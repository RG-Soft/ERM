#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьОтветственныхПоSO(SalesOrder, Уровень) Экспорт
	
	//СтруктураРеквизитовSO = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(SalesOrder, "Source, Client, Company, AU, Location, CREW");
	//
	//Если СтруктураРеквизитовSO.Source = Перечисления.ТипыСоответствий.Lawson Тогда
	//	Возврат ПолучитьОтветственныхПоSOLawson(СтруктураРеквизитовSO);
	//ИначеЕсли СтруктураРеквизитовSO.Source = Перечисления.ТипыСоответствий.OracleMI Тогда
	//	Возврат ПолучитьОтветственныхПоSOOracleMI(СтруктураРеквизитовSO);
	//ИначеЕсли СтруктураРеквизитовSO.Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
	//	Возврат ПолучитьОтветственныхПоSOOracleSmith(СтруктураРеквизитовSO);
	//ИначеЕсли СтруктураРеквизитовSO.Source = Перечисления.ТипыСоответствий.HOBs Тогда
	//	Возврат ПолучитьОтветственныхПоSOHOB(СтруктураРеквизитовSO);
	//Иначе
	//	Возврат Новый Массив();
	//КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	SalesOrderResponsibles.ResponsibleAR
		|ИЗ
		|	РегистрСведений.SalesOrderResponsibles КАК SalesOrderResponsibles
		|ГДЕ
		|	SalesOrderResponsibles.SalesOrder = &SalesOrder
		|	И SalesOrderResponsibles.ResponsibleAR <> ЗНАЧЕНИЕ(Справочник.LDAPUsers.ПустаяСсылка)";
	
	Запрос.УстановитьПараметр("SalesOrder", SalesOrder);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	МассивОтветственных = РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ResponsibleAR");
	
	Если ЗначениеЗаполнено(Уровень) Тогда
		ДополнитьМассивОтветственных(SalesOrder, МассивОтветственных, Уровень);
		//{ RGS AArsentev S-E-0000049 30.01.2017
		ИсточникHOB = Перечисления.ТипыСоответствий.HOBs;
		ИсточникGeogit = Перечисления.ТипыСоответствий.Geofit;
		ИсточникMFG = Перечисления.ТипыСоответствий.MFG;
		ИсточникRadius = Перечисления.ТипыСоответствий.Radius;
		Source = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(SalesOrder, "Source");
		SupervisorHOB = rgsНастройкаКонфигурацииПовтИсп.ПолучитьЗначениеНастройки("HOBARSupervisor");
		Если ЗначениеЗаполнено(SupervisorHOB) И (Source = ИсточникHOB ИЛИ Source = ИсточникGeogit ИЛИ Source = ИсточникMFG ИЛИ Source = ИсточникRadius) Тогда
			МассивОтветственных.Добавить(SupervisorHOB);
		КонецЕсли;
		
		Если Source = ИсточникHOB Тогда
			Ответственный = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(SalesOrder, "Responsible");
			Если ЗначениеЗаполнено(Ответственный) Тогда
				МассивОтветственных.Добавить(Ответственный);
			КонецЕсли;
		КонецЕсли;
		//} RGS AArsentev S-E-0000049 30.01.2017
	КонецЕсли;
	
	МассивОтветственных = ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивОтветственных);
	
	Возврат МассивОтветственных;
	
КонецФункции

Процедура ДополнитьМассивОтветственных(SalesOrder, МассивОтветственных, Уровень)
	
	Если Уровень = Справочники.EscalationLevels.Level1 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level1));
	ИначеЕсли Уровень = Справочники.EscalationLevels.Level2 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level1));
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level2));
	ИначеЕсли Уровень = Справочники.EscalationLevels.Level3 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level1));
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level2));
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level3));
	ИначеЕсли Уровень = Справочники.EscalationLevels.Level4 Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level1));
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level2));
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level3));
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(МассивОтветственных, ПолучитьОтветственныхПоУровню(SalesOrder, Справочники.EscalationLevels.Level4));
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьОтветственныхПоУровню(SalesOrder, Уровень)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолучателиУведомленийUnbilled.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыДляНотификацийSO КАК ИдентификаторыДляНотификацийSO
		|		ПО ПолучателиУведомленийUnbilled.Source = ИдентификаторыДляНотификацийSO.Source
		|			И ПолучателиУведомленийUnbilled.Идентификатор1 = ИдентификаторыДляНотификацийSO.Идентификатор1
		|			И ПолучателиУведомленийUnbilled.Идентификатор2 = ИдентификаторыДляНотификацийSO.Идентификатор2
		|			И (ИдентификаторыДляНотификацийSO.SalesOrder = &SalesOrder)
		|			И (ПолучателиУведомленийUnbilled.Уровень = &Уровень)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПолучателиУведомленийUnbilled.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ИдентификаторыДляНотификацийSO КАК ИдентификаторыДляНотификацийSO
		|		ПО ПолучателиУведомленийUnbilled.Source = ИдентификаторыДляНотификацийSO.Source
		|			И ПолучателиУведомленийUnbilled.Идентификатор1 = ИдентификаторыДляНотификацийSO.Идентификатор1
		|			И (ПолучателиУведомленийUnbilled.Идентификатор2 = НЕОПРЕДЕЛЕНО
		|				ИЛИ ПолучателиУведомленийUnbilled.Идентификатор2 = """"
		|				ИЛИ ПолучателиУведомленийUnbilled.Идентификатор2 = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))
		|			И (ИдентификаторыДляНотификацийSO.SalesOrder = &SalesOrder)
		|			И (ПолучателиУведомленийUnbilled.Уровень = &Уровень)";
	
	Запрос.УстановитьПараметр("SalesOrder", SalesOrder);
	Запрос.УстановитьПараметр("Уровень", Уровень);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если НЕ МассивРезультатов[0].Пустой() Тогда
		ВыборкаДетальныеЗаписи = МассивРезультатов[0].Выбрать();
	Иначе
		ВыборкаДетальныеЗаписи = МассивРезультатов[1].Выбрать();
	КонецЕсли;
	
	МассивОтветственных = Новый Массив;
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		МассивОтветственных.Добавить(ВыборкаДетальныеЗаписи.Получатель);
		
	КонецЦикла;
	
	Возврат МассивОтветственных;
	
КонецФункции

Функция ПолучитьОтветственныхПоSOLawson(СтруктураРеквизитовSO)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолучателиУведомленийUnbilled.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|ГДЕ
		|	ПолучателиУведомленийUnbilled.Source = &Source
		|	И ПолучателиУведомленийUnbilled.Идентификатор1 = &Идентификатор1
		|	И ПолучателиУведомленийUnbilled.Уровень = &Уровень
		|	И ПолучателиУведомленийUnbilled.Получатель.ResponsibleAR";
	
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.Lawson);
	Запрос.УстановитьПараметр("Идентификатор1", СтруктураРеквизитовSO.AU);
	Запрос.УстановитьПараметр("Уровень", Справочники.EscalationLevels.Level1);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Получатель");
	
КонецФункции

Функция ПолучитьОтветственныхПоSOOracleMI(СтруктураРеквизитовSO)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолучателиУведомленийUnbilled.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|ГДЕ
		|	ПолучателиУведомленийUnbilled.Source = &Source
		|	И ПолучателиУведомленийUnbilled.Идентификатор1 = &Идентификатор1
		|	И ПолучателиУведомленийUnbilled.Уровень = &Уровень
		|	И ПолучателиУведомленийUnbilled.Получатель.ResponsibleAR
		|	И ПолучателиУведомленийUnbilled.Идентификатор2 = &Идентификатор2
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ПолучателиУведомленийUnbilled.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|ГДЕ
		|	ПолучателиУведомленийUnbilled.Source = &Source
		|	И ПолучателиУведомленийUnbilled.Идентификатор1 = &Идентификатор1
		|	И ПолучателиУведомленийUnbilled.Уровень = &Уровень
		|	И ПолучателиУведомленийUnbilled.Получатель.ResponsibleAR
		|	И (ПолучателиУведомленийUnbilled.Идентификатор2 = НЕОПРЕДЕЛЕНО
		|			ИЛИ ПолучателиУведомленийUnbilled.Идентификатор2 = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))";
	
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.OracleMI);
	Запрос.УстановитьПараметр("Идентификатор1", СтруктураРеквизитовSO.Location);
	Запрос.УстановитьПараметр("Идентификатор2", СтруктураРеквизитовSO.Client);
	Запрос.УстановитьПараметр("Уровень", Справочники.EscalationLevels.Level1);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если НЕ МассивРезультатов[0].Пустой() Тогда
		РезультатЗапроса = МассивРезультатов[0];
	Иначе
		РезультатЗапроса = МассивРезультатов[1];
	КонецЕсли;
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Получатель");
	
КонецФункции

Функция ПолучитьОтветственныхПоSOOracleSmith(СтруктураРеквизитовSO)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолучателиУведомленийUnbilled.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|ГДЕ
		|	ПолучателиУведомленийUnbilled.Source = &Source
		|	И ПолучателиУведомленийUnbilled.Идентификатор1 = &Идентификатор1
		|	И ПолучателиУведомленийUnbilled.Уровень = &Уровень
		|	И ПолучателиУведомленийUnbilled.Получатель.ResponsibleAR";
	
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.OracleMI);
	Запрос.УстановитьПараметр("Идентификатор1", СтруктураРеквизитовSO.Location);
	Запрос.УстановитьПараметр("Уровень", Справочники.EscalationLevels.Level1);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Получатель");
	
КонецФункции

Функция ПолучитьОтветственныхПоSOHOB(СтруктураРеквизитовSO)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолучателиУведомленийUnbilled.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиУведомленийUnbilled КАК ПолучателиУведомленийUnbilled
		|ГДЕ
		|	ПолучателиУведомленийUnbilled.Source = &Source
		|	И ПолучателиУведомленийUnbilled.Идентификатор1 = &Идентификатор1
		|	И ПолучателиУведомленийUnbilled.Уровень = &Уровень
		|	И ПолучателиУведомленийUnbilled.Получатель.ResponsibleAR
		|	И ПолучателиУведомленийUnbilled.Идентификатор2 = &Идентификатор2";
	
	Запрос.УстановитьПараметр("Source", Перечисления.ТипыСоответствий.HOBs);
	Запрос.УстановитьПараметр("Идентификатор1", СтруктураРеквизитовSO.Company);
	Запрос.УстановитьПараметр("Идентификатор2", СтруктураРеквизитовSO.CREW);
	Запрос.УстановитьПараметр("Уровень", Справочники.EscalationLevels.Level1);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый Массив;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Получатель");
	
КонецФункции

#КонецЕсли