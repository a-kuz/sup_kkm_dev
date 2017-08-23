﻿#Если Клиент Тогда
	Перем ВидНастройки Экспорт;                        // Вид настройки
	Перем ИнформацияРасшифровки Экспорт;               // информация расшифроки отчета.
	Перем ЗапросИсх Экспорт;                           // исходный запрос
	Перем Задание;
	Перем ШиринаКолонок;
	Перем ЗаголовокНастройка;
	Перем НастройкиОтчетаНаМоментФормирования Экспорт; // настройка при формировании отчета.
	
// Обязательная процедура для работы с обработкой через ИнтерфейсРМ.ПолучитьОбъектОбработки()
// Вызывается каждый раз при обращении к объекту обработки.
// Здесь надо прописать сброс переменных в начальные значения
// Реквизиты и табличные части уже сброшены
	Процедура УстановкаНачальныхЗначений() Экспорт
		
	КонецПроцедуры

	
	// Устанавливает параметры
	//
	Процедура УстановитьПараметры()
		
		Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаС");
		Параметр.Значение = ДатаС;
		Параметр.Использование = Истина;
		
		Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ДатаПо");
		Параметр.Значение = ДатаПо;
		Параметр.Использование = Истина;
		
		Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("МассивСмен");
		Параметр.Значение = МассивСмен;
		Параметр.Использование = Истина;
		
		Параметр = КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы.Найти("ПараметрДата");
		
		Параметр.Использование = Истина;
		Если МассивСмен = Неопределено Тогда
			Параметр.Значение = Истина;	
		Иначе
			Параметр.Значение = Ложь;	
		КонецЕсли;	
		
	КонецПроцедуры
	
	// Выводит отчет в табличный документ.
	//
	// Параметры:
	//  ТабличныйДокумент - табличный документ, в который выводится отчет.
	//
	Процедура СформироватьОтчет(ТабличныйДокумент = "", НаПринтер = Ложь, ВарФормирования = 0, ЭлементыФормы = "") Экспорт
		
		Если НаПринтер Тогда
			
			Смена = ИнтерфейсРМ.ТекущаяСмена();
			
			Если НЕ ЗначениеЗаполнено(Смена) Тогда
				Текст1="Смена не открыта!";
				Текст2="Для формирования отчета нет данных...";
				ИнтерфейсРМ.ВопросПредупреждение("Предупреждение",Текст1,Текст2,"","ОК","");
				Возврат;
			КонецЕсли;
			
			ВариантФормирования = ВарФормирования;
			
			ПечататьНаПринтере(Смена);
			Возврат;
		КонецЕсли;	
		
		Если НЕ КраткийВидНастройки Тогда
			ЗаголовокНастройка = СтрПолучитьСтроку(КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение,1);
			КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение = ЗаголовокНастройка;
			
			УстановитьПараметры();	
			ФормированиеОтчетов.отчСформироватьОтчет(ЭтотОбъект, ТабличныйДокумент,,,ЭлементыФормы);
			КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение 	= ЗаголовокНастройка;
			
			НастройкиОтчетаНаМоментФормирования = ПолучитьТекущиеНастройки();
			
			Возврат;
		КонецЕсли;
		
		КомпоновщикНастроек.Настройки.Структура.Очистить();
		
		Если ПоказыватьДиаграмму И ПараметрВыводаДиаграммы = 0 Тогда
			СформироватьДиаграмму();
		КонецЕсли;
		
		Заголовок = "ОТЧЕТ ПО ВОЗВРАТАМ" + Символы.ПС + Период;
		
		КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение = Заголовок;
		
		// добавим поле группировки
		ГруппировкаРодитель = КомпоновщикНастроек.Настройки;
		
		Если ГруппироватьПоПериоду Тогда
			ГруппировкаПоПериоду = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			
			ПолеГруппировки                = ГруппировкаПоПериоду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных(ВидПериода);
			// Добавим колонку дня недели рядом с датой
			Если ВидПериода = "День" Тогда
				
				ПолеГруппировки                = ГруппировкаПоПериоду.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
				ПолеГруппировки.Использование  = Истина;
				ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ДниНедели");
				
			КонецЕсли;
			
			НовоеВыбранноеПоле = ГруппировкаПоПериоду.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			
			ГруппировкаРодитель = ГруппировкаПоПериоду;	 
		КонецЕсли;
				       
		ГруппировкаОтчета1 = ГруппировкаРодитель.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных")); 

		ПолеГруппировки                = ГруппировкаОтчета1.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		Если ПоДокументам Тогда			
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Товар");
		Иначе
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Номер");
		КонецЕсли;
		НовоеВыбранноеПоле = ГруппировкаОтчета1.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных")); 
		
		///
		ГруппировкаОтчета2 = ГруппировкаОтчета1.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных")); 

		ПолеГруппировки                = ГруппировкаОтчета2.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
					
		Если ПоДокументам Тогда			
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Номер");
		Иначе
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Товар");
		КонецЕсли;
        		
		НовоеВыбранноеПоле = ГруппировкаОтчета2.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));

		 		
		ИмяПоляКомпоновкиДанныхПериод = Новый ПолеКомпоновкиДанных("Период");
		ИмяПоляКомпоновкиДанныхСмена = Новый ПолеКомпоновкиДанных("Смена");
		
		УстановитьПараметры();
		
		Если ПоказыватьДиаграмму И ПараметрВыводаДиаграммы = 1 Тогда
			СформироватьДиаграмму();
		КонецЕсли;
		
		ФормированиеОтчетов.отчСформироватьОтчет(ЭтотОбъект, ТабличныйДокумент,,,ЭлементыФормы);
		
		МассивНаУдаление = Новый Массив;
		Для Каждого ЭлементОтбора Из КомпоновщикНастроек.Настройки.Отбор.Элементы Цикл
			Если ЭлементОтбора.ЛевоеЗначение =ИмяПоляКомпоновкиДанныхПериод ИЛИ  
				ЭлементОтбора.ЛевоеЗначение =ИмяПоляКомпоновкиДанныхСмена Тогда
				
				МассивНаУдаление.Добавить(ЭлементОтбора);
			КонецЕсли;
		КонецЦикла;
		
		Для Каждого Элемент Из МассивНаУдаление Цикл
			КомпоновщикНастроек.Настройки.Отбор.Элементы.Удалить(Элемент);
		КонецЦикла;	
		
		НастройкиОтчетаНаМоментФормирования = ПолучитьТекущиеНастройки();
	КонецПроцедуры
	
	// Формирует диаграмму.
	//
	Процедура СформироватьДиаграмму() Экспорт
		Диаграмма = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ДиаграммаКомпоновкиДанных"));
		ВыбранноеПоле = Диаграмма.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле.Использование = Истина;
		ВыбранноеПоле.Заголовок = "Сумма";
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("Сумма");
		
		Серия = Диаграмма.Серии.Добавить();
		Серия.Использование = Истина;
		Поле = Серия.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		Поле.Поле = Новый ПолеКомпоновкиДанных(?(ГруппироватьПоПериоду,ВидПериода, "ПосадочноеМесто" ));
		Поле.Использование = Истина;
		Поле.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		
		НовоеВыбранноеПоле = Серия.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		
		Параметр = Диаграмма.ПараметрыВывода.Элементы.Найти("ТипДиаграммы");
		Параметр.Значение = ТипДиаграммы;
		Параметр.Использование = Истина;
		
		Параметр2 = Диаграмма.ПараметрыВывода.Элементы.Найти("TitleOutput");
		Параметр2.Значение = ТипВыводаТекстаКомпоновкиДанных.Выводить;
		Параметр2.Использование = Ложь;
		
		Параметр4 = Параметр.ЗначенияВложенныхПараметров.Найти("ТипДиаграммы.РасположениеЛегенды");
		Параметр4.Значение = РасположениеЛегендыДиаграммыКомпоновкиДанных.Низ;
		Параметр4.Использование = Истина;
		
	КонецПроцедуры	
	
	// Получает текущие настройки.
	//
	// Параметры:
	//	ИсключитьДату - флаг исключения даты.
	//
	// Возвращаемое значение:
	//	Структура настроек.
	//
	Функция ПолучитьТекущиеНастройки(ИсключитьДату = Ложь) Экспорт
		
		СтруктураНастроек = Новый Структура;
		
		СтруктураНастроек.Вставить("КраткийВидНастройки"       , КраткийВидНастройки);
		СтруктураНастроек.Вставить("НастройкиКомпоновкиДанных" , КомпоновщикНастроек.ПолучитьНастройки());
		
		Возврат СтруктураНастроек;
		
	КонецФункции
	
	// Загружает настройки.
	//
	// Параметры:
	//	Настройки - структура настроек.
	//
	Процедура ЗагрузитьНастройки(Настройки) Экспорт
		
		КраткийВидНастройки  = Настройки.КраткийВидНастройки;
		КомпоновщикНастроек.ЗагрузитьНастройки(Настройки.НастройкиКомпоновкиДанных);
		
	КонецПроцедуры
	
	// Печать отчета из Рабочего места.
	//
	Процедура ПечататьНаПринтере(Смена) 
		
		МестоРеализации = глПараметрыРМ.МестоРеализации;
		
		ТекстЗапроса = "ВЫБРАТЬ
		|	Возврат.Сумма,
		|	Возврат.МестоРеализации,
		|	Возврат.Заказ.ПосадочноеМесто КАК ПосадочноеМесто,
		|	Возврат.Автор,
		|	Возврат.Смена,
		|	Возврат.Дата КАК Период,
		|	ДЕНЬ(Возврат.Дата) КАК День,
		|	НЕДЕЛЯ(Возврат.Дата) КАК Неделя,
		|	МЕСЯЦ(Возврат.Дата) КАК Месяц,
		|	КВАРТАЛ(Возврат.Дата) КАК Квартал,
		|	ГОД(Возврат.Дата) КАК Год,
		|	Возврат.Номер,
		|	Возврат.Ссылка КАК Возврат
		|ИЗ
		|	Документ.Возврат КАК Возврат
		|ГДЕ
		|	Возврат.ПометкаУдаления = ЛОЖЬ
		|	И Возврат.Дата МЕЖДУ &ДатаС И &ДатаПо
		|	И Возврат.МестоРеализации = &МестоРеализации";
		
		
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.УстановитьПараметр("МестоРеализации", МестоРеализации);
		Запрос.УстановитьПараметр("ДатаС", Смена.Дата);
		Запрос.УстановитьПараметр("ДатаПо", ТекущаяДата());
		Запрос.УстановитьПараметр("ПустаяСсылка", Справочники.ВариантыОплаты.ПустаяСсылка());
		РезультатЗапроса = Запрос.Выполнить();
		
		Заголовок1 = "ОТЧЕТ ПО ВОЗВРАТАМ";
		Заголовок2 = "";
		Шапка = "";
		
		ДлинаСтроки = ИнтерфейсРМ.ПРНДлинаСтроки(глПараметрыРМ.ПечатьОтчетовПринтер);
		ШиринаКолонок = Новый СписокЗначений;
		Если ДлинаСтроки=32 Тогда
			ШиринаКолонок.Добавить(20);
			ШиринаКолонок.Добавить(12);
		ИначеЕсли ДлинаСтроки=36 Тогда
			ШиринаКолонок.Добавить(24);
			ШиринаКолонок.Добавить(12);
		ИначеЕсли ДлинаСтроки=40 Тогда
			ШиринаКолонок.Добавить(28);
			ШиринаКолонок.Добавить(12);
		ИначеЕсли ДлинаСтроки=42 Тогда
			ШиринаКолонок.Добавить(30);
			ШиринаКолонок.Добавить(12);
		ИначеЕсли ДлинаСтроки=44 Тогда
			ШиринаКолонок.Добавить(32);
			ШиринаКолонок.Добавить(12);
		Иначе //Если ДлинаСтроки=48 Тогда
			ШиринаКолонок.Добавить(36);
			ШиринаКолонок.Добавить(12);
		КонецЕсли;
		
		Задание = Новый ТаблицаЗначений;
		Задание.Колонки.Добавить("Данные");
		Задание.Колонки.Добавить("ТипДанных");
		Задание.Колонки.Добавить("Параметры");
		
		Выгрузка = РезультатЗапроса.Выгрузить();
		
		Для Каждого Строка Из Выгрузка Цикл
			СформироватьСтроку(Строка.Номер + " " + Формат(Строка.Период,"ДФ=dd.MM.yy") ,Строка.Сумма, Ложь);                     
		КонецЦикла;	
		
		// итоговая сумма   
		НоваяСтрока = Задание.Добавить(); 
		НоваяСтрока.Данные    = "СтрЧерта";
		НоваяСтрока.ТипДанных = "Строка";
		НоваяСтрока.Параметры = "Центр,ПереводСтроки";
		
		СформироватьСтроку("", Выгрузка.Итог("Сумма"),	Истина);
		
		ФормированиеОтчетов.ПечатьОтчетаРМ(Задание, Заголовок1, Заголовок2, Шапка);
		
	КонецПроцедуры
	
	// Формирование строки отчета на принтер.
	//
	Процедура СформироватьСтроку(Стр, Сумма, Выделение)
		
		Выделение=?(Выделение,"Жирный","НеЖирный");
		
		НоваяСтрока = Задание.Добавить();
		НоваяСтрока.Данные    = СтрДополнитьСправа(Стр, ШиринаКолонок[0].Значение);
		НоваяСтрока.ТипДанных = "Строка";
		НоваяСтрока.Параметры = Выделение+",НеПереводСтроки";
		
		НоваяСтрока = Задание.Добавить();
		НоваяСтрока.Данные    = СтрДополнитьСлева(Формат(Сумма,"ЧЦ="+ШиринаКолонок[1].Значение +"; ЧДЦ=2; ЧН=0,00"), ШиринаКолонок[1].Значение);
		НоваяСтрока.ТипДанных = "Строка";
		НоваяСтрока.Параметры = Выделение+",ПереводСтроки";
		
		
	КонецПроцедуры
	
#КонецЕсли
