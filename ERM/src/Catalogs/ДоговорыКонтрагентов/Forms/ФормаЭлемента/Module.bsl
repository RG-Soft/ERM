#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СрокОплатыПокупателей = Константы.СрокОплатыПокупателей.Получить();
	СрокОплатыПоставщикам = Константы.СрокОплатыПоставщикам.Получить();
	
	ВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	ДоговорСРезидентомТаможенногоСоюза = УчетНДС.КонтрагентРезидентТаможенногоСоюза(Объект.Владелец);
	
	Если Параметры.Ключ.Пустая() Тогда
		Объект.ПредъявляетНДС = НЕ ДоговорСРезидентомТаможенногоСоюза;
	КонецЕсли;
	
	Параметры.Свойство("СозданИзФормыДокумента", СозданИзФормыДокумента);
	
	Если Параметры.Свойство("ОткрытИзПлатежки") Тогда
		Объект.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком;
	КонецЕсли;
	
	Если Параметры.ПараметрыВыбора.Свойство("Организация") И ЗначениеЗаполнено(Параметры.ПараметрыВыбора.Организация) Тогда
		Параметры.ПараметрыВыбора.Организация = ОбщегоНазначенияВызовСервераПовтИсп.ГоловнаяОрганизация(
			Параметры.ПараметрыВыбора.Организация);
	КонецЕсли;

	Если НЕ Параметры.Ключ.Пустая() Тогда
		Справочники.ДоговорыКонтрагентов.УстановитьДоступныеВидыДоговора(Параметры.ЗначенияЗаполнения);
	КонецЕсли;
	ОграничитьВыборРеквизитов(Параметры.ЗначенияЗаполнения);
	
	ОплатаВРублях = Объект.РасчетыВУсловныхЕдиницах;

	ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(ЭтаФорма);
	
	НаименованиеПоУмолчанию  = ПечатьДоговоровКлиентСервер.НаименованиеПоУмолчаниюБезРеквизитов();
	РеквизитыДоговораСтрокой = ПечатьДоговоровКлиентСервер.РеквизитыДоговораСтрокой(Объект.Номер, Объект.Дата);
	Элементы.НаименованиеДляСчетаФактурыНалоговогоАгента.Видимость = ПолучитьФункциональнуюОпцию("ИсполняютсяОбязанностиНалоговогоАгентаПоНДС");
	
	УправлениеФормой(ЭтаФорма);
	
	// Обработчик подсистемы "Свойства"
	//ДополнительныеПараметры = Новый Структура;
	//ДополнительныеПараметры.Вставить("Объект", Объект);
	//ДополнительныеПараметры.Вставить("ИмяЭлементаДляРазмещения", "ГруппаДополнительныеРеквизиты");
	//УправлениеСвойствами.ПриСозданииНаСервере(ЭтаФорма, ДополнительныеПараметры);
	
	//// ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере
	//ИдентификаторыСобытийПриОткрытии = "ПриОткрытии";
	//ОбработкаНовостейПереопределяемый.КонтекстныеНовости_ПриСозданииНаСервере(
	//	ЭтаФорма,
	//	"БП.Справочник.ДоговорыКонтрагентов",
	//	"ФормаЭлемента",
	//	НСтр("ru='Новости: Договор'"),
	//	ИдентификаторыСобытийПриОткрытии
	//);
	//// Конец ИнтернетПоддержкаПользователей.Новости.КонтекстныеНовости_ПриСозданииНаСервере

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	//УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства

	// ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	//ОбработкаНовостейКлиент.КонтекстныеНовости_ПриОткрытии(ЭтаФорма);
	// Конец ИнтернетПоддержкаПользователей.Новости.ПриОткрытии
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)

	// Подсистема "Свойства"
	// { RGS AGorlenko 16.05.2016 16:20:22 - 
	//Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
	//	ОбновитьЭлементыДополнительныхРеквизитов();
	//	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	//ИначеЕсли ИмяСобытия = "ДоговорыКонтрагентов_СозданиеФайлаДоговора" 
	//	И Параметр.ДоговорКонтрагента = Объект.Ссылка Тогда 
	//	// Для текущего договора был добавлен присоединенный файл с текстом договора.
	//	// Сохраним ссылку на него в текущем объекте.
	//	ОбработкаОповещенияСозданиеФайлаДоговора(Параметр.ФайлДоговора);
	//КонецЕсли;
	Если ИмяСобытия = "ДоговорыКонтрагентов_СозданиеФайлаДоговора" 
		И Параметр.ДоговорКонтрагента = Объект.Ссылка Тогда 
		// Для текущего договора был добавлен присоединенный файл с текстом договора.
		// Сохраним ссылку на него в текущем объекте.
		ОбработкаОповещенияСозданиеФайлаДоговора(Параметр.ФайлДоговора);
	КонецЕсли;
	// } RGS AGorlenko 16.05.2016 16:20:23 - 

	// ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	//ОбработкаНовостейКлиент.КонтекстныеНовости_ОбработкаОповещения(ЭтаФорма, ИмяСобытия, Параметр, Источник);
	// Конец ИнтернетПоддержкаПользователей.Новости.ОбработкаОповещения
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	ПараметрыЗаписи.Вставить("УплачиватьНДСспецРежимы", ПолучитьФункциональнуюОпциюИнтерфейса("УплачиватьНДСспецРежимы"));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.Свойство("УплачиватьНДСспецРежимы") И
		ПараметрыЗаписи.УплачиватьНДСспецРежимы <> ПолучитьФункциональнуюОпциюИнтерфейса("УплачиватьНДСспецРежимы") Тогда
		ОбновитьИнтерфейс();
	КонецЕсли;
	
	Оповестить("Запись_ДоговорыКонтрагентов", ПараметрыЗаписи, Объект.Ссылка);
	
	Если СозданИзФормыДокумента Тогда
		ОповеститьОВыборе(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерПриИзменении(Элемент)
	
	СформироватьНаименованиеДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	СформироватьНаименованиеДоговора();
	
КонецПроцедуры

&НаКлиенте
Процедура ВладелецПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Владелец) Тогда
		ВладелецПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВидДоговораПриИзменении(Элемент)

	Если НЕ ЗначениеЗаполнено(Объект.ВидДоговора)
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее")) Тогда
		Объект.ТипЦен = Неопределено;
		Объект.СпособРасчетаКомиссионногоВознаграждения = Неопределено;
		Объект.ПроцентКомиссионногоВознаграждения = 0;
		Объект.УстановленСрокОплаты = Ложь;
		Объект.СрокОплаты = 0;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ВидДоговора)
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее"))
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"))
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку"))
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку")) Тогда
		Объект.РасчетыВУсловныхЕдиницах = Ложь;
		ОплатаВРублях = 0;
	КонецЕсли;

	ЭтоДоговорПриобретения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"));

	Если НЕ ЭтоДоговорПриобретения Тогда
		Объект.УчетАгентскогоНДС = Ложь;
		Объект.НДСПоСтавкам4и2	 = Ложь;
		Объект.ВидАгентскогоДоговора = Неопределено;
	КонецЕсли;

	Если Объект.УчетАгентскогоНДС
			И (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом")) Тогда
		Объект.ВидАгентскогоДоговора = ПредопределенноеЗначение("Перечисление.ВидыАгентскихДоговоров.Нерезидент");
	КонецЕсли;
	
	Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку")
		ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку") Тогда
		Если НЕ УсловиеОплатаВВалютеПередано Тогда
			Объект.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета;
		КонецЕсли;
	КонецЕсли;

	ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(ЭтаФорма);
	Если ЗначениеЗаполнено(Объект.СпособРасчетаКомиссионногоВознаграждения) Тогда
		Если Элементы.СпособРасчетаКомиссионногоВознаграждения.СписокВыбора.НайтиПоЗначению(Объект.СпособРасчетаКомиссионногоВознаграждения) = Неопределено Тогда
			Объект.СпособРасчетаКомиссионногоВознаграждения = Неопределено;
		КонецЕсли;
	КонецЕсли;
	
	ИзменитьПредъявляетНДС();
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ОрганизацияПриИзмененииНаСервере();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ВалютаВзаиморасчетовПриИзменении(Элемент)
	
	ВалютаВзаиморасчетовПриИзмененииНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатаВПриИзменении(Элемент)
	
	Модифицированность = Истина;
	Объект.РасчетыВУсловныхЕдиницах = ОплатаВРублях;
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановленСрокОплатыПриИзменении(Элемент)

	Если Объект.УстановленСрокОплаты Тогда
		Если (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку")) Тогда
			Объект.СрокОплаты = СрокОплатыПокупателей;
		ИначеЕсли (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"))
				ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку")) Тогда
			Объект.СрокОплаты = СрокОплатыПоставщикам;
		КонецЕсли;
	Иначе
		СрокОплаты = 0;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПредъявляетНДСПриИзменении(Элемент)
	
	Если Не Объект.ПредъявляетНДС Тогда
		Объект.НДСПоСтавкам4и2 = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура УчетАгентскогоНДСПриИзменении(Элемент)
	
	Если Объект.УчетАгентскогоНДС Тогда
		Объект.РасчетыВУсловныхЕдиницах = Ложь;
		ОплатаВРублях = 0;
		Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом") Тогда
			Объект.ВидАгентскогоДоговора = ПредопределенноеЗначение("Перечисление.ВидыАгентскихДоговоров.Нерезидент");
		Иначе
			Объект.ВидАгентскогоДоговора = ПредопределенноеЗначение("Перечисление.ВидыАгентскихДоговоров.Аренда");
		КонецЕсли;
		ИзменитьПредъявляетНДС();
	Иначе
		Объект.ВидАгентскогоДоговора = Неопределено;
	КонецЕсли;
	
	УправлениеФормой(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ПорядокРегистрацииСчетовФактурНаАвансПоДоговоруПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидАгентскогоДоговораПриИзменении(Элемент)
	
	УправлениеФормой(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура РуководительКонтрагентаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	Список = ПолучитьСписокКонтактныхЛиц(Объект.Владелец);
	
	ОповещениеВыбора = Новый ОписаниеОповещения("РуководительКонтрагентаНачалоВыбораЗавершение", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОповещениеВыбора, Список, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ФайлДоговораОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если ЗначениеЗаполнено(Объект.ФайлДоговора) Тогда
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("ФайлДоговора", Объект.ФайлДоговора);
		ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаРедактированияТекстаДоговора", ПараметрыФормы, ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФайлДоговораСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) ИЛИ Модифицированность Тогда
		// Выполняем запись договора перед открытием формы редактирования файла с текстом договора,
		// аналогично тому как происходит при нажатии на кнопку Печать.
		Записать();
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура();
	Если ЗначениеЗаполнено(Объект.ФайлДоговора) Тогда
		// Открываем существующий файл договора вместо создания нового.
		ПараметрыФормы.Вставить("ФайлДоговора", Объект.ФайлДоговора);
	Иначе
		ПараметрыФормы.Вставить("ОбъектПечати", Объект.Ссылка);
	КонецЕсли;
	
	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаРедактированияТекстаДоговора", ПараметрыФормы, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	//УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	//УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

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

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)

	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	ВалютаРегламентированногоУчета = Форма.ВалютаРегламентированногоУчета;

	ЭтоДоговорКомиссии     = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку"));
		
	ЭтоДоговорПриобретения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку"));
		
	ЭтоДоговорРеализации   = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку"));
		
	ЭтоПрочийДоговор = Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее");
		
	ВидимостьКомиссионногоВознаграждения = (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентом"))
		ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку"));
		
	//Группа "Расчеты"
	
	Элементы.ОплатаВРублях.Видимость = (ЭтоДоговорРеализации И Объект.ВидДоговора <> ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку")
			ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком"))
		И (Объект.ВалютаВзаиморасчетов <> ВалютаРегламентированногоУчета)
		И НЕ Объект.УчетАгентскогоНДС
		И ЗначениеЗаполнено(Объект.ВалютаВзаиморасчетов);
		
	ЗначениеВыбора = Элементы.ОплатаВРублях.СписокВыбора.НайтиПоЗначению(0);
	ЗначениеВыбора.Представление = Объект.ВалютаВзаиморасчетов;
	
	Если Объект.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
		ТекстЗаголовкаРасчеты = НСтр("ru= 'Расчеты'");
	ИначеЕсли Объект.РасчетыВУсловныхЕдиницах Тогда
		ТекстЗаголовкаРасчеты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru= 'Расчеты: %1 (оплата в руб.)'"), Объект.ВалютаВзаиморасчетов);
	Иначе
		ТекстЗаголовкаРасчеты = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru= 'Расчеты: %1'"), Объект.ВалютаВзаиморасчетов);
	КонецЕсли;
	
	УстановитьЗаголовокГруппы(Форма, "ГруппаРасчеты", ТекстЗаголовкаРасчеты);
	
	Если Элементы.ОплатаВРублях.Видимость Тогда
		Элементы.ОплатаВРублях.ТолькоПросмотр = Форма.УсловиеОплатаВВалютеПередано;
	КонецЕсли;
	
	Элементы.ГруппаСрокОплаты.Видимость = Объект.ВидДоговора <> ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее");
	
	Элементы.СрокОплаты.Видимость = Объект.УстановленСрокОплаты;
	
	//Группа "Комиссионное вознаграждение"
	
	Элементы.ГруппаКомиссионноеВознаграждение.Видимость = ВидимостьКомиссионногоВознаграждения;
	
	//Группа "НДС"
	
	Если ЭтоДоговорРеализации Тогда
		Элементы.ГруппаНалоговыйАгент.Видимость = Ложь;
		Элементы.ГруппаНДССАвансов.Видимость = Истина;
		Элементы.ГруппаПредъявляетНДС.Видимость = Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером");
		Если ЗначениеЗаполнено(Объект.ПорядокРегистрацииСчетовФактурНаАвансПоДоговору) Тогда
			ТекстЗаголовкаНДС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'НДС: %1'"), Строка(Объект.ПорядокРегистрацииСчетовФактурНаАвансПоДоговору));
		Иначе
			ТекстЗаголовкаНДС = НСтр("ru = 'НДС: Регистрировать счета-фактуры на аванс в порядке, соответствующем учетной политике'");
		КонецЕсли;
	ИначеЕсли ЭтоПрочийДоговор Тогда
		Элементы.ГруппаНалоговыйАгент.Видимость = Ложь;
		Элементы.ГруппаНДССАвансов.Видимость = Ложь;
		Элементы.ГруппаПредъявляетНДС.Видимость = Ложь;
	Иначе
		Элементы.ГруппаНалоговыйАгент.Видимость = Истина;
		Элементы.ГруппаНДССАвансов.Видимость = Ложь;
		Элементы.ГруппаПредъявляетНДС.Видимость = Истина;
		
		Элементы.ГруппаНалоговыйАгент.Доступность = ЭтоДоговорПриобретения 
			И Объект.ВидДоговора <> ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку");
		
		Элементы.ВидАгентскогоДоговора.Доступность = ЭтоДоговорПриобретения 
			И Объект.УчетАгентскогоНДС
			И НЕ ЭтоДоговорКомиссии;
		Элементы.НаименованиеДляСчетаФактурыНалоговогоАгента.Доступность = Объект.УчетАгентскогоНДС;
		
		Если Объект.УчетАгентскогоНДС Тогда
			ТекстЗаголовкаНДС = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'НДС: Налоговый агент по уплате НДС - %1'"), Строка(Объект.ВидАгентскогоДоговора));
		ИначеЕсли Форма.ДоговорСРезидентомТаможенногоСоюза И НЕ Объект.УчетАгентскогоНДС Тогда
			ТекстЗаголовкаНДС = НСтр("ru = 'НДС: Организация не выступает в качестве налогового агента по уплате НДС'");
		ИначеЕсли Объект.ПредъявляетНДС Тогда
			ТекстЗаголовкаНДС = НСтр("ru = 'НДС: Поставщик по договору предъявляет НДС'");
		Иначе
			ТекстЗаголовкаНДС = НСтр("ru = 'НДС: Поставщик по договору не предъявляет НДС'");
		КонецЕсли;
		
	КонецЕсли;
	
	УстановитьЗаголовокГруппы(Форма, "ГруппаНДС", ТекстЗаголовкаНДС);
	
	Элементы.ПредъявляетНДС.Доступность = 
		НЕ (ЭтоДоговорРеализации ИЛИ Объект.УчетАгентскогоНДС ИЛИ Форма.ДоговорСРезидентомТаможенногоСоюза)
		ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером");
	
	Элементы.НДСПоСтавкам4и2.Доступность = Объект.ПредъявляетНДС;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьЗаголовокГруппы(Форма, НазваниеГруппы, ЗаголовокТекст)
	
	Форма.Элементы[НазваниеГруппы].ЗаголовокСвернутогоОтображения = ЗаголовокТекст;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ЗаполнитьСписокСпособовРасчетаКомиссионногоВознаграждения(Форма)

	Объект = Форма.Объект;
	Элементы = Форма.Элементы;

	ЭтоКомиссияПоЗакупке = Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку")
		ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку");

	СписокСпособов = ОбщегоНазначенияКлиентСервер.СформироватьСписокСпособовРасчетаКомиссионногоВознаграждения(ЭтоКомиссияПоЗакупке);
	СписокВыбора = Элементы.СпособРасчетаКомиссионногоВознаграждения.СписокВыбора;
	СписокВыбора.Очистить();
	Для Каждого ЭлементСписка Из СписокСпособов Цикл
		СписокВыбора.Добавить(ЭлементСписка.Значение, ЭлементСписка.Представление);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьНаименованиеДоговора()
	
	ТекстНаименования = Объект.Наименование;
	
	НовыеРеквизитыДоговораСтрокой = ПечатьДоговоровКлиентСервер.РеквизитыДоговораСтрокой(Объект.Номер, Объект.Дата);
	
	Если ПустаяСтрока(ТекстНаименования) Или ТекстНаименования = НаименованиеПоУмолчанию Тогда // См. ПечатьДоговоровКлиентСервер.НаименованиеПоУмолчаниюБезРеквизитов()
		ТекстНаименования = НовыеРеквизитыДоговораСтрокой;
	ИначеЕсли СтрНайти(ТекстНаименования, РеквизитыДоговораСтрокой) > 0 
		И СтрНайти(ТекстНаименования, НовыеРеквизитыДоговораСтрокой) = 0 Тогда
		ТекстНаименования = СтрЗаменить(ТекстНаименования, РеквизитыДоговораСтрокой, НовыеРеквизитыДоговораСтрокой);
	КонецЕсли;
	
	РеквизитыДоговораСтрокой = НовыеРеквизитыДоговораСтрокой;
	
	Объект.Наименование = ТекстНаименования;
	
КонецПроцедуры

&НаСервере
Процедура ОграничитьВыборРеквизитов(ЗначенияЗаполнения)

	Если ЗначенияЗаполнения.Свойство("Организация") Тогда
		Если ТипЗнч(ЗначенияЗаполнения.Организация) = Тип("СправочникСсылка.Организации") Тогда
			Элементы.Организация.ТолькоПросмотр = ЗначениеЗаполнено(ЗначенияЗаполнения.Организация);
		КонецЕсли;
	КонецЕсли;

	Если ЗначенияЗаполнения.Свойство("Владелец") Тогда
		Если ТипЗнч(ЗначенияЗаполнения.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
			Элементы.Владелец.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначенияЗаполнения.Свойство("ВалютаВзаиморасчетов") Тогда
		Если ТипЗнч(ЗначенияЗаполнения.ВалютаВзаиморасчетов) = Тип("СправочникСсылка.Валюты") Тогда
			Элементы.ВалютаВзаиморасчетов.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	//Проверим, передавались ли ограничения по валюте
	Если Параметры.ЗначенияЗаполнения.Свойство("Валютный") Тогда
		
		МассивРазрешенныхВалют = 
			Справочники.ДоговорыКонтрагентов.ПодготовитьСписокРазрешенныхВалют(
				ВалютаРегламентированногоУчета, Параметры.ЗначенияЗаполнения.Валютный);
		
		Элементы.ВалютаВзаиморасчетов.ПараметрыВыбора = Новый ФиксированныйМассив(МассивРазрешенныхВалют);
		
	КонецЕсли;
	
	Если Параметры.ЗначенияЗаполнения.Свойство("ОплатаВВалюте") Тогда
		УсловиеОплатаВВалютеПередано = Истина;
	КонецЕсли;
	
	Если ЗначенияЗаполнения.Свойство("ВидДоговора") Тогда
		МассивВидовДоговоров = Новый Массив;
		Если ТипЗнч(ЗначенияЗаполнения.ВидДоговора) = Тип("Массив") Тогда
			МассивВидовДоговоров = ЗначенияЗаполнения.ВидДоговора;
		ИначеЕсли ТипЗнч(ЗначенияЗаполнения.ВидДоговора) = Тип("ФиксированныйМассив") Тогда
			МассивВидовДоговоров = Новый Массив(ЗначенияЗаполнения.ВидДоговора);
		КонецЕсли;
		ОдинВидДоговора = МассивВидовДоговоров.Количество() <= 1;
		Если ОдинВидДоговора Тогда
			Элементы.ВидДоговора.ТолькоПросмотр = Истина;
		Иначе
			Элементы.ВидДоговора.РежимВыбораИзСписка = Истина;
			Элементы.ВидДоговора.СписокВыбора.ЗагрузитьЗначения(МассивВидовДоговоров);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры 

&НаКлиенте
Процедура ОбработкаОповещенияСозданиеФайлаДоговора(ФайлДоговора)
	
	Если ЗначениеЗаполнено(Объект.ФайлДоговора) Тогда
		// В договоре уже указан какой-то файл договора, не меняем его.
		Возврат;
	КонецЕсли;

	Объект.ФайлДоговора = ФайлДоговора;
	
	Если НЕ Модифицированность Тогда
		// Пользователь договор не менял, записываем его самостоятельно.
		Записать();
	КонецЕсли;	
	
	// Сообщим форме редактирования текста договора, что мы запомнили ссылку на файл, 
	// и сам объект справочника ДоговорыКонтрагентов изменять не требуется,
	// чтобы при интерактивной работе пользователя не возникало сообщений об изменении
	// объекта в другом сеансе из-за записи изменений элемента справочника.
	Оповестить("ДоговорыКонтрагентов_СозданиеФайлаОбработаноОсновнойФормойДоговора", Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ВладелецПриИзмененииНаСервере()

	Справочники.ДоговорыКонтрагентов.ЗаполнитьРуководителяКонтрагента(Объект)

КонецПроцедуры

&НаСервере
Процедура ОрганизацияПриИзмененииНаСервере()

	Справочники.ДоговорыКонтрагентов.ЗаполнитьРуководителяОрганизации(Объект);

КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСписокКонтактныхЛиц(Знач Контрагент)
	
	Возврат Справочники.КонтактныеЛица.СписокКонтактныхЛиц(Контрагент, Ложь);

КонецФункции

&НаКлиенте
Процедура РуководительКонтрагентаНачалоВыбораЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		МассивФИОДолжность = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(РезультатВыбора.Представление, ", ");
		Если МассивФИОДолжность.Количество() > 0 Тогда
			Объект.РуководительКонтрагента = МассивФИОДолжность[0];
		КонецЕсли;
		Если МассивФИОДолжность.Количество() > 1 Тогда
			Объект.ДолжностьРуководителяКонтрагента = МассивФИОДолжность[1];
		КонецЕсли;
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВалютаВзаиморасчетовПриИзмененииНаСервере()
	
	Если Объект.ВалютаВзаиморасчетов = ВалютаРегламентированногоУчета Тогда
		Объект.РасчетыВУсловныхЕдиницах = Ложь;
		ОплатаВРублях = 0;
	Иначе
		
		Если Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем")
			ИЛИ (Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомиссионером"))
			ИЛИ ((Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПоставщиком") И НЕ Объект.УчетАгентскогоНДС))
			ИЛИ (НЕ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.Прочее") И УсловиеОплатаВВалютеПередано 
			И НЕ Объект.ОплатаВВалюте) Тогда
			Объект.РасчетыВУсловныхЕдиницах = Истина;
			ОплатаВРублях = 1;
		КонецЕсли;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПредъявляетНДС()
	
	ПоставщикНеПредъявляетНДС = Объект.УчетАгентскогоНДС
		ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СПокупателем")
		ИЛИ Объект.ВидДоговора = ПредопределенноеЗначение("Перечисление.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку");
		
	Если Объект.ПредъявляетНДС И ПоставщикНеПредъявляетНДС Тогда
		Объект.ПредъявляетНДС = Ложь;
	ИначеЕсли НЕ Объект.ПредъявляетНДС
		И НЕ ПоставщикНеПредъявляетНДС Тогда 
		Объект.ПредъявляетНДС = Истина;
	КонецЕсли;
	
	Если Объект.НДСПоСтавкам4и2 и ПоставщикНеПредъявляетНДС Тогда
		Объект.НДСПоСтавкам4и2 = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ПроцедурыПодсистемыСвойств

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()

	//УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);

КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()

	//УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	// Обработчик подсистемы "Свойства"
	//УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	//УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	//УправлениеСвойствами.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	//ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	//Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
	//	РезультатВыполнения = Неопределено;
	//	ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	//	ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	//КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	//УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

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