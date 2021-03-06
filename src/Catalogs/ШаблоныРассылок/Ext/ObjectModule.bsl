﻿/////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ ДЛЯ ВЫБОРА РОДИТЕЛЯ В СПРАВОЧНИКАХ

// Обновляет гиперссылку на родителя.
//
// Параметры:
//  Форма - форма справочника.
//
Процедура ОбновитьГиперссылкуРодительСправочника(Форма) Экспорт
	
	Если Не ЗначениеЗаполнено(Форма.Родитель) Тогда
		Заголовок = "<Родитель не задан>";
	Иначе
		Заголовок = СокрЛП(Форма.Родитель);
	КонецЕсли;
	
	Форма.ЭлементыФормы.ГиперссылкаРодитель.Заголовок = Заголовок;
	
КонецПроцедуры

// Открывает форму выбора группы справочника.
//
// Параметры:
//  ОбъектСправочник - объект справочника,
//  Форма            - форма элемента справочника,
//  Гиперссылка      - элемент формы, гиперссылка на родителя.
//
Процедура НажатиеГиперссылкиРодительСправочника(ОбъектСправочник, Форма) Экспорт
	
	ФормаВыбораГруппы = Справочники[ОбъектСправочник.Метаданные().Имя].ПолучитьФормуВыбораГруппы(, Форма);
	ФормаВыбораГруппы.ПараметрТекущаяСтрока = ОбъектСправочник.Родитель;
	ФормаВыбораГруппы.Открыть();
	
КонецПроцедуры  

// Открывает форму выбора группы справочника.
//
// Параметры:
//  ОбъектСправочник - объект справочника,
//  Форма            - форма элемента справочника,
//  ВыбраннаяГруппа  - новый родитель.
//
Процедура ВыборРодителя(ОбъектСправочник, Форма, ЗначениеВыбора) Экспорт
	
	Если ТипЗнч(ЗначениеВыбора) = ТипЗнч(ОбъектСправочник.Ссылка) Тогда
		Если ЗначениеВыбора.ЭтоГруппа ИЛИ ЗначениеВыбора.Пустая() Тогда
			ОбъектСправочник.Родитель = ЗначениеВыбора;
		КонецЕсли;
	КонецЕсли;
	
	ОбновитьГиперссылкуРодительСправочника(Форма);
	
КонецПроцедуры

