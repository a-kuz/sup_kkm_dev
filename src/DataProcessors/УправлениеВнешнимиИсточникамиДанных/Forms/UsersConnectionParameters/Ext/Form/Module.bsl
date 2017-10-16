&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Var ExternalDataSourceMetadata, IBUsers;
	
	MetaPath = FormAttributeToValue("Object").Metadata().FullName();
	ExternalDataSourceMetadata = Metadata.ExternalDataSources[Parameters.DataSourceName];
	DataSourceSynonym = ExternalDataSourceMetadata.Synonym;
	If IsBlankString(ExternalDataSourceMetadata.Synonym) Then
		DataSourceSynonym = ExternalDataSourceMetadata.Name;
	EndIf;
	
	IBUsers = InfoBaseUsers.GetUsers();
	For Each User In IBUsers Do
		Users.Add(User.Name);
	EndDo;
	
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
Function GetConnectionParameters(ExternalDataSourceName, UserName)
    Var ExternalDataSource;
    
    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    Return ConnectionParametersToStructure(ExternalDataSource.GetUserConnectionParameters(UserName));
	
EndFunction

&AtServer
Function SetConnectionParameters(ExternalDataSourceName, UserName, Structure)
    Var ExternalDataSource, ConnectionParameters;
    
    ExternalDataSource = ExternalDataSources[ExternalDataSourceName];
    ConnectionParameters = ExternalDataSource.GetUserConnectionParameters(UserName);
    StructureToConnectionParameters(Structure, ConnectionParameters);
    ExternalDataSource.SetUserConnectionParameters(UserName, ConnectionParameters);
	
EndFunction

&AtClient
Procedure ConnectionParameters()
    Var Params;
    
    If Items.Users.CurrentRow <> Undefined Then
		Callback = New NotifyDescription("ConnectionParametersCallback", ThisForm);
		Params = New Structure;
		Params.Insert("Parameters", GetConnectionParameters(Parameters.DataSourceName, Items.Users.CurrentData.Value));
		Params.Insert("DataSourcePresentation", DataSourceSynonym);
		Params.Insert("IBUser", Items.Users.CurrentData.Value);
		OpenForm(MetaPath + ".Form.ConnectionParameters", Params, , , , , Callback);
		//Form = GetForm("ExternalDataProcessor.StandardExternalDataSourcesManagement.Form.ConnectionParameters", New Structure("Parameters,DataSourcePresentation,IBUser", GetConnectionParameters(Parameters.DataSourceName, Items.Users.CurrentData.Value), DataSourceSynonym, Items.Users.CurrentData.Value));
		//
		//If Form.DoModal() = DialogReturnCode.OK Then
		//	SetConnectionParameters(Parameters.DataSourceName, Items.Users.CurrentData.Value, Form.GetConnectionParameters());
		//EndIf;
	EndIf;
	
EndProcedure

&AtClient
Procedure ConnectionParametersCallback(Result, ExtraParameters) Export
	
	If Result <> Undefined AND Result.Result = DialogReturnCode.OK Then
		SetConnectionParameters(Parameters.DataSourceName, Items.Users.CurrentData.Value, Result.Parameters);
	EndIf;
	
EndProcedure

&AtClient
Procedure UsersBeforeRowChange(Item, Cancel)
	
    Cancel = True;
    ConnectionParameters();
	
EndProcedure
