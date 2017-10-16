﻿
&НаСервере
Процедура КомандаCALCНаСервере()
	РезультатJSON = ЛояльностьКлиентСервер.СформироватьJSON_Новый(Лояльность.ПредварительныйРасчетЗаказаПоСсылке(Заказ, Истина));
КонецПроцедуры

&НаКлиенте
Процедура КомандаCALC(Команда)
	КомандаCALCНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаACTIONSНаСервере()
	Лояльность.ОбновитьАкцииГостяПоЗаказу(Заказ);
	РезультатJSON = ЛояльностьКлиентСервер.СформироватьJSON_Новый(Лояльность.ПолучитьДанныеЛояльностиПоЗаказу(Заказ, "ACTIONS"));
КонецПроцедуры

&НаКлиенте
Процедура КомандаACTIONS(Команда)
	КомандаACTIONSНаСервере();
КонецПроцедуры

&НаСервере
Процедура КомандаПривязатьКартуНаСервере()
	Данные = Новый Структура;
	Данные.Вставить("err", 0);
	Данные.Вставить("err_msg");
	Данные.Вставить("request", "REG");
	Данные.Вставить("guest", Новый Структура);
	ДанныеГостя = Данные.guest;
	ДанныеГостя.Вставить("guest_number", КартаДоступа.Идентификатор);
	ДанныеГостя.Вставить("card_number", НомерКарты);
	
	Лояльность.ОбработатьЗапрос_edit(ЛояльностьКлиентСервер.СформироватьJSON_Новый(Данные));
КонецПроцедуры

&НаКлиенте
Процедура КомандаПривязатьКарту(Команда)
	КомандаПривязатьКартуНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура КомандаРассчитатьЦенники(Команда)
	Ценники_ОтветJSON = ВыполнитьКомандуИзСупТТ(Ценники_ЗапросJSON);
КонецПроцедуры

&НаКлиенте
Процедура КомандаВключитьРежимОффлайн(Команда)
	ИзменитьРежимОффлайн(Истина);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРежимОффлайн(Включен)
	Запрос = Новый Структура("Команда, Оффлайн", "ЛояльностьРежимОффлайн", ?(Включен,1,0));
	Ответ = ЛояльностьКлиентСервер.РазборJSON(ВыполнитьКомандуИзСупТТ(ЛояльностьКлиентСервер.СформироватьJSON_Новый(Запрос)));
	ТекстСообщения = "";
	Если Ответ.Результат <> 1 Тогда
		ТекстСообщения = Ответ.ОписаниеОшибки;		
	Иначе
		Если Ответ.Оффлайн = 1 Тогда
			ТекстСообщения = "Режим оффлайн установлен";
		Иначе
			ТекстСообщения = "Режим оффлайн снят";
		КонецЕсли;
	КонецЕсли;
	СообщениеПользователю = Новый СообщениеПользователю;
	СообщениеПользователю.Текст = ТекстСообщения;
	СообщениеПользователю.Сообщить();	
КонецПроцедуры

&НаКлиенте
Процедура КомандаВыключитьРежимОффлайн(Команда)
	ИзменитьРежимОффлайн(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КомандаCHECK_INFO(Команда)
	СервисCheck_ОтветJSON = Лояльность.ОбработатьЗапрос_info(СервисCheck_ЗапросJSON);
КонецПроцедуры

&НаКлиенте
Процедура КомандаCHECK_GET(Команда)
	СервисCheck_ОтветJSON = Лояльность.ОбработатьЗапрос_get(СервисCheck_ЗапросJSON);
КонецПроцедуры

&НаКлиенте
Процедура КомандаCHECK_EDIT(Команда)
	СервисCheck_ОтветJSON = Лояльность.ОбработатьЗапрос_edit(СервисCheck_ЗапросJSON);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Установка параметра динамического списка
	СписокОтбора = Новый Массив();
	СписокОтбора.Добавить(Неопределено);
	СписокОтбора.Добавить(Справочники.ИнформационныеБазы.ПустаяСсылка());
	СписокОтбора.Добавить(ПараметрыСеанса.ТекущаяИБ);	
	ДополнительныеСвойства.Параметры.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("ИнформационнаяБаза"), СписокОтбора);
	ДополнительныеСвойства.Параметры.УстановитьЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Свойство"), "Лояльность_");
		
КонецПроцедуры


&НаСервере
Процедура КомандаСброситьКэшНаСервере()
	ОбновитьПовторноИспользуемыеЗначения();
КонецПроцедуры


&НаКлиенте
Процедура КомандаСброситьКэш(Команда)
	ОбновитьПовторноИспользуемыеЗначения();
	КомандаСброситьКэшНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура КомандаPRESALE(Команда)
	Тест = Ложь;
	ПараметрыЗапроса = ЛояльностьКлиентСервер.СформироватьJSONПоЗаказу_Протокол2("SALE", Заказ, 0, Неопределено,,Тест);
	Если ПараметрыЗапроса.Ошибка Тогда
		//ЛояльностьКлиентСервер.Логирование(1, "расчет", "ошибка формирования JSON("+ПараметрыЗапроса.ТекстОшибки+")");
		РезультатJSON = ПараметрыЗапроса.ТекстОшибки;
		Возврат;
	КонецЕсли;
	
	ОтправкаУспешна = Ложь;
	
	Попытка
		//ЛояльностьКлиентСервер.Логирование(1, "расчет", "отправка запроса (Режим="+?(РежимОтправки=0,"центр","локальный")+",текст="+ПараметрыЗапроса.ТекстЗапроса+")");
		//ОтветСервера = Лояльность.ОтправитьЧекНаОбработку_Протокол2(ПараметрыЗапроса.ТекстЗапроса, РежимОтправки, Тест);
		ОтветСервера = Лояльность.ОтправитьЗапросКСервисуРасчетаЧеков_Протокол2(ПараметрыЗапроса.ТекстЗапроса, "CALC", Тест);
		РезультатJSON = ОтветСервера.Ответ;
	Исключение
	КонецПопытки;
КонецПроцедуры

