﻿
Функция ClientList(ПараметрыПоиска)
	
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
	СписокКлиентовXDTO = ПолучитьОбъектXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseDataAddition/1.0", "СписокКонтрагентов");
	ТипКлиентаXDTO = ПолучитьТипОбъектаXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.0", "Справочник.Контрагенты");
	ПравилоКонвертации = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник_Контрагенты_Отправка", "ИмяПКО");
	
	ВыборкаКлиентов = ПолучитьВыборкуКлиентов();
	Пока ВыборкаКлиентов.Следующий() Цикл
		
		////СписокКлиентовXDTO.Добавить(ОбменДаннымиXDTOСервер.ВыгрузкаОбъектаВыборки(КомпонентыОбмена, ВыборкаКлиентов.Клиент));
		//ПравилоОбработки = ПОДПоОбъектуМетаданных(КомпонентыОбмена, ОбъектМетаданныхТекущий);
		//
		//// Отработка ПОД
		//ИспользованиеПКО = Новый Структура;
		//Для Каждого ИмяПКО Из ПравилоОбработки.ИспользуемыеПКО Цикл
		//	ИспользованиеПКО.Вставить(ИмяПКО, Истина);
		//КонецЦикла;
		//
		//ПравилоКонвертации = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник_Контрагенты_Отправка", "ИмяПКО");
		СтруктураXDTO = ОбменДаннымиXDTOСервер.ДанныеXDTOИзДанныхИБ(КомпонентыОбмена, ВыборкаКлиентов.Клиент, ПравилоКонвертации);
		КлиентXDTO = ПолучитьОбъектXDTO(ФабрикаXDTO, "http://v8.1c.ru/edi/edi_stnd/EnterpriseData/1.0", "Справочник.Контрагенты");
		СписокКлиентовXDTO.Контрагенты.Добавить(ОбменДаннымиXDTOСервер.ОбъектXDTOИзДанныхXDTO(КомпонентыОбмена, СтруктураXDTO, ТипКлиентаXDTO, КлиентXDTO));
		
	КонецЦикла;
	#КонецОбласти
	
	Возврат СписокКлиентовXDTO;
	
КонецФункции

Функция ПолучитьВыборкуКлиентов()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 10
		|	Контрагенты.Ссылка КАК Клиент
		|ИЗ
		|	Справочник.Контрагенты КАК Контрагенты
		|ГДЕ
		|	НЕ Контрагенты.ПометкаУдаления";
	
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
