﻿
Перем мОбработкаТайпинга;
Перем мТекстТайпинга;
Перем мПоследнееЗначениеЭлементаТайпинга;
Перем мСтруктураИзмерений Экспорт;
Перем мПромежуточныйАдресЗаПределамиРФ;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура формирует строковое представление адреса.
//
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

// Процедура обслуживает событие изменения типа адреса
// Российский адрес и Адрес за пределами РФ
// 
// Параметры
//  НЕТ
//
Процедура ПриИзмененииТипаАдреса()

	Если ПроизвольныйАдрес Тогда
		ЭлементыФормы.ПанельАдреса.ТекущаяСтраница = ЭлементыФормы.ПанельАдреса.Страницы.ПроизвольныйАдрес;
	Иначе
		ЭлементыФормы.ПанельАдреса.ТекущаяСтраница = ЭлементыФормы.ПанельАдреса.Страницы.РегламентированныйАдрес;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Процедура вызывается при открытии формы.
//
Процедура ПриОткрытии()
	
	Если ЗначениеЗаполнено(глРабочееМесто) Тогда
		ЭлементыФормы.ДействияФормы.Видимость = Ложь;
	КонецЕсли; 
	
	ПроизвольныйАдрес = НЕ ЭтоНовый() И (Поле1+Поле2+Поле3+Поле4+Поле5+Поле6+Поле7+Поле8+Поле9+Поле10 = "");
	ПриИзмененииТипаАдреса();
	
	Если ПроизвольныйАдрес Тогда
		ТекущийЭлемент = ЭлементыФормы.Представление1;
	Иначе
		ТекущийЭлемент = ЭлементыФормы.Улица;
	КонецЕсли;
	
	//мПоследнееЗначениеЭлементаТайпинга = ;
	
	КорЛит	= ПолучитьИзПоля10("КорЛит");
	Кв		= ПолучитьИзПоля10("Кв");
	СЗДом	= ПолучитьИзПоля10("Дом");

КонецПроцедуры

// Процедура вызывается при ПослеЗаписи формы.
//
Процедура ПослеЗаписи()
	
	ОповеститьОЗаписиНовогоОбъекта(Ссылка);
	
КонецПроцедуры

// Процедура вызывается при ПередЗаписью формы.
//
Процедура ПередЗаписью(Отказ)
	
	Если ПроизвольныйАдрес Тогда
		Для а = 1 По 10 Цикл
			ЭтотОбъект["Поле" + Строка(а)] = "";
		КонецЦикла;
	Иначе
		СформироватьПредставление();
	КонецЕсли;
	
	Если Представление="" Тогда
		Предупреждение("Адрес пустой");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Процедура - обработчик события "ЗагрузитьАК" командной панели "ДействияФормы".
//
Процедура ДействияФормыЗагрузитьАК(Кнопка)

	РегистрыСведений.АдресныйКлассификатор.ПолучитьФорму("ФормаЗагрузкиАдресногоКлассификатора").Открыть();

КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" элемента формы "РоссийскийАдрес".
//
Процедура РоссийскийАдресПриИзменении(Элемент)
	
	ПриИзмененииТипаАдреса();
	
	Если ПроизвольныйАдрес Тогда
		Если ПустаяСтрока(Представление) Тогда
			Представление = мПромежуточныйАдресЗаПределамиРФ;
			мПромежуточныйАдресЗаПределамиРФ = "";
		КонецЕсли;
	Иначе
		мПромежуточныйАдресЗаПределамиРФ = Представление;
		СформироватьПредставление();
	КонецЕсли;
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Регион".
//
Процедура РегионПриИзменении(Элемент)
	
	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Район".
//
Процедура РайонПриИзменении(Элемент)
	
	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Город".
//
Процедура ГородПриИзменении(Элемент)
	
	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "НаселенныйПункт".
//
Процедура НаселенныйПунктПриИзменении(Элемент)
	
	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Улица".
//
Процедура УлицаПриИзменении(Элемент)
	
	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();
	
КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Дом".
//
Процедура ДомПриИзменении(Элемент)

	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Корпус".
//
Процедура КорпусПриИзменении(Элемент)

	Если КорЛит = "корпус " Тогда
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле8);
	Иначе
		Поле1 = киПолучитьИндекс(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, "");
	КонецЕсли;
	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Квартира".
//
Процедура КвартираПриИзменении(Элемент)

	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "ПриИзменении" поля ввода "Индекс".
//
Процедура ИндексПриИзменении(Элемент)

	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "Регион".
//
Процедура РегионНачалоВыбора(Элемент, СтандартнаяОбработка)

	ФормаВыбора = РегистрыСведений.АдресныйКлассификатор.ПолучитьФорму("ФормаВыбора", Элемент,);
	ФормаВыбора.НазваниеЭлемента = СокрЛП(Поле2);
	ФормаВыбора.ОтобратьТолькоРегионы();
	ФормаВыбора.Открыть();

КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "Район".
//
Процедура РайонНачалоВыбора(Элемент, СтандартнаяОбработка)

	ФормаВыбора = РегистрыСведений.АдресныйКлассификатор.ПолучитьФорму("ФормаВыбора", Элемент,);
	ФормаВыбора.НазваниеЭлемента = СокрЛП(Поле3);
	ФормаВыбора.УстановитьРодителя(Поле2, "", "", "");
	ФормаВыбора.ОтобратьТолькоРайоны();
	ФормаВыбора.Открыть();

КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "Город".
//
Процедура ГородНачалоВыбора(Элемент, СтандартнаяОбработка)

	ФормаВыбора = РегистрыСведений.АдресныйКлассификатор.ПолучитьФорму("ФормаВыбора", Элемент,);
	ФормаВыбора.НазваниеЭлемента = СокрЛП(Поле4);
	ФормаВыбора.УстановитьРодителя(Поле2, Поле3, "", "");
	ФормаВыбора.ОтобратьТолькоГорода();
	ФормаВыбора.Открыть();

КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "НаселенныйПункт".
//
Процедура НаселенныйПунктНачалоВыбора(Элемент, СтандартнаяОбработка)

	ФормаВыбора = РегистрыСведений.АдресныйКлассификатор.ПолучитьФорму("ФормаВыбора", Элемент,);
	ФормаВыбора.НазваниеЭлемента = СокрЛП(Поле5);
	ФормаВыбора.УстановитьРодителя(Поле2, Поле3, Поле4, "");
	ФормаВыбора.ОтобратьТолькоНаселенныеПункты();
	ФормаВыбора.Открыть();

КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" поля ввода "Улица".
//
Процедура УлицаНачалоВыбора(Элемент, СтандартнаяОбработка)

	ФормаВыбора = РегистрыСведений.АдресныйКлассификатор.ПолучитьФорму("ФормаВыбора", Элемент,);
	ФормаВыбора.НазваниеЭлемента = СокрЛП(Поле6);
	ФормаВыбора.УстановитьРодителя(Поле2, Поле3, Поле4, Поле5);
	ФормаВыбора.ОтобратьТолькоУлицы();
	ФормаВыбора.Открыть();

КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" поля ввода "Регион".
//
Процедура РегионОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АдреснаяЗапись = киПолучитьСтруктуруАдресногоЭлемента(ВыбранноеЗначение.Код);
	Элемент.Значение = СокрЛП(АдреснаяЗапись.Наименование) + " " + СокрЛП(АдреснаяЗапись.Сокращение);
	АдресЗаполнитьРодителей(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле1, АдреснаяЗапись);
	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" поля ввода "Район".
//
Процедура РайонОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АдреснаяЗапись = киПолучитьСтруктуруАдресногоЭлемента(ВыбранноеЗначение.Код);
	Элемент.Значение = СокрЛП(АдреснаяЗапись.Наименование) + " " + СокрЛП(АдреснаяЗапись.Сокращение);
	АдресЗаполнитьРодителей(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле1, АдреснаяЗапись);
	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" поля ввода "Город".
//
Процедура ГородОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АдреснаяЗапись = киПолучитьСтруктуруАдресногоЭлемента(ВыбранноеЗначение.Код);
	Элемент.Значение = СокрЛП(АдреснаяЗапись.Наименование) + " " + СокрЛП(АдреснаяЗапись.Сокращение);
	АдресЗаполнитьРодителей(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле1, АдреснаяЗапись);
	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" поля ввода "НаселенныйПункт".
//
Процедура НаселенныйПунктОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АдреснаяЗапись = киПолучитьСтруктуруАдресногоЭлемента(ВыбранноеЗначение.Код);
	Элемент.Значение = СокрЛП(АдреснаяЗапись.Наименование) + " " + СокрЛП(АдреснаяЗапись.Сокращение);
	АдресЗаполнитьРодителей(Поле2, Поле3, Поле4, Поле5, Поле6, Поле7, Поле1, АдреснаяЗапись);
	СформироватьПредставление();

КонецПроцедуры

// Процедура - обработчик события "ОбработкаВыбора" поля ввода "Улица".
//
Процедура УлицаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		АдреснаяЗапись = ВыбранноеЗначение;
	Иначе
		АдреснаяЗапись = киПолучитьСтруктуруАдресногоЭлемента(ВыбранноеЗначение.Код);
	КонецЕсли; 
	
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
	
КонецФункции // ПолучитьИзПоля10("КорЛит")

Процедура РайонГородаПриИзменении(Элемент)
	СформироватьПредставление();
КонецПроцедуры

Процедура УлицаАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка)
	
	АдресАвтоПодборПоКлассификатору(Элемент, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, 5);
	
КонецПроцедуры

Процедура УлицаОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	АдресОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, 5)
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

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
