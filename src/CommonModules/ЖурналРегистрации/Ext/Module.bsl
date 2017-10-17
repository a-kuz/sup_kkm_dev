﻿Функция Инициализация() Экспорт
	ТекстЗапроса = "
	|IF OBJECT_ID('ЖурналРегистрации') IS NULL BEGIN
	|	CREATE TABLE ЖурналРегистрации (
	|	
	|	 Ид int IDENTITY PRIMARY KEY
	|	 ,Дата datetime NOT NULL DEFAULT ((GETDATE()))
	|	 ,Пользователь VARCHAR(25) NULL
	|	 ,Компьютер VARCHAR(25) NULL
	|	 ,Уровень VARCHAR(15) NOT NULL
	|	 ,Событие VARCHAR(120) NOT NULL
	|	 ,Комментарий VARCHAR(max) NULL
	|	 ,Данные_Ссылка BINARY(16) NULL
	|	 ,Данные_ТипСсылки VARCHAR(50) NULL
	|	 ,Данные_Представление VARCHAR(100) NULL
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
	SQL.ВыполнитьЗапрос(ЖурналРегистрации.Коннект(),ТекстЗапроса,Отказ,ТексОшибки);
	Если Отказ Тогда
		ЗаписьЖурналаРегистрации("ЖР.Ошибка", УровеньЖурналаРегистрации.Ошибка, ,,ТексОшибки + Символы.ПС + ТекстЗапроса);
		Возврат Ложь;
	Иначе
		Возврат УстановитьНастройкиВнешнегоИсточникаДанных();
	КонецЕсли;
КонецФункции

Функция Коннект() Экспорт
	Возврат SQL.ПодключитьсяКsup_kkm(ПараметрыСеанса.ТекущаяИБ);	
КонецФункции

Функция ЗаписатьСобытие(Событие = "", Уровень = "Информация", Комментарий = "",Знач Данные = Неопределено) Экспорт
	ТекстЗапроса = СтрШаблон("INSERT INTO dbo.ЖурналРегистрации
	|(
	|  Дата
	| ,Пользователь
	| ,Компьютер
	| ,Уровень
	| ,Событие
	| ,Комментарий
	| ,Данные_Ссылка
	| ,Данные_ТипСсылки
	| ,Данные_Представление
	|)
	|VALUES
	|(
	|  GETDATE()
	| ,'%1' -- Пользователь - varchar(25)
	| ,'%2' -- Компьютер - varchar(25)
	| ,'%3' -- Уровень - varchar(15)
	| ,'%4' -- Событие - varchar(20)
	| ,'%5' -- Комментарий - varchar(max)
	| , %6 -- Данные_Ссылка - binary(16)
	| ,'%7' -- Данные_ТипСсылки - varchar(50)
	| ,'%8' -- Данные_Представление - varchar(100)
	|)",
	  ЖурналРегистрации.Пользователь()
	, ЖурналРегистрации.Компьютер()
	, Уровень
	, Событие
	, Комментарий
	, ПреобразоватьДанные(Данные)
	, Строка(ТипЗнч(Данные))
	, Строка(Данные)
	);
	SQL.ВыполнитьЗапросАсинхронно(ЖурналРегистрации.Коннект(), ТекстЗапроса);		
КонецФункции

Функция Компьютер() Экспорт
	Возврат ИмяКомпьютера();
КонецФункции

Функция ПреобразоватьДанные(Данные) Экспорт
	Если Данные = Неопределено Тогда
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

Функция Пользователь() Экспорт
	Возврат ИмяПользователя();
КонецФункции

Функция УстановитьНастройкиВнешнегоИсточникаДанных() Экспорт
	ИнформационнаяБаза = ПараметрыСеанса.ТекущаяИБ;		
	
	ИмяПользователя = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "ИмяПользователяSQL");
	Пароль 			= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "ПарольSQL");
	Сервер 			= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "СерверSQL");	
	База			= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "БазаSQL");
	Если Сервер = Неопределено Тогда
		Сервер 	= ИнформационнаяБаза.СерверIp;
	КонецЕсли;
    Если База = Неопределено Тогда
		База = "sup_kkm";
	КонецЕсли;
	
	Если ИмяПользователя = Неопределено Тогда
		ИмяПользователя = "sa";
	КонецЕсли;
	
	Если Пароль = Неопределено Тогда
		ИмяПользователя = "ser09l";
	КонецЕсли;

	
	СтрокаСоединения =  "Provider=SQLOLEDB;DRIVER={SQL Server Native Client 11.0}" + 
						";Data Source=" + Сервер +
						";DATABASE=" + База +
						";Initial catalog=" + База +
						";Server=" + Сервер ;
							
	
	ЖР = ВнешниеИсточникиДанных.ЖурналРегистрации;
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
		|	ВнешнийИсточникДанных.ЖурналРегистрации.Таблица.ЖурналРегистрации КАК ЖурналРегистрации");
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