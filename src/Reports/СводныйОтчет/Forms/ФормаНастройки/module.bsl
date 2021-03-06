﻿
Процедура ОсновныеДействияФормыЗакрыть(Кнопка)
	//ЗагрузитьНастройки(СтруктураНастроекПриОткрытии);
	//
	//Отмена = Истина;
	Закрыть();
	
КонецПроцедуры

Процедура ОсновныеДействияФормыДействие(Кнопка)
	
	Если Не ЗначениеЗаполнено(МестоРеализации) Тогда
		Сообщить("Не заполнено место реализации!",СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	Закрыть();
	
	СформироватьОтчет(ВладелецФормы.ЭлементыФормы.Результат);
	
КонецПроцедуры
 
Процедура КнопкаДатаНажатие(Элемент)
	ФормированиеОтчетов.КнопкаПериодНажатие(ЭтотОбъект);
КонецПроцедуры

Процедура КнопкаСменыНажатие(Элемент) 
	ФормированиеОтчетов.КнопкаСменаНажатие(ЭтотОбъект);
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Период = ПредставлениеПериода(ДатаС,ДатаПо);	
	КонецЕсли;
	
	Если ЗначениеЗаполнено(МассивСмен) Тогда
		МестоРеализации = МассивСмен[0].Значение.МестоРеализации;
	Иначе
		МестоРеализации = ?(ЗначениеЗаполнено(МестоРеализации),МестоРеализации,Константы.ОсновноеМестоРеализации.Получить());
	КонецЕсли;
	
	ЭлементыФормы.МестоРеализации.Доступность = Не ЗначениеЗаполнено(МассивСмен);
		
КонецПроцедуры

