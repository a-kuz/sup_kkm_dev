﻿
#Область ОписаниеПеременных

Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

#КонецОбласти

#Область ОбработчикиСобытийФормы

Процедура ПриОткрытии()
	
	Для Инд = 1 По 3 Цикл
		ЭлементыФормы["Кнопка"+Инд+"Тень"].Видимость = ЭлементыФормы["Кнопка"+Инд].Видимость;
	КонецЦикла;
	
	ОбновитьКнопку1();
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	ЭлементыФормы.Текст1.Заголовок 	= Сокрп(Товар.Наименование);
	ЭлементыФормы.Коды.Заголовок 	= "Код СУП: "+Товар.Номенклатура.КодСУП+?(ЗначениеЗаполнено(Товар.PLU),"    PLU: "+Товар.PLU,"");
	
//ТОВАРГЕТИНФО
	УРЛ = ИнтерфейсРМЛояльность.СформироватьУрлТовараДляМонитораГостя(Товар, Цена, КГЛ, Истина);
	ЭлементыФормы.ТоварГетИнфо.Документ.URL = УРЛ;
	
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

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

// переключение режима предпросмотра
Процедура Кнопка1Нажатие(Элемент)
	РежимПредпросмотра = НЕ РежимПредпросмотра;
	ОбновитьКнопку1();
КонецПроцедуры

// добавить строку в заказ
Процедура Кнопка2Нажатие(Элемент)
	Закрыть(РежимПредпросмотра);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ОбновитьКнопку1()
	УстановитьПометкуКнопки(ЭлементыФормы.Кнопка1, РежимПредпросмотра, ?(РежимПредпросмотра, "ВЫКЛЮЧИТЬ
	|Предпросмотр", "ВКЛЮЧИТЬ
	|Предпросмотр"));
КонецПроцедуры

#КонецОбласти

#Область Инициализация

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

#КонецОбласти