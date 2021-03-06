#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Процедура добавляет запись в регистр по переданным значениям структуры.
Процедура ДобавитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ПроверяемыеРеквизиты = Новый Массив;
	ПроверяемыеРеквизиты.Добавить("Идентификатор");
	ПроверяемыеРеквизиты.Добавить("ТипСоответствия");
	
	Для Каждого ПроверяемыйРеквизит Из ПроверяемыеРеквизиты Цикл
		Если СтруктураЗаписи.Свойство(ПроверяемыйРеквизит)
			И Не ЗначениеЗаполнено(СтруктураЗаписи[ПроверяемыйРеквизит]) Тогда
			
			ОписаниеСобытия = НСтр("ru = 'Добавление записи регистра сведений ""Mapping""'");
			Комментарий     = НСтр("ru = 'Не заполнен реквизит %1. Создание записи регистра невозможно.'");
			Комментарий     = СтрШаблон(Комментарий, ПроверяемыйРеквизит);
			ЗаписьЖурналаРегистрации(ОписаниеСобытия, 
			                         УровеньЖурналаРегистрации.Ошибка,
			                         Метаданные.РегистрыСведений.СоответствияОбъектовИнформационныхБаз,
			                         ,
			                         Комментарий);
			
			Возврат;
			
		КонецЕсли;
	КонецЦикла;
	
	ОбменДаннымиСервер.ДобавитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкаСинхронизацииОбъектовСВнешнимиСистемами", Загрузка);
	
КонецПроцедуры

// Процедура удаляет набор записей в регистре по переданным значениям структуры.
Процедура УдалитьЗапись(СтруктураЗаписи, Загрузка = Ложь) Экспорт
	
	ОбменДаннымиСервер.УдалитьНаборЗаписейВРегистреСведений(СтруктураЗаписи, "НастройкаСинхронизацииОбъектовСВнешнимиСистемами", Загрузка);
	
КонецПроцедуры

Функция ОбъектЕстьВРегистре(Идентификатор, ТипСоответствия, ТипОбъектаВнешнейСистемы) Экспорт
	
	ТекстЗапроса = "
	|ВЫБРАТЬ 1
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|ГДЕ
	|	  НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор           = &Идентификатор
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = &ТипСоответствия
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = &ТипОбъектаВнешнейСистемы
	|";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Идентификатор",           Идентификатор);
	Запрос.УстановитьПараметр("ТипСоответствия", ТипСоответствия);
	Запрос.УстановитьПараметр("ТипОбъектаВнешнейСистемы", ТипОбъектаВнешнейСистемы);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

Функция ОбъектЕстьВРегистреСУчетомПериода(Период, Идентификатор, ТипСоответствия, ТипОбъектаВнешнейСистемы) Экспорт
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	1
	               |ИЗ
	               |	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	               |ГДЕ
	               |	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор = &Идентификатор
	               |	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = &ТипСоответствия
	               |	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = &ТипОбъектаВнешнейСистемы
	               |	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = &Период";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период",                   Период);
	Запрос.УстановитьПараметр("Идентификатор",            Идентификатор);
	Запрос.УстановитьПараметр("ТипСоответствия",          ТипСоответствия);
	Запрос.УстановитьПараметр("ТипОбъектаВнешнейСистемы", ТипОбъектаВнешнейСистемы);
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Не Запрос.Выполнить().Пустой();
	
КонецФункции

#КонецОбласти

#КонецЕсли