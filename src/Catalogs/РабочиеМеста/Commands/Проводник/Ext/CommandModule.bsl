﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	Путь = Сеть.ИмяХостаРМ(ПараметрКоманды, Истина);
	Сеть.ПодключитьШару(Путь);
	ЗапуститьПриложение("explorer \\" + Путь + "\c$");
КонецПроцедуры
