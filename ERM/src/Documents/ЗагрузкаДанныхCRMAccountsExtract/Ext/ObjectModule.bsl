﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	НЗ_ParentClients = РегистрыСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СоздатьНаборЗаписей();
	НЗ_ParentClients.Отбор.ТипСоответствия.Установить(Перечисления.ТипыСоответствий.ParentClients);
	НЗ_ParentClients.Отбор.ТипОбъектаВнешнейСистемы.Установить(Перечисления.ТипыОбъектовВнешнихСистем.Client);
	
	НЗ_SalesClients = РегистрыСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СоздатьНаборЗаписей();
	НЗ_SalesClients.Отбор.ТипСоответствия.Установить(Перечисления.ТипыСоответствий.CRM);
	НЗ_SalesClients.Отбор.ТипОбъектаВнешнейСистемы.Установить(Перечисления.ТипыОбъектовВнешнихСистем.Client);
	
	НЗ_BillingClients = РегистрыСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СоздатьНаборЗаписей();
	НЗ_BillingClients.Отбор.ТипСоответствия.Установить(Перечисления.ТипыСоответствий.Lawson);
	НЗ_BillingClients.Отбор.ТипОбъектаВнешнейСистемы.Установить(Перечисления.ТипыОбъектовВнешнихСистем.Client);
	
	НЗ_ИерархияКонтрагентов = РегистрыСведений.ИерархияКонтрагентов.СоздатьНаборЗаписей();
	
	// новые parent clients
	Для каждого ТекСтрокаТЧ Из НовыеParentClients Цикл
		
		Если Не ТекСтрокаТЧ.Применить Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйКонтагент = Справочники.Контрагенты.СоздатьЭлемент();
		НовыйКонтагент.Наименование = ТекСтрокаТЧ.Description;
		НовыйКонтагент.Записать();
		
		НЗ_ParentClients.Отбор.Идентификатор.Установить(ТекСтрокаТЧ.Description);
		НЗ_ParentClients.Очистить();
		НоваяЗапись = НЗ_ParentClients.Добавить();
		НоваяЗапись.Период = Дата;
		НоваяЗапись.ТипСоответствия = Перечисления.ТипыСоответствий.ParentClients;
		НоваяЗапись.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Client;
		НоваяЗапись.Идентификатор = ТекСтрокаТЧ.Description;
		НоваяЗапись.ОбъектПриемника = НовыйКонтагент.Ссылка;
		НЗ_ParentClients.Записать(Истина);
		
	КонецЦикла;
	
	// новые Sales клиенты
	ГоловныеКонтрагенты = ПолучитьГоловныхКонтрагентов(Дата, НовыеSalesКлиенты.ВыгрузитьКолонку("ParentClient"));
	
	Для каждого ТекСтрокаТЧ Из НовыеSalesКлиенты Цикл
		
		Если Не ТекСтрокаТЧ.Применить Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйКонтагент = Справочники.Контрагенты.СоздатьЭлемент();
		НовыйКонтагент.Наименование = ТекСтрокаТЧ.Description;
		НовыйКонтагент.Записать();
		
		НЗ_SalesClients.Отбор.Идентификатор.Установить(ТекСтрокаТЧ.CRMID);
		НЗ_SalesClients.Очистить();
		НоваяЗапись = НЗ_SalesClients.Добавить();
		НоваяЗапись.Период = Дата;
		НоваяЗапись.ТипСоответствия = Перечисления.ТипыСоответствий.CRM;
		НоваяЗапись.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Client;
		НоваяЗапись.Идентификатор = ТекСтрокаТЧ.CRMID;
		НоваяЗапись.ОбъектПриемника = НовыйКонтагент.Ссылка;
		НЗ_SalesClients.Записать(Истина);
		
		НЗ_ИерархияКонтрагентов.Отбор.Контрагент.Установить(НовыйКонтагент.Ссылка);
		НЗ_ИерархияКонтрагентов.Очистить();
		НоваяЗапись = НЗ_ИерархияКонтрагентов.Добавить();
		НоваяЗапись.Период = Дата;
		НоваяЗапись.Контрагент = НовыйКонтагент.Ссылка;
		ГоловнойКонтрагент = ГоловныеКонтрагенты[ТекСтрокаТЧ.ParentClient];
		Если ГоловнойКонтрагент = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Failed to find parent client by description '" + ТекСтрокаТЧ.ParentClient + "'",,,,Отказ);
		КонецЕсли;
		НоваяЗапись.ГоловнойКонтрагент = ГоловнойКонтрагент;
		НЗ_ИерархияКонтрагентов.Записать(Истина);
		
	КонецЦикла;
	
	// новые Billing клиенты
	ГоловныеКонтрагенты = ПолучитьГоловныхКонтрагентов(Дата, НовыеBillingКлиенты.ВыгрузитьКолонку("ParentClient"));
	
	Для каждого ТекСтрокаТЧ Из НовыеBillingКлиенты Цикл
		
		Если Не ТекСтрокаТЧ.Применить Тогда
			Продолжить;
		КонецЕсли;
		
		НовыйКонтагент = Справочники.Контрагенты.СоздатьЭлемент();
		НовыйКонтагент.Наименование = ТекСтрокаТЧ.Description;
		НовыйКонтагент.Записать();
		
		НЗ_SalesClients.Отбор.Идентификатор.Установить(ТекСтрокаТЧ.CRMID);
		НЗ_SalesClients.Очистить();
		НоваяЗапись = НЗ_SalesClients.Добавить();
		НоваяЗапись.Период = Дата;
		НоваяЗапись.ТипСоответствия = Перечисления.ТипыСоответствий.CRM;
		НоваяЗапись.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Client;
		НоваяЗапись.Идентификатор = ТекСтрокаТЧ.CRMID;
		НоваяЗапись.ОбъектПриемника = НовыйКонтагент.Ссылка;
		НЗ_SalesClients.Записать(Истина);
		
		НЗ_BillingClients.Отбор.Идентификатор.Установить(ТекСтрокаТЧ.BillingID);
		НЗ_BillingClients.Очистить();
		НоваяЗапись = НЗ_BillingClients.Добавить();
		НоваяЗапись.Период = Дата;
		НоваяЗапись.ТипСоответствия = Перечисления.ТипыСоответствий.Lawson;
		НоваяЗапись.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Client;
		НоваяЗапись.Идентификатор = ТекСтрокаТЧ.BillingID;
		НоваяЗапись.ОбъектПриемника = НовыйКонтагент.Ссылка;
		НЗ_BillingClients.Записать(Истина);
		
		НЗ_ИерархияКонтрагентов.Отбор.Контрагент.Установить(НовыйКонтагент.Ссылка);
		НЗ_ИерархияКонтрагентов.Очистить();
		НоваяЗапись = НЗ_ИерархияКонтрагентов.Добавить();
		НоваяЗапись.Период = Дата;
		НоваяЗапись.Контрагент = НовыйКонтагент.Ссылка;
		ГоловнойКонтрагент = ГоловныеКонтрагенты[ТекСтрокаТЧ.ParentClient];
		Если ГоловнойКонтрагент = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Failed to find parent client by description '" + ТекСтрокаТЧ.ParentClient + "'",,,,Отказ);
		КонецЕсли;
		НоваяЗапись.ГоловнойКонтрагент = ГоловнойКонтрагент;
		НЗ_ИерархияКонтрагентов.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьГоловныхКонтрагентов(Период, МассивИдентификаторов)
	
	Результат = Новый Соответствие;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			&Период,
		|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ParentClients)
		|				И Идентификатор В (&МассивИдентификаторов)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних";
	
	Запрос.УстановитьПараметр("МассивИдентификаторов", МассивИдентификаторов);
	Запрос.УстановитьПараметр("Период", Период);
	
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Результат.Вставить(Выборка.Идентификатор, Выборка.ОбъектПриемника);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
