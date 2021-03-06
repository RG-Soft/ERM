
Функция ПолучитьТекстЗапросаОпределениеBU() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	0 КАК Приоритет,
	|	BUMapping.BU КАК BU
	|ИЗ
	|	РегистрСведений.BUMapping КАК BUMapping
	|ГДЕ
	|	ЛОЖЬ
	| 
	|//Объединить 
	|";
	
	ШаблонЧастьЗапросаОбъединить = 
	"ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	//Приоритет,
	|	BUMapping.BU КАК BU
	|ИЗ
	|	РегистрСведений.BUMapping КАК BUMapping
	|ГДЕ ИСТИНА
	|//GeoMarket_Истина     И BUMapping.GeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
	|//GeoMarket_Ложь       И BUMapping.GeoMarket = &GeoMarket
	|//SubGeoMarket_Истина  И BUMapping.SubGeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
	|//SubGeoMarket_Ложь    И BUMapping.SubGeoMarket = &SubGeoMarket
	|//MgmtGeomarket_Истина И BUMapping.MgmtGeomarket = ЗНАЧЕНИЕ(Справочник.ManagementGeography.ПустаяСсылка)
	|//MgmtGeomarket_Ложь   И BUMapping.MgmtGeomarket = &MgmtGeomarket
	|//Segment_Истина       И BUMapping.Segment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
	|//Segment_Ложь         И BUMapping.Segment = &Segment
	|//SubSegment_Истина    И BUMapping.SubSegment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
	|//SubSegment_Ложь      И BUMapping.SubSegment = &SubSegment
	|//Company_Истина       И BUMapping.Company = ЗНАЧЕНИЕ(Справочник.HFM_Companies.ПустаяСсылка)
	|//Company_Ложь         И BUMapping.Company = &Company
	|//AU_Истина            И BUMapping.AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка)
	|//AU_Ложь              И BUMapping.AU = &AU
	|
	|//Объединить 
	|";
	
	ПоляУсловий = Новый Массив;
	ПоляУсловий.Добавить("GeoMarket");
	ПоляУсловий.Добавить("SubGeoMarket");
	ПоляУсловий.Добавить("MgmtGeomarket");
	ПоляУсловий.Добавить("Segment");
	ПоляУсловий.Добавить("SubSegment");
	ПоляУсловий.Добавить("Company");
	ПоляУсловий.Добавить("AU");
	
	Приоритеты = Новый Соответствие;
	Приоритеты.Вставить("GeoMarket", 64);
	Приоритеты.Вставить("SubGeoMarket", 32);
	Приоритеты.Вставить("MgmtGeomarket", 16);
	Приоритеты.Вставить("Segment", 8);
	Приоритеты.Вставить("SubSegment", 4);
	Приоритеты.Вставить("Company", 2);
	Приоритеты.Вставить("AU", 1);
	
	КоличествоПолей = ПоляУсловий.Количество();
	
	Для Комбинация = 0 По Pow(2, КоличествоПолей) - 1 Цикл
		
		ЧастьЗапроса = ШаблонЧастьЗапросаОбъединить;
		
		ТекПриоритет = 0;
		
		ЗначенияПолей = РазложитьПоСтепенямДвойки(Комбинация, КоличествоПолей);
		Для НомерПоля = 0 По КоличествоПолей - 1 Цикл
			ИмяПоля = ПоляУсловий[НомерПоля];
			Если ЗначенияПолей[НомерПоля] Тогда
				ЧастьЗапроса = СтрЗаменить(ЧастьЗапроса, "//" + ИмяПоля + "_Истина", "");
			Иначе
				ЧастьЗапроса = СтрЗаменить(ЧастьЗапроса, "//" + ИмяПоля + "_Ложь",   "");
				ТекПриоритет = ТекПриоритет + Приоритеты[ИмяПоля];
			КонецЕсли;
		КонецЦикла; // НомерПоля
		
		ЧастьЗапроса  = СтрЗаменить(ЧастьЗапроса, "//Приоритет", ТекПриоритет);
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//Объединить", ЧастьЗапроса);
		
	КонецЦикла; // Комбинация
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВложенныйЗапрос.BU
	|ИЗ
	|	(" + СокрЛП(ТекстЗапроса) + "
	|) КАК ВложенныйЗапрос
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Приоритет УБЫВ";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция РазложитьПоСтепенямДвойки(Знач Число, Размер)
	
	Результат = Новый Массив(Размер);
	
	Для НомерПоля = 1 По Размер Цикл
		
		// Обходим с конца
		Индекс     = Размер - НомерПоля;
		Множитель  = Pow(2, Индекс);
		
		Результат[Индекс] = (Число >= Множитель);
		
		Число = Число % Множитель;
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

Функция ОпределитьBU(GeoMarket = Неопределено, SubGeoMarket = Неопределено, MgmtGeomarket = Неопределено, Segment = Неопределено, SubSegment = Неопределено, Company = Неопределено, AU = Неопределено) Экспорт
	
	ТекстЗапроса = rgsКонсолидацияДанныхСерверПовтИсп.ПолучитьТекстЗапросаОпределениеBU();
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("GeoMarket", GeoMarket);
	Запрос.УстановитьПараметр("SubGeoMarket", SubGeoMarket);
	Запрос.УстановитьПараметр("MgmtGeomarket", MgmtGeomarket);
	Запрос.УстановитьПараметр("Segment", Segment);
	Запрос.УстановитьПараметр("SubSegment", SubSegment);
	Запрос.УстановитьПараметр("Company", Company);
	Запрос.УстановитьПараметр("AU", AU);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.BusinessUnits.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.BU;
	
КонецФункции

Функция ПолучитьТекстЗапросаОпределениеМетодаРасчетаБиллинга() Экспорт
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	0 КАК Приоритет,
	|	НастройкиРасчетаБиллинга.Method КАК Method
	|ИЗ
	|	РегистрСведений.НастройкиРасчетаБиллинга КАК НастройкиРасчетаБиллинга
	|ГДЕ
	|	ЛОЖЬ
	| 
	|//Объединить 
	|";
	
	ШаблонЧастьЗапросаОбъединить = 
	"ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	//Приоритет,
	|	НастройкиРасчетаБиллинга.Method КАК Method
	|ИЗ
	|	РегистрСведений.НастройкиРасчетаБиллинга.СрезПоследних(&Период) КАК НастройкиРасчетаБиллинга
	|ГДЕ
	|	ИСТИНА
	|//Source_Истина        И НастройкиРасчетаБиллинга.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ПустаяСсылка)
	|//Source_Ложь          И НастройкиРасчетаБиллинга.Source = &Source
	|//GeoMarket_Истина     И НастройкиРасчетаБиллинга.GeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
	|//GeoMarket_Ложь       И НастройкиРасчетаБиллинга.GeoMarket = &GeoMarket
	|//ManagementGeomarket_Истина     И НастройкиРасчетаБиллинга.ManagementGeomarket = ЗНАЧЕНИЕ(Справочник.ManagementGeography.ПустаяСсылка)
	|//ManagementGeomarket_Ложь       И НастройкиРасчетаБиллинга.ManagementGeomarket = &ManagementGeomarket
	|//Segment_Истина       И НастройкиРасчетаБиллинга.Segment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
	|//Segment_Ложь         И НастройкиРасчетаБиллинга.Segment = &Segment
	|//SubSegment_Истина    И НастройкиРасчетаБиллинга.SubSegment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
	|//SubSegment_Ложь      И НастройкиРасчетаБиллинга.SubSegment = &SubSegment
	|//SubSubSegment_Истина И НастройкиРасчетаБиллинга.SubSubSegment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
	|//SubSubSegment_Ложь   И НастройкиРасчетаБиллинга.SubSubSegment = &SubSubSegment
	|//Company_Истина       И НастройкиРасчетаБиллинга.Company = ЗНАЧЕНИЕ(Справочник.HFM_Companies.ПустаяСсылка)
	|//Company_Ложь         И НастройкиРасчетаБиллинга.Company = &Company
	|
	|//Объединить 
	|";
	
	ПоляУсловий = Новый Массив;
	ПоляУсловий.Добавить("Source");
	ПоляУсловий.Добавить("GeoMarket");
	ПоляУсловий.Добавить("ManagementGeomarket");
	ПоляУсловий.Добавить("Segment");
	ПоляУсловий.Добавить("SubSegment");
	ПоляУсловий.Добавить("SubSubSegment");
	ПоляУсловий.Добавить("Company");
	
	Приоритеты = Новый Соответствие;
	Приоритеты.Вставить("Source", 64);
	Приоритеты.Вставить("GeoMarket", 32);
	Приоритеты.Вставить("ManagementGeomarket", 16);
	Приоритеты.Вставить("Segment", 8);
	Приоритеты.Вставить("SubSegment", 4);
	Приоритеты.Вставить("SubSubSegment", 2);
	Приоритеты.Вставить("Company", 1);
	
	КоличествоПолей = ПоляУсловий.Количество();
	
	Для Комбинация = 0 По Pow(2, КоличествоПолей) - 1 Цикл
		
		ЧастьЗапроса = ШаблонЧастьЗапросаОбъединить;
		
		ТекПриоритет = 0;
		
		ЗначенияПолей = РазложитьПоСтепенямДвойки(Комбинация, КоличествоПолей);
		Для НомерПоля = 0 По КоличествоПолей - 1 Цикл
			ИмяПоля = ПоляУсловий[НомерПоля];
			Если ЗначенияПолей[НомерПоля] Тогда
				ЧастьЗапроса = СтрЗаменить(ЧастьЗапроса, "//" + ИмяПоля + "_Истина", "");
			Иначе
				ЧастьЗапроса = СтрЗаменить(ЧастьЗапроса, "//" + ИмяПоля + "_Ложь",   "");
				ТекПриоритет = ТекПриоритет + Приоритеты[ИмяПоля];
			КонецЕсли;
		КонецЦикла; // НомерПоля
		
		ЧастьЗапроса  = СтрЗаменить(ЧастьЗапроса, "//Приоритет", ТекПриоритет);
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//Объединить", ЧастьЗапроса);
		
	КонецЦикла; // Комбинация
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВложенныйЗапрос.Method
	|ИЗ
	|	(" + СокрЛП(ТекстЗапроса) + "
	|) КАК ВложенныйЗапрос
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.Приоритет УБЫВ";
	
	Возврат ТекстЗапроса;
	
КонецФункции

Функция ОпределитьМетодРасчетаБиллинга(Период, Source = Неопределено, GeoMarket = Неопределено, ManagementGeomarket = Неопределено, Segment = Неопределено
	, SubSegment = Неопределено, SubSubSegment = Неопределено, Company = Неопределено) Экспорт
	
	ТекстЗапроса = rgsКонсолидацияДанныхСерверПовтИсп.ПолучитьТекстЗапросаОпределениеМетодаРасчетаБиллинга();
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Source", Source);
	Запрос.УстановитьПараметр("GeoMarket", GeoMarket);
	Запрос.УстановитьПараметр("ManagementGeomarket", ManagementGeomarket);
	Запрос.УстановитьПараметр("Segment", Segment);
	Запрос.УстановитьПараметр("SubSegment", SubSegment);
	Запрос.УстановитьПараметр("SubSubSegment", SubSubSegment);
	Запрос.УстановитьПараметр("Company", Company);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Перечисления.BillingCalculationMethods.ПустаяСсылка();
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	Возврат Выборка.Method;
	
КонецФункции