////////////////////////////////////////////////////////////////////////////////
// Проверка одного или нескольких контрагентов при помощи веб-сервиса ФНС.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Установить текст подсказки в документе.
//
// Параметры:
//  ПараметрыПрорисовки	 - Структура - Описание см ПроверкаКонтрагентов.ДополнитьОписание.
//  СостояниеПроверки	 - Перечисления.СостоянияПроверкиКонтрагентов - Указывает, в каком состояние проверка:
//		завершилась, не завершилась, выполняется или отсутствует доступ к веб-сервису.
//
Процедура УстановитьТекстПодсказкиВДокументе(ПараметрыПрорисовки, СостояниеПроверки) Экспорт
	
	// Определение цвета и текста
	ПодсказкаВДокументе = ПодсказкаВДокументе(ПараметрыПрорисовки, СостояниеПроверки);
	
	// Цвет рамки
	Если ПараметрыПрорисовки.ЭлементРодитель <> Неопределено Тогда
		ЭлементРодитель	= ПараметрыПрорисовки.ЭлементРодитель;
		ЭлементРодитель.ЦветФона = ПодсказкаВДокументе.ЦветФона;
	КонецЕсли;
	
	// Текст расширенной подсказки.
	Элемент = ПараметрыПрорисовки.Элемент;
	Элемент.РасширеннаяПодсказка.Заголовок = ПодсказкаВДокументе.Текст;
	Элемент.ОтображениеПодсказки = ОтображениеПодсказки.Кнопка;
		
КонецПроцедуры

// Вывод панели проверки в отчете.
//
// Параметры:
//  Форма	 				- УправляемаяФорма - Форма отчета, для которого выводится результат проверки контрагента.
//  ВидПанелиПроверки		- Строка - Текущее состояние проверки, соответствующее виду панели,
//		может принимать одно из следующих значений:
// 			"ВсеКонтрагентыКорректные"			- Устанавливает вид панели проверки, для случая,
//				когда все контрагенты корректны.
// 			"НайденыНекорректныеКонтрагенты"	- Устанавливает вид панели проверки, для случая,
//				когда найдены некорректные контрагенты.
// 			"ПроверкаВПроцессеВыполнения"		- Устанавливает вид панели проверки, для случая,
//				когда проверка контрагента еще выполняется.
// 			"НетДоступаКСервису"				- Устанавливает вид панели проверки, для случая,
//				когда доступ к сервису проверки отсутствует.
// 			Пустая строка						- Панель проверки контрагентов не видна.
Процедура УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, ВидПанелиПроверки = "") Экспорт
	
	// Если в отчете не добавлена панель результата проверки контрагентов, то данные действия не требуются.
	Если Форма.Элементы.Найти("ПроверкаКонтрагента") = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтандартнаяОбработка = Истина;
	Форма.Элементы.ПроверкаКонтрагента.Видимость = Ложь;
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, СтандартнаяОбработка, ВидПанелиПроверки);
	
	// Если действия по отображению результата проверки переопределили, то стандартную обработку не выполняем.
	Если НЕ СтандартнаяОбработка Тогда
		Возврат;
	КонецЕсли;
	
	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Если ЗначениеЗаполнено(ВидПанелиПроверки) Тогда 
			
			Форма.Элементы.ПроверкаКонтрагента.Видимость = Истина;
			Форма.Элементы.ПроверкаКонтрагента.ТекущаяСтраница = Форма.Элементы[ВидПанелиПроверки];
			
			Если ВидПанелиПроверки = "НайденыНекорректныеКонтрагенты" Тогда
				
				Форма.ПроверкаКонтрагентовПереключательРежимаОтображения = ?(Форма.РеквизитыПроверкиКонтрагентов.ВыведеныВсеСтроки, "Все", "Недействующие");
				
			КонецЕсли;
			
		Иначе
			
			Форма.Элементы.ПроверкаКонтрагента.Видимость = Ложь;
			
		КонецЕсли;
		
	Иначе
		Форма.Элементы.ПроверкаКонтрагента.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Определяет, есть ли у формы документа контрагент в шапке.
//
// Параметры:
//  Форма	- УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
// Возвращаемое значение:
//  Булево - Истина, если это документ с контрагентом в шапке.
//
Функция ЭтоДокументСКонтрагентомВШапке(Форма) Экспорт
	
	Результат = РезультатОпределенияВидаДокумента();
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ОпределитьВидДокумента(Форма, Результат);
	
	Возврат Результат.КонтрагентНаходитсяВШапке;

КонецФункции

// Определяет, является ли форма документа формой счета-фактуры.
//
// Параметры:
//  Источник	- Произвольный - Источник обработки оповещения.
// Возвращаемое значение:
//  Булево - Истина, если источник является счетом-фактурой.
//
Функция ЭтоСчетФактура(Источник) Экспорт
	
	ЯвляетсяСчетомФактурой = Ложь;
	
	Результат = РезультатОпределенияВидаДокумента();
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ОпределитьВидДокумента(Источник, Результат);
	ЯвляетсяСчетомФактурой = Результат.ЯвляетсяСчетомФактурой;
		
	Возврат ЯвляетсяСчетомФактурой;

КонецФункции

// Определяет, есть ли в форме документа счет-фактура в подвале.
//
// Параметры:
//  Форма	- УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
// Возвращаемое значение:
//  Булево - Истина, есть ли в форме документа счет-фактура в подвале есть.
//
Функция ЭтоДокументСоСчетомФактуройВПодвале(Форма) Экспорт
	
	Результат = РезультатОпределенияВидаДокумента();
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ОпределитьВидДокумента(Форма, Результат);
	
	Возврат Результат.СчетФактураНаходитсяВПодвале;

КонецФункции

// Определяет, есть ли в форме документа табличные части с контрагентами.
//
// Параметры:
//  Форма	- УправляемаяФорма - Форма документа, в котором выполняется проверка контрагентов.
// Возвращаемое значение:
//  Булево - Истина, есть ли в форме документа есть табличные части с контрагентами.
//
Функция ЭтоДокументСКонтрагентомВТабличнойЧасти(Форма) Экспорт
	
	Результат = РезультатОпределенияВидаДокумента();
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ОпределитьВидДокумента(Форма, Результат);
	
	Возврат Результат.КонтрагентНаходитсяВТабличнойЧасти;

КонецФункции

// Определяет, является ли источник контрагентом.
//
// Параметры:
//  Источник - Произвольный - Источник обработки оповещения.
// Возвращаемое значение:
//   - 
//
Функция ЭтоКонтрагент(Источник) Экспорт
	
	Возврат ТипЗнч(Источник) = Тип("СправочникСсылка." + СвойстваСправочникаКонтрагенты().Имя);
	
КонецФункции

// Определяет имя колонки с признаком, корректный ли это контрагент.
//
// Параметры:
//  ТаблицаФормы - ТаблицаФормы - Таблица формы, в которой располагается колонка с контрагентом.
// Возвращаемое значение:
// Строка - Имя колонки с признаком, корректный ли это контрагент.
//
Функция ИмяПоляКартинки(ТаблицаФормы) Экспорт
	Возврат ТаблицаФормы.Имя + "ЭтоНекорректныйКонтрагент";
КонецФункции

// Подсказка в документе.
//
// Параметры:
//  ПараметрыПрорисовки	 - Структура - Параметры прорисовки результата проверки контрагента в документе.
// 		Ключи: "КонтрагентЗаполнен", "СостояниеКонтрагента", "КонтрагентовНесколько".
//  СостояниеПроверки	 - Перечисления.СостоянияПроверкиКонтрагентов - Указывает, в каком состояние проверка:
//		завершилась, не завершилась, выполняется или отсутствует доступ к веб-сервису.
// Возвращаемое значение:
//  Структура - Данные, подготовленные для отображения в форме документа.
//		Определяет цвет и текст надписи о результате проверки.
//		Ключи: "Текст", "ЦветФона".
//
Функция ПодсказкаВДокументе(ПараметрыПрорисовки, СостояниеПроверки) Экспорт
	
	КонтрагентЗаполнен	 	= ПараметрыПрорисовки.КонтрагентЗаполнен;
	СостояниеКонтрагента 	= ПараметрыПрорисовки.СостояниеКонтрагента;
	КонтрагентовНесколько 	= ПараметрыПрорисовки.КонтрагентовНесколько;
	
	ЦветФона = Новый Цвет();
	Подстроки = Новый Массив;
	
	РекламаСервиса = Новый ФорматированнаяСтрока(
		НСтр("ru = 'Проверьте контрагента по кнопке в подменю Еще'"));
	
	Если СостояниеПроверки = ПредопределенноеЗначение("Перечисление.СостоянияПроверкиКонтрагентов.ПроверкаНеИспользуется") Тогда
		// Выводим предложение на подключение.
		Подстроки.Добавить(РекламаСервиса);
	ИначеЕсли СостояниеПроверки = ПредопределенноеЗначение("Перечисление.СостоянияПроверкиКонтрагентов.ПроверкаВПроцессе") Тогда
	    // Проверка не завершилась
		Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Выполняется проверка контрагентов согласно данным ФНС'")));
													  
	ИначеЕсли СостояниеПроверки = ПредопределенноеЗначение("Перечисление.СостоянияПроверкиКонтрагентов.НетДоступаКВебСервису")
		И НЕ ЗначениеЗаполнено(СостояниеКонтрагента) Тогда
		// Нет доступа к сервису
		
		Подстроки.Добавить(Новый ФорматированнаяСтрока(НСтр("ru = 'Не удалось произвести проверку контрагентов: 
                                                      |сервис ФНС временно недоступен'")));
													  
	ИначеЕсли СостояниеПроверки = ПредопределенноеЗначение("Перечисление.СостоянияПроверкиКонтрагентов.ПроверкаВыполнена")
		ИЛИ СостояниеПроверки = ПредопределенноеЗначение("Перечисление.СостоянияПроверкиКонтрагентов.НетДоступаКВебСервису")
		И ЗначениеЗаполнено(СостояниеКонтрагента) Тогда
		// Проверка завершилась
		
		Цвета = ПроверкаКонтрагентовВызовСервераПовтИсп.ЦветаРезультатовПроверки();
		
		ЦветНекорректногоКонтрагента 	= Цвета.ЦветФонаНекорректногоКонтрагентаВДокументе;
		ЦветКорректногоКонтрагента 		= Цвета.ЦветФонаКорректногоКонтрагентаВДокументе;
		
		Если НЕ КонтрагентЗаполнен Тогда
			
			// Не заполнен контрагент
			Подстроки.Добавить(НСтр("ru = 'Проверка контрагента по базе ФНС не выполнена: не заполнен контрагент'"));
			
		ИначеЕсли НЕ ЗначениеЗаполнено(СостояниеКонтрагента) Тогда
			
			Подстроки.Добавить(РекламаСервиса);
			
		ИначеЕсли СостояниеКонтрагента = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентНеПодлежитПроверке") Тогда
			
			// Иностранный контрагент
			Подстроки.Добавить(НСтр("ru = 'Проверка контрагента по базе ФНС не выполнена: проверке подлежат только российские контрагенты'"));
			
		ИначеЕсли СостояниеКонтрагента = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустойИННИлиКПП") Тогда
			
			// Контрагенты с пустым ИНН и КПП не проверяются.
			Подстроки.Добавить(НСтр("ru = 'Не заполнен ИНН или КПП'"));
			
		ИначеЕсли ПроверкаКонтрагентовКлиентСерверПовтИсп.ЭтоСостояниеНедействующегоКонтрагента(СостояниеКонтрагента) Тогда
			
			// Недействующий контрагент
			Если КонтрагентовНесколько Тогда
				// Выводим обобщенно
				Подстроки.Добавить(НСтр("ru = 'Обнаружены недействующие контрагенты по данным ФНС'"));
			Иначе
				// Выводим конкретное состояние.
				Подстроки.Добавить(Строка(СостояниеКонтрагента));
			КонецЕсли;
			ЦветФона = ЦветНекорректногоКонтрагента; 
			
		ИначеЕсли СостояниеКонтрагента = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентСодержитОшибкиВДанных") Тогда
			
			// Контрагент с ошибками в ИНН/КПП или дате.
			// Устаревшее состояние проверки.
			Подстроки.Добавить(НСтр("ru = 'Обнаружены ошибки в заполнении ИНН, КПП или даты документа'"));
			ЦветФона = ЦветНекорректногоКонтрагента;
			
		ИначеЕсли ПроверкаКонтрагентовКлиентСерверПовтИсп.ЭтоСостояниеКонтрагентаСОшибкой(СостояниеКонтрагента) Тогда
			
			Подстроки.Добавить(Строка(СостояниеКонтрагента));
			ЦветФона = ЦветНекорректногоКонтрагента;
			
		ИначеЕсли СостояниеКонтрагента = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентЕстьВБазеФНС") Тогда
			
			// Действующий корректный контрагент.
			Если КонтрагентовНесколько Тогда
				// Выводим обобщенно 
				Подстроки.Добавить(НСтр("ru = 'Проверка контрагентов по данным ФНС выполнена успешно'"));
			Иначе
				// Выводим конкретное состояние.
				Подстроки.Добавить(Строка(СостояниеКонтрагента));
			КонецЕсли;
			ЦветФона = ЦветКорректногоКонтрагента;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Подстроки.Добавить(Символы.ПС);
	Подстроки.Добавить(ПроверкаКонтрагентовКлиентСерверПовтИсп.СсылкаНаИнструкцию());
	
	Результат = Новый Структура;
	Результат.Вставить("Текст", 	Новый ФорматированнаяСтрока(Подстроки));
	Результат.Вставить("ЦветФона",  ЦветФона);
	
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ПослеФормированияПодсказкиВДокументе(Результат, СостояниеКонтрагента, Цвета);
	
	Возврат Результат; 
		
КонецФункции

// Получение счета-фактуры, находящегося в подвале документа-основания, чья форма передана в качестве
//           параметра.
//
// Параметры:
//  Форма		 - УправляемаяФорма - Форма документа-основания, для которой необходимо получить счет-фактуру.
// Возвращаемое значение:
//  ДокументСсылка - Счет-фактура, полученная для данного документа-основания.
//
Функция СчетФактура(Форма) Экспорт
	
	СчетФактура = Неопределено;
	Если ЭтоДокументСоСчетомФактуройВПодвале(Форма) Тогда
		РаботаСКонтрагентамиКлиентСерверПереопределяемый.ПолучитьСчетФактуру(Форма, СчетФактура);
	КонецЕсли;
	
	Возврат СчетФактура;
	
КонецФункции

// Свойства справочника контрагенты.
//	Предназначена для определения имени справочника, имени реквизитов ИНН и КПП.
//
// Возвращаемое значение:
// Структура - Структура с ключами Имя, ИНН и КПП справочника контрагенты.
//
Функция СвойстваСправочникаКонтрагенты() Экспорт
	
	СвойстваСправочника = Новый Структура;
	СвойстваСправочника.Вставить("Имя");
	СвойстваСправочника.Вставить("ИНН");
	СвойстваСправочника.Вставить("КПП");
	
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ОпределитьСвойстваСправочникаКонтрагенты(СвойстваСправочника);
	
	Возврат СвойстваСправочника;
	
КонецФункции

// Вывод нужной панели проверки контрагентов в отчете.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
//	ПроверкаИспользуетсяВРазделеОтчета - Булево - Признак того, что в текущем разделе используется 
//										 		  проверка контрагентов. Если отчет не содержит разделов, 
//												  то значение игнорируется.
//
Процедура ВывестиНужнуюПанельПроверкиКонтрагентовВОтчете(Форма, ПроверкаИспользуетсяВРазделеОтчета = Истина) Экспорт

	Элементы = Форма.Элементы;

	Если Элементы.Найти("ПроверкаКонтрагента") = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаИспользуется Тогда
		
		Если Форма.РеквизитыПроверкиКонтрагентов.ЕстьДоступКВебСервисуФНС Тогда
			
			Если Форма.РеквизитыПроверкиКонтрагентов.ПроверкаВыполнялась Тогда
				
				НедействующиеКонтрагентыКоличество = Форма.РеквизитыПроверкиКонтрагентов.НедействующиеКонтрагентыКоличество;
				КонтрагентыСПустымСостояниемКоличество = Форма.РеквизитыПроверкиКонтрагентов.КонтрагентыСПустымСостояниемКоличество;

				Если Форма.РеквизитыПроверкиКонтрагентов.ОтчетСРазделами И НЕ ПроверкаИспользуетсяВРазделеОтчета Тогда	
					// В  текущем разделе отчета проверка не используется.
					УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма);
				ИначеЕсли НедействующиеКонтрагентыКоличество = 0 Тогда 
					УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, "ВсеКонтрагентыКорректные");
				ИначеЕсли НедействующиеКонтрагентыКоличество > 0 И КонтрагентыСПустымСостояниемКоличество = НедействующиеКонтрагентыКоличество Тогда
					// Ни один контрагенты не проверен.
					УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, "НетДоступаКСервису");
				ИначеЕсли НедействующиеКонтрагентыКоличество > 0 Тогда
					// Контрагенты проверены
					УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, "НайденыНекорректныеКонтрагенты");
				КонецЕсли;
				
			Иначе
				// Проверка не выполнилась, например, потому что в отчете не было ни одной записи, или проверка просто еще не закончилась.
				Если Элементы.ПроверкаКонтрагента.ТекущаяСтраница <> Элементы.ПроверкаВПроцессеВыполнения Тогда
					УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма);
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			 УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма, "НетДоступаКСервису");
		КонецЕсли;
		
	Иначе
		УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма);
	КонецЕсли;

КонецПроцедуры

// Параметры фонового задания.
//
// Параметры:
//  Параметр		 - Структура - Если изменения произошли в табличной части. 
//		В записи с ключем ИмяТаблицы указывается ИмяТаблицы, в записи с ключем Идентификатор указывается Идентификатор
//		строки,  в которой произошло изменение контрагента или даты.
//					- Строка - Имя элемента управления формы, в случае если произошло изменение в контрагенте, находящегося в шапке.
//					- Дата - Дата документа, в случае если произошло изменение даты.
//					- ТаблицаФормы - Если изменения произошли в табличной части.
//					- ПолеФормы - Если изменился контрагент в определенном поле произошли в табличной части.
//					- СправочникСсылка.<Контрагенты> - Если произошла запись контрагента и сработало оповещение.
//					- ДокументСсылка.<СчетФактура> - Если произошла запись счета-фактуры и сработало оповещение.
//					- Булево - определяет, нужно ли сохранять результат проверки 
//		сразу в фоновом задании или после выхода из него.
//  Результат	 - 	 - 
// Возвращаемое значение:
//   - 
//
Функция ПараметрыФоновогоЗадания(Параметр, Знач Результат = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Результат = Новый Структура();
	КонецЕсли;
	
	Если ТипЗнч(Параметр) = Тип("Структура") Тогда
		
		Результат = Параметр;
	
	ИначеЕсли ТипЗнч(Параметр) = Тип("ТаблицаФормы") Тогда 
		
		ИмяТаблицы 		= Параметр.Имя;
		Идентификатор 	= Параметр.ТекущиеДанные.ПолучитьИдентификатор();
		
		СвойстваТаблицы = Новый Структура();
		СвойстваТаблицы.Вставить("ИмяТаблицы", 	ИмяТаблицы);
		СвойстваТаблицы.Вставить("Идентификатор", Идентификатор);
		
		// Сохраняем структуру, так как с клиента на сервер нельзя передавать таблицу.
		Результат.Вставить("ИзменившаясяТаблица", СвойстваТаблицы);
		
	ИначеЕсли ТипЗнч(Параметр) = Тип("ПолеФормы") Тогда
		
		// Сохраняем имя, так как с клиента на сервер нельзя передавать поле.
		Результат.Вставить("ИзменившеесяПоле", Параметр.Имя); 
		
	ИначеЕсли ЭтоКонтрагент(Параметр) Тогда
		
		Результат.Вставить("ИзменившийсяКонтрагент", Параметр);
		
	ИначеЕсли ТипЗнч(Параметр) = Тип("Дата") Тогда
		
		Результат.Вставить("ИзменившаясяДата", Параметр);
		
	ИначеЕсли ТипЗнч(Параметр) = Тип("Булево") Тогда
	
		Результат.Вставить("СохранятьРезультатСразуПослеПроверки", Параметр);
		
	ИначеЕсли ТипЗнч(Параметр) = Тип("Строка") Тогда
		
		// Ничего не делаем
		
	ИначеЕсли ЭтоСчетФактура(Параметр) Тогда
		
		Результат.Вставить("ИзменившийсяСчетФактура", Параметр);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Получение объекта (ДанныеФормыСтруктура) и ссылки(ДокументСсылка, СправочникСсылка) документа или
//           справочника,  в котором выполняется проверка контрагента, по форме.
// 		Обязательна к заполнению.
// Параметры:
//  Форма		 - УправляемаяФорма - Форма документа или справочника, в котором выполняется проверка контрагента.
// Возвращаемое значение:
//  Структура - Объект и Ссылка, полученные по форме документа.
//		Ключи: "Объект" (Тип ДанныеФормыСтруктура) и "Ссылка" (Тип ДокументСсылка, СправочникСсылка).
Функция ОбъектИСсылкаПоФорме(Форма) Экспорт
	
	Результат = Новый Структура("Объект, Ссылка");
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ПолучитьОбъектИСсылкуПоФорме(Форма, Результат);
	
	Возврат Результат;
	
КонецФункции

// Отображение результата проверки контрагента в справочнике.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Карточка проверяемого контрагента.
Процедура ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма) Экспорт
	
	ПредставлениеРезультатаПроверки = ПредставлениеРезультатаПроверкиКонтрагента(Форма);
	
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ОтобразитьРезультатПроверкиКонтрагентаВСправочнике(Форма, ПредставлениеРезультатаПроверки);
	
КонецПроцедуры

// Сброс актуальности, сброс вида панели проверки контрагентов при изменении отборов отчета.
//
// Параметры:
//  Форма	 - УправляемаяФорма - Форма отчета, в котором выполняется проверка контрагентов.
Процедура СброситьАктуальностьОтчета(Форма) Экспорт
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Форма.Элементы.Результат, "НеАктуальность");
	УстановитьВидПанелиПроверкиКонтрагентовВОтчете(Форма);

КонецПроцедуры

#КонецОбласти

#Область ВспомогательныеПроцедурыИФункции

Процедура ПредотвратитьСбросРедактируемогоЗначения(Форма) Экспорт
	
	// Обход особенности платформы, когда затирается редактируемое значение
	// в текущем элементе при изменении формы.
	Если НЕ ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ПолеФормы") И Форма.ТекущийЭлемент.Вид = ВидПоляФормы.ПолеВвода Тогда
			Форма.ТекущийЭлемент.ОбновлениеТекстаРедактирования = ОбновлениеТекстаРедактирования.ПриИзмененииЗначения;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Функция ВидДокумента(Форма) Экспорт
	
	Результат = РезультатОпределенияВидаДокумента();
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ОпределитьВидДокумента(Форма, Результат);
	
	Возврат Результат;

КонецФункции

Функция ПрерватьПроверкуКонтрагентовИзЗаОшибокПредварительнойПроверки(Форма, ДополнительныеПараметрыПроверки) Экспорт
	
	ВыполнятьПредварительнуюПроверку = 
		Форма.РеквизитыПроверкиКонтрагентов.ВыполнятьПредварительнуюПроверкуКонтрагента
		И Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоЮридическоеЛицо")
		И Форма.РеквизитыПроверкиКонтрагентов.Свойство("ЭтоИностранныйКонтрагент");
		
	Если НЕ ВыполнятьПредварительнуюПроверку Тогда
		Возврат Ложь;
	КонецЕсли;
	
	// Не проверяем иностранных контрагентов.
	ЭтоИностранныйКонтрагент 	= Форма.РеквизитыПроверкиКонтрагентов.ЭтоИностранныйКонтрагент = Истина; // Может быть незаполненным
	НайденыОшибки 				= Ложь;
	
	СвойстваСправочникаКонтрагенты = СвойстваСправочникаКонтрагенты();

	// Определение объекта и ссылки.
	ОбъектИСсылкаПоФорме 	= ОбъектИСсылкаПоФорме(Форма);
	КонтрагентОбъект 		= ОбъектИСсылкаПоФорме.Объект;
	КонтрагентСсылка 		= ОбъектИСсылкаПоФорме.Ссылка;
	
	ДанныеКонтрагента = Новый Структура;
	ДанныеКонтрагента.Вставить("Контрагент",			КонтрагентСсылка);
	ДанныеКонтрагента.Вставить("ИНН", 					СокрЛП(КонтрагентОбъект[СвойстваСправочникаКонтрагенты.ИНН]));
	ДанныеКонтрагента.Вставить("КПП", 					СокрЛП(КонтрагентОбъект[СвойстваСправочникаКонтрагенты.КПП]));
	ДанныеКонтрагента.Вставить("Дата", 					Неопределено);
	ДанныеКонтрагента.Вставить("Состояние",				ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка"));
	ДанныеКонтрагента.Вставить("ЭтоЮридическоеЛицо", 	Форма.РеквизитыПроверкиКонтрагентов.ЭтоЮридическоеЛицо);
	
	Если ЭтоИностранныйКонтрагент Тогда
		
		КонтрагентНеПодлежитПроверке = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентНеПодлежитПроверке");
		
		Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента = КонтрагентНеПодлежитПроверке;
		ДанныеКонтрагента.Вставить("Состояние", КонтрагентНеПодлежитПроверке);

	Иначе
	
		// Предварительная проверка
		НайденыОшибки = НайденыОшибкиВДанных(ДанныеКонтрагента, ДополнительныеПараметрыПроверки);
		
			// Сохранение результатов проверки
		Если НайденыОшибки Тогда
			
			// Сохранение результата в реквизит.
			Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента = ДанныеКонтрагента.Состояние;
			
		КонецЕсли;
		
	КонецЕсли;
		
	Если НайденыОшибки ИЛИ ЭтоИностранныйКонтрагент Тогда
		
		// Сохранение результата в регистр.
		// Вы эту ветку зайдет только если проверка выполняется на сервере.
		Если ДополнительныеПараметрыПроверки.Свойство("СохранятьРезультатСразуПослеПроверки")
			И ДополнительныеПараметрыПроверки.СохранятьРезультатСразуПослеПроверки Тогда

			ПроверкаКонтрагентовВызовСервера.ЗапомнитьРезультатПроверкиСправочникаПослеПредварительнойПроверки(ДанныеКонтрагента, ДополнительныеПараметрыПроверки);
				
		КонецЕсли;

	КонецЕсли;
	
	Возврат НайденыОшибки ИЛИ ЭтоИностранныйКонтрагент;
	
КонецФункции

Функция НайденыОшибкиВДанных(ДанныеКонтрагента, ДополнительныеПараметрыПроверки = Неопределено) Экспорт
	
	Если НЕ ДатаКорректная(ДанныеКонтрагента, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;

	Если НайденыОшибкиВИНН(ДанныеКонтрагента, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НайденыОшибкиВКПП(ДанныеКонтрагента, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция НайденыОшибкиВИНН(ДанныеКонтрагента, ДополнительныеПараметрыПроверки = Неопределено)
	
	// Отчет не проверяется предварительной проверкой.
	// Отчет проверяется веб-сервисом с целью увеличения скорости проверки.
	ЭтоПроверкаОтчета = ТипЗнч(ДополнительныеПараметрыПроверки) = Тип("Структура")
		И ДополнительныеПараметрыПроверки.Свойство("ЭтоПроверкаОтчета");
		
	ЭтоЮридическоеЛицо = ДанныеКонтрагента.ЭтоЮридическоеЛицо = Истина ИЛИ НЕ ЗначениеЗаполнено(ДанныеКонтрагента.ЭтоЮридическоеЛицо); // Может быть незаполненным
	
	Если ИННИПустой(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЭтоПроверкаОтчета И НевернаяДлинаИНН(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
		
	Если НЕ ЭтоПроверкаОтчета И ЕстьНедопустимыеСимволыВИНН(ДанныеКонтрагента, ДополнительныеПараметрыПроверки)Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЭтоПроверкаОтчета И ИНННекорректный(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция НайденыОшибкиВКПП(ДанныеКонтрагента, ДополнительныеПараметрыПроверки = Неопределено)
	
	// Отчет не проверяется предварительной проверкой.
	// Отчет проверяется веб-сервисом с целью увеличения скорости проверки.
	ЭтоПроверкаОтчета = ТипЗнч(ДополнительныеПараметрыПроверки) = Тип("Структура")
		И ДополнительныеПараметрыПроверки.Свойство("ЭтоПроверкаОтчета");
		
	ЭтоЮридическоеЛицо = ДанныеКонтрагента.ЭтоЮридическоеЛицо = Истина ИЛИ НЕ ЗначениеЗаполнено(ДанныеКонтрагента.ЭтоЮридическоеЛицо); // Может быть незаполненным
		
	Если НЕ ЭтоПроверкаОтчета И ЭтоИПСКПП(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если ЭтоЮридическоеЛицо И КПППустой(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЭтоПроверкаОтчета И НевернаяДлинаКПП(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Если НЕ ЭтоПроверкаОтчета И ЕстьНедопустимыеСимволыВКПП(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ДатаКорректная(ДанныеКонтрагента, ДополнительныеПараметрыПроверки = Неопределено)
	
	// Если в документе будущая дата, то проверяем на текущую, иначе документы
	// с будущей датой подкрасятся красным, что не верно.
	ЭтоПроверкаДокумента = ТипЗнч(ДополнительныеПараметрыПроверки) = Тип("Структура")
		И ДополнительныеПараметрыПроверки.Свойство("ЭтоПроверкаДокумента");
	
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	ТекущаяДата = ТекущаяДатаСеанса();
#Иначе
	ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
#КонецЕсли

	Если Не ЗначениеЗаполнено(ДанныеКонтрагента.Дата) 
		ИЛИ ЭтоПроверкаДокумента И ДанныеКонтрагента.Дата > КонецДня(ТекущаяДата) Тогда
		ДанныеКонтрагента.Дата = НачалоДня(ТекущаяДата);
	ИначеЕсли ТипЗнч(ДанныеКонтрагента.Дата) = Тип("Дата") 
		И (ДанныеКонтрагента.Дата < Дата(1991, 1, 1) ИЛИ ДанныеКонтрагента.Дата > КонецДня(ТекущаяДата)) Тогда
		ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НевернаяДата");
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

Процедура ПроверитьКонтрагентаИзКарточки(Форма, СохранятьРезультатСразуПослеПроверки) Экспорт
	
	СвойстваСправочникаКонтрагенты = СвойстваСправочникаКонтрагенты();

	// Определение объекта и ссылки.
	ОбъектИСсылкаПоФорме 	= ОбъектИСсылкаПоФорме(Форма);
	КонтрагентОбъект 		= ОбъектИСсылкаПоФорме.Объект;
	КонтрагентСсылка 		= ОбъектИСсылкаПоФорме.Ссылка;
	
	ИНН = КонтрагентОбъект[СвойстваСправочникаКонтрагенты.ИНН];
	КПП = КонтрагентОбъект[СвойстваСправочникаКонтрагенты.КПП];
	
	Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища 			= ПоместитьВоВременноеХранилище(Неопределено, Форма.УникальныйИдентификатор);
	Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента 	= ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустаяСсылка");
	Форма.РеквизитыПроверкиКонтрагентов.ФоновоеЗаданиеЗапущено 	= Истина;
	
	// Запуск фонового задания для проверки контрагента.
	ПараметрыЗапуска = Новый Структура;
	ПараметрыЗапуска.Вставить("Контрагент", 							КонтрагентСсылка);
	ПараметрыЗапуска.Вставить("ИНН", 									ИНН);
	ПараметрыЗапуска.Вставить("КПП", 									КПП);
	ПараметрыЗапуска.Вставить("АдресХранилища", 						Форма.РеквизитыПроверкиКонтрагентов.АдресХранилища);
	ПараметрыЗапуска.Вставить("ДополнительныеПараметры", 				Новый Структура);
	ПараметрыЗапуска.Вставить("СохранятьРезультатСразуПослеПроверки", 	СохранятьРезультатСразуПослеПроверки);
	ПараметрыЗапуска.Вставить("ВыполнятьПредварительнуюПроверкуКонтрагента", 
		Форма.РеквизитыПроверкиКонтрагентов.ВыполнятьПредварительнуюПроверкуКонтрагента);
	ПараметрыЗапуска.Вставить("ЭтоЮридическоеЛицо", 					Форма.РеквизитыПроверкиКонтрагентов.ЭтоЮридическоеЛицо);
	ПараметрыЗапуска.Вставить("ЭтоИностранныйКонтрагент", 				Форма.РеквизитыПроверкиКонтрагентов.ЭтоИностранныйКонтрагент);
	
	РаботаСКонтрагентамиКлиентСерверПереопределяемый.ДополнитьПараметрыЗапускаФоновогоЗадания(ПараметрыЗапуска.ДополнительныеПараметры, Форма);
	
	ПроверкаКонтрагентовВызовСервера.ПроверитьКонтрагентаПриИзменении(ПараметрыЗапуска);
	
КонецПроцедуры

Функция РезультатОпределенияВидаДокумента()
	
	Параметры = Новый Структура;
	
	Параметры.Вставить("КонтрагентНаходитсяВШапке", 			Ложь);
	Параметры.Вставить("КонтрагентНаходитсяВТабличнойЧасти", 	Ложь);
	Параметры.Вставить("СчетФактураНаходитсяВПодвале", 			Ложь);
	Параметры.Вставить("ЯвляетсяСчетомФактурой", 				Ложь);
	
	Возврат Параметры;
	
КонецФункции

Функция ПредставлениеРезультатаПроверкиКонтрагента(Форма)
	
	СостояниеКонтрагента = Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента;
	
	Результат = "";
	
	Если СостояниеКонтрагента <> ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентСодержитОшибкиВДанных")
		И СостояниеКонтрагента <> ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентНеПодлежитПроверке") 
		И СостояниеКонтрагента <> ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустойИННИлиКПП") Тогда
		
		ЦветТекста 			= ЦветНадписиРезультатаПроверкиПоСостояниюКонтрагента(СостояниеКонтрагента);
		СтрокаСРезультатом  = СтрокаСРезультатомПроверкиКонтрагента(Форма);
		
		// Формируем строку
		МассивПодстрок = Новый Массив;
		МассивПодстрок.Добавить(Новый ФорматированнаяСтрока(
			СтрокаСРезультатом,,
			ЦветТекста,, 
			ПроверкаКонтрагентовКлиентСерверПовтИсп.ПутьКИнструкции()));
		
		Результат = Новый ФорматированнаяСтрока(МассивПодстрок);
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

Функция СтрокаСРезультатомПроверкиКонтрагента(Форма)
	
	СостояниеКонтрагента 			= Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента;
	СвойстваСправочникаКонтрагенты 	= СвойстваСправочникаКонтрагенты();

	// Определение объекта и ссылки.
	ОбъектИСсылкаПоФорме 	= ОбъектИСсылкаПоФорме(Форма);
	КонтрагентОбъект 		= ОбъектИСсылкаПоФорме.Объект;
	
	ДлинаИНН = СтрДлина(КонтрагентОбъект[СвойстваСправочникаКонтрагенты.ИНН]);
	ЭтоФизическоеЛицо = ДлинаИНН = 12;
	
	СостояниеКонтрагента = Форма.РеквизитыПроверкиКонтрагентов.СостояниеКонтрагента;
	
	Если ЭтоФизическоеЛицо 
		И СостояниеКонтрагента = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП") Тогда
		СтрокаСРезультатом = НСтр("ru = 'Не действует'");
	Иначе
		СтрокаСРезультатом = Строка(СостояниеКонтрагента);
	КонецЕсли;
	
	Возврат СтрокаСРезультатом;
	
КонецФункции

Функция ЦветНадписиРезультатаПроверкиПоСостояниюКонтрагента(СостояниеКонтрагента)
	
	Цвета = ПроверкаКонтрагентовВызовСервераПовтИсп.ЦветаРезультатовПроверки();
	
	Если СостояниеКонтрагента = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеДействуетИлиИзмененКПП") Тогда
		ЦветТекста = Цвета.ЦветТекстаКонтрагентаПрекратившегоДеятельность;
	ИначеЕсли СостояниеКонтрагента = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.КонтрагентЕстьВБазеФНС") Тогда
		ЦветТекста = Цвета.ЦветТекстаКонтрагентаДействующего;
	Иначе
		ЦветТекста = Цвета.ЦветТекстаНекорректногоКонтрагента;
	КонецЕсли;
	
	Возврат ЦветТекста;
	
КонецФункции

Функция ИНННекорректный(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки = Неопределено)
	
	Ошибка = "";

	ИННСоответствуетТребованиям = РегламентированныеДанныеКлиентСервер.ИННСоответствуетТребованиям(ДанныеКонтрагента.ИНН, ЭтоЮридическоеЛицо, Ошибка);
	Если НЕ ИННСоответствуетТребованиям Тогда
		
		ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НеверныйИНН");
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьНедопустимыеСимволыВИНН(ДанныеКонтрагента, ДополнительныеПараметрыПроверки = Неопределено)
	
	Если НЕ СтроковыеФункцииКлиентСервер.ТолькоЦифрыВСтроке(ДанныеКонтрагента.ИНН) Тогда
		ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НедопустимыеСимволыВИНН");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ЕстьНедопустимыеСимволыВКПП(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки = Неопределено)
	
	Ошибка = "";
	
	Если ЭтоЮридическоеЛицо Тогда
		
		КППСоответствуетТребованиям = РегламентированныеДанныеКлиентСервер.КППСоответствуетТребованиям(ДанныеКонтрагента.КПП, Ошибка);
		Если НЕ КППСоответствуетТребованиям Тогда
			ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НедопустимыеСимволыВКПП");
			Возврат Истина;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция НевернаяДлинаИНН(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки = Неопределено)
	
	ДлинаИНН = СтрДлина(СокрЛП(ДанныеКонтрагента.ИНН));
	
	Если ЭтоЮридическоеЛицо И ДлинаИНН <> 10
		ИЛИ НЕ ЭтоЮридическоеЛицо И ДлинаИНН <> 12 Тогда
		
			ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НевернаяДлинаИНН");
			Возврат Истина;
		
	КонецЕсли;
		
	Возврат Ложь;
	
КонецФункции
	
Функция НевернаяДлинаКПП(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки = Неопределено)
	
	ДлинаКПП = СтрДлина(СокрЛП(ДанныеКонтрагента.КПП));
	
	Если ЭтоЮридическоеЛицо И ДлинаКПП <> 9 Тогда
		
		ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.НевернаяДлинаКПП");
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ЭтоИПСКПП(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки = Неопределено)
	
	ДлинаКПП = СтрДлина(СокрЛП(ДанныеКонтрагента.КПП));

	Если НЕ ЭтоЮридическоеЛицо И ДлинаКПП <> 0 Тогда
		
		ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ИПНеМожетИметьКПП");
		Возврат Истина;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция ИННИПустой(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки = Неопределено)
	
	ДлинаИНН = СтрДлина(СокрЛП(ДанныеКонтрагента.ИНН));

	Если ДлинаИНН = 0  Тогда
		ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустойИННИлиКПП");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

Функция КПППустой(ДанныеКонтрагента, ЭтоЮридическоеЛицо, ДополнительныеПараметрыПроверки = Неопределено)
	
	ДлинаКПП = СтрДлина(СокрЛП(ДанныеКонтрагента.КПП));

	Если ЭтоЮридическоеЛицо И ДлинаКПП = 0 Тогда
		ДанныеКонтрагента.Состояние = ПредопределенноеЗначение("Перечисление.СостоянияСуществованияКонтрагента.ПустойИННИлиКПП");
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти