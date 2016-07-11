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
	
	ТаблицаДанных.Очистить();
	
	//////////////
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата, ИсточникДанных, ИменаКолонокВПервойСтроке, ПерваяСтрокаДанных, ПоследняяСтрокаДанных");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтотОбъект);
	СтруктураПараметров.Вставить("СтруктураКолонок", РеквизитФормыВЗначение("СтруктураКолонок"));
	СтруктураПараметров.Вставить("ТаблицаДанных", РеквизитФормыВЗначение("ТаблицаДанных"));
	СтруктураПараметров.Вставить("ИсточникДанных", РеквизитФормыВЗначение("Объект").ИсточникДанных);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхLawson.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'DSS loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхLawson.ЗагрузитьДанныеИзФайла", 
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
	
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	УстановитьОтборыСписков();
	
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
Процедура ЗаполнитьСтруктуруФайлаПоУмолчанию()
	
	ПерваяСтрокаДанных = 2;
	ИменаКолонокВПервойСтроке = Истина;
	ЗаполнитьСтруктуруКолонокПоУмолчанию();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчанию()
	
	СтруктураКолонок.Очистить();
	
	// System
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "System";
	СтрокаТЗ.ИмяКолонки = "System";
	//СтрокаТЗ.НомерКолонки = 1;
	
	// JeType
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "JeType";
	СтрокаТЗ.ИмяКолонки = "JeType";
	
	// Journal
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Journal";
	СтрокаТЗ.ИмяКолонки = "Journal";
	
	// GltObjId
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "GltObjId";
	СтрокаТЗ.ИмяКолонки = "GltObjId";
	
	// УчетныйПериод
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "УчетныйПериод";
	СтрокаТЗ.ИмяКолонки = "FiscalYear";
	
	// Area
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Area";
	СтрокаТЗ.ИмяКолонки = "Area";
	
	// AreaDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AreaDesc";
	СтрокаТЗ.ИмяКолонки = "AreaDesc";
	
	// Geo
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Geo";
	СтрокаТЗ.ИмяКолонки = "Geo";
	
	// GeoDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "GeoDesc";
	СтрокаТЗ.ИмяКолонки = "GeoDesc";
	
	// SubGeo
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubGeo";
	СтрокаТЗ.ИмяКолонки = "SubGeo";
	
	// SubgeoDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubgeoDesc";
	СтрокаТЗ.ИмяКолонки = "SubgeoDesc";
	
	// Mgmtctry
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Mgmtctry";
	СтрокаТЗ.ИмяКолонки = "Mgmtctry";
	
	// MgmtctryDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "MgmtctryDesc";
	СтрокаТЗ.ИмяКолонки = "MgmtctryDesc";
	
	// BusSeg
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BusSeg";
	СтрокаТЗ.ИмяКолонки = "BusSeg";
	
	// SegDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SegDesc";
	СтрокаТЗ.ИмяКолонки = "SegDesc";
	
	// SubSeg
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubSeg";
	СтрокаТЗ.ИмяКолонки = "SubSeg";
	
	// SubsegDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubsegDesc";
	СтрокаТЗ.ИмяКолонки = "SubsegDesc";
	
	// SubSubSeg
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubSubSeg";
	СтрокаТЗ.ИмяКолонки = "SubSubSeg";
	
	// SubsubsegDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubsubsegDesc";
	СтрокаТЗ.ИмяКолонки = "SubsubsegDesc";
	
	// Company
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Company";
	СтрокаТЗ.ИмяКолонки = "Company";
	
	// Location
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Location";
	СтрокаТЗ.ИмяКолонки = "Location";
	
	// LocationDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LocationDesc";
	СтрокаТЗ.ИмяКолонки = "LocationDesc";
	
	// AccountUnit
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AccountUnit";
	СтрокаТЗ.ИмяКолонки = "AccountUnit";
	
	// AcctUnitDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AcctUnitDesc";
	СтрокаТЗ.ИмяКолонки = "AcctUnitDesc";
	
	//// MgmtNIS_BLSummaryAcct
	//СтрокаТЗ = СтруктураКолонок.Добавить();
	//СтрокаТЗ.ИмяПоля = "MgmtNIS_BLSummaryAcct";
	//СтрокаТЗ.ИмяКолонки = "MgmtNIS_BLSummaryAcct";
	
	// SummaryAcctDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SummaryAcctDesc";
	СтрокаТЗ.ИмяКолонки = "SummaryAcctDesc";
	
	// Account
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "Account";
	
	// SubAccount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SubAccount";
	СтрокаТЗ.ИмяКолонки = "SubAccount";
	
	// AccountDesc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AccountDesc";
	СтрокаТЗ.ИмяКолонки = "AccountDesc";
	
	// FiscalYear
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "FiscalYear";
	СтрокаТЗ.ИмяКолонки = "FiscalYear";
	
	// Date
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Date";
	СтрокаТЗ.ИмяКолонки = "Date";
	
	// AccountingPeriod
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AccountingPeriod";
	СтрокаТЗ.ИмяКолонки = "AccountingPeriod";
	
	// UpdateDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "UpdateDate";
	СтрокаТЗ.ИмяКолонки = "UpdateDate";
	
	// SeqTrnsNbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SeqTrnsNbr";
	СтрокаТЗ.ИмяКолонки = "SeqTrnsNbr";
	
	// PostingDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PostingDate";
	СтрокаТЗ.ИмяКолонки = "PostingDate";
	
	// Reference
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Reference";
	СтрокаТЗ.ИмяКолонки = "Reference";
	
	// Description
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Description";
	СтрокаТЗ.ИмяКолонки = "Description";
	
	// CurrencyCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CurrencyCode";
	СтрокаТЗ.ИмяКолонки = "CurrencyCode";
	
	// TranAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TranAmount";
	СтрокаТЗ.ИмяКолонки = "TranAmount";
	
	// BaseAmount
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "BaseAmount";
	СтрокаТЗ.ИмяКолонки = "BaseAmount";
	
	// OrigCompany
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "OrigCompany";
	СтрокаТЗ.ИмяКолонки = "OrigCompany";
	
	// Activity
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Activity";
	СтрокаТЗ.ИмяКолонки = "Activity";
	
	// SourceCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "SourceCode";
	СтрокаТЗ.ИмяКолонки = "SourceCode";
	
	// LineNbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LineNbr";
	СтрокаТЗ.ИмяКолонки = "LineNbr";
	
	// AutoRev
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AutoRev";
	СтрокаТЗ.ИмяКолонки = "AutoRev";
	
	// Operator
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Operator";
	СтрокаТЗ.ИмяКолонки = "Operator";
	
	// LegalFiscalFlag
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LegalFiscalFlag";
	СтрокаТЗ.ИмяКолонки = "LegalFiscalFlag";
	
	// Vendor
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Vendor";
	СтрокаТЗ.ИмяКолонки = "Vendor";
	
	// VendorVName
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "VendorVName";
	СтрокаТЗ.ИмяКолонки = "VendorVName";
	
	// ApInvoice
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ApInvoice";
	СтрокаТЗ.ИмяКолонки = "ApInvoice";
	
	// TransNbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TransNbr";
	СтрокаТЗ.ИмяКолонки = "TransNbr";
	
	// OrigOperatorId
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "OrigOperatorId";
	СтрокаТЗ.ИмяКолонки = "OrigOperatorId";
	
	// ProcessLevel
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ProcessLevel";
	СтрокаТЗ.ИмяКолонки = "ProcessLevel";
	
	// CashCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CashCode";
	СтрокаТЗ.ИмяКолонки = "CashCode";
	
	// PoNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PoNumber";
	СтрокаТЗ.ИмяКолонки = "PoNumber";
	
	// LineNbrIc
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "LineNbrIc";
	СтрокаТЗ.ИмяКолонки = "LineNbrIc";
	
	// PoCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "PoCode";
	СтрокаТЗ.ИмяКолонки = "PoCode";
	
	// Asset
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Asset";
	СтрокаТЗ.ИмяКолонки = "Asset";
	
	// AssetCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AssetCode";
	СтрокаТЗ.ИмяКолонки = "AssetCode";
	
	// AstSerialNbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AstSerialNbr";
	СтрокаТЗ.ИмяКолонки = "AstSerialNbr";
	
	// ItemDescription
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ItemDescription";
	СтрокаТЗ.ИмяКолонки = "ItemDescription";
	
	// CustomerNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerNumber";
	СтрокаТЗ.ИмяКолонки = "CustomerNumber";
	
	// CustomerName
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerName";
	СтрокаТЗ.ИмяКолонки = "CustomerName";
	
	// ArInvoice
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ArInvoice";
	СтрокаТЗ.ИмяКолонки = "ArInvoice";
	
	// TaxCode
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "TaxCode";
	СтрокаТЗ.ИмяКолонки = "TaxCode";
	
	// Item
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Item";
	СтрокаТЗ.ИмяКолонки = "Item";
	
	// DocumentNbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "DocumentNbr";
	СтрокаТЗ.ИмяКолонки = "DocumentNbr";
	
	// ContractNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ContractNumber";
	СтрокаТЗ.ИмяКолонки = "ContractNumber";
	
	// AktOfAcceptance
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AktOfAcceptance";
	СтрокаТЗ.ИмяКолонки = "AktOfAcceptance";
	
	// AktDate
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "AktDate";
	СтрокаТЗ.ИмяКолонки = "AktDate";
	
	// ApTransFormId
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ApTransFormId";
	СтрокаТЗ.ИмяКолонки = "ApTransFormId";
	
	// Urn
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Urn";
	СтрокаТЗ.ИмяКолонки = "Urn";
	
	// ArBatchNbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "ArBatchNbr";
	СтрокаТЗ.ИмяКолонки = "ArBatchNbr";
	
	// CompanyName
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyName";
	СтрокаТЗ.ИмяКолонки = "CompanyName";
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Объект.Проведен;
	УстановитьОтборыСписков();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтборыСписков()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSS, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSSНеобрабатываемые, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(СозданныеПроводкиDSSОшибки, "ДокументЗагрузки", Объект.Ссылка, , , Истина);
	
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
	Форма.Элементы.СозданныеПроводкиDSSОшибки.Обновить();
	
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
	
	//ЗначенияЗаполнения = Новый Структура("Идентификатор, ТипСоответствия, ТипОбъектаВнешнейСистемы");
	//ЗаполнитьЗначенияСвойств(ЗначенияЗаполнения, Элементы.ТаблицаКоллизий.ТекущиеДанные);
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	//ПараметрыФормы.Вставить("Период", Объект.Дата);
	//
	//ОткрытьФорму("РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Форма.ФормаЗаписи"
	//	, ПараметрыФормы, ЭтаФорма, , , , Новый ОписаниеОповещения("ТаблицаКоллизийВыборЗавершение", ЭтаФорма)
	//	, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
	Если ТаблицаКоллизийТекущиеДанные.Описание = "Not specified base element" Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("Ключ", ТаблицаКоллизийТекущиеДанные.ОбъектПриемника);
		
		Если ТаблицаКоллизийТекущиеДанные.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Segment") Тогда
			ОткрытьФорму("Справочник.Сегменты.Форма.ФормаЭлемента", ПараметрыФормы, ЭтаФорма, , , 
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
