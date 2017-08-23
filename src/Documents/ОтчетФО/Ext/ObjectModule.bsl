﻿
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Товары.Свернуть("Номенклатура, ЕдиницаИзмерения, Контрагент, ВариантОплаты, Идентификатор, ККМ, КассоваяСмена, СтавкаНДС", "Количество, Сумма, СуммаБезСкидки, СуммаБонусов, СуммаНДС, СуммаКорр");
	Для Каждого Т Из Товары Цикл
		
		Если Не ЗначениеЗаполнено(Т.СтавкаНДС) Тогда
			Товар = ОбщегоНазначенияПовтИсп.НайтиПоРеквизиту("Справочник.Товары","Номенклатура",Т.Номенклатура);
			Т.СтавкаНДС = Товар.Категория.СтавкаНДС;
			ПроцентНДС = ОбщегоНазначенияПовтИсп.ЗначениеСтавкиНДС(Т.СтавкаНДС);
			Т.СуммаНДС = (Т.Сумма * ПроцентНДС)/(100+ПроцентНДС);
		КонецЕсли;
		Если Т.Количество Тогда
			Т.Цена = Т.Сумма / Т.Количество;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Т.ЕдиницаИзмерения) Тогда
			Т.ЕдиницаИзмерения = Т.Номенклатура.БазоваяЕдиницаИзмерения;
		КонецЕсли;
		
	КонецЦикла;
	
	
	Для Каждого Т Из Специфики Цикл
		Если Не ЗначениеЗаполнено(Т.ЕдиницаИзмерения) Тогда
			Т.ЕдиницаИзмерения = Т.Номенклатура.БазоваяЕдиницаИзмерения;
		КонецЕсли;
	
	КонецЦикла;
	
	
	РасчитатьСуммуСкидок();
	СуммаКорр = Товары.Итог("СуммаКорр");
КонецПроцедуры

Процедура РасчитатьСуммуСкидок() Экспорт
	пСуммаСкидок = -Товары.Итог("Сумма") + Товары.Итог("СуммаБезСкидки");
	Если пСуммаСкидок - СуммаСкидок Тогда
		СуммаСкидок = пСуммаСкидок;
	КонецЕсли;
КонецПроцедуры


