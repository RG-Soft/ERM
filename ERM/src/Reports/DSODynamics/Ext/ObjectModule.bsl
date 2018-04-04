﻿
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	//Если КомпоновщикНастроек.Настройки.Структура.Количество() > 0 Тогда
	//	СтандартнаяОбработка = Истина;
	//	Возврат;
	//КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрПериодDSO = ОтчетыКлиентСервер.НайтиПараметр(КомпоновщикНастроек.Настройки, КомпоновщикНастроек.ПользовательскиеНастройки, "ПериодDSO");
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РАЗНОСТЬДАТ(&Дата1, &Дата2, МЕСЯЦ) КАК КоличествоМесяцев";
	Запрос.УстановитьПараметр("Дата1", ПараметрПериодDSO.Значение.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", ПараметрПериодDSO.Значение.ДатаОкончания);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ГлубинаDSO = 24 + Выборка.КоличествоМесяцев;
	
	ИсточникДанных = СхемаКомпоновкиДанных.ИсточникиДанных.Добавить();
	ИсточникДанных.Имя = "ИсточникДанных1";
	ИсточникДанных.ТипИсточникаДанных = "Local";
	
	НаборДанных = СхемаКомпоновкиДанных.НаборыДанных.Добавить(Тип("НаборДанныхЗапросСхемыКомпоновкиДанных"));
	НаборДанных.Имя = "НаборДанных1";
	НаборДанных.ИсточникДанных = ИсточникДанных.Имя;
	
	СхемаКомпоновкиДанных.НаборыДанных[0].Запрос = Отчеты.DSODynamics.ПолучитьТекстЗапроса(ГлубинаDSO);
	
	ДобавитьВычисляемыеПоля(ПараметрПериодDSO.Значение.ДатаОкончания, Выборка.КоличествоМесяцев);
	ДобавитьРесурсы(ГлубинаDSO);
	
	АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, Новый УникальныйИдентификатор());
	
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	
	УстановитьПараметрыОтчета(ПараметрПериодDSO.Значение.ДатаНачала, ПараметрПериодDSO.Значение.ДатаОкончания, ГлубинаDSO);
	
	//ПоляВыбора = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	//ЗаполнитьДоступныеПоляВыбора(КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы, ПоляВыбора.Выбор.Элементы);
	//ЗаполнитьДоступныеПоляВыбора(КомпоновщикНастроек.Настройки.ДоступныеПоляВыбора.Элементы, КомпоновщикНастроек.Настройки.Выбор.Элементы);
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	
	МакетКомпоновкиДанных = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, ДанныеРасшифровки, , Тип("ГенераторМакетаКомпоновкиДанных"));
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновкиДанных, , ДанныеРасшифровки, Истина);
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	
КонецПроцедуры

Процедура ЗаполнитьДоступныеПоляВыбора(ЭлементыИсточник, ЭлементыПриемник)
	Для каждого ЭлементВыбора Из ЭлементыИсточник Цикл
		Если ЭлементВыбора.Папка Тогда
			ЗаполнитьДоступныеПоляВыбора(ЭлементВыбора.Элементы, ЭлементыПриемник);
		Иначе
			НовоеПолеВыбора = ЭлементыПриемник.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ЗаполнитьЗначенияСвойств(НовоеПолеВыбора, ЭлементВыбора);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура УстановитьПараметрыОтчета(ДатаНачала, ДатаОкончания, ГлубинаDSO)
	
	ПараметрПериод = ОтчетыКлиентСервер.НайтиПараметр(КомпоновщикНастроек.Настройки, КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
	
	Если ПараметрПериод <> Неопределено Тогда
		ПараметрПериод.Использование = Истина;
		ПараметрПериод.Значение      = КонецМесяца(ДатаОкончания);
	КонецЕсли;
	
	Для НомерПериода = 0 По ГлубинаDSO Цикл
		
		ИмяПараметра = "ТекПериод" + Формат(НомерПериода, "ЧН=0; ЧГ=0");
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(КомпоновщикНастроек.Настройки, КомпоновщикНастроек.ПользовательскиеНастройки, ИмяПараметра);
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = ДобавитьМесяц(НачалоМесяца(ДатаОкончания), -НомерПериода);
		КонецЕсли;
		
	КонецЦикла;
	
	Для НомерПериода = 0 По ГлубинаDSO - 24 Цикл
		
		ИмяПараметра = "ПериодОстатков" + Формат(НомерПериода, "ЧН=0; ЧГ=0");
		
		ПараметрПериодОстатков = ОтчетыКлиентСервер.НайтиПараметр(КомпоновщикНастроек.Настройки, КомпоновщикНастроек.ПользовательскиеНастройки, ИмяПараметра);
		
		Если ПараметрПериодОстатков <> Неопределено Тогда
			ПараметрПериодОстатков.Использование = Истина;
			ПараметрПериодОстатков.Значение      = ДобавитьМесяц(КонецМесяца(ДатаОкончания) + 1, -НомерПериода);
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьВычисляемыеПоля(КонецПериода, КоличествоМесяцев)
	
	ПолеBU = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
	ПолеBU.ПутьКДанным = "BU";
	ПолеBU.Выражение = "rgsКонсолидацияДанныхСервер.ОпределитьBU(GeoMarket, SubGeoMarket, MgmtGeomarket, Segment, SubSegment, Company, AU)";
	ПолеBU.Заголовок = "BU";
	ПолеBU.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.BusinessUnits");
	
	Для Смещение = 0 По КоличествоМесяцев Цикл
		
		ПолеDSO = СхемаКомпоновкиДанных.ВычисляемыеПоля.Добавить();
		ПолеDSO.ПутьКДанным = "DSO_" + Смещение;
		ПолеDSO.Выражение = "rgsРасчетПоказателей.РассчитатьDSO(AR, &Период, Billing" + Формат(0 + Смещение, "ЧН=0; ЧГ=0") + ", Billing" + Формат(1 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(2 + Смещение, "ЧГ=0") + ", Billing" + Формат(3 + Смещение, "ЧГ=0") + ", Billing" + Формат(4 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(5 + Смещение, "ЧГ=0") + ", Billing" + Формат(6 + Смещение, "ЧГ=0") + ", Billing" + Формат(7 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(8 + Смещение, "ЧГ=0") + ", Billing" + Формат(9 + Смещение, "ЧГ=0") + ", Billing" + Формат(10 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(11 + Смещение, "ЧГ=0") + ", Billing" + Формат(12 + Смещение, "ЧГ=0") + ", Billing" + Формат(13 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(14 + Смещение, "ЧГ=0") + ", Billing" + Формат(15 + Смещение, "ЧГ=0") + ", Billing" + Формат(16 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(17 + Смещение, "ЧГ=0") + ", Billing" + Формат(18 + Смещение, "ЧГ=0") + ", Billing" + Формат(19 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(20 + Смещение, "ЧГ=0") + ", Billing" + Формат(21 + Смещение, "ЧГ=0") + ", Billing" + Формат(22 + Смещение, "ЧГ=0")
			+ ", Billing" + Формат(23 + Смещение, "ЧГ=0") + ", Billing" + Формат(24 + Смещение, "ЧГ=0") + ")";
		ПолеDSO.Заголовок = "DSO " + Формат(ДобавитьМесяц(КонецПериода, -Смещение), "ДФ=MM.yyyy");
		ПолеDSO.ТипЗначения = Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15, 2));
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ДобавитьРесурсы(ГлубинаDSO)
	
	Для НомерРесурса = 0 По ГлубинаDSO Цикл
		
		ИмяРесурса = "Billing" + Формат(НомерРесурса, "ЧГ=0");
		
		ПолеAR = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
		ПолеAR.ПутьКДанным = ИмяРесурса;
		ПолеAR.Выражение = "Сумма(" + ИмяРесурса + ")";
		
	КонецЦикла;
	
	Для Смещение = 0 По ГлубинаDSO - 24 Цикл
		
		СмещениеСтрокой = Формат(Смещение, "ЧН=0; ЧГ=0");
		
		ПолеAR = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
		ПолеAR.ПутьКДанным = СтрШаблон("AR%1", СмещениеСтрокой);
		ПолеAR.Выражение = СтрШаблон("СУММА(AR%1)", СмещениеСтрокой);
		
		ПолеDSO = СхемаКомпоновкиДанных.ПоляИтога.Добавить();
		ПолеDSO.ПутьКДанным = "DSO_" + Смещение;
		ПолеDSO.Выражение = "rgsРасчетПоказателей.РассчитатьDSO(AR" + СмещениеСтрокой + ", &Период, СУММА(Billing" + Формат(0 + Смещение, "ЧН=0; ЧГ=0") + "), СУММА(Billing" + Формат(1 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(2 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(3 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(4 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(5 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(6 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(7 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(8 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(9 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(10 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(11 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(12 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(13 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(14 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(15 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(16 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(17 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(18 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(19 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(20 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(21 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(22 + Смещение, "ЧГ=0")
			+ "), СУММА(Billing" + Формат(23 + Смещение, "ЧГ=0") + "), СУММА(Billing" + Формат(24 + Смещение, "ЧГ=0") + "))";
		
	КонецЦикла;
	
КонецПроцедуры