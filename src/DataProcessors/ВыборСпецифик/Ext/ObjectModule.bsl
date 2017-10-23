﻿#Если Клиент Тогда
Перем ПустаяСпецифика;
Перем СтатусДозаказ;

// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
КонецПроцедуры

// Вызывается один раз при создании объекта обработки.
// Объект затем сохраняется в структуре глОбработки для хранения объектов используемых обработок.
Процедура ИнициализацияРеквизитов()
	
	ПустаяСпецифика = Справочники.Специфики.ПустаяСсылка();
	СтатусДозаказ	= Перечисления.СтатусыПозицийЗаказа.Дозаказ;	
	
	УстановкаНачальныхЗначений();
	
КонецПроцедуры

Процедура ДобавитьЭлементыПодгруппы(Группа, Подгруппа, ЭлементОбхода, ДобавитьПоУмолчанию)

	СпрСпецифики = Справочники.Специфики;
	Выборка = СпрСпецифики.ВыбратьИерархически(ЭлементОбхода);
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ксТрактир.СпецификаИспользуется(Выборка.Ссылка,ТекущаяДата()) Тогда
			Продолжить;
		КонецЕсли; 
		
		Если Выборка.ЭтоГруппа Тогда
			ДобавитьЭлементыПодгруппы(Группа, Подгруппа, Выборка.Ссылка, ДобавитьПоУмолчанию);
			
		ИначеЕсли ЗначениеЗаполнено(Выборка.ГруппаСпецифик) Тогда
			ДобавитьЭлементыПодгруппы(Группа, Подгруппа, Выборка.ГруппаСпецифик, ДобавитьПоУмолчанию);
			
		Иначе
			НоваяСтрока = Специфики.Добавить();
			НоваяСтрока.Специфика = Выборка.Ссылка;
			НоваяСтрока.Группа = Группа;
			НоваяСтрока.Подгруппа = Подгруппа;
			НоваяСтрока.Плюс  = "+";
			НоваяСтрока.Минус = "–";
			НоваяСтрока.Порядок = выборка.Порядок;
			Если НоваяСтрока.Специфика.ЕстьЦена тогда
				Отбор = Новый Структура("ТипЦен,Номенклатура", Справочники.ТипыЦен.Розничная, НоваяСтрока.Специфика.Номенклатура);
				СтруктураЦены = РегистрыСведений.ЦеныНоменклатуры.ПолучитьПоследнее(ПолучитьРабочуюДату(), Отбор);
				НоваяСтрока.Цена = ПересчетВалют(СтруктураЦены.Цена, СтруктураЦены.Валюта);
			иначе
				НоваяСтрока.Цена = 0;
			КонецЕсли;
			Если Выборка.ПоУмолчанию > 0 тогда
				НоваяСтрока.УдельныйВес = выборка.ПоУмолчанию;
				НоваяСтрока.Выбрана		= 1;
			КонецЕсли;
		КонецЕсли; 		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ДобавитьЭлементыГруппы(Группа, ЭлементОбхода, ДобавитьПоУмолчанию)

	СпрСпецифики = Справочники.Специфики;
	Выборка = СпрСпецифики.Выбрать(ЭлементОбхода);
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ксТрактир.СпецификаИспользуется(Выборка.Ссылка,ТекущаяДата()) Тогда
			Продолжить;
		КонецЕсли; 
		
		Если Выборка.ЭтоГруппа Тогда
			ДобавитьЭлементыПодгруппы(Группа, Выборка.Ссылка, Выборка.Ссылка, ДобавитьПоУмолчанию);
			
		ИначеЕсли ЗначениеЗаполнено(Выборка.ГруппаСпецифик) Тогда
			ДобавитьЭлементыПодгруппы(Группа, Выборка.Ссылка, Выборка.ГруппаСпецифик, ДобавитьПоУмолчанию);
			
		Иначе
			НоваяСтрока = Специфики.Добавить();
			НоваяСтрока.Специфика = Выборка.Ссылка;
			НоваяСтрока.Группа = Группа;
			НоваяСтрока.Подгруппа = ПустаяСпецифика;
			НоваяСтрока.Плюс = "+";
			НоваяСтрока.Минус = "–";
			НоваяСтрока.Порядок = выборка.Порядок;
			Если НоваяСтрока.Специфика.ЕстьЦена тогда
				Отбор = Новый Структура("ТипЦен,Номенклатура", Справочники.ТипыЦен.Розничная, НоваяСтрока.Специфика.Номенклатура);
				СтруктураЦены = РегистрыСведений.ЦеныНоменклатуры.ПолучитьПоследнее(ПолучитьРабочуюДату(), Отбор);
				НоваяСтрока.Цена = ПересчетВалют(СтруктураЦены.Цена, СтруктураЦены.Валюта);
			иначе
				НоваяСтрока.Цена = 0;
			КонецЕсли;
			Если Выборка.ПоУмолчанию > 0 и ДобавитьПоУмолчанию тогда
				НоваяСтрока.УдельныйВес = выборка.ПоУмолчанию;
				НоваяСтрока.Выбрана		= 1;
			КонецЕсли;
		КонецЕсли; 		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьТаблицыСпецифик(ВыбТовар,АвтоПозиция=Ложь,ДобавитьПоУмолчанию=Ложь) Экспорт

	ГруппыСпецифик.Очистить();
	Специфики.Очистить();
	
	Если Не ЗначениеЗаполнено(ВыбТовар) Тогда
		Возврат;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(ВыбТовар.ГруппаСпецифик) Тогда
		Возврат;
	КонецЕсли; 
	
	МинУдельныйВесТовара = ВыбТовар.МинУдельныйВес;
	МаксУдельныйВесТовара = ВыбТовар.МаксУдельныйВес;
	
	Корень = ВыбТовар.ГруппаСпецифик;
	УровеньКорень = Корень.Уровень();
	
	СпрСпецифики = Справочники.Специфики;
	Выборка = СпрСпецифики.Выбрать(Корень);
	
	Пока Выборка.Следующий() Цикл
		
		Если НЕ ксТрактир.СпецификаИспользуется(Выборка.Ссылка,ТекущаяДата()) Тогда
			Продолжить;
		КонецЕсли; 
		
		Если Выборка.ЭтоГруппа Тогда
			НоваяГруппа = ГруппыСпецифик.Добавить();
			НоваяГруппа.Специфика = Выборка.Ссылка;
			НоваяГруппа.Наименование = Выборка.Наименование;
			НоваяГруппа.МинУдельныйВес = Выборка.МинУдельныйВес;
			НоваяГруппа.МаксУдельныйВес = Выборка.МаксУдельныйВес;
			НоваяГруппа.Порядок	= Выборка.Порядок;
			ДобавитьЭлементыГруппы(Выборка.Ссылка, Выборка.Ссылка,ДобавитьПоУмолчанию);
			
		ИначеЕсли ЗначениеЗаполнено(Выборка.ГруппаСпецифик) Тогда
			НоваяГруппа = ГруппыСпецифик.Добавить();
			НоваяГруппа.Специфика = Выборка.Ссылка;
			НоваяГруппа.Наименование = Выборка.Наименование;
			НоваяГруппа.МинУдельныйВес = Выборка.МинУдельныйВес;
			НоваяГруппа.МаксУдельныйВес = Выборка.МаксУдельныйВес;
			НоваяГруппа.Порядок	= Выборка.Порядок;
			ДобавитьЭлементыГруппы(Выборка.Ссылка, Выборка.ГруппаСпецифик,ДобавитьПоУмолчанию);	
			
		Иначе
			
			НайденнаяГруппа = ГруппыСпецифик.Найти(Корень, "Специфика");
			Если НайденнаяГруппа = Неопределено Тогда
				НоваяГруппа = ГруппыСпецифик.Добавить();
				НоваяГруппа.Наименование = Корень.Наименование;//"<...> ";
				НоваяГруппа.Специфика = Корень;
				НоваяГруппа.МинУдельныйВес = Корень.МинУдельныйВес;
				НоваяГруппа.МаксУдельныйВес = Корень.МаксУдельныйВес;
				НоваяГруппа.Порядок	= Корень.Порядок;
			КонецЕсли; 
			
			НоваяСтрока = Специфики.Добавить();
			НоваяСтрока.Специфика = Выборка.Ссылка;
			НоваяСтрока.Группа = Корень;
			НоваяСтрока.Подгруппа = ПустаяСпецифика;
			НоваяСтрока.Плюс = "+";
			НоваяСтрока.Минус = "–";
			НоваяСтрока.Порядок	= Выборка.Порядок;
			Если НоваяСтрока.Специфика.ЕстьЦена тогда
				Отбор = Новый Структура("ТипЦен,Номенклатура", Справочники.ТипыЦен.Розничная, НоваяСтрока.Специфика.Номенклатура);
				СтруктураЦены = РегистрыСведений.ЦеныНоменклатуры.ПолучитьПоследнее(ПолучитьРабочуюДату(), Отбор);
				НоваяСтрока.Цена = ПересчетВалют(СтруктураЦены.Цена, СтруктураЦены.Валюта);
			иначе
				НоваяСтрока.Цена = 0;
			КонецЕсли;
			
			Если Автопозиция и глПараметрыРМ.ЗКП тогда
				//автоматически добавляем
				НоваяСтрока.УдельныйВес = 1;
				НоваяСтрока.Выбрана 	= 1;
			ИначеЕсли Выборка.ПоУмолчанию > 0 и ДобавитьПоУмолчанию тогда
				НоваяСтрока.УдельныйВес = выборка.ПоУмолчанию;
				НоваяСтрока.Выбрана		= 1;
			КонецЕсли;	
		КонецЕсли; 		
	КонецЦикла; 
	
	// Удаление групп, для которых нет специфик
	К = ГруппыСпецифик.Количество()-1;
	Пока К > -1 Цикл
		Группа = ГруппыСпецифик[К].Специфика;
		
		НайденнаяСтрока = Специфики.Найти(Группа, "Группа");
		
		Если НайденнаяСтрока = Неопределено Тогда
			ГруппыСпецифик.Удалить(К);
		КонецЕсли; 
		
		К = К - 1;
	КонецЦикла; 
	
	ГруппыСпецифик.Сортировать("Порядок");
КонецПроцедуры

Функция ТаблицаНастроекСпецифик() Экспорт
	тзСпецифики = Специфики.Выгрузить();
	тзСпецифики.Свернуть("Группа, Подгруппа", "УдельныйВес, Выбрана");
	
	ТипУдВес = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(2, 0, ДопустимыйЗнак.Неотрицательный));
	
	тзНастройки = тзСпецифики.Скопировать();
	тзНастройки.Свернуть("Группа", "");
	Колонки = тзНастройки.Колонки;
	Колонки.Добавить("УдельныйВес", ТипУдВес);
	Колонки.Добавить("МинУдельныйВес", ТипУдВес);
	Колонки.Добавить("МаксУдельныйВес", ТипУдВес);
	Колонки.Добавить("РазрешитьПовторение");
	Колонки.Добавить("ОднаИзГруппы");
	Колонки.Добавить("ТаблицаПодгрупп");
	
	ТаблицаПодгруппШаблон = Новый ТаблицаЗначений;
	Колонки = ТаблицаПодгруппШаблон.Колонки;
	Колонки.Добавить("Подгруппа");
	Колонки.Добавить("УдельныйВес", ТипУдВес);
	Колонки.Добавить("Выбрана", ТипУдВес);
	Колонки.Добавить("МинУдельныйВес", ТипУдВес);
	Колонки.Добавить("МаксУдельныйВес", ТипУдВес);
	Колонки.Добавить("РазрешитьПовторение");
	Колонки.Добавить("ОднаИзГруппы");
	Колонки.Добавить("ТаблицаПодгрупп");
	Колонки.Добавить("Порядок");
	
	Отбор = Новый Структура("Группа", "");
	
	Для каждого СтрокаГруппы  Из тзНастройки Цикл
		
		ТекГруппа = СтрокаГруппы.Группа;
		
		СтрокаГруппы.МинУдельныйВес  = ТекГруппа.МинУдельныйВес;
		СтрокаГруппы.МаксУдельныйВес = ТекГруппа.МаксУдельныйВес;
		
		ТекГруппа2 = ?(ТекГруппа.ЭтоГруппа, ТекГруппа, ТекГруппа.ГруппаСпецифик);
		
		Если ЗначениеЗаполнено(ТекГруппа2) Тогда
			СтрокаГруппы.РазрешитьПовторение  = ТекГруппа2.РазрешитьПовторение;
			СтрокаГруппы.ОднаИзГруппы         = ТекГруппа2.ОднаИзГруппы;
		Иначе
			СтрокаГруппы.РазрешитьПовторение  = Ложь;
			СтрокаГруппы.ОднаИзГруппы         = Ложь;
		КонецЕсли; 
		
		СтрокаГруппы.ТаблицаПодгрупп = ТаблицаПодгруппШаблон.Скопировать();
		ТаблицаПодгрупп = СтрокаГруппы.ТаблицаПодгрупп;
		
		Отбор.Группа = ТекГруппа;
		МассивСтрок = тзСпецифики.НайтиСтроки(Отбор);
		
		Для К = 0 По МассивСтрок.Количество()-1 Цикл
			СтрокаПодгруппы = МассивСтрок[К];
			ТекПодгруппа    = СтрокаПодгруппы.Подгруппа;
			
			НоваяСтрока = ТаблицаПодгрупп.Добавить();
			НоваяСтрока.Подгруппа       = ТекПодгруппа;
			НоваяСтрока.МинУдельныйВес  = ТекПодгруппа.МинУдельныйВес;
			НоваяСтрока.МаксУдельныйВес = ТекПодгруппа.МаксУдельныйВес;
			НоваяСтрока.УдельныйВес     = СтрокаПодгруппы.УдельныйВес;
			НоваяСтрока.Выбрана         = СтрокаПодгруппы.Выбрана;
			НоваяСтрока.Порядок			= Текподгруппа.Порядок;
			
			ТекПодгруппа2 = ?(ТекПодгруппа.ЭтоГруппа, ТекПодгруппа, ТекПодгруппа.ГруппаСпецифик);
			
			Если ЗначениеЗаполнено(ТекПодгруппа2) Тогда
				НоваяСтрока.РазрешитьПовторение  = ТекПодгруппа2.РазрешитьПовторение;
				НоваяСтрока.ОднаИзГруппы         = ТекПодгруппа2.ОднаИзГруппы;
			Иначе
				НоваяСтрока.РазрешитьПовторение  = Ложь;
				НоваяСтрока.ОднаИзГруппы         = Ложь;
			КонецЕсли; 
		КонецЦикла; 
		
		ТаблицаПодгрупп.Сортировать("Порядок");
		СтрокаГруппы.УдельныйВес = ТаблицаПодгрупп.Итог("УдельныйВес");
	КонецЦикла; 
	
	Возврат тзНастройки;
	
КонецФункции

Процедура ДобавитьОшибкуВТаблицу(ТаблицаОшибок, ПроверяемыйОбъект, КатегорияОбъекта, Ошибка)

	Строка = ТаблицаОшибок.Добавить();
	Строка.ПроверяемыйОбъект	= ПроверяемыйОбъект;
	Строка.КатегорияОбъекта		= КатегорияОбъекта;
	Строка.Ошибка				= Ошибка;

КонецПроцедуры

// Если ТолькоПоГруппам = Истина, то фукнция не будет возвращать ошибки по подгруппам,
// если есть ошибки по товару или группам. Но если ошибок по товару и группам нет, то
// ошибки по подгруппам будут возвращены в массиве.
// Если ТолькоПоГруппам = Ложь, то в массиве будут все обнаруженные ошибки.
//
Функция КонтрольОграничений(тзНастройки, ТолькоПоГруппам=Ложь) Экспорт

	ТаблицаОшибок = Новый ТаблицаЗначений;
	ТаблицаОшибок.Колонки.Добавить("ПроверяемыйОбъект");
	ТаблицаОшибок.Колонки.Добавить("КатегорияОбъекта");
	ТаблицаОшибок.Колонки.Добавить("Ошибка");
	
	УдельныйВесТовар = тзНастройки.Итог("УдельныйВес"); // повторный расчет на всякий случай
	
	// по товару в целом
	Если НЕ((МинУдельныйВесТовара <= УдельныйВесТовар) И (УдельныйВесТовар <= МаксУдельныйВесТовара)) Тогда
		ТекстОшибки = "По общему количеству";
		ДобавитьОшибкуВТаблицу(ТаблицаОшибок, Товар, "Товар", ТекстОшибки);
	КонецЕсли; 

	// по спефификам
	Для каждого СтрокаГруппы Из тзНастройки Цикл
		
		// по группе специфик
		Если НЕ((СтрокаГруппы.МинУдельныйВес <= СтрокаГруппы.УдельныйВес) И (СтрокаГруппы.УдельныйВес <= СтрокаГруппы.МаксУдельныйВес)) Тогда
			ТекстОшибки = "В пределах группы "+СтрокаГруппы.Группа+"";
			ДобавитьОшибкуВТаблицу(ТаблицаОшибок, СтрокаГруппы.Группа, "Группа", ТекстОшибки);
		КонецЕсли; 
		
		ТаблицаПодгрупп = СтрокаГруппы.ТаблицаПодгрупп;
		
		Для каждого СтрокаПодгруппы Из ТаблицаПодгрупп Цикл
			Если ЗначениеЗаполнено(СтрокаПодгруппы.Подгруппа) Тогда
				// по подгруппе специфик
				Если НЕ((СтрокаПодгруппы.МинУдельныйВес <= СтрокаПодгруппы.УдельныйВес) И (СтрокаПодгруппы.УдельныйВес <= СтрокаПодгруппы.МаксУдельныйВес)) Тогда
					ТекстОшибки = "В пределах группы "+СтрокаГруппы.Группа+"/"+СтрокаПодгруппы.Подгруппа+"";
					ДобавитьОшибкуВТаблицу(ТаблицаОшибок, СтрокаПодгруппы.Подгруппа, "Подгруппа", ТекстОшибки);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 	
	КонецЦикла; 
	
	Если ТолькоПоГруппам Тогда
		ПараметрыОтбора = Новый Структура("КатегорияОбъекта", "Подгруппа");
		
		ОшибкиВПодгруппах = ТаблицаОшибок.НайтиСтроки(ПараметрыОтбора);
		
		Если (ОшибкиВПодгруппах.Количество() > 0) И (ТаблицаОшибок.Количество() > ОшибкиВПодгруппах.Количество()) Тогда
		
			Для К = 0 По ОшибкиВПодгруппах.Количество() - 1 Цикл
				ТаблицаОшибок.Удалить(ОшибкиВПодгруппах[К]);
			КонецЦикла; 			
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат ТаблицаОшибок;
	
КонецФункции

Функция ДеревоВыбранныхСпецифик()

	ТипУдВес = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(2, 0, ДопустимыйЗнак.Неотрицательный));
	
	дСпец = Новый ДеревоЗначений;
	дСпец.Колонки.Добавить("Специфика");
	дСпец.Колонки.Добавить("УдельныйВес", ТипУдВес); // именно суммарный удельный вес
	дСпец.Колонки.Добавить("Количество",  ТипУдВес); // количество выбранных позиций = [уд.вес по строке]/[ уд.вес специфики]
	дСпец.Колонки.Добавить("Цена");
	дСпец.Колонки.Добавить("ЭтоГруппа");
	дСпец.Колонки.Добавить("Порядок");
	дСпец.Колонки.Добавить("ПорядокСпецифики");
	
	Корень = Товар.ГруппаСпецифик;
	Для каждого СтрокаСпецифики Из Специфики Цикл
		Если СтрокаСпецифики.УдельныйВес > 0 Тогда
		
			Группа = СтрокаСпецифики.Группа;			
			Подгруппа = СтрокаСпецифики.Подгруппа;
			Специфика = СтрокаСпецифики.Специфика;
			
			ВыбУдельныйВес = СтрокаСпецифики.УдельныйВес;
			ВыбКоличество  = ?(Специфика.УдельныйВес = 0, 1, Окр(ВыбУдельныйВес/Специфика.УдельныйВес, 0));
			
			// *** Одноуровневый вывод специфик - только элемент ***
			НоваяСтрока = дСпец.Строки.Добавить();
			НоваяСтрока.Специфика   = Специфика;
			НоваяСтрока.УдельныйВес = ВыбУдельныйВес;
			НоваяСтрока.Количество  = ВыбКоличество;
			НоваяСтрока.Цена		= СтрокаСпецифики.Цена;
			НоваяСтрока.ЭтоГруппа   = Ложь;
			НоваяСтрока.Порядок		= ?(СтрокаСпецифики.Цена=0,?(ксТрактир.ОбщаяСпецифика(Специфика),3,2),1);
			
			СпрГруппа=Специфика;
			Пока 1=1 Цикл
				Если НЕ ЗначениеЗаполнено(СпрГруппа.Родитель) Тогда
					Прервать;
				КонецЕсли;	
				СпрГруппа=СпрГруппа.Родитель;
				Если СпрГруппа.Уровень()=1 Тогда
					Прервать;
				КонецЕсли;		
				Если СпрГруппа.Родитель=0 Тогда
					Прервать;
				КонецЕсли;	
			КонецЦикла;	
			НоваяСтрока.ПорядокСпецифики=СпрГруппа.Порядок*1000+Специфика.Порядок;
			//// *** Двухуровневый вывод специфик - только родитель и элемент ***
			//РодительСпец = ?(ЗначениеЗаполнено(Подгруппа), Подгруппа, Группа);
			//Если РодительСпец = Корень Тогда
			//	РодительСпец = ПустаяСпецифика; // иначе будет выдавать ошибку при добавлении общей специфики в заказ
			//КонецЕсли; 
			//
			//Если НЕ ЗначениеЗаполнено(РодительСпец) Тогда
			//	НоваяСтрока = дСпец.Строки.Добавить();
			//	НоваяСтрока.Специфика   = Специфика;
			//	НоваяСтрока.УдельныйВес = ВыбУдельныйВес;
			//	НоваяСтрока.Количество  = ВыбКоличество;
			//	НоваяСтрока.ЭтоГруппа   = Ложь;
			//	
			//Иначе
			//	СтрокаРодителя = дСпец.Строки.Найти(РодительСпец, "Специфика", Ложь);	
			//	Если СтрокаРодителя = Неопределено Тогда
			//		СтрокаРодителя = дСпец.Строки.Добавить();
			//		СтрокаРодителя.Специфика = РодительСпец;
			//		СтрокаРодителя.ЭтоГруппа    = Истина;
			//	КонецЕсли; 
			//	
			//	НоваяСтрока = СтрокаРодителя.Строки.Добавить();
			//	НоваяСтрока.Специфика   = Специфика;
			//	НоваяСтрока.УдельныйВес = ВыбУдельныйВес;
			//	НоваяСтрока.Количество  = ВыбКоличество;
			//	НоваяСтрока.ЭтоГруппа   = Ложь;
			//КонецЕсли; 

			// *** Трехуровневый вывод специфик ***
			//Если НЕ ЗначениеЗаполнено(Группа) Тогда
			//	НоваяСтрока = дСпец.Строки.Добавить();
			//	НоваяСтрока.Специфика = Специфика;
			//	НоваяСтрока.УдельныйВес = ВыбУдельныйВес;
			//	НоваяСтрока.Количество  = ВыбКоличество;
			//	НоваяСтрока.ЭтоГруппа   = Ложь;
			//	
			//Иначе
			//	СтрокаГруппы = дСпец.Строки.Найти(Группа, "Специфика", Ложь);	
			//	Если СтрокаГруппы = Неопределено Тогда
			//		СтрокаГруппы = дСпец.Строки.Добавить();
			//		СтрокаГруппы.Специфика = Группа;
			//		СтрокаГруппы.ЭтоГруппа = Истина;
			//	КонецЕсли; 
			//	
			//	Если НЕ ЗначениеЗаполнено(Подгруппа) Тогда
			//		НоваяСтрока = СтрокаГруппы.Строки.Добавить();
			//		НоваяСтрока.Специфика   = Специфика;
			//		НоваяСтрока.УдельныйВес = ВыбУдельныйВес;
			//		НоваяСтрока.Количество  = ВыбКоличество;
			//		НоваяСтрока.ЭтоГруппа   = Ложь;
			//	Иначе
			//		СтрокаПодгруппы = СтрокаГруппы.Строки.Найти(Подгруппа, "Специфика", Ложь);	
			//		Если СтрокаПодгруппы = Неопределено Тогда
			//			СтрокаПодгруппы = СтрокаГруппы.Строки.Добавить();
			//			СтрокаПодгруппы.Специфика = Подгруппа;
			//			СтрокаПодгруппы.ЭтоГруппа = Истина;
			//		КонецЕсли; 
			//		
			//		НоваяСтрока = СтрокаПодгруппы.Строки.Добавить();
			//		НоваяСтрока.Специфика   = Специфика;
			//		НоваяСтрока.УдельныйВес = ВыбУдельныйВес;
			//		НоваяСтрока.Количество  = ВыбКоличество;
			//		НоваяСтрока.ЭтоГруппа   = Ложь;
			//	КонецЕсли;
			//КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
	дСпец.Строки.Сортировать("Порядок,ПорядокСпецифики");
	Возврат дСпец;
	
КонецФункции 

Процедура РасчетИтоговПоГруппамСпецифик()

	// рассчитаем итоги по группам
	тзСпецифики = Специфики.Выгрузить();
	тзСпецифики.Свернуть("Группа", "УдельныйВес,Сумма");
	
	Для каждого СтрокаСпецифики Из тзСпецифики Цикл
		СтрокаГруппы = ГруппыСпецифик.Найти(СтрокаСпецифики.Группа, "Специфика");
		
		Если СтрокаГруппы <> Неопределено Тогда
			СтрокаГруппы.УдельныйВес 	= СтрокаСпецифики.УдельныйВес;
			СтрокаГруппы.Сумма			= СтрокаСпецифики.Сумма;
		КонецЕсли; 
	КонецЦикла; 
	
	// итог по товару
	УдельныйВесТовар = Специфики.Итог("УдельныйВес");
	//СуммаТовар = Специфики.Итог("Сумма");

КонецПроцедуры

Процедура ЗаполнитьТаблицуСпецификДаннымиИзЗаказа(СтрокаТовара)

	// конкретные значения специфик (т.е. элементы) в обработке содержатся в таб.части Специфики в колонке "Специфика".
	Для каждого СтрокаСпецификиЗаказа Из СтрокаТовара.Строки Цикл
		
		НайденнаяСтрока = Специфики.Найти(СтрокаСпецификиЗаказа.Товар, "Специфика");
		
		Если НайденнаяСтрока <> Неопределено Тогда
			НайденнаяСтрока.УдельныйВес = НайденнаяСтрока.УдельныйВес + НайденнаяСтрока.Специфика.УдельныйВес;
			НайденнаяСтрока.Сумма = НайденнаяСтрока.Цена * НайденнаяСтрока.УдельныйВес;
			НайденнаяСтрока.Выбрана = ?(НайденнаяСтрока.УдельныйВес > 0, 1, 0);
			
			// заказанную специфику нельзя удалять; 
			// в колонке УдельныйВесЗаказано будем хранить уже заказанный уд. вес
			Если СтрокаСпецификиЗаказа.Статус <> СтатусДозаказ Тогда
				НайденнаяСтрока.УдельныйВесЗаказано = НайденнаяСтрока.УдельныйВесЗаказано + НайденнаяСтрока.Специфика.УдельныйВес;
			КонецЕсли; 
			
		Иначе
			// Это или общая специфика, или специфика была добавлена в заказ в обход этой обработки. Или изменились настройки специфик.
			// В любом случае игнорируем эту специфику.
		КонецЕсли; 
		
		ЗаполнитьТаблицуСпецификДаннымиИзЗаказа(СтрокаСпецификиЗаказа);
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаполнитьТаблицуГруппИСпецификДаннымиИзЗаказа(СтрокаТовара)

	ЗаполнитьТаблицуСпецификДаннымиИзЗаказа(СтрокаТовара);
	
	РасчетИтоговПоГруппамСпецифик();
	
КонецПроцедуры
 
Функция ВыполнитьВыборСпецифик(Знач СтрокаТовара, ТолькоПроверка=Ложь,АвтоПозиция=Ложь, СпецификаВыбор = Неопределено) Экспорт

	Результат = Новый Структура("Контроль, ВыборСделан, Специфики", Истина, Ложь, Новый ДеревоЗначений);
	
	Товар = СтрокаТовара.Товар;
	СуммаТовар = СтрокаТовара.Цена;
	ВыборСпец = ?(СпецификаВыбор<>Неопределено,СпецификаВыбор.Товар,Справочники.Специфики.ПустаяСсылка());
	
	Если Не ЗначениеЗаполнено(Товар) Тогда
		Возврат Результат;
	КонецЕсли; 
	
	Если НЕ ЗначениеЗаполнено(Товар.ГруппаСпецифик) Тогда
		Возврат Результат;
	КонецЕсли; 
	
	
	ЗаполнитьТаблицыСпецифик(Товар,Автопозиция,СтрокаТовара.Строки.Количество()=0);
	Если не Автопозиция тогда
		ЗаполнитьТаблицуГруппИСпецификДаннымиИзЗаказа(СтрокаТовара);
	КонецЕсли;
	
	// Запоним результат значениями ДО выбора в форме.
	// Если в форме будет отказ от выбора, то возвратим эти значения.
	тзНастройки = ТаблицаНастроекСпецифик();
	ТаблицаОшибок = КонтрольОграничений(тзНастройки);
	
	Результат.Контроль = (ТаблицаОшибок.Количество() = 0);
	Результат.Специфики = ДеревоВыбранныхСпецифик();
	
	Если ТолькоПроверка Тогда
		// форму не открываем - только проверяем выполнение условий
		Возврат Результат;
	КонецЕсли; 
	
	// открываем форму для выбора специфик
	//Z+	
	ВыводСпецификНаИнфоДисплей();
	//Z-	
	ФормаВыбора = ПолучитьФорму("Форма0"); //  + глПараметрыРМ.ИнтерфейсТип
	ФормаВыбора.ОткрытьМодально();
	
	
	Если ФормаВыбора.ВыборСделан Тогда
		// Выбор сделан - обновляем дерево специфик.
		Результат.Контроль = Истина; // контроль специфик прошёл в форме
		Результат.ВыборСделан = Истина;
		Результат.Специфики = ДеревоВыбранныхСпецифик();
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции

//Z+
Процедура ВыводСпецификНаИнфоДисплей(СброситьНастройки = Ложь) Экспорт
	
	// Отобразить изменения на ИнфоДисплее
	
	Если НЕ глПараметрыРМ.ИнфоДисплейЕсть Тогда
		Возврат;
	КонецЕсли; 
	
	ДопПараметрыИнфо	= Новый Структура("Товар, НомерСтрокиЗаказа, СуммаПоСтанцииНач, СброситьНастройки");
	
	ДопПараметрыИнфо.НомерСтрокиЗаказа = Специфики.Количество();
	ДопПараметрыИнфо.СброситьНастройки = СброситьНастройки;
	ДопПараметрыИнфо.Товар = Товар;	
	//ДопПараметрыИнфо.СуммаПоСтанцииНач = СуммаТовар;
	ИнтерфейсРМ.ВыводНаИнфоДисплей("ПоказатьСпецифику", , Специфики.Выгрузить(), , ДопПараметрыИнфо);
	
КонецПроцедуры // КС_ВДВ > ------------------------------------------------------------ 
//Z-	
////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ИнициализацияРеквизитов();
#КонецЕсли