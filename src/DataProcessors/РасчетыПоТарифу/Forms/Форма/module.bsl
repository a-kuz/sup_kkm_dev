﻿
Перем ПараметрыОкна Экспорт;	// структура, определяет положение и размеры окна

Перем СтрокаЗаказа Экспорт;		// ссылка на строку заказа с тарифицируемой позицией
Перем ТаблицаУдалений Экспорт;	// ссылка на таблицу удалений обработки Заказ
Перем РежимПросмотра Экспорт;	// если Истина, то только просмотр 

Перем Тариф, Дискретность, МинВремя;
Перем МаксВремя,МаксСумма;
Перем ФлагИзменениеВремени;

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ МОДУЛЯ

Процедура ПриИзмененииВремени()
	
	Если МаксСумма>0 Тогда
		
		РассчитатьПоТарифуПоСумме(Тариф, ТаблицаРасчетов, Время1, Время2, МаксСумма);
		// ограничение по сумме может не выполниться из-за минимального времени
		Если ТаблицаРасчетов.Итог("Сумма") > МаксСумма Тогда
			МаксСумма = ТаблицаРасчетов.Итог("Сумма");
		КонецЕсли;
		
	Иначе
		
		РассчитатьПоТарифу(Тариф, ТаблицаРасчетов, Время1, Время2, МаксВремя );
		
	КонецЕсли;
	
	Если МаксСумма=0 И МаксВремя=0 Тогда
		ФлагИзменениеВремени = Истина;
		
	ИначеЕсли ЗначениеЗаполнено(СтрокаЗаказа.РасчетыПоТарифу) Тогда
		// если в заказе уже был установлены какие-то границы, то надо будет установить новые,
		// иначе ограничение применится при печати марок
		ФлагИзменениеВремени = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ИзменитьВремя(ИсхВремя, Сдвиг, ДопВремя=Неопределено)
	
	Если НЕ ЗначениеЗаполнено(ИсхВремя) Тогда
		ИсхВремя = НачалоМинуты(ТекущаяДата());
	КонецЕсли;
	
	ИсхВремя = ИсхВремя + Сдвиг*60;
	
	Если ЗначениеЗаполнено(ДопВремя) Тогда
		ДопВремя = ДопВремя + Сдвиг*60;
	КонецЕсли;
	
	ПриИзмененииВремени();
	
КонецПроцедуры

Процедура ИзменитьМаксВремя(ЗнакСдвига)
	
	Если ЗнакСдвига=-1 И МаксВремя=0 Тогда
		Возврат;
	КонецЕсли;
	
	МаксСумма = 0;
	МаксВремя = МаксВремя + ЗнакСдвига*Дискретность;
	
	Если ЗнакСдвига=1 И МаксВремя<МинВремя Тогда
		МаксВремя = МинВремя;
		
	ИначеЕсли ЗнакСдвига=-1 И МаксВремя<МинВремя Тогда
		МаксВремя = 0;
		
	КонецЕсли;
	
	Время2 = Неопределено;
	
	ПриИзмененииВремени();
	
КонецПроцедуры

Процедура ВыбратьВремя(ИсхВремя)
	
	Время = ИнтерфейсРМ.ВводВремени( "Время тарификации:", ИсхВремя);
	
	Если Время=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	ИсхВремя = Время;
	
	ПриИзмененииВремени();
	
КонецПроцедуры

Процедура УбратьОграничения()
	
	МаксСумма = 0;
	МаксВремя = 0;
	Время2 = Неопределено;
	
	ТаблицаРасчетов.Очистить();
	
КонецПроцедуры

Функция ПроверкаУменьшения()
	
	УдаляемоеКолво = СтрокаЗаказа.Количество - ТаблицаРасчетов.Итог("Количество");
	
	Если УдаляемоеКолво<=0 Тогда
		Возврат Истина;
	КонецЕсли;
	
	// выбор причины
	ВыбПричина = ИнтерфейсРМ.ВыборПричиныОтказа(Перечисления.ТипыПричинУдалений.Удаление);
	Если ВыбПричина=Неопределено Тогда
		Возврат Ложь;
	КонецЕсли;
	
	СтрокаЗаказа.Статус			= Перечисления.СтатусыПозицийЗаказа.Удалено;
	СтрокаЗаказа.Количество		= СтрокаЗаказа.Количество	 - УдаляемоеКолво;
	СтрокаЗаказа.Удалено		= СтрокаЗаказа.Удалено		 + УдаляемоеКолВо;
	СтрокаЗаказа.УдаленоСейчас	= СтрокаЗаказа.УдаленоСейчас + УдаляемоеКолВо;
	
	//данные для документа "Удаление"
	Удаление = ТаблицаУдалений.Строки.Добавить();
	Удаление.Товар			= СтрокаЗаказа.Товар;
	Удаление.Количество		= УдаляемоеКолво;
	Удаление.Причина		= ВыбПричина;
	Удаление.ГруппаПечати	= СтрокаЗаказа.Товар.ГруппаПечати;
	Удаление.Сумма			= УдаляемоеКолво * СтрокаЗаказа.Цена;
	
	Для каждого СтрокаСпецифики Из СтрокаЗаказа.Строки Цикл
		СтрокаСпецифики.Статус			= Перечисления.СтатусыПозицийЗаказа.Удалено;
		СтрокаСпецифики.УдаленоСейчас	= СтрокаЗаказа.УдаленоСейчас;
		//данные для документа "Удаление"
		УдалениеСпецифик = Удаление.Строки.Добавить();
		УдалениеСпецифик.Товар			= СтрокаСпецифики.Товар;
	КонецЦикла;
	
	ИнтерфейсРМ.ЗаписьСобытия(Справочники.События.ЗаказУдалениеЗаказаннойПозиции, Заказ, СтрокаЗаказа.Товар.Код, СтрокаЗаказа.Товар.Наименование, УдаляемоеКолво, ВыбПричина);
	
	Возврат Истина;
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Время1		= Неопределено;
	Время2		= Неопределено;
	
	Тариф		= СтрокаЗаказа.Тариф;
	Дискретность= Число(Тариф.Дискретность.Код);
	МинВремя	= Число(Тариф.МинВремя.Код);
	
	МаксВремя	= СтрокаЗаказа.МаксВремя;
	МаксСумма	= СтрокаЗаказа.МаксСумма;
	
	ФлагИзменениеВремени = Ложь;
	
	ТаблицаРасчетов.Загрузить( СтрокаЗаказа.РасчетыПоТарифу );
	
	Если ТаблицаРасчетов.Количество() = 0 Тогда
		Если ЗначениеЗаполнено(МаксВремя) Тогда
			РассчитатьПоТарифу(Тариф, ТаблицаРасчетов, Время1, Время2, МаксВремя );
			
		ИначеЕсли ЗначениеЗаполнено(МаксСумма) Тогда
			РассчитатьПоТарифуПоСумме(Тариф, ТаблицаРасчетов, Время1, Время2, МаксСумма);
			
		Иначе
			Время1 = НачалоМинуты(ТекущаяДата());
			
		КонецЕсли;
		
	Иначе
		Время1 = ТаблицаРасчетов[0].Время1;
		Время2 = ТаблицаРасчетов[ТаблицаРасчетов.Количество()-1].Время2;
		
		Если СтрокаЗаказа.Статус = Перечисления.СтатусыПозицийЗаказа.ТарифВкл И 
			Время1<=ТекущаяДата() И Время2<ТекущаяДата() Тогда
			// если процесс еще не остановлен, время начала уже наступило а текущее время больше предыдущего расчета,
			// то рассчитываем по текущему времени
			Время2 = НачалоМинуты(ТекущаяДата());
			ПриИзмененииВремени();
		КонецЕсли;
		
	КонецЕсли;
	
	Заголовок = СтрокаЗаказа.Наименование+" Тариф: "+Тариф.Наименование;
	
	Если РежимПросмотра Тогда
		ЭлементыФормы.Дата1				.Доступность = Ложь;
		ЭлементыФормы.КнопкаДата1Вперед	.Доступность = Ложь;
		ЭлементыФормы.КнопкаДата1Назад	.Доступность = Ложь;
		ЭлементыФормы.Время1			.Доступность = Ложь;
		ЭлементыФормы.КнопкаВремя1Вперед.Доступность = Ложь;
		ЭлементыФормы.КнопкаВремя1Назад	.Доступность = Ложь;
		ЭлементыФормы.КнопкаВремя1Выбрать.Доступность = Ложь;
		
		ЭлементыФормы.КнопкаОграничениеВремяВперед	.Доступность = Ложь;
		ЭлементыФормы.КнопкаОграничениеВремяНазад	.Доступность = Ложь;
		ЭлементыФормы.КнопкаОграничениеВремяВыбрать	.Доступность = Ложь;
		ЭлементыФормы.КнопкаОграничениеСуммаВыбрать	.Доступность = Ложь;
		ЭлементыФормы.КнопкаОграничениеСуммаОчистить.Доступность = Ложь;
	КонецЕсли;
	
	Если СтрокаЗаказа.Статус = Перечисления.СтатусыПозицийЗаказа.ТарифВкл Тогда
		ЭлементыФормы.КнопкаОК.Заголовок = "Остановить";
	Иначе
		ЭлементыФормы.КнопкаОК.Заголовок = "ОК";
	КонецЕсли;
	
	КолонкиРасчетов = ЭлементыФормы.ТаблицаРасчетов.Колонки;
	Если Тариф.ПоказыватьДаты Тогда
		КолонкиРасчетов.Время1.Формат = "ДФ=дд.ММ.гг,ЧЧ:мм";
		КолонкиРасчетов.Время2.Формат = "ДФ=дд.ММ.гг,ЧЧ:мм";
		КолонкиРасчетов.Время1.Ширина = 20;
		КолонкиРасчетов.Время2.Ширина = 20;
	Иначе
		КолонкиРасчетов.Время1.Формат = "ДФ=ЧЧ:мм";
		КолонкиРасчетов.Время2.Формат = "ДФ=ЧЧ:мм";
		КолонкиРасчетов.Время1.Ширина = 10;
		КолонкиРасчетов.Время2.Ширина = 10;
	КонецЕсли;
	
	КолонкиРасчетов.Цена.ТекстШапки = "Цена за "+Тариф.ВремяЦены;
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	ИнтерфейсРМ.ПриОткрытииОкна(ЭтаФорма);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ИнтерфейсРМ.ПриЗакрытииОкна();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	глОтсечкаПростоя();
	
	ЭлементыФормы.тОграничениеВремя.Заголовок = ?(МаксВремя=0, "нет", ВремяСтрокой(МаксВремя) );
	ЭлементыФормы.тОграничениеСумма.Заголовок = ?(МаксСумма=0, "нет", ФорматСумм(МаксСумма) );
	
	ЭлементыФормы.тИтого.Заголовок = "Итого: " + ВремяСтрокой(ТаблицаРасчетов.Итог("КолвоМинут")) +
	", сумма: " + ФорматСумм(ТаблицаРасчетов.Итог("Сумма"));
	
	// доступность
	Флаг2 = НЕ РежимПросмотра И МаксСумма=0 И МаксВремя=0;
	
	ЭлементыФормы.Дата2				.Доступность = Флаг2;
	ЭлементыФормы.КнопкаДата2Вперед	.Доступность = Флаг2;
	ЭлементыФормы.КнопкаДата2Назад	.Доступность = Флаг2;
	ЭлементыФормы.Время2			.Доступность = Флаг2;
	ЭлементыФормы.КнопкаВремя2Вперед.Доступность = Флаг2;
	ЭлементыФормы.КнопкаВремя2Назад	.Доступность = Флаг2;
	ЭлементыФормы.КнопкаВремя2Выбрать.Доступность = Флаг2;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КнопкаОКНажатие(Элемент)
	
	Если РежимПросмотра Тогда
		Закрыть();
		Возврат;
	КонецЕсли; 
	
	Если СтрокаЗаказа.Статус = Перечисления.СтатусыПозицийЗаказа.ТарифВкл Тогда
		
		Если НЕ ЗначениеЗаполнено(Время2) И ТекущаяДата()<Время1 Тогда
			
			Текст1="Внимание!";
			Текст2="Время начала тарификации еще не наступило!
			|Остановить?";
			Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос",Текст1,Текст2,"ОК","","Esc=Отмена") = "Отмена" Тогда
				Возврат;
			КонецЕсли;
			
			ТаблицаРасчетов[0].Время2 = НачалоМинуты(ТекущаяДата());
			ФлагИзменениеВремени = Истина;
			
		ИначеЕсли НЕ ФлагИзменениеВремени Тогда
			Время2 = НачалоМинуты(ТекущаяДата());
			ПриИзмененииВремени();
			
		КонецЕсли;
		
		СтрокаЗаказа.Статус = Перечисления.СтатусыПозицийЗаказа.Заказано;
		
	ИначеЕсли СтрокаЗаказа.Статус = Перечисления.СтатусыПозицийЗаказа.Заказано Тогда
		Если НЕ ПроверкаУменьшения() Тогда
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
	СтрокаЗаказа.МаксВремя = МаксВремя;
	СтрокаЗаказа.МаксСумма = МаксСумма;
	
	Если ФлагИзменениеВремени Тогда
		СтрокаЗаказа.ФлагИзменениеВремени = Истина;
		СтрокаЗаказа.РасчетыПоТарифу = ТаблицаРасчетов.Выгрузить();
	КонецЕсли;
	
	Закрыть("ОК");
	
КонецПроцедуры

Процедура Дата1ПриИзменении(Элемент)
	
	ПриИзмененииВремени();
	
КонецПроцедуры

Процедура КнопкаДата1НазадНажатие(Элемент)
	
	ИзменитьВремя( Время1, -24*60, Время2);
	
КонецПроцедуры

Процедура КнопкаДата1ВпередНажатие(Элемент)
	
	ИзменитьВремя( Время1, 24*60, Время2);
	
КонецПроцедуры

Процедура КнопкаДата2НазадНажатие(Элемент)
	
	ИзменитьВремя( Время2, -24*60);
	
КонецПроцедуры

Процедура КнопкаДата2ВпередНажатие(Элемент)
	
	ИзменитьВремя( Время2, 24*60);
	
КонецПроцедуры

Процедура КнопкаВремя1НазадНажатие(Элемент)
	
	ИзменитьВремя( Время1, -1, Время2);
	
КонецПроцедуры

Процедура КнопкаВремя1ВпередНажатие(Элемент)
	
	ИзменитьВремя( Время1, 1, Время2);
	
КонецПроцедуры

Процедура КнопкаВремя2НазадНажатие(Элемент)
	
	ИзменитьВремя( Время2, -Дискретность);
	
КонецПроцедуры

Процедура КнопкаВремя2ВпередНажатие(Элемент)
	
	ИзменитьВремя( Время2, Дискретность);
	
КонецПроцедуры

Процедура КнопкаВремя1ВыбратьНажатие(Элемент)
	
	ВыбратьВремя(Время1);
	
КонецПроцедуры

Процедура КнопкаВремя2ВыбратьНажатие(Элемент)
	
	ВыбратьВремя(Время2);
	
КонецПроцедуры

Процедура КнопкаОграничениеВремяНазадНажатие(Элемент)
	
	ИзменитьМаксВремя( -1 );
	
КонецПроцедуры

Процедура КнопкаОграничениеВремяВпередНажатие(Элемент)
	
	ИзменитьМаксВремя( 1 );
	
КонецПроцедуры

Процедура КнопкаОграничениеВремяВыбратьНажатие(Элемент)
	
	КолвоМинут = ИнтерфейсРМ.ВводВремени("Ограничение по времени:", МаксВремя);
	
	Если КолвоМинут=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если КолвоМинут=0 Тогда
		Если МаксВремя>0 Тогда
			УбратьОграничения();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	МаксВремя = КолвоМинут;
	МаксСумма = 0;
	
	Если МаксВремя%Дискретность<>0 Тогда
		МаксВремя = ОкруглитьЧисло( МаксВремя/Дискретность, Тариф.ПравилоОкругления) * Дискретность;
	КонецЕсли;
	Если МаксВремя<МинВремя Тогда
		МаксВремя = МинВремя;  
	КонецЕсли;
	
	Время2 = Неопределено;
	ПриИзмененииВремени();
	
КонецПроцедуры

Процедура КнопкаОграничениеСуммаВыбратьНажатие(Элемент)
	
	Сумма = ИнтерфейсРМ.ВводЧисла("Ограничение по сумме:", "Число", 10, 0, МаксСумма);
	
	Если Сумма=Неопределено Тогда
		Возврат;
	КонецЕсли; 
	
	Если Сумма=0 Тогда
		Если МаксСумма>0 Тогда
			УбратьОграничения();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	МаксСумма = Сумма;
	МаксВремя = 0;
	
	ПриИзмененииВремени();
	
КонецПроцедуры

Процедура КнопкаОграничениеСуммаОчиститьНажатие(Элемент)
	
	УбратьОграничения();
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

ПараметрыОкна = Новый Структура("Центр, Лево, Верх, Ширина, Высота", Истина);
