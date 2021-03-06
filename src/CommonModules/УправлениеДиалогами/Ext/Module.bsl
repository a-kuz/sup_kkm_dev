﻿Функция ПолучитьЭлементДиалогаПоТипу(ШаблонДиалога, Тип)
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЭлементыДиалогов.Ссылка
	|ИЗ
	|	Справочник.ЭлементыДиалогов КАК ЭлементыДиалогов
	|ГДЕ
	|	ЭлементыДиалогов.Владелец = &ШаблонДиалога
	|	И ЭлементыДиалогов.ТипЭлементаДиалога = &ТипЭлементаДиалога
	|	И НЕ ЭлементыДиалогов.ПометкаУдаления");
	Запрос.УстановитьПараметр("ШаблонДиалога", ШаблонДиалога);
	Запрос.УстановитьПараметр("ТипЭлементаДиалога", Тип);
	Рез = Запрос.Выполнить().Выгрузить();
	Если Рез.Количество() Тогда
		Возврат Рез[0].Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли; 
КонецФункции // ПолучитьЭлементДиалогаПоТипу()

Функция ПолучитьСледующийЭлемент(Элемент)
	Если ЗначениеЗаполнено(Элемент.СледующийЭлемент) Тогда
		
		Возврат Элемент.СледующийЭлемент;
		
	КонецЕсли; 	
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЭлементыДиалогов.Ссылка
	|ИЗ
	|	Справочник.ЭлементыДиалогов КАК ЭлементыДиалогов
	|ГДЕ
	|	ЭлементыДиалогов.Родитель = &Родитель
	|	И НЕ ЭлементыДиалогов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ЭлементыДиалогов.НомерПП");	
	Запрос.УстановитьПараметр("Родитель", Элемент);
	Рез = Запрос.Выполнить().Выгрузить();
	Если Рез.Количество() Тогда
		Возврат Рез[0].Ссылка;
	Иначе 
		Возврат Неопределено;	
	КонецЕсли; 
КонецФункции

Процедура Зарегистрировать(Заказ, Станция, ЭлементДиалога, Ответ=Неопределено)
	Нов = РегистрыСведений.ДиалогиНаСтанциях.СоздатьМенеджерЗаписи();
	Нов.Период = ТекущаяДата();
	Нов.Заказ = Заказ;
	Нов.Станция = Станция;
	Нов.ЭлементДиалога = ЭлементДиалога;
	Нов.Ответ = Ответ;
	Нов.Пользователь = глПользователь;
	Нов.ШаблонДиалога = ЭлементДиалога.Владелец;
	Нов.Записать();
КонецПроцедуры 

Функция АктивныеШаблоны(Станция, Дата, СобытиеАктивации = Неопределено)
	Запрос = Новый Запрос("
	|ВЫБРАТЬ
	|	ШаблоныДиалогов.ШаблонАктивности,
	|	ШаблоныДиалогов.ВариантПовторнойАктивации,
	|	ШаблоныДиалогов.Ссылка КАК ШаблонДиалога
	|ПОМЕСТИТЬ АктивныеШаблоны
	|ИЗ
	|	Справочник.ШаблоныДиалогов КАК ШаблоныДиалогов
	|ГДЕ
	|	ШаблоныДиалогов.Действует
	|	И ШаблоныДиалогов.СобытиеАктивации = &СобытиеАктивации
	|	И (ШаблоныДиалогов.СобытиеАктивации = &СобытиеАктивации
	|			ИЛИ ШаблоныДиалогов.СобытиеАктивации = НЕОПРЕДЕЛЕНО)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ШаблоныАктивностиСтанции.Расписание,
	|	АктивныеШаблоны.ШаблонДиалога,
	|	АктивныеШаблоны.ВариантПовторнойАктивации
	|ПОМЕСТИТЬ Расписания
	|ИЗ
	|	АктивныеШаблоны КАК АктивныеШаблоны
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШаблоныАктивности.Станции КАК ШаблоныАктивностиСтанции
	|		ПО АктивныеШаблоны.ШаблонАктивности = ШаблоныАктивностиСтанции.Ссылка
	|ГДЕ
	|	ШаблоныАктивностиСтанции.Станция = &Станция
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Расписания.Расписание,
	|	Расписания.ШаблонДиалога,
	|	Расписания.ВариантПовторнойАктивации
	|ПОМЕСТИТЬ ДействующиеНаДеньНедели
	|ИЗ
	|	Расписания КАК Расписания
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Расписания.ДниНедели КАК РасписанияДниНедели
	|		ПО Расписания.Расписание = РасписанияДниНедели.Ссылка
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Расписания.ПериодыАктивности КАК РасписанияПериодыАктивности
	|		По РасписанияПериодыАктивности.Ссылка = Расписания.Расписание и (РасписанияПериодыАктивности.ДеньНедели = РасписанияДниНедели.ДеньНедели или РасписанияПериодыАктивности.ДеньНедели = ЗНАЧЕНИЕ(Перечисление.ДниНедели.ПустаяСсылка) )
	|ГДЕ
	|	РасписанияДниНедели.ДеньНедели = &ДеньНедели
	|	И РасписанияДниНедели.Действует
	|	И &ТекущееВремя Между РасписанияПериодыАктивности.ВремяНач и РасписанияПериодыАктивности.ВремяКон
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ДействующиеНаДеньНедели.ВариантПовторнойАктивации,
	|	ДействующиеНаДеньНедели.ШаблонДиалога
	|ИЗ
	|	ДействующиеНаДеньНедели КАК ДействующиеНаДеньНедели
	|		
	|");
	Запрос.УстановитьПараметр("Станция", Станция);	
	Запрос.УстановитьПараметр("ДеньНедели", Перечисления.ДниНедели[ДеньНедели(Дата)-1]);	
	Запрос.УстановитьПараметр("СобытиеАктивации", СобытиеАктивации);	
	Запрос.УстановитьПараметр("ТекущееВремя", ВремяИзДаты(ТекущаяДата()));	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции 

Функция ДиалогДолженБытьАктивирован(Заказ, Станция, ШаблонДиалога, СобытиеАктивации, ВариантПовторнойАктивации)
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ШаблонДиалога", ШаблонДиалога);
	Запрос.УстановитьПараметр("Заказ", Заказ);
	Запрос.УстановитьПараметр("Станция", Станция);
	Если ВариантПовторнойАктивации = Справочники.ВариантыПовторнойАктивации.НеКонтролировать Тогда
		Возврат Истина;
	ИначеЕсли ВариантПовторнойАктивации = Справочники.ВариантыПовторнойАктивации.НаКаждойСтанции Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ДиалогиНаСтанциях.Заказ
		|ИЗ
		|	РегистрСведений.ДиалогиНаСтанциях КАК ДиалогиНаСтанциях
		|ГДЕ
		|	ДиалогиНаСтанциях.Заказ = &Заказ
		|	И ДиалогиНаСтанциях.Станция = &Станция
		|	И ДиалогиНаСтанциях.ШаблонДиалога = &ШаблонДиалога";
	ИначеЕсли ВариантПовторнойАктивации = Справочники.ВариантыПовторнойАктивации.ОдинРаз Тогда
		Запрос.Текст = "
		|ВЫБРАТЬ
		|	ДиалогиНаСтанциях.Заказ
		|ИЗ
		|	РегистрСведений.ДиалогиНаСтанциях КАК ДиалогиНаСтанциях
		|ГДЕ
		|	ДиалогиНаСтанциях.Заказ = &Заказ
		|	И ДиалогиНаСтанциях.ШаблонДиалога = &ШаблонДиалога";

	КонецЕсли; 
	Возврат Запрос.Выполнить().Пустой();
КонецФункции // ДиалогДолженБытьАктивирован()
 
Процедура ОбработкаСобытияАктивации(ОбработкаЗаказ, СобытиеАктивации)
	Заказ = ОбработкаЗаказ.Заказ.Ссылка;
	Станция = глРабочееМесто.Станция;
	АктивныеШаблоны = АктивныеШаблоны(Станция, ТекущаяДата(), СобытиеАктивации);	
	Для каждого Т Из АктивныеШаблоны Цикл
		Если ДиалогДолженБытьАктивирован(Заказ, Станция, Т.ШаблонДиалога, СобытиеАктивации, Т.ВариантПовторнойАктивации) Тогда
		    Попытка
				АктивироватьДиалог(ОбработкаЗаказ, Станция, Т.ШаблонДиалога, СобытиеАктивации, Т.ВариантПовторнойАктивации);
			Исключение
				ОписаниеОшибки = ОписаниеОшибки();
				Сообщить(ОписаниеОшибки());
				ЗарегистрироватьСобытие("Управление диалогами", УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.ШаблоныДиалогов, Т.ШаблонДиалога, "Ошибка при активации диалога: " + ОписаниеОшибки() + Символы.ПС + ОписаниеОшибки);		
			КонецПопытки;
		КонецЕсли; 	
	КонецЦикла; 
	
КонецПроцедуры

Процедура ОбработатьЭлементДиалога(Элемент, ОбработкаЗаказ, Станция)
	Заказ = ОбработкаЗаказ.Заказ.Ссылка;
	Ответ = Неопределено;
	Если ЗначениеНеЗаполнено(Элемент) Тогда
		ЗарегистрироватьСобытие("Управление диалогами", УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.ШаблоныДиалогов, Неопределено, "Ошибка: элемент диалога неопределен");
		Возврат;
		Элемент = Справочники.ЭлементыДиалогов.СоздатьЭлемент().Ссылка;
	КонецЕсли; 

	Если Не Элемент.ФормаГостя.Пустая() И Не Элемент.ФормаГостя = Справочники.ФормыДиалогов.СтандартнаяФормаЗаказа Тогда
		ФормаГостяОбъект = Элемент.ФормаГостя.ПолучитьОбъект();
		
		ФормаГостяОбъект.ПараметрыФормы = Элемент.ПараметрыФормыГостя.Выгрузить();
		ФормаГостя = ФормаГостяОбъект.ПолучитьФорму(ФормаГостяОбъект.Форма);
		ФормаГостя.СостояниеОкна = ВариантСостоянияОкна.Свободное;
		ФормаГостя.Открыть();
	КонецЕсли; 
	Если Не Элемент.Форма.Пустая()  И Не Элемент.Форма = Справочники.ФормыДиалогов.СтандартнаяФормаЗаказа Тогда
		ФормаОбъект = Элемент.Форма.ПолучитьОбъект();
		
		Если Элемент.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Вопрос Тогда
			ФормаОбъект.ВариантыОтветов = Элемент.ВариантыОтветов.Выгрузить();	
		КонецЕсли; 
		ФормаОбъект.ПараметрыФормы = Элемент.ПараметрыФормы.Выгрузить();
		Форма = ФормаОбъект.ПолучитьФорму(ФормаОбъект.Форма);
		Ответ = Форма.ОткрытьМодально();
	КонецЕсли; 	
	
	Зарегистрировать(Заказ, Станция, Элемент, Ответ);
	
	Если Элемент.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Вопрос Тогда
	
		СтрокаОтвета = Элемент.ВариантыОтветов.Найти(Ответ);
		Если СтрокаОтвета = Неопределено Тогда
			ЗарегистрироватьСобытие("Управление диалогами", УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.ЭлементыДиалогов, Элемент, "Ошибка: ответ не найден среди вариантов (" + Ответ + ")");	
		Иначе 
			СледующийЭлемент = СтрокаОтвета.ВариантОтвета;
			ОбработатьЭлементДиалога(СледующийЭлемент, ОбработкаЗаказ, Станция);
		КонецЕсли; 
		
		
	ИначеЕсли Элемент.ТипЭлементаДиалога <> Справочники.ТипыЭлементовДиалогов.Конец И
		 Элемент.ТипЭлементаДиалога <> Справочники.ТипыЭлементовДиалогов.Выход Тогда
		 
		 Если Элемент.Действие = Справочники.ДействияЭлементовДиалогов.ДобавитьТоварВЗаказ Тогда
			 Если ЗначениеЗаполнено(Элемент.ПараметрДействия) Тогда
			 
				ОбработкаЗаказ.ВводНовойСтроки(Элемент.ПараметрДействия, 1);	 	
			 
			 КонецЕсли;
		 КонецЕсли;
		 
	
		СледующийЭлемент = ПолучитьСледующийЭлемент(Элемент);
		ОбработатьЭлементДиалога(СледующийЭлемент, ОбработкаЗаказ, Станция);
	
	
	КонецЕсли; 
			
КонецПроцедуры 

Процедура АктивироватьДиалог(ОбработкаЗаказ, Станция, ШаблонДиалога, СобытиеАктивации, ВариантПовторнойАктивации)
	Старт = ПолучитьЭлементДиалогаПоТипу(ШаблонДиалога, Справочники.ТипыЭлементовДиалогов.Старт);	
	Если Старт = Неопределено Тогда
		ЗарегистрироватьСобытие("Управление диалогами", УровеньЖурналаРегистрации.Ошибка, Метаданные.Справочники.ШаблоныДиалогов, ШаблонДиалога, "Не удалось активировать диалог: отсутствует элемент диалога типа ""Старт""");
		Возврат;	
	КонецЕсли; 
	Зарегистрировать(ОбработкаЗаказ.Заказ.Ссылка, Станция, Старт);
	
	ОбработатьЭлементДиалога(ПолучитьСледующийЭлемент(Старт), ОбработкаЗаказ, Станция);
КонецПроцедуры 


Процедура ПриОткрытииЗаказаНаСтанции(ОбработкаЗаказ) Экспорт
	ОбработкаСобытияАктивации(ОбработкаЗаказ, Справочники.СобытияАктивации.ПриОткрытииЗаказаНаСтанции);
КонецПроцедуры 

Процедура ПриСохраненииЗаказаНаСтанции(ОбработкаЗаказ) Экспорт
	ОбработкаСобытияАктивации(ОбработкаЗаказ, Справочники.СобытияАктивации.ПриСохраненииЗаказаНаСтанции);
КонецПроцедуры 
