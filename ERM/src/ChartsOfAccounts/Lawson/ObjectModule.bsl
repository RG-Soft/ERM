

Процедура ПриЗаписи(Отказ)
	
	Если СуществуетСчетПоКодуЧислом(КодЧислом, Ссылка) Тогда
		
		Отказ = Истина;
		
		Сообщить("Unable to write account" + Символы.ВК + 
					"Account with """ + КодЧислом + """ already exist");
		
	КонецЕсли;
	
КонецПроцедуры

Функция СуществуетСчетПоКодуЧислом(Код_Числом, ТекущаяСсылка)

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Lawson.Ссылка КАК Ссылка
		|ИЗ
		|	ПланСчетов.Lawson КАК Lawson
		|ГДЕ
		|	Lawson.КодЧислом = &КодЧислом
		|	И Lawson.Ссылка <> &ТекущаяСсылка
		|	И НЕ Lawson.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("КодЧислом", Код_Числом);
	Запрос.УстановитьПараметр("ТекущаяСсылка", ТекущаяСсылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат НЕ РезультатЗапроса.Пустой();

КонецФункции
