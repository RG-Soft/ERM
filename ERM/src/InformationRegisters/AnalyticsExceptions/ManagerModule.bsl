#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьТаблицуИсключенийАналитики(Source) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	AnalyticsExceptions.Company,
		|	AnalyticsExceptions.AU,
		|	AnalyticsExceptions.SubSubSegment
		|ИЗ
		|	РегистрСведений.AnalyticsExceptions КАК AnalyticsExceptions
		|ГДЕ
		|	AnalyticsExceptions.Source = &Source";
		
	Запрос.УстановитьПараметр("Source", Source);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

#КонецЕсли