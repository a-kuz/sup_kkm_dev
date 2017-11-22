﻿//ирПортативный Перем ирПлатформа Экспорт; // Эта переменная нужна только здесь

//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

#Если Не ТонкийКлиент И Не ВебКлиент Тогда

Функция Получить() Экспорт 
	
	// Не следует использовать для хранения таких данных, переинициализация которых автоматически невозможна или приведет к ошибкам
	
	//#Если Клиент Или ВнешнееСоединение Или Не Сервер Тогда
		Попытка
			ирПлатформа = Вычислить("ирПлатформа");
		Исключение
		КонецПопытки;
		Если ирПлатформа = Неопределено Тогда
			ирПлатформа = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирПлатформа");
			#Если Сервер И Не Сервер Тогда
			    ирПлатформа = Обработки.ирПлатформа.Создать();
			#КонецЕсли
		КонецЕсли; 
		Возврат ирПлатформа;
	// В 8.3 это уже не работает. http://partners.v8.1c.ru/forum/thread.jsp?id=1058206#1058206
	//#Иначе
	//	ИмяПараметраСеанса = "ирКэш";
	//	Попытка
	//		НадоИнициализировать = ПараметрыСеанса[ИмяПараметраСеанса] = Неопределено;
	//	Исключение
	//		НадоИнициализировать = Истина;
	//	КонецПопытки;
	//	Если Не НадоИнициализировать Тогда
	//		Кэш = ПолучитьИзВременногоХранилища(ПараметрыСеанса[ИмяПараметраСеанса]);
	//	КонецЕсли; 
	//	Если ТипЗнч(Кэш) <> Тип("Структура") Тогда
	//		Кэш = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработкп.ирПлатформа");
	//		//ПараметрыСеанса[ИмяПараметраСеанса] = "1";
	//		ПараметрыСеанса[ИмяПараметраСеанса] = ПоместитьВоВременноеХранилище(Кэш, Новый УникальныйИдентификатор);
	//	КонецЕсли;
	//	Возврат Кэш;
	//#КонецЕсли 
	
КонецФункции // Получить()

Функция ИмяПродукта() Экспорт 
	
	Возврат "ИнструментыРазработчикаTormozit";
	
КонецФункции

Функция КомпоновщикТаблицыМетаданныхЛкс(Знач ПолноеИмяМД, ВызыватьИсключениеПриОтсутствииПрав = Истина, ИндексПараметраПериодичность = Неопределено,
	ВыражениеПараметраПериодичность = "", ИменаВместоПредставлений = Ложь) Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("КомпоновщикТаблицыМетаданныхЛкс");
		КлючНаборПараметров = "" + ПолноеИмяМД + ";" + ВызыватьИсключениеПриОтсутствииПрав + ";" + ИндексПараметраПериодичность + ";" + ВыражениеПараметраПериодичность
			+ ";" + ИменаВместоПредставлений;
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	СхемаКомпоновкиДанных = ирОбщий.ПолучитьСхемуКомпоновкиПоОбъектуМетаданныхЛкс(ПолноеИмяМД,, Ложь,, ИндексПараметраПериодичность, ВыражениеПараметраПериодичность,
		ИменаВместоПредставлений);
	#Если Сервер И Не Сервер Тогда
	    СхемаКомпоновкиДанных = Новый СхемаКомпоновкиДанных;
	#КонецЕсли
	Попытка
		ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
	Исключение
		// Антибаг платформы 8.2.18
		// Ошибка при вызове конструктора (ИсточникДоступныхНастроекКомпоновкиДанных)
		//  ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных);
		//по причине:
		//Ошибка получения информации набора данных
		//по причине:
		//Ошибка в запросе набора данных
		//по причине:
		//{(1, 17)}: Неверное присоединение
		//ВЫБРАТЬ Т.* ИЗ  <<?>>КАК Т
		ОбъектМД = Метаданные.НайтиПоПолномуИмени(ПолноеИмяМД);
		Если ОбъектМД = Неопределено Тогда
			// Возможно эта логика уже есть в какой то функции
			лПолноеИмяМД = ПолноеИмяМД;
			Фрагменты = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ПолноеИмяМД);
			Если Фрагменты.Количество() > 1 Тогда
				Фрагменты.Удалить(Фрагменты.Количество() - 1);
				лПолноеИмяМД = ирОбщий.ПолучитьСтрокуСРазделителемИзМассиваЛкс(Фрагменты, ".");
			КонецЕсли; 
			ОбъектМД = Метаданные.НайтиПоПолномуИмени(лПолноеИмяМД);
		КонецЕсли; 
		Если Ложь
			Или ОбъектМД = Неопределено
			Или Не ПравоДоступа("Чтение", ОбъектМД) 
		Тогда
			Если ВызыватьИсключениеПриОтсутствииПрав Тогда
				ВызватьИсключение "Таблица отсутствует или нет прав на ее чтение """ + ПолноеИмяМД + """";
			Иначе
				Возврат Неопределено;
			КонецЕсли; 
		Иначе
			ВызватьИсключение;
		КонецЕсли; 
	КонецПопытки; 
	КомпоновщикНастроек = Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(ИсточникДоступныхНастроек);
	
	// Для сравнения скорости в отладчике. Примерно та же скорость через построитель.
	//ПсевдонимТаблицы = "Т";
	//ПолноеИмяИлиОбъектМД = ПолноеИмяМД;
	//Если ТипЗнч(ПолноеИмяИлиОбъектМД) = Тип("Строка") Тогда
	//	ПолноеИмяМД = ПолноеИмяИлиОбъектМД;
	//Иначе
	//	ПолноеИмяМД = ПолноеИмяИлиОбъектМД.ПолноеИмя();
	//КонецЕсли; 
	//ПолноеИмяТаблицыБД = ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД);
	//Если ИндексПараметраПериодичность <> Неопределено Тогда
	//	ПолноеИмяТаблицыБД = ПолноеИмяТаблицыБД + "(";
	//	Для Индекс = 1 По ИндексПараметраПериодичность Цикл
	//		ПолноеИмяТаблицыБД = ПолноеИмяТаблицыБД + ",";
	//	КонецЦикла;
	//	ПолноеИмяТаблицыБД = ПолноеИмяТаблицыБД + ВыражениеПараметраПериодичность + ")";
	//КонецЕсли; 
	//ТекстЗапроса = "ВЫБРАТЬ " + ПсевдонимТаблицы + ".* ИЗ " + ПолноеИмяТаблицыБД + " КАК " + ПсевдонимТаблицы;
	//Построитель = Новый ПостроительЗапроса(ТекстЗапроса);
	//Построитель.ЗаполнитьНастройки();
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = КомпоновщикНастроек;
	КонецЕсли; 
	Возврат КомпоновщикНастроек;
	
КонецФункции

Функция ПолучитьПоляТаблицыБДЛкс(ПолноеИмяТаблицыБД, ВызыватьИсключениеПриОтсутствииПрав = Истина, ИндексПараметраПериодичность = Неопределено, ВыражениеПараметраПериодичность = "") Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ПолучитьПоляТаблицыБДЛкс");
		КлючНаборПараметров = "" + ПолноеИмяТаблицыБД + ";" + ВызыватьИсключениеПриОтсутствииПрав + ";" + ИндексПараметраПериодичность + ";" + ВыражениеПараметраПериодичность;
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	Результат = ирОбщий.ПолучитьПоляТаблицыБДЛкс(ПолноеИмяТаблицыБД, ВызыватьИсключениеПриОтсутствииПрав, ИндексПараметраПериодичность, ВыражениеПараметраПериодичность);
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = Результат;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ИндивидуальныеТаблицыКонстантДоступныЛкс() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	Результат = Истина
		И мПлатформа.ВерсияПлатформы >= 802014
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_2_13
		И Метаданные.РежимСовместимости <> Метаданные.СвойстваОбъектов.РежимСовместимости.Версия8_1;
	Возврат Результат;

КонецФункции

Функция ПолучитьТаблицуВсехТаблицБДЛкс() Экспорт 
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ПолучитьТаблицуВсехТаблицБДЛкс");
		КлючНаборПараметров = "";
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	ТаблицаВсехТаблицБД = Неопределено;
	// Этот способ оказался в большинстве случаев медленнее чем вычислять таблицу каждый раз
	//Если мПлатформа.ИДВерсииПлатформы > "82" Тогда 
	//	#Если Клиент Тогда
	//		Состояние("Получение структуры хранения БД...");
	//	#КонецЕсли
	//	СтруктураХраненияБД = ПолучитьСтруктуруХраненияБазыДанных(, Ложь);
	//	#Если Клиент Тогда
	//		Состояние("");
	//	#КонецЕсли
	//	ХМЛСтруктурыХранения = ЗначениеВСтрокуВнутр(СтруктураХраненияБД);
	//	Хеширование = Вычислить("Новый ХешированиеДанных(ХешФункция.MD5)");
	//	Хеширование.Добавить(ХМЛСтруктурыХранения);
	//	ХешСтруктурыХранения = Хеширование.ХешСумма;
	//	ФайлКэша = Новый Файл(мПлатформа.КаталогФайловогоКэша + "\irAllDBTables.tbl");
	//	Если ФайлКэша.Существует() Тогда
	//		КешТаблиц = ЗначениеИзФайла(ФайлКэша.ПолноеИмя);
	//		Если КешТаблиц.ХешСтруктурыХранения = ХешСтруктурыХранения Тогда
	//			ТаблицаВсехТаблицБД = КешТаблиц.ТаблицаВсехТаблицБД;
	//		КонецЕсли; 
	//	КонецЕсли; 
	//КонецЕсли; 
	Если ТаблицаВсехТаблицБД = Неопределено Тогда
		ТаблицаВсехТаблицБД = Новый ТаблицаЗначений;
		ТаблицаВсехТаблицБД.Колонки.Добавить("ПолноеИмяМД");
		ТаблицаВсехТаблицБД.Колонки.Добавить("НПолноеИмя");
		ТаблицаВсехТаблицБД.Колонки.Добавить("ПолноеИмя");
		ТаблицаВсехТаблицБД.Колонки.Добавить("Имя");
		ТаблицаВсехТаблицБД.Колонки.Добавить("Представление");
		ТаблицаВсехТаблицБД.Колонки.Добавить("Тип");
		ТаблицаВсехТаблицБД.Колонки.Добавить("Схема");
		ТаблицаВсехТаблицБД.Колонки.Добавить("ИндексПараметраОтбора");
		ТаблицаВсехТаблицБД.Колонки.Добавить("КоличествоСтрок");
		КоллекцияКорневыхТипов = Новый Массив;
		СтрокиМетаОбъектов = мПлатформа.ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
		Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
			Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
			Если Ложь
				Или (Истина
					И Единственное = "Константа"
					И ирКэш.ИндивидуальныеТаблицыКонстантДоступныЛкс())
				Или Единственное = "КритерийОтбора"
				Или Единственное = "ЖурналДокументов"
				Или ирОбщий.ЛиКорневойТипПеречисленияЛкс(Единственное)
				Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(Единственное)
				Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(Единственное)
				Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(Единственное)
			Тогда
				КоллекцияКорневыхТипов.Добавить(Единственное);
			КонецЕсли;
		КонецЦикла;
		Если мПлатформа.ВерсияПлатформы >= 802014 Тогда
			Для Каждого МетаВнешнийИсточникДанных Из Метаданные.ВнешниеИсточникиДанных Цикл
				КоллекцияКорневыхТипов.Добавить(МетаВнешнийИсточникДанных.ПолноеИмя());
			КонецЦикла; 
		КонецЕсли; 
		Если Метаданные.Константы.Количество() > 0 Тогда
			ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, "Константы",, "Константы");
		КонецЕсли; 
		мСтрокаТипаВнешнегоИсточникаДанных = мПлатформа.ПолучитьСтрокуТипаМетаОбъектов("ВнешнийИсточникДанных", , 0);
		ИндикаторТипов = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияКорневыхТипов.Количество(), "Анализ структуры БД");
		Для Каждого КорневойТип Из КоллекцияКорневыхТипов Цикл
			ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипов);
			СтрокаКорневогоТипа = мПлатформа.ПолучитьСтрокуТипаМетаОбъектов(КорневойТип);
			Если СтрокаКорневогоТипа = Неопределено Тогда
				СтрокаКорневогоТипа = мСтрокаТипаВнешнегоИсточникаДанных;
				МножественноеКорневогоТипа = СтрокаКорневогоТипа.Множественное;
				ОбъектМДКорневогоТипа = Метаданные.НайтиПоПолномуИмени(КорневойТип);
				КоллекцияМетаданных = ОбъектМДКорневогоТипа.Таблицы;
				ПредставлениеКатегории = ОбъектМДКорневогоТипа.Представление();
				СхемаТаблиц = ОбъектМДКорневогоТипа.Имя;
				КорневойТип = "Внешняя";
			Иначе
				МножественноеКорневогоТипа = СтрокаКорневогоТипа.Множественное;
				ПредставлениеКатегории = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(МножественноеКорневогоТипа);
				СхемаТаблиц = "";
				Если КорневойТип = "Перерасчет" Тогда 
					КоллекцияМетаданных = Новый Массив;
					Для Каждого МетаРегистрРасчета Из Метаданные.РегистрыРасчета Цикл
						Для Каждого Перерасчет Из МетаРегистрРасчета.Перерасчеты Цикл
							КоллекцияМетаданных.Добавить(Перерасчет);
						КонецЦикла;
					КонецЦикла;
				Иначе
					КоллекцияМетаданных = Метаданные[МножественноеКорневогоТипа];
				КонецЕсли; 
			КонецЕсли; 
			Если КоллекцияМетаданных.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			//ПредставлениеТипаТаблицы = ирОбщий.ПолучитьПредставлениеИзИдентификатораЛкс(МножественноеКорневогоТипа);
			ИндикаторТипа = ирОбщий.ПолучитьИндикаторПроцессаЛкс(КоллекцияМетаданных.Количество(), "Анализ " + КорневойТип);
			Для Каждого МетаИсточник Из КоллекцияМетаданных Цикл
				ирОбщий.ОбработатьИндикаторЛкс(ИндикаторТипа);
				ПолноеИмяМД = МетаИсточник.ПолноеИмя();
				ТипТаблицы = КорневойТип;
				Если ТипТаблицы = "КритерийОтбора" Тогда
					ТипТаблицы = "ВиртуальнаяТаблица";
				КонецЕсли; 
				СтрокаОсновнойТаблицы = ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(ПолноеИмяМД,, Ложь), ПолноеИмяМД, ТипТаблицы, МетаИсточник.Имя,
				МетаИсточник.Представление(), СхемаТаблиц, , МетаИсточник);
				Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(КорневойТип) Тогда
					СтруктураТЧ = ирОбщий.ПолучитьТабличныеЧастиОбъектаЛкс(МетаИсточник);
					Для Каждого КлючИЗначение Из СтруктураТЧ Цикл
						ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + "." + КлючИЗначение.Ключ, ПолноеИмяМД + ".ТабличнаяЧасть." + КлючИЗначение.Ключ, "ТабличнаяЧасть", ,
						МетаИсточник.Представление() + "." + КлючИЗначение.Значение);
					КонецЦикла;
					Если КорневойТип = "БизнесПроцесс" Тогда 
						ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Точки",, "Точки", , МетаИсточник.Представление() + "." + "Точки");
					КонецЕсли; 
					Если КорневойТип = "Задача" Тогда 
						Если МетаИсточник.Адресация <> Неопределено Тогда
							ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ЗадачиПоИсполнителю",, "ВиртуальнаяТаблица", ,
							МетаИсточник.Представление() + "." + "Задачи по исполнителю",,,, 1);
						КонецЕсли; 
					КонецЕсли; 
				КонецЕсли; 
				Если ирОбщий.ЕстьТаблицаИзмененийОбъектаМетаданных(МетаИсточник) Тогда
					//Если Ложь
					//            Или ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(КорневойТип)
					//            Или ирОбщий.ЛиКорневойТипРегистраБДЛкс(КорневойТип)
					//            Или ирОбщий.ЛиКорневойТипПоследовательностиЛкс(КорневойТип)
					//Тогда
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, СтрокаОсновнойТаблицы.ПолноеИмя + ".Изменения", , "Изменения", СтрокаОсновнойТаблицы.Имя,
					СтрокаОсновнойТаблицы.Представление + "." + "Изменения");
					//КонецЕсли; 
				КонецЕсли;
				Если КорневойТип = "РегистрСведений" Тогда 
					Если МетаИсточник.ПериодичностьРегистраСведений <> Метаданные.СвойстваОбъектов.ПериодичностьРегистраСведений.Непериодический Тогда
						ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".СрезПоследних",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Срез последних",,,, 1);
						ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".СрезПервых",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Срез первых",,,, 1);
					КонецЕсли;
				ИначеЕсли КорневойТип = "РегистрНакопления" Тогда 
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Обороты",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Обороты",,,, 3);
					Если МетаИсточник.ВидРегистра = Метаданные.СвойстваОбъектов.ВидРегистраНакопления.Остатки Тогда
						ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Остатки",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Остатки",,,, 1);
						ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ОстаткиИОбороты",, "ВиртуальнаяТаблица", ,
						МетаИсточник.Представление() + "." + "Остатки и обороты",,,, 4);
					КонецЕсли;
				ИначеЕсли КорневойТип = "РегистрБухгалтерии" Тогда 
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ДвиженияССубконто",, "ДвиженияССубконто", ,
					МетаИсточник.Представление() + "." + "Движения с субконто",,,, 2);
					Если МетаИсточник.ПланСчетов.МаксКоличествоСубконто > 0 Тогда
						ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Субконто",, "Субконто", , МетаИсточник.Представление() + "." + "Субконто");
					КонецЕсли; 
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Обороты",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Обороты",,,, 5);
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ОборотыДтКт",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Обороты Дт Кт",,,, 7);
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Остатки",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Остатки",,,, 3);
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".ОстаткиИОбороты",, "ВиртуальнаяТаблица", , МетаИсточник.Представление() + "." + "Остатки и обороты",,,, 6);
					//ИначеЕсли КорневойТип = "РегистрРасчета" Тогда 
					//            Для Каждого Перерасчет Из МетаИсточник.Перерасчеты Цикл
					//                            ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ирОбщий.ПолучитьИмяТаблицыИзМетаданныхЛкс(Перерасчет), "Перерасчет", Перерасчет.Имя, Перерасчет.Представление(), , , Перерасчет);
					//            КонецЦикла;
				ИначеЕсли КорневойТип = "Последовательность" Тогда 
					ирОбщий.ДобавитьДоступнуюТаблицуБДЛкс(ТаблицаВсехТаблицБД, ПолноеИмяМД + ".Границы",, "Границы", , МетаИсточник.Представление() + "." + "Границы");
				КонецЕсли;
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		ТаблицаВсехТаблицБД.Индексы.Добавить("НПолноеИмя");
		ТаблицаВсехТаблицБД.Сортировать("НПолноеИмя");
		//Если ФайлКэша <> Неопределено Тогда
		//	КешТаблиц = Новый Структура("ТаблицаВсехТаблицБД, ХешСтруктурыХранения", ТаблицаВсехТаблицБД, ХешСтруктурыХранения);
		//	ЗначениеВФайл(ФайлКэша.ПолноеИмя, КешТаблиц);
		//КонецЕсли; 
	КонецЕсли; 
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = ТаблицаВсехТаблицБД;
	КонецЕсли; 
	Возврат ТаблицаВсехТаблицБД;
	
КонецФункции

Функция ЛиПортативныйРежимЛкс() Экспорт
	
	Попытка
		Пустышка = ирПортативный.мВнешниеМодули;
		Результат = Истина;
	Исключение
		Результат = Ложь;
	КонецПопытки; 
	Возврат Результат;
	
КонецФункции

Функция ЛиЭтоРасширениеКонфигурацииЛкс() Экспорт
	
	Результат = ирКэш.ЭтотРасширениеКонфигурацииЛкс() <> Неопределено;
	Возврат Результат;
	
КонецФункции

Функция ЭтотРасширениеКонфигурацииЛкс() Экспорт
	
	Результат = Неопределено;
	Если Не ирОбщий.РежимСовместимостиМеньше8_3_4Лкс() Тогда 
		Попытка
			ЭтиРасширения = Вычислить("РасширенияКонфигурации").Получить(); // Антибаг платформы https://partners.v8.1c.ru/forum/t/1607016/m/1607016
		Исключение
			Возврат Результат;
		КонецПопытки; 
		ОтборРасширений = Новый Структура("Имя", ирОбщий.ИмяПродуктаЛкс());
		ЭтиРасширения = Вычислить("РасширенияКонфигурации").Получить(ОтборРасширений);
		Если ЭтиРасширения.Количество() > 0 Тогда 
			Результат = ЭтиРасширения[0];
		КонецЕсли; 
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьСтруктуруХраненияБДЛкс(ЛиИменаБД = Ложь, ВычислитьИменаИндексов = Истина, АдресЧужойСхемыБД = "") Экспорт

	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ПолучитьСтруктуруХраненияБДЛкс");
		КлючНаборПараметров = "" + ЛиИменаБД + ";" + ВычислитьИменаИндексов + ";" + АдресЧужойСхемыБД;
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли;
	КонецЕсли; 
	
	Результат = ирОбщий.ПолучитьСтруктуруХраненияБДЛкс(, ЛиИменаБД, ВычислитьИменаИндексов, АдресЧужойСхемыБД);
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = Результат;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

// Получить словарь метаданных состоящий из шаблонов имен таблиц
//
// Параметры:
//  ЛиИменаБД - Булево
//
// Возвращаемое значение:
//  Соответствие - словарь шаблонов имен метаданных. Ключ - наименование объекта
//                 метаданных, где его номер заменен на номер позиции этого
//                 числа в строке; Значение - количество чисел в строке
//
Функция ПолучитьСловарьШаблоновМетаданныхЛкс(ЛиИменаБД = Ложь, АдресЧужойСхемыБД = "") Экспорт

	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ПолучитьСловарьШаблоновМетаданныхЛкс");
		КлючНаборПараметров = "" + ЛиИменаБД + ";" + АдресЧужойСхемыБД;
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 

	СтруктураХраненияБД = ирКэш.ПолучитьСтруктуруХраненияБДЛкс(ЛиИменаБД, , АдресЧужойСхемыБД);
	// Создать словарь метаданных
	СловарьМетаданных = Новый Соответствие;
	КоличествоСимволов = 0;
	ПозицияЧисла = 0;
	// Обработать структуру базы
	Для Каждого СтрокаСтруктурыБазы Из СтруктураХраненияБД Цикл
		
		// Скопировать имя таблицы
		ИмяТаблицыХранения = НРег(Лев(СтрокаСтруктурыБазы.ИмяТаблицыХранения, СтрДлина(СтрокаСтруктурыБазы.ИмяТаблицыХранения)));
		ШаблонИмениТаблицыХранения = "";
		КоличествоЧисел = 0;
		ПоследнееИмяШаблона = "";
		
		// Получить шаблон имени
		Пока ирОбщий.НайтиЧислоВСтрокеЛкс(ИмяТаблицыХранения, ПозицияЧисла, КоличествоСимволов) Цикл
			КоличествоЧисел = КоличествоЧисел + 1;
			ПоследнееИмяШаблона = Лев(ИмяТаблицыХранения, ПозицияЧисла - 1);
			ШаблонИмениТаблицыХранения = ШаблонИмениТаблицыХранения + ПоследнееИмяШаблона + XMLСтрока(КоличествоЧисел);
			ИмяТаблицыХранения = Прав(ИмяТаблицыХранения, СтрДлина(ИмяТаблицыХранения) - ПозицияЧисла - КоличествоСимволов + 1);
		КонецЦикла;
		
		ШаблонИмениТаблицыХранения = ШаблонИмениТаблицыХранения + ИмяТаблицыХранения;
		СловарьМетаданных.Вставить(ШаблонИмениТаблицыХранения, КоличествоЧисел);
		
		Если Не ЛиИменаБД Тогда
			// Сохранить шаблон дочерней таблицы независимо
			Если КоличествоЧисел > 1 Тогда
				Если Лев(ПоследнееИмяШаблона, 1) = "." Тогда
					ПоследнееИмяШаблона = Сред(ПоследнееИмяШаблона, 2);
				КонецЕсли; 
				СловарьМетаданных.Вставить(ПоследнееИмяШаблона + "1", 1);
			КонецЕсли; 
		КонецЕсли; 
	КонецЦикла;
	
	// Предобразовать соответствие в ТЗ и отсортировать ее по ключу в обратном порядке
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("Ключ");
	Результат.Колонки.Добавить("Значение");
	Для Каждого СтрокаСловаря Из СловарьМетаданных Цикл
		СтрокаТаблицыСловаря = Результат.Добавить();
		СтрокаТаблицыСловаря.Ключ = НРег(СтрокаСловаря.Ключ);
		СтрокаТаблицыСловаря.Значение = СтрокаСловаря.Значение;
	КонецЦикла;
	Результат.Сортировать("Ключ Убыв");
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = Результат;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Функция ПолучитьСеансПустойИнфобазы1С8Лкс(Знач ТипCOMОбъекта = "Application", Знач Видимость = Ложь, Знач ОбработатьИсключениеПодключения = Ложь,
	ОписаниеОшибки = "", ИмяСервераПроцессов = "") Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ПолучитьСеансПустойИнфобазы1С8Лкс");
		КлючНаборПараметров = "" + ТипCOMОбъекта + ";" + Видимость + ";" + ОбработатьИсключениеПодключения + ";" + ОписаниеОшибки + ";" + ИмяСервераПроцессов;
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	СтрокаСоединения = ирОбщий.ПолучитьСтрокуСоединенияПустойИнфобазыЛкс();
	Результат = ирОбщий.СоздатьСеансИнфобазы1С8Лкс(СтрокаСоединения, , , ТипCOMОбъекта, Видимость, ОбработатьИсключениеПодключения,
		ОписаниеОшибки, ИмяСервераПроцессов);
		
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = Результат;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьБуферСравненияЛкс(ТипДанных) Экспорт
	
	Попытка
		ирПлатформа = Вычислить("ирПлатформа");
	Исключение
	КонецПопытки;
	Если ирПлатформа = Неопределено Тогда
		Результат = Новый Массив();
	Иначе
		Результат = ирПлатформа.БуферыСравнения[ТипДанных]; 
		Если Результат = Неопределено Тогда
			Результат = Новый Массив;
			ирПлатформа.БуферыСравнения[ТипДанных] = Результат;
		КонецЕсли; 
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ПолучитьWinAPI() Экспорт 
	
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	WinAPI = мПлатформа.ПолучитьWinAPI();
	Возврат WinAPI;
	
КонецФункции

Функция ПолучитьФорматБуфераОбмена1СЛкс() Экспорт 
	
	WinAPI = ирКэш.ПолучитьWinAPI();
	ФорматБуфераОбмена1С = WinAPI.RegisterClipboardFormat("V8Value");
	Возврат ФорматБуфераОбмена1С;
	
КонецФункции

Функция Это64битнаяОСЛкс(Компьютер = Неопределено) Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("Это64битнаяОСЛкс");
		КлючНаборПараметров = "" + Компьютер;
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	мWMI =  ирКэш.ПолучитьCOMОбъектWMIЛкс(Компьютер);
	// http://www.forum.mista.ru/topic.php?id=752260
	//ИмяКласса = "Win32_OperatingSystem";
	//КоллекцияОС = мWMI.InstancesOf(ИмяКласса);
	//Для каждого лОС Из КоллекцияОС Цикл
	//	Прервать;
	//КонецЦикла;
	//Результат = Лев(лОС.OSArchitecture, 2) = "64";
	РезультатЗапроса = мWMI.ExecQuery("select AddressWidth from Win32_Processor where DeviceID=""CPU0"" AND AddressWidth=64");
	Результат = РезультатЗапроса.Count > 0;
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = Результат;
	КонецЕсли; 
	Возврат Результат;

КонецФункции

// Возвращает смещение времени из-за некорректной функции ПолучитьВремяИзменения()
// Часть примечание из описания функции:
//  В режиме совместимости выдает местное время последней модификации файла с ошибкой NTFS.
//  Если файл изменен летом, а просматривается зимой, то полученное время отстает на 1 час.
//  Если файл изменен зимой, а просматривается летом, то полученное время опережает на 1 час.
//
// Источник - http://infostart.ru/public/323233/
// Автор - OtTech http://infostart.ru/profile/492011/
//
// Возвращаемое значение:
// Число - Количество секунд смещения.
//
Функция ПолучитьСмещениеВремениЛкс() Экспорт 
	
	ИмяФайла = ПолучитьИмяВременногоФайла();
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.Записать(ИмяФайла);
	Файл = Новый Файл(ИмяФайла);
	Разница = ОКР((ТекущаяДата() - Файл.ПолучитьВремяИзменения()) / 3600);
	УдалитьФайлы(ИмяФайла);
	Возврат Разница * 3600;
	
КонецФункции

//#Если Клиент Тогда
	
Функция ПолучитьАнализТехножурналаЛкс() Экспорт
	
	Результат = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс("Обработка.ирАнализТехножурнала");
	Возврат Результат;
	
КонецФункции

//#КонецЕсли

Функция ПолучитьСеансТонкогоКлиентаЛкс(ПользовательИБ = Неопределено) Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ПолучитьСеансТонкогоКлиентаЛкс");
		КлючНаборПараметров = "";
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	Если ПодАдминистратором Тогда
		ПользовательИБ = "Администратор";
		ПарольПользователяИБ = "19643003";
	Иначе
		ПользовательИБ = ИмяПользователя();
		ПарольПользователяИБ = Неопределено;
	КонецЕсли;
	
	СвязанныйСеансТонкогоКлиента = ирОбщий.ЗапуститьСеансПодПользователемЛкс(ПользовательИБ,ПарольПользователяИБ, "c.Application",,,, Ложь, Ложь,,,Истина,,,Ложь); 
	Попытка
		СвязанныйСеансТонкогоКлиента.Visible = Истина;
	Исключение
		Сообщить("Не удалось подключить тонкий клиент через COM", СтатусСообщения.Внимание);
		Возврат Неопределено;
	КонецПопытки; 
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = СвязанныйСеансТонкогоКлиента;
	КонецЕсли; 
	Возврат СвязанныйСеансТонкогоКлиента;
	
КонецФункции

Функция ОбъектыМетаданныхСРегистрациейИзменений() Экспорт 
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ОбъектыМетаданныхСРегистрациейИзменений");
		КлючНаборПараметров = "";
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	Результат = Новый Соответствие;
	Для Каждого МетаПланОбмена Из Метаданные.ПланыОбмена Цикл
		Для Каждого ЭлементСостава Из МетаПланОбмена.Состав Цикл
			Результат[ЭлементСостава.Метаданные.ПолноеИмя()] = 1;
		КонецЦикла;
	КонецЦикла;
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = Результат;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция ВКОбщая() Экспорт 

	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ВКОбщая");
		КлючНаборПараметров = "";
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	Попытка
		ВК = Новый ("AddIn.ирОбщая.AddIn");
	Исключение
		Это64битныйПроцесс = Это64битныйПроцессЛкс();
		ИмяМакета = "ВК";
		Если Это64битныйПроцесс Тогда
			ИмяМакета = ИмяМакета + "64";
		Иначе
			ИмяМакета = ИмяМакета + "32";
		КонецЕсли; 
		Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
			ДвоичныеДанные = ирПортативный.ПолучитьМакет(ИмяМакета);
		Иначе
			ДвоичныеДанные = Обработки.ирПортативный.ПолучитьМакет(ИмяМакета);
		КонецЕсли; 
		АдресКомпоненты = ПолучитьИмяВременногоФайла("dll");
		ДвоичныеДанные.Записать(АдресКомпоненты);
		//АдресКомпоненты = "D:\VC\Native_Comp_RDT\binWin32\AddInNative.dll"; // Для отладки
		Результат = ПодключитьВнешнююКомпоненту(АдресКомпоненты, "ирОбщая", ТипВнешнейКомпоненты.Native);
		Если Не Результат Тогда
			ВызватьИсключение "Не удалось подключить внешнюю компоненту Общая"; 
		КонецЕсли; 
		ВК = Новый ("AddIn.ирОбщая.AddIn");
	КонецПопытки; 
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = ВК;
	КонецЕсли; 
	Возврат ВК;
	
КонецФункции

Функция КорневыеТипыСсылочныеЛкс() Экспорт 
	
	Результат = Новый Массив;
	мПлатформа = ирКэш.Получить();
	#Если Сервер И Не Сервер Тогда
		мПлатформа = Обработки.ирПлатформа.Создать();
	#КонецЕсли
	СтрокиМетаОбъектов = мПлатформа.ТаблицаТиповМетаОбъектов.НайтиСтроки(Новый Структура("Категория", 0));
	Для Каждого СтрокаТаблицыМетаОбъектов Из СтрокиМетаОбъектов Цикл
		Единственное = СтрокаТаблицыМетаОбъектов.Единственное;
		Если ирОбщий.ЛиКорневойТипСсылочногоОбъектаБДЛкс(Единственное) Тогда
			Результат.Добавить(СтрокаТаблицыМетаОбъектов);
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;

КонецФункции

Функция ЭтоФоновоеЗаданиеЛкс() Экспорт 
	
	ТекущийСеанс = ирКэш.ТекущийСеансЛкс();
	Если ТекущийСеанс = Неопределено Тогда
		Результат = Ложь;
	Иначе
		Результат = ирОбщий.СтрокиРавныЛкс(ТекущийСеанс.ИмяПриложения, "BackgroundJob");
	КонецЕсли; 
	Возврат Результат;

КонецФункции

Функция ТекущийСеансЛкс() Экспорт 

	Сеансы = ПолучитьСеансыИнформационнойБазы();
	НомерСеанса = НомерСеансаИнформационнойБазы();
	Для Каждого Сеанс Из Сеансы Цикл 
		Если Сеанс.НомерСеанса = НомерСеанса Тогда 
			Результат = Сеанс;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если Результат = Неопределено Тогда
		Сообщить("Собственный сеанс не найден");
	КонецЕсли; 
	Возврат Результат;

КонецФункции

#КонецЕсли

Функция ТекущийПользовательОСЛкс() Экспорт  
	
	#Если ВебКлиент Тогда
		ПользовательОС = "";
	#Иначе
		Network = Новый COMОбъект("WScript.Network");
		ПользовательОС = Network.UserDomain + "\" + Network.UserName;
	#КонецЕсли
	Возврат ПользовательОС;
	
КонецФункции

Функция Это64битныйПроцессЛкс() Экспорт
	
	СисИнфо = Новый СистемнаяИнформация;
	Результат = СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64;
	Возврат Результат;

КонецФункции

Функция ИмяКолонкиНомерСтрокиЛкс() Экспорт 
	
	ИмяКолонкиНомерСтроки = "НомерСтроки8793";
	Возврат ИмяКолонкиНомерСтроки;

КонецФункции // ТабличноеПолеСВложеннымиКоллекциямиПриВыводеСтроки()

Функция ЭтоФайловаяБазаЛкс() Экспорт 

	ФайловыйКаталог = НСтр(СтрокаСоединенияИнформационнойБазы(), "File");
	ЭтоФайловаяБаза = Не ПустаяСтрока(ФайловыйКаталог);
	Возврат ЭтоФайловаяБаза;

КонецФункции // ЭтоФайловаяБазаИис()

Функция ПолучитьСтрокуСоединенияСервераЛкс() Экспорт
	
	Результат = ирСервер.ПолучитьСтрокуСоединенияСервераЛкс();
	Возврат Результат;
	
КонецФункции

Функция ПолучитьCOMОбъектWMIЛкс(Знач ИмяСервера = Неопределено, Знач ИмяСервераИсполнителя = Неопределено, Знач ТочкаПодключения = Неопределено) Экспорт
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции = ирПортативный.КэшФункцииЛкс("ПолучитьCOMОбъектWMIЛкс");
		КлючНаборПараметров = "" + ИмяСервера + ";" + ИмяСервераИсполнителя + ";" + ТочкаПодключения;
		Результат = КэшФункции[КлючНаборПараметров];
		Если Результат <> Неопределено Тогда
			Возврат Результат;
		КонецЕсли; 
	КонецЕсли; 
	
	//http://msdn.microsoft.com/en-us/library/windows/desktop/aa389763(v=vs.85).aspx
	Если Не ЗначениеЗаполнено(ИмяСервераИсполнителя) Тогда 
		Locator = Новый COMОбъект("WbemScripting.SWbemLocator");
	Иначе
		Locator = Новый COMОбъект("WbemScripting.SWbemLocator", ИмяСервераИсполнителя);
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ИмяСервера) Тогда 
		ИмяСервера = ".";
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТочкаПодключения) Тогда 
		ТочкаПодключения = "root\cimv2";
	КонецЕсли;
	Попытка
		Результат = Locator.ConnectServer(ИмяСервера, ТочкаПодключения, , , ); 
	Исключение
		Результат = Неопределено;
		Сообщить(ОписаниеОшибки(), СтатусСообщения.Внимание);
	КонецПопытки;
	
	Если ирКэш.ЛиПортативныйРежимЛкс() Тогда
		КэшФункции[КлючНаборПараметров] = Результат;
	КонецЕсли; 
	Возврат Результат;
	
КонецФункции

Функция АдресСайтаЛкс() Экспорт 
	Возврат "devtool1c.ucoz.ru";
КонецФункции
