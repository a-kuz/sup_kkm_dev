﻿
&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	ТекущийОбъект.ХранилищеТела = Новый ХранилищеЗначения(ФорматированныйДокумент);
КонецПроцедуры


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	ФорматированныйДокумент = ТекущийОбъект.ХранилищеТела.Получить();
	
КонецПроцедуры


&НаКлиенте
Процедура ПроверитьФорму(Команда)
	
	
	П = Новый Структура("Ключ", Объект.Ссылка);
	объект.Ссылка.получитьФорму(Объект.Форма).Открыть();
	
КонецПроцедуры


Процедура ВидимостьЭлементов()
	
	Элементы.СтраницаВариантыОтветов.Видимость = 0;
	Если Объект.Форма = "Вопрос" Тогда
		Элементы.СтраницаВариантыОтветов.Видимость = 1;
		Элементы.СтраницаТекстСообщения.Заголовок = "Текст вопроса";
	ИначеЕсли Объект.Форма = "Сообщение" Тогда
		Элементы.СтраницаТекстСообщения.Видимость = 1;
		Элементы.СтраницаТекстСообщения.Заголовок = "Текст сообщения";
	КонецЕсли;
	
		
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ВидимостьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура ФормаПриИзменении(Элемент)
	ВидимостьЭлементов();
КонецПроцедуры
