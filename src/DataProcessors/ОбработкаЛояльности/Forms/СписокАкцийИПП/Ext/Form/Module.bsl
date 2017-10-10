﻿#Область ОбработчикиСобытийФормы

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
	КоличествоЭлементовВСтроке = 3;
	
	ЦветФонаОплаченнойСтроки = Метаданные.ЭлементыСтиля.ЦветФонаОплаченнойСтроки.Значение; //Новый Цвет(222, 252, 222);
	ЦветНеактивнаяКнопка = Метаданные.ЭлементыСтиля.НеактивнаяКнопка.Значение; //Новый Цвет(223, 223, 223);
	
	Для Сч = 0 По КупоныГостя.ВГраница() Цикл
		
		Если Сч % КоличествоЭлементовВСтроке = 0 Тогда
			ТекСтрока = Элементы.Добавить("СтрокаКнопок" + Формат(Сч / КоличествоЭлементовВСтроке, "ЧГ=0"), Тип("ГруппаФормы"), ГруппаКупоны);
			ТекСтрока.Вид = ВидГруппыФормы.ОбычнаяГруппа;
			ТекСтрока.Группировка = ГруппировкаПодчиненныхЭлементовФормы.Горизонтальная;
			ТекСтрока.ОтображениеПодсказки = ОтображениеПодсказки.Нет;
			ТекСтрока.ОтображатьЗаголовок = Ложь;
			ТекСтрока.Отображение = ОтображениеОбычнойГруппы.Нет;
		КонецЕсли;
		
		КупонКод = КупоныГостя[Сч].Код;
		КупонСтатус = КупоныГостя[Сч].Статус;
		
		ТекЭлемент = Элементы.Добавить("Купон_" + КупонКод, Тип("КнопкаФормы"), ТекСтрока);
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
			ТекЭлемент.ЦветТекста = WebЦвета.Черный;
		ИначеЕсли КупонСтатус = 3 Тогда	
			ТекЭлемент.ЦветФона = ЦветНеактивнаяКнопка;
			ТекЭлемент.ЦветТекста = ЦветаСтиля.ЦветТекстаКнопки;
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если ТекущаяСтраница = Элементы.ГруппаВыход Тогда
		Закрыть(Неопределено);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗакрытьНажатие(Команда)
	
	Закрыть(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура ПлашкаКупон(Команда)
	
	Закрыть(СтрЗаменить(ТекущийЭлемент.Имя, "Купон_", ""));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#КонецОбласти

