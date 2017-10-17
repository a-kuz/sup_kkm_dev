﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ОписаниеПрофиля) ТОгда
		Предупреждение("Данная обработка используется для работы конфигурации. Вручную ее вызывать запрещено.");	
		Отказ = Истина;
		Возврат;  		
	КонецЕсли;   
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Сохранение параметров и закрытие формы
//
Процедура ОК(Кнопка)
	
	ЗаполнитьЗначенияСвойств(ПараметрыТО,ЭтотОбъект);
	
	Закрыть("ОК");
	
КонецПроцедуры

Процедура ИмяПринтераНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Попытка
		wshNetwork = Новый ComОбъект("WScript.Network");
	Исключение
		Предупреждение("Ошибка создания системного объекта ""WScript.Network""
						|Введите имя принтера вручную...");
		Возврат;
	КонецПопытки;
	
	СписокПринетров = Новый СписокЗначений;
	
	Попытка
		oPrinters = wshNetwork.EnumPrinterConnections();
		i=0;
		while i<oPrinters.count()-1 do
			СписокПринетров.Добавить(oPrinters.item(i+1));
			i=i+2;
		enddo;
	Исключение
		Предупреждение("Ошибка получения списка принтеров.
						|Введите имя принтера вручную...");
		Возврат;
	КонецПопытки;
	
	ВыбЭлемент = ВыбратьИзМеню( СписокПринетров );
	Если ВыбЭлемент <> Неопределено Тогда
		ИмяПринтера = ВыбЭлемент.Значение;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИмяШрифтаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение <> Неопределено Тогда
		ИмяШрифта = ВыбранноеЗначение;
	КонецЕсли; 

	
КонецПроцедуры

Процедура ОсновныеДействияФормыРекомендуемые(Кнопка)
	
	// После проверки и тестирвания нужно добавить в процедуру обновления, автозаполение уже существующих принтеров шрифта Courier
	ШиринаОбластиПечати		= 41;
	КолвоСимволовВСтроке	= 40;
	ИмяШрифта				= "Courier New";
	ШрифтОсновнойРазмер 	= 8;
	ШрифтДвойнойРазмер 		= 10;
	ПреПросмотр				= Ложь;

КонецПроцедуры


СписокКолвоСимволовВСтроке = Новый СписокЗначений;
СписокКолвоСимволовВСтроке.Добавить(32,"32");
СписокКолвоСимволовВСтроке.Добавить(35,"35");
СписокКолвоСимволовВСтроке.Добавить(36,"36");
СписокКолвоСимволовВСтроке.Добавить(40,"40");
СписокКолвоСимволовВСтроке.Добавить(42,"42");
СписокКолвоСимволовВСтроке.Добавить(44,"44");
СписокКолвоСимволовВСтроке.Добавить(48,"48");

ЭлементыФормы.КолвоСимволовВСтроке.СписокВыбора = СписокКолвоСимволовВСтроке;

