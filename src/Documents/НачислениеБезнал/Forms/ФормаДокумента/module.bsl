﻿
////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

Процедура ПриОткрытии()
	
	Если ЗначениеЗаполнено(ККМ) Тогда
		ЭлементыФормы.тВариантОплаты.Заголовок = ВариантОплаты.Наименование;
		ТолькоПросмотр = Истина;
	Иначе
		ЭлементыФормы.тВариантОплаты.Заголовок = "без чека";
	КонецЕсли;	
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

Процедура КлиентПриИзменении(Элемент)
	
	Если НЕ Клиент.Пустая() И НЕ Клиент.Безнал Тогда
		Сообщить("Для клиента " + Клиент + " не установлен признак безналичного расчета!"); 
		Клиент = Справочники.Клиенты.ПустаяСсылка();
	КонецЕсли;	
	
	ДокОснование = Неопределено;
	
КонецПроцедуры

Процедура БроньПриИзменении(Элемент)
	
	Клиент = ДокОснование.Клиент;
	
КонецПроцедуры
