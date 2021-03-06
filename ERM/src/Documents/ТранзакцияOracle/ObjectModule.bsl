#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	//Если Source = Перечисления.ТипыСоответствий.OracleSmith И РежимЗаписи = РежимЗаписиДокумента.Проведение И GlSourceType = Перечисления.OracleGlSourceType.JV Тогда
	//	
	//	ПараметрыПроведения = Документы.ТранзакцияOracle.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	//	
	//	РучнаяКорректировка = ПараметрыПроведения.СвязанныеДокументы.РучнаяКорректировка;
	//	
	//	Запрос = Новый Запрос;
	//	Запрос.Текст = 
	//		"ВЫБРАТЬ
	//		|	ManualTransactionsОстатки.AmountОстаток КАК AmountОстаток
	//		|ИЗ
	//		|	РегистрНакопления.ManualTransactions.Остатки(
	//		|			&ДатаТранзакции,
	//		|			РучнаяКорректировка = &РучнаяКорректировка
	//		|				И Account = &Account
	//		|				И Company = &Company
	//		|				И Client = &Client
	//		|				И Currency = &Currency
	//		|				И Location = &Location
	//		|				И Source = &Source
	//		|				И SubSubSegment = &SubSubSegment) КАК ManualTransactionsОстатки";
	//	
	//	Запрос.УстановитьПараметр("РучнаяКорректировка", РучнаяКорректировка);
	//	Запрос.УстановитьПараметр("Account", Account);
	//	Запрос.УстановитьПараметр("Company", Company);
	//	Запрос.УстановитьПараметр("Client", Client);
	//	Запрос.УстановитьПараметр("Currency", Currency);
	//	Запрос.УстановитьПараметр("Location", Location);
	//	Запрос.УстановитьПараметр("Source", Source);
	//	Запрос.УстановитьПараметр("SubSubSegment", SubSubSegment);
	//	Запрос.УстановитьПараметр("ДатаТранзакции", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
	//	
	//	РезультатЗапроса = Запрос.Выполнить();
	//	
	//	СуммаЗадолженности = 0;
	//	Если НЕ РезультатЗапроса.Пустой() Тогда
	//		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	//		ВыборкаДетальныеЗаписи.Следующий();
	//		СуммаЗадолженности = ВыборкаДетальныеЗаписи.AmountОстаток;
	//	КонецЕсли;
	//	Если СуммаЗадолженности <= 0 И СуммаЗадолженности + Amount > 0 И РучнаяКорректировка.Дата <> Дата Тогда
	//		ДокОбъект = РучнаяКорректировка.ПолучитьОбъект();
	//		ДокОбъект.Дата = Дата;
	//		ДокОбъект.ОбменДанными.Загрузка = Истина;
	//		ДокОбъект.Записать();
	//	КонецЕсли;
	//	
	//	
	//КонецЕсли;
	
	// { RGS TAlmazova 25.07.2017 12:29:01 - пометка удаление на подчиненные документы корректировки
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорректировкаТранзакции.Ссылка
		|ИЗ
		|	Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|ГДЕ
		|	КорректировкаТранзакции.ДокументОснование = &ДокументОснование
		|	И НЕ КорректировкаТранзакции.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("ДокументОснование", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ПометкаУдаления Тогда
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			КорректировкаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			КорректировкаОбъект.УстановитьПометкуУдаления(Истина);
		КонецЦикла;
		
	ИначеЕсли РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			КорректировкаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			КорректировкаОбъект.Записать(РежимЗаписиДокумента.ОтменаПроведения);
		КонецЦикла;
		
	КонецЕсли;
	
	// } RGS TAlmazova 25.07.2017 12:29:11 - пометка удаление на подчиненные документы корректировки
	
	//Очищаем дату в DIR если распроводится проводка
	Если ПометкаУдаления ИЛИ РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда

		ПараметрыПроведения = Документы.ТранзакцияOracle.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
		ПустаяДата = Дата(1, 1, 1);
		Даты = Новый Соответствие();
			
		Если Source = Перечисления.ТипыСоответствий.OracleMI Тогда
			Даты.Вставить("JobEndDate", ПустаяДата);
			Даты.Вставить("InvoiceFlagDate", ПустаяДата);
		Иначе
			Даты.Вставить("InvoiceFlagDate", ПустаяДата);
		КонецЕсли;
		
		РегистрыСведений.DIR.ЗаписатьДаты(ПараметрыПроведения.СвязанныеДокументы.Invoice, Даты);
		
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПараметрыПроведения = Документы.ТранзакцияOracle.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	ВалютаРуб = Константы.rgsВалютаРуб.Получить();
	ВалютаUSD = Константы.rgsВалютаUSD.Получить();
	
	Реквизиты = ПараметрыПроведения.Реквизиты[0];
	
	//{ RGS AArsentev 16.02.2017 12:14:25
	Инвойс = ПараметрыПроведения.СвязанныеДокументы.Invoice;
	Если ЗначениеЗаполнено(Инвойс) Тогда
		ЗаполнитьРС_ПериодыАктивностиДоговров(Инвойс, Отказ);
	КонецЕсли;
	//} RGS AArsentev 16.02.2017 12:14:25
	
	СчетВыручкиHFM = rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня");
	
	//{ RGS TAlmazova 21.05.2018 12:14:25
	СуммыДляПроводки = Документы.ТранзакцияOracle.ПолучитьСуммыДляПроводки(Реквизиты, СчетВыручкиHFM, ВалютаUSD, Отказ);	
	//} RGS TAlmazova 21.05.2018 12:14:25
	
	Если Реквизиты.HFMAccount.ПринадлежитЭлементу(СчетВыручкиHFM) Тогда
		
//		Запрос = Новый Запрос;
//		Запрос.Текст = 
//			"ВЫБРАТЬ
//			|	НастройкиОтображенияВалютнойСуммыВОтчетах.ИспользоватьUSDСуммуИзТранзакции
//			|ИЗ
//			|	РегистрСведений.НастройкиОтображенияВалютнойСуммыВОтчетах КАК НастройкиОтображенияВалютнойСуммыВОтчетах
//			|ГДЕ
//			|	НастройкиОтображенияВалютнойСуммыВОтчетах.Source = &Source
//			|	И НастройкиОтображенияВалютнойСуммыВОтчетах.Company = &Company
//			|	И НастройкиОтображенияВалютнойСуммыВОтчетах.TypeAccount = &TypeAccount
//			|	И НастройкиОтображенияВалютнойСуммыВОтчетах.ИспользоватьUSDСуммуИзТранзакции";
//		
//		Запрос.УстановитьПараметр("Company", Реквизиты.Company);
//		Запрос.УстановитьПараметр("Source", Реквизиты.Source);
//		Запрос.УстановитьПараметр("TypeAccount", Перечисления.ТипСчета.Revenue);
//		
//		РезультатЗапроса = Запрос.Выполнить();
//		
//		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
//		
//		// { RGS TAlmazova 13.04.2018 17:12:47 - используется в двух местах, вытащила в начало
//		СтруктураКурсаВалюты = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(Реквизиты.Currency, Реквизиты.Дата);
//		Если Не ЗначениеЗаполнено(СтруктураКурсаВалюты.Курс) Тогда
//			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("No exchange rate " + Реквизиты.Currency, , , , Отказ);
//			Возврат;
//		КонецЕсли;
//		// } RGS TAlmazova 13.04.2018 17:13:13 - используется в двух местах, вытащила в начало
//		
//		Если ВыборкаДетальныеЗаписи.Количество() > 0 ИЛИ Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
//			СуммаUSD = Реквизиты.BaseAmount;
//		ИначеЕсли Реквизиты.Currency = ВалютаUSD Тогда
//			СуммаUSD = Реквизиты.Amount;
//		Иначе
//			СуммаUSD = Реквизиты.Amount / СтруктураКурсаВалюты.Курс * ?(СтруктураКурсаВалюты.Кратность = 0, 1, СтруктураКурсаВалюты.Кратность);
//		КонецЕсли;
//		// { RGS TAlmazova 13.04.2018 17:05:50 - для смитов пересчитываем сумму в валюте транзакции из суммы USD
//		Если Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
//			Если Реквизиты.Currency = ВалютаUSD Тогда
//				СуммаТранзакции = СуммаUSD;
//			Иначе
//				СуммаТранзакции = СуммаUSD * СтруктураКурсаВалюты.Курс / ?(СтруктураКурсаВалюты.Кратность = 0, 1, СтруктураКурсаВалюты.Кратность);
//			КонецЕсли;
//		Иначе
//			СуммаТранзакции = Реквизиты.Amount;
//		КонецЕсли;
		// } RGS TAlmazova 13.04.2018 17:06:12 - для смитов пересчитываем сумму в валюте транзакции из суммы USD
		ВыполнитьДвижениеRevenue(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
		
	Иначе
	
		Если Реквизиты.Amount <> 0 или Реквизиты.BaseAmount <> 0 Тогда
		
			// { RGS TAlmazova 07.10.2016 13:23:59 - добавление условия на GlSourceType
			Если Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.SAMAccrual ИЛИ Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.SOAccrual Тогда
				
				Если Реквизиты.DocType = "Accrual" И Реквизиты.TransType = "A" Тогда
					
					ВыполнитьНачислениеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
					
				ИначеЕсли Реквизиты.DocType = "Accrual" И Реквизиты.TransType = "R" Тогда
					
					ВыполнитьСписаниеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected parameters!", , , , Отказ);
				КонецЕсли;
				
			ИначеЕсли Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.JV Тогда
				//ИначеЕсли Реквизиты.DocType = "JV" Тогда
				
				ВыполнитьДвиженияПоРучнымКорректировкам(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
				
			ИначеЕсли Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.Receivables Тогда
				
				Если Реквизиты.DocType = "INV" ИЛИ Реквизиты.DocType = "DEP" ИЛИ Реквизиты.DocType = "GUAR"
					ИЛИ Реквизиты.DocType = "PMT" ИЛИ Реквизиты.DocType = "CB" ИЛИ (Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith И (Реквизиты.DocType = "Sales Invoices" ИЛИ Реквизиты.DocType = "Adjustment")) Тогда
					
					ВыполнитьНачислениеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
					
					// { RGS TAlmazova 30.07.2018 10:13:57 - S-E-0000619
					Если ((Реквизиты.Source = Перечисления.ТипыСоответствий.OracleMI 
							И Реквизиты.DocType = "INV" И Реквизиты.TransType = "INV_REC" И ЗначениеЗаполнено(Реквизиты.SONum))
						ИЛИ (Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith И Реквизиты.DocType = "Sales Invoices")) 
						И  Реквизиты.Major = "1101" И ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice) 
						И СуммыДляПроводки.Amount > 0 Тогда
						ВыполнитьДвижениеInvoicedDebts(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, 
							Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
						Если Реквизиты.Source = Перечисления.ТипыСоответствий.OracleMI Тогда
							ЗаполнитьДатыВDIR_MI(ПараметрыПроведения.СвязанныеДокументы.Invoice);
						Иначе
							ЗаполнитьДатыВDIR_SMITH(ПараметрыПроведения.СвязанныеДокументы.Invoice);
						КонецЕсли;
					КонецЕсли
					// } RGS TAlmazova 30.07.2018 10:14:36 - S-E-0000619
					
				ИначеЕсли Реквизиты.DocType = "CASH"
					И (Реквизиты.TransType = "TRADE_UNID" ИЛИ Реквизиты.TransType = "CCURR_UNAPP" ИЛИ Реквизиты.TransType = "TRADE_UNAPP" ИЛИ Реквизиты.TransType = "TRADE_ACC") Тогда
					
					ВыполнитьНачислениеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
					// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
					ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Истина, Отказ);
					// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
					
				ИначеЕсли Реквизиты.DocType = "CASH"
					И (Реквизиты.TransType = "CCURR_REC" ИЛИ Реквизиты.TransType = "TRADE_REC") ИЛИ (Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith И (Реквизиты.DocType = "Trade Receipts" ИЛИ Реквизиты.DocType = "Cross Currency"))  Тогда // разнесение платежей
					
					// { RGS TAlmazova 08.04.2018 23:09:24 - для случая, когда и мемо и инвойс есть (в Оракле)
					Если ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice) И  ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Memo) Тогда
						ДокументРасчетов = ОпределитьДокументРасчетов(Реквизиты, ПараметрыПроведения.СвязанныеДокументы);
					Иначе
					// } RGS TAlmazova 08.04.2018 23:09:48 - для случая, когда и мемо и инвойс есть (в Оракле)
						ДокументРасчетов = ?(ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice), ПараметрыПроведения.СвязанныеДокументы.Invoice, ПараметрыПроведения.СвязанныеДокументы.Memo);
					// { RGS TAlmazova 08.04.2018 23:09:24 - для случая, когда и мемо и инвойс есть (в Оракле)
					КонецЕсли;
					// } RGS TAlmazova 08.04.2018 23:09:48 - для случая, когда и мемо и инвойс есть (в Оракле)
					Если НЕ ЗначениеЗаполнено(ДокументРасчетов) И Реквизиты.Amount = 0 Тогда
						ДокументРасчетов = Документы.Invoice.ПустаяСсылка();
						ВалютаИнвойса = Реквизиты.Currency;
					Иначе
						ВалютаИнвойса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументРасчетов, "Currency");
					КонецЕсли;
					ВалютаПлатежа = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПараметрыПроведения.СвязанныеДокументы.CashBatch, "Currency");
					ВалютаРазнесенияПлатежа = Реквизиты.Currency;
					
					//Если ВалютаРазнесенияПлатежа = ВалютаПлатежа Тогда
					//	ВыполнитьСписаниеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, -Реквизиты.BaseAmount, Истина, Отказ);
					//ИначеЕсли ВалютаПлатежа = ВалютаРуб Тогда
					//	ВыполнитьСписаниеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.BaseAmount, -Реквизиты.BaseAmount, Ложь, Отказ);
					//Иначе
					//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of of currencies!",,,,Отказ);
					//КонецЕсли;
					
					Если ВалютаРазнесенияПлатежа = ВалютаИнвойса Тогда
						Если ТипЗнч(ДокументРасчетов) = Тип("ДокументСсылка.Invoice") Тогда
							ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
						Иначе
							ВыполнитьСписаниеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
						КонецЕсли;
						// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
						ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Ложь, Отказ);
						// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
					Иначе
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of of currencies!",,,,Отказ);
					КонецЕсли;
					
				ИначеЕсли Реквизиты.DocType = "CM" И Реквизиты.TransType = "CM_REC" ИЛИ Реквизиты.DocType = "DM" И Реквизиты.TransType = "DM_REC" ИЛИ (Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith И Реквизиты.DocType = "Credit Memos") Тогда
					
					ВыполнитьНачислениеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
					
				ИначеЕсли Реквизиты.DocType = "CM" И Реквизиты.TransType = "CMAPP_REC" ИЛИ (Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith И Реквизиты.DocType = "Credit Memo Applications") Тогда
					
					Если Реквизиты.Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
						Если Реквизиты.Amount >= 0 Тогда
							ВыполнитьСписаниеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
						Иначе
							ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
							
							// { RGS TAlmazova 27.08.2018 12:35:06 - 
							//Если Сред(Реквизиты.DocID, 3, 7) = Сред(Реквизиты.LineID, 3, 7) ИЛИ Сред(Реквизиты.DocID, 1, 7) = Сред(Реквизиты.LineID, 3, 7) Тогда
							ВыполнитьДвижениеInvoicedDebts(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, 
								Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
							//КонецЕсли;
							// { RGS TAlmazova 27.08.2018 12:35:06 - 
							
						КонецЕсли;
					Иначе
						// { RGS TAlmazova 13.10.2016 12:35:06 - 
						//Если Реквизиты.Amount > 0 Тогда
						// { RGS TAlmazova 08.04.2018 23:09:24 - для случая, когда и мемо и инвойс есть (в Оракле)
						Если ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice) И  ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Memo) Тогда
							ДокументРасчетов = ОпределитьДокументРасчетов(Реквизиты, ПараметрыПроведения.СвязанныеДокументы);
						Иначе
						// } RGS TAlmazova 08.04.2018 23:09:48 - для случая, когда и мемо и инвойс есть (в Оракле)
							ДокументРасчетов = ?(ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice), ПараметрыПроведения.СвязанныеДокументы.Invoice, ПараметрыПроведения.СвязанныеДокументы.Memo);
						// { RGS TAlmazova 08.04.2018 23:09:24 - для случая, когда и мемо и инвойс есть (в Оракле)
						КонецЕсли;
						// } RGS TAlmazova 08.04.2018 23:09:48 - для случая, когда и мемо и инвойс есть (в Оракле)
						Если ТипЗнч(ДокументРасчетов) = Тип("ДокументСсылка.Memo") Тогда
						// } RGS TAlmazova 13.10.2016 12:35:07 - 
							ВыполнитьСписаниеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
						Иначе
							ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
							// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
							//ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы.Invoice, Движения, -Реквизиты.Amount, Отказ);
							// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
						КонецЕсли;
					КонецЕсли;
					
				ИначеЕсли Реквизиты.DocType = "DM" И Реквизиты.TransType = "DMAPP_REC" Тогда
					
					Если Реквизиты.Amount < 0 Тогда
						ВыполнитьСписаниеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
					Иначе
						ВыполнитьНачислениеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
					КонецЕсли;
				ИначеЕсли Реквизиты.DocType = "CM" И Реквизиты.TransType = "CM_REV" Тогда
					//временно проводки по TransType CM_REV	проводим без движений, так как это перенос казахов, разовая операция
				Иначе
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected parameters!", , , , Отказ);
				КонецЕсли;
			// } RGS TAlmazova 07.10.2016 13:23:59 - добавление условия на GlSourceType
			Иначе
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected parameters!", , , , Отказ);
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеUnbilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnbilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.Account;
	//НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnbilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnbilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnbilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.Account;
	//НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnbilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвиженияПоРучнымКорректировкам(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.ManualTransactions.Добавить();
	
	//НовоеДвижение.ВидДвижения = ?(Сумма > 0, ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход);
	Если Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
		НовоеДвижение.ВидДвижения = ?(Reverse, ВидДвиженияНакопления.Расход, ВидДвиженияНакопления.Приход);
		НовоеДвижение.Amount = ?(Reverse, -Сумма, Сумма);
		НовоеДвижение.BaseAmount = ?(Reverse, -СуммаФВ, СуммаФВ);
		
	Иначе
		НовоеДвижение.ВидДвижения = ?(TransType = "R", ВидДвиженияНакопления.Расход, ВидДвиженияНакопления.Приход);
		НовоеДвижение.Amount = ?(TransType = "R", -Сумма, Сумма);
		НовоеДвижение.BaseAmount = ?(TransType = "R", -СуммаФВ, СуммаФВ);
	КонецЕсли;
	
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.РучнаяКорректировка = СвязанныеДокументы.РучнаяКорректировка;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	//НовоеДвижение.Amount = ?(Сумма >= 0, Сумма, -Сумма);
	//НовоеДвижение.BaseAmount = ?(Сумма >= 0, СуммаФВ, -СуммаФВ);
	
	Движения.ManualTransactions.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеBilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.BilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.BilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеBilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.BilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.Invoice = ?(ЗначениеЗаполнено(СвязанныеДокументы.Invoice), СвязанныеДокументы.Invoice, СвязанныеДокументы.Memo);
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.BilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеUnallocatedCash(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedCash.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnallocatedCash(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, ИспользоватьВалютуТранзакции, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.Account;
	Если ИспользоватьВалютуТранзакции Тогда
		НовоеДвижение.Currency = Реквизиты.Currency;
	Иначе
		НовоеДвижение.Currency = Константы.rgsВалютаРуб.Получить();
	КонецЕсли;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedCash.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеUnallocatedMemo(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedMemo.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.Memo = СвязанныеДокументы.Memo;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedMemo.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnallocatedMemo(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedMemo.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	НовоеДвижение.Memo = СвязанныеДокументы.Memo;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedMemo.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвижениеPayments(Реквизиты, СвязанныеДокументы, Движения, Сумма, ЗаписыватьТолькоБэч, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Сумма <> 0 Тогда
	
		НовоеДвижение = Движения.Payments.Добавить();
		
		НовоеДвижение.Период = Реквизиты.Дата;
		НовоеДвижение.Source = Реквизиты.Source;
		НовоеДвижение.Company = Реквизиты.Company;
		//НовоеДвижение.Location = Реквизиты.Location;
		//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.AU = Реквизиты.AU;
		НовоеДвижение.Client = Реквизиты.Client;
		Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
			НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
		КонецЕсли;
		НовоеДвижение.Account = Реквизиты.Account;
		Если ЗаписыватьТолькоБэч Тогда
			НовоеДвижение.Invoice = Документы.Invoice.ПустаяСсылка();
		Иначе
			НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
		КонецЕсли;
		НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
		НовоеДвижение.Currency = Реквизиты.Currency;
		
		НовоеДвижение.Amount = Сумма;
		
		Движения.Payments.Записывать = Истина;
	
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьДвижениеRevenue(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.Revenue.Добавить();
	
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	
	Если Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.SAMAccrual ИЛИ Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.SOAccrual Тогда
		НовоеДвижение.Document = СвязанныеДокументы.SalesOrder;
	ИначеЕсли Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.JV Тогда
		НовоеДвижение.Document = СвязанныеДокументы.РучнаяКорректировка;
	ИначеЕсли Реквизиты.GlSourceType = Перечисления.OracleGlSourceType.Receivables Тогда
		НовоеДвижение.Document = ?(ЗначениеЗаполнено(СвязанныеДокументы.Invoice), СвязанныеДокументы.Invoice, СвязанныеДокументы.Memo);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Filed to determine revenue document!", , , , Отказ);
	КонецЕсли;
	
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.Revenue.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвижениеInvoicedDebts(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаUSD, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.InvoicedDebts.Добавить();
	
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Реквизиты.Source;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Client = Реквизиты.Client;
	Если НЕ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Реквизиты.Client, "Предопределенный") Тогда
		НовоеДвижение.ClientID = Реквизиты.CustomerNumber;
	КонецЕсли;
	
	НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
	
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаUSD;
	
	Движения.InvoicedDebts.Записывать = Истина;
	
	Даты = Новый Соответствие();
	Даты.Вставить("ПериодДействия",НачалоМесяца(НовоеДвижение.Период));
	РегистрыСведений.DIR.ЗаписатьДаты(Ссылка, Даты);
	
КонецПроцедуры

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	
	Если Source = Перечисления.ТипыСоответствий.OracleMI Тогда
		Префикс = "MI-";
	ИначеЕсли Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
		Префикс = "SM-";
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
КонецПроцедуры

Процедура ЗаполнитьРС_ПериодыАктивностиДоговров(Инвойс,Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.ПериодыАктивностиДоговоров.Добавить();
	НовоеДвижение.Инвойс = Инвойс;
	НовоеДвижение.Период = Дата;
	НовоеДвижение.Транзакция = Ссылка;
	Движения.ПериодыАктивностиДоговоров.Записывать = Истина;
	
КонецПроцедуры

Функция ОпределитьДокументРасчетов(Реквизиты, СвязанныеДокументы)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	BilledARОбороты.Invoice КАК ДокументРасчетов
		|ИЗ
		|	РегистрНакопления.BilledAR.Обороты(, , , Invoice = &Memo) КАК BilledARОбороты
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	UnallocatedMemoОбороты.Memo
		|ИЗ
		|	РегистрНакопления.UnallocatedMemo.Обороты(, , , Memo = &Memo) КАК UnallocatedMemoОбороты";
	
	Запрос.УстановитьПараметр("Memo", СвязанныеДокументы.Memo);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		 ВыборкаДетальныеЗаписи.Следующий();
		 ДокументРасчетов = ВыборкаДетальныеЗаписи.ДокументРасчетов;
	Иначе
		 ДокументРасчетов = СвязанныеДокументы.Invoice;
	КонецЕсли;
	
	Возврат ДокументРасчетов;
	
КонецФункции

Процедура ЗаполнитьДатыВDIR_MI(Invoice)

	Даты = Новый Соответствие();
	Даты.Вставить("JobEndDate", ShipDateActual);
	Даты.Вставить("InvoiceFlagDate", CreationDate);
	РегистрыСведений.DIR.ЗаписатьДаты(Invoice, Даты);
	
КонецПроцедуры

Процедура ЗаполнитьДатыВDIR_SMITH(Invoice)

	Даты = Новый Соответствие();
	Даты.Вставить("InvoiceFlagDate", PostingDate);
	РегистрыСведений.DIR.ЗаписатьДаты(Invoice, Даты);
	
КонецПроцедуры

#КонецЕсли

