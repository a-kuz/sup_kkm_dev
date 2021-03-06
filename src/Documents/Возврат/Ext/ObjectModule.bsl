﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
		
	Если ПараметрыСеанса.Версия=3 И Константы.НакопительныеСкидки.Получить() И НЕ Клиент.Пустая() Тогда
		
		Для каждого СтрокаТовара Из Товары Цикл
			Если СтрокаТовара.Количество=0 Тогда
				Продолжить;
			КонецЕсли; 
	
		КонецЦикла; 
		
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Для каждого Т Из Товары Цикл
			
		Если Не ЗначениеЗаполнено(Т.СтавкаНДС) Тогда
			Т.СтавкаНДС = Т.Товар.Категория.СтавкаНДС;
			ПроцентНДС = ОбщегоНазначенияПовтИсп.ЗначениеСтавкиНДС(Т.СтавкаНДС);
			Т.СуммаНДС = (Т.Сумма * ПроцентНДС)/(100+ПроцентНДС);
		КонецЕсли;
		
		Если Т.Количество = 0 Тогда
			Т.СуммаРозничная = 0;
			Т.Сумма = 0;
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

Функция идСтроки(НомерСтроки) Экспорт
	Возврат "" + ПараметрыСеанса.ТекущаяИБ.Код + "_" + Номер + "_" + НомерСтроки;
КонецФункции

#Если ТолстыйКлиентОбычноеПриложение Тогда
	Процедура ПриЗаписи(Отказ)
		Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
			Если глПараметрыРМ = Неопределено или НЕ глПараметрыРМ.ККМЕсть Тогда
				Спр = РабочееМесто;
				ИмяФайла = ПолучитьИмяВременногоФайла("txt");
				ЗаписатьОбъектВФайл(ИмяФайла,ЭтотОбъект);
				Профиль = Спр.ПрофильВхода;
				Поз = СтрНайти(Профиль,"\",НаправлениеПоиска.СКонца);
				СтрПуть = Лев(Профиль,Поз-1);
				Наим = Сред(СтрПуть,3);
				Сеть.ПодключитьШару(Наим);
				СтрПуть = СтрПуть + "\";
				Каталог = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ПараметрыСеанса.ТекущаяИБ, "ПутьДляЛогирования");//Константы.ПутьДляЛогирования.Получить();
				Если Каталог = Неопределено Тогда
					Каталог = Константы.ПутьДляЛогирования.Получить();
				КонецЕсли;
				СтрПуть = СтрПуть + СтрЗаменить(Каталог,":","$");
				СтрПуть = ?(Прав(СтрПуть,1) = "\",СтрПуть,СтрПуть + "\");
				СтрПуть = СтрПуть + Формат(ТекущаяДата(),"ДФ=yyyyMMdd") + "\";
				ИмяфайлаПолучателя = СтрПуть + "Возврат_" + Номер + "_" + Наим + ".txt";
				Попытка
					КопироватьФайл(ИмяФайла,ИмяфайлаПолучателя);
				Исключение
					ЗарегистрироватьСобытие("Ошибка записи файла возврат",УровеньЖурналаРегистрации.Ошибка,ЭтотОбъект,,"Ошибка доступа до " + Профиль);
				КонецПопытки;
			Иначе
				Каталог = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ПараметрыСеанса.ТекущаяИБ, "ПутьДляЛогирования");//Константы.ПутьДляЛогирования.Получить();
				Если Каталог = Неопределено Тогда
					Каталог = Константы.ПутьДляЛогирования.Получить();
				КонецЕсли;
				Профиль = РабочееМесто.ПрофильВхода;
				Поз = СтрНайти(Профиль,"\",НаправлениеПоиска.СКонца);
				Наим = Сред(Лев(Профиль,поз - 1),3);
				ИмяФайла = ?(Прав(Каталог,1) = "\",Каталог,Каталог + "\")+ Формат(ТекущаяДата(),"ДФ=yyyyMMdd") + "\" + "Возврат_" + Номер + "_" + Наим + ".txt";
				ЗаписатьОбъектВФайл(ИмяФайла,ЭтотОбъект);
			КонецЕсли;		
		КонецЕсли;
	КонецПроцедуры
#КонецЕсли

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() и ЗначениеЗаполнено(ДополнительныеСвойства.ИмяКомпьютера) Тогда
		Профиль = ДополнительныеСвойства.ИмяКомпьютера;
		Поз = СтрНайти(Профиль,"-");
		Поз1 = СтрНайти(Профиль,"\");
		Префикс = Сред(Профиль,Поз + 1,Поз1 - 1);
	Иначе
		Префикс = "000";
	КонецЕсли;
КонецПроцедуры
