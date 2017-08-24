#Если Клиент Тогда
Перем AutohotkeyDll;
Перем AutohotkeyDll_БлокировкаВвода;
Перем AutohotkeyDll_Переназначение;
Перем AutohotkeyDll_Динамик;
Перем AHK_Balloon;
Перем AHK_СкрытьМенюИПанели;
Перем Враппер Экспорт;
Перем pid Экспорт;
Перем locA;
Перем AutohotkeyDll_Затемнение Экспорт;
Перем Переназначения;
Перем A_FS Экспорт;
Перем AHKs Экспорт;
Перем ТекНомерПлашки Экспорт;

Процедура Инициализация( hWnd=1, ВернутьПанели = 0 ) Экспорт
	
	pid = ЭтотОбъект.pid;
	ahk = ЭтотОбъект.AutohotkeyDll_Затемнение;

	//Скрипт = "
	//|#NoTrayIcon
	//|SetWinDelay -1
	//|SetTitleMatchMode, Fast
	//|Debug := %Debug
	//|
	//|WS_EX_TRANSPARENT := 0x20
	//|WS_EX_LAYERED := 0x80000
	//|
	//|	WinWait, ahk_pid %pid ahk_class V8TopLevelFrame
	//|	WinGet, hwnd, id, ahk_pid %pid ahk_class V8TopLevelFrame
	//|	Gui, +LastFound  +Owner%Hwnd% -Caption +HwndBackgroundHwnd  +Disabled
	//|	Gui, Color, 0
	//|	WinSet, ExStyle, % ""+"" WS_EX_LAYERED|WS_EX_TRANSPARENT   ; добавляем прозрачность для кликов мыши
	//|	WinSet, Transparent, 0
	//|	Gui, Show, w%A_screenWidth% h%a_screenHeight% x0 y0 NA
	//|	global Trans := 0
	//|		
	//|return	
	//|
	//|
	//|
	//|Anim:
	//|	global BackgroundHwnd
	//|	SetTimer, DecriseTrans, -5
	//|return
	//|
	//|DecriseTrans:
	//|	SetWinDelay, -1
	//|	SetTimer, DecriseTrans, off
	//|	if (HideMode == 0) 
	//|	{
	//|	if (trans <= 120)
	//|	{
	//|		Trans := trans + (((132-trans)+10)/5)		
	//|	    WinSet, Transparent, %Trans%, ahk_id %BackgroundHwnd%  
	//|		SetTimer, DecriseTrans, -10
	//|	}
	//|	; if Debug ToolTip Trans=%Trans%
	//|	}
	//|return
	//|
	//|Anim()
	//|{
	//|	global HideMode := 0
	//|	GoSub, Anim
	//|	; if Debug SplashTextOn ,,,,Anim
	//|}
	//|
	//|Hide:
	//|	SetTimer, IncriseTrans, -5
	//|	
	//|return
	//|
	//|IncriseTrans:
	//|	
	//|	SetWinDelay, -1
	//|	SetTimer, IncriseTrans, off
	//|	if (HideMode == 1)
	//|	{	
	//|	if (Trans > 0)
	//|	{
	//|		Trans := trans - (((142-trans)+10)/3)		
	//|		If (Trans < 0 ) 
	//|		{ 
	//|			Trans := 0
	//|		}
	//|	    WinSet, Transparent, %Trans%, ahk_id %BackgroundHwnd%  
	//|		SetTimer, incriseTrans, -5
	//|		; if Debug ToolTip Trans=%Trans%
	//|	}
	//|	}
	//|return                      	
	//|
	//|Hide()
	//|{
	//|	global BackgroundHwnd
	//|	global HideMode := 1
	//|	GoSub, Hide
	//|	; if Debug SplashTextOn ,,,,Hide
	//|}";
	//Скрипт = СтрЗаменить(Скрипт, "%pid", Формат(pid,"ЧГ=0"));
	//Скрипт = СтрЗаменить(Скрипт, "%Debug", ?(Найти(СтрокаСоединенияИнформационнойБазы(),"ws_it_23"),1,0));
	//
	////AutohotkeyDll_Затемнение.ahkTextDll(Скрипт);
	
КонецПроцедуры

// Возвращает 0 - если Инициализация еще не отработала
Функция GetMainShowStatusV8() Экспорт
		
	Если глСтекОкон.Количество()>1 Тогда
		Возврат Ложь;
	КонецЕсли;

	Возврат Истина;
КонецФункции 

// Возвращает позицию окна
Функция GetWndPosV8(hWnd, X, Y) Экспорт
	X=1;
	Y=1;
КонецФункции

// Устанавливает позицию окна
Процедура УстановитьПоложениеОкна(Заголовок, pX, pY, pW="", pH="") Экспорт
	Попытка
		
		X = Формат(pX,"ЧГ=0");
		Y = Формат(pY,"ЧГ=0");
		W = Формат(pW,"ЧГ=0");
		H = Формат(pH,"ЧГ=0");
		Если W="0" Тогда
			W="";
		КонецЕсли;
		
		Если H="0" Тогда
			H="";
		КонецЕсли;         

		Скрипт = "
		|#NoTrayIcon
		|Sleep, 50
		|WinMove,%Заголовок,,%X,%Y,%W,%H
		|";
		Скрипт = СтрЗаменить(Скрипт,"%Заголовок", Заголовок);
		Скрипт = СтрЗаменить(Скрипт,"%X", X);
		Скрипт = СтрЗаменить(Скрипт,"%Y", Y);
		Скрипт = СтрЗаменить(Скрипт,"%W", W);
		Скрипт = СтрЗаменить(Скрипт,"%H", H);
		
		AutohotkeyDll.ahkTextDll(Скрипт);
	Исключение 
	КонецПопытки;
	
КонецПроцедуры 

Функция ПолучитьУказательОкна(Заголовок,СостояниеОкна) Экспорт
	Возврат 0;
	Если ВариантСостоянияОкна.Свободное = СостояниеОкна Тогда
		Скрипт = "
		|#NoTrayIcon
		|global hwnd
		|capt := ""%Заголовок""
		|WinGet, hwnd, id, %capt% ahk_pid %1 ahk_class %Class
		|fGet() {
		|global hwnd
		|return hwnd
		|}
		|
		|; TOolTip %hwnd%";
		Скрипт = СтрЗаменить(Скрипт,"%Заголовок",Заголовок);
		Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт,"%Class","V8NewLocalFrameBaseWnd");
 		AutohotkeyDll.ahkTextDll(Скрипт);
		hwnd=AutohotkeyDll.ahkFunction("wGet");
		Возврат hwnd;
	Иначе
		Возврат 1;		
	КонецЕсли;
КонецФункции


// Устанавливает размер окна
Процедура УстановитьРазмерДочернегоОкна(Заголовок, W, H) Экспорт
	Попытка
		//H = H + 2;	
		//H=H- 2;
	Исключение
	КонецПопытки;
	
	Попытка                                 
		Скрипт = "
		|#NoTrayIcon
		|WinGet, hwnd, id, %Заголовок ahk_pid %1 ahk_class V8NewLocalFrameBaseWnd
		|WinRestore, ahk_id %hwnd%
		|WinMove,  ahk_id %hwnd%, , , , %W, %H
		|WinRestore, ahk_id %hwnd%";
		Скрипт = СтрЗаменить(Скрипт,"%Заголовок",Заголовок);
		Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт,"%W",Формат(W,"ЧРГ=; ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт,"%H",Формат(H,"ЧРГ=; ЧГ=0"));
		AutohotkeyDll.ahkTextDll(Скрипт);
	Исключение		
	КонецПопытки;			
КонецПроцедуры 

// Устанавливает размер окна
Процедура УстановитьРазмерОкна(hWnd, W, Знач H, ВысотаДопМеню = 0 ) Экспорт
	Попытка
		H = H + 2;	
	Исключение
	КонецПопытки;
	
	Попытка                                 
		Скрипт = "
		|#NoTrayIcon
		|WinGet, hwnd, id, ahk_pid %1 ahk_class V8TopLevelFrame
		|WinRestore, ahk_id %hwnd%
		|WinMove,  ahk_id %hwnd%, , 0, 0, %W, %H
		|WinRestore, ahk_id %hwnd%";
		Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт,"%W",Формат(W,"ЧРГ=; ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт,"%H",Формат(H,"ЧРГ=; ЧГ=0"));
		AutohotkeyDll.ahkTextDll(Скрипт);
	Исключение		
	КонецПопытки;		
КонецПроцедуры 

Процедура ПереназначитьКнопки() Экспорт
	Скрипт = "
	|	#NoTrayIcon
	|	SetTitleMatchMode, RegEx
	|	SetNumlockState, On
	|	SetNumLockState, AlwaysOn
	|	#MaxHotkeysPerInterval 800
	|	#HotkeyInterval 100
	|	
	|	$HOME::
	|		if (WinActive(""ahk_class V8TopLevelFrame""))
	|			Send {LShift Down}1{LShift Up} 
	|		else
	|			Send {HOME}
	|	return
	|	
	|	$END:: ; ИТОГ на TPX
	|		if ((WinActive(""ahk_class V8TopLevelFrame"")) or (WinActive(""ahk_class V8NewLocalFrameBaseWnd""))) {
	|			Send ^{F5}
	|		} else {
	|			Send {END}
	|		}
	|	return
	|	
	|	$F1:: ; Кнопка ВЫХОД В МЕНЮ
	|		if (WinActive(""ahk_class V8TopLevelFrame""))
	|			Send ^{F3}
	|		else if (WinActive(""ahk_class V8NewLocalFrameBaseWnd""))
	|			Send {Esc}
	|	return
	|	
	|	$Tab::
	|		if (WinActive(""ahk_class V8TopLevelFrame""))
	|			Send {F6}
	|		else
	|			Send {Tab}
	|	return
	|	
	|	$+VKBB:: ; Кнопка +/=
	|		if (WinActive(""ahk_class V8NewLocalFrameBaseWnd""))
	|			Send {NumpadAdd}
	|		else
	|			Send +{VKBB}
	|	return
	|	
	|	$NumpadAdd::
	|	if (WinActive(""ahk_class V8TopLevelFrame""))
	|			Send {LShift Down}1{LShift Up} 
	|		else
	|			Send {NumpadAdd}
	|	return
	|	
	|	$VKBD:: ; Банк карта на ibm
	|		if (WinActive(""ahk_class V8NewLocalFrameBaseWnd""))
	|			Send +1
	|		else
	|			Send {VKBD}
	|	return
	|	
	|	$VKBC:: ; Банк карта на TPX
	|		if (WinActive(""ahk_class V8NewLocalFrameBaseWnd""))
	|			Send +1
	|		else
	|			Send {VKBC}
	|	return
	|	
	|	$+8::
	|		Send {NumpadMult}
	|	return
	|	
	|	$NumpadMult:: ; ПЕЧАТЬ на IBM
	|		if ((WinActive(""ahk_class V8TopLevelFrame"")) or (WinActive(""ahk_class V8NewLocalFrameBaseWnd""))) {
	|			Send ^{F5}
	|		} else {
	|			Send {NumpadMult}
	|		}
	|	return 		
	|	
	|	$VKBE:: ; ??
	|		Send {NumpadDot}
	|	return
	|	
	|	$Enter::
	|		if ((WinActive(""ahk_class V8TopLevelFrame"")) or (WinActive(""ahk_class V8NewLocalFrameBaseWnd""))) {
	|			Send, {Ctrl Down}{VK0D}{Ctrl Up}
	|		} else {
	|			Send, {Enter}
	|		}
	|	return
	|	
	|	#IfWinActive ahk_class V8NewLocalFrameBaseWnd
	|	VK61::VK31 ; NumPad1::1 и т. д.
	|	VK62::VK32
	|	VK63::VK33	
	|	VK64::VK34
	|	VK65::VK35
	|	VK66::VK36
	|	VK67::VK37
	|	VK68::VK38
	|	VK69::VK39
	|	VK60::VK30
	|	NumpadIns::VK30
	|	NumpadEnd::VK31
	|	NumpadDown::VK32
	|	NumpadPgDn::VK33	
	|	NumpadLeft::VK34
	|	NumpadClear::VK35
	|	NumpadRight::VK36
	|	NumpadHome::VK37
	|	NumpadUp::VK38
	|	NumpadPgUp::VK39
	|	#IfWinActive
	|	";
	
	AHK = AHK(Истина);
	Если AHK = Неопределено Тогда
		Возврат;
	КонецЕсли;
	AHK.ahkTextDll(Скрипт);	
КонецПроцедуры

Процедура ПереназначитьКнопки_(Ключ, ПереназначаемоеСочетание, НовоеСочетание) Экспорт
	Ключ = Ключ + ПереназначаемоеСочетание;
	AHK = Неопределено;
	Для Каждого Т Из Переназначения Цикл
		Если Т.Ключ <> Ключ Тогда
			//AHK = Т.Значение;
			
			//Возврат;
			//AHKненужный.ahkterminate();
			
		Иначе
			AHK = Т.Значение;
			Возврат;
		КонецЕсли;
	КонецЦикла;
	
	Скрипт = "#IfWinActive ahk_class V8.*  
	|" + ПереназначаемоеСочетание + "::
	|Send " + НовоеСочетание + "
	|return
	|#IfWinActive";
	Если AHK = Неопределено Тогда
		Скрипт0 = "
		|#NoTrayIcon
		|SetTitleMatchMode, Regex
		|#InputLevel 11
		|SendLevel 10
		|+^!#1::send 1";
		AHK = AHK();
		Если AHK = Неопределено Тогда
			Возврат;
		КонецЕсли;
		AHK.ahkTextDll(Скрипт0);	
	КонецЕсли;
	AHK.addScript(Скрипт);
	Переназначения.Вставить(Ключ, AHK);
КонецПроцедуры

Процедура СнятьПереназначение(Ключ, ПереназначаемоеСочетание) Экспорт
	Ключ = Ключ + ПереназначаемоеСочетание;
	Для Каждого Т Из Переназначения Цикл
		Если Т.Ключ = Ключ Тогда
			AHK = Т.Значение;
			AHK.AhkTerminate();
			Переназначения.Удалить(Т.Ключ);
			Возврат;
			
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

Процедура Максимизировать(hwnd=0) Экспорт
	Скрипт = "
	|#NoTrayIcon
	|SetWinDelay 100
	|WinWaitActive, ahk_pid %1 ahk_class V8TopLevelFrame
	|WinGet, hwnd, id, ahk_pid %1 ahk_class V8TopLevelFrame
	|WinMaximize, ahk_id %hwnd% 
	|";
	Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
	AutohotkeyDll.ahkTextDll(Скрипт);		
КонецПроцедуры 

Процедура МаксимизироватьДочернее(Заголовок="") Экспорт
	Скрипт = "
	|#NoTrayIcon
	|SetWinDelay 100
	|";
	Скрипт = Скрипт+"WinMaximize, " + Заголовок;
	Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
	AutohotkeyDll.ahkTextDll(Скрипт);		
КонецПроцедуры 

// Центрирует окно
Процедура CenterV8(hWnd) Экспорт
	//WshShell.SendKeys("!+R");
	//WshShell.SendKeys("!+К");
	Попытка
		A_FS.ahkFunction("CheckCenterWindow");
		//AutohotkeyDll.ahkTextDll("
		//|#NoTrayIcon
		//|#IfWinActive ahk_class V8NewLocalFrameBaseWnd
		//|	WinGetPos, X, Y, W, H, A
		//|	sW := A_ScreenWidth
		//|	sH := A_ScreenHeight
		//|	if (X + W > sW)||(Y + H > sH)||(W > sW - 20) {
		//|		nX := A_ScreenWidt/2 - W/2
		//|		nY := A_ScreenHeight/2 - H/2
		//|		WinMove, ahk_id %hwnd%, A_ScreenHeight, nX, nY
		//|	}
		//|#IfWinActive");
	Исключение
		//Сообщить(ОписаниеОшибки());
	КонецПопытки;	
	
КонецПроцедуры 

// Открывает экранную клаву
// нужна ли она вообще?
&НаКлиенте
Процедура ScreenKey(Лево, Верх, ШиринаКлавы, ВысотаКлавы, Прозрачность) Экспорт
	ЗапуститьПриложение("OSK.exe");	
КонецПроцедуры 

// Открывает экранную клаву
// не нужна
Функция StartKBHook() Экспорт
	Возврат 999;
КонецФункции 

// Воспроизводит звук
Функция PlayWav(ЗвукОповещения=Неопределено) Экспорт
	//Если AutohotkeyDll_Динамик = Неопределено Тогда
	//	AutohotkeyDll_Динамик = AHK(Истина, "PlayWav");
	//	Скрипт = "
	//	|#NoTrayIcon
	//	|#persistent
	//	|Beep() 
	//	|{
	//	|	SoundBeep, 400, 100
	//	|	SoundBeep
	//	|	return
	//	|}
	//	|
	//	|~vk4f::Beep()";
	//	AutohotkeyDll_Динамик.ahkTextDll(Скрипт);		
	//КонецЕсли;
	//AutohotkeyDll_Динамик.ahkFunction("Beep");	
	Сигнал();
КонецФункции

// Выводит всплывающее окно с сообщением
// Напишем на autohotkey
Процедура ShowMessageEx(ШиринаОкна, ЦветФона, ТекстСообщения, Событие, Данные, ИдСообщения) Экспорт 
КонецПроцедуры  

// Закрывает экранную клавиатуру
Функция CloseScreenKey() Экспорт
	//КомандаСистемы("taskKill /im osk.exe");	
КонецФункции

// Выключает компьютер
Функция ShutDown() Экспорт
	ЗапуститьПриложение("shutdown -s -f -t 20");	
КонецФункции

// убрать/вернуть заголовок окна flag = 0/1
// Напишем на autohotkey
Процедура ShowCaption(hWnd, flag, пВыполнить=0) Экспорт
	
	Попытка
		showCaptionA  = ЭтотОбъект.AHK(,"ShowCaption");
		
		Текст = "
		|#NoTrayIcon
		|WinGet, hwnd, id, ahk_pid %1 ahk_class V8TopLevelFrame
		|WinSet, Style,"+?(flag=1,"+","-")+"0x00C00000, ahk_id %hwnd%
		|ControlGetPos, X, Y, W, H, V8MDIClient1, ahk_id %kwnd1%
		|ControlMove, V8MDIClient1,%X%,%Y%,%W%,%H%,ahk_id %kwnd1%
		|";
		Текст = СтрЗаменить(текст,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		Если flag = 1 Тогда
			Текст = Текст + "
			|WinShow, ahk_class Shell_TrayWnd";
		Иначе
		КонецЕсли;  
		
		showCaptionA.ahkTextDll(Текст);
		//
		//Текст="WinGet, hwnd, id, ahk_pid %1 ahk_class V8TopLevelFrame
		//|WinMaximize, ahk_id %hwnd%
		//|";
		//Текст = СтрЗаменить(текст,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		//AutohotkeyDll.ahkTextDll(текст);
		//пока AutohotkeyDll.ahkReady() Цикл
		//	ОбработкаПрерыванияПользователя();
		//	Враппер.sleep(10);
		//КонецЦикла;
		
		
	Исключение		
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	
КонецПроцедуры 

// убрать/вернуть системное меню окна flag = 0/1
// Напишем на autohotkey
Процедура ShowSysMenu(hWnd, flag) Экспорт
	
КонецПроцедуры 

// установить окно поверх всех окон flag = 0/1
// Напишем на autohotkey
Процедура OnTop(hWnd=0, flag=1) Экспорт
	Попытка
		onTopA = ЭтотОбъект.AHK(,"OnTop");
		Скрипт = "
		|#NoTrayIcon
		|WinGet, hwnd, id, ahk_pid %1 ahk_class V8TopLevelFrame
		|WinSet, AlwaysOnTop, On, ahk_id %hwnd%
		|";
		Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		Если flag = 0 Тогда
			Скрипт = СтрЗаменить(Скрипт," On,"," Off,");
		КонецЕсли;
		
		onTopA.ahkTextDll(Скрипт);
		
		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

// На весь экран
// Напишем на autohotkey
Процедура FullScreen(hWnd=0) Экспорт
	
	Попытка
		A_FS = ЭтотОбъект.AHK(Истина, "FullScreen");	
		Скрипт = ";#NoTrayIcon
		|#KeyHistory 500
		|;if (A_ScreenWidth > 1924) {
		|;	WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame
		|;	WinMove, ahk_pid %pid ahk_class V8TopLevelFrame,,0,0,1024,786
		|;} else {
		|	WinMove, ahk_pid %pid ahk_class V8TopLevelFrame,,0,0,%A_ScreenWidth%,%A_ScreenHeight%
		|	Sleep 100
		|	WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame, , 10
		|	WinRestore, ahk_id %hwnd%
		|	WinMaximize, ahk_id %hwnd%
		|	settimer, CheckFullScreen, -100
		|;}
		|return
		|
		|CheckFullScreen:
		|	SetTimer, CheckFullScreen, off
		|	WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame, , 10
		|
		|	WinGet, hwnd, id, ahk_pid %pid ahk_class V8TopLevelFrame
		|	WinGetPos, X, Y, W, H, ahk_id %hwnd%
		|	if ((H<A_screenHeight)||(Y>1))&&(H+W<>0) {
		|	
		|	WinMove, ahk_id %hwnd%, ,0, 0,%A_ScreenWidth%, %A_screenHeight%
		|	WinRestore, ahk_id %hwnd%
		|	WinMaximize, ahk_id %hwnd%
		|	Send {alt down}{shift down}{VK52}{alt up}{shift up} ; Alt+Shift+R
		|}
		|SetTimer, CheckFullScreen, -3000
		|return
		|
		|CheckCenterWindow() {
		|	Settimer, CheckCenterWindow_Label, -100
		|	return 1	
		|}
		|
		|CheckCenterWindow_Label:
		|WinGetClass, A_Class, A 
		|
		|if (A_Class == ""V8NewLocalFrameBaseWnd"") {
		|	; TOOLTIP % A_Class
		|	WinGetPos, X, Y, W, H, A
		|	WindowCenter := (X+W/2)
		|	if ((WindowCenter < (A_ScreenWidth/2-1))&&(W<(A_ScreenWidth-1)))	{
		|		Send {alt down}{shift down}{VK52}{alt up}{shift up} ; Alt+Shift+R
		|	}
		|}
		|return
		|
		|^!VK4B::KeyHistory ; ^!k
		|~!+^VKBE::
		|	Gosub, CheckFullScreen
		|	GoSub, CheckCenterWindow_Label
		|return
		|^F2::tooltip";
		Скрипт = СтрЗаменить(Скрипт, "%pid", Формат(pid,"ЧГ=0"));
		Если глПараметрыРМ.ИнтерфейсТип = 8 Тогда
			Скрипт = СтрЗаменить(Скрипт, "1024", "800");
			Скрипт = СтрЗаменить(Скрипт, "786", "600");
		КонецЕсли;
		A_FS.ahkTextDll(Скрипт);
		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
КонецПроцедуры 

Процедура СкрытьПенельЗадач() Экспорт
	Попытка
		AHK = ЭтотОбъект.AHK(,"СкрытьПенельЗадач");	
		Скрипт = "
		|#NoTrayIcon
		|WinHide, ahk_class Shell_TrayWnd
		|WinHide, ahk_class Button
		|Monitor_setWorkArea(0,0,A_ScreenWidth,A_ScreenHeight)
		|ExitApp
		|return
		|Monitor_setWorkArea(left, top, right, bottom) {
		|   VarSetCapacity(area, 16)
		|   NumPut(left,   area,  0)
		|   NumPut(top,    area,  4)
		|   NumPut(right,  area,  8)
		|   NumPut(bottom, area, 12)
		|   DllCall(""SystemParametersInfo"", UInt, 0x2F, UInt, 0, UInt, &area, UInt, 0)   ; 0x2F = SPI_SETWORKAREA
		|}
		|";
		Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		AHK.ahkTextDll(Скрипт);
		
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	
КонецПроцедуры

Процедура ВернутьПанельЗадач() Экспорт
	Попытка
		AHK = ЭтотОбъект.AHK(,"ВернутьПанельЗадач");	
		Скрипт = "
		|#NoTrayIcon
		|WinShow, ahk_class Shell_TrayWnd
		|ExitApp
		|return";
		Скрипт = СтрЗаменить(Скрипт,"%1",Формат(pid,"ЧРГ=; ЧГ=0"));
		AHK.ahkTextDll(Скрипт);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Функция СкрытьМенюИпанели() Экспорт
	Попытка
		
		Если AHK_СкрытьМенюИПанели = Неопределено Тогда
			AHK_СкрытьМенюИПанели = ЭтотОбъект.AHK(Истина, "СкрытьМенюИпанели");	
		КонецЕсли;
		
		
		Скрипт = "
		|#NoTrayIcon
		|global PID := DllCall(""GetCurrentProcessId"")
		|
		|Start() 
		|return
		|
		|Start() {
		|	global PID
		|	WinActivate, V8TopLevelFrame
		|	HidePanels(2)
		|	WinGetClass, Class, A
		|	If (Class==""V8PopupBar"") {
		|		Send, {ESC}
		|	}
		
		|	sleep 100
		|	HidePanels(1)
		|	WinGetClass, Class, A
		|	If (Class==""V8PopupBar"") {
		|		Send, {ESC}
		|	}
		|	
		|	If (WinExist(""ahk_class V8PopupBar"")) {
		|		WinHide, ahk_class V8PopupBar
		|	}
		|	                   
		|	return
		|}
		|
		|BlockInputOff() {                                                                                                 	
		|	BlockInput, off
		|	BlockInput, MouseMoveOff
		| 	ExitApp
		|}
		|
		|HidePanels(maxFails) {
		|	SetTitleMatchMode, RegEx
		|	Fails := 0
		|	While (Fails<maxFails)&&(GetVisibleCount()>0) {
		|		if (Fails<maxFails) {
		|			WinActivate, ahk_class V8TopLevelFrame
		|			
		|			; ControlClick, V8MDIClient1, ahk_class V8TopLevelFrame, , Right,,X1 Y1
		|			ControlClick, V8MDIClient1, ahk_pid %PID%, , Right,,X1 Y1
		|			Sleep 50
		|			PixelSearch, X, Y, 1, 1, 100, 500, 0xf5dcc7, 1, FAST
		|			If (X)
		|				MouseClick, Left, %X%, %Y%
		|				else {
		|					; Fails := Fails + 1
		|					ControlClick, V8MDIClient1, ahk_class V8TopLevelFrame, , Right,,X1 Y1
		|					Sleep 10
		|					PixelSearch, X, Y, 1, 1, 100, 500, 0xf5dcc7, 1, FAST
		|					If (X)
		|						MouseClick, Left, %X%, %Y%
		|					else {
		|						; WinGetClass, Class, A
		|						; If (Class==""V8PopupBar"") {
		|							Send, {ESC}
		|						;}
		
		|						Fails := Fails + 1
		|					}
		|				}
		|			} else 
		|		{
		|			Send, {ESC}
		|			break 
		|		} 
		|	}
		|	
		|} 
		|GetVisibleCount() {
		//|	WinActivate, ahk_class V8TopLevelFrame
		//|	PID := DllCall(""GetCurrentProcessId"")
		//|	WinGet, ActiveControlList, ControlList, A
		//|	ToolTipStr :=""""
		//|	VisibleCount := 0
		//|	Loop, Parse, ActiveControlList, `n
		//|	{
		//|		isVisible := 0
		//|		ClassOfControl := A_LoopField
		//|		if (RegExMatch(ClassOfControl, ""V8Dockbar.*"") > 0) {
		//|			ControlGet, isVisible, Visible, , %ClassOfControl%, A
		//|			ControlGet, Style, Style, , %ClassOfControl%, A
		//|			ToolTipStr = %ToolTipStr% `n %ClassOfControl% isVisible = %isVisible%
		//|		}	
		//|		if (isVisible==1) {
		//|			VisibleCount := VisibleCount + 1
		//|		}
		//|	}
		//|	; ToolTip % VisibleCount
		|	return 1
		|}";
		
		
		
		AHK_СкрытьМенюИПанели.ahkTextDll(Скрипт);
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат AHK_СкрытьМенюИПанели;
КонецФункции

Процедура ВернутьМенюИпанели() Экспорт
	Попытка
		
		Скрипт = "
		|#NoTrayIcon
		|	SetTimer, ShowPanels, -100
		|return
		|
		|ShowPanels() {
		|	SetTitleMatchMode, RegEx
		|;	if (GetVisibleCount() < 7) {
		|		ControlClick, V8MDIClient1, A, , Right,,X1 Y1
		|		Sleep 100
		|		Send {Down 5}
		|		Send {Space}
		|		Sleep 30
		|		
		|		ControlClick, V8MDIClient1, A, , Right,,X1 Y1
		|		Sleep 100
		|		Send {Down 2}
		|		Send {Space}
		|		Sleep 30
		|		
		|		ControlClick, V8MDIClient1, A, , Right,,X1 Y1
		|		Sleep 100
		|		Send {Down}
		|		Send {Space}
		|		
		|		Send #{Up}
		|;	}
		|}
		|GetVisibleCount() {
		|	global PID
		|	WinGet, ActiveControlList, ControlList, A 
		|	ToolTipStr :=""""
		|	VisibleCount := 0
		|	Loop, Parse, ActiveControlList, `n
		|	{
		|		ClassOfControl := A_LoopField
		|		if (RegExMatch(ClassOfControl, ""V8CommandBar.*"") > 0) {
		|			ControlGet, isVisible, Visible, , %ClassOfControl%, A
		|			ControlGet, Style, Style, , %ClassOfControl%, A
		|			ToolTipStr = %ToolTipStr% `n %ClassOfControl% isVisible = %isVisible%
		|		}	
		|		if (isVisible==1) {
		|			VisibleCount := VisibleCount + 1
		|		}
		|	}
		|	return VisibleCount
		|	
		|}";
		AHK_СкрытьМенюИПанели.ahkTextDll(Скрипт);
	Исключение
		//Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Попытка
		глОбработки.ГлавнаяФорма.ГлавнаяФорма.ТолькоПросмотр = Ложь;
	Исключение
	КонецПопытки;
КонецПроцедуры

// Получить ширину и высоту главного окна
Процедура GetWndSize( Окно1С, Ширина1С, Высота1С ) Экспорт
	Ширина1С = 1024;
	Высота1С = 786;
КонецПроцедуры 	

// Возвращает время в мс
Функция GetTimer() Экспорт 
	Возврат ТекущаяУниверсальнаяДатаВМиллисекундах();
КонецФункции

Процедура Затемнить() Экспорт
	//Попытка
	//	Если глПараметрыРМ.Затемнение Тогда
	//		AutohotkeyDll_Затемнение.ahkFunction("Anim");	
	//	КонецЕсли;
	//Исключение
	//КонецПопытки;
КонецПроцедуры

Процедура УбратьЗатемнение() Экспорт
	//Попытка
	//	Если глПараметрыРМ.Затемнение Тогда
	//		AutohotkeyDll_Затемнение.ahkFunction("Hide");
	//	КонецЕсли;
	//	
	//Исключение
	//КонецПопытки;
КонецПроцедуры

// Делает окно AlwaysOnTop
Процедура AOTon(Заголовок, OnOff = "On") Экспорт
	Попытка
		onTopA = ЭтотОбъект.AHK(, "AOTon");
		Скрипт = "
		|#NoTrayIcon
		|hwnd := WinExist(""%1"")
		|WinSet, AlwaysOnTop, " + OnOff + ", ahk_id %hwnd%";
		Скрипт = СтрЗаменить(Скрипт,"%1", Заголовок);
		
		onTopA.ahkTextDll(Скрипт);
	Исключение 
	КонецПопытки;
КонецПроцедуры

Процедура ЗаблокироватьВвод() Экспорт
	Возврат;
	Попытка
		ПутьКкартинке = ПолучитьИмяВременногоФайла("png");
		БиблиотекаКартинок.ЛогоКуулКлевер.Записать(ПутьКкартинке);
		Скрипт = "
		|#NoTrayIcon	
		|	WS_EX_TRANSPARENT := 0x20
		|	WS_EX_LAYERED := 0x80000
		|	ExStyle := WS_EX_LAYERED|WS_EX_TRANSPARENT
		|	Gui, -Caption +AlwaysOnTop +E%ExStyle%
		|	Gui, Color, F0F0F0
		|	W := 512
		|	H := 512
		|	X := A_screenWidth/2 - W/2
		|	Y := A_screenHeight/2 -H/2
		|	
		|	Gui, Add, Picture,x%X% y%Y% , %ПутьКкартинке%
		|	Gui, Show, w%A_screenWidth% h%a_screenHeight% x0 y0 NA, Запуск СУП ККМ
		|	
		|	Sleep 10000
		|	ExitAPP
		|return
		|^1::ExitAPP
		|mExit()
		|{
		|BlockInput, off
		|ExitApp
		|}";
		
		Скрипт = СтрЗаменить(Скрипт, "%pid%",Формат(pid,"ЧРГ=; ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт, "%ПутьКкартинке%",ПутьКкартинке);
		AutohotkeyDll_БлокировкаВвода.ahkTextDll(Скрипт);
	Исключение
	КонецПопытки;
КонецПроцедуры

Процедура РазблокироватьВвод() Экспорт
	Попытка
		AutohotkeyDll_БлокировкаВвода.ahkFunction("mExit");	
		
	Исключение
	КонецПопытки;
	AutohotkeyDll_БлокировкаВвода = Null;
КонецПроцедуры

Функция AHK(СоздатьНовый = Истина, Описание = "") Экспорт
	//глОтладочнаяИнформация = глОтладочнаяИнформация + Описание + Символы.ПС;
	Если Не СоздатьНовый Тогда
		Для Каждого AHK Из AHKs Цикл
			Если AHK.ahkReady() = 0 Тогда
				Возврат AHK;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	Если глОтладкаУровень() > 0  Тогда
		Попытка
			AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey","AutoHotkey.Script.UNICODE");
		Исключение
		КонецПопытки;
		
	Иначе
		Попытка
			AHK = Новый COMОбъект("AutoHotkey.Script");
			AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey","AutoHotkey.Script.UNICODE");
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Если AHK = Неопределено Тогда
		ирПлатформа = ирКэш.Получить();
		AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey","AutoHotkey.Script.UNICODE");
		Если AHK = Неопределено Тогда
			AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey","AutoHotkey.Script");
		КонецЕсли;
	КонецЕсли;
	AHKs.Добавить(AHK);
	Возврат AHK;
КонецФункции

Функция AHK2() Экспорт
	AHK = AHK;
	Попытка
		AHK = Новый COMОбъект("AutoHotkey2.Script");
	Исключение
	КонецПопытки;
	
	Если AHK = Неопределено Тогда
		ирПлатформа = ирКэш.Получить();
		AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey2","AutoHotkey2.Script");
	КонецЕсли;
	Возврат AHK;	
КонецФункции

Функция Враппер()
	Враппер = Враппер;
	Попытка
		Враппер = Новый COMОбъект("DynamicWrapperX");	
	Исключение
	КонецПопытки;
	
	Если Враппер = Неопределено Тогда
		ирПлатформа = ирКэш.Получить();
		Враппер = ирПлатформа.ПолучитьCOMОбъектИзМакета("DynamicWrapperX32","DynamicWrapperX");
	КонецЕсли;
	
	Возврат Враппер;
КонецФункции

Процедура Подсказка(Текст) Экспорт
	ПоказатьПлашку(":-)", Текст, 5);
КонецПроцедуры

Процедура Подсказка_(Текст) Экспорт
	AHK=AutohotkeyDll;
	Если AHK = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Текст = СтрЗаменить(Текст, "%", "");
	AHK.ahkTextDll("
	|#NoTrayIcon
	|ToolTip " + Текст + "
	|Sleep 2000
	|ExitApp");
КонецПроцедуры

Процедура ПоказатьПлашку(Заголовок, Текст, НомерПлашки = 0) Экспорт
	Текст = СтрЗаменить(Текст, Символы.ПС, "`n");
	Текст = СтрЗаменить(Текст, ";", "");
	
	Если НомерПлашки = 0 Тогда
		ТекНомерПлашки=ТекНомерПлашки+1;
		НомерПлашки = ТекНомерПлашки%3+1;
	КонецЕсли;
	
	Скрипт = "
	|#NoTrayIcon
	|; #SingleInstance Force
	|
	|Global msg
	|Global mouse_x, mouse_y, ext, time, hHookMouse, Ptr
	|Global oMsg := { 0x200: ""WM_MOUSEMOVE""
	|				, 0x201: ""WM_LBUTTONDOWN"", 0x202: ""WM_LBUTTONUP""
	|				, 0x204: ""WM_RBUTTONDOWN"", 0x205: ""WM_RBUTTONUP""
	|				, 0x207: ""WM_MBUTTONDOWN"", 0x208: ""WM_MBUTTONUP""
	|				, 0x20B: ""WM_XBUTTONDOWN"", 0x20C: ""WM_XBUTTONUP""
	|				, 0x20A: ""WM_MOUSEWHEEL"" , 0x20E: ""WM_MOUSEHWHEEL"" }
	|				
	|Global oMouseData := { 0: ""0"", 1: ""XBUTTON1"", 2: ""XBUTTON2""
	|					  , 120: ""WHEEL_DELTA forward"", -120: ""WHEEL_DELTA backward"" }
	|				
	|
	|Class LowLevelMouse {
	|
	|	
	|	__New() {
	|	
	|		hHookMouse := DllCall(""SetWindowsHookEx""
	|	   , Int, WH_MOUSE_LL := 14
	|	   , Int, RegisterCallback(""LowLevelMouseProc"", ""Fast"")
	|	   , Ptr, DllCall(""GetModuleHandle"", UInt, 0, Ptr)
	|	   , UInt, 0, Ptr)
	|	}
	|	
	|	__Delete() {
	|		DllCall(""UnhookWindowsHookEx"", Ptr, hHookMouse)
	|	}
	|	
	|	SetCallback(func) {
	|			this.callback := func
	|	}
	|	
	|	CallCallbacks() {
	|		this.callback.call(mouse_x, mouse_y)
	|	}
	|
	|}
	| 
	|LowLevelMouseProc(nCode, wParam, lParam)
	|{
	|   
	|      static oMsg := { 0x200: ""WM_MOUSEMOVE""
	|                , 0x201: ""WM_LBUTTONDOWN"", 0x202: ""WM_LBUTTONUP""
	|                , 0x204: ""WM_RBUTTONDOWN"", 0x205: ""WM_RBUTTONUP""
	|                , 0x207: ""WM_MBUTTONDOWN"", 0x208: ""WM_MBUTTONUP""
	|                , 0x20B: ""WM_XBUTTONDOWN"", 0x20C: ""WM_XBUTTONUP""
	|                , 0x20A: ""WM_MOUSEWHEEL"" , 0x20E: ""WM_MOUSEHWHEEL"" }
	|                
	|      , oMouseData := { 0: ""0"", 1: ""XBUTTON1"", 2: ""XBUTTON2""
	|                      , 120: ""WHEEL_DELTA forward"", -120: ""WHEEL_DELTA backward"" }
	|
	|   msg := wParam
	|   mouse_x := NumGet(lParam + 0, ""Int"")
	|   mouse_y := NumGet(lParam + 4, ""Int"")
	|   ext     := NumGet(lParam + 10, ""Short"")
	|   time    := NumGet(lParam + 16, ""UInt"")
	|   
	|   SetTimer, EventHandling, -10
	|   Return DllCall(""CallNextHookEx"", Ptr, 0, Int, nCode, UInt, wParam, UInt, lParam)
	|
	|EventHandling:
	|	
	|   LL.CallCallbacks()
	|   Return
	|}
	|
	|
	|
	|
	|
	|Global LL := new LowLevelMouse()
	|Global THEME_COLOR := 0x068A3F
	|Global ACCENT_COLOR := 0xFF6E3F
	|
	|Global WS_EX_TRANSPARENT := 0x20
	|Global WS_EX_LAYERED := 0x80000
	|Global AW_BLEND := 0x00080000
	|Global AW_HOR_POSITIVE = 1
	|Global AW_SLIDE = 0x00040000
	|
	|Global marginX := 10
	|Global marginY := 15
	|
	|Global WINDOW_WIDTH := 250
	|Global WINDOW_HEIGHT := 100	
	|Global WINDOW_X := (A_ScreenWidth - (WINDOW_WIDTH + marginX))
	|Global animateEffect := AW_BLEND or AW_HOR_POSITIVE
	|
	|class MessageWindow {
	|	
	|	
	|	y := 0
	|	stepTrans := 0
	|	hwnd := 0
	|	
	|	__New(pIndex, pCaption, pText) {
	|		this.trans 		:= 255
	|		this.dTrans		:= 1
	|		this.stepTrans	:= 0	
	|		
	|		
	|		; ширина и высота окна, можно изменить на 1
	|		this.index := pIndex
	|		this.y := (pIndex-1)*(WINDOW_HEIGHT+marginY)+marginY*2
	|		this.strCaption := pCaption
	|		this.strText := pText
	|		this.TransDec:= ObjBindMethod(this, ""TransDecFunc"")
	|		
	|	}
	|	
	|	
	|	show() {
	|		index := this.index
	|		Gui,G%index%:+AlwaysOnTop -Caption +ToolWindow +LastFound -border
	|		
	|		Gui,G%index%: Font, s16,Segoe UI
	|		Gui,G%index%: Color, %ACCENT_COLOR%
	|
	|		Gui,G%index%: Add, Text,  W1000, % this.strCaption
	|		Gui,G%index%: Font, s10
	|		Gui,G%index%: Add, Text, W1000 H200 , % this.strText
	|
	|		win_y := this.y
	|		Gui,G%index%: Show, y%win_y% x%WINDOW_X%  w%WINDOW_WIDTH% h%WINDOW_HEIGHT% hide ; показываем окно в выбранных координатах и размерах
	|		hwnd := WinExist()
	|		this.hwnd := WinExist()
	|		DllCall(""AnimateWindow"", Ptr, hwnd, UInt, 300, UInt, animateEffect)   ; выдвигаем/задвигаем окно-слайдер
	|		
	|		WinSet, ExStyle, % ""+"" WS_EX_LAYERED | WS_EX_TRANSPARENT   ; добавляем прозрачность для кликов мыши
	|		WinSet, Transparent, % this.trans
	|		
	|		LL.SetCallback(ObjBindMethod(this, ""mouseProc"",x,y))
	|		this.hide(-2500)
	|		
	|	}
	|	
	|	pointInRect(pX, pY, rX, rY, rW, rH) {
	|		checkX := (pX-rX)*1.0		; must be > 0
	|		checkX2 :=((rX+rW)-pX)*1.0 	; must be > 0
	|		checkY := (pY-rY)*1.0 		; must be > 0
	|		checkY2 :=((rY+rW)-pY) *1.0	; must be > 0
	|		if (checkX<0 or checkX2<0 or checkY<0 or checkY2<0) {
	|			return 0		
	|		} else {
	|			return 1 
	|		}		
	|	}
	|	
	|	mouseProc(x,y) {
	|	if this.pointInRect(mouse_x, mouse_y, WINDOW_X, this.y, WINDOW_WIDTH, WINDOW_HEIGHT) {
	|		this.StopHiding()
	|	}
	|		
	|	}
	|	
	|	hide(after_ms=0) {
	|		callback := ObjBindMethod(this, ""TransDecFunc"")
	|		SetTimer,% callback, %after_ms%
	|	}
	|	
	|	TransDecFunc() {
	|		this.stepTrans := this.stepTrans + 1
	|		this.dTrans := this.dTrans + (255.0/this.trans)**(1/1.1)
	|		this.trans := this.trans - this.dTrans
	|		WinSet, Transparent, % this.trans, % ""ahk_id "" + this.hwnd
	|		if (this.trans>0) {
	|			this.hide(-50)
	|		}
	|
	|	}
	|	
	|	StopHiding() {
	|		callback1 := ObjBindMethod(this, ""TransDecFunc"")
	|		SetTimer,% callback1, Off
	|		
	|		this.stepTrans := 1
	|		this.dTrans := 1
	|		this.trans := 500
	|		WinSet, Transparent, % 255, ""ahk_id "" + this.hwnd
	|		
	|		
	|		callback2 := ObjBindMethod(this, ""hide"")		
	|		SetTimer,% callback2, off
	|		
	|	}
	|	
	|}
	|
	|Global curCaption, curText, curIndex
	|
	|ShowMessage() {
	|	w2 := new MessageWindow(curIndex,curCaption, curText)
	|	w2.show()
	|}
	|
	|";
	
	Если AHK_Balloon = Неопределено Тогда
		AHK_Balloon = AHK(Ложь, "Balloon");
		AHK_Balloon.ahkTextDll(Скрипт);
	КонецЕсли;
	AHK_Balloon.ahkExec(
	СтрШаблон(
	"curIndex := %1
	|curCaption := ""%2""
	|curText := ""%3""
	|
	|ShowMessage()",
	НомерПлашки, Заголовок, Текст)
	);
	
	

КонецПроцедуры


Функция Деструктор() Экспорт
	i=0;
	Для i = 0 По AHKs.Количество()-1 Цикл
		Попытка
			AHKs[i].ahkterminate();	
		Исключение
		КонецПопытки;
		AHKs[i] = Null;
	КонецЦикла;
	AHKs.Очистить();
	AHKs = Null;
	AutohotkeyDll = Null;
	A_FS = Null;
	AutohotkeyDll_БлокировкаВвода = Null;
	AutohotkeyDll_Переназначение = Null;
	AutohotkeyDll_Затемнение = Null;
	Враппер = Null;
	locA = Null;	
	Для Каждого Переназначение Из Переназначения Цикл
		Переназначения.Вставить(Переназначение.Ключ,Null);
	КонецЦикла;
	Переназначения.Очистить();
	Переназначения = Null;
КонецФункции

AHKs = Новый Массив;	
Если ИмяПользователя() <> "Обмен" Тогда
	
	AutohotkeyDll = AHK(,"AutohotkeyDll");
	AutohotkeyDll_БлокировкаВвода = AHK(,"AutohotkeyDll_БлокировкаВвода");
	AutohotkeyDll_Переназначение = AHK(,"AutohotkeyDll_Переназначение");
	Враппер = Враппер();
	Если Враппер <> Неопределено Тогда
		Враппер.Register("KERNEL32.DLL", "Sleep", "i=h", "f=s");
		Враппер.Register("KERNEL32.DLL", "GetCurrentProcessId", "f=s", "r=l");
		pid = Враппер.GetCurrentProcessId();
	КонецЕсли;
	
КонецЕсли;

Переназначения = Новый Соответствие;
ТекНомерПлашки = 0;
#КонецЕсли