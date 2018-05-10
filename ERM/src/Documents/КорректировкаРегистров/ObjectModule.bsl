#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Ответственный = Пользователи.ТекущийПользователь();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если НЕ Reverse И Не РольДоступна("ПолныеПрава") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("There are not enough rights to create an adjustment",,,,Отказ);
	КонецЕсли;
	
	Если Reverse Тогда

		Если Движения.BilledAR.Количество() > 0 Тогда
			
			ДанныеИзНЗ = Движения.BilledAR.Выгрузить();
			ДанныеСРазворотами = ДанныеИзНЗ.Скопировать();
			Для Каждого СтрокаДанных Из ДанныеИзНЗ Цикл
				СтрокаДанныеСРазворотами = ДанныеСРазворотами.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанныеСРазворотами,СтрокаДанных);
				СтрокаДанныеСРазворотами.Период = КонецМесяца(СтрокаДанных.Период)+1;
				СтрокаДанныеСРазворотами.Amount = - СтрокаДанных.Amount;
				СтрокаДанныеСРазворотами.BaseAmount = - СтрокаДанных.BaseAmount;
			КонецЦикла;
			
			Движения.BilledAR.Загрузить(ДанныеСРазворотами);
			
		КонецЕсли;
		
		Если Движения.UnbilledAR.Количество() > 0 Тогда
			
			ДанныеИзНЗ = Движения.UnbilledAR.Выгрузить();
			ДанныеСРазворотами = ДанныеИзНЗ.Скопировать();
			Для Каждого СтрокаДанных Из ДанныеИзНЗ Цикл
				СтрокаДанныеСРазворотами = ДанныеСРазворотами.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанныеСРазворотами,СтрокаДанных);
				СтрокаДанныеСРазворотами.Период = КонецМесяца(СтрокаДанных.Период)+1;
				СтрокаДанныеСРазворотами.Amount = - СтрокаДанных.Amount;
				СтрокаДанныеСРазворотами.BaseAmount = - СтрокаДанных.BaseAmount;
			КонецЦикла;
			
			Движения.UnbilledAR.Загрузить(ДанныеСРазворотами);
			
		КонецЕсли;

		Если Движения.ManualTransactions.Количество() > 0 Тогда
			
			ДанныеИзНЗ = Движения.ManualTransactions.Выгрузить();
			ДанныеСРазворотами = ДанныеИзНЗ.Скопировать();
			Для Каждого СтрокаДанных Из ДанныеИзНЗ Цикл
				СтрокаДанныеСРазворотами = ДанныеСРазворотами.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанныеСРазворотами,СтрокаДанных);
				СтрокаДанныеСРазворотами.Период = КонецМесяца(СтрокаДанных.Период)+1;
				СтрокаДанныеСРазворотами.Amount = - СтрокаДанных.Amount;
				СтрокаДанныеСРазворотами.BaseAmount = - СтрокаДанных.BaseAmount;
			КонецЦикла;
			
			Движения.ManualTransactions.Загрузить(ДанныеСРазворотами);
			
		КонецЕсли;

		Если Движения.UnallocatedCash.Количество() > 0 Тогда
			
			ДанныеИзНЗ = Движения.UnallocatedCash.Выгрузить();
			ДанныеСРазворотами = ДанныеИзНЗ.Скопировать();
			Для Каждого СтрокаДанных Из ДанныеИзНЗ Цикл
				СтрокаДанныеСРазворотами = ДанныеСРазворотами.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанныеСРазворотами,СтрокаДанных);
				СтрокаДанныеСРазворотами.Период = КонецМесяца(СтрокаДанных.Период)+1;
				СтрокаДанныеСРазворотами.Amount = - СтрокаДанных.Amount;
				СтрокаДанныеСРазворотами.BaseAmount = - СтрокаДанных.BaseAmount;
			КонецЦикла;
			
			Движения.UnallocatedCash.Загрузить(ДанныеСРазворотами);
			
		КонецЕсли;

		Если Движения.UnallocatedMemo.Количество() > 0 Тогда
			
			ДанныеИзНЗ = Движения.UnallocatedMemo.Выгрузить();
			ДанныеСРазворотами = ДанныеИзНЗ.Скопировать();
			Для Каждого СтрокаДанных Из ДанныеИзНЗ Цикл
				СтрокаДанныеСРазворотами = ДанныеСРазворотами.Добавить();
				ЗаполнитьЗначенияСвойств(СтрокаДанныеСРазворотами,СтрокаДанных);
				СтрокаДанныеСРазворотами.Период = КонецМесяца(СтрокаДанных.Период)+1;
				СтрокаДанныеСРазворотами.Amount = - СтрокаДанных.Amount;
				СтрокаДанныеСРазворотами.BaseAmount = - СтрокаДанных.BaseAmount;
			КонецЦикла;
			
			Движения.UnallocatedMemo.Загрузить(ДанныеСРазворотами);
			
		КонецЕсли;

	КонецЕсли;
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если Не ЭтоНовый() И Ссылка.ПометкаУдаления <> ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(НЕ ПометкаУдаления);
	ИначеЕсли ПометкаУдаления Тогда
		УстановитьАктивностьДвижений(Ложь);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьАктивностьДвижений(ФлагАктивности)
	
	Для Каждого Движение Из Движения Цикл
		
		Движение.Прочитать();
		Движение.УстановитьАктивность(ФлагАктивности);
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли