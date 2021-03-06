﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "НетВозможностиОплатить,ОплатаМР1,ОплатаМР2,ПодвалПредупреждение");
	
	ЕстьДвойнаяОплата = НЕ ПустаяСтрока(ОплатаМР1) И НЕ ПустаяСтрока(ОплатаМР2);
	ЕстьМР_БезОплаты = НЕ ПустаяСтрока(НетВозможностиОплатить);
	
	ЗакрытьСразу = НЕ ЕстьМР_БезОплаты И НЕ ЕстьДвойнаяОплата;
	
	Если НЕ ЗакрытьСразу Тогда
		
		Элементы.ГруппаНадписей1.Видимость = ЕстьМР_БезОплаты;
		Элементы.ГруппаНадписей2.Видимость = ЕстьДвойнаяОплата;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗакрытьСразу Тогда
		Закрыть(1);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	Закрыть(1);
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	Закрыть(-1);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти
