#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПроверитьВозможностьИспользованияФормы(Отказ);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ИнициализироватьРеквизитыФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьПорядковыйНомерПерехода(1);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если НачальнаяВыгрузка Тогда
		ТекстПредупреждения = НСтр("ru = 'Отменить начальную выгрузку данных?'");
	Иначе
		ТекстПредупреждения = НСтр("ru = 'Отменить выгрузку данных?'");
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияПроизвольнойФормы(
		ЭтотОбъект, Отказ, ЗавершениеРаботы, ТекстПредупреждения, "ЗакрытьФормуБезусловно");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда
		Оповестить("ВыполненОбменДанными");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаДалее(Команда)
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаНазад(Команда)
	
	ИзменитьПорядковыйНомерПерехода(-1);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаГотово(Команда)
	
	ПараметрЗакрытия = Неопределено;
	Если ВыгрузкаДанныхВыполнена Тогда
		ПараметрЗакрытия = УзелОбмена;
	КонецЕсли;
	
	ЗакрытьФормуБезусловно = Истина;
	Закрыть(ПараметрЗакрытия);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроверкаПараметровПодключения

&НаКлиенте
Процедура ПриНачалеПроверкиПодключения()
	
	ПродолжитьОжидание = Истина;
	
	ПриНачалеПроверкиПодключенияНаСервере(ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(
			ПараметрыОбработчикаОжиданияПроверкиПодключения);
			
		ПодключитьОбработчикОжидания("ПриОжиданииПроверкиПодключения",
			ПараметрыОбработчикаОжиданияПроверкиПодключения.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииПроверкиПодключения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииПроверкиПодключения()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииПроверкиПодключенияНаСервере(ПараметрыОбработчикаПроверкиПодключения, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжиданияПроверкиПодключения);
		
		ПодключитьОбработчикОжидания("ПриОжиданииПроверкиПодключения",
			ПараметрыОбработчикаОжиданияПроверкиПодключения.ТекущийИнтервал, Истина);
	Иначе
		ПараметрыОбработчикаОжиданияПроверкиПодключения = Неопределено;
		ПриЗавершенииПроверкиПодключения();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииПроверкиПодключения()
	
	ПриЗавершенииПроверкиПодключенияНаСервере();
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаСервере
Процедура ПриНачалеПроверкиПодключенияНаСервере(ПродолжитьОжидание)
	
	Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS
		И ЗапроситьПароль Тогда
		НастройкиПодключения = РегистрыСведений.НастройкиТранспортаОбменаДанными.НастройкиТранспортаWS(УзелОбмена, WSПароль);
	Иначе
		НастройкиПодключения = РегистрыСведений.НастройкиТранспортаОбменаДанными.НастройкиТранспорта(УзелОбмена, ВидТранспорта);
	КонецЕсли;
	НастройкиПодключения.Вставить("ВидТранспортаСообщенийОбмена", ВидТранспорта);
	
	НастройкиПодключения.Вставить("ИмяПланаОбмена", ОбменДаннымиПовтИсп.ПолучитьИмяПланаОбмена(УзелОбмена));
	
	Обработки.ПомощникСозданияОбменаДанными.ПриНачалеПроверкиПодключения(
		НастройкиПодключения, ПараметрыОбработчикаПроверкиПодключения, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииПроверкиПодключенияНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	ПродолжитьОжидание = Ложь;
	Обработки.ПомощникСозданияОбменаДанными.ПриОжиданииПроверкиПодключения(ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииПроверкиПодключенияНаСервере()
	
	СтатусЗавершения = Неопределено;
	Обработки.ПомощникСозданияОбменаДанными.ПриЗавершенииПроверкиПодключения(
		ПараметрыОбработчикаПроверкиПодключения, СтатусЗавершения);
		
	Если СтатусЗавершения.Отказ Тогда
		ПроверкаПодключенияВыполнена = Ложь;
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
	Иначе
		ПроверкаПодключенияВыполнена = СтатусЗавершения.Результат.ПодключениеУстановлено
			И СтатусЗавершения.Результат.ПодключениеРазрешено;
			
		Если Не ПроверкаПодключенияВыполнена
			И Не ПустаяСтрока(СтатусЗавершения.Результат.СообщениеОбОшибке) Тогда
			СообщениеОбОшибке = СтатусЗавершения.Результат.СообщениеОбОшибке;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область РегистрацияИзменений

&НаКлиенте
Процедура ПриНачалеРегистрацииИзменений()
	
	ПродолжитьОжидание = Истина;
	ПриНачалеРегистрацииИзмененийНаСервере(ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(
			ПараметрыОбработчикаОжиданияРегистрацииДанныхДляНачальнойВыгрузки);
			
		ПодключитьОбработчикОжидания("ПриОжиданииРегистрацииИзменений",
			ПараметрыОбработчикаОжиданияРегистрацииДанныхДляНачальнойВыгрузки.ТекущийИнтервал, Истина);
	Иначе
		ПриЗавершенииРегистрацииИзменений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОжиданииРегистрацииИзменений()
	
	ПродолжитьОжидание = Ложь;
	ПриОжиданииРегистрацииИзмененийНаСервере(ПараметрыОбработчикаРегистрацииДанныхДляНачальнойВыгрузки, ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжиданияРегистрацииДанныхДляНачальнойВыгрузки);
		
		ПодключитьОбработчикОжидания("ПриОжиданииРегистрацииИзменений",
			ПараметрыОбработчикаОжиданияРегистрацииДанныхДляНачальнойВыгрузки.ТекущийИнтервал, Истина);
	Иначе
		ПараметрыОбработчикаОжиданияРегистрацииДанныхДляНачальнойВыгрузки = Неопределено;
		ПриЗавершенииРегистрацииИзменений();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииРегистрацииИзменений()
	
	ПриЗавершенииРегистрацииИзмененийНаСервере();
	
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаСервере
Процедура ПриНачалеРегистрацииИзмененийНаСервере(ПродолжитьОжидание)
	
	НастройкиРегистрации = Новый Структура;
	НастройкиРегистрации.Вставить("УзелОбмена", УзелОбмена);
	
	Обработки.ПомощникСозданияОбменаДанными.ПриНачалеРегистрацииДанныхДляНачальнойВыгрузки(
		НастройкиРегистрации, ПараметрыОбработчикаРегистрацииДанныхДляНачальнойВыгрузки, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ПриОжиданииРегистрацииИзмененийНаСервере(ПараметрыОбработчика, ПродолжитьОжидание)
	
	ПродолжитьОжидание = Ложь;
	Обработки.ПомощникСозданияОбменаДанными.ПриОжиданииРегистрацииДанныхДляНачальнойВыгрузки(
		ПараметрыОбработчика, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииРегистрацииИзмененийНаСервере()
	
	СтатусЗавершения = Неопределено;
	Обработки.ПомощникСозданияОбменаДанными.ПриЗавершенииРегистрацииДанныхДляНачальнойВыгрузки(
		ПараметрыОбработчикаРегистрацииДанныхДляНачальнойВыгрузки, СтатусЗавершения);
		
	Если СтатусЗавершения.Отказ Тогда
		РегистрацияИзмененийВыполнена = Ложь;
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
	Иначе
		РегистрацияИзмененийВыполнена = СтатусЗавершения.Результат.ДанныеЗарегистрированы;
			
		Если Не РегистрацияИзмененийВыполнена
			И Не ПустаяСтрока(СтатусЗавершения.Результат.СообщениеОбОшибке) Тогда
			СообщениеОбОшибке = СтатусЗавершения.Результат.СообщениеОбОшибке;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ВыгрузкаДанных

&НаКлиенте
Процедура ПриНачалеВыгрузкиДанныхДляСопоставления()
	
	ПроцентВыполнения = 0;
	
	ПродолжитьОжидание = Истина;
	ПриНачалеВыгрузкиДанныхДляСопоставленияНаСервере(ПродолжитьОжидание);
	
	Если ПродолжитьОжидание Тогда
		
		ОповещениеОЗавершении = Новый ОписаниеОповещения("ВыгрузкаДанныхДляСопоставленияЗавершение", ЭтотОбъект);
		
		ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
		ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
		ПараметрыОжидания.ВыводитьПрогрессВыполнения = Истина;
		ПараметрыОжидания.ОповещениеОПрогрессеВыполнения = Новый ОписаниеОповещения("ВыгрузкаДанныхДляСопоставленияПрогресс", ЭтотОбъект);
		
		ДлительныеОперацииКлиент.ОжидатьЗавершение(ПараметрыОбработчикаВыгрузкиДанныхДляСопоставления.ФоновоеЗадание,
			ОповещениеОЗавершении, ПараметрыОжидания);
	
	Иначе
			
		ПриЗавершенииВыгрузкиДанныхДляСопоставления();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗавершенииВыгрузкиДанныхДляСопоставления()
	
	ПроцентВыполнения = 100;
	
	ПриЗавершенииВыгрузкиДанныхДляСопоставленияНаСервере();
	ИзменитьПорядковыйНомерПерехода(+1);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаДанныхДляСопоставленияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	ПриЗавершенииВыгрузкиДанныхДляСопоставления();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузкаДанныхДляСопоставленияПрогресс(Прогресс, ДополнительныеПараметры) Экспорт
	
	Если Прогресс = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураПрогресса = Прогресс.Прогресс;
	Если СтруктураПрогресса <> Неопределено Тогда
		ПроцентВыполнения = СтруктураПрогресса.Процент;
		ДопИнформацияВыполнение = СтруктураПрогресса.Текст;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриНачалеВыгрузкиДанныхДляСопоставленияНаСервере(ПродолжитьОжидание)
	
	НастройкиВыгрузки = Новый Структура;
	НастройкиВыгрузки.Вставить("УзелОбмена", УзелОбмена);
	НастройкиВыгрузки.Вставить("ВидТранспорта", ВидТранспорта);
	
	Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS
		И ЗапроситьПароль Тогда
		НастройкиВыгрузки.Вставить("WSПароль", WSПароль);
	КонецЕсли;
	
	Обработки.ПомощникСозданияОбменаДанными.ПриНачалеВыгрузкиДанныхДляСопоставления(
		НастройкиВыгрузки, ПараметрыОбработчикаВыгрузкиДанныхДляСопоставления, ПродолжитьОжидание);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗавершенииВыгрузкиДанныхДляСопоставленияНаСервере()
	
	СтатусЗавершения = Неопределено;
	Обработки.ПомощникСозданияОбменаДанными.ПриЗавершенииВыгрузкиДанныхДляСопоставления(
		ПараметрыОбработчикаВыгрузкиДанныхДляСопоставления, СтатусЗавершения);
		
	Если СтатусЗавершения.Отказ Тогда
		ВыгрузкаДанныхВыполнена = Ложь;
		СообщениеОбОшибке = СтатусЗавершения.СообщениеОбОшибке;
	Иначе
		ВыгрузкаДанныхВыполнена = СтатусЗавершения.Результат.ДанныеВыгружены;
			
		Если Не ВыгрузкаДанныхВыполнена
			И Не ПустаяСтрока(СтатусЗавершения.Результат.СообщениеОбОшибке) Тогда
			СообщениеОбОшибке = СтатусЗавершения.Результат.СообщениеОбОшибке;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ИнициализацияФормыПриСоздании

&НаСервере
Процедура ПроверитьВозможностьИспользованияФормы(Отказ = Ложь)
	
	// Обязательная должны быть переданы параметры выполнения выгрузки данных.
	Если Не Параметры.Свойство("УзелОбмена") Тогда
		ТекстСообщения = НСтр("ru = 'Форма не предназначена для непосредственного использования.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
	Если ОбменДаннымиПовтИсп.ЭтоУзелРаспределеннойИнформационнойБазы(Параметры.УзелОбмена) Тогда
		ТекстСообщения = НСтр("ru = 'Начальная выгрузка не поддерживается для узлов распределенных информационных баз.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , , , Отказ);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ИнициализироватьРеквизитыФормы()
	
	УзелОбмена = Параметры.УзелОбмена;
	
	Если Параметры.Свойство("НачальнаяВыгрузка") Тогда
		РежимВыгрузкиДанных = "НачальнаяВыгрузка";
		НачальнаяВыгрузка = Истина;
	Иначе
		РежимВыгрузкиДанных = "ОбычнаяВыгрузка";
	КонецЕсли;
	
	МодельСервиса = ОбщегоНазначения.РазделениеВключено()
		И ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
		
	ИспользоватьПрогресс = Не МодельСервиса;
		
	ВидТранспорта = РегистрыСведений.НастройкиТранспортаОбменаДанными.ВидТранспортаСообщенийОбменаПоУмолчанию(УзелОбмена);
	
	Если ВидТранспорта = Перечисления.ВидыТранспортаСообщенийОбмена.WS Тогда
		
		ИспользоватьПрогресс = Ложь;
		
		НастройкиТранспорта = РегистрыСведений.НастройкиТранспортаОбменаДанными.НастройкиТранспортаWS(УзелОбмена);
		
		ЗапроситьПароль = Не (НастройкиТранспорта.WSЗапомнитьПароль
			Или ОбменДаннымиСервер.ПарольСинхронизацииДанныхЗадан(УзелОбмена));
		
	КонецЕсли;
		
	ЗаполнитьТаблицуПереходов();
	
КонецПроцедуры

#КонецОбласти

#Область СценарииРаботыПомощника

&НаСервере
Функция ДобавитьСтрокуТаблицыПереходов(ИмяОсновнойСтраницы, ИмяСтраницыНавигации, ИмяСтраницыДекорации = "")
	
	СтрокаПереходов = ТаблицаПереходов.Добавить();
	СтрокаПереходов.ПорядковыйНомерПерехода = ТаблицаПереходов.Количество();
	СтрокаПереходов.ИмяОсновнойСтраницы = ИмяОсновнойСтраницы;
	СтрокаПереходов.ИмяСтраницыНавигации = ИмяСтраницыНавигации;
	СтрокаПереходов.ИмяСтраницыДекорации = ИмяСтраницыДекорации;
	
	Возврат СтрокаПереходов;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьТаблицуПереходов()
	
	ТаблицаПереходов.Очистить();
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаНачало", "СтраницаНавигацияНачало");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаНачало_ПриОткрытии";
	
	Если ЗапроситьПароль Тогда
		НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаЗапросПароля", "СтраницаНавигацияПродолжение");
		НовыйПереход.ИмяОбработчикаПриПереходеДалее = "СтраницаЗапросПароля_ПриПереходеДалее";
	КонецЕсли;
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаПроверкаПодключения", "СтраницаНавигацияОжидание");
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "СтраницаПроверкаПодключения_ДлительнаяОперация";
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаРегистрацияИзменений", "СтраницаНавигацияОжидание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаРегистрацияИзменений_ПриОткрытии";
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "СтраницаРегистрацияИзменений_ДлительнаяОперация";
	
	Если ИспользоватьПрогресс Тогда
		НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаВыгрузкаДанныхПрогресс", "СтраницаНавигацияОжидание");
	Иначе
		НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаВыгрузкаДанныхБезПрогресса", "СтраницаНавигацияОжидание");
	КонецЕсли;
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаВыгрузкаДанных_ПриОткрытии";
	НовыйПереход.ДлительнаяОперация = Истина;
	НовыйПереход.ИмяОбработчикаДлительнойОперации = "СтраницаВыгрузкаДанных_ДлительнаяОперация";
	
	НовыйПереход = ДобавитьСтрокуТаблицыПереходов("СтраницаОкончание", "СтраницаНавигацияОкончание");
	НовыйПереход.ИмяОбработчикаПриОткрытии = "СтраницаОкончание_ПриОткрытии";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийПереходов

&НаКлиенте
Функция Подключаемый_СтраницаНачало_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Элементы.РежимВыгрузкиДанных.Доступность = Не НачальнаяВыгрузка;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаЗапросПароля_ПриПереходеДалее(Отказ)
	
	Если Не ЗапроситьПароль Тогда
		Возврат 0;
	КонецЕсли;
	
	Если ПустаяСтрока(WSПароль) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите пароль.'"), , "WSПароль", , Отказ);
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаПроверкаПодключения_ДлительнаяОперация(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	ПриНачалеПроверкиПодключения();
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаРегистрацияИзменений_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Если Не ПроверкаПодключенияВыполнена Тогда
		ПропуститьСтраницу = Истина;
		Возврат 0;
	Иначе
		Если РежимВыгрузкиДанных = "ОбычнаяВыгрузка" Тогда
			ПропуститьСтраницу = Истина;
			РегистрацияИзмененийВыполнена = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаРегистрацияИзменений_ДлительнаяОперация(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	ПриНачалеРегистрацииИзменений();
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаВыгрузкаДанных_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	ПропуститьСтраницу = Не ПроверкаПодключенияВыполнена
		Или Не РегистрацияИзмененийВыполнена;
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаВыгрузкаДанных_ДлительнаяОперация(Отказ, ПерейтиДалее)
	
	ПерейтиДалее = Ложь;
	ПриНачалеВыгрузкиДанныхДляСопоставления();
	
КонецФункции

&НаКлиенте
Функция Подключаемый_СтраницаОкончание_ПриОткрытии(Отказ, ПропуститьСтраницу, ЭтоПереходДалее)
	
	Если Не ПроверкаПодключенияВыполнена Тогда
		Элементы.ПанельСостояниеЗавершения.ТекущаяСтраница = Элементы.СтраницаЗавершениеОшибкаПроверкаПодключения;
	ИначеЕсли Не РегистрацияИзмененийВыполнена Тогда
		Элементы.ПанельСостояниеЗавершения.ТекущаяСтраница = Элементы.СтраницаЗавершениеОшибкаРегистрацияИзменений;
	ИначеЕсли Не ВыгрузкаДанныхВыполнена Тогда
		Элементы.ПанельСостояниеЗавершения.ТекущаяСтраница = Элементы.СтраницаЗавершениеОшибкаВыгрузкаДанных;
	Иначе
		Элементы.ПанельСостояниеЗавершения.ТекущаяСтраница = Элементы.СтраницаЗавершениеУспех;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область ДополнительныеОбработчикиПереходов

&НаКлиенте
Процедура ИзменитьПорядковыйНомерПерехода(Итератор)
	
	ОчиститьСообщения();
	
	УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + Итератор);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПорядковыйНомерПерехода(Знач Значение)
	
	ЭтоПереходДалее = (Значение > ПорядковыйНомерПерехода);
	
	ПорядковыйНомерПерехода = Значение;
	
	Если ПорядковыйНомерПерехода < 1 Тогда
		
		ПорядковыйНомерПерехода = 1;
		
	КонецЕсли;
	
	ПорядковыйНомерПереходаПриИзменении(ЭтоПереходДалее);
	
КонецПроцедуры

&НаКлиенте
Процедура ПорядковыйНомерПереходаПриИзменении(Знач ЭтоПереходДалее)
	
	// Выполняем обработчики событий перехода.
	ВыполнитьОбработчикиСобытийПерехода(ЭтоПереходДалее);
	
	// Устанавливаем отображение страниц.
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Элементы.ПанельОсновная.ТекущаяСтраница  = Элементы[СтрокаПереходаТекущая.ИмяОсновнойСтраницы];
	Элементы.ПанельНавигации.ТекущаяСтраница = Элементы[СтрокаПереходаТекущая.ИмяСтраницыНавигации];
	
	Элементы.ПанельНавигации.ТекущаяСтраница.Доступность = Не (ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация);
	
	// Устанавливаем текущую кнопку по умолчанию.
	КнопкаДалее = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаДалее");
	
	Если КнопкаДалее <> Неопределено Тогда
		
		КнопкаДалее.КнопкаПоУмолчанию = Истина;
		
	Иначе
		
		КнопкаГотово = ПолучитьКнопкуФормыПоИмениКоманды(Элементы.ПанельНавигации.ТекущаяСтраница, "КомандаГотово");
		
		Если КнопкаГотово <> Неопределено Тогда
			
			КнопкаГотово.КнопкаПоУмолчанию = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтоПереходДалее И СтрокаПереходаТекущая.ДлительнаяОперация Тогда
		
		ПодключитьОбработчикОжидания("ВыполнитьОбработчикДлительнойОперации", 0.1, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикиСобытийПерехода(Знач ЭтоПереходДалее)
	
	// Обработчики событий переходов.
	Если ЭтоПереходДалее Тогда
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода - 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
		
			// Обработчик ПриПереходеДалее.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеДалее)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеДалее);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	Иначе
		
		СтрокиПерехода = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода + 1));
		
		Если СтрокиПерехода.Количество() > 0 Тогда
			СтрокаПерехода = СтрокиПерехода[0];
		
			// Обработчик ПриПереходеНазад.
			Если Не ПустаяСтрока(СтрокаПерехода.ИмяОбработчикаПриПереходеНазад)
				И Не СтрокаПерехода.ДлительнаяОперация Тогда
				
				ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ)";
				ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПерехода.ИмяОбработчикаПриПереходеНазад);
				
				Отказ = Ложь;
				
				Результат = Вычислить(ИмяПроцедуры);
				
				Если Отказ Тогда
					
					УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
					
					Возврат;
					
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	Если СтрокаПереходаТекущая.ДлительнаяОперация И Не ЭтоПереходДалее Тогда
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
		Возврат;
	КонецЕсли;
	
	// обработчик ПриОткрытии
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПропуститьСтраницу, ЭтоПереходДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаПриОткрытии);
		
		Отказ = Ложь;
		ПропуститьСтраницу = Ложь;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПропуститьСтраницу Тогда
			
			Если ЭтоПереходДалее Тогда
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
				
				Возврат;
				
			Иначе
				
				УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
				
				Возврат;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбработчикДлительнойОперации()
	
	СтрокиПереходаТекущие = ТаблицаПереходов.НайтиСтроки(Новый Структура("ПорядковыйНомерПерехода", ПорядковыйНомерПерехода));
	
	Если СтрокиПереходаТекущие.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не определена страница для отображения.'");
	КонецЕсли;
	
	СтрокаПереходаТекущая = СтрокиПереходаТекущие[0];
	
	// Обработчик ОбработкаДлительнойОперации.
	Если Не ПустаяСтрока(СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации) Тогда
		
		ИмяПроцедуры = "Подключаемый_[ИмяОбработчика](Отказ, ПерейтиДалее)";
		ИмяПроцедуры = СтрЗаменить(ИмяПроцедуры, "[ИмяОбработчика]", СтрокаПереходаТекущая.ИмяОбработчикаДлительнойОперации);
		
		Отказ = Ложь;
		ПерейтиДалее = Истина;
		
		Результат = Вычислить(ИмяПроцедуры);
		
		Если Отказ Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода - 1);
			
			Возврат;
			
		ИначеЕсли ПерейтиДалее Тогда
			
			УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
			
			Возврат;
			
		КонецЕсли;
		
	Иначе
		
		УстановитьПорядковыйНомерПерехода(ПорядковыйНомерПерехода + 1);
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьКнопкуФормыПоИмениКоманды(ЭлементФормы, ИмяКоманды)
	
	Для Каждого Элемент Из ЭлементФормы.ПодчиненныеЭлементы Цикл
		
		Если ТипЗнч(Элемент) = Тип("ГруппаФормы") Тогда
			
			ЭлементФормыПоИмениКоманды = ПолучитьКнопкуФормыПоИмениКоманды(Элемент, ИмяКоманды);
			
			Если ЭлементФормыПоИмениКоманды <> Неопределено Тогда
				
				Возврат ЭлементФормыПоИмениКоманды;
				
			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Элемент) = Тип("КнопкаФормы")
			И СтрНайти(Элемент.ИмяКоманды, ИмяКоманды) > 0 Тогда
			
			Возврат Элемент;
			
		Иначе
			
			Продолжить;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Неопределено;
	
КонецФункции

#КонецОбласти

#КонецОбласти
