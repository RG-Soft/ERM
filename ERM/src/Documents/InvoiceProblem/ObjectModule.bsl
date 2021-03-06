#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() ИЛИ ОбменДанными.Загрузка Тогда
		
		SLBAssignedToСтрокой = "";
		
		Если SLBAssignedTo.Количество() > 0 Тогда
			Для каждого СтрокаТЧ Из SLBAssignedTo Цикл
				SLBAssignedToСтрокой = SLBAssignedToСтрокой + СтрокаТЧ.AssignedTo + ", ";
			КонецЦикла;
			SLBAssignedToСтрокой = Лев(SLBAssignedToСтрокой, СтрДлина(SLBAssignedToСтрокой) - 2);
		КонецЕсли;
		
		Если SLBAssignedToList <> SLBAssignedToСтрокой Тогда
			SLBAssignedToList = SLBAssignedToСтрокой;
		КонецЕсли;
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(RWDTargetDate) И Status <> Перечисления.InvoiceStatus.InvoicePaid Тогда
		
		ДобавитьВОчередьУведомленийRWDDeadline();
		
	КонецЕсли;
		
	Если ЗначениеЗаполнено(ForecastDate) И Status <> Перечисления.InvoiceStatus.InvoicePaid Тогда
		
		ДобавитьВОчередьУведомленийBrokenPromises();
		
	КонецЕсли;
	// { RGS AGorlenko1 04.03.2020 14:58:39 - S-E-0001469-Запись данных в регистр дат для Collection target
	Если Не ОбменДанными.Загрузка И ЗначениеЗаполнено(TriggerDate) Тогда
			
			ПустаяДата = Дата("00010101000000");
			
			СтруктураДатДляЗаписиВРегистр = Новый Структура("TriggerDate, DateFrom, DateTo", TriggerDate, ПустаяДата, ПустаяДата);
			
			Contract = Invoice.Contract;
			
			Если ЗначениеЗаполнено(Contract) Тогда
				
				СтруктураДанныхКонтракта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Contract, "PTDaysFrom, СрокОплаты, PTType");
				ЗаполнитьЗначенияСвойств(СтруктураДатДляЗаписиВРегистр, Документы.Invoice.РассчитатьDateFromИDateTo(Invoice, СтруктураДанныхКонтракта, TriggerDate));
				
			КонецЕсли;
			
			РГСофт.ЗаписатьДанныеВРегистрДатДляCollection(Дата, Invoice, СтруктураДатДляЗаписиВРегистр);
			
	КонецЕсли;
	// } RGS AGorlenko1 04.03.2020 14:59:19 - S-E-0001469-Запись данных в регистр дат для Collection target
	
КонецПроцедуры

Процедура ДобавитьВОчередьУведомленийRWDDeadline()
	
	НЗ = РегистрыСведений.ОчередьУведомлений.СоздатьНаборЗаписей();
	НЗ.Отбор.Проблема.Установить(Ссылка);
	
	ЗаписьРегистра = НЗ.Добавить();
	ЗаписьРегистра.Проблема = Ссылка;
	ЗаписьРегистра.ВидУведомления = Справочники.ВидыУведомлений.RWDDeadlinePrimary;
	ЗаписьРегистра.ДатаУведомления = RWDTargetDate;
	
	НЗ.Записать();
	
КонецПроцедуры

Процедура ДобавитьВОчередьУведомленийBrokenPromises()
	
	НЗ = РегистрыСведений.ОчередьУведомлений.СоздатьНаборЗаписей();
	НЗ.Отбор.Проблема.Установить(Ссылка);
	
	ЗаписьРегистра = НЗ.Добавить();
	ЗаписьРегистра.Проблема = Ссылка;
	ЗаписьРегистра.ВидУведомления = Справочники.ВидыУведомлений.BrokenPromises;
	ЗаписьРегистра.ДатаУведомления = КалендарныеГрафики.ПолучитьДатуПоКалендарю(КалендарныеГрафики.ПроизводственныйКалендарьРоссийскойФедерации(), ForecastDate, 1);
	
	НЗ.Записать();
	
КонецПроцедуры

#КонецЕсли

