#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Проведен Тогда
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Failed to save posted document");
	КонецЕсли;
		
	Ответственный = Пользователи.ТекущийПользователь();
		
КонецПроцедуры

#КонецЕсли
