﻿
Перем КоличествоПосетителей;
Перем фПеренестиВсе;


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ МОДУЛЯ

// Изменение количества в текущей строке заказа
//
Процедура ИзменитьКоличество()
	
	СтрокаТовара = ЭлементыФормы.ТаблицаПереноса.ТекущаяСтрока;
	
	Если СтрокаТовара = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ИнтерфейсРМ.ЭтоТариф(СтрокаТовара.Товар)  Тогда
		Если СтрокаТовара.Перенести=0 Тогда
			СтрокаТовара.Перенести	= СтрокаТовара.Количество;
			СтрокаТовара.Остаток	= 0;
		Иначе
			СтрокаТовара.Перенести	= 0;
			СтрокаТовара.Остаток	= СтрокаТовара.Количество;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если Цел(СтрокаТовара.Товар.КратностьКоличества) <> СтрокаТовара.Товар.КратностьКоличества Тогда
		Длина		= 10;
		Точность	= 3;
	Иначе
		Длина		= 6;
		Точность	= 0;
	КонецЕсли;
	
	Колво = ИнтерфейсРМ.ВводЧисла("Количество перенести", "Число", Длина, Точность, СтрокаТовара.Количество, СтрокаТовара.Товар.КратностьКоличества);
	
	Если Колво=Неопределено Тогда
		Возврат;
	ИначеЕсли Колво>СтрокаТовара.Количество Тогда
		Текст1="Некорректное значение!";
		Текст2="Нельзя перенести больше, чем в заказе...";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат;
	КонецЕсли;
	
	СтрокаТовара.Перенести	= Колво;
	СтрокаТовара.Остаток	= СтрокаТовара.Количество - Колво;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	// неизменяемые надписи
	ЭлементыФормы.тНомерЗаказа.Заголовок = "Разделение заказа № "+УбратьВсеБуквы(Заказ.Номер)+" "+НаимПосадочногоМеста(Заказ.ПосадочноеМесто);
	
	Если Заказ.КоличествоПосетителей = 1 Тогда
		ЭлементыФормы.КнопкаПереносПосетителей.Видимость = Ложь;
	КонецЕсли;
	
	Если глПараметрыРМ.ЗаказШрифтОсновной.Вид <> ВидШрифта.АвтоШрифт Тогда
		ЭлементыФормы.ТаблицаПереноса.Шрифт = глПараметрыРМ.ЗаказШрифтОсновной;
	КонецЕсли;
	М = Новый Массив;
	М.Добавить(Заказ.Ссылка);
	Если ксТрактир.ПоЗаказуЕстьМарки(М) Тогда
		
		Текст1="По заказу есть невыданные блюда!";
		Текст2="Разделение заказа с невыданными блюдами невозможно! 
		|Продолжить?";
		Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"Да","","Esc=Нет") = "Нет"  Тогда
			Закрыть();
		КонецЕсли;
		
		Для каждого Т Из ТаблицаПереноса Цикл
			Т.Перенести = Т.Количество;
		КонецЦикла;
		фПеренестиВсе = 1;
		ЭлементыФормы.КнопкаПеренестиВсе.Видимость = 0;
		ЭлементыФормы.КнопкаКоличество.Видимость = 0;
	КонецЕсли;
	
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ТекущийЭлемент = ЭлементыФормы.ТаблицаПереноса;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаСтрелкаВверхНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.ТаблицаПереноса;
	WshShell.SendKeys("{UP}");
	
КонецПроцедуры

Процедура КнопкаСтрелкаВнизНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.ТаблицаПереноса;
	WshShell.SendKeys("{DOWN}");
	
КонецПроцедуры

Процедура ТаблицаПереносаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	Если Не фПеренестиВсе Тогда
		ИзменитьКоличество();
	Иначе
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
	
КонецПроцедуры

Процедура КнопкаКоличествоНажатие(Элемент)
	
	ИзменитьКоличество();
	
КонецПроцедуры

Процедура КнопкаПеренестиВсеНажатие(Элемент)
	
	Для каждого СтрокаТовара Из ТаблицаПереноса Цикл
		СтрокаТовара.Перенести	= СтрокаТовара.Количество;
		СтрокаТовара.Остаток	= 0;
	КонецЦикла;
	
КонецПроцедуры

Процедура КнопкаПереносПосетителейНажатие(Элемент)
	
	Колво = ИнтерфейсРМ.ВводЧисла("Кол-во посетителей", "Число", 3, 0, 1, 1);
	Если  Колво=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Колво>Заказ.КоличествоПосетителей тогда
		Текст1="Некорректное значение!";
		Текст2="Нельзя перенести больше, чем в заказе...";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат;
	КонецЕсли;
	
	КоличествоПосетителей = Колво; 
	
	ЭлементыФормы.КнопкаПереносПосетителей.Заголовок = ?(КоличествоПосетителей=0, "Посетителей не переносить", "Перенести посетителей: "+КоличествоПосетителей);
	
КонецПроцедуры

Процедура КнопкаВыбратьЗаказНажатие(Элемент)
	
	Если ТаблицаПереноса.Итог("Перенести") = 0 Тогда
		Текст1="Нечего переносить!";
		Текст2="Укажите позиции, которые нужно перенести...";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат;
	КонецЕсли;
	
	//МассивЗаказов = Новый Массив;
	//
	//Запрос = Новый Запрос("
	//|ВЫБРАТЬ
	//|	ЗаказДопИнф.Заказ КАК ДокСсылка,
	//|	ЗаказДопИнф.Заказ.Автор КАК Автор
	//|ИЗ
	//|	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	//|ГДЕ
	//|	ЗаказДопИнф.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказа.Открыт)
	//|	И НЕ ЗаказДопИнф.Заказ.ПометкаУдаления
	//|	И ЗаказДопИнф.Заказ.МестоРеализации = &МестоРеализации
	//|	И НЕ ЗаказДопИнф.Заказ.ЕстьПресчет
	//|	И НЕ ЗаказДопИнф.Заказ = &Заказ
	//|	И НЕ ЗаказДопИнф.Заказ.Доставка
	//|
	//|УПОРЯДОЧИТЬ ПО ЗаказДопИнф.Заказ.Дата
	//|");
	//
	//Запрос.УстановитьПараметр("МестоРеализации", глПараметрыРМ.МестоРеализации);
	//Запрос.УстановитьПараметр("Заказ", Заказ.Ссылка);
	//
	//Выборка = Запрос.Выполнить().Выбрать();
	//Пока Выборка.Следующий() Цикл
	//	Если ИнтерфейсРМ.ПроверкаПраваДоступа(ПланыВидовХарактеристик.ПраваДоступа.ДоступОткрытыеЗаказы, Ложь, глПользователь, Выборка.Автор)Тогда
	//		МассивЗаказов.Добавить(Выборка.ДокСсылка);
	//	КонецЕсли; 
	//КонецЦикла;
	//
	//Если МассивЗаказов.Количество() = 0 Тогда 
	//	Текст1="Нет доступа!";
	//	Текст2="Доступных заказов нет, перенос возможен только в новый заказ...";
	//	ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
	//	Возврат;
	//КонецЕсли;
	//
	//ВыбЗаказ = ИнтерфейсРМ.ВыборИзСписка(МассивЗаказов);
	ВыбЗаказ = ксТрактир.НайтиЗаказКлиента();
	
	Если ВыбЗаказ = Неопределено  Тогда 
		Возврат;
	КонецЕсли;
	
	Если ВыбЗаказ.Ссылка = Заказ.Ссылка Тогда
		Текст1 = "Выбан исходный заказ";
		Текст2 = "Укажите другой заказ";
		
		ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
		Возврат;                      	
	
	КонецЕсли; 
	
	 

	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыданныеПейджеры.Пейджер,
	|	ВыданныеПейджеры.Заказ,
	|	ВыданныеПейджеры.Станция
	|ИЗ
	|	РегистрСведений.ВыданныеПейджеры КАК ВыданныеПейджеры
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВыданныеПейджеры КАК ВыданныеПейджеры1
	|		ПО ВыданныеПейджеры.Станция = ВыданныеПейджеры1.Станция
	|ГДЕ
	|	ВыданныеПейджеры.Заказ = &СтарыйЗаказ
	|	И ВыданныеПейджеры1.Заказ = &НовыйЗаказ");
	Запрос.УстановитьПараметр("СтарыйЗаказ", Заказ.Ссылка);
	Запрос.УстановитьПараметр("НовыйЗаказ", ВыбЗаказ.Ссылка);
	
	СтрПейджеры="";
	Выб = Запрос.Выполнить().Выбрать();
	Пока Выб.Следующий() Цикл
	
		СтрПейджеры = СтрПейджеры + ?(ПустаяСтрока(СтрПейджеры), "", ", ") + СокрЛП(Выб.Пейджер);
		
		НЗ = РегистрыСведений.ВыданныеПейджеры.СоздатьНаборЗаписей();
		НЗ.Отбор.Заказ.Установить(Выб.Заказ);
		НЗ.Отбор.Станция.Установить(Выб.Станция);
		НЗ.Записать(Истина);

	КонецЦикла; 
	Если НЕ ПустаяСтрока(СтрПейджеры) Тогда
		Текст1="Возврат пейджера";
		Текст2="Гость должен сдать пейджер"+?(Выб.Количество()>1,"ы №"," №")+СтрПейджеры;
		ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
		
		// Регистрация вызова ниже; после перевода марок в статус "к выдаче"
	КонецЕсли; 
	
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ВыданныеПейджеры.Пейджер,
	|	ВыданныеПейджеры.Заказ,
	|	ВыданныеПейджеры.Станция
	|ИЗ
	|	РегистрСведений.ВыданныеПейджеры КАК ВыданныеПейджеры
	|ГДЕ
	|	ВыданныеПейджеры.Заказ = &СтарыйЗаказ");
	Запрос.УстановитьПараметр("СтарыйЗаказ", Заказ.Ссылка);
	
	Выб = Запрос.Выполнить().Выбрать();
	Пока Выб.Следующий() Цикл
	
		МЗ = РегистрыСведений.ВыданныеПейджеры.СоздатьМенеджерЗаписи();
		МЗ.Заказ = ВыбЗаказ.ссылка;
		МЗ.Станция = Выб.Станция;
		МЗ.Пейджер = Выб.Пейджер;
		МЗ.Записать(ИСтина);

	КонецЦикла;
	
	Выб = РегистрыСведений.Марки.Выбрать();
	Пока Выб.Следующий() Цикл
	
		Если Выб.Заказ=Заказ.Ссылка Тогда
		
			МЗ = Выб.ПолучитьМенеджерЗаписи();
			МЗ.Заказ = ВыбЗаказ;
			МЗ.Записать(Истина);
		
		КонецЕсли; 
	
	КонецЦикла; 

	ВладелецФормы.ОбработкаРазделенияЗаказа(ВыбЗаказ, ТаблицаПереноса, КоличествоПосетителей);
	Закрыть();
	
КонецПроцедуры

Процедура КнопкаНовыйЗаказНажатие(Элемент)
	
	М = Новый Массив;
	М.Добавить(Заказ.Ссылка);
	Если ксТрактир.ПоЗаказуЕстьМарки(М) Тогда
		Текст1="Есть невыданные блюда!";
		Текст2="Разделение заказа с невыданными блюдами невозможно!";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат;
	КонецЕсли;
		
	Если ТаблицаПереноса.Итог("Перенести") = 0 Тогда
		Текст1="Нечего переносить!";
		Текст2="Укажите позиции, которые нужно перенести...";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат;
	КонецЕсли;
	
	Текст1="Новый заказ!";
	Текст2="Создать новый заказ для переноса позиций?";
	Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"ОК","","Esc=Отмена") = "Отмена"  Тогда
		Возврат;
	КонецЕсли;
	
	ВладелецФормы.ОбработкаРазделенияЗаказа(Документы.Заказ.ПустаяСсылка(), ТаблицаПереноса, КоличествоПосетителей);
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

КоличествоПосетителей = 0;
фПеренестиВсе = 0;
