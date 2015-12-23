﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТаблицаДанных = СтруктураПараметров.ТаблицаДанных;
	ТекстОшибки = "";
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
	ФайлЭксель = СтруктураПараметров.ИсточникДанных.Получить();
	ФайлЭксель.Записать(ПутьКФайлу);
	
	// { RGS  PMatkov 01.12.2015 16:47:17 - Перенос повторяющегося кода в общий модуль
	rgsЗагрузкаИзExcel.ВыгрузитьЭксельВТаблицуДанных(ПутьКФайлу, ТаблицаДанных, ДанныеДляЗаполнения, АдресХранилища, СтруктураПараметров);
	// } RGS  PMatkov 01.12.2015 16:47:33 - Перенос повторяющегося кода в общий модуль
	
	ЗагрузитьИЗаписатьДвижения(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата, ТаблицаДанных);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Процедура ЗагрузитьИЗаписатьДвижения(Ссылка, ДатаДокумента, ТаблицаДанных)
	
	ТаблицаДанных.Колонки.Добавить("ДокументЗагрузки");
	ТаблицаДанных.ЗаполнитьЗначения(Ссылка, "ДокументЗагрузки");
	
	НЗ = РегистрыСведений.RevenueSourceData.СоздатьНаборЗаписей();
	
	// { RGS PMatkov 22.12.2015 19:06:20 - 
	Нз.Отбор.ДокументЗагрузки.Установить(Ссылка);
	// } RGS PMatkov 22.12.2015 19:06:21 - 
	
	НЗ.Загрузить(ТаблицаДанных);
	
	// { RGS PMatkov 22.12.2015 18:37:39 - 
	//НЗ.Записать(Истина);
	НЗ.Записать(Ложь);
	// } RGS PMatkov 22.12.2015 18:37:40 - 
	
	
КонецПроцедуры

Процедура ВыполнитьПроверкуНастроекСинхронизации(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛОЖЬ КАК КоллизияОтработана,
		|	""Specify the 1C object"" КАК Описание,
		|	&ТипВнешнейСистемы КАК ТипСоответствия,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment) КАК ТипОбъектаВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Справочник.Сегменты.ПустаяСсылка) КАК ОбъектПриемника,
		|	RevenueSourceData.Segment КАК Идентификатор
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment)) КАК НастройкаСинхронизацииSegment
		|		ПО RevenueSourceData.Segment = НастройкаСинхронизацииSegment.Идентификатор
		|			И (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|ГДЕ
		|	НастройкаСинхронизацииSegment.ОбъектПриемника ЕСТЬ NULL 
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		|	И не RevenueSourceData.SubSegment = """"
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		// } RGS PMatkov 22.12.2015 17:33:36 - 

		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	""Specify the 1C object"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment),
		|	ЗНАЧЕНИЕ(Справочник.Сегменты.ПустаяСсылка),
		|	RevenueSourceData.SubSegment
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment)) КАК НастройкаСинхронизацииSubSegment
		|		ПО (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И RevenueSourceData.SubSegment = НастройкаСинхронизацииSubSegment.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииSubSegment.ОбъектПриемника ЕСТЬ NULL 
		|	И &ТипВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		|	И не RevenueSourceData.SubSegment  = """"
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		// } RGS PMatkov 22.12.2015 17:33:36 - 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	""Specify the 1C object"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment),
		|	ЗНАЧЕНИЕ(Справочник.Сегменты.ПустаяСсылка),
		|	RevenueSourceData.SubSubSegment
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment)) КАК НастройкаСинхронизацииSubSubSegment
		|		ПО (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И RevenueSourceData.SubSubSegment = НастройкаСинхронизацииSubSubSegment.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииSubSubSegment.ОбъектПриемника ЕСТЬ NULL 
		|	И &ТипВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		|	И не RevenueSourceData.SubSubSegment  = """" 
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		// } RGS PMatkov 22.12.2015 17:33:36 - 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	""Specify the 1C object"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Geomarket),
		|	ЗНАЧЕНИЕ(Справочник.Geomarkets.ПустаяСсылка),
		|	RevenueSourceData.Geomarket
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Geomarket)) КАК НастройкаСинхронизацииGeomarket
		|		ПО (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И RevenueSourceData.Geomarket = НастройкаСинхронизацииGeomarket.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииGeomarket.ОбъектПриемника ЕСТЬ NULL
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		|	И не RevenueSourceData.Geomarket = """"
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		// } RGS PMatkov 22.12.2015 17:33:36 - 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	""Specify the 1C object"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Geomarket),
		|	ЗНАЧЕНИЕ(Справочник.Geomarkets.ПустаяСсылка),
		|	RevenueSourceData.SubGeomarket
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Geomarket)) КАК НастройкаСинхронизацииSubGeomarket
		|		ПО (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И RevenueSourceData.SubGeomarket = НастройкаСинхронизацииSubGeomarket.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииSubGeomarket.ОбъектПриемника ЕСТЬ NULL
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		|	И не RevenueSourceData.SubGeomarket = """"
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		// } RGS PMatkov 22.12.2015 17:33:36 - 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	""Specify the 1C object"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency),
		|	ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка),
		|	RevenueSourceData.Currency
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)) КАК НастройкаСинхронизацииCurrency
		|		ПО (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И RevenueSourceData.Currency = НастройкаСинхронизацииCurrency.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииCurrency.ОбъектПриемника ЕСТЬ NULL
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		|	И не RevenueSourceData.Currency  = """"
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		// } RGS PMatkov 22.12.2015 17:33:36 - 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	""Specify the 1C object"",
		|	&ТипВнешнейСистемы,
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client),
		|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),
		|	RevenueSourceData.CustomerCode
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = &ТипВнешнейСистемы
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)) КАК НастройкаСинхронизацииClients
		|		ПО (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И RevenueSourceData.CustomerCode = НастройкаСинхронизацииClients.Идентификатор
		|ГДЕ 
		|	&ТипВнешнейСистемы <> ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		//|	НастройкаСинхронизацииClients.ОбъектПриемника ЕСТЬ NULL
		|	И ВЫБОР
		|	КОГДА &ТипВнешнейСистемы <> ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|		ТОГДА НастройкаСинхронизацииClients.ОбъектПриемника ЕСТЬ NULL 
		|	КОНЕЦ
		|	И не RevenueSourceData.CustomerCode = """"
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		// } RGS PMatkov 22.12.2015 17:33:36 - 
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ
		|	ЛОЖЬ,
		|	""Specify the 1C object"",
		|	ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ParentClients),
		|	ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client),
		|	ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка),
		|	RevenueSourceData.CorporateAccount
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|				&Период,
		|				ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ParentClients)
		|					И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)) КАК НастройкаСинхронизацииParentClients
		|		ПО (RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки)
		|			И RevenueSourceData.CorporateAccount = НастройкаСинхронизацииParentClients.Идентификатор
		|ГДЕ
		|	НастройкаСинхронизацииParentClients.ОбъектПриемника ЕСТЬ NULL
		// { RGS PMatkov 22.12.2015 17:33:35 - 
		//|	И &ТипВнешнейСистемы <> ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)";
		|	И &ТипВнешнейСистемы <> ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
		|	И не RevenueSourceData.CorporateAccount  = """"
		|	И RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки";
		// } RGS PMatkov 22.12.2015 17:33:36 - 
	
	Запрос.УстановитьПараметр("ДокументЗагрузки", СтруктураПараметров.Ссылка);
	Запрос.УстановитьПараметр("Период", СтруктураПараметров.Дата);
	Запрос.УстановитьПараметр("ТипВнешнейСистемы", СтруктураПараметров.ТипВнешнейСистемы);
	РезультатЗапроса = Запрос.Выполнить();
	
	ДанныеДляЗаполнения.Вставить("ТаблицаКоллизий", РезультатЗапроса.Выгрузить());
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция ПолучитьТаблицуRevenueLines(ЗагрузкаДанныхRevenue) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтрокиRevenue.Ссылка,
	|	СтрокиRevenue.Segment,
	|	СтрокиRevenue.SubSegment,
	|	СтрокиRevenue.SubSubSegment,
	|	СтрокиRevenue.Geomarket,
	|	СтрокиRevenue.SubGeomarket,
	|	СтрокиRevenue.ParentClient,
	|	СтрокиRevenue.Client,
	|	СтрокиRevenue.AccountingUnit,
	|	СтрокиRevenue.Currency,
	|	СтрокиRevenue.ContractName,
	|	СтрокиRevenue.ClientContract,
	|	СтрокиRevenue.AmountUSD,
	|	СтрокиRevenue.ЗагрузкаДанных,
	|	СтрокиRevenue.НомерСтрокиRevenue,
	|	СтрокиRevenue.НомерСтрокиФайла
	|ИЗ
	|	Справочник.СтрокиRevenue КАК СтрокиRevenue
	|ГДЕ
	|	СтрокиRevenue.ЗагрузкаДанных = &ЗагрузкаДанных
	|	И НЕ СтрокиRevenue.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	СтрокиRevenue.НомерСтрокиRevenue";
	
	Запрос.УстановитьПараметр("ЗагрузкаДанных", ЗагрузкаДанныхRevenue);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ДополнитьТаблицуСтрокRevenueДаннымиФайла(ТаблицаСтрокRevenue) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтрокиRevenue.Ссылка,
	|	СтрокиRevenue.Segment,
	|	СтрокиRevenue.SubSegment,
	|	СтрокиRevenue.SubSubSegment,
	|	СтрокиRevenue.Geomarket,
	|	СтрокиRevenue.SubGeomarket,
	|	СтрокиRevenue.ParentClient,
	|	СтрокиRevenue.Client,
	//|	СтрокиRevenue.AccountingUnit,
	|	СтрокиRevenue.Currency,
	|	СтрокиRevenue.ContractName,
	|	СтрокиRevenue.ClientContract,
	|	СтрокиRevenue.AmountUSD,
	|	СтрокиRevenue.ЗагрузкаДанных КАК ЗагрузкаДанных,
	|	СтрокиRevenue.НомерСтрокиRevenue,
	|	СтрокиRevenue.НомерСтрокиФайла КАК НомерСтрокиФайла
	|ПОМЕСТИТЬ ВТ_СтрокиRevenue
	|ИЗ
	|	&ТаблицаСтрокRevenue КАК СтрокиRevenue
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	ЗагрузкаДанных,
	|	НомерСтрокиФайла
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_СтрокиRevenue.Ссылка,
	|	ВТ_СтрокиRevenue.Segment,
	|	ВТ_СтрокиRevenue.SubSegment,
	|	ВТ_СтрокиRevenue.SubSubSegment,
	|	ВТ_СтрокиRevenue.Geomarket,
	|	ВТ_СтрокиRevenue.SubGeomarket,
	|	ВТ_СтрокиRevenue.ParentClient,
	|	ВТ_СтрокиRevenue.Client,
	//|	ВТ_СтрокиRevenue.AccountingUnit,
	|	ВТ_СтрокиRevenue.Currency,
	|	ВТ_СтрокиRevenue.ContractName,
	|	ВТ_СтрокиRevenue.ClientContract,
	|	ВТ_СтрокиRevenue.AmountUSD,
	|	ВТ_СтрокиRevenue.ЗагрузкаДанных,
	|	ВТ_СтрокиRevenue.НомерСтрокиRevenue,
	|	ВТ_СтрокиRevenue.НомерСтрокиФайла,
	|	RevenueSourceData.CustomerCode КАК BillingID,
	|	RevenueSourceData.CorporateAccount КАК ParentClientID
	|ИЗ
	|	ВТ_СтрокиRevenue КАК ВТ_СтрокиRevenue
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.RevenueSourceData КАК RevenueSourceData
	|		ПО ВТ_СтрокиRevenue.ЗагрузкаДанных = RevenueSourceData.ДокументЗагрузки
	|			И ВТ_СтрокиRevenue.НомерСтрокиФайла = RevenueSourceData.СтрокаФайла";
	
	Запрос.УстановитьПараметр("ТаблицаСтрокRevenue", ТаблицаСтрокRevenue);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#КонецЕсли