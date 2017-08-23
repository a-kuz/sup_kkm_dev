﻿
&НаСервере
Процедура НоменклатураПриИзмененииНаСервере()
	ЗаполнитьЗначенияСвойств(Объект, Объект.Номенклатура,, "Предопределенный, Ссылка, ГруппаСпецифик, Родитель, Владелец");	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.Наименование) Тогда
		Если Вопрос("Перезаполнить по данным номенклатуры?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
			НоменклатураПриИзмененииНаСервере();
		КонецЕсли;
	Иначе
		НоменклатураПриИзмененииНаСервере();
	КонецЕсли;
	
КонецПроцедуры
&НаСервере
Процедура УстановитьВидимостьНастройкиНаличия()
	Если СложнаяНастройка Тогда
		Если ПараметрыСеанса.ТекущаяИБ.Предопределенный Тогда
			Элементы.ЕстьВПродаже.Видимость = Ложь;
		Иначе
			Элементы.ЕстьВПродаже.Доступность = Ложь;	
		КонецЕсли;
		Элементы.ДействующиеРасписания.Видимость = Истина;
	Иначе
		Элементы.ЕстьВПродаже.Видимость = Истина;
		Элементы.ДействующиеРасписания.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СложнаяНастройкаПриИзменении(Элемент)
	Объект.ВариантНаличияВПродаже = ?(СложнаяНастройка, ПредопределенноеЗначение("Перечисление.ВариантыНаличияВПродаже.Сложный"), ПредопределенноеЗначение("Перечисление.ВариантыНаличияВПродаже.Простой"));
	УстановитьВидимостьНастройкиНаличия();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СложнаяНастройка = ?(Объект.ВариантНаличияВПродаже = Перечисления.ВариантыНаличияВПродаже.Простой, Ложь, Истина);
	ДействующиеРасписания.КомпоновщикНастроек.Настройки.Отбор.Элементы[0].ПравоеЗначение = Объект.Ссылка;
	УстановитьВидимостьНастройкиНаличия();
КонецПроцедуры
