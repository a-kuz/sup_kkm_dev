﻿
Процедура ПриЗаписи(Отказ, Замещение)
	глПараметрыРМ = глПараметрыРМ;
	Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		Если глПараметрыРМ = Неопределено или НЕ глПараметрыРМ.ККМЕсть Тогда
			Для каждого эл из ЭтотОбъект цикл
				Спр = эл.ДокументСсылка.РабочееМесто;
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
				ИмяфайлаПолучателя = СтрПуть + "СПУЛЛояльности_" + эл.ДокументСсылка.Номер + "_" + Наим + ".txt";
				Попытка
					КопироватьФайл(ИмяФайла,ИмяфайлаПолучателя);
				Исключение
					ЗаписьЖурналаРегистрации("Ошибка записи файла спула лояльности",УровеньЖурналаРегистрации.Ошибка,ЭтотОбъект,,"Ошибка доступа до " + Профиль);
				КонецПопытки;
			конеццикла;
		Иначе
			Для каждого эл из ЭтотОбъект цикл
				Каталог = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ПараметрыСеанса.ТекущаяИБ, "ПутьДляЛогирования");//Константы.ПутьДляЛогирования.Получить();
				Если Каталог = Неопределено Тогда
					Каталог = Константы.ПутьДляЛогирования.Получить();
				КонецЕсли;
				Каталог = ?(Прав(Каталог,1) = "\", Каталог, Каталог + "\") + Формат(ТекущаяДата(),"ДФ=yyyyMMdd") + "\";
				Профиль = эл.ДокументСсылка.РабочееМесто.ПрофильВхода;
				Поз = СтрНайти(Профиль,"\",НаправлениеПоиска.СКонца);
				Наим = Сред(Лев(Профиль,поз - 1),3);
				ИмяФайла = "СПУЛЛояльности_" + эл.ДокументСсылка.Номер + "_" + Наим + ".txt";
				ЗаписатьОбъектВФайл(Каталог + ИмяФайла,ЭтотОбъект);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
