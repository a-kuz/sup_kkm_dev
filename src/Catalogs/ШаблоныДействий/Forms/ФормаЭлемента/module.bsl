﻿
Процедура КоманднаяПанельПоследовательностьПодбор(Кнопка)
	
	Форма = Справочники.События.ПолучитьФормуВыбора(,ЭлементыФормы.ПоследовательностьДействий);
	Форма.ЗакрыватьПриВыборе = Ложь;
	Форма.Открыть();
	
КонецПроцедуры

Процедура ПоследовательностьДействийОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если НЕ ВыбранноеЗначение.ЭтоГруппа Тогда
		ПоследовательностьДействий.Добавить().Событие = ВыбранноеЗначение;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	УправлениеРИБ.ПередОткрытиемЭлементаСправочника(ЭтотОбъект, ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПоследовательностьДействийПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	// у события основное представление в виде кода
	Если ЗначениеЗаполнено(ДанныеСтроки.Событие) Тогда
		ОформлениеСтроки.Ячейки.Событие.Текст = ДанныеСтроки.Событие.ПолноеНаименование();
	КонецЕсли; 
	
КонецПроцедуры
