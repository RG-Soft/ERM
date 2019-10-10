&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Процедура Заполнить(Команда)
	
	Если Объект.CalculationPenalty.Количество() > 0 ИЛИ Объект.CalculationBenefit.Количество() > 0 ИЛИ Объект.CalculationOnTime.Количество() > 0 Тогда
	
		ПоказатьВопрос(Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект), "The document is filled. If you continue, the data will be lost. Continue?", РежимДиалогаВопрос.ДаНет, 10);
		
	Иначе
		
		ЗаполнитьРасчетныеДанныеНаКлиенте();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗаполнитьРасчетныеДанныеНаКлиенте();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРасчетныеДанныеНаКлиенте()
	
	Результат = ЗаполнитьРасчетныеДанныеНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
	//Иначе
	//	Прочитать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьРасчетныеДанныеНаСервере()
	
	СтруктураПараметров = Новый Структура("Ссылка");
	СтруктураПараметров.Вставить("Ссылка", Объект.Ссылка);
	СтруктураПараметров.Вставить("ПериодРасчета", Объект.Дата);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Документы.PenaltyCalculation.ЗаполнитьРасчетныеДанные(СтруктураПараметров, АдресХранилища);
		
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Заполнение данные по штрафам'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Документы.PenaltyCalculation.ЗаполнитьРасчетныеДанные", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	Если ТипЗнч(СтруктураДанных) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ОшибкаЗаполнения") Тогда
		ВызватьИсключение СтруктураДанных.ОшибкаЗаполнения;
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ДанныеПоШтрафам") Тогда
		Объект.CalculationPenalty.Загрузить(СтруктураДанных.ДанныеПоШтрафам);
	КонецЕсли;
	
	Если СтруктураДанных.Свойство("ДанныеПоBenefit") Тогда
		Объект.CalculationBenefit.Загрузить(СтруктураДанных.ДанныеПоBenefit);
	КонецЕсли;

	Если СтруктураДанных.Свойство("ДанныеПоOnTime") Тогда
		Объект.CalculationOnTime.Загрузить(СтруктураДанных.ДанныеПоOnTime);
	КонецЕсли;
	
	Элементы.CalculationPenalty.Обновить();
	Элементы.CalculationBenefit.Обновить();
	Элементы.CalculationOnTime.Обновить();
	Модифицированность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ФормаДлительнойОперации.Открыта() 
			И ФормаДлительнойОперации.ИдентификаторЗадания = ИдентификаторЗадания Тогда
			Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
				ЗагрузитьПодготовленныеДанные();
				//Прочитать();
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

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.Дата = РезультатВыбора.КонецПериода;
	
КонецПроцедуры


&НаКлиенте
Процедура ДатаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Объект.Дата = Дата(1,1,1) Тогда	
		ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(ТекущаяДата()), КонецМесяца(ТекущаяДата()));
	Иначе
		ПараметрыВыбораПериода = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(Объект.Дата), КонецМесяца(Объект.Дата));
	КонецЕсли;	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбораПериода, , , , , ОписаниеОповещения);
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Дата = Дата(1,1,1) Тогда
		Объект.Дата = КонецМесяца(ТекущаяДата());
	КонецЕсли;
КонецПроцедуры

