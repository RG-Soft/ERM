﻿
#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ПараметрыОбработчикаОжиданияАктуализации Экспорт;

&НаКлиенте
Перем УИДЗамера;

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	//// СтандартныеПодсистемы.ОценкаПроизводительности
	//УИДЗамера = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь, "ФормированиеОтчетаDSODetails");
	//// СтандартныеПодсистемы.ОценкаПроизводительности
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	Иначе
		//ЗафиксироватьДлительностьКлючевойОперации();
				
	КонецЕсли;
	
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

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Результат = РезультатВыполнения.Результат;	

	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;

	ИдентификаторЗадания = Неопределено;

	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
			//ЗафиксироватьДлительностьКлючевойОперации();
					
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал,
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

//&НаКлиенте
//Процедура ЗафиксироватьДлительностьКлючевойОперации()
//	
//	ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(УИДЗамера);
//	
//КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере() Экспорт
	
	Если Не КомпоновщикИнициализирован Тогда
		ИнициализацияКомпоновщикаНастроек();
	КонецЕсли;
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ДополнительныеСвойства = Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
//	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
//	Отчет.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ВыводитьПодвал"   , ВыводитьПодвал);
//	Отчет.КомпоновщикНастроек.Настройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
//	Отчет.КомпоновщикНастроек.Настройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
//	Отчет.КомпоновщикНастроек.Настройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	
	//Возврат Новый Структура("ЗаданиеВыполнено", Истина);
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Отчеты.DSODetailsTest.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор,
			"Отчеты.DSODetailsTest.СформироватьОтчет",
			ПараметрыОтчета, "Формирование отчета DSO Details");
		
		АдресХранилища       = РезультатВыполнения.АдресХранилища;
		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.Сформировать.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()

	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Период"                    		, Период);
	//ПараметрыОтчета.Вставить("Группировка"                      , Отчет.Группировка.Выгрузить());
	ПараметрыОтчета.Вставить("ВыводитьЗаголовок"                , ВыводитьЗаголовок);
	ПараметрыОтчета.Вставить("ВыводитьПодвал"                   , ВыводитьПодвал);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("МакетОформления"                  , "Море");
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	ПараметрыОтчета.Вставить("НаборПоказателей"                 , Отчеты.DSODetails.ПолучитьНаборПоказателей());
	
	Возврат ПараметрыОтчета;

КонецФункции

&НаСервере
Процедура ИнициализацияКомпоновщикаНастроек()
	
	КомпоновщикИнициализирован = Истина;
	
	//Элементы.НастройкиОтчета.Видимость = Истина;
	
	Схема = Отчеты.DSODetails.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанных");
	
	ИмяВариантаНастроек = "Основной";
	ИмяОтчета = "DSODetails";
	
	Если ПустаяСтрока(ИмяВариантаНастроек) Тогда
		ИмяВариантаНастроек = ИмяОтчета;
	КонецЕсли;
	
	ВариантНастроек = Схема.ВариантыНастроек.Найти(ИмяВариантаНастроек);
	
	Если ВариантНастроек <> Неопределено Тогда
		Настройки = ВариантНастроек.Настройки;
	Иначе
		Настройки = Схема.НастройкиПоУмолчанию;
	КонецЕсли;
		
	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Настройки);
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = Период;
	КонецЕсли;
	
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, УникальныйИдентификатор);
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	ТекущиеПользовательскиеНастройки = Неопределено;
	
	Если ЭтоАдресВременногоХранилища(ПользовательскиеНастройки) Тогда
		ТекущиеПользовательскиеНастройки = ПолучитьИзВременногоХранилища(ПользовательскиеНастройки);
	КонецЕсли;
	
	ПриЗагрузкеПользовательскихНастроекКомпоновщикаНаСервере(ЭтаФорма, ТекущиеПользовательскиеНастройки);
	
КонецПроцедуры

// Выполняет инициализацию компоновщика настроек в форме отчета по переданным настройкам.
//
// Параметры:
//	ФормаОтчета - УправляемаяФорма - Форма отчета.
//	Настройки - НастройкиКомпоновкиДанных - Настройки, которые необходимо загрузить в компоновщик.
//
Процедура ПриЗагрузкеПользовательскихНастроекКомпоновщикаНаСервере(ФормаОтчета, Настройки) Экспорт

	// Для отчетов использующих варианты отчетов, при инициализации отчета
	// происходит загрузка варианта и пользовательских настроек поэтому,
	// перед тем как загружать настройки, проверим режим расшифровки.
	РежимРасшифровки = Ложь;
	Если Отчет.Свойство("РежимРасшифровки") И ФормаОтчета.Отчет.РежимРасшифровки Тогда
		РежимРасшифровки = Истина;
	КонецЕсли;
	
	// Если настройки не заданы или отчет в режиме расшифровки, загружаем настройки по умолчанию.
	Если Настройки = Неопределено Тогда
		// Установка настроек по умолчанию
		УстановитьНастройкиКомпоновщикаПоУмолчанию(ФормаОтчета);
	Иначе 
		ТекущиеНастройки = ФормаОтчета.Отчет.КомпоновщикНастроек.Настройки;
		
		// Установка пользовательских настроек
		ТекущиеНастройки.Отбор.ИдентификаторПользовательскойНастройки              = "Отбор";
		ТекущиеНастройки.Порядок.ИдентификаторПользовательскойНастройки            = "Порядок";
		ТекущиеНастройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "УсловноеОформление";
		
		// Перенос пользовательских настроек в основные
		ФормаОтчета.Отчет.КомпоновщикНастроек.ЗагрузитьПользовательскиеНастройки(Настройки);
		ФормаОтчета.Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(ФормаОтчета.Отчет.КомпоновщикНастроек.ПолучитьНастройки());
		
		// Очистка пользовательских настроек
		ТекущиеНастройки = ФормаОтчета.Отчет.КомпоновщикНастроек.Настройки;
		ТекущиеНастройки.Отбор.ИдентификаторПользовательскойНастройки              = "";
		ТекущиеНастройки.Порядок.ИдентификаторПользовательскойНастройки            = "";
		ТекущиеНастройки.УсловноеОформление.ИдентификаторПользовательскойНастройки = "";
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает настройки компоновщика отчета по умолчанию.
//
// Параметры:
//	ФормаОтчета - УправляемаяФорма - Форма отчета.
//
Процедура УстановитьНастройкиКомпоновщикаПоУмолчанию(ФормаОтчета) Экспорт
	
	// Установка начальных значений Группировки
	Если Отчет.Свойство("Группировка") Тогда
		Отчет.Группировка.Очистить();
		Для Каждого ЭлементСтруктуры Из Отчет.КомпоновщикНастроек.Настройки.Структура Цикл
			Если ТипЗнч(ЭлементСтруктуры) = Тип("ДиаграммаКомпоновкиДанных") Тогда
				Для Каждого Серия Из ЭлементСтруктуры.Серии Цикл
					Если Серия.Имя = "Группировка" Тогда
						ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Серия, Отчет.Группировка);
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Для Каждого Точка Из ЭлементСтруктуры.Точки Цикл
					Если Точка.Имя = "Группировка" Тогда
						ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Точка, Отчет.Группировка);
						Прервать;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ТаблицаКомпоновкиДанных") Тогда
				Для Каждого Колонка Из ЭлементСтруктуры.Колонки Цикл
					Если Колонка.Имя = "Группировка" Тогда
						ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Колонка, Отчет.Группировка);
						Прервать;
					КонецЕсли;
				КонецЦикла;
				Для Каждого Строка Из ЭлементСтруктуры.Строки Цикл
					Если Строка.Имя = "Группировка" Тогда
						ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, Строка, Отчет.Группировка);
						Прервать;
					КонецЕсли;
				КонецЦикла;
			ИначеЕсли ТипЗнч(ЭлементСтруктуры) = Тип("ГруппировкаКомпоновкиДанных") Тогда
				Если ЭлементСтруктуры.Имя = "Группировка" Тогда
					Отчет.Группировка.Очистить();
					ЗаполнитьГруппировкиИзНастроек(Отчет.КомпоновщикНастроек, ЭлементСтруктуры, Отчет.Группировка);
					Прервать;
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
//	Если Отчет.Свойство("РазмещениеДополнительныхПолей") Тогда
//		Отчет.РазмещениеДополнительныхПолей = ПолучитьРазмещениеДополнительныхПолей(Отчет.КомпоновщикНастроек);
//	КонецЕсли;
//	
//	Если Отчет.Свойство("Группировка") И Отчет.Свойство("ДополнительныеПоля") Тогда
//		ЗаполнитьДополнительныеПоляИзНастроек(Отчет.КомпоновщикНастроек, Отчет.ДополнительныеПоля, Отчет.Группировка);
//	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьГруппировкиИзНастроек(КомпоновщикНастроек, Структура, Группировка)
	
	Если Структура.ПоляГруппировки.Элементы.Количество() > 0 Тогда
		Поле = Строка(Структура.ПоляГруппировки.Элементы[0].Поле);
		
		НоваяСтрока = Группировка.Добавить();
		
		НоваяСтрока.Использование  = Структура.Использование;
		НоваяСтрока.Поле           = Поле;
		НоваяСтрока.Представление  = ПолучитьСвойствоПоля(КомпоновщикНастроек, НоваяСтрока.Поле);
		Если Не ЗначениеЗаполнено(НоваяСтрока.Представление) Тогда
			НоваяСтрока.Представление = Поле;
		КонецЕсли;
		
		ТипГруппировки = Структура.ПоляГруппировки.Элементы[0].ТипГруппировки;
		Если ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Иерархия Тогда
			НоваяСтрока.ТипГруппировки = 1;
		ИначеЕсли ТипГруппировки = ТипГруппировкиКомпоновкиДанных.ТолькоИерархия Тогда
			НоваяСтрока.ТипГруппировки = 2;
		Иначе
			НоваяСтрока.ТипГруппировки = 0;
		КонецЕсли;
			
		Если Структура.Структура.Количество() > 0 Тогда
			ЗаполнитьГруппировкиИзНастроек(КомпоновщикНастроек, Структура.Структура[0], Группировка);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Возвращает значение указанного свойства поля структуры.
//
// Параметры:
//	ЭлементСтруктура - КомпоновщикНастроекКомпоновкиДанных, Произвольный - Структура, в которой хранится поле.
//	Поле - Произвольный - Поле, для которого определяется значение свойства.
//	Свойство - Строка - Имя свойства, значение которого требуется получить.
//
// Возвращаемое значение:
//	Произвольный - Значение запрашиваемого свойства поля либо Неопределено.
//
Функция ПолучитьСвойствоПоля(ЭлементСтруктура, Поле, Свойство = "Заголовок") Экспорт
	
	Если ТипЗнч(ЭлементСтруктура) = Тип("КомпоновщикНастроекКомпоновкиДанных") Тогда
		Коллекция = ЭлементСтруктура.Настройки.ДоступныеПоляВыбора;
	Иначе
		Коллекция = ЭлементСтруктура;
	КонецЕсли;
	
	ПолеСтрокой = Строка(Поле);
	ПозицияКвадратнойСкобки = СтрНайти(ПолеСтрокой, "[");
	Окончание = "";
	Заголовок = "";
	Если ПозицияКвадратнойСкобки > 0 Тогда
		Окончание = Сред(ПолеСтрокой, ПозицияКвадратнойСкобки);
		ПолеСтрокой = Лев(ПолеСтрокой, ПозицияКвадратнойСкобки - 2);
	КонецЕсли;
	
	МассивСтрок = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолеСтрокой, ".");
	
	Если Не ПустаяСтрока(Окончание) Тогда
		МассивСтрок.Добавить(Окончание);
	КонецЕсли;
	
	ДоступныеПоля = Коллекция.Элементы;
	ПолеПоиска = "";
	Для Индекс = 0 По МассивСтрок.Количество() - 1 Цикл
		ПолеПоиска = ПолеПоиска + ?(Индекс = 0, "", ".") + МассивСтрок[Индекс];
		ДоступноеПоле = ДоступныеПоля.Найти(ПолеПоиска);
		Если ДоступноеПоле <> Неопределено Тогда
			ДоступныеПоля = ДоступноеПоле.Элементы;
		КонецЕсли;
	КонецЦикла;
	
	Если ДоступноеПоле <> Неопределено Тогда
		Если Свойство = "ДоступноеПоле" Тогда
			Результат = ДоступноеПоле;
		Иначе
			Результат = ДоступноеПоле[Свойство]; 
		КонецЕсли;
	Иначе
		Результат = Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
