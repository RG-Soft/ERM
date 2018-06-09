#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	//{{__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ТранзакцияHOB") Тогда
		// Заполнение шапки
		ДокументОснование = ДанныеЗаполнения.Ссылка;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ТранзакцияOracle") Тогда
		// Заполнение шапки
		ДокументОснование = ДанныеЗаполнения.Ссылка;
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ПроводкаDSS") Тогда
		// Заполнение шапки
		ДокументОснование = ДанныеЗаполнения.Ссылка;
	КонецЕсли;
	//}}__КОНСТРУКТОР_ВВОД_НА_ОСНОВАНИИ
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() Тогда
		Ответственный = Пользователи.ТекущийПользователь();
	КонецЕсли;

	Если НЕ ПометкаУдаления Тогда
	РеквизитыТранзакции = Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(ДокументОснование, Отказ);
		Если РеквизитыТранзакции.Client = ДетализацияПоКлиенту[0].Client И
					РеквизитыТранзакции.Account = Account И
					РеквизитыТранзакции.Company = Company И
					РеквизитыТранзакции.Location = Location И
					РеквизитыТранзакции.SubSubSegment = SubSubSegment И
					РеквизитыТранзакции.Currency = Currency И
					РеквизитыТранзакции.LegalEntity = LegalEntity И
					РеквизитыТранзакции.AU = AU 
					И ДетализацияПоКлиенту.Количество() = 1 Тогда
				Отказ = Истина;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Attributes not changed.",,, Отказ);
		КонецЕсли;
		
		ПустойКлиент = Справочники.Контрагенты.ПустаяСсылка();
		
		Для каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
			Если СтрокаТабЧасти.Client = ПустойКлиент Тогда
				Отказ = Истина;
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("The client is not filled.",,, Отказ);
			КонецЕсли;
		КонецЦикла;
			
		// { RGS TAlmazova 04.08.2017 13:09:46 - не записывать корректировку для помеченной на удаление транзакции
		Если РеквизитыТранзакции.ПометкаУдаления Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("The base transaction is marked for deletion.",,, Отказ);
		КонецЕсли;
		// } RGS TAlmazova 04.08.2017 13:10:34 - не создавать корректировку для помеченной на удаление транзакции
		// { RGS VSobolev 17.05.2018 14:30:51 - проверка наличия корректировки для транзакции
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	КорректировкаТранзакции.Номер
			|ИЗ
			|	Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
			|ГДЕ
			|	НЕ КорректировкаТранзакции.ПометкаУдаления
			|	И КорректировкаТранзакции.ДокументОснование = &ДокументОснование
			|	И КорректировкаТранзакции.Ссылка <> &Ссылка";
	
		Запрос.УстановитьПараметр("ДокументОснование", ДокументОснование);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
		РезультатЗапроса = Запрос.Выполнить();
	
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
		Если ВыборкаДетальныеЗаписи.Количество() <> 0 Тогда
			ВыборкаДетальныеЗаписи.Следующий();
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("For this transaction adjustments already. Mark the deletion of the previous adjustment (№ "+ ВыборкаДетальныеЗаписи.Номер + ") before creating a new one.",,, Отказ);
		КонецЕсли;
		// } RGS VSobolev 17.05.2018 14:30:51 - проверка наличия корректировки для транзакции
		
		Если ЭтоНовый() Тогда
		
			CreatedBy = Пользователи.ТекущийПользователь();
			CreationDate = ТекущаяДата();
		
		Иначе
		
			ModifiedBy = Пользователи.ТекущийПользователь();
			ModificationDate = ТекущаяДата();
		
		КонецЕсли;
		
	КонецЕсли;
		
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ВалютаUSD = Константы.rgsВалютаUSD.Получить();
//	СчетВыручкиHFM = rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня");
	
	РеквизитыТранзакции = Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(ДокументОснование, Отказ);
	
	ПроверитьMappingКлиентов(Отказ, РеквизитыТранзакции.Source);
	
	Если НЕ Отказ Тогда
		
//		Если РеквизитыТранзакции.Source = Перечисления.ТипыСоответствий.Lawson Тогда
//			
//			ПараметрыПроведения = Документы.ПроводкаDSS.ПодготовитьПараметрыПроведения(ДокументОснование, Отказ);
//			СуммыДляПроводки = Документы.ПроводкаDSS.ПолучитьСуммыДляПроводки(РеквизитыТранзакции, ПараметрыПроведения.СвязанныеДокументы, СчетВыручкиHFM, ВалютаUSD, Отказ)
//			
//		ИначеЕсли РеквизитыТранзакции.Source = Перечисления.ТипыСоответствий.HOBs Тогда
//			
//			СуммыДляПроводки = Документы.ТранзакцияHOB.ПолучитьСуммыДляПроводки(РеквизитыТранзакции, СчетВыручкиHFM, ВалютаUSD, Отказ);
//			
//		Иначе
//			
//			СуммыДляПроводки = Документы.ТранзакцияOracle.ПолучитьСуммыДляПроводки(Реквизиты, СчетВыручкиHFM, ВалютаUSD, Отказ);
//			
//		КонецЕсли;

		
		//Если (РеквизитыТранзакции.Amount <> ДетализацияПоКлиенту.Итог("Amount") И РеквизитыТранзакции.Source = Перечисления.ТипыСоответствий.OracleSmith
		//	ИЛИ РеквизитыТранзакции.BaseAmount <> ДетализацияПоКлиенту.Итог("BaseAmount") И РеквизитыТранзакции.Source <> Перечисления.ТипыСоответствий.OracleSmith)
		Если (РеквизитыТранзакции.Amount <> ДетализацияПоКлиенту.Итог("Amount") ИЛИ РеквизитыТранзакции.BaseAmount <> ДетализацияПоКлиенту.Итог("BaseAmount")) 
			И РеквизитыТранзакции.Currency = Currency Тогда
			Отказ = Истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("The amount of the document differs from the transaction amount",,, Отказ);
		КонецЕсли;
		
		НЗ_BilledAR = РегистрыНакопления.BilledAR.СоздатьНаборЗаписей();
		НЗ_BilledAR.Отбор.Регистратор.Установить(ДокументОснование);
		НЗ_BilledAR.Прочитать();
		
		Если НЗ_BilledAR.Количество() > 0 Тогда
			
			ДвиженияBilledAR = Движения.BilledAR;
			
			Для Каждого Запись Из НЗ_BilledAR Цикл
				НовоеДвижениеСторно = ДвиженияBilledAR.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеДвижениеСторно,Запись);
				НовоеДвижениеСторно.Период = Запись.Период;
				НовоеДвижениеСторно.Amount = -Запись.Amount;
				НовоеДвижениеСторно.BaseAmount = -Запись.BaseAmount;
				
				ЗнакДвижения = ?(Запись.Amount * РеквизитыТранзакции.Amount < 0, -1, 1);
				
				Для каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
					НовоеДвижение = ДвиженияBilledAR.Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ЭтотОбъект);
					НовоеДвижение.Период = Запись.Период;
					НовоеДвижение.ВидДвижения = Запись.ВидДвижения;
					НовоеДвижение.Source = Запись.Source;
					//ЗначенияРеквизитовДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Invoice, "Client");
					ИзменитьКлиентаВДокументе(Запись.Invoice, СтрокаТабЧасти.Client, Запись.Source);
					НовоеДвижение.Invoice = Запись.Invoice;
					НовоеДвижение.Client = СтрокаТабЧасти.Client;
					НовоеДвижение.Amount = СтрокаТабЧасти.Amount * ЗнакДвижения;
					НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount * ЗнакДвижения;
				КонецЦикла;
			КонецЦикла;
			
			ДвиженияBilledAR.Записывать = Истина;
			
		КонецЕсли;
		
		НЗ_UnbilledAR = РегистрыНакопления.UnbilledAR.СоздатьНаборЗаписей();
		НЗ_UnbilledAR.Отбор.Регистратор.Установить(ДокументОснование);
		НЗ_UnbilledAR.Прочитать();
		
		Если НЗ_UnbilledAR.Количество() > 0 Тогда
			
			ДвиженияUnbilledAR = Движения.UnbilledAR;
			
			Для Каждого Запись Из НЗ_UnbilledAR Цикл
				НовоеДвижениеСторно = ДвиженияUnbilledAR.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеДвижениеСторно,Запись);
				НовоеДвижениеСторно.Период = Запись.Период;
				НовоеДвижениеСторно.Amount = -Запись.Amount;
				НовоеДвижениеСторно.BaseAmount = -Запись.BaseAmount;
				
				ЗнакДвижения = ?(Запись.Amount * РеквизитыТранзакции.Amount < 0, -1, 1);
				
				Для каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
					НовоеДвижение = ДвиженияUnbilledAR.Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ЭтотОбъект);
					НовоеДвижение.Период = Запись.Период;
					НовоеДвижение.ВидДвижения = Запись.ВидДвижения;
					НовоеДвижение.Source = Запись.Source;
					//ЗначенияРеквизитовДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.SalesOrder, "Client");
					ИзменитьКлиентаВДокументе(Запись.SalesOrder, СтрокаТабЧасти.Client, Запись.Source);
					НовоеДвижение.SalesOrder = Запись.SalesOrder;
					НовоеДвижение.Client = СтрокаТабЧасти.Client;
					НовоеДвижение.Amount = СтрокаТабЧасти.Amount * ЗнакДвижения;
					НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount * ЗнакДвижения;
				КонецЦикла;
			КонецЦикла;
			
			ДвиженияUnbilledAR.Записывать = Истина;
			
		КонецЕсли;
		
		НЗ_UnallocatedCash = РегистрыНакопления.UnallocatedCash.СоздатьНаборЗаписей();
		НЗ_UnallocatedCash.Отбор.Регистратор.Установить(ДокументОснование);
		НЗ_UnallocatedCash.Прочитать();
		
		Если НЗ_UnallocatedCash.Количество() > 0 Тогда
			
			ДвиженияUnallocatedCash = Движения.UnallocatedCash;
			
			Для Каждого Запись Из НЗ_UnallocatedCash Цикл
				НовоеДвижениеСторно = ДвиженияUnallocatedCash.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеДвижениеСторно,Запись);
				НовоеДвижениеСторно.Период = Запись.Период;
				НовоеДвижениеСторно.Amount = -Запись.Amount;
				НовоеДвижениеСторно.BaseAmount = -Запись.BaseAmount;
				
				ЗнакДвижения = ?(Запись.Amount * РеквизитыТранзакции.Amount < 0, -1, 1);
				
				Для Каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
					НовоеДвижение = ДвиженияUnallocatedCash.Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ЭтотОбъект);
					НовоеДвижение.Период = Запись.Период;
					НовоеДвижение.ВидДвижения = Запись.ВидДвижения;
					НовоеДвижение.Source = Запись.Source;
					//ЗначенияРеквизитовДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.CashBatch, "Client");
					ИзменитьКлиентаВДокументе(Запись.CashBatch, СтрокаТабЧасти.Client, Запись.Source);
					НовоеДвижение.CashBatch = Запись.CashBatch;
					НовоеДвижение.Client = СтрокаТабЧасти.Client;
					НовоеДвижение.Amount = СтрокаТабЧасти.Amount * ЗнакДвижения;
					НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount * ЗнакДвижения;
				КонецЦикла;
			КонецЦикла;
			
			ДвиженияUnallocatedCash.Записывать = Истина;
			
		КонецЕсли;
		
		НЗ_UnallocatedMemo = РегистрыНакопления.UnallocatedMemo.СоздатьНаборЗаписей();
		НЗ_UnallocatedMemo.Отбор.Регистратор.Установить(ДокументОснование);
		НЗ_UnallocatedMemo.Прочитать();
		
		Если НЗ_UnallocatedMemo.Количество() > 0 Тогда
			
			ДвиженияUnallocatedMemo = Движения.UnallocatedMemo;
			
			Для Каждого Запись Из НЗ_UnallocatedMemo Цикл
				НовоеДвижениеСторно = ДвиженияUnallocatedMemo.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеДвижениеСторно,Запись);
				НовоеДвижениеСторно.Период = Запись.Период;
				НовоеДвижениеСторно.Amount = -Запись.Amount;
				НовоеДвижениеСторно.BaseAmount = -Запись.BaseAmount;
				
				ЗнакДвижения = ?(Запись.Amount * РеквизитыТранзакции.Amount < 0, -1, 1);
				
				Для каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
					НовоеДвижение = ДвиженияUnallocatedMemo.Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ЭтотОбъект);
					НовоеДвижение.Период = Запись.Период;
					НовоеДвижение.ВидДвижения = Запись.ВидДвижения;
					НовоеДвижение.Source = Запись.Source;
					ЗначенияРеквизитовДокумента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.Memo, "Client");
					ИзменитьКлиентаВДокументе(Запись.Memo, СтрокаТабЧасти.Client, Запись.Source);
					НовоеДвижение.Memo = Запись.Memo;
					НовоеДвижение.Client = СтрокаТабЧасти.Client;
					НовоеДвижение.Amount = СтрокаТабЧасти.Amount * ЗнакДвижения;
					НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount * ЗнакДвижения;
				КонецЦикла;
			КонецЦикла;
			
			ДвиженияUnallocatedMemo.Записывать = Истина;
			
		КонецЕсли;
		
		НЗ_ManualTransactions = РегистрыНакопления.ManualTransactions.СоздатьНаборЗаписей();
		НЗ_ManualTransactions.Отбор.Регистратор.Установить(ДокументОснование);
		НЗ_ManualTransactions.Прочитать();
		
		Если НЗ_ManualTransactions.Количество() > 0 Тогда
			
			ДвиженияManualTransactions = Движения.ManualTransactions;
			
			//СтруктураПоискаРучнойКорректировки = Новый Структура("Company, Client, Location, SubSubSegment, AU, Account, Currency");
			
			Для Каждого Запись Из НЗ_ManualTransactions Цикл
				НовоеДвижениеСторно = ДвиженияManualTransactions.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеДвижениеСторно,Запись);
				НовоеДвижениеСторно.Период = Запись.Период;
				НовоеДвижениеСторно.Amount = -Запись.Amount;
				НовоеДвижениеСторно.BaseAmount = -Запись.BaseAmount;
				
				ЗнакДвижения = ?(Запись.Amount * РеквизитыТранзакции.Amount < 0, -1, 1);
				
				Для каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
					НовоеДвижение = ДвиженияManualTransactions.Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ЭтотОбъект);
					НовоеДвижение.Период = Запись.Период;
					НовоеДвижение.ВидДвижения = Запись.ВидДвижения;
					НовоеДвижение.Source = Запись.Source;
					НовоеДвижение.РучнаяКорректировка = НайтиСоздатьJV(СтрокаТабЧасти.Client, Запись.РучнаяКорректировка.Дата, Отказ);
					НовоеДвижение.Client = СтрокаТабЧасти.Client;
					НовоеДвижение.Amount = СтрокаТабЧасти.Amount * ЗнакДвижения;
					НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount * ЗнакДвижения;
				КонецЦикла;
			КонецЦикла;
			
			ДвиженияManualTransactions.Записывать = Истина;
			
		КонецЕсли;
		
		НЗ_Payments = РегистрыНакопления.Payments.СоздатьНаборЗаписей();
		НЗ_Payments.Отбор.Регистратор.Установить(ДокументОснование);
		НЗ_Payments.Прочитать();
		
		Если НЗ_Payments.Количество() > 0 Тогда
			
			ДвиженияPayments = Движения.Payments;
			
			Для Каждого Запись Из НЗ_Payments Цикл
				НовоеДвижениеСторно = ДвиженияPayments.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеДвижениеСторно,Запись);
				НовоеДвижениеСторно.Период = Запись.Период;
				НовоеДвижениеСторно.Amount = -Запись.Amount;
				
				ЗнакДвижения = ?(Запись.Amount * РеквизитыТранзакции.Amount < 0, -1, 1);
				
				Для каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
					НовоеДвижение = ДвиженияPayments.Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ЭтотОбъект);
					НовоеДвижение.Период = Запись.Период;
					//НовоеДвижение.ВидДвижения = Запись.ВидДвижения;
					НовоеДвижение.Source = Запись.Source;
					// { RGS TAlmazova 1/8/2018 2:39:24 PM - клиент меняется в документе при создани движения по основным регистрам, тут не нужно
					//Если ЗначениеЗаполнено(Запись.Invoice) Тогда
					//	ИзменитьКлиентаВДокументе(Запись.Invoice, СтрокаТабЧасти.Client, Запись.Source);
					//КонецЕсли;
					//ИзменитьКлиентаВДокументе(Запись.CashBatch, СтрокаТабЧасти.Client, Запись.Source);
					// } RGS TAlmazova 1/8/2018 2:39:48 PM - клиент меняется в документе при создани движения по основным регистрам, тут не нужно
					НовоеДвижение.Invoice = Запись.Invoice;
					НовоеДвижение.CashBatch = Запись.CashBatch;
					НовоеДвижение.Client = СтрокаТабЧасти.Client;
					НовоеДвижение.Amount = СтрокаТабЧасти.Amount * ЗнакДвижения;
					//НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount;
				КонецЦикла;
			КонецЦикла;
			
			ДвиженияPayments.Записывать = Истина;
			
		КонецЕсли;
		
		НЗ_Revenue = РегистрыНакопления.Revenue.СоздатьНаборЗаписей();
		НЗ_Revenue.Отбор.Регистратор.Установить(ДокументОснование);
		НЗ_Revenue.Прочитать();
		
		Если НЗ_Revenue.Количество() > 0 Тогда
			
			ДвиженияRevenue = Движения.Revenue;
			
			Для Каждого Запись Из НЗ_Revenue Цикл
				НовоеДвижениеСторно = ДвиженияRevenue.Добавить();
				ЗаполнитьЗначенияСвойств(НовоеДвижениеСторно,Запись);
				НовоеДвижениеСторно.Период = Запись.Период;
				НовоеДвижениеСторно.Amount = -Запись.Amount;
				НовоеДвижениеСторно.BaseAmount = -Запись.BaseAmount;
				
				ЗнакДвижения = ?(Запись.Amount * РеквизитыТранзакции.Amount < 0, -1, 1);
				
				Для каждого СтрокаТабЧасти Из ДетализацияПоКлиенту Цикл
					НовоеДвижение = ДвиженияRevenue.Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ЭтотОбъект);
					НовоеДвижение.Период = Запись.Период;
					НовоеДвижение.Source = Запись.Source;
					Если ТипЗнч(Запись.Document) = Тип("ДокументСсылка.РучнаяКорректировка") Тогда
						НовоеДвижение.Document = НайтиСоздатьJV(СтрокаТабЧасти.Client, Запись.Document.Дата, отказ);
					Иначе
						ИзменитьКлиентаВДокументе(Запись.Document, СтрокаТабЧасти.Client, Запись.Source);
						НовоеДвижение.Document = Запись.Document;
					КонецЕсли;
					НовоеДвижение.Client = СтрокаТабЧасти.Client;
					НовоеДвижение.Amount = СтрокаТабЧасти.Amount * ЗнакДвижения;
					НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount * ЗнакДвижения;
					// { RGS AGorlenko 18.09.2017 18:03:00 - для выручки base amount пересчитываем по курсу при записи в регистр
					//Если СтрокаТабЧасти.BaseAmount = 0 Тогда
					// } RGS AGorlenko 18.09.2017 18:03:24 - для выручки base amount пересчитываем по курсу при записи в регистр
//						Если Currency = ВалютаUSD Тогда
//							НовоеДвижение.BaseAmount = СтрокаТабЧасти.Amount * ЗнакДвижения;
//						Иначе
//							СтруктураКурсаВалюты = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(Currency, Запись.Период);
//							Если Не ЗначениеЗаполнено(СтруктураКурсаВалюты.Курс) Тогда
//								ОбщегоНазначенияКлиентСервер.СообщитьПользователю("No exchange rate " + Currency, , , , Отказ);
//								Возврат;
//							КонецЕсли;
//							НовоеДвижение.BaseAmount = СтрокаТабЧасти.Amount * ЗнакДвижения / СтруктураКурсаВалюты.Курс * ?(СтруктураКурсаВалюты.Кратность = 0, 1, СтруктураКурсаВалюты.Кратность);
//						КонецЕсли;
					// { RGS AGorlenko 18.09.2017 18:03:42 - для выручки base amount пересчитываем по курсу при записи в регистр
					//Иначе
					//	НовоеДвижение.BaseAmount = СтрокаТабЧасти.BaseAmount * ЗнакДвижения;
					//КонецЕсли;
					// } RGS AGorlenko 18.09.2017 18:03:43 - для выручки base amount пересчитываем по курсу при записи в регистр
				КонецЦикла;
			КонецЦикла;
			
			ДвиженияRevenue.Записывать = Истина;
			
		КонецЕсли;
		
		ОтметитьВыполнениеЗадачи();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьКлиентаВДокументе(Документ, Клиент, Source)
		
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Период) КАК Период
		|ПОМЕСТИТЬ МаксимальныйПериод
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			,
		|			ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|				И ТипСоответствия = &Source
		|				И ОбъектПриемника = &Клиент) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Период КАК Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ТипСоответствия,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ТипОбъектаВнешнейСистемы,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			,
		|			ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|				И ТипСоответствия = &Source
		|				И ОбъектПриемника = &Клиент) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ МаксимальныйПериод КАК МаксимальныйПериод
		|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Период = МаксимальныйПериод.Период";
	
	Запрос.УстановитьПараметр("Source", Source);
	Запрос.УстановитьПараметр("Клиент", Клиент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	ClientID = ВыборкаДетальныеЗаписи.Идентификатор;
	
	ДокОбъект = Документ.ПолучитьОбъект();
	ДокОбъект.Client = Клиент;
	ДокОбъект.ClientID = ClientID;
	ДокОбъект.Записать();
	
КонецПроцедуры

Функция НайтиСоздатьJV(Клиент, ДатаКорректировки, Отказ)
	
	РеквизитыТранзакции = Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(ДокументОснование, Отказ);
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КлючиРучныхКорректировок.РучнаяКорректировка
		|ИЗ
		|	РегистрСведений.КлючиРучныхКорректировок КАК КлючиРучныхКорректировок
		|ГДЕ
		|	КлючиРучныхКорректировок.Source = &Source
		|	И КлючиРучныхКорректировок.Company = &Company
		|	И КлючиРучныхКорректировок.AU = &AU
		|	И КлючиРучныхКорректировок.Account = &Account
		|	И КлючиРучныхКорректировок.Currency = &Currency
		|	И КлючиРучныхКорректировок.Client = &Client";
	
	Запрос.УстановитьПараметр("Account", Account);
	Запрос.УстановитьПараметр("AU", AU);
	Запрос.УстановитьПараметр("Client", Клиент);
	Запрос.УстановитьПараметр("Company", Company);
	Запрос.УстановитьПараметр("Currency", Currency);
	Запрос.УстановитьПараметр("Source", РеквизитыТранзакции.Source);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() <> 0 Тогда
		ВыборкаДетальныеЗаписи.Следующий();
		JV = ВыборкаДетальныеЗаписи.РучнаяКорректировка;
	Иначе
		РучнаяКорректировкаОбъект = Документы.РучнаяКорректировка.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(РучнаяКорректировкаОбъект, ЭтотОбъект, "Account,AU,Company,Currency");
		РучнаяКорректировкаОбъект.Дата = ДатаКорректировки;
		РучнаяКорректировкаОбъект.Source = РеквизитыТранзакции.Source;
		РучнаяКорректировкаОбъект.Client = Клиент;
		//найти в меппинге клиента и сделать исключение, если клиент не найден
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Период) КАК Период
			|ПОМЕСТИТЬ Mapping_МаксПериод
			|ИЗ
			|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
			|			,
			|			ОбъектПриемника = &ОбъектПриемника
			|				И ТипОбъектаВнешнейСистемы = &ТипОбъектаВнешнейСистемы
			|				И ТипСоответствия = &ТипСоответствия) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор
			|ИЗ
			|	Mapping_МаксПериод КАК Mapping_МаксПериод
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
			|				,
			|				ОбъектПриемника = &ОбъектПриемника
			|					И ТипОбъектаВнешнейСистемы = &ТипОбъектаВнешнейСистемы
			|					И ТипСоответствия = &ТипСоответствия) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
			|		ПО Mapping_МаксПериод.Период = НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Период";
		
		Запрос.УстановитьПараметр("ОбъектПриемника", Клиент);
		Запрос.УстановитьПараметр("ТипСоответствия", РеквизитыТранзакции.Source);
		Запрос.УстановитьПараметр("ТипОбъектаВнешнейСистемы", Перечисления.ТипыОбъектовВнешнихСистем.Client);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("The client " + Клиент +" does not have a match in Mapping",,,,Отказ);
		Иначе
			ВыборкаДетальныеЗаписи.Следующий();
			Если НЕ Клиент.Предопределенный Тогда
				РучнаяКорректировкаОбъект.ClientID = ВыборкаДетальныеЗаписи.Идентификатор;
			КонецЕсли;
		КонецЕсли;
		РучнаяКорректировкаОбъект.Записать();
		JV = РучнаяКорректировкаОбъект.Ссылка;
	КонецЕсли;
	
	Возврат JV;
	
КонецФункции

Процедура ПроверитьMappingКлиентов(Отказ, Source)
	
	КлиентыКорректировки = ДетализацияПоКлиенту.ВыгрузитьКолонку("Client");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника КАК Client
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника В(&СписокКлиентов)
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = &ТипСоответствия
		|
		|СГРУППИРОВАТЬ ПО
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника";
	
	Запрос.УстановитьПараметр("СписокКлиентов", КлиентыКорректировки);
	Запрос.УстановитьПараметр("ТипСоответствия", Source);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТЗ_Клиенты = РезультатЗапроса.Выгрузить();
	
	КлиентыСMapping = ТЗ_Клиенты.ВыгрузитьКолонку("Client");
	
	КлиентыБезMapping = ОбщегоНазначенияКлиентСервер.СократитьМассив(КлиентыКорректировки, КлиентыСMapping);
	
	Если КлиентыБезMapping.Количество() > 0 Тогда
		Для каждого ЭлементМассива Из КлиентыБезMapping Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("The client " + ЭлементМассива +" does not have a match in Mapping",,,,Отказ);
		КонецЦикла;
	КонецЕсли;
	
	//Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	//	
	//	Если ВыборкаДетальныеЗаписи.НаличиеMapping < 1 Тогда
	//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("The client " + ВыборкаДетальныеЗаписи.Клиент +" does not have a match in Mapping",,,,Отказ);
	//	КонецЕсли;
	//	
	//КонецЦикла;

	
КонецПроцедуры

Процедура ОтметитьВыполнениеЗадачи()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачаИсполнителя.Ссылка КАК Ссылка
		|ИЗ
		|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
		|ГДЕ
		|	ЗадачаИсполнителя.Предмет = &Предмет
		|	И НЕ ЗадачаИсполнителя.Выполнена
		|	И НЕ ЗадачаИсполнителя.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Предмет", ДокументОснование);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() > 0 Тогда
		 ВыборкаДетальныеЗаписи.Следующий();
		 ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
		 ЗадачаОбъект.Выполнена = Истина;
		 ЗадачаОбъект.Записать();
	КонецЕсли;
	
КонецПроцедуры

#КонецЕсли
