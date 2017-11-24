﻿#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция Инициализация() Экспорт
	Если ирКэш.ЭтоФайловаяБазаЛкс() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	ТекстЗапроса = "
	|IF OBJECT_ID('КонтрольныеПоказатели_Значения') IS NULL BEGIN
	|	CREATE TABLE КонтрольныеПоказатели_Значения (
	|	
	|	 Ид bigint IDENTITY PRIMARY KEY
	|	 ,ДатаРегистрации datetime NOT NULL DEFAULT ((GETDATE()))
	|	 ,Хост VARCHAR(30) NOT NULL
	|	 ,КодПоказателя smallint NOT NULL
	|	 ,ЗначениеПоказателя numeric(19,5) NOT NULL
	|	 ,ДатаВыгрузки datetime  NULL
	|	) 
	|
	|	CREATE INDEX IX_ДатаРегистрации ON КонтрольныеПоказатели_Значения (ДатаРегистрации)
	|	CREATE INDEX IX_ДатаВыгрузки ON КонтрольныеПоказатели_Значения (ДатаВыгрузки)
	|END
	|";
	
	Отказ = Ложь; ТексОшибки = "";
	SQL.ВыполнитьЗапрос(Коннект(ТекущаяУниверсальнаяДатаВМиллисекундах()/(1000*600)),ТекстЗапроса,Отказ,ТексОшибки);
	Если Отказ Тогда
		ЗаписьЖурналаРегистрации("ЖР.Ошибка", УровеньЖурналаРегистрации.Ошибка, ,,ТексОшибки + Символы.ПС + ТекстЗапроса);
		Возврат Ложь;
	Иначе
		Возврат Истина;
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
Процедура Записать(Знач КодПоказателя, Знач ЗначениеПоказателя, Отказ = Ложь, ТекстОшибки = "") Экспорт
	Если Не ПараметрыСеанса.ЕстьКонтрольныеПоказатели тогда
		Отказ = Истина;
		ТекстОшибки = "нет таблицы контрольных показателей";
	КонецЕсли;
	
	Компьютер = ЖурналРегистрации.Компьютер();
	
	ТекстЗапроса = СтрШаблон("INSERT INTO dbo.КонтрольныеПоказатели_Значения
	|(
	|  ДатаРегистрации
	| ,Хост
	| ,КодПоказателя
	| ,ЗначениеПоказателя
	|)
	|VALUES
	|(
	| GetDate()  -- Дата
	| ,'%1' -- Хост - varchar(25)
	| ,%2 	-- КодПоказателя
	| ,%3 	-- ЗначениеПоказателя
	|)"
	, Компьютер
	, формат(КодПоказателя,"ЧГ=0")
	, формат(ЗначениеПоказателя,"ЧГ=0")
	);
	
	Отказ = Ложь;
	ТекстОшибки = "";
	Попытка
		SQL.ВыполнитьЗапросАсинхронно(Коннект(), ТекстЗапроса, Отказ, ТекстОшибки);	
		Если Отказ Тогда
			ВызватьИсключение ТекстОшибки;
		КонецЕсли;
	Исключение
		SQL.ВыполнитьЗапрос(SQL.ПодключитьсяКsup_kkm(ПараметрыСеанса.ТекущаяИБ), ТекстЗапроса, Отказ, ТекстОшибки);
	КонецПопытки;
	
	//Возврат Новый Структура("Отказ, ТекстОшибки",Отказ, ТекстОшибки);
КонецПроцедуры

#Если ТонкийКлиент Тогда
	&НаСервере
#КонецЕсли
Функция ВыгрузитьВцентр(ЧислоЗаписей=10000) экспорт
	//делаем через 2 соединения, пропихиваем по одной записи
	СоединениеЦентр = SQL.ПодключитьсяКСУПцентр(Справочники.Регионы.Р77, "Raz_ext_ref");
	Если СоединениеЦентр = Неопределено тогда
		возврат ложь;
	КонецЕсли;
	
	СоединениеТТ = Коннект();
	Если СоединениеТТ = Неопределено тогда
		возврат ложь;
	КонецЕсли;
	
	КодРегиона = ""+ПараметрыСеанса.ТекущаяИБ.Регион.Код;
	КодУзла = Число(Сред(ПараметрыСеанса.ТекущаяИБ.Код,3));
	ТекстЗапроса = "
	|declare @ид bigint
	|--begin tran	
	|SELECT TOP 1 
	|	@ид = ид,ДатаРегистрации,Хост,КодПоказателя,ЗначениеПоказателя
	|FROM 
	|	КонтрольныеПоказатели_Значения (nolock)
	|Where 
	|	ДатаВыгрузки is null
	|
	|if @ид is not null
	|	Update КонтрольныеПоказатели_Значения
	|		set ДатаВыгрузки = getdate()
	|	where 
	|		ид = @ид
	|";
	
	номПП=1;
	Пока 1=1 цикл
		//читаем запись из таблицы ТТ
		Отказ = Ложь;
		ТекстОшибки = ТекстОшибки;
		КонтрольныеПоказатели_Запись = SQL.ВыполнитьЗапросВыборкиПервойЗаписи(СоединениеТТ, ТекстЗапроса,Отказ,ТекстОшибки,ложь);
		
		Если не ЗначениеЗаполнено(КонтрольныеПоказатели_Запись) тогда
			прервать;
		конецЕсли;
		
		//пишем запись в ЦО
		ДатаРегистрации = Формат(КонтрольныеПоказатели_Запись.ДатаРегистрации,"ДФ='ггггммдд ЧЧ:ММ:сс'");
		ДатаВыгрузки = Формат(КонтрольныеПоказатели_Запись.ДатаВыгрузки,"ДФ='ггггммдд ЧЧ:ММ:сс'");
		
		ТекстЗапроса = "
		|INSERT INTO КонтрольныеПоказатели_Значения(
		|  Регион
		| ,КодУзла
		| ,ДатаРегистрации
		| ,Хост
		| ,КодПоказателя
		| ,ЗначениеПоказателя
		| ,ДатаВыгрузки
		|)  
		|Values(
		| "+КодРегиона+"  -- код региона
		| ,"+КодУзла+" -- код узла
		| ,'"+ДатаРегистрации+"' --
		| ,'"+КонтрольныеПоказатели_Запись.Хост+"' -- хост
		| ,"+КонтрольныеПоказатели_Запись.КодПоказателя+" -- Код показателя
		| ,"+КонтрольныеПоказатели_Запись.ЗначениеПоказателя+"--   
		| ,'"+ДатаВыгрузки+"' --
		|)";
		
		SQL.ВыполнитьЗапрос(СоединениеЦентр, ТекстЗапроса, Отказ, ТекстОшибки);
		
		Если Отказ тогда
			//Ошибка
			ЗарегистрироватьСобытие("КонтрольныеПоказатели", УровеньЖурналаРегистрации.Ошибка, ,, "Не удалось записать строку контрольных показателей в ЦО " + ТекстОшибки);
			возврат ложь;
		КонецЕсли;	
		номПП = номПП + 1;
		Если ЧислоЗаписей <> 0 тогда
			Если НомПП > ЧислоЗаписей тогда
				прервать;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	
Процедура НачатьЗамер(КодПоказателя) Экспорт
	Если глКонтрольныеПоказатели.Получить(КодПоказателя) = Неопределено Тогда
		глКонтрольныеПоказатели.Вставить(КодПоказателя, Новый Структура("НачалоЗамера", ТекущаяУниверсальнаяДатаВМиллисекундах()));		
	КонецЕсли;		
КонецПроцедуры

Процедура ЗакончитьЗамер(КодПоказателя) Экспорт
	//:глКонтрольныеПоказатели = Новый Соответствие;
	СтруктураЗамера = глКонтрольныеПоказатели.Получить(КодПоказателя);
	Если СтруктураЗамера <> Неопределено Тогда
		ЗначениеПоказателя = ТекущаяУниверсальнаяДатаВМиллисекундах() - СтруктураЗамера.НачалоЗамера;
		Записать(КодПоказателя, ЗначениеПоказателя);
		глКонтрольныеПоказатели.Удалить(КодПоказателя);
	КонецЕсли;
КонецПроцедуры

Процедура ПрерватьЗамер(КодПоказателя = Неопределено) Экспорт
	Если КодПоказателя = Неопределено Тогда
		глКонтрольныеПоказатели.Очистить();
	Иначе
		Попытка
			глКонтрольныеПоказатели.Удалить(КодПоказателя);	
		Исключение
		КонецПопытки;
		
	КонецЕсли;
КонецПроцедуры
#КонецЕсли

Функция ОписанияПоказателей() Экспорт
	ОписаниеПоказателей = Новый Соответствие;
	ОписаниеПоказателей.Вставить(1,		"Добавление строки"								);
	ОписаниеПоказателей.Вставить(2, 		"Печать чеков"										);
	ОписаниеПоказателей.Вставить(3,		"УТМ"													);
	ОписаниеПоказателей.Вставить(4,   	"Оперативный обсчет заказа лояльностью"	);
	ОписаниеПоказателей.Вставить(201,	"Обновление монитора гостя"					);
	Возврат ОписаниеПоказателей;
КонецФункции

Функция ОписаниеПоказателя(КодПоказателя) Экспорт
	Возврат ОписанияПоказателей().Получить(КодПоказателя);
КонецФункции

Функция КодПоказателя(ОписаниеПоказателя) Экспорт
	ОписанияПоказателей = КонтрольныеПоказатели.ОписанияПоказателей();//:ОписанияПоказателей = Новый Соответствие;
	Для Каждого Т Из ОписанияПоказателей Цикл
		Если Т.Значение = ОписаниеПоказателя Тогда
			Возврат Т.Ключ;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции



