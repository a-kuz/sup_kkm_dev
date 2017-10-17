﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)

	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
	ЭлементыФормы.НеактивнаяКнопкаДляФокуса.Видимость = 1;	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Для Инд = 1 По 3 Цикл
		ЭлементыФормы["Кнопка"+Инд+"Тень"].Видимость = ЭлементыФормы["Кнопка"+Инд].Видимость;
		ЭлементыФормы["Кнопка"+Инд+"Рамка"].Видимость = ЭлементыФормы["Кнопка"+Инд].Видимость;
	КонецЦикла;
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
	ОбновлениеОтображения();
КонецПроцедуры

Процедура ОбновлениеОтображения()
	ОтключитьОбработчикОжидания("ОбновлениеОтображения");
	Если ТекущийЭлемент <> ЭлементыФормы.НеактивнаяКнопкаДляФокуса Тогда
		ЭлементыФормы.НеактивнаяКнопкаДляФокуса.Видимость = 0;	
	КонецЕсли;
	ЭтаФорма.ЭлементыФормы.Кнопка1Рамка.Видимость = (ЭтаФорма.ТекущийЭлемент = ЭтаФорма.ЭлементыФормы.Кнопка1);
	ЭтаФорма.ЭлементыФормы.Кнопка2Рамка.Видимость = (ЭтаФорма.ТекущийЭлемент = ЭтаФорма.ЭлементыФормы.Кнопка2);
	ЭтаФорма.ЭлементыФормы.Кнопка3Рамка.Видимость = (ЭтаФорма.ТекущийЭлемент = ЭтаФорма.ЭлементыФормы.Кнопка3);
	ПодключитьОбработчикОжидания("ОбновлениеОтображения", 0.3, Истина);
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
