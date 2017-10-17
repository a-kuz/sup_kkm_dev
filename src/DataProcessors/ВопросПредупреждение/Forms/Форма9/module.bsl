﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Для Инд = 1 По 3 Цикл
		ЭлементыФормы["Кнопка"+Инд+"Тень"].Видимость = ЭлементыФормы["Кнопка"+Инд].Видимость;
	КонецЦикла;
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	//Если НЕ ВводДоступен() Тогда
	//	Возврат;
	//КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура Кнопка1Нажатие(Элемент)
	
	Закрыть( Элемент.Заголовок );
	
КонецПроцедуры

Процедура Кнопка2Нажатие(Элемент) 
	
	Закрыть( Элемент.Заголовок );
	
КонецПроцедуры

Процедура Кнопка3Нажатие(Элемент)
	
	Закрыть( Элемент.Заголовок );
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
