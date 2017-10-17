﻿
Процедура ПриходУходОтменаНажатие(Элемент)
	глОтсечкаПростоя();
	Закрыть(Ложь);
КонецПроцедуры

Процедура ПриходУходРегистрацияНажатие(Элемент)
	глОтсечкаПростоя();
	Если ТабличноеПоле1.Количество() <> 0 Тогда
		Движение = РегистрыСведений.ФактическийУчетРабочегоВремени.СоздатьМенеджерЗаписи();
		ВремяДляЗаписи = ?(ТипФормы = "Приход",ТабличноеПоле1[0].ВремяПрихода,ТабличноеПоле1[0].ВремяУхода);
		Движение.Период = Дата(Год(ТекущаяДата()),Месяц(ТекущаяДата()),День(ТекущаяДата()),Час(ВремяДляЗаписи),Минута(ВремяДляЗаписи),Секунда(ВремяДляЗаписи));
		Движение.Сотрудник = Сотрудник;
		Движение.МестоРеализации = глПараметрыРМ.МестоРеализации;
		Движение.НаРаботе = ТипФормы = "Приход";
		Движение.Записать();
	КонецЕсли;
	Закрыть(Истина);
КонецПроцедуры



Процедура ПриОткрытии()
	Заголовок = "Регистрация " + ?(ТипФормы = "Приход","прихода на работу","ухода с работы");
	ЭлементыФормы.ТабличноеПоле1.Колонки.ВремяУхода.Видимость = ТипФормы = "Уход";
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
	ЗаполнитьПУ();
	
КонецПроцедуры


Процедура ПриЗакрытии()
	ИнтерфейсРМ.ПриЗакрытииОкна();
КонецПроцедуры


Процедура ЗаполнитьПУ()
	
	РезПроверки = ПроверитьНаРаботе();
	Если РезПроверки = Неопределено Тогда // не на работе
		СтрТабл = ТабличноеПоле1.Добавить();
		СтрТабл.Сотрудник = Сотрудник.ФИО;
		СтрТабл.ВремяПрихода = ТекущаяДата();
	Иначе
		СтрТабл = ТабличноеПоле1.Добавить();
		СтрТабл.Сотрудник = Сотрудник.ФИО;
		СтрТабл.ВремяПрихода = РезПроверки;
		СтрТабл.ВремяУхода = ?(ТипФормы = "Уход",ТекущаяДата(),Дата(1,1,1));
	КонецЕсли;
		
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если ТипФормы = "Приход" Тогда
		Ответ = ИнтерфейсРМ.ВопросПредупреждение("Вопрос","Начало рабочей смены сотрудника","Зарегистрировать начало рабочей смены сотрудника?","Да","","Esc=Нет");
		Если Ответ <> "Да" ТОгда
			Отказ = истина;//Закрыть(Ложь);
		КонецЕсли;
		Если Не Отказ Тогда
			КодДоступа = ИнтерфейсРМ.Авторизация("ВВЕДИТЕ КОД ЕЩЕ РАЗ", "Пароль",4,,,,"Сотрудник",Истина);
			Если не ЗначениеЗаполнено(КодДоступа) Тогда
				Отказ = истина;//Закрыть(Ложь);
			КонецЕсли;
			Если СокрЛП(КодДоступа) <> СокрЛП(Сотрудник.КодДоступа) тогда
				Отказ = истина;//Закрыть(Ложь);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры




ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);