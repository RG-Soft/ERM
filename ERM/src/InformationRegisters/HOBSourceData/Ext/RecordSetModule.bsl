﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл
		ЗаписьНабора.TrID = ЗаписьНабора.DocumentGUID + Формат(ЗаписьНабора.TrNumber, "ЧГ=0");
	КонецЦикла;
	
КонецПроцедуры
