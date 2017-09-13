﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьСуммуДокумента(Документ) Экспорт
	
	Source = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Source");
	
	Если Source = Перечисления.ТипыСоответствий.Lawson Тогда
		Возврат ПолучитьСуммуДокументаLawson(Документ);
	ИначеЕсли Source = Перечисления.ТипыСоответствий.OracleMI ИЛИ Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
		Возврат ПолучитьСуммуДокументаOracle(Документ);
	Иначе
		ВызватьИсключение "Для источника " + Source + " не определен обработчик!";
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСуммуДокументаLawson(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).TranAmount) КАК СуммаДокумента
	|ИЗ
	|	РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументы
	|ГДЕ
	|	DSSСвязанныеДокументы.СвязанныйОбъект = &СвязанныйОбъект
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).System = ""BL""
	|	И (ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).SourceCode = ""DM""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).SourceCode = ""CM"")
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).Проведен
	|	И НЕ DSSСвязанныеДокументы.ПроводкаDSS.AccountLawson.БазовыйЭлемент В ИЕРАРХИИ (&СчетВыручкиВерхнегоУровня)";
	
	Запрос.УстановитьПараметр("СвязанныйОбъект", Документ);
	Запрос.УстановитьПараметр("СчетВыручкиВерхнегоУровня", rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня"));
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.СуммаДокумента;
	
КонецФункции

Функция ПолучитьСуммуДокументаOracle(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Amount) КАК СуммаДокумента
	|ИЗ
	|	РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументы
	|ГДЕ
	|	DSSСвязанныеДокументы.СвязанныйОбъект = &СвязанныйОбъект
	|	И (ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""INV""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""DEP""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""GUAR""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""PMT""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""CB"")
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Проведен
	|	И НЕ DSSСвязанныеДокументы.ПроводкаDSS.Account.БазовыйЭлемент В ИЕРАРХИИ (&СчетВыручкиВерхнегоУровня)";
	
	Запрос.УстановитьПараметр("СвязанныйОбъект", Документ);
	Запрос.УстановитьПараметр("СчетВыручкиВерхнегоУровня", rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня"));
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.СуммаДокумента;
	
КонецФункции

Процедура ОбновитьСуммуДокумента(Документ) Экспорт
	
	ДокОбъект = Документ.ПолучитьОбъект();
	ДокОбъект.Amount = ПолучитьСуммуДокумента(Документ);
	ДокОбъект.ОбменДанными.Загрузка = Истина;
	ДокОбъект.Записать();
	
КонецПроцедуры

Процедура ОбновитьСтатусОплатыДокумента(Документ, Комментарий = "") Экспорт
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Source, Company");
	
	Если РегистрыСведений.ИсточникиСЗаполнениемОплатИзОбмена.ЭтоИсточникСЗаполнениемОплатИзОбмена(СтруктураРеквизитов.Source, СтруктураРеквизитов.Company) Тогда
		Если СтруктураРеквизитов.Source = Перечисления.ТипыСоответствий.HOBs Тогда
			ОбновитьСтатусОплатыДокументаПоРегиструОплатИСуммеДокумента(Документ, Комментарий);
		Иначе
			ОбновитьСтатусОплатыДокументаПоРегиструОплат(Документ, Комментарий);
		КонецЕсли;
	Иначе
		ОбновитьСтатусОплатыДокументаПоПроводкам(Документ, Комментарий);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСтатусОплатыДокументаПоПроводкам(Документ, Комментарий = "")
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	РегистрНакопления.BilledAR КАК BilledAR
		|ГДЕ
		|	BilledAR.Invoice = &Invoice
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(BilledARОстатки.AmountОстаток / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2)) КАК AmountОстаток
		|ИЗ
		|	РегистрНакопления.BilledAR.Остатки(, Invoice = &Invoice) КАК BilledARОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО BilledARОстатки.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапросИтог.AmountОборот,
		|	ВложенныйЗапросИтог.ДатаПоследнейОплаты,
		|	ВЫБОР
		|		КОГДА InvoiceComments.Период ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьКомментарийЭтойДатой
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЕСТЬNULL(СУММА(ВЫРАЗИТЬ(ЕСТЬNULL(PaymentsОбороты.AmountОборот, 0) / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))), 0) КАК AmountОборот,
		|		ЕСТЬNULL(МАКСИМУМ(ВЫБОР
		|					КОГДА PaymentsОбороты.Invoice = НЕОПРЕДЕЛЕНО
		|							ИЛИ PaymentsОбороты.Invoice = ЗНАЧЕНИЕ(Документ.Invoice.ПустаяСсылка)
		|						ТОГДА ДАТАВРЕМЯ(1, 1, 1)
		|					КОГДА PaymentsОбороты.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|						ТОГДА ВЫРАЗИТЬ(PaymentsОбороты.Регистратор КАК Документ.ПроводкаDSS).DateLawson
		|					ИНАЧЕ PaymentsОбороты.Период
		|				КОНЕЦ), ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаПоследнейОплаты
		|	ИЗ
		|		РегистрНакопления.Payments.Обороты(, , Запись, Invoice = &Invoice) КАК PaymentsОбороты
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|			ПО PaymentsОбороты.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта) КАК ВложенныйЗапросИтог
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments КАК InvoiceComments
		|		ПО ВложенныйЗапросИтог.ДатаПоследнейОплаты = InvoiceComments.Период
		|			И (InvoiceComments.Invoice = &Invoice)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status
		|ИЗ
		|	РегистрСведений.InvoiceComments.СрезПоследних(, Invoice = &Invoice) КАК InvoiceCommentsСрезПоследних";
	
	Запрос.УстановитьПараметр("Invoice", Документ);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатНаличиеДвижений = МассивРезультатов[0];
	ЕстьДвиженияПоИнвойсу = НЕ РезультатНаличиеДвижений.Пустой();
	
	ТекущийОстаток = 0;
	РезультатЗапросаТекущийОстаток = МассивРезультатов[1];
	Если Не РезультатЗапросаТекущийОстаток.Пустой() Тогда
		ВыборкаТекущийОстаток = РезультатЗапросаТекущийОстаток.Выбрать();
		ВыборкаТекущийОстаток.Следующий();
		ТекущийОстаток = ВыборкаТекущийОстаток.AmountОстаток;
	КонецЕсли;
	
	СуммаОплаты = 0;
	ДатаОплаты = '00010101';
	РезультатЗапросаСуммаОплаты = МассивРезультатов[2];
	Если Не РезультатЗапросаСуммаОплаты.Пустой() Тогда
		ВыборкаСуммаОплаты = РезультатЗапросаСуммаОплаты.Выбрать();
		ВыборкаСуммаОплаты.Следующий();
		СуммаОплаты = ВыборкаСуммаОплаты.AmountОборот;
		Если ВыборкаСуммаОплаты.ЕстьКомментарийЭтойДатой Тогда
			ДатаОплаты = ВыборкаСуммаОплаты.ДатаПоследнейОплаты + 1;
		Иначе
			ДатаОплаты = ВыборкаСуммаОплаты.ДатаПоследнейОплаты;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийСтатус = Перечисления.InvoiceStatus.ПустаяСсылка();
	РезультатТекущийСтатус = МассивРезультатов[3];
	Если НЕ РезультатТекущийСтатус.Пустой() Тогда
		ВыборкаТекущийСтатус = РезультатТекущийСтатус.Выбрать();
		ВыборкаТекущийСтатус.Следующий();
		ТекущийСтатус = ВыборкаТекущийСтатус.Status;
	КонецЕсли;
	
	СтатусОплачен = Перечисления.InvoiceStatus.InvoicePaid;
	СтатусЧастичноОплачен = Перечисления.InvoiceStatus.PartiallyPaid;
	AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
	
	Если Не ЕстьДвиженияПоИнвойсу И СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), , AutoUser, Комментарий);
		
	ИначеЕсли Не ЕстьДвиженияПоИнвойсу И СуммаОплаты > 0 И ТекущийСтатус <> СтатусОплачен И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу не было начислений, но оплата прошла. Странная ситуация. Считаем, что инвойс частично оплачен.
		
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток > 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, значит считаем частично оплаченным
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток <= 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу закрыт баланс и была оплата, значит считаем оплаченным
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСтатусОплатыДокументаПоРегиструОплат(Документ, Комментарий = "")
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	1 КАК Поле1
		|ИЗ
		|	РегистрНакопления.BilledAR КАК BilledAR
		|ГДЕ
		|	BilledAR.Invoice = &Invoice
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫРАЗИТЬ(BilledARОстатки.AmountОстаток / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2)) КАК AmountОстаток
		|ИЗ
		|	РегистрНакопления.BilledAR.Остатки(, Invoice = &Invoice) КАК BilledARОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО BilledARОстатки.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапросИтог.AmountОборот,
		|	ВложенныйЗапросИтог.PaymentDate,
		|	ВЫБОР
		|		КОГДА InvoiceComments.Период ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьКомментарийЭтойДатой
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЕСТЬNULL(СУММА(ВЫРАЗИТЬ(ВложенныйЗапрос.Amount / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))), 0) КАК AmountОборот,
		|		ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.PaymentDate), НЕОПРЕДЕЛЕНО) КАК PaymentDate
		|	ИЗ
		|		(ВЫБРАТЬ
		|			FiscalPayments.Currency КАК Currency,
		|			СУММА(FiscalPayments.Amount) КАК Amount,
		|			МАКСИМУМ(FiscalPayments.PaymentDate) КАК PaymentDate
		|		ИЗ
		|			РегистрСведений.FiscalPayments КАК FiscalPayments
		|		ГДЕ
		|			FiscalPayments.Invoice = &Invoice
		|		
		|		СГРУППИРОВАТЬ ПО
		|			FiscalPayments.Currency) КАК ВложенныйЗапрос
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|			ПО ВложенныйЗапрос.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта) КАК ВложенныйЗапросИтог
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments КАК InvoiceComments
		|		ПО ВложенныйЗапросИтог.PaymentDate = InvoiceComments.Период
		|			И (InvoiceComments.Invoice = &Invoice)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status
		|ИЗ
		|	РегистрСведений.InvoiceComments.СрезПоследних(, Invoice = &Invoice) КАК InvoiceCommentsСрезПоследних";
	
	Запрос.УстановитьПараметр("Invoice", Документ);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	РезультатНаличиеДвижений = МассивРезультатов[0];
	ЕстьДвиженияПоИнвойсу = НЕ РезультатНаличиеДвижений.Пустой();
	
	ТекущийОстаток = 0;
	РезультатЗапросаТекущийОстаток = МассивРезультатов[1];
	Если Не РезультатЗапросаТекущийОстаток.Пустой() Тогда
		ВыборкаТекущийОстаток = РезультатЗапросаТекущийОстаток.Выбрать();
		ВыборкаТекущийОстаток.Следующий();
		ТекущийОстаток = ВыборкаТекущийОстаток.AmountОстаток;
	КонецЕсли;
	
	СуммаОплаты = 0;
	ДатаОплаты = '00010101';
	РезультатЗапросаСуммаОплаты = МассивРезультатов[2];
	Если Не РезультатЗапросаСуммаОплаты.Пустой() Тогда
		ВыборкаСуммаОплаты = РезультатЗапросаСуммаОплаты.Выбрать();
		ВыборкаСуммаОплаты.Следующий();
		СуммаОплаты = ВыборкаСуммаОплаты.AmountОборот;
		Если ВыборкаСуммаОплаты.ЕстьКомментарийЭтойДатой Тогда
			ДатаОплаты = ВыборкаСуммаОплаты.PaymentDate + 1;
		Иначе
			ДатаОплаты = ВыборкаСуммаОплаты.PaymentDate;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийСтатус = Перечисления.InvoiceStatus.ПустаяСсылка();
	РезультатТекущийСтатус = МассивРезультатов[3];
	Если НЕ РезультатТекущийСтатус.Пустой() Тогда
		ВыборкаТекущийСтатус = РезультатТекущийСтатус.Выбрать();
		ВыборкаТекущийСтатус.Следующий();
		ТекущийСтатус = ВыборкаТекущийСтатус.Status;
	КонецЕсли;
	
	СтатусОплачен = Перечисления.InvoiceStatus.InvoicePaid;
	СтатусЧастичноОплачен = Перечисления.InvoiceStatus.PartiallyPaid;
	AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
	
	Если Не ЕстьДвиженияПоИнвойсу И СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), , AutoUser, Комментарий);
		
	ИначеЕсли Не ЕстьДвиженияПоИнвойсу И СуммаОплаты > 0 И ТекущийСтатус <> СтатусОплачен И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу не было начислений, но оплата прошла. Странная ситуация. Считаем, что инвойс частично оплачен.
		
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток > 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, значит считаем частично оплаченным
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток <= 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу закрыт баланс и была оплата, значит считаем оплаченным
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСтатусОплатыДокументаПоРегиструОплатИСуммеДокумента(Документ, Комментарий = "")
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВЫРАЗИТЬ(Invoice.Amount / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2)) КАК Amount
		|ИЗ
		|	Документ.Invoice КАК Invoice
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО Invoice.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|ГДЕ
		|	Invoice.Ссылка = &Invoice
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапросИтог.AmountОборот,
		|	ВложенныйЗапросИтог.PaymentDate,
		|	ВЫБОР
		|		КОГДА InvoiceComments.Период ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьКомментарийЭтойДатой
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЕСТЬNULL(СУММА(ВЫРАЗИТЬ(ВложенныйЗапрос.Amount / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))), 0) КАК AmountОборот,
		|		ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.PaymentDate), ДАТАВРЕМЯ(1, 1, 1)) КАК PaymentDate
		|	ИЗ
		|		(ВЫБРАТЬ
		|			FiscalPayments.Currency КАК Currency,
		|			СУММА(FiscalPayments.Amount) КАК Amount,
		|			МАКСИМУМ(FiscalPayments.PaymentDate) КАК PaymentDate
		|		ИЗ
		|			РегистрСведений.FiscalPayments КАК FiscalPayments
		|		ГДЕ
		|			FiscalPayments.Invoice = &Invoice
		|		
		|		СГРУППИРОВАТЬ ПО
		|			FiscalPayments.Currency) КАК ВложенныйЗапрос
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|			ПО ВложенныйЗапрос.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта) КАК ВложенныйЗапросИтог
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments КАК InvoiceComments
		|		ПО ВложенныйЗапросИтог.PaymentDate = InvoiceComments.Период
		|			И (InvoiceComments.Invoice = &Invoice)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status
		|ИЗ
		|	РегистрСведений.InvoiceComments.СрезПоследних(, Invoice = &Invoice) КАК InvoiceCommentsСрезПоследних";
	
	Запрос.УстановитьПараметр("Invoice", Документ);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	СуммаДокумента = 0;
	РезультатЗапросаСуммаДокумента = МассивРезультатов[0];
	Если Не РезультатЗапросаСуммаДокумента.Пустой() Тогда
		ВыборкаСуммаДокумента = РезультатЗапросаСуммаДокумента.Выбрать();
		ВыборкаСуммаДокумента.Следующий();
		СуммаДокумента = ВыборкаСуммаДокумента.Amount;
	КонецЕсли;
	
	СуммаОплаты = 0;
	ДатаОплаты = '00010101';
	РезультатЗапросаСуммаОплаты = МассивРезультатов[1];
	Если Не РезультатЗапросаСуммаОплаты.Пустой() Тогда
		ВыборкаСуммаОплаты = РезультатЗапросаСуммаОплаты.Выбрать();
		ВыборкаСуммаОплаты.Следующий();
		СуммаОплаты = ВыборкаСуммаОплаты.AmountОборот;
		Если ВыборкаСуммаОплаты.ЕстьКомментарийЭтойДатой Тогда
			ДатаОплаты = ВыборкаСуммаОплаты.PaymentDate + 1;
		Иначе
			ДатаОплаты = ВыборкаСуммаОплаты.PaymentDate;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийСтатус = Перечисления.InvoiceStatus.ПустаяСсылка();
	РезультатТекущийСтатус = МассивРезультатов[2];
	Если НЕ РезультатТекущийСтатус.Пустой() Тогда
		ВыборкаТекущийСтатус = РезультатТекущийСтатус.Выбрать();
		ВыборкаТекущийСтатус.Следующий();
		ТекущийСтатус = ВыборкаТекущийСтатус.Status;
	КонецЕсли;
	
	СтатусОплачен = Перечисления.InvoiceStatus.InvoicePaid;
	СтатусЧастичноОплачен = Перечисления.InvoiceStatus.PartiallyPaid;
	AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
	
	Если СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), , AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента = 0 И СуммаОплаты > 0 И ТекущийСтатус <> СтатусОплачен И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу не было начислений, но оплата прошла. Странная ситуация. Считаем, что инвойс частично оплачен.
		
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента > 0 И СуммаОплаты <> 0 И СуммаДокумента > СуммаОплаты И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, значит считаем частично оплаченным
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента > 0 И СуммаОплаты <> 0 И СуммаДокумента <= СуммаОплаты И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, сумма оплаты покрывает инвойс, значит считаем оплаченным
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента <= 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу закрыт баланс и была оплата, значит считаем оплаченным
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаОплаты, AutoUser, Комментарий);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьСтатусИнвойса(Документ, Статус, ДатаСтатуса = Неопределено, Пользователь = Неопределено, Комментарий = "")
	
	Если Пользователь = Неопределено Тогда
		Пользователь = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если ДатаСтатуса = Неопределено Тогда
		ДатаСтатуса = ТекущаяДата();
	КонецЕсли;
	
	НЗ = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	
	СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, ConfirmedBy, CustomerRepresentative, CustomerInputDetails, Comment, CustInputDate, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");

	СтруктураРеквизитовПроблемы.Дата = ДатаСтатуса;
	СтруктураРеквизитовПроблемы.Invoice = Документ;
	СтруктураРеквизитовПроблемы.SLBAssignedTo = Новый ТаблицаЗначений;
	СтруктураРеквизитовПроблемы.Status = Статус;
	СтруктураРеквизитовПроблемы.User = Пользователь;
	СтруктураРеквизитовПроблемы.Comment = Комментарий;
	
	Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
	
	Запись = НЗ.Добавить();
	Запись.Период = ДатаСтатуса;
	Запись.Invoice = Документ;
	Запись.Problem = Problem;
	НЗ.Записать(Ложь);
	
КонецПроцедуры

#КонецЕсли