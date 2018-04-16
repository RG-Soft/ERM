
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОбновитьПослеДобавления" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодобратьИзКлассификатора(Команда)
	
	ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
	ОткрытьФорму("Справочник.КлассификаторБанковРФ.ФормаВыбора", ПараметрыФормы, Этаформа);

КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Если Не Группа Тогда
		
		Текст = НСтр("ru = 'Есть возможность подобрать банк из классификатора.
		|Подобрать?'");
		
		ТекДанные = Элементы.Список.ТекущиеДанные;
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("Родитель", Родитель);
		Если Копирование Тогда
			ДополнительныеПараметры.Вставить("Наименование", ТекДанные.Наименование);
			ДополнительныеПараметры.Вставить("Код", ТекДанные.Код);
			ДополнительныеПараметры.Вставить("КоррСчет", ТекДанные.КоррСчет);
			ДополнительныеПараметры.Вставить("Город", ТекДанные.Город);
			ДополнительныеПараметры.Вставить("Адрес", ТекДанные.Адрес);
			ДополнительныеПараметры.Вставить("Телефоны", ТекДанные.Телефоны);
			ДополнительныеПараметры.Вставить("СВИФТБИК", ТекДанные.СВИФТБИК);
			ДополнительныеПараметры.Вставить("Страна", ТекДанные.Страна);
		КонецЕсли;
		
		Оповещение = Новый ОписаниеОповещения("ВопросЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ПоказатьВопрос(Оповещение, Текст, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВопросЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПараметрыФормы = Новый Структура("ЗакрыватьПриВыборе, МножественныйВыбор", Ложь, Истина);
		ОткрытьФорму("Справочник.КлассификаторБанковРФ.ФормаВыбора", ПараметрыФормы, Этаформа);
	Иначе
		ПараметрыФормы = Новый Структура("Основание", ДополнительныеПараметры);
		ОткрытьФорму("Справочник.Банки.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	МожноРедактировать = ПравоДоступа("Редактирование", Метаданные.Справочники.Банки);
	Элементы.ФормаПодобратьИзКлассификатора.Видимость = МожноРедактировать;
	
КонецПроцедуры
