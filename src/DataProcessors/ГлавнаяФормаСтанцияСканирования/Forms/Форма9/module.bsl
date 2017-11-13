﻿#Область ОписаниеПеременных

Перем AutohotkeyDLL;
Перем ФормаСкрытияМеню, фФормаСкрытияМеню;
Перем ОтборФирма;
Перем ХэшПредыдущейВыделеннойСтроки;
Перем КупоныСоответствие Экспорт;

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
КонецПроцедуры

Процедура ПриОткрытии()
	
	//Офлайн
	Если НЕ глПараметрыРМ.ФайловаяИБ Тогда
		
		ПодключитьОбработчикОжидания("ОбновитьВремя",2,1);
		// вызов должен быть в конце обработчика
		ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
		Стиль = БиблиотекаСтилей.СтанцияОплаты;
		ЭлементыФормы.тпТовары.СоздатьКолонки();
		ЭлементыФормы.тпТовары.Колонки.Автор.Видимость = ложь;
		ЭлементыФормы.тпТовары.Колонки.ШК.Видимость = ложь;
		ЭлементыФормы.тпТовары.Колонки.Иконка.ШрифтТекста = Новый Шрифт("FontAwesome",16);
		ЭлементыФормы.тпТовары.Колонки.Иконка.ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
		ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
		ЭлементыФормы.тпТовары.Колонки.фАлкоголь.Видимость = ложь;
		ЭлементыФормы.тпТовары.Колонки.КоличествоНачальное.видимость = Ложь;
		ЭлементыФормы.тпТовары.Колонки.Блок.Видимость = Ложь;
		ЭлементыФормы.тпТовары.Колонки.Фирма.Видимость = Ложь;
		ЭлементыФормы.тпТовары.Колонки.ИдСтроки.Видимость = Ложь;
		ЭлементыФормы.тпТовары.Колонки.ИдСвязаннойСтроки.Видимость = Ложь;
		ЭлементыФормы.тпТовары.Колонки.Статус.Видимость = Ложь;
		ЭлементыФормы.тпТовары.Колонки.СтатусОплаты.Видимость = Ложь;
		
		ЭлементыФормы.тпТовары.Колонки.ЛояльностьГруппаАкции.Видимость = Ложь;
		
		//ЭлементыФормы.тпТовары.ТолькоПросмотр = истина;
		ЭлементыФормы.тпТовары.Шапка = Ложь;
		ЭлементыФормы.тпТовары.ВертикальныеЛинии = Ложь;
		
		ИнтерфейсРМЛояльность.ФормаПриОткрытии(ЭтаФорма);
		ЭлементыФормы.КнопкаПриготовить.Видимость = глПараметрыРМ.ТипТТ = Справочники.ТипыТТ.МОКП;
		Если ОтборФирма Тогда
			ДопПараметрыИнфо.Вставить("ФирмаФильтр", глПараметрыРМ.Фирма);
		Иначе
			ДопПараметрыИнфо.Вставить("ФирмаФильтр", Неопределено);
		КонецЕсли;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Через2СекундыПослеОткрытия",0.5,1);
	
КонецПроцедуры

Процедура Через2СекундыПослеОткрытия() Экспорт

	ЭтаФорма.ТолькоПросмотр = 1;
	
	ПодключитьОбработчикОжидания("ЧерезСекундуПослеАвторизации",0.5,1);
		
КонецПроцедуры

Процедура ЧерезСекундуПослеАвторизации() Экспорт
	ПодключитьОбработчикОжидания("СкрытьМенюИПанели",0.1,1);
КонецПроцедуры

Процедура СкрытьМенюИПанели() Экспорт 
	ПодключитьОбработчикОжидания("ВосстановитьФорму",1,1);
КонецПроцедуры

Процедура ВосстановитьФорму() Экспорт
	Если ФормаСкрытияМеню = Неопределено Тогда
		//Если РежимТестирования Тогда
		//	Возврат;
		//КонецЕсли;
		Если AutohotkeyDLL = Неопределено Тогда
			AutohotkeyDLL = РаботаСокнами.AHK(,"ВосстановитьФорму");
		КонецЕсли;
		
			Cкрипт = "
			|#NoTrayIcon
			|WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame,,15
			|Send {alt down}{shift down}{VK52}{alt up}{shift up}
			|Sleep 100
			|Exitapp";	
			Cкрипт = СтрЗаменить(Cкрипт, "%pid", формат(РаботаСокнами.pid, "ЧГ=0"));
			AutohotkeyDLL.ahkTextDll(Cкрипт);		

			Возврат;
	КонецЕсли;
	Если ФормаСкрытияМеню.Открыта() Тогда
		ПодключитьОбработчикОжидания("ВосстановитьФорму",0.3,1);	
	Иначе
		Если AutohotkeyDLL = Неопределено Тогда
			AutohotkeyDLL = РаботаСокнами.AHK(,"ВосстановитьФорму");
		КонецЕсли;
		AutohotkeyDLL.ahkTextDll("
		|#NoTrayIcon
		|Rest() 
		|{
		|	Send {alt down}{shift down}{VK52}{alt up}{shift up}
		|	sleep 100
		|	Exitapp
		|}");	
		AutohotkeyDLL.ahkFunction("Rest");
		РаботаСокнами.РазблокироватьВвод();
		РаботаСокнами.УбратьЗатемнение();
		AutohotkeyDLL = Неопределено;
		ФормаСкрытияМеню = Неопределено;
		//ЭтаФорма.ТолькоПросмотр = 0;
		
		//Офлайн
		Если глПараметрыРМ.ФайловаяИБ Тогда
			ОбработкаПоиска = ИнтерфейсРМ.ПолучитьОбъектОбработки("ПоискPLU");
			ОбработкаПоиска.ГлавнаяФорма = ЭтаФорма;
			ФормаПоиска = ОбработкаПоиска.ПолучитьФорму("Форма"+глПараметрыРМ.ИнтерфейсТип, ЭтаФорма);
			
			ФормаПоиска.ОткрытьМодально();
		Иначе	
			Заблокировать();
		КонецЕсли;
	КонецЕсли;
	// тестово
	Если фФормаСкрытияМеню = 0 Тогда 
		//ормаСкрытияМеню = фФормаСкрытияМеню + 1;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ДействияПередЗакрытиемФормы(ЭтаФорма, Отказ);
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();	
	AutohotkeyDLL = Неопределено;

КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	Если  Ложь Тогда ЗначениеВыбора = Справочники.Товары.ПустаяСсылка() КонецЕсли;
	Если ТипЗнч(ЗначениеВыбора) = Тип("СправочникСсылка.Товары") Тогда 
		Если Не ЗначениеЗаполнено(ТекКоличество) Или ТекКоличество = 1 Тогда
			
			Если ЗначениеВыбора.ЗапросКоличества Тогда
				ИзменитьКоличество();
			КонецЕсли;
	
		КонецЕсли;
		ВводНовойСтроки(ЗначениеВыбора);
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ИзменениеСмены" Тогда
		//глПараметрыРМ.Вставить("НомерСмены", ИнтерфейсРМ.ТекущаяСмена().Номер);
		фВводТоваровДоступен = ЗначениеЗаполнено(ИнтерфейсРМ.ТекущаяСмена().Номер);
	ИначеЕсли ИмяСобытия = "ИзменениеЗаказаНаСтанцииСканирования" Тогда
		Если НЕ Источник = ЭтаФорма И Параметр = Заказ Тогда
			ОбновитьНадписьИтого();
		КонецЕсли;
	КонецЕсли; 
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормытпТовары

Процедура тпТоварыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ИнтерфейсРМЛояльность.ПоказатьИнформациюОТоваре(ВыбраннаяСтрока.Товар, ЛояльностьДанныеЗаказа, ВыбраннаяСтрока.ИдСтроки);
	
КонецПроцедуры

Процедура тпТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура тпТоварыПослеУдаления(Элемент)
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура тпТоварыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ЦветФонаСтроки = Новый Цвет(254, 254, 254);
	
	Если ДанныеСтроки = Неопределено Тогда
		ОформлениеСтроки.ЦветТекста = ОформлениеСтроки.ЦветФона;
		Возврат;
	КонецЕсли;
	
	Если НЕ Элемент.ТекущаяСтрока = Неопределено И НЕ ДанныеСтроки = Неопределено И ДанныеСтроки.НомерСтроки = Элемент.ТекущаяСтрока.НомерСтроки Тогда
		ОформлениеСтроки.Ячейки.Товар.Шрифт = Новый Шрифт(ОформлениеСтроки.Ячейки.Товар.Шрифт, , , Истина, , , ДанныеСтроки.Количество = 0);
	Иначе
		ОформлениеСтроки.Ячейки.Товар.Шрифт = Новый Шрифт(ОформлениеСтроки.Ячейки.Товар.Шрифт, , , Ложь, , , ДанныеСтроки.Количество = 0);
	КонецЕсли;
	
	Если ДанныеСтроки.фАлкоголь = 1 Тогда
		ОформлениеСтроки.Ячейки.Количество.Шрифт = Новый Шрифт("FontAwesome",24);
		ОформлениеСтроки.Ячейки.Количество.УстановитьТекст(Шрифты.ПолучитьСимвол("glass"));
		ОформлениеСтроки.Ячейки.ЦенаРеализации.ОтображатьТекст = Ложь;
	Иначе
		ОформлениеСтроки.Ячейки.х.УстановитьТекст("х");	
		Если ДанныеСтроки.Количество = 0 Тогда
			ОформлениеСтроки.Ячейки.Количество.УстановитьТекст(ДанныеСтроки.КоличествоНачальное);
			ОформлениеСтроки.Ячейки.ЦенаРеализации.ОтображатьТекст = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеСтроки.Количество Тогда
		ОформлениеСтроки.Ячейки.Равно.УстановитьТекст("=");	
	Иначе 
		ОформлениеСтроки.Шрифт = Новый Шрифт(ОформлениеСтроки.Шрифт,,,,,,Истина); // зачеркнутый
	КонецЕсли;                                                                                   
	Если ДанныеСтроки.Блок Тогда
		ОформлениеСтроки.Ячейки.СуммаРеализации.ЦветФона = ЦветаСтиля.БолееИнтенсивныйЗеленый;
		//ОформлениеСтроки.Ячейки.СуммаРеализации.ЦветФона = ЦветаСтиля.ЦветФонаОплаченнойСтроки;
	Иначе
		ОформлениеСтроки.Ячейки.СуммаРеализации.ЦветФона = ЦветаСтиля.ЦветФонаФормы;
	КонецЕсли;
	Если глПараметрыРМ.ФирмыРМ.Найти(ДанныеСтроки.Фирма) = Неопределено  Тогда
		ОформлениеСтроки.ЦветТекста = Метаданные.ЭлементыСтиля.НеактивнаяКнопка.Значение;
	КонецЕсли;
	
	Если глПараметрыРМ.ТипТТ = Справочники.ТипыТТ.МОКП Тогда
		Если ТоварыДляПриготовления.Найти(ДанныеСтроки.Товар, "Товар") <> Неопределено Тогда
			
					
			Если ДанныеСтроки.Статус = Перечисления.СтатусыПозицийЗаказа.ДляПриготовления Тогда
				ШрифтИконки = Новый Шрифт(ОформлениеСтроки.Ячейки.Иконка.Шрифт,,16);
				ОформлениеСтроки.Ячейки.Иконка.УстановитьТекст(Шрифты.ПолучитьСимвол("check"));
			Иначе
				ШрифтИконки = Новый Шрифт(ОформлениеСтроки.Ячейки.Иконка.Шрифт,,24);
				ОформлениеСтроки.Ячейки.Иконка.УстановитьТекст(Шрифты.ПолучитьСимвол("spoon"));
			КонецЕсли;
			ОформлениеСтроки.Ячейки.Иконка.Шрифт = ШрифтИконки;
			ОформлениеСтроки.Ячейки.Иконка.ВысотаЯчейки = 1;
			
		Иначе
			
		КонецЕсли;
		
	КонецЕсли;

	
КонецПроцедуры

Процедура тпТоварыТоварПриИзменении(Элемент)
	ЗаполнитьЗначенияСвойств(ЭлементыФормы.тпТовары.ТекущиеДанные, ЭлементыФормы.тпТовары.ТекущиеДанные.Товар);
	Если ЭлементыФормы.тпТовары.ТекущиеДанные.фАлкоголь Тогда
		ЭлементыФормы.тпТовары.ТекущиеДанные.ПДФ = ВводПДФ(ЭлементыФормы.тпТовары.ТекущиеДанные.Товар);
	КонецЕсли;
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура тпТоварыПриПолученииДанных(Элемент, ОформленияСтрок) Экспорт 

	ИнтерфейсРМЛояльность.тпТоварыПриПолученииДанных(ЭтаФорма, Элемент, ОформленияСтрок, ЛояльностьДанныеЗаказа);

КонецПроцедуры

Процедура тпТоварыПриАктивизацииСтроки(Элемент)
	
	Попытка
		ТекущийЭлемент = ЭлементыФормы.Плашка11;
	Исключение
	КонецПопытки;
	
	Если глПараметрыРМ.ТипТТ = Справочники.ТипыТТ.МОКП Тогда
		Если ТекущийТоварМожноПриготовить() Тогда
			ЭлементыФормы.КнопкаПриготовить.ЦветТекстаКнопки = ЦветаСтиля.Акцент;
		Иначе
			ЭлементыФормы.КнопкаПриготовить.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаКнопкиАппБара;
		КонецЕсли;
	КонецЕсли;
	
	Элемент.ОбновитьСтроки();
	
	ПодключитьОбработчикОжидания("ОбновитьЗаказНаМонитореГостя", 0.5, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

#Область МенюСправа

Процедура РежимАдминистратораНажатие(Элемент)
	ОткрытьМенюОпераций();
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ВыборТовараНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	ВыборТовараИзМеню();
КонецПроцедуры

Процедура ПоискТовараНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	ОткрытьФормуПоиска();
КонецПроцедуры

Процедура КоличествоНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	ИзменитьКоличество();
	ОбновитьНадписьКоличество();
КонецПроцедуры

Процедура кнВесыНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	МенюВесов(Вес);
КонецПроцедуры

Процедура кнЛояльностьНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	МенюЛояльности();
КонецПроцедуры

Процедура СторноНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	
	ТС = ЭлементыФормы.тпТовары.ТекущаяСтрока;
	Если ТС <> Неопределено Тогда
		НС = ТС.НомерСтроки;
	Иначе
		НС = 0;
	КонецЕсли;
	
	Сторно(НС);
КонецПроцедуры

Процедура ВводКартыГостя(Элемент)
	
	СброситьТекущийДокумент();
	флЗаказОткрыт = Ложь;
	ВводКартыКлиента(флЗаказОткрыт);
	
	Если флЗаказОткрыт Тогда
		Лояльность.ОбновитьПредварительныйРасчетЗаказа(Заказ);
		ГлавнаяФорма.ОбновитьВремя();
		ГлавнаяФорма.ПодключитьОбработчикОжидания("ОбновитьОстальное", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаблокироватьНажатие(Элемент)
	Заблокировать();
КонецПроцедуры

#КонецОбласти

#Область МенюСверху

Процедура гпсПоказатьВсеСтрокиНажатие(Элемент)
	ОтборФирма = Не ОтборФирма;
	Если ОтборФирма Тогда
		ДопПараметрыИнфо.Вставить("ФирмаФильтр", глПараметрыРМ.Фирма);
	Иначе
		ДопПараметрыИнфо.Вставить("ФирмаФильтр", Неопределено);
	КонецЕсли;
	ОбновитьЗаказНаМонитореГостя();
	ИнтерфейсРМЛояльность.ОбновитьТабДокЛояльность(ГлавнаяФорма, , ЛояльностьДанныеЗаказа);
	ОбновитьВремя();
КонецПроцедуры

#КонецОбласти

#Область МенюСнизу

Процедура ОплатаНажатие(Элемент)
	Завершить();
КонецПроцедуры

#КонецОбласти

#Область МенюСлева

Процедура ПлашкаКупонНажатие(Элемент) Экспорт 
	ИнтерфейсРМЛояльность.ПлашкаКупонНажатие(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура Плашка_Н_Нажатие(Элемент) Экспорт 
	ИнтерфейсРМЛояльность.Плашка_Н_Нажатие(ЭтаФорма, Элемент);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область ОтрисовкаИнтерфейса

Процедура ОбновитьВремя() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлементыФормы.АппБар.Высота < 750 и глСтекОкон.Количество() = 1 Тогда
		Если фФормаСкрытияМеню < 10 Тогда
			фФормаСкрытияМеню = фФормаСкрытияМеню + 1;
			
			ФормаСкрытияМеню = Обработки.СкрытьМенюИПанели.ПолучитьФорму();
			Если не ФормаСкрытияМеню.Открыта() Тогда
				ФормаСкрытияМеню.Открыть();	
			КонецЕсли;
			ПодключитьОбработчикОжидания("ОбновитьВремя",10,1);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	тПользователь = ?(ЗначениеЗаполнено(глПользователь), Строка(глПользователь), "Система заблокирована");
	тТекущийРежим = "ПРОДАЖА "; 										
	ТекущаяДатаНаСервере = ТекущаяДатаНаСервере();
	тДата = Формат(ТекущаяДатаНаСервере,"ДФ='ddd, d MMMM'");
	тВремя = Формат(ТекущаяДатаНаСервере,"ДФ=HH:mm");
	тРабочееМесто = глРабочееМесто;		
	
	Если Не глФлагБлокировка Тогда
		тЗаказ = "Заказ  " + НомерТекущегоЗаказа() + Символы.ПС +
		?(ОтборФирма, "По станции", "Весь заказ");
		
		КартаДоступа = Заказ.КартаДоступа;
		Идентификатор2 = КартаДоступа.Идентификатор2;
		Если ЗначениеЗаполнено(Идентификатор2) Тогда
			ИдентификаторКарты = Идентификатор2;
		Иначе
			ИдентификаторКарты = Прав(КартаДоступа.Идентификатор, 5);
		КонецЕсли;			
		тБейдж = "Бейдж " + ИдентификаторКарты;
	Иначе
		тЗаказ = "";
		тБейдж = "";
	КонецЕсли;
	ОбновитьНадписьИтого();
	
	ЭлементыФормы.кнВесы.Доступность = глПараметрыРМ.ВесыЕсть;
	ЭлементыФормы.КнопкаПереключитьФильтр.Заголовок = тЗаказ;
	
	Если глПараметрыРМ.ВесыЕсть Тогда
		Вес = Обработка_Весы.DRV.Вес;
		ОбновитьВес();
	КонецЕсли;
	ПодключитьОбработчикОжидания("ОбновитьВремя",30,1);	
КонецПроцедуры

Процедура ОбновитьНадписьИтого() Экспорт
	
	ОтключитьОбработчикОжидания("ОбновитьНадписьИтого");
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(ТекущийДокумент) <> Тип("ДокументСсылка.Заказ") и ТипЗнч(ТекущийДокумент) <> Тип("ДокументСсылка.Возврат") Тогда
		Возврат;
	КонецЕсли;
	
	ОбновитьНадписьКоличество();
	
	ТД = ЭлементыФормы.тпТовары.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		ТекИдСтроки = Неопределено;
		ТекТовар = Неопределено;
	Иначе
		ТекИдСтроки = ЭлементыФормы.тпТовары.ТекущиеДанные.ИдСтроки;
		ТекТовар = ЭлементыФормы.тпТовары.ТекущиеДанные.Товар;
	КонецЕсли;
	
	// заполним таблицу на форме
	ТекСтрока = Неопределено;
	тпТовары.Очистить();
	Для каждого стр из ТекущийДокумент.Товары Цикл
		Если ОтборФирма И НЕ стр.Фирма = глПараметрыРМ.Фирма Тогда
			Продолжить;
		КонецЕсли;
		НовСтрока = тпТовары.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока,стр);
		НовСтрока.Блок = НЕ стр.ДокументОплаты.Пустая();
		Если НовСтрока.Количество И не НовСтрока.Блок Тогда
			ТекСтрока = НовСтрока;
		КонецЕсли;
	КонецЦикла;
	
	Попытка
		ДатаРождения = Заказ.ДатаРождения;
	Исключение
		ДатаРождения = Дата(1,1,1);
	КонецПопытки;
	
	Если ТекущийРежим = "ВОЗВРАТ" Тогда
		ЭлементыФормы.тпТовары.Видимость = 0;
	Иначе
		ЭлементыФормы.тпТовары.Видимость = 1;
	КонецЕсли;

		
	Если глПараметрыРМ.ТипТТ = Справочники.ТипыТТ.МОКП Тогда
		Если ЗначениеЗаполнено(ТекТовар) Тогда
			Если ТоварыДляПриготовления.Найти(ТекТовар, "Товар")<>Неопределено Тогда
				СтрокаТП = тпТовары.Найти(ТекИдСтроки, "ИдСтроки");
				Если СтрокаТП <> Неопределено Тогда
					ТекСтрока = СтрокаТП
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ТекСтрока <> Неопределено Тогда
		ЭлементыФормы.тпТовары.ТекущаяСтрока = ТекСтрока;
	КонецЕсли;


	ИнтерфейсРМЛояльность.ОбновитьЭлементыФормы(ЭтаФорма,,ЛояльностьДанныеЗаказа);	
	ИнтерфейсРМ.ЗаполнитьПодвал(ЭлементыФормы.ИтогиПоФирмамРМ, Заказ);
	
	ПодключитьОбработчикОжидания("ОбновитьЗаказНаМонитореГостя", 0.5, Истина);
	
КонецПроцедуры

Процедура ОбновитьНадписьКоличество()
	
	Если ТекКоличество <> 0 И Не ТекКоличество = 1 Тогда
		тТекКоличество = ТекКоличество;
		ЭлементыФормы.тТекКоличество.Видимость = 1;		
	Иначе
		ЭлементыФормы.тТекКоличество.Видимость = 0;
	КонецЕсли;
	
КонецПроцедуры


Процедура ОбновитьВес() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	ЭлементыФормы.тВес.Заголовок = Формат(Вес,"ЧДЦ=3; ЧРД=.; ЧН=0.000");
	Если НЕ Заказ.Пустая() Тогда
		ИнтерфейсРМ.ВыводНаИнфоДисплей("ПоказатьВес",,,,,Вес);	
	КонецЕсли;
КонецПроцедуры

Процедура УстановитьДоступностьКнопки(ИмяКнопки, Доступность, Акцент = 0, Свойство = "Доступность") Экспорт
	Кнопка = ЭлементыФормы[ИмяКнопки];
	МассивТеней = Массив(ЭлементыФормы[ИмяКнопки+"Тень"]);
	Тень2 = ЭлементыФормы.Найти(ИмяКнопки+"Тень2");
	Если Не Тень2 = Неопределено Тогда
	
		МассивТеней.Добавить(Тень2);
	
	КонецЕсли; 
	
	ЦветКнопки = ?(Акцент, Метаданные.ЭлементыСтиля.Акцент.Значение, Метаданные.ЭлементыСтиля.ЦветТемы.Значение);
	ЦветФонаНеактивнойКнопки = Метаданные.ЭлементыСтиля.НеактивнаяКнопка.Значение;
	ЦветТекстаНеактивнойКнопки = Метаданные.ЭлементыСтиля.НеактивныйЭлемент.Значение;
	
	Кнопка[Свойство] = Доступность;
	Кнопка.ЦветФонаКнопки 	=  ?(Доступность, ЦветКнопки, ЦветФонаНеактивнойКнопки);
	Кнопка.ЦветТекстаКнопки =  ?(Доступность, WebЦвета.Белый, 	ЦветТекстаНеактивнойКнопки);
	Кнопка.ЦветРамки = Кнопка.ЦветФонаКнопки;
	
	Для каждого Тень Из МассивТеней Цикл
		
		Тень.Видимость = Доступность;
		
	КонецЦикла; 
	
			
КонецПроцедуры

Процедура ОбновитьОстальное() Экспорт
	
	ИнтерфейсРМЛояльность.ОбновитьЭлементыФормы(ЭтаФорма,,ЛояльностьДанныеЗаказа);	

КонецПроцедуры

Процедура ЗаполнитьНадписиЛояльности()
	
	ОбластьСтрокаКГЛ = ПолучитьОбщийМакет("ТабДокЛояльность").ПолучитьОбласть("СтрокаКГЛ");
	ОбластьСтрокаИтого = ПолучитьОбщийМакет("ТабДокЛояльность").ПолучитьОбласть("СтрокаИтого");
	ЭлементыФормы.ТабДокЛояльность.Очистить();
	
	НомерКартыЛояльности = Заказ.НомерКартыЛояльности;
	Если ПустаяСтрока(НомерКартыЛояльности) Тогда
		
		Для Сч = 1 По 6 Цикл
			ЭлементыФормы["Плашка" + Сч].Заголовок = "";
		КонецЦикла;
		Для Сч = 7 По 11 Цикл
			ЭлементыФормы["Плашка" + Сч].Доступность = Ложь;
		КонецЦикла;
		
		ЭлементыФормы.НадписьЛояльность1.Заголовок = "Здравствуйте!";
		
	Иначе
		ДанныеГостя = ЛояльностьКлиентСервер.ПолучитьДанныеГостя(НомерКартыЛояльности, глПараметрыРМ.Тест);
		Если ДанныеГостя.Ошибка Тогда
			ЭлементыФормы.НадписьЛояльность1.Заголовок = "Здравствуйте!";
		Иначе	
			НомерКартыЛояльности = СокрЛП(Формат(ДанныеГостя.НомерКарты, "ЧГ=0"));
			Попытка
				Имя = СтрРазделить(ДанныеГостя.ФИО, " ")[0];
			Исключение
			    Имя = "Гость";
			КонецПопытки;
			ЭлементыФормы.НадписьЛояльность1.Заголовок = СтрШаблон("Здравствуйте, %1!
			|Карта %2*****%3", Имя, Лев(НомерКартыЛояльности, 2), Прав(НомерКартыЛояльности, 4));
		КонецЕсли;
		
		ДанныеЛояльности = ЛояльностьКлиент.ПолучитьДанныеЛояльностиПоЗаказу(Заказ);
		
		КупоныГостя = ДанныеЛояльности.Купоны;
		Для Сч = 0 По КупоныГостя.ВГраница() Цикл
			Инд = Сч + 1;
			Если Инд > 6 Тогда
				Прервать;
			КонецЕсли;
			ЭлементыФормы["Плашка" + Инд].Заголовок = КупоныГостя[Сч].ИнфоСтанции;
		КонецЦикла;
		
		КГЛ = 0;
		Итоги = ДанныеЛояльности.ИтогиМ.КГЛИнфо;
		Для каждого ТекСтрока Из Итоги Цикл
			КГЛ = КГЛ + ТекСтрока.КГЛ;
			Если ТекСтрока.КГЛ > 0 Тогда
				ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
				ЭлементыФормы.ТабДокЛояльность.Вывести(ОбластьСтрокаКГЛ);
			КонецЕсли;
		КонецЦикла;
		Итоги = ДанныеЛояльности.ИтогиО.КГЛИнфо;
		Для каждого ТекСтрока Из Итоги Цикл
			КГЛ = КГЛ + ТекСтрока.КГЛ;
			Если ТекСтрока.КГЛ > 0 Тогда
				ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
				ЭлементыФормы.ТабДокЛояльность.Вывести(ОбластьСтрокаКГЛ);
			КонецЕсли;
		КонецЦикла;
		Итоги = ДанныеЛояльности.ИтогиКП.КГЛИнфо;
		Для каждого ТекСтрока Из Итоги Цикл
			КГЛ = КГЛ + ТекСтрока.КГЛ;
			Если ТекСтрока.КГЛ > 0 Тогда
				ОбластьСтрокаКГЛ.Параметры.Заполнить(ТекСтрока);
				ЭлементыФормы.ТабДокЛояльность.Вывести(ОбластьСтрокаКГЛ);
			КонецЕсли;
		КонецЦикла;
		Если КГЛ > 0 Тогда
			ОбластьСтрокаИтого.Параметры.КГЛ = КГЛ;
			ЭлементыФормы.ТабДокЛояльность.Вывести(ОбластьСтрокаИтого);
		КонецЕсли;

		Для Сч = 7 По 11 Цикл
			ЭлементыФормы["Плашка" + Сч].Доступность = Истина;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьЗаказНаМонитореГостя() Экспорт
	ОтключитьОбработчикОжидания("ОбновитьЗаказНаМонитореГостя");
	ПоказатьЗаказНаМонитореГостя();	
КонецПроцедуры

Процедура ОчиститьЗаказ() Экспорт
	тпТовары.Очистить();
	ЛояльностьДанныеЗаказа = Неопределено;
	ИнтерфейсРМЛояльность.ОбновитьЭлементыФормы(ЭтаФорма, "", ЛояльностьДанныеЗаказа);
	ИнтерфейсРМ.ЗаполнитьПодвал(ЭлементыФормы.ИтогиПоФирмамРМ, Заказ);
КонецПроцедуры

#КонецОбласти

#Область ОтображениеЗаказаВБлокировке

Процедура ОтобразитьЗаказВБлокировке() Экспорт 
	ИнтервалСброса = Неопределено;
	глПараметрыРМ.Свойство("ИнфоДисплей_ИнтервалСбросаЗаказаВБлокировке", ИнтервалСброса);
	Если НЕ ЗначениеЗаполнено(ИнтервалСброса) Тогда
		ИнтервалСброса = 10;
	КонецЕсли;
	
	ОбновитьВремя();
	ПодключитьОбработчикОжидания("СброситьЗаказВБлокировке", ИнтервалСброса, Истина);
КонецПроцедуры

Процедура СброситьЗаказВБлокировке() Экспорт 
	СброситьТекущийДокумент();	
КонецПроцедуры


#КонецОбласти

Процедура ПриЗакрытииМеню() Экспорт
КонецПроцедуры

Функция ПанелиСкрыты() Экспорт
	Возврат Истина;
КонецФункции

Процедура КнопкаПриготовитьНажатие(Элемент)
	Приготовить();	
КонецПроцедуры



#Область Инициализация

фФормаСкрытияМеню = 0;

Попытка
	AutohotkeyDLL = РаботаСокнами.AHK(,"ГлавнаяФорма");
Исключение
КонецПопытки;
ФормаСкрытияМеню = Обработки.СкрытьМенюИПанели.ПолучитьФорму();
ФормаСкрытияМеню.Открыть();	

// подготовка таблицы товаров
МассивЧисла = Новый Массив;
МассивЧисла.Добавить(Тип("Число"));

тпТовары.Очистить();
тпТовары.Колонки.Очистить();
тпТовары.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"),"N",3);
тпТовары.Колонки.Добавить("Иконка",Новый ОписаниеТипов("Строка")," ",3);
тпТовары.Колонки.Добавить("Автор",Новый ОписаниеТипов("СправочникСсылка.Сотрудники"),,1);
тпТовары.Колонки.Добавить("Товар",Новый ОписаниеТипов("СправочникСсылка.Товары"),,60);
тпТовары.Колонки.Добавить("Количество",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("х",,,1);
тпТовары.Колонки.Добавить("ЦенаРеализации",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,9);
тпТовары.Колонки.Добавить("Равно",,,1);
тпТовары.Колонки.Добавить("СуммаРеализации",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,10);
тпТовары.Колонки.Добавить("фАлкоголь",,,8);
тпТовары.Колонки.Добавить("КоличествоНачальное",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("блок",Новый ОписаниеТипов("Булево"),,1);

тпТовары.Колонки.Добавить("Фирма", Новый ОписаниеТипов("СправочникСсылка.Фирмы"),,1); 
тпТовары.Колонки.Добавить("ИдСтроки", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(30)),,1); 
тпТовары.Колонки.Добавить("СтатусОплаты",Новый ОписаниеТипов("Число"),,1);
тпТовары.Колонки.Добавить("Статус",Новый ОписаниеТипов("ПеречислениеСсылка.СтатусыПозицийЗаказа"),,1);
тпТовары.Колонки.Добавить("ИдСвязаннойСтроки",Новый ОписаниеТипов("Строка"),,1);
тпТовары.Колонки.Добавить("ШК",Новый ОписаниеТипов("Строка"),,1);

тпТовары.Колонки.Добавить("ЛояльностьГруппаАкции",Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(5,0)),,1);

Если глПараметрыРМ.ВесыЕсть Тогда
	Весы = глПараметрыРМ.Весы.ПолучитьОбъект();
	Обработка_Весы = Обработка_Весы;
	ИнициализацияТО(Весы, Обработка_Весы, глПараметрыРМ);
КонецЕсли;

ОтборФирма = Ложь;

#КонецОбласти
