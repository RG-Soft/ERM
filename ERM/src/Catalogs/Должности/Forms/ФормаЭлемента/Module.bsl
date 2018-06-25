
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	// Обработчик подсистемы "ВерсионированиеОбъектов".
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтаФорма);
	
	Если Параметры.Ключ.Пустая() Тогда
		СсылкаНаОбъект = ОбщегоНазначения.МенеджерОбъектаПоСсылке(Объект.Ссылка).ПолучитьСсылку();
		ПриПолученииДанныхНаСервере(Объект.Ссылка);
		//РедактированиеПериодическихСведений.ИнициализироватьЗаписьДляРедактированияВФорме(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект);
	КонецЕсли; 
	
	УстановитьДоступностьСвойствДолжности();
	
	//ТекстПодсказкиКПоляДатаРегистрации = УчетСтраховыхВзносовКлиентСервер.ТекстПодсказкиПоляДатаРегистрацииПериодическихРегистров();
	//
	//ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
	//	Элементы, 
	//	"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений", 
	//	"Подсказка", 
	//	ТекстПодсказкиКПоляДатаРегистрации);
		
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	//СклонениеПредставленийОбъектов.ПриСозданииНаСервере(ЭтотОбъект, Объект.Наименование);	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	// СтандартныеПодсистемы.Свойства
	//УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	// СтандартныеПодсистемы.Свойства
	//УправлениеСвойствами.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.Свойства
	
	ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией = ЗначениеЗаполнено(ТекущийОбъект.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией);
	СсылкаНаОбъект = Объект.Ссылка;
	ПриПолученииДанныхНаСервере(ТекущийОбъект.Ссылка);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьИЗакрытьНаКлиенте", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ, Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)

	Если Не ПараметрыЗаписи.Свойство("ПроверкаПередЗаписьюВыполнена") Тогда 
		Отказ = Истина;
		ЗаписатьНаКлиенте(Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Параметры.Ключ.Пустая() Тогда
		ТекущийОбъект.УстановитьСсылкуНового(СсылкаНаОбъект);
	КонецЕсли;
	
	ЗаписатьКлассыУсловийТрудаПоДолжностям();
	
	// Обработчик подсистемы "Свойства".
	//УправлениеСвойствами.ПередЗаписьюНаСервере(ЭтаФорма, ТекущийОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	//СклонениеПредставленийОбъектов.ПриЗаписиНаСервере(ЭтотОбъект, Объект.Наименование, ТекущийОбъект.Ссылка);	
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	ПриПолученииДанныхНаСервере(ТекущийОбъект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	//// Подсистема "Свойства"
	//Если УправлениеСвойствамиКлиент.ОбрабатыватьОповещения(ЭтаФорма, ИмяСобытия, Параметр) Тогда
	//	ОбновитьЭлементыДополнительныхРеквизитов();
	//	УправлениеСвойствамиКлиент.ПослеЗагрузкиДополнительныхРеквизитов(ЭтотОбъект);
	//КонецЕсли;
	
	Если ИмяСобытия = "ОтредактированаИстория" И Параметр.ИмяРегистра = "КлассыУсловийТрудаПоДолжностям" Тогда
		Если КлассыУсловийТрудаПоДолжностямНаборЗаписейПрочитан Тогда
			//РедактированиеПериодическихСведенийКлиент.ОбработкаОповещения(ЭтаФорма, СсылкаНаОбъект, ИмяСобытия, Параметр, Источник);
			ОбновитьПолеКлассыУсловийТрудаПоДолжностямПериод(ЭтаФорма);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	// СтандартныеПодсистемы.Свойства
	//УправлениеСвойствами.ОбработкаПроверкиЗаполнения(ЭтаФорма, Отказ, ПроверяемыеРеквизиты);
	// Конец СтандартныеПодсистемы.Свойства
	
	//РедактированиеПериодическихСведений.ПроверитьЗаписьВФорме(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект, Отказ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсиейФлажокПриИзменении(Элемент)
	
	Если НЕ ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией Тогда
	//	Объект.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией = ПредопределенноеЗначение("Перечисление.ВидыРаботСДосрочнойПенсией.ПустаяСсылка");
	КонецЕсли;
	УстановитьДоступностьЭлементов(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямКлассУсловийТрудаПриИзменении(Элемент)
	ОбновитьПолеКлассыУсловийТрудаПоДолжностямПериод(ЭтотОбъект);
	УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду();
	ОбновитьПолеКлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	Оповещение = Новый ОписаниеОповещения("КлассыУсловийТрудаПоДолжностямПериодНачалоВыбораЗавершение", ЭтотОбъект);
	
	//ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
	//	ЭтаФорма,
	//	ЭтаФорма,
	//	"КлассыУсловийТрудаПоДолжностямПериод",
	//	"КлассыУсловийТрудаПоДолжностямПериодСтрокой", ,
	//	Оповещение);

КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодНачалоВыбораЗавершение(ЗначениеВыбрано, ДополнительныеПараметры) Экспорт 

	//КлассыУсловийТрудаПоДолжностям.Период = КлассыУсловийТрудаПоДолжностямПериод;
	
	УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду();
		
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодРегулирование(Элемент, Направление, СтандартнаяОбработка)

	//ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
	//	ЭтаФорма,
	//	"КлассыУсловийТрудаПоДолжностямПериод",
	//	"КлассыУсловийТрудаПоДолжностямПериодСтрокой",
	//	Направление,
	//	Модифицированность);

	//КлассыУсловийТрудаПоДолжностям.Период = КлассыУсловийТрудаПоДолжностямПериод;
	
	УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду();
	
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)

	//ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)

	//ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
		
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямПериодПриИзменении(Элемент)
	
	//ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
	//	ЭтаФорма,
	//	"КлассыУсловийТрудаПоДолжностямПериод",
	//	"КлассыУсловийТрудаПоДолжностямПериодСтрокой",
	//	Модифицированность);

	//КлассыУсловийТрудаПоДолжностям.Период = КлассыУсловийТрудаПоДолжностямПериод;
	
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийПриИзменении(Элемент)
	//ЗарплатаКадрыКлиент.ВводМесяцаПриИзменении(
	//	ЭтаФорма,
	//	"КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений",
	//	"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой",
	//	Модифицированность);	
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	//ЗарплатаКадрыКлиент.ВводМесяцаНачалоВыбора(
	//	ЭтаФорма,
	//	ЭтаФорма,
	//	"КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений",
	//	"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой");
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	//ЗарплатаКадрыКлиент.ВводМесяцаРегулирование(
	//	ЭтаФорма,
	//	"КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений",
	//	"КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой",
	//	Направление,
	//	Модифицированность);

КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	//ЗарплатаКадрыКлиент.ВводМесяцаАвтоПодборТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	
	//ЗарплатаКадрыКлиент.ВводМесяцаОкончаниеВводаТекста(Текст, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	// СтандартныеПодсистемы.СклонениеПредставленийОбъектов
	//СклонениеПредставленийОбъектовКлиент.ПриИзмененииПредставления(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов	

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	//Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
	//	РезультатВыполнения = Неопределено;
	//	ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	//	ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтаФорма, РезультатВыполнения);
	//КонецЕсли;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура КлассУсловийТрудаИстория(Команда)
	//РедактированиеПериодическихСведенийКлиент.ОткрытьИсторию("КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект, ЭтаФорма, ТолькоПросмотр);
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписатьИЗакрыть(Команда)
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаЗаписать(Команда)
	
	ЗаписатьНаКлиенте(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура Склонения(Команда)
	
	//СклонениеПредставленийОбъектовКлиент.ОбработатьКомандуСклонения(ЭтотОбъект, Объект.Наименование);
			
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// СтандартныеПодсистемы.Свойства

&НаКлиенте
Процедура ОбновитьЗависимостиДополнительныхРеквизитов()
	//УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПриИзмененииДополнительногоРеквизита(Элемент)
	//УправлениеСвойствамиКлиент.ОбновитьЗависимостиДополнительныхРеквизитов(ЭтотОбъект);
КонецПроцедуры

// Конец СтандартныеПодсистемы.Свойства

&НаСервере
Процедура ПриПолученииДанныхНаСервере(СсылкаНаОбъект)
	
	ПрочитатьКлассыУсловийТрудаПоДолжностям();
	УстановитьДоступностьЭлементов(ЭтаФорма)
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьДоступностьЭлементов(Форма)
	
	Форма.Элементы.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией.Доступность = 
		Форма.ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсией;
	
КонецПроцедуры
	
&НаСервере
Процедура УстановитьДоступностьСвойствДолжности()
	
	ДоступноИзменениеСвойств = Пользователи.РолиДоступны("НастройкаНалогиИВзносы");
	Если НЕ ДоступноИзменениеСвойств Тогда
	
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ЯвляетсяФармацевтическойДолжностью",
			"ТолькоПросмотр",
			Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ЯвляетсяШахтерскойДолжностью",
			"ТолькоПросмотр",
			Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ЯвляетсяДолжностьюЛетногоЭкипажа",
			"ТолькоПросмотр",
			Истина);
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(
			Элементы,
			"ВзимаютсяВзносыЗаЗанятыхНаРаботахСДосрочнойПенсиейГруппа",
			"ТолькоПросмотр",
			Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьКлассыУсловийТрудаПоДолжностям()
	
	//РедактированиеПериодическихСведений.ПрочитатьЗаписьДляРедактированияВФорме(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект);
	ОбновитьПолеКлассыУсловийТрудаПоДолжностямПериод(ЭтаФорма);
	ОбновитьПолеКлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьКлассыУсловийТрудаПоДолжностям()
	
	//РедактированиеПериодическихСведений.ЗаписатьЗаписьПослеРедактированияВФорме(ЭтаФорма, "КлассыУсловийТрудаПоДолжностям", СсылкаНаОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ПрочитатьНаборЗаписейПериодическихСведений(ИмяРегистра, ВедущийОбъект) Экспорт
	
	//РедактированиеПериодическихСведений.ПрочитатьНаборЗаписей(ЭтаФорма, ИмяРегистра, ВедущийОбъект);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеКлассыУсловийТрудаПоДолжностямПериод(Форма)
	
	//РедактированиеПериодическихСведенийКлиентСервер.ОбновитьОтображениеПолейВвода(Форма, "КлассыУсловийТрудаПоДолжностям", Форма.СсылкаНаОбъект);
	Форма.КлассыУсловийТрудаПоДолжностямПериод = Форма.КлассыУсловийТрудаПоДолжностям.Период;
	//ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "КлассыУсловийТрудаПоДолжностямПериод", "КлассыУсловийТрудаПоДолжностямПериодСтрокой");
	
КонецПроцедуры
	
&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьПолеКлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений(Форма)	
	//ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(Форма, "КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений", "КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой");
	
	Форма.Элементы.КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений.АвтоОтметкаНезаполненного = Форма.Элементы.КлассыУсловийТрудаПоДолжностямПериод.АвтоОтметкаНезаполненного;
	
	Если Не Форма.Элементы.КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений.АвтоОтметкаНезаполненного
		И Не ЗначениеЗаполнено(Форма.КлассыУсловийТрудаПоДолжностям.Период) Тогда
		
		Форма.Элементы.КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзменений.ОтметкаНезаполненного = Ложь;
	КонецЕсли;	
		
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДатуРегистрацииКлассаУсловийТрудаПоПериоду()
	//КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений = НачалоМесяца(КлассыУсловийТрудаПоДолжностям.Период);	
	
	//ЗарплатаКадрыКлиентСервер.ЗаполнитьМесяцПоДате(ЭтотОбъект, "КлассыУсловийТрудаПоДолжностям.ДатаРегистрацииИзменений", "КлассыУсловийТрудаПоДолжностямДатаРегистрацииИзмененийСтрокой");
КонецПроцедуры	

///////////////////////////////////////////////////////////////////// 
// Процедуры подсистемы Свойства.

&НаКлиенте
Процедура Подключаемый_РедактироватьСоставСвойств()
	
	//УправлениеСвойствамиКлиент.РедактироватьСоставСвойств(ЭтаФорма, Объект.Ссылка);
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьЭлементыДополнительныхРеквизитов()
	
	//УправлениеСвойствами.ОбновитьЭлементыДополнительныхРеквизитов(ЭтаФорма, РеквизитФормыВЗначение("Объект"));

КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	//ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.СклонениеПредставленийОбъектов

&НаКлиенте 
Процедура Подключаемый_ПросклонятьПредставлениеПоВсемПадежам() 
	
	//СклонениеПредставленийОбъектовКлиент.ПросклонятьПредставлениеПоВсемПадежам(ЭтотОбъект, Объект.Наименование);
		
КонецПроцедуры

// Конец СтандартныеПодсистемы.СклонениеПредставленийОбъектов

#КонецОбласти

#Область ЗаписьЭлемента

&НаКлиенте
Процедура ЗаписатьИЗакрытьНаКлиенте(Результат, ДополнительныеПараметры) Экспорт 
	
	ЗаписатьНаКлиенте(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиенте(ЗакрытьПослеЗаписи, ОповещениеЗавершения = Неопределено) Экспорт 

	//ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени("ЗаписьЭлементаСправочникаДолжности");
		
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ЗакрытьПослеЗаписи", ЗакрытьПослеЗаписи);
	ДополнительныеПараметры.Вставить("ОповещениеЗавершения", ОповещениеЗавершения);
	
	Оповещение = Новый ОписаниеОповещения("ЗаписатьНаКлиентеЗавершение", ЭтотОбъект, ДополнительныеПараметры);
	
	ТекстКнопкиДа = НСтр("ru = 'Изменились сведения о классе условий труда'");
	//ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//	НСтр("ru = 'При редактировании Вы изменили сведения о классе условий труда.
	//	|Если Вы исправили прежние сведения о классе условий труда (они были ошибочными), нажмите ""Исправлена ошибка"".
	//	|Если сведения о классе условий труда изменились с %1, нажмите ""%2""'"), 
	//	Формат(КлассыУсловийТрудаПоДолжностям.Период, "ДФ='ММММ гггг ""г""'"),
	//	ТекстКнопкиДа);
	
	//РедактированиеПериодическихСведенийКлиент.ЗапроситьРежимИзмененияРегистра(ЭтаФорма,"КлассыУсловийТрудаПоДолжностям", ТекстВопроса, ТекстКнопкиДа, Ложь, Оповещение);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьНаКлиентеЗавершение(Отказ, ДополнительныеПараметры) Экспорт 
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыЗаписи = Новый Структура("ПроверкаПередЗаписьюВыполнена", Истина);
	
	Если ДополнительныеПараметры.ОповещениеЗавершения <> Неопределено Тогда 
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОповещениеЗавершения, ПараметрыЗаписи);
	ИначеЕсли Записать(ПараметрыЗаписи) И ДополнительныеПараметры.ЗакрытьПослеЗаписи Тогда 
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
