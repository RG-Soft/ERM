#Область ПрограммныйИнтерфейс

// Возвращает текущего пользователя или текущего внешнего пользователя,
// в зависимости от того, кто выполнил вход в сеанс.
//  Рекомендуется использовать в коде, который поддерживает работу в обоих случаях.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи, СправочникСсылка.ВнешниеПользователи - пользователь
//    или внешний пользователь.
//
Функция АвторизованныйПользователь() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ПользователиСлужебный.АвторизованныйПользователь();
#Иначе
	Возврат СтандартныеПодсистемыКлиент.ПараметрКлиента("АвторизованныйПользователь");
#КонецЕсли
	
КонецФункции

// Возвращает текущего пользователя.
//  Рекомендуется использовать в коде, который не поддерживает работу с внешними пользователями.
//
//  Если вход в сеанс выполнил внешний пользователь, тогда будет вызвано исключение.
//
// Возвращаемое значение:
//  СправочникСсылка.Пользователи - пользователь.
//
Функция ТекущийПользователь() Экспорт
	
	АвторизованныйПользователь = АвторизованныйПользователь();
	
	Если ТипЗнч(АвторизованныйПользователь) <> Тип("СправочникСсылка.Пользователи") Тогда
		ВызватьИсключение
			НСтр("ru = 'Невозможно получить текущего пользователя
			           |в сеансе внешнего пользователя.'");
	КонецЕсли;
	
	Возврат АвторизованныйПользователь;
	
КонецФункции

// Возвращает текущего внешнего пользователя.
//  Рекомендуется использовать в коде, который поддерживает только внешних пользователей.
//
//  Если вход в сеанс выполнил не внешний пользователь, тогда будет вызвано исключение.
//
// Возвращаемое значение:
//  СправочникСсылка.ВнешниеПользователи - внешний пользователь.
//
Функция ТекущийВнешнийПользователь() Экспорт
	
	АвторизованныйПользователь = АвторизованныйПользователь();
	
	Если ТипЗнч(АвторизованныйПользователь) <> Тип("СправочникСсылка.ВнешниеПользователи") Тогда
		ВызватьИсключение
			НСтр("ru = 'Невозможно получить текущего внешнего пользователя
			           |в сеансе пользователя.'");
	КонецЕсли;
	
	Возврат АвторизованныйПользователь;
	
КонецФункции

// Возвращает Истина, если вход в сеанс выполнил внешний пользователь.
//
// Возвращаемое значение:
//  Булево - Истина, если вход в сеанс выполнил внешний пользователь.
//
Функция ЭтоСеансВнешнегоПользователя() Экспорт
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат ПользователиСлужебныйПовтИсп.ЭтоСеансВнешнегоПользователя();
#Иначе
	Возврат СтандартныеПодсистемыКлиент.ПараметрКлиента("ЭтоСеансВнешнегоПользователя");
#КонецЕсли
	
КонецФункции

#КонецОбласти
