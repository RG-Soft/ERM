
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Параметры.Свойство("Recipients", 	Recipients);
	Параметры.Свойство("ReplyTo", 		ReplyTo);
	Параметры.Свойство("Subject", 		Subject);
	Параметры.Свойство("Copy", 			Copy);
	//Параметры.Свойство("Body", 			Body);
	
	Если Параметры.Свойство("Body") Тогда
		Body.УстановитьHTML(Параметры.Body, Новый Структура());
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Send(Команда)
	
	ИндексСтроки = 0;
	
	Пока ИндексСтроки < Recipients.Количество() Цикл
		
		СтрокаТЧ = Recipients[ИндексСтроки];
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Recipient) Тогда
			Recipients.Удалить(ИндексСтроки);
		Иначе
			ИндексСтроки = ИндексСтроки + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	ReplyTo = СокрЛП(ReplyTo);
	Subject = СокрЛП(Subject);
	Body = СокрЛП(Body);
	Copy = СокрЛП(Copy);
	
	Отказ = Ложь;
	Если Recipients.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Поле ""Recipients"" не заполнено",
			, "Recipients", , Отказ);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ReplyTo) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Поле ""Reply to"" не заполнено",
			, "ReplyTo", , Отказ);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Subject) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Поле ""Subject"" не заполнено",
			, "Subject", , Отказ);
	КонецЕсли; 
	
	//Если НЕ ЗначениеЗаполнено(Body) Тогда
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
	//		"Поле ""Body"" не заполнено",
	//		, "Body", , Отказ);
	//КонецЕсли; 

	Если НЕ Отказ Тогда
		
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("Recipients", 	Recipients);
		СтруктураВозврата.Вставить("ReplyTo", 		ReplyTo);
		СтруктураВозврата.Вставить("Subject", 		Subject);
		СтруктураВозврата.Вставить("Body", 			Body);
		СтруктураВозврата.Вставить("Copy", 			Copy);
		
		// ++ RG-Soft КДС 24.11.2016
		СтруктураВозврата.Вставить("TechDOC", 		TechDOC);
		СтруктураВозврата.Вставить("ТипТекста", 	ПредопределенноеЗначение("Перечисление.ТипыТекстовЭлектронныхПисем.HTML"));
		
		Успех = Истина;
		// -- RG-Soft КДС 24.11.2016
		
		ОповеститьОВыборе(СтруктураВозврата);

	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если TechDOC И НЕ Успех Тогда
		Оповестить("ОтказОтправкиЗапросаTechDOC", ЭтаФорма.ВладелецФормы);
	КонецЕсли;
	
КонецПроцедуры
