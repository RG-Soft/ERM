﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура ПерезаполнитьРеквизитыSalesOrderProblem(Проблема, СтруктураРеквизитовПроблемы) Экспорт
	
	ТекОбъект = Проблема.ПолучитьОбъект();
	ЗаполнитьРеквизитыПроблемы(ТекОбъект, СтруктураРеквизитовПроблемы);
	ТекОбъект.Записать();
	
КонецПроцедуры

Функция СоздатьSalesOrderProblem(СтруктураРеквизитовПроблемы) Экспорт
	
	ТекОбъект = Документы.SalesOrderProblem.СоздатьДокумент();
	ЗаполнитьРеквизитыПроблемы(ТекОбъект, СтруктураРеквизитовПроблемы);
	ТекОбъект.Записать();
	
	Возврат ТекОбъект.Ссылка;
	
КонецФункции

Процедура ЗаполнитьРеквизитыПроблемы(ПроблемаОбъект, СтруктураРеквизитовПроблемы)
	
	ЗаполнитьЗначенияСвойств(ПроблемаОбъект, СтруктураРеквизитовПроблемы);
	
	Для каждого СтрокаТЧ Из СтруктураРеквизитовПроблемы.Responsibles Цикл
		ЗаполнитьЗначенияСвойств(ПроблемаОбъект.Responsibles.Добавить(), СтрокаТЧ);
	КонецЦикла;
	
КонецПроцедуры
#КонецЕсли
