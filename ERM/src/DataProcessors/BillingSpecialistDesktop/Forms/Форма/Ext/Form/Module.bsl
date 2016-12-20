﻿
&НаКлиенте
Процедура AddStatus(Команда)
	
	Если ОтмеченныеSalesOrders.Количество() > 0 Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("AddStatusForSelectedSalesOrders", ЭтотОбъект),
			"Add status for all selected salers orders?", РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		SalesOrdersТекущиеДанные = Элементы.SalesOrders.ТекущиеДанные;
		
		Если SalesOrdersТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура("SalesOrder", SalesOrdersТекущиеДанные.SalesOrder);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ПараметрыФормы.Вставить("Период", ТекущаяДата());
		
		ОткрытьФорму("РегистрСведений.SalesOrdersComments.Форма.ФормаЗаписи", ПараметрыФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура AddStatusForSelectedSalesOrders(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СписокSalesOrders", ОтмеченныеSalesOrders);
		
		ОткрытьФорму("Обработка.BillingSpecialistDesktop.Форма.ФормаСтатусаSalesOrder", ПараметрыФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура PeriodПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Period) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "ДатаДляСравнения", ТекущаяДата());
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "ДатаДляСравнения", Period);
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "ПериодОстатков", Period, ЗначениеЗаполнено(Period));
	
КонецПроцедуры

&НаКлиенте
Процедура SourceПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "Source", Source, , , ЗначениеЗаполнено(Source));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Period) Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "ДатаДляСравнения", ТекущаяДата());
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "МассивОтмеченныхSalesOrders", ОтмеченныеSalesOrders);
КонецПроцедуры

&НаКлиенте
Процедура GeoMarketПриИзменении(Элемент)
	
	//ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "GeoMarket", GeoMarket, ЗначениеЗаполнено(GeoMarket));
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "GeoMarket", GeoMarket, , , ЗначениеЗаполнено(GeoMarket));
	
КонецПроцедуры

&НаКлиенте
Процедура ClientПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "Client", Client, , , ЗначениеЗаполнено(Client));
	
КонецПроцедуры

&НаКлиенте
Процедура CompanyПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "Company", Company, , , ЗначениеЗаполнено(Company));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	
	Для каждого ТекВыделеннаяСтрока Из Элементы.SalesOrders.ВыделенныеСтроки Цикл
		
		ДанныеСтроки = Элементы.SalesOrders.ДанныеСтроки(ТекВыделеннаяСтрока);
		
		ЭлементСписка = ОтмеченныеSalesOrders.НайтиПоЗначению(ДанныеСтроки.SalesOrder);
		Если ЭлементСписка = Неопределено Тогда
			ОтмеченныеSalesOrders.Добавить(ДанныеСтроки.SalesOrder);
		КонецЕсли;
		
	КонецЦикла;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "МассивОтмеченныхSalesOrders", ОтмеченныеSalesOrders.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
		
	ОтмеченныеSalesOrders.Очистить();
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "МассивОтмеченныхSalesOrders", ОтмеченныеSalesOrders.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура AccountПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "Account", Account, , , ЗначениеЗаполнено(Account));
	
КонецПроцедуры

&НаКлиенте
Процедура CommentПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "НетКомментария", Истина, , , NoComments);
	
КонецПроцедуры

&НаКлиенте
Процедура SalesOrdersВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	SalesOrdersТекущиеДанные = Элементы.SalesOrders.ТекущиеДанные;
	
	Если SalesOrdersТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Документ.SalesOrder.Форма.ФормаДокумента", Новый Структура("Ключ", SalesOrdersТекущиеДанные.SalesOrder));

	
КонецПроцедуры

&НаКлиенте
Процедура SalesOrdersПриАктивизацииЯчейки(Элемент)
	
	Если Элемент.ТекущийЭлемент.Имя <> "SalesOrdersПометка" Тогда
		Возврат;
	КонецЕсли;
	
	SalesOrdersТекущиеДанные = Элементы.SalesOrders.ТекущиеДанные;
	
	Если SalesOrdersТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементСписка = ОтмеченныеSalesOrders.НайтиПоЗначению(SalesOrdersТекущиеДанные.SalesOrder);
	Если ЭлементСписка = Неопределено Тогда
		ОтмеченныеSalesOrders.Добавить(SalesOrdersТекущиеДанные.SalesOrder);
	Иначе
		ОтмеченныеSalesOrders.Удалить(ЭлементСписка);
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(SalesOrders, "МассивОтмеченныхSalesOrders", ОтмеченныеSalesOrders.ВыгрузитьЗначения());

КонецПроцедуры

&НаКлиенте
Процедура SegmentПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "Segment", Segment, , , ЗначениеЗаполнено(Segment));
	
КонецПроцедуры

&НаКлиенте
Процедура BilledПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(SalesOrders, "Billed", Billed, , , ЗначениеЗаполнено(Billed));
	
КонецПроцедуры

