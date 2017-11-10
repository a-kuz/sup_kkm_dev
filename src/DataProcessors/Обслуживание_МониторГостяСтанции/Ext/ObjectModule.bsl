﻿
Перем ПараметрыТО Экспорт;				// Параметры торгового оборудования.
Перем Результат Экспорт;				// Результат выполнения действия.
Перем DRV Экспорт;						// Соединение
Перем ТекущаяФормаhWnd Экспорт;
Перем СписокКартинок Экспорт;
Перем НомерТекущейКартинки Экспорт;
Перем РазрешитьСменуКартинок Экспорт;
Перем ЛояльностьДанныеЗаказа Экспорт;
Перем ФирмаФильтр Экспорт;
Перем ГруппаСпецифик Экспорт; //КартинкиСпецифик
Перем ДеревоСтрокаЗаказа Экспорт; //КартинкиСпецифик

#Если Клиент Тогда

// Производит инициализацию торгового оборудования.
//
Процедура Инициализация() Экспорт
	
	ПрочитатьПараметр("РазмерОкнаИнфоДисплея", "Во весь экран" );
	Если НЕ глТорговоеОборудование.Свойство("InfoDisplay",DRV) Тогда
		Если РазмерОкнаИнфоДисплея = 0 Тогда
			ИмяФормы = "ИнфоДисплейКМ";
			Если ЗначениеЗаполнено(глРабочееМесто) И глПараметрыРМ.ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.МОКП") Тогда
				ИмяФормы = "ИнфоДисплей_МОКП";
			КонецЕсли;
			//Попытка
			//	Если глПараметрыРМ.Тест Тогда
			//		ИмяФормы = "ИнфоДисплей_МОКП";
			//	КонецЕсли;
			//Исключение
			//    //ОписаниеОшибки()
			//КонецПопытки; 
			DRV = ЭтотОбъект.ПолучитьФорму(ИмяФормы);
		Иначе
			DRV = ЭтотОбъект.ПолучитьФорму("ИнфоДисплей");
		КонецЕсли;
		глТорговоеОборудование.Вставить("InfoDisplay", DRV);
	КонецЕсли;	
	
	
	
	ПрочитатьПараметр("Изображение", "" );
	ПрочитатьПараметр("ИзображениеПриглашение", "" );
	ПрочитатьПараметр("ИзображениеЗапись", "" );
	ПрочитатьПараметр("ИзображениеОплата", "" );
	ПрочитатьПараметр("ИзображениеАвторизация", "" );
	ПрочитатьПараметр("ИзображениеДляМонитораГостя", "" );
	
	////читаем список рекламных картинок
	//перенес в отдельную процедуру, чтобы можно было вызывать извне
	ПеречитатьСписокКартинок();
	
КонецПроцедуры

// Выполняет чтение параметра ТО.
//
// Параметры:
//  ИмяПараметра        - имя параметра,
//  ЗначениеПоУмолчанию - значение по умолчанию для данного параметра.
//
// Возвращаемое значение:
//  Значение параметра или значение по умолчанию
//
Процедура ПрочитатьПараметр(ИмяПараметра,ЗначениеПоУмолчанию)
	
	Если НЕ ПараметрыТО.Свойство(ИмяПараметра) Тогда
		ПараметрыТО.Вставить(ИмяПараметра,ЗначениеПоУмолчанию);
	КонецЕсли; 
	
	ЭтотОбъект[ИмяПараметра] = ПараметрыТО[ИмяПараметра];
	
КонецПроцедуры

// Выполняет действие с ТО.
//
// Параметры:
//  Действие - имя действия,
//  ПараметрыДействия - произвольный набор параметров
//
Процедура ВыполнитьДействие(Действие, ПараметрыДействия=Неопределено) Экспорт
	
	Если Действие = "Подключить" Тогда
		Подключить();
		
	ИначеЕсли Действие = "Отключить" Тогда
		Отключить();
		
	ИначеЕсли Действие = "ПоказатьЗаказ" Тогда
		Заказ				= ПараметрыДействия.Заказ;
		ТаблицаЗаказа		= ПараметрыДействия.ТаблицаЗаказа;
		СписокРекомендаций	= ПараметрыДействия.СписокРекомендаций;
		ТаблицаСпецифик		= Заказ.Специфики.Выгрузить();
		// < КС_ВДВ ------------------------------------------------------------ 
		ДопПараметрыИнфо	= ПараметрыДействия.ДопПараметрыИнфо;
		
		РежимВывода			= ?(ДопПараметрыИнфо.Свойство("РежимВывода"), ДопПараметрыИнфо.РежимВывода, "Заказ");
		СброситьНастройки	= ?(ДопПараметрыИнфо.Свойство("СброситьНастройки"), ДопПараметрыИнфо.СброситьНастройки, Ложь);
		НомерСтрокиЗаказа	= ?(ДопПараметрыИнфо.Свойство("НомерСтрокиЗаказа"), ДопПараметрыИнфо.НомерСтрокиЗаказа, 0);
		
		Если ДопПараметрыИнфо.Свойство("ЛояльностьДанныеЗаказа", ЛояльностьДанныеЗаказа) Тогда
			ДопПараметрыИнфо.Свойство("ФирмаФильтр", ФирмаФильтр);
			ТабДокЛояльность = ИнтерфейсРМЛояльность.ПолучитьТабДокЛояльность_МониторГостя(Заказ, "", ЛояльностьДанныеЗаказа, ФирмаФильтр);
		КонецЕсли;
		
		Если РежимВывода = "Марки" Тогда
		    СуммаПоСтанцииНач 			= 0;
			СписокКодовПодтверждений	= ?(ДопПараметрыИнфо.Свойство("СписокКодовПодтверждений"), ДопПараметрыИнфо.СписокКодовПодтверждений, Неопределено);
		Иначе
			СуммаПоСтанцииНач			= ?(ДопПараметрыИнфо.Свойство("СуммаПоСтанцииНач"), ДопПараметрыИнфо.СуммаПоСтанцииНач, 0);
			СписокКодовПодтверждений	= Неопределено;
		КонецЕсли; 
		// КС_ВДВ > ------------------------------------------------------------ 
		DRV.АктивироватьСтраницуЗаказа();
		
//Z+		
	ИначеЕсли Действие = "ПоказатьСпецифику" Тогда
		//Заказ				= ПараметрыДействия.Заказ;
		ТаблицаСпецифик		= ПараметрыДействия.ТаблицаЗаказа;
		ДопПараметрыИнфо	= ПараметрыДействия.ДопПараметрыИнфо;
		РежимВывода			= ?(ДопПараметрыИнфо.Свойство("РежимВывода"), ДопПараметрыИнфо.РежимВывода, "Специфика");
		СброситьНастройки	= ?(ДопПараметрыИнфо.Свойство("СброситьНастройки"), ДопПараметрыИнфо.СброситьНастройки, Ложь);
		НомерСтрокиЗаказа	= ?(ДопПараметрыИнфо.Свойство("НомерСтрокиЗаказа"), ДопПараметрыИнфо.НомерСтрокиЗаказа, 0);
		СуммаПоСтанцииНач 	= ?(ДопПараметрыИнфо.Свойство("СуммаПоСтанцииНач"), ДопПараметрыИнфо.СуммаПоСтанцииНач, 0);    		
		Товар				= ?(ДопПараметрыИнфо.Свойство("Товар"), ДопПараметрыИнфо.Товар, "");
		СписокКодовПодтверждений	= Неопределено;
		#Область КартинкиСпецифик
		ДопПараметрыИнфо.Свойство("СтрокаЗаказа", ДеревоСтрокаЗаказа);
		Если ДопПараметрыИнфо.Свойство("ГруппаСпецифик") Тогда
			ГруппаСпецифик = ДопПараметрыИнфо.ГруппаСпецифик;
		КонецЕсли;
		#КонецОбласти
	
		DRV.АктивироватьСтраницуЗаказа();
//Z-		
	ИначеЕсли Действие = "УбратьЗаказ" Тогда
		Заказ			= Неопределено;
		ТаблицаЗаказа	= Неопределено;
		// < КС_ВДВ ------------------------------------------------------------ 
		СброситьНастройки = Истина;
		// КС_ВДВ > ------------------------------------------------------------ 
		ПеречитатьСписокКартинок();
		DRV.АктивироватьСтраницуЗаказа(Ложь);
		
	ИначеЕсли Действие = "Реклама" Тогда
		Если НЕ Изображение.Пустая() Тогда
			Если НомерТекущейКартинки >=0 и НомерТекущейКартинки < СписокКартинок.Количество() тогда
				DRV.ЭлементыФормы.ПолеКартинки.Картинка		= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
				//DRV.ЭлементыФормы.тНаименование.Картинка	= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
				РазрешитьСменуКартинок = 1;
			КонецЕсли;
			
		КонецЕсли;
	ИначеЕсли Действие = "Приглашение" Тогда
		Если НЕ ИзображениеПриглашение.Пустая() Тогда
			РазрешитьСменуКартинок = 0;
			DRV.ЭлементыФормы.ПолеКартинки.Картинка		= ИзображениеПриглашение.Хранилище.Получить();
			//DRV.ЭлементыФормы.тНаименование.Картинка	= ИзображениеПриглашение.Хранилище.Получить();
		КонецЕсли;
	ИначеЕсли Действие = "Авторизация" Тогда
		Если НЕ ИзображениеАвторизация.Пустая() Тогда
			РазрешитьСменуКартинок = 0;
			DRV.ЭлементыФормы.ПолеКартинки.Картинка		= ИзображениеАвторизация.Хранилище.Получить();
			//DRV.ЭлементыФормы.тНаименование.Картинка	= ИзображениеПриглашение.Хранилище.Получить();
		КонецЕсли;
	ИначеЕсли Действие = "ЗаказЗаписан" Тогда
		Если НЕ ИзображениеЗапись.Пустая() Тогда
			DRV.ЭлементыФормы.ПолеКартинки.Картинка		= ИзображениеЗапись.Хранилище.Получить();
			//DRV.ЭлементыФормы.тНаименование.Картинка	= ИзображениеЗапись.Хранилище.Получить();
			РазрешитьСменуКартинок = 2;
		КонецЕсли;
	ИначеЕсли Действие = "ПоказатьВес" Тогда
		DRV.тВес = ПараметрыДействия.Вес;
		DRV.тЗаголовокВесКг = "КГ";
		DRV.тЗаголовокВес = "ВЕС:";
	ИначеЕсли Действие = "ЗаказОплачен" Тогда
		Если НЕ ИзображениеОплата.Пустая() Тогда
			DRV.ЭлементыФормы.ПолеКартинки.Картинка		= ИзображениеОплата.Хранилище.Получить();
			//DRV.ЭлементыФормы.тНаименование.Картинка	= ИзображениеОплата.Хранилище.Получить();
			РазрешитьСменуКартинок = 2;
			DRV.АктивироватьСтраницуЗаказа(Ложь);
		КонецЕсли;
//ТОВАРГЕТИНФО	
	ИначеЕсли Действие = "ПоказатьТоварИнфо" Тогда
		ЭлементТоварГетИнфо = DRV.ЭлементыФормы.Найти("ТоварГетИнфо");
		Если НЕ ЭлементТоварГетИнфо = Неопределено Тогда
			ДопПараметрыИнфо	= ПараметрыДействия.ДопПараметрыИнфо;
			Товар				= ?(ДопПараметрыИнфо.Свойство("Товар"), ДопПараметрыИнфо.Товар, "");
			Цена				= ?(ДопПараметрыИнфо.Свойство("Цена"), ДопПараметрыИнфо.Цена, 0);
			КГЛ					= ?(ДопПараметрыИнфо.Свойство("КГЛ"), ДопПараметрыИнфо.КГЛ, 0);
			Если ЗначениеЗаполнено(Товар) И ТипЗнч(Товар) = Тип("СправочникСсылка.Товары") Тогда
				УРЛ = ИнтерфейсРМЛояльность.СформироватьУрлТовараДляМонитораГостя(Товар, Цена, КГЛ);
				ЭлементТоварГетИнфо.Документ.URL = УРЛ;
				ЭлементТоварГетИнфо.Видимость = Истина;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Действие = "СкрытьТоварИнфо" Тогда
		ЭлементТоварГетИнфо = DRV.ЭлементыФормы.Найти("ТоварГетИнфо");
		Если НЕ ЭлементТоварГетИнфо = Неопределено Тогда
		    ЭлементТоварГетИнфо.Видимость = Ложь;
			ЭлементТоварГетИнфо.Документ.URL = "about:blank";
		КонецЕсли;
//~ТОВАРГЕТИНФО	
//ЛУЧ
	ИначеЕсли Действие = "ПоказатьЛУЧ" Тогда
		ЭлементТабДокЛуч = DRV.ЭлементыФормы.Найти("ТабДокЛуч");
		Если НЕ ЭлементТабДокЛуч = Неопределено Тогда
			ЭлементТабДокЛуч.Очистить();
			Если ПараметрыДействия.ДопПараметрыИнфо.Свойство("ТабДокЛуч") Тогда
				ЭлементТабДокЛуч.Вывести(ПараметрыДействия.ДопПараметрыИнфо.ТабДокЛуч);
				ЭлементТабДокЛуч.Видимость = ЭлементТабДокЛуч.ВысотаТаблицы > 0;
			КонецЕсли;
		КонецЕсли;
	ИначеЕсли Действие = "УбратьЛУЧ" Тогда
		ЭлементТабДокЛуч = DRV.ЭлементыФормы.Найти("ТабДокЛуч");
		Если НЕ ЭлементТабДокЛуч = Неопределено Тогда
		    ЭлементТабДокЛуч.Видимость = Ложь;
		КонецЕсли;
//~ЛУЧ
	Иначе
		Результат.Ошибка	= Истина;
		Результат.Описание	= "Неизвестная команда!";
		Результат.Подробно	= "Команда """+Действие+""" не определена для "+ТО.Наименование;
		
	КонецЕсли;
	
КонецПроцедуры

// Обработка ошибок
//
Функция Ошибка()
	
	Возврат Ложь;
	
КонецФункции

// Установка параметров подключения
//
Функция Подключить() Экспорт
	
	Попытка	
		ОткрытьОкноДисплея();	
	Исключение
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
КонецФункции

// Отключение устройства
//
Процедура Отключить() Экспорт
	
	ЗакрытьОкноДисплея();
	
КонецПроцедуры

// Открыть форму Инфо дисплея
//
Процедура ОткрытьОкноДисплея()
		
	DRV.Открыть();
		
КонецПроцедуры

// Закрыть форму Инфо дисплея
//
Процедура ЗакрытьОкноДисплея()
	
	DRV.Закрыть();
	
КонецПроцедуры

Процедура ПеречитатьСписокКартинок() Экспорт
	
	////читаем список рекламных картинок
	СписокКартинок = Новый Массив(1);
	
	ТекДата = ТекущаяДатаНаСервере();
	
	НомерТекущейКартинки = 0;
	Если Изображение.ЭтоГруппа тогда
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("Родитель", Изображение);
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ХранилищеДополнительнойИнформации.Ссылка КАК Ссылка,
		|	ХранилищеДополнительнойИнформации.ДействуетС КАК ДействуетС,
		|	ХранилищеДополнительнойИнформации.ДействуетПо КАК ДействуетПо
		|ИЗ
		|	Справочник.ХранилищеДополнительнойИнформации КАК ХранилищеДополнительнойИнформации
		|ГДЕ
		|	НЕ ХранилищеДополнительнойИнформации.ПометкаУдаления
		|	И ХранилищеДополнительнойИнформации.Родитель = &Родитель
		|
		|УПОРЯДОЧИТЬ ПО
		|	ХранилищеДополнительнойИнформации.Код";
		Выборка = Запрос.Выполнить().Выбрать();
		
//		Выборка = Справочники.ХранилищеДополнительнойИнформации.Выбрать(Изображение, , , "Код Возр");
		Пока Выборка.Следующий() цикл
//			Если Выборка.ПометкаУдаления = 1 тогда продолжить;КонецЕсли;
			Если НЕ ДатаСоответствуетПериодуДействия(ТекДата, Выборка.ДействуетС, Выборка.ДействуетПо) Тогда
			//Если Выборка.ДействуетС > ТекДата ИЛИ Выборка.ДействуетПо < ТекДата И НЕ Выборка.ДействуетПо = '00010101' Тогда
				Продолжить;
			КонецЕсли;
			Если НомерТекущейКартинки = 0 тогда
				СписокКартинок[НомерТекущейКартинки] = Выборка.Ссылка;
				НомерТекущейКартинки = НомерТекущейКартинки + 1;
			Иначе
				СписокКартинок.добавить(Выборка.Ссылка);
			КонецЕсли;
		КонецЦикла;
		НомерТекущейКартинки = 0;
	иначе
		СписокКартинок[НомерТекущейКартинки] = Изображение;
	КонецЕсли;
		
КонецПроцедуры

Функция ДатаСоответствуетПериодуДействия(ТекДата, ДействуетС, ДействуетПо)
	
	Если ДействуетС = '00010101' И ДействуетПо = '00010101' Тогда
		Возврат Истина;
	КонецЕсли;
	
	Дата = НачалоДня(ТекДата);
	Если Дата < ДействуетС Тогда
		Возврат Ложь;
	КонецЕсли;
	Если Дата > ДействуетПо И НЕ НачалоДня(ДействуетПо) = '00010101' Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Время = УстановитьВремяВДате('00010101', ТекДата);
	ВремяС = УстановитьВремяВДате('00010101', ДействуетС);
	ВремяПО = УстановитьВремяВДате('00010101', ДействуетПо);
	Если Время < ВремяС Тогда
		Возврат Ложь;
	КонецЕсли;
	Если Время > ВремяПО И НЕ ВремяПО = '00010101' Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции


// перенесено их форм
Процедура ПоказатьСледующуюКартинку() Экспорт 
	
	Если РазрешитьСменуКартинок = 0 тогда возврат; КонецЕсли;
	Если РазрешитьСменуКартинок = 2 тогда //пропускаем одну смену 
		РазрешитьСменуКартинок = 1;
		возврат; 
	КонецЕсли;
	НомерТекущейКартинки = НомерТекущейКартинки + 1;
	Если НомерТекущейКартинки >= СписокКартинок.Количество() тогда
		НомерТекущейКартинки = 0;
	КонецЕсли;
	
	DRV.ЭлементыФормы.ПолеКартинки.Картинка		= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
	Попытка // в КМ нету
		DRV.ЭлементыФормы.тНаименование.Картинка	= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
	Исключение
	КонецПопытки;
	
КонецПроцедуры

#КонецЕсли

Результат = Новый Структура("Ошибка,Описание,Подробно",Ложь,"","");