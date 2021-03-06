﻿Перем ФормаМеню;
Перем фТолькоАктуальные;
Процедура ЭлементыМенюТекстКнопкиОткрытие(Элемент, СтандартнаяОбработка)
	ирОбщий.ОткрытьФормуПроизвольногоЗначенияЛкс(ЭлементыФормы.ЭлементыМеню.ТекущиеДанные.ТекстКнопки);	
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура КнопкаЗапуститьНажатие(Элемент)
	Если ФормаМеню = Неопределено Тогда
		ФормаМеню = ТекущийОбъект.ПолучитьФорму(,ЭтаФорма, 1);
		ФормаМеню.ПоложениеОкна = ВариантПоложенияОкна.НеПерекрыватьВладельца;
		ФормаМеню.ИзменятьСпособОтображенияОкна = ИзменениеСпособаОтображенияОкна.Разрешить;
		ФормаМеню.РазрешитьСоединятьОкно = Истина;
		ФормаМеню.Открыть();
		
	ИначеЕсли ФормаМеню.Открыта() Тогда
		ФормаМеню.Активизировать();      		
	Иначе
		ФормаМеню.Открыть();
	КонецЕсли;
	ФормаМеню.СправочникОбъект = ТекущийОбъект;
	ФормаМеню.СоздатьЭлементыФормы();
КонецПроцедуры

Процедура ЭлементыМенюПриАктивизацииСтроки(Элемент)
	ТД = ЭлементыФормы.ЭлементыМеню.ТекущиеДанные;
	Если ТД = Неопределено Тогда
		ЭлементыФормы.ЭлементыМеню.Колонки.КодСУПтовара.Видимость = Истина;
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ТД.Действие) Тогда
		ТД.Действие = Справочники.ДействияЭлементовМеню.ДобавитьТовар;
	КонецЕсли;
	
	//ЭлементыФормы.ЭлементыМеню.Колонки.КодСУПтовара.Видимость = ТД.Действие = Справочники.ДействияЭлементовМеню.ДобавитьТовар;
	ОбновитьФормуМеню();
КонецПроцедуры

Процедура СправочникСписокПриАктивизацииСтроки(Элемент)
	ТекущаяНастройка = Элемент.ТекущаяСтрока;
	Если ТекущаяНастройка = ТекущийОбъект.Ссылка Тогда
		Возврат;
	КонецЕсли; 
	
	Если Модифицированность Тогда
		Ответ = Вопрос("Сохранить изменения в """+ТекущийОбъект.Ссылка.Наименование+"""?", РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Да И НЕ ЗаписатьВФорме() ИЛИ Ответ = КодВозвратаДиалога.Отмена Тогда
			// возвращаемся на строку в которой были изменения
			Элемент.ТекущаяСтрока = ТекущийОбъект.Ссылка;
			Возврат;
		КонецЕсли;
	КонецЕсли; 
	
	Если ТекущаяНастройка = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	Попытка
		ТекущийОбъект = ТекущаяНастройка.ПолучитьОбъект();	
		Модифицированность = Ложь;
	Исключение
	КонецПопытки;
	
	ДобавитьСвойства();
	ДополнительныеСвойства.Отбор.Объект.Установить(ТекущийОбъект.Ссылка);
		
	
	
КонецПроцедуры


Процедура ДобавитьСвойства() Экспорт
	Если ТекущийОбъект.ЭтоНовый() Тогда
		Возврат;
	КонецЕсли;
	ОбязательныеСвойства = Массив("Количество кнопок по горизонтали", "Количество кнопок по вертикали", "Размер шрифта");
	СвойстваОтдохни = Массив("Excise_Server", "Excise_User", "Excise_Pwd", "УТМ");
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	ДополнительныеСвойства.Свойство,
	|	ДополнительныеСвойства.Значение
	|ИЗ
	|	РегистрСведений.ДополнительныеСвойства КАК ДополнительныеСвойства
	|ГДЕ
	|	Объект = &Объект");
	Запрос.УстановитьПараметр("Объект", ТекущийОбъект.Ссылка);
	
	тзСвойства = Запрос.Выполнить().Выгрузить();
	Для Каждого Свойство Из ОбязательныеСвойства Цикл
		
		ст = тзСвойства.Найти(Свойство ,"Свойство");
		Если ст <> Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Нов = РегистрыСведений.ДополнительныеСвойства.СоздатьМенеджерЗаписи();
		
		Нов.Объект = ТекущийОбъект.Ссылка;
	
		Нов.Свойство = Свойство;
		
		Если Не ЗначениеЗаполнено(Нов.Значение) Тогда
			Нов.Значение = ЗначениеСвойстваПоУмолчанию(Свойство);
			Нов.Записать();
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЗначениеСвойстваПоУмолчанию(Свойство)
	Если СтрНайти(Свойство, "Количество кнопок") Тогда
		Возврат 4;
	ИначеЕсли СтрНайти(Свойство, "Размер шрифта") Тогда
		Возврат 14;
	КонецЕсли;
КонецФункции

Функция ЗаписатьВФорме()
	Попытка
		ТекущийОбъект.Записать();
		Модифицированность = Ложь;
		Возврат Истина;
		
	Исключение
		Возврат Ложь;
	КонецПопытки;
КонецФункции

Процедура СправочникСписокПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	Попытка
		ТекущийОбъект = Элемент.ТекущаяСтрока.ПолучитьОбъект();	
	Исключение
	КонецПопытки;
КонецПроцедуры

Процедура ЭлементыМенюПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	ОбновитьФормуМеню();
	
КонецПроцедуры

Процедура ОбновитьФормуМеню()
	
	Если ФормаМеню <> Неопределено Тогда
		Если ФормаМеню.Открыта() Тогда
			ФормаМеню.СправочникОбъект = ТекущийОбъект;
			ФормаМеню.СоздатьЭлементыФормы();
			ФормаМеню.Модифицированность = Ложь;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанель2кнТолькоДействующие(Кнопка)
	ЭлементыФормы.КПверх.Кнопки.кнТолькоДействующие.Пометка = Не ЭлементыФормы.КПверх.Кнопки.кнТолькоДействующие.Пометка;
	фТолькоАктуальные = ЭлементыФормы.КПверх.Кнопки.кнТолькоДействующие.Пометка;
	УстановитьОтбор();
КонецПроцедуры

Процедура УстановитьОтбор() 
	Если фТолькоАктуальные Тогда
		
		
		
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	МенюЛояльности.Ссылка КАК Ссылка,
		|	ВЫБОР МенюЛояльности.Станция
		|		КОГДА ЗНАЧЕНИЕ(Справочник.МенюЛояльности.ПустаяСсылка)
		|			ТОГДА 1
		|		ИНАЧЕ 0
		|	КОНЕЦ КАК ДляВсехСтанций
		|ИЗ
		|	Справочник.МенюЛояльности КАК МенюЛояльности
		|ГДЕ
		|	(МенюЛояльности.ДатаНачалаДействия <= &ТекДата
		|			ИЛИ МенюЛояльности.ДатаНачалаДействия = ДАТАВРЕМЯ(1, 1, 1))
		|	И (МенюЛояльности.ДатаОкончанияДействия >= &ТекДата
		|			ИЛИ МенюЛояльности.ДатаОкончанияДействия = ДАТАВРЕМЯ(1, 1, 1))
		|	И НЕ МенюЛояльности.ПометкаУдаления
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДляВсехСтанций,
		|	МенюЛояльности.ДатаНачалаДействия УБЫВ");
		Запрос.УстановитьПараметр("ТекДата", НаДату);
		Рез =  Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку(0);
		
		СправочникСписок.Отбор.Ссылка.ВидСравнения = ВидСравнения.ВСписке;
		СправочникСписок.Отбор.Ссылка.Значение.ЗагрузитьЗначения(Рез);	
		СправочникСписок.Отбор.Ссылка.Использование = Истина;
		
		ЭлементыФормы.КПверх.Кнопки.кнТолькоДействующие.Текст = "Показывать только актуальные на";
		ЭлементыФормы.НаДату.Видимость = Истина;
	Иначе
		СправочникСписок.Отбор.Ссылка.Использование = Ложь;
		ЭлементыФормы.КПверх.Кнопки.кнТолькоДействующие.Текст = "Показывать только актуальные";
		ЭлементыФормы.НаДату.Видимость = Ложь;
	КонецЕсли;
	СправочникСписок.Обновить();
КонецПроцедуры

Процедура НаДатуПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

Процедура КнопкаВыгрузитьНажатие(Элемент)
	УправлениеРИБ.ОткрытьФормуОчередиВыгрузкиПоОбъекту(ТекущийОбъект.Ссылка);
КонецПроцедуры






НаДату = ТекущаяДата();

ЭлементыФормы.СправочникСписок.СпособРедактирования = СпособРедактированияСписка.ВСписке;
ОтборПУ = СправочникСписок.Отбор.ПометкаУдаления;
ОтборПУ.Установить(Ложь);

