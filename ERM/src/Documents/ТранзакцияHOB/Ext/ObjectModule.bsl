﻿
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
			|				И Location = &Location
			|				И Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.HOBs)
			|				И SubSubSegment = &SubSubSegment) КАК ManualTransactionsОстатки";
		
		Запрос.УстановитьПараметр("РучнаяКорректировка", РучнаяКорректировка);
		Запрос.УстановитьПараметр("Account", Account);
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
		Если СуммаЗадолженности <= 0 И СуммаЗадолженности + Amount > 0 И РучнаяКорректировка.Дата <> Дата Тогда
			ДокОбъект = РучнаяКорректировка.ПолучитьОбъект();
			ДокОбъект.Дата = Дата;
			ДокОбъект.ОбменДанными.Загрузка = Истина;
			ДокОбъект.Записать();
		КонецЕсли;
		
		
	КонецЕсли;
	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ПараметрыПроведения = Документы.ТранзакцияHOB.ПодготовитьПараметрыПроведения(Ссылка, Отказ);
	
	Реквизиты = ПараметрыПроведения.Реквизиты[0];
	
	Если Реквизиты.TransactionType = Перечисления.HOBTransactionType.Accrual Тогда
		
		Если НЕ Реквизиты.Reverse Тогда
			ВыполнитьНачислениеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.Amount, Реквизиты.BaseAmount, Отказ);
		Иначе
			ВыполнитьСписаниеUnbilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, -Реквизиты.BaseAmount, Отказ);
		КонецЕсли;
		
	ИначеЕсли Реквизиты.TransactionType = Перечисления.HOBTransactionType.JV Тогда
		
		ВыполнитьДвиженияПоРучнымКорректировкам(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.Amount, Реквизиты.BaseAmount, Отказ);
		
	ИначеЕсли Реквизиты.TransactionType = Перечисления.HOBTransactionType.Receivables Тогда
		
		Если Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПлатежноеПоручениеВходящее Тогда
			
			ВыполнитьНачислениеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, -Реквизиты.BaseAmount, Отказ);
			// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
			ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, Истина, Отказ);
			// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
			
		ИначеЕсли Реквизиты.HOBDocumentType = Перечисления.HOBDocumentTypes.ПлатежноеПоручениеВходящее Тогда
			
			ВыполнитьНачислениеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, -Реквизиты.BaseAmount, Отказ);
			ВыполнитьСписаниеUnallocatedCash(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, -Реквизиты.BaseAmount, Отказ);
			// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
			ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, Истина, Отказ);
			ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.Amount, Истина, Отказ);
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
				ВыполнитьСписаниеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, -Реквизиты.BaseAmount, Истина, Отказ);
				// { RGS TAlmazova 22.08.2016 9:41:38 - отражение в регистре Payments
				ВыполнитьДвижениеPayments(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, -Реквизиты.Amount, Истина, Отказ);
				// } RGS TAlmazova 22.08.2016 9:41:52 - отражение в регистре Payments
			//Иначе
			//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected combination of of currencies!",,,,Отказ);
			//КонецЕсли;
			
		ИначеЕсли Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.КорректировкаДолга ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПлетежноеПоручениеИсходящее Тогда
			
			ВыполнитьНачислениеUnallocatedMemo(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.Amount, Реквизиты.BaseAmount, Отказ);
			
		ИначеЕсли Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.АктОбОказанииПроизводственныхУслуг
			ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.КорректировкаРеализации
			ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.РеализацияТоваровУслуг
			ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПередачаОС
			ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.РеализацияУслугПоПереработке
			ИЛИ Реквизиты.HOBInvoiceType = Перечисления.HOBDocumentTypes.ПрочиеЗатраты Тогда
			
			ВыполнитьНачислениеBilledAR(Реквизиты, ПараметрыПроведения.СвязанныеДокументы, Движения, Реквизиты.Amount, Реквизиты.BaseAmount, Отказ);
			
		Иначе
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected parameters!", , , , Отказ);
			
		КонецЕсли;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Unexpected parameters!", , , , Отказ);
		
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
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
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
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.SalesOrder = СвязанныеДокументы.SalesOrder;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
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
	
	НовоеДвижение.ВидДвижения = ?(Сумма > 0, ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход);
	
	НовоеДвижение.Период = Реквизиты.Дата;
	НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
	НовоеДвижение.Company = Реквизиты.Company;
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	//НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.РучнаяКорректировка = СвязанныеДокументы.РучнаяКорректировка;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
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
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
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
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
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
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
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
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.Invoice = ?(ЗначениеЗаполнено(СвязанныеДокументы.Invoice), СвязанныеДокументы.Invoice, СвязанныеДокументы.Memo);
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	Если ИспользоватьВалютуТранзакции Тогда
		НовоеДвижение.Currency = Реквизиты.Currency;
	Иначе
		НовоеДвижение.Currency = Константы.rgsВалютаUSD.Получить();
	КонецЕсли;
	
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
	НовоеДвижение.Location = Реквизиты.Location;
	НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
	НовоеДвижение.Client = Реквизиты.Client;
	НовоеДвижение.Memo = СвязанныеДокументы.Memo;
	НовоеДвижение.Account = Реквизиты.Account;
	НовоеДвижение.AU = Реквизиты.AU;
	НовоеДвижение.Currency = Реквизиты.Currency;
	
	НовоеДвижение.Amount = Сумма;
	НовоеДвижение.BaseAmount = СуммаФВ;
	
	Движения.UnallocatedMemo.Записывать = Истина;
	
КонецПроцедуры

Процедура ВыполнитьДвижениеPayments(Реквизиты, СвязанныеДокументы, Движения, Сумма, ИспользоватьВалютуТранзакции, Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если Сумма <> 0 Тогда
	
		НовоеДвижение = Движения.Payments.Добавить();
		
		НовоеДвижение.Период = Реквизиты.Дата;
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
		НовоеДвижение.Company = Реквизиты.Company;
		НовоеДвижение.Location = Реквизиты.Location;
		НовоеДвижение.SubSubSegment = Реквизиты.SubSubSegment;
		НовоеДвижение.Client = Реквизиты.Client;
		НовоеДвижение.Invoice = СвязанныеДокументы.Invoice;
		НовоеДвижение.CashBatch = СвязанныеДокументы.CashBatch;
		Если ИспользоватьВалютуТранзакции Тогда
			НовоеДвижение.Currency = Реквизиты.Currency;
		Иначе
			НовоеДвижение.Currency = Константы.rgsВалютаUSD.Получить();
		КонецЕсли;
		
		НовоеДвижение.Amount = Сумма;
		
		Движения.Payments.Записывать = Истина;
	
	КонецЕсли;
	
КонецПроцедуры
