
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ДополнительныеСвойства.Свойство("РазрешитьРедактирование") Тогда
		Возврат;	
	КонецЕсли;
	
	Если Количество() = 0 И Замещение Тогда
		Прочитать();
		Отказ =  Количество() > 0;
	КонецЕсли;
	
	AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
	
	Для каждого ЗаписьРегистра Из ЭтотОбъект Цикл
		
		АвтоматическоеЗаполнениеСтатуса = Ложь;
		
		SourceInvoice = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаписьРегистра.Invoice,"Source");
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ИсточникиСАвтоматичекимЗаполнениемСтатусов.Source
			|ИЗ
			|	РегистрСведений.ИсточникиСАвтоматичекимЗаполнениемСтатусов КАК ИсточникиСАвтоматичекимЗаполнениемСтатусов
			|ГДЕ
			|	ИсточникиСАвтоматичекимЗаполнениемСтатусов.Source.Ссылка = &Source";
		
		Запрос.УстановитьПараметр("Source", SourceInvoice);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
			АвтоматическоеЗаполнениеСтатуса = Истина
		КонецЕсли;
		
		ЗначениеРеквизитовПроблемы = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗаписьРегистра.Problem, "Status, User");
		
		Если АвтоматическоеЗаполнениеСтатуса И 
			(ЗначениеРеквизитовПроблемы.Status = Перечисления.InvoiceStatus.InvoicePaid ИЛИ ЗначениеРеквизитовПроблемы.Status = Перечисления.InvoiceStatus.InvoiceNotDue) И
			ЗначениеРеквизитовПроблемы.User <> AutoUser Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("For " + SourceInvoice +" source, the status " + ЗначениеРеквизитовПроблемы.Status + " is filled automatically.",,,,Отказ);
		КонецЕсли;

	КонецЦикла;

КонецПроцедуры
