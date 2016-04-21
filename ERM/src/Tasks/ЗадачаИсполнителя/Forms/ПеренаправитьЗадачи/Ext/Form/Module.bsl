﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТекстЗаголовкаФормы = Параметры.ЗаголовокФормы;
	ЗаголовокПоУмолчанию = ПустаяСтрока(ТекстЗаголовкаФормы);
	Если НЕ ЗаголовокПоУмолчанию Тогда
		Заголовок = ТекстЗаголовкаФормы;
	КонецЕсли;
	
	ТекстЗаголовка = "";
	
	Если Параметры.КоличествоЗадач > 1 Тогда
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 (%2)'"),
			?(ЗаголовокПоУмолчанию, НСтр("ru = 'Выбрано задач'"), ТекстЗаголовкаФормы),
			Строка(Параметры.КоличествоЗадач));
	ИначеЕсли Параметры.КоличествоЗадач = 1 Тогда
		ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 %2'"),
			?(ЗаголовокПоУмолчанию, НСтр("ru = 'Выбранная задача'"), ТекстЗаголовкаФормы),
			Строка(Параметры.Задача));
	Иначе
		Элементы.ДекорацияЗаголовок.Видимость = Ложь;
	КонецЕсли;
	Элементы.ДекорацияЗаголовок.Заголовок = ТекстЗаголовка;
	
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если ТипАдресации = 0 Тогда
		Если НЕ ЗначениеЗаполнено(Исполнитель) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не указан исполнитель задачи.'"),,,
				"Исполнитель",
				Отказ);
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Роль.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указана роль исполнителей задачи.'"),,,
			"Роль",
			Отказ);
		Возврат;
	КонецЕсли;
	
	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации
		И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации 
		И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
	
	Если ЗаданыТипыОсновногоОбъектаАдресации И ОсновнойОбъектАдресации = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"),	Роль.ТипыОсновногоОбъектаАдресации.Наименование),,,
			"ОсновнойОбъектАдресации",
			Отказ);
		Возврат;
	ИначеЕсли ЗаданыТипыДополнительногоОбъектаАдресации И ДополнительныйОбъектАдресации = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"), Роль.ТипыДополнительногоОбъектаАдресации.Наименование),,,
			"ДополнительныйОбъектАдресации",
			Отказ);
		Возврат;
	КонецЕсли;
	
	Если НЕ ИгнорироватьПредупреждения 
		И НЕ БизнесПроцессыИЗадачиСервер.ЕстьИсполнителиРоли(Роль, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'На указанную роль не назначено ни одного исполнителя. (Чтобы проигнорировать это предупреждение, установите флажок.)'"),,,
			"Роль",
			Отказ);
		Элементы.ИгнорироватьПредупреждения.Видимость = Истина;
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИсполнительПриИзменении(Элемент)
	
	ТипАдресации = 0;
	РольИсполнителя = Неопределено;
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура РольПриИзменении(Элемент)
	
	ТипАдресации = 1;
	Исполнитель = Неопределено;
	ОсновнойОбъектАдресации = Неопределено;
	ДополнительныйОбъектАдресации = Неопределено;
	УстановитьТипыОбъектовАдресации();
	УстановитьСостояниеЭлементов();
	
КонецПроцедуры

&НаКлиенте
Процедура ТипАдресацииПриИзменении(Элемент)
	УстановитьСостояниеЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	ОчиститьСообщения();
	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	Закрыть(ПараметрыЗакрытия());
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьТипыОбъектовАдресации()
	
	ТипыОсновногоОбъектаАдресации = Роль.ТипыОсновногоОбъектаАдресации.ТипЗначения;
	ТипыДополнительногоОбъектаАдресации = Роль.ТипыДополнительногоОбъектаАдресации.ТипЗначения;
	ИспользуетсяСОбъектамиАдресации = Роль.ИспользуетсяСОбъектамиАдресации;
	ИспользуетсяБезОбъектовАдресации = Роль.ИспользуетсяБезОбъектовАдресации;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСостояниеЭлементов()
	
	Элементы.Исполнитель.ОтметкаНезаполненного = Ложь;
	Элементы.Исполнитель.АвтоОтметкаНезаполненного = ТипАдресации = 0;
	Элементы.Исполнитель.Доступность = ТипАдресации = 0;
	Элементы.Роль.ОтметкаНезаполненного = Ложь;
	Элементы.Роль.АвтоОтметкаНезаполненного = ТипАдресации <> 0;
	Элементы.Роль.Доступность = ТипАдресации <> 0;
	
	ЗаданыТипыОсновногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации
		И ЗначениеЗаполнено(ТипыОсновногоОбъектаАдресации);
	ЗаданыТипыДополнительногоОбъектаАдресации = ИспользуетсяСОбъектамиАдресации 
		И ЗначениеЗаполнено(ТипыДополнительногоОбъектаАдресации);
		
	Элементы.ОсновнойОбъектАдресации.Заголовок = Роль.ТипыОсновногоОбъектаАдресации.Наименование;
	Элементы.ОдинОсновнойОбъектАдресации.Заголовок = Роль.ТипыОсновногоОбъектаАдресации.Наименование;
	
	Если ЗаданыТипыОсновногоОбъектаАдресации И ЗаданыТипыДополнительногоОбъектаАдресации Тогда
		Элементы.ГруппаОдинОбъектАдресации.Видимость = Ложь;
		Элементы.ГруппаДваОбъектаАдресации.Видимость = Истина;
	ИначеЕсли ЗаданыТипыОсновногоОбъектаАдресации Тогда
		Элементы.ГруппаОдинОбъектАдресации.Видимость = Истина;
		Элементы.ГруппаДваОбъектаАдресации.Видимость = Ложь;
	Иначе	
		Элементы.ГруппаОдинОбъектАдресации.Видимость = Ложь;
		Элементы.ГруппаДваОбъектаАдресации.Видимость = Ложь;
	КонецЕсли;
		
	Элементы.ДополнительныйОбъектАдресации.Заголовок = Роль.ТипыДополнительногоОбъектаАдресации.Наименование;
	
	Элементы.ОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыОсновногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ОдинОсновнойОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыОсновногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ДополнительныйОбъектАдресации.АвтоОтметкаНезаполненного = ЗаданыТипыДополнительногоОбъектаАдресации
		И НЕ ИспользуетсяБезОбъектовАдресации;
	Элементы.ОдинОсновнойОбъектАдресации.ОграничениеТипа = ТипыОсновногоОбъектаАдресации;
	Элементы.ОсновнойОбъектАдресации.ОграничениеТипа = ТипыОсновногоОбъектаАдресации;
	Элементы.ДополнительныйОбъектАдресации.ОграничениеТипа = ТипыДополнительногоОбъектаАдресации;
	
КонецПроцедуры

&НаКлиенте
Функция ПараметрыЗакрытия()
	
	Результат = Новый Структура;
	Результат.Вставить("Исполнитель", Исполнитель);
	Результат.Вставить("РольИсполнителя", Роль);
	Результат.Вставить("ОсновнойОбъектАдресации", 
		?(ОсновнойОбъектАдресации <> Неопределено И НЕ ОсновнойОбъектАдресации.Пустая(), ОсновнойОбъектАдресации, Неопределено));
	Результат.Вставить("ДополнительныйОбъектАдресации", 
		?(ДополнительныйОбъектАдресации <> Неопределено И НЕ ДополнительныйОбъектАдресации.Пустая(), ДополнительныйОбъектАдресации, Неопределено));
	Результат.Вставить("Комментарий", Комментарий);
	Возврат Результат;
	
КонецФункции

#КонецОбласти
