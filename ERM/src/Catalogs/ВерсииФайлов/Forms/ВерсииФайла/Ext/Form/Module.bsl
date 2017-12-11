﻿&НаКлиенте
Перем Ссылка1;

&НаКлиенте
Перем Ссылка2;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ВидимостьКомандыСравнить = 
		Не ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() И Не ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент();
	Элементы.ФормаСравнить.Видимость = ВидимостьКомандыСравнить;
	Элементы.КонтекстноеМенюСписокСравнить.Видимость = ВидимостьКомандыСравнить;
	
	УникальныйИдентификаторКарточкиФайла = Параметры.УникальныйИдентификаторКарточкиФайла;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СделатьАктивнойВыполнить()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(ТекущиеДанные.Ссылка);
	
	Если Не ЗначениеЗаполнено(ДанныеФайла.Редактирует) Тогда
		СменитьАктивнуюВерсиюФайла(ТекущиеДанные.Ссылка);
		ЗаполнитьСписок();
		Оповестить("Запись_Файл", Новый Структура("Событие", "АктивнаяВерсияИзменена"), Параметры.Файл);
	Иначе
		ПоказатьПредупреждение(, НСтр("ru = 'Смена активной версии разрешена только для незанятых файлов.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция ОбойтиВсеУзлыДерева(Элементы, ТекущаяВерсия)
	
	Для Каждого Версия Из Элементы Цикл
		
		Если Версия.Ссылка = ТекущаяВерсия Тогда
			Идентификатор = Версия.ПолучитьИдентификатор();
			Возврат Идентификатор;
		КонецЕсли;
		
		КодВозврата = ОбойтиВсеУзлыДерева(Версия.ПолучитьЭлементы(), ТекущаяВерсия);
		Если КодВозврата <> -1 Тогда
			Возврат КодВозврата;
		КонецЕсли;
	КонецЦикла;
	
	Возврат -1;
КонецФункции

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл" И (Параметр.Событие = "ЗаконченоРедактирование" Или Параметр.Событие = "ВерсияСохранена") Тогда
		
		Если Параметры.Файл = Источник Тогда
			
			ТекущаяВерсия = Элементы.Список.ТекущиеДанные.Ссылка;
			ЗаполнитьСписок();
			
			КодВозврата = ОбойтиВсеУзлыДерева(Список.ПолучитьЭлементы(), ТекущаяВерсия);
			Если КодВозврата <> -1 Тогда
				Элементы.Список.ТекущаяСтрока = КодВозврата;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Справочник.ВерсииФайлов.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдаление(Команда)
	
	ПометитьНаУдалениеСнятьПометку();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда 
		
		Версия = ТекущиеДанные.Ссылка;
		
		ПараметрыОткрытияФормы = Новый Структура("Ключ", Версия);
		ОткрытьФорму("Справочник.ВерсииФайлов.ФормаОбъекта", ПараметрыОткрытияФормы);
		
	КонецЕсли;
	
КонецПроцедуры

// Сравнить 2 выбранные версии. 
&НаКлиенте
Процедура Сравнить(Команда)
	
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	Если ЧислоВыделенныхСтрок = 2 ИЛИ ЧислоВыделенныхСтрок = 1 Тогда
		Если ЧислоВыделенныхСтрок = 2 Тогда
			Ссылка1 = Список.НайтиПоИдентификатору(Элементы.Список.ВыделенныеСтроки[0]).Ссылка;
			Ссылка2 = Список.НайтиПоИдентификатору(Элементы.Список.ВыделенныеСтроки[1]).Ссылка;
		ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
			
			Ссылка1 = Элементы.Список.ТекущиеДанные.Ссылка;
			Ссылка2 = Элементы.Список.ТекущиеДанные.РодительскаяВерсия;
			
		КонецЕсли;
		
		СпособСравненияВерсийФайлов = Неопределено;
		Расширение = НРег(Элементы.Список.ТекущиеДанные.Расширение);
		
		РасширениеПоддерживается = (
			    Расширение = "txt"
			ИЛИ Расширение = "doc"
			ИЛИ Расширение = "docx"
			ИЛИ Расширение = "rtf"
			ИЛИ Расширение = "htm"
			ИЛИ Расширение = "html"
			ИЛИ Расширение = "odt");
		
		Если Не РасширениеПоддерживается Тогда
			ТекстПредупреждения =
				НСтр("ru = 'Сравнение версий поддерживается только для файлов следующих типов: 
				           |   Текстовый документ (.txt)
				           |   Документ формата RTF (.rtf) 
				           |   Документ Microsoft Word (.doc, .docx) 
				           |   Документ HTML (.html .htm) 
				           |   Текстовый документ OpenDocument (.odt)'");
			ПоказатьПредупреждение(, ТекстПредупреждения);
			Возврат;
		КонецЕсли;
		
		Если СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиента().ЭтоБазоваяВерсияКонфигурации Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Данная операция не поддерживается в базовой версии.'"));
			Возврат;
		КонецЕсли;
		
		Если Расширение = "odt" Тогда
			СпособСравненияВерсийФайлов = "OpenOfficeOrgWriter";
		ИначеЕсли Расширение = "htm" ИЛИ Расширение = "html" Тогда
			СпособСравненияВерсийФайлов = "MicrosoftOfficeWord";
		КонецЕсли;
		
		ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ЧислоВыделенныхСтрок = Элементы.Список.ВыделенныеСтроки.Количество();
	
	КомандаСравненияДоступна = Ложь;
	
	Если ЧислоВыделенныхСтрок = 2 Тогда
		КомандаСравненияДоступна = Истина;
	ИначеЕсли ЧислоВыделенныхСтрок = 1 Тогда
		
		Если Не Элементы.Список.ТекущиеДанные.РодительскаяВерсия.Пустая() Тогда
			КомандаСравненияДоступна = Истина;
		Иначе
			КомандаСравненияДоступна = Ложь;
		КонецЕсли;
			
	Иначе
		КомандаСравненияДоступна = Ложь;
	КонецЕсли;

	Если КомандаСравненияДоступна = Истина Тогда
		Элементы.ФормаСравнить.Доступность = Истина;
		Элементы.КонтекстноеМенюСписокСравнить.Доступность = Истина;
	Иначе
		Элементы.ФормаСравнить.Доступность = Ложь;
		Элементы.КонтекстноеМенюСписокСравнить.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьВерсию(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.ОткрытьВерсиюФайла(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(ТекущиеДанные.Ссылка, УникальныйИдентификатор);
	РаботаСФайламиСлужебныйКлиент.СохранитьКак(Неопределено, ДанныеФайла, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	Отказ = Истина;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СменитьАктивнуюВерсиюФайла(Версия)
	
	ФайлОбъект = Версия.Владелец.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, , УникальныйИдентификаторКарточкиФайла);
	ФайлОбъект.ТекущаяВерсия = Версия;
	ФайлОбъект.ТекстХранилище = Версия.ТекстХранилище;
	ФайлОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(ФайлОбъект.Ссылка, УникальныйИдентификаторКарточкиФайла);
	
	ВерсияОбъект = Версия.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(Версия, , УникальныйИдентификаторКарточкиФайла);
	ВерсияОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(Версия, УникальныйИдентификаторКарточкиФайла);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписок()
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВерсииФайлов.Код КАК Код,
	|	ВерсииФайлов.Размер КАК Размер,
	|	ВерсииФайлов.Комментарий КАК Комментарий,
	|	ВерсииФайлов.Автор КАК Автор,
	|	ВерсииФайлов.ДатаСоздания КАК ДатаСоздания,
	|	ВерсииФайлов.ПолноеНаименование КАК ПолноеНаименование,
	|	ВерсииФайлов.РодительскаяВерсия КАК РодительскаяВерсия,
	|	ВерсииФайлов.ИндексКартинки,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.ПометкаУдаления = ИСТИНА
	|			ТОГДА 1
	|		ИНАЧЕ ВерсииФайлов.ИндексКартинки
	|	КОНЕЦ КАК ИндексКартинкиТекущий,
	|	ВерсииФайлов.ПометкаУдаления КАК ПометкаУдаления,
	|	ВерсииФайлов.Владелец КАК Владелец,
	|	ВерсииФайлов.Ссылка КАК Ссылка,
	|	ВЫБОР
	|		КОГДА ВерсииФайлов.Владелец.ТекущаяВерсия = ВерсииФайлов.Ссылка
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК ЭтоТекущая,
	|	ВерсииФайлов.Расширение КАК Расширение,
	|	ВерсииФайлов.НомерВерсии КАК НомерВерсии
	|ИЗ
	|	Справочник.ВерсииФайлов КАК ВерсииФайлов
	|ГДЕ
	|	ВерсииФайлов.Владелец = &Владелец");
	
	Запрос.УстановитьПараметр("Владелец", Параметры.Файл);
	Данные = Запрос.Выполнить().Выгрузить();
	
	Дерево = РеквизитФормыВЗначение("Список");
	Дерево.Строки.Очистить();
	
	ДобавитьПредыдущуюВерсию(Неопределено, Дерево, Данные);
	ЗначениеВРеквизитФормы(Дерево, "Список");
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПредыдущуюВерсию(ТекущаяВетвь, Дерево, Данные)
	
	НайденнаяСтрока = Неопределено;
	
	Если ТекущаяВетвь = Неопределено Тогда
		Для Каждого Строка Из Данные Цикл
			Если Строка.ЭтоТекущая Тогда
				НайденнаяСтрока = Строка;
				Прервать;
			КонецЕсли;
		КонецЦикла;	
	Иначе
		Для Каждого Строка Из Данные Цикл
			Если Строка.Ссылка = ТекущаяВетвь.РодительскаяВерсия Тогда 
				НайденнаяСтрока = Строка;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если НайденнаяСтрока <> Неопределено Тогда 
		Ветвь = Дерево.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(Ветвь, НайденнаяСтрока);
		Данные.Удалить(НайденнаяСтрока);
		
		ДобавитьПодчиненныеВерсии(Ветвь, Данные);
		ДобавитьПредыдущуюВерсию(Ветвь, Дерево, Данные);
	КонецЕсли;		
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьПодчиненныеВерсии(Ветвь, Данные)
	
	Для Каждого Строка Из Данные Цикл
		Если Ветвь.Ссылка = Строка.РодительскаяВерсия Тогда
			ЗаполнитьЗначенияСвойств(Ветвь.Строки.Добавить(), Строка);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Веточка Из Ветвь.Строки Цикл
		ДобавитьПодчиненныеВерсии(Веточка, Данные);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПометкуУдаления(Версия, Пометка)
	ВерсияОбъект = Версия.ПолучитьОбъект();
	ВерсияОбъект.Заблокировать();
	ВерсияОбъект.УстановитьПометкуУдаления(Пометка);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометку()
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда 
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ПометкаУдаления Тогда 
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Снять с ""%1"" пометку на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	Иначе
		ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Пометить ""%1"" на удаление?'"),
			Строка(ТекущиеДанные.Ссылка));
	КонецЕсли;
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("ТекущиеДанные", ТекущиеДанные);
	Обработчик = Новый ОписаниеОповещения("ПометитьНаУдалениеСнятьПометкуЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	ПоказатьВопрос(Обработчик, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Да);
КонецПроцедуры

&НаКлиенте
Процедура ПометитьНаУдалениеСнятьПометкуЗавершение(Ответ, ПараметрыВыполнения) Экспорт
	Если Ответ <> КодВозвратаДиалога.Да Тогда 
		Возврат;
	КонецЕсли;
	ПараметрыВыполнения.ТекущиеДанные.ПометкаУдаления = Не ПараметрыВыполнения.ТекущиеДанные.ПометкаУдаления;
	УстановитьПометкуУдаления(ПараметрыВыполнения.ТекущиеДанные.Ссылка, ПараметрыВыполнения.ТекущиеДанные.ПометкаУдаления);
	
	Если ПараметрыВыполнения.ТекущиеДанные.ПометкаУдаления Тогда
		ПараметрыВыполнения.ТекущиеДанные.ИндексКартинкиТекущий = 1;
	Иначе
		ПараметрыВыполнения.ТекущиеДанные.ИндексКартинкиТекущий = ПараметрыВыполнения.ТекущиеДанные.ИндексКартинки;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПродолжитьСравнениеВерсий(СпособСравненияВерсийФайлов)
	
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("СпособСравненияВерсийФайлов", СпособСравненияВерсийФайлов);
	ПараметрыВыполнения.Вставить("ТекущийШаг", 1);
	ПараметрыВыполнения.Вставить("ДанныеФайла1", Неопределено);
	ПараметрыВыполнения.Вставить("ДанныеФайла2", Неопределено);
	ПараметрыВыполнения.Вставить("Результат1", Неопределено);
	ПараметрыВыполнения.Вставить("Результат2", Неопределено);
	ПараметрыВыполнения.Вставить("ПолноеИмяФайла1", Неопределено);
	ПараметрыВыполнения.Вставить("ПолноеИмяФайла2", Неопределено);
	
	СравнениеВерсийАвтомат(-1, ПараметрыВыполнения);
	
КонецПроцедуры

&НаКлиенте
Процедура СравнениеВерсийАвтомат(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат <> -1 Тогда
		Если ПараметрыВыполнения.ТекущийШаг = 1 Тогда
			Если Результат <> КодВозвратаДиалога.ОК Тогда
				Возврат;
			КонецЕсли;
			
			ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
			ПараметрыВыполнения.СпособСравненияВерсийФайлов = ПерсональныеНастройки.СпособСравненияВерсийФайлов;
			
			Если ПараметрыВыполнения.СпособСравненияВерсийФайлов = Неопределено Тогда
				Возврат;
			КонецЕсли;
			ПараметрыВыполнения.ТекущийШаг = 2;
			
		ИначеЕсли ПараметрыВыполнения.ТекущийШаг = 3 Тогда
			ПараметрыВыполнения.Результат1      = Результат.ФайлПолучен;
			ПараметрыВыполнения.ПолноеИмяФайла1 = Результат.ПолноеИмяФайла;
			ПараметрыВыполнения.ТекущийШаг = 4;
			
		ИначеЕсли ПараметрыВыполнения.ТекущийШаг = 4 Тогда
			ПараметрыВыполнения.Результат2      = Результат.ФайлПолучен;
			ПараметрыВыполнения.ПолноеИмяФайла2 = Результат.ПолноеИмяФайла;
			ПараметрыВыполнения.ТекущийШаг = 5;
		КонецЕсли;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ТекущийШаг = 1 Тогда
		Если ПараметрыВыполнения.СпособСравненияВерсийФайлов = Неопределено Тогда
			
			ПерсональныеНастройки = ФайловыеФункцииСлужебныйКлиентСервер.ПерсональныеНастройкиРаботыСФайлами();
			ПараметрыВыполнения.СпособСравненияВерсийФайлов = ПерсональныеНастройки.СпособСравненияВерсийФайлов;
			
			Если ПараметрыВыполнения.СпособСравненияВерсийФайлов = Неопределено Тогда
				// Первый вызов - еще не инициализирована настройка.
				Обработчик = Новый ОписаниеОповещения("СравнениеВерсийАвтомат", ЭтотОбъект, ПараметрыВыполнения);
				ОткрытьФорму("Справочник.ВерсииФайлов.Форма.ВыборСпособаСравненияВерсий", ,
					ЭтотОбъект, , , , Обработчик);
				Возврат;
			КонецЕсли;
		КонецЕсли;
		ПараметрыВыполнения.ТекущийШаг = 2;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ТекущийШаг = 2 Тогда
		
		ПараметрыВыполнения.ДанныеФайла1 = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(
			Ссылка1, УникальныйИдентификатор);
		ПараметрыВыполнения.ДанныеФайла2 = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляОткрытия(
			Ссылка2, УникальныйИдентификатор);
		
		ТекстСостояния = НСтр("ru = 'Выполняется сравнение версий файла ""%1""...'");
		ТекстСостояния = СтрЗаменить(ТекстСостояния, "%1", Строка(ПараметрыВыполнения.ДанныеФайла1.Ссылка));
		Состояние(ТекстСостояния);
		ПараметрыВыполнения.ТекущийШаг = 3;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ТекущийШаг = 3 Тогда
		Обработчик = Новый ОписаниеОповещения("СравнениеВерсийАвтомат", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиСлужебныйКлиент.ПолучитьФайлВерсииВРабочийКаталог(
			Обработчик, ПараметрыВыполнения.ДанныеФайла1, ПараметрыВыполнения.ПолноеИмяФайла1);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ТекущийШаг = 4 Тогда
		Обработчик = Новый ОписаниеОповещения("СравнениеВерсийАвтомат", ЭтотОбъект, ПараметрыВыполнения);
		РаботаСФайламиСлужебныйКлиент.ПолучитьФайлВерсииВРабочийКаталог(
			Обработчик, ПараметрыВыполнения.ДанныеФайла2, ПараметрыВыполнения.ПолноеИмяФайла2);
		Возврат;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ТекущийШаг = 5 Тогда
		Если ПараметрыВыполнения.Результат1 И ПараметрыВыполнения.Результат2 Тогда
			Если ПараметрыВыполнения.ДанныеФайла1.НомерВерсии < ПараметрыВыполнения.ДанныеФайла2.НомерВерсии Тогда
				ПолноеИмяФайлаСлева  = ПараметрыВыполнения.ПолноеИмяФайла1;
				ПолноеИмяФайлаСправа = ПараметрыВыполнения.ПолноеИмяФайла2;
			Иначе
				ПолноеИмяФайлаСлева  = ПараметрыВыполнения.ПолноеИмяФайла2;
				ПолноеИмяФайлаСправа = ПараметрыВыполнения.ПолноеИмяФайла1;
			КонецЕсли;
			РаботаСФайламиСлужебныйКлиент.СравнитьФайлы(
				ПолноеИмяФайлаСлева,
				ПолноеИмяФайлаСправа,
				ПараметрыВыполнения.СпособСравненияВерсийФайлов);
		КонецЕсли;
		Состояние();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
