﻿
Функция ТекстGv() Экспорт
	
	Шаблон=ссылка;
	
	Выб = Справочники.ЭлементыДиалогов.ВыбратьИерархически(,Шаблон,,"");
	Стр="";ОписанияВершин = "";
	ПОка Выб.Следующий() Цикл
		Style_="";
		ЕСли Выб.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Вопрос Тогда
			Фигура = "record";
			Style_="style=rounded,";
		ИначеЕСли Выб.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Выход ИЛИ Выб.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Старт Тогда
			Фигура = "box3d";
			
		ИначеЕСли Выб.Родитель.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Вопрос Тогда
			Фигура = "circle";
		ИначеЕСли Выб.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Сообщение Тогда
			Фигура = "egg";

			
		Иначе
			Фигура = "box";
			Style_="style=rounded,";

		КонецЕсли;
		
		
		УИД="N"+Выб.Ссылка.УникальныйИдентификатор();
		УИДРодителя="N"+Выб.Родитель.УникальныйИдентификатор();
		УИДРодителяРодителя="N"+Выб.Родитель.Родитель.УникальныйИдентификатор();
		Если Выб.СледующийЭлемент = Неопределено  Тогда
		
			УИДСлед = "Неопределено";
		Иначе 
			
			УИДСлед="N"+Выб.СледующийЭлемент.УникальныйИдентификатор();
		
		КонецЕсли; 
		
		
		УИД = СтрЗаменить(УИД,"-","");
		УИДРодителя = СтрЗаменить(УИДРодителя,"-","");
		УИДРодителяРодителя = СтрЗаменить(УИДРодителяРодителя,"-","");
		УИДСлед = СтрЗаменить(УИДСлед,"-","")         ;
		
		Если Выб.Родитель.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Вопрос Тогда
			УИД = УИДРодителя;
		КонецЕсли;
		
		Label = Выб.Наименование;
		Если Фигура = "record" Тогда
			Label = СтрЗаменить(Label," ",Символы.НПП);
			Label = СтрЗаменить(Label,":"," | ");
			
			
			Label ="{ "+Label+"|{<1> Да |<2> Нет } }";
		Иначе
			
			Label = СтрЗаменить(Label,"Сообщение:","Сообщение"+Символы.ПС);
			Label = СтрЗаменить(Label,":",Символы.ПС);
			
		КонецЕсли;
		
		Если Не УИД = УИДРодителя Тогда
		
			ОписанияВершин = ОписанияВершин + " "+УИД+"["+Style_+"shape="+Фигура+",label="""+Label+""",rank="""+лев(Выб.НомерПП,1)+Выб.УровеньВВыборке()+"""]";	
		Иначе
			
		КонецЕсли; 
		
		
		Стр = Стр+" ";
			
		Если НЕ Выб.Родитель.Пустая() Тогда
			Если Не УИД = УИДРодителя Тогда
 				Если Выб.Родитель.Родитель.ТипЭлементаДиалога = Справочники.ТипыЭлементовДиалогов.Вопрос Тогда
				
					стр = Стр+УИДРодителяРодителя +":"+ ?(Выб.Родитель.Наименование="Да",1,2)+"->"+ УИД;	
				ИНаче
					стр = Стр+УИДРодителя +"->"+ УИД;	
				
				КонецЕсли; 
				
			Иначе
				стр = Стр+УИД;	
			КонецЕсли;
		Иначе
			//стр = Стр+УИД;
		КОнецЕсли;
		
		Если ЗначениеЗаполнено(Выб.СледующийЭлемент) Тогда
			Стр = СТр + "->"+ УИДСлед;		
		КонецЕсли;
		Стр=Стр+Символы.ПС;
	Конеццикла;
	Возврат ("digraph TrafficLights {
	|node[fontname=""segoe ui""]
	|")+(ОписанияВершин)+" "+(стр)+("} ");

КонецФункции // ТекстGv()
 
