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
	|	and Результат <= 0 -- берем Не обработанные и ошибки
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
	//|begin tran
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
	Если Не ТаблицаРезультат.Количество() Тогда
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
	                      |	ВЫРАЗИТЬ(ЕСТЬNULL(Т.фПометкаУдаленияШК, 0) КАК ЧИСЛО(1, 0)) КАК фПометкаУдаленияШК,
	                      |	ВЫРАЗИТЬ(ЕСТЬNULL(Т.ДляЦенника, """") КАК СТРОКА(200)) КАК ДляЦенника,
	                      |	ВЫРАЗИТЬ(ЕСТЬNULL(Т.НаименованиеОригинальное, """") КАК СТРОКА(200)) КАК НаименованиеОригинальное,
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
	                      |	ТоварыСУП.КодСУП КАК КодСУП,
	                      |	ТоварыСУП.Штрихкод КАК Штрихкод,
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
	                      |	ТоварыСУП.КодСУП КАК КодСУП,
	                      |	ТоварыСУП.Штрихкод КАК Штрихкод,
	                      |	NULL КАК ТоварСсылка,
	                      |	NULL КАК ТоварКодСУП
	                      |ПОМЕСТИТЬ ОстальныеТовары
	                      |ИЗ
	                      |	ТоварыСУП КАК ТоварыСУП
	                      |ГДЕ
	                      |	Не ТоварыСУП.КодСУП В
	                      |				(ВЫБРАТЬ
	                      |					ТоварыНайденные.ТоварКодСУП
	                      |				ИЗ
	                      |					ТоварыНайденные КАК ТоварыНайденные)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ТоварыНайденные.КодСУП КАК КодСУП,
	                      |	ТоварыНайденные.Штрихкод КАК Штрихкод,
	                      |	ТоварыНайденные.ТоварСсылка КАК ТоварСсылка
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
	                      |	ТоварыБезЦен.КодСУП КАК КодСУП,
	                      |	ТоварыБезЦен.Штрихкод КАК Штрихкод,
	                      |	ТоварыБезЦен.ТоварСсылка КАК ТоварСсылка,
	                      |	ЕСТЬNULL(ЦеныСрезПоследних.Цена, 0) КАК ТекЦена
	                      |ПОМЕСТИТЬ ТоварыСценами
	                      |ИЗ
	                      |	ТоварыБезЦен КАК ТоварыБезЦен
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&ТекущаяДата, ТипЦен = &Розничная) КАК ЦеныСрезПоследних
	                      |		ПО ТоварыБезЦен.ТоварСсылка.Номенклатура = ЦеныСрезПоследних.Номенклатура
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ТоварыСценами.КодСУП КАК КодСУП,
	                      |	ТоварыСценами.Штрихкод КАК Штрихкод,
	                      |	ТоварыСценами.ТоварСсылка КАК ТоварСсылка,
	                      |	ТоварыСценами.ТекЦена КАК ТекЦена,
	                      |	ШтрихКоды.Ссылка КАК ШтрихКодСсылка,
	                      |	ШтрихКоды.ПометкаУдаления КАК ШтрихКодПометкаУдаления
	                      |ПОМЕСТИТЬ ТоварыСценамиИшк
	                      |ИЗ
	                      |	ТоварыСценами КАК ТоварыСценами
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ШтрихКоды КАК ШтрихКоды
	                      |		ПО ТоварыСценами.ТоварСсылка = ШтрихКоды.Товар
	                      |			И (ПОДСТРОКА(ТоварыСценами.Штрихкод, 1, 13) = ПОДСТРОКА(ШтрихКоды.ШтрихКод, 1, 13))
	                      |			И (Не ШтрихКоды.ПометкаУдаления)
	                      |			И (ШтрихКоды.Товар.Владелец = &Каталог)
	                      |;
	                      |
	                      |////////////////////////////////////////////////////////////////////////////////
	                      |ВЫБРАТЬ
	                      |	ТоварыСценамиИшк.КодСУП КАК КодСУП,
	                      |	ТоварыСУП.Наименование КАК Наименование,
	                      |	ТоварыСУП.ГруппаКонтроляПродажи КАК ГруппаКонтроляПродажи,
	                      |	ТоварыСУП.фАлкоголь КАК фАлкоголь,
	                      |	ТоварыСУП.фВесовой КАК фВесовой,
	                      |	ТоварыСУП.БЕ КАК БЕ,
	                      |	ТоварыСУП.Цена КАК Цена,
	                      |	ТоварыСценамиИшк.ТоварСсылка КАК ТоварСсылка,
	                      |	Товары.Наименование КАК ТоварНаименование,
	                      |	Товары.ПометкаУдаления КАК ТоварПометкаУдаления,
	                      |	Товары.ГруппаКонтроляПродажи КАК ТоварГруппаКонтроляПродажиСсылка,
	                      |	Товары.ГруппаКонтроляПродажи.Код КАК ТоварГруппаКонтроляПродажиКод,
	                      |	ЕСТЬNULL(Товары.ЕстьВПродаже, 0) КАК ТоварЕстьВПродаже,
	                      |	Товары.фАлкоголь КАК ТоварфАлкоголь,
	                      |	Товары.PLU КАК ТоварPLU,
	                      |	сНоменклатура.ДляЦенника КАК НоменклатураДляЦенника,
	                      |	сНоменклатура.НаименованиеОригинальное КАК НоменклатураНаименованиеОригинальное,
	                      |	сНоменклатура.Состав КАК НомеклатураСостав,
	                      |	сНоменклатура.ИнформацияДляВесов КАК НоменклатураИнформацияДляВесов,
	                      |	ТоварыСценамиИшк.ТекЦена КАК ТекЦена,
	                      |	ТоварыСценамиИшк.Штрихкод КАК Штрихкод,
	                      |	ТоварыСценамиИшк.ШтрихКодСсылка КАК ШтрихКодСсылка,
	                      |	ТоварыСценамиИшк.ШтрихКодПометкаУдаления КАК ШтрихКодПометкаУдаления,
	                      |	Товары.ЗапросКоличества КАК ТоварЗапросКоличества,
	                      |	ТоварыСУП.СтавкаНДС КАК СтавкаНДС,
	                      |	ВЫБОР
	                      |		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 1
	                      |			ТОГДА 18
	                      |		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 3
	                      |			ТОГДА 10
	                      |		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 5
	                      |			ТОГДА 0
	                      |		КОГДА Товары.Категория.СтавкаНДС.Порядок <= 7
	                      |			ТОГДА 20
	                      |		ИНАЧЕ 18
	                      |	КОНЕЦ КАК ТоварКатегорияСтавкаНДС,
	                      |	ТоварыСУП.фПометкаУдаленияШК КАК фПометкаУдаленияШК,
	                      |	ТоварыСУП.ДляЦенника КАК ДляЦенника,
	                      |	ТоварыСУП.НаименованиеОригинальное КАК НаименованиеОригинальное,
	                      |	ТоварыСУП.ИнформацияДляВесов КАК ИнформацияДляВесов,
	                      |	ТоварыСУП.Состав КАК Состав,
	                      |	ТоварыСУП.PLU КАК PLU,
	                      |	ТоварыСУП.Емкость КАК Емкость
	                      |ИЗ
	                      |	ТоварыСценамиИшк КАК ТоварыСценамиИшк
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Товары КАК Товары
	                      |		ПО ТоварыСценамиИшк.ТоварСсылка = Товары.Ссылка
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Номенклатура КАК сНоменклатура
	                      |		ПО Товары.Номенклатура = сНоменклатура.Ссылка
	                      |		ЛЕВОЕ СОЕДИНЕНИЕ ТоварыСУП КАК ТоварыСУП
	                      |		ПО (ТоварыСУП.КодСУП = ТоварыСценамиИшк.КодСУП)
	                      |			И (ТоварыСУП.Штрихкод = ТоварыСценамиИшк.Штрихкод)");
	//|ГДЕ
	//|	Не ТоварыСценамиИшк.Наименование ЕСТЬ NULL ");
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
		ТекстОшибки = "Не нашли каталог товаров = "+Структура.ВидКаталога;
		фОшибка=1;
		перейти ~Ошибка;
	КонецЕсли;
	
	
	
	//=========================================================================================	
	
	
	ВсегоСтрокТоваров =ТоварыСоСсылками.Количество();
	чТекСтрокаТовары = 0;
	Если Не эуИндикатор = Неопределено Тогда
		
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
			Если Т.фПометкаУдаленияШК = 0 Тогда 	// если ШК Не помечен на удаление			
				ЗаписатьДанныеПоСтрокеТаблицы(Т);
			конецесли;
		ИначеЕсли Т.фПометкаУдаленияШК = 1 Тогда
			Если Т.ШтрихКодСсылка <> null Тогда  // удаление ШК
				ШК_объект = Т.ШтрихКодСсылка.ПолучитьОбъект();
				ШК_объект.ПометкаУдаления = 1;
				ШК_объект.Записать();
			КонецЕсли;
		ИначеЕсли 	Т.ШтрихКодСсылка = null 
			Или (Т.ТекЦена 		<> Т.Цена и Не Т.Цена = 0.01)
			Или Т.фАлкоголь 	<> Т.ТоварфАлкоголь 
			Или Т.Наименование 	<> СокрЛП(Т.ТоварНаименование) 
			Или Т.НаименованиеОригинальное 	<> СокрЛП(Т.НоменклатураНаименованиеОригинальное) 
			Или Т.ДляЦенника 	<> СокрЛП(Т.НоменклатураДляЦенника) 
			Или Т.Состав <> СокрЛП(Т.НоменклатураСостав) 
			Или Т.ИнформацияДляВесов <> СокрЛП(Т.НоменклатураИнформацияДляВесов) 
			Или Т.PLU 			<> СокрЛП(Т.ТоварPLU) 
			Или Т.фВесовой 		<> Т.ТоварЗапросКоличества 
			Или Т.ТоварПометкаУдаления
			Или Т.СтавкаНДС		<> Т.ТоварКатегорияСтавкаНДС
			Или (Т.ГруппаКонтроляПродажи <> Т.ТоварГруппаКонтроляПродажиКод и Т.ГруппаКонтроляПродажи <> 0 ) 
			Или Не Т.ТоварЕстьВПродаже Тогда
			
			ЗаписатьДанныеПоСтрокеТаблицы(Т);
		КонецЕсли;
	КонецЦикла;
	//=========================================================================================	
	
	Если фОшибка = 1 Тогда
		Перейти ~Ошибка;
	КонецЕсли;
	
	ЗафиксироватьТранзакцию();
	
	ТекстЗапроса = "
	|Update Loyality_ext.dbo.ОчередьЗагрузки 
	|	set Результат = 1
	|		, ДатаОбработки = getdate()
	|where 
	|	идСтроки = '"+СтрокаОчереди.идСтроки+"'
	|
	//|commit
	|";
	
	Отказ = Ложь;
	ТекстОшибки = "";
	
	SQL.ВыполнитьЗапрос(Connection, ТекстЗапроса, Отказ, ТекстОшибки);
	Попытка
		ЗаписатьВфайл();	
	Исключение
		ЗарегистрироватьСобытие("Обновление товаров.Ошибка записи файла для резервирования",УровеньЖурналаРегистрации.Ошибка,,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат;;
	
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
		ЗарегистрироватьСобытие("Обновление товаров.Ошибка при загрузке товаров",УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
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
	НоменклатураОбъект = НайтиПоРеквизиту("Справочник.Номенклатура", "КодСУП", СокрЛП(СтрокаТовара.КодСУП), Ложь);
	Если НоменклатураОбъект = Неопределено Тогда
		НоменклатураОбъект = Справочники.Номенклатура.СоздатьЭлемент();
		НоменклатураОбъект.КодСУП = СокрЛП(СтрокаТовара.КодСУП);
	Иначе
		НоменклатураОбъект = НоменклатураОбъект.ПолучитьОбъект();
		Если НоменклатураОбъект.ПометкаУдаления Тогда
			НоменклатураОбъект.УстановитьПометкуУдаления(ложь);
		КонецЕсли;
	КонецЕсли;
	

	Если Не НоменклатураОбъект.Наименование	= СокрЛП(СтрокаТовара.Наименование)
		Или Не НоменклатураОбъект.БазоваяЕдиницаИзмерения = ЕдиницаОбъект.Ссылка
		Или Не НоменклатураОбъект.ГруппаКонтроляПродажи	= ГруппаКонтроля
		Или Не НоменклатураОбъект.фАлкоголь = Число(СтрокаТовара.фАлкоголь)
		Или Не НоменклатураОбъект.Состав = СтрокаТовара.Состав
		Или Не НоменклатураОбъект.ИнформацияДляВесов = СтрокаТовара.ИнформацияДляВесов
		Или Не НоменклатураОбъект.КодДляВесов = СтрокаТовара.PLU 
		Или Не НоменклатураОбъект.ДляЦенника = СтрокаТовара.ДляЦенника
		Или Не НоменклатураОбъект.НаименованиеОригинальное = СтрокаТовара.НаименованиеОригинальное
		Или СтрокаТовара.ТоварСсылка = Null тогда
		
		НоменклатураОбъект.Наименование				= СокрЛП(СтрокаТовара.Наименование);
		НоменклатураОбъект.БазоваяЕдиницаИзмерения 	= ЕдиницаОбъект.Ссылка;
		НоменклатураОбъект.ГруппаКонтроляПродажи	= ГруппаКонтроля;
		НоменклатураОбъект.фАлкоголь 				= Число(СтрокаТовара.фАлкоголь);
		НоменклатураОбъект.Состав					= СтрокаТовара.Состав;
		НоменклатураОбъект.ИнформацияДляВесов		= СтрокаТовара.ИнформацияДляВесов;
		НоменклатураОбъект.КодДляВесов				= СтрокаТовара.PLU;
		НоменклатураОбъект.ДляЦенника				= СтрокаТовара.ДляЦенника;
		НоменклатураОбъект.НаименованиеОригинальное	= СтрокаТовара.НаименованиеОригинальное;
		НоменклатураОбъект.Записать();
	КонецЕсли;
	
	
	Если СтрокаТовара.ТоварСсылка = Null Тогда
		
		// ========= цены номеклатуры 
		ЦеныНоменклатуры = РегистрыСведений.ЦеныНоменклатуры.СоздатьМенеджерЗаписи();
		ЦеныНоменклатуры.Период			= ТекущаяДатаНаСервере();
		ЦеныНоменклатуры.Номенклатура 	= НоменклатураОбъект.Ссылка;
		ЦеныНоменклатуры.ТипЦен 		= Справочники.ТипыЦен.Розничная;
		ЦеныНоменклатуры.Цена			= ?(СтрокаТовара.Цена=0.01, 0, СтрокаТовара.Цена);
		ЦеныНоменклатуры.Записать();
		
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
	ТоварОбъект.Наименование		= СокрЛП(СтрокаТовара.Наименование);
	ТоварОбъект.ЕстьВПродаже 		= Истина;
	ТоварОбъект.ПометкаУдаления		= 0;
	ТоварОбъект.ВариантПечати		= 248; //товар,единица,цена,сумма
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
	//:ТоварОбъект = Справочники.Товары.СоздатьЭлемент();
	ТоварОбъект.ВариантНаличияВПродаже = Перечисления.ВариантыНаличияВПродаже.Простой;
	ТоварОбъект.ЕстьВПродаже = Истина;
	ТоварОбъект.ОбменДанными.Загрузка = Истина;	
	ТоварОбъект.Записать();
	
	// ==== ШтрихКодыТоваров =============
	
	Если Не ПустаяСтрока(СтрокаТовара.ШтрихКод) Тогда
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	ШтрихКоды.Ссылка
		|ИЗ
		|	Справочник.ШтрихКоды КАК ШтрихКоды
		|ГДЕ
		|	ШтрихКоды.ШтрихКод = &ШтрихКод
		|	И ШтрихКоды.Товар = &Товар
		|	И Не ШтрихКоды.ПометкаУдаления");
		Запрос.УстановитьПараметр("ШтрихКод", СокрЛП(СтрокаТовара.ШтрихКод));
		Запрос.УстановитьПараметр("Товар", ТоварОбъект.Ссылка);
		
		Рез = Запрос.Выполнить();
		Если Рез.Пустой() Тогда
			// добавляем
			ШтрихКодыОбъект = Справочники.ШтрихКоды.СоздатьЭлемент();
			ШтрихКодыОбъект.ШтрихКод = СокрЛП(СтрокаТовара.ШтрихКод);
			ШтрихКодыОбъект.Товар = ТоварОбъект.Ссылка;
			ШтрихКодыОбъект.ОбменДанными.Загрузка = Истина;		 	
			ШтрихКодыОбъект.PLU	= СтрокаТовара.PLU;
			ШтрихКодыОбъект.Записать();
		КонецЕсли;
	КонецЕсли;
	
	// ========= цены номеклатуры 
	ЦеныНоменклатуры = РегистрыСведений.ЦеныНоменклатуры.СоздатьМенеджерЗаписи();
	ЦеныНоменклатуры.Период			= ТекущаяДатаНаСервере();
	ЦеныНоменклатуры.Номенклатура 	= НоменклатураОбъект.Ссылка;
	ЦеныНоменклатуры.ТипЦен 		= Справочники.ТипыЦен.Розничная;
	ЦеныНоменклатуры.Цена			= ?(СтрокаТовара.Цена=0.01, 0, СтрокаТовара.Цена);
	ЦеныНоменклатуры.Записать();
	
	
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
	|	and Результат <= 0 -- берем Не обработанные и ошибки
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
	|ГДЕ " + ИмяРеквизита + " = &ЗначениеРеквизита " + ?(ВключаяПомеченные, "И Не ПометкаУдаления","") + "
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
