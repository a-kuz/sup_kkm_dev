﻿
Перем НастройкаДеревоКаталога Экспорт;    // дерево каталога
Перем ФормаКнопки;

////////////////////////////////////////////////////////////////////////////////
// ПРОЧИЕ ПРОЦЕДУРЫ

// Загрузка параметров настройки
//
Процедура ЗагрузитьПараметрыНастройки() Экспорт
	
	Перем ЗначениеПараметра;
	
	Если ФормаКнопки<>Неопределено И ФормаКнопки.Открыта() Тогда
		ФормаКнопки.Закрыть();
	КонецЕсли; 
	
	НастройкиОбъект = ТекущаяНастройка.ПолучитьОбъект();
	
	Если НастройкиОбъект = Неопределено Тогда
		ТекущаяНастройка = Неопределено;
		Возврат;
	КонецЕсли;	
	
	ПараметрыНастройки = НастройкиОбъект.ПолучитьСтруктуруПараметров();
	
	ПараметрыНастройки.Свойство("ДеревоКаталога", НастройкаДеревоКаталога);
	
	Регион = ТекущаяНастройка.Регион;
	МестоРеализации = ТекущаяНастройка.МестоРеализации;
	Для каждого Элемент Из ЭлементыФормы Цикл
		
		Если НЕ ЗначениеЗаполнено(Элемент.Данные) Тогда
			Продолжить;
		ИначеЕсли Элемент.Данные = "ТекущаяНастройка" Тогда
			Продолжить;
		КонецЕсли; 
		
		ПараметрыНастройки.Свойство(Элемент.Данные, ЗначениеПараметра);
		
		Элемент.Значение = Элемент.ТипЗначения.ПривестиЗначение( ЗначениеПараметра );
		
		// для элементов формы, значения которых выбираются из списка,
		// подставим значения по умолчанию равными первому значению из списка
		Если Элемент.Значение=Неопределено И Элемент.СписокВыбора.Количество()>0 Тогда
			Элемент.Значение = Элемент.СписокВыбора[0].Значение;
		КонецЕсли; 
		
	КонецЦикла; 
	
	Если ТипРМ.Пустая() Тогда
		ТипРМ = Перечисления.ТипыРМ.СтанцияОплаты;
	КонецЕсли;

	УстановитьПараметрыИнтерфейса();
	
	Модифицированность = Ложь;
	
КонецПроцедуры

// Формирование параметров настройки
//
// Параметры:
//	Параметр1	- описание
//
// Возвращаемое значение:
//	Тип.Вид		- описание
//
Функция СформироватьПараметрыНастройки()
	
	ПараметрыНастройки = Новый Структура;
	
	Если РучнаяНастройкаПривязок Тогда
		Если ФормаКнопки<>Неопределено И ФормаКнопки.Открыта() Тогда
			НастройкаДеревоКаталога = ФормаКнопки.ДеревоКаталога;
		КонецЕсли; 
		ПараметрыНастройки.Вставить("ДеревоКаталога", НастройкаДеревоКаталога);
	КонецЕсли;
	
	Для каждого Элемент Из ЭлементыФормы Цикл
		
		Если НЕ ЗначениеЗаполнено(Элемент.Данные) Тогда
			Продолжить;
		ИначеЕсли Элемент.Данные = "ТекущаяНастройка" Тогда
			Продолжить;
		КонецЕсли; 
		
		ПараметрыНастройки.Вставить(Элемент.Данные, Элемент.Значение);
		
	КонецЦикла; 
	
	Возврат ПараметрыНастройки;
КонецФункции

// Сохранение настройки
//
// Параметры:
//	Параметр1	- описание
//
// Возвращаемое значение:
//	Тип.Вид		- описание
//
Функция ЗаписатьНастройку(БезВопросов=Ложь)
	
	Если НЕ Модифицированность Тогда
		Возврат Истина;
	КонецЕсли; 
	
	Если БезВопросов Тогда
		Ответ = КодВозвратаДиалога.Да;
	Иначе
		Ответ = Вопрос("Записать текущую настройку?", РежимДиалогаВопрос.ДаНетОтмена);
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Отмена Тогда
		Возврат Ложь;
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Да Тогда
		Настройка = ТекущаяНастройка.ПолучитьОбъект();
		Настройка.КодВида	= ?(СпособОтображения = "Кнопки", "ЭкранМеню", "СписокМеню") + ?(ИнтерфейсТип=1, "КПК", "") ;
		Настройка.Параметры	= ЗначениеВСтрокуВнутр( СформироватьПараметрыНастройки() );
		Настройка.Регион = Регион;
		Настройка.МестоРеализации = МестоРеализации;
		Настройка.ИнформационнаяБаза = "";
		Настройка.Записать();
		Модифицированность = Ложь;
		
	Иначе
		ЗагрузитьПараметрыНастройки();
		
	КонецЕсли; 
	
	Возврат Истина;
КонецФункции

Процедура ЗагрузитьШаблон800х600()
	
	ОбщиеЗначенияШаблонов();
	
	СвободноеОкно = Ложь;
	
	Если СпособОтображения = "Кнопки" Тогда
		ШиринаОкна		= 800;
		ВысотаОкна		= 300;
		
		ШиринаКнопки	= 130;
		ВысотаКнопки	= 43;
		
	Иначе
		ШиринаОкна		= 470;
		ВысотаОкна		= 600;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьШаблон1024х768()
	
	ОбщиеЗначенияШаблонов();
	
	СвободноеОкно = Истина;
	
	Если СпособОтображения = "Кнопки" Тогда
		ШиринаОкна		= 812;
		ВысотаОкна		= 362;
		ШиринаКнопки	= 144;
		ВысотаКнопки	= 64;
	Иначе
		ШиринаОкна		= 400;
		ВысотаОкна		= 592;
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗагрузитьШаблон240х320()
	
	ОбщиеЗначенияШаблонов();
	
	ЭлементыФормы.ПоложениеОкна.Значение = "Центр";
	ИнтервалПоГоризонтали	= 0;
	ИнтервалПоВертикали		= 0;
	ШиринаОкна		= 240;
	ВысотаОкна		= 260;
	
	ШиринаКнопки	= 78;
	ВысотаКнопки	= 37;
	
	ШрифтКнопки			= Новый Шрифт("Arial", 7);
	
	КнопкиВыводКартинки	= Ложь;
	КнопкиВыводТекста	= Истина;
	КнопкиПоказЕдИзм	= Ложь;
	КнопкиПоказЦены		= Истина;
	
КонецПроцедуры

Процедура ЗагрузитьШаблон480х640()
	
	ОбщиеЗначенияШаблонов();
	
	ЭлементыФормы.ПоложениеОкна.Значение = "Центр";
	ШиринаОкна		= 480;
	ВысотаОкна		= 580;
	
	ШиринаКнопки	= 78;
	ВысотаКнопки	= 60;
	
	КнопкиВыводКартинки	= Ложь;
	КнопкиВыводТекста	= Истина;
	КнопкиПоказЕдИзм	= Ложь;
	КнопкиПоказЦены		= Истина;
	
КонецПроцедуры

// Общие значения шаблонов
//
// Параметры:
//	Параметр1	- описание параметра
//
Процедура ОбщиеЗначенияШаблонов()
	
	РеквизитСортировки	= "Наименование";
	
	Если СпособОтображения = "Кнопки" Тогда
		ЭлементыФормы.ПоложениеОкна.Значение = "Низ";
		ИнтервалПоГоризонтали	= 1;
		ИнтервалПоВертикали		= 1;
		
		ЦветФонаКнопки		= ЦветаСтиля.ЦветФонаКнопки;
		ЦветТекстаКнопки	= ЦветаСтиля.ЦветТекстаКнопки;
		ШрифтКнопки			= ШрифтыСтиля.ШрифтТекста;
		
		ЦветФонаКнопкиГруппы= ЦветаСтиля.ЦветФонаКнопки;
		ЦветТекстаКнопкиГруппы= ЦветаСтиля.ЦветТекстаКнопки;
		ШрифтКнопкиГруппы	= ШрифтыСтиля.ШрифтТекста;
		
		КнопкиВыводКартинки	= Истина;
		КнопкиРазмерКартинки= РазмерКартинки.АвтоРазмер;
		КнопкиВыводТекста	= Истина;
		КнопкиПоказЕдИзм	= Истина;
		КнопкиПоказЦены		= Истина;
		
		ЭлементыФормы.ПоложениеФиксГрупп.Значение = "Верх";
		КолвоРядовФиксГрупп = 1;
		ЭлементыФормы.РамкаФиксГрупп.Значение = ТипРамкиЭлементаУправления.Выпуклая;
		ЦветФонаФиксГрупп	= ЦветаСтиля.ЦветФонаКнопки;
	
	Иначе
		ЭлементыФормы.ПоложениеОкна.Значение = "Право";
	
		СписокПоказКода		= Ложь;
		СписокПоказЕдИзм	= Истина;
		СписокПоказЦены		= Истина;
		
		ШрифтСписка			= ШрифтыСтиля.Шрифт10ж;
		
	КонецЕсли; 
	
	Модифицированность = Истина;
	
КонецПроцедуры

// Очистить все значения раскладки
//
// Параметры:
//	Параметр1	- описание параметра
//
Процедура ОчиститьРаскладку()
	
	Если ФормаКнопки<>Неопределено И ФормаКнопки.Открыта() Тогда
		ФормаКнопки.Закрыть();
	КонецЕсли; 
	
	НастройкаДеревоКаталога = Неопределено;
	Модифицированность = Истина;
	
КонецПроцедуры

// Описание процедуры
//
Процедура УстановитьПараметрыИнтерфейса()
	
	КнопкиШаблона = ЭлементыФормы.КнопкаШаблон.Кнопки;
	КнопкиШаблона.Очистить();
	
	Если ИнтерфейсТип=0 Тогда
		
		ЭлементыФормы.ПоложениеОкна.Доступность = Истина;
		
		КнопкиШаблона.Добавить("Кнопка1", ТипКнопкиКоманднойПанели.Действие, "Для разрешения 800х600", Новый Действие("ЗагрузитьШаблон800х600") );
		КнопкиШаблона.Добавить("Кнопка2", ТипКнопкиКоманднойПанели.Действие, "Для разрешения 1024х768", Новый Действие("ЗагрузитьШаблон1024х768") );
		
	Иначе
		
		ЭлементыФормы.ПоложениеОкна.Значение = "Центр";
		ЭлементыФормы.ПоложениеОкна.Доступность = Ложь;
		
		КнопкиШаблона.Добавить("Кнопка1", ТипКнопкиКоманднойПанели.Действие, "Для разрешения 240х320", Новый Действие("ЗагрузитьШаблон240х320") );
		КнопкиШаблона.Добавить("Кнопка2", ТипКнопкиКоманднойПанели.Действие, "Для разрешения 480х640", Новый Действие("ЗагрузитьШаблон480х640") );
		
	КонецЕсли; 
	
КонецПроцедуры
 
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Отказ = НЕ ЗаписатьНастройку();
	
КонецПроцедуры

Процедура ОбновлениеОтображения()
	
	НастройкаВыбрана = ЗначениеЗаполнено( ТекущаяНастройка );
	
	ЭлементыФормы.КнопкаПереименовать	.Доступность = НастройкаВыбрана;
	ЭлементыФормы.КнопкаЗаписать		.Доступность = НастройкаВыбрана;
	ЭлементыФормы.КнопкаУдалить			.Доступность = НастройкаВыбрана;
	ЭлементыФормы.ПанельНастройки		.Доступность = НастройкаВыбрана;
	ЭлементыФормы.ОсновныеДействияФормы.Кнопки.ОК.Доступность = НастройкаВыбрана;
	
	ЭтоКнопочноеМеню = СпособОтображения = "Кнопки";
	ЭлементыФормы.ПанельНастройки.Страницы.Кнопки.Видимость				= ЭтоКнопочноеМеню;
	ЭлементыФормы.ПанельНастройки.Страницы.ФиксированныеГруппы.Видимость= ЭтоКнопочноеМеню;
	
	ЭлементыФормы.КнопкаПоказать		.Доступность = НастройкаВыбрана;
	ЭлементыФормы.КнопкаПоказать		.Заголовок	 = ?(ЭтоКнопочноеМеню И РучнаяНастройкаПривязок, "Просмотр / Настройка", "Просмотр");
	
	ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.ТекущаяСтраница;
	
	Если ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.Основное Тогда
		Если ЭтоКнопочноеМеню Тогда
			ЭлементыФормы.ПанельПараметрыОтображения.ТекущаяСтраница = ЭлементыФормы.ПанельПараметрыОтображения.Страницы.Кнопки;
			ЭлементыФормы.КнопкаОчиститьРаскладку.Видимость = РучнаяНастройкаПривязок;
			ЭлементыФормы.НадписьРазмерКартинки	.Видимость = КнопкиВыводКартинки;
			ЭлементыФормы.КнопкиРазмерКартинки	.Видимость = КнопкиВыводКартинки;
			ЭлементыФормы.КнопкиПоказЕдИзм		.Видимость = КнопкиВыводТекста;
			ЭлементыФормы.КнопкиПоказЦены		.Видимость = КнопкиВыводТекста;
		Иначе
			ЭлементыФормы.ПанельПараметрыОтображения.ТекущаяСтраница = ЭлементыФормы.ПанельПараметрыОтображения.Страницы.Список;
		КонецЕсли;
		
	ИначеЕсли ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.Окно Тогда
		Если ИнтерфейсТип=1 И СвободноеОкно Тогда
			СвободноеОкно = Ложь;
		КонецЕсли; 
		ЭлементыФормы.СвободноеОкно.Видимость = ИнтерфейсТип=0;
		
	ИначеЕсли ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.Кнопки Тогда
		ЭлементыФормы.НадписьЦветТекстаКнопки	.Видимость = КнопкиВыводТекста;
		ЭлементыФормы.НадписьШрифтКнопки		.Видимость = КнопкиВыводТекста;
		ЭлементыФормы.ЦветТекстаКнопки			.Видимость = КнопкиВыводТекста;
		ЭлементыФормы.ШрифтКнопки				.Видимость = КнопкиВыводТекста;
		
	ИначеЕсли ТекущаяСтраница = ЭлементыФормы.ПанельНастройки.Страницы.ФиксированныеГруппы Тогда
		ЭлементыФормы.НадписьПоложениеФиксГрупп	.Видимость = ФиксироватьГруппы;
		ЭлементыФормы.НадписьКолвоРядовФиксГрупп.Видимость = ФиксироватьГруппы;
		ЭлементыФормы.ПоложениеФиксГрупп		.Видимость = ФиксироватьГруппы;
		ЭлементыФормы.КолвоРядовФиксГрупп		.Видимость = ФиксироватьГруппы;
		ЭлементыФормы.ВыделениеФиксГрупп		.Видимость = ФиксироватьГруппы;
		ЭлементыФормы.НадписьРамкаФиксГрупп		.Видимость = ФиксироватьГруппы И ВыделениеФиксГрупп;
		ЭлементыФормы.НадписьЦветФонаФиксГрупп	.Видимость = ФиксироватьГруппы И ВыделениеФиксГрупп;
		ЭлементыФормы.РамкаФиксГрупп			.Видимость = ФиксироватьГруппы И ВыделениеФиксГрупп;
		ЭлементыФормы.ЦветФонаФиксГрупп			.Видимость = ФиксироватьГруппы И ВыделениеФиксГрупп;
		
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура ПанельНастройкиПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ОбновлениеОтображения();
КонецПроцедуры

Процедура ТекущаяНастройкаНачалоВыбора(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если НЕ ЗаписатьНастройку() Тогда
		Возврат;
	КонецЕсли;
	
	СписокВидов = Новый СписокЗначений;
	СписокВидов.Добавить("ЭкранМеню");
	СписокВидов.Добавить("ЭкранМенюКПК");
	СписокВидов.Добавить("СписокМеню");
	СписокВидов.Добавить("СписокМенюКПК");
	Если тоВыбратьИзСпискаТО(СписокВидов, ЭтаФорма, Элемент) <> Ложь Тогда
		ЗагрузитьПараметрыНастройки();
	КонецЕсли; 
	ПодключитьсяКвнешнемуИсточникуСупЦентр(Регион, Истина);
КонецПроцедуры

Процедура КнопкаНоваяНастройкаНажатие(Элемент)
	
	Если НЕ ЗаписатьНастройку() Тогда
		Возврат;
	КонецЕсли;
	
	НазваниеНастройки = "";
	Если НЕ ВвестиСтроку(НазваниеНастройки, "Название настройки") ИЛИ ПустаяСтрока(НазваниеНастройки) Тогда
		Возврат;
	КонецЕсли; 
	
	Настройка = Справочники.ТорговоеОборудование.СоздатьЭлемент();
	Настройка.УстановитьНовыйКод();
	Настройка.Наименование	= НазваниеНастройки;
	Настройка.КодВида		= "ЭкранМеню";
	Настройка.КодМодели		= "";
	Настройка.КодВерсии		= "";
	Настройка.ТипПрофиля	= 1;
	Настройка.ИмяОбработки	= "Обслуживание_АО";
	Настройка.Записать();
	
	ТекущаяНастройка = Настройка.Ссылка;
	ЗагрузитьПараметрыНастройки();
	
	КаталогТоваров = Справочники.КаталогиТоваров.Мяснов;
	ЗагрузитьШаблон1024х768();
	
	ЗаписатьНастройку(Истина);
	
КонецПроцедуры

Процедура КнопкаПоказатьНажатие(Элемент)
	
	Если ФормаКнопки<>Неопределено И ФормаКнопки.Открыта() Тогда
		ФормаКнопки.Закрыть();
	КонецЕсли; 
	
	Если ТекущаяНастройка.МестоРеализации = Справочники.МестаРеализации.Ресторан Тогда
		
		ИмяФормы = ПараметрыНастройки.СпособОтображения + ?(СвободноеОкно, "СвободноеОкноРесторан", глПараметрыРМ.ИнтерфейсТип);
		
	Иначе
		
		ИмяФормы = ПараметрыНастройки.СпособОтображения + ?(СвободноеОкно, "СвободноеОкно", глПараметрыРМ.ИнтерфейсТип);
		
	КонецЕсли;
	
	
	
	ФормаКнопки = ПолучитьФорму(ИмяФормы);
	ФормаКнопки.ВладелецФормы		= ЭтаФорма;
	ФормаКнопки.ЗакрыватьПриЗакрытииВладельца = Истина;
	
	ФормаКнопки.РежимНастройки		= Истина;
	ФормаКнопки.ТекущаяНастройка	= ТекущаяНастройка;
	ФормаКнопки.ПараметрыНастройки	= СформироватьПараметрыНастройки();
	
	ФормаКнопки.Открыть();
	
	
КонецПроцедуры

Процедура КнопкаПереименоватьНажатие(Элемент)
	
	НазваниеНастройки = ТекущаяНастройка.Наименование;
	Если НЕ ВвестиСтроку(НазваниеНастройки, "Название настройки") Тогда
		Возврат;
	КонецЕсли; 
	
	Настройка = ТекущаяНастройка.ПолучитьОбъект();
	Настройка.Наименование	= НазваниеНастройки;
	Настройка.Записать();
	
	ТекущаяНастройка = Настройка.Ссылка;
	
КонецПроцедуры

Процедура КнопкаЗаписатьНажатие(Элемент)
	
	Модифицированность = Истина;
	ЗаписатьНастройку(Истина);
	
КонецПроцедуры

Процедура КнопкаУдалитьНажатие(Элемент)
	
	Если Вопрос("Удалить текущую настройку?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.Отмена Тогда
		Возврат;
	КонецЕсли; 
	
	ТекущаяНастройка.ПолучитьОбъект().Удалить();
	ТекущаяНастройка = Неопределено;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

Процедура РучнаяНастройкаПривязокПриИзменении(Элемент)
	
	ОчиститьРаскладку();
	
КонецПроцедуры

Процедура КнопкаОчиститьРакладкуНажатие(Элемент)
	
	Если Вопрос("Очистить раскладку?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.ОК Тогда
		ОчиститьРаскладку();
	КонецЕсли; 
	
КонецПроцедуры

Процедура КнопкиВыводКартинкиПриИзменении(Элемент)
	
	Если НЕ КнопкиВыводКартинки И НЕ КнопкиВыводТекста Тогда
		КнопкиВыводТекста = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КнопкиВыводТекстаПриИзменении(Элемент)
	
	Если НЕ КнопкиВыводКартинки И НЕ КнопкиВыводТекста Тогда
		КнопкиВыводКартинки = Истина;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	Модифицированность = Истина;
	ЗаписатьНастройку(Истина);
	Закрыть();
	
КонецПроцедуры

Процедура ФиксироватьГруппыПриИзменении(Элемент)
	
	Если НЕ ( РучнаяНастройкаПривязок И ЗначениеЗаполнено(НастройкаДеревоКаталога) ) Тогда
		Возврат;
	КонецЕсли; 
	
	Если Вопрос("При изменении этой настройки раскладка будет очищена!
				|Продолжить?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.ОК Тогда
		ОчиститьРаскладку();
	Иначе
		ФиксироватьГруппы = НЕ ФиксироватьГруппы;
	КонецЕсли; 
	
КонецПроцедуры

Процедура КнопкиРазмерКартинкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ПоложениеОкнаОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ПоложениеФиксГруппОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура РамкаФиксГруппОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура КаталогТоваровОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура КаталогТоваровОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если (ВыбранноеЗначение = КаталогТоваров) ИЛИ НЕ ( РучнаяНастройкаПривязок И ЗначениеЗаполнено(НастройкаДеревоКаталога) ) Тогда
		Возврат;
	КонецЕсли; 
	
	//Если Вопрос("При изменении этой настройки раскладка будет очищена!
	//	|Продолжить?", РежимДиалогаВопрос.ОКОтмена) = КодВозвратаДиалога.ОК Тогда
	//	ОчиститьРаскладку();
	//Иначе
	//	СтандартнаяОбработка = Ложь;
	//КонецЕсли; 
	
КонецПроцедуры

Процедура РеквизитСортировкиОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ИнтерфейсТипПриИзменении(Элемент)
	
	УстановитьПараметрыИнтерфейса();
	
КонецПроцедуры

Процедура СпособОтображенияОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

Процедура ПриОткрытии()
	ПодключитьсяКвнешнемуИсточникуСупЦентр(Регион);	
КонецПроцедуры

Процедура РегионПриИзменении(Элемент)
	ПодключитьсяКвнешнемуИсточникуСупЦентр(Регион, Истина);
КонецПроцедуры

Процедура КнопкаПоказать1Нажатие(Элемент)
//ЭлементыФормы.КнопкаПоказать1.
КонецПроцедуры

Процедура КоманднаяПанель1Повар(Кнопка)
		Если ФормаКнопки<>Неопределено И ФормаКнопки.Открыта() Тогда
		ФормаКнопки.Закрыть();
	КонецЕсли; 
	
	ИмяФормы ="КнопкиСвободноеОкноРесторанПовар";	
	
	
	ФормаКнопки = ПолучитьФорму(ИмяФормы);
	ФормаКнопки.ВладелецФормы		= ЭтаФорма;
	ФормаКнопки.ЗакрыватьПриЗакрытииВладельца = Истина;
	
	ФормаКнопки.РежимНастройки		= Истина;
	ФормаКнопки.ТекущаяНастройка	= ТекущаяНастройка;
	ФормаКнопки.ПараметрыНастройки	= СформироватьПараметрыНастройки();
	
	ФормаКнопки.Открыть();

КонецПроцедуры

Процедура КоманднаяПанель1СтанцияОплаты(Кнопка)
		Если ФормаКнопки<>Неопределено И ФормаКнопки.Открыта() Тогда
		ФормаКнопки.Закрыть();
	КонецЕсли; 
	
	ИмяФормы ="КнопкиСвободноеОкноРесторан";	
	
	
	ФормаКнопки = ПолучитьФорму(ИмяФормы);
	ФормаКнопки.ВладелецФормы		= ЭтаФорма;
	ФормаКнопки.ЗакрыватьПриЗакрытииВладельца = Истина;
	
	ФормаКнопки.РежимНастройки		= Истина;
	ФормаКнопки.ТекущаяНастройка	= ТекущаяНастройка;
	ФормаКнопки.ПараметрыНастройки	= СформироватьПараметрыНастройки();
	
	ФормаКнопки.Открыть();

КонецПроцедуры




////////////////////////////////////////////////////////////////////////////////
// ТЕЛО МОДУЛЯ

СписокВыбора = ЭлементыФормы.СпособОтображения.СписокВыбора;
СписокВыбора.Добавить("Кнопки", "Кнопочное меню");
СписокВыбора.Добавить("Список", "Иерархический список");

СписокВыбора = ЭлементыФормы.РеквизитСортировки.СписокВыбора;
СписокВыбора.Добавить("Наименование");
СписокВыбора.Добавить("Код");
СписокВыбора.Добавить("Порядок","Произвольный порядок");

СписокВыбора = ЭлементыФормы.КнопкиРазмерКартинки.СписокВыбора;
СписокВыбора.Добавить(РазмерКартинки.АвтоРазмер);
СписокВыбора.Добавить(РазмерКартинки.Пропорционально);
СписокВыбора.Добавить(РазмерКартинки.Растянуть);
СписокВыбора.Добавить(РазмерКартинки.РеальныйРазмер);

СписокВыбора = ЭлементыФормы.ПоложениеОкна.СписокВыбора;
СписокВыбора.Добавить("Низ"		, "Прижать вниз");
СписокВыбора.Добавить("Право"	, "Прижать вправо");
СписокВыбора.Добавить("Центр"	, "По центру");

СписокВыбора = ЭлементыФормы.ПоложениеФиксГрупп.СписокВыбора;
СписокВыбора.Добавить("Верх"	, "Сверху");
СписокВыбора.Добавить("Лево"	, "Слева");
СписокВыбора.Добавить("Право"	, "Справа");
СписокВыбора.Добавить("Низ"		, "Снизу");

СписокВыбора = ЭлементыФормы.РамкаФиксГрупп.СписокВыбора;
СписокВыбора.Добавить(ТипРамкиЭлементаУправления.Выпуклая);
СписокВыбора.Добавить(ТипРамкиЭлементаУправления.Вдавленная);
СписокВыбора.Добавить(ТипРамкиЭлементаУправления.Одинарная);

