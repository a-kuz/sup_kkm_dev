﻿Перем _Тип Экспорт;

Процедура Конструктор(Объект) Экспорт 
	
	ЭтотОбъект.ДополнительныеСвойства = Объект.ДополнительныеСвойства;
	ЭтотОбъект.ОбменДанными = ирОбщий.СтруктураОбменаДаннымиОбъектаЛкс(Объект);
	ЭтотОбъект._Тип = ТипЗнч(Объект);
	ОбъектМД = Объект.Метаданные();
	ПоляТаблицыБД = ирОбщий.ПолучитьПоляТаблицыМДЛкс(ОбъектМД,,,, Ложь);
	Данные = Новый Структура;
	ПоляШапки = Новый Массив;
	Для Каждого СтрокаПоля Из ПоляТаблицыБД Цикл
		Данные.Вставить(СтрокаПоля.Имя);
	КонецЦикла; 
	ЗаполнитьЗначенияСвойств(Данные, Объект); 
	ЭтотОбъект.Данные = Данные;
	
КонецПроцедуры

Функция Снимок() Экспорт 
	
	СтруктураОбъекта = Новый Структура;
	СтруктураОбъекта.Вставить("ОбменДанными", ОбменДанными);
	СтруктураОбъекта.Вставить("ДополнительныеСвойства", ДополнительныеСвойства);
	СтруктураОбъекта.Вставить("Данные", Данные);
	СтруктураОбъекта.Вставить("_Тип", _Тип);
	ЗаписьJSON = Новый ЗаписьJSON;
	ЗаписьJSON.УстановитьСтроку();
	СериализаторXDTO.ЗаписатьJSON(ЗаписьJSON, СтруктураОбъекта, НазначениеТипаXML.Явное);
	Результат = ЗаписьJSON.Закрыть();
	Возврат Результат;
	
КонецФункции

Процедура ЗагрузитьСнимок(Снимок) Экспорт 
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(Снимок);
	СтруктураОбъекта = СериализаторXDTO.ПрочитатьJSON(ЧтениеJSON);
	ЧтениеJSON.Закрыть();
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, СтруктураОбъекта); 
	
КонецПроцедуры

Функция КлючОбъекта()
	
	Результат = Неопределено;
	Возврат Результат;
	
КонецФункции

Функция ОбъектБД() Экспорт 
	
	КлючОбъекта = КлючОбъекта();
	Результат = ирОбщий.ОбъектБДПоКлючуЛкс(Метаданные.НайтиПоТипу(_Тип).ПолноеИмя(), КлючОбъекта,, Ложь).Данные;
	ирОбщий.СкопироватьУниверсальнуюКоллекциюЛкс(ДополнительныеСвойства, Результат.ДополнительныеСвойства);
	ирОбщий.ВосстановитьСтруктуруОбменаДаннымиОбъектаЛкс(Результат, ОбменДанными);
	ЗаполнитьЗначенияСвойств(Результат, Данные); 
	Возврат Результат;
	
КонецФункции

Процедура Прочитать(НаСервере = Истина) Экспорт 
	
	Если НаСервере Тогда
		Снимок = Снимок();
		ирСервер.ПрочитатьОбъектЧерезИмитаторЛкс(Снимок, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок);
	Иначе
		ОбъектБД = ОбъектБД();
		ОбъектБД.Прочитать();
		Конструктор(ОбъектБД);
	КонецЕсли; 
	
КонецПроцедуры

Функция Записать() Экспорт
	
	#Если Не Сервер Тогда
		Снимок = Снимок();
		ирСервер.ЗаписатьОбъектXMLЛкс(Снимок,,,,,, ТипЗнч(ЭтотОбъект));
		ЗагрузитьСнимок(Снимок);
	#Иначе
		ОбъектБД = ОбъектБД();
		ОбъектБД.Записать();
		Конструктор(ОбъектБД);
	#КонецЕсли 
	
КонецФункции

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ОбъектБД = ОбъектБД();
	Отказ = Не ОбъектБД.ПроверитьЗаполнение();
	Конструктор(ОбъектБД);
	
КонецПроцедуры
