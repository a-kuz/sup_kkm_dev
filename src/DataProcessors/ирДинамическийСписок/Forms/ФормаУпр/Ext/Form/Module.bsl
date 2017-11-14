﻿
Процедура УстановитьОбъектМетаданных(ПолноеИмяТаблицы = Неопределено) Экспорт

	ЭлементыФормы = Элементы;
	Если ПолноеИмяТаблицы <> Неопределено Тогда
		ЗначениеИзменено = Ложь;
		ирОбщий.ПрисвоитьЕслиНеРавноЛкс(фОбъект.ОбъектМетаданных, ПолноеИмяТаблицы, ЗначениеИзменено);
		Если Не ЗначениеИзменено Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли;
	Если ЭлементыФормы.Найти("ДинамическийСписокВременноеПоле") <> Неопределено Тогда
		Элементы.ДинамическийСписокВременноеПоле.Видимость = Ложь;
		Элементы.Переместить(Элементы.ДинамическийСписокВременноеПоле, ЭтаФорма);
	КонецЕсли; 
	Элементы.ДинамическийСписок.Видимость = Истина;
	ЭлементыФормы.ДинамическийСписок.ИзменятьСоставСтрок = Истина;
	МассивФрагментов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(фОбъект.ОбъектМетаданных);
	ОсновнойЭУ = ЭлементыФормы.ДинамическийСписок;
	ОсновнойЭУ.РежимВыбора = РежимВыбора;
	ДинамическийСписок.ОсновнаяТаблица = фОбъект.ОбъектМетаданных;
	ирСервер.НастроитьАвтоТаблицуФормыДинамическогоСпискаЛкс(ЭтаФорма, ОсновнойЭУ, фОбъект.РежимИмяСиноним);
	ПредставлениеТаблицы = ирОбщий.ПолучитьОписаниеТаблицыБДИис(фОбъект.ОбъектМетаданных).Представление;
	ирОбщий.ОбновитьТекстПослеМаркераВСтрокеЛкс(ЭтаФорма.Заголовок,, ПредставлениеТаблицы, ": ");
	Если РежимВыбора Тогда
		ЭтаФорма.Заголовок = ЭтаФорма.Заголовок + " (выбор)";
	КонецЕсли; 
	КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(фОбъект.ОбъектМетаданных);
	фОбъект.ВместоОсновной = ирОбщий.ПолучитьИспользованиеДинамическогоСпискаВместоОсновнойФормыЛкс(фОбъект.ОбъектМетаданных);
	ирСервер.УправляемаяФорма_ОбновитьСлужебныеДанныеЛкс(ЭтаФорма,, ПоляСИсториейВыбора());
	//Попытка
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Наименование.ОтображатьИерархию = Истина;
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.ОтображатьИерархию = Ложь;
	//	ЭлементыФормы.ДинамическийСписок.Колонки.Картинка.Видимость = Ложь;
	//Исключение
	//КонецПопытки;
	//ЭлементыФормы.КоманднаяПанельПереключателяДерева.Кнопки.РежимДерева.Доступность = ирОбщий.ЛиМетаданныеИерархическогоОбъектаЛкс(ОбъектМД);
	//ирОбщий.НастроитьТабличноеПолеЛкс(ОсновнойЭУ);
	ЗагрузитьНастройкиКолонок();
	фОбъект.СтарыйОбъектМетаданных = фОбъект.ОбъектМетаданных;
	ирОбщий.ПоследниеВыбранныеЗаполнитьПодменюЛкс(ЭтаФорма, ЭлементыФормы.ПоследниеВыбранные);
	РезультирующаяСхема = Элементы.ДинамическийСписок.ПолучитьИсполняемуюСхемуКомпоновкиДанных();
	//АдресСхемы = ПоместитьВоВременноеХранилище(РезультирующаяСхема, ЭтаФорма.УникальныйИдентификатор);
	
КонецПроцедуры

Процедура ЗагрузитьНастройкиКолонок()
	
	СохраненныеНастройки = ХранилищеОбщихНастроек.Загрузить(ирОбщий.ИмяПродуктаЛкс(), "ДинамическийСписок." + фОбъект.ОбъектМетаданных + "." + РежимВыбора);
	Если СохраненныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.НастройкиКолонок.Загрузить(СохраненныеНастройки);
	НачальноеКоличество = фОбъект.НастройкиКолонок.Количество(); 
	КолонкиТП = Элементы.ДинамическийСписок.ПодчиненныеЭлементы;
	Для Счетчик = 1 По НачальноеКоличество Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок[НачальноеКоличество - Счетчик];
		КолонкаТП = КолонкиТП.Найти(ОписаниеКолонки.Имя);
		Если КолонкаТП <> Неопределено Тогда
			//КолонкиТП.Сдвинуть(КолонкаТП, -КолонкиТП.Индекс(КолонкаТП));
			Элементы.Переместить(КолонкаТП, КолонкаТП.Родитель, КолонкиТП[0]);
			ЗаполнитьЗначенияСвойств(КолонкаТП, ОписаниеКолонки,, "Имя"); 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

Процедура СохранитьНастройкиКолонок()
	
	Если Не ЗначениеЗаполнено(фОбъект.СтарыйОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли; 
	фОбъект.НастройкиКолонок.Очистить();
	Для Каждого КолонкаТП Из Элементы.ДинамическийСписок.ПодчиненныеЭлементы Цикл
		ОписаниеКолонки = фОбъект.НастройкиКолонок.Добавить();
		ЗаполнитьЗначенияСвойств(ОписаниеКолонки, КолонкаТП); 
	КонецЦикла;
	ХранилищеОбщихНастроек.Сохранить(ирОбщий.ИмяПродуктаЛкс(), "ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, фОбъект.НастройкиКолонок.Выгрузить());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхПриИзменении(Элемент)
	СохранитьНастройкиКолонок();
	ЭтаФорма.КлючУникальности = фОбъект.ОбъектМетаданных;
	ЭтаФорма.мКлючУникальности = ЭтаФорма.КлючУникальности;
	УстановитьОбъектМетаданных();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Элементы.ДинамическийСписок.Видимость = Ложь;
	ЭлементыФормы = Элементы;
	НачальноеЗначениеВыбора = Параметры.ТекущаяСтрока;
	ЭтаФорма.РежимВыбора = Параметры.РежимВыбора;
	ирСервер.УправляемаяФорма_ПриСозданииЛкс(ЭтаФорма, Отказ, СтандартнаяОбработка,, ПоляСИсториейВыбора());
	НовоеИмяТаблицы = Параметры.ИмяТаблицы;
	Если ЗначениеЗаполнено(НовоеИмяТаблицы) Тогда
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(НовоеИмяТаблицы);
		Если ОбъектМД <> Неопределено Тогда
			УстановитьОбъектМетаданных(НовоеИмяТаблицы);
		КонецЕсли;
	КонецЕсли; 
	Если Истина
		И ЗначениеЗаполнено(фОбъект.ОбъектМетаданных)
		И НачальноеЗначениеВыбора <> Неопределено 
		И ЗначениеЗаполнено(НачальноеЗначениеВыбора) 
	Тогда
		Если Ложь
			Или ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь)
			Или ирОбщий.ЛиСсылкаНаПеречислениеЛкс(НачальноеЗначениеВыбора)
			Или ирОбщий.ЛиКлючЗаписиРегистраЛкс(НачальноеЗначениеВыбора)
		Тогда
			ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = НачальноеЗначениеВыбора;
		//ИначеЕсли ирОбщий.ЛиСсылкаНаОбъектБДЛкс(НачальноеЗначениеВыбора, Ложь) Тогда 
		//	ДанныеСписка = ирОбщий.ПолучитьДанныеЭлементаУправляемойФормыЛкс(ЭлементыФормы.ДинамическийСписок); //
		//	ТекущаяСтрока = ДанныеСписка.Найти(НачальноеЗначениеВыбора, "Ссылка");
		//	Если ТекущаяСтрока <> Неопределено Тогда
		//		ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока = ТекущаяСтрока;
		//	КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	Если ЗначениеЗаполнено(фОбъект.ОбъектМетаданных) Тогда
		ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДинамическийСписок;
	КонецЕсли; 
	Если РежимВыбора Тогда
		ЭтаФорма.РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Функция ПоляСИсториейВыбора()
	
	Возврат Элементы.ОбъектМетаданных;

КонецФункции

&НаСервереБезКонтекста
Процедура ДинамическийСписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	
	#Если Сервер И Не Сервер Тогда
	    Настройки = Новый НастройкиКомпоновкиДанных;
	#КонецЕсли
	РасширенноеПредставлениеХранилищЗначений = Ложь;
	РасширенныеКолонки = Неопределено;
	ИменаКолонокСПиктограммамиТипов = Неопределено;
	КолонкиТаблицы = Настройки.Выбор.Элементы;
	ВариантОтображенияИдентификаторов = Неопределено;
	Настройки.ДополнительныеСвойства.Свойство("ОтображениеИдентификаторов", ВариантОтображенияИдентификаторов);
	СостоянияКнопки = ирОбщий.ПолучитьСостоянияКнопкиОтображатьПустыеИИдентификаторыЛкс();
	ЛиОтбражатьПустые = Ложь
		Или ВариантОтображенияИдентификаторов = СостоянияКнопки[1]
		Или ВариантОтображенияИдентификаторов = СостоянияКнопки[2];
	ОтображатьИдентификаторы = Ложь
			Или ВариантОтображенияИдентификаторов = СостоянияКнопки[2];
	ирПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
	    ирПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Если ТипЗнч(ИменаКолонокСПиктограммамиТипов) = Тип("Строка") Тогда
		ИменаКолонокСПиктограммамиТипов = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ИменаКолонокСПиктограммамиТипов, ",", Истина); 
	КонецЕсли; 
	Для Каждого СтрокаСписка Из Строки Цикл
		СтрокаОформления = СтрокаСписка.Значение;
		ДанныеСтроки = СтрокаОформления.Данные;
		Ячейки = СтрокаОформления.Оформление;
		Для Каждого Ячейка Из Ячейки Цикл
			//КолонкаОтображаетДанныеФлажка = Ложь;
			ЗначениеЯчейки = ДанныеСтроки[Ячейка.Ключ];
			//Если Ложь
			//	Или КолонкаОтображаетДанныеФлажка
			//	Или Формат(ЗначениеЯчейки, Колонка.Формат) = Ячейка.Текст 
			//Тогда // Здесь могут быть обращения к БД
				ПредставлениеЗначения = "";
				//Если Истина
				//	И Не КолонкаОтображаетДанныеФлажка
				//	И ТипЗнч(ЗначениеЯчейки) <> Тип("Строка") 
				//Тогда
				//	ПредставлениеЗначения = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(ЗначениеЯчейки, Колонка,, РасширенноеПредставлениеХранилищЗначений);
				//КонецЕсли; 
				Если ЛиОтбражатьПустые И Не ирОбщий.ЭтоКоллекцияЛкс(ЗначениеЯчейки) Тогда
					ЦветПустых = ирОбщий.ЦветФонаЯчеекПустыхЗначенийЛкс();
					Если ТипЗнч(ЗначениеЯчейки) = Тип("Строка") Тогда
						ПредставлениеЗначения = """" + ЗначениеЯчейки + """";
						Ячейка.Значение.УстановитьЗначениеПараметра("ЦветФона", ЦветПустых);
					Иначе
						Попытка
							ЗначениеНепустое = ЗначениеЗаполнено(ЗначениеЯчейки) И ЗначениеЯчейки <> Ложь;
						Исключение
							ЗначениеНепустое = Истина;
						КонецПопытки;
						Если Не ЗначениеНепустое Тогда
							ПредставлениеЗначения = ирПлатформа.мПолучитьПредставлениеПустогоЗначения(ЗначениеЯчейки);
							Ячейка.Значение.УстановитьЗначениеПараметра("ЦветФона", ЦветПустых);
						КонецЕсли;
					КонецЕсли; 
				КонецЕсли; 
				Если ПредставлениеЗначения <> "" Тогда
					Ячейка.Значение.УстановитьЗначениеПараметра("Текст", ПредставлениеЗначения);
				КонецЕсли; 
			//КонецЕсли; 
			Если ОтображатьИдентификаторы Тогда
				ИдентификаторСсылки = ирОбщий.ПолучитьИдентификаторСсылкиЛкс(ЗначениеЯчейки);
				Если ИдентификаторСсылки <> Неопределено Тогда
					XMLТип = XMLТипЗнч(ЗначениеЯчейки);
					ИдентификаторСсылки = ИдентификаторСсылки + "." + XMLТип.ИмяТипа;
				КонецЕсли; 
				Если ИдентификаторСсылки <> Неопределено Тогда
					Ячейка.Значение.УстановитьЗначениеПараметра("Текст", ИдентификаторСсылки);
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла;  
		Если Настройки.ДоступныеПоляВыбора.НайтиПоле(Новый ПолеКомпоновкиДанных("ИдентификаторСсылкиЛкс")) <> Неопределено Тогда
			ЯчейкаИдентификатора = Ячейки["ИдентификаторСсылкиЛкс"];
			Если ЯчейкаИдентификатора <> Неопределено Тогда
				Ссылка = ДанныеСтроки.Ссылка;
				Если ирОбщий.ЛиСсылкаНаПеречислениеЛкс(Ссылка) Тогда
					ИдентификаторСсылки = "" + XMLСтрока(Ссылка);
				Иначе
					ИдентификаторСсылки = "" + ирОбщий.ПолучитьИдентификаторСсылкиЛкс(Ссылка);
				КонецЕсли; 
				ЯчейкаИдентификатора.УстановитьЗначениеПараметра("Текст", ИдентификаторСсылки);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ирОбщий.ДинамическийСписок_ОбъектМетаданных_НачалоВыбора(ЭтаФорма, Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

&НаКлиенте
Процедура ОбъектОбъектМетаданныхОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		СтандартнаяОбработка = Ложь;
		лПолноеИмяОбъекта = Неопределено;
		Если ВыбранноеЗначение.Свойство("ПолноеИмяОбъекта", лПолноеИмяОбъекта) Тогда
			фОбъект.ОбъектМетаданных = ВыбранноеЗначение.ПолноеИмяОбъекта;
			ОбъектОбъектМетаданныхПриИзменении(Элемент);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура РедакторОбъектаБДСтроки(Команда)
	
	ирОбщий.ОткрытьТекущуюСтрокуТабличногоПоляТаблицыБДВРедактореОбъектаБДЛкс(Элементы.ДинамическийСписок, фОбъект.ОбъектМетаданных);
	
КонецПроцедуры

&НаКлиенте
Процедура РедакторОбъектаБДЯчейки(Команда)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ОткрытьСсылкуЯчейкиВРедактореОбъектаБДЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

&НаСервере
Процедура ОбъектРежимИмяСинонимПриИзмененииНаСервере()
	ирСервер.НастроитьЗаголовкиАвтоТаблицыФормыДинамическогоСпискаЛкс(Элементы.ДинамическийСписок, фОбъект.РежимИмяСиноним);
КонецПроцедуры

&НаКлиенте
Процедура ОбъектРежимИмяСинонимПриИзменении(Элемент)
	ОбъектРежимИмяСинонимПриИзмененииНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура НовоеОкно(Команда)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Функция Отбор() Экспорт 
	Возврат ДинамическийСписок.Отбор;
КонецФункции

&НаКлиенте
Функция ПользовательскийОтбор() Экспорт 
	
	НастройкиСписка = ирОбщий.НастройкиДинамическогоСпискаЛкс(ДинамическийСписок, "Пользовательские");
	Возврат НастройкиСписка.Отбор;
	
КонецФункции

&НаКлиенте
Процедура ОсновнаяФорма(Команда)
	
	ЭлементыФормы = Элементы;
	МножественныйВыбор = ЭлементыФормы.ДинамическийСписок.МножественныйВыбор;
	
	Если Не ЗначениеЗаполнено(фОбъект.ОбъектМетаданных) Тогда
		Возврат;
	КонецЕсли; 
	Если РежимВыбора Тогда
		Закрыть();
	КонецЕсли; 
	//Попытка
		Отбор = ДинамическийСписок.Отбор;
	//Исключение
	//	Отбор = Неопределено;
	//КонецПопытки;
	Форма = ирОбщий.ОткрытьФормуСпискаЛкс(фОбъект.ОбъектМетаданных, Отбор, Ложь, ВладелецФормы, РежимВыбора, МножественныйВыбор, ЭлементыФормы.ДинамическийСписок.ТекущаяСтрока);
	Если Форма = Неопределено Тогда
		ЭтаФорма.Открыть();
	КонецЕсли; 

КонецПроцедуры

&НаКлиенте
Процедура СброситьНастройкиКолонок(Команда)
	СброситьНастройкиКолонокНаСервере();
КонецПроцедуры

&НаСервере
Процедура СброситьНастройкиКолонокНаСервере()
	
	ХранилищеОбщихНастроек.Сохранить(ирОбщий.ИмяПродуктаЛкс(), "ДинамическийСписок." + фОбъект.СтарыйОбъектМетаданных + "." + РежимВыбора, Неопределено);
	УстановитьОбъектМетаданных();
	
КонецПроцедуры

&НаСервере
Процедура СколькоСтрокНаСервере()
	ЭлементыФормы = Элементы;
	ирОбщий.ТабличноеПолеИлиТаблицаФормы_СколькоСтрокЛкс(ЭлементыФормы.ДинамическийСписок);
КонецПроцедуры

&НаКлиенте
Процедура СколькоСтрок(Команда)
	СколькоСтрокНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ВыделитьНужноеКоличество(Команда)
	
	Количество = 10;
	Если Не ВвестиЧисло(Количество, "Введите количество", 6, 0) Тогда
		Возврат;
	КонецЕсли; 
	Если Количество = 0 Тогда
		Возврат;
	КонецЕсли; 
	ВыделитьНужноеКоличествоНаСервере(Количество);

КонецПроцедуры

&НаСервере
Процедура ВыделитьНужноеКоличествоНаСервере(Знач Количество)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ВыделитьПервыеСтрокиДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок, Количество);

КонецПроцедуры

&НаКлиенте
Процедура РазличныеЗначенияКолонки(Команда)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ОткрытьРазличныеЗначенияКолонкиЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

&НаКлиенте
Процедура НастройкаСписка(Команда)
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ФиксированныеНастройки", ДинамическийСписок.КомпоновщикНастроек.ФиксированныеНастройки);
	ПараметрыФормы.Вставить("Настройки", ДинамическийСписок.КомпоновщикНастроек.Настройки);
	ПараметрыФормы.Вставить("ПользовательскиеНастройки", ДинамическийСписок.КомпоновщикНастроек.ПользовательскиеНастройки);
	ПараметрыФормы.Вставить("ИсточникДоступныхНастроек", ДинамическийСписок.КомпоновщикНастроек.ПолучитьИсточникДоступныхНастроек());
	ОткрытьФорму("Обработка.ирДинамическийСписок.Форма.НастройкиСпискаУпр", ПараметрыФормы, ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура ОПодсистеме(Команда)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьОбъекты(Команда)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ОткрытьПодборИОбработкуОбъектовИзТабличногоПоляДинамическогоСпискаЛкс(ЭлементыФормы.ДинамическийСписок);

КонецПроцедуры

&НаКлиенте
Процедура ОтборБезЗначенияВТекущейКолонке(Команда)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ВывестиСтроки(Команда)
	
	ЭлементыФормы = Элементы;
	ирОбщий.ВывестиСтрокиТабличногоПоляИПоказатьЛкс(ЭлементыФормы.ДинамическийСписок);
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьОтбор(Команда)
	
	ПользовательскиеНастройки = ирОбщий.НастройкиДинамическогоСпискаЛкс(ДинамическийСписок, "Пользовательские");
	Для Каждого ЭлементОтбора Из ПользовательскиеНастройки.Отбор.Элементы Цикл
		ЭлементОтбора.Использование = Ложь;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображениеИдентификаторов(Команда)
	
	ЭлементыФормы = Элементы;
	Кнопка = ЭлементыФормы.ФормаОтображениеИдентификаторов;
	ирОбщий.КнопкаОтображатьПустыеИИдентификаторыНажатиеЛкс(Кнопка);
	ДинамическийСписок.КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ОтображениеИдентификаторов", Кнопка.Заголовок);
	ЭлементыФормы.ДинамическийСписок.Обновить();
	
КонецПроцедуры

&НаКлиенте
Функция ПоследниеВыбранныеНажатие(Кнопка) Экспорт
	
	ЭлементыФормы = Элементы;
	ирОбщий.ПоследниеВыбранныеНажатиеЛкс(ЭтаФорма, ЭлементыФормы.ДинамическийСписок, , Кнопка);
	
КонецФункции

&НаКлиенте
Процедура ДинамическийСписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если РежимВыбора Тогда
		ирОбщий.ПоследниеВыбранныеДобавитьЛкс(ЭтаФорма, ВыбраннаяСтрока);
	КонецЕсли; 

КонецПроцедуры

