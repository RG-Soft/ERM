﻿/////////////////////////////////////////////////////////////////////////////////
// МЕХАНИЗМ СИНХРОНИЗАЦИИ СТРОКИ ТАБЛИЦЫ ЗНАЧЕНИЙ С БАЗОЙ ДАННЫХ
 
Процедура СинхронизироватьСтрокиТаблицыСБазойДанных(ТаблицаБазы, ТаблицаДокумента, СправочникМенеджер, Отказ, Заголовок=Неопределено) Экспорт
	
	// синхронизирует таблицу документа с базой данных
	//
	// Параметры:
	//  ТаблицаБазы  		- ТаблицаЗначений. Обязательно присутствие реквизита Ссылка.
	//  ТаблицаДокумента	- ТаблицаЗначений. Обязательно присутствие реквизита Ссылка.
	//	СправочникМенеджер	- Справочник-менеджер для создания новых объектов. 
	//						  Например "Справочники.СтрокиИнвойса"
	
	ОписаниеТиповЧ = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(1,0));
	
	// получим и подготовим рабочую ТЗ
	ТаблицаРабочая = ТаблицаБазы.Скопировать();
	ТаблицаРабочая.Колонки.Добавить("Показатель", ОписаниеТиповЧ);
	ТаблицаРабочая.ЗаполнитьЗначения(-1, "Показатель");
		
	// объединим две таблицы
	Для каждого Стр из ТаблицаДокумента Цикл
		НовСтр = ТаблицаРабочая.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтр, Стр);
		НовСтр.Показатель = 1;
	КонецЦикла;
	
	// подготовим имена колонок для свертки таблицы
	ИменаКолонокСвертки = "";
	Для каждого Колонка ИЗ ТаблицаБазы.Колонки Цикл
		ИменаКолонокСвертки = ИменаКолонокСвертки + "," + Колонка.Имя;
	КонецЦикла;
	ИменаКолонокСвертки = Сред(ИменаКолонокСвертки, 2);
	
	// свернем вновь образованную таблицу
	ТаблицаРабочая.Свернуть(ИменаКолонокСвертки, "Показатель");
	ТаблицаРабочая.Сортировать("Показатель");
	ТаблицаРабочая.Индексы.Добавить("Ссылка");
	
	// обработаем полученную таблицу
	Для Каждого Стр Из ТаблицаРабочая Цикл
		
		Если ЗначениеЗаполнено(Стр.Ссылка) Тогда
						
			Если Стр.Показатель = 1 Тогда
				
				// строка изменилась, обработаем это
				Объект = Стр.Ссылка.ПолучитьОбъект();
				ЗаполнитьЗначенияСвойств(Объект, Стр);
				Объект.ПометкаУдаления = Ложь;
				ПопыткаЗаписиОбъекта(Объект, Отказ);
				
			ИначеЕсли Стр.Показатель = -1 Тогда
				
				// Показатель = -1, строку удалили или изменили
				// Пометим на удаление элемент справочника
				// Если его не удалили, а изменили, то пометка удаления потом снимется
				// Кажется, что в случаи изменения, помечать на удаление не надо, однако это нужно для контроля уникальности
					
				Объект = Стр.Ссылка.ПолучитьОбъект();
				Объект.ПометкаУдаления = Истина;
				ПопыткаЗаписиОбъекта(Объект, Отказ);
			
			КонецЕсли;
			
		Иначе
			
			// строка добавлена
			Объект = СправочникМенеджер.СоздатьЭлемент();
			ЗаполнитьЗначенияСвойств(Объект, Стр);
			ПопыткаЗаписиОбъекта(Объект, Отказ);
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПопыткаЗаписиОбъекта(Объект, Отказ) Экспорт
	
	Попытка
		Объект.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			"Не удалось записать """ + Объект + """! См. сообщения выше.",
			Объект, , , Отказ);
	КонецПопытки;
	
КонецПроцедуры

Процедура ЗагрузитьAccountingUnitsИзAU_master() Экспорт
	Обработки.AULoading.ЗагрузитьAccountingUnitsИзAU_master();
КонецПроцедуры


Процедура ИзменитьСтруктуруСегментов(Стр, Segment, SubSegment, SsubSegment) Экспорт

	//сегменты
	
	Segment = Справочники.Сегменты.НайтиПоКоду(СокрЛП(Стр.Segment));
	
	Если Не ЗначениеЗаполнено(Segment) Тогда
		
		SegmentОбъект = Справочники.Сегменты.СоздатьГруппу();
		SegmentОбъект.Код = СокрЛП(Стр.Segment);
		SegmentОбъект.Наименование = СокрЛП(Стр.Segment);
		SegmentОбъект.Родитель = Справочники.Сегменты.ПустаяСсылка();
		SegmentОбъект.Записать();
		Segment = SegmentОбъект.Ссылка;
		
	иначе
		
		SegmentОбъект = Segment.ПолучитьОбъект();
		
		Если Не SegmentОбъект.ЭтоГруппа Тогда 
			
			//Запоминаем ссылку на текущий элемент
			УникальнаяСсылка = Справочники.Сегменты.ПолучитьСсылку(SegmentОбъект.Ссылка.УникальныйИдентификатор());
			
			//Создаем новый элемент - группу
			НовыйЭлемент = Справочники.Сегменты.СоздатьГруппу();    
			НовыйЭлемент.УстановитьСсылкуНового(УникальнаяСсылка);
			
			//... с такими же параметрами, что и текущий
			НовыйЭлемент.Код                 = SegmentОбъект.Код;
			НовыйЭлемент.Наименование        = SegmentОбъект.Наименование;
			НовыйЭлемент.Родитель            = Справочники.Сегменты.ПустаяСсылка();
			НовыйЭлемент.Source              = Перечисления.ТипыСоответствий.Lawson;
			
			//Удаляем текущий
			SegmentОбъект.Удалить();
			
			//Записываем новый (группу)
			НовыйЭлемент.Записать();
			
			Segment = НовыйЭлемент.Ссылка;
			
		иначе
			
			РГСофтКлиентСервер.УстановитьЗначение(SegmentОбъект.Родитель, Справочники.Сегменты.ПустаяСсылка());
		
			Если SegmentОбъект.Модифицированность() Тогда 
				SegmentОбъект.Записать();
			КонецЕсли;  
			Segment = SegmentОбъект.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;
	
	SubSegment = Справочники.Сегменты.НайтиПоКоду(СокрЛП(Стр.SubSegment));
	
	Если Не ЗначениеЗаполнено(SubSegment) Тогда 
		
		SubSegmentОбъект = Справочники.Сегменты.СоздатьГруппу();
		SubSegmentОбъект.Код = СокрЛП(Стр.SubSegment);
		SubSegmentОбъект.Наименование = СокрЛП(Стр.SubSegment);
		SubSegmentОбъект.Родитель = Segment;
		SubSegmentОбъект.Записать();
		SubSegment = SubSegmentОбъект.Ссылка;
		
	иначе
		
		SubSegmentОбъект = SubSegment.получитьОбъект();
		
		Если Не SubSegmentОбъект.ЭтоГруппа Тогда 
			
			//Запоминаем ссылку на текущий элемент
			УникальнаяСсылка = Справочники.Сегменты.ПолучитьСсылку(SubSegmentОбъект.Ссылка.УникальныйИдентификатор());
			
			//Создаем новый элемент - группу
			НовыйЭлемент = Справочники.Сегменты.СоздатьГруппу();    
			НовыйЭлемент.УстановитьСсылкуНового(УникальнаяСсылка);
			
			//... с такими же параметрами, что и текущий
			НовыйЭлемент.Код                 = SubSegmentОбъект.Код;
			НовыйЭлемент.Наименование        = SubSegmentОбъект.Наименование;
			НовыйЭлемент.Родитель            = Segment;
			НовыйЭлемент.Source              = Перечисления.ТипыСоответствий.Lawson;
			
			//Удаляем текущий
			SubSegmentОбъект.Удалить();
			
			//Записываем новый (группу)
			НовыйЭлемент.Записать();
			
			SubSegment = НовыйЭлемент.Ссылка;
			
		иначе
			
			МассивНовыхЭлементов = Новый Массив;
			
			Если НЕ ЗначениеЗаполнено(SubSegmentОбъект.Родитель) Тогда 
				
				//сделаем все подчиненные группы - элементами, иначе будет превышение уровня элементов
				Запрос = Новый Запрос;
				Запрос.УстановитьПараметр("SubSegment", SubSegmentОбъект.Ссылка);
				
				Запрос.Текст = "ВЫБРАТЬ
				               |	Сегменты.Ссылка,
				               |	Сегменты.Код,
				               |	Сегменты.Наименование
				               |ИЗ
				               |	Справочник.Сегменты КАК Сегменты
				               |ГДЕ
				               |	Сегменты.Ссылка В ИЕРАРХИИ(&SubSegment)
				               |	И Сегменты.ЭтоГруппа
				               |	И Сегменты.Ссылка <> &SubSegment";
				
				ТЗ = Запрос.Выполнить().Выгрузить();
				ТЗДляИзменения = ТЗ.Скопировать();
				
				Для Каждого СтрТЗДляИзменения из ТЗДляИзменения Цикл
					
					//Запоминаем ссылку на текущий элемент
					УникальнаяСсылка = Справочники.Сегменты.ПолучитьСсылку(СтрТЗДляИзменения.Ссылка.УникальныйИдентификатор());
					
					//Создаем новый элемент - группу
					НовыйЭлемент = Справочники.Сегменты.СоздатьЭлемент();    
					НовыйЭлемент.УстановитьСсылкуНового(УникальнаяСсылка);
					
					//... с такими же параметрами, что и текущий
					НовыйЭлемент.Код                 = СтрТЗДляИзменения.Код;
					НовыйЭлемент.Наименование        = СтрТЗДляИзменения.Наименование;
					НовыйЭлемент.Родитель            = SubSegmentОбъект.Ссылка;
					
					//Удаляем текущий
					СтрТЗДляИзменения.Ссылка.получитьОбъект().Удалить();
					
					//добавляем новый 
					МассивНовыхЭлементов.Добавить(НовыйЭлемент);
					  				
				КонецЦикла;
				
			КонецЕсли;

			РГСофтКлиентСервер.УстановитьЗначение(SubSegmentОбъект.Родитель, Segment);
		
			Если SubSegmentОбъект.Модифицированность() Тогда 
				SubSegmentОбъект.Записать();
			КонецЕсли;
			
			Для Каждого НовыйЭлемент из МассивНовыхЭлементов Цикл 
				НовыйЭлемент.Записать();
			КонецЦикла;
			
			SubSegment = SubSegmentОбъект.Ссылка;
			
		КонецЕсли;

	КонецЕсли;
		
	SsubSegment = Справочники.Сегменты.НайтиПоКоду(СокрЛП(Стр.SsubSegment));
	
	Если Не ЗначениеЗаполнено(SsubSegment) Тогда 
		
		SsubSegmentОбъект = Справочники.Сегменты.СоздатьЭлемент();
		SsubSegmentОбъект.Код = СокрЛП(Стр.SsubSegment);
		SsubSegmentОбъект.Наименование = СокрЛП(Стр.SsubSegment);
		SsubSegmentОбъект.Source = Перечисления.ТипыСоответствий.Lawson;
		SsubSegmentОбъект.Родитель = SubSegment;
		SsubSegmentОбъект.Записать();
		SsubSegment = SsubSegmentОбъект.Ссылка;
		
	иначе
		
		SsubSegmentОбъект = SsubSegment.получитьОбъект();
				
		Если SsubSegmentОбъект.ЭтоГруппа Тогда 
			
			//Запоминаем ссылку на текущий элемент                           
			УникальнаяСсылка = Справочники.Сегменты.ПолучитьСсылку(SsubSegmentОбъект.Ссылка.УникальныйИдентификатор());
			
			//Создаем новый элемент - группу
			НовыйЭлемент = Справочники.Сегменты.СоздатьЭлемент();    
			НовыйЭлемент.УстановитьСсылкуНового(УникальнаяСсылка);
			
			//... с такими же параметрами, что и текущий
			НовыйЭлемент.Код                 = SsubSegmentОбъект.Код;
			НовыйЭлемент.Наименование        = SsubSegmentОбъект.Наименование;
			НовыйЭлемент.Родитель            = SubSegment;
			
			//Удаляем текущий
			SsubSegmentОбъект.Удалить();
			
			//Записываем новый (группу)
			НовыйЭлемент.Записать();
			
			SsubSegment = НовыйЭлемент.Ссылка; 		
			
		иначе
									
			РГСофтКлиентСервер.УстановитьЗначение(SsubSegmentОбъект.Родитель, SubSegment);
			Если SsubSegmentОбъект.Модифицированность() Тогда 
				SsubSegmentОбъект.Записать();
			КонецЕсли;
			
			SsubSegment = SsubSegmentОбъект.Ссылка;
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры
 
