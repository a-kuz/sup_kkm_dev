﻿
Процедура ДействияФормыФН(Кнопка)
	Форма = Обработки.ФормированиеНачислений.ПолучитьФорму();
	Форма.Открыть();
КонецПроцедуры

Процедура ДокументСписокПередНачаломДобавления(Элемент, Отказ, Копирование)
	Если Копирование И ЗначениеЗаполнено(Элемент.ТекущиеДанные.Ссылка.ВариантОплаты) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
КонецПроцедуры
