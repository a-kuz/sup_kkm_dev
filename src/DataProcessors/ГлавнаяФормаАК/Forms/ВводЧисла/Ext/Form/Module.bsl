﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ДлинаПоля,ВидРезультата,НомерТелефона,РабочееМесто");    //
	
	ПодвалКеГЛиРубли.Очистить();
	ПодвалКеГЛиРубли.Вывести(Параметры.ПодвалКеГЛиРубли);
	//ПодвалКеГЛиРубли.ФиксацияСверху = 5;
	//ПодвалКеГЛиРубли.ФиксацияСлева = 3;
	//ПодвалКеГЛиРубли.Защита = Истина;

	ОбновитьОтображениеЭлементовДляМестаРеализации(РабочееМесто.МестоРеализации, РабочееМесто.Фирма.ТипТТ);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	глОтсечкаПростоя();
	ОбновитьТекстПоляВРежимеПароля();

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

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Назад(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	Закрыть(СтруктураРезультата(-1));
	
КонецПроцедуры

&НаКлиенте
Процедура ВернутьсяКВыбору(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	Закрыть(СтруктураРезультата(-2));
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаН(Команда)
	
	Элементы.Колонка1.Доступность = Ложь;
	
	глОтсечкаПростоя();
	
	ЗначениеВвода = Лев(ЗначениеВвода + ТекущийЭлемент.Заголовок, ДлинаПоля);
	ОбновитьТекстПоляВРежимеПароля();
	Элементы.ПодтвердитьВыбор.Доступность = СтрДлина(ЗначениеВвода) = ДлинаПоля;
	
	Элементы.Колонка1.Доступность = Истина;

КонецПроцедуры

&НаКлиенте
Процедура БэкСпейс(Команда)
	
	глОтсечкаПростоя();
	
	ДлинаСтроки = СтрДлина(ЗначениеВвода) - 1;
	Если ДлинаСтроки >= 0 Тогда
		ЗначениеВвода = Лев(ЗначениеВвода, ДлинаСтроки);
		ОбновитьТекстПоляВРежимеПароля();
	КонецЕсли;
	Элементы.ПодтвердитьВыбор.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	
	глОтсечкаПростоя();
	
	ДлинаСтроки = 0;
	ЗначениеВвода = "";
	ОбновитьТекстПоляВРежимеПароля();

	Элементы.ПодтвердитьВыбор.Доступность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПодтвердитьВыбор(Команда)
	
	ЗарегистрироватьСобытие("Автокасса.Нажатие кнопки", ПредопределенноеЗначение("УровеньЖурналаРегистрации.Информация"), , , "Форма=" + ИмяФормы + Символы.ПС + "Кнопка=" + ТекущийЭлемент.Заголовок);
	Закрыть(СтруктураРезультата(0));
	
КонецПроцедуры

&НаКлиенте
Процедура ОбрабокаЗакрытияФормыВводЧисла(Результат, ДополнительныеПараметры) Экспорт 
	
	глОтсечкаПростоя();
	
	Если Результат = Неопределено Тогда
		// по таймауту
		Закрыть(СтруктураРезультата(-1));
	КонецЕсли;
	
	Если Результат.Ошибка = -1 Тогда
		// нажали назад 
		
	Иначе
		// ввели номер телефона
		// необходимо время на прием смс
		#Если ТолстыйКлиентУправляемоеПриложение Тогда
			глОтсечкаПростоя(180);
		#КонецЕсли		
		НомерТелефона = Результат.ЗначениеВвода;
		
	КонецЕсли;
	
	//TODO запрос нового ПИНа от сервиса лояльности
	ПолучитьПИННаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Функция СтруктураРезультата(Ошибка = 0)
	
	Возврат Новый Структура("Ошибка,ВидРезультата,ЗначениеВвода,НомерТелефона", Ошибка, ВидРезультата, ЗначениеВвода, НомерТелефона);
	
КонецФункции

&НаКлиенте
Процедура ОбновитьТекстПоляВРежимеПароля()
	
	Если ВидРезультата = 1 Тогда
		стрЗначениеВвода = Лев(Лев("********************", СтрДлина(ЗначениеВвода)) + "--------------------", ДлинаПоля);
		Если СтрДлина(ЗначениеВвода) = ДлинаПоля Тогда
			Закрыть(СтруктураРезультата(0));
		КонецЕсли;
	Иначе
		стрЗначениеВвода = ЗначениеВвода;
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ОбновитьОтображениеЭлементовДляМестаРеализации(МестоРеализации, ТипТТ = Неопределено)
	
	Если ТипТТ = Неопределено Тогда
		ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.КМ");
	КонецЕсли;
	
	// блок Кухни Полли
	Если ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.Ресторан") Тогда
		
		Элементы.ЛогоККГурмэ.Картинка = БиблиотекаКартинок.ЛогоКухняПолли;

//УДАЛИТЬ		Элементы.ГруппаСтрокаСостояния.Видимость = Истина;
		
//УДАЛИТЬ		Элементы.ДекорацияКеглиРубли.Видимость = Ложь;
//УДАЛИТЬ		Элементы.ПодвалКеГЛиРубли.Видимость = Истина;
		
		Элементы.НазадКолонка2.Видимость = Ложь;		
		
	КонецЕсли;
	
	// блок Классного магазина
	Если ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.КМ") Тогда
		
		// шапка
//УДАЛИТЬ		Элементы.ГруппаСтрокаСостояния.Видимость = Истина;
		
//УДАЛИТЬ		Элементы.ДекорацияКеглиРубли.Заголовок = Параметры.ДекорацияКеглиРубли;
//УДАЛИТЬ		Элементы.ДекорацияКеглиРубли.Видимость = Ложь;
		
//УДАЛИТЬ		Элементы.ПодвалКеГЛиРубли.Видимость = Истина;
		
		Если ВидРезультата = 0 Тогда
			
			// телефон: шаг 2
			Элементы.СС_1.ЦветФона = WebЦвета.ЦветМорскойВолныТемный;
			Элементы.СС_1ш.ЦветФона = WebЦвета.ЦветМорскойВолныТемный;
			
			Элементы.СС_2.ЦветФона = ЦветаСтиля.ЦветТемы;
			Элементы.СС_2.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
			Элементы.СС_2ш.ЦветФона = ЦветаСтиля.ЦветТемы;
			Элементы.СС_2ш.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
			
			Элементы.ПодтвердитьВыбор.Ширина = 28;
			Элементы.ПодтвердитьВыбор.ВертикальноеПоложениеВГруппе = ВертикальноеПоложениеЭлемента.Верх;
			
		ИначеЕсли ВидРезультата = 1 Тогда
			
			// ПИН: шаг 1
			Элементы.СС_1.ЦветФона = ЦветаСтиля.ЦветТемы;
			Элементы.СС_1ш.ЦветФона = ЦветаСтиля.ЦветТемы;
			
			Элементы.СС_2.ЦветФона = WebЦвета.Роса;
			Элементы.СС_2.ЦветТекста = ЦветаСтиля.НеактивныйЭлемент;
			Элементы.СС_2ш.ЦветФона = WebЦвета.Роса;
			Элементы.СС_2ш.ЦветТекста = ЦветаСтиля.НеактивныйЭлемент;
			
			Элементы.Колонка2.Видимость = Ложь;
			
		КонецЕсли;
		
	КонецЕсли; 
	
	// блок МОКП
	Если ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.МОКП") Тогда
		// шапка
		
		Если ВидРезультата = 0 Тогда
			
			// телефон: шаг 2
			Элементы.СС_1.ЦветФона = WebЦвета.ЦветМорскойВолныТемный;
			Элементы.СС_1ш.ЦветФона = WebЦвета.ЦветМорскойВолныТемный;
			
			Элементы.СС_2.ЦветФона = ЦветаСтиля.ЦветТемы;
			Элементы.СС_2.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
			Элементы.СС_2ш.ЦветФона = ЦветаСтиля.ЦветТемы;
			Элементы.СС_2ш.ЦветТекста = ЦветаСтиля.ЦветФонаФормы;
			
			Элементы.ПодтвердитьВыбор.Ширина = 28;
			Элементы.ПодтвердитьВыбор.ВертикальноеПоложениеВГруппе = ВертикальноеПоложениеЭлемента.Верх;
			
		ИначеЕсли ВидРезультата = 1 Тогда
			
			// ПИН: шаг 1
			Элементы.СС_1.ЦветФона = ЦветаСтиля.ЦветТемы;
			Элементы.СС_1ш.ЦветФона = ЦветаСтиля.ЦветТемы;
			
			Элементы.СС_2.ЦветФона = WebЦвета.Роса;
			Элементы.СС_2.ЦветТекста = ЦветаСтиля.НеактивныйЭлемент;
			Элементы.СС_2ш.ЦветФона = WebЦвета.Роса;
			Элементы.СС_2ш.ЦветТекста = ЦветаСтиля.НеактивныйЭлемент;
			
			Элементы.Колонка2.Видимость = Ложь;
			
		КонецЕсли;
		Элементы.ПодвалКеГЛиРубли.Ширина = 75;
		Элементы.ПодвалКеГЛиРубли.Высота = 7;
	КонецЕсли; 
	
	
	// блок Общий
	Если ВидРезультата = 0 Тогда
		// телефон
		Элементы.стрЗначениеВвода.Маска = " +7 (999) 999-99-99";
		Элементы.ПодтвердитьВыбор.Заголовок = "Отправить на
			|этот номер
			|телефона";
	ИначеЕсли ВидРезультата = 1 Тогда
		// ПИН
		Элементы.стрЗначениеВвода.Маска = "";
		Элементы.ПодтвердитьВыбор.Заголовок = "Ввод";
	КонецЕсли;
	Элементы.НадписьВведитеНомер.Заголовок = Параметры.ЗаголовокНадписиВведитеНомер;
	
КонецПроцедуры

#КонецОбласти

#Область УДАЛИТЬ

&НаСервере
Процедура ПолучитьПИННаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьПИН(Команда)
	
	глОтсечкаПростоя();
	
	Если ПустаяСтрока(НомерТелефона) Тогда
		
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("НомерТелефона", ""); 
		ПараметрыФормы.Вставить("ВидРезультата", 0);
		ПараметрыФормы.Вставить("ДлинаПоля", 10);
		ПараметрыФормы.Вставить("РежимПароля", Ложь);
		ПараметрыФормы.Вставить("ЗаголовокНадписиВведитеНомер", "Введите номер мобильного телефона, 
		|на который будет отправлен Код защиты:");
		
		ОткрытьФорму("Обработка.ГлавнаяФормаАК.Форма.ВводЧисла", ПараметрыФормы, ЭтотОбъект, Истина, , , Новый ОписаниеОповещения("ОбрабокаЗакрытияФормыВводЧисла", ЭтотОбъект));
		Возврат;
		
	КонецЕсли;
	
	ПолучитьПИННаСервере();
	
КонецПроцедуры

#КонецОбласти