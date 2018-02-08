﻿
Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	СтруктураКолонок = ПолучитьСтруктуруКолонокТаблицыДанных();
	СтруктураПараметров.Вставить("СтруктураКолонок", СтруктураКолонок);
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	ТекстОшибки = "";
	
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsb");
	ФайлЭксель = СтруктураПараметров.ИсточникДанных.Получить();
	ФайлЭксель.Записать(ПутьКФайлу);
	
	//УдалитьШапкуФайла(ПутьКФайлу, СтруктураПараметров);
	
		Connection = Новый COMОбъект("ADODB.Connection");
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 12.0 Xml;HDR=" + ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, "Yes", "No") + """";
		
		Попытка
			Connection.Open(СтрокаПодключения);
		Исключение
			Попытка
				СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 8.0;HDR=" + ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, "Yes", "No") + """";
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
		
		ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
		
		
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
		
		ОбновитьБазовыеЭлементы(ТаблицаДанных);
	
КонецПроцедуры

Процедура ОбновитьБазовыеЭлементы(ТаблицаДанных)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ТаблицаИсходныхДанных.BL,
	|	ТаблицаИсходныхДанных.CostCenter,
	|	ТаблицаИсходныхДанных.BL_Desc,
	|	ТаблицаИсходныхДанных.CostCenter_Desc,
	|	ТаблицаИсходныхДанных.HFM_Segment,
	|	ТаблицаИсходныхДанных.HFM_Locations
	|ПОМЕСТИТЬ ВТ_ДанныеФайла
	|ИЗ
	|	&ТаблицаИсходныхДанных КАК ТаблицаИсходныхДанных"
	;
	Запрос.УстановитьПараметр("ТаблицаИсходныхДанных", ТаблицаДанных);
	Запрос.Выполнить();
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_ДанныеФайла.BL КАК SegmentOracle_Code,
	|	ВТ_ДанныеФайла.BL_Desc КАК SegmentOracle_Desc,
	|	ВТ_ДанныеФайла.HFM_Segment КАК SegmentHFM_Code,
	|	Сегменты.Ссылка КАК SegmentOracle,
	|	HFM_Technology.Ссылка КАК SegmentHFM,
	|	Сегменты.БазовыйЭлемент КАК SegmentOracleБазовыйЭлемент
	|ИЗ
	|	ВТ_ДанныеФайла КАК ВТ_ДанныеФайла
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сегменты КАК Сегменты
	|		ПО ВТ_ДанныеФайла.BL = Сегменты.Код
	|			И (НЕ Сегменты.ПометкаУдаления)
	|			И (Сегменты.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI))
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Technology КАК HFM_Technology
	|		ПО (НЕ HFM_Technology.ПометкаУдаления)
	|			И ВТ_ДанныеФайла.HFM_Segment = HFM_Technology.Код
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПодразделенияОрганизаций.Ссылка КАК LocationOracle,
	|	HFM_Локации.Ссылка КАК LocationHFM,
	|	ВТ_ДанныеФайла.CostCenter,
	|	ВТ_ДанныеФайла.CostCenter_Desc,
	|	ВТ_ДанныеФайла.HFM_Locations,
	|	ПодразделенияОрганизаций.БазовыйЭлемент КАК LocationOracleБазовыйЭлемент
	|ИЗ
	|	ВТ_ДанныеФайла КАК ВТ_ДанныеФайла
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
	|		ПО (НЕ ПодразделенияОрганизаций.ПометкаУдаления)
	|			И (ПодразделенияОрганизаций.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI))
	|			И ВТ_ДанныеФайла.CostCenter = ПодразделенияОрганизаций.Код
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Locations КАК HFM_Локации
	|		ПО (НЕ HFM_Локации.ПометкаУдаления)
	|			И ВТ_ДанныеФайла.HFM_Locations = HFM_Локации.Код";
	
	НачатьТранзакцию();
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	ЗафиксироватьТранзакцию();
	
	ТЗ_Сегменты = РезультатЗапроса[0].Выгрузить();
	ТЗ_Локации = РезультатЗапроса[1].Выгрузить();
	
	Для каждого Сегмент Из ТЗ_Сегменты Цикл
		Если ЗначениеЗаполнено(Сегмент.SegmentOracle) Тогда
			Если Сегмент.SegmentOracleБазовыйЭлемент <> Сегмент.SegmentHFM И ЗначениеЗаполнено(Сегмент.SegmentHFM) Тогда
				СегментОбъект = Сегмент.SegmentOracle.ПолучитьОбъект();
				СегментОбъект.БазовыйЭлемент = Сегмент.SegmentHFM;
				СегментОбъект.ОбменДанными.Загрузка = Истина;
				СегментОбъект.Записать();
			КонецЕсли;
		Иначе
			СегментОбъект = Справочники.Сегменты.СоздатьЭлемент();
			СегментОбъект.Код = Сегмент.SegmentOracle_Code;
			СегментОбъект.Наименование = Сегмент.SegmentOracle_Desc;
			СегментОбъект.БазовыйЭлемент = Сегмент.SegmentHFM;
			СегментОбъект.ОбменДанными.Загрузка = Истина;
			СегментОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	Для каждого Локация Из ТЗ_Локации Цикл
		Если ЗначениеЗаполнено(Локация.LocationOracle) Тогда
			Если Локация.LocationOracleБазовыйЭлемент <> Локация.LocationHFM И ЗначениеЗаполнено(Локация.LocationHFM) Тогда
				ЛокацияОбъект = Локация.LocationOracle.ПолучитьОбъект();
				ЛокацияОбъект.БазовыйЭлемент = Локация.LocationHFM;
				ЛокацияОбъект.ОбменДанными.Загрузка = Истина;
				ЛокацияОбъект.Записать();
			КонецЕсли;
		Иначе
			ЛокацияОбъект = Справочники.ПодразделенияОрганизаций.СоздатьЭлемент();
			ЛокацияОбъект.Код = Локация.CostCenter;
			ЛокацияОбъект.Наименование = Локация.CostCenter_Desc;
			ЛокацияОбъект.БазовыйЭлемент = Локация.LocationHFM;
			ЛокацияОбъект.ОбменДанными.Загрузка = Истина;
			ЛокацияОбъект.Записать();
		КонецЕсли;
	КонецЦикла;
	
	
	
КонецПроцедуры

Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля, ТекСтрокаСтруктурыКолонок.ТипКолонки);
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Добавить("СтрокаФайла", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Неотрицательный)));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Функция ПолучитьСтруктуруКолонокТаблицыДанных() Экспорт
	
	СтруктураКолонок = Новый ТаблицаЗначений;
	СтруктураКолонок.Колонки.Добавить("ИмяПоля", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("ИмяКолонки", Новый ОписаниеТипов("Строка", , , , Новый КвалификаторыСтроки(100)));
	СтруктураКолонок.Колонки.Добавить("Обязательная", Новый ОписаниеТипов("Булево"));
	СтруктураКолонок.Колонки.Добавить("ТипКолонки");
	ТипСтрока = Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(100));
	// BL
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BL";
	СтрокаТЗ.ИмяКолонки = "BL";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	//BL (Desc)
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BL_Desc";
	СтрокаТЗ.ИмяКолонки = "BL (Desc)";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// Cost Center
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CostCenter";
	СтрокаТЗ.ИмяКолонки = "Cost Center";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	//Cost Center (Desc)
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CostCenter_Desc";
	СтрокаТЗ.ИмяКолонки = "Cost Center (Desc)";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// HFM_Segment1
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "HFM_Locations";
	СтрокаТЗ.ИмяКолонки = "HFM Segment1";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	// HFM Segment4
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "HFM_Segment";
	СтрокаТЗ.ИмяКолонки = "HFM Segment4";
	СтрокаТЗ.Обязательная = Истина;
	СтрокаТЗ.ТипКолонки = ТипСтрока;
	
	Возврат СтруктураКолонок;

КонецФункции

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
		
		НайденаSegment1 = Ложь;
		НайденаSegment4 = Ложь;
		
		Для ТекНомерСтолбца = 1 По 100 Цикл
			
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "HFM Segment1" Тогда
				НайденаSegment1 = Истина;
			КонецЕсли;
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "HFM Segment4" Тогда
				НайденаSegment4 = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НайденаSegment1 И НайденаSegment4 Тогда
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
