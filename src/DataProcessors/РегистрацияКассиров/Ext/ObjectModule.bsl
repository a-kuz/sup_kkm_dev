﻿
Функция ПроверитьНаРаботе() Экспорт
	глПараметрыРМ = глПараметрыРМ;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ФактическийУчетРабочегоВремениСрезПоследних.Период,
	               |	ФактическийУчетРабочегоВремениСрезПоследних.НаРаботе
	               |ИЗ
	               |	РегистрСведений.ФактическийУчетРабочегоВремени.СрезПоследних(
	               |			&Период,
	               |			Сотрудник = &Сотрудник
	               |				И МестоРеализации = &МестоРеализации
	               |				) КАК ФактическийУчетРабочегоВремениСрезПоследних
	               |ГДЕ
	               |	ФактическийУчетРабочегоВремениСрезПоследних.Период МЕЖДУ НАЧАЛОПЕРИОДА(&Период, ДЕНЬ) И КОНЕЦПЕРИОДА(&Период, ДЕНЬ)";
	Запрос.УстановитьПараметр("Период",ТекущаяДата());
	Запрос.УстановитьПараметр("Сотрудник",Сотрудник);
	Запрос.УстановитьПараметр("МестоРеализации",глПараметрыРМ.МестоРеализации);
	Запрос.УстановитьПараметр("параметр",истина);
	Результат = Неопределено;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.НаРаботе Тогда
			Результат = Выборка.Период;
		КонецЕсли;
	КонецЦикла;
	Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		Возврат Истина;
	Иначе
		Возврат Результат;
	КонецЕсли;
КонецФункции
