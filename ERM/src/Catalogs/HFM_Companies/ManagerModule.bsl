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
	
	СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Код, ПометкаУдаления, Наименование");
	
	Если Операция = Перечисления.ОперацииPowerBI.Create Тогда
		ТекОбъект = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_HFM_Companies.СоздатьОбъект();
		ТекОбъект.ID = Строка(Ссылка.УникальныйИдентификатор());
	Иначе
		СсылкаВоВнешнемИсточнике = ВнешниеИсточникиДанных.ERM_BI.Таблицы.dbo_HFM_Companies.ПолучитьСсылку(Строка(Ссылка.УникальныйИдентификатор()));
		ТекОбъект = СсылкаВоВнешнемИсточнике.ПолучитьОбъект();
	КонецЕсли;
	ТекОбъект.DeletionMark = СтруктураРеквизитов.ПометкаУдаления;
	ТекОбъект.Code = СтруктураРеквизитов.Код;
	ТекОбъект.Description = СтруктураРеквизитов.Наименование;
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