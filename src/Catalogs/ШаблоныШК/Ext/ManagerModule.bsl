﻿
// Получить код и количество из ШК
//
Процедура ПолучитьКодКоличествоИзШК(Префикс, ШК, Код = 0, Количество = 0, Товар = Неопределено, Каталог = Неопределено, Станция = Неопределено) Экспорт
	
	ТекШаблон = Справочники.ШаблоныШК.НайтиПоКоду(Префикс);
	
	Если ТекШаблон.Пустая() Тогда
		Код 		= 0;
		Количество	= 0;
		Возврат;
	КонецЕсли;
	
	ТелоШК = Сред(ШК, 3, 10);
	Попытка
		Код 		= ?(ТекШаблон.ПорядокКодВес, Число(Лев(ТелоШК, ТекШаблон.ДлинаКода)), Число(Прав(ТелоШК, ТекШаблон.ДлинаКода)));	
	Исключение
		Возврат;
	КонецПопытки;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	                      |	ДоступностьКаталоговТоваров.КаталогТоваров КАК КаталогТоваров
	                      |ПОМЕСТИТЬ ДоступныеКаталоги
	                      |ИЗ
	                      |	РегистрСведений.ДоступностьКаталоговТоваров КАК ДоступностьКаталоговТоваров
	                      |ГДЕ
	                      |	(ДоступностьКаталоговТоваров.Станция = &Станция
	                      |			ИЛИ ДоступностьКаталоговТоваров.Станция = ЗНАЧЕНИЕ(Справочник.Станции.ПустаяСсылка))
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ РАЗЛИЧНЫЕ
	                      |	ШтрихКоды.Товар КАК Товар
	                      |ИЗ
	                      |	ДоступныеКаталоги КАК ДоступныеКаталоги
	                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШтрихКоды КАК ШтрихКоды
	                      |		ПО (ШтрихКоды.Товар.Владелец = ДоступныеКаталоги.КаталогТоваров)
	                      |ГДЕ
	                      |	ШтрихКоды.ШтрихКод = &ШтрихКод
	                      |	И НЕ ШтрихКоды.ПометкаУдаления
	                      |	И ШтрихКоды.Товар.ЕстьВПродаже
	                      |	И НЕ ШтрихКоды.Товар.ПометкаУдаления");
	Запрос.УстановитьПараметр("ШтрихКод", Сред(ШК, 1, 7));
	Запрос.УстановитьПараметр("Станция", Станция);
	Рез = Запрос.Выполнить();
	Если Не Рез.Пустой() Тогда
		Товар = Рез.Выгрузить()[0][0];
	КонецЕсли;
	
	Количество	= ?(ТекШаблон.ПорядокКодВес, Число(Прав(ТелоШК, 10 - ТекШаблон.ДлинаКода)), Число(Лев(ТелоШК, 10 - ТекШаблон.ДлинаКода))) * ТекШаблон.МножительКоличества;
	
КонецПроцедуры	