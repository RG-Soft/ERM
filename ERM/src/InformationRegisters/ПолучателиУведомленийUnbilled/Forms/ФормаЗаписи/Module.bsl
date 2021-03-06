
&НаКлиенте
Процедура SourceПриИзменении(Элемент)
	
	НастроитьЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура НастроитьЭлементыФормы(Форма)
	
	ЭлементыФормы = Форма.Элементы;
	
	Если Форма.Запись.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.Lawson") Тогда
		
		ЭлементыФормы.Идентификатор1.Видимость = Истина;
		ЭлементыФормы.Идентификатор1.Заголовок = "AU";
		ЭлементыФормы.Идентификатор1.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КостЦентры");
		
		ЭлементыФормы.Идентификатор2.Видимость = Ложь;
		
	ИначеЕсли Форма.Запись.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") Тогда
		
		ЭлементыФормы.Идентификатор1.Видимость = Истина;
		ЭлементыФормы.Идентификатор1.Заголовок = "Location";
		ЭлементыФормы.Идентификатор1.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");
		
		ЭлементыФормы.Идентификатор2.Видимость = Истина;
		ЭлементыФормы.Идентификатор2.Заголовок = "Client";
		ЭлементыФормы.Идентификатор2.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Контрагенты");
		
	ИначеЕсли Форма.Запись.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleSmith") Тогда
		
		ЭлементыФормы.Идентификатор1.Видимость = Истина;
		ЭлементыФормы.Идентификатор1.Заголовок = "Location";
		ЭлементыФормы.Идентификатор1.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ПодразделенияОрганизаций");
		
		ЭлементыФормы.Идентификатор2.Видимость = Ложь;
		
	ИначеЕсли Форма.Запись.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.HOBs") Тогда
		
		ЭлементыФормы.Идентификатор1.Видимость = Истина;
		ЭлементыФормы.Идентификатор1.Заголовок = "Company";
		ЭлементыФормы.Идентификатор1.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
		
		ЭлементыФормы.Идентификатор2.Видимость = Истина;
		ЭлементыФормы.Идентификатор2.Заголовок = "CREW";
		ЭлементыФормы.Идентификатор2.ОграничениеТипа = Новый ОписаниеТипов("Строка");
		
	ИначеЕсли Форма.Запись.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.Radius") Тогда
		
		ЭлементыФормы.Идентификатор1.Видимость = Истина;
		ЭлементыФормы.Идентификатор1.Заголовок = "Company";
		ЭлементыФормы.Идентификатор1.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.Организации");
		
		ЭлементыФормы.Идентификатор2.Видимость = Ложь;
		
	КонецЕсли;
	
	ЭлементыФормы.ResponsibleAR.Видимость = (Форма.Запись.Уровень = ПредопределенноеЗначение("Справочник.EscalationLevels.Level1"));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	НастроитьЭлементыФормы(ЭтаФорма);
	
КонецПроцедуры

