﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Трансляция XDTO".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Для внутреннего использования.
Функция ТранслироватьОбъект(Знач Объект, ФабрикаXDTO) Экспорт
	
	ПакетИсходногоОбъекта = Объект.Тип().URIПространстваИмен;
	
	// Отсутствие итераций в цепочке трансляции означает, что версия не изменилась, и нужно просто
	// скопировать значения свойств исходного объекта в результирующий объект.
	Объект = СтандартнаяОбработка(Объект, Объект.Тип().URIПространстваИмен, ФабрикаXDTO);
	
	Возврат Объект;
	
КонецФункции

// Для внутреннего использования.
Функция СтандартнаяОбработка(Знач Объект, Знач ПакетРезультирующегоОбъекта, ФабрикаXDTO)
	
	ТипИсходногоОбъекта = Объект.Тип();
	Если ТипИсходногоОбъекта.URIПространстваИмен = ПакетРезультирующегоОбъекта Тогда
		ТипРезультирующегоОбъекта = ТипИсходногоОбъекта;
	Иначе
		ТипРезультирующегоОбъекта = ФабрикаXDTO.Тип(ПакетРезультирующегоОбъекта, ТипИсходногоОбъекта.Имя);
		Если ТипРезультирующегоОбъекта = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось выполнить стандартную обработку трансляции типа %1 в пакет %2: тип %1 не существует в пакете %2!'"),
				"{" + ТипИсходногоОбъекта.URIПространстваИмен + "}" + ТипИсходногоОбъекта.Имя,
				"{" + ПакетРезультирующегоОбъекта + "}");
		КонецЕсли;
	КонецЕсли;
		
	РезультирующийОбъект = ФабрикаXDTO.Создать(ТипРезультирующегоОбъекта);
	СвойстваИсходногоОбъекта = Объект.Свойства();
	
	Для Каждого Свойство Из ТипРезультирующегоОбъекта.Свойства Цикл
		
		СвойствоОригинала = ТипИсходногоОбъекта.Свойства.Получить(Свойство.ЛокальноеИмя);
		Если СвойствоОригинала = Неопределено Тогда
			
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось выполнить стандартную обработку конвертации типа %1 в тип %2: свойство %3 не определено для типа %1!'"),
				"{" + ТипИсходногоОбъекта.URIПространстваИмен + "}" + ТипИсходногоОбъекта.Имя,
				"{" + ТипРезультирующегоОбъекта.URIПространстваИмен + "}" + ТипРезультирующегоОбъекта.Имя,
				Свойство.ЛокальноеИмя);
			
		КонецЕсли;
		
	КонецЦикла;
	
	Для Каждого Свойство Из ТипИсходногоОбъекта.Свойства Цикл
		
		ТранслируемоеСвойство = ТипРезультирующегоОбъекта.Свойства.Получить(Свойство.ЛокальноеИмя);
		Если ТранслируемоеСвойство = Неопределено Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Не удалось выполнить стандартную обработку конвертации типа %1 в тип %2: свойство %3 не определено для типа %2!'"),
				"{" + ТипИсходногоОбъекта.URIПространстваИмен + "}" + ТипИсходногоОбъекта.Имя,
				"{" + ТипРезультирующегоОбъекта.URIПространстваИмен + "}" + ТипРезультирующегоОбъекта.Имя,
				Свойство.ЛокальноеИмя);
		КонецЕсли;
			
		Если Объект.Установлено(Свойство) Тогда
			
			Если Свойство.ВерхняяГраница = 1 Тогда
				
				// ОбъектXDTO или ЗначениеXDTO.
				ТранслируемоеЗначение = Объект.ПолучитьXDTO(Свойство);
				
				Если ТипЗнч(ТранслируемоеЗначение) = Тип("ОбъектXDTO") Тогда
					РезультирующийОбъект.Установить(ТранслируемоеСвойство, ТранслироватьОбъект(ТранслируемоеЗначение, ФабрикаXDTO));
				Иначе
					РезультирующийОбъект.Установить(ТранслируемоеСвойство, ТранслируемоеЗначение);
				КонецЕсли;
				
			Иначе
				
				// СписокXDTO
				ТранслируемыйСписок = Объект.ПолучитьСписок(Свойство);
				
				Для Итератор = 0 По ТранслируемыйСписок.Количество() - 1 Цикл
					
					ЭлементСписка = ТранслируемыйСписок.ПолучитьXDTO(Итератор);
					
					Если ТипЗнч(ЭлементСписка) = Тип("ОбъектXDTO") Тогда
						РезультирующийОбъект[Свойство.ЛокальноеИмя].Добавить(ТранслироватьОбъект(ЭлементСписка, ФабрикаXDTO));
					Иначе
						РезультирующийОбъект[Свойство.ЛокальноеИмя].Добавить(ЭлементСписка);
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат РезультирующийОбъект;
	
КонецФункции

#КонецОбласти
