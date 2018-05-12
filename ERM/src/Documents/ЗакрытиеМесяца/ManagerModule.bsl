#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	СтруктураКолонок = СтруктураПараметров.СтруктураКолонок;
	ТаблицаДанных = ИнициализироватьТаблицуДанных(СтруктураКолонок);
	ТекстОшибки = "";
	
	ФайлЭксель = СтруктураПараметров.ИсточникДанных.Получить();
	
	Если ФайлЭксель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
	ФайлЭксель.Записать(ПутьКФайлу);
	
	ДанныеКорректны = ПроверитьКорректностьДанныхВФайле(ПутьКФайлу, АдресХранилища, ДанныеДляЗаполнения, СтруктураПараметров);
	
	Если ДанныеКорректны Тогда
		rgsЗагрузкаИзExcel.ВыгрузитьЭксельВТаблицуДанныхПоИменамКолонок(ПутьКФайлу, ТаблицаДанных, ДанныеДляЗаполнения, АдресХранилища, СтруктураПараметров);
		ЗагрузитьИЗаписатьДвижения(СтруктураПараметров.Ссылка, СтруктураПараметров.Дата, ТаблицаДанных);
	Иначе
		ТекстОшибки = "Checksums in file failed validation! Check the data!";
		ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ТекстОшибки);
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
КонецПроцедуры

Функция ПроверитьКорректностьДанныхВФайле(ПутьКФайлу, АдресХранилища, ДанныеДляЗаполнения, СтруктураПараметров)
	
	Connection = Новый COMОбъект("ADODB.Connection");
	СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 12.0 Xml;IMEX=1;MAXSCANROWS=0;HDR=" + ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, "Yes", "No") + """";
	
	Попытка
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 8.0;IMEX=1;MAXSCANROWS=0;HDR=" + ?(СтруктураПараметров.ИменаКолонокВПервойСтроке, "Yes", "No") + """";
			Connection.Open(СтрокаПодключения);
		Исключение
			ТекстОшибки = ОписаниеОшибки();
			ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ТекстОшибки);
			ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
			Возврат Ложь;
		КонецПопытки;
	КонецПопытки;
	
	rs = Новый COMObject("ADODB.RecordSet");
	rs.ActiveConnection = Connection;
	sqlString = "select * from [" + "Check$" + "]";
	rs.Open(sqlString);
	
	rs.Move(1);
	
	Возврат  rs.Fields("F5").Value;
	
КонецФункции

Функция ИнициализироватьТаблицуДанных(СтруктураКолонок)
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	
	Для каждого ТекСтрокаСтруктурыКолонок Из СтруктураКолонок Цикл
		ТаблицаДанных.Колонки.Добавить(ТекСтрокаСтруктурыКолонок.ИмяПоля);
	КонецЦикла;
	
	ТаблицаДанных.Колонки.Добавить("СтрокаФайла", Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(15, 0, ДопустимыйЗнак.Неотрицательный)));
	
	Возврат ТаблицаДанных;
	
КонецФункции

Процедура УдалитьШапкуФайла(ПутьКФайлу, СтруктураПараметров)
	
	ЭкземплярExcel = Новый COMОбъект("Excel.Application");
	Книга = ЭкземплярExcel.Application.Workbooks.Open(ПутьКФайлу);
	
	ИмяЛиста = СтруктураПараметров.ЛистФайла;
	Если Прав(ИмяЛиста, 1) = "$" Тогда
		ИмяЛиста = Лев(ИмяЛиста, СтрДлина(ИмяЛиста) - 1);
	КонецЕсли;
	
	Лист = ЭкземплярExcel.Worksheets(ИмяЛиста);
	
	// в качестве ориентиров будем использовать колонки SOURCE_SYSTEM, GL_ACCOUNT, ID_ORIG
	НомерСтрокиЗаголовка = 1;
	
	Для ТекНомерСтроки = 1 По 100 Цикл
		
		НайденаTotal_Techno = Ложь;
		//НайденаGlAccount = Ложь;
		НайденаSL_RCA = Ложь;
		
		Для ТекНомерСтолбца = 1 По 100 Цикл
			
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "Total_Techno" Тогда
				НайденаTotal_Techno = Истина;
			КонецЕсли;
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "SL_RCA" Тогда
				НайденаDOC_ID = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НайденаTotal_Techno И НайденаSL_RCA Тогда
			НомерСтрокиЗаголовка = ТекНомерСтроки;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НомерСтрокиЗаголовка > 1 Тогда
		
		СтрокиДляУдаления = Лист.Rows("1:" + Строка(НомерСтрокиЗаголовка - 1));
		СтрокиДляУдаления.Delete();
		//Книга.SaveAs(ПутьКФайлу);
		Книга.Save();
		
	КонецЕсли;
	
	ЭкземплярExcel.Quit();
	ЭкземплярExcel = Неопределено;
	
КонецПроцедуры

Процедура ЗагрузитьИЗаписатьДвижения(Ссылка, ДатаДокумента, ТаблицаДанных)
	
	ТаблицаДанных.Колонки.Добавить("ДокументЗагрузки");
	ТаблицаДанных.ЗаполнитьЗначения(Ссылка, "ДокументЗагрузки");
	
	НЗ = РегистрыСведений.HFMSourceData.СоздатьНаборЗаписей();
	НЗ.Отбор.ДокументЗагрузки.Установить(Ссылка);
	НЗ.Загрузить(ТаблицаДанных);
	НЗ.Записать(Истина);
	
КонецПроцедуры

Процедура ЗаписатьДанныеВТаблицу(СтруктураПараметров, АдресХранилища) Экспорт
	
	ДанныеДляЗаполнения = Новый Структура();
	ТаблицаРасхождений = Новый ТаблицаЗначений;
	ТаблицаКоллизий = Новый ТаблицаЗначений;
	ТекстОшибки = "";
	
	Если СтруктураПараметров.ВидОперации = Перечисления.ТипСчета.AR Тогда
		
		ПолучитьДанныеAR(СтруктураПараметров, ТаблицаКоллизий, ТаблицаРасхождений);
		
	ИначеЕсли СтруктураПараметров.ВидОперации = Перечисления.ТипСчета.Revenue Тогда
		
		ПолучитьДанныеRevenue(СтруктураПараметров, ТаблицаКоллизий, ТаблицаРасхождений);
		
	Иначе
		
		Сообщение = "Select the type of operation: ""AR"" or ""Revenue""";
		ВызватьИсключение Сообщение;
		
	КонецЕсли;
	
	МесяцВФайле = ТаблицаРасхождений[0].Month;
	ГодВФайле = ТаблицаРасхождений[0].Year;
	МесяцДокумента = Месяц(СтруктураПараметров.Дата);
	ГодДокумента = Год(СтруктураПараметров.Дата);
	
	Если МесяцВФайле <> МесяцДокумента ИЛИ ГодВФайле <> ГодДокумента Тогда
		
		Сообщение = "The data period in the file does not match the selected period.";
		ВызватьИсключение Сообщение;
		
	КонецЕсли;
	
	НачатьТранзакцию();
	
	ДанныеДляЗаполнения.Вставить("ТаблицаКоллизий", ТаблицаКоллизий);
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	
	Если ТаблицаКоллизий.Количество() = 0 Тогда
		ДокОбъект = СтруктураПараметров.Ссылка.ПолучитьОбъект();
		ДокОбъект.ВидОперации = СтруктураПараметров.ВидОперации;
		ДокОбъект.ТаблицаРасхождений.Загрузить(ТаблицаРасхождений);
		ДокОбъект.Записать();
	КонецЕсли;
	ЗафиксироватьТранзакцию();

	
	
КонецПроцедуры

Процедура ПолучитьДанныеAR(СтруктураПараметров, ТаблицаКоллизий, ТаблицаРасхождений)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	HFMSourceData.Segment КАК Segment,
		|	HFMSourceData.Location КАК Location,
		|	HFMSourceData.Amount КАК Amount,
		|	HFMSourceData.Account,
		|	HFMSourceData.Year,
		|	HFMSourceData.Month
		|ПОМЕСТИТЬ ВТ_HFMSourceData
		|ИЗ
		|	РегистрСведений.HFMSourceData КАК HFMSourceData
		|ГДЕ
		|	HFMSourceData.ДокументЗагрузки = &ДокументЗагрузки
		|	И HFMSourceData.Amount <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""Segment not found"" КАК Описание,
		|	ВТ_HFMSourceData.Segment КАК Идентификатор
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Technology КАК HFM_Technology
		|		ПО ВТ_HFMSourceData.Segment = HFM_Technology.Код
		|			И (НЕ HFM_Technology.ПометкаУдаления)
		|ГДЕ
		|	HFM_Technology.Ссылка ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""Location not found"",
		|	ВТ_HFMSourceData.Location
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Locations КАК HFM_Locations
		|		ПО ВТ_HFMSourceData.Location = HFM_Locations.Код
		|			И (НЕ HFM_Locations.ПометкаУдаления)
		|ГДЕ
		|	HFM_Locations.Ссылка ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""_Account not found"",
		|	ВТ_HFMSourceData.Location
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.HFM_GL_Accounts КАК HFM_GL_Accounts
		|		ПО ВТ_HFMSourceData.Account = HFM_GL_Accounts.Код
		|ГДЕ
		|	HFM_GL_Accounts.Ссылка ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_HFMSourceData.Location КАК Location,
		|	HFM_Locations.Ссылка КАК СсылкаLocations,
		|	ВТ_HFMSourceData.Segment КАК Segment,
		|	HFM_Technology.Ссылка КАК СсылкаSegment,
		|	СУММА(ВТ_HFMSourceData.Amount) КАК Amount,
		|	ВТ_HFMSourceData.Account,
		|	HFM_GL_Accounts.Ссылка КАК СсылкаAccount,
		|	ВТ_HFMSourceData.Year,
		|	ВТ_HFMSourceData.Month
		|ПОМЕСТИТЬ ВТ_ОстаткиHFM
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Locations КАК HFM_Locations
		|		ПО ВТ_HFMSourceData.Location = HFM_Locations.Код
		|			И (НЕ HFM_Locations.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Technology КАК HFM_Technology
		|		ПО ВТ_HFMSourceData.Segment = HFM_Technology.Код
		|			И (НЕ HFM_Technology.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.HFM_GL_Accounts КАК HFM_GL_Accounts
		|		ПО ВТ_HFMSourceData.Account = HFM_GL_Accounts.Код
		|ГДЕ
		|	НЕ HFM_Locations.Ссылка ЕСТЬ NULL
		|	И НЕ HFM_Technology.Ссылка ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_HFMSourceData.Location,
		|	HFM_Locations.Ссылка,
		|	ВТ_HFMSourceData.Segment,
		|	HFM_Technology.Ссылка,
		|	ВТ_HFMSourceData.Account,
		|	HFM_GL_Accounts.Ссылка,
		|	ВТ_HFMSourceData.Year,
		|	ВТ_HFMSourceData.Month
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	BilledARОстатки.Account.БазовыйЭлемент КАК AccountБазовыйЭлементРодитель,
		|	BilledARОстатки.AU.Сегмент.БазовыйЭлемент КАК SubSubSegmentБазовыйЭлементРодительРодитель,
		|	BilledARОстатки.AU.ПодразделениеОрганизации.БазовыйЭлемент КАК LocationБазовыйЭлемент,
		|	BilledARОстатки.AmountОстаток КАК AmountОстаток,
		|	BilledARОстатки.Currency
		|ПОМЕСТИТЬ ВТ_ОстаткиЕРМ
		|ИЗ
		|	РегистрНакопления.BilledAR.Остатки(&ДатаКонец, ) КАК BilledARОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	UnallocatedCashОстатки.Account.БазовыйЭлемент,
		|	UnallocatedCashОстатки.AU.Сегмент.БазовыйЭлемент,
		|	UnallocatedCashОстатки.AU.ПодразделениеОрганизации.БазовыйЭлемент,
		|	-UnallocatedCashОстатки.AmountОстаток,
		|	UnallocatedCashОстатки.Currency
		|ИЗ
		|	РегистрНакопления.UnallocatedCash.Остатки(&ДатаКонец, ) КАК UnallocatedCashОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	UnbilledARОстатки.Account.БазовыйЭлемент,
		|	UnbilledARОстатки.AU.Сегмент.БазовыйЭлемент,
		|	UnbilledARОстатки.AU.ПодразделениеОрганизации.БазовыйЭлемент,
		|	UnbilledARОстатки.AmountОстаток,
		|	UnbilledARОстатки.Currency
		|ИЗ
		|	РегистрНакопления.UnbilledAR.Остатки(&ДатаКонец, ) КАК UnbilledARОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ManualTransactionsОстатки.Account.БазовыйЭлемент,
		|	ManualTransactionsОстатки.AU.Сегмент.БазовыйЭлемент,
		|	ManualTransactionsОстатки.AU.ПодразделениеОрганизации.БазовыйЭлемент,
		|	ManualTransactionsОстатки.AmountОстаток,
		|	ManualTransactionsОстатки.Currency
		|ИЗ
		|	РегистрНакопления.ManualTransactions.Остатки(&ДатаКонец, ) КАК ManualTransactionsОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	UnallocatedMemoОстатки.Account.БазовыйЭлемент,
		|	UnallocatedMemoОстатки.AU.Сегмент.БазовыйЭлемент,
		|	UnallocatedMemoОстатки.AU.ПодразделениеОрганизации.БазовыйЭлемент,
		|	UnallocatedMemoОстатки.AmountОстаток,
		|	UnallocatedMemoОстатки.Currency
		|ИЗ
		|	РегистрНакопления.UnallocatedMemo.Остатки(&ДатаКонец, ) КАК UnallocatedMemoОстатки
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	HFMAdjARОстатки.Account,
		|	HFMAdjARОстатки.Segment,
		|	HFMAdjARОстатки.Location,
		|	HFMAdjARОстатки.AmountОстаток,
		|	NULL
		|ИЗ
		|	РегистрНакопления.HFMAdjAR.Остатки(&ДатаКонец, ) КАК HFMAdjARОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ОстаткиЕРМ.AccountБазовыйЭлементРодитель КАК AccountБазовыйЭлементРодитель,
		|	ВТ_ОстаткиЕРМ.SubSubSegmentБазовыйЭлементРодительРодитель КАК Segment,
		|	ВТ_ОстаткиЕРМ.LocationБазовыйЭлемент КАК Location,
		|	СУММА(ВЫРАЗИТЬ(ЕСТЬNULL(ВТ_ОстаткиЕРМ.AmountОстаток, 0) / ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Курс, 1) * ЕСТЬNULL(ВнутренниеКурсыВалютСрезПоследних.Кратность, 1) КАК ЧИСЛО(15, 2))) КАК AmountОстаток
		|ПОМЕСТИТЬ ВТ_ОстаткиЕРМ_Группировка
		|ИЗ
		|	ВТ_ОстаткиЕРМ КАК ВТ_ОстаткиЕРМ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних(&ДатаКурса, ) КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО ВТ_ОстаткиЕРМ.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|ГДЕ
		|	ВТ_ОстаткиЕРМ.AccountБазовыйЭлементРодитель.Код ПОДОБНО ""1%""
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ОстаткиЕРМ.AccountБазовыйЭлементРодитель,
		|	ВТ_ОстаткиЕРМ.SubSubSegmentБазовыйЭлементРодительРодитель,
		|	ВТ_ОстаткиЕРМ.LocationБазовыйЭлемент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	0 КАК Adjustment,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.СсылкаSegment, ВТ_ОстаткиЕРМ_Группировка.Segment) КАК Segment,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.СсылкаLocations, ВТ_ОстаткиЕРМ_Группировка.Location) КАК Location,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.Amount, 0) КАК HFM_Amount,
		|	ЕСТЬNULL(ВТ_ОстаткиЕРМ_Группировка.AmountОстаток, 0) КАК ERM_Amount,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.Amount, 0) - ЕСТЬNULL(ВТ_ОстаткиЕРМ_Группировка.AmountОстаток, 0) КАК Difference,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.СсылкаAccount, ВТ_ОстаткиЕРМ_Группировка.AccountБазовыйЭлементРодитель) КАК Account,
		|	ВТ_ОстаткиHFM.Year,
		|	ВТ_ОстаткиHFM.Month
		|ИЗ
		|	ВТ_ОстаткиЕРМ_Группировка КАК ВТ_ОстаткиЕРМ_Группировка
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ОстаткиHFM КАК ВТ_ОстаткиHFM
		|		ПО (ВТ_ОстаткиHFM.СсылкаLocations = ВТ_ОстаткиЕРМ_Группировка.Location)
		|			И (ВТ_ОстаткиHFM.СсылкаSegment = ВТ_ОстаткиЕРМ_Группировка.Segment)
		|			И (ВТ_ОстаткиHFM.СсылкаAccount = ВТ_ОстаткиЕРМ_Группировка.AccountБазовыйЭлементРодитель)";
	
	Запрос.УстановитьПараметр("ДокументЗагрузки", СтруктураПараметров.Ссылка);
	Запрос.УстановитьПараметр("ДатаКонец", Новый Граница(КонецМесяца(СтруктураПараметров.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ДатаКурса", (КонецМесяца(СтруктураПараметров.Дата)+1));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаКоллизий = МассивРезультатов[1].Выгрузить();
	
	ТаблицаРасхождений = МассивРезультатов[5].Выгрузить();

КонецПроцедуры

Процедура ПолучитьДанныеRevenue(СтруктураПараметров, ТаблицаКоллизий, ТаблицаРасхождений)
	
	ТЗ_ТранзитивноеЗамыкание = ТранзитивноеЗамыкание(5);

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТаблицаИсходныхДанных.Предок,
	|	ТаблицаИсходныхДанных.Потомок
	|ПОМЕСТИТЬ ВТ_ИерархияСчетов
	|ИЗ
	|	&ТЗ_ТранзитивноеЗамыкание КАК ТаблицаИсходныхДанных"
	;
	Запрос.УстановитьПараметр("ТЗ_ТранзитивноеЗамыкание", ТЗ_ТранзитивноеЗамыкание);
	Запрос.Выполнить();
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	HFMSourceData.Segment КАК Segment,
		|	HFMSourceData.Location КАК Location,
		|	HFMSourceData.Amount КАК Amount,
		|	HFMSourceData.Account,
		|	HFMSourceData.Year,
		|	HFMSourceData.Month
		|ПОМЕСТИТЬ ВТ_HFMSourceData
		|ИЗ
		|	РегистрСведений.HFMSourceData КАК HFMSourceData
		|ГДЕ
		|	HFMSourceData.ДокументЗагрузки = &ДокументЗагрузки
		|	И HFMSourceData.Amount <> 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""Segment not found"" КАК Описание,
		|	ВТ_HFMSourceData.Segment КАК Идентификатор
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Technology КАК HFM_Technology
		|		ПО ВТ_HFMSourceData.Segment = HFM_Technology.Код
		|			И (НЕ HFM_Technology.ПометкаУдаления)
		|ГДЕ
		|	HFM_Technology.Ссылка ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""Location not found"",
		|	ВТ_HFMSourceData.Location
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Locations КАК HFM_Locations
		|		ПО ВТ_HFMSourceData.Location = HFM_Locations.Код
		|			И (НЕ HFM_Locations.ПометкаУдаления)
		|ГДЕ
		|	HFM_Locations.Ссылка ЕСТЬ NULL
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	""_Account not found"",
		|	ВТ_HFMSourceData.Location
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.HFM_GL_Accounts КАК HFM_GL_Accounts
		|		ПО ВТ_HFMSourceData.Account = HFM_GL_Accounts.Код
		|ГДЕ
		|	HFM_GL_Accounts.Ссылка ЕСТЬ NULL
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_HFMSourceData.Location КАК Location,
		|	HFM_Locations.Ссылка КАК СсылкаLocations,
		|	ВТ_HFMSourceData.Segment КАК Segment,
		|	HFM_Technology.Ссылка КАК СсылкаSegment,
		|	СУММА(ВТ_HFMSourceData.Amount) КАК Amount,
		|	ВТ_HFMSourceData.Account,
		|	HFM_GL_Accounts.Ссылка КАК СсылкаAccount,
		|	ВТ_HFMSourceData.Year,
		|	ВТ_HFMSourceData.Month
		|ПОМЕСТИТЬ ВТ_ОстаткиHFM
		|ИЗ
		|	ВТ_HFMSourceData КАК ВТ_HFMSourceData
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Locations КАК HFM_Locations
		|		ПО ВТ_HFMSourceData.Location = HFM_Locations.Код
		|			И (НЕ HFM_Locations.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.HFM_Technology КАК HFM_Technology
		|		ПО ВТ_HFMSourceData.Segment = HFM_Technology.Код
		|			И (НЕ HFM_Technology.ПометкаУдаления)
		|		ЛЕВОЕ СОЕДИНЕНИЕ ПланСчетов.HFM_GL_Accounts КАК HFM_GL_Accounts
		|		ПО ВТ_HFMSourceData.Account = HFM_GL_Accounts.Код
		|ГДЕ
		|	НЕ HFM_Locations.Ссылка ЕСТЬ NULL
		|	И НЕ HFM_Technology.Ссылка ЕСТЬ NULL
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_HFMSourceData.Location,
		|	HFM_Locations.Ссылка,
		|	ВТ_HFMSourceData.Segment,
		|	HFM_Technology.Ссылка,
		|	ВТ_HFMSourceData.Account,
		|	HFM_GL_Accounts.Ссылка,
		|	ВТ_HFMSourceData.Year,
		|	ВТ_HFMSourceData.Month
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	RevenueОбороты.Account.БазовыйЭлемент КАК AccountБазовыйЭлементРегистра,
		|	ВТ_ИерархияСчетов.Предок КАК AccountБазовыйЭлемент,
		|	RevenueОбороты.AU.Сегмент.БазовыйЭлемент КАК SubSubSegmentБазовыйЭлемент,
		|	RevenueОбороты.AU.ПодразделениеОрганизации.БазовыйЭлемент КАК LocationБазовыйЭлемент,
		|	RevenueОбороты.Currency,
		|	RevenueОбороты.BaseAmountОборот КАК BaseAmountОборот
		|ПОМЕСТИТЬ ВТ_ОборотыЕРМ
		|ИЗ
		|	РегистрНакопления.Revenue.Обороты(&ДатаНачало, &ДатаКонец, , ) КАК RevenueОбороты
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_ИерархияСчетов КАК ВТ_ИерархияСчетов
		|		ПО RevenueОбороты.Account.БазовыйЭлемент = ВТ_ИерархияСчетов.Потомок
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	NULL,
		|	HFMAdjRevenueОбороты.Account,
		|	HFMAdjRevenueОбороты.Segment,
		|	HFMAdjRevenueОбороты.Location,
		|	NULL,
		|	HFMAdjRevenueОбороты.AmountОборот
		|ИЗ
		|	РегистрНакопления.HFMAdjRevenue.Обороты(&ДатаНачало, &ДатаКонец, , ) КАК HFMAdjRevenueОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ОборотыЕРМ.AccountБазовыйЭлемент КАК AccountБазовыйЭлемент,
		|	ВТ_ОборотыЕРМ.SubSubSegmentБазовыйЭлемент КАК Segment,
		|	ВТ_ОборотыЕРМ.LocationБазовыйЭлемент КАК Location,
		|	СУММА(ВТ_ОборотыЕРМ.BaseAmountОборот) КАК BaseAmountОборот
		|ПОМЕСТИТЬ ВТ_ОборотыЕРМ_Группировка
		|ИЗ
		|	ВТ_ОборотыЕРМ КАК ВТ_ОборотыЕРМ
		|
		|СГРУППИРОВАТЬ ПО
		|	ВТ_ОборотыЕРМ.AccountБазовыйЭлемент,
		|	ВТ_ОборотыЕРМ.SubSubSegmentБазовыйЭлемент,
		|	ВТ_ОборотыЕРМ.LocationБазовыйЭлемент
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	0 КАК Adjustment,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.СсылкаSegment, ВТ_ОборотыЕРМ_Группировка.Segment) КАК Segment,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.СсылкаLocations, ВТ_ОборотыЕРМ_Группировка.Location) КАК Location,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.Amount, 0) КАК HFM_Amount,
		|	ЕСТЬNULL(ВТ_ОборотыЕРМ_Группировка.BaseAmountОборот, 0) КАК ERM_Amount,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.Amount, 0) - ЕСТЬNULL(ВТ_ОборотыЕРМ_Группировка.BaseAmountОборот, 0) КАК Difference,
		|	ЕСТЬNULL(ВТ_ОстаткиHFM.СсылкаAccount, ВТ_ОборотыЕРМ_Группировка.AccountБазовыйЭлемент) КАК Account,
		|	ВТ_ОстаткиHFM.Year,
		|	ВТ_ОстаткиHFM.Month
		|ИЗ
		|	ВТ_ОборотыЕРМ_Группировка КАК ВТ_ОборотыЕРМ_Группировка
		|		ПОЛНОЕ СОЕДИНЕНИЕ ВТ_ОстаткиHFM КАК ВТ_ОстаткиHFM
		|		ПО (ВТ_ОстаткиHFM.СсылкаLocations = ВТ_ОборотыЕРМ_Группировка.Location)
		|			И (ВТ_ОстаткиHFM.СсылкаSegment = ВТ_ОборотыЕРМ_Группировка.Segment)
		|			И (ВТ_ОстаткиHFM.СсылкаAccount = ВТ_ОборотыЕРМ_Группировка.AccountБазовыйЭлемент)";
	
	Запрос.УстановитьПараметр("ДокументЗагрузки", СтруктураПараметров.Ссылка);
	Запрос.УстановитьПараметр("ДатаКонец", Новый Граница(КонецМесяца(СтруктураПараметров.Дата), ВидГраницы.Включая));
	Запрос.УстановитьПараметр("ДатаНачало", Новый Граница(НачалоМесяца(СтруктураПараметров.Дата), ВидГраницы.Включая));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ТаблицаКоллизий = МассивРезультатов[1].Выгрузить();
	
	ТаблицаРасхождений = МассивРезультатов[5].Выгрузить();

КонецПроцедуры

Функция ТранзитивноеЗамыкание(МаксимальнаяДлинаПути)
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТранзитивноеЗамыканиеТекстЗапроса(МаксимальнаяДлинаПути);
	Запрос.Параметры.Вставить("СчетВыручкиВерхнегоУровня", rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня"));
	
	Возврат Запрос.Выполнить().Выгрузить()
	
КонецФункции

Функция ТранзитивноеЗамыканиеТекстЗапроса(МаксимальнаяДлинаПути, ПоместитьВоВременнуюТаблицу = Ложь) 
	
	Пролог = "ВЫБРАТЬ Родитель НачалоДуги, Ссылка КонецДуги ПОМЕСТИТЬ ЗамыканияДлины1 ИЗ ПланСчетов.HFM_GL_Accounts
	
	| ГДЕ Родитель <> Значение(ПланСчетов.HFM_GL_Accounts.ПустаяСсылка)
	
	| ОБЪЕДИНИТЬ ВЫБРАТЬ Ссылка, Ссылка ИЗ ПланСчетов.HFM_GL_Accounts;";
	
	Рефрен = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПерваяДуга.НачалоДуги, ВтораяДуга.КонецДуги ПОМЕСТИТЬ ЗамыканияДлины#2 ИЗ ЗамыканияДлины#1 КАК ПерваяДуга
	
	| ВНУТРЕННЕЕ СОЕДИНЕНИЕ ЗамыканияДлины#1 КАК ВтораяДуга ПО ПерваяДуга.КонецДуги = ВтораяДуга.НачалоДуги;
	
	| УНИЧТОЖИТЬ ЗамыканияДлины#1;";
	
	Эпилог = "ВЫБРАТЬ НачалоДуги Предок, КонецДуги Потомок " + ?(ПоместитьВоВременнуюТаблицу, "ПОМЕСТИТЬ ВТ_Замыкание", "") + " ИЗ ЗамыканияДлины#2 ГДЕ НачалоДуги <> КонецДуги И НачалоДуги.Родитель = &СчетВыручкиВерхнегоУровня";
	
	ТекстЗапроса = Пролог;
	
	МаксимальнаяДлинаЗамыканий = 1;
	
	Пока МаксимальнаяДлинаЗамыканий < МаксимальнаяДлинаПути Цикл
		
		ТекстЗапроса = ТекстЗапроса + СтрЗаменить(СтрЗаменить(Рефрен, "#1", Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0")), "#2", Формат(2 * МаксимальнаяДлинаЗамыканий, "ЧГ=0"));
		
		МаксимальнаяДлинаЗамыканий = 2 * МаксимальнаяДлинаЗамыканий
		
	КонецЦикла;
	
	ТекстЗапроса = ТекстЗапроса + СтрЗаменить(Эпилог, "#2", Формат(МаксимальнаяДлинаЗамыканий, "ЧГ=0"));
	
	Возврат ТекстЗапроса;
	
КонецФункции

Процедура СоздатьКорректировки(СтруктураПараметров, АдресХранилища) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);

	ТаблицаРасхождений = СтруктураПараметров.Ссылка.ТаблицаРасхождений.Выгрузить();
	
	Отбор = Новый Структура;
	Отбор.Вставить("Adjustment", 1);
	
	ТаблицаКорректировок = ТаблицаРасхождений.Скопировать(Отбор);
	
	Если ТаблицаКорректировок.Количество() > 0 Тогда
		
		ТаблицаКорректировокДляЗагрузки = ТаблицаКорректировок.СкопироватьКолонки();
		ТаблицаКорректировокДляЗагрузки.Колонки.Добавить("Период");
		ТаблицаКорректировокДляЗагрузки.Колонки.Добавить("Amount");
		Для каждого СтрокаТаблицы Из ТаблицаКорректировок Цикл
			Если СтрокаТаблицы.Difference <> 0 Тогда
				 НоваяСтрокаДляЗагрузки = ТаблицаКорректировокДляЗагрузки.Добавить();
				 ЗаполнитьЗначенияСвойств(НоваяСтрокаДляЗагрузки,СтрокаТаблицы);
				 НоваяСтрокаДляЗагрузки.Amount = СтрокаТаблицы.Difference;
			КонецЕсли;
		КонецЦикла;
		ТаблицаКорректировокДляЗагрузки.ЗаполнитьЗначения(КонецМесяца(СтруктураПараметров.Дата),"Период");
		
		Док = Документы.КорректировкаРегистров.СоздатьДокумент();
		Док.ДополнительныеСвойства.Вставить("РазрешитьСозданиеДокументаБезРеверса", Истина);
		Док.Дата = КонецМесяца(СтруктураПараметров.Дата);
		Док.Ответственный = Пользователи.ТекущийПользователь();
			
		Если СтруктураПараметров.Ссылка.ВидОперации = Перечисления.ТипСчета.AR Тогда
			
			Док.Комментарий = "HFM balances correction for " + Формат( КонецМесяца(СтруктураПараметров.Дата), "Л=en; ДФ='MMMM yyyy'") + ".";
			ТаблицаКорректировокДляЗагрузки.Колонки.Добавить("ВидДвижения");
			ТаблицаКорректировокДляЗагрузки.ЗаполнитьЗначения(ВидДвиженияНакопления.Приход,"ВидДвижения");
			СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
			СтрокаТаблицыРегистров.Имя = "HFMAdjAR";
			Док.Движения.HFMAdjAR.Загрузить(ТаблицаКорректировокДляЗагрузки);
			Док.Движения.HFMAdjAR.Записывать = Истина;
			
		ИначеЕсли СтруктураПараметров.Ссылка.ВидОперации = Перечисления.ТипСчета.Revenue Тогда
			
			Док.Комментарий = "HFM revenue correction for " + Формат( КонецМесяца(СтруктураПараметров.Дата), "Л=en; ДФ='MMMM yyyy'") + ".";
			СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
			СтрокаТаблицыРегистров.Имя = "HFMAdjRevenue";
			Док.Движения.HFMAdjRevenue.Загрузить(ТаблицаКорректировокДляЗагрузки);
			Док.Движения.HFMAdjRevenue.Записывать = Истина;
			
		КонецЕсли;
		
		Док.Записать();
		
		ЗаписатьДанныеВТаблицу(СтруктураПараметров, АдресХранилища);
		
	КонецЕсли;
	
КонецПроцедуры
#КонецЕсли
