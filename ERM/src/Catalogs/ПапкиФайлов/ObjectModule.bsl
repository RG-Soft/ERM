#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяПапка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка,
		"Наименование, Родитель, ПометкаУдаления");
	
	Если ЭтоНовый() Или ТекущаяПапка.Родитель <> Родитель Тогда
		// Проверка права "Добавление".
		Если НЕ РаботаСФайламиСлужебный.ЕстьПраво("ИзменениеПапок", Родитель) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Недостаточно прав для добавления подпапок в папку файлов ""%1"".'"),
				Строка(Родитель));
		КонецЕсли;
	КонецЕсли;
	
	Если ПометкаУдаления И ТекущаяПапка.ПометкаУдаления <> Истина Тогда
		
		// Проверка права "Пометка на удаление".
		Если НЕ РаботаСФайламиСлужебный.ЕстьПраво("ИзменениеПапок", Ссылка) Тогда
			ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Недостаточно прав для изменения папки файлов ""%1"".'"),
				Строка(Ссылка));
		КонецЕсли;
	КонецЕсли;
	
	Если ПометкаУдаления <> ТекущаяПапка.ПометкаУдаления И Не Ссылка.Пустая() Тогда
		// Отбираем файлы и пытаемся поставить им пометку удаления.
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	Файлы.Ссылка,
			|	Файлы.Редактирует
			|ИЗ
			|	Справочник.Файлы КАК Файлы
			|ГДЕ
			|	Файлы.ВладелецФайла = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		
		Результат = Запрос.Выполнить();
		Выборка = Результат.Выбрать();
		Пока Выборка.Следующий() Цикл
			Если ЗначениеЗаполнено(Выборка.Редактирует) Тогда
				ВызватьИсключение СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				                     НСтр("ru = 'Папку %1 нельзя удалить, т.к. она содержит файл ""%2"", занятый для редактирования.'"),
				                     Строка(Ссылка),
				                     Строка(Выборка.Ссылка));
			КонецЕсли;

			ФайлОбъект = Выборка.Ссылка.ПолучитьОбъект();
			ФайлОбъект.Заблокировать();
			ФайлОбъект.УстановитьПометкуУдаления(ПометкаУдаления);
		КонецЦикла;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПрошлыйЭтоНовый", ЭтоНовый());
	
	Если НЕ ЭтоНовый() Тогда
		
		Если Наименование <> ТекущаяПапка.Наименование Тогда // переименована папка
			РабочийКаталогПапки         = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Ссылка);
			РабочийКаталогРодителяПапки = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(ТекущаяПапка.Родитель);
			Если РабочийКаталогРодителяПапки <> "" Тогда
				
				// Добавляем слэш в конце, если его нет.
				РабочийКаталогРодителяПапки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
					РабочийКаталогРодителяПапки);
				
				РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогРодителяПапки
					+ ТекущаяПапка.Наименование + ПолучитьРазделительПути();
					
				Если РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогПапки Тогда
					
					НовыйРабочийКаталогПапки = РабочийКаталогРодителяПапки
						+ Наименование + ПолучитьРазделительПути();
					
					РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Ссылка, НовыйРабочийКаталогПапки);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Родитель <> ТекущаяПапка.Родитель Тогда // Перенесли папку в другую папку.
			РабочийКаталогПапки               = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Ссылка);
			РабочийКаталогРодителяПапки       = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(ТекущаяПапка.Родитель);
			РабочийКаталогНовогоРодителяПапки = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Родитель);
			
			Если РабочийКаталогРодителяПапки <> "" ИЛИ РабочийКаталогНовогоРодителяПапки <> "" Тогда
				
				РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогРодителяПапки;
				
				Если РабочийКаталогРодителяПапки <> "" Тогда
					РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогРодителяПапки
						+ ТекущаяПапка.Наименование + ПолучитьРазделительПути();
				КонецЕсли;
				
				// Рабочий каталог автоформируется от родителя.
				Если РабочийКаталогПапкиУнаследованныйПрежний = РабочийКаталогПапки Тогда
					Если РабочийКаталогНовогоРодителяПапки <> "" Тогда
						
						НовыйРабочийКаталогПапки = РабочийКаталогНовогоРодителяПапки
							+ Наименование + ПолучитьРазделительПути();
						
						РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Ссылка, НовыйРабочийКаталогПапки);
					Иначе
						РаботаСФайламиСлужебныйВызовСервера.ОчиститьРабочийКаталог(Ссылка);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеСвойства.ПрошлыйЭтоНовый Тогда
		РабочийКаталогПапки = РаботаСФайламиСлужебныйВызовСервера.РабочийКаталогПапки(Родитель);
		Если РабочийКаталогПапки <> "" Тогда
			
			// Добавляем слэш в конце, если его нет.
			РабочийКаталогПапки = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(
				РабочийКаталогПапки);
			
			РабочийКаталогПапки = РабочийКаталогПапки
				+ Наименование + ПолучитьРазделительПути();
			
			РаботаСФайламиСлужебныйВызовСервера.СохранитьРабочийКаталогПапки(Ссылка, РабочийКаталогПапки);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	ДатаСоздания = ТекущаяДатаСеанса();
	Ответственный = Пользователи.ТекущийПользователь();
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	МассивНайденныхНедопустимыхСимволов = ОбщегоНазначенияКлиентСервер.НайтиНедопустимыеСимволыВИмениФайла(Наименование);
	Если МассивНайденныхНедопустимыхСимволов.Количество() <> 0 Тогда
		Отказ = Истина;
		
		Текст = НСтр("ru = 'Наименование папки содержит запрещенные символы ( \ / : * ? "" < > | .. )'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(Текст, ЭтотОбъект, "Наименование");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли