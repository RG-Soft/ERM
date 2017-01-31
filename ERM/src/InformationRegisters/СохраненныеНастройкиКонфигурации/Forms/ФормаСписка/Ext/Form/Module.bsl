﻿
&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если НЕ Элемент.ТекущиеДанные.ЭтоГруппа Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ПараметрыФормы = Новый Структура();
		
		Если Элемент.ТекущиеДанные.Значение = "<Значение не установлено>" Тогда
			КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.СохраненныеНастройкиКонфигурации");
			ЗначенияЗаполнения = Новый Структура("Настройка", Элемент.ТекущиеДанные.Настройка);
			ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		Иначе
			ДанныеКлючаЗаписи = Новый Структура("Настройка", Элемент.ТекущиеДанные.Настройка);
			МассивПараметровКонструктора = Новый Массив();
			МассивПараметровКонструктора.Добавить(ДанныеКлючаЗаписи);
			КлючЗаписи = Новый("РегистрСведенийКлючЗаписи.СохраненныеНастройкиКонфигурации", МассивПараметровКонструктора);
		КонецЕсли;

		ПараметрыФормы.Вставить("Ключ", КлючЗаписи);
		
		ОткрытьФорму("РегистрСведений.СохраненныеНастройкиКонфигурации.ФормаЗаписи", ПараметрыФормы, ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	Элементы.Список.Обновить();
КонецПроцедуры
