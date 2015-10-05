﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает структуру параметров, необходимых для работы
// конфигурации на клиенте при запуске, т.е. в обработчиках событий.
// - ПередНачаломРаботыСистемы,
// - ПриНачалеРаботыСистемы
//
// Важно: при запуске недопустимо использовать команды сброса кэша
// повторно используемых модулей, иначе запуск может привести
// к непредсказуемым ошибкам и лишним серверным вызовам.
// 
// Возвращаемое значение:
//   ФиксированнаяСтруктура - структура параметров работы клиента при запуске.
//
Функция ПараметрыРаботыКлиентаПриЗапуске() Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ПараметрыПриЗапускеИЗавершенииПрограммы";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
	КонецЕсли;
	ПараметрыПриЗапускеИЗавершенииПрограммы = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыПриЗапускеИЗавершенииПрограммы"];
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПолученныеПараметрыКлиента", Неопределено);
	
	Если ПараметрыПриЗапускеИЗавершенииПрограммы.Свойство("ПолученныеПараметрыКлиента")
	   И ТипЗнч(ПараметрыПриЗапускеИЗавершенииПрограммы.ПолученныеПараметрыКлиента) = Тип("Структура") Тогда
		
		Параметры.Вставить("ПолученныеПараметрыКлиента",
			ПараметрыПриЗапускеИЗавершенииПрограммы.ПолученныеПараметрыКлиента);
	КонецЕсли;
	
	Если ПараметрыПриЗапускеИЗавершенииПрограммы.Свойство("ПропуститьОчисткуСкрытияРабочегоСтола") Тогда
		Параметры.Вставить("ПропуститьОчисткуСкрытияРабочегоСтола");
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		ЭтоВебКлиент = Истина;
	#Иначе
		ЭтоВебКлиент = Ложь;
	#КонецЕсли
	
	ИспользуемыйКлиент = "";
	#Если ТонкийКлиент Тогда
		ИспользуемыйКлиент = "ТонкийКлиент";
	#ИначеЕсли ТолстыйКлиентУправляемоеПриложение Тогда
		ИспользуемыйКлиент = "ТолстыйКлиентУправляемоеПриложение";
	#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
		ИспользуемыйКлиент = "ТолстыйКлиентОбычноеПриложение";
	#ИначеЕсли ВебКлиент Тогда
		ОписаниеБраузера = ТекущийБраузер();
		Если ПустаяСтрока(ОписаниеБраузера.Версия) Тогда
			ИспользуемыйКлиент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВебКлиент.%1", ОписаниеБраузера.Название);
		Иначе
			ИспользуемыйКлиент = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ВебКлиент.%1.%2", ОписаниеБраузера.Название, СтрРазделить(ОписаниеБраузера.Версия, ".")[0]);
		КонецЕсли;
	#КонецЕсли
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ЭтоLinuxКлиент = СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86
	              ИЛИ СистемнаяИнформация.ТипПлатформы = ТипПлатформы.Linux_x86_64;

	Параметры.Вставить("ПараметрЗапуска", ПараметрЗапуска);
	Параметры.Вставить("СтрокаСоединенияИнформационнойБазы", СтрокаСоединенияИнформационнойБазы());
	Параметры.Вставить("ЭтоВебКлиент",         ЭтоВебКлиент);
	Параметры.Вставить("ЭтоВебКлиентПодMacOS", ОбщегоНазначенияКлиентПовтИсп.ЭтоВебКлиентПодMacOS());
	Параметры.Вставить("ЭтоLinuxКлиент",       ЭтоLinuxКлиент);
	Параметры.Вставить("ИспользуемыйКлиент",   ИспользуемыйКлиент);
	Параметры.Вставить("СкрытьРабочийСтолПриНачалеРаботыСистемы", Ложь);
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	ОперативнаяПамять = Окр(СистемнаяИнформация.ОперативнаяПамять / 1024, 1);
	Параметры.Вставить("ОперативнаяПамять", ОперативнаяПамять);
	
	ПараметрыКлиента = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиентаПриЗапуске(Параметры);
	
	// Обновление состояния скрытия рабочего стола на клиенте по состоянию на сервере.
	СтандартныеПодсистемыКлиент.СкрытьРабочийСтолПриНачалеРаботыСистемы(
		Параметры.СкрытьРабочийСтолПриНачалеРаботыСистемы, Истина);
	
	Возврат ПараметрыКлиента;
	
КонецФункции

// Возвращает структуру параметров, необходимых для работы
// конфигурации на клиенте.
// 
// Возвращаемое значение:
//   ФиксированнаяСтруктура - структура параметров работы клиента при запуске.
//
Функция ПараметрыРаботыКлиента() Экспорт
	
	ТекущаяДата = ТекущаяДата(); // Текущая дата клиентского компьютера.
	
	ПараметрыРаботыКлиента = Новый Структура;
	ПараметрыРаботы = СтандартныеПодсистемыВызовСервера.ПараметрыРаботыКлиента();
	Для Каждого Параметр Из ПараметрыРаботы Цикл
		ПараметрыРаботыКлиента.Вставить(Параметр.Ключ, Параметр.Значение);
	КонецЦикла;
	ПараметрыРаботыКлиента.ПоправкаКВремениСеанса = ПараметрыРаботыКлиента.ПоправкаКВремениСеанса - ТекущаяДата;
	
	Возврат Новый ФиксированнаяСтруктура(ПараметрыРаботыКлиента);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает массив описаний обработчиков клиентского события.
Функция ОбработчикиКлиентскогоСобытия(Событие, Служебное = Ложь) Экспорт
	
	ПодготовленныеОбработчики = ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное);
	
	Если ПодготовленныеОбработчики = Неопределено Тогда
		// Автообновление кэша. Обновление повторно используемых значений требуется.
		СтандартныеПодсистемыВызовСервера.ПриОшибкеПолученияОбработчиковСобытия();
		ОбновитьПовторноИспользуемыеЗначения();
		// Повторная попытка получить обработчики события.
		ПодготовленныеОбработчики = ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное, Ложь);
	КонецЕсли;
	
	Возврат ПодготовленныеОбработчики;
	
КонецФункции

// Возвращает соответствие имен и клиентских модулей.
Функция ИменаКлиентскихМодулей() Экспорт
	
	МассивИмен = СтандартныеПодсистемыВызовСервера.МассивИменКлиентскихМодулей();
	
	КлиентскиеМодули = Новый Соответствие;
	
	Для каждого Имя Из МассивИмен Цикл
		КлиентскиеМодули.Вставить(Вычислить(Имя), Имя);
	КонецЦикла;
	
	Возврат Новый ФиксированноеСоответствие(КлиентскиеМодули);
	
КонецФункции

Функция ТекущийБраузер()
	
	Результат = Новый Структура("Название,Версия", "Другой", "");
	
	СистемнаяИнформация = Новый СистемнаяИнформация;
	Строка = СистемнаяИнформация.ИнформацияПрограммыПросмотра;
	Строка = СтрЗаменить(Строка, ",", ";");

	// Opera
	Идентификатор = "Opera";
	Позиция = СтрНайти(Строка, Идентификатор, НаправлениеПоиска.СКонца);
	Если Позиция > 0 Тогда
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Результат.Название = "Opera";
		Идентификатор = "Version/";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Результат.Версия = СокрЛП(Строка);
		Иначе
			Строка = СокрЛП(Строка);
			Если СтрНачинаетсяС(Строка, "/") Тогда
				Строка = Сред(Строка, 2);
			КонецЕсли;
			Результат.Версия = СокрЛ(Строка);
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// IE
	Идентификатор = "MSIE"; // v11-
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "IE";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Позиция = СтрНайти(Строка, ";");
		Если Позиция > 0 Тогда
			Строка = СокрЛ(Лев(Строка, Позиция - 1));
			Результат.Версия = Строка;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	Идентификатор = "Trident"; // v11+
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "IE";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		
		Идентификатор = "rv:";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Позиция = СтрНайти(Строка, ")");
			Если Позиция > 0 Тогда
				Строка = СокрЛ(Лев(Строка, Позиция - 1));
				Результат.Версия = Строка;
			КонецЕсли;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Chrome
	Идентификатор = "Chrome/";
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "Chrome";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Позиция = СтрНайти(Строка, " ");
		Если Позиция > 0 Тогда
			Строка = СокрЛ(Лев(Строка, Позиция - 1));
			Результат.Версия = Строка;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Safari
	Идентификатор = "Safari/";
	Если СтрНайти(Строка, Идентификатор) > 0 Тогда
		Результат.Название = "Safari";
		Идентификатор = "Version/";
		Позиция = СтрНайти(Строка, Идентификатор);
		Если Позиция > 0 Тогда
			Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
			Позиция = СтрНайти(Строка, " ");
			Если Позиция > 0 Тогда
				Результат.Версия = СокрЛП(Лев(Строка, Позиция - 1));
			КонецЕсли;
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;

	// Firefox
	Идентификатор = "Firefox/";
	Позиция = СтрНайти(Строка, Идентификатор);
	Если Позиция > 0 Тогда
		Результат.Название = "Firefox";
		Строка = Сред(Строка, Позиция + СтрДлина(Идентификатор));
		Если Не ПустаяСтрока(Строка) Тогда
			Результат.Версия = СокрЛП(Строка);
		КонецЕсли;
		Возврат Результат;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с предопределенными данными.

// Получает ссылку предопределенного элемента по его полному имени.
//  Подробнее - см. ОбщегоНазначенияКлиентСервер.ПредопределенныйЭлемент();
//
Функция ПредопределенныйЭлемент(Знач ПолноеИмяПредопределенного) Экспорт
	
	Возврат СтандартныеПодсистемыВызовСервера.ПредопределенныйЭлемент(ПолноеИмяПредопределенного);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПодготовленныеОбработчикиКлиентскогоСобытия(Событие, Служебное = Ложь, ПерваяПопытка = Истина)
	
	Параметры = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске().ОбработчикиКлиентскихСобытий;
	
	Если Служебное Тогда
		Обработчики = Параметры.ОбработчикиСлужебныхСобытий.Получить(Событие);
	Иначе
		Обработчики = Параметры.ОбработчикиСобытий.Получить(Событие);
	КонецЕсли;
	
	Если ПерваяПопытка И Обработчики = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Обработчики = Неопределено Тогда
		Если Служебное Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не найдено клиентское служебное событие ""%1"".'"), Событие);
		Иначе
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Не найдено клиентское событие ""%1"".'"), Событие);
		КонецЕсли;
	КонецЕсли;
	
	Массив = Новый Массив;
	
	Для каждого Обработчик Из Обработчики Цикл
		Элемент = Новый Структура;
		Модуль = Неопределено;
		Если ПерваяПопытка Тогда
			Попытка
				Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль(Обработчик.Модуль);
			Исключение
				Возврат Неопределено;
			КонецПопытки;
		Иначе
			Модуль = ОбщегоНазначенияКлиент.ОбщийМодуль(Обработчик.Модуль);
		КонецЕсли;
		Элемент.Вставить("Модуль",     Модуль);
		Элемент.Вставить("Версия",     Обработчик.Версия);
		Элемент.Вставить("Подсистема", Обработчик.Подсистема);
		Массив.Добавить(Новый ФиксированнаяСтруктура(Элемент));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(Массив);
	
КонецФункции

#КонецОбласти
