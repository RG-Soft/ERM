
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Ключ.Пустой() Тогда
		ЭтоНоваяЗапись = Истина;
		Элементы.ДатаПоследнегоОбновленногоЭлемента.ТолькоПросмотр = Истина;
		Элементы.КлючУникальности.ТолькоПросмотр = Истина;
		Элементы.ДатаИзмененияЗаписиРегистра.ТолькоПросмотр = Истина;
	КонецЕсли;
	
	ТолькоПросмотр = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЭтоНоваяЗапись Тогда
		Возврат;
	КонецЕсли;
	
	ТекущийОбъект.ДатаПоследнегоОбновленногоЭлемента = УправлениеДоступомСлужебный.МаксимальнаяДата();
	ТекущийОбъект.КлючУникальности = Новый УникальныйИдентификатор;
	ТекущийОбъект.ДатаИзмененияЗаписиРегистра = ТекущаяДатаСеанса();
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ЭтоНоваяЗапись = Ложь;
	
	Элементы.ДатаПоследнегоОбновленногоЭлемента.ТолькоПросмотр = Ложь;
	Элементы.КлючУникальности.ТолькоПросмотр = Ложь;
	Элементы.ДатаИзмененияЗаписиРегистра.ТолькоПросмотр = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВключитьВозможностьРедактирования(Команда)
	
	ТолькоПросмотр = Ложь;
	
КонецПроцедуры

#КонецОбласти
