
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	//Если Не ЭтоНовый() Тогда
	//	ДополнительныеСвойства.Вставить("СтарыеЗначенияКлючей", ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
	//		"Source, Company, Client, Location, SubSubSegment, AU, Account, Currency, Prepayment"));
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	//Если ДополнительныеСвойства.Свойство("СтарыеЗначенияКлючей") Тогда
	//	
	//	СтарыеЗначенияКлючей = ДополнительныеСвойства.СтарыеЗначенияКлючей;
	//	Если СтарыеЗначенияКлючей.Source <> Source ИЛИ СтарыеЗначенияКлючей.Company <> Company
	//		ИЛИ СтарыеЗначенияКлючей.Client <> Client ИЛИ СтарыеЗначенияКлючей.Location <> Location
	//		ИЛИ СтарыеЗначенияКлючей.SubSubSegment <> SubSubSegment
	//		ИЛИ СтарыеЗначенияКлючей.AU <> AU ИЛИ СтарыеЗначенияКлючей.Account <> Account
	//		ИЛИ СтарыеЗначенияКлючей.Currency <> Currency ИЛИ СтарыеЗначенияКлючей.Prepayment <> Prepayment Тогда
	//		
	//		НЗ = РегистрыСведений.КлючиCashBatch.СоздатьНаборЗаписей();
	//		НЗ.Отбор.Source.Установить(СтарыеЗначенияКлючей.Source);
	//		НЗ.Отбор.Company.Установить(СтарыеЗначенияКлючей.Company);
	//		НЗ.Отбор.Client.Установить(СтарыеЗначенияКлючей.Client);
	//		НЗ.Отбор.Location.Установить(СтарыеЗначенияКлючей.Location);
	//		НЗ.Отбор.SubSubSegment.Установить(СтарыеЗначенияКлючей.SubSubSegment);
	//		НЗ.Отбор.AU.Установить(СтарыеЗначенияКлючей.AU);
	//		НЗ.Отбор.Account.Установить(СтарыеЗначенияКлючей.Account);
	//		НЗ.Отбор.Currency.Установить(СтарыеЗначенияКлючей.Currency);
	//		НЗ.Отбор.Prepayment.Установить(СтарыеЗначенияКлючей.Prepayment);
	//		НЗ.Записать(Истина);
	//		
	//		НЗ.Отбор.Source.Установить(Source);
	//		НЗ.Отбор.Company.Установить(Company);
	//		НЗ.Отбор.Client.Установить(Client);
	//		НЗ.Отбор.Location.Установить(Location);
	//		НЗ.Отбор.SubSubSegment.Установить(SubSubSegment);
	//		НЗ.Отбор.AU.Установить(AU);
	//		НЗ.Отбор.Account.Установить(Account);
	//		НЗ.Отбор.Currency.Установить(Currency);
	//		НЗ.Отбор.Prepayment.Установить(Prepayment);
	//		ЗаписьНабора = НЗ.Добавить();
	//		ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЭтотОбъект);
	//		ЗаписьНабора.CashBatch = Ссылка;
	//		НЗ.Записать(Истина);
	//		
	//	КонецЕсли;
	//	
	//Иначе
	//	
	//	НЗ = РегистрыСведений.КлючиCashBatch.СоздатьНаборЗаписей();
	//	НЗ.Отбор.Source.Установить(Source);
	//	НЗ.Отбор.Company.Установить(Company);
	//	НЗ.Отбор.Client.Установить(Client);
	//	НЗ.Отбор.Location.Установить(Location);
	//	НЗ.Отбор.SubSubSegment.Установить(SubSubSegment);
	//	НЗ.Отбор.AU.Установить(AU);
	//	НЗ.Отбор.Account.Установить(Account);
	//	НЗ.Отбор.Currency.Установить(Currency);
	//	НЗ.Отбор.Prepayment.Установить(Prepayment);
	//	ЗаписьНабора = НЗ.Добавить();
	//	ЗаполнитьЗначенияСвойств(ЗаписьНабора, ЭтотОбъект);
	//	ЗаписьНабора.CashBatch = Ссылка;
	//	НЗ.Записать(Истина);
	//	
	//КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	//НЗ = РегистрыСведений.КлючиCashBatch.СоздатьНаборЗаписей();
	//НЗ.Отбор.Source.Установить(Source);
	//НЗ.Отбор.Company.Установить(Company);
	//НЗ.Отбор.Client.Установить(Client);
	//НЗ.Отбор.Location.Установить(Location);
	//НЗ.Отбор.SubSubSegment.Установить(SubSubSegment);
	//НЗ.Отбор.AU.Установить(AU);
	//НЗ.Отбор.Account.Установить(Account);
	//НЗ.Отбор.Currency.Установить(Currency);
	//НЗ.Отбор.Prepayment.Установить(Prepayment);
	//НЗ.Записать(Истина);
	
КонецПроцедуры