&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаСервере
Процедура АнализИзмененийНаСервере()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Идентификатор КАК Идентификатор,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипСоответствия КАК ТипСоответствия,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ТипОбъектаВнешнейСистемы КАК ТипОбъектаВнешнейСистемы,
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.ОбъектПриемника
		|ПОМЕСТИТЬ ВТ_НастройкиСинхронизации
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемами
		|ГДЕ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период >= &НачалоПериода
		|	И НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Период <= &КонецПериода
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор,
		|	ТипСоответствия,
		|	ТипОбъектаВнешнейСистемы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ВТ_НастройкиСинхронизации.Идентификатор КАК Идентификатор,
		|	ВТ_НастройкиСинхронизации.ТипСоответствия КАК ТипСоответствия,
		|	ВТ_НастройкиСинхронизации.ТипОбъектаВнешнейСистемы КАК ТипОбъектаВнешнейСистемы
		|ПОМЕСТИТЬ ВТ_Повторения
		|ИЗ
		|	ВТ_НастройкиСинхронизации КАК ВТ_НастройкиСинхронизации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_НастройкиСинхронизации КАК ВТ_НастройкиСинхронизации1
		|		ПО ВТ_НастройкиСинхронизации.Идентификатор = ВТ_НастройкиСинхронизации1.Идентификатор
		|			И ВТ_НастройкиСинхронизации.ТипСоответствия = ВТ_НастройкиСинхронизации1.ТипСоответствия
		|			И ВТ_НастройкиСинхронизации.ТипОбъектаВнешнейСистемы = ВТ_НастройкиСинхронизации1.ТипОбъектаВнешнейСистемы
		|ГДЕ
		|	ВТ_НастройкиСинхронизации.ОбъектПриемника <> ВТ_НастройкиСинхронизации1.ОбъектПриемника
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	Идентификатор,
		|	ТипСоответствия,
		|	ТипОбъектаВнешнейСистемы
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЛОЖЬ КАК ВыполнятьПо,
		|	ЛОЖЬ КАК ГруппаОбработана,
		|	ВТ_НастройкиСинхронизации.Период КАК Период,
		|	ВТ_НастройкиСинхронизации.Идентификатор КАК Идентификатор,
		|	ВТ_НастройкиСинхронизации.ТипСоответствия КАК ТипСоответствия,
		|	ВТ_НастройкиСинхронизации.ТипОбъектаВнешнейСистемы КАК ТипОбъектаВнешнейСистемы,
		|	ВТ_НастройкиСинхронизации.ОбъектПриемника КАК ОбъектПриемника
		|ИЗ
		|	ВТ_НастройкиСинхронизации КАК ВТ_НастройкиСинхронизации
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТ_Повторения КАК ВТ_Повторения
		|		ПО ВТ_НастройкиСинхронизации.Идентификатор = ВТ_Повторения.Идентификатор
		|			И ВТ_НастройкиСинхронизации.ТипСоответствия = ВТ_Повторения.ТипСоответствия
		|			И ВТ_НастройкиСинхронизации.ТипОбъектаВнешнейСистемы = ВТ_Повторения.ТипОбъектаВнешнейСистемы
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ
		|ИТОГИ ПО
		|	ТипСоответствия,
		|	ТипОбъектаВнешнейСистемы,
		|	Идентификатор";
	
	Запрос.УстановитьПараметр("КонецПериода", Период.ДатаОкончания);
	Запрос.УстановитьПараметр("НачалоПериода", Период.ДатаНачала);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗначениеВРеквизитФормы(РезультатЗапроса.Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкам), "ИзмененныеДанные");
	
КонецПроцедуры

&НаКлиенте
Процедура АнализИзменений(Команда)
	АнализИзмененийНаСервере();
КонецПроцедуры

&НаСервере
Функция ВыполнитьИзмененияНаСервере()
	
	СтруктураПараметров = Новый Структура("ПараметрыСинхронизации", ПолучитьПараметрыСинхронизации());
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.ИзменениеИсторическихДанных.ВыполнитьИзменениеДанных(СтруктураПараметров, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Загрузка данных Revenue'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Обработки.ИзменениеИсторическихДанных.ВыполнитьИзменениеДанных", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ПроверитьУспешностьВыполненияЗадания(АдресХранилища);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ПолучитьПараметрыСинхронизации()
	
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ТипСоответствия", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыСоответствий"));
	Результат.Колонки.Добавить("ТипОбъектаВнешнейСистемы", Новый ОписаниеТипов("ПеречислениеСсылка.ТипыОбъектовВнешнихСистем"));
	Результат.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(100)));
	Результат.Колонки.Добавить("ДатаС", Новый ОписаниеТипов("Дата"));
	Результат.Колонки.Добавить("ДатаПо", Новый ОписаниеТипов("Дата"));
	Результат.Колонки.Добавить("ПравильныйПриемник");
	
	ДеревоПараметровСинхронизации = РеквизитФормыВЗначение("ИзмененныеДанные");
	
	Для каждого СтрокаТипСоответствия Из ДеревоПараметровСинхронизации.Строки Цикл
		
		Для каждого СтрокаТипОбъектаВнешнейСистемы Из СтрокаТипСоответствия.Строки Цикл
			
			Для каждого СтрокаИдентификатор Из СтрокаТипОбъектаВнешнейСистемы.Строки Цикл
				
				Если Не СтрокаИдентификатор.ГруппаОбработана ИЛИ СтрокаИдентификатор.Строки.Количество() = 0 Тогда
					Продолжить;
				КонецЕсли;
				
				ПерваяСтрока = СтрокаИдентификатор.Строки[0];
				ДатаПо = ПерваяСтрока.Период;
				ПравильныйПриемник = ПерваяСтрока.ОбъектПриемника;
				
				// цикл по детальным записям
				Для каждого СтрокаДетальныеЗаписи Из СтрокаИдентификатор.Строки Цикл
					Если СтрокаДетальныеЗаписи.ВыполнятьПо Тогда
						ДатаС = СтрокаДетальныеЗаписи.Период;
					КонецЕсли;
				КонецЦикла;
				
				СтрокаРезультата = Результат.Добавить();
				СтрокаРезультата.ТипСоответствия = СтрокаИдентификатор.ТипСоответствия;
				СтрокаРезультата.ТипОбъектаВнешнейСистемы = СтрокаИдентификатор.ТипОбъектаВнешнейСистемы;
				СтрокаРезультата.Идентификатор = СтрокаИдентификатор.Идентификатор;
				СтрокаРезультата.ДатаС = ДатаС;
				СтрокаРезультата.ДатаПо = ДатаПо;
				СтрокаРезультата.ПравильныйПриемник = ПравильныйПриемник;
				
			КонецЦикла;
			
		КонецЦикла;
		
	КонецЦикла; 
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьИзменения(Команда)
	
	Результат = ВыполнитьИзмененияНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьГлубинуИзменения(Команда)
	
	ДанныеСтроки = Элементы.ИзмененныеДанные.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Или ДанныеСтроки.ВыполнятьПо Тогда
		Возврат;
	КонецЕсли;
		
	Родитель = ДанныеСтроки.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИзменитьВыполнятьПоИерархически(ДанныеСтроки, Родитель);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьВыполнятьПоИерархически(Знач ДанныеСтроки, Знач Родитель)
	
	Родитель.ГруппаОбработана = Истина;
	Для Каждого Потомок Из Родитель.ПолучитьЭлементы() Цикл
		Потомок.ВыполнятьПо = Ложь;
	КонецЦикла;
	ДанныеСтроки.ВыполнятьПо = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьГруппыИзменныхДанных(Команда)
	
	РазвернутьГруппуИзменныхДанныхИерархически();
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьГруппыИзменныхДанных(Команда)
	
	СвернутьГруппуИзменныхДанныхИерархически();
	
КонецПроцедуры

&НаКлиенте
Процедура РазвернутьГруппуИзменныхДанныхИерархически(Знач СтрокаДанных = Неопределено)
	
	Если СтрокаДанных <> Неопределено Тогда
		Элементы.ИзмененныеДанные.Развернуть(СтрокаДанных, Истина);
	КонецЕсли;
	
	// Все первого уровня
	ВсеСтроки = Элементы.ИзмененныеДанные;
	Для Каждого ДанныеСтроки Из ИзмененныеДанные.ПолучитьЭлементы() Цикл 
		ВсеСтроки.Развернуть(ДанныеСтроки.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СвернутьГруппуИзменныхДанныхИерархически(Знач СтрокаДанных = Неопределено)
	
	Если СтрокаДанных <> Неопределено Тогда
		Элементы.ИзмененныеДанные.Свернуть(СтрокаДанных);
		Возврат;
	КонецЕсли;
	
	// Все первого уровня
	ВсеСтроки = Элементы.ИзмененныеДанные;
	Для Каждого ДанныеСтроки Из ИзмененныеДанные.ПолучитьЭлементы() Цикл 
		ВсеСтроки.Свернуть(ДанныеСтроки.ПолучитьИдентификатор());
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьОтметкуГлубины(Команда)
	
	ДанныеСтроки = Элементы.ИзмененныеДанные.ТекущиеДанные;
	Если ДанныеСтроки = Неопределено Или НЕ ДанныеСтроки.ВыполнятьПо Тогда
		Возврат;
	КонецЕсли;
	
	Родитель = ДанныеСтроки.ПолучитьРодителя();
	Если Родитель = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеСтроки.ВыполнятьПо = Ложь;
	Родитель.ГруппаОбработана = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ПроверитьУспешностьВыполненияЗадания(АдресХранилища);
				ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
				ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 
					ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
			КонецЕсли;
		КонецЕсли;	
	Исключение
		ДлительныеОперацииКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ПроверитьУспешностьВыполненияЗадания(АдресРезультата)
	
	Результат = ПолучитьИзВременногоХранилища(АдресРезультата);
	
	Если Результат.Свойство("Отказ") Тогда
		Если Результат.Отказ Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Failed to change data!", , , , Истина);
			Если Результат.Свойство("ТекстОшибок") Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Результат.ТекстОшибок);
			КонецЕсли;
		Иначе
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Data successfully changed.");
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры
