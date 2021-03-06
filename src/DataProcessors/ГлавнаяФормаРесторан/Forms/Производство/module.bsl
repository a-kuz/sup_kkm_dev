﻿Перем МестоПроизводстваСписок;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОЖИДАНИЯ

// чтобы часики тикали
//
Процедура ОбновитьДатуВремя()
	
	ТекДата = ТекущаяДата();
	ЭлементыФормы.тДата.Заголовок	= Формат(ТекДата,"ДФ='dd.MM.yyyy (ddd)'");
	ЭлементыФормы.тВремя.Заголовок	= Формат(ТекДата,"ДЛФ=В");
	
КонецПроцедуры

// Раз в минуту обновляем колво сотрудников
//
Процедура ОбновитьКолвоБлюд()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ЗаказТоварыДопИнф.НомерМарки) КАК Количество
	|ИЗ
	|	РегистрСведений.ЗаказТоварыДопИнф КАК ЗаказТоварыДопИнф
	|ГДЕ
	|	ЗаказТоварыДопИнф.ГруппаПечати В(&ГруппаПечати)
	|	И ЗаказТоварыДопИнф.ВремяГотово = ДАТАВРЕМЯ(1, 1, 1)
	|	И ЗаказТоварыДопИнф.Статус В(&Статус)
	|	И ЗаказТоварыДопИнф.ВремяЗаказано > &ВремяЗаказано
	|	И ЗаказТоварыДопИнф.Количество > 0
	|");
	
	// Параметры запроса
	
	Запрос.УстановитьПараметр("ГруппаПечати"		, МестоПроизводстваСписок);
	Запрос.УстановитьПараметр("ВремяЗаказано"			, ТекущаяДата()-60*60*12); // отслеживаем марки за последние 12 часов
	СписокСтатусов = Новый Массив;
	СписокСтатусов.Добавить(Перечисления.СтатусыПозицийЗаказа.Заказано);
	СписокСтатусов.Добавить(Перечисления.СтатусыПозицийЗаказа.Удалено);
	Запрос.УстановитьПараметр("Статус"				, СписокСтатусов); // 

	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Количество() = 0 Тогда
	Иначе
		Выборка.Следующий();
	Конецесли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ДействияПередЗакрытиемФормы(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	// заставка
	//ЭлементыФормы.ПолеКартинкиЗаставка.Картинка = БиблиотекаКартинок["ЗаставкаГлавнойФормы"+глВерсия];
	
	// неизменяемые надписи
	МестоПроизводстваСписок = Новый СписокЗначений;
    МестоПроизводстваСписок.ЗагрузитьЗначения(глПараметрыРМ.МестоПроизводстваТаблица.ВыгрузитьКолонку("МестоПроизводства"));
	Если НЕ МестоПроизводстваСписок.Количество() Тогда
		МестоПроизводстваСписок.Добавить(Справочники.ГруппыПечати.НайтиПоКоду(1));
	КонецЕсли;
	
	
	
	// периодически обновляемые надписи
	ОбновитьДатуВремя();
	ПодключитьОбработчикОжидания("ОбновитьДатуВремя", 1);
	
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	Если ЗначениеЗаполнено(глПользователь) Тогда
		ЭлементыФормы.тПользователь.Заголовок = глПользователь.Наименование;
	Иначе
		ЭлементыФормы.тПользователь.Заголовок = "Система заблокирована";
	КонецЕсли; 
	
	Смена = ИнтерфейсРМ.ТекущаяСмена();
	Если ЗначениеЗаполнено(Смена) Тогда
		ЭлементыФормы.НадписьСмена.Заголовок = "Смена ТТ №"+Смена.Номер+" от " + Формат(Смена.Дата,"ДФ='dd.MM.yyyy (ddd) HH:mm'") ;
	Иначе
		ЭлементыФормы.НадписьСмена.Заголовок = "СМЕНА ТТ - НЕ ОТКРЫТА"	;		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если ВводДоступен() Тогда
		ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия="ОбновитьСтопЛист" Тогда
		
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаМониторЗаказовНажатие(Элемент)
	
	Если НЕ Авторизация() Тогда
		Возврат;
		// < КС_ВДВ ------------------------------------------------------------ 
	ИначеЕсли НЕ ИнтерфейсРМ.ПроверкаПользователяСмены() Тогда
		ДействияПриВозвратеВФорму();
		Возврат;
		// КС_ВДВ > ------------------------------------------------------------ 
	КонецЕсли; 
	
	МониторМарок = ИнтерфейсРМ.ПолучитьОбъектОбработки("МониторМарок").ПолучитьФорму();
	Если МониторМарок.ПараметрыНастройки = Неопределено Тогда
		НастройкиОбъект = глПараметрыРМ.НастройкиМонитораМарокСписок[0].Значение.ПолучитьОбъект();
		Если НастройкиОбъект = Неопределено Тогда
			Текст1 = "Монитор марок";
			Текст2 = "Ошибка в настройках монитора марок"+Символы.ПС+""""+глРабочееМесто.Наименование+"""";
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
			Возврат; 
		КонецЕсли;	
		МониторМарок.ПараметрыНастройки = НастройкиОбъект.ПолучитьСтруктуруПараметров();
	КонецЕсли;
	МониторМарок.Открыть();
	
	ВыполнитьДействияПриВозврате = Истина;
	
КонецПроцедуры

Процедура КнопкаАвторизацияНажатие(Элемент)
	
	Авторизация( Истина );
	
КонецПроцедуры

Процедура КнопкаЗаблокироватьНажатие(Элемент)
	
	Заблокировать();
	
КонецПроцедуры

Процедура КнопкаСтопЛистНажатие(Элемент)
	
	ОткрытьСтопЛист();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЧЕЕ
