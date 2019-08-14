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
	
	ТекущийОбъект.ТаблицаСтрокRevenue = СтрокиRevenue.Выгрузить();
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьФайл(Команда)
	// { RGS PMatkov 25.12.2015 12:18:36 - 
	Если ПустаяСтрока(Объект.ЛистФайла) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Не выбран лист эксель",,
		"Объект.ЛистФайла",,);
		Возврат;
	КонецЕсли;
	// } RGS PMatkov 25.12.2015 12:18:37 - 
	
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
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхRevenue.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Загрузка данных Revenue'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхRevenue.ЗагрузитьДанныеИзФайла", 
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
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтруктураДанных.ОшибкаЗаполнения);
		Возврат;
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

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСписокЛистовЭкселя();
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	// { RGS PMatkov 15.12.2015 17:10:56
	RGSИзменениеВидимостиКолонок();
	// } RGS PMatkov 15.12.2015 17:10:56
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ОбновитьТаблицуRevenueLines();
	КонецЕсли;
	//RGS VSobolev S-E-0000786 15.03.2019
	Если РольДоступна("ReadOnly") И Не РольДоступна("ПолныеПрава") Тогда
		Элементы.Найти.Доступность = Ложь;
		Элементы.СозданныеПроводкиDSSПровестиЗагруженныеДокументы.Доступность = Ложь;
		Элементы.ИмяФайла.КнопкаОткрытия = Ложь;
		Элементы.ФлагПроблемыПриЗагрузкеНеотработанные.Доступность = Ложь;
	КонецЕсли;
	//RGS VSobolev S-E-0000786 15.03.2019
	
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
		// { RGS PMatkov 25.12.2015 14:43:25 - 
		//ЛистФайла = СписокЛистов[0];
		Объект.ЛистФайла = СписокЛистов[0];
		// } RGS PMatkov 25.12.2015 14:43:26 - 
	Конецесли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруФайлаПоУмолчанию()
	// { RGS PMatkov 16.12.2015 16:21:51 - 
	//ПерваяСтрокаДанных = 2;
	Если Объект.ТипВнешнейСистемы = Перечисления.ТипыСоответствий.Lawson Тогда
		ПерваяСтрокаДанных = 2;
	ИначеЕсли Объект.ТипВнешнейСистемы = Перечисления.ТипыСоответствий.OracleMI Тогда
		ПерваяСтрокаДанных = 3;
	КонецЕсли;
	// } RGS PMatkov 16.12.2015 16:21:52 - 
	ИменаКолонокВПервойСтроке = Истина;
	ЗаполнитьСтруктуруКолонокПоУмолчанию();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчанию()
	
	СтруктураКолонок.Очистить();
	
	Если Объект.ТипВнешнейСистемы = Перечисления.ТипыСоответствий.Lawson Тогда
		ЗаполнитьСтруктуруКолонокПоУмолчаниюLawson();
	ИначеЕсли Объект.ТипВнешнейСистемы = Перечисления.ТипыСоответствий.OracleMI Тогда
		ЗаполнитьСтруктуруКолонокПоУмолчаниюOracleMI();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчаниюLawson()
	
	// Segment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Segment";
	СтрокаТЗ.ИмяКолонки = "Segment";
	СтрокаТЗ.НомерКолонки = 1;
	
	// Sub Sub Segment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubSubSegment";
	СтрокаТЗ.ИмяКолонки = "Sub Sub Segment";
	СтрокаТЗ.НомерКолонки = 2;
	
	// Sub Segment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubSegment";
	СтрокаТЗ.ИмяКолонки = "Sub Segment";
	СтрокаТЗ.НомерКолонки = 3;
	
	// Geomarket
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Geomarket";
	СтрокаТЗ.ИмяКолонки = "Geomarket";
	СтрокаТЗ.НомерКолонки = 4;
	
	// Sub Geomarket
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubGeomarket";
	СтрокаТЗ.ИмяКолонки = "Sub Geomarket";
	СтрокаТЗ.НомерКолонки = 5;
	
	// Billing Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BillingAccount";
	СтрокаТЗ.ИмяКолонки = "Billing Account";
	СтрокаТЗ.НомерКолонки = 6;
	
	// Corporate Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CorporateAccount";
	СтрокаТЗ.ИмяКолонки = "Corporate Account";
	СтрокаТЗ.НомерКолонки = 7;
	
	// Lawson Customer Code
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerCode";
	СтрокаТЗ.ИмяКолонки = "Customer Code";
	СтрокаТЗ.НомерКолонки = 8;
	
	// YearMonth
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "YearMonth";
	СтрокаТЗ.ИмяКолонки = "YearMonth";
	СтрокаТЗ.НомерКолонки = 9;
	
	// CM-1 Rev. (USD)
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Revenue";
	СтрокаТЗ.ИмяКолонки = "CM-1 Rev. (USD)";
	СтрокаТЗ.НомерКолонки = 10;
	
	// Currency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Currency";
	СтрокаТЗ.ИмяКолонки = "Currency";
	СтрокаТЗ.НомерКолонки = 11;
	
	// Accounting Unit
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AccountingUnit";
	СтрокаТЗ.ИмяКолонки = "Accounting Unit";
	СтрокаТЗ.НомерКолонки = 12;
	
	// Contract Name
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ContractName";
	СтрокаТЗ.ИмяКолонки = "Contract Name";
	СтрокаТЗ.НомерКолонки = 13;
	
	// Client Contract
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ClientContract";
	СтрокаТЗ.ИмяКолонки = "Client Contract";
	СтрокаТЗ.НомерКолонки = 14;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчаниюOracleMI()
	
	// Geomarket
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Geomarket";
	СтрокаТЗ.ИмяКолонки = "Geomarket";
	СтрокаТЗ.НомерКолонки = 1;
	
	// Sub Geomarket
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubGeomarket";
	СтрокаТЗ.ИмяКолонки = "Sub Geomarket";
	СтрокаТЗ.НомерКолонки = 2;
	
	// Segment
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Segment";
	СтрокаТЗ.ИмяКолонки = "Segment";
	СтрокаТЗ.НомерКолонки = 4;
	
	// Customer Code
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerCode";
	СтрокаТЗ.ИмяКолонки = "Customer Code";
	СтрокаТЗ.НомерКолонки = 10;
	
	// Billing Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BillingAccount";
	СтрокаТЗ.ИмяКолонки = "Billing Account";
	СтрокаТЗ.НомерКолонки = 11;
	
	//Amount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Revenue";
	СтрокаТЗ.ИмяКолонки = "Amount";
	СтрокаТЗ.НомерКолонки = 12;
	
	// Currency
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Currency";
	СтрокаТЗ.ИмяКолонки = "Currency";
	СтрокаТЗ.НомерКолонки = 13;
	
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
	СтруктураПараметров.Вставить("ТипВнешнейСистемы", Объект.ТипВнешнейСистемы);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() ИЛИ ЗапретитьВыполнениеВФоне Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхRevenue.ВыполнитьПроверкуНастроекСинхронизации(СтруктураПараметров, АдресХранилища);
		
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Проверка настроек синхронизации Revenue'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхRevenue.ВыполнитьПроверкуНастроекСинхронизации", 
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
Процедура ТаблицаКоллизийОбъектПриемникаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	
	
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
	// { RGS PMatkov 22.12.2015 15:44:54 - 
	//Если ТаблицаКоллизийТекущиеДанные.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Client")
	//	// И ТаблицаКоллизийТекущиеДанные.ТипСоответствия <> ПредопределенноеЗначение("Перечисление.ТипыСоответствий.HOBs")
	//	И ТаблицаКоллизийТекущиеДанные.ТипСоответствия <> ПредопределенноеЗначение("Перечисление.ТипыСоответствий.Sun") Тогда
	//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Corresponding custom by 'CRM accounts extract loading'");
	//	Возврат;
	//КонецЕсли;
	// } RGS PMatkov 22.12.2015 15:44:55 - 
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

&НаКлиенте
Процедура ПоказыватьТолькоНеотработанныеКоллизииПриИзменении(Элемент)
	
	Если ПоказыватьТолькоНеотработанныеКоллизии Тогда
		Элементы.ТаблицаКоллизий.ОтборСтрок = Новый ФиксированнаяСтруктура("КоллизияОтработана", Ложь);
	Иначе
		Элементы.ТаблицаКоллизий.ОтборСтрок = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоДаннымФайла(Команда)
	
	ВыполнитьПроверкуНастроекСинхронизацииНаКлиенте(Истина);
	
	Если ТаблицаКоллизий.Количество() > 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Necessary to resolve conflicts of synchronization", , "ТаблицаКоллизий");
		Возврат;
	КонецЕсли;
	
	СтрокиRevenue.Очистить();
	
	ЗаполнитьПоДаннымФайлаНаСервере();
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоДаннымФайлаНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	RevenueSourceData.СтрокаФайла,
		|	RevenueSourceData.Segment,
		|	RevenueSourceData.SubSegment,
		|	RevenueSourceData.SubSubSegment,
		|	RevenueSourceData.Geomarket,
		|	RevenueSourceData.SubGeomarket,
		|	RevenueSourceData.BillingAccount,
		|	RevenueSourceData.CorporateAccount,
		|	RevenueSourceData.CustomerCode,
		|	RevenueSourceData.YearMonth,
		|	RevenueSourceData.Revenue,
		|	RevenueSourceData.Currency,
		|	RevenueSourceData.ContractName,
		|	RevenueSourceData.ClientContract
		|ПОМЕСТИТЬ ВТ_ДанныеФайла
		|ИЗ
		|	РегистрСведений.RevenueSourceData КАК RevenueSourceData
		|ГДЕ
		|	RevenueSourceData.ДокументЗагрузки = &ДокументЗагрузки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_СоответствиеСегментов
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			&Период,
		// { RGS PMatkov 16.12.2015 18:13:27 - 
		//|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|			ТипСоответствия = &ТипСоответствия
		// } RGS PMatkov 16.12.2015 18:13:27 - 

		|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Segment)
		|				И Идентификатор В
		|					(ВЫБРАТЬ
		|						ВТ_ДанныеФайла.Segment
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла
		|			
		|					ОБЪЕДИНИТЬ
		|			
		|					ВЫБРАТЬ
		|						ВТ_ДанныеФайла.SubSegment
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла
		|			
		|					ОБЪЕДИНИТЬ
		|			
		|					ВЫБРАТЬ
		|						ВТ_ДанныеФайла.SubSubSegment
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_СоответствиеГеомаркетов
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			&Период,
		// { RGS PMatkov 16.12.2015 18:13:27 - 
		//|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|			ТипСоответствия = &ТипСоответствия
		// } RGS PMatkov 16.12.2015 18:13:27 - 
		|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Geomarket)
		|				И Идентификатор В
		|					(ВЫБРАТЬ
		|						ВТ_ДанныеФайла.Geomarket
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла
		|			
		|					ОБЪЕДИНИТЬ
		|			
		|					ВЫБРАТЬ
		|						ВТ_ДанныеФайла.SubGeomarket
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_СоответствиеКлиентов
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			&Период,
		// { RGS PMatkov 16.12.2015 18:13:27 - 
		//|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|			ТипСоответствия = &ТипСоответствия
		// } RGS PMatkov 16.12.2015 18:13:27 - 
		|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|				И Идентификатор В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_ДанныеФайла.CustomerCode
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_СоответствиеParentClient
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			&Период,
		|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.ParentClients)
		|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|				И Идентификатор В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_ДанныеФайла.CorporateAccount
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_СоответствиеCurrency
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			&Период,
		// { RGS PMatkov 16.12.2015 18:13:27 - 
		//|			ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|			ТипСоответствия = &ТипСоответствия
		// } RGS PMatkov 16.12.2015 18:13:27 - 
		|				И ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Currency)
		|				И Идентификатор В
		|					(ВЫБРАТЬ РАЗЛИЧНЫЕ
		|						ВТ_ДанныеФайла.Currency
		|					ИЗ
		|						ВТ_ДанныеФайла КАК ВТ_ДанныеФайла)) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор
		|;
		// { RGS PMatkov 16.12.2015 19:52:00 - 
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ИерархияКонтрагентовСрезПоследних.ГоловнойКонтрагент,
		|	ИерархияКонтрагентовСрезПоследних.Контрагент
		|ПОМЕСТИТЬ ВТ_СоответствиеClienthierarchy
		|ИЗ
		|	РегистрСведений.ИерархияКонтрагентов.СрезПоследних(&Период, ) КАК ИерархияКонтрагентовСрезПоследних
		|;
		// } RGS PMatkov 16.12.2015 19:52:01 - 
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеФайла.СтрокаФайла КАК НомерСтрокиФайла,
		|	ВТ_СоответствиеСегментов.ОбъектПриемника КАК Segment,
		|	ВТ_СоответствиеСегментов1.ОбъектПриемника КАК SubSegment,
		|	ВТ_СоответствиеСегментов2.ОбъектПриемника КАК SubSubSegment,
		|	ВТ_СоответствиеГеомаркетов.ОбъектПриемника КАК Geomarket,
		|	ВТ_СоответствиеГеомаркетов1.ОбъектПриемника КАК SubGeomarket,
		// { RGS PMatkov 16.12.2015 19:48:51 - 
		//|	ЕСТЬNULL(ВТ_СоответствиеParentClient.ОбъектПриемника, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК ParentClient,
		|	ВЫБОР
		|		КОГДА &ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
		|			ТОГДА ЕСТЬNULL(ВТ_СоответствиеClienthierarchy.ГоловнойКонтрагент, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))
		|		ИНАЧЕ ЕСТЬNULL(ВТ_СоответствиеParentClient.ОбъектПриемника, ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка))
		|	КОНЕЦ КАК ParentClient,
		// } RGS PMatkov 16.12.2015 19:48:51 - 
		// { RGS PMatkov 16.12.2015 18:43:04 - 
		//|	ЕСТЬNULL(ВТ_СоответствиеКлиентов.ОбъектПриемника, ЗНАЧЕНИЕ(Справочник.Контрагенты.Unallocated)) КАК Client,
		|	ВЫБОР
		|		КОГДА &ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.Lawson)
		|			ТОГДА ЕСТЬNULL(ВТ_СоответствиеКлиентов.ОбъектПриемника, ЗНАЧЕНИЕ(Справочник.Контрагенты.Unallocated))
		|		КОГДА ВТ_ДанныеФайла.CustomerCode = ""<empty>""
		|			ТОГДА ЗНАЧЕНИЕ(Справочник.Контрагенты.Unallocated)
		|		ИНАЧЕ ВТ_СоответствиеКлиентов.ОбъектПриемника
		|	КОНЕЦ КАК Client,
		// } RGS PMatkov 16.12.2015 18:43:05 - 
		|	ВТ_ДанныеФайла.Revenue КАК AmountUSD,
		|	ВТ_СоответствиеCurrency.ОбъектПриемника КАК Currency,
		|	ВТ_ДанныеФайла.ContractName,
		|	ВТ_ДанныеФайла.ClientContract,
		|	СтрокиRevenue.Ссылка
		|ИЗ
		|	ВТ_ДанныеФайла КАК ВТ_ДанныеФайла
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеСегментов КАК ВТ_СоответствиеСегментов
		|		ПО ВТ_ДанныеФайла.Segment = ВТ_СоответствиеСегментов.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеСегментов КАК ВТ_СоответствиеСегментов1
		|		ПО ВТ_ДанныеФайла.SubSegment = ВТ_СоответствиеСегментов1.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеСегментов КАК ВТ_СоответствиеСегментов2
		|		ПО ВТ_ДанныеФайла.SubSubSegment = ВТ_СоответствиеСегментов2.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеГеомаркетов КАК ВТ_СоответствиеГеомаркетов
		|		ПО ВТ_ДанныеФайла.Geomarket = ВТ_СоответствиеГеомаркетов.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеГеомаркетов КАК ВТ_СоответствиеГеомаркетов1
		|		ПО ВТ_ДанныеФайла.SubGeomarket = ВТ_СоответствиеГеомаркетов1.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеParentClient КАК ВТ_СоответствиеParentClient
		|		ПО ВТ_ДанныеФайла.CorporateAccount = ВТ_СоответствиеParentClient.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеКлиентов КАК ВТ_СоответствиеКлиентов
		|		ПО ВТ_ДанныеФайла.CustomerCode = ВТ_СоответствиеКлиентов.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеCurrency КАК ВТ_СоответствиеCurrency
		|		ПО ВТ_ДанныеФайла.Currency = ВТ_СоответствиеCurrency.Идентификатор
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтрокиRevenue КАК СтрокиRevenue
		|		ПО ВТ_ДанныеФайла.СтрокаФайла = СтрокиRevenue.НомерСтрокиФайла
		// { RGS PMatkov 16.12.2015 19:47:55 - 
		|		ЛЕВОЕ СОЕДИНЕНИЕ ВТ_СоответствиеClienthierarchy КАК ВТ_СоответствиеClienthierarchy
		|		ПО ВТ_СоответствиеКлиентов.ОбъектПриемника = ВТ_СоответствиеClienthierarchy.Контрагент";
		// } RGS PMatkov 16.12.2015 19:47:56 - 
	
	Запрос.УстановитьПараметр("Период", Объект.Дата);
	Запрос.УстановитьПараметр("ДокументЗагрузки", Объект.Ссылка);
	// { RGS PMatkov 16.12.2015 18:46:39 - 
	Запрос.УстановитьПараметр("ТипСоответствия", Объект.ТипВнешнейСистемы);
	// } RGS PMatkov 16.12.2015 18:46:40 - 
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ТекНомерСтроки = 1;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрокаRevenue = СтрокиRevenue.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаRevenue, ВыборкаДетальныеЗаписи);
		СтрокаRevenue.НомерСтрокиRevenue = ТекНомерСтроки;
		ТекНомерСтроки = ТекНомерСтроки + 1;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТаблицуRevenueLines()
	
	СтрокиRevenue.Загрузить(Документы.ЗагрузкаДанныхRevenue.ПолучитьТаблицуRevenueLines(Объект.Ссылка));
 	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	УстановитьДоступностьЗагрузкиФайла();
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступностьЗагрузкиФайла()
	
	Элементы.ПрочитатьФайл.Доступность = Не Объект.Проведен;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	УстановитьДоступностьЗагрузкиФайла();
КонецПроцедуры

// { RGS PMatkov 15.12.2015 17:10:56
&НаКлиенте
Процедура ТипВнешнейСистемыПриИзменении(Элемент)
	RGSИзменениеВидимостиКолонок();
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
КонецПроцедуры
// } RGS PMatkov 15.12.2015 17:11:00

// { RGS PMatkov 15.12.2015 17:10:56
&НаСервере
Процедура RGSИзменениеВидимостиКолонок()
	ТипВнешнейСистемы = Объект.ТипВнешнейСистемы;
	Если ТипВнешнейСистемы = Перечисления.ТипыСоответствий.Lawson Тогда
		Элементы.СтрокиRevenueSubSegment.Видимость = Истина;
		Элементы.СтрокиRevenueSubSubSegment.Видимость = Истина;
		Элементы.СтрокиRevenueContractName.Видимость = Истина;
		Элементы.СтрокиRevenueClientContract.Видимость = Истина;
	ИначеЕсли ТипВнешнейСистемы = Перечисления.ТипыСоответствий.OracleMI Тогда
		Элементы.СтрокиRevenueSubSegment.Видимость = Ложь;
		Элементы.СтрокиRevenueSubSubSegment.Видимость = Ложь;
		Элементы.СтрокиRevenueContractName.Видимость = Ложь;
		Элементы.СтрокиRevenueClientContract.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры
// } RGS PMatkov 15.12.2015 17:11:00

