#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

#Область PowerBI

// Описание
// Выполняет выгрузку данных в Power BI
// Параметры:
// 	Ссылка - Ссылка на данные, которые нужно выгрузить
// 	Операция - вид операции с данными
// Возвращаемое значение:
// 	Структура - включает поля Результат, Сообщение.
Функция ВыгрузитьДанныеДляPowerBI(Ссылка, Операция) Экспорт
	
	СтруктураРезультата = Новый Структура("Результат, Сообщение", Ложь, "");
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Код, ПометкаУдаления, Наименование, Родитель");
	
	Если Операция = Перечисления.ОперацииPowerBI.Create Тогда
		ТекОбъект = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_HFM_Technology.СоздатьОбъект();
		ТекОбъект.ID = Строка(Ссылка.УникальныйИдентификатор());
	Иначе
		СсылкаВоВнешнемИсточнике = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_HFM_Technology.ПолучитьСсылку(Строка(Ссылка.УникальныйИдентификатор()));
		ТекОбъект = СсылкаВоВнешнемИсточнике.ПолучитьОбъект();
	КонецЕсли;
	ТекОбъект.DeletionMark = СтруктураРеквизитов.ПометкаУдаления;
	ТекОбъект.Description = СтруктураРеквизитов.Наименование;
	ТекОбъект.Code = СтруктураРеквизитов.Код;
	Если ЗначениеЗаполнено(СтруктураРеквизитов.Родитель) Тогда
		ТекОбъект.ParentID = Строка(СтруктураРеквизитов.Родитель.УникальныйИдентификатор());
	Иначе
		ТекОбъект.ParentID = NULL;
	КонецЕсли;
	Попытка
		ТекОбъект.Записать();
	Исключение
		СтруктураРезультата.Сообщение = ОписаниеОшибки();
		Возврат СтруктураРезультата;
	КонецПопытки;
	
	СтруктураРезультата.Результат = Истина;
	Возврат СтруктураРезультата;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#КонецОбласти

#КонецЕсли