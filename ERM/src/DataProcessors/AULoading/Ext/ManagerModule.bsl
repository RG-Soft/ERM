﻿
//Производит загрузку Accounting units из excel-файла "AU_master" с hub'a 

//регламентное задание
Процедура ЗагрузитьAccountingUnitsИзAU_master() Экспорт
	
	//http://www.hub.slb.com/display/index.do?id=id2501787
	//http://reports.lawson.slb.com/londonmis2/Lawson/MasterData/MasterDataTables/AU_MASTER.zip
	
	//получим файл 
	//СерверИсточник = "reports.lawson.slb.com";
	СерверИсточник = "financereports.lawson.slb.com";
	СтрокаПараметраПолучения = "londonmis2/Lawson/MasterData/MasterDataTables/AU_MASTER.zip";
	ОбработкаПолученияФайлов = Обработки.ПолучениеФайловИзИнтернета.Создать();
                   	
	ВремКаталог = КаталогВременныхФайлов() + "tempAUs";
	СоздатьКаталог(ВремКаталог);
	УдалитьФайлы(ВремКаталог, "*.*");
	ИмяВходящегоФайла = "" + ВремКаталог + "\" + "AU_master.zip";
			
	Если ЗапроситьФайлыССервера(СерверИсточник, СтрокаПараметраПолучения, ИмяВходящегоФайла) <> Истина Тогда
		РГСофт.СообщитьИЗалоггировать(
			"Не удалось скачать файл AU_master.zip",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Обработки.AULoading,
			Неопределено);
		УдалитьФайлы(ВремКаталог,"*.*");
		Возврат;
	КонецЕсли; 
         	
	//разархивируем файл
	Попытка
		ZipЧтение = Новый ЧтениеZipФайла(ИмяВходящегоФайла);
		ЭлементZipФайла = ZipЧтение.Элементы[0];
	Исключение
		РГСофт.СообщитьИЗалоггировать("Не удалось разархивировать AU_master.zip!",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Обработки.AULoading,
			Неопределено,
			ОписаниеОшибки());
		УдалитьФайлы(ВремКаталог,"*.*");
		Возврат;
	КонецПопытки;
	
	Если СтрНайти(ЭлементZipФайла.Имя, "xls") = 0 Тогда
		РГСофт.СообщитьИЗалоггировать("Не удалось найти xls-файл в AU_master.zip",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Обработки.AULoading,
			Неопределено,
			ОписаниеОшибки());
		УдалитьФайлы(ВремКаталог,"*.*");
		Возврат;
	КонецЕсли;
		
	ZipЧтение.Извлечь(ЭлементZipФайла, ВремКаталог, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
		
	ПолноеИмяФайла = ВремКаталог + "\" + ЭлементZipФайла.Имя;
	     		
	//загрузим файл
	Попытка
		ЗагрузитьДанныеИзФайла(ПолноеИмяФайла);
	Исключение
		РГСофт.СообщитьИЗалоггировать(
			"Не удалось загрузить файл AU_master.zip",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Обработки.AULoading,
			Неопределено,
			ОписаниеОшибки());
	КонецПопытки;

	УдалитьФайлы(ВремКаталог,"*.*");
       	
КонецПроцедуры // ЗагрузитьAccountingUnitsИзAU_master()

// Функция получает файлы с сервера с указанными параметрами и сохраняет на диск
//
// Параметры:
//  HTTP - HTTPСоединение, если приходится использовать данную функцию в цикле, то тут передается
//         переменная с созданным в предыдущей итерации цикла HTTPСоединением
// СерверИсточникПараметр - Строка, сервер, с которого необходимо получить файлы
// СтрокаПараметраПолученияПараметр - Строка, адрес ресурса на сервере.
// ИмяВходящегоФайлаПараметр - Имя файла, в который помещаются данные полученного ресурса.
//
// Возвращаемое значение:
//  Булево - Успешно получены файлы или нет.
//
Функция ЗапроситьФайлыССервера(СерверИсточникПараметр, СтрокаПараметраПолученияПараметр, ИмяВходящегоФайлаПараметр, HTTP = Неопределено)

	СерверИсточник           = СерверИсточникПараметр;
	СтрокаПараметраПолучения = СтрокаПараметраПолученияПараметр;
	ИмяВходящегоФайла        = ИмяВходящегоФайлаПараметр;
	
	Если ТипЗнч(HTTP) <> Тип("HTTPСоединение") Тогда
		//HTTP = Новый HTTPСоединение(СерверИсточник)
		HTTP = Новый HTTPСоединение(СерверИсточник, , , , , , , Истина)
	КонецЕсли; 
	
	Попытка
		HTTP.Получить(СтрокаПараметраПолучения, ИмяВходящегоФайла);
		Возврат Истина;
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции


//загрузка AU из Excel-файла 
Процедура ЗагрузитьДанныеИзФайла(ПолноеИмяФайла) Экспорт 
	
	ТекстОшибок = "";
	
	МассивСтруктурAU = ПолучитьМассивСтруктурAUИзФайла(ТекстОшибок, ПолноеИмяФайла);
	
	Если ПустаяСтрока(ТекстОшибок) Тогда
		ЗагрузитьAU(ТекстОшибок, МассивСтруктурAU);
	КонецЕсли;
	
	Если Не ПустаяСтрока(ТекстОшибок) Тогда 
		РГСофт.СообщитьИЗалоггировать(
			"В ходе загрузки AU_master.xls возникли ошибки!",
			УровеньЖурналаРегистрации.Ошибка,
			Метаданные.Обработки.AULoading,
			Неопределено,
			ТекстОшибок + ОписаниеОшибки());
	КонецЕсли;
		
КонецПроцедуры
     
Функция ПолучитьМассивСтруктурAUИзФайла(ТекстОшибок, ПолноеИмяФайла)
	
	МассивСтруктурAU = Новый Массив;
		
	Connection = Новый COMОбъект("ADODB.Connection");
	СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ПолноеИмяФайла + ";Extended Properties=""Excel 12.0;HDR=No;IMEX=1""";	
	
	Попытка 
		Connection.Open(СтрокаПодключения);	
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ПолноеИмяФайла + ";Extended Properties=""Excel 8.0;HDR=No;IMEX=1""";
			Connection.Open(СтрокаПодключения);
		Исключение
			ТекстОшибок = ТекстОшибок + ОписаниеОшибки();
		КонецПопытки;
	КонецПопытки;
		
	rs = Новый COMObject("ADODB.RecordSet");
	rs.ActiveConnection = Connection;
	rs = Connection.OpenSchema(20);
	
	ЛистЭксель = rs.Fields("TABLE_NAME").Value;
	
	sqlString = "select * from [" + ЛистЭксель + "]";
	rs.Close();
	rs.Open(sqlString);
	
	rs.MoveFirst();
 
	// { RGS AArsentev 6/23/2016 12:49:48 PM - S-I-0001665 - Добавил SubGeomarket
	СвойстваСтруктуры = "AccountingUnit,Description,Location,Segment,SubSegment,SsubSegment,AstActivity,Company,Area,Geomarket,SubGeomarket";
	// } RGS AArsentev 6/23/2016 12:50:20 PM - S-I-0001665
	СтруктураЗначенийСтроки = Новый Структура(СвойстваСтруктуры);
	
	//CompanyForLoading = Константы.FiscalParentCompany.Получить();
	//CompanyNo = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(CompanyForLoading, "CompanyNo")); 
	
	НомерСтроки = 0;
	Пока rs.EOF = 0 Цикл
		
		НомерСтроки = НомерСтроки + 1;
						
		Если НомерСтроки = 1 Тогда 
			
			СтруктураИменИНомеровКолонок = ПолучитьСтруктуруИменИНомеровКолонок(rs, СвойстваСтруктуры, ТекстОшибок);
			
			Если Не ПустаяСтрока(ТекстОшибок) Тогда 
				Прервать;
			КонецЕсли;
			
			rs.MoveNext();
			Продолжить;
			
		КонецЕсли;
		
		//добавляем значение каждой ячейки файла в структуру значений
		Для Каждого ЭлементСтруктуры из СтруктураИменИНомеровКолонок Цикл 
			
			ЗначениеЯчейки = rs.Fields(ЭлементСтруктуры.Значение-1).Value;
			СтруктураЗначенийСтроки[ЭлементСтруктуры.Ключ] = ЗначениеЯчейки;
			
		КонецЦикла;
		
		Если Не ЗначениеЗаполнено(СтруктураЗначенийСтроки.AccountingUnit) Тогда 
			Прервать;
		КонецЕсли;
		
		//Если СтруктураЗначенийСтроки.Company <> CompanyNo ИЛИ СтруктураЗначенийСтроки.Area <> "RCA" 
		//	ИЛИ Не ЗначениеЗаполнено(СтруктураЗначенийСтроки.Segment)
		//	ИЛИ Не ЗначениеЗаполнено(СтруктураЗначенийСтроки.SubSegment)
		//	ИЛИ Не ЗначениеЗаполнено(СтруктураЗначенийСтроки.SsubSegment) Тогда
		//	rs.MoveNext();
		//	Продолжить;
		//КонецЕсли;
		         		
		
		//добавляем новую структуру и пытаемся заполнить	
		Попытка
			
			СтруктураAU = Новый Структура(СвойстваСтруктуры);
			
			Для Каждого ЭлементСтруктурыЗначений из СтруктураЗначенийСтроки Цикл 
				СтруктураAU[ЭлементСтруктурыЗначений.Ключ] = ЭлементСтруктурыЗначений.Значение;	
			КонецЦикла;
			
			СтруктураAU.Вставить("НомерСтрокиФайла", НомерСтроки);
			
			МассивСтруктурAU.Добавить(СтруктураAU);
			
		Исключение
			ТекстОшибок = ТекстОшибок + "
			|не удалось загрузить данные в строке №" + НомерСтроки + " в колонке '" + ЭлементСтруктурыЗначений.Ключ + "'!";
		КонецПопытки;
		
		rs.MoveNext();
		
	КонецЦикла;
	
	rs.Close();
	Connection.Close();
	
	Возврат МассивСтруктурAU;
	
КонецФункции

Функция ПолучитьСтруктуруИменИНомеровКолонок(rs, СвойстваСтруктуры, ТекстОшибок)
	
	СтруктураКолонокИИндексов = Новый Структура(СвойстваСтруктуры);
	
	НомерКолонки = 1;
	Для Каждого Field из rs.Fields Цикл 
		
		ТекстЯчейки = СокрЛП(Field.Value);
		Если НЕ ЗначениеЗаполнено(ТекстЯчейки) Тогда
			Прервать;
		КонецЕсли; 
		
		Если ТекстЯчейки = "Accounting Unit" Тогда
			СтруктураКолонокИИндексов.AccountingUnit = НомерКолонки;
		ИначеЕсли ТекстЯчейки = "Description" Тогда
			СтруктураКолонокИИндексов.Description = НомерКолонки;
		ИначеЕсли ТекстЯчейки = "Location" Тогда
			СтруктураКолонокИИндексов.Location = НомерКолонки;
		ИначеЕсли ТекстЯчейки = "Segment" Тогда
			СтруктураКолонокИИндексов.Segment = НомерКолонки;
		ИначеЕсли ТекстЯчейки = "SubSegment" или ТекстЯчейки = "Sub Segment" Тогда
			СтруктураКолонокИИндексов.SubSegment = НомерКолонки;
		ИначеЕсли ТекстЯчейки = "SubSubSegment" или ТекстЯчейки = "SsubSegment" или ТекстЯчейки = "Ssub Segment" Тогда
			СтруктураКолонокИИндексов.SsubSegment = НомерКолонки;
		ИначеЕсли ТекстЯчейки = "AstActivity" Тогда
			СтруктураКолонокИИндексов.AstActivity = НомерКолонки;
      	ИначеЕсли ТекстЯчейки = "Company" Тогда
			СтруктураКолонокИИндексов.Company = НомерКолонки;
      	ИначеЕсли ТекстЯчейки = "Area" Тогда
			СтруктураКолонокИИндексов.Area = НомерКолонки;
      	ИначеЕсли ТекстЯчейки = "Geomarket" Тогда
			СтруктураКолонокИИндексов.Geomarket = НомерКолонки;
			// { RGS AArsentev 6/23/2016 12:49:48 PM - S-I-0001665
		ИначеЕсли ТекстЯчейки = "Sub Geomarket" Тогда
			СтруктураКолонокИИндексов.SubGeomarket = НомерКолонки;
			// } RGS AArsentev 6/23/2016 12:49:48 PM - S-I-0001665
      	КонецЕсли;   
		
		НомерКолонки = НомерКолонки + 1;
		
	КонецЦикла; 
	
	Для Каждого КлючИЗначение Из СтруктураКолонокИИндексов Цикл
		
		Если КлючИЗначение.Значение = Неопределено Тогда
			ТекстОшибок = ТекстОшибок + "
			|необходимо проверить наличие колонки с данными '" + КлючИЗначение.Ключ + "'!";
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураКолонокИИндексов;
	
КонецФункции


//	Соответствие реквизитов справочника Кост-центры и колонок в файле следующее:
//  Код - Accounting Unit
//  Наименование - Description
//  Segment    - Segment (ищется по коду, если не найден, создается новый)
//  SubSegment - SubSegment (ищется по коду, если не найден, создается новый)
//  Сегмент    - SsubSegment (ищется по коду, если не найден, создается новый)
//  Подразделение организации - Location (ищется по коду)
//  Default activity - AstActivity
	
Процедура ЗагрузитьAU(ТекстОшибок, МассивСтруктурAU) 
	                  		     	
	ТЗДанныхAU = ПолучитьДанныеДляЗаполненияAU(МассивСтруктурAU);
	РГСофтКлиентСервер.СокрЛПКолонокВТаблице(ТЗДанныхAU, "Код");
	
	Для Каждого СтруктураAU из МассивСтруктурAU Цикл
		//-> RG-Soft Mchernetsov 2016/09/02
		Если СтруктураAU.SsubSegment = "ISM" Тогда
			Продолжить;
		КонецЕсли;
		//<- RG-Soft Mchernetsov 2016/09/02
		НачатьТранзакцию();
		
		Попытка
			//Ищем AU по коду. Если не нашли - создаем.
						
			//СтрокаДанныхAU = ТЗДанныхAU.Найти(СтруктураAU.AccountingUnit, "Код");
			AU_Код = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(СтруктураAU.AccountingUnit,10," ","Справа");
			СтрокаДанныхAU = ТЗДанныхAU.Найти(AU_Код, "Код");
						
			AUОбъект = ЗаполнитьAU(СтрокаДанныхAU, СтруктураAU);
			Если AUОбъект.Сегмент.Пустая() тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		    "Элемент не записан, т.к. не заполнен Сегмент для " + СокрЛП(СтруктураAU.Location) + "' в строке №" + СтруктураAU.НомерСтрокиФайла +"!");
			продолжить	
			КонецЕсли;
			//-> RG-Soft VIvanov 2015/02/18
			Если AUОбъект.ЭтоНовый() Тогда
				AUОбъект.Записать();
				//ЗаписьСегмента = РегистрыСведений.СегментыКостЦентров.СоздатьМенеджерЗаписи();
				Если СтрокаДанныхAU = Неопределено Тогда
					//ЗаписьСегмента.Период = Дата("19800101000000");
					СтрокаДанныхAU = ТЗДанныхAU.Добавить();
					СтрокаДанныхAU.Код = AUОбъект.Код;
				Иначе
					//ЗаписьСегмента.Период = НачалоМесяца(ТекущаяДата());
				КонецЕсли;
				СтрокаДанныхAU.AU = AUОбъект.Ссылка;
				СтрокаДанныхAU.Сегмент = AUОбъект.Сегмент;
				СтрокаДанныхAU.SubSegment = AUОбъект.SubSegment;
				СтрокаДанныхAU.Segment = AUОбъект.Segment;
				СтрокаДанныхAU.ПодразделениеОрганизации = AUОбъект.ПодразделениеОрганизации;
				СтрокаДанныхAU.DefaultActivity = AUОбъект.DefaultActivity;
				// { RGS AArsentev 6/23/2016 12:49:48 PM - S-I-0001665
				//СтрокаДанныхAU.Geomarket = AUОбъект.Geomarket; 
				//СтрокаДанныхAU.SubGeomarket = AUОбъект.SubGeomarket; 
				// } RGS AArsentev 6/23/2016 12:49:48 PM - S-I-0001665
				//ЗаписьСегмента.Код = AUОбъект.Код;
				//ЗаписьСегмента.КостЦентр = AUОбъект.Ссылка;
				//ЗаписьСегмента.Записать();
			Иначе
				AUОбъект.Записать();
			КонецЕсли;
			//<- RG-Soft VIvanov
			
			//пока только для RUL
			//Если Не ЗначениеЗаполнено(AUОбъект.TaxRegistration) И СтруктураAU.Geomarket = "RUL" Тогда
			//	Задачи.УниверсальнаяЗадача.СоздатьЗадачуДляЗаполненияTaxRegistration(AUОбъект.Ссылка);
			//КонецЕсли;
			
		Исключение
			ТекстОшибок = ТекстОшибок + "
				|не удалось записать Accounting Unit '"+ СтруктураAU.AccountingUnit + "' в строке №"+ СтруктураAU.НомерСтрокиФайла + ",
				|"+ ОписаниеОшибки();
				
			ОтменитьТранзакцию();
				
		КонецПопытки;   
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла; 	
		
КонецПроцедуры

Функция ПолучитьДанныеДляЗаполненияAU(МассивСтруктурAU)
	
	Запрос = Новый Запрос;
	
	МассивКодов = Новый Массив;
	Для Каждого СтруктураAU из МассивСтруктурAU Цикл 
		МассивКодов.Добавить(СтруктураAU.AccountingUnit);
	КонецЦикла; 
	
    Запрос.УстановитьПараметр("МассивКодов", МассивКодов);

	Запрос.Текст = "ВЫБРАТЬ
	               |	КостЦентры.Ссылка КАК AU,
	               |	КостЦентры.Код,
	               |	КостЦентры.Наименование,
	               |	КостЦентры.Сегмент,
	               |	КостЦентры.ПодразделениеОрганизации,
	               |	КостЦентры.DefaultActivity,
	               |	КостЦентры.SubSegment,
	               |	КостЦентры.Segment
	               |ИЗ
	               |	Справочник.КостЦентры КАК КостЦентры
	               |ГДЕ
	               |	НЕ КостЦентры.ПометкаУдаления
	               |	И КостЦентры.Код В(&МассивКодов)";
		         		
	Возврат Запрос.Выполнить().Выгрузить();
		
КонецФункции

Функция ЗаполнитьAU(СтрокаДанныхAU, Стр)
	//Добавила Федотова Л., РГ-Софт, 28.04.16, вопрос SLI-0006427
	Перем Segment, SubSegment, SsubSegment;
	//
	
	УстановитьПривилегированныйРежим(Истина);
	
	//Часть кода по изменению струкруры сегментов перенесла в общий модуль, 
	//чтобы можно было использовать при загрузке DSS
	//Федотова Л., РГ-Софт, 28.04.16, вопрос SLI-0006427
    Если Стр.Segment <> null тогда
	РГСофт.ИзменитьСтруктуруСегментов(Стр, Segment, SubSegment, SsubSegment);
	КонецЕсли;
	//-> RG-Soft VIvanov 2015/02/18
	Если СтрокаДанныхAU = Неопределено Тогда 
		AUОбъект = Справочники.КостЦентры.СоздатьЭлемент();
		AUОбъект.ДополнительныеСвойства.Вставить("ЗагрузкаИзDSS", Истина);
	Иначе
		// { RGS AGorlenko 23.08.2016 19:51:55 - 
		//Если Segment <> СтрокаДанныхAU.Segment Или SubSegment <> СтрокаДанныхAU.SubSegment Или SsubSegment <> СтрокаДанныхAU.Сегмент Тогда
		//	AUОбъект = Справочники.КостЦентры.СоздатьЭлемент();
		//	AUОбъект.ДополнительныеСвойства.Вставить("ЗагрузкаИзDSS", Истина);
		//Иначе
		// } RGS AGorlenko 23.08.2016 19:51:56 - 
			AUОбъект = СтрокаДанныхAU.AU.ПолучитьОбъект();
		// { RGS AGorlenko 23.08.2016 19:52:18 - 
		//КонецЕсли;
		// } RGS AGorlenko 23.08.2016 19:52:18 - 
	КонецЕсли;
			
	//Заполняем реквизиты в AU
	AUОбъект.Код                      = СокрЛП(Стр.AccountingUnit);
	AUОбъект.Наименование             = СокрЛП(Стр.Description);
	AUОбъект.DefaultActivity          = СокрЛП(Стр.AstActivity);
	// { RGS TAlmazova 12/4/2017 6:56:32 PM - 
	AUОбъект.Source                   = Перечисления.ТипыСоответствий.Lawson;
	// } RGS TAlmazova 12/4/2017 6:56:35 PM - 
	//<- RG-Soft VIvanov
	     	
	РГСофтКлиентСервер.УстановитьЗначение(AUОбъект.Segment, Segment);
	РГСофтКлиентСервер.УстановитьЗначение(AUОбъект.SubSegment, SubSegment);	
	РГСофтКлиентСервер.УстановитьЗначение(AUОбъект.Сегмент, SsubSegment);
	
	// ( RGS AArsentev 7/08/2016 16:23:48 PM - S-I-0001665
    //ЗаполнитьИзФайла(AUОбъект, Стр);
	// } RGS AArsentev 7/08/2016 16:23:48 PM - S-I-0001665

	ПодразделениеОрганизации = Справочники.ПодразделенияОрганизаций.НайтиПоКоду(СокрЛП(Стр.Location));
	Если ЗначениеЗаполнено(ПодразделениеОрганизации) и не ПодразделениеОрганизации.ПометкаУдаления  Тогда 
		РГСофтКлиентСервер.УстановитьЗначение(AUОбъект.ПодразделениеОрганизации, ПодразделениеОрганизации);
	Иначе		
		НовоеПодразделение = Справочники.ПодразделенияОрганизаций.СоздатьЭлемент();
		НовоеПодразделение.Наименование = СокрЛП(Стр.Location);
		НовоеПодразделение.Код = СокрЛП(Стр.Location);
		НовоеПодразделение.Source = Перечисления.ТипыСоответствий.Lawson;
		SubGeomarket = Справочники.GeoMarkets.НайтиПоКоду(СокрЛП(Стр.SubGeomarket));
		Если не ЗначениеЗаполнено(SubGeomarket) тогда
			
			СабГеомаркет = Справочники.GeoMarkets.СоздатьЭлемент();
			СабГеомаркет.Код = СокрЛП(Стр.SubGeomarket);
			СабГеомаркет.Наименование = СокрЛП(Стр.SubGeomarket);			
			GeoMarket = Справочники.GeoMarkets.НайтиПоКоду(СокрЛП(Стр.Geomarket));			
			Если ЗначениеЗаполнено(GeoMarket) и GeoMarket.ЭтоГруппа тогда
				СабГеомаркет.Родитель = GeoMarket.Ссылка;
				СабГеомаркет.Записать();
				НовоеПодразделение.GeoMarket = СабГеомаркет.Ссылка;
			ИначеЕсли ЗначениеЗаполнено(GeoMarket) и не GeoMarket.ЭтоГруппа тогда				
			Иначе				
				Геомаркет = Справочники.GeoMarkets.СоздатьГруппу();	
				Геомаркет.Код = СокрЛП(Стр.Geomarket);
				Геомаркет.Наименование = СокрЛП(Стр.Geomarket);
				Геомаркет.Записать();
				СабГеомаркет.Родитель = Геомаркет.Ссылка;
				СабГеомаркет.Записать();
				НовоеПодразделение.GeoMarket = СабГеомаркет.Ссылка;
			КонецЕсли;		
						
		иначе
			НовоеПодразделение.GeoMarket = SubGeomarket;
		КонецЕсли; 
		НовоеПодразделение.Записать();
		РГСофтКлиентСервер.УстановитьЗначение(AUОбъект.ПодразделениеОрганизации, НовоеПодразделение.Ссылка);
	КонецЕсли;
            	
	Возврат AUОбъект;
	
КонецФункции

Процедура ЗаполнитьИзФайла(AU, СтруктураAU)
	
	Запрос = новый запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	GeoMarkets.Ссылка КАК СубГеомаркет,
	|	GeoMarkets.Родитель КАК Геомаркет
	|ИЗ
	|	Справочник.GeoMarkets КАК GeoMarkets
	|ГДЕ
	|	GeoMarkets.Ссылка.Код = &СубГеомаркет
	|	И GeoMarkets.Родитель.Код = &Геомаркет
	|	И GeoMarkets.ЭтоГруппа
	|	И GeoMarkets.Родитель.ЭтоГруппа";
	Запрос.УстановитьПараметр("СубГеомаркет", СокрЛП(СтруктураAU.SubGeomarket));
	Запрос.УстановитьПараметр("Геомаркет", СокрЛП(СтруктураAU.Geomarket));
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() = 1 тогда
		Если  Результат[0].Геомаркет.Родитель.Родитель = Справочники.GeoMarkets.ПустаяСсылка()  тогда 
			Если Результат[0].СубГеомаркет.Родитель = Результат[0].Геомаркет тогда
				РГСофтКлиентСервер.УстановитьЗначение(AU.Geomarket, Результат[0].Геомаркет);
				РГСофтКлиентСервер.УстановитьЗначение(AU.SubGeomarket, Результат[0].СубГеомаркет);
			иначе
				РГСофтКлиентСервер.УстановитьЗначение(AU.Geomarket, Результат[0].СубГеомаркет.Родитель);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

	
КонецПроцедуры
