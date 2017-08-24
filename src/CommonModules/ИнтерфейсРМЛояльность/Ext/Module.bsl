﻿#Если НЕ ТонкийКлиент Тогда
     	
Процедура ФормаПриОткрытии(Форма) Экспорт 
	
	Попытка
		Действие = Новый Действие("ПлашкаКупонНажатие");
		Для Инд = 1 По 6 Цикл
			ТекЭлемент = Форма.ЭлементыФормы["Плашка" + Инд];
			ТекЭлемент.УстановитьДействие("Нажатие", Действие);
		КонецЦикла;
		
		Действие = Новый Действие("Плашка_Н_Нажатие");
		Для Инд = 7 По 11 Цикл
			ТекЭлемент = Форма.ЭлементыФормы["Плашка" + Инд];
			ТекЭлемент.УстановитьДействие("Нажатие", Действие);
		КонецЦикла;
	Исключение
	    //ОписаниеОшибки()
	КонецПопытки;
	
КонецПроцедуры

// первые 6 кнопок
Процедура ПлашкаКупонНажатие(Форма, Элемент) Экспорт
	
	Попытка
		ЗаказСсылка = Форма.Заказ.Ссылка;
		КупоныСоответствие = Форма.КупоныСоответствие;
	Исключение
	    Возврат;
	КонецПопытки;
	
	КодКупона = КупоныСоответствие.Получить(СтрЗаменить(Элемент.Имя, "Плашка", ""));
	Если ТипЗнч(Форма.Заказ) = Тип("ДокументСсылка.Заказ") Тогда
		ЗаказОбъект = Форма.Заказ.ПолучитьОбъект();
		ЛояльностьКлиент.ПеренестиКупонВЗаказ(ЗаказОбъект, КодКупона);
		Форма.ОбработкаОбъект.ЗаписатьЗаказ(ЗаказОбъект, ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
	ИначеЕсли ТипЗнч(Форма.Заказ) = Тип("ДокументОбъект.Заказ") Тогда
		ЗаказОбъект = Форма.Заказ;
		ЛояльностьКлиент.ПеренестиКупонВЗаказ(ЗаказОбъект, КодКупона);
		Форма.ОбработкаОбъект.ЗаписатьЗаказ(ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
		Форма.ОбработкаОбъект.ПрочитатьТекущийДокумент();
	КонецЕсли;
	
КонецПроцедуры

// кнопки с 7 по 11
Процедура Плашка_Н_Нажатие(Форма, Элемент) Экспорт 
	Выполнить("" + Элемент.Имя + "Нажатие(Форма, Элемент);"); 
КонецПроцедуры

Процедура Плашка7Нажатие(Форма, Элемент)
		
КонецПроцедуры
Процедура Плашка8Нажатие(Форма, Элемент)
		
КонецПроцедуры
Процедура Плашка9Нажатие(Форма, Элемент)
	
	Попытка
		ЗаказСсылка = Форма.Заказ.Ссылка;
	Исключение
	    Возврат;
	КонецПопытки;
	
	глОтсечкаПростоя();
	Лояльность.ОбновитьПредварительныйРасчетЗаказа(ЗаказСсылка, глПараметрыРМ.Тест);
	ОбновитьТабДокЛояльность(Форма);
	
КонецПроцедуры
Процедура Плашка10Нажатие(Форма, Элемент)
		
КонецПроцедуры
Процедура Плашка11Нажатие(Форма, Элемент)
		
КонецПроцедуры

Процедура ОбновитьНадписьПриветствие(Форма, ВерсияДанных = "") Экспорт 
	
	Попытка
		НомерКартыЛояльности = Форма.Заказ.НомерКартыЛояльности;
	Исключение
	    НомерКартыЛояльности = "";
	КонецПопытки;
	Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = "Здравствуйте, Гость!
	|Нет карты КеГеЛьБУМ.";
	
	ДанныеГостя = ЛояльностьКлиентСервер.ПолучитьДанныеГостя(НомерКартыЛояльности, глПараметрыРМ.Тест);
	Если ДанныеГостя.Ошибка Тогда
		Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = "Здравствуйте!";
	Иначе	
		НомерКартыЛояльности = СокрЛП(Формат(ДанныеГостя.НомерКарты, "ЧГ=0"));
		Попытка
			Имя = СтрРазделить(ДанныеГостя.ФИО, " ")[0];
		Исключение
			Имя = "Гость";
		КонецПопытки;
		Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = СтрШаблон("Здравствуйте, %1!
		|Карта %2*****%3", Имя, Лев(НомерКартыЛояльности, 2), Прав(НомерКартыЛояльности, 4));
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьКупоны(Форма, ВерсияДанных = "", ДанныеЛояльности = Неопределено) Экспорт 
	
	Попытка
		ЗаказСсылка = Форма.Заказ.Ссылка;
		НомерКартыЛояльности = ЗаказСсылка.НомерКартыЛояльности;
	Исключение
	    НомерКартыЛояльности = Неопределено;
	КонецПопытки;
	
	Попытка
		Форма.КупоныСоответствие = Новый Соответствие;
	Исключение
	    //ОписаниеОшибки()
	КонецПопытки; 
	
	Для Инд = 1 По 6 Цикл
		ТекЭлемент = Форма.ЭлементыФормы["Плашка" + Инд];
		ТекЭлемент.Заголовок = "";
		ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаФормы;
		ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
	КонецЦикла;

	Если НЕ ЗначениеЗаполнено(НомерКартыЛояльности) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЛояльности = Неопределено Тогда
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(ЗаказСсылка, ВерсияДанных);
	КонецЕсли;
		
	КупоныГостя = ДанныеЛояльности.Купоны;
	Для Сч = 0 По КупоныГостя.ВГраница() Цикл
		Инд = Сч + 1;
		Если Инд > 6 Тогда
			Прервать;
		КонецЕсли;
		ТекЭлемент = Форма.ЭлементыФормы["Плашка" + Инд];
		ТекЭлемент.Заголовок = КупоныГостя[Сч].ИнфоСтанции;
		Если КупоныГостя[Сч].Статус = -1 Тогда
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаФормы;
			ТекЭлемент.ЦветТекстаКнопки = WebЦвета.Красный;
		ИначеЕсли КупоныГостя[Сч].Статус = 0 Тогда
			ТекЭлемент.ЦветФонаКнопки = WebЦвета.Лосось;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупоныГостя[Сч].Статус = 1 Тогда	
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаФормы;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупоныГостя[Сч].Статус = 2 Тогда	
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаОплаченнойСтроки;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупоныГостя[Сч].Статус = 3 Тогда	
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.НеактивнаяКнопка;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		КонецЕсли;
		
		Попытка
		Форма.КупоныСоответствие.Вставить(Формат(Сч + 1, "ЧДЦ=; ЧГ=0"), КупоныГостя[Сч].Код);
		Исключение
		    //ОписаниеОшибки()
		КонецПопытки; 
	КонецЦикла;
	
КонецПроцедуры

Процедура ОбновитьТабДокЛояльность(Форма, ВерсияДанных = "", ДанныеЛояльности = Неопределено) Экспорт 
	
	Попытка
		Макет = ПолучитьОбщийМакет("ТабДокЛояльность");
		ОбластьСтрокаКГЛ = Макет.ПолучитьОбласть("СтрокаКГЛ");
		ОбластьСтрокаИтого = Макет.ПолучитьОбласть("СтрокаИтого");
		
		ТабДок = Форма.ЭлементыФормы.ТабДокЛояльность;
		ТабДок.Очистить();
		ТабДокИтоги = Форма.ЭлементыФормы.ТабДокЛояльностьИтоги;
		ТабДокИтоги.Очистить();
		
		ЗаказСсылка = Форма.Заказ.Ссылка;
		НомерКартыЛояльности = ЗаказСсылка.НомерКартыЛояльности;
	Исключение
	    НомерКартыЛояльности = Неопределено;
	КонецПопытки;
	
	Если НЕ ЗначениеЗаполнено(НомерКартыЛояльности) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЛояльности = Неопределено Тогда
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(ЗаказСсылка, ВерсияДанных);
	КонецЕсли;
	
	КГЛ = 0;
	Итоги = ДанныеЛояльности.ИтогиМ.КГЛИнфо;
	Для каждого ТекСтрока Из Итоги Цикл
		КГЛ = КГЛ + ТекСтрока.КГЛ;
		Если ТекСтрока.КГЛ > 0 Тогда
			ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
			ТабДок.Вывести(ОбластьСтрокаКГЛ);
		КонецЕсли;
	КонецЦикла;
	Итоги = ДанныеЛояльности.ИтогиО.КГЛИнфо;
	Для каждого ТекСтрока Из Итоги Цикл
		КГЛ = КГЛ + ТекСтрока.КГЛ;
		Если ТекСтрока.КГЛ > 0 Тогда
			ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
			ТабДок.Вывести(ОбластьСтрокаКГЛ);
		КонецЕсли;
	КонецЦикла;
	Итоги = ДанныеЛояльности.ИтогиКП.КГЛИнфо;
	Для каждого ТекСтрока Из Итоги Цикл
		КГЛ = КГЛ + ТекСтрока.КГЛ;
		Если ТекСтрока.КГЛ > 0 Тогда
			ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
			ТабДок.Вывести(ОбластьСтрокаКГЛ);
		КонецЕсли;
	КонецЦикла;
	Если КГЛ > 0 Тогда
		ОбластьСтрокаИтого.Параметры.КГЛ = КГЛ;
		ТабДокИтоги.Вывести(ОбластьСтрокаИтого);
	КонецЕсли;
		
КонецПроцедуры

Функция ОбновитьТовары(Форма, ВерсияДанных = "", ТабличноеПоле = Неопределено) Экспорт 
	
	Попытка
		ЗаказСсылка = Форма.Заказ.Ссылка;
	Исключение
	    Возврат Неопределено;
	КонецПопытки;

	Если ТабличноеПоле = Неопределено ИЛИ НЕ ТипЗнч(ТабличноеПоле) = Тип("ТаблицаЗначений") Тогда
		Возврат ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(ЗаказСсылка, ВерсияДанных); //TODO
	КонецЕсли;
	
	Если ТабличноеПоле.Колонки.Найти("КГЛНачислено") = Неопределено Тогда
		НовКолонка = ТабличноеПоле.Колонки.Добавить("КГЛНачислено", "КеГЛи");
		НовКолонка.ЦветТекстаПоля = ЦветаСтиля.ЦветТемы;
		НовКолонка.ШрифтТекста = Новый Шрифт(НовКолонка.ШрифтТекста,,,Истина);
		НовКолонка.Ширина = 8;
	КонецЕсли;
	Если ТабличноеПоле.Колонки.Найти("ГруппаАкции") = Неопределено Тогда
		НовКолонка = ТабличноеПоле.Колонки.Добавить("ГруппаАкции", "Акция");
		НовКолонка.Ширина = 5;
	КонецЕсли;
		
	ГруппыАкций = Новый Соответствие;
	ГруппыАкций.Вставить( 7,	"1+1");
	ГруппыАкций.Вставить( 8,	"2+1");
	ГруппыАкций.Вставить( 9,	"3+1");
	ГруппыАкций.Вставить(10,	"4+1");
	ГруппыАкций.Вставить(11,	"5+1");
	ГруппыАкций.Вставить(13,	"ЛУЧ");
	ГруппыАкций.Вставить(14,	"БКГЛ");
	ГруппыАкций.Вставить(15,	"х3");
	ГруппыАкций.Вставить(16,	"х5");
	ГруппыАкций.Вставить(17,	"х7");
	ГруппыАкций.Вставить(18,	"х10");
	ГруппыАкций.Вставить(20,	"Серт");
	ГруппыАкций.Вставить(21,	"ПП");
	ГруппыАкций.Вставить(22,	"БКГЛ");
	ГруппыАкций.Вставить(23,	"БКГЛ");
	ГруппыАкций.Вставить(25,	"ПП");
	ГруппыАкций.Вставить(27,	"ПП");
	ГруппыАкций.Вставить(29,	"ТП");
	ГруппыАкций.Вставить(30,	"ТП");

//	ГруппыАкций.Вставить(12,	"БН");
	
	ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(ЗаказСсылка, ВерсияДанных);
	Если НЕ ЗначениеЗаполнено(ДанныеЛояльности) Тогда
		Возврат ДанныеЛояльности;
	КонецЕсли;
	Для каждого ТекСтрока Из ДанныеЛояльности.СоставЗаказа Цикл
		Стр = ТабличноеПоле.Найти(ТекСтрока.ИдСтроки, "ИдСтроки");
		Если Стр = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Стр.КГЛНачислено = ТекСтрока.КГЛНачислено;
		//Стр.ГруппаАкцииЙ = ТекСтрока.ГруппаАкции;
		ТекстАкций = ГруппыАкций.Получить(ТекСтрока.ГруппаАкции);
		Стр.ГруппаАкции = ?(ТекстАкций = Неопределено, "", ТекстАкций);
	КонецЦикла; 
	Возврат ДанныеЛояльности;	
КонецФункции

Процедура ОбновитьЭлементыФормы(Форма, ВерсияДанных = "", ДанныеЛояльности = Неопределено) Экспорт
	
	Попытка
		Макет = ПолучитьОбщийМакет("ТабДокЛояльность");
		ОбластьСтрокаКГЛ = Макет.ПолучитьОбласть("СтрокаКГЛ");
		ОбластьСтрокаИтого = Макет.ПолучитьОбласть("СтрокаИтого");
		
		ТабДок = Форма.ЭлементыФормы.ТабДокЛояльность;
		ТабДок.Очистить();
		ТабДокИтоги = Форма.ЭлементыФормы.ТабДокЛояльностьИтоги;
		ТабДокИтоги.Очистить();
		
		ЗаказСсылка = Форма.Заказ.Ссылка;
		НомерКартыЛояльности = ЗаказСсылка.НомерКартыЛояльности;
		//Форма.КупоныСоответствие = Новый Соответствие;
	Исключение
	    НомерКартыЛояльности = "";
	КонецПопытки;
	Попытка
		Форма.КупоныСоответствие = Новый Соответствие;
	Исключение
	    //ОписаниеОшибки()
	КонецПопытки; 
	
	Для Инд = 1 По 6 Цикл
		ТекЭлемент = Форма.ЭлементыФормы["Плашка" + Инд];
		ТекЭлемент.Заголовок = "";
		ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаФормы;
		ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
	КонецЦикла;
	Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = "Здравствуйте, Гость!
	|Нет карты КеГеЛьБУМ.";
	
	Если НЕ ЗначениеЗаполнено(НомерКартыЛояльности) Тогда
		Возврат;
	КонецЕсли;
	
	ДанныеГостя = ЛояльностьКлиентСервер.ПолучитьДанныеГостя(НомерКартыЛояльности, глПараметрыРМ.Тест);
	Если ДанныеГостя.Ошибка Тогда
		Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = "Здравствуйте!";
	Иначе	
		НомерКартыЛояльности = СокрЛП(Формат(ДанныеГостя.НомерКарты, "ЧГ=0"));
		Попытка
			Имя = СтрРазделить(ДанныеГостя.ФИО, " ")[0];
		Исключение
			Имя = "Гость";
		КонецПопытки;
		Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = СтрШаблон("Здравствуйте, %1!
		|Карта %2*****%3", Имя, Лев(НомерКартыЛояльности, 2), Прав(НомерКартыЛояльности, 4));
	КонецЕсли;
	
	Если ДанныеЛояльности = Неопределено Тогда
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(ЗаказСсылка, ВерсияДанных);
	КонецЕсли;
		
	КупоныГостя = ДанныеЛояльности.Купоны;
	Для Сч = 0 По КупоныГостя.ВГраница() Цикл
		Инд = Сч + 1;
		Если Инд > 6 Тогда
			Прервать;
		КонецЕсли;
		ТекЭлемент = Форма.ЭлементыФормы["Плашка" + Инд];
		ТекЭлемент.Заголовок = КупоныГостя[Сч].ИнфоСтанции;
		Если КупоныГостя[Сч].Статус = -1 Тогда
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаФормы;
			ТекЭлемент.ЦветТекстаКнопки = WebЦвета.Красный;
		ИначеЕсли КупоныГостя[Сч].Статус = 0 Тогда
			ТекЭлемент.ЦветФонаКнопки = WebЦвета.Лосось;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупоныГостя[Сч].Статус = 1 Тогда	
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаФормы;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупоныГостя[Сч].Статус = 2 Тогда	
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаОплаченнойСтроки;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		ИначеЕсли КупоныГостя[Сч].Статус = 3 Тогда	
			ТекЭлемент.ЦветФонаКнопки = ЦветаСтиля.НеактивнаяКнопка;
			ТекЭлемент.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопки;
		КонецЕсли;
		
		Попытка
		Форма.КупоныСоответствие.Вставить(Формат(Сч + 1, "ЧДЦ=; ЧГ=0"), КупоныГостя[Сч].Код);
		Исключение
		    //ОписаниеОшибки()
		КонецПопытки; 
	КонецЦикла;
		
	КГЛ = 0;
	Итоги = ДанныеЛояльности.ИтогиМ.КГЛИнфо;
	Для каждого ТекСтрока Из Итоги Цикл
		КГЛ = КГЛ + ТекСтрока.КГЛ;
		Если ТекСтрока.КГЛ > 0 Тогда
			ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
			ТабДок.Вывести(ОбластьСтрокаКГЛ);
		КонецЕсли;
	КонецЦикла;
	Итоги = ДанныеЛояльности.ИтогиО.КГЛИнфо;
	Для каждого ТекСтрока Из Итоги Цикл
		КГЛ = КГЛ + ТекСтрока.КГЛ;
		Если ТекСтрока.КГЛ > 0 Тогда
			ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
			ТабДок.Вывести(ОбластьСтрокаКГЛ);
		КонецЕсли;
	КонецЦикла;
	Итоги = ДанныеЛояльности.ИтогиКП.КГЛИнфо;
	Для каждого ТекСтрока Из Итоги Цикл
		КГЛ = КГЛ + ТекСтрока.КГЛ;
		Если ТекСтрока.КГЛ > 0 Тогда
			ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
			ТабДок.Вывести(ОбластьСтрокаКГЛ);
		КонецЕсли;
	КонецЦикла;
	Если КГЛ > 0 Тогда
		ОбластьСтрокаИтого.Параметры.КГЛ = КГЛ;
		ТабДокИтоги.Вывести(ОбластьСтрокаИтого);
	КонецЕсли;
	
КонецПроцедуры

Функция ВводКартыЛояльности(ЗаказОбъект) Экспорт
	
	Результат = Новый Структура("Ошибка,ТоварКарты", Ложь, Неопределено);
	
	// не спрашиваем, если карта уже привязана
	Если НЕ ПустаяСтрока(ЗаказОбъект.НомерКартыЛояльности) Тогда
		Результат.Ошибка = Истина;
		Возврат Результат;
	КонецЕсли;
	
	// не спрашиваем, если гость ранее уже отказался
	Если ЗаказОбъект.ОтказОтКартыЛояльности > 0 Тогда
		Результат.Ошибка = Истина;
		Возврат Результат;
	КонецЕсли;
	
	//СтруктураЗаказа = Новый Структура;
	//СтруктураЗаказа.Вставить("НомерКартыЛояльности", ЗаказОбъект.НомерКартыЛояльности);
	//ОтветЛояльности = ЛояльностьКлиент.ВвестиКарту(СтруктураЗаказа);
	Если ЛояльностьКлиент.ВвестиКарту(ЗаказОбъект) И НЕ ПустаяСтрока(ЗаказОбъект.НомерКартыЛояльности) Тогда
		
	//	ЗаказОбъект.НомерКартыЛояльности = СтруктураЗаказа.НомерКартыЛояльности;
	//	//ЛояльностьКлиент.ОткрытьЗаказ(ЗаказОбъект);
	//	//ЗаписатьЗаказ(ЗаказОбъект, ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
	//	//Лояльность.ОбновитьПредварительныйРасчетЗаказа(ЗаказОбъект.Ссылка, глПараметрыРМ.Тест);
	//	
	Иначе  
			
		ДисплейИнфо = "";
		
		ОтветГостя1 = ИнтерфейсРМ.ВопросПредупреждение(
			"Заказ открыт!",
			"Давайте приобретем карту КеГеЛьБУМ",
			ДисплейИнфо,
			"Esc=Отказаться",
			"",
			"Купить карту");
			
		Если ОтветГостя1 = "Купить карту" Тогда
				
			Если ЛояльностьКлиент.ВвестиКарту(ЗаказОбъект, "Считайте новую карту КеГеЛьБУМ", Истина) Тогда

				Если НЕ ПустаяСтрока(ЗаказОбъект.НомерКартыЛояльности) Тогда
					// добавление карты в список товаров
					ТоварКарты = ИнтерфейсРМ.НайтиТоварПоКоду(Лояльность.ПолучитьКодТовараКарты(ЛояльностьКлиентСервер.ПолучитьТекущийРегион()));
					
					// товар не найден - выход
					Если ТоварКарты = Справочники.Товары.ПустаяСсылка() Тогда
						ЗаказОбъект.НомерКартыЛояльности = "";
						ИнтерфейсРМ.ВопросПредупреждение("КеГеЛьБУМ","","Не найден товар карты лояльности (код 16020001/16020002)","","Вернуться в чек","");
						ЛояльностьКлиентСервер.Логирование(1, "расчет", "товар карты не найден");
						
						Результат.Ошибка = Истина;
						
					Иначе
						
						Результат.ТоварКарты = ТоварКарты;

					КонецЕсли;
					
					
					//// добавление карты в заказ, если ее там еще нет
					//ЗаписатьЗаказ(ЗаказОбъект, ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
					//СтрокаТЧ = ЗаказОбъект.Товары.Найти(ТоварКарты, "Товар");
					//Если СтрокаТЧ = Неопределено Тогда
					//	ВводНовойСтроки(ТоварКарты);
					//КонецЕсли;
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			ОтветГостя = ИнтерфейсРМ.ВопросПредупреждение(
				"Заказ открыт!",
				"У Вас есть карта КеГеЛьБУМ?",
				"Давайте сразу ее свяжем с Вашим бейджем!
				|Тогда для начисления или списания КеГЛей Вы можете
				|пользоваться только этим бейджем
				|А также Вы сможете воспользоваться
				|своими персональными предложениями!
				|
				|Если Карта предъявлена - прокатайте
				|
				|Если Карты нет - предложите купить, прокатайте и выдайте
				|
				|Если Карта не прокатана, нажмите на одну из кнопок:",
				"Esc=Не хочу приобретать",
				"Забыл карту дома",
				"Позже предъявлю",
				,,,12);
			Если ОтветГостя = "Не хочу приобретать" Тогда
				// больше не спрашивать
				ЗаказОбъект.ОтказОтКартыЛояльности = 1;
			ИначеЕсли ОтветГостя = "Забыл карту дома" Тогда 
				// ПОКА больше не спрашивать
				ЗаказОбъект.ОтказОтКартыЛояльности = 2;
			Иначе
				// спросить позже
				ЗаказОбъект.ОтказОтКартыЛояльности = 0;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли
