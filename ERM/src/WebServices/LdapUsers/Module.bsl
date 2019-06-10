
Функция getUserByEmail(email)
	
	ПользовательИМенеджерXDTO = ПолучитьОбъектXDTO("userAndDirectManager");
	
	ПользовательLDAP = Справочники.LDAPUsers.НайтиПоEmail(email);
	
	Если Не ЗначениеЗаполнено(ПользовательLDAP) Тогда
		Возврат ПользовательИМенеджерXDTO;
	КонецЕсли;
	
	ПользовательИМенеджерXDTO.user = ПользовательLdapВXDTO(ПользовательLDAP);
	
	Менеджер = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ПользовательLDAP, "DirectManager");
	Если ЗначениеЗаполнено(Менеджер) Тогда
		ПользовательИМенеджерXDTO.directManager = ПользовательLdapВXDTO(Менеджер);
	КонецЕсли;
	
	Возврат ПользовательИМенеджерXDTO;
	
КонецФункции

Функция ПолучитьОбъектXDTO(Имя) Экспорт
	
	ПространствоИмен = Метаданные.WebСервисы.LdapUsers.ПространствоИмен;
	ТипПоля = ФабрикаXDTO.Тип(ПространствоИмен, Имя);
	Возврат ФабрикаXDTO.Создать(ТипПоля);
	
КонецФункции

Функция ПользовательLdapВXDTO(ПользовательLDAP, СтруктураРеквизитов = Неопределено)
	
	Если СтруктураРеквизитов = Неопределено Тогда
		СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ПользовательLDAP, "Наименование, DisplayName, Department, 
			|Mail, TelephoneNumber, Blocked, JobTitle, CN, ManagerDN, DirectManager");
	КонецЕсли;
	
	ПользовательXDTO = ПолучитьОбъектXDTO("user");
	ПользовательXDTO.alias = СтруктураРеквизитов.Наименование;
	ПользовательXDTO.displayName = СтруктураРеквизитов.DisplayName;
	ПользовательXDTO.department = СтруктураРеквизитов.Department;
	ПользовательXDTO.mail = СтруктураРеквизитов.Mail;
	ПользовательXDTO.telephoneNumber = СтруктураРеквизитов.TelephoneNumber;
	ПользовательXDTO.blocked = СтруктураРеквизитов.Blocked;
	ПользовательXDTO.jobTitle = СтруктураРеквизитов.JobTitle;
	ПользовательXDTO.cn = СтруктураРеквизитов.CN;
	ПользовательXDTO.managerDN = СтруктураРеквизитов.ManagerDN;
	ПользовательXDTO.guid = Строка(ПользовательLDAP.УникальныйИдентификатор());
	ПользовательXDTO.managerGuid = Строка(СтруктураРеквизитов.DirectManager.УникальныйИдентификатор());
	
	Возврат ПользовательXDTO;
	
КонецФункции

Функция getAllUsers()
	
	СписокПользователей = ПолучитьОбъектXDTO("users");
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	LDAPUsers.Ссылка КАК Ссылка,
	               |	LDAPUsers.DisplayName КАК DisplayName,
	               |	LDAPUsers.Department КАК Department,
	               |	LDAPUsers.Mail КАК Mail,
	               |	LDAPUsers.TelephoneNumber КАК TelephoneNumber,
	               |	LDAPUsers.Blocked КАК Blocked,
	               |	LDAPUsers.JobTitle КАК JobTitle,
	               |	LDAPUsers.CN КАК CN,
	               |	LDAPUsers.ManagerDN КАК ManagerDN,
	               |	LDAPUsers.DirectManager КАК DirectManager,
	               |	LDAPUsers.Наименование КАК Наименование
	               |ИЗ
	               |	Справочник.LDAPUsers КАК LDAPUsers
	               |ГДЕ
	               |	НЕ LDAPUsers.ЭтоГруппа
	               |	И НЕ LDAPUsers.ПометкаУдаления";
	
	НачатьТранзакцию();
	Результат = Запрос.Выполнить();
	ЗафиксироватьТранзакцию();
	Если Результат.Пустой() Тогда
		Возврат СписокПользователей;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		СписокПользователей.user.Добавить(ПользовательLdapВXDTO(Выборка.Ссылка, Выборка));
	КонецЦикла;
	
	Возврат СписокПользователей;
	
КонецФункции
