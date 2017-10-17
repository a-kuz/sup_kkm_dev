﻿

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	
	Если ЭлементыФормы.СправочникСписок.ТекущиеДанные <> Неопределено Тогда
		ЭлементыФормы.СправочникДерево.ТекущаяСтрока = ЭлементыФормы.СправочникСписок.ТекущиеДанные.Родитель;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если НЕ ПараметрыСеанса.РаспределенныйРежим Тогда
		ЭлементыФормы.СправочникСписок.Колонки.ИнформационнаяБаза.Видимость = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура СправочникСписокПриПолученииДанных(Элемент, ОформленияСтрок)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура СправочникСписокПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ДанныеСтроки = Неопределено Тогда
		Возврат
	КонецЕсли;
	
	стрПорт = Справочники.ТорговоеОборудование.ПолучитьНомерПорта(ДанныеСтроки.Параметры);
	ОформлениеСтроки.Ячейки.Порт.УстановитьТекст(стрПорт);
КонецПроцедуры


СправочникСписок.Отбор.ПометкаУдаления.Установить(Ложь);
