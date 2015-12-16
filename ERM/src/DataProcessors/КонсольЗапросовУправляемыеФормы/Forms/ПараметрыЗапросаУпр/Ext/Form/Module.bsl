﻿&НаКлиенте
Перем мПутьКОбработке Экспорт;
&НаКлиенте
Процедура ЗакрытьОкно(Команда)
	// Вставить содержимое обработчика.
	Закрыть();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	мПутьКОбработке = ВладелецФормы.мПутьКОбработке;
	СписокПараметров = ВладелецФормы.ПараметрыЗапроса;
	Для Каждого Параметр Из СписокПараметров Цикл
		НоваяСтрока = ПараметрыЗапроса.Добавить();
		НоваяСтрока.ИмяПараметра = Параметр.ИмяПараметра;
		НоваяСтрока.ЭтоВыражение = Параметр.ЭтоВыражение;
		НоваяСтрока.ЗначениеПараметра = Параметр.ЗначениеПараметра;
		НоваяСтрока.МоментВремениДата = Параметр.МоментВремениДата;
		НоваяСтрока.МоментВремениСсылка = Параметр.МоментВремениСсылка;
		НоваяСтрока.ГраницаЗначение = Параметр.ГраницаЗначение;
		НоваяСтрока.ГраницаВид = Параметр.ГраницаВид;
		НоваяСтрока.ДопустимыеТипы = Параметр.ДопустимыеТипы;
		ЗаполнитьКоллекциюКоллекцией(НоваяСтрока.ТаблицаЗначений,Параметр.ТаблицаЗначений);
		ЗаполнитьКоллекциюКоллекцией(НоваяСтрока.ОписаниеТаблицыЗначений,Параметр.ОписаниеТаблицыЗначений);
	КонецЦикла;
	ОбнаружитьЛишниеПараметры(ВладелецФормы.ТекстЗапроса.ПолучитьТекст());
КонецПроцедуры

&НаСервере
Процедура ОбнаружитьЛишниеПараметры(ТекстЗапроса)
		Запрос = Новый Запрос(ТекстЗапроса);
	Попытка
		ПараметрыЗапросаТЗ = Запрос.НайтиПараметры();
	Исключение
		Возврат;
	КонецПопытки;
	
	Для каждого Параметр Из ПараметрыЗапроса Цикл
		
		
		Если ПараметрыЗапросаТЗ.Найти(Параметр.ИмяПараметра) = Неопределено Тогда
			
			Параметр.НетВЗапросе = Истина;
		Иначе
			Параметр.НетВЗапросе = Ложь;
		КонецЕсли; 
		
	КонецЦикла; 
КонецПроцедуры // ОбнаружитьЛишниеПараметры()
&НаКлиенте
Процедура ОткрытьФормуСовместимость82(ИмяОткрываемойФормы,СтруктураПараметров = Неопределено,МодульРезультата = "") Экспорт
	
	Если ВладелецФормы.Это82() Тогда
		Результат = ОткрытьФормуМодально(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма);
		Если МодульРезультата <> "" Тогда
			Выполнить(МодульРезультата+"(Результат,Неопределено)");
		КонецЕсли;
	Иначе
		Если МодульРезультата <> "" Тогда
			ОписаниеОповещения = Неопределено;
			Выполнить("ОписаниеОповещения = Новый ОписаниеОповещения(МодульРезультата,ЭтаФорма)");
			Выполнить("ОткрытьФорму(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)");
		Иначе
			Выполнить("ОткрытьФорму(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)");
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры // ОткрытьФормуСовместимость82()

&НаКлиенте
Процедура ПриЗакрытии()
	СписокПараметров = ВладелецФормы.ПараметрыЗапроса;
	СписокПараметров.Очистить();
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		НоваяСтрока = СписокПараметров.Добавить();
		НоваяСтрока.ИмяПараметра = Параметр.ИмяПараметра;
		НоваяСтрока.ЭтоВыражение = Параметр.ЭтоВыражение;
		НоваяСтрока.ЗначениеПараметра = Параметр.ЗначениеПараметра;
		НоваяСтрока.МоментВремениДата = Параметр.МоментВремениДата;
		НоваяСтрока.МоментВремениСсылка = Параметр.МоментВремениСсылка;
		НоваяСтрока.ГраницаЗначение = Параметр.ГраницаЗначение;
		НоваяСтрока.ГраницаВид = Параметр.ГраницаВид;
		НоваяСтрока.ДопустимыеТипы = Параметр.ДопустимыеТипы;
		ЗаполнитьКоллекциюКоллекцией(НоваяСтрока.ТаблицаЗначений,Параметр.ТаблицаЗначений);
		ЗаполнитьКоллекциюКоллекцией(НоваяСтрока.ОписаниеТаблицыЗначений,Параметр.ОписаниеТаблицыЗначений);
	КонецЦикла;
КонецПроцедуры
&НаКлиенте
Функция ЗаполнитьКоллекциюКоллекцией(Приемник,Источник)
	
	Приемник.Очистить();
	Для Каждого СтрокаТЗ ИЗ	Источник Цикл
		НоваяСтрока = Приемник.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока,СтрокаТЗ);
	КонецЦикла;

КонецФункции // ЗаполнитьКоллекциюКоллекцией()
&НаКлиенте
Процедура МоментВремениГраница(Команда)
	Если Элементы.ПараметрыЗапроса.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ОткрытьФормуСовместимость82(мПутьКОбработке+".ПараметрМоментВремениГраницаУпр");	
КонецПроцедуры

&НаКлиенте
Процедура СЗ(Команда)
	Если Элементы.ПараметрыЗапроса.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекДанные = ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока);
	
	ТекЗначениеПараметра = ТекДанные.ЗначениеПараметра; 
	
	ОткрытьФормуСовместимость82(мПутьКОбработке+".СписокЗначенийУпр");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПараметрыПоЗапросу(ТекстЗапроса)
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Попытка
		ПараметрыЗапросаНайденные = Запрос.НайтиПараметры();
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
	
	Для каждого ПараметрЗапроса Из ПараметрыЗапросаНайденные Цикл
		
		ИмяПараметра =  ПараметрЗапроса.Имя;
		СтрокаПараметров = ПараметрыЗапроса.НайтиСтроки(Новый Структура("ИмяПараметра",ИмяПараметра));
		Если СтрокаПараметров.Количество()=0 Тогда
			СтрокаПараметров = Неопределено
		Иначе
			СтрокаПараметров = СтрокаПараметров[0];
		КонецЕсли;
		Если  СтрокаПараметров = Неопределено Тогда
			СтрокаПараметров = ПараметрыЗапроса.Добавить();
			СтрокаПараметров.ИмяПараметра = ИмяПараметра;
			СтрокаПараметров.ДопустимыеТипы = ПараметрЗапроса.ТипЗначения;
		    СтрокаПараметров.ЗначениеПараметра = ПараметрЗапроса.ТипЗначения.ПривестиЗначение(СтрокаПараметров.ЗначениеПараметра);
		КонецЕсли; 
		
	КонецЦикла;
		
КонецПроцедуры //ЗаполнитьПараметрыПоЗапросу


&НаКлиенте
Процедура ПараметрыИзЗапроса(Команда)
	ТекстЗапроса = ВладелецФормы.ТекстЗапроса.ПолучитьТекст();
	Если ТекстЗапроса = "" Тогда
		Возврат;
	КонецЕсли; 
	ЗаполнитьПараметрыПоЗапросу(ТекстЗапроса);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаЗначениеПараметраОчистка(Элемент, СтандартнаяОбработка)
	ТекСтрока = ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока);
	Если Не ТекСтрока.ЭтоВыражение Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока).ЗначениеПараметра = Неопределено;
	КонецЕсли;
	ОчиститьДопПоля(ТекСтрока);

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаЗначениеПараметраНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ТекДанные = ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока);
	Если ТекДанные.ЗначениеПараметра = Неопределено Тогда
		Элемент.ВыбиратьТип = Истина;
	Иначе
		Элемент.ВыбиратьТип = Ложь;
	КонецЕсли;
	

	Если ЗначениеЗаполнено(ТекДанные.МоментВремениСсылка) ИЛИ ЗначениеЗаполнено(ТекДанные.ГраницаВид) Тогда
		
		МоментВремениГраница(Неопределено);
		СтандартнаяОбработка = Ложь;
		
	КонецЕсли; 
	
	Если ТипЗнч(ТекДанные.ЗначениеПараметра) = Тип("СписокЗначений") Тогда
		
		СЗ(Элемент);
		СтандартнаяОбработка = Ложь;
		
	ИначеЕсли  Лев(ТекДанные.ЗначениеПараметра,15) = "ТаблицаЗначений" Тогда
		
		ТЗ(Элемент);
	ИначеЕсли Элемент.ВыбиратьТип Тогда
		ПараметрыИсходящие = Новый Структура("ВыбираемыеТипы",ТекДанные.ДопустимыеТипы);
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуСовместимость82(мПутьКОбработке+".ВыборТипаУпр",ПараметрыИсходящие,"НачалоВыбораЗавершение");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбораЗавершение(Результат,ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ТекДанные = ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока);
		ТекДанные.ЗначениеПараметра = Результат;
	КонецЕсли;
КонецПроцедуры // НачалоВыбораЗавершение()


&НаКлиенте
Процедура ПараметрыЗапросаПриАктивизацииСтроки(Элемент)
	Если Элементы.ПараметрыЗапроса.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекДанные = ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока);
	Элементы.НадписьТипЗначенияПараметра.Заголовок =  ТипЗнч(ТекДанные.ЗначениеПараметра);
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаЭтоВыражениеПриИзменении(Элемент)
	ТекДанные = ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока);
	Если ТекДанные.ЭтоВыражение Тогда
		Если Не ТипЗнч(ТекДанные.ЗначениеПараметра) = Тип("Строка") Тогда
			ТекДанные.ЗначениеПараметра = "";
		КонецЕсли; 
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТЗ(Команда)
	Если Элементы.ПараметрыЗапроса.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекДанные = ПараметрыЗапроса.НайтиПоИдентификатору(Элементы.ПараметрыЗапроса.ТекущаяСтрока);
	
	ТекЗначениеПараметра = ТекДанные.ЗначениеПараметра; 
	ПараметрыИсходящие = Новый Структура;
	ПараметрыИсходящие.Вставить("СтруктураКолонок",ТекДанные.ОписаниеТаблицыЗначений);
	ПараметрыИсходящие.Вставить("ВходящийСписок",ТекДанные.ТаблицаЗначений);
	ОткрытьФормуСовместимость82(мПутьКОбработке+".ФормаТаблицыЗначенийУпр",ПараметрыИсходящие);
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьДопПоля(Строка)
	Строка.ТаблицаЗначений.Очистить();
	Строка.ОписаниеТаблицыЗначений.Очистить();
	Строка.МоментВремениСсылка = Неопределено;
	Строка.МоментВремениДата = Дата(1,1,1);
	Строка.ГраницаЗначение = Неопределено;
	

КонецПроцедуры // ОчиститьДопПоля()

&НаКлиенте
Процедура ПараметрыЗапросаПриИзменении(Элемент)
		ОбнаружитьЛишниеПараметры(ВладелецФормы.ТекстЗапроса.ПолучитьТекст());
	ВладелецФормы.Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура УдалитьНеиспользуемые(Команда)
	МассивУдаления = Новый Массив;
	Для Каждого Параметр Из ПараметрыЗапроса Цикл
		Если Параметр.НетВЗапросе Тогда
			МассивУдаления.Добавить(Параметр);
		КонецЕсли;
	КонецЦикла;
	Для Каждого УдаляемыйПараметр Из МассивУдаления Цикл
		ПараметрыЗапроса.Удалить(УдаляемыйПараметр);
	КонецЦикла;
КонецПроцедуры
