
Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	СтруктураКолонок = СтруктураПараметров.СтруктураКолонок;
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	ТекстОшибки = "";
	
	ФайлДанных = СтруктураПараметров.ИсточникДанных.Получить();
	
	ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
	СоздатьКаталог(ИмяКаталога);
	ПутьКФайлу = ИмяКаталога + "\HOB_DIR.csv";
	
	ФайлДанных.Записать(ПутьКФайлу);
	
	ПутьСхемы = ИмяКаталога+"\schema.ini";
	ФайлСхемы = Новый ТекстовыйДокумент;
	ФайлСхемы.УстановитьТекст(Документы.ЗагрузкаДанныхДатыDIRИзГИС.ПолучитьМакет("HOB_DIRSchema").ПолучитьТекст());
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
	
	Стр_SQL = "Select * FROM HOB_DIR.csv";
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
	
	ЗагрузитьИЗаписатьДвижения(СтруктураПараметров, ТаблицаДанных);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция ПолучитьСтруктуруКолонокТаблицыДанных() Экспорт
	
	СтруктураКолонок = Новый ТаблицаЗначений;
	СтруктураКолонок.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("ИмяКолонки", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("Обязательная", Новый ОписаниеТипов("Булево"));
	
	ПолучитьСтруктуруКолонокТаблицыДанныхДатыDIRИзГИС(СтруктураКолонок);
	
	Возврат СтруктураКолонок;
	
КонецФункции

Процедура ПолучитьСтруктуруКолонокТаблицыДанныхДатыDIRИзГИС(СтруктураКолонок)
	
	// Document
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Document";
	СтрокаТЗ.ИмяКолонки = "Document";
	СтрокаТЗ.Обязательная = Истина;
	
	// JobStartDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "JobStartDate";
	СтрокаТЗ.ИмяКолонки = "JobStartDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// JobEndDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "JobEndDate";
	СтрокаТЗ.ИмяКолонки = "JobEndDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// FTLSubmissionDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FTLSubmissionDate";
	СтрокаТЗ.ИмяКолонки = "FTLSubmissionDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// CreationDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreationDate";
	СтрокаТЗ.ИмяКолонки = "CreationDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// ApprovalDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ApprovalDate";
	СтрокаТЗ.ИмяКолонки = "ApprovalDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// FirstSubmissionDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FirstSubmissionDate";
	СтрокаТЗ.ИмяКолонки = "FirstSubmissionDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceFlagDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceFlagDate";
	СтрокаТЗ.ИмяКолонки = "InvoiceFlagDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// DocumentID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentID";
	СтрокаТЗ.ИмяКолонки = "DocumentID";
	СтрокаТЗ.Обязательная = Истина;
	
КонецПроцедуры

Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля);
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Добавить("СтрокаФайла", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Неотрицательный)));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура ЗагрузитьИЗаписатьДвижения(СтруктураПараметров, ТаблицаДанных)
	
	ТаблицаДанных.Колонки.Добавить("ДокументЗагрузки");
	ТаблицаДанных.ЗаполнитьЗначения(СтруктураПараметров.Ссылка, "ДокументЗагрузки");
	
	НЗ = РегистрыСведений.ДатыDIRИзГИСSourceData.СоздатьНаборЗаписей();
	НЗ.Отбор.ДокументЗагрузки.Установить(СтруктураПараметров.Ссылка);
	НЗ.Загрузить(ТаблицаДанных);
	НЗ.Записать(Истина);
	
	// { RGS TAlmazova 14.07.2016 19:30:40 - установка статуса документа
	ДокументЗагрузки = СтруктураПараметров.Ссылка.ПолучитьОбъект();
	ДокументЗагрузки.СтатусЗагрузки = Перечисления.СтатусыЗагрузки.LoadedSourseData;
	ДокументЗагрузки.Записать();
	// } RGS TAlmazova 14.07.2016 19:30:45 - установка статуса документа
	
КонецПроцедуры

Процедура ОбновитьДатыВDIR(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	SalesOrder.Ссылка КАК СсылкаSalesOrder,
	|	ДатыDIRИзГИСSourceData.Document КАК Document,
	|	ДатыDIRИзГИСSourceData.JobStartDate КАК JobStartDate,
	|	ДатыDIRИзГИСSourceData.JobEndDate КАК JobEndDate,
	|	ДатыDIRИзГИСSourceData.FTLSubmissionDate КАК FTLSubmissionDate,
	|	ДатыDIRИзГИСSourceData.CreationDate КАК CreationDate,
	|	ДатыDIRИзГИСSourceData.ApprovalDate КАК ApprovalDate,
	|	ДатыDIRИзГИСSourceData.FirstSubmissionDate КАК FirstSubmissionDate,
	|	ДатыDIRИзГИСSourceData.InvoiceFlagDate КАК InvoiceFlagDate,
	|	ДатыDIRИзГИСSourceData.DocumentID КАК DocumentID
	|ИЗ
	|	РегистрСведений.ДатыDIRИзГИСSourceData КАК ДатыDIRИзГИСSourceData
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.SalesOrder КАК SalesOrder
	|		ПО (НЕ SalesOrder.ПометкаУдаления)
	|			И (SalesOrder.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.HOBs))
	|			И ДатыDIRИзГИСSourceData.DocumentID = SalesOrder.DocID
	|ГДЕ
	|	ДатыDIRИзГИСSourceData.ДокументЗагрузки = &Ссылка
	|	И НЕ SalesOrder.Ссылка ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("Ссылка", СтруктураПараметров.Ссылка);
	
	НачатьТранзакцию();
	РезультатЗапроса = Запрос.Выполнить();
	ЗафиксироватьТранзакцию();
	
	ВыборкаSO = РезультатЗапроса.Выбрать();
	
	ОбновленныеSO = Новый ТаблицаЗначений;
	ОбновленныеSO.Колонки.Добавить("SalesOrder", Новый ОписаниеТипов("ДокументСсылка.SalesOrder"));
	Даты = Новый Соответствие();

	
	Пока ВыборкаSO.Следующий() Цикл
		
		ТекОбъект = ВыборкаSO.СсылкаSalesOrder.ПолучитьОбъект();
		
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.JobStartDate, ВыборкаSO.JobStartDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.JobEndDate, ВыборкаSO.JobEndDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FTLSubmissionDate, ВыборкаSO.FTLSubmissionDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.CreationDate, ВыборкаSO.CreationDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.ApprovalDate, ВыборкаSO.ApprovalDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.FirstSubmissionDate, ВыборкаSO.FirstSubmissionDate);
		РГСофтКлиентСервер.УстановитьЗначение(ТекОбъект.InvoiceFlagDate, ВыборкаSO.InvoiceFlagDate);
		Даты.Вставить("JobStartDate", ВыборкаSO.JobStartDate);
		Даты.Вставить("JobEndDate", ВыборкаSO.JobEndDate);
		Даты.Вставить("FTLSubmissionDate", ВыборкаSO.FTLSubmissionDate);
		Даты.Вставить("CreationDate", ВыборкаSO.CreationDate);
		Даты.Вставить("ApprovalDate", ВыборкаSO.ApprovalDate);
		Даты.Вставить("FirstSubmissionDate", ВыборкаSO.FirstSubmissionDate);
		Даты.Вставить("InvoiceFlagDate", ВыборкаSO.InvoiceFlagDate);
		
		Если ТекОбъект.Модифицированность() Тогда
			
			Попытка
				ТекОбъект.Записать();
			Исключение
				ОтменитьТранзакцию();
				ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", Строка(ТекОбъект) + ": " + ОписаниеОшибки());
				ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
				Возврат;
			КонецПопытки;
			
		КонецЕсли;
		
		
		РегистрыСведений.DIR.ЗаписатьДаты(ВыборкаSO.СсылкаSalesOrder, Даты);
		СтрокаТЗ = ОбновленныеSO.Добавить();
		СтрокаТЗ.SalesOrder = ВыборкаSO.СсылкаSalesOrder;
		
	КонецЦикла;
		
	ОбновленныеSO.Свернуть("SalesOrder");
	ДанныеДляЗаполнения.Вставить("ОбновленныеSO", ОбновленныеSO);
		
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
		
КонецПроцедуры
