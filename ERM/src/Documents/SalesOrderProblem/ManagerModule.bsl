#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
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
	
	ТекОбъект = PowerBIРегламенты.ПолучитьОбъектИзВнешнегоИсточника("dbo_SalesOrderProblem", Операция, Ссылка, ПараметрыЛогирования);
	
	ЗаполнитьОбъектPowerBI(ТекОбъект, Ссылка);
	
	// { RGS AGorlenko 26.03.2020 18:54:23 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник
	НачатьТранзакцию();
	// } RGS AGorlenko 26.03.2020 18:56:47 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник
	Если Операция = Перечисления.ОперацииPowerBI.Create Тогда
		PowerBIРегламенты.СформироватьЗаписиЖурналаДокуменовPowerBI(Ссылка, "SalesOrderProblem", ПараметрыЛогирования, СтруктураРезультата);
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
		|	SalesOrderProblem.Ссылка КАК Ссылка,
		|	SalesOrderProblem.ВерсияДанных КАК ВерсияДанных,
		|	SalesOrderProblem.ПометкаУдаления КАК ПометкаУдаления,
		|	SalesOrderProblem.Номер КАК Номер,
		|	SalesOrderProblem.Дата КАК Дата,
		|	SalesOrderProblem.Проведен КАК Проведен,
		|	SalesOrderProblem.SalesOrder КАК SalesOrder,
		|	ПРЕДСТАВЛЕНИЕ(SalesOrderProblem.User) КАК UserName,
		|	ПРЕДСТАВЛЕНИЕ(SalesOrderProblem.Reason) КАК Reason,
		|	ПРЕДСТАВЛЕНИЕ(SalesOrderProblem.Billed) КАК Billed,
		|	SalesOrderProblem.ExpectedDateForInvoice КАК ExpectedDateForInvoice,
		|	ПРЕДСТАВЛЕНИЕ(SalesOrderProblem.EscalateTo) КАК EscalateTo,
		|	ВЫРАЗИТЬ(SalesOrderProblem.Details КАК СТРОКА(1024)) КАК Details,
		|	ВЫРАЗИТЬ(SalesOrderProblem.ResponsiblesList КАК СТРОКА(1024)) КАК ResponsiblesList,
		|	ВЫРАЗИТЬ(SalesOrderProblem.ActionItem КАК СТРОКА(1024)) КАК ActionItem
		|ИЗ
		|	Документ.SalesOrderProblem КАК SalesOrderProblem
		|ГДЕ
		|	SalesOrderProblem.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Объект.DeletionMark = ВыборкаДетальныеЗаписи.ПометкаУдаления;
	Объект.Date = ВыборкаДетальныеЗаписи.Дата;
	Объект.Number = ВыборкаДетальныеЗаписи.Номер;
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.SalesOrder) Тогда
		Объект.DocumentID = ВыборкаДетальныеЗаписи.SalesOrder.УникальныйИдентификатор();
		Объект.DocumentType = PowerBIРегламенты.ПолучитьТипДокумента(ВыборкаДетальныеЗаписи.SalesOrder);
	Иначе
		Объект.DocumentID = NULL;
		Объект.DocumentType = NULL;
	КонецЕсли;
	Объект.UserName = ВыборкаДетальныеЗаписи.UserName;
	Объект.Reason = ВыборкаДетальныеЗаписи.Reason;
	Объект.Billed = ВыборкаДетальныеЗаписи.Billed;
	Объект.ExpectedDateForInvoice = ВыборкаДетальныеЗаписи.ExpectedDateForInvoice;
	Объект.EscalateTo = ВыборкаДетальныеЗаписи.EscalateTo;
	Объект.Details = ВыборкаДетальныеЗаписи.Details;
	Объект.ResponsiblesList = ВыборкаДетальныеЗаписи.ResponsiblesList;
	Объект.ActionItem = ВыборкаДетальныеЗаписи.ActionItem;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли