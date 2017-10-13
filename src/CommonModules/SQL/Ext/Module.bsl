#Если НЕ ТонкийКлиент Тогда

Функция Подключиться(ServerName, UID="sa", PWD="ser09l", DB = Неопределено) Экспорт
	Если Не ЗначениеЗаполнено(UID) Тогда
		UID = "sa";
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(PWD) Тогда
		PWD = "ser09l";
	КонецЕсли;

	КлючПодключения = "" + ServerName + ?(DB = Неопределено, "", DB);         
	SQLConnection = Неопределено;
	глСоединения = глСоединения;
	Если Не ЗначениеЗаполнено(глСоединения) Тогда
		глСоединения = Новый Соответствие;
	КонецЕсли;
	SQLConnection = глСоединения.Получить(КлючПодключения);
	
	Если Не SQLConnection = Неопределено Тогда
		Попытка
			SQLConnection.Execute("Select 1"); // такой тест
		Исключение
			SQLConnection = Неопределено;
		КонецПопытки;
	КонецЕсли;
	
	Если Не SQLConnection = Неопределено Тогда
		Возврат SQLConnection;
	КонецЕсли;
		
	SQLConnection = Новый COMОбъект("ADODB.Connection");
    
    ConnectString = "Provider=SQLOLEDB;DRIVER={SQL Server Native Client 11.0};" + 
	                "Data Source=" + ServerName +
	                ";UID=" + UID + ";PWD=" + PWD;
	Если DB <> Неопределено Тогда
		ConnectString = ConnectString + "; Initial Catalog=" + DB;						
	КонецЕсли;  	
							
    SQLConnection.ConnectionString = ConnectString;
    SQLConnection.ConnectionTimeOut = 5;
    SQLConnection.CommandTimeout = 30;
	
    Попытка
        SQLConnection.Open();        
    Исключение
		ТекстСообщения = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		ЗаписьЖурналаРегистрации("Подключение к базе", УровеньЖурналаРегистрации.Ошибка,,,ТекстСообщения + Символы.ПС + "ConnectString = " + ConnectString);
        
        SQLConnection = Неопределено;
    КонецПопытки;
	глСоединения.Вставить(КлючПодключения, SQLConnection);
	Возврат SQLConnection;
КонецФункции

Функция ПодключитьсяКloyality_ext() Экспорт 
	ТекИБ = ПараметрыСеанса.ТекущаяИБ;
	
	ServerName 	= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ТекИБ, "Лояльность_СерверSQL");
	UID 		= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ТекИБ, "Лояльность_ИмяПользователяSQL");
	PWD 		= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ТекИБ, "Лояльность_ПарольSQL");
	
	Если ServerName = Неопределено Тогда
		ОшибкаТекст = "Не определено значение свойства Лояльность_СерверSQL для ИБ (" + ТекИБ + ")";
		
		#Если Клиент Тогда
			Предупреждение(ОшибкаТекст);
		#КонецЕсли
		
		ЗаписьЖурналаРегистрации("Подключение к базе", УровеньЖурналаРегистрации.Ошибка,,,ОшибкаТекст);
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Подключиться(ServerName, UID, PWD);
КонецФункции

Функция ПодключитьсяКegais() Экспорт 
	ТекИБ = ПараметрыСеанса.ТекущаяИБ;
	
	ServerName 	= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ТекИБ, "Excise_Server");
	UID 		= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ТекИБ, "Excise_User");
	PWD 		= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ТекИБ, "Excise_Pwd");
	DB 			= "Egais";
	
	Если ServerName = Неопределено Тогда
		ОшибкаТекст = "Не определено значение свойства Excise_Server для основой ИБ (" + ТекИБ + ")";
		
		#Если Клиент Тогда
			Предупреждение(ОшибкаТекст);
		#КонецЕсли
		
		ЗаписьЖурналаРегистрации("Подключение к базе", УровеньЖурналаРегистрации.Ошибка,,,ОшибкаТекст);
		Возврат Неопределено;
	КонецЕсли;
		
	Возврат Подключиться(ServerName, UID, PWD, DB);
КонецФункции

Функция ПодключитьсяКСУПцентр(Регион, DB = "Raz_ref") Экспорт
	
	ServerName 	= ?(Регион = Справочники.Регионы.Р77, "tdrm77", "black_hawk");
			
	Возврат Подключиться(ServerName, "", "", DB);
КонецФункции

Процедура ВыполнитьЗапрос(Подключение, ТекстЗапроса, Отказ=Ложь, ТекстОшибки="") Экспорт
	
	РезультатЗапроса = Новый COMОбъект("ADODB.Recordset");
	
	Попытка
		РезультатЗапроса.Open(ТекстЗапроса, Подключение);
	Исключение
		Отказ = Истина;
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;
	
	РезультатЗапроса = Неопределено;
КонецПроцедуры

Функция ВыполнитьЗапросАсинхронно(Подключение, ТекстЗапроса, Отказ=Ложь, ТекстОшибки="") Экспорт
	
	adAsyncExecute = 16; adExecuteNoRecords = 128;
	Options = adAsyncExecute + adExecuteNoRecords;// 16 + 128
	
	Если Подключение.State <> 1 Тогда
		локПодключение =  Новый COMОбъект("ADODB.Connection");
	    локПодключение.ConnectionString = Подключение.ConnectString;
		локПодключение.Open();
		локПодключение.Execute(ТекстЗапроса,,128);
		локПодключение.Close();
	Иначе
		Подключение.Execute(ТекстЗапроса, , Options);
	КонецЕсли;

КонецФункции

Функция ВыполнитьЗапросВыборки(Подключение, ТекстЗапроса, Отказ=Ложь, ТекстОшибки="", Таймаут = 30) Экспорт
	
	РезультатЗапроса = Новый COMОбъект("ADODB.Recordset");
	
	Попытка
		РезультатЗапроса.Open(ТекстЗапроса, Подключение);
	Исключение
		Отказ = Истина;
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		РезультатЗапроса = Неопределено;
		Возврат Неопределено;
	КонецПопытки;
	
	Результат = Новый ТаблицаЗначений;
	
	// Создаем структура таблицы значений
	КоличествоКолонок = РезультатЗапроса.Fields.Count;
	Для НомерКолонки=0 По КоличествоКолонок-1 Цикл
		Результат.Колонки.Добавить(РезультатЗапроса.Fields.Item(НомерКолонки).Name);
	КонецЦикла;
	
	// Проверяем результат запроса на наличие записей
	Если РезультатЗапроса.EOF() = 1 Тогда
		РезультатЗапроса = Неопределено;
		Возврат Результат;
	КонецЕсли;
	
	Пока РезультатЗапроса.EOF() = 0 Цикл
		НоваяСтрока = Результат.Добавить();
		
		Для НомерКолонки=0 По КоличествоКолонок-1 Цикл
			НоваяСтрока[НомерКолонки] = РезультатЗапроса.Fields(НомерКолонки).Value;//РезультатЗапроса.Fields(РезультатЗапроса.Fields.Item(НомерКолонки).Name).Value;
		КонецЦикла;
		
		РезультатЗапроса.MoveNext();
	КонецЦикла;
	
	РезультатЗапроса.Close();	
	РезультатЗапроса = Неопределено;
	
	Возврат Результат;
	
КонецФункции

Функция ВыполнитьЗапросВыборкиПервойЗаписи(Подключение, Знач ТекстЗапроса, Отказ=Ложь, ТекстОшибки="", ИспользоватьТОП1=Истина) Экспорт
	
	Если ИспользоватьТОП1 Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "SELECT", "SELECT TOP 1 ");
	КонецЕсли;
	
	РезультатЗапроса = Новый COMОбъект("ADODB.Recordset");
	
	Попытка
		РезультатЗапроса.Open(ТекстЗапроса, Подключение);
	Исключение
		Отказ = Истина;
		ТекстОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		РезультатЗапроса = Неопределено;
		Возврат Неопределено;
	КонецПопытки;
	
	// Проверяем результат запроса на наличие записей
	Если РезультатЗапроса.EOF() = 1 Тогда
		РезультатЗапроса = Неопределено;
		Возврат Неопределено;
	КонецЕсли;
	
	Результат = Новый Структура;
	
	Если РезультатЗапроса.EOF() = 0 Тогда
		Для НомерКолонки=0 По РезультатЗапроса.Fields.Count-1 Цикл
			ИмяКолонки = РезультатЗапроса.Fields.Item(НомерКолонки).Name;
			Результат.Вставить(ИмяКолонки,РезультатЗапроса.Fields(ИмяКолонки).Value);
		КонецЦикла;
	КонецЕсли;
	
	РезультатЗапроса.Close();	
	РезультатЗапроса = Неопределено;
	
	Возврат Результат;
	
КонецФункции

Функция ВыполнитьПакетЗапросов(Подключение, МассивЗапросов, Отказ=Ложь, ТекстОшибки="") Экспорт
	
	РезультатЗапроса = Новый COMОбъект("ADODB.Recordset");
	
	Попытка
		Если ТипЗнч(МассивЗапросов) = Тип("Массив") Тогда
			ТекстЗапроса = "";
			Для каждого ТекущийЗапрос Из МассивЗапросов Цикл
				ТекстЗапроса = ТекстЗапроса + ТекущийЗапрос + Символы.ПС;
			КонецЦикла;
		Иначе
			ТекстЗапроса = МассивЗапросов;
		КонецЕсли;
		
		РезультатЗапроса.Open(ТекстЗапроса, Подключение);
	Исключение
		Отказ = Истина;
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		РезультатЗапроса = Неопределено;
		Возврат Неопределено;
	КонецПопытки;
	
	МассивРезультатов = Новый Массив;
	
	Пока РезультатЗапроса<>неопределено Цикл
		
		Если РезультатЗапроса.Fields.Count>0 Тогда
			Результат = Новый ТаблицаЗначений;
			
			// Создаем структура таблицы значений
			Для НомерКолонки=0 По РезультатЗапроса.Fields.Count-1 Цикл
				Результат.Колонки.Добавить(РезультатЗапроса.Fields.Item(НомерКолонки).Name);
			КонецЦикла;
			
			// Проверяем результат запроса на наличие записей
			Если РезультатЗапроса.EOF() = 1 Тогда
				РезультатЗапроса.Close();
				РезультатЗапроса = Неопределено;
				Возврат Результат;
			КонецЕсли;
			
			Пока РезультатЗапроса.EOF() = 0 Цикл
				НоваяСтрока = Результат.Добавить();
				
				Для НомерКолонки=0 По РезультатЗапроса.Fields.Count-1 Цикл
					НоваяСтрока[НомерКолонки] = РезультатЗапроса.Fields(РезультатЗапроса.Fields.Item(НомерКолонки).Name).Value;
				КонецЦикла;
				
				РезультатЗапроса.MoveNext();
			КонецЦикла;
			
			МассивРезультатов.Добавить(Результат);
		КонецЕсли;
		
		РезультатЗапроса=РезультатЗапроса.NextRecordSet();
	КонецЦикла;
	
	//РезультатЗапроса.Close();
	РезультатЗапроса = Неопределено;
	
	Если МассивРезультатов.Количество()=1 Тогда
		Возврат Результат;
	Иначе
		Возврат МассивРезультатов;
	КонецЕсли;
	
КонецФункции

Функция ВыполнитьПакетЗапросовИВыборкуПервойЗаписи(Подключение, МассивЗапросов, Отказ=Ложь, ТекстОшибки="") Экспорт
	
	РезультатЗапроса = Новый COMОбъект("ADODB.Recordset");
	
	Попытка
		Если ТипЗнч(МассивЗапросов) = Тип("Массив") Тогда
			ТекстЗапроса = "";
			Для каждого ТекущийЗапрос Из МассивЗапросов Цикл
				ТекстЗапроса = ТекстЗапроса + ТекущийЗапрос + Символы.ПС;
			КонецЦикла;
		Иначе
			ТекстЗапроса = МассивЗапросов;
		КонецЕсли;
		
		РезультатЗапроса.Open(ТекстЗапроса, Подключение);
	Исключение
		Отказ = Истина;
		ТекстОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		РезультатЗапроса = Неопределено;
		Возврат Неопределено;
	КонецПопытки;
	
	МассивРезультатов = Новый Массив;
	
	Пока РезультатЗапроса<>неопределено Цикл
		
		Если РезультатЗапроса.Fields.Count>0 Тогда
			Результат = Новый Структура;
			
			// Проверяем результат запроса на наличие записей
			Если РезультатЗапроса.EOF() = 1 Тогда
				МассивРезультатов.Добавить(Результат);
				РезультатЗапроса=РезультатЗапроса.NextRecordSet();
				Продолжить;
			КонецЕсли;
			
			Если РезультатЗапроса.EOF() = 0 Тогда
				Для НомерКолонки=0 По РезультатЗапроса.Fields.Count-1 Цикл
					ИмяКолонки = РезультатЗапроса.Fields.Item(НомерКолонки).Name;
					Результат.Вставить(ИмяКолонки,РезультатЗапроса.Fields(ИмяКолонки).Value);
				КонецЦикла;
			КонецЕсли;
			
			МассивРезультатов.Добавить(Результат);
		КонецЕсли;
		
		РезультатЗапроса=РезультатЗапроса.NextRecordSet();
	КонецЦикла;
	
	//РезультатЗапроса.Close();
	РезультатЗапроса = Неопределено;
	
	Если МассивРезультатов.Количество()=1 Тогда
		Возврат Результат;
	Иначе
		Возврат МассивРезультатов;
	КонецЕсли;
	
КонецФункции

Функция ПодключитьсяКsup_kkm(ИнформационнаяБаза) Экспорт
	//:ИнформационнаяБаза = ПараметрыСеанса.ТекущаяИБ;
		
	ServerName 	= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "СерверSQL");
	UID 		= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "Лояльность_ИмяПользователяSQL");
	PWD 		= РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "Лояльность_ПарольSQL");
	
	
	Если ServerName = Неопределено Тогда
		ServerName 	= ИнформационнаяБаза.СерверIp;//РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИнформационнаяБаза, "Лояльность_СерверSQL");
	КонецЕсли;
	
	
	
	Возврат Подключиться(ServerName,UID, PWD,"sup_kkm");
КонецФункции

Функция ТекстСкриптаОбслуживанияБД() Экспорт
	ТекстСкрипта = "-- Параметры скрипта
	|declare @database_names as nvarchar(max) = N''; -- имена баз задавать через запятую, если не заданы, то все несистемные базы
	|										  -- пока парсер примитивный - строка просто делится по запятым и обрезаются крайние пробелы
	|										  -- (если в имени базы будет запятая или в начале или конце имени пробел, то система не работает)
	|										  -- если указано ""-ИмяБазы"", то база будет исключена, 
	|declare @index_size_threshhold as int = 1024;   -- минимальный размер в КБ для перестраиваемого индекса. Нет смысла перестраивать индексы на десяток страниц
	|declare @index_rebuild_threshhold as numeric(5,2) = 25; -- показатель фрагментации, начиная с которого происходит перестроение индекса
	|declare @index_defrag_threshhold as numeric(5,2) = 12;  -- показатель фрагментации, начиная с которого происходит дефрагментация индекса
	|declare @index_rebuild_space_used_threshhold as numeric(5,2) = 50; -- процент заполненности страниц меньше которого требуется перестроение индекса
	|declare @timeout as int = 7200; -- максимальное время работы скрипта
	|declare @max_size as bigint = 536870912; -- максимальный суммарный обрабатываемый размер в КБ (чтобы не нагенерировать логов на терабайты) -- 512*1024*1024 КБ = 0,5 ТБ
	|declare @is_emulate as bit = 0; -- 0 - выполнять, 1 - только вывести команды
	|
	|set nocount on;
	|use master;
	|
	|declare @indexes as table (
	|	database_name nvarchar(128) not null,
	|	schema_name nvarchar(128) not null,
	|	table_name nvarchar(128) not null,
	|	index_name nvarchar(128) not null,
	|	is_clustered bit not null,
	|	size_kb bigint not null,
	|	fragmentation numeric(5,2) not null
	|	);
	|declare @database_names_table as table (
	|	name nvarchar(128) not null primary key
	|	);
	|if object_id('tempdb..#index_stats') is not null 
	|	drop table #index_stats;
	|create table #index_stats (
	|	database_id smallint not null,
	|	object_id int not null,
	|	index_id int not null,
	|	index_type_desc nvarchar(60) not null,
	|	avg_fragmentation_in_percent float not null,
	|	page_count bigint not null,
	|	avg_page_space_used_in_percent float not null,
	|	record_count bigint not null,
	|	index_name nvarchar(128),
	|	table_name nvarchar(128),
	|	schema_name nvarchar(128),
	|	db_name nvarchar(128)
	|	)
	|
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- Поиск баз данных для обслуживания'
	|declare @timeout_datetime datetime = dateadd(second, @timeout, getdate());
	|
	|
	|-- Создание списка обслуживаемых БД по @database_names
	|with database_name_table(database_names_tail, database_name) as 
	|	(
	|		select 
	|			substring(@database_names, nullif(charindex(',', @database_names, 1), 0) + 1, len(@database_names) + 1), 
	|			rtrim(ltrim(left(@database_names, isnull(nullif(charindex(',', @database_names, 1), 0) - 1, len(@database_names)))))
	|		where 
	|			@database_names is not null 
	|		union all
	|		select 
	|			substring(database_names_tail, nullif(charindex(',', database_names_tail, 1), 0) + 1, len(database_names_tail) + 1), 
	|			rtrim(ltrim(left(database_names_tail, isnull(nullif(charindex(',', database_names_tail, 1), 0) - 1, len(database_names_tail)))))
	|		from database_name_table db
	|		where 
	|			database_names_tail is not null 
	|	), 
	|database_names_with_indicator(database_name, indicator) as
	|	(
	|		select
	|			db_name(db_id(case when database_name like '-%' then rtrim(ltrim(substring(database_name, 2, len(database_name)))) else database_name end)),
	|			case when database_name like '-%' then 1 else 0 end
	|		from database_name_table db 
	|		where db_name(db_id(case when database_name like '-%' then rtrim(ltrim(substring(database_name, 2, len(database_name)))) else database_name end)) is not null
	|	)
	|insert @database_names_table (name)
	|select name 
	|from sys.databases db
	|where 
	|db.name not in ('master', 'model', 'tempdb', 'msdb') -- системные базы данных обычно не требуется переиндексировать
	|and db.name not in (select dbi.database_name from database_names_with_indicator dbi where indicator = 1)
	|and ((select top 1 dbi.database_name from database_names_with_indicator dbi where indicator = 0) is null or 
	|	db.name in (select dbi.database_name from database_names_with_indicator dbi where indicator = 0))
	|;
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- найдено ' + convert(nvarchar(max), @@rowcount) + ' баз данных для обслуживания'
	|
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- Поиск индексов для обслуживания'
	|-- курсором обходим выбранные БД и ищем индексы и данные по их фрагментации
	|declare @database_cursor as cursor;
	|declare @current_database as nvarchar(128);
	|set @database_cursor = cursor forward_only for
	|select name from @database_names_table;
	|open @database_cursor;
	|fetch @database_cursor into @current_database;
	|
	|while (@@FETCH_STATUS = 0)
	|begin
	|	
	|	insert #index_stats
	|		(database_id, object_id, index_id, index_type_desc, avg_fragmentation_in_percent,
	|		page_count, avg_page_space_used_in_percent, record_count)
	|	select 
	|		database_id, object_id, index_id, index_type_desc, max(avg_fragmentation_in_percent),
	|		sum(page_count), sum(avg_page_space_used_in_percent*page_count)/isnull(nullif(sum(page_count),0),1), sum(record_count)
	|	from 
	|		sys.dm_db_index_physical_stats( db_id(@current_database), null, null, null, 'DETAILED') ips
	|	where 
	|		ips.index_id>0 -- убираем кучи (heap)
	|		and ips.index_type_desc in (N'CLUSTERED INDEX', N'NONCLUSTERED INDEX') -- всякие хитрые индексы не обрабатываем
	|		and ips.alloc_unit_type_desc = N'IN_ROW_DATA' -- обрабатываем только по ""обычным"" записям
	|		and ips.index_level = 0
	|	group by database_id, object_id, index_id, index_type_desc
	|	having sum(page_count)*8 >= @index_size_threshhold 
	|
	|	exec ('use [' + @current_database + '];
	|	update i
	|	set 
	|		i.db_name = db_name(),
	|		i.table_name = t.name,
	|		i.schema_name = s.name,
	|		i.index_name = ci.name
	|	from #index_stats i
	|	left join sys.tables t on i.object_id = t.object_id
	|	left join sys.schemas s on t.schema_id = s.schema_id
	|	left join sys.indexes ci on i.object_id = ci.object_id and i.index_id = ci.index_id
	|	where 
	|	i.database_id = db_id();');
	|
	|	fetch @database_cursor into @current_database;
	|end;
	|
	|use master;
	|close @database_cursor;
	|deallocate @database_cursor;
	|
	|declare @WithOptionsRebuild nvarchar(100) = 'WITH (SORT_IN_TEMPDB = ON); '; -- в Enterprise/Developer можно добавить в скобки "", ONLINE = ON""
	|
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- Обработка найденных индексов'
	|-- Курсором обходим выбранные индексы и ищем те, которые надо обслуживать в порядке убывания размера (без упорядочнивания по БД!)
	|declare @index_cursor as cursor;
	|set @index_cursor = cursor forward_only for
	|select 
	|	'ALTER INDEX ' + i.index_name + ' ON [' + i.db_name + '].[' + i.schema_name + '].[' + i.table_name + '] ' + 
	|	case 
	|		when @index_rebuild_threshhold <= i.avg_fragmentation_in_percent then 'REBUILD ' + @WithOptionsRebuild
	|		when @index_rebuild_space_used_threshhold >= i.avg_page_space_used_in_percent then 'REBUILD ' + @WithOptionsRebuild
	|		when @index_defrag_threshhold <= i.avg_fragmentation_in_percent then 'REORGANIZE '
	|	end sql_command,
	|	case -- оценка влияния на журнал транзакций (неточная!)
	|		when @index_rebuild_threshhold <= i.avg_fragmentation_in_percent then i.page_count*8
	|		when @index_rebuild_space_used_threshhold >= i.avg_page_space_used_in_percent then i.page_count*8
	|		when @index_defrag_threshhold <= i.avg_fragmentation_in_percent then i.page_count*8*4*i.avg_fragmentation_in_percent/100
	|	end size
	|from #index_stats i
	|where 
	|	@index_rebuild_threshhold <= i.avg_fragmentation_in_percent or 
	|	@index_defrag_threshhold <= i.avg_fragmentation_in_percent or 
	|	@index_rebuild_space_used_threshhold >= i.avg_page_space_used_in_percent
	|order by i.page_count desc
	|
	|declare @database_id as smallint;
	|declare @object_id as int;
	|declare @index_id as int;
	|declare @partition_number as int;
	|declare @sql nvarchar(max);
	|declare @size numeric(20,4);
	|
	|open @index_cursor;
	|fetch @index_cursor into @sql, @size;
	|
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- Начало обновления индексов' 
	|
	|while (@@FETCH_STATUS = 0)
	|begin
	|	set @max_size = @max_size - @size;
	|
	|	print '';
	|	print '-- ' + convert(nvarchar(max), getdate(), 121);
	|	print @sql;
	|	print '-- Размер индекса: ' + cast(@size as nvarchar(max));
	|	print '-- Остаток @max_size: ' + cast(@max_size as nvarchar(max));
	|
	|	if (@is_emulate = 0)
	|		exec(@sql);
	|
	|	if (@timeout_datetime<getdate())
	|	begin
	|		print '-- Выполнение прекращено по таймауту!';
	|		break;
	|	end;
	|	if (@max_size<0) 
	|	begin
	|		print '-- Достигнут предел обслуживаемого размера, выполнение прекращено!';
	|		break;
	|	end;
	|		
	|	fetch @index_cursor into @sql, @size;
	|end;
	|
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- Окончание обновления индексов' 
	|
	|close @index_cursor;
	|deallocate @index_cursor;
	|
	|-- обновление частотных статистик
	|declare @dbstat_cursor as cursor;
	|set @dbstat_cursor = cursor forward_only for
	|select 'use [' + d.name + ']; exec sp_updatestats @resample = ''resample'';'
	|from @database_names_table d
	|
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- Начало обновления частотных статистик'
	|
	|open @dbstat_cursor;
	|fetch @dbstat_cursor into @sql;
	|
	|while (@@FETCH_STATUS = 0)
	|begin
	|	
	|	print '';
	|	print '-- ' + convert(nvarchar(max), getdate(), 121);
	|	print @sql;
	|		
	|	if (@is_emulate = 0)
	|		exec(@sql);
	|
	|	if (@timeout_datetime<getdate())
	|	begin
	|		print '-- Выполнение прекращено по таймауту!';
	|		break;
	|	end;
	|	fetch @dbstat_cursor into @sql;
	|end;
	|
	|print '-- ' + convert(nvarchar(max), getdate(), 121) + ' -- Окончание обновления частотных статистик'
	|
	|if (@is_emulate = 1)
	|  select * from #index_stats i order by i.avg_fragmentation_in_percent desc
	|  
	|  
	|drop table #index_stats;
	|";
	Возврат ТекстСкрипта;
КонецФункции

#КонецЕсли