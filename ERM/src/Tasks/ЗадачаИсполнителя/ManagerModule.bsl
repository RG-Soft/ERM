#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// Возвращает реквизиты объекта, которые разрешается редактировать
// с помощью обработки группового изменения реквизитов.
//
// Возвращаемое значение:
//  Массив - список имен реквизитов объекта.
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("Автор");
	Результат.Добавить("Важность");
	Результат.Добавить("ДатаИсполнения");
	Результат.Добавить("ДатаНачала");
	Результат.Добавить("ДатаПринятияКИсполнению");
	Результат.Добавить("Предмет");
	Результат.Добавить("ПринятаКИсполнению");
	Результат.Добавить("СрокИсполнения");
	Возврат Результат;
	
КонецФункции

// Конец СтандартныеПодсистемы.ГрупповоеИзменениеОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК ЗадачаИсполнителя
	|
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИсполнителиЗадач КАК ИсполнителиЗадач
	|ПО
	|	ЗадачаИсполнителя.РольИсполнителя = ИсполнителиЗадач.РольИсполнителя
	|	И ЗадачаИсполнителя.ОсновнойОбъектАдресации = ИсполнителиЗадач.ОсновнойОбъектАдресации
	|	И ЗадачаИсполнителя.ДополнительныйОбъектАдресации = ИсполнителиЗадач.ДополнительныйОбъектАдресации
	|;
	|РазрешитьЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Автор)
	|	ИЛИ ЗначениеРазрешено(Исполнитель)
	|	ИЛИ ЗначениеРазрешено(ИсполнителиЗадач.Исполнитель)
	|	ИЛИ ЧтениеОбъектаРазрешено(БизнесПроцесс)
	|;
	|РазрешитьИзменениеЕслиРазрешеноЧтение
	|ГДЕ
	|	ЗначениеРазрешено(Исполнитель)
	|	ИЛИ ЗначениеРазрешено(ИсполнителиЗадач.Исполнитель)";
	
	Ограничение.ТекстДляВнешнихПользователей =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Исполнитель)
	|	ИЛИ ЗначениеРазрешено(Автор)";
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	Поля.Добавить("Наименование");
	Поля.Добавить("Дата");
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	Наименование = ?(ПустаяСтрока(Данные.Наименование), НСтр("ru = 'Без описания'"), Данные.Наименование);
	Дата = Формат(Данные.Дата, ?(ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач"), "ДЛФ=DT", "ДЛФ=D"));
	Представление = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 от %2'"), Наименование, Дата);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" И Параметры.Свойство("Ключ") Тогда
		ПараметрыФормы = БизнесПроцессыИЗадачиВызовСервера.ФормаВыполненияЗадачи(Параметры.Ключ);
		ИмяФормыЗадачи = "";
		Результат = ПараметрыФормы.Свойство("ИмяФормы", ИмяФормыЗадачи);
		Если Результат Тогда
			ВыбраннаяФорма = ИмяФормыЗадачи;
			СтандартнаяОбработка = Ложь;
			ОбщегоНазначенияКлиентСервер.ДополнитьСтруктуру(Параметры, ПараметрыФормы.ПараметрыФормы, Ложь);
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

