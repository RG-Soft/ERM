
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого ТекЗапись Из ЭтотОбъект Цикл
		ТекЗапись.Id = СокрЛП(ТекЗапись.Id);
		ТекЗапись.CustomerNumber = СокрЛП(ТекЗапись.CustomerNumber);
		ТекЗапись.CorporateAlias = СокрЛП(ТекЗапись.CorporateAlias);
	КонецЦикла;
	
КонецПроцедуры
