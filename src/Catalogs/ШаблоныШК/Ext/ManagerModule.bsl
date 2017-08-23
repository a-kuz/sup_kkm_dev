﻿
// Получить код и количество из ШК
//
Процедура ПолучитьКодКоличествоИзШК(Префикс, ШК, Код = 0, Количество = 0, Товар = Неопределено, Каталог = Неопределено) Экспорт
	
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
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ШтрихКоды.Товар КАК Товар
	|ИЗ
	|	Справочник.ШтрихКоды КАК ШтрихКоды
	|ГДЕ
	|	НЕ ШтрихКоды.ПометкаУдаления
	|	И НЕ ШтрихКоды.Товар.ПометкаУдаления
	|	И ШтрихКоды.ШтрихКод = &ШтрихКод
	|	И (ШтрихКоды.Товар.Владелец = &Каталог
	|			ИЛИ &Каталог = НЕОПРЕДЕЛЕНО)");
	Запрос.УстановитьПараметр("ШтрихКод", Сред(ШК, 1, 7));
	Запрос.УстановитьПараметр("Каталог", Каталог);
	Рез = Запрос.Выполнить();
	Если Не Рез.Пустой() Тогда
		Товар = Рез.Выгрузить()[0][0];
	КонецЕсли;
	
	Количество	= ?(ТекШаблон.ПорядокКодВес, Число(Прав(ТелоШК, 10 - ТекШаблон.ДлинаКода)), Число(Лев(ТелоШК, 10 - ТекШаблон.ДлинаКода))) * ТекШаблон.МножительКоличества;
	
КонецПроцедуры	