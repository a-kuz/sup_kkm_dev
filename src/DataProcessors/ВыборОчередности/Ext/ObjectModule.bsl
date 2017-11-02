﻿#Если Клиент Тогда
Перем СтатусДозаказ;
Перем СтатусЗаказано;
Перем СтатусОтложено;

// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
	ТипКурс   = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(2,  0, ДопустимыйЗнак.Неотрицательный));
	ТипЦелое  = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
	ТипСтрока = ПолучитьОписаниеТиповСтроки();
	ТипСтрок1 = ПолучитьОписаниеТиповСтроки(1);
	
	ТаблицаТовары = Новый ТаблицаЗначений;
	Колонки = ТаблицаТовары.Колонки;
	Колонки.Добавить("НомерПП"		,ТипЦелое, "№ п/п");
	Колонки.Добавить("Товар");
	Колонки.Добавить("Наименование"	,ТипСтрока, "Наименование",	303 );
	Колонки.Добавить("Курс"			,ТипКурс, 	"Очередность",	80 );
	Колонки.Добавить("Время"		,ТипЦелое, 	"Время, мин",	80 );
	Колонки.Добавить("Плюс"			,ТипСтрок1, "Плюс", 		80 );
	Колонки.Добавить("Минус"		,ТипСтрок1, "Минус",		80 );
	Колонки.Добавить("СтрокаТаблицыЗаказа");
	
КонецПроцедуры

// Вызывается один раз при создании объекта обработки.
// Объект затем сохраняется в структуре глОбработки для хранения объектов используемых обработок.
Процедура ИнициализацияРеквизитов()
	
	// эти реквизиты никогда не изменяют своё значение
	СтатусДозаказ	= Перечисления.СтатусыПозицийЗаказа.Дозаказ;
	СтатусЗаказано	= Перечисления.СтатусыПозицийЗаказа.Заказано;
	СтатусОтложено	= Перечисления.СтатусыПозицийЗаказа.Отложено;
	
	УстановкаНачальныхЗначений();
	
КонецПроцедуры
        
// Возвращает наименование товара со всеми спецификами
Функция ПолноеНаименованиеСоСпецификами(СтрокаЗаказа)

	Наименование = СокрЛП(СтрокаЗаказа.Товар.Наименование);
	
	НаименованияСпецифик = ПолучитьНаименованияСпецифик(СтрокаЗаказа);

	Возврат Наименование + ?(ПустаяСтрока(НаименованияСпецифик), "", " ("+НаименованияСпецифик+")");
	
КонецФункции 

// Возвращает строку из наименований специфик самого нижнего уровня, т.е. конкретных значений (без групп).
Функция ПолучитьНаименованияСпецифик(СтрокаСпецифик)

	Наименование = "";
	
	Для каждого СтрокаСпецифики Из СтрокаСпецифик.Строки Цикл
	
		Если СтрокаСпецифики.Строки.Количество() = 0 Тогда
			Наим = СокрЛП(СтрокаСпецифики.Товар.Наименование);
		Иначе	
			Наим = ПолучитьНаименованияСпецифик(СтрокаСпецифики);
		КонецЕсли; 
		
		Наименование = Наименование + ?(ПустаяСтрока(Наименование), "", ", ") + Наим;
	
	КонецЦикла; 

	Возврат Наименование;
	
КонецФункции 

Процедура ПолучитьВремяПриготовленияСпецифик(СтрокаСпецифик,ВремяПриготовления)
	Для каждого СтрокаСпецифики Из СтрокаСпецифик.Строки Цикл
	
		Если СтрокаСпецифики.Строки.Количество() = 0 Тогда
			ВремяПриготовления = Макс(ВремяПриготовления,СтрокаСпецифики.Товар.ВремяПриготовления);
		Иначе	
			ПолучитьВремяПриготовленияСпецифик(СтрокаСпецифики,ВремяПриготовления);
		КонецЕсли; 
		
	КонецЦикла; 
КонецПроцедуры

Функция ПолучитьПустуюТаблицуЗаказа(ТаблицаЗаказа) Экспорт
	Копия = ТаблицаЗаказа.Скопировать();
	Копия.Строки.Очистить();
	Возврат Копия;
КонецФункции

Функция ВыполнитьВыборОчередности(ФормаЗаказа, ЗаказСсылка, Знач ТаблицаЗаказа, Знач Станция, ВыданныйПейджер, Знач ТекущийКурс, Знач СтанцияСуммаНач) Экспорт
	Результат = Новый Структура("ВыборСделан, БыстраяВыдача, ТаблицаТовары, Пейджер", Истина, Истина, Новый ТаблицаЗначений, Неопределено);
	МассивТоваров = СвернутьМассив(ТаблицаЗаказа.Строки.ВыгрузитьКолонку("Товар"));
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Товары.Владелец КАК КаталогТоваров,
	|	Товары.Ссылка КАК Товар
	|ПОМЕСТИТЬ КаталогиТоваров
	|ИЗ
	|	Справочник.Товары КАК Товары
	|ГДЕ
	|	Товары.Ссылка В(&МассивТоваров)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПривязкаТоваровКстанциям.Станция КАК Станция,
	|	КаталогиТоваров.Товар КАК Товар
	|ИЗ
	|	РегистрСведений.ПривязкаТоваровКстанциям КАК ПривязкаТоваровКстанциям
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ КаталогиТоваров КАК КаталогиТоваров
	|		ПО ПривязкаТоваровКстанциям.КаталогТоваров = КаталогиТоваров.КаталогТоваров
	|ГДЕ
	|	ПривязкаТоваровКстанциям.ИнформационнаяБаза = &ИнформационнаяБаза");
	Запрос.УстановитьПараметр("МассивТоваров", МассивТоваров);
	Запрос.УстановитьПараметр("ИнформационнаяБаза", ПараметрыСеанса.ТекущаяИБ);
	
	ТоварыПоСтанции = Запрос.Выполнить().Выгрузить();
	//:ТаблицаЗаказа = новый ДеревоЗначений
	ГруппыОчередности = ТоварыПоСтанции.Скопировать(,"Станция");
	ГруппыОчередности.Свернуть("Станция");
	ГруппыОчередности.Колонки.Добавить("ТаблицаЗаказа");	
	
	Если ГруппыОчередности.Найти(Станция, "Станция") = Неопределено Тогда
		СтрокаСтанция = ГруппыОчередности.Добавить();
		СтрокаСтанция.Станция = Станция;
	КонецЕсли;
	ПустаяТаблицаЗаказа = ПолучитьПустуюТаблицуЗаказа(ТаблицаЗаказа);
	МассивУдаляемыхСтрок = Новый Массив;
	Для Каждого Т Из ТаблицаЗаказа.Строки Цикл
		СтрокаТовара = ТоварыПоСтанции.Найти(Т.Товар, "Товар");
		Если СтрокаТовара = Неопределено Тогда
			СтрокаТовара = Новый Структура("Станция", Станция);
		КонецЕсли;
		
		Если СтрокаТовара.Станция = Станция Тогда
			Продолжить;
		КонецЕсли;
		
		ГруппаОчередности = ГруппыОчередности.Найти(СтрокаТовара.Станция, "Станция");
		Если ГруппаОчередности.ТаблицаЗаказа = Неопределено Тогда
			ГруппаОчередности.ТаблицаЗаказа = ПустаяТаблицаЗаказа.Скопировать();
		КонецЕсли;
		
		МассивУдаляемыхСтрок.Добавить(Т);
		НовСтрока = ГруппаОчередности.ТаблицаЗаказа.Строки.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрока, Т);
		Для Каждого СтрокаСпецифика Из Т.Строки Цикл
			НовСтрокаСпецифика = НовСтрока.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрокаСпецифика, СтрокаСпецифика);
		КонецЦикла;
	КонецЦикла;
	ТаблицаЗаказаСудаленнымиСтроками =  ПустаяТаблицаЗаказа.Скопировать();
	Для Каждого Т Из ТаблицаЗаказа.Строки Цикл
		Если МассивУдаляемыхСтрок.Найти(Т) = Неопределено Тогда
			НовСтрока = ТаблицаЗаказаСудаленнымиСтроками.Строки.Добавить();
			ЗаполнитьЗначенияСвойств(НовСтрока, Т);
			Для Каждого СтрокаСпецифика Из Т.Строки Цикл
				НовСтрокаСпецифика = НовСтрока.Строки.Добавить();
				ЗаполнитьЗначенияСвойств(НовСтрокаСпецифика, СтрокаСпецифика);
			КонецЦикла;
			
		КонецЕсли;
	КонецЦикла;
	Для Каждого Т Из МассивУдаляемыхСтрок Цикл
	//	ТаблицаЗаказа.Строки.Удалить(Т);
	КонецЦикла;
	ГруппыОчередности.найти(Станция, "Станция").ТаблицаЗаказа = ТаблицаЗаказаСудаленнымиСтроками;
	
	РезультатТаблицаТовары = Новый ТаблицаЗначений;
	Для Каждого ГруппаОчередности Из ГруппыОчередности Цикл
		РезультатПоСтанции = ВыполнитьВыборОчередностиПоСтанции(ФормаЗаказа, ЗаказСсылка, ГруппаОчередности.ТаблицаЗаказа, ГруппаОчередности. Станция, ВыданныйПейджер, ТекущийКурс, СтанцияСуммаНач);			
		Если Не РезультатТаблицаТовары.Колонки.Количество() Тогда
			РезультатТаблицаТовары = РезультатПоСтанции.ТаблицаТовары.Скопировать();
		Иначе
			ДополнитьТаблицу(РезультатТаблицаТовары, РезультатПоСтанции.ТаблицаТовары);	
		КонецЕсли;
	КонецЦикла;	
	РезультатПоСтанции.ТаблицаТовары = РезультатТаблицаТовары;
	Возврат РезультатПоСтанции;
КонецФункции

Функция ВыполнитьВыборОчередностиПоСтанции(ФормаЗаказа, ЗаказСсылка, ТаблицаЗаказа, Знач Станция, ВыданныйПейджер, Знач ТекущийКурс, Знач СтанцияСуммаНач) Экспорт

	Результат = Новый Структура("ВыборСделан, БыстраяВыдача, ТаблицаТовары, Пейджер", Истина, Истина, Новый ТаблицаЗначений, Неопределено);
	       
	ТаблицаТовары.Очистить();
	
	НомерПП					= 0;
	НачальныйКурс 			= ТекущийКурс;
	НормативныйПериодСек	= Константы.НормативныйПериодПриготовленияСек.Получить();
	ТолькоБыстрыеТовары		= Истина; // время приготовления каждого товара <= НормативныйПериодСек
	ТолькоМедленныеТовары	= Истина; // время приготовления каждого товара > НормативныйПериодСек
	
	
	Для Каждого СтрокаЗаказа Из ТаблицаЗаказа.Строки Цикл
		
		Если НЕ(
			(СтрокаЗаказа.Количество <> 0) И 
			(СтрокаЗаказа.Станция = Станция ИЛИ СтрокаЗаказа.РабочееМесто = глРабочееМесто) И
			(СтрокаЗаказа.Статус = СтатусДозаказ ИЛИ СтрокаЗаказа.Статус = СтатусОтложено)
			) Тогда
			Продолжить;
		КонецЕсли;		
		
		НомерПП = НомерПП + 1;
		
		НоваяСтрока = ТаблицаТовары.Добавить();
		НоваяСтрока.НомерПП		 = НомерПП;
		НоваяСтрока.Товар		 = СтрокаЗаказа.Товар;
		НоваяСтрока.Наименование = ПолноеНаименованиеСоСпецификами(СтрокаЗаказа);
		НоваяСтрока.Время		 = СтрокаЗаказа.Товар.ВремяПриготовления;
		Если НоваяСтрока.Время = 0 тогда
			ПолучитьВремяПриготовленияСпецифик(СтрокаЗаказа,НоваяСтрока.Время);
		КонецЕсли;
		
		НоваяСтрока.Плюс		 = "+";
		НоваяСтрока.Минус		 = "–";
		
		Если НоваяСтрока.Время*60 <= НормативныйПериодСек Тогда
			НоваяСтрока.Курс	 = НачальныйКурс;
			ТолькоМедленныеТовары = Ложь;
		Иначе	
			НоваяСтрока.Курс	 = НачальныйКурс + 1;
			ТолькоБыстрыеТовары = Ложь;
		КонецЕсли; 
		
		НоваяСтрока.СтрокаТаблицыЗаказа = СтрокаЗаказа;
		
	КонецЦикла; 
	
	Если ТаблицаТовары.Количество() = 0 Тогда
		Результат.ВыборСделан = 1;
		Возврат Результат; // нет новых товаров
	КонецЕсли; 
	
	//Если ТолькоМедленныеТовары Тогда       //ПКА 20170725 по умолчанию ставим всем одинаковый курс выдачи
		// Поправим курс выдачи, т.к. он был присовен как НачальныйКурс+1.
		// НО поскольку "быстрых" товаров нет, то должно быть = НачальныйКурс
		ТаблицаТовары.ЗаполнитьЗначения(НачальныйКурс, "Курс");
	//КонецЕсли;	
	
	Если ТолькоБыстрыеТовары Тогда
		// Все новые товары с минимальным временем приготовления.
		// Их курсы выдачи равны текущему курсы, и уже проставлены в строках таблицы ТаблицаТовары.
		// Форму выбора можно не открывать.
		
		Результат.БыстраяВыдача = Истина;
		Результат.ТаблицаТовары	= ТаблицаТовары.Скопировать();
		Результат.ВыборСделан = Истина;
		Возврат Результат;
	КонецЕсли; 
	
	ТаблицаТовары.Сортировать("Курс,Время,НомерПП");
	
	Товары.Загрузить(ТаблицаТовары);
	
	
	// --- Пейджеры
	// Поскольку есть товары с длительным временем приготовления,
	// то нужно выдать пейджер, если это не было сделано ранее.
	Пейджер 		= ВыданныйПейджер;
	ВыдатьПейджер	= НЕ ЗначениеЗаполнено(ВыданныйПейджер);
	
	
	// --- Эта часть кода нужна только из-за монитора гостя
	Заказ 				= ЗаказСсылка;
	СуммаПоСтанцииНач	= СтанцияСуммаНач;
	
	// Эту таблицу будем сортировать. Она выводится на монитор гостя.
	// Для других целей она не используется.
	ТаблицаЗаказаКурс = ТаблицаЗаказа.Скопировать();
	ТипЦелое = Новый ОписаниеТипов("Число", Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный));
	ТаблицаЗаказаКурс.Колонки.Добавить("НомерПП", ТипЦелое);
	ТаблицаЗаказаКурс.Колонки.Добавить("Очередность", ТипЦелое); // Будет выводиться в мониторе гостя
	ТаблицаЗаказаКурс.Колонки.Добавить("Сортировка1", ТипЦелое); // Для старых строк = номер подачи; Для новых = Большое число, чтобы они всегда были снизу.
	ТаблицаЗаказаКурс.Колонки.Добавить("Сортировка2", ТипЦелое); // Для старых строк = индекс строки заказа; Для новых строк = номер строки в форме выбора очередности.
	
	НомерПП	= 0;
	ТаблицаЗаказаКурсСтроки = ТаблицаЗаказаКурс.Строки;
	
	Для Каждого СтрокаЗаказа Из ТаблицаЗаказаКурсСтроки Цикл
		Попытка
			СтрокаЗаказа.Очередность = СтрокаЗаказа.Подача.Номер; // важно только для старых строк; для новых будет заполнение при выводе на монитор гостя		
		Исключение
			СтрокаЗаказа.Очередность = СтрокаЗаказа.Подача; // важно только для старых строк; для новых будет заполнение при выводе на монитор гостя		
		КонецПопытки;

		
		Если НЕ(
			(СтрокаЗаказа.Количество <> 0) И 
			(СтрокаЗаказа.Станция = Станция) И
			(СтрокаЗаказа.Статус = СтатусДозаказ ИЛИ СтрокаЗаказа.Статус = СтатусОтложено)
			) Тогда
			
			Попытка
				СтрокаЗаказа.Сортировка1 = СтрокаЗаказа.Подача.Номер; // важно только для старых строк; для новых будет заполнение при выводе на монитор гостя		
			Исключение
				СтрокаЗаказа.Сортировка1 = СтрокаЗаказа.Подача; // важно только для старых строк; для новых будет заполнение при выводе на монитор гостя		
			КонецПопытки;
			
			СтрокаЗаказа.Сортировка2 = ТаблицаЗаказаКурсСтроки.Индекс(СтрокаЗаказа);
			Продолжить;
		КонецЕсли;		
		
		НомерПП = НомерПП + 1;
		
		СтрокаЗаказа.НомерПП = НомерПП;
		СтрокаЗаказа.Сортировка1 = 10000;
	КонецЦикла; 		
	
	
	// --- Открываем форму для выбора очередности
	ФормаВыбора = ПолучитьФорму("Форма" + глПараметрыРМ.ИнтерфейсТип);
	ФормаВыбора.ВладелецФормы = ФормаЗаказа;
	ФормаВыбора.Заголовок = Станция;
	ФормаВыбора.АвтоЗаголовок = Ложь;
	Результат.ВыборСделан = ФормаВыбора.ОткрытьМодально();
	
	Результат.ВыборСделан   = ФормаВыбора.ВыборСделан;
	Результат.БыстраяВыдача = Ложь;
	
	Если ФормаВыбора.ВыборСделан Тогда
		Для каждого Строка Из Товары Цикл
			СтрокаТов = ТаблицаТовары.Найти(Строка.НомерПП, "НомерПП");
			
			Если СтрокаТов <> Неопределено Тогда
				СтрокаТов.Курс = Строка.Курс;
			КонецЕсли; 
		КонецЦикла; 
		
		Результат.ТаблицаТовары	= ТаблицаТовары.Скопировать( ,"СтрокаТаблицыЗаказа, Курс");	
		
		Если ВыдатьПейджер Тогда
			Результат.Пейджер = Пейджер;
		КонецЕсли; 
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции 

////////////////////////////////////////////////////////////////////////////
ИнициализацияРеквизитов();
#КонецЕсли