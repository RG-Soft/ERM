﻿&НаКлиенте
Перем СоответствиеСинонимовИимен;

//////////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ВыбратьФайл();
	ЗаполнитьСписокЛистовЭкселяИНомераКолонок();
	ЗаполнитьПараметрыСтруктурыФайлаПоУмолчанию();
	Элементы.HOB.Видимость = Ложь;
	Элементы.Lawson_MI.Видимость = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПараметрыСтруктурыФайлаПоУмолчанию()
	
	FirstRowOfData = 2;
	LastRowOfData = 0;
	Элементы.Группа1.Видимость = Ложь;
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////////////
// ВЫБОР ФАЙЛА

&НаКлиенте
Процедура FullPathНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ВыбратьФайл();
	ЗаполнитьСписокЛистовЭкселяИНомераКолонок();
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьФайл()
	
	ДиалогВыбораФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогВыбораФайла.Фильтр						= "Files xlsx (*.xlsx)|*.xlsx|Files xls (*.xls)|*.xls";
	ДиалогВыбораФайла.ПроверятьСуществованиеФайла	= Истина;
	
	Если ДиалогВыбораФайла.Выбрать() Тогда
		
		FullPath = ДиалогВыбораФайла.ПолноеИмяФайла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокЛистовЭкселяИНомераКолонок()
	
	Sheet = "";
	СписокЛистов = Новый Массив;
	Если ЗначениеЗаполнено(FullPath) Тогда
		Connection = Новый COMОбъект("ADODB.Connection");
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + FullPath + ";Extended Properties=""Excel 12.0;HDR=No;IMEX=1""";	
		Попытка 
			Connection.Open(СтрокаПодключения);	
		Исключение
			Попытка
				СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + FullPath + ";Extended Properties=""Excel 8.0;HDR=No;IMEX=1""";
				Connection.Open(СтрокаПодключения);
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
		КонецПопытки;
		rs = Новый COMObject("ADODB.RecordSet");
		rs.ActiveConnection = Connection;
		rs = Connection.OpenSchema(20);
		Пока rs.EOF() = 0 Цикл
			Если rs.Fields("TABLE_NAME").Value <> "_xlnm#_FilterDatabase" Тогда
				СписокЛистов.Добавить(rs.Fields("TABLE_NAME").Value);
			КонецЕсли;
			rs.MoveNext();
		КонецЦикла;
		rs.Close();
		Если СписокЛистов.Количество()>0 Тогда
			Sheet = СписокЛистов[0];
			sqlString = "Select top 1 * from [" + Sheet + "]";
			rs.Open(sqlString);
			ЗаполнитьНомераКолонок(rs);
			rs.Close();
		Конецесли;
		Connection.Close();
	КонецЕсли;
	Элементы.Sheet.СписокВыбора.ЗагрузитьЗначения(СписокЛистов);
	Если СписокЛистов.Количество() = 1 Или СписокЛистов.Количество() = 0 Тогда
		Элементы.Sheet.КнопкаСпискаВыбора = Ложь;
	Иначе
		Элементы.Sheet.КнопкаСпискаВыбора = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура SheetПриИзменении(Элемент)
	
	СписокЛистов = Новый Массив;
	Если ЗначениеЗаполнено(FullPath) Тогда
		Connection = Новый COMОбъект("ADODB.Connection");
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + FullPath + ";Extended Properties=""Excel 12.0;HDR=No;IMEX=1""";	
		Попытка 
			Connection.Open(СтрокаПодключения);	
		Исключение
			Попытка
				СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + FullPath + ";Extended Properties=""Excel 8.0;HDR=No;IMEX=1""";
				Connection.Open(СтрокаПодключения);
			Исключение
				Сообщить(ОписаниеОшибки());
			КонецПопытки;
		КонецПопытки;
		rs = Новый COMObject("ADODB.RecordSet");
		rs.ActiveConnection = Connection;
		sqlString = "select top 1 * from [" + Sheet + "]";
		rs.Open(sqlString);
		ЗаполнитьНомераКолонок(rs);
		rs.Close();
		Connection.Close();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьНомераКолонок(rs)
	
	Если rs.EOF <> 0 Тогда
		Возврат;
	КонецЕсли;
	
	Для ТекИндекс = 0 По rs.Fields.Count - 1 Цикл
		
		ИмяРеквизита = Неопределено;
		ИмяКолонки = СокрЛП(rs.Fields(ТекИндекс).Value);
		
		Для Каждого КлючИЗначение из СоответствиеСинонимовИимен Цикл 
			Если КлючИЗначение.Значение = ИмяКолонки Тогда 
				ИмяРеквизита = КлючИЗначение.Ключ;
				Прервать;
			КонецЕсли;  
		КонецЦикла;
		
		Если ИмяРеквизита <> Неопределено Тогда
			ЭтотОбъект[ИмяРеквизита] = ТекИндекс + 1;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////////////////
// ЗАГРУЗКА

&НаКлиенте
Процедура Load(Команда)
	ТаблицаДанных.Очистить();	
	Если НЕ ЗначениеЗаполнено(FullPath) Тогда
		
		ВыбратьФайл();
		
		Если НЕ ЗначениеЗаполнено(FullPath) Тогда
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to select file!",
			, "Объект", "FullPath");
			Возврат;
			
		КонецЕсли;
		
	КонецЕсли;
	
	//Если НЕ ФайлДоступенДляЗагрузки(FullPath) Тогда
	//	Возврат;
	//КонецЕсли;
	
	Если Не ВсеПоляУказаны() Тогда 
		Возврат;
	КонецЕсли;
	
	Отказ = Ложь;
	
	
	ЗаполнитьТаблицуДанныхИзФайлаXLS(Отказ, FullPath);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ (Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") ИЛИ Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.Lawson") ИЛИ Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.HOBs")) Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Need to choose a value OracleMI, Lawson or HOBs in the Source",
		, "Объект", "Source");
		Возврат;
		
	КонецЕсли;
	
	Состояние("Loading data...");
	ЗаполнитьПолучателей();
	
КонецПроцедуры

&НаКлиенте
Функция ВсеПоляУказаны()
	
	ВсеПоляУказаны = Истина;
	
	Если Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") ИЛИ Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.Lawson") Тогда
		Если ColumnAUCode = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn 'AU Code'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		Если Column1Level = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn '1 Level'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		Если Column2Level = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn '2 Level'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		Если Column3Level = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn '3 Level'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		Если Column4Level = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn '4 Level'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		//Если Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") Тогда
		//	Если ColumnClient = 0 Тогда
		//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		//		"Need to specify the сolumn 'Client'!");
		//		ВсеПоляУказаны = Ложь;
		//	КонецЕсли;
		//	
		//	Если ColumnCode = 0 Тогда
		//		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		//		"Need to specify the сolumn 'Code'!");
		//		ВсеПоляУказаны = Ложь;
		//	КонецЕсли;
		//КонецЕсли;
		
	ИначеЕсли Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.HOBs") Тогда
		
		Если ColumnLevels = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn 'Levels'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		Если ColumnCompany = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn 'Company'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		Если ColumnLocations = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn 'Locations'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
		Если ColumnMail = 0 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Need to specify the сolumn 'Mail'!");
			ВсеПоляУказаны = Ложь;
		КонецЕсли;
		
	КонецЕсли;
	Возврат ВсеПоляУказаны;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьТаблицуДанныхИзФайлаXLS(Отказ, ПолноеИмяXLSФайла)
	
	// Открываем файл
	Connection = Новый COMОбъект("ADODB.Connection");
	СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + FullPath + ";Extended Properties=""Excel 12.0;HDR=No;IMEX=1""";	
	Попытка 
		Connection.Open(СтрокаПодключения);	
	Исключение
		// если подключение не удалось, то пытаемся подключиться к файлу через Microsoft.Jet.OLEDB.4.0
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + FullPath + ";Extended Properties=""Excel 8.0;HDR=No;IMEX=1""";
			Connection.Open(СтрокаПодключения);
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецПопытки;
	rs = Новый COMObject("ADODB.RecordSet");
	rs.ActiveConnection = Connection;
	rs = Connection.OpenSchema(20);
	//rs.MoveFirst(); // Станем на 1 закладку
	sqlString = "select * from [" + Sheet + "]";
	rs.Close();
	rs.Open(sqlString);
	
	rs.MoveFirst();
	
	// пропуск заголока
	rs.Move(FirstRowOfData - 1);
	
	АвтоОпределениеКонца = LastRowOfData = 0;
	
	ТекAU = Неопределено;
	ТекClient = Неопределено;
	ТекCode = Неопределено;
	
	//запоняем таб.документ пока не кончатся строки
	Пока rs.EOF = 0 Цикл
		
		Если Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") ИЛИ Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.Lawson") Тогда
			
			НовыйAU = СтрЗаменить(СокрЛП(rs.Fields(ColumnAUCode - 1).Value),Символы.НПП, "");
			НовыйAU = СтрЗаменить(НовыйAU, "," , "");
			
			Если ЗначениеЗаполнено(НовыйAU) И НовыйAU <> ТекAU Тогда 
				ТекAU = НовыйAU;
			КонецЕсли;
			
			Если ColumnClient <> 0 Тогда 
				НовыйClient = СокрЛП(rs.Fields(ColumnClient - 1).Value);
				Если СокрЛП(rs.Fields(Column1Level - 1).Value) = "" И СокрЛП(rs.Fields(Column2Level - 1).Value) = "" И СокрЛП(rs.Fields(Column3Level - 1).Value) = "" И СокрЛП(rs.Fields(Column4Level - 1).Value) = "" Тогда
					ТекClient = "";
				КонецЕсли;
				Если ЗначениеЗаполнено(НовыйClient) И НовыйClient <> ТекClient И НовыйClient <> "Client" Тогда
					ТекClient = НовыйClient;
				КонецЕсли;
			КонецЕсли;
			
			Если ColumnCode <> 0 Тогда
				НовыйCode = СокрЛП(rs.Fields(ColumnCode - 1).Value);
				Если СокрЛП(rs.Fields(Column1Level - 1).Value) = "" И СокрЛП(rs.Fields(Column2Level - 1).Value) = "" И СокрЛП(rs.Fields(Column3Level - 1).Value) = "" И СокрЛП(rs.Fields(Column4Level - 1).Value) = "" Тогда
					ТекCode = "";
					НовыйCode = "";
				КонецЕсли;
				Если ЗначениеЗаполнено(НовыйCode) И НовыйCode <> ТекCode И НовыйCode <> "Code" Тогда
					ТекCode = НовыйCode;
				КонецЕсли;
			КонецЕсли;
			
			Level1 = СокрЛП(rs.Fields(Column1Level - 1).Value);
			Level2 = СокрЛП(rs.Fields(Column2Level - 1).Value);
			Level3 = СокрЛП(rs.Fields(Column3Level - 1).Value);
			
			ЕстьДубльУровень2 = 0;
			ЕстьДубльУровень2 = СтрЧислоВхождений(Level2, "/");
			Если ЕстьДубльУровень2 = 1 Тогда
				Строка = СтрЗаменить(Level2, "/", Символы.ПС);
				Level2 = СокрЛП(СтрПолучитьСтроку(Строка,1));
				Level2Дубль = СокрЛП(СтрПолучитьСтроку(Строка,2));
			КонецЕсли;
			
			ЕстьДубль = 0;
			ЕстьДубль = СтрЧислоВхождений(Level3, "/");
			Если ЕстьДубль = 1 Тогда
				Строка = СтрЗаменить(Level3, "/", Символы.ПС);
				Level3 = СокрЛП(СтрПолучитьСтроку(Строка,1));
				Level3Дубль = СокрЛП(СтрПолучитьСтроку(Строка,2));
			КонецЕсли;
			Level4 = СокрЛП(rs.Fields(Column4Level - 1).Value);
			
			Если ColumnClient <> 0 Тогда
				Client = СокрЛП(rs.Fields(ColumnClient - 1).Value);
			КонецЕсли;
			
			Если ColumnCode <> 0 Тогда
				Code = СокрЛП(rs.Fields(ColumnCode - 1).Value);
			КонецЕсли;
			
			Если СтрНайти(Level1, "@") > 0
				ИЛИ СтрНайти(Level2, "@") > 0
				ИЛИ СтрНайти(Level3, "@") > 0
				ИЛИ СтрНайти(Level4, "@") > 0 Тогда
				
				СтрокаТЗ = ТаблицаДанных.Добавить();
				СтрокаТЗ.AU = ТекAU;
				СтрокаТЗ.Level1 = Level1;
				СтрокаТЗ.Level2 = Level2;
				СтрокаТЗ.Level3 = Level3;
				СтрокаТЗ.Level4 = Level4;
				
				Если ColumnClient <> 0 Тогда
					СтрокаТЗ.Client = ТекClient;
				КонецЕсли;
				
				Если ColumnCode <> 0 Тогда
					СтрокаТЗ.Code = ТекCode;
				КонецЕсли;
				
				Если ЕстьДубльУровень2 = 1 Тогда
					СтрокаТЗ = ТаблицаДанных.Добавить();
					СтрокаТЗ.AU = ТекAU;
					СтрокаТЗ.Level2 = Level2Дубль;
					
					Если ColumnClient <> 0 Тогда
						СтрокаТЗ.Client = ТекClient;
					КонецЕсли;
					
					Если ColumnCode <> 0 Тогда
						СтрокаТЗ.Code = ТекCode;
					КонецЕсли;
				КонецЕсли;
				
				Если ЕстьДубль = 1 Тогда
					СтрокаТЗ = ТаблицаДанных.Добавить();
					СтрокаТЗ.AU = ТекAU;
					СтрокаТЗ.Level3 = Level3Дубль;
					
					Если ColumnClient <> 0 Тогда
						СтрокаТЗ.Client = ТекClient;
					КонецЕсли;
					
					Если ColumnCode <> 0 Тогда
						СтрокаТЗ.Code = ТекCode;
					КонецЕсли;
				КонецЕсли;
				
			КонецЕсли;
			
		ИначеЕсли Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.HOBs") Тогда
			Mail = СокрЛП(rs.Fields(ColumnMail - 1).Value);
			Если СтрНайти(Mail, "@") > 0 Тогда
				СтрокаТЗ = ТаблицаДанных.Добавить();
				СтрокаТЗ.Levels =  СокрЛП(rs.Fields(ColumnLevels - 1).Value);
				СтрокаТЗ.Company = СокрЛП(rs.Fields(ColumnCompany - 1).Value);
				СтрокаТЗ.Locations = СокрЛП(rs.Fields(ColumnLocations - 1).Value);
				СтрокаТЗ.Mail = Mail;
			КонецЕсли;
		КонецЕсли;
		rs.MoveNext();
		
	КонецЦикла;
	
	rs.Close();
	Connection.Close();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПолучателей() 
	
	ЕстьОшибки = Ложь;
	
	НеНашелАдреса = Новый ТаблицаЗначений;
	НеНашелАдреса.Колонки.Добавить("Адрес");	
	
	Level1 = Справочники.EscalationLevels.Level1;
	Если Не ЗначениеЗаполнено(Level1) Тогда
		Сообщить("Не найден уровень уведомлений с кодом Level 1!");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Level2 = Справочники.EscalationLevels.Level2;
	Если Не ЗначениеЗаполнено(Level2) Тогда
		Сообщить("Не найден уровень уведомлений с кодом Level 2!");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Level3 = Справочники.EscalationLevels.Level3;
	Если Не ЗначениеЗаполнено(Level3) Тогда
		Сообщить("Не найден уровень уведомлений с кодом Level 3!");
		ЕстьОшибки = Истина;
	КонецЕсли;
	
	Level4 = Справочники.EscalationLevels.Level4;
	Если Не ЗначениеЗаполнено(Level4) Тогда
		Сообщить("Не найден уровень уведомлений с кодом Level 4!");
		ЕстьОшибки = Истина;
	КонецЕсли;
	НачатьТранзакцию();
	ТЗ = ТаблицаДанных.Выгрузить();
	Если Source = Перечисления.ТипыСоответствий.HOBs Тогда
		
		Companys = ТЗ.Скопировать();
		Companys.Свернуть("Company",);
		СтруктураОтбора = Новый Структура("Company");
		
		Для Каждого Организация ИЗ Companys Цикл
			
			Компания = Организация.Company;
			Если Не ЗначениеЗаполнено(Компания) Тогда
				Продолжить
			КонецЕсли;
			
			Запрос = Новый Запрос;
			Запрос.Текст = "ВЫБРАТЬ
			|	Организации.Ссылка
			|ИЗ
			|	Справочник.Организации КАК Организации
			|ГДЕ
			|	Организации.Код = &Код
			|	И НЕ Организации.ПометкаУдаления
			|	И Организации.Source = &Source";
			
			Запрос.УстановитьПараметр("Код", Число(Компания));
			Запрос.УстановитьПараметр("Source", Source);
			Результат = Запрос.Выполнить();
			Если Результат.Пустой() Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Failed to find Company - " + Компания);
				ЕстьОшибки = Истина;
				Продолжить
			Иначе
				Выборка = Результат.Выбрать();
				Выборка.Следующий();
				ОрганизацияСсылка = Выборка.Ссылка;
			КонецЕсли;
			
			СтруктураОтбора.Company = Компания;
			
			ТаблицаCompany = ТЗ.Скопировать(СтруктураОтбора);
			
			Locations = ТаблицаCompany.Скопировать();
			Locations.Свернуть("Locations");
			СтруктураОтбораПодразделение = Новый Структура("Locations");
			Для Каждого Подразделение ИЗ Locations Цикл
				
				Location = Подразделение.Locations;
				СтруктураОтбораПодразделение.Locations = Location;
				ТЗ_Locations = ТаблицаCompany.Скопировать(СтруктураОтбораПодразделение);
				
				НаборЗаписей = РегистрыСведений.ПолучателиУведомленийUnbilled.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Source.Установить(Source);
				НаборЗаписей.Отбор.Идентификатор1.Установить(ОрганизацияСсылка);
				
				Если НЕ ЗначениеЗаполнено(Location) Тогда
					НаборЗаписей.Отбор.Идентификатор2.Установить("");
				Иначе
					НаборЗаписей.Отбор.Идентификатор2.Установить(Location);
				КонецЕсли;
				НаборЗаписей.Записать();
				
				Для Каждого ЭлементПодразделение ИЗ ТЗ_Locations Цикл
					
					Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(ЭлементПодразделение.Mail) Тогда 
						Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", ЭлементПодразделение.Mail);
						Если ЗначениеЗаполнено(Получатель) Тогда
							Запись = НаборЗаписей.Добавить();
							Запись.Source = Source;
							Запись.Идентификатор1 = ОрганизацияСсылка;
							Запись.Идентификатор2 = ЭлементПодразделение.Locations;
							Запись.Уровень = ОпределитьУровень(ЭлементПодразделение.Levels, Level1, Level2, Level3, Level4);
							Запись.Получатель = Получатель;
						Иначе
							Адреса = НеНашелАдреса.Добавить();
							Адреса.Адрес = ЭлементПодразделение.Mail;
						КонецЕсли;
					Иначе
						ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
						"Некорректный e-mail " + ЭлементПодразделение.Mail,
						, , , ЕстьОшибки);
					КонецЕсли;
					
					
				КонецЦикла;
				
			ОшибкиПриПроверке = ПроверитьНабор(НаборЗаписей, Компания);
			Если НЕ ОшибкиПриПроверке Тогда
				Попытка
					НаборЗаписей.Записать();
				Исключение
					Сообщить("Failed to save ""Получатели "" for Company <" + Компания + ">:" + ОписаниеОшибки());
					ЕстьОшибки = Истина;
				КонецПопытки;
			Иначе
				ЕстьОшибки = Истина
			КонецЕсли;
				
			КонецЦикла;
			
			
		КонецЦикла;
		
		
		
	ИначеЕсли Source = Перечисления.ТипыСоответствий.OracleMI ИЛИ Source = Перечисления.ТипыСоответствий.Lawson Тогда
		
		//МассивAUs = ВыгрузитьКолонкуКоллекцииБезПустыхЗначенийИДублей(ТаблицаДанных, "AU");
		AUs_Cods = ТЗ.Скопировать();
		Если Source = Перечисления.ТипыСоответствий.Lawson Тогда 
			AUs_Cods.Свернуть("AU",);
		ИначеЕсли ColumnCode <> 0 Тогда
			AUs_Cods.Свернуть("AU, Code",);
		КонецЕсли;
		
		СтруктураОтбораAU = Новый Структура("AU");
		Если ColumnCode <> 0 Тогда
			СтруктураОтбораAU.Вставить("Code");
		КонецЕсли;
		
		
		Для Каждого Строка из AUs_Cods Цикл
			
			AUCode = Строка.AU;
			Если ColumnCode <> 0 Тогда
				ClientCode = Строка.Code;
			КонецЕсли;
			
			AU = Неопределено;
			
			СтруктураОтбораAU.AU = AUCode;
			Если ColumnCode <> 0 Тогда
				СтруктураОтбораAU.Code = ClientCode;
			КонецЕсли;
			
			ТаблицаAU = ТЗ.Скопировать(СтруктураОтбораAU);
			
			МассивEmailsLevel1 = ВыгрузитьКолонкуКоллекцииБезПустыхЗначенийИДублей(ТаблицаAU, "Level1");
			МассивLevel2 = ВыгрузитьКолонкуКоллекцииБезПустыхЗначенийИДублей(ТаблицаAU, "Level2");
			МассивEmailsLevel2 = ОбщегоНазначенияКлиентСервер.СократитьМассив(МассивLevel2, МассивEmailsLevel1);
			МассивLevel3 = ВыгрузитьКолонкуКоллекцииБезПустыхЗначенийИДублей(ТаблицаAU, "Level3");
			МассивEmailsLevel3 = ОбщегоНазначенияКлиентСервер.СократитьМассив(МассивLevel3, МассивLevel2);
			МассивLevel4 = ВыгрузитьКолонкуКоллекцииБезПустыхЗначенийИДублей(ТаблицаAU, "Level4");
			МассивEmailsLevel4 = ОбщегоНазначенияКлиентСервер.СократитьМассив(МассивLevel4, МассивLevel3);
			
			Если Source = Перечисления.ТипыСоответствий.Lawson Тогда
				AUCodeДляПоиска = AUCode;
				Пока СтрДлина(AUCodeДляПоиска) < 7 Цикл 
					AUCodeДляПоиска = "0" + AUCodeДляПоиска;
				КонецЦикла;
				
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	КостЦентры.Ссылка КАК AU
				|ИЗ
				|	Справочник.КостЦентры КАК КостЦентры
				|ГДЕ
				|	КостЦентры.Код = &Код
				|	И НЕ КостЦентры.ПометкаУдаления";
				
				Запрос.УстановитьПараметр("Код", AUCodeДляПоиска);
			ИначеЕсли Source = Перечисления.ТипыСоответствий.OracleMI Тогда
				AUCodeДляПоиска = AUCode;
				Запрос = Новый Запрос;
				Запрос.Текст = "ВЫБРАТЬ
				|	ПодразделенияОрганизаций.Ссылка КАК AU
				|ИЗ
				|	Справочник.ПодразделенияОрганизаций КАК ПодразделенияОрганизаций
				|ГДЕ
				|	ПодразделенияОрганизаций.Код = &Код
				|	И НЕ ПодразделенияОрганизаций.ПометкаУдаления";
				Запрос.УстановитьПараметр("Код", AUCodeДляПоиска);
			КонецЕсли;
			Выборка = Запрос.Выполнить().Выбрать();
			Пока Выборка.Следующий() Цикл
				
				AU = Выборка.AU;
				
				
				Если ColumnClient <> 0 И ТаблицаAU[0].Client <> "" Тогда
					Клиент =ТаблицаAU[0].Client;
				Иначе
					Клиент = "";
				КонецЕсли;
				Если ColumnCode <> 0 И ТаблицаAU[0].Code <> "" Тогда
					Code =ТаблицаAU[0].Code;
				Иначе
					Code = "";
				КонецЕсли;
				
				Если ЗначениеЗаполнено(Code) Тогда
					Запрос = Новый Запрос;
					Запрос.Текст = "ВЫБРАТЬ
					|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.ОбъектПриемника
					|ИЗ
					|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
					|			&Дата,
					|			Идентификатор = &Идентификатор
					|				И ТипСоответствия = &ТипСоответствия
					|				И ТипОбъектаВнешнейСистемы = &ТипОбъектаВнешнейСистемы) КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних";
					Запрос.УстановитьПараметр("Идентификатор", Code);
					Запрос.УстановитьПараметр("ТипСоответствия", Перечисления.ТипыСоответствий.OracleMI);
					Запрос.УстановитьПараметр("ТипОбъектаВнешнейСистемы", Перечисления.ТипыОбъектовВнешнихСистем.Client);
					Запрос.УстановитьПараметр("Дата", ТекущаяДата());
					Результат = Запрос.Выполнить();
					Если НЕ Результат.Пустой() Тогда
						Выборка = Результат.Выбрать();
						Выборка.Следующий();
						MappingClient = Выборка.ОбъектПриемника;
					Иначе
						MappingClient = "";
					КонецЕсли;
				КонецЕсли;
				
				НаборЗаписей = РегистрыСведений.ПолучателиУведомленийUnbilled.СоздатьНаборЗаписей();
				НаборЗаписей.Отбор.Source.Установить(Source);
				Если ЗначениеЗаполнено(MappingClient) И Source = Перечисления.ТипыСоответствий.OracleMI Тогда
					НаборЗаписей.Отбор.Идентификатор2.Установить(MappingClient);
				ИначеЕсли НЕ ЗначениеЗаполнено(MappingClient) И Source = Перечисления.ТипыСоответствий.OracleMI Тогда
					НаборЗаписей.Отбор.Идентификатор2.Установить(Справочники.Контрагенты.ПустаяСсылка());
				ИначеЕсли Source = Перечисления.ТипыСоответствий.Lawson Тогда
					НаборЗаписей.Отбор.Идентификатор2.Установить(Неопределено);
				КонецЕсли;
				НаборЗаписей.Отбор.Идентификатор1.Установить(AU);
				НаборЗаписей.Записать();
				
				// Level 1
				Если ЗначениеЗаполнено(Level1) Тогда 
					
					Для Каждого EmailLevel1 из МассивEmailsLevel1 Цикл
						
						Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(EmailLevel1) Тогда 
							Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", EmailLevel1);
							Если ЗначениеЗаполнено(Получатель) Тогда
								Запись = НаборЗаписей.Добавить();
								Запись.Source = Source;
								Запись.Идентификатор1 = AU;
								Если Source = Перечисления.ТипыСоответствий.OracleMI И ЗначениеЗаполнено(MappingClient) Тогда
									Запись.Идентификатор2 = MappingClient;
								ИначеЕсли НЕ ЗначениеЗаполнено(MappingClient) И Source = Перечисления.ТипыСоответствий.OracleMI Тогда
									Запись.Идентификатор2 = Справочники.Контрагенты.ПустаяСсылка();
								ИначеЕсли Source = Перечисления.ТипыСоответствий.Lawson Тогда
									Запись.Идентификатор2 = Неопределено;
								КонецЕсли;
								Запись.Уровень = Level1;
								Запись.Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", EmailLevel1);
							Иначе
								Адреса = НеНашелАдреса.Добавить();
								Адреса.Адрес = EmailLevel1;
							КонецЕсли;
						Иначе
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							"Некорректный e-mail '" + EmailLevel1 + "' для AU " + AU + " Level 1!",
							, , , ЕстьОшибки);
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
				// Level 2
				Если ЗначениеЗаполнено(Level2) Тогда 
					
					Для Каждого EmailLevel2 из МассивEmailsLevel2 Цикл
						
						Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(EmailLevel2) Тогда 
							Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", EmailLevel2);
							Если ЗначениеЗаполнено(Получатель) Тогда
								Запись = НаборЗаписей.Добавить();
								Запись.Source = Source;
								Запись.Идентификатор1 = AU;
								Если Source = Перечисления.ТипыСоответствий.OracleMI И ЗначениеЗаполнено(MappingClient) Тогда
									Запись.Идентификатор2 = MappingClient;
								ИначеЕсли НЕ ЗначениеЗаполнено(MappingClient) И Source = Перечисления.ТипыСоответствий.OracleMI Тогда
									Запись.Идентификатор2 = Справочники.Контрагенты.ПустаяСсылка();
								ИначеЕсли Source = Перечисления.ТипыСоответствий.Lawson Тогда
									Запись.Идентификатор2 = Неопределено;
								КонецЕсли;
								Запись.Уровень = Level2;
								Запись.Получатель = Получатель;
							Иначе
								Адреса = НеНашелАдреса.Добавить();
								Адреса.Адрес = EmailLevel2;
							КонецЕсли;
						Иначе
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							"Некорректный e-mail '" + EmailLevel2 + "' для AU " + AU + " Level 2!",
							, , , ЕстьОшибки);
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
				// Level 3
				Если ЗначениеЗаполнено(Level3) Тогда 
					
					Для Каждого EmailLevel3 из МассивEmailsLevel3 Цикл
						
						Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(EmailLevel3) Тогда 
							Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", EmailLevel3);
							Если ЗначениеЗаполнено(Получатель) Тогда
								Запись = НаборЗаписей.Добавить();
								Запись.Source = Source;
								Запись.Идентификатор1 = AU;
								Если Source = Перечисления.ТипыСоответствий.OracleMI И ЗначениеЗаполнено(MappingClient) Тогда
									Запись.Идентификатор2 = MappingClient;
								ИначеЕсли НЕ ЗначениеЗаполнено(MappingClient) И Source = Перечисления.ТипыСоответствий.OracleMI Тогда
									Запись.Идентификатор2 = Справочники.Контрагенты.ПустаяСсылка();
								ИначеЕсли Source = Перечисления.ТипыСоответствий.Lawson Тогда
									Запись.Идентификатор2 = Неопределено;
								КонецЕсли;
								Запись.Уровень = Level3;
								Запись.Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", EmailLevel3);
							Иначе
								Адреса = НеНашелАдреса.Добавить();
								Адреса.Адрес = EmailLevel3;
							КонецЕсли;
						Иначе						
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							"Некорректный e-mail '" + EmailLevel3 + "' для AU " + AU + " Level 3!",
							, , , ЕстьОшибки);
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
				// Level 4
				Если ЗначениеЗаполнено(Level4) Тогда 
					
					Для Каждого EmailLevel4 из МассивEmailsLevel4 Цикл
						
						Если ОбщегоНазначенияКлиентСервер.АдресЭлектроннойПочтыСоответствуетТребованиям(EmailLevel4) Тогда 
							Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", EmailLevel4);
							Если ЗначениеЗаполнено(Получатель) Тогда
								Запись = НаборЗаписей.Добавить();
								Запись.Source = Source;
								Запись.Идентификатор1 = AU;
								Если Source = Перечисления.ТипыСоответствий.OracleMI И ЗначениеЗаполнено(MappingClient) Тогда
									Запись.Идентификатор2 = MappingClient;
								ИначеЕсли НЕ ЗначениеЗаполнено(MappingClient) И Source = Перечисления.ТипыСоответствий.OracleMI Тогда
									Запись.Идентификатор2 = Справочники.Контрагенты.ПустаяСсылка();
								ИначеЕсли Source = Перечисления.ТипыСоответствий.Lawson Тогда
									Запись.Идентификатор2 = Неопределено;
								КонецЕсли;
								Запись.Уровень = Level4;
								Запись.Получатель = Справочники.LDAPUsers.НайтиПоРеквизиту("Mail", EmailLevel4);
							Иначе
								Адреса = НеНашелАдреса.Добавить();
								Адреса.Адрес = EmailLevel4;
							КонецЕсли;
						Иначе
							ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
							"Некорректный e-mail '" + EmailLevel4 + "' для AU " + AU + " Level 4!",
							, , , ЕстьОшибки);
						КонецЕсли;
						
					КонецЦикла;
					
				КонецЕсли;
				
				ОшибкиПриПроверке = ПроверитьНабор(НаборЗаписей, AU);
				Если НЕ ОшибкиПриПроверке Тогда
					Попытка
						НаборЗаписей.Записать();
					Исключение
						Сообщить("Failed to save ""Получатели "" for AU <" + AUCode + ">:" + ОписаниеОшибки());
						ЕстьОшибки = Истина;
					КонецПопытки;
				Иначе
					ЕстьОшибки = Истина
				КонецЕсли;
				
			КонецЦикла;
			
			Если Не ЗначениеЗаполнено(AU) Тогда
				Сообщить("Failed to find AU by code <" + СокрЛП(AUCodeДляПоиска) + ">.");
				ЕстьОшибки = Истина;
			иначе
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Если НеНашелАдреса.Количество() > 0 Тогда
		ЕстьОшибки = Истина;
		НеНашелАдреса.Свернуть("Адрес");
		Для каждого Элемент  Из НеНашелАдреса Цикл 
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Failed to find e-mail - " + Элемент.Адрес);
		КонецЦикла; 
	КонецЕсли;
	
	Если ЕстьОшибки Тогда
		ОтменитьТранзакцию();
		Сообщить("File was not loaded.");
	Иначе
		ЗафиксироватьТранзакцию();
		Сообщить("File was successfully loaded.");
	КонецЕсли;
	
КонецПроцедуры

Функция ВыгрузитьКолонкуКоллекцииБезПустыхЗначенийИДублей(Коллекция, ИмяКолонки)
	
	МассивДанных = Новый Массив;
	Для Каждого СтрокаКоллекции Из Коллекция Цикл
		
		Если ЗначениеЗаполнено(СтрокаКоллекции[ИмяКолонки])
			И МассивДанных.Найти(СтрокаКоллекции[ИмяКолонки]) = Неопределено Тогда 
			МассивДанных.Добавить(СтрокаКоллекции[ИмяКолонки]);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат МассивДанных;
	
КонецФункции

Функция ФайлДоступенДляЗагрузки(Знач ПолноеИмя, ИмяЭлементаУправления = "")
	
	ПолноеИмя = СокрЛП(ПолноеИмя);
	Если НЕ ЗначениеЗаполнено(ПолноеИмя) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Выберите файл!",
		, ИмяЭлементаУправления);
		Возврат Ложь;
	КонецЕсли; 
	
	Файл = Новый Файл(ПолноеИмя);
	Если НЕ Файл.Существует() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Файл """ + ПолноеИмя + """ не существует!",
		, ИмяЭлементаУправления);
		Возврат Ложь;
	КонецЕсли; 
	
	Если НЕ Файл.ЭтоФайл() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
		"Файл """ + ПолноеИмя + """ не является файлом!",
		, ИмяЭлементаУправления);
		Возврат Ложь;
	КонецЕсли; 
	
	Возврат Истина;
	
КонецФункции

Функция ВычестьМассивы(ПервыйМассив, ВторойМассив) 
	
	НовыйМассив = Новый Массив;
	Для Каждого Элемент Из ПервыйМассив Цикл
		
		Если ВторойМассив.Найти(Элемент) = Неопределено Тогда
			НовыйМассив.Добавить(Элемент);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат НовыйМассив;
	
КонецФункции

&НаКлиенте
Процедура SourceПриИзменении(Элемент)
	Если Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.HOBs") Тогда
		Элементы.HOB.Видимость = Истина;
		Элементы.Lawson_MI.Видимость = Ложь;
	Иначе
		Элементы.HOB.Видимость = Ложь;
		Элементы.Lawson_MI.Видимость = Истина;
		Если Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") Тогда
			Элементы.Группа1.Видимость = Истина;
		Иначе
			Элементы.Группа1.Видимость = Ложь;
			ColumnClient = 0;
			ColumnCode = 0;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ПроверитьНабор(Набор, AU)
	
	Ошибка = Ложь;
	
	Для каждого ЗаписьНабора Из Набор Цикл
		ЭтоResponsibleAR = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ЗаписьНабора.Получатель, "ResponsibleAR");
		Если ЭтоResponsibleAR И ЗаписьНабора.Уровень <> Справочники.EscalationLevels.Level1 Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Responsible AR is only available for Level 1 - " + AU);
			Ошибка = Истина;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Ошибка Тогда 
		Возврат Истина;
	Иначе
		Возврат Ложь
	КонецЕсли;
	
КонецФУнкции

Функция ОпределитьУровень(Уровень, Level1, Level2, Level3, Level4)
	
	Если СтрЧислоВхождений(Уровень,"1") = 1 Тогда
		Возврат Level1
	ИначеЕсли СтрЧислоВхождений(Уровень,"2") = 1 Тогда
		Возврат Level2
	ИначеЕсли СтрЧислоВхождений(Уровень,"3") = 1 Тогда
		Возврат Level3
	ИначеЕсли СтрЧислоВхождений(Уровень,"4") = 1 Тогда
		Возврат Level4
	КонецЕсли;
	
КонецФункции

//MI и Lawson
СоответствиеСинонимовИимен = Новый Соответствие;
СоответствиеСинонимовИимен.Вставить("ColumnAUCode", "AU");
СоответствиеСинонимовИимен.Вставить("ColumnClient", "Client");
СоответствиеСинонимовИимен.Вставить("ColumnCode", "Code");
СоответствиеСинонимовИимен.Вставить("Column1Level", "1 level");
СоответствиеСинонимовИимен.Вставить("Column2Level", "2 level");
СоответствиеСинонимовИимен.Вставить("Column3Level", "3 level");
СоответствиеСинонимовИимен.Вставить("Column4Level", "4 level");

//HOBs
СоответствиеСинонимовИимен.Вставить("ColumnLevels", "Уровень");
СоответствиеСинонимовИимен.Вставить("ColumnCompany", "Организация");
СоответствиеСинонимовИимен.Вставить("ColumnLocations", "CREW");
СоответствиеСинонимовИимен.Вставить("ColumnMail", "E-Mail");


