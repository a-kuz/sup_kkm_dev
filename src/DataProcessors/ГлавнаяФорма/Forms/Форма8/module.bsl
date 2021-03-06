﻿Перем AutohotkeyDLL;
Перем ФормаСкрытияМеню;
Перем фСменаСтраницы;

Процедура ОбновитьНадписьИтого() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	Если глСтекОкон.Количество() > 1 Тогда
		Возврат;
	КонецЕсли;  
	
	Если ФормаСкрытияМеню <> Неопределено Тогда
		Если ФормаСкрытияМеню.Открыта() Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		ДатаРождения = Заказ.ДатаРождения;
	Исключение
		ДатаРождения = Дата(1,1,1);
	КонецПопытки;
	
	Если ТекущийРежим = "ВОЗВРАТ" Тогда
		ЭлементыФормы.тпТовары.Видимость = 0;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 1;
	Иначе
		ЭлементыФормы.тпТовары.Видимость = 1;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 0;
	КонецЕсли;
	
	ЕстьТовары = ТекущийДокумент.Товары.Итог("Количество");
	Если ЕстьТовары Тогда 
		ЭлементыФормы.НадписьИтого.Заголовок = "СУММА: " + Формат(ТекущийДокумент.Товары.Итог("Сумма"), "ЧДЦ=2; ЧРД=.; ЧН=-") + " " + глСимволРубля;
		УстановитьДоступностьКнопки("Оплата",1,1);
		УстановитьДоступностьКнопки("Сторно",	1);
		УстановитьДоступностьКнопки("СторноВсе",1);
	Иначе
		ЭлементыФормы.НадписьИтого.Заголовок = "";
		УстановитьДоступностьКнопки("Оплата",0);
		УстановитьДоступностьКнопки("Сторно",0);
		Если ТекущийРежим = "ВОЗВРАТ" Тогда
			УстановитьДоступностьКнопки("СторноВсе", Истина);
		Иначе
			УстановитьДоступностьКнопки("СторноВсе", ?(ЗначениеЗаполнено(ДатаРождения),1,0));
		КонецЕсли;
	КонецЕсли;
	
	Если НадписьСдача <> Неопределено Тогда
		ЭлементыФормы.НадписьСумма.Заголовок = "";
		НадписьСдача = СтрЗаменить(НадписьСдача, ",", ".");
		ЭлементыФормы.НадписьИтого.Заголовок = "СДАЧА: " + НадписьСдача;
	Иначе
		ЭлементыФормы.НадписьСумма.Заголовок = "";
	КонецЕсли;
	Если Заказ.Товары.Количество() > 1 Тогда
		Попытка
			ЭлементыФормы.тпТовары.ТекущаяСтрока = Заказ.Товары[Заказ.Товары.Количество()-1];
		Исключение
		КонецПопытки;
		Попытка
			Если ЭлементыФормы.ОПЛАТА.Доступность Тогда
				ТекущийЭлемент = ЭлементыФормы.ОПЛАТА;
			Иначе
				ТекущийЭлемент = ЭлементыФормы.Кнопка1;
			КонецЕсли;
			
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	НадписьЛояльность = "";
	Если ЗначениеЗаполнено(ТекущийДокумент.НомерКартыЛояльности) Тогда
		Если СтрДлина(СокрП(ТекущийДокумент.НомерКартыЛояльности)) <= 10 Тогда
			НадписьЛояльность = "Карта: ******"+Прав(ТекущийДокумент.НомерКартыЛояльности,4);
		Иначе
			НадписьЛояльность = "Карта применена";
		КонецЕсли;
	КонецЕсли;
	
	Если Не ТекущийДокумент.КартаДоступа.Пустая() Тогда
		НадписьЛояльность = НадписьЛояльность + ?(НадписьЛояльность = "", "", Символы.ПС) +	"Карта доступа " + ТекущийДокумент.КартаДоступа;
	КонецЕсли;
	
	Если ТипЗнч(ТекущийДокумент) = Тип("ДокументОбъект.Заказ") Тогда
		Если ТекущийДокумент.Купоны.Количество() Тогда
			НадписьЛояльность = НадписьЛояльность + Символы.ПС + "Сертификат" + ?(ТекущийДокумент.Купоны.Количество() = 1, " ", "ы ") + "применен" + ?(ТекущийДокумент.Купоны.Количество() = 1, " ", "ы ");
		КонецЕсли;
	КонецЕсли;

	Если ТекКоличество <> 1 И ТекКоличество <> 0 и ТекКоличество <> Неопределено Тогда
		ЭлементыФормы.НадписьКоличество.Заголовок = "КОЛ-ВО: " + ТекКоличество;
	Иначе
		ЭлементыФормы.НадписьКоличество.Заголовок = "";
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьДоступностьКнопки(ИмяКнопки, Доступность, Акцент = 0, Свойство = "Доступность") Экспорт
	Кнопка = ЭлементыФормы[ИмяКнопки];
	Кнопка[Свойство] = Доступность;	
КонецПроцедуры

Процедура ОбновитьВремя() Экспорт
	ЭлементыФормы.тВремя.Заголовок = Формат(ТекущаяДатаНаСервере(),"ДФ=HH:mm");
	ЭлементыФормы.тДата.Заголовок = Формат(ТекущаяДатаНаСервере(),"ДФ='dddd, d MMMM'");
	ЭлементыФормы.тПользователь.Заголовок = ?(ТекущийРежим = "ВОЗВРАТ", "ВОЗВРАТ " + Символы.ПС, "ПРОДАЖА "+ Символы.ПС) +
											?(ЗначениеЗаполнено(глПользователь), Строка(глПользователь), "Система заблокирована");
КонецПроцедуры

Процедура ОбновитьОстальное() Экспорт
	
	ЭлементыФормы.тКасса.Заголовок = "Касса № " + глПараметрыРМ.НомерКассы;
	ЭлементыФормы.тСмена.Заголовок = "Смена № " + глПараметрыРМ.НомерСмены;
	ЭлементыФормы.тЗаказ.Заголовок = "Заказ № " + НомерТекущегоЗаказа();
	НомерТекущегоЧека = "";
	Если глСтекОкон.Количество()=1 Тогда
		ЭлементыФормы.тЧек.Заголовок   = "Чек   № " + НомерТекущегоЧека();
	ИначеЕсли глПараметрыРМ.Свойство("НомерТекущегоЧека", НомерТекущегоЧека) Тогда
		ЭлементыФормы.тЧек.Заголовок   = "Чек   № " + НомерТекущегоЧека
	КонецЕсли;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
КонецПроцедуры

Процедура ПриОткрытии()
	ПодключитьОбработчикОжидания("ОбновитьВремя",10);
	ПодключитьОбработчикОжидания("ОбновитьОстальное",10);
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		Стиль = БиблиотекаСтилей.СтанцияОплатыОфлайн;
	Иначе
		Стиль = БиблиотекаСтилей.СтанцияОплаты;
	КонецЕсли;
	
	//ОбновитьНадписьИтого();
	//РаботаСокнами.Затемнить();
	СкрытьМенюИПанели();
	
КонецПроцедуры

Процедура СкрытьМенюИПанели() Экспорт
	ОбработкаСкрытия = ИнтерфейсРМ.ПолучитьОбъектОбработки("СкрытьМенюИПанели");
	ФормаСкрытияМеню = ОбработкаСкрытия.ПолучитьФорму();
	ФормаСкрытияМеню.Открыть();	
	
	ПодключитьОбработчикОжидания("Через2СекундыПослеОткрытия",5,1);
	
КонецПроцедуры

Процедура ВосстановитьФорму() Экспорт
	Если ФормаСкрытияМеню.Открыта() Тогда
		ПодключитьОбработчикОжидания("ВосстановитьФорму",0.5,1);	
	Иначе
		AutohotkeyDLL.ahkTextDll("
		|#NoTrayIcon
		|
		|	Send {alt down}{shift down}{VK52}{alt up}{shift up}
		|");	
		РаботаСокнами.ПереназначитьКнопки();
		РаботаСокнами.РазблокироватьВвод();
		ЭтаФорма.ТолькоПросмотр = 0;
		Заблокировать();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЧерезСекундуПослеАвторизации() Экспорт
	
КонецПроцедуры

Процедура Через2СекундыПослеОткрытия() Экспорт
	ИнициализацияЗаказа(Истина);
	ОбновитьНадписьИтого();
	ЭтаФорма.ТолькоПросмотр = 1;
	
	ПодключитьОбработчикОжидания("ВосстановитьФорму",2,1);
	ПодключитьОбработчикОжидания("ЧерезСекундуПослеАвторизации",1,1);
		
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	СохранитьНастройкиПользователя();
	ДействияПередЗакрытиемФормы(ЭтаФорма, Отказ);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	
	ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ИнициализацияТаблицыТоваров()
	
КонецПроцедуры

Процедура тпТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура тпТоварыПослеУдаления(Элемент)
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура тпТоварыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ДанныеСтроки = Неопределено Тогда
		ОформлениеСтроки.ЦветТекста = ОформлениеСтроки.ЦветФона;
		Возврат;
	КонецЕсли;
	
	Если ДанныеСтроки.фАлкоголь = 1 Тогда
		ОформлениеСтроки.Ячейки.Количество.Шрифт = Новый Шрифт("FontAwesome",24);
		ОформлениеСтроки.Ячейки.Количество.УстановитьТекст(Шрифты.ПолучитьСимвол("glass"));
		ОформлениеСтроки.Ячейки.Цена.ОтображатьТекст = 0;
	Иначе
		ОформлениеСтроки.Ячейки.х.УстановитьТекст("х");	
		Если ДанныеСтроки.Количество = 0 Тогда
			ОформлениеСтроки.Ячейки.Количество.УстановитьТекст(ДанныеСтроки.КоличествоНачальное);
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеСтроки.Количество Тогда
		ОформлениеСтроки.Ячейки.Равно.УстановитьТекст("=");	
	Иначе 
		ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт,,,,,,Истина); // зачеркнутый
		ОформлениеСтроки.Ячейки.Товар.Шрифт = Новый Шрифт(ОформлениеСтроки.Ячейки.Товар.Шрифт,,,,,,Истина); // зачеркнутый
	КонецЕсли;                                                                                   
	
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ИнтерфейсРМ.ПриЗакрытииОкна();	
	AutohotkeyDLL = Неопределено;
	ФормаСкрытияМеню = Неопределено;
КонецПроцедуры

Процедура СторноВсеНажатие(Элемент)
	глОтсечкаПростоя();
	СторноВсе();
	ОбновитьНадписьИтого();
КонецПроцедуры                 

Процедура тпТоварыТоварПриИзменении(Элемент)
	ЗаполнитьЗначенияСвойств(ЭлементыФормы.тпТовары.ТекущиеДанные, ЭлементыФормы.тпТовары.ТекущиеДанные.Товар);
	Если ЭлементыФормы.тпТовары.ТекущиеДанные.фАлкоголь Тогда
		ЭлементыФормы.тпТовары.ТекущиеДанные.ПДФ = ВводПДФ(ЭлементыФормы.тпТовары.ТекущиеДанные.Товар);
	КонецЕсли;
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ПриЗакрытииМеню() Экспорт
КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	Если  Ложь Тогда ЗначениеВыбора = Справочники.Товары.ПустаяСсылка() КонецЕсли;
	Если ТипЗнч(ЗначениеВыбора) = Тип("СправочникСсылка.Товары") Тогда 
		Если Не ЗначениеЗаполнено(ТекКоличество) Или ТекКоличество = 1 Тогда
			
			Если ЗначениеВыбора.ЗапросКоличества Тогда
				ИзменитьКоличество();
			КонецЕсли;
	
		КонецЕсли;
		ВводНовойСтроки(ЗначениеВыбора);
	КонецЕсли;
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ВыборТовараНажатие(Элемент)
	ВыборТовараИзМеню();
КонецПроцедуры

Процедура ПоискТовараНажатие(Элемент)
	ОткрытьФормуПоиска();
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ЗаблокироватьНажатие(Элемент)
	ТекущийЭлемент = ЭлементыФормы.Кнопка1;
	Заблокировать();
КонецПроцедуры

Процедура ОплатаНажатие(Элемент)
	ЗарегистрироватьСобытие("Интерактивное действие.ГлавнаяФорма.Итог",,,ТекущийДокумент.Ссылка);
	Если ЭтаФорма.ТолькоПросмотр = Ложь Тогда
		ЭтаФорма.ТолькоПросмотр = Истина;
		ПодключитьОбработчикОжидания("ИнтерактивнаяОплата",0.1,1);	
	КонецЕсли;
	
КонецПроцедуры

Процедура ИнтерактивнаяОплата() Экспорт
	Попытка
		Если ТекущийРежим = "ВОЗВРАТ" Тогда
			ВозвратОплаты();
		Иначе
			Оплата();
		КонецЕсли;	
		ОбновитьНадписьИтого();
	Исключение
		ЗарегистрироватьСобытие("Ошибка выполенния в форме оплаты", УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	ЭтаФорма.ТолькоПросмотр = Ложь;
КонецПроцедуры                     

Процедура РежимАдминистратораНажатие(Элемент)
	ОткрытьМенюОпераций();
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура КоличествоНажатие(Элемент)
	ИзменитьКоличество();
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура СторноНажатие(Элемент)
	Если глСтекОкон.Количество() = 1 Тогда
		Сторно();
		ОбновитьНадписьИтого();
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ИзменениеСмены" Тогда
		
		//глПараметрыРМ.Вставить("НомерСмены", ИнтерфейсРМ.ТекущаяСмена().Номер);
		фВводТоваровДоступен = ЗначениеЗаполнено(ИнтерфейсРМ.ТекущаяСмена().Номер);
	КонецЕсли; 
КонецПроцедуры

Процедура Страница2Нажатие(Элемент)
	Если Панель.ТекущаяСтраница = Панель.Страницы.Страница1 Тогда
		фСменаСтраницы = 1;
		Панель.ТекущаяСтраница = Панель.Страницы.Страница2;
		
	Иначе
		 Панель.ТекущаяСтраница = Панель.Страницы.Страница1;
	КонецЕсли;
КонецПроцедуры
 
Процедура ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если фСменаСтраницы Тогда
		фСменаСтраницы = 0;
	Иначе
		Если Панель.ТекущаяСтраница = Панель.Страницы.Страница2 Тогда
			Панель.ТекущаяСтраница = Панель.Страницы.Страница1;
		КонецЕсли;  
	КонецЕсли;  
	
КонецПроцедуры

Процедура КалькуляторНажатие(Элемент)
	//ЗапуститьПриложение("Calc");
КонецПроцедуры

Функция ПанелиСкрыты() Экспорт
	Если ФормаСкрытияМеню = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если ФормаСкрытияМеню.Открыта() Тогда
		Возврат Ложь;
	КонецЕсли;
	Возврат Истина;
КонецФункции

Процедура тпТоварыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	Если ЭлементыФормы.ОПЛАТА.Видимость И ЭлементыФормы.ОПЛАТА.Доступность Тогда
		ОплатаНажатие(Элемент);
	КонецЕсли;                 	
КонецПроцедуры

ОтборКоличество = ЭлементыФормы.тпТовары.ОтборСтрок.Количество;

ОтборКоличество.ВидСравнения = ВидСравнения.НеРавно;
//ОтборКоличество.Использование = 1;
Попытка
	AutohotkeyDLL = РаботаСокнами.AHK(,"ГлавнаяФорма");
Исключение
КонецПопытки;
фСменаСтраницы = 0;



//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "HOME", "{LShift Down}1{LShift Up}"); // Количество
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "END", "{F5}"); // ИТОГ
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "F1", "^{F3}");
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "Tab", "{F6}");
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "+VKBB", "{NumpadAdd}");
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "+VKBD", "{NumpadSub}");
//РаботаСокнами.ПереназначитьКнопки("Оплата", "VKBC", "+1");
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "+8", "{NumpadMult}");
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "VKBE", "{NumpadDot}");
//РаботаСокнами.ПереназначитьКнопки("ГлавнаяФорма", "Enter", "{LCtrl Down}{Enter}{LCtrl Up}");
//РаботаСокнами.ПереназначитьКнопки("Авторизация", "~Left", "+{F2}");
//РаботаСокнами.ПереназначитьКнопки("Авторизация", "~Tab", "+{F2}");
//РаботаСокнами.ПереназначитьКнопки("Авторизация", "~Down", "+{F2}");
//РаботаСокнами.ПереназначитьКнопки("Авторизация", "~Right", "+{F2}");



