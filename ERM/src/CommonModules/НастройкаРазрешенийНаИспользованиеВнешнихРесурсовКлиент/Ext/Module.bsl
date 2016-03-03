﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Серверные процедуры и функции общего назначения:
// - Управление разрешениями в профилях безопасности из текущей ИБ.
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Планирует (с помощью подмены значения свойства формы ОписаниеОповещенияОЗакрытии) вызов мастера
// для проверки завершения операции после закрытия формы, из которой мастер вызывался.
//
// Параметры:
//  ФормаВладелец - УправляемаяФорма или Неопределено - форма, после закрытия которой требуется выполнить
//    проверку завершения операций, в рамках которых ранее применялись запросы разрешений на использование
//    внешних ресурсов,
//  ИдентификаторыЗапросов - Массив(УникальныйИдентификатор) - идентификаторы запросов разрешений на
//    использование внешних ресурсов, которые были применены в рамках операции, завершение которой проверяется.
//
// Результатом выполнения данной процедуры является вызов процедуры.
// ПроверкаПримененияРазрешенийПослеЗакрытияФормыВладельца() после закрытия формы, для которой в псевдо-модальном
// режиме открывался мастер настройки разрешений на использование внешних ресурсов.
//
Процедура ЗапланироватьПроверкуПримененияРазрешенийПослеЗакрытияФормыВладельца(ВладелецФормы, ИдентификаторыЗапросов) Экспорт
	
	Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") Тогда
		
		ИсходноеОписаниеОповещения = ВладелецФормы.ОписаниеОповещенияОЗакрытии;
		Если ИсходноеОписаниеОповещения <> Неопределено Тогда
			
			Если ИсходноеОписаниеОповещения.Модуль = НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент
					И ИсходноеОписаниеОповещения.ИмяПроцедуры = "ПроверкаПримененияРазрешенийПослеЗакрытияФормыВладельца" Тогда
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Состояние = СостояниеПроверкиПримененияРазрешенийПослеЗакрытияФормыВладельца();
		Состояние.ОписаниеОповещения = ИсходноеОписаниеОповещения;
		
		ОписаниеОповещенияПроверкиПримененияРазрешений = Новый ОписаниеОповещения(
			"ПроверкаПримененияРазрешенийПослеЗакрытияФормыВладельца",
			НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент,
			Состояние);
		
		ВладелецФормы.ОписаниеОповещенияОЗакрытии = ОписаниеОповещенияПроверкиПримененияРазрешений;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Запуск клиентского приложения.
//

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиентаПриЗапуске = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиентаПриЗапуске.ОтображатьПомощникНастройкиРазрешений Тогда
		
		Если ПараметрыРаботыКлиентаПриЗапуске.ПроверитьПримененияРазрешенийНаИспользованиеВнешнихРесурсов Тогда
			
			ПослеПроверкиПримененияРазрешенийНаИспользованиеВнешнихРесурсов(
				ПараметрыРаботыКлиентаПриЗапуске.ПроверкаПримененияРазрешенийНаИспользованиеВнешнихРесурсов);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Применение запросов разрешений на использование внешних ресурсов.
//

// Применяет изменения разрешений в профилях безопасности в кластере серверов по сценарию.
//
// Параметры:
//  ВидыОпераций - Структура, описывающая значения перечисления ОперацииАдминистрированияПрофилейБезопасности:
//                   * Ключ - Строка - имя значения перечисления,
//                   * Значение - ПеречислениеСсылка.ОперацииАдминистрированияПрофилейБезопасности,
//  СценарийПримененияРазрешений - Массив(Структура) - сценарий применения изменений разрешений на
//    использование профилей безопасности в кластере серверов. Значениями массива являются структуры
//    со следующими полями:
//                   * Операция - ПеречислениеСсылка.ОперацииАдминистрированияПрофилейБезопасности - операция, которую
//                      требуется выполнить,
//                   * Профиль - Строка, имя профиля безопасности,
//                   * Разрешения - Структура - описание свойств профиля безопасности, см.
//                      АдминистрированиеКластераКлиентСервер.СвойстваПрофиляБезопасности(),
//  ПараметрыАдминистрированияКластера - Структура - параметры администрирования кластера серверов, см.
//    АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияКластера(),
//  ПараметрыАдминистрированияИнформационнойБазы - Структура - параметры администрирования информационной
//    базы, см. АдминистрированиеКластераКлиентСервер.ПараметрыАдминистрированияИнформационнойБазыКластера().
//
Процедура ПрименитьИзмененияРазрешенийВПрофиляхБезопасностиВКластереСерверов(Знач ВидыОпераций, Знач СценарийПримененияРазрешений, Знач ПараметрыАдминистрированияКластера, Знач ПараметрыАдминистрированияИнформационнойБазы = Неопределено) Экспорт
	
	Если ПараметрыАдминистрированияКластера.ТипПодключения = "COM" Тогда
		ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
	КонецЕсли;
	
	ТребуютсяПараметрыАдминистрированияИБ = (ПараметрыАдминистрированияИнформационнойБазы <> Неопределено);
	
	АдминистрированиеКластераКлиентСервер.ПроверитьПараметрыАдминистрирования(
		ПараметрыАдминистрированияКластера,
		ПараметрыАдминистрированияИнформационнойБазы,
		Истина,
		ТребуютсяПараметрыАдминистрированияИБ);
	
	Для Каждого ЭлементСценария Из СценарийПримененияРазрешений Цикл
		
		Если ЭлементСценария.Операция = ВидыОпераций.Создание Тогда
			
			Если АдминистрированиеКластераКлиентСервер.ПрофильБезопасностиСуществует(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль) Тогда
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Профиль безопасности %1 уже присутствует в кластере серверов. Настройки в профиле безопасности будут замещены...'"), ЭлементСценария.Профиль));
				
				АдминистрированиеКластераКлиентСервер.УстановитьСвойстваПрофиляБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
				
			Иначе
				
				АдминистрированиеКластераКлиентСервер.СоздатьПрофильБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
				
			КонецЕсли;
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Назначение Тогда
			
			АдминистрированиеКластераКлиентСервер.УстановитьПрофильБезопасностиИнформационнойБазы(ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИнформационнойБазы, ЭлементСценария.Профиль);
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Обновление Тогда
			
			АдминистрированиеКластераКлиентСервер.УстановитьСвойстваПрофиляБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Разрешения);
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.Удаление Тогда
			
			Если АдминистрированиеКластераКлиентСервер.ПрофильБезопасностиСуществует(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль) Тогда
				
				АдминистрированиеКластераКлиентСервер.УдалитьПрофильБезопасности(ПараметрыАдминистрированияКластера, ЭлементСценария.Профиль);
				
			Иначе
				
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Профиль безопасности %1 отсутствует в кластере серверов. Возможно, профиль безопасности был удален ранее...'"), ЭлементСценария.Профиль));
				
			КонецЕсли;
			
		ИначеЕсли ЭлементСценария.Операция = ВидыОпераций.УдалениеНазначения Тогда
			
			АдминистрированиеКластераКлиентСервер.УстановитьПрофильБезопасностиИнформационнойБазы(ПараметрыАдминистрированияКластера, ПараметрыАдминистрированияИнформационнойБазы, "");
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Логика перехода между операциями мастера настройки разрешений на использование
// внешних ресурсов.
//

// Выполняет запуск мастера настройки разрешений на использование служебных ресурсов.
//
// Параметры:
//  Идентификаторы - Массив(УникальныйИдентификатор) - идентификаторы запросов на использование внешних ресурсов,
//    для применения которых вызывается мастер,
//  ФормаВладелец - УправляемаяФорма или Неопределено - форма, по отношению которой мастер открывается в
//                  псевдо-модальном режиме,
//  ОповещениеОЗакрытии - ОписаниеОповещения или Неопределено - описание оповещения, обработка которого должна быть
//    выполнена после завершения работы мастера,
//  РежимВключения - Булево - флаг того, что мастер вызывается при выполнении включения использования для информационной
//    базы профилей безопасности,
//  РежимОтключения - Булево - флаг того, что мастер вызывается при выполнении отключения использования для
//                             информационной базы профилей безопасности,
//  РежимВосстановления - Булево - флаг того, что мастер вызывается для восстановления настроек профилей безопасности в
//    кластере серверов (по текущим данным информационной базы),
//
// Результатом операции является открытие формы
// "Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.ИнициализацияЗапросаРазрешений", для которой в
// качестве описания оповещения о закрытии установлена процедура
// ПослеИнициализацииЗапросаРазрешенийНаИспользованиеВнешнихРесурсов().
//
Процедура НачатьИнициализациюЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(
		Знач Идентификаторы,
		Знач ФормаВладелец,
		Знач ОповещениеОЗакрытии,
		Знач РежимВключения = Ложь,
		Знач РежимОтключения = Ложь,
		Знач РежимВосстановления = Ложь) Экспорт
	
	Если РежимВключения ИЛИ ОтображатьПомощникНастройкиРазрешений() Тогда
		
		Состояние = СостояниеЗапросаРазрешенийНаИспользованиеВнешнихРесурсов();
		Состояние.ИдентификаторыЗапросов = Идентификаторы;
		Состояние.ОписаниеОповещения = ОповещениеОЗакрытии;
		Состояние.ФормаВладелец = ФормаВладелец;
		Состояние.РежимВключения = РежимВключения;
		Состояние.РежимОтключения = РежимОтключения;
		Состояние.РежимВосстановления = РежимВосстановления;
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Идентификаторы", Идентификаторы);
		ПараметрыФормы.Вставить("РежимВключения", Состояние.РежимВключения);
		ПараметрыФормы.Вставить("РежимОтключения", Состояние.РежимОтключения);
		ПараметрыФормы.Вставить("РежимВосстановления", Состояние.РежимВосстановления);
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеИнициализацииЗапросаРазрешенийНаИспользованиеВнешнихРесурсов",
			НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент,
			Состояние);
		
		ОткрытьФорму(
			"Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.ИнициализацияЗапросаРазрешений",
			ПараметрыФормы,
			ФормаВладелец,
			,
			,
			,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(ОповещениеОЗакрытии);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет переход к диалогу настройки разрешений в профилях безопасности.
//
// Параметры:
//  Результат - КодВозвратаДиалога - результат выполнения предыдущей операции мастера применения разрешений на
//                                   использование внешних ресурсов (используемые значения - ОК и Отмена),
//  Состояние - Структура, описывающая состояние мастера настройки разрешений (см.
//              СостояниеЗапросаРазрешенийНаИспользованиеВнешнихРесурсов))).
//
// Результатом операции является открытии формы.
// "Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов", для которой
// в качестве описания оповещения о закрытии установлена процедура
// ПослеНастройкиРазрешенийНаИспользованиеВнешнихРесурсов() или аварийное прерывание работы мастера.
//
Процедура ПослеИнициализацииЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(Результат, Состояние) Экспорт
	
	Если ТипЗнч(Результат) = Тип("Структура") И Результат.КодВозврата = КодВозвратаДиалога.ОК Тогда
		
		СостояниеИнициализации = ПолучитьИзВременногоХранилища(Результат.АдресХранилищаСостояния);
		
		Если СостояниеИнициализации.ТребуетсяПрименениеРазрешений Тогда
			
			Состояние.АдресХранилища = СостояниеИнициализации.АдресХранилища;
			
			ПараметрыФормы = Новый Структура();
			ПараметрыФормы.Вставить("АдресХранилища", Состояние.АдресХранилища);
			ПараметрыФормы.Вставить("РежимВосстановления", Состояние.РежимВосстановления);
			ПараметрыФормы.Вставить("РежимПроверки", Состояние.РежимПроверки);
			
			ОписаниеОповещения = Новый ОписаниеОповещения(
				"ПослеНастройкиРазрешенийНаИспользованиеВнешнихРесурсов",
				НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент,
				Состояние);
			
			ОткрытьФорму(
				"Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов",
				ПараметрыФормы,
				Состояние.ФормаВладелец,
				,
				,
				,
				ОписаниеОповещения,
				РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
			
		Иначе
			
			// Запрошенные разрешения избыточны, внесение изменений в настройки профилей безопасности в кластере серверов
			// не требуется.
			ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(Состояние.ОписаниеОповещения);
			
		КонецЕсли;
		
	Иначе
		
		НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВызовСервера.ОтменаПримененияЗапросовНаИспользованиеВнешнихРесурсов(
			Состояние.ИдентификаторыЗапросов);
		ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(Состояние.ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет переход к диалогу ожидания применения настроек профилей безопасности кластером серверов.
//
// Параметры:
//  Результат - КодВозвратаДиалога - результат выполнения предыдущей операции мастера применения разрешений на
//                                   использование внешних ресурсов (используемые значения - ОК, Пропустить и Отмена).
//                                   Значение Пропустить используется в том случае, если внесение изменений в настройки
//                                   профилей безопасности не вносилось, но запросы на использование внешних ресурсов
//                                   должны считаться успешно примененными (например, в том случае, если использование
//                                   всех запрашиваемых внешних ресурсов ранее уже предоставлялось),
//  Состояние - Структура - описывающая состояние мастера настройки разрешений (см.
//                          СостояниеЗапросаРазрешенийНаИспользованиеВнешнихРесурсов))).
//
// Результатом операции является открытии формы
// "Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.ЗавершениеЗапросаРазрешений", для которой
// в качестве описания оповещения о закрытии установлена процедура
// ПослеЗавершенияЗапросаРазрешенийНаИспользованиеВнешнихРесурсов() или аварийное прерывание работы мастера.
//
Процедура ПослеНастройкиРазрешенийНаИспользованиеВнешнихРесурсов(Результат, Состояние) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК ИЛИ Результат = КодВозвратаДиалога.Пропустить Тогда
		
		ЗапланироватьПроверкуПримененияРазрешенийПослеЗакрытияФормыВладельца(
			Состояние.ФормаВладелец,
			Состояние.ИдентификаторыЗапросов);
		
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("АдресХранилища", Состояние.АдресХранилища);
		ПараметрыФормы.Вставить("РежимВосстановления", Состояние.РежимВосстановления);
		
		Если Результат = КодВозвратаДиалога.ОК Тогда
			ПараметрыФормы.Вставить("Длительность", ДлительностьОжиданияПримененияИзменений());
		Иначе
			ПараметрыФормы.Вставить("Длительность", 0);
		КонецЕсли;
		
		ОписаниеОповещения = Новый ОписаниеОповещения(
			"ПослеЗавершенияЗапросаРазрешенийНаИспользованиеВнешнихРесурсов",
			НастройкаРазрешенийНаИспользованиеВнешнихРесурсовКлиент,
			Состояние);
		
		ОткрытьФорму(
			"Обработка.НастройкаРазрешенийНаИспользованиеВнешнихРесурсов.Форма.ЗавершениеЗапросаРазрешений",
			ПараметрыФормы,
			ЭтотОбъект,
			,
			,
			,
			ОписаниеОповещения,
			РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);
		
	Иначе
		
		НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВызовСервера.ОтменаПримененияЗапросовНаИспользованиеВнешнихРесурсов(
			Состояние.ИдентификаторыЗапросов);
		ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(Состояние.ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Выполняет завершение работы мастера применения разрешений на использование внешних ресурсов.
//
// Параметры:
//  Результат - КодВозвратаДиалога - результат выполнения предыдущей операции мастера применения разрешений на
//                                   использование внешних ресурсов (используемые значения - ОК и Отмена),
//  Состояние - Структура, описывающая состояние мастера настройки разрешений (см.
//              СостояниеЗапросаРазрешенийНаИспользованиеВнешнихРесурсов))).
//
// Результатом операции является обработка описания оповещения, которое изначально было передано из формы, для которой
// мастер открывался в псевдо-модальном режиме.
//
Процедура ПослеЗавершенияЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(Результат, Состояние) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Настройка разрешений'"),,
			НСтр("ru = 'Внесены изменения в настройки профилей безопасности в кластере серверов.'"));
		
		ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(Состояние.ОписаниеОповещения);
		
	Иначе
		
		НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВызовСервера.ОтменаПримененияЗапросовНаИспользованиеВнешнихРесурсов(
			Состояние.ИдентификаторыЗапросов);
		ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(Состояние.ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

// Асинхронно (по отношению к коду, из которого вызывался мастер) выполняет обработку описания оповещения,
// которое изначально было передано из формы, для которой мастер открывался в псевдо-модальном режиме, возвращая
// код возврата ОК.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения, которое было передано из вызывающего кода.
//
Процедура ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(Знач ОписаниеОповещения)
	
	ИмяПараметра = "СтандартныеПодсистемы.ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсов";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	ПараметрыПриложения[ИмяПараметра] = ОписаниеОповещения;
	
	ПодключитьОбработчикОжидания("ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсов", 0.1, Истина);
	
КонецПроцедуры

// Асинхронно (по отношению к коду, из которого вызывался мастер) выполняет обработку описания оповещения,
// которое изначально было передано из формы, для которой мастер открывался в псевдо-модальном режиме, возвращая
// код возврата Отмена.
//
// Параметры:
//  ОписаниеОповещения - ОписаниеОповещения, которое было передано из вызывающего кода.
//
Процедура ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовАсинхронно(Знач ОписаниеОповещения)
	
	ИмяПараметра = "СтандартныеПодсистемы.ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсов";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Неопределено);
	КонецЕсли;
	ПараметрыПриложения[ИмяПараметра] = ОписаниеОповещения;
	
	ПодключитьОбработчикОжидания("ПрерватьНастройкуРазрешенийНаИспользованиеВнешнихРесурсов", 0.1, Истина);
	
КонецПроцедуры

// Синхронно (по отношению к коду, из которого вызывался мастер) выполняет обработку описания оповещения,
// которое изначально было передано из формы, для которой мастер открывался в псевдо-модальном режиме.
//
// Параметры:
//  КодВозврата - КодВозвратаДиалога.
//
Процедура ЗавершитьНастройкуРазрешенийНаИспользованиеВнешнихРесурсовСинхронно(Знач КодВозврата) Экспорт
	
	ОповещениеОЗакрытии = ПараметрыПриложения["СтандартныеПодсистемы.ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсов"];
	ПараметрыПриложения["СтандартныеПодсистемы.ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсов"] = Неопределено;
	Если ОповещениеОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОповещениеОЗакрытии, КодВозврата);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Логика вызова мастера настройки разрешений на использование внешних ресурсов для
// проверки завершения операций, в рамках которых ранее применялись запросы разрешений
// на использование внешних ресурсов.
//

// Запускает мастер в режиме проверки завершения операции, в рамках которой ранее применялись запросы
// разрешений на использование внешних ресурсов.
//
// Параметры:
//  Результат - Произвольный, результат закрытия формы, для которой в псевдо-модальном режиме открывался мастер
//    настройки разрешений на использование внешних ресурсов. В теле процедуры не используется, параметр требуется
//    для назначения процедуры в качестве описания оповещения о закрытия формы.
//  Состояние - Структура - описывающая состояние проверки завершения операции (см.
//    СостояниеПроверкиПримененияРазрешенийПослеЗакрытияФормыВладельца()).
//
// Результатом выполнения данной процедуры является запуск мастера настройки разрешений на использование
// внешних ресурсов в режиме проверки завершения операции, в рамках которой ранее применялись разрешения
// на использование внешних ресурсов (с штатным прохождением всех операций), после завершения работы которого
// будет вызвана обработка описания оповещения, в качестве которого установлена процедура.
// ПослеПроверкиПримененияРазрешенийПослеЗакрытияФормыВладельца().
//
Процедура ПроверкаПримененияРазрешенийПослеЗакрытияФормыВладельца(Результат, Состояние) Экспорт
	
	ОригинальноеОписаниеОповещенияОЗакрытии = Состояние.ОписаниеОповещения;
	Если ОригинальноеОписаниеОповещенияОЗакрытии <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ОригинальноеОписаниеОповещенияОЗакрытии, Результат);
	КонецЕсли;
	
	Проверка = НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВызовСервера.ПроверитьПрименениеРазрешенийНаИспользованиеВнешнихРесурсов();
	ПослеПроверкиПримененияРазрешенийНаИспользованиеВнешнихРесурсов(Проверка);
	
КонецПроцедуры

// Обрабатывает проверку применения запросов на использование внешних ресурсов.
//
// Параметры:
//  Проверка - Структура - состояние выполнения проверки применения разрешений на использование
//                         внешних ресурсов (подробнее см. результат, возвращаемый функции.
//                         НастройкаРазрешенийНаИспользованиеВнешнихРесурсовВызовСервера.
//                         ПроверитьПрименениеРазрешенийНаИспользованиеВнешнихРесурсов().
//
Процедура ПослеПроверкиПримененияРазрешенийНаИспользованиеВнешнихРесурсов(Знач Проверка)
	
	Если Не Проверка.РезультатПроверки Тогда
		
		СостояниеПрименения = СостояниеЗапросаРазрешенийНаИспользованиеВнешнихРесурсов();
		
		СостояниеПрименения.ИдентификаторыЗапросов = Проверка.ИдентификаторыЗапросов;
		СостояниеПрименения.АдресХранилища = Проверка.АдресВременногоХранилищаСостояния;
		СостояниеПрименения.РежимПроверки = Истина;
		
		Результат = Новый Структура();
		Результат.Вставить("КодВозврата", КодВозвратаДиалога.ОК);
		Результат.Вставить("АдресХранилищаСостояния", Проверка.АдресВременногоХранилищаСостояния);
		
		ПослеИнициализацииЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(
			Результат, СостояниеПрименения);
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов мастера настройки разрешений на использование внешних ресурсов в
// специальных режимах.
//

// Вызывает мастер настройки разрешений на использование внешних ресурсов в режиме
// включения использования профилей безопасности для информационной базы.
//
// Параметры:
//  ФормаВладелец - УправляемаяФорма - форма, которая должна блокироваться до окончания применения разрешений,
//  ОповещениеОЗакрытии - ОписаниеОповещения - которое будет вызвано при успешном предоставлении разрешений.
//
Процедура НачатьВключениеИспользованияПрофилейБезопасности(ФормаВладелец, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	НачатьИнициализациюЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(
		Новый Массив(), ФормаВладелец, ОповещениеОЗакрытии, Истина, Ложь, Ложь);
	
КонецПроцедуры

// Вызывает мастер настройки разрешений на использование внешних ресурсов в режиме
// отключения использования профилей безопасности для информационной базы.
//
// Параметры:
//  ФормаВладелец - УправляемаяФорма - форма, которая должна блокироваться до окончания применения разрешений,
//  ОповещениеОЗакрытии - ОписаниеОповещения - которое будет вызвано при успешном предоставлении разрешений.
//
Процедура НачатьОтключениеИспользованияПрофилейБезопасности(ФормаВладелец, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	НачатьИнициализациюЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(
		Новый Массив(), ФормаВладелец, ОповещениеОЗакрытии, Ложь, Истина, Ложь);
	
КонецПроцедуры

// Вызывает мастер настройки разрешений на использование внешних ресурсов в режиме
// восстановления настроек профилей безопасности в кластере серверов по текущему
// состоянию информационной базы.
//
// Параметры:
//  ФормаВладелец - УправляемаяФорма - форма, которая должна блокироваться до окончания применения разрешений,
//  ОповещениеОЗакрытии - ОписаниеОповещения - которое будет вызвано при успешном предоставлении разрешений.
//
Процедура НачатьВосстановлениеПрофилейБезопасности(ФормаВладелец, ОповещениеОЗакрытии = Неопределено) Экспорт
	
	НачатьИнициализациюЗапросаРазрешенийНаИспользованиеВнешнихРесурсов(
		Новый Массив(), ФормаВладелец, ОповещениеОЗакрытии, Ложь, Ложь, Истина);
	
КонецПроцедуры

// Проверяет необходимость отображения помощника настройки разрешений на использование
//  внешних (относительно кластера серверов 1С:Предприятия) ресурсов.
//
// Возвращаемое значение: Булево.
//
Функция ОтображатьПомощникНастройкиРазрешений()
	
	Возврат СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ОтображатьПомощникНастройкиРазрешений;
	
КонецФункции

// Конструктор структуры, которая используется для хранения состояния работы мастера
// настройки разрешений на использование внешних ресурсов.
//
// Возвращаемое значение: Структура - описание полей см. в теле функции.
//
Функция СостояниеЗапросаРазрешенийНаИспользованиеВнешнихРесурсов()
	
	Результат = Новый Структура();
	
	// Идентификаторы запросов на использование внешних ресурсов, которые должны быть
	// предоставлены - Массив(УникальныйИдентификатор).
	Результат.Вставить("ИдентификаторыЗапросов", Новый Массив());
	
	// Оригинальное описание оповещения, которое должно быть вызвано после того, как запрос
	// разрешений будет применен.
	Результат.Вставить("ОписаниеОповещения", Неопределено);
	
	// Адрес во временном хранилище, по которому размещаются данные, передаваемые между формами.
	Результат.Вставить("АдресХранилища", "");
	
	// Форма, из которой первоначально было инициализировано применение запросов на использование
	// внешних ресурсов.
	Результат.Вставить("ФормаВладелец");
	
	// Режим включения - признак выполнения включения использования профилей безопасности.
	Результат.Вставить("РежимВключения", Ложь);
	
	// Режим отключения - признак выполнения отключения использования профилей безопасности.
	Результат.Вставить("РежимОтключения", Ложь);
	
	// Режим восстановления - признак выполнения восстановления разрешений в профилях
	// безопасности (запрос разрешений выполняется "с чистого листа", игнорируя сохраненную
	// информацию о ранее предоставленных разрешениях.
	Результат.Вставить("РежимВосстановления", Ложь);
	
	// Режим проверки - признак завершения операции, в рамках которой предоставлялись новые разрешения
	// в профилях безопасности (например, в процессе записи элемента справочника были предоставлены разрешения
	// в профилях безопасности, а дальнейшая запись элемента справочника не была завершена).
	Результат.Вставить("РежимПроверки", Ложь);
	
	Возврат Результат;
	
КонецФункции

// Конструктор структуры, которая используется для хранения состояния проверки завершения
// операции, в рамках которой применялись запросы разрешений на использование внешних ресурсов.
//
// Возвращаемое значение: Структура - описание полей см. в теле функции.
//
Функция СостояниеПроверкиПримененияРазрешенийПослеЗакрытияФормыВладельца()
	
	Результат = Новый Структура();
	
	// Адрес во временном хранилище, по которому размещаются данные, передаваемые между формами.
	Результат.Вставить("АдресХранилища", Неопределено);
	
	// Оригинальное описание оповещения формы-владельца, которое должно быть вызвано после
	// выполнения проверки применения разрешений.
	Результат.Вставить("ОписаниеОповещения", Неопределено);
	
	Возврат Результат;
	
КонецФункции

// Возвращает длительность ожидания применения изменений в настройках профилей безопасности
// в кластере серверов.
//
// Возвращаемое значение - Число - длительность ожидания применения изменений (в секундах).
//
Функция ДлительностьОжиданияПримененияИзменений()
	
	Возврат 20; // Интервал, через который rphost запрашивает текущие настройки профилей безопасности из rmngr.
	
КонецФункции

#КонецОбласти