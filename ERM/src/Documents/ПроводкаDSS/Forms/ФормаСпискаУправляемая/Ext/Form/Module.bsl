﻿&НаКлиенте
Процедура Уровень(Команда)
	
	#Если НЕ ТонкийКлиент И НЕ ВебКлиент Тогда
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Сообщить("Не выбрана строка");
		Возврат;
	КонецЕсли;
	               	
	ТЗ = ПолучитьТЗНаСервере();
	
	Если ТЗ.Количество() > 1 Тогда     	
		Сообщить("Строк с таким номером больше одной, поиск будет осуществляется для первой доступной");	
	КонецЕсли; 
	
	Если НЕ ТЗ.Количество() Тогда     	
		Сообщить("Данного номера поиск не осуществляется");
	КонецЕсли;  
	
	Если ТЗ.Количество() Тогда
	
		КодЭлементаСпр = ОбработкаDSSКлиент.ПрименитьФильтрыПоискТипа(Неопределено, ТЗ[0]);	
	
	КонецЕсли; 		
	
	Если ЗначениеЗаполнено(КодЭлементаСпр) Тогда
		
		//ФормаСпискаСправочника = Справочники.Фильтры.ПолучитьФормуСписка();     				
		//ФормаСпискаСправочника.Открыть();  		
		//ФормаСпискаСправочника.ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ПолучитьСсылкуНаСервере(КодЭлементаСпр);
		
	Иначе    		
		Сообщить("Не найден элемент справочника ""Фильтры"""); 		
	КонецЕсли; 	

	#КонецЕсли
		
КонецПроцедуры

&НаСервере
Функция ПолучитьТЗНаСервере()
	 
	Запрос = Новый Запрос; 
	Запрос.УстановитьПараметр("Номер", Элементы.Список.ТекущаяСтрока.Номер);
	Запрос.Текст = "ВЫБРАТЬ
			   	   |	ПроводкаDSS.AccountLawson.Родитель.КодЧислом КАК SumAcctNumber,
	               |	ПроводкаDSS.AccountLawson.Наименование КАК AccountDesc,
	               |	ПроводкаDSS.AccountLawson.КодЧислом КАК AccountNumber, 
	               |	ПроводкаDSS.Ссылка,
	               |	ПроводкаDSS.ВерсияДанных,
	               |	ПроводкаDSS.ПометкаУдаления,
	               |	ПроводкаDSS.Номер,
	               |	ПроводкаDSS.Дата,
	               |	ПроводкаDSS.Проведен,
	               |	ПроводкаDSS.AccountLawson,
	               |	ПроводкаDSS.FiscalType,
	               |	ПроводкаDSS.AU,
	               |	ПроводкаDSS.LegalEntity,
	               |	ПроводкаDSS.BaseAmount,
	               |	ПроводкаDSS.System,
	               |	ПроводкаDSS.DateLawson,
	               |	ПроводкаDSS.Reference,
	               |	ПроводкаDSS.Description,
	               |	ПроводкаDSS.TranAmount,
	               |	ПроводкаDSS.Currency,
	               |	ПроводкаDSS.GUID,
	               |	ПроводкаDSS.PeriodLawson,
	               |	ПроводкаDSS.Company,
	               |	ПроводкаDSS.Модуль,
	               |	ПроводкаDSS.Документ,
	               |	ПроводкаDSS.GeoMarket,
	               |	ПроводкаDSS.UpdateDateLawson,
	               |	ПроводкаDSS.SeqTrnsNbrLawson,
	               |	ПроводкаDSS.OrigCompanyLawson,
	               |	ПроводкаDSS.Activity,
	               |	ПроводкаDSS.SourceCode,
	               |	ПроводкаDSS.JeTypeLawson,
	               |	ПроводкаDSS.JournalLawson,
	               |	ПроводкаDSS.LineNbrLawson,
	               |	ПроводкаDSS.AutoRevLawson,
	               |	ПроводкаDSS.Operator,
	               |	ПроводкаDSS.LegalFiscalFlagLawson,
	               |	ПроводкаDSS.Vendor,
	               |	ПроводкаDSS.VendorVname,
	               |	ПроводкаDSS.ApInvoice,
	               |	ПроводкаDSS.TransNbr,
	               |	ПроводкаDSS.OrigOperatorId,
	               |	ПроводкаDSS.ProcessLevel,
	               |	ПроводкаDSS.CashCode,
	               |	ПроводкаDSS.PoNumber,
	               |	ПроводкаDSS.LineNbrIc,
	               |	ПроводкаDSS.PoCode,
	               |	ПроводкаDSS.AssetLawson,
	               |	ПроводкаDSS.ItemDescription,
	               |	ПроводкаDSS.CustomerNumber,
	               |	ПроводкаDSS.CustomerName,
	               |	ПроводкаDSS.ArInvoice,
	               |	ПроводкаDSS.TaxCode,
	               |	ПроводкаDSS.Item,
	               |	ПроводкаDSS.DocumentNbr,
	               |	ПроводкаDSS.ContractNumber,
	               |	ПроводкаDSS.AktOfAcceptance,
	               |	ПроводкаDSS.AktDateLawson,
	               |	ПроводкаDSS.ApTransFormId,
	               |	ПроводкаDSS.КонтрагентLawson,
	               |	ПроводкаDSS.Deferred,
	               |	ПроводкаDSS.POLine,
	               |	ПроводкаDSS.Ответственный,
	               |	ПроводкаDSS.Комментарий,
	               |	ПроводкаDSS.RubAmount,
	               |	ПроводкаDSS.FiscAmount,
	               |	ПроводкаDSS.TempDiff,
	               |	ПроводкаDSS.PermDiff,
	               |	ПроводкаDSS.ExchDiff,
	               |	ПроводкаDSS.ТипПроводки,
	               |	ПроводкаDSS.Ваучер
	               |ИЗ
	               |	Документ.ПроводкаDSS КАК ПроводкаDSS
	               |ГДЕ
	               |	ПроводкаDSS.Номер = &Номер";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	ТЗ = Запрос.Выполнить().Выгрузить();	
	
	Возврат ТЗ;
	 
КонецФункции

&НаСервере
Функция ПолучитьСсылкуНаСервере(КодЭлементаСпр)

		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Фильтры.Ссылка
		|ИЗ
		|	Справочник.Фильтры КАК Фильтры
		|ГДЕ
		|	Фильтры.Код = &Код";
		
		Запрос.УстановитьПараметр("Код", КодЭлементаСпр);		
		Результат = Запрос.Выполнить(); 		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		ВыборкаДетальныеЗаписи.Следующий();
		Возврат ВыборкаДетальныеЗаписи.Ссылка;

	
КонецФункции