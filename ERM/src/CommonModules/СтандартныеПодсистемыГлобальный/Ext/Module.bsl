﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Базовая функциональность".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Вызывается каждые 20 минут, например, для контроля динамического обновления и
// окончания срока действия учетной записи пользователя.
//
Процедура ОбработчикОжиданияСтандартныхПериодическихПроверок() Экспорт
	
	СтандартныеПодсистемыКлиент.ПриВыполненииСтандартныхПериодическихПроверок();
	
КонецПроцедуры

// Продолжает завершение в режиме интерактивного взаимодействия с пользователем
// после установки Отказ = Истина.
//
Процедура ОбработчикОжиданияИнтерактивнаяОбработкаПередЗавершениемРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.НачатьИнтерактивнуюОбработкуПередЗавершениемРаботыСистемы();
	
КонецПроцедуры

// Продолжает запуск в режиме интерактивного взаимодействия с пользователем.
Процедура ОбработчикОжиданияПриНачалеРаботыСистемы() Экспорт
	
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы(, Ложь);
	
КонецПроцедуры

// Вызывается после запуска конфигурации, открывает окно информации.
Процедура ПоказатьИнформациюПослеЗапуска() Экспорт
	МодульИнформацияПриЗапускеКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ИнформацияПриЗапускеКлиент");
	МодульИнформацияПриЗапускеКлиент.Показать();
КонецПроцедуры

// Показывает сообщение пользователю о недостаточном объеме оперативной памяти.
Процедура ПоказатьРекомендациюПоОбъемуОперативнойПамяти() Экспорт
	СтандартныеПодсистемыКлиент.ОповеститьОНехваткеПамяти();
КонецПроцедуры

// Отображает всплывающее предупреждение о необходимости выполнения дополнительных
// действий перед завершением работы системы.
//
Процедура ПоказатьПредупрежденияПриЗавершенииРаботы() Экспорт
	Предупреждения = СтандартныеПодсистемыКлиент.ПараметрКлиента("ПредупрежденияПриЗавершенииРаботы");
	Пояснение = НСтр("ru = 'Выполнить дополнительные действия и завершить работу'");
	Если Предупреждения.Количество() = 1 И Не ПустаяСтрока(Предупреждения[0].ТекстГиперссылки) Тогда
		Пояснение = Предупреждения[0].ТекстГиперссылки;
	КонецЕсли;
	ПоказатьОповещениеПользователя(, "e1cib/command/ОбщаяКоманда.ПредупрежденияПриЗавершенииРаботы",
		Пояснение, БиблиотекаКартинок.Информация32);
КонецПроцедуры

#КонецОбласти
