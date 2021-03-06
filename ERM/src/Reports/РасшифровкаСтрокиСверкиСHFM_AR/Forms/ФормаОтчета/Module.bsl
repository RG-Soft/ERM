
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Отбор.Свойство("AccountHFM") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "AccountHFM");
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = Параметры.Отбор.AccountHFM;
		КонецЕсли;
		
		AccountHFM = Параметры.Отбор.AccountHFM;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Период") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
		
		Если Параметр <> Неопределено Тогда
			
			Период = КонецМесяца(Параметры.Отбор.Период);
			Параметр.Использование = Истина;
			Параметр.Значение      = Период;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ДатаКурса") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ДатаКурса");
		
		Если Параметр <> Неопределено Тогда
			
			ДатаКурса = КонецМесяца(Параметры.Отбор.ДатаКурса);
			Параметр.Использование = Истина;
			Параметр.Значение      = ДатаКурса;
			
		КонецЕсли;
		
	КонецЕсли;
		
	
	Если Параметры.Отбор.Свойство("КонецПериода") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "КонецПериода");
		
		Если Параметр <> Неопределено Тогда
			
			КонецПериода = КонецМесяца(Параметры.Отбор.КонецПериода);
			Параметр.Использование = Истина;
			Параметр.Значение      = КонецПериода;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("ЛокацияHFM") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ЛокацияHFM");
		
		Если Параметр <> Неопределено Тогда
			
			ЛокацияHFM = Параметры.Отбор.ЛокацияHFM;
			Параметр.Использование = Истина;
			Параметр.Значение      = ЛокацияHFM;
			
		КонецЕсли;
		
		
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("СегментHFM") Тогда
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "СегментHFM");
		
		Если Параметр <> Неопределено Тогда
			
			СегментHFM = Параметры.Отбор.СегментHFM;
			Параметр.Использование = Истина;
			Параметр.Значение      = СегментHFM;
			
		КонецЕсли;
		
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ТестНаСервере()
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	//СхемаКомпоновкиДанных = ОтчетОбъект.ОпределитьСхемуКомпоновки("ОсновнаяСхемаКомпоновкиДанныхAR");
	СхемаКомпоновкиДанных = Отчеты.РасшифровкаСтрокиСверкиСHFM_AR.ПолучитьМакет("ОсновнаяСхемаКомпоновкиДанныхAR");
	НастройкиПользователя = ОтчетОбъект.КомпоновщикНастроек;
	Настройки = НастройкиПользователя.Настройки;
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	//Настройки = СхемаКомпоновкиДанных.НастройкиПоУмолчанию;
		
	//Помещаем в переменную данные о расшифровке данных
	ДанныеРасшифровки1 = Новый ДанныеРасшифровкиКомпоновкиДанных;

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
	
	//Формируем макет, с помощью компоновщика макета
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;

	//Передаем в макет компоновки схему, настройки и данные расшифровки
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, Настройки, ДанныеРасшифровки1, , Тип("ГенераторМакетаКомпоновкиДанных"));

	//Выполним компоновку с помощью процессора компоновки
	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки, , ДанныеРасшифровки1);
	
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

&НаКлиенте
Процедура ОчиститьТабДок(Команда)
	ОчиститьТабДокСервер();
КонецПроцедуры

&НаСервере
Процедура ОчиститьТабДокСервер()
	Результат.Очистить();
КонецПроцедуры

&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	Если СтрЗаканчиваетсяНа(Элемент.ТекущаяОбласть.Имя, "C15") Тогда
		
		СтандартнаяОбработка = Ложь;
		
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("Doc_No", Элемент.ТекущаяОбласть.Текст);
		
		ОткрытьФорму("ОбщаяФорма.rgsРасшифровкаДвиженийПоДокументу", СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

