﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем БыстроеОбновлениеДанных;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ВариантОкругления = 1;
	
	ДанныеАктуальны = Истина;
	
	// Инициализация таблицы настроек
	ИнформационнаяПанель.ДобавитьПредопределенныеБлоки(ТаблицаБлоков);
	
	// Накладываем пользовательские настройки
	ИнформационнаяПанель.ПрименитьНастройки(ТаблицаБлоков);
	
	РасставитьБлоки();
	
	ПрочитатьДанныеБлоков();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗадержкаПередЗапускомФоновыхЗаданий = 16;
	ПодключитьОбработчикОжидания("Подключаемый_ОбновлениеДанныхБлоков", ЗадержкаПередЗапускомФоновыхЗаданий, Истина);
	
	// Запланируем обновление на завтра
	Интервал = Макс(ИнтервалОбновленияДанных(ТекущаяДата()), ЗадержкаПередЗапускомФоновыхЗаданий);
	ПодключитьОбработчикОжидания("Подключаемый_ЕжедневноеОбновление", Интервал, Истина);
	
	ТекущийЭлемент = Элементы.Обновить;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ИзменениеОсновнойОрганизации" Тогда
		
		
	ИначеЕсли ИмяСобытия = "ИзмененаНастройкаИнформационнойПанели" Тогда
		
		НастройкаИнформационнойПанелиПриИзменении();
		
		// Полное обновление всех блоков
		БыстроеОбновление = Ложь;
		ПрочитатьДанныеСтатическихБлоков = Истина;
		ОбновитьДанныеБлоков(БыстроеОбновление, ПрочитатьДанныеСтатическихБлоков);
		
		
	ИначеЕсли ИмяСобытия = "ДобавитьБлокИнформационнойПанели" Тогда
		
		ИмяБлока = Строка(Параметр);
		
		Если ДобавитьБлок(ИмяБлока) Тогда
			
			РасставитьБлоки();
			
			// Полное обновление всех блоков
			БыстроеОбновление = Ложь;
			ПрочитатьДанныеСтатическихБлоков = Истина;
			ОбновитьДанныеБлоков(БыстроеОбновление, ПрочитатьДанныеСтатическихБлоков);
			
			
		КонецЕсли;
		
	ИначеЕсли ИмяСобытия = "Запись_Организации" Тогда
		
		// При записи новой организации необходимо добавить ее в список доступных организаций.
		ОбработкаОповещенияЗаписьОрганизации(Параметр, Источник);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КлиентПриИзменении(Элемент)
	
	КлиентОбработатьИзменение();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Настройка(Команда)
	
	//СписокБлоков = Новый СписокЗначений;
	//Для Каждого Блок Из ТаблицаБлоков Цикл
	//	СписокБлоков.Добавить(Блок.Имя, Блок.Синоним, Блок.Пометка);
	//КонецЦикла;
	//
	//ПараметрыФормы = Новый Структура;
	//ПараметрыФормы.Вставить("СписокБлоков", СписокБлоков);
	//
	//ОткрытьФорму("ОбщаяФорма.ИнформационнаяПанельНастройка", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	
	// Быстрое обновление динамических блоков
	БыстроеОбновление = Истина;
	ПрочитатьДанныеСтатическихБлоков = Ложь;
	ОбновитьДанныеБлоков(БыстроеОбновление, ПрочитатьДанныеСтатическихБлоков);
	
КонецПроцедуры

#КонецОбласти

#Область RWDDeadline

&НаКлиенте
Процедура RWDDeadlineAllInvoicesНажатие(Элемент)
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеБлокомRWDDeadline(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Элементы.RWDDeadline.Родитель = Элементы.БлокиПанели Тогда
		Возврат;
	КонецЕсли;
	
	ИндексИтогов = Форма.RWDDeadline_ИндексИтога;
	
	БезРамки = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки);
	
	ВГраница = БлокиИнформационнойПанелиКлиентСервер.RWDDeadlineКоличествоИтогов();
	
	Если ИндексИтогов = 0 Тогда
		
		ЧертаСверху = Новый Рамка(ТипРамкиЭлементаУправления.ЧертаСверху);
		
		Элементы.RWDDeadline_Total.Рамка = ЧертаСверху; // Черта над итоговой строкой
		//Для Индекс = 1 По ВГраница Цикл
		//	ЭлементФормы = Элементы[СтрШаблон("ОстаткиДенежныхСредств_Остаток%1", Индекс)];
		//	ЭлементФормы.Рамка = БезРамки;
		//КонецЦикла;
		
	Иначе
		
		// Подчеркиваем элемент, расположенный над итоговой строкой
		
		Подчеркивание = Новый Рамка(ТипРамкиЭлементаУправления.Подчеркивание);
		
		//ЭлементСверху = Элементы.ОстаткиДенежныхСредств_Банк;
		//Для Индекс = 0 По ВГраница Цикл
		//	ЭлементСверху.Рамка = ?(Индекс = ИндексИтогов, Подчеркивание, БезРамки);
		//	ЭлементСверху = Элементы[СтрШаблон("ОстаткиДенежныхСредств_Остаток%1", Индекс)];
		//КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область BrokenPromises

&НаКлиенте
Процедура BrokenPromisesAllInvoicesНажатие(Элемент)
	
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеБлокомBrokenPromises(Форма)
	
	Элементы = Форма.Элементы;
	
	Если Элементы.BrokenPromises.Родитель = Элементы.БлокиПанели Тогда
		Возврат;
	КонецЕсли;
	
	ИндексИтогов = Форма.BrokenPromises_ИндексИтога;
	
	БезРамки = Новый Рамка(ТипРамкиЭлементаУправления.БезРамки);
	
	ВГраница = БлокиИнформационнойПанелиКлиентСервер.BrokenPromisesКоличествоИтогов();
	
	Если ИндексИтогов = 0 Тогда
		
		ЧертаСверху = Новый Рамка(ТипРамкиЭлементаУправления.ЧертаСверху);
		
		Элементы.BrokenPromises_Total.Рамка = ЧертаСверху; // Черта над итоговой строкой
		//Для Индекс = 1 По ВГраница Цикл
		//	ЭлементФормы = Элементы[СтрШаблон("ОстаткиДенежныхСредств_Остаток%1", Индекс)];
		//	ЭлементФормы.Рамка = БезРамки;
		//КонецЦикла;
		
	Иначе
		
		// Подчеркиваем элемент, расположенный над итоговой строкой
		
		Подчеркивание = Новый Рамка(ТипРамкиЭлементаУправления.Подчеркивание);
		
		//ЭлементСверху = Элементы.ОстаткиДенежныхСредств_Банк;
		//Для Индекс = 0 По ВГраница Цикл
		//	ЭлементСверху.Рамка = ?(Индекс = ИндексИтогов, Подчеркивание, БезРамки);
		//	ЭлементСверху = Элементы[СтрШаблон("ОстаткиДенежныхСредств_Остаток%1", Индекс)];
		//КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Форма.Элементы.КартинкаФоновоеЗаданиеЗапущено.Видимость = (Форма.ФоновоеЗаданиеЗапущено Или Не Форма.ДанныеАктуальны);
	
	УправлениеБлокомRWDDeadline(Форма);
	УправлениеБлокомBrokenPromises(Форма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеБлоков(БыстроеОбновление, ПрочитатьДанныеСтатическихБлоков, ПрочитатьДанныеДинамическихБлоков = Ложь)
	
	Если ПрочитатьДанныеСтатическихБлоков И Не ПустаяСтрока(СтатическиеБлоки) Тогда
		ПрочитатьДанныеБлоков(СтатическиеБлоки);
	КонецЕсли;
	
	Если ФоновоеЗаданиеЗапущено Тогда
		// Текущее фоновое задание неактуально
		ОтменитьВыполнениеЗадания(ФоновоеЗаданиеИдентификатор, ФоновоеЗаданиеЗапущено);
	КонецЕсли;
	
	Если ПустаяСтрока(ДинамическиеБлоки) Тогда
		
		ДанныеАктуальны = Истина;
		
	Иначе
		
		Если ПрочитатьДанныеДинамическихБлоков Тогда
			// Принудительное чтение данных до начала выполнения фонового задания
			ПрочитатьДанныеБлоков(ДинамическиеБлоки);
		Иначе
			// Чтение данных после завершения фонового задания
			ИнициализироватьДанныеБлоков(ДинамическиеБлоки);
		КонецЕсли;
		
		БыстроеОбновлениеДанных = БыстроеОбновление;
		
		ПодключитьОбработчикОжидания("Подключаемый_ОбновлениеДанныхБлоков", 0.1, Истина);
		
		ДанныеАктуальны = Ложь;
		
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура РасставитьБлоки()
	
	// Инициализация свойств
	
	ОбщиеСвойстваБлоков = ОбщиеСвойстваБлоков();
	
	ЭлементыБлоков = Новый Соответствие; // Соответствие элемента формы имени блока
	
	Для Каждого Блок Из ТаблицаБлоков Цикл
		ЭлементФормы = Элементы.Найти(Блок.Имя);
		Если ЭлементФормы <> Неопределено Тогда
			ЭлементыБлоков.Вставить(Блок.Имя, ЭлементФормы);
			ЭлементФормы.ЦветФона = Блок.ЦветФона;
			ЗаполнитьЗначенияСвойств(ЭлементФормы, ОбщиеСвойстваБлоков);
		КонецЕсли;
	КонецЦикла;
	
	// Возвращаем все блоки в невидимую группу БлокиПанели
	
	Для ИндексСтроки = 0 По ИнформационнаяПанель.КоличествоСтрок() - 1 Цикл
		Для ИндексКолонки = 0 По ИнформационнаяПанель.КоличествоКолонок() - 1 Цикл
			Контейнер = Элементы[ИмяКонтейнераБлока(ИндексСтроки, ИндексКолонки)];
			Для Каждого ПодчиненныйЭлемент Из Контейнер.ПодчиненныеЭлементы Цикл
				Элементы.Переместить(ПодчиненныйЭлемент, Элементы.БлокиПанели)
			КонецЦикла;
		КонецЦикла;
	КонецЦикла;
	
	// Распределение блоков по контейнерам
	
	ИндексСтроки  = 0;
	ИндексКолонки = 0;
	
	ВГраницаСтрок   = ИнформационнаяПанель.КоличествоСтрок() - 1;
	ВГраницаКолонок = ИнформационнаяПанель.КоличествоКолонок() - 1;
	
	СтатическиеБлоки  = "";
	ДинамическиеБлоки = "";
	
	Для Каждого Блок Из ТаблицаБлоков Цикл
		
		Если Не Блок.Пометка Тогда
			// Блок выключен
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(Блок.ПроцедураОбновленияДанных) Тогда
			СтатическиеБлоки = СтатическиеБлоки + ?(ПустаяСтрока(СтатическиеБлоки), "", ",") + Блок.Имя;
		Иначе
			ДинамическиеБлоки = ДинамическиеБлоки + ?(ПустаяСтрока(ДинамическиеБлоки), "", ",") + Блок.Имя;
		КонецЕсли;
		
		// Перемещаем блок из группы БлокиПанели в контейнер
		Контейнер = Элементы[ИмяКонтейнераБлока(ИндексСтроки, ИндексКолонки)];
		Если Контейнер <> Неопределено Тогда
			Элементы.Переместить(ЭлементыБлоков[Блок.Имя], Контейнер);
		КонецЕсли;
		
		Если ИндексКолонки = ВГраницаКолонок Тогда
			ИндексКолонки = 0;
			ИндексСтроки  = ИндексСтроки + 1;
		Иначе
			ИндексКолонки = ИндексКолонки + 1;
		КонецЕсли;
		
		Если ИндексСтроки > ВГраницаСтрок Тогда
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ОбщиеСвойстваБлоков()
	
	Возврат Новый Структура("Ширина,Высота,РастягиватьПоВертикали,РастягиватьПоГоризонтали", 40, 11, Ложь, Ложь);
	
КонецФункции

&НаСервереБезКонтекста
Функция ИмяКонтейнераБлока(ИндексСтроки, ИндексКолонки)
	
	Возврат СтрШаблон("Контейнер%1%2", ИндексСтроки, ИндексКолонки);
	
КонецФункции

&НаСервере
Процедура ИнициализироватьДанныеБлоков(СтрокаОтбора = "")
	
	ПолучитьДанныеБлоков(СтрокаОтбора, Истина);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьДанныеБлоков(СтрокаОтбора = "")
	
	ПолучитьДанныеБлоков(СтрокаОтбора, Ложь);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДанныеБлоков(СтрокаОтбора, Инициализация)
	
	ОбновитьЗаголовокФормы();
	
	УстановленОтбор = Не ПустаяСтрока(СтрокаОтбора);
	Если УстановленОтбор Тогда
		ОтборБлоков = СтрРазделить(СтрокаОтбора, ", ", Ложь);
	КонецЕсли;
	
	АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("УникальныйИдентификатор",          УникальныйИдентификатор);
	СтруктураПараметров.Вставить("АдресХранилища",                   АдресХранилища);
	СтруктураПараметров.Вставить("Клиент",                           Клиент);
	СтруктураПараметров.Вставить("ВариантОкругления",                ВариантОкругления);
	СтруктураПараметров.Вставить("ПоказыватьСравнениеСПрошлымГодом", Ложь);
	СтруктураПараметров.Вставить("Инициализация",                    Инициализация);
	
	ПараметрыПроцедуры = Новый Массив();
	ПараметрыПроцедуры.Добавить(СтруктураПараметров);
	
	Для Каждого Блок Из ТаблицаБлоков Цикл
		
		Если Не Блок.Пометка Тогда
			Продолжить;
		КонецЕсли;
		
		Если УстановленОтбор И (ОтборБлоков.Найти(Блок.Имя) = Неопределено) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не ПустаяСтрока(Блок.ПроцедураПолученияДанных) Тогда
			
			РаботаВБезопасномРежиме.ВыполнитьМетодКонфигурации(Блок.ПроцедураПолученияДанных, ПараметрыПроцедуры);
			
			ДанныеБлока = ПолучитьИзВременногоХранилища(АдресХранилища);
			Если ТипЗнч(ДанныеБлока) = Тип("Структура") Тогда
				Если Инициализация Тогда
					ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеБлока);
				Иначе
					ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеБлока, Блок.РеквизитыФормы);
				КонецЕсли;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Если ЭтоАдресВременногоХранилища(АдресХранилища) Тогда
		УдалитьИзВременногоХранилища(АдресХранилища);
		АдресХранилища = "";
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЗаголовокФормы()
	
	Период = ТекущаяДатаСеанса();
	
	ПредставлениеТекущейДаты = Формат(Период, "Л=en_US; ДФ='MMMM d, dddd'");
	
	Заголовок = СтрШаблон("Today: %1", ПредставлениеТекущейДаты);
	
КонецПроцедуры

&НаСервере
Процедура НастройкаИнформационнойПанелиПриИзменении()
	
	ИнформационнаяПанель.ПрименитьНастройки(ТаблицаБлоков);
	
	РасставитьБлоки();
	
КонецПроцедуры

&НаКлиенте
Процедура КлиентОбработатьИзменение()
	
	БыстроеОбновление = Ложь;
	ПрочитатьДанныеСтатическихБлоков  = Ложь;
	ПрочитатьДанныеДинамическихБлоков = Истина;
	
	ОбновитьДанныеБлоков(БыстроеОбновление, ПрочитатьДанныеСтатическихБлоков, ПрочитатьДанныеДинамическихБлоков);
	
КонецПроцедуры

&НаКлиенте
Функция ИндексЭлементаФормы(Знач Имя)
	
	Цифры = "1234567890";
	НомерСтрокой = "";
	
	ДлинаИмени = СтрДлина(Имя);
	
	ВГраница   = ДлинаИмени - 1;
	Для Индекс = 0 По ВГраница Цикл
		Позиция = ДлинаИмени - Индекс;
		Символ = Сред(Имя,Позиция,1);
		Если СтрНайти(Цифры, Символ) = 0 Тогда
			Прервать;
		КонецЕсли;
		НомерСтрокой = Символ + НомерСтрокой;
	КонецЦикла;
	
	Если ПустаяСтрока(НомерСтрокой) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Попытка
		Возврат Число(НомерСтрокой);
	Исключение
		Возврат Неопределено;
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Процедура ОткрытьОтчет(Отчет, ГруппировкаОтчета = Неопределено, Отборы = Неопределено, Показатели  = Неопределено, КлючВарианта = Неопределено, НачалоПериода = Неопределено, КонецПериода = Неопределено)
	
	//ПользовательскиеНастройки = ПользовательскиеНастройкиДляРасшифровки(НачалоПериода, КонецПериода);
	//ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	//
	//Если ГруппировкаОтчета <> Неопределено И ТипЗнч(ГруппировкаОтчета) = Тип("Массив") Тогда
	//	ДополнительныеСвойства.Вставить("Группировка", ГруппировкаОтчета);
	//КонецЕсли;
	//
	//Если ТипЗнч(Отборы) = Тип("Массив") Тогда
	//	
	//	НастройкаОтбора = ПользовательскиеНастройки.Элементы.Добавить(Тип("ОтборКомпоновкиДанных"));
	//	НастройкаОтбора.ИдентификаторПользовательскойНастройки = "Отбор";
	//	Для Каждого Отбор Из Отборы Цикл
	//		БухгалтерскиеОтчетыКлиентСервер.ДобавитьОтбор(НастройкаОтбора, Отбор.Поле, Отбор.Значение, Отбор.ВидСравнения);
	//	КонецЦикла;
	//	
	//КонецЕсли;
	//
	//Если ТипЗнч(Показатели) = Тип("Массив") Тогда
	//	
	//	Для Каждого Показатель Из Показатели Цикл
	//		ДополнительныеСвойства.Вставить(Показатель, Истина);
	//	КонецЦикла;
	//	
	//КонецЕсли;
	//
	//Если КлючВарианта <> Неопределено Тогда
	//	ДополнительныеСвойства.Вставить("КлючВарианта", КлючВарианта);
	//КонецЕсли;
	//
	//ПараметрыОтчета = Новый Структура;
	//ПараметрыОтчета.Вставить("РежимРасшифровки"         , Истина);
	//ПараметрыОтчета.Вставить("ВидРасшифровки"           , 2);
	//ПараметрыОтчета.Вставить("ПользовательскиеНастройки", ПользовательскиеНастройки);
	//
	//ОткрытьФорму(Отчет, ПараметрыОтчета, ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаКлиенте
Функция ПользовательскиеНастройкиДляРасшифровки(НачалоПериода = Неопределено, КонецПериода = Неопределено)
	
	//// Инициализация пользовательских настроек
	//// Добавим в настройки все параметры которые могут использоваться в отчетах руководителю
	//
	//ПользовательскиеНастройки = Новый ПользовательскиеНастройкиКомпоновкиДанных;
	//
	//ДополнительныеСвойства = ПользовательскиеНастройки.ДополнительныеСвойства;
	//ДополнительныеСвойства.Вставить("РежимРасшифровки", Истина);
	//ДополнительныеСвойства.Вставить("Клиент", Клиент);
	//ДополнительныеСвойства.Вставить("Период", Период);
	//
	//Если НачалоПериода <> Неопределено Тогда
	//	ДополнительныеСвойства.Вставить("НачалоПериода", НачалоПериода);
	//КонецЕсли;
	//Если КонецПериода <> Неопределено Тогда
	//	ДополнительныеСвойства.Вставить("КонецПериода", КонецПериода);
	//КонецЕсли;
	//
	//Если ВариантОкругления = 1000 Тогда
	//	
	//	// Установим формат цифр для рублевых сумм
	//	УсловноеОформление = ПользовательскиеНастройки.Элементы.Добавить(Тип("УсловноеОформлениеКомпоновкиДанных"));
	//	УсловноеОформление.ИдентификаторПользовательскойНастройки = "УсловноеОформление";
	//	
	//	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	//	ЭлементУсловногоОформления.Представление = НСтр("ru = 'Суммы в тыс.'");
	//	ЭлементУсловногоОформления.Использование = Истина;
	//	
	//	БухгалтерскиеОтчетыКлиентСервер.УстановитьПараметр(ЭлементУсловногоОформления.Оформление, "Формат", "ЧДЦ=; ЧС=3");
	//	
	//КонецЕсли;
	//
	//Возврат ПользовательскиеНастройки;
	
КонецФункции

&НаКлиенте
Функция БлокВключен(ИмяБлока)
	
	ПараметрыОтбора = Новый Структура("Имя", ИмяБлока);
	НайденныеБлоки = ТаблицаБлоков.НайтиСтроки(ПараметрыОтбора);
	
	Возврат НайденныеБлоки.Количество() > 0 И НайденныеБлоки[0].Пометка;
	
КонецФункции

&НаКлиенте
Функция ДобавитьБлок(ИмяБлока)
	
	ПараметрыОтбора = Новый Структура("Имя", ИмяБлока);
	НайденныеБлоки = ТаблицаБлоков.НайтиСтроки(ПараметрыОтбора);
	Если НайденныеБлоки.Количество() > 0 И Не НайденныеБлоки[0].Пометка Тогда
		НайденныеБлоки[0].Пометка = Истина;
		СоставИзменен = Истина;
	Иначе
		СоставИзменен = Ложь;
	КонецЕсли;
	
	Возврат СоставИзменен;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПоказыватьСравнениеСПрошлымГодом(Знач Организация)
	
	//ДатаНачалаВеденияУчета = Справочники.Организации.ДатаНачалаВеденияУчета(Организация);
	//
	//Если ДатаНачалаВеденияУчета = Неопределено Тогда
	//	Возврат Ложь;
	//КонецЕсли;
	//
	//Возврат ДатаНачалаВеденияУчета < НачалоГода(ТекущаяДатаСеанса());
	
	Возврат Ложь;
	
КонецФункции

&НаКлиенте
// Вызывается при получении оповещения о записи организации.
// Для новых организаций добавляет их ссылки в отбор параметра выбора, 
// чтобы они были доступны в списке на форме.
//
// Параметры:
//	Параметр - Неопределено, Структура - Параметр, полученный в ОбработкаОповещения().
//		Если имеет тип Структура и содержит ключ "ЭтоНовый", то такое оповещения будет обработано,
//		иначе проигнорировано.
//	Источник - СправочникСсылка.Организации - Ссылка на измененную организацию.
//
Процедура ОбработкаОповещенияЗаписьОрганизации(Параметр, Источник)
	
	Если ТипЗнч(Параметр) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметр.Свойство("ЭтоНовый") 
		ИЛИ НЕ Параметр.ЭтоНовый Тогда
		Возврат;
	КонецЕсли;
	
	// При записи новой организации добавим ее в список доступных для выбора организаций на форме.
	ДоступныеОрганизации = Новый Массив;
	ДоступныеОрганизации.Добавить(Источник);
	
	Если Элементы.Организация.ПараметрыВыбора.Количество() > 0 Тогда
		// В качестве значения параметра выбора указан фиксированный массив ссылок организаций, 
		// полученный из ОбщегоНазначенияБПВызовСервераПовтИсп.ОрганизацииДанныеКоторыхДоступныПользователю().
		// Копируем их в новых массив.
		ОбщегоНазначенияКлиентСервер.ДополнитьМассив(ДоступныеОрганизации, Элементы.Организация.ПараметрыВыбора[0].Значение);
	КонецЕсли;
	
	ФиксированныйМассивДоступныхОрганизаций = Новый ФиксированныйМассив(ДоступныеОрганизации);
	
	УстановитьПараметрыВыбораОрганизации(ЭтотОбъект, ДоступныеОрганизации);

КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьПараметрыВыбораОрганизации(Форма, ДоступныеОрганизации)
	
	Элементы = Форма.Элементы;
	
	ПараметрВыбораОтборПоОрганизации = Новый ПараметрВыбора("Отбор.Ссылка", ДоступныеОрганизации);
	
	ПараметрыВыбораОрганизации = Новый Массив();
	ПараметрыВыбораОрганизации.Добавить(ПараметрВыбораОтборПоОрганизации);
	
	Элементы.Организация.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбораОрганизации);
	
КонецПроцедуры

#Область ОбновлениеИнформационнойПанели

&НаКлиенте
Процедура Подключаемый_ОбновлениеДанныхБлоков()
	
	Если ПустаяСтрока(ДинамическиеБлоки) Тогда
		Возврат;
	КонецЕсли;
	
	БыстроеОбновление = ?(БыстроеОбновлениеДанных <> Неопределено, БыстроеОбновлениеДанных, Ложь);
	
	Если ЗапуститьОбновлениеДанныхБлоков(БыстроеОбновление) Тогда
		ЖдатьОбновленияДанныхБлоков();
	Иначе
		// Включен монопольный режим, попробуем обновить позже
		ИнтервалМеждуПопыткамиОбновления = 60;
		ПодключитьОбработчикОжидания("Подключаемый_ОбновлениеДанныхБлоков", ИнтервалМеждуПопыткамиОбновления, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ЕжедневноеОбновление()
	
	// Полное обновление всех блоков
	БыстроеОбновление = Ложь;
	ПрочитатьДанныеСтатическихБлоков = Истина;
	ОбновитьДанныеБлоков(БыстроеОбновление, ПрочитатьДанныеСтатическихБлоков);
	
	// Запланируем обновление на завтра
	ПодключитьОбработчикОжидания("Подключаемый_ЕжедневноеОбновление", ИнтервалОбновленияДанных(ТекущаяДата()), Истина);
	
КонецПроцедуры

&НаСервере
Функция ЗапуститьОбновлениеДанныхБлоков(БыстроеОбновление = Ложь)
	
	Если МонопольныйРежим() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Возможно, что фоновое задание было запущено раньше, 
	// пользователь дал команду его отменить, однако задание не отменено.
	// В таком случае не следует запускать задание повторно - следует дождаться его выполнения.
	Если ФоновоеЗаданиеЗапущено И Не ЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор) Тогда
		Возврат Истина;
	КонецЕсли;
	
	ПроцедурыОбновленияДанных = Новый Массив;
	Для Каждого Блок Из ТаблицаБлоков Цикл
		Если Блок.Пометка И Не ПустаяСтрока(Блок.ПроцедураОбновленияДанных) Тогда
			ПроцедурыОбновленияДанных.Добавить(Блок.ПроцедураОбновленияДанных);
		КонецЕсли;
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("БыстроеОбновление",                БыстроеОбновление);
	СтруктураПараметров.Вставить("Клиент",                           Клиент);
	СтруктураПараметров.Вставить("ПроцедурыОбновленияДанных",        ПроцедурыОбновленияДанных);
	СтруктураПараметров.Вставить("ПоказыватьСравнениеСПрошлымГодом", Ложь);
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"ИнформационнаяПанель.ОбновитьДанныеБлоков",
		СтруктураПараметров,
		НСтр("ru = 'Обновление данных блоков Информационной панели'"));
	
	ФоновоеЗаданиеИдентификатор = Результат.ИдентификаторЗадания;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ДанныеАктуальны = Истина;
		ПрочитатьДанныеБлоков(ДинамическиеБлоки);
	Иначе
		ФоновоеЗаданиеЗапущено = Истина;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	Возврат Истина;
	
КонецФункции

&НаКлиенте
Процедура ЖдатьОбновленияДанныхБлоков()
	
	Если Не ФоновоеЗаданиеЗапущено Тогда
		Возврат;
	КонецЕсли;
	
	ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
	
	ПодключитьОбработчикОжиданияЗавершенияДлительнойОперации();
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьЗавершениеДлительнойОперации()
	
	Если Не ФоновоеЗаданиеЗапущено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗаданиеВыполнено(ФоновоеЗаданиеИдентификатор) Тогда
		ФоновоеЗаданиеЗапущено = Ложь;
		ДанныеАктуальны = Истина;
		ПрочитатьДанныеБлоков(ДинамическиеБлоки);
	Иначе
		ПодключитьОбработчикОжиданияЗавершенияДлительнойОперации();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОбработчикОжиданияЗавершенияДлительнойОперации()
	
	ПодключитьОбработчикОжидания(
		"Подключаемый_ПроверитьЗавершениеДлительнойОперации",
		ПараметрыОбработчикаОжидания.ТекущийИнтервал,
		Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(Знач ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(Знач ИдентификаторЗадания, ЗаданиеЗапущено)
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	ЗаданиеЗапущено = Ложь;
	
КонецПроцедуры

&НаКлиенте
Функция ИнтервалОбновленияДанных(ДатаОбновленияДанных)
	
	Возврат (КонецДня(ДатаОбновленияДанных) + 1) - ДатаОбновленияДанных + 59;
	
КонецФункции

#КонецОбласти

#КонецОбласти
