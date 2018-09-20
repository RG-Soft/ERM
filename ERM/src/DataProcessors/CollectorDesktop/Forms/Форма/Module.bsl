
&НаКлиенте
Процедура RWDDeadlineClientПриИзменении(Элемент)
	
	ОбработатьИзменениеRWDDeadlineClient();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеRWDDeadlineClient() Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesRWDDeadline, "Client", RWDDeadlineClient, , , ЗначениеЗаполнено(RWDDeadlineClient));
	
КонецПроцедуры

&НаКлиенте
Процедура RWDDeadlineCollectorПриИзменении(Элемент)
	
	ОбработатьИзменениеRWDDeadlineCollector();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеRWDDeadlineCollector() Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesRWDDeadline, "Collector", RWDDeadlineCollector, , , ЗначениеЗаполнено(RWDDeadlineCollector));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеBrokenPromisesClient() Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesBrokenPromises, "Client", BrokenPromisesClient, , , ЗначениеЗаполнено(BrokenPromisesClient));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеBrokenPromisesCollector() Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesBrokenPromises, "Collector", BrokenPromisesCollector, , , ЗначениеЗаполнено(BrokenPromisesCollector));
	
КонецПроцедуры

&НаКлиенте
Процедура AddStatus(Команда)
	
	Если Элементы.Invoices.ВыделенныеСтроки.Количество() > 1 Тогда
		
		ПоказатьВопрос(Новый ОписаниеОповещения("AddStatusForSelectedInvoices", ЭтотОбъект),
			"Add status for all selected invoices?", РежимДиалогаВопрос.ДаНет);
		
	Иначе
		
		InvoicesТекущиеДанные = Элементы.Invoices.ТекущиеДанные;
		
		Если InvoicesТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		ЗначенияЗаполнения = Новый Структура("Invoice", InvoicesТекущиеДанные.Invoice);
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
		ПараметрыФормы.Вставить("Период", ТекущаяДата());
		
		ОткрытьФорму("РегистрСведений.InvoiceComments.Форма.ФормаЗаписи", ПараметрыФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура AddStatusForSelectedInvoices(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		ОтмеченныеИнвойсы = Новый СписокЗначений;
		
		Для каждого ТекВыделеннаяСтрока Из Элементы.Invoices.ВыделенныеСтроки Цикл
			
			ДанныеСтроки = Элементы.Invoices.ДанныеСтроки(ТекВыделеннаяСтрока);
			
			ЭлементСписка = ОтмеченныеИнвойсы.НайтиПоЗначению(ДанныеСтроки.Invoice);
			Если ЭлементСписка = Неопределено Тогда
				ОтмеченныеИнвойсы.Добавить(ДанныеСтроки.Invoice);
			КонецЕсли;
			
		КонецЦикла;
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("СписокИнвойсов", ОтмеченныеИнвойсы);
		
		ОткрытьФорму("Обработка.CollectorDesktop.Форма.ФормаСтатусаИнвойса", ПараметрыФормы, ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура PeriodПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Invoices, "ПериодОстатков", Period, ЗначениеЗаполнено(Period));
	
КонецПроцедуры

&НаКлиенте
Процедура SourceПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Source", Source, , , ЗначениеЗаполнено(Source));
	
КонецПроцедуры

&НаКлиенте
Процедура InvoicesВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	InvoicesТекущиеДанные = Элементы.Invoices.ТекущиеДанные;
	
	Если InvoicesТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Документ.Invoice.Форма.ФормаДокумента", Новый Структура("Ключ", InvoicesТекущиеДанные.Invoice));
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	
	//ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Invoices, "МассивОтмеченныхИнвойсов", ОтмеченныеИнвойсы);
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Invoices, "RWDTargetDateГраница", КонецДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesRWDDeadline, "RWDTargetDateГраница", КонецДня(ТекущаяДата()));
	//ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesRWDDeadline, "Collector", Пользователи.ТекущийПользователь());
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesBrokenPromises, "ForecastDateГраница", КонецДня(ТекущаяДата()));
	//ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesBrokenPromises, "Collector", Пользователи.ТекущийПользователь());
	
	Если Параметры.Свойство("BrokenPromisesClient") Тогда
		BrokenPromisesClient = Параметры.BrokenPromisesClient;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesBrokenPromises, "Client", BrokenPromisesClient, , , ЗначениеЗаполнено(BrokenPromisesClient));
	КонецЕсли;
	
	Если Параметры.Свойство("RWDDeadlineClient") Тогда
		RWDDeadlineClient = Параметры.RWDDeadlineClient;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesRWDDeadline, "Client", RWDDeadlineClient, , , ЗначениеЗаполнено(RWDDeadlineClient));
	КонецЕсли;
	
	Если Параметры.Свойство("BrokenPromisesCollector") Тогда
		BrokenPromisesCollector = Параметры.BrokenPromisesCollector;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesBrokenPromises, "Collector", BrokenPromisesCollector, , , ЗначениеЗаполнено(BrokenPromisesCollector));
	КонецЕсли;
	
	Если Параметры.Свойство("RWDDeadlineCollector") Тогда
		RWDDeadlineCollector = Параметры.RWDDeadlineCollector;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesRWDDeadline, "Collector", RWDDeadlineCollector, , , ЗначениеЗаполнено(RWDDeadlineCollector));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура InvoicesПриАктивизацииЯчейки(Элемент)
	
	//Если Элемент.ТекущийЭлемент.Имя <> "InvoicesПометка" Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//InvoicesТекущиеДанные = Элементы.Invoices.ТекущиеДанные;
	//
	//Если InvoicesТекущиеДанные = Неопределено Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//ЭлементСписка = ОтмеченныеИнвойсы.НайтиПоЗначению(InvoicesТекущиеДанные.Invoice);
	//Если ЭлементСписка = Неопределено Тогда
	//	ОтмеченныеИнвойсы.Добавить(InvoicesТекущиеДанные.Invoice);
	//Иначе
	//	ОтмеченныеИнвойсы.Удалить(ЭлементСписка);
	//КонецЕсли;
	//
	//ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Invoices, "МассивОтмеченныхИнвойсов", ОтмеченныеИнвойсы.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура GeoMarketПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "GeoMarket", GeoMarket, , , ЗначениеЗаполнено(GeoMarket));
	
КонецПроцедуры

&НаКлиенте
Процедура ClientПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Client", Client, , , ЗначениеЗаполнено(Client));
	
КонецПроцедуры

&НаКлиенте
Процедура CompanyПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Company", Company, , , ЗначениеЗаполнено(Company));
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажки(Команда)
	//
	//Для каждого ТекВыделеннаяСтрока Из Элементы.Invoices.ВыделенныеСтроки Цикл
	//	
	//	ДанныеСтроки = Элементы.Invoices.ДанныеСтроки(ТекВыделеннаяСтрока);
	//	
	//	ЭлементСписка = ОтмеченныеИнвойсы.НайтиПоЗначению(ДанныеСтроки.Invoice);
	//	Если ЭлементСписка = Неопределено Тогда
	//		ОтмеченныеИнвойсы.Добавить(ДанныеСтроки.Invoice);
	//	КонецЕсли;
	//	
	//КонецЦикла;
	//
	//ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Invoices, "МассивОтмеченныхИнвойсов", ОтмеченныеИнвойсы.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажки(Команда)
	
	//Для каждого ТекВыделеннаяСтрока Из Элементы.Invoices.ВыделенныеСтроки Цикл
	//	
	//	ДанныеСтроки = Элементы.Invoices.ДанныеСтроки(ТекВыделеннаяСтрока);
	//	
	//	ЭлементСписка = ОтмеченныеИнвойсы.НайтиПоЗначению(ДанныеСтроки.Invoice);
	//	Если ЭлементСписка <> Неопределено Тогда
	//		ОтмеченныеИнвойсы.Удалить(ЭлементСписка);
	//	КонецЕсли;
	//	
	//КонецЦикла;
	
	//ОтмеченныеИнвойсы.Очистить();
	//
	//ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Invoices, "МассивОтмеченныхИнвойсов", ОтмеченныеИнвойсы.ВыгрузитьЗначения());
	
КонецПроцедуры

&НаКлиенте
Процедура AccountПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Account", Account, , , ЗначениеЗаполнено(Account));
	
КонецПроцедуры

&НаКлиенте
Процедура CommentПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "НетКомментария", Истина, , , NoComments);
	
КонецПроцедуры

&НаКлиенте
Процедура CollectorПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Collector", Collector, , , ЗначениеЗаполнено(Collector));
	
КонецПроцедуры

&НаКлиенте
Процедура BrokenPromisesClientПриИзменении(Элемент)
	
	ОбработатьИзменениеBrokenPromisesClient();
	
КонецПроцедуры

&НаКлиенте
Процедура Escalate(Команда)
	
//	СтруктураОтбора = Новый Структура;
//	СтруктураОтбора.Вставить("Владелец", ТекущийПользователь);
//	ПараметрыФормыВыбораШаблона = Новый Структура("Отбор", СтруктураОтбора);
	ОткрытьФорму("Справочник.UsersEMailTemplates.ФормаВыбора", , ЭтаФорма,,,, Новый ОписаниеОповещения("ВыбратьTemplateЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьTemplateЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормыОтправкиПочтовогоСообщения(Результат);
	
	Если СтруктураПараметров <> Неопределено Тогда
		
		МассивИнвойсовДляЭскалации = Новый Массив;
		
		Для каждого ТекВыделеннаяСтрока Из Элементы.Invoices.ВыделенныеСтроки Цикл
			ДанныеСтроки = Элементы.Invoices.ДанныеСтроки(ТекВыделеннаяСтрока);
			МассивИнвойсовДляЭскалации.Добавить(ДанныеСтроки.Invoice);
		КонецЦикла;
		
		СформироватьВложениеПоЭкалированнымИнвойсам(СтруктураПараметров, МассивИнвойсовДляЭскалации);
		ДополнительныеПараметры = Новый Массив;
		//ДополнительныеПараметры.Вставить(Новый Структура("МассивИнвойсовДляЭскалации", МассивИнвойсовДляЭскалации));
		СтруктураПараметров.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтправкаПочтовогоСообщенияЗавершение", ЭтаФорма, МассивИнвойсовДляЭскалации);
		ОткрытьФорму("Документ.EMails.Форма.ФормаОтправкиПочтовогоСообщения", СтруктураПараметров, ЭтаФорма, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаПочтовогоСообщенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Ответ = ОбработатьПолучениеСтруктурыПочтовогоСообщения(Результат, ДополнительныеПараметры);
	
КонецПроцедуры


&НаКлиенте
Функция ПолучитьСтруктуруПараметровФормыОтправкиПочтовогоСообщения(Template)
	
	СтруктураДанныхФормыОтправкиПочтовогоСообщения = ПолучитьСтруктуруДанныхФормыОтправкиПочтовогоСообщения(Template);
	
	Отказ = Ложь;
	
	Если НЕ СтруктураДанныхФормыОтправкиПочтовогоСообщения.Свойство("UserEMailBox")
		ИЛИ НЕ ЗначениеЗаполнено(СокрЛП(СтруктураДанныхФормыОтправкиПочтовогоСообщения.UserEMailBox)) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Не удалось определить e-mail текущего пользователя. Попросите администратора заполнить ваш e-mail.",
			, , "Объект", Отказ);
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли; 
	
	СтруктураПараметров = Новый Структура;
	
	СтруктураПараметров.Вставить("ReplyTo", СтруктураДанныхФормыОтправкиПочтовогоСообщения.UserEMailBox);
	Если СтруктураДанныхФормыОтправкиПочтовогоСообщения.Свойство("Subject") Тогда
		СтруктураПараметров.Вставить("Subject", СтруктураДанныхФормыОтправкиПочтовогоСообщения.Subject);
	КонецЕсли;
	Если СтруктураДанныхФормыОтправкиПочтовогоСообщения.Свойство("Body") Тогда
		СтруктураПараметров.Вставить("Body", СтруктураДанныхФормыОтправкиПочтовогоСообщения.Body);
	КонецЕсли;
	Если СтруктураДанныхФормыОтправкиПочтовогоСообщения.Свойство("Dispute") Тогда
		СтруктураПараметров.Вставить("Dispute", СтруктураДанныхФормыОтправкиПочтовогоСообщения.Dispute);
	КонецЕсли;

	Возврат СтруктураПараметров;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьСтруктуруДанныхФормыОтправкиПочтовогоСообщения(Template)
	
	СтруктураПараметров = Новый Структура;
	СтруктураТекстов = Новый Структура;
		
	СтруктураПараметров.Вставить("Template", Template);
	СтруктураТекстов.Вставить("РеквизитыTemplate",
		"ВЫБРАТЬ
		|	UsersEMailTemplates.Subject,
		|	UsersEMailTemplates.Body,
		|	UsersEMailTemplates.Dispute
		|ИЗ
		|	Справочник.UsersEMailTemplates КАК UsersEMailTemplates
		|ГДЕ
		|	UsersEMailTemplates.Ссылка = &Template");
		
	СтруктураПараметров.Вставить("User", Пользователи.ТекущийПользователь());
	СтруктураТекстов.Вставить("РеквизитыUser",
		"ВЫБРАТЬ
		|	Пользователи.ПользовательLDAP.Mail КАК EMailBox
		|ИЗ
		|	Справочник.Пользователи КАК Пользователи
		|ГДЕ
		|	Пользователи.Ссылка = &User");
		
	СтруктураРезультатов = РГСофт.ПолучитьСтруктуруРезультатовТекстовЗапросов(СтруктураТекстов, СтруктураПараметров);
	
	СтруктураВозврата = Новый Структура;
	
	ВыборкаРеквизитовTemplate = СтруктураРезультатов.РеквизитыTemplate.Выбрать();
	Если ВыборкаРеквизитовTemplate.Следующий() Тогда
		СтруктураВозврата.Вставить("Subject", СокрЛП(ВыборкаРеквизитовTemplate.Subject));
		СтруктураВозврата.Вставить("Body", СокрЛП(ВыборкаРеквизитовTemplate.Body));
		СтруктураВозврата.Вставить("Dispute", СокрЛП(ВыборкаРеквизитовTemplate.Dispute));
	КонецЕсли;
	
	ВыборкаРеквизитовUser = СтруктураРезультатов.РеквизитыUser.Выбрать();
	Если ВыборкаРеквизитовUser.Следующий() Тогда
		СтруктураВозврата.Вставить("UserEMailBox", ВыборкаРеквизитовUser.EMailBox);
	КонецЕсли; 
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаСервере
Процедура СформироватьВложениеПоЭкалированнымИнвойсам(СтруктураПараметров, МассивИнвойсовДляЭскалации)
	
	Если МассивИнвойсовДляЭскалации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	InvoiceДокумент.DocNumber КАК InvNo,
		|	InvoiceДокумент.Дата КАК InvDate,
		|	InvoiceДокумент.FiscalInvoiceNo,
		|	InvoiceДокумент.FiscalInvoiceDate,
		|	InvoiceДокумент.Client.CRMID КАК CRMID,
		|	InvoiceДокумент.Client,
		|	InvoiceДокумент.Currency,
		|	InvoiceДокумент.Amount,
		|	ВЫРАЗИТЬ(InvoiceДокумент.Amount / ВнутренниеКурсыВалютСрезПоследних.Курс * ВнутренниеКурсыВалютСрезПоследних.Кратность КАК ЧИСЛО(15, 2)) КАК AmountUSD,
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status,
		|	InvoiceCommentsСрезПоследних.Problem.ConfirmedBy КАК ConfirmedBy,
		|	InvoiceCommentsСрезПоследних.Problem.ForecastDate КАК ForecastDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustInputDate КАК InitialForecastDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerRepresentative КАК CustomerRepresentative,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerInputDetails КАК CustomerInputDetails,
		|	InvoiceCommentsСрезПоследних.Problem.RemedialWorkPlan КАК RemedialWorkPlan,
		|	InvoiceCommentsСрезПоследних.Problem.RWDTargetDate КАК RWDTargetDate,
		|	InvoiceCommentsСрезПоследних.Problem.Comment КАК Comment
		|ИЗ
		|	Документ.Invoice КАК InvoiceДокумент
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО InvoiceДокумент.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments.СрезПоследних(, Invoice В (&МассивИнвойсов)) КАК InvoiceCommentsСрезПоследних
		|		ПО InvoiceДокумент.Ссылка = InvoiceCommentsСрезПоследних.Invoice
		|ГДЕ
		|	InvoiceДокумент.Ссылка В(&МассивИнвойсов)";
	
	Запрос.УстановитьПараметр("МассивИнвойсов", МассивИнвойсовДляЭскалации);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ТаблицаДанных = РезультатЗапроса.Выгрузить();;
	
	ТабДок = Новый ТабличныйДокумент;
	
	Построитель = Новый ПостроительОтчета();
	
	Если ТаблицаДанных.Количество() > 0 Тогда
		
		Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаДанных);
		Построитель.ВыводитьЗаголовокОтчета = Ложь;
		Построитель.Вывести(ТабДок);
		
		Каталог = КаталогВременныхФайлов();
		
		ИмяФайла = Каталог + "Invoices.xls";
		
		ТабДок.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.XLS);
		
		ПриложенныеФайлы = Новый Массив();
		ПриложенныеФайлы.Добавить(Новый Структура("ИмяФайла, РасширениеФайла, ДанныеФайла", "Invoices", "xls", ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла), Новый УникальныйИдентификатор())));
		СтруктураПараметров.Вставить("ПриложенныеФайлы", ПриложенныеФайлы);
		
		УдалитьФайлы(ИмяФайла);
		
	КонецЕсли;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")
		И ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма")
		И (ИсточникВыбора.ИмяФормы = "Документ.EMails.Форма.ФормаОтправкиПочтовогоСообщения"
		ИЛИ ИсточникВыбора.ИмяФормы = "Документ.EMails.Форма.ФормаОтправкиПочтовогоСообщения_HTML") Тогда
		
		Ответ = ОбработатьПолучениеСтруктурыПочтовогоСообщения(ВыбранноеЗначение, Неопределено );
		
		Если Ответ = Неопределено Тогда
			Возврат;
		КонецЕсли;
		
		Если Ответ.ЗаписатьИсториюИзменения Тогда
			//ТД = Элементы.Goods.ТекущиеДанные;
			//Если НЕ ТД = Неопределено Тогда
			//	ЗаписатьНовоеЗначениеСтатуса(ТД.TDStatus, ТД.PartNo, Объект.Ссылка, ТД.TDQuery, Ответ.ЭлПисьмо);
			//	// надо найти все строки с таким парт но и установить тот же статус
			//	УстановитьСтатусДляАналогичныхСтрок(ТД);
			//	ЭтаФорма.Прочитать();
			//КонецЕсли;
			
		КонецЕсли;
				
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция ОбработатьПолучениеСтруктурыПочтовогоСообщения(СтруктураПараметров, ДополнительныеПараметры)
	
	НачатьТранзакцию();
	
	// ++ КДС RG-Soft 24.11.2016
	ЗаписатьИсториюИзменения = Ложь;
	Если СтруктураПараметров.Свойство("TechDOC") И СтруктураПараметров.TechDOC Тогда
		
		// это означает, что письмо отправлено. 
		// тогда остается, но надо записать в историю изменение с записью ссылки на письмо
		ЗаписатьИсториюИзменения = Истина;
		
	Иначе
	// -- КДС RG-Soft 24.11.2016
	
	КонецЕсли;

	// Создадим и отправим EMail	
	УстановитьПривилегированныйРежим(Истина);
	ДокументEMail = Документы.EMails.СоздатьДокумент();
	ДокументEMail.Дата = ТекущаяДата();
	ДокументEMail.Заполнить(СтруктураПараметров);
	ДокументEMail.Записать(РежимЗаписиДокумента.Запись);
	
	// обработка вложений
	Для Каждого СтрокаТаблицыВложений Из СтруктураПараметров.Attachments Цикл
		
		Размер = 0;
		ИмяФайла = СтрокаТаблицыВложений.ИмяФайла;
		
		Если СтрокаТаблицыВложений.Расположение = 4 Тогда
			// из временного хранилища
			ЗаписатьВложениеЭлектронногоПисьмаИзВременногоХранилища(
				ДокументEMail.Ссылка, СтрокаТаблицыВложений.ИмяФайлаНаКомпьютере, ИмяФайла, Размер);
			
		ИначеЕсли СтрокаТаблицыВложений.Расположение = 3 Тогда
			// из файла на сервере
			
		//ИначеЕсли СтрокаТаблицыВложений.Расположение = 1 Тогда
		//	
		//	УправлениеЭлектроннойПочтой.ЗаписатьВложениеЭлектронногоПисьмаСкопировавВложениеДругогоПисьма(
		//		Письмо, СтрокаТаблицыВложений.Ссылка, УникальныйИдентификатор);
			
		ИначеЕсли СтрокаТаблицыВложений.Расположение = 0 Тогда
			// перезаписать вложение
			
		КонецЕсли;
		
		СтрокаТаблицыВложений.Расположение = 0;
		
	КонецЦикла;
	
	Для каждого Вложение Из СтруктураПараметров.ТаблицаСоответствийИменВложенийИдентификаторам Цикл
		
		ДвоичныеДанныеКартинки = Вложение.Картинка.ПолучитьДвоичныеДанные();
		АдресКартинкиВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеКартинки, УникальныйИдентификатор);
		ПрисоединенныйФайл = ЗаписатьВложениеЭлектронногоПисьмаИзВременногоХранилища(
		                     ДокументEMail.Ссылка,
		                     АдресКартинкиВоВременномХранилище,
		                     "_" + СтрЗаменить(Вложение.ИдентификаторФайлаДляHTML, "-", "_"),
		                     ДвоичныеДанныеКартинки.Размер());
		
		Если ПрисоединенныйФайл <> Неопределено Тогда
			ПрисоединенныйФайлОбъект = ПрисоединенныйФайл.ПолучитьОбъект();
			ПрисоединенныйФайлОбъект.ИДФайлаЭлектронногоПисьма = Вложение.ИдентификаторФайлаДляHTML;
			ПрисоединенныйФайлОбъект.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
	// добавим к документам комментарии
	Если ТипЗнч(ДополнительныеПараметры) = Тип("Массив") Тогда
		SLBAssignedTo = Новый ТаблицаЗначений;
		SLBAssignedTo.Колонки.Добавить("AssignedTo", Новый ОписаниеТипов("СправочникСсылка.LDAPUsers"));
		Для каждого СтрокаДанных Из СтруктураПараметров.Recipients Цикл
			НоваяСтрока = SLBAssignedTo.Добавить();
			НоваяСтрока.AssignedTo = СтрокаДанных.Recipient;
		КонецЦикла;
		СозданныеКомментарии = ДобавитьКомментарийОбЭскалации(ДополнительныеПараметры, SLBAssignedTo);
		Если СозданныеКомментарии.Количество() > 0 Тогда
			СтрокаТЧ = ДокументEMail.Headers.Добавить();
			СтрокаТЧ.Name = "X-1C-Escalation-ID";
			СтрокаТЧ.Value = Строка(ДокументEMail.Ссылка.УникальныйИдентификатор());
		КонецЕсли;
		ЗарегистрироватьПредметыПисьма(ДокументEMail.Ссылка, СозданныеКомментарии, Перечисления.ВариантОтправленияСообщения.Escalation);
		ЗарегистрироватьПредметыПисьма(ДокументEMail.Ссылка, ДополнительныеПараметры, Перечисления.ВариантОтправленияСообщения.Escalation);
	//{RGS AArsentev 26.01.2017 S-E-0000048
	ИначеЕсли ТипЗнч(ДополнительныеПараметры) = Тип("Структура") Тогда
		ЗарегистрироватьПредметыПисьма(ДокументEMail.Ссылка, ДополнительныеПараметры.Инвойсы, Перечисления.ВариантОтправленияСообщения.MailToClient);
	//}RGS AArsentev 26.01.2017 S-E-0000048
	КонецЕсли;
	
	Попытка
		ДокументEMail.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		
		ОтменитьТранзакцию();

		Сообщить(
			"Failed to send email.
			|See errors above.
			|" + ОписаниеОшибки());		
		Возврат Неопределено;
		
	КонецПопытки;
	
	ДокументEMail.Записать();
			
	ЗафиксироватьТранзакцию();
	
	// ++ КДС RG-Soft 24.11.2016
	Возврат Новый Структура("записатьИсториюИзменения, ЭлПисьмо", записатьИсториюИзменения, ДокументEMail.Ссылка);
	// -- КДС RG-Soft 24.11.2016
	
КонецФункции

&НаСервереБезКонтекста
Функция ДобавитьКомментарийОбЭскалации(МассивИнвойсов, SLBAssignedTo)
	
	СозданныеКомментарии = Новый Массив;
	
	МассивПолучателей = Новый Массив;
	Для каждого СтрокаПолучателя ИЗ SLBAssignedTo Цикл
		МассивПолучателей.Добавить(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаПолучателя.AssignedTo, "Наименование"));
	КонецЦикла;
	ПолучателиСтрокой = СтрСоединить(МассивПолучателей, ", ");
	
	Период = ТекущаяДата();
	ТекущийПользователь = Пользователи.ТекущийПользователь();
	НЗ = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	InvoiceCommentsСрезПоследних.Invoice,
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status,
		|	InvoiceCommentsСрезПоследних.Problem.ConfirmedBy КАК ConfirmedBy,
		|	InvoiceCommentsСрезПоследних.Problem.ForecastDate КАК ForecastDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustInputDate КАК CustInputDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerRepresentative КАК CustomerRepresentative,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerInputDetails КАК CustomerInputDetails,
		|	InvoiceCommentsСрезПоследних.Problem.RemedialWorkPlan КАК RemedialWorkPlan,
		|	InvoiceCommentsСрезПоследних.Problem.RWDTargetDate КАК RWDTargetDate,
		|	InvoiceCommentsСрезПоследних.Problem.Comment КАК Comment
		|ИЗ
		|	РегистрСведений.InvoiceComments.СрезПоследних(, Invoice В (&МассивИнвойсов)) КАК InvoiceCommentsСрезПоследних";
	
	Запрос.УстановитьПараметр("МассивИнвойсов", МассивИнвойсов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	МассивИнвойсовСКомментариями = Новый Массив;
	
	ТекДата = ТекущаяДата();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		
		ЗаписьРегистра = НЗ.Добавить();
		ЗаписьРегистра.Период = ТекДата;
		
		СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, ConfirmedBy, CustomerRepresentative, CustomerInputDetails, Comment, CustInputDate, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");
		ЗаполнитьЗначенияСвойств(СтруктураРеквизитовПроблемы, ВыборкаДетальныеЗаписи);
		СтруктураРеквизитовПроблемы.Дата = ТекДата;
		СтруктураРеквизитовПроблемы.Invoice = ВыборкаДетальныеЗаписи.Invoice;
		СтруктураРеквизитовПроблемы.User = ТекущийПользователь;
		СтруктураРеквизитовПроблемы.SLBAssignedTo = SLBAssignedTo;
		СтруктураРеквизитовПроблемы.CustomerInputDetails = Формат(ТекДата, "ДФ=M.d.yyyy") + " - " + ПолучателиСтрокой;
		СтруктураРеквизитовПроблемы.RemedialWorkPlan = "repeat call/message " + ПолучателиСтрокой;
		СтруктураРеквизитовПроблемы.RWDTargetDate = КалендарныеГрафики.ПолучитьДатуПоКалендарю(КалендарныеГрафики.ПроизводственныйКалендарьРоссийскойФедерации(), ТекДата, 2);
		
		ЗаполнитьЗначенияСвойств(ЗаписьРегистра, СтруктураРеквизитовПроблемы);
		ЗаписьРегистра.Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
		СозданныеКомментарии.Добавить(ЗаписьРегистра.Problem);
		
		МассивИнвойсовСКомментариями.Добавить(ВыборкаДетальныеЗаписи.Invoice);
	
	КонецЦикла;
	
	Для каждого ТекИнвойс Из МассивИнвойсов Цикл
		
		Если МассивИнвойсовСКомментариями.Найти(ТекИнвойс) = Неопределено Тогда
			
			ЗаписьРегистра = НЗ.Добавить();
			ЗаписьРегистра.Период = Период;
			
			СтруктураРеквизитовПроблемы = Новый Структура("Дата, Invoice, User, Status, ConfirmedBy, CustomerRepresentative, CustomerInputDetails, Comment, CustInputDate, ForecastDate, RemedialWorkPlan, RWDTargetDate, SLBAssignedTo");
			СтруктураРеквизитовПроблемы.Дата = Период;
			СтруктураРеквизитовПроблемы.Invoice = ТекИнвойс;
			СтруктураРеквизитовПроблемы.User = ТекущийПользователь;
			СтруктураРеквизитовПроблемы.SLBAssignedTo = SLBAssignedTo;
			СтруктураРеквизитовПроблемы.CustomerInputDetails = Формат(ТекДата, "ДФ=M.d.yyyy") + " - " + ПолучателиСтрокой;
			СтруктураРеквизитовПроблемы.RemedialWorkPlan = "repeat call/message " + ПолучателиСтрокой;
			СтруктураРеквизитовПроблемы.RWDTargetDate = КалендарныеГрафики.ПолучитьДатуПоКалендарю(КалендарныеГрафики.ПроизводственныйКалендарьРоссийскойФедерации(), ТекДата, 2);
			
			ЗаполнитьЗначенияСвойств(ЗаписьРегистра, СтруктураРеквизитовПроблемы);
			ЗаписьРегистра.Problem = РегистрыСведений.InvoiceComments.СоздатьInvoiceProblem(СтруктураРеквизитовПроблемы);
			СозданныеКомментарии.Добавить(ЗаписьРегистра.Problem);
		
		КонецЕсли;
	
	КонецЦикла;
	
	НЗ.Записать(Ложь);
	
	Возврат СозданныеКомментарии;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ЗарегистрироватьПредметыПисьма(Email, Предметы, MailType)
	
	НЗ = РегистрыСведений.EmailsObjects.СоздатьНаборЗаписей();
	
	Для каждого ТекПредмет Из Предметы Цикл
		ЗаписьНабора = НЗ.Добавить();
		ЗаписьНабора.Email = Email;
		ЗаписьНабора.Предмет = ТекПредмет;
		ЗаписьНабора.MailType = MailType;
	КонецЦикла;
	
	НЗ.Записать(Ложь);
	
КонецПроцедуры

// Записывает вложение электронного письма, расположенное во временном хранилище в файл.
&НаСервере
Функция ЗаписатьВложениеЭлектронногоПисьмаИзВременногоХранилища(
	Письмо,
	АдресВоВременномХранилище,
	ИмяФайла,
	Размер,
	КоличествоПустыхИменВоВложениях = 0) Экспорт
	
	ИмяФайлаДляРазбора = ИмяФайла;
	РасширениеБезТочки = ВзаимодействияКлиентСервер.РасширениеФайла(ИмяФайлаДляРазбора);
	ИмяБезРасширения = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаДляРазбора);
	Если ПустаяСтрока(ИмяБезРасширения) Тогда
		
		ИмяФайлаБезРасширения =
			НСтр("ru = 'Вложение без имени'") + ?(КоличествоПустыхИменВоВложениях = 0, ""," " + Строка(КоличествоПустыхИменВоВложениях + 1));
		КоличествоПустыхИменВоВложениях = КоличествоПустыхИменВоВложениях + 1;
		
	Иначе
		ИмяБезРасширения =
			?(РасширениеБезТочки = "",
			ИмяБезРасширения,
			Лев(ИмяБезРасширения, СтрДлина(ИмяБезРасширения) - СтрДлина(РасширениеБезТочки) - 1));
	КонецЕсли;
		
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов",              Письмо);
	ПараметрыФайла.Вставить("Автор",                       Неопределено);
	ПараметрыФайла.Вставить("ИмяБезРасширения",            ИмяБезРасширения);
	ПараметрыФайла.Вставить("РасширениеБезТочки",          РасширениеБезТочки);
	ПараметрыФайла.Вставить("ВремяИзменения",              Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
	Возврат ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(
		ПараметрыФайла,
		АдресВоВременномХранилище,
		"");
	
КонецФункции

&НаКлиенте
Процедура CRMIDПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "CRMID", CRMID, , , ЗначениеЗаполнено(CRMID));
	
КонецПроцедуры

&НаКлиенте
Процедура StatusПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Status", Status, , , ЗначениеЗаполнено(Status));
	
КонецПроцедуры

&НаКлиенте
Процедура ForecastDateПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "ForecastDate", КонецДня(ForecastDate), ВидСравненияКомпоновкиДанных.МеньшеИлиРавно, , ЗначениеЗаполнено(ForecastDate));
	
КонецПроцедуры

&НаКлиенте
Процедура FiscalInvDateПриИзменении(Элемент)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(FiscalInvDate);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "FiscalInvDateНачалДня", НачалоДня(FiscalInvDate), ВидСравненияКомпоновкиДанных.Равно, , ИспользоватьОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура InvoiceDateПриИзменении(Элемент)
	
	ИспользоватьОтбор = ЗначениеЗаполнено(InvoiceDate);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "InvDateНачалоДня", НачалоДня(InvoiceDate), ВидСравненияКомпоновкиДанных.Равно, , ИспользоватьОтбор);
	
КонецПроцедуры

&НаКлиенте
Процедура AgreementПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Contract", Agreement, , , ЗначениеЗаполнено(Agreement));
	
КонецПроцедуры

&НаКлиенте
Процедура NoDetailsПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "НетДеталей", Истина, , , NoDetails);
	
КонецПроцедуры

&НаКлиенте
Процедура ForecastDateEmptyПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "ForecastDate", Дата(1,1,1), , ,ForecastDateEmpty);
	
КонецПроцедуры

&НаКлиенте
Процедура RWDTargetDateПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "RWDDeadline", RWDDeadline, , , RWDDeadline);
	
КонецПроцедуры

&НаКлиенте
Процедура SegmentПриИзменении(Элемент)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Invoices, "Segment", Segment, , , ЗначениеЗаполнено(Segment));
	
КонецПроцедуры

&НаКлиенте 
Процедура MailToClient(Команда)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", ТекущийПользователь);
	ПараметрыФормыВыбораШаблона = Новый Структура("Отбор", СтруктураОтбора);
	ОткрытьФорму("Справочник.UsersEMailTemplates.ФормаВыбора", ПараметрыФормыВыбораШаблона, ЭтаФорма,,,, Новый ОписаниеОповещения("ВыбратьTemplateЗавершение_ToClient", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры 

&НаКлиенте
Процедура ВыбратьTemplateЗавершение_ToClient(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормыОтправкиПочтовогоСообщения(Результат);
	
	Если СтруктураПараметров <> Неопределено Тогда
		
		МассивКлиентов = Новый Массив;
		МассивИнвойсов = Новый Массив;
		
		Для каждого ТекВыделеннаяСтрока Из Элементы.Invoices.ВыделенныеСтроки Цикл
			ДанныеСтроки = Элементы.Invoices.ДанныеСтроки(ТекВыделеннаяСтрока);
			МассивКлиентов.Добавить(ДанныеСтроки.Client);
			МассивИнвойсов.Добавить(ДанныеСтроки.Invoice);
		КонецЦикла;
		
		ДополнительныеПараметры = Новый Структура;
		
		СтруктураПараметров.Вставить("ДополнительныеПараметры", ДополнительныеПараметры);
		
		ДополнительныеПараметры.Вставить("Инвойсы", МассивИнвойсов);
		
		ОписаниеОповещения = Новый ОписаниеОповещения("ОтправкаПочтовогоСообщенияЗавершение", ЭтаФорма, ДополнительныеПараметры);
		
		СтруктураПараметров.Вставить("Адресаты", МассивКлиентов);
		
		ОткрытьФорму("Документ.EMails.Форма.ФормаОтправкиПочтовогоСообщения", СтруктураПараметров, ЭтаФорма, , , , ОписаниеОповещения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура BrokenPromisesCollectorПриИзменении(Элемент)
	
	ОбработатьИзменениеBrokenPromisesCollector();
	
КонецПроцедуры

&НаКлиенте
Процедура InvoicesBrokenPromisesВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	InvoicesТекущиеДанные = Элементы.InvoicesBrokenPromises.ТекущиеДанные;
	
	Если InvoicesТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Документ.Invoice.Форма.ФормаДокумента", Новый Структура("Ключ", InvoicesТекущиеДанные.Ссылка));
	
КонецПроцедуры

&НаКлиенте
Процедура InvoicesRWDDeadlineВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	InvoicesТекущиеДанные = Элементы.InvoicesRWDDeadline.ТекущиеДанные;
	
	Если InvoicesТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("Документ.Invoice.Форма.ФормаДокумента", Новый Структура("Ключ", InvoicesТекущиеДанные.Ссылка));
	
КонецПроцедуры






