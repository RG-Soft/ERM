
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ПапкаДляДобавления") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Данная обработка вызывается из других процедур конфигурации.
			           |Вручную ее вызывать запрещено.'"));
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.ПапкаДляДобавления <> Неопределено Тогда
		ВладелецФайлов = Параметры.ПапкаДляДобавления;
		Если ТипЗнч(ВладелецФайлов) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
			ПапкаДляДобавления = ВладелецФайлов;
		Иначе
			Элементы.ПапкаДляДобавления.Видимость = Ложь;
		КонецЕсли;	
	КонецЕсли;
	
	Если Параметры.МассивИменФайлов <> Неопределено Тогда
		Для Каждого ПутьФайла Из Параметры.МассивИменФайлов Цикл
			ФайлПеренесенный = Новый Файл(ПутьФайла);
			НовыйЭлемент = ВыбранныеФайлы.Добавить();
			НовыйЭлемент.Путь = ПутьФайла;
			НовыйЭлемент.ИндексКартинки = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ХранитьВерсии = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ВРег(ИсточникВыбора.ИмяФормы) = ВРег("Справочник.Файлы.Форма.ВыборКодировки") Тогда
		Если ТипЗнч(ВыбранноеЗначение) <> Тип("Структура") Тогда
			Возврат;
		КонецЕсли;
		КодировкаТекстаФайла = ВыбранноеЗначение.Значение;
		КодировкаПредставление = ВыбранноеЗначение.Представление;
		УстановитьПредставлениеКомандыКодировки(КодировкаПредставление);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВыбранныеФайлы

&НаКлиенте
Процедура ВыбранныеФайлыПередНачаломДобавления(Элемент, Отказ, Копирование)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ДобавитьВыполнить()
	
	ОчиститьСообщения();
	
	ПоляНеЗаполнены = Ложь;
	
	Если ВыбранныеФайлы.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Нет файлов для добавления.'"), , "ВыбранныеФайлы");
		ПоляНеЗаполнены = Истина;
	КонецЕсли;
	
	ВладелецФайловДляДобавления = ВладелецФайлов;
	Если ТипЗнч(ВладелецФайлов) = Тип("СправочникСсылка.ПапкиФайлов") Тогда
		ВладелецФайловДляДобавления = ПапкаДляДобавления;
	КонецЕсли;

	Если ВладелецФайловДляДобавления.Пустая() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Укажите папку.'"), , "ПапкаДляДобавления");
		ПоляНеЗаполнены = Истина;
	КонецЕсли;
	
	Если ПоляНеЗаполнены = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ВыбранныеФайлыСписокЗначений = Новый СписокЗначений;
	Для Каждого СтрокаСписка Из ВыбранныеФайлы Цикл
		ВыбранныеФайлыСписокЗначений.Добавить(СтрокаСписка.Путь);
	КонецЦикла;
	
	#Если ВебКлиент Тогда
		
		МассивОпераций = Новый Массив;
		
		Для Каждого СтрокаСписка Из ВыбранныеФайлы Цикл
			ОписаниеВызова = Новый Массив;
			ОписаниеВызова.Добавить("ПоместитьФайлы");
			
			ПомещаемыеФайлы = Новый Массив;
			Описание = Новый ОписаниеПередаваемогоФайла(СтрокаСписка.Путь, "");
			ПомещаемыеФайлы.Добавить(Описание);
			ОписаниеВызова.Добавить(ПомещаемыеФайлы);
			
			ОписаниеВызова.Добавить(Неопределено);  // не используется
			ОписаниеВызова.Добавить(Неопределено);  // не используется
			ОписаниеВызова.Добавить(Ложь); 			// Интерактивно = Ложь
			
			МассивОпераций.Добавить(ОписаниеВызова);
		КонецЦикла;
		
		Если НЕ ЗапроситьРазрешениеПользователя(МассивОпераций) Тогда
			// Пользователь не дал разрешения.
			Закрыть();
			Возврат;
		КонецЕсли;	
	#КонецЕсли	
	
	ДобавленныеФайлы = Новый Массив;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ДобавленныеФайлы", ДобавленныеФайлы);
	Обработчик = Новый ОписаниеОповещения("ДобавитьВыполнитьЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	ПараметрыВыполнения = РаботаСФайламиСлужебныйКлиент.ПараметрыИмпортаФайлов();
	ПараметрыВыполнения.ОбработчикРезультата = Обработчик;
	ПараметрыВыполнения.Владелец = ВладелецФайловДляДобавления;
	ПараметрыВыполнения.ВыбранныеФайлы = ВыбранныеФайлыСписокЗначений; 
	ПараметрыВыполнения.Комментарий = Комментарий;
	ПараметрыВыполнения.ХранитьВерсии = ХранитьВерсии;
	ПараметрыВыполнения.УдалятьФайлыПослеДобавления = УдалятьФайлыПослеДобавления;
	ПараметрыВыполнения.Рекурсивно = Ложь;
	ПараметрыВыполнения.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыВыполнения.ДобавленныеФайлы = ДобавленныеФайлы;
	ПараметрыВыполнения.Кодировка = КодировкаТекстаФайла;
	
	РаботаСФайламиСлужебныйКлиент.ВыполнитьИмпортФайлов(ПараметрыВыполнения);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлыВыполнить()
	
	Обработчик = Новый ОписаниеОповещения("ВыбратьФайлыВыполнитьПослеУстановкиРасширения", ЭтотОбъект);
	ФайловыеФункцииСлужебныйКлиент.ПоказатьВопросОбУстановкеРасширенияРаботыСФайлами(Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	ОткрытьФорму("Справочник.Файлы.Форма.ВыборКодировки", ПараметрыФормы, ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПредставлениеКомандыКодировки(Представление)
	
	Команды.ВыбратьКодировку.Заголовок = Представление;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВыполнитьЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Закрыть();
	
	ОповещениеПараметр = Неопределено;
	Если ПараметрыВыполнения.ДобавленныеФайлы.Количество() > 0 Тогда
		Индекс = ПараметрыВыполнения.ДобавленныеФайлы.Количество() - 1;
		ОповещениеПараметр = ПараметрыВыполнения.ДобавленныеФайлы[Индекс].ФайлСсылка;
	КонецЕсли;
	Оповестить("ИмпортФайловЗавершен", ОповещениеПараметр);
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайлыВыполнитьПослеУстановкиРасширения(РасширениеУстановлено, ПараметрыВыполнения) Экспорт
	Если Не РасширениеУстановлено Тогда
		Возврат;
	КонецЕсли;
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Все файлы(*.*)|*.*'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Истина;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файлы'");
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		ВыбранныеФайлы.Очистить();
		
		МассивФайлов = ДиалогОткрытияФайла.ВыбранныеФайлы;
		Для Каждого ИмяФайла Из МассивФайлов Цикл
			ФайлПеренесенный = Новый Файл(ИмяФайла);
			НовыйЭлемент = ВыбранныеФайлы.Добавить();
			НовыйЭлемент.Путь = ИмяФайла;
			НовыйЭлемент.ИндексКартинки = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(ФайлПеренесенный.Расширение);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
