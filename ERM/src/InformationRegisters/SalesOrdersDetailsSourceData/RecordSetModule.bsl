
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл
		ЗаписьНабора.YearMonthДата = Дата(СтрЗаменить(ЗаписьНабора.YearMonth, "/", "") + "01000000");
	КонецЦикла;
	
КонецПроцедуры