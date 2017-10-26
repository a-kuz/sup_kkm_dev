﻿#Область ОписаниеПеременных

&НаСервере	
Перем ДисплейИнфо;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "КОплате,НачислениеНачисление,НачислениеОплата,СписаниеНачисление,СписаниеОплата,СписаниеСписание,НадписьКартаЛОЛ,ПИН_Хэш,НомерКартыЛояльности,НомерТелефона,НомерЗаказа,РабочееМесто,Баланс");
	ДисплейИнфо = Параметры.ДисплейИнфо;
	
	Параметры.ПоказатьТаблицуТовары = Истина;
	
	СписаниеВозможно = СписаниеСписание > 0;
	ТипЧекаЛояльность = 1;
	ПИН_Нужен = Параметры.ПИН_Нужен = 1;
	НадписьБаланс = Новый ФорматированнаяСтрока(Формат(Параметры.Баланс, "ЧДЦ=; ЧН=") + " КеГЛей");
	//Элементы.ПоказатьБаланс.Видимость = Параметры.Баланс <> 0;
	
	//Элементы.ЗаказПодробно.Видимость = НЕ Параметры.ПоказатьТаблицуТовары;
	//Элементы.Подробно.Видимость = НЕ Параметры.ПоказатьТаблицуТовары;
	Элементы.ГруппаТаблицаСкролл.Видимость = Параметры.ПоказатьТаблицуТовары;
		
	МассивСтрокТоваров = Параметры.ТаблицаТовары; 
	//:МассивСтрокТоваров = Новый Массив;
	Для каждого ТекСтрока Из МассивСтрокТоваров Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаТовары.Добавить(), ТекСтрока);
	КонецЦикла;
	
	ОбновитьОтображениеЭлементовДляМестаРеализации(РабочееМесто.МестоРеализации, СписаниеВозможно, РабочееМесто.Фирма.ТипТТ);	
	
	Если РабочееМесто.Фирма.ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.Ресторан") Тогда
		ПИН_Нужен = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	глОтсечкаПростоя();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ГлавнаяФормаАК_СбросЗаказаСоСтандартнойКассы" Тогда
		Если (Параметр = глРабочееМесто ИЛИ СокрЛП(Параметр) = СокрЛП(глРабочееМесто.ПрофильВхода)) И Открыта() Тогда
			Закрыть(Неопределено);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицаТовары

&НаКлиенте
Процедура ТаблицаТоварыПриАктивизацииСтроки(Элемент)
	глОтсечкаПростоя();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	Закрыть(СтруктураРезультата(-1));
	
КонецПроцедуры

&НаКлиенте
Процедура Подробно(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	глОтсечкаПростоя();
	
	Элементы.ГруппаТаблицаСкролл.Видимость = Истина;
	Элементы.Подробно.Видимость = Ложь;
	
	//Элементы.ТаблицаТовары.ВыделенныеСтроки.Очистить();
	//ТекущийЭлемент = Элементы.ОплатитьВсеСНачислением;
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВсеСНачислением(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	глОтсечкаПростоя();
	ТипЧекаЛояльность = 1;
	Закрыть(СтруктураРезультата(1));
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВсеСоСписанием(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	глОтсечкаПростоя();
	Если ПИН_Нужен Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НомерТелефона", НомерТелефона); 
		ПараметрыФормы.Вставить("ВидРезультата", 1);
		ПараметрыФормы.Вставить("ДлинаПоля", 4);
		ПараметрыФормы.Вставить("РежимПароля", Истина);
		ПараметрыФормы.Вставить("ЗаголовокНадписиВведитеНомер", "Введите Код защиты для карты ****" + Прав(НомерКартыЛояльности, 4));
		ПараметрыФормы.Вставить("РабочееМесто",РабочееМесто);
//УДАЛИТЬ		ПараметрыФормы.Вставить("ДекорацияКеглиРубли", Элементы.ДекорацияКегли.Заголовок);
		ПараметрыФормы.Вставить("ПодвалКеглиРубли", ПолучитьТабДокПодписьКнопки("КеГЛи"));
		
		ДополнительныеПараметры = Новый Структура;
		ДополнительныеПараметры.Вставить("ПараметрыФормы", ПараметрыФормы);
		ДополнительныеПараметры.Вставить("НомерЗапроса", 1);

		ОткрытьФорму("Обработка.ГлавнаяФормаАК.Форма.ВводЧисла", ПараметрыФормы, ЭтотОбъект, , , , Новый ОписаниеОповещения("ОбрабокаЗакрытияФормыВводЧисла", ЭтотОбъект, ДополнительныеПараметры));
	Иначе
		ТипЧекаЛояльность = 2;
		Закрыть(СтруктураРезультата(2));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбрабокаЗакрытияФормыВводЧисла(Результат, ДополнительныеПараметры) Экспорт 
	
	глОтсечкаПростоя();
	
	Если Результат = Неопределено Тогда
		// по таймауту
		Возврат;
		//Закрыть(СтруктураРезультата(-1));
	КонецЕсли;
	
	Если Результат.Ошибка = -2 Тогда
		// переиграли. назад - значит назад
		
		
	ИначеЕсли Результат.Ошибка = -1 Тогда
		// нажали назад (продолжить с начислением)
		ОткрытьФормуМодально("Обработка.ГлавнаяФормаАК.Форма.ФормаОшибка", Новый Структура("ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", "Действие отменено.", "Будет произведена оплата с начислением КеГЛей.", ""), ЭтаФорма);
		
		ТипЧекаЛояльность = 1;
		Закрыть(СтруктураРезультата(1));
		
	ИначеЕсли ПроверитьХЭШНаСервере(Результат.ЗначениеВвода) Тогда
		// ПИН корректен
		НомерТелефона = Результат.НомерТелефона;
		ТипЧекаЛояльность = 2;
		Закрыть(СтруктураРезультата(2));
			
	ИначеЕсли ДополнительныеПараметры.НомерЗапроса < 3 Тогда
		
		ОткрытьФормуМодально("Обработка.ГлавнаяФормаАК.Форма.ФормаОшибка", Новый Структура("ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", "Не правильно введен Код защиты!", СтрШаблон("Попытка %1 из 3...", ДополнительныеПараметры.НомерЗапроса), ""), ЭтаФорма);
		
		ДополнительныеПараметры.Вставить("НомерЗапроса", ДополнительныеПараметры.НомерЗапроса + 1);
		ОткрытьФорму("Обработка.ГлавнаяФормаАК.Форма.ВводЧисла", ДополнительныеПараметры.ПараметрыФормы, ЭтотОбъект, , , , Новый ОписаниеОповещения("ОбрабокаЗакрытияФормыВводЧисла", ЭтотОбъект, ДополнительныеПараметры));
		
	Иначе
		// 3 раза не тот ПИН - продолжаем с начислением
		ОткрытьФормуМодально("Обработка.ГлавнаяФормаАК.Форма.ФормаОшибка", Новый Структура("ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", "Не правильно введен Код защиты!", "Будет произведена оплата с начислением КеГЛей.", ""), ЭтаФорма);
		
		ТипЧекаЛояльность = 1;
		Закрыть(СтруктураРезультата(1));
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьОтдельно(Команда)
	
	глОтсечкаПростоя();
	Закрыть(СтруктураРезультата(0));
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьБаланс(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	глОтсечкаПростоя();
	Если Элементы.ПоказатьБаланс.Заголовок = ПоказатьБалансЗаголовок Тогда
		Элементы.ПоказатьБаланс.Заголовок = НадписьБаланс;
	Иначе
		Элементы.ПоказатьБаланс.Заголовок = ПоказатьБалансЗаголовок;
	КонецЕсли;
	ОбновитьПодписиКнопок();
	
КонецПроцедуры

&НаКлиенте
Процедура СкроллВверх(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	глОтсечкаПростоя();
	Если Элементы.ТаблицаТовары.ТекущаяСтрока > 0 Тогда
		Элементы.ТаблицаТовары.ТекущаяСтрока = Элементы.ТаблицаТовары.ТекущаяСтрока - 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкроллВниз(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	глОтсечкаПростоя();
	Если Элементы.ТаблицаТовары.ТекущаяСтрока < ТаблицаТовары.Количество() - 1  Тогда
		Элементы.ТаблицаТовары.ТекущаяСтрока = Элементы.ТаблицаТовары.ТекущаяСтрока + 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// ВыбранныйВариант : -1 = ничего не выбрано, отмена; 1 = все с начислением; 2 = все со списанием; 0 = по одному
&НаКлиенте
Функция СтруктураРезультата(ВыбранныйВариант = -1)
	
	Если ВыбранныйВариант = 1 Тогда
//УДАЛИТЬ		ДекорацияКеглиРубли = Элементы.ДекорацияРубли.Заголовок;
		ПодвалКеглиРубли = ПолучитьТабДокПодписьКнопки("Рубли");
	ИначеЕсли ВыбранныйВариант = 2 Тогда
//УДАЛИТЬ		ДекорацияКеглиРубли = Элементы.ДекорацияКегли.Заголовок;
		ПодвалКеглиРубли = ПолучитьТабДокПодписьКнопки("КеГЛи");
	Иначе
//УДАЛИТЬ		ДекорацияКеглиРубли = "";
		ПодвалКеглиРубли = Новый ТабличныйДокумент;
	КонецЕсли;
//УДАЛИТЬ	Возврат Новый Структура("ВариантОплаты,ТипЧекаЛояльность,НомерТелефона,КОплате,ДекорацияКеглиРубли,ПодвалКеглиРубли", ВыбранныйВариант, ТипЧекаЛояльность, НомерТелефона, ?(ВыбранныйВариант = 2, СписаниеОплата, КОплате), ДекорацияКеглиРубли, ПодвалКеглиРубли);
	Возврат Новый Структура("ВариантОплаты,ТипЧекаЛояльность,НомерТелефона,КОплате,ПодвалКеглиРубли", ВыбранныйВариант, ТипЧекаЛояльность, НомерТелефона, ?(ВыбранныйВариант = 2, СписаниеОплата, КОплате), ПодвалКеглиРубли);
	
КонецФункции

&НаСервере
Функция ПроверитьХЭШНаСервере(ПИН)
	
	Возврат Лояльность.MD5ХешСтрока(ПИН) = ПИН_Хэш;
	
КонецФункции

&НаКлиенте
Процедура ОбождатьМиллисекунд(Миллисекунды = 5000)
	
	Дедлайн = ТекущаяУниверсальнаяДатаВМиллисекундах() + Миллисекунды;
	Пока ТекущаяУниверсальнаяДатаВМиллисекундах() < Дедлайн Цикл
			
	КонецЦикла;
	
КонецПроцедуры


&НаСервере
Процедура ОбновитьОтображениеЭлементовДляМестаРеализации(МестоРеализации, СписаниеВозможно, ТипТТ = Неопределено)
	
	Если ТипТТ = Неопределено Тогда
		ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.КМ");
	КонецЕсли;
	
	// блок Общий
	
	ПоказатьБалансЗаголовок = "Показать баланс карты КеГеЛьБУМ";
	Элементы.ПоказатьБаланс.Заголовок = ПоказатьБалансЗаголовок;
	
	// блок Кухни Полли
	Если ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.Ресторан") Тогда
		
		Элементы.ЛогоККГурмэ.Картинка = БиблиотекаКартинок.ЛогоКухняПолли;

//УДАЛИТЬ		Элементы.ГруппаСтрокаСостояния.Видимость = Истина;
		
		Элементы.ПоказатьБаланс.Видимость = НЕ ПустаяСтрока(Параметры.НомерКартыЛояльности);
		
//УДАЛИТЬ		Элементы.НадписьСписокКОплате.Заголовок = Новый ФорматированнаяСтрока("К ОПЛАТЕ: " + Формат(КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381));
		
		//Элементы.НадписьЗдравствуйте.Заголовок = "Здравствуйте, " + ?(ПустаяСтрока(Параметры.ФИО), "Гость", Параметры.ФИО) + "!" + Символы.ПС + "ВЫБЕРИТЕ СПОСОБ ОПЛАТЫ:";
		Элементы.НадписьЗдравствуйте.Заголовок = "Выберите способ оплаты:";
		//Элементы.НадписьЗдравствуйте.ЦветТекста = ЦветаСтиля.ЦветТемы;
		Элементы.НадписьЗдравствуйте.Шрифт = Новый Шрифт(Элементы.НадписьЗдравствуйте.Шрифт, , 22);
		
		Если ПустаяСтрока(НомерКартыЛояльности) ИЛИ НЕ СписаниеВозможно Тогда
			Элементы.СписатьКегли.Доступность = Ложь;
			Элементы.СписатьКегли.ЦветТекста = WebЦвета.ТемноСерый;
			Элементы.СписатьКегли.ЦветРамки = WebЦвета.ТемноСерый;
//УДАЛИТЬ			ЗаголовокКегли = "для владельцев карты КеГеЛьБУМ";
//УДАЛИТЬ		Иначе
//УДАЛИТЬ			ЗаголовокКегли = "списать" + Символы.ПС + 
//УДАЛИТЬ			"Будет списано: " + Формат(СписаниеСписание, "ЧДЦ=; ЧГ=3,0") + " КГЛ" + Символы.ПС;
		КонецЕсли;
		
//УДАЛИТЬ		Если СписаниеОплата <> 0 Тогда
//УДАЛИТЬ			ЗаголовокКегли = ЗаголовокКегли + "Доплата: " + Формат(СписаниеОплата, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
//УДАЛИТЬ		КонецЕсли;
	
//УДАЛИТЬ		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
//УДАЛИТЬ			ЗаголовокРубли = "банковская карта" + Символы.ПС + 
//УДАЛИТЬ			"К оплате: " + Формат(КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
//УДАЛИТЬ		Иначе
//УДАЛИТЬ			ЗаголовокРубли = "банковская карта" + Символы.ПС + 
//УДАЛИТЬ			"К оплате: " + Формат(НачислениеОплата, "ЧДЦ=2; ЧГ=3,0") + Символ(8381) + Символы.ПС +
//УДАЛИТЬ			"Будет начислено " + Формат(НачислениеНачисление, "ЧДЦ=; ЧГ=3,0") + " КГЛ";
//УДАЛИТЬ		КонецЕсли;
		
		ОбновитьТабДокСписокОплаты();
//УДАЛИТЬ		Элементы.НадписьСписокКОплате.Видимость = Ложь;
//УДАЛИТЬ		Элементы.ДекорацияКегли.Видимость = Ложь;
//УДАЛИТЬ		Элементы.ДекорацияРубли.Видимость = Ложь;
		
		ОбновитьПодписиКнопок();
		
		Элементы.СписатьКегли.Отображение = ОтображениеКнопки.Текст;
		Элементы.НачислитьКегли.Отображение = ОтображениеКнопки.Текст;
		
	КонецЕсли;
	
	// блок Классного магазина
	Если ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.КМ") Тогда
		// шапка
		
//УДАЛИТЬ		Элементы.ГруппаСтрокаСостояния.Видимость = Истина;
		
		Элементы.ПоказатьБаланс.Доступность = НЕ ПустаяСтрока(Параметры.НомерКартыЛояльности);
		
		// товары
		
		// надписи
		Элементы.НадписьЗдравствуйте.Заголовок = "Выберите способ оплаты:";
		Элементы.НадписьЗдравствуйте.ЦветТекста = ЦветаСтиля.ЦветТемы;
		Элементы.НадписьЗдравствуйте.Шрифт = Новый Шрифт(Элементы.НадписьЗдравствуйте.Шрифт, , 22);
		
//УДАЛИТЬ		НадписьСписокКОплате = Новый Массив;
//УДАЛИТЬ		МестаРеализации = ТаблицаТовары.Выгрузить(, "Фирма, ККМ, КОплате, СуммаРеализации");
//УДАЛИТЬ		МестаРеализации.Свернуть("Фирма,ККМ", "КОплате,СуммаРеализации");
//УДАЛИТЬ		Для каждого ТекСтрока Из МестаРеализации Цикл
//УДАЛИТЬ			ФирмаКратко = Лев(СокрЛП(ТекСтрока.Фирма), 7);
//УДАЛИТЬ			Если ТекСтрока.КОплате = 0 Тогда
//УДАЛИТЬ				НадписьСписокКОплате.Добавить("Оплачено в " + ФирмаКратко + ": " + Формат(ТекСтрока.СуммаРеализации, "ЧДЦ=2; ЧГ=3,0") + Символ(8381) + Символы.ПС);
//УДАЛИТЬ			ИначеЕсли ТекСтрока.ККМ.Пустая() Тогда 
//УДАЛИТЬ				НадписьСписокКОплате.Добавить(Новый ФорматированнаяСтрока("Не забудьте оплатить Ваш заказ в " + ФирмаКратко + ": " + Формат(ТекСтрока.КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381), БиблиотекаКартинок.Внимание36, Символы.ПС));
//УДАЛИТЬ			Иначе
//УДАЛИТЬ				НадписьСписокКОплате.Добавить("К оплате в " + ФирмаКратко + ": " + Формат(ТекСтрока.КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381) + Символы.ПС);
//УДАЛИТЬ			КонецЕсли;
//УДАЛИТЬ		КонецЦикла;
		//Элементы.НадписьСписокКОплате.Заголовок = Новый ФорматированнаяСтрока(СтрСоединить(НадписьСписокКОплате, Символы.ПС));
//УДАЛИТЬ		Элементы.НадписьСписокКОплате.Заголовок = Новый ФорматированнаяСтрока(НадписьСписокКОплате);
		
		ОбновитьТабДокСписокОплаты();
//УДАЛИТЬ		Элементы.НадписьСписокКОплате.Видимость = Ложь;
		
		// кнопки

		// подписи
//УДАЛИТЬ		ШрифтПомельче = Новый Шрифт(Элементы.ДекорацияКегли.Шрифт,,16);
//УДАЛИТЬ		мЗаголовокКегли = Новый Массив;
//УДАЛИТЬ		мЗаголовокРубли = Новый Массив;
		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
			Элементы.СписатьКегли.Доступность = ложь;
			Элементы.СписатьКегли.ЦветТекста = WebЦвета.ТемноСерый;
			Элементы.СписатьКегли.ЦветРамки = WebЦвета.ТемноСерый;
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("для владельцев карты КеГеЛьБУМ", ШрифтПомельче));
		ИначеЕсли НЕ СписаниеВозможно Тогда
			Элементы.СписатьКегли.Доступность = ложь;
			Элементы.СписатьКегли.ЦветТекста = WebЦвета.ТемноСерый;
			Элементы.СписатьКегли.ЦветРамки = WebЦвета.ТемноСерый;
//УДАЛИТЬ			Если ТипЗнч(ДисплейИнфо) = Тип("Массив") Тогда
//УДАЛИТЬ				Для каждого ТекИнфо Из ДисплейИнфо Цикл
//УДАЛИТЬ					мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(ТекИнфо + Символы.ПС, ШрифтПомельче));
//УДАЛИТЬ				КонецЦикла;
//УДАЛИТЬ			ИначеЕсли ТипЗнч(ДисплейИнфо) = Тип("Строка") Тогда 
//УДАЛИТЬ				мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(ДисплейИнфо, ШрифтПомельче));
//УДАЛИТЬ			КонецЕсли; 
//УДАЛИТЬ		Иначе
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("Будет списано: ", ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Формат(СписаниеСписание, "ЧДЦ=; ЧГ=3,0")));
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(" КГЛ" + Символы.ПС, ШрифтПомельче));
		КонецЕсли;
		
//УДАЛИТЬ		Если СписаниеОплата <> 0 Тогда
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("Доплата: ", ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Формат(СписаниеОплата, "ЧДЦ=2; ЧГ=3,0"),));
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Символ(8381) + Символы.ПС, ШрифтПомельче));
//УДАЛИТЬ		КонецЕсли;
//УДАЛИТЬ		Если СписаниеНачисление <> 0 Тогда
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("Будет начислено: ", ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Формат(СписаниеНачисление, "ЧДЦ=; ЧГ=0"), ));
//УДАЛИТЬ			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(" КГЛ", ШрифтПомельче));
//УДАЛИТЬ		КонецЕсли;
		
//УДАЛИТЬ		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("(банковской картой)" + Символы.ПС, ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("К оплате: ", ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Формат(КОплате, "ЧДЦ=2; ЧГ=3,0"), ));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Символ(8381), ШрифтПомельче));
//УДАЛИТЬ		Иначе
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("Банковской картой" + Символы.ПС, ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("К оплате: ", ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Формат(НачислениеОплата, "ЧДЦ=2; ЧГ=3,0"), ));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Символ(8381) + Символы.ПС, ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("Будет начислено: ", ШрифтПомельче));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Формат(НачислениеНачисление, "ЧДЦ=; ЧГ=3,0"), ));
//УДАЛИТЬ			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(" КГЛ", ШрифтПомельче));
//УДАЛИТЬ		КонецЕсли;
		
//УДАЛИТЬ		ЗаголовокКегли = Новый ФорматированнаяСтрока(мЗаголовокКегли);
//УДАЛИТЬ		ЗаголовокРубли = Новый ФорматированнаяСтрока(мЗаголовокРубли);
		
		ОбновитьПодписиКнопок();
//УДАЛИТЬ		Элементы.ДекорацияКегли.Видимость = Ложь;
//УДАЛИТЬ		Элементы.ДекорацияРубли.Видимость = Ложь;
	
	КонецЕсли; 
	
	// блок МОКП
	Если ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.МОКП") Тогда
		
	КонецЕсли; 
	
	
	// блок Общий
	
	НомерЗаказа = Формат(Число(УбратьВсеБуквы(НомерЗаказа)), "ЧДЦ=; ЧГ=0");
	Элементы.ТаблицаТоварыТовар.Заголовок = "Заказ № " + НомерЗаказа;
	
//УДАЛИТЬ	Элементы.ДекорацияКегли.Заголовок = ЗаголовокКегли;
//УДАЛИТЬ	Элементы.ДекорацияРубли.Заголовок = ЗаголовокРубли;
	
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьТабДокСписокОплаты()
	
	Макет = Обработки.ГлавнаяФормаАК.ПолучитьМакет("Надписи");
	СписокОплаты.Очистить();
	
	МестаРеализации = ТаблицаТовары.Выгрузить(, "Фирма, ККМ, КОплате, СуммаРеализации");
	МестаРеализации.Свернуть("Фирма,ККМ", "КОплате,СуммаРеализации");
	Для каждого ТекСтрока Из МестаРеализации Цикл
		ФирмаКратко = Лев(СокрЛП(ТекСтрока.Фирма), 7);
		//TODO ТипТТ
		Если ТекСтрока.Фирма.ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.Ресторан") Тогда
			ФирмаКратко = "Кухня Полли";
		КонецЕсли;
		Если ТекСтрока.КОплате = 0 Тогда
			ОблМакета = Макет.ПолучитьОбласть("Оплачено");
			ОблМакета.Параметры.Текст = "Оплачено в " + ФирмаКратко + ": " + Формат(ТекСтрока.СуммаРеализации, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
			СписокОплаты.Вывести(ОблМакета);	
			
			
		ИначеЕсли ТекСтрока.ККМ.Пустая() Тогда 
			ОблМакета = Макет.ПолучитьОбласть("НеОплачено");
			ОблМакета.Параметры.Текст = "Не забудьте оплатить Ваш заказ в " + ФирмаКратко + ": " + Формат(ТекСтрока.КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
			СписокОплаты.Вывести(ОблМакета);	
		Иначе
			ОблМакета = Макет.ПолучитьОбласть("КОплате");
			ОблМакета.Параметры.Текст = "К оплате в " + ФирмаКратко + ":";
			ОблМакета.Параметры.Сумма = Формат(ТекСтрока.КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
			СписокОплаты.Вывести(ОблМакета);	
		КонецЕсли;
	КонецЦикла;
	
	Пока СписокОплаты.ВысотаТаблицы < 4 Цикл
		ОблМакета = Макет.ПолучитьОбласть("Оплачено");
		СписокОплаты.Вывести(ОблМакета);
	КонецЦикла;
	
	//СписокОплаты.ФиксацияСверху = 4;
	//СписокОплаты.ФиксацияСлева = 3;
	//СписокОплаты.Защита = Истина;
		
КонецПроцедуры

&НаСервере
Функция ПолучитьТабДокПодписьКнопки(Кнопка = "Рубли", ПоказатьБаланс = Ложь)
	
	Макет = Обработки.ГлавнаяФормаАК.ПолучитьМакет("Надписи");
	ТабДок = Новый ТабличныйДокумент;
	
	Если ВРег(Кнопка) = "КЕГЛИ" Тогда
		
		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
			ОблМакета = Макет.ПолучитьОбласть("СтрокаТекст");
			ОблМакета.Параметры.Текст = "для владельцев карты КеГеЛьБУМ";
			ТабДок.Вывести(ОблМакета);
		ИначеЕсли НЕ СписаниеВозможно Тогда
			ОблМакета = Макет.ПолучитьОбласть("СтрокаТекст");
			Если ТипЗнч(ДисплейИнфо) = Тип("Массив") Тогда
				ОблМакета.Параметры.Текст = СтрСоединить(ДисплейИнфо, Символы.ПС);
			ИначеЕсли ТипЗнч(ДисплейИнфо) = Тип("Строка") Тогда 
				ОблМакета.Параметры.Текст = ДисплейИнфо;
			КонецЕсли; 
			ТабДок.Вывести(ОблМакета);
		Иначе
			ОблМакета = Макет.ПолучитьОбласть("СтрокаКГЛ");
			ОблМакета.Параметры.Текст = "Будет списано:";
			ОблМакета.Параметры.Сумма = Формат(СписаниеСписание, "ЧДЦ=; ЧГ=3,0");
			//ОблМакета.Параметры.денег = "КГЛ";
			ТабДок.Вывести(ОблМакета);
		КонецЕсли;
		
		Если СписаниеОплата <> 0 Тогда
			ОблМакета = Макет.ПолучитьОбласть("СтрокаРУБ");
			ОблМакета.Параметры.Текст = "Доплата:";
			ОблМакета.Параметры.Сумма = Формат(Цел(СписаниеОплата), "ЧДЦ=; ЧГ=3,0");
			ОблМакета.Параметры.денег = "," + Формат(СписаниеОплата * 100 % 100, "ЧЦ=2; ЧН=00; ЧВН=") + " " + Символ(8381);
			ТабДок.Вывести(ОблМакета);
		КонецЕсли;
		Если СписаниеНачисление <> 0 Тогда
			ОблМакета = Макет.ПолучитьОбласть("СтрокаКГЛ");
			ОблМакета.Параметры.Текст = "Будет начислено:";
			ОблМакета.Параметры.Сумма = Формат(СписаниеНачисление, "ЧДЦ=; ЧГ=3,0");
			//ОблМакета.Параметры.денег = "КГЛ";
			ТабДок.Вывести(ОблМакета);
		КонецЕсли;
		
		Если ПоказатьБаланс = Истина Тогда
			ОблМакета = Макет.ПолучитьОбласть("СтрокаКГЛ");
			ОблМакета.Параметры.Текст = "Баланс карты:";
			ОблМакета.Параметры.Сумма = Формат(Баланс + СписаниеНачисление - СписаниеСписание, "ЧДЦ=; ЧГ=3,0");
			//ОблМакета.Параметры.денег = "КГЛ";
			ТабДок.Вывести(ОблМакета);
		КонецЕсли;
		
	ИначеЕсли ВРег(Кнопка) = "РУБЛИ" Тогда
		
		//ОблМакета = Макет.ПолучитьОбласть("СтрокаТекст");
		//ОблМакета.Параметры.Текст = "Банковской картой";
		//ТабДок.Вывести(ОблМакета);
		
		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
			ОблМакета = Макет.ПолучитьОбласть("СтрокаРУБ");
			ОблМакета.Параметры.Текст = "К оплате:";
			ОблМакета.Параметры.Сумма = Формат(Цел(КОплате), "ЧДЦ=; ЧГ=3,0");
			ОблМакета.Параметры.денег = "," + Формат(КОплате * 100 % 100, "ЧЦ=2; ЧН=00; ЧВН=") + " " + Символ(8381);
			ТабДок.Вывести(ОблМакета);
		Иначе
			ОблМакета = Макет.ПолучитьОбласть("СтрокаРУБ");
			ОблМакета.Параметры.Текст = "К оплате:";
			ОблМакета.Параметры.Сумма = Формат(Цел(НачислениеОплата), "ЧДЦ=; ЧГ=3,0");
			ОблМакета.Параметры.денег = "," + Формат(НачислениеОплата * 100 % 100, "ЧЦ=2; ЧН=00; ЧВН=") + " " + Символ(8381);
			ТабДок.Вывести(ОблМакета);
			
			ОблМакета = Макет.ПолучитьОбласть("СтрокаКГЛ");
			ОблМакета.Параметры.Текст = "Будет начислено:";
			ОблМакета.Параметры.Сумма = Формат(НачислениеНачисление, "ЧДЦ=; ЧГ=3,0");
			//ОблМакета.Параметры.денег = "КГЛ";
			ТабДок.Вывести(ОблМакета);
		КонецЕсли;
			
		Если ПоказатьБаланс = Истина Тогда
			ОблМакета = Макет.ПолучитьОбласть("СтрокаКГЛ");
			ОблМакета.Параметры.Текст = "Баланс карты:";
			ОблМакета.Параметры.Сумма = Формат(Баланс + НачислениеНачисление, "ЧДЦ=; ЧГ=3,0");
			//ОблМакета.Параметры.денег = "КГЛ";
			ТабДок.Вывести(ОблМакета);
		КонецЕсли;
		
	КонецЕсли;

	Пока ТабДок.ВысотаТаблицы < 5 Цикл
		ОблМакета = Макет.ПолучитьОбласть("СтрокаТекст");
		ТабДок.Вывести(ОблМакета);
	КонецЦикла;
		
	Возврат ТабДок;
	
КонецФункции

&НаСервере
Процедура ОбновитьПодписиКнопок()
	
	ПоказатьБаланс = НЕ Элементы.ПоказатьБаланс.Заголовок = ПоказатьБалансЗаголовок;
	ПодвалКеГЛи.Очистить();
	ПодвалКеГЛи.Вывести(ПолучитьТабДокПодписьКнопки("КеГЛи", ПоказатьБаланс));
	
	ПодвалРубли.Очистить();
	ПодвалРубли.Вывести(ПолучитьТабДокПодписьКнопки("Рубли", ПоказатьБаланс));
	
КонецПроцедуры

#КонецОбласти
