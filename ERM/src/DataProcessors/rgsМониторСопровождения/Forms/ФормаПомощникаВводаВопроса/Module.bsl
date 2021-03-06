
////////////////////////////
// Общие процедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
		
	ЗакрыватьПриЗакрытииВладельца = Истина;
	ЗаполнитьТаблицуПроектов();

	Если ПроектОдин Тогда
		Проект = ТаблицаПроектовПользователя[0].НаименованиеПроекта;
		ГУИДПроекта = ТаблицаПроектовПользователя[0].ГУИДПроекта;
	КонецЕсли;
	Если (НЕ ПустаяСтрока(ПроектБазы) ИЛИ  ПроектОдин) Тогда	
		Если ПроверитьЗаполнение() Тогда
			Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаВторая;
			Элементы.ГруппаСтраницыЗаголовков.ТекущаяСтраница = Элементы.ГруппаЗаголовок2;
			Если НЕ Проект = ПредыдущийПроект ИЛИ ТаблицаПользователейПоПроекту.Количество() = 0 Тогда
				ТаблицаПользователейПоПроекту.Очистить();
				Кому = "";
				КомуСписок.Очистить();
				ОтКогоСписок.Очистить();
				ОтКого = ИмяТекПользователя;
				НоваяСтрока = ОтКогоСписок.Добавить();
				НоваяСтрока.ИмяПользователя = ОтКого;
				СторонниеСписок.Очистить();
				ЗаполнитьТаблицуПользователей();
				ЗаполнитьСпискиВыборов();
				Элементы.ГруппаСтраницыОтКого.ТекущаяСтраница = Элементы.ГруппаСтраницаОтКого1;
				Элементы.ГруппаСтраницыКому.ТекущаяСтраница = Элементы.ГруппаСтраницаКому1;
				Элементы.ГруппаСтраницыСторонние.ТекущаяСтраница = Элементы.ГруппаСтраницаСторонние1;
				ПредыдущийПроект = Проект;
				Если НЕ ЗначениеЗаполнено(ДеревоТемСтрокой) Тогда 
					Элементы.ТемаВопроса.ПодсказкаВвода = НСтр("ru = 'Введите тему вопроса'; en = 'Input subject of request'");
					Элементы.ТемаВопроса.РедактированиеТекста = Истина;
				Иначе
					ТемаВопроса = "";
					Элементы.ТемаВопроса.ПодсказкаВвода = "";
					Элементы.ТемаВопроса.РедактированиеТекста = Ложь;
				КонецЕсли;

				СрокОтвета = ПолучитьСрокОтветаПоПроекту();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДеревоТемСтрокой = Параметры.ДеревоТемСтрокой;
	
	Пользователь = Параметры.Пользователь;
	Пароль = Параметры.Пароль;
	АдресБазы = Параметры.АдресБазы;
	ГУИДТекПользователя = Параметры.Объект.ГУИДТекПользователя;
	ИмяТекПользователя = Параметры.Объект.ИмяТекПользователя;
	Объект.СписокПроектовИПользователей.Загрузить(Параметры.Объект.СписокПроектовИПользователей.Выгрузить());
	
	ДатаВопроса = ТекущаяДата();
	Приоритет = "Обычный";
	
	КодЯзыка = НСтр("ru = 'ru'; en = 'en'");
	Элементы.ГруппаНавигацииRU.Видимость = КодЯзыка = "ru";
	Элементы.ГруппаНавигацииEN.Видимость = КодЯзыка = "en";
	
	Администратор = Параметры.Администратор;
	ПроектБазы = Параметры.ПроектБазы;
	ПроектОдин = Параметры.ПроектОдин;
	Элементы.ФормаИзменитьФорму.Видимость = Администратор;
	
	ДанныеФормы = РеквизитФормыВЗначение("Объект");
	ВидимостьПроекта = ДанныеФормы.ВидимостьПроекта(ЗначениеЗаполнено(ПроектБазы), ПроектОдин);
	
	Элементы.Проект.Видимость = ВидимостьПроекта;
	ЗаполнитьСписокВыбораСтатусВопроса(Элементы.Приоритет.СписокВыбора);
		
	ПолучитьНастройкиФормы();
	
КонецПроцедуры

Процедура ЗаполнитьСписокВыбораСтатусВопроса(СписокВыбора)
	
	//Критический(Критический), Высокий(Высокий), Обычный(Обычный), Низкий(Низкий)

	СписокВыбора.Добавить(НСтр("ru = 'Критический'; en = 'Critical'")); 
	СписокВыбора.Добавить(НСтр("ru = 'Высокий'; en = 'High'"));
	СписокВыбора.Добавить(НСтр("ru = 'Обычный'; en = 'Normal'"));
	СписокВыбора.Добавить(НСтр("ru = 'Низкий'; en = 'Low'"));
	
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

&НаКлиенте
Процедура ПроектПредопределен()
	Если НЕ ПустаяСтрока(Проект) Тогда
	    Вперед(Неопределено);
		ОтключитьОбработчикОжидания("ПроектПредопределен");
	КонецЕсли; 
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПрокси(Определение) Экспорт
	
	Возврат Новый WSПрокси (Определение, "RemoteConnect", "RemoteConnect", "RemoteConnectSoap");
	
КонецФункции

&НаКлиенте
Процедура Назад(Команда)
	
	ТекСтраница = Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница;
	Если ТекСтраница = Элементы.ГруппаСтраницаПервая Тогда
		Возврат;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаВторая Тогда
		Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаПервая;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаТретья Тогда
		Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаВторая;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаЧетвертая Тогда
		Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаТретья;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаПятая Тогда
		Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаЧетвертая;
	КонецЕсли;
	УстановитьДоступностьЭлементов();
	// { RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215
	УстановитьЗаголовок();
	// } RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215	
КонецПроцедуры

&НаКлиенте
Процедура Вперед(Команда)
	
	ТекСтраница = Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница;
	Если ТекСтраница = Элементы.ГруппаСтраницаПервая Тогда
		Если ПроверитьЗаполнение() Тогда
			Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаВторая;
			Если НЕ Проект = ПредыдущийПроект ИЛИ ТаблицаПользователейПоПроекту.Количество() = 0 Тогда
				ТаблицаПользователейПоПроекту.Очистить();
				Кому = "";
				КомуСписок.Очистить();
				ОтКогоСписок.Очистить();
				ОтКого = ИмяТекПользователя;
				НоваяСтрока = ОтКогоСписок.Добавить();
				НоваяСтрока.ИмяПользователя = ОтКого;
				СторонниеСписок.Очистить();
				ЗаполнитьТаблицуПользователей();
				ЗаполнитьСпискиВыборов();
				Элементы.ГруппаСтраницыОтКого.ТекущаяСтраница = Элементы.ГруппаСтраницаОтКого1;
				Элементы.ГруппаСтраницыКому.ТекущаяСтраница = Элементы.ГруппаСтраницаКому1;
				Элементы.ГруппаСтраницыСторонние.ТекущаяСтраница = Элементы.ГруппаСтраницаСторонние1;
				ПредыдущийПроект = Проект;
				// { RGS Лунякин Иван 07.10.2015 15:04:18 
				Если НЕ ЗначениеЗаполнено(ДеревоТемСтрокой) Тогда 
					Элементы.ТемаВопроса.ПодсказкаВвода = НСтр("ru = 'Введите тему вопроса'; en = 'Input subject of request'");
					Элементы.ТемаВопроса.РедактированиеТекста = Истина;
				Иначе
					ТемаВопроса = "";
					Элементы.ТемаВопроса.ПодсказкаВвода = "";
					Элементы.ТемаВопроса.РедактированиеТекста = Ложь;
				КонецЕсли;
				// } RGS Лунякин Иван 07.10.2015 15:04:18
				СрокОтвета = ПолучитьСрокОтветаПоПроекту();
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаВторая Тогда
		Если КомуСписок.Количество() = 0 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Необходимо определить, кому адресован вопрос!'; en = 'It is necessary to determine to the request is addressed!'");
			Если Элементы.ГруппаСтраницыКому.ТекущаяСтраница = Элементы.ГруппаСтраницаКому1 Тогда
				Сообщение.Поле = "Кому";
			Иначе
				Сообщение.Поле = "КомуСписок";
			КонецЕсли;
			Сообщение.Сообщить();
			Возврат;
		КонецЕсли;
		ЗаполнитьУчастниковОбсуждения();
		Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаТретья;
		// { RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215
		ЕстьПредопределенныеТемы = Ложь;
		Если НЕ ПустаяСтрока(Проект) Тогда
			ЕстьПредопределенныеТемы = ЗначениеЗаполнено(ДеревоТемСтрокой);
		КонецЕсли;
		Если НЕ ЕстьПредопределенныеТемы Тогда
			Элементы.ТемаВопроса.ПодсказкаВвода = НСтр("ru = 'Введите тему вопроса'; en = 'Input subject of request'");
		Иначе
			Элементы.ТемаВопроса.ПодсказкаВвода = "";
		КонецЕсли;
		Элементы.ТемаВопроса.РедактированиеТекста = НЕ ЕстьПредопределенныеТемы;
		Элементы.ТемаВопроса.КнопкаВыбора = ЕстьПредопределенныеТемы;
		
		// } RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаТретья Тогда
		Текст = ТекстВопроса.ПолучитьТекст();
		Если СтрДлина(Текст) = 0 Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = НСтр("ru = 'Необходимо заполнить текст вопроса!'; en = 'It is necessary to fill in the text of the request!'");
			Сообщение.Поле = "ТекстВопроса";
			Сообщение.Сообщить();
			Возврат;
		ИначеЕсли НЕ ЗначениеЗаполнено(ТемаВопроса) Тогда
			НомерПереносаСтроки = Найти(Текст, Символы.ПС);
			Если НомерПереносаСтроки = 0 Тогда
				ТемаВопроса = Лев(Текст, 150);
			Иначе
				ТемаВопроса = Лев(Текст, Мин((НомерПереносаСтроки-1), 150));
			КонецЕсли;
		КонецЕсли;
		//Если СрокОтвета = 0 Тогда
		//	ТребуемаяДатаОтвета = ТекущаяДата();
		//Иначе
		//	ТребуемаяДатаОтвета = ТекущаяДата() + СрокОтвета*24*60*60;
		//КонецЕсли;
		Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаЧетвертая;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаЧетвертая Тогда
		
		Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаПятая;
		ПроверкаПолеПроект = Проект;
		ПроверкаПриоритет = Приоритет;
		
		ОтКогоСтрока = "";
		Для Каждого Строка Из ОтКогоСписок Цикл
			ОтКогоСтрока = ОтКогоСтрока + Строка.ИмяПользователя + "; ";
		КонецЦикла;
		ОтКогоСтрокой = ОтКогоСтрока;
		
		КомуСтрока = "";
		Для Каждого Строка Из КомуСписок Цикл
			КомуСтрока = КомуСтрока + Строка.ИмяПользователя + "; ";
		КонецЦикла;
		КомуСтрокой = КомуСтрока;

		СторонниеСтрока = "";
		Для Каждого Строка Из СторонниеСписок Цикл
			СторонниеСтрока = СторонниеСтрока + Строка.ИмяПользователя + "; ";
		КонецЦикла;
		СторонниеСтрокой = СторонниеСтрока;
		
		ПроверкаЖелаемаяДата = ТребуемаяДатаОтвета;
		ПроверкаТемаВопроса = ТемаВопроса;
		ПроверкаСодержаниеВопроса = ТекстВопроса;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаПятая Тогда
		Возврат;
	КонецЕсли;
	УстановитьДоступностьЭлементов();
	// { RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215
	УстановитьЗаголовок();
	// } RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215
КонецПроцедуры

// { RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215, заголовки должны изменятся и вперед, и назад
&НаКлиенте
Процедура УстановитьЗаголовок()
	ТекСтраница = Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница;
	Если ТекСтраница = Элементы.ГруппаСтраницаПервая Тогда
		Элементы.ГруппаСтраницыЗаголовков.ТекущаяСтраница = Элементы.ГруппаЗаголовок1;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаВторая Тогда
		Элементы.ГруппаСтраницыЗаголовков.ТекущаяСтраница = Элементы.ГруппаЗаголовок2;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаТретья Тогда
		Элементы.ГруппаСтраницыЗаголовков.ТекущаяСтраница = Элементы.ГруппаЗаголовок3;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаЧетвертая Тогда
		Элементы.ГруппаСтраницыЗаголовков.ТекущаяСтраница = Элементы.ГруппаЗаголовок4;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаПятая Тогда
		Элементы.ГруппаСтраницыЗаголовков.ТекущаяСтраница = Элементы.ГруппаЗаголовок5;
	КонецЕсли;

КонецПроцедуры
// } RGS Глебов Дмитрий 19.09.2016  - ОРР-0003215


&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	// { RGS Лунякин Иван 12.10.2015 14:30:37 Добавлены условия для локализации на английском
	ТекСтраница = Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница;
	Если ТекСтраница = Элементы.ГруппаСтраницаПервая Тогда
		Элементы.ФормаНазад.Доступность 	= Ложь;
		Элементы.ФормаНазадEN.Доступность 	= Ложь;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаВторая Тогда
		Элементы.ФормаНазад.Доступность 	= Истина;
		Элементы.ФормаНазадEN.Доступность 	= Истина;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаТретья Тогда
		Элементы.ФормаНазад.Доступность 	= Истина;
		Элементы.ФормаНазадEN.Доступность 	= Истина;
		Элементы.ГруппаКнопкиВперед.ТекущаяСтраница 	= Элементы.СтраницаВперед;
		Элементы.ГруппаКнопкиВпередEN.ТекущаяСтраница 	= Элементы.СтраницаВпередEN;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаЧетвертая Тогда
		Элементы.ФормаНазад.Доступность 	= Истина;
		Элементы.ФормаНазадEN.Доступность 	= Истина;
		Элементы.ГруппаКнопкиВперед.ТекущаяСтраница 	= Элементы.СтраницаВперед;
		Элементы.ГруппаКнопкиВпередEN.ТекущаяСтраница 	= Элементы.СтраницаВпередEN;
	ИначеЕсли ТекСтраница = Элементы.ГруппаСтраницаПятая Тогда
		Элементы.ФормаНазад.Доступность 	= Истина;
		Элементы.ФормаНазадEN.Доступность 	= Истина;
		Элементы.ГруппаКнопкиВперед.ТекущаяСтраница 	= Элементы.СтраницаСоздатьВопрос;
		Элементы.ГруппаКнопкиВпередEN.ТекущаяСтраница 	= Элементы.СтраницаСоздатьВопросEN;
	КонецЕсли;
	// } RGS Лунякин Иван 12.10.2015 14:30:37
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗакрытьБезПредупреждения Тогда	
		Структура = Новый Структура;
		Структура.Вставить("ТекстВопроса", НСтр("ru = 'Вы уверены, что хотите отменить создание вопроса?'; en = 'Are you sure you want to cancel the creation of the request?'"));
		Структура.Вставить("РежимВопроса","ДаНет");
		Структура.Вставить("ИмяСобытия","ЗакрытиеПомощника");
		// { RGS Лунякин Иван 27.10.2015 13:43:40 
		Структура.Вставить("Администратор", Администратор);
		// } RGS Лунякин Иван 27.10.2015 13:43:40

		Попытка
			ОткрытьФорму("ВнешняяОбработка.rgsМониторСопровождения.Форма.ФормаВопроса", Структура, ЭтаФорма, , ВариантоткрытияОкна.ОтдельноеОкно);
		Исключение
			ОткрытьФорму("Обработка.rgsМониторСопровождения.Форма.ФормаВопроса", Структура, ЭтаФорма, , ВариантоткрытияОкна.ОтдельноеОкно);
		КонецПопытки;
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры


///////////////////////////
// Страница 1


&НаКлиенте
Процедура ТаблицаПроектовПользователяПриАктивизацииСтроки(Элемент)
	
	ТекСтрока = Элемент.ТекущиеДанные;
	Если ТекСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ГУИДПроекта = ТекСтрока.ГУИДПроекта;
	Проект = ТекСтрока.НаименованиеПроекта;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПроектов()
	
	Если Объект.СписокПроектовИПользователей.Количество() = 0 Тогда
		Попытка
			Определение = Новый WSОпределения(АдресБазы+"/ws/MonitorExt.1cws?wsdl", Пользователь, Пароль);
			Прокси = ПолучитьПрокси(Определение);
			Прокси.Пользователь = Пользователь;
			Прокси.Пароль = Пароль; 
			ТаблицаПроектовПользователя.Загрузить(ЗначениеИзСтрокиВнутр(Прокси.СписокПроектовПользователя()));
			Если ТаблицаПроектовПользователя.Количество() = 1 Тогда
				Проект = ТаблицаПроектовПользователя[0].НаименованиеПроекта;
				ГУИДПроекта = ТаблицаПроектовПользователя[0].ГУИДПроекта;
			КонецЕсли;
			ТаблицаПроектовПользователя.Сортировать("НаименованиеПроекта Возр");
			//ЗаполнитьСписокВыбора();
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить(); 
		КонецПопытки; 
	Иначе
		ТаблицаПроектов = Объект.СписокПроектовИПользователей.Выгрузить();
		ТаблицаПроектов.Свернуть("ГУИДПроекта,НаименованиеПроекта,Описание,СрокОтвета");
		ТаблицаПроектовПользователя.Загрузить(ТаблицаПроектов);
		
		Если ТаблицаПроектовПользователя.Количество() >= 1 Тогда
			СтрокаВыбранаАвтоматически = Ложь;
			НомерСтроки = 0;
			Если НЕ ПустаяСтрока(ПроектБазы) Тогда
				СтруктураОтбора = Новый Структура("НаименованиеПроекта", ПроектБазы); 
				МассивНайденныхСтрок = ТаблицаПроектовПользователя.НайтиСтроки(СтруктураОтбора);	
				Если МассивНайденныхСтрок.Количество() <> 0 Тогда
				    НомерСтроки = ТаблицаПроектовПользователя.Индекс(МассивНайденныхСтрок[0]);
					СтрокаВыбранаАвтоматически = Истина;
				КонецЕсли;  
			КонецЕсли; 
			
			Проект = ТаблицаПроектовПользователя[НомерСтроки].НаименованиеПроекта;
			ГУИДПроекта = ТаблицаПроектовПользователя[НомерСтроки].ГУИДПроекта;
			ПредыдущийПроект = Проект;
			СрокОтвета = ТаблицаПроектовПользователя[НомерСтроки].СрокОтвета;
		КонецЕсли;
		
		//Если ТаблицаПроектовПользователя.Количество() = 1 ИЛИ СтрокаВыбранаАвтоматически Тогда
		//	Элементы.ГруппаСтраницыОбщая.ТекущаяСтраница = Элементы.ГруппаСтраницаВторая;
		//	
		//КонецЕсли;
		ТаблицаПроектовПользователя.Сортировать("НаименованиеПроекта Возр");
		//ЗаполнитьСписокВыбора();
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Функция ПолучитьСрокОтветаПоПроекту()
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("НаименованиеПроекта",Проект);
	Строки = ТаблицаПроектовПользователя.НайтиСтроки(СтруктураОтбора);	
	Если Строки.Количество() = 0 Тогда
		Возврат 0;
	Иначе
		Возврат Строки[0].СрокОтвета;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ТаблицаПроектовПользователяВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Вперед(Неопределено);

КонецПроцедуры

///////////////////////////
// Страница 2

&НаКлиенте
Процедура ПоказатьСпискомОтКогоНажатие(Элемент)
	
	Элементы.ГруппаСтраницыОтКого.ТекущаяСтраница = Элементы.ГруппаСтраницаОтКого2;
	НоваяСтрока = ОтКогоСписок.Добавить();
	НоваяСтрока.ИмяПользователя = "Введите имя пользователя...";
	Элементы.ОтКогоСписок.ТекущаяСтрока = НоваяСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура Декорация2Нажатие(Элемент)
	
	Элементы.ГруппаСтраницыСторонние.ТекущаяСтраница = Элементы.ГруппаСтраницаСтрононние2;
	НоваяСтрока = СторонниеСписок.Добавить();
	НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
	Элементы.СторонниеСписок.ТекущаяСтрока = НоваяСтрока;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСпискомКомуНажатие(Элемент)
	
	Элементы.ГруппаСтраницыКому.ТекущаяСтраница = Элементы.ГруппаСтраницаКому2;
    НоваяСтрока = КомуСписок.Добавить();
	НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
	Элементы.КомуСписок.ТекущаяСтрока = НоваяСтрока;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСпискиВыборов()
	
	ПолныйСписокВыбора = Новый Массив;

	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СторонаПользователя", "Спрашивающий");
	СтруктураОтбора.Вставить("ДобавлятьПоУмолчанию", Истина);
	Строки = ТаблицаПользователейПоПроекту.НайтиСтроки(СтруктураОтбора);
	Для Каждого Строка Из Строки Цикл
		НоваяСтрока = ОтКогоСписок.Добавить();	
		НоваяСтрока.ИмяПользователя = Строка.ИмяПользователя;
	КонецЦикла;
	Если ОтКогоСписок.Количество() = 1 Тогда
		ОтКого = ОтКогоСписок[0].ИмяПользователя;
	ИначеЕсли ОтКогоСписок.Количество() > 1 Тогда 
		Элементы.ГруппаСтраницыОтКого.ТекущаяСтраница = Элементы.ГруппаСтраницаОтКого2;
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СторонаПользователя", "Отвечающий");
	СтруктураОтбора.Вставить("ДобавлятьПоУмолчанию", Истина);
	Строки = ТаблицаПользователейПоПроекту.НайтиСтроки(СтруктураОтбора);
	Для Каждого Строка Из Строки Цикл
		НоваяСтрока = КомуСписок.Добавить();	
		НоваяСтрока.ИмяПользователя = Строка.ИмяПользователя;
	КонецЦикла;
	Если КомуСписок.Количество() > 0 Тогда 
		ПолныйСписокВыбора.Добавить(НСтр("ru = 'Техническая поддержка'; en = 'Technical support'"));
		Кому = НСтр("ru = 'Техническая поддержка'; en = 'Technical support'");
	КонецЕсли;
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("СторонаПользователя", НСтр("ru = 'Сторонний наблюдатель'; en = 'Reviewer'"));
	СтруктураОтбора.Вставить("ДобавлятьПоУмолчанию", Истина);
	Строки = ТаблицаПользователейПоПроекту.НайтиСтроки(СтруктураОтбора);
	Для Каждого Строка Из Строки Цикл
		НоваяСтрока = СторонниеСписок.Добавить();	
		НоваяСтрока.ИмяПользователя = Строка.ИмяПользователя;
	КонецЦикла;
	
	Для Каждого Строка Из ТаблицаПользователейПоПроекту Цикл
		ПолныйСписокВыбора.Добавить(Строка.ИмяПользователя);	
	КонецЦикла;

	Элементы.ОтКого.СписокВыбора.ЗагрузитьЗначения(ПолныйСписокВыбора);
	Элементы.ОтКогоСписокИмяПользователя.СписокВыбора.ЗагрузитьЗначения(ПолныйСписокВыбора);
	Элементы.Кому.СписокВыбора.ЗагрузитьЗначения(ПолныйСписокВыбора);
	Элементы.КомуСписокИмяПользователя.СписокВыбора.ЗагрузитьЗначения(ПолныйСписокВыбора);
	Элементы.СторонниеСписокИмяПользователя.СписокВыбора.ЗагрузитьЗначения(ПолныйСписокВыбора);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТаблицуПользователей()
	
	Если Объект.СписокПроектовИПользователей.Количество() = 0 Тогда
		Попытка
			Определение = Новый WSОпределения(АдресБазы+"/ws/MonitorExt.1cws?wsdl", Пользователь, Пароль);
			Прокси = ПолучитьПрокси(Определение);
			Прокси.Пользователь = Пользователь;
			Прокси.Пароль = Пароль; 
			ТаблицаПользователейПоПроекту.Загрузить(ЗначениеИзСтрокиВнутр(Прокси.СписокПользователейПоПроекту(ГУИДПроекта)));
		Исключение
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить(); 
		КонецПопытки; 
	Иначе
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("НаименованиеПроекта",Проект);
		СтрокиПоПроекту = Объект.СписокПроектовИПользователей.НайтиСтроки(СтруктураОтбора);
		ТаблицаПользователей = Объект.СписокПроектовИПользователей.Выгрузить(СтрокиПоПроекту);
		ТаблицаПользователей.Свернуть("ГУИДПользователя,ИмяПользователя,СторонаПользователя,ЯвляетсяСотрудникомПоддержки,ДобавлятьПоУмолчанию");
		ТаблицаПользователейПоПроекту.Загрузить(ТаблицаПользователей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтКогоСписокИмяПользователяНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	Для Каждого ЭлСписка Из ТаблицаПользователейПоПроекту Цикл
		Элемент.СписокВыбора.Добавить(ЭлСписка.ИмяПользователя, ЭлСписка.ИмяПользователя);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтКогоПриИзменении(Элемент)
	
	ОтКогоСписок.Очистить();
	НоваяСтрока = ОтКогоСписок.Добавить();
	НоваяСтрока.ИмяПользователя = ОтКого;
	ПроверитьИУдалитьИзСторонних(ОтКого);

КонецПроцедуры

&НаКлиенте
Процедура КомуПриИзменении(Элемент)
	
	КомуСписок.Очистить();
	Если Кому = НСтр("ru = 'Техническая поддержка'; en = 'Technical support'") Тогда
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("СторонаПользователя", НСтр("ru = 'Отвечающий'; en = 'Responsible'"));
		СтруктураОтбора.Вставить("ДобавлятьПоУмолчанию", Истина);
		Строки = ТаблицаПользователейПоПроекту.НайтиСтроки(СтруктураОтбора);
		Для Каждого Строка Из Строки Цикл
			НоваяСтрока = КомуСписок.Добавить();	
			НоваяСтрока.ИмяПользователя = Строка.ИмяПользователя;
		КонецЦикла;
	ИначеЕсли НЕ Кому = "" Тогда
		НоваяСтрока = КомуСписок.Добавить();
		НоваяСтрока.ИмяПользователя = Кому;
		ПроверитьИУдалитьИзСторонних(ОтКого);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтКогоСписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ПроверитьИУдалитьИзСторонних(Элементы.ОтКогоСписок.ТекущиеДанные.ИмяПользователя);
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяПользователя", НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'"));
	МассивСтрок = ОтКогоСписок.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() = 0 Тогда
		НоваяСтрока = ОтКогоСписок.Добавить();
		НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
		Элементы.ОтКогоСписок.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомуСписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)

	ПроверитьИУдалитьИзСторонних(Элементы.КомуСписок.ТекущиеДанные.ИмяПользователя);
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяПользователя", НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'"));
	МассивСтрок = КомуСписок.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() = 0 Тогда
		НоваяСтрока = КомуСписок.Добавить();
		НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
		Элементы.КомуСписок.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СторонниеСписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяПользователя", НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'"));
	МассивСтрок = СторонниеСписок.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() = 0 Тогда
		НоваяСтрока = СторонниеСписок.Добавить();
		НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
		Элементы.СторонниеСписок.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтКогоСписокПриАктивизацииСтроки(Элемент)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяПользователя", НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'"));
	МассивСтрок = ОтКогоСписок.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() = 0 Тогда
		НоваяСтрока = ОтКогоСписок.Добавить();
		НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
		Элементы.ОтКогоСписок.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомуСписокПриАктивизацииСтроки(Элемент)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяПользователя", НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'"));
	МассивСтрок = КомуСписок.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() = 0 Тогда
		НоваяСтрока = КомуСписок.Добавить();
		НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
		Элементы.КомуСписок.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СторонниеСписокПриАктивизацииСтроки(Элемент)
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяПользователя", НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'"));
	МассивСтрок = СторонниеСписок.НайтиСтроки(СтруктураПоиска);
	Если МассивСтрок.Количество() = 0 Тогда
		НоваяСтрока = СторонниеСписок.Добавить();
		НоваяСтрока.ИмяПользователя = НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'");
		Элементы.СторонниеСписок.ТекущаяСтрока = НоваяСтрока;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьИУдалитьИзСторонних(ИмяПользователя)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИмяПользователя",ИмяПользователя);
	Строки = СторонниеСписок.НайтиСтроки(СтруктураОтбора);
	Для Каждого Строка Из Строки Цикл
		СторонниеСписок.Удалить(Строка);	
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Функция НайтиГУИД(ИмяПользователя)
	
	СтруктураОтбора = Новый Структура;
	СтруктураОтбора.Вставить("ИмяПользователя",ИмяПользователя);
	Строки = ТаблицаПользователейПоПроекту.НайтиСтроки(СтруктураОтбора);	
	Если Строки.Количество() = 0 Тогда
		Возврат "";
	Иначе
		Возврат Строки[0].ГУИДПользователя;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ЗаполнитьУчастниковОбсуждения()
	
	СтруктураПоиска = Новый Структура;
	СтруктураПоиска.Вставить("ИмяПользователя", НСтр("ru = 'Введите имя пользователя...'; en = 'Enter your user name...'"));
	МассивСтрок = ОтКогоСписок.НайтиСтроки(СтруктураПоиска);
	Для Каждого Строка Из МассивСтрок Цикл
		ОтКогоСписок.Удалить(Строка);
	КонецЦикла;
	МассивСтрок = КомуСписок.НайтиСтроки(СтруктураПоиска);
	Для Каждого Строка Из МассивСтрок Цикл
		КомуСписок.Удалить(Строка);
	КонецЦикла;
	МассивСтрок = СторонниеСписок.НайтиСтроки(СтруктураПоиска);
	Для Каждого Строка Из МассивСтрок Цикл
		СторонниеСписок.Удалить(Строка);
	КонецЦикла;
	
	УчастникиОбсуждения.Очистить();
	Для Каждого Участник Из ОтКогоСписок Цикл
		НоваяСтрока = УчастникиОбсуждения.Добавить();
		НоваяСтрока.ИмяПользователя = Участник.ИмяПользователя;
		НоваяСтрока.ГУИДПользователя = НайтиГУИД(Участник.ИмяПользователя);
		НоваяСтрока.СторонаПользователя = "Спрашивающий";
	КонецЦикла;
	Для Каждого Участник Из КомуСписок Цикл
		НоваяСтрока = УчастникиОбсуждения.Добавить();
		НоваяСтрока.ИмяПользователя = Участник.ИмяПользователя;
		НоваяСтрока.ГУИДПользователя = НайтиГУИД(Участник.ИмяПользователя);
		НоваяСтрока.СторонаПользователя = "Отвечающий";
	КонецЦикла;
	МассивУдалить = Новый Массив;
	Для Каждого Участник Из СторонниеСписок Цикл
		СтруктураОтбора = Новый Структура;
		СтруктураОтбора.Вставить("ИмяПользователя",Участник.ИмяПользователя);
		Строки = УчастникиОбсуждения.НайтиСтроки(СтруктураОтбора);
		Если Строки.Количество() = 0 Тогда
			НоваяСтрока = УчастникиОбсуждения.Добавить();
			НоваяСтрока.ИмяПользователя = Участник.ИмяПользователя;
			НоваяСтрока.ГУИДПользователя = НайтиГУИД(Участник.ИмяПользователя);
			НоваяСтрока.СторонаПользователя = НСтр("ru = 'Сторонний наблюдатель'; en = 'Outsider'");
		Иначе
			МассивУдалить.Добавить(Участник);
		КонецЕсли;
	КонецЦикла;
	Для Каждого Строка Из МассивУдалить Цикл
		СторонниеСписок.Удалить(Строка);
	КонецЦикла;
	
КонецПроцедуры

///////////////////////////
// Страница 3

&НаКлиенте
// Процедура - обработчик команды ПроверитьОрфографию.
//
Процедура ПроверитьОрфографию(Команда)
		
	ТекстДляПроверки = ТекстВопроса.ПолучитьТекст();
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ТекстДляПроверки", ТекстДляПроверки);
	СтруктураПараметров.Вставить("ИмяСобытия", "ПроверкаОрфографии_Помощник");
	// { RGS Лунякин Иван 27.10.2015 13:43:40 
	СтруктураПараметров.Вставить("Администратор", Администратор);
	// } RGS Лунякин Иван 27.10.2015 13:43:40

	
	ТекстХТМЛ = Неопределено;
	Попытка
		ОткрытьФорму("ВнешняяОбработка.rgsМониторСопровождения.Форма.ФормаПроверкиОрфографии", СтруктураПараметров, ЭтаФорма);
	Исключение
		ОткрытьФорму("Обработка.rgsМониторСопровождения.Форма.ФормаПроверкиОрфографии", СтруктураПараметров, ЭтаФорма);
	КонецПопытки; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПрисоединенныеФайлы(Команда)
	
	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ТаблицаПрикрепленныхФайлов", ТаблицаПрикрепленныхФайлов);
	СтруктураДанных.Вставить("ИмяСобытия", "ПрикрепленныеФайлы_Помощник");
	
	// { RGS Лунякин Иван 27.10.2015 13:43:40 
	СтруктураДанных.Вставить("Администратор", Администратор);
	// } RGS Лунякин Иван 27.10.2015 13:43:40
	
	Попытка
		ОткрытьФорму("ВнешняяОбработка.rgsМониторСопровождения.Форма.ФормаПрисоединенныхФайлов", СтруктураДанных, ЭтаФорма);
	Исключение
	    ОткрытьФорму("Обработка.rgsМониторСопровождения.Форма.ФормаПрисоединенныхФайлов", СтруктураДанных, ЭтаФорма);
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПравильноеХТМЛ(ТекстХТМЛ)
	
	ТекстВопроса.УстановитьHTML(ТекстХТМЛ, Новый Структура);
	
КонецПроцедуры


///////////////////////////
// Страница 4

&НаКлиенте
Процедура СформироватьВопрос(Команда)
	
	//Если ТребуемаяДатаОтвета = Дата(1,1,1) Тогда
	//	Сообщение = Новый СообщениеПользователю;
	//	Сообщение.Текст = "Укажите требуемую дату ответа!";
	//	Сообщение.Поле = "ТребуемаяДатаОтвета";
	//	Сообщение.Сообщить();
	//	Возврат;
	//КонецЕсли;
	
	Если ТаблицаПрикрепленныхФайлов.Количество()>0 Тогда
		Состояние("Передача информации на сервер..");
	КонецЕсли;
	Результат = СформироватьВопросНаСервере();
	Если Результат <> "true" Тогда
		Предупреждение(Результат);
	Иначе
		ПоказатьОповещениеПользователя(, , Символы.ПС+НСтр("ru = 'Вопрос успешно создан'; en = 'Request successfully created'"));
		Оповестить("НужноОбновитьСписокВопросов", , ЭтаФорма);
		Если БольшеНеИспользоватьПомощник Тогда
			Оповестить("ОтключитьПомощникСозданияВопроса", , ЭтаФорма);
		КонецЕсли;
		ЗакрытьБезПредупреждения = Истина;
		ЭтаФорма.Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Функция СформироватьВопросНаСервере()
	
	Попытка
		ДанныеДляВопроса = СобратьДанныеОВопросе();
		Определение = Новый WSОпределения(АдресБазы+"/ws/MonitorExt.1cws?wsdl", Пользователь, Пароль);
		Прокси = ПолучитьПрокси(Определение);
		Прокси.Пользователь = Пользователь;
		Прокси.Пароль = Пароль; 
		Результат = Прокси.СоздатьНовыйВопрос(ДанныеДляВопроса);
		Возврат Результат;
	Исключение
		Возврат ОписаниеОшибки();
	КонецПопытки; 
	
КонецФункции

&НаСервере
Функция СобратьДанныеОВопросе()
	
	СообщениеХТМЛ = "";
	СтруктураКартинок = Новый Структура;
	ТекстВопроса.ПолучитьHTML(СообщениеХТМЛ, СтруктураКартинок);
	Для Каждого ЭлСтруктуры Из СтруктураКартинок Цикл
		BASE64 = ПолучитьBASE64ПредставлениеКартинки(ЭлСтруктуры.Значение);
		СообщениеХТМЛ = СтрЗаменить(СообщениеХТМЛ, ЭлСтруктуры.Ключ, "data:image;base64,"+BASE64+"");  
	КонецЦикла;
	СообщениеТекст = ТекстВопроса.ПолучитьТекст();

	СтруктураДанных = Новый Структура;
	СтруктураДанных.Вставить("ТемаВопроса", ТемаВопроса);
	СтруктураДанных.Вставить("СообщениеХТМЛ", СообщениеХТМЛ);
	СтруктураДанных.Вставить("СообщениеТекст", СообщениеТекст);
	СтруктураДанных.Вставить("ГУИДПроекта", ГУИДПроекта);
	СтруктураДанных.Вставить("ДатаВопроса", ДатаВопроса);
	
	ДанныеОбъекта = РеквизитФормыВЗначение("Объект");
	
	СтруктураДанных.Вставить("Приоритет", ДанныеОбъекта.ПолучитьИзПредставленияЗначениеСтатуса(Приоритет));
	
	Если ОтКогоСписок.Количество() = 1 Тогда
		СтруктураДанных.Вставить("АвторВопроса", ОтКогоСписок[0].ИмяПользователя);
	КонецЕсли;
	СтруктураДанных.Вставить("ТребуемаяДатаОтвета", ТребуемаяДатаОтвета);
	ТаблицаУчастников = УчастникиОбсуждения.Выгрузить();
	ТаблицаУчастников.Свернуть("ГУИДПользователя,ИмяПользователя,СторонаПользователя,ПолучатьУведомленияПоПочте");
	СтруктураДанных.Вставить("ТаблицаУчастников", УчастникиОбсуждения.Выгрузить());
	Если ТаблицаПрикрепленныхФайлов.Количество()>0 Тогда
		МассивВложений = Новый Массив;
		Для Каждого ЭлементВложений Из ТаблицаПрикрепленныхФайлов Цикл
			СтруктураВложения = Новый Структура;
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(ЭлементВложений.АдресВоВременномХранилище);
			СтруктураВложения.Вставить("Размер", ДвоичныеДанные.Размер());
			СтруктураВложения.Вставить("Расширение", ЭлементВложений.Расширение);
			СтруктураВложения.Вставить("ИмяБезРасширения", ЭлементВложений.ИмяБезРасширения);
			СтруктураВложения.Вставить("ДвоичныеДанные", ДвоичныеДанные);
			МассивВложений.Добавить(СтруктураВложения);			
		КонецЦикла; 
		СтруктураДанных.Вставить("МассивВложений", МассивВложений);
	КонецЕсли; 

	СтруктураДанныхСтрокой = ЗначениеВСтрокуВнутр(СтруктураДанных);
	Возврат СтруктураДанныхСтрокой;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьBASE64ПредставлениеКартинки(Картинка)
	
	Возврат Base64Строка(Картинка.ПолучитьДвоичныеДанные());
	
КонецФункции

&НаКлиенте
Процедура КомуСписокИмяПользователяНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	Элемент.СписокВыбора.Очистить();
	Для Каждого ЭлСписка Из ТаблицаПользователейПоПроекту Цикл
		Элемент.СписокВыбора.Добавить(ЭлСписка.ИмяПользователя, ЭлСписка.ИмяПользователя);
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗакрытиеПомощникаДа" Тогда
		ЗакрытьБезПредупреждения = Истина;
		Закрыть();
	ИначеЕсли ИмяСобытия = "ПроверкаОрфографии_Помощник" Тогда
		Если Параметр <> Неопределено Тогда
			УстановитьПравильноеХТМЛ(Параметр);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ПрикрепленныеФайлы_Помощник" Тогда
		Если Параметр <> Неопределено  Тогда
			ТаблицаПрикрепленныхФайлов.Очистить();
			Для Каждого Строка Из Параметр Цикл
				НоваяСтрока = ТаблицаПрикрепленныхФайлов.Добавить();
				ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
			КонецЦикла; 
		КонецЕсли;
    // { RGS Лунякин Иван 07.10.2015 13:53:17 	
	ИначеЕсли ИмяСобытия = "ОбработкаВыбора" Тогда
		ОбработкаВыбора(Параметр);
		// } RGS Лунякин Иван 07.10.2015 13:53:17	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОтмена(Команда)
	
	ЭтаФорма.Закрыть();
	
КонецПроцедуры

/////////////////////////////////////

&НаКлиенте
Процедура ТемаВопросаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)  
	Если НЕ ПустаяСтрока(Проект) Тогда
		Если ЗначениеЗаполнено(ДеревоТемСтрокой) Тогда
			Структура = Новый Структура; 
			Структура.Вставить("Администратор", Администратор);
			Структура.Вставить("Проект", Проект);
			Структура.Вставить("ДеревоТемСтрокой", ДеревоТемСтрокой);
			Попытка
				ОткрытьФорму("ВнешняяОбработка.rgsМониторСопровождения.Форма.ФормаВыбораТемыНовогоВопроса", Структура, ЭтаФорма,,ВариантОткрытияОкна.ОтдельноеОкно);
			Исключение
				//Сообщить(ОписаниеОшибки());
				ОткрытьФорму("Обработка.rgsМониторСопровождения.Форма.ФормаВыбораТемыНовогоВопроса", Структура, ЭтаФорма,,ВариантОткрытияОкна.ОтдельноеОкно);
			КонецПопытки;	
		КонецЕсли;
	КонецЕсли; 	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(Параметр, ДополнительныеПараметры = Неопределено) Экспорт
	РезультатЗакрытия = Неопределено;
	Если Параметр.Свойство("РезультатЗакрытия", РезультатЗакрытия) И НЕ РезультатЗакрытия = "Other" Тогда
		УстановитьТекстТемы(РезультатЗакрытия, Истина);
	Иначе
		Тема = "";
		ПоказатьВводСтроки(Новый ОписаниеОповещения("ПродолжитьВводТемы", ЭтаФорма) , Тема, НСтр("ru = 'Введите тему вопроса'; en = 'Input request'") ,,Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьТекстТемы(Текст, ТемаИзСписка);
	ТемаВопроса = Текст;
	Элементы.ТемаВопроса.РедактированиеТекста = НЕ ТемаИзСписка;
	Элементы.ТемаВопроса.ПодсказкаВвода = ?(ТемаИзСписка, "", НСтр("ru = 'Введите тему вопроса'; en = 'Input request'"));
КонецПроцедуры
	
&НаКлиенте
Процедура ПродолжитьВводТемы(Текст, ДополнительныеПараметры) Экспорт
	УстановитьТекстТемы(Текст, Ложь)
КонецПроцедуры

&НаКлиенте
Процедура ТемаВопросаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;	
	Если  НЕ ВыбранноеЗначение = "Other" Тогда
		УстановитьТекстТемы(ВыбранноеЗначение, Истина);
	Иначе
		Тема = "";
		ПоказатьВводСтроки(Новый ОписаниеОповещения("ПродолжитьВводТемы", ЭтаФорма) , Тема, НСтр("ru = 'Введите тему вопроса'; en = 'Input request'") ,,Истина);
	КонецЕсли
КонецПроцедуры



