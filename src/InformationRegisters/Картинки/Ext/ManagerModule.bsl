﻿
// Добавляет новую запись регистра
// Объект, ТипКартинки - измерения регистра
// ДанныеИзображения - данные содержащие изображения, поддерживаемые значения:
//					   ссылка на файл картинки, файл картинки, картинка, двоичные данные, хранилище значения с картинкой, спр. хранилище доп. информации.
// Обновлять - если передается Истина, то ДанныеИзображения будет передано в существующее значение хранилища доп. информации в записи регистра.  
//             в противном случае (Ложь) будет создана новый элемент справочника "хранилище доп. информации"
// Возвращаемое значение - ссылка на хранилище изображения (справочник), в который добавлена картинка
Функция ДобавитьИзображение(Объект, ТипКартинки, ДанныеИзображения, Обновлять = Ложь) Экспорт
	
	НачатьТранзакцию();
	
	ХранилищеИзображения = Неопределено;
	
	// Если требуется обновить значение хранилища доп. информации, то отыскиваем его в записях регистра
	Если Обновлять Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		               |	Картинки.ХранилищеИзображения
		               |ИЗ
		               |	РегистрСведений.Картинки КАК Картинки
		               |ГДЕ
		               |	Картинки.Объект = &Объект
		               |	И Картинки.ТипКартинки = &ТипКартинки";
		Запрос.УстановитьПараметр("Объект", Объект);
		Запрос.УстановитьПараметр("ТипКартинки", ТипКартинки);
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда
			// Если нашли, то запоминаем ссылку на прежнее значение хранилища доп. информации
			ХранилищеИзображения = Выборка.ХранилищеИзображения;
		КонецЕсли;
	КонецЕсли;
	
	ТипЗначенияИзображения = ТипЗнч(ДанныеИзображения);
	
	// Проверяем тип значения параметра "ДанныеИзображения"
	Если ТипЗначенияИзображения = Тип("Строка") ИЛИ 
		 ТипЗначенияИзображения = Тип("Файл") ИЛИ 
		 ТипЗначенияИзображения = Тип("ДвоичныеДанные") ИЛИ 
		 ТипЗначенияИзображения = Тип("Картинка") ИЛИ 
		 ТипЗначенияИзображения = Тип("ХранилищеЗначения") Тогда
		// Если ссылка на хранилище доп. информации пустая, то создаем новое хранилище на основании данных изображения
		Если ХранилищеИзображения = Неопределено Тогда
			ХранилищеИзображения = Справочники.ХранилищеДополнительнойИнформации.СоздатьПоИзображению(ДанныеИзображения).Ссылка;
		Иначе
			// Если ссылка на хринилище доп. информации не пустая, то просто обновляем там хранилище значения на основании данных изображения
			ХранилищеИзображения.ПолучитьОбъект().ОбновитьИзображение(ДанныеИзображения);
		КонецЕсли;
		
	// Если в качестве данных изображения уже передали ссылку на хранилище доп. информации, То просто передаем её в запись регистра
	ИначеЕсли ТипЗначенияИзображения = Тип("СправочникСсылка.ХранилищеДополнительнойИнформации") Тогда
		ХранилищеИзображения = ДанныеИзображения;
	КонецЕсли;
	
	// Создаем запись регистра
	НоваяЗапись = РегистрыСведений.Картинки.СоздатьМенеджерЗаписи();
	НоваяЗапись.Объект = Объект;
	НоваяЗапись.ТипКартинки = ТипКартинки;
	НоваяЗапись.ХранилищеИзображения = ХранилищеИзображения;
	НоваяЗапись.URLСсылка = "";
	НоваяЗапись.ДатаДобавления = ТекущаяДата();
	НоваяЗапись.Записать(Истина);
	
	Если ТранзакцияАктивна() Тогда
		ЗафиксироватьТранзакцию();
	КонецЕсли;
	
	Возврат ХранилищеИзображения;
	
КонецФункции

// Функция выполняет обновление записи регистра по измерениям "Объект" и "ТипКартинки"
// Обновляется значение ресурса "URLСсылка"
// Функция возвращает ИСТИНА, если запись регистра была обновлена и 
// ЛОЖЬ если запись регистра не была обновлена
Функция УстановитьURLСсылку(Объект, ТипКартинки, URLСсылка) Экспорт
	
	РезультатУстановкиURLСсылки = Ложь;
	
	// Запросом отыскиваем существующую запись по измерениям
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	Картинки.ХранилищеИзображения,
	               |	Картинки.ДатаДобавления
	               |ИЗ
	               |	РегистрСведений.Картинки КАК Картинки
	               |ГДЕ
	               |	Картинки.Объект = &Объект
	               |	И Картинки.ТипКартинки = &ТипКартинки";
	Запрос.УстановитьПараметр("Объект", Объект);
	Запрос.УстановитьПараметр("ТипКартинки", ТипКартинки);
	Выборка = Запрос.Выполнить().Выбрать();
	
	// Если есть запись регистра, то обновляем её
	Если Выборка.Следующий() Тогда
		НоваяЗапись = РегистрыСведений.Картинки.СоздатьМенеджерЗаписи();
		НоваяЗапись.Объект = Объект;
		НоваяЗапись.ТипКартинки = ТипКартинки;
		НоваяЗапись.ХранилищеИзображения = Выборка.ХранилищеИзображения;
		НоваяЗапись.URLСсылка = URLСсылка;
		НоваяЗапись.ДатаДобавления = Выборка.ДатаДобавления;
		НоваяЗапись.Записать(Истина);
		
		РезультатУстановкиURLСсылки = Истина;
	КонецЕсли;
	
	Возврат РезультатУстановкиURLСсылки;
	
КонецФункции
