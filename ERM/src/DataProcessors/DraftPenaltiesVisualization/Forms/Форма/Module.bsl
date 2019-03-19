
&НаСервере
Процедура РасчитатьНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Penalties.Client КАК Client,
		|	Penalties.Contract КАК Contract,
		|	Penalties.Invoice КАК Invoice,
		|	Penalties.PenaltyType КАК PenaltyType,
		|	Penalties.Amount КАК Amount,
		|	Penalties.USDAmount КАК USDAmount,
		|	Penalties.DueDate КАК DueDate,
		|	Penalties.RemainingAmount КАК RemainingAmount,
		|	Penalties.RemainingAmountUSD КАК RemainingAmountUSD,
		|	Penalties.OverdueDays КАК OverdueDays,
		|	Penalties.Percent КАК Percent,
		|	ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент КАК ParentClient
		|ПОМЕСТИТЬ ВТ_ИсходныеДанные
		|ИЗ
		|	РегистрСведений.Penalties КАК Penalties
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияКонтрагентов.СрезПоследних КАК ИерархияКонтрагентовСрезПоследних
		|		ПО Penalties.Client = ИерархияКонтрагентовСрезПоследних.Контрагент
		|ГДЕ
		|	Penalties.Период >= &ПериодНачало
		|	И Penalties.Период <= &ПериодКонец
		|	&УсловиеParentКлиент
		|	&УсловиеКлиент
		|	&УсловиеКонтракт
		|	И Penalties.Активность
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ BilledARОстатки.Invoice) КАК КоличествоInvoice,
		|	СУММА(BilledARОстатки.AmountОстаток) КАК AmountОстаток,
		|	СУММА(ВЫБОР
		|			КОГДА ВнутренниеКурсыВалютСрезПоследних.Курс ЕСТЬ NULL
		|					ИЛИ ВнутренниеКурсыВалютСрезПоследних.Курс = 0
		|				ТОГДА 0
		|			ИНАЧЕ BilledARОстатки.AmountОстаток / ВнутренниеКурсыВалютСрезПоследних.Курс
		|		КОНЕЦ) КАК BaseAmountОстаток
		|ИЗ
		|	РегистрНакопления.BilledAR.Остатки(
		|			&ПериодКонец,
		|			) КАК BilledARОстатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(&ПериодКонец, ) КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО BilledARОстатки.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|ГДЕ
		|	BilledARОстатки.Invoice.DueDateTo > &ПериодКонец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_ИсходныеДанные.Invoice) КАК КоличествоInvoice,
		|	СУММА(ВТ_ИсходныеДанные.RemainingAmountUSD) КАК RemainingAmountUSD
		|ИЗ
		|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
		|ГДЕ
		|	ВТ_ИсходныеДанные.PenaltyType = ЗНАЧЕНИЕ(Перечисление.PenaltyTypes.OnTime)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ИсходныеДанные.Invoice КАК Invoice,
		|	СУММА(ВТ_ИсходныеДанные.USDAmount) КАК USDAmount,
		|	МАКСИМУМ(ВТ_ИсходныеДанные.RemainingAmountUSD) КАК RemainingAmountUSD
		|ПОМЕСТИТЬ ВТ_BenefitГруппировка
		|ИЗ
		|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
		|ГДЕ
		|	ВТ_ИсходныеДанные.PenaltyType = ЗНАЧЕНИЕ(Перечисление.PenaltyTypes.Benefit)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ИсходныеДанные.Invoice
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_BenefitГруппировка.Invoice) КАК КоличествоInvoice,
		|	СУММА(ВТ_BenefitГруппировка.USDAmount) КАК USDAmount,
		|	СУММА(ВТ_BenefitГруппировка.RemainingAmountUSD) КАК RemainingAmountUSD
		|ИЗ
		|	ВТ_BenefitГруппировка КАК ВТ_BenefitГруппировка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ИсходныеДанные.Invoice КАК Invoice,
		|	СУММА(ВТ_ИсходныеДанные.USDAmount) КАК USDAmount,
		|	МАКСИМУМ(ВТ_ИсходныеДанные.RemainingAmountUSD) КАК RemainingAmountUSD
		|ПОМЕСТИТЬ ВТ_PenaltyГруппировка
		|ИЗ
		|	ВТ_ИсходныеДанные КАК ВТ_ИсходныеДанные
		|ГДЕ
		|	ВТ_ИсходныеДанные.PenaltyType = ЗНАЧЕНИЕ(Перечисление.PenaltyTypes.Penalty)
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ИсходныеДанные.Invoice
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_PenaltyГруппировка.Invoice) КАК КоличествоInvoice,
		|	СУММА(ВТ_PenaltyГруппировка.USDAmount) КАК USDAmount,
		|	СУММА(ВТ_PenaltyГруппировка.RemainingAmountUSD) КАК RemainingAmountUSD
		|ИЗ
		|	ВТ_PenaltyГруппировка КАК ВТ_PenaltyГруппировка";
	
	Запрос.УстановитьПараметр("ПериодКонец", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("ПериодНачало", Период.ДатаНачала);
	
	Если ParentClient.Количество() > 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеParentКлиент", "И ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент В (&ParentClient)");
		Запрос.УстановитьПараметр("ParentClient",ParentClient);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеParentКлиент", "");
	КонецЕсли;
	Если Client.Количество() > 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеКлиент", "И Penalties.Client В (&Client)");
		Запрос.УстановитьПараметр("Client",Client);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеКлиент", "");
	КонецЕсли;
	Если Contract.Количество() > 0 Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеКонтракт", "И Penalties.Contract В (&Contract)");
		Запрос.УстановитьПараметр("Contract",Contract);
	Иначе
		Запрос.Текст = СтрЗаменить(Запрос.Текст,"&УсловиеКонтракт", "");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	Выборка_Outstanding = РезультатЗапроса[1].Выбрать();
	
	Пока Выборка_Outstanding.Следующий() Цикл
		OutstandingInvoice = Выборка_Outstanding.КоличествоInvoice;
		OutstandingBilledAR = Выборка_Outstanding.BaseAmountОстаток;
	КонецЦикла;
	
	Выборка_PaidOnTime = РезультатЗапроса[2].Выбрать();
	
	Пока Выборка_PaidOnTime.Следующий() Цикл
		InvoicePaidOnTime = Выборка_PaidOnTime.КоличествоInvoice;
		InvoicePaidOnTimeValue = Выборка_PaidOnTime.RemainingAmountUSD;
	КонецЦикла;
	
	Выборка_Benefit = РезультатЗапроса[4].Выбрать();
	
	Пока Выборка_Benefit.Следующий() Цикл
		InvoicePaidEarly = Выборка_Benefit.КоличествоInvoice;
		InvoicePaidEarlyValue = Выборка_Benefit.RemainingAmountUSD;
		ValueOfEarlyPayments = Выборка_Benefit.USDAmount;
	КонецЦикла;
	
	Выборка_Penalty = РезультатЗапроса[6].Выбрать();
	
	Пока Выборка_Penalty.Следующий() Цикл
		InvoicesPaidLate = Выборка_Penalty.КоличествоInvoice;
		InvoicesPaidLateValue = Выборка_Penalty.RemainingAmountUSD;
		Penatlies = Выборка_Penalty.USDAmount;
	КонецЦикла;
	
	NetLossGain = ValueOfEarlyPayments - Penatlies;
	
	InvoiceBilled = InvoicePaidEarly + InvoicesPaidLate + InvoicePaidOnTime + OverdueInvoice;
	AmountBilled = InvoicePaidEarlyValue + InvoicesPaidLateValue + InvoicePaidOnTimeValue + OverdueInvoiceValue;
	
	
КонецПроцедуры

&НаКлиенте
Процедура Расчитать(Команда)
	РасчитатьНаСервере();
КонецПроцедуры
