
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	IBConnectionString = СтрокаСоединенияИнформационнойБазы();
	ЗапуститьПриложение(СтрШаблон("%2 ENTERPRISE /IBConnectionString%1 /WA+ /itdi /DisplayAllFunctions /RunModeOrdinaryApplication %3", 
								  IBConnectionString, КаталогПрограммы()+"1cv8.exe","/CВыполнитьОбработки.ПодборТоваров.ПолучитьФорму().Открыть()"));
КонецПроцедуры
