

&НаКлиенте
Процедура ТипВнешнейСистемыПриИзменении(Элемент)
	
//	Если (Запись.ТипСоответствия = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.Lawson") ИЛИ
//		 Запись.ТипСоответствия = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") ИЛИ
//		 Запись.ТипСоответствия = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleSmith")) И
//		 Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Client") Тогда
//		 	
//		 	ТолькоПросмотр = Истина;
//		 	
//	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПриемникаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.ПустаяСсылка") Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Ложь;
	
	Если Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Geomarket") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
		//ПараметрыФормы.Вставить("ОтборПоКоду", Запись.Идентификатор);
		ОткрытьФорму("Справочник.GeoMarkets.Форма.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.AccountingUnit") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
		ОткрытьФорму("Справочник.КостЦентры.Форма.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Client") Тогда
		ОткрытьФорму("Справочник.Контрагенты.Форма.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Currency") Тогда
		ОткрытьФорму("Справочник.Валюты.Форма.ФормаВыбора",,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Segment") Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("ВыборГруппИЭлементов", ИспользованиеГруппИЭлементов.ГруппыИЭлементы);
		ОткрытьФорму("Справочник.Сегменты.Форма.ФормаВыбора", ПараметрыФормы,,,,, Новый ОписаниеОповещения("ОбъектПриемникаНачалоВыбораЗавершение", ЭтаФорма),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектПриемникаНачалоВыбораЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат <> Неопределено Тогда
		Запись.ОбъектПриемника = Результат;
	КонецЕсли;
	
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Период") Тогда
		Запись.Период = НачалоМесяца(Параметры.Период);
	КонецЕсли;
	
	Если (Запись.ТипСоответствия = Перечисления.ТипыСоответствий.Lawson ИЛИ
		 Запись.ТипСоответствия = Перечисления.ТипыСоответствий.OracleMI ИЛИ
		 Запись.ТипСоответствия = Перечисления.ТипыСоответствий.OracleSmith) И 
		 Запись.ТипОбъектаВнешнейСистемы = Перечисления.ТипыОбъектовВнешнихСистем.Client И
		 НЕ РольДоступна("ПолныеПрава")	 Тогда
		 	
			РеквизитыКлиента = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Запись.ОбъектПриемника,"Предопределенный, Intercompany");
		
			Если НЕ РеквизитыКлиента.Предопределенный И НЕ РеквизитыКлиента.Intercompany Тогда
		
			 	ТолькоПросмотр = Истина;
			
			КонецЕсли;
		 	
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ОтработкаКоллизии");
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Запись.ТипСоответствия = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.HOBs") И
		Запись.ТипОбъектаВнешнейСистемы = ПредопределенноеЗначение("Перечисление.ТипыОбъектовВнешнихСистем.Client") Тогда
	
		СтруктураЗаписи = Новый Структура("Идентификатор, ТипСоответствия, ТипОбъектаВнешнейСистемы, ОбъектПриемника");
		ЗаполнитьЗначенияСвойств(СтруктураЗаписи, Запись);
		
		ФлажокЗаписи = ПроверитьНеобходимостьЗаполненияИНН(СтруктураЗаписи);
		
		Если ФлажокЗаписи <> Неопределено Тогда
			
			Если Не ФлажокЗаписи Тогда
				
				Режим = РежимДиалогаВопрос.ДаНет;
				Ответ = Вопрос("Are you sure you want to overwrite client's ITN?",Режим ,0 , , "Please confirm client's ITN change");
				
				Если Ответ = КодВозвратаДиалога.Да Тогда
					
					ФлажокЗаписи = Истина;
					
				Иначе
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("ITN change reverted. Data won't be saved",,,,Отказ);
					
				КонецЕсли;
				
			КонецЕсли;
				
			Если ФлажокЗаписи Тогда
				
				УспехЗаписи = ЗаполнитьИННКонтрагентаHOB(СтруктураЗаписи);
				
				Если Не УспехЗаписи Тогда
					
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("ITN is longer than it's supposed to be. Data won't be saved",,,,Отказ);
					
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

Функция ПроверитьНеобходимостьЗаполненияИНН(СтруктураЗаписи)
	
	Если СтруктураЗаписи.ОбъектПриемника.Предопределенный Тогда
			
		Возврат ?(ЗначениеЗаполнено(СтруктураЗаписи.ОбъектПриемника.ИНН), Ложь, Истина);
			
	Иначе
	
		Возврат Неопределено;
		
	КонецЕсли;
	
КонецФункции


&НаСервере
Функция ЗаполнитьИННКонтрагентаHOB(СтруктураЗаписи)
	
	ТекущийКонтрагент = СтруктураЗаписи.ОбъектПриемника.ПолучитьОбъект();
	
	Идентификатор = СтруктураЗаписи.Идентификатор;
	ДлинаИдентификатора = СтрДлина(Идентификатор);
	ПредполагаемаяДлинаИНН = ?(ДлинаИдентификатора > 10 И ДлинаИдентификатора < 13, 12,?(ТекущийКонтрагент.ЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо, 10, 12));
	
	Если ДлинаИдентификатора < ПредполагаемаяДлинаИНН Тогда
		
		Пока ДлинаИдентификатора < ПредполагаемаяДлинаИНН Цикл
			
			Идентификатор = "0" + Идентификатор;
			ДлинаИдентификатора = ДлинаИдентификатора + 1;
			
		КонецЦикла;
			
	ИначеЕсли ДлинаИдентификатора > ПредполагаемаяДлинаИНН Тогда
		
		Возврат Ложь;
		
	КонецЕсли;
	
	ТекущийКонтрагент.ИНН = Идентификатор;
	ТекущийКонтрагент.ОбменДанными.Загрузка = Истина;
	ТекущийКонтрагент.Записать();
	
	Возврат Истина;
	
КонецФункции