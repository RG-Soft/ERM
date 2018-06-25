
#Область ОбработчикиФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ИнициализацияНачальныхЗначений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиЭлементовФормы

&НаКлиенте
Процедура ОбновитьДанные(Команда)
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаПоДокументам Тогда
		Состояние("Производится загрузка документов, подождите...");
		ОбновитьСпискиПоДокументам();		
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаПоПроводкам Тогда
		Состояние("Производится вывод проводок, подождите...");
		ОбновитьСпискиПоПроводкам();
	Иначе
		Сообщить("Вкладка не обрабатывается");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДокиПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элементы.Доки.ВыделенныеСтроки.Количество() = 1 Тогда
		ДокиПриАктивизацииСтрокиОбработчикОжидания()
	Иначе
		ПодключитьОбработчикОжидания("ДокиПриАктивизацииСтрокиОбработчикОжидания", 1, Истина);	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПериод(НовыйПериод)

	ПериодОбработки = НовыйПериод;
	ПредставлениеПериода = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"), 
		НачалоМесяца(ПериодОбработки),
		КонецМесяца(ПериодОбработки));
	
КонецПроцедуры 

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПараметрыВыбора = Новый Структура("НачалоПериода,КонецПериода", 
		ПериодОбработки, КонецМесяца(ПериодОбработки));
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, Элементы.ПредставлениеПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИзменитьПериод(ВыбранноеЗначение.НачалоПериода);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьПериод(Команда)
	
	ИзменитьПериод(НачалоМесяца(ПериодОбработки - 1));
	
КонецПроцедуры

&НаКлиенте
Процедура УвеличитьПериод(Команда)
	
	ИзменитьПериод(КонецМесяца(ПериодОбработки) + 1);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеSystemПриИзменении(Элемент)
	
	ИспользоватьОтборSystem = ЗначениеЗаполнено(ЗначениеSystem);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеAccountПриИзменении(Элемент)
	
	ИспользоватьОтборAccount = ЗначениеЗаполнено(ЗначениеAccount);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеAUПриИзменении(Элемент)
	
	ИспользоватьОтборAU = ЗначениеЗаполнено(ЗначениеAU);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеTypeПриИзменении(Элемент)
	
	ИспользоватьОтборType = ЗначениеЗаполнено(ЗначениеType);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗначениеТипДокументаПриИзменении(Элемент)
	
	ИспользоватьОтборТипДокумента = ЗначениеЗаполнено(ЗначениеТипДокумента);
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьОтборТипДокументаПриИзменении(Элемент)

	Если ИспользоватьОтборТипДокумента И НЕ ЗначениеЗаполнено(ЗначениеТипДокумента) Тогда
		ИспользоватьОтборТипДокумента = Ложь;
		Сообщить("Необходимо выбрать тип документа!");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисоединенныеФайлы(Команда)
	
	ТекДанные  = Элементы.ПроводкиDSSОбщие.ТекущиеДанные;	
	Если ТекДанные <> Неопределено Тогда
		Если ТипЗнч(ТекДанные.Регистратор) = Тип("ДокументСсылка.ПроводкаDSS") Тогда
			Если ТипЗнч(ТекДанные.Документ) = Тип("ДокументСсылка.СчетКнигиПокупок") Тогда 
				ТекущийСКП = ТекДанные.Документ;
				ПараметрыФормы = Новый Структура("ВладелецФайла, ТолькоПросмотр", ТекущийСКП, Ложь);
				ОткрытьФорму("ОбщаяФорма.ДвоичныеДанныеФайлов", ПараметрыФормы, ЭтаФорма);
			КонецЕсли;
		КонецЕсли;                    			
	КонецЕсли;  	
	
КонецПроцедуры

&НаКлиенте
Процедура ПроводкиDSSОбщиеПриАктивизацииСтроки(Элемент)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Детали.Очистить();
	Иначе		
		ВывестиДетали(Элемент.ТекущиеДанные.GltObjId);		
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#Область ОсновныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСпискиПоДокументам()
	
	ПостроительЗапроса = ИнициализироватьПолучитьПостроительЗапроса();		
	ПостроительЗапроса.Выполнить();
	Объект.Доки.Загрузить(ПостроительЗапроса.Результат.Выгрузить());	 
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборы(ПостроительЗапроса = Неопределено)
	
	Если НЕ ПостроительЗапроса = Неопределено Тогда
		
		ПостроительЗапроса.Отбор.Добавить("System");
		ПостроительЗапроса.Отбор.Добавить("AccountLawson");
		ПостроительЗапроса.Отбор.AccountLawson.ВидСравнения = ВидСравнения.ВСпискеПоИерархии;
		ПостроительЗапроса.Отбор.Добавить("AU");
		ПостроительЗапроса.Отбор.AU.ВидСравнения 			= ВидСравнения.ВСписке;
		ПостроительЗапроса.Отбор.Добавить("FiscalType");
		ПостроительЗапроса.Отбор.FiscalType.ВидСравнения 	= ВидСравнения.ВИерархии;	
		
		Если ИспользоватьОтборSystem Тогда
			ПостроительЗапроса.Отбор.System.Использование 			= Истина;
			ПостроительЗапроса.Отбор.System.Значение 				= ЗначениеSystem;
		КонецЕсли;
		
		Если ИспользоватьОтборAccount Тогда
			ПостроительЗапроса.Отбор.AccountLawson.Использование 	= Истина;
			ПостроительЗапроса.Отбор.AccountLawson.Значение 		= ЗначениеСчетаДляОтбора(ЗначениеAccount);
		КонецЕсли;
		
		Если ИспользоватьОтборAU Тогда
			ПостроительЗапроса.Отбор.AU.Использование 				= Истина;
			ПостроительЗапроса.Отбор.AU.Значение 					= ЗначениеAUДляОтбора(ПериодОбработки, ЗначениеAU);
		КонецЕсли; 
		
		Если ИспользоватьОтборType Тогда
			ПостроительЗапроса.Отбор.FiscalType.Использование		= Истина;
			ПостроительЗапроса.Отбор.FiscalType.Значение 			= ЗначениеType;
		КонецЕсли; 
		
		ПостроительЗапроса.Параметры.Вставить("НачалоПериода", 	НачалоМесяца(ПериодОбработки));
		ПостроительЗапроса.Параметры.Вставить("КонецПериода",  	КонецМесяца(ПериодОбработки));
		ПостроительЗапроса.Параметры.Вставить("ОтбиратьПоТипу",	ИспользоватьОтборТипДокумента);
		
	Иначе
		
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "Период", 	НачалоМесяца(ПериодОбработки), ВидСравненияКомпоновкиДанных.БольшеИлиРавно);
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "Период",	 	КонецМесяца(ПериодОбработки),  ВидСравненияКомпоновкиДанных.МеньшеИлиРавно);
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "GltObjId", 	1000000000,  				   ВидСравненияКомпоновкиДанных.Больше);     		
		Если ИспользоватьОтборSystem Тогда
			ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "System", ЗначениеSystem,  ВидСравненияКомпоновкиДанных.Равно);
		КонецЕсли;  		
		Если ИспользоватьОтборAccount Тогда
			ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "AccountLawson", ЗначениеСчетаДляОтбора(ЗначениеAccount),  ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии);
		КонецЕсли;  		
		Если ИспользоватьОтборAU Тогда
			ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "AU", ЗначениеAUДляОтбора(ПериодОбработки, ЗначениеAU),  ВидСравненияКомпоновкиДанных.ВСписке);
		КонецЕсли;     		
		Если ИспользоватьОтборType Тогда
			ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "FiscalType", ЗначениеType,  ВидСравненияКомпоновкиДанных.ВИерархии);
		КонецЕсли; 
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьСпискиПоПроводкам()
	
	ПроводкиDSSОбщие.Отбор.Элементы.Очистить();	
	УстановитьОтборы(); 		               
		
КонецПроцедуры

&НаСервере
Процедура ВывестиДетали(ID)
	
	Детали.Очистить();

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ПроводкаDSS.Номер КАК GltObjId,
	|	ПроводкаDSS.GeoMarket,
	|	ПроводкаDSS.UpdateDateLawson,
	|	ПроводкаDSS.SeqTrnsNbrLawson,
	|	ПроводкаDSS.OrigCompanyLawson,
	|	ПроводкаDSS.Activity,
	|	ПроводкаDSS.SourceCode,
	|	ПроводкаDSS.System,
	|	ПроводкаDSS.JeTypeLawson,
	|	ПроводкаDSS.JournalLawson,
	|	ПроводкаDSS.LineNbrLawson,
	|	ПроводкаDSS.AutoRevLawson,
	|	ПроводкаDSS.Operator,
	|	ПроводкаDSS.LegalFiscalFlagLawson,
	|	ПроводкаDSS.Vendor,
	|	ПроводкаDSS.VendorVname,
	|	ПроводкаDSS.ApInvoice,
	|	ПроводкаDSS.TransNbr,
	|	ПроводкаDSS.OrigOperatorId,
	|	ПроводкаDSS.ProcessLevel,
	|	ПроводкаDSS.CashCode,
	|	ПроводкаDSS.PoNumber,
	|	ПроводкаDSS.LineNbrIc,
	|	ПроводкаDSS.PoCode,
	|	ПроводкаDSS.AssetLawson,
	|	ПроводкаDSS.ItemDescription,
	|	ПроводкаDSS.CustomerNumber,
	|	ПроводкаDSS.CustomerName,
	|	ПроводкаDSS.ArInvoice,
	|	ПроводкаDSS.TaxCode,
	|	ПроводкаDSS.Item,
	|	ПроводкаDSS.DocumentNbr,
	|	ПроводкаDSS.ContractNumber,
	|	ПроводкаDSS.AktOfAcceptance,
	|	ПроводкаDSS.AktDateLawson,
	|	ПроводкаDSS.ApTransFormId,
	|	ПроводкаDSS.Модуль,
	|	ПроводкаDSS.AccountLawson,
	|	ПроводкаDSS.Company,
	|	ПроводкаDSS.BaseAmount,
	|	ПроводкаDSS.Reference,
	|	ПроводкаDSS.Description,
	|	ПроводкаDSS.Currency,
	|	ПроводкаDSS.TranAmount,
	|	ПроводкаDSS.КонтрагентLawson.Код КАК Код,
	|	ПроводкаDSS.КонтрагентLawson.Наименование КАК Наименование
	|ИЗ
	|	Документ.ПроводкаDSS КАК ПроводкаDSS
	|ГДЕ
	|	ПроводкаDSS.Номер = &GltObjId";
	
	Запрос.УстановитьПараметр("GltObjId", ID);
	
	Результат = Запрос.Выполнить().Выгрузить();
	Если Результат.Количество() Тогда
		Запись = Результат[0];
	КонецЕсли;
	Если ЗначениеЗаполнено(Запись) Тогда
		Для Каждого Колонка Из Результат.Колонки Цикл
			Если  ЗначениеЗаполнено(Запись[Колонка.Имя]) ТОгда
				Выполнить("	Строка = Детали.Добавить();
				|Строка.ИмяПоля = Колонка.Имя;
				|Строка.Значение = Запись." + Колонка.Имя + ";
				|Если Колонка.Имя = ""Код"" Тогда Строка.ИмяПоля = ""Код контрагента Lawson""; КонецЕсли;
				|Если Колонка.Имя = ""Наименование"" Тогда Строка.ИмяПоля = ""Наименование контрагента Lawson""; КонецЕсли;"); 
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры   
#КонецОбласти

#Область ДополнительныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ЗначениеСчетаДляОтбора(Счет)
	
	ТекстОтбора = СтрЗаменить(Счет, "*", "%");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
					|	Lawson.Ссылка
					|ИЗ
					|	ПланСчетов.Lawson КАК Lawson
					|ГДЕ
					|	Lawson.Код ПОДОБНО &Код");
	Запрос.УстановитьПараметр("Код", ТекстОтбора);
	Список = новый СписокЗначений;
	Список.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат Список;
	
КонецФункции

&НаСервереБезКонтекста
Функция ЗначениеAUДляОтбора(Дата, ИмяAU)
	
	ТекстОтбора = СтрЗаменить(ИмяAU, "*", "%");
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                       |	СегментыКостЦентровСрезПоследних.КостЦентр КАК Ссылка
	                       |ИЗ
	                       |	РегистрСведений.СегментыКостЦентров.СрезПоследних(&Дата, Код ПОДОБНО &Код) КАК СегментыКостЦентровСрезПоследних");
	Запрос.УстановитьПараметр("Дата", НачалоМесяца(Дата));
	Запрос.УстановитьПараметр("Код", ТекстОтбора);
	Список = новый СписокЗначений;
	Список.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка"));
	
	Возврат Список;
	
КонецФункции

#КонецОбласти

#Область ПроцедурыИФункцииОбщегоФункционала

&НаСервере
Функция ИдентификаторыИДокументыПроводок()                      
	
	Если ПрименениеДействийДляВсех Тогда
		
		ПостроительЗапроса = ИнициализироватьПолучитьПостроительЗапроса();				                		
		
		Если ПостроительЗапроса.Параметры.Свойство("ОтбиратьПоТипу") И ПостроительЗапроса.Параметры.ОтбиратьПоТипу И ЗначениеЗаполнено(ЗначениеТипДокумента) Тогда
			ТипДокументаДляОтбора = ЗначениеТипДокумента;
		Иначе
			ТипДокументаДляОтбора = "ОперацияLawson";
		КонецЕсли;
		
		ПостроительЗапроса.Текст = 	"ВЫБРАТЬ
		|	ПроводкиDSSОбщие.Регистратор,
		|	ПроводкиDSSОбщие.GltObjId КАК ID
		|{ВЫБРАТЬ
		|	ПроводкиDSSОбщие.Регистратор,
		|	ПроводкиDSSОбщие.BaseAmount}
		|ИЗ
		|	РегистрНакопления.ПроводкиDSSОбщие КАК ПроводкиDSSОбщие
		|ГДЕ
		|	ПроводкиDSSОбщие.Период МЕЖДУ &НачалоПериода И &КонецПериода
		|	И ((НЕ &ОтбиратьПоТипу)
		|			ИЛИ ПроводкиDSSОбщие.Регистратор.Документ ССЫЛКА Документ."+ ТипДокументаДляОтбора + ")
		|{ГДЕ
		|	ПроводкиDSSОбщие.AccountLawson КАК AccountLawson,
		|	ПроводкиDSSОбщие.FiscalType КАК FiscalType,
		|	ПроводкиDSSОбщие.System,
		|	ПроводкиDSSОбщие.AU}";					
		
		ПостроительЗапроса.Выполнить(); 		
		ВременнаяТаблица = ПостроительЗапроса.Результат.Выгрузить();
		
	Иначе
		
		Если Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницаПоДокументам Тогда
			
			ТаблицаДокументов = Новый ТаблицаЗначений;
			ТаблицаДокументов.Колонки.Добавить("Документ", Метаданные.Документы.ПроводкаDSS.Реквизиты.Документ.Тип);
			
			Для Каждого ИдентификаторСтроки Из Элементы.Доки.ВыделенныеСтроки Цикл
				НовСтрока = ТаблицаДокументов.Добавить();
				НовСтрока.Документ = Объект.Доки.НайтиПоИдентификатору(ИдентификаторСтроки).Док;
			КонецЦикла;
			
			Запрос = Новый Запрос;
			Запрос.Параметры.Вставить("ТаблицаДокументов", ТаблицаДокументов); 
			Запрос.Текст = "ВЫБРАТЬ
			               |	ТаблицаДокументов.Документ КАК ДокументПроводки
			               |ПОМЕСТИТЬ Документы
			               |ИЗ
			               |	&ТаблицаДокументов КАК ТаблицаДокументов
			               |;
			               |
			               |////////////////////////////////////////////////////////////////////////////////
			               |ВЫБРАТЬ
			               |	ПроводкаDSS.Номер КАК ID,
			               |	ПроводкаDSS.Ссылка КАК Регистратор
			               |ИЗ
			               |	Документ.ПроводкаDSS КАК ПроводкаDSS
			               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документы КАК Документы
			               |		ПО ПроводкаDSS.Документ = Документы.ДокументПроводки"; 
			
			ВременнаяТаблица = Запрос.Выполнить().Выгрузить();
			
		Иначе
			
			ВременнаяТаблица = Новый ТаблицаЗначений;
			ВременнаяТаблица.Колонки.Добавить("Регистратор");
			ВременнаяТаблица.Колонки.Добавить("ID");
			
			Для Каждого ВыделеннаяСтрока Из Элементы.ПроводкиDSSОбщие.ВыделенныеСтроки Цикл
				СтрокаВТ = ВременнаяТаблица.Добавить();
				СтрокаВТ.Регистратор = ВыделеннаяСтрока.Регистратор;
				СтрокаВТ.ID		 	 = ВыделеннаяСтрока.Регистратор.Номер;  				
			КонецЦикла;
			
		КонецЕсли; 
		
	КонецЕсли;
	          	
	табИдентификаторы = ВременнаяТаблица.Скопировать(,"ID");
	табИдентификаторы.Индексы.Добавить("ID");
	
	табДокументы = ВременнаяТаблица.Скопировать(,"Регистратор");
	табДокументы.Свернуть("Регистратор");
	
	Возврат Новый Структура("Идентификаторы, Документы", табИдентификаторы.ВыгрузитьКолонку("ID"), табДокументы);
		
КонецФункции

&НаСервереБезКонтекста
Функция РазбитьТаблицуПоместитьВХранилища(Таблица)
	
	ТЗПорция 	  = Таблица.СкопироватьКолонки(); 		
	МассивАдресов = Новый Массив;
	
	КоличествоВПорции = Мин(Макс(Таблица.Количество() / 100, 15), 200); // количество в порции, в зависимости от общего количества не меньше 15, но не больше 200
	
	Для СчетчикСтрок = 0 По Таблица.Количество() - 1 Цикл
		
		СтрокаРезультата = Таблица[СчетчикСтрок];
		
		Если ТЗПорция.Количество() >= КоличествоВПорции Тогда     			                                                  							
			УникальныйИдентификаторПорции 	= Новый УникальныйИдентификатор;
			КопияТЗПорция = ТЗПорция.Скопировать();
			АдресПорцииВХ = ПоместитьВоВременноеХранилище(КопияТЗПорция, УникальныйИдентификаторПорции); //Потому что она очищается
			МассивАдресов.Добавить(АдресПорцииВХ);		
			ТЗПорция.Очистить();    		
		КонецЕсли;			
		
		СтрокаПорции 	= ТЗПорция.Добавить();			
		ЗаполнитьЗначенияСвойств(СтрокаПорции, СтрокаРезультата);	 			
		
	КонецЦикла;
	
	УникальныйИдентификаторПорции 	= Новый УникальныйИдентификатор;
	КопияТЗПорция = ТЗПорция.Скопировать();
	АдресПорцииВХ = ПоместитьВоВременноеХранилище(КопияТЗПорция, УникальныйИдентификаторПорции);				
	МассивАдресов.Добавить(АдресПорцииВХ);		
	ТЗПорция.Очистить(); 
	
	Возврат МассивАдресов;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстЗапроса(Тип = "ОперацияLawson")
	
	Возврат "ВЫБРАТЬ
	        |	ПроводкиDSSОбщие.Регистратор.Документ КАК Док,
	        |	МАКСИМУМ(ПроводкиDSSОбщие.Регистратор.Operator) КАК Оператор
	        |ПОМЕСТИТЬ Доки
	        |{ВЫБРАТЬ
	        |	ПроводкиDSSОбщие.Регистратор.Документ,
	        |	ПроводкиDSSОбщие.BaseAmount}
	        |ИЗ
	        |	РегистрНакопления.ПроводкиDSSОбщие КАК ПроводкиDSSОбщие
	        |ГДЕ
	        |	ПроводкиDSSОбщие.Период МЕЖДУ &НачалоПериода И &КонецПериода
	        |	И ((НЕ &ОтбиратьПоТипу)
	        |			ИЛИ ПроводкиDSSОбщие.Регистратор.Документ ССЫЛКА Документ." + Тип + ")
			|	И ПроводкиDSSОбщие.Регистратор ССЫЛКА Документ.ПроводкаDSS
			|   И ПроводкиDSSОбщие.GltObjId > 1000000000
			|{ГДЕ
	        |	ПроводкиDSSОбщие.AccountLawson КАК AccountLawson,
	        |	ПроводкиDSSОбщие.FiscalType КАК FiscalType,
	        |	ПроводкиDSSОбщие.System,
	        |	ПроводкиDSSОбщие.AU}
	        |
	        |СГРУППИРОВАТЬ ПО
	        |	ПроводкиDSSОбщие.Регистратор.Документ
	        |
	        |ИНДЕКСИРОВАТЬ ПО
	        |	Док,
	        |	Оператор
	        |;
	        |
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
	        |	ПроводкиDSSОбщие.Регистратор.Документ КАК Документ,
	        |	СУММА(ВЫБОР
	        |			КОГДА ПроводкиDSSОбщие.BaseAmountОборот > 0
	        |				ТОГДА ПроводкиDSSОбщие.BaseAmountОборот
	        |			ИНАЧЕ 0
	        |		КОНЕЦ) КАК BaseAmount
	        |ПОМЕСТИТЬ Суммы
	        |ИЗ
	        |	РегистрНакопления.ПроводкиDSSОбщие.Обороты(&НачалоПериода, &КонецПериода, Запись, ) КАК ПроводкиDSSОбщие
	        |ГДЕ
			|	ПроводкиDSSОбщие.Регистратор ССЫЛКА Документ.ПроводкаDSS
			|   И ПроводкиDSSОбщие.Регистратор.Номер > 1000000000 
	        |СГРУППИРОВАТЬ ПО
	        |	ПроводкиDSSОбщие.Регистратор.Документ
	        |;
	        |                                                                        
	        |////////////////////////////////////////////////////////////////////////////////
	        |ВЫБРАТЬ
			|	Доки.Док,
			|	Доки.Оператор,
			|	ЕСТЬNULL(Суммы.BaseAmount, 0) КАК Сумма
			|{ВЫБРАТЬ
			|	Док,
			|	Сумма}
			|ИЗ
			|	Доки КАК Доки
			|		ЛЕВОЕ СОЕДИНЕНИЕ Суммы КАК Суммы
			|		ПО Доки.Док = Суммы.Документ";   	
	
			
КонецФункции

&НаСервере
Функция ИнициализироватьПолучитьПостроительЗапроса()
	
	ПостроительЗапроса = Новый ПостроительЗапроса;	
	
	Если ИспользоватьОтборТипДокумента Тогда
		ПостроительЗапроса.Текст = ПолучитьТекстЗапроса(ЗначениеТипДокумента);
	Иначе
		ПостроительЗапроса.Текст = ПолучитьТекстЗапроса();
	КонецЕсли;
	
	УстановитьОтборы(ПостроительЗапроса);			

	Возврат ПостроительЗапроса;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ИнициализацияНачальныхЗначений()
	
	//Период
	ПериодОбработки		 = НачалоМесяца(ТекущаяДата());	
	ПредставлениеПериода = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(Перечисления.ДоступныеПериодыОтчета.Месяц, НачалоМесяца(ПериодОбработки), КонецМесяца(ПериодОбработки)); 
	
	//Список возможных System
	СписокДопустимыеSystem = Новый Массив;
	СписокДопустимыеSystem.Добавить("AP");
	СписокДопустимыеSystem.Добавить("AM");
	СписокДопустимыеSystem.Добавить("BL");
	СписокДопустимыеSystem.Добавить("GL");
	СписокДопустимыеSystem.Добавить("IC");
	СписокДопустимыеSystem.Добавить("AR");
	СписокДопустимыеSystem.Добавить("PO");
	СписокДопустимыеSystem.Добавить("CB");
	СписокДопустимыеSystem.Добавить("RJ");      	
	Элементы.ЗначениеSystem.СписокВыбора.ЗагрузитьЗначения(СписокДопустимыеSystem);
	
	//Типы возможных документов для отбора
	Элементы.ЗначениеТипДокумента.СписокВыбора.Очистить();
	Для Каждого МетаданныеДокумента Из Метаданные.Документы Цикл
		Если МетаданныеДокумента.Движения.Содержит(РегистрыНакопления.ПроводкиDSSОбщие.СоздатьНаборЗаписей().Метаданные()) Тогда
			Элементы.ЗначениеТипДокумента.СписокВыбора.Добавить(МетаданныеДокумента.Имя, МетаданныеДокумента.Синоним); 
		КонецЕсли;
	КонецЦикла;
	
	//Сбрасываем отбор в динамическом списке проводок по документу
	ПроводкиDSSПоДокументу.Параметры.УстановитьЗначениеПараметра("ТекДокумент", Неопределено);	
	
	//Сбрасываем отбор в динамическом списке проводок
	ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(ПроводкиDSSОбщие, "GltObjId", -1, ВидСравненияКомпоновкиДанных.Равно);
	
	СтруктураИндикации = Новый Структура;	
	
КонецПроцедуры

&НаСервере
Функция НетВыделенныхСтрок()
	
	Если НЕ Элементы.ПроводкиDSSОбщие.ВыделенныеСтроки.Количество() И НЕ Элементы.Доки.ВыделенныеСтроки.Количество() Тогда
		Сообщить("Выберите строки!");
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ДокиПриАктивизацииСтрокиОбработчикОжидания() Экспорт
	
	ПроводкиDSSПоДокументу.Параметры.УстановитьЗначениеПараметра("ТекДокумент", Элементы.Доки.ТекущиеДанные.Док);	
	
КонецПроцедуры

&НаКлиенте
Функция ЕстьВыделенныеСтроки()
	
	НетВыделенныхСтрок 	= НЕ (Элементы.ПроводкиDSSОбщие.ВыделенныеСтроки.Количество() ИЛИ Элементы.Доки.ВыделенныеСтроки.Количество());
	
	Если НетВыделенныхСтрок Тогда
		Сообщить("Выберите строки!");
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;     	
	
КонецФункции

#КонецОбласти

//Для упрощения сопровождения вынесены отдельно:

#Область ПрименениеФильтра

&НаКлиенте
Процедура ПрименитьФильтр(Команда)
	
	НельзяПрименитьФильтр = НЕ ПрименениеДействийДляВсех И НЕ ЕстьВыделенныеСтроки();	
	Если НельзяПрименитьФильтр Тогда
		Возврат;
	КонецЕсли;    	
	
	Состояние("Производится подготовка данных для применения фильтра, подождите...");
	ПодготовитьДанныеДляПримененияФильтраСервер();
	
	Состояние("Применение фильтров", 0, "Проведение документов по регистрам");		
	
	Для Счетчик = 1 По СтруктураИндикации.КоличествоПорций Цикл
		Обработано = 0;
		ПрименитьФильтрНаСервере(АдресВременногоХранилищаФормы, Счетчик - 1, Обработано);	
		СтруктураИндикации.ТекущееЗначениеИндикатора = СтруктураИндикации.ТекущееЗначениеИндикатора + Обработано;
		Состояние("Применение фильтров", СтруктураИндикации.ТекущееЗначениеИндикатора * 100 / СтруктураИндикации.МаксимумИндикатораПрогресса, "Проведение документов по регистрам " + СтруктураИндикации.ТекущееЗначениеИндикатора + "/" + СтруктураИндикации.МаксимумИндикатораПрогресса);		
		ОбновитьОтображениеДанных(); 	
	КонецЦикла;        	

	УдалитьИзВременногоХранилища(АдресВременногоХранилищаФормы);
	
	ДокиПриАктивизацииСтроки(Элементы.Доки);   
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьДанныеДляПримененияФильтраСервер()
	
	ДанныеПроводок = ИдентификаторыИДокументыПроводок();

	ДанныеПроводокDSS = ОбработкаDSSСервер.ПолучитьДанныеРегистровПроводокDSS(ДанныеПроводок.Идентификаторы);
	
	//Создаем фильтр
	ДеревоФильтров = Новый ДеревоЗначений;
	ДеревоФильтров.Колонки.Добавить("Код");
	ДеревоФильтров.Колонки.Добавить("Наименование");
	ДеревоФильтров.Колонки.Добавить("КодВыполнения");
	ДеревоФильтров.Колонки.Добавить("Статья");
	ДеревоФильтров.Колонки.Добавить("Тип");
	ДеревоФильтров.Колонки.Добавить("Модуль");
	ОбработкаDSSСервер.ЗаполнитьДеревоЗначений(Неопределено, ДеревоФильтров);   	
	
	МассивАдресов = РазбитьТаблицуПоместитьВХранилища(ДанныеПроводокDSS);
	
	СтруктураИндикации.Вставить("МаксимумИндикатораПрогресса", ДанныеПроводокDSS.Количество());
	СтруктураИндикации.Вставить("ТекущееЗначениеИндикатора",   0);
	СтруктураИндикации.Вставить("КоличествоПорций",   		   МассивАдресов.Количество());
	
	ДанныеДлительнойОбработки = Новый Структура;	
	ДанныеДлительнойОбработки.Вставить("МассивВременныхХранилищПорцийДанных", МассивАдресов);
	ДанныеДлительнойОбработки.Вставить("ДеревоФильтров", 					  ДеревоФильтров);
	
	АдресВременногоХранилищаФормы = ПоместитьВоВременноеХранилище(ДанныеДлительнойОбработки, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПрименитьФильтрНаСервере(АдресДанных, Индекс, Обработано = 0)
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресДанных);
	
	АдресВХПорции = СтруктураДанных.МассивВременныхХранилищПорцийДанных[Индекс];
	
	ДанныеПроводокDSS = ПолучитьИзВременногоХранилища(АдресВХПорции);
	
	ДеревоФильтров = СтруктураДанных.ДеревоФильтров;
	
	Для Каждого ДанныеОднойПроводки Из ДанныеПроводокDSS Цикл    		
		
		СтруктураПолей = ОбработкаDSSСервер.ПрименитьФильтры_ДЗ(ДеревоФильтров,ДанныеОднойПроводки);
		
		Если ЗначениеЗаполнено(СтруктураПолей) Тогда
			ДокументDSSОбъект = ДанныеОднойПроводки.Регистратор.ПолучитьОбъект();
			ДокументDSSОбъект.FiscalType = ?(ЗначениеЗаполнено(СтруктураПолей.FiscalType), СтруктураПолей.FiscalType, ДанныеОднойПроводки.FiscalType);
			ДокументDSSОбъект.Модуль = ?(ЗначениеЗаполнено(СтруктураПолей.Модуль), СтруктураПолей.Модуль, ДанныеОднойПроводки.Модуль);  			
			Попытка
				ДокументDSSОбъект.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка записи Проводки DSS "+ ДокументDSSОбъект +". 
				|	Описание ошибки: " 
				+ ОписаниеОшибки(),,,, Истина);
				Прервать;
			КонецПопытки; 
		КонецЕсли;        
		
		Обработано = Обработано + 1;
		
	КонецЦикла;
	
	УдалитьИзВременногоХранилища(АдресВХПорции);
	
КонецПроцедуры

#КонецОбласти

#Область ИзменениеType

&НаКлиенте
Процедура ИзменитьType(Команда)
	
	НельзяИзменитьType = НЕ ПрименениеДействийДляВсех И НЕ ЕстьВыделенныеСтроки();	
	Если НельзяИзменитьType Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Справочник.СтатьиДоходовИРасходов.ФормаВыбора",,ЭтаФорма,,,,
					Новый ОписаниеОповещения("ИзменитьTypeЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьTypeЗавершение(ВыбранныйType, Параметры) Экспорт
	
	Если ВыбранныйType = Неопределено Тогда
		Сообщить("Выбор не осуществлен!");
		Возврат;
	КонецЕсли;
	
	Состояние("Производится подготовка данных для изменения type, подождите...");	
	ПодготовитьДанныеДляИзмененияType();           	
	
	Состояние("Изменение type", 0, "Проведение документов по регистрам");			                        
	Для Счетчик = 1 По СтруктураИндикации.КоличествоПорций Цикл
		Обработано = 0;
		ИзменитьTypeНаСервере(ВыбранныйType, АдресВременногоХранилищаФормы, Счетчик - 1, Обработано);	
		СтруктураИндикации.ТекущееЗначениеИндикатора = СтруктураИндикации.ТекущееЗначениеИндикатора + Обработано;
		Состояние("Изменение type", СтруктураИндикации.ТекущееЗначениеИндикатора * 100 / СтруктураИндикации.МаксимумИндикатораПрогресса, "Проведение документов по регистрам " + СтруктураИндикации.ТекущееЗначениеИндикатора + "/" + СтруктураИндикации.МаксимумИндикатораПрогресса);		
		ОбновитьОтображениеДанных(); 	
	КонецЦикла;        	

	УдалитьИзВременногоХранилища(АдресВременногоХранилищаФормы);
	
	ДокиПриАктивизацииСтроки(Элементы.Доки);   
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьДанныеДляИзмененияType()

	ДанныеПроводок 	  = ИдентификаторыИДокументыПроводок();	
	ТаблицаДокументов = ДанныеПроводок.Документы;
	
	МассивАдресов = РазбитьТаблицуПоместитьВХранилища(ТаблицаДокументов);
	
	СтруктураИндикации.Вставить("МаксимумИндикатораПрогресса", ТаблицаДокументов.Количество());
	СтруктураИндикации.Вставить("ТекущееЗначениеИндикатора",   0);
	СтруктураИндикации.Вставить("КоличествоПорций",   		   МассивАдресов.Количество());
	
	ДанныеДлительнойОбработки = Новый Структура;	
	ДанныеДлительнойОбработки.Вставить("МассивВременныхХранилищПорцийДанных", МассивАдресов);
	
	АдресВременногоХранилищаФормы = ПоместитьВоВременноеХранилище(ДанныеДлительнойОбработки, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьTypeНаСервере(Type, АдресДанных, Индекс, Обработано = 0)
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресДанных);
	АдресВХПорции   = СтруктураДанных.МассивВременныхХранилищПорцийДанных[Индекс];   
	табДокументы 	= ПолучитьИзВременногоХранилища(АдресВХПорции);
	
	//Замена FiscalType с перепроведением проводки по регистрам
	Для Каждого СтрокаТЧ Из табДокументы Цикл
		ДокументDSSОбъект = СтрокаТЧ.Регистратор.ПолучитьОбъект();
		ДокументDSSОбъект.FiscalType = Type;
		Попытка
			ДокументDSSОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка записи Проводки DSS "+ ДокументDSSОбъект +". 
			|	Описание ошибки: " 
			+ ОписаниеОшибки(),,,, Истина);
			Прервать;
		КонецПопытки; 	
		Обработано = Обработано + 1;
	КонецЦикла; 
	
	УдалитьИзВременногоХранилища(АдресВХПорции);
	
КонецПроцедуры

#КонецОбласти

#Область ИзменениеМодуль

&НаКлиенте
Процедура ИзменитьМодуль(Команда)
	
	НельзяИзменитьМодуль = НЕ ПрименениеДействийДляВсех И НЕ ЕстьВыделенныеСтроки();	
	Если НельзяИзменитьМодуль Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Перечисление.МодулиРазработки.ФормаВыбора",,ЭтаФорма,,,,
					Новый ОписаниеОповещения("ИзменитьМодульЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьМодульЗавершение(ВыбранныйМодуль, Параметры) Экспорт
	
	Если ВыбранныйМодуль = Неопределено Тогда
		Сообщить("Выбор не осуществлен!");
		Возврат;
	КонецЕсли;
	
	Состояние("Производится подготовка данных для изменения модуля, подождите...");	
	ПодготовитьДанныеДляИзмененияМодуль();           	
	
	Состояние("Изменение модуля", 0, "Проведение документов по регистрам");			                        
	Для Счетчик = 1 По СтруктураИндикации.КоличествоПорций Цикл
		Обработано = 0;
		ИзменитьМодульНаСервере(ВыбранныйМодуль, АдресВременногоХранилищаФормы, Счетчик - 1, Обработано);	
		СтруктураИндикации.ТекущееЗначениеИндикатора = СтруктураИндикации.ТекущееЗначениеИндикатора + Обработано;
		Состояние("Изменение модуля", СтруктураИндикации.ТекущееЗначениеИндикатора * 100 / СтруктураИндикации.МаксимумИндикатораПрогресса, "Проведение документов по регистрам " + СтруктураИндикации.ТекущееЗначениеИндикатора + "/" + СтруктураИндикации.МаксимумИндикатораПрогресса);		
		ОбновитьОтображениеДанных(); 	
	КонецЦикла;        	

	УдалитьИзВременногоХранилища(АдресВременногоХранилищаФормы);
	
	ДокиПриАктивизацииСтроки(Элементы.Доки);   
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьДанныеДляИзмененияМодуль()

	ДанныеПроводок 	  = ИдентификаторыИДокументыПроводок();	
	ТаблицаДокументов = ДанныеПроводок.Документы;
	
	МассивАдресов = РазбитьТаблицуПоместитьВХранилища(ТаблицаДокументов);
	
	СтруктураИндикации.Вставить("МаксимумИндикатораПрогресса", ТаблицаДокументов.Количество());
	СтруктураИндикации.Вставить("ТекущееЗначениеИндикатора",   0);
	СтруктураИндикации.Вставить("КоличествоПорций",   		   МассивАдресов.Количество());
	
	ДанныеДлительнойОбработки = Новый Структура;	
	ДанныеДлительнойОбработки.Вставить("МассивВременныхХранилищПорцийДанных", МассивАдресов);
	
	АдресВременногоХранилищаФормы = ПоместитьВоВременноеХранилище(ДанныеДлительнойОбработки, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

&НаСервере
Процедура ИзменитьМодульНаСервере(Модуль, АдресДанных, Индекс, Обработано = 0)
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресДанных);
	АдресВХПорции   = СтруктураДанных.МассивВременныхХранилищПорцийДанных[Индекс];   
	табДокументы 	= ПолучитьИзВременногоХранилища(АдресВХПорции);   	
	
	//Замена Модуля с перепроведением проводки по регистрам
	Для Каждого СтрокаТЧ Из табДокументы Цикл
		ДокументDSSОбъект = СтрокаТЧ.Регистратор.ПолучитьОбъект();
		ДокументDSSОбъект.Модуль = Модуль;
		Попытка
			ДокументDSSОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Ошибка записи Проводки DSS "+ ДокументDSSОбъект +". 
			|	Описание ошибки: " 
			+ ОписаниеОшибки(),,,, Истина);
			Прервать;
		КонецПопытки; 	
		Обработано = Обработано + 1;
	КонецЦикла;   	

	УдалитьИзВременногоХранилища(АдресВХПорции);	
	
КонецПроцедуры

#КонецОбласти

#Область ПеренестиПроводкиНаДругойДокумент

&НаКлиенте
Процедура ПеренестиПроводкиНаДругойДокумент(Команда)
	
	ПоказатьВводЗначения(Новый ОписаниеОповещения("ПеренестиПроводкиНаДругойДокументЗавершение", ЭтаФорма),, 
					"Укажите документ, в который перенести проводки", ТипДокументаДляПереносаПроводок());

КонецПроцедуры

&НаСервере
Функция ТипДокументаДляПереносаПроводок() 
	
	Возврат Метаданные.Документы.ПроводкаDSS.Реквизиты.Документ.Тип;
	
КонецФункции

&НаКлиенте
Процедура ПеренестиПроводкиНаДругойДокументЗавершение(ВыбранныйДокумент, Параметры) Экспорт
	                   	
	Если ВыбранныйДокумент = Неопределено Тогда
		Сообщить("Выбор не осуществлен!");
		Возврат;
	КонецЕсли;    
	
	ПрименениеДействийДляВсех = Ложь;
	
	ПеренестиПроводкиНаДругойДокументНаСервере(ВыбранныйДокумент);
	
	ДокиПриАктивизацииСтроки(Элементы.Доки);
	
КонецПроцедуры

&НаСервере
Процедура ПеренестиПроводкиНаДругойДокументНаСервере(ВыбранныйДокумент)
	   	
	ДанныеПроводок = ИдентификаторыИДокументыПроводок();	
	Идентификаторы = ДанныеПроводок.Идентификаторы;     	
	табДокументы   = ДанныеПроводок.Документы;
	
	ОбработкаDSSСервер.ПереброситьПроводкиDSS(Идентификаторы, ВыбранныйДокумент);
	
	Если ТипЗнч(ВыбранныйДокумент) = Тип("ДокументСсылка.СчетКнигиПокупок") Тогда
		
		НачатьТранзакцию(); 
		
		//т.к. у нас изменение модуля реализовано с индикацией, то тут мы имитируем функционал для использования уже существующей функции
		МассивАдресов = Новый Массив;
		МассивАдресов.Добавить(ПоместитьВоВременноеХранилище(табДокументы, Новый УникальныйИдентификатор));		
		ДанныеДлительнойОбработки = Новый Структура;	
		ДанныеДлительнойОбработки.Вставить("МассивВременныхХранилищПорцийДанных", МассивАдресов);		
		АдресВременногоХранилищаФормы = ПоместитьВоВременноеХранилище(ДанныеДлительнойОбработки, ЭтаФорма.УникальныйИдентификатор);
		
		//Изменяем модуль
		ИзменитьМодульНаСервере(Перечисления.МодулиРазработки.PurchaseBook, АдресВременногоХранилищаФормы, 0);
		
		УдалитьИзВременногоХранилища(АдресВременногоХранилищаФормы);
		
		ДокументОбъект = ВыбранныйДокумент.ПолучитьОбъект();
		
		Отказ = Ложь;
		ДокументОбъект.ПривязатьПроводкиИЗаполнитьТЧСуммы(Отказ); // А ОНО ТУТ НУЖНО?
		
		Попытка
			ДокументОбъект.Записать(РежимЗаписиДокумента.Проведение);
		Исключение
		КонецПопытки;
		
		Если ТранзакцияАктивна() Тогда
			ЗафиксироватьТранзакцию();
		КонецЕсли;
		
	ИначеЕсли ТипЗнч(ВыбранныйДокумент) = Тип("ДокументСсылка.РеализацияТоваровУслуг") ИЛИ ТипЗнч(ВыбранныйДокумент) = Тип("ДокументСсылка.ПередачаОС") Тогда
		
		//а тут надо 
		//1. перебрасывать на модуль Sales book
		//2. пересчитывать разницы по документу реализации
		
	КонецЕсли;   	
	
КонецПроцедуры 

#КонецОбласти
      