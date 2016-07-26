﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
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
			Если Реквизиты.TranAmount >= 0 Тогда
				ВыполнитьНачислениеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
			Иначе
				ВыполнитьСписаниеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.TranAmount, -Реквизиты.BaseAmount, Отказ);
			КонецЕсли;
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of System and SourceCode!",,,,Отказ);
			
		КонецЕсли;
		
	ИначеЕсли Реквизиты.System = "AR" Тогда
		
		Если Реквизиты.SourceCode = "RL" ИЛИ Реквизиты.SourceCode = "RY" Тогда
			
			// разнесение платежей. Закрытие unallocated cash и billed AR
			Если Реквизиты.AccountLawson = ПланыСчетов.Lawson.TradeReceivables Тогда // 120101
				ДокументРасчетов = ?(ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice), ПараметрыПроведения.СвязанныеДокументы.Invoice, ПараметрыПроведения.СвязанныеДокументы.Memo);
				ВалютаИнвойса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументРасчетов, "Currency");
				//ВалютаРазнесенияПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыПроведения.СвязанныеДокументы.BatchAllocation, "Currency");
				ВалютаРазнесенияПлатежа = Реквизиты.Currency;
				Если ВалютаИнвойса = ВалютаРазнесенияПлатежа Тогда
					ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.TranAmount, -Реквизиты.BaseAmount, Истина, Отказ);
				ИначеЕсли ВалютаИнвойса = ВалютаUSD И ВалютаРазнесенияПлатежа <> ВалютаUSD Тогда
					ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.BaseAmount, -Реквизиты.BaseAmount, Ложь, Отказ);
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of of currencies!",,,,Отказ);
				КонецЕсли;
			ИначеЕсли Реквизиты.AccountLawson = ПланыСчетов.Lawson.ReceivedNotApplied Тогда // 120102
				ВыполнитьСписаниеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.TranAmount, Реквизиты.BaseAmount, Отказ);
			КонецЕсли;
			
		ИначеЕсли Реквизиты.SourceCode = "RP" ИЛИ Реквизиты.SourceCode = "RQ" Тогда
			
			// поступление денег от клииента. Приход в Unallocated cash. Или корректировка платежа. Корректировка unallocated cash в привязке к CashBatch
			ВыполнитьНачислениеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.TranAmount, -Реквизиты.BaseAmount, Отказ);
			
		ИначеЕсли Реквизиты.SourceCode = "RU" ИЛИ Реквизиты.SourceCode = "RX" Тогда
			
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
	
	НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
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
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
	Движения.UnallocatedCash.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnallocatedCash(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
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
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.AccountLawson;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
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
	НовоеДвижение.Client = Реквизиты.КонтрагентLawson;
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
