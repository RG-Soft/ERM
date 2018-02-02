﻿
&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.ПроверятьСуществованиеФайла = Истина;
	ДиалогОткрытияФайла.Фильтр = "Excel (*.xlsx)";
	ДиалогОткрытияФайла.Заголовок = "Select a file to loading";
	
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ИмяФайлаНачалоВыбораЗавершение", ЭтотОбъект));
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы <> Неопределено Тогда
		Объект.ИмяФайла = ВыбранныеФайлы[0];
		АдресВХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(Объект.ИмяФайла), УникальныйИдентификатор);
		АдресФайлаВХранилище = АдресВХранилище;
		ЗаполнитьСписокЛистовЭкселя(Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСписокЛистовЭкселя(ЗаполнитьЛист = Ложь)
	
	СписокЛистов = Новый Массив;
	
	ФайлЭксель = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
	
	Если ФайлЭксель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
	ФайлЭксель.Записать(ПутьКФайлу);
	
	Connection = Новый COMОбъект("ADODB.Connection");
	СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 12.0 Xml;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
	
	Попытка
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 8.0;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
			Connection.Open(СтрокаПодключения);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецПопытки;
	
	rs = Новый COMObject("ADODB.RecordSet");
	rs.ActiveConnection = Connection;
	rs = Connection.OpenSchema(20);
	
	Пока rs.EOF() = 0 Цикл
		Если Найти(rs.Fields("TABLE_NAME").Value, "_FilterDatabase") = 0 Тогда
			СписокЛистов.Добавить(rs.Fields("TABLE_NAME").Value);
		КонецЕсли;
		rs.MoveNext();
	КонецЦикла;
	
	rs.Close();
	Connection.Close();
	
	Элементы.ЛистФайла.СписокВыбора.ЗагрузитьЗначения(СписокЛистов);
	
	Если ЗаполнитьЛист Тогда
		
		//Если СписокЛистов.Количество() = 1 Тогда
		//	ЛистФайла = СписокЛистов[0];
		//ИначеЕсли СписокЛистов.Количество() > 1 Тогда
		//	Для каждого Лист Из СписокЛистов Цикл
		//		Если СтрНайти(Лист,"XR294") > 0 Тогда
		//			ЛистФайла = Лист;
		//		КонецЕсли;
		//	КонецЦикла;
		//Конецесли;
		ЛистФайла = СписокЛистов[0];
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьФайлНаСервере(Результат)
	
	Если Объект.ИмяФайла = "" Тогда
		Сообщить("The file is not selected");
	ИначеЕсли Период = Дата(1,1,1) Тогда
		Сообщить("Specify the period downloaded Revenue");
	Иначе
		
		ТаблицаКоллизий.Очистить();
		
		ДанныеДляЗаполнения = Новый Структура();
		ТекстОшибки = "";
		
		ДД = ПолучитьИзВременногоХранилища(АдресВХранилище);
		ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
		ДД.Записать(ПутьКФайлу);
		
		Connection = Новый COMОбъект("ADODB.Connection");
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 12.0 Xml;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
		
		Попытка
			Connection.Open(СтрокаПодключения);
		Исключение
			Попытка
				СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 8.0;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
				Connection.Open(СтрокаПодключения);
			Исключение
				ТекстОшибки = ОписаниеОшибки();
				ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ТекстОшибки);
				ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
				Возврат;
			КонецПопытки;
		КонецПопытки;
		
		rs = Новый COMObject("ADODB.RecordSet");
		rs.ActiveConnection = Connection;
		sqlString = "select * from [" + ЛистФайла + "]";
		rs.Open(sqlString);
		
		СоответствиеКолонок = Новый Соответствие;
		Для каждого ЭлементСтруктурыКолонок Из СтруктураКолонок Цикл
			СоответствиеКолонок.Вставить(ЭлементСтруктурыКолонок.ИмяПоля, ЭлементСтруктурыКолонок.ИмяКолонки);
		КонецЦикла;
		
		ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
		
		rs.MoveFirst();
		
		ВеличинаСдвига = ПерваяСтрокаДанных - 1 - ?(ИменаКолонокВПервойСтроке, 1, 1);
		Если ВеличинаСдвига <> 0 Тогда
			rs.Move(ВеличинаСдвига);
		КонецЕсли;
		
		ТекНомерСтроки = ПерваяСтрокаДанных;
		
		ТипСтрока = Тип("Строка");
		ТипЧисло = Тип("Число");
		
		Пока Не rs.EOF Цикл
			
			СтрокаДанных = ТаблицаДанных.Добавить();
			СтрокаДанных.СтрокаФайла = ТекНомерСтроки;
			
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
				Иначе
					СтрокаДанных[ЭлементСоответствия.Ключ] = ТекЗначение;
				КонецЕсли;
				
			КонецЦикла;
			
			rs.MoveNext();
			ТекНомерСтроки = ТекНомерСтроки + 1;
			
		КонецЦикла;
		
		rs.Close();
		Connection.Close();
		УдалитьФайлы(ПутьКФайлу);
		
		Для каждого СтрокаТаблицы из ТаблицаДанных Цикл
			Если СтрокаТаблицы.AU_Type = "Lawson" Тогда
				Пока СтрДлина(СтрокаТаблицы.AU) < 7 Цикл
					СтрокаТаблицы.AU = "0" + СтрокаТаблицы.AU;
				КонецЦикла;;
			Иначе
				Пока СтрДлина(СтрокаТаблицы.AU) < 10 Цикл
					СтрокаТаблицы.AU = "0" + СтрокаТаблицы.AU;
				КонецЦикла;;
			КонецЕсли;
		КонецЦикла;
		
		Результат = ПроверитьКорректностьДанных(ТаблицаДанных);
		
		Если Результат Тогда
			СоздатьЗаписиРегистра(ТаблицаДанных);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	
	Результат = Ложь;
	
	ПрочитатьФайлНаСервере(Результат);
	
	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Revenue loaded'");
	Иначе
		ТекстСообщения = НСтр("ru = 'Revenue are not loaded, add the missing data and download it again'");
	КонецЕсли;
	ПоказатьПредупреждение(, ТекстСообщения);
	
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
	СтрокаТЗ.Обязательная = Истина;

	//// TransType
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "TransType";
	//СтрокаТЗ.ИмяКолонки = "TransType";
	//СтрокаТЗ.ТипКолонки = ТипСтрока;
	//СтрокаТЗ.Обязательная = Истина;
	
	// Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "Account";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	СтрокаТЗ.Обязательная = Истина;
	
	// CustomerNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerNumber";
	СтрокаТЗ.ИмяКолонки = "CustomerNumber";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	СтрокаТЗ.Обязательная = Истина;
	
	//// TransDate
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "TransDate";
	//СтрокаТЗ.ИмяКолонки = "TransDate";
	//СтрокаТЗ.ТипКолонки = ТипДата;
	//СтрокаТЗ.Обязательная = Истина;

	//// Invoice
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "Invoice";
	//СтрокаТЗ.ИмяКолонки = "Invoice";
	//ТекМассивТипов = Новый Массив;
	//ТекМассивТипов.Добавить(Тип("Строка"));
	////ТекМассивТипов.Добавить(Тип("Число"));
	//СтрокаТЗ.ТипКолонки = Новый ОписаниеТипов(ТекМассивТипов, , Новый КвалификаторыСтроки(100));
	//СтрокаТЗ.Обязательная = Истина;
	
	// Currency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Currency";
	СтрокаТЗ.ИмяКолонки = "Currency";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	СтрокаТЗ.Обязательная = Истина;
	
	// AmountUSD
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AmountUSD";
	СтрокаТЗ.ИмяКолонки = "AmountUSD";
	СтрокаТЗ.ТипКолонки = ТипЧисло;
	СтрокаТЗ.Обязательная = Истина;
	
	// AmountRUB
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Amount";
	СтрокаТЗ.ИмяКолонки = "Amount";
	СтрокаТЗ.ТипКолонки = ТипЧисло;
	СтрокаТЗ.Обязательная = Истина;
	
	// AU_Type
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AU_Type";
	СтрокаТЗ.ИмяКолонки = "AU_Type";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	СтрокаТЗ.Обязательная = Истина;
	
	// AU
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AU";
	СтрокаТЗ.ИмяКолонки = "AU";
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	СтрокаТЗ.Обязательная = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
КонецПроцедуры

&НаСервере
Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля, ТекСтрокаСтруктурыКолонок.ТипКолонки);
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Добавить("СтрокаФайла", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Неотрицательный)));
	
	Возврат ТаблицаДанных;
	
КонецФункции

&НаСервере
Функция ПроверитьКорректностьДанных(ТаблицаДанных)
	
	Результат = Ложь;
	ПериодКонец = КонецМесяца(Период);
	
	//определение источников для загрузки
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаИсточниковЗагрузкиВыручки.SourceCustomer,
		|	НастройкаИсточниковЗагрузкиВыручки.SourceAccount
		|ИЗ
		|	РегистрСведений.НастройкаИсточниковЗагрузкиВыручки КАК НастройкаИсточниковЗагрузкиВыручки
		|ГДЕ
		|	НастройкаИсточниковЗагрузкиВыручки.Source = &Source";
	
	Запрос.УстановитьПараметр("Source", Source);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
		Сообщить("Не задана настройка источников для загрузки выручки для данного источника!");
	Иначе
		ВыборкаДетальныеЗаписи.Следующий();
		SourceCustomer = ВыборкаДетальныеЗаписи.SourceCustomer;
		SourceAccount = ВыборкаДетальныеЗаписи.SourceAccount;
	
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТаблицаИсходныхДанных.Currency КАК Currency,
		|	ТаблицаИсходныхДанных.Account,
		|	ТаблицаИсходныхДанных.Company,
		|	ТаблицаИсходныхДанных.AU_Type,
		|	ТаблицаИсходныхДанных.AU,
		|	ТаблицаИсходныхДанных.CustomerNumber
		|ПОМЕСТИТЬ врТЗТаблицаДанных
		|ИЗ
		|	&ВнешняяТаблицаДанных КАК ТаблицаИсходныхДанных";
		;
		Запрос.УстановитьПараметр("ВнешняяТаблицаДанных", ТаблицаДанных);
		Запрос.Выполнить();
		
		ДанныеДляЗаполнения = Новый Структура();
		
		Запрос.Текст = 
			"ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЛОЖЬ КАК КоллизияОтработана,
			|	""Specify the 1C object"" КАК Описание,
			|	&ТипВнешнейСистемы КАК ТипСоответствия,
			|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency) КАК ТипОбъектаВнешнейСистемы,
			|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) КАК ОбъектПриемника,
			|	врТЗТаблицаДанных.Currency КАК Идентификатор
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
			|				&Период,
			|				ТипСоответствия = &ТипВнешнейСистемы
			|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)) КАК НастройкаСинхронизацииCurrency
			|		ПО врТЗТаблицаДанных.Currency = НастройкаСинхронизацииCurrency.Идентификатор
			|ГДЕ
			|	НастройкаСинхронизацииCurrency.ОбъектПриемника ЕСТЬ NULL
			|	И НЕ врТЗТаблицаДанных.Currency = """"
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
			|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК ПланСчетов
			|		ПО врТЗТаблицаДанных.Account = ПланСчетов.КодЧислом
			|			И (НЕ ПланСчетов.ПометкаУдаления)
			|ГДЕ
			|	врТЗТаблицаДанных.Account <> 0
			|	И ПланСчетов.Ссылка ЕСТЬ NULL
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
			|	""Failed to find Accounting Unit"",
			|	&ТипВнешнейСистемы,
			|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.AccountingUnit),
			|	ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка),
			|	врТЗТаблицаДанных.AU
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|			И (КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
			|ГДЕ
			|	КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Lawson""
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЛОЖЬ,
			|	""Failed to find Accounting Unit"",
			|	&ТипВнешнейСистемы,
			|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.AccountingUnit),
			|	ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка),
			|	врТЗТаблицаДанных.AU
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|			И (КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI))
			|ГДЕ
			|	КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Oracle MI""
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЛОЖЬ,
			|	""Failed to find Accounting Unit"",
			|	&ТипВнешнейСистемы,
			|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.AccountingUnit),
			|	ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка),
			|	врТЗТаблицаДанных.AU
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|			И (КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith))
			|ГДЕ
			|	КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Oracle Smith""
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ЛОЖЬ,
			|	""Failed to find Client"",
			|	&SourceCustomer,
			|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client),
			|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),
			|	врТЗТаблицаДанных.CustomerNumber
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
			|				,
			|				ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
			|					И ТипСоответствия = &SourceCustomer) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
			|		ПО врТЗТаблицаДанных.CustomerNumber = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор
			|ГДЕ
			|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор ЕСТЬ NULL
			|	И врТЗТаблицаДанных.CustomerNumber <> """"
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КостЦентры.Сегмент КАК Ссылка,
			|	ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка) КАК БазовыйЭлемент,
			|	КостЦентры.Сегмент.Код КАК Код
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|ГДЕ
			|	НЕ КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Lawson""
			|	И КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
			|	И КостЦентры.Сегмент.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КостЦентры.Сегмент,
			|	ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка),
			|	КостЦентры.Сегмент.Код
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|ГДЕ
			|	НЕ КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Oracle MI""
			|	И КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
			|	И КостЦентры.Сегмент.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КостЦентры.Сегмент,
			|	ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка),
			|	КостЦентры.Сегмент.Код
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|ГДЕ
			|	НЕ КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Oracle Smith""
			|	И КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
			|	И КостЦентры.Сегмент.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КостЦентры.ПодразделениеОрганизации КАК Ссылка,
			|	ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка) КАК БазовыйЭлемент,
			|	КостЦентры.ПодразделениеОрганизации.Код КАК Код
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|ГДЕ
			|	НЕ КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Lawson""
			|	И КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
			|	И КостЦентры.Сегмент.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Locations.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КостЦентры.ПодразделениеОрганизации,
			|	ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка),
			|	КостЦентры.ПодразделениеОрганизации.Код
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|ГДЕ
			|	НЕ КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Oracle MI""
			|	И КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
			|	И КостЦентры.Сегмент.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Locations.ПустаяСсылка)
			|
			|ОБЪЕДИНИТЬ
			|
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	КостЦентры.ПодразделениеОрганизации,
			|	ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка),
			|	КостЦентры.ПодразделениеОрганизации.Код
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
			|		ПО (НЕ КостЦентры.ПометкаУдаления)
			|			И врТЗТаблицаДанных.AU = КостЦентры.Код
			|ГДЕ
			|	НЕ КостЦентры.Ссылка ЕСТЬ NULL
			|	И врТЗТаблицаДанных.AU_Type = ""Oracle Smith""
			|	И КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
			|	И КостЦентры.Сегмент.БазовыйЭлемент = ЗНАЧЕНИЕ(Справочник.HFM_Locations.ПустаяСсылка)
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ РАЗЛИЧНЫЕ
			|	ПланСчетов.Ссылка,
			|	ПланСчетов.Код
			|ИЗ
			|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК ПланСчетов
			|		ПО врТЗТаблицаДанных.Account = ПланСчетов.КодЧислом
			|			И (НЕ ПланСчетов.ПометкаУдаления)
			|ГДЕ
			|	ПланСчетов.БазовыйЭлемент = ЗНАЧЕНИЕ(ПланСчетов.HFM_GL_Accounts.ПустаяСсылка)
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
		
		Запрос.УстановитьПараметр("Период", ПериодКонец);
		Запрос.УстановитьПараметр("ТипВнешнейСистемы", Source);
		Запрос.УстановитьПараметр("SourceCustomer", SourceCustomer);
		
		Если SourceAccount = Перечисления.ТипыСоответствий.OracleMI ИЛИ SourceAccount = Перечисления.ТипыСоответствий.OracleSmith Тогда
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПланСчетов.Lawson", "ПланСчетов.Oracle");
			Запрос.Текст = СтрЗаменить(Запрос.Текст, "КодЧислом", "Код");
			
		КонецЕсли;
		
		МассивРезультатов = Запрос.ВыполнитьПакет();
		
		ТаблицаКоллизий1 = МассивРезультатов[0].Выгрузить();
		
		ВыборкаСегментов = МассивРезультатов[1].Выбрать();
		
		Пока ВыборкаСегментов.Следующий() Цикл
			
			Если ВыборкаСегментов.БазовыйЭлемент.Пустая() Тогда
				
				СтрокаКоллизии = ТаблицаКоллизий1.Добавить();
				СтрокаКоллизии.КоллизияОтработана = Ложь;
				СтрокаКоллизии.Описание = "Not specified base element";
				СтрокаКоллизии.ТипСоответствия = Source;
				СтрокаКоллизии.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Segment;
				СтрокаКоллизии.ОбъектПриемника = ВыборкаСегментов.Ссылка;
				СтрокаКоллизии.Идентификатор = ВыборкаСегментов.Код;
				
			КонецЕсли;
			
		КонецЦикла;
		
		// локации
		ВыборкаЛокаций = МассивРезультатов[2].Выбрать();
		
		Пока ВыборкаЛокаций.Следующий() Цикл
			
			Если ВыборкаЛокаций.БазовыйЭлемент.Пустая() Тогда
				
				СтрокаКоллизии = ТаблицаКоллизий1.Добавить();
				СтрокаКоллизии.КоллизияОтработана = Ложь;
				СтрокаКоллизии.Описание = "Not specified base element";
				СтрокаКоллизии.ТипСоответствия = Source;
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
			СтрокаКоллизии.ТипСоответствия = SourceAccount;
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
			СтрокаКоллизии.ТипСоответствия = Source;
			СтрокаКоллизии.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Company;
			СтрокаКоллизии.ОбъектПриемника = ВыборкаКомпаний.Ссылка;
			СтрокаКоллизии.Идентификатор = ВыборкаКомпаний.Код;
			
		КонецЦикла;
		
		ДанныеДляЗаполнения.Вставить("ТаблицаКоллизий1", ТаблицаКоллизий1);
		ТаблицаКоллизий.Загрузить(ТаблицаКоллизий1);
		
		Если ТаблицаКоллизий.Количество() = 0 Тогда
			Результат = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;

КонецФункции

&НаСервере
Процедура СоздатьЗаписиРегистра(ТаблицаДанных)
	
	ПериодКонец = КонецМесяца(Период);
	
	ПометитьНаУдалениеКорректировкиТекущегоМесяца();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИсходныхДанных.Currency КАК Currency,
	|	ТаблицаИсходныхДанных.Account,
	|	ТаблицаИсходныхДанных.Company,
	|	ТаблицаИсходныхДанных.AU_Type,
	|	ТаблицаИсходныхДанных.AU,
	|	ТаблицаИсходныхДанных.CustomerNumber,
	|	ТаблицаИсходныхДанных.AmountUSD,
	|	ТаблицаИсходныхДанных.Amount
	|ПОМЕСТИТЬ врТЗТаблицаДанных
	|ИЗ
	|	&ВнешняяТаблицаДанных КАК ТаблицаИсходныхДанных";
	
	Запрос.УстановитьПараметр("ВнешняяТаблицаДанных", ТаблицаДанных);
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
	|ПОМЕСТИТЬ ВТ_СоответствиеКлиентовCustomerNumber
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
	|			&Период,
	|			ТипСоответствия = &SourceCustomer
	|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
	|				И Идентификатор В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ВТ_ДанныеФайла.CustomerNumber
	|					ИЗ
	|						врТЗТаблицаДанных КАК ВТ_ДанныеФайла)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
	|ПОМЕСТИТЬ ВТ_СоответствиеCurrency
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
	|			&Период,
	|			ТипСоответствия = &Source
	|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)
	|				И Идентификатор В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ВТ_ДанныеФайла.Currency
	|					ИЗ
	|						врТЗТаблицаДанных КАК ВТ_ДанныеФайла)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Идентификатор
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&Source КАК Source,
	|	врТЗТаблицаДанных.Amount,
	|	врТЗТаблицаДанных.AmountUSD КАК BaseAmount,
	|	врТЗТаблицаДанных.CustomerNumber КАК CustomerNumber,
	|	ВТ_СоответствиеКлиентовCustomerNumber.ОбъектПриемника КАК Client,
	|	ВТ_СоответствиеCurrency.ОбъектПриемника КАК Currency,
	|	Организации.Ссылка КАК Company,
	|	ПланСчетов.Ссылка КАК Account,
	|	КостЦентры.Ссылка КАК AU,
	|	Организации.DefaultLegalEntity КАК LegalEntity
	|ИЗ
	|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеКлиентовCustomerNumber КАК ВТ_СоответствиеКлиентовCustomerNumber
	|		ПО врТЗТаблицаДанных.CustomerNumber = ВТ_СоответствиеКлиентовCustomerNumber.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеCurrency КАК ВТ_СоответствиеCurrency
	|		ПО врТЗТаблицаДанных.Currency = ВТ_СоответствиеCurrency.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО врТЗТаблицаДанных.Company = Организации.Код
	|			И (Организации.Source = &Source)
	|			И (НЕ Организации.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК ПланСчетов
	|		ПО врТЗТаблицаДанных.Account = ПланСчетов.КодЧислом
	|			И (НЕ ПланСчетов.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
	|		ПО (НЕ КостЦентры.ПометкаУдаления)
	|			И врТЗТаблицаДанных.AU = КостЦентры.Код
	|			И (КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith))
	|ГДЕ
	|	врТЗТаблицаДанных.AU_Type = ""Oracle Smith""
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	&Source,
	|	врТЗТаблицаДанных.Amount,
	|	врТЗТаблицаДанных.AmountUSD,
	|	врТЗТаблицаДанных.CustomerNumber,
	|	ВТ_СоответствиеКлиентовCustomerNumber.ОбъектПриемника,
	|	ВТ_СоответствиеCurrency.ОбъектПриемника,
	|	Организации.Ссылка,
	|	ПланСчетов.Ссылка,
	|	КостЦентры.Ссылка,
	|	Организации.DefaultLegalEntity
	|ИЗ
	|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеКлиентовCustomerNumber КАК ВТ_СоответствиеКлиентовCustomerNumber
	|		ПО врТЗТаблицаДанных.CustomerNumber = ВТ_СоответствиеКлиентовCustomerNumber.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеCurrency КАК ВТ_СоответствиеCurrency
	|		ПО врТЗТаблицаДанных.Currency = ВТ_СоответствиеCurrency.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО врТЗТаблицаДанных.Company = Организации.Код
	|			И (Организации.Source = &Source)
	|			И (НЕ Организации.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК ПланСчетов
	|		ПО врТЗТаблицаДанных.Account = ПланСчетов.КодЧислом
	|			И (НЕ ПланСчетов.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
	|		ПО (НЕ КостЦентры.ПометкаУдаления)
	|			И врТЗТаблицаДанных.AU = КостЦентры.Код
	|			И (КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI))
	|ГДЕ
	|	врТЗТаблицаДанных.AU_Type = ""Oracle MI""
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	&Source,
	|	врТЗТаблицаДанных.Amount,
	|	врТЗТаблицаДанных.AmountUSD,
	|	врТЗТаблицаДанных.CustomerNumber,
	|	ВТ_СоответствиеКлиентовCustomerNumber.ОбъектПриемника,
	|	ВТ_СоответствиеCurrency.ОбъектПриемника,
	|	Организации.Ссылка,
	|	ПланСчетов.Ссылка,
	|	КостЦентры.Ссылка,
	|	Организации.DefaultLegalEntity
	|ИЗ
	|	врТЗТаблицаДанных КАК врТЗТаблицаДанных
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеКлиентовCustomerNumber КАК ВТ_СоответствиеКлиентовCustomerNumber
	|		ПО врТЗТаблицаДанных.CustomerNumber = ВТ_СоответствиеКлиентовCustomerNumber.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеCurrency КАК ВТ_СоответствиеCurrency
	|		ПО врТЗТаблицаДанных.Currency = ВТ_СоответствиеCurrency.Идентификатор
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Организации КАК Организации
	|		ПО врТЗТаблицаДанных.Company = Организации.Код
	|			И (Организации.Source = &Source)
	|			И (НЕ Организации.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.Lawson КАК ПланСчетов
	|		ПО врТЗТаблицаДанных.Account = ПланСчетов.КодЧислом
	|			И (НЕ ПланСчетов.ПометкаУдаления)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КостЦентры КАК КостЦентры
	|		ПО (НЕ КостЦентры.ПометкаУдаления)
	|			И врТЗТаблицаДанных.AU = КостЦентры.Код
	|			И (КостЦентры.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
	|ГДЕ
	|	врТЗТаблицаДанных.AU_Type = ""Lawson"""
	;
	
	Запрос.УстановитьПараметр("Период", ПериодКонец);
	Запрос.УстановитьПараметр("Source", Source);
	Запрос.УстановитьПараметр("SourceCustomer", SourceCustomer);
	
	Если SourceAccount = Перечисления.ТипыСоответствий.OracleMI ИЛИ SourceAccount = Перечисления.ТипыСоответствий.OracleSmith Тогда
		
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "ПланСчетов.Lawson", "ПланСчетов.Oracle");
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "КодЧислом", "Код");
		
	КонецЕсли;
	
	НачатьТранзакцию();
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ЗафиксироватьТранзакцию();
	
	ВыборкаДанные = РезультатЗапроса[2].Выбрать();
	
	НачатьТранзакцию();
	
	Док = Документы.КорректировкаРегистров.СоздатьДокумент();
	Док.Дата = ПериодКонец;
	Если Source = Перечисления.ТипыСоответствий.Radius Тогда
		Док.Комментарий = "Выручка по Radius";
	ИначеЕсли Source = Перечисления.ТипыСоответствий.Geofit Тогда
		Док.Комментарий = "Выручка по Geofit";
	ИначеЕсли Source = Перечисления.ТипыСоответствий.MFG Тогда
		Док.Комментарий = "Выручка по MFG";
	КонецЕсли;
	Док.Ответственный = Пользователи.ТекущийПользователь();
	
	// { RGS AGorlenko 19.07.2017 16:40:30 - добавление фильтра незагружаемых данных
	МенеджерФильтраНезагружаемыхДанных = РегистрыСведений.ФильтрНезагружаемыхДанных;
	ФильтрНезагружаемыхДанных = МенеджерФильтраНезагружаемыхДанных.ПолучитьТаблицуФильтра(Source);
	КоличествоПропущенныхПоФильтруТранзакций = 0;
	// } RGS AGorlenko 19.07.2017 16:40:47 - добавление фильтра незагружаемых данных
	
	Пока ВыборкаДанные.Следующий() Цикл
		
		// { RGS AGorlenko 19.07.2017 16:40:30 - добавление фильтра незагружаемых данных
		Если МенеджерФильтраНезагружаемыхДанных.ЭтоНезагружаемыеДанные(ФильтрНезагружаемыхДанных, ВыборкаДанные, ВыборкаДанные.Account) Тогда
			КоличествоПропущенныхПоФильтруТранзакций = КоличествоПропущенныхПоФильтруТранзакций + 1;
			Продолжить;
		КонецЕсли;
		// } RGS AGorlenko 19.07.2017 16:40:47 - добавление фильтра незагружаемых данных
				
		Движение = Док.Движения.Revenue.Добавить();
		ЗаполнитьЗначенияСвойств(Движение, ВыборкаДанные);
		Движение.Период = Док.Дата;
		
	КонецЦикла;
	
	Если Док.Движения.Revenue.Количество() > 0 Тогда
		
		СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
		СтрокаТаблицыРегистров.Имя = "Revenue";
		
		Док.Движения.Revenue.Записывать = Истина;
		
	КонецЕсли;
		
	Док.Записать();
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Процедура ПометитьНаУдалениеКорректировкиТекущегоМесяца()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорректировкаРегистров.Ссылка
		|ИЗ
		|	Документ.КорректировкаРегистров КАК КорректировкаРегистров
		|ГДЕ
		|	НЕ КорректировкаРегистров.ПометкаУдаления
		|	И КорректировкаРегистров.Комментарий = ""Выручка по Radius""
		|	И КорректировкаРегистров.Дата = &Период";
	
	Запрос.Параметры.Вставить("Период",КонецМесяца(Период));
	
	Если Source = Перечисления.ТипыСоответствий.MFG Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Radius", "MFG");
	ИначеЕсли Source = Перечисления.ТипыСоответствий.Geofit Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Radius", "Geofit");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДокОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		ДокОбъект.УстановитьПометкуУдаления(Истина);
		ДокОбъект.Записать();
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

