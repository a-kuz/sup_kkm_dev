﻿Перем ВидНастройки Экспорт;                        // Вид настройки
Перем ИнформацияРасшифровки Экспорт;               // информация расшифроки отчета.
Перем ЗапросИсх Экспорт;                           // исходный запрос
Перем Задание;
Перем ШиринаКолонок;
Перем ЗаголовокНастройка;
Перем НастройкиОтчетаНаМоментФормирования Экспорт; // настройка при формировании отчета.
Перем ДобавленОтборПоКоличествуПосещений;

#Если Клиент Тогда
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
			
				
			ПечататьНаПринтере(Смена);
			Возврат;
		КонецЕсли;	
		
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
		
		Заголовок = "ДАВНОСТЬ ПОСЕЩЕНИЙ ПО КАРТАМ КеГеЛьБУМ" + Символы.ПС + Период;
		
		КомпоновщикНастроек.Настройки.ПараметрыВывода.НайтиЗначениеПараметра(Новый ПараметрКомпоновкиДанных("Заголовок")).Значение = Заголовок;
		
		// добавим поле группировки
		ГруппировкаРодитель = КомпоновщикНастроек.Настройки;
		
		ГруппировкаПоКлиенту = ГруппировкаРодитель.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных")); 

		ПолеГруппировки                = ГруппировкаПоКлиенту.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		ПолеГруппировки.Использование  = Истина;
		ПолеГруппировки.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
					
		ПолеГруппировки.Поле           = Новый ПолеКомпоновкиДанных("НомерКартыЛояльности");
		
		НовоеВыбранноеПоле = ГруппировкаПоКлиенту.Выбор.Элементы.Добавить(Тип("АвтоВыбранноеПолеКомпоновкиДанных"));
		
		ГруппировкаРодитель = ГруппировкаПоКлиенту;
		
		Если ГруппироватьПоПериоду Тогда
			//ГруппировкаПоПериоду = КомпоновщикНастроек.Настройки.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			ГруппировкаПоПериоду = ГруппировкаРодитель.Структура.Добавить(Тип("ГруппировкаКомпоновкиДанных"));
			
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
		
		
		// отбор
		Если НеУчитыватьКлиентов Тогда
			
			Для каждого ЭлементСтуктурыНастроекКД Из КомпоновщикНастроек.Настройки.Структура Цикл
				Если НЕ ТипЗнч(ЭлементСтуктурыНастроекКД) = Тип("ГруппировкаКомпоновкиДанных") ТОгда
					Продолжить;
				КонецЕсли;
			
				Если ЭлементСтуктурыНастроекКД.ПоляГруппировки.Элементы.Количество() > 0
					И ЭлементСтуктурыНастроекКД.ПоляГруппировки.Элементы[0].Поле = Новый ПолеКомпоновкиДанных("НомерКартыЛояльности") Тогда

					НовыйОтбор = ЭлементСтуктурыНастроекКД.Отбор.Элементы.Добавить(тип("ЭлементОтбораКомпоновкиДанных"));
					//НовыйОтбор.ЛевоеЗначение = КомпоновщикНастроек.Настройки.Структура[0].Отбор.ДоступныеПоляОтбора.НайтиПоле(Новый ПолеКомпоновкиДанных("КоличествоПосещений")).Поле;
					НовыйОтбор.Использование  = Истина;
					НовыйОтбор.ЛевоеЗначение  = Новый ПолеКомпоновкиДанных("КоличествоПосещений");
					НовыйОтбор.ПравоеЗначение = КолвоПосещенийДляОтбора;
					НовыйОтбор.ВидСравнения   = ВидСравненияКомпоновкиДанных.Больше;
				КонецЕсли;
			КонецЦикла; 
			
		КонецЕсли;

		// сортировка
		Для Порядок=0 По 3 Цикл
			КомпоновщикНастроек.Настройки.Порядок.Элементы[Порядок].Использование = Ложь;
		КонецЦикла;  
		//Для Каждого Порядок Из КомпоновщикНастроек.Настройки.Порядок.Элементы Цикл
		//	Порядок.Использование = Ложь;
		//КонецЦикла;
		КомпоновщикНастроек.Настройки.Порядок.Элементы[Сортировка].Использование = Истина;
		
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
		ВыбранноеПоле.Заголовок = "Давность посещений";
		ВыбранноеПоле.Поле = Новый ПолеКомпоновкиДанных("СПоследнегоПосещения");
		
		Серия = Диаграмма.Серии.Добавить();
		Серия.Использование = Истина;
		Поле = Серия.ПоляГруппировки.Элементы.Добавить(Тип("ПолеГруппировкиКомпоновкиДанных"));
		Поле.Поле = Новый ПолеКомпоновкиДанных(?(ГруппироватьПоПериоду,ВидПериода, "" ));
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
				
	КонецПроцедуры
	
	// Формирование строки отчета на принтер.
	//
	Процедура СформироватьСтроку(Стр, Число1="", Число2="", Число3, Выделение) Экспорт
		
		Выделение=?(Выделение,"Жирный","НеЖирный");
		
		НоваяСтрока = Задание.Добавить();
		НоваяСтрока.Данные    = СтрДополнитьСправа(Стр, ШиринаКолонок[0].Значение);
		НоваяСтрока.ТипДанных = "Строка";
		НоваяСтрока.Параметры = Выделение+",НеПереводСтроки";
		
		
		НоваяСтрока = Задание.Добавить();
		НоваяСтрока.Данные    = СтрДополнитьСлева(Строка(Формат(Число1,"ЧЦ="+ШиринаКолонок[1].Значение +"; ЧДЦ=2")), ШиринаКолонок[1].Значение);
		НоваяСтрока.ТипДанных = "Строка";
		НоваяСтрока.Параметры = Выделение+",НеПереводСтроки";
		
		НоваяСтрока = Задание.Добавить();
		НоваяСтрока.Данные    = СтрДополнитьСлева(Строка(Формат(Число2,"ЧЦ="+ШиринаКолонок[2].Значение +"; ЧДЦ=2")), ШиринаКолонок[2].Значение);
		НоваяСтрока.ТипДанных = "Строка";
		НоваяСтрока.Параметры = Выделение+",НеПереводСтроки";
		
		НоваяСтрока = Задание.Добавить();
		НоваяСтрока.Данные    = СтрДополнитьСлева(Строка(Формат(Число3,"ЧЦ="+ШиринаКолонок[3].Значение +"; ЧДЦ=2")), ШиринаКолонок[3].Значение);
		НоваяСтрока.ТипДанных = "Строка";
		НоваяСтрока.Параметры = Выделение+",ПереводСтроки";
		
	КонецПроцедуры
	
#КонецЕсли

ДобавленОтборПоКоличествуПосещений = Ложь;

КолвоПосещенийДляОтбора = 1;
НеУчитыватьКлиентов = 1;