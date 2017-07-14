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
		
		//ЗаполнитьСписокЛистовЭкселя(Истина);
		
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
	Иначе
		Прочитать();
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
	СтруктураПараметров.Вставить("ТипТранзакций", Объект.ТипТранзакций);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхHOB.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'HOB loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхHOB.ЗагрузитьДанныеИзФайла", 
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
				Прочитать();
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
	
	//Если ПустаяСтрока(Объект.ЛистФайла) Тогда
	//	ЗаполнитьСписокЛистовЭкселя();
	//КонецЕсли;
	ФлагПроблемыПриЗагрузкеНеотработанные = Истина;
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	УстановитьОтборыСписков();
	ОбновитьКонстантуrgsДатаЗакрытияHOB();
	УстановитьОтборПроблемПриЗагрузке();
	
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
	
	//Если Объект.ТипТранзакций = Перечисления.HOBTransactionType.Accrual Тогда
	//	_ЗаполнитьСтруктуруКолонокAccrualsПоУмолчанию();
	//ИначеЕсли Объект.ТипТранзакций = Перечисления.HOBTransactionType.JV Тогда
	//	_ЗаполнитьСтруктуруКолонокJVПоУмолчанию();
	//ИначеЕсли Объект.ТипТранзакций = Перечисления.HOBTransactionType.Receivables Тогда
	//	_ЗаполнитьСтруктуруКолонокReceivablesПоУмолчанию();
	//КонецЕсли;
	
	СтруктураКолонок.Загрузить(Документы.ЗагрузкаДанныхHOB.ПолучитьСтруктуруКолонокТаблицыДанных(Объект.ТипТранзакций));
	
КонецПроцедуры

&НаСервере
Процедура _ЗаполнитьСтруктуруКолонокAccrualsПоУмолчанию()
	
	// Period
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TrDate";
	СтрокаТЗ.ИмяКолонки = "Period";
	СтрокаТЗ.Обязательная = Истина;
	
	// TrNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TrNumber";
	СтрокаТЗ.ИмяКолонки = "TrNumber";
	СтрокаТЗ.Обязательная = Истина;
	
	// Document
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Document";
	СтрокаТЗ.ИмяКолонки = "Document";
	СтрокаТЗ.Обязательная = Истина;
	
	// DocumentType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentType";
	СтрокаТЗ.ИмяКолонки = "DocumentType";
	СтрокаТЗ.Обязательная = Истина;
	
	// Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "Account";
	СтрокаТЗ.Обязательная = Истина;
	
	// Client
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Client";
	СтрокаТЗ.ИмяКолонки = "Client";
	СтрокаТЗ.Обязательная = Истина;
	
	// INN
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "INN";
	СтрокаТЗ.ИмяКолонки = "INN";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderAgreementCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderAgreementCode";
	СтрокаТЗ.ИмяКолонки = "SalesOrderAgreementCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderAgreement
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderAgreement";
	СтрокаТЗ.ИмяКолонки = "SalesOrderAgreement";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrder
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrder";
	СтрокаТЗ.ИмяКолонки = "SalesOrder";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderNumber";
	СтрокаТЗ.ИмяКолонки = "SalesOrderNumber";
	СтрокаТЗ.Обязательная = Истина;
		
	// CompanyCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyCode";
	СтрокаТЗ.ИмяКолонки = "CompanyCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// CompanyDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyDesc";
	СтрокаТЗ.ИмяКолонки = "CompanyDesc";
	СтрокаТЗ.Обязательная = Истина;
	
	// Currency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Currency";
	СтрокаТЗ.ИмяКолонки = "Currency";
	СтрокаТЗ.Обязательная = Истина;
	
	// LocationCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LocationCode";
	СтрокаТЗ.ИмяКолонки = "LocationCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// LocationDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LocationDesc";
	СтрокаТЗ.ИмяКолонки = "LocationDesc";
	СтрокаТЗ.Обязательная = Истина;
	
	// Amount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Amount";
	СтрокаТЗ.ИмяКолонки = "Amount";
	СтрокаТЗ.Обязательная = Истина;
	
	// BaseAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BaseAmount";
	СтрокаТЗ.ИмяКолонки = "BaseAmount";
	СтрокаТЗ.Обязательная = Истина;
	
	// JobEndDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "JobEndDate";
	СтрокаТЗ.ИмяКолонки = "JobEndDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderAmount";
	СтрокаТЗ.ИмяКолонки = "SalesOrderAmount";
	СтрокаТЗ.Обязательная = Истина;
	
	// ERPStatus
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ERPStatus";
	СтрокаТЗ.ИмяКолонки = "ERPStatus";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderCurrency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderCurrency";
	СтрокаТЗ.ИмяКолонки = "SalesOrderCurrency";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderExchangeRate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderExchangeRate";
	СтрокаТЗ.ИмяКолонки = "SalesOrderExchangeRate";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderApprovalDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderApprovalDate";
	СтрокаТЗ.ИмяКолонки = "SalesOrderApprovalDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderApprovedBy
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderApprovedBy";
	СтрокаТЗ.ИмяКолонки = "SalesOrderApprovedBy";
	СтрокаТЗ.Обязательная = Истина;
	
	// AU
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AU";
	СтрокаТЗ.ИмяКолонки = "AU";
	СтрокаТЗ.Обязательная = Истина;
	
	// AUType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AUType";
	СтрокаТЗ.ИмяКолонки = "AUType";
	СтрокаТЗ.Обязательная = Истина;
	
	// SubSubSegment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubSubSegment";
	СтрокаТЗ.ИмяКолонки = "SubSubSegment";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderDate";
	СтрокаТЗ.ИмяКолонки = "SalesOrderDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// Invoice
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Invoice";
	СтрокаТЗ.ИмяКолонки = "Invoice";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceDate";
	СтрокаТЗ.ИмяКолонки = "InvoiceDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceNumber";
	СтрокаТЗ.ИмяКолонки = "InvoiceNumber";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceCurrency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceCurrency";
	СтрокаТЗ.ИмяКолонки = "InvoiceCurrency";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAmount";
	СтрокаТЗ.ИмяКолонки = "InvoiceAmount";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceBilled
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceBilled";
	СтрокаТЗ.ИмяКолонки = "InvoiceBilled";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForApproval
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForApproval";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForApproval";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForPayment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForPayment";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForPayment";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForApprovalDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForApprovalDate";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForApprovalDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForPaymentDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForPaymentDate";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForPaymentDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// ExpectedDateOfPayment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ExpectedDateOfPayment";
	СтрокаТЗ.ИмяКолонки = "ExpectedDateOfPayment";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceAgreementCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAgreementCode";
	СтрокаТЗ.ИмяКолонки = "InvoiceAgreementCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceAgreement
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAgreement";
	СтрокаТЗ.ИмяКолонки = "InvoiceAgreement";
	СтрокаТЗ.Обязательная = Истина;
	
	// Reverse
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Reverse";
	СтрокаТЗ.ИмяКолонки = "Reverse";
	СтрокаТЗ.Обязательная = Истина;
	
	// LegalEntity
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LegalEntity";
	СтрокаТЗ.ИмяКолонки = "LegalEntity";
	СтрокаТЗ.Обязательная = Истина;
	
	// DocumentID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentID";
	СтрокаТЗ.ИмяКолонки = "DocumentID";
	СтрокаТЗ.Обязательная = Истина;
	
	// SalesOrderID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SalesOrderID";
	СтрокаТЗ.ИмяКолонки = "SalesOrderID";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceID";
	СтрокаТЗ.ИмяКолонки = "InvoiceID";
	СтрокаТЗ.Обязательная = Истина;
	
КонецПроцедуры

&НаСервере
Процедура _ЗаполнитьСтруктуруКолонокJVПоУмолчанию()
	
	// Period
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TrDate";
	СтрокаТЗ.ИмяКолонки = "Period";
	СтрокаТЗ.Обязательная = Истина;
	
	// TrNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TrNumber";
	СтрокаТЗ.ИмяКолонки = "TrNumber";
	СтрокаТЗ.Обязательная = Истина;
	
	// Document
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Document";
	СтрокаТЗ.ИмяКолонки = "Document";
	СтрокаТЗ.Обязательная = Истина;
	
	// DocumentType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentType";
	СтрокаТЗ.ИмяКолонки = "DocumentType";
	СтрокаТЗ.Обязательная = Истина;
	
	// Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "Account";
	СтрокаТЗ.Обязательная = Истина;
	
	// Client
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Client";
	СтрокаТЗ.ИмяКолонки = "Client";
	СтрокаТЗ.Обязательная = Истина;
	
	// INN
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "INN";
	СтрокаТЗ.ИмяКолонки = "INN";
	СтрокаТЗ.Обязательная = Истина;
	
	// CompanyCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyCode";
	СтрокаТЗ.ИмяКолонки = "CompanyCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// CompanyDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyDesc";
	СтрокаТЗ.ИмяКолонки = "CompanyDesc";
	СтрокаТЗ.Обязательная = Истина;
	
	// Currency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Currency";
	СтрокаТЗ.ИмяКолонки = "Currency";
	СтрокаТЗ.Обязательная = Истина;
	
	// LocationCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LocationCode";
	СтрокаТЗ.ИмяКолонки = "LocationCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// LocationDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LocationDesc";
	СтрокаТЗ.ИмяКолонки = "LocationDesc";
	СтрокаТЗ.Обязательная = Истина;
	
	// Amount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Amount";
	СтрокаТЗ.ИмяКолонки = "Amount";
	СтрокаТЗ.Обязательная = Истина;
	
	// BaseAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BaseAmount";
	СтрокаТЗ.ИмяКолонки = "BaseAmount";
	СтрокаТЗ.Обязательная = Истина;
	
	// AU
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AU";
	СтрокаТЗ.ИмяКолонки = "AU";
	СтрокаТЗ.Обязательная = Истина;
	
	// AUType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AUType";
	СтрокаТЗ.ИмяКолонки = "AUType";
	СтрокаТЗ.Обязательная = Истина;
	
	// SubSubSegment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubSubSegment";
	СтрокаТЗ.ИмяКолонки = "SubSubSegment";
	СтрокаТЗ.Обязательная = Истина;
	
	// Reverse
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Reverse";
	СтрокаТЗ.ИмяКолонки = "Reverse";
	СтрокаТЗ.Обязательная = Истина;
	
	// LegalEntity
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LegalEntity";
	СтрокаТЗ.ИмяКолонки = "LegalEntity";
	СтрокаТЗ.Обязательная = Истина;
	
	// DocumentID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentID";
	СтрокаТЗ.ИмяКолонки = "DocumentID";
	СтрокаТЗ.Обязательная = Истина;
	
КонецПроцедуры

&НаСервере
Процедура _ЗаполнитьСтруктуруКолонокReceivablesПоУмолчанию()
	
	// Period
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TrDate";
	СтрокаТЗ.ИмяКолонки = "Period";
	СтрокаТЗ.Обязательная = Истина;
	
	// TrNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TrNumber";
	СтрокаТЗ.ИмяКолонки = "TrNumber";
	СтрокаТЗ.Обязательная = Истина;
	
	// Document
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Document";
	СтрокаТЗ.ИмяКолонки = "Document";
	СтрокаТЗ.Обязательная = Истина;
	
	// DocumentType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentType";
	СтрокаТЗ.ИмяКолонки = "DocumentType";
	СтрокаТЗ.Обязательная = Истина;
	
	// Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "Account";
	СтрокаТЗ.Обязательная = Истина;
	
	// Client
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Client";
	СтрокаТЗ.ИмяКолонки = "Client";
	СтрокаТЗ.Обязательная = Истина;
	
	// INN
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "INN";
	СтрокаТЗ.ИмяКолонки = "INN";
	СтрокаТЗ.Обязательная = Истина;
	
	// CompanyCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyCode";
	СтрокаТЗ.ИмяКолонки = "CompanyCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// CompanyDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyDesc";
	СтрокаТЗ.ИмяКолонки = "CompanyDesc";
	СтрокаТЗ.Обязательная = Истина;
	
	// Currency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Currency";
	СтрокаТЗ.ИмяКолонки = "Currency";
	СтрокаТЗ.Обязательная = Истина;
	
	// LocationCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LocationCode";
	СтрокаТЗ.ИмяКолонки = "LocationCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// LocationDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LocationDesc";
	СтрокаТЗ.ИмяКолонки = "LocationDesc";
	СтрокаТЗ.Обязательная = Истина;
	
	// Amount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Amount";
	СтрокаТЗ.ИмяКолонки = "Amount";
	СтрокаТЗ.Обязательная = Истина;
	
	// BaseAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BaseAmount";
	СтрокаТЗ.ИмяКолонки = "BaseAmount";
	СтрокаТЗ.Обязательная = Истина;
	
	// AU
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AU";
	СтрокаТЗ.ИмяКолонки = "AU";
	СтрокаТЗ.Обязательная = Истина;
	
	// AUType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AUType";
	СтрокаТЗ.ИмяКолонки = "AUType";
	СтрокаТЗ.Обязательная = Истина;
	
	// SubSubSegment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubSubSegment";
	СтрокаТЗ.ИмяКолонки = "SubSubSegment";
	СтрокаТЗ.Обязательная = Истина;
	
	// Reverse
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Reverse";
	СтрокаТЗ.ИмяКолонки = "Reverse";
	СтрокаТЗ.Обязательная = Истина;
	
	// Invoice
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Invoice";
	СтрокаТЗ.ИмяКолонки = "Invoice";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceType";
	СтрокаТЗ.ИмяКолонки = "InvoiceType";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceNumber";
	СтрокаТЗ.ИмяКолонки = "InvoiceNumber";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceDate";
	СтрокаТЗ.ИмяКолонки = "InvoiceDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceCurrency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceCurrency";
	СтрокаТЗ.ИмяКолонки = "InvoiceCurrency";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAmount";
	СтрокаТЗ.ИмяКолонки = "InvoiceAmount";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceAgreementCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAgreementCode";
	СтрокаТЗ.ИмяКолонки = "InvoiceAgreementCode";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceAgreement
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAgreement";
	СтрокаТЗ.ИмяКолонки = "InvoiceAgreement";
	СтрокаТЗ.Обязательная = Истина;
	
	// LegalEntity
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LegalEntity";
	СтрокаТЗ.ИмяКолонки = "LegalEntity";
	СтрокаТЗ.Обязательная = Истина;
	
	// FiscalInvoiceNo
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FiscalInvoiceNo";
	СтрокаТЗ.ИмяКолонки = "FiscalInvoiceNo";
	СтрокаТЗ.Обязательная = Истина;
	
	// FiscalInvoiceDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FiscalInvoiceDate";
	СтрокаТЗ.ИмяКолонки = "FiscalInvoiceDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceBilled
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceBilled";
	СтрокаТЗ.ИмяКолонки = "InvoiceBilled";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForApproval
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForApproval";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForApproval";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForPayment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForPayment";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForPayment";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForApprovalDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForApprovalDate";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForApprovalDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoicePassedForPaymentDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoicePassedForPaymentDate";
	СтрокаТЗ.ИмяКолонки = "InvoicePassedForPaymentDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// ExpectedDateOfPayment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ExpectedDateOfPayment";
	СтрокаТЗ.ИмяКолонки = "ExpectedDateOfPayment";
	СтрокаТЗ.Обязательная = Истина;
	
	// PaymentNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PaymentNumber";
	СтрокаТЗ.ИмяКолонки = "PaymentNumber";
	СтрокаТЗ.Обязательная = Истина;
	
	// PaymentDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PaymentDate";
	СтрокаТЗ.ИмяКолонки = "PaymentDate";
	СтрокаТЗ.Обязательная = Истина;
	
	// DocumentID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentID";
	СтрокаТЗ.ИмяКолонки = "DocumentID";
	СтрокаТЗ.Обязательная = Истина;
	
	// InvoiceID
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceID";
	СтрокаТЗ.ИмяКолонки = "InvoiceID";
	СтрокаТЗ.Обязательная = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Объект.Проведен;
	УстановитьОтборыСписков();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSS, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	//ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSSНеобрабатываемые, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSSОшибки, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ChecksumsLoading, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПроблемыПриЗагрузке, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПроблемПриЗагрузке()
	
	Если ФлагПроблемыПриЗагрузкеНеотработанные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПроблемыПриЗагрузке, "НаличиеКорректировки", Ложь, , , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ПроблемыПриЗагрузке, "НаличиеКорректировки");
	КонецЕсли;
	
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
	Иначе
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ВыполнитьПроверкуНастроекСинхронизацииНаСервере(ЗапретитьВыполнениеВФоне = Ложь)
	
	СтруктураПараметров = Новый Структура("Ссылка");
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ТипВнешнейСистемы", Перечисления.ТипыСоответствий.HOBs);
	СтруктураПараметров.Вставить("ТипТранзакций", Объект.ТипТранзакций);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() ИЛИ ЗапретитьВыполнениеВФоне Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхHOB.ВыполнитьПроверкуНастроекСинхронизации(СтруктураПараметров, АдресХранилища);
		
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Проверка настроек синхронизации Billing HOB'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхHOB.ВыполнитьПроверкуНастроекСинхронизации", 
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
	Иначе
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьПоДаннымФайлаНаСервере()
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтотОбъект);
	СтруктураПараметров.Вставить("СтруктураКолонок", РеквизитФормыВЗначение("СтруктураКолонок"));
	СтруктураПараметров.Вставить("ИсточникДанных", РеквизитФормыВЗначение("Объект").ИсточникДанных);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ТипВнешнейСистемы", Перечисления.ТипыСоответствий.HOBs);
	СтруктураПараметров.Вставить("ТипТранзакций", Объект.ТипТранзакций);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхHOB.СформироватьПроводкиDSS(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'HOB loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхHOB.СформироватьПроводкиDSS", 
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
	ОткрытьФорму("Документ.ТранзакцияHOB.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
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
	
	Если ТаблицаКоллизийТекущиеДанные.Описание = "Not specified base element" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ТаблицаКоллизийТекущиеДанные.ОбъектПриемника);
		
		Если ТаблицаКоллизийТекущиеДанные.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Segment") Тогда
			ОткрытьФорму("Справочник.Сегменты.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма, , , 
			, Новый ОписаниеОповещения("ТаблицаКоллизийВыборЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ИначеЕсли ТаблицаКоллизийТекущиеДанные.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Location") Тогда
			ОткрытьФорму("Справочник.ПодразделенияОрганизаций.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма, , , 
			, Новый ОписаниеОповещения("ТаблицаКоллизийВыборЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ИначеЕсли ТаблицаКоллизийТекущиеДанные.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Company") Тогда
			ОткрытьФорму("Справочник.Организации.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма, , , 
			, Новый ОписаниеОповещения("ТаблицаКоллизийВыборЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		ИначеЕсли ТаблицаКоллизийТекущиеДанные.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Account") Тогда
			ОткрытьФорму("ПланСчетов.Lawson.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, , , 
			, Новый ОписаниеОповещения("ТаблицаКоллизийВыборЗавершение", ЭтаФорма), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		КонецЕсли;
		
	КонецЕсли;
	
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
		Документы.ЗагрузкаДанныхHOB.ПровестиЗагруженныеДокументы(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'DSS posting'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхHOB.ПровестиЗагруженныеДокументы", 
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
	Иначе
		Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИсключенияПриЗагрузкеDSS(Команда)
	
	ОткрытьФорму("РегистрСведений.ИсключенияПриЗагрузкеDSS.Форма.ФормаСписка", , ЭтотОбъект, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	УстановитьОтборыСписков();
КонецПроцедуры

&НаКлиенте
Процедура ТипТранзакцийПриИзменении(Элемент)
	ТипТранзакцийПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТипТранзакцийПриИзмененииНаСервере()
	
	ЗаполнитьСтруктуруКолонокПоУмолчанию();
	
КонецПроцедуры

&НаКлиенте
Процедура HOBClosingDateНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФорму("Константа.rgsДатаЗакрытияHOB.ФормаКонстант", , ЭтаФорма, , , , Новый ОписаниеОповещения("HOBClosingDateЗавершение", ЭтотОбъект));
	
КонецПроцедуры

Процедура HOBClosingDateЗавершение(Результат, ДополнительныеПараметры) Экспорт

	ОбновитьКонстантуrgsДатаЗакрытияHOB();

КонецПроцедуры


&НаСервере
Процедура ОбновитьКонстантуrgsДатаЗакрытияHOB()
	
	HOBClosingDate = Константы.rgsДатаЗакрытияHOB.Получить();
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагПроблемыПриЗагрузкеНеотработанныеПриИзменении(Элемент)
	УстановитьОтборПроблемПриЗагрузке();
КонецПроцедуры


