﻿
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
	
	ВыгрузитьARCUST();
	ВыгрузитьARMAST();
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьARCUST()
	
	ОписаниеСтруктурыARCUST = ПолучитьОписаниеСтруктурыПриемника("ARCUST");
	
	ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
	СоздатьКаталог(ИмяКаталога);
	ПутьКФайлу = ИмяКаталога + "\ARCUST.txt";
	
	ПутьСхемы = ИмяКаталога+"\schema.ini";
	ФайлСхемы = Новый ТекстовыйДокумент;
	ФайлСхемы.УстановитьТекст(ПолучитьТекстФайлаСхемы("ARCUST", ОписаниеСтруктурыARCUST));
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
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьARMAST()
	
	ОписаниеСтруктурыARMAST = ПолучитьОписаниеСтруктурыПриемника("ARMAST");
	
	ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
	СоздатьКаталог(ИмяКаталога);
	ПутьКФайлу = ИмяКаталога + "\ARMAST.txt";
	
	ПутьСхемы = ИмяКаталога+"\schema.ini";
	ФайлСхемы = Новый ТекстовыйДокумент;
	ФайлСхемы.УстановитьТекст(ПолучитьТекстФайлаСхемы("ARMAST", ОписаниеСтруктурыARMAST));
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
	
КонецПроцедуры

&НаСервере
Функция ПолучитьТаблицуДанныхARCUST()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	BilledARОстатки.Source,
	|	BilledARОстатки.Client,
	|	BilledARОстатки.AmountОстаток КАК BALANCE
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.BilledAR.Остатки(, Source В (&Sources)) КАК BilledARОстатки
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	UnallocatedCashОстатки.Source,
	|	UnallocatedCashОстатки.Client,
	|	UnallocatedCashОстатки.AmountОстаток
	|ИЗ
	|	РегистрНакопления.UnallocatedCash.Остатки(, Source В (&Sources)) КАК UnallocatedCashОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТипыСоответствий.Ссылка,
	|	ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент,
	|	0
	|ИЗ
	|	РегистрСведений.ИерархияКонтрагентов.СрезПоследних КАК ИерархияКонтрагентовСрезПоследних,
	|	Перечисление.ТипыСоответствий КАК ТипыСоответствий
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника,
	|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период) КАК Период,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия
	|ПОМЕСТИТЬ ВТ_ИдентификаторыКлиентовМаксимальныеДаты
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ВТ_Остатки.Source
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
	|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_Остатки.Client
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ОбъектПриемника,
	|	ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ТипСоответствия,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
	|ПОМЕСТИТЬ ВТ_ИдентификаторыКлиентов
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыКлиентовМаксимальныеДаты КАК ВТ_ИдентификаторыКлиентовМаксимальныеДаты
	|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ТипСоответствия
	|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ИдентификаторыКлиентовМаксимальныеДаты.Период
	|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ОбъектПриемника
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
	|ГДЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника <> ЗНАЧЕНИЕ(Справочник.Контрагенты.GLNoName)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВЫБОР
	|		КОГДА ВТ_ИдентификаторыКлиентов.Идентификатор ЕСТЬ NULL 
	|			ТОГДА """"
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВТ_ИдентификаторыКлиентов.Идентификатор + ""-101""
	|		ИНАЧЕ ВТ_ИдентификаторыКлиентов.Идентификатор
	|	КОНЕЦ КАК CUSTNO,
	|	ЕСТЬNULL(ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент.CRMID, """") КАК PARENT,
	|	ВТ_Остатки.Client.Наименование КАК COMPANY,
	|	ВТ_Остатки.Client.CreditLimit КАК CRD_LIMIT
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыКлиентов КАК ВТ_ИдентификаторыКлиентов
	|		ПО ВТ_Остатки.Client = ВТ_ИдентификаторыКлиентов.ОбъектПриемника
	|			И ВТ_Остатки.Source = ВТ_ИдентификаторыКлиентов.ТипСоответствия
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияКонтрагентов.СрезПоследних(
	|				,
	|				Контрагент В
	|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
	|						ВТ_Остатки.Client
	|					ИЗ
	|						ВТ_Остатки КАК ВТ_Остатки)) КАК ИерархияКонтрагентовСрезПоследних
	|		ПО ВТ_Остатки.Client = ИерархияКонтрагентовСрезПоследних.Контрагент
	|ГДЕ
	|	НЕ ВТ_ИдентификаторыКлиентов.Идентификатор ПОДОБНО ""#empty#%""";
	
	Sources = Новый Массив;
	//Sources.Добавить(Перечисления.ТипыСоответствий.Lawson);
	//Sources.Добавить(Перечисления.ТипыСоответствий.OracleMI);
	Sources.Добавить(Перечисления.ТипыСоответствий.HOBs);
	Запрос.УстановитьПараметр("Sources", Sources);
	
	ТаблицаДанных = Запрос.Выполнить().Выгрузить();
	
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
	|	BilledARОстатки.Source,
	|	BilledARОстатки.Client,
	|	BilledARОстатки.Invoice,
	|	BilledARОстатки.Company,
	|	BilledARОстатки.Currency,
	|	BilledARОстатки.Invoice.Дата КАК INVDTE,
	|	BilledARОстатки.Invoice.Currency.Наименование КАК TRANCURR
	|ПОМЕСТИТЬ ВТ_Остатки
	|ИЗ
	|	РегистрНакопления.BilledAR.Остатки(, Source В (&Sources)) КАК BilledARОстатки
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	UnallocatedCashОстатки.Client.Код,
	|	UnallocatedCashОстатки.CashBatch.PaymentNumber,
	|	UnallocatedCashОстатки.AmountОстаток,
	|	UnallocatedCashОстатки.CashBatch.Amount,
	|	ВЫБОР
	|		КОГДА UnallocatedCashОстатки.CashBatch.Prepayment
	|			ТОГДА ""O""
	|		ИНАЧЕ ""U""
	|	КОНЕЦ,
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
	|	UnallocatedCashОстатки.CashBatch.Currency.Наименование
	|ИЗ
	|	РегистрНакопления.UnallocatedCash.Остатки(, Source В (&Sources)) КАК UnallocatedCashОстатки
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника,
	|	МАКСИМУМ(НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период) КАК Период,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия
	|ПОМЕСТИТЬ ВТ_ИдентификаторыКлиентовМаксимальныеДаты
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Остатки КАК ВТ_Остатки
	|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ВТ_Остатки.Source
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
	|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_Остатки.Client
	|
	|СГРУППИРОВАТЬ ПО
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ОбъектПриемника,
	|	ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ТипСоответствия,
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор
	|ПОМЕСТИТЬ ВТ_ИдентификаторыКлиентов
	|ИЗ
	|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыКлиентовМаксимальныеДаты КАК ВТ_ИдентификаторыКлиентовМаксимальныеДаты
	|		ПО НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия = ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ТипСоответствия
	|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период = ВТ_ИдентификаторыКлиентовМаксимальныеДаты.Период
	|			И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника = ВТ_ИдентификаторыКлиентовМаксимальныеДаты.ОбъектПриемника
	|			И (НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client))
	|ГДЕ
	|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника <> ЗНАЧЕНИЕ(Справочник.Контрагенты.Unreconciled)
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника <> ЗНАЧЕНИЕ(Справочник.Контрагенты.NonTrade)
	|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника <> ЗНАЧЕНИЕ(Справочник.Контрагенты.GLNoName)
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
	|	ВЫБОР
	|		КОГДА ВТ_ИдентификаторыКлиентов.Идентификатор ЕСТЬ NULL 
	|			ТОГДА """"
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВТ_ИдентификаторыКлиентов.Идентификатор + ""-101""
	|		ИНАЧЕ ВТ_ИдентификаторыКлиентов.Идентификатор
	|	КОНЕЦ КАК CUSTNO,
	|	ВТ_Остатки.INVNO,
	|	ВТ_Остатки.Company.Код КАК CompanyCode,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|			ТОГДА ВТ_Остатки.BALANCE
	|		ИНАЧЕ ВТ_Остатки.BALANCE / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность
	|	КОНЕЦ КАК BALANCE,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|			ТОГДА ВТ_Остатки.INVAMT
	|		ИНАЧЕ ВТ_Остатки.INVAMT / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность
	|	КОНЕЦ КАК INVAMT,
	|	ВТ_Остатки.ARSTAT,
	|	ВТ_Остатки.TRANORIG,
	|	ВТ_Остатки.TRANBAL,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|						ТОГДА ВТ_Остатки.INVAMT
	|					ИНАЧЕ ВТ_Остатки.INVAMT / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ВТ_Остатки.Currency = &ВалютаРубли
	|					ТОГДА ВТ_Остатки.INVAMT
	|				ИНАЧЕ ВТ_Остатки.INVAMT / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность * &КурсОтносительноРубля / &КратностьОтносительноРубля
	|			КОНЕЦ
	|	КОНЕЦ КАК LOCORIG,
	|	ВЫБОР
	|		КОГДА ВТ_Остатки.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
	|			ТОГДА ВЫБОР
	|					КОГДА ВТ_Остатки.Currency = &ВалютаUSD
	|						ТОГДА ВТ_Остатки.BALANCE
	|					ИНАЧЕ ВТ_Остатки.BALANCE / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность
	|				КОНЕЦ
	|		ИНАЧЕ ВЫБОР
	|				КОГДА ВТ_Остатки.Currency = &ВалютаРубли
	|					ТОГДА ВТ_Остатки.BALANCE
	|				ИНАЧЕ ВТ_Остатки.BALANCE / ВТ_ВнутренниеКурсыВалют.Курс * ВТ_ВнутренниеКурсыВалют.Кратность * &КурсОтносительноРубля / &КратностьОтносительноРубля
	|			КОНЕЦ
	|	КОНЕЦ КАК LOCBAL,
	|	ВТ_Остатки.Source,
	|	ВТ_Остатки.INVDTE,
	|	ВТ_Остатки.TRANCURR
	|ИЗ
	|	ВТ_Остатки КАК ВТ_Остатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИдентификаторыКлиентов КАК ВТ_ИдентификаторыКлиентов
	|		ПО ВТ_Остатки.Client = ВТ_ИдентификаторыКлиентов.ОбъектПриемника
	|			И ВТ_Остатки.Source = ВТ_ИдентификаторыКлиентов.ТипСоответствия
	|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ВнутренниеКурсыВалют КАК ВТ_ВнутренниеКурсыВалют
	|		ПО ВТ_Остатки.Currency = ВТ_ВнутренниеКурсыВалют.Валюта";
	
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
		КонецЕсли;
		
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Удалить("CompanyCode");
	ТаблицаДанных.Колонки.Удалить("Source");
	
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
		НоваяСтрокаОписания.ТипПараметраЗапроса = ПолучитьТипПараметраЗапроса(ТипПоля, ШиринаПоля);
		НоваяСтрокаОписания.ТипПараметраЗапросаЧисло = ПолучитьТипПараметраЗапросаЧисло(ТипПоля);
		НоваяСтрокаОписания.ТипПоляСхемы = ПолучитьТипПоляСхемы(ТипПоля);
		
	КонецЦикла;
	
	Возврат ОписаниеСтруктурыПриемника;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстФайлаСхемы(Знач ИмяПриемникаДанных, Знач ОписаниеСтруктурыПриемника)
	
	ТекстФайлаСхемы = "[" + ИмяПриемникаДанных + ".txt]" + Символы.ПС;
	
	// настройки формата
	ТекстФайлаСхемы = ТекстФайлаСхемы + "Format=FixedLength" + Символы.ПС;
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
Функция ПолучитьТипПараметраЗапросаЧисло(ТипПоля)
	
	// TODO RGS AGorlenko 24.08.2016: переделать как вариант с кэшированием
	
	Если ТипПоля = "C" Тогда
		Возврат 129;
	ИначеЕсли ТипПоля = "D" Тогда
		Возврат 133;
	ИначеЕсли ТипПоля = "N" Тогда
		Возврат 5;
	Иначе
		ВызватьИсключение "Unknown type " + ТипПоля;
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТипПараметраЗапроса(ТипПоля, ШиринаПоля)
	
	// TODO RGS AGorlenko 24.08.2016: переделать как вариант с кэшированием
	
	Если ТипПоля = "C" И ШиринаПоля <= 255 Тогда
		Возврат "char";
	ИначеЕсли ТипПоля = "C" И ШиринаПоля > 255 Тогда
		Возврат "longchar";
	ИначеЕсли ТипПоля = "D" Тогда
		Возврат "date";
	ИначеЕсли ТипПоля = "N" Тогда
		Возврат "double";
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
Функция ПолучитьТипПоляСхемы(ТипПоля)
	
	// TODO RGS AGorlenko 24.08.2016: переделать как вариант с кэшированием
	
	Если ТипПоля = "C" Тогда
		Возврат "Text";
	ИначеЕсли ТипПоля = "D" Тогда
		Возврат "Date";
	ИначеЕсли ТипПоля = "N" Тогда
		Возврат "Double";
	Иначе
		ВызватьИсключение "Unknown type " + ТипПоля;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	
	ВыгрузитьДанныеНаСервере();
	
	ДД = ПолучитьИзВременногоХранилища(АдресФайлаВХранилищеARCUST);
	ДД.Записать(КаталогВыгрузки + "/ARCUST.txt");
	
	ДД = ПолучитьИзВременногоХранилища(АдресФайлаВХранилищеARMAST);
	ДД.Записать(КаталогВыгрузки + "/ARMAST.txt");
	
КонецПроцедуры

&НаКлиенте
Процедура КаталогВыгрузкиОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ЗапуститьПриложение(КаталогВыгрузки);
	
КонецПроцедуры
