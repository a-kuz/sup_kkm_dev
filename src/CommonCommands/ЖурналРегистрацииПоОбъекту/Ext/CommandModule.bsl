﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ЖурналРегистрации.Используется() Тогда
		
			ОткрытьФорму("Обработка.ЖурналРегистрацииТонкийКлиентSQL.Форма.ФормаСпискаУправляемая", Новый Структура("Данные", ПараметрКоманды));
		
	Иначе
		#Если ТонкийКлиент Или ВебКлиент Тогда
			ОткрытьФорму("Обработка.ЖурналРегистрацииТонкийКлиент.Форма.EventsJournal", Новый Структура("FilterData", ПараметрКоманды));
		#Иначе
			АнализЖурналаРегистрации = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализЖурналаРегистрации");
			Отбор=Новый Структура("Данные", ПараметрКоманды);            
			АнализЖурналаРегистрации.ОткрытьСОтбором(, ,Отбор);
			
		#КонецЕсли 
	КонецЕсли;
КонецПроцедуры
