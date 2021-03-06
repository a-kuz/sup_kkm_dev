﻿
Перем ВидМеню;

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;

	Если НЕ ЭтоГруппа Тогда
		Если ВариантНаличияВПродаже.Пустая() Тогда
			ВариантНаличияВПродаже = Перечисления.ВариантыНаличияВПродаже.Простой;
		КонецЕсли; 
		
		
		Если ЭтотОбъект.Тип.Пустая() Тогда
			ЭтотОбъект.Тип = Перечисления.ТипыТоваров.Товар;
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЭтотОбъект.ЭтоНовый() И ЭтотОбъект.Код = 0 Тогда
		ЭтотОбъект.УстановитьНовыйКод();
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(Наименование) Тогда
		Сообщить("Не заполнено наименование!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;

	Если Не ЭтоГруппа Тогда
		Если ГруппаКонтроляПродажи.Пустая() Тогда
			ГруппаКонтроляПродажи = Справочники.ГруппыКонтроляПродажи.НетКонтроля;
		КонецЕсли;
	КонецЕсли;
	Попытка
		ИзменитьПорядокЭлементов(Отказ);			
	Исключение
	КонецПопытки;
	
 	Наименование = СокрЛП(Наименование);
	
КонецПроцедуры

Процедура ИзменитьПорядокЭлементов(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если (НЕ ЗначениеЗаполнено(Порядок) ИЛИ ЭтоНовый()) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		|	Товары.Порядок КАК Порядок
		|ИЗ
		|	Справочник.Товары КАК Товары
		|ГДЕ
		|	Товары.Родитель = &Родитель
		|	И Товары.Владелец = &Владелец
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок УБЫВ");
		
		Запрос.УстановитьПараметр("Родитель", Родитель);
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Выборка = Запрос.Выполнить().Выбрать();
		Порядок = ?(Выборка.Следующий(), Выборка.Порядок + 1, 1);
		
	ИначеЕсли Родитель <> Ссылка.Родитель Тогда // необходимо установить новый порядок
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		|	Товары.Порядок КАК Порядок
		|ИЗ
		|	Справочник.Товары КАК Товары
		|ГДЕ
		|	Товары.Родитель = &Родитель
		|	И Товары.Владелец = &Владелец
		|	И ВЫБОР
		|			КОГДА &ЭтоГруппа
		|				ТОГДА Товары.ЭтоГруппа = ИСТИНА
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок УБЫВ");
		
		Запрос.УстановитьПараметр("Родитель", Родитель);
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоГруппа);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Порядок = Выборка.Порядок + 1;
		КонецЕсли;
		
		Если ЭтоГруппа Тогда
			
			// Увеличим нумерацию у следующих элементов
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	Товары.Ссылка
			|ИЗ
			|	Справочник.Товары КАК Товары
			|ГДЕ
			|	Товары.Родитель = &Родитель
			|	И Товары.Владелец = &Владелец
			|	И Товары.ЭтоГруппа = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Товары.Порядок");
			
			Запрос.УстановитьПараметр("Родитель", Родитель);
			Запрос.УстановитьПараметр("Владелец", Владелец);
			Запрос.УстановитьПараметр("Порядок"	, Порядок);
			
			Выборка = Запрос.Выполнить().Выбрать();
			НовыйПорядок = Порядок + 1;
			Пока Выборка.Следующий() Цикл
				Объект = Выборка.Ссылка.ПолучитьОбъект();
				Объект.Порядок = НовыйПорядок;
				Попытка
					Объект.Записать();
				Исключение
				КонецПопытки;
				НовыйПорядок = НовыйПорядок + 1;
			КонецЦикла;
			
		КонецЕсли;
		
		// изменим порядок у элементов предыдущего родителя
		Запрос = Новый Запрос("ВЫБРАТЬ
		|	Товары.Ссылка
		|ИЗ
		|	Справочник.Товары КАК Товары
		|ГДЕ
		|	Товары.Родитель = &Родитель
		|	И Товары.Владелец = &Владелец
		|	И Товары.Порядок > &Порядок
		|
		|УПОРЯДОЧИТЬ ПО
		|	Товары.Порядок");
		
		Запрос.УстановитьПараметр("Родитель", Ссылка.Родитель);
		Запрос.УстановитьПараметр("Владелец", Владелец);
		Запрос.УстановитьПараметр("Порядок"	, Ссылка.Порядок);
		
		Выборка = Запрос.Выполнить().Выбрать();
		НовыйПорядок = Ссылка.Порядок;
		Пока Выборка.Следующий() Цикл
			Объект = Выборка.Ссылка.ПолучитьОбъект();
			Объект.Порядок = НовыйПорядок;
			Попытка
				Объект.Записать();
			Исключение
			КонецПопытки;
			НовыйПорядок = НовыйПорядок + 1;				
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#Если ТолстыйКлиентОбычноеПриложение Тогда

// Процедура осуществляет печать документа. Можно направить печать на 
// экран или принтер, а также распечатать необходмое количество копий.
//
//  Название макета печати передается в качестве параметра,
// по переданному названию находим имя макета в соответствии.
//
// Параметры:
//  ИмяМакета             - строка, название макета.
//  КоличествоЭкземпляров - количество экземплятов печатных форм.
//  НаПринтер             - выводить печатную форму на принтер.
//  ИмяПринтера           - имя принтера, на котором производится печать.
//
Процедура ПечатьМеню(ИмяМакета, КоличествоЭкземпляров = 1, НаПринтер = Ложь, ИмяПринтера = Неопределено) Экспорт
	
	ВидМеню = ИмяМакета;
	Язык = Неопределено;
	
	ТекДата = ТекущаяДата();
	Если НЕ ВвестиДату(ТекДата,"Укажите дату на которую сформировать МЕНЮ",ЧастиДаты.Дата)	тогда
		возврат
	КонецЕсли;
	
	// Управленческая печатная форма документа
	ТипЦен = ИнтерфейсАдмина.ВыбратьИзСпискаТиповЦен();
	Если ТипЦен = Неопределено Тогда
		Возврат;
	КонецЕсли;

	// Получить экземпляр документа на печать
	Если ИмяМакета = "ПростоеМеню"  Тогда
		ТабДокумент = ПечатьПростоеМеню(ТипЦен,ТекДата);
	ИначеЕсли ИмяМакета = "МенюСПереводом" Тогда
		// Печатная форма с переводом на дополнительный язык
		Язык = ИнтерфейсАдмина.ВыбратьИзСпискаЯзыков();
		ТабДокумент = ПечатьПростоеМеню(ТипЦен,ТекДата, Язык);
	ИначеЕсли ИмяМакета = "МенюСоСпецификами" Тогда
		ТабДокумент = ПечатьПростоеМеню(ТипЦен,ТекДата);
	ИначеЕсли ИмяМакета = "МенюСоШтрихКодами" Тогда
		ТабДокумент = ПечатьПростоеМеню(ТипЦен,ТекДата);
	ИначеЕсли ИмяМакета = "МенюСПоказателями" Тогда
		ТабДокумент = ПечатьПростоеМеню(ТипЦен,ТекДата);
	ИначеЕсли ТипЗнч(ИмяМакета) = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
		Попытка
			Обработка = ПолучитьОбработкуИзСправочникаВнешнихОбработок(ИмяМакета);
			ТабДокумент = Обработка.Печать(ЭтотОбъект);
		Исключение
			Сообщить("Ошибка открытия печатной формы!");
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	Если ТабДокумент <> Неопределено Тогда
		ТабДокумент.Показать();
	КонецЕсли;
	//НапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, Ссылка, Ссылка.Автор, ИмяПринтера);
	
КонецПроцедуры

Процедура Печать(ПФ=Неопределено,НаПринтер=Ложь) Экспорт
       СправочникОбъект=ЭтотОбъект;мПФ=ПФ;
       Если НЕ ИнтерфейсАдмина.ЗапретПечати(ПФ,СправочникОбъект) тогда 
               МакетПроцедура=ИнтерфейсАдмина.ПолучитьМакетПроцедуруПечатнойФормы(СправочникОбъект,мПФ);
               Если МакетПроцедура<>Неопределено Тогда
                       Макет=МакетПроцедура.Макет;
                       Выполнить(МакетПроцедура.Процедура);
               КонецЕсли;
       КонецЕсли;
   КонецПроцедуры
   
// Функция формирует табличный документ с печатной формой накладной,
// разработанной методистами
//
// Возвращаемое значение:
//  Табличный документ - печатная форма накладной
//
Функция ПечатьПростоеМеню(ТипЦен, ТекДата, Язык=Неопределено,ШтрихКод=Ложь)
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Меню_ПростоеМеню";
	
	Если НЕ ЗначениеЗаполнено(Владелец) Тогда
		Возврат ТабДокумент;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	Товары.Наименование,
	               |	Товары.ЕдиницаИзмерения,
	               |	Товары.Ссылка,
	               |	Товары.КодСуп как Код,
	               |	Товары.ЭтоГруппа,
	               |	ЕСТЬNULL(ЦеныСрезПоследних.Цена, 0) КАК Цена,
	               |	ЦеныСрезПоследних.Валюта,
	               |	Товары.Номенклатура.Выход Как Выход" + ?(глВерсия>1, ",Товары.ГруппаСпецифик","") + "
	               |ИЗ
	               |	Справочник.Товары КАК Товары
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныНоменклатуры.СрезПоследних(&Дата, ТипЦен = &ТипЦен) КАК ЦеныСрезПоследних
	               |		ПО (ЦеныСрезПоследних.Номенклатура = Товары.Номенклатура)
	               |ГДЕ
	               |	(Товары.ЭтоГруппа
	               |			ИЛИ Товары.ЕстьВПродаже = ИСТИНА)
	               |	И Товары.ПометкаУдаления = ЛОЖЬ
	               |	И Товары.Владелец = &Владелец
	               |АВТОУПОРЯДОЧИВАНИЕ";
	Запрос.УстановитьПараметр("Владелец", Владелец);
	Запрос.УстановитьПараметр("Дата", ТекДата);
	Запрос.УстановитьПараметр("ТипЦен", ТипЦен);
	
	
	Выгрузка = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
	
	Макет = ПолучитьМакет(ВидМеню);
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьШапка.Параметры.Дата = Формат(ТекДата,"ДЛФ=ДД");
	ОбластьШапка.Параметры.Каталог = Владелец;
	ТабДокумент.Вывести(ОбластьШапка);
	
	Для Каждого Строка Из Выгрузка.Строки Цикл
		Если НЕ ВывестиСтроку(Макет, ТабДокумент, Строка, Язык, ТекДата)Тогда
			Возврат Неопределено;
		КонецЕсли;
	КонецЦикла;	
	
	ОбластьПодвала = Макет.ПолучитьОбласть("Подвал");	
	ТабДокумент.Вывести(ОбластьПодвала);
	
	ТабДокумент.ОтображатьСетку = Ложь;
	ТабДокумент.ОтображатьЗаголовки = Ложь;
	
	Возврат ТабДокумент;
	
КонецФункции // ПечатьПростоеМеню()

// Возвращает доступные варианты печати документа.
//
// Параметры:
//  Нет.
//
// Вовращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати.
//  
Функция ПолучитьСписокПечатныхФорм() Экспорт
	
	СписокМакетов = Новый СписокЗначений;
	СписокМакетов.Добавить("ПростоеМеню",	"Простое меню");
	Если глВерсия>1 Тогда
		СписокМакетов.Добавить("МенюСоСпецификами","Меню со спецификами"); 
		Если Константы.ДопЯзыки.Получить() Тогда
			СписокМакетов.Добавить("МенюСПереводом","Меню с переводом");
		КонецЕсли;
	КонецЕсли;

	ЗаполнитьСписокОбработок(СписокМакетов, Перечисления.ВидыОбработок.ПечатнаяФорма, "Справочник.Товары", Истина, Ложь);
	Возврат СписокМакетов;
	
КонецФункции

Функция ВывестиСтроку(Макет, Таб, Строка, Язык, ТекДата)
	
	Область0 = Макет.ПолучитьОбласть("Группа0");
	Область1 = Макет.ПолучитьОбласть("Группа1");
	Область2 = Макет.ПолучитьОбласть("Группа2");
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");
	ОбластьСостав = Макет.ПолучитьОбласть("Состав");
	Если  ВидМеню = "МенюСПереводом" И Язык<>Неопределено Тогда
		ОбластьПереводСтр = Макет.ПолучитьОбласть("ПереводСтрока");
		ОбластьПеревод0 = Макет.ПолучитьОбласть("ПереводГруппа0"); 
		ОбластьПеревод1 = Макет.ПолучитьОбласть("ПереводГруппа1"); 
		ОбластьПеревод2 = Макет.ПолучитьОбласть("ПереводГруппа2"); 
		ПечатьЗаказа = Обработки.ПечатьЗаказа.Создать();
    КонецЕсли;
	
	Если Не Строка.ЭтоГруппа Тогда
		Если ВидМеню = "МенюСоШтрихКодами" Тогда
			Попытка 
				Макет.Рисунки.ШтрихКод.Объект.ОтображатьТекст        = Истина;
				Макет.Рисунки.ШтрихКодБезНаим.Объект.ОтображатьТекст = Истина;
			Исключение
				Предупреждение("Ошибка печати!
			                   |Не установлен элемент управления 
				               |""1С: Печать штрих-кодов""");
				Возврат Ложь;
				
			КонецПопытки;
						
			Запрос = Новый Запрос;
			Запрос.Текст="ВЫБРАТЬ
			|	ШтрихКоды.ШтрихКод
			|ИЗ
			|	Справочник.ШтрихКоды КАК ШтрихКоды
			|ГДЕ
			|	ШтрихКоды.Товар = &Товар
			|	И ШтрихКоды.ПометкаУдаления = ЛОЖЬ";
			
			Запрос.УстановитьПараметр("Товар", Строка.Ссылка);
			ВыборкаРезультатаЗапроса = Запрос.Выполнить().Выбрать();
			н = 0;
			Пока ВыборкаРезультатаЗапроса.Следующий() Цикл
				Попытка
					Если н=0 Тогда  
						// область надо получать после присвоения значения штрих-коду, 
					    // иначе выводится предыдущее сообщение
						Макет.Рисунки.ШтрихКод.Объект.Сообщение = ВыборкаРезультатаЗапроса.ШтрихКод;
						ОбластьСоШтрихКодом = Макет.ПолучитьОбласть("СтрокаСоШтрихКодом");
					Иначе  
						Макет.Рисунки.ШтрихКодБезНаим.Объект.Сообщение = ВыборкаРезультатаЗапроса.ШтрихКод;
						ОбластьШтрихКод     = Макет.ПолучитьОбласть("ТолькоШтрихКод");
					КонецЕсли;
				Исключение
					Предупреждение("Ошибка печати!
					|Не установлен элемент управления 
					|""1С: Печать штрих-кодов""");
					Возврат Ложь;
				КонецПопытки;
				
				Если н=0 Тогда
					ОбластьСоШтрихКодом.Параметры.Наименование = Строка.Наименование + " (" + Строка.ЕдиницаИзмерения + ")";
					ОбластьСоШтрихКодом.Параметры.ЦенаПродажи = ПересчетВалют(Строка.Цена, Строка.Валюта);
					Таб.Вывести(ОбластьСоШтрихКодом);
				Иначе
					Таб.Вывести(ОбластьШтрихКод);
				КонецЕсли;
				н = н+1;
			КонецЦикла;
			
			Если н=0 Тогда
				ОбластьСтрока.Параметры.Наименование = Строка.Наименование + " (" + Строка.ЕдиницаИзмерения + ")";
				ОбластьСтрока.Параметры.Код = Строка.Код;
				ОбластьСтрока.Параметры.ЦенаПродажи = ПересчетВалют(Строка.Цена, Строка.Валюта);
				ОбластьСостав.Параметры.СтрокаСостава = "Выход в граммах: " + Строка.Выход;
				Таб.Вывести(ОбластьСтрока);
			КонецЕсли;
		Иначе		
			ОбластьСтрока.Параметры.Наименование = Строка.Наименование + " (" + Строка.ЕдиницаИзмерения + ")";
			Если ВидМеню = "ПростоеМеню" Тогда
				ОбластьСтрока.Параметры.Код = Строка.Код;
			КонецЕсли;
			ОбластьСтрока.Параметры.ЦенаПродажи = ПересчетВалют(Строка.Цена, Строка.Валюта);
			ОбластьСостав.Параметры.СтрокаСостава = "Выход в граммах: " + Строка.Выход;
			Таб.Вывести(ОбластьСтрока); 
		КонецЕсли;

		Если  ВидМеню = "МенюСПереводом" И Язык<>Неопределено Тогда
			ПереводНаим  = ПечатьЗаказа.ДопНаименование(Строка.Ссылка, Язык.Значение);
			Если ПереводНаим <> Строка.Наименование Тогда
				ПереводЕдИзм = ПечатьЗаказа.ДопНаименование(Строка.ЕдиницаИзмерения, Язык.Значение);
				ОбластьПереводСтр.Параметры.Перевод = ПереводНаим+ " (" + ПереводЕдИзм + ")"; 
				Таб.Вывести(ОбластьПереводСтр);
			КонецЕсли;
			
		ИначеЕсли ВидМеню = "МенюСоСпецификами" Тогда
			ВывестиСпецифики(Строка,Таб,Макет,ТекДата);
			
		ИначеЕсли ВидМеню = "МенюСПоказателями" Тогда
			ОбластьПоказатель = Макет.ПолучитьОбласть("ПоказательСтрока");
			пНоменклатура = Строка.Ссылка.Номенклатура;
			СтрПоказатели = "";
			Коэф = 1;
			
			Попытка
				Кратность = Число(Строка.Выход);
				Коэф = Кратность/100;
				
				Если ЗначениеЗаполнено(пНоменклатура.СБ_СодержаниеБелков) Тогда
					СтрПоказатели = ""+СтрПоказатели+"Белки - "+Окр(пНоменклатура.СБ_СодержаниеБелков*Коэф)+" г. "; 
				КонецЕсли; 
				Если ЗначениеЗаполнено(пНоменклатура.СБ_СодержаниеЖиров) Тогда
					СтрПоказатели = ""+СтрПоказатели+"Жиры - "+Окр(Строка.Ссылка.Номенклатура.СБ_СодержаниеЖиров*Коэф)+" г. "; 
				КонецЕсли;
				Если ЗначениеЗаполнено(пНоменклатура.СБ_СодержаниеУглеводов) Тогда
					СтрПоказатели = ""+СтрПоказатели+"Углеводы - "+Окр(пНоменклатура.СБ_СодержаниеУглеводов*Коэф)+" г. "; 
				КонецЕсли;  
				Если не ПустаяСтрока(СтрПоказатели) Тогда
					СтрПоказатели = "Пищевая ценность: " + СтрПоказатели;
				КонецЕсли;
			Исключение
			КонецПопытки;
			
			Если ЗначениеЗаполнено(пНоменклатура.СБ_СодержаниеККАЛ) Тогда
				СтрПоказатели = ""+СтрПоказатели+"Энергетическая ценность: ";
				СтрПоказатели = ""+СтрПоказатели+Окр(пНоменклатура.СБ_СодержаниеККАЛ*Коэф)+" ккал. ";
			КонецЕсли;  
			
			Если пНоменклатура.СБ_СодержитГМО Тогда  
				СтрПоказатели = ""+СтрПоказатели+"Содержит генетически модифицированную продукцию.";
			КонецЕсли;  
			
			Если ЗначениеЗаполнено(пНоменклатура.состав) Тогда
				СтрПоказатели = ""+СтрПоказатели + символы.ПС + "Состав: "+пНоменклатура.Состав;
			КонецЕсли;
			
			Если ЗначениеЗаполнено(СтрПоказатели) Тогда
				ОбластьПоказатель.Параметры.Показатель = СтрПоказатели;
				Таб.Вывести(ОбластьПоказатель);
			Конецесли;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Строка.Выход) Тогда
			Таб.Вывести(ОбластьСостав);
		КонецЕсли;
		
		Возврат Истина;			
	КонецЕсли;	
	
	Если Строка.Строки.Количество() > 0 Тогда
		Строка.Строки.Сортировать("Код Возр");
		Уровень = Строка.Ссылка.Уровень();
		Если Уровень = 0 Тогда
			Область0.Параметры.Наименование = Строка.Наименование;
			Если ВидМеню = "ПростоеМеню" Тогда
				Область0.Параметры.Код = Строка.Код;
			КонецЕсли;
			Таб.Вывести(Область0);
			Если  ВидМеню = "МенюСПереводом" И Язык<>Неопределено Тогда
				ПереводНаим  = ПечатьЗаказа.ДопНаименование(Строка.Ссылка, Язык.Значение);
				Если ПереводНаим <> Строка.Наименование Тогда
					ОбластьПеревод0.Параметры.Перевод = ПереводНаим; 
					Таб.Вывести(ОбластьПеревод0);
				КонецЕсли;
			КонецЕсли;
        ИначеЕсли Уровень = 1 Тогда
			Область1.Параметры.Наименование = Строка.Наименование;
			Если ВидМеню = "ПростоеМеню" Тогда
				Область1.Параметры.Код = Строка.Код;
			КонецЕсли;
			
			Таб.Вывести(Область1);
			Если  ВидМеню = "МенюСПереводом" И Язык<>Неопределено Тогда
				ПереводНаим  = ПечатьЗаказа.ДопНаименование(Строка.Ссылка, Язык.Значение);
				Если ПереводНаим <> Строка.Наименование Тогда
					ОбластьПеревод1.Параметры.Перевод = ПереводНаим; 
					Таб.Вывести(ОбластьПеревод1);
				КонецЕсли;
			КонецЕсли;
    	Иначе
			Область2.Параметры.Наименование = Строка.Наименование;
			Если ВидМеню = "ПростоеМеню" Тогда
				Область2.Параметры.Код = Строка.Код;
			КонецЕсли;
			
			Таб.Вывести(Область2);
			Если  ВидМеню = "МенюСПереводом" И Язык<>Неопределено Тогда
				ПереводНаим  = ПечатьЗаказа.ДопНаименование(Строка.Ссылка, Язык.Значение);
				Если ПереводНаим <> Строка.Наименование Тогда
					ОбластьПеревод2.Параметры.Перевод = ПереводНаим; 
					Таб.Вывести(ОбластьПеревод2);
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Для Каждого Стр Из Строка.Строки Цикл
			Если НЕ ВывестиСтроку(Макет, Таб, Стр,Язык, ТекДата) Тогда
				Возврат Ложь;
			КонецЕсли;
		КонецЦикла;
		Возврат Истина;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции	

Процедура ВывестиСпецифики(Строка,Таб,Макет,текДата) 
	
	Если ЗначениеЗаполнено(Строка.ГруппаСпецифик) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Специфики.Наименование,
		|	Специфики.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Специфики КАК Специфики
		|ГДЕ
		|	(Специфики.Родитель = &Родитель
		|			ИЛИ Специфики.Родитель.Родитель = &Родитель
		|                ИЛИ Специфики.Родитель.Родитель.Родитель = &Родитель) 
		|АВТОУПОРЯДОЧИВАНИЕ";
		Запрос.УстановитьПараметр("Родитель",Строка.ГруппаСпецифик);
		
		РезультатЗапроса = Запрос.Выполнить().Выгрузить(ОбходРезультатаЗапроса.ПоГруппировкамСИерархией);
		Для Каждого СтрокаЗапроса ИЗ РезультатЗапроса.Строки Цикл
			Если ксТрактир.СпецификаИспользуется(СтрокаЗапроса.Ссылка,ТекДата) тогда
				ВывестиСтрокуСпецифики(СтрокаЗапроса,Таб,Макет);
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВывестиСтрокуСпецифики(Строка,Таб,Макет)
	ОбластьСпецифики0 = Макет.ПолучитьОбласть("Специфика0");
	ОбластьСпецифики1 = Макет.ПолучитьОбласть("Специфика1");
	ОбластьСпецифики2 = Макет.ПолучитьОбласть("Специфика2");
	
	Если Не Строка.Ссылка.ЭтоГруппа Тогда
		ОбластьСпецифики2.Параметры.Специфика = "- "+Строка.Наименование;
		Таб.Вывести(ОбластьСпецифики2);
		Возврат;			
	КонецЕсли;	
	
	Если Строка.Строки.Количество() > 0 Тогда
		//	СтрокаЗапроса.Строки.Сортировать("Код Возр");
		Уровень = Строка.Ссылка.Уровень();
		Если Уровень = 1 Тогда
			ОбластьСпецифики0.Параметры.Специфика = Строка.Наименование;
			Таб.Вывести(ОбластьСпецифики0);
		ИначеЕсли Уровень = 2 Тогда
			ОбластьСпецифики1.Параметры.Специфика = Строка.Наименование;
			Таб.Вывести(ОбластьСпецифики1);
		КонецЕсли;
		Для Каждого Стр Из Строка.Строки Цикл
			ВывестиСтрокуСпецифики(Стр,Таб,Макет)	
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

///////////////////////////////////////////////////////
// ФОРМИРОВАНИЕ ОТЧЕТОВ

// Возвращает доступные отчеты в зависимости от версии.
//
// Параметры:
//  Нет.
//
// Вовращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати.
//  
Функция ПолучитьСписокОтчетов() Экспорт
	
	СписокОтчетов = Новый СписокЗначений;
	СписокОтчетов.Добавить("ОтчетПоРасходу",		"Отчет по расходу");
	СписокОтчетов.Добавить("ОтчетПоВозвратам",		"Отчет по возвратам");
	СписокОтчетов.Добавить("ОтчетПоСебестоимости",	"Отчет по себестоимости блюд");
	СписокОтчетов.Добавить("ОтчетПоУдалениям",		"Отчет по удалениям");
	СписокОтчетов.Добавить("АнализСтруктурыМеню",	"Анализ структуры меню");
	
	ЗаполнитьСписокОбработок(СписокОтчетов, Перечисления.ВидыОбработок.ВнешнийОтчет, "Справочник.Товары", Истина, Ложь);
	Возврат СписокОтчетов;
	
КонецФункции

// Строит отчет с предопределенными группировками.
//
Процедура СформироватьОтчет(ТипОтчета, ОбъектОтчета) Экспорт 
	
	Если ОбъектОтчета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Отчет = Отчеты[ТипОтчета].Создать();
	
	Отчет.КомпоновщикНастроек.ЗагрузитьНастройки(Отчет.СхемаКомпоновкиДанных.НастройкиПоУмолчанию);
	
	Отчет.ДатаС = ДобавитьМесяц(ТекущаяДата(), -1);
	Отчет.ДатаПо  = КонецДня(ТекущаяДата());
	Отчет.Период = ПредставлениеПериода(Отчет.ДатаС,Отчет.ДатаПо);
	
	// установим группировки НашаНоменклатура и НашаХарактеристика
	ТаблицаГруппировокСтроки = ФормированиеОтчетов.ПолучитьПустуюТаблицуНастроекОтчета("Группировки");
	
	НоваяСтрока = ТаблицаГруппировокСтроки.Добавить();
	НоваяСтрока.Поле           = "Товар";
	НоваяСтрока.ТипГруппировки = ТипГруппировкиКомпоновкиДанных.Элементы;
	
	// заполним отборы
	ТаблицаОтборов = ФормированиеОтчетов.ПолучитьПустуюТаблицуНастроекОтчета("Отбор");
	
	НоваяСтрока = ТаблицаОтборов.Добавить();
	Если НЕ ТипОтчета = "АнализСтруктурыМеню" Тогда
		НоваяСтрока.Поле         = "Товар";
	Иначе
		НоваяСтрока.Поле         = "Товары";
	КонецЕсли; 
	
	Если ОбъектОтчета.ЭтоГруппа Тогда
		НоваяСтрока.ВидСравнения = ВидСравненияКомпоновкиДанных.ВИерархии;
	Иначе
		НоваяСтрока.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	НоваяСтрока.Значение     = ОбъектОтчета.Ссылка;
	
	ФормированиеОтчетов.СформироватьОтчетПоПараметрам(Отчет, ТаблицаГруппировокСтроки, , ТаблицаОтборов);
	
КонецПроцедуры

#КонецЕсли

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, ТекстЗаполнения, СтандартнаяОбработка)
	Если ЭтоНовый() Тогда
		ГруппаПечати = Справочники.ГруппыПечати.НайтиПоНаименованию("Основная");
		Категория = Родитель.Категория;
		Если не ЭтоГруппа тогда
			ЕстьВПродаже = Истина;
			ВариантНаличияВПродаже = Перечисления.ВариантыНаличияВПродаже.Простой;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры