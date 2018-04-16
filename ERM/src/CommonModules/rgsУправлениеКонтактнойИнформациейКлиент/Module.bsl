////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ СВЯЗАННЫХ С ТАБЛИЦЕЙ КОНТАКТНОЙ ИНФОРМАЦИИ НА ФОРМАХ

Процедура ГиперссылкаНажатие(Форма, Элемент, СтандартнаяОбработка) Экспорт
	
	СтандартнаяОбработка = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизита", Элемент.Имя);
	
	ЭтоТабличнаяЧасть = ЭтоТабличнаяЧасть(Элемент);
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		Если ДанныеЗаполнения = Неопределено Тогда
			Возврат;
		КонецЕсли;
	Иначе
		ДанныеЗаполнения = Форма;
	КонецЕсли;
	
	ДанныеСтроки = ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть);
	
	Если (ДанныеСтроки = Неопределено) Тогда
		Возврат;
	КонецЕсли;
	
	Представление = Форма[ДанныеСтроки.ИмяРеквизита];
	Если Представление = rgsУправлениеКонтактнойИнформациейКлиентСервер.ПредставлениеПустойГиперссылки() Тогда
		Представление = "";
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ТолькоПросмотр", Форма.ТолькоПросмотр);
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ДанныеСтроки.Вид);
	ПараметрыОткрытия.Вставить("ЗначенияПолей", ДанныеСтроки.ЗначенияПолей);
	ПараметрыОткрытия.Вставить("Представление", Представление);
	ПараметрыОткрытия.Вставить("РедактированиеТолькоВДиалоге", Истина);

	Если Не ЭтоТабличнаяЧасть Тогда
		ПараметрыОткрытия.Вставить("Комментарий", ДанныеСтроки.Комментарий);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ГиперссылкаНажатиеЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеЗаполнения",  ДанныеЗаполнения);
	Оповещение.ДополнительныеПараметры.Вставить("ЭтоТабличнаяЧасть", ЭтоТабличнаяЧасть);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеСтроки",      ДанныеСтроки);
	Оповещение.ДополнительныеПараметры.Вставить("Элемент",           Элемент);
	Оповещение.ДополнительныеПараметры.Вставить("Результат",         Результат);
	Оповещение.ДополнительныеПараметры.Вставить("Форма",             Форма);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия, Форма, Оповещение);
	
КонецПроцедуры

// Завершение немодальных диалогов
Процедура ГиперссылкаНажатиеЗавершение(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = ДополнительныеПараметры.ДанныеЗаполнения;
	ДанныеСтроки     = ДополнительныеПараметры.ДанныеСтроки;
	Результат        = ДополнительныеПараметры.Результат;
	Элемент          = ДополнительныеПараметры.Элемент;
	Форма            = ДополнительныеПараметры.Форма;
	
	ТекстПредставления = РезультатЗакрытия.Представление;

	Если ТекстПредставления = rgsУправлениеКонтактнойИнформациейКлиентСервер.ПредставлениеПустойГиперссылки() Тогда
		ТекстПредставления = "";
	КонецЕсли;

	Если ДополнительныеПараметры.ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения[Элемент.Имя + "ЗначенияПолей"] = РезультатЗакрытия.КонтактнаяИнформация;
		
	Иначе
		
		ДанныеСтроки.Представление = ТекстПредставления;
		ДанныеСтроки.ЗначенияПолей = РезультатЗакрытия.КонтактнаяИнформация;
		ДанныеСтроки.Комментарий   = РезультатЗакрытия.Комментарий;
	КонецЕсли;
	
	Форма[ДанныеСтроки.ИмяРеквизита]	= ?(ПустаяСтрока(РезультатЗакрытия.Представление), rgsУправлениеКонтактнойИнформациейКлиентСервер.ПредставлениеПустойГиперссылки(), РезультатЗакрытия.Представление);

	ДанныеЗаполнения[Элемент.Имя] = ТекстПредставления;
	
	Форма.Модифицированность = Истина;
	
	Форма.ПослеИзмененияКонтактнойИнформации(Результат);
	ОбновитьКонтактнуюИнформациюФормы(Форма, Результат);
	
КонецПроцедуры

Функция ПредставлениеНачалоВыбора(Форма, Элемент, Модифицированность = Истина, СтандартнаяОбработка = Ложь) Экспорт
	СтандартнаяОбработка = Ложь;
	
	Результат = Новый Структура;
	Результат.Вставить("ИмяРеквизита", Элемент.Имя);
	
	ЭтоТабличнаяЧасть = ЭтоТабличнаяЧасть(Элемент);
	
	Если ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		Если ДанныеЗаполнения = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
	Иначе
		ДанныеЗаполнения = Форма;
	КонецЕсли;
	
	ДанныеСтроки = ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть);
	
	// Если представление было изменено в поле и не соответствует реквизиту, то приводим в соответствие.
	Если ДанныеЗаполнения[Элемент.Имя] <> Элемент.ТекстРедактирования Тогда
		ДанныеЗаполнения[Элемент.Имя] = Элемент.ТекстРедактирования;
		УправлениеКонтактнойИнформациейКлиент.ПриИзменении(Форма, Элемент, ЭтоТабличнаяЧасть);
		Форма.Модифицированность = Истина;
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("ВидКонтактнойИнформации", ДанныеСтроки.Вид);
	ПараметрыОткрытия.Вставить("ЗначенияПолей", ДанныеСтроки.ЗначенияПолей);
	ПараметрыОткрытия.Вставить("Представление", Элемент.ТекстРедактирования);
	
	Если Не ЭтоТабличнаяЧасть Тогда
		ПараметрыОткрытия.Вставить("Комментарий", ДанныеСтроки.Комментарий);
	КонецЕсли;
	
	Оповещение = Новый ОписаниеОповещения("ПредставлениеНачалоВыбораЗавершение", ЭтотОбъект, Новый Структура);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеЗаполнения",  ДанныеЗаполнения);
	Оповещение.ДополнительныеПараметры.Вставить("ЭтоТабличнаяЧасть", ЭтоТабличнаяЧасть);
	Оповещение.ДополнительныеПараметры.Вставить("ДанныеСтроки",      ДанныеСтроки);
	Оповещение.ДополнительныеПараметры.Вставить("Элемент",           Элемент);
	Оповещение.ДополнительныеПараметры.Вставить("Результат",         Результат);
	Оповещение.ДополнительныеПараметры.Вставить("Форма",             Форма);
	
	УправлениеКонтактнойИнформациейКлиент.ОткрытьФормуКонтактнойИнформации(ПараметрыОткрытия,, Оповещение);
	
	Возврат Неопределено;
КонецФункции

Процедура ПредставлениеНачалоВыбораЗавершение(Знач РезультатЗакрытия, Знач ДополнительныеПараметры) Экспорт
	Если ТипЗнч(РезультатЗакрытия) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеЗаполнения = ДополнительныеПараметры.ДанныеЗаполнения;
	ДанныеСтроки     = ДополнительныеПараметры.ДанныеСтроки;
	Результат        = ДополнительныеПараметры.Результат;
	Элемент          = ДополнительныеПараметры.Элемент;
	Форма            = ДополнительныеПараметры.Форма;
	
	ТекстПредставления = РезультатЗакрытия.Представление;
	
	Если ДополнительныеПараметры.ЭтоТабличнаяЧасть Тогда
		ДанныеЗаполнения[Элемент.Имя + "ЗначенияПолей"] = РезультатЗакрытия.КонтактнаяИнформация;
		
	Иначе
		ДанныеСтроки.Представление = ТекстПредставления;
		ДанныеСтроки.ЗначенияПолей = РезультатЗакрытия.КонтактнаяИнформация;
		ДанныеСтроки.Комментарий   = РезультатЗакрытия.Комментарий;
	КонецЕсли;
	
	ДанныеЗаполнения[Элемент.Имя] = ТекстПредставления;
	
	Форма.Модифицированность = Истина;
	Форма.Подключаемый_ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ

// Контекстный вызов
Процедура ОбновитьКонтактнуюИнформациюФормы(Форма, Результат)

	Форма.Подключаемый_ОбновитьКонтактнуюИнформацию(Результат);
	
КонецПроцедуры

// Возвращает строку дополнительных значений по имени реквизита.
//
// Параметры:
//    Форма   - УправляемаяФорма - передаваемая форма.
//    Элемент - ДанныеФормыСтруктураСКоллекцией - данные формы.
//
// Возвращаемое значение:
//    СтрокаКоллекции - найденные данные.
//    Неопределено    - при отсутствии данных.
//
Функция ПолучитьСтрокуДополнительныхЗначений(Форма, Элемент, ЭтоТабличнаяЧасть = Ложь)
	
	Отбор = Новый Структура("ИмяРеквизита", Элемент.Имя);
	Строки = Форма.КонтактнаяИнформацияОписаниеДополнительныхРеквизитов.НайтиСтроки(Отбор);
	ДанныеСтроки = ?(Строки.Количество() = 0, Неопределено, Строки[0]);
	
	Если ЭтоТабличнаяЧасть И ДанныеСтроки <> Неопределено Тогда
		
		ПутьКСтроке = Форма.Элементы[Форма.ТекущийЭлемент.Имя].ТекущиеДанные;
		
		ДанныеСтроки.Представление = ПутьКСтроке[Элемент.Имя];
		ДанныеСтроки.ЗначенияПолей = ПутьКСтроке[Элемент.Имя + "ЗначенияПолей"];
		
	КонецЕсли;
	
	Возврат ДанныеСтроки;
	
КонецФункции

Функция ЭтоТабличнаяЧасть(Элемент)
	
	Родитель = Элемент.Родитель;
	
	Пока ТипЗнч(Родитель) <> Тип("УправляемаяФорма") Цикл
		
		Если ТипЗнч(Родитель) = Тип("ТаблицаФормы") Тогда
			Возврат Истина;
		КонецЕсли;
		
		Родитель = Родитель.Родитель;
		
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции