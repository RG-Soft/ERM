
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
		//СсылкаНаФайл = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ИсточникДанных");
		//ПолучитьФайл(СсылкаНаФайл, Объект.ИмяФайла);
		МассивПрисоединенныхФайлов = РГСофт.НайтиПрисоединенныеФайлыПоВладельцу(Объект.Ссылка);
		АдресФайла = РаботаСФайламиКлиент.ДанныеФайла(МассивПрисоединенныхФайлов[0], ЭтаФорма.УникальныйИдентификатор, Истина).СсылкаНаДвоичныеДанныеФайла;
		ПолучитьФайл(АдресФайла, Объект.ИмяФайла);
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
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоАдресВременногоХранилища(АдресФайлаВХранилище) Тогда
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресФайлаВХранилище);
		//ТекущийОбъект.ИсточникДанных = Новый ХранилищеЗначения(ДвоичныеДанные, Новый СжатиеДанных(9));
		ТекущийОбъект.ДополнительныеСвойства.Вставить("АдресФайлаВХранилище", АдресФайлаВХранилище);
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Функция ОбновитьSalesOrdersНаСервере()
	
	СтруктураПараметров = Новый Структура("Ссылка");
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
	//Если Истина Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхSmithSalesOrdersDetails.ОбновитьРеквизитыSalesOrders(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Smith Sales orders update'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхSmithSalesOrdersDetails.ОбновитьРеквизитыSalesOrders", 
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
Процедура ОбновитьSalesOrders(Команда)
	
	Результат = ОбновитьSalesOrdersНаСервере();
	
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
	
	//////////////
	МассивПрисоединенныхФайлов = РГСофт.НайтиПрисоединенныеФайлыПоВладельцу(Объект.Ссылка);
	
	СтруктураПараметров = Новый Структура("Ссылка, Дата, ИсточникДанных, ИменаКолонокВПервойСтроке, ПерваяСтрокаДанных, ПоследняяСтрокаДанных");
	ЗаполнитьЗначенияСвойств(СтруктураПараметров, ЭтотОбъект);
	СтруктураПараметров.Вставить("СтруктураКолонок", РеквизитФормыВЗначение("СтруктураКолонок"));
	СтруктураПараметров.Вставить("ИсточникДанных", МассивПрисоединенныхФайлов[0]);
	//СтруктураПараметров.Вставить("ИсточникДанных", РеквизитФормыВЗначение("Объект").ИсточникДанных);
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("ЛистФайла", Объект.ЛистФайла);
	СтруктураПараметров.Вставить("Дата", Объект.Дата);
	СтруктураПараметров.Вставить("ИмяРегистра", "OracleSalesOrdersDetailsSourceData");
	СтруктураПараметров.Вставить("СоответствиеРесурсТип", rgsЗагрузкаИзExcel.СформироватьСоответствиеРесурсовИТиповРегистра("OracleSalesOrdersDetailsSourceData", Ложь));
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.ЗагрузкаДанныхSmithSalesOrdersDetails.ЗагрузитьДанныеИзФайла(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Smith Sales orders details loading'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.ЗагрузкаДанныхSmithSalesOrdersDetails.ЗагрузитьДанныеИзФайла", 
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

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьПодготовленныеДанные();
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

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ОшибкаЗаполнения") Тогда
		ВызватьИсключение СтруктураДанных.ОшибкаЗаполнения;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ОбновленныеSO") Тогда
		Объект.ОбновленныеSO.Загрузить(СтруктураДанных.ОбновленныеSO);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("НенайденныеSO") Тогда
		Объект.НенайденныеSO.Загрузить(СтруктураДанных.НенайденныеSO);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ОбновленныеInvoice") Тогда
		Объект.ОбновленныеInvoice.Загрузить(СтруктураДанных.ОбновленныеInvoice);
		Модифицированность = Истина;
	КонецЕсли;

	Если СтруктураДанных.Свойство("ОбновленныеДатыDIR") Тогда
		Объект.ОбновленныеДатыDIR.Загрузить(СтруктураДанных.ОбновленныеДатыDIR);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("НенайденныеInvoice") Тогда
		Объект.НенайденныеInvoice.Загрузить(СтруктураДанных.НенайденныеInvoice);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ОшибкиИдентификацииИнвойсов") Тогда
		Объект.ОшибкиИдентификацииИнвойсов.Загрузить(СтруктураДанных.ОшибкиИдентификацииИнвойсов);
		Модифицированность = Истина;
	КонецЕсли;
	
	Если Модифицированность Тогда
		Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьСтруктуруФайлаПоУмолчанию();
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьСтруктуруКолонок()
	
	СтруктураКолонок.Очистить();
	СтруктураКолонок.Загрузить(Документы.ЗагрузкаДанныхSmithSalesOrdersDetails.ПолучитьСтруктуруКолонокТаблицыДанных());
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруФайлаПоУмолчанию()
	
	ПерваяСтрокаДанных = 2;
	ИменаКолонокВПервойСтроке = Истина;
	ЗагрузитьСтруктуруКолонок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСтруктуруКолонокПоУмолчанию()
	
	СтруктураКолонок.Очистить();
	
	// invoice_nbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "НомерSO";
	СтрокаТЗ.ИмяКолонки = "invoice_nbr";
	
	// DestWell
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "WellData";
	СтрокаТЗ.ИмяКолонки = "customer_po_nbr";
	
	// CustomerNumber
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CustomerNumber";
	СтрокаТЗ.ИмяКолонки = "customer_nbr";
	
	// contract_ref_nbr
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "Agreement";
	СтрокаТЗ.ИмяКолонки = "contract_ref_nbr";
	
	// invoice_dt
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "JobEndDate";
	СтрокаТЗ.ИмяКолонки = "invoice_dt";
	
	// grand_total
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceAmount";
	СтрокаТЗ.ИмяКолонки = "grand_total";
	
	// gl_dt
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "InvoiceFlagDate";
	СтрокаТЗ.ИмяКолонки = "gl_dt";

	// Company_code
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CompanyCode";
	СтрокаТЗ.ИмяКолонки = "Company_code";

	// invoiced_by
	СтрокаТЗ = СтруктураКолонок.Добавить();
	СтрокаТЗ.ИмяПоля = "CreatedBy";
	СтрокаТЗ.ИмяКолонки = "invoiced_by";
		
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ТолькоПросмотр = Объект.Проведен;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ТолькоПросмотр = Объект.Проведен;
	
КонецПроцедуры
