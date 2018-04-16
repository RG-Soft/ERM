#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// Инициализирует набор параметров, задающих флаги выполнения дополнительных действий над сущностями, обрабатываемыми
// в процессе формирования отчета.
//
// Возвращаемое значение:
//   Структура   - флаги, задающие необходимость дополнительных действий.
//
Функция ПолучитьПараметрыИсполненияОтчета() Экспорт
	
	Результат = Новый Структура;
	Результат.Вставить("ИспользоватьПередКомпоновкойМакета", Истина);
	Результат.Вставить("ИспользоватьПослеКомпоновкиМакета",  Истина);
	Результат.Вставить("ИспользоватьПослеВыводаРезультата",  Истина);
	Результат.Вставить("ИспользоватьДанныеРасшифровки",      Истина);
	Результат.Вставить("ИспользоватьПередВыводомЭлементаРезультата", Истина);

	Возврат Результат;

КонецФункции

Процедура ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
КонецПроцедуры

Процедура ВывестиЗаголовокОтчета(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
КонецПроцедуры

// В процедуре можно доработать компоновщик перед выводом в отчет. Изменения сохранены не будут.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Схема        - СхемаКомпоновкиДанных - описание получаемых данных.
//  КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - связь настроек компоновки данных и схемы компоновки.
//
Процедура ПередКомпоновкойМакета(ПараметрыОтчета, Схема, КомпоновщикНастроек) Экспорт
	
КонецПроцедуры

// Устанавливает макет оформления отчета.
//
// Параметры:
//	ПараметрыОтчета - Структура - Содержит ключи:
//		* МакетОформления - Строка - Имя макета оформления.
//	НастройкаКомпоновкиДанных - КомпоновщикНастроекКомпоновкиДанных - Компоновщик настроек СКД.
//
Процедура УстановитьМакетОформленияОтчета(ПараметрыОтчета, НастройкаКомпоновкиДанных) Экспорт
	
	МакетОформления	= Неопределено;
	
	Если ПараметрыОтчета.Свойство("МакетОформления", МакетОформления) Тогда
		Если НЕ ЗначениеЗаполнено(МакетОформления) ИЛИ МакетОформления = "МакетОформленияОтчетовЗеленый" Тогда
			МакетОформления = "ОформлениеОтчетовЗеленый";
		ИначеЕсли МакетОформления = "МакетОформленияОтчетовЧерноБелый" Тогда
			МакетОформления = "ОформлениеОтчетовЧерноБелый";
		КонецЕсли;
	Иначе
		МакетОформления = "ОформлениеОтчетовЗеленый";
	КонецЕсли;
	
	УстановитьПараметрВывода(НастройкаКомпоновкиДанных, "МакетОформления", МакетОформления);	
	
КонецПроцедуры

Процедура УстановитьПараметрВывода(ЭлементКД, Имя, Значение = Неопределено, Использование = Истина)
	ПараметрКД = ЭлементКД.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных(Имя));
	Если ПараметрКД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Значение <> Неопределено Тогда
		ПараметрКД.Значение = Значение;
	КонецЕсли;
	Если Использование <> Неопределено Тогда
		ПараметрКД.Использование = Использование;
	КонецЕсли;
КонецПроцедуры

// Возвращает макет компоновки шапки отчета.
//
// Параметры:
// 	МакетКомпоновки - МакетКомпоновкиДанных - Результат формирования макета компоновки.
//	Тело - ТелоМакетаКомпоновкиДанных - Содержание макета компоновки.
//	ТипМакета - Строка - Возможные значения "Заголовок", "Подвал".
//
// Возвращаемое значение:
//	ОписаниеМакетаОбластиМакетаКомпоновкиДанных - Искомый макет.
//
Функция ПолучитьМакетШапки(МакетКомпоновки, Тело = Неопределено, ТипМакета = "Заголовок") Экспорт
	
	ЕстьПустойМакет = Ложь;
	
	Если Тело = Неопределено Тогда
		Тело = МакетКомпоновки.Тело;
	КонецЕсли;
	
	Если Тело.Количество() > 0 Тогда
		Если ТипМакета = "Заголовок" Тогда
			НачальныйИндекс = 0;
			КонечныйИндекс  = Тело.Количество();
			ИтераторПрямой  = Истина;
		ИначеЕсли ТипМакета = "Подвал" Тогда 
			НачальныйИндекс = Тело.Количество() - 1;
			КонечныйИндекс  = 0;
			ИтераторПрямой  = Ложь;
		КонецЕсли;
		
		Индекс = НачальныйИндекс;
		Пока Индекс <> КонечныйИндекс Цикл
			Элемент = Тело[Индекс];
			Если ТипЗнч(Элемент) = Тип("МакетОбластиМакетаКомпоновкиДанных") Тогда
				Если ЕстьПустойМакет Тогда
					ЕстьПустойМакет = Ложь;
				Иначе
					Возврат МакетКомпоновки.Макеты[Элемент.Макет];
				КонецЕсли;
			ИначеЕсли ТипЗнч(Элемент) = Тип("МакетГруппировкиТаблицыМакетаКомпоновкиДанных") Тогда
				Возврат МакетКомпоновки.Макеты[Элемент.Макет];
			ИначеЕсли ТипЗнч(Элемент) = Тип("ДиаграммаМакетаКомпоновкиДанных") Тогда
				ЕстьПустойМакет = Истина;
			ИначеЕсли ТипЗнч(Элемент) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда
				Возврат МакетКомпоновки.Макеты[Элемент.МакетШапки];
			КонецЕсли;
			
			Если ИтераторПрямой Тогда
				Индекс = Индекс + 1;
			Иначе
				Индекс = Индекс - 1;
			КонецЕсли;
		КонецЦикла;	
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Ищет макет компоновки отчета по имени поля группировки.
//
// Параметры:
// 	МакетКомпоновки - МакетКомпоновкиДанных - Результат формирования макета компоновки.
//	ПолеГруппировки - Строка - Имя поля группировки.
//	ИскатьВДетальныхЗаписях - Булево - Признак поиска в детальных записях.
//	ТипМакета - Строка - Возможные значения "Заголовок", "Подвал".
//
// Возвращаемые значения:
//	Массив - Массив найденных макетов компоновки.
//
Функция ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, ПолеГруппировки, ИскатьВДетальныхЗаписях = Ложь, ТипМакета = "Заголовок") Экспорт
	
	МассивМакетов = Новый Массив;
	
	ОбойтиТелоМакетаКомпоновки(МакетКомпоновки, МакетКомпоновки.Тело, МассивМакетов, ПолеГруппировки, ТипМакета, ИскатьВДетальныхЗаписях);	
	
	Возврат МассивМакетов;
	
КонецФункции

Процедура ОбойтиТелоМакетаКомпоновки(МакетКомпоновки, Тело, МассивМакетов, ПолеГруппировки, ТипМакета, ИскатьВДетальныхЗаписях = Ложь) 
	
	Для Каждого Элемент Из Тело Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппировкаМакетаКомпоновкиДанных") Тогда
			Для Каждого ЭлементГруппировки Из Элемент.Группировка Цикл
				Если СтрНайти(ЭлементГруппировки.ИмяПоля, ПолеГруппировки) = 1 Тогда 
					МакетТело = ПолучитьМакетШапки(МакетКомпоновки, Элемент.Тело, ТипМакета);
					Если МакетТело <> Неопределено Тогда
						МассивМакетов.Добавить(МакетТело);  
					КонецЕсли;
					МакетТелоИерархии = ПолучитьМакетШапки(МакетКомпоновки, Элемент.ТелоИерархии, ТипМакета);
					Если МакетТелоИерархии <> Неопределено Тогда
						МассивМакетов.Добавить(МакетТелоИерархии);
					КонецЕсли;
				КонецЕсли; 
				ОбойтиТелоМакетаКомпоновки(МакетКомпоновки, Элемент.Тело, МассивМакетов, ПолеГруппировки, ТипМакета, ИскатьВДетальныхЗаписях);
			КонецЦикла;
		ИначеЕсли ТипЗнч(Элемент) = Тип("ТаблицаМакетаКомпоновкиДанных") Тогда

			ОбойтиТелоМакетаТаблицыКомпоновки(МакетКомпоновки, Элемент.Строки, МассивМакетов, ПолеГруппировки, ТипМакета, ИскатьВДетальныхЗаписях = Ложь);
	
		КонецЕсли;
		Если ИскатьВДетальныхЗаписях Тогда
			Если ТипЗнч(Элемент) = Тип("ЗаписиМакетаКомпоновкиДанных") Тогда
				Если Элемент.Имя = ПолеГруппировки Тогда
					МассивМакетов.Добавить(ПолучитьМакетШапки(МакетКомпоновки, Элемент.Тело));	
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбойтиТелоМакетаТаблицыКомпоновки(МакетКомпоновки, Тело, МассивМакетов, ПолеГруппировки, ТипМакета, ИскатьВДетальныхЗаписях = Ложь) 
	
	Для Каждого Элемент Из Тело Цикл
		Если ТипЗнч(Элемент) = Тип("ГруппировкаТаблицыМакетаКомпоновкиДанных") Тогда
			Для Каждого ЭлементГруппировки Из Элемент.Группировка Цикл
				Если СтрНайти(ЭлементГруппировки.ИмяПоля, ПолеГруппировки) = 1 Тогда 
					МакетТело = ПолучитьМакетШапки(МакетКомпоновки, Элемент.Тело, ТипМакета);
					Если МакетТело <> Неопределено Тогда
						МассивМакетов.Добавить(МакетТело);  
					КонецЕсли;
					МакетТелоИерархии = ПолучитьМакетШапки(МакетКомпоновки, Элемент.ТелоИерархии, ТипМакета);
					Если МакетТелоИерархии <> Неопределено Тогда
						МассивМакетов.Добавить(МакетТелоИерархии);
					КонецЕсли;
				КонецЕсли; 
				ОбойтиТелоМакетаТаблицыКомпоновки(МакетКомпоновки, Элемент.Тело, МассивМакетов, ПолеГруппировки, ТипМакета, ИскатьВДетальныхЗаписях);
			КонецЦикла;
		КонецЕсли;
		
		Если ИскатьВДетальныхЗаписях Тогда
			Если ТипЗнч(Элемент) = Тип("ЗаписиТаблицыМакетаКомпоновкиДанных") Тогда
				Если Элемент.Имя = ПолеГруппировки Тогда
					МассивМакетов.Добавить(ПолучитьМакетШапки(МакетКомпоновки, Элемент.Тело));
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Функция ЗаполнитьМакетыРесурсовПодвалаОтчета(Таблица, МассивМакетов, СоответствиеМакетовКолонкамОтчета)

	Для Каждого Группировка Из Таблица.Строки Цикл

		Для Каждого МакетРесурсов Из Группировка.МакетПодвала.МакетРесурсов Цикл

			МассивМакетов.Добавить(МакетРесурсов.Макет);

			СоответствиеМакетовКолонкамОтчета.Вставить(МакетРесурсов.Макет, МакетРесурсов.МакетГруппировки);

		КонецЦикла;

	КонецЦикла;

КонецФункции

Функция ЗаполнитьМакетыРесурсовГруппировки(Таблица, МассивМакетов, СоответствиеМакетовКолонкамОтчета, ПолеГруппировки = Неопределено, ВключатьМакетыВложенныхГруппировок = Ложь, ПрочитатьМакетыРесурсов = Ложь)
	
	// Перебираем все элементы макета.
	Для Каждого Группировка Из Таблица Цикл
		
		Если ТипЗнч(Группировка) = Тип("ГруппировкаТаблицыМакетаКомпоновкиДанных") Тогда
			// Если это группировка, проверим поле группировки.
			Если ПолеГруппировки = Неопределено ИЛИ Группировка.Группировка[0].ИмяПоля = ПолеГруппировки Тогда
				
				Если ВключатьМакетыВложенныхГруппировок Тогда
					// Перебираем вложенные группировки. Условие по полю группировки в них не накладываем.
					ЗаполнитьМакетыРесурсовГруппировки(Группировка.Тело, МассивМакетов, СоответствиеМакетовКолонкамОтчета,,,Истина);
				Иначе
					ЗаполнитьМакетыРесурсовГруппировки(Группировка.Тело, МассивМакетов, СоответствиеМакетовКолонкамОтчета, ПолеГруппировки, ВключатьМакетыВложенныхГруппировок, Истина);
				КонецЕсли;
				
				// Перебираем иерархию группировки.
				Для Каждого ТелоИерархии Из Группировка.ТелоИерархии Цикл
					
					Если ТипЗнч(ТелоИерархии) = Тип("МакетГруппировкиТаблицыМакетаКомпоновкиДанных") Тогда
						
						Для Каждого МакетРесурсов Из ТелоИерархии.МакетРесурсов Цикл
							// Помещаем макеты в массив.
							МассивМакетов.Добавить(МакетРесурсов.Макет);
							// Добавляем соответствие макетов ресурсов и колонок отчета.
							СоответствиеМакетовКолонкамОтчета.Вставить(МакетРесурсов.Макет, МакетРесурсов.МакетГруппировки);
							
						КонецЦикла;
						
					КонецЕсли;
				
				КонецЦикла;
				
			Иначе
				// Если эта группировка не подошла по условию проверим вложенные группировки.
				ЗаполнитьМакетыРесурсовГруппировки(Группировка.Тело, МассивМакетов, СоответствиеМакетовКолонкамОтчета, ПолеГруппировки, ВключатьМакетыВложенныхГруппировок);

			КонецЕсли;
			
		ИначеЕсли ТипЗнч(Группировка) = Тип("МакетГруппировкиТаблицыМакетаКомпоновкиДанных") И ПрочитатьМакетыРесурсов Тогда
			
			Для Каждого МакетРесурсов Из Группировка.МакетРесурсов Цикл
				
				// Помещаем макеты в массив.
				МассивМакетов.Добавить(МакетРесурсов.Макет);
				// Добавляем соответствие макетов ресурсов и колонок отчета.
				СоответствиеМакетовКолонкамОтчета.Вставить(МакетРесурсов.Макет, МакетРесурсов.МакетГруппировки);
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецФункции

// В процедуре можно уточнить особенности вывода данных в отчет.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//
Процедура ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки) Экспорт

//	// Определим количество группировок по субконто.
//	КоличествоГруппировок = 0;
//	
//	Для Каждого СтрокаТаблицы Из ПараметрыОтчета.Группировка Цикл
//		Если СтрокаТаблицы.Использование Тогда
//			КоличествоСубконто = СтрЧислоВхождений(СтрокаТаблицы.ПоСубконто, "+");
//			КоличествоГруппировок = Макс(КоличествоГруппировок, КоличествоСубконто);
//		КонецЕсли;
//	КонецЦикла;
//
//	// Для того чтобы отобразить сумму в валюте после каждой группировки подставляется еще групировка по валюте,
//	// удваивая тем самым общее количество группировок отчета. Это нужно учесть.
//	КоличествоГруппировок = КоличествоГруппировок + ?(ПараметрыОтчета.ПоказательВалютнаяСумма, КоличествоГруппировок, 0);
//
//	КоличествоСтрокШапки = Макс(КоличествоГруппировок, 1);
//	ПараметрыОтчета.Вставить("ВысотаШапки", КоличествоСтрокШапки + 1);
//
//	// Обработка шапки отчета.
//	// Шапка отчета состоит и 4 макетов, макет шапки таблицы, и 3 макета группировок колонок.
//	// Поместим ссылки на них в массив для дальнейшей обработки.
//	МакетШапкиТаблицы = ПолучитьМакетШапки(МакетКомпоновки);
//	
//	МакетыШапкиОтчета = Новый Массив;
//	МакетыШапкиОтчета.Добавить(МакетШапкиТаблицы.Имя);
//
//	Для Каждого Колонка Из МакетКомпоновки.Тело[0].Колонки Цикл
//
//		Для Каждого ТелоГруппировки Из Колонка.Тело Цикл
//			МакетыШапкиОтчета.Добавить(ТелоГруппировки.Макет);
//		КонецЦикла;
//
//	КонецЦикла;
//
//	// Удалим лишние строки из шапки отчета.
//	МассивДляУдаления = Новый Массив;
//	
//	Для Каждого ИмяМакетаШапкиОтчета Из МакетыШапкиОтчета Цикл
//		
//		МакетШапкиОтчета = МакетКомпоновки.Макеты[ИмяМакетаШапкиОтчета];
//		
//		
//		Для Индекс = КоличествоСтрокШапки + 1 По МакетШапкиОтчета.Макет.Количество() - 1 Цикл
//			
//			МассивДляУдаления.Добавить(МакетШапкиОтчета.Макет[Индекс]);
//			
//		КонецЦикла;
//		
//		Для Каждого Элемент Из МассивДляУдаления Цикл
//			МакетШапкиОтчета.Макет.Удалить(Элемент);
//		КонецЦикла;
//		
//		// Если группировка только по счету, объединим ячейки заголовка таблицы.
//		Если МакетШапкиОтчета = МакетШапкиТаблицы И КоличествоСтрокШапки = 1 Тогда
//			
//			Для Каждого Ячейка Из МакетШапкиОтчета.Макет[МакетШапкиОтчета.Макет.Количество() - 1].Ячейки Цикл
//				
//				Оформление = Ячейка.Оформление.Элементы.Найти("ОбъединятьПоВертикали");
//				Оформление.Значение = Истина;
//				Оформление.Использование = Истина;
//				
//			КонецЦикла;
//			
//		КонецЕсли;
//			
//	КонецЦикла;
//	
//	// Для обработки итогов запомним имена различных макетов.
//	МакетГруппировкиСчет = ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Счет");
//	МакетыРесурсовПодвалаОтчета 		= Новый Массив;
//	МакетыРесурсовСчета 				= Новый Массив;
//	
//	// Соответствие макетов колонкам отчета понадобится позже для подсчета итогов.
//	СоответствиеМакетовКолонкамОтчета = Новый Соответствие;
//	
//	ЗаполнитьМакетыРесурсовПодвалаОтчета(МакетКомпоновки.Тело[0], МакетыРесурсовПодвалаОтчета, СоответствиеМакетовКолонкамОтчета);
//	ЗаполнитьМакетыРесурсовГруппировки(МакетКомпоновки.Тело[0].Строки, МакетыРесурсовСчета, СоответствиеМакетовКолонкамОтчета, "Счет");
//	
//	МассивИменМакетовСчет = Новый Массив;
//	Для Каждого МакетСчет Из МакетГруппировкиСчет Цикл
//		МассивИменМакетовСчет.Добавить(МакетСчет.Имя);
//	КонецЦикла;
//
//	// Макеты группировки и ресурсов группировки по валюте будем использовать для определения принадлежности элемента Макет макета компоновки.
//	МакетГруппировкиВалюта = ПолучитьМакетГруппировкиПоПолюГруппировки(МакетКомпоновки, "Валюта");
//	МакетРесурсовГруппировкиВалюта = Новый Массив;
//	
//	МассивИменМакетовВалюта = Новый Массив;
//	Для Каждого МакетВалюта Из МакетГруппировкиВалюта Цикл
//		МассивИменМакетовВалюта.Добавить(МакетВалюта.Имя);
//	КонецЦикла;
//	
//	ЗаполнитьМакетыРесурсовГруппировки(МакетКомпоновки.Тело[0].Строки, МакетРесурсовГруппировкиВалюта, СоответствиеМакетовКолонкамОтчета, "Валюта", Истина);
//
//	
//	// Создадим структуру для хранения итогов.
//	ЗначенияПоказателей = Новый Структура();
//	
//	// Определим количество показателей выводимых в отчет.
//	КоличествоПоказателей 	= 1;
//	// На верхнем уровне структура. Ключу структуры соответсвует имя макета колонки, значению - 2-х мерный массив.
//	// Размерность первого измерения массива соответсвует количеству показателей отчета.
//	// Размерность второго измерения равна 2, что соответсвует дебету и кредиту.
//	Для Каждого Колонка Из МакетКомпоновки.Тело[0].Колонки Цикл
//		
//		// Создаем структуру.
//		ЗначенияПоказателей.Вставить(Колонка.Тело[0].Макет, Новый Массив(КоличествоПоказателей, 2));
//		
//		// Заполняем значения массива нолями.
//		Для Каждого Массив Из ЗначенияПоказателей[Колонка.Тело[0].Макет] Цикл
//			Для Индекс = 0 По 1 Цикл
//				Массив[Индекс] = 0;
//			КонецЦикла;
//		КонецЦикла;
//		
//	КонецЦикла;
//
//	// Создадим структуру для хранения временных данных, которые нужны для расчета итогов при выводе отчета.
//	ВременныеДанныеОтчета = Новый Структура;
//
//	// Упаковываем временные данные в структуру.
//	ВременныеДанныеОтчета.Вставить("МакетыРесурсовСчета"					, МакетыРесурсовСчета);
//	ВременныеДанныеОтчета.Вставить("МакетыРесурсовПодвалаОтчета"			, МакетыРесурсовПодвалаОтчета);
//	ВременныеДанныеОтчета.Вставить("СоответствиеМакетовКолонкамОтчета"		, СоответствиеМакетовКолонкамОтчета);
//	ВременныеДанныеОтчета.Вставить("МакетШапкиОтчета"						, МакетыШапкиОтчета);
//	ВременныеДанныеОтчета.Вставить("КоличествоПоказателей"					, КоличествоПоказателей);
//	ВременныеДанныеОтчета.Вставить("ЗначенияПоказателей"					, ЗначенияПоказателей);
//	
//	ПараметрыОтчета.Вставить("ВременныеДанныеОтчета", ВременныеДанныеОтчета);
	
КонецПроцедуры

// В процедуре можно уточнить особенности вывода в отчет отдельного элемента в структуре данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  МакетКомпоновки - МакетКомпоновкиДанных - описание выводимых данных.
//  ДанныеРасшифровки - ДанныеРасшифровкиКомпоновкиДанных - описание расшифровки для элемента в структуре данных.
//  ЭлементРезультата - ЭлементРезультатаКомпоновкиДанных - описание элемента в структуре данных.
//  Отказ        - Булево - если Истина, то не выводить эти данные в отчет.
//
Процедура ПередВыводомЭлементаРезультата(ПараметрыОтчета, МакетКомпоновки, ДанныеРасшифровки, ЭлементРезультата, Отказ = Ложь) Экспорт
	
//	// Отсекаем валютные группировки на счетах, по которым не ведется
//	// валютный учет.
//	Если ЭлементРезультата.ЗначенияПараметров.Количество() > 0
//		И ЭлементРезультата.ЗначенияПараметров.Найти("П1") <> Неопределено
//		И ЗначениеЗаполнено(ЭлементРезультата.Макет)
//		И ПараметрыОтчета.ВременныеДанныеОтчета.МакетВалюта.Найти(ЭлементРезультата.Макет) <> Неопределено
//		И ЭлементРезультата.ЗначенияПараметров.П1.Значение = Null Тогда
//		Отказ = Истина;
//		Возврат;
//	КонецЕсли;
//
//	Если ПараметрыОтчета.ПоказательВалютнаяСумма
//		И ПараметрыОтчета.ВременныеДанныеОтчета.КоличествоПоказателей > 1 Тогда
//		КоличествоПоказателей = ПараметрыОтчета.ВременныеДанныеОтчета.КоличествоПоказателей - 1;
//	Иначе
//		КоличествоПоказателей = ПараметрыОтчета.ВременныеДанныеОтчета.КоличествоПоказателей;
//	КонецЕсли;
//
//	// Обрабатываем элементы, содержащие корневые счета.
//	Если ЭлементРезультата.ЗначенияПараметров.Количество() > 0 
//		И ЭлементРезультата.ЗначенияПараметров.Найти("П1") <> Неопределено
//		И ЗначениеЗаполнено(ЭлементРезультата.Макет)
//		И ПараметрыОтчета.ВременныеДанныеОтчета.МакетШапкиОтчета.Найти(ЭлементРезультата.Макет) = Неопределено
//		И ПараметрыОтчета.ВременныеДанныеОтчета.МакетыРесурсовПодвалаОтчета.Найти(ЭлементРезультата.Макет) = Неопределено Тогда
//
//		// Запомним значение счета.
//		Если ПараметрыОтчета.ВременныеДанныеОтчета.МакетСчет.Найти(ЭлементРезультата.Макет) <> Неопределено Тогда
//			
//			ПараметрыОтчета.ВременныеДанныеОтчета.ТекущийСчет = Неопределено;
//			
//			Для Каждого Параметр Из ЭлементРезультата.ЗначенияПараметров Цикл
//				Если ТипЗнч(Параметр.Значение) = Тип("ИдентификаторРасшифровкиКомпоновкиДанных") Тогда
//					
//					ПараметрыОтчета.ВременныеДанныеОтчета.ТекущийСчет = ДанныеРасшифровки.Элементы[Параметр.Значение].ПолучитьПоля()[0].Значение;;
//					Прервать;
//					
//				КонецЕсли;
//			КонецЦикла;
//			
//		КонецЕсли;
//		
//		// Накапливаем суммы по корневым счетам.
//		Если ПараметрыОтчета.ВременныеДанныеОтчета.МакетыРесурсовСчета.Найти(ЭлементРезультата.Макет) <> Неопределено 
//			И ЗначениеЗаполнено(ПараметрыОтчета.ВременныеДанныеОтчета.ТекущийСчет) Тогда
//
//			Если Не ЗначениеЗаполнено(ПараметрыОтчета.ВременныеДанныеОтчета.ТекущийСчет.Родитель) 
//				И МакетКомпоновки.Макеты[ЭлементРезультата.Макет].Макет.Количество() > 0 Тогда
//				
//				Для ИндексЭлемента = 0 По КоличествоПоказателей - 1 Цикл
//					
//					СтрокаМакета = МакетКомпоновки.Макеты[ЭлементРезультата.Макет].Макет[ИндексЭлемента];
//					
//					Для Каждого Ячейка Из СтрокаМакета.Ячейки Цикл
//						
//						Если Ячейка.Элементы.Количество() = 0 Тогда
//							Продолжить;
//						КонецЕсли;
//						
//						Для Каждого Элемент Из Ячейка.Элементы Цикл
//							
//							ИмяПараметра = Строка(Элемент.Значение);
//							ПараметрРезультата = ЭлементРезультата.ЗначенияПараметров.Найти(ИмяПараметра);
//							
//							Значение = 0;
//
//							Если НЕ (Не ПараметрыОтчета.ВременныеДанныеОтчета.ТекущийСчет.НалоговыйУчет И ИндексЭлемента = (КоличествоПоказателей - 1)
//								И ПараметрыОтчета.ПоказательКонтроль) И ПараметрРезультата <> Неопределено Тогда
//								Если ПараметрРезультата.Значение <> Null Тогда
//									Значение = ПараметрРезультата.Значение;
//								КонецЕсли;
//							КонецЕсли;
//							
//							КолонкаРезультата = ПараметрыОтчета.ВременныеДанныеОтчета.СоответствиеМакетовКолонкамОтчета.Получить(ЭлементРезультата.Макет);
//							
//							Если КолонкаРезультата <> Неопределено Тогда
//								
//								ИндексЯчейки = СтрокаМакета.Ячейки.Индекс(Ячейка);
//								ТекущееЗначениеИтога = ПараметрыОтчета.ВременныеДанныеОтчета.ЗначенияПоказателей[КолонкаРезультата][ИндексЭлемента][ИндексЯчейки];
//								ПараметрыОтчета.ВременныеДанныеОтчета.ЗначенияПоказателей[КолонкаРезультата][ИндексЭлемента][ИндексЯчейки] = ТекущееЗначениеИтога + Значение;
//								
//							КонецЕсли;
//							
//						КонецЦикла;
//						
//					КонецЦикла;
//					
//				КонецЦикла;
//				
//			КонецЕсли;
//			
//		КонецЕсли; 
//
//	// Проставляем накопленные суммы в подвал отчета.
//	ИначеЕсли ПараметрыОтчета.ВременныеДанныеОтчета.МакетыРесурсовПодвалаОтчета.Найти(ЭлементРезультата.Макет) <> Неопределено Тогда
//
//		КолонкаРезультата = ПараметрыОтчета.ВременныеДанныеОтчета.СоответствиеМакетовКолонкамОтчета.Получить(ЭлементРезультата.Макет);
//
//		Если КолонкаРезультата <> Неопределено Тогда
//
//			Для Каждого СтрокаМакета Из МакетКомпоновки.Макеты[ЭлементРезультата.Макет].Макет Цикл
//
//				ИндексЭлемента = МакетКомпоновки.Макеты[ЭлементРезультата.Макет].Макет.Индекс(СтрокаМакета);
//
//				Для Каждого Ячейка Из СтрокаМакета.Ячейки Цикл
//
//					ИндексЯчейки =  СтрокаМакета.Ячейки.Индекс(Ячейка);
//
//					Для Каждого Элемент Из Ячейка.Элементы Цикл
//
//						ИмяПараметра = Строка(Элемент.Значение);
//						ПараметрЭлемента = ЭлементРезультата.ЗначенияПараметров.Найти(ИмяПараметра);
//
//						// Если параметр определен в макете, но его нет в элементе результата.
//						Если ПараметрЭлемента = Неопределено тогда
//							
//							// Добавляем параметра в элемент результата.
//							ПараметрЭлемента = ЭлементРезультата.ЗначенияПараметров.Добавить();
//							ПараметрЭлемента.Имя = ИмяПараметра;
//							
//						КонецЕсли;
//						
//						ПараметрЭлемента.Значение = ПараметрыОтчета.ВременныеДанныеОтчета.ЗначенияПоказателей[КолонкаРезультата][ИндексЭлемента][ИндексЯчейки];
//						
//					КонецЦикла;
//
//				КонецЦикла;
//
//			КонецЦикла;
//
//		КонецЕсли;
//
//	КонецЕсли;
	
КонецПроцедуры

Процедура ПриВыводеПодвала(ПараметрыОтчета, Результат)
	
КонецПроцедуры

// Выводит подвал отчета.
//
// Параметры:
//	ПараметрыОтчета - Структура - Содержит ключи:
//		* ОтветственноеЛицо - Перечисления.ОтветственныеЛицаОрганизаций - Вид ответственного лица.
//	КомпоновщикНастроек - КомпоновщикНастроекКомпоновкиДанных - Компоновщик настроек СКД.
//	Результат - ТабличныйДокумент - Результат формирования отчета.
//
Процедура ВывестиПодвалОтчета(ПараметрыОтчета, КомпоновщикНастроек, Результат) Экспорт
	
КонецПроцедуры

// В процедуре можно изменить табличный документ после вывода в него данных.
//
// Параметры:
//  ПараметрыОтчета - Структура - см. ПодготовитьПараметрыОтчета() в ФормаОтчета.
//  Результат    - ТабличныйДокумент - сформированный отчет.
//
Процедура ПослеВыводаРезультата(ПараметрыОтчета, Результат) Экспорт
	
//	ОбработкаРезультатаОтчета(ПараметрыОтчета, Результат);
	
//	Если Результат.Области.Найти("Заголовок") = Неопределено Тогда
//		Результат.ФиксацияСверху = ПараметрыОтчета.ВысотаШапки;
//	Иначе
//		Результат.ФиксацияСверху = Результат.Области.Заголовок.Низ + ПараметрыОтчета.ВысотаШапки;
//	КонецЕсли;
//	
//	Результат.ФиксацияСлева = 0;
	
КонецПроцедуры

// Выполняет дополнительную обработку результата отчета после его формирования:
//	- настраивает параметры печати;
//	- устанавливает колонтитулы.
//
// Параметры:
//	ИдентификаторОтчета - Строка - Имя отчета.
//	Результат - ТабличныйДокумент - Результат формирования отчета.
//
Процедура ОбработкаРезультатаОтчета(ПараметрыОтчета, Результат) Экспорт
	
	// Выводим надписи вертикально, если количество точек диаграмм больше 9
	Для Каждого Рисунок Из Результат.Рисунки Цикл
		Попытка
			Если ТипЗнч(Рисунок.Объект) = Тип("Диаграмма") Тогда
				Рисунок.Объект.ОбластьПостроения.ВертикальныеМетки  = (Рисунок.Объект.Точки.Количество() > 9);
				Рисунок.Объект.ОбластьПостроения.ФорматШкалыЗначений = "ЧГ=3,0";
				Рисунок.Объект.ОбластьЛегенды.Рамка = Новый Рамка(ТипРамкиЭлементаУправления.Одинарная, 1);
				
				Рисунок.Объект.ПоложениеПодписейШкалыЗначенийИзмерительнойДиаграммы = ПоложениеПодписейШкалыЗначенийИзмерительнойДиаграммы.НаШкале;
				Рисунок.Объект.ПодписиШкалыЗначенийИзмерительнойДиаграммыВдольШкалы = Истина;
				Рисунок.Объект.ТолщинаШкалыИзмерительнойДиаграммы                   = 3;
				Рисунок.Объект.ФорматЗначенийВПодписях                              = "ЧДЦ=2; ЧГ=3,0";
			КонецЕсли;
		Исключение
		КонецПопытки;
	КонецЦикла;
	
	СоответствиеЗаголовковИНомеровКолонок = Новый Соответствие();
	СоответствиеЗаголовковИНомеровКолонок.Вставить("AR");
	СоответствиеЗаголовковИНомеровКолонок.Вставить("DSO");
	СоответствиеЗаголовковИНомеровКолонок.Вставить("Billing", Новый Соответствие());
	
	МесяцыПоПорядкуОбработки = Новый Массив;
	ТекСдвиг = 0;
	Пока ТекСдвиг >= -24 Цикл
		ТекМесяц = ДобавитьМесяц(НачалоМесяца(ПараметрыОтчета.Период), ТекСдвиг);
		МесяцСтрокой = Формат(ТекМесяц, "ДФ=dd.MM.yyyy;");
		МесяцыПоПорядкуОбработки.Добавить(Новый Структура("Месяц, МесяцСтрокой", ТекМесяц, МесяцСтрокой)); 
		СоответствиеЗаголовковИНомеровКолонок["Billing"].Вставить(МесяцСтрокой, 0);
		ТекСдвиг = ТекСдвиг - 1;
	КонецЦикла;
	
	// ищем строку с заголовками полей
	ШиринаТаблицы = Результат.ШиринаТаблицы;
	ВысотаТаблицы = Результат.ВысотаТаблицы;
	
	Для ТекНомерСтроки = 1 По ВысотаТаблицы Цикл
		
		Для ТекНомерКолонки = 1 По ШиринаТаблицы Цикл
			
			ТекстОбласти = Результат.Область(ТекНомерСтроки, ТекНомерКолонки).Текст;
			
			Если ТекстОбласти = "AR" Тогда
				Прервать;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ТекстОбласти = "AR" Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТекстОбласти = "AR" Тогда
		СоответствиеЗаголовковИНомеровКолонок["AR"] = ТекНомерКолонки;
		Для ТекНомерКолонки = 1 По ШиринаТаблицы Цикл
			ТекстОбласти = Результат.Область(ТекНомерСтроки, ТекНомерКолонки).Текст;
			Если ТекстОбласти = "DSO" Тогда
				СоответствиеЗаголовковИНомеровКолонок["DSO"] = ТекНомерКолонки;
			ИначеЕсли СоответствиеЗаголовковИНомеровКолонок["Billing"][ТекстОбласти] = 0 Тогда
				СоответствиеЗаголовковИНомеровКолонок["Billing"][ТекстОбласти] = ТекНомерКолонки;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли; 
	
	СоответствиеЗначенийБиллинга = Новый Соответствие();
	// Удалим строки с высотой равной 1
	Индекс = ВысотаТаблицы;
	Пока Индекс > 0 Цикл
//		ИндексСтроки = "R" + Формат(Индекс, "ЧГ=0");
//		Если Результат.Область(ИндексСтроки).ВысотаСтроки = 1 Тогда
//			Результат.УдалитьОбласть(Результат.Область(ИндексСтроки), ТипСмещенияТабличногоДокумента.ПоВертикали);
//		КонецЕсли;
		ТекстDSO = Результат.Область(Индекс, СоответствиеЗаголовковИНомеровКолонок["DSO"]).Текст;
		ТекстAR  = Результат.Область(Индекс, СоответствиеЗаголовковИНомеровКолонок["AR"]).Текст;
		Если ПустаяСтрока(ТекстDSO) И Не ПустаяСтрока(ТекстAR) Тогда
			Для Каждого КлючЗначение Из СоответствиеЗаголовковИНомеровКолонок["Billing"] Цикл
				БиллингТекст = Формат(СокрЛП(Результат.Область(Индекс, КлючЗначение.Значение).Текст), "ЧРГ=; ЧГ=0;");
				Если ПустаяСтрока(БиллингТекст) Тогда
					БиллингТекст = "0";
				КонецЕсли;
				СоответствиеЗначенийБиллинга.Вставить(КлючЗначение.Ключ, Число(БиллингТекст));
			КонецЦикла;
			ЗначениеDSO = РассчитатьDSO(Число(ТекстAR), СоответствиеЗначенийБиллинга, МесяцыПоПорядкуОбработки);
			Если ЗначениеDSO <> 0 Тогда
				Результат.Область(Индекс, СоответствиеЗаголовковИНомеровКолонок["DSO"]).Текст = Строка(ЗначениеDSO);
			КонецЕсли;
		КонецЕсли;
		Индекс = Индекс - 1;
	КонецЦикла;
	
	Результат.АвтоМасштаб = Истина;
	Результат.ПолеСлева   = 5;
	Результат.ПолеСправа  = 5;
	
	Результат.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_" + "DSODetails";
		
	//УправлениеКолонтитулами.УстановитьКолонтитулы(
	//	Результат, Метаданные.Отчеты[ИдентификаторОтчета].Синоним, Пользователи.ТекущийПользователь());

КонецПроцедуры
	
Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ВыводитьПолностью = Истина;
	
	Отказ = Ложь;
	ДанныеРасшифровкиОбъект = Неопределено;
	ПараметрыИсполненияОтчета = Неопределено;
	
	Попытка
		ПараметрыИсполненияОтчета = ПолучитьПараметрыИсполненияОтчета();
	Исключение
		// Запись в журнал регистрации не требуется
	КонецПопытки;
	
	ИспользоватьПриВыводеЗаголовка             = Ложь;
	ИспользоватьПриВыводеПодвала               = Ложь;
	ИспользоватьПередКомпоновкойМакета         = Ложь;
	ИспользоватьПослеКомпоновкиМакета          = Ложь;
	ИспользоватьПередВыводомЭлементаРезультата = Ложь;
	ИспользоватьПослеВыводаРезультата          = Ложь;
	ИспользоватьДанныеРасшифровки              = Истина;
	ИспользоватьПривилегированныйРежим         = Истина;
	
	Если ПараметрыИсполненияОтчета <> Неопределено Тогда
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПриВыводеЗаголовка") Тогда
			ИспользоватьПриВыводеЗаголовка = ПараметрыИсполненияОтчета.ИспользоватьПриВыводеЗаголовка;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПриВыводеПодвала") Тогда
			ИспользоватьПриВыводеПодвала = ПараметрыИсполненияОтчета.ИспользоватьПриВыводеПодвала;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПередКомпоновкойМакета") Тогда
			ИспользоватьПередКомпоновкойМакета = ПараметрыИсполненияОтчета.ИспользоватьПередКомпоновкойМакета;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПослеКомпоновкиМакета") Тогда
			ИспользоватьПослеКомпоновкиМакета = ПараметрыИсполненияОтчета.ИспользоватьПослеКомпоновкиМакета;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПередВыводомЭлементаРезультата") Тогда
			ИспользоватьПередВыводомЭлементаРезультата = ПараметрыИсполненияОтчета.ИспользоватьПередВыводомЭлементаРезультата;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПослеВыводаРезультата") Тогда
			ИспользоватьПослеВыводаРезультата = ПараметрыИсполненияОтчета.ИспользоватьПослеВыводаРезультата;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьДанныеРасшифровки") Тогда
			ИспользоватьДанныеРасшифровки = ПараметрыИсполненияОтчета.ИспользоватьДанныеРасшифровки;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПривилегированныйРежим") Тогда
			ИспользоватьПривилегированныйРежим = ПараметрыИсполненияОтчета.ИспользоватьПривилегированныйРежим;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыОтчета.СхемаКомпоновкиДанных) = Тип("Строка") Тогда
		Если ЭтоАдресВременногоХранилища(ПараметрыОтчета.СхемаКомпоновкиДанных) Тогда
			СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(ПараметрыОтчета.СхемаКомпоновкиДанных);
		КонецЕсли;
	Иначе
		СхемаКомпоновкиДанных = ПараметрыОтчета.СхемаКомпоновкиДанных;
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ПараметрыОтчета.НастройкиКомпоновкиДанных);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	ВыводитьЗаголовок = Истина;
	ВыводитьПодвал    = Истина;
	
	Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ВыводитьЗаголовок") Тогда
		ВыводитьЗаголовок = КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВыводитьЗаголовок;
	КонецЕсли;
	Если КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Свойство("ВыводитьПодвал") Тогда
		ВыводитьПодвал = КомпоновщикНастроек.Настройки.ДополнительныеСвойства.ВыводитьПодвал;
	КонецЕсли;

	Результат = Новый ТабличныйДокумент;
	
	Если ВыводитьЗаголовок Тогда
		Если ИспользоватьПриВыводеЗаголовка Тогда
			ПриВыводеЗаголовка(ПараметрыОтчета, КомпоновщикНастроек, Результат);
		Иначе
			ВывестиЗаголовокОтчета(ПараметрыОтчета, КомпоновщикНастроек, Результат);
		КонецЕсли;
	КонецЕсли;
	
	Если ВыводитьПолностью Тогда
		Если ИспользоватьПередКомпоновкойМакета Тогда
			ПередКомпоновкойМакета(ПараметрыОтчета, СхемаКомпоновкиДанных, КомпоновщикНастроек);
		КонецЕсли;
		
		//КомпоновщикНастроек.Восстановить();
		
		НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
		
		УстановитьМакетОформленияОтчета(ПараметрыОтчета, НастройкиДляКомпоновкиМакета);
		
		// Сгенерируем макет компоновки данных при помощи компоновщика макета
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		
		Попытка
			
			// В качестве схемы компоновки будет выступать схема самого отчета.
			// В качестве настроек отчета - текущие настройки отчета.
			// Данные расшифровки будем помещать в ДанныеРасшифровки.
			Если ИспользоватьДанныеРасшифровки Тогда 
				МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета, ДанныеРасшифровкиОбъект);
			Иначе
				МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета);
			КонецЕсли;
			
			// Вызываем событие отчета
			Если ИспользоватьПослеКомпоновкиМакета Тогда
				ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки);
			КонецЕсли;
			
			// Создадим и инициализируем процессор компоновки
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровкиОбъект, Истина);
			
			// Создадим и инициализируем процессор вывода результата
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
			ПроцессорВывода.УстановитьДокумент(Результат);
			
			// Перед началом вывода установим привилегированный режим
			Если ИспользоватьПривилегированныйРежим Тогда
				УстановитьПривилегированныйРежим(Истина);
			КонецЕсли;
		
			// Обозначим начало вывода
			ПроцессорВывода.НачатьВывод();
			
			Если ИспользоватьПередВыводомЭлементаРезультата Тогда
				// Основной цикл вывода отчета
				Пока Истина Цикл
					
					// Получим следующий элемент результата компоновки
					ЭлементРезультата = ПроцессорКомпоновки.Следующий();
					
					Если ЭлементРезультата = Неопределено Тогда
						// Следующий элемент не получен - заканчиваем цикл вывода
						Прервать;
					Иначе
						
						Отказ = Ложь;
						
						ПередВыводомЭлементаРезультата(ПараметрыОтчета, МакетКомпоновки, ДанныеРасшифровкиОбъект, ЭлементРезультата, Отказ);
						
						Если Не Отказ Тогда
							// Элемент получен - выведем его при помощи процессора вывода
							ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
						КонецЕсли;	
					КонецЕсли;
				КонецЦикла;
				
				// Завершение вывода отчета
				ПроцессорВывода.ЗакончитьВывод();
			Иначе
				ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			КонецЕсли;
			
			// После окончания процессором вывода отчета, поместим расшифровку во временное хранилище.
			ДанныеДляРасшифровки = Новый Структура("Объект, ДанныеРасшифровки", ПараметрыОтчета, ДанныеРасшифровкиОбъект); 
			ДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеДляРасшифровки, ПараметрыОтчета.ДанныеРасшифровки);
			
			// Отключаем привилегированный режим если он использовался
			Если ИспользоватьПривилегированныйРежим Тогда
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли;
			
		Исключение
			// Запись в журнал регистрации не требуется
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Пока ИнформацияОбОшибке.Причина <> Неопределено Цикл
				ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
			КонецЦикла;
			ТекстСообщения = НСтр("ru = 'Отчет не сформирован! %1'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ТекстСообщения, ИнформацияОбОшибке.Описание));
			Отказ = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
	Если Не Отказ Тогда
		Если ВыводитьПодвал Тогда
			Если ИспользоватьПриВыводеПодвала Тогда 
				ПриВыводеПодвала(ПараметрыОтчета, Результат);
			Иначе
				ВывестиПодвалОтчета(ПараметрыОтчета, КомпоновщикНастроек, Результат);
			КонецЕсли;
		КонецЕсли;
		
		Если ИспользоватьПослеВыводаРезультата Тогда
			ПослеВыводаРезультата(ПараметрыОтчета, Результат);
		Иначе
			ОбработкаРезультатаОтчета(ПараметрыОтчета, Результат);
		КонецЕсли;
	КонецЕсли;
	
	// Если по каким-либо причинам отчет не был сформирован, адрес расшифровки оставляем прежним,
	// чтобы использовать его повторно при следующем формировании отчета.
	Если Отказ Тогда
		ДанныеРасшифровки = ПараметрыОтчета.ДанныеРасшифровки;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Новый Структура("Результат,ДанныеРасшифровки", Результат, ДанныеРасшифровки), АдресХранилища);
	
КонецПроцедуры

// Задает набор показателей, которые позволяет анализировать отчет.
//
// Возвращаемое значение:
//   Массив      - основные суммовые показатели отчета.
//
Функция ПолучитьНаборПоказателей() Экспорт
	
	НаборПоказателей = Новый Массив;
	НаборПоказателей.Добавить("Billing");
	
	Возврат НаборПоказателей;
	
КонецФункции

Функция РассчитатьDSO(AR, СоответствиеЗначенийБиллинга, МесяцыПоПорядкуОбработки)
	
	ТекAR = AR;
	
	Если (ТекAR <= 0) Тогда
		Возврат 0;
	КонецЕсли;
	
	DSO = 0;
	
	Для Каждого ТекСтруктураМесяца Из МесяцыПоПорядкуОбработки Цикл
		
		ТекущийБиллинг = СоответствиеЗначенийБиллинга[ТекСтруктураМесяца.МесяцСтрокой];
		
		Если ТекAR > 0 И ТекAR >= ТекущийБиллинг Тогда
			DSO = DSO + День(КонецМесяца(ТекСтруктураМесяца.Месяц));
		ИначеЕсли ТекAR > 0 Тогда
			DSO = DSO + Окр(День(КонецМесяца(ТекСтруктураМесяца.Месяц)) * ТекAR / ТекущийБиллинг, 2);
		Иначе
			Прервать;
		КонецЕсли;
		
		ТекAR = ТекAR - ТекущийБиллинг;
		
		Если ТекAR <= 0 Тогда
			Прервать;
		КонецЕсли;
		 
	КонецЦикла;
	
	Возврат DSO;
	
КонецФункции

#КонецЕсли