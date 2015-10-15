﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Заполняет список всех возможных областей для поиска дублей.
//
// Параметры:
//   УчитыватьПрикладныеПравила - Булево - Флаг необходимости поиска прикладных правил поиска дублей.
//
// Возвращаемое значение:
//   СписокЗначений - Заполняемый список, в котором устанавливаются:
//       * Значение      - Строка   - Полное имя метаданных объекта-таблицы.
//       * Представление - Строка   - Представление для пользователя.
//       * Картинка      - Картинка - Соответствующая картинка из платформенной библиотеки.
//       * Пометка       - Булево   - Флаг наличия прикладных правил поиска дублей. 
//                                    Устанавливается только если второй параметр равен Истина.//
//
Функция ОбластиПоискаДублей(Знач УчитыватьПрикладныеПравила = Ложь) Экспорт
	Результат = Новый СписокЗначений;
	
	Если УчитыватьПрикладныеПравила Тогда
		ОбъектыСПоискомДублей = Новый Соответствие;
		ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей(ОбъектыСПоискомДублей);
	Иначе
		ОбъектыСПоискомДублей = Неопределено;
	КонецЕсли;
	ГруппаОбластейПоискаДублей(Результат, ОбъектыСПоискомДублей, УчитыватьПрикладныеПравила, Справочники,             "Справочник");
	ГруппаОбластейПоискаДублей(Результат, ОбъектыСПоискомДублей, УчитыватьПрикладныеПравила, ПланыВидовХарактеристик, "ПланВидовХарактеристик");
	ГруппаОбластейПоискаДублей(Результат, ОбъектыСПоискомДублей, УчитыватьПрикладныеПравила, ПланыСчетов,             "ПланСчетов");
	ГруппаОбластейПоискаДублей(Результат, ОбъектыСПоискомДублей, УчитыватьПрикладныеПравила, ПланыВидовРасчета,       "ПланВидовРасчета");
	
	Возврат Результат;
КонецФункции

// Определение менеджера объекта для вызова прикладных правил.
// 
// Параметры:
//     ИмяОбластиПоискаДанных - Строка - Имя области (полное имя метаданных).
//
// Возвращаемое значение:
//     СправочникиМенеджер, ПланыВидовХарактеристик.Менеджер, ПланыСчетовПланыВидовРасчета.Менеджер
//
Функция МенеджерОбластиПоискаДублей(Знач ИмяОбластиПоискаДанных) Экспорт
	Мета = Метаданные.НайтиПоПолномуИмени(ИмяОбластиПоискаДанных);
	
	Если Метаданные.Справочники.Содержит(Мета) Тогда
		Возврат Справочники[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовХарактеристик.Содержит(Мета) Тогда
		Возврат ПланыВидовХарактеристик[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыСчетов.Содержит(Мета) Тогда
		Возврат ПланыСчетов[Мета.Имя];
		
	ИначеЕсли Метаданные.ПланыВидовРасчета.Содержит(Мета) Тогда
		Возврат ПланыВидовРасчета[Мета.Имя];
		
	КонецЕсли;
	
	ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Неизвестный тип объекта метаданных ""%1""'"), ИмяОбластиПоискаДанных);
КонецФункции

// Обработчик фонового поиска дублей.
//
// Параметры:
//     Параметры       - Структура - Данные для анализа.
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата.
//
Процедура ФоновыйПоискДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	// Собираем компоновщик повторно через схему и настройки.
	КомпоновщикПредварительногоОтбора = Новый КомпоновщикНастроекКомпоновкиДанных;
	
	КомпоновщикПредварительногоОтбора.Инициализировать( Новый ИсточникДоступныхНастроекКомпоновкиДанных(Параметры.СхемаКомпоновки) );
	КомпоновщикПредварительногоОтбора.ЗагрузитьНастройки(Параметры.НастройкиКомпоновщикаПредварительногоОтбора);
	
	Параметры.Вставить("КомпоновщикПредварительногоОтбора", КомпоновщикПредварительногоОтбора);
	
	// Преобразуем правила поиска в таблицу значений с индексом.
	ПравилаПоиска = Новый ТаблицаЗначений;
	ПравилаПоиска.Колонки.Добавить("Реквизит", Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Колонки.Добавить("Правило",  Новый ОписаниеТипов("Строка") );
	ПравилаПоиска.Индексы.Добавить("Реквизит");
	
	Для Каждого Правило Из Параметры.ПравилаПоиска Цикл
		ЗаполнитьЗначенияСвойств(ПравилаПоиска.Добавить(), Правило);
	КонецЦикла;
	Параметры.Вставить("ПравилаПоиска", ПравилаПоиска);
	
	Параметры.Вставить("РассчитыватьМестаИспользования", Истина);
	
	// Запускаем поиск
	ПоместитьВоВременноеХранилище(ГруппыДублей(Параметры), АдресРезультата);
КонецПроцедуры

// Обработчик фонового удаления дублей.
//
// Параметры:
//     Параметры       - Структура - Данные для анализа.
//     АдресРезультата - Строка    - Адрес во временном хранилище для сохранения результата.
//
Процедура ФоновоеУдалениеДублей(Знач Параметры, Знач АдресРезультата) Экспорт
	
	ПараметрыЗамены = Новый Структура;
	ПараметрыЗамены.Вставить("СпособУдаления",       Параметры.СпособУдаления);
	ПараметрыЗамены.Вставить("ВключатьБизнесЛогику", Истина);
	ПараметрыЗамены.Вставить("УчитыватьПрикладныеПравила", Параметры.УчитыватьПрикладныеПравила);
	
	ЗаменитьСсылки(Параметры.ПарыЗамен, ПараметрыЗамены, АдресРезультата);
	
КонецПроцедуры

// Непосредственный поиск дублей.
//
// Параметры:
//     ПараметрыПоиска - Структура - Описывает параметры поиска.
//     ЭталонныйОбъект - Произвольный - Объект для сравнения при поиски похожих элементов.
//
// Возвращаемое значение:
//     ТаблицаЗначений - Реализация дерева значений через Ссылка и Родитель, 
//                       верхний уровень - группы, нижний - найденные дубли.
//
Функция ГруппыДублей(Знач ПараметрыПоиска, Знач ЭталонныйОбъект = Неопределено) Экспорт
	Перем РазмерВозвращаемойПорции, РассчитыватьМестаИспользования;
	
	// 1. Определяем параметры с учетом прикладного кода.
	
	ПараметрыПоиска.Свойство("МаксимальноеЧислоДублей", РазмерВозвращаемойПорции);
	Если Не ЗначениеЗаполнено(РазмерВозвращаемойПорции) Тогда
		// Все найденные
		РазмерВозвращаемойПорции = 0;
	КонецЕсли;
	
	Если Не ПараметрыПоиска.Свойство("РассчитыватьМестаИспользования", РассчитыватьМестаИспользования) Тогда
		РассчитыватьМестаИспользования = Ложь;
	КонецЕсли;
	
	// Для передачи в прикладной код.
	ДополнительныеПараметры = Неопределено;
	ПараметрыПоиска.Свойство("ДополнительныеПараметры", ДополнительныеПараметры);
	
	// Вызываем прикладной код
	ИспользоватьПрикладныеПравила = ПараметрыПоиска.УчитыватьПрикладныеПравила И ЕстьПрикладныеПравилаОбластиПоискаДублей(ПараметрыПоиска.ОбластьПоискаДублей);
	
	ПоляСравненияНаРавенство = "";	// Имена реквизитов, по которым сравниваем по равенству.
	ПоляСравненияНаПодобие   = "";	// Имена реквизитов, по которым будем нечетко сравнивать.
	ПоляДополнительныхДанных = "";	// Имена реквизитов, дополнительно заказанные прикладными правилами.
	РазмерПрикладнойПорции   = 0;	// Сколько отдавать в прикладные правила для расчета.
	
	Если ИспользоватьПрикладныеПравила Тогда
		ПрикладныеПараметры = Новый Структура;
		ПрикладныеПараметры.Вставить("ПравилаПоиска",        ПараметрыПоиска.ПравилаПоиска);
		ПрикладныеПараметры.Вставить("ОграниченияСравнения", Новый Массив);
		ПрикладныеПараметры.Вставить("КомпоновщикОтбора",    ПараметрыПоиска.КомпоновщикПредварительногоОтбора);
		ПрикладныеПараметры.Вставить("КоличествоЭлементовДляСравнения", 1000);
		
		МенеджерОбластиПоиска = МенеджерОбластиПоискаДублей(ПараметрыПоиска.ОбластьПоискаДублей);
		МенеджерОбластиПоиска.ПараметрыПоискаДублей(ПрикладныеПараметры, ДополнительныеПараметры);
		
		ВсеДополнительныеПоля = Новый Соответствие;
		Для Каждого Ограничение Из ПрикладныеПараметры.ОграниченияСравнения Цикл
			Для Каждого КлючЗначение Из Новый Структура(Ограничение.ДополнительныеПоля) Цикл
				ИмяПоля = КлючЗначение.Ключ;
				Если ВсеДополнительныеПоля[ИмяПоля] = Неопределено Тогда
					ПоляДополнительныхДанных = ПоляДополнительныхДанных + ", " + ИмяПоля;
					ВсеДополнительныеПоля[ИмяПоля] = Истина;
				КонецЕсли; 
			КонецЦикла;
		КонецЦикла;
		ПоляДополнительныхДанных = Сред(ПоляДополнительныхДанных, 2);
		
		// Сколько отдавать в прикладные правила для расчета.
		РазмерПрикладнойПорции = ПрикладныеПараметры.КоличествоЭлементовДляСравнения;
	КонецЕсли;
	
	// Списки полей, возможно измененные прикладным кодом.
	Для Каждого Строка Из ПараметрыПоиска.ПравилаПоиска Цикл
		Если Строка.Правило = "Равно" Тогда
			ПоляСравненияНаРавенство = ПоляСравненияНаРавенство + ", " + Строка.Реквизит;
		ИначеЕсли Строка.Правило = "Подобно" Тогда
			ПоляСравненияНаПодобие = ПоляСравненияНаПодобие + ", " + Строка.Реквизит;
		КонецЕсли
	КонецЦикла;
	ПоляСравненияНаРавенство = Сред(ПоляСравненияНаРавенство, 2);
	ПоляСравненияНаПодобие   = Сред(ПоляСравненияНаПодобие, 2);
	
	// 2. Конструируем по возможно измененному компоновщику условия отбора.
	Фильтр = ФильтрПоискаПоКомпоновщику(ПараметрыПоиска.КомпоновщикПредварительногоОтбора);
	
	МетаданныеТаблицы = Метаданные.НайтиПоПолномуИмени(ПараметрыПоиска.ОбластьПоискаДублей);
	Характеристики= Новый Структура("ДлинаКода, ДлинаНаименования, Иерархический, ВидИерархии", 0, 0, Ложь);
	ЗаполнитьЗначенияСвойств(Характеристики, МетаданныеТаблицы);
	
	ЕстьНаименование = Характеристики.ДлинаНаименования > 0;
	ЕстьКод          = Характеристики.ДлинаКода > 0;
	
	Если Характеристики.Иерархический И Характеристики.ВидИерархии = Метаданные.СвойстваОбъектов.ВидИерархии.ИерархияГруппИЭлементов Тогда
		// Среди групп не ищем
		Если ПустаяСтрока(Фильтр.Текст) Тогда
			Фильтр.Текст = "НЕ ЭтоГруппа";
		Иначе
			Фильтр.Текст = "НЕ ЭтоГруппа И (" + Фильтр.Текст + ")";
		КонецЕсли;
	КонецЕсли;
	
	// Дополнительные поля могут пересекаться с остальными, им надо дать псевдонимы.
	ТаблицаКандидатов = Новый ТаблицаЗначений;
	КолонкиКандидатов = ТаблицаКандидатов.Колонки;
	КолонкиКандидатов.Добавить("Ссылка1");
	КолонкиКандидатов.Добавить("Поля1");
	КолонкиКандидатов.Добавить("Ссылка2");
	КолонкиКандидатов.Добавить("Поля2");
	КолонкиКандидатов.Добавить("ЭтоДубли", Новый ОписаниеТипов("Булево"));
	ТаблицаКандидатов.Индексы.Добавить("ЭтоДубли");
	
	РасшифровкаДополнительныхПолей = Новый Соответствие;
	ДополнительныеПсевдонимы  = "";
	ПорядковыйНомер = 0;
	Для Каждого КлючЗначение Из Новый Структура(ПоляДополнительныхДанных) Цикл
		ИмяПоля   = КлючЗначение.Ключ;
		Псевдоним = "Доп" + Формат(ПорядковыйНомер, "ЧН=; ЧГ=") + "_" + ИмяПоля;
		РасшифровкаДополнительныхПолей.Вставить(Псевдоним, ИмяПоля);
		
		ДополнительныеПсевдонимы = ДополнительныеПсевдонимы + "," + ИмяПоля + " КАК " + Псевдоним;
		ПорядковыйНомер = ПорядковыйНомер + 1;
	КонецЦикла;
	ДополнительныеПсевдонимы = Сред(ДополнительныеПсевдонимы, 2);
	
	// Одинаковые поля будут сравниваться по равенству.
	СтруктураПолейИдентичности = Новый Структура(ПоляСравненияНаРавенство);
	УсловиеИдентичности  = "";
	Для Каждого КлючЗначение Из СтруктураПолейИдентичности Цикл
		ИмяПоля = КлючЗначение.Ключ;
		УсловиеИдентичности = УсловиеИдентичности + "И " + ИмяПоля + " = &" + ИмяПоля + " ";
	КонецЦикла;
	УсловиеИдентичности = Сред(УсловиеИдентичности, 2);
	
	СтруктураПолейПодобия = Новый Структура(ПоляСравненияНаПодобие);
	
	ОбщаяЧастьЗапроса = "
		|ВЫБРАТЬ 
		|	" + ?(ПустаяСтрока(ПоляСравненияНаРавенство), "", ПоляСравненияНаРавенство + "," ) + "
		|	" + ?(ПустаяСтрока(ПоляСравненияНаПодобие),   "", ПоляСравненияНаПодобие   + "," ) + "
		|	" + ?(ПустаяСтрока(ДополнительныеПсевдонимы), "", ДополнительныеПсевдонимы + "," ) + "
		|	Ссылка
		|";
	Если Не СтруктураПолейИдентичности.Свойство("Код") И Не СтруктураПолейПодобия.Свойство("Код") Тогда
		ОбщаяЧастьЗапроса = ОбщаяЧастьЗапроса + "," + ?(ЕстьКод, "Код", "НЕОПРЕДЕЛЕНО") + " КАК Код";
	КонецЕсли;
	Если Не СтруктураПолейИдентичности.Свойство("Наименование") И Не СтруктураПолейПодобия.Свойство("Наименование") Тогда
		ОбщаяЧастьЗапроса = ОбщаяЧастьЗапроса + "," + ?(ЕстьНаименование, "Наименование", "НЕОПРЕДЕЛЕНО") + " КАК Наименование";
	КонецЕсли;
	ОбщаяЧастьЗапроса = ОбщаяЧастьЗапроса + "
		|ИЗ
		|	" + ПараметрыПоиска.ОбластьПоискаДублей + "
		|";
	
	// Основной запрос - для каждого элемента будем искать кандидаты-дубли.
	Если ЭталонныйОбъект = Неопределено Тогда
		
		Запрос = Новый Запрос(ОбщаяЧастьЗапроса + "
			|" + ?(ПустаяСтрока(Фильтр.Текст), "", "ГДЕ " + Фильтр.Текст) + "
			|УПОРЯДОЧИТЬ ПО
			|	Ссылка
			|");
	Иначе
		
		ТекстПредвыборки = "
			|ВЫБРАТЬ * ПОМЕСТИТЬ ЭталонныйОбъект ИЗ &_ЭталонныйОбъект КАК Эталон
			|;////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ 
			|	" + ?(ПустаяСтрока(ПоляСравненияНаРавенство), "", ПоляСравненияНаРавенство + "," ) + "
			|	" + ?(ПустаяСтрока(ПоляСравненияНаПодобие),   "", ПоляСравненияНаПодобие   + "," ) + "
			|	" + ?(ПустаяСтрока(ДополнительныеПсевдонимы), "", ДополнительныеПсевдонимы + "," ) + "
			|	ЗНАЧЕНИЕ(" + ПараметрыПоиска.ОбластьПоискаДублей + ".ПустаяСсылка) КАК Ссылка
			|";
		Если Не СтруктураПолейИдентичности.Свойство("Код") И Не СтруктураПолейПодобия.Свойство("Код") Тогда
			ТекстПредвыборки = ТекстПредвыборки + "," + ?(ЕстьКод, "Код", "НЕОПРЕДЕЛЕНО") + " КАК Код";
		КонецЕсли;
		Если Не СтруктураПолейИдентичности.Свойство("Наименование") И Не СтруктураПолейПодобия.Свойство("Наименование") Тогда
			ТекстПредвыборки = ТекстПредвыборки + "," + ?(ЕстьНаименование, "Наименование", "НЕОПРЕДЕЛЕНО") + " КАК Наименование";
		КонецЕсли;
		ТекстПредвыборки = ТекстПредвыборки + "
			|ИЗ
			|	ЭталонныйОбъект
			|";
		
		Запрос = Новый Запрос(ТекстПредвыборки + "
			|" + ?(ПустаяСтрока(Фильтр.Текст), "", "ГДЕ " + Фильтр.Текст) + "
			|");
			
		Запрос.УстановитьПараметр("_ЭталонныйОбъект", ОбъектВТаблицуЗначений(ЭталонныйОбъект));
	КонецЕсли;
		
		
	// Запрос поиска кандидатов к текущей ссылке. 
	// Сравнение ссылок и упорядочение в предыдущем запросе дают возможность избежать повторных сравнений.
	ЗапросКандидатов = Новый Запрос(ОбщаяЧастьЗапроса + "
		|ГДЕ
		|	Ссылка > &_ИсходнаяСсылка
		|	" + ?(ПустаяСтрока(Фильтр.Текст), "", "И (" + Фильтр.Текст + ")") + "
		|	" + ?(ПустаяСтрока(УсловиеИдентичности), "", "И (" + УсловиеИдентичности+ ")") + "
		|");
		
	Для Каждого КлючЗначение Из Фильтр.Параметры Цикл
		ИмяПараметра      = КлючЗначение.Ключ;
		ЗначениеПараметра = КлючЗначение.Значение;
		Запрос.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра);
		ЗапросКандидатов.УстановитьПараметр(ИмяПараметра, ЗначениеПараметра);
	КонецЦикла;
	
	// Результат и цикл поиска
	ТаблицаДублей = Новый ТаблицаЗначений;
	КолонкиРезультата = ТаблицаДублей.Колонки;
	КолонкиРезультата.Добавить("Ссылка");
	Для Каждого КлючЗначение Из СтруктураПолейИдентичности Цикл
		Если КолонкиРезультата.Найти(КлючЗначение.Ключ) = Неопределено Тогда
			КолонкиРезультата.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	Для Каждого КлючЗначение Из СтруктураПолейПодобия Цикл
		Если КолонкиРезультата.Найти(КлючЗначение.Ключ) = Неопределено Тогда
			КолонкиРезультата.Добавить(КлючЗначение.Ключ);
		КонецЕсли;
	КонецЦикла;
	Если КолонкиРезультата.Найти("Код") = Неопределено Тогда
		КолонкиРезультата.Добавить("Код");
	КонецЕсли;
	Если КолонкиРезультата.Найти("Наименование") = Неопределено Тогда
		КолонкиРезультата.Добавить("Наименование");
	КонецЕсли;
	Если КолонкиРезультата.Найти("Родитель") = Неопределено Тогда
		КолонкиРезультата.Добавить("Родитель");
	КонецЕсли;
	
	ТаблицаДублей.Индексы.Добавить("Ссылка");
	ТаблицаДублей.Индексы.Добавить("Родитель");
	ТаблицаДублей.Индексы.Добавить("Ссылка, Родитель");
	
	Результат = Новый Структура("ТаблицаДублей, ОписаниеОшибки, МестаИспользования", ТаблицаДублей);
	
	СтруктураПолей = Новый Структура;
	СтруктураПолей.Вставить("РасшифровкаДополнительныхПолей", РасшифровкаДополнительныхПолей);
	СтруктураПолей.Вставить("СтруктураПолейИдентичности",     СтруктураПолейИдентичности);
	СтруктураПолей.Вставить("СтруктураПолейПодобия",          СтруктураПолейПодобия);
	СтруктураПолей.Вставить("СписокПолейИдентичности",        ПоляСравненияНаРавенство);
	СтруктураПолей.Вставить("СписокПолейПодобия",             ПоляСравненияНаПодобие);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		// Отбираем похожих
		ЗапросКандидатов.УстановитьПараметр("_ИсходнаяСсылка", Выборка.Ссылка);
		Для Каждого КлючЗначение Из СтруктураПолейИдентичности Цикл
			ИмяПоля = КлючЗначение.Ключ;
			ЗапросКандидатов.УстановитьПараметр(ИмяПоля, Выборка[ИмяПоля]);
		КонецЦикла;
		
		ВыборкаКандидатов = ЗапросКандидатов.Выполнить().Выгрузить();
		Если СтруктураПолейПодобия.Количество() > 0 Тогда
			ПодключитьВнешнююКомпоненту("ОбщийМакет.КомпонентаПоискаСтрок", "FuzzySearch", ТипВнешнейКомпоненты.Native);
			FuzzySearch = Новый("AddIn.FuzzySearch.FuzzyStringMatchExtension");
			Для Каждого КлючЗначение Из СтруктураПолейПодобия Цикл
				ИмяПоля = КлючЗначение.Ключ;
				МассивСтрок = ВыборкаКандидатов.ВыгрузитьКолонку(ИмяПоля);
				СтрокаМассивом = СтрСоединить(МассивСтрок,"~");
				СтрокаДляПоиска = Выборка[ИмяПоля];
				МассивИндексовСтрокой = FuzzySearch.StringSearch(СтрокаДляПоиска, СтрокаМассивом, "~", 10, 80, 90);
				Если ПустаяСтрока(МассивИндексовСтрокой) Тогда
					Продолжить;
				КонецЕсли;
				МассивИндексов = СтрРазделить(МассивИндексовСтрокой, ",");
				Если МассивИндексов.Количество() > 0 Тогда
					Для Каждого ИндексСтроки Из МассивИндексов Цикл
						Если ПустаяСтрока(ИндексСтроки) Тогда
							Продолжить;
						КонецЕсли;
						СтрокаКандидата = ВыборкаКандидатов.Получить(ИндексСтроки);
						Если ТаблицаДублей.Найти(СтрокаКандидата.Ссылка, "Ссылка") <> Неопределено Тогда
							Продолжить;
						КонецЕсли;
						
						Если ИспользоватьПрикладныеПравила Тогда
							// Наполняем таблицу для прикладных правил, вызываем их, если пора.
							ДобавитьСтрокуКандидатов(ТаблицаКандидатов, Выборка, СтрокаКандидата, СтруктураПолей);
							Если ТаблицаКандидатов.Количество() = РазмерПрикладнойПорции Тогда
								ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, Выборка, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
								ТаблицаКандидатов.Очистить();
							КонецЕсли;
						Иначе
							ДобавитьДубльВРезультат(ТаблицаДублей, Выборка, СтрокаКандидата, СтруктураПолей);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
		Иначе
			Для Каждого ВыборкаКандидатов Из ВыборкаКандидатов Цикл
			
				// Если мы его уже посчитали дублем в какой-то группе, то не трогаем.
				Если ТаблицаДублей.Найти(ВыборкаКандидатов.Ссылка, "Ссылка") <> Неопределено Тогда
					Продолжить;
				КонецЕсли;
				
				// Проигрываем правила подобия для строк.
				
				Если ИспользоватьПрикладныеПравила Тогда
					// Наполняем таблицу для прикладных правил, вызываем их, если пора.
					ДобавитьСтрокуКандидатов(ТаблицаКандидатов, Выборка, ВыборкаКандидатов, СтруктураПолей);
					Если ТаблицаКандидатов.Количество() = РазмерПрикладнойПорции Тогда
						ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, Выборка, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
						ТаблицаКандидатов.Очистить();
					КонецЕсли;
				Иначе
					ДобавитьДубльВРезультат(ТаблицаДублей, Выборка, ВыборкаКандидатов, СтруктураПолей);
				КонецЕсли;
			
			КонецЦикла;
		КонецЕсли;
		
		// Обрабатываем остаток таблицы для прикладных правил.
		Если ИспользоватьПрикладныеПравила Тогда
			ДобавитьДублиПоПрикладнымПравилам(ТаблицаДублей, МенеджерОбластиПоиска, Выборка, ТаблицаКандидатов, СтруктураПолей, ДополнительныеПараметры);
			ТаблицаКандидатов.Очистить();
		КонецЕсли;
		
		// Завершен анализ группы, смотрим на количество. Много клиенту не отдаем.
		Если РазмерВозвращаемойПорции > 0 И (ТаблицаДублей.Количество() > РазмерВозвращаемойПорции) Тогда
			// Откатываем последнюю группу.
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Родитель ", Выборка.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			Для Каждого Строка Из ТаблицаДублей.НайтиСтроки( Новый Структура("Ссылка", Выборка.Ссылка) ) Цикл
				ТаблицаДублей.Удалить(Строка);
			КонецЦикла;
			// Если это была последняя группа, то сообщаем об ошибке.
			Если ТаблицаДублей.Количество() = 0 Тогда
				Результат.ОписаниеОшибки = НСтр("ru = 'Найдено слишком много элементов, определены не все группы дублей.'");
			Иначе
				Результат.ОписаниеОшибки = НСтр("ru = 'Найдено слишком много элементов. Уточните критерии поиска дублей.'");
			КонецЕсли;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Результат.ОписаниеОшибки <> Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	// Расчет мест использования
	Если РассчитыватьМестаИспользования Тогда
		НаборСсылок = Новый Массив;
		Для Каждого СтрокаДублей Из ТаблицаДублей Цикл
			Если ЗначениеЗаполнено(СтрокаДублей.Ссылка) Тогда
				НаборСсылок.Добавить(СтрокаДублей.Ссылка);
			КонецЕсли;
		КонецЦикла;
		
		МестаИспользования = МестаИспользованияСсылок(НаборСсылок);
		МестаИспользования = МестаИспользования.Скопировать(
			МестаИспользования.НайтиСтроки(Новый Структура("ВспомогательныеДанные", Ложь)));
		МестаИспользования.Индексы.Добавить("Ссылка");
		
		Результат.Вставить("МестаИспользования", МестаИспользования);
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

// Определение наличия прикладных правил у объекта.
//
// Параметры:
//     МенеджерОбласти - СправочникМенеджер - Менеджер проверяемого объекта.
//
// Возвращаемое значение:
//     Булево - Истина, если прикладные правила определены.
//
Функция ЕстьПрикладныеПравилаОбластиПоискаДублей(Знач ИмяОбъекта) Экспорт
	
	СписокОбъектов = Новый Соответствие;
	ПоискИУдалениеДублейПереопределяемый.ПриОпределенииОбъектовСПоискомДублей(СписокОбъектов);
	
	СведенияОбОбъекте = СписокОбъектов[ИмяОбъекта];
	Возврат СведенияОбОбъекте <> Неопределено И (СведенияОбОбъекте = "" Или СтрНайти(СведенияОбОбъекте, "ПараметрыПоискаДублей") > 0);
	
КонецФункции

// Интерфейс для выполнения команд обработки.
Процедура ВыполнитьКоманду(ПараметрыВыполнения, АдресРезультата) Экспорт
	
	Если ПараметрыВыполнения.ИмяПроцедуры = "ФоновыйПоискДублей" Тогда
		
		ФоновыйПоискДублей(ПараметрыВыполнения, АдресРезультата);
		
	ИначеЕсли ПараметрыВыполнения.ИмяПроцедуры = "ФоновоеУдалениеДублей" Тогда
		
		ФоновоеУдалениеДублей(ПараметрыВыполнения, АдресРезультата);
		
	Иначе
		
		ВызватьИсключение НСтр("ru = 'Поиск и удаление дублей: Команда ""%1"" не поддерживается.'");
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Преобразуем объект в таблицу для помещения в запрос.
Функция ОбъектВТаблицуЗначений(Знач ОбъектДанных)
	Результат = Новый ТаблицаЗначений;
	СтрокаДанных = Результат.Добавить();
	
	МетаОбъект = ОбъектДанных.Метаданные();
	
	Для Каждого МетаРеквизит Из МетаОбъект.СтандартныеРеквизиты  Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Для Каждого МетаРеквизит Из МетаОбъект.Реквизиты Цикл
		Имя = МетаРеквизит.Имя;
		Результат.Колонки.Добавить(Имя, МетаРеквизит.Тип);
		СтрокаДанных[Имя] = ОбъектДанных[Имя];
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

// Дополнительный анализ кандидатов в дубли прикладном методом.
//
Процедура ДобавитьДублиПоПрикладнымПравилам(СтрокиДереваРезультата, Знач МенеджерОбластиПоиска, Знач ОсновныеДанные, Знач ТаблицаКандидатов, Знач СтруктураПолей, Знач ДополнительныеПараметры)
	Если ТаблицаКандидатов.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерОбластиПоиска.ПриПоискеДублей(ТаблицаКандидатов, ДополнительныеПараметры);
	
	Данные1 = Новый Структура;
	Данные2 = Новый Структура;
	
	Для Каждого ПараКандидатов Из ТаблицаКандидатов.НайтиСтроки(Новый Структура("ЭтоДубли", Истина)) Цикл
		Данные1.Вставить("Ссылка",       ПараКандидатов.Ссылка1);
		Данные1.Вставить("Код",          ПараКандидатов.Поля1.Код);
		Данные1.Вставить("Наименование", ПараКандидатов.Поля1.Наименование);
		
		Данные2.Вставить("Ссылка",       ПараКандидатов.Ссылка2);
		Данные2.Вставить("Код",          ПараКандидатов.Поля2.Код);
		Данные2.Вставить("Наименование", ПараКандидатов.Поля2.Наименование);
		
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
			ИмяПоля = КлючЗначение.Ключ;
			Данные1.Вставить(ИмяПоля, ПараКандидатов.Поля1[ИмяПоля]);
			Данные2.Вставить(ИмяПоля, ПараКандидатов.Поля2[ИмяПоля]);
		КонецЦикла;
		
		ДобавитьДубльВРезультат(СтрокиДереваРезультата, Данные1, Данные2, СтруктураПолей);
	КонецЦикла;
КонецПроцедуры

// Добавляем строку в таблицу кандидатов для прикладного метода.
//
Функция ДобавитьСтрокуКандидатов(ТаблицаКандидатов, Знач ДанныеОсновногоЭлемента, Знач ДанныеКандидата, Знач СтруктураПолей)
	
	Строка = ТаблицаКандидатов.Добавить();
	Строка.ЭтоДубли = Ложь;
	Строка.Ссылка1  = ДанныеОсновногоЭлемента.Ссылка;
	Строка.Ссылка2  = ДанныеКандидата.Ссылка;
	
	Строка.Поля1 = Новый Структура("Код, Наименование", ДанныеОсновногоЭлемента.Код, ДанныеОсновногоЭлемента.Наименование);
	Строка.Поля2 = Новый Структура("Код, Наименование", ДанныеКандидата.Код, ДанныеКандидата.Наименование);
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейИдентичности Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.СтруктураПолейПодобия Цикл
		ИмяПоля = КлючЗначение.Ключ;
		Строка.Поля1.Вставить(ИмяПоля, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяПоля, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Для Каждого КлючЗначение Из СтруктураПолей.РасшифровкаДополнительныхПолей Цикл
		ИмяКолонки = КлючЗначение.Значение;
		ИмяПоля    = КлючЗначение.Ключ;
		
		Строка.Поля1.Вставить(ИмяКолонки, ДанныеОсновногоЭлемента[ИмяПоля]);
		Строка.Поля2.Вставить(ИмяКолонки, ДанныеКандидата[ИмяПоля]);
	КонецЦикла;
	
	Возврат Строка;
КонецФункции

// Добавляем в дерево результатов найденный вариант.
//
Процедура ДобавитьДубльВРезультат(Результат, Знач ДанныеОсновногоЭлемента, Знач ДанныеКандидата, Знач СтруктураПолей)
	
	ФильтрГруппы = Новый Структура("Ссылка, Родитель", ДанныеОсновногоЭлемента.Ссылка);
	ГруппаДублей = Результат.НайтиСтроки(ФильтрГруппы);
	
	Если ГруппаДублей.Количество() = 0 Тогда
		ГруппаДублей = Результат.Добавить();
		ЗаполнитьЗначенияСвойств(ГруппаДублей, ФильтрГруппы);
		
		СтрокаДублей = Результат.Добавить();
		СписокСвойств = "Ссылка, Код, Наименование," + СтруктураПолей.СписокПолейИдентичности + "," + СтруктураПолей.СписокПолейПодобия;
		ЗаполнитьЗначенияСвойств(СтрокаДублей, ДанныеОсновногоЭлемента, СписокСвойств);
		
		СтрокаДублей.Родитель = ГруппаДублей.Ссылка;
	Иначе
		ГруппаДублей = ГруппаДублей[0];
	КонецЕсли;
	
	СтрокаДублей = Результат.Добавить();
	СписокСвойств = "Ссылка, Код, Наименование," + СтруктураПолей.СписокПолейИдентичности + "," + СтруктураПолей.СписокПолейПодобия;
	ЗаполнитьЗначенияСвойств(СтрокаДублей, ДанныеКандидата, СписокСвойств);
	
	СтрокаДублей.Родитель = ГруппаДублей.Ссылка;
КонецПроцедуры

// Формируем текст условия запроса и набор параметров.
//
Функция ФильтрПоискаПоКомпоновщику(Знач КомпоновщикОтбора)
	Результат = Новый Структура("Параметры", Новый Структура);
	
	СтекГрупп = Новый Массив;
	СтекГрупп.Вставить(0, ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ);
	
	Результат.Вставить("Текст", ТекстОтбораГруппыКомпоновщика(КомпоновщикОтбора.Настройки.Отбор.Элементы, СтекГрупп, Результат.Параметры) );
	Результат.Вставить("Описание", Строка(КомпоновщикОтбора.Настройки.Отбор) );
	
	Возврат Результат;
КонецФункции

// Формируем текст для использования в запросе, заполняем параметры.
//
Функция ТекстОтбораГруппыКомпоновщика(Знач ЭлементыГруппы, СтекГрупп, ПараметрыКомпоновщика)
	КоличествоЭлементов = ЭлементыГруппы.Количество();
	
	Если КоличествоЭлементов = 0 Тогда
		// Пустая группа условий
		Возврат "";
	КонецЕсли;
	
	ТипТекущейГруппы = СтекГрупп[0];
	
	Текст = "";
	ТокенСравнения = ТокенСравненияГруппыОтбораКомпоновки(ТипТекущейГруппы);
	
	Для Каждого Элемент Из ЭлементыГруппы Цикл
		
		Если Не Элемент.Использование Тогда
			Продолжить;
		КонецЕсли;
		
		Если ТипЗнч(Элемент) = Тип("ЭлементОтбораКомпоновкиДанных") Тогда
			// Одиночный элемент
			ИмяПараметра  = "ПараметрОтбора" + Формат(ПараметрыКомпоновщика.Количество(), "ЧН=; ЧГ=");
			
			ПоискПоПодобию = Ложь;
			Текст = Текст + " " + ТокенСравнения + " " + ТекстСравненияГруппыОтбораКомпоновки(Элемент.ЛевоеЗначение, Элемент.ВидСравнения, "&" + ИмяПараметра, ПоискПоПодобию);
			
			Если ПоискПоПодобию Тогда
				ПараметрыКомпоновщика.Вставить(ИмяПараметра, "%" + Элемент.ПравоеЗначение + "%");
			Иначе
				ПараметрыКомпоновщика.Вставить(ИмяПараметра, Элемент.ПравоеЗначение);
			КонецЕсли;
		Иначе
			// Вложенная группа
			СтекГрупп.Вставить(0, Элемент.ТипГруппы);
			ТекстГруппы = ТекстОтбораГруппыКомпоновщика(Элемент.Элементы, СтекГрупп, ПараметрыКомпоновщика);
			Если Не ПустаяСтрока(ТекстГруппы) Тогда
				Текст = Текст + " " + ТокенСравнения + " " + ТекстОтбораГруппыКомпоновщика(Элемент.Элементы, СтекГрупп, ПараметрыКомпоновщика);
			КонецЕсли;
			СтекГрупп.Удалить(0);
		КонецЕсли;
		
	КонецЦикла;
	
	Если ПустаяСтрока(Текст) Тогда
		Возврат "";
	КонецЕсли;
	
	Текст = Сред(Текст, 2 + СтрДлина(ТокенСравнения));
	Возврат ТокенОткрытияГруппыОтбораКомпоновки(ТипТекущейГруппы) 
		+ "(" + Текст + ")";
КонецФункции

// Токен сравнения элементов внутри группы.
//
Функция ТокенСравненияГруппыОтбораКомпоновки(Знач ТипГруппы)
	
	Если ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИ Тогда 
		Возврат "И";
		
	ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли Тогда 
		Возврат "ИЛИ";
		
	ИначеЕсли ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
		Возврат "И";
		
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Токен операции перед группой.
//
Функция ТокенОткрытияГруппыОтбораКомпоновки(Знач ТипГруппы)
	
	Если ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаНе Тогда
		Возврат "НЕ"
	КонецЕсли;
	
	Возврат "";
КонецФункции

// Текст сравнения двух операндов по виду сравнения.
//
Функция ТекстСравненияГруппыОтбораКомпоновки(Знач Поле, Знач ВидСравнения, Знач ИмяПараметра, ИспользованПоискПоПодобию = Ложь)
	
	ИспользованПоискПоПодобию = Ложь;
	ПолеСравнения             = Строка(Поле);
	
	Если ВидСравнения = ВидСравненияКомпоновкиДанных.Больше Тогда
		Возврат ПолеСравнения + " > " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.БольшеИлиРавно Тогда
		Возврат ПолеСравнения + " >= " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии Тогда
		Возврат ПолеСравнения + " В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСписке Тогда
		Возврат ПолеСравнения + " В (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.ВСпискеПоИерархии  Тогда
		Возврат ПолеСравнения + " В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Заполнено Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " НЕ ПОДОБНО """" ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше Тогда
		Возврат ПолеСравнения + " < " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.МеньшеИлиРавно Тогда
		Возврат ПолеСравнения + " <= " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВИерархии Тогда
		Возврат ПолеСравнения + " НЕ В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСписке Тогда
		Возврат ПолеСравнения + " НЕ В (" + ИмяПараметра + ")";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеВСпискеПоИерархии Тогда
		Возврат ПолеСравнения + " НЕ В ИЕРАРХИИ (" + ИмяПараметра + ") ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " ПОДОБНО """" ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно Тогда
		Возврат ПолеСравнения + " <> " + ИмяПараметра + " ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.НеСодержит Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " НЕ ПОДОБНО " + ИмяПараметра + " ";
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Равно Тогда
		Возврат ПолеСравнения + " = " + ИмяПараметра;
		
	ИначеЕсли ВидСравнения = ВидСравненияКомпоновкиДанных.Содержит Тогда
		ИспользованПоискПоПодобию = Истина;
		Возврат ПолеСравнения + " ПОДОБНО " + ИмяПараметра + " ";;
		
	КонецЕсли;
	
	Возврат "";
КонецФункции

Процедура ГруппаОбластейПоискаДублей(Результат, ОбъектыСПоискомДублей, Знач АнализироватьПрикладныеПравила, Знач МенеджерГруппы, Знач Пиктограмма)
	
	Для Каждого Элемент Из МенеджерГруппы Цикл
		ОбъектМетаданных = Метаданные.НайтиПоТипу(ТипЗнч(Элемент));
		Если Не ПравоДоступа("Чтение", ОбъектМетаданных) Тогда
			// Нет доступа, не выводим в список.
			Продолжить;
		КонецЕсли;
		
		ПолноеИмя = ОбъектМетаданных.ПолноеИмя();
		Если АнализироватьПрикладныеПравила Тогда
			СведенияОбОбъекте = ОбъектыСПоискомДублей[ПолноеИмя];
			ЕстьПрикладныеПравила = СведенияОбОбъекте <> Неопределено
				И (СведенияОбОбъекте = "" Или СтрНайти(СведенияОбОбъекте, "ПараметрыПоискаДублей") > 0);
		Иначе
			ЕстьПрикладныеПравила = Ложь;
		КонецЕсли;
		
		Результат.Добавить(ПолноеИмя, Строка(ОбъектМетаданных), ЕстьПрикладныеПравила, БиблиотекаКартинок[Пиктограмма]);
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для автономной работы.

// [ОбщегоНазначения.МестаИспользования]
Функция МестаИспользованияСсылок(Знач НаборСсылок, Знач АдресРезультата = "")
	
	Возврат ОбщегоНазначения.МестаИспользования(НаборСсылок, АдресРезультата);
	
КонецФункции

// [ОбщегоНазначения.ЗаменитьСсылки]
Функция ЗаменитьСсылки(Знач ПарыЗамен, Знач Параметры = Неопределено, Знач АдресРезультата = "")
	
	Результат = ОбщегоНазначения.ЗаменитьСсылки(ПарыЗамен, Параметры);
	Если АдресРезультата <> "" Тогда
		ПоместитьВоВременноеХранилище(Результат, АдресРезультата);
	КонецЕсли;	
КонецФункции

#КонецОбласти

#КонецЕсли