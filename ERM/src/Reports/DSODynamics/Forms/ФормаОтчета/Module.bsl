
&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ПериодDSO");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = Период;
	КонецЕсли;
	
КонецПроцедуры
