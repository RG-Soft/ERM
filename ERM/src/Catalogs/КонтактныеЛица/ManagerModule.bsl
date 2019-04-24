#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт

КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

#Область PowerBI

// Описание
// Выполняет выгрузку данных в Power BI
// Параметры:
// 	Ссылка - Ссылка на данные, которые нужно выгрузить
// 	Операция - вид операции с данными
// Возвращаемое значение:
// 	Структура - включает поля Результат, Сообщение.
Функция ВыгрузитьДанныеДляPowerBI(Ссылка, Операция, ПараметрыЛогирования) Экспорт
	
	СтруктураРезультата = Новый Структура("Результат, Сообщение", Ложь, "");
	
	ТекОбъект = PowerBIРегламенты.ПолучитьОбъектИзВнешнегоИсточника("dbo_ContactPersons", Операция, Ссылка, ПараметрыЛогирования);
	
	ЗаполнитьОбъектPowerBI(ТекОбъект, Ссылка);
	
	PowerBIРегламенты.ЗаписатьОбъектВоВнешнийИсточник(ТекОбъект, ПараметрыЛогирования, СтруктураРезультата);
	
	Если НЕ ЗначениеЗаполнено(СтруктураРезультата.Сообщение) Тогда
		СтруктураРезультата.Результат = Истина;
	КонецЕсли;
	
	Возврат СтруктураРезультата;
	
КонецФункции

Процедура ЗаполнитьОбъектPowerBI(Объект, Ссылка)

	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	КонтактныеЛица.Должность КАК Position,
		|	КонтактныеЛица.Наименование КАК Description,
		|	КонтактныеЛица.ОбъектВладелец КАК ОбъектВладелец,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА КонтактныеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонРабочийКонтактныеЛица)
		|				ТОГДА КонтактныеЛицаКонтактнаяИнформация.Представление
		|			ИНАЧЕ """"
		|		КОНЕЦ) КАК WorkPhone,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА КонтактныеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонМобильныйКонтактныеЛица)
		|				ТОГДА КонтактныеЛицаКонтактнаяИнформация.Представление
		|			ИНАЧЕ """"
		|		КОНЕЦ) КАК MobilePhone,
		|	МАКСИМУМ(ВЫБОР
		|			КОГДА КонтактныеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресДляИнформированияКонтактныеЛица)
		|				ТОГДА КонтактныеЛицаКонтактнаяИнформация.Представление
		|			ИНАЧЕ """"
		|		КОНЕЦ) КАК Address,
		|	КонтактныеЛица.ПометкаУдаления КАК DeletionMark,
		|	КонтактныеЛица.Код КАК Code,
		|	ПРЕДСТАВЛЕНИЕ(КонтактныеЛица.ВидКонтактногоЛица) КАК Type
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КонтактныеЛица.КонтактнаяИнформация КАК КонтактныеЛицаКонтактнаяИнформация
		|		ПО КонтактныеЛица.Ссылка = КонтактныеЛицаКонтактнаяИнформация.Ссылка
		|			И (КонтактныеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонРабочийКонтактныеЛица)
		|				ИЛИ КонтактныеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.ТелефонМобильныйКонтактныеЛица)
		|				ИЛИ КонтактныеЛицаКонтактнаяИнформация.Вид = ЗНАЧЕНИЕ(Справочник.ВидыКонтактнойИнформации.АдресДляИнформированияКонтактныеЛица))
		|ГДЕ
		|	КонтактныеЛица.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	КонтактныеЛица.Должность,
		|	КонтактныеЛица.Наименование,
		|	КонтактныеЛица.ВидКонтактногоЛица,
		|	КонтактныеЛица.ОбъектВладелец,
		|	КонтактныеЛица.Ссылка,
		|	КонтактныеЛица.ПометкаУдаления,
		|	КонтактныеЛица.Код";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ВыборкаДетальныеЗаписи.Следующий();
	
	ЗаполнитьЗначенияСвойств(Объект, ВыборкаДетальныеЗаписи);
	Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ОбъектВладелец) Тогда
		Объект.ClientID = Строка(ВыборкаДетальныеЗаписи.ОбъектВладелец.УникальныйИдентификатор());
	Иначе
		Объект.ClientID = NULL;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


Функция ПолучитьКоличествоПодчиненныхЭлементовПоВладельцу(Владелец) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	КонтактныеЛица.Ссылка
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|ГДЕ
	|	КонтактныеЛица.ОбъектВладелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", Владелец);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Количество();

КонецФункции

Функция КонтактноеЛицоПоУмолчанию(Владелец) Экспорт

	Если ТипЗнч(Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
		ОсновноеКонтактноеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Владелец, "ОсновноеКонтактноеЛицо");
	КонецЕсли;

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("ОсновноеКонтактноеЛицо", ОсновноеКонтактноеЛицо);
	
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ ПЕРВЫЕ 2
	|	КонтактныеЛица.Ссылка,
	|	ВЫБОР
	|		КОГДА КонтактныеЛица.Ссылка = &ОсновноеКонтактноеЛицо
	|			ТОГДА 1
	|		ИНАЧЕ 2
	|	КОНЕЦ КАК ПорядокСортировки
	|ИЗ
	|	Справочник.КонтактныеЛица КАК КонтактныеЛица
	|ГДЕ
	|	КонтактныеЛица.ОбъектВладелец = &Владелец
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПорядокСортировки";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.КонтактныеЛица.ПустаяСсылка();

КонецФункции

Функция СписокКонтактныхЛиц(Контрагент, ФИОКратко = Истина) Экспорт
	
	Список = Новый СписокЗначений();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.Текст = "ВЫБРАТЬ
		|	КонтактныеЛица.*
		|ИЗ
		|	Справочник.КонтактныеЛица КАК КонтактныеЛица
		|ГДЕ
		|	КонтактныеЛица.ОбъектВладелец = &Контрагент";
		
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
	Пока РезультатЗапроса.Следующий() Цикл
		
		Представление = "";
		Если ЗначениеЗаполнено(РезультатЗапроса.Фамилия) Тогда

			Представление = ОбщегоНазначенияВызовСервера.ПолучитьФамилиюИмяОтчество(
				РезультатЗапроса.Фамилия, 
				РезультатЗапроса.Имя,
				РезультатЗапроса.Отчество,
				ФИОКратко);
				
			Если ЗначениеЗаполнено(РезультатЗапроса.Должность) Тогда
				Представление = Представление + ", " + РезультатЗапроса.Должность;
			КонецЕсли;
		ИначеЕсли ЗначениеЗаполнено(РезультатЗапроса.Наименование) Тогда
			Представление = РезультатЗапроса.Наименование;
			Если ЗначениеЗаполнено(РезультатЗапроса.Должность) Тогда
				Представление = Представление + ", " + РезультатЗапроса.Должность;
			КонецЕсли;
		КонецЕсли;
			
		Если ЗначениеЗаполнено(Представление) Тогда 
			Список.Добавить(РезультатЗапроса.Ссылка, Представление);
		КонецЕсли;

	КонецЦикла;
	
	Возврат Список;

КонецФункции

// ПРОЦЕДУРЫ И ФУНКЦИИ ПЕЧАТИ

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	
КонецПроцедуры

#КонецЕсли