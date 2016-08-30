﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.ПроверятьСуществованиеФайла	= Истина;
	ДиалогОткрытияФайла.Заголовок = "Select a file to loading";
	
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ИмяФайлаНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		Объект.ИмяФайла = ВыбранныеФайлы[0];
	КонецЕсли;
	
	АдресВХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Объект.ИмяФайла), УникальныйИдентификатор);


КонецПроцедуры


&НаСервере
Процедура ПрочитатьФайлНаСервере()
	
	ТаблицаКоллизий.Очистить();
	
	ДанныеДляЗаполнения = Новый Структура();
	ТекстОшибки = "";
	
	ДД = ПолучитьИзВременногоХранилища(АдресВХранилище);
	ИмяФайла = ПолучитьИмяВременногоФайла("csv");
	ДД.Записать(ИмяФайла);
	Разделитель = "\";
	Строки = СтрЗаменить(ИмяФайла, Разделитель, Символы.ПС);
	Путь = "";
	ТолькоИмяФайла = СтрПолучитьСтроку(Строки, СтрЧислоСтрок(Строки));
	Для Индекс = 1 По СтрЧислоСтрок(Строки)-1 Цикл
		Путь = Путь + СтрПолучитьСтроку(Строки, Индекс) + "\";
	КонецЦикла;
	ИмяКаталога = Лев(Путь, СтрДлина(Путь)-1);
	
	ПутьСхемы = ИмяКаталога+"\schema.ini";
	ФайлСхемы = Новый ТекстовыйДокумент;
	ФайлСхемы.ДобавитьСтроку("["+ ТолькоИмяФайла +"]" + Символы.ПС + "DecimalSymbol=.");
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
	
	Стр_SQL = "Select * FROM " + ТолькоИмяФайла;
	rs.Open(Стр_SQL, Connection);
	
	СоответствиеКолонок = Новый Соответствие;
	Для каждого ЭлементСтруктурыКолонок Из СтруктураКолонок Цикл
		СоответствиеКолонок.Вставить(ЭлементСтруктурыКолонок.ИмяПоля, ЭлементСтруктурыКолонок.ИмяКолонки);
	КонецЦикла;
	
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	
	rs.MoveFirst();
	
	Пока rs.EOF() = 0 Цикл
		
		СтрокаДанных = ТаблицаДанных.Добавить();
		
		Для каждого ЭлементСоответствия Из СоответствиеКолонок Цикл
			
			Попытка
				ТекЗначение = rs.Fields(ЭлементСоответствия.Значение).Value;
			Исключение
				ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ОписаниеОшибки());
				ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресВХранилище);
				Возврат;
			КонецПопытки;
				
			Если ТипЗнч(ТекЗначение) = ТипЗнч("Строка") Тогда
				СтрокаДанных[ЭлементСоответствия.Ключ] = СокрЛП(ТекЗначение);
			ИначеЕсли ТипЗнч(СтрокаДанных[ЭлементСоответствия.Ключ]) =  ТипЗнч("Строка")Тогда
				СтрокаДанных[ЭлементСоответствия.Ключ] = Формат(ТекЗначение, "ЧРГ=; ЧН=0; ЧГ=0");
				Если ЭлементСоответствия.Значение = "AcctUnit" Тогда 
					Пока СтрДлина(СтрокаДанных[ЭлементСоответствия.Ключ])<7 Цикл
						СтрокаДанных[ЭлементСоответствия.Ключ] = "0" + СтрокаДанных[ЭлементСоответствия.Ключ];
					КонецЦикла;
				КонецЕсли;
			Иначе
				СтрокаДанных[ЭлементСоответствия.Ключ] = ТекЗначение;
			КонецЕсли;
			
		КонецЦикла;
		
		rs.MoveNext();
		
	КонецЦикла;
	
	rs.Close();
	Connection.Close();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КостЦентры.Код как AccountUnit
		|ИЗ
		|	Справочник.КостЦентры КАК КостЦентры
		|ГДЕ
		|	КостЦентры.ПодразделениеОрганизации.GeoMarket.Родитель = &GeoMarket";
	
	Запрос.УстановитьПараметр("GeoMarket", GeoMarket);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаКодовAccountUnit = РезультатЗапроса.Выгрузить();
	
	МассивAccountUnit = ТаблицаКодовAccountUnit.ВыгрузитьКолонку("AccountUnit");
	
	Результат = ПроверитьКорректностьДанных(ТаблицаДанных, МассивAccountUnit);
	
	Если Результат Тогда
		СоздатьЗаписиРегистра(ТаблицаДанных, МассивAccountUnit);
	КонецЕсли;
	
	
	//УдалитьФайлы(ИмяКаталога);
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	ПрочитатьФайлНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруФайлаПоУмолчанию()
	
	ПерваяСтрокаДанных = 2;
	ИменаКолонокВПервойСтроке = Истина;
	ЗаполнитьСтруктуруКолонокПоУмолчанию();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчанию()
	
	СтруктураКолонок.Очистить();
	
	ТипСтрока = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(100));
	ТипЧисло = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2));
	ТипДата = Новый ОписаниеТипов("Дата");
	
	// Company
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Company";
	СтрокаТЗ.ИмяКолонки = "Company";
	СтрокаТЗ.ТипКолонки = ТипЧисло;

	
	// Location
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Location";
	СтрокаТЗ.ИмяКолонки = "Location";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// TransType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TransType";
	СтрокаТЗ.ИмяКолонки = "TransType";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// AcctUnit
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AcctUnit";
	СтрокаТЗ.ИмяКолонки = "AcctUnit";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	////
	// Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "Account";
	СтрокаТЗ.ТипКолонки = ТипЧисло;
	
	//// Customer
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Customer";
	СтрокаТЗ.ИмяКолонки = "Customer";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// TransDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TransDate";
	СтрокаТЗ.ИмяКолонки = "TransDate";
	СтрокаТЗ.ТипКолонки = ТипДата;

	// Invoice
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Invoice";
	СтрокаТЗ.ИмяКолонки = "Invoice";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	  
	// RemAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "RemAmount";
	СтрокаТЗ.ИмяКолонки = "RemAmount";
	СтрокаТЗ.ТипКолонки = ТипЧисло;
	
	//// OrigAmt
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "OrigAmt";
	//СтрокаТЗ.ИмяКолонки = "OrigAmt";
	//СтрокаТЗ.ТипКолонки = ТипЧисло;
	
	//// BaseCurEquiv
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "BaseCurEquiv";
	//СтрокаТЗ.ИмяКолонки = "BaseCurEquiv";
	//СтрокаТЗ.ТипКолонки = ТипЧисло;
	
	// Mgmtctry
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Mgmtctry";
	СтрокаТЗ.ИмяКолонки = "Mgmtctry";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// CurrencyCd
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "OrigCurrency";
	СтрокаТЗ.ИмяКолонки = "OrigCurrency";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// Subsubseg
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Subsubseg";
	СтрокаТЗ.ИмяКолонки = "Subsubseg";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
КонецПроцедуры

&НаСервере
Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля,ТекСтрокаСтруктурыКолонок.ТипКолонки);
	КонецЦикла;
	
	Возврат ТаблицаДанных;
	
КонецФункции

&НаСервере
Функция ПроверитьКорректностьДанных(ТаблицаДанных, МассивAccountUnit)
	Результат = Ложь;
	ПериодНач = НачалоМесяца(Период);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИсходныхДанных.AcctUnit КАК AccountUnit,
	|	ТаблицаИсходныхДанных.OrigCurrency КАК CurrencyCode,
	|	ТаблицаИсходныхДанных.Account,
	|	ТаблицаИсходныхДанных.Company,
	|	ТаблицаИсходныхДанных.Customer,
	|	ТаблицаИсходныхДанных.SubSubSeg,
	|	ТаблицаИсходныхДанных.Mgmtctry,
	|	ТаблицаИсходныхДанных.Location
	|ПОМЕСТИТЬ врТЗТаблицаДанных
	|ИЗ
	|	&ВнешняяТаблицаДанных КАК ТаблицаИсходныхДанных
	|ГДЕ
	|	((ВЫРАЗИТЬ(ТаблицаИсходныхДанных.Account / 1000 - 0.5 КАК ЧИСЛО(15, 0))) = 120
	|			ИЛИ (ВЫРАЗИТЬ(ТаблицаИсходныхДанных.Account / 1000 - 0.5 КАК ЧИСЛО(15, 0))) = 209)
	|	И ТаблицаИсходныхДанных.AcctUnit В(&AcctUnit)"
	;
	Запрос.УстановитьПараметр("ВнешняяТаблицаДанных", ТаблицаДанных);
	Запрос.УстановитьПараметр("AcctUnit", МассивAccountUnit);
	Запрос.Выполнить();
	
	ДанныеДляЗаполнения = Новый Структура();
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ КАК КоллизияОтработана,
		|	""Specify the 1C object"" КАК Описание,
		|	&ТипВнешнейСистемы КАК ТипСоответствия,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency) КАК ТипОбъектаВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ОбъектПриемника,
		|	врТЗТаблицаДанных.CurrencyCode КАК Идентификатор
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)) КАК НастройкаСинхронизацииCurrency
		|		ПО врТЗТаблицаДанных.CurrencyCode = НастройкаСинхронизацииCurrency.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииCurrency.ОбъектПриемника ЕСТЬ NULL 
		|	И НЕ врТЗТаблицаДанных.CurrencyCode = """"
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ,
		|	""Failed to find Account"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Account),
		|	ЗНАЧЕНИЕ(ПланСчетов.Lawson.ПустаяСсылка),
		|	врТЗТаблицаДанных.Account
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК Lawson
		|		ПО врТЗТаблицаДанных.Account = Lawson.КодЧислом
		|			И (НЕ Lawson.ПометкаУдаления)
		|ГДЕ
		|	врТЗТаблицаДанных.Account <> 0
		|	И Lawson.Ссылка ЕСТЬ NULL 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ,
		|	""Failed to find Company"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Company),
		|	ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка),
		|	врТЗТаблицаДанных.Company
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО (НЕ Организации.ПометкаУдаления)
		|			И врТЗТаблицаДанных.Company = Организации.Код
		|			И (Организации.Source = &ТипВнешнейСистемы)
		|ГДЕ
		|	врТЗТаблицаДанных.Company <> 0
		|	И Организации.Ссылка ЕСТЬ NULL 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ,
		|	""Failed to find Sub-Sub-Segment"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment),
		|	ЗНАЧЕНИЕ(Справочник.Сегменты.ПустаяСсылка),
		|	врТЗТаблицаДанных.SubSubSeg
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сегменты КАК Сегменты
		|		ПО (НЕ Сегменты.ПометкаУдаления)
		|			И врТЗТаблицаДанных.SubSubSeg = Сегменты.Код
		|			И (Сегменты.Source = &ТипВнешнейСистемы)
		|ГДЕ
		|	Сегменты.Ссылка ЕСТЬ NULL 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ,
		|	""Failed to find Location"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Location),
		|	ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка),
		|	врТЗТаблицаДанных.Location
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
		|		ПО (НЕ ПодразделенияОрганизаций.ПометкаУдаления)
		|			И врТЗТаблицаДанных.Location = ПодразделенияОрганизаций.Код
		|			И (ПодразделенияОрганизаций.Source = &ТипВнешнейСистемы)
		|ГДЕ
		|	ПодразделенияОрганизаций.Ссылка ЕСТЬ NULL 
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ,
		|	""Failed to find Accounting Unit"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.AccountingUnit),
		|	ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка),
		|	врТЗТаблицаДанных.AccountUnit
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
		|		ПО (НЕ КостЦентры.ПометкаУдаления)
		|			И врТЗТаблицаДанных.AccountUnit = КостЦентры.Код
		|ГДЕ
		|	КостЦентры.Ссылка ЕСТЬ NULL 
		//|;
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ЛОЖЬ,
		|	""Failed to find Client"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client),
		|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),
		|	врТЗТаблицаДанных.Customer
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				,
		|				ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|					И ТипСоответствия = &ТипВнешнейСистемы) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|		ПО врТЗТаблицаДанных.Customer = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор ЕСТЬ NULL 
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КостЦентры.Сегмент КАК Ссылка,
		|	ЕСТЬNULL(HFM_Technology.Ссылка, ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)) КАК БазовыйЭлемент,
		|	КостЦентры.Сегмент.Код КАК Код
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Technology КАК HFM_Technology
		|			ПО КостЦентры.Сегмент.Код = HFM_Technology.Код
		|				И (НЕ HFM_Technology.ПометкаУдаления)
		|		ПО врТЗТаблицаДанных.AccountUnit = КостЦентры.Код
		|			И (НЕ КостЦентры.ПометкаУдаления)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КостЦентры.ПодразделениеОрганизации.Ссылка КАК Ссылка,
		|	КостЦентры.ПодразделениеОрганизации.Код КАК Код,
		|	ЕСТЬNULL(HFM_Locations.Ссылка, ЗНАЧЕНИЕ(Справочник.HFM_Locations.ПустаяСсылка)) КАК LocationПоSubGeomarket,
		|	ЕСТЬNULL(HFM_Locations1.Ссылка, ЗНАЧЕНИЕ(Справочник.HFM_Locations.ПустаяСсылка)) КАК LocationПоMgmtctry
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Locations КАК HFM_Locations1
		|		ПО врТЗТаблицаДанных.Mgmtctry = HFM_Locations1.Код
		|			И (НЕ HFM_Locations1.ПометкаУдаления)
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
		|			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Locations КАК HFM_Locations
		|			ПО КостЦентры.ПодразделениеОрганизации.GeoMarket.Код = HFM_Locations.Код
		|				И (НЕ HFM_Locations.ПометкаУдаления)
		|		ПО врТЗТаблицаДанных.AccountUnit = КостЦентры.Код
		|			И (НЕ КостЦентры.ПометкаУдаления)
		|ГДЕ
		|	КостЦентры.ПодразделениеОрганизации.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Locations.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Lawson.Ссылка,
		|	Lawson.Код
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК Lawson
		|		ПО врТЗТаблицаДанных.Account = Lawson.КодЧислом
		|			И (НЕ Lawson.ПометкаУдаления)
		|ГДЕ
		|	Lawson.БазовыйЭлемент = ЗНАЧЕНИЕ(ПланСчетов.HFM_GL_Accounts.ПустаяСсылка)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Организации.Ссылка,
		|	Организации.Код
		|ИЗ
		|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
		|		ПО врТЗТаблицаДанных.Company = Организации.Код
		|			И (НЕ Организации.ПометкаУдаления)
		|			И (Организации.Source = &ТипВнешнейСистемы)
		|ГДЕ
		|	Организации.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Companies.ПустаяСсылка)"
		;
	
	Запрос.УстановитьПараметр("Период", ПериодНач);
	Запрос.УстановитьПараметр("ТипВнешнейСистемы", Перечисления.ТипыСоответствий.Lawson);
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаКоллизий1 = МассивРезультатов[0].Выгрузить();
	
	ВыборкаСегментов = МассивРезультатов[1].Выбрать();
	
	Пока ВыборкаСегментов.Следующий() Цикл
		
		Если ВыборкаСегментов.БазовыйЭлемент.Пустая() Тогда
			
			СтрокаКоллизии = ТаблицаКоллизий1.Добавить();
			СтрокаКоллизии.КоллизияОтработана = Ложь;
			СтрокаКоллизии.Описание = "Not specified base element";
			СтрокаКоллизии.ТипСоответствия = Перечисления.ТипыСоответствий.Lawson;
			СтрокаКоллизии.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Segment;
			СтрокаКоллизии.ОбъектПриемника = ВыборкаСегментов.Ссылка;
			СтрокаКоллизии.Идентификатор = ВыборкаСегментов.Код;
			
		Иначе
			
			ТекОбъект = ВыборкаСегментов.Ссылка.ПолучитьОбъект();
			ТекОбъект.БазовыйЭлемент = ВыборкаСегментов.БазовыйЭлемент;
			ТекОбъект.Записать();
			
		КонецЕсли;
		
	КонецЦикла;
	
	// локации
	ВыборкаЛокаций = МассивРезультатов[2].Выбрать();
	
	Пока ВыборкаЛокаций.Следующий() Цикл
		
		Если НЕ ВыборкаЛокаций.LocationПоSubGeomarket.Пустая() Тогда
			
			ТекОбъект = ВыборкаЛокаций.Ссылка.ПолучитьОбъект();
			ТекОбъект.БазовыйЭлемент = ВыборкаЛокаций.LocationПоSubGeomarket;
			ТекОбъект.Записать();
			
		ИначеЕсли НЕ ВыборкаЛокаций.LocationПоMgmtctry.Пустая() Тогда
			
			ТекОбъект = ВыборкаЛокаций.Ссылка.ПолучитьОбъект();
			ТекОбъект.БазовыйЭлемент = ВыборкаЛокаций.LocationПоMgmtctry;
			ТекОбъект.Записать();
			
		Иначе
			
			СтрокаКоллизии = ТаблицаКоллизий1.Добавить();
			СтрокаКоллизии.КоллизияОтработана = Ложь;
			СтрокаКоллизии.Описание = "Not specified base element";
			СтрокаКоллизии.ТипСоответствия = Перечисления.ТипыСоответствий.Lawson;
			СтрокаКоллизии.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Location;
			СтрокаКоллизии.ОбъектПриемника = ВыборкаЛокаций.Ссылка;
			СтрокаКоллизии.Идентификатор = ВыборкаЛокаций.Код;
			
		КонецЕсли;
		
	КонецЦикла;
	
	// счета
	ВыборкаСчетов = МассивРезультатов[3].Выбрать();
	
	Пока ВыборкаСчетов.Следующий() Цикл
		
		СтрокаКоллизии = ТаблицаКоллизий1.Добавить();
		СтрокаКоллизии.КоллизияОтработана = Ложь;
		СтрокаКоллизии.Описание = "Not specified base element";
		СтрокаКоллизии.ТипСоответствия = Перечисления.ТипыСоответствий.Lawson;
		СтрокаКоллизии.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Account;
		СтрокаКоллизии.ОбъектПриемника = ВыборкаСчетов.Ссылка;
		СтрокаКоллизии.Идентификатор = ВыборкаСчетов.Код;
		
	КонецЦикла;
	
	// организации
	ВыборкаКомпаний = МассивРезультатов[4].Выбрать();
	
	Пока ВыборкаКомпаний.Следующий() Цикл
		
		СтрокаКоллизии = ТаблицаКоллизий1.Добавить();
		СтрокаКоллизии.КоллизияОтработана = Ложь;
		СтрокаКоллизии.Описание = "Not specified base element";
		СтрокаКоллизии.ТипСоответствия = Перечисления.ТипыСоответствий.Lawson;
		СтрокаКоллизии.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Company;
		СтрокаКоллизии.ОбъектПриемника = ВыборкаКомпаний.Ссылка;
		СтрокаКоллизии.Идентификатор = ВыборкаКомпаний.Код;
		
	КонецЦикла;
	
	ДанныеДляЗаполнения.Вставить("ТаблицаКоллизий1", ТаблицаКоллизий1);
	ТаблицаКоллизий.Загрузить(ТаблицаКоллизий1);
	
	Если ТаблицаКоллизий.Количество() = 0 Тогда
		Результат = Истина;
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Процедура СоздатьЗаписиРегистра(ТаблицаДанных, МассивAccountUnit)
	
	СтруктураПоискаBatch = Новый Структура("Source, Company, Client, Location, SubSubSegment, AU, Account, Currency");
	ПериодНач = НачалоМесяца(Период);
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИсходныхДанных.AcctUnit КАК AccountUnit,
	|	ТаблицаИсходныхДанных.OrigCurrency КАК CurrencyCode,
	|	ТаблицаИсходныхДанных.Account КАК AccountCode,
	|	ТаблицаИсходныхДанных.Company КАК CompanyCode,
	|	ТаблицаИсходныхДанных.SubSubSeg,
	|	ТаблицаИсходныхДанных.Mgmtctry,
	|	ТаблицаИсходныхДанных.TransType,
	|	ТаблицаИсходныхДанных.Invoice,
	|	ТаблицаИсходныхДанных.Customer,
	|	ТаблицаИсходныхДанных.RemAmount,
	|	ТаблицаИсходныхДанных.Location
	|ПОМЕСТИТЬ врТЗТаблицаДанных
	|ИЗ
	|	&ВнешняяТаблицаДанных КАК ТаблицаИсходныхДанных
	|ГДЕ
	|	((ВЫРАЗИТЬ(ТаблицаИсходныхДанных.Account / 1000 - 0.5 КАК ЧИСЛО(15, 0))) = 120
	|			ИЛИ (ВЫРАЗИТЬ(ТаблицаИсходныхДанных.Account / 1000 - 0.5 КАК ЧИСЛО(15, 0))) = 209)
	|	И ТаблицаИсходныхДанных.AcctUnit В(&AcctUnit)"
	;
	Запрос.УстановитьПараметр("ВнешняяТаблицаДанных", ТаблицаДанных);
	Запрос.УстановитьПараметр("AcctUnit", МассивAccountUnit);
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КлючиИнвойсов.ArInvoice,
	|	КлючиИнвойсов.Invoice
	|ИЗ
	|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
	|		ПОЛНОЕ СОЕДИНЕНИЕ РегистрСведений.КлючиИнвойсов КАК КлючиИнвойсов
	|		ПО врТЗТаблицаДанных.Invoice = КлючиИнвойсов.ArInvoice
	|ГДЕ
	|	КлючиИнвойсов.Source = &Source
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КлючиCashBatch.Source,
	|	КлючиCashBatch.Company,
	|	КлючиCashBatch.Client,
	|	КлючиCashBatch.Location,
	|	КлючиCashBatch.SubSubSegment,
	|	КлючиCashBatch.AU,
	|	КлючиCashBatch.Account,
	|	КлючиCashBatch.Currency,
	|	КлючиCashBatch.CashBatch КАК CashBatch
	|ИЗ
	|	РегистрСведений.КлючиCashBatch КАК КлючиCashBatch
	|ГДЕ
	|	КлючиCashBatch.Source = &Source
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	КостЦентры.ПодразделениеОрганизации.GeoMarket КАК GeoMarket
	|ИЗ
	|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
	|		ПО врТЗТаблицаДанных.AccountUnit = КостЦентры.Код
	|			И (НЕ КостЦентры.ПометкаУдаления)
	|
	|СГРУППИРОВАТЬ ПО
	|	КостЦентры.ПодразделениеОрганизации.GeoMarket
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	врТЗТаблицаДанных.RemAmount КАК RemAmount,
	|	врТЗТаблицаДанных.TransType,
	|	врТЗТаблицаДанных.Invoice,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника КАК Client,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних1.ОбъектПриемника КАК Currency,
	|	Организации.Ссылка КАК Company,
	|	Lawson.Ссылка КАК Account,
	|	КостЦентры.Ссылка КАК AU,
	|	КостЦентры.Сегмент КАК SubSubSegment,
	|	КостЦентры.ПодразделениеОрганизации КАК Location,
	|	КостЦентры.ПодразделениеОрганизации.GeoMarket КАК GeoMarket
	|ИЗ
	|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(, ТипСоответствия = &Source) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
	|		ПО врТЗТаблицаДанных.Customer = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(, ТипСоответствия = &Source) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних1
	|		ПО врТЗТаблицаДанных.CurrencyCode = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних1.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО врТЗТаблицаДанных.CompanyCode = Организации.Код
	|			И (НЕ Организации.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК Lawson
	|		ПО врТЗТаблицаДанных.AccountCode = Lawson.КодЧислом
	|			И (НЕ Lawson.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
	|		ПО врТЗТаблицаДанных.AccountUnit = КостЦентры.Код
	|			И (НЕ КостЦентры.ПометкаУдаления)
	|ГДЕ
	|	Организации.Source = &Source";
	
	Запрос.УстановитьПараметр("Период", ПериодНач);
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.Lawson);
	
	//РезультатЗапроса = Запрос.Выполнить();
	НачатьТранзакцию();
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ЗафиксироватьТранзакцию();
	
	КэшИнвойсов = РезультатЗапроса[0].Выгрузить();
	КэшИнвойсов.Индексы.Добавить("ArInvoice");
	
	КэшCashBatch = РезультатЗапроса[1].Выгрузить();
	КэшCashBatch.Индексы.Добавить("Source, Company, Client, Location, SubSubSegment, AU, Account, Currency");
	
	КэшГеоМаркеты = РезультатЗапроса[2].Выгрузить();
	//КэшГеоМаркеты.Индексы.Добавить("GeoMarket");
	//ТЗ_ГеоМаркеты = РезультатЗапроса[3].Выгрузить();
	//ТЗ_ГеоМаркеты.Свернуть("GeoMarket");
	
	МассивГеоМаркетов = КэшГеоМаркеты.ВыгрузитьКолонку("GeoMarket");
	
	ВыборкаДанные = РезультатЗапроса[3].Выбрать();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ARBalance.Location
		|ИЗ
		|	РегистрСведений.ARBalance КАК ARBalance
		|ГДЕ
		|	ARBalance.Location.GeoMarket В(&GeoMarket)
		|	И ARBalance.Период = &Период";
	
	Запрос.УстановитьПараметр("GeoMarket", МассивГеоМаркетов);
	Запрос.УстановитьПараметр("Период", ПериодНач);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаПоЛокациям = РезультатЗапроса.Выбрать();
	
	ARBalance = РегистрыСведений.ARBalance;
	НаборЗаписей = ARBalance.СоздатьНаборЗаписей();
		
	Пока ВыборкаПоЛокациям.Следующий() Цикл
		НаборЗаписей.Отбор.Период.Установить(ПериодНач);
		НаборЗаписей.Отбор.Location.Установить(ВыборкаПоЛокациям.Location);
		НаборЗаписей.Записать();
	КонецЦикла;
	
	Пока ВыборкаДанные.Следующий() Цикл
		Если ВыборкаДанные.TransType = "P" или ВыборкаДанные.TransType = "I" или ВыборкаДанные.TransType = "C" или ВыборкаДанные.TransType = "M" Тогда
			НаборЗаписей = ARBalance.СоздатьНаборЗаписей();
			НаборЗаписей.Отбор.Период.Установить(ПериодНач);
			НаборЗаписей.Отбор.Location.Установить(ВыборкаДанные.Location);
			НаборЗаписей.Отбор.Client.Установить(ВыборкаДанные.Client);
			НаборЗаписей.Отбор.Company.Установить(ВыборкаДанные.Company);
			НаборЗаписей.Отбор.Source.Установить(Перечисления.ТипыСоответствий.Lawson);
			НаборЗаписей.Отбор.SubSubSegment.Установить(ВыборкаДанные.SubSubSegment);
			Если ВыборкаДанные.TransType = "I" или ВыборкаДанные.TransType = "C" или ВыборкаДанные.TransType = "M" Тогда
				Инвойс = КэшИнвойсов.Найти(ВыборкаДанные.Invoice, "ArInvoice");
				Если Инвойс = Неопределено Тогда
					ПолеИнвойс =  ВыборкаДанные.Invoice;
				Иначе
					ПолеИнвойс = Инвойс.Invoice;
				КонецЕсли;
			ИначеЕсли ВыборкаДанные.TransType = "P" Тогда
				СтруктураПоискаBatch.Source = Перечисления.ТипыСоответствий.Lawson;
				СтруктураПоискаBatch.Company = ВыборкаДанные.Company;
				СтруктураПоискаBatch.Client = ВыборкаДанные.Client;
				СтруктураПоискаBatch.Location = ВыборкаДанные.Location;
				СтруктураПоискаBatch.SubSubSegment = ВыборкаДанные.SubSubSegment;
				СтруктураПоискаBatch.AU = ВыборкаДанные.AU;
				СтруктураПоискаBatch.Account = ВыборкаДанные.Account;
				СтруктураПоискаBatch.Currency = ВыборкаДанные.Currency;
				
				СтрокиCashBatch = КэшCashBatch.НайтиСтроки(СтруктураПоискаBatch);
				Если СтрокиCashBatch.Количество() = 0 Тогда
					ПолеИнвойс =  ВыборкаДанные.Invoice;
				Иначе
					ПолеИнвойс = СтрокиCashBatch[0].CashBatch;
				КонецЕсли;
			Иначе
				ПолеИнвойс = ВыборкаДанные.Invoice;
			КонецЕсли;
			НаборЗаписей.Отбор.Invoice.Установить(ПолеИнвойс);
			НаборЗаписей.Отбор.Account.Установить(ВыборкаДанные.Account);
			НаборЗаписей.Отбор.Currency.Установить(ВыборкаДанные.Currency);
			НаборЗаписей.Отбор.AU.Установить(ВыборкаДанные.AU);
			НаборЗаписей.Прочитать();
			
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.Период = ПериодНач;
			НоваяЗапись.Location = ВыборкаДанные.Location;
			НоваяЗапись.Client = ВыборкаДанные.Client;
			НоваяЗапись.Company = ВыборкаДанные.Company;
			НоваяЗапись.Source = Перечисления.ТипыСоответствий.Lawson;
			НоваяЗапись.SubSubSegment = ВыборкаДанные.SubSubSegment;
			НоваяЗапись.Invoice = ПолеИнвойс;
			НоваяЗапись.Account = ВыборкаДанные.Account;
			НоваяЗапись.Currency = ВыборкаДанные.Currency;
			НоваяЗапись.AU = ВыборкаДанные.AU;
			НоваяЗапись.Amount = ВыборкаДанные.RemAmount;
			
			НаборЗаписей.Записать();
		КонецЕсли;
	КонецЦикла;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Период = РезультатВыбора.НачалоПериода;
КонецПроцедуры


&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Период = Дата(1,1,1) Тогда	
		ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(ТекущаяДата()), КонецМесяца(ТекущаяДата()));
	Иначе
		ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(Период), КонецМесяца(Период));
	КонецЕсли;	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, ЭтаФорма.ПредставлениеПериода, , , , ОписаниеОповещения);
	
КонецПроцедуры

