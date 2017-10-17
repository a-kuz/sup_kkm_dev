﻿Перем СтруктураНастроекПриОткрытии; // содержит структуру настроек при открытии формы.

Перем СтруктураДанныхКраткогоВида;
Перем МассивГруппировок;			// содержит массив группировок.
Перем СоответствиеОтборов;			// содержит соответствие отборов и их типов.
Перем Отмена;						// признак отмены при закрытии формы.
Перем ОчищатьЗначениеОтбораПриПодборе;
Перем ПодборИзДокумента;
Перем СписокВариантовФормирования;

// Обработчик события ПередОткрытием.
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	СтруктураНастроекПриОткрытии = ПолучитьТекущиеНастройки();
	Если НЕ ЗначениеЗаполнено(Период) Тогда
		Период = ПредставлениеПериода(ДатаС,ДатаПо);	
	КонецЕсли;	
КонецПроцедуры

// Обработчик события ПриОткрытии.
//
Процедура ПриОткрытии()
	ЭлементыФормы.ВидПериода.Доступность = ГруппироватьПоПериоду;
	ЭлементыФормы.ВариантФормирования.Доступность = ГруппироватьПоВиду;
	
	Если НЕ ЗначениеЗаполнено(ВидПериода) Тогда
		ВидПериода = "Смена";
	КонецЕсли;
	
	ЭлементыФормы.ВариантФормирования.Значение = СписокВариантовФормирования.НайтиПоЗначению(ВариантФормирования).Представление;
	
	ФормированиеОтчетов.ЗаполнитьТабличныеПоляОтборовКраткогоВида(ЭтотОбъект, ЭтаФорма, СтруктураДанныхКраткогоВида);
	
КонецПроцедуры

// Обработчик события ПередЗакрытием.
//
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если (КраткийВидНастройки = Истина) И НЕ Отмена Тогда
		ФормированиеОтчетов.ЗаполнитьНастройкиКомпоновкиДанныхПоПолямКраткогоВида(ЭтотОбъект, ЭтаФорма, СтруктураДанныхКраткогоВида);
	КонецЕсли;
	
	ФормированиеОтчетов.УстановитьНастройкиВФормеОтчета(ВладелецФормы);
	
КонецПроцедуры    

Процедура КнопкаДатаНажатие(Элемент)
	ФормированиеОтчетов.КнопкаПериодНажатие(ЭтотОбъект);
КонецПроцедуры

Процедура КнопкаСменыНажатие(Элемент) 
	ФормированиеОтчетов.КнопкаСменаНажатие(ЭтотОбъект);
КонецПроцедуры

// Обработчик события ПриИзменении флажка ГруппировкаПоПериоду.
//
Процедура ГруппировкаПоПериодуПриИзменении(Элемент)
	ЭлементыФормы.ВидПериода.Доступность = ГруппироватьПоПериоду;
КонецПроцедуры

// Обработчик нажатия кнопки ОК на панели ОсновныеДействияФормы.
//
Процедура ОсновныеДействияФормыОсновныеДействияФормыОК(Кнопка)
	
	Закрыть();
	СформироватьОтчет(ВладелецФормы.ЭлементыФормы.Результат,,,ВладелецФормы.ЭлементыФормы);
	
КонецПроцедуры

// Обработчик события ПриАктивизацииСтроки табличного поля ВидыОтбора.
//
Процедура ТабличноеПолеВидыОтбораПриАктивизацииСтроки(Элемент)
	ФормированиеОтчетов.ПриВыбореВидаОтбора(ЭтаФорма);
КонецПроцедуры

// Обработчик события ПередНачаломИзменения табличного поля ВидыОтбора.
//
Процедура ТабличноеПолеВидыОтбораПередНачаломИзменения(Элемент, Отказ)
	Если Элемент.ТекущаяКолонка = Элемент.Колонки["ЗначениеОтбора"] Тогда
		Отказ = Истина;
		ПодборИзДокумента = Ложь;
		ОчищатьЗначениеОтбораПриПодборе = Истина;
		ФормированиеОтчетов.ПриВыбореВидаОтбора(ЭтаФорма);
		ФормированиеОтчетов.ПодборЗначенийОтбора(ЭтаФорма, Ложь, ПодборИзДокумента);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПередОкончаниемРедактирования табличного поля ВидыОтбора.
//
Процедура ТабличноеПолеВидыОтбораПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	ТекДанные = ЭлементыФормы.ТабличноеПолеВидыОтбора.ТекущиеДанные;
	
	Если НЕ ОтменаРедактирования И ЗначениеЗаполнено(ТекДанные) И ЗначениеЗаполнено(ТекДанные.ПодборЗначения) 
		И Элемент.ТекущаяКолонка.Имя = "ПодборЗначения" Тогда
		
		Если ТекДанные.ВидОтбора = "Дни недели" Тогда
			Для Каждого элемент из ТекДанные.ПодборЗначения Цикл
				Если Элемент.Пометка Тогда
					ТекДанные.ЗначениеОтбора.Добавить(элемент.Значение);
				КонецЕсли;
			КонецЦикла;
		Иначе
			ТекДанные.ЗначениеОтбора.Добавить(ТекДанные.ПодборЗначения);
		КонецЕсли;
		
		ТекДанные.ПодборЗначения = Новый(ТипЗнч(ТекДанные.ПодборЗначения));
		ТекДанные.Пометка        = Истина;
		
		ФормированиеОтчетов.ПриВыбореВидаОтбора(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриВыводеСтроки табличного поля ВидыОтбора.
//
Процедура ТабличноеПолеВидыОтбораПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	Если ЗначениеЗаполнено(ДанныеСтроки.ЗначениеОтбора) Тогда
		Если НЕ ДанныеСтроки.ВидОтбора = "Дни недели" Тогда
			ОформлениеСтроки.Ячейки.ПодборЗначения.УстановитьТекст(ДанныеСтроки.ЗначениеОтбора);
		Иначе
			ОформлениеСтроки.Ячейки.ПодборЗначения.УстановитьТекст(ФормированиеОтчетов.отчПолучитьСписокДнейСПометкой(ДанныеСтроки.ЗначениеОтбора));
		КонецЕсли;
	Иначе
		ОформлениеСтроки.Ячейки.ПодборЗначения.УстановитьТекст("");
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриИзмененииФлажка табличного поля ВидыОтбора.
//
Процедура ТабличноеПолеВидыОтбораПриИзмененииФлажка(Элемент, Колонка)
	ФормированиеОтчетов.УправлениеАктуальностьюОтборов(ЭтаФорма);
КонецПроцедуры

// Обработчик события "Очистка" поля ввода ПодборЗначения табличного поля ТабличноеПолеВидыОтбора.
//
Процедура ТабличноеПолеВидыОтбораПодборЗначенияОчистка(Элемент, СтандартнаяОбработка)
	
	ТекДанные = ЭлементыФормы.ТабличноеПолеВидыОтбора.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекДанные) Тогда
		
		ТекДанные.ЗначениеОтбора.Очистить();
		ФормированиеОтчетов.ПриВыбореВидаОтбора(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события "НачалоВыбора" поля ввода ПодборЗначения табличного поля ТабличноеПолеВидыОтбора.
//
Процедура ТабличноеПолеВидыОтбораПодборЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	Если ЭлементыФормы.ТабличноеПолеВидыОтбора.ТекущиеДанные.ВидОтбора = "Дни недели" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ФормированиеОтчетов.отчЗаполнитьСписокДнейНеделиВОтборе(ЭлементыФормы, Элемент, мЧислоКогдаВПродаже)
		
	КонецЕсли;
		
КонецПроцедуры

// Обработчик события "ОбработкаВыбора" поля ввода ПодборЗначения табличного поля ТабличноеПолеЗначенияОтбора.
//
Процедура ТабличноеПолеЗначенияОтбораОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ТабличноеПолеЗначенияОтбора.Добавить().ЗначенияОтбора = ВыбранноеЗначение;
	ФормированиеОтчетов.ОбновитьЗначенияОтборов(ЭтаФорма);
КонецПроцедуры

// Обработчик события "ПослеУдаления" табличного поля ТабличноеПолеЗначенияОтбора.
//
Процедура ТабличноеПолеЗначенияОтбораПослеУдаления(Элемент)
	
	ФормированиеОтчетов.ОбновитьЗначенияОтборов(ЭтаФорма);
	
КонецПроцедуры

// Обработчик события "ПриОкончанииРедактирования" табличного поля ТабличноеПолеЗначенияОтбора.
//
Процедура ТабличноеПолеЗначенияОтбораПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		ФормированиеОтчетов.ОбновитьЗначенияОтборов(ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

// Процедура вызывается при нажатии на кнопку "Подбор" командной панели КоманднаяПанельЗначенияОтбора.
//
Процедура КоманднаяПанельЗначенияОтбораДействиеПодбор(Кнопка)
	
	ПодборИзДокумента = Ложь;
	ОчищатьЗначениеОтбораПриПодборе = Ложь;
	ФормированиеОтчетов.ПодборЗначенийОтбора(ЭтаФорма, Истина, ПодборИзДокумента);
	
КонецПроцедуры

// Обработчик нажатия кнопки Закрыть панели ОсновныеДействияФормы.
//
Процедура ОсновныеДействияФормыОсновныеДействияФормыЗакрыть(Кнопка)
	ЗагрузитьНастройки(СтруктураНастроекПриОткрытии);
	
	Отмена = Истина;
	Закрыть();
	
КонецПроцедуры

// Обработчик события ОбработкаВыбора.
//
Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	Если ОчищатьЗначениеОтбораПриПодборе Тогда
		ЭлементыФормы.ТабличноеПолеВидыОтбора.ТекущиеДанные.ЗначениеОтбора.Очистить();
		ЭлементыФормы.ТабличноеПолеЗначенияОтбора.Значение.Очистить();
	КонецЕсли;
	ФормированиеОтчетов.ОбработкаВыбораЗначенияВКраткомВиде(ЭтаФорма, ЗначениеВыбора, ПодборИзДокумента);	
	
КонецПроцедуры

// Обработчик события НачалоВыбораИзСписка поля ВариантФормирования.
//
Процедура ВариантФормированияНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ВыбранноеЗначение = ВыбратьИзМеню(СписокВариантовФормирования);
	Если Не ВыбранноеЗначение = Неопределено Тогда
		Элемент.Значение = ВыбранноеЗначение.Представление;
		ВариантФормирования = ВыбранноеЗначение.Значение;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик события ПриИзменении флажка ГруппироватьПоВиду.
Процедура ГруппироватьПоВидуПриИзменении(Элемент)
	ЭлементыФормы.ВариантФормирования.Доступность = ГруппироватьПоВиду;
КонецПроцедуры

// Обработка нажатия кнопки Кратко.
//
Процедура ККраткомуВиду(Элемент)
	Ответ = Вопрос("При переключении к краткому виду данные о настройках будут утеряны. Продолжить?", РежимДиалогаВопрос.ДаНет,, КодВозвратаДиалога.Нет);
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;		
	КонецЕсли;	
	
	ЭлементыФормы.ГлавнаяПанель.ТекущаяСтраница = ЭлементыФормы.ГлавнаяПанель.Страницы.Страница1;
	КраткийВидНастройки = Истина;
	
	//КомпоновщикНастроек.Настройки	
КонецПроцедуры

// Обработка нажатия кнопки Подробно.
//
Процедура КПодробномуВиду(Элемент)
	ЭлементыФормы.ГлавнаяПанель.ТекущаяСтраница = ЭлементыФормы.ГлавнаяПанель.Страницы.Страница2;
	КраткийВидНастройки = Ложь;
	
	КомпоновщикНастроек.Настройки.Структура.Очистить();
	
	Если ПоказыватьДиаграмму И ПараметрВыводаДиаграммы = 0 Тогда
		СформироватьДиаграмму();
	КонецЕсли;
	
	КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение = Заголовок;
	
	// добавим поле группировки		
	Родитель = КомпоновщикНастроек.Настройки;
	
	Если ГруппироватьПоПериоду Тогда
		ГруппировкаПоПериоду = Родитель.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		
		ПолеГруппировки                = ГруппировкаПоПериоду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ВидПериода);
		
		// Добавим колонку дня недели рядом с датой
		Если ВидПериода = "День" Тогда
			
			ПолеГруппировки                = ГруппировкаПоПериоду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ДниНедели");
			
		КонецЕсли;
		
		НовоеВыбранноеПоле = ГруппировкаПоПериоду.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		
		Родитель = ГруппировкаПоПериоду;	 
	КонецЕсли;
	
	Если ГруппироватьПоВиду Тогда
		ГруппировкаПоВиду = Родитель.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
		
		ПолеГруппировки                = ГруппировкаПоВиду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ВариантФормирования);
		
		НовоеВыбранноеПоле = ГруппировкаПоВиду.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		
		Родитель = ГруппировкаПоВиду;	 
	КонецЕсли;
	
	ДетальныеЗаписи = Родитель.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
	ВыбранноеПоле = ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
	
	
	Если ПоказыватьДиаграмму И ПараметрВыводаДиаграммы = 1 Тогда
		СформироватьДиаграмму();
	КонецЕсли;
	
КонецПроцедуры

Отмена = Ложь;
СтруктураНастроекПриОткрытии = Новый Структура;
ПодборИзДокумента = Ложь;
ОчищатьПриПодборе = Ложь;


СписокВидовПериодов = Новый СписокЗначений;

СписокВариантовФормирования = Новый СписокЗначений;
СписокВариантовФормирования.Добавить("Автор", "Автор удаления");
СписокВариантовФормирования.Добавить("Товар", "Товар");
СписокВариантовФормирования.Добавить("Причина", "Причина удаления");
СписокВариантовФормирования.Добавить("Официант", "Официант");
СписокВариантовФормирования.Добавить("Заказ", "Заказ");

СоответствиеОтборов = Новый Соответствие;
СоответствиеОтборов.Вставить(Новый ПолеКомпоновкиДанных("МестоРеализации") , Новый ОписаниеТипов("СправочникСсылка.МестаРеализации"));
Если ПараметрыСеанса.РаспределенныйРежим Тогда
	СоответствиеОтборов.Вставить(Новый ПолеКомпоновкиДанных("ИнформационнаяБаза") , Новый ОписаниеТипов("СправочникСсылка.ИнформационныеБазы"));
КонецЕсли;
СоответствиеОтборов.Вставить(Новый ПолеКомпоновкиДанных("Причина")         , Новый ОписаниеТипов("СправочникСсылка.ПричиныУдалений"));
СоответствиеОтборов.Вставить(Новый ПолеКомпоновкиДанных("Автор")           , Новый ОписаниеТипов("СправочникСсылка.Сотрудники"));
СоответствиеОтборов.Вставить(Новый ПолеКомпоновкиДанных("ПосадочноеМесто") , Новый ОписаниеТипов("СправочникСсылка.ПосадочныеМеста"));
СоответствиеОтборов.Вставить(Новый ПолеКомпоновкиДанных("Товар")           , Новый ОписаниеТипов("СправочникСсылка.Товары"));
СоответствиеОтборов.Вставить(Новый ПолеКомпоновкиДанных("ДниНедели")       , СписокВидовПериодов);

СтруктураДанныхКраткогоВида = Новый Структура;
СтруктураДанныхКраткогоВида.Вставить("СоответствиеОтборов" , СоответствиеОтборов);
