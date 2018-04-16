
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СтранаРФ = Справочники.СтраныМира.Россия;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если Параметры.Код <> "" Тогда
			БИК = СокрЛП(Параметры.Код);
			Объект.Код = БИК;
		КонецЕсли;
		
		Если Параметры.КоррСчет <> "" Тогда
			Объект.КоррСчет = Параметры.КоррСчет;
		КонецЕсли;
		
		ЗаполнитьФормуПоОбъекту();
	КонецЕсли;
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
	УстановитьУсловноеОформление();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьФормуПоОбъекту();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Объект.РучноеИзменение = ?(РучноеИзменение = Неопределено, 2, РучноеИзменение);
	
	Если Объект.Страна <> Справочники.СтраныМира.Россия Тогда
		
		Объект.КоррСчет = "";
		Объект.Город = "";
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	// Оповестим форму банковского счета об изменении реквизитов банка
	Оповестить("ЗаписанЭлементБанк", Объект.Ссылка, ЭтотОбъект);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СВИФТБИКПриИзменении(Элемент)
	
	Объект.СВИФТБИК = ВРег(СокрЛП(Объект.СВИФТБИК));
	
	Если БанковскиеПравила.СтрокаСоответствуетФорматуSWIFT(Объект.СВИФТБИК) Тогда
		
		СтранаБанка = СтранаПоSWIFT(Объект.СВИФТБИК);
		
		Если ЗначениеЗаполнено(СтранаБанка) Тогда
			Объект.Страна = СтранаБанка;
		КонецЕсли;
		
		ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаПриИзменении(Элемент)
	
	ИзменитьРеквизитыЗависимыеОтСтраны(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СтранаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	УправлениеКонтактнойИнформациейКлиент.СтранаМираОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Изменить(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВопросИзменитьЗавершение", ЭтотОбъект);
	
	Текст = НСтр("ru = 'Поставляемые данные обновляются автоматически.
		|После ручного изменения автоматическое обновление этого элемента производиться не будет.
		|Продолжить с изменением?'");
		
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИзКлассификатора(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ВопросОбновитьИзКлассификатораЗавершение", ЭтотОбъект);
	
	Текст = НСтр("ru = 'Данные элемента будут заменены данными из классификатора.
		|Все ручные изменения будут потеряны. Продолжить?'");
		
	ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	ЭлементУО = УсловноеОформление.Элементы.Добавить();
	
	// Код банка.
	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Код");
	
	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Объект.Страна", ВидСравненияКомпоновкиДанных.НеРавно, Справочники.СтраныМира.Россия);
	
	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ОтметкаНезаполненного", Ложь)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьРеквизитыЗависимыеОтСтраны(Форма)
	
	ЯвляетсяБанкомРФ = (Форма.Объект.Страна = Форма.СтранаРФ);
	
	Форма.Элементы.КоррСчет.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.Город.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.ТекстРучногоИзменения.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.ОбновитьИзКлассификатора.Видимость = ЯвляетсяБанкомРФ;
	Форма.Элементы.Изменить.Видимость = ЯвляетсяБанкомРФ;
	
	Если ЯвляетсяБанкомРФ Тогда
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'БИК'");
	Иначе
		Форма.Элементы.Код.Заголовок = НСтр("ru = 'Национальный код'"); 
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьФормуПоОбъекту()
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Банки);
	РаботаСБанкамиБП.СчитатьФлагРучногоИзменения(ЭтотОбъект, МожноРедактировать);
	
	Элементы.СтраницыДеятельностьПрекращена.ТекущаяСтраница = ?(ДеятельностьПрекращена,
		Элементы.СтраницаНадписьДеятельностьПрекращена, Элементы.СтраницаПустая);
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросИзменитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		РучноеИзменение    = Истина;
		РаботаСБанкамиКлиентПереопределяемый.ОбработатьФлагРучногоИзменения(ЭтотОбъект);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросОбновитьИзКлассификатораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
		Модифицированность = Истина;
		ОбновитьНаСервере();
		ОповеститьОбИзменении(Объект.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьНаСервере()
	
	РаботаСБанкамиБП.ВосстановитьЭлементИзОбщихДанных(ЭтотОбъект);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция СтранаПоSWIFT(СВИФТБИК)
	
	Возврат Справочники.Банки.СтранаПоSWIFT(СВИФТБИК);
	
КонецФункции

#КонецОбласти
