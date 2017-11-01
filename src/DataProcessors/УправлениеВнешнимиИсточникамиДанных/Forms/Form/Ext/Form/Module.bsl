&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
    
    Var haveAdmin, TStr;
    haveAdmin = False;
    
	MetaPath = FormAttributeToValue("Object").Metadata().FullName();
    For Each ExternalDataSourceMetadata In Metadata.ExternalDataSources Do
        If Not AccessRight("Use", ExternalDataSourceMetadata) Then
            Continue;
        EndIf;
        TStr = ExternalSourcesProp.Add();
        TStr.Name = ExternalDataSourceMetadata.Name;
		TStr.Synonym = ExternalDataSourceMetadata.Presentation();
		//TStr.Synonym = ExternalDataSourceMetadata.Synonym;
		//If TStr.Synonym = "" Then
		//	TStr.Synonym = TStr.Name;
		//EndIf;
        TStr.Administrator = AccessRight("Administration", ExternalDataSourceMetadata);
        TStr.CanSave = AccessRight("StandardAuthenticationChange", ExternalDataSourceMetadata);
        
        If TStr.Administrator Then
            haveAdmin = True;
        EndIf;
    EndDo;
    
    If Not haveAdmin Then
        Items.AdministrationGroup.Visible = False;
    EndIf;
    
    RefreshState();
	
EndProcedure

&AtServer
Procedure RefreshState()
    Var ExternalDataSource;
    
    For Each TStr In ExternalSourcesProp Do
        ExternalDataSource = ExternalDataSources[TStr.Name];
        If ExternalDataSource.GetState() = ExternalDataSourceState.Connected Then
            TStr.Connected = True;
        Else
            TStr.Connected = False;
        EndIf;
	EndDo;
	
EndProcedure

&AtServer
Procedure EstablishConnection(ExternalDataSourceName, Set, RemoveUserPassword)
    
    Var ExternalDataSourceMetadata, ExternalDataSource, SessionEDSParameters, UserParameters;
    
    Try
        ExternalDataSourceMetadata = Metadata.ExternalDataSources[ExternalDataSourceName];
        ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
        If Set Then
            ExternalDataSource.Connect();
        Else
            ExternalDataSource.Disconnect();
            SessionEDSParameters = ExternalDataSource.GetSessionConnectionParameters();
            If AccessRight("SessionOSAuthenticationChange", ExternalDataSourceMetadata) Then
				// Удалим из текущего сеанса аутентификацию ОС
                SessionEDSParameters.OSAuthentication = Undefined;
            EndIf;
            If AccessRight("SessionStandardAuthenticationChange", ExternalDataSourceMetadata) Then
				// Удалим из текущего сеанса имя и пароль.
                SessionEDSParameters.StandardAuthentication = Undefined;
                SessionEDSParameters.UserName = Undefined;
                SessionEDSParameters.Password = Undefined;
            EndIf;
            ExternalDataSource.SetSessionConnectionParameters(SessionEDSParameters);
            If RemoveUserPassword Then
                UserParameters = ExternalDataSource.GetUserConnectionParameters(InfoBaseUsers.CurrentUser().Name);
                If AccessRight("StandardAuthenticationChange", ExternalDataSourceMetadata) Then
					// Удалим для текущего пользователя пароль.
                    UserParameters.StandardAuthentication = Undefined;
                    UserParameters.UserName = Undefined;
                    UserParameters.Password = Undefined;
                EndIf;
                If AccessRight("SessionOSAuthenticationChange", ExternalDataSourceMetadata) Then
					// Удалим для текущего пользователя аутентификацию ОС
                    UserParameters.OSAuthentication = Undefined;
                EndIf;
                ExternalDataSource.SetUserConnectionParameters(InfoBaseUsers.CurrentUser().Name, UserParameters);
            EndIf;
        EndIf;
        RefreshState();
    Except
        RefreshState();
        Raise;
    EndTry;
EndProcedure

&AtServer
Function ConnectionParametersToStructure(ConnectionParameters)
    Var Result;
    
    Result = New Structure;
    Result.Insert("OSAuthentication", ConnectionParameters.OSAuthentication);
    Result.Insert("OSAuthenticationOn", ConnectionParameters.OSAuthentication <> Undefined);
    Result.Insert("StandardAuthentication", ConnectionParameters.StandardAuthentication);
    Result.Insert("StandardAuthenticationOn", ConnectionParameters.StandardAuthentication <> Undefined);
    Result.Insert("UserName", ConnectionParameters.UserName);
    Result.Insert("UserNameOn", ConnectionParameters.UserName <> Undefined);
    Result.Insert("PasswordIsSet", ConnectionParameters.PasswordIsSet);
    Result.Insert("ConnectionString", ConnectionParameters.ConnectionString);
    Result.Insert("ConnectionStringOn", ConnectionParameters.ConnectionString <> Undefined);
    Result.Insert("DBMS", ConnectionParameters.DBMS);
    Result.Insert("DBMSOn", ConnectionParameters.DBMS <> Undefined);
    Return Result;
	
EndFunction

&AtServer
Function StructureToConnectionParameters(Structure, ConnectionParameters)
	
    ConnectionParameters.OSAuthentication = ?(Structure.OSAuthenticationOn, Structure.OSAuthentication, Undefined);
    ConnectionParameters.StandardAuthentication = ?(Structure.StandardAuthenticationOn, Structure.StandardAuthentication, Undefined);
    ConnectionParameters.UserName = ?(Structure.UserNameOn, Structure.UserName, Undefined);
    If Structure.PasswordChanged Then
        ConnectionParameters.Password = ?(Structure.PasswordIsSet, Structure.Password, Undefined);
    EndIf;
    ConnectionParameters.ConnectionString = ?(Structure.ConnectionStringOn, Structure.ConnectionString, Undefined);
    ConnectionParameters.DBMS = ?(Structure.DBMSOn, Structure.DBMS, Undefined);
	
EndFunction

&AtServer
Function GetSessionConnectionParameters(ExternalDataSourceName)
    Var ExternalDataSource;
    
    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    Return ConnectionParametersToStructure(ExternalDataSource.GetSessionConnectionParameters());
	
EndFunction

&AtServer
Function SetSessionConnectionParameters(ExternalDataSourceName, Structure)
    Var ExternalDataSource, ConnectionParameters;
    
    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    ConnectionParameters = ExternalDataSource.GetSessionConnectionParameters();
    StructureToConnectionParameters(Structure, ConnectionParameters);
    ExternalDataSource.SetSessionConnectionParameters(ConnectionParameters);
	
EndFunction

&AtServer
Function GetConnectionParameters(ExternalDataSourceName)
    Var ExternalDataSource;

    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    Return ConnectionParametersToStructure(ExternalDataSource.GetUserConnectionParameters(InfoBaseUsers.CurrentUser().Name));
	
EndFunction

&AtServer
Function SetConnectionParameters(ExternalDataSourceName, Structure)
    Var ExternalDataSource, ConnectionParameters;
    
    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    ConnectionParameters = ExternalDataSource.GetUserConnectionParameters(InfoBaseUsers.CurrentUser().Name);
    StructureToConnectionParameters(Structure, ConnectionParameters);
    ExternalDataSource.SetUserConnectionParameters(InfoBaseUsers.CurrentUser().Name, ConnectionParameters);
	
EndFunction

&AtServer
Function GetCommonConnectionParameters(ExternalDataSourceName)
    Var ExternalDataSource;

    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    Return ConnectionParametersToStructure(ExternalDataSource.GetCommonConnectionParameters());
	
EndFunction

&AtServer
Function SetCommonConnectionParameters(ExternalDataSourceName, Structure)
    Var ExternalDataSource, ConnectionParameters;
    
    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    ConnectionParameters = ExternalDataSource.GetCommonConnectionParameters();
    StructureToConnectionParameters(Structure, ConnectionParameters);
    ExternalDataSource.SetCommonConnectionParameters(ConnectionParameters);
	
EndFunction

&AtClient
Procedure ChangeUsersParameters(Command)
	
	If Items.ExternalSourcesProp.CurrentRow <> Undefined Then
        If Items.ExternalSourcesProp.CurrentData.Administrator Then
			//OpenForm("ExternalDataProcessor.StandardExternalDataSourcesManagement.Form.UsersConnectionParameters", New Structure("DataSourceName", Items.ExternalSourcesProp.CurrentData.Name));
			OpenForm(MetaPath + ".Form.UsersConnectionParameters", New Structure("DataSourceName", Items.ExternalSourcesProp.CurrentData.Name));
        Else
			ShowMessageBox( , NStr("ru = 'Только администратор источника данных может настраивать параметры пользователей.'; SYS = 'DataSourcesManagement.EditUserParameters'", "ru"));
			//DoMessageBox(NStr("ru = 'Только администратор источника данных может настраивать параметры пользователей.'; SYS = 'DataSourcesManagement.EditUserParameters'", "ru"));
        EndIf;
	EndIf;
	
EndProcedure

&AtClient
Procedure ChangeCommonParameters(Command)
    Var Params, Callback;
    
    If Items.ExternalSourcesProp.CurrentRow <> Undefined Then
		If Items.ExternalSourcesProp.CurrentData.Administrator Then
			Callback = New NotifyDescription("ChangeCommonParametersCallback", ThisForm);
			Params = New Structure;
			Params.Insert("Parameters", GetCommonConnectionParameters(Items.ExternalSourcesProp.CurrentData.Name));
			Params.Insert("DataSourcePresentation", Items.ExternalSourcesProp.CurrentData.Synonym);
			OpenForm(MetaPath + ".Form.ConnectionParameters", Params, , , , , Callback);
			//Form = GetForm("ExternalDataProcessor.StandardExternalDataSourcesManagement.Form.ConnectionParameters", New Structure("Parameters,DataSourcePresentation", GetCommonConnectionParameters(Items.ExternalSourcesProp.CurrentData.Name), Items.ExternalSourcesProp.CurrentData.Synonym));
			//
			//If Form.DoModal() = DialogReturnCode.OK Then
			//	SetCommonConnectionParameters(Items.ExternalSourcesProp.CurrentData.Name, Form.GetConnectionParameters());
			//EndIf;
		Else
			ShowMessageBox( , NStr("ru = 'Только администратор источника данных может настраивать общие параметры.'; SYS = 'DataSourcesManagement.EditCommonParameters'", "ru"));
			//DoMessageBox(NStr("ru = 'Только администратор источника данных может настраивать общие параметры.'; SYS = 'DataSourcesManagement.EditCommonParameters'", "ru"));
        EndIf;
	EndIf;
	
EndProcedure

&AtClient
Procedure ChangeCommonParametersCallback(Result, ExtraParameters) Export
	
	If Result <> Undefined AND Result.Result = DialogReturnCode.OK Then
		SetCommonConnectionParameters(Items.ExternalSourcesProp.CurrentData.Name, Result.Parameters);
	EndIf;
	
EndProcedure

&AtClient
Procedure Connect(Command)
    Var Callback;
    
	If Items.ExternalSourcesProp.CurrentRow <> Undefined Then
		Callback = New NotifyDescription("ConnectCallback", ThisForm);
		OpenForm("sysForm:EDBConnectSysForm", New Structure("Name", Items.ExternalSourcesProp.CurrentData.Name), , , , , Callback, FormWindowOpeningMode.LockOwnerWindow);
		//Form = GetForm("sysForm:EDBConnectSysForm", New Structure("Name", Items.ExternalSourcesProp.CurrentData.Name));
		//Form.DoModal();
		//RefreshState();
	EndIf;
	
EndProcedure

&AtClient
Procedure ConnectCallback(Result, ExtraParameters) Export
	
	RefreshState();
	
EndProcedure

&AtClient
Procedure Disconnect(Command)
    Var Callback;
    
	If Items.ExternalSourcesProp.CurrentRow <> Undefined Then
		If Items.ExternalSourcesProp.CurrentData.CanSave OR Items.ExternalSourcesProp.CurrentData.Administrator Then
			Callback = New NotifyDescription("DisconnectCallback", ThisForm);
			ShowQueryBox(Callback, NStr("ru = 'Очистить сохраненный пароль?'; SYS = 'DataSourcesManagement.RemovePassword'", "ru"), QuestionDialogMode.YesNoCancel);
		EndIf;
		
		//Answer = DialogReturnCode.No;
		//If Items.ExternalSourcesProp.CurrentData.CanSave OR Items.ExternalSourcesProp.CurrentData.Administrator Then
		//	Answer = DoQueryBox(NStr("ru = 'Очистить сохраненный пароль?'; SYS = 'DataSourcesManagement.RemovePassword'", "ru"), QuestionDialogMode.YesNoCancel);
		//EndIf;
		//If Answer = DialogReturnCode.Yes Or Answer = DialogReturnCode.No Then
		//	EstablishConnection(Items.ExternalSourcesProp.CurrentData.Name, False, Answer = DialogReturnCode.Yes);
		//EndIf;
    EndIf;
EndProcedure

&AtClient
Procedure DisconnectCallback(Result, ExtraParameters) Export
	
	If Result = DialogReturnCode.Yes Or Result = DialogReturnCode.No Then
		EstablishConnection(Items.ExternalSourcesProp.CurrentData.Name, False, Result = DialogReturnCode.Yes);
	EndIf;
	
EndProcedure

&НаКлиенте
Процедура ExternalSourcesPropВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	#Если не ТонкийКлиент Тогда
		СЗ = новый СписокЗначений;
		Для Каждого Т Из Метаданные.ВнешниеИсточникиДанных[Элемент.ДанныеСтроки(ВыбраннаяСтрока).Name].Таблицы Цикл
			СЗ.Добавить(Т.Имя);
		КонецЦикла;
		Эл = СЗ.ВыбратьЭлемент();
		Если эл <> Неопределено Тогда
			ОткрытьФорму(СтрШаблон("ВнешнийИсточникДанных.%1.Таблица.%2.ФормаСписка", Элемент.ДанныеСтроки(ВыбраннаяСтрока).Name, эл.Значение));
		КонецЕсли;
		
		
	#Иначе
		ОткрытьФорму(СтрШаблон("ВнешнийИсточникДанных.%1.Таблица.%2.ФормаСписка", Элемент.ДанныеСтроки(ВыбраннаяСтрока).Name, "КонтрольныеПоказатели_Значения"));
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ExternalSourcesPropПриАктивизацииСтроки(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры


