﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВосстановитьПараметрыРМ();	
КонецПроцедуры

&НаСервере
Процедура ВосстановитьПараметрыРМ() Экспорт
	тзПараметрыРМ = ЗначениеИзСтрокиВнутр(Объект.ПараметрыРМ);
	ПараметрыРМ.Загрузить(тзПараметрыРМ);
КонецПроцедуры

&НаСервере
Процедура СохранитьПараметрыРМ() Экспорт
	
	Объект.ПараметрыРМ = ЗначениеВСтрокуВнутр(ПараметрыРМ.Выгрузить());
КонецПроцедуры

&НаКлиенте
Процедура КомандаСохранитьПараметрыРМ(Команда)
	СохранитьПараметрыРМ();
	Модифицированность = Истина;
КонецПроцедуры


