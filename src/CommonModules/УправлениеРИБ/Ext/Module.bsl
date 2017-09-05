﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ДИАЛОГАМИ В РИБ
#Если НЕ ТонкийКлиент Тогда
#Если Клиент Тогда

	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С КОНСТАНТАМИ В РИБ

// Процедура выполняется при открытии формы констант.
//
// Параметры:
//  Форма - форма констант.
//
Процедура ПриОткрытииФормыКонстант(Форма) Экспорт
	
	Если ПланыОбмена.ГлавныйУзел() = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Форма.ТолькоПросмотр = Истина;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ СО СПРАВОЧНИКАМИ В РИБ

// <Описание функции>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
// Возвращаемое значение:
//   <Тип.Вид>   - <описание возвращаемого значения>
//
Функция ВедениеСправочников() Экспорт
	
	Если глВерсия=1 Тогда
		Возврат Истина;
	КонецЕсли; 
	
	ИБВедениеСправочников = Константы.ИБВедениеСправочников.Получить();
	
	Возврат НЕ ЗначениеЗаполнено(ИБВедениеСправочников) ИЛИ ПараметрыСеанса.ТекущаяИБ = ИБВедениеСправочников;
	
КонецФункции
 
// Процедура выполняется при открытии справочников.
// Устанавливает признак "Только просмотр" у формы, если справочник есть в списке справочников для просмотра,
// Отказывает в открытии, если справочник если элемент новый.
//
// Параметры:
// 
// Объект               - объект справочника,
// Форма                - форма элемента справочника,
// Отказ                - отказ в открытии формы,
// СтандартнаяОбработка - стандартная обработка открытия формы.
//
Процедура ПередОткрытиемЭлементаСправочника(Объект, Форма, Отказ, СтандартнаяОбработка) Экспорт
	
	Если Не ВедениеСправочников() Тогда
		
		Если Объект.ЭтоНовый() Тогда
			ВыдатьПредупреждение("Элемент можно завести только в ИБ с признаком ведения справочников.");
		Иначе
			ВыдатьПредупреждение("Элемент редактируется только в ИБ с признаком ведения справочников.");			
		КонецЕсли;
		
		Если Объект.ЭтоНовый() Тогда
			Отказ = Истина;
		Иначе
			Форма.ТолькоПросмотр = Истина;
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры      

// Процедура выполняется при открытии формы списка справочника.
//
Процедура ПриОткрытииСпискаСправочника(Форма) Экспорт
	
	Если Не ВедениеСправочников() Тогда
		
		Форма.ТолькоПросмотр = Истина;
		
		Если Форма.ЭлементыФормы.Найти("СправочникСписок") <> Неопределено Тогда
			Форма.ЭлементыФормы.СправочникСписок.ТолькоПросмотр = Истина;
		КонецЕсли;
		
		Если Форма.ЭлементыФормы.Найти("СправочникДерево") <> Неопределено Тогда
			Форма.ЭлементыФормы.СправочникДерево.ТолькоПросмотр = Истина;
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры
	
// Определяет разрешено ли редактирование ШК на этой базе.
//
Функция РазрешеноРедактированиеШК(КлючЗаписи,Владелец) Экспорт
	
	// ДАЛИОНУМ - начало
	НаборЗаписей = РегистрыСведений.ШтрихКодыНоменклатуры.СоздатьНаборЗаписей();
	//НаборЗаписей.Отбор.Владелец.Установить(КлючЗаписи.Владелец);
	//НаборЗаписей.Отбор.ТипШтрихКода.Установить(КлючЗаписи.ТипШтрихКода);
	//НаборЗаписей.Отбор.ЕдиницаИзмерения.Установить(КлючЗаписи.ЕдиницаИзмерения);
	//НаборЗаписей.Отбор.ШтрихКод.Установить(КлючЗаписи.ШтрихКод);
	//НаборЗаписей.Прочитать();
	НаборЗаписей = РегистрыСведений.ШтрихКодыНоменклатуры.СоздатьНаборЗаписей();
	НаборЗаписей.Прочитать();
	ФормаНаборЗаписей = НаборЗаписей.ПолучитьФорму("ФормаНабораЗаписей");
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.Владелец.Значение = Владелец;
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.Владелец.Использование = Истина;
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.ТипШтрихКода.Значение = КлючЗаписи.ТипШтрихКода;
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.ТипШтрихКода.Использование = Истина;
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.ЕдиницаИзмерения.Значение = КлючЗаписи.ЕдиницаИзмерения;
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.ЕдиницаИзмерения.Использование = Истина;
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.ШтрихКод.Значение = "73453465";
	ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ОтборСтрок.ШтрихКод.Использование = Истина;
	ФормаНаборЗаписей.ОткрытьМодально();
	
	Если ФормаНаборЗаписей.ЭлементыФормы.РегистрСведенийНаборЗаписей.ТекущаяСтрока <> Неопределено Тогда
 
	
	//Если НаборЗаписей.Количество() > 0 Тогда
		КодУзла = НаборЗаписей[0].КодУзла;
	Иначе
		Возврат Истина;
	КонецЕсли;
		
	Если Не ВедениеСправочников() И ПланыОбмена.Основной.ЭтотУзел().Код <> КодУзла Тогда
		Возврат Ложь;
	Иначе
		// ДАЛИОНУМ - конец
		Возврат Истина;
		// ДАЛИОНУМ - начало
	КонецЕсли;         	
	// ДАЛИОНУМ - конец
	
КонецФункции


#КонецЕсли

// Устанавливает префикс у элемента, если справочник есть в списке справочников для префиксации.	
//
// Параметры:
// 
// Объект - объект справочника.
//
Процедура УстановитьПрефиксЭлементаСправочника(Объект, Префикс) Экспорт
	
	// ДАЛИОНУМ - начало
	Если Не ПараметрыСеанса.РаспределенныйРежим Тогда
		Возврат;
	КонецЕсли;
	
	СписокВидовСправочниковДляПрефиксации = Новый СписокЗначений;
	
	СписокВидовСправочниковДляПрефиксации.Добавить("БанковскиеСчета");
	СписокВидовСправочниковДляПрефиксации.Добавить("ВнешниеОбработки");
	СписокВидовСправочниковДляПрефиксации.Добавить("ДоговорыКонтрагентов");
	СписокВидовСправочниковДляПрефиксации.Добавить("ЕдиницыИзмерения");
	СписокВидовСправочниковДляПрефиксации.Добавить("ЗначенияСвойствОбъектов");
	СписокВидовСправочниковДляПрефиксации.Добавить("Кассы");
	СписокВидовСправочниковДляПрефиксации.Добавить("КатегорииОбъектов");
	СписокВидовСправочниковДляПрефиксации.Добавить("СтатьиЗатрат");
	СписокВидовСправочниковДляПрефиксации.Добавить("Спецификации");
	СписокВидовСправочниковДляПрефиксации.Добавить("ТорговоеОборудование");
	СписокВидовСправочниковДляПрефиксации.Добавить("СертификатыСоответствия");
	СписокВидовСправочниковДляПрефиксации.Добавить("ПроизводителиНоменклатуры");
	// ДАЛИОНУМ - начало
	СписокВидовСправочниковДляПрефиксации.Добавить("Клиенты");
	// ДАЛИОНУМ - конец
	
	ИмяСправочника = Объект.Метаданные().Имя;
	
	Если СписокВидовСправочниковДляПрефиксации.НайтиПоЗначению(ИмяСправочника) <> Неопределено Тогда
		Префикс = Префикс + ПараметрыСеанса.ПрефиксИБ;
	КонецЕсли;
	// ДАЛИОНУМ - конец
		
КонецПроцедуры

Процедура ЗарегистрироватьИзмененияСправочника(Объект) Экспорт
	
	Если Не ПараметрыСеанса.ТекущаяИБ.Предопределенный Тогда
		Объект.ОбменДанными.Получатели.Очистить();
		Возврат;
	КонецЕсли;

	Если НЕ ПараметрыСеанса.РаспределенныйРежим Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Метаданные.ПланыОбмена.Основной.Состав.Содержит(Объект.Метаданные()) Тогда
		Возврат;
	КонецЕсли;
	
	Если Объект.ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
		
	ОбщийСправочник = Истина;
	СписокМест = Новый СписокЗначений;
	
	Если ТипЗнч(Объект) = Тип("СправочникОбъект.РабочиеМеста") Тогда
		ОбщийСправочник = Ложь;
		СписокМест.Добавить(Объект.ИнформационнаяБаза);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.Товары") Тогда
		ОбщийСправочник = Ложь;
		//:Объект = Справочники.Товары.СоздатьЭлемент();
		ГруппаИБ = Объект.Владелец.ГруппаИнформационныхБазДляРепликации;
		Если ЗначениеЗаполнено(ГруппаИБ) И ЗначениеЗаполнено(Объект.Номенклатура) Тогда
			МассивИБ = Справочники.ГруппыИнформационныхБаз.ИБпоГруппе(ГруппаИБ);
			СписокМест.ЗагрузитьЗначения(МассивИБ);
			МассивУзлов = Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(ГруппаИБ);
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Номенклатура);			
			ПланыОбмена.ЗарегистрироватьИзменения(МассивУзлов, Объект.Ссылка);			
		КонецЕсли;		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.ТорговоеОборудование") Тогда
		ОбщийСправочник = Ложь;
		Если Объект.ИнформационнаяБаза.Пустая() Тогда
			Если ЗначениеЗаполнено(Объект.Регион) Тогда
				ИБпоРегиону = ИБпоРегиону(Объект.Регион);
				Для Каждого ИБ Из ИБпоРегиону Цикл
					СписокМест.Добавить(ИБ);
				КонецЦикла;
			Иначе
				
			КонецЕсли;
		Иначе
			СписокМест.Добавить(Объект.ИнформационнаяБаза);
		КонецЕсли;
		ОбщийСправочник = Ложь;
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.Фирмы") Тогда
		ОбщийСправочник = Ложь;
		СписокМест.Добавить(Объект.ИнформационнаяБаза);
		
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.КаталогиТоваров") Тогда
		//:Объект = Справочники.КаталогиТоваров.СоздатьЭлемент();;
		
		Если ЗначениеЗаполнено(Объект.ГруппаИнформационныхБазДляРепликации) Тогда
			ОбщийСправочник = Ложь;	
			
			Узлы = Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(Объект.ГруппаИнформационныхБазДляРепликации, Истина);
			Для Каждого Узел Из Узлы Цикл
				Объект.ОбменДанными.Получатели.Добавить(Узел);
				СписокМест.Добавить(Узел.ИнформационнаяБаза);
			КонецЦикла;	
		КонецЕсли;
	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.МенюЛояльности") Тогда
		//:Объект = Справочники.МенюЛояльности.СоздатьЭлемент();;
		ОбщийСправочник = Ложь;
		Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Фирмы.ИнформационнаяБаза КАК ИнформационнаяБаза
		|ИЗ
		|	Справочник.Фирмы КАК Фирмы
		|ГДЕ
		|	Фирмы.МестоРеализации = &МестоРеализации
		|	И Фирмы.ИнформационнаяБаза.Регион = &Регион");
		

		Запрос.УстановитьПараметр("МестоРеализации", Объект.МестоРеализации);
		Запрос.УстановитьПараметр("Регион", Объект.Регион);
		
		ИнформационныеБазы = Запрос.Выполнить().Выгрузить();
		
		Для Каждого ИнформационнаяБаза Из ИнформационныеБазы Цикл
			СписокМест.Добавить(ИнформационнаяБаза[0]);
		КонецЦикла;	

	ИначеЕсли ТипЗнч(Объект) = Тип("СправочникОбъект.ИнформационныеБазы") Тогда
		ОбщийСправочник = Ложь;
		СписокМест.Добавить(Объект.Ссылка);
	Иначе
		МетаданныеСправочника = Объект.Метаданные();
		Если МетаданныеСправочника.Реквизиты.Найти("ИнформационнаяБаза") <> Неопределено Тогда
			ОбщийСправочник = Ложь;
			СписокМест.Добавить(Объект.ИнформационнаяБаза);
		ИначеЕсли МетаданныеСправочника.Реквизиты.Найти("ИнформационнаяБазаГруппа") <> Неопределено Тогда
			ОбщийСправочник = Ложь;
			Если ТипЗнч(Объект.ИнформационнаяБазаГруппа) = Тип("СправочникСсылка.ИнформационныеБазы") Тогда
				СписокМест.Добавить(Объект.ИнформационнаяБазаГруппа);		
			ИначеЕсли ТипЗнч(Объект.ИнформационнаяБазаГруппа) = Тип("СправочникСсылка.ГруппыИнформационныхБаз") Тогда
				Узлы = Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(Объект.ИнформационнаяБазаГруппа, Истина);
				Для Каждого Узел Из Узлы Цикл
					Объект.ОбменДанными.Получатели.Добавить(Узел);
					СписокМест.Добавить(Узел.ИнформационнаяБаза);
				КонецЦикла;	
			ИначеЕсли Объект.ИнформационнаяБазаГруппа = Null Тогда
				Если ТипЗнч(Объект.Родитель.ИнформационнаяБазаГруппа) = Тип("СправочникСсылка.ИнформационныеБазы") Тогда
					СписокМест.Добавить(Объект.Родитель.ИнформационнаяБазаГруппа);		
				ИначеЕсли ТипЗнч(Объект.Родитель.ИнформационнаяБазаГруппа) = Тип("СправочникСсылка.ГруппыИнформационныхБаз") Тогда
					Узлы = Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(Объект.Родитель.ИнформационнаяБазаГруппа, Истина);
					Для Каждого Узел Из Узлы Цикл
						Объект.ОбменДанными.Получатели.Добавить(Узел);
						СписокМест.Добавить(Узел.ИнформационнаяБаза);
					КонецЦикла;	
					
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			Если ТипЗнч(Объект) = Тип("СправочникОбъект.Номенклатура") ИЛИ ТипЗнч(Объект) = Тип("СправочникОбъект.Специфики") ИЛИ ТипЗнч(Объект) = Тип("СправочникОбъект.Товары") Тогда
				ОбщийСправочник = Ложь;
				Узлы = Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(Справочники.ГруппыИнформационныхБаз.Рестораны, Истина);
				Для Каждого Ресторан Из Узлы Цикл
					Объект.ОбменДанными.Получатели.Добавить(Ресторан);
					СписокМест.Добавить(Ресторан.ИнформационнаяБаза);
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ОбщийСправочник Тогда
		Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
		Объект.ОбменДанными.Получатели.Очистить();
 		ПланыОбмена.УдалитьРегистрациюИзменений(Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(Справочники.ГруппыИнформационныхБаз.ВсеИБ, Истина),Объект.Ссылка);
		//ВыполнитьРегистрациюИзменений(Объект, СписокМест,Истина,Истина);		
		ВыполнитьРегистрациюИзменений(Объект, СписокМест);
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАБОТЫ С ДОКУМЕНТАМИ В РИБ

// Устанавливает префикс у документа.
//
Процедура УстановитьПрефиксДокумента(Префикс) Экспорт
	
	Если Не ПараметрыСеанса.РаспределенныйРежим Тогда
		Возврат;
	КонецЕсли;
	
	Префикс = Префикс + ПараметрыСеанса.ПрефиксИБ;
	
КонецПроцедуры

// Регистрирует изменения в РИБ в зависимости от вида документа.
//
Процедура ЗарегистрироватьИзмененияДокумента(Объект) Экспорт
	
	Если НЕ ПараметрыСеанса.РаспределенныйРежим Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Метаданные.ПланыОбмена.Основной.Состав.Содержит(Объект.Метаданные()) Тогда
		Возврат;
	КонецЕсли;
	
	// Из периферийной ИБ документ не должен попадать в центр
	Если ПланыОбмена.ГлавныйУзел() <> Неопределено  Тогда
		Возврат;
	КонецЕсли;	
	
	Объект.ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
	Объект.ОбменДанными.Получатели.Очистить();
	
	
	СписокИБ = Новый СписокЗначений;
	Если ТипЗнч(Объект) = Тип("ДокументОбъект.РеестрЦен") Тогда
		Объект.ОбменДанными.Получатели.Добавить(Объект.ТТ.ПолучитьОбъект().ПолучитьУзелРИБ());
	КонецЕсли;
	
КонецПроцедуры

// Выполняет регистрацию изменений объекта по данному торговому объекту.
//
// Параметры:
//  Объект                 - объект, для которого надо выполнить регистрацию.
//  СписокТорговыхОбъектов - список торговых объектов, для выбора узлов миграции,
//  ВыполнитьРегистрациюВПланеОбмена - выполнить регистрацию в плане обмена.
//
Процедура ВыполнитьРегистрациюИзменений(Объект, СписокМест, ОтменитьРегистрациюИзменений = Ложь, ВыполнитьРегистрациюВПланеОбмена = Ложь) Экспорт
	
	Получатели = Новый Массив;
	
	ПараметрыРИБ           = ПараметрыСеанса.ПараметрыРИБ.Получить();
	СоответствиеУзлов      = ПараметрыРИБ.СоответствиеУзлов;
	СписокЦентральныхУзлов = ПараметрыРИБ.СписокЦентральныхУзлов;
	Центр                  = ПараметрыРИБ.Центр;
	
	// Регистрация для нецентральных баз.
	Если Центр Тогда
		      		
		Для Каждого ЭлементСписка ИЗ СписокМест Цикл
			
			УзелПолучатель = Неопределено;
			Место = ЭлементСписка.Значение;
			Если ТипЗнч(Место) = Тип("СправочникСсылка.МестаРеализации") Тогда
				УзелПолучатель = СоответствиеУзлов[Место];
				
			ИначеЕсли ТипЗнч(Место) = Тип("СправочникСсылка.ИнформационныеБазы") Тогда
				УзелПолучатель = ПланыОбмена.Основной.НайтиПоРеквизиту("ИнформационнаяБаза", Место);
				
			КонецЕсли; 
			
			Если ЗначениеЗаполнено(УзелПолучатель) И УзелПолучатель <> Объект.ОбменДанными.Отправитель И УзелПолучатель <> ПланыОбмена.Основной.ЭтотУзел() Тогда
				Если ВыполнитьРегистрациюВПланеОбмена Тогда
					Получатели.Добавить(УзелПолучатель);
				ИначеЕсли ОтменитьРегистрациюИзменений Тогда
					Объект.ОбменДанными.Получатели.Удалить(УзелПолучатель);
				Иначе
					Объект.ОбменДанными.Получатели.Добавить(УзелПолучатель);  
				КонецЕсли;   
									
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Регистрация для центральных баз.
	Для Каждого Узел Из СписокЦентральныхУзлов Цикл
		
		Если Узел.Значение <> Объект.ОбменДанными.Отправитель Тогда
			Если ВыполнитьРегистрациюВПланеОбмена Тогда
				Получатели.Добавить(Узел.Значение);
			ИначеЕсли ОтменитьРегистрациюИзменений Тогда
				Объект.ОбменДанными.Получатели.Удалить(Узел.Значение);	
			Иначе
				Объект.ОбменДанными.Получатели.Добавить(Узел.Значение);
			КонецЕсли;
							
		КонецЕсли;
		
	КонецЦикла;
	
	Если ВыполнитьРегистрациюВПланеОбмена Тогда
		Если ОтменитьРегистрациюИзменений Тогда 
			ПланыОбмена.УдалитьРегистрациюИзменений(Получатели, Объект);
		Иначе	
			ПланыОбмена.ЗарегистрироватьИзменения(Получатели, Объект);
		КонецЕсли;
	КонецЕсли;
		
КонецПроцедуры

// Выполняет регистрацию изменений объекта по данному торговому объекту.
//
// Параметры:
//  Объект                 - объект, для которого надо выполнить регистрацию.
//  СписокТорговыхОбъектов - список торговых объектов, для выбора узлов миграции.
//
Процедура ВыполнитьРегистрациюИзмененийДляВсехУзлов(Объект) Экспорт
	#Если НЕ ТонкийКлиент Тогда
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отправитель", Объект.ОбменДанными.Отправитель);
	Запрос.УстановитьПараметр("ЭтотУзел"   , ПланыОбмена.Основной.ЭтотУзел());
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	Основной.Ссылка КАК Узел
	|ИЗ
	|	ПланОбмена.Основной КАК Основной
	|ГДЕ
	|	Основной.Ссылка <> &Отправитель
	|	И Основной.Ссылка <> &ЭтотУзел";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл  		
		Объект.ОбменДанными.Получатели.Добавить(Выборка.Узел);				
	КонецЦикла;
	#КонецЕсли
КонецПроцедуры
      
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УСТАНОВКИ И ПОЛУЧЕНИЯ ПАРАМЕТРОВ РИБ

// Устанавливает параметры РИБ.
//
Процедура УстановитьПараметрыРИБ() Экспорт
	
	Если ПараметрыСеанса.Версия=1 Тогда
		Возврат;
	КонецЕсли; 
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	прУстановитьПараметрыРИБ();
	#КонецЕсли
КонецПроцедуры

// Проверяет корректность параметров РИБ.
//
// Возвращаемое значение:
//  Истина - параметры корректны, ложь - нет.
//
Функция ПараметрыРИБКорректны() Экспорт
	
	//Если Не ЗначениеЗаполнено(ПараметрыСеанса.ТекущийТО) И ПланыОбмена.ГлавныйУзел() <> Неопределено Тогда
	//	Возврат Ложь;
	//КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Определяет, является ли текущая база центральной.
//
Функция ЭтоЦентр() Экспорт
	
	ПараметрыРИБ = ПараметрыСеанса.ПараметрыРИБ.Получить();
	
	Возврат ПараметрыРИБ.Центр;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// 

// Процедура производит обмен по списку настроек для обмена.
//
// Параметры:
//  МассивНастроекОбмена           - массив, содержащий настройки обмена.
//  РучнойРежимЗапуска             - признак ручного режима запуска.
//  ОбработкаАвтоОбменДанными      - объект обработки "АвтоОбменДанными".
//  ОбменПриВходеВПрограмму        - признак обмена при входе в программу (обмен при начале работы системы).
//  КоличествоПроизведенныхОбменов - содержит количество успешных обменов.
//
Процедура ПроизвестиСписокОбменовДанными(МассивНастроекОбмена, РучнойРежимЗапуска, ОбработкаАвтоОбменДанными,
	                                        ОбменПриВходеВПрограмму, КоличествоПроизведенныхОбменов) Экспорт
											
	КоличествоПроизведенныхОбменов = 0;											
											
	Для Каждого СсылкаОбмена Из МассивНастроекОбмена Цикл
		
		Если НЕ ЗначениеЗаполнено(СсылкаОбмена) Тогда
			Продолжить;
		КонецЕсли;
		
		ОбъектНастройки = СсылкаОбмена.ПолучитьОбъект();
		
		Если ОбъектНастройки = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		СтруктураНастроекОбмена = Новый Структура();
		СтруктураНастроекОбмена.Вставить("ДанныеНастройки", ОбъектНастройки);
		СтруктураНастроекОбмена.Вставить("РучнойРежимЗапуска", РучнойРежимЗапуска);
		СтруктураНастроекОбмена.Вставить("ОбработкаАвтоОбменДанными", ОбработкаАвтоОбменДанными);
		СтруктураНастроекОбмена.Вставить("ОбменПриВходеВПрограмму", ОбменПриВходеВПрограмму);
		СтруктураНастроекОбмена.Вставить("ПроизводитьЧтениеДанных", ОбъектНастройки.ПроизводитьПриемСообщений);
		СтруктураНастроекОбмена.Вставить("ПроизводитьЗаписьДанных", ОбъектНастройки.ПроизводитьОтправкуСообщений);
		СтруктураНастроекОбмена.Вставить("ПроизводитьОтправкуСообщенийПриУспешномПриеме", ОбъектНастройки.ПроизводитьОтправкуСообщенийПриУспешномПриеме);
		
		СтруктураНастроекОбмена.Вставить("ВывестиИнформациюОбОшибкеВОкноСообщений", РучнойРежимЗапуска ИЛИ ОбъектНастройки.ВыводитьСообщенияОбОшибкахПриАвтоматическомОбменеДанными);
		СтруктураНастроекОбмена.Вставить("ВывестиИнформациюВОкноСообщений", РучнойРежимЗапуска ИЛИ ОбъектНастройки.ВыводитьИнформационныеСообщенияПриАвтоматическомОбменеДанными);
		
		Если Не ПустаяСтрока(ОбъектНастройки.КаталогПроверкиДоступности) Тогда
			
			ДоступностьКаталога = ПроцедурыОбменаДанными.ПроверитьНаличиеКаталога(ОбъектНастройки.КаталогПроверкиДоступности);
			СтруктураНастроекОбмена.Вставить("ДоступностьКаталогаПроверки", ДоступностьКаталога);
			
		Иначе
			
			СтруктураНастроекОбмена.Вставить("ДоступностьКаталогаПроверки", Неопределено);
			
		КонецЕсли;
		
		ПроцедурыОбменаДанными.ПроизвестиОбменДаннымиПоНастройке(СтруктураНастроекОбмена);
		
		КоличествоПроизведенныхОбменов = КоличествоПроизведенныхОбменов + 1;
		
	КонецЦикла;
	
КонецПроцедуры 

Функция ИБпоРегиону(Регион) Экспорт
	#Если НЕ ТонкийКлиент Тогда
	Запрос = Новый Запрос("Выбрать Ссылка ИЗ Справочник.ИнформационныеБазы ГДЕ Регион = &Регион");
	Запрос.УстановитьПараметр("Регион", Регион);
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	#КонецЕсли

КонецФункции

&НаКлиенте
Функция ОткрытьФормуОчередиВыгрузкиПоОбъекту(Объект) Экспорт
	#Если Клиент Тогда
		ОткрытьФорму("Обработка.ВыгрузкаСправочниковНаТТ.Форма.ФормаУправляемая",Новый Структура("ОбъектДляВыгрузки", Объект));
	#КонецЕсли	
КонецФункции

#КонецЕсли
