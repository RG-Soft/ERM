﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Функция ПолучитьСписокПолучателей() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПолучателиТестовыхНотификаций.Получатель
		|ИЗ
		|	РегистрСведений.ПолучателиТестовыхНотификаций КАК ПолучателиТестовыхНотификаций";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Получатель");
	
КонецФункции

#КонецЕсли