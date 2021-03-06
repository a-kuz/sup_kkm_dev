﻿
Перем ПараметрыТО Экспорт;   // Параметры торгового оборудования.
Перем Результат Экспорт;     // Результат выполнения действия.
Перем DRV Экспорт;           // Драйвер
Перем Сетевой Экспорт;		 // Признак LAN-интерфейса

#Если Клиент Тогда

// Производит инициализацию торгового оборудования.
//
Процедура Инициализация() Экспорт
	
	// это наш драйвер, зашит в компоненту защиты
	DRV = РаботаСокнами;
	
	ПрочитатьПараметр("ИспользоватьСервер"	, Ложь );
	ПрочитатьПараметр("СерверIPадрес"		, "" );
	ПрочитатьПараметр("СерверIPпорт"		, 4000 );
	ПрочитатьПараметр("ТаймаутОтвета"		, 4 );
	ПрочитатьПараметр("ПортПодключения"		, "COM1" );
	ПрочитатьПараметр("Скорость"			, 19200 );
	ПрочитатьПараметр("Кодировка"			, 866 );
	ПрочитатьПараметр("НаборСимволов"		, "USA" );
	ПрочитатьПараметр("ПромоткаСтрок"		, 5 );
	ПрочитатьПараметр("ПроверкаСвязи"		, Истина );
	ПрочитатьПараметр("ПринтерIPадрес"		, "" );
	ПрочитатьПараметр("ПринтерIPпорт"		, 9100 );
	ПрочитатьПараметр("ПДНаправлениеВыброса", 2 );
	ПрочитатьПараметр("ПДКолвоСтрокНаЛист"	, 20 );
	ПрочитатьПараметр("ПДОтступСверху"		, 0 );
	ПрочитатьПараметр("ВнешнийСигнал"		, Ложь );
	ПрочитатьПараметр("КаталогСпула"		, "" );
	
	Сетевой = ТО.КодМодели="AuraPP6800L" ИЛИ ТО.КодМодели="AuraPP7200L" ИЛИ ТО.КодМодели="AuraPP8000L" ИЛИ ТО.КодМодели="LK-T21L";
	
КонецПроцедуры

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
//  ПараметрыДействия - произвольный набор параметров
//
Процедура ВыполнитьДействие(Действие, ПараметрыДействия=Неопределено) Экспорт
	
	Если Действие = "Подключить" Тогда
		Подключить(Истина);
		
	ИначеЕсли Действие = "Отключить" Тогда
		// ничего делать не надо
		
	ИначеЕсли Действие = "Печать" Тогда
		Если НЕ ПараметрыДействия.Свойство("КолвоКопий") Тогда
			ПараметрыДействия.Вставить("КолвоКопий", 1);
		КонецЕсли; 
		Если НЕ ПараметрыДействия.Свойство("ФоноваяПечать") Тогда
			ПараметрыДействия.Вставить("ФоноваяПечать", Ложь);
		КонецЕсли; 
		
		Если ТО.КодМодели="StarSP298" Тогда
			ПечатьПД( ПараметрыДействия.ТаблицаЗадания, ПараметрыДействия.КолвоКопий);
		Иначе
			Печать( ПараметрыДействия.ТаблицаЗадания, ПараметрыДействия.КолвоКопий, ПараметрыДействия.ФоноваяПечать );
		КонецЕсли;
		
	ИначеЕсли Действие = "ПроверкаСтатусаПечати" Тогда
		ПроверкаСтатусаПечати( ПараметрыДействия.ИндексЗадания );
		
	Иначе
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Неизвестная команда!";
		Результат.Подробно	= "Команда """+Действие+""" не определена для "+ТО.Наименование;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка ошибок
//
Процедура ОбработкаОшибки(ОписаниеОшибки)
	
	Если ПустаяСтрока(ОписаниеОшибки) Тогда
		Возврат;
	КонецЕсли; 
	
	ЗарегистрироватьСобытие("Торговое оборудование.Ошибка", УровеньЖурналаРегистрации.Ошибка, ТО.Метаданные(), ТО.Ссылка, ОписаниеОшибки);
	
	// ОписаниеОшибки - многострочный текст вида:
	// NetPrint:
	//	Code = 0x7
	//	Reason = Ошибка печати
	// Spooler:
	//	Code = 0xa
	//	Reason = Нет бумаги...
	//
	// Нас интересует только ошибка нижнего уровня, т.е. последние 2 строки
	
	КолвоСтрокОписания = СтрЧислоСтрок(ОписаниеОшибки);
	КодОшибки	= Сред( СтрПолучитьСтроку(ОписаниеОшибки, КолвоСтрокОписания-1), 9);
	ТекстОшибки	= Сред( СтрПолучитьСтроку(ОписаниеОшибки, КолвоСтрокОписания), 11);
	
	Результат.Ошибка = Истина;
	Результат.Описание = "Ошибка принтера!";
	Результат.Подробно = ТекстОшибки;
	
	Результат.Вставить("КодОшибки", КодОшибки);
	
КонецПроцедуры

// Установка параметров подключения
//
Процедура Подключить(ПроверкаГотовности=Ложь)
	
	Результат.Ошибка = Ложь;
	
	Если НЕ ИспользоватьСервер Тогда
		СерверIPадрес = "";
		СерверIPпорт  = 0;
	КонецЕсли; 
	
	ТаймаутОтветаМС = Макс(1,ТаймаутОтвета) * 1000;
	
	КодМодели = ТО.КодМодели;
	Если Сетевой Тогда
		DRV.PRNDRV_Printer( КодМодели, ПринтерIPадрес, ПринтерIPпорт, ?(ПроверкаСвязи,1,0), ТаймаутОтветаМС );
	Иначе
		DRV.PRNDRV_Printer( КодМодели, ПортПодключения, Скорость, ?(ПроверкаСвязи,1,0), ТаймаутОтветаМС );
	КонецЕсли; 
	
	DRV.PRNDRV_DeleteJob();
	
	DRV.PRNDRV_Coding( Кодировка, НаборСимволов );
	DRV.PRNDRV_Spacing( -1, -1 );
	
	Если ПроверкаГотовности Тогда
		Ответ = DRV.PRNDRV_GetStatus(СерверIPадрес, СерверIPпорт);
		ОбработкаОшибки(Ответ);
	КонецЕсли; 
	
КонецПроцедуры

// Печать задания
//
Процедура Печать(ТаблицаЗадания, КолвоКопий, ФоноваяПечать)
	
	Подключить();
	
	Для каждого Задание Из ТаблицаЗадания Цикл
		
		ДобавитьОбъектВЗадание(Задание);
		
		Если Результат.Ошибка Тогда
			Возврат;
		КонецЕсли; 
	
	КонецЦикла; 
	
	// промотка
	DRV.PRNDRV_NewLine( ПромоткаСтрок );
	// отрезка
	DRV.PRNDRV_Cut();
	DRV.PRNDRV_NewLine( 1 );	// без этого отрезка не всегда работает
	
	ОтправитьНаПечать(КолвоКопий, ФоноваяПечать);
	
КонецПроцедуры

// Печать на станции подкладного документа
//
Процедура ПечатьПД(ТаблицаЗадания, КолвоКопий)
	
	Для н=1 По КолвоКопий Цикл
		
		ИндексСтроки = 0;
		Пока ИндексСтроки <= ТаблицаЗадания.Количество()-1 Цикл
			
			// подключение перед посылкой каждого отдельного задания
			Подключить();
			
			Если ПДОтступСверху<>0 Тогда
				// промотка
				DRV.PRNDRV_NewLine( ПДОтступСверху );
			КонецЕсли;
			
			НомСтр = 1;
			Пока ИндексСтроки<=ТаблицаЗадания.Количество()-1 И НомСтр<=ПДКолвоСтрокНаЛист Цикл
				
				Задание = ТаблицаЗадания[ИндексСтроки];
				ДобавитьОбъектВЗадание( Задание );
				
				Если Найти(Задание.Параметры, "ПереводСтроки") Тогда
					НомСтр = НомСтр + 1;
				КонецЕсли;
				
				ИндексСтроки = ИндексСтроки + 1;
			КонецЦикла;
			
			DRV.PRNDRV_Slip( ПДНаправлениеВыброса );
			
			ОтправитьНаПечать();
			
			Пока Результат.Ошибка И Лев(Результат.Подробно,10) = "Нет бумаги" Цикл
				
				Результат.Ошибка = Ложь;
				
				DRV.PRNDRV_ClearBuffer(СерверIPадрес, СерверIPпорт);
				
				Текст1="Вставьте бумагу!";
				Текст2 = "Вставьте бумагу и нажмите <ОК>
						|Для отмены печати нажмите <Отмена>";
						
				Если ?(ЗначениеЗаполнено(глРабочееМесто), ИнтерфейсРМ.ВопросПредупреждение("Предупреждение", Текст1, Текст2, "ОК","","Esc=Отмена") = "Отмена", 
					Вопрос(Текст2, РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена) Тогда
					
					Результат.Ошибка = Истина;
					Результат.Описание = "";
					Возврат;
				КонецЕсли;
				
				ОтправитьНаПечать();
			КонецЦикла;
			
			Если Результат.Ошибка Тогда
				Возврат;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
КонецПроцедуры

// Добавление конкретной строки, ШК, и прочих команд
//
Процедура ДобавитьОбъектВЗадание(Задание)
	
	Если Задание.ТипДанных="Строка" Тогда
		
		// потом переделать !!!
		ДлинаСтроки = ИнтерфейсРМ.ПРНДлинаСтроки(ТО);
		// 
		
		СтрПечати = Строка(Задание.Данные);
		Если СтрПечати="СтрОтчерк" Тогда
			СтрПечати = Лев("==================================================",ДлинаСтроки);
		ИначеЕсли СтрПечати="СтрЧерта" Тогда
			СтрПечати = Лев("--------------------------------------------------",ДлинаСтроки);
		КонецЕсли;
		
		Задание.Параметры = СтрЗаменить(Задание.Параметры, "НеПереводСтроки", "");
		
		DRV.PRNDRV_Text( 0, Задание.Параметры, СтрПечати );
		
	ИначеЕсли Задание.ТипДанных="Картинка" Тогда

		Если DRV.PRNDRV_Image( Задание.Данные, Задание.Параметры ) = 1 Тогда
			Результат.Ошибка = Истина;
			Результат.Описание = "Ошибка принтера!";
			Результат.Подробно = "Ошибка при добавлении в задание картинки!";
		КонецЕсли; 
		
	ИначеЕсли Задание.ТипДанных="КартинкаИзБуфера" Тогда
		
		Если DRV.PRNDRV_ImageBuffer( Задание.Данные, Задание.Параметры ) = 1 Тогда
			Результат.Ошибка = Истина;
			Результат.Описание = "Ошибка принтера!";
			Результат.Подробно = "Ошибка при добавлении в задание картинки из буфера!";
		КонецЕсли;
		
	ИначеЕсли Задание.ТипДанных="ШтрихКод" Тогда
		
		ШтрихКод = Задание.Данные;
		Форматирование = Задание.Параметры;
		
		DRV.PRNDRV_BarCode(50, 2, Форматирование, 0, "EAN13", ШтрихКод);
		//Вход:	высота (число от 0 до 255 ), ширина (число 0,1,2,3... ), форматирование (строка), шрифт(число), 
		//		тип штрих кода (строка), текст штрих кода (строка)
		//Форматирование: Центр, Лево, Право, Нет, Вверху, Внизу
		
	ИначеЕсли Задание.ТипДанных="Сигнал" Тогда
		Если НЕ ВнешнийСигнал Тогда
			// внутренний сигнал
			DRV.PRNDRV_BuzzerOn( Задание.Данные );
		Иначе
			// внешний сигнал
			DRV.PRNDRV_ExternalSignal( 0, Задание.Данные );
		КонецЕсли;
		
	ИначеЕсли Задание.ТипДанных="ЧастичнаяОтрезка" Тогда
		// принудительная частичная отрезка внутри задания
		// промотка
		DRV.PRNDRV_NewLine( ПромоткаСтрок );
		// отрезка
		DRV.PRNDRV_Cut();
		
	ИначеЕсли Задание.ТипДанных="QRКод"  Тогда
		Если DRV.PRNDRV_QRCode( Задание.Данные, 6, 2, Задание.Параметры ) = Ложь Тогда
			Результат.Ошибка = Истина;
			Результат.Описание = "Ошибка принтера!";
			Результат.Подробно = "Ошибка при добавлении в задание QR-кода!";
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

// Отправка на печать и ожидание результата
//
Процедура ОтправитьНаПечать(КолвоКопий=1, ФоноваяПечать=Ложь)
	
	ИндексЗадания = DRV.PRNDRV_PrintJob(СерверIPадрес, СерверIPпорт, КолвоКопий);
	Если ИндексЗадания = 0 Тогда
		//ОбработкаОшибки(DRV.PRNDRV_ErrorMessage());
		ОписаниеОшибки = "	Code = 0" +Символы.ПС+ "	Reason = Ошибка получения индекса задания";
		ОбработкаОшибки(ОписаниеОшибки);
		Возврат;
	КонецЕсли; 
	
	Если ФоноваяПечать Тогда
		// цикл ожидания результата должен быть организован в вызывающем модуле
		Результат.Вставить("ИндексЗадания", ИндексЗадания);
		
	Иначе
		// в цикле ждем результат печати
		ПроверкаСтатусаПечати(ИндексЗадания);
		
		Пока НЕ( Результат.Ошибка ИЛИ Результат.ПечатьЗакончена) Цикл
			ПроверкаСтатусаПечати(ИндексЗадания);
		КонецЦикла; 
		
	КонецЕсли;
	
КонецПроцедуры

// Описание процедуры
//
// Параметры:
//	Параметр1	- описание параметра
//
Процедура ПроверкаСтатусаПечати(ИндексЗадания) Экспорт
	
	Результат.Вставить("ПечатьЗакончена", Ложь);
	
	СтатусПечати = DRV.PRNDRV_GetJobStatus( ИндексЗадания );
	
	Если СтатусПечати = 0 Тогда
		Результат.ПечатьЗакончена = Истина;
		
	ИначеЕсли СтатусПечати = 1 Тогда
		Ответ = DRV.PRNDRV_GetJobStatusDesc( ИндексЗадания );
		ОбработкаОшибки(Ответ);
		
	КонецЕсли; 
	
КонецПроцедуры

#КонецЕсли

Результат = Новый Структура("Ошибка,Описание,Подробно", Ложь,"","");
