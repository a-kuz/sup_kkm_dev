﻿
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ЗначениеЗаполнено(Наименование) ТОгда
		Сообщить("Не заполнено наименование!", СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	
	Если ПометкаУдаления Тогда
		НаборЗаписей = РегистрыСведений.СловарьСлужебныхСлов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Язык.Установить(Ссылка);
		НаборЗаписей.Прочитать();
		Наборзаписей.Очистить();
		НаборЗаписей.Записать();
	КонецЕсли;
КонецПроцедуры



   