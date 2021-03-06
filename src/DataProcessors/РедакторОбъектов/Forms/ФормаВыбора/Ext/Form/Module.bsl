﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если не Параметры.Свойство("КоллекцияОбъектовМетаданных") или не Параметры.Свойство("КоллекцияОбъектов") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если не ЗначениеЗаполнено(Параметры.КоллекцияОбъектовМетаданных) или не ЗначениеЗаполнено(Параметры.КоллекцияОбъектов) Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	КоллекцияОбъектовМетаданных = Параметры.КоллекцияОбъектовМетаданных;
	КоллекцияОбъектов = Параметры.КоллекцияОбъектов;
	
	/// реквизит формы
	
	НовыйДС = Новый РеквизитФормы("Список", Новый ОписаниеТипов("ДинамическийСписок"));
	МассивДобавленных = Новый Массив();
	МассивДобавленных.Добавить(НовыйДС);
	ИзменитьРеквизиты(МассивДобавленных);
	
	ЭтаФорма.Список.ОсновнаяТаблица = КоллекцияОбъектовМетаданных + "." + КоллекцияОбъектов;
	
	/// элемент формы
	
	ТаблицаФормы = Элементы.Добавить("ФормаСписок", Тип("ТаблицаФормы"), ЭтаФорма);
	ТаблицаФормы.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	ТаблицаФормы.ПутьКДанным = "Список";
	ТаблицаФормы.ПутьКДаннымКартинкиСтроки = "Список.СтандартнаяКартинка";
	ТаблицаФормы.УстановитьДействие("Выбор", "Выбор");
	ТаблицаФормы.МножественныйВыбор = Ложь;
	
	КолонкиТаблицы = Новый Массив();
	Если КоллекцияОбъектовМетаданных = "Документ" Тогда
		КолонкиТаблицы.Добавить("Дата");
		КолонкиТаблицы.Добавить("Номер");
	Иначе
		КолонкиТаблицы.Добавить("Код");
		КолонкиТаблицы.Добавить("Наименование");
	КонецЕсли;
	
	Для Каждого Колонка Из КолонкиТаблицы Цикл
		
		Если ЭтаФорма.Список.Отбор.ДоступныеПоляОтбора.Элементы.Найти(Колонка) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Элемент = Элементы.Добавить("Список" + Колонка, Тип("ПолеФормы"), ТаблицаФормы);
		Элемент.Заголовок = Колонка;
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = "Список." + Колонка;
		
	КонецЦикла;
	
	Для Каждого Колонка Из ЭтаФорма.Список.Отбор.ДоступныеПоляОтбора.Элементы Цикл
		
		Если Колонка.Папка Тогда
			Продолжить;
		КонецЕсли;
		
		ИмяПоля = Строка(Колонка.Поле);
		
		Если не КолонкиТаблицы.Найти(ИмяПоля) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Элемент = Элементы.Добавить("Список" + ИмяПоля, Тип("ПолеФормы"), ТаблицаФормы);
		Элемент.Заголовок = Колонка.Заголовок;
		Элемент.Вид = ВидПоляФормы.ПолеВвода;
		Элемент.ПутьКДанным = "Список." + ИмяПоля;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыборКоманда(Команда)
	
	Выбор(Неопределено, Неопределено, Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Выбор(ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Элементы.ФормаСписок.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ЭтаФорма.Закрыть(Элементы.ФормаСписок.ТекущаяСтрока);
	
КонецПроцедуры
