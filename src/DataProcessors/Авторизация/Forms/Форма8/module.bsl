﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
	Если ПервоеОткрытие Тогда  
		ПодключитьОбработчикОжидания("ЗакрытьФорму",0.3,Истина);
		ПервоеОткрытие = Ложь;
		Возврат;
	Иначе
		ЭмуляторСканера = ЭмуляторСканера;
		Если глОбработки.Свойство("ЭмуляторСканера",ЭмуляторСканера) Тогда
			глОбработки.ЭмуляторСканера.Выключить();
		КонецЕсли;
	КонецЕсли;  
	Если ЗначениеЗаполнено(Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы()) Или Час(ТекущаяДата())<16 Тогда
		Высота = 174;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗакрытьФорму() Экспорт
	ОтменаНажатие("");
КонецПроцедуры
Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
	//РаботаСокнами.СнятьПереназначение("Авторизация", "~Down");
	//РаботаСокнами.СнятьПереназначение("Авторизация", "~Left");
	//РаботаСокнами.СнятьПереназначение("Авторизация", "~Tab");
	//РаботаСокнами.СнятьПереназначение("Авторизация", "~Right");
КонецПроцедуры

Процедура ВнешнееСобытие(Источник, Событие, Данные)
	
	ОбработкаВнешнегоСобытия(Источник, Событие, Данные);
	//Если НЕ ВводДоступен() Тогда
	//	Возврат;
	//КонецЕсли;
	//
	//_Знач = ОбработкаВнешнихСобытий.ПолучитьДанные(Источник,Событие,Данные);
	//
	//Если ЗначениеЗаполнено(_Знач) Тогда
	//	Закрыть( _Знач );
	//КонецЕсли;
	
КонецПроцедуры

Процедура ВыводОшибки_Ожидание() Экспорт 
	ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Карта доступа", "Карта доступа не привязана ни к одному сотруднику!","","ОК","", , , 5);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаОКНажатие(Элемент)
		
	ОК();
	
КонецПроцедуры

Процедура КнопкаТочкаНажатие(Элемент)
	
	Точка();
	
КонецПроцедуры

Процедура КнопкаСбросНажатие(Элемент)
	
	Сброс();
	
КонецПроцедуры

Процедура Кнопка0Нажатие(Элемент)
	
	НажатиеКнопки("0");
	
КонецПроцедуры

Процедура Кнопка1Нажатие(Элемент)
	
	НажатиеКнопки("1");
	
КонецПроцедуры

Процедура Кнопка2Нажатие(Элемент)
	
	НажатиеКнопки("2");
	
КонецПроцедуры

Процедура Кнопка3Нажатие(Элемент)
	
	НажатиеКнопки("3");
	
КонецПроцедуры

Процедура Кнопка4Нажатие(Элемент)
	
	НажатиеКнопки("4");
	
КонецПроцедуры

Процедура Кнопка5Нажатие(Элемент)
	
	НажатиеКнопки("5");
	
КонецПроцедуры

Процедура Кнопка6Нажатие(Элемент)
	
	НажатиеКнопки("6");
	
КонецПроцедуры

Процедура Кнопка7Нажатие(Элемент)
	
	НажатиеКнопки("7");
	
КонецПроцедуры

Процедура Кнопка8Нажатие(Элемент)
	
	НажатиеКнопки("8");
	
КонецПроцедуры

Процедура Кнопка9Нажатие(Элемент)
	
	НажатиеКнопки("9");
	
КонецПроцедуры
	 
Процедура ОтменаНажатие(Элемент)
	Закрыть();
КонецПроцедуры

Процедура КнопкаВыключитьКассуНажатие(Элемент)
	Закрыть("ВыходОС");

КонецПроцедуры

Процедура ОбновлениеОтображения()
	ОтключитьОбработчикОжидания("ОбновлениеОтображения");
	Если Высота>174 Тогда
		
		Для Каждого Элемент Из ЭлементыФормы Цикл
			Если СтрНачинаетсяС(Элемент.Имя, "Рамка") Тогда
				Кнопка = ЭлементыФормы.Найти(СтрЗаменить(Элемент.Имя,"Рамка","Кнопка"));
				Если Кнопка = Неопределено Тогда
					Продолжить;
				КонецЕсли;
				Элемент.Видимость = Кнопка = ТекущийЭлемент;
			КонецЕсли;
		КонецЦикла;	
		
		ПодключитьОбработчикОжидания("ОбновлениеОтображения",0.3,1);
	КонецЕсли;

КонецПроцедуры

Процедура АктивизитоватьВыключениеНажатие(Элемент)
	ТекущийЭлемент = ЭлементыФормы.КНопкаВыключитьКассу;
КонецПроцедуры




ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота, ", Истина);

ЭлементыФормы.КнопкаВыключитьКассу.Заголовок = Шрифты.ПолучитьСимвол("power_off");

Если ЗначениеЗаполнено(Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы()) Или Час(ТекущаяДата())<16 Тогда
	ЭлементыФормы.НадписьВыключитьКассу.Видимость = 0;
	ЭлементыФормы.КнопкаВыключитьКассу.Видимость = 0;	
	
	ЭлементыФормы.НадписьВыключитьКассу.Верх = 1;
	ЭлементыФормы.РамкаВыключитьКассу.Верх = 1;
	ЭлементыФормы.КнопкаВыключитьКассу.Верх = 1;	
Иначе
	Высота = 272;
КонецЕсли;
