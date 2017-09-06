﻿
&НаКлиенте
Процедура InvoiceПриИзменении(Элемент)
	
	InvoiceПриИзмененииНаСервере();
	
	Если ЕстьAllocationПоДокументу(Объект.Invoice) Тогда
		Сообщить(" " + Объект.Invoice + ") was previously credited.");
	КонецЕсли;
	
	RemainingInvoiceAmount = РассчитатьRemainingInvoiceAmount();
	
КонецПроцедуры

&НаСервере
Процедура InvoiceПриИзмененииНаСервере()
	
	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Invoice, "Company, Location, SubSubSegment, Account, Currency, AU, Client, Amount");
	
	ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитов);
	
	InvoiceClient = ЗначенияРеквизитов.Client;
	InvoiceAmount = ЗначенияРеквизитов.Amount;
	
КонецПроцедуры

&НаКлиенте
Процедура CreditNotesCreditNoteПриИзменении(Элемент)
	
	ПустаяДата = Дата(1,1,1);
	ТекущиеДанные = Элементы.CreditNotes.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЕстьAllocationПоДокументу(ТекущиеДанные.CreditNote) Тогда
		Сообщить(" " + ТекущиеДанные.CreditNote + " was previously allocated.");
	КонецЕсли;
	
	ЗначенияРеквизитов = CreditNotesCreditNoteПриИзмененииНаСервере(ТекущиеДанные.CreditNote);
	
	ЗначенияРеквизитов.Amount = -ЗначенияРеквизитов.Amount;
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ЗначенияРеквизитов);
	
	RemainingInvoiceAmount = РассчитатьRemainingInvoiceAmount();
	
КонецПроцедуры

&НаСервере
Функция CreditNotesCreditNoteПриИзмененииНаСервере(CreditNote)
	
	Объект.Дата = CreditNote.Дата;
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(CreditNote, "Company, Location, SubSubSegment, Account, Currency, AU, Amount, Дата");
	
КонецФункции

&НаСервере
Функция РассчитатьRemainingInvoiceAmount()
	Сумма = Объект.Invoice.Amount;
	Для каждого СтрокаCreditNote Из Объект.CreditNotes Цикл
		Сумма = Сумма - СтрокаCreditNote.Amount;
	КонецЦикла;
	Возврат Сумма;
КонецФункции

&НаСервере
Функция ЕстьAllocationПоДокументу(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	BilledARОбороты.Регистратор
		|ИЗ
		|	РегистрНакопления.BilledAR.Обороты(, , Регистратор, Invoice = &Документ) КАК BilledARОбороты
		|ГДЕ
		|	BilledARОбороты.Регистратор ССЫЛКА Документ.NoteAllocation
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	UnallocatedMemoОбороты.Регистратор
		|ИЗ
		|	РегистрНакопления.UnallocatedMemo.Обороты(, , Регистратор, Memo = &Документ) КАК UnallocatedMemoОбороты
		|ГДЕ
		|	UnallocatedMemoОбороты.Регистратор ССЫЛКА Документ.NoteAllocation";
	
	Запрос.УстановитьПараметр("Документ", Документ);
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ВыборкаBilledAR = РезультатЗапроса[0].Выбрать();
	ВыборкаUnallocatedMemo = РезультатЗапроса[1].Выбрать();
	
	Если ВыборкаBilledAR.Количество() <> 0 ИЛИ ВыборкаUnallocatedMemo.Количество() <> 0 Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(Объект.Invoice) Тогда
		RemainingInvoiceAmount = РассчитатьRemainingInvoiceAmount();
		InvoiceAmount = ПолучитьСуммуИнвойса();
	КонецЕсли;
	//ОпределитьВидимостьПолей();
КонецПроцедуры

&НаСервере
Функция ПолучитьСуммуИнвойса()
	
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Invoice, "Amount");

КонецФункции
//&НаКлиенте
//Процедура ОпределитьВидимостьПолей()
//	
//	Если Объект.ВидОперацииNoteAllocation = ПредопределенноеЗначение("Перечисление.ВидыОперацийNoteAllocation.ПустаяСсылка") Тогда
//		Объект.ВидОперацииNoteAllocation = ПредопределенноеЗначение("Перечисление.ВидыОперацийNoteAllocation.CreditNote");
//	КонецЕсли;
//	
//	Если Объект.ВидОперацииNoteAllocation = ПредопределенноеЗначение("Перечисление.ВидыОперацийNoteAllocation.CreditNote") Тогда
//		Элементы.ГруппаInvoice.Видимость = Истина;
//		Элементы.ГруппаMemo.Видимость = Ложь;
//	Иначе
//		Элементы.ГруппаInvoice.Видимость = Ложь;
//		Элементы.ГруппаMemo.Видимость = Истина;
//	КонецЕсли;
//	
//КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Invoice, "Company, Location, SubSubSegment, Account, Currency, AU, Client");
	//
	//InvoiceClient = ЗначенияРеквизитов.Client;
	
КонецПроцедуры

//&НаКлиенте
//Процедура ВидОперацииNoteAllocationПриИзменении(Элемент)
//	
//	ОпределитьВидимостьПолей();
//		
//КонецПроцедуры

//&НаСервере
//Процедура MemoПриИзмененииНаСервере()
//	ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.Memo, "Company, Location, SubSubSegment, Account, Currency, AU, Client");
//	
//	ЗаполнитьЗначенияСвойств(Объект, ЗначенияРеквизитов);
//	
//	InvoiceClient = ЗначенияРеквизитов.Client;
//КонецПроцедуры

//&НаКлиенте
//Процедура MemoПриИзменении(Элемент)
//	MemoПриИзмененииНаСервере();
//	
//	Если ЕстьAllocationПоДокументу(Объект.Memo) Тогда
//		Сообщить(" " + Объект.Memo + ") was previously credited.");
//	КонецЕсли;
//	
//	RemainingInvoiceAmount = РассчитатьRemainingInvoiceAmount();
//	
//КонецПроцедуры
