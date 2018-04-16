
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	Если Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.УстановитьПараметрыСпискаМоихЗадач(Список);
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Выполнена", Ложь);
			
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокИсполнения.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.ДатаНачала.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	Элементы.Дата.Формат = ?(ИспользоватьДатуИВремяВСрокахЗадач, "ДЛФ=DT", "ДЛФ=D");
	
	// Установка отбора динамического списка.
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "ПометкаУдаления", Ложь, ВидСравненияКомпоновкиДанных.Равно, , ,
		РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	СгруппироватьПоКолонкеНаСервере(Настройки["РежимГруппировки"]);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ЗадачаИсполнителя" Тогда
		ОбновитьСписокЗадачНаСервере();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	БизнесПроцессыИЗадачиКлиент.СписокЗадачПередНачаломДобавления(ЭтотОбъект, Элемент, Отказ, Копирование, 
		Родитель, Группа);
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено
		И Элемент.ТекущиеДанные.Свойство("ПринятаКИсполнению")
		И НЕ Элемент.ТекущиеДанные.ПринятаКИсполнению Тогда
			Элементы.ПринятьКИсполнению.Доступность= Истина;
	Иначе
		Элементы.ПринятьКИсполнению.Доступность= Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьБизнесПроцесс(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьБизнесПроцесс(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПредметЗадачи(Команда)
	БизнесПроцессыИЗадачиКлиент.ОткрытьПредметЗадачи(Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоВажности(Команда)
	СгруппироватьПоКолонке("Важность");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоБезГруппировки(Команда)
	СгруппироватьПоКолонке("");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоТочкеМаршрута(Команда)
	СгруппироватьПоКолонке("ТочкаМаршрута");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоАвтору(Команда)
	СгруппироватьПоКолонке("Автор");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоПредмету(Команда)
	СгруппироватьПоКолонке("ПредметСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоСроку(Команда)
	СгруппироватьПоКолонке("СрокДляГруппировки");
КонецПроцедуры

&НаКлиенте
Процедура ПринятьКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ПринятьЗадачиКИсполнению(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтменитьПринятиеКИсполнению(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОтменитьПринятиеЗадачКИсполнению(Элементы.Список.ВыделенныеСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписокЗадач(Команда)
	
	ОбновитьСписокЗадачНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	// Скрыть вторую строку группировки.
	КолонкиСпискаЗадач = Новый Массив();
	ВыбратьВсеПодчиненныеЭлементы(Элементы.ГруппаКолонки, КолонкиСпискаЗадач);
	Для каждого ЭлементФормы Из КолонкиСпискаЗадач Цикл
		
		Если ЭлементФормы = Элементы.Наименование Тогда
			Продолжить;
		КонецЕсли;
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ЭлементФормы.Имя);
		
	КонецЦикла;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Список.Ссылка");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;

	Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
	
	БизнесПроцессыИЗадачиСервер.УстановитьОформлениеЗадач(Список);
	
КонецПроцедуры

&НаСервере
Процедура ВыбратьВсеПодчиненныеЭлементы(Родитель, Результат)
	
	Для каждого ЭлементФормы Из Родитель.ПодчиненныеЭлементы Цикл
		
		Результат.Добавить(ЭлементФормы);
		Если ТипЗнч(ЭлементФормы) = Тип("ГруппаФормы") Тогда
			ВыбратьВсеПодчиненныеЭлементы(ЭлементФормы, Результат); 
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СгруппироватьПоКолонке(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СгруппироватьПоКолонкеНаСервере(Знач ИмяКолонкиРеквизита)
	РежимГруппировки = ИмяКолонкиРеквизита;
	Список.Группировка.Элементы.Очистить();
	Если НЕ ПустаяСтрока(ИмяКолонкиРеквизита) Тогда
		ПолеГруппировки = Список.Группировка.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Поле = Новый ПолеКомпоновкиДанных(ИмяКолонкиРеквизита);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбновитьСписокЗадачНаСервере()
	
	БизнесПроцессыИЗадачиСервер.УстановитьПараметрыСпискаМоихЗадач(Список);
	// Цвет просроченных задач зависит от значения текущей даты,
	// поэтому нужно переинициализировать условное оформление.
	УстановитьУсловноеОформление();
	Элементы.Список.Обновить();
	
КонецПроцедуры

#КонецОбласти
