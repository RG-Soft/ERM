﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Макет = ПланыОбмена.ОбменКлиентамиЧерезУниверсальныйФормат.ПолучитьМакет("ПодробнаяИнформация");
	ПолеHTMLДокумента = Макет.ПолучитьТекст();
	
	Заголовок = НСтр("ru = 'Информация о синхронизации данных'");

КонецПроцедуры

#КонецОбласти