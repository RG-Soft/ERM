﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Функция ПолучитьСуммуДокумента(Документ) Экспорт
	
	Source = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Документ, "Source");
	
	Если Source = Перечисления.ТипыСоответствий.Lawson Тогда
		Возврат ПолучитьСуммуДокументаLawson(Документ);
	ИначеЕсли Source = Перечисления.ТипыСоответствий.OracleMI ИЛИ Source = Перечисления.ТипыСоответствий.OracleSmith Тогда
		Возврат ПолучитьСуммуДокументаOracle(Документ);
	Иначе
		ВызватьИсключение "Для источника " + Source + " не определен обработчик!";
	КонецЕсли;
	
КонецФункции

Функция ПолучитьСуммуДокументаLawson(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).TranAmount) КАК СуммаДокумента
	|ИЗ
	|	РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументы
	|ГДЕ
	|	DSSСвязанныеДокументы.СвязанныйОбъект = &СвязанныйОбъект
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).System = ""AR""
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).SourceCode = ""RM""
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ПроводкаDSS).Проведен
	|	И НЕ DSSСвязанныеДокументы.ПроводкаDSS.AccountLawson.БазовыйЭлемент В ИЕРАРХИИ (&СчетВыручкиВерхнегоУровня)";
	
	Запрос.УстановитьПараметр("СвязанныйОбъект", Документ);
	Запрос.УстановитьПараметр("СчетВыручкиВерхнегоУровня", rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня"));
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.СуммаДокумента;
	
КонецФункции

Функция ПолучитьСуммуДокументаOracle(Документ)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СУММА(ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Amount) КАК СуммаДокумента
	|ИЗ
	|	РегистрСведений.DSSСвязанныеДокументы КАК DSSСвязанныеДокументы
	|ГДЕ
	|	DSSСвязанныеДокументы.СвязанныйОбъект = &СвязанныйОбъект
	|	И (ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""CM""
	|				И (ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""CM_REC""
	|					ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""CMAPP_REC"")
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""DM""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""DM_REC""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""Credit Memos""
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Source = ЗНАЧЕНИЕ(Перечисление.ТипыСоответствий.OracleSmith)
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""Credit Memo Applications""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Amount > 0
	|			ИЛИ ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).DocType = ""DM""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).TransType = ""DMAPP_REC""
	|				И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Amount < 0)
	|	И ВЫРАЗИТЬ(DSSСвязанныеДокументы.ПроводкаDSS КАК Документ.ТранзакцияOracle).Проведен
	|	И НЕ DSSСвязанныеДокументы.ПроводкаDSS.Account.БазовыйЭлемент В ИЕРАРХИИ (&СчетВыручкиВерхнегоУровня)";
	
	Запрос.УстановитьПараметр("СвязанныйОбъект", Документ);
	Запрос.УстановитьПараметр("СчетВыручкиВерхнегоУровня", rgsНастройкаКонфигурации.ЗначениеНастройки("СчетВыручкиВерхнегоУровня"));
	
	Результат = Запрос.Выполнить();
	
	Если Результат.Пустой() Тогда
		Возврат 0;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.СуммаДокумента;
	
КонецФункции

Процедура ОбновитьСуммуДокумента(Документ) Экспорт
	
	ДокОбъект = Документ.ПолучитьОбъект();
	ДокОбъект.Amount = ПолучитьСуммуДокумента(Документ);
	ДокОбъект.ОбменДанными.Загрузка = Истина;
	ДокОбъект.Записать();
	
КонецПроцедуры

#КонецЕсли