
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Параметры.Свойство("Recipients", 	Recipients);
	Параметры.Свойство("ReplyTo", 		ReplyTo);
	Параметры.Свойство("Subject", 		Subject);
	Если Параметры.Свойство("Body") Тогда
		ТекстПисьмаФорматированныйДокумент.УстановитьФорматированнуюСтроку(Новый ФорматированнаяСтрока(Параметры.Body));
	КонецЕсли;
	
	Если Параметры.Свойство("ПриложенныеФайлы") Тогда
		
		//Для каждого ВыбранныйФайл Из Параметры.ПриложенныеФайлы Цикл
		//	
		//	НоваяСтрока = Вложения.Добавить();
		//	НоваяСтрока.Расположение = 2;
		//	НоваяСтрока.ИмяФайлаНаКомпьютере = ВыбранныйФайл;
		//	
		//	ИмяФайла   = "";
		//	Расширение = "";
		//	ВзаимодействияКлиентСервер.ПолучитьКаталогИИмяФайла(ВыбранныйФайл, "", ИмяФайла);
		//	НоваяСтрока.ИмяФайла = ИмяФайла;
		//	
		//	Расширение                      = ВзаимодействияКлиентСервер.ПолучитьРасширениеФайла(ИмяФайла);
		//	НоваяСтрока.ИндексКартинки      = ФайловыеФункцииСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
		//	Файл = Новый Файл(НоваяСтрока.ИмяФайлаНаКомпьютере);
		//	Размер = Файл.Размер();
		//	НоваяСтрока.Размер = Размер;
		//	НоваяСтрока.РазмерПредставление = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(Размер); 
		//	
		//КонецЦикла;
		
		Для каждого СтрокаПриложенногоФайла Из Параметры.ПриложенныеФайлы Цикл
			
			НоваяСтрока = ПриложенныеПрограммноФайлы.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, СтрокаПриложенногоФайла);
			
		КонецЦикла;
		
	КонецЕсли;
	
	//{RGS AArsentev 26.01.2017 S-E-0000048
	Если Параметры.Свойство("Адресаты") Тогда
		Адресаты = ПолучитьАдресаКлиентов(Параметры.Адресаты);
		Для каждого Адрес Из Адресаты Цикл
			СтрокаRecipients = Recipients.Добавить();
			СтрокаRecipients.Recipient = Адрес.Представление;
		КонецЦикла;
	КонецЕсли;
	//}RGS AArsentev 26.01.2017 S-E-0000048
	
КонецПроцедуры

&НаКлиенте
Процедура Send(Команда)
	
	ИндексСтроки = 0;
	
	Пока ИндексСтроки < Recipients.Количество() Цикл
		
		СтрокаТЧ = Recipients[ИндексСтроки];
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Recipient) Тогда
			Recipients.Удалить(ИндексСтроки);
		Иначе
			ИндексСтроки = ИндексСтроки + 1;
		КонецЕсли;
		
	КонецЦикла;

	ИндексСтроки = 0;
	
	Пока ИндексСтроки < Copies.Количество() Цикл
		
		СтрокаТЧ = Copies[ИндексСтроки];
		Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Recipient) Тогда
			Copies.Удалить(ИндексСтроки);
		Иначе
			ИндексСтроки = ИндексСтроки + 1;
		КонецЕсли;
		
	КонецЦикла;
	
	ReplyTo = СокрЛП(ReplyTo);
	Subject = СокрЛП(Subject);
	
	ПодготовитьПисьмоНаСервере();
	
	Отказ = Ложь;
	Если Recipients.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Поле ""Recipients"" не заполнено",
		, "Recipients", , Отказ);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ReplyTo) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Поле ""Reply to"" не заполнено",
		, "ReplyTo", , Отказ);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Subject) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Поле ""Subject"" не заполнено",
		, "Subject", , Отказ);
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Body) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Поле ""Body"" не заполнено",
		, "Body", , Отказ);
	КонецЕсли; 
	
	Для Каждого СтрокаТаблицыВложений Из Вложения Цикл
		Если СтрокаТаблицыВложений.Расположение = 2 Тогда
			Попытка
				Данные = Новый ДвоичныеДанные(СтрокаТаблицыВложений.ИмяФайлаНаКомпьютере);
				СтрокаТаблицыВложений.ИмяФайлаНаКомпьютере = ПоместитьВоВременноеХранилище(Данные, "");
				СтрокаТаблицыВложений.Расположение = 4;
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()),, "Вложения",, Отказ);
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	
	Если НЕ Отказ Тогда
		
		СтруктураВозврата = Новый Структура;
		СтруктураВозврата.Вставить("Recipients", 	Recipients);
		СтруктураВозврата.Вставить("Copies", 		Copies);
		СтруктураВозврата.Вставить("ReplyTo", 		ReplyTo);
		СтруктураВозврата.Вставить("Subject", 		Subject);
		СтруктураВозврата.Вставить("Текст", 		Body);
		СтруктураВозврата.Вставить("Attachments", 	Вложения);
		СтруктураВозврата.Вставить("ТаблицаСоответствийИменВложенийИдентификаторам", 	ТаблицаСоответствийИменВложенийИдентификаторам);
		СтруктураВозврата.Вставить("ТипТекста", 	ПредопределенноеЗначение("Перечисление.ТипыТекстовЭлектронныхПисем.HTML"));
		
		//ОповеститьОВыборе(СтруктураВозврата);
		Закрыть(СтруктураВозврата);
		
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПодготовитьПисьмоНаСервере()
	
	Body = "";
	ДокументHTMLТекущегоПисьмаПодготовлен = Ложь;
	
	ТаблицаСоответствийИменВложенийИдентификаторам.Очистить();
	
	СтруктураВложений = Новый Структура;
	ТекстПисьмаФорматированныйДокумент.ПолучитьHTML(Body, СтруктураВложений);
	
	Для каждого Вложение Из СтруктураВложений Цикл
		
		НоваяСтрока = ТаблицаСоответствийИменВложенийИдентификаторам.Добавить();
		НоваяСтрока.ИмяФайла = Вложение.Ключ;
		НоваяСтрока.ИдентификаторФайлаДляHTML = Новый УникальныйИдентификатор;
		НоваяСтрока.Картинка = Вложение.Значение;
		
	КонецЦикла;
	
	Если ТаблицаСоответствийИменВложенийИдентификаторам.Количество() > 0 Тогда
		
		ДокументHTML = Взаимодействия.ПолучитьОбъектДокументHTMLИзТекстаHTML(Body);
		Взаимодействия.ЗаменитьИменаКартинокНаИдентификаторыПочтовыхВложенийВHTML(
		ДокументHTML, ТаблицаСоответствийИменВложенийИдентификаторам.Выгрузить());
		ДокументHTMLТекущегоПисьмаПодготовлен = Истина;
		
	КонецЕсли;
	
	Если ДокументHTMLТекущегоПисьмаПодготовлен Тогда
		
		Body = Взаимодействия.ПолучитьТекстHTMLИзОбъектаДокументHTML(ДокументHTML);
		//ТекущийОбъект.Текст     = Взаимодействия.ПолучитьОбычныйТекстИзHTML(ТекущийОбъект.ТекстHTML);
		
	КонецЕсли;
	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьВложениеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	//Если Объект.СтатусПисьма <> ПредопределенноеЗначение("Перечисление.СтатусыИсходящегоЭлектронногоПисьма.Черновик") Тогда
	//	ПараметрыПеретаскивания.Действие = ДействиеПеретаскивания.Отмена;
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	МассивФайлов = Новый Массив;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		
		МассивФайлов.Добавить(ПараметрыПеретаскивания.Значение);
		
	ИначеЕсли ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Массив") Тогда
		
		Если ПараметрыПеретаскивания.Значение.Количество() >= 1
			И ТипЗнч(ПараметрыПеретаскивания.Значение[0]) = Тип("Файл") Тогда
			
			Для Каждого ФайлПринятый Из ПараметрыПеретаскивания.Значение Цикл
				Если ТипЗнч(ФайлПринятый) = Тип("Файл") Тогда
					МассивФайлов.Добавить(ФайлПринятый);
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;
		
	КонецЕсли;
	
	Для Каждого ВыбранныйФайл Из МассивФайлов Цикл
		
		ДополнительныеПараметры = Новый Структура("ВыбранныйФайл", ВыбранныйФайл);
		ОписаниеОповещение = Новый ОписаниеОповещения("ПроверкаЭтоФайлПослеЗавершения", ЭтотОбъект, ДополнительныеПараметры);
		ВыбранныйФайл.НачатьПроверкуЭтоФайл(ОписаниеОповещение);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ОткрытьВложениеВыполнить()
	
	ТекДанные = Элементы.Вложения.ТекущиеДанные;
	Если ТекДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если (ТекДанные.Расположение = 0) ИЛИ (ТекДанные.Расположение = 1) Тогда
		
		ОткрытьВложение(ТекДанные.Ссылка, УникальныйИдентификатор);
		
	ИначеЕсли текДанные.Расположение = 2 Тогда
		
		ПутьКФайлу = ТекДанные.ИмяФайлаНаКомпьютере;
		#Если Не ВебКлиент Тогда
			ЗапуститьПриложение("""" + ПутьКФайлу + """");
		#Иначе
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Истина);
		#КонецЕсли
		
	ИначеЕсли ТекДанные.Расположение = 4 Тогда
		
		ПутьКФайлу = ТекДанные.ИмяФайлаНаКомпьютере;
		#Если Не ВебКлиент Тогда
			Если ЭтоАдресВременногоХранилища(ТекДанные.ИмяФайлаНаКомпьютере) Тогда
				ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
				СоздатьКаталог(ИмяВременнойПапки);
				ПутьКФайлу = ИмяВременнойПапки + "\" + ТекДанные.ИмяФайла;
				ДвоичныеДанные = ПолучитьИзВременногоХранилища(ТекДанные.ИмяФайлаНаКомпьютере);
				ДвоичныеДанные.Записать(ПутьКФайлу);
			КонецЕсли;
			ЗапуститьПриложение("""" + ПутьКФайлу + """");
		#Иначе
			ПолучитьФайл(ПутьКФайлу, ТекДанные.ИмяФайла, Истина);
		#КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

// Открывает вложенный файл электронного письма.
//
// Параметры:
//  Ссылка  - СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы,
//            СправочникСсылка.ЭлектронноеПисьмоВходящееПрисоединенныеФайлы - ссылка на файл, который необходимо
//                                                                            открыть.
//
&НаКлиенте
Процедура ОткрытьВложение(Ссылка, УникальныйИдентификаторФормы) Экспорт
	
	ПрисоединенныеФайлыКлиент.ОткрытьФайл(
	ПрисоединенныеФайлыКлиент.ПолучитьДанныеФайла(Ссылка, УникальныйИдентификаторФормы));
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДобавитьВложениеВыполнить();
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьВложениеВыполнить()
	
	#Если Не ВебКлиент Тогда
		
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.МножественныйВыбор = Истина;
		ОписаниеОповещение = Новый ОписаниеОповещения("ДиалогВыбораФайловПослеВыбора", ЭтотОбъект);
		Диалог.Показать(ОписаниеОповещение);
		
	#Иначе
		
		Адрес = "";
		ВыбранныйФайл = "";
		ОбработчикОповещенияОЗакрытии = Новый ОписаниеОповещения("ПомещениеФайлаПриОкончании", ЭтотОбъект);
		НачатьПомещениеФайла(ОбработчикОповещенияОЗакрытии, Адрес, ВыбранныйФайл, Истина, УникальныйИдентификатор);
		
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДиалогВыбораФайловПослеВыбора(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого ВыбранныйФайл Из ВыбранныеФайлы Цикл
		НоваяСтрока = Вложения.Добавить();
		НоваяСтрока.Расположение = 2;
		НоваяСтрока.ИмяФайлаНаКомпьютере = ВыбранныйФайл;
		
		ИмяФайла   = "";
		Расширение = "";
		ВзаимодействияКлиентСервер.ПолучитьКаталогИИмяФайла(ВыбранныйФайл, "", ИмяФайла);
		НоваяСтрока.ИмяФайла = ИмяФайла;
		
		Расширение                      = ВзаимодействияКлиентСервер.ПолучитьРасширениеФайла(ИмяФайла);
		НоваяСтрока.ИндексКартинки      = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
		ДополнительныеПараметры = Новый Структура("СтрокаТаблицыВложений", НоваяСтрока);
		ОписаниеОповещение = Новый ОписаниеОповещения("НовыйФайлПослеИнициализации", ЭтотОбъект, ДополнительныеПараметры);
		Файл = Новый Файл();
		Файл.НачатьИнициализацию(ОписаниеОповещение, ВыбранныйФайл);
	КонецЦикла;
	
	Если ВыбранныеФайлы.Количество() > 0 Тогда
		Элементы.Вложения.ТекущаяСтрока = НоваяСтрока.ПолучитьИдентификатор();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыйФайлПослеИнициализации(Файл, ДополнительныеПараметры) Экспорт
	
	ОписаниеОповещение = Новый ОписаниеОповещения("ПолучениеРазмераПослеОкончания", ЭтотОбъект, ДополнительныеПараметры);
	Файл.НачатьПолучениеРазмера(ОписаниеОповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеРазмераПослеОкончания(Размер, ДополнительныеПараметры) Экспорт
	
	СтрокаТаблицыВложений  = ДополнительныеПараметры.СтрокаТаблицыВложений;
	СтрокаТаблицыВложений.Размер = Размер;
	СтрокаТаблицыВложений.РазмерПредставление = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(Размер); 
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверкаЭтоФайлПослеЗавершения(ЭтоФайл, ДополнительныеПараметры) Экспорт
	
	Если НЕ ЭтоФайл Тогда
		Возврат;
	КонецЕсли;
	
	ПолноеИмя = ДополнительныеПараметры.ВыбранныйФайл.ПолноеИмя;
	
	НоваяСтрока = Вложения.Добавить();
	НоваяСтрока.Расположение = 2;
	НоваяСтрока.ИмяФайлаНаКомпьютере = ПолноеИмя;
	
	ИмяФайла   = "";
	Расширение = "";
	ВзаимодействияКлиентСервер.ПолучитьКаталогИИмяФайла(ПолноеИмя, "", ИмяФайла);
	НоваяСтрока.ИмяФайла = ИмяФайла;
	
	Расширение                      = ВзаимодействияКлиентСервер.ПолучитьРасширениеФайла(ИмяФайла);
	НоваяСтрока.ИндексКартинки      = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
	ДополнительныеПараметры = Новый Структура("СтрокаТаблицыВложений", НоваяСтрока);
	ОписаниеОповещение = Новый ОписаниеОповещения("НовыйФайлПослеИнициализации", ЭтотОбъект, ДополнительныеПараметры);
	Файл = Новый Файл();
	Файл.НачатьИнициализацию(ОписаниеОповещение, ПолноеИмя);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ПриложенныеПрограммноФайлы.Количество() > 0 Тогда
		
		Для каждого СтрокаВыбранногоФайла Из ПриложенныеПрограммноФайлы Цикл
			
			ДанныеФайла = ПолучитьИзВременногоХранилища(СтрокаВыбранногоФайла.ДанныеФайла);
			
			Если ДанныеФайла = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ВыбранныйФайл = КаталогВременныхФайлов() + "\" + СтрокаВыбранногоФайла.ИмяФайла + "." + СтрокаВыбранногоФайла.РасширениеФайла;
			ДанныеФайла.Записать(ВыбранныйФайл);
			
			НоваяСтрока = Вложения.Добавить();
			НоваяСтрока.Расположение = 2;
			НоваяСтрока.ИмяФайлаНаКомпьютере = ВыбранныйФайл;
			
			ИмяФайла   = "";
			Расширение = "";
			ВзаимодействияКлиентСервер.ПолучитьКаталогИИмяФайла(ВыбранныйФайл, "", ИмяФайла);
			НоваяСтрока.ИмяФайла = ИмяФайла;
			
			Расширение                      = ВзаимодействияКлиентСервер.РасширениеФайла(ИмяФайла);
			НоваяСтрока.ИндексКартинки      = РаботаСФайламиСлужебныйКлиентСервер.ПолучитьИндексПиктограммыФайла(Расширение);
			Файл = Новый Файл(НоваяСтрока.ИмяФайлаНаКомпьютере);
			Размер = Файл.Размер();
			НоваяСтрока.Размер = Размер;
			НоваяСтрока.РазмерПредставление = ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(Размер); 
			
			УдалитьИзВременногоХранилища(СтрокаВыбранногоФайла.ДанныеФайла);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьАдресаКлиентов(МассивКлиентов)
	
	МассивКлиентов =  ОбщегоНазначенияКлиентСервер.СвернутьМассив(МассивКлиентов);
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	КонтрагентыКонтактнаяИнформация.Представление,
	|	КонтрагентыКонтактнаяИнформация.Ссылка КАК Клиент
	|ИЗ
	|	Справочник.Контрагенты.КонтактнаяИнформация КАК КонтрагентыКонтактнаяИнформация
	|ГДЕ
	|	КонтрагентыКонтактнаяИнформация.Тип = &Тип
	|	И КонтрагентыКонтактнаяИнформация.Ссылка В(&Инвойсы)";
	Запрос.УстановитьПараметр("Тип", Перечисления.ТипыКонтактнойИнформации.АдресЭлектроннойПочты);
	Запрос.УстановитьПараметр("Инвойсы", МассивКлиентов);
	Результат = Запрос.Выполнить().Выгрузить();
	Отбор = Новый Структура;
	Для Каждого Строка из МассивКлиентов Цикл
		Отбор.Вставить("Клиент", Строка);
		Строки = Результат.НайтиСтроки(Отбор);
		Если Строки.Количество() = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Not specified e-mail client - " + Строка);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
	
КонецФункции

