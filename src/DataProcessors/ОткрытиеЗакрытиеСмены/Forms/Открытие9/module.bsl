﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

Перем ЭтоОткрытиеСмены;			// может быть открытие новой смены или изменение состава в уже открытой
Перем ОткрытиеСменыВыполнено;
Перем МассивПейджеров;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ глПараметрыРМ.ККМЕсть Тогда
		Текст1="Нет доступа!";
		Текст2="Открыть смену можно только на кассовом месте...";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ФирмыРМ = глПараметрыРМ.ФирмыРМ;
	
	Для каждого Фирма из ФирмыРМ Цикл
		
		ТекСмена = ИнтерфейсРМ.ТекущаяСменаЗапрос(Фирма.МестоРеализации);
		
		Если ЗначениеЗаполнено(ТекСмена) Тогда
			ДокОткрытияСмены = ТекСмена.ПолучитьОбъект();
			
			Для каждого СтрокаСостава Из ДокОткрытияСмены.СоставСмены Цикл
				ДобавитьСотрудника( СтрокаСостава.Сотрудник, Истина );
			КонецЦикла; 
			
		Иначе
			
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	ОткрытиеСмены.Ссылка КАК Закрытие
			|ИЗ
			|	Документ.ОткрытиеСмены КАК ОткрытиеСмены
			|ГДЕ
			|	ОткрытиеСмены.МестоРеализации = &МестоРеализации
			|	И НАЧАЛОПЕРИОДА(ОткрытиеСмены.Дата, ДЕНЬ) = &Дата");	
			
			Запрос.УстановитьПараметр("МестоРеализации", Фирма.МестоРеализации);
			Запрос.УстановитьПараметр("Дата", НачалоДня(ТекущаяДатаНаСервере()));
			
			Рез = Запрос.Выполнить();
			Если Рез.Пустой() Тогда
				
			Иначе
				ИнтерфейсРМ.ВопросПредупреждение("Ошибка","Ошибка открытия смены", "В текущей календарной дате по " + глПараметрыРМ.МестоРеализации  + "
				|уже открывалась смена!","","ОК","");
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			ДокОткрытияСмены = Документы.ОткрытиеСмены.СоздатьДокумент();
			ДокОткрытияСмены.Дата = ТекущаяДата();
			ДокОткрытияСмены.УстановитьНовыйНомер();
			ДокОткрытияСмены.МестоРеализации = Фирма.МестоРеализации;
			
			// чтобы было что блокировать, надо сразу записать документ
			Если НЕ ИнтерфейсРМ.ПопыткаДействияСОбъектом( ДокОткрытияСмены, "Объект.Записать()" ) Тогда
				Отказ = Истина;
				Возврат;
			КонецЕсли; 
			
			ЭтоОткрытиеСмены = Истина;
			
		КонецЕсли; 
		
		Если НЕ ЗаблокироватьОткрытиеСмены() Тогда
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если глПараметрыРМ.НеОткрыватьДиалогОткрытиеСмены И НЕ ЗначениеЗаполнено(ТекСмена) Тогда  // только если первый раз открываем
			Если глПараметрыРМ.РежимПодбораСотрудниковВСмену = 0 Тогда // сотрудники
				ПодборСотрудников();
				ОтменаОткрытия = Истина;
			Иначе                                                      // бригады
				ОтменаОткрытия = НЕ ПодборБригад(Истина);
			КонецЕсли; 
			
			Если НЕ ЗначениеЗаполнено(ТаблицаСотрудников) И ОтменаОткрытия Тогда
				ДокОткрытияСмены.Удалить();
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
			ОткрытьСмену();
			ДокОткрытияСмены.Разблокировать();
			
			Отказ = Истина;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	ЭлементыФормы.тЗаголовок		.Заголовок = "Открытие смены № "+ДокОткрытияСмены.Номер;
	ЭлементыФормы.тДатаОткрытия		.Заголовок = "Время открытия: "+ДокОткрытияСмены.Дата;
	ЭлементыФормы.тМестоРеализации	.Заголовок = Фирма.МестоРеализации;
	
	
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если ЭтоОткрытиеСмены И НЕ ОткрытиеСменыВыполнено Тогда
		ДокОткрытияСмены.Удалить();
	Иначе
		ДокОткрытияСмены.Разблокировать();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	глОтсечкаПростоя();
	ТекущийЭлемент = ЭлементыФормы.ТаблицаСотрудников;
	
	ЭлементыФормы.тКолвоСотрудников.Заголовок = "Сотрудников: "+Формат(ТаблицаСотрудников.Количество(),"ЧН=");
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если НЕ ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	_Знач = ОбработкаВнешнихСобытий.ПолучитьДанные(Источник,Событие,Данные);
	Если НЕ ЗначениеЗаполнено(_Знач) Тогда
		Возврат;
	КонецЕсли;
	
	ТипПривязки = Новый ОписаниеТипов("СправочникСсылка.Сотрудники");
	ФлагПовтора = Ложь;
	Сотрудник = ИнтерфейсРМ.ИдентификацияПоКарте("Идентификатор_"+_Знач, ТипПривязки);
	
	Если ЗначениеЗаполнено(Сотрудник) И ТаблицаСотрудников.Найти(Сотрудник,"Сотрудник") = Неопределено Тогда
		ДобавитьСотрудника(Сотрудник);
	КонецЕсли; 
	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ТаблицаСотрудниковВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ОбработкаВыбораСотрудника(ВыбраннаяСтрока.Сотрудник);	
	
КонецПроцедуры

Процедура КнопкаВнесениеНажатие(Элемент)
	
	ОформитьВнесениеВыплату("Внесение");
	
КонецПроцедуры

Процедура КнопкаХотчетНажатие(Элемент)
	ТаблицаДействий = глПараметрыРМ.ДействияПриОткрытииСмены;
	ЕстьХОтчет =  ТаблицаДействий.Найти("ОтчетККМ_X","Действие");
	Если ЕстьХОтчет <> Неопределено Тогда
		Текст1 = "Снятие Х-отчета";
		Текст2 ="Снятие Х-отчета есть в списке автоматических действий при открытии смены.
		|Продолжить?";
		Ответ=ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"ОК",,"Esc=Отмена");
		Если Ответ = "Отмена"  Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ИнтерфейсРМ.ОтчетККМ("X");
	
КонецПроцедуры


Процедура КнопкаПодборСоставаНажатие(Элемент)
	
	ПодборСотрудников();
	
КонецПроцедуры

Процедура КнопкаПодборБригадНажатие(Элемент)
	
	Если глПараметрыРМ.ДействияПриОткрытииСмены.Найти("ОткрытиеСмены","Действие") = Неопределено Тогда
		Текст1="Нет доступа!";
		Текст2="Открытие и изменение состава смены не доступно на данном рабочем месте...";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат;
	Иначе
		ПодборБригад();
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаОКНажатие(Элемент)
	
	ОткрытьСмену();
	//глПараметрыРМ.Вставить("НомерСмены", ИнтерфейсРМ.ТекущаяСмена().Номер);
	Если ЭтаФорма.Открыта() Тогда
		Закрыть();
	КонецЕсли; 
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

Функция ПодборСотрудников()
	
	Если глПараметрыРМ.ДействияПриОткрытииСмены.Найти("ОткрытиеСмены","Действие") = Неопределено Тогда
		Текст1="Нет доступа!";
		Текст2="Открытие и изменение состава смены не доступно на данном рабочем месте...";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат Ложь;
	Иначе
	    ПолучитьФорму("ПодборСотрудников").ОткрытьМодально();
	КонецЕсли;
	
КонецФункции

Функция ПодборБригад(БезОткрытия=Ложь) 
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.БригадыСотрудников ГДЕ НЕ ПометкаУдаления");
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если БезОткрытия И Выборка.Количество() = 1 Тогда  // бригада одна, ее и добавим
		Выборка.Следующий();
		ДобавитьБригаду(Выборка.Ссылка);
		Возврат Истина;
	КонецЕсли;
	
	СписокБригад = Новый Массив;
	Пока Выборка.Следующий() Цикл
		СписокБригад.Добавить(Выборка.Ссылка);
	КонецЦикла; 
	
	СписокБригад = ИнтерфейсРМ.ВыборИзСписка(СписокБригад,Истина,МассивБригад);
	Если СписокБригад = Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТаблицаСотрудников.Очистить();
	Для Каждого Бригада ИЗ СписокБригад Цикл
		ДобавитьБригаду(Бригада);
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

Процедура ОткрытьСмену()

	НачатьТранзакцию();
	
	Если ЭтоОткрытиеСмены И НЕ ДействияПриОткрытииЗакрытииСмены("ПриОткрытииСмены", 0) Тогда
		ОтменитьТранзакцию();
		Возврат;
	КонецЕсли;
		
	ТаблицаДействий = глПараметрыРМ.ДействияПриОткрытииСмены;
	СтрокаДействий =  ТаблицаДействий.Найти(2,"Когда");
	Если СтрокаДействий <> Неопределено Тогда
		
		Если СтрокаДействий.Запрос Тогда
			Текст1 = "Открытие смены";
			Текст2 ="Выполнить следующее действие?
					|"+СтрокаДействий.Наименование;
			Ответ=ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"ОК","Пропуск","Esc=Отмена");
			
			Если Ответ="Отмена" Тогда
				ОтменитьТранзакцию();
				Возврат;
			ИначеЕсли Ответ="Пропуск" Тогда
				ОткрытиеСменыВыполнено = Ложь;
			Иначе
				ДокОткрытияСмены.СоставСмены.Загрузить(ТаблицаСотрудников.Выгрузить());
				
				Если НЕ ИнтерфейсРМ.ПопыткаДействияСОбъектом( ДокОткрытияСмены, "Объект.Записать()" ) Тогда
					ОтменитьТранзакцию();
					Возврат;
				КонецЕсли;
				ОткрытиеСменыВыполнено = Истина;
			КонецЕсли;
		Иначе
			ДокОткрытияСмены.СоставСмены.Загрузить(ТаблицаСотрудников.Выгрузить());
			
			Если НЕ ИнтерфейсРМ.ПопыткаДействияСОбъектом( ДокОткрытияСмены, "Объект.Записать()" ) Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
			ОткрытиеСменыВыполнено = Истина;
       	КонецЕсли;
		
		Если ЭтоОткрытиеСмены И ОткрытиеСменыВыполнено Тогда
			Если НЕ ДействияПриОткрытииЗакрытииСмены("ПриОткрытииСмены", 1) Тогда
				ОтменитьТранзакцию();
				Возврат;
			КонецЕсли;
			
			ИнтерфейсРМ.ЗаписьСобытия(Справочники.События.РежимАдминаОткрытиеСмены, ДокОткрытияСмены.Ссылка, ДокОткрытияСмены.Номер);
			
		КонецЕсли; 
		
	Иначе
		ОткрытиеСменыВыполнено = Ложь;
	КонецЕсли;
	
	Если ОткрытиеСменыВыполнено Тогда
		МенеджерЗаписи = РегистрыСведений.ТекущиеСмены.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.МестоРеализации = ДокОткрытияСмены.МестоРеализации;//глПараметрыРМ.МестоРеализации;
		МенеджерЗаписи.Смена = ДокОткрытияСмены.Ссылка;
		Если НЕ ИнтерфейсРМ.ПопыткаДействияСОбъектом( МенеджерЗаписи, "Объект.Записать()" ) Тогда
			ОтменитьТранзакцию();
			Возврат;
		КонецЕсли;
		
		ЗаписатьВыходНаРаботу();
		
	КонецЕсли; 
	
	ЗафиксироватьТранзакцию();
	
	Оповестить("ИзменениеСмены");

КонецПроцедуры
 
Процедура ЗаписатьВыходНаРаботу()

	Если глВерсия = 1 Тогда
		Возврат;
	КонецЕсли; 
	
	Если НЕ глПараметрыРМ.УчетРВАвтоПриходПоСмене Тогда
		Возврат;
	КонецЕсли; 
	
	// отмечаем выход добавленных сотрудиков
	Для Каждого СтрокаТС Из ТаблицаСотрудников Цикл
		Если НЕ УчетРабочегоВремени.СотрудникНаРаботе(СтрокаТС.Сотрудник) Тогда
			УчетРабочегоВремени.ОтметитьПриходУход(Истина, СтрокаТС.Сотрудник,,Истина);
		КонецЕсли;
	КонецЦикла;
	
	// отмечаем уход удаленных сотрудников
	Для каждого Сотрудник Из МассивУдаленных Цикл
		Если УчетРабочегоВремени.СотрудникНаРаботе(СтрокаТС.Сотрудник) Тогда
			УчетРабочегоВремени.ОтметитьПриходУход(Ложь, СтрокаТС.Сотрудник,,Истина);
		КонецЕсли;
	КонецЦикла; 
	
КонецПроцедуры




Процедура ЗаполнитьМассивПейджеров()
	
	МассивПейджеров = Новый Массив;
	Если глВерсия = 1 Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.ТорговоеОборудование
							|ГДЕ НЕ ПометкаУдаления И КодВида = &КодВида
							|");
	Запрос.УстановитьПараметр("КодВида", "Пейджер");
	
	МассивПейджеров = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
КонецПроцедуры

 
////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

ЭтоОткрытиеСмены = Ложь;
ОткрытиеСменыВыполнено = Ложь;
