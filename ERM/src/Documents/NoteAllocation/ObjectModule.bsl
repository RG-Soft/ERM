#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)

	Если ВидОперацииNoteAllocation = Перечисления.ВидыОперацийNoteAllocation.ПустаяСсылка() Тогда
		
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Select the operation type before recording.");
		
	КонецЕсли;
	
	Если ЭтоНовый() Тогда
		
		Ответственный = Пользователи.ТекущийПользователь();
		CreatedDate = ТекущаяДата();
		
	Иначе
		
		ModifiedBy = Пользователи.ТекущийПользователь();
		ModificationDate = ТекущаяДата();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	СтруктураКурсаInvoice = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(Currency, Дата);
	
	Если ВидОперацииNoteAllocation = Перечисления.ВидыОперацийNoteAllocation.CreditNote Тогда
		
		Клиент = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Invoice, "Client");
		
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
			//ДвижениеCreditNote.SubSubSegment = СтрокаТЧ.SubSubSegment;
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
			//ДвижениеInvoice.SubSubSegment = SubSubSegment;
			ДвижениеInvoice.Invoice = Invoice;
			ДвижениеInvoice.Account = Account;
			ДвижениеInvoice.Currency = Currency;
			ДвижениеInvoice.AU = AU;
			ДвижениеInvoice.Amount = -ДвижениеCreditNote.Amount;
			ДвижениеInvoice.BaseAmount = -ДвижениеCreditNote.BaseAmount;
			
		КонецЦикла;
		
		ДвиженияBilledAR.Записывать = Истина;
		
	ИначеЕсли ВидОперацииNoteAllocation = Перечисления.ВидыОперацийNoteAllocation.CreditMemo Тогда
	
		ДвиженияUnallocatedMemo = Движения.UnallocatedMemo;
		ДвиженияBilledAR = Движения.BilledAR;
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	UnallocatedMemoОстатки.AmountОстаток,
			|	UnallocatedMemoОстатки.BaseAmountОстаток
			|ИЗ
			|	РегистрНакопления.UnallocatedMemo.Остатки(&ПериодОстатки, Memo = &Memo) КАК UnallocatedMemoОстатки";
		
		Запрос.УстановитьПараметр("Memo", Invoice);
		Запрос.УстановитьПараметр("ПериодОстатки", Новый Граница(Дата, ВидГраницы.Включая));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Количество() = 1 Тогда
			
			ВыборкаДетальныеЗаписи.Следующий();
			
			ДвижениеUnallocated = ДвиженияUnallocatedMemo.Добавить();
			ЗаполнитьЗначенияСвойств(ДвижениеUnallocated, Invoice);
			ДвижениеUnallocated.Период = Дата;
			ДвижениеUnallocated.ВидДвижения = ВидДвиженияНакопления.Расход;
			ДвижениеUnallocated.Memo = Invoice;
			ДвижениеUnallocated.Amount = ВыборкаДетальныеЗаписи.AmountОстаток;
			ДвижениеUnallocated.BaseAmount = ВыборкаДетальныеЗаписи.BaseAmountОстаток;
			
			ДвижениеBilledAR = ДвиженияBilledAR.Добавить();
			ЗаполнитьЗначенияСвойств(ДвижениеBilledAR, Invoice);
			ДвижениеBilledAR.Период = Дата;
			ДвижениеBilledAR.ВидДвижения = ВидДвиженияНакопления.Приход;
			ДвижениеBilledAR.Invoice = Invoice;
			ДвижениеBilledAR.Amount = ВыборкаДетальныеЗаписи.AmountОстаток;
			ДвижениеBilledAR.BaseAmount = ВыборкаДетальныеЗаписи.BaseAmountОстаток;
			
		ИначеЕсли ВыборкаДетальныеЗаписи.Количество() > 1 Тогда
			
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Remains of this memo diverge in analytics."); //остатки в регистре по мемо на разной аналитике, такого быть не должно
			
		КонецЕсли;
		
		
		ДвижениеBilledAR = ДвиженияBilledAR.Добавить();
		ЗаполнитьЗначенияСвойств(ДвижениеBilledAR, Invoice);
		Amount = CreditNotes.Итог("Amount");
		ДвижениеBilledAR.Период = Дата;
		ДвижениеBilledAR.ВидДвижения = ВидДвиженияНакопления.Приход;
		ДвижениеBilledAR.Invoice = Invoice;
		ДвижениеBilledAR.Amount = -Amount;
		ДвижениеBilledAR.BaseAmount = -Amount / ?(ЗначениеЗаполнено(СтруктураКурсаInvoice.Курс), СтруктураКурсаInvoice.Курс, 1);
		
		Для каждого СтрокаТЧ Из CreditNotes Цикл
			
			СтруктураКурсаCreditNote = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(СтрокаТЧ.Currency, Дата);
			ДвижениеBilledAR = ДвиженияBilledAR.Добавить();
			ЗаполнитьЗначенияСвойств(ДвижениеBilledAR, СтрокаТЧ.CreditNote);
			ДвижениеBilledAR.Период = Дата;
			ДвижениеBilledAR.ВидДвижения = ВидДвиженияНакопления.Расход;
			ДвижениеBilledAR.Invoice = СтрокаТЧ.CreditNote;
			ДвижениеBilledAR.Amount = -СтрокаТЧ.Amount;
			ДвижениеBilledAR.BaseAmount = -СтрокаТЧ.Amount / ?(ЗначениеЗаполнено(СтруктураКурсаCreditNote.Курс), СтруктураКурсаCreditNote.Курс, 1);
			
		КонецЦикла;
		
		
		ДвиженияBilledAR.Записывать = Истина;
		ДвиженияUnallocatedMemo.Записывать = Истина;
		
	ИначеЕсли ВидОперацииNoteAllocation = Перечисления.ВидыОперацийNoteAllocation.DebitMemo Тогда
		
		ДвиженияUnallocatedMemo = Движения.UnallocatedMemo;
		
		Если CreditNotes.Количество() = 1 Тогда
			
			Мемо2 = CreditNotes[0].CreditNote;
			
			Если ЗначениеЗаполнено(Мемо2) Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = 
					"ВЫБРАТЬ
					|	UnallocatedMemoОстатки.AmountОстаток,
					|	UnallocatedMemoОстатки.BaseAmountОстаток
					|ИЗ
					|	РегистрНакопления.UnallocatedMemo.Остатки(&ПериодОстатков, Memo = &Memo1) КАК UnallocatedMemoОстатки
					|;
					|
					|////////////////////////////////////////////////////////////////////////////////
					|ВЫБРАТЬ
					|	UnallocatedMemoОстатки.AmountОстаток,
					|	UnallocatedMemoОстатки.BaseAmountОстаток
					|ИЗ
					|	РегистрНакопления.UnallocatedMemo.Остатки(&ПериодОстатков, Memo = &Memo2) КАК UnallocatedMemoОстатки";
				
				Запрос.УстановитьПараметр("Memo1", Invoice);
				Запрос.УстановитьПараметр("Memo2", Мемо2);
				Запрос.УстановитьПараметр("ПериодОстатков", Новый Граница(Дата, ВидГраницы.Включая));
				
				МассивРезультатов = Запрос.ВыполнитьПакет();
				
				ТаблицаМемо1 = МассивРезультатов[0].Выгрузить();
				ТаблицаМемо2 = МассивРезультатов[1].Выгрузить();
				
				СуммаДляКорректировки = Мин(Макс(ТаблицаМемо1[0].AmountОстаток, -ТаблицаМемо1[0].AmountОстаток), Макс(ТаблицаМемо2[0].AmountОстаток, -ТаблицаМемо2[0].AmountОстаток));
				СуммаДляКорректировкиUSD = Мин(Макс(ТаблицаМемо1[0].BaseAmountОстаток, -ТаблицаМемо1[0].BaseAmountОстаток), Макс(ТаблицаМемо2[0].BaseAmountОстаток, -ТаблицаМемо2[0].BaseAmountОстаток));
				
				ДвижениеUnallocated = ДвиженияUnallocatedMemo.Добавить();
				ЗаполнитьЗначенияСвойств(ДвижениеUnallocated, Invoice);
				ДвижениеUnallocated.Период = Дата;
				ДвижениеUnallocated.ВидДвижения = ВидДвиженияНакопления.Приход;
				ДвижениеUnallocated.Memo = Invoice;
				Если ТаблицаМемо1[0].AmountОстаток > 0 Тогда
					ДвижениеUnallocated.Amount = -СуммаДляКорректировки;
					ДвижениеUnallocated.BaseAmount = -СуммаДляКорректировкиUSD;
				Иначе
					ДвижениеUnallocated.Amount = СуммаДляКорректировки;
					ДвижениеUnallocated.BaseAmount = СуммаДляКорректировкиUSD;
				КонецЕсли;
					
				ДвижениеUnallocated = ДвиженияUnallocatedMemo.Добавить();
				ЗаполнитьЗначенияСвойств(ДвижениеUnallocated, Мемо2);
				ДвижениеUnallocated.Период = Дата;
				ДвижениеUnallocated.ВидДвижения = ВидДвиженияНакопления.Приход;
				ДвижениеUnallocated.Memo = Мемо2;
				Если ТаблицаМемо2[0].AmountОстаток > 0 Тогда
					ДвижениеUnallocated.Amount = -СуммаДляКорректировки;
					ДвижениеUnallocated.BaseAmount = -СуммаДляКорректировкиUSD;
				Иначе
					ДвижениеUnallocated.Amount = СуммаДляКорректировки;
					ДвижениеUnallocated.BaseAmount = СуммаДляКорректировкиUSD;
				КонецЕсли;
				
				ДвиженияUnallocatedMemo.Записывать = Истина;
				
			Иначе
				 //ругаться, что не заполнен инвойс
				Отказ = Истина;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Select the memo.");
			КонецЕсли;
		Иначе
			//ругаться, что не одна строка
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("For this type of operation can be only one credit note.");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли