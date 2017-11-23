﻿
Процедура ПередЗаписью(Отказ, Замещение)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	ЗаказОтбор = Неопределено;
	О = Отбор.Найти("Заказ");
	Если НЕ О = Неопределено Тогда
		ЗаказОтбор = О.Значение;
	КонецЕсли;
	ЗарегистрироватьСобытие("Ловушка.РегистрСведений.ОткрытыеЗаказыПоКартам", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Примечание"),, ЗаказОтбор, ЛояльностьКлиентСервер.СформироватьJSON(ЭтотОбъект.Выгрузить()));
КонецПроцедуры
