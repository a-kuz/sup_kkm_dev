﻿Перем ТекстОшибки, фОшибка, КаталогТоваров;
Перем ЗаданияОтсутствуют;
Перем ТЗдляВыгрузкиВфайл;

Функция КатегорияПоСтавкеНДС(СтавкаНДС) 
	Если СтавкаНДС = 18 Тогда
		СтавкаНДССсылка = Перечисления.СтавкиНДС.НДС18;
	ИначеЕсли СтавкаНДС = 10 Тогда 
		СтавкаНДССсылка = Перечисления.СтавкиНДС.НДС10;
	ИначеЕсли СтавкаНДС = 0 Тогда
		СтавкаНДССсылка = Перечисления.СтавкиНДС.БезНДС;
	Иначе
		СтавкаНДССсылка = Перечисления.СтавкиНДС.НДС18;
	КонецЕсли;
	
	
	Категория = Справочники.КатегорииТоваров.НайтиПоРеквизиту("СтавкаНДС", СтавкаНДССсылка);
	Если Категория.Пустая() Тогда
		обКатегория = Справочники.КатегорииТоваров.СоздатьЭлемент();
		обКатегория.Наименование = "НДС " + СтавкаНДС + "%";
		обКатегория.СтавкаНДС = СтавкаНДССсылка;
		обКатегория.Записать();
		Категория = обКатегория.Ссылка;
	КонецЕсли;
	Возврат Категория;
КонецФункции

Процедура ЗагрузкаЗаданияИзОчереди(эуИндикатор = Неопределено, Индикатор = 0) Экспорт
	
	фОшибка = 0;
	ТекстОшибки = "";
	
	Connection = SQL.ПодключитьсяКloyality_ext();
	
	//обертываем в транзакцию и выставляем флаг обработки, чтобы на период обработки строки очереди, запись в очереди была "заблокирована"
	ТекстЗапроса = "
	|--------------------------------
	|set nocount on
	|
	|declare @идСтроки varchar(50)
	|--------------------------------
	|SELECT top 1 
	|	@идСтроки = идСтроки 
	|FROM 
	|	Loyality_ext.dbo.ОчередьЗагрузки оз 
	|where 
	|	идПолучатель = 'СУП_ККМ' 
	|	and тип = 'ОбновлениеКаталогаТоваров' 
	|	and Результат <= 0 -- берем не обработанные и ошибки
	|order by 
	|	ДатаРегистрации 
	|	, Результат desc -- сначала без ошибок
	|---------------------------------
	|Select *
	|From
	|	 Loyality_ext.dbo.ОчередьЗагрузки 
	|where 
	|	идСтроки = @идСтроки
	|---------------------------------
	|begin tran
	|update Loyality_ext.dbo.ОчередьЗагрузки 
	|	set Результат = 2 -- признак, что строка очереди - обрабатывается 
	|where 
	|	идСтроки = @идСтроки
	|";
	
	ТаблицаРезультат = SQL.ВыполнитьЗапросВыборки(Connection, ТекстЗапроса);
	
	
	Если ТаблицаРезультат = Неопределено Тогда
		ЗаданияОтсутствуют = Истина;
		Возврат;
	КонецЕсли;
	Если не ТаблицаРезультат.Количество() Тогда
		//Получение значение поля "идСтроки" первой записи
		//Предупреждение("Нет данных в очереди");
		ЗаданияОтсутствуют = Истина;
		возврат;
	КонецЕсли;
	
	СтрокаОчереди = ТаблицаРезультат[0];
	
	ЧтениеJSON = Новый ЧтениеJSON;
	ЧтениеJSON.УстановитьСтроку(СтрокаОчереди.ТекстОбъекта);
	Структура = ПрочитатьJSON(ЧтениеJSON);
	
	ТекстЗапроса = "
	|SELECT * 
	|FROM 
	|	Loyality_ext.dbo.ТоварыДляЗагрузкиККМ Товары 
	|where 
	|	идПакета = '"+СтрокаОчереди.идСтроки+"' 
	|";
	
	ТаблицаТовары = SQL.ВыполнитьЗапросВыборки(Connection, ТекстЗапроса);
	
	//	Запрос = Новый Запрос("ВЫБРАТЬ
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.КодСУП, """") КАК СТРОКА(8)) КАК КодСУП,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Товар, """") КАК СТРОКА(200)) КАК Товар,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.ГруппаКонтроляПродажи, 0) КАК ЧИСЛО(1, 0)) КАК ГруппаКонтроляПродажи,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.фАлкоголь, 0) КАК ЧИСЛО(1, 0)) КАК фАлкоголь,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.фВесовой, 0) КАК ЧИСЛО(1, 0)) КАК фВесовой,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.БЕ, """") КАК СТРОКА(4)) КАК БЕ,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Штрихкод, """") КАК СТРОКА(13)) КАК Штрихкод,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Цена, 0) КАК ЧИСЛО(10, 2)) КАК Цена,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Емкость, 0) КАК ЧИСЛО(10, 2)) КАК Емкость,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.фПометкаУдаленияШК, 0) КАК ЧИСЛО(1,0)) КАК фПометкаУдаленияШК,
	////|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.ДляЦенника, """") КАК СТРОКА(200)) КАК ДляЦенника,
	////|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.PLU, """") КАК СТРОКА(10)) КАК PLU,
	////|	ЕСТЬNULL(Т.Состав, """") КАК Состав,
	////|	ЕСТЬNULL(Т.ИнформацияДляВесов, """") КАК ИнформацияДляВесов,
	//|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.СтавкаНДС, 18) КАК ЧИСЛО(2, 0)) КАК СтавкаНДС
	//|ПОМЕСТИТЬ ТоварыСУП
	//|ИЗ
	//|	&ТоварыСУП КАК Т
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ТоварыСУП.КодСУП,
	//|	ТоварыСУП.Товар КАК Наименование,
	//|	ТоварыСУП.ГруппаКонтроляПродажи,
	//|	ТоварыСУП.фАлкоголь,
	//|	ТоварыСУП.фВесовой,
	//|	ТоварыСУП.БЕ,
	//|	ТоварыСУП.Цена,
	//|	Товары.Ссылка КАК ТоварСсылка,
	//|	Товары.Наименование КАК ТоварНаименование,
	//|	Товары.ПометкаУдаления КАК ТоварПометкаУдаления,
	//|	Товары.ГруппаКонтроляПродажи КАК ТоварГруппаКонтроляПродажиСсылка,
	//|	Товары.ГруппаКонтроляПродажи.Код КАК ТоварГруппаКонтроляПродажиКод,
	//|	Товары.ЕстьВПродаже КАК ТоварЕстьВПродаже,
	//|	Товары.фАлкоголь КАК ТоварфАлкоголь,
	//|	ТоварыСУП.Штрихкод,
	//|	Товары.ЗапросКоличества КАК ТоварЗапросКоличества,
	//|	ТоварыСУП.СтавкаНДС,
	//|	ТоварыСУП.Емкость,
	//|	ТоварыСУП.фПометкаУдаленияШК,
	////|	ТоварыСУП.ДляЦенника,
	////|	ТоварыСУП.PLU,
	////|	ТоварыСУП.Состав,
	////|	ТоварыСУП.ИнформацияДляВесов,
	//|	Товары.КодСУП КАК ТоварКодСУП
	//|ПОМЕСТИТЬ ТоварыНайденные
	//|ИЗ
	//|	ТоварыСУП КАК ТоварыСУП
	//|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.Товары КАК Товары
	//|		ПО ТоварыСУП.КодСУП = Товары.КодСУП
	//|ГДЕ
	//|	Товары.Владелец = &Каталог
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ТоварыСУП.КодСУП,
	//|	ТоварыСУП.Товар КАК Наименование,
	//|	ТоварыСУП.ГруппаКонтроляПродажи,
	//|	ТоварыСУП.фАлкоголь,
	//|	ТоварыСУП.фВесовой,
	//|	ТоварыСУП.БЕ,
	//|	ТоварыСУП.Цена,
	//|	NULL КАК ТоварСсылка,
	//|	NULL КАК ТоварНаименование,
	//|	NULL КАК ТоварПометкаУдаления,
	//|	NULL КАК ТоварГруппаКонтроляПродажиСсылка,
	//|	NULL КАК ТоварГруппаКонтроляПродажиКод,
	//|	NULL КАК ТоварЕстьВПродаже,
	//|	NULL КАК ТоварфАлкоголь,
	//|	ТоварыСУП.Штрихкод,
	//|	NULL КАК ТоварЗапросКоличества,
	//|	ТоварыСУП.СтавкаНДС,
	//|	ТоварыСУП.фПометкаУдаленияШК,
	////|	ТоварыСУП.ДляЦенника,
	////|	ТоварыСУП.PLU,
	////|	ТоварыСУП.Состав,
	////|	ТоварыСУП.ИнформацияДляВесов,
	//|	ТоварыСУП.Емкость
	//|ПОМЕСТИТЬ ОстальныеТовары
	//|ИЗ
	//|	ТоварыСУП КАК ТоварыСУП
	//|ГДЕ
	//|	НЕ ТоварыСУП.КодСУП В
	//|				(ВЫБРАТЬ
	//|					ТоварыНайденные.ТоварКодСУП
	//|				ИЗ
	//|					ТоварыНайденные КАК ТоварыНайденные)
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ТоварыНайденные.КодСУП,
	//|	ТоварыНайденные.Наименование,
	//|	ТоварыНайденные.ГруппаКонтроляПродажи,
	//|	ТоварыНайденные.фАлкоголь,
	//|	ТоварыНайденные.фВесовой,
	//|	ТоварыНайденные.БЕ,
	//|	ТоварыНайденные.Цена,
	//|	ТоварыНайденные.ТоварСсылка,
	//|	ТоварыНайденные.ТоварНаименование,
	//|	ТоварыНайденные.ТоварПометкаУдаления,
	//|	ТоварыНайденные.ТоварГруппаКонтроляПродажиСсылка,
	//|	ТоварыНайденные.ТоварГруппаКонтроляПродажиКод,
	//|	ТоварыНайденные.ТоварЕстьВПродаже,
	//|	ТоварыНайденные.ТоварфАлкоголь,
	//|	ТоварыНайденные.Штрихкод,
	//|	ТоварыНайденные.ТоварЗапросКоличества,
	//|	ТоварыНайденные.СтавкаНДС,
	//|	ТоварыНайденные.фПометкаУдаленияШК,
	//|	ТоварыНайденные.Емкость
	//|ПОМЕСТИТЬ ТоварыБезЦен
	//|ИЗ
	//|	ТоварыНайденные КАК ТоварыНайденные
	//|
	//|ОБЪЕДИНИТЬ ВСЕ
	//|
	//|ВЫБРАТЬ
	//|	ОстальныеТовары.КодСУП,
	//|	ОстальныеТовары.Наименование,
	//|	ОстальныеТовары.ГруппаКонтроляПродажи,
	//|	ОстальныеТовары.фАлкоголь,
	//|	ОстальныеТовары.фВесовой,
	//|	ОстальныеТовары.БЕ,
	//|	ОстальныеТовары.Цена,
	//|	ОстальныеТовары.ТоварСсылка,
	//|	ОстальныеТовары.ТоварНаименование,
	//|	ОстальныеТовары.ТоварПометкаУдаления,
	//|	ОстальныеТовары.ТоварГруппаКонтроляПродажиСсылка,
	//|	ОстальныеТовары.ТоварГруппаКонтроляПродажиКод,
	//|	ОстальныеТовары.ТоварЕстьВПродаже,
	//|	ОстальныеТовары.ТоварфАлкоголь,
	//|	ОстальныеТовары.Штрихкод,
	//|	ОстальныеТовары.ТоварЗапросКоличества,
	//|	ОстальныеТовары.СтавкаНДС,
	//|	ОстальныеТовары.фПометкаУдаленияШК,
	//|	ОстальныеТовары.Емкость
	//|ИЗ
	//|	ОстальныеТовары КАК ОстальныеТовары
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ТоварыБезЦен.КодСУП,
	//|	ТоварыБезЦен.Наименование,
	//|	ТоварыБезЦен.ГруппаКонтроляПродажи,
	//|	ТоварыБезЦен.фАлкоголь,
	//|	ТоварыБезЦен.фВесовой,
	//|	ТоварыБезЦен.БЕ,
	//|	ТоварыБезЦен.Цена,
	//|	ТоварыБезЦен.ТоварСсылка,
	//|	ТоварыБезЦен.ТоварНаименование,
	//|	ТоварыБезЦен.ТоварПометкаУдаления,
	//|	ТоварыБезЦен.ТоварГруппаКонтроляПродажиСсылка,
	//|	ТоварыБезЦен.ТоварГруппаКонтроляПродажиКод,
	//|	ТоварыБезЦен.ТоварЕстьВПродаже,
	//|	ТоварыБезЦен.ТоварфАлкоголь,
	//|	ЕСТЬNULL(ЦеныСрезПоследних.Цена, 0) КАК ТекЦена,
	//|	ТоварыБезЦен.Штрихкод,
	//|	ТоварыБезЦен.ТоварЗапросКоличества,
	//|	ТоварыБезЦен.СтавкаНДС,
	//|	ТоварыБезЦен.фПометкаУдаленияШК,
	//|	ТоварыБезЦен.Емкость
	//|ПОМЕСТИТЬ ТоварыСценами
	//|ИЗ
	//|	ТоварыБезЦен КАК ТоварыБезЦен
	//|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Цены.СрезПоследних(&ТекущаяДата, ТипЦен = &Розничная) КАК ЦеныСрезПоследних
	//|		ПО ТоварыБезЦен.ТоварСсылка = ЦеныСрезПоследних.Товар
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ТоварыСценами.КодСУП,
	//|	ТоварыСценами.Наименование,
	//|	ТоварыСценами.ГруппаКонтроляПродажи,
	//|	ТоварыСценами.фАлкоголь,
	//|	ТоварыСценами.фВесовой,
	//|	ТоварыСценами.БЕ,
	//|	ТоварыСценами.Цена,
	//|	ТоварыСценами.ТоварСсылка,
	//|	ТоварыСценами.ТоварНаименование,
	//|	ТоварыСценами.ТоварПометкаУдаления,
	//|	ТоварыСценами.ТоварГруппаКонтроляПродажиСсылка,
	//|	ТоварыСценами.ТоварГруппаКонтроляПродажиКод,
	//|	ТоварыСценами.ТоварЕстьВПродаже,
	//|	ТоварыСценами.ТоварфАлкоголь,
	//|	ТоварыСценами.ТекЦена,
	//|	ТоварыСценами.Штрихкод,
	//|	ШтрихКоды.Ссылка КАК ШтрихКодСсылка,
	//|	ШтрихКоды.ПометкаУдаления КАК ШтрихКодПометкаУдаления,
	//|	ТоварыСценами.ТоварЗапросКоличества,
	//|	ТоварыСценами.СтавкаНДС,
	//|	ТоварыСценами.фПометкаУдаленияШК,
	//|	ТоварыСценами.Емкость
	//|ПОМЕСТИТЬ ТоварыСценамиИшк
	//|ИЗ
	//|	ТоварыСценами КАК ТоварыСценами
	//|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтрихКоды КАК ШтрихКоды
	//|		ПО ТоварыСценами.ТоварСсылка = ШтрихКоды.Товар
	//|			И (ПОДСТРОКА(ТоварыСценами.Штрихкод, 1, 13) = ПОДСТРОКА(ШтрихКоды.ШтрихКод, 1, 13))
	//|			И (НЕ ШтрихКоды.ПометкаУдаления)
	//|			И (ШтрихКоды.Товар.Владелец = &каталог)
	//|;
	//|
	//|////////////////////////////////////////////////////////////////////////////////
	//|ВЫБРАТЬ
	//|	ТоварыСценамиИшк.КодСУП,
	//|	ТоварыСценамиИшк.Наименование,
	//|	ТоварыСценамиИшк.ГруппаКонтроляПродажи,
	//|	ТоварыСценамиИшк.фАлкоголь,
	//|	ТоварыСценамиИшк.фВесовой,
	//|	ТоварыСценамиИшк.БЕ,
	//|	ТоварыСценамиИшк.Цена,
	//|	ТоварыСценамиИшк.ТоварСсылка,
	//|	ТоварыСценамиИшк.ТоварНаименование,
	//|	ТоварыСценамиИшк.ТоварПометкаУдаления,
	//|	ТоварыСценамиИшк.ТоварГруппаКонтроляПродажиСсылка,
	//|	ТоварыСценамиИшк.ТоварГруппаКонтроляПродажиКод,
	//|	ЕСТЬNULL(ТоварыСценамиИшк.ТоварЕстьВПродаже, 0) КАК ТоварЕстьВПродаже,
	//|	ТоварыСценамиИшк.ТоварфАлкоголь,
	//|	ТоварыСценамиИшк.ТекЦена,
	//|	ТоварыСценамиИшк.Штрихкод,
	//|	ТоварыСценамиИшк.ШтрихКодСсылка,
	//|	ТоварыСценамиИшк.ШтрихКодПометкаУдаления,
	//|	ТоварыСценамиИшк.ТоварЗапросКоличества,
	//|	ТоварыСценамиИшк.СтавкаНДС,
	//|	ВЫБОР
	//|		КОГДА ТоварыСценамиИшк.ТоварСсылка.Категория.СтавкаНДС.Порядок <= 1
	//|			Тогда 18
	//|		КОГДА ТоварыСценамиИшк.ТоварСсылка.Категория.СтавкаНДС.Порядок <= 3
	//|			Тогда 10
	//|		КОГДА ТоварыСценамиИшк.ТоварСсылка.Категория.СтавкаНДС.Порядок <= 5
	//|			Тогда 0
	//|		КОГДА ТоварыСценамиИшк.ТоварСсылка.Категория.СтавкаНДС.Порядок <= 7
	//|			Тогда 20
	//|		Иначе 18
	//|	КОНЕЦ КАК ТоварКатегорияСтавкаНДС,
	//|	ТоварыСценамиИшк.фПометкаУдаленияШК,
	//|	ТоварыСценамиИшк.Емкость
	//|ИЗ
	//|	ТоварыСценамиИшк КАК ТоварыСценамиИшк"); 

	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.КодСУП, """") КАК СТРОКА(8)) КАК КодСУП,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Товар, """") КАК СТРОКА(200)) КАК Наименование,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.ГруппаКонтроляПродажи, 0) КАК ЧИСЛО(1, 0)) КАК ГруппаКонтроляПродажи,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.фАлкоголь, 0) КАК ЧИСЛО(1, 0)) КАК фАлкоголь,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.фВесовой, 0) КАК ЧИСЛО(1, 0)) КАК фВесовой,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.БЕ, """") КАК СТРОКА(4)) КАК БЕ,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Штрихкод, """") КАК СТРОКА(13)) КАК Штрихкод,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Цена, 0) КАК ЧИСЛО(10, 2)) КАК Цена,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Емкость, 0) КАК ЧИСЛО(10, 2)) КАК Емкость,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.фПометкаУдаленияШК, 0) КАК ЧИСЛО(1,0)) КАК фПометкаУдаленияШК,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.ДляЦенника, """") КАК СТРОКА(200)) КАК ДляЦенника,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.PLU, """") КАК СТРОКА(10)) КАК PLU,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.Состав, """") КАК СТРОКА(1000)) КАК Состав,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.ИнформацияДляВесов, """") КАК СТРОКА(1000)) КАК ИнформацияДляВесов,
	|	ВЫРАЗИТЬ(ЕСТЬNULL(Т.СтавкаНДС, 18) КАК ЧИСЛО(2, 0)) КАК СтавкаНДС
	|ПОМЕСТИТЬ ТоварыСУП
	|ИЗ
	|	&ТоварыСУП КАК Т
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыСУП.КодСУП,
	|	ТоварыСУП.Штрихкод,
	|	Товары.Ссылка КАК ТоварСсылка,
	|	Товары.КодСУП КАК ТоварКодСУП
	|ПОМЕСТИТЬ ТоварыНайденные
	|ИЗ
	|	ТоварыСУП КАК ТоварыСУП
	|		ПОЛНОЕ СОЕДИНЕНИЕ Справочник.Товары КАК Товары
	|		ПО ТоварыСУП.КодСУП = Товары.КодСУП
	|ГДЕ
	|	Товары.Владелец = &Каталог
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыСУП.КодСУП,
	|	ТоварыСУП.Штрихкод,
	|	NULL КАК ТоварСсылка,
	|	NULL КАК ТоварКодСУП
	|ПОМЕСТИТЬ ОстальныеТовары
	|ИЗ
	|	ТоварыСУП КАК ТоварыСУП
	|ГДЕ
	|	НЕ ТоварыСУП.КодСУП В
	|				(ВЫБРАТЬ
	|					ТоварыНайденные.ТоварКодСУП
	|				ИЗ
	|					ТоварыНайденные КАК ТоварыНайденные)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыНайденные.КодСУП,
	|	ТоварыНайденные.Штрихкод,
	|	ТоварыНайденные.ТоварСсылка
	|ПОМЕСТИТЬ ТоварыБезЦен
	|ИЗ
	|	ТоварыНайденные КАК ТоварыНайденные
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ОстальныеТовары.КодСУП,
	|	ОстальныеТовары.Штрихкод,
	|	ОстальныеТовары.ТоварСсылка
	|ИЗ
	|	ОстальныеТовары КАК ОстальныеТовары
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыБезЦен.КодСУП,
	|	ТоварыБезЦен.Штрихкод,
	|	ТоварыБезЦен.ТоварСсылка,
	|	ЕСТЬNULL(ЦеныСрезПоследних.Цена, 0) КАК ТекЦена
	|ПОМЕСТИТЬ ТоварыСценами
	|ИЗ
	|	ТоварыБезЦен КАК ТоварыБезЦен
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Цены.СрезПоследних(&ТекущаяДата, ТипЦен = &Розничная) КАК ЦеныСрезПоследних
	|		ПО ТоварыБезЦен.ТоварСсылка = ЦеныСрезПоследних.Товар
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыСценами.КодСУП,
	|	ТоварыСценами.Штрихкод,
	|	ТоварыСценами.ТоварСсылка,
	|   ТоварыСценами.ТекЦена,
	|	ШтрихКоды.Ссылка КАК ШтрихКодСсылка,
	|	ШтрихКоды.ПометкаУдаления КАК ШтрихКодПометкаУдаления
	|ПОМЕСТИТЬ ТоварыСценамиИшк
	|ИЗ
	|	ТоварыСценами КАК ТоварыСценами
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтрихКоды КАК ШтрихКоды
	|		ПО ТоварыСценами.ТоварСсылка = ШтрихКоды.Товар
	|			И (ПОДСТРОКА(ТоварыСценами.Штрихкод, 1, 13) = ПОДСТРОКА(ШтрихКоды.ШтрихКод, 1, 13))
	|			И (НЕ ШтрихКоды.ПометкаУдаления)
	|			И (ШтрихКоды.Товар.Владелец = &каталог)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТоварыСценамиИшк.КодСУП,
	|	ТоварыСУП.Наименование,
	|	ТоварыСУП.ГруппаКонтроляПродажи,
	|	ТоварыСУП.фАлкоголь,
	|	ТоварыСУП.фВесовой,
	|	ТоварыСУП.БЕ,
	|	ТоварыСУП.Цена,
	|	ТоварыСценамиИшк.ТоварСсылка,
	|	Товары.Наименование КАК ТоварНаименование,
	|	Товары.ПометкаУдаления КАК ТоварПометкаУдаления,
	|	Товары.ГруппаКонтроляПродажи КАК ТоварГруппаКонтроляПродажиСсылка,
	|	Товары.ГруппаКонтроляПродажи.Код КАК ТоварГруппаКонтроляПродажиКод,
	|	ЕСТЬNULL(Товары.ЕстьВПродаже, 0) КАК ТоварЕстьВПродаже,
	|	Товары.фАлкоголь КАК ТоварфАлкоголь,
	|	Товары.PLU КАК ТоварPLU,
	//|	Товары.Состав КАК ТоварСостав,
	//|	Товары.ИнформацияДляВесов КАК ТоварИнформацияДляВесов,
	|	ТоварыСценамиИшк.ТекЦена,
	|	ТоварыСценамиИшк.Штрихкод,
	|	ТоварыСценамиИшк.ШтрихКодСсылка,
	|	ТоварыСценамиИшк.ШтрихКодПометкаУдаления,
	|	Товары.ЗапросКоличества КАК ТоварЗапросКоличества,
	|	ТоварыСУП.СтавкаНДС КАК СтавкаНДС,
	|	ВЫБОР
	|		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 1
	|			Тогда 18
	|		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 3
	|			Тогда 10
	|		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 5
	|			Тогда 0
	|		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 7
	|			Тогда 20
	|		Иначе 18
	|	КОНЕЦ КАК ТоварКатегорияСтавкаНДС,
	|	ТоварыСУП.фПометкаУдаленияШК,
	|	ТоварыСУП.ДляЦенника,
	|	ТоварыСУП.ИнформацияДляВесов,
	|	ТоварыСУП.Состав,
	|	ТоварыСУП.PLU,
	|	ТоварыСУП.Емкость
	|ИЗ
	|	ТоварыСценамиИшк КАК ТоварыСценамиИшк 
	|ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Товары КАК Товары
	|		ПО ТоварыСценамиИшк.ТоварСсылка = Товары.Ссылка
	|ЛЕВОЕ СОЕДИНЕНИЕ ТоварыСУП КАК ТоварыСУП
	|		ПО ТоварыСУП.КодСУП = ТоварыСценамиИшк.КодСУП
	|");
	//|ГДЕ
	//|	НЕ ТоварыСценамиИшк.Наименование ЕСТЬ NULL ");
	Запрос.УстановитьПараметр("ТоварыСУП", ТаблицаТовары);
	КаталогТоваров = ОбщегоНазначенияПовтИсп.НайтиПоРеквизиту("Справочник.КаталогиТоваров", "Наименование", Структура.ВидКаталога, Ложь);
	Запрос.УстановитьПараметр("Каталог", КаталогТоваров);
	Запрос.УстановитьПараметр("Розничная", Справочники.ТипыЦен.Розничная);
	Запрос.УстановитьПараметр("ТекущаяДата", ТекущаяДатаНаСервере());
	
	ТоварыСоСсылками = Запрос.Выполнить().Выгрузить();
	ТЗдляВыгрузкиВфайл = ТоварыСоСсылками.Скопировать(Новый Массив);
	
	НачатьТранзакцию();
	
	//КаталогТоваров = Справочники.КаталогиТоваров.НайтиПоНаименованию(Структура.КаталогТоваров);
	Если КаталогТоваров = Неопределено Тогда
		ТекстОшибки = "не нашли каталог товаров = "+Структура.ВидКаталога;
		фОшибка=1;
		перейти ~Ошибка;
	КонецЕсли;
	
	
	
	//=========================================================================================	
	
	
	ВсегоСтрокТоваров =ТоварыСоСсылками.Количество();
	чТекСтрокаТовары = 0;
	Если не эуИндикатор = Неопределено Тогда
		
		эуИндикатор.МаксимальноеЗначение = ВсегоСтрокТоваров;
		
	КонецЕсли; 
	
	Индикатор = 0;
	Для каждого Т Из ТоварыСоСсылками Цикл
		чТекСтрокаТовары = чТекСтрокаТовары + 1;
		#Если Клиент Тогда
			ОбработкаПрерыванияПользователя();
			Состояние("" + чТекСтрокаТовары + "/" + ВсегоСтрокТоваров);
		#КонецЕсли
		Индикатор = Индикатор + 1;
		Если Т.Наименование = null Тогда // товар есть, но в каталоге его нет
			Если Структура.ТипЗагрузки = "заполнить" Тогда //если полное обновление каталога товаров
				Если Т.ТоварЕстьВПродаже <> null Тогда
					Если Т.ТоварЕстьВПродаже Тогда
						ТоварОбъект = Т.ТоварСсылка.ПолучитьОбъект();
						ТоварОбъект.ЕстьВПродаже = 0;
						ТоварОбъект.ПометкаУдаления = 1;
						ТоварОбъект.Записать();
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		ИначеЕсли Структура.ТипЗагрузки = "удалить" Тогда
			Если Т.ТоварЕстьВПродаже <> null Тогда
				Если Т.ТоварЕстьВПродаже Тогда
					ТоварОбъект = Т.ТоварСсылка.ПолучитьОбъект();
					ТоварОбъект.ЕстьВПродаже = 0;
					ТоварОбъект.ПометкаУдаления = 1;
					ТоварОбъект.Записать();
					
					Запрос = Новый Запрос("Выбрать Ссылка Из Справочник.Штрихкоды Где Товар = &Товар");
					Запрос.УстановитьПараметр("Товар", Т.ТоварСсылка);
					Рез = Запрос.Выполнить().Выгрузить();
					Для Каждого Т Из Рез Цикл
						Т.Ссылка.ПолучитьОбъект().Удалить();
					КонецЦикла;

					
				КонецЕсли;
			КонецЕсли;
			
		ИначеЕсли Т.ТоварСсылка = null Тогда // нужного товара нет - значит, нужно создать
			Если Т.фПометкаУдаленияШК = 0 Тогда 	// если ШК не помечен на удаление			
				ЗаписатьДанныеПоСтрокеТаблицы(Т);
			конецесли;
		ИначеЕсли Т.фПометкаУдаленияШК = 1 Тогда
			Если Т.ШтрихКодСсылка <> null Тогда  // удаление ШК
				ШК_объект = Т.ШтрихКодСсылка.ПолучитьОбъект();
				ШК_объект.ПометкаУдаления = 1;
				ШК_объект.Записать();
			КонецЕсли;
		ИначеЕсли 	Т.ШтрихКодСсылка = null 
			ИЛИ (Т.ТекЦена 		<> Т.Цена и не т.цена = 0.01)
			ИЛИ т.фАлкоголь 	<> Т.ТоварфАлкоголь 
			ИЛИ т.ДляЦенника <> СокрЛП(Т.ТоварНаименование) 
			//ИЛИ т.Состав <> СокрЛП(Т.ТоварСостав) 
			//ИЛИ т.ИнформацияДляВесов <> СокрЛП(Т.ТоварИнформацияДляВесов) 
			ИЛИ т.PLU <> СокрЛП(Т.ТоварPLU) 
			ИЛИ т.фВесовой 		<> Т.ТоварЗапросКоличества 
			ИЛИ т.СтавкаНДС		<> Т.ТоварКатегорияСтавкаНДС
			ИЛИ (т.ГруппаКонтроляПродажи <> Т.ТоварГруппаКонтроляПродажиКод и т.ГруппаКонтроляПродажи <> 0 ) 
			Или Не Т.ТоварЕстьВПродаже Тогда
			
			ЗаписатьДанныеПоСтрокеТаблицы(Т);
		КонецЕсли;
	КонецЦикла;
	//=========================================================================================	
	
	Если фОшибка = 1 Тогда
		перейти ~Ошибка;
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	ТекстЗапроса = "
	|Update Loyality_ext.dbo.ОчередьЗагрузки 
	|	set Результат = 1
	|		, ДатаОбработки = getdate()
	|where 
	|	идСтроки = '"+СтрокаОчереди.идСтроки+"'
	|
	|commit
	|";
	
	Отказ = Ложь;
	ТекстОшибки = "";
	
	SQL.ВыполнитьЗапрос(Connection, ТекстЗапроса, Отказ, ТекстОшибки);
	Попытка
		ЗаписатьВфайл();	
	Исключение
		ЗаписьЖурналаРегистрации("Обновление товаров.Ошибка записи файла для резервирования",УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	возврат;
	
	~Ошибка:
	ОтменитьТранзакцию();
	//обработка ошибки обработки строки очереди
	ТекстЗапроса = "
	|Update Loyality_ext.dbo.ОчередьЗагрузки 
	|	set Результат = -1
	|		, ДатаОбработки = getdate()
	|	, ТекстОшибки = '"+ТекстОшибки+"' 
	|where 
	|	идСтроки = '"+СтрокаОчереди.идСтроки+"'
	|
	|commit
	|";
	
	Отказ = Ложь;
	#Если Клиент Тогда
		Предупреждение(""+ТекстОшибки);	
	#Иначе
		ЗаписьЖурналаРегистрации("Обновление товаров.Ошибка при загрузке товаров",УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
	#КонецЕсли
	
	SQL.ВыполнитьЗапрос(Connection, ТекстЗапроса, Отказ, ТекстОшибки);
КонецПроцедуры

Процедура ЗаписатьВфайл() 
	Если Не ТЗдляВыгрузкиВфайл.Количество() Тогда
		Возврат;
	КонецЕсли;
	
	Хост = ПараметрыСеанса.ТекущаяИБ.СерверХост;
	Сеть.ПодключитьШару(Хост, Истина);
	
	Путь = СтрШаблон("\\%1\c$\sup_kkm\", Хост);
	ИмяФайла = "ОбновлениеТоваров_" + Формат(ТекущаяДата(), "дф='ггггММдд_ччммсс'") + ".txt";
	ЗаписатьОбъектВФайл(Путь + ИмяФайла, ТЗдляВыгрузкиВфайл);
	
КонецПроцедуры

Процедура ЗаписатьДанныеПоСтрокеТаблицы(СтрокаТаблицы, ЭтоЗагрузкаИзФайла = Ложь) Экспорт
	СтрокаТовара = СтрокаТаблицы;
	Если Не ЭтоЗагрузкаИзФайла Тогда
		ЗаполнитьЗначенияСвойств(ТЗдляВыгрузкиВфайл.Добавить(), СтрокаТаблицы);
	КонецЕсли;
	
	
	ГруппаКонтроля = ОбщегоНазначенияПовтИсп.НайтиПоРеквизиту("Справочник.ГруппыКонтроляПродажи", "Код", Число(СтрокаТовара.ГруппаКонтроляПродажи), Ложь);
	Если ГруппаКонтроля = Неопределено Тогда
		ГруппаКонтроля = Справочники.ГруппыКонтроляПродажи.НетКонтроля;	
	КонецЕсли;
	
	ЕдиницаОбъект = ОбщегоНазначенияПовтИсп.НайтиПоРеквизиту("Справочник.КлассификаторЕдиницИзмерения", "Наименование", СтрокаТовара.БЕ, Истина);
	Если ЕдиницаОбъект = Неопределено Тогда
		ЕдиницаОбъект = Справочники.КлассификаторЕдиницИзмерения.СоздатьЭлемент();
		ЕдиницаОбъект.Наименование = СтрокаТовара.БЕ;
		ЕдиницаОбъект.НаименованиеПолное = СтрокаТовара.БЕ;
		ЕдиницаОбъект.Записать();
	Иначе
		ЕдиницаОбъект = ЕдиницаОбъект.ПолучитьОбъект();
		Если ЕдиницаОбъект.ПометкаУдаления Тогда
			ЕдиницаОбъект.УстановитьПометкуУдаления(ложь);
		КонецЕсли;
	КонецЕсли;
	
	// ==== НОМЕНКЛАТУРА =============
	НоменклатураОбъект = НайтиПоРеквизиту("Справочник.Номенклатура", "КодСУП", СокрЛП(СтрокаТовара.КодСУП), Истина);
	Если НоменклатураОбъект = Неопределено Тогда
		НоменклатураОбъект = Справочники.Номенклатура.СоздатьЭлемент();
		НоменклатураОбъект.КодСУП = СокрЛП(СтрокаТовара.КодСУП);
	Иначе
		НоменклатураОбъект = НоменклатураОбъект.ПолучитьОбъект();
		Если НоменклатураОбъект.ПометкаУдаления Тогда
			НоменклатураОбъект.УстановитьПометкуУдаления(ложь);
		КонецЕсли;
	КонецЕсли;
	

	Если не НоменклатураОбъект.Наименование	= СокрЛП(СтрокаТовара.Наименование)
		или не НоменклатураОбъект.БазоваяЕдиницаИзмерения = ЕдиницаОбъект.Ссылка
		или не НоменклатураОбъект.ГруппаКонтроляПродажи	= ГруппаКонтроля
		или не НоменклатураОбъект.фАлкоголь = Число(СтрокаТовара.фАлкоголь)
		или не НоменклатураОбъект.Состав = СтрокаТовара.Состав
		или не НоменклатураОбъект.ИнформацияДляВесов = СтрокаТовара.ИнформацияДляВесов
		или не НоменклатураОбъект.КодДляВесов = СтрокаТовара.PLU 
		или СтрокаТовара.ТоварСсылка = Null тогда
		
		НоменклатураОбъект.Наименование				= СокрЛП(СтрокаТовара.Наименование);
		НоменклатураОбъект.БазоваяЕдиницаИзмерения 	= ЕдиницаОбъект.Ссылка;
		НоменклатураОбъект.ГруппаКонтроляПродажи	= ГруппаКонтроля;
		НоменклатураОбъект.фАлкоголь 				= Число(СтрокаТовара.фАлкоголь);
		НоменклатураОбъект.Состав					= СтрокаТовара.Состав;
		НоменклатураОбъект.ИнформацияДляВесов		= СтрокаТовара.ИнформацияДляВесов;
		НоменклатураОбъект.КодДляВесов				= СтрокаТовара.PLU;
		НоменклатураОбъект.Записать();
	КонецЕсли;
	
	
	Если СтрокаТовара.ТоварСсылка = Null Тогда
		
		
		//// ========= цены номеклатуры 
		//ЦеныНоменклатуры = РегистрыСведений.ЦеныНоменклатуры.СоздатьМенеджерЗаписи();
		//ЦеныНоменклатуры.Период			= ТекущаяДатаНаСервере();
		//ЦеныНоменклатуры.Номенклатура 	= НоменклатураОбъект.Ссылка;
		//ЦеныНоменклатуры.ТипЦен 		= Защита.ПолучитьТипЦен();
		//ЦеныНоменклатуры.Цена			= ?(СтрокаТовара.Цена=0.01, 0, СтрокаТовара.Цена);
		//ЦеныНоменклатуры.Записать();
		
		// ==== ТОВАРЫ =============
		ТоварОбъект = НайтиПоРеквизиту("Справочник.Товары", "КодСУП", СокрЛП(СтрокаТовара.КодСУП), Ложь, КаталогТоваров);
		Если ТоварОбъект = Неопределено Тогда
			ТоварОбъект = Справочники.Товары.СоздатьЭлемент();
			ТоварОбъект.Владелец 	= КаталогТоваров;
			ТоварОбъект.КодСУП 		= СокрЛП(СтрокаТовара.КодСУП);
		Иначе
			ТоварОбъект = ТоварОбъект.ПолучитьОбъект();
		КонецЕсли;
	Иначе
		ТоварОбъект = СтрокаТовара.ТоварСсылка.ПолучитьОбъект();
	КонецЕсли;
	
	ТоварОбъект.ОбъемБутылки 		= СтрокаТовара.Емкость;
	ТоварОбъект.Наименование		= СокрЛП(СтрокаТовара.ДляЦенника);
	ТоварОбъект.ЕстьВПродаже 		= Истина;
	ТоварОбъект.Категория			= КатегорияПоСтавкеНДС(СтрокаТовара.СтавкаНДС);
	ТоварОбъект.ГруппаКонтроляПродажи	= ГруппаКонтроля;
	ТоварОбъект.ГруппаПечати		= Справочники.ГруппыПечати.НайтиПоКоду(1);
	ТоварОбъект.Номенклатура		= НоменклатураОбъект.Ссылка;
	ТоварОбъект.фАлкоголь 			= Число(СтрокаТовара.фАлкоголь);
	ТоварОбъект.КоэфПересчета	 	= 1;
	ТоварОбъект.Тип					= Перечисления.ТипыТоваров.Товар;
	ТоварОбъект.ЕдиницаИзмерения	= ЕдиницаОбъект.Ссылка;
	ТоварОбъект.PLU					= СтрокаТовара.PLU;
	
	Если Число(СтрокаТовара.фВесовой) = 1 Тогда
		//если весовой товар, устанавливаем признак запроса количества
		ТоварОбъект.ЗапросКоличества = Истина;
		ТоварОбъект.КратностьКоличества = 0.001;
	Иначе
		ТоварОбъект.КратностьКоличества = 1;
	КонецЕсли;
	ТоварОбъект.ОбменДанными.Загрузка = Истина;	
	ТоварОбъект.Записать();
	
	//	Если (ТоварОбъект.ГруппаКонтроляПродажи	<> ГруппаКонтроля и не СтрокаТаблицы.ГруппаКонтроляПродажи = 0) 
	//		ИЛИ (Не ТоварОбъект.ЕстьВпродаже)
	//		ИЛИ (ТоварОбъект.ЕдиницаИзмерения <> ЕдиницаОбъект.ссылка) 
	//		ИЛИ (ТоварОбъект.Наименование <> СокрЛП(СтрокаТовара.ДляЦенника)) 
	//		ИЛИ (ТоварОбъект.фАлкоголь <> Число(СтрокаТовара.фАлкоголь)) 
	//		ИЛИ (ТоварОбъект.ОбъемБутылки <> СтрокаТовара.Емкость) Тогда
	//		//изменения пишем только если они есть
	//		ТоварОбъект.Наименование		= СокрЛП(СтрокаТовара.ДляЦенника);
	//		ТоварОбъект.ГруппаКонтроляПродажи = ГруппаКонтроля;
	//		ТоварОбъект.фАлкоголь 			= Число(СтрокаТовара.фАлкоголь);
	//		ТоварОбъект.ПометкаУдаления 	= 0;
	//		ТоварОбъект.ОбъемБутылки 		= СтрокаТовара.Емкость;
	//		ТоварОбъект.ЕстьВпродаже 		= 1;
	//		ТоварОбъект.ЕдиницаИзмерения	= ЕдиницаОбъект.Ссылка;
	//		
	//		ТоварОбъект.Записать();
	//	КонецЕсли;
	//	
	//	//еще проверим изменения номенклатуры, если есть - изменим
	//КонецЕсли;
	
	
	// ==== ШтрихКодыТоваров =============
	
	Если Не ПустаяСтрока(СтрокаТовара.ШтрихКод) Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ШтрихКоды.Ссылка
		|ИЗ
		|	Справочник.ШтрихКоды КАК ШтрихКоды
		|ГДЕ
		|	ШтрихКоды.ШтрихКод = &ШтрихКод
		|	И ШтрихКоды.Товар = &Товар
		|	И НЕ ШтрихКоды.ПометкаУдаления");
		Запрос.УстановитьПараметр("ШтрихКод", СокрЛП(СтрокаТовара.ШтрихКод));
		Запрос.УстановитьПараметр("Товар", ТоварОбъект.Ссылка);
		
		Рез = Запрос.Выполнить();
		Если Рез.Пустой() Тогда
			// добавляем
			ШтрихКодыОбъект = Справочники.ШтрихКоды.СоздатьЭлемент();
			ШтрихКодыОбъект.ШтрихКод = СокрЛП(СтрокаТовара.ШтрихКод);
			ШтрихКодыОбъект.Товар = ТоварОбъект.Ссылка;
			ШтрихКодыОбъект.ОбменДанными.Загрузка = Истина;		 	
			ШтрихКодыОбъект.Записать();
		КонецЕсли;
	КонецЕсли;
	
	// ========= цены товаров 
	ЦеныТоваров = РегистрыСведений.Цены.СоздатьМенеджерЗаписи();
	ЦеныТоваров.Период		= ТекущаяДатаНаСервере();
	ЦеныТоваров.Товар 		= ТоварОбъект.Ссылка;
	ЦеныТоваров.ТипЦен 		= Справочники.ТипыЦен.Розничная;
	ЦеныТоваров.Цена		= ?(СтрокаТовара.Цена=0.01, 0, СтрокаТовара.Цена);
	ЦеныТоваров.Записать();
	
КонецПроцедуры

Функция Загрузка(эуИндикатор = Неопределено, Индикатор = 0, эуТекстЗаголовка = Неопределено) Экспорт
	ЗаданияОтсутствуют = Ложь;
	
	Connection = SQL.ПодключитьсяКloyality_ext();
	
	ТекстЗапроса = "
	|SELECT
	|	count(идСтроки) идСтроки
	|FROM 
	|	Loyality_ext.dbo.ОчередьЗагрузки оз 
	|where 
	|	идПолучатель = 'СУП_ККМ' 
	|	and тип = 'ОбновлениеКаталогаТоваров' 
	|	and Результат <= 0 -- берем не обработанные и ошибки
	|";
	
	Отказ = Ложь;
	ТаблицаРезультат = SQL.ВыполнитьЗапросВыборки(Connection, ТекстЗапроса, Отказ, ТекстОшибки);
	Если Отказ Тогда
		ВызватьИсключение ТекстОшибки;
	КонецЕсли;
	
	Если ТаблицаРезультат = Неопределено Тогда
		ЗаданияОтсутствуют = Истина;
	КонецЕсли;
	
	Если Не ТаблицаРезультат.Количество() Тогда
		ЗаданияОтсутствуют = Истина;
	КонецЕсли;
	
	ВсегоЗаданий = ТаблицаРезультат.Итог("идСтроки");
	Инд = 1;
	Пока Не ЗаданияОтсутствуют И Инд <= ВсегоЗаданий Цикл
		Если эуТекстЗаголовка <> Неопределено Тогда
			эуТекстЗаголовка.Заголовок = "Обновление товаров " + Инд + " из " + ВсегоЗаданий;	
		КонецЕсли; 
		Константы.ДатаОбновленияПризнакаНаличияВПродаже.Установить(ТекущаяДатаНаСервере());
		ЗагрузкаЗаданияИзОчереди();
		Инд = Инд + 1;
	КонецЦикла;
	ФормСтрока = "Л = ru_RU; ДП = Ложь; НД = Ложь";
	ПарПредмета="задание,задания,заданий,с,,,,с,0";
	СтрЗаданий = ЧислоПрописью(ВсегоЗаданий,ФормСтрока,ПарПредмета);
	
	Сообщить("Обновление завершено. Обработано " + НРег(СтрЗаданий));
КонецФункции

Функция НайтиПоРеквизиту(ИмяТаблицы, ИмяРеквизита, ЗначениеРеквизита, ВключаяПомеченные = Ложь, Владелец = Неопределено, Родитель = Неопределено) Экспорт
	Запрос = Новый Запрос("Выбрать Ссылка ИЗ " + ИмяТаблицы + "
	|ГДЕ " + ИмяРеквизита + " = &ЗначениеРеквизита " + ?(ВключаяПомеченные, "И НЕ ПометкаУдаления","") + "
	|" + ?(Владелец = Неопределено, "", " И Владелец = &Владелец") + "
	|" + ?(Родитель = Неопределено, "", " И Родитель = &Родитель"));
	Запрос.УстановитьПараметр("ЗначениеРеквизита", ЗначениеРеквизита);
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("Родитель", Родитель);
	Рез = Запрос.Выполнить();
	Если Не Рез.Пустой() Тогда 
		Возврат Рез.Выгрузить()[0][0];
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	

КонецФункции

ЗаданияОтсутствуют = Ложь;
