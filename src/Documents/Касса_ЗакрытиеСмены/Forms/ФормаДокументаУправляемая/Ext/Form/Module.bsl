﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	СтруктураПарам = Объект.Ссылка.ПараметрыСмены.Получить();
	
	Для Каждого Т ИЗ СтруктураПарам Цикл
		ЗаполнитьЗначенияСвойств(ПараметрыЗакрытия.Добавить(), Т);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНеуправляемуюФорму(Команда)
	#Если Не ТонкийКлиент Тогда
		ДокументОбъект = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.Касса_ЗакрытиеСмены"));//:ДокументОбъект = Документы.Касса_ЗакрытиеСмены.СоздатьДокумент();
		ДокументОбъект.ПолучитьФорму("ФормаДокумента").Открыть();
		Закрыть();
	#КонецЕсли
КонецПроцедуры
