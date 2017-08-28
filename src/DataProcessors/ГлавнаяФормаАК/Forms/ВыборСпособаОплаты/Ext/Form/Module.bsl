﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "КОплате,НачислениеНачисление,НачислениеОплата,СписаниеНачисление,СписаниеОплата,СписаниеСписание,НадписьКартаЛОЛ,ПИН_Хэш,НомерКартыЛояльности,НомерТелефона,НомерЗаказа,РабочееМесто");
	
	Параметры.ПоказатьТаблицуТовары = Истина;
	
	СписаниеВозможно = СписаниеСписание > 0;
	ТипЧекаЛояльность = 1;
	ПИН_Нужен = Параметры.ПИН_Нужен = 1;
	НадписьБаланс = Новый ФорматированнаяСтрока(Формат(Параметры.Баланс, "ЧДЦ=; ЧН=") + " КеГЛей");
	//Элементы.ПоказатьБаланс.Видимость = Параметры.Баланс <> 0;
	
	//Элементы.ЗаказПодробно.Видимость = НЕ Параметры.ПоказатьТаблицуТовары;
	//Элементы.Подробно.Видимость = НЕ Параметры.ПоказатьТаблицуТовары;
	Элементы.ГруппаТаблицаСкролл.Видимость = Параметры.ПоказатьТаблицуТовары;
	Элементы.КОплате.Видимость = НЕ Параметры.ПоказатьТаблицуТовары;
		
	МассивСтрокТоваров = Параметры.ТаблицаТовары; 
	//:МассивСтрокТоваров = Новый Массив;
	Для каждого ТекСтрока Из МассивСтрокТоваров Цикл
		ЗаполнитьЗначенияСвойств(ТаблицаТовары.Добавить(), ТекСтрока);
	КонецЦикла;
	Для каждого ТекМР Из Параметры.МестаРеализации Цикл
		СтрокиТоваров = ТаблицаТовары.НайтиСтроки(Новый Структура("Фирма", ТекМР.Фирма));
		Для каждого ТекСтрока Из СтрокиТоваров Цикл
			ТекСтрока.ККМ = ТекМР.ККМ;
		КонецЦикла;
	КонецЦикла;
	
	ОбновитьОтображениеЭлементовДляМестаРеализации(РабочееМесто.МестоРеализации, СписаниеВозможно);	
	////ОбновитьЗаголовкиКнопокФормы(СписаниеВозможно);
	
	//Если ПустаяСтрока(Параметры.НомерКартыЛояльности) Тогда
	//	Элементы.ОплатитьОтдельно.Видимость = Ложь;
	//	Элементы.ОплатитьВсеСоСписанием.Видимость = Ложь;
	//	Элементы.ОплатитьВсеСНачислением.Заголовок = "НАЧАТЬ ОПЛАТУ";
	//Иначе
	//	Элементы.КОплате.Видимость = Ложь;
	//	Элементы.ОплатитьВсеСоСписанием.Видимость = СписаниеВозможно;
	//	ОбновитьЗаголовкиКнопокФормы();
	//КонецЕсли;
	
	Если 
		//РабочееМесто.Тип = ПредопределенноеЗначение("Перечисление.ТипыРМ.Автокасса")
		//И 
		РабочееМесто.МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.Ресторан") Тогда
		////Элементы.ЛогоККГурмэ.Картинка = БиблиотекаКартинок.ЛогоКухняПолли;
		ПИН_Нужен = Ложь;
	КонецЕсли;
	//	Элементы.НадписьЗдравствуйте.Видимость = НЕ ПустаяСтрока(Параметры.ФИО);
	
	////Элементы.НадписьЗдравствуйте.Заголовок = "Здравствуйте, " + ?(ПустаяСтрока(Параметры.ФИО), "Гость", Параметры.ФИО) + "!" + Символы.ПС + "ВЫБЕРИТЕ СПОСОБ ОПЛАТЫ:";
	////
	////НомерЗаказа = Формат(Число(УбратьВсеБуквы(НомерЗаказа)), "ЧДЦ=; ЧГ=0");
	////Элементы.ТаблицаТоварыТовар.Заголовок = "Заказ № " + НомерЗаказа;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	глОтсечкаПростоя();
	
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
	
	Закрыть(СтруктураРезультата(-1));
	
КонецПроцедуры

&НаКлиенте
Процедура Подробно(Команда)
	
	глОтсечкаПростоя();
	
	Элементы.ГруппаТаблицаСкролл.Видимость = Истина;
	Элементы.Подробно.Видимость = Ложь;
	Элементы.КОплате.Видимость = Ложь;
	
	//Элементы.ТаблицаТовары.ВыделенныеСтроки.Очистить();
	ТекущийЭлемент = Элементы.ОплатитьВсеСНачислением;
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВсеСНачислением(Команда)
	
	глОтсечкаПростоя();
	ТипЧекаЛояльность = 1;
	Закрыть(СтруктураРезультата(1));
	
КонецПроцедуры

&НаКлиенте
Процедура ОплатитьВсеСоСписанием(Команда)
	
	глОтсечкаПростоя();
	Если ПИН_Нужен Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НомерТелефона", НомерТелефона); 
		ПараметрыФормы.Вставить("ВидРезультата", 1);
		ПараметрыФормы.Вставить("ДлинаПоля", 4);
		ПараметрыФормы.Вставить("РежимПароля", Истина);
		ПараметрыФормы.Вставить("ЗаголовокНадписиВведитеНомер", "Введите Код защиты для карты ****" + Прав(НомерКартыЛояльности, 4));
		ПараметрыФормы.Вставить("РабочееМесто",РабочееМесто);
		ПараметрыФормы.Вставить("ДекорацияКеглиРубли", Элементы.ДекорацияКегли.Заголовок);
		
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
	глОтсечкаПростоя();
	Если Элементы.ПоказатьБаланс.Заголовок = ПоказатьБалансЗаголовок Тогда
		Элементы.ПоказатьБаланс.Заголовок = НадписьБаланс;
	Иначе
		Элементы.ПоказатьБаланс.Заголовок = ПоказатьБалансЗаголовок;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СкроллВверх(Команда)
	
	глОтсечкаПростоя();
	Если Элементы.ТаблицаТовары.ТекущаяСтрока > 0 Тогда
		Элементы.ТаблицаТовары.ТекущаяСтрока = Элементы.ТаблицаТовары.ТекущаяСтрока - 1;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СкроллВниз(Команда)
	
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
		ДекорацияКеглиРубли = Элементы.ДекорацияРубли.Заголовок;
	ИначеЕсли ВыбранныйВариант = 2 Тогда
		ДекорацияКеглиРубли = Элементы.ДекорацияКегли.Заголовок;
	Иначе
		ДекорацияКеглиРубли = "";
	КонецЕсли;
	Возврат Новый Структура("ВариантОплаты,ТипЧекаЛояльность,НомерТелефона,КОплате,ДекорацияКеглиРубли", ВыбранныйВариант, ТипЧекаЛояльность, НомерТелефона, ?(ВыбранныйВариант = 2, СписаниеОплата, КОплате), ДекорацияКеглиРубли);
	
КонецФункции

&НаСервере
Процедура ОбновитьЗаголовкиКнопокФормы(СписаниеВозможно)
	
	////Если ПустаяСтрока(НомерКартыЛояльности) или не СписаниеВозможно Тогда
	////	Элементы.СписатьКегли.Доступность = ложь;
	////	Элементы.СписатьКегли.ЦветТекста = WebЦвета.ТемноСерый;
	////	Элементы.СписатьКегли.ЦветРамки = WebЦвета.ТемноСерый;
	////	ЗаголовокКегли = "для владельцев карты КеГеЛьБУМ";
	////Иначе
	////	ЗаголовокКегли = "списать" + Символы.ПС + 
	////	"Будет списано: " + Формат(СписаниеСписание, "ЧДЦ=; ЧГ=3,0") + " КГЛ" + Символы.ПС;
	////КонецЕсли;
	////
	////Если СписаниеОплата <> 0 Тогда
	////	ЗаголовокКегли = ЗаголовокКегли + "Доплата: " + Формат(СписаниеОплата, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
	////КонецЕсли;
	////
	////Если ПустаяСтрока(НомерКартыЛояльности) Тогда
	////	ЗаголовокРубли = "банковская карта" + Символы.ПС + 
	////	"К оплате: " + Формат(КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
	////Иначе
	////	ЗаголовокРубли = "банковская карта" + Символы.ПС + 
	////	"К оплате: " + Формат(НачислениеОплата, "ЧДЦ=2; ЧГ=3,0") + Символ(8381) + Символы.ПС +
	////	"Будет начислено " + Формат(НачислениеНачисление, "ЧДЦ=; ЧГ=3,0") + " КГЛ";
	////КонецЕсли;
	////
	////
	////Элементы.ДекорацияКегли.Заголовок = ЗаголовокКегли;
	////Элементы.ДекорацияРубли.Заголовок = ЗаголовокРубли;
	
	//ЗаголовокОплатитьВсеСНачислением = 
	//	"ОПЛАТИТЬ  весь заказ" + Символы.ПС +
	//	"с начислением КеГЛей" + Символы.ПС +
	//	"К ОПЛАТЕ: " + Формат(НачислениеОплата, "ЧДЦ=2; ЧГ=0") + Символ(8381) + Символы.ПС +
	//	"Будет начислено " + Формат(НачислениеНачисление, "ЧДЦ=; ЧГ=0") + " КГЛ";

	//ЗаголовокОплатитьВсеСоСписанием =
	//	"СПИСАТЬ весь" + Символы.ПС + 
	//	"заказ за КеГЛи" + Символы.ПС + 
	//	"Будет списано " + Формат(СписаниеСписание, "ЧДЦ=; ЧГ=0") + " КГЛ";
	//Если СписаниеОплата > 0 Тогда
	//	ЗаголовокОплатитьВсеСоСписанием = ЗаголовокОплатитьВсеСоСписанием + Символы.ПС + 
	//		"К доплате " + Формат(СписаниеОплата, "ЧДЦ=2; ЧГ=0") + Символ(8381);
	//КонецЕсли;
	//Если СписаниеНачисление > 0 Тогда
	//	ЗаголовокОплатитьВсеСоСписанием = ЗаголовокОплатитьВсеСоСписанием + Символы.ПС + 
	//		"Будет начислено " + Формат(СписаниеНачисление, "ЧДЦ=; ЧГ=0") + " КГЛ";
	//КонецЕсли;
	//
	//МестаРеализации = ТаблицаТовары.Выгрузить(, "МестоРеализации");
	//МестаРеализации.Свернуть("МестоРеализации");
	//МестаРеализации = МестаРеализации.ВыгрузитьКолонку("МестоРеализации");
	//Если МестаРеализации.Количество() = 1 Тогда
	//	Элементы.ОплатитьОтдельно.Видимость = Ложь;
	//Иначе
	//	Элементы.ОплатитьОтдельно.Видимость = Истина;
	//КонецЕсли;
	//ЗаголовокОплатитьОтдельно =
	//	"Оплатить ОТДЕЛЬНО" + Символы.ПС + 
	//	"заказы " + СтрСоединить(МестаРеализации, " и ");
	//
	//Элементы.ОплатитьВсеСНачислением.Заголовок = ЗаголовокОплатитьВсеСНачислением;
	//Элементы.ОплатитьВсеСоСписанием.Заголовок = ЗаголовокОплатитьВсеСоСписанием;
	//Элементы.ОплатитьОтдельно.Заголовок = ЗаголовокОплатитьОтдельно;

КонецПроцедуры

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
Процедура ОбновитьОтображениеЭлементовДляМестаРеализации(МестоРеализации, СписаниеВозможно)
	
	// блок Кухни Полли
	Если МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.Ресторан") Тогда
		
		Элементы.ЛогоККГурмэ.Картинка = БиблиотекаКартинок.ЛогоКухняПолли;
		Элементы.ЛогоККГурмэ.Ширина = 0;
		Элементы.ЛогоККГурмэ.Высота = 0;
		Элементы.ЛогоККГурмэ.РазмерКартинки = РазмерКартинки.РеальныйРазмер;

		Элементы.СтрокаСостояния.Видимость = Истина;
		Элементы.ГруппаСтрокаСостояния.Видимость = Ложь;
		
		Элементы.НадписьСписокКОплате.Видимость = Ложь;
		
		Элементы.НадписьЗдравствуйте.Заголовок = "Здравствуйте, " + ?(ПустаяСтрока(Параметры.ФИО), "Гость", Параметры.ФИО) + "!" + Символы.ПС + "ВЫБЕРИТЕ СПОСОБ ОПЛАТЫ:";
		
		Если ПустаяСтрока(НомерКартыЛояльности) или не СписаниеВозможно Тогда
			Элементы.СписатьКегли.Доступность = ложь;
			Элементы.СписатьКегли.ЦветТекста = WebЦвета.ТемноСерый;
			Элементы.СписатьКегли.ЦветРамки = WebЦвета.ТемноСерый;
			ЗаголовокКегли = "для владельцев карты КеГеЛьБУМ";
		Иначе
			ЗаголовокКегли = "списать" + Символы.ПС + 
			"Будет списано: " + Формат(СписаниеСписание, "ЧДЦ=; ЧГ=3,0") + " КГЛ" + Символы.ПС;
		КонецЕсли;
		
		Если СписаниеОплата <> 0 Тогда
			ЗаголовокКегли = ЗаголовокКегли + "Доплата: " + Формат(СписаниеОплата, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
		КонецЕсли;
	
		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
			ЗаголовокРубли = "банковская карта" + Символы.ПС + 
			"К оплате: " + Формат(КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381);
		Иначе
			ЗаголовокРубли = "банковская карта" + Символы.ПС + 
			"К оплате: " + Формат(НачислениеОплата, "ЧДЦ=2; ЧГ=3,0") + Символ(8381) + Символы.ПС +
			"Будет начислено " + Формат(НачислениеНачисление, "ЧДЦ=; ЧГ=3,0") + " КГЛ";
		КонецЕсли;
		
	КонецЕсли;
	
	// блок Классного магазина
	Если МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.КМ") Тогда
		// шапка
		Элементы.ЛогоККГурмэ.Ширина = 19;
		Элементы.ЛогоККГурмэ.Высота = 2;
		Элементы.ЛогоККГурмэ.РазмерКартинки = РазмерКартинки.Растянуть;
		
		Элементы.СтрокаСостояния.Видимость = Ложь;
		Элементы.ГруппаСтрокаСостояния.Видимость = Истина;
		
		Элементы.Назад.ЦветФона = WebЦвета.СеребристоСерый;
		Элементы.Назад.ЦветРамки = WebЦвета.СеребристоСерый;
		Элементы.Назад.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
		Элементы.Назад.Картинка = БиблиотекаКартинок.СтрелкаВлевоУголок;
		Элементы.Назад.Высота = 1;
		Элементы.Назад.Заголовок = "НАЗАД";
		
		// товары
		Элементы.ТаблицаТоварыТовар.ГоризонтальноеПоложениеВШапке = ГоризонтальноеПоложениеЭлемента.Центр;
		Элементы.ТаблицаТовары.Подвал = Ложь;
		Элементы.ТаблицаТовары.МаксимальнаяВысотаВСтрокахТаблицы = 6;
		Элементы.ТаблицаТовары.РастягиватьПоВертикали = Истина;
		
		Элементы.СкроллВверх.Картинка = БиблиотекаКартинок.СтрелкаВверхУголок;
		Элементы.СкроллВверх.ЦветФона = WebЦвета.СеребристоСерый;
		
		Элементы.СкроллВниз.Картинка = БиблиотекаКартинок.СтрелкаВнизУголок;
		Элементы.СкроллВниз.ЦветФона = WebЦвета.СеребристоСерый;
		
		// надписи
		Элементы.НадписьЗдравствуйте.Заголовок = "Выберите способ оплаты:";
		Элементы.НадписьЗдравствуйте.ЦветТекста = ЦветаСтиля.ЦветТемы;
		Элементы.НадписьЗдравствуйте.Шрифт = Новый Шрифт(Элементы.НадписьЗдравствуйте.Шрифт, , 22);
		
		НадписьСписокКОплате = Новый Массив;
		МестаРеализации = ТаблицаТовары.Выгрузить(, "Фирма, ККМ, КОплате");
		МестаРеализации.Свернуть("Фирма,ККМ", "КОплате");
		Для каждого ТекСтрока Из МестаРеализации Цикл
			ФирмаКратко = Лев(СокрЛП(ТекСтрока.Фирма), 7);
			Если ТекСтрока.КОплате = 0 Тогда
				НадписьСписокКОплате.Добавить("Оплачено в " + ФирмаКратко + Символы.ПС);
			ИначеЕсли ТекСтрока.ККМ.Пустая() Тогда 
				НадписьСписокКОплате.Добавить(Новый ФорматированнаяСтрока("Не забудьте оплатить Ваш заказ в " + ФирмаКратко + ": " + Формат(ТекСтрока.КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381), БиблиотекаКартинок.Внимание36, Символы.ПС));
			Иначе
				НадписьСписокКОплате.Добавить("К оплате в " + ФирмаКратко + ": " + Формат(ТекСтрока.КОплате, "ЧДЦ=2; ЧГ=3,0") + Символ(8381) + Символы.ПС);
			КонецЕсли;
		КонецЦикла;
		//Элементы.НадписьСписокКОплате.Заголовок = Новый ФорматированнаяСтрока(СтрСоединить(НадписьСписокКОплате, Символы.ПС));
		Элементы.НадписьСписокКОплате.Заголовок = Новый ФорматированнаяСтрока(НадписьСписокКОплате);
		
		// кнопки
		
		Элементы.СписатьКегли.Заголовок = "КеГЛи";
		Элементы.СписатьКегли.ЦветФона = ЦветаСтиля.ЦветТемы;
		Элементы.СписатьКегли.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
		
		Элементы.НачислитьКегли.Заголовок = "Рубли";
		Элементы.НачислитьКегли.ЦветФона = ЦветаСтиля.ЦветТемы;
		Элементы.НачислитьКегли.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
		
		// подписи
		ШрифтПомельче = Новый Шрифт(Элементы.ДекорацияКегли.Шрифт,,16);
		мЗаголовокКегли = Новый Массив;
		мЗаголовокРубли = Новый Массив;
		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
			Элементы.СписатьКегли.Доступность = ложь;
			Элементы.СписатьКегли.ЦветТекста = WebЦвета.ТемноСерый;
			Элементы.СписатьКегли.ЦветРамки = WebЦвета.ТемноСерый;
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("для владельцев карты КеГеЛьБУМ", ШрифтПомельче));
		ИначеЕсли НЕ СписаниеВозможно Тогда
			Элементы.СписатьКегли.Доступность = ложь;
			Элементы.СписатьКегли.ЦветТекста = WebЦвета.ТемноСерый;
			Элементы.СписатьКегли.ЦветРамки = WebЦвета.ТемноСерый;
			Если ТипЗнч(Параметры.ДисплейИнфо) = Тип("Массив") Тогда
				Для каждого ТекИнфо Из Параметры.ДисплейИнфо Цикл
					мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(ТекИнфо + Символы.ПС, ШрифтПомельче));
				КонецЦикла;
			ИначеЕсли ТипЗнч(Параметры.ДисплейИнфо) = Тип("Строка") Тогда 
				мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Параметры.ДисплейИнфо, ШрифтПомельче));
			КонецЕсли; 
		Иначе
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("Будет списано: ", ШрифтПомельче));
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Формат(СписаниеСписание, "ЧДЦ=; ЧГ=3,0")));
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(" КеГЛей" + Символы.ПС, ШрифтПомельче));
		КонецЕсли;
		
		Если СписаниеОплата <> 0 Тогда
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("Доплата: ", ШрифтПомельче));
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Формат(СписаниеОплата, "ЧДЦ=2; ЧГ=3,0"),));
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Символ(8381) + Символы.ПС, ШрифтПомельче));
		КонецЕсли;
		Если СписаниеНачисление <> 0 Тогда
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока("Будет начислено: ", ШрифтПомельче));
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(Формат(СписаниеНачисление, "ЧДЦ=; ЧГ=0"), ));
			мЗаголовокКегли.Добавить(Новый ФорматированнаяСтрока(" КеГЛей", ШрифтПомельче));
		КонецЕсли;
		
		Если ПустаяСтрока(НомерКартыЛояльности) Тогда
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("(банковской картой)" + Символы.ПС, ШрифтПомельче));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("К оплате: ", ШрифтПомельче));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Формат(КОплате, "ЧДЦ=2; ЧГ=3,0"), ));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Символ(8381), ШрифтПомельче));
		Иначе
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("Банковской картой" + Символы.ПС, ШрифтПомельче));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("К оплате: ", ШрифтПомельче));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Формат(НачислениеОплата, "ЧДЦ=2; ЧГ=3,0"), ));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Символ(8381) + Символы.ПС, ШрифтПомельче));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока("Будет начислено: ", ШрифтПомельче));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(Формат(НачислениеНачисление, "ЧДЦ=; ЧГ=3,0"), ));
			мЗаголовокРубли.Добавить(Новый ФорматированнаяСтрока(" КеГЛей", ШрифтПомельче));
		КонецЕсли;
		
		ЗаголовокКегли = Новый ФорматированнаяСтрока(мЗаголовокКегли);
		ЗаголовокРубли = Новый ФорматированнаяСтрока(мЗаголовокРубли);
	
	КонецЕсли; 
	
	// блок МОКП
	
	
	// блок Общий
	
	ПоказатьБалансЗаголовок = "Показать баланс карты КеГеЛьБУМ";
	Элементы.ПоказатьБаланс.Заголовок = ПоказатьБалансЗаголовок;
	
	НомерЗаказа = Формат(Число(УбратьВсеБуквы(НомерЗаказа)), "ЧДЦ=; ЧГ=0");
	Элементы.ТаблицаТоварыТовар.Заголовок = "Заказ № " + НомерЗаказа;
	
	Элементы.ДекорацияКегли.Заголовок = ЗаголовокКегли;
	Элементы.ДекорацияРубли.Заголовок = ЗаголовокРубли;
	
	
КонецПроцедуры

#КонецОбласти


