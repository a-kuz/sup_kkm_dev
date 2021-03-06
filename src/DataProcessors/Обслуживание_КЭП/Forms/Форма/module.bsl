﻿
Перем ТаблицаЗадания;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ОписаниеПрофиля) ТОгда
		Предупреждение("Данная обработка открывается только из справочника торгового оборудования!",5);
		Отказ = Истина;
		Возврат;  		
	КонецЕсли;   
	
	// заполнение списка COM, LPT и Ethernet портов
	Для н=1 По 32 Цикл
		ЭлементыФормы.ПортПодключения.СписокВыбора.Добавить(н, "COM"+н);
	КонецЦикла;
	
	// заполнение списка каналов
	Для н=1 По 32 Цикл
		ЭлементыФормы.НомерКанала.СписокВыбора.Добавить(н);
		ТестСписокКаналов.Добавить(н,"Канал № "+н);
	КонецЦикла;
	
	НомерКанала = 1;
	Результат.Вставить("СостояниеКанала", Неопределено);
	
	ТестИдСобытия		= 1;
	ТестДлительность	= 10;
	ТестПауза			= 5;
	ТестКоличествоПовторов = 10;
	ТестКанал			= 1;
	ТестВремяВкл		= ТекущаяДата();
	ТестВремяВыкл		= ТекущаяДата();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.СерверIPадрес			.Доступность = ИспользоватьСервер;
	ЭлементыФормы.СерверIPпорт			.Доступность = ИспользоватьСервер;
	ЭлементыФормы.НадписьСерверIPадрес	.Доступность = ИспользоватьСервер;
	ЭлементыФормы.НадписьСерверIPпорт	.Доступность = ИспользоватьСервер;
	ЭлементыФормы.ПроверитьСервер       .Доступность = ИспользоватьСервер;
	
	Если Результат.СостояниеКанала = Неопределено Тогда
		ЭлементыФормы.тСостояниеКанала.Заголовок = "состояние не определено";
	ИначеЕсли Результат.СостояниеКанала = 0 Тогда
		ЭлементыФормы.тСостояниеКанала.Заголовок = "ОТКЛЮЧЕН";
	ИначеЕсли Результат.СостояниеКанала = 1 Тогда
		ЭлементыФормы.тСостояниеКанала.Заголовок = "ВКЛЮЧЕН";
	КонецЕсли;
	
	ВремяОкончанияТеста = ТекущаяДата() + (ТестДлительность + ТестПауза) * ТестКоличествоПовторов - ТестПауза;
	ЭлементыФормы.НадписьВремяОкончания.Заголовок = Формат(ВремяОкончанияТеста, "ДФ='дд.ММ ЧЧ:мм'");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Сохранение параметров и закрытие формы
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ЗаполнитьЗначенияСвойств(ПараметрыТО,ЭтотОбъект);
	
	Закрыть("ОК");
	
КонецПроцедуры

Процедура ЗапросСостоянияНажатие(Элемент)
	
	ВыполнитьДействие("Подключить");
	
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
	Иначе
		Предупреждение("ОК!",3);
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаВКЛНажатие(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("НомерКанала", НомерКанала);
	ПараметрыДействия.Вставить("СостояниеКанала", 1);
	
	ВыполнитьДействие("УстановитьКанал", ПараметрыДействия);
	
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
	КонецЕсли;
	
	ВыполнитьДействие("ПолучитьКанал", ПараметрыДействия);
	
КонецПроцедуры

Процедура КнопкаОТКЛНажатие(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("НомерКанала", НомерКанала);
	ПараметрыДействия.Вставить("СостояниеКанала", 0);
	
	ВыполнитьДействие("УстановитьКанал", ПараметрыДействия);
	
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
	КонецЕсли;
	
	ВыполнитьДействие("ПолучитьКанал", ПараметрыДействия);
	
КонецПроцедуры

Процедура КнопкаПроверитьНажатие(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("НомерКанала", НомерКанала);
	
	ВыполнитьДействие("ПолучитьКанал", ПараметрыДействия);
	
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПроверитьСерверНажатие(Элемент)
	ЗапуститьПриложение("http://" + СерверIPадрес + ":5556/");
КонецПроцедуры

Процедура КнопкаЗапуститьОчередьНажатие(Элемент)
	
	ТекВремя = ТекущаяДата();
	НачИдСобытия = ТестИдСобытия;
	
	Для н=1 По ТестКоличествоПовторов Цикл
	
		Для каждого Канал Из ТестСписокКаналов Цикл
		
			Если НЕ Канал.Пометка Тогда
				Продолжить;
			КонецЕсли; 
			
			ПараметрыДействия = Новый Структура;
			ПараметрыДействия.Вставить("ИдСобытия"		, ТестИдСобытия);
			ПараметрыДействия.Вставить("НомерКанала"	, Канал.Значение);
			ПараметрыДействия.Вставить("ВремяНач"		, ТекВремя);
			ПараметрыДействия.Вставить("ВремяКон"		, ТекВремя + ТестДлительность);
			
			ВыполнитьДействие("ПоставитьВОчередь", ПараметрыДействия);
			
			Если Результат.Ошибка Тогда
				Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
				Возврат;
			КонецЕсли;
			
			ТестИдСобытия = ТестИдСобытия + 1;
			Состояние("В очередь поставлено событий: " + (ТестИдСобытия - НачИдСобытия));
			
		КонецЦикла; 
		
		ТекВремя = ТекВремя + ТестДлительность + ТестПауза;
		
	КонецЦикла; 
	
	Для каждого Канал Из ТестСписокКаналов Цикл
		Если Канал.Пометка Тогда
			Сообщить("Тестируется канал № "+Канал.Значение);
		КонецЕсли; 
	КонецЦикла; 
			
	Сообщить("Длительность включения каналов (сек.): " + ТестДлительность);
	Сообщить("Пауза между включениями (сек.): " + ТестПауза);
	Сообщить("Время последнего события в очереди: " + (ТекВремя - ТестПауза));
	Сообщить("Всего в очередь поставлено событий: " + (ТестИдСобытия - НачИдСобытия));
	
КонецПроцедуры

Процедура КнопкаОчиститьОчередьНажатие(Элемент)
	
	ВыполнитьДействие("ОчиститьОчередь");
	
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаУдалитьСобытиеНажатие(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ИдСобытия"		, ТестИдСобытия);
	ПараметрыДействия.Вставить("НомерКанала"	, ТестКанал);	// неважно
	ПараметрыДействия.Вставить("ВремяНач"		, Неопределено);
	ПараметрыДействия.Вставить("ВремяКон"		, Неопределено);
	
	ВыполнитьДействие("ПоставитьВОчередь", ПараметрыДействия);
	
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаИзменитьСобытиеНажатие(Элемент)
	
	ПараметрыДействия = Новый Структура;
	ПараметрыДействия.Вставить("ИдСобытия"		, ТестИдСобытия);
	ПараметрыДействия.Вставить("НомерКанала"	, ТестКанал);
	ПараметрыДействия.Вставить("ВремяНач"		, НачалоМинуты(ТестВремяВкл));
	ПараметрыДействия.Вставить("ВремяКон"		, НачалоМинуты(ТестВремяВыкл));
	
	ВыполнитьДействие("ПоставитьВОчередь", ПараметрыДействия);
	
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры


