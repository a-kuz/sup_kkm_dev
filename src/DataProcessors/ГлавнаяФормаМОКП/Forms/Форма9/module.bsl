﻿
Перем ФормаСкрытияМеню, фФормаСкрытияМеню;
Перем мСдвигаемыеЭлементы;
Перем ОтборФирма;
Перем КупоныСоответствие Экспорт;
Перем МакетПодвал;
Перем СкрываемыеЭлементыФормы Экспорт;

Процедура СкрытьПоказатьКнопки(Показать = Ложь)
	Для Каждого Эл Из ЭлементыФормы Цикл
		Если СкрываемыеЭлементыФормы.Найти(Эл) = Неопределено Тогда			
			
			
			Если СтрНачинаетсяС(Эл.Имя, "Кнопка") или СтрНачинаетсяС(Эл.Имя, "Плашка") Тогда
				Эл.Видимость = Показать;
			КонецЕсли;
		КонецЕсли; 
	КонецЦикла;
	
	ЭлементыФормы.НадписьЛояльность1.Видимость = Показать;
	
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
		//ЭлементыФормы.ТеньТовары.Видимость = 1;
		СкрытьПоказатьКнопки(Истина);
	ИначеЕсли  ТекущийРежим = "ПРОДАЖА" Тогда
		ЭлементыФормы.тпТовары.Видимость = 1;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 0;
		//ЭлементыФормы.ТеньТовары.Видимость = 1;
		СкрытьПоказатьКнопки(Истина);
	Иначе
		//ЭлементыФормы.ТеньТовары.Видимость = 0;
		ЭлементыФормы.тпТовары.Видимость = 0;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 0;
		СкрытьПоказатьКнопки();
	КонецЕсли;
	ИтогоСумма = 0;
	ИтогоКоличество = 0;
	ЕстьЧужиеТовары = Ложь;
	ТекИдСтрокиТовара = ТекИдСтрокиТовара();
	ТекСтрока = Неопределено;
	Если ТекИдСтрокиТовара <> Неопределено Тогда
		Попытка
			ТекСтрока = ТекущийДокумент.Товары.Найти(ТекИдСтрокиТовара, "ИдСтроки");		
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	ЗаполнитьТПтовары();
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
				
				Если Т.Количество И ТекСтрока = Неопределено Тогда
					ТекСтрока = Т;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		Попытка
			ТекСтрокаТП = тпТовары.Строки.Найти(ТекИдСтрокиТовара);				
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
	
	тЗаказ = "Заказ  " + НомерТекущегоЗаказа() + Символы.ПС;
	Если ЕстьЧужиеТовары Тогда
		тЗаказ = тЗаказ + ?(Не ОтборФирма, "Весь заказ", "по фирме");	
	КонецЕсли;
	ЭлементыФормы.КнопкаПереключитьФильтр.Заголовок = тЗаказ;

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
	Если глПараметрыРМ.ЭтоОтдохни Тогда
		Если ТекКоличество = 1 Или Не ЗначениеЗаполнено(ТекКоличество) Тогда
			ЭлементыФормы.кнКоличество.Заголовок = "123";
			ЭлементыФормы.кнКоличество.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопкиАппБара;
		Иначе
			ЭлементыФормы.кнКоличество.Заголовок = ТекКоличество;
			ЭлементыФормы.кнКоличество.ЦветТекстаКнопки = ЦветаСтиля.Акцент;
		КонецЕсли;
	КонецЕсли;
	ИнтерфейсРМ.ЗаполнитьПодвал(ЭлементыФормы.ТабДокПодвал, Заказ, МакетПодвал);	
КонецПроцедуры

Процедура УстановитьТекСтроку() Экспорт
	Попытка
		Если Не ТекИдСтрокиТовара = Неопределено Тогда
			СтрокаТП =  тпТовары.Строки.Найти(ТекИдСтрокиТовара, "ИдСтроки");
			Если СтрокаТП <> ЭлементыФормы.тпТовары.ТекущаяСтрока И СтрокаТП <> Неопределено Тогда
				ЭлементыФормы.тпТовары.ТекущаяСтрока = СтрокаТП;
			КонецЕсли;
		КонецЕсли;                                                  		
	Исключение
		//РаботаСокнами.ПоказатьПлашку(":-( ошибка", ОписаниеОшибки());
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
		?(Не ОтборФирма, "Весь заказ", "по фирме");
	КонецЕсли;
	
	
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
	ОбновитьНадписьИтого();
	
	ПодключитьОбработчикОжидания("Через2СекундыПослеОткрытия",0.1,1);
	УИДформы = Новый УникальныйИдентификатор;
	
	//Если глПараметрыРМ.Фирма = Справочники.МестаРеализации.Мяснов Тогда
	//	ЭтаФорма.Панель.Картинка = БиблиотекаКартинок.ЛогоКуулКлевер77;
	//ИначеЕсли Найти(глПараметрыРМ.Фирма, "Отдохни") Тогда
	//	ЭтаФорма.Панель.Картинка = БиблиотекаКартинок.ЛогоКуулКлевер77;
	//КонецЕсли;
	ЭлементыФормы.тпТовары.СоздатьКолонки();
	ИнтерфейсРМЛояльность.ФормаПриОткрытии(ЭтаФорма);
	
	ЭлементыФормы.тпТовары.Колонки.Автор.Видимость = ложь;
	ЭлементыФормы.тпТовары.Колонки.фАлкоголь.Видимость = ложь;
	ЭлементыФормы.тпТовары.Колонки.КоличествоНачальное.видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Блок.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Фирма.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.ИдСтроки.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.ИдСвязаннойСтроки.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Модифицирована.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.СтатусОплаты.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.СтатусДопИнф.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.РабочееМесто.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Станция.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.КоличествоУдалено.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.НомерМарки.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Статус.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Подача.Видимость = Ложь;
	
	ЭлементыФормы.тпТовары.Колонки.ГруппаАкции.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Цена.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Сумма.Видимость = Ложь;

	//ЭлементыФормы.тпТовары.ТолькоПросмотр = истина;
	ЭлементыФормы.тпТовары.Шапка = Ложь;
	ЭлементыФормы.тпТовары.ВертикальныеЛинии = Ложь;
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ОтображатьИерархию = Ложь;
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ШрифтТекста = Новый Шрифт(ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ШрифтТекста,,4);
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.Ширина = 2;
	//ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ВысотаЯчейки = 2;
	
	СкрываемыеЭлементыФормы = Новый Массив;
	Если глПараметрыРМ.ЭтоОтдохни Тогда
		ИменаЭлементов = Массив("КнопкаСпецифики", "КнопкаОбщиеСпецифики", "КнопкаВыдача","кнПейджер", "кнМарки");
		
		ЭлементыФормы.КнопкаСторно.Лево = Ширина - 271;
		ЭлементыФормы.КнопкаСторно.УстановитьПривязку(ГраницаЭлементаУправления.Право,ЭлементыФормы.тпТовары,ГраницаЭлементаУправления.Право);
		ЭлементыФормы.КнопкаСторно.УстановитьПривязку(ГраницаЭлементаУправления.Лево,ЭлементыФормы.тпТовары,ГраницаЭлементаУправления.Право);
		ЭлементыФормы.тпТовары.Высота = ЭлементыФормы.тпТовары.Высота + ЭлементыФормы.КнопкаИнфо.Высота/2;
	Иначе
		ИменаЭлементов = Новый Массив;
	КонецЕсли;
	
	Для каждого ИмяЭлемента Из ИменаЭлементов Цикл
		
		СкрываемыеЭлементыФормы.Добавить(ЭлементыФормы[ИмяЭлемента]);	
		ЭлементыФормы[ИмяЭлемента].Видимость = 0;
	КонецЦикла;
	
КонецПроцедуры

Процедура Через2СекундыПослеОткрытия() Экспорт                            	
	ОбновитьНадписьИтого();
	ЭтаФорма.ТолькоПросмотр = Истина;
	
	ПодключитьОбработчикОжидания("ВосстановитьФорму",0.1,1);
		
КонецПроцедуры

Процедура ВосстановитьФорму() Экспорт
	ЗаблокироватьВформе = Не ЗначениеЗаполнено(глПользователь); 
	Если AutohotkeyDLL = Неопределено Тогда
		AutohotkeyDLL = РаботаСокнами.AHK(,"ВосстановитьФорму");
	КонецЕсли;
	Cкрипт = "
	|#NoTrayIcon
	|#NoEnv
	|WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame,,150
	|Sleep 100
	|WinRestore, ahk_pid %pid ahk_class V8TopLevelFrame
	|WinMaximize, ahk_pid %pid ahk_class V8TopLevelFrame
	|Sleep 100
	|Send {alt down}{shift down}{VK52}{alt up}{shift up}
	|Exitapp";	
	Cкрипт = СтрЗаменить(Cкрипт, "%pid", формат(РаботаСокнами.pid, "ЧГ=0"));
	
	AutohotkeyDLL.ahkTextDll(Cкрипт);		
	Если ЗаблокироватьВформе Тогда
		ГлавнаяФорма.ПодключитьОбработчикОжидания("ЗаблокироватьВформе", 0.5,1);
	КонецЕсли;	

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

Процедура ЗаполнитьТПтовары() Экспорт
	
	Если ТекущийДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	//:ТекущийДокумент = Документы.Заказ.СоздатьДокумент();
	
	// заполним таблицу на форме
	ТекИдСтрокиТовара = ТекИдСтрокиТовара();
	ТекСтрока = Неопределено;
	
	тпТовары.Строки.Очистить();
	Для каждого стр из ТекущийДокумент.Товары Цикл
		Если ОтборФирма И глПараметрыРМ.ФирмыРМ.Найти(стр.Фирма) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		НовСтрока = тпТовары.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока,стр);
		НовСтрока.Блок = НЕ стр.ДокументОплаты.Пустая();
		
		МС = ТекущийДокумент.Специфики.НайтиСтроки(Новый Структура("НомерСтрокиТовара",Стр.НомерСтроки));
		Для Каждого СтрокаСпецифика ИЗ МС Цикл
			НовСтрокаСпецифика = НовСтрока.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрокаСпецифика, СтрокаСпецифика);		
			НовСтрокаСпецифика.Товар = СтрокаСпецифика.Специфика;
			НовСтрокаСпецифика.СуммаРеализации = НовСтрокаСпецифика.ЦенаРеализации * НовСтрокаСпецифика.Количество;
		КонецЦикла;
				
		Если НовСтрока.Количество И не НовСтрока.Блок Тогда
			ТекСтрока = НовСтрока;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Т Из тпТовары.Строки Цикл
		Если т.Строки.Количество() Тогда
			ЭлементыФормы.тпТовары.Развернуть(Т);
		КонецЕсли;
		
	КонецЦикла;
	УстановитьТекСтроку();
	фНеУстанавливатьТекСтроку = Истина;	
	ПодключитьОбработчикОжидания("УстановитьТекСтроку", 0.2, 1);	
	
КонецПроцедуры


Процедура тпТоварыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ДанныеСтроки = Неопределено Тогда
		ОформлениеСтроки.ЦветТекста = ОформлениеСтроки.ЦветФона;
		Возврат;
	КонецЕсли;
	
		
	ОформлениеСтрокиЗаказа(Элемент, ОформлениеСтроки, ДанныеСтроки)	
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
	//ЭлементыФормы.ТеньТовары.Высота = ВысотаТаблицыЗаказа;
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
	
	ОбработатьОповещение(ИмяСобытия, Параметр, Источник);
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
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	//Если Элемент.ТекущиеДанные.СтатусОплаты = 1 Тогда
	//	Элемент.РежимВыделенияСтроки  = РежимВыделенияСтрокиТабличногоПоля.Ячейка;
	//Иначе
	//	Элемент.РежимВыделенияСтроки  = РежимВыделенияСтрокиТабличногоПоля.Строка;
	//КонецЕсли;
	
	
	Если ТекИдСтрокиТовара <> ТекИдСтрокиТовара() Тогда
		
		
		Если фНеУстанавливатьТекСтроку Тогда
			фНеУстанавливатьТекСтроку = Ложь;
		Иначе
			ЭлементыФормы.тпТовары.ОбновитьСтроки();
			ТекИдСтрокиТовара = ТекИдСтрокиТовара();
		КонецЕсли;
		ЭлементыФормы.тпТовары.ОбновитьСтроки();
	Иначе
		Если ЭлементыФормы.тпТовары.ТекущиеДанные.Уровень() Тогда
			ЭлементыФормы.тпТовары.ОбновитьСтроки(ЭлементыФормы.тпТовары.ТекущиеДанные.Родитель.строки);
			ЭлементыФормы.тпТовары.ОбновитьСтроки(ЭлементыФормы.тпТовары.ТекущиеДанные.Родитель);
		Иначе
			ЭлементыФормы.тпТовары.ОбновитьСтроки(ЭлементыФормы.тпТовары.ТекущиеДанные.Строки);
			
		КонецЕсли;
		
	КонецЕсли;

	ПоказатьЗаказНаМонитореГостя(1);
КонецПроцедуры




Процедура ПереключитьФильтр(Элемент)
	ОтборФирма = Не ОтборФирма;
	Если ОтборФирма Тогда
		ДопПараметрыИнфо.Вставить("ФирмаФильтр", глПараметрыРМ.Фирма);
	Иначе
		ДопПараметрыИнфо.Вставить("ФирмаФильтр", Неопределено);
	КонецЕсли;
	//Если ОтборФирма.Использование Тогда
	//	Элемент.Картинка = БиблиотекаКартинок.НеФильтр;
	//Иначе
	//	Элемент.Картинка = БиблиотекаКартинок.Фильтр;
	//КонецЕсли;
	
	тЗаказ = "Заказ  " + НомерТекущегоЗаказа() + Символы.ПС;
	тЗаказ = тЗаказ + ?(Не ОтборФирма, "Весь заказ", "по фирме");	
	ЭлементыФормы.КнопкаПереключитьФильтр.Заголовок = тЗаказ;

	ПрочитатьТекущийДокумент();
	ПоказатьЗаказНаМонитореГостя();
	ИнтерфейсРМЛояльность.ОбновитьТабДокЛояльность(ГлавнаяФорма, , ЛояльностьДанныеЗаказа);

	ОбновитьВремя();
КонецПроцедуры

Процедура тпТоварыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	//казатьИнформациюОтоваре(Элемент.ТекущиеДанные.Товар);
	ИзменитьКурс(Истина);
КонецПроцедуры

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
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВводНовойСтроки(ВыбранноеЗначение);
	
КонецПроцедуры

Процедура КнопкаИнфоНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Уровень = ЭлементыФормы.тпТовары.ТекущаяСтрока.Уровень();
	Если Уровень Тогда
		ПоказатьИнформациюОтоваре(ЭлементыФормы.тпТовары.ТекущиеДанные.Родитель.Товар);
	Иначе
			ПоказатьИнформациюОтоваре(ЭлементыФормы.тпТовары.ТекущиеДанные.Товар);
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаКоличествоНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТС = ТекИдСтрокиТовара();
	Если ИзменитьКоличество() Тогда
		ИнтерфейсРМ.ЗаполнитьПодвал(ЭлементыФормы.ТабДокПодвал, Заказ, МакетПодвал);	
		ТекИдСтрокиТовара = ТС;
		ПодключитьОбработчикОжидания("УстановитьТекСтроку", 0.1, 1);
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаСпецификиНажатие(Элемент)
Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлементыФормы.тпТовары.ТекущиеДанные.Уровень() Тогда
		ТекИД = ЭлементыФормы.тпТовары.ТекущиеДанные.Родитель.ИдСтроки;
	Иначе
		ТекИД = ЭлементыФормы.тпТовары.ТекущиеДанные.ИдСтроки;
	КонецЕсли;
	
	// Выбор специфики
	//
	ВыборСпецифики();
	
	СтрокаТП = тпТовары.Строки.Найти(ТекИД, "ИдСтроки");
	Если СтрокаТП <> Неопределено Тогда
		ЭлементыФормы.тпТовары.ТекущаяСтрока = СтрокаТП;
	КонецЕсли;

	ПоказатьЗаказНаМонитореГостя();
КонецПроцедуры

Процедура КнопкаОбщиеСпецификиНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВыборСпецифики(Истина);
КонецПроцедуры

Процедура кнМаркиНажатие(Элемент)
	МониторМарок();
КонецПроцедуры

Процедура кнПейджерНажатие(Элемент)
	ВозвратПейджера();
КонецПроцедуры

Процедура КнопкаВыдачаНажатие(Элемент)
	ИзменитьКурс(Истина);
КонецПроцедуры

Процедура КнопкаСторноНажатие(Элемент)
		ТС = ЭлементыФормы.тпТовары.ТекущаяСтрока;
	Если ТС <> Неопределено Тогда
		НС = ТС.НомерСтроки;
	Иначе
		НС = 0;
	КонецЕсли;
	
	Сторно(НС);
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ВыборТовараНажатие(Элемент)
	ВыборМенюНажатие(Элемент);
КонецПроцедуры

Процедура кнКоличествоНажатие(Элемент)
		ИзменитьКоличествоПриВыборе();
		ОбновитьНадписьИтого();
КонецПроцедуры

Процедура КнопкаЛюбимыеРецептыНажатие(Элемент)
	РецептыГостя();
КонецПроцедуры

#КонецОбласти

тПользователь = "";
тЗаказ = "";

фФормаСкрытияМеню = 0;

МассивЧисла = Новый Массив;
МассивЧисла.Добавить(Тип("Число"));

МассивТоварСпецифика = Массив(Тип("СправочникСсылка.Товары"), Тип("СправочникСсылка.Специфики"));
тпТовары.Строки.Очистить();
тпТовары.Колонки.Очистить();
тпТовары.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"),"N",5);

тпТовары.Колонки.Добавить("Автор",Новый ОписаниеТипов("СправочникСсылка.Сотрудники"),,1);
тпТовары.Колонки.Добавить("Товар",Новый ОписаниеТипов(МассивТоварСпецифика),,60);
тпТовары.Колонки.Добавить("Количество",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("КоличествоУдалено",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("х",,,1);
тпТовары.Колонки.Добавить("ЦенаРеализации",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,9);
тпТовары.Колонки.Добавить("Равно",,,1);
тпТовары.Колонки.Добавить("СуммаРеализации",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,10);
тпТовары.Колонки.Добавить("фАлкоголь",,,8);
тпТовары.Колонки.Добавить("КоличествоНачальное",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("Подача",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(12,0)),,9);
тпТовары.Колонки.Добавить("блок",Новый ОписаниеТипов("Булево"),,1);

тпТовары.Колонки.Добавить("Фирма", Новый ОписаниеТипов("СправочникСсылка.Фирмы"),,1); 
тпТовары.Колонки.Добавить("ИдСтроки", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(30)),,1); 
тпТовары.Колонки.Добавить("ИдСвязаннойСтроки", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(30)),,1); 
тпТовары.Колонки.Добавить("СтатусОплаты",Новый ОписаниеТипов("Число"),,1);
тпТовары.Колонки.Добавить("Модифицирована",Новый ОписаниеТипов("Булево"),,1);

тпТовары.Колонки.Добавить("ЛояльностьГруппаАкции",Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(5,0)),,1);

тпТовары.Колонки.Добавить("Цена",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("Сумма",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("Статус",Новый ОписаниеТипов(Массив(Тип("ПеречислениеСсылка.СтатусыПозицийЗаказа")),,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("СтатусДопИнф",Новый ОписаниеТипов(Массив(Тип("ПеречислениеСсылка.СтатусыПозицийЗаказа")),,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("РабочееМесто",Новый ОписаниеТипов(Массив(Тип("СправочникСсылка.РабочиеМеста")),,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("НомерМарки",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,0)),,0);
тпТовары.Колонки.Добавить("Станция",Новый ОписаниеТипов(Массив(Тип("СправочникСсылка.Станции"))));
//ВЕСЫ
Если глПараметрыРМ.ВесыЕсть Тогда
	Весы = глПараметрыРМ.Весы.ПолучитьОбъект();
	Обработка_Весы = Обработка_Весы;
	ИнициализацияТО(Весы, Обработка_Весы, глПараметрыРМ);
КонецЕсли;

//ОтборФирма = ЭлементыФормы.тпТовары.ОтборСтрок.Фирма;
//ОтборФирма.ВидСравнения = ВидСравнения.Равно;	 
//ОтборФирма.Значение = глПараметрыРМ.Фирма;
//ОтборФирма.Использование = Истина;
Попытка
	AutohotkeyDLL = РаботаСокнами.AHK(,"ГлавнаяФорма");
Исключение
КонецПопытки;
//ФормаСкрытияМеню = Обработки.СкрытьМенюИПанели.ПолучитьФорму();
//ФормаСкрытияМеню.Открыть();	
ОтборФирма = Истина;
ДопПараметрыИнфо.Вставить("ФирмаФильтр", глПараметрыРМ.Фирма);

СкрываемыеЭлементыФормы = Новый Массив;