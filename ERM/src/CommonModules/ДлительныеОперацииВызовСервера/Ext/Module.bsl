﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
// Поддержка работы длительных серверных операций в веб-клиенте.
//  
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

Функция ОперацииВыполнены(Знач ЗаданияДляПроверки, ЗаданияДляОтмены) Экспорт
	
	Результат = ДлительныеОперации.ОперацииВыполнены(ЗаданияДляПроверки);
	Для каждого ИдентификаторЗадания Из ЗаданияДляОтмены Цикл
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
		Результат.Вставить(ИдентификаторЗадания, Новый Структура("Статус", "Отменено"));
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

#КонецОбласти
