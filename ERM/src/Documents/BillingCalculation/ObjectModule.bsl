#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() Тогда
		
		CreatedBy = Пользователи.ТекущийПользователь();
		CreationDate = ТекущаяДата();
		
	Иначе
		
		ModifiedBy = Пользователи.ТекущийПользователь();
		ModificationDate = ТекущаяДата();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	ДвиженияБиллинг = Движения.Billing;
	ДвиженияБиллинг.Записывать = Истина;
	
	ТЗ_LawsonBilling = LawsonBilling.Выгрузить(, "Company, LegalEntity, AU, Client, Currency, Method, Amount, USDAmount");
	ТЗ_LawsonBilling.Свернуть("Company, LegalEntity, AU, Client, Currency, Method", "Amount, USDAmount");
	
	Для каждого СтрокаТЧ Из ТЗ_LawsonBilling Цикл
		
		Если СтрокаТЧ.Method = Перечисления.BillingCalculationMethods.Ignore Тогда
			Продолжить;
		КонецЕсли;
		
		НовоеДвижение = ДвиженияБиллинг.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, СтрокаТЧ);
		НовоеДвижение.Период = НачалоМесяца(Дата);
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		
	КонецЦикла;
	
	ТЗ_HOBBilling = HOBBilling.Выгрузить(, "Company, LegalEntity, AU, Client, Currency, Method, Amount, USDAmount");
	ТЗ_HOBBilling.Свернуть("Company, LegalEntity, AU, Client, Currency, Method", "Amount, USDAmount");
	
	Для каждого СтрокаТЧ Из ТЗ_HOBBilling Цикл
		
		Если СтрокаТЧ.Method = Перечисления.BillingCalculationMethods.Ignore Тогда
			Продолжить;
		КонецЕсли;
			
		НовоеДвижение = ДвиженияБиллинг.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, СтрокаТЧ);
		НовоеДвижение.Период = НачалоМесяца(Дата);
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
		
	КонецЦикла;
	
	ТЗ_OracleMIBilling = OracleMIBilling.Выгрузить(, "Company, LegalEntity, AU, Client, Currency, Method, Amount, USDAmount");
	ТЗ_OracleMIBilling.Свернуть("Company, LegalEntity, AU, Client, Currency, Method", "Amount, USDAmount");
	
	Для каждого СтрокаТЧ Из ТЗ_OracleMIBilling Цикл
		
		Если СтрокаТЧ.Method = Перечисления.BillingCalculationMethods.Ignore Тогда
			Продолжить;
		КонецЕсли;
		
		НовоеДвижение = ДвиженияБиллинг.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, СтрокаТЧ);
		НовоеДвижение.Период = НачалоМесяца(Дата);
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.OracleMI;
		
	КонецЦикла;
	
	ТЗ_OracleSmithBilling = OracleSmithBilling.Выгрузить(, "Company, LegalEntity, AU, Client, Currency, Method, Amount, USDAmount");
	ТЗ_OracleSmithBilling.Свернуть("Company, LegalEntity, AU, Client, Currency, Method", "Amount, USDAmount");
	
	Для каждого СтрокаТЧ Из ТЗ_OracleSmithBilling Цикл
		
		Если СтрокаТЧ.Method = Перечисления.BillingCalculationMethods.Ignore Тогда
			Продолжить;
		КонецЕсли;
		
		НовоеДвижение = ДвиженияБиллинг.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, СтрокаТЧ);
		НовоеДвижение.Период = НачалоМесяца(Дата);
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.OracleSmith;
		
	КонецЦикла;
	
	ТЗ_RadiusBilling = RadiusBilling.Выгрузить(, "Company, LegalEntity, AU, Client, Currency, Method, Amount, USDAmount");
	ТЗ_RadiusBilling.Свернуть("Company, LegalEntity, AU, Client, Currency, Method", "Amount, USDAmount");
	
	Для каждого СтрокаТЧ Из ТЗ_RadiusBilling Цикл
		
		Если СтрокаТЧ.Method = Перечисления.BillingCalculationMethods.Ignore Тогда
			Продолжить;
		КонецЕсли;
		
		НовоеДвижение = ДвиженияБиллинг.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, СтрокаТЧ);
		НовоеДвижение.Период = НачалоМесяца(Дата);
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Radius;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли