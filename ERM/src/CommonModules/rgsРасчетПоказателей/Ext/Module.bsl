﻿
Функция РассчитатьDSO(AR, Период, Billing0, Billing1, Billing2, Billing3, Billing4,
	Billing5, Billing6, Billing7, Billing8, Billing9, Billing10, Billing11, Billing12,
	Billing13, Billing14, Billing15, Billing16, Billing17, Billing18, Billing19, Billing20,
	Billing21, Billing22, Billing23, Billing24) Экспорт
	
	Если AR <= 0 Тогда
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
		КоличествоДнейМесяца = День(ДобавитьМесяц(КонецМесяца(Период), -ИндексПоказателя));
		
		Если ОстатокAR <= ТекущийПоказатель Тогда
			DSO = DSO + (ОстатокAR / ТекущийПоказатель) * КоличествоДнейМесяца;
			Возврат DSO;
		Иначе
			DSO = DSO + КоличествоДнейМесяца;
			ОстатокAR = ОстатокAR - ТекущийПоказатель;
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат DSO;
	
КонецФункции
