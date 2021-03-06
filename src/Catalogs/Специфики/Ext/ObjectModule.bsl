﻿
Процедура ПередЗаписью(Отказ)
	
	
	Если ЭтотОбъект.ЭтоНовый() И ЭтотОбъект.Код = 0 Тогда
		ЭтотОбъект.УстановитьНовыйКод();
	КонецЕсли;		
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
		Если НЕ ЭтоГруппа Тогда
		Если ВариантНаличияВПродаже.Пустая() Тогда
			ВариантНаличияВПродаже = Перечисления.ВариантыНаличияВПродаже.Простой;
		КонецЕсли; 
		ЕстьВПродаже = ОпределитьТекущееНаличиеВПродаже(ЭтотОбъект, Истина);
	КонецЕсли;

	
	Если Не ЗначениеЗаполнено(Наименование) Тогда
		Сообщить("Не заполнено наименование!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;	
	
	Если Не ЭтоГруппа Тогда
		Если ЗначениеЗаполнено(Номенклатура) И КоэфПересчета=0 Тогда
			Сообщить("Не заполнен коэф. пересчета!", СтатусСообщения.Важное);
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;	
	ИзменитьПорядокЭлементов(Отказ);	
КонецПроцедуры

Процедура ИзменитьПорядокЭлементов(Отказ)
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	Если (НЕ ЗначениеЗаполнено(Порядок) ИЛИ ЭтоНовый()) Тогда
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		|	Специфики.Порядок КАК Порядок
		|ИЗ
		|	Справочник.Специфики КАК Специфики
		|ГДЕ
		|	Специфики.Родитель = &Родитель
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок УБЫВ");
		
		Запрос.УстановитьПараметр("Родитель", Родитель);
		Выборка = Запрос.Выполнить().Выбрать();
		Порядок = ?(Выборка.Следующий(), Выборка.Порядок + 1, 1);
		
	ИначеЕсли Родитель <> Ссылка.Родитель Тогда // необходимо установить новый порядок
		
		Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
		|	Специфики.Порядок КАК Порядок
		|ИЗ
		|	Справочник.Специфики КАК Специфики
		|ГДЕ
		|	Специфики.Родитель = &Родитель
		|	И ВЫБОР
		|			КОГДА &ЭтоГруппа
		|				ТОГДА Специфики.ЭтоГруппа = ИСТИНА
		|			ИНАЧЕ ИСТИНА
		|		КОНЕЦ
		|
		|УПОРЯДОЧИТЬ ПО
		|	Порядок УБЫВ");
		
		Запрос.УстановитьПараметр("Родитель", Родитель);
		Запрос.УстановитьПараметр("ЭтоГруппа", ЭтоГруппа);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Порядок = Выборка.Порядок + 1;
		КонецЕсли;
		
		Если ЭтоГруппа Тогда
			
			// Увеличим нумерацию у следующих элементов
			Запрос = Новый Запрос("ВЫБРАТЬ
			|	Специфики.Ссылка
			|ИЗ
			|	Справочник.Специфики КАК Специфики
			|ГДЕ
			|	Специфики.Родитель = &Родитель
			|	И Специфики.ЭтоГруппа = ЛОЖЬ
			|
			|УПОРЯДОЧИТЬ ПО
			|	Специфики.Порядок");
			
			Запрос.УстановитьПараметр("Родитель", Родитель);
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
		|	Специфики.Ссылка
		|ИЗ
		|	Справочник.Специфики КАК Специфики
		|ГДЕ
		|	Специфики.Родитель = &Родитель
		|	И Специфики.Порядок > &Порядок
		|
		|УПОРЯДОЧИТЬ ПО
		|	Специфики.Порядок");
		
		Запрос.УстановитьПараметр("Родитель", Ссылка.Родитель);
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
