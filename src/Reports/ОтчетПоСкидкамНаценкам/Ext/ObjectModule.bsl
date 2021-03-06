﻿Перем ВидНастройки Экспорт;                        // Вид настройки
Перем ИнформацияРасшифровки Экспорт;               // информация расшифроки отчета.
Перем ЗапросИсх Экспорт;                           // Исходный запрос
Перем Задание;
Перем ШиринаКолонок;
Перем ЗаголовокНастройка;
Перем НастройкиОтчетаНаМоментФормирования Экспорт; // настройка при формировании отчета.

#Если Клиент Тогда
	
	// Устанавливает параметры.
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
		
		Если НЕ КраткийВидНастройки Тогда
			ЗаголовокНастройка = СтрПолучитьСтроку(КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение,1);
			Заголовок = ЗаголовокНастройка + Символы.ПС + Период;
			
			КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение = Заголовок;
			
			УстановитьПараметры();	
			ФормированиеОтчетов.отчСформироватьОтчет(ЭтотОбъект, ТабличныйДокумент,,,ЭлементыФормы);
			КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение = ЗаголовокНастройка;
			
			НастройкиОтчетаНаМоментФормирования = ПолучитьТекущиеНастройки();
			
			Возврат;
		КонецЕсли;
		
		КомпоновщикНастроек.Настройки.Структура.Очистить();
		
		Если ПоказыватьДиаграмму И ПараметрВыводаДиаграммы = 0 Тогда
			СформироватьДиаграмму();
		КонецЕсли;
		
		Заголовок = "ОТЧЕТ ПО СКИДКАМ" + Символы.ПС + Период;
		
		КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение = Заголовок;
		
		// добавим поле группировки
		
		ГруппировкаТаблица = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ТаблицаКомпоновкиДанных"));
		Родитель = ГруппировкаТаблица.Строки;
		
		Если ГруппироватьПоПериоду Тогда
			ГруппировкаПоПериоду = Родитель.Добавить();
			
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
			
			Родитель = ГруппировкаПоПериоду.Структура;	 
		КонецЕсли;
		
		//
		Если НЕ ВариантФормирования = "Сводный отчет" Тогда
			ГруппировкаПоСкидкам = Родитель.Добавить();
			
			ПолеГруппировки                = ГруппировкаПоСкидкам.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			Если ВариантФормирования = "НаКлиента" Тогда
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Клиент");
			ИначеЕсли ВариантФормирования = "НаМесто" Тогда
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ПосадочноеМесто");
			ИначеЕсли ВариантФормирования = "НаТовар" Тогда
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Скидка");
			ИначеЕсли ВариантФормирования = "Ручная" Тогда
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Скидка");
			ИначеЕсли  ВариантФормирования = "НаВариантОплаты" Тогда
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("ВариантОплаты");
			ИначеЕсли  ВариантФормирования =  "НаЗаказ" Тогда
				ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Скидка");
			КонецЕсли;
		    			
			НовоеВыбранноеПоле = ГруппировкаПоСкидкам.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
			
			Родитель = ГруппировкаПоСкидкам.Структура;	 
			
		КонецЕсли;
		//
		
		Если РасшифровыватьПоДокументам Тогда
			ГруппировкаПоЗаказу = Родитель.Добавить();
			ПолеГруппировки                = ГруппировкаПоЗаказу.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
			ПолеГруппировки.Использование  = Истина;
			ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
			ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Ссылка"); 
			НовоеВыбранноеПоле = ГруппировкаПоЗаказу.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных")); 
			
		КонецЕсли;
		
		ДетальныеЗаписи = ГруппировкаТаблица.Колонки.Добавить();
		ПолеГруппировки                = ДетальныеЗаписи.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("");
		
		ВыбранноеПоле1 = ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле1.Использование = Истина;
		ВыбранноеПоле1.Заголовок = "";
		ВыбранноеПоле1.Поле = Новый ПолеКомпоновкиДанных("СуммаБезСкидок");
		
		ГруппировкаТипСкидки = ГруппировкаТаблица.Колонки.Добавить();
		ПолеГруппировки                = ГруппировкаТипСкидки.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("Тип");
		
		Если НЕ ВариантФормирования = "Сводный отчет" Тогда
			ВыбранноеПоле0 = ГруппировкаТипСкидки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
			ВыбранноеПоле0.Использование = Истина;
			ВыбранноеПоле0.Заголовок = "Кол-во";
			ВыбранноеПоле0.Поле = Новый ПолеКомпоновкиДанных("КолСкидок");
		КонецЕсли;
		
		ВыбранноеПоле1 = ГруппировкаТипСкидки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле1.Использование = Истина;
		ВыбранноеПоле1.Заголовок = "Сумма";
		ВыбранноеПоле1.Поле = Новый ПолеКомпоновкиДанных("Сумма");
		
		ВыбранноеПоле2 = ГруппировкаТипСкидки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле2.Использование = Истина;
		ВыбранноеПоле2.Заголовок = "Проц.";
		ВыбранноеПоле2.Поле = Новый ПолеКомпоновкиДанных("Процент");
		
		ВыбранноеПоле3 = ГруппировкаТипСкидки.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле3.Использование = Истина;
		ВыбранноеПоле3.Заголовок = " ";
		ВыбранноеПоле3.Поле = Новый ПолеКомпоновкиДанных("Тип");
		
		
		ДетальныеЗаписи = ГруппировкаТаблица.Колонки.Добавить();
		ПолеГруппировки                = ДетальныеЗаписи.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("");
		
		ВыбранноеПоле1 = ДетальныеЗаписи.Выбор.Элементы.Добавить(Тип("ВыбранноеПолеКомпоновкиДанных"));
		ВыбранноеПоле1.Использование = Истина;
		ВыбранноеПоле1.Заголовок = "";
		ВыбранноеПоле1.Поле = Новый ПолеКомпоновкиДанных("ИтоговаяСумма");
		
		
		ИмяПоляКомпоновкиДанныхПериод = Новый ПолеКомпоновкиДанных("Период");
		ИмяПоляКомпоновкиДанныхСмена = Новый ПолеКомпоновкиДанных("Смена");
		
		Если НЕ ВариантФормирования = "Сводный отчет" Тогда
			КомпоновщикНастроек.Настройки.Отбор.Элементы[0].Использование = Истина;
			КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение = Перечисления.ТипыСкидок[ВариантФормирования];
			КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ВидСравнения=ВидСравненияКомпоновкиДанных.Равно;
		Иначе
			КомпоновщикНастроек.Настройки.Отбор.Элементы[0].Использование = Ложь;
		КонецЕсли;

		УстановитьПараметры();
		
		Если ПоказыватьДиаграмму И ПараметрВыводаДиаграммы = 1 Тогда
			СформироватьДиаграмму();
		КонецЕсли;
		
		ФормированиеОтчетов.отчСформироватьОтчет(ЭтотОбъект, ТабличныйДокумент,,,ЭлементыФормы);
		
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
		Поле.Поле = Новый ПолеКомпоновкиДанных("Скидка");
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
	
	Если глВерсия = 3 Тогда
		ЭтотОбъект.СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаясхемаКомпоновкиДанных");
	Иначе
		ЭтотОбъект.СхемаКомпоновкиДанных = ПолучитьМакет("ОсновнаясхемаКомпоновкиДанных1");
	КонецЕсли;

#КонецЕсли