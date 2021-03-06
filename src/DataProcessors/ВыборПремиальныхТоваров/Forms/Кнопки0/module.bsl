﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	ФормаВыбора = ЭтаФорма;


	ЗаполнитьТаблицуВыбора();
	ВывестиТекущуюСтраницу();
	
	Заголовок = ЗаголовокФормы;
	// поиск нужен только если много страниц
	Если ВсегоСтраниц=1 Тогда
		Н = ТаблицаВыбора.Количество(); //  ЭлементыФормы.Кнопка1.Высота
		Э = ЭлементыФормы["Кнопка"+Н];
		Для НомерКнопки=Н+1 По 6 Цикл
			Кнопка 		= ЭлементыФормы["Кнопка"+НомерКнопки];
			КнопкаОтказ = ФормаВыбора.ЭлементыФормы["КнопкаОтказ"+НомерКнопки];
			КнопкаПлюс  = ФормаВыбора.ЭлементыФормы["КнопкаПлюс"+НомерКнопки];
			КнопкаМинус = ФормаВыбора.ЭлементыФормы["КнопкаМинус"+НомерКнопки];
			тКоличество = ФормаВыбора.ЭлементыФормы["тКоличество"+НомерКнопки];
			Кнопка.Верх = 10;
			КнопкаОтказ.Верх = 10;
			КнопкаПлюс.Верх = 10;
			КнопкаМинус.Верх = 10;
			тКоличество.Верх = 10;
		
		КонецЦикла; 
		ЭтаФорма.Высота = Э.Верх + Э.высота + 100;
		ЭлементыФормы.КнопкаОК.Верх = Высота - ЭлементыФормы.КнопкаОК.Высота-10;
		ЭлементыФормы.КнопкаВыход.Верх = Высота - ЭлементыФормы.КнопкаОК.Высота-10;
	КонецЕсли; 
	
	Если МножественныйПодбор Тогда
		// кнопка ОК нужна, стрелки посередине
		ЭлементыФормы.КнопкаОК.Видимость = Истина;
		//ЭлементыФормы.ПанельСтрелки.Лево = ЭтаФорма.Ширина/2 - ЭлементыФормы.ПанельСтрелки.Ширина/2;
	Иначе
		// кнопка ОК не нужна, стрелки прижимаем к правому краю
		ЭлементыФормы.КнопкаОК.Видимость = Ложь;
		//ЭлементыФормы.ПанельСтрелки.Лево = ЭтаФорма.Ширина - ЭлементыФормы.ПанельСтрелки.Ширина - 4;
	КонецЕсли; 
	
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
			
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
	РаботаСокнами.CloseScreenKey();
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаВыбораНажатие(Элемент)
	
	НомерКнопки = Число(Сред(Элемент.Имя,7));
	
	ЗначениеВыбора = ТаблицаВыбора[НомерКнопки-1];
	ЗначениеВыбора.Количество = ЗначениеВыбора.МаксКоличество;

	КнопкаПлюс(Элемент);
	ОбработкаВыбораЗначения( ЗначениеВыбора );
	
	//Элемент.Картинка = ?(ТаблицаВыбора[НомерКнопки-1].ОтказКлиента, БиблиотекаКартинок.Удалить, ?(ТаблицаВыбора[НомерКнопки-1].Выбран,БиблиотекаКартинок.Галка,Новый Картинка));

	
КонецПроцедуры

Процедура КнопкаОтказНажатие(Элемент)
	НомерКнопки = Число(Прав(Элемент.Имя,1));
	ЗначениеВыбора = ТаблицаВыбора[НомерКнопки-1].Значение;
	ТаблицаВыбора[НомерКнопки-1].Выбран = Ложь;
	ТаблицаВыбора[НомерКнопки-1].ОтказКлиента = Истина;
	ТаблицаВыбора[НомерКнопки-1].Количество = 0;
	КнопкаМинус(Элемент);
КонецПроцедуры

Процедура КнопкаОКНажатие(Элемент)
	
	Закрыть(ТаблицаВыбора);

КонецПроцедуры

Процедура КнопкаПлюс(Элемент)
	
	НомерКнопки = Число(Сред(Элемент.Имя,СтрДлина(Элемент.Имя)));
	тКоличество = ЭлементыФормы["тКоличество"+НомерКнопки];
	
	
	ТекСтрока = ТаблицаВыбора[НомерКнопки-1];
	ТекСтрока.Количество = Мин(ТекСтрока.МаксКоличество,ТекСтрока.Количество+1);
	ТекСтрока.ОтказКлиента = Ложь;
	тКоличество.Заголовок = ТекСтрока.Количество;
	
КонецПроцедуры

Процедура КнопкаМинус(Элемент)
	НомерКнопки = Число(Сред(Элемент.Имя,СтрДлина(Элемент.Имя)));
	тКоличество = ЭлементыФормы["тКоличество"+НомерКнопки];
	
	
	ТекСтрока = ТаблицаВыбора[НомерКнопки-1];
	ТекСтрока.Количество = Макс(0,ТекСтрока.Количество-1);
	тКоличество.Заголовок = ТекСтрока.Количество;

КонецПроцедуры

Процедура ВыЗаказалиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	ОформлениеСтроки.Ячейки.Количество.УстановитьТекст("" + ДанныеСтроки.Количество + " шт.");
	ОформлениеСтроки.ЦветФона = Новый Цвет(255,255,255);
	ОформлениеСтроки.ЦветФона = Новый Цвет(255,255,255);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

КолвоКнопок = 6;

	М = Новый Массив;
	Для каждого Т Из АкцииСНаборами Цикл
		Если Не Т.Количество Тогда
			М.Добавить(Т);				
		КонецЕсли; 	
	
	КонецЦикла; 
	
	Для каждого Т Из М Цикл
	
		ТекстСуммаСвыше = Т.Товар;
		ЭлементыФормы.Заголовок2.Видимость = 1;
		АкцииСНаборами.Удалить(Т);
	
	КонецЦикла; 	

	
	Если АкцииСНаборами.Количество() Тогда
		ЭлементыФормы.ВыЗаказали.Высота = АкцииСНаборами.Количество()*25;
	Иначе
		ЭлементыФормы.ВыЗаказали.Высота = 1;
		ЭлементыФормы.ВыЗаказали.Видимость = 0;
		ЭлементыФормы.Заголовок1.Заголовок = ТекстСуммаСвыше;
		ЭлементыФормы.Заголовок2.Видимость = 0;
	КонецЕсли; 