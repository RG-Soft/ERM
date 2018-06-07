
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Том = Параметры.Том;
	
	// Определение доступных хранилищ файлов.
	ЗаполнитьИменаХранилищФайлов();
	
	Если ИменаХранилищФайлов.Количество() = 0 Тогда
		ВызватьИсключение НСтр("ru = 'Не найдены хранилища файлов.'");
		
	ИначеЕсли ИменаХранилищФайлов.Количество() = 1 Тогда
		Элементы.ПредставлениеХранилищаФайлов.Видимость = Ложь;
	КонецЕсли;
	
	ИмяХранилищаФайлов = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"ОбщаяФорма.ФайлыВТоме.ОтборПоХранилищам", 
		Строка(Том.УникальныйИдентификатор()) );
	
	Если ИмяХранилищаФайлов = ""
	 ИЛИ ИменаХранилищФайлов.НайтиПоЗначению(ИмяХранилищаФайлов) = Неопределено Тогда
	
		ЭлементВерсииФайлов = ИменаХранилищФайлов.НайтиПоЗначению("ВерсииФайлов");
		
		Если ЭлементВерсииФайлов = Неопределено Тогда
			ИмяХранилищаФайлов = ИменаХранилищФайлов[0].Значение;
			ПредставлениеХранилищаФайлов = ИменаХранилищФайлов[0].Представление;
		Иначе
			ИмяХранилищаФайлов = ЭлементВерсииФайлов.Значение;
			ПредставлениеХранилищаФайлов = ЭлементВерсииФайлов.Представление;
		КонецЕсли;
	Иначе
		ПредставлениеХранилищаФайлов = ИменаХранилищФайлов.НайтиПоЗначению(ИмяХранилищаФайлов).Представление;
	КонецЕсли;
	
	НастроитьДинамическийСписок(ИмяХранилищаФайлов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПредставлениеХранилищаФайловНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПредставлениеХранилищаФайловНачалоВыбораВыборСделан", ЭтотОбъект);
	ПоказатьВыборИзСписка(ОписаниеОповещения, ИменаХранилищФайлов, Элементы.ПредставлениеХранилищаФайлов,
		ИменаХранилищФайлов.НайтиПоЗначению(ИмяХранилищаФайлов));
		
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеХранилищаФайловНачалоВыбораВыборСделан(ТекущееХранилище, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ТекущееХранилище) = Тип("ЭлементСпискаЗначений") Тогда
		ИмяХранилищаФайлов = ТекущееХранилище.Значение;
		ПредставлениеХранилищаФайлов = ТекущееХранилище.Представление;
		НастроитьДинамическийСписок(ИмяХранилищаФайлов);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ОткрытьКарточкуФайла();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	
	ОткрытьКарточкуФайла();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура НастроитьДинамическийСписок(Знач ИмяХранилища)
	
	СвойстваСписка = ОбщегоНазначения.СтруктураСвойствДинамическогоСписка();
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ХранилищеФайлов.Ссылка КАК Ссылка,
	|	ХранилищеФайлов.ИндексКартинки КАК ИндексКартинки,
	|	ХранилищеФайлов.ПутьКФайлу КАК ПутьКФайлу,
	|	ХранилищеФайлов.Размер КАК Размер,
	|	ХранилищеФайлов.Автор КАК Автор,
	|	&ЭтоПрисоединенныеФайлы КАК ЭтоПрисоединенныеФайлы
	|ИЗ
	|	&ИмяСправочника КАК ХранилищеФайлов
	|ГДЕ
	|	ХранилищеФайлов.Том = &Том";
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ИмяСправочника", "Справочник." + ИмяХранилища);
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&ЭтоПрисоединенныеФайлы", ?(
		ВРег(ИмяХранилища) = ВРег("ВерсииФайлов"), "ЛОЖЬ", "ИСТИНА"));
		
	СвойстваСписка.ОсновнаяТаблица = "Справочник." + ИмяХранилища;
	СвойстваСписка.ДинамическоеСчитываниеДанных = Истина;
	СвойстваСписка.ТекстЗапроса = ТекстЗапроса;
	ОбщегоНазначения.УстановитьСвойстваДинамическогоСписка(Элементы.Список, СвойстваСписка);
	
	Список.Параметры.УстановитьЗначениеПараметра("Том", Том);
	
	СохранитьНастройкиОтбора(Том, ИмяХранилищаФайлов);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьИменаХранилищФайлов()
	
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда
		МетаданныеСправочники = Метаданные.Справочники;
		ИменаХранилищФайлов.Добавить(МетаданныеСправочники.ВерсииФайлов.Имя, МетаданныеСправочники.ВерсииФайлов.Представление());
		
		Для каждого Справочник Из Метаданные.Справочники Цикл
			Если СтрЗаканчиваетсяНа(Справочник.Имя, "ДвоичныеДанныеФайлов") Тогда
				ИменаХранилищФайлов.Добавить(Справочник.Имя, Справочник.Представление());
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ИменаХранилищФайлов.СортироватьПоПредставлению();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура СохранитьНастройкиОтбора(Том, ТекущиеНастройки)
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"ОбщаяФорма.ФайлыВТоме.ОтборПоХранилищам",
		Строка(Том.УникальныйИдентификатор()),
		ТекущиеНастройки);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточкуФайла()
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ТекущиеДанные.ЭтоПрисоединенныеФайлы Тогда
		РаботаСФайламиКлиент.ОткрытьФормуФайла(ТекущиеДанные.Ссылка);
	Иначе
		ПоказатьЗначение(, ТекущиеДанные.Ссылка);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
