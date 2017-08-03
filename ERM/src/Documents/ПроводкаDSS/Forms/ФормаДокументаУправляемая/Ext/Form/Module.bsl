﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ТолькоПросмотр = Истина;
	SystemПриИзменении(Элементы.System);
	ДокументКорректировки = ПолучитьКорректировку();
	
	Если ДокументКорректировки <> Неопределено Тогда
		Элементы.Корректировка.Видимость = Истина;
		Элементы.СоздатьКорректировку.Видимость = Ложь;
		Корректировка = ДокументКорректировки;
	Иначе
		Элементы.Корректировка.Видимость = Ложь;
		Элементы.СоздатьКорректировку.Видимость = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкрытьВкладки()

	Элементы.PO.Видимость = Ложь;
	Элементы.GL.Видимость = Ложь;
	Элементы.IC.Видимость = Ложь;
	Элементы.AR.Видимость = Ложь;
	Элементы.AM.Видимость = Ложь;
	Элементы.RJ.Видимость = Ложь;
	Элементы.CB.Видимость = Ложь;
	Элементы.BL.Видимость = Ложь;
	Элементы.AP.Видимость = Ложь;
	
	ЭтоПроводкаAPAP = (Объект.System = "AP" И Объект.SourceCode = "AP");
	Элементы.ТипПроводки.Видимость = ЭтоПроводкаAPAP;
	Элементы.Ваучер.Видимость = ЭтоПроводкаAPAP;	

КонецПроцедуры 

&НаКлиенте
Процедура SystemПриИзменении(Элемент)

	СкрытьВкладки();
	
	Текст = ВРег(Элемент.ТекстРедактирования);
	
	Если Текст = "PO" ИЛИ Текст = "GL" ИЛИ Текст = "IC" ИЛИ Текст = "AR" ИЛИ Текст = "AM" ИЛИ Текст = "RJ" 
		ИЛИ Текст = "CB" ИЛИ Текст = "BL" ИЛИ Текст = "AP"  Тогда
		
		Элементы[Текст].Видимость = Истина;
		
	КонецЕсли;  	
	
	Если Текст = "MN" Тогда
	
		Элементы["AP"].Видимость = Истина;
		Элементы.ApInvoiceAP.ТолькоПросмотр = Ложь;
		Элементы.AktOfAcceptance.ТолькоПросмотр = Ложь;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьКорректировку()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорректировкаТранзакции.Ссылка КАК Ссылка
		|ИЗ
		|	Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|ГДЕ
		|	НЕ КорректировкаТранзакции.ПометкаУдаления
		|	И КорректировкаТранзакции.ДокументОснование = &ДокументОснование";
	
	Запрос.УстановитьПараметр("ДокументОснование",Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() <> 0 Тогда
		ВыборкаДетальныеЗаписи.Следующий();
		Возврат ВыборкаДетальныеЗаписи.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;

КонецФункции

//&НаКлиенте
//Процедура НадписьКорректировкаНажатие(Элемент, СтандартнаяОбработка)
//	ОткрытьФорму("Документ.КорректировкаТранзакции.ФормаОбъекта",,Корректировка);
//КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректировку(Команда)
	ПараметрыФормы = Новый Структура("Основание", Объект.Ссылка);
	ОткрытьФорму("Документ.КорректировкаТранзакции.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписьКорректировки" Тогда
		Если Параметр.ПометкаУдаления Тогда
			Элементы.Корректировка.Видимость = Ложь;
			Элементы.СоздатьКорректировку.Видимость = Истина;
		Иначе
			Элементы.Корректировка.Видимость = Истина;
			Элементы.СоздатьКорректировку.Видимость = Ложь;
			Корректировка = Параметр.Корректировка;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры




 
