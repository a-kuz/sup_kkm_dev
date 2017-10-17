﻿Перем мСохрДатаС;
Перем мСохрДатаПо;
Перем мСохрИнтервал;

Процедура ВремяСНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ВыбратьВремя(Элемент.Значение, Элемент);
КонецПроцедуры

// Процедура инициирует диалог выбора времени.
//
// Параметры
//  ДатаВремен - дата для выбора времени
//  ТекЭлемент - элемент формы
//  ПолныйГод - булево, показывать год 4-мя цифрами или 2-мя
//
// Возвращаемое значение:
//  НЕТ
//
Процедура ВыбратьВремя(ДатаВремен, ТекЭлемент)
	
	НачалоРабочегоДняКонстанта 		= Дата(1,1,1,01,00,00);
	ОкончаниеРабочегоДняКонстанта 	= Дата(1,1,1,23,59,59);
	
	Если ДатаВремен = Дата(1,1,1) Тогда
		ДатаВремен = НачалоДня(ДатаС);
	КонецЕсли;
	
	СписокВремен = Новый СписокЗначений;
	НачалоРабочегоДня = НачалоДня(ДатаВремен)+Час(НачалоРабочегоДняКонстанта)*60*60+?(Минута(НачалоРабочегоДняКонстанта) >= 30, 30, 0)*60;
	Если Минута(ОкончаниеРабочегоДняКонстанта) = 0 Тогда
		МинутРабочегоОкончанияДня = 0;
	ИначеЕсли Минута(ОкончаниеРабочегоДняКонстанта) > 30 Тогда
		МинутРабочегоОкончанияДня = 60;
	Иначе
		МинутРабочегоОкончанияДня = 30;
	КонецЕсли; 
	ОкончаниеРабочегоДня = НачалоДня(ДатаВремен)+Час(ОкончаниеРабочегоДняКонстанта)*60*60+МинутРабочегоОкончанияДня*60;
	
	а = 0;
	Пока 1=1 Цикл
		ВремяСписка = НачалоРабочегоДня + а*60*60;
		Если ВремяСписка = ОкончаниеРабочегоДня Тогда
			ВремяСписка = ВремяСписка-60;
		КонецЕсли;
		Если ВремяСписка > ОкончаниеРабочегоДня Тогда
			Прервать;
		КонецЕсли;
		СписокВремен.Добавить(ВремяСписка, Формат(ВремяСписка,"ДФ='ЧЧ:мм'"));
		а = а + 1;
	КонецЦикла; 
	
	НачальноеЗначение = СписокВремен.НайтиПоЗначению(ДатаВремен);
	Если НачальноеЗначение = Неопределено Тогда
		ВыбранноеВремя = ЭтаФорма.ВыбратьИзСписка(СписокВремен, ТекЭлемент);
	Иначе
		ВыбранноеВремя = ЭтаФорма.ВыбратьИзСписка(СписокВремен, ТекЭлемент, НачальноеЗначение);
	КонецЕсли; 
	
	Если ВыбранноеВремя <> Неопределено Тогда
		ДатаВремен = ВыбранноеВремя.Значение;
	КонецЕсли; 
	
КонецПроцедуры // ВыбратьВремя()

Процедура ОсновныеДействияФормыОК(Кнопка)
	мСохрИнтервал = Истина;
	Закрыть("ОК");
КонецПроцедуры

Процедура ОсновныеДействияФормыОтмена(Кнопка)
	ЭтаФорма.Закрыть();
КонецПроцедуры

Процедура ПриОткрытии()
	
	мСохрДатаС 	= ДатаС;
	мСохрДатаПо = ДатаПо;
	
КонецПроцедуры

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Если мСохрИнтервал = Истина Тогда
		Если ДатаС >= ДатаПо Тогда
		   	Предупреждение("Неверно задан интервал");
			мСохрИнтервал = Ложь;
			Отказ = Истина;
		КонецЕсли;
	Иначе
		ДатаС  = мСохрДатаС;
		ДатаПо = мСохрДатаПо;		
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаВыбораПериодаНажатие(Элемент)
	
	НастройкаПериода = Новый НастройкаПериода;
	НастройкаПериода.ВариантНастройки = ВариантНастройкиПериода.Период;
	
	НастройкаПериода.УстановитьПериод(ДатаС, ДатаПо);
	
	Если НастройкаПериода.Редактировать() Тогда
		
		ДатаС = НастройкаПериода.ПолучитьДатуНачала();
		ДатаПо = НачалоМинуты(НастройкаПериода.ПолучитьДатуОкончания());

	КонецЕсли;
	
КонецПроцедуры



