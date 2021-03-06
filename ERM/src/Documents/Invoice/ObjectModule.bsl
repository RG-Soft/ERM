#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Не ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("СтарыеЗначенияКлючей", ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Номер, Company,Source"));
	КонецЕсли;
	
	Если Source = Перечисления.ТипыСоответствий.HOBs Тогда
		Если ЭтоНовый() Тогда
			УстановитьНовыйНомер("HB");
		КонецЕсли;
		РеквизитыИнвойса = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Company,LegalEntity");
		Если НЕ РегистрыСведений.ДатыDIRИзГИС.ЗаписьЕстьВРегистре(РеквизитыИнвойса) Тогда
			Даты = Новый Соответствие();
			Даты.Вставить("JobEndDate", ?(ЗначениеЗаполнено(ФактическаяДатаРеализации),ФактическаяДатаРеализации,Дата));
			РегистрыСведений.DIR.ЗаписатьДаты(Ссылка, Даты);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("СтарыеЗначенияКлючей") Тогда
		
		СтарыеЗначенияКлючей = ДополнительныеСвойства.СтарыеЗначенияКлючей;
		Если СтарыеЗначенияКлючей.Номер <> Номер
			ИЛИ СтарыеЗначенияКлючей.Company <> Company Тогда
			
			НЗ = РегистрыСведений.КлючиИнвойсов.СоздатьНаборЗаписей();
			НЗ.Отбор.ArInvoice.Установить(СтарыеЗначенияКлючей.Номер);
			НЗ.Отбор.Company.Установить(СтарыеЗначенияКлючей.Company);
			НЗ.Отбор.Source.Установить(СтарыеЗначенияКлючей.Source);
			НЗ.Записать(Истина);
			
			НЗ.Отбор.ArInvoice.Установить(Номер);
			НЗ.Отбор.Company.Установить(Company);
			НЗ.Отбор.Source.Установить(Source);
			ЗаписьНабора = НЗ.Добавить();
			ЗаписьНабора.ArInvoice = Номер;
			ЗаписьНабора.Company = Company;
			ЗаписьНабора.Source = Source;
			ЗаписьНабора.Invoice = Ссылка;
			НЗ.Записать(Истина);
			
		КонецЕсли;
		
	Иначе
		
		НЗ = РегистрыСведений.КлючиИнвойсов.СоздатьНаборЗаписей();
		НЗ.Отбор.ArInvoice.Установить(Номер);
		НЗ.Отбор.Company.Установить(Company);
		НЗ.Отбор.Source.Установить(Source);
		ЗаписьНабора = НЗ.Добавить();
		ЗаписьНабора.ArInvoice = Номер;
		ЗаписьНабора.Company = Company;
		ЗаписьНабора.Source = Source;
		ЗаписьНабора.Invoice = Ссылка;
		НЗ.Записать(Истина);
		
	КонецЕсли;
	
	ЗаполнятьИзДатаОкончания = ЗначениеЗаполнено(ОтчетныйПериод_ДатаОкончания) И Дата >= Дата(2020, 1, 1); 
	
	Если Source = Перечисления.ТипыСоответствий.OracleMI И ЗаполнятьИзДатаОкончания Тогда
		
		Даты = Новый Соответствие();
		Даты.Вставить("JobEndDate", ОтчетныйПериод_ДатаОкончания);
		Даты.Вставить("FTLSubmissionDate", ShipDateActual);
		РегистрыСведений.DIR.ЗаписатьДаты(Ссылка, Даты);
		
	ИначеЕсли Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
		
		JobEndDate = ?(ЗаполнятьИзДатаОкончания, ОтчетныйПериод_ДатаОкончания, ФактическаяДатаРеализации);
		
		//Alm Перенесено ниже, так как для MI тоже надо
		//// { RGS AGorlenko 02.03.2020 19:44:37 - S-E-0001475-В случае, если для Oracle Smith Геомаркет KZU, AZE или TKG, Job end date Заполняется из даты инвойса
		//Если JobEndDate = Дата(1,1,1) Тогда
		//	МассивГеомаркетовСАвтозаполнениемJEDИзДатыИнвойса = ПланыВидовХарактеристик.rgsСпискиОпределяемыеДляОбъектов.ПолучитьМассивЭлементовПоТипуСписка(ПланыВидовХарактеристик.rgsСпискиОпределяемыеДляОбъектов.ГеомаркетыСАвтозаполнениемJEDИзДатыИнвойса);
		//	Если Не МассивГеомаркетовСАвтозаполнениемJEDИзДатыИнвойса.Найти(AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket) = Неопределено Тогда
		//		JobEndDate = Дата;
		//	КонецЕсли;
		//КонецЕсли;
		//// } RGS AGorlenko 02.03.2020 19:46:09 - S-E-0001475-В случае, если для Oracle Smith Геомаркет KZU, AZE или TKG, Job end date Заполняется из даты инвойса
		
		Если JobEndDate <> Дата(1,1,1) Тогда
			Даты = Новый Соответствие();
			Даты.Вставить("JobEndDate", JobEndDate);
			РегистрыСведений.DIR.ЗаписатьДаты(Ссылка, Даты);
		КонецЕсли;
			
	КонецЕсли;
	
	// { RGS AGorlenko 02.03.2020 19:44:37 - S-E-0001475-В случае, если для Oracle Геомаркет KZU, AZE или TKG, Job end date Заполняется из даты инвойса
	Если Source = Перечисления.ТипыСоответствий.OracleSmith ИЛИ Source = Перечисления.ТипыСоответствий.OracleMI Тогда
		МассивГеомаркетовСАвтозаполнениемJEDИзДатыИнвойса = ПланыВидовХарактеристик.rgsСпискиОпределяемыеДляОбъектов.ПолучитьМассивЭлементовПоТипуСписка(ПланыВидовХарактеристик.rgsСпискиОпределяемыеДляОбъектов.ГеомаркетыСАвтозаполнениемJEDИзДатыИнвойса);
		Если МассивГеомаркетовСАвтозаполнениемJEDИзДатыИнвойса.Найти(AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket) <> Неопределено Тогда
			Даты = Новый Соответствие();
			Даты.Вставить("JobEndDate", Дата);
			РегистрыСведений.DIR.ЗаписатьДаты(Ссылка, Даты);
		КонецЕсли;
	КонецЕсли;
	// } RGS AGorlenko 02.03.2020 19:46:09 - S-E-0001475-В случае, если для Oracle Геомаркет KZU, AZE или TKG, Job end date Заполняется из даты инвойса
	
	// { RGS AGorlenko 04.03.2020 14:38:45 - // } RGS AGorlenko1 04.03.2020 14:38:01 - S-E-0001469- Расчет и запись DateFrom и DateTo
	Если ЗначениеЗаполнено(Contract) Тогда
		//Запись данных в регистр дат для Collection target
		СтруктураДанныхКонтракта = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Contract, "PTDaysFrom, СрокОплаты, PTType, Trigger");
				
		Если ЗначениеЗаполнено(СтруктураДанныхКонтракта.Trigger) Тогда
			
			Если НЕ ЭтоНовый() Тогда
				
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
				               |	InvoiceCommentsСрезПоследних.Invoice КАК Invoice
				               |ИЗ
				               |	РегистрСведений.InvoiceComments.СрезПоследних(
				               |			&Период,
				               |			Invoice = &Ссылка
				               |				И НЕ Inactive) КАК InvoiceCommentsСрезПоследних
				               |ГДЕ
				               |	НЕ InvoiceCommentsСрезПоследних.Problem.TriggerDate = ДАТАВРЕМЯ(1, 1, 1)";
				Запрос.УстановитьПараметр("Период", ТекущаяДата());
				Запрос.УстановитьПараметр("Ссылка", Ссылка);
				РезультатЗапроса = Запрос.Выполнить();
				ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
				
				Если ВыборкаДетальныеЗаписи.Количество() = 0 Тогда
					
					Документы.Invoice.ЗаписатьДатыДляCollectionTargetПоИнвойсу(Ссылка, СтруктураДанныхКонтракта);
					
				КонецЕсли;
				
			Иначе
				
				Документы.Invoice.ЗаписатьДатыДляCollectionTargetПоИнвойсу(Ссылка, СтруктураДанныхКонтракта);
				
			КонецЕсли;
			
		КонецЕсли;
			
		Если Не ОбменДанными.Загрузка Тогда
				//Заполнение данных в самом инвойсе
				Если ЗначениеЗаполнено(TriggerDate) Тогда
					
					СтруктураДатДляИнвойса = Документы.Invoice.РассчитатьDateFromИDateTo(Ссылка, СтруктураДанныхКонтракта, TriggerDate);
					
					DueDateFrom = СтруктураДатДляИнвойса.DateFrom;
					DueDateTo = СтруктураДатДляИнвойса.DateTo;
					
				КонецЕсли;
		
		КонецЕсли;
	КонецЕсли;
	// } RGS AGorlenko 04.03.2020 14:39:46 - // } RGS AGorlenko1 04.03.2020 14:38:01 - S-E-0001469- Расчет и запись DateFrom и DateTo
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	НЗ = РегистрыСведений.КлючиИнвойсов.СоздатьНаборЗаписей();
	НЗ.Отбор.ArInvoice.Установить(Номер);
	НЗ.Отбор.Company.Установить(Company);
	НЗ.Отбор.Source.Установить(Source);
	НЗ.Записать(Истина);
	
КонецПроцедуры

#КонецЕсли