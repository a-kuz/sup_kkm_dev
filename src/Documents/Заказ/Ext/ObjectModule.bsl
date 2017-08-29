﻿
// Возвращает таблицу оплаты по типам
//
Функция ПолучитьТаблицуОплаты(Протокол) Экспорт
	
	Запрос = Новый Запрос;
	// Разнесем оплату по видам
	Запрос.Текст = "ВЫБРАТЬ
	|	Протокол.Ссылка.Дата КАК Дата,
	|	Протокол.ВариантОплаты КАК ВариантОплаты,
	|	Протокол.Сумма КАК Сумма,
	|	Протокол.СуммаФакт КАК СуммаФакт,
	|	Протокол.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ Таб
	|ИЗ
	|	Документ.ПротоколРасчетов.Протокол КАК Протокол
	|ГДЕ
	|	Протокол.Ссылка.Заказ = &Заказ
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Таб.Дата КАК Дата,
	|	Таб.ВариантОплаты КАК ВариантОплаты,
	|	Таб.Сумма КАК Сумма,
	|	Таб.СуммаФакт КАК СуммаФакт,
	|	Таб.ВариантОплаты.Тип КАК Тип,
	|	Таб.Ссылка КАК ПротоколРасчетов,
	|	""Взнос"" КАК Действие
	|ИЗ
	|	Таб КАК Таб";
	
	Запрос.УстановитьПараметр("Заказ", Ссылка);
	
	Рез = Запрос.Выполнить().Выгрузить();
	Возврат Рез;
	
КонецФункции //ПолучитьТаблицуОплаты()

&НаСервере
Функция ПротоколРасчетовПоЗаказу(Заказ) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	|	ПротоколРасчетов.Ссылка
	|ИЗ
	|	Документ.ПротоколРасчетов КАК ПротоколРасчетов
	|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ПротоколРасчетов.Протокол КАК ПротоколТЧ
	|		ПО ПротоколТЧ.Ссылка = ПротоколРасчетов.Ссылка
	|ГДЕ
	|	ПротоколРасчетов.Заказ = &Заказ
	|	И НЕ ПротоколРасчетов.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПротоколРасчетов.Дата УБЫВ,
	|	ПротоколТЧ.СуммаФакт УБЫВ";
	Запрос.УстановитьПараметр("Заказ", Заказ);
	
	Рез = Запрос.Выполнить();            
	Если Рез.Пустой() Тогда
		Возврат Документы.ПротоколРасчетов.ПустаяСсылка();
	Иначе 
		Возврат Рез.Выгрузить()[0][0];
	КонецЕсли;

КонецФункции

// Добавляет недостающие строки в ТЧ премиальных товаров
Процедура ЗаполнитьПремиальныеТовары(Строки=Неопределено) Экспорт
	Акции = Документы.Акция.ДействующиеАкции(Дата);
	
	Если Строки=Неопределено Тогда
	
		ТаблицаЗаказа = Товары;
	ИНаче
		ТаблицаЗаказа = Строки;
	
	КонецЕсли; 
	
	
	Для каждого Акция Из Акции Цикл
		обАкция = Акция.ПолучитьОбъект();
		тзПремиальныеТовары = обАкция.ПремиальныеТовары.Выгрузить();
		КолПодарков = 0;
		Если обАкция.ТипАкции = Справочники.ТипыАкций.СуммаЗаказа Тогда
			СуммаЗаказа = ТаблицаЗаказа.Итог("Сумма");
			
			КолПодарков = Цел(СуммаЗаказа / обАкция.ПороговаяСумма);
			КолПодарков = Мин(КолПодарков, обАкция.ЛимитПодарков);
		ИначеЕсли обАкция.ТипАкции = Справочники.ТипыАкций.НаборТоваров Тогда
			тзНабор = обАкция.ЦелевыеТовары.Выгрузить();
			тзНабор.Колонки.Добавить("КоличествоФакт", Новый ОписаниеТипов("Число"));
			тзНабор.Колонки.Добавить("КолПодарков",    Новый ОписаниеТипов("Число"));
			Для каждого СтрокаТовар Из ТаблицаЗаказа Цикл
				Если СтрокаТовар.Источник = Перечисления.ИсточникиПозицийЗаказа.Акция Тогда
					Продолжить;
				КонецЕсли;
				
				МС = тзНабор.НайтиСтроки(Новый Структура("Товар",СтрокаТовар.Товар.Номенклатура));
				Если МС.Количество() Тогда
					
					Попытка
						МС[0].КоличествоФакт = МС[0].КоличествоФакт + СтрокаТовар.Количество - СтрокаТовар.КоличествоУдалено;
					Исключение
						МС[0].КоличествоФакт = МС[0].КоличествоФакт + СтрокаТовар.Количество;
					КонецПопытки;
					
					
				КонецЕсли; 
				
				МС = тзНабор.НайтиСтроки(Новый Структура("Товар",СтрокаТовар.Товар));
				Если МС.Количество() Тогда
					
					Попытка
						МС[0].КоличествоФакт = МС[0].КоличествоФакт + СтрокаТовар.Количество - СтрокаТовар.КоличествоУдалено;
					Исключение
						МС[0].КоличествоФакт = МС[0].КоличествоФакт + СтрокаТовар.Количество;
					КонецПопытки;
					
				КонецЕсли; 

				
			КонецЦикла; 
			
			Для каждого Т Из тзНабор Цикл
				
				Т.КолПодарков = Цел(Т.КоличествоФакт / Т.Количество);
				
			КонецЦикла; 
			
			тзНабор.Сортировать("КолПодарков");
			КолПодарков = тзНабор[0].КолПодарков;
			
			Для каждого Т Из тзНабор Цикл
				
				т.КолПодарков = КолПодарков;
				
			КонецЦикла; 
		КонецЕсли;
		
		Если КолПодарков Тогда
			тзПремиальныеТовары.Колонки.Добавить("КолУжеДобавлено", Новый ОписаниеТипов("Число"));
			Для каждого СтрокаТоварАкции Из тзПремиальныеТовары Цикл
				МС = ПремиальныеТовары.НайтиСтроки(Новый Структура("Товар, Акция",СтрокаТоварАкции.Товар, Акция));			
				Для каждого Т Из МС Цикл
					
					СтрокаТоварАкции.КолУжеДобавлено = СтрокаТоварАкции.КолУжеДобавлено + Т.Количество;
					
				КонецЦикла; 
				
				Если СтрокаТоварАкции.КолУжеДобавлено < СтрокаТоварАкции.Количество*КолПодарков Тогда
					
					Нов = ПремиальныеТовары.Добавить();
					Нов.Товар = СтрокаТоварАкции.Товар;
					Нов.Акция = Акция;
					Нов.Цена = СтрокаТоварАкции.Цена;
					Нов.Количество = СтрокаТоварАкции.Количество * (КолПодарков-СтрокаТоварАкции.КолУжеДобавлено);
					Нов.Статус = Справочники.СтатусыОбработкиПремиальныхТоваров.Новый;
					
				КонецЕсли;
			КонецЦикла; 
		КонецЕсли; 
	КонецЦикла; 
	ПремиальныеТовары.Свернуть("Товар,Акция,Статус,Цена","Количество");
КонецПроцедуры

// Процедура проверяет измененные строки заказа на предмет блокировки по фирме
// TODO
Процедура ПроверитьБлокировки(Отказ) Экспорт
	
	//МассивТекФирм = Товары.Выгрузить().Свернуть("Фирма");
	//МассивФирмВБД = Ссылка.Товары.Выгрузить().Свернуть("Фирма");
	//Для Каждого Т Из МассивТекФирм Цикл
	//		
	//КонецЦикла;
	//
КонецПроцедуры


Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	глОтладкаУровень = глОтладкаУровень;
	ПроверитьБлокировки(Отказ);
	
	Если Не ЗначениеЗаполнено(Смена) Тогда
		Если ЗначениеЗаполнено(КассоваяСмена) Тогда
			Смена = КассоваяСмена.СменаТТ;
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЭтоНовый() Тогда
		//Если ЗначениеЗаполнено(Ссылка.НомерКартыЛояльности) Тогда
			Если Ссылка.НомерКартыЛояльности <> НомерКартыЛояльности Тогда
				Если Ссылка.Товары.Найти(1, "СтатусОплаты") <> Неопределено Тогда
					НомерКартыЛояльности = ссылка.НомерКартыЛояльности;
					ЗаписьЖурналаРегистрации("Попытка изменить Номер карты лояльности в заказе с оплаченными строками",УровеньЖурналаРегистрации.Ошибка,,Ссылка,"" + Ссылка.НомерКартыЛояльности + " -> " + НомерКартыЛояльности);
				КонецЕсли;
			КонецЕсли;
		//КонецЕсли;
	КонецЕсли;
	
	#Область ПроверкаИзмененияНомераЧека
	Если Не ЭтоНовый() Тогда
		Попытка
			БылНомерЧека = Ссылка.НомерЧека;	
		Исключение
			БылНомерЧека = 0;
		КонецПопытки;
		
		Если БылНомерЧека Тогда
			Если НомерЧека <> БылНомерЧека Тогда
				ЗаписьЖурналаРегистрации("Заказ.Изменение номера чека", УровеньЖурналаРегистрации.Ошибка, ,Ссылка, "Был номер чека: " + БылНомерЧека + ", стал номер чека: " + НомерЧека);
			КонецЕсли;
			Если Не НомерЧека Тогда
				НомерЧека = БылНомерЧека;
				НомерСмены = Ссылка.НомерСмены;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	#КонецОбласти
	
	Если Не МестоРеализации = Справочники.МестаРеализации.Ресторан Тогда
		Если Товары.Количество() Тогда
			Если ЗначениеЗаполнено(Товары[0].Автор) Тогда
				Автор = Товары[0].Автор;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Если Год(ДатаРождения) > 2500 Тогда
		ДатаРождения = '00010101';
	КонецЕсли;
	
	ИтоговаяСумма = Товары.Итог("СуммаРеализации");
	ИтогоСумма = Товары.Итог("Сумма");
	глРабочееМесто = глРабочееМесто;
	Если МестоРеализации.Пустая() Тогда
		Если ЗначениеЗаполнено(глРабочееМесто) Тогда
			МестоРеализации = глРабочееМесто.МестоРеализации;
		КонецЕсли;
	КонецЕсли;
	
	Для каждого Т Из Товары Цикл
		Если Не ЗначениеЗаполнено(Т.ИдСтроки) Тогда
			Т.ИдСтроки = идСтроки(Т.НомерСтроки);
			Т.АвтоПозиция = 1;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Т.ВремяДобавления) Тогда
			Т.ВремяДобавления = ТекущаяДатаНаСервере();
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Т.Фирма) Тогда
			Если ЗначениеЗаполнено(глРабочееМесто) Тогда
				Т.Фирма = глРабочееМесто.Фирма;	
			КонецЕсли;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Т.СтавкаНДС) Тогда
			Т.СтавкаНДС = Т.Товар.Категория.СтавкаНДС;
			ПроцентНДС = ОбщегоНазначенияПовтИсп.ЗначениеСтавкиНДС(Т.СтавкаНДС);
			Т.СуммаНДС = (Т.СуммаРеализации * ПроцентНДС)/(100+ПроцентНДС);
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(Т.РабочееМесто) Тогда
			Т.РабочееМесто = глРабочееМесто;	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПересчетНДС() Экспорт
	Для Каждого Т Из Товары Цикл
		Т.СтавкаНДС = Т.Товар.Категория.СтавкаНДС;
		ПроцентНДС = ОбщегоНазначенияПовтИсп.ЗначениеСтавкиНДС(Т.СтавкаНДС);
		Т.СуммаНДС = (Т.СуммаРеализации * ПроцентНДС)/(100+ПроцентНДС);
	КонецЦикла;
КонецПроцедуры

Функция идСтроки(НомерСтроки) Экспорт
	Возврат "" + ПараметрыСеанса.ТекущаяИБ.Код + "_" + СокрЛП(Номер) + "_" + НомерСтроки;
КонецФункции

Процедура ПриЗаписи(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПометкаУдаления Тогда
		НЗ = РегистрыСведений.ЗаказДопИнф.СоздатьМенеджерЗаписи();
		НЗ.Заказ = Ссылка;
		НЗ.Прочитать();
		Если НЗ.Статус <> Перечисления.СтатусыЗаказа.Удален Тогда
			НЗ.Заказ = ссылка;
			НЗ.Статус = Перечисления.СтатусыЗаказа.Удален;
			НЗ.Записать(Истина);
		КонецЕсли;
		Если Не ЭтоНовый() Тогда
			Попытка
				ЛояльностьКлиентСервер.ОбработатьУдалениеЧека(Ссылка)	
			Исключение
				ЗарегистрироватьСобытие("Ошибка ЛояльностьКлиентСервер.ОбработатьУдалениеЧека",УровеньЖурналаРегистрации.Ошибка,,Ссылка,ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если не Отказ и ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		Если глПараметрыРМ = Неопределено или НЕ глПараметрыРМ.ККМЕсть Тогда
			Спр = РабочееМесто;
			ИмяФайла = ПолучитьИмяВременногоФайла("txt");
			ЗаписатьОбъектВФайл(ИмяФайла,ЭтотОбъект);
			Профиль = Спр.ПрофильВхода;
			Поз = СтрНайти(Профиль,"\",НаправлениеПоиска.СКонца);
			СтрПуть = Лев(Профиль,Поз-1);
			Наим = Сред(СтрПуть,3);
			Сеть.ПодключитьШару(Наим);
			СтрПуть = СтрПуть + "\";
			Каталог = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ПараметрыСеанса.ТекущаяИБ, "ПутьДляЛогирования");//Константы.ПутьДляЛогирования.Получить();
			Если Каталог = Неопределено Тогда
				Каталог = Константы.ПутьДляЛогирования.Получить();
			КонецЕсли;
			СтрПуть = СтрПуть + СтрЗаменить(Каталог,":","$");
			СтрПуть = ?(Прав(СтрПуть,1) = "\",СтрПуть,СтрПуть + "\");
			СтрПуть = СтрПуть + Формат(ТекущаяДата(),"ДФ=yyyyMMdd") + "\";
			ИмяфайлаПолучателя = СтрПуть + "Заказ_" + Номер + "_" + Наим + ".txt";
			Попытка
				КопироватьФайл(ИмяФайла,ИмяфайлаПолучателя);
			Исключение
				ЗаписьЖурналаРегистрации("Ошибка записи файла заказ",УровеньЖурналаРегистрации.Ошибка,ЭтотОбъект,,"Ошибка доступа до " + Профиль);
			КонецПопытки;
		Иначе
			Каталог = РегистрыСведений.ДополнительныеСвойства.ЗначениеСвойства(ПараметрыСеанса.ТекущаяИБ, "ПутьДляЛогирования");//Константы.ПутьДляЛогирования.Получить();
			Если Каталог = Неопределено Тогда
				Каталог = Константы.ПутьДляЛогирования.Получить();
			КонецЕсли;
			Профиль = РабочееМесто.ПрофильВхода;
			Поз = СтрНайти(Профиль,"\",НаправлениеПоиска.СКонца);
			Наим = Сред(Лев(Профиль,поз - 1),3);
			ИмяФайла = ?(Прав(Каталог,1) = "\",Каталог,Каталог + "\")+ Формат(ТекущаяДата(),"ДФ=yyyyMMdd") + "\" + "Заказ_" + Номер + "_" + Наим + ".txt";
			ЗаписатьОбъектВФайл(ИмяФайла,ЭтотОбъект);
		КонецЕсли;		
	КонецЕсли;
	#КонецЕсли
КонецПроцедуры

#Если ТонкийКлиент ИЛИ ТолстыйКлиентУправляемоеПриложение Тогда
	Функция ТекущаяДатаНаСервере() Экспорт
		Возврат ТекущаяДатаСеанса();
	КонецФункции
#КонецЕсли

Процедура ПриУстановкеНовогоНомера(СтандартнаяОбработка, Префикс)
	Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() и ЗначениеЗаполнено(ДополнительныеСвойства.ИмяКомпьютера) Тогда
		Профиль = ДополнительныеСвойства.ИмяКомпьютера;
		Поз = СтрНайти(Профиль,"-");
		Поз1 = СтрНайти(Профиль,"\");
		Префикс = Сред(Профиль,Поз + 1,Поз1 - 1);
	Иначе
		Префикс = "0000000000";
	КонецЕсли;
КонецПроцедуры

// Возвращаемое значение:
//		Структура
//			- Успех 		  - Булево
//			- КемЗаблокирован - Строка
//			- ОписаниеОшибки  - Строка
Функция ЗаблокироватьРедактированиеПоФирме(Фирма, УникальныйИдентификаторФормы = Неопределено) Экспорт
	УникальныйИдентификаторФормы = Ссылка.УникальныйИдентификатор();
	РазблокироватьРедактированиеПоФирме(Фирма);
	СтрОшибка = ""; Успех = Истина; КемЗаблокирован = "";
	КлючЗаписи = РегистрыСведений.БлокировкиЗаказов.СоздатьКлючЗаписи(Новый Структура("Заказ, Фирма",Ссылка,Фирма));
	Попытка
		Если УникальныйИдентификаторФормы = Неопределено Тогда
			ЗаблокироватьДанныеДляРедактирования(КлючЗаписи);
		Иначе
			ЗаблокироватьДанныеДляРедактирования(КлючЗаписи,,УникальныйИдентификаторФормы);
		КонецЕсли;
	Исключение
		Успех = Ложь;
		СтрОшибка = ОписаниеОшибки();
	КонецПопытки;
	
	// попробуем из описания ошибки вычленить имя пользователя и компа
	СтрКлюч = "компьютер: ";
	н = Найти( СтрОшибка, СтрКлюч );
	Если н <> 0 Тогда
		СтрОшибка = Сред( СтрОшибка, н+СтрДлина(СтрКлюч) );
		н = Найти( СтрОшибка, "," );
		ИмяКомпа = Лев(СтрОшибка, н-1);
		
		СтрКлюч = "пользователь: ";
		н = Найти( СтрОшибка, СтрКлюч );
		Если н <> 0 Тогда
			СтрОшибка = Сред( СтрОшибка, н+СтрДлина(СтрКлюч) );
			н = Найти( СтрОшибка, "," );
			ИмяПользователя = Лев(СтрОшибка, н-1);
			КемЗаблокирован = "\\"+ИмяКомпа+"\"+ИмяПользователя;
		КонецЕсли; 
	КонецЕсли;

	Возврат Новый Структура("Успех, КемЗаблокирован, ОписаниеОшибки", Успех, КемЗаблокирован, СтрОшибка);
	
КонецФункции

Процедура РазблокироватьРедактированиеПоФирме(Фирма, УникальныйИдентификаторФормы = Неопределено) Экспорт
	УникальныйИдентификаторФормы = Ссылка.УникальныйИдентификатор();
	КлючЗаписи = РегистрыСведений.БлокировкиЗаказов.СоздатьКлючЗаписи(Новый Структура("Заказ, Фирма",Ссылка,Фирма));
	Если УникальныйИдентификаторФормы = Неопределено Тогда
		РазблокироватьДанныеДляРедактирования(КлючЗаписи);
	Иначе
		РазблокироватьДанныеДляРедактирования(КлючЗаписи,УникальныйИдентификаторФормы);
	КонецЕсли;
	
КонецПроцедуры

// Возвращаемое значение - Булево
Функция ЗаблокированПоФирме(Фирма) Экспорт
	УникальныйИдентификаторФормы = Ссылка.УникальныйИдентификатор();
	РазблокироватьРедактированиеПоФирме(Фирма,УникальныйИдентификаторФормы);	
	РезультатБлокировки = ЗаблокироватьРедактированиеПоФирме(Фирма,УникальныйИдентификаторФормы);
	РазблокироватьРедактированиеПоФирме(Фирма,УникальныйИдентификаторФормы);	
	Возврат Не РезультатБлокировки.Успех;
КонецФункции

Функция ЗаписатьЗаказТоварыДопИнф() Экспорт
	Если МестоРеализации = Справочники.МестаРеализации.Ресторан Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если Не ТранзакцияАктивна() Тогда
		НачатьТранзакцию();
		фТранзакция = Истина
	Иначе
		фТранзакция = Ложь
	КонецЕсли;
	
	МенеджерЗаписи_Марки = РегистрыСведений.Марки.СоздатьМенеджерЗаписи();
	
	НЗ = РегистрыСведений.ЗаказТоварыДопИнф.СоздатьНаборЗаписей();
	НЗ.Отбор.Заказ.Установить(Ссылка);
	НЗ.Прочитать();
	ЗаказТоварыДопИнф = НЗ.Выгрузить();
	Для Каждого Т Из Товары Цикл
		СтрокаТЗ = ЗаказТоварыДопИнф.Найти(Т.ИдСтроки, "идСтроки");
		Если СтрокаТЗ = Неопределено Тогда
			ЗаписьРегистра = НЗ.Добавить();
			ЗаписьРегистра.Заказ = Ссылка;
			ЗаписьРегистра.ИдСтроки = Т.ИдСтроки;
			
			ЗаписьРегистра.РабочееМесто = ?(ЗначениеЗаполнено(Т.РабочееМесто), Т.РабочееМесто, РабочееМесто);	
			ЗаписьРегистра.Товар = Т.Товар;	
			ЗаписьРегистра.ВремяЗаказано = Т.ВремяДобавления;
			ЗаписьРегистра.Станция = ЗаписьРегистра.РабочееМесто.Станция;
			ЗаписьРегистра.АвторЗаказано = Т.Автор;
			ЗаписьРегистра.АвторГотово = Т.Автор;
			
		Иначе
			ЗаписьРегистра = НЗ.Получить(ЗаказТоварыДопИнф.Индекс(СтрокаТЗ));		
			
		КонецЕсли;
		ЗаписьРегистра.ВремяВыдано = ?(ЗначениеЗаполнено(Т.ДокументОплаты), Т.ДокументОплаты.Дата, Дата(1,1,1));
		ЗаписьРегистра.Количество = Т.Количество;
		ЗаписьРегистра.КоличествоУдалено = Т.КоличествоУдалено;		
		
		Если Т.Количество Тогда
			ЗаписьРегистра.Статус = Перечисления.СтатусыПозицийЗаказа.Выдано;
		Иначе
			//если удалили строку
			ЗаписьРегистра.Статус = Перечисления.СтатусыПозицийЗаказа.Удалено;
			
			////ПКА 20170828
			////проверим наличие марки, если НомерМарки указан - удалим марку
			//Если ЗначениеЗаполнено(ЗаписьРегистра.НомерМарки) тогда
			//
			//	МенеджерЗаписи_Марки.Заказ		= Ссылка;
			//	МенеджерЗаписи_Марки.НомерМарки	= ЗаписьРегистра.НомерМарки;

			//	МенеджерЗаписи_Марки.Прочитать();
			//	
			//	Если МенеджерЗаписи_Марки.Выбран() Тогда
			//		МенеджерЗаписи_Марки.Удалить();	
			//	КонецЕсли;	
			//
			//КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;	
	НЗ.Записать(Истина);	
	
	Если фТранзакция Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
КонецФункции;
