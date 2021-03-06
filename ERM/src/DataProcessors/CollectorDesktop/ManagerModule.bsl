#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
Процедура СформироватьВложениеПоЭкалированнымИнвойсам(СтруктураПараметров, МассивИнвойсовДляЭскалации) Экспорт
	
	Если МассивИнвойсовДляЭскалации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДанных = ПолучитьТаблицуДанныхПоЭкалированнымИнвойсам(МассивИнвойсовДляЭскалации, СтруктураПараметров);
	
	ТабДок = Новый ТабличныйДокумент;
	
	Построитель = Новый ПостроительОтчета();
	
	Если ТаблицаДанных.Количество() > 0 Тогда
		
		Построитель.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаДанных);
		Построитель.ВыводитьЗаголовокОтчета = Ложь;
		Построитель.Вывести(ТабДок);
		
		Каталог = КаталогВременныхФайлов();
		
		ИмяФайла = Каталог + "Invoices.xls";
		
		ТабДок.Записать(ИмяФайла, ТипФайлаТабличногоДокумента.XLS);
		
		ПриложенныеФайлы = Новый Массив();
		ПриложенныеФайлы.Добавить(Новый Структура("ИмяФайла, РасширениеФайла, ДанныеФайла", "Invoices", "xls", ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ИмяФайла), Новый УникальныйИдентификатор())));
		СтруктураПараметров.Вставить("ПриложенныеФайлы", ПриложенныеФайлы);
		
		УдалитьФайлы(ИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьBodyПоЭкалированнымИнвойсам(СтруктураПараметров, МассивИнвойсовДляЭскалации) Экспорт
	
	Если МассивИнвойсовДляЭскалации.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ТаблицаДанных = ПолучитьТаблицуДанныхПоЭкалированнымИнвойсам(МассивИнвойсовДляЭскалации, СтруктураПараметров);
	
	ТелоHTMLТаблицаДанных = "<BR>
	|<TABLE style=""border-collapse: collapse;width:84.2%;border:solid black 1pt"">
	|<TBODY>
	|<TR align=""center"" style=""width:6.38%;background:#004D99;padding:1.5pt 1.5pt 1.5pt 1.5pt;font-size:10pt;font-family:Tahoma,sans-serif;color:white;"">
	//|<TD style=""padding: 5px; border: 2px solid #000;"">InvNo</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">InvDate</TD>
	|<TD style=""padding: 5px; border: 2px solid #000;"">Company Name</TD>
	|<TD style=""padding: 5px; border: 2px solid #000;"">FiscalInvoiceNo</TD>
	|<TD style=""padding: 5px; border: 2px solid #000;"">FiscalInvoiceDate</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">CRMID</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">Client</TD>
	|<TD style=""padding: 5px; border: 2px solid #000;"">Currency</TD>
	|<TD style=""padding: 5px; border: 2px solid #000;"">Amount</TD>
	|<TD style=""padding: 5px; border: 2px solid #000;"">Remaining amount</TD>
	|<TD style=""padding: 5px; border: 2px solid #000;"">Agreement</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">AmountUSD</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">Status</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">ConfirmedBy</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">ForecastDate</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">InitialForecastDate</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">CustomerRepresentative</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">CustomerInputDetails</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">RemedialWorkPlan</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">RWDTargetDate</TD>
	//|<TD style=""padding: 5px; border: 2px solid #000;"">Comment</TD>
	|</TR>";
	
	Для каждого СтрокаДанных Из ТаблицаДанных Цикл
		
		СтрокаВТелоСообщения = "<TR>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.InvNo + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.InvDate + "</TD>
		|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.CompanyName + "</TD>
		|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.FiscalInvoiceNo + "</TD>
		|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + ?(ЗначениеЗаполнено(СтрокаДанных.FiscalInvoiceDate), Формат(СтрокаДанных.FiscalInvoiceDate, "ДФ=MM/dd/yyyy"),"") + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.CRMID + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.Client + "</TD>
		|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.Currency + "</TD>
		|<TD style=""padding: 5px; text-align: right; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.Amount + "</TD>
		|<TD style=""padding: 5px; text-align: right; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.RemainingАmount + "</TD>
		|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.Agreement + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.AmountUSD + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.Status + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.ConfirmedBy + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.ForecastDate + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.InitialForecastDate + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.CustomerRepresentative + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.CustomerInputDetails + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.RemedialWorkPlan + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.RWDTargetDate + "</TD>
		//|<TD style=""padding: 5px; border: 2px solid #000; white-space: nowrap;"">" + СтрокаДанных.Comment + "</TD>
		|</TR>";
		ТелоHTMLТаблицаДанных = ТелоHTMLТаблицаДанных + СтрокаВТелоСообщения;
			
	КонецЦикла;
	
	ТелоHTMLТаблицаДанных = ТелоHTMLТаблицаДанных + "</TABLE><BR>";
	
	СтруктураПараметров.Вставить("ТелоHTMLТаблицаДанных", ТелоHTMLТаблицаДанных);
	
КонецПроцедуры

Функция ПолучитьТаблицуДанныхПоЭкалированнымИнвойсам(МассивИнвойсовДляЭскалации, СтруктураПараметров)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	InvoiceДокумент.DocNumber КАК InvNo,
		|	InvoiceДокумент.Дата КАК InvDate,
		|	InvoiceДокумент.FiscalInvoiceNo КАК FiscalInvoiceNo,
		|	InvoiceДокумент.FiscalInvoiceDate КАК FiscalInvoiceDate,
		|	InvoiceДокумент.Client.CRMID КАК CRMID,
		|	InvoiceДокумент.Client КАК Client,
		|	InvoiceДокумент.Company КАК Company,
		|	InvoiceДокумент.Company.Наименование КАК CompanyName,
		|	InvoiceДокумент.Currency КАК Currency,
		|	ВЫБОР
		|		КОГДА InvoiceДокумент.Contract = ЗНАЧЕНИЕ(Справочник.ДоговорыКонтрагентов.ПустаяСсылка)
		|				ИЛИ InvoiceДокумент.Contract.Ссылка ЕСТЬ NULL
		|			ТОГДА InvoiceДокумент.Agreement
		|		ИНАЧЕ InvoiceДокумент.Contract.crmContractName
		|	КОНЕЦ КАК Agreement,
		|	InvoiceДокумент.Amount КАК Amount,
		|	ВЫРАЗИТЬ(InvoiceДокумент.Amount / ВнутренниеКурсыВалютСрезПоследних.Курс * ВнутренниеКурсыВалютСрезПоследних.Кратность КАК ЧИСЛО(15, 2)) КАК AmountUSD,
		|	InvoiceCommentsСрезПоследних.Problem.Status КАК Status,
		|	InvoiceCommentsСрезПоследних.Problem.ConfirmedBy КАК ConfirmedBy,
		|	InvoiceCommentsСрезПоследних.Problem.ForecastDate КАК ForecastDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustInputDate КАК InitialForecastDate,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerRepresentative КАК CustomerRepresentative,
		|	InvoiceCommentsСрезПоследних.Problem.CustomerInputDetails КАК CustomerInputDetails,
		|	InvoiceCommentsСрезПоследних.Problem.RemedialWorkPlan КАК RemedialWorkPlan,
		|	InvoiceCommentsСрезПоследних.Problem.RWDTargetDate КАК RWDTargetDate,
		|	InvoiceCommentsСрезПоследних.Problem.Comment КАК Comment,
		|	InvoiceДокумент.Ссылка КАК СсылкаInvoice
		|ПОМЕСТИТЬ ВТ_ДанныеПоИнвойсу
		|ИЗ
		|	Документ.Invoice КАК InvoiceДокумент
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВнутренниеКурсыВалют.СрезПоследних КАК ВнутренниеКурсыВалютСрезПоследних
		|		ПО InvoiceДокумент.Currency = ВнутренниеКурсыВалютСрезПоследних.Валюта
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.InvoiceComments.СрезПоследних(, Invoice В (&МассивИнвойсов)) КАК InvoiceCommentsСрезПоследних
		|		ПО InvoiceДокумент.Ссылка = InvoiceCommentsСрезПоследних.Invoice
		|ГДЕ
		|	InvoiceДокумент.Ссылка В(&МассивИнвойсов)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВТ_ДанныеПоИнвойсу.InvNo КАК InvNo,
		|	ВТ_ДанныеПоИнвойсу.InvDate КАК InvDate,
		|	ВТ_ДанныеПоИнвойсу.FiscalInvoiceNo КАК FiscalInvoiceNo,
		|	ВТ_ДанныеПоИнвойсу.FiscalInvoiceDate КАК FiscalInvoiceDate,
		|	ВТ_ДанныеПоИнвойсу.CRMID КАК CRMID,
		|	ВТ_ДанныеПоИнвойсу.Client КАК Client,
		|	ВТ_ДанныеПоИнвойсу.Company КАК Company,
		|	ВТ_ДанныеПоИнвойсу.CompanyName КАК CompanyName,
		|	ВТ_ДанныеПоИнвойсу.Currency КАК Currency,
		|	ВТ_ДанныеПоИнвойсу.Agreement КАК Agreement,
		|	ВТ_ДанныеПоИнвойсу.Amount КАК Amount,
		|	ВТ_ДанныеПоИнвойсу.AmountUSD КАК AmountUSD,
		|	BilledARОстатки.AmountОстаток КАК RemainingАmount,
		|	ВТ_ДанныеПоИнвойсу.Status КАК Status,
		|	ВТ_ДанныеПоИнвойсу.ConfirmedBy КАК ConfirmedBy,
		|	ВТ_ДанныеПоИнвойсу.ForecastDate КАК ForecastDate,
		|	ВТ_ДанныеПоИнвойсу.InitialForecastDate КАК InitialForecastDate,
		|	ВТ_ДанныеПоИнвойсу.CustomerRepresentative КАК CustomerRepresentative,
		|	ВТ_ДанныеПоИнвойсу.CustomerInputDetails КАК CustomerInputDetails,
		|	ВТ_ДанныеПоИнвойсу.RemedialWorkPlan КАК RemedialWorkPlan,
		|	ВТ_ДанныеПоИнвойсу.RWDTargetDate КАК RWDTargetDate,
		|	ВТ_ДанныеПоИнвойсу.Comment КАК Comment
		|ИЗ
		|	ВТ_ДанныеПоИнвойсу КАК ВТ_ДанныеПоИнвойсу
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.BilledAR.Остатки(&ПериодОстатков, ) КАК BilledARОстатки
		|		ПО ВТ_ДанныеПоИнвойсу.СсылкаInvoice = BilledARОстатки.Invoice";
	
	Запрос.УстановитьПараметр("МассивИнвойсов", МассивИнвойсовДляЭскалации);
	Запрос.УстановитьПараметр("ПериодОстатков", СтруктураПараметров.Период);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции

#КонецЕсли