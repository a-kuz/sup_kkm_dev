﻿#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция Инициализация() Экспорт
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = "
	|IF OBJECT_ID('ЖурналРегистрации') IS NULL BEGIN
	|	CREATE TABLE ЖурналРегистрации (
	|	
	|	 Ид int IDENTITY PRIMARY KEY
	|	 ,Дата datetime NOT NULL DEFAULT ((GETDATE()))
	|	 ,Пользователь VARCHAR(25) NULL
	|	 ,Компьютер VARCHAR(25) NULL
	|	 ,Уровень VARCHAR(15) NOT NULL
	|	 ,Событие VARCHAR(220) NOT NULL
	|	 ,Комментарий VARCHAR(max) NULL
	|	 ,Данные_Ссылка BINARY(16) NULL
	|	 ,Данные_ТипСсылки VARCHAR(500) NULL
	|	 ,Данные_Представление VARCHAR(200) NULL
	|	) 
	|
	|	CREATE INDEX IX_Дата ON ЖурналРегистрации (Дата)
	|
	|	CREATE INDEX IX_Данные_Ссылка ON ЖурналРегистрации (Данные_Ссылка)  INCLUDE (
	|	 Дата
	|	 ,Пользователь 
	|	 ,Компьютер 
	|	 ,Уровень 
	|	 ,Событие 
	|	 ,Комментарий 
	|	 ,Данные_ТипСсылки 
	|	 ,Данные_Представление
	|	)
	|
	|	CREATE INDEX IX_Событие ON ЖурналРегистрации (Событие)
	|
	|END";
	
	Отказ = Ложь; ТексОшибки = "";
	SQL.ВыполнитьЗапрос(ЖурналРегистрации.Коннект(ТекущаяУниверсальнаяДатаВМиллисекундах()/(1000*600)),ТекстЗапроса,Отказ,ТексОшибки);
	Если Отказ Тогда
		ЗаписьЖурналаРегистрации("ЖР.Ошибка", УровеньЖурналаРегистрации.Ошибка, ,,ТексОшибки + Символы.ПС + ТекстЗапроса);
		Возврат Ложь;
	Иначе
		Попытка
			Возврат УстановитьНастройкиВнешнегоИсточникаДанных();	
		Исключение
			Возврат Ложь;
		КонецПопытки;
		
	КонецЕсли;
КонецФункции
#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция Коннект(ПризнакДляСбросаКэша=0) Экспорт
	Возврат SQL.ПодключитьсяКsup_kkm(ПараметрыСеанса.ТекущаяИБ);	
КонецФункции

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция Используется() Экспорт
	Возврат ПараметрыСеанса.ЖурналРегистрацииВsql;
КонецФункции

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция Компьютер() Экспорт
	Возврат ПолучитьТекущийСеансИнформационнойБазы().ИмяКомпьютера;
КонецФункции

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция Экранировать(Знач Стр) Экспорт
	Стр = СтрЗаменить(Стр, "'", "''"); 
	Возврат Стр;
КонецФункции

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция ПреобразоватьДанные(Данные, пМетаданные = "") Экспорт
	Если пМетаданные = "" Тогда
		Возврат "0x0";
	КонецЕсли;
	
	//:Данные = Документы.Заказ.ПустаяСсылка();
	
	Попытка
		УИД = Строка(Данные.УникальныйИдентификатор());	
	Исключение
		Возврат Null;
	КонецПопытки;
	
	Возврат "0x"+ирОбщий.ПолучитьГУИДИнверсныйИзПрямогоЛкс(УИД);
		
КонецФункции

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция ПредставлениеТипа(Тип) Экспорт
	Возврат ирОбщий.ПолучитьПолноеИмяМДТипаЛкс(Тип);
КонецФункции

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция Пользователь() Экспорт
	Возврат ИмяПользователя();
КонецФункции

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция УстановитьНастройкиВнешнегоИсточникаДанных() Экспорт
	ИнформационнаяБаза = ПараметрыСеанса.ТекущаяИБ;		
	
	ИмяПользователя = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "ИмяПользователяSQL");
	Пароль 			= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "ПарольSQL");
	Сервер 			= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "СерверSQL");	
	База			= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "БазаSQL");
	Если Сервер = Неопределено Тогда
		Сервер 	= ИнформационнаяБаза.СерверIp;
		Если СтрНайти(НРег(ИнформационнаяБаза.СерверХост), "serv") Тогда
			Сервер = Сервер + "\sqlexpress";
		КонецЕсли;
	КонецЕсли;
    Если База = Неопределено Тогда
		База = "sup_kkm";
	КонецЕсли;
	
	Если ИмяПользователя = Неопределено Тогда
		ИмяПользователя = "sa";
	КонецЕсли;
	
	Если Пароль = Неопределено Тогда
		Пароль = "ser09l";
	КонецЕсли;

	
	СтрокаСоединения =  "Provider=SQLOLEDB;DRIVER={SQL Server Native Client 11.0}" + 
						";Data Source=" + Сервер +
						";DATABASE=" + База +
						";Initial catalog=" + База +
						";Server=" + Сервер ;
							
	
	ЖР = ВнешниеИсточникиДанных.СУП_ККМ;
	Параметры = ЖР.ПолучитьОбщиеПараметрыСоединения();
	Параметры.ИмяПользователя = ИмяПользователя;
	Параметры.Пароль = Пароль;
	//Параметры.СУБД = "MSSQLServer";
	Параметры.АутентификацияОС = Ложь;
	Параметры.АутентификацияСтандартная = Истина;
	Параметры.СтрокаСоединения = СтрокаСоединения;
	
	ЖР.УстановитьОбщиеПараметрыСоединения(Параметры);	
	//ЖР.УстановитьПараметрыСоединенияПользователя(ПользователиИнформационнойБазы.ТекущийПользователь().Имя, Параметры);	
	ЖР.УстановитьПараметрыСоединенияСеанса(Параметры);	
	ЖР.УстановитьСоединение();
	
	
	Если ЖР.ПолучитьСостояние() = СостояниеВнешнегоИсточникаДанных.Подключен Тогда
		З = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЖурналРегистрации.Ид КАК Ид,
		|	ЖурналРегистрации.Дата КАК Дата,
		|	ЖурналРегистрации.Пользователь КАК Пользователь,
		|	ЖурналРегистрации.Компьютер КАК Компьютер,
		|	ЖурналРегистрации.Уровень КАК Уровень,
		|	ЖурналРегистрации.Событие КАК Событие,
		|	ЖурналРегистрации.Комментарий КАК Комментарий,
		|	ЖурналРегистрации.Данные_Ссылка КАК Данные_Ссылка,
		|	ЖурналРегистрации.Данные_ТипСсылки КАК Данные_ТипСсылки,
		|	ЖурналРегистрации.Данные_Представление КАК Данные_Представление
		|ИЗ
		|	ВнешнийИсточникДанных.СУП_ККМ.Таблица.ЖурналРегистрации КАК ЖурналРегистрации");
		Попытка
			З.Выполнить();
			Возврат Истина;
		Исключение
			Возврат Ложь;
		КонецПопытки;
	Иначе
		Возврат Ложь;
	КонецЕсли; 
КонецФункции


#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Процедура ЗагрузитьЖРвЖР(Записей = 10000) Экспорт
	
	ТЗ = Новый ТаблицаЗначений;
	Отбор = Новый Структура();
	
	Сообщить("" + ТекущаяДата() + " - выгрузка записей из штатного ЖР" );
	ВыгрузитьЖурналРегистрации(ТЗ, Отбор, "Уровень,Дата,ИмяПользователя ,Компьютер,ПредставлениеСобытия,Комментарий,Данные,ПредставлениеПриложения,ПредставлениеДанных,Метаданные",,Записей);
	Сообщить("" + ТекущаяДата() + " - запись в sql жр" );
	Если ТЗ.Количество() Тогда
		НачДата = ТЗ[0].Дата;
		Для каждого Т Из ТЗ Цикл
			Если ТЗ.Индекс(Т)%2000 = 0 Тогда
				Сообщить("" + ТекущаяДата() + " - запись в sql жр " + тз.Индекс(Т) + " / " + тз.Количество());
			КонецЕсли;
			ЗаписатьСобытие(Т.ПредставлениеСобытия, Т.уровень,Т.комментарий, Т.Данные, Т.Компьютер, Т.имяПользователя, Т.ПредставлениеДанных,Т.дата,т.Метаданные);	
		КонецЦикла;
		КонДата = Т.Дата;
		
		ПутьЖР = ПолучитьИмяВременногоФайла("lgd");
		СкопироватьЖурналРегистрации(,ПутьЖР, Новый Структура("ДатаНачала, ДатаОкончания", НачДата, конДата));
		Сообщить("" +ТекущаяДата() + " - очистка штатного жр от выгруженных записей" );
		ОчиститьЖурналРегистрации(новый Структура("ДатаНачала, ДатаОкончания", НачДата, конДата));
	КонецЕсли;

	Сообщить(СтрШаблон("Загружено %1 записей с %2 по %3", ТЗ.Количество(), НачДата, КонДата),СтатусСообщения.Информация);
КонецПроцедуры
