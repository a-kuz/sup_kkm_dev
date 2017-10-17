﻿
Процедура КнопкаВыполнитьНажатие(Элемент)
	
	Закрыть(ТабличноеПоле);
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Закрыть(ТабличноеПоле);

КонецПроцедуры

Процедура ТабличноеПолеЗначениеПриИзменении(Элемент)
	
	ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока.Представление = Символ(34) + ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока.Значение + Символ(34);
	
КонецПроцедуры

Процедура ТабличноеПолеПриАктивизацииЯчейки(Элемент)
	
	Попытка
		Если ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока.Значение = Неопределено Тогда
			ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока.Значение = "http://";
		КонецЕсли;
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура ТабличноеПолеПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	//Если ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока.Значение = "http://" Тогда
	//	ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока.
	//	ТабличноеПоле.Удалить(ЭлементыФормы.ТабличноеПоле.ТекущаяСтрока);
	//КонецЕсли;
	
КонецПроцедуры
