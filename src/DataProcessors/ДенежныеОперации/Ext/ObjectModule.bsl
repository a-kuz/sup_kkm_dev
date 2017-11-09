﻿Перем Получено Экспорт;

Функция Внесение() Экспорт
	
	СменаТТ = ИнтерфейсРМ.ТекущаяСмена();
	Если СменаТТ.Пустая() Тогда
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка внесения","Смена ТТ не открыта","","","ОК","");
		Возврат Ложь;
	КонецЕсли;
	
	СменаКасса = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы();
	Если СменаКасса.Пустая() ТОгда
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка внесения","Кассовая смена не открыта","","","ОК","");
		Возврат Ложь;
	КонецЕсли;
	
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ,Обработка_ККМ,глПараметрыРМ);
	ВхПараметры = Получено;
	ВыхПараметры = новый Структура;
	
	ПечатьУдалась = Ложь;
	Если СтрНайти(ККМ.ИмяОбработки,"326") <> 0 тогда // для НФР
		Пока Истина Цикл
			Если ПечатьУдалась Тогда
				Прервать;
			КонецЕсли;
			Попытка
				ВхПараметры = Получено;
				ВыхПараметры = новый Структура;
				Ответ = Обработка_ККМ.ВыполнитьКоманду("Внесение",ВхПараметры,ВыхПараметры);
			Исключение
				ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
				Возврат Ложь;
			КонецПопытки;
			
			Если не Ответ Тогда
				Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
					ТекстОшибки = "";
					ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
					Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
						ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
					КонецЦикла;
					Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос", "Ошибка внесения" , "Чек распечатался?", "Да","","Esc=Нет") <> "Да" Тогда
						Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос", "Ошибка внесения" , "Повторить печать?", "Да","","Esc=Нет") <> "Да" Тогда
							ИнтерфейсРМ.ВопросПредупреждение("Ошибка внесения",ТекстОшибки,"","","ОК","");
							Прервать;
						Иначе
							Продолжить;
						КонецЕсли;
					Иначе
						ПечатьУдалась = Истина;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ПечатьУдалась = Истина;
			КонецЕсли;
		КонецЦикла;
	иначе
		Попытка
			Ответ = Обработка_ККМ.ВыполнитьКоманду("Внесение",ВхПараметры,ВыхПараметры);
		Исключение
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
			Возврат Ложь;
		КонецПопытки;
		
		Если не Ответ Тогда
			Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
				ТекстОшибки = "";
				ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
				Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
					ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
				КонецЦикла;
				ИнтерфейсРМ.ВопросПредупреждение("Ошибка внесения",ТекстОшибки,"","","ОК","");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Попытка
		ОтветД = Обработка_ККМ.ВыполнитьКоманду("ОткрытьДенежныйЯщик",ВхПараметры,ВыхПараметры);
	Исключение
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
		Возврат Ложь;
	КонецПопытки;
	
	Если не ОтветД Тогда
		Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = "";
			ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
			Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
				 ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
			КонецЦикла;
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка открытия денежного ящика",ТекстОшибки,"","","ОК","");
		КонецЕсли;
	КонецЕсли;
	
	//Ответ = истина;
	// формирование документа Внесение
	Если Ответ или (СтрНайти(ККМ.ИмяОбработки,"326") <> 0 и ПечатьУдалась) Тогда
		Внесение = Документы.Касса_Внесение.СоздатьДокумент();
		Внесение.Автор = глПользователь;
		Внесение.Дата = ТекущаяДатаСеанса();
		Внесение.Касса = глПараметрыРМ.ККМ;
		Внесение.РабочееМесто = глРабочееМесто;
		Внесение.СменаТТ = СменаТТ;
		Внесение.СменаКассы = СменаКасса;
		Внесение.Сумма = Получено;
		Если не ИнтерфейсРМ.ПопыткаДействияСОбъектом(Внесение,"Объект.Записать(РежимЗаписиДокумента.Проведение)") Тогда
			Ответ = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

Функция Выплата(Фирма = Неопределено) Экспорт
	
	СменаТТ = ИнтерфейсРМ.ТекущаяСмена();
	Если СменаТТ.Пустая() Тогда
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка выплаты","Смена ТТ не открыта","","","ОК","");
		Возврат Ложь;
	КонецЕсли;
	
	СменаКасса = Обработки.ОткрытиЗакрытиеСменыКасса.ПолучитьСменуКассы();
	Если СменаКасса.Пустая() ТОгда
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка выплаты","Кассовая смена не открыта","","","ОК","");
		Возврат Ложь;
	КонецЕсли;
	
	ККМ=глПараметрыРМ.ККМ.ПолучитьОбъект();
	Обработка_ККМ=Обработка_ККМ;
	ИнициализацияТО(ККМ,Обработка_ККМ,глПараметрыРМ);
	
	Если глПараметрыРМ.ККМЕстьДоп тогда
		Попытка
			ККМ1 = глПараметрыРМ.ККМСписокДоп[0].Значение.ПолучитьОбъект();
			Обработка_ККМ1 = Обработка_ККМ1;
			ИнициализацияТО(ККМ1, Обработка_ККМ1, глПараметрыРМ);
		Исключение
			ККМ1 = Неопределено;
		КонецПопытки;
	Иначе
		ККМ1 = Неопределено;
	КонецЕсли;

	ВхПараметры = Получено;
	ВыхПараметры = новый Структура;
	
	ПечатьУдалась = Ложь;
	Если СтрНайти(ККМ.ИмяОбработки,"326") <> 0 тогда // для НФР
		Пока Истина Цикл
			Если ПечатьУдалась Тогда
				Прервать;
			КонецЕсли;
			Попытка
				ВхПараметры = Получено;
				ВыхПараметры = новый Структура;
				Ответ = Обработка_ККМ.ВыполнитьКоманду("Выемка",ВхПараметры,ВыхПараметры);
			Исключение
				ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
				Возврат Ложь;
			КонецПопытки;
			Если не Ответ Тогда
				Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
					ТекстОшибки = "";
					ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
					Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
						ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
					КонецЦикла;
					Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос", "Ошибка выплаты" , "Чек распечатался?", "Да","","Esc=Нет") <> "Да" Тогда
						Если ИнтерфейсРМ.ВопросПредупреждение("Вопрос", "Ошибка выплаты" , "Повторить печать?", "Да","","Esc=Нет") <> "Да" Тогда
							ИнтерфейсРМ.ВопросПредупреждение("Ошибка выплаты",ТекстОшибки,"","","ОК","");
							Прервать;
						Иначе
							Продолжить;
						КонецЕсли;
					Иначе
						ПечатьУдалась = Истина;
						Прервать;
					КонецЕсли;
				КонецЕсли;
			Иначе
				ПечатьУдалась = Истина;
			КонецЕсли;
		КонецЦикла;
	иначе
		Попытка
			Если ККМ1 <> Неопределено и Фирма = 1 Тогда
				Ответ = Обработка_ККМ1.ВыполнитьКоманду("Выемка",ВхПараметры,ВыхПараметры);
			Иначе
				Ответ = Обработка_ККМ.ВыполнитьКоманду("Выемка",ВхПараметры,ВыхПараметры);
			КонецЕсли;
		Исключение
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
			Возврат Ложь;
		КонецПопытки;
		
		Если не Ответ Тогда
			Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
				ТекстОшибки = "";
				ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
				Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
					ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
				КонецЦикла;
				ИнтерфейсРМ.ВопросПредупреждение("Ошибка выплаты",ТекстОшибки,"","","ОК","");
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Попытка
		ОтветД = Обработка_ККМ.ВыполнитьКоманду("ОткрытьДенежныйЯщик",ВхПараметры,ВыхПараметры);
	Исключение
		ИнтерфейсРМ.ВопросПредупреждение("Ошибка", "Ошибка ККМ", ОписаниеОшибки(), "","ОК", "");
		Возврат Ложь;
	КонецПопытки;
	
	Если не ОтветД Тогда
		Если ВыхПараметры.Свойство("ОписаниеОшибки") Тогда
			ТекстОшибки = "";
			ОписаниеОшибки = ВыхПараметры.ОписаниеОшибки;
			Для к = 0 по ОписаниеОшибки.Количество()-1 Цикл
				 ТекстОшибки = ТекстОшибки + ОписаниеОшибки[к];
			КонецЦикла;
			ИнтерфейсРМ.ВопросПредупреждение("Ошибка открытия денежного ящика",ТекстОшибки,"","","ОК","");
		КонецЕсли;
	КонецЕсли;
	
	// формирование документа Внесение
	Если Ответ или (СтрНайти(ККМ.ИмяОбработки,"326") <> 0 и ПечатьУдалась) Тогда
		Выплата = Документы.Касса_Изъятие.СоздатьДокумент();
		Выплата.Автор = глПользователь;
		Выплата.Дата = ТекущаяДатаСеанса();
		Выплата.Касса = глПараметрыРМ.ККМ;
		Выплата.РабочееМесто = глРабочееМесто;
		Выплата.СменаТТ = СменаТТ;
		Выплата.СменаКассы = СменаКасса;
		Выплата.Сумма = Получено;
		Если не ИнтерфейсРМ.ПопыткаДействияСОбъектом(Выплата,"Объект.Записать(РежимЗаписиДокумента.Проведение)") Тогда
			Ответ = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции

