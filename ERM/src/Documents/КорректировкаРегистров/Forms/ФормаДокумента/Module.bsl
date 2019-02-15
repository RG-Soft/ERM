
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Элементы.Ответственный.ТолькоПросмотр = Истина;
	// Обработчик подсистемы "Внешние обработки"
	//ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	
	Если НЕ РольДоступна("ПолныеПрава") Тогда
		Элементы.Reverse.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ПоказатьРегистры();
	
	// СтандартныеПодсистемы.Печать
	УправлениеПечатью.ПриСозданииНаСервере(ЭтаФорма, Элементы.ПодменюПечать);
	// Конец СтандартныеПодсистемы.Печать
	
	// ИнтеграцияС1СДокументооборотом
	//ИнтеграцияС1СДокументооборот.ПриСозданииНаСервере(ЭтаФорма);
	// Конец ИнтеграцияС1СДокументооборотом

	//СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

&НаКлиенте
Процедура  ПослеЗаписи(ПараметрыЗаписи)

	//МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	//МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	//МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	Если НЕ РольДоступна("ПолныеПрава") И НЕ РольДоступна("rgsСозданиеКорректировокРегистровСРеверсом") Тогда
		ТолькоПросмотр = Истина;
		Элементы.ОткрытьВыборРегистров.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)

	//МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	Если НЕ РольДоступна("ПолныеПрава") И НЕ РольДоступна("rgsСозданиеКорректировокРегистровСРеверсом") Тогда
		ТолькоПросмотр = Истина;
		Элементы.ОткрытьВыборРегистров.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//ОбщегоНазначенияКлиент.ОткрытьФормуРедактированияКомментария(Элемент.ТекстРедактирования, Объект.Комментарий, Модифицированность);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

// Подключаемый обработчик события "ПриНачалеРедактирования" таблицы формы.
//
&НаКлиенте
Процедура Подключаемый_ТаблицаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)

	Если НоваяСтрока Тогда
		Элемент.ТекущиеДанные.Период = Объект.Дата;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаДвиженийBilledARInvoiceПриИзменении(Элемент, НоваяСтрока, Копирование)

	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.Invoice) Тогда
		ДанныеИзДокумента = Новый Структура();
		ЗаполнитьДанныеИзДокумента(Элемент.Родитель.ТекущиеДанные.Invoice, ДанныеИзДокумента);
		ЗаполнитьЗначенияСвойств(Элемент.Родитель.ТекущиеДанные, ДанныеИзДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаДвиженийUnbilledARSalesOrderПриИзменении(Элемент, НоваяСтрока, Копирование)

	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.SalesOrder) Тогда
		ДанныеИзДокумента = Новый Структура();
		ЗаполнитьДанныеИзДокумента(Элемент.Родитель.ТекущиеДанные.SalesOrder, ДанныеИзДокумента);
		ЗаполнитьЗначенияСвойств(Элемент.Родитель.ТекущиеДанные, ДанныеИзДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаДвиженийUnallocatedCashCashBatchПриИзменении(Элемент, НоваяСтрока, Копирование)

	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.CashBatch) Тогда
		ДанныеИзДокумента = Новый Структура();
		ЗаполнитьДанныеИзДокумента(Элемент.Родитель.ТекущиеДанные.CashBatch, ДанныеИзДокумента);
		ЗаполнитьЗначенияСвойств(Элемент.Родитель.ТекущиеДанные, ДанныеИзДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаДвиженийManualTransactionsРучнаяКорректировкаПриИзменении(Элемент, НоваяСтрока, Копирование)

	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.РучнаяКорректировка) Тогда
		ДанныеИзДокумента = Новый Структура();
		ЗаполнитьДанныеИзДокумента(Элемент.Родитель.ТекущиеДанные.РучнаяКорректировка, ДанныеИзДокумента);
		ЗаполнитьЗначенияСвойств(Элемент.Родитель.ТекущиеДанные, ДанныеИзДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаДвиженийUnallocatedMemoMemoПриИзменении(Элемент, НоваяСтрока, Копирование)

	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.Memo) Тогда
		ДанныеИзДокумента = Новый Структура();
		ЗаполнитьДанныеИзДокумента(Элемент.Родитель.ТекущиеДанные.Memo, ДанныеИзДокумента);
		ЗаполнитьЗначенияСвойств(Элемент.Родитель.ТекущиеДанные, ДанныеИзДокумента);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ТаблицаДвиженийRevenueDocumentПриИзменении(Элемент, НоваяСтрока, Копирование)

	Если ЗначениеЗаполнено(Элемент.Родитель.ТекущиеДанные.Document) Тогда
		ДанныеИзДокумента = Новый Структура();
		ЗаполнитьДанныеИзДокумента(Элемент.Родитель.ТекущиеДанные.Document, ДанныеИзДокумента);
		ЗаполнитьЗначенияСвойств(Элемент.Родитель.ТекущиеДанные, ДанныеИзДокумента);
	КонецЕсли;

КонецПроцедуры

#Область ОбработчикиКоманд

&НаКлиенте
Процедура НастройкаСоставаРегистров(Команда)

	СписокИспользуемыхРегистров = Новый СписокЗначений;

	Для Каждого Строка Из Объект.ТаблицаРегистров Цикл
		СписокИспользуемыхРегистров.Добавить(Строка.Имя);
	КонецЦикла;

	ОткрытьФорму("Документ.КорректировкаРегистров.Форма.ФормаВыбораРегистра",
		Новый Структура("СписокИспользуемыхРегистров", СписокИспользуемыхРегистров),,,,, 
		Новый ОписаниеОповещения("НастройкаСоставаРегистровЗавершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСоставаРегистровЗавершение(Результат, ДополнительныеПараметры) Экспорт
 	
	Если ТипЗнч(Результат) = Тип("СписокЗначений") Тогда
		
		ОбработатьИзменениеРегистров(Результат);
		
		СтруктураДляПоиска = Новый Структура;
		СтруктураДляПоиска.Вставить("Имя","Revenue");
		
		Если Объект.ТаблицаРегистров.Количество() = 1 И Объект.ТаблицаРегистров.НайтиСтроки(СтруктураДляПоиска) <> Неопределено Тогда
			Объект.Reverse = Ложь;
		ИначеЕсли НЕ Объект.Reverse Тогда
			Объект.Reverse = Истина;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	//Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
	//	РезультатВыполнения = Неопределено;
	//	ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	//	ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	//КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

// ИнтеграцияС1СДокументооборотом
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуИнтеграции(Команда)
	
	//ИнтеграцияС1СДокументооборотКлиент.ВыполнитьПодключаемуюКомандуИнтеграции(Команда, ЭтаФорма, Объект);
	
КонецПроцедуры
//Конец ИнтеграцияС1СДокументооборотом

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	//СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	//ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Функция СоздатьСтраницу(ИмяСтраницы, Заголовок, Родитель)

	НовыйЭлемент = Элементы.Добавить(ИмяСтраницы, Тип("ГруппаФормы"), Родитель);
	НовыйЭлемент.Вид                      = ВидГруппыФормы.Страница;
	НовыйЭлемент.Заголовок                = Заголовок;
	НовыйЭлемент.РастягиватьПоВертикали   = Истина;
	НовыйЭлемент.РастягиватьПоГоризонтали = Истина;

	Возврат НовыйЭлемент;

КонецФункции

&НаСервере
Функция ПолучитьИмяСтраницыРегистра(ИмяРегистра)

	Возврат "Страница" + ИмяРегистра;

КонецФункции

&НаСервере
Процедура УдалитьСтраницуРегистра(ИмяРегистра)

	Элементы.Удалить(Элементы.Найти(ПолучитьИмяСтраницыРегистра(ИмяРегистра)));

КонецПроцедуры

Функция СоздатьСвязиПараметровВыбора(ИсходныйМассив, ПутьКДанным)

	НовыйМассив = Новый Массив;
	Для Каждого Элемент Из ИсходныйМассив Цикл

		НовыйМассив.Добавить(Новый СвязьПараметраВыбора(Элемент.Имя, ПутьКДанным + "." + Элемент.ПутьКДанным, Элемент.ИзменениеЗначения));

	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(НовыйМассив);

КонецФункции

&НаСервере
// Процедура создает таблицу формы.
//
Функция СоздатьТаблицуФормыРегистра(ИмяРегистра, КолонкиТаблицы, Родитель)

	ТаблицаФормы = Элементы.Добавить("ТаблицаДвижений" + ИмяРегистра, Тип("ТаблицаФормы"), Родитель);
	ТаблицаФормы.ПутьКДанным      = "Объект.Движения." + ИмяРегистра;
	Родитель.ПутьКДаннымЗаголовка = ТаблицаФормы.ПутьКДанным + ".КоличествоСтрок";

	МассивДобавленныхПолей = Новый Массив;
	Для Каждого Колонка Из КолонкиТаблицы Цикл

		ПолеФормы = Элементы.Добавить(ТаблицаФормы.Имя + Колонка.Имя, Тип("ПолеФормы"), ТаблицаФормы);
		ПолеФормы.ПутьКДанным           = ТаблицаФормы.ПутьКДанным + "." + Колонка.Имя;
		ПолеФормы.Заголовок             = Колонка.Заголовок;
		ПолеФормы.Вид                   = ВидПоляФормы.ПолеВвода;

		МассивДобавленныхПолей.Добавить(ПолеФормы);

	КонецЦикла;

	Счетчик = 0;
	Для Каждого ПолеФормы Из МассивДобавленныхПолей Цикл

		Если КолонкиТаблицы[Счетчик].СвязиПараметровВыбора <> Неопределено И  КолонкиТаблицы[Счетчик].СвязиПараметровВыбора.Количество() > 0 Тогда

			ПолеФормы.СвязиПараметровВыбора = СоздатьСвязиПараметровВыбора(КолонкиТаблицы[Счетчик].СвязиПараметровВыбора,
									 "Элементы." + ТаблицаФормы.Имя + ".ТекущиеДанные");
		КонецЕсли;

		Счетчик = Счетчик + 1;
	
	КонецЦикла;

	Возврат ТаблицаФормы;

КонецФункции

&НаСервере
// Функция создает таблицу значений по регистру.
//
Функция СоздатьМассивПолейРегистра(МенеджерРегистра, МетаданныеРегистра)

	ТаблицаРегистра = МенеджерРегистра.СоздатьНаборЗаписей().ВыгрузитьКолонки();
	ТаблицаРегистра.Колонки.Удалить("Регистратор");
	Если ТаблицаРегистра.Колонки.Найти("МоментВремени") <> Неопределено Тогда
		ТаблицаРегистра.Колонки.Удалить("МоментВремени");
	КонецЕсли;

	МассивКолонок = Новый Массив;
	Для Каждого Колонка Из ТаблицаРегистра.Колонки Цикл

		ИнформацияОКолонке = Новый Структура("Имя, Заголовок, СвязиПараметровВыбора",
				Колонка.Имя);

		МассивКолонок.Добавить(ИнформацияОКолонке);

	КонецЦикла;

	// Обновление заголовков колонок таблицы по синонимам полей регистра.
	МассивПолейРегистра = Новый Массив;
	МассивПолейРегистра.Добавить("Измерения");
	МассивПолейРегистра.Добавить("Ресурсы");
	МассивПолейРегистра.Добавить("Реквизиты");

	Для Каждого ВидПоля Из МассивПолейРегистра Цикл
		Для Каждого Поле Из МетаданныеРегистра[ВидПоля] Цикл
			Для Каждого ЭлементМассива Из МассивКолонок Цикл

				Если ЭлементМассива.Имя = Поле.Имя Тогда

					ЭлементМассива.Заголовок             = Поле.Синоним;
					ЭлементМассива.СвязиПараметровВыбора = Поле.СвязиПараметровВыбора;

				КонецЕсли;

			КонецЦикла;
		КонецЦикла;
	КонецЦикла;

	Возврат МассивКолонок;

КонецФункции

&НаСервере
// Процедура управляет созданием таблицы на форме для регистра.
//
Процедура ПоказатьТаблицуРегистраНаСтранице(Знач СтрокаТЧ)

	Если Метаданные.РегистрыНакопления.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда

		СтраницаРегистра      = Элементы.НастройкаРегистровНакопления;
		МенеджерРегистра      = РегистрыНакопления[СтрокаТЧ.Имя];
		МетаданныеРегистра    = Метаданные.РегистрыНакопления[СтрокаТЧ.Имя];
		РегистрИмеетПолеПериод= Истина;

	ИначеЕсли Метаданные.РегистрыСведений.Найти(СтрокаТЧ.Имя) <> Неопределено Тогда

		СтраницаРегистра      = Элементы.НастройкаРегистровСведений;
		МенеджерРегистра      = РегистрыСведений[СтрокаТЧ.Имя];
		МетаданныеРегистра    = Метаданные.РегистрыСведений[СтрокаТЧ.Имя];

		РегистрИмеетПолеПериод = МетаданныеРегистра.ПериодичностьРегистраСведений 
									<> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический;

	Иначе

		Возврат;

	КонецЕсли;

	МассивКолонок = СоздатьМассивПолейРегистра(МенеджерРегистра, МетаданныеРегистра);

	СтраницаДляРегистра = СоздатьСтраницу(ПолучитьИмяСтраницыРегистра(СтрокаТЧ.Имя),
				МетаданныеРегистра.Синоним,
				СтраницаРегистра);

	ТаблицаФормы = СоздатьТаблицуФормыРегистра(СтрокаТЧ.Имя, МассивКолонок, СтраницаДляРегистра);

	Если РегистрИмеетПолеПериод Тогда
		ТаблицаФормы.УстановитьДействие("ПриНачалеРедактирования", "Подключаемый_ТаблицаПриНачалеРедактирования");
	КонецЕсли;
	
	Если ТаблицаФормы.Имя = "ТаблицаДвиженийBilledAR" Тогда
		ТаблицаФормы.ПодчиненныеЭлементы.ТаблицаДвиженийBilledARInvoice.УстановитьДействие("ПриИзменении", "Подключаемый_ТаблицаДвиженийBilledARInvoiceПриИзменении");
	ИначеЕсли ТаблицаФормы.Имя  = "ТаблицаДвиженийUnbilledAR" Тогда
		ТаблицаФормы.ПодчиненныеЭлементы.ТаблицаДвиженийUnbilledARSalesOrder.УстановитьДействие("ПриИзменении", "Подключаемый_ТаблицаДвиженийUnbilledARSalesOrderПриИзменении");
	ИначеЕсли ТаблицаФормы.Имя  = "ТаблицаДвиженийUnallocatedCash" Тогда
		ТаблицаФормы.ПодчиненныеЭлементы.ТаблицаДвиженийUnallocatedCashCashBatch.УстановитьДействие("ПриИзменении", "Подключаемый_ТаблицаДвиженийUnallocatedCashCashBatchПриИзменении");
	ИначеЕсли ТаблицаФормы.Имя  = "ТаблицаДвиженийManualTransactions" Тогда
		ТаблицаФормы.ПодчиненныеЭлементы.ТаблицаДвиженийManualTransactionsРучнаяКорректировка.УстановитьДействие("ПриИзменении", "Подключаемый_ТаблицаДвиженийManualTransactionsРучнаяКорректировкаПриИзменении");
	ИначеЕсли ТаблицаФормы.Имя  = "ТаблицаДвиженийUnallocatedMemo" Тогда
		ТаблицаФормы.ПодчиненныеЭлементы.ТаблицаДвиженийUnallocatedMemoMemo.УстановитьДействие("ПриИзменении", "Подключаемый_ТаблицаДвиженийUnallocatedMemoMemoПриИзменении");
	ИначеЕсли ТаблицаФормы.Имя  = "ТаблицаДвиженийRevenue" Тогда
		ТаблицаФормы.ПодчиненныеЭлементы.ТаблицаДвиженийRevenueDocument.УстановитьДействие("ПриИзменении", "Подключаемый_ТаблицаДвиженийRevenueDocumentПриИзменении");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПоказатьРегистры()

	Для Каждого СтрокаТаб Из Объект.ТаблицаРегистров Цикл

		ПоказатьТаблицуРегистраНаСтранице(СтрокаТаб);

	КонецЦикла;

КонецПроцедуры

&НаСервере
// Процедура служит для включения/исключение регистров из списка редактируемых.
//
Процедура ОбработатьИзменениеРегистров(СписокРегистров)

	Для Каждого Элемент Из СписокРегистров Цикл

		// Нужно добавить новый регистр.
		Если Элемент.Пометка Тогда

			СтрокаТЧ = Объект.ТаблицаРегистров.Добавить();
			СтрокаТЧ.Имя = Элемент.Значение;

			ПоказатьТаблицуРегистраНаСтранице(СтрокаТЧ);

		Иначе

			Для Каждого Строка Из Объект.ТаблицаРегистров.НайтиСтроки(Новый Структура("Имя", Элемент.Значение)) Цикл
				Объект.ТаблицаРегистров.Удалить(Строка);
			КонецЦикла;

			Объект.Движения[Элемент.Значение].Очистить();
			УдалитьСтраницуРегистра(Элемент.Значение);

		КонецЕсли;

	КонецЦикла;

	Модифицированность = Истина;

КонецПроцедуры

&НаСервере
Процедура ЗаполнитьPaymentsНаСервере()
	Док = Объект.Ссылка;
	ДокОбъект = Док.ПолучитьОбъект();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	UnallocatedCash.Регистратор КАК Регистратор,
		|	UnallocatedCash.Client КАК Client,
		|	UnallocatedCash.Company КАК Company,
		|	UnallocatedCash.Source КАК Source,
		|	UnallocatedCash.Location КАК Location,
		|	UnallocatedCash.SubSubSegment КАК SubSubSegment,
		|	UnallocatedCash.CashBatch КАК CashBatch,
		|	UnallocatedCash.Account КАК Account,
		|	UnallocatedCash.Currency КАК Currency,
		|	UnallocatedCash.AU КАК AU,
		|	ВЫБОР
		|		КОГДА UnallocatedCash.ВидДвижения = ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход)
		|			ТОГДА UnallocatedCash.Amount
		|		ИНАЧЕ -UnallocatedCash.Amount
		|	КОНЕЦ КАК Amount,
		|	UnallocatedCash.Период
		|ИЗ
		|	РегистрНакопления.UnallocatedCash КАК UnallocatedCash
		|ГДЕ
		|	UnallocatedCash.Регистратор = &Регистратор";
	
	Запрос.УстановитьПараметр("Регистратор", Док);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	ПустойИнвойс = Документы.Invoice.ПустаяСсылка();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Движение = Объект.Движения.Payments.Добавить();
		Движение.Период = ВыборкаДетальныеЗаписи.Период;
		Движение.Активность = Истина;
		Движение.Source = ВыборкаДетальныеЗаписи.Source;
		Движение.Client = ВыборкаДетальныеЗаписи.Client;
		Движение.Account = ВыборкаДетальныеЗаписи.Account;
		Движение.AU = ВыборкаДетальныеЗаписи.AU;
		Движение.Company = ВыборкаДетальныеЗаписи.Company;
		Движение.Invoice = ПустойИнвойс;
		Движение.CashBatch = ВыборкаДетальныеЗаписи.CashBatch;
		Движение.SubSubSegment = ВыборкаДетальныеЗаписи.SubSubSegment;
		Движение.Location = ВыборкаДетальныеЗаписи.Location;
		Движение.Currency = ВыборкаДетальныеЗаписи.Currency;
		Движение.Amount = ВыборкаДетальныеЗаписи.Amount;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьPayments(Команда)
	
	ЗаполнитьPaymentsНаСервере();
	
	СписокИспользуемыхРегистров = Новый СписокЗначений;

	СписокИспользуемыхРегистров.Добавить("Payments", "Payments", Истина);
	
	ОбработатьИзменениеРегистров(СписокИспользуемыхРегистров);
	
	Элементы.ФормаЗаполнитьPayments.Доступность = Ложь;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ РольДоступна("ПолныеПрава") И НЕ РольДоступна("rgsСозданиеКорректировокРегистровСРеверсом") Тогда
		ТолькоПросмотр = Истина;
		Элементы.ОткрытьВыборРегистров.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьДанныеИзДокумента(Документ, ДанныеИзДокумента)
	
	ДанныеИзДокумента.Вставить("Source", Документ.Source);
	ДанныеИзДокумента.Вставить("AU", Документ.AU);
	ДанныеИзДокумента.Вставить("Account", Документ.Account);
	//Если ТипЗнч(Документ) <> Тип("ДокументСсылка.РучнаяКорректировка") Тогда
	ДанныеИзДокумента.Вставить("Client", Документ.Client);
	ДанныеИзДокумента.Вставить("ClientID", Документ.ClientID);
	//КонецЕсли;
	ДанныеИзДокумента.Вставить("Company", Документ.Company);
	ДанныеИзДокумента.Вставить("Currency", Документ.Currency);
	ДанныеИзДокумента.Вставить("Location", Документ.Location);
	ДанныеИзДокумента.Вставить("SubSubSegment", Документ.SubSubSegment);
	ДанныеИзДокумента.Вставить("Amount", Документ.Amount);
	
КонецПроцедуры
