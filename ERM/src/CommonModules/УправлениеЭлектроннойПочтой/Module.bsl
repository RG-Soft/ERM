#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОчередьЗаданийПереопределяемый.ПриПолученииСпискаШаблонов.
Процедура ПриПолученииСпискаШаблонов(ШаблоныЗаданий) Экспорт
	
	ШаблоныЗаданий.Добавить("ПолучениеИОтправкаЭлектронныхПисем");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьТекстПисьма(Письмо, Сообщение) Экспорт
	
	ТекстHTML = "";
	ТекстПростой = "";
	ТекстРазмеченный = "";

	Для Каждого ТекстПочтовогоСообщения Из Сообщение.Тексты Цикл
		Если ТекстПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.HTML Тогда
			
			ТекстHTML = ТекстHTML + ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ТекстПочтовогоСообщения.Текст);
			
		ИначеЕсли ТекстПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.ПростойТекст Тогда
			
			ТекстПростой = ТекстПростой + ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ТекстПочтовогоСообщения.Текст);
			
		ИначеЕсли ТекстПочтовогоСообщения.ТипТекста = ТипТекстаПочтовогоСообщения.РазмеченныйТекст Тогда
			ТекстРазмеченный = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(ТекстПочтовогоСообщения.Текст);
			
		КонецЕсли;
	КонецЦикла;
	
	Если ТекстHTML <> "" Тогда
		Письмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.HTML;
		Письмо.ТекстHTML = ТекстHTML;
		Письмо.Текст = ?(ТекстПростой <> "", ТекстПростой, ПолучитьПростойТекстИзHTML(ТекстHTML));
		
	ИначеЕсли ТекстРазмеченный <> "" Тогда
		Письмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.РазмеченныйТекст;
		Письмо.Текст = ТекстРазмеченный;
		
	Иначе
		Письмо.ТипТекста = Перечисления.ТипыТекстовЭлектронныхПисем.ПростойТекст;
		Письмо.Текст = ТекстПростой;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПолучитьПростойТекстИзHTML(ТекстHTML)
	
	Построитель = Новый ПостроительDOM;
	ЧтениеHTML = Новый ЧтениеHTML;
	ЧтениеHTML.УстановитьСтроку(ТекстHTML);
	ДокументHTML = Построитель.Прочитать(ЧтениеHTML);
	
	Возврат ДокументHTML.Тело.ТекстовоеСодержимое;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Работа с вложения электронных писем.

Функция ИнтернетПочтовоеСообщениеИзДвоичныхДанных(ДвоичныеДанные) 
	
	ПочтовоеСообщение = Новый ИнтернетПочтовоеСообщение;
	ПочтовоеСообщение.УстановитьИсходныеДанные(ДвоичныеДанные);
	
	Возврат ПочтовоеСообщение;
	
КонецФункции

Процедура ЗаписатьВложениеЭлектронногоПисьма(Объект, Вложение,МассивПодписей,КоличествоПустыхИменВоВложениях)
	
	ПисьмоСсылка = Объект.Ссылка;
	Размер = 0;
	ЭтоВложениеПисьмо = Ложь;
	
	Если ТипЗнч(Вложение.Данные) = Тип("ДвоичныеДанные") Тогда
		
		ДанныеВложения = Вложение.Данные;
		ИмяФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Вложение.ИмяФайла, "");
		ЭтоВложениеПисьмо = ФайлЯвляетсяЭлектроннымПисьмом(ИмяФайла, ДанныеВложения);
		
	Иначе
		
		ДанныеВложения = Вложение.Данные.ПолучитьИсходныеДанные();
		ИмяФайла = ВзаимодействияКлиентСервер.ПредставлениеПисьма(Вложение.Данные.Тема, Вложение.Данные.ДатаПолучения) + ".eml";
		ЭтоВложениеПисьмо = Истина;
		
	КонецЕсли;
	
	Размер = ДанныеВложения.Размер();
	Адрес = ПоместитьВоВременноеХранилище(ДанныеВложения, "");
	
	Если Не ПустаяСтрока(Вложение.Идентификатор) Тогда
		
		Если СтрНайти(Объект.ТекстHTML, Вложение.Идентификатор) = 0 Тогда
			
			Вложение.Идентификатор = "";
			
		ИначеЕсли СтрНайти(Объект.ТекстHTML, Вложение.Имя) > 0 
			И СтрНайти(Вложение.Идентификатор, Вложение.Имя + "@") = 0 Тогда
		
			Вложение.Идентификатор = "";
			
		КонецЕсли;
		
	КонецЕсли;
	
	ВложениеПисьмаСсылка = ЗаписатьВложениеЭлектронногоПисьмаИзВременногоХранилища(
		ПисьмоСсылка, Адрес, ИмяФайла, Размер,КоличествоПустыхИменВоВложениях);
	
	ЕстьПодписи = (МассивПодписей.Количество() > 0);
	ЭтоОтображаемыйФайл = НЕ ПустаяСтрока(Вложение.Идентификатор);
	
	Если ЕстьПодписи 
		Или ЭтоОтображаемыйФайл
		Или ЭтоВложениеПисьмо Тогда
		
		ВложениеПисьмаОбъект = ВложениеПисьмаСсылка.ПолучитьОбъект();
		
		Если ЕстьПодписи
		   И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
			
			МодульЭлектроннаяПодпись = ОбщегоНазначения.ОбщийМодуль("ЭлектроннаяПодпись");
			
			Для Каждого ПодписьВложения Из МассивПодписей Цикл
				ЭП = ВложениеПисьмаОбъект.ЭлектронныеПодписи.Добавить();
				
				ДанныеПодписи = МодульЭлектроннаяПодпись.ПрочитатьДанныеПодписи(ПодписьВложения.Данные);
				Если ДанныеПодписи <> Неопределено Тогда
					ЗаполнитьЗначенияСвойств(ЭП, ДанныеПодписи);
				КонецЕсли;
				
				ЭП.Подпись = Новый ХранилищеЗначения(ПодписьВложения.Данные);
				ЭП.Комментарий = НСтр("ru = 'Вложение электронного письма'");
				ЭП.ДатаПодписи = ТекущаяДатаСеанса();
			КонецЦикла;
			
			ВложениеПисьмаОбъект.ПодписанЭП = Истина;
			
		КонецЕсли;
		
		Если ЭтоОтображаемыйФайл Тогда
			
			ВложениеПисьмаОбъект.ИДФайлаЭлектронногоПисьма = Вложение.Идентификатор;
			
		КонецЕсли;
		
		Если ЭтоВложениеПисьмо Тогда
			
			ВложениеПисьмаОбъект.ЭтоВложениеПисьмо = Истина;
			
		КонецЕсли;
		
		ВложениеПисьмаОбъект.Записать();
		
	КонецЕсли;
	
	УдалитьИзВременногоХранилища(Адрес);
	
КонецПроцедуры

// Получает вложения электронного письма.
//
// Параметры:
//  Письмо                         - ДокументСсылка - документ электронное письмо для которого необходимо получить вложения.
//  ФормироватьРазмерПредставление - Булево - признак того, что в результате запроса будет пустая строковая колонка РазмерПредставление.
//  ТолькоСПустымИД                - Булево - если Истина, то будут получены только вложения без ИДФайлаЭлектронногоПисьма.
//
// Возвращаемое значение:
//  ТаблицаЗначений   - таблица значений, содержащая информацию о вложениях.
//
Функция ПолучитьВложенияЭлектронногоПисьма(Письмо,ФормироватьРазмерПредставление = Ложь, ТолькоСПустымИД = Ложь) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДанныеПрисоединенныхФайловПисьма = Взаимодействия.ДанныеПрисоединенныхФайловПисьма(Письмо);
	ИмяОбъектаМетаданных = ДанныеПрисоединенныхФайловПисьма.ИмяСправочникаПрисоединенныхФайлов;
	ВладелецФайлов       = ДанныеПрисоединенныхФайловПисьма.ВладелецФайлов;
	
	Если ИмяОбъектаМетаданных = Неопределено Тогда
		Возврат Новый ТаблицаЗначений;
	КонецЕсли;
	
	Если ФормироватьРазмерПредставление Тогда
		ТекстРазмерПредставление = ",
		|ВЫРАЗИТЬ("""" КАК СТРОКА(20)) КАК РазмерПредставление";
	Иначе
		ТекстРазмерПредставление = "";
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Файлы.Ссылка                    КАК Ссылка,
	|	Файлы.ИндексКартинки            КАК ИндексКартинки,
	|	Файлы.Размер                    КАК Размер,
	|	Файлы.ИДФайлаЭлектронногоПисьма КАК ИДФайлаЭлектронногоПисьма,
	|	&ПодписанЭП                     КАК ПодписанЭП,
	|	ВЫБОР
	|		КОГДА Файлы.Расширение = &ПустаяСтрока
	|			ТОГДА Файлы.Наименование
	|		ИНАЧЕ Файлы.Наименование + ""."" + Файлы.Расширение
	|	КОНЕЦ КАК ИмяФайла" + ТекстРазмерПредставление + "
	|ИЗ
	|	Справочник." + ИмяОбъектаМетаданных + " КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &Письмо
	|	И НЕ Файлы.ПометкаУдаления";
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЭлектроннаяПодпись") Тогда
		СтрокаПодписанЭП = "Файлы.ПодписанЭП";
	Иначе
		СтрокаПодписанЭП = "ЛОЖЬ";
	КонецЕсли;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст, "&ПодписанЭП", СтрокаПодписанЭП);
	
	Если ТолькоСПустымИД Тогда
		Запрос.Текст = Запрос.Текст + "
		| И Файлы.ИДФайлаЭлектронногоПисьма = """""; 
	КонецЕсли;
	
	Запрос.УстановитьПараметр("Письмо", ВладелецФайлов);
	Запрос.УстановитьПараметр("ПустаяСтрока","");
	
	ТаблицаКВозврату =  Запрос.Выполнить().Выгрузить();
	
	Если ФормироватьРазмерПредставление Тогда
		Для каждого СтрокаТаблицы Из ТаблицаКВозврату Цикл
		
			СтрокаТаблицы.РазмерПредставление = 
				ВзаимодействияКлиентСервер.ПолучитьСтроковоеПредставлениеРазмераФайла(СтрокаТаблицы.Размер);
		
		КонецЦикла;
	КонецЕсли;
	
	ТаблицаКВозврату.Индексы.Добавить("ИДФайлаЭлектронногоПисьма");
	
	Возврат ТаблицаКВозврату;
	
КонецФункции

// Записывает вложение электронного письма, расположенное во временном хранилище в файл.
Функция ЗаписатьВложениеЭлектронногоПисьмаИзВременногоХранилища(
	Письмо,
	АдресВоВременномХранилище,
	ИмяФайла,
	Размер,
	КоличествоПустыхИменВоВложениях = 0) Экспорт
	
	ИмяФайлаДляРазбора = ИмяФайла;
	РасширениеБезТочки = ВзаимодействияКлиентСервер.РасширениеФайла(ИмяФайлаДляРазбора);
	ИмяБезРасширения = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(ИмяФайлаДляРазбора);
	
	Если ПустаяСтрока(ИмяБезРасширения) Тогда
		
		ИмяБезРасширения =
			НСтр("ru = 'Вложение без имени'") + ?(КоличествоПустыхИменВоВложениях = 0, ""," " + Строка(КоличествоПустыхИменВоВложениях + 1));
		КоличествоПустыхИменВоВложениях = КоличествоПустыхИменВоВложениях + 1;
		
	Иначе
		ИмяБезРасширения =
			?(РасширениеБезТочки = "",
			ИмяБезРасширения,
			Лев(ИмяБезРасширения, СтрДлина(ИмяБезРасширения) - СтрДлина(РасширениеБезТочки) - 1));
	КонецЕсли;
		
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов",              Письмо);
	ПараметрыФайла.Вставить("Автор",                       Неопределено);
	ПараметрыФайла.Вставить("ИмяБезРасширения",            ИмяБезРасширения);
	ПараметрыФайла.Вставить("РасширениеБезТочки",          РасширениеБезТочки);
	ПараметрыФайла.Вставить("ВремяИзменения",              Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
	Возврат РаботаСФайлами.ДобавитьФайл(
		ПараметрыФайла,
		АдресВоВременномХранилище,
		"");
	
КонецФункции

// Записывает вложение электронного письма, копируя вложение другого письма.
Функция ЗаписатьВложениеЭлектронногоПисьмаСкопировавВложениеДругогоПисьма(
	Письмо,
	СсылкаНаФайл,
	УникальныйИдентификаторФормы) Экспорт
	
	ДанныеФайла = РаботаСФайлами.ДанныеФайла(
		СсылкаНаФайл, УникальныйИдентификаторФормы, Истина);
	
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов",              Письмо);
	ПараметрыФайла.Вставить("Автор",                       Неопределено);
	ПараметрыФайла.Вставить("ИмяБезРасширения",            ДанныеФайла.Наименование);
	ПараметрыФайла.Вставить("РасширениеБезТочки",          ДанныеФайла.Расширение);
	ПараметрыФайла.Вставить("ВремяИзменения",              Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", ДанныеФайла.ДатаМодификацииУниверсальная);
	Возврат РаботаСФайлами.ДобавитьФайл(
		ПараметрыФайла,
		ДанныеФайла.СсылкаНаДвоичныеДанныеФайла,
		"");
	
КонецФункции

// Устанавливает или снимает пометку удаления у вложений электронного письма.
//
// Параметры:
//  Письмо          - ДокументСсылка - письмо, для вложений которого будут выполнены действия.
//  ПометкаУдаления - Булево - признак необходимости установить или снять пометку.
//
Процедура УстановитьПометкуУдаленияУВложенийПисьма(Письмо, ПометкаУдаления) Экспорт

	УстановитьПривилегированныйРежим(Истина);
	
	ИмяОбъектаМетаданных = ИмяОбъектаМетаданныхПрисоединенныхФайловПисьма(Письмо);
	Если ИмяОбъектаМетаданных = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	Файлы.Ссылка
	|ИЗ
	|	Справочник." + ИмяОбъектаМетаданных + " КАК Файлы
	|ГДЕ
	|	Файлы.ПометкаУдаления <> &ПометкаУдаления
	|	И Файлы.ВладелецФайла = &ВладелецФайла
	|");
	Запрос.УстановитьПараметр("ПометкаУдаления", ПометкаУдаления);
	Запрос.УстановитьПараметр("ВладелецФайла", Письмо);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.УстановитьПометкуУдаления(ПометкаУдаления, Истина);
	КонецЦикла;

КонецПроцедуры

// Удаляет вложения электронного письма.
//
// Параметры:
//  Письмо - ДокументСсылка - письмо, вложения которого будут удалены.
//
Процедура УдалитьВложенияУПисьма(Письмо) Экспорт

	ИмяОбъектаМетаданных = ИмяОбъектаМетаданныхПрисоединенныхФайловПисьма(Письмо);
	Если ИмяОбъектаМетаданных = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Файлы.Ссылка
	|ИЗ
	|	Справочник." + ИмяОбъектаМетаданных + " КАК Файлы
	|ГДЕ
	|	Файлы.ВладелецФайла = &ВладелецФайла";
	Запрос.УстановитьПараметр("ВладелецФайла", Письмо);
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.Удалить();
	КонецЦикла;
	
КонецПроцедуры

// Проверяет, являются ли двоичные данные при десериализации ИнтернетПочтовоеСообщение.
//
// Параметры:
//  ДвоичныеДанные  - ДвоичныеДанные - проверяемые двоичные данные.
//
// Возвращаемое значение:
//   Булево   - Истина, если двоичные данные корректно десериализуются в объект ИнтернетПочтовоеСообщение.
//
Функция ДвоичныеДанныеКорректноеИнтернетПочтовоеСообщение(ДвоичныеДанные)
	
	ПочтовоеСообщение = ИнтернетПочтовоеСообщениеИзДвоичныхДанных(ДвоичныеДанные);
	Возврат ПочтовоеСообщение.СтатусРазбора = СтатусРазбораИнтернетПочтовогоСообщения.ОшибокНеОбнаружено;
	
КонецФункции

Функция ФайлЯвляетсяЭлектроннымПисьмом(ИмяФайла, ДвоичныеДанные) Экспорт
	
	Если ВзаимодействияКлиентСервер.ЭтоФайлПисьмо(ИмяФайла)
		И ДвоичныеДанныеКорректноеИнтернетПочтовоеСообщение(ДвоичныеДанные) Тогда
		
		Возврат Истина;
		
	Иначе
		
		Возврат Ложь;
		
	КонецЕсли;
	
КонецФункции

// Получает имя объекта метаданных присоединенных файлов электронного письма.
//
// Параметры:
//  Письмо  - ДокументСсылка - письмо для которого определяется имя.
//
// Возвращаемое значение:
//  Строка,Неопределено  - имя объекта метаданных присоединенных файлов электронного письма.
Функция ИмяОбъектаМетаданныхПрисоединенныхФайловПисьма(Письмо) Экспорт

	Возврат rgsУправлениеЭлектроннойПочтой.ИмяОбъектаМетаданныхПрисоединенныхФайловПисьма(Письмо);

КонецФункции

Процедура ЗаписатьИдентификаторПолученногоПисьма(УчетнаяЗапись, Идентификатор, ДатаПолучения) Экспорт

	Запись = РегистрыСведений.ИдентификаторыПолученныхЭлектронныхПисем.СоздатьМенеджерЗаписи();
	Запись.УчетнаяЗапись = УчетнаяЗапись;
	Запись.Идентификатор = Идентификатор;
	Запись.ДатаПолучения = ДатаПолучения;
	Запись.Записать();

КонецПроцедуры

#КонецОбласти
