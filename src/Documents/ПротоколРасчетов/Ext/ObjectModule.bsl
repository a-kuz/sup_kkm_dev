﻿
Процедура ОбработкаПроведения(Отказ, Режим)
	
	Если ОбменДанными.Загрузка Тогда
	
		Возврат	
	
	КонецЕсли; 

	
	//------------------------------------------------
	// Безнал и Бонусы
	СуммаБезнал = 0;
	СуммаБонусовЗакрыть = 0;
	СуммаНал = 0;
	
	Для Каждого СтрокаПротокола Из Протокол Цикл
		
		Если СтрокаПротокола.ВариантОплаты.Тип = Перечисления.ТипыОплаты.Безнал Тогда 
			СуммаБезнал = СуммаБезнал + СтрокаПротокола.СуммаФакт;
		ИначеЕсли СтрокаПротокола.ВариантОплаты.Тип = Перечисления.ТипыОплаты.Нал Тогда
			СуммаНал = СуммаНал + СтрокаПротокола.СуммаФакт;
		КонецЕсли; 
		
	КонецЦикла;
	
	Если СуммаНал <> 0 Тогда
		Если ЗначениеЗаполнено(Заказ) и ТипЗнч(Заказ) = Тип("ДокументСсылка.Возврат") Тогда
			СуммаНал = -1 * СуммаНал;
		КонецЕсли;
		Движение = Движения.ДенежныеОперации.Добавить();
		Движение.Период = Дата;
		Движение.РабочееМесто = РабочееМесто;//Заказ.РабочееМесто;
		Движение.ККМ = ККМ;
		Движение.Сумма = СуммаНал;
	КонецЕсли;
	
	Если ТипЗнч(Заказ) = Тип("ДокументСсылка.Заказ") Тогда
		Попытка
			Заказ.ПолучитьОбъект().ЗаписатьЗаказТоварыДопИнф();	
		Исключение
			ЗарегистрироватьСобытиеОшибки(ИнформацияОбОшибке(), Ссылка);
		КонецПопытки;
		
	КонецЕсли;                                             	
	
КонецПроцедуры

// Описание функции
//
Функция ЭтоПервыйПротокол()
	
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПротоколРасчетов.Ссылка
	|ИЗ
	|	Документ.ПротоколРасчетов КАК ПротоколРасчетов
	|ГДЕ
	|	НЕ ПротоколРасчетов.Неучетный
	|	И ПротоколРасчетов.Заказ = &Заказ
	|");
	
	Запрос.УстановитьПараметр("Заказ", Заказ);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() И Выборка.Ссылка = Ссылка Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Возврат Ложь;
КонецФункции

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
	
		Возврат	 
	
	КонецЕсли;
	Если Не Заказ.Пустая() Тогда
	
		
	
	КонецЕсли; 
	
	#Если Клиент Тогда
		Если ЭтоНовый() И Автор.Пустая() Тогда
			Автор = глПользователь;
		КонецЕсли;
	#КонецЕсли
КонецПроцедуры      

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	// Вставить содержимое обработчика.
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда
Процедура ПриЗаписи(Отказ)
	Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		Если глПараметрыРМ = Неопределено или НЕ глПараметрыРМ.ККМЕсть Тогда
			Спр = Заказ.РабочееМесто;
			ИмяФайла = ПолучитьИмяВременногоФайла("txt");
			ЗаписатьОбъектВФайл(ИмяФайла,ЭтотОбъект);
			Профиль = Спр.ПрофильВхода;
			Поз = СтрНайти(Профиль,"\",НаправлениеПоиска.СКонца);
			СтрПуть = Лев(Профиль,Поз-1);
			Наим = Сред(Профиль,Поз + 1);
			Сеть.ПодключитьШару(СтрПуть);
			СтрПуть = СтрПуть + "\";
			Каталог = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ПараметрыСеанса.ТекущаяИБ, "ПутьДляЛогирования");//Константы.ПутьДляЛогирования.Получить();
			Если Каталог = Неопределено Тогда
				Каталог = Константы.ПутьДляЛогирования.Получить();
			КонецЕсли;
			СтрПуть = СтрПуть + СтрЗаменить(Каталог,":","$");
			СтрПуть = ?(Прав(СтрПуть,1) = "\",СтрПуть,СтрПуть + "\");
			СтрПуть = СтрПуть + Формат(ТекущаяДата(),"ДФ=yyyyMMdd") + "\";
			ИмяфайлаПолучателя = СтрПуть + "ПротоколРасчетов_" + Заказ.Номер + "_" + Наим + ".txt";
			Попытка
				КопироватьФайл(ИмяФайла,ИмяфайлаПолучателя);
			Исключение
				ЗаписьЖурналаРегистрации("Ошибка записи файла протокол расчетов",УровеньЖурналаРегистрации.Ошибка,ЭтотОбъект,,"Ошибка доступа до " + Профиль);
			КонецПопытки;
		Иначе
			Каталог = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ПараметрыСеанса.ТекущаяИБ, "ПутьДляЛогирования");//Константы.ПутьДляЛогирования.Получить();
			Если Каталог = Неопределено Тогда
				Каталог = Константы.ПутьДляЛогирования.Получить();
			КонецЕсли;
			Профиль = Заказ.РабочееМесто.ПрофильВхода;
			Поз = СтрНайти(Профиль,"\",НаправлениеПоиска.СКонца);
			Наим = Сред(Профиль,поз + 1);
			ИмяФайла = ?(Прав(Каталог,1) = "\",Каталог,Каталог + "\")+ Формат(ТекущаяДата(),"ДФ=yyyyMMdd") + "\" + "ПротоколРасчетов_" + Заказ.Номер + "_" + Наим + ".txt";
			ЗаписатьОбъектВФайл(ИмяФайла,ЭтотОбъект);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
#КонецЕсли