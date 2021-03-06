﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Заказ = Неопределено;
	Протокол = Неопределено;
	Параметры.Свойство("Заказ", Заказ);
	Параметры.Свойство("Протокол", Протокол);
	УстановитьПараметрыОтбораСписка(Заказ, Протокол);
КонецПроцедуры

&НаСервере
Процедура УстановитьПараметрыОтбораСписка(ДокументСсылка, Протокол)
	ОтборыСписка = Список.Отбор.Элементы;
	ОтборыСписка.Очистить();
	
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		НовыйОтбор = ОтборыСписка.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ДокументСсылка");
		НовыйОтбор.Использование = Истина;
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение = ДокументСсылка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Протокол) Тогда
		НовыйОтбор = ОтборыСписка.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		НовыйОтбор.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Протокол");
		НовыйОтбор.Использование = Истина;
		НовыйОтбор.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
		НовыйОтбор.ПравоеЗначение = Протокол;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Обработать(Команда)
	ТекущаяСтрока = Элементы.Список.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Лояльность.ОбработатьСпулЛояльности(ТекущаяСтрока.ДокументСсылка, ТекущаяСтрока.Протокол);
КонецПроцедуры
