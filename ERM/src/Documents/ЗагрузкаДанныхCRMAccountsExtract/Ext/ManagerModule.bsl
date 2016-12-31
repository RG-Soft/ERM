﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	СтруктураКолонок = СтруктураПараметров.СтруктураКолонок;
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	ТекстОшибки = "";
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
	ФайлЭксель = СтруктураПараметров.ИсточникДанных.Получить();
	ФайлЭксель.Записать(ПутьКФайлу);
	
	// { RGS  PMatkov 01.12.2015 16:47:17 - Перенос повторяющегося кода в общий модуль
	rgsЗагрузкаИзExcel.ВыгрузитьЭксельВТаблицуДанныхПоИменамКолонок(ПутьКФайлу, ТаблицаДанных, ДанныеДляЗаполнения, АдресХранилища, СтруктураПараметров);
	// } RGS  PMatkov 01.12.2015 16:47:33 - Перенос повторяющегося кода в общий модуль
	
	ЗагрузитьИЗаписатьДвижения(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата, ТаблицаДанных);
	
	ТаблицаНовыеParentClients      = ПолучитьТаблицуНовыеParentClients(СтруктураПараметров.Ссылка);
	ТаблицаНовыеSalesКлиенты       = ПолучитьТаблицуНовыеSalesКлиенты(СтруктураПараметров.Ссылка);
	ТаблицаНовыеBillingКлиенты     = ПолучитьТаблицуНовыеBillingКлиенты(СтруктураПараметров.Ссылка);
	ТаблицаИзмененныеBillingID     = ПолучитьТаблицуИзмененныеBillingID(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата);
	ТаблицаИзмененныеParentClients = ПолучитьТаблицуИзмененныеParentClients(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата);
	ТаблицаИзмененныеРеквизиты     = ПолучитьТаблицуИзмененныеРеквизиты(СтруктураПараметров.Ссылка);
	//ТаблицаОтсутствующиеКлиенты    = ПолучитьТаблицуОтсутствующиеКлиенты(СтруктураПараметров.Ссылка);
	ТаблицаКлиентыДляДективации    = ПолучитьТаблицуКлиентыДляДективации(СтруктураПараметров.Ссылка);
	
	ДанныеДляЗаполнения.Вставить("ТаблицаНовыеParentClients", ТаблицаНовыеParentClients);
	ДанныеДляЗаполнения.Вставить("ТаблицаНовыеSalesКлиенты", ТаблицаНовыеSalesКлиенты);
	ДанныеДляЗаполнения.Вставить("ТаблицаНовыеBillingКлиенты", ТаблицаНовыеBillingКлиенты);
	ДанныеДляЗаполнения.Вставить("ТаблицаИзмененныеBillingID", ТаблицаИзмененныеBillingID);
	ДанныеДляЗаполнения.Вставить("ТаблицаИзмененныеParentClients", ТаблицаИзмененныеParentClients);
	ДанныеДляЗаполнения.Вставить("ТаблицаИзмененныеРеквизиты", ТаблицаИзмененныеРеквизиты);
	ДанныеДляЗаполнения.Вставить("ТаблицаКлиентыДляДективации", ТаблицаКлиентыДляДективации);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля);
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Добавить("СтрокаФайла", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Неотрицательный)));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура ЗагрузитьИЗаписатьДвижения(Ссылка, ДатаДокумента, ТаблицаДанных)
	
	ТаблицаДанных.Колонки.Добавить("ДокументЗагрузки");
	ТаблицаДанных.ЗаполнитьЗначения(Ссылка, "ДокументЗагрузки");
	
	НЗ = РегистрыСведений.CRMAccountsExtractSourceData.СоздатьНаборЗаписей();
	НЗ.Отбор.ДокументЗагрузки.Установить(Ссылка);
	НЗ.Загрузить(ТаблицаДанных);
	НЗ.Записать(Истина);
	
КонецПроцедуры

Функция ПолучитьТаблицуНовыеParentClients(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	CRMAccountsExtractSourceData.CorporateAccount
		|ПОМЕСТИТЬ ВТ_ParentClients
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.CorporateAccount <> """"
		|	И CRMAccountsExtractSourceData.BillingFlag = ""Y""
		//|	И CRMAccountsExtractSourceData.AccountStatus = ""Active""
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.CorporateAccount
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_SalesAccounts.CorporateAccount КАК Description
		|ИЗ
		|	ВТ_ParentClients КАК ВТ_SalesAccounts
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО ВТ_SalesAccounts.CorporateAccount = Контрагенты.Наименование
		|			И (НЕ Контрагенты.ПометкаУдаления)
		|			И (Контрагенты.ParentClient)
		|ГДЕ
		|	Контрагенты.Ссылка ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНовыеParentClients = РезультатЗапроса.Выгрузить();
	ТаблицаНовыеParentClients.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	// { RGS PMatkov 25.12.2015 17:14:28 - 
	ТаблицаНовыеParentClients.ЗаполнитьЗначения(Истина, "Применить");
	// } RGS PMatkov 25.12.2015 17:14:28 - 
	
	
	Возврат ТаблицаНовыеParentClients;
	
КонецФункции

Функция ПолучитьТаблицуНовыеSalesКлиенты(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.AccountId КАК CRMID,
		|	CRMAccountsExtractSourceData.Account КАК Description,
		|	CRMAccountsExtractSourceData.CorporateAccount КАК ParentClientDescription,
		|	ВЫБОР
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Banned""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Banned)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Conditional""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Conditional)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Limited""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Limited)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Unlimited""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Unlimited)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.CreditRating.ПустаяСсылка)
		|	КОНЕЦ КАК CreditRating
		|ПОМЕСТИТЬ ВТ_SalesAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.MIIntegrationId = """"
		|	И CRMAccountsExtractSourceData.SMITHIntegrationId = """"
		|	И CRMAccountsExtractSourceData.LawsonIntegrationId = """"
		|	И CRMAccountsExtractSourceData.AccountStatus = ""Active""
		|	И CRMAccountsExtractSourceData.BillingFlag = ""Y""
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMID
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_SalesAccounts.CRMID,
		|	ВТ_SalesAccounts.Description,
		|	ВТ_SalesAccounts.ParentClientDescription,
		|	ВТ_SalesAccounts.CreditRating
		|ИЗ
		|	ВТ_SalesAccounts КАК ВТ_SalesAccounts
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО ВТ_SalesAccounts.CRMID = Контрагенты.CRMID
		|			И (НЕ Контрагенты.ПометкаУдаления)
		|			И (НЕ Контрагенты.ParentClient)
		|ГДЕ
		|	Контрагенты.Ссылка ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНовыеSalesКлиенты = РезультатЗапроса.Выгрузить();
	ТаблицаНовыеSalesКлиенты.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	// { RGS PMatkov 25.12.2015 17:14:28 - 
	ТаблицаНовыеSalesКлиенты.ЗаполнитьЗначения(Истина, "Применить");
	// } RGS PMatkov 25.12.2015 17:14:28 - 
	
	Возврат ТаблицаНовыеSalesКлиенты;
	
КонецФункции

Функция ПолучитьТаблицуНовыеBillingКлиенты(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.AccountId КАК CRMID,
		|	CRMAccountsExtractSourceData.Account КАК Description,
		|	CRMAccountsExtractSourceData.CorporateAccount КАК ParentClientDescription,
		|	CRMAccountsExtractSourceData.MIIntegrationId КАК MIID,
		|	CRMAccountsExtractSourceData.SMITHIntegrationId КАК SMITHID,
		|	CRMAccountsExtractSourceData.LawsonIntegrationId КАК LawsonID,
		|	ВЫБОР
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Banned""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Banned)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Conditional""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Conditional)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Limited""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Limited)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Unlimited""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Unlimited)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.CreditRating.ПустаяСсылка)
		|	КОНЕЦ КАК CreditRating
		|ПОМЕСТИТЬ ВТ_BillingAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И (CRMAccountsExtractSourceData.MIIntegrationId <> """"
		|			ИЛИ CRMAccountsExtractSourceData.SMITHIntegrationId <> """"
		|			ИЛИ CRMAccountsExtractSourceData.LawsonIntegrationId <> """")
		|	И CRMAccountsExtractSourceData.BillingFlag = ""Y""
		|	И CRMAccountsExtractSourceData.AccountStatus = ""Active""
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.AccountId
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_BillingAccounts.CRMID,
		|	ВТ_BillingAccounts.Description,
		|	ВТ_BillingAccounts.ParentClientDescription,
		|	ВТ_BillingAccounts.MIID,
		|	ВТ_BillingAccounts.SMITHID,
		|	ВТ_BillingAccounts.LawsonID,
		|	ВТ_BillingAccounts.CreditRating
		|ИЗ
		|	ВТ_BillingAccounts КАК ВТ_BillingAccounts
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО ВТ_BillingAccounts.CRMID = Контрагенты.CRMID
		|			И (НЕ Контрагенты.ПометкаУдаления)
		|			И (НЕ Контрагенты.ParentClient)
		|ГДЕ
		|	Контрагенты.Ссылка ЕСТЬ NULL ";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаНовыеBillingКлиенты = РезультатЗапроса.Выгрузить();
	ТаблицаНовыеBillingКлиенты.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	// { RGS PMatkov 25.12.2015 17:14:28 - 
	ТаблицаНовыеBillingКлиенты.ЗаполнитьЗначения(Истина, "Применить");
	// } RGS PMatkov 25.12.2015 17:14:28 - 
	
	Возврат ТаблицаНовыеBillingКлиенты;
	
КонецФункции

Функция ПолучитьТаблицуИзмененныеBillingID(Ссылка, Дата)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.AccountId КАК CRMID,
		|	ВЫБОР
		|		КОГДА CRMAccountsExtractSourceData.LawsonIntegrationId = """"
		|			ТОГДА ""#empty#"" + CRMAccountsExtractSourceData.AccountId
		|		ИНАЧЕ CRMAccountsExtractSourceData.LawsonIntegrationId
		|	КОНЕЦ КАК LawsonID,
		|	ВЫБОР
		|		КОГДА CRMAccountsExtractSourceData.MIIntegrationId = """"
		|			ТОГДА ""#empty#"" + CRMAccountsExtractSourceData.AccountId
		|		ИНАЧЕ CRMAccountsExtractSourceData.MIIntegrationId
		|	КОНЕЦ КАК MIID,
		|	ВЫБОР
		|		КОГДА CRMAccountsExtractSourceData.SMITHIntegrationId = """"
		|			ТОГДА ""#empty#"" + CRMAccountsExtractSourceData.AccountId
		|		ИНАЧЕ CRMAccountsExtractSourceData.SMITHIntegrationId
		|	КОНЕЦ КАК SMITHID,
		|	CRMAccountsExtractSourceData.Account КАК Description
		|ПОМЕСТИТЬ ВТ_BillingAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.BillingFlag = ""Y""
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.AccountId
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_BillingAccounts.CRMID КАК Идентификатор,
		|	Контрагенты.Ссылка КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыCRM
		|ИЗ
		|	ВТ_BillingAccounts КАК ВТ_BillingAccounts
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО ВТ_BillingAccounts.CRMID = Контрагенты.CRMID
		|			И (НЕ Контрагенты.ПометкаУдаления)
		|			И (НЕ Контрагенты.ParentClient)
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыLawson
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период <= &Период
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
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
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыMI
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период <= &Период
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыMI
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыMI КАК ВТ_ПоследниеДатыMI
		|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыMI.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыMI.ОбъектПриемника
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI))
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период) КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ПоследниеДатыSMITH
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период <= &Период
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_ИдентификаторыSmith
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ПоследниеДатыSMITH КАК ВТ_ПоследниеДатыSMITH
		|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ПоследниеДатыSMITH.Период
		|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ПоследниеДатыSMITH.ОбъектПриемника
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith))
		|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ОбъектПриемника
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_BillingAccounts.CRMID,
		|	ВТ_ИдентификаторыLawson.Идентификатор КАК OldLawsonID,
		|	ВТ_BillingAccounts.LawsonID КАК NewLawsonID,
		|	ВТ_ИдентификаторыMI.Идентификатор КАК OldMIID,
		|	ВТ_BillingAccounts.MIID КАК NewMIID,
		|	ВТ_ИдентификаторыSmith.Идентификатор КАК OldSmithID,
		|	ВТ_BillingAccounts.SMITHID КАК NewSmithID,
		|	ВТ_BillingAccounts.Description,
		|	ВТ_ИдентификаторыCRM.ОбъектПриемника КАК Client
		|ИЗ
		|	ВТ_BillingAccounts КАК ВТ_BillingAccounts
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыCRM КАК ВТ_ИдентификаторыCRM
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыLawson КАК ВТ_ИдентификаторыLawson
		|			ПО ВТ_ИдентификаторыCRM.ОбъектПриемника = ВТ_ИдентификаторыLawson.ОбъектПриемника
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыMI КАК ВТ_ИдентификаторыMI
		|			ПО ВТ_ИдентификаторыCRM.ОбъектПриемника = ВТ_ИдентификаторыMI.ОбъектПриемника
		|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыSmith КАК ВТ_ИдентификаторыSmith
		|			ПО ВТ_ИдентификаторыCRM.ОбъектПриемника = ВТ_ИдентификаторыSmith.ОбъектПриемника
		|		ПО ВТ_BillingAccounts.CRMID = ВТ_ИдентификаторыCRM.Идентификатор
		|ГДЕ
		|	(ЕСТЬNULL(ВТ_ИдентификаторыLawson.Идентификатор, """") <> ВТ_BillingAccounts.LawsonID
		|			ИЛИ ЕСТЬNULL(ВТ_ИдентификаторыMI.Идентификатор, """") <> ВТ_BillingAccounts.MIID
		|			ИЛИ ЕСТЬNULL(ВТ_ИдентификаторыSmith.Идентификатор, """") <> ВТ_BillingAccounts.SMITHID)";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаИзмененныеBillingID = РезультатЗапроса.Выгрузить();
	ТаблицаИзмененныеBillingID.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	// { RGS PMatkov 25.12.2015 17:14:28 - 
	ТаблицаИзмененныеBillingID.ЗаполнитьЗначения(Истина, "Применить");
	// } RGS PMatkov 25.12.2015 17:14:28 - 
	
	Возврат ТаблицаИзмененныеBillingID;
	
КонецФункции

Функция ПолучитьТаблицуИзмененныеParentClients(Ссылка, Дата)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.AccountId КАК CRMID,
		|	CRMAccountsExtractSourceData.Account КАК Description,
		|	CRMAccountsExtractSourceData.CorporateAccount КАК ParentClientDescription,
		|	Контрагенты.Ссылка КАК Client,
		|	ЕСТЬNULL(Контрагенты1.Ссылка, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК NewParentClient
		|ПОМЕСТИТЬ ВТ_SalesAccounts
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО CRMAccountsExtractSourceData.AccountId = Контрагенты.CRMID
		|			И (НЕ Контрагенты.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты1
		|		ПО CRMAccountsExtractSourceData.CorporateAccount = Контрагенты1.Наименование
		|			И (НЕ Контрагенты1.ПометкаУдаления)
		|			И (Контрагенты1.ParentClient)
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И CRMAccountsExtractSourceData.BillingFlag = ""Y""
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	CRMAccountsExtractSourceData.AccountId
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_SalesAccounts.CRMID,
		|	ВТ_SalesAccounts.Description,
		|	ВТ_SalesAccounts.Client,
		|	ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент КАК OldParentClient,
		|	ВТ_SalesAccounts.NewParentClient,
		|	ВТ_SalesAccounts.ParentClientDescription КАК NewParentClientDescription
		|ИЗ
		|	ВТ_SalesAccounts КАК ВТ_SalesAccounts
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияКонтрагентов.СрезПоследних(
		|				&Период,
		|				Контрагент В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_SalesAccounts.Client
		|					ИЗ
		|						ВТ_SalesAccounts КАК ВТ_SalesAccounts)) КАК ИерархияКонтрагентовСрезПоследних
		|		ПО ВТ_SalesAccounts.Client = ИерархияКонтрагентовСрезПоследних.Контрагент
		|ГДЕ
		|	ЕСТЬNULL(ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) <> ВТ_SalesAccounts.NewParentClient";

	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("Период", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаИзмененныеParentClients = РезультатЗапроса.Выгрузить();
	ТаблицаИзмененныеParentClients.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	// { RGS PMatkov 25.12.2015 17:14:28 - 
	ТаблицаИзмененныеParentClients.ЗаполнитьЗначения(Истина, "Применить");
	// } RGS PMatkov 25.12.2015 17:14:28 - 
	
	Возврат ТаблицаИзмененныеParentClients;
	
КонецФункции

Функция ПолучитьТаблицуИзмененныеРеквизиты(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	CRMAccountsExtractSourceData.AccountId КАК CRMID,
		|	CRMAccountsExtractSourceData.Account КАК NewDescription,
		|	Контрагенты.Ссылка КАК Client,
		|	ВЫБОР
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Banned""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Banned)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Conditional""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Conditional)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Limited""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Limited)
		|		КОГДА CRMAccountsExtractSourceData.CreditRating = ""Unlimited""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Unlimited)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.CreditRating.ПустаяСсылка)
		|	КОНЕЦ КАК NewCreditRating,
		|	Контрагенты.CreditRating КАК OldCreditRating,
		|	Контрагенты.Наименование КАК OldDescription,
		|	CRMAccountsExtractSourceData.Country КАК NewCountry,
		|	CRMAccountsExtractSourceData.City КАК NewCity,
		|	CRMAccountsExtractSourceData.StreetAddress КАК NewStreetAddress,
		|	Контрагенты.crmCountry КАК OldCountry,
		|	Контрагенты.crmCity КАК OldCity,
		|	Контрагенты.crmStreetAddress КАК OldStreetAddress,
		|	CRMAccountsExtractSourceData.PostalCode КАК NewPostalCode,
		|	Контрагенты.crmPostalCode КАК OldPostalCode
		|ИЗ
		|	РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Контрагенты КАК Контрагенты
		|		ПО CRMAccountsExtractSourceData.AccountId = Контрагенты.CRMID
		|			И (НЕ Контрагенты.ПометкаУдаления)
		|			И (НЕ Контрагенты.ParentClient)
		|ГДЕ
		|	CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка
		|	И (CRMAccountsExtractSourceData.Account <> Контрагенты.Наименование
		|			ИЛИ ВЫБОР
		|				КОГДА CRMAccountsExtractSourceData.CreditRating = ""Banned""
		|					ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Banned)
		|				КОГДА CRMAccountsExtractSourceData.CreditRating = ""Conditional""
		|					ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Conditional)
		|				КОГДА CRMAccountsExtractSourceData.CreditRating = ""Limited""
		|					ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Limited)
		|				КОГДА CRMAccountsExtractSourceData.CreditRating = ""Unlimited""
		|					ТОГДА ЗНАЧЕНИЕ(Перечисление.CreditRating.Unlimited)
		|				ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.CreditRating.ПустаяСсылка)
		|			КОНЕЦ <> Контрагенты.CreditRating
		|			ИЛИ CRMAccountsExtractSourceData.Country <> Контрагенты.crmCountry
		|			ИЛИ CRMAccountsExtractSourceData.City <> Контрагенты.crmCity
		|			ИЛИ Контрагенты.crmStreetAddress <> CRMAccountsExtractSourceData.StreetAddress
		|			ИЛИ CRMAccountsExtractSourceData.PostalCode <> Контрагенты.crmPostalCode)";

	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаИзмененныеРеквизиты = РезультатЗапроса.Выгрузить();
	ТаблицаИзмененныеРеквизиты.Колонки.Добавить("Применить", Новый ОписаниеТипов("Булево"));
	ТаблицаИзмененныеРеквизиты.ЗаполнитьЗначения(Истина, "Применить");
	
	Возврат ТаблицаИзмененныеРеквизиты;
	
КонецФункции

Функция ПолучитьТаблицуОтсутствующиеКлиенты(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Client
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|		ПО Контрагенты.CRMID = CRMAccountsExtractSourceData.AccountId
		|			И (CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceDataParentClient
		|		ПО Контрагенты.CRMID = CRMAccountsExtractSourceDataParentClient.CorporateAccountId
		|			И (CRMAccountsExtractSourceDataParentClient.ДокументЗагрузки = &Ссылка)
		|ГДЕ
		|	CRMAccountsExtractSourceData.СтрокаФайла ЕСТЬ NULL 
		|	И НЕ Контрагенты.ПометкаУдаления
		|	И CRMAccountsExtractSourceDataParentClient.СтрокаФайла ЕСТЬ NULL";

	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаОтсутствующиеКлиенты = РезультатЗапроса.Выгрузить();
	
	Возврат ТаблицаОтсутствующиеКлиенты;
	
КонецФункции

Функция ПолучитьТаблицуКлиентыДляДективации(Ссылка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Client
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.CRMAccountsExtractSourceData КАК CRMAccountsExtractSourceData
		|		ПО Контрагенты.CRMID = CRMAccountsExtractSourceData.AccountId
		|			И (CRMAccountsExtractSourceData.ДокументЗагрузки = &Ссылка)
		|			И (НЕ Контрагенты.ПометкаУдаления)
		|			И (CRMAccountsExtractSourceData.AccountStatus = ""Inactive"")
		|			И (Контрагенты.СостояниеАктивности <> ЗНАЧЕНИЕ(Перечисление.СостоянияАктивностиКонтрагентов.Неактивен))";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаОтсутствующиеКлиенты = РезультатЗапроса.Выгрузить();
	
	Возврат ТаблицаОтсутствующиеКлиенты;
	
КонецФункции

#КонецЕсли