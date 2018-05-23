#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗаполнитьДанныеПоБиллингу(СтруктураПараметров, АдресХранилища) Экспорт
	
	ОбщаяТаблицаБиллинга = Перечисления.BillingCalculationMethods.ПолучитьБиллинг(НачалоМесяца(СтруктураПараметров.Дата)
		, КонецМесяца(СтруктураПараметров.Дата));
	
	ДанныеПоБиллингу = НовыеДанныеПоБиллингу();
	
	Для Каждого СтрокаТаблицыБиллинга Из ОбщаяТаблицаБиллинга Цикл
		
		Метод = rgsКонсолидацияДанныхСерверПовтИсп.ОпределитьМетодРасчетаБиллинга(СтрокаТаблицыБиллинга.Source
			, СтрокаТаблицыБиллинга.GeoMarket, СтрокаТаблицыБиллинга.Segment, СтрокаТаблицыБиллинга.SubSegment
			, СтрокаТаблицыБиллинга.SubSubSegment, СтрокаТаблицыБиллинга.Company);
			
		Если СтрокаТаблицыБиллинга.Method = Метод ИЛИ Метод = Перечисления.BillingCalculationMethods.Ignore Тогда
			
			Если СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.Lawson Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.LawsonBilling.Добавить(), СтрокаТаблицыБиллинга);
			ИначеЕсли СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.HOBs Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.HOBBilling.Добавить(), СтрокаТаблицыБиллинга);
			ИначеЕсли СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.OracleMI Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.OracleMIBilling.Добавить(), СтрокаТаблицыБиллинга);
			ИначеЕсли СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.OracleSmithBilling.Добавить(), СтрокаТаблицыБиллинга);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	ДанныеДляЗаполнения = Новый Структура();
	ДанныеДляЗаполнения.Вставить("ДанныеПоБиллингу", ДанныеПоБиллингу);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция НовыеДанныеПоБиллингу()
	
	Результат = Новый Структура();
	
	Документ = Документы.BillingCalculation.СоздатьДокумент();
	Результат.Вставить("LawsonBilling", Документ.LawsonBilling.ВыгрузитьКолонки());
	Результат.Вставить("HOBBilling", Документ.HOBBilling.ВыгрузитьКолонки());
	Результат.Вставить("OracleMIBilling", Документ.OracleMIBilling.ВыгрузитьКолонки());
	Результат.Вставить("OracleSmithBilling", Документ.OracleSmithBilling.ВыгрузитьКолонки());
	
	Возврат Результат;
	
КонецФункции

Функция РассчитатьLawsonBilling(СтруктураПараметров)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПроводкаDSS.Ссылка КАК Ссылка,
		|	ПроводкаDSS.Company КАК Company,
		|	ПроводкаDSS.LegalEntity КАК LegalEntity,
		|	ПроводкаDSS.AU КАК AU,
		|	ПроводкаDSS.КонтрагентLawson КАК Client,
		|	ПроводкаDSS.Currency КАК Currency,
		|	ПроводкаDSS.TranAmount КАК Amount
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
		|						И (ПроводкаDSS.SourceCode В (""CM"", ""DM"")
		|							ИЛИ ПроводкаDSS.SourceCode = ""JE"")
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3""))
		|			ИЛИ ПроводкаDSS.AccountLawson = &Счет120201
		|				И (ПроводкаDSS.System = ""BL""
		|						И ПроводкаDSS.SourceCode = ""JE""
		|						И ПроводкаDSS.Description = ""A/R ACCRUAL""
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3""))
		|			ИЛИ ПроводкаDSS.AccountLawson = &Счет120205
		|				И (ПроводкаDSS.System = ""BL""
		|						И ПроводкаDSS.SourceCode = ""JE""
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3""))
		|			ИЛИ ПроводкаDSS.AccountLawson = &Счет120206
		|				И (ПроводкаDSS.System = ""AR""
		|						И ПроводкаDSS.SourceCode В (""RI"", ""RM"")
		|					ИЛИ ПроводкаDSS.System = ""BL""
		|						И (ПроводкаDSS.SourceCode В (""CM"", ""DM"")
		|							ИЛИ ПроводкаDSS.SourceCode = ""JE"")
		|					ИЛИ ПроводкаDSS.System = ""GL""
		|						И ПроводкаDSS.SourceCode В (""JE"", ""S1"", ""S2"", ""S3"")))
		|
		|СГРУППИРОВАТЬ ПО
		|	ПроводкаDSS.Ссылка,
		|	ПроводкаDSS.Company,
		|	ПроводкаDSS.LegalEntity,
		|	ПроводкаDSS.AU,
		|	ПроводкаDSS.КонтрагентLawson,
		|	ПроводкаDSS.Currency,
		|	ПроводкаDSS.TranAmount
		|
		|ИМЕЮЩИЕ
		|	СУММА(ПроводкаDSS.TranAmount) <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеТранзакций.Company КАК Company,
		|	ВТ_ДанныеТранзакций.LegalEntity КАК LegalEntity,
		|	ВТ_ДанныеТранзакций.AU КАК AU,
		|	ВТ_ДанныеТранзакций.Client КАК Client,
		|	ВТ_ДанныеТранзакций.Currency КАК Currency,
		|	СУММА(ВТ_ДанныеТранзакций.Amount) КАК Amount,
		|	СУММА(ВЫРАЗИТЬ(ВТ_ДанныеТранзакций.Amount / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))) КАК USDAmount
		|ИЗ
		|	ВТ_ДанныеТранзакций КАК ВТ_ДанныеТранзакций
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(
		|				ДОБАВИТЬКДАТЕ(&КонецПериода, СЕКУНДА, 1),
		|				Валюта В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_ДанныеТранзакций.Currency
		|					ИЗ
		|						ВТ_ДанныеТранзакций КАК ВТ_ДанныеТранзакций)) КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО ВТ_ДанныеТранзакций.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ДанныеТранзакций.Company,
		|	ВТ_ДанныеТранзакций.LegalEntity,
		|	ВТ_ДанныеТранзакций.AU,
		|	ВТ_ДанныеТранзакций.Client,
		|	ВТ_ДанныеТранзакций.Currency";
	
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
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВложенныйЗапросОстатки.Client КАК Client,
		|	ВложенныйЗапросОстатки.Company КАК Company,
		|	ВложенныйЗапросОстатки.Source КАК Source,
		|	ВложенныйЗапросОстатки.AU КАК AU,
		|	СУММА(ВЫРАЗИТЬ(ВложенныйЗапросОстатки.AmountОстаток / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))) КАК USDAmount,
		|	ВложенныйЗапросОстатки.LegalEntity КАК LegalEntity,
		|	ВложенныйЗапросОстатки.Currency,
		|	СУММА(ВложенныйЗапросОстатки.AmountОстаток) КАК Amount
		|ПОМЕСТИТЬ ВТ_ОстаткиКонечные
		|ИЗ
		|	(ВЫБРАТЬ
		|		UnbilledARОстатки.Client КАК Client,
		|		UnbilledARОстатки.Company КАК Company,
		|		UnbilledARОстатки.Source КАК Source,
		|		UnbilledARОстатки.AU.ПодразделениеОрганизации КАК Location,
		|		UnbilledARОстатки.AU.Сегмент КАК SubSubSegment,
		|		UnbilledARОстатки.AU КАК AU,
		|		UnbilledARОстатки.Currency КАК Currency,
		|		UnbilledARОстатки.AmountОстаток КАК AmountОстаток,
		|		ВЫБОР
		|			КОГДА UnbilledARОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА UnbilledARОстатки.LegalEntity
		|			ИНАЧЕ UnbilledARОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ КАК LegalEntity
		|	ИЗ
		|		РегистрНакопления.UnbilledAR.Остатки(
		|				&ПериодОстатков,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК UnbilledARОстатки
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		BilledARОстатки.Client,
		|		BilledARОстатки.Company,
		|		BilledARОстатки.Source,
		|		BilledARОстатки.AU.ПодразделениеОрганизации,
		|		BilledARОстатки.AU.Сегмент,
		|		BilledARОстатки.AU,
		|		BilledARОстатки.Currency,
		|		BilledARОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА BilledARОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА BilledARОстатки.LegalEntity
		|			ИНАЧЕ BilledARОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.BilledAR.Остатки(
		|				&ПериодОстатков,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК BilledARОстатки
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		UnallocatedCashОстатки.Client,
		|		UnallocatedCashОстатки.Company,
		|		UnallocatedCashОстатки.Source,
		|		UnallocatedCashОстатки.AU.ПодразделениеОрганизации,
		|		UnallocatedCashОстатки.AU.Сегмент,
		|		UnallocatedCashОстатки.AU,
		|		UnallocatedCashОстатки.Currency,
		|		-UnallocatedCashОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА UnallocatedCashОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА UnallocatedCashОстатки.LegalEntity
		|			ИНАЧЕ UnallocatedCashОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.UnallocatedCash.Остатки(
		|				&ПериодОстатков,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК UnallocatedCashОстатки
		|	ГДЕ
		|		ВЫБОР
		|				КОГДА НЕ UnallocatedCashОстатки.CashBatch.Ссылка ЕСТЬ NULL
		|					ТОГДА НЕ UnallocatedCashОстатки.Account.КодЧислом = 209000
		|								И НЕ UnallocatedCashОстатки.Account.КодЧислом = 2090001
		|							ИЛИ UnallocatedCashОстатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
		|							ИЛИ UnallocatedCashОстатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ManualTransactionsОстатки.Client,
		|		ManualTransactionsОстатки.Company,
		|		ManualTransactionsОстатки.Source,
		|		ManualTransactionsОстатки.AU.ПодразделениеОрганизации,
		|		ManualTransactionsОстатки.AU.Сегмент,
		|		ManualTransactionsОстатки.AU,
		|		ManualTransactionsОстатки.Currency,
		|		ManualTransactionsОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА ManualTransactionsОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА ManualTransactionsОстатки.LegalEntity
		|			ИНАЧЕ ManualTransactionsОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ManualTransactions.Остатки(
		|				&ПериодОстатков,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК ManualTransactionsОстатки
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		UnallocatedMemoОстатки.Client,
		|		UnallocatedMemoОстатки.Company,
		|		UnallocatedMemoОстатки.Source,
		|		UnallocatedMemoОстатки.AU.ПодразделениеОрганизации,
		|		UnallocatedMemoОстатки.AU.Сегмент,
		|		UnallocatedMemoОстатки.AU,
		|		UnallocatedMemoОстатки.Currency,
		|		UnallocatedMemoОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА UnallocatedMemoОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА UnallocatedMemoОстатки.LegalEntity
		|			ИНАЧЕ UnallocatedMemoОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.UnallocatedMemo.Остатки(
		|				&ПериодОстатков,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК UnallocatedMemoОстатки) КАК ВложенныйЗапросОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(&ПериодОстатков, ) КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО ВложенныйЗапросОстатки.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапросОстатки.Client,
		|	ВложенныйЗапросОстатки.Company,
		|	ВложенныйЗапросОстатки.Source,
		|	ВложенныйЗапросОстатки.AU,
		|	ВложенныйЗапросОстатки.LegalEntity,
		|	ВложенныйЗапросОстатки.Currency
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Client,
		|	Company,
		|	LegalEntity,
		|	AU,
		|	Source
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапросОстатки.Client КАК Client,
		|	ВложенныйЗапросОстатки.Company КАК Company,
		|	ВложенныйЗапросОстатки.Source КАК Source,
		|	ВложенныйЗапросОстатки.AU КАК AU,
		|	СУММА(ВЫРАЗИТЬ(ВложенныйЗапросОстатки.AmountОстаток / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))) КАК USDAmount,
		|	ВложенныйЗапросОстатки.LegalEntity КАК LegalEntity,
		|	ВложенныйЗапросОстатки.Currency,
		|	СУММА(ВложенныйЗапросОстатки.AmountОстаток) КАК Amount
		|ПОМЕСТИТЬ ВТ_ОстаткиНачальные
		|ИЗ
		|	(ВЫБРАТЬ
		|		UnbilledARОстатки.Client КАК Client,
		|		UnbilledARОстатки.Company КАК Company,
		|		UnbilledARОстатки.Source КАК Source,
		|		UnbilledARОстатки.AU.ПодразделениеОрганизации КАК Location,
		|		UnbilledARОстатки.AU.Сегмент КАК SubSubSegment,
		|		UnbilledARОстатки.AU КАК AU,
		|		UnbilledARОстатки.Currency КАК Currency,
		|		UnbilledARОстатки.AmountОстаток КАК AmountОстаток,
		|		ВЫБОР
		|			КОГДА UnbilledARОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА UnbilledARОстатки.LegalEntity
		|			ИНАЧЕ UnbilledARОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ КАК LegalEntity
		|	ИЗ
		|		РегистрНакопления.UnbilledAR.Остатки(
		|				&ПериодОстатковПредыдущийМесяц,
		|				Source В (&Sources) 
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000 
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК UnbilledARОстатки
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		BilledARОстатки.Client,
		|		BilledARОстатки.Company,
		|		BilledARОстатки.Source,
		|		BilledARОстатки.AU.ПодразделениеОрганизации,
		|		BilledARОстатки.AU.Сегмент,
		|		BilledARОстатки.AU,
		|		BilledARОстатки.Currency,
		|		BilledARОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА BilledARОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА BilledARОстатки.LegalEntity
		|			ИНАЧЕ BilledARОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.BilledAR.Остатки(
		|				&ПериодОстатковПредыдущийМесяц,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК BilledARОстатки
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		UnallocatedCashОстатки.Client,
		|		UnallocatedCashОстатки.Company,
		|		UnallocatedCashОстатки.Source,
		|		UnallocatedCashОстатки.AU.ПодразделениеОрганизации,
		|		UnallocatedCashОстатки.AU.Сегмент,
		|		UnallocatedCashОстатки.AU,
		|		UnallocatedCashОстатки.Currency,
		|		-UnallocatedCashОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА UnallocatedCashОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА UnallocatedCashОстатки.LegalEntity
		|			ИНАЧЕ UnallocatedCashОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.UnallocatedCash.Остатки(&ПериодОстатковПредыдущийМесяц, Source В (&Sources)) КАК UnallocatedCashОстатки
		|	ГДЕ
		|		ВЫБОР
		|				КОГДА НЕ UnallocatedCashОстатки.CashBatch.Ссылка ЕСТЬ NULL
		|					ТОГДА НЕ UnallocatedCashОстатки.Account.КодЧислом = 209000
		|								И НЕ UnallocatedCashОстатки.Account.КодЧислом = 2090001
		|							ИЛИ UnallocatedCashОстатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
		|							ИЛИ UnallocatedCashОстатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
		|				ИНАЧЕ ИСТИНА
		|			КОНЕЦ
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		ManualTransactionsОстатки.Client,
		|		ManualTransactionsОстатки.Company,
		|		ManualTransactionsОстатки.Source,
		|		ManualTransactionsОстатки.AU.ПодразделениеОрганизации,
		|		ManualTransactionsОстатки.AU.Сегмент,
		|		ManualTransactionsОстатки.AU,
		|		ManualTransactionsОстатки.Currency,
		|		ManualTransactionsОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА ManualTransactionsОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА ManualTransactionsОстатки.LegalEntity
		|			ИНАЧЕ ManualTransactionsОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.ManualTransactions.Остатки(
		|				&ПериодОстатковПредыдущийМесяц,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК ManualTransactionsОстатки
		|
		|	ОБЪЕДИНИТЬ ВСЕ
		|
		|	ВЫБРАТЬ
		|		UnallocatedMemoОстатки.Client,
		|		UnallocatedMemoОстатки.Company,
		|		UnallocatedMemoОстатки.Source,
		|		UnallocatedMemoОстатки.AU.ПодразделениеОрганизации,
		|		UnallocatedMemoОстатки.AU.Сегмент,
		|		UnallocatedMemoОстатки.AU,
		|		UnallocatedMemoОстатки.Currency,
		|		UnallocatedMemoОстатки.AmountОстаток,
		|		ВЫБОР
		|			КОГДА UnallocatedMemoОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|				ТОГДА UnallocatedMemoОстатки.LegalEntity
		|			ИНАЧЕ UnallocatedMemoОстатки.Company.DefaultLegalEntity
		|		КОНЕЦ
		|	ИЗ
		|		РегистрНакопления.UnallocatedMemo.Остатки(
		|				&ПериодОстатковПредыдущийМесяц,
		|				Source В (&Sources)
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 209000
		|					И ВЫРАЗИТЬ(Account КАК ПланСчетов.Lawson).КодЧислом <> 2090001) КАК UnallocatedMemoОстатки) КАК ВложенныйЗапросОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(&ПериодОстатков, ) КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО ВложенныйЗапросОстатки.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапросОстатки.Client,
		|	ВложенныйЗапросОстатки.Company,
		|	ВложенныйЗапросОстатки.Source,
		|	ВложенныйЗапросОстатки.AU,
		|	ВложенныйЗапросОстатки.LegalEntity,
		|	ВложенныйЗапросОстатки.Currency
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Client,
		|	Company,
		|	LegalEntity,
		|	AU,
		|	Source
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	PaymentsОбороты.Client КАК Client,
		|	PaymentsОбороты.Company КАК Company,
		|	PaymentsОбороты.Source КАК Source,
		|	PaymentsОбороты.AU КАК AU,
		|	ВЫБОР
		|		КОГДА PaymentsОбороты.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА PaymentsОбороты.LegalEntity
		|		ИНАЧЕ PaymentsОбороты.Company.DefaultLegalEntity
		|	КОНЕЦ КАК LegalEntity,
		|	СУММА(ВЫРАЗИТЬ(PaymentsОбороты.AmountОборот / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))) КАК USDAmount,
		|	PaymentsОбороты.Currency,
		|	СУММА(PaymentsОбороты.AmountОборот) КАК Amount
		|ПОМЕСТИТЬ ВТ_Collection
		|ИЗ
		|	РегистрНакопления.Payments.Обороты(
		|			&НачалоПериода,
		|			&КонецПериода,
		|			,
		|			Source В (&Sources)
		|				И НЕ Account.КодЧислом = 209000
		|				И НЕ Account.КодЧислом = 2090001) КАК PaymentsОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(&ПериодОстатков, ) КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО PaymentsОбороты.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|
		|СГРУППИРОВАТЬ ПО
		|	PaymentsОбороты.Client,
		|	PaymentsОбороты.Company,
		|	PaymentsОбороты.Source,
		|	PaymentsОбороты.AU,
		|	ВЫБОР
		|		КОГДА PaymentsОбороты.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА PaymentsОбороты.LegalEntity
		|		ИНАЧЕ PaymentsОбороты.Company.DefaultLegalEntity
		|	КОНЕЦ,
		|	PaymentsОбороты.Currency
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.Client, ВТ_ОстаткиНачальные.Client) КАК Client,
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.Company, ВТ_ОстаткиНачальные.Company) КАК Company,
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.Source, ВТ_ОстаткиНачальные.Source) КАК Source,
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.AU, ВТ_ОстаткиНачальные.AU) КАК AU,
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.LegalEntity, ВТ_ОстаткиНачальные.LegalEntity) КАК LegalEntity,
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.Currency, ВТ_ОстаткиНачальные.Currency) КАК Currency,
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.Amount, 0) КАК FinalAR,
		|	ЕСТЬNULL(ВТ_ОстаткиКонечные.USDAmount, 0) КАК FinalARUSD,
		|	ЕСТЬNULL(ВТ_ОстаткиНачальные.Amount, 0) КАК InitialAR,
		|	ЕСТЬNULL(ВТ_ОстаткиНачальные.USDAmount, 0) КАК InitialARUSD
		|ПОМЕСТИТЬ ВТ_ПолныеОстатки
		|ИЗ
		|	ВТ_ОстаткиНачальные КАК ВТ_ОстаткиНачальные
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ОстаткиКонечные КАК ВТ_ОстаткиКонечные
		|		ПО ВТ_ОстаткиНачальные.Client = ВТ_ОстаткиКонечные.Client
		|			И ВТ_ОстаткиНачальные.Company = ВТ_ОстаткиКонечные.Company
		|			И ВТ_ОстаткиНачальные.Source = ВТ_ОстаткиКонечные.Source
		|			И ВТ_ОстаткиНачальные.AU = ВТ_ОстаткиКонечные.AU
		|			И ВТ_ОстаткиНачальные.LegalEntity = ВТ_ОстаткиКонечные.LegalEntity
		|			И ВТ_ОстаткиНачальные.Currency = ВТ_ОстаткиКонечные.Currency
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Client,
		|	Company,
		|	LegalEntity,
		|	AU,
		|	Source
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.Client, ВТ_Collection.Client) КАК Client,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.Company, ВТ_Collection.Company) КАК Company,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.Source, ВТ_Collection.Source) КАК Source,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.AU, ВТ_Collection.AU) КАК AU,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.LegalEntity, ВТ_Collection.LegalEntity) КАК LegalEntity,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.Currency, ВТ_Collection.Currency) КАК Currency,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.FinalAR, 0) КАК FinalAR,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.FinalARUSD, 0) КАК FinalARUSD,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.InitialAR, 0) КАК InitialAR,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.InitialARUSD, 0) КАК InitialARUSD,
		|	ЕСТЬNULL(ВТ_Collection.Amount, 0) КАК Collection,
		|	ЕСТЬNULL(ВТ_Collection.USDAmount, 0) КАК CollectionUSD,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.FinalAR, 0) - ЕСТЬNULL(ВТ_ПолныеОстатки.InitialAR, 0) + ЕСТЬNULL(ВТ_Collection.Amount, 0) КАК Amount,
		|	ЕСТЬNULL(ВТ_ПолныеОстатки.FinalARUSD, 0) - ЕСТЬNULL(ВТ_ПолныеОстатки.InitialARUSD, 0) + ЕСТЬNULL(ВТ_Collection.USDAmount, 0) КАК USDAmount
		|ИЗ
		|	ВТ_ПолныеОстатки КАК ВТ_ПолныеОстатки
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_Collection КАК ВТ_Collection
		|		ПО ВТ_ПолныеОстатки.Client = ВТ_Collection.Client
		|			И ВТ_ПолныеОстатки.Company = ВТ_Collection.Company
		|			И ВТ_ПолныеОстатки.Source = ВТ_Collection.Source
		|			И ВТ_ПолныеОстатки.AU = ВТ_Collection.AU
		|			И ВТ_ПолныеОстатки.LegalEntity = ВТ_Collection.LegalEntity
		|			И ВТ_ПолныеОстатки.Currency = ВТ_Collection.Currency";
	
	Запрос.УстановитьПараметр("Sources", Перечисления.ТипыСоответствий.HOBs);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(СтруктураПараметров.Дата));
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(СтруктураПараметров.Дата));
	Запрос.УстановитьПараметр("ПериодОстатков", КонецМесяца(СтруктураПараметров.Дата) + 1);
	Запрос.УстановитьПараметр("ПериодОстатковПредыдущийМесяц", НачалоМесяца(СтруктураПараметров.Дата));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

#КонецЕсли