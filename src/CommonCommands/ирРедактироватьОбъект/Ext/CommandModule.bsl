﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна в вебклиенте");
	#ИначеЕсли ТонкийКлиент или ТолстыйКлиентУправляемоеПриложение Тогда
		ОткрытьФорму("Обработка.ирРедакторОбъектаБД.Форма.ФормаУпр", Новый Структура("Ключ",ПараметрКоманды));
	#Иначе
		ирОбщий.ОткрытьСсылкуВРедактореОбъектаБДЛкс(ПараметрКоманды);
	#КонецЕсли 
	
КонецПроцедуры

