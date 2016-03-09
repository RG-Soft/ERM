﻿
&НаКлиенте
Перем УстановкаОсновногоБанковскогоСчетаВыполнена;
&НаКлиенте 
Перем ТекущийТекстНомераСчета; // Текст, набранный в поле ввода номера счета

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//// СтандартныеПодсистемы.Печать
	//УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	//// Конец СтандартныеПодсистемы.Печать
	//
	//// ДополнительныеОтчетыИОбработки
	//ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
	//// Конец ДополнительныеОтчетыИОбработки
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если Параметры.Ключ.Пустая() Тогда
		ПодготовитьФормуНаСервере();
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Владелец) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Не указан владелец банковского счета!'"),,,, Отказ);
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Контрагенты") Тогда
		
		Элементы.Владелец.Заголовок = НСтр("ru = 'Контрагент'");
		
		Элементы.ГруппаПодразделение.Видимость        = Ложь;
		Элементы.ГруппаДатаОткрытияЗакрытия.Видимость = Ложь;
		
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Организации") Тогда
		
		//ИспользуетсяНесколькоОрганизаций = Справочники.Организации.ИспользуетсяНесколькоОрганизаций();
		ИспользуетсяНесколькоОрганизаций = Истина;
		
		Элементы.Владелец.Видимость          = ИспользуетсяНесколькоОрганизаций;
		
		Элементы.Владелец.Заголовок = НСтр("ru = 'Организация'");
		
		Элементы.ГруппаПодразделение.Видимость        = Истина;
		//Элементы.ГруппаДатыОткрытияЗакрытияСчета.РасширеннаяПодсказка.Заголовок =
		//	?(УчетнаяПолитика.ПрименяетсяУСН(Объект.Владелец, ТекущаяДата()),
		//		НСтр("ru = 'Дата открытия и закрытия счета необходимы для правильного формирования Книги учета доходов и расходов (УСН)'"),
		//		"");
		
		УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("Организация", Объект.Владелец));
		
	ИначеЕсли ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.ФизическиеЛица") Тогда
		
		Элементы.Владелец.Заголовок = НСтр("ru = 'Физическое лицо'");
		
		Элементы.ГруппаПодразделение.Видимость        = Ложь;
		Элементы.ГруппаДатаОткрытияЗакрытия.Видимость = Ложь;
		Элементы.ГруппаВидСчетаНомерИДатаРазрешения.Видимость = Ложь;
		
	Иначе
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Неверно указан владелец банковского счета!'"),,,, Отказ);
		Возврат;
		
	КонецЕсли;
	
	ЗаполнитьРеквизитыБанков();
	БанковскиеСчетаФормыКлиентСервер.ИзменитьДлинуНомераСчета(ЭтотОбъект, ЯвляетсяБанкомРФ);
	
	//ВалютаРегламентированногоУчета = ОбщегоНазначенияБПВызовСервераПовтИсп.ПолучитьВалютуРегламентированногоУчета();
	
	ИспользуетсяБанкДляРасчетов = ЗначениеЗаполнено(Объект.БанкДляРасчетов);
	
	Элементы.ПодразделениеОрганизацииРасширеннаяПодсказка.Заголовок =
		НСтр("ru = 'Подразделение, которое подставляется по умолчанию в Поступление и Списание с этого банковского счета'");
	
	Если Параметры.Ключ.Пустая() Тогда
		Если ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
			Объект.Наименование = "";
			УстановитьНаименованиеСчета(ЭтотОбъект);
		Иначе
			Если НЕ Объект.Валютный Тогда
				//Объект.ВалютаДенежныхСредств = ВалютаРегламентированногоУчета;
			КонецЕсли;
			
			АвтоНаименование = СокрЛП(Объект.Наименование);
			Если ПустаяСтрока(Объект.НомерСчета) И НЕ ПустаяСтрока(АвтоНаименование)
				И СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(АвтоНаименование) Тогда
				Объект.НомерСчета = АвтоНаименование;
			Иначе
				Объект.Наименование = "";
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Элементы.ВалютаДенежныхСредств.Видимость Тогда
		Если Параметры.ЗначенияЗаполнения.Свойство("ВалютаДенежныхСредств") И ЗначениеЗаполнено(Параметры.ЗначенияЗаполнения.ВалютаДенежныхСредств)
			И Параметры.ЗначенияЗаполнения.Свойство("Валютный") Тогда
			Элементы.ВалютаДенежныхСредств.ТолькоПросмотр = Истина;
		КонецЕсли;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
	РазделениеВключено = ОбщегоНазначенияПовтИсп.РазделениеВключено();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	ТекстОшибки = "";
	
	Если Не ЗначениеЗаполнено(Объект.НомерСчета) Тогда
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения(, "Заполнение", НСтр("ru = 'Номер счета'"));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения, , "Объект.НомерСчета", , Отказ);
	КонецЕсли;
	
	Если Не БанковскиеСчетаФормыКлиентСервер.НомерСчетаКорректен(Объект.НомерСчета, БИКБанка, ЯвляетсяБанкомРФ, ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки,, "Объект.НомерСчета",, Отказ);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	БанковскиеСчетаФормыКлиент.ПередЗаписью(Объект.НомерСчета, БИКБанка, Объект.Ссылка, Отказ);
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ИспользуетсяБанкДляРасчетов Тогда
		ТекущийОбъект.БанкДляРасчетов = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТипЗнч(НаименованиеПлательщикаПриПеречисленииВБюджет) = Тип("Строка")
		И ТипЗнч(Объект.Владелец) = Тип("СправочникСсылка.Организации")
		И ПравоДоступа("Изменение", Метаданные.Справочники.Организации) Тогда
			ТекущеНаименованиеПлательщика = СокрЛП(ОбщегоНазначения.ЗначениеРеквизитаОбъекта(
				Объект.Владелец, "НаименованиеПлательщикаПриПеречисленииВБюджет"));
			Если НаименованиеПлательщикаПриПеречисленииВБюджет <> ТекущеНаименованиеПлательщика Тогда
				ОрганизацияОбъект = Объект.Владелец.ПолучитьОбъект();
				ОрганизацияОбъект.НаименованиеПлательщикаПриПеречисленииВБюджет = НаименованиеПлательщикаПриПеречисленииВБюджет;
				
				Попытка
					ОрганизацияОбъект.Записать();
				Исключение
					ИнформацияОбОшибке = ИнформацияОбОшибке();
					Если ИнформацияОбОшибке.Причина = Неопределено Тогда
						ОписаниеОшибки = ИнформацияОбОшибке.Описание;
					Иначе
						ОписаниеОшибки = ИнформацияОбОшибке.Причина.Описание;
					КонецЕсли;
					
					ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
						НСтр("ru = 'Ошибка при записи настроек организации:
						|%1'"), ОписаниеОшибки);
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки);
				КонецПопытки;
			КонецЕсли;
	КонецЕсли;
	
	Если Справочники.БанковскиеСчета.КоличествоБанковскихСчетовОрганизации(Объект.Владелец) = 1 Тогда
		ПараметрыЗаписи.Вставить("ЭтоЕдинственныйБанковскийСчет");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ПараметрОповещения = Новый Структура("Ссылка, Владелец", Объект.Ссылка, Объект.Владелец);
	
	Оповестить("ИзмененБанковскийСчет", ПараметрОповещения);
	
	Если ПараметрыЗаписи.Свойство("ЭтоЕдинственныйБанковскийСчет") Тогда
		
		УстановкаОсновногоБанковскогоСчетаВыполнена = Ложь;
		
		СтруктураПараметров = Новый Структура();
		СтруктураПараметров.Вставить("КонтрагентОрганизация",  Объект.Владелец);
		СтруктураПараметров.Вставить("ОсновнойБанковскийСчет", Объект.Ссылка);
		
		Оповестить("УстановкаОсновногоБанковскогоСчетаПриЗаписи", СтруктураПараметров);
		
		// Если форма владельца закрыта, то запишем основной банковский счет самостоятельно.
		Если НЕ УстановкаОсновногоБанковскогоСчетаВыполнена Тогда
			УстановитьОсновнойБанковскийСчет(СтруктураПараметров);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ЗаписанЭлементБанк" Тогда
		
		Если ТипЗнч(Параметр) = Тип("СправочникСсылка.Банки")
			И ЗначениеЗаполнено(Параметр)
			И Объект.Банк <> Параметр Тогда
			
			Объект.Банк = Параметр;
			
		КонецЕсли;
		
		ЗаполнитьРеквизитыБанков();
		
		УправлениеФормой(ЭтотОбъект);
		
	ИначеЕсли ИмяСобытия = "УстановкаОсновногоБанковскогоСчетаВыполнена" Тогда
		
		УстановкаОсновногоБанковскогоСчетаВыполнена = Истина;
		
	//ИначеЕсли ИмяСобытия = "ИзмененаНастройкаОбмена" Тогда
	//	
	//	Элементы.НастройкаЭДО.Заголовок = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(
	//		Объект.Владелец, Объект.Банк);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОбработкаВыбораНаСервере(ВыбранноеЗначение);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НомерСчетаПриИзменении(Элемент)
	
	Объект.НомерСчета = СтрЗаменить(Объект.НомерСчета," ","");
	
	БанковскиеСчетаФормыКлиент.УстановитьВалютуПодсказкуСчета(
		Объект, ЭтаФорма, БИКБанка, ЦветВыделенияНекорректногоЗначение, ЯвляетсяБанкомРФ);

	ДоступностьВалютыСчета(ЭтотОбъект);
	ДоступностьНомераИДатыРазрешения(ЭтотОбъект); 
	УстановитьНаименованиеСчета(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ВалютаДенежныхСредствПриИзменении(Элемент)
	
	Если НЕ ЗначениеЗаполнено(Объект.ВалютаДенежныхСредств) Тогда
		Объект.ВалютаДенежныхСредств = ВалютаРегламентированногоУчета;
	КонецЕсли;
	
	Объект.Валютный = Объект.ВалютаДенежныхСредств <> ВалютаРегламентированногоУчета;
	
	УстановитьНаименованиеСчета(ЭтотОбъект);
	ДоступностьНомераИДатыРазрешения(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Объект.ГосударственныйКонтракт = Неопределено;
	
	РеквизитыБанка = БанковскиеСчетаФормыКлиент.ПолучитьДанныеБанка(ВыбранноеЗначение);
	ВыбранноеЗначение = РеквизитыБанка.ссылка;
	
	ОбновитьРеквизитыБанкаНаФорме(ЭтотОбъект, РеквизитыБанка); 
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользуетсяБанкДляРасчетовПриИзменении(Элемент)
	
	ДоступностьБанкаДляРасчетов(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкДляРасчетовОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	РеквизитыБанка = БанковскиеСчетаФормыКлиент.ПолучитьДанныеБанка(ВыбранноеЗначение);
	ВыбранноеЗначение = РеквизитыБанка.Ссылка;
	
	ОбновитьРеквизитыБанкаДляРасчетовНаФорме(ЭтотОбъект, РеквизитыБанка);
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	
	СформироватьАвтоНаименование(ЭтотОбъект, Объект.Наименование);
	
КонецПроцедуры

&НаКлиенте
Процедура СообщениеПрямогоОбменаНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	//Если ЗначениеЗаполнено(СоглашениеПрямогоОбменаСБанками) Тогда
	//	ПараметрыФормы = Новый Структура("Ключ, РежимОткрытияОкна",
	//		СоглашениеПрямогоОбменаСБанками, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	//	ОткрытьФорму("Справочник.СоглашенияОбИспользованииЭД.ФормаОбъекта", ПараметрыФормы, ЭтотОбъект);
	//КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаЭДОНажатие(Элемент)
	
	//Обработчик = Новый ОписаниеОповещения("ПослеСозданияНастройкиЭДО", ЭтотОбъект);
	//ОбменСБанкамиКлиент.ОткрытьСоздатьНастройкуОбмена(
	//	Объект.Владелец, Объект.Банк, Объект.НомерСчета, Обработчик);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеСозданияНастройкиЭДО(НастройкаЭДО, Параметры) Экспорт
	
	//Элементы.НастройкаЭДО.Заголовок = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(
	//	Объект.Владелец, Объект.Банк);
	
КонецПроцедуры	

&НаКлиенте
Процедура НомерСчетаИзменениеТекстаРедактирования(Элемент, Текст, СтандартнаяОбработка)
	
	ТекущийТекстНомераСчета = СтрЗаменить(Текст," ","");
	
	ПодключитьОбработчикОжидания("Подключаемый_УстановитьПодсказкуНомераСчета", 0.1, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Банк) Тогда
		БИКБанка = "";
		НаименованиеБанка = "";
		ДеятельностьБанкаПрекращена = Ложь;
		ЯвляетсяБанкомРФ = Ложь;
	КонецЕсли;
	
	БанковскиеСчетаФормыКлиентСервер.ИзменитьДлинуНомераСчета(ЭтотОбъект, ЯвляетсяБанкомРФ);
	Объект.НомерСчета = Элементы.НомерСчета.ОграничениеТипа.ПривестиЗначение(Объект.НомерСчета);
	
	БанковскиеСчетаФормыКлиент.УстановитьВалютуПодсказкуСчета(
		Объект, ЭтаФорма, БИКБанка, ЦветВыделенияНекорректногоЗначение, ЯвляетсяБанкомРФ);
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкДляРасчетовПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Объект.Банк) Тогда
		КодБанкаДляРасчетов = "";
		ДеятельностьБанкаНепрямыхРасчетовПрекращена = Ложь;
	КонецЕсли;
	
	УправлениеФормой(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	БанковскиеСчетаФормыКлиент.БанкАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка, ПараметрыПолученияДанных);
	
КонецПроцедуры

&НаКлиенте
Процедура БанкДляРасчетовАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	БанковскиеСчетаФормыКлиент.БанкАвтоПодбор(Текст, ДанныеВыбора, СтандартнаяОбработка, ПараметрыПолученияДанных);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура НастройкиПлатежныхПорученийТребований(Команда)
	
	//ПараметрыФормы = Новый Структура("БанковскийСчетОрганизации, БанковскийСчетКонтрагента, АвтоТекстНазначения, НастройкиПП");
	//
	//Если Элементы.ГруппаПодразделение.Видимость Тогда
	//	// Владелец - Организация
	//	ПараметрыФормы.Вставить("ЭтоСчетОрганизации", Истина);
	//	ПараметрыФормы.Вставить("Организация",        Объект.Владелец);
	//	ПараметрыФормы.БанковскийСчетОрганизации = Объект.Ссылка;
	//	ПараметрыФормы.НастройкиПП = Новый Структура("ТекстКорреспондента, ВсегдаУказыватьКПП, МесяцПрописью, СуммаБезКопеек",
	//		Объект.ТекстКорреспондента, Объект.ВсегдаУказыватьКПП, Объект.МесяцПрописью, Объект.СуммаБезКопеек);
	//	
	//	Если ТипЗнч(НаименованиеПлательщикаПриПеречисленииВБюджет) = Тип("Строка") Тогда
	//		ПараметрыФормы.НастройкиПП.Вставить("НаименованиеПлательщикаПриПеречисленииВБюджет",
	//			НаименованиеПлательщикаПриПеречисленииВБюджет);
	//	КонецЕсли;
	//Иначе
	//	// Владелец - Контрагент
	//	ПараметрыФормы.БанковскийСчетКонтрагента = Объект.Ссылка;
	//	ПараметрыФормы.Вставить("Контрагент", Объект.Владелец);
	//	ПараметрыФормы.НастройкиПП = Новый Структура("ТекстКорреспондента, ТекстНазначения, ВсегдаУказыватьКПП",
	//		Объект.ТекстКорреспондента, Объект.ТекстНазначения, Объект.ВсегдаУказыватьКПП);
	//КонецЕсли;
	//
	//ПараметрыФормы.Вставить("Наименование", Объект.Наименование);
	//ОткрытьФорму("ОбщаяФорма.НастройкиПлатежныхПорученийТребований", ПараметрыФормы, ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораНаСервере(ВыбранноеЗначение)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		ЗаполнитьЗначенияСвойств(Объект, ВыбранноеЗначение);
		
		Если ВыбранноеЗначение.Свойство("МесяцПрописью") Тогда
			ХранилищеОбщихНастроек.Сохранить("НастройкиПлатежныхПорученийТребований", "ВсегдаУказыватьКППОрганизации",
				ВыбранноеЗначение.ВсегдаУказыватьКПП);
			НаименованиеПлательщикаПриПеречисленииВБюджет = СокрЛП(ВыбранноеЗначение.НаименованиеПлательщикаПриПеречисленииВБюджет);
		Иначе
			Если ВыбранноеЗначение.Свойство("ВсегдаУказыватьКПП") Тогда
				ХранилищеОбщихНастроек.Сохранить("НастройкиПлатежныхПорученийТребований", "ВсегдаУказыватьКППКонтрагента",
					ВыбранноеЗначение.ВсегдаУказыватьКПП);
			КонецЕсли;
		КонецЕсли;
		
		Модифицированность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УправлениеФормой(Форма)
	
	Объект   = Форма.Объект;
	Элементы = Форма.Элементы;
	
	УстановитьНаименованиеСчета(Форма);

	Форма.ПодсказкаБанк = БанковскиеСчетаФормыКлиентСервер.ПодсказкаПоляБанка(Форма.ДеятельностьБанкаПрекращена);
	Если Не ЗначениеЗаполнено(Форма.ПодсказкаНомерСчета) Тогда
		Форма.ПодсказкаНомерСчета = БанковскиеСчетаФормыКлиентСервер.ПодсказкаПоляНомерСчета(Форма.Объект.НомерСчета, Форма.БИКБанка, Форма.ЯвляетсяБанкомРФ, Форма.ЦветВыделенияНекорректногоЗначение);
	КонецЕсли;
	Форма.ПодсказкаБанкНепрямыхРасчетов = БанковскиеСчетаФормыКлиентСервер.ПодсказкаПоляБанка(Форма.ДеятельностьБанкаНепрямыхРасчетовПрекращена);
	
	Если ЗначениеЗаполнено(Объект.Банк) И ЗначениеЗаполнено(Форма.ПодсказкаБанк) Тогда
		Элементы.СтраницыБанк.ТекущаяСтраница = Элементы.СтраницаБанкНедействующий;
	ИначеЕсли ЗначениеЗаполнено(Объект.Банк) И ЗначениеЗаполнено(Форма.СоглашениеПрямогоОбменаСБанками) Тогда
		Элементы.СтраницыБанк.ТекущаяСтраница = Элементы.СтраницаБанкССоглашением;
	КонецЕсли;
	
	//Форма.Элементы.НастройкаЭДО.Видимость = ЗначениеЗаполнено(Форма.Объект.Владелец)
	//	И (ТипЗнч(Форма.Объект.Владелец) = Тип("СправочникСсылка.Организации"));
	//Если Форма.Элементы.НастройкаЭДО.Видимость Тогда
	//	Форма.Элементы.НастройкаЭДО.Заголовок = ОбменСБанкамиКлиентСервер.ЗаголовокНастройкиОбменаСБанком(
	//		Форма.Объект.Владелец, Форма.Объект.Банк);
	//	Если НЕ ЗначениеЗаполнено(Форма.Элементы.НастройкаЭДО.Заголовок) Тогда
	//		Форма.Элементы.НастройкаЭДО.Доступность = Ложь;
	//	КонецЕсли;
	//КонецЕсли;
	
	ВидимостьРеквизитовБанкаРФ = Форма.ЯвляетсяБанкомРФ Или Не ЗначениеЗаполнено(Объект.Банк);
	Форма.Элементы.ГруппаГосударственныйКонтракт.Видимость =  ВидимостьРеквизитовБанкаРФ;
	Форма.Элементы.ГруппаИспользуетсяБанкДляРасчетов.Видимость = ВидимостьРеквизитовБанкаРФ;
	
	ДоступностьВалютыСчета(Форма);
	ДоступностьНомераИДатыРазрешения(Форма);
	ДоступностьПоляГосударственныйКонтракт(Форма);
	ДоступностьБанкаДляРасчетов(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНаименованиеСчета(Форма, ИзменениеНомераСчета = Ложь)
	
	Объект = Форма.Объект;
	
	Если ПустаяСтрока(Объект.Наименование) ИЛИ Объект.Наименование = Форма.АвтоНаименование Тогда
		Форма.АвтоНаименование = СформироватьАвтоНаименование(Форма);
		Если НЕ ПустаяСтрока(Форма.АвтоНаименование) И Форма.АвтоНаименование <> Объект.Наименование Тогда
			Объект.Наименование = Форма.АвтоНаименование;
		КонецЕсли;
	Иначе
		Если ИзменениеНомераСчета И НЕ ПустаяСтрока(Форма.НомерСчетаТекущий) Тогда
			Объект.Наименование = СтрЗаменить(Объект.Наименование, Форма.НомерСчетаТекущий, СокрЛП(Объект.НомерСчета));
		КонецЕсли;
		
		Форма.АвтоНаименование = СформироватьАвтоНаименование(Форма, Объект.Наименование);
	КонецЕсли;
	
	Форма.НомерСчетаТекущий = СокрЛП(Объект.НомерСчета);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция СформироватьАвтоНаименование(Форма, Знач Текст = "")
	
	Элементы     = Форма.Элементы;
	Объект       = Форма.Объект;
	
	ПредставлениеВалюты = "" + Объект.ВалютаДенежныхСредств;
	
	ПредставлениеБанка = "";
	Если ЗначениеЗаполнено(Объект.Банк) Тогда
		ПредставлениеБанка = СокрЛП(Форма.НаименованиеБанка);
	КонецЕсли;
	
	Элементы.Наименование.СписокВыбора.Очистить();
	
	СтрокаНаименования1 = УчетДенежныхСредствКлиентСервер.НаименованиеБанковскогоСчетаПоУмолчанию(
		Объект.НомерСчета,
		ПредставлениеБанка,
		ПредставлениеВалюты,
		Объект.Валютный,
		1); // Вариант по умолчанию выводим последним
	
	Если НЕ ПустаяСтрока(СтрокаНаименования1) Тогда
		Элементы.Наименование.СписокВыбора.Добавить(СокрЛП(СтрокаНаименования1));
	КонецЕсли;
	
	СтрокаНаименования2 = УчетДенежныхСредствКлиентСервер.НаименованиеБанковскогоСчетаПоУмолчанию(
		Объект.НомерСчета,
		ПредставлениеБанка,
		ПредставлениеВалюты,
		Объект.Валютный,
		2);
	
	Строки1и2НеРавны = СокрЛП(СтрокаНаименования2) <> "(" + СтрокаНаименования1 + ")";
	Если СтрокаНаименования2 <> "" И Строки1и2НеРавны
			И Элементы.Наименование.СписокВыбора.НайтиПоЗначению(СтрокаНаименования2) = Неопределено Тогда
		Элементы.Наименование.СписокВыбора.Добавить(СокрЛП(СтрокаНаименования2));
	КонецЕсли;
	
	СтрокаНаименования = БанковскиеСчетаФормыКлиентСервер.НаименованиеБанковскогоСчета(Объект, ПредставлениеБанка);
	
	Если НЕ ПустаяСтрока(СтрокаНаименования) И Элементы.Наименование.СписокВыбора.НайтиПоЗначению(СтрокаНаименования) = Неопределено Тогда
		Элементы.Наименование.СписокВыбора.Добавить(СокрЛП(СтрокаНаименования));
	КонецЕсли;
	
	Если НЕ ПустаяСтрока(Текст) И Элементы.Наименование.СписокВыбора.НайтиПоЗначению(Текст) = Неопределено Тогда
		Элементы.Наименование.СписокВыбора.Добавить(СокрЛП(Текст));
	КонецЕсли;
	
	Возврат СтрокаНаименования;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьРеквизитыПрямогоОбменаСБанками(Знач Банк, Знач Организация)
	
	//СтруктураРеквизитов = Новый Структура;
	//СтруктураРеквизитов.Вставить("СоглашениеПрямогоОбменаСБанками", Справочники.СоглашенияОбИспользованииЭД.ПустаяСсылка());
	//СтруктураРеквизитов.Вставить("СообщениеПрямогоОбмена", "");

	//Запрос = Новый Запрос();
	//Запрос.Параметры.Вставить("Банк", Банк);
	//Запрос.Параметры.Вставить("Организация", Организация);
	//
	//Запрос.Текст =
	//"ВЫБРАТЬ
	//|	СоглашенияОбИспользованииЭД.Ссылка КАК СоглашениеПрямогоОбменаСБанками,
	//|	СоглашенияОбИспользованииЭД.Контрагент,
	//|	СоглашенияОбИспользованииЭД.СтатусСоглашения
	//|ИЗ
	//|	Справочник.СоглашенияОбИспользованииЭД КАК СоглашенияОбИспользованииЭД
	//|ГДЕ
	//|	СоглашенияОбИспользованииЭД.Контрагент = &Банк
	//|	И СоглашенияОбИспользованииЭД.Организация = &Организация
	//|	И СоглашенияОбИспользованииЭД.ПометкаУдаления = ЛОЖЬ";
	//Выборка = Запрос.Выполнить().Выбрать();
	//Если Выборка.Следующий() Тогда
	//	
	//	СтруктураРеквизитов.Вставить("СоглашениеПрямогоОбменаСБанками", Выборка.СоглашениеПрямогоОбменаСБанками);
	//	
	//	СообщениеПрямогоОбмена = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
	//		НСтр("ru = 'Соглашение о прямом обмене %1'"), НРег(Выборка.СтатусСоглашения));
	//		
	//	СтруктураРеквизитов.Вставить("СообщениеПрямогоОбмена", СообщениеПрямогоОбмена);
	//	
	//КонецЕсли;
	//
	//Возврат СтруктураРеквизитов;
	Возврат Неопределено;
	
КонецФункции

&НаСервереБезКонтекста
Процедура УстановитьОсновнойБанковскийСчет(СтруктураПараметров)
	
	Справочники.БанковскиеСчета.УстановитьОсновнойБанковскийСчет(
		СтруктураПараметров.КонтрагентОрганизация, 
		СтруктураПараметров.ОсновнойБанковскийСчет);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПОДКЛЮЧАЕМЫЕ ОБРАБОТЧИКИ

&НаКлиенте
Процедура Подключаемый_УстановитьПодсказкуНомераСчета()
	
	Если ЯвляетсяБанкомРФ Тогда
		
		Если Не БанковскиеПравила.ПроверитьДлинуНомераСчета(ТекущийТекстНомераСчета) Тогда
			ПодсказкаНомерСчета = БанковскиеСчетаФормыКлиент.ПодсказкаВводаПоляНомерСчета(
				ТекущийТекстНомераСчета, БИКБанка);
		Иначе
			ПодсказкаНомерСчета = БанковскиеСчетаФормыКлиентСервер.ПодсказкаПоляНомерСчета(
				ТекущийТекстНомераСчета, БИКБанка, ЯвляетсяБанкомРФ, ЦветВыделенияНекорректногоЗначение);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЗАВЕРШЕНИЕ НЕМОДАЛЬНЫХ ВЫЗОВОВ

#КонецОбласти

#Область СлужебныеПроцедурыИФункцииБСП

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	
	//Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
	//	РезультатВыполнения = Неопределено;
	//	ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
	//	ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
	//КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	
	//ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
	//УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ПодготовитьФормуНаСервере();
	
КонецПроцедуры

&НаКлиенте
Процедура ЭтоГосударственныйКонтрактПриИзменении(Элемент)
	
	Если НЕ ЭтоГосударственныйКонтракт Тогда
		Объект.ГосударственныйКонтракт = Неопределено;
	КонецЕсли;
	
	ДоступностьПоляГосударственныйКонтракт(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ЭтоГосударственныйКонтракт = ЗначениеЗаполнено(Объект.ГосударственныйКонтракт);
	ЦветВыделенияНекорректногоЗначение = ЦветаСтиля.ЦветВыделенияКонтрагентаСОшибкой;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРеквизитыБанков()
	
	РеквизитыБанка = БанковскиеСчетаВызовСервера.ПолучитьРеквизитыБанкаИзСправочника(Объект.Банк);
	ОбновитьРеквизитыБанкаНаФорме(ЭтотОбъект, РеквизитыБанка);
	
	РеквизитыБанка = БанковскиеСчетаВызовСервера.ПолучитьРеквизитыБанкаИзСправочника(Объект.БанкДляРасчетов);
	ОбновитьРеквизитыБанкаДляРасчетовНаФорме(ЭтотОбъект, РеквизитыБанка);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьРеквизитыБанкаНаФорме(Форма, РеквизитыБанка)
	
	Если ЗначениеЗаполнено(РеквизитыБанка.Ссылка) Тогда
		
		Если РеквизитыБанка.ЯвляетсяБанкомРФ Тогда 
			Форма.БИКБанка = РеквизитыБанка.Код;
		Иначе
			Форма.БИКБанка = РеквизитыБанка.СВИФТБИК;
		КонецЕсли;

		Форма.НаименованиеБанка = РеквизитыБанка.Наименование;
		Форма.ДеятельностьБанкаПрекращена = РеквизитыБанка.ДеятельностьПрекращена;
		Форма.ЯвляетсяБанкомРФ = РеквизитыБанка.ЯвляетсяБанкомРФ;
		
	КонецЕсли;
	
	ОбновитьРеквизитыПрямогоОбменаСБанками(Форма);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьРеквизитыБанкаДляРасчетовНаФорме(Форма, РеквизитыБанка)
	
	Если ЗначениеЗаполнено(РеквизитыБанка.Ссылка) Тогда
		Форма.КодБанкаДляРасчетов = РеквизитыБанка.Код;
		Форма.ДеятельностьБанкаНепрямыхРасчетовПрекращена = РеквизитыБанка.ДеятельностьПрекращена;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьРеквизитыПрямогоОбменаСБанками(Форма)
	
	Если ЗначениеЗаполнено(Форма.Объект.Банк)
		И ТипЗнч(Форма.Объект.Владелец) = Тип("СправочникСсылка.Организации") 
		И Не Форма.Объект.Валютный Тогда
		
		РеквизитыПрямогоОбмена = ПолучитьРеквизитыПрямогоОбменаСБанками(Форма.Объект.Банк, Форма.Объект.Владелец);
		
		Форма.СоглашениеПрямогоОбменаСБанками = РеквизитыПрямогоОбмена.СоглашениеПрямогоОбменаСБанками;
		Форма.СообщениеПрямогоОбмена = РеквизитыПрямогоОбмена.СообщениеПрямогоОбмена;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДоступностьВалютыСчета(Форма);
	
	Форма.Элементы.ВалютаДенежныхСредств.ТолькоПросмотр = Форма.ЯвляетсяБанкомРФ;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДоступностьПоляГосударственныйКонтракт(Форма)
	
	Элементы = Форма.Элементы;
	Элементы.ГосударственныйКонтракт.Доступность = Форма.ЭтоГосударственныйКонтракт;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДоступностьНомераИДатыРазрешения(Форма)
	
	Форма.Элементы.НомерИДатаРазрешения.Доступность = Форма.Объект.Валютный;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ДоступностьБанкаДляРасчетов(Форма)
	
	Форма.Элементы.ГруппаРеквизитыБанкаДляРасчетов.Доступность = Форма.ИспользуетсяБанкДляРасчетов;
	
КонецПроцедуры

#КонецОбласти
