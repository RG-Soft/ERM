﻿// Конвертация ERM (documents) от 16.12.2016 13:33:38
#Область ПроцедурыКонвертации
Процедура ПередКонвертацией(КомпонентыОбмена) Экспорт
	
КонецПроцедуры

Процедура ПослеКонвертации(КомпонентыОбмена) Экспорт
	
КонецПроцедуры

Процедура ПередОтложеннымЗаполнением(КомпонентыОбмена) Экспорт
	
КонецПроцедуры

#КонецОбласти
#Область ПОД
// Заполняет таблицу правил обработки данных.
//
// Параметры:
//  НаправлениеОбмена - строка ("Отправка" либо "Получение").
//  ПравилаОбработкиДанных - таблица значений, в которую добавляются правила. 
Процедура ЗаполнитьПравилаОбработкиДанных(НаправлениеОбмена, ПравилаОбработкиДанных) Экспорт
	Если НаправлениеОбмена = "Получение" Тогда
		ДобавитьПОД_Документ_Invoice_Получение(ПравилаОбработкиДанных);
		ДобавитьПОД_Справочник_TriggerTypes_Получение(ПравилаОбработкиДанных);
		ДобавитьПОД_Справочник_Договоры_Получение(ПравилаОбработкиДанных);
	КонецЕсли;
КонецПроцедуры

#Область Получение
#Область Документ_Invoice_Получение
Процедура ДобавитьПОД_Документ_Invoice_Получение(ПравилаОбработкиДанных)
	ПравилоОбработки = ПравилаОбработкиДанных.Добавить();
	ПравилоОбработки.Имя = "Документ_Invoice_Получение";
	ПравилоОбработки.ОбъектВыборкиФормат = "Документ.Invoice";
	ПравилоОбработки.ИспользуемыеПКО.Добавить("Документ_Invoice_Получение");
КонецПроцедуры
#КонецОбласти
#Область Справочник_TriggerTypes_Получение
Процедура ДобавитьПОД_Справочник_TriggerTypes_Получение(ПравилаОбработкиДанных)
	ПравилоОбработки = ПравилаОбработкиДанных.Добавить();
	ПравилоОбработки.Имя = "Справочник_TriggerTypes_Получение";
	ПравилоОбработки.ОбъектВыборкиФормат = "Справочник.TriggerTypes";
	ПравилоОбработки.ИспользуемыеПКО.Добавить("Справочник_TriggerTypes_Получение");
КонецПроцедуры
#КонецОбласти
#Область Справочник_Договоры_Получение
Процедура ДобавитьПОД_Справочник_Договоры_Получение(ПравилаОбработкиДанных)
	ПравилоОбработки = ПравилаОбработкиДанных.Добавить();
	ПравилоОбработки.Имя = "Справочник_Договоры_Получение";
	ПравилоОбработки.ОбъектВыборкиФормат = "Справочник.Договоры";
	ПравилоОбработки.ИспользуемыеПКО.Добавить("Справочник_ДоговорыКонтрагентов_Получение");
КонецПроцедуры
#КонецОбласти
#КонецОбласти

#КонецОбласти
#Область ПКО
// Заполняет таблицу правил конвертации объектов.
//
// Параметры:
//  НаправлениеОбмена - строка ("Отправка" либо "Получение").
//  ПравилаКонвертации - таблица значений, в которую добавляются правила. 
Процедура ЗаполнитьПравилаКонвертацииОбъектов(НаправлениеОбмена, ПравилаКонвертации) Экспорт
	Если НаправлениеОбмена = "Получение" Тогда
		ДобавитьПКО_Документ_Invoice_Получение(ПравилаКонвертации);
		ДобавитьПКО_Справочник_TriggerTypes_Получение(ПравилаКонвертации);
		ДобавитьПКО_Справочник_Валюты_Получение(ПравилаКонвертации);
		ДобавитьПКО_Справочник_ДоговорыКонтрагентов_Получение(ПравилаКонвертации);
		ДобавитьПКО_Справочник_Контрагенты_Получение(ПравилаКонвертации);
		ДобавитьПКО_Справочник_Организации_Получение(ПравилаКонвертации);
		ДобавитьПКО_Справочник_Сегменты_Получение(ПравилаКонвертации);
	КонецЕсли;
КонецПроцедуры

#Область Получение
#Область Документ_Invoice_Получение
Процедура ДобавитьПКО_Документ_Invoice_Получение(ПравилаКонвертации)
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Документ_Invoice_Получение";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Документы.Invoice;
	ПравилоКонвертации.ОбъектФормата = "Документ.Invoice";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ПриКонвертацииДанныхXDTO = "ПКО_Документ_Invoice_Получение_ПриКонвертацииДанныхXDTO";
	ПравилоКонвертации.ПередЗаписьюПолученныхДанных = "ПКО_Документ_Invoice_Получение_ПередЗаписьюПолученныхДанных";
	ПравилоКонвертации.ВариантИдентификации = "ПоПолямПоиска";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Contract";
	НоваяСтрока.СвойствоФормата = "Contract";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_ДоговорыКонтрагентов_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "DocNumber";
	НоваяСтрока.СвойствоФормата = "DocNumber";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "DueDateFrom";
	НоваяСтрока.СвойствоФормата = "DueDateFrom";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "DueDateTo";
	НоваяСтрока.СвойствоФормата = "DueDateTo";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "FiscalAmount";
	НоваяСтрока.СвойствоФормата = "FiscalAmount";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "FiscalInvoiceDate";
	НоваяСтрока.СвойствоФормата = "FiscalInvoiceDate";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "FiscalInvoiceNo";
	НоваяСтрока.СвойствоФормата = "FiscalInvoiceNumber";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Source";
	НоваяСтрока.СвойствоФормата = "Source";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Перечисление_ТипыСоответствий_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "TriggerDate";
	НоваяСтрока.СвойствоФормата = "TriggerDate";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Дата";
	НоваяСтрока.СвойствоФормата = "Дата";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ДатаВозвратаКС";
	НоваяСтрока.СвойствоФормата = "ДатаВозвратаКС";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ДатаОтправкиКС";
	НоваяСтрока.СвойствоФормата = "ДатаОтправкиКС";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "КомментарийСтатусаВозвратаКС";
	НоваяСтрока.СвойствоФормата = "КомментарийСтатусаВозвратаКС";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Номер";
	НоваяСтрока.СвойствоФормата = "Номер";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "СтатусВозвратаКС";
	НоваяСтрока.СвойствоФормата = "СтатусВозвратаКС";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоФормата = "DocID";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоФормата = "DocIDString";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоФормата = "Оплачен";
	НоваяСтрока.ИспользуетсяАлгоритмКонвертации = Истина;
	
	ПравилоКонвертации.ПоляПоиска.Добавить("DocID,Source");
	ПравилоКонвертации.ПоляПоиска.Добавить("DocNumber,Source,Дата");
	ПравилоКонвертации.ПоляПоиска.Добавить("Номер,Source");
КонецПроцедуры

Процедура ПКО_Документ_Invoice_Получение_ПриКонвертацииДанныхXDTO(ДанныеXDTO, ПолученныеДанные, КомпонентыОбмена)
	Если ДанныеXDTO.КлючевыеСвойства.Свойство("DocIDString") И ЗначениеЗаполнено(ДанныеXDTO.КлючевыеСвойства.DocIDString) Тогда
		ПолученныеДанные.DocID = ДанныеXDTO.КлючевыеСвойства.DocIDString;
	Иначе
		ПолученныеДанные.DocID = ДанныеXDTO.КлючевыеСвойства.DocID;	
	КонецЕсли;
	
	Если ДанныеXDTO.Свойство("Оплачен") И ЗначениеЗаполнено(ДанныеXDTO.Оплачен) Тогда
		ПолученныеДанные.ДополнительныеСвойства.Вставить("Оплачен", ДанныеXDTO.Оплачен)
	КонецЕсли;
	
	Если ДанныеXDTO.Свойство("FiscalPayments") Тогда
		FiscalPayments = ДанныеXDTO.FiscalPayments;
		ПолученныеДанные.ДополнительныеСвойства.Вставить("FiscalPayments", FiscalPayments);
	КонецЕсли;
КонецПроцедуры

Процедура ПКО_Документ_Invoice_Получение_ПередЗаписьюПолученныхДанных(ПолученныеДанные, ДанныеИБ, КонвертацияСвойств, КомпонентыОбмена)
	Если ДанныеИБ <> Неопределено Тогда
		Если НЕ ПолученныеДанные.ДополнительныеСвойства.Свойство("FiscalPayments") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	FiscalPayments.PaymentDocument,
			|	FiscalPayments.SettlementAmount
			|ИЗ
			|	РегистрСведений.FiscalPayments КАК FiscalPayments
			|ГДЕ
			|	FiscalPayments.Invoice = &Invoice";
			Запрос.УстановитьПараметр("Invoice", ДанныеИБ.Ссылка);
			Результат = Запрос.Выполнить().Выгрузить();
			
			//ПроверимНаУдаленные
			Для Каждого Элемент Из Результат Цикл				
				//НайденнаяСтрока = FiscalPayments.Найти(Элемент.PaymentDocument, "PaymentDocument"); 
				//Если НайденнаяСтрока = Неопределено Тогда
				Payments = РегистрыСведений.FiscalPayments.СоздатьНаборЗаписей();
				Payments.Отбор.Invoice.Установить(ДанныеИБ.Ссылка);
				Payments.Отбор.PaymentDocument.Установить(Элемент.PaymentDocument);
				Payments.Записать();
				
				НаборЗаписей = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Invoice.Установить(ДанныеИБ.Ссылка);
				НаборЗаписей.Прочитать();
				Запись = НаборЗаписей.Добавить();
				Запись.Период = ТекущаяДата();
				
				AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
				Если ЗначениеЗаполнено(AutoUser)Тогда
					Запись.User = AutoUser;
				КонецЕсли;
				
				Запись.Invoice = ДанныеИБ.Ссылка;
				Запись.Comment = "Loaded from Billing";
				Запись.Status = Перечисления.InvoiceStatus.ПустаяСсылка();
				НаборЗаписей.Записать();
				//КонецЕсли;
			КонецЦикла;
			
			
		Иначе
			FiscalPayments = ПолученныеДанные.ДополнительныеСвойства.FiscalPayments;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	FiscalPayments.PaymentDocument,
			|	FiscalPayments.SettlementAmount
			|ИЗ
			|	РегистрСведений.FiscalPayments КАК FiscalPayments
			|ГДЕ
			|	FiscalPayments.Invoice = &Invoice";
			Запрос.УстановитьПараметр("Invoice", ДанныеИБ.Ссылка);
			Результат = Запрос.Выполнить().Выгрузить();
			
			//ПроверимНаУдаленные
			Для Каждого Элемент Из Результат Цикл				
				НайденнаяСтрока = FiscalPayments.Найти(Элемент.PaymentDocument, "PaymentDocument"); 
				Если НайденнаяСтрока = Неопределено Тогда
					Payments = РегистрыСведений.FiscalPayments.СоздатьНаборЗаписей();
					Payments.Отбор.Invoice.Установить(ДанныеИБ.Ссылка);
					Payments.Отбор.PaymentDocument.Установить(Элемент.PaymentDocument);
					Payments.Записать();
					
					НаборЗаписей = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
					НаборЗаписей.Отбор.Invoice.Установить(ДанныеИБ.Ссылка);
					НаборЗаписей.Прочитать();
					Запись = НаборЗаписей.Добавить();
					Запись.Период = ТекущаяДата();
					
					AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
					Если ЗначениеЗаполнено(AutoUser)Тогда
						Запись.User = AutoUser;
					КонецЕсли;
					
					Запись.Invoice = ДанныеИБ.Ссылка;
					Запись.Comment = "Loaded from Billing";
					Запись.Status = Перечисления.InvoiceStatus.ПустаяСсылка();
					НаборЗаписей.Записать();
				КонецЕсли;
			КонецЦикла;
			
			Если FiscalPayments.Количество() > 0 Тогда
				
				Для Каждого Строка из FiscalPayments Цикл
					
					Отбор = Новый Структура;
					Отбор.Вставить("PaymentDocument", Строка.PaymentDocument);
					ДокументОплаты = Результат.Скопировать(Отбор);			
					
					Если ДокументОплаты.Количество() > 0 Тогда
						
						Если ДокументОплаты[0].SettlementAmount <> Строка.SettlementAmount ИЛИ
							ДокументОплаты[0].Amount <> Строка.Amount Тогда
							
							Payments = РегистрыСведений.FiscalPayments.СоздатьНаборЗаписей();
							Payments.Отбор.Invoice.Установить(ДанныеИБ.Ссылка);
							Payments.Отбор.Source.Установить(ДанныеИБ.Source);
							Payments.Отбор.Company.Установить(ДанныеИБ.Company);
							Payments.Отбор.PaymentDocument.Установить(Строка.PaymentDocument);
							Payments.Прочитать();
							
							Payments[0].SettlementAmount = Строка.SettlementAmount;
							Payments[0].Amount = Строка.Amount;					
							Payments.Записать();						
						КонецЕсли;
						
					Иначе
						
						//Запрос = Новый Запрос;
						//Запрос.Текст = "ВЫБРАТЬ
						//|	FiscalPayments.Invoice
						//|ИЗ
						//|	РегистрСведений.FiscalPayments КАК FiscalPayments
						//|ГДЕ
						//|	FiscalPayments.PaymentDocument = &PaymentDocument
						//|	И FiscalPayments.Invoice.FiscalInvoiceNo <> &FiscalInvoiceNo";
						//Запрос.УстановитьПараметр("FiscalInvoiceNo", ДанныеИБ.FiscalInvoiceNo);			   
						//Запрос.УстановитьПараметр("PaymentDocument", Строка.PaymentDocument);
						//Результат = Запрос.Выполнить().Выбрать();
						//Пока Результат.Следующий() Цикл
						//	
						//	Payments = РегистрыСведений.FiscalPayments.СоздатьНаборЗаписей();
						//	Payments.Отбор.Invoice.Установить(Результат.Invoice);
						//	Payments.Отбор.PaymentDocument.Установить(Строка.PaymentDocument);
						//	Payments.Записать();
						//	
						//	НаборЗаписей = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
						//	НаборЗаписей.Отбор.Invoice.Установить(Результат.Invoice);
						//	НаборЗаписей.Прочитать();
						//	Запись = НаборЗаписей.Добавить();
						//	Запись.Период = ТекущаяДата();
						//	
						//	AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
						//	Если ЗначениеЗаполнено(AutoUser)Тогда
						//		Запись.User = AutoUser;
						//	КонецЕсли;
						//	
						//	Запись.Invoice = Результат.Invoice;
						//	Запись.Comment = "Loaded from Billing";
						//	Запись.Status = Перечисления.InvoiceStatus.ПустаяСсылка();
						//	НаборЗаписей.Записать();
						//	
						//КонецЦикла;
						
						Payments = РегистрыСведений.FiscalPayments.СоздатьНаборЗаписей();
						Payments.Отбор.Invoice.Установить(ДанныеИБ.Ссылка);
						Payments.Отбор.Source.Установить(ДанныеИБ.Source);
						Payments.Отбор.Company.Установить(ДанныеИБ.Company);
						Payments.Отбор.PaymentDocument.Установить(Строка.PaymentDocument);
						Payments.Прочитать();
						
						Запись = Payments.Добавить();
						Запись.Source = ДанныеИБ.Source;
						Запись.Invoice = ДанныеИБ.Ссылка;
						Запись.PaymentDocument = Строка.PaymentDocument;
						Запись.Company = ДанныеИБ.Company;
						
						Запись.PaymentDate = Строка.PaymentDate;
						ВалютаПравило = КомпонентыОбмена.ПравилаКонвертацииОбъектов.Найти("Справочник_Валюты_Получение", "ИмяПКО");
						Валюта = ОбменДаннымиXDTOСервер.СтруктураОбъектаXDTOВДанныеИБ(КомпонентыОбмена, Строка.Currency, ВалютаПравило, "ПолучитьСсылку"); 
						
						Запись.Currency = Валюта;			
						Запись.Amount = Строка.Amount;
						Запись.SettlementAmount = Строка.SettlementAmount;
						
						Payments.Записать();
						
					КонецЕсли;	
				КонецЦикла;				
			КонецЕсли;
			
			//Проставляем Статус
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	СУММА(FiscalPayments.SettlementAmount) КАК SettlementAmount
			|ИЗ
			|	РегистрСведений.FiscalPayments КАК FiscalPayments
			|ГДЕ
			|	FiscalPayments.Invoice = &Invoice";
			Запрос.УстановитьПараметр("Invoice", ДанныеИБ.Ссылка);
			Результат = Запрос.Выполнить().Выбрать();
			Если Результат.Количество() > 0 Тогда
				
				ЗапросСтатус = Новый Запрос;
				ЗапросСтатус.Текст = "ВЫБРАТЬ
				|	InvoiceCommentsСрезПоследних.Status
				|ИЗ
				|	РегистрСведений.InvoiceComments.СрезПоследних(, Invoice = &Invoice) КАК InvoiceCommentsСрезПоследних";
				ЗапросСтатус.УстановитьПараметр("Invoice", ДанныеИБ.Ссылка);
				РезультатСтатус = ЗапросСтатус.Выполнить().Выбрать();
				Если РезультатСтатус.Количество() > 0 Тогда
					РезультатСтатус.Следующий();
					ПоследнийСтатус = РезультатСтатус.Status;
				Иначе
					РезультатСтатус = Неопределено;
				КонецЕсли;
				
				Результат.Следующий();
				
				НаборЗаписейСтатусов = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
				НаборЗаписейСтатусов.Отбор.Invoice.Установить(ДанныеИБ.Ссылка);
				НаборЗаписейСтатусов.Прочитать();
				Запись = НаборЗаписейСтатусов.Добавить();
				Запись.Период = ТекущаяДата();
				
				AutoUser = Справочники.Пользователи.НайтиПоНаименованию("AutoUser");
				Если ЗначениеЗаполнено(AutoUser)Тогда
					Запись.User = AutoUser;
				КонецЕсли;
				
				Запись.Invoice = ДанныеИБ.Ссылка;
				Запись.Comment = "Loaded from Billing";
				
				Если Результат.SettlementAmount >= ДанныеИБ.Amount И ПоследнийСтатус <> Перечисления.InvoiceStatus.InvoicePaid Тогда
					Запись.Status = Перечисления.InvoiceStatus.InvoicePaid;
					НаборЗаписейСтатусов.Записать();
				ИначеЕсли Результат.SettlementAmount < ДанныеИБ.Amount И ПоследнийСтатус <> Перечисления.InvoiceStatus.PartiallyPaid Тогда
					Запись.Status = Перечисления.InvoiceStatus.PartiallyPaid;
					НаборЗаписейСтатусов.Записать();
				КонецЕсли;
				
			КонецЕсли
		КонецЕсли;
	КонецЕсли;
	
	Если КомпонентыОбмена.УзелКорреспондента = rgsОбменДокументамиERMПовтИспСеанс.ПолучитьУзелHOB() Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеИБ <> Неопределено Тогда
		
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеИБ.Ссылка, "Номер, DocID, DocNumber");
		ПолученныеДанные.Номер = СтруктураРеквизитов.Номер;
		ПолученныеДанные.DocID = СтруктураРеквизитов.DocID;
		ПолученныеДанные.DocNumber = СтруктураРеквизитов.DocNumber;
		
		Запрос = Новый Запрос;
		Запрос.Текст =
		"ВЫБРАТЬ
		|	Invoice.Ссылка
		|ИЗ
		|	Документ.Invoice КАК Invoice
		|ГДЕ
		|	Invoice.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSMITH)
		|	И Invoice.Client = &Client
		|	И НЕ Invoice.ПометкаУдаления
		|	И Invoice.DocNumber = &DocNumber
		|	И Invoice.Ссылка <> &Ссылка";
		Запрос.УстановитьПараметр("Client", ДанныеИБ.Client);
		Запрос.УстановитьПараметр("DocNumber", ДанныеИБ.DocNumber);
		Запрос.УстановитьПараметр("Ссылка", ДанныеИБ.Ссылка);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			ТекОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ТекОбъект.FiscalInvoiceNo = ПолученныеДанные.FiscalInvoiceNo;
			ТекОбъект.FiscalInvoiceDate = ПолученныеДанные.FiscalInvoiceDate;
			ТекОбъект.FiscalAmount = ПолученныеДанные.FiscalAmount;
			ТекОбъект.TriggerDate = ПолученныеДанные.TriggerDate;
			ТекОбъект.DueDateFrom = ПолученныеДанные.DueDateFrom;
			ТекОбъект.DueDateTo = ПолученныеДанные.DueDateTo;
			ТекОбъект.Contract = ПолученныеДанные.Contract;
			ТекОбъект.ОбменДанными.Загрузка = Истина;
			ТекОбъект.Записать();
			
		КонецЦикла;
		
	Иначе
		
		Если ПолученныеДанные.DocID = -1 Тогда
			ПолученныеДанные.DocID = Неопределено;
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
#Область Справочник_TriggerTypes_Получение
Процедура ДобавитьПКО_Справочник_TriggerTypes_Получение(ПравилаКонвертации)
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_TriggerTypes_Получение";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.TriggerTypes;
	ПравилоКонвертации.ОбъектФормата = "Справочник.TriggerTypes";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоУникальномуИдентификатору";
	
	
КонецПроцедуры
#КонецОбласти
#Область Справочник_Валюты_Получение
Процедура ДобавитьПКО_Справочник_Валюты_Получение(ПравилаКонвертации)
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Валюты_Получение";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Валюты;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Валюты";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоПолямПоиска";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Код";
	НоваяСтрока.СвойствоФормата = "Код";
	
	ПравилоКонвертации.ПоляПоиска.Добавить("Код");
КонецПроцедуры
#КонецОбласти
#Область Справочник_ДоговорыКонтрагентов_Получение
Процедура ДобавитьПКО_Справочник_ДоговорыКонтрагентов_Получение(ПравилаКонвертации)
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_ДоговорыКонтрагентов_Получение";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.ДоговорыКонтрагентов;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Договоры";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ПередЗаписьюПолученныхДанных = "ПКО_Справочник_ДоговорыКонтрагентов_Получение_ПередЗаписьюПолученныхДанных";
	ПравилоКонвертации.ВариантИдентификации = "ПоПолямПоиска";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Amendment";
	НоваяСтрока.СвойствоФормата = "Amendment";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "AmendmentName";
	НоваяСтрока.СвойствоФормата = "AmendmentName";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ChecklistRequired";
	НоваяСтрока.СвойствоФормата = "ChecklistRequired";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ContractGUID";
	НоваяСтрока.СвойствоФормата = "ContractGUID";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ContractID";
	НоваяСтрока.СвойствоФормата = "ContractID";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ContractID";
	НоваяСтрока.СвойствоФормата = "ContractID";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmContractCurrency";
	НоваяСтрока.СвойствоФормата = "crmContractCurrency";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmContractID";
	НоваяСтрока.СвойствоФормата = "crmContractID";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmContractName";
	НоваяСтрока.СвойствоФормата = "crmContractName";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmContractValueUSD";
	НоваяСтрока.СвойствоФормата = "crmContractValueUSD";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmCreatedBy";
	НоваяСтрока.СвойствоФормата = "crmCreatedBy";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmCreatedDate";
	НоваяСтрока.СвойствоФормата = "crmCreatedDate";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmDFNName";
	НоваяСтрока.СвойствоФормата = "crmDFNName";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmEffectiveDate";
	НоваяСтрока.СвойствоФормата = "crmEffectiveDate";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmExpiryDate";
	НоваяСтрока.СвойствоФормата = "crmExpiryDate";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "DocumentFlowPeriodFrom";
	НоваяСтрока.СвойствоФормата = "DocumentFlowPeriodFrom";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "DocumentFlowPeriodTo";
	НоваяСтрока.СвойствоФормата = "DocumentFlowPeriodTo";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "PIC_ID";
	НоваяСтрока.СвойствоФормата = "PIC_ID";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "PTDaysFrom";
	НоваяСтрока.СвойствоФормата = "PTDaysFrom";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "PTType";
	НоваяСтрока.СвойствоФормата = "PTType";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "SourceID";
	НоваяСтрока.СвойствоФормата = "SourceID";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Trigger";
	НоваяСтрока.СвойствоФормата = "Trigger";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_TriggerTypes_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ВалютаВзаиморасчетов";
	НоваяСтрока.СвойствоФормата = "ВалютаВзаиморасчетов";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Валюты_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "ВидДоговора";
	НоваяСтрока.СвойствоФормата = "ВидДоговора";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Перечисление_ВидыДоговоровКонтрагентов_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Владелец";
	НоваяСтрока.СвойствоФормата = "Контрагент";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Контрагенты_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Дата";
	НоваяСтрока.СвойствоФормата = "Дата";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Комментарий";
	НоваяСтрока.СвойствоФормата = "Комментарий";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Наименование";
	НоваяСтрока.СвойствоФормата = "Наименование";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Номер";
	НоваяСтрока.СвойствоФормата = "Номер";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Организация";
	НоваяСтрока.СвойствоФормата = "Организация";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Организации_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "РасчетыВУсловныхЕдиницах";
	НоваяСтрока.СвойствоФормата = "РасчетыВУсловныхЕдиницах";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "СрокДействия";
	НоваяСтрока.СвойствоФормата = "СрокДействия";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "СрокОплаты";
	НоваяСтрока.СвойствоФормата = "PTDaysTo";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "УстановленСрокОплаты";
	НоваяСтрока.СвойствоФормата = "УстановленСрокОплаты";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "УчетАгентскогоНДС";
	НоваяСтрока.СвойствоФормата = "УчетАгентскогоНДС";
	ПравилоКонвертации.СвойстваТабличныхЧастей.Вставить("КодыCRMпоСегментам", ОбменДаннымиXDTOСервер.ИнициализироватьТаблицуСвойствДляПравилаКонвертации());
	СвойстваТЧ = ПравилоКонвертации.СвойстваТабличныхЧастей.КодыCRMпоСегментам;
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "crmContractID";
	НоваяСтрока.СвойствоФормата = "crmContractID";
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "PIC_ID";
	НоваяСтрока.СвойствоФормата = "PIC_ID";
	
	НоваяСтрока = СвойстваТЧ.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Segment";
	НоваяСтрока.СвойствоФормата = "Segment";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Справочник_Сегменты_Получение";
	
	ПравилоКонвертации.ПоляПоиска.Добавить("ContractGUID,Организация");
КонецПроцедуры

Процедура ПКО_Справочник_ДоговорыКонтрагентов_Получение_ПередЗаписьюПолученныхДанных(ПолученныеДанные, ДанныеИБ, КонвертацияСвойств, КомпонентыОбмена)
	Если КомпонентыОбмена.УзелКорреспондента = rgsОбменДокументамиERMПовтИспСеанс.ПолучитьУзелHOB() Тогда
		//ПолученныеДанные.crmContractName = СтруктураРеквизитов.Наименование;
		//ПолученныеДанные.crmContractCurrency = СтруктураРеквизитов.ВалютаВзаиморасчетов;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
#Область Справочник_Контрагенты_Получение
Процедура ДобавитьПКО_Справочник_Контрагенты_Получение(ПравилаКонвертации)
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Контрагенты_Получение";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Контрагенты;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Контрагенты";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ПриКонвертацииДанныхXDTO = "ПКО_Справочник_Контрагенты_Получение_ПриКонвертацииДанныхXDTO";
	ПравилоКонвертации.ВариантИдентификации = "ПоПолямПоиска";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "CRMID";
	НоваяСтрока.СвойствоФормата = "CRMID";
	
	ПравилоКонвертации.ПоляПоиска.Добавить("CRMID");
КонецПроцедуры

Процедура ПКО_Справочник_Контрагенты_Получение_ПриКонвертацииДанныхXDTO(ДанныеXDTO, ПолученныеДанные, КомпонентыОбмена)
	Если КомпонентыОбмена.УзелКорреспондента = rgsОбменДокументамиERMПовтИспСеанс.ПолучитьУзелHOB() Тогда
		
		Если ДанныеXDTO.КлючевыеСвойства.Свойство("ИНН") Тогда
			
			Запрос = Новый Запрос;
			Запрос.Текст = 
			"ВЫБРАТЬ
			|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
			|ИЗ
			|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
			|			,
			|			Идентификатор = &ИНН
			|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
			|				И ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.HOBs)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних";
			
			Запрос.УстановитьПараметр("ИНН", ДанныеXDTO.КлючевыеСвойства.ИНН);
			
			РезультатЗапроса = Запрос.Выполнить();
			
			Если НЕ РезультатЗапроса.Пустой() Тогда
				
				Выборка = РезультатЗапроса.Выбрать();
				Выборка.Следующий();
				
				ПолученныеДанные = Выборка.ОбъектПриемника.ПолучитьОбъект();
				
			Иначе
				
				ПолученныеДанные = Справочники.Контрагенты.СоздатьЭлемент();
				
			КонецЕсли;
			
		Иначе
			
			ПолученныеДанные = Справочники.Контрагенты.СоздатьЭлемент();
			
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
#Область Справочник_Организации_Получение
Процедура ДобавитьПКО_Справочник_Организации_Получение(ПравилаКонвертации)
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Организации_Получение";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Организации;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Организации";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоПолямПоиска";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Source";
	НоваяСтрока.СвойствоФормата = "Source";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Перечисление_ТипыСоответствий_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Код";
	НоваяСтрока.СвойствоФормата = "Код";
	
	ПравилоКонвертации.ПоляПоиска.Добавить("Source,Код");
КонецПроцедуры
#КонецОбласти
#Область Справочник_Сегменты_Получение
Процедура ДобавитьПКО_Справочник_Сегменты_Получение(ПравилаКонвертации)
	
	ПравилоКонвертации = ОбменДаннымиXDTOСервер.ИнициализироватьПравилоКонвертацииОбъекта(ПравилаКонвертации);
	ПравилоКонвертации.ИмяПКО = "Справочник_Сегменты_Получение";
	ПравилоКонвертации.ОбъектДанных = Метаданные.Справочники.Сегменты;
	ПравилоКонвертации.ОбъектФормата = "Справочник.Сегменты";
	ПравилоКонвертации.ПравилоДляГруппыСправочника = Ложь;
	ПравилоКонвертации.ВариантИдентификации = "ПоПолямПоиска";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Source";
	НоваяСтрока.СвойствоФормата = "Source";
	НоваяСтрока.ПравилоКонвертацииСвойства = "Перечисление_ТипыСоответствий_Получение";
	
	НоваяСтрока = ПравилоКонвертации.Свойства.Добавить();
	НоваяСтрока.СвойствоКонфигурации = "Код";
	НоваяСтрока.СвойствоФормата = "Код";
	
	ПравилоКонвертации.ПоляПоиска.Добавить("Source,Код");
КонецПроцедуры
#КонецОбласти
#КонецОбласти

#КонецОбласти
#Область ПКПД
// Заполняет таблицу правил конвертации предопределенных данных.
//
// Параметры:
//  НаправлениеОбмена - строка ("Отправка" либо "Получение").
//  ПравилаКонвертации - таблица значений, в которую будут добавлены правила. 
Процедура ЗаполнитьПравилаКонвертацииПредопределенныхДанных(НаправлениеОбмена, ПравилаКонвертации) Экспорт
	Если НаправлениеОбмена = "Получение" Тогда
		// Перечисление_ВидыДоговоровКонтрагентов_Получение.
		ПравилоКонвертации = ПравилаКонвертации.Добавить();
		ПравилоКонвертации.ИмяПКПД = "Перечисление_ВидыДоговоровКонтрагентов_Получение";
		ПравилоКонвертации.ТипДанных = Метаданные.Перечисления.ВидыДоговоровКонтрагентов;
		ПравилоКонвертации.ТипXDTO = "ВидыДоговоров";
		
		ЗначенияДляПолучения = Новый Соответствие;
		ЗначенияДляПолучения.Вставить("Прочее", Перечисления.ВидыДоговоровКонтрагентов.Прочее);
		ЗначенияДляПолучения.Вставить("СКомиссионером", Перечисления.ВидыДоговоровКонтрагентов.СКомиссионером);
		ЗначенияДляПолучения.Вставить("СКомиссионеромНаЗакупку", Перечисления.ВидыДоговоровКонтрагентов.СКомиссионеромНаЗакупку);
		ЗначенияДляПолучения.Вставить("СКомитентом", Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
		ЗначенияДляПолучения.Вставить("СКомитентомНаЗакупку", Перечисления.ВидыДоговоровКонтрагентов.СКомитентомНаЗакупку);
		ЗначенияДляПолучения.Вставить("СПокупателем", Перечисления.ВидыДоговоровКонтрагентов.СПокупателем);
		ЗначенияДляПолучения.Вставить("СПоставщиком", Перечисления.ВидыДоговоровКонтрагентов.СПоставщиком);
		ПравилоКонвертации.КонвертацииЗначенийПриПолучении = ЗначенияДляПолучения;
		
		// Перечисление_ТипыСоответствий_Получение.
		ПравилоКонвертации = ПравилаКонвертации.Добавить();
		ПравилоКонвертации.ИмяПКПД = "Перечисление_ТипыСоответствий_Получение";
		ПравилоКонвертации.ТипДанных = Метаданные.Перечисления.ТипыСоответствий;
		ПравилоКонвертации.ТипXDTO = "Source";
		
		ЗначенияДляПолучения = Новый Соответствие;
		ЗначенияДляПолучения.Вставить("HOBs", Перечисления.ТипыСоответствий.HOBs);
		ЗначенияДляПолучения.Вставить("Lawson", Перечисления.ТипыСоответствий.Lawson);
		ЗначенияДляПолучения.Вставить("OracleMI", Перечисления.ТипыСоответствий.OracleMI);
		ЗначенияДляПолучения.Вставить("OracleSmith", Перечисления.ТипыСоответствий.OracleSmith);
		ПравилоКонвертации.КонвертацииЗначенийПриПолучении = ЗначенияДляПолучения;
		
		// Перечисление_ЮридическоеФизическоеЛицо_Получение.
		ПравилоКонвертации = ПравилаКонвертации.Добавить();
		ПравилоКонвертации.ИмяПКПД = "Перечисление_ЮридическоеФизическоеЛицо_Получение";
		ПравилоКонвертации.ТипДанных = Метаданные.Перечисления.ЮридическоеФизическоеЛицо;
		ПравилоКонвертации.ТипXDTO = "ЮридическоеФизическоеЛицо";
		
		ЗначенияДляПолучения = Новый Соответствие;
		ЗначенияДляПолучения.Вставить("ФизическоеЛицо", Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо);
		ЗначенияДляПолучения.Вставить("ЮридическоеЛицо", Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо);
		ПравилоКонвертации.КонвертацииЗначенийПриПолучении = ЗначенияДляПолучения;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
#Область Алгоритмы



#КонецОбласти
#Область Параметры
// Заполняет параметры конвертации.
//
// Параметры:
//  ПараметрыКонвертации - структура, в которую добавляются параметры конвертации.
Процедура ЗаполнитьПараметрыКонвертации(ПараметрыКонвертации) Экспорт
КонецПроцедуры

#КонецОбласти
#Область ОбщегоНазначения
// Процедура-обертка, выполняет запуск указанной в параметрах процедуры модуля менеджера обмена через формат.
//
// Параметры:
//  ИмяПроцедуры - строка.
//  СтруктураПараметров - структура, содержащая передаваемые параметры.
Процедура ВыполнитьПроцедуруМодуляМенеджера(ИмяПроцедуры, Параметры) Экспорт
	Если ИмяПроцедуры = "ПКО_Документ_Invoice_Получение_ПриКонвертацииДанныхXDTO" Тогда 
		ПКО_Документ_Invoice_Получение_ПриКонвертацииДанныхXDTO(
		Параметры.ДанныеXDTO, Параметры.ПолученныеДанные, Параметры.КомпонентыОбмена);
	ИначеЕсли ИмяПроцедуры = "ПКО_Документ_Invoice_Получение_ПередЗаписьюПолученныхДанных" Тогда 
		ПКО_Документ_Invoice_Получение_ПередЗаписьюПолученныхДанных(
		Параметры.ПолученныеДанные, Параметры.ДанныеИБ, Параметры.КонвертацияСвойств, Параметры.КомпонентыОбмена);
	ИначеЕсли ИмяПроцедуры = "ПКО_Справочник_ДоговорыКонтрагентов_Получение_ПередЗаписьюПолученныхДанных" Тогда 
		ПКО_Справочник_ДоговорыКонтрагентов_Получение_ПередЗаписьюПолученныхДанных(
		Параметры.ПолученныеДанные, Параметры.ДанныеИБ, Параметры.КонвертацияСвойств, Параметры.КомпонентыОбмена);
	ИначеЕсли ИмяПроцедуры = "ПКО_Справочник_Контрагенты_Получение_ПриКонвертацииДанныхXDTO" Тогда 
		ПКО_Справочник_Контрагенты_Получение_ПриКонвертацииДанныхXDTO(
		Параметры.ДанныеXDTO, Параметры.ПолученныеДанные, Параметры.КомпонентыОбмена);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
