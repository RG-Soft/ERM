﻿
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ДополнительныеСвойства.Свойство("РазрешитьРедактирование") Тогда
		Возврат;	
	КонецЕсли;
	
	Если Количество() = 0 И Замещение Тогда
		Прочитать();
		Отказ =  Количество() > 0;
	КонецЕсли;
	
КонецПроцедуры
