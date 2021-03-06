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
	попытка
		Выход = Число(Товар.Выход);
	исключение
		Выход = 0;
	КонецПопытки;
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеБелков) тогда
		стрЭнергетика = стрЭнергетика + "Содержание Белков:    "+Формат(Товар.Номенклатура.СБ_СодержаниеБелков*?(Выход=0,1,Выход/100),"ЧЦ=6; ЧДЦ=2")+" гр" + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеЖиров) тогда
		стрЭнергетика = стрЭнергетика + "Содержание Жиров:    "+Формат(Товар.Номенклатура.СБ_СодержаниеЖиров*?(Выход=0,1,Выход/100),"ЧЦ=6; ЧДЦ=2")+" гр" + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеУглеводов) тогда
		стрЭнергетика = стрЭнергетика + "Содержание Углеводов:    "+Формат(Товар.Номенклатура.СБ_СодержаниеУглеводов*?(Выход=0,1,Выход/100),"ЧЦ=6; ЧДЦ=2")+" гр" + Символы.ПС;
	КонецЕсли;
	Если ЗначениеЗаполнено(товар.Номенклатура.СБ_СодержаниеККАЛ) тогда
		стрЭнергетика = стрЭнергетика + "Энерг. ценность:    "+Формат(Товар.Номенклатура.СБ_СодержаниеККАЛ*?(Выход=0,1,Выход/100),"ЧЦ=6; ЧДЦ=2")+" ККАЛ" + Символы.ПС;
	КонецЕсли;
	
	Если Выход <> 0 тогда
		стрЭнергетика = "Выход порции готового блюда: "+Выход+" гр"+Символы.ПС+"Пищевая и энергетическая ценность на 1 порцию:";
	Иначе
		стрЭнергетика = "Пищевая и энергетическая ценность на 100гр:" + стрЭнергетика; 
	КонецЕсли;
	
	ЭлементыФормы.Энергетика.Заголовок = стрЭнергетика;
//ТОВАРГЕТИНФО	
	ДопПараметрыИнфо = Новый Структура;
	ДопПараметрыИнфо.Вставить("Товар", Товар);
	ДопПараметрыИнфо.Вставить("Цена", Цена);
	ДопПараметрыИнфо.Вставить("КГЛ", КГЛ);
	ИнтерфейсРМ.ВыводНаИнфоДисплей("ПоказатьТоварИнфо", , , Неопределено, ДопПараметрыИнфо);
//~ТОВАРГЕТИНФО	
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
//ТОВАРГЕТИНФО
	ИнтерфейсРМ.ВыводНаИнфоДисплей("СкрытьТоварИнфо", , , , );
//~ТОВАРГЕТИНФО	
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
	
	Закрыть(Новый Структура);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
