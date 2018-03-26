﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АдресВХранилище = "";
	ВыбранноеИмяФайла = "";
	
	ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ИмяФайлаНачалоВыбораЗавершение", ЭтотОбъект);
	
	НачатьПомещениеФайла(ОписаниеОповещенияОЗавершении, АдресВХранилище,,, УникальныйИдентификатор);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбораЗавершение(Результат, АдресВХранилище, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		Файл = Новый Файл(ВыбранноеИмяФайла);
		
		Объект.ИмяФайла = Файл.Имя;
		АдресФайлаВХранилище = АдресВХранилище;
		Модифицированность = Истина;
		
		ЗаполнитьСписокЛистовЭкселя(Истина);
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Объект.ИмяФайла = "" Тогда
		Сообщить("Файл не загружен!");
	Иначе
		СсылкаНаФайл = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ИсточникДанных");
		ПолучитьФайл(СсылкаНаФайл, Объект.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоАдресВременногоХранилища(АдресФайлаВХранилище) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
		ТекущийОбъект.ИсточникДанных = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	//ПараметрыФормы = Новый Структура();
	//ПараметрыФормы.Вставить("ДокументЗагрузки", Объект.Ссылка);
	//ПараметрыФормы.Вставить("ИмяФайла", Объект.ИмяФайла);
	//ОткрытьФорму("Обработка.ЗагрузкаCRMAccountsExtract.Форма.Форма", ПараметрыФормы, ЭтаФорма,,,, Новый ОписаниеОповещения("ЗагрузкаCRMAccountsExtractЗавершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	// проверка формата файла
	РезультатПроверки = ПроверитьФайлНаСервере();
	
	Объект.НовыеParentClients.Очистить();
	Объект.НовыеSalesКлиенты.Очистить();
	Объект.НовыеBillingКлиенты.Очистить();
	Объект.ИзмененныеCRMID.Очистить();
	Объект.ИзмененныеBillingID.Очистить();
	Объект.ИзмененныеParentClients.Очистить();
	Объект.ИзмененныеРеквизиты.Очистить();
	Объект.КлиентыДляДективации.Очистить();
	
	Результат = ПрочитатьФайлНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПроверитьФайлНаСервере()
	
	//ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
	//ФайлЭксель = Объект.ИсточникДанных.Получить();
	//ФайлЭксель.Записать(ПутьКФайлу);
	//
	//Connection = Новый COMОбъект("ADODB.Connection");
	//СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 12.0 Xml;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
	//
	//Попытка
	//	Connection.Open(СтрокаПодключения);
	//Исключение
	//	Попытка
	//		СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 8.0;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
	//		Connection.Open(СтрокаПодключения);
	//	Исключение
	//		ТекстОшибки = ОписаниеОшибки();
	//		ДанныеДляЗаполнения.Вставить("ОшибкаЗаполнения", ТекстОшибки);
	//		ПоместитьВоВременноеХранилище(ДанныеДляЗаполнения, АдресХранилища);
	//		Возврат Ложь;
	//	КонецПопытки;
	//КонецПопытки;
	//
	//КоличествоСтрокДляВыборки = ?(ИменаКолонокВПервойСтроке, 1, ПерваяСтрокаДанных - 1);
	//
	//rs = Новый COMObject("ADODB.RecordSet");
	//rs.ActiveConnection = Connection;
	//sqlString = "select top " + КоличествоСтрокДляВыборки + " * from [" + Объект.ЛистФайла + "]";
	//rs.Open(sqlString);
	//
	//rs.Close();
	//Connection.Close();
	//УдалитьФайлы(ПутьКФайлу);
	
	Возврат Истина;
	
КонецФункции

&НаСервере
Функция ПрочитатьФайлНаСервере()
	
	ТаблицаДанных.Очистить();
	
	//////////////
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата, ИсточникДанных, ЛистФайла, ИменаКолонокВПервойСтроке, ПерваяСтрокаДанных, ПоследняяСтрокаДанных");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтотОбъект);
	СтруктураПараметров.Вставить("СтруктураКолонок", РеквизитФормыВЗначение("СтруктураКолонок"));
	СтруктураПараметров.Вставить("ТаблицаДанных", РеквизитФормыВЗначение("ТаблицаДанных"));
	СтруктураПараметров.Вставить("ИсточникДанных", РеквизитФормыВЗначение("Объект").ИсточникДанных);
	СтруктураПараметров.Вставить("ЛистФайла", Объект.ЛистФайла);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ИмяРегистра", "CRMAccountsExtractSourceData");
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхCRMAccountsExtract.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Загрузка данных CRM Accounts extract'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхCRMAccountsExtract.ЗагрузитьДанныеИзФайла", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ОшибкаЗаполнения") Тогда
		//ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураДанных.ОшибкаЗаполнения,,"Объект.ЛистФайла");
		//Возврат;
		ВызватьИсключение СтруктураДанных.ОшибкаЗаполнения;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаНовыеParentClients") Тогда
		Объект.НовыеParentClients.Загрузить(СтруктураДанных.ТаблицаНовыеParentClients);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаНовыеSalesКлиенты") Тогда
		Объект.НовыеSalesКлиенты.Загрузить(СтруктураДанных.ТаблицаНовыеSalesКлиенты);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаНовыеBillingКлиенты") Тогда
		Объект.НовыеBillingКлиенты.Загрузить(СтруктураДанных.ТаблицаНовыеBillingКлиенты);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаИзмененныеCRMID") Тогда
		Объект.ИзмененныеCRMID.Загрузить(СтруктураДанных.ТаблицаИзмененныеCRMID);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаИзмененныеBillingID") Тогда
		Объект.ИзмененныеBillingID.Загрузить(СтруктураДанных.ТаблицаИзмененныеBillingID);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаИзмененныеParentClients") Тогда
		Объект.ИзмененныеParentClients.Загрузить(СтруктураДанных.ТаблицаИзмененныеParentClients);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаИзмененныеРеквизиты") Тогда
		Объект.ИзмененныеРеквизиты.Загрузить(СтруктураДанных.ТаблицаИзмененныеРеквизиты);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаКлиентыДляДективации") Тогда
		Объект.КлиентыДляДективации.Загрузить(СтруктураДанных.ТаблицаКлиентыДляДективации);
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьПодготовленныеДанные();
				//УправлениеФормой(ЭтаФорма);
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		КонецЕсли;	
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

//&НаКлиенте
//Процедура ЗагрузкаCRMAccountsExtractЗавершение(Результат, ДополнительныеПараметры) Экспорт
//	
//	Если Результат = Неопределено Тогда
//		АдресТаблицыДанныхВХранилище = "";
//		Возврат;
//	КонецЕсли;
//	
//	АдресТаблицыДанныхВХранилище = Результат;
//	
//	ОбработатьТаблицуДанныхCRMAccountsExtract();
//	
//КонецПроцедуры

//&НаСервере
//Процедура ОбработатьТаблицуДанныхCRMAccountsExtract()
//	
//	ТаблицаДанных = ПолучитьИзВременногоХранилища(АдресТаблицыДанныхВХранилище);
//	ТаблицаДанных.Колонки.Добавить("Период");
//	ТаблицаДанных.ЗаполнитьЗначения(Объект.Дата, "Период");
//	
//	НЗ = РегистрыСведений.CRMAccountsExtractSourceData.СоздатьНаборЗаписей();
//	НЗ.Отбор.Регистратор.Установить(Объект.Ссылка);
//	НЗ.Загрузить(ТаблицаДанных);
//	НЗ.Записать(Истина);
//	
//КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокЛистовЭкселя();
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияFileSettingsНажатие(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИменаКолонокВПервойСтроке", ИменаКолонокВПервойСтроке);
	СтруктураПараметров.Вставить("ПерваяСтрокаДанных", ПерваяСтрокаДанных);
	СтруктураПараметров.Вставить("ПоследняяСтрокаДанных", ПоследняяСтрокаДанных);
	СтруктураПараметров.Вставить("СтруктураКолонок", СтруктураКолонок);
	
	ОткрытьФорму("Документ.ЗагрузкаДанныхCRMAccountsExtract.Форма.ФормаНастройкиПараметровФайла", СтруктураПараметров, ЭтаФорма,,,, Новый ОписаниеОповещения("ДекорацияFileSettingsЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияFileSettingsЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено  Тогда
		Возврат;
	КонецЕсли;
	
	ИменаКолонокВПервойСтроке = Результат.ИменаКолонокВПервойСтроке;
	ПерваяСтрокаДанных = Результат.ПерваяСтрокаДанных;
	ПоследняяСтрокаДанных = Результат.ПоследняяСтрокаДанных;
	//СтруктураКолонок.Загрузить(Результат.СтруктураКолонок.Выгрузить());
	ЗагрузитьСтруктуруКолонок(Результат.СтруктураКолонок);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтруктуруКолонок(Источник)
	
	СтруктураКолонок.Загрузить(Источник.Выгрузить());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокЛистовЭкселя(ЗаполнитьЛист = Ложь)
	
	СписокЛистов = Новый Массив;
	
	Если ЭтоАдресВременногоХранилища(АдресФайлаВХранилище) Тогда
		ФайлЭксель = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
	Иначе
		ОбъектДляСервера = РеквизитФормыВЗначение("Объект");
		ФайлЭксель = ОбъектДляСервера.ИсточникДанных.Получить();
	КонецЕсли;
	
	Если ФайлЭксель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsx");
	ФайлЭксель.Записать(ПутьКФайлу);
	
	Connection = Новый COMОбъект("ADODB.Connection");
	СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 12.0 Xml;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
	
	Попытка
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + СокрЛП(ПутьКФайлу) + ";Extended Properties=""Excel 8.0;HDR=" + ?(ИменаКолонокВПервойСтроке, "Yes", "No") + """";
			Connection.Open(СтрокаПодключения);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецПопытки;
	
	rs = Новый COMObject("ADODB.RecordSet");
	rs.ActiveConnection = Connection;
	rs = Connection.OpenSchema(20);
	
	Пока rs.EOF() = 0 Цикл
		Если Найти(rs.Fields("TABLE_NAME").Value, "_FilterDatabase") = 0 Тогда
			СписокЛистов.Добавить(rs.Fields("TABLE_NAME").Value);
		КонецЕсли;
		rs.MoveNext();
	КонецЦикла;
	
	rs.Close();
	Connection.Close();
	
	Элементы.ЛистФайла.СписокВыбора.ЗагрузитьЗначения(СписокЛистов);
	
	Если СписокЛистов.Количество() > 0 И ЗаполнитьЛист Тогда
		// { RGS PMatkov 25.12.2015 15:50:08 - 
		//ЛистФайла = СписокЛистов[0];
		Объект.ЛистФайла = СписокЛистов[0];
		// } RGS PMatkov 25.12.2015 15:50:09 - 
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруФайлаПоУмолчанию()
	
	ПерваяСтрокаДанных = 2;
	ИменаКолонокВПервойСтроке = Истина;
	ЗаполнитьСтруктуруКолонокПоУмолчанию();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчанию()
	
	СтруктураКолонок.Очистить();
	
	// MI Integration Id
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "MIIntegrationId";
	СтрокаТЗ.ИмяКолонки = "MI Integration Id";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 1;
	
	// SMITH Integration Id
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SMITHIntegrationId";
	СтрокаТЗ.ИмяКолонки = "SMITH Integration Id";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 2;
	
	// Corporate Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CorporateAccount";
	СтрокаТЗ.ИмяКолонки = "Corporate Alias";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 3;
	
	// SAP Integration id
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SAPIntegrationId";
	СтрокаТЗ.ИмяКолонки = "SAP Integration Id";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 8;
	
	// Created
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Created";
	СтрокаТЗ.ИмяКолонки = "Created";
	//СтрокаТЗ.НомерКолонки = 9;
	
	// Created By
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreatedBy";
	СтрокаТЗ.ИмяКолонки = "Created By";
	//СтрокаТЗ.НомерКолонки = 10;
	
	// Account Status
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AccountStatus";
	СтрокаТЗ.ИмяКолонки = "Account Status";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 11;
	
	// Credit Approver
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreditApprover";
	СтрокаТЗ.ИмяКолонки = "Credit Approver";
	//СтрокаТЗ.НомерКолонки = 12;
	
	// Credit Rating
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreditRating";
	СтрокаТЗ.ИмяКолонки = "Credit rating";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 13;
	
	// Area of Operation
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AreaOfOperation";
	СтрокаТЗ.ИмяКолонки = "Area of Operation";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 14;
	
	// Sub Credit Rating
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubCreditRating";
	СтрокаТЗ.ИмяКолонки = "Sub Credit Rating";
	//СтрокаТЗ.НомерКолонки = 15;
	
	// Account Id
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AccountId";
	СтрокаТЗ.ИмяКолонки = "Id";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 16;
	
	// Credit Limit
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreditLimit";
	СтрокаТЗ.ИмяКолонки = "Credit limit";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 17;
	
	// Updated
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Updated";
	СтрокаТЗ.ИмяКолонки = "Updated";
	//СтрокаТЗ.НомерКолонки = 18;
	
	// Updated By
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "UpdatedBy";
	СтрокаТЗ.ИмяКолонки = "Updated By";
	//СтрокаТЗ.НомерКолонки = 19;
	
	// Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "Account";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 20;
	
	// Country
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Country";
	СтрокаТЗ.ИмяКолонки = "Country";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 21;
	
	// Credit Assessment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreditAssessment";
	СтрокаТЗ.ИмяКолонки = "Credit Assessment";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 22;
	
	// LawsonIntegrationId
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LawsonIntegrationId";
	СтрокаТЗ.ИмяКолонки = "Customer Number";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 25;
	
	// BillingFlag
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BillingFlag";
	СтрокаТЗ.ИмяКолонки = "Billing Flag";
	СтрокаТЗ.Обязательная = Истина;
	
	// City
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "City";
	СтрокаТЗ.ИмяКолонки = "City";
	СтрокаТЗ.Обязательная = Истина;
	
	// StreetAddress
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "StreetAddress";
	СтрокаТЗ.ИмяКолонки = "Street Address";
	СтрокаТЗ.Обязательная = Истина;
	
	// Postal Code
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PostalCode";
	СтрокаТЗ.ИмяКолонки = "Postal Code";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesAccountAlias
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesAccountAlias";
	СтрокаТЗ.ИмяКолонки = "Sales Account Alias";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesAccountAlias
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ParentAccount";
	СтрокаТЗ.ИмяКолонки = "Parent Account";
	СтрокаТЗ.Обязательная = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыеSalesКлиентыУстановитьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.НовыеSalesКлиенты Цикл
		ТекСтрока.Применить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыеSalesКлиентыСнятьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.НовыеSalesКлиенты Цикл
		ТекСтрока.Применить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыеBillingКлиентыУстановитьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.НовыеBillingКлиенты Цикл
		ТекСтрока.Применить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыеBillingКлиентыСнятьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.НовыеBillingКлиенты Цикл
		ТекСтрока.Применить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыеParentClientsУстановитьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.НовыеParentClients Цикл
		ТекСтрока.Применить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура НовыеParentClientsСнятьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.НовыеParentClients Цикл
		ТекСтрока.Применить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеCRMIDУстановитьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеCRMID Цикл
		ТекСтрока.Применить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеCRMIDСнятьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеCRMID Цикл
		ТекСтрока.Применить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеBillingIDУстановитьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеBillingID Цикл
		ТекСтрока.Применить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеBillingIDСнятьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеBillingID Цикл
		ТекСтрока.Применить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеParentClientsУстановитьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеParentClients Цикл
		ТекСтрока.Применить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеParentClientsСнятьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеParentClients Цикл
		ТекСтрока.Применить = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Объект.Проведен;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ТолькоПросмотр = Объект.Проведен;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеРеквизитыУстановитьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеРеквизиты Цикл
		ТекСтрока.Применить = Истина;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ИзмененныеРеквизитыСнятьФлажки(Команда)
	
	Для каждого ТекСтрока Из Объект.ИзмененныеРеквизиты Цикл
		ТекСтрока.Применить = Ложь;
	КонецЦикла;
	
КонецПроцедуры
