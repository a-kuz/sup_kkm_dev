﻿
Процедура ПередЗаписью(Отказ)
	Если Не ЗначениеЗаполнено(ДатаРегистрации) Тогда
		ДатаРегистрации = ТекущаяДата();
	КонецЕсли;    
	Если Не ЗначениеЗаполнено(Автор) Тогда
		Автор = ПараметрыСеанса.ТекущийПользователь;
	КонецЕсли;
		
	Если Не ЭтоНовый() Тогда
		Если флагРезультат - Ссылка.флагРезультат Тогда
			ПроверитьИзмененияСтатусаЗадачиСПодзадачами(Отказ);
			Если Не Родитель.Пустая() Тогда
				ИзменитьСтатусРодительскойЗадачи();	
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если флагРезультат Тогда
		ДатаВыполнения = ТекущаяДата();
	Иначе
		ДатаВыполнения = Дата(1,1,1);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Родитель) Тогда
		Если Не Родитель.РабочееМесто.Пустая() Тогда
			РабочееМесто = Родитель.РабочееМесто;
		КонецЕсли;
	КонецЕсли;
	
	// Запланируем выполнение следующих задач
	
	Если флагРезультат = 1 И ДополнительныеСвойства.Свойство("Авто") Тогда
		
		// проверка, что это последняя задача с такой очередностью
		Запрос = Новый Запрос("
		|ВЫБРАТЬ ПЕРВЫЕ 1
		|	Ссылка
		|ИЗ
		|	Справочник.Задачи КАК Задачи
		|ГДЕ
		|	Задачи.Родитель = &Родитель
		|	И Задачи.Очередность = &Очередность и флагРезультат <> 1 и Ссылка <> &Ссылка
		|");
		Запрос.УстановитьПараметр("Родитель", Родитель);
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.УстановитьПараметр("Очередность", Очередность);
		Рез = Запрос.Выполнить();
		
		Если Рез.Пустой() Тогда
			
			Запрос.Текст = ("
			|ВЫБРАТЬ
			|	Задачи.Родитель КАК Родитель,
			|	Задачи.Ссылка КАК Ссылка,
			|	Задачи.Очередность КАК Очередность,
			|	Задачи.Процедура КАК Процедура,
			|	Задачи.НормативноеВремя КАК НормативноеВремя
			|ПОМЕСТИТЬ тСледующаяЗадача
			|ИЗ
			|	Справочник.Задачи КАК Задачи
			|ГДЕ
			|	Задачи.Родитель = &Родитель
			|	И Задачи.Очередность = &Очередность + 1
			|;		
			|////////////////////////////////////////////////////////////////////////////////
			|ВЫБРАТЬ
			|	тСледующаяЗадача.Ссылка КАК Задача
			|ИЗ
			|	тСледующаяЗадача КАК тСледующаяЗадача
			|ГДЕ
			|	тСледующаяЗадача.Процедура <> ЗНАЧЕНИЕ(Справочник.ирАлгоритмы.ПустаяСсылка)
			|	И тСледующаяЗадача.НормативноеВремя > 0
			|
			|ОБЪЕДИНИТЬ ВСЕ
			|
			|ВЫБРАТЬ
			|	Задачи.Ссылка
			|ИЗ
			|	Справочник.Задачи КАК Задачи
			|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ тСледующаяЗадача КАК тСледующаяЗадача
			|		ПО Задачи.Родитель = тСледующаяЗадача.Ссылка
			|ГДЕ
			|	тСледующаяЗадача.Процедура = ЗНАЧЕНИЕ(Справочник.ирАлгоритмы.ПустаяСсылка)
			|	И Задачи.Очередность = 1
			|	И Задачи.Процедура <> ЗНАЧЕНИЕ(Справочник.ирАлгоритмы.ПустаяСсылка)
			|	И Задачи.НормативноеВремя > 0");
			
			Выб = Запрос.Выполнить().Выбрать();
			Пока Выб.Следующий() Цикл
				
				обЗадача = Выб.Задача.ПолучитьОбъект();//:обЗадача = Справочники.Задачи.СоздатьЭлемент();
				Если обЗадача.ПланируемаяДатаВыполнения = ПланируемаяДатаВыполнения И НачалоДня(ПланируемаяДатаВыполнения) = НачалоДня(ТекущаяДата()) Тогда
					ДатаВремя = ТекущаяДата() + НормативноеВремя;
				Иначе
					ДатаВремя = обЗадача.ПланируемаяДатаВыполнения;
				КонецЕсли;
				обЗадача.ЗапланироватьВыполнение(ДатаВремя);
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
	
	Если флагРезультат = 1 Тогда
		ОписаниеОшибки = "";
		ИдентификаторРегламентногоЗадания = "";
	ИначеЕсли флагРезультат = 0 Тогда
		Результат = "";
		ОписаниеОшибки = "";
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьСтатусРодительскойЗадачи()
	ЕстьСошибками = Ложь;
	ЕстьНеВыполненные = Ложь;
	Выб = Справочники.Задачи.Выбрать(Родитель);
	Пока Выб.Следующий() Цикл
		Если Выб.Ссылка = Ссылка Тогда
			ЕстьСошибками = ЕстьСошибками Или флагРезультат = -1;
			ЕстьНеВыполненные = ЕстьНеВыполненные Или флагРезультат = 0;
		Иначе
			ЕстьСошибками = ЕстьСошибками Или Выб.флагРезультат = -1;
			ЕстьНеВыполненные = ЕстьНеВыполненные Или Выб.флагРезультат = 0;
		КонецЕсли;
	КонецЦикла;
	РодительфлагРезультат = Родитель.флагРезультат;
	
	Если РодительфлагРезультат = -1 И Не ЕстьСошибками Тогда
		НовыйФлагРезультат = 0;
	КонецЕсли;

	Если ЕстьСошибками Тогда
		НовыйФлагРезультат = -1;
	ИначеЕсли ЕстьНеВыполненные Тогда
		НовыйФлагРезультат = 0;
	Иначе
		НовыйФлагРезультат = 1;
	КонецЕсли;
		
	Если РодительфлагРезультат - НовыйФлагРезультат Тогда
		обРодитель = Родитель.ПолучитьОбъект();
		обРодитель.флагРезультат = НовыйФлагРезультат;
		обРодитель.ДополнительныеСвойства.Вставить("Авто", Истина);
		обРодитель.Записать();
	КонецЕсли;
КонецПроцедуры

Процедура ПроверитьИзмененияСтатусаЗадачиСПодзадачами(Отказ)
	
	Если Не ДополнительныеСвойства.Свойство("Авто") Тогда
		Если флагРезультат <> Ссылка.флагРезультат Тогда
			Выб = Справочники.Задачи.Выбрать(Ссылка);
			Если Выб.Следующий() Тогда
				Отказ = Истина;
				Сообщить("Изменение статуса выполнения задач, имеющих подзадачи не разрешено!");			
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ДанныеЗаполнения,,"Код");
	Автор = ПараметрыСеанса.ТекущийПользователь;
	ДатаРегистрации = ТекущаяДата();
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	Автор = ПараметрыСеанса.ТекущийПользователь;
	ДатаРегистрации = ТекущаяДата();
КонецПроцедуры

Функция ЗапланироватьВыполнение(ДатаВремя) Экспорт
	
	Если флагРезультат = 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Расписание = Новый РасписаниеРегламентногоЗадания;
	Расписание.ИнтервалЗавершения = 2000;
	Расписание.ДатаНачала = ДатаВремя;
	Расписание.ВремяНачала = ДатаВремя;		

	Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторРегламентногоЗадания));
	Иначе
		Задание = Неопределено;
	КонецЕсли;
	
	Если Задание = Неопределено Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(Метаданные.РегламентныеЗадания.ВыполнениеПроцедурыПоЗадаче);	
	КонецЕсли;
	
	ИдентификаторРегламентногоЗадания = Задание.УникальныйИдентификатор;
	Записать();
	Задание.Наименование = Наименование;
	Задание.Расписание = Расписание;
	Задание.Использование = Истина;
	Задание.Параметры.Очистить();
	Задание.Параметры.Добавить(Ссылка);
	Задание.Записать();	
КонецФункции

Функция Расписание() Экспорт
	Если ЗначениеЗаполнено(ИдентификаторРегламентногоЗадания) Тогда
		Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Новый УникальныйИдентификатор(ИдентификаторРегламентногоЗадания));
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	Если Задание = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	Возврат Задание.Расписание;
КонецФункции

Функция ЗапланированнаяДата() Экспорт
	Расписание = Расписание();
	Если Расписание = Неопределено Тогда
		Возврат '00010101';
	КонецЕсли;
	//:Расписание = Новый РасписаниеРегламентногоЗадания;
	Возврат УстановитьВремяВДате(Расписание.ДатаНачала, Расписание.ВремяНачала);
КонецФункции
