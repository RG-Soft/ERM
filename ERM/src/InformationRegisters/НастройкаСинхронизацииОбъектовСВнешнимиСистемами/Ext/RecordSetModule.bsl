﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	МассивУзлов = rgsОбменКлиентамиERMПовтИспСеанс.ПолучитьУзлыПланаОбмена();
	
	Для каждого ЗаписьНабора Из ЭтотОбъект Цикл
		
		Если ЗаписьНабора.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Client Тогда
			
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, ЗаписьНабора.ОбъектПриемника);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
