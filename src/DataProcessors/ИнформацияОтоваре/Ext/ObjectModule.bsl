﻿#Если Клиент Тогда
	
Перем ВариантОтображенияКнопок Экспорт;
// 0-только кнопка закрыть
// 1-три кнопки (для повара)
// 2-кнопка "добавить" не доступна

// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
Процедура УстановкаНачальныхЗначений() Экспорт
	
	ВариантОтображенияКнопок = 0;
	
	Если глПараметрыРМ.ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.МОКП") 
		И глПараметрыРМ.Тип = ПредопределенноеЗначение("Перечисление.ТипыРМ.СтанцияПовараМОКП") Тогда
		
		ВариантОтображенияКнопок = 1;
	КонецЕсли;
	
КонецПроцедуры

Процедура УстановитьПометкуКнопки(Кнопка, Нажата = Ложь, Текст = "") Экспорт 
	
	Если Нажата Тогда
		Кнопка.ЦветФонаКнопки = ЦветаСтиля.ЦветФонаГлавнойФормы;
		Кнопка.ЦветТекстаКнопки =  ЦветаСтиля.ЦветТемы;
	Иначе
		Кнопка.ЦветФонаКнопки = ЦветаСтиля.ЦветТемы;
		Кнопка.ЦветТекстаКнопки = ЦветаСтиля.ЦветФонаГлавнойФормы;
	КонецЕсли;
	Если НЕ ПустаяСтрока(Текст) Тогда
		Кнопка.Заголовок = Текст;
	КонецЕсли;
	
КонецПроцедуры
	
Функция ПолучитьОсновнуюФорму() Экспорт 
	
	Если глПараметрыРМ.ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.МОКП") Тогда
		Возврат ЭтотОбъект.ПолучитьФорму("ФормаОнлайн");
	ИначеЕсли глПараметрыРМ.ТипТТ = ПредопределенноеЗначение("Справочник.ТипыТТ.КМ") Тогда
		Возврат ЭтотОбъект.ПолучитьФорму("Форма");
	Иначе
		Возврат ЭтотОбъект.ПолучитьФорму("Форма");
	КонецЕсли;
	
КонецФункции

#КонецЕсли
