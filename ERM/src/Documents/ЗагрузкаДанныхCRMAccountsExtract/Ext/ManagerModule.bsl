﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТаблицаДанных = СтруктураПараметров.ТаблицаДанных;
	ТекстОшибки = "";
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
	ФайлЭксель = СтруктураПараметров.ИсточникДанных.Получить();
	ФайлЭксель.Записать(ПутьКФайлу);
	
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
	
	ВеличинаСдвига = СтруктураПараметров.ПерваяСтрокаДанных - 1 - ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, 1, 0);
	Если ВеличинаСдвига <> 0 Тогда
		rs.Move(ВеличинаСдвига);
	КонецЕсли;
	
	ТекНомерСтроки = СтруктураПараметров.ПерваяСтрокаДанных;
	ПоследняяСтрокаДанных = СтруктураПараметров.ПоследняяСтрокаДанных;
	
	СтруктураКолонок = СтруктураПараметров.СтруктураКолонок;
	
	Пока Не rs.EOF И (ТекНомерСтроки <= ПоследняяСтрокаДанных ИЛИ ПоследняяСтрокаДанных = 0) Цикл
		
		СтрокаТЗ = ТаблицаДанных.Добавить();
		СтрокаТЗ.СтрокаФайла = ТекНомерСтроки;
		
		Для каждого СтруктураКолонки Из СтруктураПараметров.СтруктураКолонок Цикл
			
			Значение = rs.Fields(СтруктураКолонки.НомерКолонки - 1).Value;
			Если ТипЗнч(СтрокаТЗ[СтруктураКолонки.ИмяПоля]) = Тип("Строка") И ТипЗнч(Значение) = Тип("Число") Тогда
				Значение = Формат(Значение, "ЧДЦ=0; ЧГ=0");
			Иначе
				Значение = СокрЛП(Значение);
			КонецЕсли;
			СтрокаТЗ[СтруктураКолонки.ИмяПоля] = Значение;
			
		КонецЦикла; 
		
		rs.MoveNext();
		ТекНомерСтроки = ТекНомерСтроки + 1;
		
	КонецЦикла;
	
	rs.Close();
	Connection.Close();
	УдалитьФайлы(ПутьКФайлу);
	
	ЗагрузитьИЗаписатьДвижения(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата, ТаблицаДанных);
	
	ТаблицаНовыеParentClients = ПолучитьТаблицуНовыеParentClients(СтруктураПараметров.Ссылка);
	ТаблицаНовыеSalesКлиенты = ПолучитьТаблицуНовыеSalesКлиенты(СтруктураПараметров.Ссылка);
	ТаблицаНовыеBillingКлиенты = ПолучитьТаблицуНовыеBillingКлиенты(СтруктураПараметров.Ссылка);
	ТаблицаИзмененныеCRMID = ПолучитьТаблицуИзмененныеCRMID(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата);
	ТаблицаИзмененныеBillingID = ПолучитьТаблицуИзмененныеBillingID(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата);
	ТаблицаИзмененныеParentClients = ПолучитьТаблицуИзмененныеParentClients(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата);
	
	ДанныеДляЗаполнения.Вставить("ТаблицаНовыеParentClients", ТаблицаНовыеParentClients);
	ДанныеДляЗаполнения.Вставить("ТаблицаНовыеSalesКлиенты", ТаблицаНовыеSalesКлиенты);
	ДанныеДляЗаполнения.Вставить("ТаблицаНовыеBillingКлиенты", ТаблицаНовыеBillingКлиенты);
	ДанныеДляЗаполнения.Вставить("ТаблицаИзмененныеCRMID", ТаблицаИзмененныеCRMID);
	ДанныеДляЗаполнения.Вставить("ТаблицаИзмененныеBillingID", ТаблицаИзмененныеBillingID);
	ДанныеДляЗаполнения.Вставить("ТаблицаИзмененныеParentClients", ТаблицаИзмененныеParentClients);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ЗагрузитьИЗаписатьДвижения(Ссылка, ДатаДокумента, ТаблицаДанных)
	
	ТаблицаДанных.Колонки.Добавить("ДокументЗагрузки");
	ТаблицаДанных.ЗаполнитьЗначения(Ссылка, "ДокументЗагрузки");
	
	НЗ = РегистрыСведений.CRMAccountsExtractSourceData.СоздатьНаборЗаписей();
	НЗ.Загрузить(ТаблицаДанных);
	НЗ.Записать(Истина);
	
КонецПроцедуры

Функция ПолучитьТаблицуНовыеParentClients(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	CRMAccountsExtractSourceData.CorporateAlias КАК CorporateAlias
		|ПОМЕСТИТЬ ВТ_ParentClients
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.CorporateAlias <> """"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CorporateAlias
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_SalesAccounts.CorporateAlias КАК Description
		|ИЗ
		|	ВТ_ParentClients КАК ВТ_SalesAccounts
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ПО (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ParentClients))
		|			И ВТ_SalesAccounts.CorporateAlias = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор ЕСТЬ NULL";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНовыеParentClients = РезультатЗапроса.Выгрузить();
	ТаблицаНовыеParentClients.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаНовыеParentClients;
	
КонецФункции

Функция ПолучитьТаблицуНовыеSalesКлиенты(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.Id КАК CRMID,
		|	CRMAccountsExtractSourceData.Account КАК Description,
		|	CRMAccountsExtractSourceData.CorporateAlias КАК ParentClient
		|ПОМЕСТИТЬ ВТ_SalesAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.CustomerNumber = """"
		|	И CRMAccountsExtractSourceData.Id <> """"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.Id
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_SalesAccounts.CRMID,
		|	ВТ_SalesAccounts.Description,
		|	ВТ_SalesAccounts.ParentClient
		|ИЗ
		|	ВТ_SalesAccounts КАК ВТ_SalesAccounts
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ПО ВТ_SalesAccounts.CRMID = НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM))
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНовыеSalesКлиенты = РезультатЗапроса.Выгрузить();
	ТаблицаНовыеSalesКлиенты.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаНовыеSalesКлиенты;
	
КонецФункции

Функция ПолучитьТаблицуНовыеBillingКлиенты(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.Id КАК CRMID,
		|	CRMAccountsExtractSourceData.CustomerNumber КАК BillingID,
		|	CRMAccountsExtractSourceData.Account КАК Description,
		|	CRMAccountsExtractSourceData.CorporateAlias КАК ParentClient
		|ПОМЕСТИТЬ ВТ_BillingAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.CustomerNumber <> """"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.Id
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_BillingAccounts.CRMID,
		|	ВТ_BillingAccounts.BillingID,
		|	ВТ_BillingAccounts.Description,
		|	ВТ_BillingAccounts.ParentClient
		|ИЗ
		|	ВТ_BillingAccounts КАК ВТ_BillingAccounts
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиBillingAccounts
		|		ПО (НастройкаСинхронизацииОбъектовСВнешнимиСистемамиBillingAccounts.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
		|			И ВТ_BillingAccounts.BillingID = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиBillingAccounts.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиSalesAccounts
		|		ПО (НастройкаСинхронизацииОбъектовСВнешнимиСистемамиBillingAccounts.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM))
		|			И ВТ_BillingAccounts.CRMID = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиSalesAccounts.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиBillingAccounts.Идентификатор ЕСТЬ NULL 
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемамиSalesAccounts.Идентификатор ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНовыеBillingКлиенты = РезультатЗапроса.Выгрузить();
	ТаблицаНовыеBillingКлиенты.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаНовыеBillingКлиенты;
	
КонецФункции

Функция ПолучитьТаблицуИзмененныеCRMID(Ссылка, Дата)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.Id КАК CRMID,
		|	CRMAccountsExtractSourceData.CustomerNumber КАК BillingID,
		|	CRMAccountsExtractSourceData.Account КАК Description
		|ПОМЕСТИТЬ ВТ_BillingAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.CustomerNumber <> """"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.Id
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыCRM
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(&Период, ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыLawson
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(&Период, ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыCRM
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыCRM КАК ВТ_ПоследниеДатыCRM
		|		ПО (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM))
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыCRM.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыCRM.ОбъектПриемника
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыLawson
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыLawson КАК ВТ_ПоследниеДатыLawson
		|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыLawson.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыLawson.ОбъектПриемника
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВТ_ИдентификаторыCRM.ОбъектПриемника, ВТ_ИдентификаторыLawson.ОбъектПриемника) КАК ОбъектПриемника,
		|	ЕСТЬNULL(ВТ_ИдентификаторыCRM.Идентификатор, """") КАК CRMID,
		|	ЕСТЬNULL(ВТ_ИдентификаторыLawson.Идентификатор, """") КАК BillingID
		|ПОМЕСТИТЬ ВТ_ActualMapping
		|ИЗ
		|	ВТ_ИдентификаторыCRM КАК ВТ_ИдентификаторыCRM
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыLawson КАК ВТ_ИдентификаторыLawson
		|		ПО ВТ_ИдентификаторыCRM.ОбъектПриемника = ВТ_ИдентификаторыLawson.ОбъектПриемника
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	BillingID
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ActualMapping.CRMID КАК OldCRMID,
		|	ВТ_BillingAccounts.CRMID КАК NewCRMID,
		|	ВТ_BillingAccounts.BillingID,
		|	ВТ_BillingAccounts.Description,
		|	ВТ_ActualMapping.ОбъектПриемника КАК Client
		|ИЗ
		|	ВТ_BillingAccounts КАК ВТ_BillingAccounts
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ActualMapping КАК ВТ_ActualMapping
		|		ПО ВТ_BillingAccounts.BillingID = ВТ_ActualMapping.BillingID
		|ГДЕ
		|	ВТ_BillingAccounts.CRMID <> ВТ_ActualMapping.CRMID
		|	И ВТ_ActualMapping.CRMID <> """"";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаИзмененныеCRMID = РезультатЗапроса.Выгрузить();
	ТаблицаИзмененныеCRMID.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаИзмененныеCRMID;
	
КонецФункции

Функция ПолучитьТаблицуИзмененныеBillingID(Ссылка, Дата)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.Id КАК CRMID,
		|	CRMAccountsExtractSourceData.CustomerNumber КАК BillingID,
		|	CRMAccountsExtractSourceData.Account КАК Description
		|ПОМЕСТИТЬ ВТ_BillingAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.CustomerNumber <> """"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.Id
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыCRM
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(&Период, ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыLawson
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(&Период, ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихLawson.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыCRM
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыCRM КАК ВТ_ПоследниеДатыCRM
		|		ПО (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM))
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыCRM.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыCRM.ОбъектПриемника
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыLawson
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыLawson КАК ВТ_ПоследниеДатыLawson
		|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыLawson.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыLawson.ОбъектПриемника
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson))
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВТ_ИдентификаторыCRM.ОбъектПриемника, ВТ_ИдентификаторыLawson.ОбъектПриемника) КАК ОбъектПриемника,
		|	ЕСТЬNULL(ВТ_ИдентификаторыCRM.Идентификатор, """") КАК CRMID,
		|	ЕСТЬNULL(ВТ_ИдентификаторыLawson.Идентификатор, """") КАК BillingID
		|ПОМЕСТИТЬ ВТ_ActualMapping
		|ИЗ
		|	ВТ_ИдентификаторыCRM КАК ВТ_ИдентификаторыCRM
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыLawson КАК ВТ_ИдентификаторыLawson
		|		ПО ВТ_ИдентификаторыCRM.ОбъектПриемника = ВТ_ИдентификаторыLawson.ОбъектПриемника
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMID
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_BillingAccounts.CRMID,
		|	ВТ_ActualMapping.BillingID КАК OldBillingID,
		|	ВТ_BillingAccounts.BillingID КАК NewOldBillingID,
		|	ВТ_BillingAccounts.Description,
		|	ВТ_ActualMapping.ОбъектПриемника КАК Client
		|ИЗ
		|	ВТ_BillingAccounts КАК ВТ_BillingAccounts
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ActualMapping КАК ВТ_ActualMapping
		|		ПО ВТ_BillingAccounts.CRMID = ВТ_ActualMapping.CRMID
		|ГДЕ
		|	ВТ_ActualMapping.BillingID <> ВТ_BillingAccounts.BillingID
		|	И ВТ_ActualMapping.BillingID <> """"";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаИзмененныеBillingID = РезультатЗапроса.Выгрузить();
	ТаблицаИзмененныеBillingID.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаИзмененныеBillingID;
	
КонецФункции

Функция ПолучитьТаблицуИзмененныеParentClients(Ссылка, Дата)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.Id КАК CRMID,
		|	CRMAccountsExtractSourceData.CustomerNumber КАК BillingID,
		|	CRMAccountsExtractSourceData.Account КАК Description,
		|	CRMAccountsExtractSourceData.CorporateAlias КАК ParentClient
		|ПОМЕСТИТЬ ВТ_SalesAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.Id <> """"
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.Id
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыCRM
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(&Период, ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыCRM
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыCRM КАК ВТ_ПоследниеДатыCRM
		|		ПО (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.CRM))
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыCRM.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыCRM.ОбъектПриемника
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыParentClients
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(&Период, ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ParentClients)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследнихCRM.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыParentClients
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыParentClients КАК ВТ_ПоследниеДатыParentClients
		|		ПО (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ParentClients))
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыParentClients.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыParentClients.ОбъектПриемника
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_SalesAccounts.CRMID,
		|	ВТ_SalesAccounts.BillingID,
		|	ВТ_SalesAccounts.Description,
		|	ВТ_ИдентификаторыCRM.ОбъектПриемника КАК Client,
		|	ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент КАК OldParentClient,
		|	ВТ_ИдентификаторыParentClients.ОбъектПриемника КАК NewParentClient,
		|	ВТ_SalesAccounts.ParentClient КАК NewParentClientDescription
		|ИЗ
		|	ВТ_SalesAccounts КАК ВТ_SalesAccounts
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыCRM КАК ВТ_ИдентификаторыCRM
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияКонтрагентов.СрезПоследних(&Период, ) КАК ИерархияКонтрагентовСрезПоследних
		|			ПО ВТ_ИдентификаторыCRM.ОбъектПриемника = ИерархияКонтрагентовСрезПоследних.Контрагент
		|		ПО ВТ_SalesAccounts.CRMID = ВТ_ИдентификаторыCRM.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыParentClients КАК ВТ_ИдентификаторыParentClients
		|		ПО ВТ_SalesAccounts.ParentClient = ВТ_ИдентификаторыParentClients.Идентификатор
		|ГДЕ
		|	(ВТ_ИдентификаторыParentClients.ОбъектПриемника ЕСТЬ NULL 
		|			ИЛИ ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент <> ВТ_ИдентификаторыParentClients.ОбъектПриемника)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаИзмененныеParentClients = РезультатЗапроса.Выгрузить();
	ТаблицаИзмененныеParentClients.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	
	Возврат ТаблицаИзмененныеParentClients;
	
КонецФункции

#КонецЕсли