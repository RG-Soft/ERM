﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	// Проверим, выполняется ли копирование группы.
	Если Копирование И Группа Тогда
		Отказ = Истина;
		
		ПоказатьПредупреждение(, НСтр("ru='Добавление новых групп в справочнике запрещено.'"));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПереместитьЭлементВверх()
	
	Если Не ВозможноПеремещениеЭлемента(Элементы.Список.ТекущиеДанные.Ссылка, "Вверх") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Перемещение данного вида контактной информации не предусмотрено'"));
		Возврат;
	КонецЕсли;
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВверхВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

&НаКлиенте
Процедура ПереместитьЭлементВниз()
	
	Если Не ВозможноПеремещениеЭлемента(Элементы.Список.ТекущиеДанные.Ссылка, "Вниз") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Нстр("ru = 'Перемещение данного вида контактной информации не предусмотрено'"));
		Возврат;
	КонецЕсли;
	
	НастройкаПорядкаЭлементовКлиент.ПереместитьЭлементВнизВыполнить(Список, Элементы.Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ВозможноПеремещениеЭлемента(ТекущийЭлемент, Направление)
	
	СоседнийЭлемент = НастройкаПорядкаЭлементовСлужебный.СоседнийЭлемент(ТекущийЭлемент, Список, Направление);
	
	Возврат СоседнийЭлемент = Неопределено Или Не (ТекущийЭлемент.ЗапретитьРедактированиеПользователем Или СоседнийЭлемент.ЗапретитьРедактированиеПользователем);
	
КонецФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	//Элемент = Список.УсловноеОформление.Элементы.Добавить();
	//
	//ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	//ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Используется");
	//ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	//ОтборЭлемента.ПравоеЗначение = Ложь;
	//Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
КонецПроцедуры

#КонецОбласти