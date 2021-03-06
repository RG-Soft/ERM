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
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).System = ""AR""
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).SourceCode = ""RM""
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
	|	И (ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""CM""
	|				И (ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""CM_REC""
	|					ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""CMAPP_REC"")
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""DM""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""DM_REC""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""Credit Memos""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""Credit Memo Applications""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Amount > 0
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""DM""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""DMAPP_REC""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Amount < 0)
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
	
	ТекОбъект = PowerBIРегламенты.ПолучитьОбъектИзВнешнегоИсточника("dbo_Memo", Операция, Ссылка, ПараметрыЛогирования);
	
	ЗаполнитьОбъектPowerBI(ТекОбъект, Ссылка);
	
	// { RGS AGorlenko 26.03.2020 18:54:23 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник
	НачатьТранзакцию();
	// } RGS AGorlenko 26.03.2020 18:56:47 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник
	Если Операция = Перечисления.ОперацииPowerBI.Create Тогда
		PowerBIРегламенты.СформироватьЗаписиЖурналаДокуменовPowerBI(Ссылка, "Memo", ПараметрыЛогирования, СтруктураРезультата);
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(СтруктураРезультата.Сообщение) Тогда
		PowerBIРегламенты.ЗаписатьОбъектВоВнешнийИсточник(ТекОбъект, ПараметрыЛогирования, СтруктураРезультата);
	КонецЕсли;
	// { RGS AGorlenko 26.03.2020 18:54:23 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник
	ЗафиксироватьТранзакцию();
	// } RGS AGorlenko 26.03.2020 18:56:47 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник

	Если НЕ ЗначениеЗаполнено(СтруктураРезультата.Сообщение) Тогда
		СтруктураРезультата.Результат = Истина;
	КонецЕсли;
	
	Возврат СтруктураРезультата;
	
КонецФункции

Процедура ЗаполнитьОбъектPowerBI(Объект, Ссылка)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	Memo.ПометкаУдаления,
		|	Memo.Номер,
		|	Memo.Дата,
		|	ПРЕДСТАВЛЕНИЕ(Memo.Source) КАК Source,
		|	Memo.Company.БазовыйЭлемент КАК Company,
		|	Memo.Client,
		|	Memo.Currency,
		|	Memo.Amount,
		|	Memo.Agreement
		|ИЗ
		|	Документ.Memo КАК Memo
		|ГДЕ
		|	Memo.Ссылка = &Ссылка";
	
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
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Currency) Тогда
		Объект.CurrencyID = Строка(ВыборкаДетальныеЗаписи.Currency.УникальныйИдентификатор());
	Иначе
		Объект.CurrencyID = NULL;
	КонецЕсли;
	Объект.Agreement = ВыборкаДетальныеЗаписи.Agreement;
	Объект.Amount = ВыборкаДетальныеЗаписи.Amount;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли