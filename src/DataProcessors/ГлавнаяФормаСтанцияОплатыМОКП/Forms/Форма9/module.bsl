﻿Перем AutohotkeyDLL;
Перем ФормаСкрытияМеню, фФормаСкрытияМеню;
Перем мСдвигаемыеЭлементы;
Перем ОтборФирма;
Перем КупоныСоответствие Экспорт;
Перем МакетПодвал;
Перем ТекСтрокаТП;

Процедура СкрытьПоказатьКнопки(Показать = Ложь)
	Для Каждого Эл Из ЭлементыФормы Цикл
		Если СтрНачинаетсяС(Эл.Имя, "Кнопка") Тогда
			Эл.Видимость = Показать;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры


Процедура ОбновитьНадписьИтого() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
		
	Попытка
		ДатаРождения = Заказ.ДатаРождения;
	Исключение
		ДатаРождения = Дата(1,1,1);
	КонецПопытки;
	
	Если ТекущийРежим = "ВОЗВРАТ" Тогда
		ЭлементыФормы.тпТовары.Видимость = 0;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 1;
		ЭлементыФормы.ТеньТовары.Видимость = 1;
		СкрытьПоказатьКнопки(Истина);
	ИначеЕсли  ТекущийРежим = "ПРОДАЖА" Тогда
		ЭлементыФормы.тпТовары.Видимость = 1;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 0;
		ЭлементыФормы.ТеньТовары.Видимость = 1;
		СкрытьПоказатьКнопки(Истина);
	Иначе
		ЭлементыФормы.ТеньТовары.Видимость = 0;
		ЭлементыФормы.тпТовары.Видимость = 0;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 0;
		СкрытьПоказатьКнопки();
	КонецЕсли;
	ИтогоСумма = 0;
	ИтогоКоличество = 0;
	ЕстьЧужиеТовары = Ложь;
	Если ТекущийРежим = "" Тогда
		ЕстьТовары = Ложь;
		
	Иначе
		Если ТекущийДокумент.Товары.Количество() Тогда
			ТекСтрока = ТекущийДокумент.Товары[ТекущийДокумент.Товары.Количество()-1];
		Иначе
			ТекСтрока = Неопределено;
		КонецЕсли;
		
		Для Каждого Т Из ТекущийДокумент.Товары Цикл
			Если т.Фирма <> глПараметрыРМ.Фирма Тогда
				ЕстьЧужиеТовары = Истина;
			КонецЕсли;
			Если Т.СтатусОплаты = -1 Тогда
				Попытка
					ИтогоСумма = ИтогоСумма + ?(ТекущийРежим = "ПРОДАЖА", Т.СуммаРеализации, Т.Сумма);	
					ИтогоКоличество = ИтогоКоличество + Т.Количество;
				Исключение
				КонецПопытки;                                        
				
				Если Т.Количество Тогда
					ТекСтрока = Т;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		Попытка
			ТекСтрокаТП = ТекСтрока;	
			ПодключитьОбработчикОжидания("УстановитьТекСтроку", 0.2, 1);
		Исключение
		КонецПопытки;
		
		ЕстьТовары = ИтогоКоличество;
	КонецЕсли;
	
	
	
	Если ЕстьТовары Тогда 
		СуммаКоплате = Формат(ИтогоСумма, "ЧДЦ=2; ЧРД=.; ЧН=-") + " " + глСимволРубля;
		УстановитьВидимостьКнопки("Оплата",1,1);
	Иначе
		СуммаКоплате = "";
	КонецЕсли;
	
	УстановитьДоступностьКнопки("КнопкаПереключитьФильтр",ЕстьЧужиеТовары,0,"Видимость");

	Если НадписьСдача <> Неопределено Тогда
		//ЭлементыФормы.НадписьСумма.Заголовок = "Сдача";
		СуммаКоплате = СтрЗаменить(НадписьСдача, ",", ".");  
		УстановитьДоступностьКнопки("Оплата",1,1);
	ИначеЕсли ТекущийДокумент = Неопределено Тогда
		//ЭлементыФормы.НадписьСумма.Заголовок = "";
		УстановитьДоступностьКнопки("Оплата",0,1);
	Иначе
		УстановитьДоступностьКнопки("Оплата",1,1);
		//ЭлементыФормы.НадписьСумма.Заголовок = "К оплате";
		Если Не ИтогоСумма Тогда
			//ЭлементыФормы.НадписьСумма.Заголовок = "";
		КонецЕсли;
	КонецЕсли;
	НадписьЛояльность = "";
	Если ТекущийДокумент <> Неопределено Тогда
		
		Если ЕстьТовары Тогда
			
			Попытка
				ТекущийЭлемент = ЭлементыФормы.Плашка11;
			Исключение
			КонецПопытки;
		КонецЕсли;
		
		
		
		Если ЗначениеЗаполнено(ТекущийДокумент.НомерКартыЛояльности) Тогда
			Если СтрДлина(СокрП(ТекущийДокумент.НомерКартыЛояльности)) <= 10 Тогда
				НадписьЛояльность = "Карта: ******"+Прав(ТекущийДокумент.НомерКартыЛояльности,4);
			Иначе
				НадписьЛояльность = "Карта применена";
			КонецЕсли;
		КонецЕсли;
		
		//Если Не ТекущийДокумент.КартаДоступа.Пустая() Тогда
		//	НадписьЛояльность = НадписьЛояльность + ?(НадписьЛояльность = "", "", Символы.ПС) +	"Карта доступа " + ТекущийДокумент.КартаДоступа;
		//КонецЕсли;
		
		Если ТипЗнч(ТекущийДокумент) = Тип("ДокументОбъект.Заказ") Тогда
			Если ТекущийДокумент.Купоны.Количество() Тогда
				НадписьЛояльность = НадписьЛояльность + Символы.ПС + "Сертификат" + ?(ТекущийДокумент.Купоны.Количество() = 1, " ", "ы ") + "применен" + ?(ТекущийДокумент.Купоны.Количество() = 1, " ", "ы ");
			КонецЕсли;
		КонецЕсли;
		
		
		//ЭлементыФормы.Количество.Заголовок = "КОЛ-ВО";
		Если ЗначениеЗаполнено(ТекКоличество) Тогда
			Если ТекКоличество<>1 Тогда
				//ЭлементыФормы.Количество.Заголовок = ТекКоличество;
			КонецЕсли;
		КонецЕсли;
		//УстановитьВидимостьКнопки("Количество", 1,,,0);	
	Иначе
		//УстановитьВидимостьКнопки("Количество", 0,,,0);	
	КонецЕсли;
	
	ИнтерфейсРМ.ЗаполнитьПодвал(ЭлементыФормы.ТабДокПодвал, Заказ, МакетПодвал);	
КонецПроцедуры

Процедура УстановитьТекСтроку() Экспорт
	Попытка
		Если Не ТекСтрокаТП = Неопределено Тогда
			ЭлементыФормы.тпТовары.ТекущаяСтрока = ТекСтрокаТП;
		КонецЕсли;                                                  		
	Исключение
		РаботаСокнами.ПоказатьПлашку(":-( ошибка", ОписаниеОшибки());
	КонецПопытки;                                           	
КонецПроцедуры

Процедура УстановитьСвойствоКнопки(ИмяКнопки, ЗначениеСвойства, Акцент = 0, Свойство = "Доступность", МенятьЦвет = Истина) Экспорт
	Кнопка = ЭлементыФормы[ИмяКнопки];
	МассивТеней = Новый Массив;	
	Тень1 = ЭлементыФормы.Найти(ИмяКнопки+"Тень2");
	Если Не Тень1 = Неопределено Тогда
	
		МассивТеней.Добавить(Тень1);
	
	КонецЕсли; 

	Тень2 = ЭлементыФормы.Найти(ИмяКнопки+"Тень2");
	Если Не Тень2 = Неопределено Тогда
	
		МассивТеней.Добавить(Тень2);
	
	КонецЕсли; 
	
	ЦветКнопки = ?(Акцент, Метаданные.ЭлементыСтиля.Акцент.Значение, Метаданные.ЭлементыСтиля.ЦветТемы.Значение);
	ЦветФонаНеактивнойКнопки = Метаданные.ЭлементыСтиля.НеактивнаяКнопка.Значение;
	ЦветТекстаНеактивнойКнопки = Метаданные.ЭлементыСтиля.НеактивныйЭлемент.Значение;
	
	Кнопка[Свойство] = ЗначениеСвойства;
	Если ЗначениеСвойства Тогда
		Кнопка.Видимость = Истина;
		Кнопка.Доступность = Истина;
	КонецЕсли;
	
	Если МенятьЦвет Тогда
		Кнопка.ЦветФонаКнопки 	=  ?(ЗначениеСвойства, ЦветКнопки, ЦветФонаНеактивнойКнопки);
		Кнопка.ЦветТекстаКнопки =  ?(ЗначениеСвойства, WebЦвета.Белый, 	ЦветТекстаНеактивнойКнопки);
		Кнопка.ЦветРамки = Кнопка.ЦветФонаКнопки;
	КонецЕсли;
	Для каждого Тень Из МассивТеней Цикл
		
		Тень.Видимость = ЗначениеСвойства;
		
	КонецЦикла; 
	
			
КонецПроцедуры

Процедура УстановитьДоступностьКнопки(ИмяКнопки, Доступность, Акцент = 0, Свойство = "", МенятьЦвет = Истина) Экспорт
	Свойство = "Доступность";
	УстановитьСвойствоКнопки(ИмяКнопки, Доступность, Акцент, Свойство, МенятьЦвет);
КонецПроцедуры

Процедура УстановитьВидимостьКнопки(ИмяКнопки, Доступность, Акцент = 0, Свойство = "", МенятьЦвет = Истина) Экспорт
	Свойство = "Видимость";
	УстановитьСвойствоКнопки(ИмяКнопки, Доступность, Акцент, Свойство, МенятьЦвет);
КонецПроцедуры

Процедура ОбновитьВремя() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаНаСервере = ТекущаяДатаНаСервере();
	тДата = Формат(ТекущаяДатаНаСервере,"ДФ='ddd, d MMMM'");
	тВремя = Формат(ТекущаяДатаНаСервере,"ДФ=HH:mm");
	тПользователь = ?(ЗначениеЗаполнено(глПользователь), Строка(глПользователь), "Система заблокирована");
	тТекущийРежим = ТекущийРежим; 										
	тБейдж = "";
	Если ТекущийДокумент = Неопределено Тогда
		тЗаказ = "";
		тБейдж = "";
	ИначеЕсли Не глФлагБлокировка Тогда
		Если ТекущийРежим = "ПРОДАЖА" Тогда
			КартаДоступа = Заказ.КартаДоступа;
			Идентификатор2 = КартаДоступа.Идентификатор2;
			Если ЗначениеЗаполнено(Идентификатор2) Тогда
				ИдентификаторКарты = Идентификатор2;
			Иначе
				ИдентификаторКарты = Прав(КартаДоступа.Идентификатор, 5);
			КонецЕсли;			
			тБейдж = "Бейдж " + ИдентификаторКарты;
		КонецЕсли;
		тЗаказ = "Заказ  " + НомерТекущегоЗаказа() + Символы.ПС +
		?(Не ОтборФирма.Использование, "Весь заказ", "По станции");
	КонецЕсли;
	
	ЭлементыФормы.КнопкаПереключитьФильтр.Заголовок  = тЗаказ;
	
	//ВЕСЫ
	ЭлементыФормы.кнВесы.Видимость = глПараметрыРМ.ВесыЕсть;
	Если глПараметрыРМ.ВесыЕсть Тогда
		Вес = Обработка_Весы.DRV.Вес;
		//Вес = глТорговоеОборудование.Scale1C.Вес;
		ОбновитьВес();
	КонецЕсли;
	
	тРабочееМесто = глРабочееМесто;		
	//ПодключитьОбработчикОжидания("ЗаполнитьНадписиЛояльности",1,1);
	ПодключитьОбработчикОжидания("ОбновитьВремя",10,1);	
КонецПроцедуры

Процедура ОбновитьОстальное() Экспорт
	ОбновитьВремя();
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
КонецПроцедуры

Процедура ПриОткрытии()
	
	ПодключитьОбработчикОжидания("ОбновитьВремя",2,1);
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	Стиль = БиблиотекаСтилей.СтанцияОплаты;
	ОбновитьНадписьИтого();
	
	ПодключитьОбработчикОжидания("Через2СекундыПослеОткрытия",0.1,1);
	УИДформы = Новый УникальныйИдентификатор;
	
	//Если глПараметрыРМ.Фирма = Справочники.МестаРеализации.Мяснов Тогда
	//	ЭтаФорма.Панель.Картинка = БиблиотекаКартинок.ЛогоКуулКлевер77;
	//ИначеЕсли Найти(глПараметрыРМ.Фирма, "Отдохни") Тогда
	//	ЭтаФорма.Панель.Картинка = БиблиотекаКартинок.ЛогоКуулКлевер77;
	//КонецЕсли;
	ИнтерфейсРМЛояльность.ФормаПриОткрытии(ЭтаФорма);
КонецПроцедуры

Процедура ВосстановитьФорму() Экспорт
		Если AutohotkeyDLL = Неопределено Тогда
			AutohotkeyDLL = РаботаСокнами.AHK(,"ВосстановитьФорму");
		КонецЕсли;
		
			Cкрипт = "
			|#NoTrayIcon
			|WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame,,15
			|Sleep 100
			|WinRestore, ahk_pid %pid ahk_class V8TopLevelFrame
			|WinMaximize, ahk_pid %pid ahk_class V8TopLevelFrame
			|Sleep 100
			|Send {alt down}{shift down}{VK52}{alt up}{shift up}
			|Exitapp";	
			Cкрипт = СтрЗаменить(Cкрипт, "%pid", формат(РаботаСокнами.pid, "ЧГ=0"));
			AutohotkeyDLL.ahkTextDll(Cкрипт);		
			
	ПодключитьОбработчикОжидания("ЗаблокироватьВформе", 1.1,1);
	
КонецПроцедуры

Процедура Через2СекундыПослеОткрытия() Экспорт
	ОбновитьНадписьИтого();
	ЭтаФорма.ТолькоПросмотр = Истина;
	
	ПодключитьОбработчикОжидания("ВосстановитьФорму",0.1,1);
		
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
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
	КонецЕсли; 
	
	Если ДанныеСтроки.Фирма <> глПараметрыРМ.Фирма Тогда
		ОформлениеСтроки.ЦветТекста = Метаданные.ЭлементыСтиля.НеактивнаяКнопка.Значение;
	КонецЕсли;
	
	Если ДанныеСтроки.СтатусОплаты = 1 Тогда
		ОформлениеСтроки.Ячейки.Сумма.ЦветФона = Метаданные.ЭлементыСтиля.БолееИнтенсивныйЗеленый.Значение;
		//ОформлениеСтроки.Ячейки.Сумма.ЦветФона = Метаданные.ЭлементыСтиля.ЦветФонаОплаченнойСтроки.Значение;
		//ОформлениеСтроки.Ячейки.Сумма.ЦветТекстаВыделения = Метаданные.ЭлементыСтиля.ЦветТемы.Значение;
	КонецЕсли;                                                                   	
	
	Если ДанныеСтроки.СтатусОплаты >= 0 Тогда
		ОформлениеСтроки.ЦветТекста =  Метаданные.ЭлементыСтиля.ЦветТекстаНедоступнойСтроки.Значение;
		//ОформлениеСтроки.ЦветТекстаВыделения = ОформлениеСтроки.ЦветТекста;
		//ОформлениеСтроки.ЦветФонаВыделения = Новый Цвет(255,255,255);
	КонецЕсли;
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();	
	AutohotkeyDLL = Неопределено;
КонецПроцедуры

Процедура СторноВсеНажатие(Элемент)
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
	ЭлементыФормы.тпТовары.Высота = ВысотаТаблицыЗаказа;
	ЭлементыФормы.ТеньТовары.Высота = ВысотаТаблицыЗаказа;
	ЭлементыФормы.тпТоварыВозврат.Высота = ВысотаТаблицыЗаказа;
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

Процедура ВыборМенюНажатие(Элемент)
	Если ВысотаТаблицыЗаказа = Неопределено Тогда
		ВысотаТаблицыЗаказа	= ЭлементыФормы.тпТовары.Высота;
		ВысотаПодвала		= Высота - (ЭлементыФормы.тпТовары.Верх + ВысотаТаблицыЗаказа);
	КонецЕсли;
	ПодборТоваров();
КонецПроцедуры

Процедура ПоискТовараНажатие(Элемент)
	Если фВводТоваровДоступен Тогда
		ОткрытьФормуПоиска();
		ОбновитьНадписьИтого();
	КонецЕсли;
КонецПроцедуры

Процедура ЗаблокироватьНажатие(Элемент)
	Заблокировать(Истина);
КонецПроцедуры

Процедура ЗаблокироватьВформе() Экспорт
	ТолькоПросмотр = Ложь;
	Заблокировать(Истина);
	Cкрипт = "
			|#NoTrayIcon
			|WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame
			|Sleep 100
			|Send {alt down}{shift down}{VK52}{alt up}{shift up}
			|Exitapp";	
	Cкрипт = СтрЗаменить(Cкрипт, "%pid", формат(РаботаСокнами.pid, "ЧГ=0"));
	AutohotkeyDLL.ahkTextDll(Cкрипт);		
КонецПроцедуры

Процедура ОплатаНажатие(Элемент)
	УстановитьДоступностьКнопки("Оплата", 0);
	ЭлементыФормы.тпТовары.ВыделенныеСтроки.Очистить();
	ПодключитьОбработчикОжидания("Оплата_ОбработкаОжидания",0.1,Истина);
КонецПроцедуры

Процедура Оплата_ОбработкаОжидания() Экспорт
	Попытка
		Если ТекущийРежим = "ВОЗВРАТ" Тогда
			ВозвратОплаты();
		Иначе
			Оплата();
		КонецЕсли;
		УстановитьДоступностьКнопки("Оплата", 1,1);
		ОбновитьНадписьИтого();
	Исключение
		ЗарегистрироватьСобытие("Ошибка выполенния в форме оплаты", УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	ОбновитьНадписьИтого();

	
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
	
	ТС = ЭлементыФормы.тпТовары.ТекущаяСтрока;
	Если ТС <> Неопределено Тогда
		НС = ТС.НомерСтроки;
	Иначе
		НС = 0;
	КонецЕсли;
	
	Сторно(НС);
	ОбновитьНадписьИтого();
КонецПроцедуры


Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ИзменениеСмены" Тогда
		//глПараметрыРМ.Вставить("НомерСмены", ИнтерфейсРМ.ТекущаяСмена().Номер);
		фВводТоваровДоступен = ЗначениеЗаполнено(ИнтерфейсРМ.ТекущаяСмена().Номер);
	КонецЕсли; 
КонецПроцедуры

Процедура кнЛояльностьНажатие(Элемент)
	МенюЛояльности();
	ОбновитьНадписьИтого();
КонецПроцедуры

Функция ПанелиСкрыты() Экспорт
	Если РежимТестирования Тогда
		Возврат Истина;
	КонецЕсли;
	Если фФормаСкрытияМеню = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Если ФормаСкрытияМеню.Открыта() Тогда
			Возврат Ложь;
		КонецЕсли;
		
	Исключение
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

Процедура ВводКартыГостя(Элемент)
	СброситьТекущийДокумент();	
КонецПроцедуры

Функция ПоказатьПлашки() Экспорт
	//УстановитьВидимостьКнопки("Плашка1",ЗначениеЗаполнено(ЭлементыФормы.Плашка1.Заголовок),,,Ложь);	
	//УстановитьВидимостьКнопки("Плашка2",ЗначениеЗаполнено(ЭлементыФормы.Плашка2.Заголовок),,,Ложь);	
	//ЭлементыФормы.НадписьЛояльность2.Видимость = 1;
	//ШиринаПашки = ЭлементыФормы.Плашка1Тень.Лево + ЭлементыФормы.Плашка1Тень.Ширина + 3;
	//Для Каждого Элемент Из мСдвигаемыеЭлементы Цикл
	//	былоЛево = Элемент.Лево;	
	//	Лево = ШиринаПашки + ?(СтрНайти(Элемент.Имя,"Тень"),3,0);
	//	Дельта = былоЛево - Лево;
	//	Если Дельта Тогда
	//		Элемент.Ширина = Элемент.Ширина + Дельта; 
	//		Элемент.Лево = Лево;
	//	КонецЕсли;
	//	
	//КонецЦикла;	
	//ЭлементыФормы.КнопкаСкрытьПаказать.Заголовок = Шрифты.ПолучитьСимвол("arrow_circle_o_left");
	//ЭлементыФормы.КнопкаСкрытьПаказать.ЦветТекста = Метаданные.ЭлементыСтиля.АппБар.Значение;
	
КонецФункции

Функция СкрытьПлашки() Экспорт
	//УстановитьВидимостьКнопки("Плашка1",0,,,Ложь);
	//УстановитьВидимостьКнопки("Плашка2",0,,,Ложь);
	//ЭлементыФормы.НадписьЛояльность2.Видимость = 0;
	//Для Каждого Элемент Из мСдвигаемыеЭлементы Цикл
	//	былоЛево = Элемент.Лево;	
	//	Лево = 6 + ?(СтрНайти(Элемент.Имя,"Тень"),3,0);
	//	Дельта = былоЛево - Лево;
	//	Если Дельта Тогда
	//		Элемент.Лево = Лево;
	//		Элемент.Ширина = Элемент.Ширина + Дельта; 
	//	КонецЕсли;
	//КонецЦикла;	
	//ЭлементыФормы.КнопкаСкрытьПаказать.Заголовок = Шрифты.ПолучитьСимвол("arrow_circle_o_right");
	//ЭлементыФормы.КнопкаСкрытьПаказать.ЦветТекста = Метаданные.ЭлементыСтиля.Акцент.Значение;
КонецФункции
		
Процедура тпТоварыПриАктивизацииСтроки(Элемент)
	Попытка
		ТекущийЭлемент = ЭлементыФормы.Плашка11;
	Исключение
	КонецПопытки;
	Если Элемент.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Элемент.ТекущиеДанные.СтатусОплаты = 1 Тогда
		Элемент.РежимВыделенияСтроки  = РежимВыделенияСтрокиТабличногоПоля.Ячейка;
	Иначе
		Элемент.РежимВыделенияСтроки  = РежимВыделенияСтрокиТабличногоПоля.Строка;
	КонецЕсли;
	ПоказатьЗаказНаМонитореГостя();
КонецПроцедуры

Процедура ПереключитьФильтр(Элемент)
	ОтборФирма.Использование = Не ОтборФирма.Использование;
	//Если ОтборФирма.Использование Тогда
	//	Элемент.Картинка = БиблиотекаКартинок.НеФильтр;
	//Иначе
	//	Элемент.Картинка = БиблиотекаКартинок.Фильтр;
	//КонецЕсли;
	ОбновитьВремя();
КонецПроцедуры

Процедура тпТоварыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	ПоказатьИнформациюОтоваре(Элемент.ТекущиеДанные.Товар);
КонецПроцедуры

Функция ПоказатьИнформациюОтоваре(Товар) Экспорт
	Обработка = ИнтерфейсРМ.ПолучитьОбъектОбработки("ИнформацияОтоваре");
	//: Обработка = Обработки.ИнформацияОтоваре.Создать();
	Обработка.Товар = Товар;
	Обработка.ПолучитьФорму().ОткрытьМодально();
КонецФункции

Процедура ПлашкаКупонНажатие(Элемент) Экспорт 
	ИнтерфейсРМЛояльность.ПлашкаКупонНажатие(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура Плашка_Н_Нажатие(Элемент) Экспорт 
	ИнтерфейсРМЛояльность.Плашка_Н_Нажатие(ЭтаФорма, Элемент);
	//ЛояльностьДанныеЗаказа = ИнтерфейсРМЛояльность.ОбновитьТовары(ЭтаФорма);
	ЭлементыФормы.тпТовары.ОбновитьСтроки();
КонецПроцедуры

Процедура тпТоварыПриПолученииДанных(Элемент, ОформленияСтрок)
	ИнтерфейсРМЛояльность.тпТоварыПриПолученииДанных(ЭтаФорма, Элемент, ОформленияСтрок, ЛояльностьДанныеЗаказа);
КонецПроцедуры

#Область ВЕСЫ

Процедура кнВесыНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	МенюВесов(Вес);
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ОбновитьВес() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	ЭлементыФормы.тВес.Заголовок = Формат(Вес,"ЧДЦ=3; ЧРД=.; ЧН=0.000");
	Если фВводТоваровДоступен = Истина Тогда
		ИнтерфейсРМ.ВыводНаИнфоДисплей("ПоказатьВес",,,,,Вес);	
	КонецЕсли;
КонецПроцедуры

Процедура тпТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ВводНовойСтроки(ВыбранноеЗначение);

КонецПроцедуры

#КонецОбласти

тПользователь = "";
тЗаказ = "";

фФормаСкрытияМеню = 0;
ОтборКоличество = ЭлементыФормы.тпТовары.ОтборСтрок.Количество;
ОтборКоличество.ВидСравнения = ВидСравнения.НеРавно;
//ОтборКоличество.Использование = 1;

ОтборСтатусОплаты = ЭлементыФормы.тпТовары.ОтборСтрок.СтатусОплаты;
ОтборСтатусОплаты.ВидСравнения = ВидСравнения.Равно;
ОтборСтатусОплаты.значение = -1;
//ОтборСтатусОплаты.Использование = Истина;

//ВЕСЫ
Если глПараметрыРМ.ВесыЕсть Тогда
	Весы = глПараметрыРМ.Весы.ПолучитьОбъект();
	Обработка_Весы = Обработка_Весы;
	ИнициализацияТО(Весы, Обработка_Весы, глПараметрыРМ);
КонецЕсли;

ОтборФирма = ЭлементыФормы.тпТовары.ОтборСтрок.Фирма;
ОтборФирма.ВидСравнения = ВидСравнения.Равно;	 
ОтборФирма.Значение = глПараметрыРМ.Фирма;
//ОтборФирма.Использование = Истина;
Попытка
	AutohotkeyDLL = РаботаСокнами.AHK(,"ГлавнаяФорма");
Исключение
КонецПопытки;
//ФормаСкрытияМеню = Обработки.СкрытьМенюИПанели.ПолучитьФорму();
//ФормаСкрытияМеню.Открыть();	
