
&НаКлиенте
Процедура ГоловныеКонтрагентыПриАктивизацииСтроки(Элемент)
	
//	УстановитьОтборНаСервере(Элементы.ГоловныеКонтрагенты.ТекущиеДанные.Контрагент);
	ПодключитьОбработчикОжидания("УстановитьОтборПоГоловномуКонтрагенту", 0.1, Истина);
	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборПоГоловномуКонтрагенту()
	
	ТекущиеДанные = Элементы.ГоловныеКонтрагенты.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ГоловнойКонтрагент", ТекущиеДанные.Контрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокНачалоПеретаскивания(Элемент, ПараметрыПеретаскивания, Выполнение)
	СтандартнаяОбработка = Ложь;  
КонецПроцедуры

&НаКлиенте
Процедура ГоловныеКонтрагентыПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры 

&НаКлиенте
Процедура ГоловныеКонтрагентыПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)                             
	     	
	СтандартнаяОбработка = Ложь; 
	
	ТекСтрока = Элемент.ТекущаяСтрока;
	Элемент.ТекущаяСтрока = Строка;
	
	ГоловнойКонтрагент = Элемент.ТекущиеДанные.Контрагент;
	Ключ 			   = ПараметрыПеретаскивания.Значение[0];  
	
	ЗаписатьВРегистрСведений(Ключ, ГоловнойКонтрагент);		
	Элемент.ТекущаяСтрока = ТекСтрока;
	Элементы.ГоловныеКонтрагенты.Обновить();
		
КонецПроцедуры

&НаСервере
Процедура ЗаписатьВРегистрСведений(Ключ,ГоловнойКонтрагент)
	
	Если ГоловнойКонтрагент.ЭтоГруппа Тогда  
		Возврат;
	КонецЕсли;
	
	Запись = РегистрыСведений.ИерархияКонтрагентов.СоздатьМенеджерЗаписи();
	ЗаполнитьЗначенияСвойств(Запись, Ключ);
	Запись.ГоловнойКонтрагент = ГоловнойКонтрагент;
	Запись.Записать();	
	
	//УстановитьОтборНаСервере(ГоловнойКонтрагент);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмеющиеПодчиненныхПриИзменении(Элемент)
	
	ИзменитьТекстЗапросаСервер(ИмеющиеПодчиненных);
	
КонецПроцедуры  

&НаСервере
Процедура ИзменитьТекстЗапросаСервер(ИмеющиеПодчиненных)
	
	Если НЕ ИмеющиеПодчиненных Тогда
		
		ГоловныеКонтрагенты.ТекстЗапроса = 		
		"ВЫБРАТЬ
		|	СправочникКонтрагентыLawson.Ссылка КАК Контрагент
		|ИЗ
		|	Справочник.КонтрагентыLawson КАК СправочникКонтрагентыLawson";
		
	Иначе
		
		ГоловныеКонтрагенты.ТекстЗапроса = 		
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СправочникКонтрагентыLawson.Ссылка КАК Контрагент,
		|	ИерархияКонтрагентов.ГоловнойКонтрагент КАК ГоловнойКонтрагент1
		|ИЗ
		|	Справочник.КонтрагентыLawson КАК СправочникКонтрагентыLawson
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияКонтрагентов КАК ИерархияКонтрагентов
		|		ПО СправочникКонтрагентыLawson.Ссылка = ИерархияКонтрагентов.ГоловнойКонтрагент";
		
	КонецЕсли;
	
	Элементы.ГоловныеКонтрагенты.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
//	ИмеющиеПодчиненных = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДатаАктуальности = ТекущаяДатаСеанса();
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Период", ДатаАктуальности);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ГоловныеКонтрагенты, "Период", ДатаАктуальности);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаАктуальностиПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "Период", ДатаАктуальности);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ГоловныеКонтрагенты, "Период", ДатаАктуальности);
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентДляОтбораПриИзменении(Элемент)
	
	ЗаполненКонтрагентДляОтбора = ЗначениеЗаполнено(КонтрагентДляОтбора);
	
	Если ЗаполненКонтрагентДляОтбора Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ГоловнойКонтрагент", Неопределено, Ложь);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "Контрагент", КонтрагентДляОтбора, ВидСравненияКомпоновкиДанных.Равно, , ЗаполненКонтрагентДляОтбора);
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(ГоловныеКонтрагенты, "Контрагент", КонтрагентДляОтбора, ЗаполненКонтрагентДляОтбора);
	
	Если НЕ ЗаполненКонтрагентДляОтбора Тогда
		ПодключитьОбработчикОжидания("УстановитьОтборПоГоловномуКонтрагенту", 0.1, Истина);
	КонецЕсли;
	
КонецПроцедуры
