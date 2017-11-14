﻿//ирПортативный Перем ирПортативный Экспорт;
//ирПортативный Перем ирОбщий Экспорт;
//ирПортативный Перем ирСервер Экспорт;
//ирПортативный Перем ирКэш Экспорт;
//ирПортативный Перем ирПривилегированный Экспорт;

Перем мСтруктураПоискаВДереве;
Перем мТекущийИндексНайденнойСтроки;

Процедура ПриОткрытии()
	
	ЭтаФорма.РежимПодсистемы = КлючУникальности = "ВсеИнструменты";
	Если РежимПодсистемы Тогда
		ЭтаФорма.Заголовок = "Структура всех инструментов (ИР)";
	КонецЕсли; 
	ОбновитьДерево();
	Если ПараметрЭлементФормы = Неопределено Тогда
		Если Форма <> Неопределено Тогда
			ПараметрЭлементФормы = Форма.ТекущийЭлемент;
			Если ТипЗнч(ПараметрЭлементФормы) = Тип("ТабличноеПоле") Тогда
				Если ПараметрЭлементФормы.ТекущаяКолонка <> Неопределено Тогда
					ПараметрЭлементФормы = ПараметрЭлементФормы.ТекущаяКолонка;
				КонецЕсли; 
			ИначеЕсли ТипЗнч(ПараметрЭлементФормы) = Тип("Панель") Тогда
				Если ПараметрЭлементФормы.ТекущаяСтраница <> Неопределено Тогда
					ПараметрЭлементФормы = ПараметрЭлементФормы.ТекущаяСтраница;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
	Если ПараметрЭлементФормы <> Неопределено Тогда
		СтрокаЭлементаФормы = Дерево.Строки.Найти(ПараметрЭлементФормы, "ЭлементФормы", Истина);
		Если СтрокаЭлементаФормы <> Неопределено Тогда
			ЭлементыФормы.Дерево.ТекущаяСтрока = СтрокаЭлементаФормы;
			ЭлементыФормы.Дерево.Развернуть(СтрокаЭлементаФормы);
		КонецЕсли; 
	КонецЕсли; 
	ПодключитьОбработчикОжидания("ИндикацияТекущегоЭлемента", 0.2, Истина);
	
КонецПроцедуры

Функция ПолучитьПервогоРодителяПоТипу(Знач СтрокаДерева, Тип)
	
	Пока СтрокаДерева.Родитель <> Неопределено Цикл 
		СтрокаДерева = СтрокаДерева.Родитель;
		Если СтрокаДерева.Тип = Тип Тогда 
			Прервать;
		КонецЕсли; 
	КонецЦикла; 
	Возврат СтрокаДерева;
	
КонецФункции

Функция ПолучитьПоследнегоРодителяПоТипу(Знач СтрокаДерева, Тип)
	
	Пока Истина
		И СтрокаДерева.Родитель <> Неопределено 
		И СтрокаДерева.Родитель.Тип = Тип
	Цикл
		СтрокаДерева = СтрокаДерева.Родитель;
	КонецЦикла; 
	Возврат СтрокаДерева;
	
КонецФункции

Процедура ИндикацияТекущегоЭлемента()
	
	ТекущаяСтрока = ЭлементыФормы.Дерево.ТекущаяСтрока;
	Если ТекущаяСтрока = Неопределено Тогда
		Перейти ~Конец;
	КонецЕсли; 
	Если РежимПодсистемы Тогда
		Форма = Неопределено;
		СтрокаФормы = ТекущаяСтрока;
		ОсновнойЛ = Ложь;
		Пока СтрокаФормы.Родитель <> Неопределено Цикл
			Если СтрокаФормы.Основной Тогда 
				Если СтрокаФормы.ЭлементФормы.Открыта() Тогда
					Форма = СтрокаФормы.ЭлементФормы;
				КонецЕсли; 
				Если ТекущаяСтрока = СтрокаФормы Тогда
					Перейти ~Конец;
				КонецЕсли; 
				Прервать;
			КонецЕсли; 
			СтрокаФормы = СтрокаФормы.Родитель;
		КонецЦикла;
	КонецЕсли; 
	Если Форма = Неопределено Тогда
		Перейти ~Конец;
	КонецЕсли; 
	Попытка
		ТекущаяСтрока.Видимость = ТекущаяСтрока.ЭлементФормы.Видимость;
	Исключение
	КонецПопытки; 
	Попытка
		ТекущаяСтрока.Доступность = ТекущаяСтрока.ЭлементФормы.Доступность;
	Исключение
	КонецПопытки; 
	Если ТекущаяСтрока.Тип = Тип("КнопкаКоманднойПанели") Тогда
		СтрокаДереваКоманднойПанели = ПолучитьПервогоРодителяПоТипу(ТекущаяСтрока, Тип("КоманднаяПанель"));
		ПоказатьВложенныйЭлементФормы(СтрокаДереваКоманднойПанели);
		СтрокаВерхнегоПодменю = ПолучитьПоследнегоРодителяПоТипу(ТекущаяСтрока, Тип("КнопкаКоманднойПанели"));
		ЭлементФормы = СтрокаВерхнегоПодменю.ЭлементФормы;
		Маркер = "<<<<!>>>>";
		Если Найти(ЭлементФормы.Текст, Маркер) = 1 Тогда
			ВосстановитьСтарыеСвойстваЭлементаФормы(СтрокаВерхнегоПодменю); 
		Иначе
			СохранитьСтарыеСвойстваЭлементаФормы(СтрокаВерхнегоПодменю, "Текст, Пометка, Отображение");
			ЭлементФормы.Текст = Маркер;
			ЭлементФормы.Пометка = Не ЭлементФормы.Пометка;
			ЭлементФормы.Отображение = ОтображениеКнопкиКоманднойПанели.Надпись;
		КонецЕсли; 
	ИначеЕсли ТекущаяСтрока.Тип = Тип("КолонкаТабличногоПоля") Тогда
		СтрокаДереваТабличногоПоля = ПолучитьПервогоРодителяПоТипу(ТекущаяСтрока, Тип("ТабличноеПоле"));
		Форма.ТекущийЭлемент = СтрокаДереваТабличногоПоля.ЭлементФормы;
		Если ТекущаяСтрока.Видимость Тогда
			СтрокаДереваТабличногоПоля.ЭлементФормы.ТекущаяКолонка = ТекущаяСтрока.ЭлементФормы;
			Колонка = ТекущаяСтрока.ЭлементФормы;
			Маркер = ПолучитьЦветИндикации();
			Если Колонка.ЦветФонаПоля = Маркер Тогда
				ВосстановитьСтарыеСвойстваЭлементаФормы(ТекущаяСтрока); 
			Иначе
				СохранитьСтарыеСвойстваЭлементаФормы(ТекущаяСтрока, "ЦветФонаПоля, ЦветФонаШапки");
				Колонка.ЦветФонаПоля = Маркер;
				Колонка.ЦветФонаШапки = Маркер;
			КонецЕсли; 
		КонецЕсли; 
	ИначеЕсли ТекущаяСтрока.Тип = Тип("СтраницаПанели") Тогда
		СтрокаДереваПанели = ПолучитьПервогоРодителяПоТипу(ТекущаяСтрока, Тип("Панель"));
		Форма.ТекущийЭлемент = СтрокаДереваПанели.ЭлементФормы;
		Если ТекущаяСтрока.Видимость Тогда
			СтрокаДереваПанели.ЭлементФормы.ТекущаяСтраница = ТекущаяСтрока.ЭлементФормы;
			ЭлементФормы = ТекущаяСтрока.ЭлементФормы;
			Маркер = "<<<<!>>>>";
			Если Найти(ЭлементФормы.Заголовок, Маркер) = 1 Тогда
				ВосстановитьСтарыеСвойстваЭлементаФормы(ТекущаяСтрока); 
			Иначе
				СохранитьСтарыеСвойстваЭлементаФормы(ТекущаяСтрока, "Заголовок");
				ЭлементФормы.Заголовок = Маркер;
			КонецЕсли; 
		КонецЕсли; 
	Иначе
		Если ТекущаяСтрока.Видимость Тогда
			Форма.ТекущийЭлемент = ТекущаяСтрока.ЭлементФормы;
			Если Форма.ТекущийЭлемент <> ТекущаяСтрока.ЭлементФормы Тогда
				ПоказатьВложенныйЭлементФормы(ТекущаяСтрока);
			КонецЕсли; 
			ЭлементФормы = ТекущаяСтрока.ЭлементФормы;
			ИмяСвойства = "ЦветРамки";
			Если Ложь
				Или ТекущаяСтрока.Тип = Тип("Надпись")
				Или ТекущаяСтрока.Тип = Тип("Флажок")
				Или ТекущаяСтрока.Тип = Тип("КоманднаяПанель")
				//Или ТекущаяСтрока.Тип = Тип("ПолеВвода")
				//Или ТекущаяСтрока.Тип = Тип("ПолеВыбора")
			Тогда
				ИмяСвойства = "ЦветФона";
			КонецЕсли; 
			Маркер = ПолучитьЦветИндикации();
			Если ЭлементФормы[ИмяСвойства] = Маркер Тогда
				ВосстановитьСтарыеСвойстваЭлементаФормы(ТекущаяСтрока); 
			Иначе
				СохранитьСтарыеСвойстваЭлементаФормы(ТекущаяСтрока, ИмяСвойства);
				ЭлементФормы[ИмяСвойства] = Маркер;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли; 
~Конец: 
	ПодключитьОбработчикОжидания("ИндикацияТекущегоЭлемента", 0.5, Истина);
	
КонецПроцедуры

Процедура ПоказатьВложенныйЭлементФормы(Знач ТекущаяСтрока)
	
	Если Истина
		И ТекущаяСтрока.Родитель <> Неопределено 
		И ТекущаяСтрока.Родитель.Родитель <> Неопределено 
		И ТекущаяСтрока.Родитель.Родитель.Тип = Тип("Панель")
	Тогда
		Форма.ТекущийЭлемент = ТекущаяСтрока.Родитель.Родитель.ЭлементФормы;
		ТекущаяСтрока.Родитель.Родитель.ЭлементФормы.ТекущаяСтраница = ТекущаяСтрока.Родитель.ЭлементФормы;
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьЦветИндикации()
	
	Возврат Новый Цвет(255, 1, 1);

КонецФункции

Процедура СохранитьСтарыеСвойстваЭлементаФормы(Знач ТекущаяСтрока, СтрокаСвойств)
	
	СтарыеСвойства = Новый Структура(СтрокаСвойств);
	ЗаполнитьЗначенияСвойств(СтарыеСвойства, ТекущаяСтрока.ЭлементФормы);
	ТекущаяСтрока.СтарыеСвойства = СтарыеСвойства;

КонецПроцедуры

Процедура ВосстановитьСтарыеСвойстваЭлементаФормы(Знач ТекущаяСтрока)
	
	Если ТекущаяСтрока.СтарыеСвойства <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ТекущаяСтрока.ЭлементФормы, ТекущаяСтрока.СтарыеСвойства);
		ТекущаяСтрока.СтарыеСвойства = Неопределено;
	КонецЕсли; 

КонецПроцедуры

Процедура ОбновитьДерево()
	
	//СтарыеКоординаты = ПолучитьКоординаты();
	Если Не РежимПодсистемы Тогда
		Дерево.Строки.Очистить();
		Если Форма <> Неопределено Тогда
			ДобавитьОписаниеФормы(Форма, Дерево);
		КонецЕсли; 
		СортироватьСтроки(Дерево);
	Иначе
		ирПлатформа = ирКэш.Получить();
		#Если Сервер И Не Сервер Тогда
			ирПлатформа = Обработки.ирПлатформа.Создать();
		#КонецЕсли
		СписокИнструментов = ирПлатформа.ПолучитьМакет("СписокИнструментов");
		СписокИнструментов = ирОбщий.ПолучитьТаблицуИзТабличногоДокументаЛкс(СписокИнструментов,,,, Истина);
		Индикатор2 = ирОбщий.ПолучитьИндикаторПроцессаЛкс(СписокИнструментов.Количество());
		Для Каждого СтрокаИнструмента Из СписокИнструментов Цикл
			ирОбщий.ОбработатьИндикаторЛкс(Индикатор2);
			КорневойТип = ирОбщий.ПолучитьПервыйФрагментЛкс(СтрокаИнструмента.ПолноеИмя);
			Если Истина
				И КорневойТип <> "Обработка"
				И КорневойТип <> "Отчет"
			Тогда
				Продолжить;
			КонецЕсли; 
			Объект = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс(СтрокаИнструмента.ПолноеИмя);
			МетаОбъект = Объект.Метаданные();
			Если Дерево.Строки.Найти(МетаОбъект.ПолноеИмя(), "Имя") <> Неопределено Тогда
				Продолжить;
			КонецЕсли; 
			Попытка
				МетаФормы = МетаОбъект.Формы;
			Исключение
				Продолжить;
			КонецПопытки;
			СтрокаДереваОбъекта = Неопределено;
			//МенеджерОбъектаМетаданных = ирОбщий.ПолучитьМенеджерЛкс(МетаОбъект);
			МенеджерОбъектаМетаданных = ирОбщий.ПолучитьОбъектПоПолномуИмениМетаданныхЛкс(МетаОбъект.ПолноеИмя());
			Индикатор3 = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МетаФормы.Количество(), "Формы");
			Для Каждого МетаФорма Из МетаФормы Цикл
				ирОбщий.ОбработатьИндикаторЛкс(Индикатор3);
				ПолноеИмяФормы = МетаФорма.ПолноеИмя();
				Попытка
					ФормаЛ = МенеджерОбъектаМетаданных.ПолучитьФорму(МетаФорма.Имя,,Новый УникальныйИдентификатор());
				Исключение
					Сообщить("Ошибка при получении формы " + ПолноеИмяФормы + ": " + ОписаниеОшибки(), СтатусСообщения.ОченьВажное);
					Продолжить;
				КонецПопытки;
				Если ТипЗнч(ФормаЛ) = Тип("Форма") Тогда
					Если СтрокаДереваОбъекта = Неопределено Тогда
						СтрокаДереваОбъекта = Дерево.Строки.Добавить();
						СтрокаДереваОбъекта.Текст = МетаОбъект.Представление();
						СтрокаДереваОбъекта.Имя = МетаОбъект.ПолноеИмя();
						СтрокаДереваОбъекта.Видимость = Истина;
						СтрокаДереваОбъекта.Доступность = Истина;
						СтрокаДереваОбъекта.ПредставлениеТипа = "Объект";
						Если ЗначениеЗаполнено(СтрокаИнструмента.ИмяКартинки) Тогда
							СтрокаДереваОбъекта.Картинка = ирОбщий.ПолучитьОбщуюКартинкуЛкс(СтрокаИнструмента.ИмяКартинки);
						КонецЕсли; 
					КонецЕсли; 
					СтрокаДереваФормы = СтрокаДереваОбъекта.Строки.Добавить();
					СтрокаДереваФормы.Текст = МетаФорма.Представление();
					СтрокаДереваФормы.Имя = МетаФорма.ПолноеИмя();
					СтрокаДереваФормы.Видимость = Истина;
					СтрокаДереваФормы.Доступность = Истина;
					СтрокаДереваФормы.ПредставлениеТипа = "Форма";
					СтрокаДереваФормы.Картинка = ФормаЛ.КартинкаЗаголовка;
					СтрокаДереваФормы.ЭлементФормы = ФормаЛ;
					ДобавитьОписаниеФормы(ФормаЛ, СтрокаДереваФормы);
					Если МетаОбъект.ОсновнаяФорма = МетаФорма Тогда 
						СтрокаДереваФормы.Основной = Истина;
						СтрокаДереваФормы.Текст = СтрокаДереваФормы.Текст + " (Основная)";
					КонецЕсли; 
				КонецЕсли; 
			КонецЦикла;
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЦикла;
		ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
	КонецЕсли; 
	
КонецПроцедуры

Процедура ДобавитьОписаниеФормы(Форма, КорневаяСтрокаФормы)
	
	Если Форма = Неопределено Тогда
		Возврат;
	КонецЕсли; 
	СтрокаФормы = ЗначениеВСтрокуВнутр(Форма);
	XMLСтрокаФормы = ирОбщий.СтрокаВнутрВХМЛТелоЛкс(СтрокаФормы);
	ЧтениеXML = Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(XMLСтрокаФормы);
	ПостроительDOM = Новый ПостроительDOM;
	ДокументDOM = ПостроительDOM.Прочитать(ЧтениеXML);
	
	РазыменовательПИ = Новый РазыменовательПространствИменDOM(ДокументDOM);
	СтрокаXPath = "/elem/elem/elem[1]/elem[2]/elem[2]";
	РезультатXPath = ДокументDOM.ВычислитьВыражениеXPath(СтрокаXPath, ДокументDOM, РазыменовательПИ, ТипРезультатаDOMXPath.НеупорядоченныйИтераторУзлов);
	Узел = РезультатXPath.ПолучитьСледующий();
	СтрокаДЗ = КорневаяСтрокаФормы.Строки.Добавить();
	СтрокаДЗ.ЭлементФормы = Форма.Панель;
	КорневойЭлемент = Форма.Панель;
	Если КорневойЭлемент.Страницы.Количество() = 1 Тогда
		КорневойЭлемент = КорневойЭлемент.Страницы[0];
	Иначе
		ЗаполнитьСтрокуЭлементаФормы(СтрокаДЗ);
	КонецЕсли; 
	Если Узел <> Неопределено Тогда
		ОбойтиУзелДереваЭлементовФормы(КорневаяСтрокаФормы, Форма, Узел, СтрокаДЗ, КорневойЭлемент);
		Если КорневойЭлемент <> Неопределено Тогда
			КорневаяСтрокаФормы.Строки.Удалить(КорневаяСтрокаФормы.Строки.Найти(Форма.Панель, "ЭлементФормы"));
		КонецЕсли; 
	КонецЕсли;

КонецПроцедуры

Процедура СортироватьСтроки(СтрокаДерева)
	Если Ложь
		Или СтрокаДерева = Дерево
		Или СтрокаДерева.Тип = Тип("СтраницаПанели")
	Тогда
		СтрокаДерева.Строки.Сортировать("Тип,Текст");
	КонецЕсли; 
	Для Каждого ДочерняяСтрока Из СтрокаДерева.Строки Цикл
		СортироватьСтроки(ДочерняяСтрока);
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьСтрокуЭлементаФормы(СтрокаДерева, Роль = "")
	
	ЭлементФормы = СтрокаДерева.ЭлементФормы;
	СтрокаДерева.Тип = ТипЗнч(ЭлементФормы);
	СтрокаДерева.ПредставлениеТипа = "" + СтрокаДерева.Тип;
	ЗаполнитьЗначенияСвойств(СтрокаДерева, ЭлементФормы);
	Свертка = ирОбщий.БезопасноПолучитьЗначениеСвойстваЛкс(ЭлементФормы, "Свертка");
	Если СтрокаДерева.Видимость И Свертка <> Неопределено И Свертка <> РежимСверткиЭлементаУправления.Нет Тогда
		СтрокаДерева.Видимость = Ложь;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(СтрокаДерева.Имя) Тогда
		СтрокаДерева.Имя = "" + ТипЗнч(ЭлементФормы);
	КонецЕсли; 
	Если ТипЗнч(ЭлементФормы) = Тип("Панель") Тогда
		ИмяКоллекции = "Страницы";
		ИмяСвойстваЗаголовка = "Заголовок";
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле") Тогда
		ИмяКоллекции = "Колонки";
		ИмяСвойстваЗаголовка = "ТекстШапки";
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("КоманднаяПанель") Тогда
		ИмяКоллекции = "Кнопки";
		ИмяСвойстваЗаголовка = "Текст";
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("КолонкаТабличногоПоля") Тогда
		ИмяСвойстваЗаголовка = "ТекстШапки";
		СтрокаДерева.Подсказка = ЭлементФормы.ПодсказкаВШапке;
	ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("КнопкаКоманднойПанели") Тогда
		ИмяСвойстваЗаголовка = "Текст";
		СтрокаДерева.Видимость = Истина;
	Иначе
		ИмяСвойстваЗаголовка = "Заголовок";
	КонецЕсли; 
	Если ЗначениеЗаполнено(ИмяКоллекции) Тогда
		ЗаголовокЭлемента = "";
		СчетчикНепустых = 0;
		Индекс = 0;
		Пока Индекс < ЭлементФормы[ИмяКоллекции].Количество() Цикл
			ЭлементКоллекции = ЭлементФормы[ИмяКоллекции][Индекс];
			ЗаголовокВложенного = ЭлементКоллекции[ИмяСвойстваЗаголовка];
			Индекс = Индекс + 1;
			Если Ложь
				Или Не ЗначениеЗаполнено(ЗаголовокВложенного) 
				Или (Истина
					И ИмяКоллекции = "Кнопки"
					И ЭлементКоллекции.Имя = "СтруктураКоманднойПанели")
			Тогда
				Продолжить;
			КонецЕсли; 
			Если ЗаголовокЭлемента <> "" Тогда
				ЗаголовокЭлемента = ЗаголовокЭлемента + ", ";
			КонецЕсли; 
			ЗаголовокЭлемента = ЗаголовокЭлемента + ЗаголовокВложенного;
			СчетчикНепустых = СчетчикНепустых + 1;
			Если СчетчикНепустых = 5 Тогда
				Прервать;
			КонецЕсли; 
		КонецЦикла;
	Иначе
		ЗаголовокЭлемента = ирОбщий.БезопасноПолучитьЗначениеСвойстваЛкс(ЭлементФормы, ИмяСвойстваЗаголовка);
	КонецЕсли; 
	Если ЗначениеЗаполнено(СтрокаДерева.ПредставлениеСочетаниеКлавиш) Тогда
		ЗаголовокЭлемента = ЗаголовокЭлемента + " (" + СтрокаДерева.ПредставлениеСочетаниеКлавиш + ")";
	КонецЕсли; 
	СтрокаДерева.Текст = ЗаголовокЭлемента;
	Если ЗначениеЗаполнено(Роль) Тогда
		СтрокаДерева.Текст = "[" + Роль + "] " + СтрокаДерева.Текст;
	КонецЕсли; 
	Если Не ЗначениеЗаполнено(СтрокаДерева.Текст) Тогда
		СтрокаДерева.Текст = "<" + СтрокаДерева.Имя + ">";
	КонецЕсли; 
	Если СтрокаДерева.Подсказка = СтрокаДерева.Текст Тогда
		СтрокаДерева.Подсказка = "";
	КонецЕсли; 
	Если СтрокаДерева.СочетаниеКлавиш <> Неопределено Тогда
		ПредставлениеСочетаниеКлавиш = ирОбщий.ПолучитьПреставлениеСочетанияКлавишЛкс(СтрокаДерева.СочетаниеКлавиш);
		Если Не ирОбщий.СтрокиРавныЛкс(ПредставлениеСочетаниеКлавиш, "Нет") Тогда
			СтрокаДерева.ПредставлениеСочетаниеКлавиш = ПредставлениеСочетаниеКлавиш;
		КонецЕсли; 
	КонецЕсли; 

КонецПроцедуры

Процедура ОбойтиУзелДереваЭлементовФормы(КорневаяСтрокаФормы, Форма, Узел, СтрокаДЗ, КорневойЭлемент = Неопределено)
	
	Для каждого УзелЭлементаФормы Из Узел.ДочерниеУзлы Цикл
		Если УзелЭлементаФормы.ИмяУзла = "data" Тогда 
			Если ТипЗнч(СтрокаДЗ.ЭлементФормы) = Тип("Панель") Тогда
				Для каждого Страница Из СтрокаДЗ.ЭлементФормы.Страницы Цикл
					Если КорневойЭлемент = Неопределено Тогда
						//Если Не ПоказыватьНевидимые И Не Страница.Видимость Тогда
						//	Продолжить;
						//КонецЕсли; 
						СтрокаСтраница = СтрокаДЗ.Строки.Добавить();
						СтрокаСтраница.ЭлементФормы = Страница;
						ЗаполнитьСтрокуЭлементаФормы(СтрокаСтраница);
					КонецЕсли; 
					Если Страница = КорневойЭлемент Тогда
						Прервать;
					КонецЕсли; 
				КонецЦикла;
			Иначе
				// У формы обработки ирЗагрузкаТабличныхДанных сюда попало поле табличного документа ТабличныйДокумент
			КонецЕсли; 
		Иначе
			СвойстваЭлФормы = УзелЭлементаФормы.ДочерниеУзлы;
			Если ТипЗнч(УзелЭлементаФормы.ПоследнийДочерний) = Тип("ТекстDOM") Тогда
				УзелЭлементаФормы.УдалитьДочерний(УзелЭлементаФормы.ПоследнийДочерний);
			КонецЕсли; 
			ЭтоПанель = СвойстваЭлФормы[СвойстваЭлФормы.Количество() - 1].ТекстовоеСодержимое <> "0";
			СвойстваЭлФормыСИменем = СвойстваЭлФормы[СвойстваЭлФормы.Количество() - 2].ДочерниеУзлы;
			СвойстваЭлФормыСИндексом = СвойстваЭлФормы[СвойстваЭлФормы.Количество() - 3].ДочерниеУзлы;
			ИндексСтраницы = Число(СвойстваЭлФормыСИндексом[СвойстваЭлФормыСИндексом.Количество() - 5].ТекстовоеСодержимое);
			ЭлементФормы = Форма.ЭлементыФормы[СтрЗаменить(СвойстваЭлФормыСИменем[1].ТекстовоеСодержимое, """", "")];
			Если Ложь
				Или ТипЗнч(ЭлементФормы) = Тип("Разделитель")
				Или ТипЗнч(ЭлементФормы) = Тип("РамкаГруппы")
				Или ирОбщий.БезопасноПолучитьЗначениеСвойстваЛкс(ЭлементФормы, "Видимость") = Ложь 
			Тогда
				Продолжить;
			КонецЕсли; 
			Если КорневойЭлемент = Неопределено Тогда
				СтрокаРодителя = СтрокаДЗ.Строки[ИндексСтраницы];
			Иначе
				СтрокаРодителя = КорневаяСтрокаФормы;
			КонецЕсли; 
			НовСтрокаДЗ = СтрокаРодителя.Строки.Добавить();
			НовСтрокаДЗ.ЭлементФормы = ЭлементФормы;
			ЗаполнитьСтрокуЭлементаФормы(НовСтрокаДЗ);
			Если ЭтоПанель Тогда
				ОбойтиУзелДереваЭлементовФормы(КорневаяСтрокаФормы, Форма, СвойстваЭлФормы[СвойстваЭлФормы.Количество() - 1], НовСтрокаДЗ);
			КонецЕсли;
			Если НовСтрокаДЗ <> СтрокаДЗ Тогда
				Если ТипЗнч(ЭлементФормы) = Тип("КоманднаяПанель") Тогда
					ЗаполнитьСтрокиИзКнопок(ЭлементФормы.Кнопки, НовСтрокаДЗ.Строки);
				ИначеЕсли ТипЗнч(ЭлементФормы) = Тип("ТабличноеПоле") Тогда
					Если ТипЗнч(ЭлементФормы.Значение) <> Тип("ОтборКомпоновкиДанных") Тогда
						Для Каждого КолонкаТабличногоПоля Из ЭлементФормы.Колонки Цикл
							//Если Не ПоказыватьНевидимые И Не КолонкаТабличногоПоля.Видимость Тогда
							//	Продолжить;
							//КонецЕсли; 
							СтрокаКолонки = НовСтрокаДЗ.Строки.Добавить();
							СтрокаКолонки.ЭлементФормы = КолонкаТабличногоПоля;
							ЗаполнитьСтрокуЭлементаФормы(СтрокаКолонки);
						КонецЦикла;
					КонецЕсли; 
				КонецЕсли; 
				КонтекстноеМеню = ирОбщий.БезопасноПолучитьЗначениеСвойстваЛкс(ЭлементФормы, "КонтекстноеМеню");
				Если КонтекстноеМеню <> Неопределено И КонтекстноеМеню.Кнопки.Количество() > 0 Тогда
					СтрокаКонтекстногоМеню = НовСтрокаДЗ.Строки.Добавить();
					СтрокаКонтекстногоМеню.ЭлементФормы = КонтекстноеМеню;
					ЗаполнитьСтрокуЭлементаФормы(СтрокаКонтекстногоМеню);
					СтрокаКонтекстногоМеню.Текст = "[Контекстное меню] " + СтрокаКонтекстногоМеню.Текст;
					ЗаполнитьСтрокиИзКнопок(КонтекстноеМеню.Кнопки, СтрокаКонтекстногоМеню.Строки);
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьСтрокиИзКнопок(Кнопки, СтрокиДерева)
	
	Для Каждого Кнопка Из Кнопки Цикл
		Если Ложь
			Или Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Разделитель 
			//Или Кнопка.Имя = "СтруктураКоманднойПанели"
		Тогда
			Продолжить;
		КонецЕсли; 
		СтрокаДерева = СтрокиДерева.Добавить();
		СтрокаДерева.ЭлементФормы = Кнопка;
		ЗаполнитьЗначенияСвойств(СтрокаДерева, Кнопка); 
		Если СтрокаДерева.Подсказка = СтрокаДерева.Текст Тогда
			СтрокаДерева.Подсказка = "";
		КонецЕсли; 
		ПредставлениеСочетаниеКлавиш = ирОбщий.ПолучитьПреставлениеСочетанияКлавишЛкс(СтрокаДерева.СочетаниеКлавиш);
		Если Не ирОбщий.СтрокиРавныЛкс(ПредставлениеСочетаниеКлавиш, "Нет") Тогда
			СтрокаДерева.ПредставлениеСочетаниеКлавиш = ПредставлениеСочетаниеКлавиш;
		КонецЕсли; 
		ЗаполнитьСтрокуЭлементаФормы(СтрокаДерева);
		Если Кнопка.ТипКнопки = ТипКнопкиКоманднойПанели.Подменю Тогда
			ЗаполнитьСтрокиИзКнопок(Кнопка.Кнопки, СтрокаДерева.Строки);
		КонецЕсли; 
	КонецЦикла;

КонецПроцедуры

Процедура ДеревоПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	Если ДанныеСтроки.Картинка <> Неопределено Тогда
		Картинка = ДанныеСтроки.Картинка;
	КонецЕсли; 
	Если Ложь
		Или Картинка = Неопределено
		Или Картинка.Вид = ВидКартинки.Пустая
	Тогда 
		СтруктураТипа = ирКэш.Получить().ПолучитьСтруктуруТипаИзКонкретногоТипа(ДанныеСтроки.Тип);
		Картинка = ирОбщий.ПолучитьКартинкуКорневогоТипаЛкс(СтруктураТипа.ИмяОбщегоТипа);
	КонецЕсли; 
	ОформлениеСтроки.Ячейки.Текст.УстановитьКартинку(Картинка);
	Если Не ДанныеСтроки.Видимость Тогда
		ОформлениеСтроки.ЦветТекста = Новый Цвет(100, 100, 100);
	ИначеЕсли Не ДанныеСтроки.Доступность Тогда
		ОформлениеСтроки.ЦветТекста = Новый Цвет(50, 50, 50);
	КонецЕсли; 
	ирОбщий.ОформитьСтрокуВТабличномПолеДереваСПоискомЛкс(Элемент, ОформлениеСтроки, ДанныеСтроки, мСтруктураПоискаВДереве);
	
КонецПроцедуры

Процедура ПриЗакрытии()
	
	ВосстановитьСвойстваЭлементовФормы();
	
КонецПроцедуры

Процедура ДеревоПриАктивизацииСтроки(Элемент)
	
	ВосстановитьСвойстваЭлементовФормы();
	ЭтаФорма.ПутьВДереве = ирОбщий.ПолучитьСтрокуПутиВДеревеЛкс(Элемент.ТекущаяСтрока, "Текст",, " \ ");
	
КонецПроцедуры

Процедура ВосстановитьСвойстваЭлементовФормы()
	
	ВсеСтрокиДерева = ирОбщий.ПолучитьВсеСтрокиДереваЗначенийЛкс(Дерево);
	Для Каждого СтрокаДерева Из ВсеСтрокиДерева Цикл
		ВосстановитьСтарыеСвойстваЭлементаФормы(СтрокаДерева); 
	КонецЦикла;
	
КонецПроцедуры

Процедура СтрокаПоискаПриИзменении(Элемент)
	
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ирОбщий.ПрименитьСтрокуПоискаКТабличномуПолюДереваЛкс(ЭлементыФормы.Дерево, СтрокаПоиска, "Текст, Подсказка", мСтруктураПоискаВДереве);
	
КонецПроцедуры

Процедура СтрокаПоискаНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);
	
КонецПроцедуры

Процедура ВпередНажатие(Элемент)
	
	ирОбщий.СледующееВхождениеСтрокиПоискаВТабличномПолеДереваЛкс(ЭлементыФормы.Дерево, мСтруктураПоискаВДереве);
	
КонецПроцедуры

Процедура НазадНажатие(Элемент)
	
	ирОбщий.ПредыдущееВхождениеСтрокиПоискаВТабличномПолеДереваЛкс(ЭлементыФормы.Дерево, мСтруктураПоискаВДереве);

КонецПроцедуры

Процедура КоманднаяПанельДереваСвернутьОстальные(Кнопка)
	
	ирОбщий.ТабличноеПолеДеревоЗначений_СвернутьВсеСтрокиЛкс(ЭлементыФормы.Дерево, Истина);
	
КонецПроцедуры

Процедура ДеревоВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если РежимПодсистемы Тогда
		СтандартнаяОбработка = Ложь;
		СтрокаОбъекта = ВыбраннаяСтрока;
		Пока СтрокаОбъекта.Родитель <> Неопределено Цикл
			СтрокаОбъекта = СтрокаОбъекта.Родитель;
		КонецЦикла;
		СтрокаОсновнойФормы = СтрокаОбъекта.Строки.Найти(Истина, "Основной");
		Если СтрокаОсновнойФормы <> Неопределено Тогда 
			Форма = СтрокаОсновнойФормы.ЭлементФормы;
			Если Не Форма.Открыта() Тогда
				Форма.Открыть();
			КонецЕсли; 
		КонецЕсли;
	КонецЕсли; 
	Если Форма <> Неопределено Тогда
		Форма.Активизировать();
	КонецЕсли; 
	Активизировать();
	
КонецПроцедуры

//ирПортативный #Если Клиент Тогда
//ирПортативный Контейнер = Новый Структура();
//ирПортативный Оповестить("ирПолучитьБазовуюФорму", Контейнер);
//ирПортативный Если Не Контейнер.Свойство("ирПортативный", ирПортативный) Тогда
//ирПортативный 	ПолноеИмяФайлаБазовогоМодуля = ирОбщий.ВосстановитьЗначениеЛкс("ирПолноеИмяФайлаОсновногоМодуля");
//ирПортативный 	ирПортативный = ВнешниеОбработки.ПолучитьФорму(ПолноеИмяФайлаБазовогоМодуля);
//ирПортативный КонецЕсли; 
//ирПортативный ирОбщий = ирПортативный.ПолучитьОбщийМодульЛкс("ирОбщий");
//ирПортативный ирКэш = ирПортативный.ПолучитьОбщийМодульЛкс("ирКэш");
//ирПортативный ирСервер = ирПортативный.ПолучитьОбщийМодульЛкс("ирСервер");
//ирПортативный ирПривилегированный = ирПортативный.ПолучитьОбщийМодульЛкс("ирПривилегированный");
//ирПортативный #КонецЕсли

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.СтруктураФормы");
Дерево.Колонки.Добавить("Картинка");
Дерево.Колонки.Добавить("СтарыеСвойства");
Дерево.Колонки.Добавить("Тип");
Дерево.Колонки.Добавить("Основной", Новый ОписаниеТипов("Булево"));
Дерево.Колонки.Добавить("СочетаниеКлавиш");
Дерево.Колонки.Добавить("ЭлементФормы");
