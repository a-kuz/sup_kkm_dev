﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	ДействияПередОткрытиемФормы(ЭтаФорма, Отказ);
	
КонецПроцедуры

Процедура ПриОткрытии()
	ДоступностьКнопок();	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
	ЭлементыФормы.НадписьЗаголовок.Заголовок = ЭтаФорма.Заголовок;	
	Если глПараметрыРМ.ОбрезкаОкон Тогда
		
	Иначе
		Заголовок = "";
	КонецЕсли;

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаОКНажатие(Элемент)
	
	ОК(); 
	
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

Процедура ДоступностьКнопок() Экспорт                                    
	
	Если СтрДлина(СокрЛП(стрЗначениеВвода)) < 10 Тогда
		НеактивныйЭлемент = Метаданные.ЭлементыСтиля.НеактивныйЭлемент.Значение;
		ЭлементыФормы.КнопкаОк.Доступность = 0;
		ЭлементыФормы.КнопкаОк.ЦветФонаКнопки = НеактивныйЭлемент;
		ЭлементыФормы.КнопкаОк.ЦветРамки = НеактивныйЭлемент;
		ЭлементыФормы.ОкТень.Видимость = 0;
	Иначе 
		Тема = Метаданные.ЭлементыСтиля.ЦветТемы.Значение;
		ЭлементыФормы.КнопкаОк.ЦветФонаКнопки = Тема;
		ЭлементыФормы.КнопкаОк.ЦветРамки = Тема;
		ЭлементыФормы.ОкТень.Видимость = 1;
		ЭлементыФормы.КнопкаОк.Доступность = 1;
	КонецЕсли;		
		
КонецПроцедуры

Процедура Кнопка10Нажатие(Элемент)
	//ЗначениеВвода = Дата(1900,1,1);
	//стрЗначениеВвода = Строка(ЗначениеВвода);
	//ОК(); 
КонецПроцедуры

Процедура БэкспейсНажатие(Элемент)
	глОтсечкаПростоя();
	стр = элементыформы.ЗначениеВвода.Значение;
	стр = СтрЗаменить(стр, ".", "");
	стр = СтрЗаменить(стр, "_", "");
	стр = СокрЛП(стр);
	Если СтрДлина(стр) Тогда
		Элементыформы.ЗначениеВвода.Значение = Лев(стр, СтрДлина(стр)-1);
		стрЗначениеВвода = Лев(стр, СтрДлина(стр)-1);
	КонецЕсли;
	Обновить();
	НажатиеКнопки("");
КонецПроцедуры

Процедура ПодсветкаНесоответсвующейСтроки() Экспорт
	стр = СокрП(ЭлементыФормы.ЗначениеВвода.Значение);
	стр = СтрЗаменить(стр, " .", "");
	стр = СтрЗаменить(стр, " ", "");
	Pattern = "^(([0123]$)|(0[1-9])|([1-2]\d)|(3[01]))\s?\s?(\.|$)((0[1-9]|1[12]?|[01]$))?\s?\s?(\.|$)(19\d?\d?|[12]$|20$|20[01]\d?$)?$";
	RegExp = ирПлатформа.RegExp;
	RegExp.Pattern = Pattern;
	IsMatch = RegExp.Test(стр) или ПустаяСтрока(стр);
	Если IsMatch Тогда
		RegExp.Pattern = "(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d";
		Если RegExp.Test(стр) Тогда
			ЭлементыФормы.ЗначениеВвода.ЦветТекстаПоля = Новый Цвет(0,177,0);	
		Иначе
			ЭлементыФормы.ЗначениеВвода.ЦветТекстаПоля = Новый Цвет(50,50,50);
		КонецЕсли;
		
	Иначе
		ЭлементыФормы.ЗначениеВвода.ЦветТекстаПоля = Метаданные.ЭлементыСтиля.Акцент.Значение;
	КонецЕсли;
	
	
КонецПроцедуры

//ЭлементыФормы.КнопкаСброс.Заголовок = Шрифты.ПолучитьСимвол("arrow_left");

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);


