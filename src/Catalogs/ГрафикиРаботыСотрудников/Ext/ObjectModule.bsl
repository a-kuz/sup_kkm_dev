﻿Перем ТекущийГод Экспорт;

Перем мДлинаСуток Экспорт;
Перем ТЗГрафикНаГод Экспорт;

Перем БледноКрасныйЦвет Экспорт;
Перем СерыйЦвет;
Перем КрасныйЦвет;

// Функция формирует соответствие даты и вида дня за интервал
//
Функция ПолучитьДниВПроизводственномКалендаре(ДатаНачалаИнтервала, ДатаОкончанияИнтервала) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ДатаНачалаИнтервала", ДатаНачалаИнтервала);
	Запрос.УстановитьПараметр("ДатаОкончанияИнтервала", ДатаОкончанияИнтервала);
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	УР_ПроизводственныйКалендарь.ДатаКалендаря,
	|	УР_ПроизводственныйКалендарь.ВидДня
	|ИЗ
	|	РегистрСведений.УР_ПроизводственныйКалендарь КАК УР_ПроизводственныйКалендарь
	|ГДЕ
	|	УР_ПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &ДатаНачалаИнтервала И &ДатаОкончанияИнтервала";
	
	Выборка = Запрос.Выполнить().Выбрать();
	СоответствиеДней = Новый Соответствие;
	Пока Выборка.Следующий() Цикл
		СоответствиеДней.Вставить(Выборка.ДатаКалендаря,Выборка.ВидДня)
	КонецЦикла;
	
	Возврат СоответствиеДней;

КонецФункции

// Функция выбирает данные производственного календаря за месяц
//
Функция ДанныеПроизводственногоКалендаря(НомерМесяца) Экспорт
	
	ТекущийМесяц = НачалоМесяца(Дата(Год(ТекущийГод), НомерМесяца, 1));
	Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("НачалоМесяца",НачалоМесяца(ТекущийМесяц));
		Запрос.УстановитьПараметр("КонецМесяца",КонецМесяца(ТекущийМесяц));
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УР_ПроизводственныйКалендарь.ВидДня,
		|	ДЕНЬНЕДЕЛИ(УР_ПроизводственныйКалендарь.ДатаКалендаря) КАК ДеньНедели
		|ИЗ
		|	РегистрСведений.УР_ПроизводственныйКалендарь КАК УР_ПроизводственныйКалендарь
		|ГДЕ
		|	УР_ПроизводственныйКалендарь.ДатаКалендаря МЕЖДУ &НачалоМесяца И &КонецМесяца
		|
		|УПОРЯДОЧИТЬ ПО
		|	УР_ПроизводственныйКалендарь.ДатаКалендаря";
		
	Данные = Запрос.Выполнить().Выгрузить();
	Возврат Данные;

КонецФункции

//Функция вычисляет итоги рабочего времени за месяцы, кварталы и за год 
//по данным производственного календаря
Функция ДанныеПроизводственногоКалендаряЗаГод(Год)
		
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ГОД(УР_ПроизводственныйКалендарь.ДатаКалендаря) КАК ГодКалендаря,
	|	КВАРТАЛ(УР_ПроизводственныйКалендарь.ДатаКалендаря) КАК КварталКалендаря,
	|	МЕСЯЦ(УР_ПроизводственныйКалендарь.ДатаКалендаря) КАК МесяцКалендаря,
	|	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ УР_ПроизводственныйКалендарь.ДатаКалендаря) КАК КалендарныеДни,
	|	УР_ПроизводственныйКалендарь.ВидДня КАК ВидДня
	|ИЗ
	|	РегистрСведений.УР_ПроизводственныйКалендарь КАК УР_ПроизводственныйКалендарь
	|ГДЕ
	|	УР_ПроизводственныйКалендарь.Год = &Год
	|
	|СГРУППИРОВАТЬ ПО
	|	УР_ПроизводственныйКалендарь.ВидДня,
	|	ГОД(УР_ПроизводственныйКалендарь.ДатаКалендаря),
	|	КВАРТАЛ(УР_ПроизводственныйКалендарь.ДатаКалендаря),
	|	МЕСЯЦ(УР_ПроизводственныйКалендарь.ДатаКалендаря)
	|
	|УПОРЯДОЧИТЬ ПО
	|	КварталКалендаря,
	|	МесяцКалендаря
	|ИТОГИ ПО
	|	ГодКалендаря,
	|	КварталКалендаря,
	|	МесяцКалендаря";
	
	РабочееВремяГод = 0;
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Год", Год);
	Результат = Запрос.Выполнить();
	ВыборкаПоГоду = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

	ТаблицаИтогов = Новый ТаблицаЗначений;
	ТаблицаИтогов.Колонки.Добавить("НомерМесяца");
	ТаблицаИтогов.Колонки.Добавить("ДнейПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ЧасовПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ВыходныхПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ДнейЗаКварталПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ЧасовЗаКварталПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ВыходныхЗаКварталПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ДнейЗаГодПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ЧасовЗагодПоКалендарю");
	ТаблицаИтогов.Колонки.Добавить("ВыходныхЗагодПоКалендарю");
	
	Пока ВыборкаПоГоду.Следующий() Цикл
		ВыборкаПоКварталу = ВыборкаПоГоду.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
		Пока ВыборкаПоКварталу.Следующий() Цикл
			
			КалендарныеДниКв = 0;
			РабочееВремяКв = 0;
			РабочиеДниКв	 = 0;
			ВыходныеДниКв	 = 0;
			
			Если ВыборкаПоКварталу.КварталКалендаря = 1 тогда
				КалендарныеДниГод = 0;
				РабочееВремяГод = 0;
				РабочиеДниГод	 = 0;
				ВыходныеДниГод	 = 0;                                             
			КонецЕсли;
			
			ВыборкаПоМесяцу = ВыборкаПоКварталу.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			Пока ВыборкаПоМесяцу.Следующий() Цикл
				ВыходныеДни 	= 0;
				РабочееВремя 	= 0;
				КалендарныеДни 	= 0;
				РабочиеДни 		= 0;
				ВыборкаПоВидуДня = ВыборкаПоМесяцу.Выбрать(ОбходРезультатаЗапроса.Прямой);
				Пока ВыборкаПоВидуДня.Следующий() Цикл
					Если ВыборкаПоВидуДня.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Суббота Или 
						 ВыборкаПоВидуДня.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Воскресенье Или
						 ВыборкаПоВидуДня.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Праздник Тогда
						 ВыходныеДни = ВыходныеДни + ВыборкаПоВидуДня.КалендарныеДни
					 ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Рабочий Тогда
						 РабочееВремя = РабочееВремя + ВыборкаПоВидуДня.КалендарныеДни * 40/5;
						 РабочиеДни 	= РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
					 ИначеЕсли ВыборкаПоВидуДня.ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Предпраздничный Тогда
						 РабочееВремя = РабочееВремя + ВыборкаПоВидуДня.КалендарныеДни * 40/5 - 1;
						 РабочиеДни 	= РабочиеДни + ВыборкаПоВидуДня.КалендарныеДни;
					 КонецЕсли;
					 КалендарныеДни = КалендарныеДни + ВыборкаПоВидуДня.КалендарныеДни;
				КонецЦикла; // вид дня
				КалендарныеДниКв = КалендарныеДниКв + КалендарныеДни;
				РабочееВремяКв = РабочееВремяКв + РабочееВремя;
				РабочиеДниКв	 = РабочиеДниКв 	+ РабочиеДни;
				ВыходныеДниКв	 = ВыходныеДниКв	+ ВыходныеДни;
				
				КалендарныеДниГод = КалендарныеДниГод + КалендарныеДни;
				РабочееВремяГод = РабочееВремяГод + РабочееВремя;
				РабочиеДниГод	 = РабочиеДниГод 	+ РабочиеДни;
				ВыходныеДниГод	 = ВыходныеДниГод	+ ВыходныеДни;
				
				НоваяСтрока = ТаблицаИтогов.Добавить();
				НоваяСтрока.НомерМесяца 	= ВыборкаПоМесяцу.МесяцКалендаря;
				НоваяСтрока.ДнейПоКалендарю = РабочиеДни;
				НоваяСтрока.ЧасовПоКалендарю = РабочееВремя;
				НоваяСтрока.ВыходныхПоКалендарю = ВыходныеДни;
				
			КонецЦикла; // месяц
			НоваяСтрока.ДнейЗаКварталПоКалендарю = РабочиеДниКв;
			НоваяСтрока.ЧасовЗаКварталПоКалендарю = РабочееВремяКв;
			НоваяСтрока.ВыходныхЗаКварталПоКалендарю = ВыходныеДниКв; 
			
		КонецЦикла;  // квартал
		НоваяСтрока.ДнейЗаГодПоКалендарю = РабочиеДниГод;
		НоваяСтрока.ЧасовЗаГодПоКалендарю = РабочееВремяГод;
		НоваяСтрока.ВыходныхЗаГодПоКалендарю = ВыходныеДниГод; 

	КонецЦикла; // год
	
	Возврат ТаблицаИтогов;
	
КонецФункции

// Функция вычисляет количество дней в месяце
//
Функция КоличествоДнейВМесяце(Месяц, Год) Экспорт
	ДатаМесяца = Дата(Год, Месяц, 1);
	ДнейВМесяце = День(КонецМесяца(ДатаМесяца));
	Возврат ДнейВМесяце;
КонецФункции

#Если ТолстыйКлиентОбычноеПриложение Тогда

// Функция выполняет печать графика работ на год 	
Функция Печать(ТЗГрафикНаГод) Экспорт
		
	ВыводитьИтогиПроизводственногоКалендаря = Истина;
	
	ДатаНачалаИнтервала    	= НачалоГода(ТекущийГод);
	ДатаОкончанияИнтервала  = КонецГода(ТекущийГод);
	ДнейВИнтервале = (КонецДня(ДатаОкончанияИнтервала) - НачалоДня(ДатаНачалаИнтервала) + 1) / мДлинаСуток;
	Календарь = ПолучитьДниВПроизводственномКалендаре(ДатаНачалаИнтервала, ДатаОкончанияИнтервала); // это соответствие: дата - вид дня
	
	Если ДнейВИнтервале <> Календарь.Количество() Тогда
		Сообщить("Проверьте правильность заполнения производственного календаря на " + Формат(Год(ТекущийГод), "ЧГ=5") + " год", СтатусСообщения.Важное);
		ВыводитьИтогиПроизводственногоКалендаря = Ложь;
	КонецЕсли;
	
	ПечатныйДокумент = Новый ТабличныйДокумент;
	ПечатныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ГрафикиРаботы";
	ПечатныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ПечатныйДокумент.Автомасштаб = Истина;

	Макет = ПолучитьМакет("Макет");

	ОбластьДанныхШапка 	          = Макет.ПолучитьОбласть("Шапка|Месяцы");
	ОбластьДанныхКолонтитул       = Макет.ПолучитьОбласть("Колонтитул");
	ОбластьДанныхРасширение       = Макет.ПолучитьОбласть("Расширение");
	ОбластьДанныхДень             = Макет.ПолучитьОбласть("День|Месяцы");
	ОбластьДанныхДеньПоДням       = Макет.ПолучитьОбласть("День|Дни");
	ОбластьИтогиЗаМесяц           = Макет.ПолучитьОбласть("День|Итоги");
	ОбластьИтогиЗаКвартал         = Макет.ПолучитьОбласть("Квартал");
	ОбластьИтогиЗаГод			  = Макет.ПолучитьОбласть("Год");
	ОбластьКалендаря			  = Макет.ПолучитьОбласть("Календарь");	
	ОбластьПодписи				  = Макет.ПолучитьОбласть("Подпись");
	ОбластьРасширениеИтоги		  = Макет.ПолучитьОбласть("РасширениеИтоги");
	
	ОбластьДанныхШапка.Параметры.Наименование = "График работы '" + СокрЛП(ЭтотОбъект.Наименование) 
		+ "' на " + Формат(Год(ТекущийГод), "ЧГ=5") + " год" ;
    ПечатныйДокумент.Вывести(ОбластьДанныхШапка);
	ОбластьДнейЗаголовок = "Часов за день";
	ОбластьДанныхКолонтитул.Параметры.Установить(0, ОбластьДнейЗаголовок);
	ПечатныйДокумент.Вывести(ОбластьДанныхКолонтитул);
	
	ДнейЗаКвартал 						= 0;
	ЧасовЗаКвартал 						= 0;
	ДнейЗаГод 							= 0;
	ЧасовЗагод 							= 0;
	ДнейПоКалендарю						= 0;
	ЧасовПоКалендарю					= 0;
	ВыходныхПоКалендарю					= 0;
	ДнейЗаКварталПоКалендарю			= 0;
	ЧасовЗаКварталПоКалендарю			= 0;
	ВыходныхЗаКварталПоКалендарю		= 0;
	ДнейЗаГодПоКалендарю				= 0;
	ЧасовЗаГодПоКалендарю               = 0;
	ВыходныхЗаГодПоКалендарю			= 0;
	Квартал  							= 0;
	ИндексСтраницы						= 0;
	
	Для Индекс = 0 По 11 Цикл
		
		НомерМесяца = Индекс + 1;
		НазваниеМесяца = ТЗГрафикНаГод[Индекс].Месяц;
		Дней           = ТЗГрафикНаГод[Индекс].ДнейЗаМесяц;
		Часов          = ТЗГрафикНаГод[Индекс].ЧасовЗаМесяц;
		
		Если НомерМесяца = 4 ИЛИ НомерМесяца = 7 ИЛИ НомерМесяца = 10 Тогда
			ДнейЗаКвартал  = 0;
			ЧасовЗаквартал = 0;
		КонецЕсли;
		
		ДнейЗаКвартал  = ДнейЗаКвартал + Дней;
		ЧасовЗаКвартал = ЧасовЗаКвартал + Часов;
		ДнейЗаГод = ДнейЗаГод + Дней;
		ЧасовЗаГод = ЧасовЗаГод + Часов;
		
		ДанныеМесяца = ТЗГрафикНаГод[Индекс];
		ОбластьДанныхДень.Параметры.Заполнить(ДанныеМесяца); 
		
		СтрокаСПодвалом = Новый Массив; // создадим массив для проверки вывода 
		СтрокаСПодвалом.Добавить(ОбластьДанныхДень); 
		СтрокаСПодвалом.Добавить(ОбластьИтогиЗаКвартал);
		
		Если Не ПечатныйДокумент.ПроверитьВывод(СтрокаСПодвалом) Тогда
			ПечатныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ПечатныйДокумент.Вывести(ОбластьДанныхКолонтитул);
			ИндексСтраницы=ИндексСтраницы+1;
		КонецЕсли;
		
		ПечатныйДокумент.Вывести(ОбластьДанныхДень);
		
		ОбластьДанныхДеньПоДням.Параметры.Заполнить(ДанныеМесяца);
		ОбластьИтогиЗаМесяц.Параметры.Заполнить(ДанныеМесяца);
		
		ДнейВМесяце = КоличествоДнейВМесяце(НомерМесяца, Год(ТекущийГод)); 
		Если ДнейВМесяце < 31 Тогда
			ЛишнийДень = ДнейВМесяце + 1;
			Пока ЛишнийДень <= 31 Цикл
				ОбластьДанныхДеньПоДням.Параметры.Установить(ЛишнийДень-1, "X");
				ЛишнийДень = ЛишнийДень + 1;
			КонецЦикла;
		КонецЕсли;
		
		//Установим параметры производственного календаря
		ДанныеПроизводственногоКалендаря = ДанныеПроизводственногоКалендаря(НомерМесяца);
		ТаблицаИтоговКалендаря = ДанныеПроизводственногоКалендаряЗаГод(Год(ТекущийГод));
			
		Если ВыводитьИтогиПроизводственногоКалендаря Тогда
			ТаблицаИтогов = ТаблицаИтоговКалендаря[Индекс];
			ОбластьИтогиЗаМесяц.Параметры.Установить(2, ТаблицаИтоговКалендаря[Индекс].ДнейПоКалендарю);
			ОбластьИтогиЗаМесяц.Параметры.Установить(3, ТаблицаИтоговКалендаря[Индекс].ЧасовПоКалендарю);
			ОбластьИтогиЗаМесяц.Параметры.Установить(4, ТаблицаИтоговКалендаря[Индекс].ВыходныхПоКалендарю);
		КонецЕсли;
		
		ПечатныйДокумент.Присоединить(ОбластьДанныхДеньПоДням);
		ПечатныйДокумент.Присоединить(ОбластьИтогиЗаМесяц);
		ПечатныйДокумент.Вывести(ОбластьДанныхРасширение);
				
		//Выделим цветом нерабочие дни в календаре
		ТекущийМесяц = НачалоМесяца(Дата(Год(ТекущийГод), НомерМесяца, 1));
		ДеньНеделиМесяца = ДеньНедели(НачалоМесяца(ТекущийМесяц));
		Для НомерДня = 1 По 31 Цикл
			Если НомерДня <= ДнейВМесяце Тогда
				Если ДанныеПроизводственногоКалендаря.Количество() > 0 Тогда
					ВидДня = ДанныеПроизводственногоКалендаря[НомерДня - 1].ВидДня;
					Если ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Воскресенье 
						Или ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Суббота 
						Или ВидДня = Перечисления.УР_ВидыДнейПроизводственногоКалендаря.Праздник Тогда
						ОбластьВыходных = ПечатныйДокумент.НайтиТекст(Строка(НомерДня),,,,Истина);
						//Если (Не УчитыватьВечерниеЧасы И Не УчитыватьНочныеЧасы)
						//	Или (УчитыватьВечерниеЧасы И Не УчитыватьНочныеЧасы)
						//	Или (Не УчитыватьВечерниеЧасы И УчитыватьНочныеЧасы)Тогда
							ОбластьДляЗакрашивания = ПечатныйДокумент.Область(ОбластьВыходных.Верх + НомерМесяца*2 + Квартал*2- 1, ОбластьВыходных.Лево, ОбластьВыходных.Верх + НомерМесяца*2  + Квартал*2, ОбластьВыходных.Лево);
						//Иначе
						//	ОбластьДляЗакрашивания = ПечатныйДокумент.Область(ОбластьВыходных.Верх + НомерМесяца*3+ ИндексСтраницы*3 + Квартал*3 - 2, ОбластьВыходных.Лево, ОбластьВыходных.Верх + НомерМесяца*3+ ИндексСтраницы*3 + Квартал*3, ОбластьВыходных.Лево);
						//КонецЕсли;
						ОбластьДляЗакрашивания.ЦветФона = КрасныйЦвет;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ОбластьЛишнихДней = ПечатныйДокумент.НайтиТекст(Строка(НомерДня),,,,Истина);
				//Если (Не УчитыватьВечерниеЧасы И Не УчитыватьНочныеЧасы)
				//	Или (УчитыватьВечерниеЧасы И Не УчитыватьНочныеЧасы)
				//	Или (Не УчитыватьВечерниеЧасы И УчитыватьНочныеЧасы)Тогда
					ОбластьДляЗакрашивания = ПечатныйДокумент.Область(ОбластьЛишнихДней.Верх + НомерМесяца*2 + Квартал*2 - 1, ОбластьЛишнихДней.Лево, ОбластьЛишнихДней.Верх + НомерМесяца*2 + Квартал*2, ОбластьЛишнихДней.Лево);
				//Иначе
				//	ОбластьДляЗакрашивания = ПечатныйДокумент.Область(ОбластьЛишнихДней.Верх + НомерМесяца*3+ ИндексСтраницы*3 + Квартал*3 - 2, ОбластьЛишнихДней.Лево, ОбластьЛишнихДней.Верх + НомерМесяца*3+ ИндексСтраницы*3 + Квартал*3, ОбластьЛишнихДней.Лево);
				//КонецЕсли;
				ОбластьДляЗакрашивания.ЦветФона = СерыйЦвет;
			КонецЕсли;
		КонецЦикла;
		
		Если НомерМесяца = 3 ИЛИ НомерМесяца = 6 ИЛИ НомерМесяца = 9 ИЛИ НомерМесяца = 12 Тогда
			Квартал = НомерМесяца/3;
			ОбластьИтогиЗаКвартал.Параметры.Установить(0, "" + Квартал + " квартал");
			ОбластьИтогиЗаКвартал.Параметры.Установить(1, ДнейЗаКвартал);
			ОбластьИтогиЗаКвартал.Параметры.Установить(2, ЧасовЗаКвартал);
			Если ВыводитьИтогиПроизводственногоКалендаря Тогда
				ОбластьИтогиЗаКвартал.Параметры.Установить(3, ТаблицаИтоговКалендаря[НомерМесяца-1].ДнейЗаКварталПоКалендарю);
				ОбластьИтогиЗаКвартал.Параметры.Установить(4, ТаблицаИтоговКалендаря[НомерМесяца-1].ЧасовЗаКварталПоКалендарю);
				ОбластьИтогиЗаКвартал.Параметры.Установить(5, ТаблицаИтоговКалендаря[НомерМесяца-1].ВыходныхЗаКварталПоКалендарю); 
			КонецЕсли;
			
			ПечатныйДокумент.Вывести(ОбластьИтогиЗаКвартал);
			
			ПечатныйДокумент.Вывести(ОбластьРасширениеИтоги);
		КонецЕсли;
		
	КонецЦикла;

	ОбластьИтогиЗаГод.Параметры.Установить(0, ДнейЗаГод);
	ОбластьИтогиЗаГод.Параметры.Установить(1, ЧасовЗаГод);
	Если ВыводитьИтогиПроизводственногоКалендаря Тогда
		ОбластьИтогиЗаГод.Параметры.Установить(2, ТаблицаИтоговКалендаря[11].ДнейЗаГодПоКалендарю);
		ОбластьИтогиЗаГод.Параметры.Установить(3, ТаблицаИтоговКалендаря[11].ЧасовЗаГодПоКалендарю);
		ОбластьИтогиЗаГод.Параметры.Установить(4, ТаблицаИтоговКалендаря[11].ВыходныхЗаГодПоКалендарю);
	КонецЕсли;
	
	ПечатныйДокумент.Вывести(ОбластьИтогиЗаГод);
	
	ПечатныйДокумент.Вывести(ОбластьРасширениеИтоги);
	ОбластьИтоговЗаГод = ПечатныйДокумент.НайтиТекст("Итого за год:");
	СераяОбласть = ПечатныйДокумент.Область(ОбластьИтоговЗаГод.Верх + 1, ОбластьИтоговЗаГод.Лево, ОбластьИтоговЗаГод.Верх + 1, ОбластьИтоговЗаГод.Лево + 37);
	СераяОбласть.ЦветФона = ЦветаСтиля.ЦветФонаФормы;

	ПечатныйДокумент.Вывести(ОбластьПодписи);

	ИнтерфейсАдмина.НапечататьДокумент(ПечатныйДокумент, , , "График работы " + Наименование);
	
КонецФункции

#КонецЕсли

// Обработчик события "ПередЗаписью" элемента справочника.
//
Процедура ПередЗаписью(Отказ)
	
	Если НЕ ОбменДанными.Загрузка Тогда
		
		Заголовок = "Запись справочника: " + Ссылка;
	
		Если НЕ ЗначениеЗаполнено(Код) Тогда
			СообщитьОбОшибке("Не заполнен код.", Отказ, Заголовок);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(Наименование) Тогда
			СообщитьОбОшибке("Не заполнено наименование графика работы.", Отказ, Заголовок);
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ТипГрафика) Тогда
			СообщитьОбОшибке("Не заполнен тип графика работы.", Отказ, Заголовок);
		КонецЕсли;
		
		Если График.Количество() = 0 Тогда
			СообщитьОбОшибке("Не заполнена табличная часть ""Шаблон графика работы"".", Отказ, Заголовок);
			Возврат;
		КонецЕсли; 
		
		Для каждого СтрокаТЧ Из График Цикл
			Если НЕ ЗначениеЗаполнено(СтрокаТЧ.Смена) Тогда
				ТекстСообщения = "В строке " + СтрокаТЧ.НомерСтроки + " не заполнен реквизит ""Смена""";
				СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
			КонецЕсли;
		КонецЦикла;
		
		// Проверим длительность у рабочих дней
		НайденныеСтроки = График.НайтиСтроки(Новый Структура("Длительность", 0));
		Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
			Если НайденнаяСтрока.Смена.ВидВремени = Справочники.УР_ВидыИспользованияРабочегоВремени.Явка Тогда
				СообщитьОбОшибке("В строке № " + (График.Индекс(НайденнаяСтрока)+1) + " не указана длительность.", Отказ, Заголовок);
			КонецЕсли;
		КонецЦикла;
		
		// Проверка корректности заполнения шаблона графика
		Если ТипГрафика = Перечисления.ТипыГрафиковРаботы.Сменный Тогда
			
			ТаблицаГрафика = График.Выгрузить();
			ТаблицаГрафика.Колонки.Добавить("ДатаВремяНачала");
			ТаблицаГрафика.Колонки.Добавить("ДатаВремяОкончания");
			
			// Дублируем первую строку для проверки её связи с последней
			ЗаполнитьЗначенияСвойств(ТаблицаГрафика.Добавить(), ТаблицаГрафика[0]);
			
			ТаблицаГрафика.ЗагрузитьКолонку(ТаблицаГрафика.ВыгрузитьКолонку("ВремяНачала"), "ДатаВремяНачала");
			ТаблицаГрафика.ЗагрузитьКолонку(ТаблицаГрафика.ВыгрузитьКолонку("ВремяОкончания"), "ДатаВремяОкончания");
			
			Для Каждого СтрокаГрафика Из ТаблицаГрафика Цикл
				
				СтрокаГрафика.ДатаВремяНачала = СтрокаГрафика.ВремяНачала + ТаблицаГрафика.Индекс(СтрокаГрафика) * мДлинаСуток;
				СтрокаГрафика.ДатаВремяОкончания = СтрокаГрафика.ВремяОкончания + (ТаблицаГрафика.Индекс(СтрокаГрафика) + ?(СтрокаГрафика.ВремяОкончания >= СтрокаГрафика.ВремяНачала, 0, 1)) * мДлинаСуток ;
				
			КонецЦикла;
			
			// Проверка пересечения диапазонов
			Для ИндексТекСтроки = 0 По ТаблицаГрафика.Количество() - 2 Цикл
				
				ТекСтрока = ТаблицаГрафика.Получить(ИндексТекСтроки);
				
				Если НЕ ЗначениеЗаполнено(ТекСтрока.Смена) Тогда
					СообщитьОбОшибке("В строке № " + (ИндексТекСтроки+1) + " не заполнена смена.", Отказ, Заголовок);
				КонецЕсли;
				
				Если ТекСтрока.ДатаВремяНачала > ТекСтрока.ДатаВремяОкончания Тогда
					СообщитьОбОшибке("В строке № " + (ИндексТекСтроки+1) + " неверно указан диапазон.", Отказ, Заголовок);
				КонецЕсли;
				
				СледСтрока = ТаблицаГрафика.Получить(ИндексТекСтроки + 1);
				
				Если СледСтрока.Выходной Тогда
					Продолжить;
				КонецЕсли;
				
				Если ТекСтрока.ДатаВремяОкончания > СледСтрока.ДатаВремяНачала Тогда
					СообщитьОбОшибке("В строке № " + (ТекСтрока.НомерСтроки) + " время окончания больше времени начала в строке № " + СледСтрока.НомерСтроки, Отказ, Заголовок);
				КонецЕсли;
				
			КонецЦикла;
					
		Иначе
			
			НайденныеСтроки = График.НайтиСтроки(Новый Структура("ДеньНедели", Перечисления.ДниНедели.ПустаяСсылка()));
			
			Для каждого НайденнаяСтрока Из НайденныеСтроки Цикл
				СообщитьОбОшибке("В строке № " + (График.Индекс(НайденнаяСтрока)+1) + " не указан день недели.", Отказ, Заголовок);
			КонецЦикла;
			
		КонецЕсли;

	КонецЕсли;
	
КонецПроцедуры

мДлинаСуток = 86400; // в секундах

ТЗГрафикНаГод    = Новый ТаблицаЗначений; 
ТЗГрафикНаГод.Колонки.Добавить("Дата", Новый ОписаниеТипов("Дата"));
ТЗГрафикНаГод.Колонки.Добавить("Часы", Новый ОписаниеТипов("Число"));
ТЗГрафикНаГод.Колонки.Добавить("ВремяНачала", Новый ОписаниеТипов("Дата"));
ТЗГрафикНаГод.Колонки.Добавить("ВремяОкончания", Новый ОписаниеТипов("Дата"));
ТЗГрафикНаГод.Индексы.Добавить("Дата");

БледноКрасныйЦвет = Новый Цвет(255, 235, 235);
КрасныйЦвет = Новый Цвет(255, 220, 205);
СерыйЦвет = Новый Цвет(205, 205, 205);
