

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	СформироватьОтчетНаСервере();
КонецПроцедуры

&НаСервере
Процедура СформироватьОтчетНаСервере()
	
	Результат.Очистить();
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	НастройкиДляКомпоновкиМакета = ОтчетОбъект.КомпоновщикНастроек.ПолучитьНастройки();
	МакетКомпоновки = КомпоновщикМакета.Выполнить(ОтчетОбъект.СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета, ,
		, Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, , Неопределено, Истина);
	
	ПредставлениеПериода = "Period: " + НастройкиДляКомпоновкиМакета.ПараметрыДанных.Элементы.Найти("ПериодОтчета").Значение;
	ПредставлениеОтборы = "";
	Для каждого ЭлементОтбора Из НастройкиДляКомпоновкиМакета.Отбор.Элементы Цикл
		Если ЭлементОтбора.Использование Тогда
			 ПредставлениеОтборы = ПредставлениеОтборы + ЭлементОтбора.ЛевоеЗначение + ": " + ЭлементОтбора.ПравоеЗначение + ",";
		КонецЕсли;
	КонецЦикла;
	
	ТЗ = Новый ТаблицаЗначений;
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);
	
	СписокКолонок = "КоличествоInvoiceBenefit, USDAmountBenefit, BaseAmountUSDBenefit, КоличествоInvoiceOutstanding, AmountОстатокOutstanding,
		|BaseAmountОстатокOutstanding, КоличествоInvoicePenaltyPaidLate, USDAmountPenaltyPaidLate, BaseAmountUSDPenaltyPaidLate, КоличествоInvoicePaidOnTime,
		|BaseAmountUSDPaidOnTime, КоличествоInvoicePenaltyOverdue, USDAmountPenaltyOverdue, BaseAmountUSDPenaltyOverdue, OverdueDays, OverdueDaysBenefit, 
		|OverdueDaysPaidLate, OverdueDaysКоличествоСтрок, OverdueDaysКоличествоСтрокBenefit, OverdueDaysКоличествоСтрокPaidLate";
	ТаблицаПоказателей = ТЗ.Скопировать(, СписокКолонок);
	ТаблицаПоказателей.Свернуть(, СписокКолонок);
	
	Если ТЗ.Количество() > 0 Тогда
	
		Макет = ОтчетОбъект.ПолучитьМакет("Template");
		
		ОбластьПоказатели = Макет.ПолучитьОбласть("Показатели");
		
		ОбластьПоказатели.Параметры.ПредставлениеПериода = ПредставлениеПериода;
		ОбластьПоказатели.Параметры.ПредставлениеОтборы = ПредставлениеОтборы;
		
		СтрокаТЗ = ТаблицаПоказателей[0];
		
		ОбластьПоказатели.Параметры.InvoicePaidOnTime = СтрокаТЗ.КоличествоInvoicePaidOnTime;
		ОбластьПоказатели.Параметры.InvoicePaidOnTimeValue = СтрокаТЗ.BaseAmountUSDPaidOnTime;
		ОбластьПоказатели.Параметры.InvoicePaidEarly = СтрокаТЗ.КоличествоInvoiceBenefit;
		ОбластьПоказатели.Параметры.InvoicePaidEarlyValue = СтрокаТЗ.BaseAmountUSDBenefit;
		ОбластьПоказатели.Параметры.ValueOfEarlyPayments = СтрокаТЗ.USDAmountBenefit;
		ОбластьПоказатели.Параметры.InvoicesPaidLate = СтрокаТЗ.КоличествоInvoicePenaltyPaidLate;
		ОбластьПоказатели.Параметры.InvoicesPaidLateValue = СтрокаТЗ.BaseAmountUSDPenaltyPaidLate;
		ОбластьПоказатели.Параметры.OverdueInvoice = СтрокаТЗ.КоличествоInvoicePenaltyOverdue;
		ОбластьПоказатели.Параметры.OverdueInvoiceValue = СтрокаТЗ.BaseAmountUSDPenaltyOverdue;
		ОбластьПоказатели.Параметры.Penatlies =  СтрокаТЗ.USDAmountPenaltyOverdue + СтрокаТЗ.USDAmountPenaltyPaidLate;
		ОбластьПоказатели.Параметры.NetLossGain = СтрокаТЗ.USDAmountBenefit - ОбластьПоказатели.Параметры.Penatlies;
		
		ОбластьПоказатели.Параметры.OutstandingBilledAR = СтрокаТЗ.BaseAmountОстатокOutstanding;
		ОбластьПоказатели.Параметры.OutstandingInvoice = СтрокаТЗ.КоличествоInvoiceOutstanding;
		
		ОбластьПоказатели.Параметры.InvoicesBilled = ОбластьПоказатели.Параметры.InvoicePaidEarly 
			+ ОбластьПоказатели.Параметры.InvoicesPaidLate
			+ ОбластьПоказатели.Параметры.InvoicePaidOnTime
			+ ОбластьПоказатели.Параметры.OverdueInvoice
			+ ОбластьПоказатели.Параметры.OutstandingInvoice;
		ОбластьПоказатели.Параметры.AmountBilled = ОбластьПоказатели.Параметры.InvoicePaidEarlyValue 
			+ ОбластьПоказатели.Параметры.InvoicesPaidLateValue
			+ ОбластьПоказатели.Параметры.InvoicePaidOnTimeValue
			+ ОбластьПоказатели.Параметры.OverdueInvoiceValue
			+ ОбластьПоказатели.Параметры.OutstandingBilledAR;
			
		ОбластьПоказатели.Параметры.EffectivePenalty = ОбластьПоказатели.Параметры.Penatlies/ОбластьПоказатели.Параметры.AmountBilled;
		ОбластьПоказатели.Параметры.OverdueDaysBenefit = СтрокаТЗ.OverdueDaysBenefit/?(СтрокаТЗ.OverdueDaysКоличествоСтрокBenefit = 0,1,СтрокаТЗ.OverdueDaysКоличествоСтрокBenefit);
		Если СтрокаТЗ.OverdueDays = 0 ИЛИ СтрокаТЗ.OverdueDaysPaidLate = 0 Тогда
			ОбластьПоказатели.Параметры.OverdueDaysPaidLateAndOverdue = 
				СтрокаТЗ.OverdueDays/?(СтрокаТЗ.OverdueDaysКоличествоСтрок = 0,1,СтрокаТЗ.OverdueDaysКоличествоСтрок) + 
				СтрокаТЗ.OverdueDaysPaidLate/?(СтрокаТЗ.OverdueDaysКоличествоСтрокPaidLate = 0,1,СтрокаТЗ.OverdueDaysКоличествоСтрокPaidLate);
		Иначе
			ОбластьПоказатели.Параметры.OverdueDaysPaidLateAndOverdue = (СтрокаТЗ.OverdueDays/?(СтрокаТЗ.OverdueDaysКоличествоСтрок = 0,1,СтрокаТЗ.OverdueDaysКоличествоСтрок) + 
				СтрокаТЗ.OverdueDaysPaidLate/?(СтрокаТЗ.OverdueDaysКоличествоСтрокPaidLate = 0,1,СтрокаТЗ.OverdueDaysКоличествоСтрокPaidLate))/2;
		КонецЕсли;
		
		Результат.Вывести(ОбластьПоказатели);
	
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры
