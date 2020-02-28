#Область ПрограммныйИнтерфейс

// Позволяет изменить работу интерфейса при встраивании.
//
// Параметры:
//  НастройкиРаботыИнтерфейса - Структура - содержит свойство:
//   * ИспользоватьВнешнихПользователей - Булево - (начальное значение Ложь),
//     если установить Истина, тогда даты запрета можно будет настраивать для внешних пользователей.
//
Процедура НастройкаИнтерфейса(НастройкиРаботыИнтерфейса) Экспорт
	
	
	
КонецПроцедуры

// Заполняет разделы дат запрета изменения, используемые при настройке дат запрета.
// Если не указать ни одного раздела, тогда будет доступна только настройка общей даты запрета.
//
// Параметры:
//  Разделы - ТаблицаЗначений - с колонками:
//   * Имя - Строка - имя используемое в описании источников данных в
//       процедуре ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
//
//   * Идентификатор - УникальныйИдентификатор - идентификатор ссылки элемента плана видов характеристик.
//       Чтобы получить идентификатор нужно в режиме 1С:Предприятия выполнить метод платформы:
//       "ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПолучитьСсылку().УникальныйИдентификатор()".
//       Не следует указывать идентификаторы, полученные любым другим способом,
//       так как это может нарушить их уникальность.
//
//   * Представление - Строка - представляет раздел в форме настройки дат запрета.
//
//   * ТипыОбъектов  - Массив - типы ссылок объектов в разрезе которых можно настроить даты запрета,
//       например, Тип("СправочникСсылка.Организации"), если не указано ни одного типа,
//       то даты запрета будут настраиваться только с точностью до раздела.
//
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	Раздел = Разделы.Добавить();
	Раздел.Имя  = "Source";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("71369a24-8a96-11e6-ba34-e83935eebc72");
	Раздел.Представление = "Source";
	Раздел.ТипыОбъектов.Добавить(Тип("ПеречислениеСсылка.ТипыСоответствий"));
	
	Раздел = Разделы.Добавить();
	Раздел.Имя  = "GeoMarket";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("71369a25-8a96-11e6-ba34-e83935eebc72");
	Раздел.Представление = "Geo Market";
	Раздел.ТипыОбъектов.Добавить(Тип("ПеречислениеСсылка.ТипыСоответствий"));
	
КонецПроцедуры

// Позволяет задать таблицы и поля объектов для проверки запрета изменения данных.
// Для добавления нового источника в ИсточникиДанных см. ДатыЗапретаИзменения.ДобавитьСтроку.
//
// Вызывается из процедуры ИзменениеЗапрещено общего модуля ДатыЗапретаИзменения,
// используемой в подписке на событие ПередЗаписью объекта для проверки наличия
// запретов и отказа от изменений запрещенного объекта.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений - с колонками:
//   * Таблица     - Строка - полное имя объекта метаданных,
//                   например, Метаданные.Документы.ПриходнаяНакладная.ПолноеИмя().
//   * ПолеДаты    - Строка - имя реквизита объекта или табличной части,
//                   например "Дата", "Товары.ДатаОтгрузки".
//   * Раздел      - Строка - имя раздела дат запрета, указанного в
//                   процедуре ПриЗаполненииРазделовДатЗапретаИзменения (см. выше).
//   * ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части,
//                   например "Организация", "Товары.Склад".
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.UnbilledAR"                                           , "Период", "Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.BilledAR"                                             , "Период", "Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.UnallocatedCash"                                      , "Период", "Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ManualTransactions"                                   , "Период", "Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.UnallocatedMemo"                                      , "Период", "Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.Payments"                                             , "Период", "Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.Revenue"                                              , "Период", "Source", "Source");
	//ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.HFMAdjAR"                                             , "Период", "Source", "Source");
	//ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.HFMAdjRevenue"                                        , "Период", "Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.Billing"                                                , "Период","Source", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.DIR"                                                    , "ПериодДействия", "Source", "Invoice.Source");
	
	//ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "Документ.Invoice"                                                  , "Дата" , "БухгалтерскийУчет", "Организация");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.UnbilledAR"                                           , "Период", "GeoMarket", "Location.БазовыйЭлемент.GeoMarket.Родитель");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.BilledAR"                                             , "Период", "GeoMarket", "Location.БазовыйЭлемент.GeoMarket.Родитель");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.UnallocatedCash"                                      , "Период", "GeoMarket", "Location.БазовыйЭлемент.GeoMarket.Родитель");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.ManualTransactions"                                   , "Период", "GeoMarket", "Location.БазовыйЭлемент.GeoMarket.Родитель");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.UnallocatedMemo"                                      , "Период", "GeoMarket", "Location.БазовыйЭлемент.GeoMarket.Родитель");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.Payments"                                             , "Период", "GeoMarket", "Location.БазовыйЭлемент.GeoMarket.Родитель");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.Revenue"                                              , "Период", "GeoMarket", "Source");
	//ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.HFMAdjAR"                                             , "Период", "GeoMarket", "Source");
	//ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрНакопления.HFMAdjRevenue"                                        , "Период", "GeoMarket", "Source");
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.Billing"                                                , "Период","GeoMarket", "AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель" );
	ДатыЗапретаИзменения.ДобавитьСтроку(ИсточникиДанных, "РегистрСведений.DIR"                                                    , "ПериодДействия", "GeoMarket", "Invoice.AU.ПодразделениеОрганизации.БазовыйЭлемент.GeoMarket.Родитель");
	
КонецПроцедуры

// Позволяет переопределить выполнение проверки запрета изменения произвольным образом.
//
// Если проверка выполняется в процессе записи документа, то в свойстве ДополнительныеСвойства документа Объект
// имеется свойство РежимЗаписи.
//  
// Параметры:
//  Объект       - СправочникОбъект,
//                 ДокументОбъект,
//                 ПланВидовХарактеристикОбъект,
//                 ПланСчетовОбъект,
//                 ПланВидовРасчетаОбъект,
//                 БизнесПроцессОбъект,
//                 ЗадачаОбъект,
//                 ПланОбменаОбъект, 
//                 РегистрСведенийНаборЗаписей,
//                 РегистрНакопленияНаборЗаписей,
//                 РегистрБухгалтерииНаборЗаписей,
//                 РегистрРасчетаНаборЗаписей - проверяемый элемент данных или набор записей 
//                 (который передается из обработчиков ПередЗаписью и ПриЧтенииНаСервере).
//
//  ПроверкаЗапретаИзменения    - Булево - установить в Ложь, чтобы пропустить проверку запрета изменения данных.
//  УзелПроверкиЗапретаЗагрузки - ПланыОбменаСсылка, Неопределено - установить в Неопределено, чтобы 
//                                пропустить проверку запрета загрузки данных.
//  ВерсияОбъекта               - Строка - установить "СтараяВерсия" или "НоваяВерсия", чтобы
//                                выполнить проверку только старой (в базе данных) 
//                                или только новой версии объекта (в параметре Объект).
//                                По умолчанию содержит значение "" - проверяются обе версии объекта сразу.
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
