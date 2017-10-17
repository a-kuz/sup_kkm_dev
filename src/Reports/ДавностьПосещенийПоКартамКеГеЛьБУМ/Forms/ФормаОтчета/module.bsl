﻿Перем ИмяОбъекта;
Перем НастройкиПереданы Экспорт;          // если флаг установлен, тогда восстановление настроек при открытии не происходит.

////////////////////////////////////////////////////
// ОБЩИЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Восстанавливает настройки отчета
//
// Параметры:
//	Значение - восстановленное значение настройки
//
Процедура ВосстановитьНастройку(Значение) Экспорт

	ВосстанавливаемоеЗначение = Значение.Получить();
		
	Если ВосстанавливаемоеЗначение <> Неопределено Тогда
		ФормированиеОтчетов.ВосстановитьНастройкуОтчета(ЭтотОбъект, ВосстанавливаемоеЗначение);
	КонецЕсли;
		
КонецПроцедуры

// Установка настроек по умолчанию
//
Процедура УстановитьПараметрыПоУмолчанию()
	
	СхемаКомпоновкиДанных.Параметры.ДатаС.Значение = Дата("00010101");
	СхемаКомпоновкиДанных.Параметры.ДатаПо.Значение = Дата("00010101");
	СхемаКомпоновкиДанных.Параметры.МассивСмен.Значение = Неопределено;
	СхемаКомпоновкиДанных.Параметры.ПараметрДата.Значение = Истина;
	КраткийВидНастройки = Ложь;
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
КонецПроцедуры

////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ФормированиеОтчетов.ПередОткрытиемОтчета(ЭтаФорма);
КонецПроцедуры

// Обработчик события ПриОткрытии.
//
Процедура ПриОткрытии()
	
	// Добавим кнопку сохранения списка клиентов в буфер
	//Рассылки.ДобавитьКнопкуВФормеОтчета(ЭлементыФормы);
	
	// Не будем учитывать документы заказ, по которым не распечатаны марки, но они сохранены в базу. ГлВерсия = 3
	// Это документы, созданные из интерфейса Доставка
	Если глВерсия = 3  Тогда
		
		СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос, "Документ.Заказ.Товары КАК ЗаказТовары",
		"Документ.Заказ.Товары КАК ЗаказТовары
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДоставкаДопИнф.СрезПоследних(, ) КАК ДоставкаДопИнф
		|		ПО ЗаказТовары.Ссылка = ДоставкаДопИнф.Заказ");
		
	
		СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос = СтрЗаменить(СхемаКомпоновкиДанных.НаборыДанных.НаборДанных1.Запрос,"ЗаказТовары.Ссылка.ПометкаУдаления = ЛОЖЬ",
		"ЗаказТовары.Ссылка.ПометкаУдаления = ЛОЖЬ
		|	И (НЕ ЗаказТовары.Ссылка.Доставка
		|			ИЛИ ЗаказТовары.Ссылка.Доставка
		|				И ДоставкаДопИнф.Статус <> ЗНАЧЕНИЕ(Перечисление.СтатусыДоставки.Открыт))");
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(мЧислоКогдаВПродаже) Тогда
		мЧислоКогдаВПродаже = 0;
	КонецЕсли; 
	ВидПериода = "Смена";
	
	Если Не ЗначениеЗаполнено(РасшифровыватьПоДокументам) Тогда
		РасшифровыватьПоДокументам = Истина;
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(ДатаС) И Не ЗначениеЗаполнено(ДатаПо) И Не ЗначениеЗаполнено(МассивСмен) Тогда 
		ДатаС = НачалоКвартала(ТекущаяДата());
		ДатаПо = ТекущаяДата();
		
		Период = ПредставлениеПериода(ДатаС,ДатаПо);
	КонецЕсли;	
	 
	Если НЕ НастройкиПереданы Тогда	
		ВосстанавливаемоеЗначение = ФормированиеОтчетов.ВосстановитьПриОткрытииОбр(ИмяОбъекта);
	Иначе
		ВосстанавливаемоеЗначение = Неопределено;
	КонецЕсли;	
	
	Если ВосстанавливаемоеЗначение <> Неопределено Тогда
		УстановитьПараметрыПоУмолчанию();

//		ВосстановитьНастройку(ВосстанавливаемоеЗначение);
	Иначе
		УстановитьПараметрыПоУмолчанию();
	КонецЕсли;
	
КонецПроцедуры

// Обработчик расшифровки.
//
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ФормированиеОтчетов.РасшифровкаОтчетов(ЭтотОбъект, Расшифровка, НастройкиОтчетаНаМоментФормирования);
	
КонецПроцедуры

////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ДЕЙСТВИЯ КОМАНДНЫХ ПАНЕЛЕЙ ФОРМЫ

// Обработчик  нажатия кнопки Настройка.
//
Процедура ДействияФормыНастройка(Кнопка)
	Форма =  ПолучитьФорму("ФормаНастройки", ЭтаФорма);
	
	Если КраткийВидНастройки = Истина Тогда
		Форма.ЭлементыФормы.ГлавнаяПанель.ТекущаяСтраница = Форма.ЭлементыФормы.ГлавнаяПанель.Страницы.Страница1;
	Иначе
		Форма.ЭлементыФормы.ГлавнаяПанель.ТекущаяСтраница = Форма.ЭлементыФормы.ГлавнаяПанель.Страницы.Страница2;
	КонецЕсли;	
	
	Форма.ОткрытьМодально();
КонецПроцедуры

// Обработчик формирования отчета
//
Процедура ДействияФормыСформировать(Кнопка) 
	
	СформироватьОтчет(ЭлементыФормы.Результат,,,ЭлементыФормы);
	
КонецПроцедуры

// задается программно
Процедура КоманднаяПанельФормыБыстрыеОтборы(Элемент)
	ФормированиеОтчетов.УправлениеОтображениемЭлементовФормы(ЭтаФорма,Элемент);
КонецПроцедуры

Процедура КнопкаПериодаНажатие(Элемент)
	ФормированиеОтчетов.КнопкаПериодНажатие(ЭтотОбъект);
КонецПроцедуры

Процедура КнопкаСменыНажатие(Элемент)
	ФормированиеОтчетов.КнопкаСменаНажатие(ЭтотОбъект);
КонецПроцедуры

// Обработчик восстановления настройки отчета
//
Процедура ДействияФормыВосстановитьНастройки(Кнопка)
	
	ФормированиеОтчетов.ВосстановитьНастройкуОбр(ИмяОбъекта,  ЭтаФорма, Неопределено);
	
КонецПроцедуры

// Обработчик сохранения настройки отчета
//
Процедура ДействияФормыСохранитьНастройки(Кнопка)
	
	ФормированиеОтчетов.СохранитьНастройкуОтчета(ЭтотОбъект, ИмяОбъекта);
	
КонецПроцедуры

// Процедура назначается динамически
// Процедура вызывается при выборе пункта меню СписокКлиентов командной панели
// формы. Процедура отрабатывает сохранение списка клиентов.
// Подключение данной процедуры-обработчика выполняется из кода конфигурации
//
Процедура ДействияФормыСписокКлиентов(Кнопка)
	
	//Рассылки.СохранитьСписокСотрудниковВБуфер(ОтчетОбъект.ИнформацияРасшифровки, глСписокКлиентов)
	
КонецПроцедуры

ИмяОбъекта = "Отчет."+  ЭтотОбъект.Метаданные().Имя+"_"	;
НастройкиПереданы = Ложь;


