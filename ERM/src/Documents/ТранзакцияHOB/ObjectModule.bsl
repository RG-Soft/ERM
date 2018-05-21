
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	1
	|ИЗ
	|	Документ.ТранзакцияHOB КАК ТранзакцияHOB
	|ГДЕ
	|	ТранзакцияHOB.TrID = &TrID
	|	И ТранзакцияHOB.Ссылка <> &Ссылка";
	Запрос.УстановитьПараметр("TrID", TrID);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("TrID " + TrID + " is not unique!", , , , Отказ);
	КонецЕсли;
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение И TransactionType = Перечисления.HOBTransactionType.JV Тогда
		
		ПараметрыПроведения = Документы.ТранзакцияHOB.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
		
		РучнаяКорректировка = ПараметрыПроведения.СвязанныеДокументы.РучнаяКорректировка;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ManualTransactionsОстатки.AmountОстаток КАК AmountОстаток
			|ИЗ
			|	РегистрНакопления.ManualTransactions.Остатки(
			|			&ДатаТранзакции,
			|			РучнаяКорректировка = &РучнаяКорректировка
			|				И Account = &Account
			|				И Company = &Company
			|				И Currency = &Currency
			|				И AU = &AU
			|				И Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.HOBs)) КАК ManualTransactionsОстатки";
		
		Запрос.УстановитьПараметр("РучнаяКорректировка", РучнаяКорректировка);
		Запрос.УстановитьПараметр("Account", Account);
		Запрос.УстановитьПараметр("Company", Company);
		Запрос.УстановитьПараметр("Currency", Currency);
		Запрос.УстановитьПараметр("AU", AU);
		Запрос.УстановитьПараметр("ДатаТранзакции", Новый Граница(МоментВремени(), ВидГраницы.Исключая));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		СуммаЗадолженности = 0;
		Если НЕ РезультатЗапроса.Пустой() Тогда
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			ВыборкаДетальныеЗаписи.Следующий();
			СуммаЗадолженности = ВыборкаДетальныеЗаписи.AmountОстаток;
		КонецЕсли;
		Если СуммаЗадолженности <= 0 И СуммаЗадолженности + Amount > 0 И РучнаяКорректировка.Дата <> Дата Тогда
			ДокОбъект = РучнаяКорректировка.ПолучитьОбъект();
			ДокОбъект.Дата = Дата;
			ДокОбъект.ОбменДанными.Загрузка = Истина;
			ДокОбъект.Записать();
		КонецЕсли;
		
		
	КонецЕсли;
	
	// { RGS TAlmazova 25.07.2017 12:29:01 - пометка удаление на подчиненные документы корректировки
	РедактироватьКорректировку = Истина;
	Если ДополнительныеСвойства.Свойство("РедактироватьКорректировку") Тогда
		РедактироватьКорректировку = ДополнительныеСвойства.РедактироватьКорректировку;
	КонецЕсли;
		//ДополнительныеСвойства.Свойство("РедактироватьКорректировку", РедактироватьКорректировку);
	
	Если РедактироватьКорректировку Тогда
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
		
	КонецЕсли;
	// } RGS TAlmazova 25.07.2017 12:29:11 - пометка удаление на подчиненные документы корректировки
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПараметрыПроведения = Документы.ТранзакцияHOB.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
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
	СуммыДляПроводки = Документы.ТранзакцияHOB.ПолучитьСуммыДляПроводки(Реквизиты, СчетВыручкиHFM, Отказ);	
	//} RGS TAlmazova 21.05.2018 12:14:25
	
	Если Реквизиты.HFMAccount.ПринадлежитЭлементу(СчетВыручкиHFM) Тогда
		
//		Если Реквизиты.Currency = ВалютаUSD Тогда
//			СуммаUSD = Реквизиты.Amount;
//		Иначе
//			СтруктураКурсаВалюты = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(Реквизиты.Currency, Реквизиты.Дата);
//			Если Не ЗначениеЗаполнено(СтруктураКурсаВалюты.Курс) Тогда
//				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("No exchange rate " + Реквизиты.Currency, , , , Отказ);
//				Возврат;
//			КонецЕсли;
//			СуммаUSD = Реквизиты.Amount / СтруктураКурсаВалюты.Курс * ?(СтруктураКурсаВалюты.Кратность = 0, 1, СтруктураКурсаВалюты.Кратность);
//		КонецЕсли;
		ВыполнитьДвижениеRevenue(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
		
	Иначе
	
		Если Реквизиты.TransactionType = Перечисления.HOBTransactionType.Accrual Тогда
			
			Если НЕ Реквизиты.Reverse Тогда
				ВыполнитьНачислениеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
			Иначе
				ВыполнитьСписаниеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
			КонецЕсли;
			
		ИначеЕсли Реквизиты.TransactionType = Перечисления.HOBTransactionType.JV Тогда
			
			ВыполнитьДвиженияПоРучнымКорректировкам(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
			
		ИначеЕсли Реквизиты.TransactionType = Перечисления.HOBTransactionType.Receivables Тогда
			
			//Если Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.КорректировкаДолга И Реквизиты.HOBInvoiceType <> Перечисления.HOBDocumentTypes.ПлетежноеПоручениеИсходящее Тогда
			//	
			//	ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, Истина, Ложь, Отказ);
			//	
			//КонецЕсли;
			
			Если Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПлатежноеПоручениеВходящее Тогда
				
				ВыполнитьНачислениеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
				// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Истина, Истина, Отказ);
				// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
				
			//ИначеЕсли Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.ПлатежноеПоручениеВходящее Тогда
			ИначеЕсли Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.ПлатежноеПоручениеВходящее
					ИЛИ Реквизиты.HOBReverseType = Перечисления.HOBDocumentTypes.ПлатежноеПоручениеВходящее Тогда
				
				ВыполнитьНачислениеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
				ВыполнитьСписаниеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -СуммыДляПроводки.BaseAmount, Отказ);
				// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Истина, Истина, Отказ);
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, Истина, Истина, Отказ);
				// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
				
				//ДокументРасчетов = ?(ЗначениеЗаполнено(ПараметрыПроведения.СвязанныеДокументы.Invoice), ПараметрыПроведения.СвязанныеДокументы.Invoice, ПараметрыПроведения.СвязанныеДокументы.Memo);
				//Если НЕ ЗначениеЗаполнено(ДокументРасчетов) И Реквизиты.Amount = 0 Тогда
				//	ДокументРасчетов = Документы.Invoice.ПустаяСсылка();
				//	ВалютаИнвойса = Реквизиты.Currency;
				//Иначе
				//	ВалютаИнвойса = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДокументРасчетов, "Currency");
				//КонецЕсли;
				//ВалютаРазнесенияПлатежа = Реквизиты.Currency;
				
				//Если ВалютаРазнесенияПлатежа = ВалютаИнвойса Тогда
				ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, -Реквизиты.СуммыДляПроводки, Истина, Отказ);
				// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Истина, Ложь, Отказ);
				// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
				//Иначе
				//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of of currencies!",,,,Отказ);
				//КонецЕсли;
				
			//ИначеЕсли Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.КорректировкаДолга ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПлетежноеПоручениеИсходящее Тогда
			//	
			//	ВыполнитьНачислениеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.Amount, Реквизиты.BaseAmount, Отказ);
			ИначеЕсли Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.КорректировкаДолга Тогда
				
				ВыполнитьНачислениеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Истина, Ложь, Отказ);
				
				
			ИначеЕсли Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПлетежноеПоручениеИсходящее Тогда
				
				ВыполнитьНачислениеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
				
			ИначеЕсли Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.АктОбОказанииПроизводственныхУслуг
				ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.КорректировкаРеализации
				ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.РеализацияТоваровУслуг
				ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПередачаОС
				ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.РеализацияУслугПоПереработке
				ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПрочиеЗатраты Тогда
				
				ВыполнитьНачислениеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, СуммыДляПроводки.Amount, СуммыДляПроводки.BaseAmount, Отказ);
				
				Если (Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.Сторно И Реквизиты.HOBReverseType = Перечисления.HOBDocumentTypes.КорректировкаДолга) 
					ИЛИ Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.КорректировкаДолга
					ИЛИ Лев(Реквизиты.CorAccount,6) = "209000" Тогда 
				
					ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Истина, Ложь, Отказ);
				
				КонецЕсли;
				
				Если (Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.Операция ИЛИ Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.КорректировкаЗаписейРегистров)
					И Реквизиты.CorAccount = "201100.1" Тогда
				
					ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -СуммыДляПроводки.Amount, Истина, Ложь, Отказ);
				
				КонецЕсли;
				
			Иначе
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected parameters!", , , , Отказ);
				
			КонецЕсли;
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected parameters!", , , , Отказ);
			
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
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
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
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnbilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвиженияПоРучнымКорректировкам(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.ManualTransactions.Добавить();
	
	НовоеДвижение.ВидДвижения = ?(Сумма > 0, ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход);
	
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.РучнаяКорректировка = СвязанныеДокументы.РучнаяКорректировка;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
	
	НовоеДвижение.Amount = ?(Сумма >= 0, Сумма, -Сумма);
	НовоеДвижение.BaseAmount = ?(Сумма >= 0, СуммаФВ, -СуммаФВ);
	
	Движения.ManualTransactions.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеUnallocatedCash(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedCash.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеUnallocatedCash(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedCash.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedCash.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеBilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.BilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.BilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьСписаниеBilledAR(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, ИспользоватьВалютуТранзакции, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.BilledAR.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Расход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.Invoice = ?(ЗначениеЗаполнено(СвязанныеДокументы.Invoice), СвязанныеДокументы.Invoice, СвязанныеДокументы.Memo);
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	Если ИспользоватьВалютуТранзакции Тогда
		НовоеДвижение.Currency = Реквизиты.Currency;
	Иначе
		НовоеДвижение.Currency = Константы.rgsВалютаUSD.Получить();
	КонецЕсли;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.BilledAR.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьНачислениеUnallocatedMemo(Реквизиты, СвязанныеДокументы, Движения, Сумма, СуммаФВ, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	НовоеДвижение = Движения.UnallocatedMemo.Добавить();
	
	НовоеДвижение.ВидДвижения = ВидДвиженияНакопления.Приход;
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	//НовоеДвижение.Location = Реквизиты.Location;
	//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.Memo = СвязанныеДокументы.Memo;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	//{RGS AArsentev 18.01.2017
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	//}RGS AArsentev 18.01.2017
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedMemo.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвижениеPayments(Реквизиты, СвязанныеДокументы, Движения, Сумма, ИспользоватьВалютуТранзакции, ЗаписыватьТолькоБэч, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Сумма <> 0 Тогда
	
		НовоеДвижение = Движения.Payments.Добавить();
		
		НовоеДвижение.Период = Реквизиты.Дата;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
		НовоеДвижение.Company = Реквизиты.Company;
		//НовоеДвижение.Location = Реквизиты.Location;
		//НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.Client;
		НовоеДвижение.AU = Реквизиты.AU;
		НовоеДвижение.Account = Реквизиты.Account;
		Если ЗаписыватьТолькоБэч Тогда
			НовоеДвижение.Invoice = Документы.Invoice.ПустаяСсылка();
		Иначе
			Если ЗначениеЗаполнено(СвязанныеДокументы.Invoice) Тогда
				НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
			Иначе
				НовоеДвижение.Invoice = СвязанныеДокументы.Memo;
			КонецЕсли;
		КонецЕсли;
		НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
		Если ИспользоватьВалютуТранзакции Тогда
			НовоеДвижение.Currency = Реквизиты.Currency;
		Иначе
			НовоеДвижение.Currency = Константы.rgsВалютаUSD.Получить();
		КонецЕсли;
		//{RGS AArsentev 18.01.2017
		НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
		//}RGS AArsentev 18.01.2017
		
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
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Client = Реквизиты.Client;
	
	Если Реквизиты.TransactionType = Перечисления.HOBTransactionType.Accrual Тогда
		НовоеДвижение.Document = СвязанныеДокументы.SalesOrder;
	ИначеЕсли Реквизиты.TransactionType = Перечисления.HOBTransactionType.JV Тогда
		НовоеДвижение.Document = СвязанныеДокументы.РучнаяКорректировка;
	ИначеЕсли Реквизиты.TransactionType = Перечисления.HOBTransactionType.Receivables Тогда
		НовоеДвижение.Document = ?(ЗначениеЗаполнено(СвязанныеДокументы.Invoice), СвязанныеДокументы.Invoice, СвязанныеДокументы.Memo);
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Filed to determine revenue document!", , , , Отказ);
	КонецЕсли;
	
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	НовоеДвижение.LegalEntity = Реквизиты.LegalEntity;
	Если ЗначениеЗаполнено(Реквизиты.MNGC) Тогда
		НовоеДвижение.Location = Реквизиты.MNGC;
	КонецЕсли;
	Если ЗначениеЗаполнено(Реквизиты.EndClient) Тогда
		НовоеДвижение.EndClient = Реквизиты.EndClient;
	КонецЕсли;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.Revenue.Записывать = Истина;
	
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