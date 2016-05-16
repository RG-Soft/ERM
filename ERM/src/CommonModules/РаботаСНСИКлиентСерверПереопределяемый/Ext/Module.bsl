﻿
///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ТИПОВ

//Функция описание типа договора
//
Функция ПолучитьОписаниеТиповДоговора() Экспорт
	
	Возврат Новый ОписаниеТипов("СправочникСсылка.ДоговорыКонтрагентов");
	
КонецФункции

//Функция возвращает описание типа банковского счета организации
//
Функция ТипЗначенияБанковскогоСчетаОрганизации() Экспорт
	
	Возврат Тип("СправочникСсылка.БанковскиеСчета");

КонецФункции

// Функция ПолучитьОписаниеТиповБанковскогоСчетаОрганизации ОписаниеТипов
// для банковских счетов организаций.
//
Функция ПолучитьОписаниеТиповБанковскогоСчетаОрганизации() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.БанковскиеСчета");	

КонецФункции // ПолучитьОписаниеТиповБанковскогоСчетаОрганизации()

// Функция ОписаниеТиповПодразделения возвращает 
// описание типов для справочника подразделений.
//
Функция ОписаниеТиповПодразделения() Экспорт

	Возврат Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");

КонецФункции

//Функция возвращает тип для справочника подразделений.
//
Функция ТипПодразделения() Экспорт
	
	Возврат Тип("СправочникСсылка.ПодразделенияОрганизаций");

КонецФункции

///////////////////////////////////////////////////////////////////////////////
// ФУНКЦИИ ОПРЕДЕЛЕНИЯ ИМЕН РЕКВИЗИТОВ

// Функция ПолучитьИмяРеквизитаКонтрагентДоговора имя реквизита в справочнике
// ДоговорыКонтрагентов, в котором храниться ссылка на контрагента-владельца.
//
Функция ПолучитьИмяРеквизитаКонтрагентДоговора() Экспорт

	Возврат "Владелец";

КонецФункции

// Функция ПолучитьИмяРеквизитаВидДоговора имя реквизита в справочнике
// ДоговорыКонтрагентов, по которому определяется вид договора.
//
Функция ПолучитьИмяРеквизитаВидДоговора() Экспорт

	Возврат "ВидДоговора";

КонецФункции

// Функция возвращает строку с именем реквизита в справочнике подразделений,
// определяющего организацию подразделения, либо пустую строку, если справочник 
// подразделений не является подчиненным справочником.
//
Функция ИмяРеквизитаОрганизацияПодразделения() Экспорт
	
	Возврат "Владелец";

КонецФункции
