
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		// Скрытие профиля Администратор.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Справочники.ПрофилиГруппДоступа.Администратор,
			ВидСравненияКомпоновкиДанных.НеРавно, , Истина);
		
		Элементы.Список.ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
		
		АвтоЗаголовок = Ложь;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			
			Заголовок = НСтр("ru = 'Подбор профилей групп доступа'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор профиля групп доступа'");
		КонецЕсли;
	Иначе
		Элементы.Список.РежимВыбора = Ложь;
	КонецЕсли;
	
	Если Параметры.Свойство("ПрофилиСРолямиПомеченнымиНаУдаление") Тогда
		ПоказатьПрофили = "Устаревшие";
	Иначе
		ПоказатьПрофили = "ВсеПрофили";
	КонецЕсли;
	
	Если Не Параметры.РежимВыбора Тогда
		УстановитьОтбор();
	Иначе
		Элементы.ПоказатьПрофили.Видимость = Ложь;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовУправленияФормы

&НаКлиенте
Процедура ПоказатьПрофилиПриИзменении(Элемент)
	
	УстановитьОтбор();
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПользователейНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВыбораНазначения", ЭтотОбъект);
	
	ПользователиСлужебныйКлиент.ВыбратьНазначение(ЭтотОбъект,
		НСтр("ru = 'Выбор назначения профилей'"), Истина, Истина, ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ВидПользователейОчистка(Элемент, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список, "Ссылка.Назначение.ТипПользователей", , , , Ложь);
		
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ОбновитьНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьНаСервере()
	
	УстановитьОтбор();
	
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьОтбор()
	
	Если ПоказатьПрофили = "Устаревшие" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка",
			Справочники.ПрофилиГруппДоступа.НесовместимыеПрофилиГруппДоступа(),
			ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка", , , , Ложь);
	КонецЕсли;
	
	Если ПоказатьПрофили = "Поставляемые" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка.ИдентификаторПоставляемыхДанных",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКомпоновкиДанных.НеРавно, , Истина);
		
	ИначеЕсли ПоказатьПрофили = "Непоставляемые" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка.ИдентификаторПоставляемыхДанных",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКомпоновкиДанных.Равно, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка.ИдентификаторПоставляемыхДанных", , , , Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеВыбораНазначения(МассивТипов, ДополнительныеПараметры) Экспорт
	
	Если МассивТипов.Количество() <> 0 Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список,
			"Ссылка.Назначение.ТипПользователей",
			МассивТипов,
			ВидСравненияКомпоновкиДанных.ВСписке, , Истина);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка.Назначение.ТипПользователей", , , , Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти