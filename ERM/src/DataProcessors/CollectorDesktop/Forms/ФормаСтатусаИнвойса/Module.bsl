
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Период = РГСофт.ПолучитьДатуСервера();
	Если Не ЗначениеЗаполнено(User) Тогда
		User = Пользователи.ТекущийПользователь();
	КонецЕсли;

	СписокИнвойсов = Параметры.СписокИнвойсов;
	
	АвтоматическоеЗаполнениеСтатуса = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ИсточникиСАвтоматичекимЗаполнениемСтатусов.Source
		|ИЗ
		|	РегистрСведений.ИсточникиСАвтоматичекимЗаполнениемСтатусов КАК ИсточникиСАвтоматичекимЗаполнениемСтатусов
		|ГДЕ
		|	ИсточникиСАвтоматичекимЗаполнениемСтатусов.Source.Ссылка = &Source";
	
	Запрос.УстановитьПараметр("Source", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СписокИнвойсов[0].Значение,"Source"));
	
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
КонецПроцедуры

&НаСервере
Процедура SaveНаСервере()
	
	НЗ = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	НЗ.Отбор.Период.Установить(Период);
	
	Для каждого ЭлементСписка Из СписокИнвойсов Цикл
		
		СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, ConfirmedBy, CustomerRepresentative, CustomerInputDetails, Comment, CustInputDate, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитовПроблемы, ЭтотОбъект);
		СтруктураРеквизитовПроблемы.Дата = Период;
		СтруктураРеквизитовПроблемы.Invoice = ЭлементСписка.Значение;
		
		НачатьТранзакцию();
		
		Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
		
		НЗ.Очистить();
		НЗ.Отбор.Invoice.Установить(ЭлементСписка.Значение);
		
		Запись = НЗ.Добавить();
		Запись.Период = Период;
		Запись.Invoice = ЭлементСписка.Значение;
		//Запись.User = User;
		//Запись.Status = Status;
		//Запись.ConfirmedBy = ConfirmedBy;
		//Запись.Comment = Comment;
		//Запись.ForecastDate = ForecastDate;
		//Запись.CustInputDate = CustInputDate;
		//Запись.CustomerRepresentative = CustomerRepresentative;
		//Запись.CustomerInputDetails = CustomerInputDetails;
		//Запись.SLBAssignedTo = SLBAssignedTo;
		//Запись.RemedialWorkPlan = RemedialWorkPlan;
		//Запись.RWDTargetDate = RWDTargetDate;
		Запись.Problem = Problem;
		
		НЗ.Записать(Ложь);
		
		ЗафиксироватьТранзакцию();
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура Save(Команда)
	
	SaveНаСервере();
	
	Закрыть();
	
КонецПроцедуры
