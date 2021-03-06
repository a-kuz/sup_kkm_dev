﻿Процедура НажатиеЦифры(Элемент)
	глОтсечкаПростоя();
	Поз = СтрНайти(НадписьПолучено,".");
	Поз1 = СтрНайти(НадписьПолучено,",");
	Если Поз <> 0 Тогда
		Если СтрДлина(НадписьПолучено) - Поз - 2 >= 2 Тогда
			Возврат;
		КонецЕсли;
	ИначеЕсли Поз1 <> 0 Тогда
		Если СтрДлина(НадписьПолучено) - Поз1 - 2 >= 2 Тогда
			Возврат;
		КонецЕсли;
	КонецЕсли;		
	Цифра = Прав(Элемент.Имя,1);
	НадписьПолучено = СтрЗаменить(НадписьПолучено, " " + Символ(8381),"") + Цифра + " ";
	Добавка = "";
	Если Поз <> 0 Тогда
		Если Сред(НадписьПолучено,Поз+1,2) = "0 " Тогда
			Добавка = ".0";
		КонецЕсли;
	КонецЕсли;
	Если Поз1 <> 0 Тогда
		Если Сред(НадписьПолучено,Поз1+1,2) = "0 " Тогда
			Добавка = ".0";
		КонецЕсли;
	КонецЕсли;
	Получено = Число(СтрЗаменить(НадписьПолучено, Символы.НПП, ""));
	НадписьПолучено = "" + Получено + Добавка + " " + Символ(8381);
КонецПроцедуры

Процедура ВнесениеОтменаНажатие(Элемент)
	глОтсечкаПростоя();
	//фОплачено = Ложь;
	Закрыть(Ложь);
КонецПроцедуры

Процедура ВнесениеРегистрацияНажатие(Элемент)
	глОтсечкаПростоя();
	Если глПараметрыРМ.ККМЕстьДоп Тогда
		МассивЮрЛиц = Новый Массив;
		МассивЮрЛиц.Добавить(глПараметрыРМ.ККМ.Фирма);
		МассивЮрЛиц.Добавить(глПараметрыРМ.ККМСписокДоп[0].Значение.Фирма);
		ВыбЗначение = ИнтерфейсРМ.ВыборИзСписка(МассивЮрЛиц);
		Индекс = МассивЮрЛиц.Найти(ВыбЗначение);
		фВыплачено = Выплата(Индекс);
	Иначе
		фВыплачено = Выплата();
	КонецЕсли;
	Закрыть(фВыплачено);
КонецПроцедуры




Процедура ПриЗакрытии()
	ИнтерфейсРМ.ПриЗакрытииОкна();
КонецПроцедуры

Процедура ПриОткрытии()
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	ИнтерфейсРМ.СменаПользователя(,Истина);
КонецПроцедуры


Процедура КнопкаТочкаНажатие(Элемент)
	
	Если (не стрНайти(НадписьПолучено,".")) и (не стрНайти(НадписьПолучено,",")) Тогда
		Поз = СтрНайти(НадписьПолучено,Символ(8381));
		НадписьПолучено = Лев(НадписьПолучено,Поз-2) + ", " + Символ(8381);
	КонецЕсли;
	
КонецПроцедуры

Процедура КнопкаОчиститьНажатие(Элемент)
	
	НадписьПолучено = "0";
	
КонецПроцедуры




НадписьПолучено = "0";
Получено = 0;
ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);