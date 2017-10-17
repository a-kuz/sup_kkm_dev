﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура формирует строковое представление адреса.
Процедура СформироватьПредставление()

	Представление = "";

	Если СокрЛП(Поле1) <> "" Тогда
		Представление = Представление + ", " + СокрЛП(Поле1);
	КонецЕсли;

	Если СокрЛП(Поле2) <> "" Тогда
		Представление = Представление + ", " + СокрЛП(Поле2);
	КонецЕсли;

	Если СокрЛП(Поле3) <> "" Тогда
		Представление = Представление + ", " + СокрЛП(Поле3);
	КонецЕсли;

	Если СокрЛП(Поле4) <> "" Тогда
		Представление = Представление + ", " + СокрЛП(Поле4);
	КонецЕсли;

	Если СокрЛП(Поле5) <> "" Тогда
		Представление = Представление + ", " + СокрЛП(Поле5);
	КонецЕсли;
	
	Если СокрЛП(Район) <> "" Тогда
		Представление = Представление + ", " + СокрЛП(Район);
	КонецЕсли;

	Если СокрЛП(Поле6) <> "" Тогда
		Представление = Представление + ", " + СокрЛП(Поле6);
	КонецЕсли;

	Если СокрЛП(Поле7) <> "" Тогда
		Если НЕ СокрЛП(СЗДом) = "другое" Тогда
			ПредставлениеДом = СЗДом + Поле7;
		Иначе
			ПредставлениеДом = Поле7;
		КонецЕсли;
		Представление = Представление + ", " + СокрЛП(ПредставлениеДом);
	КонецЕсли;

	Если СокрЛП(Поле8) <> "" Тогда
		Если НЕ СокрЛП(КорЛит) = "другое" Тогда
			ПредставлениеКор = КорЛит + Поле8;
		Иначе
			ПредставлениеКор = Поле8;
		КонецЕсли;
		Представление = Представление + ", " + СокрЛП(ПредставлениеКор);
	КонецЕсли;

	Если СокрЛП(Поле9) <> "" Тогда
		Если НЕ СокрЛП(Кв) = "другое" Тогда
			ПредставлениеКв = Кв + Поле9;
		Иначе
			ПредставлениеКв = Поле9;
		КонецЕсли;
		Представление = Представление + ", " + СокрЛП(ПредставлениеКв);
	КонецЕсли;

	Если СтрДлина(Представление) > 2 Тогда
		Представление = Сред(Представление, 3);
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	КорЛит	= ПолучитьИзПоля10("КорЛит");
	Кв		= ПолучитьИзПоля10("Кв");
	СЗДом	= ПолучитьИзПоля10("Дом");
	
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ПослеЗаписи()
	
	ОповеститьОЗаписиНовогоОбъекта(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	СформироватьПредставление();
	
	Если Представление="" Тогда
		Предупреждение("Адрес пустой");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура УлицаПриИзменении(Элемент)
	
	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();
	
КонецПроцедуры

Процедура ДомПриИзменении(Элемент)

	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();

КонецПроцедуры

Процедура КорпусПриИзменении(Элемент)

	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();

КонецПроцедуры

Процедура КвартираПриИзменении(Элемент)

	СформироватьПредставление();

КонецПроцедуры

Процедура УлицаНачалоВыбора(Элемент, СтандартнаяОбработка)

	ФормаВыбора = РегистрыСведений.АдресныйКлассификатор.ПолучитьФорму("ФормаВыбора", Элемент,);
	ФормаВыбора.НазваниеЭлемента = СокрЛП(Поле6);
	ФормаВыбора.УстановитьРодителя(Поле2, Поле3, Поле4, Поле5);
	ФормаВыбора.ОтобратьТолькоУлицы();
	ФормаВыбора.Открыть();

КонецПроцедуры

Процедура УлицаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АдреснаяЗапись = киПолучитьСтруктуруАдресногоЭлемента(ВыбранноеЗначение.Код);
	Элемент.Значение = СокрЛП(АдреснаяЗапись.Наименование) + " " + СокрЛП(АдреснаяЗапись.Сокращение);
	АдресЗаполнитьРодителей(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле1, АдреснаяЗапись);
	СформироватьПредставление();

КонецПроцедуры

Процедура КорЛитПриИзменении(Элемент)
	
	Поле10 = СЗДом + Символы.ПС + КорЛит + Символы.ПС + Кв;
	СформироватьПредставление();
	
КонецПроцедуры

Функция ПолучитьИзПоля10(ЧтоИскать)

	СтрокаДом	= СтрПолучитьСтроку(Поле10, 1);
	СтрокаКор	= СтрПолучитьСтроку(Поле10, 2);
	СтрокаКв	= СтрПолучитьСтроку(Поле10, 3);
	
	Если ЧтоИскать = "КорЛит" Тогда
		Возврат ?(ПустаяСтрока(СтрокаКор), "корпус ", СтрокаКор);
	ИначеЕсли ЧтоИскать = "Кв" Тогда
		Возврат ?(ПустаяСтрока(СтрокаКв), "кв.", СтрокаКв);
	ИначеЕсли ЧтоИскать = "Дом" Тогда
		Возврат ?(ПустаяСтрока(СтрокаДом), "дом № ", СтрокаДом);
	КонецЕсли;
	
КонецФункции

Процедура РайонПриИзменении(Элемент)
	СформироватьПредставление();
КонецПроцедуры

Процедура КнопкаЭкраннаяКлаваНажатие(Элемент)
	
	ИнтерфейсРМ.ЭкраннаяКлавиатура();
	
	ТекущийЭлемент = ЭлементыФормы.Улица;
	
КонецПроцедуры

Процедура КнопкаЗакрытьНажатие(Элемент)
	
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

Процедура УлицаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	АдресАвтоПодборПоКлассификатору(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, 5);
	
КонецПроцедуры

Процедура УлицаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	АдресОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, 5)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

СписокВозможныхЗначенийКорЛит = ЭлементыФормы.КорЛит.СписокВыбора;
СписокВозможныхЗначенийКорЛит.Добавить("корпус ", "Корпус");
СписокВозможныхЗначенийКорЛит.Добавить("лит. ", "Литера");
СписокВозможныхЗначенийКорЛит.Добавить("другое ", "другое");

СписокВозможныхЗначенийКв = ЭлементыФормы.Кв.СписокВыбора;
СписокВозможныхЗначенийКв.Добавить("кв.", "Квартира");
СписокВозможныхЗначенийКв.Добавить("пом.", "Помещение");
СписокВозможныхЗначенийКв.Добавить("оф.", "Офис");
СписокВозможныхЗначенийКв.Добавить("другое ", "другое");

СписокВозможныхЗначенийДом = ЭлементыФормы.СЗДом.СписокВыбора;
СписокВозможныхЗначенийДом.Добавить("дом № ", "Дом");
СписокВозможныхЗначенийДом.Добавить("другое", "другое");


