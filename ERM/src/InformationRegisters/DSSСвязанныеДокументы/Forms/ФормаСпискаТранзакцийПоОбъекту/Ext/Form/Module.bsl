﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Документ") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Transactions, "СвязанныйОбъект", Параметры.Документ, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура TransactionsВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.Transactions.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		
		Документ = ТекущиеДанные.ПроводкаDSS;
		
		ПараметрыФормы = Новый Структура("Ключ", Документ);
		
		Если ТипЗнч(Документ) = Тип("ДокументСсылка.ПроводкаDSS") Тогда
			ОткрытьФорму("Документ.ПроводкаDSS.Форма.ФормаДокументаУправляемая", ПараметрыФормы);
		ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ТранзакцияOracle") Тогда
			ОткрытьФорму("Документ.ТранзакцияOracle.Форма.ФормаДокумента", ПараметрыФормы);
		ИначеЕсли ТипЗнч(Документ) = Тип("ДокументСсылка.ТранзакцияHOB") Тогда
			ОткрытьФорму("Документ.ТранзакцияHOB.Форма.ФормаДокумента", ПараметрыФормы);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
