﻿

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Закрыть(Истина);
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	
	Закрыть();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ОписаниеТиповРедактированияСписка <> Неопределено Тогда 
		ЭлементыФормы.СписокРедактирования.ТипЗначенияСписка = ОписаниеТиповРедактированияСписка;
	КонецЕсли;
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторИзмененийНаУзлах.Форма.ФормаВыбораОбъектовДляРегистрации");
ОписаниеТиповРедактированияСписка = Неопределено;
