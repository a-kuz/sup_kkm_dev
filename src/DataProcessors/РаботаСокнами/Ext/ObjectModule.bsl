#Если Клиент Тогда
Перем AutohotkeyDll;
Перем AutohotkeyDll_БлокировкаВвода;
Перем AutohotkeyDll_Переназначение;
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
		
#Если ТолстыйКлиентОбычноеПриложение Тогда
	Если глСтекОкон.Количество()>1 Тогда
		Возврат Ложь;
	КонецЕсли;
#КонецЕсли	

	Возврат Истина;
КонецФункции 

// Возвращает позицию окна
Функция GetWndPosV8(hWnd, X, Y) Экспорт
	X=1;
	Y=1;
КонецФункции

// Устанавливает позицию окна
Процедура УстановитьПоложениеОкна(Заголовок, pX, pY, pW="0", pH="0") Экспорт
	Попытка
		
		X = Формат(pX,"ЧГ=0");
		Y = Формат(pY,"ЧГ=0");
		W = Формат(pW,"ЧГ=0;чн=0");
		H = Формат(pH,"ЧГ=0;Чн=0");
		Если W="0" Тогда
			W="";
		КонецЕсли;
		
		Если H="0" Тогда
			H="";
		КонецЕсли;         

		Скрипт = "
		|#NoTrayIcon
		|#NoEnv
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
		|#NoEnv
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
		|#NoEnv
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
		|#NoEnv
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
	|	#NoEnv
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
	|#NoEnv
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
	|#NoEnv
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
	Сигнал();
КонецФункции

// Выводит всплывающее окно с сообщением
// Напишем на autohotkey
Процедура ShowMessageEx(ШиринаОкна, ЦветФона, ТекстСообщения, Событие, Данные, ИдСообщения) Экспорт
	ПоказатьПлашку(" ", ТекстСообщения, , "1000000", 10, 230);
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
		|#NoEnv
		|WinGet, hwnd, id, ahk_pid %pid ahk_class V8TopLevelFrame
		|WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame, , 10
		|WinSet, Style,"+?(flag=1,"+","-")+"0x00C00000, ahk_id %hwnd%
		|";
		Текст = СтрЗаменить(текст,"%pid",Формат(pid,"ЧРГ=; ЧГ=0"));
		Если flag = 1 Тогда
			Текст = Текст + "
			|WinShow, ahk_class Shell_TrayWnd";
		Иначе
		КонецЕсли;  
		
		showCaptionA.ahkTextDll(Текст);

		
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
		|#NoEnv
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
		Скрипт = "
		|#NoEnv
		|#KeyHistory 500
		|	WinMove, ahk_pid %pid ahk_class V8TopLevelFrame,,0,0,%A_ScreenWidth%,%A_ScreenHeight%
		|	Sleep 100
		|	WinWaitActive, ahk_pid %pid ahk_class V8TopLevelFrame, , 10
		|	WinRestore, ahk_id %hwnd%
		|	WinMaximize, ahk_id %hwnd%
		|	settimer, CheckFullScreen, -100
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
		|	Settimer, fun2, -1000
		|	return 1	
		|}
		|
		|fun2:
		|Gosub, CheckCenterWindow_Label
		|return
		|
		|CheckCenterWindow_Label:
		|WinGetClass, A_Class, A 
		|
		|if (A_Class == ""V8NewLocalFrameBaseWnd"") {
		|	WinGetPos, X, Y, W, H, A
		|	WindowCenter := (X+W/2)
		|	if ((WindowCenter < (A_ScreenWidth/2-1))&&(W<(A_ScreenWidth-1)))	{
		|		Send {alt down}{shift down}{VK52}{alt up}{shift up} ; Alt+Shift+R
		|	}
		|}
		|return
		|
		|
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
		|#NoEnv
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
		|#NoEnv
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
		|#NoEnv
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
	ирПлатформа = ирКэш.Получить();
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
			AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey","AutoHotkey.Script.UNICODE");
		Исключение
		КонецПопытки;
	КонецЕсли;
	
	Если AHK = Неопределено Тогда
		AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey","AutoHotkey.Script.UNICODE");
		Если AHK = Неопределено Тогда
			AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey","AutoHotkey.Script");
		КонецЕсли;
	КонецЕсли;
	AHKs.Добавить(AHK);
	Возврат AHK;
КонецФункции

Функция AHK2() Экспорт
	ирПлатформа = ирКэш.Получить();
	AHK = AHK;
	Попытка
		AHK = Новый COMОбъект("AutoHotkey2.Script");
	Исключение
	КонецПопытки;
	
	Если AHK = Неопределено Тогда
		
		AHK = ирПлатформа.ПолучитьCOMОбъектИзМакета("AutoHotkey2","AutoHotkey2.Script");
	КонецЕсли;
	Возврат AHK;	
КонецФункции

Функция Враппер()
	ирПлатформа = ирКэш.Получить();
	Враппер = Враппер;
	Попытка
		Враппер = Новый COMОбъект("DynamicWrapperX");	
	Исключение
	КонецПопытки;
	
	Если Враппер = Неопределено Тогда
		
		Враппер = ирПлатформа.ПолучитьCOMОбъектИзМакета("DynamicWrapperX32","DynamicWrapperX");
	КонецЕсли;
	
	Возврат Враппер;
КонецФункции

Процедура Подсказка(Текст) Экспорт
	ПоказатьПлашку("-", Текст, 5, "3000",0,200);
КонецПроцедуры

Процедура Подсказка_(Текст) Экспорт
	AHK=AutohotkeyDll;
	Если AHK = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Текст = СтрЗаменить(Текст, "%", "");
	AHK.ahkTextDll("
	|#NoTrayIcon
	|#NoEnv
	|ToolTip " + Текст + "
	|Sleep 2000
	|ExitApp");
КонецПроцедуры

Процедура ПоказатьПлашку(Заголовок = "(:-)", Знач Текст = "", НомерПлашки = 0, Таймаут = "2500", Лево = 0, Прозрачность = 255, Ширина = 300, Высота = 180, РазмерШрифта1 = 14, РазмерШрифта2 = 9, Отладка = Ложь) Экспорт
	Текст = СтрЗаменить(Текст, Символы.ПС, "`n");
	Текст = СтрЗаменить(Текст, ";", "");
	Текст = СтрЗаменить(Текст, """", """""");
	
	Если НомерПлашки = 0 Тогда
		НомерПлашки = ТекНомерПлашки%4+1;
		ТекНомерПлашки=ТекНомерПлашки+1;
		
	КонецЕсли;
	Если AHK_Balloon = Неопределено Тогда
		AHK_Balloon = AHK(,"Balloon");
		Скрипт = "#NoTrayIcon
		|#NoEnv
		|Global w1
		|Global w2
		|Global w3
		|Global w4
		|Global w5
		|Global w6
		|Global w7
		|Global w8
		|Global w9
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
		|Global marginY := 25
		|Global fontSize1 := %РазмерШрифта1%
		|Global fontSize2 := %РазмерШрифта2%
		|
		|Global WINDOW_WIDTH := %Ширина%
		|Global WINDOW_HEIGHT := %Высота%	
		|Global WINDOW_X := (A_ScreenWidth - (WINDOW_WIDTH + marginX))
		|Global animateEffect := AW_BLEND|AW_HOR_POSITIVE
		|
		|class MessageWindow {
		|	
		|	
		|	y := 0
		|	stepTrans := 0
		|	hwnd := 0
		|	trans := 255
		|	
		|	__New(pIndex, pCaption, pText,pTimeout) {
		|		this.dTrans		:= 1
		|		this.stepTrans	:= 0	
		|		this.timeout 	:= pTimeout
		|		
		|		
		|		; ширина и высота окна, можно изменить на 1
		|		this.index := pIndex
		|		if (pindex <= 4) {
		|			this.y := (pIndex-1)*(WINDOW_HEIGHT+marginY)+marginY*2
		|			this.x := WINDOW_X
		|		} else {
		|			this.x := (A_ScreenWidth/2)-(WINDOW_WIDTH/2)
		|			this.y := A_screenHeight - WINDOW_HEIGHT - 20
		|		}
		|		
		|		this.strCaption := pCaption
		|		this.strText := pText
		|		this.callback := ObjBindMethod(this, ""TransDecFunc"")
		|		
		|	}
		|	
		|	__Delete()
		|	{
		|		index := this.index
		|		Gui,G%index%:Destroy
		|		OnMessage(0x201, this.WM_LBUTTONDOWN,0)
		|	}
		|	
		|	
		|	show() {
		|		index := this.index
		|		Gui,G%index%:+AlwaysOnTop -Caption +ToolWindow +LastFound -border
		|		
		|		Gui,G%index%: Font, s%fontSize1%,Segoe UI
		|		
		|		if (mod(index,2)==1) {
		|			Gui,G%index%: Color, %ACCENT_COLOR%
		|		} else {
		|			Gui,G%index%: Color, %THEME_COLOR%
		|		}
		|
		|		Gui,G%index%: Add, Text,  W1000, % this.strCaption
		|		Width := WINDOW_WIDTH - 40
		|		if (this.index <= 4) {
		|			Gui,G%index%: Font, s%fontSize2%
		|			Gui,G%index%: Add, Text, W%Width% H200 , % this.strText
		|		} else {
		|			Gui,G%index%: Font, s20
		|			Gui,G%index%: Add, Text, CXY W%Width% H200 , % this.strText
		|		}
		|		
		|		
		|
		|		win_y := this.y
		|		win_x := this.x
		|		Gui,G%index%: Show, y%win_y% x%win_x%  w%WINDOW_WIDTH% h%WINDOW_HEIGHT% hide ; показываем окно в выбранных координатах и размерах
		|		hwnd := WinExist()
		|		this.hwnd := WinExist()
		|		DllCall(""AnimateWindow"", Ptr, hwnd, UInt, 300, UInt, animateEffect)   ; выдвигаем/задвигаем окно-слайдер
		|		
		|;		WinSet, ExStyle, % ""+"" WS_EX_LAYERED | WS_EX_TRANSPARENT   ; добавляем прозрачность для кликов мыши
		|		WinSet, Transparent, % this.trans
		|		
		|		if (this.timeout) {
		|			this.hide(-this.timeout)
		|		}
		|		this.WM_LBUTTONDOWN := ObjBindMethod(this, ""LBUTTONDOWN"")
		|		OnMessage(0x201, this.WM_LBUTTONDOWN)
		|
		|		
		|	}
		|		
		|	
		|	hide(after_ms=0) {
		|		
		|		callback := this.callback
		|		SetTimer,% callback, %after_ms%
		|	}
		|	
		|	TransDecFunc() {
		|		MouseGetPos,X,Y,hwnd
		|		if (hwnd == this.hwnd) {
		|			this.stepTrans := 0
		|			this.dTrans := 1
		|			this.trans := 255
		|			WinSet, Transparent, % this.trans, % ""ahk_id "" + this.hwnd
		|			SetTimer,,Off
		|			this.hide(-2500)
		|			return
		|		}
		|		this.stepTrans := this.stepTrans + 1
		|		this.dTrans := this.dTrans + (255.0/this.trans)**(1/1.1)
		|		this.trans := this.trans - this.dTrans
		|		
		|		if (this.trans>0) {
		|			WinSet, Transparent, % this.trans, % ""ahk_id "" + this.hwnd
		|			this.hide(-50)
		|		} else {
		|			index := this.index
		|			SetTimer,,Off
		|			OnMessage(0x201, this.WM_LBUTTONDOWN,0)
		|			Gui,G%index%:Destroy
		|			this.WM_LBUTTONDOWN := 0
		|			this.Callback := 0
		|			w%index% := 0			
		|		}
		|	}
		|	
		|	
		|	LBUTTONDOWN(wParam, lParam, msg, hwnd)
		|	{
		|		ThWND := THIS.hwnd	
		|		if (hwnd == this.hwnd)|(!this.hwnd)
		|		{
		|			index := this.index
		|			OnMessage(0x201, this.WM_LBUTTONDOWN,0)
		|			Gui,G%index%:Destroy
		|			this.WM_LBUTTONDOWN := 0
		|			if (!this.timeout)
		|				this.Callback := 0
		|			w%index% := 0
		|		}
		|	
		|	}
		|	
		|	
		|}
		|
		|
		|Global curCaption, curText, curIndex, curTimeout, curTrans
		|
		|ShowMessage() {
		|	w%curIndex% := new MessageWindow(curIndex,curCaption, curText, curTimeout)
		|	if (curTrans)
		|		w%curIndex%.trans := curTrans
		|	w%curindex%.show()
		|}
		|
		|
		|
		|DeleteMessage() {
		|	this := w%curindex%
		|	this.timeout := 1
		|	this.hide(-1)
		|}
		|";
		Скрипт = СтрЗаменить(Скрипт, "%Ширина%", Формат(Ширина,"ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт, "%Высота%", Формат(Высота,"ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт, "%РазмерШрифта2%", Формат(РазмерШрифта2,"ЧГ=0"));
		Скрипт = СтрЗаменить(Скрипт, "%РазмерШрифта1%", Формат(РазмерШрифта1,"ЧГ=0"));
		Если Отладка Тогда
			Скрипт = СтрЗаменить(Скрипт, "#NoTrayIcon", "");
		КонецЕсли;
		AHK_Balloon.ahktextdll(Скрипт);	
	КонецЕсли;
	Если ЗначениеЗаполнено(Лево) Тогда
		AHK_Balloon.ahkassign("Window_X", Лево);	
	Иначе
		AHK_Balloon.addScript("WINDOW_X := (A_ScreenWidth - (WINDOW_WIDTH + marginX))",2);	
	КонецЕсли;
	
	AHK_Balloon.addScript(
	СтрШаблон(
	"curIndex := %1
	|curCaption := ""%2""
	|curText := ""%3""
	|curTimeout := %4
	|curTrans := %5
	|WINDOW_WIDTH := %6
	|WINDOW_HEIGHT := %7
	|fontSize1 := %8
	|fontSize2 := %9
	|ShowMessage()",
	НомерПлашки, Заголовок, Текст, Формат(Таймаут,"ЧГ=0"), Прозрачность,Ширина,Высота,РазмерШрифта1, РазмерШрифта2)
	, 2); 
	
КонецПроцедуры

Процедура УдалитьПлашку(НомерПлашки) Экспорт
	Если AHK_Balloon = Неопределено Тогда
		Возврат;
	КонецЕсли;
	AHK_Balloon.addScript(
	СтрШаблон(
	"
	|curIndex := %1
	|
	|DeleteMessage()",
	НомерПлашки)
	, 2); 
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