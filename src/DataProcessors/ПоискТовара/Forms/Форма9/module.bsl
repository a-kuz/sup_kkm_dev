﻿Перем фЗакрыть;
Перем ТоваровНаСтранице;


Процедура ПриОткрытии()
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);

	ЭлементыФормы.НадписьЗаголовок.Заголовок = ЭтаФорма.Заголовок;	
	Если глПараметрыРМ.ОбрезкаОкон Тогда
		
	Иначе
		//Заголовок = "";
	КонецЕсли;
	
	ЗаполнитьТовары(Товары);	
	Стиль = БиблиотекаСтилей.СтанцияОплаты;
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	глОтсечкаПростоя();
	Если Не глСтекОкон.Количество() Тогда
		Возврат;
	КонецЕсли;
	Если глСтекОкон[0].Форма <> ЭтаФорма Тогда
		Возврат;
	КонецЕсли;
	
	_Знач = ОбработкаВнешнихСобытий.ПолучитьДанные(Источник,Событие,Данные);
	Если НЕ ЗначениеЗаполнено(_Знач) Тогда
		Возврат;
	КонецЕсли;

	ЗначениеВвода = _Знач;
	ПодключитьОбработчикОжидания("Поиск",0.1,1);
	//ПДФ = ОбработкаВнешнихСобытий.ПолучитьДанные(Источник,Событие,Данные);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	ИнтерфейсРМ.ПриЗакрытииОкна();
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
КонецПроцедуры

Процедура ОтменаНажатие(Элемент)
	фЗакрыть = Истина;
	Закрыть("");
КонецПроцедуры

Процедура НажатиеКнопки(СтрКнопки) Экспорт
	ОтключитьОбработчикОжидания("Поиск");
	ФормаВвода = ЭтаФорма;
	Если ФормаВвода.ЭлементыФормы.ЗначениеВвода.ТолькоПросмотр Тогда
		Возврат;
	КонецЕсли;
	
	
	НовЗнач = ЗначениеВвода;
	
	НовЗнач = НовЗнач + СтрКнопки;	
	
	ЗначениеВвода = НовЗнач;
	Если СтрДлина(НовЗнач) > 2 Тогда
		ПодключитьОбработчикОжидания("Поиск",0.1,1);
	ИначеЕсли СтрДлина(НовЗнач) Тогда 
		ПодключитьОбработчикОжидания("Поиск",1.5,1);
	Иначе
		ОтключитьОбработчикОжидания("Поиск");
	КонецЕсли;
	
	глОтсечкаПростоя();
	
КонецПроцедуры

Процедура Поиск() Экспорт
	мДобавленныеТовары = Новый Массив;
	Товары.Очистить();
	Если СтрДлина(ЗначениеВвода) <=3 Тогда
		Ст = ТаблицаПоиска.Найти(ЗначениеВвода, "Штрихкод");	
		Если Не Ст = Неопределено Тогда
			Ст.Представление = Ст.Наименование;
			ЗаполнитьЗначенияСвойств(Товары.Добавить(),Ст);
			ЭлементыФормы.тпТовары.ТекущаяСтрока = Товары[0];
			Возврат;	
		КонецЕсли;
	КонецЕсли;
	Для каждого Т Из ТаблицаПоиска Цикл
		фДобавить = Ложь;
		ПозКодСУП = Найти(Т.КодСУП, ЗначениеВвода);
		Если ПозКодСУП Тогда                                             
			фДобавить = Истина;
			Т.Представление = СокрЛП(Т.Наименование) + " ("+Т.КодСУП + ")";
			Позиция2 = Найти(Т.ШтрихКод, ЗначениеВвода);
			Если Позиция2 = 0 Тогда
			
				Позиция2 = 9999;
			
			КонецЕсли; 
			Т.ПозицияСовпадения = Мин(ПозКодСУП, Позиция2);
		Иначе
			ПозШК = Найти(Т.ШтрихКод, ЗначениеВвода);
			Если ПозШК Тогда 
				фДобавить = Истина;
				Т.Представление = СокрЛП(Т.Наименование) + " ("+СокрЛП(Т.ШтрихКод) + ")";
				Т.ПозицияСовпадения = ПозШК;
			КонецЕсли;
		КонецЕсли;
		Если фДобавить Тогда
			Если мДобавленныеТовары.Найти(Т.Товар) = Неопределено Тогда
				мДобавленныеТовары.Добавить(Т.Товар);
				ЗаполнитьЗначенияСвойств(Товары.Добавить(),Т);
			КонецЕсли;
		КонецЕсли;
		//Если Товары.Количество() > 100 Тогда
		//	Прервать;
		//КонецЕсли;
		
	КонецЦикла;
	
	Если Товары.Количество() Тогда
		Товары.Сортировать("ПозицияСовпадения");
		ЭлементыФормы.тпТовары.ТекущаяСтрока = Товары[0];
	КонецЕсли;
	
	ДоступностьСтрелок();
КонецПроцедуры

Процедура ДоступностьСтрелок()
	ВсегоСтрок = Товары.Количество();
	Если ВсегоСтрок Тогда
		НомерТекСтроки = Товары.Индекс( ЭлементыФормы.тпТовары.ТекущаяСтрока) + 1;
	Иначе
		НомерТекСтроки = 0;
	КонецЕсли;
	
	Если НомерТекСтроки+2 <= ТоваровНаСтранице Тогда
		ЭлементыФормы.ЛистатьВверх.Доступность = 0;
		КначалуСписка();	
	Иначе
		ЭлементыФормы.ЛистатьВверх.Доступность = 1;
	КонецЕсли;
	
	Если НомерТекСтроки = ВсегоСтрок Тогда
		ЭлементыФормы.ЛистатьВниз.Доступность = 0;
	Иначе
		ЭлементыФормы.ЛистатьВниз.Доступность = 1;
	КонецЕсли;

	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаОКНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Если Товары.Количество() Тогда
			Товар = Товары[0].Товар;
			ШК = Товары[0].ШК;
		Иначе
			ОтменаНажатие("");
		КонецЕсли;
	Иначе
		Товар = ЭлементыФормы.тпТовары.ТекущиеДанные.Товар;
		ШК = ЭлементыФормы.тпТовары.ТекущиеДанные.ШК;
	КонецЕсли;
	ОК();
КонецПроцедуры

Процедура КнопкаСбросНажатие(Элемент)
	
	Товары.Очистить();
	ОтключитьОбработчикОжидания("Поиск");
	Сброс();
	
КонецПроцедуры

Процедура Кнопка0Нажатие(Элемент)
	
	НажатиеКнопки("0");
	
КонецПроцедуры

Процедура Кнопка1Нажатие(Элемент)
	
	НажатиеКнопки("1");
	
КонецПроцедуры

Процедура Кнопка2Нажатие(Элемент)
	
	НажатиеКнопки("2");
	
КонецПроцедуры

Процедура Кнопка3Нажатие(Элемент)
	
	НажатиеКнопки("3");
	
КонецПроцедуры

Процедура Кнопка4Нажатие(Элемент)
	
	НажатиеКнопки("4");
	
КонецПроцедуры

Процедура Кнопка5Нажатие(Элемент)
	
	НажатиеКнопки("5");
	
КонецПроцедуры

Процедура Кнопка6Нажатие(Элемент)
	
	НажатиеКнопки("6");
	
КонецПроцедуры

Процедура Кнопка7Нажатие(Элемент)
	
	НажатиеКнопки("7");
	
КонецПроцедуры

Процедура Кнопка8Нажатие(Элемент)
	
	НажатиеКнопки("8");
	
КонецПроцедуры

Процедура Кнопка9Нажатие(Элемент)
	
	НажатиеКнопки("9");
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	Товары.Очистить();	
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
КонецПроцедуры

Процедура тпТоварыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	ОК();	
КонецПроцедуры

Процедура тпТоварыПриАктивизацииСтроки(Элемент)
	Если ЭлементыФОрмы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Товар = Справочники.Товары.ПустаяСсылка();
		ШК = "";
	Иначе
		Товар = ЭлементыФормы.тпТовары.ТекущиеДанные.Товар;
		ШК = ЭлементыФормы.тпТовары.ТекущиеДанные.ШК;
	КонецЕсли;
	
	//тпТоварыВыбор(Элемент, ЭлементыФормы.тпТовары.ТекущаяСтрока, "", Ложь);
КонецПроцедуры

Процедура ЛистатьВверхНажатие(Элемент)
	Скрипт = "
	|#NoTrayIcon
	|ControlSend, V8Grid1, {PgUp}, A
	|";
	Скрипт = СтрЗаменить(Скрипт, "%Заголовок%", Заголовок);
	AutohotkeyDll.ahkTextDll(Скрипт);
	ПодключитьОбработчикОжидания("ДоступностьСтрелок",0.2,1);
КонецПроцедуры

Процедура ЛистатьВнизНажатие(Элемент)
	Скрипт = "
	|#NoTrayIcon
	|ControlSend, V8Grid1, {PgDn}, A
	|";
	Скрипт = СтрЗаменить(Скрипт, "%Заголовок%", Заголовок);
	AutohotkeyDll.ahkTextDll(Скрипт);
	ПодключитьОбработчикОжидания("ДоступностьСтрелок",0.2,1);
КонецПроцедуры

Процедура КначалуСписка()
	Скрипт = "
	|#NoTrayIcon
	|ControlSend, V8Grid1, {Home}, A
	|";
	Скрипт = СтрЗаменить(Скрипт, "%Заголовок%", Заголовок);
	AutohotkeyDll.ahkTextDll(Скрипт);
КонецПроцедуры

Процедура ЗначениеВводаПриИзменении(Элемент)
	ПодключитьОбработчикОжидания("Поиск",0.1,1);

КонецПроцедуры

Процедура тпТоварыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	стрЦена = Формат(ДанныеСтроки.Цена, "ЧДЦ=2; ЧРД=.");
	Если ДанныеСтроки.Цена = Цел(ДанныеСтроки.Цена) Тогда
		стрЦена = СтрЗаменить(стрЦена, ".00", ".-");
	КонецЕсли;
	
	стрЦена = стрЦена + " " + глСимволРубля;
	ОформлениеСтроки.Ячейки.Цена.УстановитьТекст(стрЦена);
КонецПроцедуры

Процедура БэкспейсНажатие(Элемент)
	ЗначениеВвода = СокрП(ЗначениеВвода);
	ЗначениеВвода = Лев(ЗначениеВвода, СтрДлина(ЗначениеВвода)-1);
	НажатиеКнопки("");
КонецПроцедуры





ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
ЭлементыФормы.ЛистатьВверх.Заголовок = Шрифты.ПолучитьСимвол("angle_up");
ЭлементыФормы.ЛистатьВниз.Заголовок = Шрифты.ПолучитьСимвол("angle_down");

ТоваровНаСтранице = 15;

