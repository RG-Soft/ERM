﻿// Конвертация ERM от 13.04.2016 3:27:36
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
		ДобавитьПОД_Справочник_Банки_Отправка(ПравилаОбработкиДанных);
		ДобавитьПОД_Справочник_БанковскиеСчета_Отправка(ПравилаОбработкиДанных);
		ДобавитьПОД_Справочник_Контрагенты_Отправка(ПравилаОбработкиДанных);
	КонецЕсли;
КонецПроцедуры

#Область Отправка
#Область Справочник_Банки_Отправка
Процедура ДобавитьПОД_Справочник_Банки_Отправка(ПравилаОбработкиДанных)
	ПравилоОбработки = ПравилаОбработкиДанных.Добавить();
	ПравилоОбработки.Имя = "Справочник_Банки_Отправка";
	ПравилоОбработки.ОбъектВыборкиМетаданные = Метаданные.Справочники.Банки;
	ПравилоОбработки.ОчисткаДанных = Ложь;
	ПравилоОбработки.ИспользуемыеПКО.Добавить("Справочник_Банки_Отправка");
КонецПроцедуры
#КонецОбласти
#Область Справочник_БанковскиеСчета_Отправка
Процедура ДобавитьПОД_Справочник_БанковскиеСчета_Отправка(ПравилаОбработкиДанных)
	ПравилоОбработки = ПравилаОбработкиДанных.Добавить();
	ПравилоОбработки.Имя = "Справочник_БанковскиеСчета_Отправка";
	ПравилоОбработки.ОбъектВыборкиМетаданные = Метаданные.Справочники.БанковскиеСчета;
	ПравилоОбработки.ОчисткаДанных = Ложь;
	ПравилоОбработки.ИспользуемыеПКО.Добавить("Справочник_БанковскиеСчета_Отправка");
КонецПроцедуры
#КонецОбласти
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
		ДобавитьПКО_Справочник_Банки_Отправка(ПравилаКонвертации);
		ДобавитьПКО_Справочник_БанковскиеСчета_Отправка(ПравилаКонвертации);
		ДобавитьПКО_Справочник_Валюты_Отправка(ПравилаКонвертации);
		ДобавитьПКО_Справочник_Контрагенты_Отправка(ПравилаКонвертации);
		ДобавитьПКО_Справочник_СтраныМира(ПравилаКонвертации);
	КонецЕсли;
КонецПроцедуры

#Область Отправка
#Область Справочник_Банки_Отправка
Процедура ДобавитьПКО_Справочник_Банки_Отправка(ПравилаКонвертации)

	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Банки_Отправка";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Банки;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Банки";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоУникальномуИдентификатору";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Адрес";
	НоваяСтрока.СвойствоФормата = "Адрес";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Город";
	НоваяСтрока.СвойствоФормата = "Город";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Код";
	НоваяСтрока.СвойствоФормата = "БИК";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КоррСчет";
	НоваяСтрока.СвойствоФормата = "КоррСчет";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Наименование";
	НоваяСтрока.СвойствоФормата = "Наименование";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Телефоны";
	НоваяСтрока.СвойствоФормата = "Телефоны";

КонецПроцедуры
#КонецОбласти
#Область Справочник_БанковскиеСчета_Отправка
Процедура ДобавитьПКО_Справочник_БанковскиеСчета_Отправка(ПравилаКонвертации)

	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_БанковскиеСчета_Отправка";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.БанковскиеСчета;
	ПравилоКонвертации.ОбъектФормата = "Справочник.БанковскиеСчета";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоУникальномуИдентификатору";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Банк";
	НоваяСтрока.СвойствоФормата = "Банк";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Банки_Отправка";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "БанкДляРасчетов";
	НоваяСтрока.СвойствоФормата = "БанкДляРасчетов";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Банки_Отправка";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ВалютаДенежныхСредств";
	НоваяСтрока.СвойствоФормата = "ВалютаДенежныхСредств";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Валюты_Отправка";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ВидСчета";
	НоваяСтрока.СвойствоФормата = "ВидСчета";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Владелец";
	НоваяСтрока.СвойствоФормата = "Владелец";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Контрагенты_Отправка";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Наименование";
	НоваяСтрока.СвойствоФормата = "Наименование";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "НомерСчета";
	НоваяСтрока.СвойствоФормата = "НомерСчета";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ТекстКорреспондента";
	НоваяСтрока.СвойствоФормата = "ТекстКорреспондента";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ТекстНазначения";
	НоваяСтрока.СвойствоФормата = "ТекстНазначения";

КонецПроцедуры
#КонецОбласти
#Область Справочник_Валюты_Отправка
Процедура ДобавитьПКО_Справочник_Валюты_Отправка(ПравилаКонвертации)

	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Валюты_Отправка";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Валюты;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Валюты";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоУникальномуИдентификатору";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Код";
	НоваяСтрока.СвойствоФормата = "Код";

КонецПроцедуры
#КонецОбласти
#Область Справочник_Контрагенты_Отправка
Процедура ДобавитьПКО_Справочник_Контрагенты_Отправка(ПравилаКонвертации)

	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Контрагенты_Отправка";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Контрагенты;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Контрагенты";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ПриОтправкеДанных = "ПКО_Справочник_Контрагенты_Отправка_ПриОтправкеДанных";
	ПравилоКонвертации.ВариантИдентификации = "ПоУникальномуИдентификатору";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "CreditRating";
	НоваяСтрока.СвойствоФормата = "CreditRating";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Перечисление_CreditRating";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "CRMID";
	НоваяСтрока.СвойствоФормата = "CRMID";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ДополнительнаяИнформация";
	НоваяСтрока.СвойствоФормата = "ДополнительнаяИнформация";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ДополнительнаяИнформация";
	НоваяСтрока.СвойствоФормата = "ДополнительнаяИнформация";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ИНН";
	НоваяСтрока.СвойствоФормата = "ИНН";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КодКлассификатора";
	НоваяСтрока.СвойствоФормата = "КодКлассификатора";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КодПоОКПО";
	НоваяСтрока.СвойствоФормата = "ОКПО";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КПП";
	НоваяСтрока.СвойствоФормата = "КПП";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ЛокальноеНаименование";
	НоваяСтрока.СвойствоФормата = "ЛокальноеНаименование";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Наименование";
	НоваяСтрока.СвойствоФормата = "Наименование";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "НаименованиеПолное";
	НоваяСтрока.СвойствоФормата = "НаименованиеПолное";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "НалоговыйНомер";
	НоваяСтрока.СвойствоФормата = "НалоговыйНомерНерезидента";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ОбособленноеПодразделение";
	НоваяСтрока.СвойствоФормата = "ОбособленноеПодразделение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "РегистрационныйНомер";
	НоваяСтрока.СвойствоФормата = "РегистрационныйНомерНерезидента";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Родитель";
	НоваяСтрока.СвойствоФормата = "Группа";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ЮридическоеФизическоеЛицо";
	НоваяСтрока.СвойствоФормата = "ЮридическоеФизическоеЛицо";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Перечисление_ЮридическоеФизическоеЛицо";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоФормата = "ГоловнойКонтрагент";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Контрагенты_Отправка";
	ПравилоКонвертации.СвойстваТабличныхЧастей.Вставить("КонтактнаяИнформация", ОбменДаннымиXDTOСервер.ИнициализироватьТаблицуСвойствДляПравилаКонвертации());
	СвойстваТЧ = ПравилоКонвертации.СвойстваТабличныхЧастей.КонтактнаяИнформация;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "ВидКонтактнойИнформации";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "ЗначенияПолей";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "НаименованиеКонтактнойИнформации";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	ПравилоКонвертации.СвойстваТабличныхЧастей.Вставить("КонтактнаяИнформацияСтарыйФормат", ОбменДаннымиXDTOСервер.ИнициализироватьТаблицуСвойствДляПравилаКонвертации());
	СвойстваТЧ = ПравилоКонвертации.СвойстваТабличныхЧастей.КонтактнаяИнформацияСтарыйФормат;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "ВидКонтактнойИнформации";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "ЗначениеПоУмолчанию";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Комментарий";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле1";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле10";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле2";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле3";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле4";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле5";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле6";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле7";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле8";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Поле9";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "Представление";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "ТипДома";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "ТипКвартиры";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоФормата = "ТипКорпуса";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;

КонецПроцедуры

Процедура ПКО_Справочник_Контрагенты_Отправка_ПриОтправкеДанных(ДанныеИБ, ДанныеXDTO, КомпонентыОбмена, СтекВыгрузки)
	Если ЗначениеЗаполнено(ДанныеИБ.ГоловнойКонтрагент) И ДанныеИБ.ГоловнойКонтрагент <> ДанныеИБ.Ссылка Тогда
		ДанныеXDTO.Вставить("ГоловнойКонтрагент", ДанныеИБ.ГоловнойКонтрагент);
	Иначе
		ДанныеXDTO.Вставить("ГоловнойКонтрагент", Неопределено);
	КонецЕсли;
	
	Если ДанныеИБ.СтранаРегистрации <> Справочники.СтраныМира.Россия Тогда
		ДанныеXDTO.Вставить("СтранаРегистрации", ДанныеИБ.СтранаРегистрации);
		ДанныеXDTO.Вставить("НалоговыйНомерНерезидента", ДанныеИБ.ИНН);
	Иначе
		ДанныеXDTO.Вставить("СтранаРегистрации", Неопределено);
	КонецЕсли;
	
	ПодготовитьДанныеКонтактнаяИнформация(ДанныеИБ, ДанныеXDTO);
	ПодготовитьДанныеКонтактнаяИнформацияСтарыйФормат(ДанныеИБ, ДанныеXDTO);
КонецПроцедуры
#КонецОбласти
#Область Справочник_СтраныМира
Процедура ДобавитьПКО_Справочник_СтраныМира(ПравилаКонвертации)

	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_СтраныМира";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.СтраныМира;
	ПравилоКонвертации.ОбъектФормата = "Справочник.СтраныМира";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоУникальномуИдентификатору";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Код";
	НоваяСтрока.СвойствоФормата = "Код";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КодАльфа2";
	НоваяСтрока.СвойствоФормата = "КодАльфа2";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КодАльфа3";
	НоваяСтрока.СвойствоФормата = "КодАльфа3";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Наименование";
	НоваяСтрока.СвойствоФормата = "Наименование";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "НаименованиеПолное";
	НоваяСтрока.СвойствоФормата = "НаименованиеПолное";

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
	Если НаправлениеОбмена = "Отправка" Тогда
		// ВидыКИ_Отправка.
		ПравилоКонвертации = ПравилаКонвертации.Добавить();
		ПравилоКонвертации.ИмяПКПД = "ВидыКИ_Отправка";
		ПравилоКонвертации.ТипДанных = Метаданные.Справочники.ВидыКонтактнойИнформации;
		ПравилоКонвертации.ТипXDTO = "ВидыКИ";
	
		ЗначенияДляОтправки = Новый Соответствие;
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.EmailКонтактныеЛица, "АдресЭлектроннойПочты");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.EmailКонтрагенты, "АдресЭлектроннойПочты");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.EmailОрганизации, "АдресЭлектроннойПочты");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.EmailПользователя, "АдресЭлектроннойПочты");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.АдресДляИнформированияКонтактныеЛица, "ПочтовыйАдрес");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтактныеЛица, "ПользовательскаяКИДругое");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтрагенты, "ПользовательскаяКИДругое");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияОрганизации, "ПользовательскаяКИДругое");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресКонтрагента, "ПочтовыйАдрес");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ПочтовыйАдресОрганизации, "ПочтовыйАдрес");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ТелефонКонтрагента, "Телефон");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ТелефонМобильныйКонтактныеЛица, "Телефон");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ТелефонОрганизации, "Телефон");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ТелефонПользователя, "Телефон");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ТелефонРабочийКонтактныеЛица, "ТелефонРабочий");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ФаксКонтрагенты, "Факс");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ФаксОрганизации, "Факс");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ФактАдресКонтрагента, "ФактическийАдрес");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ФактАдресОрганизации, "ФактическийАдрес");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ЮрАдресКонтрагента, "ЮридическийАдрес");
		ЗначенияДляОтправки.Вставить(Справочники.ВидыКонтактнойИнформации.ЮрАдресОрганизации, "ЮридическийАдрес");
		ПравилоКонвертации.КонвертацииЗначенийПриОтправке = ЗначенияДляОтправки;
	КонецЕсли;

	// Перечисление_CreditRating.
	ПравилоКонвертации = ПравилаКонвертации.Добавить();
	ПравилоКонвертации.ИмяПКПД = "Перечисление_CreditRating";
	ПравилоКонвертации.ТипДанных = Метаданные.Перечисления.CreditRating;
	ПравилоКонвертации.ТипXDTO = "CreditRating";

	ЗначенияДляОтправки = Новый Соответствие;
	ЗначенияДляОтправки.Вставить(Перечисления.CreditRating.Banned, "Banned");
	ЗначенияДляОтправки.Вставить(Перечисления.CreditRating.Conditional, "Conditional");
	ЗначенияДляОтправки.Вставить(Перечисления.CreditRating.Limited, "Limited");
	ЗначенияДляОтправки.Вставить(Перечисления.CreditRating.Unlimited, "Unlimited");
	ПравилоКонвертации.КонвертацииЗначенийПриОтправке = ЗначенияДляОтправки;
	ЗначенияДляПолучения = Новый Соответствие;
	ЗначенияДляПолучения.Вставить("Banned", Перечисления.CreditRating.Banned);
	ЗначенияДляПолучения.Вставить("Conditional", Перечисления.CreditRating.Conditional);
	ЗначенияДляПолучения.Вставить("Limited", Перечисления.CreditRating.Limited);
	ЗначенияДляПолучения.Вставить("Unlimited", Перечисления.CreditRating.Unlimited);
	ПравилоКонвертации.КонвертацииЗначенийПриПолучении = ЗначенияДляПолучения;

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


Процедура ПодготовитьДанныеКонтактнаяИнформация(ДанныеИБ, ДанныеXDTO)
	Если ДанныеИБ.КонтактнаяИнформация.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ТабКонтактнаяИнформация = Новый ТаблицаЗначений;
	ТабКонтактнаяИнформация.Колонки.Добавить("ЗначенияПолей");
	ТабКонтактнаяИнформация.Колонки.Добавить("ВидКонтактнойИнформации");
	ТабКонтактнаяИнформация.Колонки.Добавить("НаименованиеКонтактнойИнформации");
	Для Каждого СтрокаКИ ИЗ ДанныеИБ.КонтактнаяИнформация цикл
		Если НЕ ЗначениеЗаполнено(СтрокаКИ.Вид)
			ИЛИ НЕ ЗначениеЗаполнено(СтрокаКИ.ЗначенияПолей) Тогда
			Продолжить;
		КонецЕсли;
		
		СвойстваВидаКИ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаКИ.Вид, "Наименование,Предопределенный");
		
		СтрокаТЗКИ = ТабКонтактнаяИнформация.Добавить();
		СтрокаТЗКИ.ЗначенияПолей = СокрЛП(СтрокаКИ.ЗначенияПолей);
		Если СвойстваВидаКИ.Предопределенный И СтрокаКИ.Вид <> Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияОрганизации
			И СтрокаКИ.Вид <> Справочники.ВидыКонтактнойИнформации.ДругаяИнформацияКонтрагенты Тогда
			СтрокаТЗКИ.ВидКонтактнойИнформации = СтрокаКИ.Вид;
		Иначе
			// Получение наименования значения перечисления.
			ИндексТипаКИ = Перечисления.ТипыКонтактнойИнформации.Индекс(СтрокаКИ.Тип);
			ИмяТипаКИ = Метаданные.Перечисления.ТипыКонтактнойИнформации.ЗначенияПеречисления[ИндексТипаКИ].Имя;
	
			СтрокаТЗКИ.ВидКонтактнойИнформации = "ПользовательскаяКИ"+ИмяТипаКИ;
			СтрокаТЗКИ.НаименованиеКонтактнойИнформации = СвойстваВидаКИ.Наименование;
		КонецЕсли;
	КонецЦикла;
	ДанныеXDTO.Вставить("КонтактнаяИнформация", ТабКонтактнаяИнформация);
КонецПроцедуры
Процедура ПодготовитьДанныеКонтактнаяИнформацияСтарыйФормат(ДанныеИБ, ДанныеXDTO)
	Если ДанныеИБ.КонтактнаяИнформация.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Строки = Новый ТаблицаЗначений;
	Строки.Колонки.Добавить("ВидКонтактнойИнформации");
	Строки.Колонки.Добавить("Тип");
	Строки.Колонки.Добавить("Поле1");
	Строки.Колонки.Добавить("Поле2");
	Строки.Колонки.Добавить("Поле3");
	Строки.Колонки.Добавить("Поле4");
	Строки.Колонки.Добавить("Поле5");
	Строки.Колонки.Добавить("Поле6");
	Строки.Колонки.Добавить("Поле7");
	Строки.Колонки.Добавить("Поле8");
	Строки.Колонки.Добавить("Поле9");
	Строки.Колонки.Добавить("ТипДома");
	Строки.Колонки.Добавить("ТипКвартиры");
	Строки.Колонки.Добавить("ТипКорпуса");
	Строки.Колонки.Добавить("Представление");
	Строки.Колонки.Добавить("Комментарий");
	Строки.Колонки.Добавить("ЭтоПроизвольнаяСтрока", Новый ОписаниеТипов("Булево"));
	
	// Типы дома, корпуса и квартиры, которые поддерживаются в БП
	ТипыДомов = Новый Массив;
	ТипыДомов.Добавить("дом");
	ТипыДомов.Добавить("владение");
	
	ТипыКорпусов = Новый Массив;
	ТипыКорпусов.Добавить("корпус");
	ТипыКорпусов.Добавить("строение");
	
	ТипыКвартир = Новый Массив;
	ТипыКвартир.Добавить("кв.");
	ТипыКвартир.Добавить("оф.");
	ТипыКвартир.Добавить("офис");
	ТипыКвартир.Добавить("квартира");
	
	// Заполнение набора
	Для Каждого СтрокаКИ Из ДанныеИБ.КонтактнаяИнформация Цикл
		
		// Получаем структуру значений полей
		СтруктураПолей		= Новый Структура;
		ПоследнийЭлементИмя	= Неопределено;
		СтрокаПолей			= СтрокаКИ.ЗначенияПолей;
		СтарыйФорматХранения = Истина;
		
		Если УправлениеКонтактнойИнформациейКлиентСервер.ЭтоКонтактнаяИнформацияВXML(СтрокаКИ.ЗначенияПолей) Тогда
			СтарыйФорматХранения = Ложь;
			СтрокаПолей = УправлениеКонтактнойИнформацией.ПредыдущийФорматКонтактнойИнформацииXML(СтрокаКИ.ЗначенияПолей, Истина);
		Иначе
			СтрокаПолей = СтрокаКИ.ЗначенияПолей;
		КонецЕсли;
		
		Для Сч = 1 По СтрЧислоСтрок(СтрокаПолей) Цикл
			Стр = СтрПолучитьСтроку(СтрокаПолей, Сч);
			Если Лев(Стр, 1) = Символы.Таб Тогда
				Если ПоследнийЭлементИмя <> Неопределено Тогда
					СтруктураПолей[ПоследнийЭлементИмя] = СтруктураПолей[ПоследнийЭлементИмя] + Символы.ПС + Сред(Стр, 2);
				КонецЕсли;
			Иначе
				Поз = Найти(Стр, "=");
				Если Поз <> 0 Тогда
					ПоследнийЭлементИмя = Лев(Стр, Поз-1);
					СтруктураПолей.Вставить(ПоследнийЭлементИмя, Сред(Стр, Поз+1));
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		СтрокаНабора = Строки.Добавить();
		СтрокаНабора.ВидКонтактнойИнформации = СтрокаКИ.Вид;
		СтрокаНабора.Тип					 = СтрокаКИ.Тип;
		СтрокаНабора.Представление			 = СтрокаКИ.Представление;
		
		Если СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Факс
			ИЛИ СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Телефон Тогда
			СтруктураПолей.Свойство("КодСтраны", СтрокаНабора.Поле1);
			СтруктураПолей.Свойство("КодГорода", СтрокаНабора.Поле2);
			СтруктураПолей.Свойство("НомерТелефона", СтрокаНабора.Поле3);
			СтруктураПолей.Свойство("Добавочный", СтрокаНабора.Поле4);
		ИначеЕсли СтрокаКИ.Тип = Перечисления.ТипыКонтактнойИнформации.Адрес Тогда
			
			СтруктураПолей.Свойство("Индекс", СтрокаНабора.Поле1);
			СтруктураПолей.Свойство("Регион", СтрокаНабора.Поле2);
			СтруктураПолей.Свойство("Район", СтрокаНабора.Поле3);
			СтруктураПолей.Свойство("Город", СтрокаНабора.Поле4);
			СтруктураПолей.Свойство("НаселенныйПункт", СтрокаНабора.Поле5);
			СтруктураПолей.Свойство("Улица", СтрокаНабора.Поле6);
			СтруктураПолей.Свойство("Дом", СтрокаНабора.Поле7);
			СтруктураПолей.Свойство("Корпус", СтрокаНабора.Поле8);
			СтруктураПолей.Свойство("Квартира", СтрокаНабора.Поле9);
			
			СтруктураПолей.Свойство("ТипДома", СтрокаНабора.ТипДома);
			СтруктураПолей.Свойство("ТипКорпуса", СтрокаНабора.ТипКорпуса);
			СтруктураПолей.Свойство("ТипКвартиры", СтрокаНабора.ТипКвартиры);
			
			// Проверяем значения типа дома, корпуса и квартиры
			СтрокаНабора.ТипДома	 = ?(ТипыДомов.Найти(НРег(СтрокаНабора.ТипДома)) = Неопределено, Неопределено, СтрокаНабора.ТипДома);
			СтрокаНабора.ТипКорпуса  = ?(ТипыКорпусов.Найти(НРег(СтрокаНабора.ТипКорпуса)) = Неопределено, Неопределено, СтрокаНабора.ТипКорпуса);
			СтрокаНабора.ТипКвартиры = ?(ТипыКвартир.Найти(НРег(СтрокаНабора.ТипКвартиры)) = Неопределено, Неопределено, СтрокаНабора.ТипКвартиры);
			
			// Получаем представление, какое оно должно быть
			КодСтраны = "";
			НаименованиеСтраны = СтрокаКИ.Страна;
			СтранаРоссия = Справочники.СтраныМира.Россия;
			
			СтруктураПолей.Свойство("КодСтраны", КодСтраны);
			Страна = ?(ЗначениеЗаполнено(КодСтраны), Справочники.СтраныМира.НайтиПоКоду(КодСтраны), Неопределено);
			Страна = ?(ЗначениеЗаполнено(Страна), Справочники.СтраныМира.НайтиПоНаименованию(НаименованиеСтраны, Истина), СтранаРоссия);
			Страна = ?(ЗначениеЗаполнено(Страна), Страна, СтранаРоссия);
			
			Представление = "";
			Если Страна <> СтранаРоссия Тогда
				Представление = Представление + ?(ЗначениеЗаполнено(Строка(Страна)), ", " + Строка(Страна), "");
			КонецЕсли;
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле1)), ", " + СокрЛП(СтрокаНабора.Поле1), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле2)), ", " + СокрЛП(СтрокаНабора.Поле2), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле3)), ", " + СокрЛП(СтрокаНабора.Поле3), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле4)), ", " + СокрЛП(СтрокаНабора.Поле4), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле5)), ", " + СокрЛП(СтрокаНабора.Поле5), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле6)), ", " + СокрЛП(СтрокаНабора.Поле6), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле7)), ", " + СтрокаНабора.ТипДома    + " № " + СокрЛП(СтрокаНабора.Поле7), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле8)), ", " + СтрокаНабора.ТипКорпуса + " " + СокрЛП(СтрокаНабора.Поле8), "");
			Представление = Представление + ?(ЗначениеЗаполнено(СокрЛП(СтрокаНабора.Поле9)), ", " + СтрокаНабора.ТипКвартиры + " " + СокрЛП(СтрокаНабора.Поле9), "");
			
			Если СтрДлина(Представление) > 2 Тогда
				Представление = Сред(Представление, 3);
			КонецЕсли;
			
			// Проверяем представление на наличие произвольного значения
			Если СтарыйФорматХранения Тогда
				Если Представление <> СтрокаНабора.Представление Тогда
					СтрокаНабора.ЭтоПроизвольнаяСтрока = Истина;
					СтрокаНабора.Поле1 = Строка(Страна);
				КонецЕсли;
			Иначе
				Если НРег(Представление) <> НРег(СтрокаНабора.Представление) Тогда
					СтрокаНабора.ЭтоПроизвольнаяСтрока = Истина;
					СтрокаНабора.Поле1 = Строка(Страна);
				КонецЕсли;
			КонецЕсли;
			
			СтрокаНабора.ТипКвартиры = ?(СтрокаНабора.ТипКвартиры = "кв.", "Квартира", "Офис");
			
		КонецЕсли;
		
		СтруктураПолей.Свойство("Комментарий", СтрокаНабора.Комментарий);
		
	КонецЦикла;
	
	ДанныеXDTO.Вставить("КонтактнаяИнформацияСтарыйФормат", Строки);
КонецПроцедуры

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
	Если ИмяПроцедуры = "ПКО_Справочник_Контрагенты_Отправка_ПриОтправкеДанных" Тогда 
		ПКО_Справочник_Контрагенты_Отправка_ПриОтправкеДанных(
			Параметры.ДанныеИБ, Параметры.ДанныеXDTO, Параметры.КомпонентыОбмена, Параметры.СтекВыгрузки);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
