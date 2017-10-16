﻿
Функция ЗарегистрироватьСобытиеКлиент(ИмяСобытия, Уровень = Неопределено, ОбъектМетаданных = Неопределено, Данные = Неопределено, Комментарий = "", РежимТранзакции = Неопределено) Экспорт
	      	
	//#Если НЕ ТонкийКлиент Тогда
	//	Если Уровень = УровеньЖурналаРегистрации.Ошибка Тогда
	//		РаботаСокнами = РаботаСокнами;
	//		Если Не РаботаСокнами = Неопределено И глОтладкаУровень() > 0 Тогда
	//			//:РаботаСокнами = Обработки.РаботаСокнами.Создать();
	//			РаботаСокнами.ПоказатьПлашку("Ошибочка :-(", Комментарий);
	//		КонецЕсли;
	//	КонецЕсли;
	//#КонецЕсли
	
	
	Если ПараметрыСеанса.ЖурналРегистрацииВsql Тогда
		ЖурналРегистрации.ЗаписатьСобытие(ИмяСобытия, Строка(Уровень), Комментарий, Данные);
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции
	
Функция ОтладкаУровень() Экспорт
	ИК = ИмяКомпьютера();
	Попытка
		Тест = глПараметрыРМ.Тест;
	Исключение
		Тест = Ложь;
	КонецПопытки;

	Если СтрНайти(ИК,"ws_it") Или СтрНайти(ИК,"s0") Или СтрНайти(ИК,"m0") Или СтрНайти(ИК,"k0") Или Тест Тогда
		Возврат 1;
	Иначе
		Возврат 0;
	КонецЕсли;
КонецФункции

Процедура ОбождатьМиллисекунд(Миллисекунды = 5000) Экспорт 
	
	Дедлайн = ТекущаяУниверсальнаяДатаВМиллисекундах() + Миллисекунды;
	Пока ТекущаяУниверсальнаяДатаВМиллисекундах() < Дедлайн Цикл
			
	КонецЦикла;
	
КонецПроцедуры




