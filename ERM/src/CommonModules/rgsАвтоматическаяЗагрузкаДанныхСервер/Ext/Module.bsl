﻿
Процедура ВыполнитьЗагрузкуДанныхOracleMI() Экспорт
	
	СтруктураНастроек = Новый Структура();
	ИнициализироватьСтруктуруНастроек(СтруктураНастроек);
	
	ПолучениеВыполнено = ВыполнитьПолучениеСообщения(СтруктураНастроек);
	
	Если Не ПолучениеВыполнено Тогда
		
		РГСофт.ЗарегистрироватьПочтовоеСообщение(Константы.ПолучателиСообщенийОбОшибкахЗагрузкиДанныхOracleMI.Получить(),
			"ERM: Oracle MI loading error", СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР, , ТипТекстаПочтовогоСообщения.ПростойТекст);
			
		ЗаписьЖурналаРегистрации("Oracle MI loading error", УровеньЖурналаРегистрации.Ошибка, , , СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР);
		
		Возврат;
		
	КонецЕсли;
	
	ЗагрузитьПолученныеДанные(СтруктураНастроек);
	
	ДействияПриОкончанииЗагрузки(СтруктураНастроек);
	
КонецПроцедуры

Процедура ИнициализироватьСтруктуруНастроек(СтруктураНастроек)
	
	СтруктураНастроек.Вставить("СтрокаСообщенияОбОшибке", "");
	СтруктураНастроек.Вставить("СтрокаСообщенияОбОшибкеЖР", "");
	СтруктураНастроек.Вставить("ИмяКаталогаОбменаИнформацией", ИмяКаталогаОбменаИнформацией());
	СтруктураНастроек.Вставить("ШаблонИмениФайлаСообщения", "OracleMITransactions*");
	СтруктураНастроек.Вставить("ИмяКаталогаСообщенияОбмена", КаталогВременныхФайлов() + "MI-" + Строка(Новый УникальныйИдентификатор()));
	СтруктураНастроек.Вставить("ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений", Истина);
	СтруктураНастроек.Вставить("СообщенияОшибок", Новый Соответствие);
	
	ИнициализацияСообщенийОшибок(СтруктураНастроек);
	
КонецПроцедуры

Процедура ИнициализацияСообщенийОшибок(СтруктураНастроек)
	
	СообщенияОшибок = СтруктураНастроек.СообщенияОшибок;
	СообщенияОшибок.Вставить(1, НСтр("ru = 'Ошибка подключения: Не указан каталог обмена информацией.'"));
	СообщенияОшибок.Вставить(2, НСтр("ru = 'Ошибка подключения: Каталог обмена информацией не существует.'"));
	
	СообщенияОшибок.Вставить(3, НСтр("ru = 'В каталоге обмена информацией не был обнаружен файл сообщения с данными.'"));
	СообщенияОшибок.Вставить(4, НСтр("ru = 'Ошибка при распаковке сжатого файла сообщения.'"));
	СообщенияОшибок.Вставить(5, НСтр("ru = 'Ошибка при сжатии файла сообщения обмена.'"));
	СообщенияОшибок.Вставить(6, НСтр("ru = 'Ошибка при создании временного каталога'"));
	СообщенияОшибок.Вставить(7, НСтр("ru = 'Архив не содержит файл сообщения обмена'"));
	
	СообщенияОшибок.Вставить(8, НСтр("ru = 'Ошибка записи файла в каталог обмена информацией. Проверьте права пользователя на доступ к каталогу.'"));
	СообщенияОшибок.Вставить(9, НСтр("ru = 'Ошибка удаления файла из каталога обмена информацией. Проверьте права пользователя на доступ к каталогу.'"));
	
	СообщенияОшибок.Вставить(10, НСтр("ru = 'Ошибка обработки файла'"));
	СообщенияОшибок.Вставить(11, НСтр("ru = 'Ошибка чтения данных из файла'"));
	
КонецПроцедуры

Функция ВыполнитьПолучениеСообщения(СтруктураНастроек)
	
	Попытка
		Результат = ПолучитьСообщение(СтруктураНастроек);
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСообщение(СтруктураНастроек)
	
	ИмяКаталогаОбменаИнформацией = СтруктураНастроек.ИмяКаталогаОбменаИнформацией;
	ШаблонИмениФайлаСообщения = СтруктураНастроек.ШаблонИмениФайлаСообщения;
	ИмяКаталогаСообщенияОбмена = СтруктураНастроек.ИмяКаталогаСообщенияОбмена;
	ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений = СтруктураНастроек.ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений;
	
	СоздатьКаталог(ИмяКаталогаСообщенияОбмена);
	
	ТаблицаФайловСообщенийОбмена = Новый ТаблицаЗначений;
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("Файл", Новый ОписаниеТипов("Файл"));
	ТаблицаФайловСообщенийОбмена.Колонки.Добавить("ВремяИзменения");
	
	МассивНайденныхФайлов = НайтиФайлы(ИмяКаталогаОбменаИнформацией, ШаблонИмениФайлаСообщения + ".*", Ложь);
	
	Для Каждого ТекущийФайл Из МассивНайденныхФайлов Цикл
		
		// Проверяем нужное расширение.
		Если ((ВРег(ТекущийФайл.Расширение) <> ".ZIP")
			И (ВРег(ТекущийФайл.Расширение) <> ".XSLB")) Тогда
			
			Продолжить;
			
		// Проверяем что это файл, а не каталог.
		ИначеЕсли НЕ ТекущийФайл.ЭтоФайл() Тогда
			
			Продолжить;
			
		// Проверяем ненулевой размер файла.
		ИначеЕсли (ТекущийФайл.Размер() = 0) Тогда
			
			Продолжить;
			
		КонецЕсли;
		
		// Файл является требуемым сообщением обмена; добавляем его в таблицу.
		СтрокаТаблицы = ТаблицаФайловСообщенийОбмена.Добавить();
		СтрокаТаблицы.Файл           = ТекущийФайл;
		СтрокаТаблицы.ВремяИзменения = ТекущийФайл.ПолучитьВремяИзменения();
		
	КонецЦикла;
	
	Если ТаблицаФайловСообщенийОбмена.Количество() = 0 Тогда
		
		ПолучитьСообщениеОбОшибке(3, СтруктураНастроек);
		
		СтрокаСообщения = НСтр("ru = 'Каталог обмена информацией: ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ИмяКаталогаОбменаИнформацией);
		ДополнитьСообщениеОбОшибке(СтрокаСообщения, СтруктураНастроек);
		
		СтрокаСообщения = НСтр("ru = 'Имя файла сообщения обмена: ""%1"" или ""%2""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ШаблонИмениФайлаСообщения + ".xml", ШаблонИмениФайлаСообщения + ".zip");
		ДополнитьСообщениеОбОшибке(СтрокаСообщения, СтруктураНастроек);
		
		Возврат Ложь;
		
	Иначе
		
		ТаблицаФайловСообщенийОбмена.Сортировать("ВремяИзменения Возр");
		
		// Получаем из таблицы самый "свежий" файл сообщения обмена.
		ФайлВходящегоСообщения = ТаблицаФайловСообщенийОбмена[0].Файл;
		
		ФайлЗапакован = (ВРег(ФайлВходящегоСообщения.Расширение) = ".ZIP");
		
		Если ФайлЗапакован Тогда
			
			// Получаем имя для временного файла архива.
			ИмяВременногоФайлаАрхива = ОбщегоНазначенияКлиентСервер.ПолучитьПолноеИмяФайла(ИмяКаталогаСообщенияОбмена, ФайлВходящегоСообщения.Имя);
			
			// Копируем файл архива из сетевого каталога во временный.
			Если Не ВыполнитьКопированиеФайла(ФайлВходящегоСообщения.ПолноеИмя, ИмяВременногоФайлаАрхива, СтруктураНастроек) Тогда
				Возврат Ложь;
			КонецЕсли;
			
			// Распаковываем временный файл архива.
			УспешноРаспаковано = ОбменДаннымиСервер.РаспаковатьZipФайл(ИмяВременногоФайлаАрхива, ИмяКаталогаСообщенияОбмена);
			
			Если Не УспешноРаспаковано Тогда
				ПолучитьСообщениеОбОшибке(4, СтруктураНастроек);
				Возврат Ложь;
			КонецЕсли;
			
			//// Проверка на существование файла сообщения.
			//Файл = Новый Файл(ИмяФайлаСообщенияОбмена);
			//
			//Если Не Файл.Существует() Тогда
			//	
			//	ПолучитьСообщениеОбОшибке(7, СтруктураНастроек);
			//	Возврат Ложь;
			//	
			//КонецЕсли;
			
		Иначе
			
			// Просто копируем файл входящего сообщения из каталога обмена в каталог временных файлов.
			Если ИспользоватьВременныйКаталогДляОтправкиИПриемаСообщений И Не ВыполнитьКопированиеФайла(ФайлВходящегоСообщения.ПолноеИмя, ИмяКаталогаСообщенияОбмена + ФайлВходящегоСообщения.Имя, СтруктураНастроек) Тогда
				
				Возврат Ложь;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Функция ИмяКаталогаОбменаИнформацией()
	
	Возврат Константы.КаталогОбменаOracleMI.Получить();
	
КонецФункции

Процедура ПолучитьСообщениеОбОшибке(НомерСообщения, СтруктураНастроек)
	
	УстановитьСтрокуСообщенияОбОшибке(СтруктураНастроек.СообщенияОшибок[НомерСообщения], СтруктураНастроек)
	
КонецПроцедуры

Процедура УстановитьСтрокуСообщенияОбОшибке(Знач Сообщение, СтруктураНастроек)
	
	ИмяОбъекта = НСтр("ru = 'Получение данных Oracle MI'");
	
	Если Сообщение = Неопределено Тогда
		Сообщение = Нстр("ru = 'Внутренняя ошибка'");
	КонецЕсли;
	
	СтруктураНастроек.СтрокаСообщенияОбОшибке   = Сообщение;
	СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР = ИмяОбъекта + ": " + Сообщение;
	
КонецПроцедуры

Процедура ДополнитьСообщениеОбОшибке(Сообщение, СтруктураНастроек)
	
	СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР = СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР + Символы.ПС + Сообщение;
	
КонецПроцедуры

Функция ВыполнитьКопированиеФайла(Знач ИмяФайлаИсточника, Знач ИмяФайлаПриемника, СтруктураНастроек)
	
	Попытка
		
		УдалитьФайлы(ИмяФайлаПриемника);
		КопироватьФайл(ИмяФайлаИсточника, ИмяФайлаПриемника);
		
	Исключение
		
		СтрокаСообщения = НСтр("ru = 'Ошибка при копировании файла из %1 в %2. Описание ошибки: %3'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения,
							ИмяФайлаИсточника,
							ИмяФайлаПриемника,
							КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		УстановитьСтрокуСообщенияОбОшибке(СтрокаСообщения, СтруктураНастроек);
		
		Возврат Ложь
		
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

Функция ПолучитьСписокЛистовЭкселя(ПутьКФайлу)
	
	СписокЛистов = Новый Массив;
	ИменаКолонокВПервойСтроке = Ложь;
	
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
	
	Возврат СписокЛистов;
	
КонецФункции

Процедура ЗагрузитьПолученныеДанные(СтруктураНастроек)
	
	МассивНайденныхФайлов = НайтиФайлы(СтруктураНастроек.ИмяКаталогаСообщенияОбмена, "*.xlsb", Ложь);
	
	// формируем документ загрузки для каждого найденного файла (должен быть 1 по идее)
	Для каждого НайденныйФайл Из МассивНайденныхФайлов Цикл
		
		ДокументЗагрузки = Документы.ЗагрузкаДанныхOracle.СоздатьДокумент();
		ДокументЗагрузки.Дата = ТекущаяДата();
		ДокументЗагрузки.Source = Перечисления.ТипыСоответствий.OracleMI;
		ДокументЗагрузки.ИмяФайла = НайденныйФайл.Имя;
		ДокументЗагрузки.Комментарий = НайденныйФайл.Имя;
		ДокументЗагрузки.Ответственный = Пользователи.ТекущийПользователь();
		ДвоичныеДанные = Новый ДвоичныеДанные(НайденныйФайл.ПолноеИмя);
		ДокументЗагрузки.ИсточникДанных = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
		
		ДокументЗагрузки.Записать();
		
		Попытка
			СписокЛистовЭкселя = ПолучитьСписокЛистовЭкселя(НайденныйФайл.ПолноеИмя);
		Исключение
			СписокЛистовЭкселя = Новый Массив();
		КонецПопытки;
		
		Если СписокЛистовЭкселя.Количество() = 1 Тогда
			
			ДокументЗагрузки.ЛистФайла = СписокЛистовЭкселя[0];
			ДокументЗагрузки.Записать();
			
		Иначе
			
			ПолучитьСообщениеОбОшибке(10, СтруктураНастроек);
			
			СтрокаСообщения = НСтр("ru = 'Не удалось определить лист файла в документе: ""%1""'");
			СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ПолучитьНавигационнуюСсылку(ДокументЗагрузки.Ссылка));
			ДополнитьСообщениеОбОшибке(СтрокаСообщения, СтруктураНастроек);
			
			РГСофт.ЗарегистрироватьПочтовоеСообщение(Константы.ПолучателиСообщенийОбОшибкахЗагрузкиДанныхOracleMI.Получить(),
				"ERM: Oracle MI loading error", СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР, , ТипТекстаПочтовогоСообщения.ПростойТекст);
				
			ЗаписьЖурналаРегистрации("Oracle MI loading error", УровеньЖурналаРегистрации.Ошибка, , , СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР);
			
			Возврат;
			
		КонецЕсли;
		
		СтруктураНастроек.Вставить("НачалоОбработкиФайла", ТекущаяДата());
		СтруктураНастроек.Вставить("ОбъемВБайтах", НайденныйФайл.Размер());
		ОбработатьДокументЗагрузки(ДокументЗагрузки, СтруктураНастроек);
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбработатьДокументЗагрузки(ДокументЗагрузки, СтруктураНастроек)
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата, ИсточникДанных, ИменаКолонокВПервойСтроке, ПерваяСтрокаДанных, ПоследняяСтрокаДанных");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ДокументЗагрузки);
	СтруктураПараметров.Вставить("СтруктураКолонок", Документы.ЗагрузкаДанныхOracle.ПолучитьСтруктуруКолонокТаблицыДанных());
	СтруктураПараметров.Вставить("ИсточникДанных", ДокументЗагрузки.ИсточникДанных);
	СтруктураПараметров.Вставить("ИменаКолонокВПервойСтроке", Истина);
	СтруктураПараметров.Вставить("ПерваяСтрокаДанных", 2);
	СтруктураПараметров.Вставить("ПоследняяСтрокаДанных", 0);
	СтруктураПараметров.Вставить("Ссылка", ДокументЗагрузки.Ссылка);
	СтруктураПараметров.Вставить("Дата", ДокументЗагрузки.Дата);
	СтруктураПараметров.Вставить("ЛистФайла", ДокументЗагрузки.ЛистФайла);
	СтруктураПараметров.Вставить("ИмяРегистра", "OracleSourceData");
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, Новый УникальныйИдентификатор());
	
	СтруктураЗаписиЛогов = Новый Структура;
	СтруктураЗаписиЛогов.Вставить("Период", ТекущаяДата());
	СтруктураЗаписиЛогов.Вставить("ДокументЗагрузки", ДокументЗагрузки.Ссылка);
	СтруктураЗаписиЛогов.Вставить("Source", ДокументЗагрузки.Source);
	СтруктураЗаписиЛогов.Вставить("СтатусЗагрузки", Перечисления.СтатусыЗагрузки.LoadedSourseData);
	СтруктураЗаписиЛогов.Вставить("ДатаНачала", СтруктураНастроек.НачалоОбработкиФайла);
	СтруктураЗаписиЛогов.Вставить("ДатаЗавершения", ТекущаяДата());
	СтруктураЗаписиЛогов.Вставить("ОбъемВБайтах", СтруктураНастроек.ОбъемВБайтах);
	
	Попытка
		
		Документы.ЗагрузкаДанныхOracle.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		
	Исключение
		
		СтруктураЗаписиЛогов.Вставить("ОписаниеОшибки", ОписаниеОшибки());
		
		ПолучитьСообщениеОбОшибке(11, СтруктураНастроек);
		
		СтрокаСообщения = НСтр("ru = '" + СтруктураЗаписиЛогов.ОписаниеОшибки + ": ""%1""'");
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаСообщения, ПолучитьНавигационнуюСсылку(ДокументЗагрузки.Ссылка));
		ДополнитьСообщениеОбОшибке(СтрокаСообщения, СтруктураНастроек);
		
		Попытка
			РГСофт.ЗарегистрироватьПочтовоеСообщение(Константы.ПолучателиСообщенийОбОшибкахЗагрузкиДанныхOracleMI.Получить(),
				"ERM: Oracle MI loading error", СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР, , ТипТекстаПочтовогоСообщения.ПростойТекст);
			СтруктураЗаписиЛогов.Вставить("СформированоУведомлениеОбОшибке", Истина);
		Исключение
		КонецПопытки;
			
		ЗаписьЖурналаРегистрации("Oracle MI loading error", УровеньЖурналаРегистрации.Ошибка, , , СтруктураНастроек.СтрокаСообщенияОбОшибкеЖР);
		
	КонецПопытки;
	
	РезультатЭтапа = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если РезультатЭтапа.Свойство() Тогда
		
	КонецЕсли;
	
	// логируем загрузку данных из файла
	РегистрыСведений.ИсторияЗагрузкиДанных.ДобавитьЗапись(СтруктураЗаписиЛогов);
	
КонецПроцедуры

Процедура ДействияПриОкончанииЗагрузки(СтруктураНастроек)
	
	УдалитьФайлы(СтруктураНастроек.ИмяКаталогаСообщенияОбмена);
	
КонецПроцедуры