'*********************************Déclaration des variables globales*******************************
Option Explicit
Const ForReading = 1
Dim Titre,oExec,fso,objFile,ListInFile,ws,Temp,Voice,PathScript,DownloadFolder,LireTout,Choix
Titre = "Downloading File by © Hackoo 2013"
Set ws = CreateObject("wscript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
    ListInFile = "ListLinks.txt"
    If Not fso.FileExists(ListInFile) Then
           MsgBox "ATTENTION ERREUR !!! "& Vbcr &_
           "Le fichier "& DblQuote(ListInFile) &" n'existe pas ! "& Vbcr &_
           "Vous devez créer un fichier nommé " & DblQuote(ListInFile) &" avec ce script et y copier vos liens à télécharger !",16,Titre
           Wscript.Quit
    End If              
    Set objFile = FSO.OpenTextFile(ListInFile,ForReading)
        LireTout = objFile.ReadAll
    objFile.Close 
Temp = ws.ExpandEnvironmentStrings("%Temp%")
Set Voice = CreateObject("SAPI.SpVoice")
PathScript = fso.GetParentFolderName(wscript.ScriptFullName) 'Chemin ou se localise le Vbscript
DownloadFolder = PathScript & "\Download_Folder\"
CreerRep(DownloadFolder)
'**************************************************************************************************
Choix = ChooseOne(LireTout)
'MsgBox Choix
Function ChooseOne(LireTout)
'Returns one of several string choices. 
'Returns empty string if there is a problem.
Dim fs, web, doc
Dim strFile, strChoice
Dim intChars
Dim dtTime
    On Error Resume Next
    Set web = CreateObject("InternetExplorer.Application")
    If web Is Nothing Then
        ChooseOne = ""
        Exit Function
    End If
    'Increase displayed width to accomodate longest string choice
    intChars = 0
    For Each strChoice In Split(LireTout,VbcrLF)
        If Len(strChoice) > intChars Then intChars = Len(strChoice)
    Next
    If intChars > 20 Then
        web.Width = 250 + 6 * (intChars - 20)
    Else
        web.Width = 250
    End If
    web.Height = 200
    web.Offline = True
    web.AddressBar = False
    web.MenuBar = False
    web.StatusBar = False
    web.Silent = True
    web.ToolBar = False
    web.Navigate "about:blank"
    'Wait for the browser to navigate to nowhere
    dtTime = Now
    Do While web.Busy
        'Don't wait more than 5 seconds
        Wscript.Sleep 100
        If (dtTime + 5/24/60/60) < Now Then
            ChooseOne = ""
            web.Quit
            Exit Function
        End If
    Loop
    'Wait for a good reference to the browser document
    Set doc = Nothing
    dtTime = Now
    Do Until Not doc Is Nothing
        Wscript.Sleep 100
        Set doc = web.Document
        'Don't wait more than 5 seconds
        If (dtTime + 5/24/60/60) < Now Then
            ChooseOne = ""
            web.Quit
            Exit Function
        End If
    Loop
    'Write the HTML form
    doc.Write "<html><head><title>Choose</title></head>"
    doc.Write "<body text=""white"" bgColor=""Orange""><b>Please Choose a link to download it with this Application :</b><br><form><select name=""choice"">"
    For Each strChoice In Split(LireTout,VbCrLF)
        doc.Write "<option value=""" & strChoice & """>" & strChoice
    Next
    doc.Write "</select>"
    doc.Write "<br><br><input type=button "
    doc.Write "name=submit "
    doc.Write "value=""OK"" onclick='javascript:submit.value=""Done""'>"
    doc.Write "</form></body></html>"
    'Show the form
    web.Visible = True
    'Wait for the user to choose, but fail gracefully if a popup killer.
    Err.Clear
    Do Until doc.Forms(0).elements("submit").Value <> "OK"
        Wscript.Sleep 100
        If doc Is Nothing Then
            ChooseOne = ""
            web.Quit
            Exit Function
        End If
        If Err.Number <> 0 Then
            ChooseOne = ""
            web.Quit
            Exit Function
        End If
    Loop
    'Retrieve the chosen value
    ChooseOne = doc.Forms(0).elements("choice").Value
    web.Quit
End Function
'**************************************************************************************************
'Appel au programme principal ou on peut intégrer la barre de progression
Call DownloadingFile(choix)
'**************************************************************************************************
Sub DownloadingFile(choix)
Dim Titre,fso,Ws,objXMLHTTP,PathScript,Tab,strHDLocation,objADOStream,Command,Start,File,URL
Dim MsgTitre,MsgAttente,StartTime,DurationTime,ProtocoleHTTP
Set fso = Createobject("Scripting.FileSystemObject")
Set Ws = CreateObject("wscript.Shell")
ProtocoleHTTP = "http://"
PathScript = fso.GetParentFolderName(wscript.ScriptFullName) 'Chemin ou se localise le Vbscript
DownloadFolder = PathScript & "\Download_Folder\"
Titre = "Downloading File by © Hackoo 2013"
URL = InputBox("Tapez ou bien collez l'URL dans le champ de saisie Exemple : "&Dblquote(choix),Titre,Choix)
If URL = "" Then WScript.Quit
If Left(URL,7) <> ProtocoleHTTP Then
URL = ProtocoleHTTP & URL
MsgBox URL
End if
Tab = Split(url,"/")
File =  Tab(UBound(Tab))
File = Replace(File,"%20"," ")
File = Replace(File,"%28","(")
File = Replace(File,"%29",")")
Titre = "Downloading File : " & Dblquote(File) & " © Hackoo 2013"
    Set objXMLHTTP = CreateObject("MSXML2.ServerXMLHTTP.3.0")
    strHDLocation = DownloadFolder & File
    msgbox strHDLocation
    MsgAttente = "Veuillez patientez !"
    Call CreateProgressBar(Titre,MsgAttente)'Creation de barre de progression
    Voice.Speak "Please Wait a While ! The download of " & Dblquote(File) & " is in progress !"
    Call LancerProgressBar()'Lancement de la barre de progression
    StartTime = Timer'Début du Compteur Timer
    On Error Resume Next
    objXMLHTTP.open "GET", URL, false
    objXMLHTTP.send()
If Err.number <> 0 Then
     Call FermerProgressBar()'Fermeture de barre de progression
     MsgBox err.description,16,err.Description
     Exit Sub
 Else
    If objXMLHTTP.Status = 200 Then
    Set objADOStream = CreateObject("ADODB.Stream")
    objADOStream.Open
    objADOStream.Type = 1 'adTypeBinary
    objADOStream.Write objXMLHTTP.ResponseBody
    objADOStream.Position = 0    'Set the stream position to the start
    If fso.Fileexists(strHDLocation) Then fso.DeleteFile strHDLocation
    objADOStream.SaveToFile strHDLocation
    objADOStream.Close
    Set objADOStream = Nothing
    End if
End If

Set objXMLHTTP = Nothing
    DurationTime = FormatNumber(Timer - StartTime, 0) & " seconds."'La durée de l'exécution du script
    Call FermerProgressBar()'Fermeture de barre de progression
    Voice.Speak "The Download of " & Dblquote(File) & " is finished in " & DurationTime &" !"
'strHDLocation = PathScript & "\" & File
MsgBox "The Download of " & Dblquote(File) & " is finished in " & DurationTime &" !",64,"The Download of " & Dblquote(File) & " is finished in " & DurationTime &" !"
If Right(File,3) = "swf" Then
Dim NewFenetre,Exec,Question
    NewFenetre = "-new-window"
    Command = "Cmd /c CD %Programfiles%\Mozilla Firefox\ | Start Firefox.exe " & NewFenetre & " " & Dblquote(strHDLocation)
    MsgBox Command
    Exec = Ws.Run(Command,0,False)
    WScript.Sleep 5000
    Question = MsgBox ("Vouliez-vous ouvrir ce Jeu en plein écran ?" & Vbcr &_
 "SI Oui , alors cliquez sur [OUI]  ?"& Vbcr &_
 "Sinon , alors cliquez sur [NON]",VBYesNO+VbQuestion,Titre)
 If Question = VbYes then
    ws.AppActivate "file:///" & strHDLocation
    WS.SendKeys "{F11}"
 else
    WScript.Quit
 End if
else
Command = "Cmd /c start explorer "& Dblquote(strHDLocation) &" "
MsgBox command
Start = Ws.Run(Command,0,False)
End if
End Sub
'****************************************************************************************************
Sub CreateProgressBar(Titre,MsgAttente)
    Dim ws,fso,f,f2,ts,ts2,Ligne,i,fread,LireTout,NbLigneTotal,Temp,PathOutPutHTML,fhta,oExec
    Set ws = CreateObject("wscript.Shell")
    Set fso = CreateObject("Scripting.FileSystemObject")
    Set f = fso.GetFile(WScript.ScriptFullName)
    Set ts = f.OpenAsTextStream(1,-2)
    Set fread = Fso.OpenTextFile(f,1)
    LireTout = fread.ReadAll
    NbLigneTotal = fread.Line 
    Temp = WS.ExpandEnvironmentStrings("%Temp%")
    PathOutPutHTML = Temp & "\Barre.hta"
    Set fhta = fso.OpenTextFile(PathOutPutHTML,2,True)
    fso.CreateTextFile Temp & "\loader.gif"
    Set f2 = fso.GetFile(Temp & "\loader.gif")
    Set ts2 = f2.OpenAsTextStream(2,-2)
    for i=1 to NbLigneTotal - 1
        ts.skipline
    Next
    Do
        Ligne = ts.readline
        For i=2 to Len(Ligne) step 2
            ts2.write chr( "&h" & mid(Ligne,i,2))
        Next
    loop until ts.AtEndOfStream
    ts.Close
    ts2.Close
    fhta.WriteLine "<HTML>"
    fhta.WriteLine "<HEAD>" 
    fhta.WriteLine "<Title>" & Titre & "</Title>" 
    fhta.WriteLine "<HTA:APPLICATION"
    fhta.WriteLine "ICON = ""Defrag.exe"" "
    fhta.WriteLine "BORDER=""THIN"" "
    fhta.WriteLine "INNERBORDER=""NO"" "
    fhta.WriteLine "MAXIMIZEBUTTON=""NO"" "
    fhta.WriteLine "MINIMIZEBUTTON=""NO"" "
    fhta.WriteLine "SCROLL=""NO"" "
    fhta.WriteLine "SYSMENU=""NO"" "
    fhta.WriteLine "SELECTION=""NO"" " 
    fhta.WriteLine "SINGLEINSTANCE=""YES"">"
    fhta.WriteLine "</HEAD>" 
    fhta.WriteLine "<BODY text=""white""><CENTER><DIV><SPAN ID=""ProgressBar""></SPAN>"
    fhta.WriteLine "<span><marquee DIRECTION=""LEFT"" SCROLLAMOUNT=""3"" BEHAVIOR=ALTERNATE><font face=""Comic sans MS"">" & MsgAttente &" "& Titre & "</font></marquee></span></DIV></CENTER></BODY></HTML>"
    fhta.WriteLine "<SCRIPT LANGUAGE=""VBScript""> "
    fhta.WriteLine "Set ws = CreateObject(""wscript.Shell"")"
    fhta.WriteLine "Temp = WS.ExpandEnvironmentStrings(""%Temp%"")"
    fhta.WriteLine "Sub window_onload()"
    fhta.WriteLine "    CenterWindow 320,90"
    fhta.WriteLine "    Self.document.bgColor = ""Red"" "
    fhta.WriteLine "    image = ""<center><img src= "& Temp & "\loader.gif></center>"" "
    fhta.WriteLine "    ProgressBar.InnerHTML = image"
    fhta.WriteLine " End Sub"
    fhta.WriteLine " Sub CenterWindow(x,y)"
    fhta.WriteLine "    Dim iLeft,itop"
    fhta.WriteLine "    window.resizeTo x,y"
    fhta.WriteLine "    iLeft = window.screen.availWidth/2 - x/2"
    fhta.WriteLine "    itop = window.screen.availHeight/2 - y/2"
    fhta.WriteLine "    window.moveTo ileft,itop"
    fhta.WriteLine "End Sub"
    fhta.WriteLine "</script>"
End Sub
'**********************************************************************************************
Sub LancerProgressBar()
    Set oExec = Ws.Exec("mshta.exe " & Temp & "\Barre.hta")
End Sub
'**********************************************************************************************
Sub FermerProgressBar()
    oExec.Terminate
End Sub
'**********************************************************************************************
'Fonction pour ajouter les doubles quotes dans une variable
Function DblQuote(Str)
    DblQuote = Chr(34) & Str & Chr(34)
End Function
'************************************************************************************************
Sub CreerRep(Chemin)
    If Not fso.FolderExists(chemin) Then
        CreerRep(fso.GetParentFolderName(chemin))
        fso.CreateFolder(chemin)
    End If
End Sub
'************************************************************************************************
'47494638396180000F00F20000F3D9DDF15279F2BBC6F2B0BEF17492F1527900000000000021FF0B4E45545343415045322E30030100000021FE1A43726561746564207769746820616A61786C6F61642E696E666F0021F904090A0000002C0000000080000F000003E708B20BFEAC3D17C5A4F1AA7CABF61D3781A3089918B391AB5949A9FB96EC6B9DF58CCBB9DDF340D54E1823B68C365A107664FA744527B4798B56A94AE4343994FE9E57AE35EB5D86B7E86F590B5EBBCF6AB8992C67CFBB3EBA1EBF1FF3FF7E81587862838285886977878A760C039091031392919495930F98990E9B97959F92A1969A98A390A79C009B9EA5A0AEA2B0A49DA6B2A8B6AAADB4AFBBB1BDB3ABACBCC1C3BAC4BEC7C0C6CBB5BFB7CEB9CDC9C2A9D5B8D6D0D8D3D1C5D2CCC2CADEE2DDE4C8DFE6E3E8E5E0DAE7E1EBCFDBEDE9EFEAA2C3BF1AF8C9FAC8F917FB02FAE3077020A8040021F904090A0000002C0000000080000F000003FF08B40BFE22C607A5A0CE5EAC31E89CE581145949A318A24C5B6A5B06BF261C7FF3A9CA75CEEFB89EA6C5A0016D46944EF963068FBEA713B99C5405C4C635696D76A55FAAF7260693A3655B96C03D0BA1EF297A1E0FD32DEBB67ECB1FEFFD7D667F667981697772756E708C898D11858092828688768A83871A059C9D051403A1A203A0A3A1A5A6A8A3AAA2ACA70FA6AF0EB1A4B0B1AEB5B3B19E9DB8BEB6A9C0ABC2ADC4B200B4BFBAC1CBC3CDA2BC9CCAC8B7C6B9D4CCD8CEDAC5CFC7C9D6D3B4D19FE1E6DED7E0E8E2D5EBE7DCDFBBD1ECD9EAF0E9EDF7F4DBF6FDF2BCFBBAE97BE7AF5EBE82FC0EDE028821DB330F0EB941DCF6B021458916055664052001010021F904090A0000002C0000000080000F000003FF08B40BFEAC3D276A9DD40A0CF4C61E17829A58929699A257C44CAE948DF359AFF7F5787AFEF913DEAFC30BF2620458CC482336854C9B530ADD15ADCFAB0FA974457153701588A56AC33DF470ACE6429665F1994D9FDBB378B3C7EDE0ABBF697579728381777A1A7E7E8288848D86856B878E168A7064987F71908F9291809E1A05A3A40513A5A41303ABAC03AAADABAFB0B2ADB4ACB6B10FB0B90EBBAEBABBB803A8A3A7C4C2C8C0B3CAB5CCB7CEBC00BEC9BDC1D0C3C70FC4A6D7D4D2D6D5CBE1CDE3CFE5D1D3DDD7DBC6A8DEE9E7BFF1EFE0DFE2F6E4F8E6FAABECDAD9F3D4051CC84F5E417AF7E015F4E780E141810F092A9C588F62C260EE3064B4C5E10F5EB98EF93E62F0A80FE43E911C13000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C97422E70BF4BE9EC085A3576AE73791A05949D43BBDD613AADDBDEA368FF939D64F1834F542B4990CB21C1A9DA8E3B31885E26E2269957ABD2599156558DB25627766E0999CB5B6B9826F6C3C8FA0A76BF77D9B87EFCB785E4D0A83727E6C7F6F7D8B6A8D6948859174877A88969598949A58869D838C8F81A17C8EA2A61A05A9AA0513ABAAADAEAC0F03B4B50313B6B5B8B9B7B3BCBBB9C0B6C2BABEC1C6B6B1B20ECAB0AEC4B4D0BD0EBCD300D5D2D9C8C5D4BFDBB4CD0FE1CCB1DADDC7E7C3DFD6D8EBE6D7DEE9B5E300F4F4EDF2D1EEFBF9ECF1F0E800AAEB67AF9C3883FDDEE113C88DA1BE84FC1CFACB55F0D9418B10334A54F86F1AA1C78EBF305E4CC541A43C0E014F5E48C910E5C06D2E1B9E4C000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F102C1B9EEDE050A1F587667388D2959495835BD16F4AE23F9E4BAC3E3AC5D0E6812067D39DAEC66933533C622F2B8194651575595FACB0A944FC6D219834EA55B74F78C656BD7E9769C032E8BC33005D3DD9BF7E180567C44723C757A6488668A77835E846F827E907F92867B8C798787815C969F9EA16A49989BA5989DA3A285A0AAAE1D05B1B20513B3B2B5B6B40FB9BA0E03BFC00313C1C0C3C4C20FC7C8BEC7C6C4CEC1D0C0BCB8B6D5B3D7B7C9CDDBCFDDD1DFC5E1BFD2E4E3CB00CAD4BBB9D9B1EEBDE9DCCCDEF4E0F6E2F8E6FAE8CAE503EB1C04043070A0BF73FF12225CC8EF5FC176ECAC45C4C6505E3D8BF730E6D3B88F2B63BF791E1F4A140891E4488F0A1B563CA8B225CA9326DF5D804990A2340D17F1E1CCA8F3424E8D3B8B25000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7C85F7DA07766258929F99A2602561D5E45A902BDB8FB83AFAC8F7939E2008CC157FBAD92D5663C2384F0651373D21AD006175973D7693B8E86BE32443CD5223558DD5B2B9EE2BBCA76C9EEB625A7EEBFBB6BD717E736B721E786863878A61827D818F8091848D028B6596778C90939B7F9C922298697B76A3887A947C436F8EA0839E2205B2B30513B4B3B6B7B50FBABB0EBD1303C2C303C1C4C2C6C7C9C4CBC3CDC80FC7C2C0BCBAB9B7D7B4D9B8D1D2CFC5DDCAE1CCE3CEE5D00ED203D4BFD6D5D8EFDAF1DCE9DEE7E0F5E2F9E4FBE6FDE800D4B10330B0A0BB76F0FEE10B684FE1B787F7BE194C48F060458A03D5417418B12D23478513E52114799164C6860CF5A5E4B7D25F4B801A23521CE96B9E8699256BF6D3A072E7859E2D79B2DC99000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CAB1620F885C2189AE245962AB9795065C53056BF9C9D036BEAF4AC5F6F02240E1F40D94CC798289D32E8ED893C0A57466C557B756D4954A644BCC43569BB30CFBAE6B6BDDDD3571E07A9EF51F4992CDD15E73E6F7482817F75027853797C7A63668E8684419259709480888B8F6589699A6A91A16CA26E499FA78AA99E37A496AD83AF2005B3B40513B5B4B7B8B60FBBBC0EBEBAB81303C5C603C4C7C5C9CACCC7CEC6D0C5C1BDBBC2B5D7B9D5C3DBD80FCACBDFE0D2C8E2CDE6CFE8C6D4C0D6DDDAEDDCF1DEF3F000E0E50EF8E4FCEAE1FAE0D8011048D05DBD59D910FACB776FDCC27E00CF453C5650DE4083172D56A4D7503362C77413A33D1C19721AC68DF6502A3CF8EBA3C8920CF79174F98F26328BF534E0CCB8F29D4E8E2135780C7A61A84BA1CF12000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF697208ADA48866699A2E30662AFCBC1B3CC4C9544DF8FD9F63EC1242804FA86C19C0592C3359931A533FA74109147E3CA1AC49AA4D01A78A7B395C7E62537BBDE02AEDA5F7B84AE57D353F11D0D9F9FFC45805E747B8554877A883C82717F6F5D8D818F3E768A678689998B936E7D9C729F8E44959A97966A78619B9EAC908C8005B1B20513B3B2B5B6B40FB9BA0EBCB8B6C0B31303C5C603C4C7C5C9CACCC7CEC6BFBBB9C2B7D3C1D7C3D9D6BED40FCACBDFE0D0E10EE0C8E2CAD2DDD8ECDAEEDC00EBF2DEF0B1E4E8E6E3E9CFFCC6F8F302D6A3D78EE03B83F1E69DC3C7D05F3900E7041694789062C2810B1DE683B84F2E5F338D16EF6D1369AF174292274D2AECC8F1A3C77E2FFF6944A8A120BC9A076F5EB049F3824B7F1A7EC60CFA2C010021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D370924A995E6850A27BA8118FC8A333355524CE316848F2BD623287410812BDEEDE793299B3BA6CE06A51A8348D710BB4D4A6B39706F1A7E92C7E2A5ECD8D55E57D992395D2D7FE7F8FB97FD7603F87F41794E7A848651875681706D2571297D728588948A8395766B5C91908B7E44979693A28999986880A99B9E2505AEAF0513B0AFB2B3B10FB6B70EB9B5B3BDB0BFB40F03C4C50313C6C5C8C9C7C3CCBCB8B6C1AED3BA00D0BBD2D1BEDBC0CEC9CBE0DFC6E1C6D8D7DAD9DCEADEECC2EED4DDEFE8EB00CCCD0EF7E5CAE3C5E7FFE9E8B513380F60BD73FAFA11DBB750E100830321160C28311E3C6B09F3316388CF27DE338A200F868C387262BD8C1EC5695499925C3D771A5E128C3910E605993259AE6CB84F03B8040021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D378193609ADA895EAAB091AF1833636541760DDB37B6E78FD6CA217405853C9D2C89FB3997401F14562C09AD2DA694D69C7AB95B49B8371397C9D5630BABD29E95E07737EEAE47E5C4AB5AC53ED99F74777F5F66837169796B7B7E828D80858E8464866688009645949391818F9B9E70957A897C8B2605A8A90513AAA9ACADAB0FB0B10EB3AFADB7AAB9AEB2B01303C0C103BFC2C0C4C5B6BDB8CABACCBCB5BECEA8BBD3D2B400C90EC5C60FDBC3DDDBD9D8D1D0CBE5CDE7CFE3E6EBE8EDEAE2DEC7C2F3C1E2F7E4EFD5E9FBFAD7F8ECE26DABC74D5BB87C00DD258487B061C07CF2C015233860613F8BFF1C2AD4C8901B5D44831325D263974E03C97726DD95BC70B2A54A0021EB699898000021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D3781A3F80828AAA56A2561E416BB16E496F36DE7BCC9A6931F8A86331177461D2CD963149D48A84328080A8F4BA98CC9D562B75E25F835AE4D85D6DF772D6637C9EE2E5C4C4DB3E2E1B7B9FC9CEBFB7B5F7527576D867F517E7281878B7640846A8D798E898C88598A945A83673F05A0A10513A2A1A4A5A30FA8A90EABA7A5AFA2B1A6AAA8B3A01303BABB03B9BCBAAEB5B0C2B2C4B4ADB6C6B8CAAC00C1C8C3D0C50EBFBABEBFCFCEC9D2C7DAD1DED3E0DDD9E4DBE2CBD4D5D7BCE5DFEDE1EFE3E6F1E8E7CDD5BD0FF8F4CDFCB7FDF302BA13180EDFBA5DFE98FD5BA8B021B77A09D3FD3A68ED1B370D16C5610C77F10C42C68F1C355E9838921780040021F904090A0000002C0000000080000F000003FF08B40BFEAC3D17C9A4F1AA7CABF61D3781A308998EA0AA1BD99A9584B9B175D27189EF70FEACC09AAEC7630C8D37A212395BCA5E4C0070254C46ABCDAB2FFBC442BBDBAF8D3B964E05DE74585D04B7CB6C67F98C5EDBDF47B73C0FBFEF7F67715A78567A837F647C8A805382868F7D8489859188621374059A9B05139C9B9E9F9D0FA2A30EA5A19FA99CABA0A4A2AD9AB1A60003B6B703A8AFAABBACBDAEA7B0BFB2C3B4BAC1BCC8BECAC0B5B8B6C700D1D3C2CCC4D6C6D5D2DAD4C9DBDECFD0DCE3DEDDCBDFE7E6CDEAD7E8CDE1B9E4E9F2EBF4EDECD9E5F6B4F0F8B3FFC5006213E8EEDEBE09F0DC69F0C66CE1B98617182A8CF870622B87CD1C3C0390000021F904090A0000002C0000000080000F000003E708B40BFEAC3D17C9A4F1AA7CABF61D3781A3089918B391AB5949A9FB96EC6B9DF58CCBB9DDF340D54E1823B68C365A107664FA744527B4798B56A94AE4343994FE9E57AE35EB5D86B7E86F590B5EBBCF6AB8992C67CFBB3EBA1EBF1FF3FF7E81587862838285886977878A760C059091051392919495930F98990E9B97959F92A1969A98A390A79C009B9EA5A0AEA2B0A49DA6B2A8B6AAADB4AFBBB1BDB3ABACBCC1C3BAC4BEC7C0C6CBB5BFB7CEB9CDC9C2A9D5B8D6D0D8D3D1C5D2CCC2CADEE2DDE4C8DFE6E3E8E5E0DAE7E1EBCFDBEDE9EFEAA2C3BF1AF8C9FAC8F917FB02FAE3077020A804003B000000000000000000