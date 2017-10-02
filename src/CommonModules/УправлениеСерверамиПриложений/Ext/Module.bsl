﻿// Выполняет динамическое обновление конфигурации БД. 
// Если требуется рестуктуризация, обновление произойдет, только если база свободна
Функция ОбновитьКонфигурациюБД(ИнформационнаяБаза, Синхронно = Ложь) Экспорт
	Платформа = ирКэш.Получить();
	//:ИнформационнаяБаза = Справочники.ИнформационныеБазы.НайтиПоКоду();
	//:Платформа = Обработки.ирПлатформа.Создать();
	Сервер = ИнформационнаяБаза.СерверХост;
	ЭтоX64 = СтрНайти(НРег(Сервер), "ost") > 0;
	Если Не ИнформационнаяБаза.Предопределенный Тогда
		Сеть.ПодключитьШару(Сервер, Истина);
	КонецЕсли;
	
	Пользователь 			= ?(ЭтоX64, "Администратор", "Администратор ТТ");
	Пароль 					= ?(ЭтоX64, "F54eTylfm8", "1");
	УИД						= СтрЗаменить(Строка(Новый УникальныйИдентификатор),"-","");
	ПутьКфайлуАут 			= "\\"+Сервер+"\c$\temp\ExchangeOut"+УИД+".txt";
	локПутьКфайлуАут 		= "c:\temp\ExchangeOut"+УИД+".txt";
	ПутьКплатформе 			= ?(ЭтоX64, "C:\Program Files (x86)\1cv8\8.3.10.2561\bin\1cv8.exe", "C:\Program Files\1cv8\8.3.10.2561\bin\1cv8.exe");
	ПутьКфайлуРезультата 	= "\\"+Сервер+"\c$\temp\cfgUpdateResult"+УИД+".txt";
	локПутьКфайлуРезультата = "c:\temp\cfgUpdateResult"+УИД+".txt";

	
	#Если Клиент Тогда
		Платформа.sleep(1);
	#КонецЕсли
	
	Команда = "psexec \\"+Сервер + " -u """ + Пользователь + """ -p " + Пароль + " -accepteula -i " + """"+ПутьКплатформе+""" designer /S" + Сервер + "\sup_kkm /NАдминистратор /p""19643003"" /DisableStartupMessages  /UC123 /UpdateDBCfg -Server /DumpResult" + локПутьКфайлуРезультата + " /Out" + локПутьКфайлуАут;
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(СтрЗаменить(Команда,"8.3.10.2561","8.3.10.2561"),,,,Синхронно);
	Возврат Новый Структура("ИнформационнаяБаза, ПутьКфайлуАут, ПутьКфайлуРезультата, ПроцессЗавершен, Успех, ВремяЗапуска, ОписаниеОшибки", ИнформационнаяБаза, ПутьКфайлуАут, ПутьКфайлуРезультата, Ложь, Ложь, ТекущаяДатаНаСервере(), "");
КонецФункции

Функция ЗапуститьОбменДанными(ИнформационнаяБаза, Синхронно = Ложь) Экспорт
	Платформа = ирКэш.Получить();
	//:ИнформационнаяБаза = Справочники.ИнформационныеБазы.НайтиПоКоду();
	//:Платформа = Обработки.ирПлатформа.Создать();
	Сервер = ИнформационнаяБаза.СерверХост;
	ЭтоX64 = СтрНайти(НРег(Сервер), "ost") > 0;
	Если Не ИнформационнаяБаза.Предопределенный Тогда
		Сеть.ПодключитьШару(Сервер, Истина);
	КонецЕсли;
	
	Пользователь 			= ?(ЭтоX64, "Администратор", "Администратор ТТ");
	Пароль 					= ?(ЭтоX64, "F54eTylfm8", "1");
	УИД						= СтрЗаменить(Строка(Новый УникальныйИдентификатор),"-","");
	ПутьКфайлуАут 			= "\\"+Сервер+"\c$\temp\ExchangeOut"+УИД+".txt";
	локПутьКфайлуАут 		= "c:\temp\ExchangeOut"+УИД+".txt";
	ПутьКплатформе 			= ?(ЭтоX64, "C:\Program Files (x86)\1cv8\8.3.10.2561\bin\1cv8.exe", "C:\Program Files\1cv8\8.3.10.2561\bin\1cv8.exe");
	
	Команда = "psexec \\"+Сервер + " -u """ + Пользователь + """ -p " + Пароль + " -accepteula" + " -i " + """"+ ПутьКплатформе + """ enterprise /S" + 
	Сервер + "\sup_kkm /NАдминистратор /p""19643003"" /DisableStartupMessages /RunModeOrdinaryApplication /CВыполнитьОбменДанными /UC123 /Out" + локПутьКфайлуАут;
	
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(СтрЗаменить(Команда,"8.3.10.2561","8.3.10.2561"), КаталогВременныхФайлов(), , Строка(Новый УникальныйИдентификатор())+".txt", Синхронно);
	Возврат Новый Структура("ИнформационнаяБаза, ПутьКфайлуАут, ПроцессЗавершен, Успех, ВремяЗапуска, ОписаниеОшибки", ИнформационнаяБаза, ПутьКфайлуАут, Ложь, Ложь, ТекущаяДатаНаСервере(), "");
КонецФункции

Функция ВыполнитьЗагрузкуТоваров(ИнформационнаяБаза) Экспорт
	Платформа = ирКэш.Получить();
	//:ИнформационнаяБаза = Справочники.ИнформационныеБазы.НайтиПоКоду();
	//:Платформа = Обработки.ирПлатформа.Создать();
	Сервер = ИнформационнаяБаза.СерверХост;
	Если Не ИнформационнаяБаза.Предопределенный Тогда
		Сеть.ПодключитьШару(Сервер, Истина);
	КонецЕсли;
	
	Пользователь 			= "Администратор ТТ";
	Пароль 					= "1";
	ПутьКфайлуАут 			= "\\"+Сервер+"\c$\temp\ExchangeOut.txt";
	локПутьКфайлуАут 		= "c:\temp\ExchangeOut.txt";
	
	Попытка
		УдалитьФайлы(ПутьКфайлуАут);    	
	Исключение
	КонецПопытки;
	
	Команда = "psexec \\"+Сервер + " -u """ + Пользователь + """ -p " + Пароль + " -accepteula" + " -i " + """C:\Program Files\1cv8\common\1cestart.exe"" enterprise /S" + 
	Сервер + "\sup_kkm /NАдминистратор /p""19643003"" /DisableStartupMessages /RunModeOrdinaryApplication /CОбновлениеТоваров /Out" + локПутьКфайлуАут;
	
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда, КаталогВременныхФайлов(), , Строка(Новый УникальныйИдентификатор())+".txt", Ложь);
	
	Возврат Новый Структура("ИнформационнаяБаза, ПутьКфайлуАут, ПроцессЗавершен, Успех, ВремяЗапуска, ОписаниеОшибки", ИнформационнаяБаза, ПутьКфайлуАут, Ложь, Ложь, ТекущаяДатаНаСервере(), "");	
КонецФункции

Функция ВыгрузитьDT(ИнформационнаяБаза) Экспорт
	Платформа = ирКэш.Получить();//:Платформа = Обработки.ирПлатформа.Создать();
	
	Хост = ИнформационнаяБаза.СерверХост;
	Сеть.ПодключитьШару(Хост, Истина);

	ПутьКфайлуАут 			= "\\" + Хост + "\c$\temp\ВыгрузитьDT.txt";
	локПутьКфайлуАут 		= "c:\temp\ВыгрузитьDT.txt";

	ПутьКфайлуВыгрузки 		= "\\" + Хост + "\c$\temp\sup_kkm.dt";
	локПутьКфайлуВыгрузки	= "c:\temp\sup_kkm.dt";
	
	Попытка
		УдалитьФайлы(ПутьКфайлуВыгрузки);
		УдалитьФайлы(ПутьКфайлуАут);	
	Исключение
	КонецПопытки;
	Команда = "psexec \\" + Хост + " -accepteula -i " + """C:\Program Files\1cv8\8.3.10.2561\bin\1cv8.exe"" DESIGNER /S" + 
	Хост + "\sup_kkm /NАдминистратор /p""19643003"" /UC123 /DumpIB " + локПутьКфайлуВыгрузки + " /Out" + локПутьКфайлуАут;
	
	КраткоеИмяФайла = Строка(Новый УникальныйИдентификатор());
	Сообщить(Команда);
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда, КаталогВременныхФайлов(), , КраткоеИмяФайла, Истина);
	Сообщить(РаботаСФайлами.ИзвлечьТекст(КаталогВременныхФайлов()+КраткоеИмяФайла,КодировкаТекста.OEM, Истина));
	
	Возврат Новый Структура("ИнформационнаяБаза, ПутьКфайлуАут, ПроцессЗавершен, Успех, ВремяЗапуска, ОписаниеОшибки, ПутьКфайлуВыгрузки", ИнформационнаяБаза, ПутьКфайлуАут, Ложь, Ложь, ТекущаяДатаНаСервере(), "", ПутьКфайлуВыгрузки);
КонецФункции

Функция ПутьКзапускателюПлатформы(ИнформационнаяБаза) Экспорт
	//Платформа = ирКэш.Получить();
	//
	//Хост = ИнформационнаяБаза.СерверХост;
	//Сеть.ПодключитьШару(Хост, Истина);
	
	
КонецФункции

Функция ОбрезатьЖурналРегистрации(ИнформационнаяБаза, Синхронно = Истина) Экспорт
	Платформа = ирКэш.Получить();
	
	Хост = ИнформационнаяБаза.СерверХост;
	Сеть.ПодключитьШару(Хост, Истина);

	ПутьКфайлуАут 			= "\\" + Хост + "\c$\temp\ОбрезатьЖурналРегистрации.txt";
	локПутьКфайлуАут 		= "c:\temp\ОбрезатьЖурналРегистрации.txt";
	
	Попытка
		УдалитьФайлы(ПутьКфайлуАут);	
	Исключение
	КонецПопытки;
	
	ДатаОбрезки = Формат(ТекущаяДата()-86400*Константы.ГлубинаАрхива.Получить(),"ДФ=yyyy-MM-dd");
	Команда = "psexec \\" + Хост + " -accepteula -i " + """C:\Program Files\1cv8\8.3.10.2561\bin\1cv8.exe"" DESIGNER /S" + 
	Хост + "\sup_kkm /NАдминистратор /p""19643003"" /UC123 /ReduceEventLogSize " + ДатаОбрезки + " /Out" + локПутьКфайлуАут;
	
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда, КаталогВременныхФайлов(), , Строка(Новый УникальныйИдентификатор())+".txt", Синхронно);
	
	Возврат Новый Структура("ИнформационнаяБаза, ПутьКфайлуАут, ПроцессЗавершен, Успех, ВремяЗапуска, ОписаниеОшибки", ИнформационнаяБаза, ПутьКфайлуАут, Ложь, Ложь, ТекущаяДатаНаСервере(), "");
КонецФункции

Функция ПерезапускСлужбы(ИнформационнаяБаза, Остановить = Истина, Запустить = Истина) Экспорт
	Платформа = ирКэш.Получить();
	//:Платформа = Обработки.ирПлатформа.Создать();
	
	Хост = ИнформационнаяБаза.СерверХост;
	Сеть.ПодключитьШару(Хост, Истина);
	
	Попытка
		ЗавершитьСеансы(ИнформационнаяБаза);	
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Если Остановить Тогда
		
		Уид = Строка(Новый УникальныйИдентификатор);
		Команда = СтрШаблон("psservice \\%1 stop ""1C:Enterprise 8.3 Server Agent""", Хост);
		Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда,КаталогВременныхФайлов(),,"psservice.txt"+Уид);
		Ч = Новый ЧтениеТекста(КаталогВременныхФайлов()+"psservice.txt"+Уид, КодировкаТекста.OEM);
		Результат = Ч.Прочитать();
		Ч.Закрыть();
		#Если Клиент Тогда
			Платформа.sleep(10);
		#Иначе
			Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 10 127.0.0.1");
		#КонецЕсли
		
		Команда2 = СтрШаблон("pskill \\%1", Хост);
		
		Команда2_1 = СтрШаблон("%1 rmngr", Команда2);
		Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда2_1,,,"pskill.txt"+Уид);
		
		Команда2_2 = СтрШаблон("%1 ragent", Команда2);
		Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда2_2,,,"pskill2.txt"+Уид);
		
		Команда2_3 = СтрШаблон("%1 rphost", Команда2);
		Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда2_3,,,"pskill3.txt"+Уид);
		
		Команда2_4 = СтрШаблон("%1 1cv8", Команда2);
		Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда2_4,,,"pskill4.txt"+Уид);
	КонецЕсли;
	Если Запустить Тогда
		Команда = СтрШаблон("psservice \\%1 start ""1C:Enterprise 8.3 Server Agent""", Хост);
		Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда,,,"psservice2.txt"+Уид);
		Ч = Новый ЧтениеТекста(КаталогВременныхФайлов()+"psservice2.txt"+Уид, "windows-1251");
		Результат = Ч.Прочитать();
		Ч.Закрыть();
	КонецЕсли;
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 15 127.0.0.1");
	Возврат Результат;
КонецФункции

Функция ЗавершитьСеансы(ИнформационнаяБаза) Экспорт
	Соединитель = Новый COMObject("V83.COMConnector");
	Попытка
		Агент = Соединитель.ConnectAgent(ИнформационнаяБаза.СерверХост);
	Исключение
		Соединитель = Новый COMObject("V83.COMConnector_8.3.10.2561");
		Агент = Соединитель.ConnectAgent(ИнформационнаяБаза.СерверХост);
	КонецПопытки;

	Агент = Соединитель.ConnectAgent(ИнформационнаяБаза.СерверХост);
	
	Кластеры = Агент.GetClusters();
	Кластер = Кластеры.GetValue(0);
	
	Агент.Authenticate(Кластер,"","");
	Сеансы = Агент.GetSessions(Кластер).Выгрузить();
	Для Каждого Сеанс Из Сеансы Цикл
		Агент.TerminateSession(Кластер, Сеанс);
	КонецЦикла;
КонецФункции

Функция УстановитьБлокировкуСоединений(ИнформационнаяБаза, БлокировкаСоединений = Истина, БлокировкаФоновыхЗаданий = Истина) Экспорт
	Соединитель = Новый COMObject("V83.COMConnector");
	Попытка
		Агент = Соединитель.ConnectAgent(ИнформационнаяБаза.СерверХост);
	Исключение
		Соединитель = Новый COMObject("V83.COMConnector_8.3.10.2561");
		Агент = Соединитель.ConnectAgent(ИнформационнаяБаза.СерверХост);
	КонецПопытки;
		
	Кластеры = Агент.GetClusters();
	Кластер = Кластеры.GetValue(0);
	
	Агент.Authenticate(Кластер,"","");
	РабочиеПроцессы = Агент.GetWorkingProcesses(Кластер);
	РабочийПроцесс = РабочиеПроцессы.GetValue(0);
	HostName = РабочийПроцесс.HostName;
	MainPort = РабочийПроцесс.MainPort;
	Попытка
		СоединениесРабочимПроцессом = Соединитель.ConnectWorkingProcess("tcp://"+HostName+":" + Формат(MainPort,"ЧГ=0"));
	Исключение
		СоединениесРабочимПроцессом = Соединитель.ConnectWorkingProcess("tcp://"+HostName+":"+"1560");
	КонецПопытки;
	
	СоединениесРабочимПроцессом.AuthenticateAdmin("","");
	СоединениесРабочимПроцессом.AddAuthentication("Администратор","19643003");
	Базы = СоединениесРабочимПроцессом.GetInfoBases();
	фНашли = Ложь;
	Для Каждого База Из Базы Цикл
		Если СтрНайти(НРег(База.Name), "sup_kkm") Тогда
			фНашли = Истина;
			Прервать
		КонецЕсли;
	КонецЦикла;
	
	Если фНашли Тогда
		База.SessionsDenied = БлокировкаСоединений;
		База.ScheduledJobsDenied = БлокировкаФоновыхЗаданий;
		База.PermissionCode = "123";
		База.DeniedTo = ТекущаяДата() + 360;
		СоединениесРабочимПроцессом.UpdateInfoBase(База);
	КонецЕсли;
	
	
КонецФункции

// Создает файловую базу из файла выгрузки 
Функция СоздатьБазуИзDT(ИнформационнаяБаза, Хост) Экспорт

	Платформа = ирКэш.Получить();
	Сервер = ИнформационнаяБаза.СерверХост;
	
	

	ПутьКфайлуАут 			= "\\" + Хост + "\c$\CreateIBout.txt";
	локПутьКфайлуАут 		= "c:\CreateIBout.txt";
	
	ПутьКфайлуВыгрузки 		= "\\" + Сервер + "\c$\temp\sup_kkm.dt";
	локПутьКфайлуВыгрузки 	= "c:\temp\sup_kkm.dt";
	
	Если Сеть.ПодключитьШару(Сервер, Истина) Тогда
		
		Попытка
			Сообщить("КопироватьФайл(""\\"" + Хост + ""\c$\sup_kkm\1cv8.1cd"", ""\\"" + Хост + ""\c$\temp\1cv8.1cd"")");
			Сеть.КопироватьФайлУдаленно("\\" + Хост + "\c$\sup_kkm\1cv8.1cd", "\\" + Хост + "\c$\temp\1cv8.1cd");
		Исключение
		КонецПопытки;
		
		
		ФайлВыгрузки = Новый Файл(ПутьКфайлуВыгрузки);
		
		Если ФайлВыгрузки.Существует() Тогда
			Если ФайлВыгрузки.Размер() < 20000000 Тогда
				Сообщить("dt слишком маленькая");
				Возврат Ложь;
			КонецЕсли;
		КонецЕсли;
		
		Попытка
			УдалитьФайлы("\\" + Хост + "\c$\sup_kkm\*");
			УдалитьФайлы(ПутьКфайлуАут);	
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;

	КонецЕсли;
	
	Команда = СтрШаблон("PSEXEC \\%1 -U ""Администратор ТТ"" -P 1 CMD /CDEL C:\sup_kkm\* /q", Хост);		
	КраткоеИмяФайла = Строка(Новый УникальныйИдентификатор());
	Сообщить(Команда);
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда, КаталогВременныхФайлов(), , КраткоеИмяФайла, Истина);
	Сообщить(РаботаСФайлами.ИзвлечьТекст(КаталогВременныхФайлов()+КраткоеИмяФайла,КодировкаТекста.OEM, Истина));
	Сообщить(ПутьКфайлуАут + ": " + РаботаСФайлами.ИзвлечьТекст(ПутьКфайлуАут,, Истина));	
	
	
	Команда = "psexec \\" + Хост + " -accepteula -i " + """C:\Program Files\1cv8\8.3.10.2561\bin\1cv8.exe""" + 
	" CREATEINFOBASE file=c:\sup_kkm /UseTemplate" + локПутьКфайлуВыгрузки + " /Out" + локПутьКфайлуАут;
	
	КраткоеИмяФайла = Строка(Новый УникальныйИдентификатор());
	Сообщить(Команда);
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(Команда, КаталогВременныхФайлов(), , КраткоеИмяФайла, Истина);
	Сообщить(РаботаСФайлами.ИзвлечьТекст(КаталогВременныхФайлов()+КраткоеИмяФайла,КодировкаТекста.OEM, Истина));
	Сообщить(ПутьКфайлуАут + ": " + РаботаСФайлами.ИзвлечьТекст(ПутьКфайлуАут,, Истина));
	
	Если Сеть.ПодключитьШару(Хост, Истина) Тогда
		Файлы = НайтиФайлы("\\"+Хост+"\c$\sup_kkm\","*");
		Для Каждого Файл Из файлы цикл
			Если Нрег(Файл.Расширение) <> ".1cd" Тогда
				Попытка
					УдалитьФайлы(Файл.ПолноеИмя);
				исключение
				конецпопытки;
				
			КонецЕсли;
		КонецЦикла
		
		
	КонецЕсли;
	
	Возврат Новый Структура("ИнформационнаяБаза, ПутьКфайлуАут, ПроцессЗавершен, Успех, ВремяЗапуска, ОписаниеОшибки, ПутьКфайлуВыгрузки", ИнформационнаяБаза, ПутьКфайлуАут, Ложь, Ложь, ТекущаяДатаНаСервере(), "", ПутьКфайлуВыгрузки);
КонецФункции

// Функция вызывается при открытии кассовой смены локально на кассовом РМ
Функция СоздатьЛокальнуюФайловуюБазу() Экспорт
	ЗаписьЖурналаРегистрации("СоздатьЛокальнуюФайловуюБазу");
	Если ПроцедурыОбменаДанными.ОпределитьЭтаИнформационнаяБазаФайловая() Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Платформа = ирКэш.Получить();
	Cервер = ПараметрыСеанса.ТекущаяИБ.СерверХост;
	Сеть.ОтключитьШары();
	Сеть.ПодключитьШару(Cервер, Истина);
	
	ПутьКпапкеСбазойНаСервере = СтрШаблон("\\%1\c$\sup_kkm", Cервер);
	локПутьКпапкеСбазой = "c:\sup_kkm";
	СоздатьКаталог(локПутьКпапкеСбазой);
	
	ПапкаНаСервере = Новый Файл(ПутьКпапкеСбазойНаСервере);
	Если ПапкаНаСервере.Существует() Тогда
		Файлы = НайтиФайлы(ПутьКпапкеСбазойНаСервере,"*.1CD");
		Сеть.ПодключитьШару(Cервер, Истина);
		Для Каждого Файл Из Файлы Цикл
			Если Файл.Размер() > 5000000 Тогда
				КомандаКопирования = СтрШаблон("xcopy %1\1cv8.1CD %2 /D /V /Y", ПутьКпапкеСбазойНаСервере, локПутьКпапкеСбазой);
				Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения(КомандаКопирования,,,,Ложь);
				Прервать;
			КонецЕсли;			
		КонецЦикла;
		
		Результат = Истина;
	Иначе
		Результат = Ложь;
	КонецЕсли;
	Возврат Результат;
КонецФункции

Функция МассивОбменов(Знач МассивУзлов) Экспорт
	З = Новый Запрос("ВЫБРАТЬ
	|	НастройкиОбменаДанными.Ссылка КАК Ссылка,
	|	НастройкиОбменаДанными.КаталогОбменаИнформацией КАК КаталогОбменаИнформацией
	|ИЗ
	|	Справочник.НастройкиОбменаДанными КАК НастройкиОбменаДанными
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ПланОбмена.Основной КАК Основной
	|		ПО НастройкиОбменаДанными.УзелИнформационнойБазы = Основной.Ссылка
	|ГДЕ
	|	НЕ НастройкиОбменаДанными.ПроизводитьПриемСообщений
	|	И НастройкиОбменаДанными.ПроизводитьОтправкуСообщений
	|	И НЕ Основной.Центр
	|	И НЕ НастройкиОбменаДанными.ПометкаУдаления
	|	И НЕ Основной.ПометкаУдаления
	|	И Основной.Ссылка В (&МассивУзлов)");

	З.УстановитьПараметр("МассивУзлов", МассивУзлов);

	ТЗ = З.Выполнить().Выгрузить();
	МассивОбменов  = ТЗ.ВыгрузитьКолонку(0);
	Для каждого Т Из Тз Цикл
		Сеть.ПодключитьШару(Т.КаталогОбменаИнформацией, Истина);	
	КонецЦикла;
	
	Возврат МассивОбменов;
КонецФункции

Процедура ПерезапускСлужбыИобновлениеКонфигурации(ИнформационнаяБаза) Экспорт
	//:ИнформационнаяБаза = Справочники.ИнформационныеБазы.ПустаяСсылка();
	Платформа = ирКэш.Получить();
	//Сеть.ОтключитьСессии(ИнформационнаяБаза.СерверХост);
	Сеть.ПодключитьШару(ИнформационнаяБаза.СерверХост, Истина);
	глОбработкаАвтоОбменДанными = глОбработкаАвтоОбменДанными;
	
	Сообщить("ПроцедурыОбменаДанными.ПроизвестиСписокОбменовДанными
	|" + ТекущаяДата());
	ПроцедурыОбменаДанными.ПроизвестиСписокОбменовДанными(МассивОбменов(ИнформационнаяБаза.ПолучитьОбъект().ПолучитьУзелРИБ()), Ложь, глОбработкаАвтоОбменДанными);
	Сообщить("ЗапуститьОбменДанными
	|" + ТекущаяДата());
	ЗапуститьОбменДанными(ИнформационнаяБаза, Истина);
	УстановитьБлокировкуСоединений(ИнформационнаяБаза,Истина, Истина);
	Сообщить("Пауза");
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 5 127.0.0.1"); // 
	Сообщить("ПерезапускСлужбы
	|" + ТекущаяДата());
	Сообщить(ПерезапускСлужбы(ИнформационнаяБаза));
	Сообщить("Пауза");
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 15 127.0.0.1"); // 
	Сообщить("ОбновитьКонфигурациюБД
	|" + ТекущаяДата());
	Сообщить(ЗначениеВСтрокуВнутр(ОбновитьКонфигурациюБД(ИнформационнаяБаза,Истина)));
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 5 127.0.0.1"); // 
	ЗапуститьОбменДанными(ИнформационнаяБаза, Истина);
	УстановитьБлокировкуСоединений(ИнформационнаяБаза, Ложь, Ложь);
	
	Отбор = Новый Структура("Метаданные, Использование", "ОбновлениеИБузла", Истина);
	Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(Отбор);
	Для Каждого Задание Из Задания Цикл
		//:Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание();
		Если Задание.Параметры.Найти(ИнформационнаяБаза)<>Неопределено Тогда
			Задание.Использование = Ложь;
			Задание.Записать();
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура ОтправкаСообщенияИобновлениеКонфигурации(ИнформационнаяБаза) Экспорт
	//:ИнформационнаяБаза = Справочники.ИнформационныеБазы.ПустаяСсылка();
	Платформа = ирКэш.Получить();
	Сеть.ПодключитьШару(ИнформационнаяБаза.СерверХост, Истина);
	глОбработкаАвтоОбменДанными = глОбработкаАвтоОбменДанными;
	Сообщить("ПроцедурыОбменаДанными.ПроизвестиСписокОбменовДанными
	|" + ТекущаяДата());
	ПроцедурыОбменаДанными.ПроизвестиСписокОбменовДанными(МассивОбменов(ИнформационнаяБаза.ПолучитьОбъект().ПолучитьУзелРИБ()), Ложь, глОбработкаАвтоОбменДанными);
	Сообщить("ЗапуститьОбменДанными
	|" + ТекущаяДата());
	ЗапуститьОбменДанными(ИнформационнаяБаза, Истина);
	Сообщить("ping -n 25 127.0.0.1
	|" + ТекущаяДата());
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 35 127.0.0.1"); // 
	Сообщить("ОбновитьКонфигурациюБД
	|" + ТекущаяДата());
	Сообщить(ЗначениеВСтрокуВнутр(ОбновитьКонфигурациюБД(ИнформационнаяБаза,Истина)));
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 25 127.0.0.1"); // 
	ЗапуститьОбменДанными(ИнформационнаяБаза, Истина);
	Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 25 127.0.0.1"); // 
	ВыполнениеРегламентныхЗаданий.ОбновитьНомераВерсийИБ();
КонецПроцедуры

// Перезапуск службы, блокировка соединений, выгрузка DT и создание базы в c:\sup_kkm
// Регламент, запускается ночью
Процедура СоздатьФайловуюБазу(ИнформационнаяБаза) Экспорт
	Платформа = ирКэш.Получить();
	//Сеть.ОтключитьСессии(ИнформационнаяБаза.СерверХост);
	УстановитьБлокировкуСоединений(ИнформационнаяБаза);
	ПерезапускСлужбы(ИнформационнаяБаза);	
	ВыгрузитьDT(ИнформационнаяБаза);
	Попытка
		ОбрезатьЖурналРегистрации(ИнформационнаяБаза, Ложь);	
	Исключение
	КонецПопытки;
	
	//Платформа.ЗапуститьСкрытоеПриложениеИДождатьсяЗавершения("ping -n 2 127.0.0.1");
	Сообщить(ЗначениеВСтрокуВнутр(СоздатьБазуИзDT(ИнформационнаяБаза, ИнформационнаяБаза.СерверХост)));
	УстановитьБлокировкуСоединений(ИнформационнаяБаза,Ложь,Ложь);
	
КонецПроцедуры
