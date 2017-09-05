﻿#Если Клиент Тогда

#Область ОписаниеПеременных

Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

Перем ТипЗначения	Экспорт;   // тип значения
Перем Длина			Экспорт;   // длина
Перем Точность		Экспорт;   // точность
Перем Кратность		Экспорт;   // кратность

Перем ТипПоляВвода	Экспорт;
Перем ФлагОткрытия	Экспорт;
Перем ФлагДроби		Экспорт;
Перем ДробнаяЧасть	Экспорт;

Перем ФормаВвода;

Перем ТаблицаПоиска Экспорт;
Перем AutohotkeyDll Экспорт;

//Офлайн
Перем ГлавнаяФорма Экспорт;
Перем Вес Экспорт;
Перем ВесСтабилен Экспорт;

#КонецОбласти


#Область ПрограммныйИнтерфейс

Процедура ЗаполнитьТовары(Товары) Экспорт
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("РабочееМесто", глРабочееМесто);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаНаСервере());
	
	Запрос.Текст =
	"ВЫБРАТЬ ПЕРВЫЕ 15
	|	ВыбранныеТовары.Товар КАК Товар,
	|	ПРЕДСТАВЛЕНИЕ(ВыбранныеТовары.Товар) КАК Представление,
	|	ЦеныСрезПоследних.Цена КАК Цена,
	|	МАКСИМУМ(ШтрихКоды.ШтрихКод) КАК ШтрихКод,
	|	МАКСИМУМ(ШтрихКоды.ШтрихКод) КАК ШК
	|ИЗ
	|	РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекущаяДата, ТипЦен = ЗНАЧЕНИЕ(Справочник.ТипыЦен.Розничная)) КАК ЦеныСрезПоследних
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыбранныеТовары КАК ВыбранныеТовары
	|		ПО ЦеныСрезПоследних.Номенклатура = ВыбранныеТовары.Товар.Номенклатура
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШтрихКоды КАК ШтрихКоды
	|		ПО ЦеныСрезПоследних.Номенклатура = ШтрихКоды.Товар.Номенклатура
	|ГДЕ
	|	ВыбранныеТовары.РабочееМесто = &РабочееМесто
	|	И ВыбранныеТовары.Товар.ЕстьВПродаже
	|
	|СГРУППИРОВАТЬ ПО
	|	ВыбранныеТовары.Товар,
	|	ЦеныСрезПоследних.Цена,
	|	ВыбранныеТовары.ДатаВыбора
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВыбранныеТовары.ДатаВыбора УБЫВ";
	ТЗ = Запрос.Выполнить().Выгрузить();
	Для Каждого Т Из ТЗ Цикл
		ЗаполнитьЗначенияСвойств(Товары.Добавить(), Т);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытий

// Вызывается из обработчика ПередОткрытием форм этой обработки,
// выполняет инициализацию рабочего места
//
Процедура ДействияПередОткрытиемФормы(ТекущаяФорма, Отказ) Экспорт
	
	ФормаВвода = ТекущаяФорма;
	
	ТипПоляВвода = ПолучитьОписаниеТиповСтроки( 12 );
	
	ФормаВвода.ЭлементыФормы.ЗначениеВвода.ОграничениеТипа = ТипПоляВвода;
	ФормаВвода.ЭлементыФормы.ЗначениеВвода.Значение = ТипПоляВвода.ПривестиЗначение(ЗначениеВвода);
	
	Вес = 0;
	ВесСтабилен = Ложь;
	
	//Офлайн
	Если глПараметрыРМ.ФайловаяИБ Тогда
		
		ГлавнаяФорма.ТолькоПросмотр = Истина;
		
		ФормаВвода.РазрешитьЗакрытие = Ложь;
		ФормаВвода.СпособОтображенияОкна = ВариантСпособаОтображенияОкна.Максимизированное;
		ФормаВвода.ЭлементыФормы.Отмена.Доступность = Ложь;
		
		Действие = Новый Действие("КнопкаПечатьНажатиеОфлайн");
		ФормаВвода.ЭлементыФормы.ОК.УстановитьДействие("Нажатие", Действие);
		Действие = Новый Действие("тпТоварыВыборОфлайн");
		ФормаВвода.ЭлементыФормы.тпТовары.УстановитьДействие("Выбор", Действие);
		
		ОбновитьВес();
	КонецЕсли;
	
	ТаблицаПоиска = ОбщегоНазначенияПовтИсп.СформироватьТаблицуПоискаСПЛУ(Константы.ДатаОбновленияПризнакаНаличияВПродаже.Получить());
	
КонецПроцедуры

// Обработка внешних событий
//
Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные) Экспорт
	
	Если Источник = "NativeDraw" Тогда
		Возврат;
	КонецЕсли;
	
	Если Найти(Источник,"Штрих АС POS") <> 0 Тогда //"Штрих АС POS" Тогда
		ОбновитьВес();
	КонецЕсли;
	
КонецПроцедуры

#Область ОбработчикиСобытийФормы

Процедура Сброс() Экспорт
	
	ЗначениеВвода	= ТипПоляВвода.ПривестиЗначение();
	ФормаВвода.ОбновитьЗаголовок();
	
КонецПроцедуры

Процедура Точка() Экспорт
	
	Если ФлагОткрытия Тогда
		Сброс();
		ФлагОткрытия = Ложь;
	КонецЕсли;
	
КонецПроцедуры
 
Процедура ОК() Экспорт
	
	МЗ = РегистрыСведений.ВыбранныеТовары.СоздатьМенеджерЗаписи();
	МЗ.РабочееМесто = глРабочееМесто;
	МЗ.Товар = Товар;
	МЗ.ДатаВыбора = ТекущаяДатаНаСервере();
	МЗ.Записать(Истина);
	Результат = Новый Структура("Товар, ШК", Товар, ШК);
	ФормаВвода.Закрыть(Результат);
	
КонецПроцедуры


#Область Офлайн

Процедура Печать(Вес) Экспорт 
	
	МЗ = РегистрыСведений.ВыбранныеТовары.СоздатьМенеджерЗаписи();
	МЗ.РабочееМесто = глРабочееМесто;
	МЗ.Товар = Товар;
	МЗ.ДатаВыбора = ТекущаяДатаНаСервере();
	МЗ.Записать(Истина);
	
	Если ЗначениеЗаполнено(Товар) Тогда
		Если НЕ Товар.ЗапросКоличества Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Неверное количество", "Количество для данного товара не может быть дробным","","ОК","");	
			Возврат;
		КонецЕсли;
		Если НЕ ПустаяСтрока(глПараметрыРМ.ИмяПринтераВесы) Тогда
			ШКсВесом = ГлавнаяФорма.ОбработкаОбъект.ШтрихкодСВесом(ШК, Вес);
			ГлавнаяФорма.ОбработкаОбъект.НапечататьЦенник(Товар, ШКсВесом, Вес);
		КонецЕсли;
		ФормаВвода.ОтключитьОбработчикОжидания("Поиск");
		Сброс();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
	
КонецПроцедуры

Процедура ОбновитьВес() Экспорт
	Если глПараметрыРМ.ВесыЕсть Тогда
		Весы = глТорговоеОборудование.Scale1C;
		Весы.УдалитьСообщение();
		Весы.ПосылкаДанных = Истина;
		Вес = Весы.Вес;
		ВесСтабилен = НЕ Весы.ВесНеСтабилен;
		
		ФормаВвода.ЭлементыФормы.ОК.Доступность = Вес > 0 И ВесСтабилен;
		Если ВесСтабилен Тогда
			ФормаВвода.ЭлементыФормы.НадписьЗаголовок.ЦветФона = ЦветаСтиля.ЦветФонаОплаченнойСтроки;
		Иначе	
			ФормаВвода.ЭлементыФормы.НадписьЗаголовок.ЦветФона = ЦветаСтиля.ЦветНативногоЗаколовкаОкна;
		КонецЕсли;
		ФормаВвода.ОбновитьЗаголовок();
		ИнтерфейсРМ.ВыводНаИнфоДисплей("ПоказатьВес",,,,,Вес);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

#КонецОбласти


#Область Инициализация

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
Попытка
	AutohotkeyDll = РаботаСокнами.AHK(,"ПоискТовара");
Исключение
КонецПопытки;

#КонецОбласти


#КонецЕсли