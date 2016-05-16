﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	// Отбор по полю "Организация" всегда выполняется по головной организации.
	Если Параметры.Отбор.Свойство("Организация") Тогда
		Если ЗначениеЗаполнено(Параметры.Отбор.Организация) Тогда
			Параметры.Отбор.Организация = ОбщегоНазначенияВызовСервераПовтИсп.ГоловнаяОрганизация(Параметры.Отбор.Организация);
		КонецЕсли;
	КонецЕсли;

	Если Параметры.Свойство("ВалютаВзаиморасчетовНеРавно") Тогда
		ОтборыСписковКлиентСервер.УстановитьЭлементОтбораСписка(Список, "ВалютаВзаиморасчетов",
		                                                        Параметры.ВалютаВзаиморасчетовНеРавно,
		                                                        ВидСравненияКомпоновкиДанных.НеРавно);
	КонецЕсли;
	
	ОткрытИзПлатежки = Параметры.Свойство("ОткрытИзПлатежки");
	
	Справочники.ДоговорыКонтрагентов.УстановитьДоступныеВидыДоговора(Параметры.Отбор);

	//// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	//ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	//ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
	//	ЭтаФорма,
	//	"БП.Справочник.ДоговорыКонтрагентов",
	//	"ФормаВыбора",
	//	НСтр("ru='Новости: Договор'"),
	//	ИдентификаторыСобытийПриОткрытии
	//);
	//// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	//ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	//ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	
	ДанныеСтроки = Элемент.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Оповестить("Запись_ДоговорыКонтрагентов", , ДанныеСтроки.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)

	Если Группа Тогда
		Возврат;
	КонецЕсли;

	Отказ = Истина;

	ПараметрыФормы = Новый Структура;
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
	ИначеЕсли ОткрытИзПлатежки Тогда
		ПараметрыФормы.Вставить("ОткрытИзПлатежки");
	КонецЕсли;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("Родитель", Родитель);

	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)

	СписокПуст = Элементы.Список.ТекущиеДанные = Неопределено;
	
	Если СписокПуст или Элементы.Список.ТекущиеДанные.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли;

	Отказ = Истина;

	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());

	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	//УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Функция СтруктураОтборовСписка()

	СтруктураОтборов = Новый Структура;
	Для каждого ЭлементОтбора Из Список.Отбор.Элементы Цикл
		Если НЕ ЭлементОтбора.Использование Тогда
			Продолжить;
		КонецЕсли;
		Если ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда 
			СтруктураОтборов.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение);
		ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
			СтруктураОтборов.Вставить(Строка(ЭлементОтбора.ЛевоеЗначение), ЭлементОтбора.ПравоеЗначение.ВыгрузитьЗначения());
		КонецЕсли;
	КонецЦикла;
	Возврат СтруктураОтборов;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПоказатьКонтекстныеНовости(Команда)

	//ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаКомандыНовости(
	//	ЭтаФорма,
	//	Команда
	//);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеФункцииИПроцедуры

// Процедура показывает новости, требующие прочтения (важные и очень важные)
//
// Параметры:
//  Нет
//
&НаКлиенте
Процедура Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии()

	// ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии
	ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	// Конец ИнтернетПоддержкаПользователей.Новости.Подключаемый_ПоказатьНовостиТребующиеПрочтенияПриОткрытии

	//ОбработкаНовостейКлиент.КонтекстныеНовости_ПоказатьНовостиТребующиеПрочтенияПриОткрытии(ЭтаФорма, ИдентификаторыСобытийПриОткрытии);

КонецПроцедуры

#КонецОбласти