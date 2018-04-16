#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	
	ПараметрыПроведения.Вставить("СвязанныеДокументы", Новый Структура("SalesOrder, Invoice, CashBatch, BatchAllocation, РучнаяКорректировка, Memo"));
	
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
		ИначеЕсли СтрокаСвязанногоДокумента.ТипСвязанногоОбъекта = Перечисления.ТипыОбъектовСвязанныхСПроводкойDSS.Memo Тогда
			ПараметрыПроведения.СвязанныеДокументы.Memo = СтрокаСвязанногоДокумента.Ссылка;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПараметрыПроведения;
	
КонецФункции

Функция ТекстЗапросаПарамтерыПроведения(НомераТаблиц)
	
	НомераТаблиц.Вставить("Реквизиты",                       НомераТаблиц.Количество());
	НомераТаблиц.Вставить("СвязанныеДокументы",              НомераТаблиц.Количество());
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ТранзакцияOracle.Номер,
	|	ТранзакцияOracle.Дата,
	|	ТранзакцияOracle.GlSourceType,
	|	ТранзакцияOracle.Company,
	|	ТранзакцияOracle.Account,
	|	ТранзакцияOracle.Location,
	|	ТранзакцияOracle.SubSubSegment,
	|	ТранзакцияOracle.Currency,
	|	ТранзакцияOracle.ExchangeRate,
	|	ТранзакцияOracle.GL_Account,
	|	ТранзакцияOracle.Client,
	|	ТранзакцияOracle.Contract,
	|	ТранзакцияOracle.DocType,
	|	ТранзакцияOracle.Description,
	|	ТранзакцияOracle.TransType,
	|	ТранзакцияOracle.SONum,
	|	ТранзакцияOracle.SODate,
	|	ТранзакцияOracle.ShipDateActual,
	|	ТранзакцияOracle.CreationDate,
	|	ТранзакцияOracle.CreatedBy,
	|	ТранзакцияOracle.DocID,
	|	ТранзакцияOracle.LineID,
	|	ТранзакцияOracle.Amount,
	|	ТранзакцияOracle.BaseAmount,
	|	ТранзакцияOracle.Source,
	|	ТранзакцияOracle.AU,
	|	ТранзакцияOracle.Account.БазовыйЭлемент КАК HFMAccount,
	|	ТранзакцияOracle.LegalEntity
	|ИЗ
	|	Документ.ТранзакцияOracle КАК ТранзакцияOracle
	|ГДЕ
	|	ТранзакцияOracle.Ссылка = &Ссылка
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