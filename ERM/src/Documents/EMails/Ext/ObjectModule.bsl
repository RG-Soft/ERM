﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА ЗАПОЛНЕНИЯ

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("Структура")
		И ДанныеЗаполнения.Свойство("Recipients") Тогда
		
		Для Каждого СтрокаRecipient Из ДанныеЗаполнения.Recipients Цикл
			НоваяСтрокаТЧ = Recipients.Добавить();
			НоваяСтрокаТЧ.Recipient = СтрокаRecipient.Recipient;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПЕРЕД ЗАПИСЬЮ

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДозаполнитьРеквизитыБезДополнительныхДанных(РежимЗаписи);
	
	ПроверитьВозможностьИзменения(Отказ, РежимЗаписи);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьЗаполнениеРеквизитов(Отказ, РежимЗаписи);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////

Процедура ДозаполнитьРеквизитыБезДополнительныхДанных(РежимЗаписи)
	
	Если РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
		Дата = ТекущаяДата();
	КонецЕсли;
	
	Subject = СокрЛП(Subject);
	Body = СокрЛП(Body);
	ReplyTo = СокрЛП(ReplyTo);
	
	Если ЭтоНовый() Тогда
		CreatedBy = Пользователи.ТекущийПользователь();
		CreationDate = ТекущаяДата();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ModifiedBy) Тогда
		ModifiedBy = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ModificationDate) Тогда
		ModificationDate = ТекущаяДата();
	КонецЕсли;
	
	ИндексСтроки = 0;
	ListOfRecipients = "";
	Пока ИндексСтроки < Recipients.Количество() Цикл
		
		СтрокаТЧ = Recipients[ИндексСтроки];
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Recipient) Тогда
			Recipients.Удалить(ИндексСтроки);
		Иначе
			ListOfRecipients = ListOfRecipients + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.Recipient, "Mail") + ", ";
			ИндексСтроки = ИндексСтроки+1;
		КонецЕсли;
		
	КонецЦикла;
	Recipients.Свернуть("Recipient", "");
	Если Не ПустаяСтрока(ListOfRecipients) Тогда
		ListOfRecipients = Лев(ListOfRecipients, СтрДлина(ListOfRecipients) - 2);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////

Процедура ПроверитьВозможностьИзменения(Отказ, РежимЗаписи)
	
	// Запретим отмену проведения, так как проведение - это отправка, а отменить отправку нельзя
	Если РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"You can not return message that was already sent!",
			ЭтотОбъект,,, Отказ);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////

Процедура ПроверитьЗаполнениеРеквизитов(Отказ, РежимЗаписи)
	
	Если РежимЗаписи <> РежимЗаписиДокумента.Проведение Тогда
		Возврат;
	КонецЕсли;
	
	//Если НЕ ЗначениеЗаполнено(Object) Тогда
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
	//		"Object is empty!",
	//		ЭтотОбъект, "Object", , Отказ);
	//КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Subject) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Subject is empty!",
			ЭтотОбъект, "Subject", , Отказ);
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Body) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Body is empty!",
			ЭтотОбъект, "Body", , Отказ);
	КонецЕсли;
	
	Если Recipients.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Recipients are empty!",
			ЭтотОбъект, "Recipients", , Отказ);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТКА ПРОВЕДЕНИЯ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Проведение - это отправка сообщения
	СистемнаяУчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
		
	ПараметрыПисьма = Новый Структура;

	МассивСтруктурКому = Новый Массив;
	Для Каждого СтрокаТЧ Из Recipients Цикл
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаТЧ.Recipient, "Mail, DisplayName");
		МассивСтруктурКому.Добавить(Новый Структура("Адрес, Представление", СтруктураРеквизитов.Mail, , СтруктураРеквизитов.DisplayName));
	КонецЦикла; 
	ПараметрыПисьма.Вставить("Кому", МассивСтруктурКому);

	ПараметрыПисьма.Вставить("Тема", 		Subject);
	ПараметрыПисьма.Вставить("Тело", 		Body);
	ПараметрыПисьма.Вставить("АдресОтвета", ReplyTo);
	ПараметрыПисьма.Вставить("Копии", 		Copy);
	
	Если НЕ ЗначениеЗаполнено(ТипТекста) Тогда
		ПараметрыПисьма.Вставить("ТипТекста", 	Перечисления.ТипыТекстовЭлектронныхПисем.ПростойТекст);
	Иначе
		ПараметрыПисьма.Вставить("ТипТекста", 	ТипТекста);
	КонецЕсли;
	
	// вложения
	МассивПрисоединенныхФайлов = Новый Массив();
	ПрисоединенныеФайлы.ПолучитьПрикрепленныеФайлыКОбъекту(Ссылка, МассивПрисоединенныхФайлов);
	Если МассивПрисоединенныхФайлов.Количество() > 0 Тогда
		Вложения = Новый Соответствие;
		Для каждого ТекПрисоединенныйФайл Из МассивПрисоединенныхФайлов Цикл
			СтруктураДанныхФайла = ПрисоединенныеФайлы.ПолучитьДанныеФайла(ТекПрисоединенныйФайл);
			Вложения.Вставить(СтруктураДанныхФайла.ИмяФайла, СтруктураДанныхФайла.СсылкаНаДвоичныеДанныеФайла);
		КонецЦикла;
		ПараметрыПисьма.Вставить("Вложения", Вложения);
	КонецЕсли;

	// Попробуем отправить сообщение
	ПисьмоОтправлено = Ложь;
	КоличествоПопыток = 0;
	Пока НЕ ПисьмоОтправлено И КоличествоПопыток < 3 Цикл
		
		КоличествоПопыток = КоличествоПопыток + 1;
		Попытка
			РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(СистемнаяУчетнаяЗапись, ПараметрыПисьма);
			ПисьмоОтправлено = Истина;
		Исключение
			ЗаписьЖурналаРегистрации(
				"Ошибка отправки E-mail",
				УровеньЖурналаРегистрации.Ошибка,
				Метаданные.Документы.EMails,
				Object,
				ОписаниеОшибки());
		КонецПопытки;
			
	КонецЦикла;

	Если НЕ ПисьмоОтправлено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Failed to send e-mail!
			|" + ОписаниеОшибки(),
			ЭтотОбъект, , , Отказ);
	КонецЕсли;
	
КонецПроцедуры




