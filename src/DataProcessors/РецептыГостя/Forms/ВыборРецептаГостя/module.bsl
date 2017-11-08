﻿
#Область ОбработчикиСобытийФормы

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьТаблицыФормы();
	
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

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьТаблицыФормы()
	
	ВремТаб = Товары.Выгрузить(, "Блюдо");
	ВремТаб.Свернуть("Блюдо");
	СписокБлюд.ЗагрузитьЗначения(ВремТаб.ВыгрузитьКолонку("Блюдо"));
	
	Если СписокБлюд.Количество() Тогда
		ВремТаб = Товары.Выгрузить(Новый Структура("Блюдо", СписокБлюд[0].Значение), "Рецепт");
		ВремТаб.Свернуть("Рецепт");
		СписокРецептов.ЗагрузитьЗначения(ВремТаб.ВыгрузитьКолонку("Рецепт"));
	КонецЕсли;
	
	УстановитьОтборТовары();
	
КонецПроцедуры

Процедура УстановитьОтборТовары()
	
	Попытка
		ТекБлюдо = ЭлементыФормы.СписокБлюд.ТекущаяСтрока.Значение;
		ТекРецепт = ЭлементыФормы.СписокРецептов.ТекущаяСтрока.Значение;
	Исключение
	    Возврат;
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
