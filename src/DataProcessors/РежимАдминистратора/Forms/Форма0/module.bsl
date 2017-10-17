﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	ДействияПередЗакрытиемФормы(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаВыполнитьНажатие(Элемент)
	
	НомерКнопки = Число(Сред(Элемент.Имя,7));
	ОбработкаНажатияКнопки(НомерКнопки);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

КолвоКнопок = 10;
