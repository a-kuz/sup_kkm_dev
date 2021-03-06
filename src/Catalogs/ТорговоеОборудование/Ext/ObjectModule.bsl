﻿
#Если Клиент Тогда

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Открывает нужную обработку обслуживания ТО для настройки параметров,
// с выводом диалога выбора профиля, если надо.
// Вызывается из формы элемента и формы списка.
//
// Параметры:
//  ПараметрыСтр - ссылка на реквизит справочника ТО Параметры,
//                 нужен для вызова из формы списка.
//
Процедура НастройкаПараметров(ПараметрыСтр) Экспорт
	
	Перем ОбработкаОбслуживания;
	
	Если ТипПрофиля = 1 Тогда
		Профиль = "Все станции\Все пользователи";
		
	Иначе
		ТаблицаПрофилей		= ПолучитьТаблицуПрофилей();
		ФормаВыбораПрофиля	= ПолучитьФорму("ВыборПрофиля");
		ФормаВыбораПрофиля.ТаблицаПрофилей	= ТаблицаПрофилей;
		ФормаВыбораПрофиля.ТипПрофиля		= ТипПрофиля;
		
		Профиль = ФормаВыбораПрофиля.ОткрытьМодально();
		Если ФормаВыбораПрофиля.Модифицированность Тогда
			ПараметрыСтр = ЗначениеВСтрокуВнутр(ТаблицаПрофилей);
		КонецЕсли; 
		Если НЕ ЗначениеЗаполнено(Профиль) Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	ПараметрыТО	= ПолучитьСтруктуруПараметров(Профиль);
	Результат	= ИнициализацияОбработкиОбслуживания(ПараметрыТО, ОбработкаОбслуживания);
	
	Если Результат.Ошибка Тогда
		Если Вопрос(Результат.Описание+Символы.ВК+Символы.ПС+Результат.Подробно + Символы.ПС + "Продолжить?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	ФормаНастройки = ОбработкаОбслуживания.ПолучитьФорму();
	ФормаНастройки.ОписаниеПрофиля = Профиль;
	
	Если ФормаНастройки.ОткрытьМодально() <> "ОК" Тогда
		Возврат;
	КонецЕсли;
	
	Если ТипПрофиля = 1 Тогда
		ПараметрыСтр = ЗначениеВСтрокуВнутр(ОбработкаОбслуживания.ПараметрыТО);
	Иначе
		ТаблицаПрофилей.Найти(Профиль,"Профиль").Параметры = ОбработкаОбслуживания.ПараметрыТО;
		ПараметрыСтр = ЗначениеВСтрокуВнутр(ТаблицаПрофилей);
	КонецЕсли; 
	
КонецПроцедуры

// Вызывает процедуру ВыполнитьДействие() соответстующей обработки обслуживания.
//
// Параметры:
//  Объект            - объект справочника "Торговое оборудование".
//  Действие          – <Строка> – идентификатор действия.
//  ПараметрыДействия – <Произвольный> – параметр или структура параметров,
//                       необходимые для выполнения действия.
//
// Возвращаемое значение:
//   <Структура>   – результат действия, содержит обязательные свойства:
//                   Ошибка   - <Булево>, действие выполнено успешно или нет
//                   Описание - <Строка>, описание результата
//                   Подробно - <Строка>, подробное описание
//
Функция ВыполнитьДействие(Действие, ПараметрыДействия=Неопределено) Экспорт
	
	Перем ОбработкаОбслуживания;
	
	Если ПараметрыДействия = Неопределено Тогда
		ПараметрыДействия = Новый Структура;
	КонецЕсли; 
	
	//Возврат РаботаСокнами.toExecCommand(ЭтотОбъект, Действие, ПараметрыДействия);
	
	ПараметрыТО = ПолучитьСтруктуруПараметров();
	Результат = ИнициализацияОбработкиОбслуживания(ПараметрыТО, ОбработкаОбслуживания);
	
	Если Результат.Ошибка Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОбработкаОбслуживания.ВыполнитьДействие(Действие,ПараметрыДействия);
	
	Возврат ОбработкаОбслуживания.Результат;
КонецФункции

// Вызывает процедуру ВыполнитьДействие() соответстующей обработки обслуживания.
//
// Параметры:
//  Объект            - объект справочника "Торговое оборудование".
//  Действие          – <Строка> – идентификатор действия.
//  ПараметрыДействия – <Произвольный> – параметр или структура параметров,
//                       необходимые для выполнения действия.
//
// Возвращаемое значение:
//   <Структура>   – результат действия, содержит обязательные свойства:
//                   Ошибка   - <Булево>, действие выполнено успешно или нет
//                   Описание - <Строка>, описание результата
//                   Подробно - <Строка>, подробное описание
//
Функция ВыполнитьКоманду(Действие, ПараметрыВходные=Неопределено, ПараметрыВыходные=Неопределено) Экспорт
	
	Перем ОбработкаОбслуживания;
	
	Если ПараметрыВходные = Неопределено Тогда
		ПараметрыВходные = Новый Структура;
	КонецЕсли; 
	
	//Возврат TraktirFO.toExecCommand(ЭтотОбъект, Действие, ПараметрыДействия);
	
	ПараметрыТО = ПолучитьСтруктуруПараметров();
	Результат = ИнициализацияОбработкиОбслуживания(ПараметрыТО, ОбработкаОбслуживания);
	
	Если Результат.Ошибка Тогда
		Возврат Результат;
	КонецЕсли;
	
	ОбработкаОбслуживания.ВыполнитьКоманду(Действие,ПараметрыВходные, ПараметрыВыходные);
	
	Если ПараметрыВыходные.Свойство("Ошибка") Тогда
		Если ПараметрыВыходные.Ошибка = Истина Тогда
			
		КонецЕсли;
	КонецЕсли;
	
	Возврат ОбработкаОбслуживания.Результат;
КонецФункции

// Возвращает параметры ТО в виде структуры свойств.
// Без указания параметра Профиль, возвращается значение для текущего профиля,
// в соответствии с вариантом хранения параметром.
//
// Параметры
//  Объект   - объект справочника "Торговое оборудование".
//  Профиль  – <Строка> – описание профиля в виде <ИмяКомпьютера>\<ИмяПользователя>, если параметры хранятся,
//             для всех пользователей, то Профиль игнорируется.
//
// Возвращаемое значение:
//   <Структура> – структура параметров ТО.
//
Функция ПолучитьСтруктуруПараметров(Профиль="") Экспорт
	
	//Возврат РаботаСокнами.toGetPrmStruct(ЭтотОбъект, Профиль);
	
	Перем СтруктураПараметров;
	
	Если ТипПрофиля = 1 Тогда
		Попытка
			СтруктураПараметров = ЗначениеИзСтрокиВнутр(Параметры);
		Исключение
		КонецПопытки;
		
	Иначе
		Если Профиль = "" Тогда
			Профиль  = ВРег(ИмяКомпьютера())+"\"+?(ТипПрофиля=2,"Все пользователи",ИмяПользователя());
		КонецЕсли;
		ТаблицаПрофилей = ПолучитьТаблицуПрофилей();
		СтрокаТаблицы   = ТаблицаПрофилей.Найти(Профиль,"Профиль");
		
		Если СтрокаТаблицы <> Неопределено Тогда
			СтруктураПараметров = СтрокаТаблицы.Параметры;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТипЗнч(СтруктураПараметров) <> Тип("Структура") Тогда
		СтруктураПараметров = Новый Структура;
	КонецЕсли;
	
	Возврат СтруктураПараметров;
КонецФункции

// Возвращает таблицу профилей для данного ТО.
//
// Параметры:
//  Объект   - объект справочника "Торговое оборудование".
//
// Возвращаемое значение:
//  <Таблица значений> - колонки 
//                       Профиль - <строка>, имя профиля.
//                       ТипПрофиля - <строка>, тип профиля (1 - общие параметры, 2 - общие на компьютер, 3 - индивидуально).
//                       Параметры - <строка>, параметры профиля.
//
Функция ПолучитьТаблицуПрофилей()
	
	//Возврат РаботаСокнами.toGetProfileTable(Объект);
	
	ФлагНоваяТаблица = Ложь;
	
	Попытка
		ТаблицаПрофилей = ЗначениеИзСтрокиВнутр(Параметры);
		Если ТипЗнч(ТаблицаПрофилей) <> Тип("ТаблицаЗначений") Тогда
			ФлагНоваяТаблица = Истина;
		КонецЕсли;
	Исключение
		ФлагНоваяТаблица = Истина;
	КонецПопытки;
	
	Если ФлагНоваяТаблица Тогда
		
		ТаблицаПрофилей = Новый ТаблицаЗначений;
		ТаблицаПрофилей.Колонки.Добавить("Профиль"   , Новый ОписаниеТипов("Строка"));
		ТаблицаПрофилей.Колонки.Добавить("ТипПрофиля", Новый ОписаниеТипов("Число"));
		ТаблицаПрофилей.Колонки.Добавить("Параметры" ,Новый ОписаниеТипов("Структура"));
		
	КонецЕсли;
	
	Возврат ТаблицаПрофилей;
КонецФункции

// Выполняет создание и инициализацию обработки обслуживания.
//
// Параметры:
//  Объект                - объект справочника "Торговое оборудование".
//  ПараметрыТО           - структура параметров ТО.
//  ОбработкаОбслуживания - имя обработки обслуживания.
//
// Возвращаемое значение:
//   <Структура>   – результат действия, содержит обязательные свойства:
//                   Ошибка   - <Булево>, действие выполнено успешно или нет
//                   Описание - <Строка>, описание результата
//                   Подробно - <Строка>, подробное описание
//
Функция ИнициализацияОбработкиОбслуживания(ПараметрыТО, ОбработкаОбслуживания)
	
	Возврат ИнициализацияТО(ЭтотОбъект, ОбработкаОбслуживания, глПараметрыРМ);
	
КонецФункции

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Код) Тогда
		Сообщить("Необходимо задать код!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Сообщить("Необходимо задать наименование!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если ЭтоГруппа Тогда
		Возврат;
	КонецЕсли; 
	
	Если ОбработкаВнешняя И НЕ ЗначениеЗаполнено(ИмяОбработки) Тогда
		Сообщить("Необходимо указать обработку обслуживания!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	Если ЭтоНовый() И ИнформационнаяБаза.Пустая() Тогда
		ИнформационнаяБаза = ПараметрыСеанса.ТекущаяИБ;
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(Параметры) И ЗначениеЗаполнено(Ссылка.Параметры) Тогда
		Параметры = Ссылка.Параметры;
	КонецЕсли;
	
	Если КодВида = "ЭкранМеню" Тогда
		
		Попытка
			СтруктураПараметров = ЗначениеИзСтрокиВнутр(Параметры);	
			КаталогТоваров = СтруктураПараметров.КаталогТоваров;
			Если Ссылка.Параметры<>Параметры Тогда
				Константы.ДатаОбновленияПризнакаНаличияВПродаже.СоздатьМенеджерЗначения().ОбновитьЗначение();
			КонецЕсли;
		Исключение
			
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если КодВида = "ФР" Тогда
		ПроверяемыеРеквизиты.Добавить("Фирма");
	КонецЕсли;
КонецПроцедуры

