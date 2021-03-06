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
		Результат.Подробно	= "Программе не удалось загрузить драйвер принтера...";
		Возврат;
	КонецЕсли; 
	
	// заполнение списка моделей
	КодыМоделей = Новый Структура;
	КодыМоделей.Вставить("StarSP2000"	,1);
	КодыМоделей.Вставить("StarSP298"	,2);
	КодыМоделей.Вставить("StarTSP600"	,3);
	КодыМоделей.Вставить("StarTSP700"	,4);
	КодыМоделей.Вставить("StarTSP800"	,5);
	КодыМоделей.Вставить("CBM1000II"	,7);
	КодыМоделей.Вставить("CTS300"		,9);
	КодыМоделей.Вставить("CBM270"		,10);
	КодыМоделей.Вставить("Axiohm794"	,6);
	КодыМоделей.Вставить("AuraPP7000"	,11);	// 7000 и 8000 и 6800 идут под одним кодом
	КодыМоделей.Вставить("AuraPP7200L"	,11);	// и сетевые тоже
	КодыМоделей.Вставить("AuraPP8000"	,11);   //
	КодыМоделей.Вставить("AuraPP8000L"	,11);	//
	КодыМоделей.Вставить("AuraPP6800"	,11);   //
	КодыМоделей.Вставить("AuraPP6800L"	,11);	//
	КодыМоделей.Вставить("AuraPP5200"	,13);
	КодыМоделей.Вставить("EpsonTM_T88"	,12);
	
	DRV.Model = КодыМоделей[ТО.КодМодели];
	
	ПрочитатьПараметр("PortNumber"		, 1 );
	ПрочитатьПараметр("BaudRate"		, 7 );
	ПрочитатьПараметр("CharSet"			, 0 );
	ПрочитатьПараметр("CodePage"		, 10 );
	ПрочитатьПараметр("LineSpacing"		, DRV.LineSpacing/10 );
	ПрочитатьПараметр("WaitPrinterAck"	, 1 );
	ПрочитатьПараметр("IPAddress"		, "127.0.0.1" );
	ПрочитатьПараметр("IPPort"			, 9100 );
	ПрочитатьПараметр("MachineName"		, "" );
	ПрочитатьПараметр("Exclusive"		, 0 );
	ПрочитатьПараметр("BackgroundPrint"	, 0 );
	ПрочитатьПараметр("ОтступСверху"	, 0 );
	ПрочитатьПараметр("КолвоСтрокНаЛист", 30 );
	ПрочитатьПараметр("SlipValue"		, 3 );
	ПрочитатьПараметр("CutValue"		, 2 );
	ПрочитатьПараметр("FeedValue"		, 0 );
	ПрочитатьПараметр("ВнешнийСигнал"	, Ложь );
	
	ЗаполнитьПараметрыСтроки();
	
КонецПроцедуры

// Выполняет действие с ТО.
//
// Параметры:
//  Действие - имя действия,
//  ПараметрыДействия - произвольный набор параметров
//
Процедура ВыполнитьДействие(Действие, ПараметрыДействия=Неопределено) Экспорт
	
	Если Действие = "Подключить" Тогда
		Если DRV.WaitPrinterAck=1 И НЕ ЗначениеЗаполнено(DRV.CapStationSlip) Тогда
			ПечатьПроверкаСвязи();
		Иначе
			Подключить();
		КонецЕсли;
		Отключить();
		
	ИначеЕсли Действие = "Отключить" Тогда
		Отключить();
		
	ИначеЕсли Действие = "Печать" Тогда
		Если НЕ ПараметрыДействия.Свойство("КолвоКопий") Тогда
			ПараметрыДействия.Вставить("КолвоКопий", 1);
		КонецЕсли; 
		
		// если принтер ПД
		Если ЗначениеЗаполнено(DRV.CapStationSlip) Тогда
			ПечатьПД( ПараметрыДействия.ТаблицаЗадания, ПараметрыДействия.КолвоКопий );
		Иначе
			Печать( ПараметрыДействия.ТаблицаЗадания, ПараметрыДействия.КолвоКопий );
		КонецЕсли;
		
		Отключить();
		
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
	
	Если глТорговоеОборудование.Свойство("RcpPrn1C",DRV) Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Попытка 
		ЗагрузитьВнешнююКомпоненту("RcpPrn1C.dll");
		DRV = Новый("AddIn.RcpPrn51");
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
	
	Если DRV.ResultCode=-12 Тогда	// не поддерживается в данной модели
		Возврат Ложь;
	КонецЕсли;
	
	Если DRV.ResultCode <> 0 Тогда
		
		ЗарегистрироватьСобытие("Торговое оборудование.Ошибка", УровеньЖурналаРегистрации.Ошибка, ТО.Метаданные(), ТО.Ссылка, DRV.ResultDescription);
		
		Результат.Ошибка = Истина;
		Результат.Описание = "Ошибка принтера: "+DRV.ResultCode;
		Результат.Подробно = DRV.ResultDescription;
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции

// Установка параметров подключения
//
Функция Подключить()
	
	DRV.RaiseException		= 0;
	
	Если DRV.DeviceCount = 0 Тогда
		DRV.AddDevice();
	КонецЕсли;
	
	// Свойства для работы с ЛУ
	DRV.CurrentDeviceNumber	= 1;
	DRV.CurrentDeviceName  	= Лев(ТО.Наименование,20);
	
	// Параметры связи
	DRV.Model				= КодыМоделей[ТО.КодМодели];
	DRV.PortNumber			= PortNumber;
	DRV.MachineName			= MachineName;
	Если PortNumber<33 Тогда
		DRV.BaudRate		= BaudRate;
		DRV.FlowControl		= FlowControl;
	КонецЕсли;
	Если PortNumber=99 Тогда 
		DRV.IPAddress       = IPAddress;
		DRV.IPPort          = IPPort;
	КонецЕсли;
	DRV.Exclusive			= Exclusive;
	
	// Настройки печати
	DRV.UpdatePrinterSettings = 1;
	DRV.CharSet				= CharSet;
	DRV.CodePage			= CodePage;
	DRV.WaitPrinterAck		= WaitPrinterAck;
	DRV.BackgroundPrint		= BackgroundPrint;
	DRV.Copies				= 1;
	DRV.ShowProgress		= 0;
	DRV.ZeroSlashed			= 0;
	DRV.SlipValue			= SlipValue;
	DRV.LineSpacing			= LineSpacing*10;
	
	DRV.DeviceEnabled = 1;
	Если Ошибка() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ИнициализацияСервера();
КонецФункции

// Отключение устройства
//
Процедура Отключить()
	
	DRV.DeviceEnabled=0;
	
КонецПроцедуры

// Инициализация сервера
//
Функция ИнициализацияСервера()
	
	DRV.CheckServerState();
	Если Ошибка() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если DRV.ServerState=1 Тогда
		DRV.Resume();
		
	ИначеЕсли DRV.ServerState=3 Тогда
		// удаление из очереди заданий, которые находятся в состоянии "Ошибка"
		КоличествоЗаданий = DRV.TaskIDNumber;
		Для ТекTaskIDNumber=0 По КоличествоЗаданий Цикл
			DRV.TaskIDNumber = ТекTaskIDNumber;
			DRV.CheckTaskState();
			Если DRV.TaskState=1 Тогда
				DRV.CancelTask();
			КонецЕсли;
		КонецЦикла;
		
		DRV.Resume();
		
	КонецЕсли;
	
	Возврат НЕ Ошибка();
КонецФункции

// Вызывается при подключении для проверки фактической готовности принтера
//
Процедура ПечатьПроверкаСвязи()
	
	ТаблицаЗадания = Новый ТаблицаЗначений;
	ТаблицаЗадания.Колонки.Добавить("Данные");
	ТаблицаЗадания.Колонки.Добавить("ТипДанных");
	ТаблицаЗадания.Колонки.Добавить("Параметры");
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    ="Проверка связи";
	Задание.ТипДанных ="Строка";
	Задание.Параметры ="ПереводСтроки";
	
	Печать(ТаблицаЗадания,1);
	
КонецПроцедуры

// Печать задания
//
Процедура Печать(ТаблицаЗадания, КолвоКопий)
	
	Если НЕ Подключить() Тогда
		Возврат;
	КонецЕсли;
	
	DRV.ClearTask();
	Если Ошибка() Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого Задание Из ТаблицаЗадания Цикл
		ДобавитьОбъектВЗадание(Задание);
	КонецЦикла;
	
	Если FeedValue<>0 Тогда
		DRV.FeedValue = FeedValue;
		DRV.AddFeed();
	КонецЕсли;
	Если CutValue<>0 Тогда
		DRV.CutValue = CutValue;
		DRV.AddCut();
	КонецЕсли;
	// ошибку не проверяем для совместимости моделей
	
	DRV.Copies = КолвоКопий;
	DRV.PrintTask();
	
	Если Ошибка() Тогда
		DRV.CancelTask();
	КонецЕсли;
	
	DRV.ClearTask();
	
КонецПроцедуры

// Печать на станции подкладного документа
//
Процедура ПечатьПД(ТаблицаЗадания, КолвоКопий)
	
	Если НЕ Подключить() Тогда
		Возврат;
	КонецЕсли;
	
	Для н=1 По КолвоКопий Цикл
		
		ИндексСтроки = 0;
		Пока ИндексСтроки <= ТаблицаЗадания.Количество()-1 Цикл
			
			DRV.ClearTask();
			Если Ошибка() Тогда
				Возврат;
			КонецЕсли;
			
			Если ОтступСверху<>0 Тогда
				DRV.FeedValue = ОтступСверху;
				DRV.AddFeed();
			КонецЕсли;
			
			НомСтр = 1;
			Пока ИндексСтроки<=ТаблицаЗадания.Количество()-1 И НомСтр<=КолвоСтрокНаЛист Цикл
				
				DRV.TextNewLine=1;
				ДобавитьОбъектВЗадание( ТаблицаЗадания[ИндексСтроки] );
				
				Если DRV.TextNewLine=1 Тогда
					НомСтр = НомСтр + 1;
				КонецЕсли;
				
				ИндексСтроки = ИндексСтроки + 1;
			КонецЦикла;
			
			DRV.AddSlip();
			
			DRV.Copies=1;
			DRV.PrintTask();
			
			Пока DRV.ResultCode=-6001 Цикл
				
				Результат.Ошибка = Ложь;
				
				Текст1="Вставьте бумагу!";
				Текст2 = "Вставьте бумагу и нажмите <ОК>" +Символы.ПС+ "Для отмены печати нажмите <Отмена>";
				Если ?(ЗначениеЗаполнено(глРабочееМесто), ИнтерфейсРМ.ВопросПредупреждение("Предупреждение", Текст1, Текст2, "ОК","","Esc=Отмена") = "Отмена", 
					Вопрос(Текст2, РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена) Тогда
					
					Результат.Ошибка = Истина;
					Результат.Описание = "";
					DRV.ClearTask();
					Возврат;
				КонецЕсли;
				
				DRV.PrintTask();
			КонецЦикла;
			
			Если Ошибка() Тогда
				DRV.CancelTask();
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	DRV.ClearTask();
КонецПроцедуры

Процедура ДобавитьОбъектВЗадание(Задание)
	
	Параметры = СформироватьСтруктуруПараметровСтроки(Задание.Данные, Задание.Параметры);
	
	Если Задание.ТипДанных="Строка" Тогда
		DRV.Caption			= Строка(Параметры.Caption);		Ошибка();
		DRV.FontIndex		= Число(Параметры.FontIndex);		// ошибку не проверяем для совместимости моделей
		DRV.FontBold		= Число(Параметры.FontBold);		
		DRV.FontItalic		= Число(Параметры.FontItalic);		
		DRV.FontDblHeight	= Число(Параметры.FontDblHeight);	
		DRV.FontDblWidth	= Число(Параметры.FontDblWidth);	
		DRV.FontUnderLine	= Число(Параметры.FontUnderLine);	
		DRV.FontOverLine	= Число(Параметры.FontOverLine);	
		DRV.FontNegative	= Число(Параметры.FontNegative);	
		DRV.TextUpSideDown	= Число(Параметры.TextUpSideDown);	
		//DRV.TextZeroSlashed	= Число(Параметры.TextZeroSlashed);		
		DRV.CharRotation	= Число(Параметры.CharRotation);	
		DRV.Color			= Число(Параметры.Color);			
		DRV.Alignment		= Число(Параметры.Alignment);		
		DRV.TextWrap		= Число(Параметры.TextWrap);		
		DRV.TextNewLine		= Число(Параметры.TextNewLine);		
		
		DRV.AddText();
		
	ИначеЕсли Задание.ТипДанных="Картинка" Тогда
		DRV.FileName		= Строка(Параметры.Caption);		Ошибка();
		DRV.Color			= Число(Параметры.Color);			// ошибку не проверяем для совместимости моделей
		DRV.Alignment		= Число(Параметры.Alignment);		
		DRV.Rotation		= Число(Параметры.Rotation);		
		
		ФайлНаДиске = Новый Файл( DRV.FileName );
		Если ФайлНаДиске.Существует() Тогда
			DRV.AddPicture();
		КонецЕсли;
		
	ИначеЕсли Задание.ТипДанных="ШтрихКод" Тогда
		DRV.Caption				= Строка(Параметры.Caption);			Ошибка();
		DRV.BarCodeHeight		= Макс(Число(Параметры.BarCodeHeight), 50);
		DRV.BarCodeType			= Число(Параметры.BarCodeType);			
		DRV.BarCodeControlCode	= Число(Параметры.BarCodeControlCode);	
		DRV.BarCodePrintText	= Число(Параметры.BarCodePrintText);	
		DRV.Color				= Число(Параметры.Color);				
		DRV.Alignment			= Число(Параметры.Alignment);			
		DRV.Rotation			= Число(Параметры.Rotation);			
		
		DRV.AddBarCode();
		
	ИначеЕсли Задание.ТипДанных="Сигнал" Тогда
		Если НЕ ВнешнийСигнал Тогда
			DRV.BeepValue = Задание.Данные;
			DRV.AddBeep();
		Иначе
			DRV.DrawerValue=1;
			Для н=1 По Задание.Данные Цикл
				DRV.AddDrawer();
			КонецЦикла;
		КонецЕсли;
		
	ИначеЕсли Задание.ТипДанных="ЧастичнаяОтрезка" Тогда
		// принудительная частичная отрезка внутри задания
		Если FeedValue<>0 Тогда
			DRV.FeedValue = FeedValue;
			DRV.AddFeed();
		КонецЕсли;
		DRV.CutValue = 2;
		DRV.AddCut();
		
	КонецЕсли;
	
КонецПроцедуры

// Формирует таблицу значений из макета "ПараметрыСтроки"
//
Процедура ЗаполнитьПараметрыСтроки()
	
	ТаблицаПараметрыСтроки = Новый ТаблицаЗначений;
	ТаблицаПараметрыСтроки.Колонки.Добавить("ИдПарам");
	ТаблицаПараметрыСтроки.Колонки.Добавить("СтрЗнач");
	ТаблицаПараметрыСтроки.Колонки.Добавить("ЧислЗач");
	
	Таб = ПолучитьМакет("ПараметрыСтроки");
	
	Для НомСтр=1 По Таб.ВысотаТаблицы Цикл
		
		ИдПарам = Таб.Область(НомСтр,1).Текст;
		Если НЕ ЗначениеЗаполнено(ИдПарам) Тогда
			Продолжить;
		КонецЕсли;
		
		ПараметрыСтроки = ТаблицаПараметрыСтроки.Добавить();
		ПараметрыСтроки.ИдПарам = ИдПарам;
		ПараметрыСтроки.СтрЗнач = Врег(Таб.Область(НомСтр,2).Текст);
		ПараметрыСтроки.ЧислЗач = Число(Таб.Область(НомСтр,3).Текст);
		
	КонецЦикла;
	
КонецПроцедуры

// Преобразует строку параметров в структуру, используя таблицу параметров
//
Функция СформироватьСтруктуруПараметровСтроки(Знач СтрПечати, Знач СтрПараметры)
	
	СтруктураПараметров = Новый Структура;
	
	Если СтрПечати="СтрОтчерк" Тогда
		СтрПечати="==================================================";
	ИначеЕсли СтрПечати="СтрЧерта" Тогда
		СтрПечати="--------------------------------------------------";
	КонецЕсли;
	
	СтруктураПараметров.Вставить("Caption",СтрПечати);
	
	РазделительСтрок = Символы.ПС + Символы.ВК;
	СтрПараметры = СтрЗаменить(СтрПараметры, РазделительСтрок,"");	// убираем лишние переводы строк
	СтрПараметры = СтрЗаменить(СтрПараметры, ",", РазделительСтрок);
	
	Для н=1 По СтрЧислоСтрок(СтрПараметры) Цикл
		
		Парам = СтрПолучитьСтроку(СтрПараметры,н);
		
		Если Лев(Парам,8)="ВысотаШК" Тогда
			ЧислЗач = Число(Сред(Парам,9))*10;
			СтруктураПараметров.Вставить("BarCodeHeight", ЧислЗач);
		Иначе
			ПараметрыСтроки = ТаблицаПараметрыСтроки.Найти(Врег(Парам), "СтрЗнач");
			Если ПараметрыСтроки <> Неопределено Тогда
				СтруктураПараметров.Вставить(ПараметрыСтроки.ИдПарам, ПараметрыСтроки.ЧислЗач);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	Для каждого ПараметрыСтроки Из ТаблицаПараметрыСтроки Цикл
		
		Если НЕ СтруктураПараметров.Свойство(ПараметрыСтроки.ИдПарам) Тогда
			СтруктураПараметров.Вставить(ПараметрыСтроки.ИдПарам, ПараметрыСтроки.ЧислЗач);
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат СтруктураПараметров;
КонецФункции

#КонецЕсли

Результат = Новый Структура("Ошибка,Описание,Подробно",Ложь,"","");
