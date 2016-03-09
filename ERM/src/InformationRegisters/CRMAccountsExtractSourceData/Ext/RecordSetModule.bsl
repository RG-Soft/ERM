
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого ТекЗапись Из ЭтотОбъект Цикл
		ТекЗапись.AccountId = СокрЛП(ТекЗапись.AccountId);
		ТекЗапись.Account = СокрЛП(ТекЗапись.Account);
		ТекЗапись.IntegrationId = СокрЛП(ТекЗапись.IntegrationId);
		ТекЗапись.CorporateAccount = СокрЛП(ТекЗапись.CorporateAccount);
		ТекЗапись.CorporateAccountId = СокрЛП(ТекЗапись.CorporateAccountId);
		ТекЗапись.MIIntegrationId = СокрЛП(ТекЗапись.MIIntegrationId);
		ТекЗапись.SMITHIntegrationId = СокрЛП(ТекЗапись.SMITHIntegrationId);
		ТекЗапись.LawsonIntegrationId = ?(Лев(ТекЗапись.IntegrationId, 4) = "OFS_", Прав(ТекЗапись.IntegrationId, СтрДлина(ТекЗапись.IntegrationId) - 4), ТекЗапись.IntegrationId);
	КонецЦикла;
	
КонецПроцедуры
