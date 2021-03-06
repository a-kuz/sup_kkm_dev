﻿
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ЭтоГруппа Тогда
		ПровСсылка = Ссылка;
		Если ЗначениеЗаполнено(КодДоступа) И НЕ ПроверкаУникальностиРеквизитаСправочника(ПровСсылка, "КодДоступа", КодДоступа) Тогда
			Сообщить("Код доступа уже использован у "+ПровСсылка.Наименование , СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Наименование) Тогда
			Сообщить("Не заполнено сокращенно!",СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;	
		
		Если НЕ ЗначениеЗаполнено(ФИО) Тогда
			Сообщить("Не заполнено ФИО!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		
		Если ПраваДоступа.Найти(Справочники.НаборыПравДоступа.ПустаяСсылка()) <> Неопределено Тогда
			ПраваДоступа.Очистить();
			Нов = ПраваДоступа.Добавить();
			Нов.МестоРеализации = Справочники.МестаРеализации.Мяснов;
			Нов.НаборПрав = Справочники.НаборыПравДоступа.НайтиПоНаименованию("Касса");
			Нов = ПраваДоступа.Добавить();
			Нов.МестоРеализации = Справочники.МестаРеализации.Отдохни;
			Нов.НаборПрав = Справочники.НаборыПравДоступа.НайтиПоНаименованию("Касса");
			Нов = ПраваДоступа.Добавить();
			Нов.МестоРеализации = Справочники.МестаРеализации.КМ;
			Нов.НаборПрав = Справочники.НаборыПравДоступа.НайтиПоНаименованию("Касса");
			Нов = ПраваДоступа.Добавить();
			Нов.МестоРеализации = Справочники.МестаРеализации.Ресторан;
			Нов.НаборПрав = Справочники.НаборыПравДоступа.НайтиПоНаименованию("Касса");

		КонецЕсли;
		
	КонецЕсли;	
	
КонецПроцедуры

#Если Клиент Тогда
	
///////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ОТЧЕТОВ

// Возвращает доступные отчеты в зависимости от версии.
//
// Параметры:
//  Нет.
//
// Вовращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати.
//  
Функция ПолучитьСписокОтчетов() Экспорт
	
	СписокОтчетов = Новый СписокЗначений;
	СписокОтчетов.Добавить("ОтчетПоРасходу",		"Отчет по расходу");
	Если глВерсия>1 Тогда
		СписокОтчетов.Добавить("ОтчетПоРасходуСпецифик","Отчет по расходу специфик");
	КонецЕсли;
	СписокОтчетов.Добавить("ОтчетПоВозвратам",		"Отчет по возвратам");
	СписокОтчетов.Добавить("ОтчетПоСебестоимости",	"Отчет по себестоимости блюд");
	СписокОтчетов.Добавить("ОтчетПоУдалениям",		"Отчет по удалениям");
	СписокОтчетов.Добавить("ОтчетПоВыручке",		"Отчет по выручке");
	СписокОтчетов.Добавить("ОтчетПоСкидкамНаценкам","Отчет по скидкам наценкам");
	Если глВерсия>1 Тогда
		СписокОтчетов.Добавить("СтопЛист","Анализ стоп-листа"); 
		СписокОтчетов.Добавить("АнализВремениОбслуживания","Анализ времени обслуживания");
	КонецЕсли;

	ЗаполнитьСписокОбработок(СписокОтчетов, Перечисления.ВидыОбработок.ВнешнийОтчет, "Справочник.Товары", Истина, Ложь);
	Возврат СписокОтчетов;
	
КонецФункции

// Строит отчет с предопределенными группировками.
//
Процедура СформироватьОтчет(ТипОтчета, ОбъектОтчета) Экспорт 
	
	Если ОбъектОтчета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отчет = Отчеты[ТипОтчета].Создать();
	
	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Отчет.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	Отчет.ДатаС = ДобавитьМесяц(ТекущаяДата(), -1);
	Отчет.ДатаПо  = КонецДня(ТекущаяДата());
	Отчет.Период = ПредставлениеПериода(Отчет.ДатаС,Отчет.ДатаПо);
	
	// установим группировки НашаНоменклатура и НашаХарактеристика
	ТаблицаГруппировокСтроки = ФормированиеОтчетов.ПолучитьПустуюТаблицуНастроекОтчета("Группировки");
	
	НоваяСтрока = ТаблицаГруппировокСтроки.Добавить();
	Если НЕ ТипОтчета = "СтопЛист" И НЕ ТипОтчета = "АнализВремениОбслуживания" Тогда
		НоваяСтрока.Поле           = "Официант";
	ИначеЕсли ТипОтчета = "АнализВремениОбслуживания" Тогда
		НоваяСтрока.Поле           = "АвторЗаказано";
	Иначе
		НоваяСтрока.Поле           = "Автор";
	КонецЕсли;
		
	НоваяСтрока.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	
	// заполним отборы
	ТаблицаОтборов = ФормированиеОтчетов.ПолучитьПустуюТаблицуНастроекОтчета("Отбор");
	
	НоваяСтрока = ТаблицаОтборов.Добавить();
	Если НЕ ТипОтчета = "СтопЛист" И НЕ ТипОтчета = "АнализВремениОбслуживания" Тогда
		НоваяСтрока.Поле           = "Официант";
	ИначеЕсли ТипОтчета = "АнализВремениОбслуживания" Тогда
		НоваяСтрока.Поле           = "АвторЗаказано";
	Иначе
		НоваяСтрока.Поле           = "Автор";
	КонецЕсли;
	Если ОбъектОтчета.ЭтоГруппа Тогда
		НоваяСтрока.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
	Иначе
		НоваяСтрока.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	НоваяСтрока.Значение     = ОбъектОтчета.Ссылка;
	
	ФормированиеОтчетов.СформироватьОтчетПоПараметрам(Отчет, ТаблицаГруппировокСтроки, , ТаблицаОтборов);
	
КонецПроцедуры

#КонецЕсли

