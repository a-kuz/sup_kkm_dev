﻿
// Управление доступностью элементов формы
//
Процедура УправлениеДоступностью()
	
	Тип = ЭлементыФормы.СправочникСписок.ТекущиеДанные.Тип;
	
	Если Тип=Перечисления.ТипыОплаты.Нал ИЛИ
		Тип=Перечисления.ТипыОплаты.Неплательщик ИЛИ
		глВерсия>1 И Тип = Перечисления.ТипыОплаты.Бонусы Тогда
		ЭлементыФормы.СправочникСписок.Колонки.НомерВККМ.ТолькоПросмотр = Истина;
	Иначе
		ЭлементыФормы.СправочникСписок.Колонки.НомерВККМ.ТолькоПросмотр = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// При изменении типа оплаты
//
Процедура СправочникСписокТипПриИзменении(Элемент)
	
	Тип = Элемент.Значение;
	
	Если Тип = Перечисления.ТипыОплаты.Нал Тогда
		ЭлементыФормы.СправочникСписок.ТекущиеДанные.НомерВККМ = 1;
		
	ИначеЕсли Тип = Перечисления.ТипыОплаты.Неплательщик ИЛИ 
		глВерсия>1 И Тип = Перечисления.ТипыОплаты.Бонусы Тогда
		
		ЭлементыФормы.СправочникСписок.ТекущиеДанные.НомерВККМ = 0;
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ЭлементыФормы.СправочникСписок.ТекущиеДанные.Наименование) Тогда
		ЭлементыФормы.СправочникСписок.ТекущиеДанные.Наименование = Строка(Тип);
	КонецЕсли;
	
	УправлениеДоступностью();
	
КонецПроцедуры

// При активизации строки списка
//
Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	
	УправлениеДоступностью();

КонецПроцедуры

Процедура СправочникСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.НомерВККМ = 0 Тогда
		ОформлениеСтроки.Ячейки.НомерВККМ.Текст = "не регистрировать";
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	УправлениеРИБ.ПриОткрытииСпискаСправочника(ЭтаФорма);
	
	Если глВерсия=1 Тогда
		ЭлементыФормы.СправочникСписок.Колонки.Скидка.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

СписокНомерВККМ = ЭлементыФормы.СправочникСписок.Колонки.НомерВККМ.ЭлементУправления.СписокВыбора;
СписокНомерВККМ.Добавить(0,"не регистрировать");
СписокНомерВККМ.Добавить(2);
СписокНомерВККМ.Добавить(3);
СписокНомерВККМ.Добавить(4);
