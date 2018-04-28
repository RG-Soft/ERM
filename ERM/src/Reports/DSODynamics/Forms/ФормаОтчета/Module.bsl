#Область ОписаниеПеременных

&НаКлиенте
Перем ПараметрыОбработчикаОжидания; 

#КонецОбласти

#Область Период

&НаКлиенте
Процедура ПериодПриИзменении(Элемент)
	
	ПриИзмененииПериода();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииПериода()
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ПериодDSO");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = Период;
	КонецЕсли;
	
	ИнициализироватьНастройкиСКД();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Период) Тогда
		ТекДата = ТекущаяДата();
		Период = Новый СтандартныйПериод(НачалоМесяца(ДобавитьМесяц(ТекДата, -4)), НачалоМесяца(ТекДата) - 1);
	КонецЕсли;
	
	ОтчетОбъект = РеквизитФормыВЗначение("Отчет");
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(ОтчетОбъект.СхемаКомпоновкиДанных, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ПериодDSO");
	
	Если Параметр <> Неопределено И ЗначениеЗаполнено(Параметр.Значение) Тогда
		Период = Параметр.Значение;
	КонецЕсли;
	
	ПриИзмененииПериода();
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеВариантаНаСервере(Настройки)
	
	Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ПериодDSO");
	
	Если Параметр <> Неопределено Тогда
		Параметр.Использование = Истина;
		Параметр.Значение      = Период;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	
	ОчиститьСообщения();
	
	ОтключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания");
	
	РезультатВыполнения = СформироватьОтчетНаСервере();
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "ФормированиеОтчета");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СформироватьОтчетНаСервере()
	
	Если Не ПроверитьЗаполнение() Тогда
		Возврат Новый Структура("ЗаданиеВыполнено, ОтказПроверкиЗаполнения", Истина, Истина);
	КонецЕсли;
	
	ИБФайловая = ОбщегоНазначения.ИнформационнаяБазаФайловая();
	
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
	ПараметрыОтчета = ПодготовитьПараметрыОтчета();
	
//	Если ИБФайловая Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ОтчетыВызовСервера.СформироватьОтчет(ПараметрыОтчета, АдресХранилища);
		РезультатВыполнения = Новый Структура("ЗаданиеВыполнено", Истина);
//	Иначе
//		НаименованиеЗадания = НСтр("ru = 'Формирование отчета DSO dynamics'");
//		РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
//			УникальныйИдентификатор, 
//			"ОтчетыВызовСервера.СформироватьОтчет", 
//			ПараметрыОтчета, 
//			НаименованиеЗадания);
//			
//		АдресХранилища       = РезультатВыполнения.АдресХранилища;
//		ИдентификаторЗадания = РезультатВыполнения.ИдентификаторЗадания;
//	КонецЕсли;
	
	Если РезультатВыполнения.ЗаданиеВыполнено Тогда
		ЗагрузитьПодготовленныеДанные();
	КонецЕсли;
	
	Элементы.СформироватьОтчет.КнопкаПоУмолчанию = Истина;
	
	Возврат РезультатВыполнения;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПодготовитьПараметрыОтчета()
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("Период"                           , Период);
	ПараметрыОтчета.Вставить("ДанныеРасшифровки"                , ДанныеРасшифровки);
	ПараметрыОтчета.Вставить("СхемаКомпоновкиДанных"            , ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных));
	ПараметрыОтчета.Вставить("ИдентификаторОтчета"              , "DSODynamics");
	ПараметрыОтчета.Вставить("НастройкиКомпоновкиДанных"        , Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	
	Возврат ПараметрыОтчета;
	
КонецФункции

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	
	Попытка
		Если ЗаданиеВыполнено(ИдентификаторЗадания) Тогда 
			ЗагрузитьПодготовленныеДанные();
			ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		Иначе
			ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			ПодключитьОбработчикОжидания(
				"Подключаемый_ПроверитьВыполнениеЗадания", 
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
				Истина);
		КонецЕсли;
	Исключение
		ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПодготовленныеДанные()

	РезультатВыполнения = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Результат = РезультатВыполнения.Результат;	

	ДанныеРасшифровки = РезультатВыполнения.ДанныеРасшифровки;
	
	ИдентификаторЗадания = Неопределено;
	
	ОбщегоНазначенияКлиентСервер.УстановитьСостояниеПоляТабличногоДокумента(Элементы.Результат, "НеИспользовать");
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
	
КонецФункции

&НаСервере
Процедура ИнициализироватьНастройкиСКД()
	
	ПараметрПериодDSO = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "ПериодDSO");
	Запрос = Новый Запрос();
	Запрос.Текст =
	"ВЫБРАТЬ
	|	РАЗНОСТЬДАТ(&Дата1, &Дата2, МЕСЯЦ) КАК КоличествоМесяцев";
	Запрос.УстановитьПараметр("Дата1", ПараметрПериодDSO.Значение.ДатаНачала);
	Запрос.УстановитьПараметр("Дата2", ПараметрПериодDSO.Значение.ДатаОкончания);
	Выборка = Запрос.Выполнить().Выбрать();
	Выборка.Следующий();
	ГлубинаDSO = 24 + Выборка.КоличествоМесяцев;
	
	СКД = ПолучитьИзВременногоХранилища(СхемаКомпоновкиДанных);
	НаборДанных = СКД.НаборыДанных[0];
	
	НаборДанных.Запрос = Отчеты.DSODynamics.ПолучитьТекстЗапроса(ГлубинаDSO);
	
	ЗаполнитьПоляНабора(НаборДанных, ПараметрПериодDSO.Значение.ДатаОкончания, ГлубинаDSO);
	
	ДобавитьВычисляемыеПоля(СКД, ПараметрПериодDSO.Значение.ДатаОкончания, Выборка.КоличествоМесяцев);
	ДобавитьРесурсы(СКД, ГлубинаDSO);
	
	СхемаКомпоновкиДанных = ПоместитьВоВременноеХранилище(СКД, УникальныйИдентификатор);
	
	Отчет.КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	
	УстановитьПараметрыОтчета(ПараметрПериодDSO.Значение.ДатаНачала, ПараметрПериодDSO.Значение.ДатаОкончания, ГлубинаDSO);
	ДобавитьРесурсыВПоляВыбора(ГлубинаDSO);
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоляНабора(НаборДанных, КонецПериода, ГлубинаDSO)
	
	Для ТекУровень = 0 По ГлубинаDSO Цикл
		
		УровеньСтрокой = Формат(ТекУровень, "ЧН=0; ЧГ=0");
		
		Для ВложенныйУровень = 0 По ГлубинаDSO - 24 Цикл
			
			ВложенныйУровеньСтрокой = Формат(ВложенныйУровень, "ЧН=0; ЧГ=0");

			ИмяРесурса = "Billing" + УровеньСтрокой + "_" + ВложенныйУровеньСтрокой;
			
			Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
			Поле.Поле = ИмяРесурса;
			Поле.ПутьКДанным = ИмяРесурса;
			Поле.Заголовок = СтрШаблон("Billing %1 (rate %2)", Формат(ДобавитьМесяц(КонецПериода, -ТекУровень), "ДФ=MM.yyyy"), Формат(ДобавитьМесяц(КонецПериода, -ВложенныйУровень), "ДФ=MM.yyyy"));
			
		КонецЦикла;
		
	КонецЦикла;
	
	Для Смещение = 0 По ГлубинаDSO - 24 Цикл
		
		СмещениеСтрокой = Формат(Смещение, "ЧН=0; ЧГ=0");
		
		Поле = НаборДанных.Поля.Добавить(Тип("ПолеНабораДанныхСхемыКомпоновкиДанных"));
		Поле.Поле = "AR" + СмещениеСтрокой;
		Поле.ПутьКДанным = "AR" + СмещениеСтрокой;
		Поле.Заголовок = "AR " + Формат(ДобавитьМесяц(КонецПериода, -Смещение), "ДФ=MM.yyyy");
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРесурсы(СКД, ГлубинаDSO)
	
	Для ТекУровень = 0 По ГлубинаDSO Цикл
		
		УровеньСтрокой = Формат(ТекУровень, "ЧН=0; ЧГ=0");
		
		Для ВложенныйУровень = 0 По ГлубинаDSO - 24 Цикл
			
			ВложенныйУровеньСтрокой = Формат(ВложенныйУровень, "ЧН=0; ЧГ=0");

			ИмяРесурса = "Billing" + УровеньСтрокой + "_" + ВложенныйУровеньСтрокой;
			
			Если СКД.ПоляИтога.Найти(ИмяРесурса) <> Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			ПолеBilling = СКД.ПоляИтога.Добавить();
			ПолеBilling.ПутьКДанным = ИмяРесурса;
			ПолеBilling.Выражение = "Сумма(" + ИмяРесурса + ")";
			
		КонецЦикла;
		
	КонецЦикла;
	
	Для Смещение = 0 По ГлубинаDSO - 24 Цикл
		
		СмещениеСтрокой = Формат(Смещение, "ЧН=0; ЧГ=0");
		
		ИмяПоляAR = СтрШаблон("AR%1", СмещениеСтрокой);
		Если СКД.ПоляИтога.Найти(ИмяПоляAR) = Неопределено Тогда
			ПолеAR = СКД.ПоляИтога.Добавить();
			ПолеAR.ПутьКДанным = ИмяПоляAR;
			ПолеAR.Выражение = СтрШаблон("СУММА(AR%1)", СмещениеСтрокой);
		КонецЕсли;
		
		ИмяПоляDSO = "DSO_" + Смещение;
		Если СКД.ПоляИтога.Найти(ИмяПоляDSO) = Неопределено Тогда
			ПолеDSO = СКД.ПоляИтога.Добавить();
			ПолеDSO.ПутьКДанным = ИмяПоляDSO;
			ПолеDSO.Выражение = "rgsРасчетПоказателей.РассчитатьDSO(СУММА(AR" + СмещениеСтрокой + "), &ТекПериод" + СмещениеСтрокой + ", СУММА(Billing" + Формат(0 + Смещение, "ЧН=0; ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(1 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(2 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(3 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(4 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(5 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(6 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(7 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(8 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(9 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(10 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(11 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(12 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(13 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(14 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(15 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(16 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(17 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(18 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(19 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(20 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(21 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(22 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(23 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "), СУММА(Billing" + Формат(24 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + "))";
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьВычисляемыеПоля(СКД, КонецПериода, КоличествоМесяцев)
	
	Если СКД.ВычисляемыеПоля.Найти("BU") = Неопределено Тогда
		
		ПолеBU = СКД.ВычисляемыеПоля.Добавить();
		ПолеBU.ПутьКДанным = "BU";
		ПолеBU.Выражение = "rgsКонсолидацияДанныхСервер.ОпределитьBU(GeoMarket, SubGeoMarket, MgmtGeomarket, Segment, SubSegment, Company, AU)";
		ПолеBU.Заголовок = "BU";
		ПолеBU.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.BusinessUnits");
		
	КонецЕсли;
	
	Для Смещение = 0 По КоличествоМесяцев Цикл
		
		СмещениеСтрокой = Формат(Смещение, "ЧН=0; ЧГ=0");
		
		ИмяПоляDSO = "DSO_" + Смещение;
		ПолеDSO = СКД.ВычисляемыеПоля.Найти(ИмяПоляDSO); 
		Если ПолеDSO = Неопределено Тогда
			ПолеDSO = СКД.ВычисляемыеПоля.Добавить();
			ПолеDSO.ПутьКДанным = ИмяПоляDSO;
			ПолеDSO.Выражение = "rgsРасчетПоказателей.РассчитатьDSO(AR" + СмещениеСтрокой + ", &ТекПериод" + СмещениеСтрокой +", Billing" + Формат(0 + Смещение, "ЧН=0; ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(1 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(2 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(3 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(4 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(5 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(6 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(7 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(8 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(9 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(10 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(11 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(12 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(13 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(14 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(15 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(16 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(17 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(18 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(19 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(20 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(21 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(22 + Смещение, "ЧГ=0")
				+ "_" + СмещениеСтрокой + ", Billing" + Формат(23 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ", Billing" + Формат(24 + Смещение, "ЧГ=0") + "_" + СмещениеСтрокой + ")";
			ПолеDSO.ТипЗначения = Новый ОписаниеТипов("Число", , , Новый КвалификаторыЧисла(15, 2));
		КонецЕсли;
		ПолеDSO.Заголовок = "DSO " + Формат(ДобавитьМесяц(КонецПериода, -Смещение), "ДФ=MM.yyyy");
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыОтчета(ДатаНачала, ДатаОкончания, ГлубинаDSO)
	
	ПараметрПериод = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, "Период");
	
	Если ПараметрПериод <> Неопределено Тогда
		ПараметрПериод.Использование = Истина;
		ПараметрПериод.Значение      = КонецМесяца(ДатаОкончания);
	КонецЕсли;
	
	Для НомерПериода = 0 По ГлубинаDSO Цикл
		
		ИмяПараметра = "ТекПериод" + Формат(НомерПериода, "ЧН=0; ЧГ=0");
		
		Параметр = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, ИмяПараметра);
		
		Если Параметр <> Неопределено Тогда
			Параметр.Использование = Истина;
			Параметр.Значение      = ДобавитьМесяц(НачалоМесяца(ДатаОкончания), -НомерПериода);
			//Параметр.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		
	КонецЦикла;
	
	Для НомерПериода = 0 По ГлубинаDSO - 24 Цикл
		
		ИмяПараметра = "ПериодОстатков" + Формат(НомерПериода, "ЧН=0; ЧГ=0");
		
		ПараметрПериодОстатков = ОтчетыКлиентСервер.НайтиПараметр(Отчет.КомпоновщикНастроек.Настройки, Отчет.КомпоновщикНастроек.ПользовательскиеНастройки, ИмяПараметра);
		
		Если ПараметрПериодОстатков <> Неопределено Тогда
			ПараметрПериодОстатков.Использование = Истина;
			ПараметрПериодОстатков.Значение      = ДобавитьМесяц(КонецМесяца(ДатаОкончания) + 1, -НомерПериода);
			//ПараметрПериодОстатков.РежимОтображения = РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьРесурсыВПоляВыбора(ГлубинаDSO)
	
	ВыбранныеПоля = Отчет.КомпоновщикНастроек.Настройки.Выбор.Элементы;
	
	МассивВыбранныхПолей = Новый Массив;
	
	Для Каждого ВыбранноеПоле Из ВыбранныеПоля Цикл
		МассивВыбранныхПолей.Добавить(ВыбранноеПоле);
	КонецЦикла;
	
	ВыбранныеПоля.Очистить();
	
	Для Каждого ВыбранноеПоле Из МассивВыбранныхПолей Цикл
		Если СтрНачинаетсяС(ВыбранноеПоле.Поле, "DSO") Тогда
			Продолжить;
		КонецЕсли;
		ПолеВыбора = ВыбранныеПоля.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ЗаполнитьЗначенияСвойств(ПолеВыбора, ВыбранноеПоле)
	КонецЦикла;
	
	Для Смещение = 0 По ГлубинаDSO - 24 Цикл
		
		СмещениеСтрокой = Формат(Смещение, "ЧН=0; ЧГ=0");
		
		ИмяПоля = "DSO_" + СмещениеСтрокой;
		
		ПолеВыбора = ВыбранныеПоля.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ПолеВыбора.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);
		ПолеВыбора.Использование = Истина;
		
	КонецЦикла;
		
КонецПроцедуры

#КонецОбласти

