
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	SalesOrdersCommentsСрезПоследних.Problem
		|ИЗ
		|	РегистрСведений.SalesOrdersComments.СрезПоследних(, SalesOrder = &SalesOrder) КАК SalesOrdersCommentsСрезПоследних";
	
	Запрос.УстановитьПараметр("SalesOrder", ТекущийОбъект.SalesOrder);
	
	НачатьТранзакцию();
	ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
	ЗафиксироватьТранзакцию();
	
	НачатьТранзакцию();
	Если ВыборкаДетальныеЗаписи.Следующий() И ВыборкаДетальныеЗаписи.Problem <> LastProblem Тогда
		ТекстСообщенияОбОшибках = "The status of the Sales Order has been changed by another user.";
		ВызватьИсключение ТекстСообщенияОбОшибках;
		Отказ = Истина;
	Иначе
		СтруктураРеквизитовПроблемы = Новый Структура("Дата, SalesOrder, User, Reason, Billed, ExpectedDateForInvoice, EscalateTo, Details, Responsibles, FollowUpDate, ActionItem");
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитовПроблемы, ЭтотОбъект);
		СтруктураРеквизитовПроблемы.Дата = ТекущийОбъект.Период;
		СтруктураРеквизитовПроблемы.SalesOrder = ТекущийОбъект.SalesOrder;
		
		Если ЗначениеЗаполнено(ТекущийОбъект.Problem) Тогда
			РегистрыСведений.SalesOrdersComments.ПерезаполнитьРеквизитыSalesOrderProblem(ТекущийОбъект.Problem, СтруктураРеквизитовПроблемы);
		Иначе
			ТекущийОбъект.Problem = РегистрыСведений.SalesOrdersComments.СоздатьSalesOrderProblem(СтруктураРеквизитовПроблемы);
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Запись.SalesOrder) = Тип("ДокументСсылка.SalesOrder") И Responsibles.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Responsibles are empty!", , "Responsibles", , ?(ЗначениеЗаполнено(EscalateTo), Отказ, Неопределено));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(EscalateTo) Тогда
		РегистрыСведений.SalesOrdersComments.ПроверитьНастройкиНотификаций(Запись.SalesOrder, Отказ);
		Если Отказ Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Notification configured incorrectly! See 'Unbilled notification recipients'.", , , , );
		КонецЕсли;
	КонецЕсли;
	
	Если Отказ Тогда
		ОтменитьТранзакцию();
	Иначе
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Если Запись.SalesOrder = Документы.SalesOrder.ПустаяСсылка() Тогда
	//	ТекстСообщенияОбОшибках = "Selected not Sales orders";
	//	ВызватьИсключение ТекстСообщенияОбОшибках;
	//	Отказ = Истина;
	//КонецЕсли;
	Если ТипЗнч(Запись.SalesOrder) = Тип("ДокументСсылка.РучнаяКорректировка") Тогда
		Элементы.EscalateTo.Доступность = Ложь;
	КонецЕсли;
	
	Если ТипЗнч(Запись.SalesOrder) = Тип("ДокументСсылка.SalesOrder")
			И (Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.Lawson ИЛИ Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.OracleMI
			ИЛИ Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.OracleSmith ИЛИ Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.HOBs И Запись.SalesOrder.Company <> Справочники.Организации.НайтиПоКоду("385")) Тогда
	
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ExceptionsIntercoClientsForUnbilledStatus.Source,
			|	ExceptionsIntercoClientsForUnbilledStatus.Client
			|ИЗ
			|	РегистрСведений.ExceptionsIntercoClientsForUnbilledStatus КАК ExceptionsIntercoClientsForUnbilledStatus
			|ГДЕ
			|	ExceptionsIntercoClientsForUnbilledStatus.Client = &Client
			|	И ExceptionsIntercoClientsForUnbilledStatus.Source = &Source";
		
		Запрос.УстановитьПараметр("Client", Запись.SalesOrder.Client);
		Запрос.УстановитьПараметр("Source", Запись.SalesOrder.Source);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
				Элементы.Billed.Доступность = Ложь;
			КонецЕсли;
			
	КонецЕсли;
	
	Если Параметры.Ключ.Пустой() Тогда
		Запись.Период = РГСофт.ПолучитьДатуСервера();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(User) Тогда
		User = Пользователи.ТекущийПользователь();
	КонецЕсли;
	
	Если Запись.Problem.Пустая() Тогда
		
		Если Не ЗначениеЗаполнено(Billed) Тогда
			Billed = Перечисления.SalesOrderBilledStatus.Unbilled;
		КонецЕсли;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	SalesOrdersCommentsСрезПоследних.Problem,
			|	SalesOrdersCommentsСрезПоследних.Problem.Reason КАК Reason,
			|	SalesOrdersCommentsСрезПоследних.Problem.Billed КАК Billed,
			|	SalesOrdersCommentsСрезПоследних.Problem.ExpectedDateForInvoice КАК ExpectedDateForInvoice,
			|	SalesOrdersCommentsСрезПоследних.Problem.EscalateTo КАК EscalateTo,
			|	SalesOrdersCommentsСрезПоследних.Problem.Details КАК Details,
			|	SalesOrdersCommentsСрезПоследних.Problem.ActionItem КАК ActionItem,
			|	SalesOrdersCommentsСрезПоследних.Период
			|ИЗ
			|	РегистрСведений.SalesOrdersComments.СрезПоследних(, SalesOrder = &SalesOrder) КАК SalesOrdersCommentsСрезПоследних";
		
		Запрос.УстановитьПараметр("SalesOrder", Запись.SalesOrder);
		
		НачатьТранзакцию();
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		ЗафиксироватьТранзакцию();
		
		НачалоТекМесяца = НачалоМесяца(ТекущаяДата());
		
		Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
			ВыборкаДетальныеЗаписи.Следующий();
			
			Если ТипЗнч(Запись.SalesOrder) = Тип("ДокументСсылка.SalesOrder")
					И (ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Billed ИЛИ ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Canceled)
					И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Reason) И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ExpectedDateForInvoice)
					И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.EscalateTo) И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Details) И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ActionItem)
					И (ВыборкаДетальныеЗаписи.Период > НачалоТекМесяца) Тогда
					
				ТекстСообщенияОбОшибках = "Adding a status is impossible! Selected Sales Order in status billed.";
				ВызватьИсключение ТекстСообщенияОбОшибках;
				Отказ = Истина;
				
			Иначе
				
				Если ТипЗнч(Запись.SalesOrder) = Тип("ДокументСсылка.SalesOrder") И (ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Billed ИЛИ ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Canceled) Тогда
					Элементы.Billed.Доступность = Ложь;
				КонецЕсли;
				
				Если ВыборкаДетальныеЗаписи.Период >= НачалоТекМесяца Тогда
					
					Billed = ВыборкаДетальныеЗаписи.Billed;
					Reason = ВыборкаДетальныеЗаписи.Reason;
					ExpectedDateForInvoice = ВыборкаДетальныеЗаписи.ExpectedDateForInvoice;
					EscalateTo = ВыборкаДетальныеЗаписи.EscalateTo;
					Details = ВыборкаДетальныеЗаписи.Details;
					ActionItem = ВыборкаДетальныеЗаписи.ActionItem;
					LastProblem = ВыборкаДетальныеЗаписи.Problem;
					
				Иначе
				
					Billed = ВыборкаДетальныеЗаписи.Billed;
					LastProblem = ВыборкаДетальныеЗаписи.Problem;
					
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(Запись.SalesOrder) = Тип("ДокументСсылка.SalesOrder") И Responsibles.Количество() = 0 Тогда
		
		МассивОтветственных = Документы.SalesOrder.ПолучитьОтветственныхПоSO(Запись.SalesOrder, EscalateTo);
		Для каждого ТекОтветственный Из МассивОтветственных Цикл
			НоваяСтрока = Responsibles.Добавить();
			НоваяСтрока.Responsible = ТекОтветственный;
		КонецЦикла;
		
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
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, ТекПроблема, , "Responsibles");
		ЗначениеВРеквизитФормы(ТекПроблема.Responsibles.Выгрузить(), "Responsibles");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура EscalateToПриИзменении(Элемент)
	EscalateToПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура EscalateToПриИзмененииНаСервере()
	
	Если ТипЗнч(Запись.SalesOrder) = Тип("ДокументСсылка.SalesOrder") Тогда
		
		Responsibles.Очистить();
		МассивОтветственных = Документы.SalesOrder.ПолучитьОтветственныхПоSO(Запись.SalesOrder, EscalateTo);
		
		Для каждого ТекОтветственный Из МассивОтветственных Цикл
			НоваяСтрока = Responsibles.Добавить();
			НоваяСтрока.Responsible = ТекОтветственный;
		КонецЦикла;
		
	КонецЕсли;
		
КонецПроцедуры







