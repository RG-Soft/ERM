
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
	
	МассивСтатусов = ЭтаФорма.ПодчиненныеЭлементы.Status.СписокВыбора.ВыгрузитьЗначения();
	
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.CustomerIsInsolventOrBankrupt);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PendingSLBDocumentation);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.Pricing);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.TechnicalSQ);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.LostInHole);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PendingInvoiceApproval);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PendingPaymentAllocation);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.ClientConfirmedPayment);
	Если НЕ АвтоматическоеЗаполнениеСтатуса Тогда
		МассивСтатусов.Добавить(Перечисления.InvoiceStatus.InvoicePaid);
	КонецЕсли;
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.EscalatedToSales);
	Если НЕ АвтоматическоеЗаполнениеСтатуса Тогда
		МассивСтатусов.Добавить(Перечисления.InvoiceStatus.InvoiceNotDue);
	КонецЕсли;
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.CustomerIsUnavailable);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.ClientHasLiquidityProblems);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.BillingError);
	//МассивСтатусов.Добавить(Перечисления.InvoiceStatus.PartiallyPaid);
	
	ЭтаФорма.ПодчиненныеЭлементы.Status.СписокВыбора.ЗагрузитьЗначения(МассивСтатусов);
	
	Если Параметры.СтруктураДанныхТекущейСтроки.Свойство("RemainingAmount") И Параметры.СтруктураДанныхТекущейСтроки.Свойство("Currency") Тогда
	
		RemainingAmount = Параметры.СтруктураДанныхТекущейСтроки.RemainingAmount;
		Элементы.RemainingAmountValue.Заголовок = Элементы.RemainingAmountValue.Заголовок + " " + Строка(RemainingAmount) + " " + Параметры.СтруктураДанныхТекущейСтроки.Currency;
	
	Иначе
		
		Элементы.RemainingAmountValue.Заголовок = " ";
		
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Параметры.СтруктураДанныхТекущейСтроки);
	
	//FiscalInvNo = Параметры.СтруктураДанныхТекущейСтроки.FiscalInvoiceNo;
	Контракт = Параметры.СтруктураДанныхТекущейСтроки.Invoice.Contract;

	Если ЗначениеЗаполнено(Контракт) Тогда
	
		PTFrom = Контракт.PTDaysFrom;
		PTTo = Контракт.СрокОплаты;
		Trigger = Контракт.Trigger;
		
	КонецЕсли; 
	
	StatusПриИзмененииНаСервере(Status);
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
	
	СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, StatusOfDispute, StatusOfDebt, DebtAmount, DisputeDistributedDate, 
		|DateEntered, DateIdentified, DisputCollectableDate, TriggerDate, ConfirmedBy, CustomerRepresentative, 
		|CustomerInputDetails, Comment, CustInputDate, Potential, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитовПроблемы, ЭтотОбъект);
	СтруктураРеквизитовПроблемы.Дата = ТекущийОбъект.Период;
	СтруктураРеквизитовПроблемы.Invoice = ТекущийОбъект.Invoice;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Problem) Тогда
		РегистрыСведений.InvoiceComments.ПерезаполнитьРеквизитыInvoiceProblem(ТекущийОбъект.Problem, СтруктураРеквизитовПроблемы);
	Иначе
		ТекущийОбъект.Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
	КонецЕсли;
	
	ДокInvoice = ТекущийОбъект.Invoice.ПолучитьОбъект();
	ДокInvoice.TriggerDate = ЭтотОбъект.TriggerDate;
	ДокInvoice.Записать(РежимЗаписиДокумента.Запись);
	
КонецПроцедуры

&НаСервере
Процедура StatusПриИзмененииНаСервере(ЗначениеCтатуса)
	
	Если ЗначениеCтатуса = Перечисления.InvoiceStatus.ClientConfirmedPayment Тогда
	
		УстановитьДоступностьПолейDebt(Истина, Истина);
		
	ИначеЕсли ЗначениеCтатуса = Перечисления.InvoiceStatus.PartiallyPaid  Тогда
		
		УстановитьДоступностьПолейDebt(Истина, Ложь);
		
	Иначе
		
		StatusOfDebt = Неопределено;
		DebtAmount = 0;
		УстановитьДоступностьПолейDebt(Ложь, Ложь);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура StatusПриИзменении(Элемент)
	
	StatusПриИзмененииНаСервере(Status);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьПолейDebt(ДоступностьСтатуса, ДоступностьЗадолженности)
	
	Элементы.StatusOfDebt.Доступность = ДоступностьСтатуса;
	Элементы.DebtAmount.Доступность = ДоступностьЗадолженности;
	Элементы.RemainingAmountValue.Доступность = ДоступностьЗадолженности;
	
КонецПроцедуры 

&НаСервере
Процедура StatusOfDebtПриИзмененииНаСервере()
	
	Если StatusOfDebt = Перечисления.InvoiceStatus.ПустаяСсылка() Тогда
	
		DebtAmount = 0;
	
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура StatusOfDebtПриИзменении(Элемент)
	StatusOfDebtПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбнулитьDebtAmount()

	Если RemainingAmount >= 0 Тогда
	
		ОбнулитьDebtAmount = ?(DebtAmount > RemainingAmount ИЛИ DebtAmount < 0, Истина, Ложь);
		
	Иначе 
	
		ОбнулитьDebtAmount = ?(DebtAmount < RemainingAmount ИЛИ DebtAmount > 0, Истина, Ложь);
	
	КонецЕсли;
	
	Если ОбнулитьDebtAmount Тогда
	
		DebtAmount = 0;
		Сообщить("Incorrect debt amount!");
	
	КонецЕсли; 

КонецПроцедуры
 
&НаКлиенте
Процедура DebtAmountПриИзменении(Элемент)
	ОбнулитьDebtAmount();
КонецПроцедуры

