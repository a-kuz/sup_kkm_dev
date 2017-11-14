﻿Перем ОсновнойЭУ;
Перем мПлатформа;

Процедура КоманднаяПанельСпискаПользователейОПодсистеме(Кнопка)

	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейЖурналРегистрации(Кнопка)
	
	ТекущаяСтрока = ОсновнойЭУ.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	#Если Сервер И Не Сервер Тогда
		АнализЖурналаРегистрации = Обработки.ирАнализЖурналаРегистрации.Создать();
	#КонецЕсли
	АнализЖурналаРегистрации.ОткрытьСПараметром("Пользователь", Новый УникальныйИдентификатор(ТекущаяСтрока.УникальныйИдентификатор), ТекущаяСтрока.Имя);

КонецПроцедуры

Процедура ПриОткрытии()
	
	мПлатформа = ирКэш.Получить();
	Если РолиПользователя.Количество() = 0 Тогда
		Для Каждого мРоль Из Метаданные.Роли Цикл
			СтрокаСпискаДоступныхРолей = РолиПользователя.Добавить();
			СтрокаСпискаДоступныхРолей.Представление = мРоль.Представление();
			СтрокаСпискаДоступныхРолей.Роль = мРоль.Имя;
		КонецЦикла;
	КонецЕсли; 
	Если РазделениеДанных.Количество() = 0 Тогда
		Для Каждого ОбщийРеквизит Из Метаданные.ОбщиеРеквизиты Цикл
			Если ОбщийРеквизит.РазделениеДанных = Метаданные.СвойстваОбъектов.РазделениеДанныхОбщегоРеквизита.Разделять Тогда
				СтрокаРазделителя = РазделениеДанных.Добавить();
				СтрокаРазделителя.Разделитель = ОбщийРеквизит.Имя;
				СтрокаРазделителя.Представление = ОбщийРеквизит.Представление();
			КонецЕсли; 
		КонецЦикла;
	КонецЕсли; 
	ЭтаФорма.вСписокИсторииОтбора = ирОбщий.ВосстановитьЗначениеЛкс("Обработка_УправлениеСпискомПользователей_Отбор");
	Если ТипЗНЧ(ЭтаФорма.вСписокИсторииОтбора) <> Тип("СписокЗначений") Тогда
		ЭтаФорма.вСписокИсторииОтбора = Новый СписокЗначений;
	КонецЕсли; 
	НастройкаОтбораСтрок = ОсновнойЭУ.НастройкаОтбораСтрок;
	Для каждого НастройкаОтбораСтроки Из НастройкаОтбораСтрок Цикл
		НастройкаОтбораСтроки.Доступность = Истина;
	КонецЦикла; 
	ИсторияОтборов = Новый Массив;
	УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	Если ЗначениеЗаполнено(ЭтаФорма.ПараметрИмяПользователя) Тогда
		СтрокаПользователя = ОсновнойЭУ.Значение.Найти(ЭтаФорма.ПараметрИмяПользователя, "Имя");
		Если СтрокаПользователя <> Неопределено Тогда
			ОсновнойЭУ.ТекущаяСтрока = СтрокаПользователя;
		КонецЕсли;
	КонецЕсли;
	ОсновнойЭУ.Значение.Сортировать("Имя");
	ЭлементыФормы.КоманднаяПанельСпискаПользователей.Кнопки.УстановитьНастройкиУправляемогоПриложения.Доступность = ирКэш.Получить().ИДВерсииПлатформы >= "83";

КонецПроцедуры

Функция УправлениеСпискомПользователей_ОбновитьСписокПользователей(Знач УникальныйИдентификатор = "") Экспорт
	
	Если Не ЗначениеЗаполнено(УникальныйИдентификатор) Тогда
		ТекущиеДанные = ОсновнойЭУ.ТекущиеДанные;
		УникальныйИдентификатор = ?(ТекущиеДанные = Неопределено, Неопределено, ТекущиеДанные.УникальныйИдентификатор);
	КонецЕсли; 
	ПользователиИнфобазы = ПользователиИнформационнойБазы.ПолучитьПользователей();
	Разница = ПользователиИнфобазы.Количество() - ОсновнойЭУ.Значение.Количество();
	Если Разница > 0  Тогда
		Для Счетчик = 1 По Разница Цикл
			ОсновнойЭУ.Значение.Добавить();
		КонецЦикла; 
	ИначеЕсли Разница < 0 Тогда
		Для Счетчик = 1 По -Разница Цикл
			ОсновнойЭУ.Значение.Удалить(ОсновнойЭУ.Значение.Количество()-1);
		КонецЦикла; 
	КонецЕсли; 
	Счетчик = 0;
	Для каждого Пользователь Из ПользователиИнфобазы Цикл
		ТекущиеДанные = ОсновнойЭУ.Значение[Счетчик];
		УправлениеСпискомПользователей_ОбновитьСтрокуПользователя(Пользователь, ТекущиеДанные);
		Счетчик = Счетчик + 1;
	КонецЦикла;
	ОсновнойЭУ.Значение.Сортировать("Имя");
	НоваяТекущаяСтрока = ОсновнойЭУ.Значение.Найти("" + УникальныйИдентификатор, "УникальныйИдентификатор");
	Если НоваяТекущаяСтрока <> Неопределено Тогда
		ОсновнойЭУ.ТекущаяСтрока = НоваяТекущаяСтрока;
	КонецЕсли;
	ЭтаФорма.Обновить();
	
КонецФункции

Функция УправлениеСпискомПользователей_ОбновитьСтрокуПользователя(Знач Пользователь = Неопределено, Знач ТекущиеДанные) Экспорт
	
	Если Пользователь = Неопределено Тогда
		Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ТекущиеДанные.УникальныйИдентификатор));
	Иначе
		ТекущиеДанные.Имя = Пользователь.Имя;
	КонецЕсли; 
	ТекущиеДанные.ПолноеИмя = Пользователь.ПолноеИмя;
	ТекущиеДанные.ПарольУстановлен = Пользователь.ПарольУстановлен;
	ТекущиеДанные.ПоказыватьВСпискеВыбора = Пользователь.ПоказыватьВСпискеВыбора;
	ТекущиеДанные.АутентификацияСтандартная = Пользователь.АутентификацияСтандартная;
	ТекущиеДанные.АутентификацияОС = Пользователь.АутентификацияОС;
	ТекущиеДанные.АутентификацияOpenID = Пользователь.АутентификацияOpenID;
	Попытка
		ТекущиеДанные.ПользовательОС = Пользователь.ПользовательОС;
	Исключение
		ТекущиеДанные.ПользовательОС = "<Неверные данные>";
	КонецПопытки; 
	
	Если Пользователь.Язык = Неопределено Тогда
		ТекущиеДанные.Язык = "";
		ТекущиеДанные.ЯзыкПредставление = "";
	Иначе
		ТекущиеДанные.Язык = Пользователь.Язык.Имя;
		ТекущиеДанные.ЯзыкПредставление = Пользователь.Язык;
	КонецЕсли; 
	
	Если Пользователь.ОсновнойИнтерфейс = Неопределено Тогда
		ТекущиеДанные.ОсновнойИнтерфейс = "";
		ТекущиеДанные.ОсновнойИнтерфейсПредставление = "";
	Иначе
		ТекущиеДанные.ОсновнойИнтерфейс = Пользователь.ОсновнойИнтерфейс.Имя;
		ТекущиеДанные.ОсновнойИнтерфейсПредставление = Пользователь.ОсновнойИнтерфейс;
	КонецЕсли; 
	
	РезультатРоли = Новый СписокЗначений;
	Для каждого Роль Из Пользователь.Роли Цикл
		РезультатРоли.Добавить(Роль.Имя,Роль);
	КонецЦикла; 
	РезультатРоли.СортироватьПоЗначению();
	
	РезультатИмена         = "";
	РезультатПредставление = "";
	Для каждого Роль Из РезультатРоли Цикл
		РезультатИмена         = РезультатИмена+Роль.Значение+", ";
		РезультатПредставление = РезультатПредставление+Роль.Представление+", ";
	КонецЦикла; 
	ТекущиеДанные.РолиИмена = Сред(РезультатИмена,1,СтрДлина(РезультатИмена)-2);
	ТекущиеДанные.РолиПредставление = Сред(РезультатПредставление,1,СтрДлина(РезультатПредставление)-2);
	ТекущиеДанные.УникальныйИдентификатор = Пользователь.УникальныйИдентификатор;
	ТекущиеДанные.СохраняемоеЗначениеПароля = Пользователь.СохраняемоеЗначениеПароля;
	ТекущиеДанные.РежимЗапуска = Пользователь.РежимЗапуска;
	Если мПлатформа.ВерсияПлатформы > 803009 Тогда
		ТекущиеДанные.ПредупреждатьОбОпасныхДействиях = Пользователь.ЗащитаОтОпасныхДействий.ПредупреждатьОбОпасныхДействиях;
	КонецЕсли;
	Если РазделениеДанных.Количество() > 0 Тогда
		ТекущиеДанные.РазделениеДанныхПредставление = ирОбщий.РасширенноеПредставлениеЗначенияЛкс(Пользователь.РазделениеДанных);
	КонецЕсли; 
	
	НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, Пользователь.Имя);
	Если НастройкиКлиентскогоПриложения = Неопределено Тогда
		НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, НастройкиКлиентскогоПриложения); 
	
	УправлениеСпискомПользователей_УстановитьОтборПоРолям(ТекущиеДанные);
	
КонецФункции

Функция УправлениеСпискомПользователей_УстановитьОтборПоРолям(Знач ТекущиеДанные) Экспорт
	
	ОтборСтрок = ОсновнойЭУ.ОтборСтрок;
	Если ОтборСтрок.ОтборПоРолям.Использование = ложь Тогда
		Возврат Неопределено;
	КонецЕсли; 
	ВходитВОтборПоРолям = Ложь;
	Попытка
		СтруктураОтбораРолей = Новый Структура(ОтборСтрок.Роли.Значение);
		СтруктураРолей = Новый Структура(ТекущиеДанные.Роли);
		Для каждого КлючИЗначение Из СтруктураОтбораРолей Цикл
			Если СтруктураРолей.Свойство(КлючИЗначение.Ключ) Тогда
				ВходитВОтборПоРолям = Истина;
				Прервать;
			КонецЕсли; 
		КонецЦикла; 
	Исключение
	КонецПопытки; 
	ТекущиеДанные.ОтборПоРолям = ВходитВОтборПоРолям;
	
КонецФункции

Процедура ПользователиПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	РедактироватьПользователя(Элемент);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейОбновить(Кнопка)
	
	УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейОткрытьМенеджерТабличногоПоля(Кнопка)
	
	ирОбщий.ОткрытьМенеджерТабличногоПоляЛкс(ЭлементыФормы.Пользователи, ЭтаФорма);
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейОтборБезЗначенияВТекущейКолонке(Кнопка)
	
	ирОбщий.ТабличноеПоле_ОтборБезЗначенияВТекущейКолонке_КнопкаЛкс(ЭлементыФормы.Пользователи);
	
КонецПроцедуры

Процедура ПользователиПриПолученииДанных(Элемент, ОформленияСтрок)
	
	Сеансы = ПолучитьСеансыИнформационнойБазы();
	// Оптимизировать
	Для Каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		ДанныеСтроки = ОформлениеСтроки.ДанныеСтроки;
		Для Каждого Сеанс Из Сеансы Цикл
			Если Сеанс.Пользователь = Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			Если ирОбщий.СтрокиРавныЛкс(ДанныеСтроки.УникальныйИдентификатор, ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор) Тогда
				ОформлениеСтроки.ЦветТекста = Новый Цвет(20, 40, 140);
			КонецЕсли; 
			Если ирОбщий.СтрокиРавныЛкс(Сеанс.Пользователь.УникальныйИдентификатор, ДанныеСтроки.УникальныйИдентификатор) Тогда
				ОформлениеСтроки.ЦветФона = Новый Цвет(245, 255, 245);
				Прервать;
			КонецЕсли;
		КонецЦикла;
		ОформлениеСтроки.Ячейки.НастройкиУправляемогоПриложения.Видимость = Ложь;
	КонецЦикла; 
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейЗапуститьПодПользователем(Кнопка)
	
	Если ОсновнойЭУ.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ФормаЗапуска = ПолучитьФорму("ЗапускПодПользователем");
	УникальныйИдентификатор = Новый УникальныйИдентификатор(ОсновнойЭУ.ТекущаяСтрока.УникальныйИдентификатор);
	ФормаЗапуска.ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(УникальныйИдентификатор);
	Если ФормаЗапуска.ПользовательИБ = Неопределено Тогда
		УправлениеСпискомПользователей_ОбновитьСписокПользователей();
		Возврат;
	КонецЕсли; 
	ФормаЗапуска.ОткрытьМодально();
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейТехноЖурнал(Кнопка)
	
	ТекущаяСтрока = ОсновнойЭУ.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ирОбщий.ПолучитьФормуЛкс("Обработка.ирАнализТехножурнала.Форма").ОткрытьСОтбором(, , Новый Структура("Пользователь", ТекущаяСтрока.Имя));
	
КонецПроцедуры

Процедура ПользователиПередНачаломДобавления(Элемент, Отказ, Копирование)
	
	Отказ = Истина;
	ФормаРедактированияПользователя = ПолучитьФорму("ПользовательИнфобазы");
	Если Копирование Тогда
		ФормаРедактированияПользователя.ПользовательДляКопированияНастроек = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Элемент.ТекущаяСтрока.УникальныйИдентификатор));
	КонецЕсли; 
	РезультатОткрытия = ФормаРедактированияПользователя.ОткрытьМодально();
	Если РезультатОткрытия = Истина Тогда
		УправлениеСпискомПользователей_ОбновитьСписокПользователей("" + ФормаРедактированияПользователя.ПользовательБД.УникальныйИдентификатор);
	КонецЕсли; 

КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ПользователиПередУдалением(Элемент, Отказ)
	
	Отказ = Истина;
	ВыделенныеСтроки = ЭлементыФормы.Пользователи.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		Возврат;
	КонецЕсли; 
	Ответ = Вопрос("Вы действительно хотите удалить выделенных (" + ВыделенныеСтроки.Количество() + ") пользователей?", РежимДиалогаВопрос.ОКОтмена);
	Если Ответ = КодВозвратаДиалога.ОК Тогда
		Для Каждого ВыделеннаяСтрока Из ВыделенныеСтроки Цикл
			ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ВыделеннаяСтрока.УникальныйИдентификатор)).Удалить();
		КонецЦикла;
		УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	КоличествоПользователей = ОсновнойЭУ.Значение.Количество();

КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейУстановитьНастройкиУправляемогоПриложения(Кнопка)
	
	ФормаУстановкиНастроек = ПолучитьФорму("УстановкаНастроекПриложения");
	Если ЭлементыФормы.Пользователи.ТекущаяСтрока <> Неопределено Тогда
		НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, ЭлементыФормы.Пользователи.ТекущаяСтрока.Имя);
		Если НастройкиКлиентскогоПриложения = Неопределено Тогда
			НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
		КонецЕсли;
		//ФормаУстановкиНастроек.ВариантИнтерфейсаКлиентскогоПриложенияЗначение = НастройкиКлиентскогоПриложения.ВариантИнтерфейсаКлиентскогоПриложения; // Тут представление значений <> имени, потому нужен мэпинг
		ФормаУстановкиНастроек.ВариантМасштабаФормКлиентскогоПриложенияЗначение = НастройкиКлиентскогоПриложения.ВариантМасштабаФормКлиентскогоПриложения;
		//ФормаУстановкиНастроек.РежимОткрытияФормПриложенияЗначение = НастройкиКлиентскогоПриложения.РежимОткрытияФормПриложения; // Тут представление значений <> имени, потому нужен мэпинг
		ФормаУстановкиНастроек.ОтображатьПанельРазделовЗначение = НастройкиКлиентскогоПриложения.ОтображатьПанельРазделов;
		ФормаУстановкиНастроек.ОтображатьПанелиНавигацииИДействийЗначение = НастройкиКлиентскогоПриложения.ОтображатьПанелиНавигацииИДействий;
	КонецЕсли;
	РезультатФормы = ФормаУстановкиНастроек.ОткрытьМодально();
	Если РезультатФормы <> Неопределено Тогда
		Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.Пользователи.ВыделенныеСтроки Цикл
			НастройкиКлиентскогоПриложения = ХранилищеСистемныхНастроек.Загрузить("Общее/НастройкиКлиентскогоПриложения",,, ВыделеннаяСтрока.Имя);
			Если НастройкиКлиентскогоПриложения = Неопределено Тогда
				НастройкиКлиентскогоПриложения = Новый НастройкиКлиентскогоПриложения;
			КонецЕсли;
			ЗаполнитьЗначенияСвойств(НастройкиКлиентскогоПриложения, РезультатФормы); 
			ХранилищеСистемныхНастроек.Сохранить("Общее/НастройкиКлиентскогоПриложения", "", НастройкиКлиентскогоПриложения, , ВыделеннаяСтрока.Имя);
			УправлениеСпискомПользователей_ОбновитьСтрокуПользователя(, ВыделеннаяСтрока);
		КонецЦикла;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельСпискаПользователейОбработатьВКонсолиКода(Кнопка)
	
	ВыделенныеПользователи = Новый Массив;
	Для Каждого ВыделеннаяСтрока Из ЭлементыФормы.Пользователи.ВыделенныеСтроки Цикл
		ВыделенныеПользователи.Добавить(ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ВыделеннаяСтрока.УникальныйИдентификатор)));
	КонецЦикла;
	СтруктураПараметров = Новый Структура("ВыделенныеПользователи", ВыделенныеПользователи);
	ТекстАлгоритма = "Для Каждого Пользователь Из ВыделенныеПользователи Цикл
	|	//: Пользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору();
	|
	|КонецЦикла;";
	ирОбщий.ОперироватьСтруктуройЛкс(ТекстАлгоритма, , СтруктураПараметров);
	
КонецПроцедуры

Процедура ПользователиВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	РедактироватьПользователя(Элемент);

КонецПроцедуры

Процедура РедактироватьПользователя(Знач Элемент)
	
	Перем РезультатОткрытия, ФормаРедактированияПользователя;
	
	ФормаРедактированияПользователя = ПолучитьФорму("ПользовательИнфобазы");
	ФормаРедактированияПользователя.ПользовательБД = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Элемент.ТекущаяСтрока.УникальныйИдентификатор));
	РезультатОткрытия = ФормаРедактированияПользователя.ОткрытьМодально();
	Если РезультатОткрытия = Истина Тогда
		УправлениеСпискомПользователей_ОбновитьСписокПользователей();
	КонецЕсли;

КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирРедакторПользователей.Форма.Форма");

ОсновнойЭУ = ЭлементыФормы.Пользователи;
