﻿Функция НайтиПоКодуВнутриИБ(Код, ИнфБаза=Неопределено) Экспорт
	
	Запрос = Новый Запрос("ВЫБРАТЬ ПЕРВЫЕ 1
	                      | Ссылка ИЗ Справочник.ПосадочныеМеста
	                      |ГДЕ
	                      |	Код = &Код И 
	                      |	ИнформационнаяБаза = &ИнфБаза
	                      |");
						  
	Запрос.УстановитьПараметр("ИнфБаза", ?(ИнфБаза=Неопределено, ПараметрыСеанса.ТекущаяИБ, ИнфБаза));
	Запрос.УстановитьПараметр("Код", Код);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат ПустаяСсылка();
	КонецЕсли;
	
КонецФункции

Процедура ОбнулитьПосадочныеМеста() Экспорт
	
	Выб = Справочники.ПосадочныеМеста.Выбрать();
	Пока Выб.Следующий() Цикл
	
		Если Не Выб.ЭтоГруппа Тогда
			Если Выб.ЗанятоМест Тогда
			
				об = Выб.ПолучитьОбъект();
				об.ЗанятоМест = 0;
				об.Записать();
			
			КонецЕсли; 
					
		КонецЕсли; 	
	
	КонецЦикла; 
КонецПроцедуры 
