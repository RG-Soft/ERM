#Область ПрограммныйИнтерфейс

Процедура PowerBIПередЗаписьюОбъекта(Источник, Отказ) Экспорт
	
	ПередЗаписьюОбъекта(Источник, Отказ);
	
КонецПроцедуры

Процедура PowerBIПередЗаписьюДокумента(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	ПередЗаписьюОбъекта(Источник, Отказ);
КонецПроцедуры

Процедура PowerBIПередУдалениемОбъекта(Источник, Отказ) Экспорт
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);

	Операция = Перечисления.ОперацииPowerBI.Delete;
	Ссылка = Источник.Ссылка;

	ТаблицаСуществующихЗаданий = Справочники.ЗаданияPowerBI.ЗаданияПоИсточнику(Ссылка);
	
	Если ТаблицаСуществующихЗаданий.Количество() = 0 Тогда
		Задание = Справочники.ЗаданияPowerBI.СоздатьЭлемент();
	Иначе
		Задание = ТаблицаСуществующихЗаданий[0].Ссылка.ПолучитьОбъект();
		Если Задание.Операция = Перечисления.ОперацииPowerBI.Create Тогда
			Задание.Удалить();
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Задание.Источник = Ссылка;
	Задание.Операция = Операция;
	Если Задание.Модифицированность() Тогда
		Задание.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьЗаданияПоИсточнику(Источник) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаЗаданийПоИсточнику = Справочники.ЗаданияPowerBI.ЗаданияПоИсточнику(Источник);
	
	Отбор = Новый Структура;
	Параметры = Новый Массив;
	
	Для каждого СтрокаТаблицыЗаданий Из ТаблицаЗаданийПоИсточнику Цикл
		
		Отбор.Вставить("ИмяМетода", "PowerBIРегламенты.ВыполнитьЗаданиеПоИсточнику");
		Отбор.Вставить("Ключ", СтрШаблон("PowerBIРегламенты.ВыполнитьЗаданияПоИсточнику: %1", СтрокаТаблицыЗаданий.Ссылка.УникальныйИдентификатор()));
		Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
		
		Параметры.Очистить();
		Параметры.Добавить(СтрокаТаблицыЗаданий.Ссылка);
		
		МассивФоновыхЗаданий = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
		Если МассивФоновыхЗаданий.Количество() = 0 Тогда
			Попытка
				ФоновыеЗадания.Выполнить(Отбор.ИмяМетода, Параметры,
					Отбор.Ключ, // Ключ
					НСтр("ru = 'Выполнение заданий Power BI'")); // Наименование
			Исключение
			КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьЗаданиеПоИсточнику(Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Справочник.ЗаданияPowerBI");
	ЭлементБлокировки.УстановитьЗначение("Ссылка", Задание);
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();
	
	ЗаданиеОбъект = Задание.ПолучитьОбъект();
	
	СтруктураРезультата = ЗаданиеОбъект.ВыполнитьЗадание();
	Если СтруктураРезультата.Результат Тогда
		УбратьПодчиненныеЗаданияИзИерархии(ЗаданиеОбъект);
		ЗаданиеОбъект.Удалить();
	Иначе
		ЗаданиеОбъект.КоличествоПопытокОтправки = ЗаданиеОбъект.КоличествоПопытокОтправки + 1;
		ЗаданиеОбъект.Лог = СтруктураРезультата.Сообщение;
		ЗаданиеОбъект.Записать();
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура ВыполнитьЗаданиеСПодчиненными(Задание) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	НачатьТранзакцию();
	ПодчиненныеЗадания = ПолучитьЗаданияСледующегоУровня(Задание);
	ВыполнитьЗаданиеПоИсточнику(Задание);
	Для каждого ПодчиненноеЗадание Из ПодчиненныеЗадания Цикл
		ВыполнитьЗаданиеПоИсточнику(ПодчиненноеЗадание);
	КонецЦикла;
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура PowerBIОтправкаДанныхСправочников() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТаблицаЗаданий = ПолучитьТаблицуЗаданийДляОбработки();
	Для каждого СтрокаЗадания Из ТаблицаЗаданий Цикл
		Если ЗначениеЗаполнено(СтрокаЗадания.ПодчиненноеЗадание) Тогда
			ВыполнитьЗаданиеСПодчиненными(СтрокаЗадания.Задание);
		Иначе
			ВыполнитьЗаданиеПоИсточнику(СтрокаЗадания.Задание);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура PowerBIОтправкаДанных_Revenue() Экспорт
	
	НачатьТранзакцию();
	
	Отчет = Отчеты.RevenueByClient.Создать();
	СКД = Отчет.СхемаКомпоновкиДанных;
	ИмяВарианта = "PowerBI";
	АктивизироватьВариантОтчета(СКД, ИмяВарианта);
	АдресСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	
	Отчет.КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	
	ТекДата = НачалоМесяца(ТекущаяДата());
	НачалоПериода = ДобавитьМесяц(ТекДата, -rgsНастройкаКонфигурации.ЗначениеНастройки("PowerBI_НачалоПериодаRevenue"));
	КонецПериода = КонецМесяца(ДобавитьМесяц(ТекДата, -rgsНастройкаКонфигурации.ЗначениеНастройки("PowerBI_КонецПериодаRevenue")));
	
	ПараметрыДанных = Новый Соответствие;
	ПараметрыДанных.Вставить("ПериодОтчета", Новый СтандартныйПериод(НачалоПериода, КонецПериода));
	ИнициализироватьПараметрыДанных(Отчет.КомпоновщикНастроек, ПараметрыДанных);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	НастройкиДляКомпоновкиМакета = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиДляКомпоновкиМакета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
	
	// Создадим и инициализируем процессор вывода результата
	ТЗ = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	ТЗ.Свернуть("ПериодМесяц, Source, ClientID, Client, Company, SubGeomarket, SubSubSegment, Account, BU, Currency, AU", "Amount, USDAmount");
	
	НЗ = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_Revenue.СоздатьНаборЗаписей();
	
	ТекПериод = НачалоПериода;
	
	Пока КонецМесяца(ТекПериод) <= КонецПериода Цикл
		
		ТЗ_ТекПериод = ТЗ.Скопировать(Новый Структура("ПериодМесяц", ТекПериод));
		
		НЗ.Очистить();
		НЗ.Отбор.Period.Установить(ТекПериод);
	
		Для каждого СтрокаТЗ Из ТЗ_ТекПериод Цикл
			
			ЗаписьНабора = НЗ.Добавить();
			ЗаписьНабора.Period = СтрокаТЗ.ПериодМесяц;
			ЗаписьНабора.Source = Строка(СтрокаТЗ.Source);
			ЗаписьНабора.ClientNumber = СтрокаТЗ.ClientID;
			Если ЗначениеЗаполнено(СтрокаТЗ.Client) Тогда
				ЗаписьНабора.ClientID = СтрокаТЗ.Client.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.ClientID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.Company) Тогда
				ЗаписьНабора.CompanyID = СтрокаТЗ.Company.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.CompanyID = NULL;
			КонецЕсли;
			//Если ЗначениеЗаполнено(СтрокаТЗ.SubGeomarket) Тогда
			//	ЗаписьНабора.SubGeomarketID = СтрокаТЗ.SubGeomarket.УникальныйИдентификатор();
			//Иначе
			//	ЗаписьНабора.SubGeomarketID = NULL;
			//КонецЕсли;
			//Если ЗначениеЗаполнено(СтрокаТЗ.SubSubSegment) Тогда
			//	ЗаписьНабора.SubSubSegmentID = СтрокаТЗ.SubSubSegment.УникальныйИдентификатор();
			//Иначе
			//	ЗаписьНабора.SubSubSegmentID = NULL;
			//КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.AU) Тогда
				ЗаписьНабора.AU_ID = СтрокаТЗ.AU.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.AU_ID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.Account) Тогда
				ЗаписьНабора.AccountID = СтрокаТЗ.Account.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.AccountID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.BU) Тогда
				ЗаписьНабора.BusinessUnitID = СтрокаТЗ.BU.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.BusinessUnitID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.Currency) Тогда
				ЗаписьНабора.CurrencyID = СтрокаТЗ.Currency.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.CurrencyID = NULL;
			КонецЕсли;
			ЗаписьНабора.Amount = СтрокаТЗ.Amount;
			ЗаписьНабора.AmountUSD = СтрокаТЗ.USDAmount;
			
		КонецЦикла;
		
		НЗ.Записать(Истина);
		
		ТекПериод = ДобавитьМесяц(ТекПериод, 1);
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура PowerBIОтправкаДанных_ARDetails() Экспорт
	
	НачатьТранзакцию();
	
	ТекДата = НачалоМесяца(ТекущаяДата());
	НачалоПериода = ДобавитьМесяц(ТекДата, -rgsНастройкаКонфигурации.ЗначениеНастройки("PowerBI_НачалоПериодаARDetails"));
	КонецПериода = КонецМесяца(ДобавитьМесяц(ТекДата, -rgsНастройкаКонфигурации.ЗначениеНастройки("PowerBI_КонецПериодаARDetails")));
	
	ТекПериод = НачалоПериода;
	
	Отчет = Отчеты.ARDetailsAgeing.Создать();
	СКД = Отчет.СхемаКомпоновкиДанных;
	ИмяВарианта = "PowerBI";
	АктивизироватьВариантОтчета(СКД, ИмяВарианта);
	АдресСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	
	Отчет.КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	
	Пока КонецМесяца(ТекПериод) <= КонецПериода Цикл
	
		ПараметрыДанных = Новый Соответствие;
		ПараметрыДанных.Вставить("Период", КонецМесяца(ТекПериод));
		ИнициализироватьПараметрыДанных(Отчет.КомпоновщикНастроек, ПараметрыДанных);
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		НастройкиДляКомпоновкиМакета = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
		
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиДляКомпоновкиМакета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
		
		// Создадим и инициализируем процессор вывода результата
		ТЗ = Новый ТаблицаЗначений;
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(ТЗ);
		ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
		ТЗ.Свернуть("Source, CustomerID, Client, CompanyБазовыйЭлемент, LegalEntity, AU, AccountБазовыйЭлемент, Agreement, BU, TransactionType, Document, Currency", "AmountОстаток, BaseAmountОстаток");
		
		НЗ = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_AR_Details.СоздатьНаборЗаписей();
		
		НЗ.Очистить();
		НЗ.Отбор.Period.Установить(ТекПериод);
	
		Для каждого СтрокаТЗ Из ТЗ Цикл
			
			ЗаписьНабора = НЗ.Добавить();
			ЗаписьНабора.Period = ТекПериод;
			ЗаписьНабора.Source = Строка(СтрокаТЗ.Source);
			ЗаписьНабора.ClientNumber = СтрокаТЗ.CustomerID;
			Если ЗначениеЗаполнено(СтрокаТЗ.Client) Тогда
				ЗаписьНабора.ClientID = СтрокаТЗ.Client.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.ClientID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.CompanyБазовыйЭлемент) Тогда
				ЗаписьНабора.CompanyID = СтрокаТЗ.CompanyБазовыйЭлемент.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.CompanyID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.LegalEntity) Тогда
				ЗаписьНабора.LegalEntityID = СтрокаТЗ.LegalEntity.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.LegalEntityID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.AU) Тогда
				ЗаписьНабора.AU_ID = СтрокаТЗ.AU.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.AU_ID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.AccountБазовыйЭлемент) Тогда
				ЗаписьНабора.AccountID = СтрокаТЗ.AccountБазовыйЭлемент.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.AccountID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.BU) Тогда
				ЗаписьНабора.BusinessUnitID = СтрокаТЗ.BU.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.BusinessUnitID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.Currency) Тогда
				ЗаписьНабора.CurrencyID = СтрокаТЗ.Currency.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.CurrencyID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.Document) Тогда
				ЗаписьНабора.DocumentID = СтрокаТЗ.Document.УникальныйИдентификатор();
				ЗаписьНабора.DocumentType = ПолучитьТипДокумента(СтрокаТЗ.Document);
			Иначе
				ЗаписьНабора.DocumentID = NULL;
				ЗаписьНабора.DocumentType = NULL;
			КонецЕсли;
			
			ЗаписьНабора.TransactionType = СтрокаТЗ.TransactionType;
			ЗаписьНабора.Agreement = СтрокаТЗ.Agreement;
			ЗаписьНабора.Amount = СтрокаТЗ.AmountОстаток;
			ЗаписьНабора.AmountUSD = СтрокаТЗ.BaseAmountОстаток;
						
		КонецЦикла;
		
		НЗ.Записать(Истина);
		
		ТекПериод = ДобавитьМесяц(ТекПериод, 1);
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Процедура PowerBIОтправкаДанных_DSO() Экспорт
	
	НачатьТранзакцию();
	
	ТекДата = НачалоМесяца(ТекущаяДата());
	НачалоПериода = ДобавитьМесяц(ТекДата, -rgsНастройкаКонфигурации.ЗначениеНастройки("PowerBI_НачалоПериодаDSO"));
	КонецПериода = КонецМесяца(ДобавитьМесяц(ТекДата, -rgsНастройкаКонфигурации.ЗначениеНастройки("PowerBI_КонецПериодаDSO")));
	
	ТекПериод = НачалоПериода;
	
	Отчет = Отчеты.DSODetails.Создать();
	СКД = Отчет.СхемаКомпоновкиДанных;
	ИмяВарианта = "PowerBI";
	АктивизироватьВариантОтчета(СКД, ИмяВарианта);
	АдресСхемы = ПоместитьВоВременноеХранилище(СКД, Новый УникальныйИдентификатор());
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы);
	
	Отчет.КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	
	Пока КонецМесяца(ТекПериод) <= КонецПериода Цикл
	
		ПараметрыДанных = Новый Соответствие;
		ПараметрыДанных.Вставить("Период", КонецМесяца(ТекПериод));
		ИнициализироватьПараметрыДанных(Отчет.КомпоновщикНастроек, ПараметрыДанных);
		
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		НастройкиДляКомпоновкиМакета = Отчет.КомпоновщикНастроек.ПолучитьНастройки();
		
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СКД, НастройкиДляКомпоновкиМакета, , , Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
		
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , , Истина);
		
		// Создадим и инициализируем процессор вывода результата
		ТЗ = Новый ТаблицаЗначений;
		ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
		ПроцессорВывода.УстановитьОбъект(ТЗ);
		ПроцессорВывода.Вывести(ПроцессорКомпоновки);
		
		ТЗ.Свернуть("Source, Client, Company, LegalEntity, AU, BU", "AR, Billing0, Billing1, Billing2, Billing3, Billing4, Billing5, Billing6
			|, Billing7, Billing8, Billing9, Billing10, Billing11, Billing12, Billing13, Billing14, Billing15, Billing16, Billing17, Billing18
			|, Billing19, Billing20, Billing21, Billing22, Billing23, Billing24");
		
		НЗ = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_DSO_Details.СоздатьНаборЗаписей();
		
		НЗ.Очистить();
		НЗ.Отбор.Period.Установить(ТекПериод);
	
		Для каждого СтрокаТЗ Из ТЗ Цикл
				
			ЗаписьНабора = НЗ.Добавить();
			
			ЗаполнитьЗначенияСвойств(ЗаписьНабора, СтрокаТЗ);
			
			ЗаписьНабора.Period = ТекПериод;
			ЗаписьНабора.Source = Строка(СтрокаТЗ.Source);
			Если ЗначениеЗаполнено(СтрокаТЗ.Client) Тогда
				ЗаписьНабора.ClientID = СтрокаТЗ.Client.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.ClientID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.Company) Тогда
				ЗаписьНабора.CompanyID = СтрокаТЗ.Company.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.CompanyID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.LegalEntity) Тогда
				ЗаписьНабора.LegalEntityID = СтрокаТЗ.LegalEntity.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.LegalEntityID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.AU) Тогда
				ЗаписьНабора.AU_ID = СтрокаТЗ.AU.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.AU_ID = NULL;
			КонецЕсли;
			Если ЗначениеЗаполнено(СтрокаТЗ.BU) Тогда
				ЗаписьНабора.BusinessUnitID = СтрокаТЗ.BU.УникальныйИдентификатор();
			Иначе
				ЗаписьНабора.BusinessUnitID = NULL;
			КонецЕсли;
						
		КонецЦикла;
		
		НЗ.Записать(Истина);
		
		ТекПериод = ДобавитьМесяц(ТекПериод, 1);
		
	КонецЦикла;
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТипДокумента(Документ)
	
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.Invoice") Тогда
		Возврат "Invoice";
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.Memo") Тогда
		Возврат "Memo";
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.CashBatch") Тогда
		Возврат "CashBatch";
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.SalesOrder") Тогда
		Возврат "SalesOrder";
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.РучнаяКорректировка") Тогда
		Возврат "JV";
	Иначе
		Возврат NULL;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция ПолучитьОбъектИзВнешнегоИсточника(ИмяТаблицы, Операция, Ссылка, ПараметрыЛогирования) Экспорт
	
	Если Операция = Перечисления.ОперацииPowerBI.Create Тогда
		ПараметрыЛогирования.Событие = Перечисления.ТипыСобытийИнтеграцииPowerBI.СозданиеОбъекта;
		РегистрыСведений.ЛогВыгрузкиPowerBI.ЗалогироватьСобытие(ПараметрыЛогирования);
		ТекОбъект = ВнешниеИсточникиДанных.ERM_BI.Таблицы[ИмяТаблицы].СоздатьОбъект();
		ТекОбъект.ID = Строка(Ссылка.УникальныйИдентификатор());
	Иначе
		ПараметрыЛогирования.Событие = Перечисления.ТипыСобытийИнтеграцииPowerBI.ПолучениеОбъекта;
		РегистрыСведений.ЛогВыгрузкиPowerBI.ЗалогироватьСобытие(ПараметрыЛогирования);
		СсылкаВоВнешнемИсточнике = ВнешниеИсточникиДанных.ERM_BI.Таблицы[ИмяТаблицы].ПолучитьСсылку(Строка(Ссылка.УникальныйИдентификатор()));
		ТекОбъект = СсылкаВоВнешнемИсточнике.ПолучитьОбъект();
	КонецЕсли;
	
	Возврат ТекОбъект;
	
КонецФункции

Процедура ЗаписатьОбъектВоВнешнийИсточник(Объект, ПараметрыЛогирования, СтруктураРезультата) Экспорт
	
	ПараметрыЛогирования.Событие = Перечисления.ТипыСобытийИнтеграцииPowerBI.НачалоЗаписи;
	РегистрыСведений.ЛогВыгрузкиPowerBI.ЗалогироватьСобытие(ПараметрыЛогирования);
	Попытка
		Объект.Записать();
	Исключение
		СтруктураРезультата.Сообщение = ОписаниеОшибки();
		Возврат;
	КонецПопытки;
	ПараметрыЛогирования.Событие = Перечисления.ТипыСобытийИнтеграцииPowerBI.ОкончаниеЗаписи;
	РегистрыСведений.ЛогВыгрузкиPowerBI.ЗалогироватьСобытие(ПараметрыЛогирования);
	
КонецПроцедуры

Процедура СформироватьЗаписиЖурналаДокуменовPowerBI(Ссылка, ИмяТипа, ПараметрыЛогирования, СтруктураРезультата) Экспорт
	
	ГУИД = Строка(Ссылка.УникальныйИдентификатор());
	
	НЗ = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_DocumentJournal.СоздатьНаборЗаписей();
	НЗ.Отбор.TypeName.Установить(ИмяТипа);
	НЗ.Отбор.DocumentID.Установить(ГУИД);
	
	ЗаписьНабора = НЗ.Добавить();
	ЗаписьНабора.TypeName = ИмяТипа;
	ЗаписьНабора.DocumentID = ГУИД;

	ПараметрыЛогирования.Событие = Перечисления.ТипыСобытийИнтеграцииPowerBI.НачалоЗаписи;
	ПараметрыЛогирования.Комментарий = "Запись в журнал документов";
	РегистрыСведений.ЛогВыгрузкиPowerBI.ЗалогироватьСобытие(ПараметрыЛогирования);
	Попытка
		НЗ.Записать();
	Исключение
		СтруктураРезультата.Сообщение = ОписаниеОшибки();
		Возврат;
	КонецПопытки;
	ПараметрыЛогирования.Событие = Перечисления.ТипыСобытийИнтеграцииPowerBI.ОкончаниеЗаписи;
	РегистрыСведений.ЛогВыгрузкиPowerBI.ЗалогироватьСобытие(ПараметрыЛогирования);
	ПараметрыЛогирования.Комментарий = "";
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПередЗаписьюОбъекта(Источник, Отказ) Экспорт

	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Источник) = Тип("СправочникСсылка.ДоговорыКонтрагентов") И Источник.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);

	ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Источник));
	
	Если Источник.ЭтоНовый() Тогда
		
		Ссылка = Источник.ПолучитьСсылкуНового();
		Если Ссылка.Пустая() Тогда
			Если ОбщегоНазначения.ЭтоСправочник(ОбъектМетаданных) Тогда
				Ссылка = Справочники[ОбъектМетаданных.Имя].ПолучитьСсылку(Новый УникальныйИдентификатор());
			ИначеЕсли ОбщегоНазначения.ЭтоПланСчетов(ОбъектМетаданных) Тогда
				Ссылка = ПланыСчетов[ОбъектМетаданных.Имя].ПолучитьСсылку(Новый УникальныйИдентификатор());
			ИначеЕсли ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) Тогда
				Ссылка = Документы[ОбъектМетаданных.Имя].ПолучитьСсылку(Новый УникальныйИдентификатор());
			Иначе
				ВызватьИсключение СтрШаблон("Unexpected metadata type: %1", Источник);
			КонецЕсли;
			Источник.УстановитьСсылкуНового(Ссылка);
		КонецЕсли;
		
		Операция = Перечисления.ОперацииPowerBI.Create;
		
	Иначе
		
		Ссылка = Источник.Ссылка;
		Операция = Перечисления.ОперацииPowerBI.Update;
		
	КонецЕсли;

	ТаблицаСуществующихЗаданий = Справочники.ЗаданияPowerBI.ЗаданияПоИсточнику(Ссылка);
	
	Если ТаблицаСуществующихЗаданий.Количество() = 0 Тогда
		Задание = Справочники.ЗаданияPowerBI.СоздатьЭлемент();
	Иначе
		Задание = ТаблицаСуществующихЗаданий[0].Ссылка.ПолучитьОбъект();
	КонецЕсли;
	
	Если НЕ ОбщегоНазначения.ЭтоДокумент(ОбъектМетаданных) 
		И (ОбщегоНазначения.ЭтоПланСчетов(ОбъектМетаданных) 
			ИЛИ ОбъектМетаданных.Иерархический) И ЗначениеЗаполнено(Источник.Родитель) Тогда
		Задания = Справочники.ЗаданияPowerBI.ЗаданияПоИсточнику(Источник.Родитель);
		Если Задания.Количество() > 0 Тогда
			Задание.Родитель = Задания[0].Ссылка;
		КонецЕсли;
	КонецЕсли;
	
	Если ТаблицаСуществующихЗаданий.Количество() = 0 Тогда
		Задание.Источник = Ссылка;
		Задание.Операция = Операция;
	КонецЕсли;
	Если Задание.Модифицированность() Тогда
		Задание.Записать();
	КонецЕсли;
	
КонецПроцедуры

Процедура УбратьПодчиненныеЗаданияИзИерархии(ЗаданиеРодитель)
	
	ПодчиненныеЗадания = ПолучитьЗаданияСледующегоУровня(ЗаданиеРодитель.Ссылка);
	
	Для Каждого ПодчиненноеЗадание Из ПодчиненныеЗадания Цикл
		
		ПодчиненноеЗаданиеОбъект = ПодчиненноеЗадание.ПолучитьОбъект();
		ПодчиненноеЗаданиеОбъект.Родитель = Справочники.ЗаданияPowerBI.ПустаяСсылка();
		ПодчиненноеЗаданиеОбъект.Записать();
		
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТаблицуЗаданийДляОбработки()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаданияPowerBI.Ссылка КАК Задание,
		|	ЕСТЬNULL(МАКСИМУМ(ЗаданияPowerBI1.Ссылка), ЗНАЧЕНИЕ(Справочник.ЗаданияPowerBI.ПустаяСсылка)) КАК ПодчиненноеЗадание
		|ИЗ
		|	Справочник.ЗаданияPowerBI КАК ЗаданияPowerBI
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ЗаданияPowerBI КАК ЗаданияPowerBI1
		|		ПО ЗаданияPowerBI.Ссылка = ЗаданияPowerBI1.Родитель
		|			И (НЕ ЗаданияPowerBI1.ПометкаУдаления)
		|ГДЕ
		|	НЕ ЗаданияPowerBI.ПометкаУдаления
		|
		|СГРУППИРОВАТЬ ПО
		|	ЗаданияPowerBI.Ссылка";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция ПолучитьЗаданияСледующегоУровня(Задание)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗаданияPowerBI.Ссылка
		|ИЗ
		|	Справочник.ЗаданияPowerBI КАК ЗаданияPowerBI
		|ГДЕ
		|	ЗаданияPowerBI.Родитель = &Родитель
		|	И НЕ ЗаданияPowerBI.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Родитель", Задание);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецФункции

Процедура ИнициализироватьПараметрыДанных(КомпоновщикНастроек, ПараметрыДанных)
	
	Если ПараметрыДанных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ТекПараметр Из ПараметрыДанных Цикл
		Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти(ТекПараметр.Ключ);
		Если Параметр <> Неопределено Тогда
			Параметр.Значение = ТекПараметр.Значение;
			Параметр.Использование = Истина;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура АктивизироватьВариантОтчета(СКД, ИмяВарианта)
	
	Если Не ЗначениеЗаполнено(ИмяВарианта) Тогда
		Возврат;
	КонецЕсли;
	
	Вариант = СКД.ВариантыНастроек.Найти(ИмяВарианта);
	
	Если Вариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВариантыДляУдаления = Новый Массив;
	
	Для каждого ТекВариант Из СКД.ВариантыНастроек Цикл
		Если ТекВариант.Имя <> ИмяВарианта Тогда
			ВариантыДляУдаления.Добавить(ТекВариант);
		КонецЕсли;
	КонецЦикла;
	
	Для каждого ТекВариант Из ВариантыДляУдаления Цикл
		СКД.ВариантыНастроек.Удалить(ТекВариант);
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
