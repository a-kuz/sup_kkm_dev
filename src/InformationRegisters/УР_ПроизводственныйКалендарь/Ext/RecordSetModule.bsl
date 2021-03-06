﻿
////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Заполняет ресурсы "Пятидневка", "Шестидневка" и "КалендарныеДни"
Процедура ЗаполнитьРесурсыЗаписиРегистра(ЗаписьРегистра)
	
	// рабочий день
	Если ЗаписьРегистра.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Рабочий ИЛИ
		ЗаписьРегистра.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
		
		ЗаписьРегистра.Пятидневка  = 1;
		ЗаписьРегистра.Шестидневка = 1;
		
		// суббота	
	ИначеЕсли ЗаписьРегистра.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Суббота Тогда
		ЗаписьРегистра.Пятидневка  = 0;
		ЗаписьРегистра.Шестидневка = 1;
		
		// воскресение
	ИначеЕсли ЗаписьРегистра.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Воскресенье Тогда
		ЗаписьРегистра.Пятидневка  = 0;
		ЗаписьРегистра.Шестидневка = 0;
		
		// празничный день	
	Иначе  
		ЗаписьРегистра.Пятидневка  = 0;
		ЗаписьРегистра.Шестидневка = 0;
		
	КонецЕсли;
	
КонецПроцедуры 

// формирует список значений, описывающий государственные праздники РФ
//
// Возвращаемое значение:
//   список значений, содержащий строки-"месяц,день" праздников
//
Функция ПолучитьСписокПраздников() Экспорт

	СписокПраздников = Новый СписокЗначений();
	СписокПраздников.Добавить("0101");
	СписокПраздников.Добавить("0102");
	СписокПраздников.Добавить("0103");
	СписокПраздников.Добавить("0104");
	СписокПраздников.Добавить("0105");
	СписокПраздников.Добавить("0107");
	СписокПраздников.Добавить("0223");
	СписокПраздников.Добавить("0308");
	СписокПраздников.Добавить("0501");
	СписокПраздников.Добавить("0509");
	СписокПраздников.Добавить("0612");
	СписокПраздников.Добавить("1104");

	Возврат СписокПраздников

КонецФункции // ПолучитьСписокПраздников()

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ 

Функция ПервоначальноеЗаполнениеРегистра(КонтрольнаяДата) Экспорт
	
	ТаблицаРегистра = Новый ТаблицаЗначений();
	ТаблицаРегистра.Колонки.Добавить("ДатаКалендаря");
	ТаблицаРегистра.Колонки.Добавить("ВидДня");
	ТаблицаРегистра.Индексы.Добавить("ДатаКалендаря");

	мДлинаСуток = 86400;
	
	// Заполнение регистра за год
	ПервоеЯнваря = НачалоГода(КонтрольнаяДата);
	СписокПраздниковВВыходные = Новый СписокЗначений;
	
	СписокПраздников = ПолучитьСписокПраздников();
	
	Для НомерДня = 1 По ДеньГода(КонецГода(КонтрольнаяДата)) Цикл
		
		ЗаписываемаяДата 	= НачалоДня(ПервоеЯнваря + мДлинаСуток * (НомерДня - 1));
		ПраздничныйДень = СписокПраздников.НайтиПоЗначению("" + Формат(ЗаписываемаяДата, "ДФ = 'ММ'") + Формат(ЗаписываемаяДата, "ДФ = 'дд'"));
		
		НоваяЗаписьРегистраВидДня =Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Рабочий; 
		
		Если ПраздничныйДень <> Неопределено Тогда
			
			НоваяЗаписьРегистраВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Праздник;
			
			Если ДеньНедели(ЗаписываемаяДата) > 5 Тогда
				
				СписокПраздниковВВыходные.Добавить(ЗаписываемаяДата, ПраздничныйДень);
				
			КонецЕсли;
			
			// Предпраздничные дни
			Если НомерДня > 1 Тогда
				
				СтрокаТаблицы = ТаблицаРегистра.Найти(ЗаписываемаяДата - мДлинаСуток,"ДатаКалендаря");
				Если СтрокаТаблицы.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
					СтрокаТаблицы.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Предпраздничный;
				КонецЕсли; 
				
			КонецЕсли;
			
		Иначе
			
			Если ДеньНедели(ЗаписываемаяДата) = 6 Тогда
				НоваяЗаписьРегистраВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Суббота
			ИначеЕсли ДеньНедели(ЗаписываемаяДата) = 7 Тогда
				НоваяЗаписьРегистраВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Воскресенье
			Иначе
				НоваяЗаписьРегистраВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Рабочий
			КонецЕсли; 
			
		КонецЕсли; 
		
		// Запишем в таблицу значений
		НоваяСтрокаТаблицыРегистра = ТаблицаРегистра.Добавить();
		НоваяСтрокаТаблицыРегистра.ДатаКалендаря = ЗаписываемаяДата;
		НоваяСтрокаТаблицыРегистра.ВидДня        = НоваяЗаписьРегистраВидДня;
		
	КонецЦикла; 
	
	// 31 декабря предпраздничный день в таблице
	Если НоваяСтрокаТаблицыРегистра.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
		НоваяСтрокаТаблицыРегистра.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Предпраздничный;
	КонецЕсли;
	
	Возврат ТаблицаРегистра
	
КонецФункции

// Выполняет запись в регистр сведений "РегламентированныйПроизводственныйКалендарь" данных из временной таблицы 
Процедура ЗаписатьИзТаблицыВРегистр(ТаблицаРегистра,ГодЗаписи) Экспорт

	// Очистим старые данные за год
	НаборЗаписей = РегистрыСведений.УР_ПроизводственныйКалендарь.СоздатьНаборЗаписей();
	НаборЗаписей.Отбор.Год.Значение		 = ГодЗаписи;
	НаборЗаписей.Отбор.Год.Использование = Истина;
	НаборЗаписей.Прочитать();
	
	ЕстьЗаписиВРегистре = НаборЗаписей.Количество() > 0;
	
	// Запишем новые данные за год
	Если ЕстьЗаписиВРегистре Тогда
		Для каждого Запись Из НаборЗаписей Цикл
			СтрокаТаблицы = ТаблицаРегистра.Найти(Запись.ДатаКалендаря,"ДатаКалендаря");
			Запись.ВидДня = СтрокаТаблицы.ВидДня;
			// Установим ресурсы "Пятидневка", "Шестидневка"
			ЗаполнитьРесурсыЗаписиРегистра(Запись);
		КонецЦикла; 
	Иначе
		Для Каждого СтрокаТаблицы ИЗ ТаблицаРегистра Цикл
			НоваяЗаписьРегистра = НаборЗаписей.Добавить();
			НоваяЗаписьРегистра.ДатаКалендаря = СтрокаТаблицы.ДатаКалендаря;
			НоваяЗаписьРегистра.Год			  = Год(СтрокаТаблицы.ДатаКалендаря);
			НоваяЗаписьРегистра.ВидДня		  = СтрокаТаблицы.ВидДня;
			// Установим ресурсы "Пятидневка", "Шестидневка"
			ЗаполнитьРесурсыЗаписиРегистра(НоваяЗаписьРегистра);
		КонецЦикла; 
	КонецЕсли;
	
	// запишем набор записей
	НаборЗаписей.Записать();
	ДанныеКалендаря = НаборЗаписей.Выгрузить();
	ДанныеКалендаря.Индексы.Добавить("ДатаКалендаря");
	ДанныеКалендаря.Сортировать("ДатаКалендаря");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИНИЦИАЛИЗАЦИЯ ПЕРЕМЕННЫХ МОДУЛЯ

