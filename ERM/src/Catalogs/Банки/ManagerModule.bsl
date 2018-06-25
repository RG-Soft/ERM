#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Функция получает таблицу ссылок на банки по Коду или корреспондетскому счету.
//
// Параметры:
//	Поле - Строка - Имя поля (Код или КоррСчет)
//	Значение - Строка - Значение Код или Корреспондентского счета
//	Валютный - Булево - Банковский счет является Валютным. По умолчанию - Ложь
//	ТаможенныйСоюз - Булево - Владелец банковского счета резидент таможенного союза. По умолчанию - Ложь
//
// Возвращаемое значение:
//	ТаблицаЗначений - Найденые банки
//
Функция ПолучитьТаблицуБанковПоРеквизитам(Поле, Значение, Валютный = Ложь, ТаможенныйСоюз = Ложь) Экспорт
	
	ТаблицаБанков = Новый ТаблицаЗначений;
	Колонки = ТаблицаБанков.Колонки;
	Колонки.Добавить("Ссылка");
	Колонки.Добавить("Код");
	Колонки.Добавить("КоррСчет");
	Колонки.Добавить("Наименование");

	ЭтоКод = Ложь;
	ЭтоКоррСчет = Ложь;
	Если СтрНайти(Поле, "Код") <> 0 Тогда
		ЭтоКод = Истина;
	ИначеЕсли СтрНайти(Поле, "КоррСчет") <> 0 Тогда
		ЭтоКоррСчет = Истина;
	КонецЕсли;
	
	Если ЭтоКод И (СтрДлина(Значение) = 9 ИЛИ Валютный ИЛИ ТаможенныйСоюз)
		ИЛИ ЭтоКоррСчет И (СтрДлина(Значение) = 20 ИЛИ Валютный ИЛИ ТаможенныйСоюз) Тогда
		
		Если ЭтоКод Тогда
			СтруктураОтбора = Новый Структура("Код", Значение, Ложь);
		ИначеЕсли ЭтоКоррСчет Тогда
			СтруктураОтбора = Новый Структура("КоррСчет", Значение, Ложь);
		КонецЕсли;
		
		Выборка = Справочники.Банки.Выбрать(,, СтруктураОтбора, "Код Возр");
		Пока Выборка.Следующий() Цикл
			Если НЕ Выборка.ЭтоГруппа Тогда
				НоваяСтрока = ТаблицаБанков.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
			КонецЕсли;
		КонецЦикла;
		
		Если ТаблицаБанков.Количество() = 0 И НЕ (Валютный ИЛИ ТаможенныйСоюз) Тогда
			ДобавитьБанкиИзКлассификатора(
				?(ЭтоКод, Значение, ""), // Код
				?(ЭтоКоррСчет, Значение, ""), // КоррСчет
				ТаблицаБанков
			);
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТаблицаБанков;
	
КонецФункции

Функция СсылкаНаБанк(БИК, ЭтоРегион = Ложь) Экспорт
	
	Если ПустаяСтрока(БИК) Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.Ссылка
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Код = &БИК
	|	И Банки.ЭтоГруппа = &ЭтоГруппа";
	
	Запрос.УстановитьПараметр("БИК",       БИК);
	Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоРегион);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

Функция СсылкаНаБанкПоСВИФТБИК(СВИФТБИК) Экспорт
	
	Если ПустаяСтрока(СВИФТБИК) Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.Ссылка
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.СВИФТБИК = &СВИФТБИК
	|	И НЕ Банки.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("СВИФТБИК", СВИФТБИК);
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.Банки.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

Процедура ОбновитьБанкиИзКлассификатора(СтруктураПараметров, АдресХранилища) Экспорт
	
	МассивБанков        = Новый Массив();
	ДанныеДляЗаполнения = Новый Структура();
	
	УспешноОбновлены = РаботаСБанкамиБП.ОбновитьБанкиИзКлассификатора(,
		ОбщегоНазначения.ЗначениеРазделителяСеанса());
	
	ДанныеДляЗаполнения.Вставить("УспешноОбновлены",   УспешноОбновлены);
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция СтранаПоSWIFT(СВИФТБИК) Экспорт
	
	КодСтраны = БанковскиеПравила.КодСтраныSWIFT(СВИФТБИК);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КодАльфа2", КодСтраны);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СтраныМира.Ссылка
	|ИЗ
	|	Справочник.СтраныМира КАК СтраныМира
	|ГДЕ
	|	СтраныМира.КодАльфа2 = &КодАльфа2";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		ВсеСтраны = Справочники.СтраныМира.ТаблицаКлассификатора();
		ВсеСтраны.Индексы.Добавить("КодАльфа2");
		ОписаниеСтраны = ВсеСтраны.Найти(КодСтраны);
		Если ОписаниеСтраны <> Неопределено Тогда
			Страна = Справочники.СтраныМира.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(Страна, ОписаниеСтраны);
			Страна.Записать();
			
			Возврат Страна.Ссылка;
		Иначе
			Возврат Справочники.СтраныМира.Россия;
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция формирует результат запроса по классификатору банков
// с отбором по Код, корреспондентскому счету, наименованию или городу.
//
// Параметры:
//	Код - Строка (9) - Код банка
//	КорСчет - Строка (20) - Корреспондентский счет банка
//
// Возвращаемое значение:
//	РезультатЗапроса - Результат запроса по классификатору.
//
Функция ПолучитьРезультатЗапросаПоКлассификатору(Код, КоррСчет)
	
	Если ПустаяСтрока(Код) И ПустаяСтрока(КоррСчет) Тогда
		Запрос = Новый Запрос;
		Возврат Запрос.Выполнить().Выбрать();
	КонецЕсли;
	
	ПостроительЗапроса = Новый ПостроительЗапроса;
	ПостроительЗапроса.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлассификаторБанков.Код КАК Код,
	|	КлассификаторБанков.Наименование,
	|	КлассификаторБанков.КоррСчет,
	|	КлассификаторБанков.Город,
	|	КлассификаторБанков.Адрес,
	|	КлассификаторБанков.Ссылка
	|ИЗ
	|	Справочник.КлассификаторБанков КАК КлассификаторБанков
	|ГДЕ
	|	НЕ КлассификаторБанков.ЭтоГруппа
	|{ГДЕ
	|	КлассификаторБанков.Код,
	|	КлассификаторБанков.КоррСчет}
	|{УПОРЯДОЧИТЬ ПО
	|	Наименование}";
	
	Отбор = ПостроительЗапроса.Отбор;
	
	Если ЗначениеЗаполнено(Код) Тогда
		Отбор.Добавить("Код");
		Отбор.Код.Значение = СокрЛП(Код);
		Отбор.Код.ВидСравнения = ВидСравнения.Содержит;
		Отбор.Код.Использование = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КоррСчет) Тогда
		Отбор.Добавить("КоррСчет");
		Отбор.КоррСчет.Значение = СокрЛП(КоррСчет);
		Отбор.КоррСчет.ВидСравнения = ВидСравнения.Содержит;
		Отбор.КоррСчет.Использование = ЗначениеЗаполнено(КоррСчет);
	КонецЕсли;
	
	Порядок = ПостроительЗапроса.Порядок;
	Порядок.Добавить("Наименование");
	
	ПостроительЗапроса.Выполнить();
	РезультатЗапроса = ПостроительЗапроса.Результат;
	
	Возврат РезультатЗапроса;
	
КонецФункции

// Процедура добавляет новый банк из классификатора
// по значению Код или корреспондентскому счету.
//
// Параметры:
//	Код - Строка (9) - Код банка
//	КоррСчет - Строка (20) - Корреспондентский счет банка
//	ТаблицаБанков - ТаблицаЗначений - Таблица банков
//
Процедура ДобавитьБанкиИзКлассификатора(Код, КоррСчет, ТаблицаБанков)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РезультатЗапроса = ПолучитьРезультатЗапросаПоКлассификатору(Код, КоррСчет);
	
	МассивБанковИзКлассификатора = Новый Массив;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивБанковИзКлассификатора.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	Если МассивБанковИзКлассификатора.Количество() > 0 Тогда
		МассивБанков = РаботаСБанкамиБП.ПодобратьБанкИзКлассификатора(МассивБанковИзКлассификатора);
	Иначе
		Возврат;
	КонецЕсли;
	
	БанкНайден = Ложь;
	Для каждого НайденныйБанк Из МассивБанков Цикл
		ИскатьПоКоду      = ЗначениеЗаполнено(Код);
		ИскатьПоКоррСчету = ЗначениеЗаполнено(КоррСчет) И НЕ НайденныйБанк.ЭтоГруппа;
		
		Если ИскатьПоКоду И ИскатьПоКоррСчету
			И НайденныйБанк.Код = Код И НайденныйБанк.КоррСчет = КоррСчет Тогда
			БанкНайден = Истина;
		ИначеЕсли ИскатьПоКоду И НайденныйБанк.Код = Код Тогда
			БанкНайден = Истина;
		ИначеЕсли ИскатьПоКоррСчету И НайденныйБанк.КоррСчет = КоррСчет Тогда
			БанкНайден = Истина;
		КонецЕсли;
		
		Если БанкНайден Тогда
			НоваяСтрока = ТаблицаБанков.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, НайденныйБанк);
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Поля.Добавить("Код");
	Поля.Добавить("Наименование");
	Поля.Добавить("СВИФТБИК");
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если БанковскиеПравила.ЭтоБИКБанкаРФ(Данные.Код) Тогда
		Представление = СокрЛП(Данные.Код) + " " + СокрЛП(Данные.Наименование);
	Иначе
		КодЗарубежногоБанка = " " + ?(ПустаяСтрока(Данные.СВИФТБИК), Данные.Код, Данные.СВИФТБИК); 
		Представление = СокрЛП(КодЗарубежногоБанка) + " " + СокрЛП(Данные.Наименование);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиОбновления

Процедура УстановитьСтрануВБанках() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Страна = &ПустаяСтрана
	|	И НЕ Банки.ЭтоГруппа";
	
	Запрос.УстановитьПараметр("ПустаяСтрана", Справочники.СтраныМира.ПустаяСсылка());
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	СтранаРФ = Справочники.СтраныМира.Россия;
	Пока Выборка.Следующий() Цикл
		
		ВыбранныйБанк = Выборка.Ссылка.ПолучитьОбъект();
		ВыбранныйБанк.Страна = СтранаРФ;
		
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(ВыбранныйБанк);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
