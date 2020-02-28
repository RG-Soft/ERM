Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Список = Новый СписокЗначений;
	Список.Добавить(Перечисления.InvoiceStatus.CustomerIsInsolventOrBankrupt);
	Список.Добавить(Перечисления.InvoiceStatus.BankIssue);
	Список.Добавить(Перечисления.InvoiceStatus.Pricing);
	Список.Добавить(Перечисления.InvoiceStatus.TaxRetention);
	Список.Добавить(Перечисления.InvoiceStatus.ContractIssue);
	Список.Добавить(Перечисления.InvoiceStatus.InvalidPO);
	Список.Добавить(Перечисления.InvoiceStatus.MissingInvoice);
	Список.Добавить(Перечисления.InvoiceStatus.MissingPO);
	Список.Добавить(Перечисления.InvoiceStatus.MissingSupportingDocuments);
	Список.Добавить(Перечисления.InvoiceStatus.OverBudget);
	Список.Добавить(Перечисления.InvoiceStatus.PendingApprovalToPay);
	Список.Добавить(Перечисления.InvoiceStatus.WriteOff);
	Список.Добавить(Перечисления.InvoiceStatus.TechnicalSQ);
	Список.Добавить(Перечисления.InvoiceStatus.LostInHole);
	Список.Добавить(Перечисления.InvoiceStatus.BudgetIssue);
	Список.Добавить(Перечисления.InvoiceStatus.BillingError);
	Список.Добавить(Перечисления.InvoiceStatus.ClientConfirmedPayment);
	//Список.Добавить(Перечисления.InvoiceStatus.InvoicePaid);
	//Список.Добавить(Перечисления.InvoiceStatus.PartiallyPaid);
	Список.Добавить(Перечисления.InvoiceStatus.PendingPaymentAllocation);
	Список.Добавить(Перечисления.InvoiceStatus.InvoiceOnApproval);
	
	ДанныеВыбора = Список;

КонецПроцедуры

Функция ПолучитьDisputeStatuses() Экспорт
	
	Список = Новый СписокЗначений;
	Список.Добавить(Перечисления.InvoiceStatus.Pricing);
	Список.Добавить(Перечисления.InvoiceStatus.BankIssue);
	Список.Добавить(Перечисления.InvoiceStatus.TaxRetention);
	Список.Добавить(Перечисления.InvoiceStatus.ContractIssue);
	Список.Добавить(Перечисления.InvoiceStatus.InvalidPO);
	Список.Добавить(Перечисления.InvoiceStatus.MissingInvoice);
	Список.Добавить(Перечисления.InvoiceStatus.MissingPO);
	Список.Добавить(Перечисления.InvoiceStatus.MissingSupportingDocuments);
	Список.Добавить(Перечисления.InvoiceStatus.OverBudget);
	Список.Добавить(Перечисления.InvoiceStatus.PendingApprovalToPay);
	Список.Добавить(Перечисления.InvoiceStatus.WriteOff);
	Список.Добавить(Перечисления.InvoiceStatus.TechnicalSQ);
	Список.Добавить(Перечисления.InvoiceStatus.LostInHole);
	Список.Добавить(Перечисления.InvoiceStatus.BudgetIssue);
	//Список.Добавить(Перечисления.InvoiceStatus.BillingError);
	Список.Добавить(Перечисления.InvoiceStatus.InvoiceOnApproval);
	
	Возврат Список;
	
КонецФункции