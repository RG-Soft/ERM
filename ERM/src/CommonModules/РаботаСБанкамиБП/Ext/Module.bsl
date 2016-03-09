﻿#Область ПрограммныйИнтерфейс

// Обновим банки из классификатора, а также установим их текущее состояние (реквизит РучноеИзменение).
// Связь ищем по БИК и Коррсчету (только для элементов).
// Обновление производим только для элементов, у которых любой из реквизитов не совпадает с аналогичным в классификаторе
//
// Параметры:
//
//  - СписокБанков - Массив - элементов с типом СправочникСсылка.КлассификаторБанковРФ - список банков для обновления,
//                            если список банков пуст, то необходимо проверить все элементы и обновить "измененные
//
//  - ОбластьДанных - Число(1, 0) - область данных, для которой необходимо выполнить обновление
//                                  для локального режима = 0, если область данных не передана, обновление не выполняем
//
Функция ОбновитьБанкиИзКлассификатора(Знач СписокБанков = Неопределено, Знач ОбластьДанных) Экспорт
	
	ОбластьОбработана  = Истина;
	Если ОбластьДанных = Неопределено Тогда
		Возврат ОбластьОбработана;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.Код КАК Код,
	|	КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	КлассификаторБанковРФ.Наименование КАК Наименование,
	|	КлассификаторБанковРФ.Город,
	|	КлассификаторБанковРФ.Адрес,
	|	КлассификаторБанковРФ.Телефоны,
	|	КлассификаторБанковРФ.ЭтоГруппа КАК ЭтоГруппа,
	|	КлассификаторБанковРФ.Родитель.Код,
	|	КлассификаторБанковРФ.Родитель.Наименование,
	|	КлассификаторБанковРФ.ДеятельностьПрекращена,
	|	КлассификаторБанковРФ.СВИФТБИК
	|ПОМЕСТИТЬ ВТ_ИзмененныеБанки
	|ИЗ
	|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Ссылка В(&СписокБанков)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	Код,
	|	КоррСчет,
	|	Наименование,
	|	ЭтоГруппа
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВложенныйЗапросБанки.Банк КАК Банк,
	|	ВложенныйЗапросБанки.Код КАК Код,
	|	ВложенныйЗапросБанки.КоррСчет КАК КоррСчет,
	|	ВложенныйЗапросБанки.Наименование КАК Наименование,
	|	ВложенныйЗапросБанки.Город КАК Город,
	|	ВложенныйЗапросБанки.Адрес КАК Адрес,
	|	ВложенныйЗапросБанки.Телефоны КАК Телефоны,
	|	ВложенныйЗапросБанки.ЭтоГруппа КАК ЭтоГруппа,
	|	ВложенныйЗапросБанки.РодительКод КАК РодительКод,
	|	ВложенныйЗапросБанки.РодительНаименование КАК РодительНаименование,
	|	ВложенныйЗапросБанки.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|	ВложенныйЗапросБанки.СВИФТБИК
	|ПОМЕСТИТЬ ВТ_ИзмененныеЭлементы
	|ИЗ
	|	(ВЫБРАТЬ
	|		Банки.Ссылка КАК Банк,
	|		ВТ_ИзмененныеБанки.Код КАК Код,
	|		ВТ_ИзмененныеБанки.КоррСчет КАК КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование КАК Наименование,
	|		ВТ_ИзмененныеБанки.Город КАК Город,
	|		ВТ_ИзмененныеБанки.Адрес КАК Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны КАК Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа КАК ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод КАК РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование КАК РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК КАК СВИФТБИК
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Наименование <> ВТ_ИзмененныеБанки.Наименование
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Город <> ВТ_ИзмененныеБанки.Город
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Адрес <> ВТ_ИзмененныеБанки.Адрес
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Телефоны <> ВТ_ИзмененныеБанки.Телефоны
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.Родитель.Код <> ВТ_ИзмененныеБанки.РодительКод
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И Банки.СВИФТБИК <> ВТ_ИзмененныеБанки.СВИФТБИК
	|				И (Банки.РучноеИзменение = 0)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		Банки.Ссылка,
	|		ВТ_ИзмененныеБанки.Код,
	|		ВТ_ИзмененныеБанки.КоррСчет,
	|		ВТ_ИзмененныеБанки.Наименование,
	|		ВТ_ИзмененныеБанки.Город,
	|		ВТ_ИзмененныеБанки.Адрес,
	|		ВТ_ИзмененныеБанки.Телефоны,
	|		ВТ_ИзмененныеБанки.ЭтоГруппа,
	|		ВТ_ИзмененныеБанки.РодительКод,
	|		ВТ_ИзмененныеБанки.РодительНаименование,
	|		ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|		ВТ_ИзмененныеБанки.СВИФТБИК
	|	ИЗ
	|		Справочник.Банки КАК Банки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|			ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|				И Банки.КоррСчет = ВТ_ИзмененныеБанки.КоррСчет
	|				И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|				И (Банки.РучноеИзменение = 2)
	|	ГДЕ
	|		НЕ Банки.ЭтоГруппа) КАК ВложенныйЗапросБанки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИзмененныеЭлементы.Банк КАК Банк,
	|	ВТ_ИзмененныеЭлементы.Код КАК Код,
	|	ВТ_ИзмененныеЭлементы.КоррСчет КАК КоррСчет,
	|	ВТ_ИзмененныеЭлементы.Наименование КАК Наименование,
	|	ВТ_ИзмененныеЭлементы.Город КАК Город,
	|	ВТ_ИзмененныеЭлементы.Адрес КАК Адрес,
	|	ВТ_ИзмененныеЭлементы.Телефоны КАК Телефоны,
	|	ВТ_ИзмененныеЭлементы.ЭтоГруппа КАК ЭтоГруппа,
	|	0 КАК РучноеИзменение,
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Родитель,
	|	ВТ_ИзмененныеЭлементы.РодительКод КАК РодительКод,
	|	ВТ_ИзмененныеЭлементы.РодительНаименование КАК РодительНаименование,
	|	ВТ_ИзмененныеЭлементы.ДеятельностьПрекращена КАК ДеятельностьПрекращена,
	|	ВТ_ИзмененныеЭлементы.СВИФТБИК
	|ИЗ
	|	ВТ_ИзмененныеЭлементы КАК ВТ_ИзмененныеЭлементы
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_ИзмененныеЭлементы.РодительКод = Банки.Код
	|			И (Банки.ЭтоГруппа)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка,
	|	ВТ_ИзмененныеБанки.Код,
	|	NULL,
	|	ВТ_ИзмененныеБанки.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ЭтоГруппа,
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|	NULL
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|		ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|			И Банки.Наименование <> ВТ_ИзмененныеБанки.Наименование
	|			И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|			И (Банки.РучноеИзменение = 0)
	|ГДЕ
	|	ВТ_ИзмененныеБанки.ЭтоГруппа
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка,
	|	ВТ_ИзмененныеБанки.Код,
	|	NULL,
	|	ВТ_ИзмененныеБанки.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ЭтоГруппа,
	|	0,
	|	NULL,
	|	NULL,
	|	NULL,
	|	ВТ_ИзмененныеБанки.ДеятельностьПрекращена,
	|	NULL
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИзмененныеБанки КАК ВТ_ИзмененныеБанки
	|		ПО Банки.Код = ВТ_ИзмененныеБанки.Код
	|			И Банки.ЭтоГруппа = ВТ_ИзмененныеБанки.ЭтоГруппа
	|			И (Банки.РучноеИзменение = 2)
	|ГДЕ
	|	ВТ_ИзмененныеБанки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоГруппа УБЫВ";
	
	Если СписокБанков = Неопределено ИЛИ СписокБанков.Количество() = 0 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "
			|ГДЕ
			|	КлассификаторБанковРФ.Ссылка В(&СписокБанков)", "");
	Иначе
		Запрос.УстановитьПараметр("СписокБанков",  СписокБанков);
	КонецЕсли;
	
	Запрос.Текст  = ТекстЗапроса;
	ВыборкаБанков = Запрос.Выполнить().Выбрать();
	
	ИсключаяСвойстваДляЭлемента = "ЭтоГруппа";
	ИсключаяСвойстваДляГруппы   = "Адрес, Город, КоррСчет, Телефоны, Родитель, ЭтоГруппа";
	
	Пока ВыборкаБанков.Следующий() Цикл
		
		Банк = ВыборкаБанков.Банк.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(Банк, ВыборкаБанков,,
			?(ВыборкаБанков.ЭтоГруппа, ИсключаяСвойстваДляГруппы, ИсключаяСвойстваДляЭлемента));
		
		Если НЕ ВыборкаБанков.ЭтоГруппа И НЕ ЗначениеЗаполнено(ВыборкаБанков.Родитель) И НЕ ПустаяСтрока(ВыборкаБанков.РодительКод) Тогда
			Родитель = Справочники.Банки.СсылкаНаБанк(ВыборкаБанков.РодительКод, Истина);
			Если НЕ ЗначениеЗаполнено(Родитель) Тогда
				Родитель = Справочники.Банки.СоздатьГруппу();
				Родитель.Код          = ВыборкаБанков.РодительКод;
				Родитель.Наименование = ВыборкаБанков.РодительНаименование;
				
				Попытка
					Родитель.Записать();
				Исключение
					ШаблонСообщения   = НСтр("ru = 'Не удалось записать группу (регион) %1.
                                              |%2'");
					ТекстСообщения    = СтрШаблон(
						ШаблонСообщения,
						ВыборкаБанков.РодительНаименование,
						ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
						
					ЗаписьЖурналаРегистрации(
						ИмяСобытияВЖурналеРегистрации(), 
						УровеньЖурналаРегистрации.Ошибка,
						Метаданные.Справочники.Банки,
						ВыборкаБанков.Банк, 
						ТекстСообщения);
					
					ОбластьОбработана = Ложь;
					Прервать;
				КонецПопытки
			КонецЕсли;
			
			Банк.Родитель = Родитель.Ссылка;
		КонецЕсли;
		
		Попытка
			Банк.Записать();
		Исключение
			ШаблонСообщения   = НСтр("ru = 'Не удалось записать элемент.
                                      |%1'");
			ТекстСообщения    = СтрШаблон(
				ШаблонСообщения,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
				
			ЗаписьЖурналаРегистрации(
				ИмяСобытияВЖурналеРегистрации(),
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Банки,
				ВыборкаБанков.Банк,
				ТекстСообщения);
			
			ОбластьОбработана = Ложь;
		КонецПопытки;
		
	КонецЦикла;
	
	Если НЕ ОбластьОбработана Тогда
		Возврат ОбластьОбработана;
	КонецЕсли;
	
	// Найдем банки которые потеряли связь с классификатором
	// и установим им соотвествующий признак
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.Ссылка КАК Банк,
	|	2 КАК РучноеИзменение
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|		ПО Банки.Код = КлассификаторБанковРФ.Код
	|			И (Банки.ЭтоГруппа
	|				ИЛИ Банки.КоррСчет = КлассификаторБанковРФ.КоррСчет)
	|ГДЕ
	|	КлассификаторБанковРФ.Ссылка ЕСТЬ NULL 
	|	И Банки.РучноеИзменение <> 2
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	Банки.Ссылка,
	|	3
	|ИЗ
	|	Справочник.Банки КАК Банки
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|		ПО Банки.Код = КлассификаторБанковРФ.Код
	|			И (Банки.ЭтоГруппа
	|				ИЛИ Банки.КоррСчет = КлассификаторБанковРФ.КоррСчет)
	|ГДЕ
	|	КлассификаторБанковРФ.ДеятельностьПрекращена
	|	И Банки.РучноеИзменение < 2";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Банк = Выборка.Банк.ПолучитьОбъект();
		Банк.РучноеИзменение = Выборка.РучноеИзменение;
		
		Попытка
			Банк.Записать();
		Исключение
			ОбластьОбработана = Ложь;
			
			ШаблонСообщения   = НСтр("ru = 'Не удалось записать элемент.
				|%1'");
			ТекстСообщения    = СтрШаблон(ШаблонСообщения,
				ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ЗаписьЖурналаРегистрации(
				ИмяСобытияВЖурналеРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Банки,
				Выборка.Банк, 
				ТекстСообщения);
		КонецПопытки;
		
	КонецЦикла;
	
	Возврат ОбластьОбработана;
	
КонецФункции

// Функция осуществляет подбор данных классификатора, для копирования в элемент справочника Банки.
// Если такого банка ещё нет, то он создается.
// Если банк находится в иерархии не на первом уровне, то создается/копируется вся цепочка родителей.
//
// Параметры:
//
// - СсылкиБанков - Массив с элементами типа СправочникСсылка.КлассификаторБанковРФ - список значений классификатора
//   которые необходимо обработать
// - ИгнорироватьРучноеИзменение - Булево - указание не обрабатывать банки, измененные вручную
//
// Возвращаемое значение:
//
// - Массив с элементами типа СправочникСсылка.Банки
//
Функция ПодобратьБанкИзКлассификатора(Знач СсылкиБанков, ИгнорироватьРучноеИзменение = Ложь) Экспорт
	
	МассивБанков = Новый Массив;
	
	Если СсылкиБанков.Количество() = 0 Тогда
		Возврат МассивБанков;
	КонецЕсли;
	
	СсылкиИерархия = ДополнитьМассивРодителямиСсылок(СсылкиБанков);
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СсылкиИерархия", СсылкиИерархия);
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.Код КАК БИК,
	|	КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	КлассификаторБанковРФ.Наименование,
	|	КлассификаторБанковРФ.Город,
	|	КлассификаторБанковРФ.Адрес,
	|	КлассификаторБанковРФ.Телефоны,
	|	КлассификаторБанковРФ.ЭтоГруппа,
	|	КлассификаторБанковРФ.ДеятельностьПрекращена,
	|	КлассификаторБанковРФ.Родитель.Код,
	|	КлассификаторБанковРФ.СВИФТБИК
	|ПОМЕСТИТЬ ВТ_КлассификаторБанковРФ
	|ИЗ
	|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Ссылка В(&СсылкиИерархия)
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	БИК,
	|	КоррСчет
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Банк,
	|	ВТ_КлассификаторБанковРФ.БИК КАК Код,
	|	ВТ_КлассификаторБанковРФ.КоррСчет КАК КоррСчет,
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа КАК ЭтоРегион,
	|	ВТ_КлассификаторБанковРФ.Наименование,
	|	ВТ_КлассификаторБанковРФ.Город,
	|	ВТ_КлассификаторБанковРФ.Адрес,
	|	ВТ_КлассификаторБанковРФ.Телефоны,
	|	ВТ_КлассификаторБанковРФ.СВИФТБИК,
	|	ВЫБОР
	|		КОГДА ВТ_КлассификаторБанковРФ.ДеятельностьПрекращена
	|			ТОГДА 3
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК РучноеИзменение,
	|	ЕСТЬNULL(ВТ_КлассификаторБанковРФ.РодительКод, """") КАК РодительКод
	|ПОМЕСТИТЬ БанкиБезРодителей
	|ИЗ
	|	ВТ_КлассификаторБанковРФ КАК ВТ_КлассификаторБанковРФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_КлассификаторБанковРФ.КоррСчет = Банки.КоррСчет
	|			И ВТ_КлассификаторБанковРФ.БИК = Банки.Код
	|			И ВТ_КлассификаторБанковРФ.ЭтоГруппа = Банки.ЭтоГруппа
	|ГДЕ
	|	НЕ ВТ_КлассификаторБанковРФ.ЭтоГруппа
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)),
	|	ВТ_КлассификаторБанковРФ.БИК,
	|	NULL,
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа,
	|	ВТ_КлассификаторБанковРФ.Наименование,
	|	NULL,
	|	NULL,
	|	NULL,
	|	NULL,
	|	0,
	|	ЕСТЬNULL(ВТ_КлассификаторБанковРФ.РодительКод, """")
	|ИЗ
	|	ВТ_КлассификаторБанковРФ КАК ВТ_КлассификаторБанковРФ
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО ВТ_КлассификаторБанковРФ.БИК = Банки.Код
	|			И ВТ_КлассификаторБанковРФ.ЭтоГруппа = Банки.ЭтоГруппа
	|ГДЕ
	|	ВТ_КлассификаторБанковРФ.ЭтоГруппа
	|
	|ИНДЕКСИРОВАТЬ ПО
	|	РодительКод
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	БанкиБезРодителей.Банк,
	|	БанкиБезРодителей.Код КАК Код,
	|	БанкиБезРодителей.КоррСчет,
	|	БанкиБезРодителей.ЭтоРегион КАК ЭтоРегион,
	|	БанкиБезРодителей.Наименование,
	|	БанкиБезРодителей.Город,
	|	БанкиБезРодителей.Адрес,
	|	БанкиБезРодителей.Телефоны,
	|	БанкиБезРодителей.РучноеИзменение,
	|	БанкиБезРодителей.РодительКод,
	|	ЕСТЬNULL(Банки.Ссылка, ЗНАЧЕНИЕ(Справочник.Банки.ПустаяСсылка)) КАК Родитель,
	|	БанкиБезРодителей.СВИФТБИК
	|ИЗ
	|	БанкиБезРодителей КАК БанкиБезРодителей
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Банки КАК Банки
	|		ПО БанкиБезРодителей.РодительКод = Банки.Родитель
	|			И БанкиБезРодителей.ЭтоРегион = Банки.ЭтоГруппа
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭтоРегион УБЫВ,
	|	Код";
	
	УстановитьПривилегированныйРежим(Истина);
	ТаблицаБанков = Запрос.Выполнить().Выгрузить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Ссылки = Новый Массив;
	Для каждого СтрокаТаблицыЗначений Из ТаблицаБанков Цикл
		
		ПараметрыОбъекта = ОбщегоНазначения.СтрокаТаблицыЗначенийВСтруктуру(СтрокаТаблицыЗначений);
		УдалитьНеВалидныеКлючиСтруктуры(ПараметрыОбъекта);
		Ссылки.Добавить(ПараметрыОбъекта);
		
	КонецЦикла;
	
	МассивБанков = СоздатьОбновитьБанкиВИБ(Ссылки, ИгнорироватьРучноеИзменение);
	
	Возврат МассивБанков;
	
КонецФункции

// Загружает классификатор банков в модели сервиса из поставляемых данных.
//
// Параметры:
//   ПутьКФайлу - Строка - путь к файлу bnk.zip, полученному из поставляемых данных
//
Функция ЗагрузитьПоставляемыйКлассификаторБанков(ПутьКФайлу) Экспорт
	
	Возврат РаботаСБанками.ЗагрузитьДанныеИзФайлаРБК(ПутьКФайлу);
	
КонецФункции

Функция СсылкаПоКлассификатору(БИК, Коррсчет = "", ЭтоРегион = Ложь) Экспорт
	
	Если ПустаяСтрока(БИК) Тогда
		Возврат Справочники.КлассификаторБанковРФ.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	КлассификаторБанковРФ.Ссылка
	|ИЗ
	|	Справочник.КлассификаторБанковРФ КАК КлассификаторБанковРФ
	|ГДЕ
	|	КлассификаторБанковРФ.Код = &БИК
	|	И КлассификаторБанковРФ.ЭтоГруппа = &ЭтоГруппа
	|	И КлассификаторБанковРФ.КоррСчет = &Коррсчет";
	
	Запрос.УстановитьПараметр("БИК", БИК);
	
	Если ЭтоРегион Тогда
		Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоРегион);
	Иначе
		Если ПустаяСтрока(Коррсчет) Тогда
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И КлассификаторБанковРФ.ЭтоГруппа = &ЭтоГруппа", "");
		Иначе
			Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоРегион);
		КонецЕсли;
	КонецЕсли;
	
	Если ПустаяСтрока(Коррсчет) Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "И КлассификаторБанковРФ.КоррСчет = &Коррсчет", "");
	Иначе
		Запрос.УстановитьПараметр("Коррсчет", Коррсчет);
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапроса;
	
	УстановитьПривилегированныйРежим(Истина);
	Результат = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если Результат.Пустой() Тогда
		Возврат Справочники.КлассификаторБанковРФ.ПустаяСсылка();
	КонецЕсли;
	
	Возврат Результат.Выгрузить()[0].Ссылка;
	
КонецФункции

// Считывает текущее состояние объекта и приводит форму в соответстие с ним.
//
Процедура СчитатьФлагРучногоИзменения(Форма, Знач МожноРедактировать) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Банки.РучноеИзменение КАК РучноеИзменение
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	Банки.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Форма.Объект.Ссылка);
	
	УстановитьПривилегированныйРежим(Истина);
	РезультатЗапроса = Запрос.Выполнить();
	УстановитьПривилегированныйРежим(Ложь);
	
	Если РезультатЗапроса.Пустой() Тогда
		
		Форма.РучноеИзменение = Неопределено;
		
	Иначе
		
		Выборка = РезультатЗапроса.Выбрать();
		Выборка.Следующий();
		
		Если Выборка.РучноеИзменение = 2 Тогда
			Форма.РучноеИзменение = Неопределено;
		ИначеЕсли Выборка.РучноеИзменение = 1 Тогда
			Форма.РучноеИзменение = Истина;
		Иначе
			Форма.РучноеИзменение = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Форма.РучноеИзменение <> Неопределено Тогда
		СсылкаНаКлассификатор = СсылкаПоКлассификатору(Форма.Объект.Код);
		Если ЗначениеЗаполнено(СсылкаНаКлассификатор) Тогда
			Форма.ДеятельностьПрекращена = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СсылкаНаКлассификатор, "ДеятельностьПрекращена");
		КонецЕсли;
	КонецЕсли;
	
	ОбработатьФлагРучногоИзменения(Форма, МожноРедактировать);
	
КонецПроцедуры

// Восстановление данных из общего объекта и изменяет состояние объекта.
//
Процедура ВосстановитьЭлементИзОбщихДанных(Знач Форма) Экспорт
	
	Объект = Форма.Объект;
	
	НачатьТранзакцию();
	Попытка
		Ссылки = Новый Массив;
		Классификатор = СсылкаПоКлассификатору(Объект.Код, СокрЛП(Объект.КоррСчет));
		
		Если НЕ ЗначениеЗаполнено(Классификатор) Тогда
			Возврат;
		КонецЕсли;
		
		Ссылки.Добавить(Классификатор);
		ПодобратьБанкИзКлассификатора(Ссылки, Истина);
		
		ДеятельностьПрекращена = Ложь;
		СсылкаНаКлассификатор  = СсылкаПоКлассификатору(Объект.Код);
		Если ЗначениеЗаполнено(СсылкаНаКлассификатор) Тогда
			СвойстваБанка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Классификатор, "ДеятельностьПрекращена, ЭтоГруппа");
			ДеятельностьПрекращена = НЕ СвойстваБанка.ЭтоГруппа И СвойстваБанка.ДеятельностьПрекращена;
		КонецЕсли;
		
		Форма.ДеятельностьПрекращена = ДеятельностьПрекращена;
		Если ДеятельностьПрекращена Тогда
			Форма.РучноеИзменение = Неопределено;
		Иначе
			Форма.РучноеИзменение = Ложь;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		
		ШаблонСообщения = НСтр("ru = 'Не удалось восстановить из общих данных
                                |%1'");
		
		ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ЗаписьЖурналаРегистрации(
			ИмяСобытияВЖурналеРегистрации(), 
			УровеньЖурналаРегистрации.Ошибка,,, ТекстСообщения);
		
		ВызватьИсключение;
	КонецПопытки;
	
	Форма.Прочитать();
	
КонецПроцедуры

// Копирует банки во все ОД.
//
// Параметры
//  ТаблицаБанков - ТаблицаЗначений с банками
//  ОбластиДляОбновления - Массив со списком кодов областей
//  ИдентификаторФайла - УникальныйИдентификатор файла обрабатываемых банков
//  КодОбработчика - Строка, код обработчика
//
Процедура РаспространитьБанкиПоОД(Знач СписокБанков, Знач ИдентификаторФайла, Знач КодОбработчика) Экспорт
	
	//ОбластиДляОбновления  = ПоставляемыеДанные.ОбластиТребующиеОбработки(
	//	ИдентификаторФайла, "БанкиРФ");
	//
	//Для каждого ОбластьДанных Из ОбластиДляОбновления Цикл
	//	ОбластьОбработана = Ложь;
	//	УстановитьПривилегированныйРежим(Истина);
	//	ОбщегоНазначения.УстановитьРазделениеСеанса(Истина, ОбластьДанных);
	//	УстановитьПривилегированныйРежим(Ложь);
	//	
	//	НачатьТранзакцию();
	//	ОбластьОбработана = РаботаСБанкамиБП.ОбновитьБанкиИзКлассификатора(
	//		СписокБанков, ОбластьДанных);
	//	
	//	Если ОбластьОбработана Тогда
	//		ПоставляемыеДанные.ОбластьОбработана(ИдентификаторФайла, КодОбработчика, ОбластьДанных);
	//		ЗафиксироватьТранзакцию();
	//	Иначе
	//		ОтменитьТранзакцию();
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
КонецПроцедуры

// Дополняет данные заполнения ссылкой на банк, найденной (созданной) на основании содержащихся в данных заполнения сведений
// о БИК и других реквизитах банка.
//
// Параметры:
//  ДанныеЗаполнения - Структура - обрабатываются ключи БИК, ВозможныйБИК, БИКБанкаДляРасчетов, ГородБанка, НаименованиеБанка, КоррСчетБанка.
// 
// Возвращаемое значение:
//  Булево - Истина, если удалось определить ссылку на банк; Ложь, если не удалось.
//
Функция УстановитьБанк(ДанныеЗаполнения) Экспорт
	
	УстановитьБИК(ДанныеЗаполнения);
	
	Если Не ДанныеЗаполнения.Свойство("БИК") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	БИК = СокрЛП(ДанныеЗаполнения.БИК);
	
	Если ПустаяСтрока(БИК) И ДанныеЗаполнения.Свойство("БИКБанкаДляРасчетов") Тогда
		Возврат Ложь; // Если передан БИКБанкаДляРасчетов, то создать нельзя, поскольку свойства НаименованиеБанка, ГородБанка и КоррСчетБанка содержат реквизиты банка для расчетов
	КонецЕсли;
	
	Если БанковскиеПравила.ЭтоБИКБанкаРФ(БИК) Тогда
		Банк = НайтиБанк(БИК);
		Если Не ЗначениеЗаполнено(Банк) Тогда
			Банк = СоздатьБанк(БИК, ДанныеЗаполнения);
		КонецЕсли;
	ИначеЕсли ДанныеЗаполнения.Свойство("СВИФТБИК") И НЕ ПустаяСтрока(ДанныеЗаполнения.СВИФТБИК) Тогда
		Банк = НайтиБанкПоСВИФТБИК(СокрЛП(ДанныеЗаполнения.СВИФТБИК));
		Если Не ЗначениеЗаполнено(Банк) Тогда
			Банк = СоздатьОбновитьИностранныйБанкПоСВИФТБИК(ДанныеЗаполнения);
		КонецЕсли;
	Иначе
		Банк = НайтиБанк(БИК, Истина);
		ЭтоКодСВИФТ = БанковскиеПравила.СтрокаСоответствуетФорматуSWIFT(БИК);
		Если ЭтоКодСВИФТ Тогда
			Если ЗначениеЗаполнено(Банк) Тогда
				Банк = НайтиБанкПоСВИФТБИК(БИК);
				Если Не ЗначениеЗаполнено(Банк) Тогда
					Банк = СоздатьОбновитьИностранныйБанкПоСВИФТБИК(ДанныеЗаполнения);
				КонецЕсли;
			Иначе
				Банк = СоздатьОбновитьИностранныйБанкПоСВИФТБИК(ДанныеЗаполнения, Банк);
			КонецЕсли;
		Иначе // Код банка не является российским "БИК" и не удовлетворяет требованиям SWIFT, возможно пустой.
			Если Не ЗначениеЗаполнено(Банк) Тогда
				Банк = СоздатьБанк(БИК, ДанныеЗаполнения);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Банк) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДанныеЗаполнения.Вставить("Банк", Банк);
	Возврат Истина;
	
КонецФункции

// Дополняет данные заполнения ссылкой на банк для расчетов, найденной (созданной) на основании содержащихся в данных заполнения сведений
// о БИК и других реквизитах банка.
//
// Параметры:
//  ДанныеЗаполнения - Структура - обрабатываются ключи БИКБанкаДляРасчетов, ГородБанка, НаименованиеБанка, КоррСчетБанка.
// 
// Возвращаемое значение:
//  Булево - Истина, если удалось определить ссылку на банк; Ложь, если не удалось.
//
Функция УстановитьБанкДляРасчетов(ДанныеЗаполнения) Экспорт
	
	Если Не ДанныеЗаполнения.Свойство("БИКБанкаДляРасчетов") Тогда
		Возврат Ложь;
	КонецЕсли;
	
	БИК = ДанныеЗаполнения.БИКБанкаДляРасчетов;
	
	Банк = НайтиБанк(БИК);
	Если Не ЗначениеЗаполнено(Банк) Тогда
		Банк = СоздатьБанк(БИК, ДанныеЗаполнения);
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Банк) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ДанныеЗаполнения.Вставить("БанкДляРасчетов", Банк);
	Возврат Истина;
	
КонецФункции

Процедура УстановитьБИК(ДанныеЗаполнения)
	
	Если ДанныеЗаполнения.Свойство("БИК") Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДанныеЗаполнения.Свойство("ВозможныйБИК") Или Не ДанныеЗаполнения.Свойство("НомерСчета") Тогда
		Возврат;
	КонецЕсли;
	
	БИКСоответствуетСчету = БанковскиеПравила.ПроверитьКонтрольныйКлючВНомереБанковскогоСчета(
		ДанныеЗаполнения.НомерСчета,
			ДанныеЗаполнения.ВозможныйБИК);
	Если Не БИКСоответствуетСчету Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения.Вставить("БИК", ДанныеЗаполнения.ВозможныйБИК);
	
КонецПроцедуры

Функция НайтиБанк(БИК, Иностранный = Ложь)
	
	Банк = Справочники.Банки.СсылкаНаБанк(БИК);
	Если ЗначениеЗаполнено(Банк) ИЛИ Иностранный Тогда
		Возврат Банк;
	КонецЕсли;
	
	БанкВКлассификаторе = СсылкаПоКлассификатору(БИК);
	Банки = ПодобратьБанкИзКлассификатора(ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(БанкВКлассификаторе));
		
	Если ЗначениеЗаполнено(Банки) Тогда
		Возврат Банки[Банки.ВГраница()];
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция НайтиБанкПоСВИФТБИК(СВИФТБИК)
	
	Банк = Справочники.Банки.СсылкаНаБанкПоСВИФТБИК(СВИФТБИК);
	Если ЗначениеЗаполнено(Банк) Тогда
		Возврат Банк;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

Функция СоздатьБанк(БИК, ДанныеЗаполнения)
	
	Если ПустаяСтрока(БИК) Или Не ДанныеЗаполнения.Свойство("НаименованиеБанка") Или ПустаяСтрока(ДанныеЗаполнения.НаименованиеБанка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	НовыйБанк = Справочники.Банки.СоздатьЭлемент();
	НовыйБанк.Код          = БИК;
	НовыйБанк.Наименование = ДанныеЗаполнения.НаименованиеБанка;
	Если ДанныеЗаполнения.Свойство("ГородБанка") Тогда
		НовыйБанк.Город    = ДанныеЗаполнения.ГородБанка;
	КонецЕсли;
	Если ДанныеЗаполнения.Свойство("КоррСчетБанка") Тогда
		НовыйБанк.КоррСчет = ДанныеЗаполнения.КоррСчетБанка;
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("СВИФТБИК") Тогда
		НовыйБанк.СВИФТБИК = СокрЛП(ДанныеЗаполнения.СВИФТБИК);
	КонецЕсли;
	
	НовыйБанк.Страна = Справочники.СтраныМира.Россия;
	НовыйБанк.СнятьСПоддержки();
	НовыйБанк.Записать();
	
	Возврат НовыйБанк.Ссылка;
	
КонецФункции

Функция СоздатьОбновитьИностранныйБанкПоСВИФТБИК(ДанныеЗаполнения, Банк = Неопределено)
	
	Если Не ДанныеЗаполнения.Свойство("НаименованиеБанка") Или ПустаяСтрока(ДанныеЗаполнения.НаименованиеБанка) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Банк) Тогда
		БанкОбъект = Банк.ПолучитьОбъект();
	Иначе
		БанкОбъект = Справочники.Банки.СоздатьЭлемент();
	КонецЕсли;
	
	Если ДанныеЗаполнения.Свойство("СВИФТБИК") И НЕ ПустаяСтрока(ДанныеЗаполнения.СВИФТБИК) Тогда
		БанкОбъект.Код      = СокрЛП(ДанныеЗаполнения.БИК);
		БанкОбъект.СВИФТБИК = СокрЛП(ДанныеЗаполнения.СВИФТБИК);
	Иначе // Если передан только БИК, значит это СВИФТБИК, а национальный код не передан.
		БанкОбъект.Код      = "";
		БанкОбъект.СВИФТБИК = СокрЛП(ДанныеЗаполнения.БИК);
	КонецЕсли;
	
	БанкОбъект.Наименование = СокрЛП(ДанныеЗаполнения.НаименованиеБанка);
	Если ДанныеЗаполнения.Свойство("ГородБанка") Тогда
		БанкОбъект.Город    = СокрЛП(ДанныеЗаполнения.ГородБанка);
	КонецЕсли;
	
	БанкОбъект.Страна = Справочники.Банки.СтранаПоSWIFT(БанкОбъект.СВИФТБИК);
	БанкОбъект.СнятьСПоддержки();
	БанкОбъект.Записать();
	
	Возврат БанкОбъект.Ссылка;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Функция для изменения и запись справочника Банки по переданным параметрам.
// Если такого банка ещё нет, то он создается.
// Если банк находится в иерархии не на первом уровне, то создается/копируется вся цепочка родителей.
//
// Параметры:
//
// - Ссылки - Массив с элементами типа Структура - Ключи структуры - названия реквизитов справочника,
//   Значения структуры - значения данных реквизитов
// - ИгнорироватьРучноеИзменение - Булево - указание не обрабатывать банки, измененные вручную
//   
// Возвращаемое значение:
//
// - Массив с элементами типа СправочникСсылка.Банки
//
Функция СоздатьОбновитьБанкиВИБ(Ссылки, ИгнорироватьРучноеИзменение)
	
	МассивБанков = Новый Массив;
	
	Для инд = 0 По Ссылки.ВГраница() Цикл
		ПараметрыОбъект = Ссылки[инд];
		
		Банк = ПараметрыОбъект.Банк;
		
		Если ПараметрыОбъект.РучноеИзменение = 1
			И НЕ ИгнорироватьРучноеИзменение Тогда
			МассивБанков.Добавить(Банк);
			Продолжить;
		КонецЕсли;
		
		Если Банк.Пустая() Тогда
			Если ПараметрыОбъект.ЭтоРегион Тогда
				БанкОбъект = Справочники.Банки.СоздатьГруппу();
			Иначе
				БанкОбъект = Справочники.Банки.СоздатьЭлемент();
			КонецЕсли;
		Иначе
			БанкОбъект = Банк.ПолучитьОбъект();
		КонецЕсли;
		
		Если Не БанкОбъект.ЭтоГруппа Тогда
			ПараметрыОбъект.Вставить("Страна", Справочники.СтраныМира.Россия);
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(БанкОбъект, ПараметрыОбъект);
		
		Если НЕ ПустаяСтрока(ПараметрыОбъект.РодительКод) И НЕ ЗначениеЗаполнено(ПараметрыОбъект.Родитель) Тогда
			Регион = Справочники.Банки.СсылкаНаБанк(ПараметрыОбъект.РодительКод, Истина);
			
			Если НЕ ЗначениеЗаполнено(Регион) Тогда
				ПараметрыБанковВышеПоИерархии = Новый Массив;
				ПараметрыБанковВышеПоИерархии.Добавить(СсылкаПоКлассификатору(ПараметрыОбъект.РодительКод,, Истина));
				
				// Если переданный Родитель не является корневым элементом,
				// то будет возвращен массив всех элементов (групп) выше по иерархии.
				// В начале массива будет корневой элемент иерархии, в конце массива - элемента переданный в параметрах 
				МассивБанковВышеПоИерархии = ПодобратьБанкИзКлассификатора(ПараметрыБанковВышеПоИерархии);
				
				Если МассивБанковВышеПоИерархии.Количество() > 0 Тогда
					// Переданный в параметре элемент (к созданию) в возвращенном Массиве будет всегда на последней позиции
					ПоследнийЭлемент = МассивБанковВышеПоИерархии.ВГраница();
					Регион = МассивБанковВышеПоИерархии[ПоследнийЭлемент];
				КонецЕсли;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(Регион) И Регион.ЭтоГруппа Тогда
				БанкОбъект.Родитель = Регион;
			КонецЕсли;
			
			Если НЕ ЗначениеЗаполнено(БанкОбъект.Родитель) Тогда
				ШаблонСообщения = НСтр("ru = 'Не определена группа для элемента с кодом %1'");
				ТекстСообщения = СтрШаблон(
					ШаблонСообщения,
					СокрЛП(ПараметрыОбъект.Код));
				
				ЗаписьЖурналаРегистрации(
					ИмяСобытияВЖурналеРегистрации(), 
					УровеньЖурналаРегистрации.Ошибка,
					Метаданные.Справочники.Банки,
					Банк,
					ТекстСообщения);
				Прервать;
			КонецЕсли;
		КонецЕсли;
		
		НачатьТранзакцию();
		Попытка
			БанкОбъект.Записать();
			ЗафиксироватьТранзакцию();
		Исключение
			ОтменитьТранзакцию();
			
			ШаблонСообщения = НСтр( "ru = 'Не удалось записать элемент
                                  |%1'");
			
			ТекстСообщения = СтрШаблон(ШаблонСообщения, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			
			ЗаписьЖурналаРегистрации(
				ИмяСобытияВЖурналеРегистрации(), 
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Справочники.Банки,
				Банк,
				ТекстСообщения);
			
			Прервать;
		КонецПопытки;
		
		МассивБанков.Добавить(БанкОбъект.Ссылка);
	КонецЦикла;
	
	Возврат МассивБанков;
	
КонецФункции

Функция ДополнитьМассивРодителямиСсылок(Знач Ссылки)
	
	ИмяТаблицы = Ссылки[0].Метаданные().ПолноеИмя();
	
	МассивСсылок = Новый Массив;
	Для каждого Ссылка Из Ссылки Цикл
		МассивСсылок.Добавить(Ссылка);
	КонецЦикла;
	
	ТекущиеСсылки = Ссылки;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	Таблица.Родитель КАК Ссылка
	|ИЗ
	|	" + ИмяТаблицы + " КАК Таблица
	|ГДЕ
	|	Таблица.Ссылка В (&Ссылки)
	|	И Таблица.Родитель <> ЗНАЧЕНИЕ(" + ИмяТаблицы + ".ПустаяСсылка)";
	
	Пока Истина Цикл
		Запрос.УстановитьПараметр("Ссылки", ТекущиеСсылки);
		Результат = Запрос.Выполнить();
		Если Результат.Пустой() Тогда
			Прервать;
		КонецЕсли;
		
		ТекущиеСсылки = Новый Массив;
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			ТекущиеСсылки.Добавить(Выборка.Ссылка);
			МассивСсылок.Добавить(Выборка.Ссылка);
		КонецЦикла;
	КонецЦикла;
	
	Возврат МассивСсылок;
	
КонецФункции

// Задает текст состояние разделнного объекта, устанавливает доступность
// кнопок управления состоянием и флага ТолькоПросмотр формы.
//
Процедура ОбработатьФлагРучногоИзменения(Форма, Знач МожноРедактировать)
	
	Элементы  = Форма.Элементы;
	
	Если Форма.РучноеИзменение = Неопределено Тогда
		Если Форма.ДеятельностьПрекращена Тогда
			Форма.ТекстРучногоИзменения = "";
		Иначе
			Форма.ТекстРучногоИзменения = НСтр("ru = 'Элемент создан вручную. Автоматическое обновление невозможно.'");
		КонецЕсли;
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = НЕ МожноРедактировать;
		Элементы.Родитель.Доступность = МожноРедактировать;
		Элементы.Код.Доступность      = МожноРедактировать;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = МожноРедактировать;
		КонецЕсли;
	ИначеЕсли Форма.РучноеИзменение = Истина Тогда
		Форма.ТекстРучногоИзменения = НСтр("ru = 'Автоматическое обновление элемента отключено.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = МожноРедактировать;
		Элементы.Изменить.Доступность = Ложь;
		Форма.ТолькоПросмотр          = НЕ МожноРедактировать;
		Элементы.Родитель.Доступность = Ложь;
		Элементы.Код.Доступность      = Ложь;
		Если НЕ Форма.Объект.ЭтоГруппа Тогда
			Элементы.КоррСчет.Доступность = Ложь;
		КонецЕсли;
	Иначе
		Форма.ТекстРучногоИзменения = НСтр("ru = 'Элемент обновляется автоматически.'");
		
		Элементы.ОбновитьИзКлассификатора.Доступность = Ложь;
		Элементы.Изменить.Доступность = МожноРедактировать;
		Форма.ТолькоПросмотр          = Истина;
	КонецЕсли;
	
КонецПроцедуры

Процедура УдалитьНеВалидныеКлючиСтруктуры(ПараметрыСтруктураСправочника)
	
	Для каждого КлючИЗначение Из ПараметрыСтруктураСправочника Цикл
		Если КлючИЗначение.Значение = Null ИЛИ КлючИЗначение.Ключ = "ЭтоГруппа" Тогда
			ПараметрыСтруктураСправочника.Удалить(КлючИЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ИмяСобытияВЖурналеРегистрации()

	Возврат НСтр("ru = 'Классификатор банков'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());

КонецФункции

#КонецОбласти
