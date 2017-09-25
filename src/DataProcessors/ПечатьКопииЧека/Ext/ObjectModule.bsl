﻿
#Если Клиент Тогда
	
	Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна
	
	Перем ТипЗначения	Экспорт;   // тип значения
	Перем Длина			Экспорт;   // длина
	Перем Точность		Экспорт;   // точность
	Перем Кратность		Экспорт;   // кратность
	
	Перем ТипПоляВвода	Экспорт;
	Перем ФлагОткрытия	Экспорт;
	Перем ФлагДроби		Экспорт;
	Перем ДробнаяЧасть	Экспорт;
	
	Перем ФормаВвода;
	
	// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
	// Вызывается каждый раз при обращении к объекту обработки.
	// Здесь надо прописать сброс переменных в начальные значения
	// Реквизиты и табличные части уже сброшены
	Процедура УстановкаНачальныхЗначений() Экспорт
		
	КонецПроцедуры
	
	Процедура ЗаполнитьЧеки() Экспорт
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 700
		                      |	докЗаказ.Ссылка КАК Заказ,
		                      |	докЗаказ.НомерЧека КАК НомерЧека,
		                      |	докЗаказ.Номер КАК НомерЗаказа,
		                      |	докЗаказ.ИтогоСумма КАК Сумма,
		                      |	ВЫРАЗИТЬ(докЗаказ.ПодвалЧека КАК СТРОКА(1000)) КАК ПодвалЧека,
		                      |	ЗаказДопИнф.ДатаЗакрытия КАК Время,
		                      |	МАКСИМУМ(ПротоколРасчетовПротокол.ВариантОплаты) КАК ТипОплаты
		                      |ИЗ
		                      |	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
		                      |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ КАК докЗаказ
		                      |		ПО ЗаказДопИнф.Заказ = докЗаказ.Ссылка
		                      |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПротоколРасчетов.Протокол КАК ПротоколРасчетовПротокол
		                      |		ПО ЗаказДопИнф.ПротоколРасчетов = ПротоколРасчетовПротокол.Ссылка
		                      |ГДЕ
		                      |	НЕ докЗаказ.ПометкаУдаления
		                      |	И ЗаказДопИнф.Статус = &СтатусЗакрыт
		                      |	И ПротоколРасчетовПротокол.Ссылка.Фирма = &Фирма
		                      |
		                      |СГРУППИРОВАТЬ ПО
		                      |	ЗаказДопИнф.ДатаЗакрытия,
		                      |	докЗаказ.Ссылка,
		                      |	докЗаказ.НомерЧека,
		                      |	докЗаказ.Номер,
		                      |	докЗаказ.ИтогоСумма,
		                      |	ВЫРАЗИТЬ(докЗаказ.ПодвалЧека КАК СТРОКА(1000))
		                      |
		                      |УПОРЯДОЧИТЬ ПО
		                      |	ЗаказДопИнф.ДатаЗакрытия УБЫВ");
		
		Запрос.УстановитьПараметр("СтатусЗакрыт", Перечисления.СтатусыЗаказа.Закрыт);
		Запрос.УстановитьПараметр("КассоваяСмена", Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы());
		Запрос.УстановитьПараметр("Фирма", глРабочееМесто.Фирма);
		Чеки.Загрузить(Запрос.Выполнить().Выгрузить());
	КонецПроцедуры
	
	////////////////////////////////////////////////////////////////////////////////
	// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ
	
	// Вызывается из обработчика ПередОткрытием форм этой обработки,
	// выполняет инициализацию рабочего места
	//
	Процедура ДействияПередОткрытиемФормы(ТекущаяФорма, Отказ) Экспорт
		ЗаполнитьЧеки();
		ФормаВвода = ТекущаяФорма;
		
	КонецПроцедуры
	
	////////////////////////////////////////////////////////////////////////////////
	// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ
	Процедура ОК() Экспорт
		
		ТипЧека = 0; // по умолчанию чек лояльности
		Если СтрНайти(Врег(глПараметрыРМ.ККМ.ИмяОбработки),"ФР_Атол326") = 0 Тогда
			Если ИнтерфейсРМ.ВопросПредупреждение("Печать копии чека","Копию какого чека расчатать?","","Фискального","","Лояльности") = "Фискального" тогда
			    ТипЧека = 1;
			Иначе
				ТипЧека = 0;
			КонецЕсли;
		КонецЕсли;
		//ФормаВвода.Закрыть(Заказ);
		СтрукВозврата = Новый Структура;
		СтрукВозврата.Вставить("Заказ",Заказ);
		СтрукВозврата.Вставить("ТипЧека",ТипЧека);
		
		ФормаВвода.Закрыть(СтрукВозврата);
		
	КонецПроцедуры
	
	
	////////////////////////////////////////////////////////////////////////////////
	////////////////////////////////////////////////////////////////////////////////
	
	ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
	
#КонецЕсли
