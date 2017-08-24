﻿
Процедура ЗарегистрироватьСобытие(ИмяСобытия, Уровень = Неопределено, ОбъектМетаданных = Неопределено, Данные = Неопределено, Комментарий = "", РежимТранзакции = Неопределено) Экспорт
	ЗаписьЖурналаРегистрации(ИмяСобытия, Уровень, ОбъектМетаданных, Данные, Комментарий, РежимТранзакции);	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	ОбщегоНазначенияКлиент.ЗарегистрироватьСобытиеКлиент(ИмяСобытия, Уровень, ОбъектМетаданных, Данные, Комментарий, РежимТранзакции);
	#КонецЕсли
КонецПроцедуры

Функция глОтладкаУровень() Экспорт
	#Если Клиент Тогда
		ИК = ИмяКомпьютера();
		Если СтрНайти(ИК,"ws_it") Или СтрНайти(ИК,"s0") Или СтрНайти(ИК,"m0") Или СтрНайти(ИК,"k0") Тогда
			Возврат 1;
		Иначе
			Возврат 0;
		КонецЕсли;
	#Иначе
		Возврат 0;
	#КонецЕсли
КонецФункции


