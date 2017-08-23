﻿&НаКлиенте
Перем ТекДанные,мПутьКОбработке;
&НаКлиенте
Процедура Сохранить(Команда)
	// Вставить содержимое обработчика.
	ТекДанные.ЗначениеПараметра = СписокЗначений.Скопировать();
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	мПутьКОбработке = ВладелецФормы.мПутьКОбработке;
	ТекДанные = ВладелецФормы.ПараметрыЗапроса.НайтиПоИдентификатору(ВладелецФормы.Элементы.ПараметрыЗапроса.ТекущаяСтрока);
    Массив = ТекДанные.ДопустимыеТипы.Типы();
	Если Массив.Количество()>0 Тогда
		СписокЗначений.ТипЗначения = ТекДанные.ДопустимыеТипы;
	КонецЕсли;
	Если ТипЗнч(ТекДанные.ЗначениеПараметра) = Тип("СписокЗначений") Тогда
		СписокЗначений = ТекДанные.ЗначениеПараметра.Скопировать();
		Если СписокЗначений.Количество()>0 Тогда
			Массив.Добавить(ТипЗнч(СписокЗначений[0].Значение));
		КонецЕсли;
	Иначе	
		Если ЗначениеЗаполнено(ТекДанные.ЗначениеПараметра) Тогда
			СписокЗначений.Добавить(ТекДанные.ЗначениеПараметра);
		КонецЕсли;
		Массив.Добавить(ТипЗнч(ТекДанные.ЗначениеПараметра));
	КонецЕсли;	
	ТипЗначенияПараметра = ТекДанные.ДопустимыеТипы;
	ЭтаФорма.Заголовок = "Список значений параметра " + ТекДанные.ИмяПараметра;
	УстановитьКомандуПодбора(ТипЗначенияПараметра.Типы().Количество()=1);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКомандуПодбора(ВыбранТип)
	Элементы.СписокЗначенийКоманднаяПанель.ПодчиненныеЭлементы.Найти("СписокЗначенийПодборПольз").Видимость = НЕ ВыбранТип;
	Элементы.СписокЗначенийКоманднаяПанель.ПодчиненныеЭлементы.Найти("СписокЗначенийПодбор").Видимость = ВыбранТип;
	Элементы.СписокЗначенийКоманднаяПанель.ПодчиненныеЭлементы.Найти("ВыбратьТип").Видимость = ВыбранТип;

КонецПроцедуры // УстановитьКомандуПодбора()


&НаКлиенте
Процедура СписокЗначенийПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НЕ НоваяСтрока ИЛИ Копирование Тогда Возврат КонецЕсли;
	
	НовСтрока = СписокЗначений.НайтиПоИдентификатору(Элементы.СписокЗначений.ТекущаяСтрока);
	НовСтрока.Значение = ТипЗначенияПараметра.ПривестиЗначение();
	
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуСовместимость82(ИмяОткрываемойФормы,СтруктураПараметров = Неопределено,МодульРезультата = "") Экспорт
	
	Если ВладелецФормы.ВладелецФормы.Это82() Тогда
		Результат = ОткрытьФормуМодально(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма);
		Если МодульРезультата <> "" Тогда
			Выполнить(МодульРезультата+"(Результат,Неопределено)");
		КонецЕсли;
	Иначе
		Если МодульРезультата <> "" Тогда
			ОписаниеОповещения = Неопределено;
			Выполнить("ОписаниеОповещения = Новый ОписаниеОповещения(МодульРезультата,ЭтаФорма)");
			Выполнить("ОткрытьФорму(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)");
		Иначе
			Выполнить("ОткрытьФорму(ИмяОткрываемойФормы,СтруктураПараметров,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца)");
		КонецЕсли;
	КонецЕсли;
	

КонецПроцедуры // ОткрытьФормуСовместимость82()


&НаКлиенте
Процедура НачалоВыбораЗавершение(Результат,ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Данные = СписокЗначений.НайтиПоИдентификатору(Элементы.СписокЗначений.ТекущаяСтрока);
		Данные.Значение = Результат;
	КонецЕсли;
КонецПроцедуры // НачалоВыбораЗавершение()

&НаКлиенте
Процедура СписокЗначенийЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Элементы.СписокЗначенийЗначение.ВыбиратьТип = Элементы.СписокЗначений.ТекущиеДанные.Значение = Неопределено;
	Если Элементы.СписокЗначенийЗначение.ВыбиратьТип Тогда
		ПараметрыИсходящие = Новый Структура("ВыбираемыеТипы",ТипЗначенияПараметра);
		СтандартнаяОбработка = Ложь;
		ОткрытьФормуСовместимость82(мПутьКОбработке+".ВыборТипаУпр",ПараметрыИсходящие,"НачалоВыбораЗавершение");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подбор(Команда)
	//Если вызывается, значит тип не выбран
	ПараметрыИсходящие = Новый Структура("ВыбираемыеТипы",ТипЗначенияПараметра);
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуСовместимость82(мПутьКОбработке+".ВыборТипаУпр",ПараметрыИсходящие,"ВыбранТипДляПодбора");
КонецПроцедуры    

&НаКлиенте
Процедура ВыбранТипДляПодбора(Результат,ДополнительныеПараметры) Экспорт
	Если Результат<>Неопределено Тогда
		МассивТипов = Новый Массив;
		МассивТипов.Добавить(ТипЗнч(Результат));
		СписокЗначений.ТипЗначения = Новый ОписаниеТипов(МассивТипов);
		УстановитьКомандуПодбора(Истина);
		Элементы.СписокЗначенийКоманднаяПанель.ПодчиненныеЭлементы.Найти("СписокЗначенийПодбор")
	КонецЕсли;
КонецПроцедуры // ВыбранТипДляПодбора()
