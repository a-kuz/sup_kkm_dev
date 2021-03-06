﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

// Вызывается по кнопке ВЫБОР или при выборе строки списка
//
Процедура ВыборКлиента()
	
	Клиент = ЭлементыФормы.СправочникСписок.ТекущаяСтрока;
	
	Если НЕ ЗначениеЗаполнено(Клиент) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Клиент.ЭтоГруппа Тогда
		ТекущийРодитель = Клиент;
	Иначе
		ВыборСделан = Истина;
		Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

// Функция выполняет запрос при автоподборе текста  и при окончании ввода текста в поле ввода.
//
// Параметры
//  Текст - Строка, текст введенный в поле ввода видв контактной информации, по которому необходимо строить поиск
//  СтруктураПараметров - Структура параметров запроса, ключ - имя параметра, значение - значение параметра.
//  ТипСправочника - Тип, тип справочника автоподбора текста
//  КоличествоЭлементов - Число, количество элементов в результирующей таблице запроса
//
// Возвращаемое значение
//  РезультатЗапроса
//
Процедура ПолучитьРезультатЗапросаАвтоподбора(Знач Текст) Экспорт
	
	ЭлементыФормы.СправочникСписок.ИерархическийПросмотр = Ложь;
	СправочникСписок.Отбор.ЭтоГруппа.Установить(Ложь);
	
	СправочникСписок.Отбор.Наименование.Использование = Истина;
	СправочникСписок.Отбор.Наименование.ВидСравнения = ВидСравнения.Содержит;
	СправочникСписок.Отбор.Наименование.Значение = Текст;
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	СправочникСписок.Отбор.ПометкаУдаления.Установить(Ложь);
	СправочникСписок.Отбор.НедоступенВыборИзСписка.Установить(Ложь);
	
	РежимВыбора = Истина;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
	РаботаСокнами.CloseScreenKey();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	глОтсечкаПростоя();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если НЕ ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	_Знач = ОбработкаВнешнихСобытий.ПолучитьДанные(Источник, Событие, Данные);
	
	Если ЗначениеЗаполнено(_Знач) Тогда

		ТипПривязки = Новый ОписаниеТипов("СправочникСсылка.Клиенты");
		ФлагПовтора = Истина;
		Клиент = ИнтерфейсРМ.ИдентификацияПоКарте("Идентификатор_"+_Знач, ТипПривязки, ФлагПовтора);
		
		Если Клиент = Справочники.Клиенты.ПустаяСсылка() Тогда
			Возврат;
		КонецЕсли;	
			
		ВыборСделан = Истина;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура СправочникСписокВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ВыборКлиента();
	
КонецПроцедуры

Процедура КнопкаВыбратьНажатие(Элемент)
	
	ВыборКлиента();
	
КонецПроцедуры

// выбор пустого клиента
//
Процедура КнопкаУдалитьНажатие(Элемент)
	
	Клиент = Справочники.Клиенты.ПустаяСсылка();
	ВыборСделан = Истина;
	Закрыть();
	
КонецПроцедуры

Процедура КнопкаУровеньВверхНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.СправочникСписок;
	WshShell.SendKeys("^{UP}");
	
КонецПроцедуры

Процедура КнопкаСтрелкаВверхНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.СправочникСписок;
	WshShell.SendKeys("{UP}");
	
КонецПроцедуры

Процедура КнопкаСтрелкаВнизНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.СправочникСписок;
	WshShell.SendKeys("{DOWN}");
	
КонецПроцедуры

Процедура КнопкаУровеньВнизНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.СправочникСписок;
	WshShell.SendKeys("^{DOWN}");
	
КонецПроцедуры

Процедура КнопкаЭкраннаяКлаваНажатие(Элемент)
	
	Перем X, Y;
	
	ИнтерфейсРМ.ЭкраннаяКлавиатура();
	
	ТекущийЭлемент = ЭлементыФормы.ПодстрокаПоиска;
		
КонецПроцедуры

Процедура ПодстрокаПоискаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПолучитьРезультатЗапросаАвтоподбора(Текст);
	
КонецПроцедуры

Процедура ПодстрокаПоискаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Значение = Текст;
	
	ПолучитьРезультатЗапросаАвтоподбора(Текст);
	
КонецПроцедуры

Процедура КнопкаОчиститьФильтрНажатие(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущаяСтрока;
	
	ЭлементыФормы.СправочникСписок.ИерархическийПросмотр = Истина;
	СправочникСписок.Отбор.ЭтоГруппа.Использование = Ложь;
	СправочникСписок.Отбор.Наименование.Использование = Ложь;
	
	ПодстрокаПоиска = "";
	ТекущийЭлемент = ЭлементыФормы.ПодстрокаПоиска;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока) Тогда
		ЭлементыФормы.СправочникСписок.ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли; 
	
КонецПроцедуры

Процедура СправочникСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если глВерсия=3 И НЕ ДанныеСтроки.ЭтоГруппа И ДанныеСтроки.Ссылка.ЧерныйСписок Тогда
		ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт,,,,,,Истина);	// зачеркнутый
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
