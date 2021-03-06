#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ЗаполнитьДанныеПоБиллингу(СтруктураПараметров, АдресХранилища) Экспорт
	
	ОбщаяТаблицаБиллинга = Перечисления.BillingCalculationMethods.ПолучитьБиллинг(НачалоМесяца(СтруктураПараметров.Дата)
		, КонецМесяца(СтруктураПараметров.Дата));
	
	ДанныеПоБиллингу = НовыеДанныеПоБиллингу();
	
	Для Каждого СтрокаТаблицыБиллинга Из ОбщаяТаблицаБиллинга Цикл
		
		Метод = rgsКонсолидацияДанныхСерверПовтИсп.ОпределитьМетодРасчетаБиллинга(КонецМесяца(СтруктураПараметров.Дата)
			, СтрокаТаблицыБиллинга.Source, СтрокаТаблицыБиллинга.GeoMarket, СтрокаТаблицыБиллинга.ManagementGeomarket, СтрокаТаблицыБиллинга.Segment
			, СтрокаТаблицыБиллинга.SubSegment, СтрокаТаблицыБиллинга.SubSubSegment, СтрокаТаблицыБиллинга.HFMCompany);
			
		Если СтрокаТаблицыБиллинга.Method = Метод ИЛИ Метод = Перечисления.BillingCalculationMethods.Ignore Тогда
			
			Если Метод = Перечисления.BillingCalculationMethods.Ignore Тогда
				СтрокаТаблицыБиллинга.Method = Перечисления.BillingCalculationMethods.Ignore;
			КонецЕсли;
			
			Если СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.Lawson Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.LawsonBilling.Добавить(), СтрокаТаблицыБиллинга);
			ИначеЕсли СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.HOBs Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.HOBBilling.Добавить(), СтрокаТаблицыБиллинга);
			ИначеЕсли СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.OracleMI Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.OracleMIBilling.Добавить(), СтрокаТаблицыБиллинга);
			ИначеЕсли СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.OracleSmithBilling.Добавить(), СтрокаТаблицыБиллинга);
			ИначеЕсли СтрокаТаблицыБиллинга.Source = Перечисления.ТипыСоответствий.Radius Тогда
				ЗаполнитьЗначенияСвойств(ДанныеПоБиллингу.RadiusBilling.Добавить(), СтрокаТаблицыБиллинга);
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
	Результат.Вставить("RadiusBilling", Документ.RadiusBilling.ВыгрузитьКолонки());
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли