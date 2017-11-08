﻿#Если НЕ ТонкийКлиент Тогда
      	
Процедура ОбработкаСобытийКлючаЗащиты(Событие="EVENT_DONGLE_NO",Парам2=1) Экспорт
КонецПроцедуры

Функция ПолучитьДанные(Источник, Событие, Данные, Парам4=Истина) Экспорт
	
	Если найти(Источник,"Штрих АС POS") <> 0 Тогда //"Штрих АС POS" Тогда
		Весы = глТорговоеОборудование.Scale1C;
		Весы.УдалитьСообщение();
		Весы.ПосылкаДанных = Истина;
		Возврат "";
	КонецЕсли;
	
	Если Найти(ВРег(Источник),"COM") <> 0 Тогда
		Если Событие = "ДанныеКарты" Тогда // ридер z-2 mf
			Возврат Данные;
		Иначе
			Возврат "";
		КонецЕсли;
	КонецЕсли;

	Если Найти(Источник, "BarCode") > 0 Тогда
		Сканер = глТорговоеОборудование.Scaner1C;
		Сканер.УдалитьСообщение();  
		Сканер.ПосылкаДанных = 1;
		
		Данные = Сканер.Данные;
		Попытка
			Данные = СтрЗаменить(Данные, Символ(10), "");
			Данные = СтрЗаменить(Данные, Символ(13), "");
		Исключение
		КонецПопытки;
		
		Возврат Данные;
	Иначе
		Сканер = глТорговоеОборудование.Scaner1C;
		Сканер.УдалитьСообщение();  
		Сканер.ПосылкаДанных = 1;
		
		Данные = Сканер.Данные;
		Попытка
			Данные = СтрЗаменить(Данные, Символ(10), "");
			Данные = СтрЗаменить(Данные, Символ(13), "");
			Данные = СтрЗаменить(Данные, "?|", "");
			Данные = СтрЗаменить(Данные, "|?", "");
		Исключение
		КонецПопытки;
		
		Возврат Данные;
	КонецЕсли;
	
КонецФункции

#КонецЕсли 