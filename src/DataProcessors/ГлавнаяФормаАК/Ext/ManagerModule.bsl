﻿#Если ТолстыйКлиентУправляемоеПриложение Тогда

// Вызывается перед открытием формы из ИнтерфейсРМ.ЗапуститьРабочееМесто()
//
//&НаКлиенте
Функция ИнициализацияРабочегоМеста(ТекущееРМ) Экспорт
	
	РезультатОткрытия = Новый Структура("Ошибка,ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", Ложь, "", "", "");
	
	глПараметрыРМ = Новый Структура;
	
	// Проверка даты запуска ТТ
	//ДатаЗапускаТТ = ДатаЗапускаТТ();
	глПараметрыРМ.Вставить("РежимТестированияПередЗапуском", Ложь);
	глПараметрыРМ.Вставить("ФайловаяИБ", ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая());
	
	// Инициализация глобальных переменных
	глТорговоеОборудование	= Новый Структура;	// чтобы убрать все лишнее при запуске в режиме тестирования
	глСтекОкон				= Новый Массив;
	глОбработки				= Новый Структура;
	глФлагБлокировка		= Ложь;
	глФлагЗапретБлокировки	= Ложь;
	глПользователь			= Справочники.Сотрудники.ПустаяСсылка();
	
	// Инициализация параметров рабочего места
	РежимТестирования = ЗначениеЗаполнено(ТекущееРМ);
	
	Если РежимТестирования Тогда
		
		глРабочееМесто = ТекущееРМ;
		
	Иначе
		
		ПрофильВхода = "\\" + ИмяКомпьютера() + "\" + ИмяПользователя();
		глРабочееМесто = Справочники.РабочиеМеста.НайтиПоРеквизиту("ПрофильВхода",ПрофильВхода);
		
		Если глРабочееМесто.Пустая() Тогда
			Возврат ВыходПоОшибке("Рабочее место с профилем входа """ + ПрофильВхода + """ отсутствует!
				|Обратитесь к администратору...");
		КонецЕсли; 
		
		Если НЕ глРабочееМесто.Тест Тогда
			
			Попытка
				
				Для каждого Соединение Из ПолучитьСоединенияИнформационнойБазы() Цикл
					
					Если Соединение.Пользователь = Неопределено Тогда
						Продолжить;
					КонецЕсли; 
					
					Если Не ЗначениеЗаполнено(Соединение.НомерСоединения) Тогда
						Продолжить;
					КонецЕсли;
					
					Если Не ЗначениеЗаполнено(Соединение.НомерСеанса) Тогда
						Продолжить;
					КонецЕсли;
					
					ПрофильСоединения = "\\"+Соединение.ИмяКомпьютера+"\"+Соединение.Пользователь.Имя;
					
					Если Соединение.НомерСоединения <> НомерСоединенияИнформационнойБазы() И ПрофильСоединения = ПрофильВхода Тогда
						Если Сеть.СписокПроцессовЛокально().Количество() > 1 Тогда
							Возврат ВыходПоОшибке("Рабочее место с профилем входа """ + ПрофильВхода + """ запущено в другом сеансе!");
						Иначе
							Соединитель = Новый COMObject("V83.COMConnector");
							Агент = Соединитель.ConnectAgent(ПараметрыСеанса.ТекущаяИБ.СерверХост);
							Кластеры = Агент.GetClusters();
							Кластер = Кластеры.GetValue(0);
							
							Агент.Authenticate(Кластер, "", "");
							Сеансы = Агент.GetSessions(Кластер).Выгрузить();
							Для Каждого Сеанс Из Сеансы Цикл
								Если Сеанс.SessionID = Соединение.НомерСеанса Тогда
									Агент.TerminateSession(Кластер, Сеанс);	
								КонецЕсли;
							КонецЦикла;
							
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
				Для Каждого Сеанс Из ПолучитьСеансыИнформационнойБазы() Цикл
					Если НомерСеансаИнформационнойБазы() <> Сеанс.НомерСеанса Тогда
						Если НРег(Сеанс.ИмяКомпьютера) = НРег(ИмяКомпьютера()) Тогда
							
							Соединитель = Новый COMObject("V83.COMConnector");
							Агент = Соединитель.ConnectAgent(ПараметрыСеанса.ТекущаяИБ.СерверХост);
							Кластеры = Агент.GetClusters();
							Кластер = Кластеры.GetValue(0);
							
							Агент.Authenticate(Кластер, "", "");
							Sessions = Агент.GetSessions(Кластер).Выгрузить();
							Для Каждого Session Из Sessions Цикл
								Если Session.SessionID = Сеанс.НомерСеанса Тогда
									Агент.TerminateSession(Кластер, Session);	
								КонецЕсли;
							КонецЦикла;
							
						КонецЕсли;
					КонецЕсли;
				КонецЦикла;
				
			Исключение
				ЗаписьЖурналаРегистрации("РМ.Ошибка завершения сеанса",УровеньЖурналаРегистрации.Ошибка, ,,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
			
		КонецЕсли;
	КонецЕсли; 
	
	Если глРабочееМесто.ПометкаУдаления Тогда
		Возврат ВыходПоОшибке("Рабочее место """ + глРабочееМесто + """ помечено на удаление!
			|Обратитесь к администратору...");
	КонецЕсли;	
	
	// Чтение параметров РМ через форму настройки для контроля соответствия версии и релизу.
	// Заполняется глобальная переменная-структура глПараметрыРМ,
	// ключи структуры соответствуют именам реквизитов формы НастройкаРМ
	
	НастройкаРМ = Справочники.РабочиеМеста.ПолучитьФорму("НастройкаРМ");
	НастройкаРМ.СправочникОбъект = глРабочееМесто.ПолучитьОбъект();
	Если НЕ НастройкаРМ.ПроверкаПараметров() Тогда
		Возврат ВыходПоОшибке("Рабочее место """ + глРабочееМесто + """ не настроено!
			|Обратитесь к администратору...");
	КонецЕсли;
	НастройкаРМ.СохранитьПараметры(глПараметрыРМ);
	
	Лояльность_Версия = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(глРабочееМесто.МестоРеализации, "Лояльность_Версия");
	Если ЗначениеЗаполнено(Лояльность_Версия) Тогда
		Лояльность.УстановитьПараметрСеанса_ВерсияЛояльности(Лояльность_Версия);	
	КонецЕсли;                                                                      
	// интерфейсные объекты можно создавать только после получения параметров РМ
	глОжидание = Обработки.Ожидание.Создать();
	
	// ----------------------------------------------------------------------
	// Подключение торгового оборудования
	глОжидание.Начало("Запуск системы", "Подключение торгового оборудования...");
	
	МассивТО = ПолучитьМассивПодключаемогоТО();
	ТаблицаОшибок = Новый ТаблицаЗначений;
	тоВыполнитьПодключениеОтключение("Подключить", Ложь, МассивТО, ТаблицаОшибок);
	
	Если ТаблицаОшибок.Количество() > 0 Тогда
		
		ТекстОшибки = "";
		Для каждого Ошибка Из ТаблицаОшибок Цикл
			ТекстОшибки = ТекстОшибки + Ошибка.ТО.Наименование + ": " + Ошибка.Описание + " ( " + Ошибка.Подробно + " )" + Символы.ПС;
		КонецЦикла;
		
		Возврат ВыходПоОшибке(ТекстОшибки);
	
	КонецЕсли;
	
	// ----------------------------------------------------------------------
	// если основной режим работы - доставка, то это многое меняет :)
	глДоставкаОсновнойРежим = глВерсия=3 И глПараметрыРМ.ДоставкаЕсть И глПараметрыРМ.ДоставкаРежимИспользования<>1;
	
	// ----------------------------------------------------------------------
	// проверка наличия хотя бы одного элемента в справочнике Сотрудники
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1 Ссылка ИЗ Справочник.Сотрудники ГДЕ НЕ ПометкаУдаления И НЕ ЭтоГруппа");
	Выборка = Запрос.Выполнить().Выбрать();
	Если НЕ Выборка.Следующий() Тогда
		Возврат ВыходПоОшибке("Нет доступа!
			|Нужно завести хотя бы одного сотрудника!");
	КонецЕсли; 
	
	// ----------------------------------------------------------------------
	//запись события запуска системы
	ИнтерфейсРМ.ЗаполнитьТаблицуСобытий();
	
	Если РежимТестирования Тогда
		ИнтерфейсРМ.ЗаписьСобытия(Справочники.События.ЗапускРежимТестирования, , глРабочееМесто);
	Иначе
		ИнтерфейсРМ.ЗаписьСобытия(Справочники.События.ЗапускРМ);
	КонецЕсли; 
	
	глОжидание.Конец();
	
	// пользователь по умолчанию
	Если глПараметрыРМ.ПользовательВходБезАвторизации Тогда
		глПользователь = глПараметрыРМ.ПользовательПоУмолчанию;
	КонецЕсли; 
	
	Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы();	
	глПараметрыРМ.Вставить("НомерКассы", глПараметрыРМ.ККМ.КодСУП);	
	ОткрытьЧек();
	
	Возврат РезультатОткрытия;
	
КонецФункции         

Функция ВыходПоОшибке(ТекстОшибки)
	Возврат Новый Структура("Ошибка,ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", Истина, ТекстОшибки, "Произвести попытку перезапуска?", "ЗакрытьПриложение");	
КонецФункции

// Формирование массива подключаемого на РМ торгового оборудования 
//
Функция ПолучитьМассивПодключаемогоТО()
	
	МассивТО = Новый Массив;
	
	ЕстьСчитыватель = Ложь;
	Для каждого ТО Из глПараметрыРМ.СписокСУ Цикл
		МассивТО.Добавить(ТО.Значение);
		Если Найти("РидерМК,Проксимити,ПроксимитиPERCo", ТО.Значение.КодМодели) Тогда
			ЕстьСчитыватель = Истина;
		КонецЕсли; 
	КонецЦикла;
	глПараметрыРМ.Вставить("ЕстьСчитыватель", ЕстьСчитыватель);
	
	Если глВерсия=3 Тогда
		Для каждого ТО Из глПараметрыРМ.СписокКЭП Цикл
			МассивТО.Добавить(ТО.Значение);
		КонецЦикла;
		
		Если глПараметрыРМ.РегистрацияСобытийВидеоЕсть Тогда
			МассивТО.Добавить(глПараметрыРМ.РегистрацияСобытийВидеонаблюдение);
		КонецЕсли; 
	КонецЕсли; 
	
	// ККМ и Принтеры не занимают порты постоянно, поэтому для корректной проверки подключаем их после сканеров
	// и прочих дисплеев, которые захватывают порт на все время работы
	Если глПараметрыРМ.ККМЕсть Тогда
		МассивТО.Добавить(глПараметрыРМ.ККМ);
	КонецЕсли;
	
	Если глПараметрыРМ.ККМЕстьДоп Тогда
		Для каждого ТО Из глПараметрыРМ.ККМСписокДоп Цикл
			МассивТО.Добавить(ТО.Значение);
		КонецЦикла;
	КонецЕсли;
	
	Для каждого СтрокаГП Из глПараметрыРМ.ГруппыПечати.Строки Цикл
		Если НЕ СтрокаГП.ПроверкаСвязи Тогда
			Продолжить;
		КонецЕсли; 
		
		Если ЗначениеЗаполнено(СтрокаГП.Принтер) Тогда
			Принтер = СтрокаГП.Принтер;
		Иначе
			Попытка
				Принтер = СтрокаГП.Группа.Оборудование[0].Принтер;
			Исключение
				Продолжить;
			КонецПопытки;
		КонецЕсли; 
		
		МассивТО.Добавить(Принтер);
	КонецЦикла;
	
	Если глПараметрыРМ.ПечатьСчета Тогда
		МассивТО.Добавить(глПараметрыРМ.ПечатьСчетаПринтер);
	КонецЕсли; 
	
	Возврат МассивТО;
	
КонецФункции

Процедура ОткрытьЧек() Экспорт
	
	Если Найти(глПараметрыРМ.ККМ, "автономная") Тогда
		НомерЧека = 999;
		НомерСмены = 999;	
		глПараметрыРМ.Вставить("НомерТекущегоЧека", НомерЧека);
		глПараметрыРМ.Вставить("НомерСмены",  НомерСмены);
		Возврат;
	КонецЕсли;
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ,глПараметрыРМ);
	Параметры = Новый Структура;
	Параметры.Вставить("Кассир", Строка(глПользователь));
	Параметры.Вставить("ТипЧека", Ложь);
	ПараметрыВыходные = Новый Массив;
	Попытка
		Р = Обработка_ККМ.ВыполнитьКоманду("ПолучитьТекущееСостояние", Параметры, ПараметрыВыходные);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Если ПараметрыВыходные.Количество() > 2 Тогда
		глПараметрыРМ.Вставить("НомерТекущегоЧека", ПараметрыВыходные.НомерЧека);
		глПараметрыРМ.Вставить("НомерСмены",  ПараметрыВыходные.НомерСмены);
	КонецЕсли;
	ПоказатьОшибкуККМ(ПараметрыВыходные);
	
КонецПроцедуры

Функция ОткрытьКассовуюСмену() Экспорт
	
	// основная касса
	ККМ_Ссылка = глПараметрыРМ.ККМ;
	ККМ = ККМ_Ссылка.ПолучитьОбъект();
	Обработка_ККМ = Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);
	
	// поиск и закрытие вчерашней открытой смены ККТ
	ВыходныеПараметры = Новый Структура;
	ВходныеПараметры = Новый Структура;
	Попытка
		Ответ = Обработка_ККМ.ВыполнитьКоманду("ПолучитьТекущееСостояние", ВходныеПараметры, ВыходныеПараметры);
	Исключение
		Возврат СтруктураОшибки(Истина, "Ошибка ККМ", ОписаниеОшибки(), "СервисноеМеню");
	КонецПопытки;
	Если НЕ Ответ Тогда
		
		ТекстОшибки = "";
		Если ВыходныеПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = СтрСоединить(ВыходныеПараметры.ОписаниеОшибки, Символы.ПС);
		КонецЕсли;
		Возврат СтруктураОшибки(Истина, "Текущее состояние ККТ", ТекстОшибки, "СервисноеМеню");

	ИначеЕсли ВыходныеПараметры.СменаОткрыта И НачалоДня(ВыходныеПараметры.ДатаСменыККТ) <> НачалоДня(ТекущаяДата()) Тогда
		
		РезультатЗакрытия = ЗакрытьКассовуюСмену();
		Если РезультатЗакрытия.Ошибка Тогда
			Возврат РезультатЗакрытия;
		КонецЕсли;

	КонецЕсли;
	
	ДокСмены = ПолучитьСменуКассы(ККМ_Ссылка);
	Если ДокСмены.Пустая() Тогда

		СменаТТ = ИнтерфейсРМ.ТекущаяСмена();

		ВходныеПараметры = Новый Структура;
		ВыходныеПараметры = Новый Структура;
		ВходныеПараметры.Вставить("Кассир", Строка(глПользователь));
		
		Попытка
			Ответ = Обработка_ККМ.ВыполнитьКоманду("ОткрытьСмену", ВходныеПараметры, ВыходныеПараметры);
		Исключение
			Возврат СтруктураОшибки(Истина, "Ошибка ККМ", ОписаниеОшибки(), "СервисноеМеню");
		КонецПопытки;
		
		Если НЕ Ответ Тогда
			
			ТекстОшибки = "";
			Если ВыходныеПараметры.Свойство("ОписаниеОшибки") Тогда
				ТекстОшибки = СтрСоединить(ВыходныеПараметры.ОписаниеОшибки, Символы.ПС);
			КонецЕсли;
			Возврат СтруктураОшибки(Истина, "Ошибка Открытия смены", ТекстОшибки, "СервисноеМеню");
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат СтруктураОшибки(, "Успешно", "Смена ККМ открыта");
	
КонецФункции  

Функция ЗакрытьКассовуюСмену() Экспорт 
	
	СменаТТ = ИнтерфейсРМ.ТекущаяСмена();
	
	// основная касса
	ККМ_Ссылка = глПараметрыРМ.ККМ;
	
	ККМ = ККМ_Ссылка.ПолучитьОбъект();
	Обработка_ККМ = Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);
	
	ПростоЗакрыть = Ложь;
	СменаКасса = ПолучитьСменуКассы(ККМ_Ссылка);
	Если СменаКасса.Пустая() Тогда
		// добавим проверку на смену из ФН если это он
		Если СтрНайти(Врег(ккм.ИмяОбработки),"ФР_АТОЛ1") <> 0 Тогда
			ВходныеПараметры = Новый Структура;
			ВыходныеПараметры = Новый Структура;
			Ответ = Обработка_ККМ.ВыполнитьКоманду("ПолучитьТекущееСостояние", ВходныеПараметры, ВыходныеПараметры);
			Если Ответ Тогда
				Если ВыходныеПараметры.Свойство("СменаОткрыта") и ВыходныеПараметры.СменаОткрыта Тогда
					// получим последнюю открытую смену по ККМ
					СменаКасса = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьПоследнююНеЗакрытуюСменуПоНомеру(глПараметрыРМ.ККМ.КодСуп, ВыходныеПараметры.НомерСмены);
					Если НЕ СменаКасса.Пустая() ТОгда
						ПростоЗакрыть = Истина;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
		
	
	Попытка
		ОбъектТерминал = глПараметрыРМ.ПлатежнаяСистема.ПолучитьОбъект();
		Обработка_ПС = Обработка_ПС;
		РезультатИнит = ИнициализацияТО(ОбъектТерминал, Обработка_ПС, глПараметрыРМ);
		ОтветПС = Истина;
		ОтветККТ = Истина;
	Исключение
		Возврат СтруктураОшибки(Истина, "Ошибка платежного терминала", "", "СервисноеМеню");
	КонецПопытки;
	ВходныеПараметры = новый Структура;
	ВыходныеПараметры = Новый Массив;
	
	
	Попытка
		ОтветПС = Обработка_ПС.ВыполнитьКоманду("ИтогиДняПоКартам", ВходныеПараметры, ВыходныеПараметры);
		
		Если НЕ ОтветПС Тогда
			Возврат СтруктураОшибки(Истина, "Ошибка платежного терминала", ВыходныеПараметры[0], "СервисноеМеню");
		Иначе
			Строки = ВыходныеПараметры[0].Строки;
			
			// сформируем записи в ext по закрытию смены по банку
			Коннект = sql.ПодключитьсяКloyality_ext();
			Если Коннект = Неопределено Тогда
				ЗаписьЖурналаРегистрации("Подключение к базе", УровеньЖурналаРегистрации.Ошибка,,,"ошибка подключения к серверу при записи Банковской смены");
			Иначе			
				ТекстЗапроса = "
				|begin
				|Insert into [Loyality_ext].[dbo].[БанковскиеСмены]
				|			(Дата
				|			,ТТ
				|			,[НомерККМ]
				|			,[СлипЗакрытия]
				|			,[Сумма])
				|Values
				|			('&ДатаДок'
				|			,&КодТТ
				|			,&НомерККМ
				|			,'&СлипЗакрытия'
				|			,&Сумма)
				|end";
				
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ДатаДок",Формат(ТекущаяДата(),"ДФ='yyyyMMdd HH:mm:ss'; ДП='40010101 00:00:00'"));
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&КодТТ",формат(глРабочееМесто.Фирма.КодТТ,"ЧН=0; ЧГ=0"));
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&НомерККМ",Формат(глПараметрыРМ.ККМ.КодСуп,"ЧН=0; ЧГ=0"));
				СуммаИтого = 0;
				ТекстСлип = "";
				ТипБлока = 0;
				Для инд = 0 по Строки.Количество() - 1 Цикл
					СтрокаТекста = Строки[инд];
					СтрокаТекста = СтрЗаменить(СтрокаТекста,"""","""""");
					СтрокаТекста = СтрЗаменить(СтрокаТекста,"'","""""");
					ТекстСлип = ТекстСлип + СтрокаТекста + Символы.ПС;
					Если СтрНайти(ВРег(СтрокаТекста),"ОПЛАТА") <> 0 Тогда
						ТипБлока = 1;
					ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ВОЗВРАТ") <> 0 Тогда
						ТипБлока = -1;
					ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ОТМЕНА") <> 0 Тогда
						ТипБлока = 0;
					КонецЕсли;
					Если СтрНайти(ВРег(СтрокаТекста),"ВСЕГО ОПЕРАЦИЙ:") <> 0 Тогда
						Попытка
							СтрокаТекстаСумма = Строки[инд + 1];
							СуммаОп = Число(СокрЛП(СтрЗаменить(ВРег(СтрокаТекстаСумма),"НА СУММУ:","")));
						Исключение
							СуммаОп = 0;
						КонецПопытки;
						СуммаИтого = СуммаИтого + ТипБлока * СуммаОп;
					КонецЕсли;
				КонецЦикла;
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&СлипЗакрытия",ТекстСлип);
				ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&Сумма",формат(СуммаИтого,"ЧРД=.; ЧН=0; ЧГ=0"));
				
				
				Отказ = Ложь;
				ТекстОшибки = "";
				SQL.ВыполнитьЗапрос(Коннект, ТекстЗапроса, Отказ, ТекстОшибки);
				Если Отказ Тогда 
					ЗаписьЖурналаРегистрации("Запись закрытия смены по СБ", УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
				КонецЕсли;
			КонецЕсли;
			
			Если глПараметрыРМ.ПечататьСлипПриЗакрытииСмены Тогда
				ВходныеПараметры = новый Структура;
				ВходныеПараметры.Вставить("Строки",Строки);
				ВыходныеПараметры = новый Структура;
				ОтветККТ = Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста", ВходныеПараметры, ВыходныеПараметры);
				Если не ОтветККТ Тогда
					Если ВыходныеПараметры.Свойство("Описаниеошибки") Тогда
						ТекстОшибки = СтрСоединить(ВыходныеПараметры.ОписаниеОшибки);
						Если СтрНайти(ТекстОшибки,"Отчет с гашением прерван. Вход в режим невозможен") = 0 
							ИЛИ СтрНайти(ТекстОшибки,"Смена превысила 24 часа") = 0 Тогда
								// все ок
						Иначе
							Возврат СтруктураОшибки(Истина, "Ошибка платежного терминала", ТекстОшибки, "СервисноеМеню");	
						КонецЕсли;
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
	Исключение
//DeBuG		Возврат СтруктураОшибки(Истина, "Ошибка платежного терминала", "", "ЗакрытьПриложение");
	КонецПопытки;
	
		
	
	ВходныеПараметры = новый Структура;
	ВыходныеПараметры = новый Структура;
	ВходныеПараметры.Вставить("Кассир",Строка(глПользователь));
	
	Попытка
		ОтветЗ = Обработка_ККМ.ВыполнитьКоманду("ЗакрытьСмену", ВходныеПараметры, ВыходныеПараметры);
	Исключение
		Возврат СтруктураОшибки(Истина, "Ошибка ККМ", ОписаниеОшибки(), "СервисноеМеню");
	КонецПопытки;
	
	Если НЕ ОтветЗ Тогда
		
		ТекстОшибки = "";
		Если ВыходныеПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = СтрСоединить(ВыходныеПараметры.ОписаниеОшибки);
		КонецЕсли;
		Возврат СтруктураОшибки(Ложь, "Ошибка Закрытия смены", ТекстОшибки, "СервисноеМеню");

	Иначе	
		// формирование документа Закрытия смены Касса
	
		ЗакрытиеСмены = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьДокументЗакрытияСмены(СменаКасса).ПолучитьОбъект();//Документы.Касса_ЗакрытиеСмены.СоздатьДокумент();
		ЗакрытиеСмены.Автор = глПользователь;
		ЗакрытиеСмены.Дата = ТекущаяДатаСеанса();
		ЗакрытиеСмены.СменаТТ =  СменаТТ;
		ЗакрытиеСмены.СменаКассы = СменаКасса;
		ЗакрытиеСмены.ПараметрыСмены = Новый ХранилищеЗначения(ВыходныеПараметры);
		ЗакрытиеСмены.РабочееМесто = глРабочееМесто;
		ЗакрытиеСмены.Совпало = ПроверитьСуммы(ВыходныеПараметры, глРабочееМесто, СменаКасса);
		
		Если не ИнтерфейсРМ.ПопыткаДействияСОбъектом(ЗакрытиеСмены,"Объект.Записать(РежимЗаписиДокумента.Проведение)") Тогда
			//Ответ = Ложь;
		КонецЕсли;
		Если глПараметрыРМ.Свойство("НомерТекущегоЧека") Тогда
			глПараметрыРМ.НомерТекущегоЧека = 1;
		КонецЕсли;
	КонецЕсли;
	
	Возврат СтруктураОшибки(, "Успешно", "Смена ККМ закрыта");

КонецФункции  

Функция ПолучитьСменуКассы(Касса, ТекущийДень = Истина) Экспорт 
	
	ШаблонЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СУММА(влож.открытий), 0) > ЕСТЬNULL(СУММА(влож.Закрытий), 0)
	|			ТОГДА ИСТИНА
	|		ИНАЧЕ ЛОЖЬ
	|	КОНЕЦ КАК Рез,
	|	ВЫБОР
	|		КОГДА ЕСТЬNULL(СУММА(влож.открытий), 0) > ЕСТЬNULL(СУММА(влож.Закрытий), 0)
	|			ТОГДА Касса_ОткрытиеСмены.Ссылка
	|		ИНАЧЕ ЗНАЧЕНИЕ(Документ.Касса_ОткрытиеСмены.ПустаяСсылка)
	|	КОНЕЦ КАК Ссылка
	|ИЗ
	|	(ВЫБРАТЬ
	|		КОЛИЧЕСТВО(Касса_ОткрытиеСмены.Ссылка) КАК открытий,
	|		NULL КАК Закрытий
	|	ИЗ
	|		Документ.Касса_ОткрытиеСмены КАК Касса_ОткрытиеСмены
	|	ГДЕ
	|		НЕ Касса_ОткрытиеСмены.ПометкаУдаления
	|		И РАЗНОСТЬДАТ(Касса_ОткрытиеСмены.Дата, &Дата, ДЕНЬ) %1 0
	|		И Касса_ОткрытиеСмены.Касса = &Касса
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		NULL,
	|		КОЛИЧЕСТВО(Касса_ЗакрытиеСмены.Ссылка)
	|	ИЗ
	|		Документ.Касса_ЗакрытиеСмены КАК Касса_ЗакрытиеСмены
	|	ГДЕ
	|		НЕ Касса_ЗакрытиеСмены.ПометкаУдаления
	|		И РАЗНОСТЬДАТ(Касса_ЗакрытиеСмены.СменаКассы.Дата, &Дата, ДЕНЬ) %1 0
	|		И Касса_ЗакрытиеСмены.СменаКассы.Касса = &Касса) КАК влож,
	|	Документ.Касса_ОткрытиеСмены КАК Касса_ОткрытиеСмены
	|ГДЕ
	|	НЕ Касса_ОткрытиеСмены.ПометкаУдаления
	|	И Касса_ОткрытиеСмены.Касса = &Касса
	|	И РАЗНОСТЬДАТ(Касса_ОткрытиеСмены.Дата, &Дата, ДЕНЬ) %1 0
	|
	|СГРУППИРОВАТЬ ПО
	|	Касса_ОткрытиеСмены.Ссылка
	|
	|УПОРЯДОЧИТЬ ПО
	|	Касса_ОткрытиеСмены.МоментВремени УБЫВ";

	Запрос = Новый Запрос;
	Запрос.Текст = СтрШаблон(ШаблонЗапроса, ?(ТекущийДень, "=", ">"));
				   
	Запрос.УстановитьПараметр("Касса", Касса);
	Запрос.УстановитьПараметр("Дата", ТекущаяДата());
	
	Выборка = Запрос.Выполнить().Выбрать();
	глПараметрыРМ = глПараметрыРМ;
	
	Если Выборка.Следующий() и не Выборка.Ссылка.Пустая() Тогда
		
		Если ТипЗнч(глПараметрыРМ) = Тип("Структура") Тогда
			глПараметрыРМ.Вставить("НомерСмены", Выборка.Ссылка.НомерСмены);
		КонецЕсли;
		Возврат Выборка.Ссылка;
	Иначе
		Если ТипЗнч(глПараметрыРМ) = Тип("Структура") Тогда
			глПараметрыРМ.Вставить("НомерСмены", 0);
		КонецЕсли;
	КонецЕсли; 
	
	Возврат Документы.ОткрытиеСмены.ПустаяСсылка();
	
КонецФункции

Функция ПроверитьСуммы(ПараметрыВх, РабочееМесто, СменаКасса)
	номерСмены = ПараметрыВх.НомерСмены;
	СуммаНал = ПараметрыВх.СуммаПриходНал- ПараметрыВх.СуммаВозвратПриходаНал;
	СуммаБНал = ПараметрыВх.СуммаПриходБНал - ПараметрыВх.СуммаВозвратПриходаБНал;
	Сравнилось = Ложь;
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЕСТЬNULL(СУММА(влож.Нал), 0) КАК Нал,
	               |	ЕСТЬNULL(СУММА(влож.БНал), 0) КАК БНал
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ЕСТЬNULL(ВЫБОР
	               |				КОГДА ПротоколРасчетовПротокол.ВариантОплаты = ЗНАЧЕНИЕ(Справочник.ВариантыОплаты.Наличные)
	               |					ТОГДА ВЫБОР
	               |							КОГДА ПротоколРасчетовПротокол.Ссылка.Заказ ССЫЛКА Документ.Заказ
	               |								ТОГДА ПротоколРасчетовПротокол.СуммаФакт
	               |							ИНАЧЕ -1 * ПротоколРасчетовПротокол.СуммаФакт
	               |						КОНЕЦ
	               |				ИНАЧЕ 0
	               |			КОНЕЦ, 0) КАК Нал,
	               |		ЕСТЬNULL(ВЫБОР
	               |				КОГДА ПротоколРасчетовПротокол.ВариантОплаты = ЗНАЧЕНИЕ(Справочник.ВариантыОплаты.Карта)
	               |					ТОГДА ВЫБОР
	               |							КОГДА ПротоколРасчетовПротокол.Ссылка.Заказ ССЫЛКА Документ.Заказ
	               |								ТОГДА ПротоколРасчетовПротокол.СуммаФакт
	               |							ИНАЧЕ -1 * ПротоколРасчетовПротокол.СуммаФакт
	               |						КОНЕЦ
	               |				ИНАЧЕ 0
	               |			КОНЕЦ, 0) КАК БНал
	               |	ИЗ
	               |		Документ.ПротоколРасчетов.Протокол КАК ПротоколРасчетовПротокол
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	               |			ПО ПротоколРасчетовПротокол.Ссылка.Заказ.Ссылка = ЗаказДопИнф.Заказ
	               |				И (ЗаказДопИнф.Статус = &Закрыт)
	               |	ГДЕ
	               |		ПротоколРасчетовПротокол.Ссылка.Заказ.НомерСмены = &НомерСмены
	               |		И ПротоколРасчетовПротокол.Ссылка.Заказ.РабочееМесто = &РабочееМесто
	               |		И ПротоколРасчетовПротокол.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ЕСТЬNULL(ВЫБОР
	               |				КОГДА ПротоколРасчетовПротокол.ВариантОплаты = ЗНАЧЕНИЕ(Справочник.ВариантыОплаты.Наличные)
	               |					ТОГДА ВЫБОР
	               |							КОГДА ПротоколРасчетовПротокол.Ссылка.Заказ ССЫЛКА Документ.Заказ
	               |								ТОГДА ПротоколРасчетовПротокол.СуммаФакт
	               |							ИНАЧЕ -1 * ПротоколРасчетовПротокол.СуммаФакт
	               |						КОНЕЦ
	               |				ИНАЧЕ 0
	               |			КОНЕЦ, 0),
	               |		ЕСТЬNULL(ВЫБОР
	               |				КОГДА ПротоколРасчетовПротокол.ВариантОплаты = ЗНАЧЕНИЕ(Справочник.ВариантыОплаты.Карта)
	               |					ТОГДА ВЫБОР
	               |							КОГДА ПротоколРасчетовПротокол.Ссылка.Заказ ССЫЛКА Документ.Заказ
	               |								ТОГДА ПротоколРасчетовПротокол.СуммаФакт
	               |							ИНАЧЕ -1 * ПротоколРасчетовПротокол.СуммаФакт
	               |						КОНЕЦ
	               |				ИНАЧЕ 0
	               |			КОНЕЦ, 0)
	               |	ИЗ
	               |		Документ.ПротоколРасчетов.Протокол КАК ПротоколРасчетовПротокол
	               |			ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ВозвратДопИнф КАК ВозвратДопИнф
	               |			ПО ПротоколРасчетовПротокол.Ссылка.Заказ.Ссылка = ВозвратДопИнф.Возврат
	               |				И (ВозвратДопИнф.Статус = &Закрыт)
	               |	ГДЕ
	               |		ПротоколРасчетовПротокол.Ссылка.Заказ.НомерСмены = &НомерСмены
	               |		И ПротоколРасчетовПротокол.Ссылка.Заказ.РабочееМесто = &РабочееМесто
	               |		И ПротоколРасчетовПротокол.Ссылка.Дата МЕЖДУ НАЧАЛОПЕРИОДА(&Дата, ДЕНЬ) И КОНЕЦПЕРИОДА(&Дата, ДЕНЬ)) КАК влож";
	Запрос.УстановитьПараметр("НомерСмены",номерСмены);
	Запрос.УстановитьПараметр("РабочееМесто",РабочееМесто);
	Запрос.УстановитьПараметр("Дата",СменаКасса.Дата);
	Запрос.УстановитьПараметр("Закрыт",Перечисления.СтатусыЗаказа.Закрыт);
	Выборка = Запрос.Выполнить().Выбрать();
	СуммаТТ = 0;
	Пока Выборка.Следующий() Цикл
		СуммаТТ = СуммаТТ + Выборка.Нал + Выборка.БНал;
		Если Выборка.Нал = Окр(СуммаНал,2) и Выборка.БНал = Окр(СуммаБНал,2) Тогда
			Сравнилось = Истина;
		КонецЕсли;
	КонецЦикла;
	Если НЕ Сравнилось И НЕ РабочееМесто.Тест Тогда // отправим почту
		ТекстПисьма = "Ошибка закрытия кассовой смены ТТ " + РабочееМесто + ". " + Символы.ПС + "Расхождения в суммах: Сумма по Документам ТТ - " + СуммаТТ + "." + Символы.ПС;
		ТекстПисьма = ТекстПисьма + "Сумма по ККМ - " + Окр((СуммаНал + СуммаБНал),2) + ".";
		Получатели = "disp_cto_kc@myasnov.ru;dez.admin.SUP@coolclever.ru";
//DeBuG		ЭлектроннаяПочта.ОтправитьОповещениеНаПочту("Ошибка закрытия ККМ",ТекстПисьма,Получатели); 
	КонецЕсли;
	Возврат Сравнилось;
КонецФункции

Функция СтруктураОшибки(Ошибка = Ложь, ТекстОшибки1 = "", ТекстОшибки2 = "", РезультатКнопкиОК = "СервисноеМеню")
	
	Возврат Новый Структура("Ошибка,ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", Ошибка, ТекстОшибки1, ТекстОшибки2, РезультатКнопкиОК);

КонецФункции

Функция ОтчетБезГашения() Экспорт
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ,Обработка_ККМ,глПараметрыРМ);
	ВхПараметры = новый Структура;
	ВыходныеПараметры = новый Структура;
	
	Попытка
		Ответ = Обработка_ККМ.ВыполнитьКоманду("НапечататьОтчетБезГашения",ВхПараметры,ВыходныеПараметры);
	Исключение
		Возврат СтруктураОшибки(Истина, "Ошибка ККМ", ОписаниеОшибки());
	КонецПопытки;
	
	Если НЕ Ответ Тогда
		ТекстОшибки = "";
		Если ВыходныеПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = СтрСоединить(ВыходныеПараметры.ОписаниеОшибки);
		КонецЕсли;
		Возврат СтруктураОшибки(Истина, "Ошибка Открытия смены", ТекстОшибки);
	КонецЕсли;
	
	Возврат СтруктураОшибки();
	
КонецФункции

Функция ОтчетСбербанк() Экспорт
	
	Попытка
		ОбъектТерминал = глПараметрыРМ.ПлатежнаяСистема.ПолучитьОбъект();
		Обработка_ПС = Обработка_ПС;
		РезультатИнит = ИнициализацияТО(ОбъектТерминал, Обработка_ПС, глПараметрыРМ);
		ВхПараметры = Новый Структура;
		ВыхПараметры = Новый Массив;
		
		Попытка
			Обработка_ПС.ВыполнитьКоманду("ОтчетПоСбербанку",ВхПараметры, ВыхПараметры);
		Исключение
			Возврат СтруктураОшибки(Истина, "Ошибка отчета", ОписаниеОшибки());
		КонецПопытки;
		
		Строки = ВыхПараметры[0].Строки;
		
		ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
		Обработка_ККМ=Обработка_ККМ;
		ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
		ВхПараметры = новый Структура;
		ВхПараметры.Вставить("Строки",Строки);
		ВыхПараметры = новый Структура;
		Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		Возврат СтруктураОшибки(Истина, "Ошибка отчета", ОписаниеОшибки());
	КонецПопытки;

	Возврат СтруктураОшибки();
	
КонецФункции

Функция ЗакрытиеДняСбербанк() Экспорт
	
	Попытка
		ОбъектТерминал = глПараметрыРМ.ПлатежнаяСистема.ПолучитьОбъект();
		Обработка_ПС = Обработка_ПС;
		РезультатИнит = ИнициализацияТО(ОбъектТерминал, Обработка_ПС, глПараметрыРМ);
		ВхПараметры = новый Структура;
		ВыходныеПараметры = Новый Массив;
		
		Попытка
			Ответ = Обработка_ПС.ВыполнитьКоманду("ИтогиДняПоКартам",ВхПараметры, ВыходныеПараметры);
		Исключение
			Возврат СтруктураОшибки(Истина, "Ошибка Платежного терминала", ОписаниеОшибки());
		КонецПопытки;
		
		Если НЕ Ответ Тогда
			ТекстОшибки = "";
			Если ВыходныеПараметры.Свойство("ОписаниеОшибки") Тогда
				ТекстОшибки = СтрСоединить(ВыходныеПараметры.ОписаниеОшибки);
			КонецЕсли;
			Возврат СтруктураОшибки(Истина, "Ошибка Итоги дня по картам", ТекстОшибки);
		КонецЕсли;
		
		Строки = ВыходныеПараметры[0].Строки;
		
		// сформируем записи в ext по закрытию смены по банку
		Коннект = sql.ПодключитьсяКloyality_ext();
		Если Коннект = Неопределено Тогда
			ЗаписьЖурналаРегистрации("Подключение к базе", УровеньЖурналаРегистрации.Ошибка,,,"ошибка подключения к серверу при записи Банковской смены");
		Иначе			
			ТекстЗапроса = "
			|begin
			|Insert into [Loyality_ext].[dbo].[БанковскиеСмены]
			|			(Дата
			|			,ТТ
			|			,[НомерККМ]
			|			,[СлипЗакрытия]
			|			,[Сумма])
			|Values
			|			('&ДатаДок'
			|			,&КодТТ
			|			,&НомерККМ
			|			,'&СлипЗакрытия'
			|			,&Сумма)
			|end";
			
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&ДатаДок",Формат(ТекущаяДата(),"ДФ='yyyyMMdd HH:mm:ss'; ДП='40010101 00:00:00'"));
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&КодТТ",формат(глРабочееМесто.Фирма.КодТТ,"ЧН=0; ЧГ=0"));
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&НомерККМ",Формат(глПараметрыРМ.ККМ.КодСуп,"ЧН=0; ЧГ=0"));
			СуммаИтого = 0;
			ТекстСлип = "";
			ТипБлока = 0;
			Для инд = 0 по Строки.Количество() - 1 Цикл
				СтрокаТекста = Строки[инд];
				СтрокаТекста = СтрЗаменить(СтрокаТекста,"""","""""");
				СтрокаТекста = СтрЗаменить(СтрокаТекста,"'","""""");
				ТекстСлип = ТекстСлип + СтрокаТекста + Символы.ПС;
				Если СтрНайти(ВРег(СтрокаТекста),"ОПЛАТА") <> 0 Тогда
					ТипБлока = 1;
				ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ВОЗВРАТ") <> 0 Тогда
					ТипБлока = -1;
				ИначеЕсли СтрНайти(ВРег(СтрокаТекста),"ОТМЕНА") <> 0 Тогда
					ТипБлока = 0;
				КонецЕсли;
				Если СтрНайти(ВРег(СтрокаТекста),"ВСЕГО ОПЕРАЦИЙ:") <> 0 Тогда
					Попытка
						СтрокаТекстаСумма = Строки[инд + 1];
						СуммаОп = Число(СокрЛП(СтрЗаменить(ВРег(СтрокаТекстаСумма),"НА СУММУ:","")));
					Исключение
						СуммаОп = 0;
					КонецПопытки;
					СуммаИтого = СуммаИтого + ТипБлока * СуммаОп;
				КонецЕсли;
			КонецЦикла;
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&СлипЗакрытия",ТекстСлип);
			ТекстЗапроса = СтрЗаменить(ТекстЗапроса,"&Сумма",формат(СуммаИтого,"ЧРД=.; ЧН=0; ЧГ=0"));
			
			
			Отказ = Ложь;
			ТекстОшибки = "";
			SQL.ВыполнитьЗапрос(Коннект, ТекстЗапроса, Отказ, ТекстОшибки);
			Если Отказ Тогда 
				ЗаписьЖурналаРегистрации("Запись закрытия смены по СБ", УровеньЖурналаРегистрации.Ошибка,,,ТекстОшибки);
			КонецЕсли;
			
		КонецЕсли;
		
		//
		
		ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
		Обработка_ККМ=Обработка_ККМ;
		ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);;
		ВхПараметры = новый Структура;
		ВхПараметры.Вставить("Строки",Строки);
		ВыхПараметры = новый Структура;
		Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста",ВхПараметры,ВыхПараметры);
	Исключение
		Возврат СтруктураОшибки(Истина, "Ошибка платежного терминала", ОписаниеОшибки());	
	КонецПопытки;
	
	Возврат СтруктураОшибки(, "Успешно", "Закрыта смена по СБ");
	
КонецФункции


#Область ПечатьПодвалаЛояльности

Функция КассаАвтономная()
	КассаАвтономная = Неопределено;
	глПараметрыРМ.Свойство("КассаАвтономная", КассаАвтономная);
	Если КассаАвтономная = Неопределено Тогда
		 КассаАвтономная = Найти(НРег(глПараметрыРМ.ККМ), "автономная");
		 глПараметрыРМ.Вставить("КассаАвтономная", КассаАвтономная);
	КонецЕсли;
	Если КассаАвтономная Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция СтруктураРезультата(Ошибка = 0, ТекстОшибки1 = "", ТекстОшибки2 = "", РезультатКнопкиОК = "")
	
	Возврат Новый Структура("Ошибка,ТекстОшибки1,ТекстОшибки2,РезультатКнопкиОК", Ошибка, ТекстОшибки1, ТекстОшибки2, РезультатКнопкиОК);
	
КонецФункции

Процедура ПечатьПодвалаЛояльности(Фирма = Неопределено, ККМСсылка, ЗаказСсылка, ПротоколРасчетовСсылка = Неопределено) Экспорт 
	
	ЗаписьЖурналаРегистрации("Оплата.ПечатьПодвалаЛояльности.До вызова", УровеньЖурналаРегистрации.Информация, , ЗаказСсылка);
	
	Если Фирма = Неопределено Тогда
		// Итоговый полвал
		Попытка ОбработкаОплаты_ПечатьПодвалаЛояльности(ККМСсылка, ЗаказСсылка) Исключение КонецПопытки;
	ИначеЕсли Фирма.МестоРеализации = ПредопределенноеЗначение("Справочник.МестаРеализации.Ресторан") Тогда
		РезультатПечатиЧека = Заказ_ПечатьЧека_ПечатьЧека(ККМСсылка, ЗаказСсылка, ПротоколРасчетовСсылка);
	Иначе
		Попытка ОбработкаОплаты_ПечатьПодвалаЛояльности(ККМСсылка, ПротоколРасчетовСсылка) Исключение КонецПопытки;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации("Оплата.ПечатьПодвалаЛояльности.После вызова", УровеньЖурналаРегистрации.Информация, , ЗаказСсылка);
		
КонецПроцедуры

// не для КП
Процедура ОбработкаОплаты_ПечатьПодвалаЛояльности(ККМСсылка, ПротоколРасчетовСсылка)
	
	Если ПустаяСтрока(ПротоколРасчетовСсылка.ПодвалЧека) Тогда
		Возврат;
	КонецЕсли; 
	
	ККМ = ККМСсылка.ПолучитьОбъект();
	Обработка_ККМ = Обработка_ККМ;
	ИнициализацияТО(ККМ, Обработка_ККМ, глПараметрыРМ);
	
	Если КассаАвтономная() Тогда
		Возврат;
	КонецЕсли;
	
	СтрокиПодвала = СтрРазделить(ПротоколРасчетовСсылка.ПодвалЧека, Символы.ПС);
	ПараметрыВходные = Новый Структура;
	ПараметрыВходные.Вставить("Строки", СтрокиПодвала);
	ПараметрыВходные.Вставить("ТипШрифта", 0);
//326	ПараметрыВходные.Вставить("МестоРеализации", ПротоколРасчетовСсылка.МестоРеализации);
	ПараметрыВыходные = ПараметрыВыходные;
	Обработка_ККМ.ВыполнитьКоманду("ПечатьТекста", ПараметрыВходные, ПараметрыВыходные);
	ПоказатьОшибкуККМ(ПараметрыВыходные);

КонецПроцедуры

// для КП
Функция Заказ_ПечатьЧека_ПечатьЧека(ККМСсылка, ЗаказСсылка, ПротоколРасчетовСсылка)
	
	Если ПустаяСтрока(ПротоколРасчетовСсылка.ПодвалЧека) И ПустаяСтрока(ЗаказСсылка.ПодвалЧека) Тогда
		Возврат СтруктураРезультата();
	КонецЕсли; 
	
	ГруппаОплаты = Неопределено;
	
	ЗаказДопИнф = РегистрыСведений.ЗаказДопИнф.СоздатьМенеджерЗаписи();
	ЗаказДопИнф.Заказ = ЗаказСсылка;
	ЗаказДопИнф.Прочитать();
	
	ОбработкаПечати = ИнтерфейсРМ.ПолучитьОбъектОбработки("ПечатьЧека");
	ОбработкаПечати.УстановкаНачальныхЗначений();
	ОбработкаПечати.ККМ = ККМСсылка;
	ОбработкаПечати.Заказ = ЗаказСсылка;
	ОбработкаПечати.ЗаказДопИнф = ЗаказДопИнф;
	ОбработкаПечати.ФоновыйРежим = Истина;
	ОбработкаПечати.Текст1 = ЗаказСсылка.ПодвалЧека;
	
	ЧекПрошел = ОбработкаПечати.ПечатьЧека(ПротоколРасчетовСсылка.Протокол, ПротоколРасчетовСсылка.ИтогСуммаФакт, ГруппаОплаты);
	
	Если НЕ ЧекПрошел Тогда
		Возврат СтруктураРезультата(Истина, ОбработкаПечати.Текст1, ОбработкаПечати.Текст2); 
	КонецЕсли;
	
	Возврат СтруктураРезультата();
	
КонецФункции

#КонецОбласти


#КонецЕсли
