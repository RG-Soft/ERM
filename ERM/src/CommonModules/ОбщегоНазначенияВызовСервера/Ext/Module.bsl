﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции для работы с данными в базе.

// Проверяет наличие ссылок на объект в базе данных.
//
// Параметры:
//  Ссылка       - ЛюбаяСсылка
//               - Массив значений типа ЛюбаяСсылка.
//
//  ИскатьСредиСлужебныхОбъектов - Булево - начальное значение Ложь,
//                 когда установлено Истина, тогда не будет учитываться
//                 исключения поиска ссылок, заданные при разработке конфигурации.
//
// Возвращаемое значение:
//  Булево.
//
Функция ЕстьСсылкиНаОбъект(Знач СсылкаИлиМассивСсылок, Знач ИскатьСредиСлужебныхОбъектов = Ложь) Экспорт
	
	Возврат ОбщегоНазначения.ЕстьСсылкиНаОбъект(СсылкаИлиМассивСсылок, ИскатьСредиСлужебныхОбъектов);
	
КонецФункции

// Проверяет проведенность документов.
//
// Параметры:
//  Документы - Массив - документы, проведенность которых необходимо проверить.
//
// Возвращаемое значение:
//  Массив - непроведенные документы из массива Документы.
//
Функция ПроверитьПроведенностьДокументов(Знач Документы) Экспорт
	
	Возврат ОбщегоНазначения.ПроверитьПроведенностьДокументов(Документы);
	
КонецФункции

// Выполняет попытку проведения документов.
//
// Параметры:
//	Документы                - Массив - документы, которые необходимо провести.
//
// Возвращаемое значение:
//	Массив - массив структур с полями:
//									Ссылка         - документ, который не удалось провести;
//									ОписаниеОшибки - текст описания ошибки при проведении.
//
Функция ПровестиДокументы(Документы) Экспорт
	
	Возврат ОбщегоНазначения.ПровестиДокументы(Документы);
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////////
// Общие процедуры и функции для работы в режиме разделения данных.

// Устанавливает разделение сеанса.
//
// Параметры:
// Использование - Булево - Использование разделителя ОбластьДанных в сеансе.
// ОбластьДанных - Число - Значение разделителя ОбластьДанных.
//
Процедура УстановитьРазделениеСеанса(Знач Использование, Знач ОбластьДанных = Неопределено) Экспорт
	
	ОбщегоНазначения.УстановитьРазделениеСеанса(Использование, ОбластьДанных);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сохранение, чтение и удаление настроек из хранилищ.

// Сохраняет настройку в хранилище общих настроек.
// 
// Параметры:
//   Соответствуют методу ХранилищеОбщихНастроекСохранить.Сохранить, 
//   подробнее - см. параметры процедуры ХранилищеСохранить().
// 
Процедура ХранилищеОбщихНастроекСохранить(КлючОбъекта, КлючНастроек, Значение, ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено, НужноОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		КлючОбъекта,
		КлючНастроек,
		Значение,
		ОписаниеНастроек,
		ИмяПользователя,
		НужноОбновитьПовторноИспользуемыеЗначения);
		
КонецПроцедуры

// Загружает настройку из хранилища общих настроек.
//
// Параметры:
//   Соответствуют методу ХранилищеОбщихНастроек.Загрузить,
//   подробнее - см. параметры функции ХранилищеЗагрузить().
//
Функция ХранилищеОбщихНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, 
	ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		КлючОбъекта,
		КлючНастроек,
		ЗначениеПоУмолчанию,
		ОписаниеНастроек,
		ИмяПользователя);
		
КонецФункции

// Удаляет настройку из хранилища общих настроек.
//
// Параметры:
//   Соответствуют методу ХранилищеОбщихНастроек.Удалить,
//   подробнее - см. параметры функции ХранилищеУдалить().
//
Процедура ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);
	
КонецПроцедуры

// Сохраняет массив пользовательских настроек МассивСтруктур. 
// Может применяться для случаев вызова с клиента.
// 
// Параметры:
//    МассивСтруктур - Массив - массив структур с полями "Объект", "Настройка", "Значение".
//    НужноОбновитьПовторноИспользуемыеЗначения - Булево - требуется обновить повторно используемые значения.
//
Процедура ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур, НужноОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассив(МассивСтруктур, НужноОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// Сохраняет массив пользовательских настроек МассивСтруктур и обновляет повторно
//   используемые значения. Может применяться для случаев вызова с клиента.
// 
// Параметры:
//    МассивСтруктур - Массив - массив структур с полями "Объект", "Настройка", "Значение".
//
Процедура ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьМассивИОбновитьПовторноИспользуемыеЗначения(МассивСтруктур);
	
КонецПроцедуры

// Сохраняет настройку в хранилище общих настроек и обновляет повторно используемые 
//   значения.
// 
// Параметры:
//   Соответствуют методу ХранилищеОбщихНастроекСохранить.Сохранить, 
//   подробнее - см. параметры процедуры ХранилищеСохранить().
//
Процедура ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения(КлючОбъекта, КлючНастроек, Значение) Экспорт
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранитьИОбновитьПовторноИспользуемыеЗначения(КлючОбъекта, КлючНастроек, Значение);
	
КонецПроцедуры

// Сохраняет настройку в хранилище системных настроек.
// 
// Параметры:
//   Соответствуют методу ХранилищеСистемныхНастроек.Сохранить, 
//   подробнее - см. параметры процедуры ХранилищеСохранить().
// 
Процедура ХранилищеСистемныхНастроекСохранить(КлючОбъекта, КлючНастроек, Значение, ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено, НужноОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекСохранить(
		КлючОбъекта, 
		КлючНастроек, 
		Значение,
		ОписаниеНастроек, 
		ИмяПользователя, 
		НужноОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// Загружает настройку из хранилища системных настроек.
//
// Параметры:
//   Соответствуют методу ХранилищеСистемныхНастроек.Загрузить,
//   подробнее - см. параметры функции ХранилищеЗагрузить().
//
Функция ХранилищеСистемныхНастроекЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, 
	ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеСистемныхНастроекЗагрузить(
		КлючОбъекта, 
		КлючНастроек, 
		ЗначениеПоУмолчанию, 
		ОписаниеНастроек, 
		ИмяПользователя);
	
КонецФункции

// Удаляет настройку из хранилища системных настроек.
//
// Параметры:
//   Соответствуют методу ХранилищеСистемныхНастроек.Удалить,
//   подробнее - см. параметры функции ХранилищеУдалить().
//
Процедура ХранилищеСистемныхНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт
	
	ОбщегоНазначения.ХранилищеСистемныхНастроекУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);
	
КонецПроцедуры

// Сохраняет настройку в хранилище настроек данных форм.
// 
// Параметры:
//   Соответствуют методу ХранилищеСистемныхНастроек.Сохранить, 
//   подробнее - см. параметры процедуры ХранилищеСохранить().
//
Процедура ХранилищеНастроекДанныхФормСохранить(КлючОбъекта, КлючНастроек, Значение, ОписаниеНастроек = Неопределено,
	ИмяПользователя = Неопределено, НужноОбновитьПовторноИспользуемыеЗначения = Ложь) Экспорт
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		КлючОбъекта, 
		КлючНастроек, 
		Значение,
		ОписаниеНастроек, 
		ИмяПользователя, 
		НужноОбновитьПовторноИспользуемыеЗначения);
	
КонецПроцедуры

// Загружает настройку из хранилища настроек данных форм.
//
// Параметры:
//   Соответствуют методу ХранилищеСистемныхНастроек.Загрузить,
//   подробнее - см. параметры функции ХранилищеЗагрузить().
//
Функция ХранилищеНастроекДанныхФормЗагрузить(КлючОбъекта, КлючНастроек, ЗначениеПоУмолчанию = Неопределено, 
	ОписаниеНастроек = Неопределено, ИмяПользователя = Неопределено) Экспорт
	
	Возврат ОбщегоНазначения.ХранилищеНастроекДанныхФормЗагрузить(
		КлючОбъекта, 
		КлючНастроек, 
		ЗначениеПоУмолчанию, 
		ОписаниеНастроек, 
		ИмяПользователя);
	
КонецФункции

// Удаляет настройку из хранилища настроек данных форм.
//
// Параметры:
//   Соответствуют методу ХранилищеНастроекДанныхФорм.Удалить,
//   подробнее - см. параметры функции ХранилищеУдалить().
//
Процедура ХранилищеНастроекДанныхФормУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя) Экспорт
	
	ОбщегоНазначения.ХранилищеНастроекДанныхФормУдалить(КлючОбъекта, КлючНастроек, ИмяПользователя);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ РАБОТЫ С ФИЗЛИЦАМИ

// Функция формирует фамилию, имя и отчество одной строкой
//
// Параметры
//  Фамилия  - фамилия физ. лица.
//  Имя      - имя физ. лица.
//  Отчество - отчество физ. лица.
//  ФИОКратко    - Булево - если Истина (по умолчанию), Представление физ.лица включает фамилию и инициалы, если Ложь - фамилию и полностью имя и отчество
//
// Возвращаемое значение
//  Фамилия, имя, отчество одной строкой.
//
Функция ПолучитьФамилиюИмяОтчество(Фамилия = " ", Имя = " ", Отчество = " ", ФИОКратко = Истина) Экспорт

	Если ФИОКратко Тогда
		Возврат ?(НЕ ПустаяСтрока(Фамилия), Фамилия + ?(НЕ ПустаяСтрока(Имя)," " + Лев(Имя,1) + "." +
				?(НЕ ПустаяСтрока(Отчество) ,
				Лев(Отчество,1)+".", ""), ""), "");
	Иначе
		Возврат ?(НЕ ПустаяСтрока(Фамилия), Фамилия + ?(НЕ ПустаяСтрока(Имя)," " + Имя +
				?(НЕ ПустаяСтрока(Отчество) , " " + Отчество, ""), ""), "");
	КонецЕсли;

КонецФункции // ПолучитьФамилиюИмяОтчество()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Функции для работы с цветами стиля в клиентском коде.

// Функция получает цвет стиля по имени элемента стиля.
//
// Параметры:
// ИмяЦветаСтиля - Строка -  Имя элемента стиля.
//
// Возвращаемое значение:
// Цвет.
//
Функция ЦветСтиля(ИмяЦветаСтиля) Экспорт
	
	Возврат ЦветаСтиля[ИмяЦветаСтиля];
	
КонецФункции

// Функция получает шрифт стиля по имени элемента стиля.
//
// Параметры:
// ИмяШрифтаСтиля - Строка - Имя шрифта стиля.
//
// Возвращаемое значение:
// Шрифт.
//
Функция ШрифтСтиля(ИмяШрифтаСтиля) Экспорт
	
	Возврат ШрифтыСтиля[ИмяШрифтаСтиля];
	
КонецФункции

#КонецОбласти
