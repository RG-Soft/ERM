#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Не ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("СтарыеЗначенияКлючей", ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Номер, Company,Source"));
	КонецЕсли;
	
	Если Source = Перечисления.ТипыСоответствий.HOBs И ЭтоНовый() Тогда
		УстановитьНовыйНомер("HB");
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("СтарыеЗначенияКлючей") Тогда
		
		СтарыеЗначенияКлючей = ДополнительныеСвойства.СтарыеЗначенияКлючей;
		Если СтарыеЗначенияКлючей.Номер <> Номер
			ИЛИ СтарыеЗначенияКлючей.Company <> Company Тогда
			
			НЗ = РегистрыСведений.КлючиИнвойсов.СоздатьНаборЗаписей();
			НЗ.Отбор.ArInvoice.Установить(СтарыеЗначенияКлючей.Номер);
			НЗ.Отбор.Company.Установить(СтарыеЗначенияКлючей.Company);
			НЗ.Отбор.Source.Установить(СтарыеЗначенияКлючей.Source);
			НЗ.Записать(Истина);
			
			НЗ.Отбор.ArInvoice.Установить(Номер);
			НЗ.Отбор.Company.Установить(Company);
			НЗ.Отбор.Source.Установить(Source);
			ЗаписьНабора = НЗ.Добавить();
			ЗаписьНабора.ArInvoice = Номер;
			ЗаписьНабора.Company = Company;
			ЗаписьНабора.Source = Source;
			ЗаписьНабора.Invoice = Ссылка;
			НЗ.Записать(Истина);
			
		КонецЕсли;
		
	Иначе
		
		НЗ = РегистрыСведений.КлючиИнвойсов.СоздатьНаборЗаписей();
		НЗ.Отбор.ArInvoice.Установить(Номер);
		НЗ.Отбор.Company.Установить(Company);
		НЗ.Отбор.Source.Установить(Source);
		ЗаписьНабора = НЗ.Добавить();
		ЗаписьНабора.ArInvoice = Номер;
		ЗаписьНабора.Company = Company;
		ЗаписьНабора.Source = Source;
		ЗаписьНабора.Invoice = Ссылка;
		НЗ.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	НЗ = РегистрыСведений.КлючиИнвойсов.СоздатьНаборЗаписей();
	НЗ.Отбор.ArInvoice.Установить(Номер);
	НЗ.Отбор.Company.Установить(Company);
	НЗ.Отбор.Source.Установить(Source);
	НЗ.Записать(Истина);
	
КонецПроцедуры

#КонецЕсли