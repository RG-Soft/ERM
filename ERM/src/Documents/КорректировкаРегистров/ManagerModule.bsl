
#Область ПрограммныйИнтерфейс

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт

КонецПроцедуры

// Возвращает пустую структуру. Используется в обработчиках обновления информационной базы.
//
// Параметры:
//	ДокументСсылка - ДокументСсылка.ЗаказКлиента - ссылка на документ, запрос движений которого необходимо получить.
//
// Возвращаемое значение:
//	Структура - пустая структура таблиц движений.
//
Функция ТаблицыДляДвиженийПоРегистрамОбеспечения(ДокументСсылка) Экспорт

	ТаблицыДляДвижений = Новый Структура();
	Возврат ТаблицыДляДвижений;

КонецФункции

#КонецОбласти
