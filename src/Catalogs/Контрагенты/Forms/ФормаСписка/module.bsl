﻿
Процедура ДействияФормыЗаполнить(Кнопка)
	Форма = Справочники.Контрагенты.ПолучитьФорму("Автозаполнение");
	Форма.Открыть();
КонецПроцедуры

Процедура ГрупповаяОбработка()
	
	
КонецПроцедуры	


Процедура ПриОткрытии()
	
	УправлениеРИБ.ПриОткрытииСпискаСправочника(ЭтаФорма);
	
	Если ТолькоПросмотр Тогда
		ЭлементыФормы.ДействияФормы.Кнопки.ГрупповаяОбработка.Доступность = Ложь;
		ЭлементыФормы.ДействияФормы.Кнопки.Заполнить.Доступность = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

