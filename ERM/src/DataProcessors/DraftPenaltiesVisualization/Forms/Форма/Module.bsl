
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
		|	Penalties.BaseAmount КАК BaseAmount,
		|	Penalties.BaseAmountUSD КАК BaseAmountUSD,
		|	Penalties.OverdueDays КАК OverdueDays,
		|	Penalties.Percent КАК Percent,
		|	ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент КАК ParentClient,
		|	Penalties.PaymentDate КАК PaymentDate
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
		|	РегистрНакопления.BilledAR.Остатки(&ПериодКонец, ) КАК BilledARОстатки
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(&ПериодКонец, ) КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО BilledARОстатки.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|ГДЕ
		|	BilledARОстатки.Invoice.DueDateTo > &ПериодКонец
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_ИсходныеДанные.Invoice) КАК КоличествоInvoice,
		|	СУММА(ВТ_ИсходныеДанные.BaseAmountUSD) КАК BaseAmountUSD
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
		|	МАКСИМУМ(ВТ_ИсходныеДанные.BaseAmountUSD) КАК BaseAmountUSD
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
		|	СУММА(ВТ_BenefitГруппировка.BaseAmountUSD) КАК BaseAmountUSD
		|ИЗ
		|	ВТ_BenefitГруппировка КАК ВТ_BenefitГруппировка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ИсходныеДанные.Invoice КАК Invoice,
		|	СУММА(ВТ_ИсходныеДанные.USDAmount) КАК USDAmount,
		|	МАКСИМУМ(ВТ_ИсходныеДанные.BaseAmountUSD) КАК BaseAmountUSD,
		|	МАКСИМУМ(ВТ_ИсходныеДанные.PaymentDate) КАК PaymentDate
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
		|	СУММА(ВТ_PenaltyГруппировка.BaseAmountUSD) КАК BaseAmountUSD
		|ИЗ
		|	ВТ_PenaltyГруппировка КАК ВТ_PenaltyГруппировка
		|ГДЕ
		|	ВТ_PenaltyГруппировка.PaymentDate = ДАТАВРЕМЯ(1, 1, 1)
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_PenaltyГруппировка.Invoice) > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_PenaltyГруппировка.Invoice) КАК КоличествоInvoice,
		|	СУММА(ВТ_PenaltyГруппировка.USDAmount) КАК USDAmount,
		|	СУММА(ВТ_PenaltyГруппировка.BaseAmountUSD) КАК BaseAmountUSD
		|ИЗ
		|	ВТ_PenaltyГруппировка КАК ВТ_PenaltyГруппировка
		|ГДЕ
		|	ВТ_PenaltyГруппировка.PaymentDate <> ДАТАВРЕМЯ(1, 1, 1)
		|ИМЕЮЩИЕ
		|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_PenaltyГруппировка.Invoice) > 0";
	
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
		InvoicePaidOnTimeValue = Выборка_PaidOnTime.BaseAmountUSD;
	КонецЦикла;
	
	Выборка_Benefit = РезультатЗапроса[4].Выбрать();
	
	Пока Выборка_Benefit.Следующий() Цикл
		InvoicePaidEarly = Выборка_Benefit.КоличествоInvoice;
		InvoicePaidEarlyValue = Выборка_Benefit.BaseAmountUSD;
		ValueOfEarlyPayments = Выборка_Benefit.USDAmount;
	КонецЦикла;
	
	Выборка_Penalty_Overdue = РезультатЗапроса[6].Выбрать();
	Penatlies_Overdue = 0;
	
	Пока Выборка_Penalty_Overdue.Следующий() Цикл
		OverdueInvoice = Выборка_Penalty_Overdue.КоличествоInvoice;
		OverdueInvoiceValue = Выборка_Penalty_Overdue.BaseAmountUSD;
		Penatlies_Overdue = Выборка_Penalty_Overdue.USDAmount;
	КонецЦикла;
	
	Выборка_Penalty_PaidLate = РезультатЗапроса[7].Выбрать();
	Penatlies_PaidLate = 0;
	
	Пока Выборка_Penalty_PaidLate.Следующий() Цикл
		InvoicesPaidLate = Выборка_Penalty_PaidLate.КоличествоInvoice;
		InvoicesPaidLateValue = Выборка_Penalty_PaidLate.BaseAmountUSD;
		Penatlies_PaidLate = Выборка_Penalty_PaidLate.USDAmount;
	КонецЦикла;
	
	Penatlies = Penatlies_Overdue + Penatlies_PaidLate;
	
	NetLossGain = ValueOfEarlyPayments - Penatlies;
	
	InvoiceBilled = InvoicePaidEarly + InvoicesPaidLate + InvoicePaidOnTime + OverdueInvoice;
	AmountBilled = InvoicePaidEarlyValue + InvoicesPaidLateValue + InvoicePaidOnTimeValue + OverdueInvoiceValue;
	
КонецПроцедуры

&НаКлиенте
Процедура Расчитать(Команда)
	РасчитатьНаСервере();
КонецПроцедуры
