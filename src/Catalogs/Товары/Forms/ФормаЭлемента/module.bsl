﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЧЕЕ


Процедура ПрочитатьЦены(ТоварСсылка)

	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ТипыЦен.Ссылка КАК ТипЦен,
	|	ЦеныНоменклатурыСрезПоследних.Период КАК ДатаИзменения,
	|	ЦеныНоменклатурыСрезПоследних.Цена КАК Цена,
	|	ЦеныНоменклатурыСрезПоследних.Валюта КАК Валюта
	|ИЗ
	|	Справочник.ТипыЦен КАК ТипыЦен
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ДатаЦен, Номенклатура = &Номенклатура) КАК ЦеныНоменклатурыСрезПоследних
	|		ПО (ЦеныНоменклатурыСрезПоследних.ТипЦен = ТипыЦен.Ссылка)
	|ГДЕ
	|	НЕ ТипыЦен.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ТипыЦен.Наименование");
		
	Запрос.УстановитьПараметр("Номенклатура", Номенклатура);
	Запрос.УстановитьПараметр("ДатаЦен", ДатаЦен);
	
	Выборка = Запрос.Выполнить().Выбрать();
	ТаблицаЦен.Очистить();
	
	Пока Выборка.Следующий() Цикл
	
		СтрокаЦен = ТаблицаЦен.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаЦен, Выборка);
		
		Если НЕ ЗначениеЗаполнено(СтрокаЦен.Валюта) Тогда
			СтрокаЦен.Валюта = Константы.ОсновнаяВалюта.Получить()
		КонецЕсли; 
		
		Если СтрокаЦен.ТипЦен = ОсновнойТипЦен Тогда
			Цена 			= СтрокаЦен.Цена;
			ВалютаЦены   	= СтрокаЦен.Валюта;
			
		ИначеЕсли СтрокаЦен.ТипЦен = Справочники.ТипыЦен.Себестоимость Тогда
			Себестоимость 		= СтрокаЦен.Цена;
			
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

Процедура ЗаписатьЦены()

	//Для каждого СтрокаЦен Из ТаблицаЦен Цикл
	//	
	//	Если СтрокаЦен.ДатаИзменения <> ДатаЦен Тогда
	//		Продолжить;
	//	КонецЕсли; 
	//	
	//	РегистрЦены = РегистрыСведений.ЦеныНоменклатуры.СоздатьМенеджерЗаписи();
	//	РегистрЦены.Номенклатура	= Номенклатура;
	//	РегистрЦены.Период	= СтрокаЦен.ДатаИзменения;
	//	РегистрЦены.ТипЦен	= СтрокаЦен.ТипЦен;
	//	РегистрЦены.Цена	= СтрокаЦен.Цена;
	//	РегистрЦены.Валюта  = СтрокаЦен.Валюта;
	//	Попытка
	//		РегистрЦены.Записать();
	//	Исключение
	//		Сообщить(ОписаниеОшибки());
	//	КонецПопытки;
	//	
	//КонецЦикла; 

КонецПроцедуры
 
Процедура УстановитьЦенуВТаблице(ТипЦен, ИмяЦены, Значение)

	СтрокаЦен = ТаблицаЦен.Найти(ТипЦен, "ТипЦен");
	Если СтрокаЦен <> Неопределено Тогда
		СтрокаЦен[ИмяЦены] = Значение;
		СтрокаЦен.ДатаИзменения = ДатаЦен;
	КонецЕсли; 
	
КонецПроцедуры
 
Процедура ПриИзмененииВариантНаличия()
	
	Если ВариантНаличияВПродаже = Перечисления.ВариантыНаличияВПродаже.Сложный Тогда
		ЭлементыФормы.ДействующиеРасписания.Видимость = истина;
		//ЭлементыФормы.ЕстьВпродаже.Видимость = ложь;
		
	Иначе		
		ЭлементыФормы.ДействующиеРасписания.Видимость = ложь;
		//ЭлементыФормы.ЕстьВпродаже.Видимость = истина;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	УправлениеРИБ.ПередОткрытиемЭлементаСправочника(ЭтотОбъект, ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ЭлементыФормы.стрВладелец.Заголовок = ""+Владелец;
	
	Если ЭтоНовый() Тогда
		Если ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
		Иначе
			Если ЗначениеЗаполнено(Родитель) Тогда
				ЕдиницаИзмерения= Родитель.ЕдиницаИзмерения;
				Категория		= Родитель.Категория;
				ГруппаПечати	= Родитель.ГруппаПечати;
				Если Родитель.ЭтоГруппаЕдиниц Тогда
					Наименование  = Родитель.Наименование;
					ДопИнформация = Родитель.ДопИнформация;
				КонецЕсли;
			Иначе
				ЕдиницаИзмерения=Константы.ОсновнаяЕдиницаИзмерения.Получить();
				Категория       =Константы.ОсновнаяКатегорияТоваров.Получить();
			КонецЕсли;
			
			ЕстьВПродаже  = Истина;
			ВариантПечати = 511;	// все колонки
			КратностьКоличества=1;
			
			Если глВерсия=3 Тогда
				Тип = Перечисления.ТипыТоваров.Товар;
			КонецЕсли; 
			
		КонецЕсли; 
		
		Изображение = Неопределено;
	КонецЕсли; 
	
	ОсновнойТипЦен	= ИнтерфейсАдмина.ПолучитьОсновнойТипЦен();
	ДатаЦен			= ТекущаяДата();
	ПрочитатьЦены( ?(ЗначениеЗаполнено(ПараметрОбъектКопирования), ПараметрОбъектКопирования, Ссылка) );
	
	ИнтерфейсАдмина.ЗаполнитьСписокЧтоПечататьВСчете(СписокКолонкиПечати, ВариантПечати);
	
	СписокВыбора = ЭлементыФормы.ВариантНаличияВПродаже.СписокВыбора;
	СписокВыбора.Добавить(Перечисления.ВариантыНаличияВПродаже.Простой);
	СписокВыбора.Добавить(Перечисления.ВариантыНаличияВПродаже.Сложный);
	
	ПриИзмененииВариантНаличия();
	
	СправочникСписокШтрихКоды.Отбор.Товар.Установить(Ссылка);
	
	Если НЕ Изображение.Пустая() Тогда
		ЭлементыФормы.Изображение.Картинка = Изображение.Хранилище.Получить();
	КонецЕсли; 
	
	Если глВерсия=1 ИЛИ НЕ Константы.ДопЯзыки.Получить() Тогда
		ЭлементыФормы.ПанельОсновная.Страницы.ДопНаименования.Видимость = Ложь;
	Иначе
		Если НЕ ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
			ИнтерфейсАдмина.ЗаполнитьДопНаименования(Ссылка,ТаблицаДопНаименования);
		Иначе
			ИнтерфейсАдмина.ЗаполнитьДопНаименования(ПараметрОбъектКопирования,ТаблицаДопНаименования);
		КонецЕсли;
	КонецЕсли;
	
	Если глВерсия<3 Тогда
		ЭлементыФормы.Тип.Видимость = Ложь;
		ЭлементыФормы.НадписьТип.Видимость = Ложь;
	КонецЕсли; 
	
	Попытка
		ЭлементыФормы.ПанельОсновная.ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы[ВосстановитьЗначение("ТекущаяСтраницаТовары")];
	Исключение
	КонецПопытки;
	
	ИнтерфейсАдмина.ЗаполнитьПодменюВыбораОтчетов(ЭтотОбъект, ЭлементыФормы.ДействияФормы.Кнопки.ПодменюОтчеты);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	СохранитьЗначение("ТекущаяСтраницаТовары", ЭлементыФормы.ПанельОсновная.ТекущаяСтраница.Имя);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	ВариантПечати = ИнтерфейсАдмина.СписокПометокВЧисло(СписокКолонкиПечати);
	
	Если глВерсия>1 Тогда
		Если НЕ ЗначениеЗаполнено(ЭтотОбъект.ГруппаСпецифик) Тогда
			ЭтотОбъект.МинУдельныйВес = 0;
			ЭтотОбъект.МаксУдельныйВес = 0;
		ИначеЕсли ЭтотОбъект.МаксУдельныйВес < ЭтотОбъект.МинУдельныйВес Тогда
			ЭтотОбъект.МаксУдельныйВес = ЭтотОбъект.МинУдельныйВес
		КонецЕсли;
	КонецЕсли; 
	
	Если глВерсия=3 Тогда
		Если ЭтотОбъект.Тип=Перечисления.ТипыТоваров.Тариф Тогда
			ОтдельнойСтрокой = Истина;
			Разделитель = Ложь;
		Иначе
			Тариф = Неопределено;
		КонецЕсли; 
		
	КонецЕсли; 
	
	Если Разделитель Тогда
		ЗапросКоличества = Ложь;
		КратностьКоличества = 1;
	КонецЕсли; 
	
	//СпецификиТипЭкранаГостя = стандарт - 1;
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ИнтерфейсАдмина.ЗаписатьДопНаименования(Ссылка,ТаблицаДопНаименования);
	
	Если НЕ(глВерсия=3 И ЭтотОбъект.Тип=Перечисления.ТипыТоваров.Тариф) Тогда
		ЗаписатьЦены();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПослеЗаписи()
	
	СправочникСписокШтрихКоды.Отбор.Товар.Установить(Ссылка);
	ДействующиеРасписания.Отбор.Объект.Установить(Ссылка);	
КонецПроцедуры

Процедура ОбработкаВыбора(ЗначениеВыбора, Источник)
	
	Если ТипЗнч(ЗначениеВыбора) = Тип("СправочникСсылка.ХранилищеДополнительнойИнформации") Тогда
		Если НЕ Изображение = ЗначениеВыбора Тогда
			Изображение = ЗначениеВыбора;
		КонецЕсли;
		
		ЭлементыФормы.Изображение.Картинка = Изображение.Хранилище.Получить();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭтоТариф	 = глВерсия=3 И ЭтотОбъект.Тип=Перечисления.ТипыТоваров.Тариф;
	
	ЭлементыФормы.ПанельОсновная.Страницы.Цены		.Видимость = НЕ ЭтоТариф И ТаблицаЦен.Количество()>2;
	
	ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.ТекущаяСтраница;
	
	Если ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.Основное Тогда
		
		Если ЭтоТариф Тогда
			ЭлементыФормы.ПанельЦенаТариф.ТекущаяСтраница = ЭлементыФормы.ПанельЦенаТариф.Страницы.Тариф;
		Иначе
			ЭлементыФормы.ПанельЦенаТариф.ТекущаяСтраница = ЭлементыФормы.ПанельЦенаТариф.Страницы.Цена;
		КонецЕсли; 
		
		Флаг = ЗначениеЗаполнено(Номенклатура);
		ЭлементыФормы.НадписьКоэфПересчета.Доступность	= Флаг;
		ЭлементыФормы.КоэфПересчета.Доступность			= Флаг;
		Если Флаг И ЗначениеЗаполнено(ЕдиницаИзмерения) Тогда
			ЭлементыФормы.ИнфНадписьКоэффициент.Заголовок = ЕдиницаИзмерения.Наименование+" = "+КоэфПересчета+" * "+Номенклатура.БазоваяЕдиницаИзмерения;
		Иначе
			ЭлементыФормы.ИнфНадписьКоэффициент.Заголовок = "";
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = ЭлементыФормы.ПанельОсновная.Страницы.ПараметрыДляЗаказа Тогда
		
		Если глВерсия>1 Тогда
			Флаг = ЗначениеЗаполнено(ЭтотОбъект.ГруппаСпецифик);
			ЭлементыФормы.НадписьМинУдельныйВес	.Доступность = Флаг;
			ЭлементыФормы.МинУдельныйВес		.Доступность = Флаг;
			ЭлементыФормы.МаксУдельныйВес		.Доступность = Флаг;
		КонецЕсли; 
		
		Если глВерсия=3 Тогда
			ЭлементыФормы.ПанельПараметрыПодбора.Видимость = ЭтотОбъект.Тип=Перечисления.ТипыТоваров.Товар;
		КонецЕсли; 
		
		Если ЭлементыФормы.ПанельПараметрыПодбора.Видимость Тогда
			ЭлементыФормы.ОтдельнойСтрокой			.Видимость = НЕ ЭтотОбъект.Разделитель;
			ЭлементыФормы.ЗапросКоличества			.Видимость = НЕ ЭтотОбъект.Разделитель;
			ЭлементыФормы.КратностьКоличества		.Видимость = НЕ ЭтотОбъект.Разделитель;
			ЭлементыФормы.НадписьКратностьКоличества.Видимость = НЕ ЭтотОбъект.Разделитель;
		КонецЕсли; 
				
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
Процедура ВариантНаличияВПродажеПриИзменении(Элемент)
	
	ПриИзмененииВариантНаличия();
	
КонецПроцедуры

Процедура ВариантНаличияВПродажеОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ПанельОсновнаяПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ОбновлениеОтображения();
КонецПроцедуры

Процедура ИзображениеНажатие(Элемент)
	
	ХранилищеДополнительнойИнформации.ОткрытьФормуИзображения(ЭтаФорма, Изображение);
	
КонецПроцедуры

Процедура КоманднаяПанельКолонкиПечатиУстановитьФлажки(Кнопка)
	
	СписокКолонкиПечати.ЗаполнитьПометки(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельКолонкиПечатиСнятьФлажки(Кнопка)
	
	СписокКолонкиПечати.ЗаполнитьПометки(Ложь);
	
КонецПроцедуры

Процедура ШтрихКодыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, ЭтоГруппа)
	
	Отказ = Истина;
	
	Если ЭтоНовый() Тогда
		Предупреждение("Необходимо записать элемент!",5);
		Возврат;
	КонецЕсли;
	
	ФормаШК = Справочники.ШтрихКоды.ПолучитьФормуНовогоЭлемента(, Элемент);
	ФормаШК.Товар = Ссылка;
	ФормаШК.Открыть();
	
КонецПроцедуры

Процедура ШтрихКодыОбработкаЗаписиНовогоОбъекта(Элемент, Объект, СтандартнаяОбработка)
	
	Если Объект.Товар = Ссылка Тогда
		ЭлементыФормы.ШтрихКоды.ТекущаяСтрока = Объект;
	КонецЕсли; 
	
КонецПроцедуры

Процедура МинУдельныйВесПриИзменении(Элемент)
	
	Если ЭтотОбъект.МаксУдельныйВес < ЭтотОбъект.МинУдельныйВес Тогда
		ЭтотОбъект.МаксУдельныйВес = ЭтотОбъект.МинУдельныйВес
	КонецЕсли; 
	
КонецПроцедуры

Процедура МаксУдельныйВесПриИзменении(Элемент)
	
	Если ЭтотОбъект.МаксУдельныйВес < ЭтотОбъект.МинУдельныйВес Тогда
		ЭтотОбъект.МинУдельныйВес = ЭтотОбъект.МаксУдельныйВес
	КонецЕсли; 
	
КонецПроцедуры

Процедура СкидкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтерфейсАдмина.ВыборСкидкиБонуса(Элемент, Ложь);
	
КонецПроцедуры

Процедура БонусыНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтерфейсАдмина.ВыборСкидкиБонуса(Элемент, Истина);
	
КонецПроцедуры

Процедура ДатаЦенПриИзменении(Элемент)
	
	ПрочитатьЦены(Ссылка);
	
КонецПроцедуры

Процедура ЦенаПриИзменении(Элемент)
	
	УстановитьЦенуВТаблице(ОсновнойТипЦен, "Цена", Элемент.Значение);
	
КонецПроцедуры


Процедура СебестоимостьПриИзменении(Элемент)
	
	УстановитьЦенуВТаблице(Справочники.ТипыЦен.Себестоимость, "Цена", Элемент.Значение);
	
КонецПроцедуры

Процедура ТаблицаЦенПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаЦен = Элемент.ТекущаяСтрока;
	СтрокаЦен.ДатаИзменения = ДатаЦен;
	
	Если СтрокаЦен.ТипЦен = ОсновнойТипЦен Тогда
		Цена 			= СтрокаЦен.Цена;
		ВалютаЦены   	= СтрокаЦен.Валюта;
		
	ИначеЕсли СтрокаЦен.ТипЦен = Справочники.ТипыЦен.Себестоимость Тогда
		Себестоимость 		= СтрокаЦен.Цена;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаЦенПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.ТипЦен = ОсновнойТипЦен Тогда
		ОформлениеСтроки.Шрифт = Новый Шрифт(,,Истина);	// жирный
		
	ИначеЕсли ДанныеСтроки.ТипЦен = Справочники.ТипыЦен.Себестоимость Тогда
		ОформлениеСтроки.ЦветТекста = Новый Цвет(153,51,0);		// бардовый
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНДНОЙ ПАНЕЛИ ФОРМЫ

// Процедура назначается динамически
// Процедура вызывается при выборе пункта подменю ПодменюОтчеты командной панели
// формы. Процедура отрабатывает выбор печатной формы.
// Подключение данной процедуры-обработчика выполняется из кода конфигурации
//
Процедура ДействияФормыДействиеВыбратьОтчет(Кнопка) 
	
	Если Кнопка <> Неопределено Тогда // найти новое значение вида операции
		СписокОтчетов = ПолучитьСписокОтчетов();
		СтрокаОтчетаВСписке = СписокОтчетов.НайтиПоЗначению(Кнопка.Имя);
		Если СтрокаОтчетаВСписке <> Неопределено Тогда
			СформироватьОтчет(СтрокаОтчетаВСписке.Значение, ЭтотОбъект);
		Иначе
			СсылкаНаОтчет = Справочники.ВнешниеОбработки.НайтиПоКоду(СтрЗаменить(Кнопка.Имя, "ВнешнийОтчет_", ""));
			
			Если СсылкаНаОтчет <> Неопределено Тогда
				СформироватьОтчет(СсылкаНаОтчет, ЭтотОбъект);
			КонецЕсли;
			
		КонецЕсли;		
		
	КонецЕсли;
	
КонецПроцедуры

Процедура НоменклатураПриИзменении(Элемент)
	КодСУП = Номенклатура.КодСУП;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОСНОВНОЕ ТЕЛО МОДУЛЯ

ДействующиеРасписания.Отбор.Объект.Установить(Ссылка);