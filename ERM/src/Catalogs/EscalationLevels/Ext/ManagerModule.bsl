﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

Функция ПолучитьВышестоящиеУровни(ТекущийУровень, ВключаяТекущий = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	EscalationLevels.Ссылка,
		|	EscalationLevels.DaysFromTheStartingDate
		|ИЗ
		|	Справочник.EscalationLevels КАК EscalationLevels
		|ГДЕ
		|	НЕ EscalationLevels.ПометкаУдаления
		|	И EscalationLevels.LevelID > &ТекущийУровень";
	
	Запрос.УстановитьПараметр("ТекущийУровень", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекущийУровень, "LevelID"));
	Если ВключаяТекущий Тогда
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "EscalationLevels.LevelID > &ТекущийУровень", "EscalationLevels.LevelID >= &ТекущийУровень");
	КонецЕсли;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

#КонецОбласти
	
#КонецЕсли