﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ЗначениеЗаполнено(Запись.Данные_ТипСсылки) Тогда
		Тип = СтрЗаменить(ЗАпись.Данные_ТипСсылки, "Ссылка.",".");
		Тип = СтрЗаменить(Тип, "Документ.","Документы.");
		Тип = СтрЗаменить(Тип, "Справочник.","Справочники.");
		Попытка
			Менеджер = Вычислить("Документы."+Тип);	
		Исключение
			Попытка
				Менеджер = Вычислить("Справочники."+Тип);	
			Исключение
				Возврат;
			КонецПопытки;
		КонецПопытки;
		
		//:Менеджер = Документы.Заказ;
		Данные = Менеджер.ПолучитьСсылку(Запись.Данные_Ссылка);	
	КонецЕсли;
КонецПроцедуры
