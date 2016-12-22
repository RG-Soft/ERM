﻿
&НаКлиенте
Процедура RWDDeadlineClientПриИзменении(Элемент)
	
	ОбработатьИзменениеRWDDeadlineClient();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеRWDDeadlineClient() Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesRWDDeadline, "Client", RWDDeadlineClient, , , ЗначениеЗаполнено(RWDDeadlineClient));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьИзменениеBrokenPromisesClient() Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesBrokenPromises, "Client", BrokenPromisesClient, , , ЗначениеЗаполнено(BrokenPromisesClient));
	
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
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesRWDDeadline, "RWDTargetDateГраница", КонецДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesRWDDeadline, "Collector", Пользователи.ТекущийПользователь());
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesBrokenPromises, "ForecastDateГраница", КонецДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(InvoicesBrokenPromises, "Collector", Пользователи.ТекущийПользователь());
	
	Если Параметры.Свойство("RWDDeadlineClient") Тогда
		RWDDeadlineClient = Параметры.RWDDeadlineClient;
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(InvoicesRWDDeadline, "Client", RWDDeadlineClient, , , ЗначениеЗаполнено(RWDDeadlineClient));
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
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("Владелец", ТекущийПользователь);
	ПараметрыФормыВыбораШаблона = Новый Структура("Отбор", СтруктураОтбора);
	ОткрытьФорму("Справочник.UsersEMailTemplates.ФормаВыбора", ПараметрыФормыВыбораШаблона, ЭтаФорма,,,, Новый ОписаниеОповещения("ВыбратьTemplateЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьTemplateЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	СтруктураПараметров = ПолучитьСтруктуруПараметровФормыОтправкиПочтовогоСообщения(Результат);
	
	Если СтруктураПараметров <> Неопределено Тогда
		
		ОткрытьФорму("Документ.EMails.Форма.ФормаОтправкиПочтовогоСообщения", СтруктураПараметров, ЭтаФорма);
		
	КонецЕсли;
	
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
	СтруктураПараметров.Вставить("Subject", СтруктураДанныхФормыОтправкиПочтовогоСообщения.Subject);
	СтруктураПараметров.Вставить("Body", СтруктураДанныхФормыОтправкиПочтовогоСообщения.Body);

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
		|	UsersEMailTemplates.Body
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
	КонецЕсли;
	
	ВыборкаРеквизитовUser = СтруктураРезультатов.РеквизитыUser.Выбрать();
	Если ВыборкаРеквизитовUser.Следующий() Тогда
		СтруктураВозврата.Вставить("UserEMailBox", ВыборкаРеквизитовUser.EMailBox);
	КонецЕсли; 
	
	Возврат СтруктураВозврата;
	
КонецФункции

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура")
		И ТипЗнч(ИсточникВыбора) = Тип("УправляемаяФорма")
		И (ИсточникВыбора.ИмяФормы = "Документ.EMails.Форма.ФормаОтправкиПочтовогоСообщения"
		ИЛИ ИсточникВыбора.ИмяФормы = "Документ.EMails.Форма.ФормаОтправкиПочтовогоСообщения_HTML") Тогда
		
		Ответ = ОбработатьПолучениеСтруктурыПочтовогоСообщения(ВыбранноеЗначение);
		
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
Функция ОбработатьПолучениеСтруктурыПочтовогоСообщения(СтруктураПараметров)
	
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
	
			
	ЗафиксироватьТранзакцию();	
	
	// ++ КДС RG-Soft 24.11.2016
	Возврат Новый Структура("записатьИсториюИзменения, ЭлПисьмо", записатьИсториюИзменения, ДокументEMail.Ссылка);
	// -- КДС RG-Soft 24.11.2016
	
КонецФункции

// Записывает вложение электронного письма, расположенное во временном хранилище в файл.
&НаСервере
Функция ЗаписатьВложениеЭлектронногоПисьмаИзВременногоХранилища(
	Письмо,
	АдресВоВременномХранилище,
	ИмяФайла,
	Размер,
	КоличествоПустыхИменВоВложениях = 0) Экспорт
	
	ИмяФайлаДляРазбора = ИмяФайла;
	РасширениеБезТочки = ВзаимодействияКлиентСервер.ПолучитьРасширениеФайла(ИмяФайлаДляРазбора);
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


