#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УвеличитьПериод(Команда)
	
	Период = КонецМесяца(ДобавитьМесяц(Период, 1));
	ПриИзмененииПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура УменьшитьПериод(Команда)
	
	Период = КонецМесяца(ДобавитьМесяц(Период,-1));
	ПриИзмененииПериода();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеПериодаПриИзменении(Элемент)
	
	ПриИзмененииПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(Период), КонецМесяца(Период));
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, Элементы.ПредставлениеПериода, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеПериодаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		Период = КонецМесяца(ТекущаяДата());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
	
	Если Параметр <> Неопределено И ЗначениеЗаполнено(Параметр.Значение) Тогда
		Период = Параметр.Значение;
	КонецЕсли;
	
	ПриИзмененииПериода();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = Период;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриИзмененииПериода()
	
	// Обновляем представление периода на форме.
	ПредставлениеПериода = ВыборПериодаКлиентСервер.ПолучитьПредставлениеПериодаОтчета(
		ПредопределенноеЗначение("Перечисление.ДоступныеПериодыОтчета.Месяц"),
		НачалоМесяца(Период),
		КонецМесяца(Период));
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = Период;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НЕАКТУАЛЬНОСТЬ");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Описание оповещений

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Период = РезультатВыбора.НачалоПериода;
	
	ПриИзмененииПериода();
	
КонецПроцедуры

#КонецОбласти
