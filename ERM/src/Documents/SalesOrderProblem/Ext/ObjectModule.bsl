
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЭтоНовый() ИЛИ ОбменДанными.Загрузка Тогда
		
		ResponsiblesСтрокой = "";
		
		Если Responsibles.Количество() > 0 Тогда
			Для каждого СтрокаТЧ Из Responsibles Цикл
				ResponsiblesСтрокой = ResponsiblesСтрокой + СтрокаТЧ.Responsible + ", ";
			КонецЦикла;
			ResponsiblesСтрокой = Лев(ResponsiblesСтрокой, СтрДлина(ResponsiblesСтрокой) - 2);
		КонецЕсли;
		
		Если ResponsiblesList <> ResponsiblesСтрокой Тогда
			ResponsiblesList = ResponsiblesСтрокой;
		КонецЕсли;
		
	Иначе
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры
