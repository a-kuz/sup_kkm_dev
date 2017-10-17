﻿
Перем ТаблицаИменКолонокТарифнойСетки;

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	УправлениеРИБ.ПередОткрытиемЭлементаСправочника(ЭтотОбъект, ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
		ТипЦен = Справочники.ТипыЦен.Розничная;
	КонецЕсли;
	
	
	// Доступность ГруппыОплаты в зависимости от общих настроек 
	ИспользоватьГруппыОплаты = Константы.ИспользоватьГруппыОплаты.Получить();
	ЭлементыФормы.ГруппыОплаты.Доступность		= ИспользоватьГруппыОплаты;
	ЭлементыФормы.КоманднаяПанель1.Доступность	= ИспользоватьГруппыОплаты;
	
	Выборка = Справочники.КаталогиТоваров.Выбрать();
	Пока Выборка.Следующий() Цикл
		Если НЕ Выборка.ПометкаУдаления Тогда
			Используется = КаталогиТоваров.Найти(Выборка.Ссылка) <> Неопределено;
			СписокКаталогов.Добавить(Выборка.Ссылка,,Используется);
		КонецЕсли; 
	КонецЦикла; 
	
	ФлагТипыЦенПоРасписанию = НЕ ЗначениеЗаполнено(ТипЦен);
	
	//ФормаТарифнаяСетка = Защита.ЗаполнитьТипыЦенРасписание( ?(ЗначениеЗаполнено(ПараметрОбъектКопирования), ПараметрОбъектКопирования, Ссылка), ТаблицаИменКолонокТарифнойСетки);
	
	Колонки = ЭлементыФормы.ТарифнаяСетка.Колонки;
	Колонки.Время.Данные = "Время";
	
	//Для каждого СтрокаИмен Из ТаблицаИменКолонокТарифнойСетки Цикл
	//	КолонкаЦена = Колонки.Добавить(СтрокаИмен.Цена, СтрокаИмен.ТипДня.Наименование);
	//	КолонкаЦена.Данные = СтрокаИмен.Цена;
	//	КолонкаЦена.ЭлементУправления.БыстрыйВыбор = Истина;
	//КонецЦикла;
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.ТипЦен.Видимость						= НЕ ФлагТипыЦенПоРасписанию;
	ЭлементыФормы.ТарифнаяСетка.Видимость				= ФлагТипыЦенПоРасписанию;
	ЭлементыФормы.КоманднаяПанельТарифнаяСетка.Видимость= ФлагТипыЦенПоРасписанию;
	
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	КаталогиТоваров.Очистить();
	Для каждого Каталог Из СписокКаталогов Цикл
		Если Каталог.Пометка Тогда
			КаталогиТоваров.Добавить().Каталог = Каталог.Значение;
		КонецЕсли; 
	КонецЦикла; 
	
	Если ФлагТипыЦенПоРасписанию Тогда
		ТипыЦенРасписание.Очистить();
		
		Для каждого СтрокаИмен Из ТаблицаИменКолонокТарифнойСетки Цикл
			Для Каждого СтрокаСетки Из ФормаТарифнаяСетка Цикл
				
				Если СтрокаСетки[СтрокаИмен.Цена]<>0 ИЛИ СтрокаСетки[СтрокаИмен.Бесплатно] Тогда
					НоваяСтрока = ТипыЦенРасписание.Добавить();
					НоваяСтрока.ТипДня	= СтрокаИмен.ТипДня;
					НоваяСтрока.Время	= СтрокаСетки.Время;
					НоваяСтрока.ТипЦен	= СтрокаСетки[СтрокаИмен.Цена];
				КонецЕсли;
				
			КонецЦикла;
		КонецЦикла;
		
		Если ТипыЦенРасписание.Количество()=0 ТОгда
			Сообщить("Не указано расписание типов цен!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
		ТипЦен = Неопределено;
		
	ИначеЕсли НЕ ЗначениеЗаполнено(ТипЦен) Тогда
		Сообщить("Не указан тип цен!", СтатусСообщения.Важное);
		Отказ = Истина;
		
	КонецЕсли;
	
	// Проверка ГруппыОплаты
	//ИспользоватьГруппыОплаты = Константы.ИспользоватьГруппыОплаты.Получить();
	//Если НЕ ИспользоватьГруппыОплаты И ГруппыОплаты.Количество() > 0 Тогда	
	//	Сообщить("На закладке ""Отчеты ФО"" таблица ""Группы оплаты"" должна быть пустой, когда в настройках общих параметров не установлен флаг ""Использовать группы оплаты"" !", СтатусСообщения.Важное);
	//	Отказ = Истина;
	//КонецЕсли;
		
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ТарифнаяСеткаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	
	// проверка существования строки с таким же временем
	Если НЕ ОтменаРедактирования Тогда
		МассивСтрок = ФормаТарифнаяСетка.НайтиСтроки(Новый Структура("Время",Элемент.ТекущиеДанные.Время));
		Если МассивСтрок.Количество() > 1 Тогда
			Предупреждение("Такое время уже есть!");
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура ТарифнаяСеткаПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если НЕ ОтменаРедактирования Тогда
		ФормаТарифнаяСетка.Сортировать("Время");
	КонецЕсли;
	
КонецПроцедуры

Процедура ТарифнаяСеткаВремяНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИнтерфейсАдмина.ВыбратьВремяИзСписка(ЭтаФорма, Элемент);
	
КонецПроцедуры

