﻿// Конвертация ERM от 18.03.2016 17:12:39
#Область ПроцедурыКонвертации
Процедура ПередКонвертацией(КомпонентыОбмена) Экспорт
	
КонецПроцедуры

Процедура ПослеКонвертации(КомпонентыОбмена) Экспорт
	
КонецПроцедуры

Процедура ПередОтложеннымЗаполнением(КомпонентыОбмена) Экспорт
	
КонецПроцедуры

#КонецОбласти
#Область ПОД
// Заполняет таблицу правил обработки данных.
//
// Параметры:
//  НаправлениеОбмена - строка ("Отправка" либо "Получение").
//  ПравилаОбработкиДанных - таблица значений, в которую добавляются правила. 
Процедура ЗаполнитьПравилаОбработкиДанных(НаправлениеОбмена, ПравилаОбработкиДанных) Экспорт
	Если НаправлениеОбмена = "Отправка" Тогда
	Если ПравилаОбработкиДанных.Колонки.Найти("ОчисткаДанных") = Неопределено Тогда
	    ПравилаОбработкиДанных.Колонки.Добавить("ОчисткаДанных");
	КонецЕсли;
		ДобавитьПОД_Справочник_Контрагенты_Отправка(ПравилаОбработкиДанных);
	КонецЕсли;
КонецПроцедуры

#Область Отправка
#Область Справочник_Контрагенты_Отправка
Процедура ДобавитьПОД_Справочник_Контрагенты_Отправка(ПравилаОбработкиДанных)
	ПравилоОбработки = ПравилаОбработкиДанных.Добавить();
	ПравилоОбработки.Имя = "Справочник_Контрагенты_Отправка";
	ПравилоОбработки.ОбъектВыборкиМетаданные = Метаданные.Справочники.Контрагенты;
	ПравилоОбработки.ОчисткаДанных = Ложь;
	ПравилоОбработки.ИспользуемыеПКО.Добавить("Справочник_Контрагенты_Отправка");
КонецПроцедуры
#КонецОбласти
#КонецОбласти

#КонецОбласти
#Область ПКО
// Заполняет таблицу правил конвертации объектов.
//
// Параметры:
//  НаправлениеОбмена - строка ("Отправка" либо "Получение").
//  ПравилаКонвертации - таблица значений, в которую добавляются правила. 
Процедура ЗаполнитьПравилаКонвертацииОбъектов(НаправлениеОбмена, ПравилаКонвертации) Экспорт
	Если НаправлениеОбмена = "Отправка" Тогда
		ДобавитьПКО_Справочник_Контрагенты_Отправка(ПравилаКонвертации);
	КонецЕсли;
КонецПроцедуры

#Область Отправка
#Область Справочник_Контрагенты_Отправка
Процедура ДобавитьПКО_Справочник_Контрагенты_Отправка(ПравилаКонвертации)

	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Контрагенты_Отправка";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Контрагенты;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Контрагенты";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоУникальномуИдентификатору";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ДополнительнаяИнформация";
	НоваяСтрока.СвойствоФормата = "ДополнительнаяИнформация";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ИНН";
	НоваяСтрока.СвойствоФормата = "ИНН";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КодПоОКПО";
	НоваяСтрока.СвойствоФормата = "ОКПО";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КПП";
	НоваяСтрока.СвойствоФормата = "КПП";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Наименование";
	НоваяСтрока.СвойствоФормата = "Наименование";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Родитель";
	НоваяСтрока.СвойствоФормата = "Группа";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ЮридическоеФизическоеЛицо";
	НоваяСтрока.СвойствоФормата = "ЮридическоеФизическоеЛицо";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Перечисление_ЮридическоеФизическоеЛицо";

КонецПроцедуры
#КонецОбласти
#КонецОбласти

#КонецОбласти
#Область ПКПД
// Заполняет таблицу правил конвертации предопределенных данных.
//
// Параметры:
//  НаправлениеОбмена - строка ("Отправка" либо "Получение").
//  ПравилаКонвертации - таблица значений, в которую будут добавлены правила. 
Процедура ЗаполнитьПравилаКонвертацииПредопределенныхДанных(НаправлениеОбмена, ПравилаКонвертации) Экспорт

	// Перечисление_ЮридическоеФизическоеЛицо.
	ПравилоКонвертации = ПравилаКонвертации.Добавить();
	ПравилоКонвертации.ИмяПКПД = "Перечисление_ЮридическоеФизическоеЛицо";
	ПравилоКонвертации.ТипДанных = Метаданные.Перечисления.ЮридическоеФизическоеЛицо;
	ПравилоКонвертации.ТипXDTO = "ЮридическоеФизическоеЛицо";

	ЗначенияДляОтправки = Новый Соответствие;
	ЗначенияДляОтправки.Вставить(Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо, "ФизическоеЛицо");
	ЗначенияДляОтправки.Вставить(Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, "ЮридическоеЛицо");
	ПравилоКонвертации.КонвертацииЗначенийПриОтправке = ЗначенияДляОтправки;
	ЗначенияДляПолучения = Новый Соответствие;
	ЗначенияДляПолучения.Вставить("ФизическоеЛицо", Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
	ЗначенияДляПолучения.Вставить("ЮридическоеЛицо", Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
	ПравилоКонвертации.КонвертацииЗначенийПриПолучении = ЗначенияДляПолучения;

КонецПроцедуры

#КонецОбласти
#Область Алгоритмы



#КонецОбласти
#Область Параметры
// Заполняет параметры конвертации.
//
// Параметры:
//  ПараметрыКонвертации - структура, в которую добавляются параметры конвертации.
Процедура ЗаполнитьПараметрыКонвертации(ПараметрыКонвертации) Экспорт
КонецПроцедуры

#КонецОбласти
#Область ОбщегоНазначения
// Процедура-обертка, выполняет запуск указанной в параметрах процедуры модуля менеджера обмена через формат.
//
// Параметры:
//  ИмяПроцедуры - строка.
//  СтруктураПараметров - структура, содержащая передаваемые параметры.
Процедура ВыполнитьПроцедуруМодуляМенеджера(ИмяПроцедуры, Параметры) Экспорт
КонецПроцедуры

#КонецОбласти
