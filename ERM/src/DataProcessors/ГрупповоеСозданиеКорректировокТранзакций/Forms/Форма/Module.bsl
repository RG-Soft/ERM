
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
		ЗаполнитьЗначенияСвойств(КорректировкаТразакции, СтрокаТранзакции, "Company,Account,Currency,AU,LegalEntity");
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
		|	ТранзакцияHOB.Номер,
		|	ТранзакцияHOB.Account,
		|	ТранзакцияHOB.Amount,
		|	ТранзакцияHOB.BaseAmount,
		|	ТранзакцияHOB.Client,
		|	ТранзакцияHOB.Company,
		|	ТранзакцияHOB.Currency,
		|	ТранзакцияHOB.CustomerNumber,
		|	"""" КАК CreatedByName,
		|	"""" КАК Description,
		|	ТранзакцияHOB.AU,
		|	ТранзакцияHOB.LegalEntity,
		|	ТранзакцияHOB.Ссылка
		|ИЗ
		|	Документ.ТранзакцияHOB КАК ТранзакцияHOB
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|		ПО ТранзакцияHOB.Ссылка = КорректировкаТранзакции.ДокументОснование
		|			И (НЕ КорректировкаТранзакции.ПометкаУдаления)
		|ГДЕ
		|	ТранзакцияHOB.Проведен
		|	И ТранзакцияHOB.Дата <= &ДатаОкончания
		|	И ТранзакцияHOB.Дата >= &ДатаНачала
		|	&УсловиеСчета
		|	И (&Company = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) ИЛИ ТранзакцияHOB.Company = &Company)
		|	И (&Client = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ИЛИ ТранзакцияHOB.Client = &Client)
		|	И (&CustomerNumber = """" ИЛИ ТранзакцияHOB.CustomerNumber = &CustomerNumber)
		|	И (&Currency = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) ИЛИ ТранзакцияHOB.Currency = &Currency)
		|	И (&LegalEntity = ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка) ИЛИ ТранзакцияHOB.LegalEntity = &LegalEntity)
		|	И (&Account = Неопределено ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Oracle.ПустаяСсылка) ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Lawson.ПустаяСсылка) ИЛИ ТранзакцияHOB.Account = &Account)
		|	И (&AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка) ИЛИ ТранзакцияHOB.AU = &AU)
		|	И &УсловиеПоКлиенту
		|	И КорректировкаТранзакции.Ссылка ЕСТЬ NULL
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
	
	Если ТипСчета = Перечисления.ТипСчета.AR Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И НЕ ТранзакцияHOB.Account.Код ПОДОБНО ""4%""");
	ИначеЕсли ТипСчета = Перечисления.ТипСчета.Revenue Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И ТранзакцияHOB.Account.Код ПОДОБНО ""4%""");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "");
	КонецЕсли;
	
	Если IcoClients И PredefinedClients Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ТранзакцияHOB.Client.Предопределенный ИЛИ ТранзакцияHOB.Client.Intercompany");
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
		|	ПроводкаDSS.Номер,
		|	ПроводкаDSS.Company,
		|	ПроводкаDSS.Currency,
		|	ПроводкаDSS.Description,
		|	ПроводкаDSS.CustomerNumber,
		|	"""" КАК CreatedByName,
		|	ПроводкаDSS.AU,
		|	ПроводкаDSS.LegalEntity,
		|	ПроводкаDSS.AccountLawson КАК Account,
		|	ПроводкаDSS.КонтрагентLawson КАК Client,
		|	ПроводкаDSS.TranAmount КАК Amount,
		|	ПроводкаDSS.BaseAmount,
		|	ПроводкаDSS.Ссылка
		|ИЗ
		|	Документ.ПроводкаDSS КАК ПроводкаDSS
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|		ПО ПроводкаDSS.Ссылка = КорректировкаТранзакции.ДокументОснование
		|			И (НЕ КорректировкаТранзакции.ПометкаУдаления)
		|ГДЕ
		|	ПроводкаDSS.Проведен
		|	И ПроводкаDSS.DateLawson <= &ДатаОкончания
		|	И ПроводкаDSS.DateLawson >= &ДатаНачала
		|	&УсловиеСчета
		|	И (&Company = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) ИЛИ ПроводкаDSS.Company = &Company)
		|	И (&Client = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ИЛИ ПроводкаDSS.КонтрагентLawson = &Client)
		|	И (&CustomerNumber = """" ИЛИ ПроводкаDSS.CustomerNumber = &CustomerNumber)
		|	И (&Currency = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) ИЛИ ПроводкаDSS.Currency = &Currency)
		|	И (&LegalEntity = ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка) ИЛИ ПроводкаDSS.LegalEntity = &LegalEntity)
		|	И (&Account = Неопределено ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Oracle.ПустаяСсылка) ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Lawson.ПустаяСсылка) ИЛИ ПроводкаDSS.AccountLawson = &Account)
		|	И (&AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка) ИЛИ ПроводкаDSS.AU = &AU)
		|	И &УсловиеПоКлиенту
		|	И КорректировкаТранзакции.Ссылка ЕСТЬ NULL
		|УПОРЯДОЧИТЬ ПО
		|	ПроводкаDSS.Номер";
	
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
	
	Если ТипСчета = Перечисления.ТипСчета.AR Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И НЕ ПроводкаDSS.AccountLawson.Код ПОДОБНО ""4%""");
	ИначеЕсли ТипСчета = Перечисления.ТипСчета.Revenue Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И ПроводкаDSS.AccountLawson.Код ПОДОБНО ""4%""");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "");
	КонецЕсли;
	
	Если IcoClients И PredefinedClients Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ПроводкаDSS.КонтрагентLawson.Предопределенный ИЛИ ПроводкаDSS.КонтрагентLawson.Intercompany");
	ИначеЕсли IcoClients Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ПроводкаDSS.КонтрагентLawson.Intercompany");
	ИначеЕсли (PredefinedClients) Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ПроводкаDSS.КонтрагентLawson.Предопределенный");
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
		|	ТранзакцияOracle.Номер,
		|	ТранзакцияOracle.Account,
		|	ТранзакцияOracle.Amount,
		|	ТранзакцияOracle.BaseAmount,
		|	ТранзакцияOracle.Client,
		|	ТранзакцияOracle.EndClient,
		|	ТранзакцияOracle.Company,
		|	ТранзакцияOracle.Currency,
		|	ТранзакцияOracle.Description,
		|	ТранзакцияOracle.CustomerNumber,
		|	ТранзакцияOracle.EndCustomerNumber,
		|	ТранзакцияOracle.CreatedByName,
		|	ТранзакцияOracle.AU,
		|	ТранзакцияOracle.LegalEntity,
		|	ТранзакцияOracle.Source,
		|	ТранзакцияOracle.Ссылка
		|ИЗ
		|	Документ.ТранзакцияOracle КАК ТранзакцияOracle
		|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|		ПО ТранзакцияOracle.Ссылка = КорректировкаТранзакции.ДокументОснование
		|			И (НЕ КорректировкаТранзакции.ПометкаУдаления)
		|ГДЕ
		|	ТранзакцияOracle.Проведен
		|	И ТранзакцияOracle.Дата <= &ДатаОкончания
		|	И ТранзакцияOracle.Дата >= &ДатаНачала
		|	&УсловиеСчета
		|	И (&Company = ЗНАЧЕНИЕ(Справочник.Организации.ПустаяСсылка) ИЛИ ТранзакцияOracle.Company = &Company)
		|	И (&Client = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ИЛИ ТранзакцияOracle.Client = &Client)
		|	И (&CustomerNumber = """" ИЛИ ТранзакцияOracle.CustomerNumber = &CustomerNumber)
		|	И (&Currency = ЗНАЧЕНИЕ(Справочник.Валюты.ПустаяСсылка) ИЛИ ТранзакцияOracle.Currency = &Currency)
		|	И (&LegalEntity = ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка) ИЛИ ТранзакцияOracle.LegalEntity = &LegalEntity)
		|	И (&Account = Неопределено ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Oracle.ПустаяСсылка) ИЛИ &Account = ЗНАЧЕНИЕ(ПланСчетов.Lawson.ПустаяСсылка) ИЛИ ТранзакцияOracle.Account = &Account)
		|	И (&AU = ЗНАЧЕНИЕ(Справочник.КостЦентры.ПустаяСсылка) ИЛИ ТранзакцияOracle.AU = &AU)
		|	И &УсловиеПоКлиенту
		|	И ТранзакцияOracle.Source = &Source
		|	И КорректировкаТранзакции.Ссылка ЕСТЬ NULL
		|УПОРЯДОЧИТЬ ПО
		|	ТранзакцияOracle.Номер
		|";
	
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
	
	Если ТипСчета = Перечисления.ТипСчета.AR Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И НЕ ТранзакцияOracle.Account.Код ПОДОБНО ""4%""");
	ИначеЕсли ТипСчета = Перечисления.ТипСчета.Revenue Тогда 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "И ТранзакцияOracle.Account.Код ПОДОБНО ""4%""");
	Иначе 
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеСчета", "");
	КонецЕсли;
	
	Если IcoClients И PredefinedClients Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "&УсловиеПоКлиенту", "ТранзакцияOracle.Client.Предопределенный ИЛИ ТранзакцияOracle.Client.Intercompany");
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

