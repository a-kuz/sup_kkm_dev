﻿Перем Колонки;

Процедура ПриОткрытии()
	
	ТабличноеПоле = КлючУникальности;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок, , ТабличноеПоле.Имя, ": ");
	ОбновитьСоставСвойств();
	
КонецПроцедуры

Процедура ОбновитьСоставСвойств()
	
	ТабличноеПоле = КлючУникальности;
	СвойстваСтроки.Очистить();
	Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда
		Колонки = ТабличноеПоле.Колонки;
		КолонкиДанных = ТабличноеПоле.Значение.Колонки;
	Иначе
		Колонки = ТабличноеПоле.ПодчиненныеЭлементы;
		//КолонкиДанных = ирСервер.ПолучитьТаблицуДочернихРеквизитовЛкс(ТабличноеПоле, Истина);
	КонецЕсли; 
	Для Каждого Колонка Из Колонки Цикл
		ИмяКолонкиДанных = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле, Колонка);
		Если Не ЗначениеЗаполнено(ИмяКолонкиДанных) Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаСвойства = СвойстваСтроки.Добавить();
		СтрокаСвойства.Имя = Колонка.Имя;
		СтрокаСвойства.Данные = ИмяКолонкиДанных;
		Если ТипЗнч(Колонка) = Тип("КолонкаТабличногоПоля") Тогда
			СтрокаСвойства.Представление = Колонка.ТекстШапки;
			КолонкаДанных = КолонкиДанных[СтрокаСвойства.Данные];
			СтрокаСвойства.ОписаниеТипов = КолонкаДанных.ТипЗначения;
		Иначе
			СтрокаСвойства.Представление = Колонка.Заголовок;
			СтрокаСвойства.ОписаниеТипов = ирОбщий.ПолучитьТипЗначенияЭлементаФормыЛкс(Колонка, Ложь);
		КонецЕсли; 
		СтрокаСвойства.Порядок = СвойстваСтроки.Количество();
	КонецЦикла;
	//СвойстваСтроки.Сортировать("Представление");
	ЗагрузитьДанныеСтроки(, Ложь);

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если Источник = КлючУникальности Тогда 
		Если ИмяСобытия = "ПриАктивизацииСтроки" Тогда 
			ЗагрузитьДанныеСтроки();
			ПодключитьОбработчикОжидания("ЗагрузитьДанныеСтрокиБезПараметров", 0.1, Истина); // Чтобы при копировании строки содержимое сразу отображалось тут
		ИначеЕсли ИмяСобытия = "ПриИзмененииЯчейки" Тогда
			ЗагрузитьДанныеСтроки(Истина);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура ЗагрузитьДанныеСтрокиБезПараметров()
	
	ЗагрузитьДанныеСтроки();
	
КонецПроцедуры

Процедура ЗагрузитьДанныеСтроки(УстановитьТекущуюСтроку = Ложь, ПроверитьНеизменностьКолонок = Истина)
	
	ТабличноеПоле = КлючУникальности;
	Если ПроверитьНеизменностьКолонок Тогда
		Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда
			Для Каждого СтрокаСвойства Из СвойстваСтроки Цикл
				Если ТабличноеПоле.Значение.Колонки.Найти(СтрокаСвойства.Имя) = Неопределено Тогда
					// Изменились колонки источника
					ОбновитьСоставСвойств();
					Возврат;
				КонецЕсли; 
			КонецЦикла; 
		КонецЕсли; 
	КонецЕсли; 
	//ЭлементыФормы.СвойстваСтроки.ОбновитьСтроки();
	Если Истина
		И ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле")
		И ТабличноеПоле.ТекущаяСтрока <> Неопределено 
	Тогда
		ОформлениеСтроки = ТабличноеПоле.ОформлениеСтроки(ТабличноеПоле.ТекущаяСтрока);
	КонецЕсли; 
	ТекущиеДанные = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ТабличноеПоле);
	Для Каждого СтрокаСвойства Из СвойстваСтроки Цикл
		Если ТекущиеДанные = Неопределено Тогда
			СтрокаСвойства.Значение = СтрокаСвойства.ОписаниеТипов.ПривестиЗначение(Неопределено);
			СтрокаСвойства.ТолькоПросмотр = Истина;
		Иначе
			СтрокаСвойства.Значение = ТекущиеДанные[СтрокаСвойства.Данные];
			КолонкаТабличногоПоля = Колонки[СтрокаСвойства.Имя];
			Попытка
				ЯчейкаОформления = ОформлениеСтроки.Ячейки[СтрокаСвойства.Имя];
			Исключение
				ЯчейкаОформления = Неопределено; // Это новая строка таблицы
			КонецПопытки;
			СтрокаСвойства.ТолькоПросмотр = Ложь
				Или КолонкаТабличногоПоля.ТолькоПросмотр
				Или Не КолонкаТабличногоПоля.Доступность
				Или (Истина
					И ЯчейкаОформления <> Неопределено
					И ЯчейкаОформления.ТолькоПросмотр);
		КонецЕсли; 
		СтрокаСвойства.ПредставлениеЗначения = СтрокаСвойства.Значение;
		ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаСвойства);
	КонецЦикла;
	Если УстановитьТекущуюСтроку Тогда
		ДействияФормыТекущаяКолонкаИсточника();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СвойстваСтрокиПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	ирОбщий.ТабличноеПолеПриВыводеСтрокиЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки, ЭлементыФормы.ДействияФормы.Кнопки.Идентификаторы, "ПредставлениеЗначения",
		Новый Структура("ПредставлениеЗначения", "Значение"));
	
КонецПроцедуры

Процедура ДействияФормыИдентификаторы(Кнопка)
	
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ЭлементыФормы.СвойстваСтроки.ОбновитьСтроки();

КонецПроцедуры

Процедура СвойстваСтрокиПредставлениеЗначенияПриИзменении(Элемент)
	
	ЭлементыФормы.СвойстваСтроки.ТекущиеДанные.Значение = Элемент.Значение;
	ОбновитьПредставлениеИТипЗначенияВСтроке();
	
КонецПроцедуры

// Фактический обработчик ПриИзменени
Процедура ОбновитьПредставлениеИТипЗначенияВСтроке(СтрокаТаблицы = Неопределено)
	
	Если СтрокаТаблицы = Неопределено Тогда
		СтрокаТаблицы = ЭлементыФормы.СвойстваСтроки.ТекущиеДанные;
	КонецЕсли; 
	СтрокаТаблицы.ПредставлениеЗначения = СтрокаТаблицы.Значение;
	ирОбщий.ОбновитьТипЗначенияВСтрокеТаблицыЛкс(СтрокаТаблицы);
	ДействияФормыТекущаяСтрока();
	
КонецПроцедуры

Процедура ДействияФормыРедакторОбъектаБД(Кнопка)
	
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.СвойстваСтроки);
	
КонецПроцедуры

Процедура ДействияФормыСравнить(Кнопка)
	
	ирОбщий.СравнитьСодержимоеЭлементаУправленияЛкс(ЭлементыФормы.СвойстваСтроки);
	
КонецПроцедуры

Процедура СвойстваСтрокиПриАктивизацииСтроки(Элемент)
	
	Если ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ЭлементыФормы.СвойстваСтроки.Колонки.ПредставлениеЗначения.ТолькоПросмотр = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.ТолькоПросмотр;
	
КонецПроцедуры

Процедура ДействияФормыТекущаяКолонкаИсточника(Кнопка = Неопределено)
	
	ТабличноеПоле = КлючУникальности;
	ИмяКолонкиДанных = ирОбщий.ПутьКДаннымКолонкиТабличногоПоляЛкс(ТабличноеПоле);
	Если ЗначениеЗаполнено(ИмяКолонкиДанных) Тогда
		ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока = СвойстваСтроки.Найти(ИмяКолонкиДанных, "Данные");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДействияФормыТекущаяСтрока(Кнопка = Неопределено)
	
	ТабличноеПоле = КлючУникальности;
	ТекущаяСтрокаИсточника = ирОбщий.ДанныеСтрокиТабличногоПоляЛкс(ТабличноеПоле);
	Если ТекущаяСтрокаИсточника = Неопределено Тогда
		ЗагрузитьДанныеСтроки();
		Возврат;
	КонецЕсли; 
	ТекущаяСтрокаСвойства = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока;
	Если Колонки[ТекущаяСтрокаСвойства.Имя].Видимость Тогда
		Если ТипЗнч(ТабличноеПоле) = Тип("ТабличноеПоле") Тогда 
			ТабличноеПоле.ТекущаяКолонка = Колонки[ТекущаяСтрокаСвойства.Имя];
		Иначе
			ТабличноеПоле.ТекущийЭлемент = Колонки[ТекущаяСтрокаСвойства.Имя];
		КонецЕсли; 
	КонецЕсли; 
	ТекущаяСтрокаИсточника[ТекущаяСтрокаСвойства.Данные] = ТекущаяСтрокаСвойства.Значение;
	
КонецПроцедуры

Процедура СвойстваСтрокиПредставлениеЗначенияНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ТабличноеПоле = КлючУникальности;
	Если СвязиИПараметрыВыбора Тогда
		Если ЗначениеЗаполнено(ИмяТаблицыБД) Тогда
			ПоляТаблицыБД = ирКэш.ПолучитьПоляТаблицыБДЛкс(ИмяТаблицыБД);
			ИмяПоляТаблицы = ТабличноеПоле.ТекущаяКолонка.Имя;
			МетаРеквизит = ПоляТаблицыБД.Найти(ИмяПоляТаблицы, "Имя").Метаданные;
			СтруктураОтбора = ирОбщий.ПолучитьСтруктуруОтбораПоСвязямИПараметрамВыбораЛкс(ТабличноеПоле.ТекущаяСтрока, МетаРеквизит);
		КонецЕсли; 
	КонецЕсли; 
	ЭлементыФормы.СвойстваСтроки.Колонки.ПредставлениеЗначения.ЭлементУправления.ОграничениеТипа = ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.ОписаниеТипов;
	Если ирОбщий.ПолеВводаКолонкиРасширенногоЗначения_НачалоВыбораЛкс(ЭлементыФормы.СвойстваСтроки, СтандартнаяОбработка, ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.Значение, Истина, СтруктураОтбора) Тогда 
		ОбновитьПредставлениеИТипЗначенияВСтроке();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СвойстваСтрокиПредставлениеЗначенияОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка)
	
	ирОбщий.ПолеВвода_ОкончаниеВводаТекстаЛкс(Элемент, Текст, Значение, СтандартнаяОбработка, ЭлементыФормы.СвойстваСтроки.ТекущаяСтрока.Значение);

КонецПроцедуры

Процедура ПриПовторномОткрытии(СтандартнаяОбработка)
	
	ОбновитьСоставСвойств();

КонецПроцедуры

Процедура СвойстваСтрокиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Ложь
		Или Колонка = ЭлементыФормы.СвойстваСтроки.Колонки.Имя
		Или Колонка = ЭлементыФормы.СвойстваСтроки.Колонки.Представление 
	Тогда
		ДействияФормыТекущаяСтрока();
	КонецЕсли; 
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СтрокаТаблицы");
СвойстваСтроки.Колонки.Добавить("Значение");
ЭтаФорма.СвязиИПараметрыВыбора = Истина;
