
Функция РассчитатьDSO(AR, Период, Billing0, Billing1, Billing2, Billing3, Billing4,
	Billing5, Billing6, Billing7, Billing8, Billing9, Billing10, Billing11, Billing12,
	Billing13, Billing14, Billing15, Billing16, Billing17, Billing18, Billing19, Billing20,
	Billing21, Billing22, Billing23, Billing24) Экспорт
	
	Если AR = Null Или AR <= 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	DSO = 0;
	ОстатокAR = AR;
	Биллинг = Новый Массив;
	Биллинг.Добавить(Billing0);
	Биллинг.Добавить(Billing1);
	Биллинг.Добавить(Billing2);
	Биллинг.Добавить(Billing3);
	Биллинг.Добавить(Billing4);
	Биллинг.Добавить(Billing5);
	Биллинг.Добавить(Billing6);
	Биллинг.Добавить(Billing7);
	Биллинг.Добавить(Billing8);
	Биллинг.Добавить(Billing9);
	Биллинг.Добавить(Billing10);
	Биллинг.Добавить(Billing11);
	Биллинг.Добавить(Billing12);
	Биллинг.Добавить(Billing13);
	Биллинг.Добавить(Billing14);
	Биллинг.Добавить(Billing15);
	Биллинг.Добавить(Billing16);
	Биллинг.Добавить(Billing17);
	Биллинг.Добавить(Billing18);
	Биллинг.Добавить(Billing19);
	Биллинг.Добавить(Billing20);
	Биллинг.Добавить(Billing21);
	Биллинг.Добавить(Billing22);
	Биллинг.Добавить(Billing23);
	Биллинг.Добавить(Billing24);
	
	Для ИндексПоказателя  = 0 По 24 Цикл
		
		ТекущийПоказатель = Биллинг[ИндексПоказателя];
		КоличествоДнейМесяца = День(КонецМесяца(ДобавитьМесяц(КонецМесяца(Период), -ИндексПоказателя)));
		
		Если ОстатокAR <= ТекущийПоказатель Тогда
			DSO = DSO + Окр((ОстатокAR / ТекущийПоказатель) * КоличествоДнейМесяца, 2);
			Возврат DSO;
		Иначе
			DSO = DSO + КоличествоДнейМесяца;
			ОстатокAR = ОстатокAR - ТекущийПоказатель;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат DSO;
	
КонецФункции

Функция ПолучитьМаксимальноеЗначениеARиBillingПоМодулю(AR, Billing0, Billing1, Billing2, Billing3, Billing4,
	Billing5, Billing6, Billing7, Billing8, Billing9, Billing10, Billing11, Billing12, Billing13, Billing14,
	Billing15, Billing16, Billing17, Billing18, Billing19, Billing20, Billing21, Billing22, Billing23, Billing24) Экспорт
	
	ARМодуль = ?(AR >= 0, AR, -AR);
	Billing0Модуль = ?(Billing0 >= 0, Billing0, -Billing0);
	Billing1Модуль = ?(Billing1 >= 0, Billing1, -Billing1);
	Billing2Модуль = ?(Billing2 >= 0, Billing2, -Billing2);
	Billing3Модуль = ?(Billing3 >= 0, Billing3, -Billing3);
	Billing4Модуль = ?(Billing4 >= 0, Billing4, -Billing4);
	Billing5Модуль = ?(Billing5 >= 0, Billing5, -Billing5);
	Billing6Модуль = ?(Billing6 >= 0, Billing6, -Billing6);
	Billing7Модуль = ?(Billing7 >= 0, Billing7, -Billing7);
	Billing8Модуль = ?(Billing8 >= 0, Billing8, -Billing8);
	Billing9Модуль = ?(Billing9 >= 0, Billing9, -Billing9);
	Billing10Модуль = ?(Billing10 >= 0, Billing10, -Billing10);
	Billing11Модуль = ?(Billing11 >= 0, Billing11, -Billing11);
	Billing12Модуль = ?(Billing12 >= 0, Billing12, -Billing12);
	Billing13Модуль = ?(Billing13 >= 0, Billing13, -Billing13);
	Billing14Модуль = ?(Billing14 >= 0, Billing14, -Billing14);
	Billing15Модуль = ?(Billing15 >= 0, Billing15, -Billing15);
	Billing16Модуль = ?(Billing16 >= 0, Billing16, -Billing16);
	Billing17Модуль = ?(Billing17 >= 0, Billing17, -Billing17);
	Billing18Модуль = ?(Billing18 >= 0, Billing18, -Billing18);
	Billing19Модуль = ?(Billing19 >= 0, Billing19, -Billing19);
	Billing20Модуль = ?(Billing20 >= 0, Billing20, -Billing20);
	Billing21Модуль = ?(Billing21 >= 0, Billing21, -Billing21);
	Billing22Модуль = ?(Billing22 >= 0, Billing22, -Billing22);
	Billing23Модуль = ?(Billing23 >= 0, Billing23, -Billing23);
	Billing24Модуль = ?(Billing24 >= 0, Billing24, -Billing24);
	
	МаксимальноеЗначение = Макс(ARМодуль, Billing0Модуль, Billing1Модуль, Billing2Модуль, Billing3Модуль, Billing4Модуль,
		Billing5Модуль, Billing6Модуль, Billing7Модуль, Billing8Модуль, Billing9Модуль, Billing10Модуль, Billing11Модуль, 
		Billing12Модуль, Billing13Модуль, Billing14Модуль, Billing15Модуль, Billing16Модуль, Billing17Модуль, Billing18Модуль, 
		Billing19Модуль, Billing20Модуль, Billing21Модуль, Billing22Модуль, Billing23Модуль, Billing24Модуль);
	
	Возврат МаксимальноеЗначение;
	
КонецФункции