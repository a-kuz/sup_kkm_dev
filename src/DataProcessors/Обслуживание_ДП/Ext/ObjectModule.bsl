﻿
Перем ПараметрыТО Экспорт;   // Параметры торгового оборудования.
Перем Результат Экспорт;     // Результат выполнения действия.
Перем DRV Экспорт;           // Драйвер

Перем КодыМоделей;
Перем ТаблицаПараметрыСтроки;

#Если Клиент Тогда

// Производит инициализацию торгового оборудования.
//
Процедура Инициализация() Экспорт
	
	Если НЕ ЗагрузитьДрайвер() Тогда
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Ошибка загрузки драйвера!";
		Результат.Подробно	= "Программе не удалось загрузить драйвер дисплея покупателя...";
		Возврат;
	КонецЕсли; 
	
	// заполнение списка моделей
	КодыМоделей = Новый Структура;
	КодыМоделей.Вставить("DPD_201"		,0);
	КодыМоделей.Вставить("EPSON"		,1);
	КодыМоделей.Вставить("ДП_01"		,2);
	КодыМоделей.Вставить("ДП_02"		,3);
	КодыМоделей.Вставить("ДП_03"		,4);
	КодыМоделей.Вставить("Flytech"		,5);
	КодыМоделей.Вставить("GIGATEK800"	,6);
	КодыМоделей.Вставить("FrontMaster"	,7);
	КодыМоделей.Вставить("EPSON_USA"	,8);
	КодыМоделей.Вставить("IPC"			,10);
	КодыМоделей.Вставить("GIGATEK820"	,11);
	КодыМоделей.Вставить("TEC51"		,12);
	КодыМоделей.Вставить("OMRON75"		,13);
	КодыМоделей.Вставить("NCR_597x"		,14);
	КодыМоделей.Вставить("ШтрихMiniPos"	,15);
	КодыМоделей.Вставить("PosiflexPD"	,16);
	КодыМоделей.Вставить("ДемоДисплей"	,255);
	
	ПрочитатьПараметр("PortNumber"		, 1001 );
	ПрочитатьПараметр("BaudRate"		, 7 );
	ПрочитатьПараметр("MachineName"		, "" );
	ПрочитатьПараметр("DataBits"		, 4 );
	ПрочитатьПараметр("Parity"			, 0 );
	ПрочитатьПараметр("StopBits"		, 0 );
	ПрочитатьПараметр("DownloadFonts"	, 1 );
	ПрочитатьПараметр("MarqueeType"		, 3 );
	ПрочитатьПараметр("MarqueeFormat"	, 1 );
	ПрочитатьПараметр("MarqueeRepeatWait", 500 );
	ПрочитатьПараметр("MarqueeUnitWait"	, 200 );
	
КонецПроцедуры

// Выполняет действие с ТО.
//
// Параметры:
//  Действие - имя действия,
//  ПараметрыДействия - произвольный набор параметров
//
Процедура ВыполнитьДействие(Действие, ПараметрыДействия=Неопределено) Экспорт
	
	Если Действие = "Подключить" Тогда
		Подключить();
		
	ИначеЕсли Действие = "Отключить" Тогда
		Отключить();
		
	ИначеЕсли Действие = "ВывестиТекст" Тогда
		ВывестиТекст(ПараметрыДействия);
		
	ИначеЕсли Действие = "БегущаяСтрока" Тогда
		БегущаяСтрока(ПараметрыДействия);
		
	Иначе
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Неизвестная команда!";
		Результат.Подробно	= "Команда """+Действие+""" не определена для "+ТО.Наименование;
		
	КонецЕсли;
	
КонецПроцедуры

// Загружает драйвер ТО.
//
// Возвращаемое значение:
//  Истина - драйвер загружен, ложь - нет.
//
Функция ЗагрузитьДрайвер()
	
	Если глТорговоеОборудование.Свойство("Line45",DRV) Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Попытка 
		ЗагрузитьВнешнююКомпоненту("Line1C.dll");
		DRV = Новый("AddIn.Line45");
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	DRV.LockDevices = 1;
	
	глТорговоеОборудование.Вставить("RcpPrn1C", DRV);
	Возврат Истина;
КонецФункции

// Выполняет чтение параметра ТО.
//
// Параметры:
//  ИмяПараметра        - имя параметра,
//  ЗначениеПоУмолчанию - значение по умолчанию для данного параметра.
//
// Возвращаемое значение:
//  Значение параметра или значение по умолчанию
//
Процедура ПрочитатьПараметр(ИмяПараметра,ЗначениеПоУмолчанию)
	
	Если НЕ ПараметрыТО.Свойство(ИмяПараметра) Тогда
		ПараметрыТО.Вставить(ИмяПараметра,ЗначениеПоУмолчанию);
	КонецЕсли; 
	
	ЭтотОбъект[ИмяПараметра] = ПараметрыТО[ИмяПараметра];
	
КонецПроцедуры

// Обработка ошибок
//
Функция Ошибка()
	
	Если DRV.ResultCode <> 0 Тогда
		
		ЗарегистрироватьСобытие("Торговое оборудование.Ошибка", УровеньЖурналаРегистрации.Ошибка, ТО.Метаданные(), ТО.Ссылка, DRV.ResultDescription);
		
		Результат.Ошибка = Истина;
		Результат.Описание = "Ошибка ДП: "+DRV.ResultCode;
		Результат.Подробно = DRV.ResultDescription;
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

// Установка параметров подключения
//
Функция Подключить() Экспорт
	
	Если КодыМоделей = Неопределено Тогда
		Инициализация();
	КонецЕсли;
	
	Если DRV.DeviceCount = 0 Тогда
		DRV.AddDevice();
	КонецЕсли;
	
	// Свойства для работы с ЛУ
	DRV.CurrentDeviceNumber	= 1;
	DRV.CurrentDeviceName  	= Лев(ТО.Наименование,20);
	
	// Параметры связи
	DRV.Model			= КодыМоделей[ТО.КодМодели];
	DRV.MachineName		= MachineName;
	DRV.PortNumber		= PortNumber;
	Если PortNumber<>66 Тогда
		DRV.BaudRate	= BaudRate;
		DRV.DataBits	= DataBits;
		DRV.Parity		= Parity;
		DRV.StopBits	= StopBits;
	КонецЕсли; 
	
	// Параметры работы дисплея покупателя
	Если DRV.CapDownloadFonts Тогда
		DRV.DownloadFonts	= DownloadFonts;
	КонецЕсли;
	DRV.CharacterSet		= 852;
	DRV.CursorUpdate		= 0;
	DRV.BlinkInterval		= 0;
	
	DRV.DeviceEnabled = 1;
	Если Ошибка() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

// Отключение устройства
//
Процедура Отключить() Экспорт
	
	DRV.DeviceEnabled=0;
	
КонецПроцедуры

// вывод текста на дисплей
//
Процедура ВывестиТекст(ПараметрыДействия)
	
	ШиринаОкна = 20;
	Текст1 = Лев(ПараметрыДействия.Текст1, ШиринаОкна);
	Текст2 = Лев(ПараметрыДействия.Текст2, ШиринаОкна);
	
	УдалитьВсеОкна();
	DRV.CreateWindow(0,0,2,20,2,ШиринаОкна);
	
	DRV.DisplayText( Текст1+Символы.ПС+Текст2+Символы.ПС, 0);
	
	Ошибка();
	
КонецПроцедуры

// Вывод текста бегущей строкой
//
Процедура БегущаяСтрока(ПараметрыДействия)
	
	УдалитьВсеОкна();
	
	Текст = ПараметрыДействия.Текст;
	КолвоСтрок = СтрЧислоСтрок(Текст);
	МаксДлинаСтроки = 1;
	Для н=1 По КолвоСтрок Цикл
		МаксДлинаСтроки = Макс(МаксДлинаСтроки, СтрДлина(СтрПолучитьСтроку(Текст,н)) );
	КонецЦикла; 
	
	ВысотаОкна = КолвоСтрок+2;
	ШиринаОкна = МаксДлинаСтроки+20;
	DRV.CreateWindow(0,0,2,20,ВысотаОкна,ШиринаОкна);
	
	DRV.MarqueeRepeatWait	= MarqueeRepeatWait;
	DRV.MarqueeUnitWait		= MarqueeUnitWait;
	DRV.MarqueeType			= MarqueeType;
	DRV.MarqueeFormat		= MarqueeFormat;
	
	DRV.DisplayText(ПараметрыДействия.Текст, 0);
	
	Ошибка();
	
КонецПроцедуры

// Удаляет все окна
Процедура УдалитьВсеОкна() Экспорт
	
	Пока DRV.CurrentWindow > 0 Цикл
		DRV.CurrentWindow = 1;
		DRV.DestroyWindow();
	КонецЦикла;
	
КонецПроцедуры 

#КонецЕсли

Результат = Новый Структура("Ошибка,Описание,Подробно",Ложь,"","");
