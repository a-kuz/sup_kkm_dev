&AtClient
Function GetConnectionParameters()
    Var Result;

    Result = New Structure;
    Result.Insert("OSAuthentication", OSAuthentication);
    Result.Insert("OSAuthenticationOn", OSAuthenticationOn);
    Result.Insert("StandardAuthentication", StandardAuthentication);
    Result.Insert("StandardAuthenticationOn", StandardAuthenticationOn);
    Result.Insert("UserName", UserName);
    Result.Insert("UserNameOn", UserNameOn);
    Result.Insert("Password", Password);
    Result.Insert("PasswordIsSet", PasswordIsSet);
    Result.Insert("ConnectionString", ConnectionString);
    Result.Insert("ConnectionStringOn", ConnectionStringOn);
    Result.Insert("PasswordChanged", PasswordChanged);
    Result.Insert("DBMS", DBMS);
    Result.Insert("DBMSOn", DBMSOn);

    Return Result;
	
EndFunction

&AtClient
Procedure OK(Command)
	
	Result = New Structure;
	Result.Insert("Result", DialogReturnCode.OK);
	Result.Insert("Parameters", GetConnectionParameters());
    Close(Result);
	
EndProcedure

&AtClient
Procedure Cancel(Command)
	
	Result = New Structure;
	Result.Insert("Result", DialogReturnCode.Cancel);
	Result.Insert("Parameters", GetConnectionParameters());
    Close(Result);
	
EndProcedure

&AtServer
Procedure SetAuthenticationOSEnabledOnServer()
    OSAuthentication = False;
    OSAuthenticationOn = False;
EndProcedure

&AtClient
Procedure SetAuthenticationOSEnabled()
	If DBMS = "MSSQLServerAnalysisServices" Or DBMS = "OracleEssbase" Or DBMS = "IBMInfosphereWarehouse" Then
		SetAuthenticationOSEnabledOnServer();
		Items.OSAutenticationOn.Enabled = False;
		Items.OSAutentication.Enabled = False;
	ElsIf DBMS = "MSSQLServer" Or DBMS = "OracleDatabase" Or DBMS = "IBMDB2" Or DBMS = "PostgreSQL" Or DBMS = "MySQL" Then	
		Items.OSAutenticationOn.Enabled = True;
		Items.OSAutentication.Enabled = True;	
	Else	
		If Upper(Left(ConnectionString, 7)) = "HTTP://" Then
			SetAuthenticationOSEnabledOnServer();
			Items.OSAutenticationOn.Enabled = False;
			Items.OSAutentication.Enabled = False;
		Else
			Items.OSAutenticationOn.Enabled = True;
			Items.OSAutentication.Enabled = True;
		EndIf;
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
    DataSourcePresentation = Parameters.DataSourcePresentation;
    If Parameters.IBUser = "" Then
        Items.EditedUser.Visible = False;
    Else
        EditedUser = Parameters.IBUser;
    EndIf;
    OSAuthentication = Parameters.Parameters.OSAuthentication;
    OSAuthenticationOn = Parameters.Parameters.OSAuthenticationOn;
    StandardAuthentication = Parameters.Parameters.StandardAuthentication;
    StandardAuthenticationOn = Parameters.Parameters.StandardAuthenticationOn;
    UserName = Parameters.Parameters.UserName;
    UserNameOn = Parameters.Parameters.UserNameOn;
    If Parameters.Parameters.PasswordIsSet = True Then
        Password = "------";
    EndIf;
    PasswordIsSet = Parameters.Parameters.PasswordIsSet;
    ConnectionString = Parameters.Parameters.ConnectionString;
    ConnectionStringOn = Parameters.Parameters.ConnectionStringOn;
    DBMS = Parameters.Parameters.DBMS;
    DBMSOn = Parameters.Parameters.DBMSOn;
EndProcedure

&AtClient
Procedure PasswordOnChange(Item)
    PasswordChanged = True;
    PasswordIsSet = True;
EndProcedure

&AtClient
Procedure PasswordIsSetOnChange(Item)
    PasswordChanged = True;
    Password = "";
EndProcedure

&AtClient
Procedure StandardAuthenticationOnChange(Item)
    StandardAuthenticationOn = true;
EndProcedure

&AtClient
Procedure UserNameOnChange(Item)
    UserNameOn = True;
EndProcedure

&AtClient
Procedure ConnectionStringOnChange(Item)
    ConnectionStringOn = True;
	SetAuthenticationOSEnabled();
EndProcedure

&AtClient
Procedure DBMSOnChange(Item)
	DBMSOn = True;
	SetAuthenticationOSEnabled();
EndProcedure

&AtClient
Procedure OSAutenticationOnChange(Item)
    OSAuthenticationOn = true; 
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetAuthenticationOSEnabled();
EndProcedure
