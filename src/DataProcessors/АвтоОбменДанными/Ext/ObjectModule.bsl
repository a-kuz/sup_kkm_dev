﻿
Перем мДатаПоследнегоОбновленияДанныхОбОбмене Экспорт; // дата последнего обновления информации об настройках обмена.
Перем мКоличествоСекундОпросаОбмена;                   // количество секунд опреса обмена.

Перем мКоэффициентУменьшенияИнтервалов;

// Функция формирует таблицу настроек обмена для автоматического выполнения
// текущим пользователем.
//
// Возвращаемое значение:
//   ТаблицаЗначений
//
Функция ПолучитьТаблицуАвтоматическихОбменовДанными(ТолькоДляПервогоВходаВПрограмму = Ложь, 
			ТолькоДляВходаВПрограмму = Ложь, ТолькоДляВыходаИзПрограммы = Ложь, ОграничениеПоДнюНедели = Истина,
			СсылкаНаНастройку = Неопределено, ОграничиватьПоПользователю = Истина)
	
	// для обмена при первом входе в программу константа не нужна
	Если Не ТолькоДляПервогоВходаВПрограмму Тогда
		
		ИспользоватьАвтообмен = ПроцедурыОбменаДанными.ИспользоватьМеханизмАвтоматическогоОбмена();
		Если Не ИспользоватьАвтообмен Тогда
			Возврат Неопределено;	
		КонецЕсли;
	
	КонецЕсли;
	
	// есть ли доступ к настройкам обмена данными
	Если НЕ ПравоДоступа("Чтение", Метаданные.Справочники.НастройкиОбменаДанными) 
		ИЛИ НЕ ПравоДоступа("Чтение", Метаданные.РегистрыСведений.ПараметрыОбменаДанными) Тогда	
		
		Возврат Неопределено;
		
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	
	ДополнительныеОграничения = "	НЕ	НастройкиОбменаДанными.ПометкаУдаления
								|	И (НастройкиОбменаДанными.ПроизводитьПриемСообщений 
								|		ИЛИ НастройкиОбменаДанными.ПроизводитьОтправкуСообщений)";
	
	// строим ограничения в зависимости от параметров
	Если ТолькоДляПервогоВходаВПрограмму Тогда
		ДополнительныеОграничения = "	ПараметрыОбменаДанными.ВыполнятьПриПервомВходеВСистему";
		
	ИначеЕсли ТолькоДляВходаВПрограмму Тогда
		ДополнительныеОграничения = ДополнительныеОграничения +	"
									|	И	НастройкиОбменаДанными.Ответственный = &ТекущийПользователь	
                                    |	И	НастройкиОбменаДанными.КаждыйЗапускПрограммы";
									
	ИначеЕсли ТолькоДляВыходаИзПрограммы Тогда
		ДополнительныеОграничения = ДополнительныеОграничения +	"
									|	И	НастройкиОбменаДанными.Ответственный = &ТекущийПользователь	
									|	И	НастройкиОбменаДанными.КаждоеЗавершениеРаботыСПрограммой";								
		
	Иначе
				
		
		Если ОграничиватьПоПользователю Тогда
			ОграничениеПоПользователю = "	И	НастройкиОбменаДанными.Ответственный = &ТекущийПользователь";
		Иначе
			ОграничениеПоПользователю = "";
		КонецЕсли;
		
		ДополнительныеОграничения = ДополнительныеОграничения +	"
									|" + ОграничениеПоПользователю + "
									|	И	
									|		 (НастройкиОбменаДанными.КаталогПроверкиДоступности <> """")
									|";
	КонецЕсли;
	
	
	Запрос.УстановитьПараметр("ТекущийПользователь", ПараметрыСеанса.ТекущийПользователь); 
	
	Если ЗначениеЗаполнено(СсылкаНаНастройку) Тогда
		
		ДополнительныеОграничения = ДополнительныеОграничения +	"
			| И (НастройкиОбменаДанными.Ссылка = &Ссылка)";
			
		Запрос.УстановитьПараметр("Ссылка", СсылкаНаНастройку);
		
	КонецЕсли;
		
	Запрос.Текст = "
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	НастройкиОбменаДанными.Ссылка								КАК Ссылка,
		|   НастройкиОбменаДанными.КаталогПроверкиДоступности           КАК КаталогПроверкиДоступности,
		|
		|	ПараметрыОбменаДанными.ДатаПоследнегоОбмена					КАК ДатаПоследнегоОбмена,
		|	ПараметрыОбменаДанными.ДоступностьКаталогаПроверки			КАК ДоступностьКаталогаПроверки
		|ИЗ
		|	Справочник.НастройкиОбменаДанными КАК НастройкиОбменаДанными
		|	Левое соединение РегистрСведений.ПараметрыОбменаДанными КАК ПараметрыОбменаДанными 
		|		ПО (ПараметрыОбменаДанными.НастройкаОбменаДанными = НастройкиОбменаДанными.Ссылка)
		|ГДЕ
		|" + ДополнительныеОграничения;
		
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

#Если Клиент Тогда
	
// процедура сообщает пользователю об изменениях в настройках автообмена
Процедура СообщитьОбИзмененияхВНастройкеАвтообмена(ТаблицаОбменов)
	
	СохраненнаяТаблица = ВосстановитьЗначение("ТаблицаАвтоматическогоОбменаДанными");

	Если ТипЗнч(СохраненнаяТаблица) <> Тип("ТаблицаЗначений") Тогда
		
		Возврат;
		
	КонецЕсли;
	
	СохраненнаяТаблица.Индексы.Добавить("Ссылка");
	
	// для тех строк, которые были до этого проверяем наличие новой строки
	Для Каждого СтрокаТаблицы Из СохраненнаяТаблица Цикл
				
		НайденнаяСтрока = ТаблицаОбменов.Найти(СтрокаТаблицы.Ссылка, "Ссылка");
				
		Если НайденнаяСтрока = Неопределено Тогда
			Сообщить("Из списка текущих автообменов удалена настройка """ + СтрокаТаблицы.Ссылка + """.");
			Продолжить;
		КонецЕсли;
						
	КонецЦикла;
	
	// для каждой новой строки проверяем была ли она в сохраненной копии
	Для Каждого СтрокаТаблицы Из ТаблицаОбменов Цикл
		
		НайденнаяСтрока = СохраненнаяТаблица.Найти(СтрокаТаблицы.Ссылка, "Ссылка");
		
		Если НайденнаяСтрока = Неопределено Тогда
			Сообщить("В список автоматического обмена данными добавлена новая настройка """ + СтрокаТаблицы.Ссылка + """");
		КонецЕсли; 
	
	КонецЦикла;
	
КонецПроцедуры
	
#КонецЕсли

// процедура устанавливает время последнего обмена данными для настройки обмена
Процедура ОбновитьИнформациюОНастройкахОбмена(НастройкаОбмена, Знач ДатаПоследнегоОбмена, Знач ДоступностьКаталога) Экспорт
	
	СтрокаТЧ = НастройкиДляОбмена.Найти(НастройкаОбмена.Ссылка, "Ссылка");
	Если СтрокаТЧ <> Неопределено Тогда
		
		СтрокаТЧ.ДатаПоследнегоОбмена = ДатаПоследнегоОбмена;						
		СтрокаТЧ.ДоступностьКаталогаПроверки = ДоступностьКаталога;
						
	КонецЕсли;
  	
КонецПроцедуры

// процедура обновляет одну настройку автоматического обмена данными
Процедура ОбновитьНастройкуАвтоматическогоОбмена(Ссылка) Экспорт
	
	// по настройке нужно определить подходит ли она для обмена сегодня
	НастройкаОбмена = Ссылка.ПолучитьОбъект();
	
	ТаблицаАвтоматическихОбменов = ПолучитьТаблицуАвтоматическихОбменовДанными(,,,,Ссылка);
	
	// настройка подходит для периодического автообмена
	Если (ТаблицаАвтоматическихОбменов = Неопределено) Тогда
		Возврат;
	КонецЕсли;
		
	Если (ТаблицаАвтоматическихОбменов.Количество() = 1) Тогда
		СтрокаТаблицы = ТаблицаАвтоматическихОбменов[0];
	Иначе
		СтрокаТаблицы = Неопределено;
	КонецЕсли;
			
	СтрокаНастройкиОбмена = НастройкиДляОбмена.Найти(Ссылка, "Ссылка");
	
	// есть ли сейчас эта настройка в с писке автообменов
	Если СтрокаНастройкиОбмена = Неопределено Тогда
		
		Если (СтрокаТаблицы <> Неопределено) Тогда
			
			// если настройка должна быть, то ее нужно в список добавить
			НоваяСтрокаТЧ = НастройкиДляОбмена.Добавить();
			НоваяСтрокаТЧ.ДатаИзмененияНастройкиОбмена = ТекущаяДата();
			ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, СтрокаТаблицы);
						
			#Если Клиент Тогда
				Сообщить("В список автоматического обмена данными добавлена новая настройка """ + СтрокаТаблицы.Ссылка + """");
			#КонецЕсли
			
		КонецЕсли;
		
	Иначе
		
		Если СтрокаТаблицы = Неопределено Тогда
			#Если Клиент Тогда
				Сообщить("Из списка текущих автообменов удалена настройка """ + СтрокаНастройкиОбмена.Ссылка + """.");
			#КонецЕсли	
		
			// надо удалять настройку обмена
			НастройкиДляОбмена.Удалить(СтрокаНастройкиОбмена);
		Иначе
						
			// изменились параметры настройки обмена
			ЗаполнитьЗначенияСвойств(СтрокаНастройкиОбмена, СтрокаТаблицы);
			
			СтрокаНастройкиОбмена.ДатаИзмененияНастройкиОбмена = ТекущаяДата();
									
		КонецЕсли;
		
	КонецЕсли;
	
	#Если Клиент Тогда
		СохранитьЗначение("ТаблицаАвтоматическогоОбменаДанными", НастройкиДляОбмена);
	#КонецЕсли
	
КонецПроцедуры

// Процедура обновляет список необходимых настроек для автоматического обмена данными
Процедура ОбновитьТабличнуюЧастьАвтоматическихОбменов(ТолькоДляПервогоВходаВПрограмму = Ложь, 
			ОбменПриВходеВПрограмму = Ложь, ОбменПриВыходеИзПрограммы = Ложь) Экспорт
	
	мДатаПоследнегоОбновленияДанныхОбОбмене = НачалоДня(ТекущаяДата());
	
	ТаблицаОбменов = ПолучитьТаблицуАвтоматическихОбменовДанными(ТолькоДляПервогоВходаВПрограмму, ОбменПриВходеВПрограмму, ОбменПриВыходеИзПрограммы);
	
	НастройкиДляОбмена.Очистить();
	
	Если ТаблицаОбменов = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	ТаблицаОбменов.Индексы.Добавить("Ссылка");

	Если НЕ (ТолькоДляПервогоВходаВПрограмму ИЛИ ОбменПриВходеВПрограмму ИЛИ ОбменПриВыходеИзПрограммы) Тогда
		
		#Если Клиент Тогда
			СообщитьОбИзмененияхВНастройкеАвтообмена(ТаблицаОбменов);
		#КонецЕсли
		
	КонецЕсли;	
	
	// перегоняем все в табличную часть
	Для Каждого СтрокаТаблицы Из ТаблицаОбменов Цикл
		
		НоваяСтрокаТЧ = НастройкиДляОбмена.Добавить();
		НоваяСтрокаТЧ.ДатаИзмененияНастройкиОбмена = ТекущаяДата();
		ЗаполнитьЗначенияСвойств(НоваяСтрокаТЧ, СтрокаТаблицы);
	    		
	КонецЦикла;
	
	Если НЕ (ТолькоДляПервогоВходаВПрограмму ИЛИ ОбменПриВходеВПрограмму ИЛИ ОбменПриВыходеИзПрограммы) Тогда
		
		#Если Клиент Тогда
			СохранитьЗначение("ТаблицаАвтоматическогоОбменаДанными", ТаблицаОбменов.Скопировать());
		#КонецЕсли
	
	КонецЕсли;
	
КонецПроцедуры

// Функция определяет подходит ли строка текущей настройки обмена для периодического обмена данными сейчас
Функция ОпределитьПодходитСтрокаДляПериодическогоОбмена(СтрокаТЧ)
	
	//сначала проверим может быть это настройка которая должна сработать при изменении доступности каталога
	Если НЕ ПустаяСтрока(СтрокаТЧ.КаталогПроверкиДоступности) Тогда
		
		//проверим что там с каталогом делается
		ТекущаяДоступностьКаталога = ПроцедурыОбменаДанными.ПроверитьНаличиеКаталога(СтрокаТЧ.КаталогПроверкиДоступности);
		
		Если ТекущаяДоступностьКаталога <> СтрокаТЧ.ДоступностьКаталогаПроверки Тогда
			
			// если до этого каталог был доступен а стал недоступен, то ничего не делаем, а только это фиксируем и все
			Если СтрокаТЧ.ДоступностьКаталогаПроверки Тогда
				
				ПроцедурыОбменаДанными.УстановитьДоступностьКаталогаДляПроверки(СтрокаТЧ.Ссылка, ТекущаяДоступностьКаталога);
				СтрокаТЧ.ДоступностьКаталогаПроверки = ТекущаяДоступностьКаталога;
				
			Иначе
				// а каталог то доступен стал, а был недоступен
				Возврат Истина;				
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
			
КонецФункции

// функция формирует массив строк для выполнения автоматического обмена данными
Функция СформироватьМассивСсылокНастроекОбмена()
	    	
	Если НастройкиДляОбмена.Количество() = 0 Тогда
		
		Возврат Неопределено;
		
	КонецЕсли;
	
	// а настроен ли вообще периодический обмен данными
	ИспользоватьАвтообмен = ПроцедурыОбменаДанными.ИспользоватьМеханизмАвтоматическогоОбмена();
	Если Не ИспользоватьАвтообмен Тогда
		
		// нет периодических обменов данными
		НастройкиДляОбмена.Очистить();
		Возврат Неопределено;
		
	КонецЕсли;
	
	//НастройкиДляОбмена.Сортировать("ВремяСледующегоОбмена");
	
	// тот массив строк с которыми будем работать для автоматического обмена
	МассивОбработанныхСтрок = Неопределено;
	
	Для Каждого СтрокаТЧ Из НастройкиДляОбмена Цикл
		
		// подходит строка для периодического обмена данными или нет
		СтрокаПодходитДляОбмена = ОпределитьПодходитСтрокаДляПериодическогоОбмена(СтрокаТЧ);
		
		Если СтрокаПодходитДляОбмена Тогда
			
			Если МассивОбработанныхСтрок = Неопределено Тогда 
				МассивОбработанныхСтрок = Новый Массив;
			КонецЕсли;
			
			// добавляем строку в список подходящих для работы
			МассивОбработанныхСтрок.Добавить(СтрокаТЧ.Ссылка);
		КонецЕсли;
						
	КонецЦикла;
	
	Возврат МассивОбработанныхСтрок;
	
КонецФункции

// процедура инициирует проведение списка обмена данными
Процедура ИнициироватьОбменДанными(МассивСсылокНастроек, ОбменПриПервомВходеВПрограмму = Ложь)
	
	ПроцедурыОбменаДанными.ПроизвестиСписокОбменовДанными(МассивСсылокНастроек, , ЭтотОбъект, ОбменПриПервомВходеВПрограмму);
	
КонецПроцедуры

// процедура проводит обмен по настройкам обменов
Процедура ПровестиОбменДанными() Экспорт
	
	Если НачалоДня(ТекущаяДата()) <> мДатаПоследнегоОбновленияДанныхОбОбмене Тогда
		
		// день сменился, обновляем информацию об обмене для этого дня
		ОбновитьТабличнуюЧастьАвтоматическихОбменов();
				
	КонецЕсли;
	
	// тот массив строк с которыми будем работать для автоматического обмена
	МассивСсылокНастроек = СформироватьМассивСсылокНастроекОбмена();
	
	ИнициироватьОбменДанными(МассивСсылокНастроек);

КонецПроцедуры

// процедура производит обмен данными при входе или выходе из программы
Процедура ПроизвестиОбменПриВходеВыходе(ОбменПриПервомВходеВПрограмму = Ложь, ОбменПриВходеВПрограмму = Ложь, ОбменПриВыходеИзПрограммы = Ложь) Экспорт
	
	ОбновитьТабличнуюЧастьАвтоматическихОбменов(ОбменПриПервомВходеВПрограмму, ОбменПриВходеВПрограмму, ОбменПриВыходеИзПрограммы);
	
	МассивОбменов = НастройкиДляОбмена.ВыгрузитьКолонку("Ссылка");
		
	ИнициироватьОбменДанными(МассивОбменов, ОбменПриПервомВходеВПрограмму);

	// далее настройки обмена не нужны
	НастройкиДляОбмена.Очистить();
	
КонецПроцедуры


// ИНИЦИАЛИЗАЦИЯ
///////////////////////////////////////////////////////////////////////////////

мДатаПоследнегоОбновленияДанныхОбОбмене = Неопределено;

#Если Клиент тогда
	мКоличествоСекундОпросаОбмена = глКоличествоСекундОпросаОбмена;
#Иначе
	мКоличествоСекундОпросаОбмена = 60;	
#КонецЕсли