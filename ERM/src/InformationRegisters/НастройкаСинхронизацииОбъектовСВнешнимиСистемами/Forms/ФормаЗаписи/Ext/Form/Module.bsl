﻿
&НаКлиенте
Процедура ОбъектПриемникаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.ПустаяСсылка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Geomarket") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
		//ПараметрыФормы.Вставить("ОтборПоКоду", Запись.Идентификатор);
		ОткрытьФорму("Справочник.GeoMarkets.Форма.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.AccountingUnit") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
		ОткрытьФорму("Справочник.КостЦентры.Форма.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Client") Тогда
		ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Currency") Тогда
		ОткрытьФорму("Справочник.Валюты.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Segment") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
		ОткрытьФорму("Справочник.Сегменты.Форма.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПриемникаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Запись.ОбъектПриемника = Результат;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Период") Тогда
		Запись.Период = НачалоМесяца(Параметры.Период);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОтработкаКоллизии");
	
КонецПроцедуры
