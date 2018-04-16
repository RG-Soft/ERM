#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьКурсыВалют(СтруктураПараметров, АдресХранилища) Экспорт
	
	СтруктураКолонок = Новый ТаблицаЗначений;
	СтруктураКолонок.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("ИмяКолонки", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("Обязательная", Новый ОписаниеТипов("Булево"));
	СтруктураКолонок.Колонки.Добавить("ТипКолонки");
	
	ЗаполнитьСтруктуруКолонокПоУмолчанию(СтруктураКолонок);
	
	ДанныеДляЗаполнения = Новый Структура();
	//СтруктураКолонок = СтруктураПараметров.СтруктураКолонок;
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	ТекстОшибки = "";
	
	//ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsb");
	//ФайлЭксель = ПолучитьИзВременногоХранилища(СтруктураПараметров.АдресФайлаВХранилище);
	//ФайлЭксель.Записать(ПутьКФайлу);
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsb");
	ФайлЭксель = СтруктураПараметров.ИсточникДанных.Получить();
	ФайлЭксель.Записать(ПутьКФайлу);
	
	УдалитьШапкуФайла(ПутьКФайлу, СтруктураПараметров);
	
	Connection = Новый COMОбъект("ADODB.Connection");
	СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 12.0 Xml;IMEX=1;MAXSCANROWS=0;HDR=" + ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, "Yes", "No") + """";
	
	Попытка
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 8.0;IMEX=1;MAXSCANROWS=0;HDR=" + ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, "Yes", "No") + """";
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
	sqlString = "select * from [" + СтруктураПараметров.ЛистФайла + "]";
	rs.Open(sqlString);
	
	СоответствиеКолонок = Новый Соответствие;
	Для каждого ЭлементСтруктурыКолонок Из СтруктураКолонок Цикл
		СоответствиеКолонок.Вставить(ЭлементСтруктурыКолонок.ИмяПоля, ЭлементСтруктурыКолонок.ИмяКолонки);
	КонецЦикла;
	
	rs.MoveFirst();
	
	ВеличинаСдвига = СтруктураПараметров.ПерваяСтрокаДанных - 1 - ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, 1, 1);
	Если ВеличинаСдвига <> 0 Тогда
		rs.Move(ВеличинаСдвига);
	КонецЕсли;
	
	ТекНомерСтроки = СтруктураПараметров.ПерваяСтрокаДанных;
	
	ТипСтрока = Тип("Строка");
	ТипЧисло = Тип("Число");
	
	Пока Не rs.EOF
		Цикл
		
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
	
	ТаблицаДанных.Колонки.Добавить("DateERM", Новый ОписаниеТипов("Дата"));
	
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		СтрокаТаблицы.DateERM = КонецМесяца(СтрокаТаблицы.DATE)+1;
		
	КонецЦикла;
		
	ЗагрузитьКурсыВРегистр(ТаблицаДанных);
	
КонецПроцедуры

Процедура УдалитьШапкуФайла(ПутьКФайлу, СтруктураПараметров)
	
	ЭкземплярExcel = Новый COMОбъект("Excel.Application");
	Книга = ЭкземплярExcel.Application.Workbooks.Open(ПутьКФайлу);
	
	ИмяЛиста = СтруктураПараметров.ЛистФайла;
	Если Прав(ИмяЛиста, 1) = "$" Тогда
		ИмяЛиста = Лев(ИмяЛиста, СтрДлина(ИмяЛиста) - 1);
	КонецЕсли;
	
	Лист = ЭкземплярExcel.Worksheets(ИмяЛиста);
	
	// в качестве ориентиров будем использовать колонки CURRENCY
	НомерСтрокиЗаголовка = 1;
	
	Для ТекНомерСтроки = 1 По 100 Цикл
		
		НайденаCURRENCY = Ложь;
		
		Для ТекНомерСтолбца = 1 По 100 Цикл
			
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "CURRENCY" Тогда
				НайденаCURRENCY = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НайденаCURRENCY Тогда
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

Процедура ЗагрузитьКурсыВРегистр(ТаблицаДанных)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИсходныхДанных.CURRENCY,
	|	ТаблицаИсходныхДанных.DATE,
	|	ТаблицаИсходныхДанных.RATE,
	|	ТаблицаИсходныхДанных.DateERM
	|ПОМЕСТИТЬ ВТ_ДанныеФайла
	|ИЗ
	|	&ВнешняяТаблицаДанных КАК ТаблицаИсходныхДанных"
	;
	Запрос.УстановитьПараметр("ВнешняяТаблицаДанных", ТаблицаДанных);
	Запрос.Выполнить();
	
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_ДанныеФайла.CURRENCY,
		|	ВТ_ДанныеФайла.DateERM,
		|	ВТ_ДанныеФайла.RATE,
		|	Валюты.Ссылка КАК Валюта
		|ИЗ
		|	ВТ_ДанныеФайла КАК ВТ_ДанныеФайла
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Валюты КАК Валюты
		|		ПО ВТ_ДанныеФайла.CURRENCY = Валюты.Наименование
		|ГДЕ
		|	НЕ Валюты.Ссылка ЕСТЬ NULL";
	
	НачатьТранзакцию();
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	ЗафиксироватьТранзакцию();
	
	НЗ_КурсВалют = РегистрыСведений.ВнутренниеКурсыВалют.СоздатьНаборЗаписей();
	
	Пока Выборка.Следующий() Цикл
		
		НЗ_КурсВалют.Очистить();
		НЗ_КурсВалют.Отбор.Период.Установить(Выборка.DateERM);
		НЗ_КурсВалют.Отбор.Валюта.Установить(Выборка.Валюта);
		НоваяЗаписьНабора = НЗ_КурсВалют.Добавить();
		НоваяЗаписьНабора.Валюта = Выборка.Валюта;
		НоваяЗаписьНабора.Период = Выборка.DateERM;
		НоваяЗаписьНабора.Курс = Выборка.RATE;
		НоваяЗаписьНабора.Кратность = 1;
		НЗ_КурсВалют.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля,ТекСтрокаСтруктурыКолонок.ТипКолонки);
		//ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля);
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Добавить("СтрокаФайла", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Неотрицательный)));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура ЗаполнитьСтруктуруКолонокПоУмолчанию(СтруктураКолонок)
	
	СтруктураКолонок.Очистить();
	
	ТипСтрока = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(100));
	ТипЧисло = Новый ОписаниеТипов("Число",,, Новый КвалификаторыЧисла(15, 2));
	ТипДата = Новый ОписаниеТипов("Дата");
	
	// CURRENCY
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CURRENCY";
	СтрокаТЗ.ИмяКолонки = "CURRENCY";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// DATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DATE";
	СтрокаТЗ.ИмяКолонки = "DATE";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипДата;
	
	// RATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "RATE";
	СтрокаТЗ.ИмяКолонки = "RATE";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипЧисло;
	
КонецПроцедуры

#КонецЕсли