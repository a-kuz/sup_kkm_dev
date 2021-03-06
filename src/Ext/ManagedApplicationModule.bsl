﻿#Область ОписаниеПеременных

Перем глСоединения Экспорт;
Перем глКонтрольныеПоказатели Экспорт; // соответствие: ключ - код показателя, значение - структура("НачалоЗамера")
Перем глВерсия Экспорт;
Перем глПараметрыРМ Экспорт;
Перем глРабочееМесто Экспорт;
Перем РаботаСокнами Экспорт;
Перем глОбработки Экспорт;
Перем глПользователь Экспорт;
Перем WshShell Экспорт;
Перем глОбработкаАвтоОбменДанными Экспорт;

//АК
Перем глРежимКиоск Экспорт;				// Признак запуска в режиме киоска
Перем глИмяГлавнойФормы Экспорт;		// Имя формы, которая будет открыта в режиме киоска
Перем глДоставкаОсновнойРежим Экспорт;	
Перем глСимволРубля Экспорт;
Перем глСтекОкон Экспорт;				// Массив стека открытых окон
Перем глДопУправлениеФормами Экспорт;	// Объект внешней обработки для управления формами
Перем глФлагБлокировка Экспорт;			// Признак блокировки
Перем глФлагЗапретБлокировки Экспорт;	// Признак запрета повторной блокировки
Перем глТаблицаСобытий Экспорт;			// Таблица событий для записи в журнал регистрации / центр безопасности
Перем глТорговоеОборудование Экспорт;		// Структура со ссылками на объекты для работы с торговым оборудованием
Перем глОжидание Экспорт;				// Форма окна ожидания
Перем ирПлатформа Экспорт;
Перем глФормаНастройкиРМ Экспорт;
Перем глПоследниеСотрудники Экспорт; // Массив из четырех последних сотрудников работавших на РМ

#КонецОбласти

Процедура ПриНачалеРаботыСистемы()
	
	Если глРежимКиоск Тогда

		УстановитьЗаголовокКлиентскогоПриложения("");
		Попытка
			ПодключитьОбработчикОжидания("СкрытьЗначок",1, Истина);		
		Исключение
		КонецПопытки;
		ОткрытьФорму(глИмяГлавнойФормы);
		//ПерехватЗаказа
		ПодключитьОбработчикОжидания("ОбработчикОповещения_Ожидание", 1, Истина);
	Иначе
		
	//#Если ТолстыйКлиентУправляемоеПриложение Тогда
		УстановитьЗаголовокКлиентскогоПриложения(ЗащитаСервер.ТекущаяИБстр());
	//#КонецЕсли
	
	КонецЕсли;
	
	
КонецПроцедуры

Процедура СкрытьЗначок() Экспорт
	ahk = Новый COMОбъект("Autohotkey.Script");
	ahk.ahktextdll("#NoTrayIcon
	|WinActivate,ahk_class V8TopLevelFrameSDI
	|WinWaitActive,ahk_class V8TopLevelFrameSDI
	|ControlGet, id, hwnd,,V8FormElement2, A
	|WinMove, ahk_id %id%,,1,1,0, 0");
КонецПроцедуры


Процедура ПередНачаломРаботыСистемы(Отказ)

	глРежимКиоск = Лев(НРег(ИмяКомпьютера()), 2) = "ak" ИЛИ ПараметрЗапуска = "ak";
	Если глРежимКиоск Тогда
		
		КлиентскоеПриложение.УстановитьРежимОсновногоОкна(РежимОсновногоОкнаКлиентскогоПриложения.Киоск);
		глИмяГлавнойФормы = "Обработка.ГлавнаяФормаАК.Форма.Форма";
		
		Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
			Отказ = Истина;
			ЗарегистрироватьСобытие("Автокасса.Оффлайн режим", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Ошибка"), , , "Попытка запуска файловой базы");
		КонецЕсли;
	ИначеЕсли СтрНайти(ИмяПользователя(), "СлужебныйКиоск") Тогда
		КлиентскоеПриложение.УстановитьРежимОсновногоОкна(РежимОсновногоОкнаКлиентскогоПриложения.РабочееМесто);	
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при всех интерактивных действиях пользователя в интерфейсе РМ,
// подключает обработчик ожидания для срабатывания автоблокировки.
Процедура глОтсечкаПростоя(БлокировкаВремя = Неопределено) Экспорт
	
	Попытка
		Если глПараметрыРМ.БлокировкаАвто И НЕ глФлагЗапретБлокировки Тогда
			Если БлокировкаВремя = Неопределено Тогда
				ПодключитьОбработчикОжидания("глАвтоблокировка", глПараметрыРМ.БлокировкаАвтоВремя, Истина);
			Иначе
				ПодключитьОбработчикОжидания("глАвтоблокировка", БлокировкаВремя, Истина);
			КонецЕсли;
		КонецЕсли;
	Исключение
	КонецПопытки;
		
КонецПроцедуры

// Подключается как обработчик ожидания, запускает процесс закрытия окон.
//
Процедура глАвтоблокировка() Экспорт
	
	Если глФлагЗапретБлокировки = Истина Тогда
		Возврат;
	КонецЕсли;
	
	ОткрытыеОкна = ПолучитьОкна();
	
	Если НЕ ОткрытыеОкна = Неопределено Тогда
		Для каждого ТекОкно Из ОткрытыеОкна Цикл
			Если ТекОкно.Основное Тогда
				Продолжить;
			КонецЕсли;
			СодержимоеОкна = ТекОкно.Содержимое;
			Для каждого ТекФорма Из СодержимоеОкна Цикл
				Если ТекФорма.ИмяФормы = глИмяГлавнойФормы Тогда
					ТекФорма.ОтобразитьНачальнуюСтраницу();
					//глФлагБлокировка = Истина;
				Иначе
					ТекФорма.Закрыть();
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры
Процедура глУправлениеОкнами() Экспорт
КонецПроцедуры
Процедура глОтключитьОбработчикОжидания(ИмяПроцедуры) Экспорт 

	ОтключитьОбработчикОжидания(ИмяПроцедуры);

КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
КонецПроцедуры

Процедура ОткрытьГлавнуюФорму() Экспорт 
	
	ОткрытыеОкна = ПолучитьОкна();
	
	Если НЕ ОткрытыеОкна = Неопределено Тогда
		Для каждого ТекОкно Из ОткрытыеОкна Цикл
			Если ТекОкно.Основное Тогда
				Продолжить;
			КонецЕсли;
			СодержимоеОкна = ТекОкно.Содержимое;
			Для каждого ТекФорма Из СодержимоеОкна Цикл
				ТекФорма.Закрыть();
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	              
	ОткрытьФорму(глИмяГлавнойФормы);
	
КонецПроцедуры

//ПерехватЗаказа
Процедура ОбработчикОповещения_Ожидание() Экспорт
	
#Если ТолстыйКлиентУправляемоеПриложение Тогда
	Если ЗначениеЗаполнено(глРабочееМесто) Тогда
		Отбор = Новый Структура("РабочееМесто", глРабочееМесто);
		ВыборкаСобытий = РегистрыСведений.ОбработкаСобытий.Выбрать(, КонецДня(ТекущаяДатаСеанса()), Отбор);
		н = 0;
		Пока ВыборкаСобытий.Следующий() Цикл
			Если ВыборкаСобытий.ТипСобытия = ПредопределенноеЗначение("Перечисление.ТипыСобытий.СообщениеДействие") Тогда
				//Оповестить("ГлавнаяФормаАК_СбросЗаказаСоСтандартнойКассы", глРабочееМесто, ГлавнаяФорма);
				ВыборкаСобытий.ПолучитьМенеджерЗаписи().Удалить();
				Оповестить(ВыборкаСобытий.Описание, глРабочееМесто, Неопределено);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
#КонецЕсли

	ПодключитьОбработчикОжидания("ОбработчикОповещения_Ожидание", 1, Истина);
	
КонецПроцедуры

Процедура ПередЗавершениемРаботыСистемы(Отказ, ТекстПредупреждения)
	
	глСтекОкон = Новый Массив;
	глОбработки = Новый Структура;
	глСоединения = Новый Соответствие;
	РаботаСокнами = Неопределено;
	WshShell = null;
	глТорговоеОборудование = Неопределено;

КонецПроцедуры

#Если ТолстыйКлиентУправляемоеПриложение Тогда
Функция Тест() Экспорт
	Попытка
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ОсновноеМестоРеализации.Значение
		|ИЗ
		|	Константа.ОсновноеМестоРеализации КАК ОсновноеМестоРеализации");
		Запрос.Выполнить();
		Возврат 1;
	Исключение
		Возврат 0;        
	КонецПопытки;
КонецФункции
#КонецЕсли

#Область Инициализация

глСоединения = Новый Соответствие;
глВерсия = 3;
глОбработки = Новый Структура;
//АК
глДоставкаОсновнойРежим = Ложь;
глСимволРубля = Символ(8381);
#Если ТолстыйКлиентУправляемоеПриложение Тогда
	//РаботаСокнами = Обработки.РаботаСокнами.Создать();
	ирПлатформа = Обработки.ирПлатформа.Создать();
#КонецЕсли
глПоследниеСотрудники = Новый Массив;
глКонтрольныеПоказатели = Новый Соответствие;
#КонецОбласти
