﻿Процедура ОбновитьЗначение() Экспорт
	КлючЗадания =  "ОбновитьДатуОбновленияПризнакаНаличияВпродаже";
	мФЗ = ФоновыеЗадания.ПолучитьФоновыеЗадания(Новый Структура("Ключ, Состояние", КлючЗадания, СостояниеФоновогоЗадания.Активно));
	Если мФЗ.Количество() Тогда
		Возврат;
	КонецЕсли;
	Попытка
		ФЗ = ФоновыеЗадания.Выполнить("ВыполнениеРегламентныхЗаданий.ОбновитьДатуОбновленияПризнакаНаличияВпродаже",,КлючЗадания,КлючЗадания);
	Исключение
	КонецПопытки;

КонецПроцедуры
