﻿
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ТолькоПросмотр = Истина;
	
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
