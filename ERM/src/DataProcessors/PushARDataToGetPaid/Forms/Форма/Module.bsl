
&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	Если Не ПустаяСтрока(КаталогВыгрузки) Тогда
		ДиалогВыбора.Каталог = КаталогВыгрузки;
	КонецЕсли;
	Если ДиалогВыбора.Выбрать() Тогда
		КаталогВыгрузки = ДиалогВыбора.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьДанныеНаСервере()
	
	Если не ToFile Тогда 
		ВнешниеИсточникиДанных.ERM_GP.dbo_set_skiped_all_BATCHES();
		ВнешниеИсточникиДанных.ERM_GP.dbo_insert_BATCHES();
		Объект.LastBatchID = ВнешниеИсточникиДанных.ERM_GP.dbo_get_last_BATCH_ID();
	КонецЕсли;
	
	ВыгрузитьARCUST();
	ВыгрузитьARMAST();
	ВыгрузитьARCASH();
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьARCUST()
	
	Если ToFile Тогда 
		
		ОписаниеСтруктурыARCUST = ПолучитьОписаниеСтруктурыПриемника("ARCUST");
		
		ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
		СоздатьКаталог(ИмяКаталога);
		ПутьКФайлу = ИмяКаталога + "\ARCUST.txt";
		
		ПутьСхемы = ИмяКаталога+"\schema.ini";
		ФайлСхемы = Новый ТекстовыйДокумент;
		ФайлСхемы.УстановитьТекст(ПолучитьТекстФайлаСхемы("ARCUST", ОписаниеСтруктурыARCUST, ФорматФайла));
		ФайлСхемы.Записать(ПутьСхемы, КодировкаТекста.OEM);
		
		Connection = Новый COMОбъект("ADODB.Connection");
		
		Попытка
			СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=No;IMEX=0;Readonly=False""";
			Connection.CursorLocation = 3;
			Connection.Mode = 3;
			Connection.Open(СтрокаПодключения);
		Исключение
			Попытка
				СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=No;IMEX=0;Readonly=False""";
				Connection.Mode = 3;
				Connection.Open(СтрокаПодключения);
			Исключение
				ВызватьИсключение "Can't open connection! " + ОписаниеОшибки();
			КонецПопытки;
		КонецПопытки;
		
		// создадим таблицу
		Connection.Execute(ПолучитьТекстКомандыСозданияТаблицы("ARCUST", ОписаниеСтруктурыARCUST));
		
		Command = Новый COMОбъект("ADODB.Command");
		Command.ActiveConnection = Connection;
		Command.CommandType = 1;
		
		Command.CommandText = ПолучитьТекстКомандыЗапроса("ARCUST", ОписаниеСтруктурыARCUST);
		СоздатьКоллекциюПараметровКоманды(Command, ОписаниеСтруктурыARCUST);
		
		ТаблицаДанныхARCUST = ПолучитьТаблицуДанныхARCUST();
		КоллекцияКолонокРезультата = ТаблицаДанныхARCUST.Колонки;
		
		Для каждого СтрокаТаблицы Из ТаблицаДанныхARCUST Цикл
			
			Для каждого ТекКолонка Из КоллекцияКолонокРезультата Цикл
				
				ТекЗначение = СтрокаТаблицы[ТекКолонка.Имя];
				Command.Parameters("@" + ТекКолонка.Имя).Value = ?(ТипЗнч(ТекЗначение) = Тип("Строка"), СокрЛП(ТекЗначение), ТекЗначение);
				
			КонецЦикла;
			
			Command.Execute();
			
		КонецЦикла;
		
		АдресФайлаВХранилищеARCUST = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу), УникальныйИдентификатор);
		
		// Закрываем соединение
		Command = Неопределено;
		Connection.Close();
		Connection = Неопределено;
		
		УдалитьФайлы(ИмяКаталога);
		
	Иначе 
		
		ТаблицаДанныхARCUST = ПолучитьТаблицуДанныхARCUST();
		
		Для Каждого Запись из ТаблицаДанныхARCUST Цикл
			
			ВнешниеИсточникиДанных.ERM_GP.dbo_insert_ARCUST(
				Запись.CUSTNO,
				Запись.PARENT,
				Запись.COMPANY,
				Запись.ARCOMMENT,
				Запись.CRD_LIMIT,
				Запись.TERR,
				Запись.BALANCE,
				Запись.REFKEY1,
				Запись.REFKEY2,
				Запись.CREDITSCOR,
				Запись.RESOLVER01,
				Запись.RESOLVER02,
				Запись.RESOLVER03,
				Запись.RESOLVER04,
				Запись.RESOLVER05,
				Запись.RESOLVER06,
				Запись.RESOLVER07,
				Запись.RESOLVER08,
				Запись.RESOLVER09,
				Запись.RESOLVER10,
				Запись.HIGHBAL,
				Запись.LASTYSALES,
				Запись.LASTQSALES,
				Запись.DUNS,
				Запись.ULTIMATEDUNS,
				Запись.FEDID,
				Запись.BNKRTNUM,
				Запись.YTDSALES,
				Запись.LTDSALES,
				Запись.FINYE,
				Запись.LCVDTE,
				Запись.CREDIT_ACCT,
				Запись.TICKER,
				Запись.SIC_CODE,
				Запись.CRSCDT,
				Запись.CRSTDT, 
				Запись.CRLIDT,        
				Запись.EXPCRDLMTDTE, 
				Запись.ARBDR,
				Запись.CMACCT_ID,
				Запись.REQ_SATISFIED,
				Запись.CMPARENT,
				Запись.SMS_PHONE,
				Запись.RELORDERS,
				Запись.PENDINGORD,
				Запись.SLPNEMAIL,
				Запись.SLPN_LANG_ID,
				Запись.PAY_INST_TOTAL,
				Запись.PAY_INST_TOTAL_AMT,
				Запись.PAY_INST_NEXT_DATE, 
				Запись.PAY_INST_NEXT_AMT,
				Запись.ADDRESS1,
				Запись.CITY,
				Запись.COUNTRY,
				Запись.FIRSTNAME,
				Запись.LASTAMT,
				Запись.LASTNAME,
				Запись.LASTPAY,
				Запись.LDATE,
				Запись.LOCCURR,
				Объект.LastBatchID);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьARMAST()
	
	Если ToFile Тогда 
		
		ОписаниеСтруктурыARMAST = ПолучитьОписаниеСтруктурыПриемника("ARMAST");
		
		ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
		СоздатьКаталог(ИмяКаталога);
		ПутьКФайлу = ИмяКаталога + "\ARMAST.txt";
		
		ПутьСхемы = ИмяКаталога+"\schema.ini";
		ФайлСхемы = Новый ТекстовыйДокумент;
		ФайлСхемы.УстановитьТекст(ПолучитьТекстФайлаСхемы("ARMAST", ОписаниеСтруктурыARMAST, ФорматФайла));
		ФайлСхемы.Записать(ПутьСхемы, КодировкаТекста.OEM);
		
		Connection = Новый COMОбъект("ADODB.Connection");
		
		Попытка
			СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=No;IMEX=0;Readonly=False""";
			Connection.CursorLocation = 3;
			Connection.Mode = 3;
			Connection.Open(СтрокаПодключения);
		Исключение
			Попытка
				СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=No;IMEX=0;Readonly=False""";
				Connection.Mode = 3;
				Connection.Open(СтрокаПодключения);
			Исключение
				ВызватьИсключение "Can't open connection! " + ОписаниеОшибки();
			КонецПопытки;
		КонецПопытки;
		
		// создадим таблицу
		Connection.Execute(ПолучитьТекстКомандыСозданияТаблицы("ARMAST", ОписаниеСтруктурыARMAST));
		
		Command = Новый COMОбъект("ADODB.Command");
		Command.ActiveConnection = Connection;
		Command.CommandType = 1;
		
		Command.CommandText = ПолучитьТекстКомандыЗапроса("ARMAST", ОписаниеСтруктурыARMAST);
		СоздатьКоллекциюПараметровКоманды(Command, ОписаниеСтруктурыARMAST);
		
		ТаблицаДанныхARMAST = ПолучитьТаблицуДанныхARMAST();
		КоллекцияКолонокРезультата = ТаблицаДанныхARMAST.Колонки;
		
		Для каждого СтрокаТаблицы Из ТаблицаДанныхARMAST Цикл
			
			Для каждого ТекКолонка Из КоллекцияКолонокРезультата Цикл
				
				ТекЗначение = СтрокаТаблицы[ТекКолонка.Имя];
				Command.Parameters("@" + ТекКолонка.Имя).Value = ?(ТипЗнч(ТекЗначение) = Тип("Строка"), СокрЛП(ТекЗначение), ТекЗначение);
				
			КонецЦикла;
			
			Command.Execute();
			
		КонецЦикла;
		
		АдресФайлаВХранилищеARMAST = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу), УникальныйИдентификатор);
		
		// Закрываем соединение
		Command = Неопределено;
		Connection.Close();
		Connection = Неопределено;
		
		УдалитьФайлы(ИмяКаталога);
		
	Иначе 
		
		ТаблицаДанныхARMAST = ПолучитьТаблицуДанныхARMAST();
		
		Для Каждого Запись Из ТаблицаДанныхARMAST Цикл 
			
			ВнешниеИсточникиДанных.ERM_GP.dbo_insert_ARMAST(
				Запись.CUSTNO,
				Запись.INVNO,
				Запись.INVDTE,
				Запись.BALANCE,
				Запись.INVAMT,
				Запись.ARSTAT,
				Запись.TRANCURR,
				Запись.TRANORIG,
				Запись.TRANBAL,
				Запись.LOCORIG,
				Запись.LOCBAL,
				Запись.FLEXFIELD5,
				Запись.FLEXFIELD10,
				Запись.FLEXFIELD11,
				Запись.FLEXFIELD12,
				Запись.FLEXFIELD13,
				Запись.FLEXFIELD14,
				Запись.FLEXFIELD15,
				Запись.DIVCODE,
				Запись.DIVISION,
				Запись.FLEXDATE1,
				Запись.FLEXFIELD7,
				Запись.FLEXFIELD8,
				Запись.FLEXNUM2,
				Запись.PNET,
				Запись.SALESAREA,
				Объект.LastBatchID);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьARCASH()
	
	Если ToFile Тогда 
		
		ОписаниеСтруктурыARCASH = ПолучитьОписаниеСтруктурыПриемника("ARCASH");
		
		ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
		СоздатьКаталог(ИмяКаталога);
		ПутьКФайлу = ИмяКаталога + "\ARCASH.txt";
		
		ПутьСхемы = ИмяКаталога+"\schema.ini";
		ФайлСхемы = Новый ТекстовыйДокумент;
		ФайлСхемы.УстановитьТекст(ПолучитьТекстФайлаСхемы("ARCASH", ОписаниеСтруктурыARCASH, ФорматФайла));
		ФайлСхемы.Записать(ПутьСхемы, КодировкаТекста.OEM);
		
		Connection = Новый COMОбъект("ADODB.Connection");
		
		Попытка
			СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=No;IMEX=0;Readonly=False""";
			Connection.CursorLocation = 3;
			Connection.Mode = 3;
			Connection.Open(СтрокаПодключения);
		Исключение
			Попытка
				СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=No;IMEX=0;Readonly=False""";
				Connection.Mode = 3;
				Connection.Open(СтрокаПодключения);
			Исключение
				ВызватьИсключение "Can't open connection! " + ОписаниеОшибки();
			КонецПопытки;
		КонецПопытки;
		
		// создадим таблицу
		Connection.Execute(ПолучитьТекстКомандыСозданияТаблицы("ARCASH", ОписаниеСтруктурыARCASH));
		
		Command = Новый COMОбъект("ADODB.Command");
		Command.ActiveConnection = Connection;
		Command.CommandType = 1;
		
		Command.CommandText = ПолучитьТекстКомандыЗапроса("ARCASH", ОписаниеСтруктурыARCASH);
		СоздатьКоллекциюПараметровКоманды(Command, ОписаниеСтруктурыARCASH);
		
		ТаблицаДанныхARCASH = ПолучитьТаблицуДанныхARCASH();
		КоллекцияКолонокРезультата = ТаблицаДанныхARCASH.Колонки;
		
		Для каждого СтрокаТаблицы Из ТаблицаДанныхARCASH Цикл
			
			Для каждого ТекКолонка Из КоллекцияКолонокРезультата Цикл
				
				ТекЗначение = СтрокаТаблицы[ТекКолонка.Имя];
				Command.Parameters("@" + ТекКолонка.Имя).Value = ?(ТипЗнч(ТекЗначение) = Тип("Строка"), СокрЛП(ТекЗначение), ТекЗначение);
				
			КонецЦикла;
			
			Command.Execute();
			
		КонецЦикла;
		
		АдресФайлаВХранилищеARCASH = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу), УникальныйИдентификатор);
		
		// Закрываем соединение
		Command = Неопределено;
		Connection.Close();
		Connection = Неопределено;
		
		УдалитьФайлы(ИмяКаталога);
		
	Иначе 
		
		ТаблицаДанныхARCASH = ПолучитьТаблицуДанныхARCASH();
		
		Для Каждого Запись Из ТаблицаДанныхARCASH Цикл 
			
			ВнешниеИсточникиДанных.ERM_GP.dbo_insert_ARCASH(
				Запись.CUSTNO,
				Запись.INVNO,
				Запись.BATCH_NO,
				Запись.CURRCODE,
				Запись.RECEIPT_NUM,
				Запись.RECEIPT_AMT,
				Запись.DEPOSIT_DATE,
				Запись.DEPOSIT_DISCR,
				Запись.APP_AMT,
				Запись.APP_DATE,
				Запись.OPERATION,
				Запись.TYPE_IND,
				Объект.LastBatchID);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуДанныхARCUST()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВнутренниеКурсыВалютСрезПоследних.Валюта КАК Валюта,
	|	ВнутренниеКурсыВалютСрезПоследних.Курс КАК Курс,
	|	ВнутренниеКурсыВалютСрезПоследних.Кратность КАК Кратность
	|ПОМЕСТИТЬ ВТ_ВнутренниеКурсыВалют
	|ИЗ
	|	РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(, ) КАК ВнутренниеКурсыВалютСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	BilledARОстатки.Source,
	|	BilledARОстатки.Client,
	|	BilledARОстатки.Currency КАК Currency,
	|	СУММА(ВЫБОР
	|			КОГДА BilledARОстатки.Currency = &ВалютаUSD
	|				ТОГДА BilledARОстатки.AmountОстаток
	|			ИНАЧЕ ВЫРАЗИТЬ(BilledARОстатки.AmountОстаток / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность КАК ЧИСЛО(15, 2))
	|		КОНЕЦ) КАК BALANCE,
	|	BilledARОстатки.Company.Код,
	|	BilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode КАК CountryCode,
	|	BilledARОстатки.Invoice.ClientID КАК ClientID,
	|	BilledARОстатки.Invoice
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.BilledAR.Остатки(
	|			,
	|			Source В (&Sources)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)) КАК BilledARОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВнутренниеКурсыВалют КАК ВТ_ВнутренниеКурсыВалют
	|		ПО BilledARОстатки.Currency = ВТ_ВнутренниеКурсыВалют.Валюта
	|
	|СГРУППИРОВАТЬ ПО
	|	BilledARОстатки.Source,
	|	BilledARОстатки.Client,
	|	BilledARОстатки.Currency,
	|	BilledARОстатки.Company.Код,
	|	BilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode,
	|	BilledARОстатки.Invoice.ClientID,
	|	BilledARОстатки.Invoice
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	UnbilledARОстатки.Source,
	|	UnbilledARОстатки.Client,
	|	UnbilledARОстатки.Currency,
	|	СУММА(ВЫБОР
	|			КОГДА UnbilledARОстатки.Currency = &ВалютаUSD
	|				ТОГДА UnbilledARОстатки.AmountОстаток
	|			ИНАЧЕ ВЫРАЗИТЬ(UnbilledARОстатки.AmountОстаток / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность КАК ЧИСЛО(15, 2))
	|		КОНЕЦ),
	|	UnbilledARОстатки.Company.Код,
	|	UnbilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode,
	|	UnbilledARОстатки.SalesOrder.ClientID,
	|	UnbilledARОстатки.SalesOrder
	|ИЗ
	|	РегистрНакопления.UnbilledAR.Остатки(
	|			,
	|			Source В (&Sources)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)) КАК UnbilledARОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВнутренниеКурсыВалют КАК ВТ_ВнутренниеКурсыВалют
	|		ПО UnbilledARОстатки.Currency = ВТ_ВнутренниеКурсыВалют.Валюта
	|
	|СГРУППИРОВАТЬ ПО
	|	UnbilledARОстатки.Source,
	|	UnbilledARОстатки.Client,
	|	UnbilledARОстатки.Currency,
	|	UnbilledARОстатки.Company.Код,
	|	UnbilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode,
	|	UnbilledARОстатки.SalesOrder.ClientID,
	|	UnbilledARОстатки.SalesOrder
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	UnallocatedCashОстатки.Source,
	|	UnallocatedCashОстатки.Client,
	|	UnallocatedCashОстатки.Currency,
	|	СУММА(ВЫБОР
	|			КОГДА UnallocatedCashОстатки.Currency = &ВалютаUSD
	|				ТОГДА UnallocatedCashОстатки.AmountОстаток
	|			ИНАЧЕ ВЫРАЗИТЬ(UnallocatedCashОстатки.AmountОстаток / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность КАК ЧИСЛО(15, 2))
	|		КОНЕЦ),
	|	UnallocatedCashОстатки.Company.Код,
	|	UnallocatedCashОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode,
	|	UnallocatedCashОстатки.CashBatch.ClientID,
	|	UnallocatedCashОстатки.CashBatch
	|ИЗ
	|	РегистрНакопления.UnallocatedCash.Остатки(
	|			,
	|			Source В (&Sources)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)) КАК UnallocatedCashОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВнутренниеКурсыВалют КАК ВТ_ВнутренниеКурсыВалют
	|		ПО UnallocatedCashОстатки.Currency = ВТ_ВнутренниеКурсыВалют.Валюта
	|
	|СГРУППИРОВАТЬ ПО
	|	UnallocatedCashОстатки.Source,
	|	UnallocatedCashОстатки.Client,
	|	UnallocatedCashОстатки.Currency,
	|	UnallocatedCashОстатки.Company.Код,
	|	UnallocatedCashОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode,
	|	UnallocatedCashОстатки.CashBatch.ClientID,
	|	UnallocatedCashОстатки.CashBatch
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТипыСоответствий.Ссылка,
	|	ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент,
	|	"""",
	|	0,
	|	"""",
	|	"""",
	|	"""",
	|	НЕОПРЕДЕЛЕНО
	|ИЗ
	|	РегистрСведений.ИерархияКонтрагентов.СрезПоследних КАК ИерархияКонтрагентовСрезПоследних,
	|	Перечисление.ТипыСоответствий КАК ТипыСоответствий
	|ГДЕ
	|	ЛОЖЬ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	UnallocatedCash.Source,
	|	UnallocatedCash.Client,
	|	МАКСИМУМ(UnallocatedCash.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_МаксимальныеДатыОплаты
	|ИЗ
	|	РегистрНакопления.UnallocatedCash КАК UnallocatedCash
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО UnallocatedCash.Source = ВТ_Остатки.Source
	|			И UnallocatedCash.Client = ВТ_Остатки.Client
	|			И (UnallocatedCash.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
	|			И (UnallocatedCash.Активность)
	|
	|СГРУППИРОВАТЬ ПО
	|	UnallocatedCash.Source,
	|	UnallocatedCash.Client
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	UnallocatedCash.Source КАК Source,
	|	UnallocatedCash.Client КАК Client,
	|	МАКСИМУМ(UnallocatedCash.CashBatch) КАК CashBatch,
	|	UnallocatedCash.Период
	|ПОМЕСТИТЬ ВТ_МаксимальныеРегистраторыОплаты
	|ИЗ
	|	РегистрНакопления.UnallocatedCash КАК UnallocatedCash
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_МаксимальныеДатыОплаты КАК ВТ_МаксимальныеДатыОплаты
	|		ПО UnallocatedCash.Source = ВТ_МаксимальныеДатыОплаты.Source
	|			И UnallocatedCash.Client = ВТ_МаксимальныеДатыОплаты.Client
	|			И UnallocatedCash.Период = ВТ_МаксимальныеДатыОплаты.Период
	|			И (UnallocatedCash.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
	|			И (UnallocatedCash.Активность)
	|
	|СГРУППИРОВАТЬ ПО
	|	UnallocatedCash.Source,
	|	UnallocatedCash.Client,
	|	UnallocatedCash.Период
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	UnallocatedCash.Source КАК Source,
	|	UnallocatedCash.Client КАК Client,
	|	UnallocatedCash.Период КАК Период,
	|	UnallocatedCash.Currency КАК Currency,
	|	СУММА(UnallocatedCash.Amount) КАК Amount
	|ПОМЕСТИТЬ ВТ_ДанныеПоследнейОплаты
	|ИЗ
	|	РегистрНакопления.UnallocatedCash КАК UnallocatedCash
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_МаксимальныеРегистраторыОплаты КАК ВТ_МаксимальныеРегистраторыОплаты
	|		ПО UnallocatedCash.Source = ВТ_МаксимальныеРегистраторыОплаты.Source
	|			И UnallocatedCash.Client = ВТ_МаксимальныеРегистраторыОплаты.Client
	|			И UnallocatedCash.CashBatch = ВТ_МаксимальныеРегистраторыОплаты.CashBatch
	|			И (UnallocatedCash.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход))
	|			И (UnallocatedCash.Активность)
	|			И (UnallocatedCash.Период = ВТ_МаксимальныеРегистраторыОплаты.Период)
	|
	|СГРУППИРОВАТЬ ПО
	|	UnallocatedCash.Source,
	|	UnallocatedCash.Client,
	|	UnallocatedCash.Период,
	|	UnallocatedCash.Currency
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВложенныйЗапрос.Source,
	|	ВложенныйЗапрос.Client,
	|	МАКСИМУМ(ВложенныйЗапрос.Период) КАК Период
	|ПОМЕСТИТЬ ВТ_ДатыПоследнихТранзакций
	|ИЗ
	|	(ВЫБРАТЬ
	|		UnbilledARОбороты.Период КАК Период,
	|		UnbilledARОбороты.Client КАК Client,
	|		UnbilledARОбороты.Source КАК Source
	|	ИЗ
	|		РегистрНакопления.UnbilledAR.Обороты(
	|				,
	|				,
	|				День,
	|				(Client, Source) В
	|					(ВЫБРАТЬ
	|						ВТ_Остатки.Client,
	|						ВТ_Остатки.Source
	|					ИЗ
	|						ВТ_Остатки КАК ВТ_Остатки)) КАК UnbilledARОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		BilledARОбороты.Период,
	|		BilledARОбороты.Client,
	|		BilledARОбороты.Source
	|	ИЗ
	|		РегистрНакопления.BilledAR.Обороты(
	|				,
	|				,
	|				День,
	|				(Client, Source) В
	|					(ВЫБРАТЬ
	|						ВТ_Остатки.Client,
	|						ВТ_Остатки.Source
	|					ИЗ
	|						ВТ_Остатки КАК ВТ_Остатки)) КАК BilledARОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		UnallocatedCashОбороты.Период,
	|		UnallocatedCashОбороты.Client,
	|		UnallocatedCashОбороты.Source
	|	ИЗ
	|		РегистрНакопления.UnallocatedCash.Обороты(
	|				,
	|				,
	|				День,
	|				(Client, Source) В
	|					(ВЫБРАТЬ
	|						ВТ_Остатки.Client,
	|						ВТ_Остатки.Source
	|					ИЗ
	|						ВТ_Остатки КАК ВТ_Остатки)) КАК UnallocatedCashОбороты) КАК ВложенныйЗапрос
	|
	|СГРУППИРОВАТЬ ПО
	|	ВложенныйЗапрос.Source,
	|	ВложенныйЗапрос.Client
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Остатки.Client,
	|	МАКСИМУМ(КонтактныеЛица.Ссылка) КАК КонтактноеЛицо
	|ПОМЕСТИТЬ ВТ_КонтактныеЛица
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица КАК КонтактныеЛица
	|		ПО ВТ_Остатки.Client = КонтактныеЛица.ОбъектВладелец
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Остатки.Client
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВТ_Остатки.Client,
	|	ОсновныеДоговорыКонтрагента.Договор.ВалютаВзаиморасчетов.Наименование КАК ВалютаВзаиморасчетов
	|ПОМЕСТИТЬ ВТ_ВалютаОсновныхДоговоров
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ОсновныеДоговорыКонтрагента КАК ОсновныеДоговорыКонтрагента
	|		ПО ВТ_Остатки.Client = ОсновныеДоговорыКонтрагента.Контрагент
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Остатки.Client,
	|	ОсновныеДоговорыКонтрагента.Договор.ВалютаВзаиморасчетов.Наименование
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.ClientID ЕСТЬ NULL
	|			ТОГДА """"
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВТ_Остатки.ClientID + ""-101""
	|		ИНАЧЕ ВТ_Остатки.ClientID
	|	КОНЕЦ КАК CUSTNO,
	|	ВТ_Остатки.Client.CRMID КАК PARENT,
	|	ВТ_Остатки.Client.Наименование КАК COMPANY,
	|	ВТ_Остатки.Client.CreditLimit КАК CRD_LIMIT,
	|	ВТ_Остатки.CompanyКод КАК CompanyКод,
	|	ВТ_Остатки.CountryCode КАК CountryCode,
	|	СУММА(ВТ_Остатки.BALANCE) КАК BALANCE,
	|	""RC13"" КАК TERR,
	|	ЕСТЬNULL(ВТ_ДанныеПоследнейОплаты.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК LASTPAY,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(ВТ_ДанныеПоследнейОплаты.Amount, 0) / ВТ_ВнутренниеКурсыВалют1.Курс * ВТ_ВнутренниеКурсыВалют1.Кратность КАК ЧИСЛО(15, 2)) КАК LASTAMT,
	|	ЕСТЬNULL(ВТ_ДатыПоследнихТранзакций.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК LDATE,
	|	ЕСТЬNULL(ВТ_КонтактныеЛица.КонтактноеЛицо.Имя, """") КАК FIRSTNAME,
	|	ЕСТЬNULL(ВТ_КонтактныеЛица.КонтактноеЛицо.Фамилия, """") КАК LASTNAME,
	|	"""" КАК ARCOMMENT,
	|	"""" КАК REFKEY1,
	|	"""" КАК REFKEY2,
	|	"""" КАК CREDITSCOR,
	|	"""" КАК RESOLVER01,
	|	"""" КАК RESOLVER02,
	|	"""" КАК RESOLVER03,
	|	"""" КАК RESOLVER04,
	|	"""" КАК RESOLVER05,
	|	"""" КАК RESOLVER06,
	|	"""" КАК RESOLVER07,
	|	"""" КАК RESOLVER08,
	|	"""" КАК RESOLVER09,
	|	"""" КАК RESOLVER10,
	|	0 КАК HIGHBAL,
	|	0 КАК LASTYSALES,
	|	0 КАК LASTQSALES,
	|	"""" КАК DUNS,
	|	"""" КАК ULTIMATEDUNS,
	|	"""" КАК FEDID,
	|	"""" КАК BNKRTNUM,
	|	0 КАК YTDSALES,
	|	0 КАК LTDSALES,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК FINYE,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК LCVDTE,
	|	"""" КАК CREDIT_ACCT,
	|	"""" КАК TICKER,
	|	"""" КАК SIC_CODE,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК CRSCDT,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК CRSTDT,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК CRLIDT,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК EXPCRDLMTDTE,
	|	"""" КАК ARBDR,
	|	"""" КАК CMACCT_ID,
	|	"""" КАК REQ_SATISFIED,
	|	"""" КАК CMPARENT,
	|	"""" КАК SMS_PHONE,
	|	0 КАК RELORDERS,
	|	0 КАК PENDINGORD,
	|	"""" КАК SLPNEMAIL,
	|	"""" КАК SLPN_LANG_ID,
	|	0 КАК PAY_INST_TOTAL,
	|	0 КАК PAY_INST_TOTAL_AMT,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК PAY_INST_NEXT_DATE,
	|	0 КАК PAY_INST_NEXT_AMT,
	|	ВТ_Остатки.Client.crmCountry КАК COUNTRY,
	|	ВТ_Остатки.Client.crmCity КАК CITY,
	|	ВТ_Остатки.Client.crmStreetAddress КАК ADDRESS1,
	|	ЕСТЬNULL(ВТ_ВалютаОсновныхДоговоров.ВалютаВзаиморасчетов, ""RUB"") КАК LOCCURR
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияКонтрагентов.СрезПоследних(
	|				,
	|				Контрагент В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ВТ_Остатки.Client
	|					ИЗ
	|						ВТ_Остатки КАК ВТ_Остатки)) КАК ИерархияКонтрагентовСрезПоследних
	|		ПО ВТ_Остатки.Client = ИерархияКонтрагентовСрезПоследних.Контрагент
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВнутренниеКурсыВалют КАК ВТ_ВнутренниеКурсыВалют
	|		ПО ВТ_Остатки.Currency = ВТ_ВнутренниеКурсыВалют.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДанныеПоследнейОплаты КАК ВТ_ДанныеПоследнейОплаты
	|			ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВнутренниеКурсыВалют КАК ВТ_ВнутренниеКурсыВалют1
	|			ПО ВТ_ДанныеПоследнейОплаты.Currency = ВТ_ВнутренниеКурсыВалют1.Валюта
	|		ПО ВТ_Остатки.Source = ВТ_ДанныеПоследнейОплаты.Source
	|			И ВТ_Остатки.Client = ВТ_ДанныеПоследнейОплаты.Client
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ДатыПоследнихТранзакций КАК ВТ_ДатыПоследнихТранзакций
	|		ПО ВТ_Остатки.Source = ВТ_ДатыПоследнихТранзакций.Source
	|			И ВТ_Остатки.Client = ВТ_ДатыПоследнихТранзакций.Client
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_КонтактныеЛица КАК ВТ_КонтактныеЛица
	|		ПО ВТ_Остатки.Client = ВТ_КонтактныеЛица.Client
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВалютаОсновныхДоговоров КАК ВТ_ВалютаОсновныхДоговоров
	|		ПО ВТ_Остатки.Client = ВТ_ВалютаОсновныхДоговоров.Client
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Остатки.Client.CRMID,
	|	ВТ_Остатки.Client.Наименование,
	|	ВТ_Остатки.Client.CreditLimit,
	|	ВТ_Остатки.CompanyКод,
	|	ВТ_Остатки.CountryCode,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.ClientID ЕСТЬ NULL
	|			ТОГДА """"
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВТ_Остатки.ClientID + ""-101""
	|		ИНАЧЕ ВТ_Остатки.ClientID
	|	КОНЕЦ,
	|	ЕСТЬNULL(ВТ_ДанныеПоследнейОплаты.Период, ДАТАВРЕМЯ(1, 1, 1)),
	|	ВЫРАЗИТЬ(ЕСТЬNULL(ВТ_ДанныеПоследнейОплаты.Amount, 0) / ВТ_ВнутренниеКурсыВалют1.Курс * ВТ_ВнутренниеКурсыВалют1.Кратность КАК ЧИСЛО(15, 2)),
	|	ЕСТЬNULL(ВТ_ДатыПоследнихТранзакций.Период, ДАТАВРЕМЯ(1, 1, 1)),
	|	ЕСТЬNULL(ВТ_КонтактныеЛица.КонтактноеЛицо.Фамилия, """"),
	|	ЕСТЬNULL(ВТ_КонтактныеЛица.КонтактноеЛицо.Имя, """"),
	|	ВТ_Остатки.Client.crmCountry,
	|	ВТ_Остатки.Client.crmCity,
	|	ВТ_Остатки.Client.crmStreetAddress,
	|	ЕСТЬNULL(ВТ_ВалютаОсновныхДоговоров.ВалютаВзаиморасчетов, ""RUB"")";
	
	Sources = Новый Массив;
	//Sources.Добавить(Перечисления.ТипыСоответствий.Lawson);
	//Sources.Добавить(Перечисления.ТипыСоответствий.OracleMI);
	Sources.Добавить(Перечисления.ТипыСоответствий.HOBs);
	Запрос.УстановитьПараметр("Sources", Sources);
	Запрос.УстановитьПараметр("ВалютаUSD", Константы.rgsВалютаUSD.Получить());
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		Если ЗначениеЗаполнено(СтрокаТаблицы.CUSTNO) Тогда
			СтрокаТаблицы.CUSTNO = СтрокаТаблицы.CUSTNO + "-" + СтрокаТаблицы.CountryCode + "-" + Строка(СтрокаТаблицы.CompanyКод);
		КонецЕсли;
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Удалить("CompanyКод");
	ТаблицаДанных.Колонки.Удалить("CountryCode");
	
	Возврат ТаблицаДанных;
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуДанныхARMAST()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	BilledARОстатки.Client.Код КАК CUSTNO,
	|	BilledARОстатки.Invoice.DocNumber КАК INVNO,
	|	BilledARОстатки.AmountОстаток КАК BALANCE,
	|	BilledARОстатки.Invoice.Amount КАК INVAMT,
	|	""I"" КАК ARSTAT,
	|	BilledARОстатки.Invoice.Amount КАК TRANORIG,
	|	BilledARОстатки.AmountОстаток КАК TRANBAL,
	|	BilledARОстатки.Invoice.Amount КАК LOCORIG,
	|	BilledARОстатки.AmountОстаток КАК LOCBAL,
	|	BilledARОстатки.Source КАК Source,
	|	BilledARОстатки.Client КАК Client,
	|	BilledARОстатки.Invoice КАК Invoice,
	|	BilledARОстатки.Company КАК Company,
	|	BilledARОстатки.Currency КАК Currency,
	|	BilledARОстатки.Invoice.Дата КАК INVDTE,
	|	BilledARОстатки.Invoice.Currency.Наименование КАК TRANCURR,
	|	BilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode КАК CountryCode,
	|	BilledARОстатки.Invoice.ClientID КАК ClientID,
	|	BilledARОстатки.SubSubSegment.БазовыйЭлемент.Код КАК SubSubSegment,
	|	BilledARОстатки.SubSubSegment.БазовыйЭлемент.Родитель.Код КАК SubSegment,
	|	BilledARОстатки.SubSubSegment.БазовыйЭлемент.Родитель.Родитель.Код КАК Segment,
	|	BilledARОстатки.Company.Код КАК CompanyКод,
	|	BilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.GetPaidCode КАК DIVISION,
	|	BilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.GetPaidCode КАК DIVCODE,
	|	BilledARОстатки.Location.MgmtCountryCode КАК SALESAREA,
	|	NULL КАК JobEndDate,
	|	BilledARОстатки.Location.БазовыйЭлемент.Код КАК FLEXFIELD8,
	|	BilledARОстатки.Invoice.Responsible КАК FLEXFIELD6
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.BilledAR.Остатки(
	|			,
	|			Source В (&Sources)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)) КАК BilledARОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	UnallocatedCashОстатки.Client.Код,
	|	UnallocatedCashОстатки.CashBatch.PaymentNumber,
	|	UnallocatedCashОстатки.AmountОстаток,
	|	UnallocatedCashОстатки.CashBatch.Amount,
	|	""U"",
	|	UnallocatedCashОстатки.CashBatch.Amount,
	|	UnallocatedCashОстатки.AmountОстаток,
	|	UnallocatedCashОстатки.CashBatch.Amount,
	|	UnallocatedCashОстатки.AmountОстаток,
	|	UnallocatedCashОстатки.Source,
	|	UnallocatedCashОстатки.Client,
	|	UnallocatedCashОстатки.CashBatch,
	|	UnallocatedCashОстатки.Company,
	|	UnallocatedCashОстатки.Currency,
	|	UnallocatedCashОстатки.CashBatch.Дата,
	|	UnallocatedCashОстатки.CashBatch.Currency.Наименование,
	|	UnallocatedCashОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode,
	|	UnallocatedCashОстатки.CashBatch.ClientID,
	|	UnallocatedCashОстатки.SubSubSegment.БазовыйЭлемент.Код,
	|	UnallocatedCashОстатки.SubSubSegment.БазовыйЭлемент.Родитель.Код,
	|	UnallocatedCashОстатки.SubSubSegment.БазовыйЭлемент.Родитель.Родитель.Код,
	|	UnallocatedCashОстатки.Company.Код,
	|	UnallocatedCashОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.GetPaidCode,
	|	UnallocatedCashОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.GetPaidCode,
	|	UnallocatedCashОстатки.Location.MgmtCountryCode,
	|	NULL,
	|	UnallocatedCashОстатки.Location.БазовыйЭлемент.Код,
	|	UnallocatedCashОстатки.CashBatch.Responsible
	|ИЗ
	|	РегистрНакопления.UnallocatedCash.Остатки(
	|			,
	|			Source В (&Sources)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)) КАК UnallocatedCashОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	UnbilledARОстатки.Client.Код,
	|	UnbilledARОстатки.SalesOrder.Номер,
	|	UnbilledARОстатки.AmountОстаток,
	|	UnbilledARОстатки.SalesOrder.Amount,
	|	""O"",
	|	UnbilledARОстатки.SalesOrder.Amount,
	|	UnbilledARОстатки.AmountОстаток,
	|	UnbilledARОстатки.SalesOrder.Amount,
	|	UnbilledARОстатки.AmountОстаток,
	|	UnbilledARОстатки.Source,
	|	UnbilledARОстатки.Client,
	|	UnbilledARОстатки.SalesOrder,
	|	UnbilledARОстатки.Company,
	|	UnbilledARОстатки.Currency,
	|	UnbilledARОстатки.SalesOrder.Дата,
	|	UnbilledARОстатки.SalesOrder.Currency.Наименование,
	|	UnbilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode,
	|	UnbilledARОстатки.SalesOrder.ClientID,
	|	UnbilledARОстатки.SubSubSegment.БазовыйЭлемент.Код,
	|	UnbilledARОстатки.SubSubSegment.БазовыйЭлемент.Родитель.Код,
	|	UnbilledARОстатки.SubSubSegment.БазовыйЭлемент.Родитель.Родитель.Код,
	|	UnbilledARОстатки.Company.Код,
	|	UnbilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.GetPaidCode,
	|	UnbilledARОстатки.Location.БазовыйЭлемент.GeoMarket.Родитель.GetPaidCode,
	|	UnbilledARОстатки.Location.MgmtCountryCode,
	|	UnbilledARОстатки.SalesOrder.JobEndDate,
	|	UnbilledARОстатки.Location.БазовыйЭлемент.Код,
	|	UnbilledARОстатки.SalesOrder.Responsible
	|ИЗ
	|	РегистрНакопления.UnbilledAR.Остатки(
	|			,
	|			Source В (&Sources)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)) КАК UnbilledARОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВнутренниеКурсыВалютСрезПоследних.Валюта,
	|	ВнутренниеКурсыВалютСрезПоследних.Курс,
	|	ВнутренниеКурсыВалютСрезПоследних.Кратность
	|ПОМЕСТИТЬ ВТ_ВнутренниеКурсыВалют
	|ИЗ
	|	РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(
	|			,
	|			Валюта В
	|				(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|					ВТ_Остатки.Currency
	|				ИЗ
	|					ВТ_Остатки КАК ВТ_Остатки)) КАК ВнутренниеКурсыВалютСрезПоследних
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_Остатки.Invoice КАК Invoice,
	|	МАКСИМУМ(SalesOrder.JobEndDate) КАК JobEndDate
	|ПОМЕСТИТЬ ВТ_SO
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.SalesOrder КАК SalesOrder
	|		ПО ВТ_Остатки.Invoice = SalesOrder.Ссылка
	|			И (НЕ SalesOrder.ПометкаУдаления)
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_Остатки.Invoice
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.ClientID ЕСТЬ NULL 
	|				ИЛИ ВТ_Остатки.ClientID = """"
	|			ТОГДА """"
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВТ_Остатки.ClientID + ""-101""
	|		ИНАЧЕ ВТ_Остатки.ClientID
	|	КОНЕЦ КАК CUSTNO,
	|	ВТ_Остатки.INVNO КАК INVNO,
	|	ВТ_Остатки.Company.Код КАК CompanyCode,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|			ТОГДА ВТ_Остатки.BALANCE
	|		ИНАЧЕ ВЫРАЗИТЬ(ВТ_Остатки.BALANCE / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность КАК ЧИСЛО(15, 2))
	|	КОНЕЦ КАК BALANCE,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|			ТОГДА ВТ_Остатки.INVAMT
	|		ИНАЧЕ ВЫРАЗИТЬ(ВТ_Остатки.INVAMT / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность КАК ЧИСЛО(15, 2))
	|	КОНЕЦ КАК INVAMT,
	|	ВТ_Остатки.ARSTAT КАК ARSTAT,
	|	ВТ_Остатки.TRANORIG КАК TRANORIG,
	|	ВТ_Остатки.TRANBAL КАК TRANBAL,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|						ТОГДА ВТ_Остатки.INVAMT
	|					ИНАЧЕ ВЫРАЗИТЬ(ВТ_Остатки.INVAMT / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность КАК ЧИСЛО(15, 2))
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ВТ_Остатки.Currency = &ВалютаРубли
	|					ТОГДА ВТ_Остатки.INVAMT
	|				ИНАЧЕ ВЫРАЗИТЬ(ВТ_Остатки.INVAMT / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность * &КурсОтносительноРубля / &КратностьОтносительноРубля КАК ЧИСЛО(15, 2))
	|			КОНЕЦ
	|	КОНЕЦ КАК LOCORIG,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|						ТОГДА ВТ_Остатки.BALANCE
	|					ИНАЧЕ ВЫРАЗИТЬ(ВТ_Остатки.BALANCE / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность КАК ЧИСЛО(15, 2))
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ВТ_Остатки.Currency = &ВалютаРубли
	|					ТОГДА ВТ_Остатки.BALANCE
	|				ИНАЧЕ ВЫРАЗИТЬ(ВТ_Остатки.BALANCE / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность * &КурсОтносительноРубля / &КратностьОтносительноРубля КАК ЧИСЛО(15, 2))
	|			КОНЕЦ
	|	КОНЕЦ КАК LOCBAL,
	|	ВТ_Остатки.Source КАК Source,
	|	ВТ_Остатки.INVDTE КАК INVDTE,
	|	ВТ_Остатки.TRANCURR КАК TRANCURR,
	|	ВТ_Остатки.CountryCode КАК CountryCode,
	|	ВТ_Остатки.SubSubSegment КАК Flexfield5,
	|	ВТ_Остатки.SubSegment КАК Flexfield11,
	|	ВТ_Остатки.Segment КАК Flexfield13,
	|	""RCA"" КАК Flexfield15,
	|	ВТ_Остатки.CompanyКод КАК Flexfield10,
	|	ВТ_Остатки.CountryCode КАК Flexfield12,
	|	ВТ_Остатки.Invoice.Contract.PTDaysFrom КАК PNET,
	|	ВТ_Остатки.DIVISION КАК DIVISION,
	|	ВТ_Остатки.DIVCODE КАК DIVCODE,
	|	ВТ_Остатки.SALESAREA КАК SALESAREA,
	|	ВТ_ВнутренниеКурсыВалют.Курс КАК FLEXNUM2,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Invoice ССЫЛКА Документ.Invoice
	|			ТОГДА ЕСТЬNULL(ВТ_SO.JobEndDate, ДАТАВРЕМЯ(1, 1, 1))
	|		КОГДА ВТ_Остатки.Invoice ССЫЛКА Документ.SalesOrder
	|			ТОГДА ВТ_Остатки.JobEndDate
	|		ИНАЧЕ ДАТАВРЕМЯ(1, 1, 1)
	|	КОНЕЦ КАК FLEXDATE1,
	|	ЕСТЬNULL(ВТ_Остатки.Invoice.FiscalInvoiceNo, """") КАК FLEXFIELD7,
	|	ВТ_Остатки.FLEXFIELD8 КАК FLEXFIELD8,
	|	ВТ_Остатки.ClientID КАК FLEXFIELD14,
	|	ВТ_Остатки.FLEXFIELD6
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВнутренниеКурсыВалют КАК ВТ_ВнутренниеКурсыВалют
	|		ПО ВТ_Остатки.Currency = ВТ_ВнутренниеКурсыВалют.Валюта
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_SO КАК ВТ_SO
	|		ПО ВТ_Остатки.Invoice = ВТ_SO.Invoice";
	
	Sources = Новый Массив;
	//Sources.Добавить(Перечисления.ТипыСоответствий.Lawson);
	//Sources.Добавить(Перечисления.ТипыСоответствий.OracleMI);
	Sources.Добавить(Перечисления.ТипыСоответствий.HOBs);
	Запрос.УстановитьПараметр("Sources", Sources);
	
	Запрос.УстановитьПараметр("ВалютаUSD", Константы.rgsВалютаUSD.Получить());
	Рубли = Константы.rgsВалютаРуб.Получить();
	Запрос.УстановитьПараметр("ВалютаРубли", Рубли);
	СтруктураКурса = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(Рубли, ТекущаяДата());
	Запрос.УстановитьПараметр("КурсОтносительноРубля", СтруктураКурса.Курс);
	Запрос.УстановитьПараметр("КратностьОтносительноРубля", СтруктураКурса.Кратность);
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		Если СтрокаТаблицы.Source = Перечисления.ТипыСоответствий.Lawson И СтрокаТаблицы.ARSTAT = "I" Тогда
			СтрокаТаблицы.INVNO = "I-" + СтрокаТаблицы.INVNO + "-" + Строка(СтрокаТаблицы.CompanyCode);
		ИначеЕсли СтрокаТаблицы.Source = Перечисления.ТипыСоответствий.HOBs Тогда
			СтрокаТаблицы.INVNO = СтрокаТаблицы.ARSTAT + "-" + Строка(СтрокаТаблицы.CompanyCode) + "-" + СтрокаТаблицы.INVNO;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.CUSTNO) Тогда
			СтрокаТаблицы.CUSTNO = СтрокаТаблицы.CUSTNO + "-" + СтрокаТаблицы.CountryCode + "-" + Строка(СтрокаТаблицы.CompanyCode);
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Удалить("CompanyCode");
	ТаблицаДанных.Колонки.Удалить("Source");
	ТаблицаДанных.Колонки.Удалить("CountryCode");
	
	Возврат ТаблицаДанных;
	
КонецФункции

&НаСервере
Функция ПолучитьТаблицуДанныхARCASH()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	PaymentsОбороты.CashBatch.ClientID КАК CUSTNO,
	|	PaymentsОбороты.Invoice.DocNumber КАК INVNO,
	|	PaymentsОбороты.CashBatch.Номер КАК BATCH_NO,
	|	PaymentsОбороты.Currency.Наименование КАК CURRCODE,
	|	PaymentsОбороты.CashBatch.Номер КАК RECEIPT_NUM,
	|	PaymentsОбороты.AmountОборот КАК RECEIPT_AMT,
	|	ДАТАВРЕМЯ(1, 1, 1) КАК DEPOSIT_DATE,
	|	""001"" КАК DEPOSIT_DISCR,
	|	PaymentsОбороты.CashBatch.Amount КАК APP_AMT,
	|	PaymentsОбороты.CashBatch.Дата КАК APP_DATE,
	|	1 КАК OPERATION,
	|	""C"" КАК TYPE_IND,
	|	PaymentsОбороты.Company.Код КАК CompanyCode,
	|	PaymentsОбороты.Location.БазовыйЭлемент.GeoMarket.Родитель.CountryCode КАК CountryCode,
	|	PaymentsОбороты.Source,
	|	""I"" КАК ARSTAT
	|ИЗ
	|	РегистрНакопления.Payments.Обороты(
	|			&НачалоПериода,
	|			,
	|			,
	|			Source В (&Sources)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|				И Client <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)) КАК PaymentsОбороты
	|ГДЕ
	|	PaymentsОбороты.AmountОборот >= 0";
	
	Sources = Новый Массив;
	//Sources.Добавить(Перечисления.ТипыСоответствий.Lawson);
	//Sources.Добавить(Перечисления.ТипыСоответствий.OracleMI);
	Sources.Добавить(Перечисления.ТипыСоответствий.HOBs);
	Запрос.УстановитьПараметр("Sources", Sources);
	
	Запрос.УстановитьПараметр("НачалоПериода", Константы.rgsДатаЗакрытияHOB.Получить());
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
	Для каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		Если СтрокаТаблицы.Source = Перечисления.ТипыСоответствий.Lawson И СтрокаТаблицы.ARSTAT = "I" Тогда
			СтрокаТаблицы.INVNO = "I-" + СтрокаТаблицы.INVNO + "-" + Строка(СтрокаТаблицы.CompanyCode);
		ИначеЕсли СтрокаТаблицы.Source = Перечисления.ТипыСоответствий.HOBs Тогда
			СтрокаТаблицы.INVNO = СтрокаТаблицы.ARSTAT + "-" + Строка(СтрокаТаблицы.CompanyCode) + "-" + СтрокаТаблицы.INVNO;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.CUSTNO) Тогда
			СтрокаТаблицы.CUSTNO = СтрокаТаблицы.CUSTNO + "-" + СтрокаТаблицы.CountryCode + "-" + Строка(СтрокаТаблицы.CompanyCode);
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Удалить("CompanyCode");
	ТаблицаДанных.Колонки.Удалить("CountryCode");
	ТаблицаДанных.Колонки.Удалить("Source");
	ТаблицаДанных.Колонки.Удалить("ARSTAT");
	
	Возврат ТаблицаДанных;
	
КонецФункции

&НаСервере
Процедура СоздатьКоллекциюПараметровКоманды(Command, Знач ОписаниеСтруктурыПриемника)
	
	Для каждого ЭлементСтруктурыПриемника Из ОписаниеСтруктурыПриемника Цикл
		
		Параметр = Command.CreateParameter("@" + ЭлементСтруктурыПриемника.ИмяПоля, ЭлементСтруктурыПриемника.ТипПараметраЗапросаЧисло, 1, ЭлементСтруктурыПриемника.Ширина);
		Если ЭлементСтруктурыПриемника.Разрядность <> 0 Тогда
			Параметр.Precision = ЭлементСтруктурыПриемника.Разрядность;
		КонецЕсли;
		// определим значение по-умолчанию
		Параметр.Value = ПолучитьЗначениеТипаПоУмолчанию(ЭлементСтруктурыПриемника.Тип);
		Command.Parameters.Append(Параметр);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОписаниеСтруктурыПриемника(ИмяПриемникаДанных)
	
	ОписаниеСтруктурыПриемника = Новый ТаблицаЗначений;
	ОписаниеСтруктурыПриемника.Колонки.Добавить("ИмяПоля");
	ОписаниеСтруктурыПриемника.Колонки.Добавить("Тип");
	ОписаниеСтруктурыПриемника.Колонки.Добавить("Ширина");
	ОписаниеСтруктурыПриемника.Колонки.Добавить("Разрядность");
	ОписаниеСтруктурыПриемника.Колонки.Добавить("ТипПараметраЗапроса");
	ОписаниеСтруктурыПриемника.Колонки.Добавить("ТипПараметраЗапросаЧисло");
	ОписаниеСтруктурыПриемника.Колонки.Добавить("ТипПоляСхемы");
	
	Макет = Обработки.PushARDataToGetPaid.ПолучитьМакет(ИмяПриемникаДанных);
	
	ВысотаТаблицы = Макет.ВысотаТаблицы;
	
	Для ТекНомерСтроки = 2 По ВысотаТаблицы Цикл
		
		ИмяПоля = Макет.Область(ТекНомерСтроки, 1).Текст;
		ТипПоля = Макет.Область(ТекНомерСтроки, 2).Текст;
		ШиринаПоля = Число(Макет.Область(ТекНомерСтроки, 3).Текст);
		РазрядностьПоля = Число(Макет.Область(ТекНомерСтроки, 4).Текст);
		
		НоваяСтрокаОписания = ОписаниеСтруктурыПриемника.Добавить();
		НоваяСтрокаОписания.ИмяПоля = ИмяПоля;
		НоваяСтрокаОписания.Тип = ТипПоля;
		НоваяСтрокаОписания.Ширина = ШиринаПоля;
		НоваяСтрокаОписания.Разрядность = РазрядностьПоля;
		НоваяСтрокаОписания.ТипПараметраЗапроса = ПолучитьТипПараметраЗапроса(ТипПоля, ШиринаПоля, РазрядностьПоля);
		НоваяСтрокаОписания.ТипПараметраЗапросаЧисло = ПолучитьТипПараметраЗапросаЧисло(ТипПоля, РазрядностьПоля);
		НоваяСтрокаОписания.ТипПоляСхемы = ПолучитьТипПоляСхемы(ТипПоля, РазрядностьПоля);
		
	КонецЦикла;
	
	Возврат ОписаниеСтруктурыПриемника;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстФайлаСхемы(Знач ИмяПриемникаДанных, Знач ОписаниеСтруктурыПриемника, Знач ФорматФайла)
	
	ТекстФайлаСхемы = "[" + ИмяПриемникаДанных + ".txt]" + Символы.ПС;
	
	// настройки формата
	ТекстФайлаСхемы = ТекстФайлаСхемы + "Format=" + ФорматФайла + Символы.ПС;
	//ТекстФайлаСхемы = ТекстФайлаСхемы + "Format=TabDelimited" + Символы.ПС;
	ТекстФайлаСхемы = ТекстФайлаСхемы + "DecimalSymbol=." + Символы.ПС;
	ТекстФайлаСхемы = ТекстФайлаСхемы + "DateTimeFormat=""MM/DD/YY""" + Символы.ПС;
	
	// колонки
	ТекНомерКолонки = 1;
	Для каждого ЭлементСтруктурыПриемника Из ОписаниеСтруктурыПриемника Цикл
		
		ТекстФайлаСхемы = ТекстФайлаСхемы + "Col" + Строка(ТекНомерКолонки) 
			+ "=" + ЭлементСтруктурыПриемника.ИмяПоля + " " 
			+ ЭлементСтруктурыПриемника.ТипПоляСхемы + " Width "
			+ Строка(ЭлементСтруктурыПриемника.Ширина) + Символы.ПС;
			
		ТекНомерКолонки = ТекНомерКолонки + 1;
		
	КонецЦикла;
	
	Возврат ТекстФайлаСхемы;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстКомандыЗапроса(Знач ИмяПриемникаДанных, Знач ОписаниеСтруктурыПриемника)
	
	ТекстКомандыЧасть1 = "PARAMETERS ";
	ТекстКомандыЧасть2 = "INSERT INTO [" + ИмяПриемникаДанных + "] VALUES (";
	
	Для каждого ЭлементСтруктурыПриемника Из ОписаниеСтруктурыПриемника Цикл
		
		ТекстКомандыЧасть1 = ТекстКомандыЧасть1 + "@" + ЭлементСтруктурыПриемника.ИмяПоля + " "
			+ ЭлементСтруктурыПриемника.ТипПараметраЗапроса + ?(ЭлементСтруктурыПриемника.ТипПараметраЗапроса = "char", "("
			+ ЭлементСтруктурыПриемника.Ширина + ")", "") + ", ";
		
		ТекстКомандыЧасть2 = ТекстКомандыЧасть2 + "@" + ЭлементСтруктурыПриемника.ИмяПоля + ", ";
		
	КонецЦикла;
	
	ТекстКомандыЧасть1 = Лев(ТекстКомандыЧасть1, СтрДлина(ТекстКомандыЧасть1) - 2);
	ТекстКомандыЧасть2 = Лев(ТекстКомандыЧасть2, СтрДлина(ТекстКомандыЧасть2) - 2) + ")";
	
	Возврат ТекстКомандыЧасть1 + "; " + ТекстКомандыЧасть2;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстКомандыСозданияТаблицы(Знач ИмяПриемникаДанных, Знач ОписаниеСтруктурыПриемника)
	
	ТекстКоманды = "CREATE TABLE [" + ИмяПриемникаДанных + ".txt] (";
	
	Для каждого ЭлементСтруктурыПриемника Из ОписаниеСтруктурыПриемника Цикл
		
		ТекстКоманды = ТекстКоманды + ЭлементСтруктурыПриемника.ИмяПоля + " "
			+ ЭлементСтруктурыПриемника.ТипПараметраЗапроса + ?(ЭлементСтруктурыПриемника.ТипПараметраЗапроса = "char", "("
			+ ЭлементСтруктурыПриемника.Ширина + ")", "") + ", ";
		
	КонецЦикла;
	
	ТекстКоманды = Лев(ТекстКоманды, СтрДлина(ТекстКоманды) - 2) + ")";
	
	Возврат ТекстКоманды;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТипПараметраЗапросаЧисло(ТипПоля, РазрядностьПоля)
	
	// TODO RGS AGorlenko 24.08.2016: переделать как вариант с кэшированием
	
	Если ТипПоля = "C" Тогда
		Возврат 129;
	ИначеЕсли ТипПоля = "D" Тогда
		Возврат 133;
	ИначеЕсли ТипПоля = "N" И РазрядностьПоля > 0 Тогда
		Возврат 5;
	ИначеЕсли ТипПоля = "N" И РазрядностьПоля = 0 Тогда
		Возврат 20; // bigint
	Иначе
		ВызватьИсключение "Unknown type " + ТипПоля;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТипПараметраЗапроса(ТипПоля, ШиринаПоля, РазрядностьПоля)
	
	// TODO RGS AGorlenko 24.08.2016: переделать как вариант с кэшированием
	
	Если ТипПоля = "C" И ШиринаПоля <= 255 Тогда
		Возврат "char";
	ИначеЕсли ТипПоля = "C" И ШиринаПоля > 255 Тогда
		Возврат "longchar";
	ИначеЕсли ТипПоля = "D" Тогда
		Возврат "date";
	ИначеЕсли ТипПоля = "N" И РазрядностьПоля > 0 Тогда
		Возврат "double";
	ИначеЕсли ТипПоля = "N" И РазрядностьПоля = 0 Тогда
		Возврат "integer";
	Иначе
		ВызватьИсключение "Unknown type " + ТипПоля;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьЗначениеТипаПоУмолчанию(ТипПоля)
	
	// TODO RGS AGorlenko 24.08.2016: переделать как вариант с кэшированием
	
	Если ТипПоля = "C" Тогда
		Возврат "";
	ИначеЕсли ТипПоля = "D" Тогда
		Возврат '00010101';
	ИначеЕсли ТипПоля = "N" Тогда
		Возврат 0;
	Иначе
		ВызватьИсключение "Unknown type " + ТипПоля;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТипПоляСхемы(ТипПоля, РазрядностьПоля)
	
	// TODO RGS AGorlenko 24.08.2016: переделать как вариант с кэшированием
	
	Если ТипПоля = "C" Тогда
		Возврат "Text";
	ИначеЕсли ТипПоля = "D" Тогда
		Возврат "Date";
	ИначеЕсли ТипПоля = "N" И РазрядностьПоля > 0 Тогда
		Возврат "Double";
	ИначеЕсли ТипПоля = "N" И РазрядностьПоля = 0 Тогда
		Возврат "Long";
	Иначе
		ВызватьИсключение "Unknown type " + ТипПоля;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	ВыгрузитьДанныеНаСервере();
	
	Если ToFile Тогда 
	
		ДД = ПолучитьИзВременногоХранилища(АдресФайлаВХранилищеARCUST);
		ДД.Записать(КаталогВыгрузки + "/ARCUST.txt");
		
		ДД = ПолучитьИзВременногоХранилища(АдресФайлаВХранилищеARMAST);
		ДД.Записать(КаталогВыгрузки + "/ARMAST.txt");
		
		ДД = ПолучитьИзВременногоХранилища(АдресФайлаВХранилищеARCASH);
		ДД.Записать(КаталогВыгрузки + "/ARCASH.txt");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(КаталогВыгрузки);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ФорматФайла = "FixedLength";
	РаботаСВнешнимиИсточникамиДанных.ПодключениеERM_GP();
	
КонецПроцедуры

&НаКлиенте
Процедура ToFileПриИзменении(Элемент)
	Элементы.КаталогВыгрузки.Доступность = ?(ToFile, Истина, Ложь);
	Элементы.ФорматФайла.Доступность = ?(ToFile, Истина, Ложь);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура MarkedAsUploadedНаСервере()
	ВнешниеИсточникиДанных.ERM_GP.dbo_set_uploaded_all_BATCHES();
КонецПроцедуры

&НаКлиенте
Процедура MarkedAsUploaded(Команда)
	MarkedAsUploadedНаСервере();
КонецПроцедуры