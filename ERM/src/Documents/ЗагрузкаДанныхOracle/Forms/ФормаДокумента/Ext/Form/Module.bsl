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
		
		Если Объект.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") Тогда
			ЗаполнитьСписокЛистовЭкселя(Истина);
		КонецЕсли;
		
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
	
	//ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsb");
	//СсылкаНаФайл = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ИсточникДанных");
	//ПолучитьФайл(СсылкаНаФайл, ПутьКФайлу, Ложь);
	
	//УдалитьШапкуФайла(ПутьКФайлу);
	
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
	СтруктураПараметров.Вставить("ИмяРегистра", ?(Объект.Source = Перечисления.ТипыСоответствий.OracleMI, "OracleSourceData", "OracleSmithSourceData"));
	
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

&НаКлиенте
Процедура УдалитьШапкуФайла(ПутьКФайлу)
	
	ЭкземплярExcel = Новый COMОбъект("Excel.Application");
	Книга = ЭкземплярExcel.Application.Workbooks.Open(ПутьКФайлу);
	
	ИмяЛиста = Объект.ЛистФайла;
	Если Прав(ИмяЛиста, 1) = "$" Тогда
		ИмяЛиста = Лев(ИмяЛиста, СтрДлина(ИмяЛиста) - 1);
	КонецЕсли;
	
	Лист = ЭкземплярExcel.Worksheets(ИмяЛиста);
	
	// в качестве ориентиров будем использовать колонки SOURCE_SYSTEM, GL_ACCOUNT, ID_ORIG
	НомерСтрокиЗаголовка = 1;
	
	Для ТекНомерСтроки = 1 По 100 Цикл
		
		НайденаSourceSystem = Ложь;
		НайденаGlAccount = Ложь;
		НайденаIdOrig = Ложь;
		
		Для ТекНомерСтолбца = 1 По 100 Цикл
			
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "SOURCE_SYSTEM" Тогда
				НайденаSourceSystem = Истина;
			КонецЕсли;
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "GL_ACCOUNT" Тогда
				НайденаGlAccount = Истина;
			КонецЕсли;
			Если Лист.Cells(ТекНомерСтроки, ТекНомерСтолбца).Value = "ID_ORIG" Тогда
				НайденаIdOrig = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если НайденаSourceSystem И НайденаGlAccount И НайденаIdOrig Тогда
			НомерСтрокиЗаголовка = ТекНомерСтроки;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если НомерСтрокиЗаголовка > 1 Тогда
		
		СтрокиДляУдаления = Лист.Rows("1:3");
		СтрокиДляУдаления.Delete();
		Книга.SaveAs(ПутьКФайлу);
		
	КонецЕсли;
	
	ЭкземплярExcel.Quit();
	ЭкземплярExcel = Неопределено;
	
КонецПроцедуры

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
	
	Если ПустаяСтрока(Объект.ЛистФайла) И Объект.Source = Перечисления.ТипыСоответствий.OracleMI Тогда
		ЗаполнитьСписокЛистовЭкселя();
	КонецЕсли;
	ФлагПроблемыПриЗагрузкеНеотработанные = Истина;
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	УстановитьОтборыСписков();
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
	
	ПутьКФайлу = ПолучитьИмяВременногоФайла("xlsb");
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
	
	//ЗначениеВРеквизитФормы(Документы.ЗагрузкаДанныхOracle.ПолучитьСтруктуруКолонокТаблицыДанных(), "СтруктураКолонок");
	СтруктураКолонок.Загрузить(Документы.ЗагрузкаДанныхOracle.ПолучитьСтруктуруКолонокТаблицыДанных(Объект.Source));
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Объект.Проведен;
	// { RGS TAlmazova 14.07.2016 19:20:58 - только просмотр формы
	Если Объект.СтатусЗагрузки = Перечисления.СтатусыЗагрузки.CreatedTransactions ИЛИ Объект.СтатусЗагрузки = Перечисления.СтатусыЗагрузки.PostedTransactions Тогда
		ТолькоПросмотр = Истина;
		Элементы.ПрочитатьФайл.Доступность = Ложь;
		Элементы.ВыполнитьПроверкуНастроекСинхронизации.Доступность = Ложь;
		Элементы.СозданныеПроводкиDSSЗаполнитьПоДаннымФайла.Доступность = Ложь;
	КонецЕсли;
	// } RGS TAlmazova 14.07.2016 19:21:07 - только просмотр формы
	УстановитьОтборыСписков();
	
	Если Объект.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleSmith") Тогда
		Элементы.ЛистФайла.Доступность = Ложь;
	Иначе
		Элементы.ЛистФайла.Доступность = Истина;
	КонецЕсли;
	
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
	СтруктураПараметров.Вставить("ТипВнешнейСистемы", Объект.Source);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() ИЛИ ЗапретитьВыполнениеВФоне Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхOracle.ВыполнитьПроверкуНастроекСинхронизации(СтруктураПараметров, АдресХранилища);
		
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Проверка настроек синхронизации Billing Oracle'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхOracle.ВыполнитьПроверкуНастроекСинхронизации", 
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
	СтруктураПараметров.Вставить("ТипВнешнейСистемы", Объект.Source);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхOracle.СформироватьПроводкиDSS(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Oracle loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхOracle.СформироватьПроводкиDSS", 
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
	ОткрытьФорму("Документ.ТранзакцияOracle.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
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
			ОткрытьФорму("ПланСчетов.Oracle.ФормаОбъекта", ПараметрыФормы, ЭтаФорма, , , 
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
	
	СтруктураПараметров = Новый Структура("Ссылка, ТипВнешнейСистемы");
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("ТипВнешнейСистемы", Объект.Source);

	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхOracle.ПровестиЗагруженныеДокументы(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'DSS posting'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхOracle.ПровестиЗагруженныеДокументы", 
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
Процедура SourceПриИзменении(Элемент)
	
	ЗаполнитьСтруктуруКолонокПоУмолчанию();
	
	Если Объект.Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleSmith") Тогда
		Элементы.ЛистФайла.Доступность = Ложь;
	Иначе
		Элементы.ЛистФайла.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроблемыПриЗагрузкеВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ПроблемыПриЗагрузке.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", ТекущиеДанные.Транзакция);
	ОткрытьФорму("Документ.ТранзакцияOracle.Форма.ФормаДокумента", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборПроблемПриЗагрузке()
	
	Если ФлагПроблемыПриЗагрузкеНеотработанные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(ПроблемыПриЗагрузке, "НаличиеКорректировки", Ложь, , , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УдалитьЭлементыГруппыОтбораДинамическогоСписка(ПроблемыПриЗагрузке, "НаличиеКорректировки");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФлагПроблемыПриЗагрузкеНеотработанныеПриИзменении(Элемент)
	
	УстановитьОтборПроблемПриЗагрузке();
	
КонецПроцедуры
