﻿
// Обработчик события ПередЗаписью
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Сообщить("Не заполнено наименование!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Тип) Тогда
		Сообщить("Не выбран тип списания!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры
