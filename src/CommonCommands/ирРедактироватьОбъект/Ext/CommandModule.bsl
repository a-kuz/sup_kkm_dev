﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ТонкийКлиент Или ВебКлиент Тогда
		ОткрытьФорму("Обработка.РедакторОбъектов.Форма.Форма", Новый Структура("Объект", ПараметрКоманды));
	#Иначе
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ПараметрКоманды);
	#КонецЕсли 
	
КонецПроцедуры
