
Процедура ПередЗаписью(Отказ, Замещение)

	Если Отбор.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ЭлементОтбора Из Отбор Цикл
		Если ЭлементОтбора.Имя = "Контрагент" Тогда
			Если ЭлементОтбора.ВидСравнения = ВидСравнения.Равно Тогда
				PowerBIРегламенты.PowerBIПередЗаписьюОбъекта(ЭлементОтбора.Значение.ПолучитьОбъект(), Отказ);
			ИначеЕсли ЭлементОтбора.ВидСравнения = ВидСравнения.ВСписке Тогда
				Для Каждого ЭлементСписка Из ЭлементОтбора.Значение Цикл
					PowerBIРегламенты.PowerBIПередЗаписьюОбъекта(ЭлементСписка.Значение.ПолучитьОбъект(), Отказ);
				КонецЦикла;
			КонецЕсли;
			Прервать;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры
