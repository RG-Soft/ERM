#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ПолучитьТекстЗапроса(ГлубинаDSO) Экспорт
	
	ШаблонОбъединенияОстатков = "
		|	ВЫБРАТЬ
		|		ВложенныйЗапросОстатки%1.Client КАК Client,
		|		ВложенныйЗапросОстатки%1.Company КАК Company,
		|		ВложенныйЗапросОстатки%1.Source КАК Source,
		|		ВложенныйЗапросОстатки%1.Location КАК Location,
		|		ВложенныйЗапросОстатки%1.SubSubSegment КАК SubSubSegment,
		|		ВложенныйЗапросОстатки%1.AU КАК AU,
		|		#РесурсыОстатков#
		|		ВложенныйЗапросОстатки%1.LegalEntity КАК LegalEntity
		|	ИЗ
		|		(ВЫБРАТЬ
		|			UnbilledARОстатки.Client КАК Client,
		|			UnbilledARОстатки.Company КАК Company,
		|			UnbilledARОстатки.Source КАК Source,
		|			UnbilledARОстатки.AU.ПодразделениеОрганизации КАК Location,
		|			UnbilledARОстатки.AU.Сегмент КАК SubSubSegment,
		|			UnbilledARОстатки.AU КАК AU,
		|			UnbilledARОстатки.Currency КАК Currency,
		|			UnbilledARОстатки.AmountОстаток КАК AmountОстаток,
		|			ВЫБОР
		|				КОГДА UnbilledARОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|					ТОГДА UnbilledARОстатки.LegalEntity
		|				ИНАЧЕ UnbilledARОстатки.Company.DefaultLegalEntity
		|			КОНЕЦ КАК LegalEntity
		|		ИЗ
		|			РегистрНакопления.UnbilledAR.Остатки(
		|					{(&ПериодОстатков%1)},
		|					Source В (&Sources)
		|						И ПОДСТРОКА(Account.Код, 1, 6) <> ""209000"") КАК UnbilledARОстатки
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			BilledARОстатки.Client,
		|			BilledARОстатки.Company,
		|			BilledARОстатки.Source,
		|			BilledARОстатки.AU.ПодразделениеОрганизации,
		|			BilledARОстатки.AU.Сегмент,
		|			BilledARОстатки.AU,
		|			BilledARОстатки.Currency,
		|			BilledARОстатки.AmountОстаток,
		|			ВЫБОР
		|				КОГДА BilledARОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|					ТОГДА BilledARОстатки.LegalEntity
		|				ИНАЧЕ BilledARОстатки.Company.DefaultLegalEntity
		|			КОНЕЦ
		|		ИЗ
		|			РегистрНакопления.BilledAR.Остатки(
		|					{(&ПериодОстатков%1)},
		|					Source В (&Sources)
		|						И ПОДСТРОКА(Account.Код, 1, 6) <> ""209000"") КАК BilledARОстатки
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			UnallocatedCashОстатки.Client,
		|			UnallocatedCashОстатки.Company,
		|			UnallocatedCashОстатки.Source,
		|			UnallocatedCashОстатки.AU.ПодразделениеОрганизации,
		|			UnallocatedCashОстатки.AU.Сегмент,
		|			UnallocatedCashОстатки.AU,
		|			UnallocatedCashОстатки.Currency,
		|			-UnallocatedCashОстатки.AmountОстаток,
		|			ВЫБОР
		|				КОГДА UnallocatedCashОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|					ТОГДА UnallocatedCashОстатки.LegalEntity
		|				ИНАЧЕ UnallocatedCashОстатки.Company.DefaultLegalEntity
		|			КОНЕЦ
		|		ИЗ
		|			РегистрНакопления.UnallocatedCash.Остатки(
		|					{(&ПериодОстатков%1)},
		|					Source В (&Sources)
		|						И ПОДСТРОКА(Account.Код, 1, 6) <> ""209000"") КАК UnallocatedCashОстатки
		|		ГДЕ
		|			ВЫБОР
		|					КОГДА НЕ UnallocatedCashОстатки.CashBatch.Ссылка ЕСТЬ NULL
		|						ТОГДА НЕ UnallocatedCashОстатки.Account.КодЧислом = 209000
		|									И НЕ UnallocatedCashОстатки.Account.КодЧислом = 2090001
		|								ИЛИ UnallocatedCashОстатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
		|								ИЛИ UnallocatedCashОстатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
		|					ИНАЧЕ ИСТИНА
		|				КОНЕЦ
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			ManualTransactionsОстатки.Client,
		|			ManualTransactionsОстатки.Company,
		|			ManualTransactionsОстатки.Source,
		|			ManualTransactionsОстатки.AU.ПодразделениеОрганизации,
		|			ManualTransactionsОстатки.AU.Сегмент,
		|			ManualTransactionsОстатки.AU,
		|			ManualTransactionsОстатки.Currency,
		|			ManualTransactionsОстатки.AmountОстаток,
		|			ВЫБОР
		|				КОГДА ManualTransactionsОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|					ТОГДА ManualTransactionsОстатки.LegalEntity
		|				ИНАЧЕ ManualTransactionsОстатки.Company.DefaultLegalEntity
		|			КОНЕЦ
		|		ИЗ
		|			РегистрНакопления.ManualTransactions.Остатки(
		|					{(&ПериодОстатков%1)},
		|					Source В (&Sources)
		|						И ПОДСТРОКА(Account.Код, 1, 6) <> ""209000"") КАК ManualTransactionsОстатки
		|		
		|		ОБЪЕДИНИТЬ ВСЕ
		|		
		|		ВЫБРАТЬ
		|			UnallocatedMemoОстатки.Client,
		|			UnallocatedMemoОстатки.Company,
		|			UnallocatedMemoОстатки.Source,
		|			UnallocatedMemoОстатки.AU.ПодразделениеОрганизации,
		|			UnallocatedMemoОстатки.AU.Сегмент,
		|			UnallocatedMemoОстатки.AU,
		|			UnallocatedMemoОстатки.Currency,
		|			UnallocatedMemoОстатки.AmountОстаток,
		|			ВЫБОР
		|				КОГДА UnallocatedMemoОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|					ТОГДА UnallocatedMemoОстатки.LegalEntity
		|				ИНАЧЕ UnallocatedMemoОстатки.Company.DefaultLegalEntity
		|			КОНЕЦ
		|		ИЗ
		|			РегистрНакопления.UnallocatedMemo.Остатки(
		|					{(&ПериодОстатков%1)},
		|					Source В (&Sources)
		|						И ПОДСТРОКА(Account.Код, 1, 6) <> ""209000"") КАК UnallocatedMemoОстатки) КАК ВложенныйЗапросОстатки%1
		|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних({(&ПериодОстатков%1)}, ) КАК ВнутренниеКурсыВалютСрезПоследних
		|			ПО ВложенныйЗапросОстатки%1.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта";
	
	Объединение = "";
	
	Для ТекУровень = 0 По ГлубинаDSO - 24 Цикл
		
		РесурсыОстатков = "";
		Для УровеньРесурсаОстатков = 0 По ГлубинаDSO - 24 Цикл
			УровеньСтрокой = Формат(УровеньРесурсаОстатков, "ЧН=0; ЧГ=0");
			РесурсыОстатков = РесурсыОстатков + СтрШаблон("%1 КАК USDAmount%2", ?(ТекУровень = УровеньРесурсаОстатков, СтрШаблон("ВЫРАЗИТЬ(ВложенныйЗапросОстатки%1.AmountОстаток / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))", Формат(ТекУровень, "ЧН=0; ЧГ=0")), "0"), УровеньСтрокой + "," + Символы.ПС);
		КонецЦикла;
		
		ФрагментОбъединения = СтрШаблон(ШаблонОбъединенияОстатков, Формат(ТекУровень, "ЧН=0; ЧГ=0"));
		Объединение = Объединение + Символы.ПС + СтрЗаменить(ФрагментОбъединения, "#РесурсыОстатков#", РесурсыОстатков) + ?(ТекУровень < ГлубинаDSO - 24, Символы.ПС + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ", "");
		
	КонецЦикла;
	
	МассивРесурсовОстатковВерхнегоУровня = Новый Массив;
	МассивРесурсовОстатковВерхнегоУровняСПсевдонимами = Новый Массив;
	МассивРесурсовБиллингаBilling1 = Новый Массив;
	МассивРесурсовБиллингаBilling2 = Новый Массив;
	МассивРесурсовБиллингаRevenue = Новый Массив;
	МассивКурсыБиллингаBilling2 = Новый Массив;
	МассивРесурсовОборотыПолные = Новый Массив;
	
	Для ТекУровень = 0 По ГлубинаDSO - 24 Цикл
		ТекУровеньСтрокой = Формат(ТекУровень, "ЧН=0; ЧГ=0");
		МассивРесурсовОстатковВерхнегоУровня.Добавить(СтрШаблон("СУММА(ВложенныйЗапросОстатки.USDAmount%1) <> 0", ТекУровеньСтрокой));
		МассивРесурсовОстатковВерхнегоУровняСПсевдонимами.Добавить(СтрШаблон("СУММА(ВложенныйЗапросОстатки.USDAmount%1) КАК USDAmount%1", ТекУровеньСтрокой));
		МассивРесурсовБиллингаBilling1.Добавить(СтрШаблон("СУММА(Billing.USDAmount) КАК USDAmount%1", ТекУровеньСтрокой));
		МассивРесурсовБиллингаBilling2.Добавить(СтрШаблон("СУММА(Billing.Amount / ВнутренниеКурсыВалютСрезПоследних%1.Курс * ВнутренниеКурсыВалютСрезПоследних%1.Кратность)", ТекУровеньСтрокой));
		МассивРесурсовБиллингаRevenue.Добавить("RevenueОбороты.BaseAmountОборот");
		МассивКурсыБиллингаBilling2.Добавить(Символы.ПС + СтрШаблон("ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних({(&ПериодОстатков%1)}, ) КАК ВнутренниеКурсыВалютСрезПоследних%1
		|		ПО Billing.Currency = ВнутренниеКурсыВалютСрезПоследних%1.Валюта", ТекУровеньСтрокой));
		МассивРесурсовОборотыПолные.Добавить(СтрШаблон("ЕСТЬNULL(ВТ_Биллинг.USDAmount%1, 0) КАК USDAmount%1", ТекУровеньСтрокой));
	КонецЦикла;
	
	ТекстЗапроса = 
		"ВЫБРАТЬ
		|	ВложенныйЗапросОстатки.Client КАК Client,
		|	ВложенныйЗапросОстатки.Company КАК Company,
		|	ВложенныйЗапросОстатки.Source КАК Source,
		|	ВложенныйЗапросОстатки.Location,
		|	ВложенныйЗапросОстатки.SubSubSegment,
		|	ВложенныйЗапросОстатки.AU КАК AU,
		|	ВложенныйЗапросОстатки.LegalEntity КАК LegalEntity,
		|	" + СтрСоединить(МассивРесурсовОстатковВерхнегоУровняСПсевдонимами, "," + Символы.ПС) + "
		|ПОМЕСТИТЬ ВТ_Остатки
		|ИЗ
		|	(" + Объединение + ") КАК ВложенныйЗапросОстатки
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапросОстатки.Client,
		|	ВложенныйЗапросОстатки.Company,
		|	ВложенныйЗапросОстатки.Source,
		|	ВложенныйЗапросОстатки.Location,
		|	ВложенныйЗапросОстатки.SubSubSegment,
		|	ВложенныйЗапросОстатки.AU,
		|	ВложенныйЗапросОстатки.LegalEntity
		|
		|ИМЕЮЩИЕ
		|" + СтрСоединить(МассивРесурсовОстатковВерхнегоУровня, Символы.ПС + "ИЛИ" + Символы.ПС) + "
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
		|	Billing.Период,
		|	Billing.Client,
		|	Billing.Company,
		|	ВЫБОР
		|		КОГДА Billing.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА Billing.LegalEntity
		|		ИНАЧЕ Billing.Company.DefaultLegalEntity
		|	КОНЕЦ КАК LegalEntity,
		|	Billing.AU,
		|	Billing.Source,
		|	" + СтрСоединить(МассивРесурсовБиллингаBilling1, "," + Символы.ПС) + "
		|ПОМЕСТИТЬ ВТ_Биллинг
		|ИЗ
		|	РегистрСведений.Billing КАК Billing
		|ГДЕ
		|	Billing.Период <= &Период
		|	И Billing.Активность
		|	И Billing.Период >= ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, -&ГлубинаDSO)
		|	И Billing.Source В(&SourcesBilling)
		|	И Billing.Source <> ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|
		|СГРУППИРОВАТЬ ПО
		|	Billing.Период,
		|	Billing.Client,
		|	Billing.Company,
		|	ВЫБОР
		|		КОГДА Billing.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА Billing.LegalEntity
		|		ИНАЧЕ Billing.Company.DefaultLegalEntity
		|	КОНЕЦ,
		|	Billing.AU,
		|	Billing.Source
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	Billing.Период,
		|	Billing.Client,
		|	Billing.Company,
		|	ВЫБОР
		|		КОГДА Billing.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА Billing.LegalEntity
		|		ИНАЧЕ Billing.Company.DefaultLegalEntity
		|	КОНЕЦ,
		|	Billing.AU,
		|	Billing.Source,
		|	" + СтрСоединить(МассивРесурсовБиллингаBilling2, "," + Символы.ПС) + "
		|ИЗ
		|	РегистрСведений.Billing КАК Billing
		|		" + СтрСоединить(МассивКурсыБиллингаBilling2, Символы.ПС) + "
		|ГДЕ
		|	Billing.Период <= &Период
		|	И Billing.Активность
		|	И Billing.Период >= ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, -&ГлубинаDSO)
		|	И Billing.Source В(&SourcesBilling)
		|	И Billing.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|
		|СГРУППИРОВАТЬ ПО
		|	Billing.Период,
		|	Billing.Client,
		|	Billing.Company,
		|	ВЫБОР
		|		КОГДА Billing.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА Billing.LegalEntity
		|		ИНАЧЕ Billing.Company.DefaultLegalEntity
		|	КОНЕЦ,
		|	Billing.AU,
		|	Billing.Source
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	RevenueОбороты.Период,
		|	RevenueОбороты.Client,
		|	RevenueОбороты.Company,
		|	ВЫБОР
		|		КОГДА RevenueОбороты.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА RevenueОбороты.LegalEntity
		|		ИНАЧЕ RevenueОбороты.Company.DefaultLegalEntity
		|	КОНЕЦ,
		|	RevenueОбороты.AU,
		|	RevenueОбороты.Source,
		|	" + СтрСоединить(МассивРесурсовБиллингаRevenue, "," + Символы.ПС) + "
		|ИЗ
		|	РегистрНакопления.Revenue.Обороты(
		|			ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, -&ГлубинаDSO),
		|			&Период,
		|			Месяц,
		|			Source В (&SourcesRevenue)
		|				И НЕ Account.БазовыйЭлемент.Intercompany) КАК RevenueОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НАЧАЛОПЕРИОДА(ДанныеПроизводственногоКалендаря.Дата, МЕСЯЦ) КАК Период
		|ПОМЕСТИТЬ Месяцы
		|ИЗ
		|	РегистрСведений.ДанныеПроизводственногоКалендаря КАК ДанныеПроизводственногоКалендаря
		|ГДЕ
		|	ДанныеПроизводственногоКалендаря.Дата <= &Период
		|	И ДанныеПроизводственногоКалендаря.Дата >= НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(&Период, МЕСЯЦ, -&ГлубинаDSO), МЕСЯЦ)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Месяцы.Период,
		|	КомбинацииАналитики.Client,
		|	КомбинацииАналитики.Company,
		|	КомбинацииАналитики.LegalEntity,
		|	КомбинацииАналитики.AU,
		|	КомбинацииАналитики.Source
		|ПОМЕСТИТЬ ВсеПериодыПоКомбинацииАналитики
		|ИЗ
		|	Месяцы КАК Месяцы,
		|	(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		ВТ_Биллинг.Client КАК Client,
		|		ВТ_Биллинг.Company КАК Company,
		|		ВТ_Биллинг.LegalEntity КАК LegalEntity,
		|		ВТ_Биллинг.AU КАК AU,
		|		ВТ_Биллинг.Source КАК Source
		|	ИЗ
		|		ВТ_Биллинг КАК ВТ_Биллинг
		|	
		|	ОБЪЕДИНИТЬ
		|	
		|	ВЫБРАТЬ РАЗЛИЧНЫЕ
		|		ВТ_Остатки.Client,
		|		ВТ_Остатки.Company,
		|		ВТ_Остатки.LegalEntity,
		|		ВТ_Остатки.AU,
		|		ВТ_Остатки.Source
		|	ИЗ
		|		ВТ_Остатки КАК ВТ_Остатки) КАК КомбинацииАналитики
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВсеПериодыПоКомбинацииАналитики.Период КАК Период,
		|	ВсеПериодыПоКомбинацииАналитики.Client КАК Client,
		|	ВсеПериодыПоКомбинацииАналитики.Company КАК Company,
		|	ВсеПериодыПоКомбинацииАналитики.LegalEntity КАК LegalEntity,
		|	ВсеПериодыПоКомбинацииАналитики.AU КАК AU,
		|	ВсеПериодыПоКомбинацииАналитики.Source КАК Source,
		|	" + СтрСоединить(МассивРесурсовОборотыПолные, "," + Символы.ПС) + "
		|ПОМЕСТИТЬ ОборотыПолные
		|ИЗ
		|	ВсеПериодыПоКомбинацииАналитики КАК ВсеПериодыПоКомбинацииАналитики
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Биллинг КАК ВТ_Биллинг
		|		ПО ВсеПериодыПоКомбинацииАналитики.Период = ВТ_Биллинг.Период
		|			И ВсеПериодыПоКомбинацииАналитики.Client = ВТ_Биллинг.Client
		|			И ВсеПериодыПоКомбинацииАналитики.Company = ВТ_Биллинг.Company
		|			И ВсеПериодыПоКомбинацииАналитики.LegalEntity = ВТ_Биллинг.LegalEntity
		|			И ВсеПериодыПоКомбинацииАналитики.AU = ВТ_Биллинг.AU
		|			И ВсеПериодыПоКомбинацииАналитики.Source = ВТ_Биллинг.Source
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Client,
		|	Company,
		|	LegalEntity,
		|	AU,
		|	Source,
		|	Период";
	
	Объединение = "";
	ШаблонОбъединения = "
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ВТ_Остатки.Client, ОборотыПолные.Client) КАК Client,
	|	ЕСТЬNULL(ВТ_Остатки.Company.БазовыйЭлемент, ОборотыПолные.Company.БазовыйЭлемент) КАК Company,
	|	ЕСТЬNULL(ВТ_Остатки.Source, ОборотыПолные.Source) КАК Source,
	|	ЕСТЬNULL(ВТ_Остатки.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket, ОборотыПолные.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.ManagementGeomarket) КАК MgmtGeomarket,
	|	ЕСТЬNULL(ВТ_Остатки.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель, ОборотыПолные.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель) КАК GeoMarket,
	|	ЕСТЬNULL(ВТ_Остатки.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket, ОборотыПолные.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket) КАК SubGeoMarket,
	|	ЕСТЬNULL(ВТ_Остатки.AU.ПодразделениеОрганизации.БазовыйЭлемент, ОборотыПолные.AU.ПодразделениеОрганизации.БазовыйЭлемент) КАК Location,
	|	ЕСТЬNULL(ВТ_Остатки.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель, ОборотыПолные.AU.Сегмент.БазовыйЭлемент.Родитель.Родитель) КАК Segment,
	|	ЕСТЬNULL(ВТ_Остатки.AU.Сегмент.БазовыйЭлемент.Родитель, ОборотыПолные.AU.Сегмент.БазовыйЭлемент.Родитель) КАК SubSegment,
	|	ЕСТЬNULL(ВТ_Остатки.AU.Сегмент.БазовыйЭлемент, ОборотыПолные.AU.Сегмент.БазовыйЭлемент) КАК SubSubSegment,
	|	ЕСТЬNULL(ВТ_Остатки.AU, ОборотыПолные.AU) КАК AU,
	|	ЕСТЬNULL(ВТ_Остатки.LegalEntity, ОборотыПолные.LegalEntity) КАК LegalEntity,
	|	ЕСТЬNULL(ОборотыПолные.Период, &ТекПериод) КАК ТекущийМесяц,
	|	%РесурсыБиллинга%
	|	%РесурсыAR%
	|ИЗ
	|	ОборотыПолные КАК ОборотыПолные
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО ОборотыПолные.Client = ВТ_Остатки.Client
	|			И ОборотыПолные.Company = ВТ_Остатки.Company
	|			И ОборотыПолные.Source = ВТ_Остатки.Source
	|			И ОборотыПолные.AU = ВТ_Остатки.AU
	|			И ОборотыПолные.LegalEntity = ВТ_Остатки.LegalEntity
	|			И (ОборотыПолные.Период = &ТекПериод)
	|	ГДЕ ОборотыПолные.Период = &ТекПериод";
	
	МассивРесурсовAR = Новый Массив;
	МассивРесурсовARМаксимум = Новый Массив;
	МассивПолейAR = Новый Массив;
	Для ТекУровень = 0 По ГлубинаDSO - 24 Цикл
		УровеньСтрокой = Формат(ТекУровень, "ЧН=0; ЧГ=0");
		МассивРесурсовAR.Добавить(СтрШаблон("ЕСТЬNULL(ВТ_Остатки.USDAmount%1, 0) КАК AR%1", УровеньСтрокой));
		МассивРесурсовARМаксимум.Добавить(СтрШаблон("МАКСИМУМ(ВложенныйЗапрос.AR%1) КАК AR%1", УровеньСтрокой));
		МассивПолейAR.Добавить(СтрШаблон("AR%1 КАК AR%1", УровеньСтрокой));
	КонецЦикла;
	
	Для ТекУровень = 0 По ГлубинаDSO Цикл
		
		РесурсыБиллинга = "";
		Для УровеньРесурсаБиллинга = 0 По ГлубинаDSO Цикл
			УровеньСтрокой = Формат(УровеньРесурсаБиллинга, "ЧН=0; ЧГ=0");
			Для ВложенныйУровень = 0 По ГлубинаDSO - 24 Цикл
				ВложенныйУровеньСтрокой = Формат(ВложенныйУровень, "ЧН=0; ЧГ=0");
				РесурсыБиллинга = РесурсыБиллинга + СтрШаблон("%1 КАК Billing%2", ?(ТекУровень = УровеньРесурсаБиллинга, СтрШаблон("ЕСТЬNULL(ОборотыПолные.USDAmount%1, 0)", ВложенныйУровеньСтрокой), "0"), УровеньСтрокой + "_" + ВложенныйУровеньСтрокой + "," + Символы.ПС);
			КонецЦикла;
		КонецЦикла;
		
		ШаблонОбъединенияПараметризованный = СтрЗаменить(ШаблонОбъединения, "&ТекПериод", "&ТекПериод" + Формат(ТекУровень, "ЧН=0; ЧГ=0"));
		ШаблонОбъединенияПараметризованный = СтрЗаменить(ШаблонОбъединенияПараметризованный, "%РесурсыAR%", СтрСоединить(МассивРесурсовAR, "," + Символы.ПС));
		Объединение = Объединение + Символы.ПС + СтрЗаменить(ШаблонОбъединенияПараметризованный, "%РесурсыБиллинга%", РесурсыБиллинга) + ?(ТекУровень < ГлубинаDSO, Символы.ПС + Символы.ПС + "ОБЪЕДИНИТЬ ВСЕ", "");
		
	КонецЦикла;
	
	ТекстВложенногоЗапроса = "
	|;
	|
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Client КАК Client,
	|	ЕСТЬNULL(ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК ParentClient,
	|	ЕСТЬNULL(ИерархияКонтрагентовСрезПоследних.SalesAccount, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК SalesAccount,
	|	ВложенныйЗапрос.Company КАК Company,
	|	ВложенныйЗапрос.Source КАК Source,
	|	ВложенныйЗапрос.MgmtGeomarket КАК MgmtGeomarket,
	|	ВложенныйЗапрос.GeoMarket КАК GeoMarket,
	|	ВложенныйЗапрос.SubGeoMarket КАК SubGeoMarket,
	|	ВложенныйЗапрос.Location КАК Location,
	|	ВложенныйЗапрос.Segment КАК Segment,
	|	ВложенныйЗапрос.SubSegment КАК SubSegment,
	|	ВложенныйЗапрос.SubSubSegment КАК SubSubSegment,
	|	ВложенныйЗапрос.AU КАК AU,
	|	ВложенныйЗапрос.LegalEntity КАК LegalEntity,
	|	%РесурсыБиллинга%
	|	%РесурсыAR%
	|	{ВЫБРАТЬ Client.*, ParentClient.*, SalesAccount.*, Company.*, Source, MgmtGeomarket.*, 
	|	GeoMarket.*, SubGeoMarket.*, Location.*, Segment.*, SubSegment.*, SubSubSegment.*, AU.*, LegalEntity.*,
	|	%ПоляБиллинга% %ПоляAR%}
	|ИЗ
	|	(" + Объединение + ") КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияКонтрагентов.СрезПоследних КАК ИерархияКонтрагентовСрезПоследних
	|		ПО ВложенныйЗапрос.Client = ИерархияКонтрагентовСрезПоследних.Контрагент
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Client,
	|	ЕСТЬNULL(ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)),
	|	ЕСТЬNULL(ИерархияКонтрагентовСрезПоследних.SalesAccount, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)),
	|	ВложенныйЗапрос.Company,
	|	ВложенныйЗапрос.Source,
	|	ВложенныйЗапрос.MgmtGeomarket,
	|	ВложенныйЗапрос.GeoMarket,
	|	ВложенныйЗапрос.SubGeoMarket,
	|	ВложенныйЗапрос.Location,
	|	ВложенныйЗапрос.Segment,
	|	ВложенныйЗапрос.SubSegment,
	|	ВложенныйЗапрос.SubSubSegment,
	|	ВложенныйЗапрос.AU,
	|	ВложенныйЗапрос.LegalEntity";
	
	РесурсыБиллинга = "";
	ПоляБиллинга = "";
	
	Для ТекУровень = 0 По ГлубинаDSO Цикл
		
		УровеньСтрокой = Формат(ТекУровень, "ЧН=0; ЧГ=0");
		Для ВложенныйУровень = 0 По ГлубинаDSO - 24 Цикл
			ВложенныйУровеньСтрокой = Формат(ВложенныйУровень, "ЧН=0; ЧГ=0");
			РесурсыБиллинга = РесурсыБиллинга + СтрШаблон("СУММА(ВложенныйЗапрос.Billing%1) КАК Billing%2,", УровеньСтрокой + "_" + ВложенныйУровеньСтрокой, УровеньСтрокой + "_" + ВложенныйУровеньСтрокой) + Символы.ПС;
			ПоляБиллинга = ПоляБиллинга + СтрШаблон("Billing%1 КАК Billing%1, ", УровеньСтрокой + "_" + ВложенныйУровеньСтрокой);
		КонецЦикла;
		
	КонецЦикла;
	
	ТекстВложенногоЗапроса = СтрЗаменить(ТекстВложенногоЗапроса, "%РесурсыБиллинга%", РесурсыБиллинга);
	ТекстВложенногоЗапроса = СтрЗаменить(ТекстВложенногоЗапроса, "%РесурсыAR%", СтрСоединить(МассивРесурсовARМаксимум, "," + Символы.ПС));
	ТекстВложенногоЗапроса = СтрЗаменить(ТекстВложенногоЗапроса, "%ПоляБиллинга%", ПоляБиллинга);
	ТекстВложенногоЗапроса = СтрЗаменить(ТекстВложенногоЗапроса, "%ПоляAR%", СтрСоединить(МассивПолейAR, ", "));
	
	ТекстЗапроса = ТекстЗапроса + Символы.ПС + Символы.ПС + ТекстВложенногоЗапроса;
	
	Возврат СтрЗаменить(ТекстЗапроса, "&ГлубинаDSO", Формат(ГлубинаDSO, "ЧГ=0"));
	
КонецФункции

#КонецОбласти

#КонецЕсли