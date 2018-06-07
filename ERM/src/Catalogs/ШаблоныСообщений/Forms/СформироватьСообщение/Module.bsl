#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Предмет            = Параметры.Предмет;
	ВидСообщения       = Параметры.ВидСообщения;
	РежимВыбора        = Параметры.РежимВыбора;
	ВладелецШаблона    = Параметры.ВладелецШаблона;
	ПараметрыСообщения = Параметры.ПараметрыСообщения;
	ПодготовитьШаблон  = Параметры.ПодготовитьШаблон;
	
	Если ЗначениеЗаполнено(Предмет) И ТипЗнч(Предмет) <> Тип("Строка") Тогда
		ПолноеИмяТипаОснования = Предмет.Метаданные().ПолноеИмя();
	КонецЕсли;
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		ПредназначенДляSMS = Истина;
		ПредназначенДляЭлектронныхПисем = Ложь;
		Заголовок = НСтр("ru = 'Шаблоны сообщений SMS'");
	Иначе
		ПредназначенДляSMS = Ложь;
		ПредназначенДляЭлектронныхПисем = Истина;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ШаблоныСообщений) Тогда
		ЕстьПравоИзменения = Ложь;
		Элементы.ФормаИзменить.Видимость = Ложь;
		Элементы.ФормаСоздать.Видимость  = Ложь;
	Иначе
		ЕстьПравоИзменения = Истина;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		Элементы.ФормаСформироватьИОтправить.Видимость = Ложь;
		Элементы.ФормаСформировать.Заголовок = НСтр("ru='Выбрать'");
	ИначеЕсли ПодготовитьШаблон Тогда
		Элементы.ФормаСформироватьИОтправить.Видимость = Ложь;
	КонецЕсли;
	
	ЗаполнитьСписокДоступныхШаблонов();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_ШаблоныСообщений" Тогда
		СсылкаНаВыбранныйЭлемент = Неопределено;
		Если Элементы.Шаблоны.ТекущиеДанные <> Неопределено Тогда
			СсылкаНаВыбранныйЭлемент = Элементы.Шаблоны.ТекущиеДанные.Ссылка;
		КонецЕсли;
		ЗаполнитьСписокДоступныхШаблонов();
		НайденныеСтроки = Шаблоны.НайтиСтроки(Новый Структура("Ссылка", СсылкаНаВыбранныйЭлемент));
		Если НайденныеСтроки.Количество() > 0 Тогда
			Элементы.Шаблоны.ТекущаяСтрока = НайденныеСтроки[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если НЕ ПоказыватьФормуВыбораШаблонов Тогда
		ПараметрыОтправки = КонструкторПараметровОтправки();
		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Ложь;
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыШаблоны

&НаКлиенте
Процедура ШаблоныПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	Если Копирование И НЕ Группа Тогда
		СоздатьНовыйШаблон(Элемент.ТекущиеДанные.Ссылка);
	Иначе
		СоздатьНовыйШаблон();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПриАктивизацииСтроки(Элемент)
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		Элементы.ФормаСформироватьИОтправить.Доступность = (Элемент.ТекущиеДанные.Имя <> "<БезШаблона>");
		Если Элемент.ТекущиеДанные.ТипТекстаПисьма = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
			Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаФорматированныйДокумент;
			ПодключитьОбработчикОжидания("ОбновитьДанныеПредпросмотра", 0.2, Истина);
		Иначе
			Элементы.СтраницыПредпросмотра.ТекущаяСтраница = Элементы.СтраницаОбычныйТекст;
			ПредпросмотрОбычныйТекст.УстановитьТекст(Элемент.ТекущиеДанные.ТекстШаблона);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Если Элемент.ТекущиеДанные <> Неопределено Тогда
		ПараметрыФормы = Новый Структура("Ключ", Элемент.ТекущиеДанные.Ссылка);
		ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ШаблоныВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	СформироватьСообщениеПоВыбранномШаблону();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Сформировать(Команда)
	
	СформироватьСообщениеПоВыбранномШаблону();
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьИОтправить(Команда)
	
	ТекущиеДанные = Шаблоны.НайтиПоИдентификатору(Элементы.Шаблоны.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = КонструкторПараметровОтправки(ТекущиеДанные.Ссылка);
	ПараметрыОтправки.ДополнительныеПараметры.ОтправитьСразу = Истина;
	Если ТекущиеДанные.ЕстьПроизвольныеПараметры Тогда
		ВводПараметров(ТекущиеДанные.Ссылка, ПараметрыОтправки, Истина);
	Иначе
		ОтравитьСообщение(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Создать(Команда)
	СоздатьНовыйШаблон();
КонецПроцедуры

&НаКлиенте
Процедура ВводПараметров(Шаблон, ПараметрыОтправки, ОтправлятьСразу)
	
	ПараметрыДляЗаполнения = Новый Структура("Шаблон, Предмет", Шаблон, Предмет);
	
	Оповещение = Новый ОписаниеОповещения("ПослеВводаПараметров", ЭтотОбъект, ПараметрыОтправки);
	ОткрытьФорму("Справочник.ШаблоныСообщений.Форма.ЗаполнитьПроизвольныеПараметры", ПараметрыДляЗаполнения,,,,, Оповещение);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СформироватьСообщениеПоВыбранномШаблону()
	
	ТекущиеДанные = Шаблоны.НайтиПоИдентификатору(Элементы.Шаблоны.ТекущаяСтрока);
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если РежимВыбора Тогда
		Закрыть(ТекущиеДанные.Ссылка);
		Возврат;
	КонецЕсли;
	
	ПараметрыОтправки = КонструкторПараметровОтправки(ТекущиеДанные.Ссылка);
	ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
	
	Если ТекущиеДанные.ЕстьПроизвольныеПараметры Тогда
		ВводПараметров(ТекущиеДанные.Ссылка, ПараметрыОтправки, Ложь);
	Иначе
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьСообщениеДляОтправки(ПараметрыОтправки)
	
	АдресВременногоХранилища = Неопределено;
	АдресВременногоХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
	
	АдресРезультата = СформироватьСообщениеНаСервере(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения);
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Результат.Вставить("Предмет", Предмет);
	Результат.Вставить("Шаблон",  ПараметрыОтправки.Шаблон);
	Если ПараметрыОтправки.ДополнительныеПараметры.Свойство("ПараметрыСообщения")
		И ТипЗнч(ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения) = Тип("Структура") Тогда
		ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Результат, ПараметрыСообщения, Ложь);
	КонецЕсли;
	
	Если ПараметрыОтправки.ДополнительныеПараметры.ОтправитьСразу Тогда
		ПослеФормированияИОтправкиСообщения(Результат, ПараметрыОтправки);
	Иначе
		Если ПодготовитьШаблон Тогда
			Закрыть(Результат);
		Иначе
			Закрыть();
			ПоказатьФормуСообщения(Результат);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьСообщениеНаСервере(АдресВременногоХранилища, ПараметрыОтправки, ВидСообщения)
	
	ПараметрыВызоваСервера = Новый Структура();
	ПараметрыВызоваСервера.Вставить("ПараметрыОтправки", ПараметрыОтправки);
	ПараметрыВызоваСервера.Вставить("ВидСообщения",      ВидСообщения);
	
	ШаблоныСообщенийСлужебный.СформироватьСообщениеВФоне(ПараметрыВызоваСервера, АдресВременногоХранилища);
	
	Возврат АдресВременногоХранилища;
	
КонецФункции

&НаКлиенте
Процедура ПослеВводаПараметров(Результат, ПараметрыОтправки) Экспорт
	
	Если Результат <> Неопределено И Результат <> КодВозвратаДиалога.Отмена Тогда
		ПараметрыОтправки.ДополнительныеПараметры.ПроизвольныеПараметры = Результат;
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтравитьСообщение(Знач ПараметрыОтправкиСообщения)
	
	Если ВидСообщения = "Письмо" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			ОписаниеОповещения = Новый ОписаниеОповещения("ОтравитьСообщениеПроверкаУчетнойЗаписиВыполнена", ЭтотОбъект, ПараметрыОтправкиСообщения);
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.ПроверитьНаличиеУчетнойЗаписиДляОтправкиПочты(ОписаниеОповещения);
		КонецЕсли;
	Иначе
		СформироватьСообщениеДляОтправки(ПараметрыОтправкиСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтравитьСообщениеПроверкаУчетнойЗаписиВыполнена(УчетнаяЗаписьНастроена, ПараметрыОтправки) Экспорт
	
	Если УчетнаяЗаписьНастроена = Истина Тогда
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеФормированияИОтправкиСообщения(Результат, ПараметрыОтправки)
	
	Если Результат.Отправлено Тогда;
		Закрыть();
	Иначе
		Оповещение = Новый ОписаниеОповещения("ПослеВопросаОбОткрытиеФормыСообщения", ЭтотОбъект, ПараметрыОтправки);
		ОписаниеОшибки = Результат.ОписаниеОшибки + Символы.ПС + НСтр("ru = 'Открыть форму отправки сообщения?'");
		ПоказатьВопрос(Оповещение, ОписаниеОшибки, РежимДиалогаВопрос.ДаНет);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПоказатьФормуСообщения(Сообщение)
	
	Если ВидСообщения = "СообщениеSMS" Тогда
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.ОтправкаSMS") Тогда 
			МодульОтправкаSMSКлиент= ОбщегоНазначенияКлиент.ОбщийМодуль("ОтправкаSMSКлиент");
			ДополнительныеПараметры = Новый Структура("ИсточникКонтактнойИнформации, ПеревестиВТранслит");
			
			Если Сообщение.ДополнительныеПараметры <> Неопределено Тогда
				ЗаполнитьЗначенияСвойств(ДополнительныеПараметры, Сообщение.ДополнительныеПараметры);
			КонецЕсли;
			
			ДополнительныеПараметры.ИсточникКонтактнойИнформации = Предмет;
			ДополнительныеПараметры.Вставить("Предмет", Предмет);
			Текст      = ?(Сообщение.Свойство("Текст"), Сообщение.Текст, "");
			Получатель = ?(Сообщение.Свойство("Получатель"), Сообщение.Получатель.ВыгрузитьЗначения(), Новый СписокЗначений);
			МодульОтправкаSMSКлиент.ОтправитьSMS(Получатель, Текст, ДополнительныеПараметры);
		КонецЕсли;
	Иначе
		Если ОбщегоНазначенияКлиент.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСПочтовымиСообщениями") Тогда
			МодульРаботаСПочтовымиСообщениямиКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("РаботаСПочтовымиСообщениямиКлиент");
			МодульРаботаСПочтовымиСообщениямиКлиент.СоздатьНовоеПисьмо(Сообщение);
		КонецЕсли;
	КонецЕсли;
	
	Если Сообщение.Свойство("СообщенияПользователю")
		И Сообщение.СообщенияПользователю <> Неопределено
		И Сообщение.СообщенияПользователю.Количество() > 0 Тогда
			Для каждого СообщенияПользователю Из Сообщение.СообщенияПользователю Цикл
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщенияПользователю.Текст,
					СообщенияПользователю.КлючДанных, СообщенияПользователю.Поле, СообщенияПользователю.ПутьКДанным);
			КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция КонструкторПараметровОтправки(Шаблон = Неопределено)
	
	ПараметрыОтправки = ШаблоныСообщенийКлиентСервер.КонструкторПараметровОтправки(Шаблон, Предмет, УникальныйИдентификатор);
	ПараметрыОтправки.ДополнительныеПараметры.ВидСообщения       = ВидСообщения;
	ПараметрыОтправки.ДополнительныеПараметры.ПараметрыСообщения = ПараметрыСообщения;
	
	Возврат ПараметрыОтправки;
	
КонецФункции

&НаКлиенте
Процедура ПослеВопросаОбОткрытиеФормыСообщения(Результат, ПараметрыОтправки) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПараметрыОтправки.ДополнительныеПараметры.ОтправитьСразу                                  = Ложь;
		ПараметрыОтправки.ДополнительныеПараметры.ПреобразовыватьHTMLДляФорматированногоДокумента = Истина;
		СформироватьСообщениеДляОтправки(ПараметрыОтправки);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СоздатьНовыйШаблон(ЗначениеКопирования = Неопределено)
	
	ПараметрыФормы = Новый Структура();
	ПараметрыФормы.Вставить("ВидСообщения"          , ВидСообщения);
	ПараметрыФормы.Вставить("ПолноеИмяТипаОснования", ПолноеИмяТипаОснования);
	ПараметрыФормы.Вставить("ТолькоДляАвтора",        Истина);
	ПараметрыФормы.Вставить("ВладелецШаблона",        ВладелецШаблона);
	ПараметрыФормы.Вставить("ЗначениеКопирования",    ЗначениеКопирования);
	ПараметрыФормы.Вставить("Новый",                  Истина);
	
	Оповещение = Новый ОписаниеОповещения("ОбновитьОкно", ЭтотОбъект);
	ОткрытьФорму("Справочник.ШаблоныСообщений.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОкно(Результат, ДополнительныеПараметры) Экспорт
	ЗаполнитьСписокДоступныхШаблонов();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокДоступныхШаблонов()
	
	Шаблоны.Очистить();
	ТипШаблона = ?(ПредназначенДляSMS, "SMS", "Письмо");
	Запрос = ШаблоныСообщенийСлужебный.ПодготовитьЗапросДляПолученияСпискаШаблонов(ТипШаблона, Предмет, ВладелецШаблона);
	
	РезультатЗапроса = Запрос.Выполнить().Выбрать();
		
	Пока РезультатЗапроса.Следующий() Цикл
		НоваяСтрока = Шаблоны.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РезультатЗапроса);
		
		Если РезультатЗапроса.ШаблонПоВнешнейОбработке
			И ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки") Тогда
				МодульДополнительныеОтчетыИОбработки = ОбщегоНазначения.ОбщийМодуль("ДополнительныеОтчетыИОбработки");
				ВнешнийОбъект = МодульДополнительныеОтчетыИОбработки.ОбъектВнешнейОбработки(РезультатЗапроса.ВнешняяОбработка);
				ПараметрыШаблона = ВнешнийОбъект.ПараметрыШаблона();
				
				Если ПараметрыШаблона.Количество() > 1 Тогда
					ЕстьПроизвольныеПараметры = Истина;
				Иначе
					ЕстьПроизвольныеПараметры = Ложь;
				КонецЕсли;
		Иначе
			ПроизвольныеПараметры = РезультатЗапроса.ЕстьПроизвольныеПараметры.Выгрузить();
			ЕстьПроизвольныеПараметры = ПроизвольныеПараметры.Количество() > 0;
		КонецЕсли;
		
		НоваяСтрока.ЕстьПроизвольныеПараметры = ЕстьПроизвольныеПараметры;
	КонецЦикла;
	
	Если Шаблоны.Количество() = 0 Тогда
		НастройкиШаблоновСообщений = ШаблоныСообщенийСлужебныйПовтИсп.ПриОпределенииНастроек();
		ПоказыватьФормуВыбораШаблонов = НастройкиШаблоновСообщений.ВсегдаПоказыватьФормуВыбораШаблонов;
	Иначе
		ПоказыватьФормуВыбораШаблонов = Истина;
	КонецЕсли;
	
	Шаблоны.Сортировать("Представление");
	
	Если НЕ РежимВыбора И НЕ ПодготовитьШаблон Тогда
		ПерваяСтрока = Шаблоны.Вставить(0);
		ПерваяСтрока.Имя = "<БезШаблона>";
		ПерваяСтрока.Представление = НСтр("ru = '<Без шаблона>'");
	КонецЕсли;
	
	Если Шаблоны.Количество() = 0 Тогда
		Элементы.ФормаСоздать.ТолькоВоВсехДействиях = Ложь;
		Элементы.ФормаСоздать.Отображение = ОтображениеКнопки.КартинкаИТекст;
		Элементы.ФормаСформировать.Доступность           = Ложь;
		Элементы.ФормаСформироватьИОтправить.Доступность = Ложь;
	Иначе
		Элементы.ФормаСформировать.Доступность           = Истина;
		Элементы.ФормаСформироватьИОтправить.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеПредпросмотра()
	ТекущиеДанные = Элементы.Шаблоны.ТекущиеДанные;
	Если ТекущиеДанные <> Неопределено Тогда
		УстановитьHTMLВФорматированныйДокумент(ТекущиеДанные.ТекстШаблона, ТекущиеДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьHTMLВФорматированныйДокумент(ТекстШаблонаПисьмаHTML, СсылкаНаТекущийОбъект);
	
	ПараметрШаблона = Новый Структура("Шаблон, УникальныйИдентификатор");
	ПараметрШаблона.Шаблон = СсылкаНаТекущийОбъект;
	ПараметрШаблона.УникальныйИдентификатор = УникальныйИдентификатор;
	Сообщение = ШаблоныСообщенийСлужебный.КонструкторСообщения();
	Сообщение.Текст = ТекстШаблонаПисьмаHTML;
	ШаблоныСообщенийСлужебный.ОбработатьHTMLДляФорматированногоДокумента(ПараметрШаблона, Сообщение, Истина);
	СтруктураВложений = Новый Структура();
	Для каждого ВложениеВHTML Из Сообщение.Вложения Цикл
		Изображение = Новый Картинка(ПолучитьИзВременногоХранилища(ВложениеВHTML.АдресВоВременномХранилище));
		СтруктураВложений.Вставить(ВложениеВHTML.Представление, Изображение);
	КонецЦикла;
	ПредпросмотрФорматированныйДокумент.УстановитьHTML(Сообщение.Текст, СтруктураВложений);
	
КонецПроцедуры

#КонецОбласти