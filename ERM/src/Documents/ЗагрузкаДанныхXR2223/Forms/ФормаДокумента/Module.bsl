
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	АдресВХранилище = "";
	ВыбранноеИмяФайла = "";
	
	ОписаниеОповещенияОЗавершении = Новый ОписаниеОповещения("ИмяФайлаНачалоВыбораЗавершение", ЭтотОбъект);
	
	НачатьПомещениеФайла(ОписаниеОповещенияОЗавершении, АдресВХранилище,,, УникальныйИдентификатор);
	
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаНачалоВыбораЗавершение(Результат, АдресВХранилище, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		
		Файл = Новый Файл(ВыбранноеИмяФайла);
		
		Объект.ИмяФайла = Файл.Имя;
		АдресФайлаВХранилище = АдресВХранилище;
		Модифицированность = Истина;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Если Объект.ИмяФайла = "" Тогда
		Сообщить("Файл не загружен!");
	Иначе
		СсылкаНаФайл = ПолучитьНавигационнуюСсылку(Объект.Ссылка, "ИсточникДанных");
		ПолучитьФайл(СсылкаНаФайл, Объект.ИмяФайла);
	КонецЕсли;
	
КонецПроцедуры
