#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов.
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	ШаблоныЗаданий.Добавить("ПолучениеИОтправкаЭлектронныхПисем");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТекстПисьма(Письмо, Сообщение) Экспорт
	
	ТекстHTML = "";
	ТекстПростой = "";
	ТекстРазмеченный = "";

	Для Каждого ТекстПочтовогоСообщения Из Сообщение.Тексты Цикл
		Если ТекстПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
			
			ТекстHTML = ТекстHTML + ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ТекстПочтовогоСообщения.Текст);
			
		ИначеЕсли ТекстПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст Тогда
			
			ТекстПростой = ТекстПростой + ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ТекстПочтовогоСообщения.Текст);
			
		ИначеЕсли ТекстПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.РазмеченныйТекст Тогда
			ТекстРазмеченный = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ТекстПочтовогоСообщения.Текст);
			
		КонецЕсли;
	КонецЦикла;
	
	Если ТекстHTML <> "" Тогда
		Письмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML;
		Письмо.ТекстHTML = ТекстHTML;
		Письмо.Текст = ?(ТекстПростой <> "", ТекстПростой, ПолучитьПростойТекстИзHTML(ТекстHTML));
		
	ИначеЕсли ТекстРазмеченный <> "" Тогда
		Письмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.РазмеченныйТекст;
		Письмо.Текст = ТекстРазмеченный;
		
	Иначе
		Письмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.ПростойТекст;
		Письмо.Текст = ТекстПростой;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПростойТекстИзHTML(ТекстHTML)
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	ДокументHTML = Построитель.Прочитать(ЧтениеHTML);
	
	Возврат ДокументHTML.Тело.ТекстовоеСодержимое;
	
КонецФункции

#КонецОбласти
