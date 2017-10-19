﻿Перем Коплате;
Перем A,Макет;
Перем МакетПодвал;
//*******************************************************************************
//* ПанельКонтент: страница ВыдачаЗаказ должна быть первой (перед ПриемЗаказа)! *
//* Иначе почему-то появляются полосы прокрутки в режиме выдачи.                *
//*******************************************************************************


Перем ТекНомерСтрокиЗаказа; // номер текущей строки заказа
Перем ТекНомерСтрокиТабДок; // номер строки таб.документа, которая сделана текущей 

Процедура ПоказатьСледующуюКартинку_Ожидание()
	ПоказатьСледующуюКартинку();
	//////Если РазрешитьСменуКартинок = 0 тогда возврат; КонецЕсли;
	//////Если РазрешитьСменуКартинок = 2 тогда //пропускаем одну смену 
	//////	РазрешитьСменуКартинок = 1;
	//////	возврат; 
	//////КонецЕсли;
	//////НомерТекущейКартинки = НомерТекущейКартинки + 1;
	//////
	//////Если НомерТекущейКартинки >= СписокКартинок.Количество() тогда
	//////	НомерТекущейКартинки = 0;
	//////КонецЕсли;
	//////
	//////DRV.ЭлементыФормы.ПолеКартинки.Картинка		= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
	//////
	////////DRV.ЭлементыФормы.ПолеКартинки.Картинка		= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
	////////DRV.ЭлементыФормы.тНаименование.Картинка	= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
	
	ВремяОтображения = ?(СписокКартинок[НомерТекущейКартинки].ВремяОтображения = 0, 5, СписокКартинок[НомерТекущейКартинки].ВремяОтображения);
	ПодключитьОбработчикОжидания("ПоказатьСледующуюКартинку_Ожидание", ВремяОтображения, Истина);
	
КонецПроцедуры

Процедура УстановитьПоложениеОкна() Экспорт
	Попытка
		//Полный экран
		Если РазмерОкнаИнфоДисплея = 0  Тогда
			А = РаботаСокнами.AHK();
			Экраны = ПолучитьИнформациюЭкрановКлиента();
			Если Экраны.Количество() > 1 Тогда
				ШиринаВторогоМонитора = Экраны[1].Ширина;
				ШиринаВторогоМонитораПлюс = ШиринаВторогоМонитора + 9;
				ВысотаВторогоМонитора = Экраны[1].Высота;
				ВысотаВторогоМонитораПлюс = ВысотаВторогоМонитора + 24;
			Иначе
				ШиринаВторогоМонитораПлюс = 1;
				ВысотаВторогоМонитораПлюс = 1;
			КонецЕсли;
			
			Скрипт = "
			|#Persistent
			|
			|Global hwnd := winExist(""%Заголовок"")
			|Global H := %ВысотаВторогоМонитораПлюс
			|Global W := %ШиринаВторогоМонитораПлюс
			|Global X := A_ScreenWidth - 4
 			|if (hwnd)
			|{
			|	tFunc()
			|}
			|
			|SetTimer, tFunc, 13000
			|return
			|
			|tFunc() {
			|	WinMove, ahk_id %hwnd%, , %X%, -21, %W%, %H%
			|	WinSet, Region, 4-21 W%W% H%H%, ahk_id %hwnd%
			|}
			|";
			Скрипт = СтрЗаменить(Скрипт, "%ШиринаВторогоМонитораПлюс", Формат(ШиринаВторогоМонитораПлюс,"ЧГ=0"));
			Скрипт = СтрЗаменить(Скрипт, "%ВысотаВторогоМонитораПлюс", Формат(ВысотаВторогоМонитораПлюс,"ЧГ=0"));
			Скрипт = СтрЗаменить(Скрипт, "%Заголовок", Заголовок);
			А.ahktextDll(Скрипт);
	
		Иначе
			
			А = РаботаСокнами.AHK();
			Скрипт = "
			|#NoTrayIcon
			|Winget, hwnd, id, %Заголовок
			|if (hwnd)
			|{
			|	X := A_ScreenWidth-4
			|	W := 804
			|	H := 620
			|	WinMove, ahk_id %hwnd%, , X, -20,%W%,%H%			
			|	WinSet, Region, 9-20, ahk_id %hwnd%
			|}
			|";
			Скрипт = СтрЗаменить(Скрипт, "%Заголовок", Заголовок);
			А.ahktextDll(Скрипт);
		КонецЕсли;
		
		//A_ = РаботаСокнами.AHK();            
		//Скрипт = "
		//|#NoTrayIcon
		//|WinGet, hwnd, id, Информационный дисплей
		//|ControlGetPos, X, Y, W, H, V8FormElement3, ahk_id %hwnd%
		//|X := X + 4
		//|W := W - 9
		//|;WinSet, Region, %X%-%Y% W%W% H%H%, ahk_id %hwnd%
		//|SysGet, MonitorCount, MonitorCount
		//|IF (MonitorCount < 2) 
		//|{
		//| WinSet, Region, 1-1 W20 H20, ahk_id %hwnd%
		//|}";
		//A_.ahktextdll(Скрипт);
		
	Исключение
	КонецПопытки;
	
КонецПроцедуры

//
//
Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Информационная;
	Если глПараметрыРМ = Неопределено Тогда
		Возврат;
	КонецЕсли;	
		
КонецПроцедуры

//
//
Процедура ПриОткрытии()
	
//ТОВАРГЕТИНФО	
	ЭлементыФормы.ТоварГетИнфо.Видимость = Ложь;
//~ТОВАРГЕТИНФО	
	
	ОбновитьТаймер();
	
	ПодключитьОбработчикОжидания("ОбновитьТаймер", 1);
	Если не Изображение.Пустая() тогда
		DRV.ЭлементыФормы.ПолеКартинки.Картинка		= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
		DRV.ЭлементыФормы.ПолеКартинкиГостя.Картинка= ИзображениеДляМонитораГостя.Хранилище.Получить();
		//DRV.ЭлементыФормы.тНаименование.Картинка	= СписокКартинок[НомерТекущейКартинки].Хранилище.Получить();
		РазрешитьСменуКартинок = 1;
		ВремяОтображения = ?(СписокКартинок[НомерТекущейКартинки].ВремяОтображения = 0, 5, СписокКартинок[НомерТекущейКартинки].ВремяОтображения);
		ПодключитьОбработчикОжидания("ПоказатьСледующуюКартинку_Ожидание", ВремяОтображения, Истина);
		//ПодключитьОбработчикОжидания("ПоказатьСледующуюКартинку", 15);
	КонецЕсли;
	
	//// Установить картинку рекламную
	//Если НЕ Изображение.Пустая() Тогда
	//	ЭлементыФормы.ПолеКартинки.Картинка		= Изображение.Хранилище.Получить();
	//	ЭлементыФормы.тНаименование.Картинка	= Изображение.Хранилище.Получить();
	//КонецЕсли;
	
	
	
	//ЭлементыФормы.НадписьСтанция.Заголовок  = "Сумма по станции:";
	
	
	ТекНомерСтрокиЗаказа = 0;
	ТекНомерСтрокиТабДок = 0;
	
	ПодключитьОбработчикОжидания("УстановитьПоложениеОкна",2,1);
	
КонецПроцедуры

//
//
Процедура ПриЗакрытии()
	
КонецПроцедуры

// Вывести таблицу заказа на ИнфоДисплей
//
Процедура ЗаполнитьТаблицуЗаказа() 
		
	ТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.ФиксацияСверху = 1;
	//ТабличныйДокумент.ОтображатьЗаголовки = Истина;
	
	
	// Сообщить("Высота="+ТабличныйДокумент.Высота+", ширина="+ТабличныйДокумент.Ширина);
	// Фактический размер табл.документа 490*779
	ВысотаЗаголовка	= 1/23.1; // 23.1 - столько строк заголовка влезет по высоте
	ВысотаТовара 	= 1/8;
	ВысотаСпецифики	= 1/28.6;
	
	ОбластьМакетаЗаголовок		= Макет.ПолучитьОбласть("Заголовок|ВидимаяОбласть");
	// Товар
	ОбластьМакетаТовар			= Макет.ПолучитьОбласть("СтрокаТовара|ВидимаяОбласть");
	ОбластьМакетаБезСумм			= Макет.ПолучитьОбласть("СтрокаБезСумм|ВидимаяОбласть");
	ОбластьМакетаТоварОплачено	= Макет.ПолучитьОбласть("СтрокаТовараОплачено|ВидимаяОбласть");
	ОбластьМакетаТоварОплаченоРед	= Макет.ПолучитьОбласть("СтрокаТовараОплаченоРед|ВидимаяОбласть");

	ОбластьМакетаТоварРед 		= Макет.ПолучитьОбласть("СтрокаТовараРед|ВидимаяОбласть");
		
	Если СуммаПоСтанцииНач <> 0 Тогда
		// это дозаказ - новые строки выделяем другим цветом
		ОбластьМакетаТоварНов		= Макет.ПолучитьОбласть("СтрокаТовараНов|ВидимаяОбласть");
	Иначе
		// это первые товары в заказе - выделять строки не нужно
		ОбластьМакетаТоварНов		= ОбластьМакетаТовар;
		
	КонецЕсли; 
	
	ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовок);
	
	Кл = 0;
	СтатДозаказ	= Перечисления.СтатусыПозицийЗаказа.Дозаказ;
	ТекСтанция = ?(глПараметрыРМ.тип = Перечисления.ТипыРМ.Производство,глРабочееМесто.Станция,Справочники.Станции.ПустаяСсылка());
	ФильтрПоСтанции = ЗначениеЗаполнено(ТекСтанция);
	ФильтрПоФирме = ТаблицаЗаказа.Колонки.Найти("Фирма") <> Неопределено;
	НовНомерСтрокиТабДок = 0;
	СуммаПоСтанции = 0;
	
	// Высота строк заказов в таб. документе.
	// Одна строка заказа состоит из нескольких строк таб.документа: строка товара + строка(и) специфик
	// "НомерНижнейСтроки" - номер самой последней строки таб. документа, относящейся к товару.
	// "Высота" - высота всей строки в долях от общей высоты таблицы.
	РазметкаСтрок = Новый ТаблицаЗначений;
	РазметкаСтрок.Колонки.Добавить("НомерНижнейСтроки");
	РазметкаСтрок.Колонки.Добавить("Высота");
	
	СтрокиТоваров = ТаблицаЗаказа.Строки;
	
	// Проверим: будет ли выведена текущая строка заказа
	Если (1 <= НомерСтрокиЗаказа) И (НомерСтрокиЗаказа <= СтрокиТоваров.Количество()) Тогда
		СтрокаЗаказа = СтрокиТоваров[НомерСтрокиЗаказа-1];
		
		Если (ФильтрПоСтанции И СтрокаЗаказа.Станция <> ТекСтанция) ИЛИ (СтрокаЗаказа.Количество = 0) Тогда
			// строка не будет выведена; сделаем текущей "прошлую" строку
			НомерСтрокиЗаказа = Мин(ТекНомерСтрокиЗаказа, СтрокиТоваров.Количество());
		КонецЕсли;		
	КонецЕсли; 
	Коплате = 0;
	Для Каждого СтрокаЗаказа Из СтрокиТоваров Цикл
		
		// Показываем строки только текущей станции
		Если ФильтрПоСтанции И СтрокаЗаказа.Станция <> ТекСтанция Тогда
			Продолжить;
		КонецЕсли;	
		
		Попытка
			Если СтрокаЗаказа.СТатусОплаты <= 0 Тогда
				Коплате = Коплате + СтрокаЗаказа.СуммаРеализации;
			КонецЕсли;
		Исключение
			Коплате = Коплате + СтрокаЗаказа.СуммаРеализации;
		КонецПопытки;
		

		Если ФильтрПоФирме Тогда
			Если глПараметрыРМ.Фирма <> СтрокаЗаказа.Фирма Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			Если СтрокаЗаказа.СтатусОплаты = -1 Тогда
				СуммаПоСтанции = СуммаПоСтанции + СтрокаЗаказа.СуммаРеализации; 
			КонецЕсли;
		Исключение
			СуммаПоСтанции = СуммаПоСтанции + СтрокаЗаказа.СуммаРеализации;
		КонецПопытки;

		НомерТекущей = СтрокиТоваров.Индекс(СтрокаЗаказа) + 1;
		
		// Удаленные не показываем
		Если СтрокаЗаказа.Количество = 0 Тогда
			Продолжить;
		КонецЕсли;		
		
		
		Кл = Кл + 1;
		Четная = (Кл % 2 = 0);
		
		Если НомерТекущей = НомерСтрокиЗаказа Тогда
			ОбластьСтрока 		= ОбластьМакетаТоварРед;
			
			Если СтрокаЗаказа.СтатусОплаты = 1 Тогда
				ОбластьСтрока = ОбластьМакетаТоварОплаченоРед;
			Иначе
				ОбластьСтрока 	= ОбластьМакетаТоварНов;
			КонецЕсли;
			
		Иначе
			// Старые строки
			
			Если СтрокаЗаказа.СтатусОплаты = 1 Тогда
				ОбластьСтрока = ОбластьМакетаТоварОплачено;
			Иначе
				ОбластьСтрока 		= ОбластьМакетаТовар;
			КонецЕсли;
		КонецЕсли;
		
		Если СтрокаЗаказа.Цена = 0 И СтрокаЗаказа.Количество = 1 И лев(СтрокаЗаказа.Товар.КодСУП,2)="16" Тогда
			ОбластьСтрока = ОбластьМакетаБезСумм;
		КонецЕсли;

		
				
		ОбластьСтрока.Параметры.Заполнить(СтрокаЗаказа);
		
		Попытка
			ОбластьСтрока.Параметры.Состав = "";
			ОбластьСтрока.Параметры.Состав = СокрЛП(СтрокаЗаказа.Товар.Номенклатура.Состав);
		Исключение
			
		КонецПопытки;
		ОбластьСтрока.Параметры.Кл = ?(РежимВывода = "Заказ", Кл, СтрокаЗаказа.Очередность);
		
		Если ОбластьСтрока.Рисунки.Количество() Тогда 
			Если ЗначениеЗаполнено(СтрокаЗаказа.ГруппаАкции) Тогда
				Попытка
					Картинка = БиблиотекаКартинок["ГруппаАкций"+СтрокаЗаказа.ГруппаАкции];
					ОбластьСтрока.Рисунки[ОбластьСтрока.Рисунки.Количество()-1].Картинка = Картинка;	
				Исключение
					ОбластьСтрока.Рисунки[ОбластьСтрока.Рисунки.Количество()-1].Картинка = Новый Картинка;
				КонецПопытки;
				
			Иначе
				ОбластьСтрока.Рисунки[ОбластьСтрока.Рисунки.Количество()-1].Картинка = Новый Картинка;
			КонецЕсли;
		КонецЕсли;
		ТабличныйДокумент.Вывести(ОбластьСтрока); 
		
		СтрокаРазметки = РазметкаСтрок.Добавить();
		СтрокаРазметки.НомерНижнейСтроки = ТабличныйДокумент.ВысотаТаблицы;
		СтрокаРазметки.Высота = ВысотаТовара;
		
		Если НомерТекущей = НомерСтрокиЗаказа Тогда
			НовНомерСтрокиТабДок = ТабличныйДокумент.ВысотаТаблицы;
		КонецЕсли;
		
				
	КонецЦикла;
	
	// Номер текущей строки таб.документа не должен быть больше высоты выведенной таблицы. 
	// Высота может уменьшиться при удалении строк в заказе.
	ТекНомерСтрокиТабДок = Мин(ТекНомерСтрокиТабДок, ТабличныйДокумент.ВысотаТаблицы);
	
	Если НовНомерСтрокиТабДок = 0 Тогда
		НовНомерСтрокиТабДок = ТабличныйДокумент.ВысотаТаблицы;
		
	ИначеЕсли НовНомерСтрокиТабДок > ТабличныйДокумент.ВысотаТаблицы Тогда	
		НовНомерСтрокиТабДок = ТабличныйДокумент.ВысотаТаблицы;
	КонецЕсли; 

	//--------------------------------------------------------------------------------//
	//ТЕСТ СПЕЦИФИК КП
	//ТабличныйДокумент.УстановитьПривязку(
	//СтрокаСпецифик = ПолучитьМакет("Специфика1280х1024").ПолучитьОбласть("СтрокаСпецифик");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ 15
	|	ХранилищеДополнительнойИнформации.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.ХранилищеДополнительнойИнформации КАК ХранилищеДополнительнойИнформации
	|ГДЕ
	|	ХранилищеДополнительнойИнформации.Родитель.Наименование = &Родитель";
	Запрос.УстановитьПараметр("Родитель", "Специфики КП");
	РезультатЗапроса = Запрос.Выполнить().Выгрузить();
	
	КоличествоСпецифик = РезультатЗапроса.Количество();
	//DeBuG
	КоличествоСпецифик = Окр(Секунда(ТекущаяДата()) / 4, 0, РежимОкругления.Окр15как20);
	
	Если КоличествоСпецифик > 8 Тогда
		чСтрок = 3;
		чКолонок = 5;
		Вграница = 15;
	Иначе	
		чСтрок = 2;
		чКолонок = 4;
		Вграница = 8;
	КонецЕсли;
	
	МКТ = ПолучитьМакет("Специфика1280х1024").ПолучитьОбласть(СтрШаблон("СтрокаСпецифик|ВидимаяОбласть_%1х%2", чКолонок, чСтрок));
	
	ОбластьГруппаСпецифик = ПолучитьМакет("Специфика1280х1024").ПолучитьОбласть("ГруппаСпецифик");
	СтрокаСпецифик = Новый ТабличныйДокумент;
	ОбластьГруппаСпецифик.Параметры.Наименование = "Очень длинное наименование группы специфик для одного из товаров Кухни Полли. Настолько длинное, что не вмещается в одну строку на мониторе гостя.";
	СтрокаСпецифик.Вывести(ОбластьГруппаСпецифик);
	Для Яч = 0 По Вграница Цикл
		Попытка
			ХДИ = РезультатЗапроса[Яч].Ссылка.Хранилище.Получить();
			МКТ.Параметры.Наименование = РезультатЗапроса[Яч].Ссылка.Наименование;
			МКТ.Параметры.Цена = Формат(123.45, "ЧДЦ=2; ЧН==; ЧГ=3,0") + " " + Символ(8381);
		Исключение
			МКТ.Параметры.Наименование = "";
			МКТ.Параметры.Цена = "";
		    ХДИ = Неопределено;
		КонецПопытки;
		МКТ.Область("R1C1:R2C1").Картинка = ХДИ;
		Если Яч % 2 Тогда
			МКТ.Область("R4C1:R4C2").Картинка = Неопределено;
		Иначе
			МКТ.Область("R4C1:R4C2").Картинка = БиблиотекаКартинок.CheckMark48;
		КонецЕсли;
		
		Если Яч % чКолонок = 0 Тогда
			СтрокаСпецифик.Вывести(МКТ);
		Иначе
			СтрокаСпецифик.Присоединить(МКТ);
		КонецЕсли;
	КонецЦикла;
	ТабличныйДокумент.Вывести(СтрокаСпецифик); 
	//--------------------------------------------------------------------------------//
	
	
	// *** Итоги ***
	Сумма	= ТаблицаЗаказа.Строки.Итог("Сумма");
	//Итого	= ТаблицаЗаказа.Строки.Итог("СуммаРеализации");
	//ЭлементыФормы.НадписьСтанция.Заголовок  = "Сумма по станции:";

	
	// *** Опеределение строки, которую необходимо сделать текущей ***
	// Таблица полностью замещается. Текущая активная область не сохраняется.
	
	ВысотаСтраницы    = 1 - ВысотаЗаголовка;	
	
	НачСтрокаСтраницы = ОпределитьГраницуСтраницы(РазметкаСтрок, ВысотаСтраницы, ТекНомерСтрокиТабДок, Ложь);
	Если НачСтрокаСтраницы = Неопределено Тогда
		НачСтрокаСтраницы = 1;
	КонецЕсли; 
	
	Если НомерСтрокиЗаказа = ТекНомерСтрокиЗаказа Тогда
		// Строка товара не изменилась => Делаем текущей ту же самую строку, что была в прошлый раз.
		Если (НачСтрокаСтраницы <= НовНомерСтрокиТабДок) И (НовНомерСтрокиТабДок <= ТекНомерСтрокиТабДок) Тогда
			УстановитьТекущуюСтрокуЗаказа(ТекНомерСтрокиТабДок);
		Иначе
			// изменилась высота текущей страницы так, что строка вышла за её пределы => Найдём новую конечную строку.
			КонСтрокаСтраницы = ОпределитьГраницуСтраницы(РазметкаСтрок, ВысотаСтраницы, НовНомерСтрокиТабДок, Истина);
			Если КонСтрокаСтраницы <> Неопределено Тогда
				НовНомерСтрокиТабДок = КонСтрокаСтраницы;
			КонецЕсли; 
			
			УстановитьТекущуюСтрокуЗаказа(НовНомерСтрокиТабДок);
			ТекНомерСтрокиТабДок = НовНомерСтрокиТабДок;
		КонецЕсли; 
		
	ИначеЕсли (НачСтрокаСтраницы <= НовНомерСтрокиТабДок) И (НовНомерСтрокиТабДок <= ТекНомерСтрокиТабДок) Тогда	
		// Строка останется в пределах текущей страницы, если сделаем текущей ту же самую строку, что была в прошлый раз.
		УстановитьТекущуюСтрокуЗаказа(ТекНомерСтрокиТабДок);
		
	ИначеЕсли НомерСтрокиЗаказа < ТекНомерСтрокиЗаказа Тогда
		// Сдвиг текущей строки вверх => Нужно от новой строки отсчитать вниз строки до самой последней строки, 
		// которая ещё будет влезать на экран. Делаем последнюю строку текущей.
		КонСтрокаСтраницы = ОпределитьГраницуСтраницы(РазметкаСтрок, ВысотаСтраницы, НовНомерСтрокиТабДок, Истина);
		Если КонСтрокаСтраницы <> Неопределено Тогда
			НовНомерСтрокиТабДок = КонСтрокаСтраницы;
		КонецЕсли; 
		
		УстановитьТекущуюСтрокуЗаказа(НовНомерСтрокиТабДок);
		ТекНомерСтрокиТабДок = НовНомерСтрокиТабДок;
		
	Иначе
		// Сдвиг текущей строки вниз => Делаем текущей саму строку.
		УстановитьТекущуюСтрокуЗаказа(НовНомерСтрокиТабДок);
		ТекНомерСтрокиТабДок = НовНомерСтрокиТабДок;
	КонецЕсли; 
	
	ТекНомерСтрокиЗаказа = НомерСтрокиЗаказа;
	
	ИнтерфейсРМ.ЗаполнитьПодвалГостя(ЭлементыФормы.ТабДокПодвал, Заказ, МакетПодвал, ЛояльностьДанныеЗаказа);
КонецПроцедуры

// < КС_ВДВ ------------------------------------------------------------ 
Процедура УстановитьТекущуюСтрокуЗаказа(НомерСтрокиТД)

	Если НомерСтрокиТД = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	ТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
	
	ТекНомер = Мин(НомерСтрокиТД, ТабличныйДокумент.ВысотаТаблицы);
	
	ТабличныйДокумент.ТекущаяОбласть = ТабличныйДокумент.Область("R"+НомерСтрокиТД+"C1");	

КонецПроцедуры // КС_ВДВ > ------------------------------------------------------------ 

// < КС_ВДВ ------------------------------------------------------------ 
Функция ОпределитьГраницуСтраницы(ТабРазметка, Знач ВысотаСтраницы, ВыбСтрока, ИскатьВниз)

	ГраницаСтраницы = Неопределено;
	
	СтрокаРазметки = ТабРазметка.Найти(ВыбСтрока, "НомерНижнейСтроки");

	Если СтрокаРазметки <> Неопределено Тогда
		ВысотаТек = 0;
		Индекс = ТабРазметка.Индекс(СтрокаРазметки);
		МаксИндекс = ТабРазметка.Количество() - 1;
		
		Пока (0 <= Индекс) И (Индекс <= МаксИндекс) Цикл
			СтрокаРазметки = ТабРазметка[Индекс];
			
			ВысотаТек = ВысотаТек + СтрокаРазметки.Высота;
			
			Если ВысотаТек >= ВысотаСтраницы Тогда
				Прервать;
			КонецЕсли; 
			
			ГраницаСтраницы = СтрокаРазметки.НомерНижнейСтроки;
			
		    Индекс = ?(ИскатьВниз, Индекс + 1, Индекс - 1);
		КонецЦикла; 
	КонецЕсли; 
	
	Возврат ГраницаСтраницы;
	
КонецФункции // КС_ВДВ > ------------------------------------------------------------ 

// < КС_ВДВ ------------------------------------------------------------ 
// Вывести таблицы марок на ИнфоДисплей
//
Процедура ЗаполнитьТаблицуВыдачи(ВывестиМаркиПриготовление=Ложь) 
		
	ТекСтанция = глРабочееМесто.Станция;
	
	Если ВывестиМаркиПриготовление Тогда
		
		// ПРИГОТОВЛЕНИЕ
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Товары.Подача КАК Подача,
		|	Товары.Товар КАК Товар,
		|   Товары.идСтроки Как ИдСтроки,
		|	Товары.Количество КАК Количество,
		|	Специфики.Специфика,
		|	Товары.БудетВыдано КАК БудетВыдано
		|ИЗ
		|	(ВЫБРАТЬ
		|		ЗаказТоварыДопИнф.Подача КАК Подача,
		|		ЗаказТоварыДопИнф.Товар КАК Товар,
		|		ЗаказТоварыДопИнф.Количество КАК Количество,
		|		ЗаказТоварыДопИнф.ИдСтроки КАК ИдСтроки,
		|		0 КАК БудетВыдано
		|	ИЗ
		|		РегистрСведений.ЗаказТоварыДопИнф КАК ЗаказТоварыДопИнф
		|	ГДЕ
		|		ЗаказТоварыДопИнф.Заказ = &Заказ
		|		И ЗаказТоварыДопИнф.Станция = &Станция
		|		И ЗаказТоварыДопИнф.Статус = &Статус
		|		И ЗаказТоварыДопИнф.Количество > 0
		|		И ЗаказТоварыДопИнф.Товар ССЫЛКА Справочник.Товары
		|		И ЗаказТоварыДопИнф.ВремяГотово = ДАТАВРЕМЯ(1, 1, 1)) КАК Товары
		|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
		|			ЗаказТоварыДопИнф.Товар КАК Специфика,
		|			ЗаказТоварыДопИнф.ИдСтрокиВладельца КАК ИдСтрокиВладельца
		|		ИЗ
		|			РегистрСведений.ЗаказТоварыДопИнф КАК ЗаказТоварыДопИнф
		|		ГДЕ
		|			ЗаказТоварыДопИнф.Заказ = &Заказ
		|			И ЗаказТоварыДопИнф.Станция = &Станция
		|			И ЗаказТоварыДопИнф.Статус = &Статус
		|			И ЗаказТоварыДопИнф.Количество > 0
		|			И ЗаказТоварыДопИнф.Товар ССЫЛКА Справочник.Специфики
		|			И ЗаказТоварыДопИнф.ВремяГотово = ДАТАВРЕМЯ(1, 1, 1)) КАК Специфики
		|		ПО Товары.ИдСтроки = Специфики.ИдСтрокиВладельца
		|
		|УПОРЯДОЧИТЬ ПО
		|	Подача,
		|	Товар
		|ИТОГИ
		|	МАКСИМУМ(Количество),
		|	СУММА(БудетВыдано)
		|ПО
		|	Подача,
		|	ИдСтроки,
		|	Товар
		|АВТОУПОРЯДОЧИВАНИЕ";
		
		Запрос.УстановитьПараметр("ДатаНачала",	ТекущаяДата()-60*60*12); // за последние 12 часов
		Запрос.УстановитьПараметр("Заказ",		Заказ);
		Запрос.УстановитьПараметр("Станция",	ТекСтанция);
		Запрос.УстановитьПараметр("Статус",		Перечисления.СтатусыПозицийЗаказа.Заказано);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ЗаполнитьТаблицуМарок(ЭлементыФормы.ПолеПриготовление, РезультатЗапроса);
	КонецЕсли; 
	
	// К ВЫДАЧЕ
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Товары.Подача КАК Подача,
	|	Товары.Товар КАК Товар,
	|   Товары.идСтроки Как ИдСтроки,
	|	Товары.Количество КАК Количество,
	|	Специфики.Специфика,
	|	Товары.БудетВыдано КАК БудетВыдано
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаказТоварыДопИнф.Подача КАК Подача,
	|		ЗаказТоварыДопИнф.Товар КАК Товар,
	|		ЗаказТоварыДопИнф.Количество КАК Количество,
	|		ЗаказТоварыДопИнф.ИдСтроки КАК ИдСтроки,
	|		ВЫБОР
	|			КОГДА ЗаказТоварыДопИнф.КодПодтверждения В (&КодыПодтв)
	|				ТОГДА 1
	|			ИНАЧЕ 0
	|		КОНЕЦ КАК БудетВыдано
	|	ИЗ
	|		РегистрСведений.ЗаказТоварыДопИнф КАК ЗаказТоварыДопИнф
	|	ГДЕ
	|		ЗаказТоварыДопИнф.Заказ = &Заказ
	|		И ЗаказТоварыДопИнф.Станция = &Станция
	|		И ЗаказТоварыДопИнф.Статус = &Статус
	|		И ЗаказТоварыДопИнф.Количество > 0
	|		И ЗаказТоварыДопИнф.Товар ССЫЛКА Справочник.Товары
	|		И ЗаказТоварыДопИнф.ВремяГотово > &ДатаНачала) КАК Товары
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|			ЗаказТоварыДопИнф.Товар КАК Специфика,
	|			ЗаказТоварыДопИнф.ИдСтрокиВладельца КАК ИдСтрокиВладельца
	|		ИЗ
	|			РегистрСведений.ЗаказТоварыДопИнф КАК ЗаказТоварыДопИнф
	|		ГДЕ
	|			ЗаказТоварыДопИнф.Заказ = &Заказ
	|			И ЗаказТоварыДопИнф.Станция = &Станция
	|			И ЗаказТоварыДопИнф.Статус = &Статус
	|			И ЗаказТоварыДопИнф.Количество > 0
	|			И ЗаказТоварыДопИнф.Товар ССЫЛКА Справочник.Специфики
	|			И ЗаказТоварыДопИнф.ВремяГотово > &ДатаНачала) КАК Специфики
	|		ПО Товары.ИдСтроки = Специфики.ИдСтрокиВладельца
	|
	|УПОРЯДОЧИТЬ ПО
	|	Подача,
	|	Товар
	|ИТОГИ
	|	МАКСИМУМ(Количество),
	|	СУММА(БудетВыдано)
	|ПО
	|	Подача,
	|	ИдСтроки,
	|	Товар
	|АВТОУПОРЯДОЧИВАНИЕ";
		
	Запрос.УстановитьПараметр("ДатаНачала",	ТекущаяДата()-60*60*12); // за последние 12 часов
	Запрос.УстановитьПараметр("Заказ",		Заказ);
	Запрос.УстановитьПараметр("Станция",	ТекСтанция);
	Запрос.УстановитьПараметр("Статус",		Перечисления.СтатусыПозицийЗаказа.Готово);
	Запрос.УстановитьПараметр("КодыПодтв",	СписокКодовПодтверждений.ВыгрузитьЗначения());
	                                       
	РезультатЗапроса = Запрос.Выполнить();
	
	ЗаполнитьТаблицуМарок(ЭлементыФормы.ПолеКВыдаче, РезультатЗапроса);
	
КонецПроцедуры // КС_ВДВ > ------------------------------------------------------------ 

// < КС_ВДВ ------------------------------------------------------------ 
// Вывести результат запроса по маркам
Процедура ЗаполнитьТаблицуМарок(ТабличныйДокумент, РезультатЗапроса)

	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.ФиксацияСверху = 1;
	
	Макет = ЭтотОбъект.ПолучитьМакет("Марки800х600");

	Выд = ?(ТабличныйДокумент.Имя = "ПолеКВыдаче", "Выд", "");
	
	ОбластьМакетаЗаголовок		= Макет.ПолучитьОбласть("Заголовок|ВидимаяОбласть");
	// Товар
	ОбластьМакетаТовар1			= Макет.ПолучитьОбласть("СтрокаТовара"+Выд+"1|ВидимаяОбласть");
	ОбластьМакетаТовар2			= Макет.ПолучитьОбласть("СтрокаТовара"+Выд+"2|ВидимаяОбласть");
	ОбластьМакетаТоварРед 		= Макет.ПолучитьОбласть("СтрокаТовараРед|ВидимаяОбласть");
	// Специфики
	ОбластьМакетаСпецифика1		= Макет.ПолучитьОбласть("СтрокаСпецифики"+Выд+"1|ВидимаяОбласть");
	ОбластьМакетаСпецифика2		= Макет.ПолучитьОбласть("СтрокаСпецифики"+Выд+"2|ВидимаяОбласть");
    ОбластьМакетаСпецификаРед	= Макет.ПолучитьОбласть("СтрокаСпецификиРед|ВидимаяОбласть");
	
	ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовок);
	
	Если РезультатЗапроса.Пустой() Тогда
		Возврат;
	КонецЕсли; 
	
	Кл = 0;
	ПоследняяСтрокаВыдачи = 0;
	
	ВыборкаПодача = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока ВыборкаПодача.Следующий() Цикл
		
		Подача = ВыборкаПодача.Подача;
		
		ВыборкаСтроки = ВыборкаПодача.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаСтроки.Следующий() Цикл
			
		ВыборкаТовары = ВыборкаСтроки.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		
		Пока ВыборкаТовары.Следующий() Цикл
			
			Кл = Кл + 1;
			Четная = (Кл % 2 = 0);
			
			Если ВыборкаТовары.БудетВыдано > 0 Тогда
			    ОбластьСтрока 		= ОбластьМакетаТоварРед;
				ОбластьСпецифика 	= ОбластьМакетаСпецификаРед;
				
			ИначеЕсли Четная Тогда
				ОбластьСтрока 		= ОбластьМакетаТовар2;
				ОбластьСпецифика 	= ОбластьМакетаСпецифика2;
				
			Иначе
				ОбластьСтрока 		= ОбластьМакетаТовар1;
				ОбластьСпецифика 	= ОбластьМакетаСпецифика1;
			КонецЕсли;
			
			ОбластьСтрока.Параметры.Заполнить(ВыборкаТовары);
			//ОбластьСтрока.Параметры.Подача = Подача;	
			ТабличныйДокумент.Вывести(ОбластьСтрока); 
			
			Специфики = "";
			
			ВыборкаСпецифики = ВыборкаТовары.Выбрать();
			Пока ВыборкаСпецифики.Следующий() Цикл
				Специфика = ВыборкаСпецифики.Специфика;
				
				Если ЗначениеЗаполнено(Специфика) Тогда
					Специфики = Специфики + ?(ПустаяСтрока(Специфики), "", ", ") + ВыборкаСпецифики.Специфика;	
				КонецЕсли; 
			КонецЦикла;

			Если НЕ ПустаяСтрока(Специфики) Тогда
				ОбластьСпецифика.Параметры.Специфики = Специфики;	
				ТабличныйДокумент.Вывести(ОбластьСпецифика); 
			КонецЕсли; 
			
			Если ВыборкаТовары.БудетВыдано > 0 Тогда
				ПоследняяСтрокаВыдачи = ТабличныйДокумент.ВысотаТаблицы;
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла; 
	КонецЦикла; 
	
	НомерСтрокиТабДок = ?(ПоследняяСтрокаВыдачи > 0, ПоследняяСтрокаВыдачи, ТабличныйДокумент.ВысотаТаблицы);
	ТабличныйДокумент.ТекущаяОбласть = ТабличныйДокумент.Область("R"+НомерСтрокиТабДок+"C1");	
	
КонецПроцедуры // КС_ВДВ > ------------------------------------------------------------ 

//Z+
Процедура ЗаполнитьТаблицуСпецифик()
	ТабличныйДокумент = ЭлементыФормы.ПолеТабличногоДокумента;
	ТабличныйДокумент.Очистить();
	ТабличныйДокумент.ФиксацияСверху = 1;
	
	Макет = ЭтотОбъект.ПолучитьМакет("Специфика800х600");

	
	ОбластьМакетаЗаголовок		= Макет.ПолучитьОбласть("Заголовок|ВидимаяОбласть");
	// Товар
	ОбластьМакетаТовар1			= Макет.ПолучитьОбласть("СтрокаТовара1|ВидимаяОбласть");
	ОбластьМакетаТовар2			= Макет.ПолучитьОбласть("СтрокаТовараНов2|ВидимаяОбласть");
	ОбластьМакетаТоварРед 		= Макет.ПолучитьОбласть("СтрокаТовараРед|ВидимаяОбласть");
	// Специфики
	ОбластьМакетаСпецифика1		= Макет.ПолучитьОбласть("СтрокаСпецифики1|ВидимаяОбласть");
	ОбластьМакетаСпецифика2		= Макет.ПолучитьОбласть("СтрокаСпецификиНов2|ВидимаяОбласть");
    ОбластьМакетаСпецификаРед	= Макет.ПолучитьОбласть("СтрокаСпецификиРед|ВидимаяОбласть");
	
	ТабличныйДокумент.Вывести(ОбластьМакетаЗаголовок);
	
	Если ТаблицаСпецифик.Количество()=0 Тогда
		Возврат;
	КонецЕсли; 
	оНоменклатура = Товар.Номенклатура.ПолучитьОбъект();
	пНаименование = ?(ЗначениеЗаполнено(оНоменклатура.ДляЦенника),оНоменклатура.ДляЦенника,Товар.Наименование);
	
	Если ЗначениеЗаполнено(оНоменклатура.НаименованиеОригинальное) тогда 
		пНаименование = пНаименование = "(" + оНоменклатура.НаименованиеОригинальное + ")";
	КонецЕсли;
	ОбластьМакетаТовар2.Параметры.Наименование = пНаименование;
	ОбластьМакетаТовар2.Параметры.Количество=1;
	ОбластьМакетаТовар2.Параметры.Цена=СуммаПоСтанцииНач;
	ОбластьМакетаТовар2.Параметры.Сумма=СуммаПоСтанцииНач;
	ТабличныйДокумент.Вывести(ОбластьМакетаТовар2);
	
	Кл = 0;
	ПоследняяСтрокаВыдачи = 0;
	//Гр="";
	СуммаСпецифик=0;
	ТаблицаСпецифик.Сортировать("ПорядокВыбора");	
	Для Каждого Спец из ТаблицаСпецифик Цикл	
		Если Спец.УдельныйВес=0 Тогда
			Продолжить;
		КонецЕсли;	
		ОбластьСтрока 		= ОбластьМакетаТовар1;
		ОбластьСпецифика 	= ОбластьМакетаСпецифика1;
		ОбластьСтрока.Параметры.Наименование=Спец.Специфика.Наименование;
		ОбластьСтрока.Параметры.Количество=Спец.УдельныйВес;
		ОбластьСтрока.Параметры.Цена=Спец.Цена;
		ОбластьСтрока.Параметры.Сумма=Спец.Сумма;
		СуммаСпецифик = СуммаСпецифик + Спец.Сумма;
		ТабличныйДокумент.Вывести(ОбластьСтрока); 
	КонецЦикла; 
	
	НомерСтрокиТабДок = ?(ПоследняяСтрокаВыдачи > 0, ПоследняяСтрокаВыдачи, ТабличныйДокумент.ВысотаТаблицы);
	ТабличныйДокумент.ТекущаяОбласть = ТабличныйДокумент.Область("R"+НомерСтрокиТабДок+"C1");	
	мСтрокиТекТовара = Этотобъект.ТаблицаЗаказа.Строки.НайтиСтроки(Новый СТруктура("Товар,Сумма",Товар,0));
	Если мСтрокиТекТовара.Количество() Тогда
		ЦенаТовара = мСтрокиТекТовара.Получить(0).Цена;
	Иначе
		ЦенаТовара = 0;
	КонецЕсли;
	
	ОбластьТоварЦена = ТабличныйДокумент.Область("R2C7");
	ОбластьТоварСумма = ТабличныйДокумент.Область("R2C9");
	ОбластьТоварЦена.Текст = ЦенаТовара;
	ОбластьТоварСумма.Текст = ЦенаТовара+СуммаСпецифик;
	
	Итого	= ТаблицаЗаказа.Строки.Итог("СуммаРеализации");
	
	//ЭлементыФормы.НадписьСтанция.Заголовок  = "За блюдо:";
	
КонецПроцедуры
//Z-

// Получить в строку все специфики к товару
//
Функция  ПолучитьПереченьСпецифик(СтрокиСпецифик, ТекНаименование = "")
	
	Для Каждого СтрокаСпецифики Из СтрокиСпецифик.Строки Цикл
		ТекНаименование = ТекНаименование + ?(ЗначениеЗаполнено(ТекНаименование), ", " , "")+ СтрокаСпецифики.Наименование;
		Если ЗначениеЗаполнено(СтрокаСпецифики.Строки) Тогда
			ПолучитьПереченьСпецифик(СтрокаСпецифики, ТекНаименование);
		КонецЕсли;
   КонецЦикла;	
   
   Возврат ТекНаименование;
   
КонецФункции


// < КС_ВДВ ------------------------------------------------------------ 
Процедура  ЗаполнитьМассивСпецифик(СтрокиСпецифик, МассивСпецифик)
	
	Для Каждого СтрокаСпецифики Из СтрокиСпецифик.Строки Цикл
		МассивСпецифик.Добавить(""+СтрокаСпецифики.Товар+?(СтрокаСпецифики.Цена = 0,""," ( +"+СтрокаСпецифики.Цена+"р.)"));
		
		Если ЗначениеЗаполнено(СтрокаСпецифики.Строки) Тогда
			ЗаполнитьМассивСпецифик(СтрокаСпецифики, МассивСпецифик);
		КонецЕсли;
   КонецЦикла;	
   
КонецПроцедуры // КС_ВДВ > ------------------------------------------------------------ 

// < КС_ВДВ ------------------------------------------------------------ 
Функция  ПолучитьМассивСтрокСпецифик(СтрокиСпецифик, МаксДлинаСтроки)
	
	МассивСпецифик = Новый Массив;
	ЗаполнитьМассивСпецифик(СтрокиСпецифик, МассивСпецифик);
	
	ТекСтрока = "";
	МассивСтрокСпецифик = Новый Массив;
	
	Для К = 0 По МассивСпецифик.Количество() - 1 Цикл
		СтрСпецифика = МассивСпецифик[К];
		
		ТекСтрока2 = ТекСтрока + ?(ПустаяСтрока(ТекСтрока), "", ", ") + СтрСпецифика;
		
		Если СтрДлина(ТекСтрока2) >= МаксДлинаСтроки Тогда
			МассивСтрокСпецифик.Добавить(ТекСтрока);	
			ТекСтрока = СтрСпецифика;
		Иначе
			ТекСтрока = ТекСтрока2;
		КонецЕсли; 
	КонецЦикла; 
	
	Если НЕ ПустаяСтрока(ТекСтрока) Тогда
		МассивСтрокСпецифик.Добавить(ТекСтрока);
	КонецЕсли; 
	
   Возврат МассивСтрокСпецифик;
   
КонецФункции // КС_ВДВ > ------------------------------------------------------------ 

// Спозиционировать форму дисплея на втором экране
//
Процедура РазвернутьОкноИнфоДисплея()
	Перем X,Y;
	ТекущаяФормаhWnd = 1;
	//РаботаСокнами.GetWndSizeV8(ТекущаяФормаhWnd, X, Y);
	// Открываем форму на втором экране (слева)
	//РаботаСокнами.УстановитьПоложениеОкна(Заголовок, 1599, 0);
	//РаботаСокнами.УстановитьРазмерДочернегоОкна(ТекущаяФормаhWnd, 800, 600);
	// Разворачиваем во весь второй экран
	//Если глПараметрыРМ.БлокировкаПереднийПлан Тогда //ИЛИ (глпараметрырм.ШиринаОкна1С< 1400) 
	//    РаботаСокнами.УстановитьПоложениеОкна(Заголовок, 1921, 0, 800, 600);
	//	РаботаСокнами.МаксимизироватьДочернее(Заголовок);	
	//Иначе
	//	
	//	РаботаСокнами.УстановитьПоложениеОкна(Заголовок, 1921, 0, 800, 600);

	//
	//КонецЕсли; 
	
	
	//ПодключитьОбработчикОжидания("УстановитьРазмерыИнфоДисплея", 0.1, Истина);	
	
КонецПроцедуры

// Установить размер формы
// Установить активную страницу рекламы
// Установить фокус на РМ
//
Процедура УстановитьРазмерыИнфоДисплея()
	
	Перем X, Y;
	// Получаем координаты левого верхнего угла
	РаботаСокнами.GetWndPosV8(ТекущаяФормаhWnd, X, Y );
	

	// Изменяем зазмер если не во весь экран
	Если РазмерОкнаИнфоДисплея <> 0 Тогда
		Если РазмерОкнаИнфоДисплея = 2 Тогда
			//РаботаСокнами.SetWndPosV8(ТекущаяФормаhWnd, X + 1, Y + 1);
			РаботаСокнами.УстановитьРазмерДочернегоОкна(ТекущаяФормаhWnd, 1025, 768);
		ИначеЕсли РазмерОкнаИнфоДисплея = 1 Тогда
			РаботаСокнами.SetWndPosV8(ТекущаяФормаhWnd, X + 1, Y + 1);
			РаботаСокнами.УстановитьРазмерДочернегоОкна(ТекущаяФормаhWnd, 800, 600);
		КонецЕсли;
	Иначе
		РаботаСокнами.МаксимизироватьДочернее(Заголовок);
	КонецЕсли;	
	
	// Активируем рекламную страницу
	АктивироватьСтраницуЗаказа(Ложь);
	
	// установка фокуса обратно на РМ
	//WshShell.AppActivate(?(ТекущийЯзыкСистемы()="en","1C:Enterprise", "1С:Предприятие") + " - " + ПолучитьЗаголовокСистемы() );
	
КонецПроцедуры

// Свернуть форму ИнфоДисплея (не используется)
//
Процедура СвернутьИнфоДисплей()
	
	РаботаСокнами.MinimizeV8( ТекущаяФормаhWnd );
	
КонецПроцедуры

// чтобы часики тикали
//
Процедура ОбновитьТаймер()
	
	ТекВремя = ТекущаяДата();
	тВремя	= Формат(ТекВремя,"ДФ='HH:mm ddd, dd MMMM'");	
КонецПроцедуры

// перелистывание между заказом и рекламой
//
Процедура АктивироватьСтраницуЗаказа(ПоказатьЗаказ = Истина) Экспорт
	
	Если СброситьНастройки ИЛИ (НЕ ЗначениеЗаполнено(ТаблицаЗаказа)) Тогда
		ТекНомерСтрокиЗаказа = 0;
		ТекНомерСтрокиТабДок = 0;
	КонецЕсли; 
	
	ЭлементыФормы.ПанельОсновная.Страницы.Заказ.Видимость			= ПоказатьЗаказ;
	ЭлементыФормы.ПанельОсновная.Страницы.Информационная.Видимость	= НЕ ПоказатьЗаказ;
	
	Если ПоказатьЗаказ Тогда
		ЭлементыФормы.ПанельКонтент.Страницы.ПриемЗаказа.Видимость  = НЕ (РежимВывода = "Марки");	
		ЭлементыФормы.ПанельКонтент.Страницы.ВыдачаЗаказа.Видимость = (РежимВывода = "Марки");	
	КонецЕсли; 
	Если ПоказатьЗаказ Тогда
		Если РежимВывода = "Марки" Тогда
		    ЗаполнитьТаблицуВыдачи(СброситьНастройки);
//Z+			
		ИначеЕсли РежимВывода = "Специфика" Тогда
			ЗаполнитьТаблицуСпецифик();
//Z-			
		Иначе
			ЗаполнитьТаблицуЗаказа();
		КонецЕсли; 
		ЗаполнитьПанельЛояльность();
	КонецЕсли; 
	
	тБейдж = Заказ.КартаДоступа.Идентификатор2;
	тЗаказ = "Ваш ЗАКАЗ " + глПараметрыРМ.Фирма;
	Попытка
		Если СтрНайти(глПараметрыРМ.Фирма, "Отд") Тогда
			ЭлементыФормы.ПолеКартинки1.Картинка = БиблиотекаКартинок.МониторГостя_Отдохни;
		КонецЕсли;	
		
	Исключение
	КонецПопытки;
КонецПроцедуры	

Процедура ПолеКартинкиНажатие(Элемент)
	//АктивироватьСтраницуЗаказа(ИСтина);
КонецПроцедуры

Процедура ЗаполнитьПанельЛояльность()

	ПоказатьТабДокЛояльность = НЕ ТабДокЛояльность.ВысотаТаблицы = 0;
	Если ПоказатьТабДокЛояльность Тогда
		ЭлементыФормы.ТабДокЛояльность.Очистить();
		ЭлементыФормы.ТабДокЛояльность.Вывести(ТабДокЛояльность);
	КонецЕсли;
	ЭлементыФормы.ТабДокЛояльность.Видимость = ПоказатьТабДокЛояльность;
	ЭлементыФормы.ПолеКартинкиГостя.Видимость = НЕ ПоказатьТабДокЛояльность;

КонецПроцедуры

Процедура ТоварГетИнфоДокументСформирован(Элемент)
	Элемент.Видимость = НЕ ПустаяСтрока(Элемент.Документ.url) И НЕ Элемент.Документ.url = "about:blank";
КонецПроцедуры

ТекНомерСтрокиЗаказа = 0;
ТекНомерСтрокиТабДок = 0;
Макет = ЭтотОбъект.ПолучитьМакет("Заказ1280х1024");