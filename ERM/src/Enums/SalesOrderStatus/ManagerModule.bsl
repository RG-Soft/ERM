
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
	Список.Добавить(Перечисления.SalesOrderStatus.DisputeChemistryExtraConsumptionMI);
	Список.Добавить(Перечисления.SalesOrderStatus.OngoingJob);
	Список.Добавить(Перечисления.SalesOrderStatus.JECutOffDateDeferral);
	Список.Добавить(Перечисления.SalesOrderStatus.JETechnicalErrorsInERP);
	Список.Добавить(Перечисления.SalesOrderStatus.JEEliminationForNonLawsonSegments);
	
	ДанныеВыбора = Список;

КонецПроцедуры
