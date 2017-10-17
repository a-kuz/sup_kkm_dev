﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ

// Обновляет заголовок элемента формы "НадписьДлина"
//
Процедура ОбновитьНадписьДлина()
	
	Текст = ЭлементыФормы.Шаблон.Значение;
	
	Если ЕстьИдентификаторы(Текст) Тогда
		ЭлементыФормы.НадписьДлина.Заголовок = "Мин. длина сообщения: " + Строка(ДлинаБезИдентификаторов(Текст));
	Иначе
		ЭлементыФормы.НадписьДлина.Заголовок = "Длина сообщения: " + Строка(СтрДлина(Текст));		
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Обработчик события ПередОткрытием формы.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	УправлениеРИБ.ПередОткрытиемЭлементаСправочника(ЭтотОбъект, ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

// Обработчик события ПриОткрытии формы.
//
Процедура ПриОткрытии()
	
	Если ЭтоНовый() Тогда
		ВидРассылки = Перечисления.ВидыРассылок.СМС;
	КонецЕсли;
	
	СписокИД = "%клиент%";	
	ОбновитьНадписьДлина();
	ОбновитьГиперссылкуРодительСправочника(ЭтаФорма);
	
КонецПроцедуры

// Обработчик события ОбработкаВыбора формы.
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	ВыборРодителя(ЭтотОбъект, ЭтаФорма, ЗначениеВыбора);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ГиперссылкаРодительНажатие(Элемент)
	
	НажатиеГиперссылкиРодительСправочника(ЭтотОбъект, ЭтаФорма);

КонецПроцедуры

Процедура Кнопка1Нажатие(Элемент)
	
	ЭлементыФормы.Шаблон.Значение = ЭлементыФормы.Шаблон.Значение + СписокИД;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕКСТ ОСНОВНОЙ ПРОГРАММЫ

ПодключитьОбработчикОжидания("ОбновитьНадписьДлина", 1);