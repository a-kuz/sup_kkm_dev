﻿#Если Клиент Тогда
	
	// Процедура осуществляет печать документа. Можно направить печать на 
	// экран или принтер, а также распечатать необходимое количество копий.
	//
	//  Название макета печати передается в качестве параметра,
	// по переданному названию находим имя макета в соответствии.
	//
	// Параметры:
	//  ИмяМакета             - строка, название макета.
	//  КоличествоЭкземпляров - количество экземпляров печатных форм.
	//  НаПринтер             - выводить печатную форму на принтер.
	//  ИмяПринтера           - имя принтера, на котором производится печать.
	//
	Процедура Печать(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь, ИмяПринтера = Неопределено) Экспорт
		
		// Получить экземпляр документа на печать
		Если ИмяМакета = "Заказ" тогда
			ТабДокумент = ПечатьЗаказа();
			
		ИначеЕсли ТипЗнч(ИмяМакета) = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
			Попытка
				Обработка = ПолучитьОбработкуИзСправочникаВнешнихОбработок(ИмяМакета);
				ТабДокумент = Обработка.Печать(ЭтотОбъект);
			Исключение
				Сообщить("Ошибка открытия печатной формы!");
				Возврат;
			КонецПопытки;
		КонецЕсли;
		
		ТабДокумент.Показать();
		
	КонецПроцедуры //Печать()
	
	// Функция формирует табличный документ с печатной формой заказа
	// 
	Функция ПечатьЗаказа()
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	Заказ.Номер КАК НомерДок,
		|	Заказ.Автор КАК Официант,
		|	Заказ.МестоРеализации,
		|	Заказ.ПосадочноеМесто КАК ПосадочноеМесто,
		|	Заказ.Клиент,
		|	Заказ.КоличествоПосетителей,
		|	Заказ.ИтоговаяСумма
		|ИЗ
		|	Документ.Заказ КАК Заказ
		|ГДЕ
		|	Заказ.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказТовары.НомерСтроки КАК НомерСтроки,
		|	ЗаказТовары.Товар,
		|	ЗаказТовары.Количество,
		|	ЗаказТовары.КоличествоУдалено КАК Удалено,
		|	ЗаказТовары.Цена,
		|	ЗаказТовары.СуммаРеализации
		|ИЗ
		|	Документ.Заказ.Товары КАК ЗаказТовары
		|ГДЕ
		|	ЗаказТовары.Ссылка = &Ссылка
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЗаказСкидки.Тип,
		|	ЗаказСкидки.Скидка,
		|	ЗаказСкидки.Сумма
		|ИЗ
		|	Документ.Заказ.Скидки КАК ЗаказСкидки
		|ГДЕ
		|	ЗаказСкидки.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Удаление.Товар,
		|	Удаление.Количество,
		|	Удаление.Причина КАК ПричинаУдаления,
		|	Удаление.Сумма,
		|	Удаление.Автор
		|ИЗ
		|	Документ.Удаление КАК Удаление
		|ГДЕ
		|	Удаление.Заказ = &Ссылка
		|	И Удаление.ПометкаУдаления = ЛОЖЬ";
		
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		РезультатыЗапроса = Запрос.ВыполнитьПакет();
		ВыборкаШапка  	= РезультатыЗапроса[0].Выбрать();
		ВыборкаТовары 	= РезультатыЗапроса[1].Выбрать();
		ВыборкаСкидки 	= РезультатыЗапроса[2].Выбрать();
		ВыборкаУдалений = РезультатыЗапроса[3].Выбрать();
		КонстантаВалюта = Константы.ОсновнаяВалюта.Получить();
		
		// Данные о протоколе расчетов
		Отбор 			= Новый Структура("Заказ", Ссылка);
		ЗаписиРегистра 	= РегистрыСведений.ЗаказДопИнф.Получить(Отбор);
		печДатаОткрытия = ЗаписиРегистра.ДатаОткрытия;
		печДатаЗакрытия = ЗаписиРегистра.ДатаЗакрытия;
		печКассир 		= ЗаписиРегистра.ПротоколРасчетов.Автор;
		печИтоговаяСумма = 0;
		
		Таб = Новый ТабличныйДокумент;
		Макет = ПолучитьМакет("Заказ");
		
		// Шапка
		ОбластьШапки = Макет.ПолучитьОбласть("Шапка");
		Если ВыборкаШапка.Следующий() Тогда
			ОбластьШапки.Параметры.Заполнить(ВыборкаШапка);
			ОбластьШапки.Параметры.ДатаОткрытия 	= печДатаОткрытия;
			ОбластьШапки.Параметры.ДатаЗакрытия 	= печДатаЗакрытия;
			ОбластьШапки.Параметры.Кассир 			= печКассир;
			ОбластьШапки.Параметры.ПосадочноеМесто 	= ВыборкаШапка.ПосадочноеМесто.Наименование;// + " № " + ВыборкаШапка.ПосадочноеМесто.Код;
			ОбластьШапки.Параметры.КоличествоПосетителей = ЧеловекПрописью(ОбластьШапки.Параметры.КоличествоПосетителей); 
			печИтоговаяСумма = ВыборкаШапка.ИтоговаяСумма;
		КонецЕсли;
		
		Таб.Вывести(ОбластьШапки);
		
		// Товары
		ОбластьЗаголовка = Макет.ПолучитьОбласть("ЗаголовокТовары");
		Таб.Вывести(ОбластьЗаголовка);
		
		КоличествоИтого = 0;
		УдаленоИтого 	= 0;
		СписаноИтого 	= 0;
		СуммаИтого 	 	= 0;
		печНаличные = 0;
		печБезнал = 0;
		печБанкКарта = 0;
		печНеплательщик = 0;
		
		ОбластьСтроки = Макет.ПолучитьОбласть("СтрокаТовары");
		Пока ВыборкаТовары.Следующий() Цикл
			ОбластьСтроки.Параметры.Заполнить(ВыборкаТовары);
			КоличествоИтого = КоличествоИтого + ВыборкаТовары.Количество;
			УдаленоИтого 	= УдаленоИтого + ВыборкаТовары.Удалено;
			СуммаИтого 	 	= СуммаИтого + ВыборкаТовары.СуммаРеализации;
			Таб.Вывести(ОбластьСтроки);
		КонецЦикла;
		
		ОбластьИтоги = Макет.ПолучитьОбласть("ИтогиТовары");
		ОбластьИтоги.Параметры.КоличествоИтого = КоличествоИтого;
		ОбластьИтоги.Параметры.УдаленоИтого = УдаленоИтого;
		ОбластьИтоги.Параметры.СуммаИтого = СуммаИтого;
		Таб.Вывести(ОбластьИтоги);
		// Скидки
		ЕстьСкидки = ВыборкаСкидки.Количество() > 0;
		Если ЕстьСкидки Тогда
			ОбластьЗаголовка = Макет.ПолучитьОбласть("ЗаголовокСкидки");
			Таб.Вывести(ОбластьЗаголовка);
			ОбластьСтроки = Макет.ПолучитьОбласть("СтрокаСкидки");
			СуммаИтого = 0;
			ОбластьИтоги = Макет.ПолучитьОбласть("ИтогиСкидки");
		КонецЕсли;
		Пока ВыборкаСкидки.Следующий() Цикл
			ОбластьСтроки.Параметры.Заполнить(ВыборкаСкидки);
			СуммаИтого = СуммаИтого + ВыборкаСкидки.Сумма; 
			Таб.Вывести(ОбластьСтроки);
		КонецЦикла;
		Если ЕстьСкидки Тогда
			ОбластьИтоги.Параметры.СуммаИтого = СуммаИтого;
			ОбластьИтоги.Параметры.СуммаБезСкидок = Строка(?(СуммаИтого > 0, печИтоговаяСумма+СуммаИтого, печИтоговаяСумма-СуммаИтого))
			+ " " + КонстантаВалюта;
			Таб.Вывести(ОбластьИтоги);
		КонецЕсли;
		
		// Удаления
		Если ВыборкаУдалений.Количество() > 0 Тогда
			ОбластьЗаголовка = Макет.ПолучитьОбласть("ЗаголовокУдалений");
			Таб.Вывести(ОбластьЗаголовка);
			ОбластьСтроки = Макет.ПолучитьОбласть("СтрокаУдалений");
			НомерСтроки = 1;
		КонецЕсли;		
		Пока ВыборкаУдалений.Следующий() Цикл
			ОбластьСтроки.Параметры.Заполнить(ВыборкаУдалений);
			ОбластьСтроки.Параметры.НомерСтроки = НомерСтроки;
			Таб.Вывести(ОбластьСтроки);
			НомерСтроки = НомерСтроки + 1;
		КонецЦикла;
		
		
		// Протокол расчетов
		Протокол = ЗаписиРегистра.ПротоколРасчетов.Протокол.Выгрузить().Скопировать();
		Оплата 	 = ПолучитьТаблицуОплаты(Протокол);
		
		Если Протокол.Количество() > 0 Тогда
			ОбластьЗаголовка = Макет.ПолучитьОбласть("ЗаголовокПротокола");
			Таб.Вывести(ОбластьЗаголовка);
			ОбластьСтроки = Макет.ПолучитьОбласть("СтрокаПротокола");
			НомерСтроки = 1;
		КонецЕсли;	
		Для Каждого СтрокаПротокола Из Протокол Цикл
			
			ЗаполнитьЗначенияСвойств(ОбластьСтроки.Параметры, СтрокаПротокола);
			Таб.Вывести(ОбластьСтроки);
			
		КонецЦикла;
		
		Для Каждого СтрокаОплаты Из Оплата Цикл
			ТипОплаты = СтрокаОплаты.Тип;
			Если НЕ ЗначениеЗаполнено(ТипОплаты) Тогда
				Продолжить;
			КонецЕсли;
			СуммаОплаты = СтрокаОплаты.Сумма;
			Если ТипОплаты = Перечисления.ТипыОплаты.Нал Тогда
				печНаличные = СуммаОплаты;
			ИначеЕсли ТипОплаты = Перечисления.ТипыОплаты.Безнал Тогда
				печБезнал = СуммаОплаты;
			ИначеЕсли ТипОплаты = Перечисления.ТипыОплаты.Карта Тогда
				печБанкКарта = СуммаОплаты;
			ИначеЕсли ТипОплаты = Перечисления.ТипыОплаты.Неплательщик Тогда
				печНеплательщик = СуммаОплаты;				
			КонецЕсли;
			
		КонецЦикла;
		
		// Итоги
		
		ОбластьИтоги 	= Макет.ПолучитьОбласть("Итоги");
		Если печНаличные > 0 Тогда
			ОбластьИтоги.Параметры.Наличными  	= Строка(Формат(печНаличные, "ЧЦ=12; ЧДЦ=2;")) + " " + КонстантаВалюта;
		КонецЕсли;
		Если печБезнал > 0 Тогда
			ОбластьИтоги.Параметры.Безнал 	 	= Строка(Формат(печБезнал, "ЧЦ=12; ЧДЦ=2;")) + " " + КонстантаВалюта;
		КонецЕсли;
		Если печБанкКарта > 0 Тогда
			ОбластьИтоги.Параметры.БанкКарта 	= Строка(Формат(печБанкКарта, "ЧЦ=12; ЧДЦ=2;")) + " " + КонстантаВалюта;
		КонецЕсли;
		Если печНеплательщик > 0 Тогда
			ОбластьИтоги.Параметры.Неплательщик = Строка(Формат(печНеплательщик, "ЧЦ=12; ЧДЦ=2;")) + " " + КонстантаВалюта;
		КонецЕсли;
		Если печИтоговаяСумма > 0 Тогда
			ОбластьИтоги.Параметры.ИтоговаяСумма = Строка(Формат(печИтоговаяСумма, "ЧЦ=12; ЧДЦ=2;")) + " " + КонстантаВалюта;
		КонецЕсли;	
		
		Таб.Вывести(ОбластьИтоги);
		
		Таб.ОтображатьГруппировки = Ложь;
		Таб.ОтображатьЗаголовки = Ложь;
		Таб.ОтображатьСетку = Ложь;
		Таб.ТолькоПросмотр = Истина;
		Таб.Показать("Заказ № " + ВыборкаШапка.НомерДок);
		
		Возврат Таб;
		
	КонецФункции //ПечатьЗаказа()
	
	// Возвращает доступные варианты печати документа.
	//
	// Параметры:
	//  Нет.
	//
	// Возвращаемое значение:
	//  Структура, каждая строка которой соответствует одному из вариантов печати.
	//  
	Функция ПолучитьСписокПечатныхФорм() Экспорт
		
		СписокМакетов = Новый СписокЗначений;
		СписокМакетов.Добавить("Заказ",	"Заказ");
		
		ЗаполнитьСписокОбработок(СписокМакетов, Перечисления.ВидыОбработок.ПечатнаяФорма, ЭтотОбъект.Метаданные().ПолноеИмя(), Истина, Ложь);
		Возврат СписокМакетов;
		
	КонецФункции
	
#КонецЕсли

// Возвращает информацию о количестве человек
//
Функция ЧеловекПрописью(Количество)
	
	Если Количество=0 Тогда
		Возврат "< не указано >";
	КонецЕсли;
	
	Склонение="";
	Если (Количество<10) ИЛИ (Количество>20) Тогда
		ПервыйРазряд=Количество%10;
		Если (ПервыйРазряд=2) ИЛИ (ПервыйРазряд=3) ИЛИ (ПервыйРазряд=4) Тогда
			Склонение="а";
		КонецЕсли;
	КонецЕсли;
	
	Возврат Строка(Количество)+" человек"+Склонение;
	
КонецФункции //ЧеловекПрописью()

// Возвращает таблицу оплаты по типам
//
Функция ПолучитьТаблицуОплаты(Протокол) Экспорт
	
	Запрос = Новый Запрос;
	// Разнесем оплату по видам
	Запрос.Текст = "ВЫБРАТЬ
	|	Протокол.ВариантОплаты КАК ВариантОплаты,
	|	Протокол.СуммаФакт КАК Сумма
	|ПОМЕСТИТЬ Таб
	|ИЗ
	|	&Протокол КАК Протокол
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таб.ВариантОплаты.Тип КАК Тип,
	|	СУММА(Таб.Сумма) КАК Сумма
	|ИЗ
	|	Таб КАК Таб
	|
	|СГРУППИРОВАТЬ ПО
	|	Таб.ВариантОплаты.Тип";
	
	Запрос.УстановитьПараметр("Протокол", Протокол);
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции //ПолучитьТаблицуОплаты()
