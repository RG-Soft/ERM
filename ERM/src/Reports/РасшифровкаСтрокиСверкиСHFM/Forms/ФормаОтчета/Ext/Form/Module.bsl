﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	////ОтчетОбъект.ОпределитьСхемуКомпоновки("ОсновнаяСхемаКомпоновкиДанныхAR");
	////ЗначениеВДанныеФормы(ОтчетОбъект, Отчет);
	////Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(ОтчетОбъект.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	////СхемаКД = ОтчетОбъект.СхемаКомпоновкиДанных;
	////АдресСхемы = ПоместитьВоВременноеХранилище(СхемаКД, УникальныйИдентификатор);
	////Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемы));
	//////Настройки = ОтчетыКлиентСервер.ПолучитьНастройкиОтчетаПоУмолчанию();
	////
	//////Настройки.События.ПередЗагрузкойНастроекВКомпоновщик = Истина;
	//
	//СхемаКД = Отчеты.РасшифровкаСтрокиСверкиСHFM.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанныхAR");
	//
	//НастройкиСхемыКД = СхемаКД.НастройкиПоУмолчанию;
	//
	//ОтчетОбъект.КомпоновщикНастроек.ЗагрузитьНастройки(НастройкиСхемыКД);
	////ЗначениеВДанныеФормы(ОтчетОбъект, "Отчет");
	
	Если Параметры.Отбор.Свойство("AccountHFM") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "AccountHFM");
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = Параметры.Отбор.AccountHFM;
		КонецЕсли;
		
		AccountHFM = Параметры.Отбор.AccountHFM;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("НачалоПериода") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "НачалоПериода");
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = Параметры.Отбор.НачалоПериода;
		КонецЕсли;
		
		НачалоПериода = Параметры.Отбор.НачалоПериода;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("КонецПериода") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "КонецПериода");
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = Параметры.Отбор.КонецПериода;
		КонецЕсли;
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
		
		КонецПериода = Параметры.Отбор.КонецПериода;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ЛокацияHFM") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ЛокацияHFM");
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = Параметры.Отбор.ЛокацияHFM;
		КонецЕсли;
		
		ЛокацияHFM = Параметры.Отбор.ЛокацияHFM;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("СегментHFM") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "СегментHFM");
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = Параметры.Отбор.СегментHFM;
		КонецЕсли;
		
		СегментHFM = Параметры.Отбор.СегментHFM;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТестНаСервере()
	
	//ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	//СхемаКомпоновкиДанных = ОтчетОбъект.ОпределитьСхемуКомпоновки("ОсновнаяСхемаКомпоновкиДанныхAR");
	СхемаКомпоновкиДанных = Отчеты.РасшифровкаСтрокиСверкиСHFM.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанныхAR");
	
	Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
		
	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки1 = Новый ДанныеРасшифровкиКомпоновкиДанных;

	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки1);

	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки1);

	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "AccountHFM");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = AccountHFM;
	КонецЕсли;
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "НачалоПериода");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = НачалоПериода;
	КонецЕсли;
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "КонецПериода");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = КонецПериода;
	КонецЕсли;
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ДатаКурса");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = КонецМесяца(КонецПериода)+1;
	КонецЕсли;
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ЛокацияHFM");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = ЛокацияHFM;
	КонецЕсли;
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "СегментHFM");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = СегментHFM;
	КонецЕсли;
	
	//Очищаем поле табличного документа
	Результат.Очистить();

	//Выводим результат в табличный документ
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);

	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
	//
	//ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	//СхемаКомпоновкиДанных = ОтчетОбъект.ОпределитьСхемуКомпоновки("ОсновнаяСхемаКомпоновкиДанныхAR");
	//
	//Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
	//	
	//КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	//МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки);
	////ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;

	//ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	//ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,,);

	//ДокументРезультат = Новый ТабличныйДокумент;
	//ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	//ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	//ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);

	//ДокументРезультат.Показать();
		
КонецПроцедуры

&НаКлиенте
Процедура Тест(Команда)
	ТестНаСервере();
КонецПроцедуры
