﻿#Если Клиент Тогда

Перем ПараметрыТО Экспорт;   // Параметры торгового оборудования.
Перем Результат Экспорт;     // Результат выполнения действия.
Перем DRV Экспорт;           // Объект драйвера торгового оборудования.


// Производит инициализацию торгового оборудования.
//
Процедура Инициализация() Экспорт
	
	Если НЕ ЗагрузитьДрайвер() Тогда
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Ошибка загрузки драйвера!";
		Результат.Подробно	= "Программе не удалось загрузить драйвер весов...";
		Возврат;
	КонецЕсли; 
	
	СтрокаИменСвойств = "";
	
	ПрочитатьПараметр("CurrentDeviceNumber", 1);
	ПрочитатьПараметр("Model"              , 0);
	ПрочитатьПараметр("PortNumber"	       , 1);
	ПрочитатьПараметр("BaudRate"	       , 7);
	ПрочитатьПараметр("Parity"		       , 0);
	ПрочитатьПараметр("DecimalPoint"	   , 0);
	ПрочитатьПараметр("МПВ"	               , 0);
		
КонецПроцедуры
	
// Загружает драйвер ТО.
//
// Возвращаемое значение:
//  Истина - драйвер загружен, ложь - нет.
//
Функция ЗагрузитьДрайвер()
	
	Если глТорговоеОборудование.Свойство("Scale1C",DRV) Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Попытка 
		//ЗагрузитьВнешнююКомпоненту("Scale1C.dll");
		ПодключитьВнешнююКомпоненту("AddIn.Scale45");
		DRV = Новый("AddIn.Scale45");
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	
	глТорговоеОборудование.Вставить("Scale1C", DRV);
	
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
		
	ИначеЕсли Действие = "ПолучитьВес" Тогда
		Результат.Вес = ПолучитьВес();
				
	ИначеЕсли Действие = "УстановитьТару" Тогда
		УстановитьТару();
				
	ИначеЕсли Действие = "УстановитьНоль" Тогда
		УстановитьНоль();
		
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
Функция  Подключить() Экспорт
	
	Пока DRV.DeviceCount < CurrentDeviceNumber Цикл
        DRV.AddDevice();
	КонецЦикла;
	
	// Свойства для работы с ЛУ
	DRV.CurrentDeviceNumber	= CurrentDeviceNumber;
	DRV.CurrentDeviceName  	= Лев(ТО.Наименование,20);
	
	// Параметры связи
	DRV.Model			= Model;
	DRV.PortNumber		= PortNumber;
	DRV.BaudRate		= BaudRate;
	DRV.Parity			= Parity;
	DRV.DeviceEnabled		= 1;
	Если Ошибка() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Model = 11 Тогда // пока только для протокола POS2
		// асинхронный режим
		DRV.ШагВеса = 0.002;
		DRV.ПериодОпроса = 1;
		DRV.АсинхронныйРежим = Истина;
		DRV.ПосылкаДанных = Истина;
		DRV.АвтоВыключение = Истина;
	КонецЕсли;
	//// свойство появилось в версии 6.5
	//Попытка
	//	DRV.DecimalPoint = DecimalPoint;
	//Исключение
	//КонецПопытки;
	
	
	Возврат Истина;
КонецФункции

// Выполняет отключение ТО.
//
// Возвращаемое значение:
//  Истина - есть ошибка, ложь - нет.
//
Процедура Отключить() Экспорт
	
	DRV.CurrentDeviceNumber	= CurrentDeviceNumber;
	DRV.DeviceEnabled		= 0;
	Ошибка();
	
КонецПроцедуры

// Описание процедуры
//
Процедура ПрочитатьСвойстваДрайвера() Экспорт
	
	// Свойства для работы с ЛУ
	CurrentDeviceNumber	= DRV.CurrentDeviceNumber;
	
	// Параметры связи
	Model           = DRV.Model;
	PortNumber		= DRV.PortNumber;
	BaudRate		= DRV.BaudRate;
	Parity			= DRV.Parity;
	
КонецПроцедуры


Функция ПолучитьВес()  Экспорт
	
	Если DRV.DeviceEnabled=0 Тогда
		Если НЕ Подключить() Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Цена)=0 Тогда
		DRV.UnitPrice=Цена;
	КонецЕсли;
	
	DRV.ReadWeight();
	
	Если Ошибка() Тогда
		Возврат DRV.ResultCode;
	КонецЕсли;
	
	Возврат DRV.Weight;
КонецФункции

Процедура УстановитьТару()  Экспорт
	
	Если DRV.DeviceEnabled=0 Тогда
		Если НЕ Подключить() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	DRV.Tare();
		
КонецПроцедуры

Процедура УстановитьНоль() Экспорт
	
	Если DRV.DeviceEnabled=0 Тогда
		Если НЕ Подключить() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	DRV.ZeroScale();
	
КонецПроцедуры

Процедура ОчиститьОчередь() Экспорт 
	
	Пока DRV.DataCount Цикл
		DRV.УдалитьСообщение();
	КонецЦикла;
	
КонецПроцедуры


// Выполняет обработку ошибок ТО.
//
// Возвращаемое значение:
//  Истина - есть ошибка, ложь - нет.
//
Функция Ошибка()
	
	ResultCode			= DRV.ResultCode;
	ResultDescription	= DRV.ResultDescription;
	
	Если DRV.ResultCode = 0 Тогда
		Возврат Ложь;
		
	Иначе
		ЗарегистрироватьСобытие("Торговое оборудование.Ошибка",
		УровеньЖурналаРегистрации.Предупреждение,
		,
		ТО.Ссылка,
		Строка(DRV.ResultCode)+" - "+DRV.ResultDescription);
		
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Ошибка драйвера: "+DRV.ResultCode;
		Результат.Подробно	= СокрЛП(DRV.ResultDescription);
		
		Возврат Истина;
		
	КонецЕсли;
	
КонецФункции

// Проверяет стабильность веса ниже порога взвешивания
Функция ВесСтабилен() Экспорт 
	
	ТекВес = DRV.Weight;
	Если ТекВес > МПВ Тогда
		Возврат НЕ DRV.NonStable;
	ИначеЕсли ТекВес <= 0 Тогда
		Возврат Ложь;
	ИначеЕсли НЕ DRV.NonStable Тогда
		Возврат Истина;
	КонецЕсли;
	
	ОбщегоНазначенияКлиент.ОбождатьМиллисекунд(200);
	Возврат ТекВес = DRV.Weight;
	
КонецФункции


Результат = Новый Структура("Ошибка,Описание,Подробно,Вес",Ложь,"","");

#КонецЕсли
