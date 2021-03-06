
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Процедура ТаблицаДеревоAdjustmentПриИзменении(Элемент)
	ИзменениеAdjustment(Элементы.ТаблицаДерево.ТекущаяСтрока);
КонецПроцедуры

&НаСервере
Процедура ИзменениеAdjustment(Строка)
	
	ЭлементДанных = ТаблицаДерево.НайтиПоИдентификатору(Строка);
	ЭлементДанных.Adjustment = ЭлементДанных.Adjustment % 2;
	ПроставитьAdjustmentВниз(ЭлементДанных);
	ПроставитьAdjustmentВверх(ЭлементДанных);

КонецПроцедуры

&НаСервере
Процедура ПроставитьAdjustmentВниз(ДанныеСтроки) 
	Значение = ДанныеСтроки.Adjustment;
	Для Каждого Потомок Из ДанныеСтроки.ПолучитьЭлементы() Цикл
		Потомок.Adjustment = Значение;
		ПроставитьAdjustmentВниз(Потомок);
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ПроставитьAdjustmentВверх(ДанныеСтроки) Экспорт
	РодительСтроки = ДанныеСтроки.ПолучитьРодителя();
	Если РодительСтроки <> Неопределено Тогда
		ВсеИстина = Истина;
		НеВсеЛожь = Ложь;
		Для Каждого Потомок Из РодительСтроки.ПолучитьЭлементы() Цикл
			ВсеИстина = ВсеИстина И (Потомок.Adjustment = 1);
			НеВсеЛожь = НеВсеЛожь Или Булево(Потомок.Adjustment);
		КонецЦикла;
		Если ВсеИстина Тогда
			РодительСтроки.Adjustment = 1;
		ИначеЕсли НеВсеЛожь Тогда
			РодительСтроки.Adjustment = 2;
		Иначе
			РодительСтроки.Adjustment = 0;
		КонецЕсли;
		ПроставитьAdjustmentВверх(РодительСтроки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаДеревоВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Location) ИЛИ НЕ ЗначениеЗаполнено(Элемент.ТекущиеДанные.Segment) Тогда
		Возврат;
	КонецЕсли;
	
	ДатаДокумента = Объект.Дата;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("AccountHFM", Элемент.ТекущиеДанные.Account);
	СтруктураОтбора.Вставить("СегментHFM", Элемент.ТекущиеДанные.Segment);
	СтруктураОтбора.Вставить("ЛокацияHFM", Элемент.ТекущиеДанные.Location);
	СтруктураОтбора.Вставить("НачалоПериода", НачалоМесяца(ДатаДокумента));
	СтруктураОтбора.Вставить("КонецПериода", КонецМесяца(ДатаДокумента));
	СтруктураОтбора.Вставить("ДатаКурса", КонецМесяца(ДатаДокумента) + 1);
	СтруктураОтбора.Вставить("Период", КонецМесяца(ДатаДокумента));
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("СформироватьПриОткрытии", Истина);
	СтруктураПараметров.Вставить("Отбор", СтруктураОтбора);
	
	Если Объект.ВидОперации = ПредопределенноеЗначение("Перечисление.ТипСчета.AR") Тогда
		
		ОткрытьФорму("Отчет.РасшифровкаСтрокиСверкиСHFM_AR.ФормаОбъекта", СтруктураПараметров);
		
	Иначе
		
		ОткрытьФорму("Отчет.РасшифровкаСтрокиСверкиСHFM_Revenue.ФормаОбъекта", СтруктураПараметров);
		
	КонецЕсли;
	
КонецПроцедуры

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

&НаСервере
Процедура ЗаполнитьСписокЛистовЭкселя(ЗаполнитьЛист = Ложь)
	
	СписокЛистов = Новый Массив;
	
	Если ЭтоАдресВременногоХранилища(АдресФайлаВХранилище) Тогда
		ФайлЭксель = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
	Иначе
		//ОбъектДляСервера = РеквизитФормыВЗначение("Объект");
		//ФайлЭксель = ОбъектДляСервера.ИсточникДанных.Получить();
		МассивПрисоединенныхФайлов = РГСофт.НайтиПрисоединенныеФайлыПоВладельцу(Объект.Ссылка);
		
		ФайлЭксель = РаботаСФайлами.ДвоичныеДанныеФайла(МассивПрисоединенныхФайлов[0]);
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
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Объект.ИмяФайла = "" Тогда
		Сообщить("Файл не загружен!");
	Иначе
		//СсылкаНаФайл = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ИсточникДанных");
		//ПолучитьФайл(СсылкаНаФайл, Объект.ИмяФайла);
		МассивПрисоединенныхФайлов = РГСофт.НайтиПрисоединенныеФайлыПоВладельцу(Объект.Ссылка);
		АдресФайла = РаботаСФайламиКлиент.ДанныеФайла(МассивПрисоединенныхФайлов[0], ЭтаФорма.УникальныйИдентификатор, Истина).СсылкаНаДвоичныеДанныеФайла;
		ПолучитьФайл(АдресФайла, Объект.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоАдресВременногоХранилища(АдресФайлаВХранилище) Тогда
		//ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
		//ТекущийОбъект.ИсточникДанных = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
		ТекущийОбъект.ДополнительныеСвойства.Вставить("АдресФайлаВХранилище", АдресФайлаВХранилище);
	КонецЕсли;
	
	ТаблицаИзДерева = ВыгрузитьДеревоЗначенийВТаблицуЗначений(РеквизитФормыВЗначение("ТаблицаДерево"));
	
	ТекущийОбъект.ТаблицаРасхождений.Очистить();
	ТекущийОбъект.ТаблицаРасхождений.Загрузить(ТаблицаИзДерева);
	
КонецПроцедуры

Функция ВыгрузитьДеревоЗначенийВТаблицуЗначений(Дерево, Таблица = Неопределено) Экспорт
	
	Если Таблица = Неопределено Тогда
		Таблица = Новый ТаблицаЗначений;
		Для Каждого Колонка Из Дерево.Колонки Цикл
			Таблица.Колонки.Добавить(Колонка.Имя, Колонка.ТипЗначения);
		КонецЦикла;
	КонецЕсли;
	Для Каждого СтрокаДерева Из Дерево.Строки Цикл
		Если СтрокаДерева.Уровень() = 2 Тогда
			ЗаполнитьЗначенияСвойств(Таблица.Добавить(), СтрокаДерева);
		КонецЕсли;
		ВыгрузитьДеревоЗначенийВТаблицуЗначений(СтрокаДерева, Таблица);
	КонецЦикла;
	Возврат Таблица;
	
КонецФункции 

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
	
	МассивПрисоединенныхФайлов = РГСофт.НайтиПрисоединенныеФайлыПоВладельцу(Объект.Ссылка);
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата, ИсточникДанных, ИменаКолонокВПервойСтроке, ПерваяСтрокаДанных, ПоследняяСтрокаДанных, АдресФайлаВХранилище");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтотОбъект);
	СтруктураПараметров.Вставить("СтруктураКолонок", РеквизитФормыВЗначение("СтруктураКолонок"));
	СтруктураПараметров.Вставить("ИсточникДанных", МассивПрисоединенныхФайлов[0]);
	//СтруктураПараметров.Вставить("ИсточникДанных", РеквизитФормыВЗначение("Объект").ИсточникДанных);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ЛистФайла", Объект.ЛистФайла);
	СтруктураПараметров.Вставить("АдресФайлаВХранилище", АдресФайлаВХранилище);
	СтруктураПараметров.Вставить("ИмяРегистра","HFMSourceData");
	СтруктураПараметров.Вставить("СоответствиеРесурсТип", rgsЗагрузкаИзExcel.СформироватьСоответствиеРесурсовИТиповРегистра("HFMSourceData", Ложь));
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗакрытиеМесяца.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'HFM loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗакрытиеМесяца.ЗагрузитьДанныеИзФайла", 
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
	
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	ЗаполнитьДерево();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДерево()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗакрытиеМесяцаТаблицаРасхождений.Adjustment КАК Adjustment,
		|	ЗакрытиеМесяцаТаблицаРасхождений.Account КАК Account,
		|	ЗакрытиеМесяцаТаблицаРасхождений.Segment КАК Segment,
		|	ЗакрытиеМесяцаТаблицаРасхождений.Location КАК Location,
		|	ЗакрытиеМесяцаТаблицаРасхождений.HFM_Amount КАК HFM_Amount,
		|	ЗакрытиеМесяцаТаблицаРасхождений.ERM_Amount КАК ERM_Amount,
		|	ЗакрытиеМесяцаТаблицаРасхождений.Difference КАК Difference
		|ИЗ
		|	Документ.ЗакрытиеМесяца.ТаблицаРасхождений КАК ЗакрытиеМесяцаТаблицаРасхождений
		|ГДЕ
		|	ЗакрытиеМесяцаТаблицаРасхождений.Ссылка = &Ссылка
		|ИТОГИ
		|	ВЫБОР
		|		КОГДА СУММА(Adjustment) = 0
		|			ТОГДА 0
		|		КОГДА СУММА(Adjustment) < КОЛИЧЕСТВО(Adjustment)
		|			ТОГДА 2
		|		ИНАЧЕ 1
		|	КОНЕЦ КАК Adjustment,
		|	СУММА(HFM_Amount),
		|	СУММА(ERM_Amount),
		|	СУММА(Difference)
		|ПО
		|	Account,
		|	Location";
	
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	ДеревоИзЗапроса = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ЗначениеВРеквизитФормы(ДеревоИзЗапроса, "ТаблицаДерево");

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруФайлаПоУмолчанию()
	
	ПерваяСтрокаДанных = 2;
	ИменаКолонокВПервойСтроке = Истина;
	ЗаполнитьСтруктуруКолонокПоУмолчанию();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчанию()
	
		// Source
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Source";
	СтрокаТЗ.ИмяКолонки = "Source";
	СтрокаТЗ.Обязательная = Истина;
	//СтрокаТЗ.НомерКолонки = 1;
	
	// ACCOUNT
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Account";
	СтрокаТЗ.ИмяКолонки = "ACCOUNT";
	СтрокаТЗ.Обязательная = Истина;
	
	// YEAR
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Year";
	СтрокаТЗ.ИмяКолонки = "YEAR";
	СтрокаТЗ.Обязательная = Истина;
	
	// Month
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Month";
	СтрокаТЗ.ИмяКолонки = "Month";
	СтрокаТЗ.Обязательная = Истина;
	
	// SUBSEG
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Segment";
	СтрокаТЗ.ИмяКолонки = "SUBSEG";
	СтрокаТЗ.Обязательная = Истина;
	
	// GEO
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Location";
	СтрокаТЗ.ИмяКолонки = "GEO";
	СтрокаТЗ.Обязательная = Истина;
	
	// SUM
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Amount";
	СтрокаТЗ.ИмяКолонки = "SUM";
	СтрокаТЗ.Обязательная = Истина;
	
	
КонецПроцедуры

&НаСервере
Функция ЗаписатьДанныеВТаблицуНаСервере()
	
	СтруктураПараметров = Новый Структура("Ссылка");
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ВидОперации", Объект.ВидОперации);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗакрытиеМесяца.ЗаписатьДанныеВТаблицу(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Закрытие месяца'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗакрытиеМесяца.ЗаписатьДанныеВТаблицу", 
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
Процедура ЗаписатьДанныеВТаблицу(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	ТаблицаКоллизий.Очистить();
	
	Результат = ЗаписатьДанныеВТаблицуНаСервере(); 
	
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
Функция СоздатьКорректировкиНаСервере()
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ВидОперации", Объект.ВидОперации);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗакрытиеМесяца.СоздатьКорректировки(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Закрытие месяца'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗакрытиеМесяца.СоздатьКорректировки", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		//ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ЗакрытьМесяц(Команда)
	
	//Результат = СоздатьКорректировкиНаСервере();
	//
	//Если НЕ Результат.ЗаданиеВыполнено Тогда
	//	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	//	АдресХранилища       = Результат.АдресХранилища;
	//	
	//	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	//	ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	//	ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	//Иначе
	//	Прочитать();
	//КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ДатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДатаДокумента = Объект.Дата;
	
	ПараметрыВыбора1 = Новый Структура;
	
	Если ДатаДокумента = Дата(1,1,1) Тогда
		ПараметрыВыбора1.Вставить("НачалоПериода", НачалоМесяца(ТекущаяДата()));
		ПараметрыВыбора1.Вставить("КонецПериода", КонецМесяца(ТекущаяДата()));
	Иначе
		ПараметрыВыбора1.Вставить("НачалоПериода", НачалоМесяца(ДатаДокумента));
		ПараметрыВыбора1.Вставить("КонецПериода", КонецМесяца(ДатаДокумента));
	КонецЕсли;	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора1, ЭтаФорма.ТекущийЭлемент.ВыделенныйТекст, , , , ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Дата = РезультатВыбора.НачалоПериода;
	
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректировки(Команда)
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
	Результат = СоздатьКорректировкиНаСервере();
	
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

