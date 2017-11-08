﻿
#Если Клиент Тогда

Перем ПараметрыТО Экспорт;   // Параметры торгового оборудования.
Перем Результат Экспорт;     // Результат выполнения действия.
Перем DRV Экспорт;           // Объект драйвера торгового оборудования.

Перем КодыМоделей Экспорт;	 // Структура кодов моделей.
Перем СтрокаИменСвойств Экспорт;

// Производит инициализацию торгового оборудования.
//
Процедура Инициализация() Экспорт
	
	Если НЕ ЗагрузитьДрайвер() Тогда
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Ошибка загрузки драйвера!";
		Результат.Подробно	= "Программе не удалось загрузить драйвер устройств ввода...";
		Возврат;
	КонецЕсли; 
	
	СтрокаИменСвойств = "";
	
	ПрочитатьПараметр("CurrentDeviceNumber", 1);
	ПрочитатьПараметр("PortNumber"	, 1);
	ПрочитатьПараметр("BaudRate"	, 7);
	ПрочитатьПараметр("DataBits"	, 4);
	ПрочитатьПараметр("Parity"		, 0);
	ПрочитатьПараметр("StopBits"	, 0);
	ПрочитатьПараметр("Sensitive"	, 30);
	ПрочитатьПараметр("Prefix"		, "");
	ПрочитатьПараметр("Suffix"		, "");
	
	// заполнение списка моделей
	КодыМоделей = Новый Структура;
	//КодыМоделей.Вставить("СканерШК"				,0);
	//КодыМоделей.Вставить("РидерМК"				,1);
	//КодыМоделей.Вставить("Проксимити"			,6);
	//КодыМоделей.Вставить("ПроксимитиPERCo"		,8);
	//КодыМоделей.Вставить("ПроксимитиParsec"		,11);
	КодыМоделей.Вставить("ПроксиIronLogicZ2MF"	,3);
	//КодыМоделей.Вставить("ПроксимитиCoreRFID"	,14);
	//КодыМоделей.Вставить("ПроксиАрсеналПС01"	,15);
	
КонецПроцедуры

// Загружает драйвер ТО.
//
// Возвращаемое значение:
//  Истина - драйвер загружен, ложь - нет.
//
Функция ЗагрузитьДрайвер()
	
	Если глТорговоеОборудование.Свойство("Scaner1C",DRV) Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Попытка 
		ПодключитьВнешнююКомпоненту("ZR1C.dll", "Comp", ТипВнешнейКомпоненты.Native);
		DRV = Новый("AddIn.Comp.ZR1CExtension");
	Исключение
		Сообщить(ОписаниеОшибки());
		Попытка
			DRV = Новый COMОбъект("AddIn.Comp.ZR1CExtension");
		Исключение
			Возврат Ложь;
		КонецПопытки;
		
	КонецПопытки;
	
	глТорговоеОборудование.Вставить("Scaner1C", DRV);
	
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

// Выполняет действие с ТО.
//
// Параметры:
//  Действие - имя действия,
//  ПараметрыДействия - произвольный набор параметров, туда же присваивается возвращаемое значение функции.
//
Функция ВыполнитьДействие(Действие,ПараметрыДействия) Экспорт
	
	Если Действие = "Подключить" Тогда
		Подключить();
		
	ИначеЕсли Действие = "Отключить" Тогда
		Отключить();
		
	ИначеЕсли Действие = "ОчиститьОчередь" Тогда	
		ОчиститьОчередь();
		
	ИначеЕсли Действие = "ТестУстройства" Тогда
		ТестУстройства();
		
	Иначе
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Неизвестная команда!";
		Результат.Подробно	= "Команда """+Действие+""" не определена для "+ТО.Наименование;
		
	КонецЕсли;
	
	Возврат ПараметрыДействия;
	
КонецФункции

// Выполняет подключение ТО.
//
// Возвращаемое значение:
//  Истина - есть ошибка, ложь - нет.
//
Процедура Подключить() Экспорт
	
	УстановитьСвойстваДрайвера();
	DRV.ОчиститьЛог();
	DRV.ЗагрузитьНастройки(3);
	DRV.ОчиститьФорматы();
	DRV.ВставитьФормат(0,"МОКП","%.2X%.2X%.2X%.2X%.2X%.2X%.2X%.2X","b0 b1 b2 b3 b4 b5 b6 b7");
	DRV.СохранитьНастройки(3);
	ИмяПорта = "";
	Ответ = DRV.Подключить(ИмяПорта);
	
	Если не Ответ Тогда
		Ошибка();
	КонецЕсли;
	//Пока DRV.DeviceCount < CurrentDeviceNumber Цикл
	//    DRV.AddDevice();
	//КонецЦикла;
	//
	//УстановитьСвойстваДрайвера();
	//
	//DRV.OldVersion			= 0;
	//DRV.DataEventEnabled	= 1;
	//DRV.AutoDisable			= 1;
	//
	//DRV.DeviceEnabled		= 1;
	//Ошибка();
	
КонецПроцедуры

Функция ТестУстройства() Экспорт
	ОписаниеРезультата = "";
	Демо = "";
	Ответ = DRV.ТестУстройства(ОписаниеРезультата,Демо);
	Если не Ответ Тогда
		Ошибка();
		Отключить();
		Возврат Результат.Подробно;
	Иначе
		Возврат ОписаниеРезультата;
	КонецЕсли;
	
КонецФункции

// Выполняет отключение ТО.
//
// Возвращаемое значение:
//  Истина - есть ошибка, ложь - нет.
//
Процедура Отключить() Экспорт
	
	//DRV.CurrentDeviceNumber	= CurrentDeviceNumber;
	//DRV.DeviceEnabled		= 0;
	ИмяПорта = "COM" + Формат(PortNumber,"ЧГ=0");
	Ответ = DRV.Отключить(ИмяПорта);
	Если не Ответ Тогда
		Ошибка();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОчиститьОчередь() Экспорт 
	
	//Пока DRV.DataCount Цикл
	//	DRV.УдалитьСообщение();
	//КонецЦикла;
	
КонецПроцедуры


// Описание процедуры
//
Процедура УстановитьСвойстваДрайвера() Экспорт
	
	// Свойства для работы с ЛУ
	//DRV.CurrentDeviceNumber	= CurrentDeviceNumber;
	//DRV.CurrentDeviceName  	= Лев(ТО.Наименование,20);
	
	// Параметры связи
	DRV.Model				= КодыМоделей[ТО.КодМодели];
	DRV.Port				= "Com" + Формат(PortNumber,"ЧГ=0");
	
	DRV.Prefix				= Prefix;
	DRV.Suffix				= Suffix;
	
	// параметры СОМ порта
	DRV.Speed				= 0; // Автоматически выбирается максимальная скорость
	//DRV.DataBits		= DataBits;
	//DRV.Parity			= Parity;
	//DRV.StopBits		= StopBits;
	
КонецПроцедуры
 
// Описание процедуры
//
Процедура ПрочитатьСвойстваДрайвера() Экспорт
	
	// Свойства для работы с ЛУ
	CurrentDeviceNumber	= DRV.CurrentDeviceNumber;
	
	// Параметры связи
	PortNumber			= СтрЗаменить(DRV.Port,"Com","");
	
	Prefix				= DRV.Prefix;
	Suffix				= DRV.Suffix;
	
	
КонецПроцедуры
 
// Выполняет обработку ошибок ТО.
//
// Возвращаемое значение:
//  Истина - есть ошибка, ложь - нет.
//
Функция Ошибка()
	
	//ResultCode			= DRV.ResultCode;
	//ResultDescription	= DRV.ResultDescription;
	
	//Если DRV.ResultCode = 0 Тогда
	//	Возврат Ложь;
	//	
	//Иначе
	ТекстОшибки = "";
	КодОшибки = DRV.ПолучитьОшибку(ТекстОшибки);
	ЗарегистрироватьСобытие("Торговое оборудование.Ошибка",
	УровеньЖурналаРегистрации.Предупреждение,
	,
	ТО.Ссылка,
	Строка(КодОшибки)+" - "+ТекстОшибки);
	
	Результат.Ошибка	= Истина;
	Результат.Описание	= "Ошибка драйвера: "+КодОшибки;
	Результат.Подробно	= СокрЛП(ТекстОшибки);
	
	Возврат Истина;
		
	//КонецЕсли;
	
КонецФункции

Результат = Новый Структура("Ошибка,Описание,Подробно",Ложь,"","");

#КонецЕсли

