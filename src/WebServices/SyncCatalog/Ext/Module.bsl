﻿
Функция Nomenclature(пКлюч, пДанные, ОписаниеОшибки)
	Попытка
		Данные = ЗначениеИзСтрокиВнутр(пДанные);
		УИД = Новый УникальныйИдентификатор(пКлюч);
		Ссылка = Справочники.Номенклатура.ПолучитьСсылку(УИД);
		Если Ссылка.ПолучитьОбъект()=Неопределено Тогда                  
			Если Данные.ЭтоГруппа Тогда
				ОбъектНоменклатура = Справочники.Номенклатура.СоздатьГруппу();	
			Иначе
				ОбъектНоменклатура = Справочники.Номенклатура.СоздатьЭлемент();
			КонецЕсли;
			ОбъектНоменклатура.УстановитьСсылкуНового(Ссылка);
		Иначе
			ОбъектНоменклатура = Ссылка.ПолучитьОбъект();
		КонецЕсли;
		ОбъектНоменклатура.Родитель = Справочники.Номенклатура.ПолучитьСсылку(Новый УникальныйИдентификатор(Данные.Родитель));
		
		фСигареты = Неопределено;
		Если Данные.ЭтоГруппа Тогда
			ЗаполнитьЗначенияСвойств(ОбъектНоменклатура, Данные, , "ЭтоГруппа, Родитель");
		Иначе
			Если Данные.Свойство("фСигареты", фСигареты) Тогда
				//:Данные=Новый Структура;
				Данные.Удалить("фСигареты");
			КонецЕсли;
			
			
			ЗаполнитьЗначенияСвойств(ОбъектНоменклатура, Данные, , "ЭтоГруппа, Родитель");
			
			Если Данные.фАлкоголь Тогда
				ОбъектНоменклатура.ГруппаКонтроляПродажи = Справочники.ГруппыКонтроляПродажи.Алкоголь;
			ИначеЕсли Не фСигареты = Неопределено И фСигареты = 1 Тогда
				ОбъектНоменклатура.ГруппаКонтроляПродажи = Справочники.ГруппыКонтроляПродажи.Сигареты;
			Иначе
				ОбъектНоменклатура.ГруппаКонтроляПродажи = Справочники.ГруппыКонтроляПродажи.НетКонтроля;
			КонецЕсли;
		КонецЕсли;
		ОбъектНоменклатура.Код = "ХД"+Формат(Данные.Код, "ЧЦ=9; ЧВН=; ЧГ=0");
		
		
		Узлы = Справочники.ГруппыИнформационныхБаз.УзлыПоГруппе(Справочники.ГруппыИнформационныхБаз.Рестораны);
		Для Каждого Ресторан Из Узлы Цикл
			ОбъектНоменклатура.ОбменДанными.Получатели.Добавить(Ресторан);
		КонецЦикла;
		ОбъектНоменклатура.Записать();
		Возврат Истина;
	Исключение
		ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации("Ошибка вэбсервиса.",,,,ОписаниеОшибки);
		Возврат Ложь;
	КонецПопытки;
	
КонецФункции
