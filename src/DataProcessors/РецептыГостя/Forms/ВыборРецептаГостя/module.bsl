﻿
#Область ОписаниеПеременных

Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ОбновитьТовары();
	ЗаполнитьТаблицыФормы();
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицФормы

Процедура СписокБлюдПриАктивизацииСтроки(Элемент)
	
	ТекБлюдо = ЭлементыФормы.СписокБлюд.ТекущаяСтрока.Значение;
	ВремТаб = Товары.Выгрузить(Новый Структура("Блюдо", ТекБлюдо), "Рецепт");
	ВремТаб.Свернуть("Рецепт");
	СписокРецептов.ЗагрузитьЗначения(ВремТаб.ВыгрузитьКолонку("Рецепт"));
	
	УстановитьОтборТовары();
	
КонецПроцедуры

Процедура СписокРецептовПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборТовары();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

Процедура КнопкаОКНажатие(Элемент)
	Попытка
		Закрыть(ЭлементыФормы.СписокРецептов.ТекущаяСтрока.Значение);
	Исключение
	    Закрыть(Неопределено);
	КонецПопытки;
КонецПроцедуры

Процедура КнопкаПереименоватьНажатие(Элемент)
	
	Попытка
		ТекРецепт = ЭлементыФормы.СписокРецептов.ТекущаяСтрока.Значение;
	Исключение
	    Возврат;
	КонецПопытки;
	
	ИмяРецепта = ТекРецепт.ИмяРецепта;
	
	ВводСтроки = ИнтерфейсРМ.ПолучитьОбъектОбработки("ВводСтроки").ПолучитьФорму("Форма");
	ВводСтроки.Заголовок = "Введите имя рецепта гостя...";
	ВводСтроки.ЗначениеВвода = ИмяРецепта;
	ИмяРецепта = ВводСтроки.ОткрытьМодально();
	
	Если НЕ ИмяРецепта = ТекРецепт.ИмяРецепта Тогда
		ПереименоватьРецептГостя(ТекРецепт, ИмяРецепта);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицыФормы()
	
	ВремТаб = Товары.Выгрузить(, "Блюдо");
	ВремТаб.Свернуть("Блюдо");
	СписокБлюд.ЗагрузитьЗначения(ВремТаб.ВыгрузитьКолонку("Блюдо"));
	
	Если СписокБлюд.Количество() Тогда
		ЭлементыФормы.СписокБлюд.ТекущаяСтрока = СписокБлюд[0];
		ВремТаб = Товары.Выгрузить(Новый Структура("Блюдо", СписокБлюд[0].Значение), "Рецепт");
		ВремТаб.Свернуть("Рецепт");
		СписокРецептов.ЗагрузитьЗначения(ВремТаб.ВыгрузитьКолонку("Рецепт"));
	КонецЕсли;
	
	УстановитьОтборТовары();
	
КонецПроцедуры

Процедура УстановитьОтборТовары()
	
	ТекБлюдо = Неопределено;
	ТекРецепт = Неопределено;
	Попытка
		Если НЕ ЗначениеЗаполнено(ЭлементыФормы.СписокБлюд.ТекущаяСтрока.Значение) Тогда
			ЭлементыФормы.СписокБлюд.ТекущаяСтрока = СписокБлюд[0];
		КонецЕсли;
		ТекБлюдо = ЭлементыФормы.СписокБлюд.ТекущаяСтрока.Значение;
	Исключение
	КонецПопытки;
	Попытка
		Если НЕ ЗначениеЗаполнено(ЭлементыФормы.СписокРецептов.ТекущаяСтрока.Значение) Тогда
			ЭлементыФормы.СписокРецептов.ТекущаяСтрока = СписокРецептов[0];
		КонецЕсли;
		ТекРецепт = ЭлементыФормы.СписокРецептов.ТекущаяСтрока.Значение;
	Исключение
	КонецПопытки;
	
	ОтборСтрок = ЭлементыФормы.Товары.ОтборСтрок;
	
	НовОтбор = ОтборСтрок.Найти("Блюдо");
	Если НовОтбор = Неопределено Тогда
		НовОтбор = ОтборСтрок.Добавить("Блюдо");
	КонецЕсли;
	НовОтбор.Установить(ТекБлюдо);
	
	НовОтбор = ОтборСтрок.Найти("Рецепт");
	Если НовОтбор = Неопределено Тогда
		НовОтбор = ОтборСтрок.Добавить("Рецепт");
	КонецЕсли;
	НовОтбор.Установить(ТекРецепт);
	
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

#КонецОбласти