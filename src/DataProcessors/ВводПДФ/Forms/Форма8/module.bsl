﻿Перем фЗакрыть;
Процедура Мигнуть() Экспорт
	глОтсечкаПростоя();
	//Индикатор = (-1)*(Индикатор - 100);
КонецПроцедуры

Процедура ПриОткрытии()
	ПодключитьОбработчикОжидания("Мигнуть",3);
	Заголовок = "ПДФ";
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	Стиль = БиблиотекаСтилей.СтанцияОплаты;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	глОтсечкаПростоя();
	Если глСтекОкон[0].Форма <> ЭтаФорма Тогда
		Возврат;
	КонецЕсли;
	
	ПДФ = ОбработкаВнешнихСобытий.ПолучитьДанные(Источник,Событие,Данные);
	Если Не ЗначениеЗаполнено(ПДФ) Тогда
		Возврат;
	КонецЕсли;
	
	ЭтоСканерШК = Найти(Источник, "Bar") > 0;
	Сканер1С = Сканер1С;
	Если глТорговоеОборудование.Свойство("Scaner1C", Сканер1С) Тогда
		Если Найти(Сканер1С.ОписаниеПорта, "Клавиатура") Тогда
			ЭтоСканерШК = Ложь; // Т. к. источник всегда равен "BarCodeScaner", сделаем пока затычку: считаем, что ридеры МК подключены через клавиатуру
		КонецЕсли;
	КонецЕсли;
	
	Если ЭтоСканерШК Тогда
		РезультатПроверки = Алкоголь.ПроверитьПДФ(ПДФ, ПДФЧека, Товар, ЭтоВозврат, глОбработки.ГлавнаяФорма.ТекущийДокумент.Ссылка);
		Если РезультатПроверки.Успех Тогда
			фЗакрыть = Истина;
			Закрыть(РезультатПроверки.ПДФ);
		Иначе
			ЗарегистрироватьСобытие("Excise.Повтор ПДФ", УровеньЖурналаРегистрации.Ошибка,,,ПДФ + Символы.ПС + РезультатПроверки.ОшибкаТекст);
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка",РезультатПроверки.ОшибкаЗаголовок,РезультатПроверки.ОшибкаТекст,"","ОК","",,0);
			фЗакрыть = Истина;
			Закрыть("");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗакрытии()
	ИнтерфейсРМ.ПриЗакрытииОкна();
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Если фЗакрыть = Ложь Тогда
		фЗакрыть = Истина;
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
КонецПроцедуры

Процедура ОтменаНажатие(Элемент)
	глОтсечкаПростоя();
	фЗакрыть = Истина;
	Закрыть("");
КонецПроцедуры

Процедура кнЧитНажатие(Элемент)
	фЗакрыть = Истина;
	Закрыть("16N00001CJPFO4450G71NSP20905004004797o326811691897119682191882211821");
КонецПроцедуры


ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);