﻿Перем мСтруктураХраненияСРазмерами;

Процедура КоманднаяПанель1КонсольЗапросов(Кнопка)
	
	Если Не ЗначениеЗаполнено(ЭлементыФормы.Результат.ПолучитьТекст()) Тогда
		ОбновитьЗапрос();
	КонецЕсли; 
	ТекстЗапроса = ЭлементыФормы.Результат.ПолучитьТекст();
	Если Не ЗначениеЗаполнено(ТекстЗапроса) Тогда
		Возврат;
	КонецЕсли;
	Если ЭтоТекстSDBL И ПереводитьВМета Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = ТекстЗапроса;
		Для Каждого СтрокаПараметра Из Параметры Цикл
			Запрос.Параметры.Вставить(СтрокаПараметра.Имя, СтрокаПараметра.Значение);
		КонецЦикла;
		ирОбщий.ОтладитьЛкс(Запрос);
	Иначе
		////СоединениеADO = ПодключенияИис.ПолучитьСоединениеADOПоСсылкеИис(Инфобаза.ИнфобазаСУБД,, Ложь);
		//СоединениеADO = Новый COMОбъект("ADODB.Connection");
		//ирОбщий.ОтладитьЛкс(СоединениеADO,, ТекстЗапроса);
		ирОбщий.ОткрытьЗапросСУБДЛкс(ТекстЗапроса,, Параметры);
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель1ОбновитьЗапрос(Кнопка)
	
	ОбновитьЗапрос();
	
КонецПроцедуры

Процедура ОбновитьЗапрос()
	
	лТипСУБД = ТипСУБД;
	Если ЭтоТекстSDBL Тогда
		лТипСУБД = "";
	КонецЕсли; 
	Индексы.Очистить();
	СтруктураЗапроса = ПолучитьСтруктуруЗапросаИзТекстаБД(ЭлементыФормы.ТекстБД.ПолучитьТекст(), лТипСУБД, ПересобратьТекст, ПереводитьИндексы, ПереводитьВМета,, ВстраиватьПараметры);
	Граница1 = 0; Граница2 = 0; Граница3 = 0; Граница4 = 0;
	ЭлементыФормы.Результат.ПолучитьГраницыВыделения(Граница1, Граница2, Граница3, Граница4);
	ЭлементыФормы.Результат.УстановитьТекст(СтруктураЗапроса.Текст);
	ЭлементыФормы.Результат.УстановитьГраницыВыделения(Граница1, Граница2, Граница3, Граница4);
	Если ЗначениеЗаполнено(СтруктураЗапроса.Текст) Тогда
		ПанельОсновная = ЭлементыФормы.ПанельОсновная;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(ПанельОсновная.ТекущаяСтраница, ПанельОсновная.Страницы.Результат);
	КонецЕсли; 
	ЭтаФорма.Параметры = СтруктураЗапроса.Параметры;
	ЭтаФорма.Таблицы.Очистить();
	ирОбщий.ЗагрузитьВТаблицуЗначенийЛкс(СтруктураЗапроса.Таблицы, ЭтаФорма.Таблицы);
	СтруктураХраненияБД = ирКэш.ПолучитьСтруктуруХраненияБДЛкс(Не ЭтоТекстSDBL,, мАдресЧужойСхемыБД);
	мСтруктураХраненияСРазмерами = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирСтруктураХраненияБД");
	мСтруктураХраненияСРазмерами.ПоказыватьСУБД = Не ЭтоТекстSDBL;
	мСтруктураХраненияСРазмерами.ПоказыватьSDBL = ЭтоТекстSDBL;
	мСтруктураХраненияСРазмерами.ПоказыватьРазмеры = ПоказыватьРазмеры;
	мСтруктураХраненияСРазмерами.ОбновитьТаблицы();
	Для Каждого СтрокаТаблицыБД Из Таблицы Цикл
		СтрокаСтруктурыХрания = СтруктураХраненияБД.Найти(СтрокаТаблицыБД.ИмяБД, "КраткоеИмяТаблицыХранения");
		Если СтрокаСтруктурыХрания <> Неопределено Тогда
			СтрокаТаблицыБД.ИмяБД = СтрокаСтруктурыХрания.ИмяТаблицыХранения;
		КонецЕсли; 
		СтрокаСтруктурыХрания = мСтруктураХраненияСРазмерами.Таблицы.Найти(СтрокаТаблицыБД.ИмяБД, "ИмяТаблицыХранения");
		Если СтрокаСтруктурыХрания <> Неопределено Тогда
			СтрокаТаблицыБД.КоличествоСтрок = СтрокаСтруктурыХрания.КоличествоСтрок;
			СтрокаТаблицыБД.ДанныеKB = СтрокаСтруктурыХрания.РазмерЗаписи;
			СтрокаТаблицыБД.ИндексыKB = СтрокаСтруктурыХрания.РазмерИндексы;
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.Таблицы.Колонки.КоличествоСтрок.Видимость = Не ирКэш.ЭтоФайловаяБазаЛкс();
	ЭтоТекстSDBLПриИзменении();
	ОбновитьЗапрос();
	ОбновитьДоступность();
	ПодключитьОбработчикОжидания("ОбновитьРазмерТекста", 2);
	
КонецПроцедуры

Процедура ПанельОсновнаяПриСменеСтраницы(Элемент = Неопределено, ТекущаяСтраница = Неопределено)
	
	Если Не ЗначениеЗаполнено(ЭлементыФормы.Результат.ПолучитьТекст()) Тогда
		Если ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Результат Тогда
			ОбновитьЗапрос();
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПараметрыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = Элемент.Колонки.Значение И ЗначениеЗаполнено(ВыбраннаяСтрока.Метаданные) Тогда
		ОткрытьЗначение(ВыбраннаяСтрока.Значение);
	Иначе
		Если Ложь
			Или Не ЗначениеЗаполнено(ВыбраннаяСтрока.ЗначениеSDBL)
			Или Не ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы.Результат, ВыбраннаяСтрока.ЗначениеSDBL) 
		Тогда 
			ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы.Результат, ВыбраннаяСтрока.Имя);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ирОбщий.ОбновитьЗаголовкиСтраницПанелейЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ТаблицыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	КонтекстноеМенюТаблицНайтиВТексте();
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура ТипСУБДПриИзменении(Элемент)
	
	ОбновитьЗапрос();
	
КонецПроцедуры

Процедура КоманднаяПанель1НовоеОкно(Кнопка)
	
	Форма = ПолучитьФорму("КонверторТекстаСУБД",, Новый УникальныйИдентификатор);
	Форма.Открыть();

КонецПроцедуры

Процедура ДействияФормыВыполнить(Кнопка)
	
	ОбновитьЗапрос();
	//ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Результат;
	
КонецПроцедуры

Процедура ОбновитьРазмерТекста()
	
	ЭтаФорма.КоличествоСимволов = СтрДлина(ЭлементыФормы.ТекстБД.ПолучитьТекст());
	
КонецПроцедуры

Процедура ЭтоТекстSDBLПриИзменении(Элемент = Неопределено)
	
	ЭлементыФормы.ТипСУБД.Доступность = Не ЭтоТекстSDBL;
	
КонецПроцедуры

Процедура НастроитьТехножурналПоТексту(Кнопка)
	
	ОткрытьНастройкуТехножурналаДляРегистрацииВыполненияЗапроса(ЭлементыФормы.ТекстБД.ПолучитьТекст(), ЭтоТекстSDBL, ТипСУБД);

КонецПроцедуры

Функция ПолучитьТекстДляПоискаВТехножурнале()
	
	Результат = ЭлементыФормы.ТекстБД.ПолучитьТекст();
	Если Не ЭтоТекстSDBL Тогда
		Результат = ПолучитьТекстSQLДляПоискаВТехножурнале(Результат);
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Процедура НайтиВТаблицеТехножурнала(Кнопка)
	
	Если ЭтоТекстSDBL Тогда
		ИмяЭлементаОтбора = "ТекстSDBL";
	Иначе
		ИмяЭлементаОтбора = "ТекстСУБД";
	КонецЕсли; 
	ТекстПоиска = ПолучитьТекстДляПоискаВТехножурнале();
	//ФормаЖурнала = ВладелецФормы;
	ФормаЖурнала = ПолучитьФорму();
	ФормаЖурнала.УстановитьРежимИтогов(Ложь);
	ФормаЖурнала.ЭлементыФормы.ТаблицаЖурнала.ОтборСтрок.Сбросить();
	ЭлементОтбора = ФормаЖурнала.ЭлементыФормы.ТаблицаЖурнала.ОтборСтрок[ИмяЭлементаОтбора];
	ЭлементОтбора.ВидСравнения = ВидСравнения.Содержит;
	ЭлементОтбора.Значение = ТекстПоиска;
	ЭлементОтбора.Использование = Истина;
	ФормаЖурнала.Открыть();

КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ТаблицыПриАктивизацииСтроки(Элемент)
	
	ТекущаяСтрокаТаблиц = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Индексы.Очистить();
	Если ТекущаяСтрокаТаблиц = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтруктуруХраненияБД = ирКэш.ПолучитьСтруктуруХраненияБДЛкс(Не ЭтоТекстSDBL,, мАдресЧужойСхемыБД);
	КлючПоиска = Новый Структура("КраткоеИмяТаблицыХранения", НРег(ТекущаяСтрокаТаблиц.ИмяБД));
	НайденныеСтроки = СтруктуруХраненияБД.НайтиСтроки(КлючПоиска);
	Если НайденныеСтроки.Количество() > 0 Тогда
		СтрокаТаблицыХранения = НайденныеСтроки[0];
		Для Каждого ИндексТаблицыБД Из СтрокаТаблицыХранения.Индексы Цикл
			СтрокаИндекса = Индексы.Добавить();
			СтрокаИндекса.ИндексМета = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(ИндексТаблицыБД,, СтрокаТаблицыХранения, Ложь);
			СтрокаИндекса.ИндексБД = ирОбщий.ПолучитьПредставлениеИндексаХраненияЛкс(ИндексТаблицыБД,, СтрокаТаблицыХранения, Истина);
			СтрокаИндекса.ИмяХранения = ИндексТаблицыБД.ИмяИндексаХранения;
		КонецЦикла;
		Индексы.Сортировать("ИндексМета");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИндексыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ТекущаяСтрокаТаблиц = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если ТекущаяСтрокаТаблиц = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТекущаяСтрокаИндексов = ЭлементыФормы.Индексы.ТекущаяСтрока;
	Если ТекущаяСтрокаИндексов = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	//Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирСтруктураХраненияБД.Форма");
	Форма = мСтруктураХраненияСРазмерами.ПолучитьФорму();
	Форма.ПараметрИмяТаблицы = ТекущаяСтрокаТаблиц.ИмяМета;
	Форма.ПараметрИмяИндексаХранения = ТекущаяСтрокаИндексов.ИмяХранения;
	Форма.ПараметрПоказыватьSDBL = Истина;
	Форма.ПараметрПоказыватьСУБД = Ложь;
	Форма.Открыть();

КонецПроцедуры

Процедура КоманднаяПанель1ПоказатьСтруктуруХранения(Кнопка)
	
	ТекущаяСтрокаТаблиц = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если ТекущаяСтрокаТаблиц = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	//Форма = ирОбщий.ПолучитьФормуЛкс("Обработка.ирСтруктураХраненияБД.Форма");
	Форма = мСтруктураХраненияСРазмерами.ПолучитьФорму();
	Форма.ПараметрИмяТаблицы = ТекущаяСтрокаТаблиц.ИмяМета;
	Форма.ПараметрПоказыватьSDBL = ЭтоТекстSDBL;
	Форма.ПараметрПоказыватьСУБД = Не ЭтоТекстSDBL;
	Форма.Открыть();
	
КонецПроцедуры

Процедура КонтекстноеМенюТаблицНайтиВТексте(Кнопка = Неопределено)
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ТекущаяСтрока = ЭлементыФормы.Таблицы.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если Не ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.ИмяБД) Тогда 
		ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.ИмяМета);
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ДействияФормыСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ПереводитьВМетаПриИзменении(Элемент)
	
	ОбновитьДоступность();
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	ЭлементыФормы.ПереводитьИндексы.Доступность = ПереводитьВМета;
	
КонецПроцедуры

Процедура ПослеВосстановленияЗначений()
	
	ОбновитьДоступность();

КонецПроцедуры

Процедура КонтекстноеМенюКонстантаНайтиВТексте(Кнопка)
	
	ИмяСтраницы = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя;
	ТекущаяСтрока = ЭлементыФормы.Параметры.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Если Ложь
		Или Не ЗначениеЗаполнено(ТекущаяСтрока.ЗначениеSDBL)
		Или Не ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], ТекущаяСтрока.ЗначениеSDBL) 
	Тогда 
		Если ВстраиватьПараметры Тогда
			СтрокаПоиска = ТекущаяСтрока.Значение;
		Иначе
			СтрокаПоиска = ТекущаяСтрока.Имя;
		КонецЕсли; 
		ирОбщий.НайтиПоказатьСтрокуВПолеТекстовогоДокументаЛкс(ЭтаФорма, ЭлементыФормы[ИмяСтраницы], СтрокаПоиска);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭлементыФормы[ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя]);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирАнализТехножурнала.Форма.КонверторТекстаСУБД");
ПереводитьИндексы = Истина;
ПереводитьВМета = Истина;
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("MSSQL");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DBPOSTGRS");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DB2");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("ORACLE");
ЭлементыФормы.ТипСУБД.СписокВыбора.Добавить("DBV8DBENG");
Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда
	ТипСУБД = "DBV8DBENG";
Иначе
	ТипСУБД = "MSSQL";
КонецЕсли; 
