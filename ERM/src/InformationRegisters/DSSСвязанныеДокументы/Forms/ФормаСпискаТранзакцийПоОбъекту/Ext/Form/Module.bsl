﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Документ") Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Transactions, "СвязанныйОбъект", Параметры.Документ, Истина);
	КонецЕсли;
	
КонецПроцедуры
