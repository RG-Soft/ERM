#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ЗаполнитьДанныеПоШтрафам(СтруктураПараметров, АдресХранилища) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
		|	BilledARОстатки.Source КАК Source,
		|	BilledARОстатки.Company КАК Company,
		|	BilledARОстатки.Client КАК Client,
		|	BilledARОстатки.AU КАК AU,
		|	BilledARОстатки.Account КАК Account,
		|	ВЫБОР
		|		КОГДА BilledARОстатки.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА BilledARОстатки.LegalEntity
		|		ИНАЧЕ BilledARОстатки.Company.DefaultLegalEntity
		|	КОНЕЦ КАК LegalEntity,
		|	BilledARОстатки.ClientID КАК ClientID,
		|	BilledARОстатки.Invoice КАК Invoice,
		|	BilledARОстатки.Currency КАК Currency,
		|	BilledARОстатки.AmountОстаток КАК AmountОстаток
		|ПОМЕСТИТЬ ВТ_АктуальныеОстатки
		|ИЗ
		|	РегистрНакопления.BilledAR.Остатки(
		|			,
		|			Source В (&Sources)
		|				И Invoice.DueDateTo <> ДАТАВРЕМЯ(1, 1, 1)
		|				И Invoice.DueDateTo < &КонецПериодаРасчета) КАК BilledARОстатки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	PaymentsОбороты.Source КАК Source,
		|	PaymentsОбороты.Company КАК Company,
		|	PaymentsОбороты.Client КАК Client,
		|	PaymentsОбороты.AU КАК AU,
		|	PaymentsОбороты.Account КАК Account,
		|	ВЫБОР
		|		КОГДА PaymentsОбороты.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА PaymentsОбороты.LegalEntity
		|		ИНАЧЕ PaymentsОбороты.Company.DefaultLegalEntity
		|	КОНЕЦ КАК LegalEntity,
		|	PaymentsОбороты.ClientID КАК ClientID,
		|	PaymentsОбороты.Invoice КАК Invoice,
		|	PaymentsОбороты.Currency КАК Currency,
		|	PaymentsОбороты.AmountОборот КАК AmountОборот
		|ПОМЕСТИТЬ ВТ_ОплатыСНачалаПериодаРасчета
		|ИЗ
		|	РегистрНакопления.Payments.Обороты(
		|			&НачалоПериодаРасчета,
		|			,
		|			,
		|			Source В (&Sources)
		|				И Invoice.DueDateTo <> ДАТАВРЕМЯ(1, 1, 1)
		|				И Invoice.DueDateTo < &КонецПериодаРасчета) КАК PaymentsОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	PaymentsОбороты.Source КАК Source,
		|	PaymentsОбороты.Company КАК Company,
		|	PaymentsОбороты.Client КАК Client,
		|	PaymentsОбороты.AU КАК AU,
		|	PaymentsОбороты.Account КАК Account,
		|	ВЫБОР
		|		КОГДА PaymentsОбороты.LegalEntity <> ЗНАЧЕНИЕ(Справочник.LegalEntiites.ПустаяСсылка)
		|			ТОГДА PaymentsОбороты.LegalEntity
		|		ИНАЧЕ PaymentsОбороты.Company.DefaultLegalEntity
		|	КОНЕЦ КАК LegalEntity,
		|	PaymentsОбороты.ClientID КАК ClientID,
		|	PaymentsОбороты.Invoice КАК Invoice,
		|	PaymentsОбороты.Currency КАК Currency,
		|	PaymentsОбороты.AmountОборот КАК AmountОборот,
		|	PaymentsОбороты.Период КАК Период
		|ПОМЕСТИТЬ ВТ_ОплатыЗаПериодРасчета
		|ИЗ
		|	РегистрНакопления.Payments.Обороты(
		|			&НачалоПериодаРасчета,
		|			&КонецПериодаРасчета,
		|			День,
		|			Source В (&Sources)
		|				И Invoice.DueDateTo <> ДАТАВРЕМЯ(1, 1, 1)
		|				И Invoice.DueDateTo < &КонецПериодаРасчета) КАК PaymentsОбороты
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	LawsonDepositDatesInv.Invoice КАК Document,
		|	МАКСИМУМ(LawsonDepositDatesInv.DepositDate) КАК DepositDate
		|ПОМЕСТИТЬ ВТ_LawsonDepositDates
		|ИЗ
		|	РегистрСведений.LawsonDepositDates КАК LawsonDepositDatesInv
		|ГДЕ
		|	LawsonDepositDatesInv.Invoice В
		|			(ВЫБРАТЬ
		|				ОплатыЗаПериодРасчета.Invoice
		|			ИЗ
		|				ВТ_ОплатыЗаПериодРасчета КАК ОплатыЗаПериодРасчета)
		|
		|СГРУППИРОВАТЬ ПО
		|	LawsonDepositDatesInv.Invoice
		|
		|ИМЕЮЩИЕ
		|	МАКСИМУМ(LawsonDepositDatesInv.DepositDate) МЕЖДУ &НачалоПериодаРасчета И &КонецПериодаРасчета
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ОплатыЗаПериодРасчета.Source КАК Source,
		|	ВТ_ОплатыЗаПериодРасчета.Company КАК Company,
		|	ВТ_ОплатыЗаПериодРасчета.Client КАК Client,
		|	ВТ_ОплатыЗаПериодРасчета.AU КАК AU,
		|	ВТ_ОплатыЗаПериодРасчета.Account КАК Account,
		|	ВТ_ОплатыЗаПериодРасчета.LegalEntity КАК LegalEntity,
		|	ВТ_ОплатыЗаПериодРасчета.ClientID КАК ClientID,
		|	ВТ_ОплатыЗаПериодРасчета.Invoice КАК Invoice,
		|	ВТ_ОплатыЗаПериодРасчета.Currency КАК Currency,
		|	ВТ_ОплатыЗаПериодРасчета.AmountОборот КАК AmountОборот,
		|	ЕСТЬNULL(ВТ_LawsonDepositDates.DepositDate, ВТ_ОплатыЗаПериодРасчета.Период) КАК ДатаОплаты,
		|	ВЫБОР
		|		КОГДА ВТ_ОплатыЗаПериодРасчета.Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|				И (ВТ_LawsonDepositDates.DepositDate ЕСТЬ NULL ИЛИ ВТ_LawsonDepositDates.DepositDate = ДАТАВРЕМЯ(1, 1, 1))
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ЕстьПроблемаРасчета
		|ПОМЕСТИТЬ ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты
		|ИЗ
		|	ВТ_ОплатыЗаПериодРасчета КАК ВТ_ОплатыЗаПериодРасчета
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_LawsonDepositDates КАК ВТ_LawsonDepositDates
		|		ПО ВТ_ОплатыЗаПериодРасчета.Invoice = ВТ_LawsonDepositDates.Document
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Source КАК Source,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Company КАК Company,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Client КАК Client,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.AU КАК AU,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Account КАК Account,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.LegalEntity КАК LegalEntity,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.ClientID КАК ClientID,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Invoice КАК Invoice,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Invoice.Contract КАК Contract,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Invoice.Contract.СпособРасчетаШтрафаПоЗадолженности КАК СпособРасчетаШтрафаПоЗадолженности,
		|	ЕСТЬNULL(ВложенныйЗапросАктуальныеОстаткиБезОплат.Invoice.Contract.ПроцентЗадолженности,0) КАК Percent,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Currency КАК Currency,
		|	СУММА(ВложенныйЗапросАктуальныеОстаткиБезОплат.AmountОстаток) КАК Amount,
		|	ДАТАВРЕМЯ(1, 1, 1) КАК ДатаОплаты,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Invoice.DueDateTo КАК DueDate,
		|	1 КАК ПриоритетОбработки,
		|	ЛОЖЬ КАК ЕстьПроблемаРасчета
		|ИЗ
		|	(ВЫБРАТЬ
		|		ВТ_АктуальныеОстатки.Source КАК Source,
		|		ВТ_АктуальныеОстатки.Company КАК Company,
		|		ВТ_АктуальныеОстатки.Client КАК Client,
		|		ВТ_АктуальныеОстатки.AU КАК AU,
		|		ВТ_АктуальныеОстатки.Account КАК Account,
		|		ВТ_АктуальныеОстатки.LegalEntity КАК LegalEntity,
		|		ВТ_АктуальныеОстатки.ClientID КАК ClientID,
		|		ВТ_АктуальныеОстатки.Invoice КАК Invoice,
		|		ВТ_АктуальныеОстатки.Currency КАК Currency,
		|		ВТ_АктуальныеОстатки.AmountОстаток КАК AmountОстаток
		|	ИЗ
		|		ВТ_АктуальныеОстатки КАК ВТ_АктуальныеОстатки
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		ВТ_ОплатыСКонцаПериодаРасчета.Source,
		|		ВТ_ОплатыСКонцаПериодаРасчета.Company,
		|		ВТ_ОплатыСКонцаПериодаРасчета.Client,
		|		ВТ_ОплатыСКонцаПериодаРасчета.AU,
		|		ВТ_ОплатыСКонцаПериодаРасчета.Account,
		|		ВТ_ОплатыСКонцаПериодаРасчета.LegalEntity,
		|		ВТ_ОплатыСКонцаПериодаРасчета.ClientID,
		|		ВТ_ОплатыСКонцаПериодаРасчета.Invoice,
		|		ВТ_ОплатыСКонцаПериодаРасчета.Currency,
		|		ВТ_ОплатыСКонцаПериодаРасчета.AmountОборот
		|	ИЗ
		|		ВТ_ОплатыСНачалаПериодаРасчета КАК ВТ_ОплатыСКонцаПериодаРасчета) КАК ВложенныйЗапросАктуальныеОстаткиБезОплат
		|
		|СГРУППИРОВАТЬ ПО
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Source,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Company,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Client,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.AU,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Account,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.LegalEntity,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.ClientID,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Invoice,
		|	ВложенныйЗапросАктуальныеОстаткиБезОплат.Currency,
		|	ЕСТЬNULL(ВложенныйЗапросАктуальныеОстаткиБезОплат.Invoice.Contract.ПроцентЗадолженности,0)
		|
		|ИМЕЮЩИЕ
		|	СУММА(ВложенныйЗапросАктуальныеОстаткиБезОплат.AmountОстаток) <> 0
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Source,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Company,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Client,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.AU,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Account,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.LegalEntity,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.ClientID,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Invoice,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Invoice.Contract,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Invoice.Contract.СпособРасчетаШтрафаПоЗадолженности,
		|	ЕСТЬNULL(ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Invoice.Contract.ПроцентЗадолженности,0),
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Currency,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.AmountОборот,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.ДатаОплаты,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.Invoice.DueDateTo,
		|	2,
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты.ЕстьПроблемаРасчета
		|ИЗ
		|	ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты КАК ВТ_ОплатыЗаПериодРасчетаСДатамиОплаты
		|
		|УПОРЯДОЧИТЬ ПО
		|	ПриоритетОбработки,
		|	ДатаОплаты
		|ИТОГИ
		|	МАКСИМУМ(DueDate),
		|	МИНИМУМ(Amount)
		|ПО
		|	Invoice,
		|	Client,
		|	Company,
		|	Source,
		|	Account,
		|	Currency,
		|	AU,
		|	LegalEntity,
		|	ClientID";

	Sources = Новый Массив;
	Sources.Добавить(Перечисления.ТипыСоответствий.Lawson);
	Sources.Добавить(Перечисления.ТипыСоответствий.OracleMI);
	Sources.Добавить(Перечисления.ТипыСоответствий.OracleSmith);
	Sources.Добавить(Перечисления.ТипыСоответствий.HOBs);
	Запрос.УстановитьПараметр("Sources", Sources);
	Запрос.УстановитьПараметр("НачалоПериодаРасчета", НачалоМесяца(СтруктураПараметров.ПериодРасчета));
	Запрос.УстановитьПараметр("КонецПериодаРасчета", КонецМесяца(СтруктураПараметров.ПериодРасчета));

	ДанныеПоШтрафам = Новый ТаблицаЗначений;
	ДанныеПоШтрафам.Колонки.Добавить("Source");
	ДанныеПоШтрафам.Колонки.Добавить("Company");
	ДанныеПоШтрафам.Колонки.Добавить("LegalEntity");
	ДанныеПоШтрафам.Колонки.Добавить("AU");
	ДанныеПоШтрафам.Колонки.Добавить("ClientID");
	ДанныеПоШтрафам.Колонки.Добавить("Client");
	ДанныеПоШтрафам.Колонки.Добавить("Contract");
	ДанныеПоШтрафам.Колонки.Добавить("Invoice");
	ДанныеПоШтрафам.Колонки.Добавить("DueDate");
	ДанныеПоШтрафам.Колонки.Добавить("Currency");
	ДанныеПоШтрафам.Колонки.Добавить("PenaltyDate");
	//ДанныеПоШтрафам.Колонки.Добавить("PenaltyDate");
	ДанныеПоШтрафам.Колонки.Добавить("RemainingAmount");
	ДанныеПоШтрафам.Колонки.Добавить("RemainingAmountUSD");
	ДанныеПоШтрафам.Колонки.Добавить("OverDueDays");
	ДанныеПоШтрафам.Колонки.Добавить("Percent");
	ДанныеПоШтрафам.Колонки.Добавить("PenaltyAmount");
	ДанныеПоШтрафам.Колонки.Добавить("PenaltyAmountUSD");
	ДанныеПоШтрафам.Колонки.Добавить("IsProblem");
	ДанныеПоШтрафам.Колонки.Добавить("ProblemDescription");

	ВыборкаИнвойс = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	КэшКурсов = Новый Соответствие();
	ДанныеПоСтавкеРефинансирования =  ПолучитьДанныеПоСтавкеРефинансирования(СтруктураПараметров.ПериодРасчета);
	
	Пока ВыборкаИнвойс.Следующий() Цикл
		
		DueDate = ВыборкаИнвойс.DueDate;
		ЕстьПроблема = ВыборкаИнвойс.Amount < 0;
		ОписаниеПроблемы = "";
		
		Если ЕстьПроблема Тогда
			ОписаниеПроблемы = "По инвойсу присутствуют отрицательные строки";
		КонецЕсли;
		
		ВыбокаClient = ВыборкаИнвойс.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
		Пока ВыбокаClient.Следующий() Цикл
		
			ВыборкаCompany = ВыбокаClient.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
			Пока ВыборкаCompany.Следующий() Цикл
				
				ВыборкаSource = ВыборкаCompany.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				
				Пока ВыборкаSource.Следующий() Цикл
					
					ВыборкаAccount = ВыборкаSource.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
					
					Пока ВыборкаAccount.Следующий() Цикл
						
						ВыборкаCurrency = ВыборкаAccount.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
						
						Пока ВыборкаCurrency.Следующий() Цикл
							
							ВыборкаAU = ВыборкаCurrency.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
							
							Пока ВыборкаAU.Следующий() Цикл
								
								ВыборкаLegalEntity = ВыборкаAU.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
								
								Пока ВыборкаLegalEntity.Следующий() Цикл
									
									ВыборкаClientID = ВыборкаLegalEntity.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
									
									Пока ВыборкаClientID.Следующий() Цикл
										
										ВыборкаДетальныеЗаписи = ВыборкаClientID.Выбрать();
										
										ВыборкаДетальныеЗаписи.Следующий();
										ТекущийБаланс = ?(ВыборкаДетальныеЗаписи.ПриоритетОбработки = 1, 
											ВыборкаДетальныеЗаписи.Amount, -ВыборкаДетальныеЗаписи.Amount);
										НачалоПериодаРасчета = Макс(НачалоМесяца(СтруктураПараметров.ПериодРасчета), КонецДня(DueDate) + 1);
										КонецПериодаРасчета = КонецМесяца(СтруктураПараметров.ПериодРасчета);
										Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
											Если ВыборкаДетальныеЗаписи.ПриоритетОбработки = 2
													И ВыборкаДетальныеЗаписи.ДатаОплаты <= КонецДня(DueDate) Тогда
												ТекущийБаланс = ТекущийБаланс - ВыборкаДетальныеЗаписи.Amount;
												Продолжить;
											КонецЕсли;
											ТекКонецПериодаРасчета = ?(ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ДатаОплаты), 
												КонецДня(ВыборкаДетальныеЗаписи.ДатаОплаты), КонецМесяца(СтруктураПараметров.ПериодРасчета));
											Если ВыборкаДетальныеЗаписи.ЕстьПроблемаРасчета Тогда
												ОписаниеПроблемы = "По инвойсу не загружена дата оплаты";
											КонецЕсли;
											ЗаполнитьСтрокиДанныхПоШтрафам(ДанныеПоШтрафам, ВыборкаДетальныеЗаписи, НачалоПериодаРасчета, 
												ТекКонецПериодаРасчета, ТекущийБаланс, ДанныеПоСтавкеРефинансирования, КэшКурсов, 
												ЕстьПроблема ИЛИ ВыборкаДетальныеЗаписи.ЕстьПроблемаРасчета, ОписаниеПроблемы);
											НачалоПериодаРасчета = ТекКонецПериодаРасчета + 1;
											Если ВыборкаДетальныеЗаписи.ПриоритетОбработки = 2 Тогда
												ТекущийБаланс = ТекущийБаланс - ВыборкаДетальныеЗаписи.Amount;
											КонецЕсли;
										КонецЦикла;
										ВыборкаДетальныеЗаписи.Сбросить();
										ВыборкаДетальныеЗаписи.Следующий();
										ЗаполнитьСтрокиДанныхПоШтрафам(ДанныеПоШтрафам, ВыборкаДетальныеЗаписи, НачалоПериодаРасчета, 
											КонецПериодаРасчета, ТекущийБаланс, ДанныеПоСтавкеРефинансирования, КэшКурсов,
											ЕстьПроблема ИЛИ ВыборкаДетальныеЗаписи.ЕстьПроблемаРасчета, ОписаниеПроблемы);
										
									КонецЦикла;
									
								КонецЦикла;
								
							КонецЦикла;
							
						КонецЦикла;
						
					КонецЦикла;
					
				КонецЦикла;
				
			КонецЦикла;
			
		КонецЦикла;
	
	КонецЦикла;
	
	ДанныеДляЗаполнения = Новый Структура();
	ДанныеДляЗаполнения.Вставить("ДанныеПоШтрафам", ДанныеПоШтрафам);
	
	ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);

КонецПроцедуры

Функция ПолучитьДанныеПоСтавкеРефинансирования(Период)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВЫРАЗИТЬ(СтавкаРефинансированияЦБСрезПоследних.Размер / ДЕНЬГОДА(КОНЕЦПЕРИОДА(&КонецПериода, ГОД)) КАК ЧИСЛО(15,
	|		2)) КАК Размер
	|ИЗ
	|	РегистрСведений.СтавкаРефинансированияЦБ.СрезПоследних(&НачалоПериода,) КАК СтавкаРефинансированияЦБСрезПоследних
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СтавкаРефинансированияЦБ.Период КАК Период,
	|	ВЫРАЗИТЬ(СтавкаРефинансированияЦБ.Размер / ДЕНЬГОДА(КОНЕЦПЕРИОДА(&КонецПериода, ГОД)) КАК ЧИСЛО(15, 2)) КАК Размер
	|ИЗ
	|	РегистрСведений.СтавкаРефинансированияЦБ КАК СтавкаРефинансированияЦБ
	|ГДЕ
	|	СтавкаРефинансированияЦБ.Период > &НачалоПериода
	|	И СтавкаРефинансированияЦБ.Период < &КонецПериода
	|УПОРЯДОЧИТЬ ПО
	|	Период";
	Запрос.УстановитьПараметр("НачалоПериода", НачалоМесяца(Период) + 1);
	Запрос.УстановитьПараметр("КонецПериода", КонецМесяца(Период));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Результат = Новый Структура("СтавкаНаНачалоПериода, ИзменениеСтавкиЗаПериод");
	
	ВыборкаСтавкаНаНачалоПериода = МассивРезультатов[0].Выбрать();
	Если НЕ ВыборкаСтавкаНаНачалоПериода.Следующий() Тогда
		ВызватьИсключение "Не задана ставка рефинансирования на " + НачалоМесяца(Период);
	КонецЕсли;
	Результат.СтавкаНаНачалоПериода = ВыборкаСтавкаНаНачалоПериода.Размер;
	
	ВыборкаИзменениеСтавки = МассивРезультатов[1].Выбрать();
	Результат.ИзменениеСтавкиЗаПериод = Новый ТаблицаЗначений();
	Результат.ИзменениеСтавкиЗаПериод.Колонки.Добавить("НачалоПериода");
	Результат.ИзменениеСтавкиЗаПериод.Колонки.Добавить("КонецПериода");
	Результат.ИзменениеСтавкиЗаПериод.Колонки.Добавить("Размер");
	
	ПредыдущийПериод = НачалоМесяца(Период);
	ПредыдущаяСтавка = Результат.СтавкаНаНачалоПериода;
	Пока ВыборкаИзменениеСтавки.Следующий() Цикл
		НоваяСтрока = Результат.ИзменениеСтавкиЗаПериод.Добавить();
		НоваяСтрока.НачалоПериода = ПредыдущийПериод;
		НоваяСтрока.КонецПериода = ВыборкаИзменениеСтавки.Период - 1;
		НоваяСтрока.Размер = ПредыдущаяСтавка;
		ПредыдущийПериод = ВыборкаИзменениеСтавки.Период;
		ПредыдущаяСтавка = ВыборкаИзменениеСтавки.Размер;
	КонецЦикла;
	Если Результат.ИзменениеСтавкиЗаПериод.Количество() > 0 Тогда
		НоваяСтрока = Результат.ИзменениеСтавкиЗаПериод.Добавить();
		НоваяСтрока.НачалоПериода = ПредыдущийПериод;
		НоваяСтрока.КонецПериода = КонецМесяца(Период);
		НоваяСтрока.Размер = ПредыдущаяСтавка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьКурсИзКэша(Кэш, Валюта, ДатаКурса)
	Если Кэш[Валюта] = Неопределено Тогда
		СтруктураКурса = РаботаСКурсамиВалют.ПолучитьВнутреннийКурсВалюты(Валюта, ДатаКурса);
		Кэш.Вставить(Валюта, СтруктураКурса.Курс);
	КонецЕсли;
	Возврат Кэш[Валюта];
КонецФункции

Процедура ЗаполнитьСтрокиДанныхПоШтрафам(ДанныеПоШтрафам, Параметры, Знач НачалоПериодаРасчета, Знач КонецПериодаРасчета, 
	Знач Баланс, ДанныеПоСтавкеРефинансирования, КэшКурсов, ЕстьПроблема, ОписаниеПроблемы)
	
	Если Баланс = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Параметры.СпособРасчетаШтрафаПоЗадолженности) Тогда
		ПроцентШтрафа = 0;
	ИначеЕсли Параметры.СпособРасчетаШтрафаПоЗадолженности = Справочники.СпособыРасчетаШтрафаПоЗадолженности.СогласноДоговору Тогда
		ПроцентШтрафа = Параметры.Percent;
	ИначеЕсли Параметры.СпособРасчетаШтрафаПоЗадолженности = Справочники.СпособыРасчетаШтрафаПоЗадолженности.СогласноГК Тогда
		Если ДанныеПоСтавкеРефинансирования.ИзменениеСтавкиЗаПериод.Количество() = 0 Тогда
			ПроцентШтрафа = ДанныеПоСтавкеРефинансирования.СтавкаНаНачалоПериода;
		Иначе
			Для каждого СтрокаИзмененияЗаПериод Из ДанныеПоСтавкеРефинансирования.ИзменениеСтавкиЗаПериод Цикл
				Если НачалоПериодаРасчета > СтрокаИзмененияЗаПериод.КонецПериода Тогда
					Продолжить;
				КонецЕсли;
				Если КонецПериодаРасчета <= СтрокаИзмененияЗаПериод.КонецПериода Тогда
					ЗаполнитьСтрокуДанныхПоШтрафам(ДанныеПоШтрафам, Параметры, НачалоПериодаРасчета, КонецПериодаРасчета, Баланс, 
						СтрокаИзмененияЗаПериод.Размер, КэшКурсов, ЕстьПроблема, ОписаниеПроблемы);
					Прервать;
				Иначе
					ЗаполнитьСтрокуДанныхПоШтрафам(ДанныеПоШтрафам, Параметры, НачалоПериодаРасчета, СтрокаИзмененияЗаПериод.КонецПериода, Баланс, 
						СтрокаИзмененияЗаПериод.Размер, КэшКурсов, ЕстьПроблема, ОписаниеПроблемы);
					НачалоПериодаРасчета = СтрокаИзмененияЗаПериод.КонецПериода + 1; 
				КонецЕсли;
			КонецЦикла;
			Возврат;
		КонецЕсли;
	Иначе
		ВызватьИсключение "Unknown method " + Параметры.СпособРасчетаШтрафаПоЗадолженности;
	КонецЕсли;
	
	ЗаполнитьСтрокуДанныхПоШтрафам(ДанныеПоШтрафам, Параметры, НачалоПериодаРасчета, КонецПериодаРасчета, Баланс, 
		ПроцентШтрафа, КэшКурсов, ЕстьПроблема, ОписаниеПроблемы);	
	
КонецПроцедуры

Процедура ЗаполнитьСтрокуДанныхПоШтрафам(ДанныеПоШтрафам, Параметры, НачалоПериодаРасчета, КонецПериодаРасчета, Баланс, 
	ПроцентШтрафа, КэшКурсов, ЕстьПроблема, ОписаниеПроблемы)
	
	СтрокаШтрафа = ДанныеПоШтрафам.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаШтрафа, Параметры, "Source, Company, LegalEntity, AU, ClientID, Client, Contract, Invoice, DueDate, Currency");
	СтрокаШтрафа.Percent = ПроцентШтрафа;
	СтрокаШтрафа.PenaltyDate = КонецПериодаРасчета;
	СтрокаШтрафа.OverDueDays = ДеньГода(КонецПериодаРасчета) - ДеньГода(НачалоПериодаРасчета) + 1;
	СтрокаШтрафа.RemainingAmount = Баланс;
	СтрокаШтрафа.RemainingAmountUSD = СтрокаШтрафа.RemainingAmount / ПолучитьКурсИзКэша(
		КэшКурсов, Параметры.Currency, КонецМесяца(КонецПериодаРасчета));
	СтрокаШтрафа.PenaltyAmount = СтрокаШтрафа.RemainingAmount * СтрокаШтрафа.Percent / 100 * СтрокаШтрафа.OverDueDays;
	СтрокаШтрафа.PenaltyAmountUSD  = СтрокаШтрафа.PenaltyAmount / ПолучитьКурсИзКэша(
		КэшКурсов, Параметры.Currency, КонецМесяца(КонецПериодаРасчета));
	СтрокаШтрафа.IsProblem = ЕстьПроблема;
	СтрокаШтрафа.ProblemDescription = ОписаниеПроблемы;
	
КонецПроцедуры

#КонецЕсли