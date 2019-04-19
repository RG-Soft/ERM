&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Процедура ПериодНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Если Период = Дата(1,1,1) Тогда	
		ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(ТекущаяДата()), КонецМесяца(ТекущаяДата()));
	Иначе
		ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", НачалоМесяца(Период), КонецМесяца(Период));
	КонецЕсли;	
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериодаМесяц", ПараметрыВыбора, ЭтаФорма.ПредставлениеПериода, , , , ОписаниеОповещения);

КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Период = РезультатВыбора.НачалоПериода;
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьКорректировки(Команда)
	
	Результат = Истина;
	ВыполнитьПроверкуСуммНаКлиенте(Результат);
	
	Если Результат Тогда 
		СоздатьКорректировкиНаСервере();
		НайтиТранзакцииНаКлиенте();
	Иначе
		ТекстСообщения = НСтр("ru = 'Differences between the selected transactions is within than allowed. 
			|Balance transfer is possible!'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;

	
КонецПроцедуры

&НаСервере
Процедура СоздатьКорректировкиНаСервере()
	
	Отбор = Новый Структура;
	Отбор.Вставить("Apply", Истина);
	ТЗ_ТранзакцииLawson = ТаблицаТранзакцийLawson.Выгрузить(Отбор, );
	ТЗ_ТранзакцииOracle = ТаблицаТранзакцийOracle.Выгрузить(Отбор, );
	 
	Если ТЗ_ТранзакцииLawson.Количество() > 0 ИЛИ ТЗ_ТранзакцииOracle.Количество() > 0 Тогда
		
		УстановитьПривилегированныйРежим(Истина);
		
		НачатьТранзакцию();

		Док = Документы.КорректировкаРегистров.СоздатьДокумент();
		Док.ДополнительныеСвойства.Вставить("РазрешитьСозданиеДокументаБезРеверса", Истина);
		Док.Дата = КонецМесяца(Период);
		Док.ТипКорректировки = Перечисления.ТипыКорректировкиРегистров.ПереносБалансовСLawsonНаOracle;
		Док.ManagementGeomarket = ManagementGeomarket;
		Док.Комментарий = "Перенос Балансов С Lawson На Oracle";
		Док.Ответственный = Пользователи.ТекущийПользователь();
		Док.Записать();
		
		КорректировкаСсылка = Док.Ссылка;
		
		ТЗ_ТранзакцииLawson.Колонки.Добавить("КорректировкаРегистров");
		ТЗ_ТранзакцииLawson.ЗаполнитьЗначения(КорректировкаСсылка, "КорректировкаРегистров");
		
		ТЗ_ТранзакцииOracle.Колонки.Добавить("КорректировкаРегистров");
		ТЗ_ТранзакцииOracle.ЗаполнитьЗначения(КорректировкаСсылка, "КорректировкаРегистров");
		
		МассивТипов=Новый Массив();
		МассивТипов.Добавить(Тип("ДокументСсылка.ТранзакцияOracle"));
		МассивТипов.Добавить(Тип("ДокументСсылка.ПроводкаDSS"));
		ТипыТранзакций = Новый ОписаниеТипов(МассивТипов); 
		
		ТЗ_Общая = Новый ТаблицаЗначений;
		ТЗ_Общая.Колонки.Добавить("Транзакция", ТипыТранзакций);
		ТЗ_Общая.Колонки.Добавить("КорректировкаРегистров", Новый ОписаниеТипов("ДокументСсылка.КорректировкаРегистров")); 
		
		//ТЗ_Общая = ТЗ_ТранзакцииOracle.Скопировать();
		
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТЗ_ТранзакцииLawson,ТЗ_Общая);
		ОбщегоНазначенияКлиентСервер.ДополнитьТаблицу(ТЗ_ТранзакцииOracle,ТЗ_Общая);
		
		
		НЗ = РегистрыСведений.СоответсвиеКорректировкиРегистровПроводки.СоздатьНаборЗаписей();
		НЗ.Отбор.КорректировкаРегистров.Установить(КорректировкаСсылка);
		
		НЗ.Загрузить(ТЗ_Общая);
		
		НЗ.Записать(Истина);
		
		КорректировкаОбъект = КорректировкаСсылка.ПолучитьОбъект();
		
		//Для каждого СтрокаТранзакции Из ТЗ_ТранзакцииLawson Цикл
		//	НоваяЗапись = НЗ.Добавить();
		//	НоваяЗапись.КорректировкаРегистров = КорректировкаСсылка;
		//	НоваяЗапись.Транзакция = СтрокаТранзакции.Транзакция;
		//КонецЦикла;
		OracleUnbilledAccount = ПланыСчетов.Oracle.НайтиПоКоду("1090.000.0000.501");
		OracleBilledAccount = ПланыСчетов.Oracle.НайтиПоКоду("110G.000.0000.501");
		
		Для Каждого СтрокаТранзакции Из ТЗ_ТранзакцииOracle Цикл
			ТранзакцияОбъект = СтрокаТранзакции.Транзакция.ПолучитьОбъект();
			КоллекцияДвижений = ТранзакцияОбъект.Движения;
			
			Для каждого НаборЗаписей Из КоллекцияДвижений Цикл
				МетаданныеНабораЗаписей = Метаданные.НайтиПоТипу(ТипЗнч(НаборЗаписей));
				Если НЕ Метаданные.РегистрыНакопления.Содержит(МетаданныеНабораЗаписей) Тогда
					Продолжить;
				КонецЕсли;
				НаборЗаписей.Прочитать();
				Для каждого ДвижениеТранзакции Из НаборЗаписей Цикл
					НовоеДвижение = Док.Движения[МетаданныеНабораЗаписей.Имя].Добавить();
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ДвижениеТранзакции);
					НовоеДвижение.Период = Док.Дата;
					Для каждого Ресурс Из МетаданныеНабораЗаписей.Ресурсы Цикл
						НовоеДвижение[Ресурс.Имя] = -НовоеДвижение[Ресурс.Имя];
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
			
		КонецЦикла;
		
		СообщениеОбОшибке = "";
		
		Для каждого СтрокаТранзакции Из ТЗ_ТранзакцииLawson Цикл 
			ТранзакцияОбъект = СтрокаТранзакции.Транзакция.ПолучитьОбъект();
			КоллекцияДвижений = ТранзакцияОбъект.Движения;
			
			Для каждого НаборЗаписей Из КоллекцияДвижений Цикл
				МетаданныеНабораЗаписей = Метаданные.НайтиПоТипу(ТипЗнч(НаборЗаписей));
				Если НЕ Метаданные.РегистрыНакопления.Содержит(МетаданныеНабораЗаписей) Тогда
					Продолжить;
				КонецЕсли;
				НаборЗаписей.Прочитать();
				Для каждого ДвижениеТранзакции Из НаборЗаписей Цикл
					НовоеДвижение = Док.Движения[МетаданныеНабораЗаписей.Имя].Добавить();
					//AccountOracle = ОпределитьСчетOracle(ДвижениеТранзакции);
					ЗаполнитьЗначенияСвойств(НовоеДвижение, ДвижениеТранзакции);
					НовоеДвижение.Период = Док.Дата;
					НовоеДвижение.Source = Перечисления.ТипыСоответствий.OracleMI;
					НовоеДвижение.Company = Справочники.Организации.НайтиПоКоду(9660);
					Если ДвижениеТранзакции.Account.Родитель = ПланыСчетов.Lawson.ControlAccounts Тогда
						НовоеДвижение.Account = OracleBilledAccount;
					Иначе
						НовоеДвижение.Account = OracleUnbilledAccount;
					КонецЕсли;
					AUOracleMI = ОпределитьAUOracleMI(ДвижениеТранзакции.Client, ДвижениеТранзакции.AU);
					Если ЗначениеЗаполнено(AUOracleMI) Тогда 
						НовоеДвижение.AU = AUOracleMI;
					Иначе
						СообщениеОбОшибке = СообщениеОбОшибке + "Для клиента " + ДвижениеТранзакции.Client + " и AU " + ДвижениеТранзакции.AU + " не найдено соответствие AU Oracle." + Символы.ПС;
					КонецЕсли;
					CustomerNumberOracleMI = ОпределитьCustomerNumberOracleMI(ДвижениеТранзакции.Client);
					Если ЗначениеЗаполнено(CustomerNumberOracleMI) Тогда
						НовоеДвижение.ClientID = CustomerNumberOracleMI;
					Иначе
						СообщениеОбОшибке = СообщениеОбОшибке + "Для клиента " + ДвижениеТранзакции.Client + " не настроен Mapping Oracle MI." + Символы.ПС;
					КонецЕсли;
					Для каждого Ресурс Из МетаданныеНабораЗаписей.Ресурсы Цикл
						НовоеДвижение[Ресурс.Имя] = НовоеДвижение[Ресурс.Имя]/1.18;
					КонецЦикла;
				КонецЦикла;
			КонецЦикла;
		КонецЦикла;
		
		Если СообщениеОбОшибке <> "" Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке);
			ОтменитьТранзакцию();
		Иначе
			
			Если Док.Движения.UnbilledAR.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "UnbilledAR";
				
				Док.Движения.UnbilledAR.Записывать = Истина;
				
			КонецЕсли;
			
			Если Док.Движения.BilledAR.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "BilledAR";
				
				Док.Движения.BilledAR.Записывать = Истина;
				
			КонецЕсли;
			
			Если Док.Движения.UnallocatedCash.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "UnallocatedCash";
				
				Док.Движения.UnallocatedCash.Записывать = Истина;
				
			КонецЕсли;
			
			Если Док.Движения.ManualTransactions.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "ManualTransactions";
				
				Док.Движения.ManualTransactions.Записывать = Истина;
				
			КонецЕсли;
			
			Если Док.Движения.UnallocatedMemo.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "UnallocatedMemo";
				
				Док.Движения.UnallocatedMemo.Записывать = Истина;
				
			КонецЕсли;
			
			Если Док.Движения.Payments.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "Payments";
				
				Док.Движения.Payments.Записывать = Истина;
				
			КонецЕсли;
			
			Если Док.Движения.Revenue.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "Revenue";
				
				Док.Движения.Revenue.Записывать = Истина;
				
			КонецЕсли;
			
			Если Док.Движения.InvoicedDebts.Количество() > 0 Тогда
				
				СтрокаТаблицыРегистров = Док.ТаблицаРегистров.Добавить();
				СтрокаТаблицыРегистров.Имя = "InvoicedDebts";
				
				Док.Движения.InvoicedDebts.Записывать = Истина;
				
			КонецЕсли;
			
			Док.Записать();
			
			ЗафиксироватьТранзакцию();
			
		КонецЕсли;
		
	Иначе
		//ругаться, что ничего не выбрано
	КонецЕсли;
		
		
КонецПроцедуры

&НаСервере
Функция ОпределитьCustomerNumberOracleMI(Client)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних.Идентификатор КАК Идентификатор
		|ИЗ
		|	РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.СрезПоследних(
		|			,
		|			ТипОбъектаВнешнейСистемы = ЗНАЧЕНИЕ(Перечисление.ТипыОбъектовВнешнихСистем.Client)
		|				И ТипСоответствия = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleMI)
		|				И ОбъектПриемника = &Client
		|				И НЕ Идентификатор ПОДОБНО ""%#empty#%"") КАК НастройкаСинхронизацииОбъектовСВнешнимиСистемамиСрезПоследних";
	
	Запрос.УстановитьПараметр("Client", Client);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.Идентификатор;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

&НаСервере
Функция ОпределитьAUOracleMI(Client, AU)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СоответствиеClientAULawsonOracleMI.AUOracleMI КАК AUOracleMI
		|ИЗ
		|	РегистрСведений.СоответствиеClientAULawsonOracleMI КАК СоответствиеClientAULawsonOracleMI
		|ГДЕ
		|	СоответствиеClientAULawsonOracleMI.Client = &Client
		|	И СоответствиеClientAULawsonOracleMI.AULawson = &AULawson";
	
	Запрос.УстановитьПараметр("AULawson", AU);
	Запрос.УстановитьПараметр("Client", Client);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.AUOracleMI;
	КонецЕсли;;
	
	Возврат Неопределено;
	
КонецФункции

&НаКлиенте
Процедура НайтиТранзакции(Команда)
	
	НайтиТранзакцииНаКлиенте();
	
КонецПроцедуры

&НаКлиенте
Процедура НайтиТранзакцииНаКлиенте()
	
	ИтоговаяСуммаLawson = 0;
	ИтоговаяСуммаOracle = 0;
	
	Результат = НайтиТранзакцииНаСервере();
	
КонецПроцедуры

&НаСервере
Функция НайтиТранзакцииНаСервере()
	
	ТранзакцииLawson = Обработки.ПереносБалансовСLawsonНаOracleMI.НайтиТранзакцииLawson(Период, ВидСчета, ManagementGeomarket);
	ТранзакцииOracle = Обработки.ПереносБалансовСLawsonНаOracleMI.НайтиТранзакцииOracle(Период, ВидСчета, ManagementGeomarket);
	
	ТаблицаТранзакцийLawson.Загрузить(ТранзакцииLawson);
	ТаблицаТранзакцийOracle.Загрузить(ТранзакцииOracle);
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьПроверкуСумм(Команда)
	
	Результат = Истина;
	ВыполнитьПроверкуСуммНаКлиенте(Результат);
	
	Если Результат Тогда 
		ТекстСообщения = НСтр("ru = 'Differences between the selected transactions is within than allowed. 
			|Balance transfer is possible!'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьПроверкуСуммНаКлиенте(Результат = Истина)

	Если Макс(ИтоговаяСуммаLawson - ИтоговаяСуммаOracle, ИтоговаяСуммаOracle - ИтоговаяСуммаLawson) > ДопустимоеОтклонениеСумм Тогда
		Результат = Ложь;
	КонецЕсли;
	
	Если НЕ Результат Тогда
		ТекстСообщения = НСтр("ru = 'Differences between selected transactions are more than possible.'");
		ПоказатьПредупреждение(, ТекстСообщения);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТранзакцийLawsonApplyПриИзменении(Элемент)
	
	Если Элементы.ТаблицаТранзакцийLawson.ТекущиеДанные.ЕстьКорректировка ИЛИ ЗначениеЗаполнено(Элементы.ТаблицаТранзакцийLawson.ТекущиеДанные.КорректировкаТранзакции) Тогда
		Элементы.ТаблицаТранзакцийLawson.ТекущиеДанные.Apply = Ложь;
		Возврат;
	КонецЕсли;
	
	Если Элементы.ТаблицаТранзакцийLawson.ТекущиеДанные.Apply Тогда
		ИтоговаяСуммаLawson = ИтоговаяСуммаLawson + Элементы.ТаблицаТранзакцийLawson.ТекущиеДанные.BaseAmount;
	Иначе
		ИтоговаяСуммаLawson = ИтоговаяСуммаLawson - Элементы.ТаблицаТранзакцийLawson.ТекущиеДанные.BaseAmount;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаТранзакцийOracleApplyПриИзменении(Элемент)
	
	Если Элементы.ТаблицаТранзакцийOracle.ТекущиеДанные.ЕстьКорректировка ИЛИ ЗначениеЗаполнено(Элементы.ТаблицаТранзакцийOracle.ТекущиеДанные.КорректировкаТранзакции) Тогда
		Элементы.ТаблицаТранзакцийOracle.ТекущиеДанные.Apply = Ложь;
		Возврат;
	КонецЕсли;
	
	Если Элементы.ТаблицаТранзакцийOracle.ТекущиеДанные.Apply Тогда
		ИтоговаяСуммаOracle = ИтоговаяСуммаOracle + Элементы.ТаблицаТранзакцийOracle.ТекущиеДанные.BaseAmount;
	Иначе
		ИтоговаяСуммаOracle = ИтоговаяСуммаOracle - Элементы.ТаблицаТранзакцийOracle.ТекущиеДанные.BaseAmount;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажкиLawson(Команда)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТранзакцийLawson Цикл
		Если Элементы.ТаблицаТранзакцийLawson.ПроверитьСтроку(СтрокаТаблицы.ПолучитьИдентификатор()) Тогда
			Если НЕ СтрокаТаблицы.Apply И НЕ СтрокаТаблицы.ЕстьКорректировка И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КорректировкаТранзакции) Тогда
				СтрокаТаблицы.Apply = Истина;
				ИтоговаяСуммаLawson = ИтоговаяСуммаLawson + СтрокаТаблицы.BaseAmount;
			КонецЕсли
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажкиLawson(Команда)
	
	Для каждого СтрокаТаблицы Из ТаблицаТранзакцийLawson Цикл
		Если СтрокаТаблицы.Apply Тогда
			СтрокаТаблицы.Apply = Ложь;
			ИтоговаяСуммаLawson = ИтоговаяСуммаLawson - СтрокаТаблицы.BaseAmount;
		КонецЕсли;
	КонецЦикла;

	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьФлажкиOracle(Команда)
	
	Для Каждого СтрокаТаблицы Из ТаблицаТранзакцийOracle Цикл
		Если Элементы.ТаблицаТранзакцийOracle.ПроверитьСтроку(СтрокаТаблицы.ПолучитьИдентификатор()) Тогда
			Если НЕ СтрокаТаблицы.Apply  И НЕ СтрокаТаблицы.ЕстьКорректировка И НЕ ЗначениеЗаполнено(СтрокаТаблицы.КорректировкаТранзакции) Тогда
				СтрокаТаблицы.Apply = Истина;
				ИтоговаяСуммаOracle = ИтоговаяСуммаOracle + СтрокаТаблицы.BaseAmount;
			КонецЕсли
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлажкиOracle(Команда)
	
	Для каждого СтрокаТаблицы Из ТаблицаТранзакцийOracle Цикл
		Если СтрокаТаблицы.Apply Тогда
			СтрокаТаблицы.Apply = Ложь;
			ИтоговаяСуммаOracle = ИтоговаяСуммаOracle - СтрокаТаблицы.BaseAmount;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

