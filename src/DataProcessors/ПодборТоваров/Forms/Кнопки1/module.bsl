﻿
////////////////////////////////////////////////////////////////////////////////
// ПРОЧЕЕ

Процедура ПоказатьКурс() Экспорт
	
	Кнопки = ЭлементыФормы.КоманднаяПанель.Кнопки;
	
	Если глВерсия>1 И Константы.РаботаСПодтверждениямиПозицийЗаказа.Получить() И НЕ ВызовИзСтопЛиста И глПараметрыРМ.ЗаказИспользоватьКурсы И НЕ ВладелецФормы.Доставка Тогда
		Кнопки.Курс.Текст = ВладелецФормы.ТекущаяПодача.Номер;
	Иначе
		Кнопки.Удалить( Кнопки.Курс );
	КонецЕсли;
	
КонецПроцедуры

// Вызывается из модуля обработки после вывода кнопок
//
Процедура УстановитьВидимостьСтрелок(НужнаСтрелкаВверх, НужнаСтрелкаВниз) Экспорт
	
	Кнопки = ЭлементыФормы.КоманднаяПанельСтрелки.Кнопки;
	Кнопки.Вверх.Доступность = НужнаСтрелкаВверх;
	Кнопки.Вниз.Доступность  = НужнаСтрелкаВниз;
	
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	КнопкиДействияПередОткрытием(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если РежимНастройки Тогда
		ЭлементыФормы.КоманднаяПанель.Доступность = Ложь;
		Возврат;
	КонецЕсли;
	
	ПоказатьДозаказ();
	ПоказатьКурс();
	
	Если глВерсия=1 ИЛИ ВызовИзСтопЛиста Тогда
		Кнопки = ЭлементыФормы.КоманднаяПанель.Кнопки;
		Кнопки.Удалить( Кнопки.Специфика );
		Кнопки.Удалить( Кнопки.ОбщСпецифика );
	КонецЕсли;
	
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	Если РежимНастройки Тогда
		Если ПараметрыНастройки.РучнаяНастройкаПривязок Тогда
			ВладелецФормы.НастройкаДеревоКаталога = ДеревоКаталога;
		КонецЕсли; 
		
	Иначе
		ВладелецФормы.ПриЗакрытииМеню();	// это обязательно сначала
		ИнтерфейсРМ.ПриЗакрытииОкна();
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ОповещениеДозаказа(ИмяСобытия, Параметр, Источник);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Назначается динамически
//
Процедура КнопкаТовараНажатие(Элемент)
	
	ОбработкаНажатияКнопки(Элемент);
	
КонецПроцедуры
 
Процедура КнопкаУдалитьНажатие(Элемент)
	
	Если Дозаказ.Количество()>0 Тогда
		ВладелецФормы.УдалитьСтроку(,Истина);
	КонецЕсли; 
	
КонецПроцедуры

Процедура КнопкаКурсНажатие(Элемент)
	
	Если Дозаказ.Количество()>0 Тогда
		ВладелецФормы.ИзменитьКурс();
		ПоказатьКурс();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КнопкаСпецификаНажатие(Элемент)
	
	Если Дозаказ.Количество()>0 Тогда
		ВладелецФормы.ВыборСпецифики();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельОбщСпецифика(Кнопка)
	Если Дозаказ.Количество()>0 Тогда
		ВладелецФормы.ВыборСпецифики(Истина);
	КонецЕсли; 
КонецПроцедуры

Процедура КнопкаСтрелкаВверхНажатие(Элемент)
	
	Пролистать(-1);
	
КонецПроцедуры

Процедура КнопкаСтрелкаВнизНажатие(Элемент)
	
	Пролистать(1);
	
КонецПроцедуры

Процедура КнопкаВыборМенюНажатие(Элемент)
	
	ВыборМеню();
	
КонецПроцедуры

Процедура КнопкаПодсказкаНажатие(Элемент)
	
	РежимПодсказки = НЕ РежимПодсказки;
	Элемент.Пометка = РежимПодсказки;
	
	Если НЕ РежимНастройки Тогда
		ПоказатьДозаказ(РежимПодсказки);
	КонецЕсли; 
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ
