﻿
Процедура ОтборОбработатьВыборЗначения(Форма, Элемент, СтандартнаяОбработка, Значение, СписокПараметров, ТипПоля) Экспорт
	
	Перем ОписанияТиповВидовСубконто;
	
	ОписанияТиповВидовСубконто = Форма .ОписанияТиповВидовСубконто;
	
	Если ТипЗнч(ТипПоля) <> Тип("ОписаниеТипов") Тогда
		
		Возврат;
		
	ИначеЕсли ТипПоля.Типы().Количество() > 0 Тогда
		
		ТипЭлемента = ТипЗнч(Значение);
		Если ?(ТипЭлемента = Неопределено, Истина, не ТипПоля.СодержитТип(ТипЭлемента)) Тогда
			ТипЭлемента = ТипПоля.Типы()[0];
		КонецЕсли; 
	Иначе
		Возврат;
	КонецЕсли;
	
	Если ТипЭлемента = Тип("СправочникСсылка.БанковскиеСчета") Тогда
		СтандартнаяОбработка = Ложь;
		
		ЗначенияОтборов = Новый Структура;
		Если ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
			ЗначенияОтборов.Вставить("Владелец", СписокПараметров.Организация);
		КонецЕсли;
		ПараметрыФормы = Новый Структура("Отбор", ЗначенияОтборов);
		//БухгалтерскийУчетКлиентПереопределяемый.ОткрытьФормуВыбораБанковскогоСчетОрганизации(ПараметрыФормы, Элемент);
		ОткрытьФорму("Справочник.БанковскиеСчета.ФормаВыбора", ПараметрыФормы, Элемент);
	//ИначеЕсли ТипЭлемента = БухгалтерскийУчетКлиентСерверПереопределяемый.ТипПодразделения() Тогда
	//	
	//	СтандартнаяОбработка = Ложь;
	//	
	//	ЗначенияОтборов = Новый Структура;
	//	ИмяРеквизитаОрганизации = БухгалтерскийУчетКлиентСерверПереопределяемый.ИмяРеквизитаОрганизацияПодразделения();
	//	Если ЗначениеЗаполнено(ИмяРеквизитаОрганизации) Тогда
	//		Если ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
	//			ЗначенияОтборов.Вставить(ИмяРеквизитаОрганизации, СписокПараметров.Организация);
	//		КонецЕсли;
	//	КонецЕсли;
	//	
	//	ПараметрыФормы = Новый Структура("Отбор", ЗначенияОтборов);
	//	БухгалтерскийУчетКлиентПереопределяемый.ОткрытьФормуВыбораПодразделения(ПараметрыФормы, Элемент);
	//	
	//ИначеЕсли ТипЭлемента = Тип("СправочникСсылка.ДоговорыКонтрагентов") Тогда
	//	
	//	СтандартнаяОбработка = Ложь;
	//	
	//	ЗначенияОтборов = Новый Структура;
	//	Если ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
	//		ЗначенияОтборов.Вставить("Организация", СписокПараметров.Организация);
	//	КонецЕсли;
	//	ИмяРеквизитаКонтрагента = БухгалтерскийУчетКлиентСерверПереопределяемый.ПолучитьИмяРеквизитаКонтрагентДоговора();
	//	Если ЗначениеЗаполнено(СписокПараметров.Контрагент) Тогда
	//		ЗначенияОтборов.Вставить(ИмяРеквизитаКонтрагента, СписокПараметров.Контрагент);
	//	КонецЕсли;
	//	
	//	ПараметрыФормы = Новый Структура("Отбор", ЗначенияОтборов);
	//	ОткрытьФорму("Справочник.ДоговорыКонтрагентов.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	//	
	//	
	//ИначеЕсли ТипПоля = ОписанияТиповВидовСубконто["Партия"] 
	//	ИЛИ ТипЭлемента = Тип("ДокументСсылка.Партия") Тогда
	//	
	//	СтандартнаяОбработка = Ложь;
	//	
	//	ПараметрыОбъекта  = Новый Структура;
	//	Если ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
	//		ПараметрыОбъекта.Вставить("Организация", СписокПараметров.Организация);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.Номенклатура) Тогда
	//		ПараметрыОбъекта.Вставить("Номенклатура", СписокПараметров.Номенклатура);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.Склад) Тогда
	//		ПараметрыОбъекта.Вставить("Склад", СписокПараметров.Склад);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.Дата) Тогда
	//		ПараметрыОбъекта.Вставить("КонецПериода", СписокПараметров.Дата);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.СчетУчета) Тогда
	//		ПараметрыОбъекта.Вставить("СчетУчета", СписокПараметров.СчетУчета);
	//	КонецЕсли;
	//	ПараметрыОбъекта.Вставить("ТипыДокументов", ТипПоля);
	//	
	//	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	//	ОткрытьФорму("Документ.Партия.ФормаВыбора", ПараметрыФормы, Элемент);
	//	
	//ИначеЕсли ТипПоля = ОписанияТиповВидовСубконто.ДокументРасчетовСКонтрагентами 
	//	ИЛИ ТипЭлемента = Тип("ДокументСсылка.ДокументРасчетовСКонтрагентом") Тогда
	//	СтандартнаяОбработка = Ложь;
	//	
	//	ПараметрыОбъекта  = Новый Структура;
	//	Если ЗначениеЗаполнено(СписокПараметров.Организация) Тогда
	//		ПараметрыОбъекта.Вставить("Организация", СписокПараметров.Организация);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.Контрагент) Тогда
	//		ПараметрыОбъекта.Вставить("Контрагент", СписокПараметров.Контрагент);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.ДоговорКонтрагента) Тогда
	//		ПараметрыОбъекта.Вставить("ДоговорКонтрагента", СписокПараметров.ДоговорКонтрагента);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.Дата) Тогда
	//		ПараметрыОбъекта.Вставить("Дата", СписокПараметров.Дата);
	//	КонецЕсли;
	//	Если ЗначениеЗаполнено(СписокПараметров.СчетУчета) Тогда
	//		ПараметрыОбъекта.Вставить("СчетУчета", СписокПараметров.СчетУчета);
	//	КонецЕсли;
	//	ПараметрыОбъекта.Вставить("ТипыДокументов", ТипПоля);
	//	
	//	ПараметрыФормы = Новый Структура("ПараметрыОбъекта", ПараметрыОбъекта);
	//	
	//	ОткрытьФорму("Документ.ДокументРасчетовСКонтрагентом.ФормаВыбора", ПараметрыФормы, Элемент);
	//	
	//ИначеЕсли ТипЭлемента = Тип("ДокументСсылка.ПартияМатериаловВЭксплуатации") Тогда
	//	
	//	ЗначенияОтборов = Новый Структура;
	//	Если ЗначениеЗаполнено(СписокПараметров.Контрагент) Тогда
	//		ЗначенияОтборов.Вставить("Номенклатура", СписокПараметров.Номенклатура);
	//	КонецЕсли;
	//	
	//	ПараметрыФормы = Новый Структура("Отбор", ЗначенияОтборов);
	//	ОткрытьФорму("Документ.ПартияМатериаловВЭксплуатации.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
		
	//ИначеЕсли ТипЭлемента = Тип("СправочникСсылка.Субконто") Тогда
	//	
	//	ЗначенияОтборов = Новый Структура;
	//	Если ЗначениеЗаполнено(СписокПараметров.СчетУчета) Тогда
	//		ПараметрыФормы = Новый Структура("Счет", СписокПараметров.СчетУчета);
	//	КонецЕсли;
	//	
	//	ОткрытьФорму("Справочник.Субконто.Форма.ФормаВыбора", ПараметрыФормы, Элемент);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтборыПравоеЗначениеНачалоВыбора(КомпоновщикНастроек, Форма, Элемент, ДанныеВыбора, СтандартнаяОбработка, СписокПараметров) Экспорт
	
	//Элементы = Форма.Элементы;
	//
	//ОписанияТиповВидовСубконто = Форма.ОписанияТиповВидовСубконто;
	//
	//Если Элементы.Отборы.ТекущиеДанные <> Неопределено Тогда
	//	Поле         = Элементы.Отборы.ТекущиеДанные.ЛевоеЗначение;
	//	Значение     = Элементы.Отборы.ТекущиеДанные.ПравоеЗначение;
	//	
	//	ВидСравненияСтрока = Элементы.Отборы.ТекущиеДанные.ВидСравнения;
	//	
	//	ТипПоля = БухгалтерскиеОтчетыКлиентСервер.ПолучитьСвойствоПоля(КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора, Поле, "Тип");
	//	
	//	// Принятая в конфигурации обработка работает только для равенства/неравенства
	//	Если Строка(ВидСравненияСтрока) = Строка(ВидСравненияКомпоновкиДанных.Равно)
	//		ИЛИ Строка(ВидСравненияСтрока) = Строка(ВидСравненияКомпоновкиДанных.НеРавно) Тогда
	//		
	//		Для Каждого СтрокаОтбора Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
	//			Если ТипЗнч(СтрокаОтбора) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
	//				Если ТипЗнч(СтрокаОтбора.ПравоеЗначение) <> Тип("ПолеКомпоновкиДанных") Тогда
	//					ЗначениеОтбора = ?(ТипЗнч(СтрокаОтбора.ПравоеЗначение) <> Тип("СписокЗначений"), СтрокаОтбора.ПравоеЗначение, СтрокаОтбора.ПравоеЗначение[0].Значение);
	//					ТипЗначенияПоля = БухгалтерскиеОтчетыКлиентСервер.ПолучитьСвойствоПоля(КомпоновщикНастроек.Настройки.Отбор.ДоступныеПоляОтбора, СтрокаОтбора.ЛевоеЗначение, "Тип");
	//					
	//					Если ТипЗначенияПоля = ОписанияТиповВидовСубконто.Номенклатура Тогда
	//						СписокПараметров.Вставить("Номенклатура", ЗначениеОтбора);
	//					ИначеЕсли ТипЗначенияПоля = ОписанияТиповВидовСубконто.Склад Тогда
	//						СписокПараметров.Вставить("Склад", ЗначениеОтбора);
	//					ИначеЕсли ТипЗначенияПоля = ОписанияТиповВидовСубконто.Контрагент Тогда
	//						СписокПараметров.Вставить("Контрагент", ЗначениеОтбора);
	//					ИначеЕсли ТипЗначенияПоля = ОписанияТиповВидовСубконто.ДоговорКонтрагента Тогда
	//						СписокПараметров.Вставить("ДоговорКонтрагента", ЗначениеОтбора);
	//					КонецЕсли;
	//				КонецЕсли;
	//			КонецЕсли;
	//		КонецЦикла;
	//		ОтборОбработатьВыборЗначения(Форма, Элемент, СтандартнаяОбработка, Значение, СписокПараметров, ТипПоля);
	//	КонецЕсли;
	//КонецЕсли;
	
КонецПроцедуры
