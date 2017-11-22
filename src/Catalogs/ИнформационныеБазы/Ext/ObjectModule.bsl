﻿Перем Соединение Экспорт;
Перем ТолстоеСоединение Экспорт;
Функция ПолучитьУзелРИБ() Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Основной.Ссылка
	|ИЗ
	|	ПланОбмена.Основной КАК Основной
	|ГДЕ
	|	Основной.ИнформационнаяБаза = &ИнформационнаяБаза
	|	И Не ПометкаУдаления");

	Запрос.УстановитьПараметр("ИнформационнаяБаза", ПолучитьСсылку());
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		Возврат ПланыОбмена.Основной.ПустаяСсылка();
	Иначе
		Возврат Рез.Выгрузить()[0][0];
	КонецЕсли;
КонецФункции

Функция ПолучитьСсылку() Экспорт
	Если ЭтоНовый() Тогда
		Если ПолучитьСсылкуНового().Пустая() Тогда
			УстановитьСсылкуНового(Справочники.ИнформационныеБазы.ПолучитьСсылку(Новый УникальныйИдентификатор));
		КонецЕсли;
		ТекСсылка = ПолучитьСсылкуНового();
	Иначе
		ТекСсылка = Ссылка;
	КонецЕсли;
	Возврат ТекСсылка;
КонецФункции

Функция ДеревоРМ() Экспорт
	ДеревоРМ = Новый ДеревоЗначений;
	ДеревоРМ.Колонки.Добавить("Значение");
	ДеревоРМ.Колонки.Добавить("Порт");
	
	Выб = Справочники.МестаРеализации.Выбрать();
	Пока Выб.Следующий() Цикл
		Если Выб.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		стМесто = ДеревоРМ.Строки.Добавить();
		стМесто.Значение = Выб.Ссылка;
	КонецЦикла;
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	РабочиеМеста.Ссылка,
	|	РабочиеМеста.Наименование,
	|	РабочиеМеста.ПрофильВхода,
	|	РабочиеМеста.МестоРеализации,
	|	РабочиеМеста.Станция,
	|	РабочиеМеста.ИнформационнаяБаза,
	|	РабочиеМеста.Фирма
	|ИЗ
	|	Справочник.РабочиеМеста КАК РабочиеМеста
	|ГДЕ
	|	РабочиеМеста.ИнформационнаяБаза = &ИнформационнаяБаза
	|	И не ЭтоГруппа и не ПометкаУдаления");

	Запрос.УстановитьПараметр("ИнформационнаяБаза", ПолучитьСсылку());

	тзРабочиеМеста = Запрос.Выполнить().Выгрузить();
	Для каждого тРМ Из тзРабочиеМеста Цикл
		стМесто = ДеревоРМ.Строки.Найти(тРМ.МестоРеализации);
		Если стМесто = Неопределено Тогда
			стМесто = ДеревоРМ.Строки.Найти("<Место реализации не задано>");
			Если стМесто = Неопределено Тогда
				стМесто = ДеревоРМ.Строки.Добавить();
				стМесто.Значение = "<Место реализации не задано>";
			КонецЕсли;
		КонецЕсли;
		РМ = тРМ.Ссылка.ПолучитьОбъект();
		стРМ = стМесто.Строки.Добавить();
		стРМ.Значение = тРМ.Ссылка;
		Попытка
			ПараметрыРМ = ЗначениеИзСтрокиВнутр(РМ.ПараметрыРМ);
		Исключение
			Продолжить
		КонецПопытки;
		
		стУстройства = стРМ.Строки.Добавить();
		стУстройства.Значение = "Устройства ввода";
		
		УстройстваВвода = ПараметрыРМ.СписокСУ;
		Для каждого УстройствоВвода Из УстройстваВвода Цикл
			ТО = УстройствоВвода.Значение;
			стУстройство = стУстройства.Строки.Добавить();
			стУстройство.Значение = ТО;
			стУстройство.Порт = Справочники.ТорговоеОборудование.ПолучитьНомерПорта(ТО.Параметры);
		КонецЦикла;
		
		стККТ = стРМ.Строки.Добавить();
		стККТ.Значение = "ККТ";
		новККТ = стККТ.Строки.Добавить();
		новККТ.Значение = ПараметрыРМ.ККМ;
		Если ЗначениеЗаполнено(новККТ.Значение) Тогда
			новККТ.Порт = Справочники.ТорговоеОборудование.ПолучитьНомерПорта(ПараметрыРМ.ККМ.Параметры);
		КонецЕсли; 
		
		стПС = стРМ.Строки.Добавить();
		стПС.Значение = "Платежная система";
		новПС = стПС.Строки.Добавить();
		новПС.Значение = ПараметрыРМ.ПлатежнаяСистема;
		
		стДП = стРМ.Строки.Добавить();
		стДП.Значение = "Дисплей покупателя";
		новДП = стДП.Строки.Добавить();
		новДП.Значение = ПараметрыРМ.ДП;
		Если ЗначениеЗаполнено(НовДП.Значение) Тогда
			новДП.Порт = Справочники.ТорговоеОборудование.ПолучитьНомерПорта(ПараметрыРМ.ДП.Параметры);
		КонецЕсли;
		
	КонецЦикла;
	Возврат ДеревоРМ;
КонецФункции

Функция ЗначениеСвойстваПоУмолчанию(Свойство)
	Если СтрНайти(Свойство, "Ema") Тогда
		Если ЗначениеЗаполнено(Регион) И ЗначениеЗаполнено(Код) Тогда
         ИмяОтправителя = "kegelbum"+Регион.Код + НомерТТ()+"@msk.myasnov.ru";
			Если Регион = Справочники.Регионы.Р52 Тогда
				ИмяОтправителя = СтрЗаменить(ИмяОтправителя, "@msk.","@");
			КонецЕсли;
			Возврат ИмяОтправителя;
		КонецЕсли;
	КонецЕсли;
	
	Если Свойство = "Лояльность_СервисРасчетаЧеков_Локальный" Тогда
		Значение = "http://" + СерверХост + ":85/check_local/ws/check?wsdl";	
	КонецЕсли;
	
	Если СтрНайти(Свойство, "Exc") Или СтрНайти(Свойство, "УТМ") Тогда
		НомерТТ = НомерТТ();
		лСерверХост = СтрШаблон("%1-ost.tt%2.local", НомерТТ, Регион)
	ИначеЕсли Не ЗначениеЗаполнено(СерверIp) Тогда
		Возврат "";
	Иначе
		лСерверХост = СерверIp;
	КонецЕсли;

	Если Найти(Свойство, "Сервер") Тогда
		Значение = лСерверХост + "\sqlexpress";
	ИначеЕсли Найти(Свойство, "Excise_Server") Тогда
		Значение = лСерверХост;
	ИначеЕсли СтрНайти(Свойство, "УТМ") Тогда
		IP = Сеть.IpПоИмени(лСерверХост);
		Если ЗначениеЗаполнено(IP) Тогда
			Значение = IP + ":8080";
		Иначе
			Значение = лСерверХост + ":8080";
		КонецЕсли;
	ИначеЕсли СтрНайти(Свойство, "Пользовател") Или СтрНайти(Свойство, "User") Тогда
		Значение = "sa";
	ИначеЕсли СтрНайти(Свойство, "Pwd") Или СтрНайти(Свойство, "Пароль") Тогда
		Значение = "ser09l";
	КонецЕсли;
	Возврат Значение;
КонецФункции

Функция СтрокаСоединения() Экспорт
	ПортСервера = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Ссылка,"Порт сервера 1С");
	ПортСервера = ?(ПортСервера = Неопределено, "1541", ПортСервера);
	СтрокаСоединения = СтрШаблон("Srvr=""%1:%2"";Ref=""sup_kkm""", СерверХост,ПортСервера);
	Возврат СтрокаСоединения;
КонецФункции 

Функция ComConnection() Экспорт
	Если Соединение <> Неопределено Тогда
		Возврат Соединение;
	КонецЕсли;
	ИмяКомСоединителя = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Ссылка, "Имя ком соединителя");
	Если Не ЗначениеЗаполнено(ИмяКомСоединителя) Тогда
		ИмяКомСоединителя = "V83.COMConnector";		
	КонецЕсли;
	Соединитель = Новый COMObject(ИмяКомСоединителя);
	ПортСервера = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Ссылка,"Порт сервера 1С");
	ПортСервера = ?(ПортСервера = Неопределено, "1541", ПортСервера);
	СтрокаСоединения = СтрШаблон("Srvr=""%1:%2"";Ref=""sup_kkm"";Usr=""Администратор"";Pwd=""19643003""", СерверХост,ПортСервера);
	Попытка
		Соединение = Соединитель.Connect(СтрокаСоединения);		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Возврат Соединение;
КонецФункции

Функция ComApplication() Экспорт
	Если ТолстоеСоединение <> Неопределено Тогда
		Возврат ТолстоеСоединение;
	КонецЕсли;
	ТолстоеСоединение = Новый COMObject("V83.Application");
	ПортСервера = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(Ссылка,"Порт сервера 1С");
	ПортСервера = ?(ПортСервера = Неопределено, "1541", ПортСервера);
	СтрокаСоединения = СтрШаблон("Srvr=""%1:%2"";Ref=""sup_kkm"";Usr=""Администратор"";Pwd=""19643003""", СерверХост,ПортСервера);
	Попытка
		ТолстоеСоединение.Connect(СтрокаСоединения);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	Возврат ТолстоеСоединение;
КонецФункции


Функция ПолучитьДанныеИзСУПцентр(НомерТТ)
	Соединение = SQL.ПодключитьсяКСУПцентр(Регион);
		ТекстЗапроса = "
	|IF OBJECT_ID('tempdb..#Фирмы') IS NOT NULL 
	|  DROP TABLE #Фирмы
	|
	|SELECT 
	|  rtrim(ТТ.descr) Фирма_Наименование
	|  ,rtrim(Клиенты.descr) Фирма_НаименованиеЮридическогоЛица
	|  ,rtrim(CASE WHEN Клиенты.ИНН LIKE '%/%' THEN SUBSTRING(Клиенты.ИНН,1,10) ELSE Клиенты.ИНН END) ИНН
	|  ,rtrim(ТТ.КПП) КПП
	|  ,rtrim(ТТ.Адрес) Адрес
	|  ,CASE WHEN ТТ.descr LIKE 'Мяснов%' THEN 'Мяснов' ELSE 'Отдохни' END МестоРеализации
	|  ,ТТ.id ТТ
	|  ,rtrim(ТТ.code) КодТТ 
	|  ,ТипыТТ.Code ,ТипТТ
	|  INTO #Фирмы
	|  FROM Спр_ТТ ТТ
	|  JOIN Спр_Клиенты Клиенты
	|     ON Клиенты.id = ТТ.Клиент
	|  JOIN Спр_ТипТТ ТипыТТ on ТипыТТ.id = ТипТТ
	|  WHERE ТТ.НомерТТ = " + НомерТТ + "
	|";
	ТекстОшибки2="";
	SQL.ВыполнитьЗапрос(Соединение, ТекстЗапроса);
	
	ТекстЗапроса = "
	|SELECT
	|  ф.Фирма_Наименование
	| ,ф.Фирма_НаименованиеЮридическогоЛица
	| ,ф.ИНН Фирма_ИНН
	| ,ф.КПП Фирма_КПП
	| ,ф.Адрес Фирма_Адрес
	| ,ф.МестоРеализации
	| ,rtrim(ЗаводскойНомерККМ) ККМ_ЗаводскойНомер
	| ,rtrim(НомерККМ) ККМ_КодСУП
	| ,(НомерККМвТТ) НомерККМвТТ 
	| ,rtrim(ККМ.descr) РабочееМесто_Наименование
	| ,rtrim(КодТТ) КодТТ,ТипТТ
	|FROM Спр_ККМ ККМ
	|JOIN #Фирмы ф
	|  ON ККМ.ТТ = ф.ТТ
	|    AND ККМ.Активен = 1
	|    
	|    order by НомерККМвТТ, НомерККМ";
	
	Отказ = Ложь;
	ТекстОшибки = ТекстОшибки;
	ТЗ_СУП = SQL.ВыполнитьЗапросВыборки(Соединение, ТекстЗапроса, Отказ, ТекстОшибки);
	Если Отказ Тогда
		Сообщить(ТекстОшибки, СтатусСообщения.Важное);
		Возврат Неопределено;
	КонецЕсли;
	
	ТекНомерККМ_М = 0;
	ТекНомерККМ_О = 0;
	Для Каждого Т Из ТЗ_СУП Цикл
		Т.ККМ_КодСУП = СокрЛП(Т.ККМ_КодСУП);
		Если Не ЗначениеЗаполнено(Т.НомерККМвТТ) Тогда
			Если Т.МестоРеализации = "Мяснов" Тогда
				Т.НомерККМвТТ = ТекНомерККМ_М + 1;
			ИначеЕсли Т.МестоРеализации = "Отдохни" Тогда
				Т.НомерККМвТТ = ТекНомерККМ_О + 1;
			КонецЕсли
		КонецЕсли;
		Если Т.МестоРеализации = "Мяснов" Тогда
			ТекНомерККМ_М = Макс(ТекНомерККМ_М, Т.НомерККМвТТ);
		ИначеЕсли Т.МестоРеализации = "Отдохни" Тогда
			ТекНомерККМ_О = Макс(ТекНомерККМ_О, Т.НомерККМвТТ);
		КонецЕсли
	КонецЦикла;
	Возврат ТЗ_СУП;
КонецФункции

Функция Фирма(МестоРеализации, Молча = Ложь) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Фирмы.Ссылка
	|ИЗ
	|	Справочник.Фирмы КАК Фирмы
	|ГДЕ
	|	Фирмы.ИнформационнаяБаза = &ИнформационнаяБаза
	|	И Фирмы.МестоРеализации = &МестоРеализации");

	Запрос.УстановитьПараметр("ИнформационнаяБаза", ПолучитьСсылку());
	Запрос.УстановитьПараметр("МестоРеализации", МестоРеализации);
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		Фирма = Справочники.Фирмы.ПустаяСсылка();
		Если Не Молча Тогда
			#Если Клиент Тогда
				ВвестиЗначение(Фирма, "Укажите фирму по месту реализации" + МестоРеализации);
			#КонецЕсли			
		КонецЕсли;
		Возврат Фирма;
	Иначе
		Возврат Рез.Выгрузить()[0][0];
	КонецЕсли;
КонецФункции

Функция ГруппаРМ() Экспорт
	Запрос = Новый Запрос("Выбрать Ссылка Из Справочник.РабочиеМеста Где ЭтоГруппа И ИнформационнаяБаза = &ИнформационнаяБаза");
	
	Запрос.УстановитьПараметр("ИнформационнаяБаза", ПолучитьСсылку());
	Рез = Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		
		ГруппаРМ = Справочники.РабочиеМеста.НайтиПоНаименованию(Наименование, Истина);
		Если ГруппаРМ.Пустая() Тогда
			обГруппаРМ = Справочники.РабочиеМеста.СоздатьГруппу();
			обГруппаРМ.Наименование = Наименование;
			обГруппаРМ.ИнформационнаяБаза = ПолучитьСсылку();
			обГруппаРМ.Записать();
			ГруппаРМ = обГруппаРМ.Ссылка;
		КонецЕсли;
		
	Иначе
		
		ГруппаРМ = Рез.Выгрузить()[0][0];
		
	КонецЕсли;
	Возврат ГруппаРМ;
КонецФункции

Функция ГруппаТО() Экспорт
	ГруппаТО = Справочники.ТорговоеОборудование.НайтиПоНаименованию(Наименование);
	Если ГруппаТО.Пустая() Тогда
		обГруппаТО = Справочники.ТорговоеОборудование.СоздатьГруппу();
		обГруппаТО.Наименование = Наименование;
		обГруппаТО.ИнформационнаяБаза = ПолучитьСсылку();
		обГруппаТО.УстановитьНовыйКод();
		обГруппаТО.Записать();
		ГруппаТО = обГруппаТО.Ссылка;
	КонецЕсли;
	Возврат ГруппаТО;
КонецФункции

Функция СоздатьРМ(ИмяРМ, ИмяХоста, ИмяПользователя, МестоРеализации, КодКассы, Знач ЗаводскойНомерККМ, РабочееМесто = Неопределено, ПараметрыПилот = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(ЗаводскойНомерККМ) Тогда
		ЗаводскойНомерККМ = КодКассы;
	КонецЕсли;
	
	Фирма = Фирма(МестоРеализации);
	ТипТТ = Фирма.ТипТТ;
	Если ТипТТ = Справочники.ТипыТТ.КМ Тогда
		ВариантыТиповРМ = Массив(Перечисления.ТипыРМ.СтанцияОплатыКМ, Перечисления.ТипыРМ.СтанцияСканирования);
	ИначеЕсли ТипТТ = Справочники.ТипыТТ.МОКП Тогда
		ВариантыТиповРМ = Массив(Перечисления.ТипыРМ.СтанцияОплатыМОКП, Перечисления.ТипыРМ.СтанцияПовараМОКП, Перечисления.ТипыРМ.СтанцияСканирования);
	Иначе
		ВариантыТиповРМ = Массив(Перечисления.ТипыРМ.СтанцияОплаты)
	КонецЕсли;
	Если ВариантыТиповРМ.Количество() > 1 Тогда
		//:ВариантыТиповРМ = Новый Массив;
		СЗ = новый СписокЗначений; СЗ.ЗагрузитьЗначения(ВариантыТиповРМ);
		Выб = СЗ.ВыбратьЭлемент("Тип РМ", ВариантыТиповРМ[0]);
		Если Выб = Неопределено Тогда
			Возврат Неопределено;
		КонецЕсли;
		ТипРМ = Выб.Значение;
		Станция = Справочники.Станции.ПустаяСсылка();
		#Если Клиент Тогда
			ВвестиЗначение(Станция);
		#КонецЕсли		
	Иначе
		ТипРМ = ВариантыТиповРМ[0];
		Станция = ?(МестоРеализации = Справочники.МестаРеализации.Мяснов, Справочники.Станции.НайтиПоНаименованию("Мясо"), Справочники.Станции.НайтиПоНаименованию("Отдохни"));
	КонецЕсли;
	
	ЭталонныйНабор = ОбщегоНазначенияПовтИсп.НайтиПоРеквизиту("Справочник.ТорговоеОборудование", "Наименование", XMLстрока(ТипРМ), Ложь,,Справочники.ТорговоеОборудование.ЭталонныйНабор);
	Если Не ЗначениеЗаполнено(ЭталонныйНабор) Тогда
		Сообщить("Не найден эталонный набор для " + XMLстрока(ТипРМ));
		Возврат Ложь;
	КонецЕсли;

	
	Если РабочееМесто = Неопределено Тогда
		РМ = Справочники.РабочиеМеста.СоздатьЭлемент();
	Иначе
		РМ = РабочееМесто.ПолучитьОбъект();
	КонецЕсли; //:РМ = Справочники.РабочиеМеста.СоздатьЭлемент();
	
	Если ПараметрыПилот = Неопределено Тогда
		ПараметрыПилот = Новый Структура("ЭтоВива, ПортФР, ПортСканера, ПортДП", Истина);
	КонецЕсли;
	
	РМ.Наименование = ИмяРМ;
	РМ.Родитель = ГруппаРМ();
	РМ.ПрофильВхода = "\\"+ИмяХоста+"\"+ИмяПользователя;
	РМ.ИнформационнаяБаза = ПолучитьСсылку();
	РМ.Фирма = Фирма;
	РМ.МестоРеализации = МестоРеализации;   
	РМ.Тип = ТипРМ;
	РМ.Станция = Станция;
	РМ.НомерККМ = КодКассы;
	РМ.Хост = ИмяХоста;
	Если СтрНайти(имяХоста,".local") = 0 тогда
		РМ.Хост = РМ.Хост+ ".tt" + РМ.ИнформационнаяБаза.Регион + ".local";
	КонецЕсли;
	
	РМ.Записать();
	
	ПараметрыРМ = ПараметрыРМ(РМ.Ссылка);
	ПараметрыРМ.Вставить("ИнформационнаяБаза", ПолучитьСсылку());
	ПараметрыРМ.Вставить("Фирма", Фирма(МестоРеализации));
	ПараметрыРМ.Вставить("МестоРеализации", МестоРеализации);
	ПараметрыРМ.Вставить("Станция", РМ.Станция);
	Если ПараметрыПилот.ЭтоВива = Ложь Тогда
		ПараметрыРМ.Вставить("ИнтерфейсТип", 8);
		ПараметрыРМ.Вставить("ИнтерфейсРазмерОкна", 2);
		РМ.Наименование = ИмяРМ + " (TPX)";
	Иначе
		РМ.Наименование = ИмяРМ + "";
	КонецЕсли;

	РМ.ПараметрыРМ = ЗначениеВСтрокуВнутр(ПараметрыРМ);
	
	// ПортФР, ПортДП, ПортСканера, ЭтоВива
	
	СписокСУ = Новый СписокЗначений;
	ККМ = ККМ;
	ПлатежнаяСистема = ПлатежнаяСистема;
	ДП = ДП;
	ИнфоДисплей = ИнфоДисплей;
	//:ТипРМ = Перечисления.ТипыРМ.СтанцияОплаты;
	Выб = Справочники.ТорговоеОборудование.Выбрать(ЭталонныйНабор);
	Пока Выб.Следующий() Цикл
		Если Выб.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		обТО = Выб.ПолучитьОбъект().Скопировать();
		обТО.Наименование = ИмяХоста + " | " + Выб.Наименование;
		обТО.Родитель = ГруппаТО();
		обТО.ИнформационнаяБаза = ПолучитьСсылку();
		обТО.УстановитьНовыйКод();
		Если Выб.КодМодели = "ПР410" Тогда
			Если ЗаводскойНомерККМ <> КодКассы Тогда
				Продолжить;
			КонецЕсли;
			обТО.КодСУП = КодКассы;
			обТО.ЗаводскойНомер = ЗаводскойНомерККМ;
		КонецЕсли;
		Если Выб.КодМодели = "АТОЛ77Ф" Тогда
			Если ЗаводскойНомерККМ = КодКассы Тогда
				Продолжить;
			КонецЕсли;
			обТО.КодСУП = КодКассы;
			обТО.ЗаводскойНомер = ЗаводскойНомерККМ;
			
		КонецЕсли;
		обТО.Записать();
		Если Выб.КодМодели = "СканерШК" Тогда
			СписокСУ.Добавить(обТО.Ссылка);
			Если ЗначениеЗаполнено(ПараметрыПилот.ПортСканера) Тогда
				обТО.Параметры = Справочники.ТорговоеОборудование.ИзменитьНомерПорта(обТО.Параметры, ПараметрыПилот.ПортСканера);
				обТО.Записать();
			КонецЕсли;
		ИначеЕсли Выб.КодМодели = "РидерМК" Тогда
			Если ПараметрыПилот.ЭтоВива = Ложь Тогда
				обТО.Наименование = ИмяХоста + " | Ридер (+autohotkey)";
				обТО.Записать();
			КонецЕсли;
			СписокСУ.Добавить(обТО.Ссылка);
		ИначеЕсли Выб.КодМодели = "ПроксиIronLogicZ2" Тогда
			Если ПараметрыПилот.ЭтоВива = Ложь Тогда
				обТО.Наименование = ИмяХоста + " | Ридер (+autohotkey)";
				обТО.Записать();
			КонецЕсли;
			СписокСУ.Добавить(обТО.Ссылка);

		ИначеЕсли Выб.КодВида = "ФР" Тогда
			ККМ = обТО.Ссылка;
			Если ЗначениеЗаполнено(ПараметрыПилот.ПортФР) Тогда
				обТО.Параметры = Справочники.ТорговоеОборудование.ИзменитьНомерПорта(обТО.Параметры, ПараметрыПилот.ПортФР);
				обТО.Фирма = РМ.Фирма;
				обТО.Записать();
			КонецЕсли;
		ИначеЕсли Выб.КодВида = "ПС" Тогда
			ПлатежнаяСистема = обТО.Ссылка;
		ИначеЕсли СтрНайти(Выб.Наименование, "исплей") Тогда
			Если ЗначениеЗаполнено(ПараметрыПилот.ПортДП) Тогда
				обТО.Параметры = Справочники.ТорговоеОборудование.ИзменитьНомерПорта(обТО.Параметры, ПараметрыПилот.ПортДП);
				обТО.Записать();
			КонецЕсли;
			ДП = обТО.Ссылка;
		ИначеЕсли Выб.КодВида = "ИнфоДисплей" Тогда
			ИнфоДисплей = обТО.Ссылка;
		Иначе
			обТО.Записать();
		КонецЕсли;
	КонецЦикла;
	
	ПараметрыРМ.Вставить("ККМЕсть", ЗначениеЗаполнено(ККМ));
	ПараметрыРМ.Вставить("ИнфоДисплейЕсть", ЗначениеЗаполнено(ИнфоДисплей));
	ПараметрыРМ.Вставить("ДПЕсть", 	ЗначениеЗаполнено(ДП));
	ПараметрыРМ.Вставить("СписокСУ",СписокСУ);
	ПараметрыРМ.Вставить("ККМ", 	ККМ);
	ПараметрыРМ.Вставить("ДП", 		ДП);
	ПараметрыРМ.Вставить("ИнфоДисплей",	ИнфоДисплей);
	ПараметрыРМ.ДПТекстОжидание = "       Добро 
								  |     пожаловать";
	ПараметрыРМ.Вставить("БлокировкаАвто", Истина);
	ПараметрыРМ.Вставить("БыстраяАвторизация", Истина);
	ПараметрыРМ.Вставить("ПроизводствоИспользоватьКурсы", Истина);
	ПараметрыРМ.Вставить("ЗаказИспользоватьКурсы", Истина);
	ПараметрыРМ.Вставить("БлокировкаАвтоВремя", 145);
	ПараметрыРМ.Вставить("ПлатежнаяСистема", ПлатежнаяСистема);
	ПараметрыРМ.Вставить("ЗаказМенюОсновное", КороткоеМеню(МестоРеализации));
	ПараметрыРМ.Вставить("ЗаказМенюВид", 1);
	
	РМ.ПараметрыРМ = ЗначениеВСтрокуВнутр(ПараметрыРМ);
	РМ.Записать();
	Возврат РМ;
КонецФункции

Функция КороткоеМеню(МестоРеализации)
	//:МестоРеализации = Справочники.МестаРеализации.СоздатьЭлемент();
	Ст = МестоРеализации.КороткиеМеню.Найти(Регион);
	Если Не Ст = Неопределено Тогда
		Возврат Ст.КороткоеМеню;
	Иначе
		Сообщить("Не задано короткое меню по умолчанию для места реализации " + МестоРеализации);
		Возврат Неопределено;
	КонецЕсли;
КонецФункции

Функция ПараметрыРМ(РМ) Экспорт
	ПараметрыРМ = Новый Структура;
	НастройкаРМ = Справочники.РабочиеМеста.ПолучитьФорму("НастройкаРМ");
	НастройкаРМ.СправочникОбъект = РМ.ПолучитьОбъект();
	
	НастройкаРМ.СохранитьПараметры(ПараметрыРМ);
	Возврат ПараметрыРМ;
КонецФункции

Функция НомерТТ() Экспорт
	НомерТТ = Число(Сред(Код, 3)); // вызовет исключение на неправильных кодах. Так и нужно
	стрНомерТТ = Формат(НомерТТ,"ЧГ=0");
	Возврат стрНомерТТ;
КонецФункции

Процедура ЗаполнитьПоНомеруТТ(НомерТТ, СтандартныеПорты = Ложь, СоздатьРабочиеМеста = Истина) Экспорт
	стрНомерТТ = Формат(НомерТТ,"ЧГ=0");
	Это50регион = Лев(стрНомерТТ,2) = "50";	
	НачатьТранзакцию();	
	СерверХост = СтрШаблон("%1-serv.tt%2.local", стрНомерТТ, Регион);
	СерверIp = Сеть.IpПоИмени(СерверХост);
	Наименование = СтрШаблон("ТТ%1_%2", Регион, стрНомерТТ);
	Код = СтрШаблон("%1%2", Регион, Формат(НомерТТ,"ЧЦ=5; ЧВН=; ЧГ=0"));
	ДопустимыеГруппыОграниченияПродажи = Массив("50","52","77");//:ДопустимыеГруппыОграниченияПродажи = Новый Массив;
	
	КодГр = Лев(Код,2);
	Если ДопустимыеГруппыОграниченияПродажи.Найти(КодГр)<>Неопределено Тогда
		КодГруппыОграниченияПродажи = КодГр;
	КонецЕсли;
	
	ТЗ_СУП = ПолучитьДанныеИзСУПцентр(стрНомерТТ);
	//:ТЗ_СУП = Новый ТаблицаЗначений;
	Если ТЗ_СУП = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Фирмы = ТЗ_СУП.Скопировать();
	Фирмы.Свернуть("Фирма_Адрес, Фирма_Наименование, Фирма_НаименованиеЮридическогоЛица, Фирма_ИНН, Фирма_КПП, МестоРеализации, КодТТ, ТипТТ");
	МестаРеализации = Фирмы.Скопировать(,"МестоРеализации");
	Для Каждого Место Из МестаРеализации Цикл
		МС = Фирмы.НайтиСтроки(Новый Структура("МестоРеализации", Место.МестоРеализации));
		Если МС.Количество() > 1 Тогда
			стрФирмы = "";
			Для Каждого Т Из МС Цикл 
				стрФирмы=стрФирмы+Т.Фирма_Наименование+Символы.ПС;
				Если МС.Найти(Т)<МС.ВГраница() Тогда
					Фирмы.Удалить(Т);
				КонецЕсли;
			КонецЦикла;
				
			#Если Клиент Тогда
			Предупреждение("У ТТ " + НомерТТ + " по месту реализации " + Место.МестоРеализации + " более одной фирмы!
			|" + стрФирмы);
			#КонецЕсли
		КонецЕсли;
	КонецЦикла;
	Для Каждого ДанныеФирмы Из Фирмы Цикл
		Если СтрДлина(ДанныеФирмы.Фирма_Адрес) > 128 Тогда
			#Если Клиент Тогда
			Предупреждение(ДанныеФирмы.Фирма_Адрес + Символы.ПС + "Длина адреса не может превышать 128 символов (из-за ЕГАИС)");
			#КонецЕсли
		КонецЕсли;
		МестоРеализации = Справочники.МестаРеализации[ДанныеФирмы.МестоРеализации];
		Фирма = Фирма(МестоРеализации, Истина);
		Если Фирма.Пустая() Тогда
			Фирма = Справочники.Фирмы.СоздатьЭлемент();
		Иначе
			Фирма = Фирма.ПолучитьОбъект();
		КонецЕсли;
		//:Фирма = Справочники.Фирмы.СоздатьЭлемент();
		Фирма.Наименование 					= ДанныеФирмы.Фирма_Наименование;
		Фирма.НаименованиеЮридическогоЛица 	= ДанныеФирмы.Фирма_НаименованиеЮридическогоЛица;
		Фирма.Адрес 						= ДанныеФирмы.Фирма_Адрес;
		Фирма.ИНН							= ДанныеФирмы.Фирма_ИНН;
		Фирма.КПП							= ДанныеФирмы.Фирма_КПП;
		Фирма.ИнформационнаяБаза 			= ПолучитьСсылку();
		Фирма.МестоРеализации 				= МестоРеализации;
		Фирма.Префикс						= стрНомерТТ;
		Фирма.КодТТ							= ДанныеФирмы.КодТТ;
		Фирма.АдресДляЕГАИС					= ДанныеФирмы.Фирма_Адрес;
		Фирма.ТипТТ							= Справочники.ТипыТТ.НайтиПоКоду(Число(СокрЛП(ДанныеФирмы.ТипТТ)));
		Фирма.Записать();
		
		МС = ТЗ_СУП.НайтиСтроки(Новый Структура("Фирма_Наименование", ДанныеФирмы.Фирма_Наименование));
		Для НомерККМвТТ = 1 По МС.Количество()+1 Цикл
			
			ПрефиксРМ 	= ?(МестоРеализации = Справочники.МестаРеализации.Мяснов, "m", "a");
			ИмяХоста 	= СтрШаблон("%1-k%2%3", стрНомерТТ, ПрефиксРМ, НомерККМвТТ);
			Суффикс 	= СтрШаблон(".tt%1.local", Регион);
			Если СтандартныеПорты Тогда
				Если НомерККМвТТ-1 > МС.ВГраница() Тогда
					Продолжить;
				КонецЕсли;
				ТекККМ = МС[НомерККМвТТ-1];
				КодКассы = ТекККМ.ККМ_КодСУП;
				ПараметрыПилот = Неопределено;
			Иначе
				КодКассы 	= Сеть.КодКассыИзCashReg(ИмяХоста+Суффикс);
				ПараметрыПилот = Сеть.ИзвлечьПараметрыРМизКонфиговПилота(ИмяХоста+Суффикс);
				
			КонецЕсли;
			
			
			МассивСоСтрокойККМ = ТЗ_СУП.НайтиСтроки(Новый Структура("ККМ_КодСУП", Формат(КодКассы,"ЧГ=0")));
			Если МассивСоСтрокойККМ.Количество() Тогда
				ДанныеККМ = МассивСоСтрокойККМ[0];
			Иначе
				Сообщить("Касса " + КодКассы + " " + ИмяХоста + " офлайн", СтатусСообщения.Внимание);
				Продолжить;
			КонецЕсли;
			
			ИмяПользователя = ?(МестоРеализации = Справочники.МестаРеализации.Мяснов, "Myasnov-Pos", "Otdohni-pos");
			Профиль  		= СтрШаблон("\\%1\%2", ИмяХоста, ИмяПользователя);
			РабочееМесто 	= ОбщегоНазначенияПовтИсп.НайтиПоРеквизиту("Справочник.РабочиеМеста", "ПрофильВхода", Профиль, Ложь, , ГруппаРМ(), Строка(Новый УникальныйИдентификатор));
			ИмяРМ 			= Наименование + " | " + ИмяХоста + " / " + ДанныеККМ.ККМ_КодСУП;
			Если СоздатьРабочиеМеста Тогда
				РабочееМесто 	= СоздатьРМ(ИмяРМ, ИмяХоста, ИмяПользователя, МестоРеализации, ДанныеККМ.ККМ_КодСУП, ДанныеККМ.ККМ_ЗаводскойНомер, РабочееМесто, ПараметрыПилот);
			КонецЕсли;
			
		КонецЦикла;
	КонецЦикла;	
	ДобавитьСвойства();
	
	ЗафиксироватьТранзакцию();
КонецПроцедуры

Функция ЕстьТолькоМяснов() Экспорт
	Отдохни = Фирма(Справочники.МестаРеализации.Отдохни, Истина);
	Возврат Отдохни = Справочники.Фирмы.ПустаяСсылка();
КонецФункции

Процедура ДобавитьСвойства() Экспорт
	Если ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	ОбязательныеСвойства = Массив("Excise_Server", "Excise_User", "Excise_Pwd", "Лояльность_СерверSQL","Лояльность_ИмяПользователяSQL", "Лояльность_ПарольSQL", "УТМ", "Email_ИмяОтправителя", "Лояльность_СервисРасчетаЧеков_Локальный");
	СвойстваОтдохни = Массив("Excise_Server", "Excise_User", "Excise_Pwd", "УТМ");
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ДополнительныеСвойства.Свойство,
	|	ДополнительныеСвойства.Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСвойства КАК ДополнительныеСвойства
	|ГДЕ
	|	ИнформационнаяБаза = &ИнформационнаяБаза");
	Запрос.УстановитьПараметр("ИнформационнаяБаза", ПолучитьСсылку());
	
	тзСвойства = Запрос.Выполнить().Выгрузить();
	Отдохни = Фирма(Справочники.МестаРеализации.Отдохни, Истина);
	Для Каждого Свойство Из ОбязательныеСвойства Цикл
		Если СвойстваОтдохни.Найти(Свойство) <> Неопределено И ЕстьТолькоМяснов() Тогда
			Продолжить;
		КонецЕсли;
		
		ст = тзСвойства.Найти(Свойство ,"Свойство");
		Нов = РегистрыСведений.ДополнительныеСвойства.СоздатьМенеджерЗаписи();
		Нов.ИнформационнаяБаза = ПолучитьСсылку();
		
		Если СтрНайти(Свойство, "УТМ") Тогда
			Если ЗначениеЗаполнено(Отдохни) Тогда
				Нов.Объект = Отдохни;
			Иначе
				Продолжить;
			КонецЕсли;
		Иначе
			Нов.Объект = ПолучитьСсылку();
		КонецЕсли;
	
		Нов.Свойство = Свойство;
		Если ст = Неопределено Тогда
			Нов.Записать();
		Иначе
			Нов.Значение = ст.Значение;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Нов.Значение) Тогда
			Нов.Значение = ЗначениеСвойстваПоУмолчанию(Свойство);
			Нов.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	Если Не Отказ Тогда
		Если ПолучитьУзелРИБ().Пустая() Тогда
			УзелРИБ = ПланыОбмена.Основной.СоздатьУзел();
			//УзелРИБ.Код = Код;
			УзелРИБ.УстановитьНовыйКод();
			УзелРИБ.Наименование = Наименование;
			УзелРИБ.ИнформационнаяБаза = Ссылка;
			УзелРИБ.Записать();
		КонецЕсли;
		
		Если Не Справочники.ГруппыИнформационныхБаз.ГруппыПоИБ(Ссылка).Количество() Тогда
			Если Не ТолькоМяснов Тогда
				Нов = РегистрыСведений.СоставГруппИнформационныхБаз.СоздатьМенеджерЗаписи();
				Нов.Группа = Справочники.ГруппыИнформационныхБаз.Отдохни;
				Нов.ИнформационнаяБаза = Ссылка;
				Нов.Записать();
			КонецЕсли;
			
			Нов = РегистрыСведений.СоставГруппИнформационныхБаз.СоздатьМенеджерЗаписи();
			Нов.Группа = Справочники.ГруппыИнформационныхБаз.Мяснов;
			Нов.ИнформационнаяБаза = Ссылка;
			Нов.Записать();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
