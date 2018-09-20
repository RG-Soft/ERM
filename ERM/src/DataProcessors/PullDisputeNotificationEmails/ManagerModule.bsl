#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ОбработатьПисьма(Письма, ДанныеУчетнойЗаписи) Экспорт
	
	ОбработанныеПисьма = Новый Массив;
	
	Для Каждого Письмо Из Письма Цикл
		
		ОбработатьПисьмо(Письмо, ДанныеУчетнойЗаписи);
		ОбработанныеПисьма.Добавить(Письмо);
		
	КонецЦикла;
	
	Возврат ОбработанныеПисьма;
	
КонецФункции

Процедура ОбработатьПисьмо(Письмо, ДанныеУчетнойЗаписи) Экспорт
	
	НачатьТранзакцию();
	
	СозданноеПисьмо = rgsУправлениеЭлектроннойПочтой.ЗаписатьЭлектронноеПисьмо(ДанныеУчетнойЗаписи, Письмо, Ложь); 
	InvoiceProblems = ПолучитьКомментарииИнвойсовПоИдентификаторуПисьма(СозданноеПисьмо.ИдентификаторОснования);
	
	ДатаНовогоКомментария = ТекущаяДата();
	НЗ = РегистрыСведений.InvoiceComments.СоздатьНаборЗаписей();
	
	Для Каждого InvoiceProblem Из InvoiceProblems Цикл
		НовыйКомментарийИнвойса = Документы.InvoiceProblem.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(НовыйКомментарийИнвойса, InvoiceProblem, , "Дата, Номер, RemedialWorkPlan");
		НовыйКомментарийИнвойса.SLBAssignedTo.Загрузить(InvoiceProblem.SLBAssignedTo.Выгрузить());
		НовыйКомментарийИнвойса.Дата = ДатаНовогоКомментария;
		НовыйКомментарийИнвойса.CustomerInputDetails = Формат(ДатаНовогоКомментария, "ДФ=M.d.yyyy") + " - " + СозданноеПисьмо.Текст;
		НовыйКомментарийИнвойса.Записать();
		ЗаписьНабора = НЗ.Добавить();
		ЗаписьНабора.Период = ДатаНовогоКомментария;
		ЗаписьНабора.Invoice = НовыйКомментарийИнвойса.Invoice;
		ЗаписьНабора.Problem = НовыйКомментарийИнвойса.Ссылка;
		ОтменитьЗадачуПоНотификации(InvoiceProblem);
	КонецЦикла;
	НЗ.Записать(Ложь);
	
	ЗафиксироватьТранзакцию();
	
КонецПроцедуры

Функция ПолучитьКомментарииИнвойсовПоИдентификаторуПисьма(ИдентификаторПисьма)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	EmailsObjects.Предмет
		|ИЗ
		|	РегистрСведений.EmailsObjects КАК EmailsObjects
		|ГДЕ
		|	EmailsObjects.Email.ИдентификаторСообщения = &ИдентификаторСообщения
		|	И EmailsObjects.Предмет ССЫЛКА Документ.InvoiceProblem";
	
	Запрос.УстановитьПараметр("ИдентификаторСообщения", ИдентификаторПисьма);
	
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Предмет");
	
КонецФункции

Процедура ОтменитьЗадачуПоНотификации(InvoiceProblem)
	
	НЗ = РегистрыСведений.ОчередьУведомлений.СоздатьНаборЗаписей();
	НЗ.Отбор.Проблема.Установить(InvoiceProblem);
	НЗ.Отбор.ВидУведомления.Установить(Справочники.ВидыУведомлений.Dispute);
	НЗ.Записать(Истина);
	
КонецПроцедуры

#КонецЕсли