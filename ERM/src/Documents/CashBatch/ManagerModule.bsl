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
	
	ТекОбъект = PowerBIРегламенты.ПолучитьОбъектИзВнешнегоИсточника("dbo_CashBatch", Операция, Ссылка, ПараметрыЛогирования);
	
	ЗаполнитьОбъектPowerBI(ТекОбъект, Ссылка);
	
	// { RGS AGorlenko 26.03.2020 18:54:23 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник
	НачатьТранзакцию();
	// } RGS AGorlenko 26.03.2020 18:56:47 - S-E-0001488-добавление транзакции для избежания случаев, когда происходит запись в журнал, но не происходит запись во внешний источник
	Если Операция = Перечисления.ОперацииPowerBI.Create Тогда
		PowerBIРегламенты.СформироватьЗаписиЖурналаДокуменовPowerBI(Ссылка, "CashBatch", ПараметрыЛогирования, СтруктураРезультата);
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
		|	CashBatch.ПометкаУдаления,
		|	CashBatch.Номер,
		|	CashBatch.Дата,
		|	ПРЕДСТАВЛЕНИЕ(CashBatch.Source) КАК Source,
		|	CashBatch.Company.БазовыйЭлемент КАК Company,
		|	CashBatch.Client,
		|	CashBatch.Currency,
		|	CashBatch.Amount,
		|	CashBatch.Agreement,
		|	CashBatch.Prepayment,
		|	CashBatch.PaymentDate,
		|	CashBatch.PaymentNumber
		|ИЗ
		|	Документ.CashBatch КАК CashBatch
		|ГДЕ
		|	CashBatch.Ссылка = &Ссылка";
	
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
	Объект.Prepayment = ВыборкаДетальныеЗаписи.Prepayment;
	Объект.PaymentDate = ВыборкаДетальныеЗаписи.PaymentDate;
	Объект.PaymentNumber = ВыборкаДетальныеЗаписи.PaymentNumber;	
	Объект.Amount = ВыборкаДетальныеЗаписи.Amount;
	
КонецПроцедуры
#КонецОбласти

#КонецЕсли

