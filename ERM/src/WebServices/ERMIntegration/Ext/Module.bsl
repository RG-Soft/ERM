﻿
Функция GetClientList(ПараметрыПоиска)
	
	КомпонентыОбмена = ОбменДаннымиXDTOСервер.ИнициализироватьКомпонентыОбмена("Отправка");
	
	#Область НастройкаКомпонентовОбмена
	УзелДляОбмена = ПланыОбмена.rgsОбменКлиентамиЧерезУниверсальныйФормат.НайтиПоКоду("PS");
	
	КомпонентыОбмена.УзелКорреспондента = УзелДляОбмена;
	
	КомпонентыОбмена.ВерсияФорматаОбмена = ОбменДаннымиXDTOСервер.ВерсияФорматаОбменаПриВыгрузке(УзелДляОбмена);
	
	ФорматОбмена = ОбменДаннымиXDTOСервер.ФорматОбмена(
		УзелДляОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
	КомпонентыОбмена.XMLСхема = ФорматОбмена;
	
	КомпонентыОбмена.МенеджерОбмена = ОбменДаннымиXDTOСервер.МенеджерОбменаВерсииФормата(
		УзелДляОбмена, КомпонентыОбмена.ВерсияФорматаОбмена);
	
	КомпонентыОбмена.ТаблицаПравилаРегистрацииОбъектов = ОбменДаннымиXDTOСервер.ПравилаРегистрацииОбъектов(УзелДляОбмена);
	КомпонентыОбмена.СвойстваУзлаПланаОбмена = ОбменДаннымиXDTOСервер.СвойстваУзлаПланаОбмена(УзелДляОбмена);
	
	ОбменДаннымиXDTOСервер.ИнициализироватьТаблицыПравилОбмена(КомпонентыОбмена);
	#КонецОбласти
	
	#Область ВыгрузкаДанных
	СтруктураВозвратаСпискаКлиентов = ПолучитьОбъектXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseDataAddition/1.0", "СтруктураВозвратаСпискаКлиентов");
	СписокКлиентовXDTO = ПолучитьОбъектXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseDataAddition/1.0", "СписокКонтрагентов");
	ТипКлиентаXDTO = ПолучитьТипОбъектаXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.0", "Справочник.Контрагенты");
	ПравилоКонвертации = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник_Контрагенты_Отправка", "ИмяПКО");
	
	ВыборкаКлиентов = ПолучитьВыборкуКлиентов(ПараметрыПоиска);
	
	ТекНомерКлиента = 0;
	Пока ВыборкаКлиентов.Следующий() И ТекНомерКлиента <= 100 Цикл
		
		СтруктураXDTO = ОбменДаннымиXDTOСервер.ДанныеXDTOИзДанныхИБ(КомпонентыОбмена, ВыборкаКлиентов.Клиент, ПравилоКонвертации);
		КлиентXDTO = ПолучитьОбъектXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.0", "Справочник.Контрагенты");
		СписокКлиентовXDTO.Контрагенты.Добавить(ОбменДаннымиXDTOСервер.ОбъектXDTOИзДанныхXDTO(КомпонентыОбмена, СтруктураXDTO, ТипКлиентаXDTO, КлиентXDTO));
		ТекНомерКлиента = ТекНомерКлиента + 1;
		
	КонецЦикла;
	
	Если ВыборкаКлиентов.Количество() > 100 Тогда
		СтруктураВозвратаСпискаКлиентов.ДопИнформация = "Найдено более 100 элементов. Необходимо уточнить условия запроса.";
	КонецЕсли;
	
	СтруктураВозвратаСпискаКлиентов.СписокКлиентов = СписокКлиентовXDTO;
	
	Попытка
		СтруктураВозвратаСпискаКлиентов.Проверить();
	Исключение
		СтруктураВозвратаСпискаКлиентов.СообщениеОбОшибке = ОписаниеОшибки();
		СтруктураВозвратаСпискаКлиентов.СписокКлиентов = ПолучитьОбъектXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseDataAddition/1.0", "СписокКонтрагентов");
	КонецПопытки;
	
	#КонецОбласти
	
	Возврат СтруктураВозвратаСпискаКлиентов;
	
КонецФункции

Функция ПолучитьВыборкуКлиентов(ПараметрыПоиска)
	
	Запрос = Новый Запрос;
	
	ДопУсловие = "";
	Если ЗначениеЗаполнено(ПараметрыПоиска.НаименованиеАнгл) Тогда
		ДопУсловие = ДопУсловие + " И Контрагенты.Наименование ПОДОБНО ""%" + СокрЛП(ПараметрыПоиска.НаименованиеАнгл) + "%""";
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыПоиска.Наименование) Тогда
		ДопУсловие = ДопУсловие + " И Контрагенты.ЛокальноеНаименование ПОДОБНО ""%" + СокрЛП(ПараметрыПоиска.Наименование) + "%""";
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыПоиска.ИНН) Тогда
		ДопУсловие = ДопУсловие + " И Контрагенты.ИНН = """ + СокрЛП(ПараметрыПоиска.ИНН) + """";
	КонецЕсли;
	Если ЗначениеЗаполнено(ПараметрыПоиска.КПП) Тогда
		ДопУсловие = ДопУсловие + " И Контрагенты.КПП = """ + СокрЛП(ПараметрыПоиска.КПП) + """";
	КонецЕсли;
	
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Контрагенты.Ссылка КАК Клиент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ПометкаУдаления" + ДопУсловие;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
	
КонецФункции

Функция ПолучитьОбъектXDTO(ИспользуемаяФабрикаXDTO, URIПространстваИмен, Имя) 
	
	// Конструирует объект XDTO типа Имя с помощью ФабрикиXDTO и URIПространстваИмен
	
	ТипПоля = ИспользуемаяФабрикаXDTO.Тип(URIПространстваИмен, Имя);
	Возврат ИспользуемаяФабрикаXDTO.Создать(ТипПоля);
	
КонецФункции

Функция ПолучитьТипОбъектаXDTO(ИспользуемаяФабрикаXDTO, URIПространстваИмен, Имя)
	
	Возврат ИспользуемаяФабрикаXDTO.Тип("http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.0", "Справочник.Контрагенты");
	
КонецФункции

Функция RegisterClients(RefList)
	
	УзелОбмена = ПланыОбмена.rgsОбменКлиентамиЧерезУниверсальныйФормат.ПолучитьУзелОбменаПоИдентификаторуКорреспондента(RefList.ИдентификаторКорреспондента);
	
	Для каждого ТекСсылка Из RefList.Ссылки Цикл
		
		ТекКлиент = Справочники.Контрагенты.ПолучитьСсылку(Новый УникальныйИдентификатор(ТекСсылка));
		ПланыОбмена.ЗарегистрироватьИзменения(УзелОбмена, ТекКлиент);
		
	КонецЦикла;
	
	// инициируем обмен
	Отказ = Ложь;
	ПараметрыОбмена = Новый Структура();
	ПараметрыОбмена.Вставить("ВидТранспортаСообщенийОбмена", Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	ПараметрыОбмена.Вставить("ВыполнятьЗагрузку", Истина);
	ПараметрыОбмена.Вставить("ВыполнятьВыгрузку", Истина);
	ПараметрыОбмена.Вставить("ТолькоПараметры", Ложь);
	ПараметрыОбмена.Вставить("ПараметрыАутентификации", Неопределено);
	ПараметрыОбмена.Вставить("ИдентификаторФайла", "");
	ПараметрыОбмена.Вставить("ДлительнаяОперация", Ложь);
	ПараметрыОбмена.Вставить("ИдентификаторОперации", "");
	ПараметрыОбмена.Вставить("ДлительнаяОперацияРазрешена", Истина);
	ОбменДаннымиСервер.ВыполнитьОбменДаннымиДляУзлаИнформационнойБазы(УзелОбмена, ПараметрыОбмена, Отказ);
	
	Возврат Отказ;
	
КонецФункции
