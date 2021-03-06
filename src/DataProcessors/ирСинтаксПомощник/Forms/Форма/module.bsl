﻿Перем мПлатформа;
Перем мСтрокаДляПодсветки;
Перем ИмяКласса;
Перем ФайлСтиля;
Перем ФайлШаблона;
Перем ПрефиксСсылкиВстроенногоЯзыка;
Перем ПрефиксСсылкиЯзыкаЗапросов;
Перем ПрефиксСсылки;
Перем ПутьКЭлементу;
Перем СтароеСловоИндекса;
Перем РазрешитьУстановкуСловаИндекса;
Перем ПодходящиеСлова;
Перем ТекущаяСтраницаУстановлена;
Перем ТекущийФайлСодержания;
Перем ТекущийФайлИндекса;

// <Описание функции>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
// Возвращаемое значение:
//               – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>;
//  <Значение2>  – <Тип.Вид> – <описание значения>
//                 <продолжение описания значения>.
//
Функция ЗагрузитьНовуюСтраницу(ПутьКЭлементуБезПрефиксаАрхива, ЛиЗагружатьПовторно = Ложь)

	//ПутьКЭлементуБезПрефиксаАрхива = СтрЗаменить(ПутьКЭлементуБезПрефиксаАрхива, ПрефиксСсылки + "/", "");
	НовыйПутьКЭлементу = "//" + АрхивСинтаксПомощника + ПутьКЭлементуБезПрефиксаАрхива;
	Если Истина
		И Не ЛиЗагружатьПовторно
		И НовыйПутьКЭлементу = ПутьКЭлементу 
	Тогда
		Возврат Неопределено;
	КонецЕсли;
	ПутьКЭлементу = НовыйПутьКЭлементу;
	НовыйАдрес = мПлатформа.РаспаковатьФайлАрхиваСинтаксПомощника(ПутьКЭлементу, ПрефиксСсылки);
	Возврат НовыйАдрес; // Новый адрес

КонецФункции // ЗагрузитьНовуюСтраницу()

Функция ПолучитьНовыйАдресИзСсылки(НовыйАдрес) Экспорт

	Если Найти(НовыйАдрес, ПрефиксСсылкиЯзыкаЗапросов) > 0 Тогда
		ПрефиксСсылки = ПрефиксСсылкиЯзыкаЗапросов;
	ИначеЕсли Найти(НовыйАдрес, ПрефиксСсылкиВстроенногоЯзыка) > 0 Тогда
		ПрефиксСсылки = ПрефиксСсылкиВстроенногоЯзыка;
	//Иначе
	//	ПрефиксСсылки = "";
	КонецЕсли;

	МаркерДопАрхива = "v8help://";
	Если Найти(НовыйАдрес, МаркерДопАрхива) = 1 Тогда
		лИмяАрхива = ирОбщий.ПолучитьПервыйФрагментЛкс(Сред(НовыйАдрес, СтрДлина(МаркерДопАрхива) + 1), "/");
		НовыйАдрес = Сред(НовыйАдрес, СтрДлина(МаркерДопАрхива) + 1 + СтрДлина(лИмяАрхива));
	КонецЕсли; 
	Возврат НовыйАдрес;

КонецФункции // ПолучитьНовыйАдресИзСсылки()

Процедура ПолеHTMLДокументаonclick(Элемент, pEvtObj)
	
	htmlElement = pEvtObj.srcElement;
	
	Пока htmlElement <> Неопределено И ВРег(htmlElement.tagName) <> "A" Цикл
		htmlElement = htmlElement.parentElement;
	КонецЦикла;
	
	Если htmlElement = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	НовыйАдрес = ПолучитьНовыйАдресИзСсылки(htmlElement.href);
	Если Найти(НовыйАдрес, "http://") = 1 Тогда
		ЗапуститьПриложение(НовыйАдрес);
	Иначе
		htmlElement.href = ЗагрузитьНовуюСтраницу(НовыйАдрес);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОткрытьАдрес(Знач НовыйОтносительныйАдрес = "", пСтрокаДляПодсветки = "", ЛиАдресСПрефиксомАрхива = Истина) Экспорт
	
	Если ЛиАдресСПрефиксомАрхива Тогда
		Если Найти(НовыйОтносительныйАдрес, "//") = 1 Тогда
			АрхивСинтаксПомощника = ирОбщий.ПолучитьПервыйФрагментЛкс(Сред(НовыйОтносительныйАдрес, СтрДлина("//") + 1), "/");
			НовыйОтносительныйАдрес = Сред(НовыйОтносительныйАдрес, СтрДлина("//" + АрхивСинтаксПомощника) + 1);
			ПрефиксСсылки = ПрефиксСсылкиЯзыкаЗапросов; // Криво. Здесь может быть нужно другие префиксы устанавливать
		Иначе
			АрхивСинтаксПомощника = "shcntx_ru";
			ПрефиксСсылки = ПрефиксСсылкиВстроенногоЯзыка;
		КонецЕсли;
	КонецЕсли; 
	//Если ПрефиксАрхива = "" Тогда
	//	НовыйОтносительныйАдрес = ПрефиксСсылкиВстроенногоЯзыка + НовыйОтносительныйАдрес;
	//КонецЕсли; 
	ЛиСтрокаДляПодсветкиИзменилась = мСтрокаДляПодсветки <> пСтрокаДляПодсветки;
	мСтрокаДляПодсветки = пСтрокаДляПодсветки;
	Если Не Открыта() Тогда
		Открыть();
	Иначе
		//Активизировать();
	КонецЕсли;
	Если ЗначениеЗаполнено(НовыйОтносительныйАдрес) Тогда
		НовыйАдрес = ЗагрузитьНовуюСтраницу(НовыйОтносительныйАдрес, ЛиСтрокаДляПодсветкиИзменилась);
		Если НовыйАдрес = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		ЭлементыФормы.ПолеHTMLДокумента.Перейти(НовыйАдрес);
	КонецЕсли; 
	ЛиАктивизироватьОкноСправкиПриЕгоОткрытии = ирОбщий.ВосстановитьЗначениеЛкс(ИмяКласса + ".ЛиАктивизироватьОкноСправкиПриЕгоОткрытии");
	Если Истина
		И ЛиАктивизироватьОкноСправкиПриЕгоОткрытии <> Истина
		И ВладелецФормы <> Неопределено
	Тогда
		ВладелецФормы.Активизировать();
	КонецЕсли;

КонецПроцедуры // ОткрытьАдрес()

Процедура ПолеHTMLДокументаДокументСформирован(Элемент)
	
	Если ЭлементыФормы.ПолеHTMLДокумента.Документ.location.href = "about:blank" Тогда
		Возврат;
	КонецЕсли;
	Документ = ЭлементыФормы.ПолеHTMLДокумента.Документ;
	ФайлСтилей = мПлатформа.ПолучитьФайлСтилейСинтаксПомощника();
	ЭлементыФормы.ПолеHTMLДокумента.Документ.createStyleSheet(ФайлСтилей.ПолноеИмя);
	СодержаниеСтраницы = Документ.body.innerHTML;
	Если мСтрокаДляПодсветки <> "" Тогда
		СодержаниеСтраницы = СтрЗаменить(СодержаниеСтраницы, мСтрокаДляПодсветки,
			"<font color=""#FF0000""><b>" + мСтрокаДляПодсветки + "</b></font>");
		//мСтрокаДляПодсветки = "";
	КонецЕсли;
	Документ.body.innerHTML = "<body><div class=""V8SH_textarea"" valign=""bottom"">" + СодержаниеСтраницы + "</div></body>";
	ЗаголовокДокумента = ЭлементыФормы.ПолеHTMLДокумента.Документ.getElementsByTagName("HEAD").item(0);
	ТегиБазы = ЗаголовокДокумента.getElementsByTagName("BASE");
	Если ТегиБазы.length > 0 Тогда
		ПолнаяСсылка = ТегиБазы.Item(0).href; // Криво "base"
		ПутьКЭлементу = "//" + АрхивСинтаксПомощника + ПолучитьНовыйАдресИзСсылки(ПолнаяСсылка);
		Если ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница = ЭлементыФормы.ВерхняяПанель.Страницы.Содержание Тогда
			ПодключитьОбработчикОжидания("ЗагрузитьСодержаниеОтложенно", 0.1, Истина);
		КонецЕсли; 
	КонецЕсли; 
 
КонецПроцедуры

Процедура КоманднаяПанель1ОПодсистеме(Кнопка)
	
	ирОбщий.ОткрытьСправкуПоПодсистемеЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура ЗагрузитьСодержаниеОтложенно() Экспорт 

	ЗагрузитьСодержание();

КонецПроцедуры // ЗагрузитьСодержаниеОтложенно()

Процедура ЗагрузитьИндекс(ОпределятьКнигуПоОткрытойСтранице = Ложь) Экспорт

	Если ОпределятьКнигуПоОткрытойСтранице Тогда
		ФайлИндекса = мПлатформа.ПолучитьАрхивСинтаксПомощникаПоПутиКЭлементу(ПутьКЭлементу, 2, , АрхивСинтаксПомощника);
		// АрхивСинтаксПомощника теперь изменился
	Иначе
		ФайлИндекса = мПлатформа.ПолучитьАрхивСинтаксПомощникаПоИмени(2, АрхивСинтаксПомощника);
	КонецЕсли; 
	Если ТекущийФайлИндекса = ФайлИндекса Тогда
		Возврат;
	КонецЕсли;
	лТаблицаИндекса = мПлатформа.ИндексыАрхивовСправки[АрхивСинтаксПомощника];
	Если лТаблицаИндекса = Неопределено Тогда
		лТаблицаИндекса = Новый ТаблицаЗначений;
		лТаблицаИндекса.Колонки.Добавить("ПутьКСлову", Новый ОписаниеТипов("Строка"));
		лТаблицаИндекса.Колонки.Добавить("НПутьКСлову", Новый ОписаниеТипов("Строка"));
		лТаблицаИндекса.Колонки.Добавить("ПутьКОписанию", Новый ОписаниеТипов("Строка"));
		лТаблицаИндекса.Колонки.Добавить("Варианты", Новый ОписаниеТипов("Число"));
		КлючПоиска = Новый Структура("НПутьКСлову");
		Если АрхивСинтаксПомощника = "shcntx_ru" Тогда
			РабочийКаталог = ПолучитьИмяВременногоФайла();
			СоздатьКаталог(РабочийКаталог);
			ФайлРаспаковщикаZIP = мПлатформа.ПолучитьФайлРаспаковщикаZIP(Истина);
			//ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(ФайлРаспаковщикаZIP.Имя + " -j " + ФайлСодержания.ПолноеИмя 
			мПлатформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(ФайлРаспаковщикаZIP.Имя + " -o """ + ФайлИндекса.ПолноеИмя + """ -d """ + РабочийКаталог + """");
			//Shell.Run( + " -o " + ФайлСодержания.ПолноеИмя + " + -d " + РабочийКаталог + "PackBlock", 0, Истина);
			МассивФайлов = НайтиФайлы(РабочийКаталог, "*.*");
			Если МассивФайлов.Количество() > 0 Тогда
				RegExp = мПлатформа.RegExp;
				RegExp.Global = Истина;
				//RegExp.Pattern = """ru"",""([^""]+)"",\d+,\d+,\d+,\d+,""([^""]+)""";
				RegExp.Pattern = """ru"",""([^""]+)"",\d+,\d+,\d+,\d+((?:,""([^""]+)"")+)"; // Там может быть несколько страниц справки на одно слово
				Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(МассивФайлов.Количество(), "Построение индекса справки");
				Для Каждого ФайлЧастиИндекса Из МассивФайлов Цикл
			        ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
					Текст = Новый ТекстовыйДокумент;
					Текст.Прочитать(ФайлЧастиИндекса.ПолноеИмя);
					ТекстФайла = Текст.ПолучитьТекст();
					РезультатПоиска = RegExp.Execute(ТекстФайла);
					Для Каждого Вхождение Из РезультатПоиска Цикл
						СтрокаИндекса = лТаблицаИндекса.Добавить();
						СтрокаИндекса.ПутьКСлову = Вхождение.SubMatches(0);
						СтрокаИндекса.НПутьКСлову = НРег(СтрокаИндекса.ПутьКСлову);
						СтрокаИндекса.ПутьКОписанию = СтрЗаменить(Сред(Вхождение.SubMatches(1), 2), """", "");
						ПутиКОписанию = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(СтрокаИндекса.ПутьКОписанию, ",");
						СтрокаИндекса.Варианты = ПутиКОписанию.Количество();
					КонецЦикла; 
				КонецЦикла;
				ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
			КонецЕсли; 
		Иначе
			ЯзыкПрограммы = ПолучитьЯзыкПрограммыПоИмениАрхиваСинтаксПомощника();
			Если ЯзыкПрограммы <> Неопределено Тогда
				// Для остальных языков индекса нет, поэтому строим свой
				мПлатформа.ИнициализацияОписанияМетодовИСвойств();
				МассивКоллекций = Новый Массив();
				СтрокиСлов = мПлатформа.ТаблицаКонтекстов.НайтиСтроки(Новый Структура("ЯзыкПрограммы", ЯзыкПрограммы));
				МассивКоллекций.Добавить(СтрокиСлов);
				СтрокиСлов = мПлатформа.ТаблицаШаблоновКонтекстов.НайтиСтроки(Новый Структура("ЯзыкПрограммы", ЯзыкПрограммы));
				МассивКоллекций.Добавить(СтрокиСлов);
				Для Каждого Коллекция Из МассивКоллекций Цикл
					Для Каждого СтрокаСлова Из Коллекция Цикл
						СуществующаяСтрока = лТаблицаИндекса.Найти(СтрокаСлова.НСлово, "НПутьКСлову");
						Если СуществующаяСтрока <> Неопределено Тогда
							СуществующаяСтрока.ПутьКОписанию = ""; // Чтобы было понятно, что неоднозначное слово
							Продолжить;
						КонецЕсли; 
						Если Найти(СтрокаСлова.ПутьКОписанию, "//" + АрхивСинтаксПомощника + "/") <> 1 Тогда
							Продолжить;
						КонецЕсли; 
						СтрокаИндекса = лТаблицаИндекса.Добавить();
						СтрокаИндекса.НПутьКСлову = СтрокаСлова.НСлово;
						СтрокаИндекса.ПутьКСлову = СтрокаСлова.Слово;
						СтрокаИндекса.ПутьКОписанию = СтрокаСлова.ПутьКОписанию;
						СтрокаИндекса.Варианты = 1;
					КонецЦикла; 
				КонецЦикла;
			КонецЕсли; 
		КонецЕсли; 
		//лТаблицаИндекса.Индексы.Добавить("НПутьКСлову");
		лТаблицаИндекса.Сортировать("НПутьКСлову");
		мПлатформа.ИндексыАрхивовСправки[АрхивСинтаксПомощника] = лТаблицаИндекса;
	КонецЕсли;
	ТаблицаИндекса.Загрузить(лТаблицаИндекса);
	ТекущийФайлИндекса = ФайлИндекса;
	
КонецПроцедуры // ЗагрузитьСодержание()

Процедура ЗагрузитьСодержание(ОпределятьКнигуПоОткрытойСтранице = Ложь) Экспорт

	Если ОпределятьКнигуПоОткрытойСтранице Тогда
		ФайлСодержания = мПлатформа.ПолучитьАрхивСинтаксПомощникаПоПутиКЭлементу(ПутьКЭлементу, 1, , АрхивСинтаксПомощника);
		// АрхивСинтаксПомощника теперь изменился
	Иначе
		ФайлСодержания = мПлатформа.ПолучитьАрхивСинтаксПомощникаПоИмени(1, АрхивСинтаксПомощника);
	КонецЕсли; 
	Если ТекущийФайлСодержания = ФайлСодержания Тогда
		Возврат;
	КонецЕсли;
	лСодержание = мПлатформа.СодержанияАрхивовСправки[АрхивСинтаксПомощника];
	Если лСодержание = Неопределено Тогда
		лСодержание = Новый ДеревоЗначений;
		лСодержание.Колонки.Добавить("ИмяРаздела");
		лСодержание.Колонки.Добавить("ПутьКЭлементу");
		лСодержание.Колонки.Добавить("ЭтоПапка");
		РабочийКаталог = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(РабочийКаталог);
		ФайлРаспаковщикаZIP = мПлатформа.ПолучитьФайлРаспаковщикаZIP(Истина);
		//ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(ФайлРаспаковщикаZIP.Имя + " -j " + ФайлСодержания.ПолноеИмя 
		мПлатформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(ФайлРаспаковщикаZIP.Имя + " -o """ + ФайлСодержания.ПолноеИмя + """ -d """ + РабочийКаталог + """");
		//Shell.Run( + " -o " + ФайлСодержания.ПолноеИмя + " + -d " + РабочийКаталог + "PackBlock", 0, Истина);
		МассивФайлов = НайтиФайлы(РабочийКаталог, "*.*");
		Если МассивФайлов.Количество() > 0 Тогда
			Текст = Новый ТекстовыйДокумент;
			Текст.Прочитать(МассивФайлов[0].ПолноеИмя);
			RegExp = мПлатформа.RegExp;
			RegExp.Global = Истина;
			RegExp.Pattern = "\{(\d+),(\d+),.*\n\{.*\n\{.*,\n\{""(ru|#)"",""(.*)""}.*\n(?:\{""en"",""(.*)""}\n)?\},""([^""]*)""\}";
			Текст = Новый ТекстовыйДокумент;
			Текст.Прочитать(МассивФайлов[0].ПолноеИмя);
			ТекстФайла = Текст.ПолучитьТекст();
			РезультатПоиска = RegExp.Execute(ТекстФайла);
			Индикатор = ирОбщий.ПолучитьИндикаторПроцессаЛкс(РезультатПоиска.Count, "Построение содержания справки");
			МассивЭлементов = Новый Массив;
			СоответствиеРодителей = Новый Соответствие();
			Для Каждого Вхождение Из РезультатПоиска Цикл
		        ирОбщий.ОбработатьИндикаторЛкс(Индикатор);
				Номер = Число(Вхождение.SubMatches(0));
				НомерРодителя = Число(Вхождение.SubMatches(1));
				Если НомерРодителя = 0 Тогда
					КоллекцияСтрок = лСодержание.Строки;
				Иначе
					КоллекцияСтрок = СоответствиеРодителей.Получить(НомерРодителя).Строки;
				КонецЕсли;
				СтрокаДерева = КоллекцияСтрок.Добавить();
				СтрокаДерева.ЭтоПапка = Вхождение.SubMatches(2) = "#";
				СтрокаДерева.ИмяРаздела = Вхождение.SubMatches(3);
				//СтрокаДерева.АнглийскийИдентификатор = СтрЗаменить(АнглийскийИдентификатор, """" + """", """");
				СтрокаДерева.ПутьКЭлементу = Вхождение.SubMatches(5);
				//ВычислитьИндексКартинки(СтрокаДерева, КоличествоПодчиненных);
				СоответствиеРодителей.Вставить(Номер, СтрокаДерева);
			КонецЦикла; 
			ирОбщий.ОсвободитьИндикаторПроцессаЛкс();
		КонецЕсли;
		
		мПлатформа.СодержанияАрхивовСправки[АрхивСинтаксПомощника] = лСодержание;
	КонецЕсли;
	Содержание = лСодержание;
	Если Содержание.Строки.Количество() = 1 Тогда
		ЭлементыФормы.Содержание.Развернуть(Содержание.Строки[0]);
	КонецЕсли; 
	ТекущийФайлСодержания = ФайлСодержания;
	
КонецПроцедуры // ЗагрузитьСодержание()

Функция НайтиТекущуюСтраницуВДереве() Экспорт 
	
	ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница = ЭлементыФормы.ВерхняяПанель.Страницы.Содержание;
	ЗагрузитьСодержание(Истина);
	ТекущаяСтрока = Содержание.Строки.Найти(Сред(ПутьКЭлементу, СтрДлина("//" + АрхивСинтаксПомощника) + 1), "ПутьКЭлементу", Истина);
	Если ТекущаяСтрока <> Неопределено Тогда
		ЭлементыФормы.Содержание.ТекущаяСтрока = ТекущаяСтрока;
	КонецЕсли;
	Возврат ЭлементыФормы.Содержание.ТекущаяСтрока = ТекущаяСтрока;
	
КонецФункции

Процедура КоманднаяПанельХтмлНайтиВДереве(Кнопка)
	
	НайтиТекущуюСтраницуВДереве();
	
КонецПроцедуры

Процедура СодержаниеПриВыводеСтроки(Элемент, ОформлениеСтроки, ДанныеСтроки)
	
	КоличествоПодчиненных = ДанныеСтроки.Строки.Количество();
	Если Ложь
		Или (Истина
			И ДанныеСтроки.ЭтоПапка 
			И Не ПустаяСтрока(ДанныеСтроки.ПутьКЭлементу))
		Или (Истина
			И КоличествоПодчиненных > 0
			И Не ДанныеСтроки.ЭтоПапка)
	Тогда
		ИндексКартинки = 0;
	ИначеЕсли ДанныеСтроки.ЭтоПапка И ПустаяСтрока(ДанныеСтроки.ПутьКЭлементу) Тогда
		ИндексКартинки = 1;
	Иначе
		ИндексКартинки = 2;
	КонецЕсли;
	ОформлениеСтроки.Ячейки.ИмяРаздела.ИндексКартинки = ИндексКартинки;
	ОформлениеСтроки.Ячейки.ИмяРаздела.ОтображатьКартинку = Истина;
	
КонецПроцедуры

Процедура СодержаниеВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если Не ПустаяСтрока(ВыбраннаяСтрока.ПутьКЭлементу) Тогда
		ОткрытьАдрес(ВыбраннаяСтрока.ПутьКЭлементу, , Ложь);
	КонецЕсли;
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

Процедура АрхивСинтаксПомощникаПриИзменении(Элемент = Неопределено)
	
	Для Каждого Страница Из ЭлементыФормы.ВерхняяПанель.Страницы Цикл
		Страница.Значение = 1;
	КонецЦикла; 
	ВерхняяПанельПриСменеСтраницы();
	
КонецПроцедуры

Процедура КоманднаяПанельХтмлВверх(Кнопка)
	
	Если НайтиТекущуюСтраницуВДереве() Тогда
		Родитель = ЭлементыФормы.Содержание.ТекущаяСтрока.Родитель;
		Если Не ПустаяСтрока(Родитель.ПутьКЭлементу) Тогда
			ОткрытьАдрес(Родитель.ПутьКЭлементу, , Ложь);
		КонецЕсли;
		ЭлементыФормы.Содержание.ТекущаяСтрока = Родитель;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ПриОткрытии()
	
	Если Не ТекущаяСтраницаУстановлена Тогда
		ТекущаяСтраница = ирОбщий.ВосстановитьЗначениеЛкс(Метаданные().ПолноеИмя() + ".ТекущаяСтраница");
		Страница = ЭлементыФормы.ВерхняяПанель.Страницы.Найти(ТекущаяСтраница);
		Если Страница <> Неопределено Тогда
			ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница = Страница;
		КонецЕсли; 
	КонецЕсли; 
	Если ЭтаФорма.ВладелецФормы = Неопределено Тогда
		ОткрытьАдрес();
	КонецЕсли;
	АрхивСинтаксПомощникаПриИзменении();
	Попытка
		Пустышка = Новый COMОбъект("Forms.TextBox.1");
	Исключение
		Сообщить("Для работы закладки ""Индекс"" необходимо зарегистрировать библиотеки FM20.dll и FM20ENU.dll из состава MS Office 97-2007.
		|Это можно сделать с помощью формы ""Административная регистрация COM компонент"" из состава подсистемы");
	КонецПопытки; 
	
КонецПроцедуры

Процедура ДеревоТиповСловаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	Если ВыбраннаяСтрока.Уровень() = 1 Тогда
		ОткрытьСтраницуСтрокиПоиска();
	КонецЕсли;
	
КонецПроцедуры

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ВыбратьИскомуюСтроку(СтрокаДереваТиповСлова, БезусловнаяАктивизацияРезультатов = Истина) Экспорт 

	Если Ложь
		Или БезусловнаяАктивизацияРезультатов 
		или ДеревоТиповСлова.Строки[0].Строки.Количество() > 1
	Тогда
		ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница = ЭлементыФормы.ВерхняяПанель.Страницы.Поиск;
		ТекущаяСтраницаУстановлена = Истина;
	КонецЕсли; 
	ЭлементыФормы.ДеревоТиповСлова.ТекущаяСтрока = СтрокаДереваТиповСлова;
	ОткрытьСтраницуСтрокиПоиска();

КонецПроцедуры // ВыбратьИскомуюСтроку()

Функция ПолучитьЯзыкПрограммыПоИмениАрхиваСинтаксПомощника(ИмяАрхиваСинтаксПомощника = "") Экспорт 

	Если Не ЗначениеЗаполнено(ИмяАрхиваСинтаксПомощника) Тогда
		ИмяАрхиваСинтаксПомощника = АрхивСинтаксПомощника;
	КонецЕсли; 
	Если ИмяАрхиваСинтаксПомощника = "shquery_ru" Тогда
		ЯзыкПрограммы = 1;
	ИначеЕсли ИмяАрхиваСинтаксПомощника = "dcsui_ru" Тогда
		ЯзыкПрограммы = 2;
	ИначеЕсли ИмяАрхиваСинтаксПомощника = "shcntx_ru" Тогда
		ЯзыкПрограммы = 0;
	КонецЕсли; 
	Возврат ЯзыкПрограммы;

КонецФункции // ПолучитьЯзыкПрограммыПоИмениАрхиваСинтаксПомощника()

Функция ПолучитьИмяАрхиваСинтаксПомощникаПоЯзыкуПрограммы(ЯзыкПрограммы) Экспорт 

	Если ЯзыкПрограммы = 1 Тогда
		ИмяАрхиваСинтаксПомощника = "shquery_ru";
	ИначеЕсли ЯзыкПрограммы = 2 Тогда
		ИмяАрхиваСинтаксПомощника = "dcsui_ru";
	Иначе
		ИмяАрхиваСинтаксПомощника = "shcntx_ru";
	КонецЕсли; 
	Возврат ИмяАрхиваСинтаксПомощника;

КонецФункции // ПолучитьЯзыкПрограммыПоИмениАрхиваСинтаксПомощника()

// <Описание процедуры>
//
// Параметры:
//  <Параметр1>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>;
//  <Параметр2>  – <Тип.Вид> – <описание параметра>
//                 <продолжение описания параметра>.
//
Процедура ОткрытьСтраницуСтрокиПоиска()

	ОтносительныйПутьКОписанию = "";
	СтрокаОписания = ЭлементыФормы.ДеревоТиповСлова.ТекущаяСтрока.Ключ;
	Если СтрокаОписания.Владелец().Колонки.Найти("ЯзыкПрограммы") <> Неопределено Тогда
		ЯзыкПрограммы = СтрокаОписания.ЯзыкПрограммы;
	Иначе
		ЯзыкПрограммы = 0;
	КонецЕсли; 
	АрхивСинтаксПомощника = ПолучитьИмяАрхиваСинтаксПомощникаПоЯзыкуПрограммы(ЯзыкПрограммы);
	// Добавлено 05.04.2012
	// Сначала ищем по индексу, чтобы найти точный родной путь к странице синтакс-помощника, т.к. разные версии платформ могут иметь разные пути к странице
	Если СтрокаОписания <> Неопределено Тогда
		ЗагрузитьИндекс();
		СтрокаИндекса = Неопределено;
		Если СтрокаОписания.Владелец().Колонки.Найти("ТипКонтекста") <> Неопределено Тогда
			ТипКонтекста = СтрокаОписания.ТипКонтекста;
			Если ТипКонтекста = "Общее" Тогда
				ТипКонтекста = "Встроенные функции языка";
			КонецЕсли; 
			ПутьКСлову = ТипКонтекста + "." + СтрокаОписания.Слово;
			СтрокаИндекса = ТаблицаИндекса.Найти(НРег(ПутьКСлову), "НПутьКСлову");
		КонецЕсли; 
		Если СтрокаИндекса = Неопределено Тогда
			Если СтрокаОписания.Владелец().Колонки.Найти("Слово") <> Неопределено Тогда
				ПутьКСлову = СтрокаОписания.Слово;
				СтрокаИндекса = ТаблицаИндекса.Найти(НРег(ПутьКСлову), "НПутьКСлову");
			КонецЕсли; 
		КонецЕсли; 
		Если СтрокаИндекса <> Неопределено Тогда
			Если СтрокаИндекса.Варианты = 1 Тогда
				ОтносительныйПутьКОписанию = СтрокаИндекса.ПутьКОписанию;
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;
	
	// Если по индексу найти не удалось, тогда берем путь из таблиц описания платформы
	Если ОтносительныйПутьКОписанию = "" Тогда
		Если СтрокаОписания <> Неопределено Тогда
			Если СтрокаОписания.Владелец().Колонки.Найти("ПутьКОписанию") <> Неопределено Тогда
				ОтносительныйПутьКОписанию = СтрокаОписания.ПутьКОписанию;
				Если ОтносительныйПутьКОписанию = "" Тогда
					Попытка
						ТипЗначения = СтрокаОписания.ТипЗначения;
					Исключение
					КонецПопытки;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		Если ТипЗначения <> Неопределено Тогда
			ЯзыкПрограммы = ПолучитьЯзыкПрограммыПоИмениАрхиваСинтаксПомощника();
			КлючПоиска = Новый Структура("ЯзыкПрограммы, Слово", ЯзыкПрограммы, ТипЗначения);
			НайденныеСтроки = мПлатформа.ТаблицаОбщихТипов.НайтиСтроки(КлючПоиска);
			Если НайденныеСтроки.Количество() > 0 Тогда
				ОтносительныйПутьКОписанию = НайденныеСтроки[0].ПутьКОписанию;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли; 
	
	СтрокаДляПодсветки = "";
	Если Истина
		И ОтносительныйПутьКОписанию <> "" 
		И НомерИскомогоПараметра > 0
	Тогда
		СтруктураКлюча = Новый Структура("ТипКонтекста, ЯзыкПрограммы, Слово, Номер");
		ЗаполнитьЗначенияСвойств(СтруктураКлюча, СтрокаОписания);
		СтруктураКлюча.Номер = НомерИскомогоПараметра;
		НайденныеСтроки = мПлатформа.ТаблицаПараметров.НайтиСтроки(СтруктураКлюча);
		Если НайденныеСтроки.Количество() > 0 Тогда
			СтрокаДляПодсветки = НайденныеСтроки[0].Параметр;
		Иначе
			//ирОбщий.СообщитьСУчетомМодальностиЛкс("Параметр не обнаружен!");
		КонецЕсли;
	КонецЕсли;
	ОткрытьАдрес(ОтносительныйПутьКОписанию, СтрокаДляПодсветки);

КонецПроцедуры // ОткрытьСтраницуСтрокиПоиска()

Процедура ОбновитьРезультатыПоиска(БезусловнаяАктивизацияРезультатов = Истина)

	ПоискСУчетомТипаСлова = Ложь;
	ВключатьПутьКОписаниюТипаЗначения = Ложь;
	ЯзыкПрограммы = ПолучитьЯзыкПрограммыПоИмениАрхиваСинтаксПомощника();
	ТаблицаСтруктурВозможныхТиповКонтекста = ирОбщий.НайтиВозможныеСтрокиОписанияСловаВСинтаксПомощникеЛкс(ИскомоеСлово, ЯзыкПрограммы, ПоискСУчетомТипаСлова);
	СтруктураЦикла = Новый Соответствие;
	СтруктураЦикла.Вставить("1.Возможные:", ТаблицаСтруктурВозможныхТиповКонтекста);
	мПлатформа.ВыбратьСтрокуОписанияИзМассиваСтруктурТипов(СтруктураЦикла, ВключатьПутьКОписаниюТипаЗначения, , ИскомоеСлово, НомерИскомогоПараметра,
		БезусловнаяАктивизацияРезультатов);

КонецПроцедуры // ОбновитьРезультатыПоиска()

Процедура ИскомоеСловоПриИзменении(Элемент = Неопределено)
	
	Если Элемент = Неопределено Тогда
		Элемент = ЭлементыФормы.ИскомоеСлово;
	КонецЕсли; 
	ОбновитьРезультатыПоиска();
	ирОбщий.ПолеВводаСИсториейВыбора_ПриИзмененииЛкс(Элемент, ЭтаФорма);
	ЭтаФорма.ТекущийЭлемент = ЭлементыФормы.ДеревоТиповСлова;

КонецПроцедуры

Процедура ВерхняяПанельПриСменеСтраницы(Элемент = Неопределено, ТекущаяСтраница = Неопределено)
	
	Если ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница = ЭлементыФормы.ВерхняяПанель.Страницы.Содержание Тогда
		Если ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница.Значение <> Неопределено Тогда
			ЗагрузитьСодержание();
			ирОбщий.УстановитьГотовностьДанныхСтраницыЛкс(ЭтаФорма, ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница, Истина);
		КонецЕсли; 
	ИначеЕсли ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница = ЭлементыФормы.ВерхняяПанель.Страницы.Индекс Тогда
		Если ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница.Значение <> Неопределено Тогда
			РазрешитьУстановкуСловаИндекса = Ложь;
			ЗагрузитьИндекс();
			ОбновитьПодходящиеСлова();
			ирОбщий.УстановитьГотовностьДанныхСтраницыЛкс(ЭтаФорма, ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница, Истина);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура КоманднаяПанельХтмлНовоеОкно(Кнопка)
	
	//ирОбщий.ОткрытьФормуЛкс("Обработка.ирСинтаксПомощник.Форма",,, Новый УникальныйИдентификатор);
	ирОбщий.ОткрытьНовоеОкноОбработкиЛкс(ЭтотОбъект);
	
КонецПроцедуры

Процедура НомерИскомогоПараметраПриИзменении(Элемент)
	
	ОбновитьРезультатыПоиска();
	
КонецПроцедуры

Процедура СодержаниеПриАктивизацииСтроки(Элемент)
	
	ПутьВДереве = "";
	ТекущаяСтрока = Элемент.ТекущаяСтрока;
	Пока ТекущаяСтрока <> Неопределено Цикл
		Если ПутьВДереве <> "" Тогда
			ПутьВДереве = "\" + ПутьВДереве;
		КонецЕсли; 
		ПутьВДереве = ТекущаяСтрока.ИмяРаздела + ПутьВДереве;
		ТекущаяСтрока = ТекущаяСтрока.Родитель;
	КонецЦикла; 
	
КонецПроцедуры

Процедура ИскомоеСловоНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	
	ирОбщий.ПолеВводаСИсториейВыбора_НачалоВыбораИзСпискаЛкс(Элемент, ЭтаФорма);

КонецПроцедуры

Процедура ВыбратьСтрокуИндекса(ВыбраннаяСтрока)
	
	Если Истина
		И ВыбраннаяСтрока.Варианты = 1
		//И Найти(ВыбраннаяСтрока.ПутьКСлову, ".") > 0
		И Не ПустаяСтрока(ВыбраннаяСтрока.ПутьКОписанию) 
	Тогда
		ОткрытьАдрес(ВыбраннаяСтрока.ПутьКОписанию, , Ложь);
	Иначе
		ИскомоеСлово = ВыбраннаяСтрока.ПутьКСлову;
		ОбновитьРезультатыПоиска(Ложь);
		Если ДеревоТиповСлова.Строки.Количество() = 0 Тогда 
			// Доделать
			ПутиКОписанию = ирОбщий.ПолучитьМассивИзСтрокиСРазделителемЛкс(ВыбраннаяСтрока.ПутьКОписанию);
			//ТаблицаСтруктурВозможныхТиповКонтекста = ирКэш.Получить().ПолучитьНовуюТаблицуСтруктурТипа();
			//Для Каждого ПутьКОписанию Из ПутиКОписанию Цикл
			//	ЗаполнитьЗначенияСвойств(ТаблицаСтруктурВозможныхТиповКонтекста.Добавить(), Новый Структура("СтрокаОписания", НайденнаяСтрока));
			//КонецЦикла;
			//СтруктураЦикла = Новый Соответствие;
			//СтруктураЦикла.Вставить("1.Возможные:", ТаблицаСтруктурВозможныхТиповКонтекста);
			//мПлатформа.ВыбратьСтрокуОписанияИзМассиваСтруктурТипов(СтруктураЦикла, ВключатьПутьКОписаниюТипаЗначения, , ИскомоеСлово, НомерИскомогоПараметра,
			//	БезусловнаяАктивизацияРезультатов);
			ОткрытьАдрес(ПутиКОписанию[0],, Ложь);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

Процедура ТаблицаИндексаВыбор(Элемент, ВыбраннаяСтрока, Колонка, СтандартнаяОбработка)
	
	ВыбратьСтрокуИндекса(ВыбраннаяСтрока);
	СтандартнаяОбработка = Ложь;

КонецПроцедуры

Процедура СловоИндексаChange(Элемент = Неопределено)
	
	Если Элемент = Неопределено Тогда
		Элемент = ЭлементыФормы.СловоИндекса;
	КонецЕсли;
	
	НовоеСловоИндекса = НРег(Элемент.Значение);
	Если Элемент.Значение = "" Тогда
		СтрокаИндекса = ТаблицаИндекса[0];
	Иначе
		ИндексТекущейСтроки = 0;
		Если ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока <> Неопределено Тогда
			ТекущаяСтрокаПодходящегоСлова = ПодходящиеСлова.Найти(ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока.НПутьКСлову, "НПутьКСлову");
			Если ТекущаяСтрокаПодходящегоСлова <> Неопределено Тогда
				ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ТекущаяСтрокаПодходящегоСлова);
			КонецЕсли; 
		КонецЕсли; 
		ДлинаСлова = СтрДлина(НовоеСловоИндекса);
		Если СтароеСловоИндекса > НовоеСловоИндекса Тогда
			НаправлениеПоискаСтроки = -1;
		Иначе
			НаправлениеПоискаСтроки = +1;
		КонецЕсли; 
		Индекс = ИндексТекущейСтроки;
		Пока Индекс >= 0 И Индекс < ПодходящиеСлова.Количество() Цикл
			СтрокаИндекса = ПодходящиеСлова[Индекс];
			Если Ложь
				Или (Истина
					И НаправлениеПоискаСтроки = 1
					И (Ложь
						Или (Истина
							И Лев(СтрокаИндекса.НПутьКСлову, СтрДлина(СтароеСловоИндекса)) <> СтароеСловоИндекса
							И СтрокаИндекса.НПутьКСлову >= НовоеСловоИндекса)
						Или (Истина
							И Лев(СтрокаИндекса.НПутьКСлову, СтрДлина(СтароеСловоИндекса)) = СтароеСловоИндекса
							И СтрокаИндекса.НПутьКСлову >= НовоеСловоИндекса)))
				Или (Истина
					И НаправлениеПоискаСтроки = -1
					И Лев(СтрокаИндекса.НПутьКСлову, СтрДлина(НовоеСловоИндекса)) <> НовоеСловоИндекса
					И СтрокаИндекса.НПутьКСлову <= НовоеСловоИндекса)
			Тогда
				Если Истина
					И НаправлениеПоискаСтроки = -1 
					//И СтрокаИндекса.НПутьКСлову <= НовоеСловоИндекса // всегда выполняется
				Тогда
					СтрокаИндекса = ПодходящиеСлова[Индекс + 1];
				КонецЕсли; 
				Прервать;
			КонецЕсли;
			Индекс = Индекс + НаправлениеПоискаСтроки;
		КонецЦикла; 
	КонецЕсли; 
	Если СтрокаИндекса <> Неопределено Тогда
		РазрешитьУстановкуСловаИндекса = Ложь;
		ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока = ТаблицаИндекса.Найти(СтрокаИндекса.НПутьКСлову, "НПутьКСлову");
		РазрешитьУстановкуСловаИндекса = Истина;
	КонецЕсли; 
	СтароеСловоИндекса = НовоеСловоИндекса;
	ОбновитьЦветФонаСловаИндекса();
	
КонецПроцедуры

Процедура ОбновитьЦветФонаСловаИндекса()
	
	Если Истина
		И ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока <> Неопределено
		И Лев(ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока.НПутьКСлову, СтрДлина(СловоИндекса)) = НРег(СловоИндекса)
	Тогда
		ЭлементыФормы.СловоИндекса.BackColor = 16777215; // Новый Цвет(255, 255, 255);
	Иначе
		ЭлементыФормы.СловоИндекса.BackColor = 16448255; // Новый Цвет(255, 250, 250);
	КонецЕсли; 

КонецПроцедуры

Процедура ПриЗакрытии()
	
	ирОбщий.СохранитьЗначениеЛкс(Метаданные().ПолноеИмя() + ".ТекущаяСтраница", ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница.Имя);
	ирОбщий.Форма_ПриЗакрытииЛкс(ЭтаФорма);
	
КонецПроцедуры

Процедура ИскомоеСловоОткрытие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ИскомоеСловоПриИзменении();
	
КонецПроцедуры

Процедура ТаблицаИндексаПриАктивизацииСтроки(Элемент)
	
	Если РазрешитьУстановкуСловаИндекса Тогда
		Если Элемент.ТекущаяСтрока <> Неопределено Тогда
			СловоИндекса = Элемент.ТекущаяСтрока.ПутьКСлову;
		КонецЕсли; 
	КонецЕсли;
	РазрешитьУстановкуСловаИндекса = Истина;
	
КонецПроцедуры

Процедура ОбновитьПодходящиеСлова()
	
	ВременнныйПостроительЗапроса = Новый ПостроительЗапроса;
	ВременнныйПостроительЗапроса.ИсточникДанных = Новый ОписаниеИсточникаДанных(ТаблицаИндекса);
	ирОбщий.СкопироватьОтборПостроителяЛкс(ВременнныйПостроительЗапроса.Отбор, ЭлементыФормы.ТаблицаИндекса.ОтборСтрок);
	ВременнныйПостроительЗапроса.ВыбранныеПоля.Очистить();
	ВременнныйПостроительЗапроса.ВыбранныеПоля.Добавить("НПутьКСлову");
	ВременнныйПостроительЗапроса.Выполнить();
	ПодходящиеСлова = ВременнныйПостроительЗапроса.Результат.Выгрузить();

КонецПроцедуры

Процедура ПолеОтбораПоПодстрокеChange(Элемент = Неопределено)
	
	ОбновитьПодходящиеСлова();
	СловоИндексаChange();
	
КонецПроцедуры

Процедура КоманднаяПанельХтмлНайтиВИндексе(Кнопка = Неопределено)
	
	ЭлементыФормы.ВерхняяПанель.ТекущаяСтраница = ЭлементыФормы.ВерхняяПанель.Страницы.Индекс;
	ЗагрузитьИндекс(Истина);
	СтрокаИндекса = ТаблицаИндекса.Найти(Сред(ПутьКЭлементу, СтрДлина("//" + АрхивСинтаксПомощника) + 1), "ПутьКОписанию");
	Если СтрокаИндекса <> Неопределено Тогда
		ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока = СтрокаИндекса;
		СловоИндекса = ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока.ПутьКСлову;
	КонецЕсли; 
	
КонецПроцедуры

Процедура ИндексКлавишаНажата(KeyCode, Shift)

	// очень похожий фрагмент есть в Обработка.ирКлсПолеТекстовогоДокументаСКонтекстнойПодсказкой.Форма.Подсказки
	СтруктураКлюча = Новый Структура("НПутьКСлову");
	Если KeyCode.Value = 13 Тогда // {ENTER} 
		Если Истина
			И ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока <> Неопределено
			И ЭлементыФормы.ТаблицаИндекса.ВыделенныеСтроки.Содержит(ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока)
		Тогда 
			ВыбратьСтрокуИндекса(ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока);
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 40 Тогда // {DOWN}
		Если ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока <> Неопределено Тогда
			Смещение = + 1;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Мин(ИндексТекущейСтроки + Смещение, ПодходящиеСлова.Количество() - 1);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока = ТаблицаИндекса.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 38 Тогда // {UP} 
		Если ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока <> Неопределено Тогда
			Смещение = - 1;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Макс(ИндексТекущейСтроки + Смещение, 0);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока = ТаблицаИндекса.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 34 Тогда // {PGDW} 
		Если ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока <> Неопределено Тогда
			Смещение = + 20;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Мин(ИндексТекущейСтроки + Смещение, ПодходящиеСлова.Количество() - 1);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока = ТаблицаИндекса.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	ИначеЕсли KeyCode.Value = 33 Тогда // {PGUP} 
		Если ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока <> Неопределено Тогда
			Смещение = - 20;
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока);
			ИндексТекущейСтроки = ПодходящиеСлова.Индекс(ПодходящиеСлова.НайтиСтроки(СтруктураКлюча)[0]);
			НовыйИндекс = Макс(ИндексТекущейСтроки + Смещение, 0);
			ЗаполнитьЗначенияСвойств(СтруктураКлюча, ПодходящиеСлова[НовыйИндекс]);
			ЭлементыФормы.ТаблицаИндекса.ТекущаяСтрока = ТаблицаИндекса.НайтиСтроки(СтруктураКлюча)[0];
		КонецЕсли;
	//ИначеЕсли KeyCode.Value = 191 Тогда // "."
	//	ОткрытьДочерние();
	КонецЕсли;

КонецПроцедуры


Процедура СловоИндексаKeyDown(Элемент, KeyCode, Shift)
	
	ИндексКлавишаНажата(KeyCode, Shift);

КонецПроцедуры

Процедура ПолеОтбораПоПодстрокеKeyDown(Элемент, KeyCode, Shift)

	ИндексКлавишаНажата(KeyCode, Shift);
	
КонецПроцедуры

Процедура КнопкаОчисткиФильтраИндексаНажатие(Элемент)
	
	ЭлементыФормы.ПолеОтбораПоПодстроке.Значение = "";
	
КонецПроцедуры

Процедура КнопкаОчисткиСловаИндексаНажатие(Элемент)
	
	ЭлементыФормы.СловоИндекса.Значение = "";
	
КонецПроцедуры

Процедура КоманднаяПанельХтмлКнопкаПоУмолчанию(Кнопка)
	// Вставить содержимое обработчика.
КонецПроцедуры

Процедура СтруктураКоманднойПанелиНажатие(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруКоманднойПанелиЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	ирОбщий.ФормаОбработкаОповещенияЛкс(ЭтаФорма, ИмяСобытия, Параметр, Источник); 

КонецПроцедуры

Процедура КоманднаяПанельХтмлСтруктураФормы(Кнопка)
	
	ирОбщий.ОткрытьСтруктуруФормыЛкс(ЭтаФорма);
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирСинтаксПомощник.Форма.Форма");

мПлатформа = ирКэш.Получить();
ИмяКласса = "ПолеТекстовогоДокументаСКонтекстнойПодсказкой";
ПрефиксСсылкиВстроенногоЯзыка = "v8help://SyntaxHelperContext";
ПрефиксСсылкиЯзыкаЗапросов = "v8help://SyntaxHelperQueries";
МаркерДопАрхива = "//";

Файлы = НайтиФайлы(КаталогПрограммы(), "*_ru.hbk");
Для Каждого Файл Из Файлы Цикл
	Если Файл.Размер() > 20000 Тогда // отсекаем мелкий мусор
		ЭлементСписка = ЭлементыФормы.АрхивСинтаксПомощника.СписокВыбора.Добавить(Файл.ИмяБезРасширения);
		Если ЭлементСписка.Значение = "dcsui_ru" Тогда
			ЭлементСписка.Представление = "Язык выражений компоновки";
		ИначеЕсли ЭлементСписка.Значение = "shcntx_ru" Тогда
			ЭлементСписка.Представление = "Основная";
		//ИначеЕсли ЭлементСписка.Значение = "debug_ru" Тогда
		//	ЭлементСписка.Представление = "Отладка";
		//ИначеЕсли ЭлементСписка.Значение = "config_ru" Тогда
		//	ЭлементСписка.Представление = "Обновление конфигурации";
		//ИначеЕсли ЭлементСписка.Значение = "devtool_ru" Тогда
		//	ЭлементСписка.Представление = "Разработка конфигурации";
		ИначеЕсли ЭлементСписка.Значение = "shquery_ru" Тогда
			ЭлементСписка.Представление = "Язык запросов";
		КонецЕсли; 
	КонецЕсли; 
КонецЦикла;
ЭлементыФормы.АрхивСинтаксПомощника.СписокВыбора.СортироватьПоПредставлению();
АрхивСинтаксПомощника = "shcntx_ru";
ЭлементОтбора = ЭлементыФормы.ТаблицаИндекса.ОтборСтрок.ПутьКСлову;
ЭлементОтбора.ВидСравнения = ВидСравнения.Содержит;
ЭлементОтбора.Использование = истина;
СтароеСловоИндекса = "";
ТекущаяСтраницаУстановлена = Ложь;