﻿
&НаКлиенте
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
Функция ПрочитатьФайлНаСервере()
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата, ИсточникДанных, ИменаКолонокВПервойСтроке, ПерваяСтрокаДанных, ПоследняяСтрокаДанных");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтотОбъект);
	СтруктураПараметров.Вставить("СтруктураКолонок", РеквизитФормыВЗначение("СтруктураКолонок"));
	СтруктураПараметров.Вставить("ИсточникДанных", РеквизитФормыВЗначение("Объект").ИсточникДанных);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ЛистФайла", Объект.ЛистФайла);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхOracle.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Oracle loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхOracle.ЗагрузитьДанныеИзФайла", 
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
		ВызватьИсключение СтруктураДанных.ОшибкаЗаполнения;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ТаблицаКоллизий") Тогда
		ТаблицаКоллизий.Загрузить(СтруктураДанных.ТаблицаКоллизий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьПодготовленныеДанные();
				ОбновитьСписокЗагруженныхПроводокDSS(ЭтаФорма);
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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ПустаяСтрока(Объект.ЛистФайла) Тогда
		ЗаполнитьСписокЛистовЭкселя();
	КонецЕсли;
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияFileSettingsНажатие(Элемент)
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИменаКолонокВПервойСтроке", ИменаКолонокВПервойСтроке);
	СтруктураПараметров.Вставить("ПерваяСтрокаДанных", ПерваяСтрокаДанных);
	СтруктураПараметров.Вставить("ПоследняяСтрокаДанных", ПоследняяСтрокаДанных);
	СтруктураПараметров.Вставить("СтруктураКолонок", СтруктураКолонок);
	
	ОткрытьФорму("Документ.ЗагрузкаДанныхLawson.Форма.ФормаНастройкиПараметровФайла", СтруктураПараметров, ЭтаФорма,,,, Новый ОписаниеОповещения("ДекорацияFileSettingsЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ДекорацияFileSettingsЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено  Тогда
		Возврат;
	КонецЕсли;
	
	ИменаКолонокВПервойСтроке = Результат.ИменаКолонокВПервойСтроке;
	ПерваяСтрокаДанных = Результат.ПерваяСтрокаДанных;
	ПоследняяСтрокаДанных = Результат.ПоследняяСтрокаДанных;
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
	
	// SOURCE_SYSTEM
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SOURCE_SYSTEM";
	СтрокаТЗ.ИмяКолонки = "SOURCE_SYSTEM";
	//СтрокаТЗ.НомерКолонки = 1;
	
	// OU
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "OU";
	СтрокаТЗ.ИмяКолонки = "OU";
	
	// Journal
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "GL_SOURCE";
	СтрокаТЗ.ИмяКолонки = "GL_SOURCE";
	
	// GL_DATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "GL_DATE";
	СтрокаТЗ.ИмяКолонки = "GL_DATE";
	
	// CURRENCY_CODE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CURRENCY_CODE";
	СтрокаТЗ.ИмяКолонки = "CURRENCY_CODE";
	
	// EXCHANGE_RATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "EXCHANGE_RATE";
	СтрокаТЗ.ИмяКолонки = "EXCHANGE_RATE";
	
	// GL_ACCOUNT
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "GL_ACCOUNT";
	СтрокаТЗ.ИмяКолонки = "GL_ACCOUNT";
	
	// CUSTOMER_ID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CUSTOMER_ID";
	СтрокаТЗ.ИмяКолонки = "CUSTOMER_ID";
	
	// CUSTOMER_NUMBER
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CUSTOMER_NUMBER";
	СтрокаТЗ.ИмяКолонки = "CUSTOMER_NUMBER";
	
	// CUSTOMER_NAME
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CUSTOMER_NAME";
	СтрокаТЗ.ИмяКолонки = "CUSTOMER_NAME";
	
	// CONTRACT_NAME
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CONTRACT_NAME";
	СтрокаТЗ.ИмяКолонки = "CONTRACT_NAME";
	
	// ENTERED
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ENTERED";
	СтрокаТЗ.ИмяКолонки = "ENTERED";
	
	// ACCOUNTED
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ACCOUNTED";
	СтрокаТЗ.ИмяКолонки = "ACCOUNTED";
	
	// DOC_TYPE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DOC_TYPE";
	СтрокаТЗ.ИмяКолонки = "DOC_TYPE";
	
	// DESCRIPTION
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DESCRIPTION";
	СтрокаТЗ.ИмяКолонки = "DESCRIPTION";
	
	// DOC_NUMBER
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DOC_NUMBER";
	СтрокаТЗ.ИмяКолонки = "DOC_NUMBER";
	
	// DOC_NUMBER_2
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DOC_NUMBER_2";
	СтрокаТЗ.ИмяКолонки = "DOC_NUMBER_2";
	
	// TRANS_TYPE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TRANS_TYPE";
	СтрокаТЗ.ИмяКолонки = "TRANS_TYPE";
	
	// INV_DATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "INV_DATE";
	СтрокаТЗ.ИмяКолонки = "INV_DATE";
	
	// LINE_TYPE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LINE_TYPE";
	СтрокаТЗ.ИмяКолонки = "LINE_TYPE";
	
	// SALESPERSON
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SALESPERSON";
	СтрокаТЗ.ИмяКолонки = "SALESPERSON";
	
	// DUE_DATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DUE_DATE";
	СтрокаТЗ.ИмяКолонки = "DUE_DATE";
	
	// TAX_RATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TAX_RATE";
	СтрокаТЗ.ИмяКолонки = "TAX_RATE";
	
	// ORIGINAL_TRX_NUMBER
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ORIGINAL_TRX_NUMBER";
	СтрокаТЗ.ИмяКолонки = "ORIGINAL_TRX_NUMBER";
	
	// PO_NUMBER
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PO_NUMBER";
	СтрокаТЗ.ИмяКолонки = "PO_NUMBER";
	
	// SO_NUM
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SO_NUM";
	СтрокаТЗ.ИмяКолонки = "SO_NUM";
	
	//// SO_DATE
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "SO_DATE";
	//СтрокаТЗ.ИмяКолонки = "SO_DATE";
	
	// DO_DATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DO_DATE";
	СтрокаТЗ.ИмяКолонки = "DO_DATE";
	
	// SHIP_DATE_ACTUAL
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SHIP_DATE_ACTUAL";
	СтрокаТЗ.ИмяКолонки = "SHIP_DATE_ACTUAL";
	
	// ITEM_NO
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ITEM_NO";
	СтрокаТЗ.ИмяКолонки = "ITEM_NO";
	
	// ITEM_DESC
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ITEM_DESC";
	СтрокаТЗ.ИмяКолонки = "ITEM_DESC";
	
	// PRICE_UNIT
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PRICE_UNIT";
	СтрокаТЗ.ИмяКолонки = "PRICE_UNIT";
	
	// SHIPPED_QUANTITY
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SHIPPED_QUANTITY";
	СтрокаТЗ.ИмяКолонки = "SHIPPED_QUANTITY";
	
	// RECEIPT_AMOUNT
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "RECEIPT_AMOUNT";
	СтрокаТЗ.ИмяКолонки = "RECEIPT_AMOUNT";
	
	// CREATION_DATE
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CREATION_DATE";
	СтрокаТЗ.ИмяКолонки = "CREATION_DATE";
	
	// CREATED_BY
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CREATED_BY";
	СтрокаТЗ.ИмяКолонки = "CREATED_BY";
	
	// BILL_SITE_NAME
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BILL_SITE_NAME";
	СтрокаТЗ.ИмяКолонки = "BILL_SITE_NAME";
	
	// BILL_SITE_ID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BILL_SITE_ID";
	СтрокаТЗ.ИмяКолонки = "BILL_SITE_ID";
	
	// SHIP_SITE_NAME
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SHIP_SITE_NAME";
	СтрокаТЗ.ИмяКолонки = "SHIP_SITE_NAME";
	
	// SHIP_SITE_ID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SHIP_SITE_ID";
	СтрокаТЗ.ИмяКолонки = "SHIP_SITE_ID";
	
	// DOC_ID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DOC_ID";
	СтрокаТЗ.ИмяКолонки = "DOC_ID";
	
	// LINE_ID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LINE_ID";
	СтрокаТЗ.ИмяКолонки = "LINE_ID";
	
	// DOC_TRANS_ID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DOC_TRANS_ID";
	СтрокаТЗ.ИмяКолонки = "DOC_TRANS_ID";
	
	// ID_ORIG
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ID_ORIG";
	СтрокаТЗ.ИмяКолонки = "ID_ORIG";
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Объект.Проведен;
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSS, "ДокументЗагрузки", Объект.Ссылка);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSSНеобрабатываемые, "ДокументЗагрузки", Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ТолькоПросмотр = Объект.Проведен;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуНастроекСинхронизации(Команда)
	
	ВыполнитьПроверкуНастроекСинхронизацииНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуНастроекСинхронизацииНаКлиенте(ЗапретитьВыполнениеВФоне = Ложь)
	
	ТаблицаКоллизий.Очистить();
	
	Результат = ВыполнитьПроверкуНастроекСинхронизацииНаСервере(ЗапретитьВыполнениеВФоне);
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПроверкуНастроекСинхронизацииНаСервере(ЗапретитьВыполнениеВФоне = Ложь)
	
	СтруктураПараметров = Новый Структура("Ссылка");
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ТипВнешнейСистемы", Перечисления.ТипыСоответствий.Lawson);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() ИЛИ ЗапретитьВыполнениеВФоне Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхLawson.ВыполнитьПроверкуНастроекСинхронизации(СтруктураПараметров, АдресХранилища);
		
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Проверка настроек синхронизации Revenue'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхLawson.ВыполнитьПроверкуНастроекСинхронизации", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьПоДаннымФайла(Команда)
	
	ВыполнитьПроверкуНастроекСинхронизацииНаКлиенте(Истина);
	
	Если ТаблицаКоллизий.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Necessary to resolve conflicts of synchronization", , "ТаблицаКоллизий");
		Возврат;
	КонецЕсли;
	
	Результат = ЗаполнитьПоДаннымФайлаНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПоДаннымФайлаНаСервере()
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтотОбъект);
	СтруктураПараметров.Вставить("СтруктураКолонок", РеквизитФормыВЗначение("СтруктураКолонок"));
	СтруктураПараметров.Вставить("ТаблицаДанных", РеквизитФормыВЗначение("ТаблицаДанных"));
	СтруктураПараметров.Вставить("ИсточникДанных", РеквизитФормыВЗначение("Объект").ИсточникДанных);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхLawson.СформироватьПроводкиDSS(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'DSS loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхLawson.СформироватьПроводкиDSS", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСписокЗагруженныхПроводокDSS(Форма)
	
	Форма.Элементы.СозданныеПроводкиDSS.Обновить();
	Форма.Элементы.СозданныеПроводкиDSSНеобрабатываемые.Обновить();
	
КонецПроцедуры

&НаКлиенте
Процедура СозданныеПроводкиDSSВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.СозданныеПроводкиDSS.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.ПроводкаDSS);
	ОткрытьФорму("Документ.ПроводкаDSS.Форма.ФормаДокументаУправляемая", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКоллизийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элемент.ТекущийЭлемент <> Элементы.ТаблицаКоллизийИдентификатор Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаКоллизийТекущиеДанные = Элементы.ТаблицаКоллизий.ТекущиеДанные;
	
	Если ТаблицаКоллизийТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЗначенияЗаполнения = Новый Структура("Идентификатор, ТипСоответствия, ТипОбъектаВнешнейСистемы");
	ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, Элементы.ТаблицаКоллизий.ТекущиеДанные);
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("Период", Объект.Дата);
	
	ОткрытьФорму("РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Форма.ФормаЗаписи"
		, ПараметрыФормы, ЭтаФорма, , , , Новый ОписаниеОповещения("ТаблицаКоллизийВыборЗавершение", ЭтаФорма)
		, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаКоллизийВыборЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ОтработкаКоллизии" Тогда
		
		ИдентификаторТекущейстроки = Элементы.ТаблицаКоллизий.ТекущаяСтрока;
		Если ИдентификаторТекущейстроки <> Неопределено Тогда
			ТекСтрока = ТаблицаКоллизий.НайтиПоИдентификатору(ИдентификаторТекущейстроки);
			ТекСтрока.КоллизияОтработана = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПровестиЗагруженныеДокументыНаСервере()
	
	СтруктураПараметров = Новый Структура("Ссылка", Объект.Ссылка);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхLawson.ПровестиЗагруженныеДокументы(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'DSS posting'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхLawson.ПровестиЗагруженныеДокументы", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПровестиЗагруженныеДокументы(Команда)
	
	Результат = ПровестиЗагруженныеДокументыНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияПриЗагрузкеDSS(Команда)
	
	ОткрытьФорму("РегистрСведений.ИсключенияПриЗагрузкеDSS.Форма.ФормаСписка", , ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры
