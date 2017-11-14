﻿Перем мСоответствиеРежимовОбновления;

Процедура ПриОткрытии()
	
	лОбновлениеПредопределенныхДанных = Вычислить("ОбновлениеПредопределенныхДанных");
	РежимыОбновления = Новый Массив;
	РежимыОбновления.Добавить(лОбновлениеПредопределенныхДанных.Авто);
	РежимыОбновления.Добавить(лОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически);
	РежимыОбновления.Добавить(лОбновлениеПредопределенныхДанных.ОбновлятьАвтоматически);
	мСоответствиеРежимовОбновления = Новый Соответствие;
	СписокВыбораРежимаОбновления = Новый СписокЗначений;
	Для Каждого лРежимОбновления Из РежимыОбновления Цикл
		мСоответствиеРежимовОбновления["" + лРежимОбновления] = лРежимОбновления;
		СписокВыбораРежимаОбновления.Добавить("" + лРежимОбновления);
	КонецЦикла;
	ЭлементыФормы.РежимОбновления.СписокВыбора = СписокВыбораРежимаОбновления;
	ЭлементыФормы.Типы.Колонки.РежимОбновления.ЭлементУправления.СписокВыбора = СписокВыбораРежимаОбновления;
	КоманднаяПанельНайденныеОбъектыОбновить();
	
КонецПроцедуры

Процедура КоманднаяПанельНайденныеОбъектыОбновить(Кнопка = Неопределено, ПолноеИмяМД = "")
	
	ЭтотОбъект.РежимОбновления = Вычислить("ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы()");
	ТекущийПредопределеный = ЭлементыФормы.Данные.ТекущаяСтрока;
	Если ТекущийПредопределеный <> Неопределено Тогда
		ТекущийПредопределеный = ТекущийПредопределеный.ИмяПредопределенного;
	КонецЕсли; 
	НачальноеКоличество = Данные.Количество(); 
	Для СчетчикДанные = 1 По НачальноеКоличество Цикл
		СтрокаДанных = Данные[НачальноеКоличество - СчетчикДанные];
		Если Ложь
			Или Не ЗначениеЗаполнено(ПолноеИмяМД) 
			Или СтрокаДанных.ИмяТипаСсылки = ПолноеИмяМД
		Тогда 
			Данные.Удалить(СтрокаДанных);
		КонецЕсли;
	КонецЦикла;
	СтрокиМетаОбъектов = мПлатформа.ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
	Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
		Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
		Если Истина
			И ирОбщий.ЛиКорневойТипОбъектаСПредопределеннымЛкс(Единственное) 
			И (Ложь
				Или Не ЗначениеЗаполнено(ПолноеИмяМД) 
				Или ирОбщий.ПолучитьПервыйФрагментЛкс(ПолноеИмяМД) = Единственное)
		Тогда 
			ТекстЗапроса = "";
			Для Каждого ОбъектМД Из Метаданные[СтрокаТаблицыМетаОбъектов.Множественное] Цикл
				Если Ложь
					Или Не ЗначениеЗаполнено(ПолноеИмяМД) 
					Или ОбъектМД.ПолноеИмя() = ПолноеИмяМД
				Тогда 
					ПолноеИмя = "";
					Для Каждого ИмяЭлемента Из ОбъектМД.ПолучитьИменаПредопределенных() Цикл
						Если ПолноеИмя = "" Тогда
							ПолноеИмя = ОбъектМД.ПолноеИмя();
							Если ТекстЗапроса <> "" Тогда
								ТекстЗапроса = ТекстЗапроса + "
								|ОБЪЕДИНИТЬ ВСЕ";
							КонецЕсли; 
							ТекстЗапроса = ТекстЗапроса + "
							|ВЫБРАТЬ МАКСИМУМ(Т.Ссылка) КАК Ссылка, КОЛИЧЕСТВО(*) КАК КоличествоДанных, Т.ИмяПредопределенныхДанных, """ + ПолноеИмя + """ КАК ИмяТипаСсылки
							|ИЗ " + ПолноеИмя + " КАК Т 
							|ГДЕ Т.ИмяПредопределенныхДанных <> """"
							|СГРУППИРОВАТЬ ПО """ + ПолноеИмя + """, Т.ИмяПредопределенныхДанных";
						КонецЕсли; 
						СтрокаДанных = Данные.Добавить();
						СтрокаДанных.ИмяТипаСсылки = ПолноеИмя;
						СтрокаДанных.ИмяПредопределенного = ИмяЭлемента;
						СтрокаДанных.КоличествоВсего = 1;
						СтрокаДанных.КоличествоОтсутствующих = 1;
						СтрокаДанных.Ссылка = ПредопределенноеЗначение(ПолноеИмя + ".ПустаяСсылка");
					КонецЦикла;
				КонецЕсли; 
			КонецЦикла;
			Если ЗначениеЗаполнено(ТекстЗапроса) Тогда
				// Антибаг платформы 8.3 в запросе поле ИмяПредопределенныхДанных не удается сравнить с другим полем https://partners.v8.1c.ru/forum/t/1388262/m/1388262
				//Запрос = Новый Запрос("ВЫБРАТЬ * ПОМЕСТИТЬ ИменаПредопределенных ИЗ &ИменаПредопределенных КАК ИменаПредопределенных;
				//|ВЫБРАТЬ ИменаПредопределенных.ИмяПредопределенного, ИменаПредопределенных.ИмяТипаСсылки, Ссылки.* 
				//|ИЗ ИменаПредопределенных ЛЕВОЕ СОЕДИНЕНИЕ (" + ТекстЗапроса + ") КАК Ссылки ПО ИменаПредопределенных.ИмяПредопределенного = Ссылки.ИмяПредопределенныхДанных
				//|УПОРЯДОЧИТЬ ПО ИменаПредопределенных.ИмяТипаСсылки, ИменаПредопределенных.ИмяПредопределенного");
				//Запрос.Параметры.Вставить("ИменаПредопределенных", Данные);
				//Данные.Загрузить(Запрос.Выполнить().Выгрузить());
				Запрос = Новый Запрос(ТекстЗапроса);
				ТаблицаРезультата = Запрос.Выполнить().Выгрузить();
				Для Каждого СтрокаРезультата Из ТаблицаРезультата Цикл
					СтрокиДанных = Данные.НайтиСтроки(Новый Структура("ИмяТипаСсылки, ИмяПредопределенного", СтрокаРезультата.ИмяТипаСсылки, СтрокаРезультата.ИмяПредопределенныхДанных));
					Если СтрокиДанных.Количество() > 0 Тогда
						СтрокаДанных = СтрокиДанных[0];
						ЗаполнитьЗначенияСвойств(СтрокаДанных, СтрокаРезультата);
						СтрокаДанных.КоличествоОтсутствующих = 0;
						Если СтрокаРезультата.КоличествоДанных > 1 Тогда
							СтрокаДанных.КоличествоЗадублированных = 1;
						Иначе
							СтрокаДанных.КоличествоЗадублированных = 0;
						КонецЕсли; 
						СтрокаДанных.Идентификатор = СтрокаРезультата.Ссылка.УникальныйИдентификатор();
					Иначе
						Сообщить("Проигнорирован элемент типа " + СтрокаРезультата.ИмяТипаСсылки + " с недействительным именем предопределенного (" + СтрокаРезультата.ИмяПредопределенныхДанных + ")");
					КонецЕсли; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	Данные.Сортировать("ИмяПредопределенного");
	Если ТекущийПредопределеный <> Неопределено Тогда
		ЭлементыФормы.Данные.ТекущаяСтрока = Данные.Найти(ТекущийПредопределеный, "ИмяПредопределенного");
	КонецЕсли; 
	ОбновитьТипы();
	
КонецПроцедуры

Процедура ОбновитьТипы()
	
	ТекущийТип = ЭлементыФормы.Типы.ТекущаяСтрока;
	Если ТекущийТип <> Неопределено Тогда
		ТекущийТип = ТекущийТип.ИмяТипаСсылки;
	КонецЕсли; 
	Типы.Очистить();
	КопияДанных = Данные.Выгрузить();
	КопияДанных.Свернуть("ИмяТипаСсылки", "КоличествоЗадублированных, КоличествоОтсутствующих, КоличествоВсего");
	Типы.Загрузить(КопияДанных);
	лОбновлениеПредопределенныхДанных = Вычислить("ОбновлениеПредопределенныхДанных");
	лОбновлениеПредопределенныхДанныхБазы = Вычислить("ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы()");
	Для Каждого СтрокаТипа Из Типы Цикл
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(СтрокаТипа.ИмяТипаСсылки);
		СтрокаТипа.ПредставлениеТипаСсылки = ОбъектМД.Представление();
		МенеджерМД = Новый (СтрЗаменить(СтрокаТипа.ИмяТипаСсылки, ".", "Менеджер."));
		СтрокаТипа.РежимОбновления = МенеджерМД.ПолучитьОбновлениеПредопределенныхДанных();
		СтрокаТипа.РежимОбновленияИзМетаданных = ОбъектМД.ОбновлениеПредопределенныхДанных;
		ПроверяемыйРежим = МенеджерМД.ПолучитьОбновлениеПредопределенныхДанных();
		Если ПроверяемыйРежим <> лОбновлениеПредопределенныхДанных.Авто Тогда
			СтрокаТипа.РежимОбновленияРезультирующий = ПроверяемыйРежим;
		Иначе
			ПроверяемыйРежим = ОбъектМД.ОбновлениеПредопределенныхДанных;
			Если ПроверяемыйРежим <> Метаданные.СвойстваОбъектов.ОбновлениеПредопределенныхДанных.Авто Тогда
				СтрокаТипа.РежимОбновленияРезультирующий = ПроверяемыйРежим;
			Иначе
				Если лОбновлениеПредопределенныхДанныхБазы <> Метаданные.СвойстваОбъектов.ОбновлениеПредопределенныхДанных.Авто Тогда
					СтрокаТипа.РежимОбновленияРезультирующий = лОбновлениеПредопределенныхДанныхБазы;
				Иначе
					Если ПланыОбмена.ГлавныйУзел() = Неопределено Тогда 
						СтрокаТипа.РежимОбновленияРезультирующий = лОбновлениеПредопределенныхДанных.ОбновлятьАвтоматически;
					Иначе
						СтрокаТипа.РежимОбновленияРезультирующий = лОбновлениеПредопределенныхДанных.НеОбновлятьАвтоматически;
					КонецЕсли; 
				КонецЕсли;
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	Типы.Сортировать("ПредставлениеТипаСсылки");
	Если ТекущийТип <> Неопределено Тогда
		ЭлементыФормы.Типы.ТекущаяСтрока = Типы.Найти(ТекущийТип, "ИмяТипаСсылки");
	КонецЕсли;

КонецПроцедуры

Процедура ИмяПредставлениеПриИзменении(Элемент)
	
	ТабличноеПоле = ЭлементыФормы.Типы;
	ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость = Не ИмяПредставление;
	ТабличноеПоле.Колонки.ИмяТипаСсылки.Видимость = ИмяПредставление;
	СтараяКолонка = ТабличноеПоле.ТекущаяКолонка;
	Если СтараяКолонка <> Неопределено Тогда
		Если Найти(НРег(СтараяКолонка.Имя), "типассылки") > 0 Тогда
			Если ТабличноеПоле.Колонки.ПредставлениеТипаСсылки.Видимость Тогда
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ПредставлениеТипаСсылки;
			Иначе
				ТабличноеПоле.ТекущаяКолонка = ТабличноеПоле.Колонки.ИмяТипаСсылки;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_СвязанныеДанныеМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Данные, ЭтаФорма);

КонецПроцедуры

Процедура ТипыПриАктивизацииСтроки(Элемент)
	
	//ТекущийПредопределеный = ЭлементыФормы.Данные.ТекущаяСтрока;
	//Если ТекущийПредопределеный <> Неопределено Тогда
	//	ТекущийПредопределеный = ТекущийПредопределеный.ИмяПредопределенного;
	//КонецЕсли; 
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ИмяТипаСсылки = ЭлементыФормы.Типы.ТекущаяСтрока.ИмяТипаСсылки;
	ЭлементыФормы.Данные.ОтборСтрок.ИмяТипаСсылки.Установить(ИмяТипаСсылки);
	ЭлементыФормы.Данные.Колонки.Ссылка.ЭлементУправления.ОграничениеТипа = Новый ОписаниеТипов(ирОбщий.ИмяТипаИзПолногоИмениТаблицыБДЛкс(ИмяТипаСсылки));
	//Если ТекущийПредопределеный <> Неопределено Тогда
	//	ЭлементыФормы.Данные.ТекущаяСтрока = Данные.Найти(ТекущийПредопределеный, "ИмяПредопределенного");
	//КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеСсылкаПриИзменении(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.Данные.ТекущаяСтрока;
	СтарыеСсылки = ПолучитьДанныеТекущегоЭлемента();
	Если СтарыеСсылки.Количество() > 0 Тогда 
		СтарыйПредопределенный = СтарыеСсылки[0];
		Если СтарыеСсылки.Количество() > 1 Тогда
			Сообщить("Сначала необходимо избавиться от дублей");
			Элемент.Значение = СтарыйПредопределенный;
			Возврат;
		КонецЕсли; 
	КонецЕсли; 
	НачатьТранзакцию();
	Если ЗначениеЗаполнено(СтарыйПредопределенный) Тогда
		Объект = СтарыйПредопределенный.ПолучитьОбъект();
		Объект.ИмяПредопределенныхДанных = "";
		ирОбщий.ЗаписатьОбъектЛкс(Объект, ЗаписьНаСервере,,, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		ТекущаяСтрока.КоличествоОтсутствующих = 1;
		ТекущаяСтрока.КоличествоДанных = 0;
		ТекущаяСтрока.Идентификатор = Неопределено;
	КонецЕсли; 
	НовыйПредопределенный = Элемент.Значение;
	Если ЗначениеЗаполнено(НовыйПредопределенный) Тогда
		Объект = НовыйПредопределенный.ПолучитьОбъект();
		Объект.ИмяПредопределенныхДанных = ТекущаяСтрока.ИмяПредопределенного;
		ирОбщий.ЗаписатьОбъектЛкс(Объект, ЗаписьНаСервере,,, ОтключатьКонтрольЗаписи, БезАвторегистрацииИзменений);
		ТекущаяСтрока.КоличествоОтсутствующих = 0;
		ТекущаяСтрока.КоличествоДанных = 1;
		ТекущаяСтрока.Идентификатор = НовыйПредопределенный.УникальныйИдентификатор();
	КонецЕсли; 
	ЗафиксироватьТранзакцию();
	КоманднаяПанельНайденныеОбъектыОбновить(, ЭлементыФормы.Типы.ТекущаяСтрока.ИмяТипаСсылки);
	
КонецПроцедуры

Функция ПолучитьДанныеТекущегоЭлемента()
	
	ТекущаяСтрока = ЭлементыФормы.Данные.ТекущаяСтрока;
	Запрос = Новый Запрос("ВЫБРАТЬ Т.Ссылка ИЗ " + ТекущаяСтрока.ИмяТипаСсылки + " КАК Т ГДЕ Т.ИмяПредопределенныхДанных = &ИмяПредопределенного");
	Запрос.Параметры.Вставить("ИмяПредопределенного", ТекущаяСтрока.ИмяПредопределенного);
	МассивСсылок = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
	ТекущаяСтрока.КоличествоДанных = МассивСсылок.Количество();
	Если ТекущаяСтрока.КоличествоДанных > 1 Тогда
		ТекущаяСтрока.КоличествоЗадублированных = 1;
	Иначе
		ТекущаяСтрока.КоличествоЗадублированных = 0;
	КонецЕсли; 
	Возврат МассивСсылок
	
КонецФункции

Процедура ГлавнаяКоманднаяПанельНовоеОкно(Кнопка)
	
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);

КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельОПодсистеме(Кнопка)
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
КонецПроцедуры

Процедура РежимОбновленияПриИзменении(Элемент)
	
	Если Не ЗначениеЗаполнено(Элемент.Значение) Тогда
		Элемент.Значение = Вычислить("ПолучитьОбновлениеПредопределенныхДанныхИнформационнойБазы()");
		Возврат;
	КонецЕсли; 
	НовыйРежим = мСоответствиеРежимовОбновления[Элемент.Значение];
	Выполнить("УстановитьОбновлениеПредопределенныхДанныхИнформационнойБазы(НовыйРежим)");
	ОбновитьТипы();
	
КонецПроцедуры

Процедура ТипыРежимОбновленияПриИзменении(Элемент)
	
	ТекущаяСтрока = ЭлементыФормы.Типы.ТекущаяСтрока;
	МенеджерМД = Новый (СтрЗаменить(ТекущаяСтрока.ИмяТипаСсылки, ".", "Менеджер."));
	Если Не ЗначениеЗаполнено(ТекущаяСтрока.РежимОбновления) Тогда
		ТекущаяСтрока.РежимОбновления = МенеджерМД.ПолучитьОбновлениеПредопределенныхДанных();
		Возврат;
	КонецЕсли; 
	МенеджерМД.УстановитьОбновлениеПредопределенныхДанных(мСоответствиеРежимовОбновления[ТекущаяСтрока.РежимОбновления]);
	ОбновитьТипы();

КонецПроцедуры

Процедура КП_СвязанныеДанныеОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.Данные);
	
КонецПроцедуры

Процедура КоманднаяПанельТипыОтборБезЗначения(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.Типы);
	
КонецПроцедуры

Процедура ТипыПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.КоличествоОтсутствующих > 0 Или ДанныеСтроки.КоличествоЗадублированных > 0 Тогда
		ОформлениеСтроки.ЦветФона = ирОбщий.ПолучитьЦветСтиляЛкс("ирЦветФонаОшибки");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.КоличествоОтсутствующих > 0 Или ДанныеСтроки.КоличествоЗадублированных > 0 Тогда
		ОформлениеСтроки.ЦветФона = ирОбщий.ПолучитьЦветСтиляЛкс("ирЦветФонаОшибки");
	КонецЕсли; 

КонецПроцедуры

Процедура КП_ДанныеОткрытьТаблицу(Кнопка)
	
	ирОбщий.ОткрытьЗначениеЛкс(Данные.Выгрузить(), Ложь,,,,, ЭлементыФормы.Данные);

КонецПроцедуры

Процедура КП_ДанныеКонсольОбработки(Кнопка)
	
	ирОбщий.ОткрытьОбъектыИзВыделенныхЯчеекВПодбореИОбработкеОбъектовЛкс(ЭлементыФормы.Данные);
	
КонецПроцедуры

Процедура КП_ДанныеРедакторОбъектаБД(Кнопка)
	
	Если ЭлементыФормы.Данные.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ОткрытьОбъект();
	
КонецПроцедуры

Процедура ОткрытьОбъект()
	
	СсылкаПредопределенного = ЭлементыФормы.Данные.ТекущаяСтрока.Ссылка;
	Если ЗначениеЗаполнено(СсылкаПредопределенного) Тогда
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(СсылкаПредопределенного);
	Иначе
		Ответ = Вопрос("Хотите создать объект для преодпреленного элемента?", РежимДиалогаВопрос.ОКОтмена);
		Если Ответ = КодВозвратаДиалога.ОК Тогда
			ПредопределенныйОбъект = ирОбщий.СоздатьСсылочныйОбъектПоМетаданнымЛкс(СсылкаПредопределенного.Метаданные());
			ПредопределенныйОбъект.ИмяПредопределенныхДанных = ЭлементыФормы.Данные.ТекущаяСтрока.ИмяПредопределенного;
			ирОбщий.ОткрытьОбъектВРедактореОбъектаБДЛкс(ПредопределенныйОбъект);
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда
		Сообщить("Инструмент доступен только в режиме совместимости 8.3.4 и выше");
		Отказ = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДанныеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Колонка = ЭлементыФормы.Данные.Колонки.КоличествоДанных Тогда
		КП_ДанныеОткрытьДубли();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_ДанныеОткрытьДубли(Кнопка = Неопределено)
	
	МассивСсылок = ПолучитьДанныеТекущегоЭлемента();
	//ОбновитьТипы();
	Если МассивСсылок.Количество() > 1 Тогда
		ФормаОбработки = ирОбщий.ПолучитьФормуЛкс("Обработка.ирПоискДублейИЗаменаСсылок.Форма");
		ФормаОбработки.ОткрытьДляЗаменыПоСпискуСсылок(МассивСсылок,, 0);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельИТС(Кнопка)
	
	ЗапуститьПриложение("http://its.1c.ru/db/metod8dev#content:5367:hdoc");
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельИнициализироватьВсеПредопределенные(Кнопка)
	
	Ответ = Вопрос("Инициализировать все предопределенные данные текущей области?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Выполнить("ИнициализироватьПредопределенныеДанные()");
	КонецЕсли;
	
КонецПроцедуры

Процедура ГлавнаяКоманднаяПанельСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ДанныеСсылкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ирОбщий.ОткрытьФормуСпискаЛкс(Элемент.Значение.Метаданные().ПолноеИмя(), , , Элемент, Истина,, Элемент.Значение);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);

КонецПроцедуры

Процедура ДанныеСсылкаОткрытие(Элемент, СтандартнаяОбработка)
	
	Если Не ЗначениеЗаполнено(Элемент.Значение) Тогда
		ОткрытьОбъект();
		СтандартнаяОбработка = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КП_ДанныеОбновить(Кнопка = Неопределено)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	КоманднаяПанельНайденныеОбъектыОбновить(, ЭлементыФормы.Типы.ТекущаяСтрока.ИмяТипаСсылки);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельТипыОткрытьОбъектМетаданных(Кнопка)
	
	Если ЭлементыФормы.Типы.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ОткрытьОбъектМетаданныхЛкс(ЭлементыФормы.Типы.ТекущаяСтрока.ИмяТипаСсылки);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПредопределенных.Форма.Форма");
