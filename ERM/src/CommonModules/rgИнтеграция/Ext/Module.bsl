﻿
Процедура ПриЗаписиКонтрагентаПриЗаписи(Источник, Отказ) Экспорт
	
	//ЗарегистрироватьОбъектКПередаче(Источник.Ссылка, Источник.Ссылка);
	
КонецПроцедуры

Процедура ПриЗаписиБанковскогоСчетаПриЗаписи(Источник, Отказ) Экспорт
	
	Если ТипЗнч(Источник.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
		ЗарегистрироватьОбъектКПередаче(Источник.Ссылка, Источник.Владелец);
	КонецЕсли;
		
КонецПроцедуры

Процедура ЗарегистрироватьОбъектКПередаче(Ссылка, Контрагент)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Узлы = ПолучитьСписокУзловДляКонтрагента(Контрагент);
	
	Если Узлы.Количество() > 0 Тогда
		
		ПланыОбмена.ЗарегистрироватьИзменения(Узлы, Ссылка);
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Функция ПолучитьСписокУзловДляКонтрагента(Контрагент)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПубличныеИдентификаторыСинхронизируемыхОбъектов.УзелИнформационнойБазы
		|ИЗ
		|	РегистрСведений.ПубличныеИдентификаторыСинхронизируемыхОбъектов КАК ПубличныеИдентификаторыСинхронизируемыхОбъектов
		|ГДЕ
		|	ПубличныеИдентификаторыСинхронизируемыхОбъектов.Ссылка = &Контрагент";
	
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Узлы = Новый Массив;
	
	Пока Выборка.Следующий() Цикл
		Узлы.Добавить(Выборка.УзелИнформационнойБазы);
	КонецЦикла;
	
	Возврат Узлы;
	
КонецФункции




