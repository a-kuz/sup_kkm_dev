﻿&НаКлиенте
Перем ЗапущенныеПроцессы;

&НаСервере
Процедура ВыполнитьЗагрузкуТоваровНаСервере(ИБссылка, ЗапущенныеПроцессы)
	ЗапущенныеПроцессы.Добавить(УправлениеСерверамиПриложений.ВыполнитьЗагрузкуТоваров(ИБссылка));
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуТоваров(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьЗагрузкуТоваровНаСервере(ТД.Ссылка, ЗапущенныеПроцессы);
	ПодключитьОбработчикОжидания("ПроверитьЗапущенныеПроцессы",1);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКонфигурациюБД(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Т Из Элементы.Список.ВыделенныеСтроки Цикл
		ОбновитьКонфигурациюБДнаСервере(Элементы.Список.ДанныеСтроки(Т).Ссылка, ЗапущенныеПроцессы);
	КонецЦикла;
	
	ПодключитьОбработчикОжидания("ПроверитьЗапущенныеПроцессы",1);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьКонфигурациюБДнаСервере(ИБссылка, ЗапущенныеПроцессы)
	ЗапущенныеПроцессы.Добавить(УправлениеСерверамиПриложений.ОбновитьКонфигурациюБД(ИБссылка));
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьОбменНаУзле(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Для Каждого Т Из Элементы.Список.ВыделенныеСтроки Цикл
		ВыполнитьОбменНаУзлеНаСервере(Элементы.Список.ДанныеСтроки(Т).Ссылка, ЗапущенныеПроцессы);
	КонецЦикла;

	ОтключитьОбработчикОжидания("ПроверитьЗапущенныеПроцессы");
	ПодключитьОбработчикОжидания("ПроверитьЗапущенныеПроцессы",5);
	Результат.УстановитьТекст("Процесс запущен. Ожидайте ...");
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьОбменНаУзлеНаСервере(ИБссылка, ЗапущенныеПроцессы)
	ЗапущенныеПроцессы.Добавить(УправлениеСерверамиПриложений.ЗапуститьОбменДанными(ИБссылка));
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗапущенныеПроцессы() Экспорт
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТД.Свойство("ГруппировкаСтроки") Тогда
		Возврат;
	КонецЕсли;
	
	ИБ = ТД.Ссылка;
	ПроверитьЗапущенныеПроцессыНаСервере(ЗапущенныеПроцессы);
	ЗаполнитьРезультатПоЗапущеннымПроцессамНаСервере(ИБ, ЗапущенныеПроцессы);
КонецПроцедуры

&НаСервере
Процедура ПроверитьЗапущенныеПроцессыНаСервере(ЗапущенныеПроцессы) Экспорт
	Для Каждого Т Из ЗапущенныеПроцессы Цикл
		ПроцессЗавершен = ПроцессЗавершен;
		Если Не Т.Свойство("ПроцессЗавершен", ПроцессЗавершен) Тогда
			ПроцессЗавершен = Ложь
		ИначеЕсли ПроцессЗавершен Тогда
			Продолжить;
		КонецЕсли;
		ПутьКфайлуРезультата = ПутьКфайлуРезультата;
		Т.Свойство("ПутьКфайлуРезультата", ПутьКфайлуРезультата);
		ПутьКфайлуАут = Т.ПутьКфайлуАут;
		Если ПутьКфайлуРезультата = Неопределено Тогда
			ПутьКфайлуРезультата = Т.ПутьКфайлуАут;
		КонецЕсли;
		
		Попытка
			Чтение = Новый ЧтениеТекста(ПутьКфайлуРезультата);
			СтрРезультат = Чтение.Прочитать(1);
		Исключение
			СтрРезультат = Неопределено;
		КонецПопытки;
		
		// При успехе Стр="0", при неудаче "1"
		Если СтрРезультат = Неопределено Тогда
			Т.Вставить("ПроцессЗавершен", Ложь);
			Продолжить;
		Иначе
			Т.Вставить("ПроцессЗавершен", Истина);
			Если СтрРезультат = "0" Тогда
				Т.Вставить("Успех", Истина);
			ИначеЕсли СтрРезультат = "1" Тогда
				Чтение = Новый ЧтениеТекста(ПутьКфайлуАут);
				ОписаниеОшибки = Чтение.Прочитать();
				Т.Вставить("ОписаниеОшибки", ОписаниеОшибки);
			Иначе
				Чтение = Новый ЧтениеТекста(ПутьКфайлуАут);
				Описание = Чтение.Прочитать();
				Т.Вставить("Описание", Описание);
				Если СтрНайти(Описание, "Обмен закончен") Тогда
					Т.Вставить("Успех", Истина);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьРезультатПоЗапущеннымПроцессам() Экспорт
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Если ТД.Свойство("ГруппировкаСтроки") Тогда
		Возврат;
	КонецЕсли;
	
	ИБ = ТД.Ссылка;	
	ЗаполнитьРезультатПоЗапущеннымПроцессамНаСервере(ИБ, ЗапущенныеПроцессы);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьРезультатПоЗапущеннымПроцессамНаСервере(ИБссылка, ЗапущенныеПроцессы) Экспорт

	
	Текст = "";
	Для Каждого Т Из ЗапущенныеПроцессы Цикл
		Если НЕ Т.ИнформационнаяБаза = ИБссылка Тогда
			Продолжить;
		КонецЕсли;
		Текст = Текст + "===================================" + Символы.ПС;
		Текст = Текст + Строка(Т.ВремяЗапуска) + Символы.ПС;
		Текст = Текст + ?(Т.ПроцессЗавершен, "Процесс завершен " + ?(Т.Успех, "успешно", "не успешно"), "В процессе ...") + Символы.ПС;
		Если Т.ПроцессЗавершен Тогда
			Текст = Текст + Т.ОписаниеОшибки + Символы.ПС;
		КонецЕсли;
		Описание = Описание;
		Т.Свойство("Описание", Описание);
		Если Описание <> Неопределено Тогда
			Текст = Текст + Описание + Символы.ПС;
		КонецЕсли;		
	КонецЦикла;
	Если Результат.ПолучитьТекст() <> Текст Тогда
		Результат.УстановитьТекст(Текст);
		ОбновитьНомераВерсийИБнаСервере();
	КонецЕсли;
	
	мУД = Новый Массив;
	Для Каждого Т Из ЗапущенныеПроцессы Цикл
		Если Т.ВремяЗапуска < ТекущаяДата() - 240 Тогда
			мУД.Добавить(ЗапущенныеПроцессы.Найти(Т));
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Т Из мУД Цикл
		Попытка
			ЗапущенныеПроцессы.Удалить(Т);	
		Исключение
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьФлагОбновлятьПроцессы() Экспорт
	ОбновлятьПроцессы = Ложь;
	Элементы.ПроцессыПереключитьФлагОбновлятьПроцессы.Пометка = ОбновлятьПроцессы;
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	ПодключитьОбработчикОжидания("СнятьФлагОбновлятьПроцессы", 120, 1);
	ИнформационнаяБаза = Элементы.Список.ТекущаяСтрока;
	РабочиеМеста.Параметры.УстановитьЗначениеПараметра("ИнформационнаяБаза", ИнформационнаяБаза);
	//УстановитьОтборРабочихМест(Элементы.Список.ТекущаяСтрока);	
	#Если НЕ ТонкийКлиент Тогда
		ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
		Если ФЗ <> Неопределено Тогда
			Если ФЗ.Состояние = СостояниеФоновогоЗадания.Активно Тогда
				ФЗ.Отменить();
			КонецЕсли;
		КонецЕсли;
		ИдентификаторЗадания = Новый УникальныйИдентификатор;
	#КонецЕсли
	АдресТаблицыПроцессов = "";
	Если Процессы.Количество() Тогда
		Процессы.Очистить();
	КонецЕсли;              	
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Элементы.ГруппаТекИБ.Заголовок ="";
		Возврат;
	КонецЕсли;
	Если ТД.Свойство("ГруппировкаСтроки") Тогда
		Элементы.ГруппаТекИБ.Заголовок = "";
		Возврат;
	КонецЕсли;
	ИБ = ТД.Ссылка;
	//Элементы.ГруппаТекИБ.Заголовок = ТД.Наименование;
	ОтключитьОбработчикОжидания("ОбновитьПроцессы");
	Если Элементы.Список.ВыделенныеСтроки.Количество() > 1 Тогда
	Иначе
		Если ЗапущенныеПроцессы.Количество() Тогда
			ПодключитьОбработчикОжидания("ЗаполнитьРезультатПоЗапущеннымПроцессам",0.1,1);
		КонецЕсли;
		ПодключитьОбработчикОжидания("ОбновитьПроцессы",1,1);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьНомераВерсийИБ(Команда)
	ПодключитьОбработчикОжидания("ОбновитьСписок",10, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьСписок() Экспорт
	Элементы.Список.Обновить();
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОбновитьНомераВерсийИБнаСервере()
	Попытка
		ФоновыеЗадания.Выполнить("ВыполнениеРегламентныхЗаданий.ОбновитьНомераВерсийИБ",,"ОбновитьНомераВерсийИБ","ОбновитьНомераВерсийИБ");
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьТонкийКлиент(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Сервер = ТД.СерверХост;
	ПортСервера = ПортСервера(ТД.Ссылка);
	ПортСервера = ?(ПортСервера = Неопределено, "1541", ПортСервера);
	ЗапуститьПриложение(СтрШаблон("%2 ENTERPRISE /IBConnectionString""Srvr=""""%1:%3"""";Ref=""""sup_kkm"""";"" /WA- /N""Администратор"" /P19643003 /DisplayAllFunctions /itaxi /OLow /TComp", 
	Сервер, КаталогПрограммы()+"1cv8c.exe",ПортСервера));
КонецПроцедуры


&НаСервереБезКонтекста
Функция ПортСервера(ИБ)
	Возврат РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ИБ,"Порт сервера 1С");
КонецФункции


&НаКлиенте
Процедура ОтправитьСообщениеОбмена(Команда)
	МассивУзлов = Новый Массив;
	Для Каждого Т Из Элементы.Список.ВыделенныеСтроки Цикл
		МассивУзлов.Добавить(Элементы.Список.ДанныеСтроки(Т).Узел);		
	КонецЦикла;
	Для каждого Т Из МассивУзлов Цикл
		Сеть.ПодключитьШару(Т.ИнформационнаяБаза.СерверХост, Истина);
	КонецЦикла;
	глОбработкаАвтоОбменДанными = глОбработкаАвтоОбменДанными;
	ПроцедурыОбменаДанными.ПроизвестиСписокОбменовДанными(МассивОбменов(МассивУзлов), Истина, глОбработкаАвтоОбменДанными);
КонецПроцедуры

&НаСервереБезКонтекста
Функция МассивОбменов(Знач МассивУзлов) Экспорт
	Возврат УправлениеСерверамиПриложений.МассивОбменов(МассивУзлов);
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПодключитьОбработчикОжидания("ОбновитьПроцессы",5);
	Элементы.ПроцессыПереключитьФлагОбновлятьПроцессы.Пометка = ОбновлятьПроцессы;
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПроцессы() Экспорт
	ОтключитьОбработчикОжидания("ОбновитьПроцессы");
	Если Не Элементы.ПроцессыПереключитьФлагОбновлятьПроцессы.Пометка = ОбновлятьПроцессы Тогда
		Элементы.ПроцессыПереключитьФлагОбновлятьПроцессы.Пометка = ОбновлятьПроцессы;
	КонецЕсли;
	Если Не ОбновлятьПроцессы Тогда
		ПодключитьОбработчикОжидания("ОбновитьПроцессы",2,Истина);
		Возврат;
	КонецЕсли;
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		ПодключитьОбработчикОжидания("ОбновитьПроцессы",2,Истина);
		Возврат;
	КонецЕсли;	
	ОбновитьПроцессыНаСервере(ТД.Ссылка);
	ПодключитьОбработчикОжидания("ОбновитьПроцессы",2,Истина);
КонецПроцедуры

&НаСервере
Процедура ОбновитьПроцессыНаСервере(ИБссылка) Экспорт
	ФЗ = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	
	Если Не ФЗ = Неопределено Тогда
		Если ФЗ.Состояние = СостояниеФоновогоЗадания.Активно Тогда
			Возврат;	
		КонецЕсли;
	КонецЕсли;
	
	ТЗпроцессы = Неопределено;
	Если ЗначениеЗаполнено(АдресТаблицыПроцессов) Тогда
		Если ЭтоАдресВременногоХранилища(АдресТаблицыПроцессов) Тогда
			ТЗпроцессы = ПолучитьИзВременногоХранилища(АдресТаблицыПроцессов);	
		КонецЕсли;
	Иначе
		АдресТаблицыПроцессов = ПоместитьВоВременноеХранилище(Процессы.Выгрузить(Новый Массив));
	КонецЕсли;
	
	Если ТЗпроцессы = Неопределено Тогда
		Процессы.Очистить();
	Иначе         
		Процессы.Загрузить(ТЗпроцессы);
	КонецЕсли;
	
	Если ФЗ = Неопределено Или ФЗ.Состояние = СостояниеФоновогоЗадания.Завершено Или ФЗ.Состояние = СостояниеФоновогоЗадания.ЗавершеноАварийно Тогда
		Сервер = ИБссылка.СерверХост;
		ПараметрыФЗ = Новый Массив;
		ПараметрыФЗ.Добавить(Сервер);
		ПараметрыФЗ.Добавить(АдресТаблицыПроцессов);
		Попытка
			ФЗ = ФоновыеЗадания.Выполнить("Сеть.СохранитьСписокПроцессовВоХранилище",ПараметрыФЗ,ИБссылка.УникальныйИдентификатор(),"СохранитьСписокПроцессовВоХранилище");
			ИдентификаторЗадания = ФЗ.УникальныйИдентификатор;
			
		Исключение
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтправкаСообщенияИобновлениеКонфигурацииНаСервере(ИБссылка) 
	лПараметры = Массив(ИБссылка);
	ФоновыеЗадания.Выполнить("УправлениеСерверамиПриложений.ОтправкаСообщенияИобновлениеКонфигурации", лПараметры, ИБссылка.Код+"Обновление",ИБссылка.Наименование);
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаСообщенияИобновлениеКонфигурации(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Для Каждого Т Из Элементы.Список.ВыделенныеСтроки Цикл
		ОтправкаСообщенияИобновлениеКонфигурацииНаСервере(Элементы.Список.ДанныеСтроки(Т).Ссылка);
	КонецЦикла;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура УбитьПроцессНаСервере(ИБссылка, ИДпроцесса)
	Сеть.УбитьПроцесс(ИБссылка.СерверХост, ИДпроцесса, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПроцессыПередУдалением(Элемент, Отказ)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;

	УбитьПроцессНаСервере(ТД.Ссылка, Элемент.ТекущиеДанные.ProcessID);
КонецПроцедуры

&НаКлиенте
Процедура ПереключитьФлагОбновлятьПроцессы(Команда)
	ОбновлятьПроцессы = Не ОбновлятьПроцессы;
	Элементы.ПроцессыПереключитьФлагОбновлятьПроцессы.Пометка = ОбновлятьПроцессы;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	РабочиеМеста.Параметры.УстановитьЗначениеПараметра("ИнформационнаяБаза", Справочники.ИнформационныеБазы.ПустаяСсылка());
	Если ПараметрыСеанса.ТекущаяИБ = Справочники.ИнформационныеБазы.Центр Тогда
		ПодключитьсяКвнешнемуИсточникуСупЦентр(Справочники.Регионы.Р77, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Процедура Перезапуск1СсервераНаСервере(ИБ)
	
		УправлениеСерверамиПриложений.ПерезапускСлужбы(ИБ);	
		
КонецПроцедуры

&НаКлиенте
Процедура Перезапуск1Ссервера(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИБ = ТД.Ссылка;
	Если Вопрос("Остановить СУП ККМ на " + ИБ + "?", РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет) = КодВозвратаДиалога.Да Тогда
		Перезапуск1СсервераНаСервере(ИБ);
		Предупреждение("СУП ККМ перезупущен на " + ИБ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьТолстыйКлиент(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Сервер = ТД.Ссылка.СерверХост;
	ЗапуститьСистему(СтрШаблон("/s%1\sup_kkm /nАдминистратор /p19643003 /RunModeManagedApplication", 
								  Сервер));
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОбычноеПриложение(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Сервер = ТД.Ссылка.СерверХост;
	ПортСервера = ПортСервера(ТД.Ссылка);
	ПортСервера = ?(ПортСервера = Неопределено, "1541", ПортСервера);
	ЗапуститьСистему(СтрШаблон("/s%1:%2\sup_kkm /nАдминистратор /p19643003 /RunModeOrdinaryApplication", 
	Сервер, ПортСервера));
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗапуститьОфлайнРежимНаСервере(РМ, Синхронно=Истина)
	
	ир = ирКэш.Получить();
	
	Хост = Сеть.ИмяХостаРМ(РМ, Истина);
	Если РМ.МестоРеализации = Справочники.МестаРеализации.Мяснов Тогда
		Пользователь = "myasnov-pos";
	Иначе
		Пользователь = "otdohni-pos";
	КонецЕсли;
	
	Команда = СтрШаблон("pskill \\%1 -u kassa -p 1 1cv8", Хост);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда);
	
	Команда = СтрШаблон("pskill \\%1 -u kassa -p 1 starter", Хост);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда);
	Команда = СтрШаблон("psexec \\%1 -u kassa -p 1 -i -c ""C:\distr\OfflineNotification.exe""", Хост);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда,,,,Ложь);
	
	Команда = СтрШаблон("psexec -i \\%1 -u kassa -p 1 ""C:\Program Files\1cv8\common\1cestart.exe"" enterprise /FC:\sup_kkm /N%2 /p"""" /DisableStartupMessages /RunModeOrdinaryApplication", Хост, Пользователь);
	//Сообщить(Команда);
	ФайлРезультат = Строка(Новый УникальныйИдентификатор);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда,,,ФайлРезультат,Синхронно);
	РезультатБатника = РаботаСФайлами.ИзвлечьТекст(КаталогВременныхФайлов() + ФайлРезультат);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОфлайнРежим(Команда)
	ТД = Элементы.РабочиеМеста.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Для Каждого РМ Из Элементы.РабочиеМеста.ВыделенныеСтроки Цикл
		Если Вопрос("Остановить СУП ККМ на " + РМ + "?
			|На кассе закроется СУП ККМ и откроется в офлайн режиме.
			|Продолжить?", РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет) = КодВозвратаДиалога.Да Тогда
			ЗапуститьОфлайнРежимНаСервере(РМ,Элементы.РабочиеМеста.ВыделенныеСтроки.Количество()=1);
			//Предупреждение("Готово " + РМ,100, "Оффлайн");
		КонецЕсли;
	КонецЦикла;


	
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗапуститьОнлайнРежимНаСервере(РМ)
	ир = ирКэш.Получить();
	
	//:РМ = справочники.РабочиеМеста.ПустаяСсылка();
	Хост = Сеть.ИмяХостаРМ(РМ, Истина);
	
	Команда = СтрШаблон("pskill \\%1 -u kassa -p 1 1cv8", Хост);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда);
	Команда = СтрШаблон("pskill \\%1 -u kassa -p 1 starter", Хост);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда);
	Команда = СтрШаблон("pskill \\%1 -u kassa -p 1 OfflineNotification", Хост);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда);
	Команда = СтрШаблон("pskill %1 PSEXESVC", Хост);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда);
	

	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда);
	Команда = СтрШаблон("psexec \\%1 -u kassa -p 1 -i -c -f -w C:\sup_kkm_addins\ ""C:\sup_kkm_addins\starter.exe""", Хост);
	Если СтрНайти(РМ.ИнформационнаяБаза.СерверХост, "ost") Тогда
		Команда = СтрЗаменить(Команда, "starter", "starter_ost");
	КонецЕсли;
	Результат = "Выполнена команда:
	|" + Команда;		

	ФайлРезультат = Строка(Новый УникальныйИдентификатор);
	ир.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда,,,ФайлРезультат,Ложь);
	РезультатБатника = РаботаСФайлами.ИзвлечьТекст(КаталогВременныхФайлов() + ФайлРезультат, КодировкаТекста.OEM,Истина);
	
	Результат = Результат + Символы.ПС + РезультатБатника;
КонецПроцедуры

&НаКлиенте
Процедура ЗапуститьОнлайнРежим(Команда)
	ТД = Элементы.РабочиеМеста.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Для Каждого РМ Из Элементы.РабочиеМеста.ВыделенныеСтроки Цикл
		Если Вопрос("Остановить СУП ККМ на " + РМ + "?
			|На кассе закроется СУП ККМ и откроется в онлайн режиме.
			|Продолжить?", РежимДиалогаВопрос.ДаНет,,КодВозвратаДиалога.Нет) = КодВозвратаДиалога.Да Тогда
			ЗапуститьОнлайнРежимНаСервере(РМ);
			
		КонецЕсли;
	КонецЦикла;
	


КонецПроцедуры

&НаСервереБезКонтекста
Процедура ОтключитьСессииНаСервере(ИБ)
	Сеть.ОтключитьСессии(ИБ.СерверХост);
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьСессии(Команда)
	ТД = Элементы.Список.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ИБ = ТД.Ссылка;

	ОтключитьСессииНаСервере(ИБ);
КонецПроцедуры

ЗапущенныеПроцессы = Новый Массив;