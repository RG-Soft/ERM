#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьТаблицуФильтра(Source) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ФильтрНезагружаемыхДанных.Company,
		|	ФильтрНезагружаемыхДанных.AU,
		|	ФильтрНезагружаемыхДанных.AR,
		|	ФильтрНезагружаемыхДанных.Revenue,
		|	ФильтрНезагружаемыхДанных.Segment
		|ИЗ
		|	РегистрСведений.ФильтрНезагружаемыхДанных КАК ФильтрНезагружаемыхДанных
		|ГДЕ
		|	ФильтрНезагружаемыхДанных.Source = &Source";
	
	Запрос.УстановитьПараметр("Source", Source);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаФильтра = РезультатЗапроса.Выгрузить();
	//// { RGS TAlmazova 29.10.2017 15:59:02 - ДобавлениеПризнаков AR, Revenue
	//ТаблицаФильтра.Индексы.Добавить("Company, AU, AR, Revenue");
	//// } RGS TAlmazova 29.10.2017 15:59:23 - ДобавлениеПризнаков AR, Revenue
	ТаблицаФильтра.Индексы.Добавить("Company, AU");
	ТаблицаФильтра.Индексы.Добавить("AU");
	ТаблицаФильтра.Индексы.Добавить("Segment");
	
	Возврат ТаблицаФильтра;
	
КонецФункции

Функция ЭтоНезагружаемыеДанные(ТаблицаФильтра, СтрокаДанных, Account) Экспорт
	
	Если ТаблицаФильтра.Количество() = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ЭтоПроводкаПоСчетуВыручки = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Account, "БазовыйЭлемент").ПринадлежитЭлементу(rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня"));
	
	СтруктураПоискаCompanyAU = Новый Структура("Company, AU");
	СтруктураПоискаCompanyAU.Company = СтрокаДанных.Company;
	СтруктураПоискаCompanyAU.AU = СтрокаДанных.AU;
	
	МассивФильтра = ТаблицаФильтра.НайтиСтроки(СтруктураПоискаCompanyAU);
	Если МассивФильтра.Количество() > 0 Тогда
		Если ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].Revenue ИЛИ НЕ ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].AR Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПоискаCompanyAU.Company = Справочники.Организации.ПустаяСсылка();
	МассивФильтра = ТаблицаФильтра.НайтиСтроки(СтруктураПоискаCompanyAU);
	Если МассивФильтра.Количество() > 0 Тогда
		Если ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].Revenue ИЛИ НЕ ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].AR Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	СтруктураПоискаCompanyAU.Company = СтрокаДанных.Company;
	СтруктураПоискаCompanyAU.AU = Справочники.КостЦентры.ПустаяСсылка();
	МассивФильтра = ТаблицаФильтра.НайтиСтроки(СтруктураПоискаCompanyAU);
	Если МассивФильтра.Количество() > 0 Тогда
		Если ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].Revenue ИЛИ НЕ ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].AR Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	
	Segment =  ПолучитьСегментПоAU(СтрокаДанных.AU);
	СтруктураПоискаSeg = Новый Структура("Segment");
	СтруктураПоискаSeg.Segment = Segment;
	
	МассивФильтра = ТаблицаФильтра.НайтиСтроки(СтруктураПоискаSeg);
	Если МассивФильтра.Количество() > 0 Тогда
		Если ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].Revenue ИЛИ НЕ ЭтоПроводкаПоСчетуВыручки И МассивФильтра[0].AR Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ПолучитьСегментПоAU(AU)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КостЦентры.Сегмент.БазовыйЭлемент.Родитель.Родитель КАК Segment
		|ИЗ
		|	Справочник.КостЦентры КАК КостЦентры
		|ГДЕ
		|	КостЦентры.Ссылка = &AU";
	
	Запрос.УстановитьПараметр("AU", AU);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.Segment;
	
КонецФункции

#КонецЕсли
