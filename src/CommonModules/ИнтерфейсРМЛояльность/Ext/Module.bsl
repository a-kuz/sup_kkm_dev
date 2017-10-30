﻿#Если НЕ ТонкийКлиент Тогда
	
// обработчик события открытия главной формы
//	- прописывает действия плашек лояльности
//	- добавляет необходимые колонки в тпТовары (уже должна существовать на форме)
//
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
		
		Действие = Новый Действие("тпТоварыПриПолученииДанных");
		ТекЭлемент = Форма.ЭлементыФормы.тпТовары;
		ТекЭлемент.УстановитьДействие("ПриПолученииДанных", Действие);
	Исключение
	КонецПопытки;
	
	Попытка
		Форма.ОбработкаОбъект.ГруппыАкций = ПолучитьГруппыАкцийСоответствие();
	Исключение
	КонецПопытки;
	
	ТабличноеПоле = Форма.ЭлементыФормы.тпТовары;
	Если ТабличноеПоле.Колонки.Найти("КГЛ") = Неопределено Тогда
		НовКолонка = ТабличноеПоле.Колонки.Добавить("КГЛ", "КеГЛи");
		НовКолонка.ЦветТекстаПоля = ЦветаСтиля.ЦветТемы;
		НовКолонка.ШрифтТекста = Новый Шрифт(НовКолонка.ШрифтТекста,,,Истина);
		НовКолонка.Ширина = 8;
		НовКолонка.ГоризонтальноеПоложениеВКолонке = ГоризонтальноеПоложение.Право;
	КонецЕсли;
	Если ТабличноеПоле.Колонки.Найти("ГруппаАкции") = Неопределено Тогда
		НовКолонка = ТабличноеПоле.Колонки.Добавить("ГруппаАкции", "Акция");
		НовКолонка.Ширина = 5;
		НовКолонка.КартинкиСтрок = БиблиотекаКартинок.ЛоготипАкций;
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийЭлементовГлавнойФормы

Процедура тпТоварыПриПолученииДанных(Форма, Элемент, ОформленияСтрок, ДанныеЛояльности = Неопределено) Экспорт
	
	ГруппыАкций = Форма.ОбработкаОбъект.ГруппыАкций;
	Если ДанныеЛояльности = Неопределено Тогда
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Форма.Заказ, "");
	КонецЕсли;
	Если ДанныеЛояльности = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		
		ИдСтроки = ОформлениеСтроки.ДанныеСтроки.ИдСтроки;
		ТекГруппаАкции = ОформлениеСтроки.ДанныеСтроки.ЛояльностьГруппаАкции;
		ТекстАкций = ГруппыАкций.Получить(ТекГруппаАкции);
		ТекстАкций = ?(ТекстАкций = Неопределено, "", ТекстАкций);
		ОформлениеСтроки.Ячейки.ГруппаАкции.УстановитьТекст(ТекстАкций);
		
		Если ТекГруппаАкции > 0 Тогда
			ОформлениеСтроки.Ячейки.ГруппаАкции.ОтображатьКартинку = Истина;
			ОформлениеСтроки.Ячейки.ГруппаАкции.ОтображатьТекст = Ложь;
			ОформлениеСтроки.Ячейки.ГруппаАкции.ИндексКартинки = ТекГруппаАкции;	
		Иначе
			ОформлениеСтроки.Ячейки.ГруппаАкции.ОтображатьКартинку = Ложь;
		КонецЕсли;
		
		Для каждого ТекСтрока Из ДанныеЛояльности.СоставЗаказа Цикл
			Если ТекСтрока.ИдСтроки = ИдСтроки Тогда
				ОформлениеСтроки.Ячейки.КГЛ.УстановитьТекст(Формат(ТекСтрока.КГЛНачислено,"ЧН=' '"));
				Прервать;
			КонецЕсли;
		КонецЦикла;
				
	КонецЦикла; 
	
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
	
	ОбработатьВыборКупона(Форма, КодКупона);
	Возврат;
	
	
	Если КодКупона = Неопределено Тогда
		Возврат; // Плашка пустая
	КонецЕсли;
	Если ТипЗнч(Форма.Заказ) = Тип("ДокументСсылка.Заказ") Тогда
		ЗаказОбъект = Форма.Заказ.ПолучитьОбъект();
		ЛояльностьКлиент.ПеренестиКупонВЗаказ(ЗаказОбъект, КодКупона);
		Форма.ОбработкаОбъект.ЗаписатьЗаказ(ЗаказОбъект, ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
	ИначеЕсли ТипЗнч(Форма.Заказ) = Тип("ДокументОбъект.Заказ") Тогда
		ЗаказОбъект = Форма.Заказ;
		ЛояльностьКлиент.ПеренестиКупонВЗаказ(ЗаказОбъект, КодКупона);
		Форма.ОбработкаОбъект.ЗаписатьЗаказ(ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
		Форма.ОбработкаОбъект.ПрочитатьТекущийДокумент();
		ОбновитьТабДокЛояльность(Форма, ""); // Если передать пустую строку в версию - лояльность обновит расчет
		ОбновитьКупоны(Форма);
	КонецЕсли;
	
КонецПроцедуры

// кнопки с 7 по 11
Процедура Плашка_Н_Нажатие(Форма, Элемент) Экспорт 
	Выполнить("" + Элемент.Имя + "Нажатие(Форма, Элемент);"); 
КонецПроцедуры

Процедура Плашка7Нажатие(Форма, Элемент)

	Попытка
		//ЗаказСсылка = Форма.Заказ.Ссылка;
		ЛояльностьДанныеЗаказа = Форма.ОбработкаОбъект.ЛояльностьДанныеЗаказа;
	Исключение
	    Возврат;
	КонецПопытки;
	
	Параметры = Новый Структура;
	Параметры.Вставить("ДанныеЛояльности", ЛояльностьДанныеЗаказа);
	КодКупона = ОткрытьФормуМодально("Обработка.ОбработкаЛояльности.Форма.СписокАкцийИПП", Параметры, Форма);
	
	ОбработатьВыборКупона(Форма, КодКупона);
	
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
	//Лояльность.ОбновитьПредварительныйРасчетЗаказа(ЗаказСсылка, глПараметрыРМ.Тест);
	ОбновитьТабДокЛояльность(Форма, ""); // Если передать пустую строку в версию - лояльность обновит расчет
	ОбновитьКупоны(Форма);
	Форма.ОбновитьНадписьИтого();
	
КонецПроцедуры
Процедура Плашка10Нажатие(Форма, Элемент)
		
КонецПроцедуры
Процедура Плашка11Нажатие(Форма, Элемент)
		
КонецПроцедуры

Процедура ОбработатьВыборКупона(Форма, КодКупона)
	
	Если КодКупона = Неопределено Тогда
		Возврат; // Плашка пустая
	КонецЕсли;
	
	Если ТипЗнч(Форма.Заказ) = Тип("ДокументСсылка.Заказ") Тогда
		ЗаказОбъект = Форма.Заказ.ПолучитьОбъект();
		ЛояльностьКлиент.ПеренестиКупонВЗаказ(ЗаказОбъект, КодКупона);
		Форма.ОбработкаОбъект.ЗаписатьЗаказ(ЗаказОбъект, ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
	ИначеЕсли ТипЗнч(Форма.Заказ) = Тип("ДокументОбъект.Заказ") Тогда
		ЗаказОбъект = Форма.Заказ;
		ЛояльностьКлиент.ПеренестиКупонВЗаказ(ЗаказОбъект, КодКупона);
		Форма.ОбработкаОбъект.ЗаписатьЗаказ(ПредопределенноеЗначение("Перечисление.СтатусыЗаказа.Открыт"));
		Форма.ОбработкаОбъект.ПрочитатьТекущийДокумент();
		ОбновитьТабДокЛояльность(Форма, ""); // Если передать пустую строку в версию - лояльность обновит расчет
		ОбновитьКупоны(Форма);
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти

// обновляет элемент формы НадписьЛояльность1
//
Процедура ОбновитьНадписьПриветствие(Форма, ВерсияДанных = Неопределено) Экспорт 
	
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
		Если ЗначениеЗаполнено(НомерКартыЛояльности) Тогда
			Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = СтрШаблон("Здравствуйте, %1!
			|Карта %2*****%3", Имя, Лев(НомерКартыЛояльности, 2), Прав(НомерКартыЛояльности, 4));
		Иначе
			Форма.ЭлементыФормы.НадписьЛояльность1.Заголовок = "Здравствуйте, Гость!
			|Нет карты КеГеЛьБУМ.";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// обновляет заголовки плашек с купонами
//
Процедура ОбновитьКупоны(Форма, ВерсияДанных = Неопределено, ДанныеЛояльности = Неопределено) Экспорт 
	
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
	
	Форма.ЭлементыФормы.Плашка7.ЦветФонаКнопки = ЦветаСтиля.ЦветТемы;

	Если НЕ ЗначениеЗаполнено(НомерКартыЛояльности) Тогда
		Возврат;
	КонецЕсли;
	
	Если ДанныеЛояльности = Неопределено Тогда
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Форма.Заказ, ВерсияДанных);
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
			ТекЭлемент.ЦветТекстаКнопки = WebЦвета.Черный;
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
	
	Если КупоныГостя.Количество() > 6 Тогда
		Форма.ЭлементыФормы.Плашка7.ЦветФонаКнопки = ЦветаСтиля.Акцент;
	КонецЕсли;
	
КонецПроцедуры

// обновляет элементы главной формы ТабДокЛояльность и ТабДокЛояльностьИтоги
//
Процедура ОбновитьТабДокЛояльность(Форма, ВерсияДанных = Неопределено, ДанныеЛояльности = Неопределено) Экспорт 
	
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
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Форма.Заказ, ВерсияДанных);
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

// выполняет все действия предшествующих трех процедур:
//	- обновляет элемент формы НадписьЛояльность1
//	- обновляет заголовки плашек с купонами
//	- обновляет элементы главной формы ТабДокЛояльность и ТабДокЛояльностьИтоги
//
Процедура ОбновитьЭлементыФормы(Форма, ВерсияДанных = Неопределено, ДанныеЛояльности = Неопределено) Экспорт
	
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
	Форма.ЭлементыФормы.Плашка7.ЦветФонаКнопки = ЦветаСтиля.ЦветТемы;
	
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
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Форма.Заказ, ВерсияДанных);
	КонецЕсли;
		
	КупоныГостя = ДанныеЛояльности.Купоны;
	Для Сч = 0 По КупоныГостя.ВГраница() Цикл
		Инд = Сч + 1;
		Если Инд > 6 Тогда
			Прервать;
		КонецЕсли;
		ТекЭлемент = Форма.ЭлементыФормы["Плашка" + Инд];
		ТекЭлемент.Заголовок = КупоныГостя[Сч].ИнфоСтанции;
		//ТекЭлемент.Видимость = Истина;
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
			ТекЭлемент.ЦветТекстаКнопки = WebЦвета.Черный;
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
	
	Если КупоныГостя.Количество() > 6 Тогда
		Форма.ЭлементыФормы.Плашка7.ЦветФонаКнопки = ЦветаСтиля.Акцент;
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

Функция ОткрытьМенюЛояльности() Экспорт
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ
	|	МенюЛояльности.Ссылка КАК Ссылка,
	|	ВЫБОР МенюЛояльности.Станция
	|		КОГДА ЗНАЧЕНИЕ(Справочник.МенюЛояльности.ПустаяСсылка)
	|			ТОГДА 1
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ДляВсехСтанций
	|ИЗ
	|	Справочник.МенюЛояльности КАК МенюЛояльности
	|ГДЕ
	|	МенюЛояльности.Регион = &Регион
	|	И МенюЛояльности.ТипТТ = &ТипТТ
	|	И (МенюЛояльности.Станция = &Станция
	|			ИЛИ МенюЛояльности.Станция = ЗНАЧЕНИЕ(Справочник.МенюЛояльности.ПустаяСсылка))
	|	И (МенюЛояльности.ДатаНачалаДействия <= &ТекДата
	|			ИЛИ МенюЛояльности.ДатаНачалаДействия = ДАТАВРЕМЯ(1, 1, 1))
	|	И (МенюЛояльности.ДатаОкончанияДействия >= &ТекДата
	|			ИЛИ МенюЛояльности.ДатаОкончанияДействия = ДАТАВРЕМЯ(1, 1, 1))
	|	И НЕ МенюЛояльности.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ДляВсехСтанций,
	|	МенюЛояльности.ДатаНачалаДействия УБЫВ");
	Запрос.УстановитьПараметр("Станция", глПараметрыРМ.Станция);
	Запрос.УстановитьПараметр("ТекДата", НачалоДня(ТекущаяДатаНаСервере()));
	Запрос.УстановитьПараметр("Регион", глПараметрыРМ.ИнформационнаяБаза.Регион);
	Запрос.УстановитьПараметр("ТипТТ", глПараметрыРМ.Фирма.ТипТТ);
	Рез =  Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка","","Настройка меню с таким сочетанием региона, станции и места реализации не задана!","","ОК","");
		
		Возврат Неопределено;
	КонецЕсли;
	
	Форма = Рез.Выгрузить()[0][0].ПолучитьФорму();
	РезультатОткрытия = Форма.ОткрытьМодально();
	Возврат	РезультатОткрытия;
КонецФункции

// Получает текстовые представления акций
// используется в тестовых целях
//
Функция ПолучитьГруппыАкцийСоответствие()
	
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

	Возврат ГруппыАкций;
	
КонецФункции

// Формирует табличный документ с данными лояльности
// для вывода на мониторе гостя
//
Функция ПолучитьТабДокЛояльность_МониторГостя(ЗаказСсылка, ВерсияДанных = Неопределено, ДанныеЛояльности = Неопределено) Экспорт
	
	ТабДок = Новый ТабличныйДокумент;
	
	Попытка
		НомерКартыЛояльности = ЗаказСсылка.НомерКартыЛояльности;
	Исключение
	    НомерКартыЛояльности = Неопределено;
	КонецПопытки;
	Попытка
		Макет = ПолучитьОбщийМакет("ИД_Лояльность361х1024");
	Исключение
	    Возврат ТабДок;
	КонецПопытки;
	
	Если НЕ ЗначениеЗаполнено(НомерКартыЛояльности) Тогда
		//ТабДок.Вывести(Макет.ПолучитьОбласть("НетКарты"));
		Возврат ТабДок;
	КонецЕсли;
	
	// Приветствие
	ДанныеГостя = ЛояльностьКлиентСервер.ПолучитьДанныеГостя(НомерКартыЛояльности, глПараметрыРМ.Тест);
	ДоброПожаловать = "Добро пожаловать в КуулКЛЕВЕР!";
	Если НЕ ДанныеГостя.Ошибка  Тогда
		//////Если НЕ ПустаяСтрока(ДанныеГостя.ФИО) Тогда 
		//////	Имя = СтрРазделить(ДанныеГостя.ФИО, " ")[0];
		//////	ДоброПожаловать = Имя + ", добро пожаловать в КуулКЛЕВЕР!";	
		//////КонецЕсли;
		НомерКартыЛояльности = СокрЛП(Формат(ДанныеГостя.НомерКарты, "ЧГ=0"));
	КонецЕсли;
	ОблМакета = Макет.ПолучитьОбласть("Шапка");
	ОблМакета.Параметры.ДоброПожаловать = ДоброПожаловать;
	ОблМакета.Параметры.НомерКартыЛояльности = СтрШаблон("%1*****%2", Лев(НомерКартыЛояльности, 2), Прав(НомерКартыЛояльности, 3));
	ТабДок.Вывести(ОблМакета);
	
	Если ДанныеЛояльности = Неопределено Тогда
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(ЗаказСсылка, ВерсияДанных);
	КонецЕсли;
	
	// Купоны
	ВыведеноКупонов = 0;
	КупоныГостя = ДанныеЛояльности.Купоны;
	Для Сч = 0 По КупоныГостя.ВГраница() Цикл
		ТекСтатус = КупоныГостя[Сч].Статус;
		
		Если ТекСтатус < 0 ИЛИ ТекСтатус > 2 Тогда
			Продолжить;
		КонецЕсли;
		
		ОблМакета = Макет.ПолучитьОбласть("КупонСтатус" + ТекСтатус);
		ОблМакета.Параметры.ИнфоГостя = КупоныГостя[Сч].ИнфоГостя;
		ТабДок.Вывести(ОблМакета);
		ВыведеноКупонов = ВыведеноКупонов + 1;
		Если ВыведеноКупонов = 6 Тогда
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если ВыведеноКупонов < 6 Тогда
		ОблМакета = Макет.ПолучитьОбласть("КупонПустой");
		Для Сч = ВыведеноКупонов + 1 По 6 Цикл
			ТабДок.Вывести(ОблМакета);
		КонецЦикла;
	КонецЕсли;
	
	// ЛУЧ
	ОблМакета = Макет.ПолучитьОбласть("ЛУЧ");
	ОблМакета.Параметры.Текст = "";
	ТабДок.Вывести(ОблМакета);
	
	// Итоги
	ОблМакета = Макет.ПолучитьОбласть("ИтогиШапка");
	ОблМакета.Параметры.КГЛ = ДанныеЛояльности.КГЛНачислено;
	ТабДок.Вывести(ОблМакета);
	
	// говнокодим обход фирм
	ВыведеноСтрок = 0; // из 8
	ОбходФирм = Новый Массив;
	ОбходФирм.Добавить("ИтогиМ");
	ОбходФирм.Добавить("ИтогиО");
	ОбходФирм.Добавить("ИтогиКП");
	
	ТекФирма = "Итоги" +  ВРег(Лев(глПараметрыРМ.Фирма, 1));
	ТекФирма = ?(ТекФирма = "ИтогиК", "ИтогиКП", ТекФирма);
	ОбходФирм.Удалить(ОбходФирм.Найти(ТекФирма));
	
	ТекФирмаИмя = ?(ТекФирма = "ИтогиМ", "МясновЪ", ?(ТекФирма = "ИтогиО", "ОТДОХНИ", "Кухне Полли"));
	
	ТекИтоги = ДанныеЛояльности[ТекФирма];
	ВывестиСтрокуИтогов(ТабДок, Макет, ВыведеноСтрок, "Будет начислено в " + ТекФирмаИмя, ТекИтоги.КГЛНачислено, Истина);
	
	Для каждого ТекСтрока Из ТекИтоги.КГЛИнфо Цикл
		ВывестиСтрокуИтогов(ТабДок, Макет, ВыведеноСтрок, ТекСтрока.Текст, ТекСтрока.КГЛ);
	КонецЦикла;
	
	//Если ВыведеноСтрок < 7 Тогда
		Пока ВыведеноСтрок < 6 Цикл
			ВывестиСтрокуИтогов(ТабДок, Макет, ВыведеноСтрок);
		КонецЦикла;
	//КонецЕсли;
	
	Для каждого ТекФирма Из ОбходФирм Цикл
		ТекИтоги = ДанныеЛояльности[ТекФирма];
		Если ТекИтоги.КГЛНачислено Тогда
			ТекФирмаИмя = ?(ТекФирма = "ИтогиМ", "МясновЪ", ?(ТекФирма = "ИтогиО", "ОТДОХНИ", "Кухне Полли"));
			ВывестиСтрокуИтогов(ТабДок, Макет, ВыведеноСтрок, "Начислено в " + ТекФирмаИмя, ТекИтоги.КГЛНачислено, Истина);
		Иначе
			ВывестиСтрокуИтогов(ТабДок, Макет, ВыведеноСтрок);
		КонецЕсли;
	КонецЦикла;

	Возврат ТабДок;
		
КонецФункции

Процедура ВывестиСтрокуИтогов(ТабДок, Макет, ВыведеноСтрок, Знач Текст = "", КГЛ = 0, Итоги = Ложь)
	
	Если НЕ Итоги И НЕ Текст = "" Тогда
		Текст = Лев(Текст, СтрДлина(Текст) - 2);
	КонецЕсли;
	
	СтруктураПараметров = Новый Структура("Текст,КГЛ", Текст, КГЛ);
	Если Итоги Тогда
		ИмяОбласти = "ИтогиМР";
	ИначеЕсли НЕ КГЛ = 0 Тогда 	
		ИмяОбласти = "ИтогиДетально";
	ИначеЕсли Текст = "" Тогда
		ИмяОбласти = "ИтогиПустаяСтрока";
	Иначе	
		ИмяОбласти = "ИтогиДетально0";
	КонецЕсли;
	ОблМакета = Макет.ПолучитьОбласть(ИмяОбласти);
	ОблМакета.Параметры.Заполнить(СтруктураПараметров);
	ТабДок.Вывести(ОблМакета);
	
	ВыведеноСтрок = ВыведеноСтрок + 1;
	
КонецПроцедуры

Функция СформироватьУрлТовараДляМонитораГостя(ТоварСсылка, Цена = 0, КГЛ = 0) Экспорт 

	Если ТоварСсылка.Пустая() Тогда
		Возврат "";
	КонецЕсли;
	
	ИД = "0000000000000000";
	Регион = ЛояльностьКлиентСервер.ПолучитьТекущийРегионСтрокой();

	Если Регион = "52" Тогда
		ИД = ТоварСсылка.Номенклатура.КодСУП + "00000000";
	ИначеЕсли Регион = "77" Тогда
		ИД = "00000000" + ТоварСсылка.Номенклатура.КодСУП;
	КонецЕсли;
	
	УРЛ = СтрШаблон("https://www.kegelbum.ru/getinfo/?id=%1&price=%2&kgl=%3", ИД, Формат(Цена, "ЧДЦ=2; ЧН=0.00; ЧГ=0"), Формат(КГЛ, "ЧДЦ=; ЧН=0; ЧГ=0"));
	
	Возврат УРЛ;
	
КонецФункции

Процедура ПоказатьИнформациюОТоваре(Товар, ЛояльностьДанныеЗаказа = Неопределено, ИдСтроки = "") Экспорт 
	Обработка = ИнтерфейсРМ.ПолучитьОбъектОбработки("ИнформацияОтоваре");
	//: Обработка = Обработки.ИнформацияОтоваре.Создать();
	Обработка.Товар = Товар;
	
	Если ЗначениеЗаполнено(ИдСтроки) 
		И ТипЗнч(ЛояльностьДанныеЗаказа) = Тип("Структура") 
		И ЛояльностьДанныеЗаказа.Свойство("СоставЗаказа") 
		И ТипЗнч(ЛояльностьДанныеЗаказа.СоставЗаказа) = Тип("Массив")
		Тогда
		
		Для каждого ТекСтрокаСостава Из ЛояльностьДанныеЗаказа.СоставЗаказа Цикл
			Если ТекСтрокаСостава.ИдСтроки = ИдСтроки Тогда
				Обработка.Цена = ТекСтрокаСостава.ЦенаФакт;
				Обработка.КГЛ = ТекСтрокаСостава.КГЛНачислено;
				Прервать;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Обработка.ПолучитьФорму().ОткрытьМодально();
КонецПроцедуры


#Область УДАЛИТЬ

Функция ОбновитьТовары(Форма, ВерсияДанных = Неопределено, ТабличноеПоле = Неопределено) Экспорт 
	
	Возврат ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Форма.Заказ, ВерсияДанных);
	//ОбнТов
	
	
	
	Попытка
		ЗаказСсылка = Форма.Заказ.Ссылка;
	Исключение
	    Возврат Неопределено;
	КонецПопытки;

	Если ТабличноеПоле = Неопределено ИЛИ НЕ ТипЗнч(ТабличноеПоле) = Тип("ТаблицаЗначений") Тогда
		Возврат ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Форма.Заказ, ВерсияДанных); 
	КонецЕсли;
	
	Если ТабличноеПоле.Колонки.Найти("КГЛ") = Неопределено Тогда
		НовКолонка = ТабличноеПоле.Колонки.Добавить("КГЛ", "КеГЛи");
		НовКолонка.ЦветТекстаПоля = ЦветаСтиля.ЦветТемы;
		НовКолонка.ШрифтТекста = Новый Шрифт(НовКолонка.ШрифтТекста,,,Истина);
		НовКолонка.Ширина = 8;
	КонецЕсли;
	Если ТабличноеПоле.Колонки.Найти("ГруппаАкции") = Неопределено Тогда
		НовКолонка = ТабличноеПоле.Колонки.Добавить("ГруппаАкции", "Акция");
		НовКолонка.Ширина = 5;
	КонецЕсли;
	
	ГруппыАкций = ПолучитьГруппыАкцийСоответствие();
	
	ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Форма.Заказ, ВерсияДанных);
	Если НЕ ЗначениеЗаполнено(ДанныеЛояльности) Тогда
		Возврат ДанныеЛояльности;
	КонецЕсли;
	Для каждого ТекСтрока Из ДанныеЛояльности.СоставЗаказа Цикл
		Стр = ТабличноеПоле.Найти(ТекСтрока.ИдСтроки, "ИдСтроки");
		Если Стр = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Стр.КГЛ = ТекСтрока.КГЛНачислено;
		//Стр.ГруппаАкцииЙ = ТекСтрока.ГруппаАкции;
		ТекстАкций = ГруппыАкций.Получить(ТекСтрока.ГруппаАкции);
		Стр.ГруппаАкции = ?(ТекстАкций = Неопределено, "", ТекстАкций);
	КонецЦикла; 
	Возврат ДанныеЛояльности;	
КонецФункции

#КонецОбласти

#КонецЕсли
