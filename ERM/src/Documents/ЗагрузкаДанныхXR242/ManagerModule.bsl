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
	
	// Date
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceDate";
	СтрокаТЗ.ИмяКолонки = "InvoiceDate";
	
	// ArInvoice
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ArInvoice";
	СтрокаТЗ.ИмяКолонки = "InvPreInvoice";
	
	
	
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

Процедура ОбновитьРеквизитыInvoices(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	XR242SourceData.ArInvoice КАК ArInvoice,
	|	XR242SourceData.InvoiceDate,
	|	ЕСТЬNULL(Организации.Ссылка, ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)) КАК Организация
	|ПОМЕСТИТЬ ВТ_ИсходныеДанные
	|ИЗ
	|	РегистрСведений.XR242SourceData КАК XR242SourceData
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО XR242SourceData.Company = Организации.Код
	|		И Организации.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|ГДЕ
	|	XR242SourceData.ДокументЗагрузки = &Ссылка
	|ИНДЕКСИРОВАТЬ ПО
	|	ArInvoice, Организация
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИсходныеДанные.ArInvoice,
	|	ВТ_ИсходныеДанные.InvoiceDate,
	|	ЕСТЬNULL(КлючиИнвойсов.Invoice, ЗНАЧЕНИЕ(Документ.Invoice.ПустаяСсылка)) КАК Invoice
	|ИЗ
	|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.КлючиИнвойсов КАК КлючиИнвойсов
	|		ПО ВТ_ИсходныеДанные.ArInvoice = КлючиИнвойсов.ArInvoice
	|		И ВТ_ИсходныеДанные.Организация = КлючиИнвойсов.Company
	|		И КлючиИнвойсов.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)";
	
	Запрос.УстановитьПараметр("Ссылка", СтруктураПараметров.Ссылка);
	
	НачатьТранзакцию();
	Выборка = Запрос.Выполнить().Выбрать();
	ЗафиксироватьТранзакцию();
	
	ОбновленныеInvoice = Новый ТаблицаЗначений;
	ОбновленныеInvoice.Колонки.Добавить("Invoice", Новый ОписаниеТипов("ДокументСсылка.Invoice"));
	
	НенайденныеInvoices = Новый ТаблицаЗначений;
	НенайденныеInvoices.Колонки.Добавить("InvoiceNumber", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(12)));
	
	Даты = Новый Соответствие();
	
	НачатьТранзакцию();
	
	Пока Выборка.Следующий() Цикл
		
		Если Не ПустаяСтрока(Выборка.ArInvoice) И НЕ ЗначениеЗаполнено(Выборка.Invoice) Тогда
			
			СтрокаТЗ = НенайденныеInvoices.Добавить();
			СтрокаТЗ.InvoiceNumber = Выборка.ArInvoice;
			
		ИначеЕсли ЗначениеЗаполнено(Выборка.Invoice) Тогда
			
			Даты.Вставить("InvoiceFlagDate", РГСофт.ПреобразоватьВДату(Выборка.InvoiceDate, "Date"));
			РегистрыСведений.DIR.ЗаписатьДаты(Выборка.Invoice, Даты);
			
			СтрокаТЗ = ОбновленныеInvoice.Добавить();
			СтрокаТЗ.Invoice = Выборка.Invoice;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
	ОбновленныеInvoice.Свернуть("Invoice");
	НенайденныеInvoices.Свернуть("InvoiceNumber");
	
	ДанныеДляЗаполнения.Вставить("ОбновленныеInvoice", ОбновленныеInvoice);
	ДанныеДляЗаполнения.Вставить("НенайденныеInvoices", НенайденныеInvoices);
		
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

#КонецЕсли