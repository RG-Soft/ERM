#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПерезаполнитьРеквизитыInvoiceProblem(Проблема, СтруктураРеквизитовПроблемы) Экспорт
	
	ТекОбъект = Проблема.ПолучитьОбъект();
	ЗаполнитьРеквизитыПроблемы(ТекОбъект, СтруктураРеквизитовПроблемы);
	ТекОбъект.Записать();
	
КонецПроцедуры

Функция СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы) Экспорт
	
	ТекОбъект = Документы.InvoiceProblem.СоздатьДокумент();
	ЗаполнитьРеквизитыПроблемы(ТекОбъект, СтруктураРеквизитовПроблемы);
	ТекОбъект.Записать();
	
	Возврат ТекОбъект.Ссылка;
	
КонецФункции

Процедура ЗаполнитьРеквизитыПроблемы(ПроблемаОбъект, СтруктураРеквизитовПроблемы)
	
	ЗаполнитьЗначенияСвойств(ПроблемаОбъект, СтруктураРеквизитовПроблемы);
	
	Если СтруктураРеквизитовПроблемы.SLBAssignedTo <> Неопределено Тогда
		Для каждого СтрокаТЧ Из СтруктураРеквизитовПроблемы.SLBAssignedTo Цикл
			ЗаполнитьЗначенияСвойств(ПроблемаОбъект.SLBAssignedTo.Добавить(), СтрокаТЧ);
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция ЗаписьЕстьВРегистре(СтруктураЗаписи) Экспорт
	
	НаборЗаписей = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	
	// Устанавливаем отбор по измерениям регистра.
	Для Каждого Элемент Из СтруктураЗаписи Цикл
		НаборЗаписей.Отбор[Элемент.Ключ].Установить(Элемент.Значение);
	КонецЦикла;

	НаборЗаписей.Прочитать();
	
	Возврат НаборЗаписей.Количество() > 0;
	
КонецФункции

Функция ПолучитьПоследниеКомментарииПоИнвойсам(МассивИнвойсов) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	InvoiceCommentsСрезПоследних.Invoice,
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status,
		|	InvoiceCommentsСрезПоследних.Problem.StatusOfDispute КАК StatusOfDispute,
		|	InvoiceCommentsСрезПоследних.Problem.DisputeDistributedDate КАК DisputeDistributedDate,
		|	InvoiceCommentsСрезПоследних.Problem.DisputCollectableDate КАК DisputCollectableDate,
		|	InvoiceCommentsСрезПоследних.Problem.DateEntered КАК DateEntered,
		|	InvoiceCommentsСрезПоследних.Problem.DateIdentified КАК DateIdentified,
		|	InvoiceCommentsСрезПоследних.Problem.ConfirmedBy КАК ConfirmedBy,
		|	InvoiceCommentsСрезПоследних.Problem.ForecastDate КАК ForecastDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustInputDate КАК CustInputDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerRepresentative КАК CustomerRepresentative,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerInputDetails КАК CustomerInputDetails,
		|	InvoiceCommentsСрезПоследних.Problem.RemedialWorkPlan КАК RemedialWorkPlan,
		|	InvoiceCommentsСрезПоследних.Problem.RWDTargetDate КАК RWDTargetDate,
		|	InvoiceCommentsСрезПоследних.Problem.Comment КАК Comment
		|ИЗ
		|	РегистрСведений.InvoiceComments.СрезПоследних(, Invoice В (&МассивИнвойсов)) КАК InvoiceCommentsСрезПоследних";
	
	Запрос.УстановитьПараметр("МассивИнвойсов", МассивИнвойсов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса;
	
КонецФункции

#КонецЕсли
