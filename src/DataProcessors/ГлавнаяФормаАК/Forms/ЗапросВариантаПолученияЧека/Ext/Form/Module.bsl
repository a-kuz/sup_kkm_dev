﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СпособПолученияЧека = -1;
	Email = Параметры.Email;
	НомерТелефона = Параметры.НомерТелефона;
	ДекорацияКеглиРубли = Параметры.ДекорацияКеглиРубли;
	
	ОбновитьОтображениеЭлементовДляМестаРеализации(Параметры.РабочееМесто.МестоРеализации);
	////Если Параметры.РабочееМесто.Тип = Перечисления.ТипыРМ.Автокасса
	////	и Параметры.РабочееМесто.МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.Ресторан") Тогда
	////	Элементы.ЛогоККГурмэ.Картинка = БиблиотекаКартинок.ЛогоКухняПолли;
	////КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ОбновитьНадписьEmail();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ГлавнаяФормаАК_СбросЗаказаСоСтандартнойКассы" Тогда
		Если Параметр = глРабочееМесто И Открыта() Тогда
			Закрыть(Неопределено);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	СпособПолученияЧека = -1;
	Закрыть(СтруктураРезультата());
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьВыбор(Команда)

	Закрыть(СтруктураРезультата());
	
КонецПроцедуры

&НаКлиенте
Процедура НачалоВыбора(Команда)
	
	глОтсечкаПростоя();
	
	ОтобразитьНачальнуюСтраницу();
	
КонецПроцедуры

&НаКлиенте
Процедура ВариантВыбор(Команда)
	
	глОтсечкаПростоя();
	
	СпособПолученияЧека = Число(Прав(ТекущийЭлемент.Имя, 1));
	Если СпособПолученияЧека = 0 Тогда
		Закрыть(СтруктураРезультата());
	ИначеЕсли СпособПолученияЧека = 1 Тогда
		Если ПустаяСтрока(НомерТелефона) Тогда
			ВвестиНомерТелефона();
			Возврат;
		КонецЕсли;
		ОбновитьНадписьНомерТелефона();
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Страница_3_2;
	ИначеЕсли СпособПолученияЧека = 2 Тогда
		Если ПустаяСтрока(Email) Тогда
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Страница_3_5;
		Иначе
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Страница_3_4;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВводНомера(Команда)
	
	глОтсечкаПростоя();
	
	ВвестиНомерТелефона();
	
КонецПроцедуры

&НаКлиенте
Процедура ВвестиНомерТелефона()
	
	глОтсечкаПростоя();
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("НомерТелефона", НомерТелефона); 
	ПараметрыФормы.Вставить("ВидРезультата", 0);
	ПараметрыФормы.Вставить("ДлинаПоля", 10);
	ПараметрыФормы.Вставить("РежимПароля", Ложь);
	ПараметрыФормы.Вставить("ЗаголовокНадписиВведитеНомер", "Введите номер мобильного телефона, 
	|на который будет отправлен чек:");
	ПараметрыФормы.Вставить("РабочееМесто", глРабочееМесто);
	ПараметрыФормы.Вставить("ДекорацияКеглиРубли", ДекорацияКеглиРубли);
	
	
	ОткрытьФорму("Обработка.ГлавнаяФормаАК.Форма.ВводЧисла", ПараметрыФормы, ЭтотОбъект, , , , Новый ОписаниеОповещения("ОбрабокаЗакрытияФормыВводЧисла", ЭтотОбъект));
	
КонецПроцедуры


&НаКлиенте
Процедура ОбрабокаЗакрытияФормыВводЧисла(Результат, ДополнительныеПараметры) Экспорт 
	
	глОтсечкаПростоя();
	
	Если Результат = Неопределено Тогда
		// по таймауту
		Возврат;
		//СпособПолученияЧека = -1;
		//Закрыть(СтруктураРезультата());
	КонецЕсли;
	
	Если Результат.Ошибка = -1 Тогда
		// нажали назад 		
		СпособПолученияЧека = -1;
		Закрыть(СтруктураРезультата());
		
	ИначеЕсли Результат.Ошибка = -2 Тогда
		
		ОтобразитьНачальнуюСтраницу();
		
	Иначе
		
		Если ЗначениеЗаполнено(Результат.ЗначениеВвода) Тогда
			НомерТелефона = Результат.ЗначениеВвода;
		КонецЕсли;
		
		Закрыть(СтруктураРезультата());
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СтруктураРезультата()
	
	Возврат Новый Структура("СпособПолученияЧека,Email,НомерТелефона", СпособПолученияЧека, Email, НомерТелефона);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьНадписьEmail()
	
	ШрифтПомельче = Новый Шрифт(Элементы.НадписьEmail.Шрифт,,14);
	
	Собака = СтрНайти(Email, "@");
	ПредставлениеEmail = Лев(Email, Мин(4, Цел(Собака / 2))) + "*****" + Сред(Email, Собака);
	
	Элементы.НадписьEmail.Заголовок = Новый ФорматированнаяСтрока(
	"Чек будет отправлен на Ваш e-mail:" + Символы.ПС,
	Новый ФорматированнаяСтрока(ПредставлениеEmail + Символы.ПС + Символы.ПС, Новый Шрифт(Элементы.НадписьEmail.Шрифт, , , Истина, Истина)),
	Новый ФорматированнаяСтрока("Изменить e-mail Вы можете" + Символы.ПС, ШрифтПомельче),
	Новый ФорматированнаяСтрока("в Личном кабинете на ", ШрифтПомельче),
	Новый ФорматированнаяСтрока("www.kegelbum.ru" + Символы.ПС, Новый Шрифт(ШрифтПомельче, , , Истина, Истина, Истина)),
	Новый ФорматированнаяСтрока("или в Мобильном приложении КуулКЛЕВЕР", ШрифтПомельче)
	);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНадписьНомерТелефона()
	
	//ПредставлениеНомераТелефона = СтрШаблон("+7 (%1) ***-*%2-%3", Лев(НомерТелефона, 3), Сред(НомерТелефона, 8, 1), Сред(НомерТелефона, 9, 2));
	ПредставлениеНомераТелефона = СтрШаблон("+7 (%1) %2-%3-%4", Лев(НомерТелефона, 3), Сред(НомерТелефона, 4, 3), Сред(НомерТелефона, 7, 2), Сред(НомерТелефона, 9, 2));
	Элементы.НадписьНомерТелефона.Заголовок = Новый ФорматированнаяСтрока(
	"Чек будет отправлен" + Символы.ПС + "в СМС на номер" + Символы.ПС,
	Новый ФорматированнаяСтрока(ПредставлениеНомераТелефона, Новый Шрифт(Элементы.НадписьEmail.Шрифт, , , Истина, Истина)));
	
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьНачальнуюСтраницу()

	СпособПолученияЧека = -1;
	Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.Страница_3_1;

КонецПроцедуры // ()

&НаСервере
Процедура ОбновитьОтображениеЭлементовДляМестаРеализации(МестоРеализации)
	
	// блок Кухни Полли
	Если МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.Ресторан") Тогда
		
		Элементы.ЛогоККГурмэ.Картинка = БиблиотекаКартинок.ЛогоКухняПолли;
		Элементы.ЛогоККГурмэ.Ширина = 0;
		Элементы.ЛогоККГурмэ.Высота = 0;
		Элементы.ЛогоККГурмэ.РазмерКартинки = РазмерКартинки.РеальныйРазмер;

		Элементы.СтрокаСостояния.Видимость = Истина;
		Элементы.ГруппаСтрокаСостояния.Видимость = Ложь;
		
		Элементы.ДекорацияКеглиРубли.Видимость = Ложь;
		
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
		
		Элементы.ДекорацияКеглиРубли.Видимость = Истина;
		Элементы.ДекорацияКеглиРубли.Заголовок = ДекорацияКеглиРубли;
		
		Элементы.ВариантВыбор1.Доступность = Ложь;
		Элементы.ВариантВыбор2.Доступность = Ложь;
	КонецЕсли; 
	
	// блок МОКП
	
	
	// блок Общий
	

	
КонецПроцедуры

#КонецОбласти

