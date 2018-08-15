#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";
	
	ФайлДанных = СтруктураПараметров.ИсточникДанных.Получить();
	
	ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
	СоздатьКаталог(ИмяКаталога);
	ПутьКФайлу = ИмяКаталога + "\XR242.csv";
	ФайлДанных.Записать(ПутьКФайлу);
	
	ПутьСхемы = ИмяКаталога+"\schema.ini";
	ФайлСхемы = Новый ТекстовыйДокумент;
	ФайлСхемы.ДобавитьСтроку("["+ "XR242.csv" +"]" 
		+ Символы.ПС + "DecimalSymbol=."
		+ Символы.ПС + "DateTimeFormat=dd/mm/yyyy");
	ФайлСхемы.Записать(ПутьСхемы, КодировкаТекста.OEM);
	
	Connection = Новый COMОбъект("ADODB.Connection");
	
	Попытка
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1;""";
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1""";
			Connection.Open(СтрокаПодключения);
		Исключение
			ВызватьИсключение "Can't open connection! " + ОписаниеОшибки();
		КонецПопытки;
	КонецПопытки;
	
	rs = Новый COMObject("ADODB.RecordSet");
	
	Стр_SQL = "Select * FROM XR242.csv";
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
			
			Попытка
				ТекЗначение = rs.Fields(ЭлементСоответствия.Значение).Value;
			Исключение
				ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ОписаниеОшибки());
				ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
				Возврат;
			КонецПопытки;
			
			Если ТипЗнч(ТекЗначение) = ТипЗнч("Строка") Тогда
				СтрокаДанных[ЭлементСоответствия.Ключ] = СокрЛП(ТекЗначение);
			Иначе
				СтрокаДанных[ЭлементСоответствия.Ключ] = ТекЗначение;
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

Функция ПолучитьСтруктуруКолонокТаблицыДанных() Экспорт
	
	СтруктураКолонок = Новый ТаблицаЗначений;
	СтруктураКолонок.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("ИмяКолонки", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("Обязательная", Новый ОписаниеТипов("Булево"));
	
	ЗаполнитьСтруктуруКолонокТаблицыДанных(СтруктураКолонок);
	
	Возврат СтруктураКолонок;
	
КонецФункции

Процедура ЗаполнитьСтруктуруКолонокТаблицыДанных(СтруктураКолонок)
	
	// Company
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Company";
	СтрокаТЗ.ИмяКолонки = "Company";
	
	// CompanyName
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyName";
	СтрокаТЗ.ИмяКолонки = "CompanyName";
	
	// CustomerNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerNumber";
	СтрокаТЗ.ИмяКолонки = "Customer";
	
	// CustomerName
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerName";
	СтрокаТЗ.ИмяКолонки = "CustomerDesc";

	// AUCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AUCode";
	СтрокаТЗ.ИмяКолонки = "AcctUnit";

	// CurrencyCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CurrencyCode";
	СтрокаТЗ.ИмяКолонки = "TranCurrencyCode";
	
	// Date
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceDate";
	СтрокаТЗ.ИмяКолонки = "InvoiceDate";
	
	// JobEndDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "EndDate";
	СтрокаТЗ.ИмяКолонки = "EndDate";
	
	// ArInvoice
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ArInvoice";
	СтрокаТЗ.ИмяКолонки = "InvPreInvoice";
	
	// InvoiceAmt
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAmt";
	СтрокаТЗ.ИмяКолонки = "InvoiceAmt";
	
	
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
	
	НЗ = РегистрыСведений.XR242SourceData.СоздатьНаборЗаписей();
	НЗ.Отбор.ДокументЗагрузки.Установить(Ссылка);
	НЗ.Загрузить(ТаблицаДанных);
	НЗ.Записать(Истина);
	
КонецПроцедуры

Процедура ВыполнитьПроверкуНастроекСинхронизации(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ КАК КоллизияОтработана,
		|	""Failed to find Currency"" КАК Описание,
		|	&ТипВнешнейСистемы КАК ТипСоответствия,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency) КАК ТипОбъектаВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ОбъектПриемника,
		|	XR242SourceData.CurrencyCode КАК Идентификатор
		|ИЗ
		|	РегистрСведений.XR242SourceData КАК XR242SourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)) КАК НастройкаСинхронизацииCurrency
		|		ПО (XR242SourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И XR242SourceData.CurrencyCode = НастройкаСинхронизацииCurrency.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииCurrency.ОбъектПриемника ЕСТЬ NULL
		|	И XR242SourceData.ДокументЗагрузки = &ДокументЗагрузки
		|	И НЕ XR242SourceData.CurrencyCode = """"
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ КАК КоллизияОтработана,
		|	""Failed to find Client"" КАК Описание,
		|	&ТипВнешнейСистемы КАК ТипСоответствия,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client) КАК ТипОбъектаВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) КАК ОбъектПриемника,
		|	XR242SourceData.CustomerNumber КАК Идентификатор
		|ИЗ
		|	РегистрСведений.XR242SourceData КАК XR242SourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)) КАК НастройкаСинхронизацииClient
		|		ПО (XR242SourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И XR242SourceData.CustomerNumber = НастройкаСинхронизацииClient.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииClient.ОбъектПриемника ЕСТЬ NULL
		|	И XR242SourceData.ДокументЗагрузки = &ДокументЗагрузки
		|	И НЕ XR242SourceData.CustomerNumber = """"
		|
		|ОБЪЕДИНИТЬ		
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ,
		|	""Failed to find Accounting Unit"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.AccountingUnit),
		|	ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка),
		|	XR242SourceData.AUCode
		|ИЗ
		|	РегистрСведений.XR242SourceData КАК XR242SourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
		|		ПО (НЕ КостЦентры.ПометкаУдаления)
		|			И XR242SourceData.AUCode = КостЦентры.Код
		|ГДЕ
		|	XR242SourceData.ДокументЗагрузки = &ДокументЗагрузки
		|	И КостЦентры.Ссылка ЕСТЬ NULL
		|;";
	
	Запрос.УстановитьПараметр("ДокументЗагрузки", СтруктураПараметров.Ссылка);
	Запрос.УстановитьПараметр("Период", СтруктураПараметров.Дата);
	Запрос.УстановитьПараметр("ТипВнешнейСистемы", СтруктураПараметров.ТипВнешнейСистемы);
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаКоллизий = РезультатЗапроса.Выгрузить();
	
	ДанныеДляЗаполнения.Вставить("ТаблицаКоллизий", ТаблицаКоллизий);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ОбновитьРеквизитыInvoices(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	XR242SourceData.ArInvoice КАК ArInvoice,
	|	XR242SourceData.InvoiceDate КАК InvoiceDate,
	|	XR242SourceData.EndDate КАК EndDate,
	|	XR242SourceData.InvoiceAmt КАК InvoiceAmt,
	|	XR242SourceData.CustomerNumber КАК CustomerNumber,
	|	XR242SourceData.AUCode КАК AUCode,
	|	XR242SourceData.CurrencyCode КАК CurrencyCode,
	|	ЕСТЬNULL(Организации.Ссылка, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация
	|ПОМЕСТИТЬ ВТ_ИсходныеДанные
	|ИЗ
	|	РегистрСведений.XR242SourceData КАК XR242SourceData
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО XR242SourceData.Company = Организации.Код
	|			И (Организации.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|ГДЕ
	|	XR242SourceData.ДокументЗагрузки = &Ссылка
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ArInvoice,
	|	Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника КАК ОбъектПриемника
	|ПОМЕСТИТЬ ВТ_СоответствиеКлиентовCustomerNumber
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
	|			&Период,
	|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
	|				И Идентификатор В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ВТ_ИсходныеДанные.CustomerNumber
	|					ИЗ
	|						ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника КАК ОбъектПриемника
	|ПОМЕСТИТЬ ВТ_СоответствиеCurrency
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
	|			&Период,
	|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)
	|				И Идентификатор В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ВТ_ИсходныеДанные.CurrencyCode
	|					ИЗ
	|						ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИсходныеДанные.ArInvoice КАК ArInvoice,
	|	ВТ_ИсходныеДанные.InvoiceDate КАК InvoiceDate,
	|	ВТ_ИсходныеДанные.EndDate КАК EndDate,
	|	ВТ_ИсходныеДанные.InvoiceAmt КАК InvoiceAmountUSD,
	|	ВТ_ИсходныеДанные.AUCode КАК AUCode,
	|	КостЦентры.Ссылка КАК AU,
	|	ВТ_СоответствиеКлиентовCustomerNumber.ОбъектПриемника КАК Client,
	|	ВТ_ИсходныеДанные.CustomerNumber КАК CustomerNumber,
	|	ВТ_СоответствиеCurrency.ОбъектПриемника КАК Currency,
	|	ЕСТЬNULL(КлючиИнвойсов.Invoice, ЗНАЧЕНИЕ(Документ.Invoice.ПустаяСсылка)) КАК Invoice,
	|	ЕСТЬNULL(КлючиSalesOrders.SalesOrder, ЗНАЧЕНИЕ(Документ.SalesOrder.ПустаяСсылка)) КАК SalesOrder,
	|	ЕСТЬNULL(КлючиИнвойсовB.Invoice, ЗНАЧЕНИЕ(Документ.Invoice.ПустаяСсылка)) КАК InvoiceB,
	|	ЕСТЬNULL(КлючиSalesOrdersB.SalesOrder, ЗНАЧЕНИЕ(Документ.SalesOrder.ПустаяСсылка)) КАК SalesOrderB,
	|	ЕСТЬNULL(КлючиSalesOrders.SalesOrder.JobEndDate, ДАТАВРЕМЯ(1, 1, 1)) КАК SO_JobEndDate,
	|	ЕСТЬNULL(КлючиSalesOrdersB.SalesOrder.JobEndDate, ДАТАВРЕМЯ(1, 1, 1)) КАК SOB_JobEndDate
	|ИЗ
	|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КлючиSalesOrders КАК КлючиSalesOrders
	|		ПО ВТ_ИсходныеДанные.ArInvoice = КлючиSalesOrders.ArInvoice
	|			И ВТ_ИсходныеДанные.Организация = КлючиSalesOrders.Company
	|			И (КлючиSalesOrders.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеКлиентовCustomerNumber КАК ВТ_СоответствиеКлиентовCustomerNumber
	|		ПО ВТ_ИсходныеДанные.CustomerNumber = ВТ_СоответствиеКлиентовCustomerNumber.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеCurrency КАК ВТ_СоответствиеCurrency
	|		ПО ВТ_ИсходныеДанные.CurrencyCode = ВТ_СоответствиеCurrency.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КлючиИнвойсов КАК КлючиИнвойсов
	|		ПО ВТ_ИсходныеДанные.ArInvoice = КлючиИнвойсов.ArInvoice
	|			И ВТ_ИсходныеДанные.Организация = КлючиИнвойсов.Company
	|			И (КлючиИнвойсов.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
	|		ПО ВТ_ИсходныеДанные.AUCode = КостЦентры.Код
	|			И (НЕ КостЦентры.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КлючиИнвойсов КАК КлючиИнвойсовB
	|		ПО (ВТ_ИсходныеДанные.ArInvoice + ""B"" = КлючиИнвойсовB.ArInvoice)
	|			И ВТ_ИсходныеДанные.Организация = КлючиИнвойсовB.Company
	|			И (КлючиИнвойсовB.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КлючиSalesOrders КАК КлючиSalesOrdersB
	|		ПО (ВТ_ИсходныеДанные.ArInvoice + ""B"" = КлючиSalesOrdersB.ArInvoice)
	|			И ВТ_ИсходныеДанные.Организация = КлючиSalesOrdersB.Company
	|			И (КлючиSalesOrdersB.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))";
	
	Запрос.УстановитьПараметр("Ссылка", СтруктураПараметров.Ссылка);
	Запрос.УстановитьПараметр("Период",  СтруктураПараметров.Дата);
	
	НачатьТранзакцию();
	Выборка = Запрос.Выполнить().Выбрать();
	ЗафиксироватьТранзакцию();
	
	ОбновленныеInvoice = Новый ТаблицаЗначений;
	ОбновленныеInvoice.Колонки.Добавить("Invoice", Новый ОписаниеТипов("ДокументСсылка.Invoice"));
	
	НенайденныеInvoices = Новый ТаблицаЗначений;
	НенайденныеInvoices.Колонки.Добавить("InvoiceNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(12)));

	ОбновленныеSO = Новый ТаблицаЗначений;
	ОбновленныеSO.Колонки.Добавить("SalesOrder", Новый ОписаниеТипов("ДокументСсылка.SalesOrder"));
	
	НенайденныеSO = Новый ТаблицаЗначений;
	НенайденныеSO.Колонки.Добавить("SONumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(12)));
	
	НайденныеInvoice = Новый ТаблицаЗначений;
	НайденныеInvoice.Колонки.Добавить("Invoice", Новый ОписаниеТипов("ДокументСсылка.Invoice"));
	НайденныеInvoice.Колонки.Добавить("AU", Новый ОписаниеТипов("СправочникСсылка.КостЦентры"));
	НайденныеInvoice.Колонки.Добавить("Currency", Новый ОписаниеТипов("СправочникСсылка.Валюты"));
	НайденныеInvoice.Колонки.Добавить("Client", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	НайденныеInvoice.Колонки.Добавить("InvoiceДата", Новый ОписаниеТипов("Дата",,, Новый КвалификаторыДаты(ЧастиДаты.Дата)));
	НайденныеInvoice.Колонки.Добавить("CustomerNumber", Новый ОписаниеТипов("Строка",,, Новый КвалификаторыСтроки(10)));
	НайденныеInvoice.Колонки.Добавить("InvoiceAmountUSD", Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15,2)));


	Даты = Новый Соответствие();
	МинимальнаяДатаИнвойса = Дата(2040,01,01);
	МаксимальнаяДатаИнвойса = Дата(1980,01,01);
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		InvoiceDate = РГСофт.ПреобразоватьВДату(Выборка.InvoiceDate, "Date");
		
		Если InvoiceDate < МинимальнаяДатаИнвойса И InvoiceDate <> Дата('00010101') Тогда
			МинимальнаяДатаИнвойса = InvoiceDate;
		КонецЕсли;
		Если InvoiceDate > МаксимальнаяДатаИнвойса Тогда
			МаксимальнаяДатаИнвойса = InvoiceDate;
		КонецЕсли;

		JobEndDate = РГСофт.ПреобразоватьВДату(Выборка.EndDate, "Date");
		
		Если Не ПустаяСтрока(Выборка.ArInvoice) И НЕ ЗначениеЗаполнено(Выборка.Invoice) И НЕ ЗначениеЗаполнено(Выборка.InvoiceB) Тогда
			
			СтрокаТЗ = НенайденныеInvoices.Добавить();
			СтрокаТЗ.InvoiceNumber = Выборка.ArInvoice;
			
		Иначе

			Если ЗначениеЗаполнено(Выборка.Invoice) Тогда
				
				Если JobEndDate <> Дата(1, 1, 1) Тогда
					
					Если ЗначениеЗаполнено(Выборка.SalesOrder) Тогда
						Если НЕ ЗначениеЗаполнено(Выборка.SO_JobEndDate) Тогда
							ДозаполнитьSO(Выборка.SalesOrder, JobEndDate);
							СтрокаТЗ = ОбновленныеSO.Добавить();
							СтрокаТЗ.SalesOrder = Выборка.SalesOrder;
						КонецЕсли
					Иначе
						СтрокаТЗ = НенайденныеSO.Добавить();
						СтрокаТЗ.SONumber = Выборка.ArInvoice;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(Выборка.SalesOrderB) Тогда
						Если НЕ ЗначениеЗаполнено(Выборка.SOB_JobEndDate) Тогда
							ДозаполнитьSO(Выборка.SalesOrderB, JobEndDate);
							СтрокаТЗ = ОбновленныеSO.Добавить();
							СтрокаТЗ.SalesOrder = Выборка.SalesOrderB;
						КонецЕсли
					Иначе
						СтрокаТЗ = НенайденныеSO.Добавить();
						СтрокаТЗ.SONumber = Выборка.ArInvoice + "B";
					КонецЕсли;
					
					Даты.Вставить("JobEndDate", JobEndDate);
					
				КонецЕсли;
				
				Даты.Вставить("InvoiceFlagDate", InvoiceDate);
				РегистрыСведений.DIR.ЗаписатьДаты(Выборка.Invoice, Даты);
				
				СтрокаТЗ = ОбновленныеInvoice.Добавить();
				СтрокаТЗ.Invoice = Выборка.Invoice;
				
				СтрокаТЗ_НайденныеИнвойсы = НайденныеInvoice.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЗ_НайденныеИнвойсы,Выборка);
				СтрокаТЗ_НайденныеИнвойсы.InvoiceДата = InvoiceDate;
				//СтрокаТЗ_НайденныеИнвойсы.Курс = Выборка.Курс;
				//СтрокаТЗ_НайденныеИнвойсы.Кратность = Выборка.Кратность;
				
			КонецЕсли;

			Если ЗначениеЗаполнено(Выборка.InvoiceB) Тогда
				
				Если JobEndDate <> Дата(1, 1, 1) Тогда
					
					Если ЗначениеЗаполнено(Выборка.SalesOrder) Тогда
						Если НЕ ЗначениеЗаполнено(Выборка.SO_JobEndDate) Тогда
							ДозаполнитьSO(Выборка.SalesOrder, JobEndDate);
							СтрокаТЗ = ОбновленныеSO.Добавить();
							СтрокаТЗ.SalesOrder = Выборка.SalesOrder;
						КонецЕсли
					Иначе
						СтрокаТЗ = НенайденныеSO.Добавить();
						СтрокаТЗ.SONumber = Выборка.ArInvoice;
					КонецЕсли;
					
					Если ЗначениеЗаполнено(Выборка.SalesOrderB) Тогда
						Если НЕ ЗначениеЗаполнено(Выборка.SOB_JobEndDate) Тогда
							ДозаполнитьSO(Выборка.SalesOrderB, JobEndDate);
							СтрокаТЗ = ОбновленныеSO.Добавить();
							СтрокаТЗ.SalesOrder = Выборка.SalesOrderB;
						КонецЕсли
					Иначе
						СтрокаТЗ = НенайденныеSO.Добавить();
						СтрокаТЗ.SONumber = Выборка.ArInvoice + "B";
					КонецЕсли;
					
					Даты.Вставить("JobEndDate", JobEndDate);
					
				КонецЕсли;

				//InvoiceDate = РГСофт.ПреобразоватьВДату(Выборка.InvoiceDate, "Date");
				Даты.Вставить("InvoiceFlagDate", InvoiceDate);
				РегистрыСведений.DIR.ЗаписатьДаты(Выборка.InvoiceB, Даты);
				
				СтрокаТЗ = ОбновленныеInvoice.Добавить();
				СтрокаТЗ.Invoice = Выборка.InvoiceB;
				
				СтрокаТЗ_НайденныеИнвойсы = НайденныеInvoice.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаТЗ_НайденныеИнвойсы,Выборка, "AU,Currency,Client,InvoiceAmountUSD");
				СтрокаТЗ_НайденныеИнвойсы.Invoice = Выборка.InvoiceB;
				СтрокаТЗ_НайденныеИнвойсы.InvoiceДата = InvoiceDate;
				
			КонецЕсли;

		КонецЕсли;
						
	КонецЦикла;
	
	СоздатьКорректировкиПоИнвойсам(НайденныеInvoice, МинимальнаяДатаИнвойса, МаксимальнаяДатаИнвойса, СтруктураПараметров.Ссылка);
	
	ЗафиксироватьТранзакцию();
	
	ОбновленныеInvoice.Свернуть("Invoice");
	НенайденныеInvoices.Свернуть("InvoiceNumber");
	ОбновленныеSO.Свернуть("SalesOrder");
	НенайденныеSO.Свернуть("SONumber");
	
	ДанныеДляЗаполнения.Вставить("ОбновленныеInvoice", ОбновленныеInvoice);
	ДанныеДляЗаполнения.Вставить("НенайденныеInvoices", НенайденныеInvoices);
	ДанныеДляЗаполнения.Вставить("ОбновленныеSO", ОбновленныеSO);
	ДанныеДляЗаполнения.Вставить("НенайденныеSO", НенайденныеSO);
		
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Процедура СоздатьКорректировкиПоИнвойсам(НайденныеInvoice, МинимальнаяДатаИнвойса, МаксимальнаяДатаИнвойса, ДокументЗагрузки)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НайденныеInvoice.Invoice КАК Invoice,
	|	НайденныеInvoice.InvoiceДата КАК InvoiceДата,
	|	НайденныеInvoice.AU КАК AU,
	|	НайденныеInvoice.Currency КАК Currency,
	|	НайденныеInvoice.Client КАК Client,
	|	НайденныеInvoice.CustomerNumber КАК CustomerNumber,
	|	НайденныеInvoice.InvoiceAmountUSD КАК InvoiceAmountUSD
	|ПОМЕСТИТЬ ВТ_Инвойсы
	|ИЗ
	|	&НайденныеInvoice КАК НайденныеInvoice"
	;
	Запрос.УстановитьПараметр("НайденныеInvoice", НайденныеInvoice);
	
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВТ_Инвойсы.Invoice КАК Invoice,
	|	ВТ_Инвойсы.CustomerNumber КАК CustomerNumber,
	|	ВТ_Инвойсы.InvoiceДата КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson) КАК Source,
	|	ВТ_Инвойсы.Invoice.Company КАК Company,
	|	ВТ_Инвойсы.Client КАК Client,
	|	ВТ_Инвойсы.AU КАК AU,
	|	&Account КАК Account,
	|	ВТ_Инвойсы.InvoiceAmountUSD КАК BaseAmount,
	|	ВТ_Инвойсы.Currency КАК Currency,
	|	ВЫБОР
	|		КОГДА ВТ_Инвойсы.Currency <> &USD
	|				И ЕСТЬNULL(ВнутренниеКурсыВалют.Курс, 0) = 0
	|			ТОГДА 0
	|		КОГДА ВТ_Инвойсы.Currency <> &USD
	|			ТОГДА ВЫРАЗИТЬ(ВТ_Инвойсы.InvoiceAmountUSD * ЕСТЬNULL(ВнутренниеКурсыВалют.Курс, 0) КАК ЧИСЛО(15, 2))
	|		ИНАЧЕ ВТ_Инвойсы.InvoiceAmountUSD
	|	КОНЕЦ КАК Amount,
	|	ВЫБОР
	|		КОГДА ВТ_Инвойсы.Invoice.Currency = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		КОГДА ВТ_Инвойсы.Invoice.AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		КОГДА ВТ_Инвойсы.Invoice.Client = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
	|			ТОГДА ИСТИНА
	|		КОГДА ВТ_Инвойсы.Invoice.ClientID = """"
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК НеобходимоДозаполнить
	|ИЗ
	|	ВТ_Инвойсы КАК ВТ_Инвойсы
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.InvoicedDebts.Обороты(&Начало, &Конец, , Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)) КАК InvoicedDebtsОбороты
	|		ПО ВТ_Инвойсы.Invoice = InvoicedDebtsОбороты.Invoice
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют КАК ВнутренниеКурсыВалют
	|		ПО ВТ_Инвойсы.Currency = ВнутренниеКурсыВалют.Валюта
	|			И (НАЧАЛОПЕРИОДА(ВТ_Инвойсы.InvoiceДата, МЕСЯЦ) = ВнутренниеКурсыВалют.Период)
	|ГДЕ
	|	InvoicedDebtsОбороты.Amount <> 0"
	;

	Запрос.УстановитьПараметр("Account", ПланыСчетов.Lawson.TradeReceivables);
	Запрос.УстановитьПараметр("USD", Справочники.Валюты.НайтиПоКоду("840"));
	Запрос.УстановитьПараметр("Начало", МинимальнаяДатаИнвойса);
	Запрос.УстановитьПараметр("Конец", МаксимальнаяДатаИнвойса);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ_ДляКорректировки = РезультатЗапроса.Выгрузить();
		
	УстановитьПривилегированныйРежим(Истина);

	Док = Документы.КорректировкаРегистров.СоздатьДокумент();
	Док.ДополнительныеСвойства.Вставить("РазрешитьСозданиеДокументаБезРеверса", Истина);
	Док.Дата = ТекущаяДата();
	Док.Комментарий = "Инвойсы из загрузки: " + ДокументЗагрузки;
	Док.Ответственный = Пользователи.ТекущийПользователь();
	
	Док.Движения.InvoicedDebts.Загрузить(ТЗ_ДляКорректировки);
	
	СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
	СтрокаТаблицыРегистров.Имя = "InvoicedDebts";
	
	Док.Движения.InvoicedDebts.Записывать = Истина;
	
	Док.Записать();
	
	Для каждого СтрокаТЗ Из ТЗ_ДляКорректировки Цикл
	
		Если СтрокаТЗ.НеобходимоДозаполнить Тогда
		
			ДозаполнитьИнвойс(СтрокаТЗ)
		
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

Процедура ДозаполнитьИнвойс(СтрокаТЗ)
	
	ИнвойсОбъект = СтрокаТЗ.Invoice.ПолучитьОбъект();
	РГСофтКлиентСервер.УстановитьЗначение(ИнвойсОбъект.Currency, СтрокаТЗ.Currency);
	РГСофтКлиентСервер.УстановитьЗначение(ИнвойсОбъект.Client, СтрокаТЗ.Client);
	РГСофтКлиентСервер.УстановитьЗначение(ИнвойсОбъект.ClientID, СтрокаТЗ.CustomerNumber);
	РГСофтКлиентСервер.УстановитьЗначение(ИнвойсОбъект.AU, СтрокаТЗ.AU);
	ИнвойсОбъект.Записать();
	
КонецПроцедуры

Процедура ДозаполнитьSO(SO, JobEndDate)
	
		SalesOrderОбъект = SO.ПолучитьОбъект();
		РГСофтКлиентСервер.УстановитьЗначение(SalesOrderОбъект.JobEndDate, JobEndDate);
		SalesOrderОбъект.ОбменДанными.Загрузка = Истина;
		SalesOrderОбъект.Записать();
	
КонецПроцедуры

#КонецЕсли