﻿
Процедура КнопкаВыполнитьНажатие(Кнопка)
	Если ФорматКода = "Текст" Тогда
		QRКод = Текст;  
	ИначеЕсли ФорматКода = "Ссылка" Тогда
		Если Лев(СсылкаСтр,7)="http://" Тогда
			QRКод = СсылкаСтр;
		Иначе
			QRКод = "http://"+СсылкаСтр;
		КонецЕсли;
		QRКод=?(Прав(QRКод,1)="/",QRКод,QRКод+"/");
	ИначеЕсли ФорматКода = "WiFi" Тогда
		QRКод = "WIFI:"+"T:"+Шифрование+";"+"S:"+SSID+";"+"P:"+Пароль+";;";
	ИначеЕсли ФорматКода = "Событие" Тогда
		Если НЕ ЗначениеЗаполнено(ДатаНачала)ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончания)  Тогда
			Сообщить("Необходимо указать дату события." , СтатусСообщения.Важное);
			Возврат;
		КонецЕсли;
		
		QRКод="BEGIN:VEVENT"+Символы.ПС+ 
		      ?(НазваниеСобытия="","","SUMMARY:"+НазваниеСобытия+Символы.ПС)+
		      "DTSTART:"+Формат(УниверсальноеВремя(ДатаНачала),"ДФ=yyyyMMdd")+"T"+Формат(УниверсальноеВремя(ДатаНачала),"ДФ=HHmmss")+"Z"+Символы.ПС+
			  "DTEND:"+Формат(УниверсальноеВремя(ДатаОкончания),"ДФ=yyyyMMdd")+"T"+Формат(УниверсальноеВремя(ДатаОкончания),"ДФ=HHmmss")+"Z"+Символы.ПС+
		      ?(Расположение="","","LOCATION:"+Расположение+Символы.ПС)+
		      ?(("GEO:"+ШиротаСобытие+","+ДолготаСобытия)="GEO:,","","GEO:"+ШиротаСобытие+","+ДолготаСобытия+Символы.ПС)+
		      ?(Описание="","","DESCRIPTION:"+Описание+Символы.ПС)+
		      "END:VEVENT";
    Иначе
		QRКод="BEGIN:VCARD"+Символы.ПС+	
		      ?(Имя="","","N:;"+Имя+Символы.ПС)+
		      ?(Адрес="","","ADR:"+Адрес+Символы.ПС)+
              ?(("GEO:"+ШиротаКарта+","+ДолготаКарта)="GEO:,","","GEO:"+ШиротаКарта+","+ДолготаКарта+Символы.ПС)+
              ?(Телефон="","","TEL:"+Телефон+Символы.ПС)+
              ?(Email="","","EMAIL:"+Email+Символы.ПС)+
              ?(Сайт="","","URL:"+Сайт+Символы.ПС)+
              ?(Примечание="","","NOTE:"+Примечание+Символы.ПС)+
 		       "END:VCARD";
	КонецЕсли;	
	
	Если НЕ ЗначениеЗаполнено(QRКод) Тогда
		Сообщить("Необходимо указать данные для QR-кода." , СтатусСообщения.Важное);
		Возврат;
	КонецЕсли;
	
	Закрыть(QRКод);
КонецПроцедуры

Процедура ФорматКодаПриИзменении(Элемент)
	ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы[Элемент.Значение];
КонецПроцедуры

Процедура ЗаполнитьQRКод()
	
	Если Лев(QRКод,7) = "http://" Тогда
		ФорматКода = "Ссылка";
		СсылкаСтр = QRКод;
		
	ИначеЕсли Лев(QRКод,4) = "WIFI" Тогда
		ФорматКода = "WiFi";
		СимвS = Найти(QRКод,"S:");
		СимвP = Найти(QRКод,"P:");
		SSID = Сред(QRКод,СимвS+2,(СимвP-1)-(СимвS+2));
		Шифрование = Сред(QRКод,8,(СимвS-1)-8);
		Пароль = Сред(QRКод,СимвP+2,(СтрДлина(QRКод)-2)-(СимвP+1));
			
	ИначеЕсли Лев(QRКод,12) = "BEGIN:VEVENT" Тогда
		ФорматКода = "Событие";
		Для н = 1 По СтрЧислоСтрок(QRКод) Цикл
			ТекСтрока = СтрПолучитьСтроку(QRКод,н);
			Если Лев(ТекСтрока,8) = "SUMMARY:"  Тогда
				НазваниеСобытия = Сред(ТекСтрока,9,СтрДлина(ТекСтрока)-8);
			ИначеЕсли Лев(ТекСтрока,8) = "DTSTART:" Тогда
				ДатаНачала = МестноеВремя(Дата(Сред(ТекСтрока,9,8)+Сред(ТекСтрока,18,6)));
			ИначеЕсли Лев(ТекСтрока,6) = "DTEND:" Тогда
				ДатаОкончания = МестноеВремя(Дата(Сред(ТекСтрока,7,8)+Сред(ТекСтрока,16,6)));
			ИначеЕсли Лев(ТекСтрока,4) = "GEO:" Тогда
				Знак = Найти(ТекСтрока,",");
				Если Знак>0 Тогда
					ШиротаСобытие = Сред(ТекСтрока,5,Знак-5);
					ДолготаСобытия = Прав(ТекСтрока,СтрДлина(ТекСтрока)-Знак);
				КонецЕсли;
			ИначеЕсли Лев(ТекСтрока,9) = "LOCATION:" Тогда
				Расположение = Сред(ТекСтрока,10,СтрДлина(ТекСтрока)-9);
			ИначеЕсли Лев(ТекСтрока,12) = "DESCRIPTION:" Тогда
				Описание = Сред(ТекСтрока,13,СтрДлина(ТекСтрока)-12);
			КонецЕсли;
		КонецЦикла;
			
	ИначеЕсли Лев(QRКод,11) = "BEGIN:VCARD" Тогда
		ФорматКода = "Контакт";
		Для н = 1 По СтрЧислоСтрок(QRКод) Цикл
			ТекСтрока = СтрПолучитьСтроку(QRКод,н);
			Если Лев(ТекСтрока,3) = "N:;"  Тогда
				Имя = Сред(ТекСтрока,4,СтрДлина(ТекСтрока)-3);
			ИначеЕсли Лев(ТекСтрока,4) = "ADR:" Тогда
				Адрес = Сред(ТекСтрока,5,СтрДлина(ТекСтрока)-4);
			ИначеЕсли Лев(ТекСтрока,4) = "GEO:" Тогда
				Знак = Найти(ТекСтрока,",");
				Если Знак>0 Тогда
					ШиротаКарта = Сред(ТекСтрока,5,Знак-5);
					ДолготаКарта = Прав(ТекСтрока,СтрДлина(ТекСтрока)-Знак);
				КонецЕсли;
			ИначеЕсли Лев(ТекСтрока,4) = "TEL:" Тогда
				Телефон = Сред(ТекСтрока,5,СтрДлина(ТекСтрока)-4);
			ИначеЕсли Лев(ТекСтрока,6) = "EMAIL:" Тогда
				Email = Сред(ТекСтрока,7,СтрДлина(ТекСтрока)-6);
			ИначеЕсли Лев(ТекСтрока,4) = "URL:" Тогда
				Сайт = Сред(ТекСтрока,5,СтрДлина(ТекСтрока)-4);
			ИначеЕсли Лев(ТекСтрока,5) = "NOTE:" Тогда
				Примечание = Сред(ТекСтрока,6,СтрДлина(ТекСтрока)-5);
			КонецЕсли;
		КонецЦикла;		
		
	Иначе
		ФорматКода = "Текст";
		Текст = QRКод;
	Конецесли;

КонецПроцедуры

Процедура ПередОткрытием(Отказ, СтандартнаяОбработка)
	ЗаполнитьQRКод();
	ЭлементыФормы.Панель1.ТекущаяСтраница = ЭлементыФормы.Панель1.Страницы[ФорматКода];
КонецПроцедуры
