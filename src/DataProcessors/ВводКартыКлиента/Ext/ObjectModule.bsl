﻿// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
	НомерКартыДоступа = "";	
		
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
Процедура ДействияПриОткрытии() Экспорт
	ИнтерфейсРМ.ВыводНаИнфоДисплей("Приглашение", Неопределено, Неопределено, Неопределено, Неопределено);
КонецПроцедуры

Процедура ДействияПриЗакрытии() Экспорт
	ИнтерфейсРМ.ВыводНаИнфоДисплей("Реклама", Неопределено, Неопределено, Неопределено, Неопределено);
КонецПроцедуры

Функция ПолучитьКартуДоступаПоИдентификатору(Идентификатор, СпособРегистрацииБейджа = 0) Экспорт 
	
	ИдентификаторHEX = Идентификатор;
	Если СтрДлина(ИдентификаторHEX) <= 16 И СтрДлина(ИдентификаторHEX) % 2 = 0 Тогда
		ИдентификаторHEX = Прав("00000000" + ИдентификаторHEX, 16);
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Бэйдж", ПредопределенноеЗначение("Перечисление.ТипыКартДоступа.Временная"));
	Запрос.УстановитьПараметр("Идентификатор", Идентификатор);
	Запрос.УстановитьПараметр("ИдентификаторHEX", ИдентификаторHEX);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	КартыДоступа.Ссылка КАК КартаДоступа,
	|	2 КАК СпособРегистрацииБейджа
	|ИЗ
	|	Справочник.КартыДоступа КАК КартыДоступа
	|ГДЕ
	|	КартыДоступа.ТипКарты = &Бэйдж
	|	И КартыДоступа.Идентификатор = &Идентификатор
	|	И НЕ КартыДоступа.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КартыДоступа.Ссылка,
	|	3
	|ИЗ
	|	Справочник.КартыДоступа КАК КартыДоступа
	|ГДЕ
	|	КартыДоступа.ТипКарты = &Бэйдж
	|	И КартыДоступа.Идентификатор1 = &Идентификатор
	|	И НЕ КартыДоступа.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КартыДоступа.Ссылка,
	|	1
	|ИЗ
	|	Справочник.КартыДоступа КАК КартыДоступа
	|ГДЕ
	|	КартыДоступа.ТипКарты = &Бэйдж
	|	И КартыДоступа.Идентификатор2 = &Идентификатор
	|	И НЕ КартыДоступа.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КартыДоступа.Ссылка,
	|	2
	|ИЗ
	|	Справочник.КартыДоступа КАК КартыДоступа
	|ГДЕ
	|	КартыДоступа.ТипКарты = &Бэйдж
	|	И КартыДоступа.ИдентификаторHEX = &ИдентификаторHEX
	|	И НЕ КартыДоступа.ПометкаУдаления";
	
	Рез = Запрос.Выполнить().Выбрать();
	Если Рез.Следующий() Тогда
		КартаДоступа = Рез.КартаДоступа;
		СпособРегистрацииБейджа = Рез.СпособРегистрацииБейджа;
	Иначе
		КартаДоступа = ПредопределенноеЗначение("Справочник.КартыДоступа.ПустаяСсылка");
	КонецЕсли;

	//Если Рез.Пустой() Тогда
	//	КартаДоступа = Справочники.КартыДоступа.ПустаяСсылка();
	//Иначе
	//	КартаДоступа = Рез.Выгрузить()[0][0];
	//КонецЕсли;
	
	Возврат КартаДоступа;
		
КонецФункции

#КонецЕсли