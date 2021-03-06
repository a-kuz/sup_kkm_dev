﻿Перем ИмяОбъекта;
Перем НастройкиПереданы Экспорт;          // если флаг установлен, тогда восстановление настроек при открытии не происходит.

////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Установка настроек по умолчанию
//
Процедура УстановитьПараметрыПоУмолчанию()
	
	СхемаКомпоновкиДанных.Параметры.ДатаС.Значение = Дата("00010101");
	СхемаКомпоновкиДанных.Параметры.ДатаПо.Значение = Дата("00010101");
	КраткийВидНастройки = Истина;
	
КонецПроцедуры

// Выбор месяца из списка
//
Функция ВыбратьПериодРегистрации(Знач мПериодРегистрации, Элемент)
	
	СписокВыбора = СформироватьСписокВыбораМесяцев(мПериодРегистрации);
	ВыбЗначение = ВыбратьИзМеню(СписокВыбора, Элемент);

	Если ТипЗнч(ВыбЗначение) <> Тип("Неопределено") И ВыбЗначение.Значение = "ГодНазад" Тогда
		
		мПериодРегистрации = ВыбратьПериодРегистрации(ДобавитьМесяц(мПериодРегистрации, -12), Элемент);

	ИначеЕсли ТипЗнч(ВыбЗначение) <> Тип("Неопределено") И ВыбЗначение.Значение = "ГодВперед" Тогда
		
		мПериодРегистрации = ВыбратьПериодРегистрации(ДобавитьМесяц(мПериодРегистрации, 12), Элемент);
		
	ИначеЕсли ТипЗнч(ВыбЗначение) <> Тип("Неопределено") Тогда
		
		мПериодРегистрации = Дата(Сред(ВыбЗначение.Значение, 6, 4), Сред(ВыбЗначение.Значение, 11, 2), 1);
		
	Иначе
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	Возврат мПериодРегистрации;

КонецФункции // ВыбратьПериодРегистрации()

// Функция формирует список выбора месяцев
//
Функция СформироватьСписокВыбораМесяцев(мДата)
	
	Если НЕ ЗначениеЗаполнено(мДата) Тогда
		мДата = ТекущаяДата();
	КонецЕсли;
	
	Список = Новый СписокЗначений;
	Список.Добавить("ГодНазад", "<<— перейти к " + Формат(ДобавитьМесяц(мДата, -12), "ДФ='yyyy ""году""'"));
	Для Сч = 0 По 11 Цикл
		мМесяц = ДобавитьМесяц(НачалоГода(мДата), Сч);
		Список.Добавить("Дата"+Формат(мМесяц, "ДФ=_yyyy_MM"), "      " + Формат(мМесяц, "ДФ='MMMM yyyy'"));
	КонецЦикла;
	Список.Добавить("ГодВперед", "перейти к " + Формат(ДобавитьМесяц(мДата, 12), "ДФ='yyyy ""году —>>""'"));
	
	Возврат Список;
	
КонецФункции

////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ФормированиеОтчетов.ПередОткрытиемОтчета(ЭтаФорма);
КонецПроцедуры

// Обработчик события ПриОткрытии.
//
Процедура ПриОткрытии()
	
	Если Не ЗначениеЗаполнено(ДатаС) И Не ЗначениеЗаполнено(ДатаПо) И Не ЗначениеЗаполнено(МассивСмен) Тогда 
		ДатаС = НачалоМесяца(ТекущаяДата());
		ДатаПо = КонецМесяца(ТекущаяДата());
		Период = ПредставлениеПериода(ДатаС,ДатаПо);
	КонецЕсли;	
	
	//Если НЕ НастройкиПереданы Тогда	
	//	ВосстанавливаемоеЗначение = ФормированиеОтчетов.ВосстановитьПриОткрытииОбр(ИмяОбъекта);
	//Иначе
	//	ВосстанавливаемоеЗначение = Неопределено;
	//КонецЕсли;	
	//
	//Если ВосстанавливаемоеЗначение <> Неопределено Тогда
	//	ВосстановитьНастройку(ВосстанавливаемоеЗначение);
	//Иначе
	//	УстановитьПараметрыПоУмолчанию();
	//КонецЕсли;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.КнопкаПериодРегистрации.Заголовок = Формат(ДатаС, "ДФ='MMMM yyyy'");
	
КонецПроцедуры

// Обработчик расшифровки.
//
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	//СтандартнаяОбработка = Ложь;
	//
	//ФормированиеОтчетов.РасшифровкаОтчетов(ЭтотОбъект, Расшифровка, НастройкиОтчетаНаМоментФормирования);
	
КонецПроцедуры


////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Процедура - обработчик события "Нажатие" кнопки ПериодРегистрации
//
Процедура КнопкаПериодРегистрацииНажатие(Элемент)
	
	ВыбранноеЗначение = ВыбратьПериодРегистрации(ДатаС, Элемент);
	Если НЕ ВыбранноеЗначение = Неопределено Тогда
		ДатаС = ВыбранноеЗначение;
		ДатаПо = КонецМесяца(ДатаС);
	КонецЕсли;	
	
КонецПроцедуры

// Обработчик формирования отчета
//
Процедура ДействияФормыСформировать(Кнопка) 
	
	СформироватьОтчет(ЭлементыФормы.Результат,,,ЭлементыФормы);
	
КонецПроцедуры

// Процедура назначается динамически
// Процедура вызывается при выборе пункта меню СписокКлиентов командной панели
// формы. Процедура отрабатывает сохранение списка клиентов.
// Подключение данной процедуры-обработчика выполняется из кода конфигурации
//
Процедура ДействияФормыСписокКлиентов(Кнопка)
	
//	Рассылки.СохранитьСписокСотрудниковВБуфер(ОтчетОбъект.ИнформацияРасшифровки, глСписокКлиентов)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "Регулирование" кнопки ПериодРегистрации
//
Процедура ПериодРегистрацииРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ДатаС = ДобавитьМесяц(ДатаС, Направление);
	ДатаПо = КонецМесяца(ДатаС);
	
КонецПроцедуры

ИмяОбъекта = "Отчет."+  ЭтотОбъект.Метаданные().Имя+"_"	;
НастройкиПереданы = Ложь;

