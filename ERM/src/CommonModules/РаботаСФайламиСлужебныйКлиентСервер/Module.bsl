#Область СлужебныйПрограммныйИнтерфейс

// Возвращает персональные настройки.
//
Функция ПерсональныеНастройкиРаботыСФайлами() Экспорт

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат РаботаСФайламиСлужебныйПовтИсп.НастройкиРаботыСФайлами().ПерсональныеНастройки;
#Иначе
	Возврат РаботаСФайламиСлужебныйКлиент.ПерсональныеНастройкиРаботыСФайлами();
#КонецЕсли

КонецФункции

// Возвращает персональные общие настройки.
//
Функция ОбщиеНастройкиРаботыСФайлами() Экспорт

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	Возврат РаботаСФайламиСлужебныйПовтИсп.НастройкиРаботыСФайлами().ОбщиеНастройки;
#Иначе
	Возврат РаботаСФайламиСлужебныйКлиент.ОбщиеНастройкиРаботыСФайлами();
#КонецЕсли

КонецФункции

// Извлечь текст из файла и возвратить его в виде строки.
Функция ИзвлечьТекст(ПолноеИмяФайла, Отказ = Ложь, Кодировка = Неопределено) Экспорт
	
	ИзвлеченныйТекст = "";
	
	Попытка
		Файл = Новый Файл(ПолноеИмяФайла);
		Если Не Файл.Существует() Тогда
			Отказ = Истина;
			Возврат ИзвлеченныйТекст;
		КонецЕсли;
	Исключение
		Отказ = Истина;
		Возврат ИзвлеченныйТекст;
	КонецПопытки;
	
	Прекратить = Ложь;
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
#Если Не ВебКлиент Тогда
	
	РасширениеИмениФайла =
		ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
	
	РасширениеФайлаВСписке = РасширениеФайлаВСписке(
		ОбщиеНастройки.СписокРасширенийТекстовыхФайлов, РасширениеИмениФайла);
	
	Если РасширениеФайлаВСписке Тогда
		Возврат ИзвлечьТекстИзТекстовогоФайла(ПолноеИмяФайла, Кодировка, Отказ);
	КонецЕсли;
	
	Попытка
		Извлечение = Новый ИзвлечениеТекста(ПолноеИмяФайла);
		ИзвлеченныйТекст = Извлечение.ПолучитьТекст();
	Исключение
		// Когда текст некому извлечь исключение не требуется. Это нормальный случай.
		ИзвлеченныйТекст = "";
		Прекратить = Истина;
	КонецПопытки;
#КонецЕсли
	
	Если ПустаяСтрока(ИзвлеченныйТекст) Тогда
		
		РасширениеИмениФайла =
			ОбщегоНазначенияКлиентСервер.ПолучитьРасширениеИмениФайла(ПолноеИмяФайла);
		
		РасширениеФайлаВСписке = РасширениеФайлаВСписке(
			ОбщиеНастройки.СписокРасширенийФайловOpenDocument, РасширениеИмениФайла);
		
		Если РасширениеФайлаВСписке Тогда
			Возврат ИзвлечьТекстOpenDocument(ПолноеИмяФайла, Отказ);
		КонецЕсли;
		
	КонецЕсли;
	
	Если Прекратить Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Получить уникальное имя файла в рабочем каталоге.
//  Если есть совпадения - будет имя подобное "A1\Приказ.doc".
//
Функция ПолучитьУникальноеИмяСПутем(ИмяКаталога, ИмяФайла) Экспорт
	
	ИтоговыйПуть = "";
	
	Счетчик = 0;
	ЦиклНомер = 0;
	Успешно = Ложь;
	КодБукваA = КодСимвола("A", 1);
	
	ГенераторСлучая = Неопределено;
	
#Если Не ВебКлиент Тогда
	ГенераторСлучая = Новый ГенераторСлучайныхЧисел(ТекущаяУниверсальнаяДатаВМиллисекундах());
#КонецЕсли

	КоличествоСлучайныхВариантов = 26;
	
	Пока НЕ Успешно И ЦиклНомер < 100 Цикл
		НомерКаталога = 0;
		
#Если Не ВебКлиент Тогда
		НомерКаталога = ГенераторСлучая.СлучайноеЧисло(0, КоличествоСлучайныхВариантов - 1);
#Иначе
		НомерКаталога = ТекущаяУниверсальнаяДатаВМиллисекундах() % КоличествоСлучайныхВариантов;
#КонецЕсли

		Если Счетчик > 1 И КоличествоСлучайныхВариантов < 26 * 26 * 26 * 26 * 26 Тогда
			КоличествоСлучайныхВариантов = КоличествоСлучайныхВариантов * 26;
		КонецЕсли;
		
		БуквыКаталога = "";
		КодБукваA = КодСимвола("A", 1);
		
		Пока Истина Цикл
			НомерБуквы = НомерКаталога % 26;
			НомерКаталога = Цел(НомерКаталога / 26);
			
			КодКаталога = КодБукваA + НомерБуквы;
			
			БуквыКаталога = БуквыКаталога + Символ(КодКаталога);
			Если НомерКаталога = 0 Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
		ПодКаталог = ""; // Частичный путь.
		
		// По умолчанию вначале используется корень, если возможности нет,
		// то добавляется A, B, ... Z, .. ZZZZZ, .. AAAAA, .. AAAAAZ и т.д.
		Если  Счетчик = 0 Тогда
			ПодКаталог = "";
		Иначе
			ПодКаталог = БуквыКаталога;
			ЦиклНомер = Окр(Счетчик / 26);
			
			Если ЦиклНомер <> 0 Тогда
				ЦиклНомерСтрока = Строка(ЦиклНомер);
				ПодКаталог = ПодКаталог + ЦиклНомерСтрока;
			КонецЕсли;
			
			Если ЭтоЗарезервированноеИмяКаталога(ПодКаталог) Тогда
				Продолжить;
			КонецЕсли;
			
			ПодКаталог = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПодКаталог);
		КонецЕсли;
		
		ПолныйПодКаталог = ИмяКаталога + ПодКаталог;
		
		// Создание каталога для файлов.
		КаталогНаДиске = Новый Файл(ПолныйПодКаталог);
		Если НЕ КаталогНаДиске.Существует() Тогда
			Попытка
				СоздатьКаталог(ПолныйПодКаталог);
			Исключение
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при создании каталога ""%1"":
					           |""%2"".'"),
					ПолныйПодКаталог,
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()) );
			КонецПопытки;
		КонецЕсли;
		
		ФайлПопытки = ПолныйПодКаталог + ИмяФайла;
		Счетчик = Счетчик + 1;
		
		// Проверка, есть ли файл с таким именем.
		ФайлНаДиске = Новый Файл(ФайлПопытки);
		Если НЕ ФайлНаДиске.Существует() Тогда  // Нет такого файла.
			ИтоговыйПуть = ПодКаталог + ИмяФайла;
			Успешно = Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИтоговыйПуть;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением находится в списке расширений.
Функция РасширениеФайлаВСписке(СписокРасширений, РасширениеФайла) Экспорт
	
	РасширениеФайлаБезТочки = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	МассивРасширений = СтрРазделить(
		НРег(СписокРасширений), " ", Ложь);
	
	Если МассивРасширений.Найти(РасширениеФайлаБезТочки) <> Неопределено Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Проверяет расширение файла и размер.
Функция ПроверитьВозможностьЗагрузкиФайла(Файл,
                                          ВызыватьИсключение = Истина,
                                          МассивИменФайловСОшибками = Неопределено) Экспорт
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
	// Размер файла слишком большой.
	Если Файл.Размер() > ОбщиеНастройки.МаксимальныйРазмерФайла Тогда
		
		РазмерВМб     = Файл.Размер() / (1024 * 1024);
		РазмерВМбМакс = ОбщиеНастройки.МаксимальныйРазмерФайла / (1024 * 1024);
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Размер файла ""%1"" (%2 Мб)
			           |превышает максимально допустимый размер файла (%3 Мб).'"),
			Файл.Имя,
			ПолучитьСтрокуСРазмеромФайла(РазмерВМб),
			ПолучитьСтрокуСРазмеромФайла(РазмерВМбМакс));
		
		Если ВызыватьИсключение Тогда
			ВызватьИсключение ОписаниеОшибки;
		КонецЕсли;
		
		Запись = Новый Структура;
		Запись.Вставить("ИмяФайла", Файл.ПолноеИмя);
		Запись.Вставить("Ошибка",   ОписаниеОшибки);
		
		МассивИменФайловСОшибками.Добавить(Запись);
		Возврат Ложь;
	КонецЕсли;
	
	// Проверка расширения файла.
	Если Не ПроверитьРасширениеФайлаДляЗагрузки(Файл.Расширение, Ложь) Тогда
		
		ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка файлов с расширением ""%1"" запрещена.
			           |Обратитесь к администратору.'"),
			Файл.Расширение);
		
		Если ВызыватьИсключение Тогда
			ВызватьИсключение ОписаниеОшибки;
		КонецЕсли;
		
		Запись = Новый Структура;
		Запись.Вставить("ИмяФайла", Файл.ПолноеИмя);
		Запись.Вставить("Ошибка",   ОписаниеОшибки);
		
		МассивИменФайловСОшибками.Добавить(Запись);
		Возврат Ложь;
	КонецЕсли;
	
	// Временные файлы Word не импортируются.
	Если СтрНачинаетсяС(Файл.Имя, "~")
		И Файл.ПолучитьНевидимость() Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Возвращает Истина, если файл с таким расширением можно загружать.
Функция ПроверитьРасширениеФайлаДляЗагрузки(РасширениеФайла, ВызыватьИсключение = Истина) Экспорт
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
	Если НЕ ОбщиеНастройки.ЗапретЗагрузкиФайловПоРасширению Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если РасширениеФайлаВСписке(ОбщиеНастройки.СписокЗапрещенныхРасширений, РасширениеФайла) Тогда
		
		Если ВызыватьИсключение Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Загрузка файлов с расширением ""%1"" запрещена.
				           |Обратитесь к администратору.'"),
				РасширениеФайла);
		Иначе
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Вызывает исключение, если файл имеет недопустимый размер для загрузки.
Процедура ПроверитьРазмерФайлаДляЗагрузки(Файл) Экспорт
	
	ОбщиеНастройки = ОбщиеНастройкиРаботыСФайлами();
	
	Если ТипЗнч(Файл) = Тип("Файл") Тогда
		Размер = Файл.Размер();
	Иначе
		Размер = Файл.Размер;
	КонецЕсли;
	
	Если Размер > ОбщиеНастройки.МаксимальныйРазмерФайла Тогда
	
		РазмерВМб     = Размер / (1024 * 1024);
		РазмерВМбМакс = ОбщиеНастройки.МаксимальныйРазмерФайла / (1024 * 1024);
		
		Если ТипЗнч(Файл) = Тип("Файл") Тогда
			Имя = Файл.Имя;
		Иначе
			Имя = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
				Файл.ПолноеНаименование, Файл.Расширение);
		КонецЕсли;
		
		ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Размер файла ""%1"" (%2 Мб)
			           |превышает максимально допустимый размер файла (%3 Мб).'"),
			Имя,
			ПолучитьСтрокуСРазмеромФайла(РазмерВМб),
			ПолучитьСтрокуСРазмеромФайла(РазмерВМбМакс));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для пользовательского интерфейса.

// Возвращает Строку сообщения о недопустимости подписания занятого файла.
//
Функция СтрокаСообщенияОНедопустимостиПодписанияЗанятогоФайла(ФайлСсылка = Неопределено) Экспорт
	
	Если ФайлСсылка = Неопределено Тогда
		Возврат НСтр("ru = 'Нельзя подписать занятый файл.'");
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Нельзя подписать занятый файл: %1.'"),
			Строка(ФайлСсылка) );
	КонецЕсли;
	
КонецФункции

// Возвращает Строку сообщения о недопустимости подписания зашифрованного файла.
//
Функция СтрокаСообщенияОНедопустимостиПодписанияЗашифрованногоФайла(ФайлСсылка = Неопределено) Экспорт
	
	Если ФайлСсылка = Неопределено Тогда
		Возврат НСтр("ru = 'Нельзя подписать зашифрованный файл.'");
	Иначе
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Нельзя подписать зашифрованный файл: %1.'"),
						Строка(ФайлСсылка) );
	КонецЕсли;
	
КонецФункции

// Возвращает текст сообщения об ошибке создания нового файла.
//
// Параметры:
//  ИнформацияОбОшибке - ИнформацияОбОшибке.
//
Функция ОшибкаСозданияНовогоФайла(ИнформацияОбОшибке) Экспорт
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Ошибка создания нового файла.
		           |
		           |%1'"),
		КраткоеПредставлениеОшибки(ИнформацияОбОшибке));

КонецФункции

// Возвращает стандартный текст ошибки.
Функция ОшибкаФайлНеНайденВХранилищеФайлов(ИмяФайла, ПоискВТоме = Истина, ВладелецФайла = "") Экспорт
	
	Если ПоискВТоме Тогда
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось открыть файл:
				|%1
				|который присоединен к:
				|%2
				|по причине: двоичные данные файла были удалены. Возможно, файл очищен как ненужный или удален антивирусной программой.
				|Обратитесь к администратору.'"),
			ИмяФайла,
			ВладелецФайла);
			
	Иначе
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Не удалось открыть файл:
				|%1
				|который присоединен к:
				|%2
				|по причине: двоичные данные файла были удалены. Возможно, файл очищен как ненужный.
				|Обратитесь к администратору.'"),
			ИмяФайла,
			ВладелецФайла);
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции

// Получить строку с представлением размера файла - например для отображения в Состояние при передаче файла.
Функция ПолучитьСтрокуСРазмеромФайла(Знач РазмерВМб) Экспорт
	
	Если РазмерВМб < 0.1 Тогда
		РазмерВМб = 0.1;
	КонецЕсли;	
	
	СтрокаРазмера = ?(РазмерВМб >= 1, Формат(РазмерВМб, "ЧДЦ=0"), Формат(РазмерВМб, "ЧДЦ=1; ЧН=0"));
	Возврат СтрокаРазмера;
	
КонецФункции	

// Получается индекс пиктограммы файла - индекс в картинке КоллекцияПиктограммФайлов.
Функция ПолучитьИндексПиктограммыФайла(Знач РасширениеФайла) Экспорт
	
	Если ТипЗнч(РасширениеФайла) <> Тип("Строка")
		ИЛИ ПустаяСтрока(РасширениеФайла) Тогда
		Возврат 0;
	КонецЕсли;
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	Расширение = "." + НРег(РасширениеФайла) + ";";
	
	Если СтрНайти(".dt;.1cd;.cf;.cfu;", Расширение) <> 0 Тогда
		Возврат 6; // Файлы 1С.
		
	ИначеЕсли Расширение = ".mxl;" Тогда
		Возврат 8; // Табличный Файл.
		
	ИначеЕсли СтрНайти(".txt;.log;.ini;", Расширение) <> 0 Тогда
		Возврат 10; // Текстовый Файл.
		
	ИначеЕсли Расширение = ".epf;" Тогда
		Возврат 12; // Внешние обработки.
		
	ИначеЕсли СтрНайти(".ico;.wmf;.emf;",Расширение) <> 0 Тогда
		Возврат 14; // Картинки.
		
	ИначеЕсли СтрНайти(".htm;.html;.url;.mht;.mhtml;",Расширение) <> 0 Тогда
		Возврат 16; // HTML.
		
	ИначеЕсли СтрНайти(".doc;.dot;.rtf;",Расширение) <> 0 Тогда
		Возврат 18; // Файл Microsoft Word.
		
	ИначеЕсли СтрНайти(".xls;.xlw;",Расширение) <> 0 Тогда
		Возврат 20; // Файл Microsoft Excel.
		
	ИначеЕсли СтрНайти(".ppt;.pps;",Расширение) <> 0 Тогда
		Возврат 22; // Файл Microsoft PowerPoint.
		
	ИначеЕсли СтрНайти(".vsd;",Расширение) <> 0 Тогда
		Возврат 24; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mpp;",Расширение) <> 0 Тогда
		Возврат 26; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mdb;.adp;.mda;.mde;.ade;",Расширение) <> 0 Тогда
		Возврат 28; // База данных Microsoft Access.
		
	ИначеЕсли СтрНайти(".xml;",Расширение) <> 0 Тогда
		Возврат 30; // xml.
		
	ИначеЕсли СтрНайти(".msg;.eml;",Расширение) <> 0 Тогда
		Возврат 32; // Письмо электронной почты.
		
	ИначеЕсли СтрНайти(".zip;.rar;.arj;.cab;.lzh;.ace;",Расширение) <> 0 Тогда
		Возврат 34; // Архивы.
		
	ИначеЕсли СтрНайти(".exe;.com;.bat;.cmd;",Расширение) <> 0 Тогда
		Возврат 36; // Исполняемые файлы.
		
	ИначеЕсли СтрНайти(".grs;",Расширение) <> 0 Тогда
		Возврат 38; // Графическая схема.
		
	ИначеЕсли СтрНайти(".geo;",Расширение) <> 0 Тогда
		Возврат 40; // Географическая схема.
		
	ИначеЕсли СтрНайти(".jpg;.jpeg;.jp2;.jpe;",Расширение) <> 0 Тогда
		Возврат 42; // jpg.
		
	ИначеЕсли СтрНайти(".bmp;.dib;",Расширение) <> 0 Тогда
		Возврат 44; // bmp.
		
	ИначеЕсли СтрНайти(".tif;.tiff;",Расширение) <> 0 Тогда
		Возврат 46; // tif.
		
	ИначеЕсли СтрНайти(".gif;",Расширение) <> 0 Тогда
		Возврат 48; // gif.
		
	ИначеЕсли СтрНайти(".png;",Расширение) <> 0 Тогда
		Возврат 50; // png.
		
	ИначеЕсли СтрНайти(".pdf;",Расширение) <> 0 Тогда
		Возврат 52; // pdf.
		
	ИначеЕсли СтрНайти(".odt;",Расширение) <> 0 Тогда
		Возврат 54; // Open Office writer.
		
	ИначеЕсли СтрНайти(".odf;",Расширение) <> 0 Тогда
		Возврат 56; // Open Office math.
		
	ИначеЕсли СтрНайти(".odp;",Расширение) <> 0 Тогда
		Возврат 58; // Open Office Impress.
		
	ИначеЕсли СтрНайти(".odg;",Расширение) <> 0 Тогда
		Возврат 60; // Open Office draw.
		
	ИначеЕсли СтрНайти(".ods;",Расширение) <> 0 Тогда
		Возврат 62; // Open Office calc.
		
	ИначеЕсли СтрНайти(".mp3;",Расширение) <> 0 Тогда
		Возврат 64;
		
	ИначеЕсли СтрНайти(".erf;",Расширение) <> 0 Тогда
		Возврат 66; // Внешние отчеты.
		
	ИначеЕсли СтрНайти(".docx;",Расширение) <> 0 Тогда
		Возврат 68; // Файл Microsoft Word docx.
		
	ИначеЕсли СтрНайти(".xlsx;",Расширение) <> 0 Тогда
		Возврат 70; // Файл Microsoft Excel xlsx.
		
	ИначеЕсли СтрНайти(".pptx;",Расширение) <> 0 Тогда
		Возврат 72; // Файл Microsoft PowerPoint pptx.
		
	ИначеЕсли СтрНайти(".p7s;",Расширение) <> 0 Тогда
		Возврат 74; // Файл подписи.
		
	ИначеЕсли СтрНайти(".p7m;",Расширение) <> 0 Тогда
		Возврат 76; // зашифрованное сообщение.
	Иначе
		Возврат 4;
	КонецЕсли;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Прочие

// Удаляет файлы после импорта или загрузки.
Процедура УдалитьФайлыПослеДобавления(МассивСтруктурВсехФайлов, МассивВсехПапок) Экспорт
	
	Для Каждого Элемент Из МассивСтруктурВсехФайлов Цикл
		ВыбранныйФайл = Новый Файл(Элемент.ИмяФайла);
		ВыбранныйФайл.УстановитьТолькоЧтение(Ложь);
		УдалитьФайлы(ВыбранныйФайл.ПолноеИмя);
	КонецЦикла;
	
КонецПроцедуры

// Возвращает массив файлов, эмулируя работу НайтиФайлы - но не по файловой системе, а по Соответствию
//  если ПсевдоФайловаяСистема пуста - работает с файловой системой.
Функция НайтиФайлыПсевдо(Знач ПсевдоФайловаяСистема, Путь) Экспорт
	
	Если ПсевдоФайловаяСистема.Количество() = 0 Тогда
		Файлы = НайтиФайлы(Путь, "*.*");
		Возврат Файлы;
	КонецЕсли;
	
	Файлы = Новый Массив;
	
	ЗначениеНайденное = ПсевдоФайловаяСистема.Получить(Строка(Путь));
	Если ЗначениеНайденное <> Неопределено Тогда
		Для Каждого ИмяФайла Из ЗначениеНайденное Цикл
			ФайлИзСписка = Новый Файл(ИмяФайла);
			Файлы.Добавить(ФайлИзСписка);
		КонецЦикла;
	КонецЕсли;
	
	Возврат Файлы;
	
КонецФункции

// Только для внутреннего использования.
Процедура ЗаполнитьСтатусПодписи(СтрокаПодписи) Экспорт
	
	Если Не ЗначениеЗаполнено(СтрокаПодписи.ДатаПроверкиПодписи) Тогда
		СтрокаПодписи.Статус = "";
		Возврат;
	КонецЕсли;
	
	Если СтрокаПодписи.ПодписьВерна Тогда
		СтрокаПодписи.Статус = НСтр("ru = 'Верна'");
	Иначе
		СтрокаПодписи.Статус = НСтр("ru = 'Неверна'");
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Синхронизация файлов

Функция АдресВОблачномСервисе(Сервис, Href) Экспорт
	
	АдресОбъекта = Href;
	
	Если Не ПустаяСтрока(Сервис) Тогда
		Если Сервис = "https://webdav.yandex.ru" Тогда
			АдресОбъекта = СтрЗаменить(Href, "https://webdav.yandex.ru", "https://disk.yandex.ru/client/disk");
		ИначеЕсли Сервис = "https://webdav.4shared.com" Тогда
			АдресОбъекта = "http://www.4shared.com/folder";
		ИначеЕсли Сервис = "https://dav.box.com/dav" Тогда
			АдресОбъекта = "https://app.box.com/files/0/";
		ИначеЕсли Сервис = "https://dav.dropdav.com" Тогда
			АдресОбъекта = "https://www.dropbox.com/home/";
		КонецЕсли;
	КонецЕсли;
	
	Возврат АдресОбъекта;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
// Получить имя сканированного файла, вида ДМ-00000012, где ДМ - префикс базы.
//
// Параметры:
//  НомерФайла  - Число - целое число, например, 12.
//  ПрефиксБазы - Строка - префикс базы, например, "ДМ".
//
// Возвращаемое значение:
//  Строка - имя сканированного файла, например, "ДМ-00000012".
//
Функция ИмяСканированногоФайла(НомерФайла, ПрефиксБазы) Экспорт
	
	ИмяФайла = "";
	Если НЕ ПустаяСтрока(ПрефиксБазы) Тогда
		ИмяФайла = ПрефиксБазы + "-";
	КонецЕсли;
	
	ИмяФайла = ИмяФайла + Формат(НомерФайла, "ЧЦ=9; ЧВН=; ЧГ=0");
	Возврат ИмяФайла;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Извлекает текст в соответствии с кодировкой.
// Если кодировка не задана - сама вычисляет кодировку.
//
Функция ИзвлечьТекстИзТекстовогоФайла(ПолноеИмяФайла, Кодировка, Отказ)
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда
	
	// Определение кодировки.
	Если Не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = Неопределено;
	КонецЕсли;
	
	Попытка
		ЧтениеТекста = Новый ЧтениеТекста(ПолноеИмяФайла, Кодировка);
		ИзвлеченныйТекст = ЧтениеТекста.Прочитать();
	Исключение
		Отказ = Истина;
		ИзвлеченныйТекст = "";
	КонецПопытки;
	
#КонецЕсли
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлечь текст из файла OpenDocument и возвратить его в виде строки.
//
Функция ИзвлечьТекстOpenDocument(ПутьКФайлу, Отказ)
	
	ИзвлеченныйТекст = "";
	
#Если Не ВебКлиент Тогда
	
	ВременнаяПапкаДляРазархивирования = ПолучитьИмяВременногоФайла("");
	ВременныйZIPФайл = ПолучитьИмяВременногоФайла("zip"); 
	
	КопироватьФайл(ПутьКФайлу, ВременныйZIPФайл);
	Файл = Новый Файл(ВременныйZIPФайл);
	Файл.УстановитьТолькоЧтение(Ложь);

	Попытка
		Архив = Новый ЧтениеZipФайла();
		Архив.Открыть(ВременныйZIPФайл);
		Архив.ИзвлечьВсе(ВременнаяПапкаДляРазархивирования, РежимВосстановленияПутейФайловZIP.Восстанавливать);
		Архив.Закрыть();
		ЧтениеXML = Новый ЧтениеXML();
		
		ЧтениеXML.ОткрытьФайл(ВременнаяПапкаДляРазархивирования + "/content.xml");
		ИзвлеченныйТекст = ИзвлечьТекстИзContentXML(ЧтениеXML);
		ЧтениеXML.Закрыть();
	Исключение
		// Не считаем ошибкой, т.к. например расширение OTF может быть как OpenDocument, так и шрифт OpenType.
		Архив     = Неопределено;
		ЧтениеXML = Неопределено;
		Отказ = Истина;
		ИзвлеченныйТекст = "";
	КонецПопытки;
	
	УдалитьФайлы(ВременнаяПапкаДляРазархивирования);
	УдалитьФайлы(ВременныйZIPФайл);
	
#КонецЕсли
	
	Возврат ИзвлеченныйТекст;
	
КонецФункции

// Извлечь текст из объекта ЧтениеXML (прочитанного из файла OpenDocument).
Функция ИзвлечьТекстИзContentXML(ЧтениеXML)
	
	ИзвлеченныйТекст = "";
	ПоследнееИмяТега = "";
	
#Если Не ВебКлиент Тогда
	
	Пока ЧтениеXML.Прочитать() Цикл
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
			
			ПоследнееИмяТега = ЧтениеXML.Имя;
			
			Если ЧтениеXML.Имя = "text:p" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:line-break" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.ПС;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:tab" Тогда
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + Символы.Таб;
				КонецЕсли;
			КонецЕсли;
			
			Если ЧтениеXML.Имя = "text:s" Тогда
				
				СтрокаДобавки = " "; // пробел
				
				Если ЧтениеXML.КоличествоАтрибутов() > 0 Тогда
					Пока ЧтениеXML.ПрочитатьАтрибут() Цикл
						Если ЧтениеXML.Имя = "text:c"  Тогда
							ЧислоПробелов = Число(ЧтениеXML.Значение);
							СтрокаДобавки = "";
							Для Индекс = 0 По ЧислоПробелов - 1 Цикл
								СтрокаДобавки = СтрокаДобавки + " "; // пробел
							КонецЦикла;
						КонецЕсли;
					КонецЦикла
				КонецЕсли;
				
				Если НЕ ПустаяСтрока(ИзвлеченныйТекст) Тогда
					ИзвлеченныйТекст = ИзвлеченныйТекст + СтрокаДобавки;
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЧтениеXML.ТипУзла = ТипУзлаXML.Текст Тогда
			
			Если СтрНайти(ПоследнееИмяТега, "text:") <> 0 Тогда
				ИзвлеченныйТекст = ИзвлеченныйТекст + ЧтениеXML.Значение;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
#КонецЕсли

	Возврат ИзвлеченныйТекст;
	
КонецФункции

Функция ЭтоЗарезервированноеИмяКаталога(ИмяПодКаталога)
	
	СписокИмен = Новый Соответствие();
	СписокИмен.Вставить("CON", Истина);
	СписокИмен.Вставить("PRN", Истина);
	СписокИмен.Вставить("AUX", Истина);
	СписокИмен.Вставить("NUL", Истина);
	
	Возврат СписокИмен[ИмяПодКаталога] <> Неопределено;
	
КонецФункции

#КонецОбласти