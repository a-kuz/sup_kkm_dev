﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПолучитьДеревоТО();
	
	СВ = Элементы.Порт.СписокВыбора;
	СВ.Очистить();
	Для Инд = 0 по 9 Цикл
		СВ.Добавить(Инд, ?(Инд, "COM"+Инд, "Клавиатура"));
	КонецЦикла;
	СВ.Добавить(Неопределено, "<не задан>");
	
	Порт = Справочники.ТорговоеОборудование.ПолучитьНомерПорта(Объект.Параметры, Истина);
	Попытка Порт = Число(Порт) Исключение КонецПопытки;
	
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииНаСервере(Отказ, ТекущаяИБ, РаспределенныйРежим)
	
	ТекущаяИБ = ПараметрыСеанса.ТекущаяИБ;
	РаспределенныйРежим = ПараметрыСеанса.РаспределенныйРежим;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)

	Перем ТекущаяИБ, РаспределенныйРежим;
	ПриОткрытииНаСервере(Отказ, ТекущаяИБ, РаспределенныйРежим);
	
	Если _ДеревоТО.ПолучитьЭлементы().Количество() = 0 Тогда
		ПоказатьПредупреждение(, "Список видов подключаемого оборудования не определен!", 5);
		Возврат;
	КонецЕсли; 
	
	Если Объект.Ссылка.Пустая() И НЕ ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.ТипПрофиля = 1;
		Объект.ИнформационнаяБаза = ?(глВерсия = 1, Неопределено, ТекущаяИБ);
	КонецЕсли;
	
	ЗаполнитьСписокВыбораТО(1, Истина);
	ОпределитьИмяОбработки();
	УправлениеФормой();
	
	Если НЕ РаспределенныйРежим Тогда
		Элементы.ИнформационнаяБаза.Видимость = Ложь;
	КонецЕсли; 

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ИнформационнаяБазаНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ПараметрыФормы = Новый Структура;
	ОткрытьФорму("Справочник.ИнформационныеБазы.ФормаВыбора", ПараметрыФормы, ЭтаФорма, , , ,Новый ОписаниеОповещения("ИнформационнаяБазаНажатие_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ИнформационнаяБазаНажатие_Завершение(Результат, ДополнительныеПараметры) Экспорт 
	Если НЕ Результат = Неопределено Тогда
		Объект.ИнформационнаяБаза = Результат;
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура КодВидаПриИзменении(Элемент)
	ЗаполнитьСписокВыбораТО(2);
	ОпределитьИмяОбработки();
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура КодМоделиПриИзменении(Элемент)
	ЗаполнитьСписокВыбораТО(3);
	ОпределитьИмяОбработки();
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура КодВерсииПриИзменении(Элемент)
	ОпределитьИмяОбработки();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВнешняяПриИзменении(Элемент)
	ОпределитьИмяОбработки();
	УправлениеФормой();
КонецПроцедуры

&НаКлиенте
Процедура ИмяОбработкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок = "Выберите файл...";
	Диалог.ПредварительныйПросмотр		= Ложь;
	Диалог.ПроверятьСуществованиеФайла	= Ложь;
	Диалог.МножественныйВыбор			= Ложь;
	Диалог.ПолноеИмяФайла				= Объект.ИмяОбработки;
	Диалог.Фильтр						= "Внешняя обработка (*.epf)|*.epf";
	Диалог.Расширение					= "epf";
	
	Если Диалог.Выбрать() Тогда
		Элемент.Значение = Диалог.ПолноеИмяФайла;
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПортПриИзмененииНаСервере()
	Объект.Параметры = Справочники.ТорговоеОборудование.ИзменитьНомерПорта(Объект.Параметры, СокрЛП(Порт));
КонецПроцедуры

&НаКлиенте
Процедура ПортПриИзменении(Элемент)
	ПортПриИзмененииНаСервере();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаСервере
Процедура ПараметрыНаСервере()
	РеквизитФормыВЗначение("Объект").НастройкаПараметров(Объект.Параметры);
	Порт = Справочники.ТорговоеОборудование.ПолучитьНомерПорта(Объект.Параметры, Истина);
КонецПроцедуры

&НаКлиенте
Процедура Параметры(Команда)
	ПараметрыНаСервере();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеФормой()
	Элементы.ОбработкаВнешняя.Доступность = НЕ (ВРег(Объект.КодВида) = "ИНОЕ") И НЕ (ВРег(Объект.КодМодели) = "ИНОЕ") И НЕ (ВРег(Объект.КодВерсии) = "ИНОЕ");
	Элементы.ИмяОбработки.Доступность     = Объект.ОбработкаВнешняя;
КонецПроцедуры

&НаСервере
Процедура ОпределитьИмяОбработки()
	
	ДеревоТО = РеквизитФормыВЗначение("_ДеревоТО");
	
	Результат = Новый Структура("Код,ИмяОбработки");
	
	ТекСтрока = ДеревоТО.Строки.Найти(Объект.КодВида, "Код", Ложь);
	Если НЕ ТекСтрока = Неопределено Тогда
		ЗаполнитьЗначенияСвойств(Результат, ТекСтрока);
		Если НЕ ЗначениеЗаполнено(ТекСтрока.ИмяОбработки) Тогда
			ТекСтрока = ТекСтрока.Строки.Найти(Объект.КодМодели, "Код", Ложь);
			Если НЕ ТекСтрока = Неопределено Тогда
				ЗаполнитьЗначенияСвойств(Результат, ТекСтрока);
				Если НЕ ЗначениеЗаполнено(ТекСтрока.ИмяОбработки) Тогда
					ТекСтрока = ТекСтрока.Строки.Найти(Объект.КодВерсии, "Код", Ложь);
					Если НЕ ТекСтрока = Неопределено Тогда
						ЗаполнитьЗначенияСвойств(Результат, ТекСтрока);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если ВРег(Результат.Код) = "ИНОЕ" Тогда
		Объект.ОбработкаВнешняя = Истина;
	КонецЕсли;
	Объект.ИмяОбработки = Результат.ИмяОбработки;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписокВыбораТО(Уровень, ЗаполнениеПриОткрытии = Ложь)
	ЗаполнитьСписокВыбораТОНаСервере(Уровень, ЗаполнениеПриОткрытии);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораТОНаСервере(Уровень, ЗаполнениеПриОткрытии = Ложь)
	
	Если Уровень = 1 Тогда
		ПолеВыбора = Элементы.КодВида;
	ИначеЕсли Уровень = 2 Тогда
		ПолеВыбора = Элементы.КодМодели;
	ИначеЕсли Уровень = 3 Тогда
		ПолеВыбора = Элементы.КодВерсии;
	Иначе 
		Возврат;
	КонецЕсли;
	
	ДеревоТО = РеквизитФормыВЗначение("_ДеревоТО");
	СписокВыбора = ПолеВыбора.СписокВыбора;
	СписокВыбора.Очистить();
	
	СписокСтрок = Неопределено;
	Если Уровень = 1 Тогда
		СписокСтрок = ДеревоТО.Строки;
	Иначе
		СтрокаВида = ДеревоТО.Строки.Найти(Объект.КодВида, "Код", Ложь);
		Если НЕ СтрокаВида = Неопределено Тогда
			Если Уровень = 2 Тогда
				СписокСтрок = СтрокаВида.Строки;
			Иначе
				СтрокаМодели = СтрокаВида.Строки.Найти(Объект.КодМодели, "Код", Ложь);
				Если НЕ СтрокаМодели = Неопределено Тогда
					СписокСтрок = СтрокаМодели.Строки;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	
	Если СписокСтрок = Неопределено ИЛИ СписокСтрок.Количество() = 0 Тогда
		ПолеВыбора.Доступность = Ложь;
	Иначе
		Для каждого СтрокаДереваТО Из СписокСтрок Цикл
			СписокВыбора.Добавить(СтрокаДереваТО.Код, СтрокаДереваТО.Наименование);
		КонецЦикла;
		ПолеВыбора.Доступность = Истина;
	КонецЕсли;
	
	Если Уровень < 3 Тогда
		ЗаполнитьСписокВыбораТОНаСервере(Уровень + 1, ЗаполнениеПриОткрытии);
	КонецЕсли; 
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьДеревоТО()
	
	ДеревоТО = РеквизитФормыВЗначение("_ДеревоТО");
	
	Таб = Справочники.ТорговоеОборудование.ПолучитьМакет("СписокТО");
	НомСтр = Таб.Область("Пример").Низ + 1;
	                                                                                   
	ЗаполнитьДеревоТО(ДеревоТО, 1, Таб, НомСтр);
	ОчиститьДеревоТО(ДеревоТО, 1);
	
	ЗначениеВРеквизитФормы(ДеревоТО, "_ДеревоТО");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДеревоТО(КореньДерева, Уровень, Таб, НомСтр)
	Перем СтрокаДереваТО;
	
	СтрокиУровня = КореньДерева.Строки;
	
	ВсегоСтрок = Таб.ВысотаТаблицы;
	
	Пока НомСтр <= ВсегоСтрок Цикл
		
		Если Уровень > 1 И ЗначениеЗаполнено(Таб.Область(НомСтр, Уровень - 1).Текст) Тогда
			Возврат;
			
		ИначеЕсли НЕ ЗначениеЗаполнено(Таб.Область(НомСтр, Уровень).Текст) Тогда
			Если ЗначениеЗаполнено(Таб.Область(НомСтр, Уровень + 1).Текст) Тогда
				ЗаполнитьДеревоТО(СтрокаДереваТО, Уровень + 1, Таб, НомСтр);
			Иначе
				НомСтр = НомСтр + 1;
			КонецЕсли;
			
			Продолжить;
			
		КонецЕсли;
		
		_Код			= Таб.Область(НомСтр, Уровень).Текст;
		_Наименование	= Таб.Область(НомСтр, Уровень + 1).Текст;
		_ИмяОбработки	= Таб.Область(НомСтр, Уровень + 3).Текст;
		
		Если НЕ Уровень = 1 И НЕ ЗначениеЗаполнено(_ИмяОбработки) Тогда
			_ИмяОбработки = ?(ЗначениеЗаполнено(КореньДерева), КореньДерева.ИмяОбработки, "Обслуживание") +"_"+ _Код;
		КонецЕсли; 
		
		СтрокаДереваТО = СтрокиУровня.Добавить();
		СтрокаДереваТО.Код			= _Код;
		СтрокаДереваТО.Наименование	= _Наименование;
		СтрокаДереваТО.ИмяОбработки	= _ИмяОбработки;
		СтрокаДереваТО.ОбработкаЕсть= ?(Метаданные.НайтиПоПолномуИмени("Обработка."+_ИмяОбработки) = Неопределено, 0, 1);
		
		Если НЕ Уровень = 1 Тогда
			КореньДерева.ОбработкаЕсть = Макс(КореньДерева.ОбработкаЕсть, СтрокаДереваТО.ОбработкаЕсть);
		КонецЕсли;
		
		НомСтр = НомСтр + 1;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьДеревоТО(КореньДерева, Уровень)
	
	СтрокиУровня = КореньДерева.Строки;
	ИндексСтроки = 0;
	Пока ИндексСтроки <= СтрокиУровня.Количество()-1 Цикл
		
		СтрокаДереваТО = СтрокиУровня[ИндексСтроки];
		
		Если СтрокаДереваТО.ОбработкаЕсть = 0 Тогда
			СтрокиУровня.Удалить(СтрокаДереваТО);
		Иначе
			ОчиститьДеревоТО(СтрокаДереваТО, Уровень+1);
			ИндексСтроки = ИндексСтроки + 1;
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
