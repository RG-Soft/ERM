
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Ключ.Пустой() Тогда
		Запись.Период = РГСофт.ПолучитьДатуСервера();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(User) Тогда
		User = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Запись.Problem.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status,
			|	InvoiceCommentsСрезПоследних.Problem.StatusOfDispute КАК StatusOfDispute,
			|	InvoiceCommentsСрезПоследних.Problem.DisputeDistributedDate КАК DisputeDistributedDate,
			|	InvoiceCommentsСрезПоследних.Problem.DateEntered КАК DateEntered, 
			|	InvoiceCommentsСрезПоследних.Problem.DateIdentified КАК DateIdentified, 
			|	InvoiceCommentsСрезПоследних.Problem.DisputCollectableDate КАК DisputCollectableDate, 
			|	InvoiceCommentsСрезПоследних.Problem.ConfirmedBy КАК ConfirmedBy,
			|	InvoiceCommentsСрезПоследних.Problem.ForecastDate КАК ForecastDate,
			|	InvoiceCommentsСрезПоследних.Problem.CustInputDate КАК CustInputDate,
			|	InvoiceCommentsСрезПоследних.Problem.CustomerRepresentative КАК CustomerRepresentative,
			|	InvoiceCommentsСрезПоследних.Problem.CustomerInputDetails КАК CustomerInputDetails,
			|	InvoiceCommentsСрезПоследних.Problem.RemedialWorkPlan КАК RemedialWorkPlan,
			|	InvoiceCommentsСрезПоследних.Problem.RWDTargetDate КАК RWDTargetDate
			|ИЗ
			|	РегистрСведений.InvoiceComments.СрезПоследних(, Invoice = &Invoice) КАК InvoiceCommentsСрезПоследних";
		
		Запрос.УстановитьПараметр("Invoice", Запись.Invoice);
		
		НачатьТранзакцию();
		РезультатЗапроса = Запрос.Выполнить();
		ЗафиксироватьТранзакцию();
		
		Если НЕ РезультатЗапроса.Пустой() Тогда
			
			ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
			ВыборкаДетальныеЗаписи.Следующий();
			
			ЗаполнитьЗначенияСвойств(ЭтаФорма, ВыборкаДетальныеЗаписи);
			
		КонецЕсли;
		
	КонецЕсли;
	
	АвтоматическоеЗаполнениеСтатуса = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсточникиСАвтоматичекимЗаполнениемСтатусов.Source
		|ИЗ
		|	РегистрСведений.ИсточникиСАвтоматичекимЗаполнениемСтатусов КАК ИсточникиСАвтоматичекимЗаполнениемСтатусов
		|ГДЕ
		|	ИсточникиСАвтоматичекимЗаполнениемСтатусов.Source.Ссылка = &Source";
	
	Запрос.УстановитьПараметр("Source", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Invoice,"Source"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		АвтоматическоеЗаполнениеСтатуса = Истина
	КонецЕсли;
	
	МассивСтатусов = Новый Массив;
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.CustomerIsInsolventOrBankrupt);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PendingSLBDocumentation);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.Pricing);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.TechnicalSQ);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.LostInHole);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PendingInvoiceApproval);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PendingPaymentAllocation);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.ClientConfirmedPayment);
	Если НЕ АвтоматическоеЗаполнениеСтатуса Тогда
		МассивСтатусов.Добавить(Перечисления.InvoiceStatus.InvoicePaid);
	КонецЕсли;
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.EscalatedToSales);
	Если НЕ АвтоматическоеЗаполнениеСтатуса Тогда
		МассивСтатусов.Добавить(Перечисления.InvoiceStatus.InvoiceNotDue);
	КонецЕсли;
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.CustomerIsUnavailable);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.ClientHasLiquidityProblems);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.BillingError);
	МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PartiallyPaid);
	
	ЭтаФорма.ПодчиненныеЭлементы.Status.СписокВыбора.ЗагрузитьЗначения(МассивСтатусов);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ТолькоПросмотр = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Истина;
	ЭтаФорма.ТолькоПросмотр = Истина;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Problem) Тогда
		
		ТекПроблема = ТекущийОбъект.Problem.ПолучитьОбъект();
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ТекПроблема, , "SLBAssignedTo");
		ЗначениеВРеквизитФормы(ТекПроблема.SLBAssignedTo.Выгрузить(), "SLBAssignedTo");
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, StatusOfDispute, DisputeDistributedDate, 
		|DateEntered, DateIdentified, DisputCollectableDate, ConfirmedBy, CustomerRepresentative, 
		|CustomerInputDetails, Comment, CustInputDate, Potential, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитовПроблемы, ЭтотОбъект);
	СтруктураРеквизитовПроблемы.Дата = ТекущийОбъект.Период;
	СтруктураРеквизитовПроблемы.Invoice = ТекущийОбъект.Invoice;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Problem) Тогда
		РегистрыСведений.InvoiceComments.ПерезаполнитьРеквизитыInvoiceProblem(ТекущийОбъект.Problem, СтруктураРеквизитовПроблемы);
	Иначе
		ТекущийОбъект.Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
	КонецЕсли;
	
КонецПроцедуры