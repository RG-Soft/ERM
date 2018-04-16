
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	BilledAR.ВидДвижения,
		|	BilledAR.Client,
		|	BilledAR.Company,
		|	BilledAR.Source,
		|	BilledAR.Location,
		|	BilledAR.SubSubSegment,
		|	BilledAR.Invoice,
		|	BilledAR.Account,
		|	BilledAR.Currency,
		|	BilledAR.AU,
		|	BilledAR.Amount,
		|	BilledAR.BaseAmount
		|ИЗ
		|	РегистрНакопления.BilledAR КАК BilledAR
		|ГДЕ
		|	BilledAR.Регистратор В(&МассивТранзакцийMemoClosing)
		|	И BilledAR.Активность
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	BilledAR.ВидДвижения,
		|	BilledAR.Client,
		|	BilledAR.Company,
		|	BilledAR.Source,
		|	BilledAR.Location,
		|	BilledAR.SubSubSegment,
		|	BilledAR.Invoice,
		|	BilledAR.Account,
		|	BilledAR.Currency,
		|	BilledAR.AU,
		|	BilledAR.Amount,
		|	BilledAR.BaseAmount,
		|	BilledAR.Регистратор
		|ИЗ
		|	РегистрНакопления.BilledAR КАК BilledAR
		|ГДЕ
		|	BilledAR.Регистратор В(&МассивТранзакцийInvoiceClosing)
		|	И BilledAR.Активность";
	
	Запрос.УстановитьПараметр("МассивТранзакцийInvoiceClosing", InvoiceClosing.ВыгрузитьКолонку("Transaction"));
	Запрос.УстановитьПараметр("МассивТранзакцийMemoClosing", MemoClosing.ВыгрузитьКолонку("Transaction"));
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	ВыборкаMemoClosing = МассивРезультатов[0].Выбрать();
	ВыборкаInvoiceClosing = МассивРезультатов[1].Выбрать();
	
	Пока ВыборкаMemoClosing.Следующий() Цикл
		
		ТекДвижение = Движения.BilledAR.Добавить();
		ЗаполнитьЗначенияСвойств(ТекДвижение, ВыборкаMemoClosing);
		ТекДвижение.Период = Дата;
		ТекДвижение.ВидДвижения = ?(ВыборкаMemoClosing.ВидДвижения = ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход, ВидДвиженияНакопления.Приход);
		
		ТекДвижение = Движения.UnallocatedMemo.Добавить();
		ЗаполнитьЗначенияСвойств(ТекДвижение, ВыборкаMemoClosing);
		ТекДвижение.Период = Дата;
		ТекДвижение.Memo = Memo;
		
	КонецЦикла;
	
	СоответствиеТранзакцийИИнвойсов = Новый Соответствие;
	Для каждого СтрокаТЧ Из InvoiceClosing Цикл
		СоответствиеТранзакцийИИнвойсов.Вставить(СтрокаТЧ.Transaction, СтрокаТЧ.Invoice);
	КонецЦикла;
	
	Пока ВыборкаInvoiceClosing.Следующий() Цикл
		
		ТекДвижение = Движения.BilledAR.Добавить();
		ЗаполнитьЗначенияСвойств(ТекДвижение, ВыборкаInvoiceClosing);
		ТекДвижение.Период = Дата;
		ТекДвижение.ВидДвижения = ?(ВыборкаInvoiceClosing.ВидДвижения = ВидДвиженияНакопления.Приход, ВидДвиженияНакопления.Расход, ВидДвиженияНакопления.Приход);
		
		ТекДвижение = Движения.BilledAR.Добавить();
		ЗаполнитьЗначенияСвойств(ТекДвижение, ВыборкаInvoiceClosing);
		ТекДвижение.Период = Дата;
		ТекДвижение.Invoice = СоответствиеТранзакцийИИнвойсов[ВыборкаInvoiceClosing.Регистратор];
		
	КонецЦикла;
	
	Движения.BilledAR.Записывать = Истина;
	Движения.UnallocatedMemo.Записывать = Истина;
	
КонецПроцедуры
