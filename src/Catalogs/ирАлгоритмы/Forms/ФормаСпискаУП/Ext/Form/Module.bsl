﻿&НаКлиенте
Процедура КонсольКода(Команда)
	
	#Если ВебКлиент Тогда
		Сообщить("Команда недоступна в вебклиенте");
	#ИначеЕсли ТонкийКлиент Тогда
		ОткрытьФорму("Обработка.ирПортативный.Форма.ФормаУправляемая");
	#Иначе
		ТекущаяСтрока = Элементы.Список.ТекущаяСтрока;
		Если ТекущаяСтрока = Неопределено Тогда
			Возврат;
		КонецЕсли; 
		Справочники[ирОбщий.ОтделитьРазделителемЛкс(Список.ОсновнаяТаблица)].ОткрытьКонсольКодаДляАлгоритма(ТекущаяСтрока.Ссылка);
	#КонецЕсли

КонецПроцедуры

&НаКлиенте
Процедура НастройкиВыполненияАлгоритмов(Команда)
	
	ирОбщий.ОткрытьНастройкиАлгоритмовЛкс();
	
КонецПроцедуры
