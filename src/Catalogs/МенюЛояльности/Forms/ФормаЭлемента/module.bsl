﻿Перем ИдетФормированиеЭлементовФормы;
Перем ОтступПоВертикали, ОтступПоГоризонтали;
Перем КолКнопокВширину, КолКнопокВвысоту;
Перем ШрифтКнопки;
Перем ШиринаВнутр, ВысотаВнутр;
Перем ОтступМеждуКнопками;


Процедура ОпределитьРазмерВнутреннейОбласти()
	Выб = Справочники.ГруппыМенюЛояльности.Выбрать(,,,"Код");
	Пока Выб.Следующий() Цикл
		Если Выб.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		Элементы = ЭлементыМеню.НайтиСтроки(Новый Структура("Группа", Выб.Ссылка));
		Если Элементы.Количество() Тогда
			Страница = Панель.Страницы.Добавить("Страница" + Выб.Код,Выб.Наименование);
			Страница.КартинкаЗаголовка = БиблиотекаКартинок.ДляЗакладокМеню;
		КонецЕсли;		
	КонецЦикла;
	
	Кнопка = ЭлементыФормы.Добавить(Тип("Кнопка"), "КнопкаВоВесьРазмер",,Панель);
	Кнопка.Верх = 0;
	Кнопка.Лево = 0;
	//:Кнопка = ЭлементыФормы[0];
	Кнопка.Ширина = 1200;
	Кнопка.Высота = 1400;
	
	ШиринаВнутр = Кнопка.Ширина;
	ВысотаВнутр = Кнопка.Высота;
	ЭлементыФормы.Удалить(Кнопка);
КонецПроцедуры

Процедура СоздатьЭлементыФормы() Экспорт
	УстановкаПараметров();
	ИдетФормированиеЭлементовФормы = Истина;
	СтраницаБыла = Панель.ТекущаяСтраница.Имя;
	Для Каждого Элемент Из ЭлементыФормы Цикл
		ЭлементыФормы.Удалить(Элемент);
	КонецЦикла;
	
	Панель.Страницы.Очистить();
	
	ОпределитьРазмерВнутреннейОбласти();
	Выб = Справочники.ГруппыМенюЛояльности.Выбрать(,,,"Код");
	Пока Выб.Следующий() Цикл
		Если Выб.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		Элементы = ЭлементыМеню.НайтиСтроки(Новый Структура("Группа", Выб.Ссылка));
		Если Элементы.Количество() Тогда
			Страница = Панель.Страницы["Страница" + Выб.Код];
			Страница.КартинкаЗаголовка = БиблиотекаКартинок.ДляЗакладокМеню;
			Панель.ТекущаяСтраница = Страница;
			ШиринаКнопки = (ШиринаВнутр) / (КолКнопокВширину) - ОтступПоГоризонтали;
			ВысотаКнопки = (ВысотаВнутр) / (КолКнопокВвысоту) - ОтступПоВертикали;
			
			
			Для Каждого Элемент Из Элементы Цикл
				Индекс = Элементы.Найти(Элемент);
				Кнопка = ЭлементыФормы.Добавить(Тип("Кнопка"), "Кнопка" + Элемент.НомерСтроки,1,Панель);
				ИндексВерх = Цел(Индекс/КолКнопокВширину);
				Кнопка.Верх = ИндексВерх * ВысотаКнопки + ОтступМеждуКнопками*ИндексВерх + ОтступМеждуКнопками;
				Кнопка.Ширина = ШиринаКнопки;
				Кнопка.Высота = ВысотаКнопки;
				
				Кнопка.Лево = (Индекс%КолКнопокВширину) * ШиринаКнопки + ОтступМеждуКнопками * (Индекс%КолКнопокВширину) + ОтступМеждуКнопками;				
				Кнопка.Заголовок = Элемент.ТекстКнопки;
				
				
				//:Кнопка = Новый Кнопка;
				Кнопка.МногострочныйРежим = Истина;
				Кнопка.Шрифт = ШрифтКнопки;
				Кнопка.УстановитьДействие("Нажатие", Новый Действие("КнопкаМенюНажатие"));	
			КонецЦикла;
		КонецЕсли;		
	КонецЦикла;
	
	Панель.Страницы.Добавить("Х","Выход");
	
	Если Панель.Страницы.Количество() > 1 Тогда
		Панель.Страницы.Удалить(Панель.Страницы[0]);
		Панель.ТекущаяСтраница = Панель.Страницы[1];
	КонецЕсли;
	
	Если ЗначениеЗаполнено(СтраницаБыла) Тогда
		СтраницаБыла = Панель.Страницы.Найти(СтраницаБыла);
		Если СтраницаБыла <> Неопределено и СтраницаБыла.Имя <> "Х"  Тогда
			Панель.ТекущаяСтраница = СтраницаБыла;
		КонецЕсли;
	КонецЕсли;
	
	ПодключитьОбработчикОжидания("Сброс_идетФормирование",0.1,1);	
КонецПроцедуры

Процедура Сброс_идетФормирование() Экспорт
	ИдетФормированиеЭлементовФормы = ложь;
КонецПроцедуры


Процедура ПриОткрытии()
	Если ЗначениеЗаполнено(глРабочееМесто) Тогда
		АвтоЗаголовок = Ложь;
		Заголовок = "КеГеЛьБУМ";
		РазрешитьЗакрытие = Ложь;
		ПодключитьОбработчикОжидания("СоздатьЭлементыФормы",0.1,1);
	КонецЕсли;
КонецПроцедуры



Процедура КнопкаМенюНажатие(Элемент)
	Если Не ЗначениеЗаполнено(глПараметрыРМ) Тогда
		Возврат;
	КонецЕсли;
	ИмяКнопки = СтрЗаменить(Элемент.Имя,"Кнопка","");
	СтрокаЭлементМеню = ЭлементыМеню.Получить(Число(ИмяКнопки)-1);
	
	Если СтрокаЭлементМеню.Действие = Справочники.ДействияЭлементовМеню.ДобавитьТовар Тогда
		ВыбТовар = ИнтерфейсРМ.НайтиТоварПоКоду(СтрокаЭлементМеню.КодСУПтовара);
		Закрыть(ВыбТовар);
	Иначе
		Закрыть(СтрокаЭлементМеню.Действие);
	КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Модифицированность = Ложь;
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	Модифицированность = Ложь;
КонецПроцедуры

Процедура ПриСменеСтраницы(Элемент, ТекущаяСтраница) Экспорт
	Если ИдетФормированиеЭлементовФормы Тогда  
		Возврат;
	КонецЕсли;
	Если ТекущаяСтраница = Элемент.СТраницы.Количество()-1 Тогда
		Если Открыта() Тогда
			Закрыть();
		КонецЕсли;
		
	КонецЕсли;
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ИОЭ = ПолучитьИнформациюЭкрановКлиента();
	Ширина = Мин(ИОЭ[0].Ширина, 1024) - 30;
	Высота = Мин(ИОЭ[0].Высота, 786) - 80;
	
КонецПроцедуры

//СоздатьЭлементыФормы();

Процедура УстановкаПараметров() Экспорт
	КолКнопокВширину = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Ссылка, "Количество кнопок по горизонтали");
	КолКнопокВширину = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Ссылка, "Количество кнопок по горизонтали");
	РазмерШрифта     = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Ссылка, "Размер шрифта");
	
	Если КолКнопокВширину = Неопределено Тогда
		КолКнопокВширину = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Неопределено, "Количество кнопок по горизонтали");
	КонецЕсли;
	
	Если КолКнопокВвысоту = Неопределено Тогда
		КолКнопокВвысоту = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Неопределено, "Количество кнопок по вертикали");
	КонецЕсли;
	
	Если РазмерШрифта = Неопределено Тогда
		РазмерШрифта = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Неопределено, "Размер шрифта");
	КонецЕсли;
	
	ИдетФормированиеЭлементовФормы = Истина;
	ОтступПоГоризонтали = 12; 
	ОтступПоВертикали = 10;
	Если КолКнопокВширину = Неопределено Тогда
		КолКнопокВширину = 4;
	КонецЕсли;
	
	Если КолКнопокВвысоту = Неопределено Тогда
		КолКнопокВвысоту = 4;
	КонецЕсли;
	
	Если РазмерШрифта = Неопределено Тогда
		РазмерШрифта = 14;
	КонецЕсли;
	ОтступМеждуКнопками = 10;
	
	
	ШрифтКнопки = Новый Шрифт(Панель.Шрифт, "Segoe UI", РазмерШрифта,0);
КонецПроцедуры

