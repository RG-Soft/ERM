
// Формирует отчет по переданным параметрам и помещает его результат во временное хранилище.
//
// Параметры:
//	ПараметрыОтчета - Структура - Содержит ключи:
//		* ИдентификаторОтчета - Строка - Имя отчета, как оно указано в метаданных.
//		* СхемаКомпоновкиДанных - СхемаКомпоновкиДанных - Схема отчета.
//		* НастройкиКомпоновкиДанных - НастройкиКомпоновкиДанных - Настройки отчета.
//	АдресХранилища - Строка - Адрес временного хранилища, в которое необходимо поместить результат.
//
Процедура СформироватьОтчет(ПараметрыОтчета, АдресХранилища) Экспорт
	
	ВыводитьПолностью = Истина;
	
	Отказ = Ложь;
	ДанныеРасшифровкиОбъект = Неопределено;
	ПараметрыИсполненияОтчета = Неопределено;
	
	МенеджерОтчета = Отчеты[ПараметрыОтчета.ИдентификаторОтчета];
	
	Попытка
		ПараметрыИсполненияОтчета = МенеджерОтчета.ПолучитьПараметрыИсполненияОтчета();
	Исключение
		// Запись в журнал регистрации не требуется
	КонецПопытки;
	
	ИспользоватьВнешниеНаборыДанных            = Ложь;
	ИспользоватьПередКомпоновкойМакета         = Ложь;
	ИспользоватьПослеКомпоновкиМакета          = Ложь;
	ИспользоватьПередВыводомЭлементаРезультата = Ложь;
	ИспользоватьДанныеРасшифровки              = Истина;
	ИспользоватьПривилегированныйРежим         = Истина;
	
	Если ПараметрыИсполненияОтчета <> Неопределено Тогда
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьВнешниеНаборыДанных") Тогда
			ИспользоватьВнешниеНаборыДанных = ПараметрыИсполненияОтчета.ИспользоватьВнешниеНаборыДанных;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПередКомпоновкойМакета") Тогда
			ИспользоватьПередКомпоновкойМакета = ПараметрыИсполненияОтчета.ИспользоватьПередКомпоновкойМакета;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПослеКомпоновкиМакета") Тогда
			ИспользоватьПослеКомпоновкиМакета = ПараметрыИсполненияОтчета.ИспользоватьПослеКомпоновкиМакета;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПередВыводомЭлементаРезультата") Тогда
			ИспользоватьПередВыводомЭлементаРезультата = ПараметрыИсполненияОтчета.ИспользоватьПередВыводомЭлементаРезультата;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьДанныеРасшифровки") Тогда
			ИспользоватьДанныеРасшифровки = ПараметрыИсполненияОтчета.ИспользоватьДанныеРасшифровки;
		КонецЕсли;
		Если ПараметрыИсполненияОтчета.Свойство("ИспользоватьПривилегированныйРежим") Тогда
			ИспользоватьПривилегированныйРежим = ПараметрыИсполненияОтчета.ИспользоватьПривилегированныйРежим;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(ПараметрыОтчета.СхемаКомпоновкиДанных) = Тип("Строка") Тогда
		Если ЭтоАдресВременногоХранилища(ПараметрыОтчета.СхемаКомпоновкиДанных) Тогда
			СхемаКомпоновкиДанных = ПолучитьИзВременногоХранилища(ПараметрыОтчета.СхемаКомпоновкиДанных);
		КонецЕсли;
	Иначе
		СхемаКомпоновкиДанных = ПараметрыОтчета.СхемаКомпоновкиДанных;
	КонецЕсли;
	
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.ЗагрузитьНастройки(ПараметрыОтчета.НастройкиКомпоновкиДанных);
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	Результат = Новый ТабличныйДокумент;
	
	Если ВыводитьПолностью Тогда
		Если ИспользоватьПередКомпоновкойМакета Тогда
			МенеджерОтчета.ПередКомпоновкойМакета(ПараметрыОтчета, СхемаКомпоновкиДанных, КомпоновщикНастроек);
		КонецЕсли;
		
		КомпоновщикНастроек.Восстановить();
		
		НастройкиДляКомпоновкиМакета = КомпоновщикНастроек.ПолучитьНастройки();
		
		// Сгенерируем макет компоновки данных при помощи компоновщика макета
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		
		Попытка
			
			// В качестве схемы компоновки будет выступать схема самого отчета.
			// В качестве настроек отчета - текущие настройки отчета.
			// Данные расшифровки будем помещать в ДанныеРасшифровки.
			Если ИспользоватьДанныеРасшифровки Тогда 
				МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета, ДанныеРасшифровкиОбъект);
			Иначе
				МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиДляКомпоновкиМакета);
			КонецЕсли;
			
			// Вызываем событие отчета
			Если ИспользоватьПослеКомпоновкиМакета Тогда
				МенеджерОтчета.ПослеКомпоновкиМакета(ПараметрыОтчета, МакетКомпоновки);
			КонецЕсли;
			
			Если ИспользоватьВнешниеНаборыДанных Тогда
				ВнешниеНаборыДанных = МенеджерОтчета.ПолучитьВнешниеНаборыДанных(ПараметрыОтчета, МакетКомпоновки);
			КонецЕсли;
		
			// Создадим и инициализируем процессор компоновки
			ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
			Если ВнешниеНаборыДанных = Неопределено Тогда
				ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,, ДанныеРасшифровкиОбъект, Истина);
			Иначе
				ПроцессорКомпоновки.Инициализировать(МакетКомпоновки, ВнешниеНаборыДанных, ДанныеРасшифровкиОбъект, Истина);
			КонецЕсли;	
			
			// Создадим и инициализируем процессор вывода результата
			ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
			ПроцессорВывода.УстановитьДокумент(Результат);
			
			// Перед началом вывода установим привилегированный режим
			Если ИспользоватьПривилегированныйРежим Тогда
				УстановитьПривилегированныйРежим(Истина);
			КонецЕсли;
		
			// Обозначим начало вывода
			ПроцессорВывода.НачатьВывод();
			
			Если ИспользоватьПередВыводомЭлементаРезультата Тогда
				// Основной цикл вывода отчета
				Пока Истина Цикл
					
					// Получим следующий элемент результата компоновки
					ЭлементРезультата = ПроцессорКомпоновки.Следующий();
					
					Если ЭлементРезультата = Неопределено Тогда
						// Следующий элемент не получен - заканчиваем цикл вывода
						Прервать;
					Иначе
						
						Отказ = Ложь;
						
						МенеджерОтчета.ПередВыводомЭлементаРезультата(ПараметрыОтчета, МакетКомпоновки, ДанныеРасшифровкиОбъект, ЭлементРезультата, Отказ);
						
						Если Не Отказ Тогда
							// Элемент получен - выведем его при помощи процессора вывода
							ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
						КонецЕсли;	
					КонецЕсли;
				КонецЦикла;
				
				// Завершение вывода отчета
				ПроцессорВывода.ЗакончитьВывод();
			Иначе
				ПроцессорВывода.Вывести(ПроцессорКомпоновки, Истина);
			КонецЕсли;
			
			// После окончания процессором вывода отчета, поместим расшифровку во временное хранилище.
			ДанныеДляРасшифровки = Новый Структура("Объект, ДанныеРасшифровки", ПараметрыОтчета, ДанныеРасшифровкиОбъект); 
			ДанныеРасшифровки = ПоместитьВоВременноеХранилище(ДанныеДляРасшифровки, ПараметрыОтчета.ДанныеРасшифровки);
			
			// Отключаем привилегированный режим если он использовался
			Если ИспользоватьПривилегированныйРежим Тогда
				УстановитьПривилегированныйРежим(Ложь);
			КонецЕсли;
			
		Исключение
			// Запись в журнал регистрации не требуется
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			Пока ИнформацияОбОшибке.Причина <> Неопределено Цикл
				ИнформацияОбОшибке = ИнформацияОбОшибке.Причина;
			КонецЦикла;
			ТекстСообщения = НСтр("ru = 'Отчет не сформирован! %1'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрШаблон(ТекстСообщения, ИнформацияОбОшибке.Описание));
			Отказ = Истина;
		КонецПопытки;
		
	КонецЕсли;
	
	// Если по каким-либо причинам отчет не был сформирован, адрес расшифровки оставляем прежним,
	// чтобы использовать его повторно при следующем формировании отчета.
	Если Отказ Тогда
		ДанныеРасшифровки = ПараметрыОтчета.ДанныеРасшифровки;
	КонецЕсли;
	
	ПоместитьВоВременноеХранилище(Новый Структура("Результат,ДанныеРасшифровки", Результат, ДанныеРасшифровки), АдресХранилища);
	
КонецПроцедуры


