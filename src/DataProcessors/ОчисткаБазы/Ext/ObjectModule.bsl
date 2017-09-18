﻿
//
//
Процедура КомандаОчиститьИБ() Экспорт 
	
	Если НЕ ВыполнитьОчистку() Тогда
		ВывестиСообщение("Ошибка при выполнении очистки базы", Истина);
		Возврат;
	КонецЕсли;		
	
КонецПроцедуры	

//
//
Функция ПроверкаЗаполнения()
	
	// Указана ли ИБ
	Если ПараметрыСеанса.Версия > 1 И ПараметрыСеанса.РаспределенныйРежим И НЕ ЗначениеЗаполнено(ИнформационнаяБаза) Тогда
		ВывестиСообщение("Не указана информационная база для очистки!", Истина);
		Возврат Ложь;
	КонецЕсли;	
	
	// Указана ли дата обчистки
	Если НЕ ЗначениеЗаполнено(ДатаОчистки) Тогда
		ВывестиСообщение("Не указана дата до которой нужно произвести очистку!", Истина);
		Возврат Ложь;
	КонецЕсли;	
	
	// Нельзя устанавливать дату очистки будущим
	Если ДатаОчистки >= ТекущаяДата() Тогда
		ВывестиСообщение("Нельзя устанавливать дату очистки будущим числом!", Истина);
		Возврат Ложь;
	КонецЕсли;		
			
	Возврат Истина;
	
КонецФункции	

//
//
Функция УстановитьКомандуНаОчисткуИБРИБ() Экспорт
	
    Если НЕ ПроверкаЗаполнения() Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	// Есть ли данные об очистке по текущей ИБ
	МенеджерЗаписи = РегистрыСведений.ОчисткаРИБ.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИнформационнаяБаза = ИнформационнаяБаза;
	МенеджерЗаписи.Прочитать();
	
	// Уже есть команда на очистку и она еще не выполнена
	Если МенеджерЗаписи.Выбран() И НЕ МенеджерЗаписи.ОчисткаВыполнена Тогда
		ВывестиСообщение("Для ИБ " + ИнформационнаяБаза + " уже отправлена команда на очистку до " + МенеджерЗаписи.ДатаОчистки, Истина);
		Возврат Ложь;
	КонецЕсли;
	
		
	Возврат Истина;
	
КонецФункции

Процедура КомандаОтменитьОчисткуИБ() Экспорт
	
	// Отменяется очистка центрального узла
	Если ПланыОбмена.ГлавныйУзел() = Неопределено И ПараметрыСеанса.ТекущаяИБ = ИнформационнаяБаза Тогда
				
		// Передать команду на отмену очистки центральной и всех периферийных ИБ
		ВыборкаУзлов = ПланыОбмена.Основной.Выбрать();
		Пока ВыборкаУзлов.Следующий() Цикл
			Если ВыборкаУзлов.ПометкаУдаления Тогда
				Продолжить;
			КонецЕсли;
			ЗаписатьРегистрОтменаОчисткиИБ(ВыборкаУзлов.ИнформационнаяБаза);
		КонецЦикла;
		
	// Установить команду на очистку периферийной ИБ	
	Иначе
		ЗаписатьРегистрОтменаОчисткиИБ(ИнформационнаяБаза);
	КонецЕсли;
	
КонецПроцедуры	

// Прописать в регистр команду на очистку ИБ
//
Процедура ЗаписатьРегистрНаОчисткуИБ(ТекИБ, ОчититьПериферийнуюИБ = Истина)
	
	// Если это центральная ИБ то просто ставим контроль
	Контроль		= ПараметрыСеанса.ТекущаяИБ = ТекИБ;
	
	// Если это центральная ИБ и ОчититьПериферийнуюИБ = Ложь то для центральной все равно ставим метку Очистить.
	ОчиститьТекИБ	= ?(Контроль, Истина, ОчититьПериферийнуюИБ);
	
	МенеджерЗаписи = РегистрыСведений.ОчисткаРИБ.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИнформационнаяБаза	= ТекИБ;
	МенеджерЗаписи.ДатаОчистки			= ДатаОчистки;
	МенеджерЗаписи.Очистить				= ОчиститьТекИБ;	
	МенеджерЗаписи.НомерСообщения		= 0;
	МенеджерЗаписи.Контроль				= Контроль;
	МенеджерЗаписи.ОчисткаВыполнена		= Ложь;
	МенеджерЗаписи.Записать();
	
	ВывестиСообщение("Установлена команда на очистку ИБ " + ТекИБ + " до " + ДатаОчистки);
	
КонецПроцедуры

// Прописать в регистр команду на очистку ИБ
//
Процедура ЗаписатьРегистрОтменаОчисткиИБ(ТекИБ)
	
	МенеджерЗаписи = РегистрыСведений.ОчисткаРИБ.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ИнформационнаяБаза	= ТекИБ;
	МенеджерЗаписи.Прочитать();
	
	Если МенеджерЗаписи.Выбран() Тогда
		
		МенеджерЗаписи.Удалить();
		//МенеджерЗаписи.ИнформационнаяБаза	= ТекИБ;
		//МенеджерЗаписи.ДатаОчистки			= Неопределено;
		//МенеджерЗаписи.НомерСообщения		= 0;
		//МенеджерЗаписи.Контроль				= Ложь;
		//МенеджерЗаписи.ОчисткаВыполнена		= Ложь;
		//МенеджерЗаписи.Записать();
		
		ВывестиСообщение("Отменена команда на очистку ИБ " + ТекИБ);
	КонецЕсли;
	
КонецПроцедуры


// Ввыполнить очистку текущей информационной базы
//
Функция ВыполнитьОчистку() Экспорт
	
	//----------------------------------------------
	// Проверки
	
    Если НЕ ПроверкаЗаполнения() Тогда
		Возврат Ложь;
	КонецЕсли;	
	
	// Чистим только в монопольном режиме
	Попытка
		УстановитьМонопольныйРежим(Истина);
	Исключение
		ВывестиСообщение("Не удалось установить монопольный режим.
		|Обработка не выполнена!", Истина);		
		Возврат Ложь;
	КонецПопытки; 	
	
	// Уведомляем о начале очистки
	ВывестиСообщение("Пользователь " + Строка(ПараметрыСеанса.ТекущийПользователь) + " запустил обработку очистки базы до " + Строка(ДатаОчистки));
	ВывестиСообщение(Строка(ТекущаяДата()) + " начата очистка базы");
	
	ВывестиСообщение(Строка(ТекущаяДата()) + " расчитывается сальдо по клиентам");
	
	//----------------------------------------------
	// Выбираем и помечаем на удаление документы всех видов
	Для Каждого Вид Из Метаданные.Документы Цикл
		УдаленияДокументов(Вид.Имя, Ложь);
	КонецЦикла;
	
		// Удаление данных из регистров при помеченном на удаление Заказе
		УдалениеДанныхРегистраСведенийСПроверкойРеквизита("ЗаказДопИнф", "Заказ");
		УдалениеДанныхРегистраСведенийСПроверкойРеквизита("ЗаказТоварыДопИнф", "Заказ");
		//----------------------------------------------
		// Удаленние данных из периодических регистров
		УдалениеДанныхПериодическогоРегистраСведений("ФактическийУчетРабочегоВремени"); 
	
	//----------------------------------------------
	// Удаленние данных из периодических регистров
	УдалениеДанныхПериодическогоРегистраСведений("КурсыВалют");
	УдалениеДанныхПериодическогоРегистраСведений("Цены");
	УдалениеДанныхПериодическогоРегистраСведений("ЦеныНоменклатуры");
	
	//----------------------------------------------
	// Выбираем и удаляем помеченные на удаление документы всех видов
	Для Каждого Вид Из Метаданные.Документы Цикл
		УдаленияДокументов(Вид.Имя);
	КонецЦикла;
	
	// Очистка закончена
	ВывестиСообщение(Строка(ТекущаяДата()) + " закончена очистка базы");
	
	Возврат Истина;
	
КонецФункции

// Проверка на наличиен не законченных очисток в периферийных ИБ
//
Функция ОчищеныПериферийныеИБ()
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	ОчисткаРИБ.ИнформационнаяБаза КАК ИнформационнаяБаза
	|ИЗ
	|	РегистрСведений.ОчисткаРИБ КАК ОчисткаРИБ
	|ГДЕ
	|	НЕ ОчисткаРИБ.ОчисткаВыполнена
	|	И ОчисткаРИБ.ИнформационнаяБаза <> &ЦентральнаяИБ";
	
	Запрос.УстановитьПараметр("ЦентральнаяИБ", ПараметрыСеанса.ТекущаяИБ);
	
	Если НЕ Запрос.Выполнить().Пустой() Тогда
		ВывестиСообщение("Существуют не выполненные команды на очистку периферийных баз", Истина);
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Удалить или пометить на удаление все документы определенного вида до указанной даты
//
Процедура УдаленияДокументов(ВидДокумента, УдалитьПомеченные = Истина)
	
	ВывестиСообщение(Строка(ТекущаяДата()) + ?(УдалитьПомеченные, " удаляются", " помечаются на удаление") + " документы " + ВидДокумента);
	
	Выборка = Документы[ВидДокумента].Выбрать( , ДатаОчистки);
	Инд = 1;
	Пока Выборка.Следующий() Цикл
		Если НЕ УдалитьПомеченные И Выборка.ПометкаУдаления Тогда
			Продолжить;
		ИначеЕсли УдалитьПомеченные И НЕ Выборка.ПометкаУдаления Тогда
			Продолжить;
		КонецЕсли;
		
		#Если Клиент Тогда
		ЕСли Инд%10 = 0 Тогда
			Состояние(""+Инд);
		КонецЕсли;
		#КонецЕсли
		Инд = Инд + 1;
		ТекОбъект = Выборка.ПолучитьОбъект();
		ТекОбъект.ДополнительныеСвойства.Вставить("ОчисткаБазы");
		
		Попытка
			Если УдалитьПомеченные Тогда
				ТекОбъект.Удалить();
			Иначе
				ТекОбъект.Проведен = Ложь;
				ТекОбъект.ПометкаУдаления = (Истина);
				ТекОбъект.ОбменДанными.Загрузка = ИСтина;
				ТекОбъект.Записать();
			КонецЕсли;
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры	

// Очистить данные по регистру где помечен на удаление документ
//
Процедура УдалениеДанныхРегистраСведенийСПроверкойРеквизита(ВидРегистра, ПроверяемыйРеквизит)
	
	ВывестиСообщение(Строка(ТекущаяДата()) + " Очищается регистр сведений " + ВидРегистра);
	
	ТекстЗапроса = СтрШаблон("Выбрать * ИЗ РегистрСведений.%1 ГДЕ %2.Дата < &Дата", ВидРегистра, ПроверяемыйРеквизит);
	
	Запрос = Новый Запрос(ТекстЗапроса);	
	Запрос.УстановитьПараметр("Дата", ДатаОчистки);
	
	ТЗ = Запрос.Выполнить().Выгрузить();	
	МЗ = РегистрыСведений[ВидРегистра].СоздатьМенеджерЗаписи();
	Для Каждого Т Из ТЗ Цикл
		МЗ[ПроверяемыйРеквизит] = Т[ПроверяемыйРеквизит];
		МЗ.Прочитать();
		МЗ.Удалить();
		
	КонецЦикла;
КонецПроцедуры	

// Очистить периодический регистр сведений до указанной даты
//
Процедура УдалениеДанныхПериодическогоРегистраСведений(НаименованиеРегистра)
	
	ВывестиСообщение(Строка(ТекущаяДата()) + " Очищается регистр " + НаименованиеРегистра);
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений." + НаименованиеРегистра + ".СрезПоследних КАК " + НаименованиеРегистра + "СрезПоследних
	|
	|ОБЪЕДИНИТЬ
	|
	|ВЫБРАТЬ
	|	*
	|ИЗ
	|	РегистрСведений." + НаименованиеРегистра + " КАК " + НаименованиеРегистра + "
	|ГДЕ
	|	" + НаименованиеРегистра + ".Период >= &Период"; 
	
	Запрос.УстановитьПараметр("Период", ДатаОчистки);
	
	ТаблицаОставляемыхЗаписей = Запрос.Выполнить().Выгрузить();
	
	НаборЗаписей = РегистрыСведений[НаименованиеРегистра].СоздатьНаборЗаписей();
	НаборЗаписей.Загрузить(ТаблицаОставляемыхЗаписей);
	НаборЗаписей.Записать();   	
	
КонецПроцедуры	

// Проставить признак об очистке центра для периферийных ИБ
//
Процедура ПроставитьОтметкуОбОчисткеЦентраДляПериферийныхИБ()
	
	ВыборкаОчисткиРИБ = РегистрыСведений.ОчисткаРИБ.Выбрать();
	
	ПроставленПризнак = Ложь;
	
	Пока ВыборкаОчисткиРИБ.Следующий() Цикл
		Если ВыборкаОчисткиРИБ.ИнформационнаяБаза = ПараметрыСеанса.ТекущаяИБ Тогда
			Продолжить;	
		КонецЕсли;
		МенеджерЗаписи = ВыборкаОчисткиРИБ.ПолучитьМенеджерЗаписи();
		МенеджерЗаписи.ИнформационнаяБаза	= МенеджерЗаписи.ИнформационнаяБаза;
		МенеджерЗаписи.ДатаОчистки			= МенеджерЗаписи.ДатаОчистки;
		МенеджерЗаписи.Очистить				= МенеджерЗаписи.Очистить;
		МенеджерЗаписи.НомерСообщения		= МенеджерЗаписи.НомерСообщения;
		МенеджерЗаписи.ОчисткаВыполнена		= МенеджерЗаписи.ОчисткаВыполнена;
		МенеджерЗаписи.Контроль				= МенеджерЗаписи.Контроль;
		МенеджерЗаписи.ОчищенаЦБ			= Истина;
		МенеджерЗаписи.Записать();
		
		ПроставленПризнак = Истина;
		
	КонецЦикла;

	Если ПроставленПризнак Тогда
	 	ВывестиСообщение("Проставлен признак очистки Центра для всех периферийных ИБ", Истина);
	КонецЕсли;
	
КонецПроцедуры

// Сообщить, предупредить, записать в журнал регистраций - по обстоятельствам
//
Процедура ВывестиСообщение(ТекстСообшения, ЭтоОшибка = Ложь)
	
	#Если Клиент Тогда
		Если глРабочееМесто = Неопределено Тогда
			Сообщить(ТекстСообшения, ?(ЭтоОшибка, СтатусСообщения.ОченьВажное, СтатусСообщения.БезСтатуса));
		КонецЕсли;
	#КонецЕсли
	
	ЗаписьЖурналаРегистрации(ТекстСообшения, ?(ЭтоОшибка, УровеньЖурналаРегистрации.Ошибка, УровеньЖурналаРегистрации.Информация));
	
КонецПроцедуры	

ИнформационнаяБаза = ПараметрыСеанса.ТекущаяИБ;
Попытка
	ГлубинаАрхива = Константы.ГлубинаАрхива.Получить();	
Исключение
	ГлубинаАрхива = 0;
КонецПопытки;

Если Не ЗначениеЗаполнено(ГлубинаАрхива) Тогда
	ГлубинаАрхива = 50;
КонецЕсли;
ДатаОчистки = ТекущаяДата() - 86400*ГлубинаАрхива;