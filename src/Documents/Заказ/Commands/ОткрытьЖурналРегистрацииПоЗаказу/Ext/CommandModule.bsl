﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОткрытьЖРнаСервере(ПараметрКоманды);
	АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	Отбор=Новый Структура("Данные", ПараметрКоманды);            
	АнализЖурналаРегистрации.ОткрытьСОтбором(ПараметрКоманды.Дата - 86400, ,Отбор);

КонецПроцедуры

&НаСервере
Функция ОткрытьЖРнаСервере(Заказ)
	//АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
	//Отбор=Новый Структура("Данные", Заказ);            
	//АнализЖурналаРегистрации.ОткрытьСОтбором(Заказ.Дата - 86400, ,Отбор);
КонецФункции

