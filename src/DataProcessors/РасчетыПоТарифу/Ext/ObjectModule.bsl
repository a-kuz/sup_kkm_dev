﻿
#Если Клиент Тогда

// Описание процедуры
//
Процедура РассчитатьПоТарифу( Тариф, РасчетыПоТарифу, Время1=Неопределено, Время2=Неопределено, МаксВремя=0 ) Экспорт
	
	Если ЗначениеЗаполнено(РасчетыПоТарифу) И ЗначениеЗаполнено(Время1) Тогда
		// если изменили начальное время, то считаем все заново
		Если РасчетыПоТарифу[0].Время1 <> Время1 Тогда
			РасчетыПоТарифу.Очистить();
		КонецЕсли;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(РасчетыПоТарифу) Тогда
		// надо запустить отсчет времени
		Если Не ЗначениеЗаполнено(Время1) Тогда
			Время1 = НачалоМинуты(ТекущаяДата());
			
			ВремяПодготовки = Число(Тариф.ВремяПодготовки.Код);
			Если ВремяПодготовки>0 Тогда
				Время1 = Время1 + ВремяПодготовки*60;
			КонецЕсли;
		КонецЕсли;
		
		ЦенаТарифа = НачальнаяЦенаТарифа(Тариф,Время1);
		
		СтрокаРасчета = РасчетыПоТарифу.Добавить();
		СтрокаРасчета.Время1 = Время1;
		СтрокаРасчета.Цена   = ЦенаТарифа;
	КонецЕсли;
	
	Время1 = РасчетыПоТарифу[0].Время1;
	
	Если МаксВремя>0 Тогда
		Время2 = Время1 + МаксВремя*60;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Время2) Тогда
		Возврат;
	КонецЕсли;
	
	// проверка интервала времени
	Дискретность = Число(Тариф.Дискретность.Код);
	МинВремя	 = Число(Тариф.МинВремя.Код);
	
	КолвоМинут = (Время2 - Время1) / 60;
	ФлагПересчет = Ложь;
	Если КолвоМинут % Дискретность <> 0 Тогда
		КолвоМинут = ОкруглитьЧисло( КолвоМинут/Дискретность, Тариф.ПравилоОкругления) * Дискретность;
		ФлагПересчет = Истина;
	КонецЕсли;
	Если КолвоМинут < МинВремя Тогда
		КолвоМинут = МинВремя;
		ФлагПересчет = Истина;
	КонецЕсли;
	Если ФлагПересчет = Истина Тогда
		Время2 = Время1 + КолвоМинут*60;
	КонецЕсли;
	
	// проверка на уменьшение интервала
	кс = РасчетыПоТарифу.Количество();
	Пока кс>1 И РасчетыПоТарифу[кс-1].Время1 > Время2 Цикл
		РасчетыПоТарифу.Удалить(кс-1);
		кс=кс-1;
	КонецЦикла;
	
	СтрокаРасчета = РасчетыПоТарифу[кс-1];
	
	// расчет по сетке
	Если Тариф.ВариантРасчета=0 Тогда
		
		ТарифнаяСетка = ПолучитьТарифнуюСетку(Тариф);
		
		ДатаРасчета = НачалоДня(СтрокаРасчета.Время1);
		ВремяРасчета = ВремяИзДаты(СтрокаРасчета.Время1);
		
		Пока ДатаРасчета <= НачалоДня(Время2) Цикл
			
			ТипДня = Защита.ОпределитьТипДня(ДатаРасчета);
			Если НЕ ЗначениеЗаполнено(ТипДня) Тогда
				ДатаРасчета = ДатаРасчета + 24*60*60;
				ВремяРасчета = '00010101';
				Продолжить;
			КонецЕсли;
			
			ИмяЦены		= "Цена"+ТипДня.Код;
			ИмяБесплатно= "Бесплатно"+ТипДня.Код;
			
			ВремяКонца = ?(ДатаРасчета < НачалоДня(Время2), КонецДня('00010101'), ВремяИзДаты(Время2) );
			
			Для каждого СтрокаСетки Из ТарифнаяСетка Цикл
				
				Если СтрокаСетки.Время >= ВремяКонца Тогда
					Прервать;
				ИначеЕсли СтрокаСетки.Время <= ВремяРасчета Тогда
					Продолжить;
				КонецЕсли;
				
				ЦенаТарифа = СтрокаСетки[ИмяЦены];
				Если ЦенаТарифа=0 И НЕ СтрокаСетки[ИмяБесплатно] Тогда
					Продолжить;
				ИначеЕсли ЦенаТарифа = СтрокаРасчета.Цена Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаРасчета.Время2 = УстановитьВремяВДате(ДатаРасчета, СтрокаСетки.Время);
				РасчетСуммыПоТарифу(Тариф, СтрокаРасчета);
				
				СтрокаРасчета = РасчетыПоТарифу.Добавить();
				СтрокаРасчета.Время1 = УстановитьВремяВДате(ДатаРасчета, СтрокаСетки.Время);
				СтрокаРасчета.Цена	 = ЦенаТарифа;
				
			КонецЦикла;
			
			ДатаРасчета = ДатаРасчета + 24*60*60;
			ВремяРасчета = '00010101';
		КонецЦикла;
		
	КонецЕсли;
	
	СтрокаРасчета.Время2 = Время2;
	РасчетСуммыПоТарифу(Тариф, СтрокаРасчета);
	
КонецПроцедуры

// Описание процедуры
//
Процедура РассчитатьПоТарифуПоСумме(Тариф, РасчетыПоТарифу, Время1=Неопределено, Время2=Неопределено, МаксСумма ) Экспорт
	
	Если Не ЗначениеЗаполнено(Время1) Тогда
		Время1 = НачалоМинуты(ТекущаяДата());
		
		ВремяПодготовки = Число(Тариф.ВремяПодготовки.Код);
		Если ВремяПодготовки>0 Тогда
			Время1 = Время1 + ВремяПодготовки*60;
		КонецЕсли;
	КонецЕсли;
	
	ЦенаТарифа = НачальнаяЦенаТарифа(Тариф,Время1);
	
	// расчет по сетке
	Если Тариф.ВариантРасчета=0 Тогда
		
		РасчетыПоТарифу.Очистить();
		СтрокаРасчета = РасчетыПоТарифу.Добавить();
		СтрокаРасчета.Время1 = Время1;
		СтрокаРасчета.Цена   = ЦенаТарифа;
		
		ТарифнаяСетка = ПолучитьТарифнуюСетку(Тариф);
		
		ДатаРасчета = НачалоДня(СтрокаРасчета.Время1);
		ВремяРасчета = ВремяИзДаты(СтрокаРасчета.Время1);
		
		Пока РасчетыПоТарифу.Итог("Сумма") < МаксСумма Цикл
			
			ТипДня = Защита.ОпределитьТипДня(ДатаРасчета);
			Если НЕ ЗначениеЗаполнено(ТипДня) Тогда
				ДатаРасчета = ДатаРасчета + 24*60*60;
				ВремяРасчета = '00010101';
				Продолжить;
			КонецЕсли;
			
			ИмяЦены		= "Цена"+ТипДня.Код;
			ИмяБесплатно= "Бесплатно"+ТипДня.Код;
			
			Для каждого СтрокаСетки Из ТарифнаяСетка Цикл
				
				Если СтрокаСетки.Время <= ВремяРасчета Тогда
					Продолжить;
				КонецЕсли;
				
				ЦенаТарифа = СтрокаСетки[ИмяЦены];
				Если ЦенаТарифа=0 И НЕ СтрокаСетки[ИмяБесплатно] Тогда
					Продолжить;
				ИначеЕсли ЦенаТарифа = СтрокаРасчета.Цена Тогда
					Продолжить;
				КонецЕсли;
				
				СтрокаРасчета.Время2 = УстановитьВремяВДате(ДатаРасчета, СтрокаСетки.Время);
				РасчетСуммыПоТарифу(Тариф, СтрокаРасчета);
				
				Если РасчетыПоТарифу.Итог("Сумма") = МаксСумма Тогда
					Время2 = СтрокаРасчета.Время2;
					Прервать;
				ИначеЕсли РасчетыПоТарифу.Итог("Сумма") > МаксСумма Тогда
					КолвоМинут = Цел( (РасчетыПоТарифу.Итог("Сумма")-МаксСумма) / СтрокаРасчета.Цена * Число(Тариф.ВремяЦены.Код) );
					Время2 = СтрокаРасчета.Время2 - КолвоМинут*60;
					Прервать;
				КонецЕсли;
				
				СтрокаРасчета = РасчетыПоТарифу.Добавить();
				СтрокаРасчета.Время1 = УстановитьВремяВДате(ДатаРасчета, СтрокаСетки.Время);
				СтрокаРасчета.Цена	 = ЦенаТарифа;
				
			КонецЦикла;
			
			ДатаРасчета = ДатаРасчета + 24*60*60;
			ВремяРасчета = '00010101';
		КонецЦикла;
		
	ИначеЕсли ЦенаТарифа>0 Тогда
		КолвоМинут = Цел(МаксСумма/ЦенаТарифа*Число(Тариф.ВремяЦены.Код));
		Время2 = Время1 + КолвоМинут*60;
		
	КонецЕсли;
	
	РассчитатьПоТарифу(Тариф, РасчетыПоТарифу, Время1, Время2);
	
	// Время2 может увеличиться с учетом дискретности
	Дискретность = Число(Тариф.Дискретность.Код);
	
	Если РасчетыПоТарифу.Итог("Сумма") > МаксСумма Тогда
		Время2 = Время2 - Дискретность*60;
		РассчитатьПоТарифу(Тариф, РасчетыПоТарифу, Время1, Время2);
	КонецЕсли;
	
КонецПроцедуры

// Описание процедуры
//
Процедура РасчетСуммыПоТарифу(Тариф, СтрокаРасчета);
	
	ЕдиницаЦены = Число(Тариф.ВремяЦены.Код);
	ЦенаМинуты = СтрокаРасчета.Цена / ЕдиницаЦены;
	
	СтрокаРасчета.КолвоМинут	= (СтрокаРасчета.Время2 - СтрокаРасчета.Время1) / 60;
	СтрокаРасчета.ВремяСтр		= ВремяСтрокой( СтрокаРасчета.КолвоМинут );
	
	СтрокаРасчета.Количество	= СтрокаРасчета.КолвоМинут / ЕдиницаЦены;
	СтрокаРасчета.Сумма			= СтрокаРасчета.КолвоМинут * ЦенаМинуты;
	
КонецПроцедуры

// Описание процедуры
//
Функция НачальнаяЦенаТарифа(Тариф, Знач ВремяРасчета=Неопределено) Экспорт
	
	Если глВерсия<3 Тогда
		Возврат 0;
	КонецЕсли;
	
	Если Тариф.ВариантРасчета=2 Тогда
		Возврат Тариф.Цена;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ВремяРасчета) Тогда
		ДатаРасчета = НачалоДня(ВремяРасчета);
		ВремяРасчета = ВремяИзДаты(ВремяРасчета);
	Иначе
		ДатаРасчета = НачалоДня(ТекущаяДата());
		ВремяРасчета = ВремяИзДаты(ТекущаяДата());
	КонецЕсли;
	
	ТарифнаяСетка = ПолучитьТарифнуюСетку(Тариф);
	
	Для н=1 По 7 Цикл
		
		ТипДня = Защита.ОпределитьТипДня(ДатаРасчета);
		
		Если ЗначениеЗаполнено(ТипДня) Тогда
			
			ИмяЦены		= "Цена"+ТипДня.Код;
			ИмяБесплатно= "Бесплатно"+ТипДня.Код;
			
			Инд = ТарифнаяСетка.Количество()-1;
			Пока Инд>=0 Цикл
				
				СтрокаСетки = ТарифнаяСетка[Инд];
				
				Если СтрокаСетки.Время <= ВремяРасчета И 
					(СтрокаСетки[ИмяЦены]<>0 ИЛИ СтрокаСетки[ИмяБесплатно]) Тогда
					
					Возврат СтрокаСетки[ИмяЦены];
				КонецЕсли;
				
				Инд = Инд - 1;
			КонецЦикла;
			
		КонецЕсли;
		
		ДатаРасчета = ДатаРасчета - 24*60*60;
		ВремяРасчета = КонецДня('00010101');
	КонецЦикла;
	
	Возврат 0;
КонецФункции

// Описание процедуры
//
Функция ПолучитьТарифнуюСетку(Тариф)
	
	Если НЕ ЗначениеЗаполнено(глТарифныеСетки) Тогда
		глТарифныеСетки = Новый ТаблицаЗначений;
		глТарифныеСетки.Колонки.Добавить("Тариф");
		глТарифныеСетки.Колонки.Добавить("Сетка");
		глТарифныеСетки.Колонки.Добавить("ДатаИзменения");
	КонецЕсли;
	
	СтрокаТС = глТарифныеСетки.Найти(Тариф,"Тариф");
	Если СтрокаТС = Неопределено Тогда
		СтрокаТС = глТарифныеСетки.Добавить();
		СтрокаТС.Тариф = Тариф;
	КонецЕсли;
	
	Если СтрокаТС.ДатаИзменения <> Тариф.ДатаИзменения Тогда
		СтрокаТС.Сетка = Защита.ЗаполнитьТарифнуюСетку(Тариф);
		СтрокаТС.ДатаИзменения = Тариф.ДатаИзменения;
		// заодно сбросим и типы дней
		глТипыДней = Неопределено;
	КонецЕсли; 
	
	Возврат СтрокаТС.Сетка;
КонецФункции

#КонецЕсли
