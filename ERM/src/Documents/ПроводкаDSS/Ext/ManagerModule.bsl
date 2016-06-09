﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПодготовитьПараметрыПроведения(ДокументСсылка, Отказ) Экспорт
	
	ПараметрыПроведения            = Новый Структура;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	НомераТаблиц = Новый Структура;
	Запрос.Текст = ТекстЗапросаПарамтерыПроведения(НомераТаблиц);
	Результат    = Запрос.ВыполнитьПакет();
	
	ТаблицаРеквизиты = Результат[НомераТаблиц["Реквизиты"]].Выгрузить();
	ПараметрыПроведения.Вставить("Реквизиты", ТаблицаРеквизиты);
	
	ТаблицаСвязанныеДокументы = Результат[НомераТаблиц["СвязанныеДокументы"]].Выгрузить();
	
	ПараметрыПроведения.Вставить("СвязанныеДокументы", Новый Структура("SalesOrder, Invoice, CashBatch, BatchAllocation, РучнаяКорректировка"));
	
	Для каждого СтрокаСвязанногоДокумента Из ТаблицаСвязанныеДокументы Цикл
		Если СтрокаСвязанногоДокумента.ТипСвязанногоОбъекта = Перечисления.ТипыОбъектовСвязанныхСПроводкойDSS.SalesOrder Тогда
			ПараметрыПроведения.СвязанныеДокументы.SalesOrder = СтрокаСвязанногоДокумента.Ссылка;
		ИначеЕсли СтрокаСвязанногоДокумента.ТипСвязанногоОбъекта = Перечисления.ТипыОбъектовСвязанныхСПроводкойDSS.Invoice Тогда
			ПараметрыПроведения.СвязанныеДокументы.Invoice = СтрокаСвязанногоДокумента.Ссылка;
		ИначеЕсли СтрокаСвязанногоДокумента.ТипСвязанногоОбъекта = Перечисления.ТипыОбъектовСвязанныхСПроводкойDSS.CashBatch Тогда
			ПараметрыПроведения.СвязанныеДокументы.CashBatch = СтрокаСвязанногоДокумента.Ссылка;
		ИначеЕсли СтрокаСвязанногоДокумента.ТипСвязанногоОбъекта = Перечисления.ТипыОбъектовСвязанныхСПроводкойDSS.BatchAllocation Тогда
			ПараметрыПроведения.СвязанныеДокументы.BatchAllocation = СтрокаСвязанногоДокумента.Ссылка;
		ИначеЕсли СтрокаСвязанногоДокумента.ТипСвязанногоОбъекта = Перечисления.ТипыОбъектовСвязанныхСПроводкойDSS.РучнаяКорректировка Тогда
			ПараметрыПроведения.СвязанныеДокументы.РучнаяКорректировка = СтрокаСвязанногоДокумента.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ТекстЗапросаПарамтерыПроведения(НомераТаблиц)
	
	НомераТаблиц.Вставить("Реквизиты",                       НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СвязанныеДокументы",              НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ПроводкаDSS.ПометкаУдаления,
	|	ПроводкаDSS.Номер,
	|	ПроводкаDSS.Дата,
	|	ПроводкаDSS.Проведен,
	|	ПроводкаDSS.System,
	|	ПроводкаDSS.Документ,
	|	ПроводкаDSS.GeoMarket,
	|	ПроводкаDSS.Модуль,
	|	ПроводкаDSS.SourceCode,
	|	ПроводкаDSS.AccountLawson,
	|	ПроводкаDSS.AU,
	|	ПроводкаDSS.LegalEntity,
	|	ПроводкаDSS.BaseAmount,
	|	ПроводкаDSS.DateLawson,
	|	ПроводкаDSS.Reference,
	|	ПроводкаDSS.Description,
	|	ПроводкаDSS.TranAmount,
	|	ПроводкаDSS.Currency,
	|	ПроводкаDSS.GUID,
	|	ПроводкаDSS.PeriodLawson,
	|	ПроводкаDSS.Company,
	|	ПроводкаDSS.UpdateDateLawson,
	|	ПроводкаDSS.SeqTrnsNbrLawson,
	|	ПроводкаDSS.OrigCompanyLawson,
	|	ПроводкаDSS.Activity,
	|	ПроводкаDSS.JeTypeLawson,
	|	ПроводкаDSS.JournalLawson,
	|	ПроводкаDSS.LineNbrLawson,
	|	ПроводкаDSS.AutoRevLawson,
	|	ПроводкаDSS.Operator,
	|	ПроводкаDSS.LegalFiscalFlagLawson,
	|	ПроводкаDSS.Vendor,
	|	ПроводкаDSS.VendorVname,
	|	ПроводкаDSS.ApInvoice,
	|	ПроводкаDSS.TransNbr,
	|	ПроводкаDSS.OrigOperatorId,
	|	ПроводкаDSS.ProcessLevel,
	|	ПроводкаDSS.CashCode,
	|	ПроводкаDSS.PoNumber,
	|	ПроводкаDSS.LineNbrIc,
	|	ПроводкаDSS.PoCode,
	|	ПроводкаDSS.ItemDescription,
	|	ПроводкаDSS.CustomerNumber,
	|	ПроводкаDSS.CustomerName,
	|	ПроводкаDSS.ArInvoice,
	|	ПроводкаDSS.TaxCode,
	|	ПроводкаDSS.Item,
	|	ПроводкаDSS.DocumentNbr,
	|	ПроводкаDSS.ContractNumber,
	|	ПроводкаDSS.AktOfAcceptance,
	|	ПроводкаDSS.AktDateLawson,
	|	ПроводкаDSS.ApTransFormId,
	|	ПроводкаDSS.КонтрагентLawson,
	|	ПроводкаDSS.Deferred,
	|	ПроводкаDSS.Ответственный,
	|	ПроводкаDSS.Комментарий,
	|	ПроводкаDSS.RubAmount,
	|	ПроводкаDSS.FiscAmount,
	|	ПроводкаDSS.TempDiff,
	|	ПроводкаDSS.PermDiff,
	|	ПроводкаDSS.ExchDiff,
	|	ПроводкаDSS.ТипПроводки,
	|	ПроводкаDSS.Ваучер,
	|	ПроводкаDSS.FiscalDate,
	|	ПроводкаDSS.Urn,
	|	ПроводкаDSS.SubGeoMarket,
	|	ПроводкаDSS.Segment,
	|	ПроводкаDSS.SubSegment,
	|	ПроводкаDSS.SubSubSegment,
	|	ПроводкаDSS.AccountingPeriod
	|ИЗ
	|	Документ.ПроводкаDSS КАК ПроводкаDSS
	|ГДЕ
	|	ПроводкаDSS.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	DSSСвязанныеДокументы.ТипСвязанногоОбъекта,
	|	DSSСвязанныеДокументы.СвязанныйОбъект КАК Ссылка
	|ИЗ
	|	РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументы
	|ГДЕ
	|	DSSСвязанныеДокументы.ПроводкаDSS = &Ссылка";
	
	Возврат ТекстЗапроса;
	
КонецФункции

#КонецЕсли