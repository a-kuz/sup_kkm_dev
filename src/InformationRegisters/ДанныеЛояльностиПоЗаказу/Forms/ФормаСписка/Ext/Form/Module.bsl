﻿
&НаСервере
Процедура УдалитьВсеНаСервере()
	Лояльность.УдалитьДанныеЛояльностиПоЗаказу();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьВсе(Команда)
	УдалитьВсеНаСервере();
КонецПроцедуры
