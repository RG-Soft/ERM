
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ПараметрыФормы = Новый Структура("ОбъектПриемника", ПараметрКоманды);
	ОткрытьФорму("РегистрСведений.НастройкаСинхронизацииОбъектовСВнешнимиСистемами.Форма.ФормаНастроекСинхронизацииОбъекта", ПараметрыФормы, ПараметрыВыполненияКоманды.Источник, ПараметрыВыполненияКоманды.Уникальность, ПараметрыВыполненияКоманды.Окно, ПараметрыВыполненияКоманды.НавигационнаяСсылка);
КонецПроцедуры
