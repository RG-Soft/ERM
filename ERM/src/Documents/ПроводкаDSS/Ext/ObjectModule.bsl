﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И System = "GL" Тогда
		
		ПараметрыПроведения = Документы.ПроводкаDSS.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
		
		РучнаяКорректировка = ПараметрыПроведения.СвязанныеДокументы.РучнаяКорректировка;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ManualTransactionsОстатки.AmountОстаток КАК AmountОстаток
			|ИЗ
			|	РегистрНакопления.ManualTransactions.Остатки(
			|			&ДатаТранзакции,
			|			РучнаяКорректировка = &РучнаяКорректировка
			|				И Account = &AccountLawson
			|				И AU = &AU
			|				И Company = &Company
			|				И Currency = &Currency
			|				И Location = &Location
			|				И Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
			|				И SubSubSegment = &SubSubSegment) КАК ManualTransactionsОстатки";
		
		Запрос.УстановитьПараметр("РучнаяКорректировка", РучнаяКорректировка);
		Запрос.УстановитьПараметр("AccountLawson", AccountLawson);
		Запрос.УстановитьПараметр("AU", AU);
		Запрос.УстановитьПараметр("Company", Company);
		Запрос.УстановитьПараметр("Currency", Currency);
		Запрос.УстановитьПараметр("Location", Location);
		Запрос.УстановитьПараметр("SubSubSegment", SubSubSegment);
		Запрос.УстановитьПараметр("ДатаТранзакции", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		СуммаЗадолженности = 0;
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			ВыборкаДетальныеЗаписи.Следующий();
			СуммаЗадолженности = ВыборкаДетальныеЗаписи.AmountОстаток;
		КонецЕсли;
		Если СуммаЗадолженности <= 0 И СуммаЗадолженности + TranAmount > 0 И РучнаяКорректировка.Дата <> DateLawson Тогда
			ДокОбъект = РучнаяКорректировка.ПолучитьОбъект();
			ДокОбъект.Дата = DateLawson;
			ДокОбъект.ОбменДанными.Загрузка = Истина;
			ДокОбъект.Записать();
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПараметрыПроведения = Документы.ПроводкаDSS.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	ВалютаUSD = Константы.rgsВалютаUSD.Получить();
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Реквизиты = ПараметрыПроведения.Реквизиты[0];
	
	Если Реквизиты.System = "BL" Тогда
		
		Если Реквизиты.SourceCode = "DM" ИЛИ Реквизиты.SourceCode = "CM" Тогда
			
			// Инвойс, возникает AR billed
			//// если была отдельная транзакция по sales order, то надо погасить unbilled
			//Если БылоНачислениеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы) Тогда
			//	ВыполнитьСписаниеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, ?(Реквизиты.SourceCode = "DM", Реквизиты.TranAmount, -Реквизиты.TranAmount), Отказ);
			//КонецЕсли;
			// { RGS AGorlenko 26.07.2016 13:39:56 - CM с минусом - так и должно быть. Поэтому просто берем сумму из проводки.
			//ВыполнитьНачислениеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, 
			//	Движения, ?(Реквизиты.SourceCode = "DM", Реквизиты.TranAmount, -Реквизиты.TranAmount), 
			//	?(Реквизиты.SourceCode = "DM", Реквизиты.BaseAmount, -Реквизиты.BaseAmount), Отказ);
			ВыполнитьНачислениеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, 
				Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
			// } RGS AGorlenko 26.07.2016 13:40:50 - CM с минусом - так и должно быть. Поэтому просто берем сумму из проводки.
			
		ИначеЕсли Реквизиты.SourceCode = "JE" Тогда
			
			// начисление по SalesOrder
			// { RGS TAlmazova 27.07.2016 14:31:27 - замена на признак
			//Если Реквизиты.TranAmount >= 0 Тогда
			Если Реквизиты.JeTypeLawson = "N" Тогда
				ВыполнитьНачислениеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
			ИначеЕсли Реквизиты.JeTypeLawson = "A" Тогда
				ВыполнитьСписаниеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.TranAmount, -Реквизиты.BaseAmount, Отказ);
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of JeType!",,,,Отказ);
			КонецЕсли;
			// } RGS TAlmazova 27.07.2016 14:31:38 - замена на признак
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of System and SourceCode!",,,,Отказ);
			
		КонецЕсли;
		
	ИначеЕсли Реквизиты.System = "AR" Тогда
		
		Если Реквизиты.SourceCode = "RL" ИЛИ Реквизиты.SourceCode = "RY" Тогда
			
			// разнесение платежей. Закрытие unallocated cash и billed AR
			Если Реквизиты.AccountLawson = ПланыСчетов.Lawson.TradeReceivables Тогда // 120101
				ДокументРасчетов = ?(ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice), ПараметрыПроведения.СвязанныеДокументы.Invoice, ПараметрыПроведения.СвязанныеДокументы.Memo);
				// { RGS TAlmazova 11.08.2016 16:41:21 - может не найти инвойс
				//ВалютаИнвойса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументРасчетов, "Currency");
				Если НЕ ЗначениеЗаполнено(ДокументРасчетов) И Реквизиты.BaseAmount = 0 Тогда
					ДокументРасчетов = Документы.Invoice.ПустаяСсылка();
					ВалютаИнвойса = Реквизиты.Currency;
				Иначе
					ВалютаИнвойса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументРасчетов, "Currency");
				КонецЕсли;
				// } RGS TAlmazova 11.08.2016 16:41:27 - может не найти инвойс
				//ВалютаРазнесенияПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыПроведения.СвязанныеДокументы.BatchAllocation, "Currency");
				ВалютаРазнесенияПлатежа = Реквизиты.Currency;
				Если ВалютаИнвойса = ВалютаРазнесенияПлатежа Тогда
					ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.TranAmount, -Реквизиты.BaseAmount, Истина, Отказ);
					// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
					ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы.Invoice, Движения, -Реквизиты.TranAmount, Истина, Отказ);
					// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
				ИначеЕсли ВалютаИнвойса = ВалютаUSD И ВалютаРазнесенияПлатежа <> ВалютаUSD Тогда
					ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.BaseAmount, -Реквизиты.BaseAmount, Ложь, Отказ);
					// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
					ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы.Invoice, Движения, -Реквизиты.BaseAmount, Ложь, Отказ);
					// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of of currencies!",,,,Отказ);
				КонецЕсли;
			ИначеЕсли Реквизиты.AccountLawson = ПланыСчетов.Lawson.ReceivedNotApplied ИЛИ Реквизиты.AccountLawson = ПланыСчетов.Lawson.AdvancesFromCustomers Тогда // 120102 или 209000
				Если Реквизиты.SourceCode = "RY" Тогда // разворот вешаем на последнюю оплату
					ВыполнитьСписаниеUnallocatedCashРазворот(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
				Иначе
					ВыполнитьСписаниеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
				КонецЕсли;
				// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы.CashBatch, Движения, -Реквизиты.TranAmount, Истина, Отказ);
				// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
			КонецЕсли;
			
		ИначеЕсли Реквизиты.SourceCode = "RP" ИЛИ Реквизиты.SourceCode = "RQ" ИЛИ Реквизиты.SourceCode = "RX" Тогда
			
			Если Реквизиты.AccountLawson = ПланыСчетов.Lawson.ReceivedNotApplied Тогда //120102
			
				// поступление денег от клииента. Приход в Unallocated cash. Или корректировка платежа. Корректировка unallocated cash в привязке к CashBatch
				ВыполнитьНачислениеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.TranAmount, -Реквизиты.BaseAmount, Отказ);
				// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы.CashBatch, Движения, -Реквизиты.TranAmount, Истина, Отказ);
				// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
			Иначе
				ВыполнитьНачислениеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
			КонецЕсли;
			
		ИначеЕсли Реквизиты.SourceCode = "RU" Тогда
			
			// вопрос, что делать с переоценкой
			
		ИначеЕсли Реквизиты.SourceCode = "RM" Тогда
			
			// Мемо (корректировка долга)
			ВыполнитьНачислениеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, 
				Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of System and SourceCode!",,,,Отказ);
			
		КонецЕсли;
		
	ИначеЕсли Реквизиты.System = "GL" Тогда 
		
		//Если Реквизиты.SourceCode = "JE" Тогда
			
			ВыполнитьДвиженияПоРучнымКорректировкам(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
			
		//ИначеЕсли Реквизиты.SourceCode <> "GR" Тогда // GR - переоценка остатков по счету, ее игнорируем, на другие ругаемся
		//	
		//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of System and SourceCode!",,,,Отказ);
		//	
		//КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of System and SourceCode!",,,,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеUnbilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnbilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.AccountingPeriod;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubGeoMarket = Реквизиты.SubGeoMarket;
	//НовоеДвижение.Segment = Реквизиты.Segment;
	//НовоеДвижение.SubSegment = Реквизиты.SubSegment;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
	Движения.UnbilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnbilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnbilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	НовоеДвижение.Период = Реквизиты.AccountingPeriod;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubGeoMarket = Реквизиты.SubGeoMarket;
	//НовоеДвижение.Segment = Реквизиты.Segment;
	//НовоеДвижение.SubSegment = Реквизиты.SubSegment;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
	Движения.UnbilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеBilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.BilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	//НовоеДвижение.Период = Реквизиты.DateLawson;
	НовоеДвижение.Период = Реквизиты.AccountingPeriod;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.GeoMarket = Реквизиты.GeoMarket;
	//НовоеДвижение.SubGeoMarket = Реквизиты.SubGeoMarket;
	//НовоеДвижение.Segment = Реквизиты.Segment;
	//НовоеДвижение.SubSegment = Реквизиты.SubSegment;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
	НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
	Движения.BilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеBilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, ИспользоватьВалютуТранзакции, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.BilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	//НовоеДвижение.Период = Реквизиты.DateLawson;
	НовоеДвижение.Период = Реквизиты.AccountingPeriod;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
	НовоеДвижение.Invoice = ?(ЗначениеЗаполнено(СвязанныеДокументы.Invoice), СвязанныеДокументы.Invoice, СвязанныеДокументы.Memo);
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	Если ИспользоватьВалютуТранзакции Тогда
		НовоеДвижение.Currency = Реквизиты.Currency;
	Иначе
		НовоеДвижение.Currency = Константы.rgsВалютаUSD.Получить();
	КонецЕсли;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
	Движения.BilledAR.Записывать = Истина;
	
КонецПроцедуры

Функция БылоНачислениеUnbilledAR(Реквизиты, СвязанныеДокументы)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	UnbilledARОстатки.AmountОстаток
		|ИЗ
		|	РегистрНакопления.UnbilledAR.Остатки(
		|			,
		|			Client = &Client
		|				И Company = &Company
		|				И GeoMarket = &GeoMarket
		|				И SubGeoMarket = &SubGeoMarket
		|				И Segment = &Segment
		|				И SalesOrder = &SalesOrder) КАК UnbilledARОстатки";
	
	Запрос.УстановитьПараметр("Client", Реквизиты.Client);
	Запрос.УстановитьПараметр("Company", Реквизиты.Company);
	Запрос.УстановитьПараметр("GeoMarket", Реквизиты.GeoMarket);
	Запрос.УстановитьПараметр("SalesOrder", СвязанныеДокументы.SalesOrder);
	Запрос.УстановитьПараметр("Segment", Реквизиты.Segment);
	Запрос.УстановитьПараметр("SubGeoMarket", Реквизиты.SubGeoMarket);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();
	
КонецФункции

Процедура ВыполнитьНачислениеUnallocatedCash(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	UnallocatedCashОстатки.CashBatch,
	|	UnallocatedCashОстатки.AmountОстаток,
	|	UnallocatedCashОстатки.BaseAmountОстаток
	|ИЗ
	|	РегистрНакопления.UnallocatedCash.Остатки(
	//|			&Период
	|			,
	|			Account = &Account
	|				И AU = &AU
	|				И Client = &Client
	|				И Company = &Company
	|				И Location = &Location
	|				И Source = &Source
	|				И SubSubSegment = &SubSubSegment
	|				И Currency = &Currency
	|				И CashBatch = ЗНАЧЕНИЕ(Документ.CashBatch.ПустаяСсылка)) КАК UnallocatedCashОстатки
	|ГДЕ
	|	UnallocatedCashОстатки.AmountОстаток < 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	UnallocatedCashОстатки.CashBatch.МоментВремени";
	
	//Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Account", Реквизиты.AccountLawson);
	Запрос.УстановитьПараметр("AU", Реквизиты.AU);
	Запрос.УстановитьПараметр("Client", Реквизиты.КонтрагентLawson);
	Запрос.УстановитьПараметр("Company", Реквизиты.Company);
	Запрос.УстановитьПараметр("Location", Реквизиты.Location);
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.Lawson);
	Запрос.УстановитьПараметр("SubSubSegment", Реквизиты.SubSubSegment);
	Запрос.УстановитьПараметр("Currency", Реквизиты.Currency);
	
	Результат = Запрос.Выполнить();
	
	Корректировка = 0;
	КорректировкаUSD = 0;
	
	//Если Не Результат.Пустой() И Сумма > 0  Тогда
	Если Ложь Тогда
		
		ОсталосьПрихода = Сумма;
		ОсталосьПриходаUSD = СуммаUSD;
		
		ВыборкаОстатков = Результат.Выбрать();
		
		Пока ВыборкаОстатков.Следующий() И ОсталосьПрихода > 0 Цикл
			
			НовоеДвижение = Движения.UnallocatedCash.Добавить();
			
			НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
			//НовоеДвижение.Период = Реквизиты.DateLawson;
			НовоеДвижение.Период = Реквизиты.AccountingPeriod;
			НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
			НовоеДвижение.Company = Реквизиты.Company;
			НовоеДвижение.Location = Реквизиты.Location;
			НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
			НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
			НовоеДвижение.CashBatch = ВыборкаОстатков.CashBatch;
			НовоеДвижение.Account = Реквизиты.AccountLawson;
			НовоеДвижение.AU = Реквизиты.AU;
			НовоеДвижение.Currency = Реквизиты.Currency;
			
			НовоеДвижение.Amount = ?(-ВыборкаОстатков.AmountОстаток < ОсталосьПрихода, -ВыборкаОстатков.AmountОстаток, ОсталосьПрихода);
			НовоеДвижение.BaseAmount = ?(-ВыборкаОстатков.BaseAmountОстаток < ОсталосьПриходаUSD, -ВыборкаОстатков.BaseAmountОстаток, ОсталосьПриходаUSD);;
			
			ОсталосьПрихода = ОсталосьПрихода - НовоеДвижение.Amount;
			ОсталосьПриходаUSD = ОсталосьПриходаUSD - НовоеДвижение.BaseAmount;
			
		КонецЦикла;
		
		Если ОсталосьПрихода > 0 Тогда
			
			НовоеДвижение = Движения.UnallocatedCash.Добавить();
			
			НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
			//НовоеДвижение.Период = Реквизиты.DateLawson;
			НовоеДвижение.Период = Реквизиты.AccountingPeriod;
			НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
			НовоеДвижение.Company = Реквизиты.Company;
			НовоеДвижение.Location = Реквизиты.Location;
			НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
			НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
			НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
			НовоеДвижение.Account = Реквизиты.AccountLawson;
			НовоеДвижение.AU = Реквизиты.AU;
			НовоеДвижение.Currency = Реквизиты.Currency;
			
			НовоеДвижение.Amount = ОсталосьПрихода;
			НовоеДвижение.BaseAmount = ОсталосьПриходаUSD;
			
		КонецЕсли;
		
	Иначе
		
		НовоеДвижение = Движения.UnallocatedCash.Добавить();
		
		НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
		//НовоеДвижение.Период = Реквизиты.DateLawson;
		НовоеДвижение.Период = Реквизиты.AccountingPeriod;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		НовоеДвижение.Company = Реквизиты.Company;
		НовоеДвижение.Location = Реквизиты.Location;
		НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
		НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
		НовоеДвижение.Account = Реквизиты.AccountLawson;
		НовоеДвижение.AU = Реквизиты.AU;
		НовоеДвижение.Currency = Реквизиты.Currency;
		
		НовоеДвижение.Amount = Сумма;
		НовоеДвижение.BaseAmount = СуммаUSD;
		
	КонецЕсли;
	
	
	Движения.UnallocatedCash.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnallocatedCash(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	UnallocatedCashОстатки.CashBatch,
	|	UnallocatedCashОстатки.AmountОстаток,
	|	UnallocatedCashОстатки.BaseAmountОстаток
	|ИЗ
	|	РегистрНакопления.UnallocatedCash.Остатки(
	//|			&Период
	|			,
	|			Account = &Account
	|				И AU = &AU
	|				И Client = &Client
	|				И Company = &Company
	|				И Location = &Location
	|				И Source = &Source
	|				И SubSubSegment = &SubSubSegment
	|				И Currency = &Currency) КАК UnallocatedCashОстатки
	|ГДЕ
	|	UnallocatedCashОстатки.AmountОстаток > 0
	|
	|УПОРЯДОЧИТЬ ПО
	|	UnallocatedCashОстатки.CashBatch.МоментВремени";
	
	//Запрос.УстановитьПараметр("Период", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	Запрос.УстановитьПараметр("Account", Реквизиты.AccountLawson);
	Запрос.УстановитьПараметр("AU", Реквизиты.AU);
	Запрос.УстановитьПараметр("Client", Реквизиты.КонтрагентLawson);
	Запрос.УстановитьПараметр("Company", Реквизиты.Company);
	Запрос.УстановитьПараметр("Location", Реквизиты.Location);
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.Lawson);
	Запрос.УстановитьПараметр("SubSubSegment", Реквизиты.SubSubSegment);
	Запрос.УстановитьПараметр("Currency", Реквизиты.Currency);
	
	ВыборкаОстатков = Запрос.Выполнить().Выбрать();
	
	ОсталосьСписать = Сумма;
	ОсталосьСписатьUSD = СуммаUSD;
	
	ТаблицаCashBatchAllocation = Движения.CashBatchAllocation.ВыгрузитьКолонки();
	
	Пока ВыборкаОстатков.Следующий() И (ОсталосьСписать <> 0 ИЛИ ОсталосьСписатьUSD <> 0) Цикл
		
		НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
		НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
		//НовоеДвижение.Период = Реквизиты.DateLawson;
		НовоеДвижение.Период = Реквизиты.AccountingPeriod;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		НовоеДвижение.Company = Реквизиты.Company;
		НовоеДвижение.Location = Реквизиты.Location;
		НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
		НовоеДвижение.CashBatch = ВыборкаОстатков.CashBatch;
		НовоеДвижение.Account = Реквизиты.AccountLawson;
		НовоеДвижение.AU = Реквизиты.AU;
		НовоеДвижение.Currency = Реквизиты.Currency;
		
		Если ВыборкаОстатков.AmountОстаток < 0 Тогда
			НовоеДвижение.Amount = ОсталосьСписать;
		Иначе
			НовоеДвижение.Amount = ?(ОсталосьСписать <= ВыборкаОстатков.AmountОстаток, ОсталосьСписать, ВыборкаОстатков.AmountОстаток);
		КонецЕсли;
		Если ВыборкаОстатков.BaseAmountОстаток < 0 Тогда
			НовоеДвижение.BaseAmount = ОсталосьСписатьUSD;
		Иначе
			НовоеДвижение.BaseAmount = ?(ОсталосьСписатьUSD <= ВыборкаОстатков.BaseAmountОстаток, ОсталосьСписатьUSD, ВыборкаОстатков.BaseAmountОстаток);
		КонецЕсли;
		
		ОсталосьСписать = ОсталосьСписать - НовоеДвижение.Amount;
		ОсталосьСписатьUSD = ОсталосьСписатьUSD - НовоеДвижение.BaseAmount;
		
		ДвижениеCashBatchAllocation = ТаблицаCashBatchAllocation.Добавить();
		ДвижениеCashBatchAllocation.Transaction = Ссылка;
		ДвижениеCashBatchAllocation.BatchAllocation = СвязанныеДокументы.BatchAllocation;
		ДвижениеCashBatchAllocation.CashBatch = НовоеДвижение.CashBatch;
		ДвижениеCashBatchAllocation.Amount = НовоеДвижение.Amount;
		
	КонецЦикла;
	
	Если ОсталосьСписать <> 0 ИЛИ ОсталосьСписатьUSD <> 0 Тогда
		
		НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
		НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
		//НовоеДвижение.Период = Реквизиты.DateLawson;
		НовоеДвижение.Период = Реквизиты.AccountingPeriod;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		НовоеДвижение.Company = Реквизиты.Company;
		НовоеДвижение.Location = Реквизиты.Location;
		НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
		НовоеДвижение.CashBatch = Документы.CashBatch.ПустаяСсылка();
		НовоеДвижение.Account = Реквизиты.AccountLawson;
		НовоеДвижение.AU = Реквизиты.AU;
		НовоеДвижение.Currency = Реквизиты.Currency;
		
		НовоеДвижение.Amount = ОсталосьСписать;
		НовоеДвижение.BaseAmount = ОсталосьСписатьUSD;
		
		ДвижениеCashBatchAllocation = ТаблицаCashBatchAllocation.Добавить();
		ДвижениеCashBatchAllocation.Transaction = Ссылка;
		ДвижениеCashBatchAllocation.BatchAllocation = СвязанныеДокументы.BatchAllocation;
		ДвижениеCashBatchAllocation.CashBatch = НовоеДвижение.CashBatch;
		ДвижениеCashBatchAllocation.Amount = НовоеДвижение.Amount;
		
	КонецЕсли;
	
	ТаблицаCashBatchAllocation.Свернуть("BatchAllocation, CashBatch, Transaction", "Amount");
	Движения.CashBatchAllocation.Загрузить(ТаблицаCashBatchAllocation);
	
	Движения.UnallocatedCash.Записывать = Истина;
	Движения.CashBatchAllocation.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnallocatedCashРазворот(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	UnallocatedCashОстатки.AmountОстаток,
	|	UnallocatedCashОстатки.BaseAmountОстаток
	|ИЗ
	|	РегистрНакопления.UnallocatedCash.Остатки(
	|			,
	|			Account = &Account
	|				И AU = &AU
	|				И Client = &Client
	|				И Company = &Company
	|				И Location = &Location
	|				И Source = &Source
	|				И SubSubSegment = &SubSubSegment
	|				И Currency = &Currency
	|				И CashBatch = ЗНАЧЕНИЕ(Документ.CashBatch.ПустаяСсылка)) КАК UnallocatedCashОстатки
	|ГДЕ
	|	UnallocatedCashОстатки.AmountОстаток < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	CashBatchAllocation.CashBatch
	|ИЗ
	|	РегистрСведений.CashBatchAllocation КАК CashBatchAllocation
	|ГДЕ
	|	CashBatchAllocation.BatchAllocation = &BatchAllocation
	|	И CashBatchAllocation.CashBatch <> ЗНАЧЕНИЕ(Документ.CashBatch.ПустаяСсылка)
	|
	|УПОРЯДОЧИТЬ ПО
	|	CashBatchAllocation.CashBatch.МоментВремени УБЫВ";
	
	Запрос.УстановитьПараметр("BatchAllocation", СвязанныеДокументы.BatchAllocation);
	Запрос.УстановитьПараметр("Account", Реквизиты.AccountLawson);
	Запрос.УстановитьПараметр("AU", Реквизиты.AU);
	Запрос.УстановитьПараметр("Client", Реквизиты.КонтрагентLawson);
	Запрос.УстановитьПараметр("Company", Реквизиты.Company);
	Запрос.УстановитьПараметр("Location", Реквизиты.Location);
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.Lawson);
	Запрос.УстановитьПараметр("SubSubSegment", Реквизиты.SubSubSegment);
	Запрос.УстановитьПараметр("Currency", Реквизиты.Currency);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатПоПустомуДокументу = МассивРезультатов[0];
	
	СуммаОтнестиНаПоследнийБэтч = Сумма;
	СуммаВалОтнестиНаПоследнийБэтч = СуммаUSD;
	
	Если НЕ РезультатПоПустомуДокументу.Пустой() Тогда
		
		Выборка = РезультатПоПустомуДокументу.Выбрать();
		Выборка.Следующий();
		
		СуммаОтнестиНаПустойДокумент = Мин(-Выборка.AmountОстаток, -Сумма);
		СуммаВалОтнестиНаПустойДокумент = Мин(-Выборка.BaseAmountОстаток, -СуммаUSD);
		
		НовоеДвижение = Движения.UnallocatedCash.Добавить();
		
		НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
		НовоеДвижение.Период = Реквизиты.AccountingPeriod;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		НовоеДвижение.Company = Реквизиты.Company;
		НовоеДвижение.Location = Реквизиты.Location;
		НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
		НовоеДвижение.CashBatch = документы.CashBatch.ПустаяСсылка();
		НовоеДвижение.Account = Реквизиты.AccountLawson;
		НовоеДвижение.AU = Реквизиты.AU;
		НовоеДвижение.Currency = Реквизиты.Currency;
	
		НовоеДвижение.Amount = СуммаОтнестиНаПустойДокумент;
		НовоеДвижение.BaseAmount = СуммаВалОтнестиНаПустойДокумент;
		
		СуммаОтнестиНаПоследнийБэтч = Сумма + СуммаОтнестиНаПустойДокумент;
		СуммаВалОтнестиНаПоследнийБэтч = СуммаUSD + СуммаВалОтнестиНаПустойДокумент;
		
	КонецЕсли;
	
	Если СуммаОтнестиНаПоследнийБэтч <> 0 ИЛИ СуммаВалОтнестиНаПоследнийБэтч <> 0 Тогда
		
		Результат = МассивРезультатов[1];
		
		Если Результат.Пустой() Тогда
			CashBatch = Документы.CashBatch.ПустаяСсылка();
		Иначе
			Выборка = Результат.Выбрать();
			Выборка.Следующий();
			CashBatch = Выборка.CashBatch;
		КонецЕсли;
		
		НовоеДвижение = Движения.UnallocatedCash.Добавить();

		НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
		//НовоеДвижение.Период = Реквизиты.DateLawson;
		НовоеДвижение.Период = Реквизиты.AccountingPeriod;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		НовоеДвижение.Company = Реквизиты.Company;
		НовоеДвижение.Location = Реквизиты.Location;
		НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
		НовоеДвижение.CashBatch = CashBatch;
		НовоеДвижение.Account = Реквизиты.AccountLawson;
		НовоеДвижение.AU = Реквизиты.AU;
		НовоеДвижение.Currency = Реквизиты.Currency;
		
		НовоеДвижение.Amount = СуммаОтнестиНаПоследнийБэтч;
		НовоеДвижение.BaseAmount = СуммаВалОтнестиНаПоследнийБэтч;
		
	КонецЕсли;
	
	Движения.UnallocatedCash.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвиженияПоРучнымКорректировкам(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.ManualTransactions.Добавить();
	
	НовоеДвижение.ВидДвижения = ?(Сумма > 0, ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход);
	
	НовоеДвижение.Период = Реквизиты.AccountingPeriod;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.GeoMarket = Реквизиты.GeoMarket;
	//НовоеДвижение.SubGeoMarket = Реквизиты.SubGeoMarket;
	//НовоеДвижение.Segment = Реквизиты.Segment;
	//НовоеДвижение.SubSegment = Реквизиты.SubSegment;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	//НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
	НовоеДвижение.РучнаяКорректировка = СвязанныеДокументы.РучнаяКорректировка;
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = ?(Сумма >= 0, Сумма, -Сумма);
	НовоеДвижение.BaseAmount = ?(Сумма >= 0, СуммаUSD, -СуммаUSD);
	
	Движения.ManualTransactions.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеUnallocatedMemo(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedMemo.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.AccountingPeriod;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubGeoMarket = Реквизиты.SubGeoMarket;
	//НовоеДвижение.Segment = Реквизиты.Segment;
	//НовоеДвижение.SubSegment = Реквизиты.SubSegment;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
	НовоеДвижение.Memo = СвязанныеДокументы.Memo;
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
	Движения.UnallocatedMemo.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвижениеPayments(Реквизиты, Invoice, Движения, Сумма, ИспользоватьВалютуТранзакции, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Сумма <> 0 Тогда
	
		НовоеДвижение = Движения.Payments.Добавить();
		
		НовоеДвижение.Период = Реквизиты.AccountingPeriod;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		НовоеДвижение.Company = Реквизиты.Company;
		НовоеДвижение.Location = Реквизиты.Location;
		НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
		НовоеДвижение.Invoice = Invoice;
		Если ИспользоватьВалютуТранзакции Тогда
			НовоеДвижение.Currency = Реквизиты.Currency;
		Иначе
			НовоеДвижение.Currency = Константы.rgsВалютаUSD.Получить();
		КонецЕсли;
		
		НовоеДвижение.Amount = Сумма;
		
		Движения.Payments.Записывать = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
