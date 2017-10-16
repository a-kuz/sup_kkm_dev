﻿
#Если Клиент Тогда

Перем ТаблицаЗадания;
Перем ДлинаСуммы;
	
// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
	ТаблицаЗадания = Новый ТаблицаЗначений;
	ТаблицаЗадания.Колонки.Добавить("Данные");
	ТаблицаЗадания.Колонки.Добавить("ТипДанных");
	ТаблицаЗадания.Колонки.Добавить("Параметры");
	
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ

// Формирование таблицы задания для печати чека
//
Функция ПечатьЧека(ПротоколРасчетов, ОплаченнаяСумма, Знач ГруппаОплаты) Экспорт
	
	Перем Действие;
	
	ТаблицаОтделов = Новый ТаблицаЗначений;
	ТаблицаОтделов.Колонки.Добавить("Отдел");
	ТаблицаОтделов.Колонки.Добавить("Сумма");
	
	// открытие чека
	Задание = ТаблицаЗадания.Добавить();
	Если Заказ.ИтоговаяСумма > ОплаченнаяСумма или Заказ.ИтоговаяСумма = 0 Тогда
		Задание.ТипДанных = "ОткрытьЧекПродажа";
	ИначеЕсли Заказ.ИтоговаяСумма < ОплаченнаяСумма Тогда
		Задание.ТипДанных = "ОткрытьЧекВозврат";
	КонецЕсли;
	
	//Мясновъ начало
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = Формат(ЗаказДопИнф.ДатаЗакрытия,"ДЛФ=Д");
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Лево,ПереводСтроки";
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "Ваш заказ на станциях ""Кухни Полли"" №"+Формат(Число(Заказ.Номер),"ЧГ=") + ?(ЗначениеЗаполнено(Заказ.ВнешнийНомер), " / "+Заказ.ВнешнийНомер, "");
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Центр,ПереводСтроки";
	
	
	
	//========================================== старый код	
	//Задание = ТаблицаЗадания.Добавить();
	//Задание.Данные    = "ПО СЧЕТУ N "+Формат(Число(Заказ.Номер),"ЧГ=") + ?(ЗначениеЗаполнено(Заказ.ВнешнийНомер), " / "+Заказ.ВнешнийНомер, "");
	//Задание.ТипДанных = "Строка";
	//Задание.Параметры = "Центр,ПереводСтроки";
	
	//// формирование заголовка счета
	//Если глПараметрыРМ.ПечатьЧекаШапка Тогда
	//	Задание = ТаблицаЗадания.Добавить();
	//	Задание.Данные    = "СтрЧерта";
	//	Задание.ТипДанных = "Строка";
	//	Задание.Параметры = "Центр,ПереводСтроки";
	//	
	//	Задание = ТаблицаЗадания.Добавить();
	//	Задание.Данные    = "    Дата: "+Формат(ЗаказДопИнф.ДатаЗакрытия,"ДЛФ=Д");
	//	Задание.ТипДанных = "Строка";
	//	Задание.Параметры = "Лево,ПереводСтроки";
	//	
	//	Если Заказ.Доставка ИЛИ ЗаказДопИнф.ДатаЗакрытия - ЗаказДопИнф.ДатаОткрытия < 5*60 Тогда
	//		Задание = ТаблицаЗадания.Добавить();
	//		Задание.Данные    = "  Время: "+Формат(ЗаказДопИнф.ДатаЗакрытия,"ДФ=ЧЧ:мм");
	//		Задание.ТипДанных = "Строка";
	//		Задание.Параметры = "Лево,ПереводСтроки";
	//	Иначе
	//		Задание = ТаблицаЗадания.Добавить();
	//		Задание.Данные    = "  Открыт: "+Формат(ЗаказДопИнф.ДатаОткрытия,"ДФ=ЧЧ:мм");
	//		Задание.ТипДанных = "Строка";
	//		Задание.Параметры = "Лево,ПереводСтроки";
	//		
	//		Задание = ТаблицаЗадания.Добавить();
	//		Задание.Данные    = "  Закрыт: "+Формат(ЗаказДопИнф.ДатаЗакрытия,"ДФ=ЧЧ:мм");
	//		Задание.ТипДанных = "Строка";
	//		Задание.Параметры = "Лево,ПереводСтроки";
	//	КонецЕсли; 
	//	
	//	Если НЕ Заказ.Доставка Тогда
	//		Задание = ТаблицаЗадания.Добавить();
	//		Задание.Данные    = "   Место: "+НаимПосадочногоМеста(Заказ.ПосадочноеМесто);
	//		Задание.ТипДанных = "Строка";
	//		Задание.Параметры = "Лево,ПереводСтроки";
	//	КонецЕсли; 
	//	
	//	Если ЗначениеЗаполнено(Заказ.Клиент) Тогда
	//		Задание = ТаблицаЗадания.Добавить();
	//		Задание.Данные    = "  Клиент: "+Заказ.Клиент.Наименование;
	//		Задание.ТипДанных = "Строка";
	//		Задание.Параметры = "Лево,ПереводСтроки";
	//		
	//		Если Заказ.Доставка Тогда
	//			Адрес = Заказ.Адрес;
	//			Телефон = Заказ.Телефон;
	//			
	//			Задание = ТаблицаЗадания.Добавить();
	//			Задание.Данные    = "   Адрес: "+Адрес.Представление + ?(ЗначениеЗаполнено(Адрес.Комментарий), " ("+Адрес.Комментарий+")", "");
	//			Задание.ТипДанных = "Строка";
	//			Задание.Параметры = "Жирный,Лево,Переносить,ПереводСтроки";
	//			
	//			Задание = ТаблицаЗадания.Добавить();
	//			Задание.Данные    = "    Тел.: "+Телефон.Представление + ?(ЗначениеЗаполнено(Телефон.Комментарий), " ("+Телефон.Комментарий+")", "");
	//			Задание.ТипДанных = "Строка";
	//			Задание.Параметры = "Жирный,Лево,Переносить,ПереводСтроки";
	//			
	//			Если ЗначениеЗаполнено(Заказ.Комментарий) Тогда
	//				Задание = ТаблицаЗадания.Добавить();
	//				Задание.Данные    = "   Прим.: "+Заказ.Комментарий;
	//				Задание.ТипДанных = "Строка";
	//				Задание.Параметры = "Жирный,Лево,Переносить,ПереводСтроки";
	//			КонецЕсли;
	//		КонецЕсли;
	//	КонецЕсли;
	//	
	//	Если Заказ.Доставка Тогда
	//		Задание = ТаблицаЗадания.Добавить();
	//		Задание.Данные    = "Оператор: "+Заказ.Автор;
	//		Задание.ТипДанных = "Строка";
	//		Задание.Параметры = "Лево,ПереводСтроки";
	//	Иначе
	//		Если глПараметрыРМ.ЗаказЗапросКолвоПосетителей Тогда
	//			Задание = ТаблицаЗадания.Добавить();
	//			Задание.Данные    = "  Гостей: "+Заказ.КоличествоПосетителей+" чел.";
	//			Задание.ТипДанных = "Строка";
	//			Задание.Параметры = "Лево,ПереводСтроки";
	//		КонецЕсли;
	//		
	//		Задание = ТаблицаЗадания.Добавить();
	//		Задание.Данные    = "Официант: "+Заказ.Автор;
	//		Задание.ТипДанных = "Строка";
	//		Задание.Параметры = "Лево,ПереводСтроки";
	//	КонецЕсли;
	//	
	//	Задание = ТаблицаЗадания.Добавить();
	//	Задание.Данные    = "СтрЧерта";
	//	Задание.ТипДанных = "Строка";
	//	Задание.Параметры = "Центр,ПереводСтроки";
	//КонецЕсли;
	
	Если НЕ( Константы.ИспользоватьГруппыОплаты.Получить() И ОплаченнаяСумма=0 ) Тогда
		ГруппаОплаты = Неопределено;
	КонецЕсли;
	
	// Формирование товарной спецификации счета
	Если глПараметрыРМ.ПечатьЧекаТовары Тогда
		ОбработкаПечати = ИнтерфейсРМ.ПолучитьОбъектОбработки("ПечатьЗаказа");
		ОбработкаПечати.Заказ = Заказ;
		
		ДлинаРасшифровки = 0;
		ДлинаСуммы = 0;
		ОбработкаПечати.СформироватьСпецификацию(ККМ, ТаблицаЗадания, ДлинаРасшифровки, ДлинаСуммы, , ГруппаОплаты);
		
	Иначе
		ДлинаСуммы = СтрДлина(ФорматСумм(Заказ.ИтоговаяСумма)) + 2;   // плюс 2 для "= "
	КонецЕсли;
	
	// это уже для регистрации по отделам
	Для каждого СтрЗаказа Из Заказ.Товары Цикл
		
		Товар = СтрЗаказа.Товар;
		Если СтрЗаказа.СуммаРеализации=0 Тогда
			Продолжить;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ГруппаОплаты) И СтрЗаказа.ГруппаОплаты<>ГруппаОплаты Тогда
			Продолжить;
		КонецЕсли;
		
		Если Товар.Категория.НомерОтдела <> 0 Тогда
			Отдел = Товар.Категория.НомерОтдела;
		ИначеЕсли Заказ.МестоРеализации.НомерОтдела <> 0 Тогда
			Отдел = Заказ.МестоРеализации.НомерОтдела;
		Иначе
			Отдел = 1;
		КонецЕсли;
		
		СтрОтдел = ТаблицаОтделов.Добавить();
		СтрОтдел.Отдел = Отдел;
		СтрОтдел.Сумма = СтрЗаказа.СуммаРеализации;
		
	КонецЦикла;
	
	ТаблицаОтделовИтогСумма = ТаблицаОтделов.Итог("Сумма");
	
	//-------------------------------------------
	Если ОплаченнаяСумма>0 Тогда
		//ДлинаСуммы = Макс(ДлинаСуммы, СтрДлина(ФорматСумм(ОплаченнаяСумма)) + 2 );
		//
		//Задание = ТаблицаЗадания.Добавить();
		//Задание.Данные    = "СтрЧерта";
		//Задание.ТипДанных = "Строка";
		//Задание.Параметры = "Центр,ПереводСтроки";
		//
		//Задание = ТаблицаЗадания.Добавить();
		//Задание.Данные    = "ИТОГО без предоплаты:" + ФорматСумм1(ТаблицаОтделовИтогСумма,ДлинаСуммы);
		//Задание.ТипДанных = "Строка";
		//Задание.Параметры = "ДвойнаяВысота,Жирный,Право,ПереводСтроки";
		//
		//Задание = ТаблицаЗадания.Добавить();
		//Задание.Данные    = "Предоплата:" + ФорматСумм1(ОплаченнаяСумма,ДлинаСуммы);
		//Задание.ТипДанных = "Строка";
		//Задание.Параметры = "Право,ПереводСтроки";
	КонецЕсли;
	
	СписокПараметровЗакрытия = Новый Структура;
	
	//-------------------------------------------
	// если осталось что платить
	Если Заказ.ИтоговаяСумма > ОплаченнаяСумма Тогда
		
		//-------------------------------------------
		// из регистрируемой суммы надо вычесть уже внесенную предоплату и суммы по вариантам оплат без регистрации
		// и все это распределить по отделам
		НерегистрируемаяСумма = ОплаченнаяСумма;
		ДобавитьНерегистрируемыеВариантыОплаты(ПротоколРасчетов, НерегистрируемаяСумма);
		
		//-------------------------------------------
		ТаблицаОтделов.Свернуть("Отдел", "Сумма");
		
		Если НерегистрируемаяСумма <> 0 Тогда
			ОстатокСуммы = НерегистрируемаяСумма;
			
			Для каждого СтрОтдел Из ТаблицаОтделов Цикл
				Если ТаблицаОтделов.Индекс(СтрОтдел) = ТаблицаОтделов.Количество()-1 Тогда
					СтрОтдел.Сумма	= СтрОтдел.Сумма	- ОстатокСуммы;
				Иначе
					СуммаНаОтдел	= Окр(НерегистрируемаяСумма * СтрОтдел.Сумма /ТаблицаОтделовИтогСумма, 2);
					СтрОтдел.Сумма	= СтрОтдел.Сумма	- СуммаНаОтдел;
					ОстатокСуммы	= ОстатокСуммы		- СуммаНаОтдел;
				КонецЕсли;
			КонецЦикла;
			
		КонецЕсли;
		
		Если ТаблицаОтделов.Итог("Сумма")=0 Тогда
			// т.е. после всех вычетов регистрировать нечего
			Действие="Печать";
		Иначе
			Задание = ТаблицаЗадания.Добавить();
			Задание.Данные    = "СтрЧерта";
			Задание.ТипДанных = "Строка";
			Задание.Параметры = "Центр,ПереводСтроки";
			
			Для каждого СтрОтдел Из ТаблицаОтделов Цикл
				Задание = ТаблицаЗадания.Добавить();
				Задание.ТипДанных = "Регистрация";
				Задание.Параметры = СформироватьСписокПараметровРегистрации("",СтрОтдел.Сумма,1,СтрОтдел.Отдел);
			КонецЦикла;
		КонецЕсли;
		
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "СтрЧерта";
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Центр,ПереводСтроки";
		
		Если глПараметрыРМ.ПечатьЧекаНДС Тогда
			ДобавитьНДС(ТаблицаОтделовИтогСумма-ОплаченнаяСумма);
		КонецЕсли;
		
	//-------------------------------------------
	// иначе надо вернуть разницу
	ИначеЕсли Заказ.ИтоговаяСумма < ОплаченнаяСумма Тогда
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "СтрЧерта";
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Центр,ПереводСтроки";
		
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "ВОЗВРАТ ПРЕДОПЛАТЫ";
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Лево,ПереводСтроки";
		
		НерегистрируемаяСумма = 0;
		ДобавитьНерегистрируемыеВариантыОплаты(ПротоколРасчетов, НерегистрируемаяСумма);		
		
		СуммаВозврата = ОплаченнаяСумма - Заказ.ИтоговаяСумма - НерегистрируемаяСумма;
		
		Если СуммаВозврата = 0 Тогда
			// т.е. после всех вычетов регистрировать нечего
			Действие="Печать";
		Иначе
			
			// Нужно ли проверять нал в ККМ
			ПроверятьНалВККМ = 0;
			Для каждого Протокол Из ПротоколРасчетов Цикл
				Если НЕ ЗначениеЗаполнено(Протокол.ВариантОплаты) ИЛИ ТипЗнч(Протокол.ВариантОплаты)<>Тип("СправочникСсылка.ВариантыОплаты") Тогда
					Продолжить;
				ИначеЕсли Протокол.ВариантОплаты.НомерВККМ=1 Тогда
					ПроверятьНалВККМ = 1;
					Прервать;
				КонецЕсли;
            КонецЦикла;
						
			Задание = ТаблицаЗадания.Добавить();
			Задание.ТипДанных = "Возврат";
			Задание.Параметры = СформироватьСписокПараметровВозврата("",СуммаВозврата,1,ПроверятьНалВККМ);
			
			Задание = ТаблицаЗадания.Добавить();
			Задание.Данные    = "СтрЧерта";
			Задание.ТипДанных = "Строка";
			Задание.Параметры = "Центр,ПереводСтроки";
		КонецЕсли;
		
	//ИначеЕсли Заказ.ИтоговаяСумма = 0 тогда
	//	
	//	Задание = ТаблицаЗадания.Добавить();
	//	Задание.ТипДанных = "Регистрация";
	//	Задание.Параметры = СформироватьСписокПараметровРегистрации("",0,1,0);
	//-------------------------------------------
	// нечего регистрировать, просто печатаем информацию по заказу
	Иначе
		
		Действие="Печать";
		
		//Задание = ТаблицаЗадания.Добавить();
		//Задание.Данные    = "СтрЧерта";
		//Задание.ТипДанных = "Строка";
		//Задание.Параметры = "Центр,ПереводСтроки";
		//
		//Задание = ТаблицаЗадания.Добавить();
		//Задание.Данные    = "СЧЕТ ОПЛАЧЕН ПОЛНОСТЬЮ";
		//Задание.ТипДанных = "Строка";
		//Задание.Параметры = "Центр,ПереводСтроки";
		
	КонецЕсли;
	
	//-------------------------------------------
	// оплата
	ДобавитьОплату(ПротоколРасчетов, СписокПараметровЗакрытия);
	
	// Информация по клиенту
	//ДобавитьИнформациюПоКлиенту(ТаблицаЗадания, Заказ.Клиент);
	
	// Информация из системы лояльности
	Если Текст1 <> "" тогда
		Для нс = 1 по СтрЧислоСтрок(Текст1) цикл
			Задание = ТаблицаЗадания.Добавить();
			Задание.Данные    = "СтрЧерта";
			Задание.ТипДанных = "Строка";
			Задание.Параметры = "Лево,ПереводСтроки";
			
			Задание.Данные    = СтрПолучитьСтроку(Текст1,нс);
			Задание.ТипДанных = "Строка";
			Задание.Параметры = "Лево,Переносить,ПереводСтроки";
		КонецЦикла;
	КонецЕсли;
	
	// закрытие чека
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "ЗакрытьЧек";
	Задание.Параметры = СписокПараметровЗакрытия;
	
	// если получилась нефискальная операция и печатать нечего, то ничего не делаем
	Если Действие="Печать" И 
		НЕ (глПараметрыРМ.ПечатьЧекаШапка ИЛИ
		глПараметрыРМ.ПечатьЧекаТовары ИЛИ
		глПараметрыРМ.ПечатьЧекаНерегВО ИЛИ
		глПараметрыРМ.ПечатьЧекаНДС) Тогда
		
		Возврат Истина;
	КонецЕсли;
	
	Возврат ОтправитьЗадание(Действие);
КонецФункции                    	

Функция ЗначениеНДС(СтавкаНДС) Экспорт
	Если Не ЗначениеЗаполнено(СтавкаНДС) Тогда
		Возврат 0;
	КонецЕсли;
	стрНДС = Строка(СтавкаНДС);
	Если Найти(стрНДС,"18") Тогда
		Возврат "18";
	ИначеЕсли Найти(стрНДС,"10") Тогда
		Возврат "10";
	Иначе
		Возврат "Без НДС";
	КонецЕсли;
КонецФункции

// Формирование таблицы задания для печати чека
//
Функция Фискализация(ПротоколРасчетов, ОплаченнаяСумма, Знач ГруппаОплаты) Экспорт
	СтрокаБезнал = Неопределено;
	СтрокаНал = Неопределено;
	//: ПротоколРасчетов = Документы.ПротоколРасчетов.НайтиПоНомеру();
	Для Каждого Т Из ПротоколРасчетов Цикл
		Если Т.ВариантОплаты.Тип = Перечисления.ТипыОплаты.Карта Тогда
			СтрокаБезнал = Т;
		ИначеЕсли Т.ВариантОплаты.Тип = Перечисления.ТипыОплаты.Нал Тогда
			СтрокаНал = Т;
		КонецЕсли;
	КонецЦикла;
	
	Если СтрокаБезнал = Неопределено Тогда
		СуммаБезнал = 0;
	Иначе
		СуммаБезнал = СтрокаБезнал.Сумма;
	КонецЕсли;
	
	Если СтрокаНал = Неопределено Тогда
		СуммаНал = 0;
	Иначе
		СуммаНал = СтрокаНал.Сумма;
	КонецЕсли;
	
	Товары = Заказ.Товары;
	СтрокиЧека = Новый Массив;
	СуммаПоСтрокам = 0;
	Для Каждого Т Из Товары Цикл
		Если Не ЗначениеЗаполнено(Т.Товар) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не (Т.Количество И Т.СуммаРеализации) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокиЧека.Добавить(Новый Структура);
		СтрокаЧека = СтрокиЧека.Получить(СтрокиЧека.Количество()-1);
		
		СтрокаЧека.Вставить("ФискальнаяСтрока", "");
		СтрокаЧека.Вставить("Наименование", Т.Товар.Наименование);
		СтрокаЧека.Вставить("Количество",?(Т.Количество,Т.Количество,1));
		Цена = Т.СуммаРеализации / СтрокаЧека.Количество;
		СтрокаЧека.Вставить("Цена", Цена);
		СтрокаЧека.Вставить("Сумма",
		СтрокаЧека.Цена*СтрокаЧека.Количество);
		СтрокаЧека.Вставить("НомерСекции", Т.Товар.Категория.НомерОтдела);
		
		СтрокаЧека.Вставить("СтавкаНДС", ЗначениеНДС(Т.Товар.Категория.СтавкаНДС));
		Попытка
			СтрокаЧека.Вставить("НДС", СтрокаЧека.Сумма*СтрокаЧека.СтавкаНДС/100);	
		Исключение
			СтрокаЧека.Вставить("НДС", 0);
		КонецПопытки;
		СуммаПоСтрокам = СуммаПоСтрокам + СтрокаЧека.Сумма;
	КонецЦикла;
	
	СтрокиОплат = Новый Массив;
	
	Если СуммаНал Тогда
		СтрокаОплат = Новый Структура;
		СтрокаОплат.Вставить("ТипОплаты", "Нал");
		СтрокаОплат.Вставить("Сумма", СуммаНал);
		СтрокиОплат.Добавить(СтрокаОплат);
	КонецЕсли;	
	Если СуммаБезнал Тогда
		СтрокаОплат = Новый Структура;
		СтрокаОплат.Вставить("ТипОплаты", "Безнал");
		СтрокаОплат.Вставить("Сумма", СуммаБезнал);
		СтрокиОплат.Добавить(СтрокаОплат);
	КонецЕсли;
	
	Если СуммаПоСтрокам <> Заказ.Товары.Итог("СуммаРеализации") Тогда
		
		Текст1 = "Ошибка подготовки чека" ;
		Текст2 = "Сумма по строкам чека равна сумме всех оплат";
		Если НЕ ФоновыйРежим Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка", Текст1, Текст2, "","ОК","");
		КонецЕсли;
		ЗарегистрироватьСобытие("Оплата.Ошибка подготовки чека",УровеньЖурналаРегистрации.Ошибка, , Заказ.Ссылка, "Сумма по строкам = " + СуммаПоСтрокам + "; СуммаЗаказа = " + (СуммаБезнал + СуммаНал));
		Возврат Ложь;
	
	КонецЕсли;
	
		
	Параметры = Новый Структура;
	Параметры.Вставить("Кассир", Строка(глПользователь));
	Параметры.Вставить("СтрокиЧека", СтрокиЧека);
	Параметры.Вставить("СтрокиОплат", СтрокиОплат);
	//Параметры.Вставить("СуммаСкидкиНаЧек",0.99);
	Параметры.Вставить("ТипЧека", Ложь);
	//Если ЗначениеЗаполнено(Email) Тогда
	//	Параметры.Вставить("EmailКлиента", Email);
	//КонецЕсли;
	//Если ЗначениеЗаполнено(НомерТелефона) Тогда
	//	R = ирКэш.Получить().RegExp;
	//	R.Global = 1;
	//	R.Pattern = "\D";
	//	НомерТелефона=R.Replace(НомерТелефона,"");
	//	Параметры.Вставить("ТелефонКлиента", НомерТелефона);
	//КонецЕсли;

	ПараметрыВыходные = ПараметрыВыходные;
	Если ПараметрыВыходные = Неопределено Тогда
		ПараметрыВыходные = Новый Структура;
	КонецЕсли;
	Если СтрокиЧека.Количество() Тогда
		
		ЗарегистрироватьСобытие("Оплата.Фискализация.Входные параметры",УровеньЖурналаРегистрации.Информация,,Заказ, ЗначениеВСтрокуВнутр(Параметры));
		Попытка
			Р = ККМ.ПолучитьОбъект().ВыполнитьКоманду("ФискализацияЧека",Параметры,ПараметрыВыходные);
			фОшибка = Ложь;
		Исключение
			ОписаниеОшибки = Новый Массив;
			ОписаниеОшибки.Добавить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			ПараметрыВыходные.Вставить("ОписаниеОшибки", ОписаниеОшибки);
			Р = Новый Структура("Ошибка, Описание, Подробно", Истина, ОписаниеОшибки[0], ОписаниеОшибки[0]);
			фОшибка = Ложь;
		КонецПопытки;
	Иначе
		Р = Истина;
		фОшибка = Ложь;
		ПараметрыВыходные = "Не фискализирован";
	КонецЕсли;
		
	Если фОшибка Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Попытка 
		Р_ошибка = Р.Ошибка;
	Исключение
		Р_ошибка = Не Р;
	КонецПопытки;
	
	Если Не Р_ошибка Тогда
		//ПараметрыВыходные = Неопределено;
				
	Иначе
		//Если ЗначениеЗаполнено(ПротоколРасчетов.ИдентификаторЗапросаЕГАИС) Тогда
		//	РезультатОплаты.Неудача = Истина;
		//ИначеЕсли ПротоколРасчетов.Протокол.Итог("СуммаФакт") Тогда
		//	РезультатОплаты.Неудача = Истина;
		//Иначе
		//	РезультатОплаты.Отмена = Истина;
		//КонецЕсли;
		//
		//ПоказатьОшибкуККМ(ПараметрыВыходные);
		Текст1 = Р.Описание;
		Текст2 = Р.Подробно;
		Если НЕ ФоновыйРежим Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка", Текст1, Текст2, "","ОК","");
		КонецЕсли;

		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
КонецФункции

// Формирование таблицы задания для печати чека
// Параметры
Функция ФискализацияВозврата(ДокВозврат, ВариантОплаты) Экспорт
	//:ВариантОплаты = Справочники.ВариантыОплаты.ПустаяСсылка();
	//:ДокВозврат = Документы.Возврат.СоздатьДокумент();
	Если ВариантОплаты.Тип = Перечисления.ТипыОплаты.Нал Тогда
		СуммаБезнал = 0;
		СуммаНал = ДокВозврат.Сумма;
	Иначе
		СуммаБезнал = ДокВозврат.Сумма;
		СуммаНал = 0;
	КонецЕсли;
	
	Товары = ДокВозврат.Товары;
	СтрокиЧека = Новый Массив;
	Для Каждого Т Из Товары Цикл
		Если Не ЗначениеЗаполнено(Т.Товар) Тогда
			Продолжить;
		КонецЕсли;
		
		Если Не (Т.Количество И Т.Сумма) Тогда
			Продолжить;
		КонецЕсли;
		
		СтрокиЧека.Добавить(Новый Структура);
		СтрокаЧека = СтрокиЧека.Получить(СтрокиЧека.Количество()-1);
		
		СтрокаЧека.Вставить("ФискальнаяСтрока", "");
		СтрокаЧека.Вставить("Наименование", Т.Товар.Наименование);
		СтрокаЧека.Вставить("Количество",?(Т.Количество,Т.Количество,1));
		Цена = Т.Сумма/Т.Количество;
		СтрокаЧека.Вставить("Цена", Цена);
		СтрокаЧека.Вставить("Сумма",
		СтрокаЧека.Цена*СтрокаЧека.Количество);
		СтрокаЧека.Вставить("НомерСекции", Т.Товар.Категория.НомерОтдела);
		
		СтрокаЧека.Вставить("СтавкаНДС", ЗначениеНДС(Т.Товар.Категория.СтавкаНДС));
		Попытка
			СтрокаЧека.Вставить("НДС", СтрокаЧека.Сумма*СтрокаЧека.СтавкаНДС/100);	
		Исключение
			СтрокаЧека.Вставить("НДС", 0);
		КонецПопытки;
		
	КонецЦикла;
	
	СтрокиОплат = Новый Массив;
	
	Если СуммаНал Тогда
		СтрокаОплат = Новый Структура;
		СтрокаОплат.Вставить("ТипОплаты", "Нал");
		СтрокаОплат.Вставить("Сумма", СуммаНал);
		СтрокиОплат.Добавить(СтрокаОплат);
	КонецЕсли;	
	Если СуммаБезнал Тогда
		СтрокаОплат = Новый Структура;
		СтрокаОплат.Вставить("ТипОплаты", "Безнал");
		СтрокаОплат.Вставить("Сумма", СуммаБезнал);
		СтрокиОплат.Добавить(СтрокаОплат);
	КонецЕсли;
		
	Параметры = Новый Структура;
	Параметры.Вставить("Кассир", Строка(глПользователь));
	Параметры.Вставить("СтрокиЧека", СтрокиЧека);
	Параметры.Вставить("СтрокиОплат", СтрокиОплат);
	//Параметры.Вставить("СуммаСкидкиНаЧек",0.99);
	Параметры.Вставить("ТипЧека", Истина);
	//Если ЗначениеЗаполнено(Email) Тогда
	//	Параметры.Вставить("EmailКлиента", Email);
	//КонецЕсли;
	//Если ЗначениеЗаполнено(НомерТелефона) Тогда
	//	R = ирКэш.Получить().RegExp;
	//	R.Global = 1;
	//	R.Pattern = "\D";
	//	НомерТелефона=R.Replace(НомерТелефона,"");
	//	Параметры.Вставить("ТелефонКлиента", НомерТелефона);
	//КонецЕсли;

	ПараметрыВыходные = ПараметрыВыходные;
	Если СтрокиЧека.Количество() Тогда
		
		ЗарегистрироватьСобытие("Оплата.Фискализация.Входные параметры",УровеньЖурналаРегистрации.Информация,,Заказ, ЗначениеВСтрокуВнутр(Параметры));
		Попытка
			Р = ККМ.ПолучитьОбъект().ВыполнитьКоманду("ФискализацияЧека",Параметры,ПараметрыВыходные);
			Если ПараметрыВыходные.Количество() = 1 Тогда
				
				Если ПараметрыВыходные.Свойство("ОписаниеОшибки", Р.Описание) Тогда
					Р.Описание = ПараметрыВыходные.ОписаниеОшибки;
					Р.Ошибка = Истина;
				КонецЕсли;
			КонецЕсли;
			
			фОшибка = Ложь;
		Исключение
			фОшибка = Истина;
		КонецПопытки;
	Иначе
		Р = Истина;
		фОшибка = Ложь;
		ПараметрыВыходные = "Не фискализирован";
	КонецЕсли;
		
	Если фОшибка Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не Р.Ошибка Тогда
		
		ДокВозврат.КассоваяСмена = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы();
		
		ДокВозврат.НомерСмены = ПараметрыВыходные.НомерСмены;
		ДокВозврат.НомерЧека = ПараметрыВыходные.НомерЧека;
				
		ПротоколРасчетов = Документы.ПротоколРасчетов.СоздатьДокумент();
		ЗаполнитьЗначенияСвойств(ПротоколРасчетов, докВозврат);
		ПротоколРасчетов.Заказ = докВозврат.Ссылка;
		#Если ТолстыйКлиентУправляемоеПриложение Тогда
		ПротоколРасчетов.Дата = ТекущаяДатаСеанса();
		#Иначе      	
		ПротоколРасчетов.Дата = ТекущаяДатаНаСервере();
		#КонецЕсли
		
		Нов = ПротоколРасчетов.Протокол.Добавить();
		Нов.ВариантОплаты = ВариантОплаты;
		Нов.Сумма = докВозврат.Товары.Итог("Сумма");
		Нов.Действие = Перечисления.ДействияПриОплате.Взнос;
		ПротоколРасчетов.Фискализирован = Истина;
		ПротоколРасчетов.Записать(РежимЗаписиДокумента.Проведение);
		
		
		Нов = РегистрыСведений.ВозвратДопИнф.СоздатьМенеджерЗаписи();
		Нов.Возврат = докВозврат.Ссылка;
		Нов.Статус = Перечисления.СтатусыЗаказа.Закрыт;
		Нов.ДатаЗакрытия = докВозврат.Дата;
		Нов.ДатаОткрытия = докВозврат.Дата;
		Нов.ПротоколРасчетов = ПротоколРасчетов.Ссылка;
		Нов.Записать();

		//
		//ПротоколРасчетов.Фискализирован = Истина;
		//ПротоколРасчетов.НеУдалосьОтправитьОтменуВегаис = Ложь;
		//ПротоколРасчетов.ИтогСуммаФакт = Товары.Итог("СуммаРеализации");
		//ПротоколРасчетов.Записать();
		
		//Если Не Заказ.НомерЧека Тогда
		//	Если ТипЗнч(ПараметрыВыходные) = Тип("Структура") Тогда
		//		ПараметрыВыходные.Свойство("НомерЧека", Заказ.НомерЧека);
		//		ПараметрыВыходные.Свойство("НомерСмены", Заказ.НомерСмены);
		//	КонецЕсли;
		//КонецЕсли;
	Иначе
		//Если ЗначениеЗаполнено(ПротоколРасчетов.ИдентификаторЗапросаЕГАИС) Тогда
		//	РезультатОплаты.Неудача = Истина;
		//ИначеЕсли ПротоколРасчетов.Протокол.Итог("СуммаФакт") Тогда
		//	РезультатОплаты.Неудача = Истина;
		//Иначе
		//	РезультатОплаты.Отмена = Истина;
		//КонецЕсли;
		//
		//ПоказатьОшибкуККМ(ПараметрыВыходные);
		Текст1 = СтрСоединить(Р.Описание, Символы.ПС);
		Текст2 = Р.Подробно;
		Если НЕ ФоновыйРежим Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка", Текст1, Текст2, "","ОК","");
		КонецЕсли;

		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
КонецФункции

// Дополнительная информация по клиенту
//
Процедура ДобавитьИнформациюПоКлиенту(ТаблицаЗадания, Клиент)
	
	Если НЕ ЗначениеЗаполнено(Клиент) Тогда
		Возврат;
	КонецЕсли;
	
	НакопленияКлиента = НакопленияКлиента(Клиент); 
	СуммаБезнал = НакопленияКлиента.СуммаБезнал;
	СуммаБонусов = ?(глВерсия=1, 0, НакопленияКлиента.СуммаБонусов );
	
	Если Клиент.Безнал ИЛИ СуммаБонусов<>0 Тогда
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "СтрЧерта";
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Лево,ПереводСтроки";
	КонецЕсли;
	Если Клиент.Безнал Тогда
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "Остаток на счете: "+ФорматСумм1(СуммаБезнал,12);
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Право,Переносить,ПереводСтроки";
	КонецЕсли;
	Если СуммаБонусов<>0 Тогда
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "Накоплено бонусов: "+ФорматСумм1(СуммаБонусов,12);
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Право,Переносить,ПереводСтроки";
	КонецЕсли;
	
КонецПроцедуры

// Формирование таблицы задания для печати чека предоплаты
//
Функция ПечатьПредоплаты(ПротоколРасчетов, СуммаПредоплаты) Экспорт
	
	Перем Действие;
	
	ДлинаСуммы = 12;
	
	// открытие чека
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "ОткрытьЧекПродажа";
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "ПРЕДОПЛАТА ПО СЧЕТУ N "+Число(Заказ.Номер);
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Центр,ПереводСтроки";
		
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "   Место: "+НаимПосадочногоМеста(Заказ.ПосадочноеМесто);
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Лево,ПереводСтроки";
	
	Если ЗначениеЗаполнено(Заказ.Клиент) Тогда
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "  Клиент: "+Заказ.Клиент.Наименование;
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Лево,ПереводСтроки";
	КонецЕсли;
		
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "";
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Центр,ПереводСтроки";
		
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "Сумма:"+ФорматСумм1(СуммаПредоплаты,ДлинаСуммы);
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Право,ПереводСтроки";
		
	//-------------------------------------------
	// надо учесть сумму по вариантам оплат без регистрации
	НерегистрируемаяСумма = 0;
	
	ДобавитьНерегистрируемыеВариантыОплаты(ПротоколРасчетов, НерегистрируемаяСумма);
	
	СуммаПредоплаты = СуммаПредоплаты - НерегистрируемаяСумма;
	
	//-------------------------------------------
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "СтрЧерта";
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Центр,ПереводСтроки";
	
	Если СуммаПредоплаты = 0 Тогда
		// т.е. после всех вычетов регистрировать нечего
		Действие="Печать";
	Иначе
		Задание = ТаблицаЗадания.Добавить();
		Задание.ТипДанных = "Регистрация";
		Задание.Параметры = СформироватьСписокПараметровРегистрации("",СуммаПредоплаты,1,1);
		
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "СтрЧерта";
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Центр,ПереводСтроки";
		
		Если глПараметрыРМ.ПечатьЧекаНДС Тогда
			ДобавитьНДС(СуммаПредоплаты);
		КонецЕсли;
		
		// оплата
		СписокПараметровЗакрытия = Новый Структура;
		ДобавитьОплату(ПротоколРасчетов, СписокПараметровЗакрытия);
		
		// закрытие чека
		Задание = ТаблицаЗадания.Добавить();
		Задание.ТипДанных = "ЗакрытьЧек";
		Задание.Параметры = СписокПараметровЗакрытия;
	
	КонецЕсли;
	
	Возврат ОтправитьЗадание(Действие);
КонецФункции

// Формирование таблицы задания для печати чека возврата
//
Функция ПечатьВозврата(Сумма, ВариантОплаты) Экспорт
	
	Если ВариантОплаты.НомерВККМ=0 Тогда	// нерегистрируемый вариант оплаты
		Возврат Истина;
	КонецЕсли;
	
	// открытие чека
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "ОткрытьЧекВозврат";
	
	// возврат
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "Возврат";
	Задание.Параметры = СформироватьСписокПараметровВозврата("",Сумма,1,?(ВариантОплаты.НомерВККМ=1,1,0));
	
	// оплата
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "Оплата";
	Задание.Параметры = СформироватьСписокПараметровОплаты(Сумма,ВариантОплаты.НомерВККМ);
	
	// закрытие чека (параметры только для ШТРИХа)
	СписокПараметровЗакрытия = Новый Структура;
	СписокПараметровЗакрытия.Вставить("Summ"+ВариантОплаты.НомерВККМ,Сумма);
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "ЗакрытьЧек";
	Задание.Параметры = СписокПараметровЗакрытия;
	
	Возврат ОтправитьЗадание();
КонецФункции

// Формирование таблицы задания для печати чека начислений/удержаний
//
Функция ПечатьНачислений(Клиент, ДокОснование, Сумма, ВариантОплаты) Экспорт
	
	НомерВККМ = ?(ЗначениеЗаполнено(ВариантОплаты), ВариантОплаты.НомерВККМ, 1);
	
	Если НомерВККМ=0 Тогда	// нерегистрируемый вариант оплаты
		Возврат Истина;
	КонецЕсли;
	
	РежимВозврата = Сумма < 0;
	Сумма = Модуль(Сумма);
	
	// открытие чека
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = ?(РежимВозврата, "ОткрытьЧекВозврат", "ОткрытьЧекПродажа");
	
	Задание = ТаблицаЗадания.Добавить();
	Если ЗначениеЗаполнено(ДокОснование) Тогда
		Задание.Данные    = ?(РежимВозврата, "Возврат предоплаты", "Предоплата") + " по брони № " + ДокОснование.Номер;
	Иначе
		Задание.Данные    = ?(РежимВозврата, "Удержание со счета клиента", "Начисление на счет клиента");
	КонецЕсли; 
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Центр,ПереводСтроки";
	
	// печатаем остаток на счету клиента
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "";
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Центр,ПереводСтроки";
	
	Задание = ТаблицаЗадания.Добавить();
	Если ТипЗнч(Клиент) = Тип("СправочникСсылка.Клиенты") Тогда
		Задание.Данные    = "Клиент: "+Клиент.Наименование;
	Иначе
		Задание.Данные    = "ФИО клиента: "+Клиент;
	КонецЕсли; 
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Лево,ПереводСтроки";  
	
	Если НЕ РежимВозврата Тогда
		// продажа
		Задание = ТаблицаЗадания.Добавить();
		Задание.ТипДанных = "Регистрация";
		Задание.Параметры = СформироватьСписокПараметровРегистрации("Сумма начислено:",Сумма,1,1);
		
	Иначе
		// возврат
		Задание = ТаблицаЗадания.Добавить();
		Задание.ТипДанных = "Возврат";
		Задание.Параметры = СформироватьСписокПараметровВозврата("Сумма удержано:",Сумма,1,?(ВариантОплаты.НомерВККМ=1,1,0));
		
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ДокОснование) Тогда
		ОстатокБезнал = НакопленияКлиента(Клиент).СуммаБезнал; 
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "Остаток на счете: "+ФорматСумм(ОстатокБезнал);
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Лево,Переносить,ПереводСтроки";
	КонецЕсли;
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.Данные    = "СтрЧерта";
	Задание.ТипДанных = "Строка";
	Задание.Параметры = "Центр,ПереводСтроки";
	
	// оплата
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "Оплата";
	Задание.Параметры = СформироватьСписокПараметровОплаты(Сумма,НомерВККМ); 
	
	// закрытие чека (параметры только для ШТРИХа)
	СписокПараметровЗакрытия = Новый Структура;
	СписокПараметровЗакрытия.Вставить("Summ"+НомерВККМ,Сумма);  
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = "ЗакрытьЧек";
	Задание.Параметры = СписокПараметровЗакрытия;  
	
	Возврат ОтправитьЗадание();
КонецФункции

// Формирование таблицы задания для печати чека внесения/выплаты в кассу
//
Функция ПечатьВнесенияВыплаты(Действие, Сумма) Экспорт
	
	Задание = ТаблицаЗадания.Добавить();
	Задание.ТипДанных = Действие;
	Задание.Параметры = Новый Структура("Summ",Сумма);
	
	Возврат ОтправитьЗадание();
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ

Функция СформироватьСписокПараметровРегистрации(Name		= "",
												Price		= 0,
												Quantity	= 0,
												Department	= 1)
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Name",		Name);
	СписокПараметров.Вставить("Price",		Price);
	СписокПараметров.Вставить("Quantity",	Quantity);
	СписокПараметров.Вставить("Department",	Department);
	
	Возврат СписокПараметров;
	
КонецФункции

Функция СформироватьСписокПараметровВозврата(Name				= "",
											Price				= 0,
											Quantity			= 0,
											EnableCheckSumm	= 1)
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Name",		Name);
	СписокПараметров.Вставить("Price",		Price);
	СписокПараметров.Вставить("Quantity",	Quantity);
	СписокПараметров.Вставить("EnableCheckSumm",EnableCheckSumm);
	
	Возврат СписокПараметров;
	
КонецФункции

Функция СформироватьСписокПараметровОплаты(Summ = 0, TypeClose = 0)
	
	СписокПараметров = Новый Структура;
	СписокПараметров.Вставить("Summ",		Summ);
	СписокПараметров.Вставить("TypeClose",	TypeClose);
	
	Возврат СписокПараметров;
	
КонецФункции

Процедура ДобавитьНерегистрируемыеВариантыОплаты(ПротоколРасчетов, НерегистрируемаяСумма)
	
	Для каждого Протокол Из ПротоколРасчетов Цикл
		Если НЕ ЗначениеЗаполнено(Протокол.ВариантОплаты) ИЛИ ТипЗнч(Протокол.ВариантОплаты)<>Тип("СправочникСсылка.ВариантыОплаты") Тогда
			Продолжить;
		ИначеЕсли Протокол.ВариантОплаты.НомерВККМ<>0 Тогда
			Продолжить;
		КонецЕсли;
		
		НерегистрируемаяСумма = НерегистрируемаяСумма + Модуль(Протокол.Сумма);
		
		// печать нерегистрируемых сумм
		Если глПараметрыРМ.ПечатьЧекаНерегВО Тогда
			Задание = ТаблицаЗадания.Добавить();
			Задание.Данные    = Протокол.ВариантОплаты.Наименование + СтрДополнитьСлева("= "+ФорматСумм(Модуль(Протокол.Сумма)),ДлинаСуммы);
			Задание.ТипДанных = "Строка";
			Задание.Параметры = "Право,ПереводСтроки";
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры
 
// Добавление данных об оплате
//
Процедура ДобавитьОплату(ПротоколРасчетов, СписокПараметровЗакрытия)
	
	Для каждого Протокол Из ПротоколРасчетов Цикл
		
		Если НЕ ЗначениеЗаполнено(Протокол.ВариантОплаты) ИЛИ ТипЗнч(Протокол.ВариантОплаты)<>Тип("СправочникСсылка.ВариантыОплаты") Тогда
			Продолжить;
		ИначеЕсли Протокол.ВариантОплаты.НомерВККМ=0 Тогда
			Продолжить;
		КонецЕсли;
		
		Задание = ТаблицаЗадания.Добавить();
		Задание.ТипДанных = "Оплата";
		Задание.Параметры = СформироватьСписокПараметровОплаты(Модуль(Протокол.Сумма), Протокол.ВариантОплаты.НомерВККМ);
		
		// а это для драйвера компании "Штрих"
		ИмяСуммы = "Summ"+Протокол.ВариантОплаты.НомерВККМ;
		Если НЕ СписокПараметровЗакрытия.Свойство(ИмяСуммы) Тогда
			СписокПараметровЗакрытия.Вставить(ИмяСуммы, 0);
		КонецЕсли; 
		СписокПараметровЗакрытия[ИмяСуммы] = СписокПараметровЗакрытия[ИмяСуммы] + Модуль(Протокол.Сумма);
		
	КонецЦикла;
	
КонецПроцедуры

// Добавление НДС
//
Процедура ДобавитьНДС(Сумма)
	
	СтавкаНДС = 18; //Константы.ОсновнаяСтавкаНДС.Получить();
	СуммаНДС = Окр(Сумма*СтавкаНДС/(100+СтавкаНДС),2,1);
	
	Если СуммаНДС<>0 Тогда
		Задание = ТаблицаЗадания.Добавить();
		Задание.Данные    = "в т.ч. НДС:"+ФорматСумм1(СуммаНДС,ДлинаСуммы);
		Задание.ТипДанных = "Строка";
		Задание.Параметры = "Право,ПереводСтроки";
	КонецЕсли;
	
КонецПроцедуры

// Отправить сформированное задание на ККМ
//
Функция ОтправитьЗадание(Действие="")
	
	Если НЕ ЗначениеЗаполнено(Действие) Тогда
		Действие="Регистрация";
	КонецЕсли;
	
	Парам = Новый Структура;
	Парам.Вставить("ТаблицаЗадания"	,ТаблицаЗадания);
	
	Если ЗначениеЗаполнено(Пароль) Тогда
		Парам.Вставить("ИгнорироватьОбщийПароль" ,НЕ глПараметрыРМ.ККМИспользоватьТекПароль);
	Иначе
		Пароль = глПользователь.КодДоступа;
	КонецЕсли;
	
	Парам.Вставить("Пароль"		,Пароль);
	Парам.Вставить("Кассир"		,глПользователь.Наименование);	// это для СПАРКа и МУЛЬТИСОФТа
	Если ЗначениеЗаполнено(Заказ.ПодвалЧека) Тогда
		Подвал = Новый Массив;//РазложитьСтрокуВМассив(Заказ.ПодвалЧека, Символы.ПС);
	ИначеЕсли ЗначениеЗаполнено(Заказ) Тогда
		Подвал = Новый Массив;
		Подвал = РазложитьСтрокуВМассив("-   Спасибо, что стали гостем «Кухни Полли»!   -
		|-       Поделитесь своими впечатлениями        -
		|-           на www.kitchenpolly.ru             -", Символы.ПС)
	Иначе
		Подвал = Новый Массив;
	КонецЕсли;
	Если Подвал.Количество() Тогда
		Парам.Вставить("Подвал", Подвал);
	КонецЕсли;
	
	
	Попытка
		Результат = ККМ.ПолучитьОбъект().ВыполнитьДействие(Действие, Парам);
	Исключение
		Текст1="Нет доступа!";
		Текст2="Указана некорректная ККМ! Обратитесь к администратору...
		|" + 
		ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Сообщить(ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		Если НЕ ФоновыйРежим Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		КонецЕсли;
		
		Возврат Ложь;
	КонецПопытки;
	
	Если Результат.Ошибка Тогда
		Текст1 = Результат.Описание;
		Текст2 = Результат.Подробно;
		Если НЕ ФоновыйРежим Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка", Результат.Описание, Результат.Подробно, "","ОК","");
		КонецЕсли;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

#КонецЕсли