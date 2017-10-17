﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	// вызов должен быть в конце обработчика
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ПоискПоНомеруНажатие(Элемент)
	ОткрытьЗаказПоНомеру();
КонецПроцедуры

Процедура ПоискПоКлиентуНажатие(Элемент)
	
	ИнтерфейсРМ.ВыводНаИнфоДисплей("Приглашение", Неопределено, Неопределено, Неопределено, Неопределено);
	ВыбКлиент = ИнтерфейсРМ.ИдентификацияКлиента();
	ИнтерфейсРМ.ВыводНаИнфоДисплей("Реклама", Неопределено, Неопределено, Неопределено, Неопределено);
	
	Если ВыбКлиент=Неопределено Тогда
		Возврат;
		
	ИначеЕсли ВыбКлиент.Пустая() Тогда
		Текст1="Убрать клиента?";
		Текст2="Вы уверены, что хотите отключить отбор по клиенту?";
		Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"Да","","Esc=Нет") = "Нет" Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	СводныйЖурнал = Ложь;
	СоздатьСтруктуруЖурнала();
	ОбновитьЖурнал(,ВыбКлиент);
	Закрыть();
	
КонецПроцедуры

Процедура ПоискПоОфициантуНажатие(Элемент)
	МассивСотрудников = Новый Массив;
	
	Запрос = Новый Запрос("ВЫБРАТЬ Ссылка ИЗ Справочник.Сотрудники
	|ГДЕ НЕ ЭтоГруппа И НЕ ПометкаУдаления 
	|УПОРЯДОЧИТЬ ПО Наименование");
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивСотрудников.Добавить(Выборка.Ссылка);
	КонецЦикла;
	
	ВыбАвтор = ИнтерфейсРМ.ВыборИзСписка(МассивСотрудников);
	СводныйЖурнал = Ложь;
	СоздатьСтруктуруЖурнала();
	ОбновитьЖурнал(,ВыбАвтор);
	Закрыть();
	
КонецПроцедуры

Процедура ПоискПоМестуНажатие(Элемент)
	
	ЛимитнаяКарта = ?(глВерсия=3, глПараметрыРМ.ЛимитныеКарты, Ложь );
	
	ДоставкаВозможна = глВерсия=3 И глПараметрыРМ.ДоставкаЕсть И 
						ИнтерфейсРМ.ПроверкаПраваДоступа(ПланыВидовХарактеристик.ПраваДоступа.ДоставкаДоступОткрытыеЗаказы);
						
	ВыбМесто = ИнтерфейсРМ.ВыборПосадочногоМеста(ЛимитнаяКарта, ДоставкаВозможна);
	СводныйЖурнал = Ложь;
	Если ВыбМесто = "Доставка" Тогда
		ДоставкаЖурнал = Истина;
	КонецЕсли;
	
	СоздатьСтруктуруЖурнала();
	ОбновитьЖурнал(,?(ВыбМесто = "Доставка",Неопределено,ВыбМесто));
	Закрыть();
	
КонецПроцедуры

Процедура ОтключитьОтборНажатие(Элемент)
	ВыбЗначение = Неопределено;
	ОбновитьЖурнал(,ВыбЗначение);
	Закрыть();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);

