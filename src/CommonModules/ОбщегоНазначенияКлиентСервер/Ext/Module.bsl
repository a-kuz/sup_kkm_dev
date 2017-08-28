﻿
Процедура ЗарегистрироватьСобытие(ИмяСобытия, Уровень = Неопределено, ОбъектМетаданных = Неопределено, Данные = Неопределено, Комментарий = "", РежимТранзакции = Неопределено) Экспорт
	#Если НЕ ТонкийКлиент Тогда
	ЗаписьЖурналаРегистрации(ИмяСобытия, Уровень, ОбъектМетаданных, Данные, Комментарий, РежимТранзакции);	
	#КонецЕсли
	#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	ОбщегоНазначенияКлиент.ЗарегистрироватьСобытиеКлиент(ИмяСобытия, Уровень, ОбъектМетаданных, Данные, Комментарий, РежимТранзакции);
	#КонецЕсли
КонецПроцедуры

Процедура ЗарегистрироватьСобытиеОшибки(ИнформацияОбОшибке, Данные = Неопределено) Экспорт
	#Если НЕ ТонкийКлиент Тогда
	ЗарегистрироватьСобытие("Ошибка выполнения", УровеньЖурналаРегистрации.Ошибка,,Данные,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке));	
	#КонецЕсли
КонецПроцедуры



Функция глОтладкаУровень() Экспорт
	#Если Клиент Тогда
		Возврат ОбщегоНазначенияКлиент.ОтладкаУровень();
	#Иначе
		Возврат 0;
	#КонецЕсли
КонецФункции


