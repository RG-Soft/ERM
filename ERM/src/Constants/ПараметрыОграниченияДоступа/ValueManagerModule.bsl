#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Обновляет описание свойств видов доступа в
// параметрах ограничения доступа при изменении конфигурации.
// 
// Параметры:
//  ЕстьИзменения - Булево (возвращаемое значение) - если производилась запись,
//                  устанавливается Истина, иначе не изменяется.
//
Процедура ОбновитьОписаниеСвойствВидовДоступа(ЕстьИзменения = Неопределено, ТолькоПроверка = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Если ТолькоПроверка ИЛИ МонопольныйРежим() Тогда
		СнятьМонопольныйРежим = Ложь;
	Иначе
		СнятьМонопольныйРежим = Истина;
		УстановитьМонопольныйРежим(Истина);
	КонецЕсли;
	
	СвойстваВидовДоступа = СвойстваВидовДоступа();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("Константа.ПараметрыОграниченияДоступа");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	
	НачатьТранзакцию();
	Попытка
		Блокировка.Заблокировать();
		
		Параметры = СтандартныеПодсистемыСервер.ПараметрыРаботыПрограммы(
			"ПараметрыОграниченияДоступа");
		
		Сохраненные = Неопределено;
		
		Если Параметры.Свойство("СвойстваВидовДоступа") Тогда
			Сохраненные = Параметры.СвойстваВидовДоступа;
			
			Если НЕ ОбщегоНазначения.ДанныеСовпадают(СвойстваВидовДоступа, Сохраненные) Тогда
				ЕстьИзмененияТиповГруппИЗначенийДоступа =
					ЕстьИзмененияТиповГруппИЗначенийДоступа(СвойстваВидовДоступа, Сохраненные);
				Сохраненные = Неопределено;
			КонецЕсли;
		КонецЕсли;
		
		Если Сохраненные = Неопределено Тогда
			ЕстьИзменения = Истина;
			Если ТолькоПроверка Тогда
				ЗафиксироватьТранзакцию();
				Возврат;
			КонецЕсли;
			СтандартныеПодсистемыСервер.УстановитьПараметрРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"СвойстваВидовДоступа",
				СвойстваВидовДоступа);
		КонецЕсли;
		
		СтандартныеПодсистемыСервер.ПодтвердитьОбновлениеПараметраРаботыПрограммы(
			"ПараметрыОграниченияДоступа",
			"СвойстваВидовДоступа");
		
		Если НЕ ТолькоПроверка Тогда
			СтандартныеПодсистемыСервер.ДобавитьИзмененияПараметраРаботыПрограммы(
				"ПараметрыОграниченияДоступа",
				"ТипыГруппИЗначенийДоступа",
				?(ЕстьИзмененияТиповГруппИЗначенийДоступа = Истина,
				  Новый ФиксированнаяСтруктура("ЕстьИзменения", Истина),
				  Новый ФиксированнаяСтруктура()) );
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		Если СнятьМонопольныйРежим Тогда
			УстановитьМонопольныйРежим(Ложь);
		КонецЕсли;
		ВызватьИсключение;
	КонецПопытки;
	
	Если СнятьМонопольныйРежим Тогда
		УстановитьМонопольныйРежим(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает свойства видов доступа, заполняемых при внедрении
// в процедуре ПриЗаполненииВидовДоступа общего модуля.
// УправлениеДоступомПереопределяемый и одноименных процедурах служебного события.
//
Функция СвойстваВидовДоступа()
	
	// 1. Заполнение данных, указанных при внедрении.
	
	ВидыДоступа = Новый ТаблицаЗначений;
	ВидыДоступа.Колонки.Добавить("Имя",                    Новый ОписаниеТипов("Строка"));
	ВидыДоступа.Колонки.Добавить("Представление",          Новый ОписаниеТипов("Строка"));
	ВидыДоступа.Колонки.Добавить("ТипЗначений",            Новый ОписаниеТипов("Тип"));
	ВидыДоступа.Колонки.Добавить("ТипГруппЗначений",       Новый ОписаниеТипов("Тип"));
	ВидыДоступа.Колонки.Добавить("НесколькоГруппЗначений", Новый ОписаниеТипов("Булево"));
	ВидыДоступа.Колонки.Добавить("ДополнительныеТипы",     Новый ОписаниеТипов("ТаблицаЗначений"));
	
	ПользователиСлужебный.ПриЗаполненииВидовДоступа(ВидыДоступа);
	
	ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
		"СтандартныеПодсистемы.УправлениеДоступом\ПриЗаполненииВидовДоступа");
	
	Для каждого Обработчик Из ОбработчикиСобытия Цикл
		Обработчик.Модуль.ПриЗаполненииВидовДоступа(ВидыДоступа);
	КонецЦикла;
	
	УправлениеДоступомПереопределяемый.ПриЗаполненииВидовДоступа(ВидыДоступа);
	
	// Проверки:
	// - тип значений доступа не указан для 2-х видов доступа
	// - тип значений доступа Пользователи, ГруппыПользователей используется только для вида доступа Пользователи.
	// Т тип значений доступа ВнешниеПользователи, ГруппыВнешнихПользователей используется только для вида доступа
	// ВнешниеПользователи.
	// И имена видов доступа Объект, Условие, НастройкиПрав, ПравоЧтения, ПравоИзменения не указаны.
	// Т тип групп значений не совпадает с типом значений.
	
	// 2. Подготовка различных коллекций свойств видов доступа, используемых при работе программы.
	МассивСвойств         = Новый Массив;
	ПоСсылкам             = Новый Соответствие;
	ПоИменам              = Новый Соответствие;
	ПоТипамЗначений       = Новый Соответствие;
	ПоТипамГруппИЗначений = Новый Соответствие;
	
	ЗначенияДоступаСГруппами = Новый Структура;
	ЗначенияДоступаСГруппами.Вставить("ПоТипам",           Новый Соответствие);
	ЗначенияДоступаСГруппами.Вставить("ПоТипамСсылок",     Новый Соответствие);
	ЗначенияДоступаСГруппами.Вставить("ИменаТаблиц",       Новый Массив);
	ЗначенияДоступаСГруппами.Вставить("ТипыГруппЗначений", Новый Соответствие);
	
	Параметры = Новый Структура;
	Параметры.Вставить("ОпределяемыеТипыЗначенийДоступа",
		УправлениеДоступомСлужебныйПовтИсп.ТипыПоляТаблицы("ОпределяемыйТип.ЗначениеДоступа"));
	
	ЗаголовокОшибки =
		НСтр("ru = 'Ошибка в процедуре ЗаполнитьСвойстваВидаДоступа
		           |общего модуля УправлениеДоступомПереопределяемый.
		           |
		           |'");
	
	Параметры.Вставить("ЗаголовокОшибки", ЗаголовокОшибки);
	
	Параметры.Вставить("ТипыПодпискиОбновитьГруппыЗначенийДоступа",
		УправлениеДоступомСлужебныйПовтИсп.ТипыПоляТаблицы(
			"ОпределяемыйТип.ЗначениеДоступаСГруппамиЗначенийДоступаОбъект"));
	
	ВсеИменаВидовДоступа = Новый Соответствие;
	ВсеИменаВидовДоступа.Вставить(ВРег("Объект"),         Истина);
	ВсеИменаВидовДоступа.Вставить(ВРег("Условие"),        Истина);
	ВсеИменаВидовДоступа.Вставить(ВРег("НастройкиПрав"),  Истина);
	ВсеИменаВидовДоступа.Вставить(ВРег("ПравоЧтения"),    Истина);
	ВсеИменаВидовДоступа.Вставить(ВРег("ПравоИзменения"), Истина);
	
	ВсеТипыЗначений      = Новый Соответствие;
	ВсеТипыГруппЗначений = Новый Соответствие;
	
	Для каждого ВидДоступа Из ВидыДоступа Цикл
		
		Если ВсеИменаВидовДоступа[ВРег(ВидДоступа.Имя)] <> Неопределено Тогда
			ВызватьИсключение ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Имя вида доступа ""%1"" уже определено.'"),
				ВидДоступа.Имя);
		КонецЕсли;
		
		// Проверка повторения типов значений и групп.
		ПроверитьТип(ВидДоступа, ВидДоступа.ТипЗначений,      ВсеТипыЗначений,      Параметры);
		ПроверитьТип(ВидДоступа, ВидДоступа.ТипГруппЗначений, ВсеТипыГруппЗначений, Параметры, Истина);
		// Проверка пересечения типов значений и групп.
		ПроверитьТип(ВидДоступа, ВидДоступа.ТипЗначений,      ВсеТипыГруппЗначений, Параметры,       , Истина);
		ПроверитьТип(ВидДоступа, ВидДоступа.ТипГруппЗначений, ВсеТипыЗначений,      Параметры, Истина, Истина);
		
		Для каждого Строка Из ВидДоступа.ДополнительныеТипы Цикл
			// Проверка повторения типов значений и групп.
			ПроверитьТип(ВидДоступа, Строка.ТипЗначений,      ВсеТипыЗначений,      Параметры);
			ПроверитьТип(ВидДоступа, Строка.ТипГруппЗначений, ВсеТипыГруппЗначений, Параметры, Истина);
			// Проверка пересечения типов значений и групп.
			ПроверитьТип(ВидДоступа, Строка.ТипЗначений,      ВсеТипыГруппЗначений, Параметры,       , Истина);
			ПроверитьТип(ВидДоступа, Строка.ТипГруппЗначений, ВсеТипыЗначений,      Параметры, Истина, Истина);
		КонецЦикла;
		
		ПустаяСсылкаТипаЗначений = ОбщегоНазначения.МенеджерОбъектаПоПолномуИмени(
			Метаданные.НайтиПоТипу(ВидДоступа.ТипЗначений).ПолноеИмя()).ПустаяСсылка();
		
		Свойства = Новый Структура;
		Свойства.Вставить("Имя",                      ВидДоступа.Имя);
		Свойства.Вставить("Ссылка",                   ПустаяСсылкаТипаЗначений);
		Свойства.Вставить("Представление",            ВидДоступа.Представление);
		Свойства.Вставить("ТипЗначений",              ВидДоступа.ТипЗначений);
		Свойства.Вставить("ТипГруппЗначений",         ВидДоступа.ТипГруппЗначений);
		Свойства.Вставить("НесколькоГруппЗначений",   ВидДоступа.НесколькоГруппЗначений);
		Свойства.Вставить("ДополнительныеТипы",       Новый Массив);
		Свойства.Вставить("ТипыВыбираемыхЗначений",   Новый Массив);
		
		МассивСвойств.Добавить(Свойства);
		ПоИменам.Вставить(Свойства.Имя, Свойства);
		ПоСсылкам.Вставить(ПустаяСсылкаТипаЗначений, Свойства);
		ПоТипамЗначений.Вставить(Свойства.ТипЗначений, Свойства);
		ПоТипамГруппИЗначений.Вставить(Свойства.ТипЗначений, Свойства);
		Если Свойства.ТипГруппЗначений <> Тип("Неопределено") Тогда
			ПоТипамГруппИЗначений.Вставить(Свойства.ТипГруппЗначений, Свойства);
		КонецЕсли;
		ЗаполнитьЗначенияДоступаСГруппами(Свойства, ЗначенияДоступаСГруппами, Свойства, Параметры);
		
		Для каждого Строка Из ВидДоступа.ДополнительныеТипы Цикл
			Элемент = Новый Структура;
			Элемент.Вставить("ТипЗначений",            Строка.ТипЗначений);
			Элемент.Вставить("ТипГруппЗначений",       Строка.ТипГруппЗначений);
			Элемент.Вставить("НесколькоГруппЗначений", Строка.НесколькоГруппЗначений);
			Свойства.ДополнительныеТипы.Добавить(Элемент);
			ПоТипамЗначений.Вставить(Строка.ТипЗначений, Свойства);
			ПоТипамГруппИЗначений.Вставить(Строка.ТипЗначений, Свойства);
			Если Строка.ТипГруппЗначений <> Тип("Неопределено") Тогда
				ПоТипамГруппИЗначений.Вставить(Строка.ТипГруппЗначений, Свойства);
			КонецЕсли;
			ЗаполнитьЗначенияДоступаСГруппами(Строка, ЗначенияДоступаСГруппами, Свойства, Параметры);
		КонецЦикла;
		
	КонецЦикла;
	
	БезГруппДляЗначенияДоступа      = Новый Массив;
	СОднойГруппойДляЗначенияДоступа = Новый Массив;
	ТипыЗначенийДоступаСГруппами    = Новый Соответствие;
	
	ВидыДоступаСГруппами = Новый Соответствие;
	
	Для каждого КлючИЗначение Из ЗначенияДоступаСГруппами.ПоТипамСсылок Цикл
		ИмяВидаДоступа = КлючИЗначение.Значение.Имя;
		ВидыДоступаСГруппами.Вставить(ИмяВидаДоступа, Истина);
		
		ПустаяСсылка = УправлениеДоступомСлужебный.ПустаяСсылкаОбъектаМетаданных(КлючИЗначение.Ключ);
		ТипыЗначенийДоступаСГруппами.Вставить(ТипЗнч(ПустаяСсылка), ПустаяСсылка);
		
		Если НЕ КлючИЗначение.Значение.НесколькоГруппЗначений
		   И СОднойГруппойДляЗначенияДоступа.Найти(ИмяВидаДоступа) = Неопределено Тогда
		   
			СОднойГруппойДляЗначенияДоступа.Добавить(ИмяВидаДоступа);
		КонецЕсли;
	КонецЦикла;
	
	ТипыЗначенийДоступаСГруппами.Вставить(Тип("СправочникСсылка.Пользователи"),
		Справочники.Пользователи.ПустаяСсылка());
	
	ТипыЗначенийДоступаСГруппами.Вставить(Тип("СправочникСсылка.ГруппыПользователей"),
		Справочники.ГруппыПользователей.ПустаяСсылка());
	
	ТипыЗначенийДоступаСГруппами.Вставить(Тип("СправочникСсылка.ВнешниеПользователи"),
		Справочники.ВнешниеПользователи.ПустаяСсылка());
	
	ТипыЗначенийДоступаСГруппами.Вставить(Тип("СправочникСсылка.ГруппыВнешнихПользователей"),
		Справочники.ГруппыВнешнихПользователей.ПустаяСсылка());
	
	Для каждого СвойстваВидаДоступа Из МассивСвойств Цикл
		Если ВидыДоступаСГруппами.Получить(СвойстваВидаДоступа.Имя) <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если СвойстваВидаДоступа.Имя = "Пользователи"
		 ИЛИ СвойстваВидаДоступа.Имя = "ВнешниеПользователи" Тогда
			Продолжить;
		КонецЕсли;
		БезГруппДляЗначенияДоступа.Добавить(СвойстваВидаДоступа.Имя);
	КонецЦикла;
	
	СвойстваВидовДоступа = Новый Структура;
	СвойстваВидовДоступа.Вставить("Массив",                          МассивСвойств);
	СвойстваВидовДоступа.Вставить("ПоИменам",                        ПоИменам);
	СвойстваВидовДоступа.Вставить("ПоСсылкам",                       ПоСсылкам);
	СвойстваВидовДоступа.Вставить("ПоТипамЗначений",                 ПоТипамЗначений);
	СвойстваВидовДоступа.Вставить("ПоТипамГруппИЗначений",           ПоТипамГруппИЗначений);
	СвойстваВидовДоступа.Вставить("ЗначенияДоступаСГруппами",        ЗначенияДоступаСГруппами);
	СвойстваВидовДоступа.Вставить("БезГруппДляЗначенияДоступа",      БезГруппДляЗначенияДоступа);
	СвойстваВидовДоступа.Вставить("СОднойГруппойДляЗначенияДоступа", СОднойГруппойДляЗначенияДоступа);
	СвойстваВидовДоступа.Вставить("ТипыЗначенийДоступаСГруппами",    ТипыЗначенийДоступаСГруппами);
	
	// Проверка совместимости перехода на новые версии программы.
	Если Параметры.ОпределяемыеТипыЗначенийДоступа.Получить(
		ТипЗнч(ПланыВидовХарактеристик.УдалитьВидыДоступа.ПустаяСсылка())) = Неопределено Тогда
	
		ОписаниеОшибки =
			НСтр("ru = 'Тип ПланВидовХарактеристикСсылка.УдалитьВидыДоступа,
			           |необходимый для перехода на новые версии программы
			           |не указан в определяемом типе ""Значение доступа"".'");
		
		ВызватьИсключение Параметры.ЗаголовокОшибки + ОписаниеОшибки;
	КонецЕсли;
	
	Возврат ОбщегоНазначения.ФиксированныеДанные(СвойстваВидовДоступа);
	
КонецФункции

Процедура ЗаполнитьЗначенияДоступаСГруппами(Строка, ЗначенияДоступаСГруппами, Свойства, Параметры)
	
	Если Свойства.Имя = "Пользователи" Тогда
		ДобавитьВМассив(Свойства.ТипыВыбираемыхЗначений, Тип("СправочникСсылка.Пользователи"));
		ДобавитьВМассив(Свойства.ТипыВыбираемыхЗначений, Тип("СправочникСсылка.ГруппыПользователей"));
		Возврат;
	КонецЕсли;
	
	Если Свойства.Имя = "ВнешниеПользователи" Тогда
		ДобавитьВМассив(Свойства.ТипыВыбираемыхЗначений, Тип("СправочникСсылка.ВнешниеПользователи"));
		ДобавитьВМассив(Свойства.ТипыВыбираемыхЗначений, Тип("СправочникСсылка.ГруппыВнешнихПользователей"));
		Возврат;
	КонецЕсли;
	
	Если Строка.ТипГруппЗначений = Тип("Неопределено") Тогда
		ДобавитьВМассив(Свойства.ТипыВыбираемыхЗначений, Строка.ТипЗначений);
		Возврат;
	КонецЕсли;
	
	ТипСсылки = Строка.ТипЗначений;
	
	МетаданныеТипаЗначений = Метаданные.НайтиПоТипу(Строка.ТипЗначений);
	Если ОбщегоНазначения.ЭтоПеречисление(МетаданныеТипаЗначений) Тогда
		ТипОбъекта = ТипСсылки;
	Иначе
		ТипОбъекта = СтандартныеПодсистемыСервер.ТипОбъектаИлиНабораЗаписейОбъектаМетаданных(
			МетаданныеТипаЗначений);
	КонецЕсли;
	
	Если Строка.ТипГруппЗначений <> Тип("Неопределено") Тогда
		ДобавитьВМассив(Свойства.ТипыВыбираемыхЗначений, Строка.ТипГруппЗначений);
	КонецЕсли;
	
	ЗначенияДоступаСГруппами.ПоТипам.Вставить(ТипСсылки,  Свойства);
	ЗначенияДоступаСГруппами.ПоТипам.Вставить(ТипОбъекта, Свойства);
	ЗначенияДоступаСГруппами.ПоТипамСсылок.Вставить(ТипСсылки, Свойства);
	ЗначенияДоступаСГруппами.ИменаТаблиц.Добавить(МетаданныеТипаЗначений.ПолноеИмя());
	
	МетаданныеТипаГруппЗначений = Метаданные.НайтиПоТипу(Строка.ТипГруппЗначений);
	ПустаяСсылкаТипаГруппЗначений =
		УправлениеДоступомСлужебный.ПустаяСсылкаОбъектаМетаданных(МетаданныеТипаГруппЗначений);
	
	ЗначенияДоступаСГруппами.ТипыГруппЗначений.Вставить(ТипСсылки, ПустаяСсылкаТипаГруппЗначений);
	ЗначенияДоступаСГруппами.ТипыГруппЗначений.Вставить(
		УправлениеДоступомСлужебный.ПустаяСсылкаОбъектаМетаданных(МетаданныеТипаЗначений),
		ПустаяСсылкаТипаГруппЗначений);
	
	// Проверка наличия типа ссылки в соответствующих объектах метаданных.
	Если Параметры.ТипыПодпискиОбновитьГруппыЗначенийДоступа.Получить(ТипОбъекта) = Неопределено
	   И НЕ ОбщегоНазначения.ЭтоПеречисление(МетаданныеТипаЗначений) Тогда
		
		ВызватьИсключение Параметры.ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Тип значения доступа ""%1"", использующий группы значений, не указан
			           |в определяемом типе ""Значение доступа с группами значений доступа объект"".'"),
			Строка(ТипОбъекта));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьТип(ВидДоступа, Тип, ВсеТипы, Параметры, ПроверкаТиповГрупп = Ложь, ПроверкаПересечения = Ложь)
	
	Если Тип = Тип("Неопределено") Тогда
		Если ПроверкаТиповГрупп Тогда
			Возврат;
		КонецЕсли;
		ВызватьИсключение Параметры.ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Для вида доступа ""%1"" не указан тип значений доступа.'"),
			ВидДоступа.Имя);
	КонецЕсли;
	
	// Проверка, что указан тип ссылки.
	Если НЕ ОбщегоНазначения.ЭтоСсылка(Тип) Тогда
		Если ПроверкаТиповГрупп Тогда
			ОписаниеОшибки =
				НСтр("ru = 'Тип ""%1"" указан, как тип групп значений, для вида доступа ""%2"".
				           |Однако это не тип ссылки.'");
		Иначе
			ОписаниеОшибки =
				НСтр("ru = 'Тип ""%1"" указан, как тип значений, для вида доступа ""%2"".
				           |Однако это не тип ссылки.'");
		КонецЕсли;
		ВызватьИсключение Параметры.ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ОписаниеОшибки, Тип, ВидДоступа.Имя);
	КонецЕсли;
	
	// Проверка повторения и пересечения типов значений и групп значений.
	ДляТогоЖеВидаДоступаОшибкиНет = Ложь;
	
	Если ПроверкаТиповГрупп Тогда
		Если ПроверкаПересечения Тогда
			ОписаниеОшибки =
				НСтр("ru = 'Тип ""%1"" указан, как тип значений, для вида доступа ""%2"".
				           |Для вида доступа ""%3"" его нельзя указать, как тип групп значений.'");
		Иначе
			ДляТогоЖеВидаДоступаОшибкиНет = Истина;
			ОписаниеОшибки =
				НСтр("ru = 'Тип групп значений ""%1"" уже указан для вида доступа ""%2"".
				           |Для вида доступа ""%3"" его нельзя указать.'");
		КонецЕсли;
	Иначе
		Если ПроверкаПересечения Тогда
			ОписаниеОшибки =
				НСтр("ru = 'Тип ""%1"" указан, как тип групп значений, для вида доступа ""%2"".
				           |Для вида доступа ""%3"" его нельзя указать, как тип значений.'");
		Иначе
			ОписаниеОшибки =
				НСтр("ru = 'Тип значений ""%1"" уже указан для вида доступа ""%2"".
				           |Для вида доступа ""%3"" его нельзя указать.'");
		КонецЕсли;
	КонецЕсли;
	
	Если ВсеТипы.Получить(Тип) <> Неопределено Тогда
		Если НЕ (ДляТогоЖеВидаДоступаОшибкиНет И ВидДоступа.Имя = ВсеТипы.Получить(Тип)) Тогда
			ВызватьИсключение Параметры.ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ОписаниеОшибки, Тип, ВсеТипы.Получить(Тип), ВидДоступа.Имя);
		КонецЕсли;
	ИначеЕсли НЕ ПроверкаПересечения Тогда
		ВсеТипы.Вставить(Тип, ВидДоступа.Имя);
	КонецЕсли;
	
	// Проверка состава определяемых типов.
	ОписаниеОшибки = "";
	Если Параметры.ОпределяемыеТипыЗначенийДоступа.Получить(Тип) = Неопределено Тогда
		Если ПроверкаТиповГрупп Тогда
			ОписаниеОшибки =
				НСтр("ru = 'Тип групп значений доступа ""%1"" вида доступа ""%2""
				           |не указан в определяемом типе ""Значение доступа"".'");
		Иначе
			ОписаниеОшибки =
				НСтр("ru = 'Тип значений доступа ""%1"" вида доступа ""%2""
				           |не указан в определяемом типе ""Значение доступа"".'");
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ВызватьИсключение Параметры.ЗаголовокОшибки + СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ОписаниеОшибки, Тип, ВидДоступа.Имя);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДобавитьВМассив(Массив, Значение)
	
	Если Массив.Найти(Значение) = Неопределено Тогда
		Массив.Добавить(Значение);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет наличие изменений типов групп и значений доступа.
Функция ЕстьИзмененияТиповГруппИЗначенийДоступа(СвойстваВидовДоступа, Сохраненные)
	
	Если НЕ ТипЗнч(Сохраненные) = Тип("ФиксированнаяСтруктура")
	 ИЛИ НЕ Сохраненные.Свойство("ПоТипамЗначений")
	 ИЛИ НЕ Сохраненные.Свойство("ТипыЗначенийДоступаСГруппами")
	 ИЛИ НЕ ТипЗнч(Сохраненные.ПоТипамЗначений)              = Тип("ФиксированноеСоответствие")
	 ИЛИ НЕ ТипЗнч(Сохраненные.ТипыЗначенийДоступаСГруппами) = Тип("ФиксированноеСоответствие")
	 ИЛИ НЕ СвойстваВидовДоступа.Свойство("ПоТипамЗначений")
	 ИЛИ НЕ СвойстваВидовДоступа.Свойство("ТипыЗначенийДоступаСГруппами")
	 ИЛИ НЕ ТипЗнч(СвойстваВидовДоступа.ПоТипамЗначений)              = Тип("ФиксированноеСоответствие")
	 ИЛИ НЕ ТипЗнч(СвойстваВидовДоступа.ТипыЗначенийДоступаСГруппами) = Тип("ФиксированноеСоответствие") Тогда
	
		Возврат Истина;
	КонецЕсли;
	
	Если КлючиСоответствийОтличаются(СвойстваВидовДоступа.ПоТипамЗначений, Сохраненные.ПоТипамЗначений) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если КлючиСоответствийОтличаются(СвойстваВидовДоступа.ТипыЗначенийДоступаСГруппами,
			Сохраненные.ТипыЗначенийДоступаСГруппами) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция КлючиСоответствийОтличаются(Новое, Старое)
	
	Если Новое.Количество() <> Старое.Количество() Тогда
		Возврат Истина;
	КонецЕсли;
	
	Для каждого КлючИЗначение Из Новое Цикл
		Если Старое.Получить(КлючИЗначение.Ключ) = Неопределено Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#КонецЕсли
