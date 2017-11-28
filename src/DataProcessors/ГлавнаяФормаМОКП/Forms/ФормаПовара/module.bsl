﻿
#Область ОписаниеПеременных

Перем ФормаСкрытияМеню, фФормаСкрытияМеню;
Перем мСдвигаемыеЭлементы;
Перем ОтборСтрок Экспорт;
Перем КупоныСоответствие Экспорт;
Перем МакетПодвал;
Перем ВариантыОтбораСтрок;

#КонецОбласти


#Область ОбработчикиСобытийФормы

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
КонецПроцедуры

Процедура ПриОткрытии()
	
	ОбновитьВремя(2);
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	Стиль = БиблиотекаСтилей.СтанцияОплаты;
	ОбновитьНадписьИтого();
	
	ПодключитьОбработчикОжидания("Через2СекундыПослеОткрытия",0.1,1);
	УИДформы = Новый УникальныйИдентификатор;
	
	//Если глПараметрыРМ.Фирма = Справочники.МестаРеализации.Мяснов Тогда
	//	ЭтаФорма.Панель.Картинка = БиблиотекаКартинок.ЛогоКуулКлевер77;
	//ИначеЕсли Найти(глПараметрыРМ.Фирма, "Отдохни") Тогда
	//	ЭтаФорма.Панель.Картинка = БиблиотекаКартинок.ЛогоКуулКлевер77;
	//КонецЕсли;
	
	ЭлементыФормы.тпТовары.СоздатьКолонки();
	
	ЭлементыФормы.тпТовары.Колонки.Автор.Видимость = ложь;
	ЭлементыФормы.тпТовары.Колонки.фАлкоголь.Видимость = ложь;
	ЭлементыФормы.тпТовары.Колонки.КоличествоНачальное.видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Блок.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Фирма.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.ИдСтроки.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.ИдСвязаннойСтроки.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.СтатусОплаты.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.СтатусДопИнф.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Статус.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Подача.Видимость = Ложь;
	
	ЭлементыФормы.тпТовары.Колонки.Цена.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Сумма.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Сумма.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.КоличествоУдалено.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Автор.Видимость = ложь;
	ЭлементыФормы.тпТовары.Колонки.фАлкоголь.Видимость = ложь;
	ЭлементыФормы.тпТовары.Колонки.КоличествоНачальное.видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Блок.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Фирма.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.ИдСтроки.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.СтатусОплаты.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.СтатусДопИнф.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.РабочееМесто.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Станция.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.КоличествоУдалено.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.НомерМарки.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Статус.Видимость = Ложь;
	ЭлементыФормы.тпТовары.Колонки.Подача.Видимость = Ложь;

	ЭлементыФормы.тпТовары.Колонки.ЛояльностьГруппаАкции.Видимость = Ложь;

	//ЭлементыФормы.тпТовары.ТолькоПросмотр = истина;
	ЭлементыФормы.тпТовары.Шапка = Ложь;
	ЭлементыФормы.тпТовары.ВертикальныеЛинии = Ложь;
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ОтображатьИерархию = Ложь;
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ШрифтТекста = Новый Шрифт(ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ШрифтТекста,,8);
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.Ширина = 1;
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ВысотаЯчейки = 1;
	ИнтерфейсРМЛояльность.ФормаПриОткрытии(ЭтаФорма);
	
	колонкаМодифицирована =  ЭлементыФормы.тпТовары.Колонки.Модифицирована;
	//:колонкаМодифицирована = ЭлементыФормы.тпТовары.Колонки.Добавить();
	колонкаМодифицирована.ШрифтТекста = Новый Шрифт("MS Shell Dlg",4,,,,,10);
	колонкаМодифицирована.ШрифтШапки = 	колонкаМодифицирована.ШрифтТекста;
	колонкаМодифицирована.ЦветТекстаПоля = ЦветаСтиля.ЦветФонаПоля;
	колонкаМодифицирована.ИзменениеРазмера = ИзменениеРазмераКолонки.НеИзменять;
	колонкаМодифицирована.Ширина = 1;
	колонкаМодифицирована.ОтображатьВШапке = Ложь;
	колонкаМодифицирована.Положение = ПоложениеКолонки.ВТойЖеКолонке;  
	ЭлементыФормы.тпТовары.Колонки.НомерСтроки.ВысотаЯчейки = 3;
КонецПроцедуры

Процедура Через2СекундыПослеОткрытия() Экспорт
	ОбновитьНадписьИтого();
	ЭтаФорма.ТолькоПросмотр = Истина;
	
	ПодключитьОбработчикОжидания("ВосстановитьФорму",0.1,1);
		
КонецПроцедуры

Процедура ВосстановитьФорму() Экспорт
	ЗаблокироватьВформе = Не ЗначениеЗаполнено(глПользователь);
	Если AutohotkeyDLL = Неопределено Тогда
		AutohotkeyDLL = РаботаСокнами.AHK(,"ВосстановитьФорму");
	КонецЕсли;
	
	Лайтово = Ложь;
	Cкрипт = "
	|#NoTrayIcon
	|#NoEnv
	|WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame,,15
	|Sleep 100
	|WinRestore, ahk_pid %pid ahk_class V8TopLevelFrame
	|WinMaximize, ahk_pid %pid  ahk_class V8TopLevelFrame
	|Sleep 100
	|Send {alt down}{shift down}{VK52}{alt up}{shift up}
	|Exitapp";	
	Cкрипт = СтрЗаменить(Cкрипт, "%pid", формат(РаботаСокнами.pid, "ЧГ=0"));
	
	AutohotkeyDLL.ahkTextDll(Cкрипт);		
	Если ЗаблокироватьВформе Тогда
		ГлавнаяФорма.ПодключитьОбработчикОжидания("ЗаблокироватьВформе", 0.5,1);
	КонецЕсли;	

КонецПроцедуры

Процедура ЗаблокироватьВформе() Экспорт
	ТолькоПросмотр = Ложь;
	Заблокировать(Истина);
	Cкрипт = "
	|#NoTrayIcon
	|WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame
	|Sleep 100
	|Send {alt down}{shift down}{VK52}{alt up}{shift up}
	|Exitapp";	
	Cкрипт = СтрЗаменить(Cкрипт, "%pid", формат(РаботаСокнами.pid, "ЧГ=0"));
	AutohotkeyDLL.ahkTextDll(Cкрипт);		
	
	//ПодключитьОбработчикОжидания("ПоказатьМенюПовара",0.3,1);
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
				ИзменитьКоличествоПриВыборе();
			КонецЕсли;
	
		КонецЕсли;
		Если ОбщегоНазначенияПовтИсп.СтанцияТовара(ЗначениеВыбора) <> глПараметрыРМ.Станция Тогда
			ОтборСтрок = 3;
			ОбновитьЗаголовокКнопкиФильтра();
			
		КонецЕсли;
		ВводНовойСтроки(ЗначениеВыбора);
	КонецЕсли;
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ИзменениеСмены" Тогда
		//глПараметрыРМ.Вставить("НомерСмены", ИнтерфейсРМ.ТекущаяСмена().Номер);
		фВводТоваровДоступен = ЗначениеЗаполнено(ИнтерфейсРМ.ТекущаяСмена().Номер);
	ИначеЕсли ИмяСобытия = "ЗакрытМониторМарок" Тогда
		ПрочитатьТекущийДокумент();
		ПоказатьЗаказНаМонитореГостя(0.1,"ФормаПовара.ОбработкаОповещения().ЗакрытМониторМарок");
		ГлавнаяФорма.ПодключитьОбработчикОжидания("ПоказатьМенюПовара",0.6,1);
	КонецЕсли; 
	
	ОбработатьОповещение(ИмяСобытия, Параметр, Источник);
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	ОбновитьНадписьИтого();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормытпТовары

Процедура тпТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура тпТоварыПослеУдаления(Элемент)
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура тпТоварыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
		
	ОформлениеСтрокиЗаказа(Элемент, ОформлениеСтроки, ДанныеСтроки)	
КонецПроцедуры

Процедура тпТоварыТоварПриИзменении(Элемент)
	ЗаполнитьЗначенияСвойств(ЭлементыФормы.тпТовары.ТекущиеДанные, ЭлементыФормы.тпТовары.ТекущиеДанные.Товар);
	Если ЭлементыФормы.тпТовары.ТекущиеДанные.фАлкоголь Тогда
		ЭлементыФормы.тпТовары.ТекущиеДанные.ПДФ = ВводПДФ(ЭлементыФормы.тпТовары.ТекущиеДанные.Товар);
	КонецЕсли;
	ОбновитьНадписьИтого();
КонецПроцедуры
		
Процедура тпТоварыПриАктивизацииСтроки(Элемент)
	Попытка
		ТекущийЭлемент = ЭлементыФормы.Плашка11;
	Исключение
	КонецПопытки;
	
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если Элемент.ТекущиеДанные.СтатусОплаты = 1 Тогда
		//Элемент.РежимВыделенияСтроки  = РежимВыделенияСтрокиТабличногоПоля.Ячейка;
	Иначе
		//Элемент.РежимВыделенияСтроки  = РежимВыделенияСтрокиТабличногоПоля.Строка;
	КонецЕсли;
	Если ТекИдСтрокиТовара <> ТекИдСтрокиТовара() И ЭлементыФормы.тпТовары.ТекущаяСтрока <> Неопределено Тогда
		Попытка
			СтрокаТ = тпТовары.Строки.Найти(ТекИдСтрокиТовара,"ИдСтроки");
			
			МассивСтрок = Массив(СтрокаТ);
			ДополнитьМассив(МассивСтрок, СтрокаТ.Строки);
			ЭлементыФормы.тпТовары.ОбновитьСтроки();
			ПоказатьЗаказНаМонитореГостя();
		Исключение
		КонецПопытки;
		
		ТекИдСтрокиТовара = ТекИдСтрокиТовара();
	КонецЕсли;
КонецПроцедуры

Процедура тпТоварыВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	ПоказатьИнформациюОтоваре(РежимПредпросмотра);
	ОбновитьОтображениеТоварГетИнфо();
КонецПроцедуры

Процедура тпТоварыПриПолученииДанных(Элемент, ОформленияСтрок)
	ИнтерфейсРМЛояльность.тпТоварыПриПолученииДанных(ЭтаФорма, Элемент, ОформленияСтрок, ЛояльностьДанныеЗаказа);
КонецПроцедуры

Процедура тпТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВводНовойСтроки(ВыбранноеЗначение);
	
КонецПроцедуры

Процедура тпТоварыПриАктивизацииЯчейки(Элемент)
	Попытка
		Если не ЭлементыФормы.тпТовары.ТекущаяКолонка = ЭлементыФормы.тпТовары.Колонки.Модифицирована Тогда
			ЭлементыФормы.тпТовары.ТекущаяКолонка = ЭлементыФормы.тпТовары.Колонки.Модифицирована;
		КонецЕсли;
		
	Исключение
	КонецПопытки;

КонецПроцедуры



#КонецОбласти

#Область ОбработчикиКомандФормы

#Область МенюСверху

Процедура ПереключитьФильтр(Элемент)
	ОтборСтрок = (ОтборСтрок+1)%3+1;
	Если ОтборСтрок = 1 Тогда
		ДопПараметрыИнфо.Вставить("ФирмаФильтр", глПараметрыРМ.Фирма);
	ИначеЕсли ОтборСтрок = 2 Тогда
		ДопПараметрыИнфо.Вставить("ФирмаФильтр", глПараметрыРМ.Фирма);
	Иначе
		ДопПараметрыИнфо.Вставить("ФирмаФильтр", Неопределено);
	КонецЕсли;
	ОбновитьЗаголовокКнопкиФильтра();	
	ПрочитатьТекущийДокумент();
	ПоказатьЗаказНаМонитореГостя();
	ИнтерфейсРМЛояльность.ОбновитьЭлементыФормы(ГлавнаяФорма, , ЛояльностьДанныеЗаказа);
	//ИнтерфейсРМЛояльность.ОбновитьТабДокЛояльность(ГлавнаяФорма, , ЛояльностьДанныеЗаказа);
КонецПроцедуры

Процедура кнПейджерНажатие(Элемент)
	ВозвратПейджера();
КонецПроцедуры

#КонецОбласти


#Область МенюСнизу

Процедура КнопкаСпецификиНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ЭлементыФормы.тпТовары.ТекущиеДанные.Уровень() Тогда
		ТекИД = ЭлементыФормы.тпТовары.ТекущиеДанные.Родитель.ИдСтроки;
	Иначе
		ТекИД = ЭлементыФормы.тпТовары.ТекущиеДанные.ИдСтроки;
	КонецЕсли;
	
	// Выбор специфики
	//
	ВыборСпецифики(,);
	
	СтрокаТП = тпТовары.Строки.Найти(ТекИД, "ИдСтроки");
	Если СтрокаТП <> Неопределено Тогда
		ЭлементыФормы.тпТовары.ТекущаяСтрока = СтрокаТП;
	КонецЕсли;
	
	ПоказатьЗаказНаМонитореГостя();

КонецПроцедуры

Процедура КнопкаОбщиеСпецификиНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;

	ВыборСпецифики(Истина);
КонецПроцедуры

Процедура КнопкаКоличествоНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИзменитьКоличество() Тогда
		ОбновитьНадписьИтого();
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаРецептыГостяНажатие(Элемент)
      РецептыГостя();
КонецПроцедуры

Процедура КнопкаИнфоНажатие(Элемент)
	Если ЭлементыФормы.тпТовары.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПоказатьИнформациюОтоваре(РежимПредпросмотра);
	ОбновитьОтображениеТоварГетИнфо();
	
КонецПроцедуры

#КонецОбласти


#Область МенюСлева

Процедура ПлашкаКупонНажатие(Элемент) Экспорт 
	ИнтерфейсРМЛояльность.ПлашкаКупонНажатие(ЭтаФорма, Элемент);
КонецПроцедуры

Процедура Плашка_Н_Нажатие(Элемент) Экспорт 
	ИнтерфейсРМЛояльность.Плашка_Н_Нажатие(ЭтаФорма, Элемент);
	//ЛояльностьДанныеЗаказа = ИнтерфейсРМЛояльность.ОбновитьТовары(ЭтаФорма);
	ЭлементыФормы.тпТовары.ОбновитьСтроки();
КонецПроцедуры

#КонецОбласти


#Область МенюСправа

Процедура РежимАдминистратораНажатие(Элемент)
	Если ЕстьДозаказ() Тогда
		ПредупреждениеЕстьДозаказ();		
		Возврат;
	КонецЕсли;

	ОткрытьМенюОпераций();
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ЗаблокироватьНажатие(Элемент)
	
	Если ЕстьДозаказ() Тогда
		ПредупреждениеЕстьДозаказ();		
		Возврат;
	КонецЕсли;
	ОтборСтрок = 3;
	//ОбновитьЗаголовокКнопкиФильтра();
	
	РежимПредпросмотра = Ложь;
	ОбновитьОтображениеТоварГетИнфо();
	фЗаблокировать = 1;
	Если ТекущийРежим = "ПРОДАЖА" Тогда
		ТекущийРежим = "";
		ТекущийДокумент = Неопределено;
		Заказ = Неопределено;
		глПользователь = Справочники.Сотрудники.ПустаяСсылка();
		Заблокировать(Истина);
	Иначе
		Заблокировать(Истина);
	КонецЕсли;
	ОтборСтрок = 1;
	ОбновитьЗаголовокКнопкиФильтра();
	ФильтроватьТП();
	ПоказатьМенюПовара();
КонецПроцедуры

Процедура КнопкаСоздатьМаркиНажатие(Элемент)
	Попытка
		ФормаПодбораТоваров.Закрыть();	
	Исключение
	КонецПопытки;
	
	МониторМарок();
	
КонецПроцедуры

Процедура КнопкаСтрелкаВверхНажатие(Элемент)
	Попытка
		ФормаПодбораТоваров.Пролистать(-1);	
	Исключение
	КонецПопытки;
	
	
КонецПроцедуры

Процедура КнопкаСтрелкаВнизНажатие(Элемент)
	
	Попытка
		ФормаПодбораТоваров.Пролистать(1);	
	Исключение
	КонецПопытки;
	
КонецПроцедуры

Процедура кнЛояльностьНажатие(Элемент)
	МенюЛояльности();
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ВыборМенюНажатие(Элемент)
	Если ВысотаТаблицыЗаказа = Неопределено Тогда
		ВысотаТаблицыЗаказа	= ЭлементыФормы.тпТовары.Высота;
		ВысотаПодвала		= ЭлементыФормы.КнопкаКоличество.Высота;
	КонецЕсли;
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;

	СменаМенюПовара();
КонецПроцедуры

#КонецОбласти


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьСвойствоКнопки(ИмяКнопки, ЗначениеСвойства, Акцент = 0, Свойство = "Доступность", МенятьЦвет = Истина) Экспорт
	Кнопка = ЭлементыФормы[ИмяКнопки];
	МассивТеней = Новый Массив;	
	Тень1 = ЭлементыФормы.Найти(ИмяКнопки+"Тень2");
	Если Не Тень1 = Неопределено Тогда
	
		МассивТеней.Добавить(Тень1);
	
	КонецЕсли; 

	Тень2 = ЭлементыФормы.Найти(ИмяКнопки+"Тень2");
	Если Не Тень2 = Неопределено Тогда
	
		МассивТеней.Добавить(Тень2);
	
	КонецЕсли; 
	
	ЦветКнопки = ?(Акцент, Метаданные.ЭлементыСтиля.Акцент.Значение, Метаданные.ЭлементыСтиля.ЦветТемы.Значение);
	ЦветФонаНеактивнойКнопки = Метаданные.ЭлементыСтиля.НеактивнаяКнопка.Значение;
	ЦветТекстаНеактивнойКнопки = Метаданные.ЭлементыСтиля.НеактивныйЭлемент.Значение;
	
	Кнопка[Свойство] = ЗначениеСвойства;
	Если ЗначениеСвойства Тогда
		Кнопка.Видимость = Истина;
		Кнопка.Доступность = Истина;
	КонецЕсли;
	
	Если МенятьЦвет Тогда
		Кнопка.ЦветФонаКнопки 	=  ?(ЗначениеСвойства, ЦветКнопки, ЦветФонаНеактивнойКнопки);
		Кнопка.ЦветТекстаКнопки =  ?(ЗначениеСвойства, WebЦвета.Белый, 	ЦветТекстаНеактивнойКнопки);
		Кнопка.ЦветРамки = Кнопка.ЦветФонаКнопки;
	КонецЕсли;
	Для каждого Тень Из МассивТеней Цикл
		
		Тень.Видимость = ЗначениеСвойства;
		
	КонецЦикла; 
	
			
КонецПроцедуры

Процедура УстановитьДоступностьКнопки(ИмяКнопки, Доступность, Акцент = 0, Свойство = "", МенятьЦвет = Истина) Экспорт
	Свойство = "Доступность";
	УстановитьСвойствоКнопки(ИмяКнопки, Доступность, Акцент, Свойство, МенятьЦвет);
КонецПроцедуры

Процедура УстановитьВидимостьКнопки(ИмяКнопки, Доступность, Акцент = 0, Свойство = "", МенятьЦвет = Истина) Экспорт
	Свойство = "Видимость";
	УстановитьСвойствоКнопки(ИмяКнопки, Доступность, Акцент, Свойство, МенятьЦвет);
КонецПроцедуры
	
// вызывается извне из открытой модальной формы (меню, весы, подбор ...)
Процедура ПриЗакрытииМеню() Экспорт
	//ЭлементыФормы.тпТовары.Высота = ВысотаТаблицыЗаказа;
	//ЭлементыФормы.ТеньТовары.Высота = ВысотаТаблицыЗаказа;
	//ЭлементыФормы.тпТоварыВозврат.Высота = ВысотаТаблицыЗаказа;
	ЭлементыФормы.КнопкаСтрелкаВверх.Видимость = 0;
	ЭлементыФормы.КнопкаСтрелкаВниз.Видимость = 0;	
	ЭлементыФормы.ПолоскаМеждуСтрелками.Видимость = 0;
	
КонецПроцедуры

Процедура СкрытьПоказатьКнопки(Показать = Ложь)
	Для Каждого Эл Из ЭлементыФормы Цикл
		Если СтрНачинаетсяС(Эл.Имя, "Кнопка") или СтрНачинаетсяС(Эл.Имя, "Плашка") Тогда
			Эл.Видимость = Показать;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементыФормы.НадписьЛояльность1.Видимость = Показать;
	
КонецПроцедуры

Процедура ОбновитьОтображениеТоварГетИнфо()
	Если РежимПредпросмотра Тогда
		ЭлементыФормы.КнопкаИнфо.ЦветТекстаКнопки = ЦветаСтиля.ЦветФонаКнопки;
		ЭлементыФормы.КнопкаИнфо.ЦветФонаКнопки = ЦветаСтиля.ЦветТекстаФормы;
	Иначе
		ЭлементыФормы.КнопкаИнфо.ЦветТекстаКнопки = ЦветаСтиля.ЦветТекстаФормы;
		ЭлементыФормы.КнопкаИнфо.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаКнопки;
	КонецЕсли;	
КонецПроцедуры

Процедура ОбновитьЗаголовокКнопкиФильтра()
	
		
	тЗаказ = "Заказ  " + НомерТекущегоЗаказа() + Символы.ПС;
	тЗаказ = тЗаказ + ВариантыОтбораСтрок.Получить(ОтборСтрок);
	ЭлементыФормы.КнопкаПереключитьФильтр.Заголовок = тЗаказ;
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнтерфейса

Процедура ОбновитьВремя(Задержка = 0) Экспорт 
	
	Если Задержка Тогда
		ОтключитьОбработчикОжидания("ОбновитьВремя_Ожидание");
		ПодключитьОбработчикОжидания("ОбновитьВремя_Ожидание", Задержка, Истина);
	Иначе
		ОбновитьВремя_Ожидание();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновитьВремя_Ожидание() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
	ТекущаяДатаНаСервере = ТекущаяДатаНаСервере();
	тДата = Формат(ТекущаяДатаНаСервере,"ДФ='ddd, d MMMM'");
	тВремя = Формат(ТекущаяДатаНаСервере,"ДФ=HH:mm");
	тПользователь = ?(ЗначениеЗаполнено(глПользователь), Строка(глПользователь), "Система заблокирована");
	тТекущийРежим = ТекущийРежим; 										
	тБейдж = "";
	Если ТекущийДокумент = Неопределено Тогда
		тЗаказ = "";
		тБейдж = "";
	ИначеЕсли Не глФлагБлокировка Тогда
		Если ТекущийРежим = "ПРОДАЖА" Тогда
			КартаДоступа = Заказ.КартаДоступа;
			Идентификатор2 = КартаДоступа.Идентификатор2;
			Если ЗначениеЗаполнено(Идентификатор2) Тогда
				ИдентификаторКарты = Идентификатор2;
			Иначе
				ИдентификаторКарты = Прав(КартаДоступа.Идентификатор, 5);
			КонецЕсли;			
			тБейдж = "Бейдж " + ИдентификаторКарты;
		КонецЕсли;
				
	КонецЕсли;
	
	тРабочееМесто = глРабочееМесто;		
	//ПодключитьОбработчикОжидания("ЗаполнитьНадписиЛояльности",1,1);
	ОбновитьВремя(10);	
КонецПроцедуры

Процедура ОбновитьНадписьИтого() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	
			
	Попытка
		ДатаРождения = Заказ.ДатаРождения;
	Исключение
		ДатаРождения = Дата(1,1,1);
	КонецПопытки;
	
	Если ТекущийРежим = "ВОЗВРАТ" Тогда
		ЭлементыФормы.тпТовары.Видимость = 0;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 1;
		//ЭлементыФормы.ТеньТовары.Видимость = 1;
		СкрытьПоказатьКнопки(Истина);
		
	ИначеЕсли  ТекущийРежим = "ПРОДАЖА" Тогда
		ЭлементыФормы.тпТовары.Видимость = 1;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 0;
		//ЭлементыФормы.ТеньТовары.Видимость = 1;
		СкрытьПоказатьКнопки(Истина);
		ЭлементыФормы.тИтог.Видимость = 1;
		Если СуммаРеализации() Тогда
			тИтог = Формат(тпТовары.Строки.Итог("СуммаРеализации",Ложь),"ЧДЦ=2; ЧРД=.") + глСимволРубля;
			тИтог = СтрЗаменить(тИтог, ".00", ".- ");
		Иначе
			тИтог = "";			
		КонецЕсли;
		
	Иначе
		//ЭлементыФормы.ТеньТовары.Видимость = 0;
		ЭлементыФормы.тпТовары.Видимость = 0;
		ЭлементыФормы.тпТоварыВозврат.Видимость = 0;
		Если ксТрактир.ВыданныеПейджеры(Заказ.Ссылка).Количество() Тогда
			ЭлементыФормы.кнПейджер.Видимость = Истина;
		Иначе
			ЭлементыФормы.кнПейджер.Видимость = Ложь;
		КонецЕсли;
		ЭлементыФормы.тИтог.Видимость = 0;
		СкрытьПоказатьКнопки();
	КонецЕсли;
	ИтогоСумма = 0;
	ИтогоКоличество = 0;
	ЕстьЧужиеТовары = Ложь;
	Если ЭлементыФормы.тпТовары.ТекущаяСтрока<>Неопределено Тогда
		ТекИдСтрокиТовара = ТекИдСтрокиТовара();
	КонецЕсли;
	
	ТекСтрока = Неопределено;
	Если ТекИдСтрокиТовара <> Неопределено Тогда
		Попытка
			ТекИдСтрокиТовара = ТекИдСтрокиТовара();
		Исключение
		КонецПопытки;                           
	КонецЕсли;
	
	//ЗаполнитьТПтовары();
	Если ТекущийРежим = "" Тогда
		ЕстьТовары = Ложь;
		
	Иначе
		Если ТекущийДокумент.Товары.Количество() Тогда
			ТекСтрока = ТекущийДокумент.Товары[ТекущийДокумент.Товары.Количество()-1];
		Иначе
			ТекСтрока = Неопределено;
		КонецЕсли;
		
		Для Каждого Т Из ТекущийДокумент.Товары Цикл
			Если т.Фирма <> глПараметрыРМ.Фирма Тогда
				ЕстьЧужиеТовары = Истина;
			КонецЕсли;
			Если Т.СтатусОплаты = -1 Тогда
				Попытка
					ИтогоСумма = ИтогоСумма + ?(ТекущийРежим = "ПРОДАЖА", Т.СуммаРеализации, Т.Сумма);	
					ИтогоКоличество = ИтогоКоличество + Т.Количество;
				Исключение
				КонецПопытки;                                        
				
				Если Т.Количество И ТекСтрока = Неопределено Тогда
					ТекСтрока = Т;
				КонецЕсли;
				
			КонецЕсли;
		КонецЦикла;
		Попытка
			ТекИдСтрокиТовара = ТекИдСтрокиТовара();
			ПодключитьОбработчикОжидания("УстановитьТекСтроку", 0.1, 1);
		Исключение
		КонецПопытки;
		
		ЕстьТовары = ИтогоКоличество;
	КонецЕсли;
	
	
	
	Если ЕстьТовары Тогда 
		СуммаКоплате = Формат(ИтогоСумма, "ЧДЦ=2; ЧРД=.; ЧН=-") + " " + глСимволРубля;
	Иначе
		СуммаКоплате = "";
	КонецЕсли;
	
	тЗаказ = "Заказ  " + НомерТекущегоЗаказа() + Символы.ПС;
	тЗаказ = тЗаказ + ВариантыОтбораСтрок.Получить(ОтборСтрок);
	ЭлементыФормы.КнопкаПереключитьФильтр.Заголовок = тЗаказ;
	
	Если НадписьСдача <> Неопределено Тогда
		//ЭлементыФормы.НадписьСумма.Заголовок = "Сдача";
		СуммаКоплате = СтрЗаменить(НадписьСдача, ",", ".");  
	ИначеЕсли ТекущийДокумент = Неопределено Тогда
		//ЭлементыФормы.НадписьСумма.Заголовок = "";
	Иначе
		//ЭлементыФормы.НадписьСумма.Заголовок = "К оплате";
		Если Не ИтогоСумма Тогда
			//ЭлементыФормы.НадписьСумма.Заголовок = "";
		КонецЕсли;
	КонецЕсли;
	НадписьЛояльность = "";
	Если ТекущийДокумент <> Неопределено Тогда
		
		Если ЕстьТовары Тогда
			
			Попытка
				ТекущийЭлемент = ЭлементыФормы.Плашка11;
			Исключение
			КонецПопытки;
		КонецЕсли;
		
		
		
		Если ЗначениеЗаполнено(ТекущийДокумент.НомерКартыЛояльности) Тогда
			Если СтрДлина(СокрП(ТекущийДокумент.НомерКартыЛояльности)) <= 10 Тогда
				НадписьЛояльность = "Карта: ******"+Прав(ТекущийДокумент.НомерКартыЛояльности,4);
			Иначе
				НадписьЛояльность = "Карта применена";
			КонецЕсли;
		КонецЕсли;
		
		//Если Не ТекущийДокумент.КартаДоступа.Пустая() Тогда
		//	НадписьЛояльность = НадписьЛояльность + ?(НадписьЛояльность = "", "", Символы.ПС) +	"Карта доступа " + ТекущийДокумент.КартаДоступа;
		//КонецЕсли;
		
		Если ТипЗнч(ТекущийДокумент) = Тип("ДокументОбъект.Заказ") Тогда
			Если ТекущийДокумент.Купоны.Количество() Тогда
				НадписьЛояльность = НадписьЛояльность + Символы.ПС + "Сертификат" + ?(ТекущийДокумент.Купоны.Количество() = 1, " ", "ы ") + "применен" + ?(ТекущийДокумент.Купоны.Количество() = 1, " ", "ы ");
			КонецЕсли;
		КонецЕсли;
		
		
		//ЭлементыФормы.Количество.Заголовок = "КОЛ-ВО";
		Если ЗначениеЗаполнено(ТекКоличество) Тогда
			Если ТекКоличество<>1 Тогда
				//ЭлементыФормы.Количество.Заголовок = ТекКоличество;
			КонецЕсли;
		КонецЕсли;
		//УстановитьВидимостьКнопки("Количество", 1,,,0);	
	Иначе
		//УстановитьВидимостьКнопки("Количество", 0,,,0);	
	КонецЕсли;
	
	//ИнтерфейсРМ.ЗаполнитьПодвал(ЭлементыФормы.ТабДокПодвал, Заказ, МакетПодвал);	
КонецПроцедуры

Процедура ОбновитьОстальное() Экспорт
	ОбновитьВремя();
КонецПроцедуры

#КонецОбласти




Процедура УстановитьТекСтроку() Экспорт
	Попытка
		Если Не ТекИдСтрокиТовара = Неопределено Тогда
			ЭлементыФормы.тпТовары.ТекущаяСтрока = тпТовары.Строки.Найти(ТекИдСтрокиТовара, "ИдСтроки");;
		КонецЕсли;                                                  		
	Исключение
		//РаботаСокнами.ПоказатьПлашку(":-( ошибка", ОписаниеОшибки());
	КонецПопытки;                                           	
КонецПроцедуры

Процедура ЗаполнитьТПтовары() Экспорт
	
	//:ТекущийДокумент = Документы.Заказ.СоздатьДокумент();
	
	// заполним таблицу на форме
	ТекСтрока = Неопределено;
	ТекИдСтрокиТовара = ТекИдСтрокиТовара();

	тпТовары.Строки.Очистить();
	Если ТекущийДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Для каждого стр из ТекущийДокумент.Товары Цикл
		
		Если ОтборСтрок = 1 Тогда // Место реализации
			Если стр.Фирма.МестоРеализации <> глПараметрыРМ.МестоРеализации Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		Если ОтборСтрок = 2 Тогда // Станция
			МЗ = РегистрыСведений.ЗаказТоварыДопИнф.СоздатьМенеджерЗаписи();
			МЗ.Заказ = заказ.Ссылка;
			МЗ.ИдСтроки = стр.ИдСтроки;
			МЗ.Прочитать();
			Если МЗ.Станция <> глПараметрыРМ.Станция И ЗначениеЗаполнено(МЗ.Станция) Тогда
				Продолжить;	
			Иначе
				НовСтрока = тпТовары.Строки.Добавить();
				НовСтрока.Станция = МЗ.Станция;
			КонецЕсли;
		Иначе
			НовСтрока = тпТовары.Строки.Добавить();
			
		КонецЕсли;
		Если Не ЗначениеЗаполнено(НовСтрока.Станция) Тогда
		//	НовСтрока.Станция = глПараметрыРМ.Станция;
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НовСтрока,стр,,"Статус");
		НовСтрока.Блок = НЕ стр.ДокументОплаты.Пустая();
		
		МС = ТекущийДокумент.Специфики.НайтиСтроки(Новый Структура("НомерСтрокиТовара",Стр.НомерСтроки));
		Для Каждого СтрокаСпецифика ИЗ МС Цикл
			НовСтрокаСпецифика = НовСтрока.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрокаСпецифика, СтрокаСпецифика);		
			НовСтрокаСпецифика.Товар = СтрокаСпецифика.Специфика;
			НовСтрокаСпецифика.СуммаРеализации = НовСтрокаСпецифика.ЦенаРеализации * НовСтрокаСпецифика.Количество;
		КонецЦикла;
				
		Если НовСтрока.Количество И не НовСтрока.Блок Тогда
			ТекСтрока = НовСтрока;
		КонецЕсли;
	КонецЦикла;

	Для Каждого Т Из тпТовары.Строки Цикл
		Если т.Строки.Количество() и не ЭлементыФормы.тпТовары.Развернут(Т) Тогда
			ЭлементыФормы.тпТовары.Развернуть(Т);
		КонецЕсли;
		
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("УстановитьТекСтроку", 0.1, 1);	
КонецПроцедуры

Процедура ФильтроватьТП() Экспорт
	УдаляемыеСтроки = Новый Массив;
	Для каждого Т Из тпТовары.Строки Цикл
		
		Если ОтборСтрок = 1 Тогда // Место реализации
			Если Т.Фирма.МестоРеализации <> глПараметрыРМ.МестоРеализации Тогда
				УдаляемыеСтроки.Добавить(Т);
			КонецЕсли;
		ИначеЕсли ОтборСтрок = 2 Тогда // Станция
			Если Т.Станция <> глПараметрыРМ.Станция Тогда
				УдаляемыеСтроки.Добавить(Т);
			КонецЕсли;	
		КонецЕсли;	
	КонецЦикла; 
	
	Для Каждого Т Из УдаляемыеСтроки Цикл
		тпТовары.Строки.Удалить(Т);
	КонецЦикла;
КонецПроцедуры


Процедура ПоказатьМенюПовараФорма() Экспорт
	Если ВысотаТаблицыЗаказа = Неопределено Тогда
		ВысотаТаблицыЗаказа	= ЭлементыФормы.тпТовары.Высота;
		ВысотаПодвала		= ЭлементыФормы.КнопкаКоличество.Высота;
	КонецЕсли;
	//РаботаСокнами.ПоказатьПлашку("ПоказатьМенюПовараФорма", ""+ЭлементыФормы.тпТовары.Ширина);
	Если ТекущийРежим= "ПРОДАЖА" Тогда
		Если ФормаПодбораТоваров = Неопределено Тогда
			СменаМенюПовара();
		Иначе
			Если Не ФормаПодбораТоваров.Открыта() Тогда
				СменаМенюПовара();
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры




#Область УДАЛИТЬ

Процедура кнВесыНажатие(Элемент)
	глОтсечкаПростоя();
	Если ЗаказНеВыбран() Тогда
		Возврат;
	КонецЕсли;
	МенюВесов(Вес);
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура ОбновитьВес() Экспорт
	Если Не ЭтаФорма.Открыта() Тогда
		Возврат;
	КонецЕсли;
	ЭлементыФормы.тВес.Заголовок = Формат(Вес,"ЧДЦ=3; ЧРД=.; ЧН=0.000");
	Если фВводТоваровДоступен = Истина Тогда
		ИнтерфейсРМ.ВыводНаИнфоДисплей("ПоказатьВес",,,,,Вес);	
	КонецЕсли;
КонецПроцедуры

Процедура КоличествоНажатие(Элемент)
	ИзменитьКоличество();
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура СторноНажатие(Элемент)
	
	ТС = ЭлементыФормы.тпТовары.ТекущаяСтрока;
	Если ТС <> Неопределено Тогда
		НС = ТС.НомерСтроки;
	Иначе
		НС = 0;
	КонецЕсли;
	
	Сторно(НС);
	ОбновитьНадписьИтого();
КонецПроцедуры

Процедура кнМаркиНажатие(Элемент)
	Если ЕстьДозаказ() Тогда
		ПредупреждениеЕстьДозаказ();		
		Возврат;
	КонецЕсли;
	
	Попытка
		ФормаПодбораТоваров.Закрыть();	
	Исключение
	КонецПопытки;

	МониторМарок();
КонецПроцедуры

Процедура КнопкаВыдачаНажатие(Элемент)
	ИзменитьКурс(Истина);
КонецПроцедуры

Процедура ВводКартыГостя(Элемент)
	СброситьТекущийДокумент();	
КонецПроцедуры

Процедура ПоискТовараНажатие(Элемент)
	Если фВводТоваровДоступен Тогда
		ОткрытьФормуПоиска();
		ОбновитьНадписьИтого();
	КонецЕсли;
КонецПроцедуры

Процедура СторноВсеНажатие(Элемент)
	СторноВсе();
	ОбновитьНадписьИтого();
КонецПроцедуры                 

Процедура ИнициализацияТаблицыТоваров()
	
КонецПроцедуры


Функция ПанелиСкрыты() Экспорт
	Если РежимТестирования Тогда
		Возврат Истина;
	КонецЕсли;
	Если фФормаСкрытияМеню = 0 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка
		Если ФормаСкрытияМеню.Открыта() Тогда
			Возврат Ложь;
		КонецЕсли;
		
	Исключение
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

Функция ПоказатьПлашки() Экспорт
	//УстановитьВидимостьКнопки("Плашка1",ЗначениеЗаполнено(ЭлементыФормы.Плашка1.Заголовок),,,Ложь);	
	//УстановитьВидимостьКнопки("Плашка2",ЗначениеЗаполнено(ЭлементыФормы.Плашка2.Заголовок),,,Ложь);	
	//ЭлементыФормы.НадписьЛояльность2.Видимость = 1;
	//ШиринаПашки = ЭлементыФормы.Плашка1Тень.Лево + ЭлементыФормы.Плашка1Тень.Ширина + 3;
	//Для Каждого Элемент Из мСдвигаемыеЭлементы Цикл
	//	былоЛево = Элемент.Лево;	
	//	Лево = ШиринаПашки + ?(СтрНайти(Элемент.Имя,"Тень"),3,0);
	//	Дельта = былоЛево - Лево;
	//	Если Дельта Тогда
	//		Элемент.Ширина = Элемент.Ширина + Дельта; 
	//		Элемент.Лево = Лево;
	//	КонецЕсли;
	//	
	//КонецЦикла;	
	//ЭлементыФормы.КнопкаСкрытьПаказать.Заголовок = Шрифты.ПолучитьСимвол("arrow_circle_o_left");
	//ЭлементыФормы.КнопкаСкрытьПаказать.ЦветТекста = Метаданные.ЭлементыСтиля.АппБар.Значение;
	
КонецФункции

Функция СкрытьПлашки() Экспорт
	//УстановитьВидимостьКнопки("Плашка1",0,,,Ложь);
	//УстановитьВидимостьКнопки("Плашка2",0,,,Ложь);
	//ЭлементыФормы.НадписьЛояльность2.Видимость = 0;
	//Для Каждого Элемент Из мСдвигаемыеЭлементы Цикл
	//	былоЛево = Элемент.Лево;	
	//	Лево = 6 + ?(СтрНайти(Элемент.Имя,"Тень"),3,0);
	//	Дельта = былоЛево - Лево;
	//	Если Дельта Тогда
	//		Элемент.Лево = Лево;
	//		Элемент.Ширина = Элемент.Ширина + Дельта; 
	//	КонецЕсли;
	//КонецЦикла;	
	//ЭлементыФормы.КнопкаСкрытьПаказать.Заголовок = Шрифты.ПолучитьСимвол("arrow_circle_o_right");
	//ЭлементыФормы.КнопкаСкрытьПаказать.ЦветТекста = Метаданные.ЭлементыСтиля.Акцент.Значение;
КонецФункции


#КонецОбласти


#Область Инициализация

тПользователь = "";
тЗаказ = "";

фФормаСкрытияМеню = 0;

МассивЧисла = Новый Массив;
МассивЧисла.Добавить(Тип("Число"));

МассивТоварСпецифика = Массив(Тип("СправочникСсылка.Товары"), Тип("СправочникСсылка.Специфики"));
тпТовары.Строки.Очистить();
тпТовары.Колонки.Очистить();
тпТовары.Колонки.Добавить("НомерСтроки",Новый ОписаниеТипов("Число"),"N",2);
тпТовары.Колонки.Добавить("Модифицирована",Новый ОписаниеТипов("Булево")," ",1);
тпТовары.Колонки.Добавить("Автор",Новый ОписаниеТипов("СправочникСсылка.Сотрудники"),,1);
тпТовары.Колонки.Добавить("Товар",Новый ОписаниеТипов(МассивТоварСпецифика),,60);
тпТовары.Колонки.Добавить("Количество",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("КоличествоУдалено",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("х",,,1);
тпТовары.Колонки.Добавить("ЦенаРеализации",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,9);
тпТовары.Колонки.Добавить("Равно",,,1);
тпТовары.Колонки.Добавить("СуммаРеализации",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,10);
тпТовары.Колонки.Добавить("фАлкоголь",,,8);
тпТовары.Колонки.Добавить("КоличествоНачальное",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,3)),,9);
тпТовары.Колонки.Добавить("Подача");
тпТовары.Колонки.Добавить("блок",Новый ОписаниеТипов("Булево"),,1);

тпТовары.Колонки.Добавить("Фирма", Новый ОписаниеТипов("СправочникСсылка.Фирмы"),,1); 
тпТовары.Колонки.Добавить("ИдСтроки", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(30)),,1); 
тпТовары.Колонки.Добавить("ИдСвязаннойСтроки", Новый ОписаниеТипов("Строка",,,,Новый КвалификаторыСтроки(30)),,1); 
тпТовары.Колонки.Добавить("СтатусОплаты",Новый ОписаниеТипов("Число"),,1);


тпТовары.Колонки.Добавить("ЛояльностьГруппаАкции",Новый ОписаниеТипов("Число",,,Новый КвалификаторыЧисла(5,0)),,1);

тпТовары.Колонки.Добавить("Цена",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("НомерМарки",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,0)),,0);
тпТовары.Колонки.Добавить("Сумма",Новый ОписаниеТипов(МассивЧисла,,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("Статус",Новый ОписаниеТипов(Массив(Тип("ПеречислениеСсылка.СтатусыПозицийЗаказа")),,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("СтатусДопИнф",Новый ОписаниеТипов(Массив(Тип("ПеречислениеСсылка.СтатусыПозицийЗаказа")),,Новый КвалификаторыЧисла(15,2)),,0);
тпТовары.Колонки.Добавить("РабочееМесто",Новый ОписаниеТипов(Массив(Тип("СправочникСсылка.РабочиеМеста"))));
тпТовары.Колонки.Добавить("Станция",Новый ОписаниеТипов(Массив(Тип("СправочникСсылка.Станции"))));

//ВЕСЫ
Если глПараметрыРМ.ВесыЕсть Тогда
	Весы = глПараметрыРМ.Весы.ПолучитьОбъект();
	Обработка_Весы = Обработка_Весы;
	ИнициализацияТО(Весы, Обработка_Весы, глПараметрыРМ);
КонецЕсли;

//ОтборФирма = ЭлементыФормы.тпТовары.ОтборСтрок.Фирма;
//ОтборФирма.ВидСравнения = ВидСравнения.Равно;	 
//ОтборФирма.Значение = глПараметрыРМ.Фирма;
//ОтборФирма.Использование = Истина;
Попытка
	AutohotkeyDLL = РаботаСокнами.AHK(,"ГлавнаяФорма");
Исключение
КонецПопытки;
//ФормаСкрытияМеню = Обработки.СкрытьМенюИПанели.ПолучитьФорму();                                    ё
//ФормаСкрытияМеню.Открыть();	

ВариантыОтбораСтрок = Новый Соответствие();
ВариантыОтбораСтрок.Вставить(1,"по м.р.");
ВариантыОтбораСтрок.Вставить(2,"по станции");
ВариантыОтбораСтрок.Вставить(3,"весь заказ");
ОтборСтрок = 3;
ДопПараметрыИнфо.Вставить("ФирмаФильтр", глПараметрыРМ.Фирма);

ВысотаПодвала		= ЭлементыФормы.КнопкаКоличество.Высота; 

#КонецОбласти
