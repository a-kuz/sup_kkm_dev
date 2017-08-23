Перем AHK;
Перем Prefix Экспорт;
Перем Suffix Экспорт;
Процедура Инициализация() Экспорт
	DecPrefix = КодСимвола(Prefix);
	HexPrefix = DecToAny(DecPrefix, 16);
	PrefixStr = Прав("0" + HexPrefix, 2);
	Если PrefixStr = "35" Тогда
		PrefixStr = "+5";
	Иначе
		PrefixStr = "{VK"+PrefixStr+"}";
	КонецЕсли;
	
	VK_SuffixStr = "";
	Для Инд = 1 По СтрДлина(Suffix) Цикл
		StrSuffix = сред((Suffix),Инд,1);
		DecSuffix = КодСимвола(StrSuffix);
		HexSuffix = DecToAny(DecSuffix, 16);
		
		VK_SuffixStr = VK_SuffixStr + "{VK" + Прав("0" + HexSuffix, 2) + "}";
	КонецЦикла;

	РаботаСокнами=РаботаСокнами;
	AHK = РаботаСокнами.AHK();
	Скрипт = "
	|#InstallKeybdHook
	|
	|isHidden := 1
	|
	|Gui, +LastFound  -Caption +HwndB2hwnd +ToolWindow +Disabled  +AlwaysOnTop ; +E%ExStyle%
	|
	|Gui, Add, Text, vCapt w200 x0 Center y0 h80
	|Gui, Font, Segoe UI Light s48 
	|GuiControl, Font, Capt
	|		
	|SetKeyDelay, 1
	|strInput := """"
	|#InputLevel 1
	|~1::Gosub proc
	|~2::Gosub proc
	|~3::Gosub proc
	|~4::Gosub proc
	|~5::Gosub proc
	|~6::Gosub proc
	|~7::Gosub proc                                                                             
	|~8::Gosub proc
	|~9::Gosub proc
	|~0::Gosub proc
	|#InputLevel 0 
	|~Numpad1::Gosub proc
	|~Numpad2::Gosub proc
	|~Numpad3::Gosub proc
	|~Numpad4::Gosub proc
	|~Numpad5::Gosub proc
	|~Numpad6::Gosub proc
	|~Numpad7::Gosub proc
	|~Numpad8::Gosub proc
	|~Numpad9::Gosub proc
	|~Numpad0::Gosub proc
	|proc:
	|	If WinExist(""ahk_class V8NewLocalFrameBaseWnd"") {
	|		WinGetTitle, WinT , ahk_class V8NewLocalFrameBaseWnd
	|		if (RegExMatch(WinT, ""Тестирование рабочего места"") == 0) {
	|			Gosub, RTT
	|			return
	|		}
	|	}
	|	
	|	Settimer, RTT, off
	|	SetTimer, clear, -1000
	|	strHotKey := """"+StrReplace(A_ThisHotKey, ""Numpad"")
	|	strHotkey := StrReplace(strHotkey,""~"")
	|	strHotkey := StrReplace(strHotkey,""$"")
	|	if (isPaused==0) {
	|		strInput := strInput . strHotKey                                                           
	|	
	|		if (isHidden==1) {
	|			Gui, Show, NoActivate W200 H80
	|		}
	|		isHidden := 0
	|		GuiControl,, Capt, %strInput%
	|	
	|		Settimer, RTT, -1000
	|	
	|		if (strLen(strInput)=3) {
	|			strOutput := strInput
	|			strInput := """"
	|			SetLocale()
	|			Send {Shift UP}
	|			SendEvent %PrefixStr%%strOutput%%Suffix%
	|		}
	|	}
	|
	|return
	|
	|~+VK35::
	|~VKBA::
	|PrefixProc:
	|	
	|		Gosub, RTT
	|		isPaused := 1
	|		SetTimer, Start, -900
	|		SetTimer, Stop, -1
	|	
	|return
	|
	|Clear:
	|	strInput := """"
	|return
	|
	|RTT:
	|	Gui, Hide
	|	isHidden := 1
	|return
	|
	|Stop() 
	|{
	|	Gosub, RTT
	|	global isPaused := 1
	|   Settimer, lStop, -1
	|}
	|
	|Start()
	|{
	|	global isPaused := 0
	|	suspend,off  
	|	pause,off
	|}
	|
	|lStop:
	|	Gosub, RTT
	|	Suspend,On
	|return
	|
	|SetLocale()
	|{
	|  SetFormat, Integer, H
	|  LocaleEn=0x4090409  ; Английский (американский).
	|  SendMessage, 0x50,, % LocaleEn,, ahk_exe 1cv8.exe
	|}
	|";
	Скрипт = СтрЗаменить(Скрипт, "%PrefixStr%", PrefixStr);
	Скрипт = СтрЗаменить(Скрипт, "%Suffix%", VK_SuffixStr);
	Попытка
		AHK.ahkTextDll(Скрипт);  		
	Исключение
	КонецПопытки;
КонецПроцедуры

Процедура Деструктор() Экспорт
	Попытка
		//AHK.Ahkterminate();	
	Исключение
	КонецПопытки;
	AHK = Неопределено;
КонецПроцедуры

Процедура Выключить() Экспорт
	AHK.ahkFunction("Stop")	
КонецПроцедуры

Процедура Включить() Экспорт
	AHK.ahkFunction("Start");	
КонецПроцедуры

