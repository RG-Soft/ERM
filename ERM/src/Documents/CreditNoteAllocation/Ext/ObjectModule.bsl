Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Клиент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Invoice, "Client");
	СтруктураКурсаInvoice = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(Currency, Дата);
	
	ДвиженияBilledAR = Движения.BilledAR;
	
	Для каждого СтрокаТЧ Из CreditNotes Цикл
		
		ДвижениеCreditNote = ДвиженияBilledAR.Добавить();
		ДвижениеInvoice = ДвиженияBilledAR.Добавить();
		
		СтруктураКурсаCreditNote = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(СтрокаТЧ.Currency, Дата);
		
		ДвижениеCreditNote.Период = Дата;
		ДвижениеCreditNote.ВидДвижения = ВидДвиженияНакопления.Расход;
		ДвижениеCreditNote.Client = Клиент;
		ДвижениеCreditNote.Company = СтрокаТЧ.Company;
		ДвижениеCreditNote.Source = Source;
		ДвижениеCreditNote.Location = СтрокаТЧ.Location;
		ДвижениеCreditNote.SubSubSegment = СтрокаТЧ.SubSubSegment;
		ДвижениеCreditNote.Invoice = СтрокаТЧ.CreditNote;
		ДвижениеCreditNote.Account = СтрокаТЧ.Account;
		ДвижениеCreditNote.Currency = СтрокаТЧ.Currency;
		ДвижениеCreditNote.AU = СтрокаТЧ.AU;
		ДвижениеCreditNote.Amount = -СтрокаТЧ.Amount;
		ДвижениеCreditNote.BaseAmount = -СтрокаТЧ.Amount / ?(ЗначениеЗаполнено(СтруктураКурсаCreditNote.Курс), СтруктураКурсаCreditNote.Курс, 1);
		
		ДвижениеInvoice.Период = Дата;
		ДвижениеInvoice.ВидДвижения = ВидДвиженияНакопления.Расход;
		ДвижениеInvoice.Client = Клиент;
		ДвижениеInvoice.Company = Company;
		ДвижениеInvoice.Source = Source;
		ДвижениеInvoice.Location = Location;
		ДвижениеInvoice.SubSubSegment = SubSubSegment;
		ДвижениеInvoice.Invoice = Invoice;
		ДвижениеInvoice.Account = Account;
		ДвижениеInvoice.Currency = Currency;
		ДвижениеInvoice.AU = AU;
		ДвижениеInvoice.Amount = ДвижениеCreditNote.Amount;
		ДвижениеInvoice.BaseAmount = ДвижениеCreditNote.BaseAmount;
		
	КонецЦикла;
	
КонецПроцедуры


