﻿&НаСервере
Процедура ЗаполнитьСтатусInvoiceNotDue(ДатаОстатков = '00010101',ДатаКомментария = '00010101') Экспорт 
	
	Если ДатаОстатков = '00010101' Тогда
		ДатаОстатков = НачалоДня(ТекущаяДата());
	КонецЕсли;
	
	Если ДатаКомментария = '00010101' Тогда
		ДатаКомментария = НачалоДня(ТекущаяДата());
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	BilledARОстатки.Invoice КАК Invoice,
		|	BilledARОстатки.Invoice.DueDateTo
		|ПОМЕСТИТЬ Инвойсы
		|ИЗ
		|	РегистрНакопления.BilledAR.Остатки(&Дата, ) КАК BilledARОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	BilledAR.Invoice,
		|	BilledAR.Invoice.DueDateTo
		|ИЗ
		|	РегистрНакопления.BilledAR КАК BilledAR
		|ГДЕ
		|	BilledAR.Период >= &НачалоТекущегоМесяца
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Инвойсы.Invoice
		|ИЗ
		|	Инвойсы КАК Инвойсы
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments КАК InvoiceComments
		|		ПО Инвойсы.Invoice = InvoiceComments.Invoice
		|ГДЕ
		|	InvoiceComments.Invoice ЕСТЬ NULL 
		|	И Инвойсы.InvoiceDueDateTo > &Дата";
	
	Запрос.УстановитьПараметр("Дата", ДатаОстатков);
	Запрос.УстановитьПараметр("НачалоТекущегоМесяца", НачалоМесяца(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	User = ПараметрыСеанса.ТекущийПользователь;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	НаборЗаписей = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		НаборЗаписей.Очистить();
		НаборЗаписей.Отбор.Invoice.Установить(ВыборкаДетальныеЗаписи.Invoice);
		НоваяЗапись = НаборЗаписей.Добавить();
		НоваяЗапись.Invoice = ВыборкаДетальныеЗаписи.Invoice;
		НоваяЗапись.Status = Перечисления.InvoiceStatus.InvoiceNotDue;
		НоваяЗапись.Период = ДатаКомментария;
		НоваяЗапись.User = User;
		НаборЗаписей.Записать(Ложь);
	КонецЦикла;
	
КонецПроцедуры
