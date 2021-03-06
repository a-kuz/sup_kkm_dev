﻿
Перем ТаблицаЗадания;
Перем Сотрудник;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(ОписаниеПрофиля) ТОгда
		Предупреждение("Данная обработка открывается только из справочника торгового оборудования!",5);
		Отказ = Истина;
		Возврат;  		
	КонецЕсли;   
	
	// заполнение списка COM портов
	Для н=1 По 24 Цикл
		ЭлементыФормы.PortNumber.СписокВыбора.Добавить(н, "COM"+н);
	КонецЦикла;
	
	// заполнение списка скоростей обмена
	СписокСкоростей = ЭлементыФормы.BaudRate.СписокВыбора;
	СписокСкоростей.Добавить(9600);
	СписокСкоростей.Добавить(19200);
	СписокСкоростей.Добавить(57600);
	СписокСкоростей.Добавить(115200);
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

// Сохранение параметров и закрытие формы
//
// Параметры
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>
//
Процедура ОсновныеДействияФормыОК(Кнопка)
	
	ЗаполнитьЗначенияСвойств(ПараметрыТО,ЭтотОбъект);
	
	Закрыть("ОК");
	
КонецПроцедуры

Процедура КнопкаПроверкаСвязиНажатие(Элемент)
	
	Если НЕ Подключить(Истина) Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
	Иначе 
		Предупреждение("ОК!",3);
		Отключить();
    КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаОбновитьВремяНажатие(Элемент)
	
	Если НЕ Подключить(Истина) Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
		Возврат;
	КонецЕсли;
	
	ДатаККМ = DRV.QueryEcrDateTime();
	ЭлементыФормы.тВремяККМ.Заголовок = Формат(ДатаККМ, "ДЛФ=ДВ");
	ЭлементыФормы.тВремяСистемы.Заголовок = Формат(ТекущаяДата(), "ДЛФ=ДВ");
	
	Отключить();
	
КонецПроцедуры

Процедура КнопкаСинхронизироватьВремяНажатие(Элемент)
	
	Текст2 = "Подтвердите системные дату, время:"+Символы.ПС+Формат(ТекущаяДата(),"ДЛФ=ДВ");
	Если Вопрос(Текст2,РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли;
	
	Парам = Новый Структура;
	Парам.Вставить("Пароль"					, Password);
	Парам.Вставить("ИгнорироватьОбщийПароль", Истина);
	
	ВыполнитьДействие("СинхронизироватьВремя", Парам);
	Если Результат.Ошибка Тогда
		Предупреждение(Результат.Описание + Символы.ПС + Результат.Подробно);
	КонецЕсли;
	
	КнопкаОбновитьВремяНажатие(Элемент);
	
КонецПроцедуры
