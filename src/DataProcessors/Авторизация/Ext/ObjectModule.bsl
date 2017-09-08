﻿
#Если Клиент Тогда

Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

Перем ТипЗначения	Экспорт;   // тип значения
Перем Длина			Экспорт;   // длина
Перем Точность		Экспорт;   // точность
Перем Кратность		Экспорт;   // кратность
Перем РежимПароля   Экспорт;

Перем ТипПоляВвода	Экспорт;
Перем ФлагОткрытия	Экспорт;
Перем ФлагДроби		Экспорт;
Перем ДробнаяЧасть	Экспорт;

Перем ЗапретОтмены Экспорт;
Перем ПервоеОткрытие Экспорт;

Перем ФормаВвода;

// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
	ФлагОткрытия	= Ложь;
	ЗапретОтмены 	= Ложь;
	ИнтерфейсРМ.ВыводНаДП("Ожидание");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

// Вызывается из обработчика ПередОткрытием форм этой обработки,
// выполняет инициализацию рабочего места
//
Процедура ДействияПередОткрытиемФормы(ТекущаяФорма, Отказ) Экспорт
	
	ФормаВвода = ТекущаяФорма;
	
	Если ТипЗначения = "Пароль" Тогда
		ТипЗначения		= "Строка";
		РежимПароля = Истина;
		Длина			= ?(ЗначениеЗаполнено(Длина),Длина,4);
		ЗначениеВвода	= "";
		ФормаВвода.ЭлементыФормы.ЗначениеВвода.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		ФормаВвода.ЭлементыФормы.ЗначениеВвода.Шрифт = Новый Шрифт(ФормаВвода.ЭлементыФормы.ЗначениеВвода.Шрифт,72);
		//ФормаВвода.ЭлементыФормы.ЗначениеВвода.РежимПароля = Истина;
	Иначе
		РежимПароля = Ложь;
	КонецЕсли; 
	
	Если ТипЗначения = "Строка" Тогда
		ТипПоляВвода = ПолучитьОписаниеТиповСтроки( Длина );
	Иначе
		ТипПоляВвода = ПолучитьОписаниеТиповЧисла( Длина, Точность, Истина );
	КонецЕсли; 
	
	//ФормаВвода.ЭлементыФормы.ЗначениеВвода.ОграничениеТипа = ТипПоляВвода;
	ЗначениеВвода = ТипПоляВвода.ПривестиЗначение(ЗначениеВвода);
	Если РежимПароля Тогда
		стрЗначениеВвода = "▫▫▫▫";
	Иначе
		стрЗначениеВвода = Формат(ЗначениеВвода, "ЧРД=.; ЧГ=0");
	КонецЕсли;
	

	
	ФлагОткрытия	= Истина;
	ФлагДроби		= Ложь;
	ДробнаяЧасть	= 0.1;	
	
		
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные) Экспорт 
	
	Если НЕ ФормаВвода.ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
	_Знач = ОбработкаВнешнихСобытий.ПолучитьДанные(Источник,Событие,Данные);
	Если НЕ ЗначениеЗаполнено(_Знач) Тогда
		Возврат;
	КонецЕсли;
	
	ТипПривязки = Новый ОписаниеТипов("СправочникСсылка.Сотрудники");
	ФлагПовтора = Ложь;
	Сотрудник = ИнтерфейсРМ.ИдентификацияПоКарте("Идентификатор_"+_Знач, ТипПривязки, ФлагПовтора, , Истина);
	
	Если ЗначениеЗаполнено(Сотрудник) Тогда
		ФормаВвода.Закрыть(Сотрудник.КодДоступа);
	Иначе
		ФормаВвода.ПодключитьОбработчикОжидания("ВыводОшибки_Ожидание", 0.5, Истина);	
		//ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Карта доступа", "Карта доступа не привязана ни к одному сотруднику!","","ОК","", , , 5);
	КонецЕсли; 
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура Сброс() Экспорт
	
	ФлагДроби		= Ложь;
	ДробнаяЧасть	= 0.1;
	ЗначениеВвода	= ТипПоляВвода.ПривестиЗначение();
	стрЗначениеВвода = "▫▫▫▫";
	глОтсечкаПростоя();
	
КонецПроцедуры

Процедура НажатиеКнопки(СтрКнопки) Экспорт
	
		
	Если ФлагОткрытия Тогда
		Сброс();
		ФлагОткрытия = Ложь;
	КонецЕсли;
	
	Если ЗначениеВвода = Неопределено Тогда
		ЗначениеВвода = ?(ТипЗначения="Число", 0, "");
	КонецЕсли;
	
	НовЗнач = ЗначениеВвода;
	
	Если ТипЗначения="Строка" Тогда
		НовЗнач = НовЗнач + СтрКнопки;
		
	ИначеЕсли НЕ ФлагДроби ИЛИ Точность=0 Тогда
		НовЗнач = НовЗнач * ?(СтрКнопки="00",100,10) + Число(СтрКнопки);	
		
	Иначе
		НовЗнач = НовЗнач + Число(СтрКнопки) * ДробнаяЧасть;
		ДробнаяЧасть = ДробнаяЧасть * 0.1;
		
	КонецЕсли;
	
	Если ТипПоляВвода.ПривестиЗначение(НовЗнач) = НовЗнач Тогда
		ЗначениеВвода = НовЗнач;
	КонецЕсли;
	Если РежимПароля Тогда
		стрЗначениеВвода = СокрЛП(ЗначениеВвода);
		стрЗначениеВвода = лев("▪▪▪▪▪▪▪▪▪▪",СтрДлина(стрЗначениеВвода)) + лев("▫▫▫▫▫▫▫▫▫▫", Длина-СтрДлина(стрЗначениеВвода));
	Иначе
		стрЗначениеВвода = Формат(ЗначениеВвода, "ЧРД=.; ЧГ=0");
	КонецЕсли;
		
	Если Длина = СтрДлина(ЗначениеВвода) И РежимПароля Тогда
		ОК();
	КонецЕсли;
	
	глОтсечкаПростоя();
	
КонецПроцедуры

Процедура Точка() Экспорт
	
	Если ФлагОткрытия Тогда
		Сброс();
		ФлагОткрытия = Ложь;
	КонецЕсли;
	
	ФлагДроби = Истина;
	Если не стрНайти(стрЗначениеВвода,".") Тогда
		стрЗначениеВвода = стрЗначениеВвода + ".";
	КонецЕсли;
	
	
КонецПроцедуры
 
Процедура ОК() Экспорт
	
	Если ТипЗначения="Число" И Кратность>0 Тогда
		
		ПровЗнач = ЗначениеВвода / Кратность;
		Если Цел(ПровЗнач)<>ПровЗнач Тогда
			
			Текст1="Ошибка ввода";
			Текст2="Значение должно быть кратно "+Кратность+" !";
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2, "", "ОК", "");
			
			ФлагОткрытия = Истина;	
			ФормаВвода.ТекущийЭлемент = ФормаВвода.ЭлементыФормы.ЗначениеВвода;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеВвода = "9999" Тогда
		ФормаВвода.Закрыть("ВыходОС");
	ИначеЕсли ЗначениеЗаполнено(ЗначениеВвода) Тогда
		ФормаВвода.Закрыть( ЗначениеВвода );	
	КонецЕсли;
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);


#КонецЕсли
РежимПароля = Ложь;
ПервоеОткрытие = Истина;