
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// { RGS TAlmazova 02.08.2017 17:03:51 - проверка наличия корректировки для транзакции
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КорректировкаТранзакции.Номер
		|ИЗ
		|	Документ.КорректировкаТранзакции КАК КорректировкаТранзакции
		|ГДЕ
		|	НЕ КорректировкаТранзакции.ПометкаУдаления
		|	И КорректировкаТранзакции.ДокументОснование = &ДокументОснование
		|	И КорректировкаТранзакции.Ссылка <> &Ссылка";
	
	Запрос.УстановитьПараметр("ДокументОснование", Объект.ДокументОснование);
	Запрос.УстановитьПараметр("Ссылка", Объект.Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество() <> 0 Тогда
		ВыборкаДетальныеЗаписи.Следующий();
		Отказ = Истина;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("For this transaction adjustments already. Mark the deletion of the previous adjustment (№"+ ВыборкаДетальныеЗаписи.Номер + ") before creating a new one.");
	КонецЕсли;
	// } RGS TAlmazova 02.08.2017 17:03:51 - проверка наличия корректировки для транзакции
	
	
	
	Если ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ПроводкаDSS") Тогда
		Source = Перечисления.ТипыСоответствий.Lawson;
	ИначеЕсли ТипЗнч(Объект.ДокументОснование) = Тип("ДокументСсылка.ТранзакцияHOB") Тогда
		Source = Перечисления.ТипыСоответствий.HOBs;
	Иначе
		Source = Объект.ДокументОснование.Source;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(Объект.ДокументОснование) Тогда
		ЗначенияРеквизитовТранзакции = ПолучитьРеквизитыТранзакции();
		ЗаполнитьЗначенияСвойств(ЭтаФорма,ЗначенияРеквизитовТранзакции);
		Если Параметры.Ключ.Пустая() Тогда
			//Объект.Client = ТранзакцияClient;
			Объект.Account = ТранзакцияAccount;
			Объект.Company = ТранзакцияCompany;
			Объект.Location = ТранзакцияLocation;
			Объект.SubSubSegment = ТранзакцияSubSubSegment;
			Объект.Currency = ТранзакцияCurrency;
			Объект.AU = ТранзакцияAU;
			Объект.LegalEntity = ТранзакцияLegalEntity;
			СтрокаКлиент = Объект.ДетализацияПоКлиенту.Добавить();
			СтрокаКлиент.Client = ТранзакцияClient;
			СтрокаКлиент.Amount = ЗначенияРеквизитовТранзакции.ТранзакцияAmount;
			СтрокаКлиент.BaseAmount = ЗначенияРеквизитовТранзакции.ТранзакцияBaseAmount;
		КонецЕсли;
		
		//Если Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleMI") или Source = ПредопределенноеЗначение("Перечисление.ТипыСоответствий.OracleSmith") Тогда
		//	 Элементы.ГруппаAU.Видимость = Ложь;
		//Иначе
		//	 Элементы.ГруппаAU.Видимость = Истина;
		//КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРеквизитыТранзакции()
	Возврат Документы.КорректировкаТранзакции.ПолучитьРеквизитыТранзакции(Объект.ДокументОснование);
КонецФункции

&НаКлиенте
Процедура ClientПриИзменении(Элемент)
	
	//ДокументОснованиеClient = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.ДокументОснование, "Client");
	ИзменитьФон(Объект.Client, ЭтаФорма.ТранзакцияClient, Элементы.Client);
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьФон(РеквизитДокумента, РеквизитТранзакции, ЭлементФормы)
	
	Если РеквизитДокумента <> РеквизитТранзакции Тогда
		 ЭлементФормы.ЦветФона = WebЦвета.СветлоРозовый;
	 Иначе
		 ЭлементФормы.ЦветФона = Новый Цвет();
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура CompanyПриИзменении(Элемент)
	
	ИзменитьФон(Объект.Company, ЭтаФорма.ТранзакцияCompany, Элементы.Company);
	
КонецПроцедуры

&НаКлиенте
Процедура LocationПриИзменении(Элемент)
	
	ИзменитьФон(Объект.Location, ЭтаФорма.ТранзакцияLocation, Элементы.Location);
	
КонецПроцедуры

&НаКлиенте
Процедура LegalEntityПриИзменении(Элемент)
	
	ИзменитьФон(Объект.LegalEntity, ЭтаФорма.ТранзакцияLegalEntity, Элементы.LegalEntity);
	
КонецПроцедуры

&НаКлиенте
Процедура SubSubSegmentПриИзменении(Элемент)
	
	ИзменитьФон(Объект.SubSubSegment, ЭтаФорма.ТранзакцияSubSubSegment, Элементы.SubSubSegment);
	
КонецПроцедуры

&НаКлиенте
Процедура AccountПриИзменении(Элемент)
	
	ИзменитьФон(Объект.Account, ЭтаФорма.ТранзакцияAccount, Элементы.Account);
	
КонецПроцедуры

&НаКлиенте
Процедура CurrencyПриИзменении(Элемент)
	
	ИзменитьФон(Объект.Currency, ЭтаФорма.ТранзакцияCurrency, Элементы.Currency);
	
КонецПроцедуры

&НаКлиенте
Процедура AUПриИзменении(Элемент)
	
	ИзменитьФон(Объект.AU, ЭтаФорма.ТранзакцияAU, Элементы.AU);
	
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияПоКлиентуПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	//Чтобы строка не добавлялась, так как добавление внутри распределения суммы
	Отказ = Истина;
	
	РаспределитьСумму();

КонецПроцедуры

&НаСервере
Процедура РаспределитьСумму()
	
	ЗначенияРеквизитовТранзакции = ПолучитьРеквизитыТранзакции();
	ОстатокСуммы = ЗначенияРеквизитовТранзакции.ТранзакцияAmount - Объект.ДетализацияПоКлиенту.Итог("Amount");
	Если ОстатокСуммы <> 0 Тогда
		ТабличнаяЧастьДокумента = Объект.ДетализацияПоКлиенту.Выгрузить();
		НоваяСтрока = ТабличнаяЧастьДокумента.Добавить();
		НоваяСтрока.Amount = ОстатокСуммы; 
		ТаблицаСумм = ТабличнаяЧастьДокумента.ВыгрузитьКолонку("Amount");
		Если (ЗначенияРеквизитовТранзакции.ТранзакцияBaseAmount) <> 0 Тогда
			ТаблицаСуммВалюта = ОбщегоНазначения.РаспределитьСуммуПропорциональноКоэффициентам(ЗначенияРеквизитовТранзакции.ТранзакцияBaseAmount, ТаблицаСумм);
			ТабличнаяЧастьДокумента.ЗагрузитьКолонку(ТаблицаСуммВалюта, "BaseAmount");
		КонецЕсли;
		Объект.ДетализацияПоКлиенту.Загрузить(ТабличнаяЧастьДокумента);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДетализацияПоКлиентуAmountПриИзменении(Элемент)
	
	Если ТранзакцияCurrency = Объект.Currency Тогда
		РаспределитьСумму();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	СтруктураОповещения = Новый Структура;
	СтруктураОповещения.Вставить("Корректировка", Объект.Ссылка);
	СтруктураОповещения.Вставить("ПометкаУдаления", Объект.ПометкаУдаления);
	
	Оповестить("ЗаписьКорректировки", СтруктураОповещения);

КонецПроцедуры
