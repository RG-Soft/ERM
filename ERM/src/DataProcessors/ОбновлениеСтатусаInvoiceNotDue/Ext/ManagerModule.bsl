﻿&НаСервере
Процедура ЗаполнитьСтатусInvoiceNotDue() Экспорт 
	
	//Если ДатаОстатков = '00010101' Тогда
	//	ДатаОстатков = НачалоДня(ТекущаяДата());
	//КонецЕсли;
	//
	//Если ДатаКомментария = '00010101' Тогда
	//	ДатаКомментария = НачалоДня(ТекущаяДата());
	//КонецЕсли;
	
	Дата = НачалоДня(ТекущаяДата());
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	BilledARОстатки.Invoice
		|ИЗ
		|	РегистрНакопления.BilledAR.Остатки(&Дата, ) КАК BilledARОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments КАК InvoiceComments
		|		ПО BilledARОстатки.Invoice = InvoiceComments.Invoice
		|ГДЕ
		|	InvoiceComments.Invoice ЕСТЬ NULL 
		|	И BilledARОстатки.Invoice.DueDateTo > &Дата";
	
	//Запрос.УстановитьПараметр("Дата", ДатаОстатков);
	Запрос.УстановитьПараметр("Дата", Дата);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	User = ПараметрыСеанса.ТекущийПользователь;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	НаборЗаписей = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		НаборЗаписей.Очистить();
		НаборЗаписей.Отбор.Invoice.Установить(ВыборкаДетальныеЗаписи.Invoice);
		
		СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, ConfirmedBy, CustomerRepresentative, CustomerInputDetails, Comment, CustInputDate, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");
		СтруктураРеквизитовПроблемы.Дата = Дата;
		СтруктураРеквизитовПроблемы.Invoice = ВыборкаДетальныеЗаписи.Invoice;
		СтруктураРеквизитовПроблемы.Status = Перечисления.InvoiceStatus.InvoiceNotDue;
		СтруктураРеквизитовПроблемы.User = User;
		
		НачатьТранзакцию();
		
		Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
		
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Период = Дата;
		НоваяЗапись.Invoice = ВыборкаДетальныеЗаписи.Invoice;
		//НоваяЗапись.Status = Перечисления.InvoiceStatus.InvoiceNotDue;
		//НоваяЗапись.User = User;
		НоваяЗапись.Problem = Problem;
		НаборЗаписей.Записать(Ложь);
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
КонецПроцедуры
