
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Запись.Период = РГСофт.ПолучитьДатуСервера();
	Если Не ЗначениеЗаполнено(User) Тогда
		User = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Запись.Problem.Пустая() Тогда
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status,
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
	
	СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, ConfirmedBy, CustomerRepresentative, CustomerInputDetails, Comment, CustInputDate, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");
	ЗаполнитьЗначенияСвойств(СтруктураРеквизитовПроблемы, ЭтотОбъект);
	СтруктураРеквизитовПроблемы.Дата = ТекущийОбъект.Период;
	СтруктураРеквизитовПроблемы.Invoice = ТекущийОбъект.Invoice;
	
	Если ЗначениеЗаполнено(ТекущийОбъект.Problem) Тогда
		РегистрыСведений.InvoiceComments.ПерезаполнитьРеквизитыInvoiceProblem(ТекущийОбъект.Problem, СтруктураРеквизитовПроблемы);
	Иначе
		ТекущийОбъект.Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
	КонецЕсли;
	
КонецПроцедуры
