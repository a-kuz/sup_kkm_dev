﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИИ СОБЫТИЙ ФОРМЫ

// Обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии()
	
	УправлениеРИБ.ПриОткрытииСпискаСправочника(ЭтаФорма);
	
КонецПроцедуры
                                       
Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	
	ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущийРодитель;
	
КонецПроцедуры


