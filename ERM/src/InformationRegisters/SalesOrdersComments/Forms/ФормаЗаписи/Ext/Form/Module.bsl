﻿
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
	
	Если Responsibles.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Responsibles are empty!", , "Responsibles", , ?(ЗначениеЗаполнено(EscalateTo), Отказ, Неопределено));
	КонецЕсли;
	
	Если ЗначениеЗаполнено(EscalateTo) Тогда
		ПроверитьНастройкиНотификаций(Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНастройкиНотификаций(Отказ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПолучателиУведомленийUnbilled.Уровень) КАК КоличествоУровней
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыДляНотификацийSO КАК ИдентификаторыДляНотификацийSO
		|		ПО ПолучателиУведомленийUnbilled.Source = ИдентификаторыДляНотификацийSO.Source
		|			И ПолучателиУведомленийUnbilled.Идентификатор1 = ИдентификаторыДляНотификацийSO.Идентификатор1
		|			И ПолучателиУведомленийUnbilled.Идентификатор2 = ИдентификаторыДляНотификацийSO.Идентификатор2
		|			И (ИдентификаторыДляНотификацийSO.SalesOrder = &SalesOrder)
		|			И (ПолучателиУведомленийUnbilled.Получатель <> ЗНАЧЕНИЕ(Справочник.LDAPUsers.ПустаяСсылка))
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ПолучателиУведомленийUnbilled.Уровень) КАК КоличествоУровней
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыДляНотификацийSO КАК ИдентификаторыДляНотификацийSO
		|		ПО ПолучателиУведомленийUnbilled.Source = ИдентификаторыДляНотификацийSO.Source
		|			И ПолучателиУведомленийUnbilled.Идентификатор1 = ИдентификаторыДляНотификацийSO.Идентификатор1
		|			И (ПолучателиУведомленийUnbilled.Идентификатор2 = НЕОПРЕДЕЛЕНО
		|				ИЛИ ПолучателиУведомленийUnbilled.Идентификатор2 = """"
		|				ИЛИ ПолучателиУведомленийUnbilled.Идентификатор2 = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))
		|			И (ИдентификаторыДляНотификацийSO.SalesOrder = &SalesOrder)
		|			И (ПолучателиУведомленийUnbilled.Получатель <> ЗНАЧЕНИЕ(Справочник.LDAPUsers.ПустаяСсылка))";
	
	Запрос.УстановитьПараметр("SalesOrder", Запись.SalesOrder);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаДетальныеЗаписи1 = МассивРезультатов[0].Выбрать();
	ВыборкаДетальныеЗаписи2 = МассивРезультатов[1].Выбрать();
	
	ВыборкаДетальныеЗаписи1.Следующий();
	ВыборкаДетальныеЗаписи2.Следующий();
	
	Если ВыборкаДетальныеЗаписи1.КоличествоУровней <> 4 И ВыборкаДетальныеЗаписи2.КоличествоУровней <> 4 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Notification configured incorrectly! See 'Unbilled notification recipients'.", , , , Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.Lawson ИЛИ Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.OracleMI ИЛИ
		Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.OracleSmith ИЛИ Запись.SalesOrder.Source = Перечисления.ТипыСоответствий.HOBs И Запись.SalesOrder.Company = Справочники.Организации.НайтиПоКоду("385") Тогда
		Элементы.Billed.Доступность = Ложь;
	КонецЕсли;
	
	Запись.Период = РГСофт.ПолучитьДатуСервера();
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
			|	SalesOrdersCommentsСрезПоследних.Problem.Reason как Reason,
			|	SalesOrdersCommentsСрезПоследних.Problem.Billed как Billed,
			|	SalesOrdersCommentsСрезПоследних.Problem.ExpectedDateForInvoice как ExpectedDateForInvoice,
			|	SalesOrdersCommentsСрезПоследних.Problem.EscalateTo как EscalateTo,
			|	SalesOrdersCommentsСрезПоследних.Problem.Details как Details
			|ИЗ
			|	РегистрСведений.SalesOrdersComments.СрезПоследних(, SalesOrder = &SalesOrder) КАК SalesOrdersCommentsСрезПоследних";
		
		Запрос.УстановитьПараметр("SalesOrder", Запись.SalesOrder);
		
		НачатьТранзакцию();
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		ЗафиксироватьТранзакцию();
		
		Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
			ВыборкаДетальныеЗаписи.Следующий();
			Если (ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Billed ИЛИ ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Canceled)
				И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Reason) И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ExpectedDateForInvoice)
				И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.EscalateTo) И ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Details) Тогда
				ТекстСообщенияОбОшибках = "Adding a status is impossible! Selected Sales Order in status billed.";
				ВызватьИсключение ТекстСообщенияОбОшибках;
				Отказ = Истина;
			Иначе
				Billed = ВыборкаДетальныеЗаписи.Billed;
				Reason = ВыборкаДетальныеЗаписи.Reason;
				ExpectedDateForInvoice = ВыборкаДетальныеЗаписи.ExpectedDateForInvoice;
				EscalateTo = ВыборкаДетальныеЗаписи.EscalateTo;
				Details = ВыборкаДетальныеЗаписи.Details;
				LastProblem = ВыборкаДетальныеЗаписи.Problem;
				
				Если (ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Billed ИЛИ ВыборкаДетальныеЗаписи.Billed = Перечисления.SalesOrderBilledStatus.Canceled) Тогда
					Элементы.Billed.Доступность = Ложь;
				КонецЕсли;
				
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Если Responsibles.Количество() = 0 Тогда
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
	
	Responsibles.Очистить();
	МассивОтветственных = Документы.SalesOrder.ПолучитьОтветственныхПоSO(Запись.SalesOrder, EscalateTo);
	Для каждого ТекОтветственный Из МассивОтветственных Цикл
		НоваяСтрока = Responsibles.Добавить();
		НоваяСтрока.Responsible = ТекОтветственный;
	КонецЦикла;
	
КонецПроцедуры







