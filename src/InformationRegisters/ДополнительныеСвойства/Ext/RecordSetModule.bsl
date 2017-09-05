﻿
Процедура ПередЗаписью(Отказ, Замещение)
	ОД = ОбменДанными;
	ЕСли ОД.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Не Количество() Тогда
		Возврат;
	КонецЕсли;
	
	Всем = Ложь;
	ТекИБ = ПараметрыСеанса.ТекущаяИБ;
	
	Если Не ТекИБ.Предопределенный Тогда
		Возврат;
	КонецЕсли;
	Получатели = Новый Массив;
	
	Попытка
		ПланыОбмена.УдалитьРегистрациюИзменений(Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(Справочники.ГруппыИнформационныхБаз.ВсеИБ, Истина), ЭтотОбъект);	
	Исключение
	КонецПопытки;
	
	Для Каждого Т Из ЭтотОбъект Цикл
		Если Т.ИнформационнаяБаза = ТекИБ Тогда
			Продолжить;
		КонецЕсли;
		Если Т.ИнформационнаяБаза.Пустая() Тогда
			Всем = Истина;
		Иначе
			ИБ = ПланыОбмена.Основной.НайтиПоРеквизиту("ИнформационнаяБаза", Т.ИнформационнаяБаза);
			Попытка
				Получатели.Добавить(ИБ);	
			Исключение
			КонецПопытки;
			
		КонецЕсли;
	КонецЦикла;
	
	Если Всем Тогда
		Получатели = Справочники.ГруппыИнформационныхБаз.ИБпоГруппе(Справочники.ГруппыИнформационныхБаз.ВсеИБ, Истина);
	КонецЕсли;

		
		ОД.Получатели.Очистить();
		Для Каждого Т Из Получатели Цикл
			Попытка
				ОД.Получатели.Добавить(Т);	
			Исключение
			КонецПопытки;
			
		КонецЦикла;
КонецПроцедуры
