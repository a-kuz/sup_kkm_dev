﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(ОписаниеПрофиля) ТОгда
		Предупреждение("Данная обработка открывается только из справочника торгового оборудования!",5);
		Отказ = Истина;
		Возврат;  		
	КонецЕсли;   
	
	// заполнение списка лог. устройств
	СписокЛогУстройств = ЭлементыФормы.CurrentDeviceNumber.СписокВыбора;
	Для н=1 По 99 Цикл
		СписокЛогУстройств.Добавить(н,"№ "+н);
	КонецЦикла;
	
	// заполнение списка моделей
	СписокМоделей = ЭлементыФормы.Model.СписокВыбора;
	СписокМоделей.Добавить(0,"ВР 4149");
	СписокМоделей.Добавить(1,"ВР 4900");
	СписокМоделей.Добавить(2,"Штрих ВТ,МТ");
	СписокМоделей.Добавить(3,"Штрих АС");
	СписокМоделей.Добавить(4,"CAS LP версии 1.5 ");
	СписокМоделей.Добавить(5,"Штрих АС POS");
	СписокМоделей.Добавить(6,"Штрих АС мини POS");
	СписокМоделей.Добавить(7,"CAS AP");
	СписокМоделей.Добавить(8,"CAS AD");
	СписокМоделей.Добавить(9,"CAS SC");
	СписокМоделей.Добавить(10,"CAS S-2000");
	СписокМоделей.Добавить(11,"ПетВес серия Е");
	СписокМоделей.Добавить(12,"Тензо ТВ-003/05Д");
	СписокМоделей.Добавить(13,"Bolet MD-991");
	СписокМоделей.Добавить(14,"МАССА-К серии ПВ");
	СписокМоделей.Добавить(15,"МАССА-К серий ВТ,ВТМ");
	СписокМоделей.Добавить(16,"МАССА-К серий MK-A, MK-T");
	СписокМоделей.Добавить(17,"Мера (Ока) до 30 кг");
	СписокМоделей.Добавить(18,"Мера (Ока) до 150 кг");
	СписокМоделей.Добавить(19,"ACOM PC100W");
	СписокМоделей.Добавить(20,"ACOM PC100");
	СписокМоделей.Добавить(21,"ACOM SI-1");
	СписокМоделей.Добавить(22,"CAS ER");
	СписокМоделей.Добавить(23,"CAS LP версии 1.6/2.0");
	СписокМоделей.Добавить(24,"Mettler Toledo 8217");
	СписокМоделей.Добавить(25,"Штрих BM100");
	СписокМоделей.Добавить(26,"Мера (9 байт) до 30 кг");
	СписокМоделей.Добавить(27,"Мера (9 байт) до 150 кг");
	СписокМоделей.Добавить(28,"CAS BW");
	СписокМоделей.Добавить(29,"Масса-К серий МК-ТВ,МК-ТН,ТВ-А");
	СписокМоделей.Добавить(30,"Mettler-Toledo Tiger-E");
	СписокМоделей.Добавить(31,"DIGI DS-788");
	СписокМоделей.Добавить(32,"Меркурий 314/315");
	СписокМоделей.Добавить(33,"CAS PDS");
		
	// заполнение списка COM портов
	СписокПортов = ЭлементыФормы.PortNumber.СписокВыбора;
	Для н=1 По 32 Цикл
		СписокПортов.Добавить(н,"COM"+н);
	КонецЦикла;
		
	// заполнение списка скоростей обмена
	СписокСкоростей = ЭлементыФормы.BaudRate.СписокВыбора;
	СписокСкоростей.Добавить(3 ,"1200");
	СписокСкоростей.Добавить(4 ,"2400");
	СписокСкоростей.Добавить(5 ,"4800");
	СписокСкоростей.Добавить(7 ,"9600");
	СписокСкоростей.Добавить(10,"19200");
	СписокСкоростей.Добавить(12,"38400");
	СписокСкоростей.Добавить(14,"57600");
	СписокСкоростей.Добавить(18,"115200");
		
	// заполнение списка четности
	СписокЧетности = ЭлементыФормы.Parity.СписокВыбора;
	СписокЧетности.Добавить(0, "Нет");
	СписокЧетности.Добавить(1, "Нечетность");
	СписокЧетности.Добавить(2, "Четность");
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ФлажокУстройствоВклПриИзменении(Элемент)
	
	Если ФлажокУстройствоВкл Тогда
		Подключить();
	Иначе
		Отключить();
	КонецЕсли; 
	
	ОтобразитьРезультат();
	ФлажокУстройствоВкл = DRV.DeviceEnabled;
	
КонецПроцедуры

Процедура ОбновитьНажатие(Элемент)
	ПоказанияДисплея();
КонецПроцедуры

Процедура ОсновныеДействияФормыОсновныеДействияФормыВыполнить(Кнопка)
	ЗаполнитьЗначенияСвойств(ПараметрыТО,ЭтотОбъект);
	
	Закрыть("ОК");
КонецПроцедуры

Процедура ПоказанияДисплея() 
	
//	DRV.UnitPrice=Цена;
	DRV.ReadWeight();
	     
	ResultCode			= DRV.ResultCode;
	ResultDescription	= DRV.ResultDescription;
	
	Если ResultCode=0 Тогда   
		Вес			= DRV.Weight;
		Цена		= DRV.UnitPrice;
		Стоимость	= DRV.SalesPrice;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОтобразитьРезультат()
	
	ResultCode = DRV.ResultCode;
	ResultDescription	= DRV.ResultDescription;
	
КонецПроцедуры





