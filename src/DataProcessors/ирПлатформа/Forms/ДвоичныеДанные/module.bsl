﻿Перем ДвоичныеДанные;

Процедура ОсновныеДействияФормыОК(Кнопка)
	
	НовоеЗначение = ПолучитьРезультат();
	ирОбщий.ПрименитьИзмененияИЗакрытьФормуЛкс(ЭтаФорма, НовоеЗначение);
	
КонецПроцедуры

Функция ПолучитьРезультат()
	
	Возврат ДвоичныеДанные;

КонецФункции

Процедура ПриОткрытии()
	
	Если ТипЗнч(НачальноеЗначениеВыбора) <> Тип("ДвоичныеДанные") Тогда
		НачальноеЗначениеВыбора = Неопределено;
	КонецЕсли; 
	ДвоичныеДанные = НачальноеЗначениеВыбора;
	ОбновитьДоступность();

КонецПроцедуры

Процедура ОсновныеДействияФормыИсследовать(Кнопка)
	
	ирОбщий.ИсследоватьЛкс(ПолучитьРезультат());
	
КонецПроцедуры

Процедура КлсУниверсальнаяКомандаНажатие(Кнопка) Экспорт 
	
	ирОбщий.УниверсальнаяКомандаФормыЛкс(ЭтаФорма, Кнопка);
	
КонецПроцедуры

Процедура ОбработчикОжиданияСПараметрамиЛкс() Экспорт 
	
	ирОбщий.ОбработчикОжиданияСПараметрамиЛкс();

КонецПроцедуры

Процедура ВыгрузитьВФайлНажатие(Элемент)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(Ложь);
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		ДвоичныеДанные.Записать(ПолноеИмяФайла);
	КонецЕсли; 
	
КонецПроцедуры

Процедура ОбновитьДоступность()
	
	ЭлементыФормы.ВыгрузитьВФайл.Доступность = ТипЗнч(ДвоичныеДанные) = Тип("ДвоичныеДанные");
	 
КонецПроцедуры

Процедура ЗагрузитьИзФайлаНажатие(Элемент)
	
	ПолноеИмяФайла = ирОбщий.ВыбратьФайлЛкс(Ложь);
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		ДвоичныеДанные = Новый ДвоичныеДанные(ПолноеИмяФайла);
	КонецЕсли; 
	ОбновитьДоступность();
	
КонецПроцедуры

ирОбщий.ИнициализироватьФормуЛкс(ЭтаФорма, "Обработка.ирПлатформа.Форма.ДвоичныеДанные");
