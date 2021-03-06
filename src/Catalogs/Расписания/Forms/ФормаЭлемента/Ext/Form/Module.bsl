﻿#Если Не ТонкийКлиент Тогда
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
		
	Для Инд = 1 По Перечисления.ДниНедели.Количество() Цикл
		
		ДеньНедели = Перечисления.ДниНедели[Инд-1];
		Если Объект.ДниНедели.НайтиСтроки(Новый Структура("ДеньНедели", ДеньНедели)).Количество()=0 Тогда
		
			ДН = Объект.ДниНедели.Добавить();
			Дн.Действует = Истина;
			Дн.ДеньНедели = ДеньНедели;
	
		
		КонецЕсли; 
	КонецЦикла;
		
КонецПроцедуры

&НаКлиенте
Процедура ДниНеделиПриАктивизацииСтроки(Элемент)
	ОбновитьОбластьДействияИнтервалов();	
КонецПроцедуры

&НаКлиенте
Процедура ДниНеделиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьОбластьДействияИнтервалов();	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьОбластьДействияИнтервалов()
	
	Если фСохранитьИнтервалы Тогда СохранитьИнтервалы() КонецЕсли;
	
	ТекДень=Перечисления.ДниНедели.ПустаяСсылка();
	нОбластьДействияИнтервалов = ОбластьДействияИнтервалов;
	
	Если Объект.ПоДнямНедели Тогда		
		стрДень = нрег(Элементы.ДниНедели.ТекущиеДанные.ДеньНедели);
		Если Прав(стрДень,1) = "а" Тогда
			стрДень = Лев(стрДень,СтрДлина(стрДень)-1) + "у";
		КонецЕсли; 
		нОбластьДействияИнтервалов = "На " + стрДень;
		ТекДень =  Элементы.ДниНедели.ТекущиеДанные.ДеньНедели;
	Иначе                                                                        		
		нОбластьДействияИнтервалов = "По всем дням недели";                       		
	КонецЕсли; 
	
	
	Если Не нОбластьДействияИнтервалов = ОбластьДействияИнтервалов Тогда
		
		ОбластьДействияИнтервалов = нОбластьДействияИнтервалов;
		ЗаполнитьИнтервалы();
	
	КонецЕсли; 
КонецПроцедуры 

Процедура СохранитьИнтервалы()
	Если фСохранитьИнтервалы Тогда
	
		МС = Объект.ПериодыАктивности.НайтиСтроки(Новый Структура("ДеньНедели",ТекДень));
		Для каждого Т Из МС Цикл
		
			Объект.ПериодыАктивности.Удалить(Т);
		
		КонецЦикла; 
		
		Для каждого Т Из СписокИнтервалов Цикл
		
			Нов = Объект.ПериодыАктивности.Добавить();
			ЗаполнитьЗначенияСвойств(Нов, Т.Значение);
			Нов.ДеньНедели = ТекДень;
			
		КонецЦикла; 	
		
	КонецЕсли; 
	фСохранитьИнтервалы = Ложь;
КонецПроцедуры 

Процедура ЗаполнитьИнтервалы()
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ПериодыАктивности.ВремяНач,
	|	ПериодыАктивности.ВремяКон,
	|	ПериодыАктивности.ДеньНедели
	|ПОМЕСТИТЬ ТЧ
	|ИЗ
	|	&ТЧ КАК ПериодыАктивности
	|ГДЕ
	|	ПериодыАктивности.ДеньНедели = &ДеньНедели
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТЧ.ВремяНач,
	|	ТЧ.ВремяКон,
	|	ТЧ.ДеньНедели
	|ИЗ
	|	ТЧ КАК ТЧ");
	Запрос.УстановитьПараметр("ДеньНедели", ТекДень);
	Запрос.УстановитьПараметр("ТЧ", Объект.ПериодыАктивности.Выгрузить());
	
	СписокИнтервалов.Очистить();
	Выб = Запрос.Выполнить().Выбрать();
	Пока Выб.Следующий() Цикл
	
		Интервал = Новый Структура("ВремяКон,ВремяНач");
		ЗаполнитьЗначенияСвойств(Интервал,Выб);
		СписокИнтервалов.Добавить(Интервал, ПредставлениеИнтервала(Интервал));
	
	КонецЦикла; 
	
	Если Не СписокИнтервалов.Количество() Тогда
	
		СписокИнтервалов.Добавить(ВесьДень, "Весь день");	
	
	КонецЕсли; 
	
КонецПроцедуры  

&НаКлиентеНаСервереБезКонтекста
Функция ПредставлениеИнтервала(Интервал)
	
	Представление = "";
	
	//Если ЗначениеЗаполнено(Интервал.ВремяНач) Тогда
		
	Представление = "с " + Формат(Интервал.ВремяНач,"ДФ=HH:mm") + " ";
		
	//КонецЕсли; 
	
	Если ЗначениеЗаполнено(Интервал.ВремяКон) Тогда
		
		Представление = Представление + "по " + Формат(Интервал.ВремяКон,"ДФ=HH:mm");
		
	КонецЕсли; 
	
	Если Интервал.ВремяНач = НачалоДня(Интервал.ВремяНач) И Минута(Интервал.ВремяКон) = 59 И Час(Интервал.ВремяКон) = 23 Тогда
		
		Представление = "Весь день";
		
	КонецЕсли;
	
	Возврат Представление;
КонецФункции

&НаКлиенте
Процедура СписокИнтерваловПередНачаломИзменения(Элемент, Отказ)
	Отказ = Истина;
	Интервал = Элементы.СписокИнтервалов.ТекущиеДанные.Значение;
	Интервал = ОткрытьФормуМодально("Справочник.Расписания.Форма.ВводИнтервала", Интервал);
	
	Если НЕ Интервал = Неопределено Тогда
		Эл = СписокИнтервалов.НайтиПоЗначению(Элементы.СписокИнтервалов.ТекущиеДанные.Значение);
		Эл.Значение = Интервал;
		Эл.Представление = ПредставлениеИнтервала(Интервал);
		ПодключитьОбработчикОжидания("СвернутьИнтервалы",0.1,Истина);
		фСохранитьИнтервалы = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокИнтерваловПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
	Интервал = Новый Структура("ВремяКон,ВремяНач");	
	Интервал = ОткрытьФормуМодально("Справочник.Расписания.Форма.ВводИнтервала",Интервал);
	Если НЕ Интервал = Неопределено Тогда
		СписокИнтервалов.Добавить(Интервал,ПредставлениеИнтервала(Интервал));
		ПодключитьОбработчикОжидания("СвернутьИнтервалы",0.1,Истина);
		фСохранитьИнтервалы = Истина;
	КонецЕсли; 
КонецПроцедуры

&НаКлиенте
Процедура СвернутьИнтервалы() Экспорт
	
	ТЗ = Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("ВремяНач");
	ТЗ.Колонки.Добавить("ВремяКон");
	МассивРасписаниеДня = СписокИнтервалов.ВыгрузитьЗначения();
	Для каждого Т Из МассивРасписаниеДня Цикл
	
		Если Т.ВремяНач = Т.ВремяКон Тогда
		
			Продолжить;	
		
		КонецЕсли; 
		ЗаполнитьЗначенияСвойств(ТЗ.Добавить(),Т);
	КонецЦикла; 
	
	ТЗ.Сортировать("ВремяНач");
	
	М = Новый Массив;
	Для каждого Т Из ТЗ Цикл
		
		Инд = ТЗ.Индекс(Т);
		Если Инд = ТЗ.Количество()-1 Тогда
		
			Прервать;
		
		КонецЕсли; 
		
		
		Если Т.ВремяКон >= ТЗ[Инд+1].ВремяНач Тогда
			
			ТЗ[Инд+1].ВремяНач = Мин(Т.ВремяНач,ТЗ[Инд+1].ВремяНач);
			ТЗ[Инд+1].ВремяКон = Макс(Т.ВремяКон,ТЗ[Инд+1].ВремяКон);
			
			М.Добавить(Т);
		КонецЕсли; 
		
	
	КонецЦикла; 
	Для каждого Т Из М Цикл
	
		ТЗ.Удалить(Т);
	
	КонецЦикла; 
	
	МассивРасписаниеДня.Очистить();
	Для каждого Т Из ТЗ Цикл
		
		Зн = Новый Структура("ВремяКон,ВремяНач");
		ЗаполнитьЗначенияСвойств(Зн,Т);
		МассивРасписаниеДня.Добавить(Зн);
	
	КонецЦикла; 
	СписокИнтервалов.ЗагрузитьЗначения(МассивРасписаниеДня);
	
	Для каждого Т Из СписокИнтервалов Цикл
	
		Т.Представление = ПредставлениеИнтервала(Т.Значение);	
	
	КонецЦикла; 
	
	Если Не СписокИнтервалов.Количество() Тогда
	
		СписокИнтервалов.Добавить(ВесьДень, "Весь день");
	
	КонецЕсли; 
	
	КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СохранитьИнтервалы();
КонецПроцедуры

&НаКлиенте
Процедура ПоДнямНеделиПриИзменении(Элемент)
	ОбновитьОбластьДействияИнтервалов();
КонецПроцедуры

ВесьДень = Новый Структура("ВремяНач,ВремяКон", Дата(1,1,2),Дата(1,1,1,23,59,00));
#КонецЕсли
