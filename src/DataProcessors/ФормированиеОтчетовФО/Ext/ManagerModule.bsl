﻿Функция ТаблицаОперативнойРеализации(Смена, ЧислаЧислами = 0, Фирма = Неопределено) Экспорт
	
	Если Фирма = Неопределено Тогда
		Фирмы = Новый Массив;
		Выб = Справочники.Фирмы.Выбрать();
		Пока Выб.Следующий() Цикл
			Если Выб.МестоРеализации = Смена.МестоРеализации и не Выб.ПометкаУдаления Тогда
				Фирмы.Добавить(Выб.Ссылка);
				Фирма = Выб.Ссылка;
			КонецЕсли;
		КонецЦикла;
	Иначе
		Фирмы = Массив(Фирма);
	КонецЕсли;
	
	Если Фирмы.Количество() Тогда			
		Если Фирма.МестоРеализации = Справочники.МестаРеализации.Ресторан Тогда
			РезультатТаблицаОперативнойРеализации = ТаблицаОперативнойРеализацииКП(Смена, ЧислаЧислами, Фирмы[0]);
			Для Инд = 1 По Фирмы.Количество()-1 Цикл
				ТаблицаОперативнойРеализации = ТаблицаОперативнойРеализацииКП(Смена, ЧислаЧислами, Фирмы[Инд]);
				Для Каждого Т Из ТаблицаОперативнойРеализации Цикл
					ЗаполнитьЗначенияСвойств(РезультатТаблицаОперативнойРеализации.Добавить(), Т);
				КонецЦикла;
			КонецЦикла;
			Возврат РезультатТаблицаОперативнойРеализации;
			
		ИначеЕсли Фирма.ТипТТ = Справочники.ТипыТТ.КМ ИЛИ Фирма.ТипТТ = Справочники.ТипыТТ.МОКП Тогда
			РезультатТаблицаОперативнойРеализации = ТаблицаОперативнойРеализацииКМ(Смена, ЧислаЧислами, Фирмы[0]);
			Для Инд = 1 По Фирмы.Количество()-1 Цикл
				ТаблицаОперативнойРеализации = ТаблицаОперативнойРеализацииКМ(Смена, ЧислаЧислами, Фирмы[Инд]);
				Для Каждого Т Из ТаблицаОперативнойРеализации Цикл
					ЗаполнитьЗначенияСвойств(РезультатТаблицаОперативнойРеализации.Добавить(), Т);
				КонецЦикла;
			КонецЦикла;
			Возврат РезультатТаблицаОперативнойРеализации;
		КонецЕсли;
	КонецЕсли;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ЗаказДопИнф.Заказ КАК Заказ,
	|	тчПротокол.ВариантОплаты КАК ВариантОплаты,
	|	СУММА(тчПротокол.СуммаФакт * ВЫБОР
	|			КОГДА докПротоколРасчетов.Заказ ССЫЛКА Документ.Заказ
	|				ТОГДА 1
	|			ИНАЧЕ -1
	|		КОНЕЦ) КАК СуммаФакт,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(докПротоколРасчетов.ИтогСуммаФакт, 0) = 0
	|			ТОГДА 1
	|		ИНАЧЕ СУММА(тчПротокол.СуммаФакт) / докПротоколРасчетов.ИтогСуммаФакт
	|	КОНЕЦ КАК Доля,
	|	докПротоколРасчетов.ККМ.КодСУП КАК НомерККМ,
	|	докПротоколРасчетов.ККМ КАК ККМ,
	|	докПротоколРасчетов.КассоваяСмена КАК КассоваяСмена,
	|	докПротоколРасчетов.Фирма КАК Фирма
	|ПОМЕСТИТЬ тОплата
	|ИЗ
	|	Документ.ПротоколРасчетов КАК докПротоколРасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПротоколРасчетов.Протокол КАК тчПротокол
	|		ПО (тчПротокол.Ссылка = докПротоколРасчетов.Ссылка)
	|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаказДопИнф.Заказ КАК Заказ,
	|			ЗаказДопИнф.Статус КАК Статус,
	|			ЗаказДопИнф.ПротоколРасчетов КАК ПротоколРасчетов
	|		ИЗ
	|			РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|		ГДЕ
	|			ЗаказДопИнф.Статус = &Закрыт
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ВозвратДопИнф.Возврат,
	|			ВозвратДопИнф.Статус,
	|			ВозвратДопИнф.ПротоколРасчетов
	|		ИЗ
	|			РегистрСведений.ВозвратДопИнф КАК ВозвратДопИнф
	|		ГДЕ
	|			ВозвратДопИнф.Статус = &Закрыт) КАК ЗаказДопИнф
	|		ПО докПротоколРасчетов.Ссылка = ЗаказДопИнф.ПротоколРасчетов
	|ГДЕ
	|	докПротоколРасчетов.Смена = &Смена
	|	И докПротоколРасчетов.Проведен
	|
	|СГРУППИРОВАТЬ ПО
	|	тчПротокол.ВариантОплаты,
	|	ЗаказДопИнф.Заказ,
	|	докПротоколРасчетов.ИтогСуммаФакт,
	|	докПротоколРасчетов.ККМ.КодСУП,
	|	докПротоколРасчетов.ККМ,
	|	докПротоколРасчетов.КассоваяСмена,
	|	докПротоколРасчетов.Фирма
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	т.Заказ КАК Заказ,
	|	т.Товар КАК Товар,
	|	СУММА(т.Количество) КАК Количество,
	|	СУММА(т.Сумма) КАК Сумма,
	|	СУММА(т.СуммаРеализации) КАК СуммаРеализации,
	|	т.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(т.СуммаНДС) КАК СуммаНДС,
	|	т.КодСУП КАК КодСУП,
	|	т.ТипРасхода КАК ТипРасхода,
	|	т.ТипТовара КАК ТипТовара,
	|	т.ТоварСпецифики КАК ТоварСпецифики,
	|	СУММА(т.СуммаСпецифики) КАК СуммаСпецифики,
	|	СУММА(т.СуммаФактСпецифики) КАК СуммаФактСпецифики,
	|	т.ШК КАК ШК
	|ПОМЕСТИТЬ тПродажиПред
	|ИЗ
	|	(ВЫБРАТЬ
	|		докЗаказ.Ссылка КАК Заказ,
	|		ЗаказТовары.Товар КАК Товар,
	|		СУММА(ЗаказТовары.Количество) КАК Количество,
	|		СУММА(ЗаказТовары.Сумма) КАК Сумма,
	|		СУММА(ЗаказТовары.СуммаРеализации) КАК СуммаРеализации,
	|		ЗаказТовары.СтавкаНДС КАК СтавкаНДС,
	|		СУММА(ЗаказТовары.СуммаНДС) КАК СуммаНДС,
	|		ЗаказТовары.Товар.КодСУП КАК КодСУП,
	|		ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Реализация) КАК ТипРасхода,
	|		""Товары"" КАК ТипТовара,
	|		NULL КАК ТоварСпецифики,
	|		0 КАК СуммаСпецифики,
	|		0 КАК СуммаФактСпецифики,
	|		ЗаказТовары.ШК КАК ШК
	|	ИЗ
	|		Документ.Заказ.Товары КАК ЗаказТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|			ПО ЗаказТовары.Ссылка = ЗаказДопИнф.Заказ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ КАК докЗаказ
	|			ПО (докЗаказ.Ссылка = ЗаказТовары.Ссылка)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|			ПО ЗаказТовары.Товар.Номенклатура = Номенклатура.Ссылка
	|	ГДЕ
	|		докЗаказ.Смена = &Смена
	|		И ЗаказДопИнф.Статус = &Закрыт
	|		И НЕ докЗаказ.ПометкаУдаления
	|		И ЗаказТовары.Сумма + ЗаказТовары.СуммаРеализации + ЗаказТовары.Количество > 0
	|	
	|	СГРУППИРОВАТЬ ПО
	|		докЗаказ.Ссылка,
	|		ЗаказТовары.Товар,
	|		ЗаказТовары.СтавкаНДС,
	|		ЗаказТовары.Товар.КодСУП,
	|		ЗаказТовары.ШК
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		докЗаказ.Ссылка,
	|		ЗаказСпецифики.Специфика,
	|		СУММА(докЗаказТовары.Количество),
	|		0,
	|		0,
	|		докЗаказТовары.СтавкаНДС,
	|		0,
	|		ЗаказСпецифики.Специфика.Номенклатура.КодСУП,
	|		ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Реализация),
	|		""Специфики"",
	|		докЗаказТовары.Товар,
	|		СУММА(ЗаказСпецифики.Цена * докЗаказТовары.Количество),
	|		СУММА(ЗаказСпецифики.ЦенаРеализации * докЗаказТовары.Количество),
	|		NULL
	|	ИЗ
	|		Документ.Заказ.Специфики КАК ЗаказСпецифики
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|			ПО ЗаказСпецифики.Ссылка = ЗаказДопИнф.Заказ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ КАК докЗаказ
	|			ПО ЗаказСпецифики.Ссылка = докЗаказ.Ссылка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ.Товары КАК докЗаказТовары
	|			ПО ЗаказСпецифики.Ссылка = докЗаказТовары.Ссылка
	|				И ЗаказСпецифики.НомерСтрокиТовара = докЗаказТовары.НомерСтроки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|			ПО (спрНоменклатура.Ссылка = ЗаказСпецифики.Специфика.Номенклатура)
	|	ГДЕ
	|		докЗаказ.Смена = &Смена
	|		И ЗаказДопИнф.Статус = &Закрыт
	|		И НЕ докЗаказ.ПометкаУдаления
	|		И ЗаказСпецифики.ЦенаРеализации + ЗаказСпецифики.Цена + ЗаказСпецифики.Количество > 0
	|	
	|	СГРУППИРОВАТЬ ПО
	|		докЗаказ.Ссылка,
	|		ЗаказСпецифики.Специфика,
	|		докЗаказТовары.СтавкаНДС,
	|		ЗаказСпецифики.Специфика.Номенклатура.КодСУП,
	|		докЗаказТовары.Товар
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		докВозврат.Ссылка,
	|		ВозвратТовары.Товар,
	|		СУММА(-ВозвратТовары.Количество),
	|		СУММА(-ВозвратТовары.СуммаРозничная),
	|		СУММА(-ВозвратТовары.Сумма),
	|		ВозвратТовары.СтавкаНДС,
	|		СУММА(-ВозвратТовары.СуммаНДС),
	|		ВозвратТовары.Товар.КодСУП,
	|		ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Возврат),
	|		""Товары"",
	|		NULL,
	|		0,
	|		0,
	|		ВозвратТовары.ШК
	|	ИЗ
	|		Документ.Возврат.Товары КАК ВозвратТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВозвратДопИнф КАК ВозвратДопИнф
	|			ПО ВозвратТовары.Ссылка = ВозвратДопИнф.Возврат
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Возврат КАК докВозврат
	|			ПО (докВозврат.Ссылка = ВозвратТовары.Ссылка)
	|	ГДЕ
	|		докВозврат.Смена = &Смена
	|		И ВозвратДопИнф.Статус = &Закрыт
	|		И НЕ докВозврат.ПометкаУдаления
	|		И ВозвратТовары.Сумма + ВозвратТовары.Количество > 0
	|	
	|	СГРУППИРОВАТЬ ПО
	|		докВозврат.Ссылка,
	|		ВозвратТовары.Товар,
	|		ВозвратТовары.СтавкаНДС,
	|		ВозвратТовары.Товар.КодСУП,
	|		ВозвратТовары.ШК) КАК т
	|
	|СГРУППИРОВАТЬ ПО
	|	т.Заказ,
	|	т.Товар,
	|	т.СтавкаНДС,
	|	т.КодСУП,
	|	т.ТипРасхода,
	|	т.ТипТовара,
	|	т.ТоварСпецифики,
	|	т.ШК
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(тПродажи.Количество * ЕСТЬNULL(тОплата.Доля, 1)) КАК Количество,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.Сумма * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаРозн,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаРеализации * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаФакт,
	|	ПРЕДСТАВЛЕНИЕ(тПродажи.СтавкаНДС) КАК СтавкаНДС,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаНДС * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
	|	тПродажи.КодСУП КАК КодСУП,
	|	ЕСТЬNULL(ПРЕДСТАВЛЕНИЕ(тОплата.ВариантОплаты), """") КАК ТипОплаты,
	|	тОплата.НомерККМ КАК НомерККМ,
	|	тПродажи.Заказ КАК Заказ,
	|	тПродажи.Товар КАК Товар,
	|	тПродажи.СтавкаНДС КАК СтавкаНДСссылка,
	|	тОплата.ВариантОплаты КАК ВариантОплаты,
	|	тПродажи.ТипРасхода КАК ТипРасхода,
	|	тОплата.ККМ КАК ККМ,
	|	тОплата.КассоваяСмена КАК КассоваяСмена,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(10, 2)) КАК СуммаКорр,
	|	тПродажи.ТоварСпецифики КАК ТоварСпецифики,
	|	тПродажи.ТипТовара КАК ТипТовара,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаСпецифики * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаСпецифики,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаФактСпецифики * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаФактСпецифики,
	|	тОплата.Фирма КАК Фирма,
	|	тОплата.Фирма.КодТТ КАК ФирмаКодТТ,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(тПродажи.ШК, 1, 2) = ""21""
	|			ТОГДА ""00"" + ПОДСТРОКА(тПродажи.ШК, 3, 5) + ""000000""
	|		ИНАЧЕ тПродажи.ШК
	|	КОНЕЦ КАК ШК	
	|ПОМЕСТИТЬ ТаблицаРеализации
	|ИЗ
	|	тПродажиПред КАК тПродажи
	|		ЛЕВОЕ СОЕДИНЕНИЕ тОплата КАК тОплата
	|		ПО тПродажи.Заказ = тОплата.Заказ
	|
	|СГРУППИРОВАТЬ ПО
	|	тПродажи.КодСУП,
	|	тОплата.НомерККМ,
	|	тПродажи.Товар,
	|	тПродажи.СтавкаНДС,
	|	тОплата.ВариантОплаты,
	|	тПродажи.Заказ,
	|	тПродажи.ТипРасхода,
	|	тОплата.ККМ,
	|	тОплата.КассоваяСмена,
	|	тПродажи.ТоварСпецифики,
	|	тПродажи.ТипТовара,
	|	тОплата.Фирма,
	|	тОплата.Фирма.КодТТ,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(тПродажи.ШК, 1, 2) = ""21""
	|			ТОГДА ""00"" + ПОДСТРОКА(тПродажи.ШК, 3, 5) + ""000000""
	|		ИНАЧЕ тПродажи.ШК
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРеализации.КассоваяСмена КАК КассоваяСмена,
	|	ТаблицаРеализации.ККМ КАК ККМ,
	|	ТаблицаРеализации.ВариантОплаты КАК ВариантОплаты,
	|	ВЫРАЗИТЬ(СУММА(ТаблицаРеализации.СуммаФакт) КАК ЧИСЛО(15, 2)) КАК СуммаФакт
	|ПОМЕСТИТЬ ТаблицаРеализацииСвернутая
	|ИЗ
	|	ТаблицаРеализации КАК ТаблицаРеализации
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРеализации.КассоваяСмена,
	|	ТаблицаРеализации.ККМ,
	|	ТаблицаРеализации.ВариантОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	тОплата.ВариантОплаты КАК ВариантОплаты,
	|	тОплата.ККМ КАК ККМ,
	|	тОплата.КассоваяСмена КАК КассоваяСмена,
	|	СУММА(тОплата.СуммаФакт) КАК СуммаФакт
	|ПОМЕСТИТЬ ТаблицаОплат
	|ИЗ
	|	тОплата КАК тОплата
	|
	|СГРУППИРОВАТЬ ПО
	|	тОплата.ВариантОплаты,
	|	тОплата.ККМ,
	|	тОплата.КассоваяСмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОплат.ВариантОплаты, ТаблицаРеализацииСвернутая.ВариантОплаты) КАК ВариантОплаты,
	|	ЕСТЬNULL(ТаблицаОплат.ККМ, ТаблицаРеализацииСвернутая.ККМ) КАК ККМ,
	|	ЕСТЬNULL(ТаблицаОплат.КассоваяСмена, ТаблицаРеализацииСвернутая.КассоваяСмена) КАК КассоваяСмена,
	|	ТаблицаРеализацииСвернутая.СуммаФакт КАК СуммаФактРеализация,
	|	ТаблицаОплат.СуммаФакт КАК СуммаФактОплата,
	|	ТаблицаОплат.СуммаФакт - (ВЫРАЗИТЬ(ТаблицаРеализацииСвернутая.СуммаФакт КАК ЧИСЛО(15, 2))) КАК Копейка
	|ПОМЕСТИТЬ ТаблицаКопейки
	|ИЗ
	|	ТаблицаРеализацииСвернутая КАК ТаблицаРеализацииСвернутая
	|		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаОплат КАК ТаблицаОплат
	|		ПО ТаблицаРеализацииСвернутая.ВариантОплаты = ТаблицаОплат.ВариантОплаты
	|			И (ЕСТЬNULL(ТаблицаРеализацииСвернутая.ККМ, 0) = ЕСТЬNULL(ТаблицаОплат.ККМ, 0))
	|			И (ЕСТЬNULL(ТаблицаРеализацииСвернутая.КассоваяСмена, 0) = ЕСТЬNULL(ТаблицаОплат.КассоваяСмена, 0))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	тПродажиПред.Заказ КАК Заказ,
	|	тПродажиПред.Товар КАК Товар,
	|	СУММА(тПродажиПред.Количество) КАК Количество,
	|	СУММА(тПродажиПред.Сумма) КАК Сумма,
	|	СУММА(тПродажиПред.СуммаРеализации) КАК СуммаРеализации,
	|	тПродажиПред.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(тПродажиПред.СуммаНДС) КАК СуммаНДС,
	|	тПродажиПред.КодСУП КАК КодСУП,
	|	тПродажиПред.ТипРасхода КАК ТипРасхода,
	|	тПродажиПред.ТипТовара КАК ТипТовара,
	|	тПродажиПред.ТоварСпецифики КАК ТоварСпецифики,
	|	СУММА(тПродажиПред.СуммаСпецифики) КАК СуммаСпецифики,
	|	СУММА(тПродажиПред.СуммаФактСпецифики) КАК СуммаФактСпецифики,
	|	тПродажиПред.ШК КАК ШК
	|ИЗ
	|	тПродажиПред КАК тПродажиПред
	|
	|СГРУППИРОВАТЬ ПО
	|	тПродажиПред.Заказ,
	|	тПродажиПред.Товар,
	|	тПродажиПред.СтавкаНДС,
	|	тПродажиПред.ТоварСпецифики,
	|	тПродажиПред.ТипТовара,
	|	тПродажиПред.ТипРасхода,
	|	тПродажиПред.КодСУП,
	|	тПродажиПред.ШК");
	Запрос.УстановитьПараметр("Смена", Смена);
	Запрос.УстановитьПараметр("Закрыт", Перечисления.СтатусыЗаказа.Закрыт);
	Запрос.УстановитьПараметр("МестоРеализации", Смена.МестоРеализации);
	
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Выполнить();
	
	ТаблицаРеализации			= МВТ.Таблицы.Найти("ТаблицаРеализации").ПолучитьДанные().Выгрузить();
	ТаблицаОплат 				= МВТ.Таблицы.Найти("ТаблицаОплат").ПолучитьДанные().Выгрузить();
	ТаблицаРеализацииСвернутая	= МВТ.Таблицы.Найти("ТаблицаРеализацииСвернутая").ПолучитьДанные().Выгрузить();
	ТаблицаКопейки				= МВТ.Таблицы.Найти("ТаблицаКопейки").ПолучитьДанные().Выгрузить();
	
	Для Каждого СтрокаКопейки Из ТаблицаКопейки Цикл
		Если  СтрокаКопейки.Копейка = null Тогда
			Продолжить
		КонецЕсли;
		
		Если СтрокаКопейки.Копейка Тогда
			Отбор = Новый Структура("ВариантОплаты, ККМ, КассоваяСмена");
			ЗаполнитьЗначенияСвойств(Отбор, СтрокаКопейки);
			МС = ТаблицаРеализации.НайтиСтроки(Отбор);
			Для Каждого СМС Из МС Цикл
				Если СМС.СуммаФакт + СтрокаКопейки.Копейка > 0 Тогда
					СМС.СуммаФакт = СМС.СуммаФакт + СтрокаКопейки.Копейка;
					СМС.СуммаКорр = СтрокаКопейки.Копейка;
					Прервать
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;		
	КонецЦикла;
	
	Если Не ЧислаЧислами Тогда
		
		мУд = Новый Массив; // массив числовых колонок
		Для Каждого К Из ТаблицаРеализации.Колонки Цикл
			Если К.ТипЗначения.СодержитТип(Тип("Число")) Тогда
				мУд.Добавить(К);
				ТаблицаРеализации.Колонки.Добавить(К.имя+"Стр", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)),К.Имя);	
			КонецЕсли;
		КонецЦикла;
		
		
		Для Каждого Т Из ТаблицаРеализации Цикл
			Для Каждого К Из ТаблицаРеализации.Колонки Цикл
				Значение = Т[К.Имя];
				Если ТипЗнч(Значение) = Тип("Число") Тогда
					Т[К.Имя+"Стр"] = Формат(Значение, "ЧРД=.; ЧГ=0");
					
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		
		Для Каждого К Из мУд Цикл
			ИмяК = К.Имя;
			ТаблицаРеализации.Колонки.Удалить(К);
			ТаблицаРеализации.Колонки.Добавить(ИмяК, Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)), К.Имя);
			ТаблицаРеализации.ЗагрузитьКолонку(ТаблицаРеализации.ВыгрузитьКолонку(ИмяК+"Стр"),ИмяК);
			ТаблицаРеализации.Колонки.Удалить(ИмяК+"Стр");
		КонецЦикла;
		
		КоличествоКолонок = ТаблицаРеализации.Колонки.Количество();
		Для НомерКолонки = 1 По КоличествоКолонок Цикл
			К = ТаблицаРеализации.Колонки[КоличествоКолонок - НомерКолонки];
			Если Не СтрНайти(Строка(К.ТипЗначения), "Строка") Тогда
				//:К.ТипЗначения.содержитТип(Тип("СправочникСсылка"));
				ТаблицаРеализации.Колонки.Удалить(К);
			КонецЕсли;
		КонецЦикла;
		
		ТаблицаРеализации.Колонки.Удалить("СуммаКорр");
	КонецЕсли;
	
	
	Возврат ТаблицаРеализации;
КонецФункции

Функция ТаблицаОперативнойРеализацииКМ(Смена, ЧислаЧислами = 0, Фирма)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ЗаказТовары.Фирма КАК Фирма,
	|	ЗаказТовары.ДокументОплаты.КассоваяСмена.Касса КАК ККМ,
	|	ЗаказТовары.ДокументОплаты.КассоваяСмена КАК КассоваяСмена,
	|	ЗаказТовары.Товар КАК Товар,
	|	СУММА(ЗаказТовары.Количество) КАК Количество,
	|	СУММА(ЗаказТовары.Сумма) КАК Сумма,
	|	СУММА(ЗаказТовары.СуммаРеализации) КАК СуммаРеализации,
	|	ЗаказТовары.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(ЗаказТовары.СуммаНДС) КАК СуммаНДС,
	|	ЗаказТовары.ДокументОплаты.КассоваяСмена.СменаТТ КАК Смена,
	|	ПротоколРасчетовПротокол.ВариантОплаты КАК ВариантОплаты,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Реализация) КАК ТипРасхода,
	|	ЗаказТовары.ШК КАК ШК
	|ПОМЕСТИТЬ ЗаказыИвозвраты
	|ИЗ
	|	Документ.Заказ.Товары КАК ЗаказТовары
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПротоколРасчетов.Протокол КАК ПротоколРасчетовПротокол
	|		ПО ЗаказТовары.ДокументОплаты = ПротоколРасчетовПротокол.Ссылка
	|			И (ПротоколРасчетовПротокол.НомерСтроки = 1)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|		ПО ЗаказТовары.Ссылка = ЗаказДопИнф.Заказ
	|ГДЕ
	|	ЗаказДопИнф.Статус = &Закрыт
	|	И ЗаказТовары.ДокументОплаты.Смена = &Смена
	|	И ЗаказТовары.Фирма = &Фирма
	|	И ЗаказТовары.Ссылка.КартаДоступа.СлужебныйБейдж = 0
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказТовары.Фирма,
	|	ЗаказТовары.Товар,
	|	ЗаказТовары.СтавкаНДС,
	|	ПротоколРасчетовПротокол.ВариантОплаты,
	|	ЗаказТовары.ШК,
	|	ЗаказТовары.ДокументОплаты.КассоваяСмена,
	|	ЗаказТовары.ДокументОплаты.КассоваяСмена.Касса,
	|	ЗаказТовары.ДокументОплаты.КассоваяСмена.СменаТТ
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ВозвратТовары.Фирма,
	|	ВозвратДопИнф.ПротоколРасчетов.ККМ,
	|	ВозвратДопИнф.ПротоколРасчетов.КассоваяСмена,
	|	ВозвратТовары.Товар,
	|	-ВозвратТовары.Количество,
	|	-ВозвратТовары.СуммаРозничная,
	|	-ВозвратТовары.Сумма,
	|	ВозвратТовары.СтавкаНДС,
	|	ВозвратТовары.СуммаНДС,
	|	ВозвратДопИнф.ПротоколРасчетов.Смена,
	|	ВозвратТовары.Ссылка.ВариантОплаты,
	|	ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Возврат),
	|	ВозвратТовары.ШК
	|ИЗ
	|	Документ.Возврат.Товары КАК ВозвратТовары
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВозвратДопИнф КАК ВозвратДопИнф
	|		ПО ВозвратТовары.Ссылка = ВозвратДопИнф.Возврат
	|ГДЕ
	|	ВозвратДопИнф.ПротоколРасчетов.Фискализирован
	|	И ВозвратДопИнф.Возврат.Смена = &Смена
	|	И ВозвратТовары.Фирма = &Фирма
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЗаказыИвозвраты.Фирма КАК Фирма,
	|	ЗаказыИвозвраты.ККМ КАК ККМ,
	|	ЗаказыИвозвраты.КассоваяСмена КАК КассоваяСмена,
	|	ЗаказыИвозвраты.Товар КАК Товар,
	|	СУММА(ЗаказыИвозвраты.Количество) КАК Количество,
	|	СУММА(ЗаказыИвозвраты.Сумма) КАК Сумма,
	|	СУММА(ЗаказыИвозвраты.СуммаРеализации) КАК СуммаРеализации,
	|	ЗаказыИвозвраты.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(ЗаказыИвозвраты.СуммаНДС) КАК СуммаНДС,
	|	ЗаказыИвозвраты.Смена КАК Смена,
	|	ЗаказыИвозвраты.ВариантОплаты КАК ВариантОплаты,
	|	ЗаказыИвозвраты.ТипРасхода КАК ТипРасхода,
	|	ПРЕДСТАВЛЕНИЕ(ЕСТЬNULL(ЗаказыИвозвраты.ВариантОплаты, """")) КАК ТипОплаты,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ЗаказыИвозвраты.ШК, 1, 2) = ""21""
	|			ТОГДА ""00"" + ПОДСТРОКА(ЗаказыИвозвраты.ШК, 3, 5) + ""000000""
	|		ИНАЧЕ ЗаказыИвозвраты.ШК
	|	КОНЕЦ КАК ШК
	|ПОМЕСТИТЬ Сгруппированная
	|ИЗ
	|	ЗаказыИвозвраты КАК ЗаказыИвозвраты
	|ГДЕ
	|	(ЗаказыИвозвраты.Количество > 0
	|			ИЛИ ЗаказыИвозвраты.ТипРасхода = ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Возврат))
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаказыИвозвраты.Фирма,
	|	ЗаказыИвозвраты.ККМ,
	|	ЗаказыИвозвраты.КассоваяСмена,
	|	ЗаказыИвозвраты.Товар,
	|	ЗаказыИвозвраты.СтавкаНДС,
	|	ЗаказыИвозвраты.Смена,
	|	ЗаказыИвозвраты.ВариантОплаты,
	|	ЗаказыИвозвраты.ТипРасхода,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ЗаказыИвозвраты.ШК, 1, 2) = ""21""
	|			ТОГДА ""00"" + ПОДСТРОКА(ЗаказыИвозвраты.ШК, 3, 5) + ""000000""
	|		ИНАЧЕ ЗаказыИвозвраты.ШК
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сгруппированная.Товар КАК Товар,
	|	Сгруппированная.Фирма КАК Фирма,
	|	Сгруппированная.Фирма.КодТТ КАК ФирмаКодТТ,
	|	Сгруппированная.ККМ КАК ККМ,
	|	Сгруппированная.КассоваяСмена КАК КассоваяСмена,
	|	Сгруппированная.Количество КАК Количество,
	|	Сгруппированная.Сумма КАК СуммаРозн,
	|	Сгруппированная.СуммаРеализации КАК СуммаФакт,
	|	ПРЕДСТАВЛЕНИЕ(Сгруппированная.СтавкаНДС) КАК СтавкаНДС,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(10, 2)) КАК СуммаКорр,
	|	Сгруппированная.ККМ.КодСУП КАК НомерККМ,
	|	Сгруппированная.СтавкаНДС КАК СтавкаНДСссылка,
	|	Сгруппированная.СуммаНДС КАК СуммаНДС,
	|	Сгруппированная.Смена КАК Смена,
	|	Сгруппированная.ВариантОплаты КАК ВариантОплаты,
	|	Сгруппированная.Сумма / Сгруппированная.Количество КАК ЦенаРозн,
	|	Сгруппированная.СуммаРеализации / Сгруппированная.Количество КАК ЦенаФакт,
	|	Сгруппированная.ТипРасхода КАК ТипРасхода,
	|	Сгруппированная.ТипОплаты КАК ТипОплаты,
	|	""Товары"" КАК ТипТовара,
	|	"""" КАК ТоварСпецифики,
	|	0 КАК СуммаФактСпецифики,
	|	0 КАК СуммаСпецифики,
	|	Сгруппированная.Товар.КодСУП КАК КодСУП,
	|	Сгруппированная.ШК КАК ШК
	|ИЗ
	|	Сгруппированная КАК Сгруппированная";
	Запрос.УстановитьПараметр("Закрыт", Перечисления.СтатусыЗаказа.Закрыт);
	Запрос.УстановитьПараметр("Смена", Смена);
	Запрос.УстановитьПараметр("Фирма", Фирма);
	
	
	ТаблицаРеализации			= Запрос.Выполнить().Выгрузить();
	
	
	
	Если Не ЧислаЧислами Тогда
		Для Каждого Т ИЗ ТаблицаРеализации Цикл
			Т.Фирма = Формат(Т.ФирмаКодТТ, "ЧГ=0");
		КонецЦикла;
		
		
		мУд = Новый Массив; // массив числовых колонок
		Для Каждого К Из ТаблицаРеализации.Колонки Цикл
			Если К.ТипЗначения.СодержитТип(Тип("Число")) Тогда
				мУд.Добавить(К);
				ТаблицаРеализации.Колонки.Добавить(К.имя+"Стр", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)),К.Имя);	
			КонецЕсли;
		КонецЦикла;
		
		
		Для Каждого Т Из ТаблицаРеализации Цикл
			Для Каждого К Из ТаблицаРеализации.Колонки Цикл
				Значение = Т[К.Имя];
				Если ТипЗнч(Значение) = Тип("Число") Тогда
					Т[К.Имя+"Стр"] = Формат(Значение, "ЧРД=.; ЧГ=0");
					
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		
		Для Каждого К Из мУд Цикл
			ИмяК = К.Имя;
			ТаблицаРеализации.Колонки.Удалить(К);
			ТаблицаРеализации.Колонки.Добавить(ИмяК, Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)), К.Имя);
			ТаблицаРеализации.ЗагрузитьКолонку(ТаблицаРеализации.ВыгрузитьКолонку(ИмяК+"Стр"),ИмяК);
			ТаблицаРеализации.Колонки.Удалить(ИмяК+"Стр");
		КонецЦикла;
		
		КоличествоКолонок = ТаблицаРеализации.Колонки.Количество();
		Для НомерКолонки = 1 По КоличествоКолонок Цикл
			К = ТаблицаРеализации.Колонки[КоличествоКолонок - НомерКолонки];
			Если Не СтрНайти(Строка(К.ТипЗначения), "Строка") Тогда
				//:К.ТипЗначения.содержитТип(Тип("СправочникСсылка"));
				ТаблицаРеализации.Колонки.Удалить(К);
			КонецЕсли;
		КонецЦикла;
		
		ТаблицаРеализации.Колонки.Удалить("СуммаКорр");
	КонецЕсли;
	
	
	Возврат ТаблицаРеализации;
	
	
КонецФункции

Функция ТаблицаОперативнойРеализацииКП(Смена, ЧислаЧислами = 0, Фирма = Неопределено) Экспорт
	
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ЗаказДопИнф.Заказ КАК Заказ,
	|	тчПротокол.ВариантОплаты КАК ВариантОплаты,
	|	тчПротокол.СуммаФакт * ВЫБОР
	|		КОГДА докПротоколРасчетов.Заказ ССЫЛКА Документ.Заказ
	|			ТОГДА 1
	|		ИНАЧЕ -1
	|	КОНЕЦ КАК СуммаФакт,
	|	1 КАК Доля,
	|	докПротоколРасчетов.КассоваяСмена.Касса.КодСУП КАК НомерККМ,
	|	докПротоколРасчетов.КассоваяСмена.Касса КАК ККМ,
	|	докПротоколРасчетов.КассоваяСмена КАК КассоваяСмена,
	|	докПротоколРасчетов.КассоваяСмена.Касса.Фирма КАК Фирма
	|ПОМЕСТИТЬ тОплата
	|ИЗ
	|	Документ.ПротоколРасчетов КАК докПротоколРасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПротоколРасчетов.Протокол КАК тчПротокол
	|		ПО (тчПротокол.Ссылка = докПротоколРасчетов.Ссылка)
	|		ПОЛНОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаказДопИнф.Заказ КАК Заказ,
	|			ЗаказДопИнф.Статус КАК Статус,
	|			ЗаказТовары.ДокументОплаты КАК ПротоколРасчетов
	|		ИЗ
	|			РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ.Товары КАК ЗаказТовары
	|				ПО ЗаказДопИнф.Заказ = ЗаказТовары.Ссылка
	|		ГДЕ
	|			ЗаказДопИнф.Статус = &Закрыт
	|		
	|		ОБЪЕДИНИТЬ ВСЕ
	|		
	|		ВЫБРАТЬ
	|			ВозвратДопИнф.Возврат,
	|			ВозвратДопИнф.Статус,
	|			ВозвратДопИнф.ПротоколРасчетов
	|		ИЗ
	|			РегистрСведений.ВозвратДопИнф КАК ВозвратДопИнф
	|		ГДЕ
	|			ВозвратДопИнф.Статус = &Закрыт) КАК ЗаказДопИнф
	|		ПО докПротоколРасчетов.Ссылка = ЗаказДопИнф.ПротоколРасчетов
	|ГДЕ
	|	докПротоколРасчетов.КассоваяСмена.СменаТТ = &Смена
	|	И докПротоколРасчетов.Проведен
	|	И докПротоколРасчетов.КассоваяСмена.Касса.Фирма = &Фирма
	|
	|СГРУППИРОВАТЬ ПО
	|	тчПротокол.ВариантОплаты,
	|	ЗаказДопИнф.Заказ,
	|	докПротоколРасчетов.ИтогСуммаФакт,
	|	докПротоколРасчетов.КассоваяСмена,
	|	тчПротокол.СуммаФакт * ВЫБОР
	|		КОГДА докПротоколРасчетов.Заказ ССЫЛКА Документ.Заказ
	|			ТОГДА 1
	|		ИНАЧЕ -1
	|	КОНЕЦ,
	|	докПротоколРасчетов.КассоваяСмена.Касса.Фирма,
	|	докПротоколРасчетов.КассоваяСмена.Касса.КодСУП,
	|	докПротоколРасчетов.КассоваяСмена.Касса
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	т.Заказ КАК Заказ,
	|	т.Товар КАК Товар,
	|	СУММА(т.Количество) КАК Количество,
	|	СУММА(т.Сумма) КАК Сумма,
	|	СУММА(т.СуммаРеализации) КАК СуммаРеализации,
	|	т.СтавкаНДС КАК СтавкаНДС,
	|	СУММА(т.СуммаНДС) КАК СуммаНДС,
	|	т.КодСУП КАК КодСУП,
	|	т.ТипРасхода КАК ТипРасхода,
	|	т.ТипТовара КАК ТипТовара,
	|	т.ТоварСпецифики КАК ТоварСпецифики,
	|	СУММА(т.СуммаСпецифики) КАК СуммаСпецифики,
	|	СУММА(т.СуммаФактСпецифики) КАК СуммаФактСпецифики,
	|	т.ШК КАК ШК
	|ПОМЕСТИТЬ тПродажиПред
	|ИЗ
	|	(ВЫБРАТЬ
	|		докЗаказ.Ссылка КАК Заказ,
	|		ЗаказТовары.Товар КАК Товар,
	|		СУММА(ЗаказТовары.Количество) КАК Количество,
	|		СУММА(ЗаказТовары.Сумма) КАК Сумма,
	|		СУММА(ЗаказТовары.СуммаРеализации) КАК СуммаРеализации,
	|		ЗаказТовары.СтавкаНДС КАК СтавкаНДС,
	|		СУММА(ЗаказТовары.СуммаНДС) КАК СуммаНДС,
	|		ЗаказТовары.Товар.КодСУП КАК КодСУП,
	|		ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Реализация) КАК ТипРасхода,
	|		""Товары"" КАК ТипТовара,
	|		NULL КАК ТоварСпецифики,
	|		0 КАК СуммаСпецифики,
	|		0 КАК СуммаФактСпецифики,
	|		ЗаказТовары.ШК КАК ШК
	|	ИЗ
	|		Документ.Заказ.Товары КАК ЗаказТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|			ПО ЗаказТовары.Ссылка = ЗаказДопИнф.Заказ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ КАК докЗаказ
	|			ПО (докЗаказ.Ссылка = ЗаказТовары.Ссылка)
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК Номенклатура
	|			ПО ЗаказТовары.Товар.Номенклатура = Номенклатура.Ссылка
	|	ГДЕ
	|		ЗаказДопИнф.Статус = &Закрыт
	|		И НЕ докЗаказ.ПометкаУдаления
	|		И ЗаказТовары.Сумма + ЗаказТовары.СуммаРеализации + ЗаказТовары.Количество > 0
	|		И ЗаказТовары.Фирма = &Фирма
	|		И ЗаказТовары.ДокументОплаты.Смена = &Смена
	|	
	|	СГРУППИРОВАТЬ ПО
	|		докЗаказ.Ссылка,
	|		ЗаказТовары.Товар,
	|		ЗаказТовары.СтавкаНДС,
	|		ЗаказТовары.Товар.КодСУП,
	|		ЗаказТовары.ШК
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		докЗаказ.Ссылка,
	|		ЗаказСпецифики.Специфика,
	|		СУММА(докЗаказТовары.Количество),
	|		0,
	|		0,
	|		докЗаказТовары.СтавкаНДС,
	|		0,
	|		ЗаказСпецифики.Специфика.Номенклатура.КодСУП,
	|		ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Реализация),
	|		""Специфики"",
	|		докЗаказТовары.Товар,
	|		СУММА(ЗаказСпецифики.Цена * докЗаказТовары.Количество),
	|		СУММА(ЗаказСпецифики.ЦенаРеализации * докЗаказТовары.Количество),
	|		NULL
	|	ИЗ
	|		Документ.Заказ.Специфики КАК ЗаказСпецифики
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|			ПО ЗаказСпецифики.Ссылка = ЗаказДопИнф.Заказ
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ КАК докЗаказ
	|			ПО ЗаказСпецифики.Ссылка = докЗаказ.Ссылка
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ.Товары КАК докЗаказТовары
	|			ПО ЗаказСпецифики.Ссылка = докЗаказТовары.Ссылка
	|				И ЗаказСпецифики.НомерСтрокиТовара = докЗаказТовары.НомерСтроки
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК спрНоменклатура
	|			ПО (спрНоменклатура.Ссылка = ЗаказСпецифики.Специфика.Номенклатура)
	|	ГДЕ
	|		докЗаказТовары.ДокументОплаты.Смена = &Смена
	|		И ЗаказДопИнф.Статус = &Закрыт
	|		И НЕ докЗаказ.ПометкаУдаления
	|		И ЗаказСпецифики.ЦенаРеализации + ЗаказСпецифики.Цена + ЗаказСпецифики.Количество > 0
	|		И докЗаказТовары.Фирма = &Фирма
	|	
	|	СГРУППИРОВАТЬ ПО
	|		докЗаказ.Ссылка,
	|		ЗаказСпецифики.Специфика,
	|		докЗаказТовары.СтавкаНДС,
	|		ЗаказСпецифики.Специфика.Номенклатура.КодСУП,
	|		докЗаказТовары.Товар
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		докВозврат.Ссылка,
	|		ВозвратТовары.Товар,
	|		СУММА(-ВозвратТовары.Количество),
	|		СУММА(-ВозвратТовары.СуммаРозничная),
	|		СУММА(-ВозвратТовары.Сумма),
	|		ВозвратТовары.СтавкаНДС,
	|		СУММА(-ВозвратТовары.СуммаНДС),
	|		ВозвратТовары.Товар.КодСУП,
	|		ЗНАЧЕНИЕ(Перечисление.ТипыРасхода.Возврат),
	|		""Товары"",
	|		NULL,
	|		0,
	|		0,
	|		ВозвратТовары.ШК
	|	ИЗ
	|		Документ.Возврат.Товары КАК ВозвратТовары
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВозвратДопИнф КАК ВозвратДопИнф
	|			ПО ВозвратТовары.Ссылка = ВозвратДопИнф.Возврат
	|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Возврат КАК докВозврат
	|			ПО (докВозврат.Ссылка = ВозвратТовары.Ссылка)
	|	ГДЕ
	|		докВозврат.Смена = &Смена
	|		И ВозвратДопИнф.Статус = &Закрыт
	|		И НЕ докВозврат.ПометкаУдаления
	|		И ВозвратТовары.Сумма + ВозвратТовары.Количество > 0
	|	
	|	СГРУППИРОВАТЬ ПО
	|		докВозврат.Ссылка,
	|		ВозвратТовары.Товар,
	|		ВозвратТовары.СтавкаНДС,
	|		ВозвратТовары.Товар.КодСУП,
	|		ВозвратТовары.ШК) КАК т
	|ГДЕ
	|	ЕСТЬNULL(т.Заказ.КартаДоступа.СлужебныйБейдж, 0) = 0
	|
	|СГРУППИРОВАТЬ ПО
	|	т.Заказ,
	|	т.Товар,
	|	т.СтавкаНДС,
	|	т.КодСУП,
	|	т.ТипРасхода,
	|	т.ТипТовара,
	|	т.ТоварСпецифики,
	|	т.ШК
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СУММА(тПродажи.Количество * ЕСТЬNULL(тОплата.Доля, 1)) КАК Количество,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.Сумма * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаРозн,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаРеализации * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаФакт,
	|	ПРЕДСТАВЛЕНИЕ(тПродажи.СтавкаНДС) КАК СтавкаНДС,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаНДС * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаНДС,
	|	тПродажи.КодСУП КАК КодСУП,
	|	ЕСТЬNULL(ПРЕДСТАВЛЕНИЕ(тОплата.ВариантОплаты), """") КАК ТипОплаты,
	|	тОплата.НомерККМ КАК НомерККМ,
	|	тПродажи.Заказ КАК Заказ,
	|	тПродажи.Товар КАК Товар,
	|	тПродажи.СтавкаНДС КАК СтавкаНДСссылка,
	|	тОплата.ВариантОплаты КАК ВариантОплаты,
	|	тПродажи.ТипРасхода КАК ТипРасхода,
	|	тОплата.ККМ КАК ККМ,
	|	тОплата.КассоваяСмена КАК КассоваяСмена,
	|	ВЫРАЗИТЬ(0 КАК ЧИСЛО(10, 2)) КАК СуммаКорр,
	|	тПродажи.ТоварСпецифики КАК ТоварСпецифики,
	|	тПродажи.ТипТовара КАК ТипТовара,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаСпецифики * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаСпецифики,
	|	ВЫРАЗИТЬ(СУММА(тПродажи.СуммаФактСпецифики * ЕСТЬNULL(тОплата.Доля, 1)) КАК ЧИСЛО(15, 2)) КАК СуммаФактСпецифики,
	|	тОплата.Фирма КАК Фирма,
	|	тОплата.Фирма.КодТТ КАК ФирмаКодТТ,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(тПродажи.ШК, 1, 2) = ""21""
	|			ТОГДА ""00"" + ПОДСТРОКА(тПродажи.ШК, 3, 5) + ""000000""
	|		ИНАЧЕ тПродажи.ШК
	|	КОНЕЦ КАК ШК
	|ПОМЕСТИТЬ ТаблицаРеализации
	|ИЗ
	|	тПродажиПред КАК тПродажи
	|		ЛЕВОЕ СОЕДИНЕНИЕ тОплата КАК тОплата
	|		ПО тПродажи.Заказ = тОплата.Заказ
	|
	|СГРУППИРОВАТЬ ПО
	|	тПродажи.КодСУП,
	|	тОплата.НомерККМ,
	|	тПродажи.Товар,
	|	тПродажи.СтавкаНДС,
	|	тОплата.ВариантОплаты,
	|	тПродажи.Заказ,
	|	тПродажи.ТипРасхода,
	|	тОплата.ККМ,
	|	тОплата.КассоваяСмена,
	|	тПродажи.ТоварСпецифики,
	|	тПродажи.ТипТовара,
	|	тОплата.Фирма,
	|	тОплата.Фирма.КодТТ,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(тПродажи.ШК, 1, 2) = ""21""
	|			ТОГДА ""00"" + ПОДСТРОКА(тПродажи.ШК, 3, 5) + ""000000""
	|		ИНАЧЕ тПродажи.ШК
	|	КОНЕЦ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРеализации.КассоваяСмена КАК КассоваяСмена,
	|	ТаблицаРеализации.ККМ КАК ККМ,
	|	ТаблицаРеализации.ВариантОплаты КАК ВариантОплаты,
	|	ВЫРАЗИТЬ(СУММА(ТаблицаРеализации.СуммаФакт) КАК ЧИСЛО(15, 2)) КАК СуммаФакт
	|ПОМЕСТИТЬ ТаблицаРеализацииСвернутая
	|ИЗ
	|	ТаблицаРеализации КАК ТаблицаРеализации
	|
	|СГРУППИРОВАТЬ ПО
	|	ТаблицаРеализации.КассоваяСмена,
	|	ТаблицаРеализации.ККМ,
	|	ТаблицаРеализации.ВариантОплаты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	тОплата.ВариантОплаты КАК ВариантОплаты,
	|	тОплата.ККМ КАК ККМ,
	|	тОплата.КассоваяСмена КАК КассоваяСмена,
	|	СУММА(тОплата.СуммаФакт) КАК СуммаФакт
	|ПОМЕСТИТЬ ТаблицаОплат
	|ИЗ
	|	тОплата КАК тОплата
	|
	|СГРУППИРОВАТЬ ПО
	|	тОплата.ВариантОплаты,
	|	тОплата.ККМ,
	|	тОплата.КассоваяСмена
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ЕСТЬNULL(ТаблицаОплат.ВариантОплаты, ТаблицаРеализацииСвернутая.ВариантОплаты) КАК ВариантОплаты,
	|	ЕСТЬNULL(ТаблицаОплат.ККМ, ТаблицаРеализацииСвернутая.ККМ) КАК ККМ,
	|	ЕСТЬNULL(ТаблицаОплат.КассоваяСмена, ТаблицаРеализацииСвернутая.КассоваяСмена) КАК КассоваяСмена,
	|	ТаблицаРеализацииСвернутая.СуммаФакт КАК СуммаФактРеализация,
	|	ТаблицаОплат.СуммаФакт КАК СуммаФактОплата,
	|	ТаблицаОплат.СуммаФакт - (ВЫРАЗИТЬ(ТаблицаРеализацииСвернутая.СуммаФакт КАК ЧИСЛО(15, 2))) КАК Копейка
	|ПОМЕСТИТЬ ТаблицаКопейки
	|ИЗ
	|	ТаблицаРеализацииСвернутая КАК ТаблицаРеализацииСвернутая
	|		ПОЛНОЕ СОЕДИНЕНИЕ ТаблицаОплат КАК ТаблицаОплат
	|		ПО ТаблицаРеализацииСвернутая.ВариантОплаты = ТаблицаОплат.ВариантОплаты
	|			И (ЕСТЬNULL(ТаблицаРеализацииСвернутая.ККМ, 0) = ЕСТЬNULL(ТаблицаОплат.ККМ, 0))
	|			И (ЕСТЬNULL(ТаблицаРеализацииСвернутая.КассоваяСмена, 0) = ЕСТЬNULL(ТаблицаОплат.КассоваяСмена, 0))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаРеализации.Фирма КАК Фирма,
	|	ТаблицаРеализации.ТипОплаты КАК ТипОплаты,
	|	ТаблицаРеализации.ККМ КАК ККМ,
	|	ТаблицаРеализации.КассоваяСмена КАК КассоваяСмена,
	|	ТаблицаРеализации.Количество КАК Количество,
	|	ТаблицаРеализации.СуммаФакт КАК СуммаФакт,
	|	ТаблицаРеализации.Заказ КАК Заказ,
	|	ТаблицаРеализации.СуммаРозн КАК СуммаРозн,
	|	ТаблицаРеализации.СтавкаНДС КАК СтавкаНДС,
	|	ТаблицаРеализации.СуммаНДС КАК СуммаНДС,
	|	ТаблицаРеализации.КодСУП КАК КодСУП,
	|	ТаблицаРеализации.НомерККМ КАК НомерККМ,
	|	ТаблицаРеализации.Товар КАК Товар,
	|	ТаблицаРеализации.СтавкаНДСссылка КАК СтавкаНДСссылка,
	|	ТаблицаРеализации.ТипРасхода КАК ТипРасхода,
	|	ТаблицаРеализации.СуммаКорр КАК СуммаКорр,
	|	ТаблицаРеализации.ТоварСпецифики КАК ТоварСпецифики,
	|	ТаблицаРеализации.ТипТовара КАК ТипТовара,
	|	ТаблицаРеализации.СуммаСпецифики КАК СуммаСпецифики,
	|	ТаблицаРеализации.СуммаФактСпецифики КАК СуммаФактСпецифики,
	|	ТаблицаРеализации.ФирмаКодТТ КАК ФирмаКодТТ,
	|	ТаблицаРеализации.ШК КАК ШК,
	|	ТаблицаРеализации.ВариантОплаты КАК ВариантОплаты
	|ИЗ
	|	ТаблицаРеализации КАК ТаблицаРеализации");
	Запрос.УстановитьПараметр("Смена", Смена);
	Запрос.УстановитьПараметр("Фирма", Фирма);
	Запрос.УстановитьПараметр("Закрыт", Перечисления.СтатусыЗаказа.Закрыт);
	Запрос.УстановитьПараметр("МестоРеализации", Смена.МестоРеализации);
	
	МВТ = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МВТ;
	Запрос.Выполнить();
	
	ТаблицаРеализации			= МВТ.Таблицы.Найти("ТаблицаРеализации").ПолучитьДанные().Выгрузить();
	ТаблицаОплат 				= МВТ.Таблицы.Найти("ТаблицаОплат").ПолучитьДанные().Выгрузить();
	ТаблицаРеализацииСвернутая	= МВТ.Таблицы.Найти("ТаблицаРеализацииСвернутая").ПолучитьДанные().Выгрузить();
	ТаблицаКопейки				= МВТ.Таблицы.Найти("ТаблицаКопейки").ПолучитьДанные().Выгрузить();
	
	Для Каждого СтрокаКопейки Из ТаблицаКопейки Цикл
		Если  СтрокаКопейки.Копейка = null Тогда
			Продолжить
		КонецЕсли;
		
		Если СтрокаКопейки.Копейка Тогда
			Отбор = Новый Структура("ВариантОплаты, ККМ, КассоваяСмена");
			ЗаполнитьЗначенияСвойств(Отбор, СтрокаКопейки);
			МС = ТаблицаРеализации.НайтиСтроки(Отбор);
			Для Каждого СМС Из МС Цикл
				Если СМС.СуммаФакт + СтрокаКопейки.Копейка > 0 Тогда
					СМС.СуммаФакт = СМС.СуммаФакт + СтрокаКопейки.Копейка;
					СМС.СуммаКорр = СтрокаКопейки.Копейка;
					Прервать
				КонецЕсли;
			КонецЦикла;
		КонецЕсли;		
	КонецЦикла;
	
	Если Не ЧислаЧислами Тогда
		
		мУд = Новый Массив; // массив числовых колонок
		Для Каждого К Из ТаблицаРеализации.Колонки Цикл
			Если К.ТипЗначения.СодержитТип(Тип("Число")) Тогда
				мУд.Добавить(К);
				ТаблицаРеализации.Колонки.Добавить(К.имя+"Стр", Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)),К.Имя);	
			КонецЕсли;
		КонецЦикла;
		
		
		Для Каждого Т Из ТаблицаРеализации Цикл
			Для Каждого К Из ТаблицаРеализации.Колонки Цикл
				Значение = Т[К.Имя];
				Если ТипЗнч(Значение) = Тип("Число") Тогда
					Т[К.Имя+"Стр"] = Формат(Значение, "ЧРД=.; ЧГ=0");
					
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		
		Для Каждого К Из мУд Цикл
			ИмяК = К.Имя;
			ТаблицаРеализации.Колонки.Удалить(К);
			ТаблицаРеализации.Колонки.Добавить(ИмяК, Новый ОписаниеТипов("Строка",,Новый КвалификаторыСтроки(20)), К.Имя);
			ТаблицаРеализации.ЗагрузитьКолонку(ТаблицаРеализации.ВыгрузитьКолонку(ИмяК+"Стр"),ИмяК);
			ТаблицаРеализации.Колонки.Удалить(ИмяК+"Стр");
		КонецЦикла;
		
		КоличествоКолонок = ТаблицаРеализации.Колонки.Количество();
		Для НомерКолонки = 1 По КоличествоКолонок Цикл
			К = ТаблицаРеализации.Колонки[КоличествоКолонок - НомерКолонки];
			Если Не СтрНайти(Строка(К.ТипЗначения), "Строка") Тогда
				//:К.ТипЗначения.содержитТип(Тип("СправочникСсылка"));
				ТаблицаРеализации.Колонки.Удалить(К);
			КонецЕсли;
		КонецЦикла;
		
		ТаблицаРеализации.Колонки.Удалить("СуммаКорр");
	КонецЕсли;
	
	
	Возврат ТаблицаРеализации;
КонецФункции
