﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьУстройства();
	
	Если КоммутируемыеУстройства.Количество() = 0 Тогда
		Текст1 = "Нет устройств!";
		Текст2 = "Нет подключенных коммутируемых устройств!";
	    ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	ВсегоСтраниц = КоммутируемыеУстройства.Количество() / КолвоКнопок;
	Если Цел(ВсегоСтраниц) <> ВсегоСтраниц Тогда
		ВсегоСтраниц = Цел(ВсегоСтраниц) + 1;
	КонецЕсли;
	ТекСтраница = 1;
	
	ВывестиТекущуюСтраницу(ЭтаФорма);
	
	ПравоВкл = ПланыВидовХарактеристик.ПраваДоступа.УправлениеКоммутаторомВкл;
	ЭлементыФормы.КнопкаПерезагрузитьОчередь.Видимость = ИнтерфейсРМ.ПроверкаПраваДоступа(ПравоВкл);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
			
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаСтрелкаВверхНажатие(Элемент)
	
	ТекСтраница = ТекСтраница - 1;
	ВывестиТекущуюСтраницу(ЭтаФорма);
	
КонецПроцедуры

Процедура КнопкаСтрелкаВнизНажатие(Элемент)
	
	ТекСтраница = ТекСтраница + 1;
	ВывестиТекущуюСтраницу(ЭтаФорма);
	
КонецПроцедуры

Процедура КнопкаВыбораНажатие(Элемент)
	
	ВклВыклТекущееУстройство(ЭтаФорма);
	
КонецПроцедуры

Процедура КнопкаПерезагрузитьОчередьНажатие(Элемент)
	
	ПерезагрузитьОчередьСобытий();
	
	// полностью обновим данные по каналам
	ЗаполнитьУстройства();
	ТекСтраница = 1;
	ВывестиТекущуюСтраницу(ЭтаФорма);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

КолвоКнопок = 10;