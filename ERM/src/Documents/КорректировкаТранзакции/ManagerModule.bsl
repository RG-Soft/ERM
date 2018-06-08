
Функция ПолучитьРеквизитыТранзакции(Документ, Отказ = Ложь) Экспорт
	
	ВалютаUSD = Константы.rgsВалютаUSD.Получить();
	СчетВыручкиHFM = rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня");
	
	ЗначенияРеквизитовТранзакции = Новый Структура("Source, Company, Location, Account, HFMAccount, SubSubSegment, Currency, AU, Client , LegalEntity,Amount, BaseAmount, ПометкаУдаления, Дата, System, SourceCode");
	Если ТипЗнч(Документ) = Тип("ДокументСсылка.ПроводкаDSS") Тогда
		ЗначенияРеквизитовDSS = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Company, Location, AccountLawson, SubSubSegment, Currency, AU, КонтрагентLawson , LegalEntity, BaseAmount, TranAmount, AccountingPeriod, System, SourceCode");
		ЗначенияРеквизитовТранзакции.ПометкаУдаления = Документ.ПометкаУдаления;
		ЗначенияРеквизитовТранзакции.Source = Перечисления.ТипыСоответствий.Lawson;
		ЗначенияРеквизитовТранзакции.Client = ЗначенияРеквизитовDSS.КонтрагентLawson;
		ЗначенияРеквизитовТранзакции.Account = ЗначенияРеквизитовDSS.AccountLawson;
		ЗначенияРеквизитовТранзакции.HFMAccount = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначенияРеквизитовDSS.AccountLawson, "БазовыйЭлемент");
		ЗначенияРеквизитовТранзакции.Company = ЗначенияРеквизитовDSS.Company;
		ЗначенияРеквизитовТранзакции.Location = ЗначенияРеквизитовDSS.Location;
		ЗначенияРеквизитовТранзакции.SubSubSegment = ЗначенияРеквизитовDSS.SubSubSegment;
		ЗначенияРеквизитовТранзакции.Currency = ЗначенияРеквизитовDSS.Currency;
		ЗначенияРеквизитовТранзакции.AU = ЗначенияРеквизитовDSS.AU;
		ЗначенияРеквизитовТранзакции.LegalEntity = ЗначенияРеквизитовDSS.LegalEntity;
		ЗначенияРеквизитовТранзакции.Дата = ЗначенияРеквизитовDSS.AccountingPeriod;
		ЗначенияРеквизитовТранзакции.Amount = ЗначенияРеквизитовDSS.TranAmount;
		ЗначенияРеквизитовТранзакции.BaseAmount = ЗначенияРеквизитовDSS.BaseAmount;
		ПараметрыПроведения = Документы.ПроводкаDSS.ПодготовитьПараметрыПроведения(Документ, Отказ);
		СуммыДляПроводки = Документы.ПроводкаDSS.ПолучитьСуммыДляПроводки(ЗначенияРеквизитовТранзакции, ПараметрыПроведения.СвязанныеДокументы, СчетВыручкиHFM, ВалютаUSD, Отказ);
		ЗначенияРеквизитовТранзакции.Amount = СуммыДляПроводки.Amount;
		ЗначенияРеквизитовТранзакции.System = ЗначенияРеквизитовDSS.System;
		ЗначенияРеквизитовТранзакции.SourceCode = ЗначенияРеквизитовDSS.SourceCode;
		ЗначенияРеквизитовТранзакции.BaseAmount = СуммыДляПроводки.BaseAmount;
	ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ТранзакцияHOB") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Company, Location, Account, SubSubSegment, Currency, AU, Client , LegalEntity, Amount, BaseAmount, Дата, MNGC");
		ЗначенияРеквизитовТранзакции.ПометкаУдаления = Документ.ПометкаУдаления;
		ЗначенияРеквизитовТранзакции.Source = Перечисления.ТипыСоответствий.HOBs;
		ЗначенияРеквизитовТранзакции.Client = ЗначенияРеквизитов.Client;
		ЗначенияРеквизитовТранзакции.Account = ЗначенияРеквизитов.Account;
		ЗначенияРеквизитовТранзакции.HFMAccount = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначенияРеквизитов.Account, "БазовыйЭлемент");
		ЗначенияРеквизитовТранзакции.Company = ЗначенияРеквизитов.Company;
		Если ЗначениеЗаполнено(ЗначенияРеквизитов.MNGC) Тогда
			ЗначенияРеквизитовТранзакции.Location = ЗначенияРеквизитов.MNGC;
		Иначе
			ЗначенияРеквизитовТранзакции.Location = ЗначенияРеквизитов.Location;
		КонецЕсли;
		ЗначенияРеквизитовТранзакции.SubSubSegment = ЗначенияРеквизитов.SubSubSegment;
		ЗначенияРеквизитовТранзакции.Currency = ЗначенияРеквизитов.Currency ;
		ЗначенияРеквизитовТранзакции.AU = ЗначенияРеквизитов.AU;
		ЗначенияРеквизитовТранзакции.LegalEntity = ЗначенияРеквизитов.LegalEntity;
		ЗначенияРеквизитовТранзакции.Дата = ЗначенияРеквизитов.Дата;
		ЗначенияРеквизитовТранзакции.Amount = ЗначенияРеквизитов.Amount;
		ЗначенияРеквизитовТранзакции.BaseAmount = ЗначенияРеквизитов.BaseAmount;
		СуммыДляПроводки = Документы.ТранзакцияHOB.ПолучитьСуммыДляПроводки(ЗначенияРеквизитовТранзакции, СчетВыручкиHFM, ВалютаUSD, Отказ);
		ЗначенияРеквизитовТранзакции.Amount = СуммыДляПроводки.Amount;
		ЗначенияРеквизитовТранзакции.BaseAmount = СуммыДляПроводки.BaseAmount;
	Иначе
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Документ, "Source, Company,  AU, Location, Account, SubSubSegment, Currency, Client , LegalEntity, Amount, BaseAmount, Дата");
		ЗначенияРеквизитовТранзакции.ПометкаУдаления = Документ.ПометкаУдаления;
		ЗначенияРеквизитовТранзакции.Source = ЗначенияРеквизитов.Source;
		ЗначенияРеквизитовТранзакции.Client = ЗначенияРеквизитов.Client;
		ЗначенияРеквизитовТранзакции.Account = ЗначенияРеквизитов.Account;
		ЗначенияРеквизитовТранзакции.HFMAccount = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗначенияРеквизитов.Account, "БазовыйЭлемент");
		ЗначенияРеквизитовТранзакции.Company = ЗначенияРеквизитов.Company;
		ЗначенияРеквизитовТранзакции.AU = ЗначенияРеквизитов.AU;
		ЗначенияРеквизитовТранзакции.Location = ЗначенияРеквизитов.Location;
		ЗначенияРеквизитовТранзакции.SubSubSegment = ЗначенияРеквизитов.SubSubSegment;
		ЗначенияРеквизитовТранзакции.Currency = ЗначенияРеквизитов.Currency ;
		ЗначенияРеквизитовТранзакции.LegalEntity = ЗначенияРеквизитов.LegalEntity;
		ЗначенияРеквизитовТранзакции.Дата = ЗначенияРеквизитов.Дата;
		ЗначенияРеквизитовТранзакции.Amount = ЗначенияРеквизитов.Amount;
		ЗначенияРеквизитовТранзакции.BaseAmount = ЗначенияРеквизитов.BaseAmount;
		СуммыДляПроводки = Документы.ТранзакцияOracle.ПолучитьСуммыДляПроводки(ЗначенияРеквизитовТранзакции, СчетВыручкиHFM, ВалютаUSD, Отказ);
		ЗначенияРеквизитовТранзакции.Amount = СуммыДляПроводки.Amount;
		ЗначенияРеквизитовТранзакции.BaseAmount = СуммыДляПроводки.BaseAmount;
	КонецЕсли;

	Возврат ЗначенияРеквизитовТранзакции;
		
КонецФункции
