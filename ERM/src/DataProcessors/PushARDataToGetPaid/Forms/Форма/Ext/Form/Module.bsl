
&НаКлиенте
Процедура КаталогВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогВыбора = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	
	Если Не ПустаяСтрока(КаталогВыгрузки) Тогда
		ДиалогВыбора.Каталог = КаталогВыгрузки;
	КонецЕсли;
	Если ДиалогВыбора.Выбрать() Тогда
		КаталогВыгрузки = ДиалогВыбора.Каталог;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ВыгрузитьДанныеНаСервере()
	
	ИмяКаталога = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор());
	СоздатьКаталог(ИмяКаталога);
	ПутьКФайлу = ИмяКаталога + "\DSS.txt";
	//ФайлДанных.Записать(ПутьКФайлу);
	ТД = Новый ТекстовыйДокумент;
	ТД.Записать(ПутьКФайлу);
	
	ПутьСхемы = ИмяКаталога+"\schema.ini";
	ФайлСхемы = Новый ТекстовыйДокумент;
	//ФайлСхемы.ДобавитьСтроку("["+ "DSS.txt" +"]" + Символы.ПС + "DecimalSymbol=.");
	ФайлСхемы.УстановитьТекст();
	ФайлСхемы.Записать(ПутьСхемы, КодировкаТекста.OEM);
	
	Connection = Новый COMОбъект("ADODB.Connection");
	
	Попытка
		СтрокаПодключения = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1;""";
		Connection.Open(СтрокаПодключения);
	Исключение
		Попытка
			СтрокаПодключения = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + ИмяКаталога + ";Extended Properties=""text;HDR=NO;IMEX=1""";
			Connection.Open(СтрокаПодключения);
		Исключение
			ВызватьИсключение "Can't open connection! " + ОписаниеОшибки();
		КонецПопытки;		
	КонецПопытки;
	
	rs = Новый COMObject("ADODB.RecordSet");
	
КонецПроцедуры

&НаКлиенте
Процедура ВыгрузитьДанные(Команда)
	ВыгрузитьДанныеНаСервере();
КонецПроцедуры

Функция ОписаниеПоляТранзакции(FieldName, Length, Dec, StartPosition, EndPosition, Type, Required, Notes)
	
	ОписаниеПоля = Новый Структура("FieldName, Length, Dec, StartPosition, EndPosition, Type, Required, Notes",
		FieldName, Length, Dec, StartPosition, EndPosition, Type, Required, Notes);
	
	Возврат ОписаниеПоля;
	
КонецФункции

Функция ОписаниеСтруктурыARMAST()
	
	ОписаниеСтруктурыARMAST = Новый Структура;
	
	ОписаниеПоля = ОписаниеПоляТранзакции("CUSTNO", 20, 0, 1, 20, "С", Истина, "Unique, all upper case, left justified");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("INVNO", 20, 0, 21, 40, "С", Истина, "Unique, all upper case, left justified");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("INVDTE", 8, 0, 41, 48, "D", Ложь, "Date that customer transaction originated");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("BALANCE", 20, 2, 49, 68, "N", Истина, "Send in Base Currency. Use negative for credit, unapplied payment, on-account payment, or any credit balance transaction");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("PNET", 4, 0, 69, 72, "N", Ложь, "Number of days after invoice date that the invoice becomes due");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("INVAMT", 20, 2, 73, 92, "N", Истина, "Send in Base Currency. Original amount of transaction");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("REFNO", 30, 0, 93, 122, "С", Ложь, "Will display on the GETPAID screen for each transaction.");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("PONUM", 54, 0, 123, 176, "С", Ложь, "A/R system populated transaction purchase order identification value");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("DIVISION", 10, 0, 177, 186, "С", Ложь, "Profit center or multi-company identifier");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("TAX", 20, 2, 187, 206, "N", Истина, "Sales tax amount for this transaction; use a value of zero if sales tax appears as a line item in ARTRAN.TXT");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FREIGHT", 20, 2, 207, 226, "N", Ложь, "Freight amount for this transaction; use a value of zero if freight appears as a line item in ARTRAN.TXT");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("OTHER", 20, 2, 227, 246, "N", Ложь, "Other charges amount for this transaction; use a value of zero if other charges appear as a line item in ARTRAN.TXT");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("ARSTAT", 1, 0, 247, 247, "С", Истина, "Valid transaction types: I = invoice, C = credit, D = debit, B = balance forward, U = unapplied payment, O = on-account payment, F = financial charge.");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("CHECKNUM", 20, 0, 248, 267, "С", Ложь, "Check applied for creation of short payment");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("PROBNUM", 10, 0, 268, 277, "С", Ложь, "Pre-existing Problem record for credits");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("REASCODE", 10, 0, 278, 287, "С", Ложь, "Customer’s reason for short payment");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("SALESPN", 10, 0, 288, 297, "С", Ложь, "Sales person identified on this invoice");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("CONTACTID", 10, 0, 298, 307, "С", Ложь, "For multiple ship-to locations");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("SRCINVOICE", 20, 0, 308, 327, "С", Ложь, "To research short payment transactions");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("TRANCURR", 10, 0, 328, 337, "С", Ложь, "Currency of the transaction");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("TRANORIG", 20, 2, 338, 357, "N", Истина, "Original amount of source transactions in transaction currency");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("TRANBAL", 20, 2, 358, 377, "N", Истина, "Balance in transaction currency");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("LOCORIG", 20, 2, 378, 397, "N", Истина, "Original amount of source transaction in local currency");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("LOCBAL", 20, 2, 398, 417, "N", Истина, "Transaction balance in local currency");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("DIVCODE", 10, 0, 418, 427, "С", Ложь, "Required for automatic assignment of resolvers");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("SALESAREA", 10, 0, 428, 437, "С", Ложь, "Required for reports - Populate with Area1 if data is not available");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD1", 50, 0, 438, 487, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD2", 50, 0, 488, 537, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD3", 50, 0, 538, 587, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD4", 50, 0, 588, 637, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD5", 50, 0, 638, 687, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXNUM1", 20, 2, 688, 707, "N", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXNUM2", 20, 2, 708, 727, "N", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXNUM3", 20, 2, 728, 747, "N", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXNUM4", 20, 2, 748, 767, "N", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXNUM5", 20, 2, 768, 787, "N", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXDATE1", 8, 0, 788, 795, "D", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXDATE2", 8, 0, 796, 803, "D", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXDATE3", 8, 0, 804, 811, "D", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXDATE4", 8, 0, 812, 819, "D", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXDATE5", 8, 0, 820, 827, "D", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("DISCODE", 10, 0, 828, 837, "С", Истина, "Not used in GETPaid.");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("ARTARGETSYSTEM", 10, 0, 838, 847, "С", Истина, "Not used in GETPaid.");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD6", 50, 0, 848, 897, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD7", 50, 0, 898, 947, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD8", 50, 0, 948, 997, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD9", 50, 0, 998, 1047, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD10", 50, 0, 1048, 1097, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD11", 50, 0, 1098, 1147, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD12", 50, 0, 1148, 1197, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD13", 50, 0, 1198, 1247, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD14", 50, 0, 1248, 1297, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("FLEXFIELD15", 50, 0, 1298, 1347, "С", Ложь, "Optional Field");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("GA_JOURNAL_ID", 10, 0, 1348, 1357, "N", Ложь, "Used with GETApplied");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("NONDISCTAX", 20, 2, 1358, 1377, "N", Ложь, "Used with GETApplied to identify the tax amount on the invoice to exclude from the prompt payment discount calculation");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("NONDISCFREIGHT", 20, 2, 1378, 1397, "N", Ложь, "Used with GETApplied to identify the freight amount on the invoice to exclude from the prompt payment discount calculation");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("NONDISCOTHER", 20, 2, 1398, 1417, "N", Ложь, "Used with GETApplied to identify the other amount on the invoice to exclude from the prompt payment discount calculation");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	ОписаниеПоля = ОписаниеПоляТранзакции("INV_INTEREST_RATE", 20, 2, 1418, 1437, "N", Ложь, "Invoice Interest Rate being charged on invoice late payments.");
	ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	//ОписаниеПоля = ОписаниеПоляТранзакции("INVNO", 20, 0, 21, 40, "С", Истина, "Unique, all upper case, left justified");
	//ОписаниеСтруктурыARMAST.Вставить(ОписаниеПоля.FiledName, ОписаниеПоля);
	
	Возврат ОписаниеСтруктурыARMAST;
	
КонецФункции
