﻿Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = Данные.Штрихкод;
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	Поля.Добавить("ШтрихКод");
	СтандартнаяОбработка = Ложь;
КонецПроцедуры
