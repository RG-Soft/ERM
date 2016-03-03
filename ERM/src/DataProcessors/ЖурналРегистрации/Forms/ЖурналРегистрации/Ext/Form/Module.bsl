﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОтборЖурналаРегистрации = Новый Структура;
	ОтборЖурналаРегистрацииПоУмолчанию = Новый Структура;
	ЗначенияОтбора = ПолучитьЗначенияОтбораЖурналаРегистрации("Событие").Событие;
	
	Если Не ПустаяСтрока(Параметры.Пользователь) Тогда
		Если ТипЗнч(Параметры.Пользователь) = Тип("СписокЗначений") Тогда
			ОтборПоПользователю = Параметры.Пользователь;
		Иначе
			ИмяПользователя = Параметры.Пользователь;
			ОтборПоПользователю = Новый СписокЗначений;
			ПоПользователю = ОтборПоПользователю.Добавить(ИмяПользователя, ИмяПользователя);
		КонецЕсли;
		ОтборЖурналаРегистрации.Вставить("Пользователь", ОтборПоПользователю);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.СобытиеЖурналаРегистрации) Тогда
		ОтборПоСобытию = Новый СписокЗначений;
		Если ТипЗнч(Параметры.СобытиеЖурналаРегистрации) = Тип("Массив") Тогда
			Для Каждого Событие Из Параметры.СобытиеЖурналаРегистрации Цикл
				ПредставлениеСобытия = ЗначенияОтбора[Событие];
				ОтборПоСобытию.Добавить(Событие, ПредставлениеСобытия);
			КонецЦикла;
		Иначе
			ОтборПоСобытию.Добавить(Параметры.СобытиеЖурналаРегистрации, Параметры.СобытиеЖурналаРегистрации);
		КонецЕсли;
		ОтборЖурналаРегистрации.Вставить("Событие", ОтборПоСобытию);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ДатаНачала) Тогда
		ОтборЖурналаРегистрации.Вставить("ДатаНачала", Параметры.ДатаНачала);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ДатаОкончания) Тогда
		ОтборЖурналаРегистрации.Вставить("ДатаОкончания", Параметры.ДатаОкончания + 1);
	КонецЕсли;
	
	Если Параметры.Данные <> Неопределено Тогда
		ОтборЖурналаРегистрации.Вставить("Данные", Параметры.Данные);
	КонецЕсли;
	
	Если Параметры.Сеанс <> Неопределено Тогда
		ОтборЖурналаРегистрации.Вставить("Сеанс", Параметры.Сеанс);
	КонецЕсли;
	
	// Уровень - список значений.
	Если Параметры.Уровень <> Неопределено Тогда
		ОтборЖурналаРегистрации.Вставить("Уровень", Параметры.Уровень);
	КонецЕсли;
	
	// ИмяПриложения - список значений.
	Если Параметры.ИмяПриложения <> Неопределено Тогда
		СписокПриложений = Новый СписокЗначений;
		Для Каждого Приложение Из Параметры.ИмяПриложения Цикл
			СписокПриложений.Добавить(Приложение, ПредставлениеПриложения(Приложение));
		КонецЦикла;
		ОтборЖурналаРегистрации.Вставить("ИмяПриложения", СписокПриложений);
	КонецЕсли;
	
	КоличествоПоказываемыхСобытий = 200;
	
	ОтборПоУмолчанию = ОтборПоУмолчанию(ЗначенияОтбора);
	Если Не ОтборЖурналаРегистрации.Свойство("Событие") Тогда
		ОтборЖурналаРегистрации.Вставить("Событие", ОтборПоУмолчанию);
	КонецЕсли;
	ОтборЖурналаРегистрацииПоУмолчанию.Вставить("Событие", ОтборПоУмолчанию);
	Элементы.ПредставлениеРазделенияДанныхСеанса.Видимость = Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных();
	
	Критичность = "ВсеСобытия";
	
	// Взводится в значение Истина, если нужно, чтобы формирование журнала регистрации проходило не в фоне.
	ЗапускатьНеВФоне = Параметры.ЗапускатьНеВФоне;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ПодключитьОбработчикОжидания("ОбновитьТекущийСписок", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если ИдентификаторЗадания <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КоличествоПоказываемыхСобытийПриИзменении(Элемент)
	
#Если ВебКлиент Тогда
	КоличествоПоказываемыхСобытий = ?(КоличествоПоказываемыхСобытий > 1000, 1000, КоличествоПоказываемыхСобытий);
#КонецЕсли
	
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура КритичностьПриИзменении(Элемент)
	
	Если Критичность = "ВсеСобытия" Тогда
		ОтборЖурналаРегистрации.Удалить("Уровень");
		ОбновитьТекущийСписок();
	ИначеЕсли Критичность = "Ошибки" Тогда
		ОтборПоУровню = Новый СписокЗначений;
		ОтборПоУровню.Добавить("Ошибка", "Ошибка");
		ОтборЖурналаРегистрации.Удалить("Уровень");
		ОтборЖурналаРегистрации.Вставить("Уровень", ОтборПоУровню);
		ОбновитьТекущийСписок();
	ИначеЕсли Критичность = "Предупреждения" Тогда
		ОтборПоУровню = Новый СписокЗначений;
		ОтборПоУровню.Добавить("Предупреждение", "Предупреждение");
		ОтборЖурналаРегистрации.Удалить("Уровень");
		ОтборЖурналаРегистрации.Вставить("Уровень", ОтборПоУровню);
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыЖурнал

&НаКлиенте
Процедура ЖурналВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ЖурналРегистрацииКлиент.СобытияВыбор(
		Элементы.Журнал.ТекущиеДанные, 
		Поле, 
		ИнтервалДат, 
		ОтборЖурналаРегистрации);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") И ВыбранноеЗначение.Свойство("Событие") Тогда
		
		Если ВыбранноеЗначение.Событие = "УстановленОтборЖурналаРегистрации" Тогда
			
			ОтборЖурналаРегистрации.Очистить();
			Для Каждого ЭлементСписка Из ВыбранноеЗначение.Отбор Цикл
				ОтборЖурналаРегистрации.Вставить(ЭлементСписка.Представление, ЭлементСписка.Значение);
			КонецЦикла;
			
			Если ОтборЖурналаРегистрации.Свойство("Уровень")
				И ОтборЖурналаРегистрации.Уровень.Количество() > 1 Тогда
				Критичность = "";
			КонецЕсли;
			
			ОбновитьТекущийСписок();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОбновитьТекущийСписок()
	
	Элементы.Страницы.ТекущаяСтраница = Элементы.ИндикаторДлительныхОпераций;
	
	РезультатВыполнения = ПрочитатьЖурнал();
	
	ПараметрыОбработчикаОжидания = Новый Структура;
	
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "ФормированиеОтчета");
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор()
	
	ОтборЖурналаРегистрации = ОтборЖурналаРегистрацииПоУмолчанию;
	Критичность = "ВсеСобытия";
	ОбновитьТекущийСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьДанныеДляПросмотра()
	
	ЖурналРегистрацииКлиент.ОткрытьДанныеДляПросмотра(Элементы.Журнал.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрТекущегоСобытияВОтдельномОкне()
	
	ЖурналРегистрацииКлиент.ПросмотрТекущегоСобытияВОтдельномОкне(Элементы.Журнал.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотра()
	
	Оповещение = Новый ОписаниеОповещения("УстановитьИнтервалДатДляПросмотраЗавершение", ЭтотОбъект);
	ЖурналРегистрацииКлиент.УстановитьИнтервалДатДляПросмотра(ИнтервалДат, ОтборЖурналаРегистрации, Оповещение)
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтбор()
	
	УстановитьОтборНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеОтбораНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	УстановитьОтборНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоЗначениюВТекущейКолонке()
	
	КолонкиИсключения = Новый Массив;
	КолонкиИсключения.Добавить("Дата");
	
	Если ЖурналРегистрацииКлиент.УстановитьОтборПоЗначениюВТекущейКолонке(
			Элементы.Журнал.ТекущиеДанные,
			Элементы.Журнал.ТекущийЭлемент,
			ОтборЖурналаРегистрации,
			КолонкиИсключения) Тогда
		
		ОбновитьТекущийСписок();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьИнтервалДатДляПросмотраЗавершение(ИнтервалУстановлен, ДополнительныеПараметры) Экспорт
	
	Если ИнтервалУстановлен Тогда
		ОбновитьТекущийСписок();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
КонецПроцедуры

&НаСервере
Функция ОтборПоУмолчанию(СписокСобытий)
	
	ОтборПоУмолчанию = Новый СписокЗначений;
	
	Для Каждого СобытиеЖурнала Из СписокСобытий Цикл
		
		Если СобытиеЖурнала.Ключ = "_$Transaction$_.Commit"
			Или СобытиеЖурнала.Ключ = "_$Transaction$_.Begin"
			Или СобытиеЖурнала.Ключ = "_$Transaction$_.Rollback" Тогда
			Продолжить;
		КонецЕсли;
		
		ОтборПоУмолчанию.Добавить(СобытиеЖурнала.Ключ, СобытиеЖурнала.Значение);
		
	КонецЦикла;
	
	Возврат ОтборПоУмолчанию;
КонецФункции

&НаСервере
Функция ПрочитатьЖурнал()
	
	ПараметрыОтчета = ПараметрыОтчета();
	
	Если Не ПроверитьЗаполнение() Тогда 
		Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	КонецЕсли;
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
	
	Попытка
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"ЖурналРегистрации.ПрочитатьСобытияЖурналаРегистрации",
			ПараметрыОтчета,
			НСтр("ru = 'Обновление журнала регистрации'"));
			
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	Исключение
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ВызватьИсключение;
	КонецПопытки;
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	ЖурналРегистрации.СформироватьПредставлениеОтбора(ПредставлениеОтбора, ОтборЖурналаРегистрации, ОтборЖурналаРегистрацииПоУмолчанию);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПараметрыОтчета()
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ОтборЖурналаРегистрации", ОтборЖурналаРегистрации);
	ПараметрыОтчета.Вставить("КоличествоПоказываемыхСобытий", КоличествоПоказываемыхСобытий);
	ПараметрыОтчета.Вставить("УникальныйИдентификатор", УникальныйИдентификатор);
	ПараметрыОтчета.Вставить("МенеджерВладельца", Обработки.ЖурналРегистрации);
	ПараметрыОтчета.Вставить("ДобавлятьДополнительныеКолонки", Ложь);
	ПараметрыОтчета.Вставить("Журнал", РеквизитФормыВЗначение("Журнал"));

	Возврат ПараметрыОтчета;
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	СобытияЖурнала       = РезультатВыполнения.СобытияЖурнала;
	
	ЖурналРегистрации.ПоместитьДанныеВоВременноеХранилище(СобытияЖурнала, УникальныйИдентификатор);
	
	ЗначениеВДанныеФормы(СобытияЖурнала, Журнал);
	ИдентификаторЗадания = Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ПозиционированиеВКонецСписка()
	Если Журнал.Количество() > 0 Тогда
		Элементы.Журнал.ТекущаяСтрока = Журнал[Журнал.Количество() - 1].ПолучитьИдентификатор();
	КонецЕсли;
КонецПроцедуры 

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()  
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
			Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
			ПозиционированиеВКонецСписка();
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.ПолеИндикаторДлительныхОпераций, "НеИспользовать");
		Элементы.Страницы.ТекущаяСтраница = Элементы.ЖурналРегистрации;
		ПозиционированиеВКонецСписка();
		ВызватьИсключение;
	КонецПопытки;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиенте
Процедура УстановитьОтборНаКлиенте()
	
	ОтборФормы = Новый СписокЗначений;
	Для Каждого КлючИЗначение Из ОтборЖурналаРегистрации Цикл
		ОтборФормы.Добавить(КлючИЗначение.Значение, КлючИЗначение.Ключ);
	КонецЦикла;
	
	ОткрытьФорму(
		"Обработка.ЖурналРегистрации.Форма.ОтборЖурналаРегистрации", 
		Новый Структура("Отбор, СобытияПоУмолчанию", ОтборФормы, ОтборЖурналаРегистрацииПоУмолчанию.Событие), 
		ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
