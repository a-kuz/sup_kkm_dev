﻿
#Если Клиент ИЛИ ВнешнееСоединение Тогда
	
// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
	//ТаблицаСотрудников.Очистить();
	//
	МассивБригад = Новый Массив;
	МассивУдаленных = Новый Массив;
	
КонецПроцедуры
 
// Описание функции
//
Функция ЗаблокироватьОткрытиеСмены() Экспорт
	
	Перем КемЗаблокирован;
	
	Если ИнтерфейсРМ.ЗаблокироватьОбъект(ДокОткрытияСмены, КемЗаблокирован) Тогда
		Возврат Истина;
	КонецЕсли;
	
	Текст1="Нет доступа!";
	Текст2="Открытие или закрытие смены уже выполняется на
			|"+КемЗаблокирован;
	ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
	
	Возврат Ложь;
	
КонецФункции
 
// Описание процедуры
//
Процедура ДобавитьСотрудника(Сотрудник, ПриОткрытии=Ложь) Экспорт
	
	СтрокаТЧПраваДоступа = Сотрудник.ПраваДоступа.Найти(глПараметрыРМ.МестоРеализации, "МестоРеализации");
	Если СтрокаТЧПраваДоступа = Неопределено Тогда
		Текст1="Нет доступа!";
		Текст2= "Сотруднику "+Сотрудник.Наименование+" не установлены права доступа в этом месте реализации...";
		//ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		Возврат;
	КонецЕсли;
	
	СтрокаТаблицы = ТаблицаСотрудников.Добавить();
	СтрокаТаблицы.Сотрудник = Сотрудник;
	СтрокаТаблицы.НаборПрав = СтрокаТЧПраваДоступа.НаборПрав;
	Если глВерсия > 1 Тогда
		СтрокаТаблицы.Пейджер	= Сотрудник.Пейджер;
	КонецЕсли; 
	
	Если НЕ ПриОткрытии Тогда
		//СообщитьНаПейджер(Сотрудник, "Состав смены", "Вы добавлены в состав смены.", "СоставСмены");
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДобавитьБригаду(Бригада) Экспорт
	
	Для Каждого СтрБригады Из Бригада.Сотрудники Цикл
		Если ТаблицаСотрудников.Найти(СтрБригады.Сотрудник,"Сотрудник") = Неопределено Тогда
			ДобавитьСотрудника(СтрБригады.Сотрудник);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Описание процедуры
//
Процедура ОбработкаВыбораСотрудника(Знач Сотрудник) Экспорт
	
	СтрокаТаблицы = ТаблицаСотрудников.Найти(Сотрудник,"Сотрудник");
	
	Если СтрокаТаблицы = Неопределено Тогда
		ДобавитьСотрудника(Сотрудник);
		
		Инд = МассивУдаленных.Найти(Сотрудник);
		Если Инд <> Неопределено Тогда
			МассивУдаленных.Удалить(Инд);
		КонецЕсли; 
		
	Иначе
		ТаблицаСотрудников.Удалить(СтрокаТаблицы);
		
		Если МассивУдаленных.Найти(Сотрудник) = Неопределено Тогда
			МассивУдаленных.Добавить(Сотрудник);
		КонецЕсли; 
		
		//СообщитьНаПейджер(Сотрудник, "Состав смены", "Вы удалены из состава смены.", "СоставСмены");
		
	КонецЕсли; 
	
КонецПроцедуры

// Описание процедуры
//
Процедура ОформитьВнесениеВыплату(Действие) Экспорт
	
	Перем ККМ,Пароль;
	
	Если НЕ ИнтерфейсРМ.ВыборККМ_ЗапросПароля( ККМ, Пароль ) Тогда
		Возврат;
	КонецЕсли;
	
	Сумма = ИнтерфейсРМ.ВводЧисла("Введите сумму", "Число", 12, 2);
	
	Если Сумма=0 ИЛИ Сумма=Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Текст1="Сумма: "+ФорматСумм(Сумма);
	Текст2="Оформить "+?(Действие="Внесение", "внесение в кассу?", "выплату из кассы?");
	Ответ = ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"ОК","","Esc=Отмена");
	Если Ответ="Отмена" Тогда
		Возврат;
	КонецЕсли;
	
	ОбработкаПечати = ИнтерфейсРМ.ПолучитьОбъектОбработки("ПечатьЧека");
	ОбработкаПечати.ККМ		= ККМ;
	ОбработкаПечати.Пароль	= Пароль;
	ОбработкаПечати.ПечатьВнесенияВыплаты(Действие, Сумма);
	
КонецПроцедуры

// Описание процедуры
//
Функция ДействияПриОткрытииЗакрытииСмены(Режим, ФлагКогда) Экспорт
	
	Если Не глПараметрыРМ.Свойство("Действия"+Режим) Тогда
		Возврат Истина;
	КонецЕсли;
	ТаблицаДействий = глПараметрыРМ["Действия"+Режим];
	
	Текст1 = ?(ФлагКогда=0, "До ", "После ") + ?(Режим="ПриОткрытииСмены", "открытия смены", "закрытия смены");
	
	Для каждого СтрокаДействий Из ТаблицаДействий Цикл
		
		Если СтрокаДействий.Когда<>ФлагКогда Тогда
			Продолжить;
		КонецЕсли;
		
		Если СтрокаДействий.Запрос Тогда
			
			Текст2="Выполнить следующее действие?
					|"+СтрокаДействий.Наименование;
			Ответ=ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"ОК","Пропуск","Esc=Отмена");
			
			Если Ответ="Отмена" Тогда
				Возврат Ложь;
			ИначеЕсли Ответ="Пропуск" Тогда
				Продолжить;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Лев(СтрокаДействий.Действие,9) = "ОтчетККМ_" ИЛИ СтрокаДействий.Действие = "СинхронизироватьВремяККМ" Тогда
			СписокККМ = глПараметрыРМ.ККМСписокДоп.Скопировать();
			СписокККМ.Вставить(0,глПараметрыРМ.ККМ);
			
			Для каждого ККМ Из СписокККМ Цикл
				Если ККМ.Значение.КодВида = "ФР" Тогда
					Если СтрокаДействий.Действие = "СинхронизироватьВремяККМ" Тогда
						ДействиеВыполнено = ИнтерфейсРМ.СинхронизироватьВремяККМ(ККМ.Значение, СтрокаДействий.Запрос);
					Иначе
						ДействиеВыполнено = ИнтерфейсРМ.ОтчетККМ( Сред(СтрокаДействий.Действие,10), ККМ.Значение )
					КонецЕсли;
					Если НЕ ДействиеВыполнено Тогда
						Возврат Ложь;
					КонецЕсли; 
				КонецЕсли;
			КонецЦикла;
			
		ИначеЕсли Лев(СтрокаДействий.Действие,6) = "Отчет_" Тогда
			
			//ФормированиеОтчетов.ПолучитьОтчетРМ( Сред(СтрокаДействий.Действие,7) );
			// В отчетах через второй "_" передается ПараметрФормирования.
			ДанныеОтчета	= СтрЗаменить(СтрокаДействий.Действие, "_", Символы.ПС); 
			ТекОтчет		= СтрПолучитьСтроку(ДанныеОтчета, 2);
			ТекПараметр		= ?(ЗначениеЗаполнено(СтрПолучитьСтроку(ДанныеОтчета, 3)), СтрПолучитьСтроку(ДанныеОтчета, 3), 0);
			ФормированиеОтчетов.ПолучитьОтчетРМ(ТекОтчет, ТекПараметр);
			
		ИначеЕсли Лев(СтрокаДействий.Действие,8) = "ОтчетПС_" Тогда
			Если НЕ Защита.ОтчетПлатежнойСистемы( Сред(СтрокаДействий.Действие,9) ) Тогда
				Возврат Ложь;
			КонецЕсли; 
			
		ИначеЕсли СтрокаДействий.Действие = "ВыгрузкаДанных" Тогда
			ВыгрузкаДанных();
			
		ИначеЕсли Лев(СтрокаДействий.Действие,9) = "Регламент" Тогда
			ПараметрОбработки = Новый Структура("Режим, ФлагКогда", Режим, ФлагКогда);
			Если НЕ ИнтерфейсРМ.ВыполнитьВнешнююОбработку(СтрокаДействий.ПараметрДействия, ПараметрОбработки) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		ИначеЕсли  СтрокаДействий.Действие = "ОткрытиеСмены" Тогда
			ДокОткрытияСмены.СоставСмены.Загрузить(ТаблицаСотрудников.Выгрузить());
			
			Если НЕ ИнтерфейсРМ.ПопыткаДействияСОбъектом( ДокОткрытияСмены, "Объект.Записать()" ) Тогда
				Возврат Ложь;
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;
КонецФункции

// Описание процедуры
//
Функция ПроверкаОткрытыхЗаказов(Молча = Ложь, МассивОшибок = Неопределено) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказДопИнф.Заказ.РабочееМесто КАК РабочееМесто
	|ИЗ
	|	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ.Товары КАК ЗаказТовары
	|		ПО ЗаказДопИнф.Заказ = ЗаказТовары.Ссылка
	|ГДЕ
	|	ЗаказДопИнф.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказа.Открыт)
	|	И НЕ ЗаказДопИнф.Заказ.ПометкаУдаления
	|	И ЗаказДопИнф.Заказ.Смена = &Смена
	|	И ЗаказТовары.Количество > 0");
	
	Запрос.УстановитьПараметр("Смена", ДокОткрытияСмены.Ссылка);
	Рез = Запрос.Выполнить();
	ТЗ = Рез.Выгрузить();
	
	ЕстьОткрытые = Не Рез.Пустой();
	Если ЕстьОткрытые Тогда
		Текст1="Ошибка закрытия смены";
		Текст2="В смене остались открытые заказы! Рабочие места:";
		РабочиеМестаСнезакрытыми = ТЗ.ВыгрузитьКолонку("РабочееМесто");
		стрРабочиеМеста = СтрСоединить(РабочиеМестаСнезакрытыми, Символы.ПС);
		Текст2 = Текст2 + Символы.ПС + стрРабочиеМеста;
		Если Не Молча Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
		КонецЕсли;
		Если Не МассивОшибок = Неопределено Тогда
			МассивОшибок.Добавить(Текст2);
		КонецЕсли; 	
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;

КонецФункции  

Функция ПроверкаКассовыхСмен(Молча = Ложь, МассивОшибок = Неопределено) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	Касса_ОткрытиеСмены.Ссылка
	|ИЗ
	|	Документ.Касса_ОткрытиеСмены КАК Касса_ОткрытиеСмены
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.Касса_ЗакрытиеСмены КАК Касса_ЗакрытиеСмены
	|		ПО Касса_ЗакрытиеСмены.СменаКассы = Касса_ОткрытиеСмены.Ссылка
	|ГДЕ
	|	Касса_ЗакрытиеСмены.Ссылка ЕСТЬ NULL 
	|	И касса_Открытиесмены.СменаТТ = &СменаТТ
	|	И НЕ Касса_ОткрытиеСмены.ПометкаУдаления");
	
	Запрос.УстановитьПараметр("СменаТТ", ДокОткрытияСмены.Ссылка);

	Рез = Запрос.Выполнить();
	Если Рез.Пустой() Тогда
		Возврат Истина;
	Иначе
		Текст1="Ошибка закрытия смены";
		Текст2="В смене остались открытые кассовые смены!
		|Закрытие смены не разрешено!
		|Закройте кассовые смены или обратитесь к администратору!";
		Если Не Молча Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
		КонецЕсли;
		Если Не МассивОшибок = Неопределено Тогда
			МассивОшибок.Добавить(Текст2);
		КонецЕсли; 
		Возврат Ложь;
	КонецЕсли;
КонецФункции

Функция ПроверкаНефискализированныхЗаказов(Молча = Ложь, МассивОшибок = Неопределено) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказДопИнф.Заказ КАК Заказ
	|ИЗ
	|	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ.Товары КАК ЗаказТовары
	|		ПО ЗаказДопИнф.Заказ = ЗаказТовары.Ссылка
	|ГДЕ
	|	ЗаказДопИнф.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказа.Закрыт)
	|	И НЕ ЗаказДопИнф.Заказ.ПометкаУдаления
	|	И НЕ ЗаказТовары.ДокументОплаты.Фискализирован
	|	И ЗаказДопИнф.Заказ.Смена = &Смена");

	Запрос.УстановитьПараметр("Смена", ДокОткрытияСмены.Ссылка);
	
	ЕстьНефискализированные = Не Запрос.Выполнить().Пустой();
	Если ЕстьНефискализированные Тогда
		Текст1="Ошибка закрытия смены";
		Текст2="В смене остались нефискализированные закрытые заказы!
		|Закрытие смены не разрешено!";
		Если Не Молча Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
		КонецЕсли;
		Если Не МассивОшибок = Неопределено Тогда
			МассивОшибок.Добавить(Текст2);
		КонецЕсли; 	
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции

Функция ПроверкаНеОтмененныхВегаисЗаказов(Молча = Ложь, МассивОшибок = Неопределено) Экспорт
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказДопИнф.Заказ
	|ИЗ
	|	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|ГДЕ
	|	НЕ ЗаказДопИнф.Заказ.ПометкаУдаления
	|	И ЗаказДопИнф.Заказ.Смена = &Смена
	|	И ЗаказДопИнф.ПротоколРасчетов.НеУдалосьОтправитьОтменуВегаис");

	Запрос.УстановитьПараметр("Смена", ДокОткрытияСмены.Ссылка);
	
	ЕстьНефискализированные = Не Запрос.Выполнить().Пустой();
	Если ЕстьНефискализированные Тогда
		Текст1="Ошибка закрытия смены";
		Текст2="В смене остались заказы, по которым не отправлена отмена в ЕГАИС!" + "
		|Закрытие смены не разрешено!";
		Если Не Молча Тогда
			ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
		КонецЕсли;
		Если Не МассивОшибок = Неопределено Тогда
			МассивОшибок.Добавить(Текст2);
		КонецЕсли; 
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
КонецФункции

Функция ЗакрытьСмену(МассивОшибок = Неопределено) Экспорт
	
	ЗакрытиеСменыВыполнено = Ложь;
	МассивОшибок = Новый Массив;
	
	Молча = глПараметрыРМ = Неопределено;
	
	Если Молча Тогда
		НачатьТранзакцию();
	КонецЕсли;
	
	ЗакрытьНезакрытыеОплаченныеЗаказы();
	ПроверкаКассовыхСмен(Молча, МассивОшибок);
	ПроверкаНефискализированныхЗаказов(Молча, МассивОшибок);
	ПроверкаНеОтмененныхВегаисЗаказов(Молча, МассивОшибок);
	ПроверкаОткрытыхЗаказов(Молча, МассивОшибок);
		
	ЗаписатьУходСРаботы();
	
	Если МассивОшибок.Количество() Тогда
		Если Молча Тогда
			ОтменитьТранзакцию();	
		КонецЕсли;               		
		Возврат Ложь;
	КонецЕсли;
	Если Не Молча Тогда
		НачатьТранзакцию();
	КонецЕсли;
	ДокЗакрытияСмены = Документы.ЗакрытиеСмены.СоздатьДокумент();
	ДокЗакрытияСмены.Дата = ТекущаяДата();
	ДокЗакрытияСмены.МестоРеализации = ДокОткрытияСмены.МестоРеализации;
	ДокЗакрытияСмены.Смена = ДокОткрытияСмены.Ссылка;
	ЗакрытиеСменыВыполнено = Ложь;		
	Если НЕ ИнтерфейсРМ.ПопыткаДействияСОбъектом( ДокЗакрытияСмены, "Объект.Записать()" ) Тогда
		ОтменитьТранзакцию();
		Возврат ЗакрытиеСменыВыполнено;
	Иначе
		ЗакрытиеСменыВыполнено = Истина;				
		ФормированиеОтчетовФО = Обработки.ФормированиеОтчетовФО.Создать();
		ФормированиеОтчетовФО.РежимПереформирования = Истина;
		ФормированиеОтчетовФО.ДатаС = НачалоДня(ДокОткрытияСмены.Дата);
		ФормированиеОтчетовФО.ДатаПо = КонецДня(ДокОткрытияСмены.Дата);
		ФормированиеОтчетовФО.СформироватьОтчеты(ДокОткрытияСмены.МестоРеализации);
		
		МенеджерЗаписи = РегистрыСведений.ТекущиеСмены.СоздатьМенеджерЗаписи();
		МенеджерЗаписи.МестоРеализации = ДокОткрытияСмены.МестоРеализации;
		МенеджерЗаписи.Прочитать();
		
		Если МенеджерЗаписи.Смена = ДокОткрытияСмены.Ссылка Тогда
			
			МенеджерЗаписи.Смена = Неопределено;
			Если НЕ ИнтерфейсРМ.ПопыткаДействияСОбъектом( МенеджерЗаписи, "Объект.Записать()" ) Тогда
				ОтменитьТранзакцию();
				Возврат ЗакрытиеСменыВыполнено;
			КонецЕсли;
		КонецЕсли;
		
		РегистрыСведений.ОткрытыеЗаказыПоКартам.СоздатьНаборЗаписей().Записать(Истина);
		ЗафиксироватьТранзакцию();
		
	КонецЕсли;
	
	Попытка
		ВыполнениеРегламентныхЗаданий.ОбработатьСпулЛояльности();
		ЛояльностьКлиентСервер.ПочиститьЛОГи();
	Исключение
	КонецПопытки;
	
	ИнтерфейсРМ.ЗаписьСобытия(Справочники.События.РежимАдминаЗакрытиеСмены, ДокОткрытияСмены.Ссылка, ДокОткрытияСмены.Номер);
	
	Оповестить("ИзменениеСмены");
	Возврат ЗакрытиеСменыВыполнено;
	
КонецФункции

Процедура ЗаписатьУходСРаботы() Экспорт
	
	Для Каждого СтрокаТС Из ДокОткрытияСмены.СоставСмены Цикл
		УчетРабочегоВремени.ОтметитьПриходУход(Ложь, СтрокаТС.Сотрудник,ДокОткрытияСмены.МестоРеализации,Истина);
	КонецЦикла; 
	
КонецПроцедуры

Функция ОткрытыеЗаказыОтсутствуют(ЗаказыДоставки = Ложь)
	
	// открытые заказы
	Запрос = Новый Запрос("
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗаказДопИнф.Заказ
	|ИЗ
	|	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|ГДЕ
	|	ЗаказДопИнф.Статус = ЗНАЧЕНИЕ(Перечисление.СтатусыЗаказа.Открыт)
	|	И НЕ ЗаказДопИнф.Заказ.ПометкаУдаления
	|	И ЗаказДопИнф.Заказ.МестоРеализации = &МестоРеализации	
	|");
	Запрос.УстановитьПараметр("МестоРеализации", глПараметрыРМ.МестоРеализации);
	
	Возврат Запрос.Выполнить().Пустой();
		
КонецФункции	

Процедура ЗакрытьНезакрытыеОплаченныеЗаказы()
	Запрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказДопИнф.Заказ КАК Заказ
	|ПОМЕСТИТЬ РеальноНезакрытыеЗаказы
	|ИЗ
	|	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.Заказ.Товары КАК ЗаказТовары
	|		ПО ЗаказДопИнф.Заказ = ЗаказТовары.Ссылка
	|ГДЕ
	|	ЗаказДопИнф.Статус = &Открыт
	|	И ЗаказТовары.Количество <> 0
	|	И ЗаказТовары.ДокументОплаты = ЗНАЧЕНИЕ(Документ.ПротоколРасчетов.ПустаяСсылка)
	|	И ЗаказТовары.СуммаРеализации <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ЗаказДопИнф.Заказ КАК Заказ
	|ИЗ
	|	РегистрСведений.ЗаказДопИнф КАК ЗаказДопИнф
	|		ЛЕВОЕ СОЕДИНЕНИЕ РеальноНезакрытыеЗаказы КАК РеальноНезакрытыеЗаказы
	|		ПО ЗаказДопИнф.Заказ = РеальноНезакрытыеЗаказы.Заказ
	|ГДЕ
	|	ЗаказДопИнф.Статус = &Открыт
	|	И РеальноНезакрытыеЗаказы.Заказ ЕСТЬ NULL");

	Запрос.УстановитьПараметр("Открыт", Перечисления.СтатусыЗаказа.Открыт);
	ТЗ = Запрос.Выполнить().Выгрузить();
	Для Каждого Т Из ТЗ Цикл
		ИнтерфейсРМ.ЗарегистрироватьЗавершениеПокупокПоЗаказу(Т.Заказ);
	КонецЦикла;

КонецПроцедуры

// Описание процедуры
//
Процедура ВыгрузкаДанных()
	
	глОжидание.Начало("Выгрузка данных", "Формирование отчетов продаж за смену...");
	
	ФормированиеОтчетовФО = Обработки.ФормированиеОтчетовФО.Создать();
	
	СписокСформированныхДокументов = ФормированиеОтчетовФО.СформироватьОтчеты( глПараметрыРМ.МестоРеализации);
	
	ПравилаВыгрузки = Константы.АвтообменПравилаВыгрузки.Получить();
	
	Если ЗначениеЗаполнено(СписокСформированныхДокументов) Тогда
		Если ЗначениеЗаполнено(ПравилаВыгрузки) Тогда
			
			глОжидание.Начало("Выгрузка данных", "Выгрузка данных за смену в файл...");
			
			СтруктураОтбора = Новый Структура;
			СтруктураОтбора.Вставить("ОтчетФО", СписокСформированныхДокументов);
			
			АвтообменДанными.ВыгрузитьДанныеXML( ПравилаВыгрузки, СтруктураОтбора);
			
			Текст1 = "Выгрузка данных";
			Текст2 = "Выгрузка данных  завершена!";
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
			
			ИнтерфейсРМ.ЗакрытьОкноСообщений();
		Иначе
			Текст1 = "Выгрузка данных";
			Текст2 = "Выгрузка невозможна.
					|Не указаны правила выгрузки!";
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
			
			ИнтерфейсРМ.ЗакрытьОкноСообщений();
		КонецЕсли;
	Иначе
		Текст1 = "Выгрузка данных";
		Текст2 = "Нет данных для выгрузки!";
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка",Текст1,Текст2,"","ОК","");
		
		ИнтерфейсРМ.ЗакрытьОкноСообщений();
		
	КонецЕсли;
	
	глОжидание.Конец();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ


#КонецЕсли
