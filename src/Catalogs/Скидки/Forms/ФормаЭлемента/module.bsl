﻿
Перем ФлагНекорректныеПараметры;

// Возвращает "человеческое" описание скидки и условий ее применения
//
Функция ПолучитьОписаниеСкидки()
	
	ФлагНекорректныеПараметры = Ложь;
	
	Стр = "";
	Если ТипЗначения = "СкидкаПроцент" Тогда
		Стр = Стр + "Скидка " + ЗначениеСкидки + "%";
	ИначеЕсли ТипЗначения = "СкидкаСумма" Тогда
		Стр = Стр + "Скидка " + ?(ЗначениемЯвляетсяЦена, "равна цене текущей позиции.", Строка(ЗначениеСкидки)+" руб.");
		
	ИначеЕсли ТипЗначения = "НаценкаПроцент" Тогда
		Стр = Стр + "Наценка " + ЗначениеСкидки + "%";
	ИначеЕсли ТипЗначения = "НаценкаСумма" Тогда
		Стр = Стр + "Наценка " + ЗначениеСкидки + " руб.";
		
	ИначеЕсли ТипЗначения = "БонусПроцент" Тогда
		Стр = Стр + "Бонус " + ЗначениеСкидки + "%";
	ИначеЕсли ТипЗначения = "БонусСумма" Тогда
		Стр = Стр + "Бонус " + ЗначениеСкидки + " руб.";
		
	ИначеЕсли ТипЗначения = "ТипЦен" Тогда
		Если НЕ ЗначениеЗаполнено(ТипЦен) Тогда
			ФлагНекорректныеПараметры = Истина;
			Возврат "Тип цен не выбран!";
		КонецЕсли; 
		Стр = Стр + "Тип цен: " + ТипЦен;
		
	ИначеЕсли Подарок И НЕ ПодарокТакойЖе Тогда
		Стр = Стр + ?(ПодарокНаВыбор, "Подарок на выбор.", "Подарок или набор подарков.");
		
		Если Подарки.Количество()=0 Тогда
			ФлагНекорректныеПараметры = Истина;
			Возврат "Подарок не выбран!";
		КонецЕсли; 
		Для каждого СтрокаПодарка Из Подарки Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаПодарка.Товар) ИЛИ СтрокаПодарка.Количество=0 Тогда
				ФлагНекорректныеПараметры = Истина;
				Возврат "Подарок не выбран!";
			ИначеЕсли СтрокаПодарка.Товар.Тип = Перечисления.ТипыТоваров.Тариф Тогда
				ФлагНекорректныеПараметры = Истина;
				Возврат "Тарифицируемая услуга не может использоваться в качестве подарка!";
			КонецЕсли; 
		КонецЦикла; 
		
	ИначеЕсли ПодарокТакойЖе Тогда
		Стр = Стр + "Такой же в подарок.";
		
	КонецЕсли; 
	
	// ограничение действия по категориям товаров
	Если НЕ Подарок И ТипОграниченияКатегорий <> Перечисления.ТипыОграниченийПоСписку.Нет Тогда
		СтрКТ = "";
		Для каждого КТ Из КатегорииТоваров Цикл
			Если КТ.Пометка Тогда
				СтрКТ = СтрКТ + ?(ПустаяСтрока(СтрКТ), "", ", ") + КТ.Значение;
			КонецЕсли; 
		КонецЦикла; 
		
		Если НЕ ПустаяСтрока(СтрКТ) И ТипОграниченияКатегорий = Перечисления.ТипыОграниченийПоСписку.Включить Тогда
			Стр = Стр + Символы.ПС + "Действует только на категории " + СтрКТ + "."+Символы.ПС;
		ИначеЕсли НЕ ПустаяСтрока(СтрКТ) И ТипОграниченияКатегорий = Перечисления.ТипыОграниченийПоСписку.Исключить Тогда
			Стр = Стр + Символы.ПС + "Действует на все категории, кроме " + СтрКТ + "."+Символы.ПС;
		КонецЕсли; 
			
	КонецЕсли; 
	
	Если Ручная Тогда
		Стр = Стр + Символы.ПС;
		Стр = Стр + "Может использоваться как ручная "+?(ПользователиТипОграничения=Перечисления.ТипыОграниченийПоСписку.Нет,
														"всеми сотрудниками. ",
														"сотрудниками с указанными наборами прав.");
		Если ОтменяетАвтоматические Тогда
			Стр = Стр + " При этом, отменяет действие всех прочих автоматических скидок/наценок.";
		КонецЕсли; 
		
		Стр = Стр + " В качестве автоматической, не имеет дополнительных условий. ";
		
		Возврат Стр;
	КонецЕсли; 
	
	// условия автоматических скидок
	СтрУсл = "";
	
	// ограничение по доставке
	Если Доставка = 1 Тогда
		СтрУсл = СтрУсл + Символы.ПС + "кроме доставки;"+Символы.ПС;
	ИначеЕсли Доставка = 2 Тогда
		СтрУсл = СтрУсл + Символы.ПС + "только на доставку;"+Символы.ПС;
	КонецЕсли; 
	
	// ограничение действия из Гостя
	Если ТолькоИзГостя Тогда
		Стр = Стр + Символы.ПС + "только при заказе из гостевого приложения."+Символы.ПС;
	КонецЕсли; 
	
	// условие по месту реализации
	Если ТипОграниченияМестРеализации <> Перечисления.ТипыОграниченийПоСписку.Нет Тогда
		СтрМР = "";
		Для каждого МР Из СписокМестРеализации Цикл
			Если МР.Пометка Тогда
				СтрМР = СтрМР + ?(ПустаяСтрока(СтрМР), "", ", ") + МР.Значение;
			КонецЕсли; 
		КонецЦикла; 
		
		Если НЕ ПустаяСтрока(СтрМР) И ТипОграниченияМестРеализации = Перечисления.ТипыОграниченийПоСписку.Включить Тогда
			СтрУсл = СтрУсл + "только в месте реализации " + СтрМР + ";"+Символы.ПС;
		ИначеЕсли НЕ ПустаяСтрока(СтрМР) И КлиентТипОграниченияКатегорий = Перечисления.ТипыОграниченийПоСписку.Исключить Тогда
			СтрУсл = СтрУсл + "кроме мест реализации " + СтрМР + ";"+Символы.ПС;
		КонецЕсли; 
			
	КонецЕсли; 
	
	// условия по дате, времени, дням недели
	Если ФлагДата1 И ЗначениеЗаполнено(Дата1) И ФлагДата2 И ЗначениеЗаполнено(Дата2) Тогда
		Если Дата1 > Дата2 Тогда
			ФлагНекорректныеПараметры = Истина;
			Возврат "НЕКОРРЕКТНЫЙ диапазон дат!";
		КонецЕсли; 
		СтрУсл = СтрУсл + "в период с " + Формат(Дата1,"ДЛФ=Д") + " по " + Формат(Дата2,"ДЛФ=Д") + "; "+Символы.ПС;
		
	ИначеЕсли ФлагДата1 И ЗначениеЗаполнено(Дата1) Тогда
		СтрУсл = СтрУсл + "начиная с " + Формат(Дата1,"ДЛФ=Д") + "; "+Символы.ПС;
	ИначеЕсли ФлагДата2 И ЗначениеЗаполнено(Дата2) Тогда
		СтрУсл = СтрУсл + "до " + Формат(Дата2,"ДЛФ=Д") + " включительно; "+Символы.ПС;
	КонецЕсли; 
	
	Если ФлагВремя1 И ЗначениеЗаполнено(Время1) И ФлагВремя2 И ЗначениеЗаполнено(Время2) Тогда
		СтрУсл = СтрУсл + "время с " + Формат(Время1,"ДФ=ЧЧ:мм") + " по " + Формат(Время2,"ДФ=ЧЧ:мм") + ";"+Символы.ПС;
	ИначеЕсли ФлагВремя1 И ЗначениеЗаполнено(Время1) Тогда
		СтрУсл = СтрУсл + "после " + Формат(Время1,"ДФ=ЧЧ:мм") + ";"+Символы.ПС;
	ИначеЕсли ФлагВремя2 И ЗначениеЗаполнено(Время2) Тогда
		СтрУсл = СтрУсл + "до " + Формат(Время2,"ДФ=ЧЧ:мм") + ";"+Символы.ПС;
	КонецЕсли; 
	
	Если ФлагДниНедели Тогда
		СтрДН = "";
		Для каждого ДН Из СписокДниНедели Цикл
			Если ДН.Пометка Тогда
				СтрДН = СтрДН + ?(ПустаяСтрока(СтрДН), "", ",") + ДН.Значение;
			КонецЕсли; 
		КонецЦикла; 
		Если НЕ ПустаяСтрока(СтрДН) Тогда
			СтрУсл = СтрУсл + "дни недели: " + ВРег(СтрДН) + ";"+Символы.ПС;
		КонецЕсли; 
	КонецЕсли; 
	
	// НЕКОРРЕКТНОЕ сочетание параметров
	Если СуммаВидУсловия=1 И (Колво1>0 ИЛИ Сумма1>0) И ОборотВидУсловия=1 И ОборотГраница1>0 Тогда
		ФлагНекорректныеПараметры = Истина;
		Возврат "НЕКОРРЕКТНОЕ сочетание параметров!
				|Тип условия ""Предоставить за каждые"" не может быть выбран одновременно для суммы и оборота!";
	КонецЕсли; 
	
	Если СуммаТип=1 ИЛИ ОборотТип=1 ИЛИ ПодарокТакойЖе ИЛИ ЗначениемЯвляетсяЦена Тогда
		Стр = Стр + Символы.ПС;
		Стр = Стр + "ВНИМАНИЕ! Может использоваться только как скидка/наценка на товар или категорию товаров.";
	КонецЕсли; 
	
	// условия по количеству и сумме
	Если СуммаВидУсловия=0 Тогда
		
		// диапазон значений
		Если СуммаТип=0 Тогда
			СтрТипСуммы = "сумма заказа";
			СтрТипКолво = "суммарное количество";
		ИначеЕсли СуммаТип=1 Тогда
			СтрТипСуммы = "сумма товара";
			СтрТипКолво = "количество товара";
		ИначеЕсли СуммаТип=2 Тогда
			СтрТипСуммы = "сумма указаных товаров";
			СтрТипКолво = "количество указаных товаров";
		ИначеЕсли СуммаТип=3 Тогда
			СтрТипСуммы = "сумма указанных категорий";
			СтрТипКолво = "количество указанных категорий";
		КонецЕсли; 
		
		Если ФлагКолво1 И Колво1>0 И ФлагКолво2 И Колво2>0 Тогда
			Если Колво1 > Колво2 Тогда
				ФлагНекорректныеПараметры = Истина;
				Возврат "НЕКОРРЕКТНЫЙ диапазон количества!";
			КонецЕсли; 
			СтрУсл = СтрУсл + СтрТипКолво + " от " + Колво1 + " до " + Колво2 + ";"+Символы.ПС;
			
		ИначеЕсли ФлагКолво1 И Колво1>0 Тогда
			СтрУсл = СтрУсл + СтрТипКолво + " не менее " + Колво1 + ";"+Символы.ПС;
		ИначеЕсли ФлагКолво2 И Колво2>0 Тогда
			СтрУсл = СтрУсл + СтрТипКолво + " не более " + Колво2 + ";"+Символы.ПС;
		КонецЕсли; 
		
		Если ФлагСумма1 И Сумма1>0 И ФлагСумма2 И Сумма2>0 Тогда
			Если Сумма1 > Сумма2 Тогда
				ФлагНекорректныеПараметры = Истина;
				Возврат "НЕКОРРЕКТНЫЙ диапазон сумм!";
			КонецЕсли; 
			СтрУсл = СтрУсл + СтрТипСуммы + " от " + ФорматСумм(Сумма1) + " до " + ФорматСумм(Сумма2) + ";"+Символы.ПС;
			
		ИначеЕсли ФлагСумма1 И Сумма1>0 Тогда
			СтрУсл = СтрУсл + СтрТипСуммы + " не менее " + ФорматСумм(Сумма1) + ";"+Символы.ПС;
		ИначеЕсли ФлагСумма2 И Сумма2>0 Тогда
			СтрУсл = СтрУсл + СтрТипСуммы + " не более " + ФорматСумм(Сумма2) + ";"+Символы.ПС;
		КонецЕсли; 
		
	ИначеЕсли СуммаВидУсловия=1 И (Колво1>0 ИЛИ Сумма1>0) Тогда
		
		// за каждые...
		Если СуммаТип=0 Тогда
			СтрТипСуммы = "в заказе всего";
		ИначеЕсли СуммаТип=1 Тогда
			СтрТипСуммы = "текущего товара";
		ИначеЕсли СуммаТип=2 Тогда
			СтрТипСуммы = "указаных товаров";
		ИначеЕсли СуммаТип=3 Тогда
			СтрТипСуммы = "указанных категорий";
		КонецЕсли; 
		
		СтрУсл = СтрУсл + "предоставляется за каждые " + ?(Колво1>0, Строка(Колво1)+" ед. количества", "") 
													   + ?(Колво1>0 И Сумма1>0, " ИЛИ ", "") 
													   + ?(Сумма1>0, ФорматСумм(Сумма1)+" руб.", "") + " " + СтрТипСуммы + ";"+Символы.ПС;
		
	КонецЕсли; 
	
	// условия по обороту
	Если ОборотВидУсловия=0 Тогда
		
		// диапазон значений
		Если ОборотТипПериода=0 Тогда
			СтрТипПериода = "суммарный ";
		Иначе
			СтрТипПериода = "за предыдущие "+ОборотКолвоМесяцев+" календарных месяцев ";
		КонецЕсли; 
		
		Если ОборотТипРесурса=2 Тогда
			СтрТипОборота = "количество посещений клиента";
		Иначе
			СтрТипОборота = ?(ОборотТипРесурса=1, "количественный ", "");
			Если ОборотТип=0 Тогда
				СтрТипОборота = "оборот клиента";
			ИначеЕсли ОборотТип=1 Тогда
				СтрТипОборота = "оборот клиента по текущему товару";
			ИначеЕсли ОборотТип=2 Тогда
				СтрТипОборота = "оборот клиента по указанным товарам";
			ИначеЕсли ОборотТип=3 Тогда
				СтрТипОборота = "оборот клиента по указанным категориям";
			КонецЕсли; 
		КонецЕсли; 
		
		Если ФлагОборот1 И ОборотГраница1>0 И ФлагОборот2 И ОборотГраница2>0 Тогда
			Если ОборотГраница1 > ОборотГраница2 Тогда
				ФлагНекорректныеПараметры = Истина;
				Возврат "НЕКОРРЕКТНЫЙ диапазон оборотов!";
			КонецЕсли; 
			СтрУсл = СтрУсл + СтрТипПериода + СтрТипОборота + " от " + ОборотГраница1 + " до " + ОборотГраница2 + ";"+Символы.ПС;
			
		ИначеЕсли ФлагОборот1 И ОборотГраница1>0 Тогда
			СтрУсл = СтрУсл + СтрТипПериода + СтрТипОборота + " не менее " + ОборотГраница1 + ";"+Символы.ПС;
		ИначеЕсли ФлагОборот2 И ОборотГраница2>0 Тогда
			СтрУсл = СтрУсл + СтрТипПериода + СтрТипОборота + " не более " + ОборотГраница2 + ";"+Символы.ПС;
		КонецЕсли; 
		
	ИначеЕсли ОборотВидУсловия=1 И ОборотГраница1>0 Тогда
		
		// за каждые...
		Если ОборотТипРесурса=2 Тогда
			СтрТипОборота = "посещений клиента";
		Иначе
			СтрТипОборота = ?(ОборотТипРесурса=1, "ед. количества ", "руб. ");
			Если ОборотТип=0 Тогда
				СтрТипОборота = СтрТипОборота + "оборота клиента";
			ИначеЕсли ОборотТип=1 Тогда
				СтрТипОборота = СтрТипОборота + "оборота клиента по текущему товару";
			ИначеЕсли ОборотТип=2 Тогда
				СтрТипОборота = СтрТипОборота + "оборота клиента по указанным товарам";
			ИначеЕсли ОборотТип=3 Тогда
				СтрТипОборота = СтрТипОборота + "оборота клиента по указанным категориям";
			КонецЕсли; 
		КонецЕсли; 
		
		СтрУсл = СтрУсл + "предоставляется за каждые " + ОборотГраница1 + " " + СтрТипОборота + ";"+Символы.ПС;
		
	ИначеЕсли ОборотВидУсловия=2 И ОборотГраница1>0 Тогда
		
		// действует в каждом...
		СтрУсл = СтрУсл + "дествует в каждом " + ОборотГраница1 + " заказе;"+Символы.ПС;
		
	КонецЕсли; 
	
	// условия по клиенту
	Если КлиентТипОграниченияКатегорий <> Перечисления.ТипыОграниченийПоСписку.Нет Тогда
		СтрКК = "";
		Для каждого КК Из КатегорииКлиентов Цикл
			Если КК.Пометка Тогда
				СтрКК = СтрКК + ?(ПустаяСтрока(СтрКК), "", ", ") + КК.Значение;
			КонецЕсли; 
		КонецЦикла; 
		
		Если НЕ ПустаяСтрока(СтрКК) И КлиентТипОграниченияКатегорий = Перечисления.ТипыОграниченийПоСписку.Включить Тогда
			СтрУсл = СтрУсл + "только клиентам категорий " + СтрКК + ";"+Символы.ПС;
		ИначеЕсли НЕ ПустаяСтрока(СтрКК) И КлиентТипОграниченияКатегорий = Перечисления.ТипыОграниченийПоСписку.Исключить Тогда
			СтрУсл = СтрУсл + "кроме клиентов категорий " + СтрКК + ";"+Символы.ПС;
		КонецЕсли; 
			
	КонецЕсли; 
	
	Если КлиентДеньРождения Тогда
		СтрУсл = СтрУсл + "в день рождения клиента" + ?(КлиентДеньРожденияПлюсМинус=0,"",", +/- дней: "+КлиентДеньРожденияПлюсМинус) + "; ";
	КонецЕсли; 
	Если ФлагКлиентПол И ЗначениеЗаполнено(КлиентПол) Тогда
		СтрУсл = СтрУсл + "только " +?(КлиентПол=Перечисления.ПолКлиента.Мужской, "мужчинам", "женщинам")+ ".";
	КонецЕсли; 
	
	Стр = Стр + Символы.ПС;
	Стр = Стр + ?(ПустаяСтрока(СтрУсл), "Дополнительных условий не имеет.", "Условия действия:" + Символы.ПС + СтрУсл);
	
	Возврат Стр;
КонецФункции
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	УправлениеРИБ.ПередОткрытиемЭлементаСправочника(ЭтотОбъект, ЭтаФорма, Отказ, СтандартнаяОбработка);
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если ЭтоНовый() И НЕ ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда 
		ПравилоОкругления				= Константы.ОсновноеПравилоОкругления.Получить();
	   	ТипОграниченияКатегорий			= Перечисления.ТипыОграниченийПоСписку.Нет;
	   	ПользователиТипОграничения		= Перечисления.ТипыОграниченийПоСписку.Нет;
	   	КлиентТипОграниченияКатегорий	= Перечисления.ТипыОграниченийПоСписку.Нет;
	   	ТипОграниченияМестРеализации	= Перечисления.ТипыОграниченийПоСписку.Нет;
	КонецЕсли;
	
	Если Подарок Тогда
		ТипЗначения = ?(ПодарокНаВыбор, "ПодарокНаВыбор", ?(ПодарокТакойЖе, "ПодарокТакойЖе", "Подарок") );
	ИначеЕсли ПереключитьТипЦен Тогда
		ТипЗначения = "ТипЦен";
	Иначе
		ТипЗначения = ?(Бонусная, "Бонус", ?(Значение<=0, "Скидка", "Наценка")) + ?(Суммовая, "Сумма", "Процент");
		ЗначениеСкидки = Модуль(Значение);
	КонецЕсли; 
	
	Если НЕ Константы.НакопительныеСкидки.Получить() Тогда
		ЭлементыФормы.ПанельУсловия.Страницы.Оборот.Видимость = Ложь;
	КонецЕсли; 
	
	Если Подарок Тогда
		// для подарка на выбор количество у всех должно быть одинаковое, устанавливается в 1, иначе сложно учитывать в Заказе
		ЭлементыФормы.Подарки.Колонки.Количество.Доступность= НЕ ПодарокНаВыбор;
		ЭлементыФормы.Подарки.Подвал						= НЕ ПодарокНаВыбор;
	КонецЕсли; 
	
	ФлагДата1		= ЗначениеЗаполнено(Дата1);
	ФлагДата2		= ЗначениеЗаполнено(Дата2);
	ФлагВремя1		= ЗначениеЗаполнено(Время1);
	ФлагВремя2		= ЗначениеЗаполнено(Время2);
	ФлагКолво1		= ЗначениеЗаполнено(Колво1);
	ФлагКолво2		= ЗначениеЗаполнено(Колво2);
	ФлагСумма1		= ЗначениеЗаполнено(Сумма1);
	ФлагСумма2		= ЗначениеЗаполнено(Сумма2);
	ФлагОборот1		= ЗначениеЗаполнено(ОборотГраница1);
	ФлагОборот2		= ЗначениеЗаполнено(ОборотГраница2);
	ФлагКлиентПол	= ЗначениеЗаполнено(КлиентПол);
	
	ФлагДниНедели	= ЗначениеЗаполнено(ДниНедели);
	ИнтерфейсАдмина.ЗаполнитьСписокДнейНедели(СписокДниНедели, ДниНедели);
	
	ИнтерфейсАдмина.ЗаполнитьСписокПометокПоТабЧасти(КатегорииТоваров,		ДопустимыеКатегории,"Категория");
	ИнтерфейсАдмина.ЗаполнитьСписокПометокПоТабЧасти(ГруппыПользователей,	ДопустимыеГруппыПользователей,"НаборПрав");
	ИнтерфейсАдмина.ЗаполнитьСписокПометокПоТабЧасти(КатегорииКлиентов,		КлиентКатегории,"Категория");
	ИнтерфейсАдмина.ЗаполнитьСписокПометокПоТабЧасти(СписокМестРеализации,	МестаРеализации,"Место");
	
	Если глВерсия=1 ИЛИ НЕ Константы.ДопЯзыки.Получить() Тогда
	    ЭлементыФормы.Панель1.Страницы.ДопНаименования.Видимость = Ложь;
	КонецЕсли;
	Если НЕ ЗначениеЗаполнено(ПараметрОбъектКопирования) Тогда
		ИнтерфейсАдмина.ЗаполнитьДопНаименования(Ссылка,ТаблицаДопНаименования);
	Иначе
		ИнтерфейсАдмина.ЗаполнитьДопНаименования(ПараметрОбъектКопирования,ТаблицаДопНаименования);
	КонецЕсли;

	Попытка
		ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы[ВосстановитьЗначение("ТекущаяСтраницаСкидки")];
	Исключение
	КонецПопытки;
			
КонецПроцедуры

Процедура ПриЗакрытии()
	
	СохранитьЗначение("ТекущаяСтраницаСкидки", ЭлементыФормы.Панель1.ТекущаяСтраница.Имя);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ФлагНекорректныеПараметры Тогда
		Предупреждение("Некорректные параметры!");
		Отказ = Истина;
		Возврат;
	КонецЕсли; 
	
	Значение = ?(Найти(ТипЗначения, "Скидка"), -ЗначениеСкидки, ЗначениеСкидки);
	
	Дата1	= ?(ФлагДата1 , Дата1 , Неопределено);
	Дата2	= ?(ФлагДата2 , Дата2 , Неопределено);
	Время1	= ?(ФлагВремя1, Время1, Неопределено);
	Время2	= ?(ФлагВремя2, Время2, Неопределено);
	
	ДниНедели = ?(ФлагДниНедели, ИнтерфейсАдмина.СписокПометокВЧисло(СписокДниНедели), Неопределено);
	
	Если СуммаВидУсловия=0 Тогда
		Колво1	= ?(ФлагКолво1, Колво1, 0);
		Колво2	= ?(ФлагКолво2, Колво2, 0);
		Сумма1	= ?(ФлагСумма1, Сумма1, 0);
		Сумма2	= ?(ФлагСумма2, Сумма2, 0);
	Иначе
		Колво2	= 0;
		Сумма2	= 0;
	КонецЕсли; 
	
	Если ОборотВидУсловия=0 Тогда
		ОборотГраница1 = ?(ФлагОборот1, ОборотГраница1, 0);
		ОборотГраница2 = ?(ФлагОборот2, ОборотГраница2, 0);
	Иначе
		ОборотГраница2 = 0;
	КонецЕсли; 
	
	КлиентПол = ?(ФлагКлиентПол, КлиентПол, Неопределено);
	
	Если ТипОграниченияКатегорий = Перечисления.ТипыОграниченийПоСписку.Нет Тогда
		ДопустимыеКатегории.Очистить();
	Иначе
		ИнтерфейсАдмина.ЗаполнитьТабЧастьПоСпискуПометок(КатегорииТоваров,ДопустимыеКатегории,"Категория");
		Если ДопустимыеКатегории.Количество()=0 Тогда
			ТипОграниченияКатегорий	= Перечисления.ТипыОграниченийПоСписку.Нет;
		КонецЕсли; 
	КонецЕсли; 
	
	Если КлиентТипОграниченияКатегорий = Перечисления.ТипыОграниченийПоСписку.Нет Тогда
		КлиентКатегории.Очистить();
	Иначе
		ИнтерфейсАдмина.ЗаполнитьТабЧастьПоСпискуПометок(КатегорииКлиентов,КлиентКатегории,"Категория");
		Если КлиентКатегории.Количество()=0 Тогда
			КлиентТипОграниченияКатегорий	= Перечисления.ТипыОграниченийПоСписку.Нет;
		КонецЕсли; 
	КонецЕсли; 
	
	Если ТипОграниченияМестРеализации = Перечисления.ТипыОграниченийПоСписку.Нет Тогда
		МестаРеализации.Очистить();
	Иначе
		ИнтерфейсАдмина.ЗаполнитьТабЧастьПоСпискуПометок(СписокМестРеализации,МестаРеализации,"Место");
		Если МестаРеализации.Количество()=0 Тогда
			ТипОграниченияМестРеализации	= Перечисления.ТипыОграниченийПоСписку.Нет;
		КонецЕсли; 
	КонецЕсли; 
	
	Если НЕ Ручная ИЛИ ПользователиТипОграничения = Перечисления.ТипыОграниченийПоСписку.Нет Тогда
		ДопустимыеГруппыПользователей.Очистить();
	Иначе
		ИнтерфейсАдмина.ЗаполнитьТабЧастьПоСпискуПометок(ГруппыПользователей,ДопустимыеГруппыПользователей,"НаборПрав");
		Если ДопустимыеГруппыПользователей.Количество()=0 Тогда
			ПользователиТипОграничения	= Перечисления.ТипыОграниченийПоСписку.Нет;
		КонецЕсли; 
	КонецЕсли; 
	
	// проще чтоб не повторялись
	Подарки.Свернуть("Товар","Количество");
	
	Если ПодарокНаВыбор Тогда
		Для каждого СтрокаПодарка Из Подарки Цикл
			СтрокаПодарка.Количество = 1;
		КонецЦикла; 
	КонецЕсли; 
	
	Если Ручная Тогда
		ТолькоИзГостя = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	ИнтерфейсАдмина.ЗаписатьДопНаименования(Ссылка,ТаблицаДопНаименования);
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	ЭлементыФормы.Панель1.Страницы.Допуск		.Видимость = Ручная;
	ЭлементыФормы.Панель1.Страницы.Условия		.Видимость = НЕ Ручная;
	ЭлементыФормы.Панель1.Страницы.Категории	.Видимость = НЕ Подарок;
	
	Если ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Основное Тогда
		
		ЭлементыФормы.ЗначениемЯвляетсяЦена.Видимость = (ТипЗначения = "СкидкаСумма");
		
		Если ПодарокТакойЖе Тогда
			ЭлементыФормы.ПанельТипСкидки.ТекущаяСтраница = ЭлементыФормы.ПанельТипСкидки.Страницы.ПодарокТакойЖе;
			
		ИначеЕсли Подарок Тогда
			ЭлементыФормы.ПанельТипСкидки.ТекущаяСтраница = ЭлементыФормы.ПанельТипСкидки.Страницы.Подарок;
			ЭлементыФормы.РамкаПодарки.Заголовок = ?(ПодарокНаВыбор, "Подарок на выбор", "Набор подарков");
			
		ИначеЕсли ЗначениемЯвляетсяЦена Тогда
			ЭлементыФормы.ПанельТипСкидки.ТекущаяСтраница = ЭлементыФормы.ПанельТипСкидки.Страницы.ЗначениеЦена;
			
		Иначе
			ЭлементыФормы.ПанельТипСкидки.ТекущаяСтраница = ЭлементыФормы.ПанельТипСкидки.Страницы.Обычная;
			ЭлементыФормы.ПанельЗначение.ТекущаяСтраница = ЭлементыФормы.ПанельЗначение.Страницы[?(ПереключитьТипЦен,"ТипЦен","ПроцентСумма")];
			ЭлементыФормы.тЗначение.Заголовок = ?(Суммовая, "Сумма:", "Процент:");
			ЭлементыФормы.Ручная.Видимость = НЕ Бонусная И НЕ Подарок;
			ЭлементыФормы.ОтменяетАвтоматические.Видимость = Ручная;
			
		КонецЕсли; 
	
	ИначеЕсли ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Допуск Тогда
		Флаг = ПользователиТипОграничения <> Перечисления.ТипыОграниченийПоСписку.Нет;
		ЭлементыФормы.ГруппыПользователей.Доступность					= Флаг;
		ЭлементыФормы.КоманднаяПанельГруппыПользователей.Доступность	= Флаг;
		
	ИначеЕсли ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Категории Тогда
		Флаг = ТипОграниченияКатегорий <> Перечисления.ТипыОграниченийПоСписку.Нет;
		ЭлементыФормы.КатегорииТоваров.Доступность					= Флаг;
		ЭлементыФормы.КоманднаяПанельКатегорииТоваров.Доступность	= Флаг;
		
	ИначеЕсли ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы.Условия Тогда
		
		Если ЭлементыФормы.ПанельУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельУсловия.Страницы.Время Тогда
			ЭлементыФормы.Дата1 .Доступность = ФлагДата1;
			ЭлементыФормы.Дата2 .Доступность = ФлагДата2;
			ЭлементыФормы.Время1.Доступность = ФлагВремя1;
			ЭлементыФормы.Время2.Доступность = ФлагВремя2;
			ЭлементыФормы.СписокДниНедели.Доступность = ФлагДниНедели;
			ЭлементыФормы.КоманднаяПанельДниНедели.Доступность = ФлагДниНедели;
		
		ИначеЕсли ЭлементыФормы.ПанельУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельУсловия.Страницы.КолвоСумма Тогда
			Если СуммаВидУсловия=0 Тогда
				ЭлементыФормы.ПанельСуммаВидУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельСуммаВидУсловия.Страницы.Диапазон;
				ЭлементыФормы.Колво1.Доступность = ФлагКолво1;
				ЭлементыФормы.Колво2.Доступность = ФлагКолво2;
				ЭлементыФормы.Сумма1.Доступность = ФлагСумма1;
				ЭлементыФормы.Сумма2.Доступность = ФлагСумма2;
			Иначе
				ЭлементыФормы.ПанельСуммаВидУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельСуммаВидУсловия.Страницы.ЗаКаждые;
			КонецЕсли;
			
			ЭлементыФормы.СуммаТовары.Видимость						= СуммаТип=2;
			ЭлементыФормы.КоманднаяПанельСуммаТовары.Видимость		= СуммаТип=2;
			ЭлементыФормы.СуммаКатегории.Видимость					= СуммаТип=3;
			ЭлементыФормы.КоманднаяПанельСуммаКатегории.Видимость	= СуммаТип=3;
			
		ИначеЕсли ЭлементыФормы.ПанельУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельУсловия.Страницы.Оборот Тогда
			Если ОборотВидУсловия=0 Тогда
				ЭлементыФормы.ПанельОборотВидУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельОборотВидУсловия.Страницы.Диапазон;
				ЭлементыФормы.ОборотГраница1.Доступность = ФлагОборот1;
				ЭлементыФормы.ОборотГраница2.Доступность = ФлагОборот2;
			Иначе
				ЭлементыФормы.ПанельОборотВидУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельОборотВидУсловия.Страницы.ЗаКаждые;
				Если ОборотВидУсловия=2 И ОборотТипРесурса<>2 Тогда
					// действует в каждом n-ом заказе
					ОборотТипРесурса = 2;
				КонецЕсли;
				Если ОборотТипРесурса=0 Тогда
					ЭлементыФормы.НадписьОборотГраницаИнфо.Заголовок = "руб. оборота за весь период";
				ИначеЕсли ОборотТипРесурса=1 Тогда
					ЭлементыФормы.НадписьОборотГраницаИнфо.Заголовок = "единиц оборота за весь период";
				Иначе
					ЭлементыФормы.НадписьОборотГраницаИнфо.Заголовок = ?(ОборотВидУсловия=2, "заказе", "заказов");
				КонецЕсли; 
			КонецЕсли;
			
			ЭлементыФормы.ОборотТипРесурса.Доступность = ОборотВидУсловия<>2;
			
			ЭлементыФормы.ОборотТип.Видимость						= ОборотТипРесурса<>2;
			ЭлементыФормы.НадписьОборотТип.Видимость				= ОборотТипРесурса<>2;
			Если ОборотТипРесурса=2 И ОборотТип<>0 Тогда
				ОборотТип=0;
			КонецЕсли; 
			
			ЭлементыФормы.ОборотТовары.Видимость					= ОборотТип=2;
			ЭлементыФормы.КоманднаяПанельОборотТовары.Видимость		= ОборотТип=2;
			ЭлементыФормы.ОборотКатегории.Видимость					= ОборотТип=3;
			ЭлементыФормы.КоманднаяПанельОборотКатегории.Видимость	= ОборотТип=3;
			
			ЭлементыФормы.ОборотКолвоМесяцев.Видимость				= ОборотТипПериода=1;
			ЭлементыФормы.НадписьОборотКолвоМесяцев.Видимость		= ОборотТипПериода=1;
			
		ИначеЕсли ЭлементыФормы.ПанельУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельУсловия.Страницы.Клиент Тогда
			Флаг = КлиентТипОграниченияКатегорий <> Перечисления.ТипыОграниченийПоСписку.Нет;
			ЭлементыФормы.КатегорииКлиентов.Доступность					= Флаг;
			ЭлементыФормы.КоманднаяПанельКатегорииКлиентов.Доступность	= Флаг;
			
			ЭлементыФормы.КлиентДеньРожденияПлюсМинус		.Видимость	= КлиентДеньРождения;
			ЭлементыФормы.НадписьКлиентДеньРожденияПлюсМинус.Видимость	= КлиентДеньРождения;
			
			ЭлементыФормы.КлиентПол.Доступность	= ФлагКлиентПол;
			
		ИначеЕсли ЭлементыФормы.ПанельУсловия.ТекущаяСтраница = ЭлементыФормы.ПанельУсловия.Страницы.МестаРеализации Тогда
			Флаг = ТипОграниченияМестРеализации <> Перечисления.ТипыОграниченийПоСписку.Нет;
			ЭлементыФормы.СписокМестРеализации			.Доступность	= Флаг;
			ЭлементыФормы.КоманднаяПанельМестаРеализации.Доступность	= Флаг;
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЭлементыФормы.НадписьОписаниеСкидки.Заголовок = ПолучитьОписаниеСкидки();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура Панель1ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура ПанельУсловияПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура ТипЗначенияПриИзменении(Элемент)
	
	Суммовая = Найти(ТипЗначения, "Сумма");
	Бонусная = Найти(ТипЗначения, "Бонус");
	Подарок  = Найти(ТипЗначения, "Подарок");
	ПодарокНаВыбор = ТипЗначения="ПодарокНаВыбор";
	ПодарокТакойЖе = ТипЗначения="ПодарокТакойЖе";
	ПереключитьТипЦен = ТипЗначения="ТипЦен";
	
	Если Бонусная ИЛИ Подарок Тогда
		Ручная = Ложь;
	КонецЕсли; 
	
	Если ТипЗначения <> "СкидкаСумма" Тогда
		ЗначениемЯвляетсяЦена = Ложь;
	КонецЕсли; 
	
	Если Подарок И НЕ ПодарокТакойЖе Тогда
		// для подарка на выбор количество у всех должно быть одинаковое, устанавливается в 1, иначе сложно учитывать в Заказе
		ЭлементыФормы.Подарки.Колонки.Количество.Доступность= НЕ ПодарокНаВыбор;
		ЭлементыФормы.Подарки.Подвал						= НЕ ПодарокНаВыбор;
		
		Если ПодарокНаВыбор Тогда
			Для каждого СтрокаПодарка Из Подарки Цикл
				СтрокаПодарка.Количество = 1;
			КонецЦикла; 
		КонецЕсли; 
		
	Иначе
		Подарки.Очистить();
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗначениемЯвляетсяЦенаПриИзменении(Элемент)
	
	Если ЗначениемЯвляетсяЦена Тогда
		Ручная				= Ложь;
		ПравилоОкругления	= Неопределено;
		ЗначениеСкидки		= 0;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КоманднаяПанельГруппыПользователейУстановитьФлажки(Кнопка)
	
	ГруппыПользователей.ЗаполнитьПометки(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельГруппыПользователейСнятьФлажки(Кнопка)
	
	ГруппыПользователей.ЗаполнитьПометки(Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельДниНеделиУстановитьФлажки(Кнопка)
	
	СписокДниНедели.ЗаполнитьПометки(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельДниНеделиСнятьФлажки(Кнопка)
	
	СписокДниНедели.ЗаполнитьПометки(Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельКатегорииТоваровУстановитьФлажки(Кнопка)
	
	КатегорииТоваров.ЗаполнитьПометки(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельКатегорииТоваровСнятьФлажки(Кнопка)
	
	КатегорииТоваров.ЗаполнитьПометки(Ложь);
	
КонецПроцедуры

Процедура Время1НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ИнтерфейсАдмина.ВыбратьВремяИзСписка(ЭтаФорма, Элемент);
	
КонецПроцедуры

Процедура Время2НачалоВыбора(Элемент, СтандартнаяОбработка)
	
	ИнтерфейсАдмина.ВыбратьВремяИзСписка(ЭтаФорма, Элемент, Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельСуммаТоварыПодбор(Кнопка)
	
	Форма 							= Справочники.Товары.ПолучитьФормуВыбора(,ЭлементыФормы.СуммаТовары);
	Форма.ЗакрыватьПриВыборе 		= Ложь;
	Форма.ФормаОткрытаДляВыбора 	= Истина;
	Форма.Открыть();
	
КонецПроцедуры

Процедура СуммаТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СуммаТовары.Добавить().Товар = ВыбранноеЗначение;
	
КонецПроцедуры

Процедура КоманднаяПанельСуммаКатегорииПодбор(Кнопка)
	
	Форма = Справочники.КатегорииТоваров.ПолучитьФормуВыбора(,ЭлементыФормы.СуммаКатегории);
	Форма.ЗакрыватьПриВыборе = Ложь;
	Форма.Открыть();
	
КонецПроцедуры

Процедура СуммаКатегорииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	СуммаКатегории.Добавить().Категория = ВыбранноеЗначение;
	
КонецПроцедуры

Процедура КоманднаяПанельОборотТоварыПодбор(Кнопка)
	
	Форма 						= Справочники.Товары.ПолучитьФормуВыбора(,ЭлементыФормы.ОборотТовары);
	Форма.ЗакрыватьПриВыборе 	= Ложь;
	Форма.ФормаОткрытаДляВыбора = Истина;
	Форма.Открыть();
	
КонецПроцедуры

Процедура ОборотТоварыОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОборотТовары.Добавить().Товар = ВыбранноеЗначение;
	
КонецПроцедуры

Процедура КоманднаяПанельОборотКатегорииПодбор(Кнопка)
	
	Форма = Справочники.КатегорииТоваров.ПолучитьФормуВыбора(,ЭлементыФормы.ОборотКатегории);
	Форма.ЗакрыватьПриВыборе = Ложь;
	Форма.Открыть();
	
КонецПроцедуры

Процедура ОборотКатегорииОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	ОборотКатегории.Добавить().Категория = ВыбранноеЗначение;
	
КонецПроцедуры

Процедура КоманднаяПанельКатегорииКлиентовУстановитьФлажки(Кнопка)
	
	КатегорииКлиентов.ЗаполнитьПометки(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельКатегорииКлиентовСнятьФлажки(Кнопка)
	
	КатегорииКлиентов.ЗаполнитьПометки(Ложь);
	
КонецПроцедуры

Процедура КоманднаяПанельПодаркиПодбор(Кнопка)
	
	Форма 						= Справочники.Товары.ПолучитьФормуВыбора(,ЭлементыФормы.Подарки);
	Форма.ЗакрыватьПриВыборе 	= Ложь;
	Форма.ФормаОткрытаДляВыбора = Истина;
	Форма.Открыть();
	
КонецПроцедуры


Процедура ПодаркиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение.ЭтоГруппа Тогда
		Возврат;
	КонецЕсли; 
	
	НоваяСтрока = Подарки.Добавить();
	НоваяСтрока.Товар = ВыбранноеЗначение;
	НоваяСтрока.Количество = 1;
	
КонецПроцедуры

Процедура ПодаркиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока Тогда
		Элемент.ТекущаяСтрока.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры

Процедура ПодаркиПриПолученииДанных(Элемент, ОформленияСтрок)
	
	ТаблицаСЦенами = Подарки.Выгрузить();
	Защита.ПроставитьСтоимостьПодарков( ТаблицаСЦенами );
	
	Для каждого ОформлениеСтроки Из ОформленияСтрок Цикл
		
		СтрТабСЦенами = ТаблицаСЦенами[ОформлениеСтроки.ДанныеСтроки.НомерСтроки-1];
		
		ОформлениеСтроки.Ячейки.Цена.Текст = ФорматСумм( СтрТабСЦенами.Цена );
		ОформлениеСтроки.Ячейки.Сумма.Текст = ФорматСумм( СтрТабСЦенами.Сумма );
		
		ОформлениеСтроки.Ячейки.Цена.ОтображатьТекст = Истина;
		ОформлениеСтроки.Ячейки.Сумма.ОтображатьТекст = Истина;
	КонецЦикла; 
	
	ЭлементыФормы.Подарки.Колонки.Сумма.ТекстПодвала = ФорматСумм( ТаблицаСЦенами.Итог("Сумма") );
	
КонецПроцедуры

Процедура КатегорииКлиентовПриИзмененииФлажка(Элемент)
	
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура КатегорииТоваровПриИзмененииФлажка(Элемент)
	
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура ГруппыПользователейПриИзмененииФлажка(Элемент)
	
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура СписокМестРеализацииПриИзмененииФлажка(Элемент)
	
	ОбновлениеОтображения();
	
КонецПроцедуры

Процедура КоманднаяПанельМестаРеализацииУстановитьФлажки(Кнопка)
	
	СписокМестРеализации.ЗаполнитьПометки(Истина);
	
КонецПроцедуры

Процедура КоманднаяПанельМестаРеализацииСнятьФлажки(Кнопка)
	
	СписокМестРеализации.ЗаполнитьПометки(Ложь);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОСНОВНОЕ ТЕЛО МОДУЛЯ

ТипыЗначения = ЭлементыФормы.ТипЗначения.СписокВыбора;
ТипыЗначения.Добавить("СкидкаПроцент"	,"Скидка %");
ТипыЗначения.Добавить("СкидкаСумма"		,"Скидка суммовая");
ТипыЗначения.Добавить("НаценкаПроцент"	,"Наценка %");
ТипыЗначения.Добавить("НаценкаСумма"	,"Наценка суммовая");
ТипыЗначения.Добавить("ТипЦен"			,"Тип цен");
ТипыЗначения.Добавить("БонусПроцент"	,"Бонус %");
ТипыЗначения.Добавить("БонусСумма"		,"Бонус суммовой");
ТипыЗначения.Добавить("Подарок"			,"Подарок или набор подарков");
ТипыЗначения.Добавить("ПодарокНаВыбор"	,"Подарок на выбор");
ТипыЗначения.Добавить("ПодарокТакойЖе"	,"Такой же в подарок");

ТипыСуммы = ЭлементыФормы.СуммаТип.СписокВыбора;
ТипыСуммы.Добавить(0,"заказу всего");
ТипыСуммы.Добавить(1,"текущему товару");
ТипыСуммы.Добавить(2,"списку товаров...");
ТипыСуммы.Добавить(3,"списку категорий...");

ВидыУсловий = ЭлементыФормы.СуммаВидУсловия.СписокВыбора;
ВидыУсловий.Добавить(0,"по диапазону значений");
ВидыУсловий.Добавить(1,"предоставить за каждые");

ТипыОборота = ЭлементыФормы.ОборотТип.СписокВыбора;
ТипыОборота.Добавить(0,"клиенту общий");
ТипыОборота.Добавить(1,"текущему товару");
ТипыОборота.Добавить(2,"списку товаров...");
ТипыОборота.Добавить(3,"списку категорий...");

ВидыУсловий = ЭлементыФормы.ОборотВидУсловия.СписокВыбора;
ВидыУсловий.Добавить(0,"по диапазону значений");
ВидыУсловий.Добавить(1,"предоставить за каждые");
ВидыУсловий.Добавить(2,"действует в каждом");

ТипыПериода = ЭлементыФормы.ОборотТипПериода.СписокВыбора;
ТипыПериода.Добавить(0,"за весь период");
ТипыПериода.Добавить(1,"за предыдущие...");

ТипыРесурса = ЭлементыФормы.ОборотТипРесурса.СписокВыбора;
ТипыРесурса.Добавить(0,"сумма");
ТипыРесурса.Добавить(1,"количество");
ТипыРесурса.Добавить(2,"количество посещений");

