Перем ПрошлыйИзмененныйРодительОбъектаДоступа;

Процедура ПередЗаписью(Отказ)
	
	Перем мСсылкаНового;
	
	Если НЕ ОбменДанными.Загрузка Тогда
				
		ПрошлыйИзмененныйРодительОбъектаДоступа = ?(Не ЭтоНовый() и Не Ссылка.Родитель = Родитель, Ссылка.Родитель, Неопределено);
		Если ЗначениеЗаполнено(мСсылкаНового) Тогда
			//НастройкаПравДоступа.ПередЗаписьюНовогоОбъектаСПравамиДоступаПользователей(ЭтотОбъект, Отказ, Родитель, мСсылкаНового);
		КонецЕсли; 
		
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
				
		//НастройкаПравДоступа.ОбновитьПраваДоступаКИерархическимОбъектамПриНеобходимости(Ссылка,ПрошлыйИзмененныйРодительОбъектаДоступа, Отказ);
		
	КонецЕсли;
	
КонецПроцедуры
