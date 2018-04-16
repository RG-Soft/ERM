#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	
	ДанныеДляЗаполнения = Новый Структура();
	СтруктураКолонок = СтруктураПараметров.СтруктураКолонок;
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	ТекстОшибки = "";
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsb");
	ФайлЭксель = СтруктураПараметров.ИсточникДанных.Получить();
	ФайлЭксель.Записать(ПутьКФайлу);
	
	УдалитьШапкуФайла(ПутьКФайлу, СтруктураПараметров);
	
	rgsЗагрузкаИзExcel.ВыгрузитьЭксельВТаблицуДанныхПоИменамКолонок(ПутьКФайлу, ТаблицаДанных, ДанныеДляЗаполнения, АдресХранилища, СтруктураПараметров);
	
	ЗагрузитьИЗаписатьДвижения(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата, ТаблицаДанных);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция ПолучитьСтруктуруКолонокТаблицыДанных() Экспорт
	
	СтруктураКолонок = Новый ТаблицаЗначений;
	СтруктураКолонок.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("ИмяКолонки", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("Обязательная", Новый ОписаниеТипов("Булево"));
	
	ПолучитьСтруктуруКолонокТаблицыДанныхSODetails(СтруктураКолонок);
	
	Возврат СтруктураКолонок;
	
КонецФункции

Процедура ПолучитьСтруктуруКолонокТаблицыДанныхSODetails(СтруктураКолонок)
	
	// Order Number
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "НомерSO";
	СтрокаТЗ.ИмяКолонки = "Order Number";
	//СтрокаТЗ.НомерКолонки = 1;
	
	//// YearMonth
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "YearMonth";
	//СтрокаТЗ.ИмяКолонки = "YearMonth";
	//
	//// BillingAccount
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "BillingAccount";
	//СтрокаТЗ.ИмяКолонки = "Billing Account";
	//
	//// BillingAccountID
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "BillingAccountID";
	//СтрокаТЗ.ИмяКолонки = "Billing Account ID";
	//
	// Customer Number
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerNumber";
	СтрокаТЗ.ИмяКолонки = "Customer Number";
	
	// Agreement
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Agreement";
	СтрокаТЗ.ИмяКолонки = "Agreement";
	
	//// AgreementName
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "AgreementName";
	//СтрокаТЗ.ИмяКолонки = "Agreement Name";
	//
	//// Agreement Status
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "AgreementStatus";
	//СтрокаТЗ.ИмяКолонки = "Agreement Status";
	//
	//// Agreement Type
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "AgreementType";
	//СтрокаТЗ.ИмяКолонки = "Agreement Type";
	//
	//// Effective Date
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "EffectiveDate";
	//СтрокаТЗ.ИмяКолонки = "Effective Date";
	//
	//// Expiration Date
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "ExpirationDate";
	//СтрокаТЗ.ИмяКолонки = "Expiration Date";
	
	// COMPANY
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyCode";
	СтрокаТЗ.ИмяКолонки = "COMPANY";
	
	//// Order ID
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "OrderID";
	//СтрокаТЗ.ИмяКолонки = "Order ID";
	
	// DOC_ID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DOC_ID";
	СтрокаТЗ.ИмяКолонки = "DOC_ID";
	
	// Customer Name
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerRepresentative";
	СтрокаТЗ.ИмяКолонки = "Customer Name";
	
	// ApprovedBy
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ApprovedBy";
	СтрокаТЗ.ИмяКолонки = "ApprovedBy";
	
	// CreatedBy
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreatedBy";
	СтрокаТЗ.ИмяКолонки = "CreatedBy";
	
	//// Exchange Rate
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "ExchangeRate";
	//СтрокаТЗ.ИмяКолонки = "Exchange Rate";
	
	// Currency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Currency";
	СтрокаТЗ.ИмяКолонки = "Currency";
	
	//// Credit Memo Reason
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "CreditMemoReason";
	//СтрокаТЗ.ИмяКолонки = "Credit Memo Reason";
	//
	//// Dual Currency Status
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "DualCurrencyStatus";
	//СтрокаТЗ.ИмяКолонки = "Dual Currency Status";
	//
	//// Evidence Of Delivery
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "EvidenceOfDelivery";
	//СтрокаТЗ.ИмяКолонки = "Evidence Of Delivery";
	
	// FTLCreatedBy
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FTLCreatedBy";
	СтрокаТЗ.ИмяКолонки = "FTLCreatedBy";
	
	//// FTL Approver ID
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "FTLApproverID";
	//СтрокаТЗ.ИмяКолонки = "FTL Approver ID";
	//
	// ERPStatus
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ERPStatus";
	СтрокаТЗ.ИмяКолонки = "ERPStatus";
	
	//// Order Currency
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "OrderCurrencyAmount";
	//СтрокаТЗ.ИмяКолонки = "Order Currency";
	//
	//// Order (USD)
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "OrderUSDAmount";
	//СтрокаТЗ.ИмяКолонки = "Order (USD)";
	
	//JobEndDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "JobEndDate";
	СтрокаТЗ.ИмяКолонки = "JobEndDate";
	
	// CreationDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreationDate";
	СтрокаТЗ.ИмяКолонки = "CreationDate";
	
	//// Order Job Start Date
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "OrderJobStartDate";
	//СтрокаТЗ.ИмяКолонки = "Order Job Start Date";
	//
	//// Field Ticket Creation Date
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "FieldTicketCreationDate";
	//СтрокаТЗ.ИмяКолонки = "Field Ticket Creation Date";
	//
	//// FTL Approval Date
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "FTLApprovalDate";
	//СтрокаТЗ.ИмяКолонки = "FTL Approval Date";
	
	// FTLSubmissionDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FTLSubmissionDate";
	СтрокаТЗ.ИмяКолонки = "FTLSubmissionDate";
	
	// FirstSubmissionDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FirstSubmissionDate";
	СтрокаТЗ.ИмяКолонки = "FirstSubmissionDate";
	
	// DestWell
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "WellData";
	СтрокаТЗ.ИмяКолонки = "DestWell";
	
	// ApprovalDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ApprovalDate";
	СтрокаТЗ.ИмяКолонки = "ApprovalDate";
	
	//
	// InvoiceFlagDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceFlagDate";
	СтрокаТЗ.ИмяКолонки = "InvoiceFlagDate";
	
	//ShipmentDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ShipmentDate";
	СтрокаТЗ.ИмяКолонки = "ShipmentDate";
	
	// FieldTicket
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FieldTicket";
	СтрокаТЗ.ИмяКолонки = "FieldTicket";
	
	// Invoice Amount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAmount";
	СтрокаТЗ.ИмяКолонки = "Invoice Amount";
	
КонецПроцедуры

Процедура УдалитьШапкуФайла(ПутьКФайлу, СтруктураПараметров)
	
	ЭкземплярExcel = Новый COMОбъект("Excel.Application");
	Книга = ЭкземплярExcel.Application.Workbooks.Open(ПутьКФайлу);
	
	ИмяЛиста = СтруктураПараметров.ЛистФайла;
	Если Прав(ИмяЛиста, 1) = "$" Тогда
		ИмяЛиста = Лев(ИмяЛиста, СтрДлина(ИмяЛиста) - 1);
	КонецЕсли;
	
	Лист = ЭкземплярExcel.Worksheets(ИмяЛиста);
	
	// в качестве ориентиров будем использовать колонки SOURCE_SYSTEM, GL_ACCOUNT, ID_ORIG
	НомерСтрокиЗаголовка = 1;
	
	Для ТекНомерСтроки = 1 По 100 Цикл
		
		НайденаOrderNumber = Ложь;
		//НайденаGlAccount = Ложь;
		НайденаDOC_ID = Ложь;
		
		Для ТекНомерСтолбца = 1 По 100 Цикл
			
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "Order Number" Тогда
				НайденаOrderNumber = Истина;
			КонецЕсли;
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "DOC_ID" Тогда
				НайденаDOC_ID = Истина;
			КонецЕсли;
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "ID_ORIG" Тогда
				НайденаIdOrig = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НайденаOrderNumber И НайденаDOC_ID Тогда
			НомерСтрокиЗаголовка = ТекНомерСтроки;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НомерСтрокиЗаголовка > 1 Тогда
		
		СтрокиДляУдаления = Лист.Rows("1:" + Строка(НомерСтрокиЗаголовка - 1));
		СтрокиДляУдаления.Delete();
		//Книга.SaveAs(ПутьКФайлу);
		Книга.Save();
		
	КонецЕсли;
	
	ЭкземплярExcel.Quit();
	ЭкземплярExcel = Неопределено;
	
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
	
	НЗ = РегистрыСведений.OracleSalesOrdersDetailsSourceData.СоздатьНаборЗаписей();
	НЗ.Отбор.ДокументЗагрузки.Установить(Ссылка);
	НЗ.Загрузить(ТаблицаДанных);
	НЗ.Записать(Истина);
	
КонецПроцедуры

Процедура ОбновитьРеквизитыSalesOrders(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	OracleSalesOrdersDetailsSourceData.ДокументЗагрузки КАК ДокументЗагрузки,
	|	OracleSalesOrdersDetailsSourceData.НомерSO КАК НомерSO,
	|	OracleSalesOrdersDetailsSourceData.CustomerNumber КАК CustomerNumber,
	|	OracleSalesOrdersDetailsSourceData.Agreement КАК Agreement,
	|	OracleSalesOrdersDetailsSourceData.CompanyCode КАК CompanyCode,
	|	OracleSalesOrdersDetailsSourceData.CustomerRepresentative КАК CustomerRepresentative,
	|	OracleSalesOrdersDetailsSourceData.ApprovedBy КАК ApprovedBy,
	|	OracleSalesOrdersDetailsSourceData.CreatedBy КАК CreatedBy,
	|	OracleSalesOrdersDetailsSourceData.Currency КАК Currency,
	|	OracleSalesOrdersDetailsSourceData.FTLCreatedBy КАК FTLCreatedBy,
	|	ВЫБОР
	|		КОГДА OracleSalesOrdersDetailsSourceData.ERPStatus ПОДОБНО ""%CANCELLED%""
	|			ТОГДА 3
	|		КОГДА OracleSalesOrdersDetailsSourceData.ERPStatus ПОДОБНО ""%CLOSED%""
	|			ТОГДА 2
	|		ИНАЧЕ 1
	|	КОНЕЦ КАК ERPStatus,
	|	OracleSalesOrdersDetailsSourceData.JobEndDate КАК JobEndDate,
	|	OracleSalesOrdersDetailsSourceData.CreationDate КАК CreationDate,
	|	OracleSalesOrdersDetailsSourceData.FTLSubmissionDate КАК FTLSubmissionDate,
	|	OracleSalesOrdersDetailsSourceData.FirstSubmissionDate КАК FirstSubmissionDate,
	|	OracleSalesOrdersDetailsSourceData.ApprovalDate КАК ApprovalDate,
	|	OracleSalesOrdersDetailsSourceData.InvoiceFlagDate КАК InvoiceFlagDate,
	|	OracleSalesOrdersDetailsSourceData.FieldTicket КАК FieldTicket,
	|	OracleSalesOrdersDetailsSourceData.DOC_ID КАК DOC_ID,
	|	OracleSalesOrdersDetailsSourceData.ShipmentDate,
	|	OracleSalesOrdersDetailsSourceData.InvoiceAmount,
	|	OracleSalesOrdersDetailsSourceData.WellData
	|ПОМЕСТИТЬ Исходники
	|ИЗ
	|	РегистрСведений.OracleSalesOrdersDetailsSourceData КАК OracleSalesOrdersDetailsSourceData
	|ГДЕ
	|	OracleSalesOrdersDetailsSourceData.ДокументЗагрузки = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Исходники.ДокументЗагрузки КАК ДокументЗагрузки,
	|	Исходники.НомерSO КАК НомерSO,
	|	Исходники.CustomerNumber КАК CustomerNumber,
	|	Исходники.Agreement КАК Agreement,
	|	Исходники.CompanyCode КАК CompanyCode,
	|	Исходники.CustomerRepresentative КАК CustomerRepresentative,
	|	Исходники.ApprovedBy КАК ApprovedBy,
	|	Исходники.CreatedBy КАК CreatedBy,
	|	Исходники.Currency КАК Currency,
	|	Исходники.FTLCreatedBy КАК FTLCreatedBy,
	|	Исходники.ERPStatus КАК ERPStatus,
	|	Исходники.JobEndDate КАК JobEndDate,
	|	Исходники.CreationDate КАК CreationDate,
	|	Исходники.FTLSubmissionDate КАК FTLSubmissionDate,
	|	Исходники.FirstSubmissionDate КАК FirstSubmissionDate,
	|	Исходники.ApprovalDate КАК ApprovalDate,
	|	Исходники.InvoiceFlagDate КАК InvoiceFlagDate,
	|	Исходники.FieldTicket КАК FieldTicket,
	|	Исходники.DOC_ID КАК DOC_ID,
	// { RGS TAlmazova 22.03.2018 15:48:22 - Суммы инвойсов заполняются загрузкой оборотов
	//|	ДокInvoice.Ссылка КАК СсылкаInvoice,
	// } RGS TAlmazova 22.03.2018 15:48:23 - Суммы инвойсов заполняются загрузкой оборотов
	|	SalesOrder.Ссылка КАК СсылкаSalesOrder,
	|	Организации.Ссылка КАК СсылкаОрганизация,
	|	Исходники.ShipmentDate,
	|	Исходники.InvoiceAmount,
	|	Исходники.WellData
	|ПОМЕСТИТЬ ИсходникиСсылки
	|ИЗ
	|	Исходники КАК Исходники
	// { RGS TAlmazova 22.03.2018 15:47:46 - Суммы инвойсов заполняются загрузкой оборотов
	//|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Invoice КАК ДокInvoice
	//|		ПО Исходники.DOC_ID = ДокInvoice.DocID
	//|			И (НЕ ДокInvoice.ПометкаУдаления)
	//|			И (Исходники.DOC_ID <> 0)
	// } RGS TAlmazova 22.03.2018 15:47:57 - Суммы инвойсов заполняются загрузкой оборотов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.SalesOrder КАК SalesOrder
	|		ПО Исходники.НомерSO = SalesOrder.Номер
	|			И Исходники.CompanyCode = SalesOrder.Company.Код
	|			И (НЕ SalesOrder.ПометкаУдаления)
	|			И (SalesOrder.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО Исходники.CompanyCode = Организации.Код
	|			И (НЕ Организации.ПометкаУдаления)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИсходникиСсылки.CustomerNumber
	|ПОМЕСТИТЬ КлиентыБезДублей
	|ИЗ
	|	ИсходникиСсылки КАК ИсходникиСсылки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ИсходникиСсылки.Currency
	|ПОМЕСТИТЬ ВалютаБезДублей
	|ИЗ
	|	ИсходникиСсылки КАК ИсходникиСсылки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВалютаБезДублей.Currency,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
	|ПОМЕСТИТЬ ВалютыСсылка
	|ИЗ
	|	ВалютаБезДублей КАК ВалютаБезДублей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
	|		ПО ВалютаБезДублей.Currency = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор
	|ГДЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлиентыБезДублей.CustomerNumber,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
	|ПОМЕСТИТЬ КлиентыСсылка
	|ИЗ
	|	КлиентыБезДублей КАК КлиентыБезДублей
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
	|		ПО КлиентыБезДублей.CustomerNumber = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор
	|ГДЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ИсходникиСсылки.ДокументЗагрузки,
	|	ИсходникиСсылки.НомерSO,
	|	ИсходникиСсылки.CustomerNumber,
	|	ИсходникиСсылки.Agreement,
	|	ИсходникиСсылки.CompanyCode,
	|	ИсходникиСсылки.CustomerRepresentative,
	|	ИсходникиСсылки.ApprovedBy,
	|	ИсходникиСсылки.CreatedBy,
	|	ИсходникиСсылки.Currency,
	|	ИсходникиСсылки.FTLCreatedBy,
	|	МИНИМУМ(ИсходникиСсылки.ERPStatus) КАК ERPStatus,
	|	ИсходникиСсылки.JobEndDate,
	|	ИсходникиСсылки.CreationDate,
	|	ИсходникиСсылки.FTLSubmissionDate,
	|	ИсходникиСсылки.FirstSubmissionDate,
	|	ИсходникиСсылки.ApprovalDate,
	|	ИсходникиСсылки.InvoiceFlagDate,
	|	ИсходникиСсылки.FieldTicket,
	|	ИсходникиСсылки.DOC_ID,
	// { RGS TAlmazova 22.03.2018 16:52:08 - Суммы инвойсов заполняются загрузкой оборотов
	//|	ИсходникиСсылки.СсылкаInvoice,
	// } RGS TAlmazova 22.03.2018 16:52:09 - Суммы инвойсов заполняются загрузкой оборотов
	|	ИсходникиСсылки.СсылкаSalesOrder,
	|	ИсходникиСсылки.СсылкаОрганизация,
	|	ВалютыСсылка.ОбъектПриемника КАК СсылкаВалюта,
	|	КлиентыСсылка.ОбъектПриемника КАК СсылкаКлиент,
	|	ИсходникиСсылки.ShipmentDate,
	|	ИсходникиСсылки.InvoiceAmount,
	|	ИсходникиСсылки.WellData
	|ИЗ
	|	ИсходникиСсылки КАК ИсходникиСсылки
	|		ЛЕВОЕ СОЕДИНЕНИЕ КлиентыСсылка КАК КлиентыСсылка
	|		ПО ИсходникиСсылки.CustomerNumber = КлиентыСсылка.CustomerNumber
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВалютыСсылка КАК ВалютыСсылка
	|		ПО ИсходникиСсылки.Currency = ВалютыСсылка.Currency
	|
	|СГРУППИРОВАТЬ ПО
	|	ИсходникиСсылки.CustomerNumber,
	|	ИсходникиСсылки.ДокументЗагрузки,
	|	ИсходникиСсылки.CustomerRepresentative,
	|	ИсходникиСсылки.НомерSO,
	|	ИсходникиСсылки.ApprovedBy,
	|	ИсходникиСсылки.CreatedBy,
	|	ИсходникиСсылки.Agreement,
	|	ИсходникиСсылки.Currency,
	|	ИсходникиСсылки.JobEndDate,
	|	ИсходникиСсылки.FTLCreatedBy,
	|	ИсходникиСсылки.CreationDate,
	|	ИсходникиСсылки.FirstSubmissionDate,
	|	ИсходникиСсылки.ApprovalDate,
	// { RGS TAlmazova 22.03.2018 16:52:24 - Суммы инвойсов заполняются загрузкой оборотов
	//|	ИсходникиСсылки.СсылкаInvoice,
	// } RGS TAlmazova 22.03.2018 16:52:25 - Суммы инвойсов заполняются загрузкой оборотов
	|	ИсходникиСсылки.FTLSubmissionDate,
	|	ВалютыСсылка.ОбъектПриемника,
	|	ИсходникиСсылки.FieldTicket,
	|	ИсходникиСсылки.InvoiceFlagDate,
	|	ИсходникиСсылки.СсылкаSalesOrder,
	|	ИсходникиСсылки.СсылкаОрганизация,
	|	КлиентыСсылка.ОбъектПриемника,
	|	ИсходникиСсылки.WellData,
	|	ИсходникиСсылки.ShipmentDate,
	|	ИсходникиСсылки.DOC_ID,
	|	ИсходникиСсылки.InvoiceAmount,
	|	ИсходникиСсылки.CompanyCode";
	
	Запрос.УстановитьПараметр("Ссылка", СтруктураПараметров.Ссылка);
	
	НачатьТранзакцию();
	Выборка = Запрос.Выполнить().Выбрать();
	ЗафиксироватьТранзакцию();
	
	ОбновленныеSO = Новый ТаблицаЗначений;
	ОбновленныеSO.Колонки.Добавить("SalesOrder", Новый ОписаниеТипов("ДокументСсылка.SalesOrder"));
	
	НенайденныеSO = Новый ТаблицаЗначений;
	НенайденныеSO.Колонки.Добавить("SalesOrderNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(17)));
	
	НенайденныеInvoices = Новый ТаблицаЗначений;
	НенайденныеInvoices.Колонки.Добавить("InvoiceDOC_ID", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(12)));
	
	ОбновленныеInvoice = Новый ТаблицаЗначений;
	ОбновленныеInvoice.Колонки.Добавить("Invoice", Новый ОписаниеТипов("ДокументСсылка.Invoice", , , , Новый КвалификаторыСтроки(17)));
	
	ПустаяДата = '00010101';
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		// { RGS TAlmazova 22.03.2018 15:46:11 - Суммы инвойсов заполняются при загрузке оборотов
		//Если Не ПустаяСтрока(Выборка.DOC_ID) Тогда
		//	Если НЕ ЗначениеЗаполнено(Выборка.СсылкаInvoice) Тогда
		//		СтрокаТЗ = НенайденныеInvoices.Добавить();
		//		СтрокаТЗ.InvoiceDOC_ID = Выборка.DOC_ID;
		//	Иначе
		//		ТекОбъектИнвойс = Выборка.СсылкаInvoice.ПолучитьОбъект();
		//		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъектИнвойс.Amount, Выборка.InvoiceAmount);
		//		Если ТекОбъектИнвойс.Модифицированность() Тогда
		//			Попытка
		//			ТекОбъектИнвойс.Записать();
		//			Исключение
		//				ОтменитьТранзакцию();
		//				ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", Строка(ТекОбъектИнвойс) + ": " + ОписаниеОшибки());
		//				ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
		//				Возврат;
		//			КонецПопытки;
		//			СтрокаТЗ = ОбновленныеInvoice.Добавить();
		//			СтрокаТЗ.Invoice = ТекОбъектИнвойс.Ссылка;
		//		КонецЕсли;
		//	КонецЕсли;
		//КонецЕсли;
		// } RGS TAlmazova 22.03.2018 15:46:22 - Суммы инвойсов заполняются при загрузке оборотов
		
		Если Не ЗначениеЗаполнено(Выборка.СсылкаSalesOrder) Тогда
			//Если Выборка.LawsonStatus = "Closed" 
			//	ИЛИ Выборка.LawsonStatus = "Unreleased - Locked in Lawson"
			//	ИЛИ Выборка.LawsonStatus = "Unreleased in Lawson" Тогда
			//	СтрокаТЗ = ОшибкиПоискаSO.Добавить();
			//	СтрокаТЗ.SalesOrderNumber = Выборка.НомерSO;
			//Иначе
				СтрокаТЗ = НенайденныеSO.Добавить();
				СтрокаТЗ.SalesOrderNumber = Выборка.НомерSO;
			//КонецЕсли;
			Продолжить;
		КонецЕсли;
		
		ТекОбъект = Выборка.СсылкаSalesOrder.ПолучитьОбъект();
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Дата, Выборка.CreationDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Agreement, Выборка.Agreement);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Agreement, Выборка.AgreementName);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementStatus, Выборка.AgreementStatus);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementType, Выборка.AgreementType);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Company, Выборка.СсылкаОрганизация);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ArInvoice, Выборка.LawsonInvoice);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Invoice,?(ЗначениеЗаполнено(Выборка.СсылкаInvoice), Выборка.СсылкаInvoice, Документы.Invoice.ПустаяСсылка()));
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.SiebelOrderId, Выборка.OrderID);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FieldTicket, Выборка.FieldTicket);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.JobStartDate, Выборка.OrderJobStartDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ERPStatus, Выборка.ERPStatus);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLCreatedBy, Выборка.FTLCreatedBy);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLApproverID, Выборка.FTLApproverID);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ApprovedBy, Выборка.ApprovedBy);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.CreatedBy, Выборка.CreatedBy);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.WellData, Выборка.WellData);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ExchangeRate, Выборка.ExchangeRate);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Amount, Выборка.OrderCurrencyAmount);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AmountUSD, Окр(Выборка.OrderCurrencyAmount / Выборка.ExchangeRate, 2));
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.BaseAmount, Выборка.OrderUSDAmount);
		
		// DIR Stages
		JobEndDate = Неопределено;
		FTLSubmissionDate = Неопределено;
		CreationDate = Неопределено;
		ApprovalDate = Неопределено;
		FirstSubmissionDate = Неопределено;
		InvoiceFlagDate = Выборка.InvoiceFlagDate;
		
		
		Если Выборка.FirstSubmissionDate = ПустаяДата Тогда
			FirstSubmissionDate = InvoiceFlagDate;
		Иначе
			FirstSubmissionDate = Выборка.FirstSubmissionDate;
		КонецЕсли;
		
		Если Выборка.ApprovalDate = ПустаяДата Тогда
			ApprovalDate = FirstSubmissionDate;
		Иначе
			ApprovalDate = Выборка.ApprovalDate;
		КонецЕсли;
		
		Если Выборка.CreationDate = ПустаяДата Тогда
			CreationDate = ApprovalDate;
		Иначе
			CreationDate = Выборка.CreationDate;
		КонецЕсли;
		
		Если Выборка.FTLSubmissionDate = ПустаяДата Тогда
			FTLSubmissionDate = CreationDate;
		Иначе
			FTLSubmissionDate = Выборка.FTLSubmissionDate;
		КонецЕсли;
		
		Если Выборка.JobEndDate = ПустаяДата Тогда
			JobEndDate = FTLSubmissionDate;
		Иначе
			JobEndDate = Выборка.JobEndDate;
		КонецЕсли;
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.JobEndDate, JobEndDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLSubmissionDate, FTLSubmissionDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.CreationDate, CreationDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ApprovalDate, ApprovalDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FirstSubmissionDate, FirstSubmissionDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.InvoiceFlagDate, InvoiceFlagDate);
		
		Если НЕ ЗначениеЗаполнено(Выборка.СсылкаВалюта) Тогда
			ОтменитьТранзакцию();
			ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", Строка(ТекОбъект) + ": Failed to find currency!");
			ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
			Возврат;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Выборка.СсылкаКлиент) Тогда
			ОтменитьТранзакцию();
			ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", Строка(ТекОбъект) + ": Failed to find client!");
			ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
			Возврат;
		КонецЕсли;
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Client, Выборка.СсылкаКлиент);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Currency, Выборка.СсылкаВалюта);
		
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
		
		// { RGS TAlmazova 23.01.2017 15:00:33 - обновление комментария для СО
		ОбновитьСтатусСО(Выборка.СсылкаSalesOrder, Выборка.ERPStatus, Выборка.ShipmentDate, ТекстОшибки);
		Если ТекстОшибки <> "" Тогда
			ОтменитьТранзакцию();
			ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ТекстОшибки);
			ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
			Возврат;
		КонецЕсли;
		// } RGS TAlmazova 23.01.2017 15:00:44 - обновление комментария для СО
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	ОбновленныеSO.Свернуть("SalesOrder");
	НенайденныеSO.Свернуть("SalesOrderNumber");
	НенайденныеInvoices.Свернуть("InvoiceDOC_ID");
	ОбновленныеInvoice.Свернуть("Invoice");
	
	ДанныеДляЗаполнения.Вставить("ОбновленныеSO", ОбновленныеSO);
	ДанныеДляЗаполнения.Вставить("НенайденныеSO", НенайденныеSO);
	ДанныеДляЗаполнения.Вставить("НенайденныеInvoices", НенайденныеInvoices);
	ДанныеДляЗаполнения.Вставить("ОбновленныеInvoice", ОбновленныеInvoice);
		
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ОбновитьСтатусСО(SalesOrder, ERPStatus, ShipmentDate, ТекстОшибки)
	
	ТекущаяДата = ТекущаяДата();
	НачалоМесТекДата = НачалоМесяца(ТекущаяДата);
	ПустаяДата = '00010101';
	
	AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
	
	НЗSOComments = РегистрыСведений.SalesOrdersComments.СоздатьНаборЗаписей();
	НЗSOComments.Отбор.Период.Установить(ТекущаяДата);
	
	//Если ВРег(ERPStatus) = "CANCELLED" Тогда
	//	 BilledStatus = Перечисления.SalesOrderBilledStatus.Canceled;
	// ИначеЕсли ВРег(ERPStatus) = "CLOSED" И ShipmentDate <> ПустаяДата Тогда
	//	 BilledStatus = Перечисления.SalesOrderBilledStatus.Billed;
	// Иначе
	//	 BilledStatus = Перечисления.SalesOrderBilledStatus.Unbilled;
	//КонецЕсли;
	Если ERPStatus = 3 Тогда
		 BilledStatus = Перечисления.SalesOrderBilledStatus.Canceled;
	 ИначеЕсли ERPStatus = 2 И ShipmentDate <> ПустаяДата Тогда
		 BilledStatus = Перечисления.SalesOrderBilledStatus.Billed;
	 Иначе
		 BilledStatus = Перечисления.SalesOrderBilledStatus.Unbilled;
	КонецЕсли;
	
	Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	SalesOrdersCommentsСрезПоследних.Problem,
			|	SalesOrdersCommentsСрезПоследних.Problem.Reason КАК Reason,
			|	SalesOrdersCommentsСрезПоследних.Problem.Billed КАК Billed,
			|	SalesOrdersCommentsСрезПоследних.Problem.ExpectedDateForInvoice КАК ExpectedDateForInvoice,
			|	SalesOrdersCommentsСрезПоследних.Problem.EscalateTo КАК EscalateTo,
			|	SalesOrdersCommentsСрезПоследних.Problem.Details КАК Details,
			|	SalesOrdersCommentsСрезПоследних.Период,
			|	SalesOrdersCommentsСрезПоследних.Problem.User КАК User,
			|	SalesOrdersCommentsСрезПоследних.Problem.ActionItem КАК ActionItem
			|ИЗ
			|	РегистрСведений.SalesOrdersComments.СрезПоследних(, SalesOrder = &SalesOrder) КАК SalesOrdersCommentsСрезПоследних";
		
		Запрос.УстановитьПараметр("SalesOrder", SalesOrder);
		
		НачатьТранзакцию();
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		ЗафиксироватьТранзакцию();
		
		НЗSOComments.Очистить();
		ДобавитьКоммент = Ложь;
		//СтруктураРеквизитовПроблемы = Новый Структура("Дата, SalesOrder, User, Reason, Billed, ExpectedDateForInvoice, EscalateTo, Details, Responsibles");
		СтруктураРеквизитовПроблемы = Новый Структура("Дата, SalesOrder, User, Reason, Billed, ExpectedDateForInvoice, EscalateTo, Details, ActionItem, Responsibles");
		Responsibles = Новый ТаблицаЗначений;
		Responsibles.Колонки.Добавить("Responsible");
		
		Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
			ДобавитьКоммент = Истина;
			СтруктураРеквизитовПроблемы.Дата = ТекущаяДата;
			СтруктураРеквизитовПроблемы.SalesOrder = SalesOrder;
			СтруктураРеквизитовПроблемы.User = AutoUser;
			СтруктураРеквизитовПроблемы.Billed = BilledStatus;
			
		Иначе
			
			ВыборкаДетальныеЗаписи.Следующий();
			
			Если BilledStatus <> ВыборкаДетальныеЗаписи.Billed Тогда
				// { RGS TAlmazova 09.02.2017 14:45:58 - костыль чтобы добавлять статус Unbilled даже если стоит Billed, который проставился обработкой заполнения статусов
				//Если ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Unbilled Тогда
				Если ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Unbilled ИЛИ ((ВыборкаДетальныеЗаписи.Период = '20161218231026' ИЛИ ВыборкаДетальныеЗаписи.Период = '20161218233402') И ВыборкаДетальныеЗаписи.User = AutoUser)Тогда
				// } RGS TAlmazova 09.02.2017 14:46:48 - костыль чтобы добавлять статус Unbilled даже если стоит Billed, который проставился обработкой заполнения статусов
					ДобавитьКоммент = Истина;
					Если ВыборкаДетальныеЗаписи.Период >= НачалоМесТекДата Тогда
						
						СтруктураРеквизитовПроблемы.Дата = ТекущаяДата;
						СтруктураРеквизитовПроблемы.SalesOrder = SalesOrder;
						СтруктураРеквизитовПроблемы.User = AutoUser;
						СтруктураРеквизитовПроблемы.Billed = BilledStatus;
						СтруктураРеквизитовПроблемы.Reason = ВыборкаДетальныеЗаписи.Reason;
						СтруктураРеквизитовПроблемы.ExpectedDateForInvoice = ВыборкаДетальныеЗаписи.ExpectedDateForInvoice;
						СтруктураРеквизитовПроблемы.Details = ВыборкаДетальныеЗаписи.Details;
						СтруктураРеквизитовПроблемы.ActionItem = ВыборкаДетальныеЗаписи.ActionItem;
						Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.EscalateTo) Тогда
							СтруктураРеквизитовПроблемы.Вставить("Responsibles", Новый ТаблицаЗначений);
							СтруктураРеквизитовПроблемы.EscalateTo = ВыборкаДетальныеЗаписи.EscalateTo;
							МассивОтветственных = Документы.SalesOrder.ПолучитьОтветственныхПоSO(SalesOrder, ВыборкаДетальныеЗаписи.EscalateTo);
							Если МассивОтветственных.Количество() = 0 Тогда
								ТекстОшибки = "For the selected Sales Order is not filled Responsible";
							КонецЕсли;
							Responsibles.Очистить();
							Для каждого ТекОтветственный Из МассивОтветственных Цикл
								НоваяСтрока = Responsibles.Добавить();
								НоваяСтрока.Responsible = ТекОтветственный;
							КонецЦикла;
							СтруктураРеквизитовПроблемы.Responsibles = Responsibles;
						КонецЕсли;
					Иначе
						СтруктураРеквизитовПроблемы.Дата = ТекущаяДата;
						СтруктураРеквизитовПроблемы.SalesOrder = SalesOrder;
						СтруктураРеквизитовПроблемы.User = AutoUser;
						СтруктураРеквизитовПроблемы.Billed = BilledStatus;
					КонецЕсли;
				Иначе 
				 ТекстОшибки = " " + SalesOrder + " in the " + ВыборкаДетальныеЗаписи.Billed + " status of the ERM and Unbilled status in the file. Check document status!";
			 	КонецЕсли;
			 КонецЕсли;
		КонецЕсли;
		
		Если ТекстОшибки = "" И ДобавитьКоммент Тогда
			Problem = РегистрыСведений.SalesOrdersComments.СоздатьSalesOrderProblem(СтруктураРеквизитовПроблемы);

			НЗSOComments.Очистить();
			НЗSOComments.Отбор.SalesOrder.Установить(SalesOrder);

			Запись = НЗSOComments.Добавить();
			Запись.Период = ТекущаяДата;
			Запись.SalesOrder = SalesOrder;
			Запись.Problem = Problem;
			НЗSOComments.Записать(Ложь);
		КонецЕсли;
		
КонецПроцедуры

#КонецЕсли