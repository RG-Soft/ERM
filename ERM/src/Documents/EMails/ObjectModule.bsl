#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

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
			//{RGS AArsentev 26.01.2017 S-E-0000048
			//ListOfRecipients = ListOfRecipients + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.Recipient, "Mail") + ", ";
			// { RGS TAlmazova 12.04.2018 19:04:23 - 
			//Если СтрокаТЧ.Recipient = Тип("СправочникСсылка.LDAPUsers") Тогда
			Если ТипЗнч(СтрокаТЧ.Recipient) = Тип("СправочникСсылка.LDAPUsers") Тогда
			// } RGS TAlmazova 12.04.2018 19:04:24 - 
				ListOfRecipients = ListOfRecipients + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТЧ.Recipient, "Mail") + ", ";
			Иначе
				ListOfRecipients = ListOfRecipients + СтрокаТЧ.Recipient + ", ";
			КонецЕсли;
			//}RGS AArsentev 26.01.2017 S-E-0000048
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
	//{RGS AArsentev S-E-0000019 17.01.2017
	//СистемнаяУчетнаяЗапись = РаботаСПочтовымиСообщениями.СистемнаяУчетнаяЗапись();
	ТекПользователь = Пользователи.ТекущийПользователь();
	ПользовательLDAP = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ТекПользователь, "ПользовательLDAP");
	Если ЗначениеЗаполнено(ПользовательLDAP) Тогда
		ПочтаПользователя = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПользовательLDAP, "Mail");
		Если ЗначениеЗаполнено(ПочтаПользователя) Тогда
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	УчетныеЗаписиЭлектроннойПочты.Ссылка
			|ИЗ
			|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
			|ГДЕ
			|	УчетныеЗаписиЭлектроннойПочты.АдресЭлектроннойПочты = &АдресЭлектроннойПочты";
			Запрос.УстановитьПараметр("АдресЭлектроннойПочты", ПочтаПользователя);
			Результат = Запрос.Выполнить();
			Если НЕ Результат.Пустой() Тогда
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				УчетнаяЗаписьПочтыПользователя = Выборка.Ссылка;
			Иначе
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Not found the account email address - " + ПочтаПользователя, ЭтотОбъект, , , Отказ);
			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Not specified e-mail address for the LDAP user - " + ПользовательLDAP, ЭтотОбъект, , , Отказ);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Not defined the LDAP account to the current user - " + ТекПользователь, ЭтотОбъект, , , Отказ);
	КонецЕсли;
	//}RGS AArsentev S-E-0000019 17.01.2017
	
	ПараметрыПисьма = Новый Структура;

	МассивСтруктурКому = Новый Массив;
	Для Каждого СтрокаТЧ Из Recipients Цикл
		//{RGS AArsentev 26.01.2017 S-E-0000048
		Если СтрокаТЧ <> Тип("СправочникСсылка.LDAPUsers") Тогда
			МассивСтруктурКому.Добавить(Новый Структура("Адрес, Представление", СтрокаТЧ.Recipient, , СтрокаТЧ.Recipient));
		Иначе
		//}RGS AArsentev 26.01.2017 S-E-0000048
			СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СтрокаТЧ.Recipient, "Mail, DisplayName");
			МассивСтруктурКому.Добавить(Новый Структура("Адрес, Представление", СтруктураРеквизитов.Mail, , СтруктураРеквизитов.DisplayName));
		КонецЕсли;
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

	// { RGS AGorlenko 20.01.2017 18:01:31 - поддержка картинок
	//МассивПрисоединенныхФайлов = Новый Массив();
	//ДвоичныеДанныеФайлов.ПолучитьПрикрепленныеФайлыКОбъекту(Ссылка, МассивПрисоединенныхФайлов);
	//Если МассивПрисоединенныхФайлов.Количество() > 0 Тогда
	//	Вложения = Новый Соответствие;
	//	Для каждого ТекПрисоединенныйФайл Из МассивПрисоединенныхФайлов Цикл
	//		СтруктураДанныхФайла = ДвоичныеДанныеФайлов.ПолучитьДанныеФайла(ТекПрисоединенныйФайл);
	//		Вложения.Вставить(СтруктураДанныхФайла.ИмяФайла, СтруктураДанныхФайла.СсылкаНаДвоичныеДанныеФайла);
	//	КонецЦикла;
	//	ПараметрыПисьма.Вставить("Вложения", Вложения);
	//КонецЕсли;
	
	СоотвВложения = Новый Соответствие;

	ИмяОбъектаМетаданных = "EmailsПрисоединенныеФайлы";
	ВладелецФайлов       = Ссылка;

	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Файлы.Наименование КАК ПолноеНаименование,
	|	Файлы.Расширение КАК Расширение,
	|	Файлы.Ссылка КАК Ссылка,
	//|	Файлы.ЭлектронныеПодписи.(
	//|		НомерСтроки,
	//|		Подпись
	//|	),
	|	Файлы.ИДФайлаЭлектронногоПисьма
	|ИЗ
	|	Справочник." + ИмяОбъектаМетаданных + " КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", ВладелецФайлов);
	Выборка = Запрос.Выполнить().Выбрать(); 

	Пока Выборка.Следующий() Цикл
		ИмяФайла = Выборка.ПолноеНаименование + ?(Выборка.Расширение = "", "", "." + Выборка.Расширение);
		Если ПустаяСтрока(Выборка.ИДФайлаЭлектронногоПисьма) Тогда
			СоотвВложения.Вставить(ИмяФайла, ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Выборка.Ссылка));
		Иначе
			СтруктураДанныеВложения = Новый Структура;
			СтруктураДанныеВложения.Вставить("ДвоичныеДанные", ПрисоединенныеФайлы.ПолучитьДвоичныеДанныеФайла(Выборка.Ссылка));
			СтруктураДанныеВложения.Вставить("Идентификатор", Выборка.ИДФайлаЭлектронногоПисьма);
			СоотвВложения.Вставить(ИмяФайла, СтруктураДанныеВложения);
		КонецЕсли;
		//Для каждого ЭП Из Выборка.ЭлектронныеПодписи.Выгрузить() Цикл
		//
		//	СоотвВложения.Вставить(Выборка.ПолноеНаименование + "-DS("+ ЭП.НомерСтроки + ")." 
		//	                       + РасширениеДляФайловПодписи,ЭП.Подпись.Получить());
		//
		//КонецЦикла;
	КонецЦикла;
	ПараметрыПисьма.Вставить("Вложения", СоотвВложения);
	ПараметрыПисьма.Вставить("ОбрабатыватьТексты", Ложь);
	// } RGS AGorlenko 20.01.2017 18:01:38 - поддержка картинок
	
	// Попробуем отправить сообщение
	ПисьмоОтправлено = Ложь;
	КоличествоПопыток = 0;
	Пока НЕ ПисьмоОтправлено И КоличествоПопыток < 3 Цикл
		
		КоличествоПопыток = КоличествоПопыток + 1;
		Попытка
			//{RGS AArsentev S-E-0000019 17.01.2017
			//РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(СистемнаяУчетнаяЗапись, ПараметрыПисьма);
			РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗаписьПочтыПользователя, ПараметрыПисьма);
			//}RGS AArsentev S-E-0000019 17.01.2017
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

#КонецЕсли

