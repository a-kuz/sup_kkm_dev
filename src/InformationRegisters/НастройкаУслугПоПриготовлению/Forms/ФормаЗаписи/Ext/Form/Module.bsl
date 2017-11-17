﻿
&НаКлиенте
Процедура Товар_КодСУПНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ОткрытьФорму("Справочник.Номенклатура.ФормаВыбора",Новый Структура("Ключ", ОбщегоНазначенияПовтИсп.НайтиПоРеквизиту("Справочник.номенклатура", "КодСУП",Запись.Товар_КодСУП)),Элемент,УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура Товар_КодСУПОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Запись.Товар_КодСУП = КодСУПэлемента(ВыбранноеЗначение);
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаСервереБезКонтекста
Функция КодСУПэлемента(Элемент)
	Возврат Элемент.КодСУП;
КонецФункции


&НаКлиенте
Процедура СпецификаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
	
	УстановитьГруппуСпецифик();
КонецПроцедуры

&НаСервере
Процедура УстановитьГруппуСпецифик()
	ГруппаСпецифик = Запись.Услуга.ГруппаСпецифик;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	УстановитьГруппуСпецифик();
	ПодключитьсяКСУПцентру();
	
	ТоварСУПцентр = ВнешниеИсточникиДанных.СУПтт.Таблицы.dbo_Спр_Товары.НайтиПоПолю("КодГрПгрПрд", Запись.Товар_КодСУП);
КонецПроцедуры

&НаСервере
Процедура ПодключитьсяКСУПцентру()
	Если ЗначениеЗаполнено(Запись.ИнформационнаяБаза) Тогда
		Регион = Запись.ИнформационнаяБаза.Регион;
	Иначе
		Регион = ПараметрыСеанса.ТекущаяИБ.Регион;
	КонецЕсли;
	ПодключитьсяКвнешнемуИсточникуСупЦентр(Запись.ИнформационнаяБаза.Регион, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяБазаПриИзменении(Элемент)
	ПодключитьсяКСУПцентру();
КонецПроцедуры

&НаСервере
Процедура ТоварСУПцентрПриИзмененииНаСервере()
	Запись.Товар_КодСУП = ТоварСУПцентр.КодГрПгрПрд;
КонецПроцедуры

&НаКлиенте
Процедура ТоварСУПцентрПриИзменении(Элемент)
	ТоварСУПцентрПриИзмененииНаСервере();
КонецПроцедуры
