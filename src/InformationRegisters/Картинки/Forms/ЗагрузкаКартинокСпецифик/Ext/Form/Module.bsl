﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Вставить содержимое обработчика.
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура КаталогСКартинкамиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	Если Не ВыборФайла.Выбрать() Тогда
		Возврат;		
	КонецЕсли;
	КаталогСКартинками = ВыборФайла.Каталог;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок
//Код процедур и функций
#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыделитьВсе(Команда)
	Для каждого ТекСтрока Из Список Цикл
		ТекСтрока.Загрузить = Истина;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура СнятьВыделение(Команда)
	Для каждого ТекСтрока Из Список Цикл
		ТекСтрока.Загрузить = Ложь;
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьКаталог(Команда)

	Если НЕ ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	
	НачатьПоискФайлов(Новый ОписаниеОповещения("ПослеПоискаФайлов", ЭтотОбъект, ДополнительныеПараметры), КаталогСКартинками, "*.png", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПоискаФайлов(НайденныеФайлы, ДополнительныеПараметры) Экспорт 
	
	RegExp = ирКэш.Получить().RegExp;
	RegExp.Pattern = "\d{8}.{1,}";

	Список.Очистить();
	Для каждого ТекФайл Из НайденныеФайлы Цикл
		
		ИмяБезРасширения = СокрЛП(ТекФайл.ИмяБезРасширения);
		Matches = RegExp.Execute(ИмяБезРасширения);
		Если НЕ Matches.Count = 1 Тогда
			Продолжить;
		КонецЕсли;
		
		НовСтрока = Список.Добавить();
		НовСтрока.КодСУП = Лев(ИмяБезРасширения, 8);
		НовСтрока.ПутьКФайлу = ТекФайл.ПолноеИмя;
		НовСтрока.Наименование = СокрЛП(СтрЗаменить(Сред(ИмяБезРасширения, 9), "_", " "));
		НовСтрока.ТипКартинки = ?(Прав(НовСтрока.Наименование, 3) = "160", ПредопределенноеЗначение("Справочник.ТипыКартинок.Специфика"), ПредопределенноеЗначение("Справочник.ТипыКартинок.СпецификаБольшая"));

	КонецЦикла;
	
	ЗаполнитьСписокНайденнымиФайлами();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокНайденнымиФайлами()
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ТЗ", Список.Выгрузить());
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ТЗ.КодСуп КАК КодСуп,
	|	ТЗ.ПутьКФайлу КАК ПутьКФайлу,
	|	ТЗ.Наименование КАК Наименование,
	|	ТЗ.ТипКартинки КАК ТипКартинки
	|ПОМЕСТИТЬ втСписок
	|ИЗ
	|	&ТЗ КАК ТЗ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписок.КодСуп КАК КодСуп,
	|	втСписок.ПутьКФайлу КАК ПутьКФайлу,
	|	втСписок.Наименование КАК Наименование,
	|	втСписок.ТипКартинки КАК ТипКартинки,
	|	Специфики.Ссылка КАК Объект
	|ПОМЕСТИТЬ втСписок2
	|ИЗ
	|	втСписок КАК втСписок
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Специфики КАК Специфики
	|		ПО втСписок.КодСуп = Специфики.Номенклатура.КодСУП
	|			И (НЕ Специфики.Номенклатура.ПометкаУдаления)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	втСписок2.КодСуп КАК КодСуп,
	|	втСписок2.ПутьКФайлу КАК ПутьКФайлу,
	|	втСписок2.Наименование КАК Наименование,
	|	втСписок2.ТипКартинки КАК ТипКартинки,
	|	втСписок2.Объект КАК Объект,
	|	Картинки.ХранилищеИзображения КАК ХранилищеИзображения,
	|	ИСТИНА КАК Загрузить
	|ИЗ
	|	втСписок2 КАК втСписок2
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Картинки КАК Картинки
	|		ПО втСписок2.Объект = Картинки.Объект
	|			И втСписок2.ТипКартинки = Картинки.ТипКартинки";
	Список.Загрузить(Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры


#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПолучитьСписокКЗагрузке()
	
	СписокКЗагрузке = Список.Выгрузить(Новый Структура("Загрузить", Истина), "ПутьКФайлу");
	СписокКЗагрузке.Свернуть("ПутьКФайлу");
	
	Возврат СписокКЗагрузке.ВыгрузитьКолонку("ПутьКФайлу");
	
КонецФункции


#КонецОбласти

&НаКлиенте
Процедура ВыполнитьЗагрузку(Команда)
	
	ПомещаемыеФайлы = Новый Массив;
	СписокКЗагрузке = ПолучитьСписокКЗагрузке();
	
	Для каждого ТекПутьКФайлу Из СписокКЗагрузке Цикл
		ПомещаемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ТекПутьКФайлу)); 
	КонецЦикла;
	
	ДополнительныеПараметры = Новый Структура;
	НачатьПомещениеФайлов(Новый ОписаниеОповещения("ПослеПомещенияФайлов", ЭтотОбъект, ДополнительныеПараметры), ПомещаемыеФайлы, , Ложь, УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеПомещенияФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт 
	
	Для каждого ТекФайл Из ПомещенныеФайлы Цикл
		Если ТекФайл = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		СтрокаСписка = Список.НайтиСтроки(Новый Структура("ПутьКФайлу", ТекФайл.Имя));
		Для каждого ТекСтрокаСписка Из СтрокаСписка Цикл
			ТекСтрокаСписка.АдресВоВременномХранилище = ТекФайл.Хранение;
		КонецЦикла;
	КонецЦикла;
	
	ВыполнитьЗагрузкуНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗагрузкуНаСервере()
	
	Для каждого ТекСтрока Из Список Цикл
		
		Если НЕ ТекСтрока.Загрузить Тогда
			Продолжить;
		КонецЕсли;
		
		Если ПустаяСтрока(ТекСтрока.АдресВоВременномХранилище) Тогда
			Сообщить("Не удалась передача файла: " + ТекСтрока.ПутьКФайлу);
		КонецЕсли;
		
		ТекФайл = ПолучитьИзВременногоХранилища(ТекСтрока.АдресВоВременномХранилище);
		
		Если ТекСтрока.ХранилищеИзображения.Пустая() Тогда
			ОбъектХДИ = Справочники.ХранилищеДополнительнойИнформации.СоздатьЭлемент();
			ОбъектХДИ.Хранилище = Новый ХранилищеЗначения(Новый Картинка(ТекФайл));
			ОбъектХДИ.Родитель = ГруппаКартинок;
			ОбъектХДИ.Наименование = ТекСтрока.Наименование;
			ОбъектХДИ.Записать();
			ТекСтрока.ХранилищеИзображения = ОбъектХДИ.Ссылка;
			
			МЗ = РегистрыСведений.Картинки.СоздатьМенеджерЗаписи();
			ЗаполнитьЗначенияСвойств(МЗ, ТекСтрока, "Объект,ТипКартинки,ХранилищеИзображения");
			МЗ.ДатаДобавления = ТекущаяДатаСеанса();
			МЗ.Записать();
		Иначе
			ОбъектХДИ = ТекСтрока.ХранилищеИзображения.ПолучитьОбъект();
			ОбъектХДИ.Хранилище = Новый ХранилищеЗначения(Новый Картинка(ТекФайл));
			//ОбъектХДИ.ОбновитьИзображение(ТекФайл, Ложь);
			ОбъектХДИ.Записать();
		КонецЕсли;
		ТекСтрока.Загрузить = Ложь;
		
	КонецЦикла;
	
КонецПроцедуры




