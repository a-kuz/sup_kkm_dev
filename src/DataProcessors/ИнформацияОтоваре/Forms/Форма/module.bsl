﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	Для Инд = 3 По 3 Цикл
		ЭлементыФормы["Кнопка"+Инд+"Тень"].Видимость = ЭлементыФормы["Кнопка"+Инд].Видимость;
	КонецЦикла;
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	ЭлементыФормы.Текст1.Заголовок 	= Сокрп(Товар.Наименование);
	ЭлементыФормы.Коды.Заголовок 	= "Код СУП: "+Товар.Номенклатура.КодСУП+?(ЗначениеЗаполнено(Товар.PLU),"    PLU: "+Товар.PLU,"");
	ЭлементыФормы.Состав.Заголовок 	= "Состав:"+Символы.ПС+Сокрп(Товар.Номенклатура.Состав);
	стрЭнергетика = "";
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеБелков) тогда
		стрЭнергетика = стрЭнергетика + "Содержание Белков:    "+Формат(Товар.Номенклатура.СБ_СодержаниеБелков,"ЧЦ=6; ЧДЦ=2")+" на 100 г.";
	КонецЕсли;
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеЖиров) тогда
		стрЭнергетика = стрЭнергетика + "Содержание Жиров:     "+Формат(Товар.Номенклатура.СБ_СодержаниеЖиров,"ЧЦ=6; ЧДЦ=2")+" на 100 г.";
	КонецЕсли;
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеУглеводов) тогда
		стрЭнергетика = стрЭнергетика + "Содержание Углеводов: "+Формат(Товар.Номенклатура.СБ_СодержаниеУглеводов,"ЧЦ=6; ЧДЦ=2")+" на 100 г.";
	КонецЕсли;
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеККАЛ) тогда
		стрЭнергетика = стрЭнергетика + "Энерг. ценность:      "+Формат(Товар.Номенклатура.СБ_СодержаниеККАЛ,"ЧЦ=6; ЧДЦ=2")+" ккал/кДж на 100 г.";
	КонецЕсли;
	
	ЭлементыФормы.Энергетика.Заголовок = стрЭнергетика;
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	Если НЕ ВводДоступен() Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура Кнопка3Нажатие(Элемент)
	
	Закрыть();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
