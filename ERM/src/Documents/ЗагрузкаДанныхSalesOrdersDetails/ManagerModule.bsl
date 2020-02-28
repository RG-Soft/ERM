#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";
	
	//ФайлДанных = СтруктураПараметров.ИсточникДанных.Получить();
	ФайлДанных = РаботаСФайлами.ДвоичныеДанныеФайла(СтруктураПараметров.ИсточникДанных);
	
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
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1;FMT=Delimited;MAXSCANROWS=0;""";
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1;FMT=Delimited;MAXSCANROWS=0;""";
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
	|	SalesOrdersDetailsSourceData.BillingAccount КАК BillingAccount,
	|	SalesOrdersDetailsSourceData.BillingAccountID КАК BillingAccountID,
	|	SalesOrdersDetailsSourceData.LawsonCustomerCode КАК LawsonCustomerCode,
	|	SalesOrdersDetailsSourceData.Agreement КАК Agreement,
	|	SalesOrdersDetailsSourceData.AgreementName КАК AgreementName,
	|	SalesOrdersDetailsSourceData.AgreementStatus КАК AgreementStatus,
	|	SalesOrdersDetailsSourceData.AgreementType КАК AgreementType,
	|	SalesOrdersDetailsSourceData.EffectiveDate КАК EffectiveDate,
	|	SalesOrdersDetailsSourceData.ExpirationDate КАК ExpirationDate,
	|	SalesOrdersDetailsSourceData.CompanyCode КАК CompanyCode,
	|	SalesOrdersDetailsSourceData.OrderID КАК OrderID,
	|	SalesOrdersDetailsSourceData.НомерSO КАК НомерSO,
	|	SalesOrdersDetailsSourceData.LawsonInvoice КАК LawsonInvoice,
	|	SalesOrdersDetailsSourceData.CustomerRepresentative КАК CustomerRepresentative,
	|	SalesOrdersDetailsSourceData.ApprovedBy КАК ApprovedBy,
	|	SalesOrdersDetailsSourceData.CreatedBy КАК CreatedBy,
	|	SalesOrdersDetailsSourceData.ExchangeRate КАК ExchangeRate,
	|	SalesOrdersDetailsSourceData.OrderCurrency КАК OrderCurrency,
	|	SalesOrdersDetailsSourceData.CreditMemoReason КАК CreditMemoReason,
	|	SalesOrdersDetailsSourceData.DualCurrencyStatus КАК DualCurrencyStatus,
	|	SalesOrdersDetailsSourceData.EvidenceOfDelivery КАК EvidenceOfDelivery,
	|	SalesOrdersDetailsSourceData.FTLCreatedBy КАК FTLCreatedBy,
	|	SalesOrdersDetailsSourceData.FTLApproverID КАК FTLApproverID,
	|	SalesOrdersDetailsSourceData.LawsonStatus КАК LawsonStatus,
	|	SalesOrdersDetailsSourceData.OrderCurrencyAmount КАК OrderCurrencyAmount,
	|	SalesOrdersDetailsSourceData.OrderUSDAmount КАК OrderUSDAmount,
	|	SalesOrdersDetailsSourceData.OrderJobEndDate КАК OrderJobEndDate,
	|	SalesOrdersDetailsSourceData.OrderCreationDate КАК OrderCreationDate,
	|	SalesOrdersDetailsSourceData.OrderJobStartDate КАК OrderJobStartDate,
	|	SalesOrdersDetailsSourceData.FieldTicketCreationDate КАК FieldTicketCreationDate,
	|	SalesOrdersDetailsSourceData.FTLApprovalDate КАК FTLApprovalDate,
	|	SalesOrdersDetailsSourceData.FTLSubmissionDate КАК FTLSubmissionDate,
	|	SalesOrdersDetailsSourceData.OrderFirstSubmissionDate КАК OrderFirstSubmissionDate,
	|	SalesOrdersDetailsSourceData.RequestToApproveDate КАК RequestToApproveDate,
	|	SalesOrdersDetailsSourceData.OrderApprovalDate КАК OrderApprovalDate,
	|	SalesOrdersDetailsSourceData.AccrueFlagDate КАК AccrueFlagDate,
	|	SalesOrdersDetailsSourceData.InvoiceFlagDate КАК InvoiceFlagDate,
	|	SalesOrdersDetailsSourceData.LastUpdatedDate КАК LastUpdatedDate,
	|	SalesOrdersDetailsSourceData.FieldTicket КАК FieldTicket,
	|	SalesOrder.Ссылка КАК SalesOrderСсылка,
	|	ДокументInvoice.Ссылка КАК InvoiceСсылка,
	|	ДокументInvoiceB.Ссылка КАК InvoiceСсылкаB,
	|	Организации.Ссылка КАК ОрганизацияСсылка,
	|	SalesOrdersDetailsSourceData.YearMonthДата КАК YearMonthДата,
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
	|	SalesOrdersDetailsSourceData.ClientContract КАК ClientContract
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
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Invoice КАК ДокументInvoiceB
	|		ПО (SalesOrdersDetailsSourceData.LawsonInvoice + ""B"" = ДокументInvoiceB.Номер)
	|			И (НЕ ДокументInvoiceB.ПометкаУдаления)
	|			И SalesOrdersDetailsSourceData.CompanyCode = ДокументInvoiceB.Company.Код
	|			И (ДокументInvoiceB.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО SalesOrdersDetailsSourceData.CompanyCode = Организации.Код
	|			И (НЕ Организации.ПометкаУдаления)
	|			И (Организации.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|ГДЕ
	|	SalesOrdersDetailsSourceData.ДокументЗагрузки = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ.YearMonthДата КАК YearMonthДата,
	|	ВТ.OrderCurrency КАК OrderCurrency
	|ПОМЕСТИТЬ ВТ_Валюта
	|ИЗ
	|	ВТ КАК ВТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ.YearMonthДата КАК YearMonthДата,
	|	ВТ.LawsonCustomerCode КАК LawsonCustomerCode
	|ПОМЕСТИТЬ ВТ_Клиенты
	|ИЗ
	|	ВТ КАК ВТ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Валюта.YearMonthДата КАК YearMonthДата,
	|	ВТ_Валюта.OrderCurrency КАК OrderCurrency,
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
	|	ВТ_ВалютаМаксимальныеДаты.YearMonthДата КАК YearMonthДата,
	|	ВТ_ВалютаМаксимальныеДаты.OrderCurrency КАК OrderCurrency,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
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
	|	ВТ_Клиенты.YearMonthДата КАК YearMonthДата,
	|	ВТ_Клиенты.LawsonCustomerCode КАК LawsonCustomerCode,
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
	|	ВТ_КлиентыПоследниеДаты.YearMonthДата КАК YearMonthДата,
	|	ВТ_КлиентыПоследниеДаты.LawsonCustomerCode КАК LawsonCustomerCode,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
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
	|	ВТ.YearMonth КАК YearMonth,
	|	ВТ.BillingAccount КАК BillingAccount,
	|	ВТ.BillingAccountID КАК BillingAccountID,
	|	ВТ.LawsonCustomerCode КАК LawsonCustomerCode,
	|	ВТ.Agreement КАК Agreement,
	|	ВТ.AgreementName КАК AgreementName,
	|	ВТ.AgreementStatus КАК AgreementStatus,
	|	ВТ.AgreementType КАК AgreementType,
	|	ВТ.EffectiveDate КАК EffectiveDate,
	|	ВТ.ExpirationDate КАК ExpirationDate,
	|	ВТ.CompanyCode КАК CompanyCode,
	|	ВТ.OrderID КАК OrderID,
	|	ВТ.НомерSO КАК НомерSO,
	|	ВТ.LawsonInvoice КАК LawsonInvoice,
	|	ВТ.CustomerRepresentative КАК CustomerRepresentative,
	|	ВТ.ApprovedBy КАК ApprovedBy,
	|	ВТ.CreatedBy КАК CreatedBy,
	|	ВТ.ExchangeRate КАК ExchangeRate,
	|	ВТ.OrderCurrency КАК OrderCurrency,
	|	ВТ.CreditMemoReason КАК CreditMemoReason,
	|	ВТ.DualCurrencyStatus КАК DualCurrencyStatus,
	|	ВТ.EvidenceOfDelivery КАК EvidenceOfDelivery,
	|	ВТ.FTLCreatedBy КАК FTLCreatedBy,
	|	ВТ.FTLApproverID КАК FTLApproverID,
	|	ВТ.LawsonStatus КАК LawsonStatus,
	|	ВТ.OrderCurrencyAmount КАК OrderCurrencyAmount,
	|	ВТ.OrderUSDAmount КАК OrderUSDAmount,
	|	ВТ.OrderJobEndDate КАК OrderJobEndDate,
	|	ВТ.OrderCreationDate КАК OrderCreationDate,
	|	ВТ.OrderJobStartDate КАК OrderJobStartDate,
	|	ВТ.FieldTicketCreationDate КАК FieldTicketCreationDate,
	|	ВТ.FTLApprovalDate КАК FTLApprovalDate,
	|	ВТ.FTLSubmissionDate КАК FTLSubmissionDate,
	|	ВТ.OrderFirstSubmissionDate КАК OrderFirstSubmissionDate,
	|	ВТ.RequestToApproveDate КАК RequestToApproveDate,
	|	ВТ.OrderApprovalDate КАК OrderApprovalDate,
	|	ВТ.AccrueFlagDate КАК AccrueFlagDate,
	|	ВТ.InvoiceFlagDate КАК InvoiceFlagDate,
	|	ВТ.LastUpdatedDate КАК LastUpdatedDate,
	|	ВТ.FieldTicket КАК FieldTicket,
	|	ВТ.SalesOrderСсылка КАК SalesOrderСсылка,
	|	ВТ.InvoiceСсылка КАК InvoiceСсылка,
	|	ВТ.InvoiceСсылкаB КАК InvoiceСсылкаB,
	|	ВТ.ОрганизацияСсылка КАК ОрганизацияСсылка,
	|	ВТ.YearMonthДата КАК YearMonthДата,
	|	ВТ_ВалютыСПриемником.ОбъектПриемника КАК ВалютаСсылка,
	|	ВТ_КлиентыСПриемником.ОбъектПриемника КАК КлиентСсылка,
	|	ВЫБОР
	|		КОГДА ВТ.WellName <> """"
	|			ТОГДА ВТ.WellName + "" ""
	|		ИНАЧЕ """"
	|	КОНЕЦ + ВТ.FieldName КАК WellData,
	|	ВТ.ClientContract КАК ClientContract,
	|	ЕСТЬNULL(DIR.JobEndDate, ДАТАВРЕМЯ(1, 1, 1)) КАК Invoice_JED,
	|	ЕСТЬNULL(DIR.InvoiceFlagDate, ДАТАВРЕМЯ(1, 1, 1)) КАК Invoice_IFD,
	|	ЕСТЬNULL(DIR_B.JobEndDate, ДАТАВРЕМЯ(1, 1, 1)) КАК InvoiceB_JED,
	|	ЕСТЬNULL(DIR_B.InvoiceFlagDate, ДАТАВРЕМЯ(1, 1, 1)) КАК InvoiceB_IFD
	|ИЗ
	|	ВТ КАК ВТ
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВалютыСПриемником КАК ВТ_ВалютыСПриемником
	|		ПО ВТ.YearMonthДата = ВТ_ВалютыСПриемником.YearMonthДата
	|			И ВТ.OrderCurrency = ВТ_ВалютыСПриемником.OrderCurrency
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КлиентыСПриемником КАК ВТ_КлиентыСПриемником
	|		ПО ВТ.YearMonthДата = ВТ_КлиентыСПриемником.YearMonthДата
	|			И ВТ.LawsonCustomerCode = ВТ_КлиентыСПриемником.LawsonCustomerCode
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DIR КАК DIR
	|		ПО ВТ.InvoiceСсылка = DIR.Invoice
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DIR КАК DIR_B
	|		ПО ВТ.InvoiceСсылкаB = DIR_B.Invoice";
	
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
	
	ОбновленныеДатыDIR = Новый ТаблицаЗначений;
	ОбновленныеДатыDIR.Колонки.Добавить("Invoice", Новый ОписаниеТипов("ДокументСсылка.Invoice"));
	
	НенайденныеInvoices = Новый ТаблицаЗначений;
	НенайденныеInvoices.Колонки.Добавить("InvoiceNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(12)));
	
	ОшибкиПоискаSO = Новый ТаблицаЗначений;
	ОшибкиПоискаSO.Колонки.Добавить("SalesOrderNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(17)));
	
	ПустаяДата = '00010101';
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ПустаяСтрока(Выборка.LawsonInvoice) И НЕ ЗначениеЗаполнено(Выборка.InvoiceСсылка) И НЕ ЗначениеЗаполнено(Выборка.InvoiceСсылкаB) Тогда
			
			СтрокаТЗ = НенайденныеInvoices.Добавить();
			СтрокаТЗ.InvoiceNumber = Выборка.LawsonInvoice;
			
		Иначе
			
			Если ЗначениеЗаполнено(Выборка.InvoiceСсылка) Тогда
				
				ОбъектInvoice = Выборка.InvoiceСсылка.ПолучитьОбъект();
				
				Если Не ПустаяСтрока(Выборка.ClientContract) И Выборка.ClientContract <> "N/A" Тогда
				
					РГСофтКлиентСервер.УстановитьЗначение(ОбъектInvoice.Agreement, Выборка.ClientContract);
					
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(ОбъектInvoice.FTLResponsible) И (ЗначениеЗаполнено(Выборка.FTLApproverID) Или ЗначениеЗаполнено(Выборка.FTLCreatedBy)) Тогда
			
					РГСофтКлиентСервер.УстановитьЗначение(ОбъектInvoice.FTLResponsible, ?(ЗначениеЗаполнено(Выборка.FTLApproverID), Выборка.FTLApproverID, Выборка.FTLCreatedBy));
			
				КонецЕсли;
				
				Если ОбъектInvoice.Модифицированность() Тогда
					ОбъектInvoice.ОбменДанными.Загрузка = Истина;
					ОбъектInvoice.Записать();
					СтрокаТЗ = ОбновленныеInvoice.Добавить();
					СтрокаТЗ.Invoice = Выборка.InvoiceСсылка;
				КонецЕсли;
				
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Выборка.InvoiceСсылкаB) Тогда
				
				ОбъектInvoice = Выборка.InvoiceСсылкаB.ПолучитьОбъект();
				
				Если Не ПустаяСтрока(Выборка.ClientContract) И Выборка.ClientContract <> "N/A" Тогда
				
					РГСофтКлиентСервер.УстановитьЗначение(ОбъектInvoice.Agreement, Выборка.ClientContract);
					
				КонецЕсли;
				
				Если Не ЗначениеЗаполнено(ОбъектInvoice.FTLResponsible) И (ЗначениеЗаполнено(Выборка.FTLApproverID) Или ЗначениеЗаполнено(Выборка.FTLCreatedBy)) Тогда
			
					РГСофтКлиентСервер.УстановитьЗначение(ОбъектInvoice.FTLResponsible, ?(ЗначениеЗаполнено(Выборка.FTLApproverID), Выборка.FTLApproverID, Выборка.FTLCreatedBy));
			
				КонецЕсли;
				
				Если ОбъектInvoice.Модифицированность() Тогда
					ОбъектInvoice.ОбменДанными.Загрузка = Истина;
					ОбъектInvoice.Записать();
					СтрокаТЗ = ОбновленныеInvoice.Добавить();
					СтрокаТЗ.Invoice = Выборка.InvoiceСсылкаB;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
				
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
		
		ТекОбъект = Выборка.SalesOrderСсылка.ПолучитьОбъект();
		
		
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementCode, Выборка.Agreement);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Agreement, Выборка.AgreementName);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementStatus, Выборка.AgreementStatus);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AgreementType, Выборка.AgreementType);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Company, Выборка.ОрганизацияСсылка);
		Если ЗначениеЗаполнено(Выборка.InvoiceСсылка) Тогда
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Invoice, Выборка.InvoiceСсылка);
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ArInvoice, Выборка.LawsonInvoice);
		ИначеЕсли ЗначениеЗаполнено(Выборка.InvoiceСсылкаB) Тогда
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Invoice, Выборка.InvoiceСсылкаB);
			РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ArInvoice, Выборка.LawsonInvoice + "B");
		КонецЕсли;
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.SiebelOrderId, Выборка.OrderID);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ERPStatus, Выборка.LawsonStatus);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ExchangeRate, Выборка.ExchangeRate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.Amount, Выборка.OrderCurrencyAmount);
		//РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.AmountUSD, Окр(Выборка.OrderCurrencyAmount / Выборка.ExchangeRate, 2));
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
		Если НЕ ЗначениеЗаполнено(ТекОбъект.InvoiceFlagDate) Тогда 
			InvoiceFlagDate = Выборка.InvoiceFlagDate;
		Иначе
			InvoiceFlagDate = ПустаяДата;
		КонецЕсли;
		
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
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLSubmissionDate, FTLSubmissionDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.CreationDate, CreationDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ApprovalDate, ApprovalDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FirstSubmissionDate, FirstSubmissionDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.InvoiceFlagDate, InvoiceFlagDate);

		Даты = Новый Соответствие();
		Даты.Вставить("JobStartDate", Выборка.OrderJobStartDate);
		Даты.Вставить("FTLSubmissionDate", FTLSubmissionDate);
		Даты.Вставить("CreationDate", CreationDate);
		Даты.Вставить("ApprovalDate", ApprovalDate);
		Даты.Вставить("FirstSubmissionDate", FirstSubmissionDate);
		
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
		
		//ДатыDIR = Новый Соответствие();
		
		Если ЗначениеЗаполнено(Выборка.InvoiceСсылка) Тогда
			//Если Выборка.ПериодДействия = ПустаяДата Тогда
			//	ДатыDIR.Вставить("ПериодДействия",НачалоМесяца(Выборка.InvoiceДата))	
			//КонецЕсли;
			Если Выборка.Invoice_JED = ПустаяДата Тогда
				Даты.Вставить("JobEndDate", JobEndDate);
			КонецЕсли;
			Если Выборка.Invoice_IFD = ПустаяДата Тогда
				Даты.Вставить("InvoiceFlagDate", Выборка.InvoiceFlagDate);
			КонецЕсли;
			
			РегистрыСведений.DIR.ЗаписатьДаты(Выборка.InvoiceСсылка, Даты);
			СтрокаТЗ = ОбновленныеДатыDIR.Добавить();
			СтрокаТЗ.Invoice = Выборка.InvoiceСсылка;

		КонецЕсли;

		Если ЗначениеЗаполнено(Выборка.InvoiceСсылкаB) Тогда
			//Если Выборка.ПериодДействияB = ПустаяДата Тогда
			//	ДатыDIR.Вставить("ПериодДействия",НачалоМесяца(Выборка.InvoiceBДата))	
			//КонецЕсли;
			Если Выборка.InvoiceB_JED = ПустаяДата Тогда
				Даты.Вставить("JobEndDate", JobEndDate);
			КонецЕсли;
			Если Выборка.InvoiceB_IFD = ПустаяДата Тогда
				Даты.Вставить("InvoiceFlagDate", Выборка.InvoiceFlagDate);
			КонецЕсли;

			РегистрыСведений.DIR.ЗаписатьДаты(Выборка.InvoiceСсылкаB, Даты);
			СтрокаТЗ = ОбновленныеДатыDIR.Добавить();
			СтрокаТЗ.Invoice = Выборка.InvoiceСсылкаB;

		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	ОбновленныеSO.Свернуть("SalesOrder");
	НенайденныеSO.Свернуть("SalesOrderNumber");
	ОбновленныеInvoice.Свернуть("Invoice");
	ОбновленныеДатыDIR.Свернуть("Invoice");
	НенайденныеInvoices.Свернуть("InvoiceNumber");
	ОшибкиПоискаSO.Свернуть("SalesOrderNumber");
	
	ДанныеДляЗаполнения.Вставить("ОбновленныеSO", ОбновленныеSO);
	ДанныеДляЗаполнения.Вставить("НенайденныеSO", НенайденныеSO);
	ДанныеДляЗаполнения.Вставить("ОбновленныеInvoice", ОбновленныеInvoice);
	ДанныеДляЗаполнения.Вставить("ОбновленныеДатыDIR", ОбновленныеДатыDIR);
	ДанныеДляЗаполнения.Вставить("НенайденныеInvoices", НенайденныеInvoices);
	ДанныеДляЗаполнения.Вставить("ОшибкиПоискаSO", ОшибкиПоискаSO);
		
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

#КонецЕсли