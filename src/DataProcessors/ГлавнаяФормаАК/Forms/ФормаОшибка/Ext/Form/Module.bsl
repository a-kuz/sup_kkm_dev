﻿&НаКлиенте
Перем СчетчикНажатий;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	РезультатКнопкиОК = Параметры.РезультатКнопкиОК;
	Попытка
		ТекстОшибки1 = СтрШаблон(Параметры.ТекстОшибки1, Параметры.ПараметрШаблона1);
	Исключение
		ТекстОшибки1 = Параметры.ТекстОшибки1;
	КонецПопытки;
	Попытка
		ТекстОшибки2 = СтрШаблон(Параметры.ТекстОшибки2, Параметры.ПараметрШаблона1);
	Исключение
		ТекстОшибки2 = Параметры.ТекстОшибки2;
	КонецПопытки;
	
	Элементы.ТекстОшибки1.Видимость = НЕ ПустаяСтрока(ТекстОшибки1);
	Элементы.ТекстОшибки2.Видимость = НЕ ПустаяСтрока(ТекстОшибки2);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьОтображениеЭлементовДляМестаРеализации(глПараметрыРМ.МестоРеализации);
	
	Если ВРег(РезультатКнопкиОК) = "ОШИБКАЗАПУСКА"
		ИЛИ ВРег(РезультатКнопкиОК) = "ЗАКРЫТЬПРИЛОЖЕНИЕ"
		ИЛИ ВРег(РезультатКнопкиОК) = "ОТКРЫТЬГЛАВНУЮФОРМУ"
		Тогда
		глОтключитьОбработчикОжидания("глАвтоблокировка");
	КонецЕсли;
	
	СчетчикНажатий = 0;
	Элементы.ЛогоККГурмэ.Гиперссылка  = глПараметрыРМ.Тест;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ГлавнаяФормаАК_СервисноеМеню_Закрытие" Тогда
		Если Параметр = глРабочееМесто И Открыта() И КлючУникальности = Неопределено Тогда
			Закрыть(РезультатКнопкиОК);
		КонецЕсли;
	ИначеЕсли ИмяСобытия = "ГлавнаяФормаАК_СбросЗаказаСоСтандартнойКассы" Тогда
		Если (Параметр = глРабочееМесто ИЛИ СокрЛП(Параметр) = СокрЛП(глРабочееМесто.ПрофильВхода)) И Открыта() Тогда
			Закрыть("НачальноеОкно");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаОК(Команда)
	
	Закрыть(РезультатКнопкиОК);
	
КонецПроцедуры

&НаКлиенте
Процедура ЛогоККГурмэНажатие(Элемент)
	Если НЕ глПараметрыРМ.Тест Тогда
		Возврат;
	КонецЕсли;
	Если СчетчикНажатий = 12 Тогда
		Закрыть("СервисноеМеню");
		//ОткрытьФорму("Обработка.ГлавнаяФормаАК.Форма.СервисноеМеню", Новый Структура, ЭтотОбъект);
		//СчетчикНажатий = 0;
	Иначе
		СчетчикНажатий = СчетчикНажатий + 1;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьОтображениеЭлементовДляМестаРеализации(МестоРеализации)
	
	Если МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.Ресторан") Тогда
		
		Элементы.ЛогоККГурмэ.Видимость = Ложь;
		
	КонецЕсли;
	
	// блок Классного магазина
	Если МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.КМ") Тогда
		
		// шапка
		Элементы.ЛогоККГурмэ.Видимость = Истина;
		
	КонецЕсли; 
	
	// блок МОКП
	
	
	// блок Общий
	
КонецПроцедуры

#КонецОбласти
