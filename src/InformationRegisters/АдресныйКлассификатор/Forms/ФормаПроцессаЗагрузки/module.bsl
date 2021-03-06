﻿Перем КодировкаWindows;
Перем Формат2003;
Перем СтрокаДопустимыхКодов;
Перем АдресныеСведения;
Перем АдресныеСведенияИБ;
Перем ИспользованныеКоды;
Перем АльтернативныеНазвания;



//  Процедура устанавливает заданную кодировку для файла XBASE
//
// Параметры:
//  ФайлБД - Объект с отрытым файлом XBASE.
//
Процедура УстановитьКодировку(ФайлБД)

	Если КодировкаWindows Тогда
		ФайлБД.Кодировка = КодировкаXBase.ANSI;
	Иначе
		ФайлБД.Кодировка = КодировкаXBase.OEM;
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ЗАГРУЗКИ АДРЕСНОЙ ИНФОРМАЦИИ

// Процедура загружает в справочник адресный классификатор один адресный 
// элемент по переданным параметрам.
//
// Параметры:
//  КодЭлемента - значение кода для адресного элемента.
//  Наименование - значение наименования для адресного элемента.
//  Сокращение - значение сокращения для адресного элемента.
//  Индекс - значение индекса для адресного элемента.
//  МножительСдвига - множитель для окончательного сдвига кода ( см. вычисление выражения).
//  ДелительСдвига - делитель для первичного сдвига кода ( см. вычисление выражения).
//
Процедура ЗагрузитьАдресныйЭлемент(Знач КодЭлемента, Знач Наименование, Знач Сокращение, Знач Индекс, Знач МножительСдвига, Знач ДелительСдвига = 1)

	Если СокрЛП(Строка(КодЭлемента)) = "" Тогда
		Возврат;
	КонецЕсли;

	Если СокрЛП(Строка(Наименование)) = "" Тогда
		Возврат;
	КонецЕсли;

	Если СокрЛП(Строка(Сокращение)) = "" Тогда
		Возврат;
	КонецЕсли;

	Наименование = СокрЛП(Наименование);
	Сокращение   = СокрЛП(Сокращение);
	
	Если (Формат2003) И (СтрДлина(КодЭлемента) < 19) Тогда
		Если Прав(КодЭлемента, 2) <> "00" Тогда
			СтрокаАльтернативныхНазваний = АльтернативныеНазвания.Добавить();
			КодЭлемента  = Число(СтрЗаменить(КодЭлемента, " ", "0"));
			СтрокаАльтернативныхНазваний.Код = Цел(КодЭлемента / ДелительСдвига) * МножительСдвига * 100 + КодЭлемента%ДелительСдвига;
			СтрокаАльтернативныхНазваний.Наименование = Наименование;
			СтрокаАльтернативныхНазваний.Сокращение = Сокращение;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	КодЭлемента  = Число(СтрЗаменить(КодЭлемента, " ", "0"));
	КодЭлемента = Цел(КодЭлемента / ДелительСдвига) * МножительСдвига * 100 + КодЭлемента%ДелительСдвига;

	КодРегиона = Цел(КодЭлемента / киМаскаРегиона());
	
	КодРайона            = Цел(КодЭлемента / киМаскаРайона()) % 1000;
	КодГорода            = Цел(КодЭлемента / киМаскаГорода()) % 1000;
	КодНаселенногоПункта = Цел(КодЭлемента / киМаскаНасПункта()) % 1000;
	КодУлицы             = Цел(КодЭлемента / киМаскаУлицы())% 10000;

	Если НЕ ЗначениеЗаполнено(Индекс) Тогда
		Индекс = "";
	Иначе
		Индекс = СтрЗаменить(Формат(Число(Индекс),"ЧЦ=6,ЧВН="), " " ,"");
		Индекс = СтрЗаменить(Индекс, Символ(160) ,"");
	КонецЕсли;
	
	
	Если (Врег(Сокращение) = "ДОМ") И (Цел(КодЭлемента / киМаскаДома())% 10000 = 0) Тогда
		// дом с нулевым кодом дома - когда загружаем классификатор улиц формата 2002 года
		ТексЗапросаПоискДома = "ВЫБРАТЬ
		                       |	АдресныйКлассификатор.Код
		                       |ИЗ
		                       |	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
		                       |
		                       |ГДЕ
		                       |	АдресныйКлассификатор.КодРегионаВКоде = &КодРегионаВКоде И
		                       |	АдресныйКлассификатор.КодРайонаВКоде = &КодРайонаВКоде И
		                       |	АдресныйКлассификатор.КодГородаВКоде = &КодГородаВКоде И
		                       |	АдресныйКлассификатор.КодНаселенногоПунктаВКоде = &КодНаселенногоПунктаВКоде И
		                       |	АдресныйКлассификатор.КодУлицыВКоде = &КодУлицыВКоде И
		                       |	АдресныйКлассификатор.Наименование = &Наименование И
		                       |	АдресныйКлассификатор.ТипАдресногоЭлемента = 6";
		
		ЗапросПоискДома = Новый Запрос(ТексЗапросаПоискДома);
		
		ЗапросПоискДома.УстановитьПараметр("КодРегионаВКоде", КодРегиона);
		ЗапросПоискДома.УстановитьПараметр("КодРайонаВКоде", КодРайона);
		ЗапросПоискДома.УстановитьПараметр("КодГородаВКоде", КодГорода);
		ЗапросПоискДома.УстановитьПараметр("КодНаселенногоПунктаВКоде", КодНаселенногоПункта);
		ЗапросПоискДома.УстановитьПараметр("КодУлицыВКоде", КодУлицы);
		ЗапросПоискДома.УстановитьПараметр("Наименование", Наименование);
		
		Выборка = ЗапросПоискДома.Выполнить().Выбрать();

		Если Выборка.Следующий() Тогда
			Возврат;
		КонецЕсли;
		
		ДобавилиДом = Ложь;
		
		Для Сч = 1 По 999 Цикл
			КодДома = КодРегиона * киМаскаРегиона()
			        + КодРайона * киМаскаРайона()
			        + КодГорода * киМаскаГорода()
			        + КодНаселенногоПункта * киМаскаНасПункта()
			        + КодУлицы * киМаскаУлицы()
			        + Сч * киМаскаДома();
			
			Если АдресныеСведенияИБ[КодДома] = Истина Тогда
				Продолжить;
			КонецЕсли;
			
			Если ИспользованныеКоды[КодДома] = Истина Тогда  // и уже в добавленных записях
				Продолжить;
			КонецЕсли;
			
			ДобавилиДом = Истина;
			КодЭлемента = КодДома;
			Прервать;
			
		КонецЦикла;
		
		Если НЕ ДобавилиДом Тогда
			Сообщить("Не удалось добавить адресный элемент """ + КодЭлемента + "   " + Наименование + "   " + Сокращение, СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ИспользованныеКоды[КодЭлемента] = Истина Тогда  //уже добавили элемент с таким кодом
		Сообщить("Не удалось добавить адресную информацию о """ + Наименование + " " + Сокращение + " (" + КодЭлемента + ")""", СтатусСообщения.Внимание);
		Возврат;
	КонецЕсли;

	ИспользованныеКоды.Вставить(КодЭлемента, Истина);
	
	ЗаписьАдреса = АдресныеСведения.Добавить();
	ЗаписьАдреса.Код = КодЭлемента;

	ЗаписьАдреса.Наименование = Наименование;
	ЗаписьАдреса.АльтернативныеНазвания = "";
	ЗаписьАдреса.Сокращение = Сокращение;
	ЗаписьАдреса.Индекс = Индекс;
	ЗаписьАдреса.ТипАдресногоЭлемента = киПолучитьТипАдресногоЭлемента(КодЭлемента);
	
	ЗаписьАдреса.КодРегионаВКоде           = КодРегиона;
	ЗаписьАдреса.КодРайонаВКоде            = КодРайона;
	ЗаписьАдреса.КодГородаВКоде            = КодГорода;
	ЗаписьАдреса.КодНаселенногоПунктаВКоде = КодНаселенногоПункта;
	ЗаписьАдреса.КодУлицыВКоде             = КодУлицы;
	
	Если АдресныеСведенияИБ[КодЭлемента] = Истина Тогда
		 АдресныеСведенияИБ[КодЭлемента] = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Процедура загружает адресные класиификаторы из файлов.
//
// Параметры:
//  ФайлАдресногоКлассификатора - имя файла адресного классификатора.
//  ФайлКлассификатораУлиц - имя файла классификатора улиц.
//  ФайлКлассификатораДомов - имя файла классификатора домов.
//  ФайлКлассификатораСокращений - имя файла классификатора сокращений.
//  СписокРегионов - список значений с регионами, адресную информацию по которым 
//                   необходимо обновить (другие не обрабатываются).
//  КодировкаБД - кодировка баз XBASE.
//  ЗагрузитьВФормате2003 - вариант формата классификатора - новый классификатор с 2003 года.
//
Процедура ЗагрузитьКлассификаторы(ФайлАдресногоКлассификатора, ФайлКлассификатораУлиц, ФайлКлассификатораДомов, ФайлКлассификатораСокращений, СписокРегионов, КодировкаБД, ЗагрузитьВФормате2003) Экспорт

	КодировкаWindows = КодировкаБД;
	Формат2003 = ЗагрузитьВФормате2003;
	
	СтрокаДопустимыхКодов = "_";
	
	Для каждого Элемент Из СписокРегионов Цикл
		Если Элемент.Пометка Тогда
			
			ИспользованныеКоды = Новый Соответствие();
			
			АльтернативныеНазвания  = Новый ТаблицаЗначений();
			АльтернативныеНазвания.Колонки.Добавить("Код");
			АльтернативныеНазвания.Колонки.Добавить("Наименование");
			АльтернативныеНазвания.Колонки.Добавить("Сокращение");

			АдресныеСведения = Новый ТаблицаЗначений();
			АдресныеСведения.Колонки.Добавить("Код");
			АдресныеСведения.Колонки.Добавить("КодРегионаВКоде");
			АдресныеСведения.Колонки.Добавить("Наименование");
			АдресныеСведения.Колонки.Добавить("АльтернативныеНазвания");
			АдресныеСведения.Колонки.Добавить("Сокращение");
			АдресныеСведения.Колонки.Добавить("Индекс");
			АдресныеСведения.Колонки.Добавить("ТипАдресногоЭлемента");
			АдресныеСведения.Колонки.Добавить("КодРайонаВКоде");
			АдресныеСведения.Колонки.Добавить("КодГородаВКоде");
			АдресныеСведения.Колонки.Добавить("КодНаселенногоПунктаВКоде");
			АдресныеСведения.Колонки.Добавить("КодУлицыВКоде");
			

			ЭлементыФормы.НадписьПояснениеИндикатораЗагрузки.Заголовок = "Позиция в файле классификатора:";

			ТексЗапроса = "ВЫБРАТЬ
			              |	АдресныйКлассификатор.Код,
			              |	АдресныйКлассификатор.КодРегионаВКоде,
			              |	АдресныйКлассификатор.Наименование,
			              |	АдресныйКлассификатор.АльтернативныеНазвания,
			              |	АдресныйКлассификатор.Сокращение,
			              |	АдресныйКлассификатор.Индекс,
			              |	АдресныйКлассификатор.ТипАдресногоЭлемента,
			              |	АдресныйКлассификатор.КодРайонаВКоде,
			              |	АдресныйКлассификатор.КодГородаВКоде,
			              |	АдресныйКлассификатор.КодНаселенногоПунктаВКоде,
			              |	АдресныйКлассификатор.КодУлицыВКоде
			              |ИЗ
			              |	РегистрСведений.АдресныйКлассификатор КАК АдресныйКлассификатор
			              |
			              |ГДЕ
			              |	АдресныйКлассификатор.КодРегионаВКоде = &КодРегионаВКоде";
			
			Запрос = Новый Запрос(ТексЗапроса);
			Запрос.УстановитьПараметр("КодРегионаВКоде", Элемент.Значение);
			
			РезультатЗапросаСведений = Запрос.Выполнить();
			МассивСведений = РезультатЗапросаСведений.Выгрузить().ВыгрузитьКолонку("Код");
			АдресныеСведенияИБ = Новый Соответствие();
			Для Сч = 0 По МассивСведений.ВГраница() Цикл
				АдресныеСведенияИБ.Вставить(МассивСведений[Сч], Истина);
			КонецЦикла;

			ВыражениеДляИндекса = "SUBSTR(CODE,1,2)='" + Формат(Элемент.Значение, "ЧЦ=2;ЧВН=") + "'";
			КлассификаторАдресов = Новый XBase(ФайлАдресногоКлассификатора);

			Если КлассификаторАдресов.Открыта() Тогда

				ЭлементыФормы.Комментарий.Заголовок = "Загружается адресный классификатор из файла " + ФайлАдресногоКлассификатора;
				ЭлементыФормы.ИндикаторЗагрузки.МаксимальноеЗначение = КлассификаторАдресов.КоличествоЗаписей();

				// проверяем структуру адресных полей
				Если (КлассификаторАдресов.поля.Найти("CODE") = Неопределено)
				 ИЛИ (КлассификаторАдресов.поля.Найти("NAME") = Неопределено)
				 ИЛИ (КлассификаторАдресов.поля.Найти("SOCR") = Неопределено)
				 ИЛИ (КлассификаторАдресов.поля.Найти("INDEX") = Неопределено) Тогда
					Сообщить("Классификатор адресов неправильной структуры. Не загружен!", СтатусСообщения.Важное);

				Иначе 

					КлассификаторАдресов.индексы.Добавить("MAIN","RECNO()", , , ВыражениеДляИндекса);
					КлассификаторАдресов.СоздатьИндексныйФайл(КаталогВременныхФайлов() + "mainkldr.cdx");
					КлассификаторАдресов.ЗакрытьФайл();
					
					КлассификаторАдресов = Новый XBase(ФайлАдресногоКлассификатора, КаталогВременныхФайлов() + "mainkldr.cdx", Истина);
					КлассификаторАдресов.ТекущийИндекс = КлассификаторАдресов.индексы.Найти("MAIN");
						
					УстановитьКодировку(КлассификаторАдресов);
					
					// если в стурктуре есть необходимые поля - загружаем
					КлассификаторАдресов.Первая();
					
					Если НЕ КлассификаторАдресов.ВКонце() Тогда
					
						ЗагрузитьАдресныйЭлемент(КлассификаторАдресов.CODE,
						                         КлассификаторАдресов.NAME,
						                         КлассификаторАдресов.SOCR,
						                         КлассификаторАдресов.INDEX,
						                         1000000000000, ?(Формат2003, 100, 1));

						Пока КлассификаторАдресов.Следующая() Цикл
							ЗагрузитьАдресныйЭлемент(КлассификаторАдресов.CODE,
							                         КлассификаторАдресов.NAME,
							                         КлассификаторАдресов.SOCR,
							                         КлассификаторАдресов.INDEX,
							                         1000000000000, ?(Формат2003, 100, 1));
							ОбработкаПрерыванияПользователя();
							ИндикаторЗагрузки = КлассификаторАдресов.НомерЗаписи();
						КонецЦикла;
				
					КонецЕсли;
				
					КлассификаторАдресов.ЗакрытьФайл();
				
				КонецЕсли;
				
			КонецЕсли;

			КлассификаторУлиц = Новый XBase(ФайлКлассификатораУлиц);

			Если КлассификаторУлиц.Открыта() Тогда

				ЭлементыФормы.Комментарий.Заголовок = "Загружается классификатор улиц из файла " + ФайлКлассификатораУлиц;
				ЭлементыФормы.ИндикаторЗагрузки.МаксимальноеЗначение = КлассификаторУлиц.КоличествоЗаписей();

				// проверяем структуру адресных полей
				Если (КлассификаторУлиц.поля.Найти("CODE") = Неопределено)
				 ИЛИ (КлассификаторУлиц.поля.Найти("NAME") = Неопределено)
				 ИЛИ (КлассификаторУлиц.поля.Найти("SOCR") = Неопределено)
				 ИЛИ (КлассификаторУлиц.поля.Найти("INDEX") = Неопределено) Тогда
					Сообщить("Классификатор улиц неправильной структуры. Не загружен!", СтатусСообщения.Важное);

				Иначе
					
					КлассификаторУлиц.индексы.Добавить("MAIN","RECNO()", , , ВыражениеДляИндекса);
					КлассификаторУлиц.СоздатьИндексныйФайл(КаталогВременныхФайлов() + "mainkldr.cdx");
					КлассификаторУлиц.ЗакрытьФайл();
					
					КлассификаторУлиц = Новый XBase(ФайлКлассификатораУлиц, КаталогВременныхФайлов() + "mainkldr.cdx", Истина);
					КлассификаторУлиц.ТекущийИндекс = КлассификаторУлиц.индексы.Найти("MAIN");

					УстановитьКодировку(КлассификаторУлиц);

					// если в стурктуре есть необходимые поля - загружаем
					КлассификаторУлиц.Первая();
					Если НЕ КлассификаторУлиц.ВКонце() Тогда
						ЗагрузитьАдресныйЭлемент(КлассификаторУлиц.CODE,
						                         КлассификаторУлиц.NAME,
						                         КлассификаторУлиц.SOCR,
						                         КлассификаторУлиц.INDEX,
						                         100000000, ?(Формат2003, 100, 1));

						Пока КлассификаторУлиц.Следующая() Цикл
							
							// проверка на загрузку дома
							КодЭлемента = КлассификаторУлиц.CODE;
							
							ЗагрузитьАдресныйЭлемент(КодЭлемента,
							                         КлассификаторУлиц.NAME,
							                         КлассификаторУлиц.SOCR,
							                         КлассификаторУлиц.INDEX,
							                         100000000, ?(Формат2003, 100, 1));
							ОбработкаПрерыванияПользователя();
							ИндикаторЗагрузки = КлассификаторУлиц.НомерЗаписи();
						КонецЦикла;
						
					КонецЕсли;
					
					КлассификаторУлиц.ЗакрытьФайл();
					
				КонецЕсли;
				
			КонецЕсли;
			
 			Если Формат2003 Тогда
				
				КлассификаторДомов = Новый XBase(ФайлКлассификатораДомов);

				Если КлассификаторДомов.Открыта() Тогда

					ЭлементыФормы.Комментарий.Заголовок = "Загружается классификатор домов из файла " + ФайлКлассификатораДомов;
					ЭлементыФормы.ИндикаторЗагрузки.МаксимальноеЗначение = КлассификаторДомов.КоличествоЗаписей();

					// проверяем структуру адресных полей
					Если (КлассификаторДомов.поля.Найти("CODE") = Неопределено)
					 ИЛИ (КлассификаторДомов.поля.Найти("NAME") = Неопределено)
					 ИЛИ (КлассификаторДомов.поля.Найти("SOCR") = Неопределено)
					 ИЛИ (КлассификаторДомов.поля.Найти("KORP") = Неопределено)
					 ИЛИ (КлассификаторДомов.поля.Найти("INDEX") = Неопределено) Тогда
						Сообщить("Классификатор домов неправильной структуры. Не загружен!", СтатусСообщения.Важное);

					Иначе 
					
						КлассификаторДомов.индексы.Добавить("MAIN","RECNO()", , , ВыражениеДляИндекса);
						КлассификаторДомов.СоздатьИндексныйФайл(КаталогВременныхФайлов() + "mainkldr.cdx");
						КлассификаторДомов.ЗакрытьФайл();
						
						КлассификаторДомов = Новый XBase(ФайлКлассификатораДомов, КаталогВременныхФайлов() + "mainkldr.cdx", Истина);
						КлассификаторДомов.ТекущийИндекс = КлассификаторДомов.индексы.Найти("MAIN");

						УстановитьКодировку(КлассификаторДомов);

						КлассификаторДомов.Первая();
						Если НЕ КлассификаторДомов.ВКонце() Тогда
							Дом = КлассификаторДомов.NAME;
							Корпус = КлассификаторДомов.KORP;
							ЗагрузитьАдресныйЭлемент(КлассификаторДомов.CODE,
							                         СокрЛП("" + Дом) + ?(ПустаяСтрока(СокрЛП("" + Корпус)), "", "К" + СокрЛП("" + Корпус)),
							                         КлассификаторДомов.SOCR,
							                         КлассификаторДомов.INDEX,
							                         10000);

							Пока КлассификаторДомов.Следующая() Цикл
								Дом = КлассификаторДомов.NAME;
								Корпус = КлассификаторДомов.KORP;
								ЗагрузитьАдресныйЭлемент(КлассификаторДомов.CODE,
								                         СокрЛП("" + Дом) + ?(ПустаяСтрока(СокрЛП("" + Корпус)), "", "К" + СокрЛП("" + Корпус)),
								                         КлассификаторДомов.SOCR,
								                         КлассификаторДомов.INDEX,
								                         10000);
								ОбработкаПрерыванияПользователя();
								ИндикаторЗагрузки = КлассификаторДомов.НомерЗаписи();
							КонецЦикла;
							
						КонецЕсли;
						
						КлассификаторДомов.ЗакрытьФайл();
						
					КонецЕсли;

				КонецЕсли;
			КонецЕсли;

			ЭлементыФормы.Комментарий.Заголовок = "Подготавливаем данные к записи по региону " + Символы.ПС + СписокРегионов.НайтиПоЗначению(Элемент.Значение).Представление;
			ВыборкаЗапроса = РезультатЗапросаСведений.Выбрать();
			Для Сч = 0 По МассивСведений.ВГраница() Цикл
				Если АдресныеСведенияИБ[МассивСведений[Сч]] = Истина Тогда
					Если ВыборкаЗапроса.НайтиСледующий(МассивСведений[Сч], "Код") Тогда
						ЗаписьАдреса = АдресныеСведения.Добавить();
						
						ЗаписьАдреса.Код = ВыборкаЗапроса.Код;
						
						ЗаписьАдреса.Наименование              = ВыборкаЗапроса.Наименование;
						ЗаписьАдреса.АльтернативныеНазвания    = ВыборкаЗапроса.АльтернативныеНазвания;
						ЗаписьАдреса.Сокращение                = ВыборкаЗапроса.Сокращение;
						ЗаписьАдреса.Индекс                    = ВыборкаЗапроса.Индекс;
						ЗаписьАдреса.ТипАдресногоЭлемента      = ВыборкаЗапроса.ТипАдресногоЭлемента;
						
						ЗаписьАдреса.КодРегионаВКоде           = ВыборкаЗапроса.КодРегионаВКоде;
						ЗаписьАдреса.КодРайонаВКоде            = ВыборкаЗапроса.КодРайонаВКоде;
						ЗаписьАдреса.КодГородаВКоде            = ВыборкаЗапроса.КодГородаВКоде;
						ЗаписьАдреса.КодНаселенногоПунктаВКоде = ВыборкаЗапроса.КодНаселенногоПунктаВКоде;
						ЗаписьАдреса.КодУлицыВКоде             = ВыборкаЗапроса.КодУлицыВКоде;
						
					КонецЕсли;
				КонецЕсли;
			КонецЦикла;
			
			Для Каждого СтрокаАльтернативногоНазвания Из АльтернативныеНазвания Цикл
				ЗаписьАдреса = АдресныеСведения.Найти(Цел(Число(СтрокаАльтернативногоНазвания.Код) / 100) * 100, "Код");
				Если ЗаписьАдреса <> Неопределено Тогда
					ЗаписьАдреса.АльтернативныеНазвания = ЗаписьАдреса.АльтернативныеНазвания + СтрокаАльтернативногоНазвания.Наименование + " " + СтрокаАльтернативногоНазвания.Сокращение + ",";
				КонецЕсли;
			КонецЦикла;
			
			// очищаем регион
			НаборАдресныхСведений = РегистрыСведений.АдресныйКлассификатор.СоздатьНаборЗаписей();
			НаборАдресныхСведений.Отбор.КодРегионаВКоде.Использование = Истина;
			НаборАдресныхСведений.Отбор.КодРегионаВКоде.Значение = Элемент.Значение;
			НаборАдресныхСведений.Записать(Истина);

			// заносим новые данные порциями
			ЭлементыФормы.ИндикаторЗагрузки.МаксимальноеЗначение = АдресныеСведения.Количество();
			ЭлементыФормы.Комментарий.Заголовок = "Заносим данные в информационную базу по региону " + Символы.ПС + СписокРегионов.НайтиПоЗначению(Элемент.Значение).Представление;
			ЭлементыФормы.НадписьПояснениеИндикатораЗагрузки.Заголовок = "Записано данных:";
			СчетчикЗаписей = 0;
			ИндикаторЗагрузки = 0;
			
			Для каждого АдреснаяЗапись из АдресныеСведения Цикл
				Если СчетчикЗаписей = 0 Тогда
					НаборАдресныхСведений = РегистрыСведений.АдресныйКлассификатор.СоздатьНаборЗаписей();
					НаборАдресныхСведений.Отбор.КодРегионаВКоде.Использование = Истина;
					НаборАдресныхСведений.Отбор.КодРегионаВКоде.Значение = Элемент.Значение;
				КонецЕсли;
				
				ЗаписьАдреса = НаборАдресныхСведений.Добавить();
				
				ЗаписьАдреса.Код = АдреснаяЗапись.Код;
				
				ЗаписьАдреса.Наименование              = АдреснаяЗапись.Наименование;
				ЗаписьАдреса.АльтернативныеНазвания    = АдреснаяЗапись.АльтернативныеНазвания;
				ЗаписьАдреса.Сокращение                = АдреснаяЗапись.Сокращение;
				ЗаписьАдреса.Индекс                    = АдреснаяЗапись.Индекс;
				ЗаписьАдреса.ТипАдресногоЭлемента      = АдреснаяЗапись.ТипАдресногоЭлемента;
				
				ЗаписьАдреса.КодРегионаВКоде           = АдреснаяЗапись.КодРегионаВКоде;
				ЗаписьАдреса.КодРайонаВКоде            = АдреснаяЗапись.КодРайонаВКоде;
				ЗаписьАдреса.КодГородаВКоде            = АдреснаяЗапись.КодГородаВКоде;
				ЗаписьАдреса.КодНаселенногоПунктаВКоде = АдреснаяЗапись.КодНаселенногоПунктаВКоде;
				ЗаписьАдреса.КодУлицыВКоде             = АдреснаяЗапись.КодУлицыВКоде;
				
				Если СчетчикЗаписей >= 170 Тогда
					НаборАдресныхСведений.Записать(Ложь);
					СчетчикЗаписей = 0;
				Иначе
					СчетчикЗаписей = СчетчикЗаписей + 1;
				КонецЕсли;
				ИндикаторЗагрузки = ИндикаторЗагрузки + 1;
				
			КонецЦикла;
			
			Если СчетчикЗаписей > 0 Тогда
				НаборАдресныхСведений.Записать(Ложь);
			КонецЕсли;

			
		КонецЕсли;
	КонецЦикла;
	
	КлассификаторСокращений = Новый XBase(ФайлКлассификатораСокращений,,Истина);
	
	Если КлассификаторСокращений.Открыта() Тогда
		
		УстановитьКодировку(КлассификаторСокращений);
		
		СправочникКлассификатора = Справочники.АдресныеСокращения;
		
		// проверяем структуру адресных полей
		Если (КлассификаторСокращений.поля.Найти("KOD_T_ST") = Неопределено)
		 ИЛИ (КлассификаторСокращений.поля.Найти("SOCRNAME") = Неопределено)
		 ИЛИ (КлассификаторСокращений.поля.Найти("SCNAME") = Неопределено)
		 ИЛИ (КлассификаторСокращений.поля.Найти("LEVEL") = Неопределено) Тогда
			Сообщить("Классификатор сокращений неправильной структуры. Не загружен!", СтатусСообщения.Важное);
			
		Иначе
			// если в структуре есть необходимые поля - загружаем
			КлассификаторСокращений.Первая();
			Если НЕ КлассификаторСокращений.ВКонце() Тогда
				ЭлементыФормы.Комментарий.Заголовок = "Загружается классификатор сокращений из файла " + ФайлКлассификатораСокращений;
				ЭлементыФормы.ИндикаторЗагрузки.МаксимальноеЗначение = КлассификаторСокращений.КоличествоЗаписей();
				
				Фасет = Число(СокрЛП(КлассификаторСокращений.KOD_T_ST));
				ОбъектАдреса = СправочникКлассификатора.НайтиПоКоду(Фасет);
				Если НЕ ЗначениеЗаполнено(ОбъектАдреса) Тогда
					ОбъектАдреса = СправочникКлассификатора.СоздатьЭлемент();
					ОбъектАдреса.Код = Фасет;
				Иначе
					ОбъектАдреса = ОбъектАдреса.ПолучитьОбъект()
				КонецЕсли;
				
				ОбъектАдреса.Наименование = СокрЛП(КлассификаторСокращений.SOCRNAME);
				ОбъектАдреса.Сокращение = СокрЛП(КлассификаторСокращений.SCNAME);
				ОбъектАдреса.Уровень = Число(КлассификаторСокращений.LEVEL);
				
				ОбъектАдреса.Записать();
				
				Пока КлассификаторСокращений.Следующая() Цикл
					ОбработкаПрерыванияПользователя();
					ИндикаторЗагрузки = КлассификаторСокращений.НомерЗаписи();
					Фасет = Число(СокрЛП(КлассификаторСокращений.KOD_T_ST));
					ОбъектАдреса = СправочникКлассификатора.НайтиПоКоду(Фасет);
					Если НЕ ЗначениеЗаполнено(ОбъектАдреса) Тогда
						ОбъектАдреса = СправочникКлассификатора.СоздатьЭлемент();
						ОбъектАдреса.Код = Фасет;
					Иначе
						ОбъектАдреса = ОбъектАдреса.ПолучитьОбъект()
					КонецЕсли;
					
					ОбъектАдреса.Наименование = СокрЛП(КлассификаторСокращений.SOCRNAME);
					ОбъектАдреса.Сокращение = СокрЛП(КлассификаторСокращений.SCNAME);
					ОбъектАдреса.Уровень = Число(КлассификаторСокращений.LEVEL);
					
					ОбъектАдреса.Записать();
					
				КонецЦикла;
				
			КонецЕсли;
			
			КлассификаторСокращений.ЗакрытьФайл();
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Процедура загружает регионы из внутренних таблиц.
//
// Параметры:
//  нет
//
Процедура ЗагрузитьРегионы() Экспорт

	АдресныеСведения = РегистрыСведений.АдресныйКлассификатор.СоздатьНаборЗаписей();
	КлассификаторАдресов = РегистрыСведений.АдресныйКлассификатор.ПолучитьМакет("ТаблицаРегионов");
	
	ВсегоЗаписей = КлассификаторАдресов.ВысотаТаблицы - 1;
	ЭлементыФормы.Комментарий.Заголовок = "Загружаются регионы из внутренних таблиц.";

	Для Сч = 2 По КлассификаторАдресов.ВысотаТаблицы Цикл

		ИндикаторЗагрузки = (Сч - 1) * 100 / ВсегоЗаписей;

		ЗаписьАдреса = РегистрыСведений.АдресныйКлассификатор.СоздатьМенеджерЗаписи();
		
		ЗаписьАдреса.Код = Число(КлассификаторАдресов.Область(Сч, 1, Сч, 1).Текст);
		КодРегиона = Цел(ЗаписьАдреса.Код / киМаскаРегиона());
		
		ЗаписьАдреса.Наименование = СокрЛП(КлассификаторАдресов.Область(Сч, 2, Сч, 2).Текст);
		ЗаписьАдреса.Сокращение   = СокрЛП(КлассификаторАдресов.Область(Сч, 3, Сч, 3).Текст);
		ЗаписьАдреса.Индекс       = СокрЛП(КлассификаторАдресов.Область(Сч, 4, Сч, 4).Текст);
		ЗаписьАдреса.ТипАдресногоЭлемента = 1;
		
		ЗаписьАдреса.КодРегионаВКоде           = КодРегиона;
		ЗаписьАдреса.КодРайонаВКоде            = Цел(ЗаписьАдреса.Код / киМаскаРайона()) % 1000;
		ЗаписьАдреса.КодГородаВКоде            = Цел(ЗаписьАдреса.Код / киМаскаГорода()) % 1000;
		ЗаписьАдреса.КодНаселенногоПунктаВКоде = Цел(ЗаписьАдреса.Код / киМаскаНасПункта()) % 1000;
		ЗаписьАдреса.КодУлицыВКоде             = Цел(ЗаписьАдреса.Код / киМаскаУлицы())% 10000;
		
		ЗаписьАдреса.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

СтрокаДопустимыхКодов ="";
