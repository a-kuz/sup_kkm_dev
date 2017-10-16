﻿Функция КассовыйОтчетКраткий() Экспорт
	Смена = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы();
	Если Смена.пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	Смена = Смена.НомерСмены;
	Отчет = Новый Массив;
	Отчет.Добавить(" ");
	Отчет.Добавить("Кассовый отчет за смену " + Смена);
	Отчет.Добавить("Касса		: " + глПараметрыРМ.ККМ.КодСуп);
	Отчет.Добавить("Смена		: " + Смена);
	Отчет.Добавить("Напечатал	: " + глПользователь.Наименование);
	Отчет.Добавить("Вид отчета	: Краткий");
	//Отчет.Добавить("123456789012345678901234567890123456789012345678");
	Отчет.Добавить(" ");
	Отчет.Добавить("По всем кассирам                           Сумма");
	Отчет.Добавить("------------------------------------------------");
	Отчет.Добавить("Приход");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДенежныеОперации.РабочееМесто,
	               |	СУММА(ДенежныеОперации.Сумма) КАК Сумма
	               |ИЗ
	               |	РегистрНакопления.ДенежныеОперации КАК ДенежныеОперации
	               |ГДЕ
	               |	ДенежныеОперации.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) И КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	               |	И ВЫБОР
	               |			КОГДА &Знак
	               |				ТОГДА ДенежныеОперации.Сумма > 0
	               |			ИНАЧЕ ДенежныеОперации.Сумма < 0
	               |		КОНЕЦ
	               |	И ДенежныеОперации.РабочееМесто = &РабочееМесто
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДенежныеОперации.РабочееМесто";
	Запрос.УстановитьПараметр("Период",ТекущаяДатаНаСервере());
	Запрос.УстановитьПараметр("РабочееМесто",глРабочееМесто);
	Запрос.УстановитьПараметр("Знак",Истина);
	Выборка = Запрос.Выполнить().Выбрать();
	СуммаПриход = 0;
	Пока Выборка.Следующий() Цикл
		СуммаПриход = Выборка.Сумма;
	КонецЦикла;
	СуммаСтрокой = Формат(СуммаПриход,"ЧГ=3,0");
	ТекстСтроки = "  Руб ";
	Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	Отчет.Добавить("Возврат");
	Запрос.УстановитьПараметр("Знак",ложь);
	Выборка = Запрос.Выполнить().Выбрать();
	СуммаВозврат = 0;
	Пока Выборка.Следующий() Цикл
		СуммаВозврат = Выборка.Сумма;
	КонецЦикла;
	СуммаВозврат = ?(СуммаВозврат < 0, -1*СуммаВозврат,СуммаВозврат);
	СуммаСтрокой = Формат(СуммаВозврат,"ЧГ=3,0");
	ТекстСтроки = "  Руб ";
	Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	Отчет.Добавить("Чистая выручка");
	СуммаВыручки = СуммаПриход - СуммаВозврат;
	СуммаСтрокой = Формат(СуммаВыручки,"ЧГ=3,0");
	ТекстСтроки = "  Руб ";
	Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	Отчет.Добавить(" ");
	Отчет.Добавить("" + ТекущаяДата() + " Зав № " + глПараметрыРМ.ККМ.ЗаводскойНомер);
	Отчет.Добавить(" ");
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);
	
	ВхПараметры = новый Структура;
	ВхПараметры.Вставить("Строки",Отчет);
	ВыхПараметры = новый Структура;
	
	Попытка
		Ответ = Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
		Возврат Ложь;
	КонецПопытки;
	
	Если не Ответ Тогда
		Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = "";
			ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
			Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
				 ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
			КонецЦикла;
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка кассового отчета краткий",ТекстОшибки,"","","ОК","");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция КассовыйОтчетПодробный() Экспорт
	Смена = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы();
	Если Смена.пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	Смена = Смена.НомерСмены;
	Отчет = Новый Массив;
	Отчет.Добавить(" ");
	Отчет.Добавить("Кассовый отчет за смену " + Смена);
	Отчет.Добавить("Касса		: " + глПараметрыРМ.ККМ.КодСуп);
	Отчет.Добавить("Смена		: " + Смена);
	Отчет.Добавить("Напечатал	: " + глПользователь.Наименование);
	Отчет.Добавить("Вид отчета	: Подробный");
	//Отчет.Добавить("123456789012345678901234567890123456789012345678");
	Отчет.Добавить(" ");
	Отчет.Добавить("                                           Сумма");
	Отчет.Добавить("------------------------------------------------");
	Отчет.Добавить(" ");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ВЫБОР
	               |			КОГДА ДенежныеОперации.Сумма > 0
	               |				ТОГДА ДенежныеОперации.Сумма
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК СуммаПриход,
	               |	ДенежныеОперации.Регистратор.Автор КАК Автор,
	               |	СУММА(ВЫБОР
	               |			КОГДА ДенежныеОперации.Сумма < 0
	               |				ТОГДА ДенежныеОперации.Сумма
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК СуммаВозврат
	               |ИЗ
	               |	РегистрНакопления.ДенежныеОперации КАК ДенежныеОперации
	               |ГДЕ
	               |	ДенежныеОперации.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) И КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	               |	И ДенежныеОперации.Регистратор ССЫЛКА Документ.ПротоколРасчетов
	               |	И ДенежныеОперации.РабочееМесто = &РабочееМесто
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДенежныеОперации.Регистратор.Автор
	               |
	               |ИМЕЮЩИЕ
	               |	(СУММА(ВЫБОР
	               |				КОГДА ДенежныеОперации.Сумма > 0
	               |					ТОГДА ДенежныеОперации.Сумма
	               |				ИНАЧЕ 0
	               |			КОНЕЦ) <> 0
	               |		ИЛИ СУММА(ВЫБОР
	               |				КОГДА ДенежныеОперации.Сумма < 0
	               |					ТОГДА ДенежныеОперации.Сумма
	               |				ИНАЧЕ 0
	               |			КОНЕЦ) <> 0)";
	Запрос.УстановитьПараметр("Период",ТекущаяДатаНаСервере());
	Запрос.УстановитьПараметр("РабочееМесто",глРабочееМесто);
	Выборка = Запрос.Выполнить().Выбрать();
	ИтогоЧистаяВыручка = 0;
	Пока Выборка.Следующий() Цикл
		
		Отчет.Добавить(" ");
		СуммаПриход = Выборка.СуммаПриход;
		СуммаВозврат = Выборка.СуммаВозврат;
		Автор = Выборка.Автор;
		
		СуммаСтрокой = Формат(СуммаПриход,"ЧГ=3,0");
		ТекстСтроки = "  Руб ";
		Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
			ТекстСтроки = ТекстСтроки + " ";
		КонецЦикла;
		Отчет.Добавить("Приход");
		Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
		Отчет.Добавить("Возврат");
		
		СуммаВозврат = ?(СуммаВозврат < 0, -1*СуммаВозврат,СуммаВозврат);
		СуммаСтрокой = Формат(СуммаВозврат,"ЧГ=3,0");
		ТекстСтроки = "  Руб ";
		Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
			ТекстСтроки = ТекстСтроки + " ";
		КонецЦикла;
		Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
		
		Отчет.Добавить("Чистая выручка");
		СуммаВыручки = СуммаПриход - СуммаВозврат;
		ИтогоЧистаяВыручка = ИтогоЧистаяВыручка + СуммаВыручки;
		СуммаСтрокой = Формат(СуммаВыручки,"ЧГ=3,0");
		ТекстСтроки = "  Руб ";
		Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
			ТекстСтроки = ТекстСтроки + " ";
		КонецЦикла;
		Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
		Отчет.Добавить(" ");
		Отчет.Добавить("------------------------------------------------");
		
		
	КонецЦикла;

	Отчет.Добавить("Итого чистая выручка");
	СуммаСтрокой = Формат(ИтогоЧистаяВыручка,"ЧГ=3,0");
	ТекстСтроки = "  Руб ";
	Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	Отчет.Добавить(" ");
	
	Отчет.Добавить("" + ТекущаяДата() + " Зав № " + глПараметрыРМ.ККМ.ЗаводскойНомер);
	Отчет.Добавить(" ");
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
	ВхПараметры = новый Структура;
	ВхПараметры.Вставить("Строки",Отчет);
	ВыхПараметры = новый Структура;
	
	Попытка
		Ответ = Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
		Возврат Ложь;
	КонецПопытки;
	
	Если не Ответ Тогда
		Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = "";
			ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
			Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
				 ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
			КонецЦикла;
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка кассового отчета краткий",ТекстОшибки,"","","ОК","");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция КассовыйОтчет() Экспорт
	Смена = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы();
	Если Смена.пустая() Тогда
		Возврат Ложь;
	КонецЕсли;
	Смена = Смена.НомерСмены;
	Отчет = Новый Массив;
	Отчет.Добавить(" ");
	Отчет.Добавить("Кассовый отчет");
	Отчет.Добавить("Касса " + глПараметрыРМ.ККМ.КодСуп);
	Отчет.Добавить("Смена " + Смена);
	Отчет.Добавить("Дата: " + ТекущаяДатаНаСервере());
	Отчет.Добавить("Кассир " + глПользователь.Наименование);
	//Отчет.Добавить("123456789012345678901234567890123456789012345678");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕСТЬNULL(СУММА(ВЫБОР
	               |				КОГДА ПротоколРасчетовПротокол.ВариантОплаты = ЗНАЧЕНИЕ(Справочник.ВариантыОплаты.Наличные)
	               |					ТОГДА ПротоколРасчетовПротокол.СуммаФакт
	               |				ИНАЧЕ 0
	               |			КОНЕЦ), 0) КАК Нал,
	               |	ЕСТЬNULL(СУММА(ВЫБОР
	               |				КОГДА ПротоколРасчетовПротокол.ВариантОплаты = ЗНАЧЕНИЕ(Справочник.ВариантыОплаты.Карта)
	               |					ТОГДА ПротоколРасчетовПротокол.СуммаФакт
	               |				ИНАЧЕ 0
	               |			КОНЕЦ), 0) КАК БНал
	               |ИЗ
	               |	Документ.ПротоколРасчетов.Протокол КАК ПротоколРасчетовПротокол
	               |ГДЕ
	               |	ПротоколРасчетовПротокол.Ссылка.ККМ = &ККМ
				   //|	и ПротоколРасчетовПротокол.Ссылка.Заказ.РабочееМесто = &РабочееМесто
	               |	И ПротоколРасчетовПротокол.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	               |	И ПротоколРасчетовПротокол.Ссылка.Заказ ССЫЛКА Документ.Заказ
	               |	И ПротоколРасчетовПротокол.Ссылка.Проведен
	               |	И НЕ ПротоколРасчетовПротокол.Ссылка.ПометкаУдаления";
	Запрос.УстановитьПараметр("РабочееМесто",глРабочееМесто);
	Запрос.УстановитьПараметр("Дата",ТекущаяДата());
	Запрос.УстановитьПараметр("ККМ",глПараметрыРМ.ККМ);
	ВыборкаПриход = Запрос.Выполнить().Выбрать();
	СуммаПриходНал = 0;
	СуммаПриходБНал = 0;
	Пока ВыборкаПриход.Следующий() Цикл
		СуммаПриходНал = ВыборкаПриход.Нал;
		СуммаПриходБНал = ВыборкаПриход.БНал;
	КонецЦикла;
	СуммаИтогоПриход = СуммаПриходНал + СуммаПриходБНал;
	
	Отчет.Добавить("------------------------------------------");
	
	СуммаСтрокой = Формат(СуммаИтогоПриход,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "Приход ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по кол  Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	СуммаСтрокой = Формат(СуммаПриходНал,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "    Наличными ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	СуммаСтрокой = Формат(СуммаПриходБНал,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "    Электронными ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"ССЫЛКА Документ.Заказ","ССЫЛКА Документ.Возврат");
	ВыборкаВозврат = Запрос.Выполнить().Выбрать();
	СуммаВозвратНал = 0;
	СуммаВозвратБНал = 0;
	Пока ВыборкаВозврат.Следующий() Цикл
		СуммаВозвратНал = ВыборкаВозврат.Нал;
		СуммаВозвратБНал = ВыборкаВозврат.БНал;
	КонецЦикла;
	СуммаИтогоВозврат = СуммаВозвратНал + СуммаВозвратБНал;

	Отчет.Добавить("------------------------------------------");
	
	СуммаСтрокой = Формат(-1*СуммаИтогоВозврат,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "Возврат ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	СуммаСтрокой = Формат(-1*СуммаВозвратНал,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "    Наличными ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ПротоколРасчетовПротокол.Ссылка.Заказ.Автор.Наименование КАК ЗаказАвтор,
	               |	ПротоколРасчетовПротокол.Ссылка.Заказ.НомерЧека КАК ЗаказНомерЧека,
	               |	ПротоколРасчетовПротокол.Ссылка.Заказ.Дата КАК ЗаказДата,
	               |	ПротоколРасчетовПротокол.ВариантОплаты КАК ВариантОплаты,
	               |	СУММА(ПротоколРасчетовПротокол.СуммаФакт) КАК СуммаФакт
	               |ИЗ
	               |	Документ.ПротоколРасчетов.Протокол КАК ПротоколРасчетовПротокол
	               |ГДЕ
	               |	ПротоколРасчетовПротокол.Ссылка.ККМ = &ККМ
				   //|	И ПротоколРасчетовПротокол.Ссылка.РабочееМесто = &РабочееМесто
	               |	И ПротоколРасчетовПротокол.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	               |	И ПротоколРасчетовПротокол.Ссылка.Заказ ССЫЛКА Документ.Возврат
	               |	И НЕ ПротоколРасчетовПротокол.Ссылка.ПометкаУдаления
	               |	И ПротоколРасчетовПротокол.Ссылка.Проведен
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ПротоколРасчетовПротокол.Ссылка.Заказ.Автор,
	               |	ПротоколРасчетовПротокол.Ссылка.Заказ.НомерЧека,
	               |	ПротоколРасчетовПротокол.Ссылка.Заказ.Дата,
	               |	ПротоколРасчетовПротокол.ВариантОплаты";
				   
	ВыборкаВозврат = Запрос.Выполнить().Выбрать();
	Сч = 0;
	Пока ВыборкаВозврат.Следующий() Цикл
		Если ВыборкаВозврат.ВариантОплаты = Справочники.ВариантыОплаты.Наличные Тогда
			Сч = Сч + 1;
			ТекстСтроки = "    Возврат " + Формат(Сч,"ЧГ=0") + " - " + СокрЛП(ВыборкаВозврат.ЗаказАвтор);
			Отчет.Добавить(ТекстСтроки);
			СуммаСтрокой = Формат(-1*ВыборкаВозврат.СуммаФакт,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
			ТекстСтроки = "    №" + Формат(ВыборкаВозврат.ЗаказНомерЧека,"ЧГ=0") + "," + Формат(ВыборкаВозврат.ЗаказДата,"ДФ=ЧЧ:мм") + "," + ?(ВыборкаВозврат.ВариантОплаты = Справочники.ВариантыОплаты.Наличные,"нал","б/нал");//?(ВыборкаВозврат.ВариантОплаты = Перечисления.ТипыОплаты.Нал,"нал","б/нал");
			Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
			Если Кол < 0 Тогда
				Отчет.Добавить(ТекстСтроки);
				ТекстСтроки = "    ";
				Кол = 41 - СтрДлина(СуммаСтрокой);
				Для к = 1 по Кол Цикл
					ТекстСтроки = ТекстСтроки + " ";
				КонецЦикла;
				Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
			Иначе
				Для к = 1 по Кол Цикл
					ТекстСтроки = ТекстСтроки + " ";
				КонецЦикла;
				Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Отчет.Добавить("------------------------------------------");
	
	СуммаСтрокой = Формат(-1*СуммаВозвратБНал,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "    Электронными ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	ВыборкаВозврат.Сбросить();
	Сч = 0;
	Пока ВыборкаВозврат.Следующий() Цикл
		Если ВыборкаВозврат.ВариантОплаты <> Справочники.ВариантыОплаты.Наличные Тогда
			Сч = Сч + 1;
			ТекстСтроки = "    Возврат " + Формат(Сч,"ЧГ=0") + " - " + СокрЛП(ВыборкаВозврат.ЗаказАвтор);
			Отчет.Добавить(ТекстСтроки);
			СуммаСтрокой = Формат(-1*ВыборкаВозврат.СуммаФакт,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
			ТекстСтроки = "    №" + Формат(ВыборкаВозврат.ЗаказНомерЧека,"ЧГ=0") + "," + Формат(ВыборкаВозврат.ЗаказДата,"ДФ=ЧЧ:мм") + "," + ?(ВыборкаВозврат.ВариантОплаты = Справочники.ВариантыОплаты.Наличные,"нал","б/нал");//?(ВыборкаВозврат.ВариантОплаты = Перечисления.ТипыОплаты.Нал,"нал","б/нал");
			Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
			Если Кол < 0 Тогда
				Отчет.Добавить(ТекстСтроки);
				ТекстСтроки = "    ";
				Кол = 41 - СтрДлина(СуммаСтрокой);
				Для к = 1 по Кол Цикл
					ТекстСтроки = ТекстСтроки + " ";
				КонецЦикла;
				Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
			Иначе
				Для к = 1 по Кол Цикл
					ТекстСтроки = ТекстСтроки + " ";
				КонецЦикла;
				Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Отчет.Добавить("------------------------------------------");
	
	//Отчет.Добавить("123456789012345678901234567890123456789012345678");
	Запрос.Текст = "ВЫБРАТЬ
	               |	СУММА(ВЫБОР
	               |			КОГДА ДенежныеОперации.Сумма > 0
	               |				ТОГДА ДенежныеОперации.Сумма
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК СуммаВнесения,
	               |	ДенежныеОперации.Регистратор.Автор.Наименование КАК Автор,
	               |	ДенежныеОперации.Период КАК Период
	               |ИЗ
	               |	РегистрНакопления.ДенежныеОперации КАК ДенежныеОперации
	               |ГДЕ
	               |	ДенежныеОперации.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	               |	И НЕ ДенежныеОперации.Регистратор ССЫЛКА Документ.ПротоколРасчетов
	               |	И ДенежныеОперации.РабочееМесто = &РабочееМесто
	               |	И ДенежныеОперации.ККМ = &ККМ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДенежныеОперации.Регистратор.Автор.Наименование,
	               |	ДенежныеОперации.Период
	               |
	               |ИМЕЮЩИЕ
	               |	СУММА(ВЫБОР
	               |			КОГДА ДенежныеОперации.Сумма > 0
	               |				ТОГДА ДенежныеОперации.Сумма
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) <> 0
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";
	ТаблВнесение = Запрос.Выполнить().Выгрузить();
	СуммаИтогоВнесение = ТаблВнесение.Итог("СуммаВнесения");
	
	СуммаСтрокой = Формат(СуммаИтогоВнесение,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "Внесение ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	Сч = 0;
	для каждого СтрВнес из ТаблВнесение Цикл
		Сч = Сч + 1;
		ТекстСтроки = "    Внесение " + Формат(Сч,"ЧГ=0") + " - " + СокрЛП(СтрВнес.Автор);
		Отчет.Добавить(ТекстСтроки);
		СуммаСтрокой = Формат(СтрВнес.СуммаВнесения,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
		ТекстСтроки = "    " + Формат(СтрВнес.Период,"ДФ=ЧЧ:мм");
		Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
		Для к = 1 по Кол Цикл
			ТекстСтроки = ТекстСтроки + " ";
		КонецЦикла;
		Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	КонецЦикла;
	
	Запрос.Текст = СтрЗаменить(Запрос.Текст,"ДенежныеОперации.Сумма > 0","ДенежныеОперации.Сумма < 0");
	
	ТаблИзъятие = Запрос.Выполнить().Выгрузить();
	СуммаИтогоИзъятие = ТаблИзъятие.Итог("СуммаВнесения");
	
	Отчет.Добавить("------------------------------------------");
	
	СуммаСтрокой = Формат(СуммаИтогоИзъятие,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "Изъятие ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	Сч = 0;
	для каждого СтрИзъя из ТаблИзъятие Цикл
		Сч = Сч + 1;
		ТекстСтроки = "    Изъятие " + Формат(Сч,"ЧГ=0") + " - " + СокрЛП(СтрИзъя.Автор);
		Отчет.Добавить(ТекстСтроки);
		СуммаСтрокой = Формат(СтрИзъя.СуммаВнесения,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
		ТекстСтроки = "    " + Формат(СтрИзъя.Период,"ДФ=ЧЧ:мм");
		Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
		Для к = 1 по Кол Цикл
			ТекстСтроки = ТекстСтроки + " ";
		КонецЦикла;
		Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	КонецЦикла;
	
	Отчет.Добавить("------------------------------------------");
	
	СуммаИтогоНаличность = СуммаПриходНал - СуммаВозвратНал + СуммаИтогоВнесение + СуммаИтогоИзъятие;
	СуммаСтрокой = Формат(СуммаИтогоНаличность,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "Наличность в кассе ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	
	СуммаЧистаяВыручка = СуммаПриходНал - СуммаВозвратНал + СуммаПриходБНал - СуммаВозвратБНал;//СуммаИтогоНаличность + СуммаПриходБНал + СуммаВозвратБНал;
	СуммаСтрокой = Формат(СуммаЧистаяВыручка,"ЧДЦ=2; ЧН=0,00; ЧГ=3,0");
	ТекстСтроки = "Чистая выручка ";
	Кол = 41 - СтрДлина(ТекстСтроки) - СтрДлина(СуммаСтрокой);
	Для к = 1 по Кол Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	Отчет.Добавить(" ");
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
	ВхПараметры = новый Структура;
	ВхПараметры.Вставить("Строки",Отчет);
	ВыхПараметры = новый Структура;
	
	Попытка
		Ответ = Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
		Возврат Ложь;
	КонецПопытки;
	
	Если не Ответ Тогда
		Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = "";
			ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
			Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
				 ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
			КонецЦикла;
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка кассового отчета",ТекстОшибки,"","","ОК","");
		КонецЕсли;
	КонецЕсли;
КонецФункции

Функция НаличиеВКассе() экспорт
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
	ВхПараметры = Новый Структура;
	ВыхПараметры = Новый Структура;
	
	Попытка
		Ответ = Обработка_ККМ.ВыполнитьКоманду("ПолучитьТекущееСостояние",ВхПараметры,ВыхПараметры);
	Исключение
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
		Возврат Ложь;
	КонецПопытки;
	
	Если не Ответ Тогда
		Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = "";
			ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
			Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
				 ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
			КонецЦикла;
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка наличие денег в кассе",ТекстОшибки,"","","ОК","");
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Отчет = Новый Массив;
	Отчет.Добавить(" ");
	Отчет.Добавить("Касса		: " + глПараметрыРМ.ККМ.КодСуп);
	Отчет.Добавить("Напечатал	: " + глПользователь.Наименование);
	//Отчет.Добавить("Вид отчета	: Краткий");
	//Отчет.Добавить("123456789012345678901234567890123456789012345678");
	Отчет.Добавить(" ");
	Отчет.Добавить("Остаток по кассе                           Сумма");
	Отчет.Добавить("------------------------------------------------");
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДенежныеОперации.РабочееМесто КАК РабочееМесто,
	               |	СУММА(ДенежныеОперации.Сумма) КАК Сумма
	               |ИЗ
	               |	РегистрНакопления.ДенежныеОперации КАК ДенежныеОперации
	               |ГДЕ
	               |	ДенежныеОперации.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) И КОНЕЦПЕРИОДА(&Период, ДЕНЬ)
	               |	И ДенежныеОперации.РабочееМесто = &РабочееМесто
	               |	И ВЫБОР
	               |			КОГДА ДенежныеОперации.Регистратор ССЫЛКА Документ.ПротоколРасчетов
	               |				ТОГДА ДенежныеОперации.Регистратор.КассоваяСмена.НомерСмены = &НомерСмены
	               |			ИНАЧЕ ДенежныеОперации.Регистратор.СменаКассы.НомерСмены = &НомерСмены
	               |		КОНЕЦ
	               |	И ДенежныеОперации.ККМ = &ККМ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ДенежныеОперации.РабочееМесто";
	Запрос.УстановитьПараметр("Период",ТекущаяДатаНаСервере());
	Запрос.УстановитьПараметр("РабочееМесто",глРабочееМесто);
	Запрос.УстановитьПараметр("ККМ",глПараметрыРМ.ККМ);
	Запрос.УстановитьПараметр("НомерСмены",ВыхПараметры.НомерСмены);
	Выборка = Запрос.Выполнить().Выбрать();
	СуммаПриход = 0;
	Пока Выборка.Следующий() Цикл
		СуммаПриход = Выборка.Сумма;
	КонецЦикла;
	СуммаСтрокой = Формат(СуммаПриход,"ЧГ=3,0");
	ТекстСтроки = "  Руб ";
	Для к = 1 по 41 - СтрДлина(СуммаСтрокой) Цикл
		ТекстСтроки = ТекстСтроки + " ";
	КонецЦикла;
	Отчет.Добавить(ТекстСтроки + СуммаСтрокой);
	Отчет.Добавить(" ");
	Отчет.Добавить("" + ТекущаяДата() + " Зав № " + глПараметрыРМ.ККМ.ЗаводскойНомер);
	Отчет.Добавить(" ");
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
	ВхПараметры = новый Структура;
	ВхПараметры.Вставить("Строки",Отчет);
	ВыхПараметры = новый Структура;
	
	Попытка
		Ответ = Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
		Возврат Ложь;
	КонецПопытки;
	
	Если не Ответ Тогда
		Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = "";
			ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
			Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
				 ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
			КонецЦикла;
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка наличие денег в кассе",ТекстОшибки,"","","ОК","");
		КонецЕсли;
	КонецЕсли;
	
КонецФункции

Функция ОтчетСбербанк() Экспорт
	
	Попытка
		ОбъектТерминал = глПараметрыРМ.ПлатежнаяСистема.ПолучитьОбъект();
		Обработка_ПС = Обработка_ПС;
		РезультатИнит = ИнициализацияТО(ОбъектТерминал, Обработка_ПС, глПараметрыРМ);
		ВхПараметры = новый Структура;
		ВыхПараметры = Новый Массив;
		
		Попытка
			Обработка_ПС.ВыполнитьКоманду("ОтчетПоСбербанку",ВхПараметры, ВыхПараметры);
		Исключение
			Сообщить(ОписаниеОшибки());
			Возврат Ложь;
		КонецПопытки;
		
		Строки = ВыхПараметры[0].Строки;
		
		ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
		Обработка_ККМ=Обработка_ККМ;
		ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
		ВхПараметры = новый Структура;
		ВхПараметры.Вставить("Строки",Строки);
		ВыхПараметры = новый Структура;
		Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		Возврат ложь;
	КонецПопытки;
	Возврат Истина;
	
КонецФункции

Функция ЗакрытиеДняСбербанк() Экспорт
	
	Попытка
		ОбъектТерминал = глПараметрыРМ.ПлатежнаяСистема.ПолучитьОбъект();
		Обработка_ПС = Обработка_ПС;
		РезультатИнит = ИнициализацияТО(ОбъектТерминал, Обработка_ПС, глПараметрыРМ);
		ВхПараметры = новый Структура;
		ВыхПараметры = Новый Массив;
		
		Попытка
			Ответ = Обработка_ПС.ВыполнитьКоманду("ИтогиДняПоКартам",ВхПараметры, ВыхПараметры);
		Исключение
			Сообщить(ОписаниеОшибки());
			Возврат Ложь;
		КонецПопытки;
		
		Если не Ответ Тогда
			//Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
				ТекстОшибки = "";
				ОписаниеОшибки = ВыхПараметры;
				Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
					ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
				КонецЦикла;
				ИнтерфейсРМ.ВопросПредупреждение("Ошибка Итоги дня по картам",ТекстОшибки,"","","ОК","");
			//КонецЕсли;
			Возврат Ложь;
		КонецЕсли;
		
		Строки = ВыхПараметры[0].Строки;
		
		// сформируем записи в ext по закрытию смены по банку
		Коннект = sql.ПодключитьсяКloyality_ext();
		Если Коннект = Неопределено Тогда
			ЗарегистрироватьСобытие("Подключение к базе", УровеньЖурналаРегистрации.Ошибка,,,"ошибка подключения к серверу при записи Банковской смены");
		Иначе			
			ТекстЗапроса = "
			|begin
			|Insert into [Loyality_ext].[dbo].[БанковскиеСмены]
			|			(Дата
			|			,ТТ
			|			,[НомерККМ]
			|			,[СлипЗакрытия]
			|			,[Сумма])
			|Values
			|			('&ДатаДок'
			|			,&КодТТ
			|			,&НомерККМ
			|			,'&СлипЗакрытия'
			|			,&Сумма)
			|end";
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ДатаДок",Формат(ТекущаяДата(),"ДФ='yyyyMMdd HH:mm:ss'; ДП='40010101 00:00:00'"));
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&КодТТ",формат(глРабочееМесто.Фирма.КодТТ,"ЧН=0; ЧГ=0"));
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&НомерККМ",Формат(глПараметрыРМ.ККМ.КодСуп,"ЧН=0; ЧГ=0"));
			СуммаИтого = 0;
			ТекстСлип = "";
			ТипБлока = 0;
			Для инд = 0 по Строки.Количество() - 1 Цикл
				СтрокаТекста = Строки[инд];
				СтрокаТекста = СтрЗаменить(СтрокаТекста,"""","""""");
				СтрокаТекста = СтрЗаменить(СтрокаТекста,"'","""""");
				ТекстСлип = ТекстСлип + СтрокаТекста + Символы.ПС;
				Если СтрНайти(ВРег(СтрокаТекста),"ОПЛАТА") <> 0 Тогда
					ТипБлока = 1;
				ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ВОЗВРАТ") <> 0 Тогда
					ТипБлока = -1;
				ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ОТМЕНА") <> 0 Тогда
					ТипБлока = 0;
				КонецЕсли;
				Если СтрНайти(ВРег(СтрокаТекста),"ВСЕГО ОПЕРАЦИЙ:") <> 0 Тогда
					Попытка
						СтрокаТекстаСумма = Строки[инд + 1];
						СуммаОп = Число(СокрЛП(СтрЗаменить(ВРег(СтрокаТекстаСумма),"НА СУММУ:","")));
					Исключение
						СуммаОп = 0;
					КонецПопытки;
					СуммаИтого = СуммаИтого + ТипБлока * СуммаОп;
				КонецЕсли;
			КонецЦикла;
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&СлипЗакрытия",ТекстСлип);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&Сумма",формат(СуммаИтого,"ЧРД=.; ЧН=0; ЧГ=0"));
			
			
			Отказ = Ложь;
			ТекстОшибки = "";
			SQL.ВыполнитьЗапрос(Коннект, ТекстЗапроса, Отказ, ТекстОшибки);
			Если Отказ Тогда 
				ЗарегистрироватьСобытие("Запись закрытия смены по СБ", УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
			КонецЕсли;
			
		КонецЕсли;
		
		//
		
		ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
		Обработка_ККМ=Обработка_ККМ;
		ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
		ВхПараметры = новый Структура;
		ВхПараметры.Вставить("Строки",Строки);
		ВыхПараметры = новый Структура;
		Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Ложь;
	КонецПопытки;
	Возврат Истина;
КонецФункции

Функция СуммаПоБНТекущая(Сумма) Экспорт
	
	Ответ = ЗакрытиеДняСбербанк();
	
	Если не Ответ Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Коннект = sql.ПодключитьсяКloyality_ext();
	Если Коннект = Неопределено Тогда
		ЗарегистрироватьСобытие("Подключение к базе", УровеньЖурналаРегистрации.Ошибка,,,"ошибка подключения к серверу при записи Банковской смены");
		Возврат Ложь;
	Иначе			
		ТекстЗапроса = "
		|Select
		|	СлипЗакрытия
		|	,Сумма
		|From [Loyality_ext].[dbo].[БанковскиеСмены]
		|Where
		|	Дата between '&ДатаНач' and '&ДатаКон'
		|	and ТТ = &КодТТ
		|	and НомерККМ = &НомерККМ
		|Order by дата desc";
		
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ДатаНач",Формат(ТекущаяДата(),"ДФ=yyyyMMdd; ДП=40010101"));
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ДатаКон",Формат(ТекущаяДата() + 86400,"ДФ=yyyyMMdd; ДП=40010101"));
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&КодТТ",формат(глРабочееМесто.Фирма.КодТТ,"ЧН=0; ЧГ=0"));
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&НомерККМ",Формат(глПараметрыРМ.ККМ.КодСуп,"ЧН=0; ЧГ=0"));
		Отказ = Ложь;
		ТекстОшибки = "";
		ТЗСлип = SQL.ВыполнитьЗапросВыборки(Коннект, ТекстЗапроса, Отказ, ТекстОшибки);
		Если Отказ Тогда 
			ЗарегистрироватьСобытие("Запись закрытия смены по СБ", УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
			Возврат Ложь;
		КонецЕсли;
		
		Первый = Истина;
		СуммаИтого = 0;
		Для каждого стр из ТЗСлип Цикл
			Строки = Стр.СлипЗакрытия;
			ТипБлока = 0;
			Для инд = 1 по СтрЧислоСтрок(Строки) Цикл
				СтрокаТекста = СтрПолучитьСтроку(Строки,инд);
				СтрокаТекста = СтрЗаменить(СтрокаТекста,"""","""""");
				СтрокаТекста = СтрЗаменить(СтрокаТекста,"'","""""");
				Если Первый и СтрНайти(ВРег(СтрокаТекста),"ИТОГИ НЕ СОВПАЛИ") <> 0 Тогда
					ТипБлока = 0;
				КонецЕсли;
				//Если Первый и СтрНайти(ВРег(СтрокаТекста),"ИТОГИ СОВПАЛИ") <> 0 Тогда
				//	Возврат Истина;
				//КонецЕсли;
				Если СтрНайти(ВРег(СтрокаТекста),"ОПЛАТА") <> 0 Тогда
					ТипБлока = 1;
				ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ВОЗВРАТ") <> 0 Тогда
					ТипБлока = -1;
				ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ОТМЕНА") <> 0 Тогда
					ТипБлока = 0;
				КонецЕсли;
				Если СтрНайти(ВРег(СтрокаТекста),"ВСЕГО ОПЕРАЦИЙ:") <> 0 Тогда
					Попытка
						СтрокаТекстаСумма = СтрПолучитьСтроку(Строки,инд + 1);
						СуммаОп = Число(СокрЛП(СтрЗаменить(ВРег(СтрокаТекстаСумма),"НА СУММУ:","")));
					Исключение
						СуммаОп = 0;
					КонецПопытки;
					СуммаИтого = СуммаИтого + ТипБлока * СуммаОп;
				КонецЕсли;
			КонецЦикла;
			Первый = ложь;
		КонецЦикла;
		
		Возврат СуммаИтого = Сумма;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции
