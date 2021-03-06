﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") Тогда
		МассивЗадач = ПараметрКоманды;
	Иначе
		МассивЗадач = Массив(ПараметрКоманды);
	КонецЕсли;
	УИД = МассивЗадач[0].ИдентификаторРегламентногоЗадания;
	
	ДиалогРасписанияРегламентногоЗадания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание(МассивЗадач[0]));
	Если ДиалогРасписанияРегламентногоЗадания.ОткрытьМодально() Тогда
		Расписание = ДиалогРасписанияРегламентногоЗадания.Расписание;
	Иначе
		Возврат;
	КонецЕсли;
	
	Для Каждого Задача Из МассивЗадач Цикл
		//:Задача = Справочники.Задачи.СоздатьЭлемент();
		обЗадача = Задача.ПолучитьОбъект();
		Если обЗадача.ПроцедураВыполяетсяНаКлиенте Тогда
			Сообщить(СтрШаблон("Задача %1 выполняется на клиенте! Запланировать ее невозможно, т. к. выполнение запланированных заданий происходит на сервере.", обЗадача.Наименование));
			обЗадача.ИдентификаторРегламентногоЗадания = "";
			обЗадача.Записать();
			Продолжить;
		КонецЕсли;
		Если ЗначениеЗаполнено(Задача.ИдентификаторРегламентногоЗадания) Тогда
			Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Задача.ИдентификаторРегламентногоЗадания));
			
		Иначе
			Задание = Неопределено;
		КонецЕсли;
		
		Если Задание = Неопределено Тогда
			Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ВыполнениеПроцедурыПоЗадаче);	
		КонецЕсли;
		
		
		
		обЗадача.ИдентификаторРегламентногоЗадания = Задание.УникальныйИдентификатор;
		обЗадача.Записать();
		Задание.Наименование = Задача;
		Задание.Расписание = Расписание;
		Задание.Использование = Истина;
		Задание.Параметры.Очистить();
		Задание.Параметры.Добавить(Задача);
		Задание.Записать();	
	КонецЦикла;
КонецПроцедуры

Функция Расписание(Задача) Экспорт
	Если ЗначениеЗаполнено(Задача.ИдентификаторРегламентногоЗадания) Тогда
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(Задача.ИдентификаторРегламентногоЗадания));
	Иначе
		Задание = Неопределено;
	КонецЕсли;
	
	Если Задание <> Неопределено Тогда
		Возврат Задание.Расписание;
	Иначе
		//:Задача = Справочники.Задачи.СоздатьЭлемент();
		Расписание = Новый РасписаниеРегламентногоЗадания;
		Расписание.ИнтервалЗавершения = 1800;
		Расписание.ДатаНачала = Задача.ПланируемаяДатаВыполнения;
		Расписание.ВремяНачала = ТекущаяДата();		
		Возврат Расписание
	КонецЕсли;
	
КонецФункции

