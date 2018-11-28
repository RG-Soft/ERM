
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервере
Процедура ЗаполнитьТаблицуПользователей()
	
	Попытка
		Определение = Новый WSОпределения(Объект.АдресБазы+"/ws/MonitorExt.1cws?wsdl", Объект.Пользователь, Объект.Пароль);
		Прокси = ПолучитьПрокси(Определение);
		Прокси.Пользователь = Объект.Пользователь;
		Прокси.Пароль = Объект.Пароль; 
		ТаблицаПользователейПоПроекту.Загрузить(ЗначениеИзСтрокиВнутр(Прокси.СписокПользователейПоПроекту(ГУИДПроекта)));
		МассивПользователей = Новый Массив;
		Для Каждого Строка Из ТаблицаПользователейПоПроекту Цикл
			МассивПользователей.Добавить(Строка.ИмяПользователя);
		КонецЦикла;
		Элементы.ТаблицаПользователейИмяПользователя.СписокВыбора.ЗагрузитьЗначения(МассивПользователей);
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить(); 
	КонецПопытки; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// { RGS Лунякин Иван 12.11.2015 9:56:06    
	ТаблицаУчастниковОбсуждения = Параметры.УчастникиОбсуждения.Выгрузить();
	УчастникиОбсуждения.Загрузить(ПолучитьТехническуюСторонуПользователя(ТаблицаУчастниковОбсуждения));
	// } RGS Лунякин Иван 12.11.2015 9:56:06
	ГУИДПроекта = Параметры.ГУИДПроекта;
	Объект.Пользователь = Параметры.Объект.Пользователь;
	Объект.Пароль		= Параметры.Объект.Пароль;
	Объект.АдресБазы 	= Параметры.Объект.АдресБазы;
	
	// { RGS Лунякин Иван 27.10.2015 12:49:28 
	Администратор 		= Параметры.Администратор;
	Элементы.ФормаИзменитьФорму.Видимость = Администратор;
	// } RGS Лунякин Иван 27.10.2015 12:49:28
	
	// { RGS Лунякин Иван 03.11.2015 16:29:30 
	ПолучитьНастройкиФормы();
	ЗаполнитьСписокВыбораСторонаПользователя();
	// } RGS Лунякин Иван 03.11.2015 16:29:30
	
   	ЗаполнитьТаблицуПользователей();
    ПроставлениеТП();
	Если Параметры.Свойство("ИмяСобытия") Тогда
		ИмяСобытия = Параметры.ИмяСобытия;
	КонецЕсли;
	
	//Спрашивающий(Спрашивающий), Отвечающий(Отвечающий), Сторонний наблюдатель(Сторонний наблюдатель)	
	
КонецПроцедуры

// { RGS Лунякин Иван 03.11.2015 16:26:16

&НаСервере
Функция ПолучитьТехническуюСторонуПользователя(ТаблицаИсточник)
	 
	ТаблицаПриемник	= УчастникиОбсуждения.Выгрузить();
	ТаблицаПриемник.Очистить();
	
	Если ТаблицаИсточник.Количество() Тогда
	    Возврат(ЗаполнитьюСторонуПользователя(ТаблицаПриемник, ТаблицаИсточник));
	Иначе	
		Возврат(ТаблицаПриемник);
	КонецЕсли;
	
КонецФункции // ()

&НаСервереБезКонтекста
Функция ЗаполнитьюСторонуПользователя(ТаблицаПриемник, ТаблицаИсточник)
	Для каждого СтрокаТаблицыИсточника Из ТаблицаИсточник Цикл
		СтрокаТаблицыПриемника = ТаблицаПриемник.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаТаблицыПриемника, СтрокаТаблицыИсточника, , "СторонаПользователя");
		
		Если СтрокаТаблицыИсточника.СторонаПользователя = "Спрашивающий" Тогда
			СтрокаТаблицыПриемника.СторонаПользователя = НСтр("ru = 'Спрашивающий'; en = 'Requester'");
			СтрокаТаблицыПриемника.СторонаПользователяТехническая = СтрокаТаблицыИсточника.СторонаПользователя;
		ИначеЕсли СтрокаТаблицыИсточника.СторонаПользователя = "Отвечающий" Тогда
			СтрокаТаблицыПриемника.СторонаПользователя = НСтр("ru = 'Отвечающий'; en = 'Responsible'");
			СтрокаТаблицыПриемника.СторонаПользователяТехническая = СтрокаТаблицыИсточника.СторонаПользователя;
		ИначеЕсли СтрокаТаблицыИсточника.СторонаПользователя = "Сторонний наблюдатель" Тогда
			СтрокаТаблицыПриемника.СторонаПользователя = НСтр("ru = 'Сторонний наблюдатель'; en = 'Reviewer'");
			СтрокаТаблицыПриемника.СторонаПользователяТехническая = СтрокаТаблицыИсточника.СторонаПользователя;
		КонецЕсли; 
		
	КонецЦикла; 		  	
	Возврат ТаблицаПриемник;
КонецФункции // ()
  

&НаСервере
Процедура ЗаполнитьСписокВыбораСторонаПользователя()
	СписокВыбора = Элементы.ТаблицаПользователейСторонаПользователя.СписокВыбора;	
	СписокВыбора.Очистить();
	СписокВыбора.Добавить(НСтр("ru = 'Спрашивающий'; 			en = 'Requester'"));
	СписокВыбора.Добавить(НСтр("ru = 'Отвечающий'; 				en = 'Responsible'"));
	СписокВыбора.Добавить(НСтр("ru = 'Сторонний наблюдатель'; 	en = 'Reviewer'"));
КонецПроцедуры


&НаСервере
Процедура ПолучитьНастройкиФормы()

	СтруктураНастроекФормы = ХранилищеНастроекДанныхФорм.Загрузить(ЭтаФорма.ИмяФормы, "НастройкаФорм");
	Если СтруктураНастроекФормы <> Неопределено Тогда
	   ХранилищеСистемныхНастроек.Сохранить(ЭтаФорма.ИмяФормы + "/НастройкиФормы",,СтруктураНастроекФормы);
	КонецЕсли;
	СтруктураНастроекОкна = ХранилищеНастроекДанныхФорм.Загрузить(ЭтаФорма.ИмяФормы, "НастройкаОкна");
	Если СтруктураНастроекФормы <> Неопределено Тогда
	   ХранилищеСистемныхНастроек.Сохранить(ЭтаФорма.ИмяФормы + "/НастройкиОкна",,СтруктураНастроекОкна);
	КонецЕсли;

КонецПроцедуры

// } RGS Лунякин Иван 03.11.2015 16:26:16 

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД

&НаКлиенте
Процедура ОК(Команда)
	
	Если Не ПроверитьЗаполнениеПользователей(УчастникиОбсуждения, "УчастникиОбсуждения") Тогда
		Возврат;
	КонецЕсли; 
	
	Если ИмяСобытия = "ОбсуждающиеНовогоВопроса" Тогда
		// { RGS Лунякин Иван 12.11.2015 10:29:42   
		Оповестить("ОбсуждающиеНовогоВопроса", ПереФормироватьТаблицуУчастникиОбсуждения(), ЭтаФорма);
		// } RGS Лунякин Иван 12.11.2015 10:29:42
	КонецЕсли;
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

// { RGS Лунякин Иван 12.11.2015 10:30:50

&НаСервере
Функция ПереФормироватьТаблицуУчастникиОбсуждения()
	
	ВременнаяТаблица = РеквизитФормыВЗначение("УчастникиОбсуждения");
	
	ВременнаяТаблица.Колонки.Удалить("СторонаПользователя");
	ВременнаяТаблица.Колонки.СторонаПользователяТехническая.Имя = "СторонаПользователя";
	ВременнаяТаблица.Колонки.Добавить("СторонаПользователяТехническая", Новый ОписаниеТипов("Строка", ,
																		Новый КвалификаторыСтроки(25, ДопустимаяДлина.Переменная)));
	ЗначениеВРеквизитФормы(ВременнаяТаблица, "УчастникиОбсуждения");
	
	Возврат УчастникиОбсуждения;
КонецФункции
// } RGS Лунякин Иван 12.11.2015 10:30:50

&НаКлиенте
// Проверка заполнения таблицы на клиенте.
// Параметры:
// Отказ  - параметр отказа,
// Таблица - таблица для проверки,
// НазваниеТаблицы - имя таблицы для проверки строкой. 
//
Функция ПроверитьЗаполнениеПользователей(Таблица, НазваниеТаблицы) 
	
	// Проверка незаполненных и повторяющихся пользователей.
	НомерСтроки = Таблица.Количество()-1;
	
	Пока  НомерСтроки >= 0 Цикл
		ТекущаяСтрока = Таблица.Получить(НомерСтроки);
		// Проверка заполнения значения.
		Если НЕ ЗначениеЗаполнено(ТекущаяСтрока.ИмяПользователя) Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Не заполнен пользователь!'; en = 'Do not fill the user!'");
			Сообщение.Поле = НазваниеТаблицы + "[" + Формат(НомерСтроки, "ЧГ=0") + "].ИмяПользователя";
			Сообщение.Сообщить(); 
			Возврат Ложь;
		КонецЕсли;

		// Проверка наличия повторяющихся значений.
		НайденныеЗначения = Таблица.НайтиСтроки(Новый Структура("ИмяПользователя, СторонаПользователя", ТекущаяСтрока.ИмяПользователя, ТекущаяСтрока.СторонаПользователя));
		Если НайденныеЗначения.Количество() > 1 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст =НСтр("ru = 'Пользователь повторяется!'; en = 'The user repeats!'");
			Сообщение.Поле = НазваниеТаблицы + "["  + Формат(НомерСтроки, "ЧГ=0") + "].ИмяПользователя";
			Сообщение.Сообщить(); 
			Возврат Ложь;
		КонецЕсли;
		НомерСтроки = НомерСтроки - 1;
	КонецЦикла;
	
	Возврат Истина;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
Процедура ТаблицаПользователейИмяПользователяНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	Для Каждого ЭлСписка Из ТаблицаПользователейПоПроекту Цикл
		Элемент.СписокВыбора.Добавить(ЭлСписка.ИмяПользователя, ЭлСписка.ИмяПользователя);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПользователейИмяПользователяОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Массив = ТаблицаПользователейПоПроекту.НайтиСтроки(Новый Структура("ИмяПользователя", ВыбранноеЗначение));
	Если Массив.Количество()>0 Тогда
		Элементы.ТаблицаПользователей.ТекущиеДанные.ГУИДПользователя = Массив[0].ГУИДПользователя;
	КонецЕсли; 
 	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПользователейПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элементы.ТаблицаПользователей.ТекущиеДанные.СторонаПользователя = НСтр("ru = 'Отвечающий'; en = 'Responsible'");
		ЗаполнитьТехническуюСторонуПользователя();
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаСервере
Процедура ПроставлениеТП()

	Для каждого Строка Из УчастникиОбсуждения Цикл
	    Пар = Новый Структура();
		Пар.Вставить("ИмяПользователя", Строка.ИмяПользователя);
		СтрокаПроектов = ТаблицаПользователейПоПроекту.НайтиСтроки(Пар);
		Если СтрокаПроектов.Количество() = 1 Тогда
			Строка.ЯвляетсяСотрудникомПоддержки = СтрокаПроектов[0].ЯвляетсяСотрудникомПоддержки;
		КонецЕсли;	
	КонецЦикла; 	

КонецПроцедуры 


&НаКлиенте
Процедура ТаблицаПользователейПриИзменении(Элемент)
	ТекДанные = Элементы.ТаблицаПользователей.ТекущиеДанные;
	Если ТекДанные <> Неопределено Тогда
		Пар = Новый Структура();
		Пар.Вставить("ИмяПользователя", ТекДанные.ИмяПользователя);
		СтрокаПроектов = ТаблицаПользователейПоПроекту.НайтиСтроки(Пар);
		Если СтрокаПроектов.Количество() = 1 Тогда
			ТекДанные.ЯвляетсяСотрудникомПоддержки = СтрокаПроектов[0].ЯвляетсяСотрудникомПоддержки;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПрокси(Определение) Экспорт
	
	Возврат Новый WSПрокси (Определение, "RemoteConnect", "RemoteConnect", "RemoteConnectSoap");
	
КонецФункции


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗакрыватьПриЗакрытииВладельца = Истина;
	
КонецПроцедуры


&НаКлиенте
Процедура ТаблицаПользователейСторонаПользователяПриИзменении(Элемент)
	ЗаполнитьТехническуюСторонуПользователя();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТехническуюСторонуПользователя()
	
	ТекущаяСтрока = Элементы.ТаблицаПользователей.ТекущиеДанные;
	
	Если ТекущаяСтрока.СторонаПользователя = НСтр("ru = 'Спрашивающий'; en = 'Requester'") Тогда
		
		ТекущаяСтрока.СторонаПользователяТехническая = "Спрашивающий";
		
	ИначеЕсли ТекущаяСтрока.СторонаПользователя = НСтр("ru = 'Отвечающий'; en = 'Responsible'") Тогда
		
		ТекущаяСтрока.СторонаПользователяТехническая = "Отвечающий";
		
	ИначеЕсли ТекущаяСтрока.СторонаПользователя = НСтр("ru = 'Сторонний наблюдатель'; en = 'Reviewer'") Тогда
		
		ТекущаяСтрока.СторонаПользователяТехническая = "Сторонний наблюдатель";
		
	КонецЕсли;
	
КонецПроцедуры
 
