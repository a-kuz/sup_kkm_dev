﻿#Если НЕ ТонкийКлиент Тогда

#Область ОписаниеПеременных

&НаКлиенте
Перем флТаймаут;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	глОтключитьОбработчикОжидания("глАвтоблокировка");
	ИнтерфейсРМ.СменаПользователя();
	
	Отказ = НЕ ЗначениеЗаполнено(глПользователь);
	флТаймаут = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если флТаймаут Тогда
		// по таймауту
		Отказ = Истина;
		//СтандартнаяОбработка = Ложь;
		ПодключитьОбработчикОжидания("ЗакрытиеПоТаймауту", 0.5, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если НЕ ЗавершениеРаботы Тогда
		Оповестить("ГлавнаяФормаАК_СервисноеМеню_Закрытие", глРабочееМесто, ЭтаФорма);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытиеКассовойСмены(Команда)
	Результат = Обработки.ГлавнаяФормаАК.ОткрытьКассовуюСмену();
	Если Результат.Ошибка ИЛИ Результат.ТекстОшибки1 = "ОК" Тогда
		Результат.РезультатКнопкиОК = "СервисноеМеню";
		флТаймаут = Ложь;
		Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеКассовойСмены(Команда)
	Результат = Обработки.ГлавнаяФормаАК.ЗакрытьКассовуюСмену();
	Если Результат.Ошибка ИЛИ Результат.ТекстОшибки1 = "ОК" Тогда
		Результат.РезультатКнопкиОК = "СервисноеМеню";
		флТаймаут = Ложь;
		Закрыть(Результат);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтчетБезГашения(Команда)
	
	Результат = Обработки.ГлавнаяФормаАК.ОтчетБезГашения();
	Если Результат.Ошибка ИЛИ Результат.ТекстОшибки1 = "ОК" Тогда
		Результат.РезультатКнопкиОК = "СервисноеМеню";
		флТаймаут = Ложь;
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытиеДняСбербанк(Команда)
	
	Результат = Обработки.ГлавнаяФормаАК.ЗакрытиеДняСбербанк();
	Если Результат.Ошибка ИЛИ Результат.ТекстОшибки1 = "ОК" Тогда
		Результат.РезультатКнопкиОК = "СервисноеМеню";
		флТаймаут = Ложь;
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтчетСбербанк(Команда)
	
	Результат = Обработки.ГлавнаяФормаАК.ОтчетСбербанк();
	Если Результат.Ошибка ИЛИ Результат.ТекстОшибки1 = "ОК" Тогда
		Результат.РезультатКнопкиОК = "СервисноеМеню";
		флТаймаут = Ложь;
		Закрыть(Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыключитьКассу(Команда)
	
	ЗапуститьПриложение("shutdown -s -f -t 20");
	ПрекратитьРаботуСистемы(Ложь);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗакрытиеПоТаймауту() Экспорт 
	
	флТаймаут = Ложь;
	Результат =  Новый Структура("Ошибка,ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", Ложь, "", "", "ОткрытьГлавнуюФорму");
		
	Закрыть(Результат);
		
КонецПроцедуры

#КонецОбласти

#КонецЕсли
