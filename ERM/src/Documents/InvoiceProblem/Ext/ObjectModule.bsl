﻿
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
	
	//Если ЗначениеЗаполнено(EscalateTo) Тогда
	//	
	//	ДобавитьВОчередьУведомлений();
	//	
	//КонецЕсли;
	
КонецПроцедуры
