#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла",  ПараметрКоманды);
	ПараметрыФормы.Вставить("ТолькоПросмотр", ПараметрыВыполненияКоманды.Источник.ТолькоПросмотр);
	
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ДвоичныеДанныеФайлов",
	             ПараметрыФормы,
	             ПараметрыВыполненияКоманды.Источник,
	             ПараметрыВыполненияКоманды.Уникальность,
	             ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти
