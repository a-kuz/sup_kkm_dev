﻿
Процедура ПриОткрытии()
//	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	ПодключитьОбработчикОжидания("ВыполнитьОбновление",0.1,1);
КонецПроцедуры

Процедура ВыполнитьОбновление() Экспорт
	Загрузка(ЭлементыФормы.Индикатор, Индикатор, ЭлементыФормы.ТекстЗаголовка);
	Закрыть();
КонецПроцедуры


Процедура ПриЗакрытии()
//	ИнтерфейсРМ.ПриЗакрытииОкна();
КонецПроцедуры

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);