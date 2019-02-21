
Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Список = Новый СписокЗначений;
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeNoSignedContract);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeNoServiceSigned);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputePendingClientApprovalToInvoice);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeExceedContractValue);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeLostInHole);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputePricing);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeTechnicalSQ);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeCustomerIsInsolventOrBankrupt);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeSLBInternalDelaysSOIsMissing);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeSLBInternalDelaysERPTimeCosureIsDifferent);
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeSLBInternalDelaysARDelay);
	Список.Добавить(Перечисления.SalesOrderStatus.StatusUnknown);
	Список.Добавить(Перечисления.SalesOrderStatus.InvoiceNotYetDueForBilling);
	Список.Добавить(Перечисления.SalesOrderStatus.OngoingJob);
	
	ДанныеВыбора = Список;

КонецПроцедуры
