﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗаполнитьДанныеПоБиллингу(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	
	ДанныеПоБиллингу = Новый Структура;
	ДанныеПоБиллингу.Вставить("LawsonBilling", РассчитатьLawsonBilling(СтруктураПараметров));
	ДанныеПоБиллингу.Вставить("HOBBilling", РассчитатьHOBBilling(СтруктураПараметров));
	
	ДанныеДляЗаполнения.Вставить("ДанныеПоБиллингу", ДанныеПоБиллингу);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция РассчитатьLawsonBilling(СтруктураПараметров)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроводкаDSS.Company,
		|	ПроводкаDSS.LegalEntity,
		|	ПроводкаDSS.AU,
		|	ПроводкаDSS.КонтрагентLawson КАК Client,
		|	ПроводкаDSS.Currency,
		|	СУММА(ПроводкаDSS.TranAmount) КАК Amount
		|ПОМЕСТИТЬ ВТ_ДанныеТранзакций
		|ИЗ
		|	Документ.ПроводкаDSS КАК ПроводкаDSS
		|ГДЕ
		|	ПроводкаDSS.Проведен
		|	И ПроводкаDSS.AccountingPeriod >= &НачалоПериода
		|	И ПроводкаDSS.AccountingPeriod <= &КонецПериода
		|	И (ПроводкаDSS.AccountLawson = &Счет120101
		|				И (ПроводкаDSS.System = ""AR""
		|						И ПроводкаDSS.SourceCode В (""SA"", ""DM"", ""CM"", ""RI"", ""RM"")
		|					ИЛИ ПроводкаDSS.System = ""BL""
		|						И ПроводкаDSS.SourceCode В (""SA"", ""DM"", ""CM"", ""RI"", ""RM""))
		|			ИЛИ ПроводкаDSS.AccountLawson = &Счет120104
		|				И (ПроводкаDSS.System = ""AR""
		|						И ПроводкаDSS.SourceCode В (""RI"", ""RM"")
		|					ИЛИ ПроводкаDSS.System = ""BL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""CM"", ""DM"")
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3""))
		|			ИЛИ ПроводкаDSS.AccountLawson = &Счет120201
		|				И (ПроводкаDSS.System = ""BL""
		|						И ПроводкаDSS.SourceCode В (""JE"")
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3""))
		|			ИЛИ ПроводкаDSS.AccountLawson = &Счет120205
		|				И (ПроводкаDSS.System = ""BL""
		|						И ПроводкаDSS.SourceCode В (""JE"")
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3""))
		|			ИЛИ ПроводкаDSS.AccountLawson = &Счет120206
		|				И (ПроводкаDSS.System = ""AR""
		|						И ПроводкаDSS.SourceCode В (""RI"", ""RM"")
		|					ИЛИ ПроводкаDSS.System = ""BL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""CM"", ""DM"")
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3"")))
		|
		|СГРУППИРОВАТЬ ПО
		|	ПроводкаDSS.Company,
		|	ПроводкаDSS.LegalEntity,
		|	ПроводкаDSS.AU,
		|	ПроводкаDSS.КонтрагентLawson,
		|	ПроводкаDSS.Currency
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеТранзакций.Company,
		|	ВТ_ДанныеТранзакций.LegalEntity,
		|	ВТ_ДанныеТранзакций.AU,
		|	ВТ_ДанныеТранзакций.Client,
		|	ВТ_ДанныеТранзакций.Currency,
		|	ВТ_ДанныеТранзакций.Amount,
		|	ВТ_ДанныеТранзакций.Amount / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК USDAmount
		|ИЗ
		|	ВТ_ДанныеТранзакций КАК ВТ_ДанныеТранзакций,
		|	РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(
		|			&КонецПериода,
		|			Валюта В
		|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|					ВТ_ДанныеТранзакций.Currency
		|				ИЗ
		|					ВТ_ДанныеТранзакций КАК ВТ_ДанныеТранзакций)) КАК ВнутренниеКурсыВалютСрезПоследних";
	
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(СтруктураПараметров.Дата));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(СтруктураПараметров.Дата));
	Запрос.УстановитьПараметр("Счет120101", ПланыСчетов.Lawson.НайтиПоКоду("120101"));
	Запрос.УстановитьПараметр("Счет120104", ПланыСчетов.Lawson.НайтиПоКоду("120104"));
	Запрос.УстановитьПараметр("Счет120201", ПланыСчетов.Lawson.НайтиПоКоду("120201"));
	Запрос.УстановитьПараметр("Счет120205", ПланыСчетов.Lawson.НайтиПоКоду("120205"));
	Запрос.УстановитьПараметр("Счет120206", ПланыСчетов.Lawson.НайтиПоКоду("120206"));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

Функция РассчитатьHOBBilling(СтруктураПараметров)
	
КонецФункции

#КонецЕсли