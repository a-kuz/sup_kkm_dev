﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Попытка
		КупоныГостя = Параметры.ДанныеЛояльности.Купоны;
	Исключение
	    Отказ = Истина;
		Возврат;
	КонецПопытки;
	
	ГруппаКупоны = Элементы.ГруппаКупоны;
	КнопкаЭталон = Элементы.Закрыть;
	
	ЦветФонаОплаченнойСтроки = Новый Цвет(222, 252, 222);
	ЦветНеактивнаяКнопка = Новый Цвет(223, 223, 223);
	
	Для Сч = 0 По КупоныГостя.ВГраница() Цикл
		
		КупонКод = КупоныГостя[Сч].Код;
		КупонСтатус = КупоныГостя[Сч].Статус;
		
		ТекЭлемент = Элементы.Добавить("Купон_" + КупонКод, Тип("КнопкаФормы"), ГруппаКупоны);
		ТекЭлемент.ИмяКоманды = "ПлашкаКупон";
		ТекЭлемент.Заголовок = КупоныГостя[Сч].ИнфоСтанции;
		ЗаполнитьЗначенияСвойств(ТекЭлемент, КнопкаЭталон, "Высота,Ширина,Шрифт");

		Если КупонСтатус = -1 Тогда
			ТекЭлемент.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			ТекЭлемент.ЦветТекста = WebЦвета.Красный;
		ИначеЕсли КупонСтатус = 0 Тогда
			ТекЭлемент.ЦветФона = WebЦвета.Лосось;
			ТекЭлемент.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупонСтатус = 1 Тогда	
			ТекЭлемент.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
			ТекЭлемент.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупонСтатус = 2 Тогда	
			ТекЭлемент.ЦветФона = ЦветФонаОплаченнойСтроки;
			ТекЭлемент.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупонСтатус = 3 Тогда	
			ТекЭлемент.ЦветФона = ЦветНеактивнаяКнопка;
			ТекЭлемент.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакрытьНажатие(Команда)
	Закрыть(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПлашкаКупон(Команда)
	
	Закрыть(СтрЗаменить(ТекущийЭлемент.Имя, "Купон_", ""));
	
КонецПроцедуры
