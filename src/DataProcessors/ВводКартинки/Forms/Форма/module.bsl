﻿Перем ВариантКартинкиИзФайла;

Процедура ОбновитьОтображение()
	
	ЭлементыФормы.Панель1.Страницы.КартинкаИзФайла.Видимость	= ВариантКартинкиИзФайла;
	ЭлементыФормы.Панель1.Страницы.КартинкаИзБуфера.Видимость	= НЕ ВариантКартинкиИзФайла;
	
	Если ВариантКартинкиИзФайла Тогда
		ПутьКФайлуКартинки	= Картинка;
	Иначе
		НомерКартинки		= Картинка;
	КонецЕсли;	
	
КонецПроцедуры	

Процедура КнопкаВыполнитьНажатие(Кнопка)
	
	ДанныеКартинки = Новый Структура("Тип, Картинка, КоличествоТочек", Тип, ?(ВариантКартинкиИзФайла, Картинка, НомерКартинки), КоличествоТочекСтроки);
	
	Закрыть(ДанныеКартинки);
	
КонецПроцедуры

Процедура ВариантКартинкиПриИзменении(Элемент)
	
	ВариантКартинкиИзФайла = Тип = "Картинка";
	
	Если ВариантКартинкиИзФайла И НЕ ЗначениеЗаполнено(КоличествоТочекСтроки) Тогда
		КоличествоТочекСтроки = "Печать_24_точек_строка";
	КонецЕсли;
	
	Картинка	= ?(ВариантКартинкиИзФайла, Неопределено, 1);
	
	ОбновитьОтображение();
	
КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Тип) Тогда
		Тип = "Картинка";
	КонецЕсли;	
	
	ВариантКартинкиИзФайла = Тип = "Картинка";
	
	Если ВариантКартинкиИзФайла И НЕ ЗначениеЗаполнено(КоличествоТочекСтроки) Тогда
		КоличествоТочекСтроки = "Печать_24_точек_строка";
	КонецЕсли;

	
	ОбновитьОтображение();
	
КонецПроцедуры

Процедура ПутьКФайлуКартинкиоВыбора(Элемент, СтандартнаяОбработка)
	
	ФильтрДиалога = "Картинки (*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf)|*.bmp;*.dib;*.rle;*.jpg;*.jpeg;*.tif;*.gif;*.png;*.ico;*.wmf;*.emf";
	Диалог = РаботаСФайлами.ПолучитьДиалогВыбораФайлов(,,ФильтрДиалога);
	
	Если Диалог.Выбрать() Тогда
		ПутьКФайлуКартинки	= Диалог.ПолноеИмяФайла;
		Картинка			= Диалог.ПолноеИмяФайла;
	КонецЕсли;

КонецПроцедуры

Процедура НомерКартинкиПриИзменении(Элемент)
	Картинка = НомерКартинки;
КонецПроцедуры



