#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";
	
	ФайлДанных = СтруктураПараметров.ИсточникДанных.Получить();
	
	ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
	СоздатьКаталог(ИмяКаталога);
	ПутьКФайлу = ИмяКаталога + "\DSS.csv";
	ФайлДанных.Записать(ПутьКФайлу);
	
	ПутьСхемы = ИмяКаталога+"\schema.ini";
	ФайлСхемы = Новый ТекстовыйДокумент;
	ФайлСхемы.ДобавитьСтроку("["+ "DSS.csv" +"]" + Символы.ПС + "DecimalSymbol=.");
	//ТекстСхемы = Документы.ЗагрузкаДанныхSalesOrdersDetails.ПолучитьМакет("Макет");
	//ФайлСхемы.УстановитьТекст(ТекстСхемы.ПолучитьТекст());
	ФайлСхемы.Записать(ПутьСхемы, КодировкаТекста.OEM);
	
	Connection = Новый COMОбъект("ADODB.Connection");
	
	Попытка
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1;FMT=Delimited""";
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1;FMT=Delimited""";
			Connection.Open(СтрокаПодключения);
		Исключение
			ВызватьИсключение "Can't open connection! " + ОписаниеОшибки();
		КонецПопытки;		
	КонецПопытки;
	
	rs = Новый COMObject("ADODB.RecordSet");
	
	Стр_SQL = "Select * FROM DSS.csv";
	rs.Open(Стр_SQL, Connection);
	
	СтруктураКолонок = СтруктураПараметров.СтруктураКолонок;
	СоответствиеКолонок = Новый Соответствие;
	Для каждого ЭлементСтруктурыКолонок Из СтруктураКолонок Цикл
		СоответствиеКолонок.Вставить(ЭлементСтруктурыКолонок.ИмяПоля, ЭлементСтруктурыКолонок.ИмяКолонки);
	КонецЦикла;
	
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	
	rs.MoveFirst();
	
	ТекНомерСтроки = 0;
	
	Пока rs.EOF() = 0 Цикл
		
		ТекНомерСтроки = ТекНомерСтроки + 1;
		
		
		СтрокаДанных = ТаблицаДанных.Добавить();
		СтрокаДанных.СтрокаФайла = ТекНомерСтроки;
		
		Для каждого ЭлементСоответствия Из СоответствиеКолонок Цикл
			
			Если ЭлементСоответствия.Значение = "Order Currency" Тогда
				Продолжить;
			КонецЕсли;
			
			Попытка
				ТекЗначение = rs.Fields(ЭлементСоответствия.Значение).Value;
			Исключение
				// TODO RGS AGorlenko 28.06.2016: сделать нормальную обработку BOM
				Попытка
					ТекЗначение = rs.Fields("п»ї" + ЭлементСоответствия.Значение).Value;
				Исключение
					ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ОписаниеОшибки());
					ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
					Возврат;
				КонецПопытки;
			КонецПопытки;
			
			Если ЭлементСоответствия.Ключ = "LawsonCustomerCode" Тогда
				СтрокаДанных.LawsonCustomerCode = Формат(ТекЗначение, "ЧГ=0");
			ИначеЕсли ТипЗнч(ТекЗначение) = ТипЗнч("Строка") Тогда
				СтрокаДанных[ЭлементСоответствия.Ключ] = СокрЛП(ТекЗначение);
			Иначе
				СтрокаДанных[ЭлементСоответствия.Ключ] = ТекЗначение;
			КонецЕсли;
			
		КонецЦикла;
		
		// отдельно Order Currency, т.к. 2 колонки с таким именем
		Для каждого ТекКолонка Из rs.Fields Цикл
			
			Если ТекКолонка.Name = "DSS#csv.Order Currency" Тогда
				Если ТипЗнч(ТекКолонка.Value) = Тип("Строка") Тогда
					СтрокаДанных.OrderCurrency = СокрЛП(ТекКолонка.Value);
				Иначе
					СтрокаДанных.OrderCurrencyAmount = ТекКолонка.Value;
				КонецЕсли;
			КонецЕсли;
			
		КонецЦикла;
		
		rs.MoveNext();
		
	КонецЦикла;
	
	rs.Close();
	Connection.Close();
	
	УдалитьФайлы(ИмяКаталога);
	
	ЗагрузитьИЗаписатьДвижения(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата, ТаблицаДанных);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля);
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Добавить("СтрокаФайла", Новый ОписаниеТипов("Число"));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура ЗагрузитьИЗаписатьДвижения(Ссылка, ДатаДокумента, ТаблицаДанных)
	
	ТаблицаДанных.Колонки.Добавить("ДокументЗагрузки");
	ТаблицаДанных.ЗаполнитьЗначения(Ссылка, "ДокументЗагрузки");
	
	НЗ = РегистрыСведений.SalesOrdersDetailsSourceData.СоздатьНаборЗаписей();
	НЗ.Отбор.ДокументЗагрузки.Установить(Ссылка);
	НЗ.Загрузить(ТаблицаДанных);
	НЗ.Записать(Истина);
	
КонецПроцедуры

Процедура ОбновитьРеквизитыSalesOrders(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	SalesOrdersDetailsSourceData.YearMonth КАК YearMonth,
	|	SalesOrdersDetailsSourceData.BillingAccount,
	|	SalesOrdersDetailsSourceData.BillingAccountID,
	|	SalesOrdersDetailsSourceData.LawsonCustomerCode,
	|	SalesOrdersDetailsSourceData.Agreement,
	|	SalesOrdersDetailsSourceData.AgreementName,
	|	SalesOrdersDetailsSourceData.AgreementStatus,
	|	SalesOrdersDetailsSourceData.AgreementType,
	|	SalesOrdersDetailsSourceData.EffectiveDate,
	|	SalesOrdersDetailsSourceData.ExpirationDate,
	|	SalesOrdersDetailsSourceData.CompanyCode,
	|	SalesOrdersDetailsSourceData.OrderID,
	|	SalesOrdersDetailsSourceData.НомерSO,
	|	SalesOrdersDetailsSourceData.LawsonInvoice,
	|	SalesOrdersDetailsSourceData.CustomerRepresentative,
	|	SalesOrdersDetailsSourceData.ApprovedBy,
	|	SalesOrdersDetailsSourceData.CreatedBy,
	|	SalesOrdersDetailsSourceData.ExchangeRate,
	|	SalesOrdersDetailsSourceData.OrderCurrency,
	|	SalesOrdersDetailsSourceData.CreditMemoReason,
	|	SalesOrdersDetailsSourceData.DualCurrencyStatus,
	|	SalesOrdersDetailsSourceData.EvidenceOfDelivery,
	|	SalesOrdersDetailsSourceData.FTLCreatedBy,
	|	SalesOrdersDetailsSourceData.FTLApproverID,
	|	SalesOrdersDetailsSourceData.LawsonStatus,
	|	SalesOrdersDetailsSourceData.OrderCurrencyAmount,
	|	SalesOrdersDetailsSourceData.OrderUSDAmount,
	|	SalesOrdersDetailsSourceData.OrderJobEndDate,
	|	SalesOrdersDetailsSourceData.OrderCreationDate,
	|	SalesOrdersDetailsSourceData.OrderJobStartDate,
	|	SalesOrdersDetailsSourceData.FieldTicketCreationDate,
	|	SalesOrdersDetailsSourceData.FTLApprovalDate,
	|	SalesOrdersDetailsSourceData.FTLSubmissionDate,
	|	SalesOrdersDetailsSourceData.OrderFirstSubmissionDate,
	|	SalesOrdersDetailsSourceData.RequestToApproveDate,
	|	SalesOrdersDetailsSourceData.OrderApprovalDate,
	|	SalesOrdersDetailsSourceData.AccrueFlagDate,
	|	SalesOrdersDetailsSourceData.InvoiceFlagDate,
	|	SalesOrdersDetailsSourceData.LastUpdatedDate,
	|	SalesOrdersDetailsSourceData.FieldTicket,
	|	SalesOrder.Ссылка КАК SalesOrderСсылка,
	|	ДокументInvoice.Ссылка КАК InvoiceСсылка,
	|	Организации.Ссылка КАК ОрганизацияСсылка,
	|	SalesOrdersDetailsSourceData.YearMonthДата,
	|	ВЫБОР
	|		КОГДА SalesOrdersDetailsSourceData.WellName = ""N/A""
	|			ТОГДА """"
	|		ИНАЧЕ SalesOrdersDetailsSourceData.WellName
	|	КОНЕЦ КАК WellName,
	|	ВЫБОР
	|		КОГДА SalesOrdersDetailsSourceData.FieldName = ""N/A""
	|			ТОГДА """"
	|		ИНАЧЕ SalesOrdersDetailsSourceData.FieldName
	|	КОНЕЦ КАК FieldName,
	|	SalesOrdersDetailsSourceData.ClientContract
	|ПОМЕСТИТЬ ВТ
	|ИЗ
	|	РегистрСведений.SalesOrdersDetailsSourceData КАК SalesOrdersDetailsSourceData
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.SalesOrder КАК SalesOrder
	|		ПО SalesOrdersDetailsSourceData.НомерSO = SalesOrder.Номер
	|			И (НЕ SalesOrder.ПометкаУдаления)
	|			И SalesOrdersDetailsSourceData.CompanyCode = SalesOrder.Company.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Invoice КАК ДокументInvoice
	|		ПО SalesOrdersDetailsSourceData.LawsonInvoice = ДокументInvoice.Номер
	|			И (НЕ ДокументInvoice.ПометкаУдаления)
	|			И SalesOrdersDetailsSourceData.CompanyCode = ДокументInvoice.Company.Код
	|			И (ДокументInvoice.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО SalesOrdersDetailsSourceData.CompanyCode = Организации.Код
	|			И (НЕ Организации.ПометкаУдаления)
	|ГДЕ
	|	SalesOrdersDetailsSourceData.ДокументЗагрузки = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ.YearMonthДата,
	|	ВТ.OrderCurrency
	|ПОМЕСТИТЬ ВТ_Валюта
	|ИЗ
	|	ВТ КАК ВТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ.YearMonthДата,
	|	ВТ.LawsonCustomerCode
	|ПОМЕСТИТЬ ВТ_Клиенты
	|ИЗ
	|	ВТ КАК ВТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Валюта.YearMonthДата,
	|	ВТ_Валюта.OrderCurrency,
	|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_ВалютаМаксимальныеДаты
	|ИЗ
	|	ВТ_Валюта КАК ВТ_Валюта
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ПО ВТ_Валюта.OrderCurrency = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency))
	|			И ВТ_Валюта.YearMonthДата >= НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Валюта.YearMonthДата,
	|	ВТ_Валюта.OrderCurrency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ВалютаМаксимальныеДаты.YearMonthДата,
	|	ВТ_ВалютаМаксимальныеДаты.OrderCurrency,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
	|ПОМЕСТИТЬ ВТ_ВалютыСПриемником
	|ИЗ
	|	ВТ_ВалютаМаксимальныеДаты КАК ВТ_ВалютаМаксимальныеДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ПО ВТ_ВалютаМаксимальныеДаты.Период = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период
	|			И ВТ_ВалютаМаксимальныеДаты.OrderCurrency = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Клиенты.YearMonthДата,
	|	ВТ_Клиенты.LawsonCustomerCode,
	|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_КлиентыПоследниеДаты
	|ИЗ
	|	ВТ_Клиенты КАК ВТ_Клиенты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ПО ВТ_Клиенты.LawsonCustomerCode = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Клиенты.YearMonthДата,
	|	ВТ_Клиенты.LawsonCustomerCode
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_КлиентыПоследниеДаты.YearMonthДата,
	|	ВТ_КлиентыПоследниеДаты.LawsonCustomerCode,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
	|ПОМЕСТИТЬ ВТ_КлиентыСПриемником
	|ИЗ
	|	ВТ_КлиентыПоследниеДаты КАК ВТ_КлиентыПоследниеДаты
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ПО ВТ_КлиентыПоследниеДаты.Период = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период
	|			И ВТ_КлиентыПоследниеДаты.LawsonCustomerCode = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ.YearMonth,
	|	ВТ.BillingAccount,
	|	ВТ.BillingAccountID,
	|	ВТ.LawsonCustomerCode,
	|	ВТ.Agreement,
	|	ВТ.AgreementName,
	|	ВТ.AgreementStatus,
	|	ВТ.AgreementType,
	|	ВТ.EffectiveDate,
	|	ВТ.ExpirationDate,
	|	ВТ.CompanyCode,
	|	ВТ.OrderID,
	|	ВТ.НомерSO,
	|	ВТ.LawsonInvoice,
	|	ВТ.CustomerRepresentative,
	|	ВТ.ApprovedBy,
	|	ВТ.CreatedBy,
	|	ВТ.ExchangeRate,
	|	ВТ.OrderCurrency,
	|	ВТ.CreditMemoReason,
	|	ВТ.DualCurrencyStatus,
	|	ВТ.EvidenceOfDelivery,
	|	ВТ.FTLCreatedBy,
	|	ВТ.FTLApproverID,
	|	ВТ.LawsonStatus,
	|	ВТ.OrderCurrencyAmount,
	|	ВТ.OrderUSDAmount,
	|	ВТ.OrderJobEndDate,
	|	ВТ.OrderCreationDate,
	|	ВТ.OrderJobStartDate,
	|	ВТ.FieldTicketCreationDate,
	|	ВТ.FTLApprovalDate,
	|	ВТ.FTLSubmissionDate,
	|	ВТ.OrderFirstSubmissionDate,
	|	ВТ.RequestToApproveDate,
	|	ВТ.OrderApprovalDate,
	|	ВТ.AccrueFlagDate,
	|	ВТ.InvoiceFlagDate,
	|	ВТ.LastUpdatedDate,
	|	ВТ.FieldTicket,
	|	ВТ.SalesOrderСсылка,
	|	ВТ.InvoiceСсылка,
	|	ВТ.ОрганизацияСсылка,
	|	ВТ.YearMonthДата,
	|	ВТ_ВалютыСПриемником.ОбъектПриемника КАК ВалютаСсылка,
	|	ВТ_КлиентыСПриемником.ОбъектПриемника КАК КлиентСсылка,
	|	ВЫБОР
	|		КОГДА ВТ.WellName <> """"
	|			ТОГДА ВТ.WellName + "" ""
	|		ИНАЧЕ """"
	|	КОНЕЦ + ВТ.FieldName КАК WellData,
	|	ВТ.ClientContract
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВалютыСПриемником КАК ВТ_ВалютыСПриемником
	|		ПО ВТ.YearMonthДата = ВТ_ВалютыСПриемником.YearMonthДата
	|			И ВТ.OrderCurrency = ВТ_ВалютыСПриемником.OrderCurrency
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КлиентыСПриемником КАК ВТ_КлиентыСПриемником
	|		ПО ВТ.YearMonthДата = ВТ_КлиентыСПриемником.YearMonthДата
	|			И ВТ.LawsonCustomerCode = ВТ_КлиентыСПриемником.LawsonCustomerCode";
	
	Запрос.УстановитьПараметр("Ссылка", СтруктураПараметров.Ссылка);
	
	НачатьТранзакцию();
	Выборка = Запрос.Выполнить().Выбрать();
	ЗафиксироватьТранзакцию();
	
	ОбновленныеSO = Новый ТаблицаЗначений;
	ОбновленныеSO.Колонки.Добавить("SalesOrder", Новый ОписаниеТипов("ДокументСсылка.SalesOrder"));
	
	НенайденныеSO = Новый ТаблицаЗначений;
	НенайденныеSO.Колонки.Добавить("SalesOrderNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(17)));
	
	ОбновленныеInvoice = Новый ТаблицаЗначений;
	ОбновленныеInvoice.Колонки.Добавить("Invoice", Новый ОписаниеТипов("ДокументСсылка.Invoice"));
	
	НенайденныеInvoices = Новый ТаблицаЗначений;
	НенайденныеInvoices.Колонки.Добавить("InvoiceNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(12)));
	
	ОшибкиПоискаSO = Новый ТаблицаЗначений;
	ОшибкиПоискаSO.Колонки.Добавить("SalesOrderNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(17)));
	
	ПустаяДата = '00010101';
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ЗначениеЗаполнено(Выборка.SalesOrderСсылка) Тогда
			Если Выборка.LawsonStatus = "Closed" 
				ИЛИ Выборка.LawsonStatus = "Unreleased - Locked in Lawson"
				ИЛИ Выборка.LawsonStatus = "Unreleased in Lawson" Тогда
				СтрокаТЗ = ОшибкиПоискаSO.Добавить();
				СтрокаТЗ.SalesOrderNumber = Выборка.НомерSO;
			Иначе
				СтрокаТЗ = НенайденныеSO.Добавить();
				СтрокаТЗ.SalesOrderNumber = Выборка.НомерSO;
			КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		Если Не ПустаяСтрока(Выборка.LawsonInvoice) И НЕ ЗначениеЗаполнено(Выборка.InvoiceСсылка) Тогда
			
			СтрокаТЗ = НенайденныеInvoices.Добавить();
			СтрокаТЗ.InvoiceNumber = Выборка.LawsonInvoice;
			
		ИначеЕсли ЗначениеЗаполнено(Выборка.InvoiceСсылка) И Не ПустаяСтрока(Выборка.ClientContract) Тогда
			
			ОбъектInvoice = Выборка.InvoiceСсылка.ПолучитьОбъект();
			РГСофтКлиентСервер.УстановитьЗначение(ОбъектInvoice.Agreement, Выборка.ClientContract);
			
			Если ОбъектInvoice.Модифицированность() Тогда
				ОбъектInvoice.ОбменДанными.Загрузка = Истина;
				ОбъектInvoice.Записать();
				СтрокаТЗ = ОбновленныеInvoice.Добавить();
				СтрокаТЗ.Invoice = Выборка.InvoiceСсылка;
			КонецЕсли;
			
		КонецЕсли;
		
		ТекОбъект = Выборка.SalesOrderСсылка.ПолучитьОбъект();
		
		
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementCode, Выборка.Agreement);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Agreement, Выборка.AgreementName);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementStatus, Выборка.AgreementStatus);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementType, Выборка.AgreementType);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Company, Выборка.ОрганизацияСсылка);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ArInvoice, Выборка.LawsonInvoice);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Invoice, Выборка.InvoiceСсылка);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.SiebelOrderId, Выборка.OrderID);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ERPStatus, Выборка.LawsonStatus);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ExchangeRate, Выборка.ExchangeRate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Amount, Выборка.OrderCurrencyAmount);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AmountUSD, Окр(Выборка.OrderCurrencyAmount / Выборка.ExchangeRate, 2));
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.BaseAmount, Выборка.OrderUSDAmount);
		//Если НЕ СтруктураПараметров.ТипЗагрузкиUnbilled Тогда
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Дата, Выборка.OrderCreationDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FieldTicket, Выборка.FieldTicket);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.JobStartDate, Выборка.OrderJobStartDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLCreatedBy, Выборка.FTLCreatedBy);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLApproverID, Выборка.FTLApproverID);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ApprovedBy, Выборка.ApprovedBy);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.CreatedBy, Выборка.CreatedBy);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.WellData, Выборка.WellData);
		//КонецЕсли;
		// DIR Stages
		JobEndDate = Неопределено;
		FTLSubmissionDate = Неопределено;
		CreationDate = Неопределено;
		ApprovalDate = Неопределено;
		FirstSubmissionDate = Неопределено;
		InvoiceFlagDate = Выборка.InvoiceFlagDate;
		
		Если Выборка.OrderFirstSubmissionDate = ПустаяДата Тогда
			FirstSubmissionDate = InvoiceFlagDate;
		Иначе
			FirstSubmissionDate = Выборка.OrderFirstSubmissionDate;
		КонецЕсли;
		
		Если Выборка.OrderApprovalDate = ПустаяДата Тогда
			ApprovalDate = FirstSubmissionDate;
		Иначе
			ApprovalDate = Выборка.OrderApprovalDate;
		КонецЕсли;
		
		Если Выборка.OrderCreationDate = ПустаяДата Тогда
			CreationDate = ApprovalDate;
		Иначе
			CreationDate = Выборка.OrderCreationDate;
		КонецЕсли;
		
		Если Выборка.FTLSubmissionDate = ПустаяДата Тогда
			FTLSubmissionDate = CreationDate;
		Иначе
			FTLSubmissionDate = Выборка.FTLSubmissionDate;
		КонецЕсли;
		
		Если Выборка.OrderJobEndDate = ПустаяДата Тогда
			JobEndDate = FTLSubmissionDate;
		Иначе
			JobEndDate = Выборка.OrderJobEndDate;
		КонецЕсли;
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.JobEndDate, JobEndDate);
		
		//Если НЕ СтруктураПараметров.ТипЗагрузкиUnbilled Тогда
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLSubmissionDate, FTLSubmissionDate);
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.CreationDate, CreationDate);
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ApprovalDate, ApprovalDate);
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FirstSubmissionDate, FirstSubmissionDate);
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.InvoiceFlagDate, InvoiceFlagDate);
		//КонецЕсли;
			
		Если НЕ ЗначениеЗаполнено(Выборка.ВалютаСсылка) Тогда
			ОтменитьТранзакцию();
			ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", Строка(ТекОбъект) + ": Failed to find currency!");
			ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Выборка.КлиентСсылка) Тогда
			ОтменитьТранзакцию();
			ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", Строка(ТекОбъект) + ": Failed to find client!");
			ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
			Возврат;
		КонецЕсли;
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Client, Выборка.КлиентСсылка);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Currency, Выборка.ВалютаСсылка);
		
		Если ТекОбъект.Модифицированность() Тогда
			
			Попытка
				ТекОбъект.Записать();
			Исключение
				ОтменитьТранзакцию();
				ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", Строка(ТекОбъект) + ": " + ОписаниеОшибки());
				ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
				Возврат;
			КонецПопытки;
			СтрокаТЗ = ОбновленныеSO.Добавить();
			СтрокаТЗ.SalesOrder = ТекОбъект.Ссылка;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	ОбновленныеSO.Свернуть("SalesOrder");
	НенайденныеSO.Свернуть("SalesOrderNumber");
	ОбновленныеInvoice.Свернуть("Invoice");
	НенайденныеInvoices.Свернуть("InvoiceNumber");
	ОшибкиПоискаSO.Свернуть("SalesOrderNumber");
	
	ДанныеДляЗаполнения.Вставить("ОбновленныеSO", ОбновленныеSO);
	ДанныеДляЗаполнения.Вставить("НенайденныеSO", НенайденныеSO);
	ДанныеДляЗаполнения.Вставить("ОбновленныеInvoice", ОбновленныеInvoice);
	ДанныеДляЗаполнения.Вставить("НенайденныеInvoices", НенайденныеInvoices);
	ДанныеДляЗаполнения.Вставить("ОшибкиПоискаSO", ОшибкиПоискаSO);
		
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

#КонецЕсли