
&НаСервере
Процедура СформироватьКорректировкиТранзакцийНаСервере()
	
	НачатьТранзакцию();
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	Для каждого СтрокаТранзакции Из ТаблицаТранзакций Цикл
		
		Если Не СтрокаТранзакции.Apply Тогда
			Продолжить;
		КонецЕсли;
		
		КорректировкаТразакции = Документы.КорректировкаТранзакции.СоздатьДокумент();
		КорректировкаТразакции.Дата = ТекущаяДата();
		КорректировкаТразакции.ДокументОснование = СтрокаТранзакции.Ссылка;
		ЗаполнитьЗначенияСвойств(КорректировкаТразакции, СтрокаТранзакции, "Company,Account,Currency,AU,Location,LegalEntity");
//		РеквизитыТранзакции = Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(СтрокаТранзакции.Ссылка);
		СтрокаТабЧасти = КорректировкаТразакции.ДетализацияПоКлиенту.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТабЧасти, СтрокаТранзакции);
//		СтрокаТабЧасти.Amount = РеквизитыТранзакции.Amount;
//		СтрокаТабЧасти.BaseAmount = РеквизитыТранзакции.BaseAmount;
		СтрокаТабЧасти.Client = НовыйКлинет;
		КорректировкаТразакции.Комментарий = "The document was created using Group creation of Transaction adjustment for changes client""";
		КорректировкаТразакции.Ответственный = ТекущийПользователь;
		КорректировкаТразакции.Записать(РежимЗаписиДокумента.Запись);
		
		ТекДок = КорректировкаТразакции.Ссылка.ПолучитьОбъект();
		Попытка
			ТекДок.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Не удалось записать """ + ТекДок + """! ");
			ОтменитьТранзакцию();
			Возврат;
		КонецПопытки;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Transaction adjustments created!");
	
	ЗафиксироватьТранзакцию();
	
	ОтобразитьТранзакцииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьКорректировкиТранзакций(Команда)
	СформироватьКорректировкиТранзакцийНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТранзакций Цикл
		Если Элементы.ТаблицаТранзакций.ПроверитьСтроку(СтрокаТаблицы.ПолучитьИдентификатор()) Тогда
			Если НЕ СтрокаТаблицы.Apply Тогда
				СтрокаТаблицы.Apply = Истина;
				ИтоговаяСумма = ИтоговаяСумма + СтрокаТаблицы.BaseAmount;
			КонецЕсли
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	Для каждого СтрокаТаблицы Из ТаблицаТранзакций Цикл
		Если СтрокаТаблицы.Apply Тогда
			СтрокаТаблицы.Apply = Ложь;
			ИтоговаяСумма = ИтоговаяСумма - СтрокаТаблицы.BaseAmount;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОтобразитьТранзакцииНаСервере()
	
	Если Source = Перечисления.ТипыСоответствий.HOBs Тогда
		ТЗ_Транзакций = ПолучитьТранзакцииHOBs();
	ИначеЕсли Source = Перечисления.ТипыСоответствий.Lawson Тогда
		ТЗ_Транзакций = ПолучитьТранзакцииLawson();
	ИначеЕсли Source = Перечисления.ТипыСоответствий.OracleMI ИЛИ Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
		ТЗ_Транзакций = ПолучитьТранзакцииOracle();
	КонецЕсли;
	
	ЗначениеВРеквизитФормы(ТЗ_Транзакций, "ТаблицаТранзакций");
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТранзакцииHOBs()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛОЖЬ КАК Apply,
		|	ТранзакцияHOB.Номер КАК Номер,
		|	ТранзакцияHOB.Account КАК Account,
		|	ТранзакцияHOB.Amount КАК Amount,
		|	ТранзакцияHOB.BaseAmount КАК BaseAmount,
		|	ТранзакцияHOB.Client КАК Client,
		|	ТранзакцияHOB.Company КАК Company,
		|	ТранзакцияHOB.Currency КАК Currency,
		|	ТранзакцияHOB.CustomerNumber КАК CustomerNumber,
		|	"""" КАК CreatedByName,
		|	"""" КАК Description,
		|	ТранзакцияHOB.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель КАК Segment,
		|	ТранзакцияHOB.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель КАК GeoMarket,
		|	ТранзакцияHOB.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket КАК SubGeoMarket,
		|	ТранзакцияHOB.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket КАК ManagementGeo,
		|	ТранзакцияHOB.AU КАК AU,
		|	Выбор когда ТранзакцияHOB.MNGC = Значение(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
		|		Тогда ТранзакцияHOB.AU.ПодразделениеОрганизации
		|		Иначе ТранзакцияHOB.MNGC
		|		Конец КАК Location,
		|	ТранзакцияHOB.LegalEntity КАК LegalEntity,
		|	ТранзакцияHOB.Ссылка КАК Ссылка,
		|	DSSСвязанныеДокументыInv.СвязанныйОбъект.Номер КАК Invoice,
		|	DSSСвязанныеДокументыSO.СвязанныйОбъект.Номер КАК SalesOrder,
		|	DSSСвязанныеДокументыCB.СвязанныйОбъект.Номер КАК CashBatch,
		|	DSSСвязанныеДокументыBA.СвязанныйОбъект.Номер КАК BatchAllocation,
		|	DSSСвязанныеДокументыJV.СвязанныйОбъект.Номер КАК ManualTransaction,
		|	DSSСвязанныеДокументыM.СвязанныйОбъект.Номер КАК Memo
		|ИЗ
		|	Документ.ТранзакцияHOB КАК ТранзакцияHOB
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|		ПО ТранзакцияHOB.Ссылка = КорректировкаТранзакции.ДокументОснование
		|			И (НЕ КорректировкаТранзакции.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыInv
		|		ПО ТранзакцияHOB.Ссылка = DSSСвязанныеДокументыInv.ПроводкаDSS
		|			И (DSSСвязанныеДокументыInv.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.Invoice))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыSO
		|		ПО ТранзакцияHOB.Ссылка = DSSСвязанныеДокументыSO.ПроводкаDSS
		|			И (DSSСвязанныеДокументыSO.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.SalesOrder))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыCB
		|		ПО ТранзакцияHOB.Ссылка = DSSСвязанныеДокументыCB.ПроводкаDSS
		|			И (DSSСвязанныеДокументыCB.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.CashBatch))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыBA
		|		ПО ТранзакцияHOB.Ссылка = DSSСвязанныеДокументыBA.ПроводкаDSS
		|			И (DSSСвязанныеДокументыBA.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.BatchAllocation))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыJV
		|		ПО (DSSСвязанныеДокументыJV.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.РучнаяКорректировка))
		|			И ТранзакцияHOB.Ссылка = DSSСвязанныеДокументыJV.ПроводкаDSS
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыM
		|		ПО ТранзакцияHOB.Ссылка = DSSСвязанныеДокументыM.ПроводкаDSS
		|			И (DSSСвязанныеДокументыM.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.Memo))
		|ГДЕ
		|	ТранзакцияHOB.Проведен
		|	И ТранзакцияHOB.Дата <= &ДатаОкончания
		|	И ТранзакцияHOB.Дата >= &ДатаНачала
		|	&УсловиеСчета
		|	И (&Company = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.Company = &Company)
		|	И (&Client = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.Client = &Client)
		|	И (&CustomerNumber = """"
		|			ИЛИ ТранзакцияHOB.CustomerNumber = &CustomerNumber)
		|	И (&Currency = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.Currency = &Currency)
		|	И (&LegalEntity = ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.LegalEntity = &LegalEntity)
		|	И (&Account = НЕОПРЕДЕЛЕНО
		|			ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Oracle.ПустаяСсылка)
		|			ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Lawson.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.Account = &Account)
		|	И (&AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.AU = &AU)
		|	И &УсловиеПоКлиенту
		|	И КорректировкаТранзакции.Ссылка ЕСТЬ NULL
		|	И (&Segment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель = &Segment)
		|	И (&GeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель = &GeoMarket)
		|	И (&SubGeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket = &SubGeoMarket)
		|	И (&ManagementGeomarket = ЗНАЧЕНИЕ(Справочник.ManagementGeography.ПустаяСсылка)
		|			ИЛИ ТранзакцияHOB.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket = &ManagementGeomarket)
		|	И (&ClientID_Document = """" 
		|			ИЛИ ((DSSСвязанныеДокументыInv.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыInv.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыSO.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыSO.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыCB.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыCB.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыBA.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыBA.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыJV.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыJV.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыM.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыM.СвязанныйОбъект.ClientID = &ClientID_Document)))
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранзакцияHOB.Номер";
	
	Запрос.УстановитьПараметр("AU", AU);
	Запрос.УстановитьПараметр("Company", Company);
	Запрос.УстановитьПараметр("Source", Source);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Client", Client);
	Запрос.УстановитьПараметр("CustomerNumber", CustomerNumber);
	Запрос.УстановитьПараметр("Currency", Currency);
	Запрос.УстановитьПараметр("Account", Account);
	Запрос.УстановитьПараметр("LegalEntity", LegalEntity);
	Запрос.УстановитьПараметр("Segment", Segment);
	Запрос.УстановитьПараметр("GeoMarket", GeoMarket);
	Запрос.УстановитьПараметр("SubGeoMarket", SubGeoMarket);
	Запрос.УстановитьПараметр("ManagementGeomarket", ManagementGeomarket);
	Запрос.УстановитьПараметр("ClientID_Document", ClientID_Document);
	
	Если ТипСчета = Перечисления.ТипСчета.AR Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И НЕ ТранзакцияHOB.Account.Код ПОДОБНО ""4%""");
	ИначеЕсли ТипСчета = Перечисления.ТипСчета.Revenue Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И ТранзакцияHOB.Account.Код ПОДОБНО ""4%""");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "");
	КонецЕсли;
	
	Если IcoClients И PredefinedClients Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "(ТранзакцияHOB.Client.Предопределенный ИЛИ ТранзакцияHOB.Client.Intercompany)");
	ИначеЕсли IcoClients Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ТранзакцияHOB.Client.Intercompany");
	ИначеЕсли (PredefinedClients) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ТранзакцияHOB.Client.Предопределенный");
	КонецЕсли;		
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ_Транзакции =  РезультатЗапроса.Выгрузить();
	
	Для каждого Транзакция Из ТЗ_Транзакции Цикл
		РеквизитыТранзакции = Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(Транзакция.Ссылка);
		Транзакция.Amount = РеквизитыТранзакции.Amount;
		Транзакция.BaseAmount = РеквизитыТранзакции.BaseAmount;
	КонецЦикла;
	
	Возврат ТЗ_Транзакции;
	
КонецФункции

&НаСервере
Функция ПолучитьТранзакцииLawson()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛОЖЬ КАК Apply,
		|	ПроводкаDSS_Doc.Номер КАК Номер,
		|	ПроводкаDSS_Doc.Company КАК Company,
		|	ПроводкаDSS_Doc.Currency КАК Currency,
		|	ПроводкаDSS_Doc.Description КАК Description,
		|	ПроводкаDSS_Doc.CustomerNumber КАК CustomerNumber,
		|	"""" КАК CreatedByName,
		|	ПроводкаDSS_Doc.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель КАК Segment,
		|	ПроводкаDSS_Doc.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель КАК GeoMarket,
		|	ПроводкаDSS_Doc.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket КАК SubGeoMarket,
		|	ПроводкаDSS_Doc.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket КАК ManagementGeo,
		|	ПроводкаDSS_Doc.AU КАК AU,
		|	ПроводкаDSS_Doc.AU.ПодразделениеОрганизации КАК Location,
		|	ПроводкаDSS_Doc.LegalEntity КАК LegalEntity,
		|	ПроводкаDSS_Doc.AccountLawson КАК Account,
		|	ПроводкаDSS_Doc.КонтрагентLawson КАК Client,
		|	ПроводкаDSS_Doc.TranAmount КАК Amount,
		|	ПроводкаDSS_Doc.BaseAmount КАК BaseAmount,
		|	ПроводкаDSS_Doc.Ссылка КАК Ссылка,
		|	DSSСвязанныеДокументыInv.СвязанныйОбъект.Номер КАК Invoice,
		|	DSSСвязанныеДокументыSO.СвязанныйОбъект.Номер КАК SalesOrder,
		|	DSSСвязанныеДокументыCB.СвязанныйОбъект.Номер КАК CashBatch,
		|	DSSСвязанныеДокументыBA.СвязанныйОбъект.Номер КАК BatchAllocation,
		|	DSSСвязанныеДокументыJV.СвязанныйОбъект.Номер КАК ManualTransaction,
		|	DSSСвязанныеДокументыM.СвязанныйОбъект.Номер КАК Memo
		|ИЗ
		|	Документ.ПроводкаDSS КАК ПроводкаDSS_Doc
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|		ПО ПроводкаDSS_Doc.Ссылка = КорректировкаТранзакции.ДокументОснование
		|			И (НЕ КорректировкаТранзакции.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыInv
		|		ПО ПроводкаDSS_Doc.Ссылка = DSSСвязанныеДокументыInv.ПроводкаDSS
		|			И (DSSСвязанныеДокументыInv.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.Invoice))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыSO
		|		ПО ПроводкаDSS_Doc.Ссылка = DSSСвязанныеДокументыSO.ПроводкаDSS
		|			И (DSSСвязанныеДокументыSO.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.SalesOrder))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыCB
		|		ПО ПроводкаDSS_Doc.Ссылка = DSSСвязанныеДокументыCB.ПроводкаDSS
		|			И (DSSСвязанныеДокументыCB.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.CashBatch))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыBA
		|		ПО ПроводкаDSS_Doc.Ссылка = DSSСвязанныеДокументыBA.ПроводкаDSS
		|			И (DSSСвязанныеДокументыBA.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.BatchAllocation))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыJV
		|		ПО (DSSСвязанныеДокументыJV.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.РучнаяКорректировка))
		|			И ПроводкаDSS_Doc.Ссылка = DSSСвязанныеДокументыJV.ПроводкаDSS
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыM
		|		ПО ПроводкаDSS_Doc.Ссылка = DSSСвязанныеДокументыM.ПроводкаDSS
		|			И (DSSСвязанныеДокументыM.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.Memo))
		|ГДЕ
		|	ПроводкаDSS_Doc.Проведен
		|	И ПроводкаDSS_Doc.AccountingPeriod <= &ДатаОкончания
		|	И ПроводкаDSS_Doc.AccountingPeriod >= &ДатаНачала
		|	&УсловиеСчета
		|	И (&Company = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.Company = &Company)
		|	И (&Client = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.КонтрагентLawson = &Client)
		|	И (&CustomerNumber = """"
		|			ИЛИ ПроводкаDSS_Doc.CustomerNumber = &CustomerNumber)
		|	И (&Currency = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.Currency = &Currency)
		|	И (&LegalEntity = ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.LegalEntity = &LegalEntity)
		|	И (&Account = НЕОПРЕДЕЛЕНО
		|			ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Oracle.ПустаяСсылка)
		|			ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Lawson.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.AccountLawson = &Account)
		|	И (&AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.AU = &AU)
		|	И &УсловиеПоКлиенту
		|	И КорректировкаТранзакции.Ссылка ЕСТЬ NULL
		|	И (&Segment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель = &Segment)
		|	И (&GeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель = &GeoMarket)
		|	И (&SubGeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket = &SubGeoMarket)
		|	И (&ManagementGeomarket = ЗНАЧЕНИЕ(Справочник.ManagementGeography.ПустаяСсылка)
		|			ИЛИ ПроводкаDSS_Doc.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket = &ManagementGeomarket)
		|	И (&ClientID_Document = """"
		|			ИЛИ ((DSSСвязанныеДокументыInv.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыInv.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыSO.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыSO.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыCB.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыCB.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыBA.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыBA.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыJV.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыJV.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыM.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыM.СвязанныйОбъект.ClientID = &ClientID_Document)))
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПроводкаDSS_Doc.Номер";
	
	Запрос.УстановитьПараметр("AU", AU);
	Запрос.УстановитьПараметр("Company", Company);
	Запрос.УстановитьПараметр("Source", Source);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Client", Client);
	Запрос.УстановитьПараметр("CustomerNumber", CustomerNumber);
	Запрос.УстановитьПараметр("Currency", Currency);
	Запрос.УстановитьПараметр("Account", Account);
	Запрос.УстановитьПараметр("LegalEntity", LegalEntity);
	Запрос.УстановитьПараметр("Segment", Segment);
	Запрос.УстановитьПараметр("GeoMarket", GeoMarket);
	Запрос.УстановитьПараметр("SubGeoMarket", SubGeoMarket);
	Запрос.УстановитьПараметр("ManagementGeomarket", ManagementGeomarket);
	Запрос.УстановитьПараметр("ClientID_Document", ClientID_Document);
	
	Если ТипСчета = Перечисления.ТипСчета.AR Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И НЕ ПроводкаDSS_Doc.AccountLawson.Код ПОДОБНО ""4%""");
	ИначеЕсли ТипСчета = Перечисления.ТипСчета.Revenue Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И ПроводкаDSS_Doc.AccountLawson.Код ПОДОБНО ""4%""");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "");
	КонецЕсли;
	
	Если IcoClients И PredefinedClients Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "(ПроводкаDSS_Doc.КонтрагентLawson.Предопределенный ИЛИ ПроводкаDSS_Doc.КонтрагентLawson.Intercompany)");
	ИначеЕсли IcoClients Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ПроводкаDSS_Doc.КонтрагентLawson.Intercompany");
	ИначеЕсли (PredefinedClients) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ПроводкаDSS_Doc.КонтрагентLawson.Предопределенный");
	КонецЕсли;		
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ_Транзакции =  РезультатЗапроса.Выгрузить();
	
	Для каждого Транзакция Из ТЗ_Транзакции Цикл
		РеквизитыТранзакции = Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(Транзакция.Ссылка);
		Транзакция.Amount = РеквизитыТранзакции.Amount;
		Транзакция.BaseAmount = РеквизитыТранзакции.BaseAmount;
	КонецЦикла;
	
	Возврат ТЗ_Транзакции;
	
КонецФункции

&НаСервере
Функция ПолучитьТранзакцииOracle()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЛОЖЬ КАК Apply,
		|	ТранзакцияOracle.Номер КАК Номер,
		|	ТранзакцияOracle.Account КАК Account,
		|	ТранзакцияOracle.Amount КАК Amount,
		|	ТранзакцияOracle.BaseAmount КАК BaseAmount,
		|	ТранзакцияOracle.Client КАК Client,
		|	ТранзакцияOracle.EndClient КАК EndClient,
		|	ТранзакцияOracle.Company КАК Company,
		|	ТранзакцияOracle.Currency КАК Currency,
		|	ТранзакцияOracle.Description КАК Description,
		|	ТранзакцияOracle.CustomerNumber КАК CustomerNumber,
		|	ТранзакцияOracle.EndCustomerNumber КАК EndCustomerNumber,
		|	ТранзакцияOracle.CreatedByName КАК CreatedByName,
		|	ТранзакцияOracle.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель КАК Segment,
		|	ТранзакцияOracle.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель КАК GeoMarket,
		|	ТранзакцияOracle.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket КАК SubGeoMarket,
		|	ТранзакцияOracle.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket КАК ManagementGeo,
		|	ТранзакцияOracle.AU КАК AU,
		|	ТранзакцияOracle.AU.ПодразделениеОрганизации КАК Location,
		|	ТранзакцияOracle.LegalEntity КАК LegalEntity,
		|	ТранзакцияOracle.Source КАК Source,
		|	ТранзакцияOracle.Ссылка КАК Ссылка,
		|	DSSСвязанныеДокументыInv.СвязанныйОбъект.Номер КАК Invoice,
		|	DSSСвязанныеДокументыSO.СвязанныйОбъект.Номер КАК SalesOrder,
		|	DSSСвязанныеДокументыCB.СвязанныйОбъект.Номер КАК CashBatch,
		|	DSSСвязанныеДокументыBA.СвязанныйОбъект.Номер КАК BatchAllocation,
		|	DSSСвязанныеДокументыJV.СвязанныйОбъект.Номер КАК ManualTransaction,
		|	DSSСвязанныеДокументыM.СвязанныйОбъект.Номер КАК Memo
		|ИЗ
		|	Документ.ТранзакцияOracle КАК ТранзакцияOracle
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|		ПО ТранзакцияOracle.Ссылка = КорректировкаТранзакции.ДокументОснование
		|			И (НЕ КорректировкаТранзакции.ПометкаУдаления И КорректировкаТранзакции.Проведен)
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыInv
		|		ПО ТранзакцияOracle.Ссылка = DSSСвязанныеДокументыInv.ПроводкаDSS
		|			И (DSSСвязанныеДокументыInv.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.Invoice))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыSO
		|		ПО ТранзакцияOracle.Ссылка = DSSСвязанныеДокументыSO.ПроводкаDSS
		|			И (DSSСвязанныеДокументыSO.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.SalesOrder))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыCB
		|		ПО ТранзакцияOracle.Ссылка = DSSСвязанныеДокументыCB.ПроводкаDSS
		|			И (DSSСвязанныеДокументыCB.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.CashBatch))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыBA
		|		ПО ТранзакцияOracle.Ссылка = DSSСвязанныеДокументыBA.ПроводкаDSS
		|			И (DSSСвязанныеДокументыBA.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.BatchAllocation))
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыJV
		|		ПО (DSSСвязанныеДокументыJV.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.РучнаяКорректировка))
		|			И ТранзакцияOracle.Ссылка = DSSСвязанныеДокументыJV.ПроводкаDSS
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументыM
		|		ПО ТранзакцияOracle.Ссылка = DSSСвязанныеДокументыM.ПроводкаDSS
		|			И (DSSСвязанныеДокументыM.ТипСвязанногоОбъекта = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовСвязанныхСПроводкойDSS.Memo))
		|ГДЕ
		|	ТранзакцияOracle.Проведен
		|	И ТранзакцияOracle.Дата <= &ДатаОкончания
		|	И ТранзакцияOracle.Дата >= &ДатаНачала
		|	&УсловиеСчета
		|	И (&Company = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.Company = &Company)
		|	И (&Client = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.Client = &Client)
		|	И (&CustomerNumber = """"
		|			ИЛИ ТранзакцияOracle.CustomerNumber = &CustomerNumber)
		|	И (&Currency = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.Currency = &Currency)
		|	И (&LegalEntity = ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.LegalEntity = &LegalEntity)
		|	И (&Account = НЕОПРЕДЕЛЕНО
		|			ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Oracle.ПустаяСсылка)
		|			ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Lawson.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.Account = &Account)
		|	И (&AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.AU = &AU)
		|	И &УсловиеПоКлиенту
		|	И ТранзакцияOracle.Source = &Source
		|	И КорректировкаТранзакции.Ссылка ЕСТЬ NULL
		|	И (&Segment = ЗНАЧЕНИЕ(Справочник.HFM_Technology.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель = &Segment)
		|	И (&GeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель = &GeoMarket)
		|	И (&SubGeoMarket = ЗНАЧЕНИЕ(Справочник.HFM_Geomarkets.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket = &SubGeoMarket)
		|	И (&ManagementGeomarket = ЗНАЧЕНИЕ(Справочник.ManagementGeography.ПустаяСсылка)
		|			ИЛИ ТранзакцияOracle.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket = &ManagementGeomarket)
		|	И (&ClientID_Document = """"
		|			ИЛИ ((DSSСвязанныеДокументыInv.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыInv.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыSO.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыSO.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыCB.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыCB.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыBA.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыBA.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыJV.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыJV.СвязанныйОбъект.ClientID = &ClientID_Document)
		|				И (DSSСвязанныеДокументыM.СвязанныйОбъект.Ссылка Есть NULL ИЛИ DSSСвязанныеДокументыM.СвязанныйОбъект.ClientID = &ClientID_Document)))
		|
		|УПОРЯДОЧИТЬ ПО
		|	ТранзакцияOracle.Номер";
	
	Запрос.УстановитьПараметр("AU", AU);
	Запрос.УстановитьПараметр("Company", Company);
	Запрос.УстановитьПараметр("Source", Source);
	Запрос.УстановитьПараметр("ДатаНачала", Период.ДатаНачала);
	Запрос.УстановитьПараметр("ДатаОкончания", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("Client", Client);
	Запрос.УстановитьПараметр("CustomerNumber", CustomerNumber);
	Запрос.УстановитьПараметр("Currency", Currency);
	Запрос.УстановитьПараметр("Account", Account);
	Запрос.УстановитьПараметр("LegalEntity", LegalEntity);
	Запрос.УстановитьПараметр("Segment", Segment);
	Запрос.УстановитьПараметр("GeoMarket", GeoMarket);
	Запрос.УстановитьПараметр("SubGeoMarket", SubGeoMarket);
	Запрос.УстановитьПараметр("ManagementGeomarket", ManagementGeomarket);
	Запрос.УстановитьПараметр("ClientID_Document", ClientID_Document);
	
	Если ТипСчета = Перечисления.ТипСчета.AR Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И НЕ ТранзакцияOracle.Account.Код ПОДОБНО ""4%""");
	ИначеЕсли ТипСчета = Перечисления.ТипСчета.Revenue Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И ТранзакцияOracle.Account.Код ПОДОБНО ""4%""");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "");
	КонецЕсли;
	
	Если IcoClients И PredefinedClients Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "(ТранзакцияOracle.Client.Предопределенный ИЛИ ТранзакцияOracle.Client.Intercompany)");
	ИначеЕсли IcoClients Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ТранзакцияOracle.Client.Intercompany");
	ИначеЕсли (PredefinedClients) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ТранзакцияOracle.Client.Предопределенный");
	КонецЕсли;		
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ_Транзакции =  РезультатЗапроса.Выгрузить();
	ТЗ_ТранзакцииБезКонечныхКлиентов = ТЗ_Транзакции.СкопироватьКолонки();
	
	Для каждого Транзакция Из ТЗ_Транзакции Цикл
		ДанныеКлиента = Документы.ТранзакцияOracle.ПолучитьКлиента(Транзакция);
		Если ДанныеКлиента.Клиент.Предопределенный И PredefinedClients ИЛИ ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ДанныеКлиента.Клиент,"Intercompany") И IcoClients Тогда
			НоваяСтрока = ТЗ_ТранзакцииБезКонечныхКлиентов.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока,Транзакция);
			РеквизитыТранзакции = Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(НоваяСтрока.Ссылка);
			НоваяСтрока.Amount = РеквизитыТранзакции.Amount;
			НоваяСтрока.BaseAmount = РеквизитыТранзакции.BaseAmount;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ТЗ_ТранзакцииБезКонечныхКлиентов;
	
КонецФункции

&НаКлиенте
Процедура SourceПриИзменении(Элемент)
	
	Если Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") ИЛИ Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleSmith") Тогда
		Элементы.Client.Доступность = Ложь;
	Иначе
		Элементы.Client.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьТранзакции(Команда)
	
	Если НЕ IcoClients И НЕ PredefinedClients Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Client type is not selected. Select ""Ico Clients"" or ""Predefined Clients""");
	Иначе
		ОтобразитьТранзакцииНаСервере();
		ИтоговаяСумма = 0;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТранзакцийApplyПриИзменении(Элемент)
	
	Если Элементы.ТаблицаТранзакций.ТекущиеДанные.Apply Тогда
		ИтоговаяСумма = ИтоговаяСумма + Элементы.ТаблицаТранзакций.ТекущиеДанные.BaseAmount;
	Иначе
		ИтоговаяСумма = ИтоговаяСумма - Элементы.ТаблицаТранзакций.ТекущиеДанные.BaseAmount;
	КонецЕсли;
	
КонецПроцедуры

