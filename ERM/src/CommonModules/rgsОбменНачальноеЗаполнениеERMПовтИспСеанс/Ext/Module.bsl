﻿
Функция ПолучитьУзелBilling() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	rgsНачальноеЗаполнениеКлиентовERM.Ссылка
		|ИЗ
		|	ПланОбмена.rgsНачальноеЗаполнениеКлиентовERM КАК rgsНачальноеЗаполнениеКлиентовERM
		|ГДЕ
		|	НЕ rgsНачальноеЗаполнениеКлиентовERM.ЭтотУзел
		|	И НЕ rgsНачальноеЗаполнениеКлиентовERM.ПометкаУдаления
		|	И rgsНачальноеЗаполнениеКлиентовERM.Код = ""BL""";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	ВыборкаДетальныеЗаписи.Следующий();
	
	Возврат ВыборкаДетальныеЗаписи.Ссылка;
	
КонецФункции