
// Параметры формы:
//     Уровень                           - Число  - Запрашиваемый уровень.
//     Родитель                          - УникальныйИдентификатор - Родительский объект.
//     СкрыватьНеактуальныеАдреса        - Булево - флаг того, что при неактуальные адреса будут скрываться.
//     ФорматАдреса - Строка - вариант классификатора.
//     Идентификатор                     - УникальныйИдентификатор - Текущий адресный элемент.
//     Представление                     - Строка - Представление текущего элемента,. используется если не указан
//                                                  Идентификатор.
//
// Результат выбора:
//     Структура - с полями
//         * Отказ                      - Булево - флаг того, что при обработке произошла ошибка.
//         * КраткоеПредставлениеОшибки - Строка - Описание ошибки.
//         * Идентификатор              - УникальныйИдентификатор - Данные адреса.
//         * Представление              - Строка                  - Данные адреса.
//         * РегионЗагружен             - Булево                  - Имеет смысл только для регионов, Истина, если есть
//                                                                  записи.
// ---------------------------------------------------------------------------------------------------------------------
//
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	НомерПорции = Неопределено;
	
	Параметры.Свойство("Родитель", Родитель);
	Параметры.Свойство("Уровень",  Уровень);
	Параметры.Свойство("СкрыватьНеактуальныеАдреса", СкрыватьНеактуальныеАдреса);
	Параметры.Свойство("ФорматАдреса", ФорматАдреса);
	
	Если ПустаяСтрока(ФорматАдреса) Тогда
		ФорматАдреса = "ФИАС";
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("СкрыватьНеактуальные", СкрыватьНеактуальныеАдреса);
	ПараметрыПоиска.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыПоиска.Вставить("Сортировка",   "ASC");
	ПараметрыПоиска.Вставить("ПерваяЗапись", НомерПорции);
	
	// Порционный режим, если необходимо.
	ПолучениеДанныхСИспользованиемВебСервиса = УправлениеКонтактнойИнформациейСлужебный.КлассификаторДоступенЧерезВебСервис();

	Элементы.ПорционнаяНавигация.Видимость = ПолучениеДанныхСИспользованиемВебСервиса;
	
	Если ПолучениеДанныхСИспользованиемВебСервиса Тогда
		// РазмерПорции - одновременно флаг режима работы.
		РазмерПорции = 100;
		Элементы.ГруппаНайтиВебСервис.Видимость = Истина;
		Элементы.ГруппаНайти.Видимость = Ложь;
	Иначе
		РазмерПорции = Неопределено;
		Элементы.ГруппаНайтиВебСервис.Видимость = Ложь;
		Элементы.ГруппаНайти.Видимость = Истина;
	КонецЕсли;
	ПараметрыПоиска.Вставить("РазмерПорции", РазмерПорции);
		
	ДанныеКлассификатора = УправлениеКонтактнойИнформациейСлужебный.АдресаДляИнтерактивногоВыбора(Родитель, Уровень, ПараметрыПоиска);
	
	ДанныеКлассификатораДополнительныеТерритории = УправлениеКонтактнойИнформациейСлужебный.АдресаДляИнтерактивногоВыбора(Родитель, 90, ПараметрыПоиска);
	Если ДанныеКлассификатораДополнительныеТерритории.Данные.Количество() = 0 Тогда
		Элементы.ДополнительныеТерритории.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	Если ДанныеКлассификатора.Данные.Количество() = 0 Тогда
		Элементы.УлицыИНаселенныеПункты.Видимость = Ложь;
		Элементы.Страницы.ОтображениеСтраниц = ОтображениеСтраницФормы.Нет;
	КонецЕсли;
	Если Элементы.ДополнительныеТерритории.Видимость = Ложь И Элементы.УлицыИНаселенныеПункты.Видимость = Ложь Тогда
		КраткоеПредставлениеОшибки = НСтр("ru = 'Данные о улицах, населенных пунктах и дополнительных территориях для введенного адреса отсутствуют'");
		Возврат;
	КонецЕсли;
	Элементы.ВыбратьУлицу.КнопкаПоУмолчанию = Истина;
	
	ВариантыАдреса.Загрузить(ДанныеКлассификатора.Данные);
	ВариантыДополнительныхТерриторий.Загрузить(ДанныеКлассификатораДополнительныеТерритории.Данные);
	ОчищатьПодчиненные = Ложь;
	УстановитьДанныеПоПредставлениюУлицы(Параметры.ПредставлениеУлицы, Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Не ПустаяСтрока(КраткоеПредставлениеОшибки) Тогда
		ОповеститьВладельца(Неопределено, Истина);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура НайтиАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание = 0 Тогда
		// Формирование списка быстрого выбора, стандартную обработку не надо трогать.
		Возврат;
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Текст) Тогда
		ЗаполнитьПорциюВариантовПоПервойБукве(Текст);
	Иначе
		ПерейтиВНачалоСписка();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьУлицу(Команда)
	ПроизвестиВыбор(Элементы.ВариантыАдреса.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	ПроизвестиВыбор(Элементы.ВариантыДополнительныхТерриторий.ТекущаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВариантыДополнительныхТерриторийВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ПроизвестиВыбор(ВыбраннаяСтрока);
КонецПроцедуры

&НаКлиенте
Процедура ВариантыАдресаВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	ПроизвестиВыбор(Значение);
	
КонецПроцедуры

&НаКлиенте
Процедура ДополнительныйЭлементНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ВариантыАдреса.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийРодитель = ТекущиеДанные.Идентификатор;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыОткрытия.Вставить("СкрыватьНеактуальныеАдреса",        СкрыватьНеактуальныеАдреса);
	
	ПараметрыОткрытия.Вставить("Уровень",  90);
	ПараметрыОткрытия.Вставить("Родитель", ТекущийРодитель);
	
	ПараметрыОткрытия.Вставить("Идентификатор", ИдентификаторДополнительного);
	ОткрытьФорму("Обработка.ВводКонтактнойИнформации.Форма.ВыборАдресаПоУровню", ПараметрыОткрытия, Элемент);
	
КонецПроцедуры

&НаКлиенте
Процедура ПодчиненныйЭлементНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(ИдентификаторДополнительного) Тогда
		ТекущийРодитель = ИдентификаторДополнительного;
	Иначе
		ТекущиеДанные = Элементы.ВариантыАдреса.ТекущиеДанные;
		Если ТекущиеДанные = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ТекущийРодитель = ТекущиеДанные.Идентификатор;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыОткрытия.Вставить("СкрыватьНеактуальныеАдреса",        СкрыватьНеактуальныеАдреса);
	
	ПараметрыОткрытия.Вставить("Уровень",  91);
	ПараметрыОткрытия.Вставить("Родитель", ТекущийРодитель);
	
	ПараметрыОткрытия.Вставить("Идентификатор", ИдентификаторПодчиненного);
	
	ОткрытьФорму("Обработка.ВводКонтактнойИнформации.Форма.ВыборАдресаПоУровню", ПараметрыОткрытия, Элемент);
КонецПроцедуры

&НаКлиенте
Процедура ПодчиненныйЭлементДляТерриторииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.ВариантыДополнительныхТерриторий.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ТекущийРодитель = ТекущиеДанные.Идентификатор;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыОткрытия.Вставить("СкрыватьНеактуальныеАдреса",        СкрыватьНеактуальныеАдреса);
	
	ПараметрыОткрытия.Вставить("Уровень",  91);
	ПараметрыОткрытия.Вставить("Родитель", ТекущийРодитель);
	
	ПараметрыОткрытия.Вставить("Идентификатор", ИдентификаторПодчиненногоДляТерритории);
	
	ОткрытьФорму("Обработка.ВводКонтактнойИнформации.Форма.ВыборАдресаПоУровню", ПараметрыОткрытия, Элемент);

КонецПроцедуры

&НаКлиенте
Процедура ДополнительныйЭлементОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда 
		СтандартнаяОбработка = Ложь;
		ИдентификаторДополнительного = ВыбранноеЗначение.Идентификатор;
		ДополнительныйЭлемент = ВыбранноеЗначение.Представление;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодчиненныйЭлементОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда 
		СтандартнаяОбработка = Ложь;
		ИдентификаторПодчиненного = ВыбранноеЗначение.Идентификатор;
		ПодчиненныйЭлемент = ВыбранноеЗначение.Представление;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПодчиненныйЭлементДляТерриторииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда 
		СтандартнаяОбработка = Ложь;
		ИдентификаторПодчиненногоДляТерритории = ВыбранноеЗначение.Идентификатор;
		ПодчиненныйЭлементДляТерритории = ВыбранноеЗначение.Представление;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если ТекущаяСтраница = Элементы.УлицыИНаселенныеПункты Тогда 
		Элементы.ВыбратьУлицу.КнопкаПоУмолчанию = Истина;
	Иначе
		Элементы.ВариантыДополнительныхТерриторийВыбрать.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	ОчищатьПодчиненные = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыАдресаПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено И ЕстьПодчиненныеЭлементы(Элемент.ТекущиеДанные.Идентификатор) Тогда
		Элементы.ДополнительныйЭлемент.Доступность = Истина;
		Элементы.ПодчиненныйЭлемент.Доступность = Истина;
	Иначе
		Элементы.ДополнительныйЭлемент.Доступность = Ложь;
		Элементы.ПодчиненныйЭлемент.Доступность = Ложь;
	КонецЕсли;
	Если ОчищатьПодчиненные Тогда
		ДополнительныйЭлемент = Неопределено;
		ПодчиненныйЭлемент = Неопределено;
	Иначе 
		ОчищатьПодчиненные = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВариантыДополнительныхТерриторийПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено И ЕстьПодчиненныеЭлементы(Элемент.ТекущиеДанные.Идентификатор, 91) Тогда
		Элементы.ПодчиненныйЭлементДляТерритории.Доступность = Истина;
	Иначе
		Элементы.ПодчиненныйЭлементДляТерритории.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область КомандыФормы

&НаКлиенте
Процедура ПерваяПорция(Команда)
	
	Если РазмерПорции = Неопределено Тогда
		Возврат;
	КонецЕсли;
		
	ПерейтиВНачалоСписка();

КонецПроцедуры

&НаКлиенте
Процедура ПредыдущаяПорция(Команда)
	
	ЧислоЗаписей = ВариантыАдреса.Количество();
	Если ЧислоЗаписей = 0 Или РазмерПорции = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НомерПорции > 0 Тогда
		НомерПорции = НомерПорции - 1;
	Иначе
		НомерПорции = Неопределено;
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("СкрыватьНеактуальные",              Ложь);
	ПараметрыПоиска.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыПоиска.Вставить("РазмерПорции", РазмерПорции);
	ПараметрыПоиска.Вставить("ПерваяЗапись", НомерПорции);
	ПараметрыПоиска.Вставить("Сортировка",   "DESC");
	
	ЗаполнитьПорциюВариантов(ПараметрыПоиска);
КонецПроцедуры

&НаКлиенте
Процедура СледующаяПорция(Команда)
	
	ЧислоЗаписей = ВариантыАдреса.Количество();
	Если ЧислоЗаписей = 0 Или РазмерПорции = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(НомерПорции) Тогда
		НомерПорции = НомерПорции + 1;
	Иначе
		НомерПорции = 1;
	КонецЕсли;
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("СкрыватьНеактуальные",              Ложь);
	ПараметрыПоиска.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыПоиска.Вставить("РазмерПорции", РазмерПорции);
	ПараметрыПоиска.Вставить("ПерваяЗапись", НомерПорции);
	ПараметрыПоиска.Вставить("Сортировка",   "ASC");
	
	ЗаполнитьПорциюВариантов(ПараметрыПоиска);
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиНаПорцию(Команда)
	
	ВариантыПерехода= Новый СписокЗначений;
	
	ВариантыПерехода.Добавить("1", "1..9");
	Варианты = "АБВГДЕЖЗИЙКЛМНОПРСТУВХЦЧШЩЫЭЮЯ";
	Для Позиция = 1 По СтрДлина(Варианты) Цикл
		Буква = Сред(Варианты, Позиция, 1);
		ВариантыПерехода.Добавить(Буква, Буква + "...");
	КонецЦикла;
	
	ПерваяБуква = Неопределено;
	ТекущиеДанные = Элементы.ВариантыАдреса.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		ПерваяБуква = ВариантыПерехода.НайтиПоЗначению( ВРег(Лев(СокрЛ(ТекущиеДанные.Представление), 1)) );
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПереходНаПозициюПоПервойБукве", ЭтотОбъект);
	ПоказатьВыборИзМеню(Оповещение, ВариантыПерехода, Элементы.КоманднаяПанельПерейтиНаПорцию);
КонецПроцедуры

&НаКлиенте
Процедура ПереходНаПозициюПоПервойБукве(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		
		ЗаполнитьПорциюВариантовПоПервойБукве(Результат.Значение);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПроизвестиВыбор(Знач НомерСтроки)
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.ДополнительныеТерритории Тогда 
		Данные = ВариантыДополнительныхТерриторий.НайтиПоИдентификатору(Элементы.ВариантыДополнительныхТерриторий.ТекущаяСтрока);
	Иначе
		Данные = ВариантыАдреса.НайтиПоИдентификатору(НомерСтроки);
	КонецЕсли;
	
	Если Данные = Неопределено Тогда
		Возврат;
	ИначеЕсли Не Данные.Неактуален Тогда
		ОповеститьВладельца(Данные);
		Возврат;
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПроизвестиВыборЗавершениеВопроса", ЭтотОбъект, Данные);
	
	ПредупреждениеНеактуальности = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Адрес ""%1"" неактуален.
		           |Продолжить?'"), Данные.Представление);
	ЗаголовокПредупреждения = НСтр("ru = 'Подтверждение'");
	
	ПоказатьВопрос(Оповещение, ПредупреждениеНеактуальности, РежимДиалогаВопрос.ДаНет, , ,ЗаголовокПредупреждения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПерейтиВНачалоСписка()
	
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("СкрыватьНеактуальные",              Ложь);
	ПараметрыПоиска.Вставить("ФорматАдреса", ФорматАдреса);
	ПараметрыПоиска.Вставить("РазмерПорции", РазмерПорции);
	ПараметрыПоиска.Вставить("ПерваяЗапись", Неопределено);
	ПараметрыПоиска.Вставить("Сортировка",   "ASC");
	
	ЗаполнитьПорциюВариантов(ПараметрыПоиска);
	
КонецПроцедуры


&НаКлиенте
Процедура ПроизвестиВыборЗавершениеВопроса(Знач РезультатВопроса, Знач ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ОповеститьВладельца(ДополнительныеПараметры);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОповеститьВладельца(Знач Данные, Отказ = Ложь)
	
	Результат = СтруктураВыбранногоАдреса();
	Если Не Отказ Тогда
		ЗаполнитьЗначенияСвойств(Результат, Данные);
		Если Элементы.Страницы.ТекущаяСтраница = Элементы.ДополнительныеТерритории Тогда
			Результат.Улица = "";
			Результат.ДополнительныйЭлемент = Данные.Представление;
			Результат.ПодчиненныйЭлемент = ПодчиненныйЭлементДляТерритории;
			
			Если ЗначениеЗаполнено(ИдентификаторПодчиненногоДляТерритории) Тогда
				Результат.Идентификатор = ИдентификаторПодчиненного;
			КонецЕсли;
		Иначе
			Результат.Улица = Данные.Представление;
			Результат.ДополнительныйЭлемент = ДополнительныйЭлемент;
			Результат.ПодчиненныйЭлемент = ПодчиненныйЭлемент;
			
			Если ЗначениеЗаполнено(ИдентификаторПодчиненного) Тогда
				Результат.Идентификатор = ИдентификаторПодчиненного;
			ИначеЕсли ЗначениеЗаполнено(ИдентификаторДополнительного) Тогда
				Результат.Идентификатор = ИдентификаторДополнительного;
			КонецЕсли;
		КонецЕсли;
		Результат.Представление = СформироватьПредставлениеАдреса(Результат);
	Иначе
		Результат.Отказ = Истина;
	КонецЕсли;
	
	Результат.КраткоеПредставлениеОшибки = КраткоеПредставлениеОшибки;
	
	
	ОповеститьОВыборе(Результат);
КонецПроцедуры

&НаКлиенте
Функция СтруктураВыбранногоАдреса()
	СтруктураАдреса = Новый Структура;
	СтруктураАдреса.Вставить("Представление", Неопределено);
	СтруктураАдреса.Вставить("Улица", Неопределено);
	СтруктураАдреса.Вставить("Идентификатор", Неопределено);
	СтруктураАдреса.Вставить("ДополнительныйЭлемент", Неопределено);
	СтруктураАдреса.Вставить("ПодчиненныйЭлемент", Неопределено);
	СтруктураАдреса.Вставить("РегионЗагружен", Истина);
	СтруктураАдреса.Вставить("Неактуален", Ложь);
	СтруктураАдреса.Вставить("КраткоеПредставлениеОшибки", "");
	СтруктураАдреса.Вставить("Отказ", Ложь);
	
	Возврат СтруктураАдреса;
КонецФункции

&НаКлиенте
Функция СформироватьПредставлениеАдреса(СтруктураАдреса)
	
	Результат = "";
	
	Разделитель = "";
	Если ЗначениеЗаполнено(СтруктураАдреса.Улица) Тогда
		Результат = СтруктураАдреса.Улица;
		Разделитель = ", ";
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтруктураАдреса.ДополнительныйЭлемент) Тогда
		Результат = Результат + Разделитель + СтруктураАдреса.ДополнительныйЭлемент;
		Разделитель = ", ";
	КонецЕсли;
		
	Если ЗначениеЗаполнено(СтруктураАдреса.ПодчиненныйЭлемент) Тогда
		Результат = Результат + Разделитель + СтруктураАдреса.ПодчиненныйЭлемент;
		Разделитель = ", ";
	КонецЕсли;
	
	Возврат Результат;
КонецФункции

&НаСервере
Процедура ЗаполнитьПорциюВариантов(ПараметрыПоиска)
	
	ДанныеКлассификатора = УправлениеКонтактнойИнформациейСлужебный.АдресаДляИнтерактивногоВыбора(Родитель, Уровень, ПараметрыПоиска);
	Если ДанныеКлассификатора.Отказ Тогда
		// Сервис на обслуживании
		Возврат;
	КонецЕсли;
	
	Если ДанныеКлассификатора.Данные.Количество() > 0 Тогда
		ВариантыАдреса.Очистить();
		ВариантыАдреса.Загрузить(ДанныеКлассификатора.Данные);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПорциюВариантовПоПервойБукве(Текст)
	ДанныеВыбора = Новый СписокЗначений;
	
	Если СтрДлина(Текст) < 1 Или Не ЗначениеЗаполнено(Родитель)Тогда
		// Нет вариантов, список пуст, стандартную обработку не надо трогать.
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ФорматАдреса", "ФИАС");
	ДополнительныеПараметры.Вставить("СкрыватьНеактуальные", Ложь);
	
	ДанныеКлассификатора = УправлениеКонтактнойИнформациейСлужебный.СписокАвтоподбораУлицы(Родитель, Текст, ДополнительныеПараметры);
	Если ДанныеКлассификатора.Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеВыбора = ДанныеКлассификатора.Данные;
	
	// Стандартную обработку отключаем, только если есть наши варианты.
	Если ДанныеВыбора.Количество() > 0 Тогда
		СтандартнаяОбработка = Ложь;
		ВариантыАдреса.Очистить();
		Для каждого Адрес Из ДанныеВыбора Цикл
			СтрокаАдреса = ВариантыАдреса.Добавить();
			СтрокаАдреса.Представление = Адрес.Значение.Значение.Представление;
			СтрокаАдреса.Идентификатор = Адрес.Значение.Значение.Идентификатор;
			СтрокаАдреса.Неактуален = Адрес.Пометка;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоПредставлениюУлицы(Представление, ИдентификаторРодителя)
	
	АнализКлассификатора =УправлениеКонтактнойИнформациейСлужебный.УлицыПоПредставлению(ИдентификаторРодителя, Представление);
	Если АнализКлассификатора <> Неопределено Тогда
		ДанныеУлицы = АнализКлассификатора.Найти(7, "Уровень");
		Если ДанныеУлицы <> Неопределено Тогда
			Отбор = Новый Структура("Представление",ДанныеУлицы.Значение);
			Варианты = ВариантыАдреса.НайтиСтроки(Отбор);
			Если Варианты.Количество() > 0 Тогда 
				Элементы.ВариантыАдреса.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
			КонецЕсли;
			ДанныеДополнительныйЭлемент = АнализКлассификатора.Найти(90, "Уровень");
			Если ДанныеДополнительныйЭлемент <> Неопределено Тогда
				ДополнительныйЭлемент = ДанныеДополнительныйЭлемент.Значение;
			КонецЕсли;
			ДанныеПодчиненныйЭлемент = АнализКлассификатора.Найти(91, "Уровень");
			Если ДанныеПодчиненныйЭлемент <> Неопределено Тогда 
				ПодчиненныйЭлемент = ДанныеПодчиненныйЭлемент.Значение;
			КонецЕсли;
		Иначе
			ДанныеДополнительныйЭлемент = АнализКлассификатора.Найти(90, "Уровень");
			Если ДанныеДополнительныйЭлемент <> Неопределено Тогда 
				Отбор = Новый Структура("Представление", ДанныеДополнительныйЭлемент.Значение);
				Варианты = ВариантыДополнительныхТерриторий.НайтиСтроки(Отбор);
				Если Варианты.Количество() > 0 Тогда
					Элементы.ВариантыДополнительныхТерриторий.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
				КонецЕсли;
				Элементы.Страницы.ТекущаяСтраница = Элементы.ДополнительныеТерритории;
			КонецЕсли;
			ДанныеПодчиненныйЭлементДляТерритории = АнализКлассификатора.Найти(91, "Уровень");
			Если ДанныеПодчиненныйЭлементДляТерритории <> Неопределено Тогда 
				ПодчиненныйЭлементДляТерритории = ДанныеПодчиненныйЭлементДляТерритории.Значение;
			КонецЕсли;
		КонецЕсли;
	Иначе
		ЧастиУлицы = СтрРазделить(Представление, ",", Ложь);
		Если ЧастиУлицы.Количество() = 3 Тогда
			Отбор = Новый Структура("Представление", СокрЛП(ЧастиУлицы[0]));
			Варианты = ВариантыАдреса.НайтиСтроки(Отбор);
			Если Варианты.Количество() > 0 Тогда 
				Элементы.ВариантыАдреса.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
			КонецЕсли;
			ДополнительныйЭлемент = СокрЛП(ЧастиУлицы[1]);
			ПодчиненныйЭлемент = СокрЛП(ЧастиУлицы[2]);
		ИначеЕсли ЧастиУлицы.Количество() = 2 Тогда
			Отбор = Новый Структура("Представление", СокрЛП(ЧастиУлицы[0]));
			Варианты = ВариантыАдреса.НайтиСтроки(Отбор);
			Если Варианты.Количество() > 0 Тогда
				Элементы.ВариантыАдреса.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
				Если Элементы.УлицыИНаселенныеПункты.Видимость Тогда
					ДополнительныйЭлемент = СокрЛП(ЧастиУлицы[1]);
				Иначе
					ПодчиненныйЭлементДляТерритории = СокрЛП(ЧастиУлицы[1]);
				КонецЕсли;
			Иначе
				Варианты = ВариантыДополнительныхТерриторий.НайтиСтроки(Отбор);
				Если Варианты.Количество() > 0 Тогда
					Элементы.ВариантыДополнительныхТерриторий.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
					Если Элементы.УлицыИНаселенныеПункты.Видимость Тогда
						ДополнительныйЭлемент = СокрЛП(ЧастиУлицы[1]);
					Иначе
						ПодчиненныйЭлементДляТерритории = СокрЛП(ЧастиУлицы[1]);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли ЧастиУлицы.Количество() = 1 Тогда
			Отбор = Новый Структура("Представление", СокрЛП(ЧастиУлицы[0]));
			Варианты = ВариантыАдреса.НайтиСтроки(Отбор);
			Если Варианты.Количество() > 0 Тогда
				Элементы.ВариантыАдреса.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
			Иначе
				Варианты = ВариантыДополнительныхТерриторий.НайтиСтроки(Отбор);
				Если Варианты.Количество() > 0 Тогда
					Элементы.ВариантыДополнительныхТерриторий.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
					Элементы.Страницы.ТекущаяСтраница = Элементы.ДополнительныеТерритории;
				Иначе
					Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.АдресныйКлассификатор") Тогда
						АдресныйОбъект = УправлениеКонтактнойИнформациейКлиентСервер.НаименованиеСокращение(Представление);
						
						МодульАдресныйКлассификаторСлужебный = ОбщегоНазначения.ОбщийМодуль("АдресныйКлассификаторСлужебный");
						Результат = МодульАдресныйКлассификаторСлужебный.УлицаИДополнительнаяТерритория(АдресныйОбъект, ИдентификаторРодителя);
						Если Результат <> Неопределено Тогда
							Отбор = Новый Структура("Идентификатор", Результат.ИдентификаторУлицы);
							Варианты = ВариантыАдреса.НайтиСтроки(Отбор);
							Элементы.ВариантыАдреса.ТекущаяСтрока = Варианты[0].ПолучитьИдентификатор();
							ИдентификаторДополнительного = Результат.Идентификатор;
							ДополнительныйЭлемент = Результат.Значение;
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЕстьПодчиненныеЭлементы(Идентификатор, Уровень = 90)
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Свойство("ФорматАдреса", "ФИАС");
	ПараметрыПоиска.Свойство("СкрыватьНеактуальные", Истина);

	ДанныеКлассификатора = УправлениеКонтактнойИнформациейСлужебный.АдресаДляИнтерактивногоВыбора(Идентификатор, Уровень, ПараметрыПоиска);
	Если ДанныеКлассификатора.Данные.Количество() > 0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти
