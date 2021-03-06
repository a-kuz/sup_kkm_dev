﻿Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна
Перем тзНастройки;
Перем ВыбГруппа, ВыбПодгруппа, ВыбНастройкиГруппы, ВыбНастройкиПодгруппы;
Перем ЦветОК, ЦветОш, ЦветБц;

Процедура ВыводПредупреждения(Заголовок, Текст, ГоризонтальноеПоложение=Неопределено)

	ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Заголовок,Текст,"","ОК","", ГоризонтальноеПоложение);
	
КонецПроцедуры

// Вызывается по кнопке ВЫБОР 
//
Процедура ВыборСпецифик()
	
	ТаблицаОшибок = КонтрольОграничений(тзНастройки, Истина);
	Если ТаблицаОшибок.Количество() > 0 Тогда
		К = 1;
		Стр = "";
		
		Для Каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
			Стр = Стр + ?(Стр = "", "", Символы.ПС) + К + ") " + СтрокаТаблицы.Ошибка;
			К = К + 1;
		КонецЦикла; 
		
		ВыводПредупреждения("Невыполнены условия:", Стр, ГоризонтальноеПоложение.Лево);
		Возврат;
	КонецЕсли; 
	
	ВыборСделан = Истина;
	Закрыть();
	
КонецПроцедуры

Процедура РасчетИтогаПоТовару()

	УдельныйВесТовар = ГруппыСпецифик.Итог("УдельныйВес");
	
	
	ЭлементыФормы.тФакт.Заголовок = УдельныйВесТовар;
	ЭлементыФормы.тСумма.Заголовок = Специфики.Итог("Сумма");
	
	ЭлементыФормы.тСуммаБлюда.Заголовок = (СуммаТовар+Специфики.Итог("Сумма"));
	
	ЭлементыФормы.ПанельГруппы.ЦветФона = ?((МинУдельныйВесТовара <= УдельныйВесТовар) И (УдельныйВесТовар <= МаксУдельныйВесТовара), ЦветОК, ЦветОш);

КонецПроцедуры
 
Процедура УстановитьОтборПоСтроке();

	СтрокаГруппы = ЭлементыФормы.ГруппыСпецифик.ТекущаяСтрока;
	
	Если СтрокаГруппы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	// текущие значения в отборе
	Специфики.Сортировать("Порядок,Специфика");
	ОтборСтрок = ЭлементыФормы.Специфики.ОтборСтрок;
	
	Отбор = ОтборСтрок["Группа"];
	ОтборГруппа = ?(Отбор.Использование, Отбор.Значение, Неопределено);
	
	Отбор = ОтборСтрок["Подгруппа"];
	ОтборПодгруппа = ?(Отбор.Использование, Отбор.Значение, Неопределено);
	
	// новые значения
	ВыбГруппа = СтрокаГруппы["Специфика"];
	ВыбГруппаНаименование = СтрокаГруппы["Наименование"];
	
	ВыбНастройкиГруппы = тзНастройки.Найти(ВыбГруппа, "Группа");
	Если ВыбНастройкиГруппы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТаблицаПодгрупп = ВыбНастройкиГруппы.ТаблицаПодгрупп;

	Если (ВыбГруппа <> ОтборГруппа) Тогда
		ВыбПодгруппа = Неопределено;
	КонецЕсли; 
	
	Если ВыбПодгруппа = Неопределено Тогда
	    // берем первую
		ТаблицаПодгрупп = ВыбНастройкиГруппы.ТаблицаПодгрупп;
		Если ТаблицаПодгрупп.Количество() = 0 Тогда
			Возврат;
		КонецЕсли; 
		
		ВыбПодгруппа = ТаблицаПодгрупп[0].Подгруппа;
	КонецЕсли;
	
	ВыбНастройкиПодгруппы = ТаблицаПодгрупп.Найти(ВыбПодгруппа, "Подгруппа");
	НомерПодгруппы = ?(ВыбНастройкиПодгруппы = Неопределено, 0, ТаблицаПодгрупп.Индекс(ВыбНастройкиПодгруппы)+1);
	
	Если (ВыбГруппа = ОтборГруппа) И (ВыбПодгруппа = ОтборПодгруппа) Тогда
		Возврат; // ничего не изменилось
	КонецЕсли; 
	
	ОтборСтрок.Сбросить();		
	
	Отбор = ОтборСтрок["Группа"];
	Отбор.Использование = Истина;
	Отбор.Значение = ВыбГруппа;
	Отбор.ВидСравнения = ВидСравнения.Равно;

	Отбор = ОтборСтрок["Подгруппа"];
	Отбор.Использование = Истина;
	Отбор.Значение = ВыбПодгруппа;
	Отбор.ВидСравнения = ВидСравнения.Равно;

	ЛистаниеПодгрупп = (ТаблицаПодгрупп.Количество() > 1);
	ЭлементыФормы.тНомерПодгруппы.Заголовок = ?(ЛистаниеПодгрупп, ""+НомерПодгруппы+"/"+ТаблицаПодгрупп.Количество(), "");
	ЭлементыФормы.КнопкаПредыдущая.Доступность = ЛистаниеПодгрупп;
	//ЭлементыФормы.КнопкаПредыдущая.Видимость = ЛистаниеПодгрупп;
	ЭлементыФормы.КнопкаСледующая.Доступность = ЛистаниеПодгрупп;
	//ЭлементыФормы.КнопкаСледующая.Видимость = ЛистаниеПодгрупп;
	
	ЭлементыФормы.тГруппаПодгруппаСпецифик.Заголовок = ""+ВыбГруппаНаименование+?(ЛистаниеПодгрупп, "/"+ВыбПодгруппа, "")+":";
	
	#Область КартинкиСпецифик
	ВыводСпецификНаИнфоДисплей(, ?(ЗначениеЗаполнено(ВыбПодгруппа), ВыбПодгруппа, ВыбГруппа));
	#КонецОбласти
КонецПроцедуры
 
Процедура ЛистаниеПодгрупп(Шаг)

	//НастройкиГруппы = тзНастройки.Найти(ВыбГруппа, "Группа");
	//Если НастройкиГруппы = Неопределено Тогда
	//	Возврат;
	//КонецЕсли; 
	
	ТаблицаПодгрупп = ВыбНастройкиГруппы.ТаблицаПодгрупп;

	//Если ТаблицаПодгрупп.Количество() = 0 Тогда
	//	Возврат;
	//КонецЕсли; 
	//
	//НастройкиПодгруппы = ТаблицаПодгрупп.Найти(ВыбПодгруппа, "Подгруппа");
	//
	//Если НастройкиПодгруппы = Неопределено Тогда
	//	Возврат;
	//КонецЕсли; 
	
	НомерПодгруппы = (ТаблицаПодгрупп.Индекс(ВыбНастройкиПодгруппы)+1) + Шаг;
	
	Если НомерПодгруппы < 1 Тогда
		НомерПодгруппы = ТаблицаПодгрупп.Количество();
	ИначеЕсли НомерПодгруппы > ТаблицаПодгрупп.Количество() Тогда
		НомерПодгруппы = 1;
	КонецЕсли; 
	
	ВыбНастройкиПодгруппы = ТаблицаПодгрупп[НомерПодгруппы-1];
	ВыбПодгруппа = ВыбНастройкиПодгруппы.Подгруппа;
	
	УстановитьОтборПоСтроке();
	
КонецПроцедуры
 
Процедура ИзменитьУдельныйВесПоСтроке(СтрокаСпецифик, Знак)

	Шаг = СтрокаСпецифик.Специфика.УдельныйВес;
	Изменение = Знак * Шаг;
	НовыйВес = СтрокаСпецифик.УдельныйВес + Изменение;
	
	Если (СтрокаСпецифик.УдельныйВесЗаказано > 0) И (СтрокаСпецифик.УдельныйВесЗаказано > НовыйВес) Тогда
		 ВыводПредупреждения("Нет доступа!", "Нельзя удалять уже заказанную специфику!");
	     Возврат;
	КонецЕсли; 

	СтрокаГруппы = ГруппыСпецифик.Найти(СтрокаСпецифик.Группа, "Специфика");
	Если СтрокаГруппы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	//---
	НастройкиГруппы = тзНастройки.Найти(СтрокаСпецифик.Группа, "Группа");
	Если НастройкиГруппы = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ТаблицаПодгрупп = НастройкиГруппы.ТаблицаПодгрупп;

	Если ТаблицаПодгрупп.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	
	НастройкиПодгруппы = ТаблицаПодгрупп.Найти(СтрокаСпецифик.Подгруппа, "Подгруппа");
	
	Если НастройкиПодгруппы = Неопределено Тогда
		Возврат;
	КонецЕсли; 

	СпецификаКонтроль = ?(ЗначениеЗаполнено(СтрокаСпецифик.Подгруппа), СтрокаСпецифик.Подгруппа, СтрокаСпецифик.Группа);
	НастройкиКонтроля = ?(ЗначениеЗаполнено(СтрокаСпецифик.Подгруппа), НастройкиПодгруппы, НастройкиГруппы);
	
	Если НовыйВес > 0 Тогда // эти контроли выполняем только при выбранном значении уд. веса
		Если НастройкиКонтроля.ОднаИзГруппы Тогда
			Отбор = Новый Структура("Группа, Подгруппа", СтрокаСпецифик.Группа, СтрокаСпецифик.Подгруппа);
			МассивСтрок = Специфики.НайтиСтроки(Отбор);
			
			УжеВыбраноВГруппе = 0;
			Для К = 0 По МассивСтрок.Количество() - 1 Цикл
				УжеВыбраноВГруппе = УжеВыбраноВГруппе + МассивСтрок[К].Выбрана;
			КонецЦикла; 
			
			Если УжеВыбраноВГруппе > 0 Тогда
				ВыводПредупреждения("Контроль специфик!", "Доступен выбор только одной специфики из "+СпецификаКонтроль+".");
				Возврат;
			КонецЕсли; 
			
		ИначеЕсли НЕ НастройкиКонтроля.РазрешитьПовторение Тогда
			Если СтрокаСпецифик.Выбрана > 0 Тогда
				ВыводПредупреждения("Контроль специфик!", "Для "+СпецификаКонтроль+" запрещено повторение одной и той же специфики.");
				Возврат;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	//---
	//Z+
	Если Знак=1 и СтрокаСпецифик.ПорядокВыбора=0 Тогда
		Пор=0;
		Список=Новый СписокЗначений;    
		Список.ЗагрузитьЗначения(Специфики.ВыгрузитьКолонку("ПорядокВыбора"));    
		Если Список.Количество()=0 Тогда 
			Пор=0 
		КонецЕсли;                            
		Список.СортироватьПоЗначению(НаправлениеСортировки.Убыв);    
		Пор=Список[0].Значение;   
		СтрокаСпецифик.ПорядокВыбора=Пор+1;
	КонецЕсли;
	
	УдВес1 = СтрокаСпецифик.УдельныйВес;
	
	СтрокаСпецифик.УдельныйВес = СтрокаСпецифик.УдельныйВес + Изменение;
	СтрокаСпецифик.Сумма = СтрокаСпецифик.УдельныйВес * СтрокаСпецифик.Цена;
	СтрокаСпецифик.Выбрана     = ?(СтрокаСпецифик.УдельныйВес > 0, 1, 0);
	
	УдВес2 = СтрокаСпецифик.УдельныйВес;
	
	Если УдВес1 <> УдВес2 Тогда
		// Изменился уд. вес по специфике
		СтрокаГруппы.УдельныйВес   	= СтрокаГруппы.УдельныйВес + Изменение;
		СтрокаГруппы.Сумма			= СтрокаГруппы.Сумма + Изменение * СтрокаСпецифик.Цена; 
		Если (УдВес1 > 0) И (УдВес2 = 0) Тогда
			ИзменениеВыбрана = -1;
		ИначеЕсли (УдВес1 = 0) И (УдВес2 > 0) Тогда
			ИзменениеВыбрана = 1;	
		Иначе
			ИзменениеВыбрана = 0;
		КонецЕсли; 
		
		// Также сохраним изменения в настройках
		НастройкиГруппы.УдельныйВес    = СтрокаГруппы.УдельныйВес;
		НастройкиПодгруппы.УдельныйВес = НастройкиПодгруппы.УдельныйВес + Изменение;
		НастройкиПодгруппы.Выбрана     = НастройкиПодгруппы.Выбрана + ИзменениеВыбрана;
	КонецЕсли; 
	
	РасчетИтогаПоТовару();
	
	ГидПоГруппам();
	
КонецПроцедуры

Процедура ГидПоГруппам()

	Если ГруппыСпецифик.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Создаем таблицу групп с колонкой "ЕстьОшибка"
	тзГруппы = ГруппыСпецифик.Выгрузить( , "Специфика");
	тзГруппы.Колонки.Добавить("ЕстьОшибка", Новый ОписаниеТипов("Булево"));
	
	ТаблицаОшибок = КонтрольОграничений(тзНастройки, Истина);
	
	Для каждого СтрокаТаблицы Из ТаблицаОшибок Цикл
		Если СтрокаТаблицы.КатегорияОбъекта = "Группа" Тогда
		
			НайденнаяСтрока = тзГруппы.Найти(СтрокаТаблицы.ПроверяемыйОбъект, "Специфика");	
			Если НайденнаяСтрока <> Неопределено Тогда
				НайденнаяСтрока.ЕстьОшибка = Истина;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла; 
	
	// Текущая группа
	СтрокаГруппы = ЭлементыФормы.ГруппыСпецифик.ТекущаяСтрока;
	ТекГруппа = ?(СтрокаГруппы <> Неопределено, СтрокаГруппы.Специфика, ГруппыСпецифик[0].Специфика);
	
	// Ищем группу с ошибкой начиная с текущей
	НайденнаяСтрока = тзГруппы.Найти(ТекГруппа, "Специфика");	
	ТекИндекс = тзГруппы.Индекс(НайденнаяСтрока);
	НовИндекс = ТекИндекс;
	
	Пока ТекИндекс < тзГруппы.Количество() Цикл
		СтрокаГруппы = тзГруппы[ТекИндекс];
		
		Если СтрокаГруппы.ЕстьОшибка Тогда
			НовИндекс = ТекИндекс;
			Прервать;
		КонецЕсли; 
		
		ТекИндекс = ТекИндекс + 1;
	КонецЦикла;
	
	Если ЭлементыФормы.ГруппыСпецифик.ТекущиеДанные <> Неопределено И ЭлементыФормы.ГруппыСпецифик.ТекущиеДанные.МинУдельныйВес > 0 Тогда
		ЭлементыФормы.ГруппыСпецифик.ТекущаяСтрока = ГруппыСпецифик[НовИндекс];
	КонецЕсли;
	
	
	УстановитьОтборПоСтроке();
	
КонецПроцедуры
 

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ВыборСделан = Ложь;
	
	ЭтаФорма.Заголовок = СокрЛП(Товар.Наименование);
	ЭлементыФормы.тТовар.Заголовок = "Специфики приготовления";
	
	РасчетИтогаПоТовару();
	
	ЭлементыФормы.тМин.Заголовок  = МинУдельныйВесТовара;
	ЭлементыФормы.тМакс.Заголовок = МаксУдельныйВесТовара;
	
	тзНастройки = ТаблицаНастроекСпецифик();
	
	Если ГруппыСпецифик.Количество() > 0 Тогда
		//ЭлементыФормы.ГруппыСпецифик.ТекущаяСтрока = ГруппыСпецифик[0];
		ГидПоГруппам();
	КонецЕсли; 
	
	УстановитьОтборПоСтроке();
	
КонецПроцедуры

Процедура ПриОткрытии()
	Показатель_ДобавлениеСтроки = 1;
	КонтрольныеПоказатели.ЗакончитьЗамер(Показатель_ДобавлениеСтроки);
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
	Если ВыборСпец<>Справочники.Специфики.ПустаяСсылка() Тогда
		СпрГруппа=ВыборСпец;
		Пока 1=1 Цикл
			Если НЕ ЗначениеЗаполнено(СпрГруппа.Родитель) Тогда
				Прервать;
			КонецЕсли;	
			СпрГруппа=СпрГруппа.Родитель;
			Если СпрГруппа.Уровень()=1 Тогда
				Прервать;
			КонецЕсли;		
			Если СпрГруппа.Родитель=0 Тогда
				Прервать;
			КонецЕсли;	
		КонецЦикла;	
		Общая=ксТрактир.ОбщаяСпецифика(СпрГруппа);//СпрГруппа.ПринадлежитЭлементу(Константы.ГруппаОбщихСпецифик.Получить());
		Если НЕ Общая Тогда
			НужнаяГруппа=ГруппыСпецифик.НайтиСтроки(Новый Структура("Специфика",СпрГруппа));
			Если НужнаяГруппа.Количество()<>0 Тогда
				ЭлементыФормы.ГруппыСпецифик.ТекущаяСтрока= НужнаяГруппа[0];
				НужнаяСтрока=Специфики.НайтиСтроки(Новый Структура("Специфика",ВыборСпец));	
			КонецЕсли;
			Если НужнаяСтрока<>Неопределено Тогда
				Если НужнаяСтрока.Количество()<>0 Тогда
					ЭлементыФормы.Специфики.ТекущаяСтрока= НужнаяСтрока[0];
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	глОтсечкаПростоя();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаВыбратьНажатие(Элемент)
	
	ВыборСпецифик();
	
КонецПроцедуры

Процедура КнопкаСтрелкаВверхНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.ГруппыСпецифик;
	WshShell.SendKeys("{UP}");
	
	УстановитьОтборПоСтроке();
	
КонецПроцедуры

Процедура КнопкаСтрелкаВнизНажатие(Элемент)
	
	ТекущийЭлемент = ЭлементыФормы.ГруппыСпецифик;
	WshShell.SendKeys("{DOWN}");
	
	УстановитьОтборПоСтроке();
	
КонецПроцедуры

Процедура КнопкаВверхСпискаНажатие(Элемент)
	
	ЭлементыФормы.Специфики.ТекущаяКолонка = ЭлементыФормы.Специфики.Колонки.Специфика;
	ТекущийЭлемент = ЭлементыФормы.Специфики;
	WshShell.SendKeys("{HOME}"); // {PGUP}
	
КонецПроцедуры

Процедура КнопкаВнизСпискаНажатие(Элемент)
	
	ЭлементыФормы.Специфики.ТекущаяКолонка = ЭлементыФормы.Специфики.Колонки.Специфика;
	ТекущийЭлемент = ЭлементыФормы.Специфики;
	WshShell.SendKeys("{END}"); // {PGDN}
	
КонецПроцедуры

Процедура ГруппыСпецификПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ЦветФона = ?((ДанныеСтроки.МинУдельныйВес <= ДанныеСтроки.УдельныйВес) И (ДанныеСтроки.УдельныйВес <= ДанныеСтроки.МаксУдельныйВес), ЦветОК, ЦветОш);
	
	Если (ЦветФона = ЦветОК) И (ДанныеСтроки.УдельныйВес = 0) Тогда
		ЦветФона = ЦветБц;
	КонецЕсли; 
	
	ОформлениеСтроки.ЦветФона = ЦветФона;
	
КонецПроцедуры

Процедура ГруппыСпецификПриАктивизацииСтроки(Элемент)
	
	УстановитьОтборПоСтроке();
	
КонецПроцедуры

Процедура ГруппыСпецификВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	УстановитьОтборПоСтроке();
	
КонецПроцедуры

Процедура КнопкаПредыдущаяНажатие(Элемент)
	
	ЛистаниеПодгрупп(-1);
	
КонецПроцедуры

Процедура КнопкаСледующаяНажатие(Элемент)
	
	ЛистаниеПодгрупп(1);
	
КонецПроцедуры

Процедура СпецификиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	НастройкиКонтроль = ?(ЗначениеЗаполнено(ВыбПодгруппа), ВыбНастройкиПодгруппы, ВыбНастройкиГруппы);
	ЦветФона = ?((НастройкиКонтроль.МинУдельныйВес <= НастройкиКонтроль.УдельныйВес) И (НастройкиКонтроль.УдельныйВес <= НастройкиКонтроль.МаксУдельныйВес), ЦветОК, ЦветОш);
	
	Если (ДанныеСтроки.УдельныйВес = 0) Тогда
		ЦветФона = ЦветБц;
	КонецЕсли; 
	
	ОформлениеСтроки.ЦветФона = ЦветФона;
	//	Ячейки = ОформлениеСтроки.Ячейки;
	//	Ячейки.Минус.ЦветФона = ЦветБц;
	
КонецПроцедуры

Процедура СпецификиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Колонка = ЭлементыФормы.Специфики.ТекущаяКолонка;
	
	Если Колонка = Неопределено Тогда
		Возврат;
	ИначеЕсли Колонка.Имя = "Плюс" Тогда
		Знак = 1;
	ИначеЕсли Колонка.Имя = "Минус" Тогда
		Знак = -1;
	Иначе
		Возврат;
	КонецЕсли; 
	
	Строка = ЭлементыФормы.Специфики.ТекущаяСтрока;
	
	Если Строка = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ИзменитьУдельныйВесПоСтроке(Строка, Знак);
	//Z+	
	ВыводСпецификНаИнфоДисплей(, ?(ЗначениеЗаполнено(ВыбПодгруппа), ВыбПодгруппа, ВыбГруппа));
	//Z-	
	
КонецПроцедуры



////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
ВыбГруппа    = Неопределено;
ВыбПодгруппа = Неопределено;
ЦветОК = Новый Цвет(219,251,216);
ЦветОш = Новый Цвет(251,219,216); 
ЦветБц = Новый Цвет(255,255,255); 