#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если Не ЭтоНовый() Тогда
		ДополнительныеСвойства.Вставить("СтарыеЗначенияКлючей", ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Номер, Client, Company"));
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ДополнительныеСвойства.Свойство("СтарыеЗначенияКлючей") Тогда
		
		СтарыеЗначенияКлючей = ДополнительныеСвойства.СтарыеЗначенияКлючей;
		Если СтарыеЗначенияКлючей.Номер <> Номер
			ИЛИ СтарыеЗначенияКлючей.Company <> Company
			ИЛИ СтарыеЗначенияКлючей.Client <> Client Тогда
			
			НЗ = РегистрыСведений.КлючиMemo.СоздатьНаборЗаписей();
			НЗ.Отбор.ArInvoice.Установить(СтарыеЗначенияКлючей.Номер);
			НЗ.Отбор.Company.Установить(СтарыеЗначенияКлючей.Company);
			НЗ.Отбор.Client.Установить(СтарыеЗначенияКлючей.Client);
			НЗ.Записать(Истина);
			
			НЗ.Отбор.ArInvoice.Установить(Номер);
			НЗ.Отбор.Company.Установить(Company);
			НЗ.Отбор.Client.Установить(Client);
			ЗаписьНабора = НЗ.Добавить();
			ЗаписьНабора.ArInvoice = Номер;
			ЗаписьНабора.Company = Company;
			ЗаписьНабора.Client = Client;
			ЗаписьНабора.Memo = Ссылка;
			НЗ.Записать(Истина);
			
		КонецЕсли;
		
	Иначе
		
		НЗ = РегистрыСведений.КлючиMemo.СоздатьНаборЗаписей();
		НЗ.Отбор.ArInvoice.Установить(Номер);
		НЗ.Отбор.Company.Установить(Company);
		НЗ.Отбор.Client.Установить(Client);
		ЗаписьНабора = НЗ.Добавить();
		ЗаписьНабора.ArInvoice = Номер;
		ЗаписьНабора.Company = Company;
		ЗаписьНабора.Client = Client;
		ЗаписьНабора.Memo = Ссылка;
		НЗ.Записать(Истина);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	НЗ = РегистрыСведений.КлючиMemo.СоздатьНаборЗаписей();
	НЗ.Отбор.ArInvoice.Установить(Номер);
	НЗ.Отбор.Company.Установить(Company);
	НЗ.Отбор.Client.Установить(Client);
	НЗ.Записать(Истина);
	
КонецПроцедуры

#КонецЕсли
