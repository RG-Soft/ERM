
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//// СтандартныеПодсистемы.Печать
	//УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ГруппаКоманднаяПанель);
	//// Конец СтандартныеПодсистемы.Печать
	//
	//// СтандартныеПодсистемы.ВерсионированиеОбъектов
	//ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	//// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Отбор.Свойство("Владелец") Тогда
		ОтборОрганизация = Параметры.Отбор.Владелец;
		Параметры.Отбор.Удалить("Владелец");
	//ИначеЕсли НЕ Справочники.Организации.ИспользуетсяНесколькоОрганизаций() Тогда
		//ОтборОрганизация = РаботаСНСИПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация");
	КонецЕсли;
	
	ОтборОрганизацияИспользование = ЗначениеЗаполнено(ОтборОрганизация);
	Элементы.ОтборОрганизация.Видимость = ОтборОрганизацияИспользование;
	
	ТипВладельца = ТипЗнч(ОтборОрганизация);
	Если ОтборОрганизацияИспользование Тогда
		Если ТипВладельца = Тип("СправочникСсылка.Контрагенты") Тогда
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Контрагент'");
		ИначеЕсли ТипВладельца = Тип("СправочникСсылка.ФизическиеЛица") Тогда
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Физическое лицо'");
		ИначеЕсли ТипВладельца = Тип("СправочникСсылка.Организации") Тогда
			//Элементы.ОтборОрганизация.Видимость = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
			Элементы.ОтборОрганизация.Видимость = Истина;
			Элементы.ОтборОрганизация.Заголовок = НСтр("ru = 'Организация'");
		КонецЕсли;
	КонецЕсли;
	
	//Элементы.СоглашениеОПрямомОбмене.Видимость =
	//	ПолучитьФункциональнуюОпцию("ИспользоватьОбменСБанками") И ТипВладельца = Тип("СправочникСсылка.Организации");
	Элементы.СоглашениеОПрямомОбмене.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборПоОрганизации();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборПоОрганизации()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(
		ЭтотОбъект.Список.КомпоновщикНастроек.ФиксированныеНастройки.Отбор,
		"Владелец",
		ОтборОрганизация,
		Неопределено,
		,
		ОтборОрганизацияИспользование);
	
КонецПроцедуры

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


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	Если Копирование Тогда
		ПараметрыФормы.Вставить("ЗначениеКопирования", Элементы.Список.ТекущиеДанные.Ссылка);
	КонецЕсли;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());
	ПараметрыФормы.ЗначенияЗаполнения.Вставить("Владелец", ОтборОрганизация);
	
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект,,,,, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	СписокПуст = Элементы.Список.ТекущиеДанные = Неопределено;
	
	Если СписокПуст Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элемент.ТекущаяСтрока);
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", СтруктураОтборовСписка());
	
	ОткрытьФорму("Справочник.БанковскиеСчета.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	//УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Элементы.Список);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

#КонецОбласти
