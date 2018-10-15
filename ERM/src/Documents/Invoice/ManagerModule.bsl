#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
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
		//Если СтруктураРеквизитов.Source = Перечисления.ТипыСоответствий.HOBs Тогда
			ОбновитьСтатусОплатыДокументаПоРегиструОплатИСуммеДокумента(Документ, Комментарий);
		//Иначе
		//	ОбновитьСтатусОплатыДокументаПоРегиструОплат(Документ, Комментарий);
		//КонецЕсли;
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
		|	РегистрСведений.InvoiceComments.СрезПоследних(
		|			,
		|			Invoice = &Invoice
		|				И НЕ Inactive
		|				И НЕ ПроставленРегламентомАктуализацииСтатусовОплат) КАК InvoiceCommentsСрезПоследних";
	
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
			СтруктураЗаписи = Новый Структура("Период, Invoice");
			СтруктураЗаписи.Invoice = Документ;
			Для КоличествоСекунд = 1 По 100 Цикл
				ДатаОплаты = ВыборкаСуммаОплаты.ДатаПоследнейОплаты + КоличествоСекунд;
				СтруктураЗаписи.Период = ДатаОплаты;
				Если НЕ РегистрыСведений.InvoiceComments.ЗаписьЕстьВРегистре(СтруктураЗаписи) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
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
	AutoUser = rgsНастройкаКонфигурации.ЗначениеНастройки("AutoUser");
	ДатаСтатуса = Неопределено;
	
	Если Не ЕстьДвиженияПоИнвойсу И СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		ДатаСтатуса = ТекущаяДата();
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли Не ЕстьДвиженияПоИнвойсу И СуммаОплаты > 0 И ТекущийСтатус <> СтатусОплачен И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу не было начислений, но оплата прошла. Странная ситуация. Считаем, что инвойс частично оплачен.
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток > 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, значит считаем частично оплаченным
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	// TODO RGS AGorlenko 22.11.2017: проверить условие
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток > 0 И СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		ДатаСтатуса = ?(ЗначениеЗаполнено(ДатаОплаты), ДатаОплаты, ТекущаяДата());
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток <= 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу закрыт баланс и была оплата, значит считаем оплаченным
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	КонецЕсли;
	
	Если ДатаСтатуса <> Неопределено Тогда
		ОтметитьПоследующиеАвтостатусыКакНеактуальные(Документ, ДатаСтатуса);
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
		|	РегистрСведений.InvoiceComments.СрезПоследних(
		|			,
		|			Invoice = &Invoice
		|				И НЕ Inactive
		|				И НЕ ПроставленРегламентомАктуализацииСтатусовОплат) КАК InvoiceCommentsСрезПоследних";
	
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
			СтруктураЗаписи = Новый Структура("Период, Invoice");
			СтруктураЗаписи.Invoice = Документ;
			Для КоличествоСекунд = 1 По 100 Цикл
				ДатаОплаты = ВыборкаСуммаОплаты.PaymentDate + КоличествоСекунд;
				СтруктураЗаписи.Период = ДатаОплаты;
				Если НЕ РегистрыСведений.InvoiceComments.ЗаписьЕстьВРегистре(СтруктураЗаписи) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
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
	AutoUser = rgsНастройкаКонфигурации.ЗначениеНастройки("AutoUser");
	ДатаСтатуса = Неопределено;
	
	Если Не ЕстьДвиженияПоИнвойсу И СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		ДатаСтатуса = ТекущаяДата();
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли Не ЕстьДвиженияПоИнвойсу И СуммаОплаты > 0 И ТекущийСтатус <> СтатусОплачен И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу не было начислений, но оплата прошла. Странная ситуация. Считаем, что инвойс частично оплачен.
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток > 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, значит считаем частично оплаченным
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	// TODO RGS AGorlenko 22.11.2017: проверить условие
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток > 0 И СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		ДатаСтатуса = ?(ЗначениеЗаполнено(ДатаОплаты), ДатаОплаты, ТекущаяДата());
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли ЕстьДвиженияПоИнвойсу И ТекущийОстаток <= 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу закрыт баланс и была оплата, значит считаем оплаченным
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	КонецЕсли;
	
	Если ДатаСтатуса <> Неопределено Тогда
		ОтметитьПоследующиеАвтостатусыКакНеактуальные(Документ, ДатаСтатуса);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьСтатусОплатыДокументаПоРегиструОплатИСуммеДокумента(Документ, Комментарий = "")
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	// { RGS AGorlenko 31.01.2018 17:51:53 - ориентируемся на сумму взаиморасчетов
		//"ВЫБРАТЬ
		//|	ВЫРАЗИТЬ(Invoice.FiscalAmount / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2)) КАК Amount
		//|ИЗ
		//|	Документ.Invoice КАК Invoice
		//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		//|		ПО Invoice.FiscalCurrency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		//|ГДЕ
		//|	Invoice.Ссылка = &Invoice
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ
		//|	ВложенныйЗапросИтог.AmountОборот,
		//|	ВложенныйЗапросИтог.PaymentDate,
		//|	ВЫБОР
		//|		КОГДА InvoiceComments.Период ЕСТЬ NULL
		//|			ТОГДА ЛОЖЬ
		//|		ИНАЧЕ ИСТИНА
		//|	КОНЕЦ КАК ЕстьКомментарийЭтойДатой
		//|ИЗ
		//|	(ВЫБРАТЬ
		//|		ЕСТЬNULL(СУММА(ВЫРАЗИТЬ(ВложенныйЗапрос.Amount / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))), 0) КАК AmountОборот,
		//|		ЕСТЬNULL(МАКСИМУМ(ВложенныйЗапрос.PaymentDate), ДАТАВРЕМЯ(1, 1, 1)) КАК PaymentDate
		//|	ИЗ
		//|		(ВЫБРАТЬ
		//|			FiscalPayments.Currency КАК Currency,
		//|			СУММА(FiscalPayments.Amount) КАК Amount,
		//|			МАКСИМУМ(FiscalPayments.PaymentDate) КАК PaymentDate
		//|		ИЗ
		//|			РегистрСведений.FiscalPayments КАК FiscalPayments
		//|		ГДЕ
		//|			FiscalPayments.Invoice = &Invoice
		//|		
		//|		СГРУППИРОВАТЬ ПО
		//|			FiscalPayments.Currency) КАК ВложенныйЗапрос
		//|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		//|			ПО ВложенныйЗапрос.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта) КАК ВложенныйЗапросИтог
		//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments КАК InvoiceComments
		//|		ПО ВложенныйЗапросИтог.PaymentDate = InvoiceComments.Период
		//|			И (InvoiceComments.Invoice = &Invoice)
		//|;
		//|
		//|////////////////////////////////////////////////////////////////////////////////
		//|ВЫБРАТЬ
		//|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status
		//|ИЗ
		//|	РегистрСведений.InvoiceComments.СрезПоследних(
		//|			,
		//|			Invoice = &Invoice
		//|				И НЕ Inactive) КАК InvoiceCommentsСрезПоследних";
		"ВЫБРАТЬ
		|	Invoice.FiscalAmount КАК Amount
		|ИЗ
		|	Документ.Invoice КАК Invoice
		|ГДЕ
		|	Invoice.Ссылка = &Invoice
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВложенныйЗапрос.Amount, 0) КАК AmountОборот,
		|	ЕСТЬNULL(ВложенныйЗапрос.PaymentDate, ДАТАВРЕМЯ(1, 1, 1)) КАК PaymentDate,
		|	ВЫБОР
		|		КОГДА InvoiceComments.Период ЕСТЬ NULL
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЕстьКомментарийЭтойДатой
		|ИЗ
		|	(ВЫБРАТЬ
		|		СУММА(FiscalPayments.SettlementAmount) КАК Amount,
		|		МАКСИМУМ(FiscalPayments.PaymentDate) КАК PaymentDate
		|	ИЗ
		|		РегистрСведений.FiscalPayments КАК FiscalPayments
		|	ГДЕ
		|		FiscalPayments.Invoice = &Invoice) КАК ВложенныйЗапрос
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments КАК InvoiceComments
		|		ПО ВложенныйЗапрос.PaymentDate = InvoiceComments.Период
		|			И (InvoiceComments.Invoice = &Invoice)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status
		|ИЗ
		|	РегистрСведений.InvoiceComments.СрезПоследних(
		|			,
		|			Invoice = &Invoice
		|				И НЕ Inactive
		|				И НЕ ПроставленРегламентомАктуализацииСтатусовОплат) КАК InvoiceCommentsСрезПоследних";
	// } RGS AGorlenko 31.01.2018 17:52:11 - ориентируемся на сумму взаиморасчетов
	
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
			СтруктураЗаписи = Новый Структура("Период, Invoice");
			СтруктураЗаписи.Invoice = Документ;
			Для КоличествоСекунд = 1 По 100 Цикл
				ДатаОплаты = ВыборкаСуммаОплаты.PaymentDate + КоличествоСекунд;
				СтруктураЗаписи.Период = ДатаОплаты;
				Если НЕ РегистрыСведений.InvoiceComments.ЗаписьЕстьВРегистре(СтруктураЗаписи) Тогда
					Прервать;
				КонецЕсли;
			КонецЦикла;
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
	ДатаСтатуса = Неопределено;
	
	Если СуммаОплаты = 0 И (ТекущийСтатус = СтатусОплачен ИЛИ ТекущийСтатус = СтатусЧастичноОплачен) Тогда
		
		// отменяем предыдущий статус оплаты
		ДатаСтатуса = ТекущаяДата();
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента = 0 И СуммаОплаты > 0 И ТекущийСтатус <> СтатусОплачен И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу не было начислений, но оплата прошла. Странная ситуация. Считаем, что инвойс частично оплачен.
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента > 0 И СуммаОплаты <> 0 И СуммаДокумента > СуммаОплаты И ТекущийСтатус <> СтатусЧастичноОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, значит считаем частично оплаченным
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусЧастичноОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента > 0 И СуммаОплаты <> 0 И СуммаДокумента <= СуммаОплаты И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу есть баланс и была оплата, сумма оплаты покрывает инвойс, значит считаем оплаченным
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	// TODO RGS AGorlenko 22.11.2017: проверить условие
	ИначеЕсли СуммаДокумента > 0 И СуммаОплаты = 0 И (ТекущийСтатус = СтатусЧастичноОплачен И ТекущийСтатус = СтатусОплачен) Тогда
		
		// по инвойсу есть баланс и была оплата, сумма оплаты покрывает инвойс, значит считаем оплаченным
		ДатаСтатуса = ?(ЗначениеЗаполнено(ДатаОплаты), ДатаОплаты, ТекущаяДата());
		УстановитьСтатусИнвойса(Документ, Перечисления.InvoiceStatus.ПустаяСсылка(), ДатаСтатуса, AutoUser, Комментарий);
		
	ИначеЕсли СуммаДокумента <= 0 И СуммаОплаты <> 0 И ТекущийСтатус <> СтатусОплачен Тогда
		
		// по инвойсу закрыт баланс и была оплата, значит считаем оплаченным
		ДатаСтатуса = ДатаОплаты;
		УстановитьСтатусИнвойса(Документ, СтатусОплачен, ДатаСтатуса, AutoUser, Комментарий);
		
	КонецЕсли;
	
	Если ДатаСтатуса <> Неопределено Тогда
		ОтметитьПоследующиеАвтостатусыКакНеактуальные(Документ, ДатаСтатуса);
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

Процедура ОтметитьПоследующиеАвтостатусыКакНеактуальные(Документ, ДатаСтатуса)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	InvoiceComments.Период
		|ИЗ
		|	РегистрСведений.InvoiceComments КАК InvoiceComments
		|ГДЕ
		|	InvoiceComments.Период > &Период
		|	И
		|	НЕ InvoiceComments.Inactive
		|	И InvoiceComments.Problem.User = &AutoUser
		|	И InvoiceComments.Invoice = &Invoice
		|	И
		|	НЕ InvoiceComments.ПроставленРегламентомАктуализацииСтатусовОплат";
	
	Запрос.УстановитьПараметр("AutoUser", rgsНастройкаКонфигурации.ЗначениеНастройки("AutoUser"));
	Запрос.УстановитьПараметр("Invoice", Документ);
	Запрос.УстановитьПараметр("Период", ДатаСтатуса);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	НЗ = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	НЗ.ДополнительныеСвойства.Вставить("РазрешитьРедактирование", Истина);
	НЗ.Отбор.Invoice.Установить(Документ);
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НЗ.Очистить();
		НЗ.Отбор.Период.Установить(ВыборкаДетальныеЗаписи.Период);
		
		НЗ.Прочитать();
		
		НЗ[0].Inactive = Истина;
		НЗ.Записать();
		
	КонецЦикла;

КонецПроцедуры

#Область PowerBI

// Описание
// Выполняет выгрузку данных в Power BI
// Параметры:
// 	Ссылка - Ссылка на данные, которые нужно выгрузить
// 	Операция - вид операции с данными
// Возвращаемое значение:
// 	Структура - включает поля Результат, Сообщение.
Функция ВыгрузитьДанныеДляPowerBI(Ссылка, Операция, ПараметрыЛогирования) Экспорт
	
	СтруктураРезультата = Новый Структура("Результат, Сообщение", Ложь, "");
	
	ТекОбъект = PowerBIРегламенты.ПолучитьОбъектИзВнешнегоИсточника("dbo_Invoice", Операция, Ссылка, ПараметрыЛогирования);
	
	ЗаполнитьОбъектPowerBI(ТекОбъект, Ссылка);
	
	Если Операция = Перечисления.ОперацииPowerBI.Create Тогда
		PowerBIРегламенты.СформироватьЗаписиЖурналаДокуменовPowerBI(Ссылка, "Invoice", ПараметрыЛогирования, СтруктураРезультата);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(СтруктураРезультата.Сообщение) Тогда
		PowerBIРегламенты.ЗаписатьОбъектВоВнешнийИсточник(ТекОбъект, ПараметрыЛогирования, СтруктураРезультата);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтруктураРезультата.Сообщение) Тогда
		СтруктураРезультата.Результат = Истина;
	КонецЕсли;
	
	Возврат СтруктураРезультата;
	
КонецФункции

Процедура ЗаполнитьОбъектPowerBI(Объект, Ссылка)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Invoice.ПометкаУдаления КАК ПометкаУдаления,
		|	Invoice.Номер КАК Номер,
		|	Invoice.Дата КАК Дата,
		|	ПРЕДСТАВЛЕНИЕ(Invoice.Source) КАК Source,
		|	Invoice.Company.БазовыйЭлемент КАК Company,
		|	Invoice.Client КАК Client,
		|	Invoice.Contract КАК Contract,
		|	Invoice.Currency КАК Currency,
		|	Invoice.Amount КАК Amount,
		|	Invoice.FiscalInvoiceNo КАК FiscalInvoiceNo,
		|	Invoice.FiscalInvoiceDate КАК FiscalInvoiceDate,
		|	Invoice.FiscalCurrency КАК FiscalCurrency,
		|	Invoice.FiscalAmount КАК FiscalAmount,
		|	Invoice.TriggerDate КАК TriggerDate,
		|	Invoice.DueDateFrom КАК DueDateFrom,
		|	Invoice.DueDateTo КАК DueDateTo,
		|	Invoice.Agreement КАК Agreement,
		|	Invoice.ДатаВозвратаКС КАК DateReturnKS,
		|	Invoice.ДатаОтправкиКС КАК DateSentKS,
		|	Invoice.КомментарийСтатусаВозвратаКС КАК CommentTheStatusOfTheReturn,
		|	Invoice.СтатусВозвратаКС КАК ReturnStatusKS,
		|	Invoice.DocNumber КАК DocNumber
		|ИЗ
		|	Документ.Invoice КАК Invoice
		|ГДЕ
		|	Invoice.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Объект.DeletionMark = ВыборкаДетальныеЗаписи.ПометкаУдаления;
	Объект.Date = ВыборкаДетальныеЗаписи.Дата;
	Объект.Number = ВыборкаДетальныеЗаписи.Номер;
	Объект.Source = ВыборкаДетальныеЗаписи.Source;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Company) Тогда
		Объект.CompanyID = Строка(ВыборкаДетальныеЗаписи.Company.УникальныйИдентификатор());
	Иначе
		Объект.CompanyID = NULL;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Client) Тогда
		Объект.ClientID = Строка(ВыборкаДетальныеЗаписи.Client.УникальныйИдентификатор());
	Иначе
		Объект.ClientID = NULL;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Contract) Тогда
		Объект.ContractID = Строка(ВыборкаДетальныеЗаписи.Contract.УникальныйИдентификатор());
	Иначе
		Объект.ContractID = NULL;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Currency) Тогда
		Объект.CurrencyID = Строка(ВыборкаДетальныеЗаписи.Currency.УникальныйИдентификатор());
	Иначе
		Объект.CurrencyID = NULL;
	КонецЕсли;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.FiscalCurrency) Тогда
		Объект.FiscalCurrencyID = Строка(ВыборкаДетальныеЗаписи.FiscalCurrency.УникальныйИдентификатор());
	Иначе
		Объект.FiscalCurrencyID = NULL;
	КонецЕсли;
	Объект.Amount = ВыборкаДетальныеЗаписи.Amount;
	Объект.FiscalInvoiceNo = ВыборкаДетальныеЗаписи.FiscalInvoiceNo;
	Объект.FiscalInvoiceDate = ВыборкаДетальныеЗаписи.FiscalInvoiceDate;
	Объект.FiscalAmount = ВыборкаДетальныеЗаписи.FiscalAmount;
	Объект.TriggerDate = ВыборкаДетальныеЗаписи.TriggerDate;
	Объект.DueDateFrom = ВыборкаДетальныеЗаписи.DueDateFrom;
	Объект.DueDateTo = ВыборкаДетальныеЗаписи.DueDateTo;
	Объект.Agreement = ВыборкаДетальныеЗаписи.Agreement;
	Объект.KSReturnDate = ВыборкаДетальныеЗаписи.DateReturnKS;
	Объект.KSDepartureDate = ВыборкаДетальныеЗаписи.DateSentKS;
	Объект.KSReturnStatus = ВыборкаДетальныеЗаписи.ReturnStatusKS;
	Объект.KSCommentReturnStatus = ВыборкаДетальныеЗаписи.CommentTheStatusOfTheReturn;
	Объект.DocNumber = ВыборкаДетальныеЗаписи.DocNumber;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли