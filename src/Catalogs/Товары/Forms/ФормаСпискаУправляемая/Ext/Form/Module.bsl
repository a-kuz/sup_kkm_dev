﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Отбор") Тогда
		Если Параметры.Отбор.Количество() Тогда
			Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
			Список.КомпоновщикНастроек.Настройки.Отбор.Элементы.Очистить();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
