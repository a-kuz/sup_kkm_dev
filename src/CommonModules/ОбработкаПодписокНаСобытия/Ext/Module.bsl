﻿#Если НЕ ТонкийКлиент Тогда
      	
// Подписка на событие при записи документа.
//
Процедура ПриЗаписиДокументов(ДокументОбъект, Отказ) Экспорт
	
	УправлениеРИБ.ЗарегистрироватьИзмененияДокумента(ДокументОбъект);
	
КонецПроцедуры

// Подписка на событие при записи справочника.
//
Процедура ПриЗаписиСправочников(СправочникОбъект, Отказ) Экспорт
	
	УправлениеРИБ.ЗарегистрироватьИзмененияСправочника(СправочникОбъект);
	
КонецПроцедуры

Процедура ПриЗаписиРегистраИнформационнаяБазаГруппаПриЗаписи(Источник, Отказ, Замещение) Экспорт
	ОбменДанными = Источник.ОбменДанными;
	Если ОбменДанными.загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Не Источник.Количество() Тогда
		ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
		ОбменДанными.Получатели.Очистить();
		Возврат;
	КонецЕсли;    
	Если Не ПараметрыСеанса.ТекущаяИБ.Предопределенный Тогда
		Источник.ОбменДанными.Получатели.Очистить();
		Возврат;
	КонецЕсли;
	//:Источник = РегистрыСведений.ДоступностьКаталоговТоваров.СоздатьНаборЗаписей();
	
	ИнформационнаяБазаГруппа = Источник[0].ИнформационнаяБазаГруппа;
	Если Не ЗначениеЗаполнено(ИнформационнаяБазаГруппа) ИЛИ ИнформационнаяБазаГруппа = Справочники.ГруппыИнформационныхБаз.ВсеИБ Тогда
		ОбменДанными.Получатели.АвтоЗаполнение = Истина;
		ОбменДанными.Получатели.Заполнить();
	ИначеЕсли ТипЗнч(ИнформационнаяБазаГруппа) = Тип("СправочникСсылка.ИнформационныеБазы") Тогда
		//:ИнформационнаяБазаГруппа = Справочники.ИнформационныеБазы.ПустаяСсылка();
		ОбменДанными.Получатели.АвтоЗаполнение = Ложь;
		ОбменДанными.Получатели.Очистить();
		Попытка
			ОбменДанными.Получатели.Добавить(ИнформационнаяБазаГруппа.ПолучитьОбъект().ПолучитьУзелРИБ());	
		Исключение
		КонецПопытки;
		
	ИначеЕсли ТипЗнч(ИнформационнаяБазаГруппа) = Тип("СправочникСсылка.ГруппыИнформационныхБаз") Тогда
		//:ИнформационнаяБазаГруппа = Справочники.ГруппыИнформационныхБаз.ПустаяСсылка();
		ОбменДанными.Получатели.АвтоЗаполнение = Ложь;		
		ОбменДанными.Получатели.Очистить();
		Узлы = Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(ИнформационнаяБазаГруппа, Истина);
		ОбменДанными.Получатели.Очистить();
		Для Каждого Узел Из Узлы Цикл
			//:Узел = ПланыОбмена.Основной.ПустаяСсылка();
			Если Узел.ЭтотУзел Тогда
				Продолжить;
			КонецЕсли;
			Попытка
				ОбменДанными.Получатели.Добавить(Узел);	
			Исключение
			КонецПопытки;
			
		КонецЦикла;
		
	КонецЕсли;

КонецПроцедуры

Процедура ПередУдалением(Источник, Отказ) Экспорт
	ЗарегистрироватьСобытие("Удаление", УровеньЖурналаРегистрации.Примечание,,Источник.Ссылка, ЗаписатьОбъектВстроку(Источник));
КонецПроцедуры


#КонецЕсли