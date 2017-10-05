﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
	
	ТЗ_LawsonBilling = LawsonBilling.Выгрузить(, "Company, LegalEntity, AU, Client, USDAmount");
	ТЗ_LawsonBilling.Свернуть("Company, LegalEntity, AU, Client", "USDAmount");
	
	Для каждого СтрокаТЧ Из ТЗ_LawsonBilling Цикл
		
		НовоеДвижение = ДвиженияБиллинг.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, СтрокаТЧ);
		НовоеДвижение.Период = НачалоМесяца(Дата);
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.Lawson;
		
	КонецЦикла;
	
	ТЗ_HOBBilling = HOBBilling.Выгрузить(, "Company, LegalEntity, AU, Client, USDAmount");
	ТЗ_HOBBilling.Свернуть("Company, LegalEntity, AU, Client", "USDAmount");
	
	Для каждого СтрокаТЧ Из ТЗ_HOBBilling Цикл
		
		НовоеДвижение = ДвиженияБиллинг.Добавить();
		ЗаполнитьЗначенияСвойств(НовоеДвижение, СтрокаТЧ);
		НовоеДвижение.Период = НачалоМесяца(Дата);
		НовоеДвижение.Source = Перечисления.ТипыСоответствий.HOBs;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецЕсли