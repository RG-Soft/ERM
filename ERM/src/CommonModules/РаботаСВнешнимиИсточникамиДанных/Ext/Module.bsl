﻿Процедура ПодключениеERM_GP() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ERM_GPМенеджер = ВнешниеИсточникиДанных.ERM_GP;
	
	Если ERM_GPМенеджер.ПолучитьСостояние() = СостояниеВнешнегоИсточникаДанных.Подключен Тогда
		Возврат;
	КонецЕсли;
	
	Владелец = ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Обработка.PushARDataToGetPaid");
	ПараметрыВИД = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(Владелец, "ПараметрыВИД");
	
	Если ПараметрыВИД <> Неопределено тогда
		ПараметрыСоединения = Новый ПараметрыСоединенияВнешнегоИсточникаДанных;
		ПараметрыСоединения.АутентификацияОС = ПараметрыВИД.АутентификацияОС;
		ПараметрыСоединения.АутентификацияСтандартная = ПараметрыВИД.АутентификацияСтандартная;
		ПараметрыСоединения.ИмяПользователя = ПараметрыВИД.ИмяПользователя;
		ПараметрыСоединения.Пароль = ПараметрыВИД.Пароль;
		ПараметрыСоединения.СтрокаСоединения = ПараметрыВИД.СтрокаСоединения;
		ПараметрыСоединения.СУБД = ПараметрыВИД.СУБД;
		ERM_GPМенеджер.УстановитьПараметрыСоединенияСеанса(ПараметрыСоединения);
	иначе
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не найдены параметры подключения к ERM_GP в безопасном хранилище.";
		Сообщение.Сообщить();
	КонецЕсли;
	
	Попытка
		ERM_GPМенеджер.УстановитьСоединение();
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось установить соединение с внешними источниками данных, сообщите администратору!";
		Сообщение.Сообщить(); 
		ЗаписьЖурналаРегистрации("Подключение к внешним источникам данных",  УровеньЖурналаРегистрации.Ошибка,,, 
								ОписаниеОшибки(), РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
		Возврат;
	КонецПопытки;
	
	Если ERM_GPМенеджер.ПолучитьСостояние() = СостояниеВнешнегоИсточникаДанных.Отключен Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Не удалось установить соединение с внешними источниками данных, сообщите администратору!";
		Сообщение.Сообщить(); 
		ЗаписьЖурналаРегистрации("Подключение к внешним источникам данных",  УровеньЖурналаРегистрации.Ошибка,,, 
								"Проверить версии драйверов", РежимТранзакцииЗаписиЖурналаРегистрации.Независимая);
	КонецЕсли;
	
КонецПроцедуры
