﻿
&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;

&НаСервере
Функция ОбновитьСправочникПользователейНаСервере(ЗапретитьВыполнениеВФоне = Ложь)
	
	СтруктураПараметров = Новый Структура();
	СтруктураПараметров.Вставить("ИмяПользователяПодключения", ИмяПользователяПодключения);
	СтруктураПараметров.Вставить("ПарольПользователяПодключения", ПарольПользователяПодключения);
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() ИЛИ ЗапретитьВыполнениеВФоне Тогда
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		Обработки.UpdateLDAPUsers.ОбновитьСправочникLDAPUsers(СтруктураПараметров, АдресХранилища);
		
		Результат = Новый Структура("ЗаданиеВыполнено", Истина);
	Иначе
		НаименованиеЗадания = НСтр("ru = 'Update LDAP Users'");
		Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
			УникальныйИдентификатор, 
			"Обработки.UpdateLDAPUsers.ОбновитьСправочникLDAPUsers", 
			СтруктураПараметров, 
			НаименованиеЗадания);
			
		АдресХранилища = Результат.АдресХранилища;
	КонецЕсли;
	
	Если Результат.ЗаданиеВыполнено Тогда
		ОбработатьРезультат();
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСправочникПользователей(Команда)
	
	Результат = ОбновитьСправочникПользователейНаСервере();
	
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		АдресХранилища       = Результат.АдресХранилища;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		ФормаДлительнойОперации = ДлительныеОперацииКлиент.ОткрытьФормуДлительнойОперации(ЭтаФорма, ИдентификаторЗадания);
		
	Иначе
		
		ОбработатьРезультат();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьРезультат()
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если СтруктураДанных.Свойство("ОшибкаЗаполнения") Тогда
		ВызватьИсключение СтруктураДанных.ОшибкаЗаполнения;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("LDAP Users catalogue successfully updated");
	КонецЕсли;
	
КонецПроцедуры

