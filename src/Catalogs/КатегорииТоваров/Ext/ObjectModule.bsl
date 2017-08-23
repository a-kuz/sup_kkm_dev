﻿
// Обработчик события "ПередЗаписью" объекта.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) ТОгда
		Сообщить("Не заполнено наименование!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СтавкаНДС) ТОгда
		Сообщить("Не выбрана ставка НДС!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
