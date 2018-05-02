        @echo off
        mode con:cols=90 lines=12
        title -==*==- Batch Telechargeur de fichier -==*==-
        (
        echo Option Explicit
        echo.
        echo Dim Message, result
        echo Dim Title, Text1, Text2
        echo.
        echo Message = "Tapez l'URL du fichier a telecharger http://www.gametop.com/online-free-games/anti-terror-force-online/game.swf"        
        echo Title = "Telecharger un fichier depuis URL"
        echo Text1 = "vous avez annulé"
        echo.
        echo result = InputBox^(Message, Title, "http://www.gametop.com/online-free-games/anti-terror-force-online/game.swf", 900, 900^)
        echo.
        echo.
        echo If result = "" Then
        echo    WScript.Echo Text1
        echo Else
        echo    WScript.Echo result
        echo End If
        )>"%tmp%\inputbox.vbs"
        for /f "tokens=* delims=*" %%a in ('Cscript "%tmp%\inputbox.vbs" //nologo') do (set "a=%%a")
        (
        echo path = "%A%"
        echo pos = InStrRev(path, "/"^) +1
        echo Const DownloadDest = "%A%"
        echo LocalFile = Mid(path, pos^)
        echo Const webUser = "admin"
        echo Const webPass = "admin"
        echo Const DownloadType = "binary"
        echo dim strURL
        echo.
        echo function getit(^)
        echo  dim xmlhttp
        echo.
        echo  set xmlhttp=createobject("MSXML2.XMLHTTP.3.0"^)
        echo  'xmlhttp.SetOption 2, 13056 'If https -^) Ignorer toutes les erreurs SSL
        echo  strURL = DownloadDest
        echo  Wscript.Echo "Download-URL: " ^& strURL
        echo.
        echo  'Pour l'authentification de base, utilisez la liste ci-dessous, ainsi que les variables + d'utilisateurs? laisser passer
        echo  xmlhttp.Open "GET", strURL, false, WebUser, WebPass
        echo  'xmlhttp.Open "GET", strURL, false
        echo.
        echo  xmlhttp.Send
        echo  Wscript.Echo "Download-Status: " ^& xmlhttp.Status ^& " " ^& xmlhttp.statusText
        echo.
        echo  If xmlhttp.Status = 200 Then
        echo    Dim objStream
        echo    set objStream = CreateObject("ADODB.Stream"^)
        echo    objStream.Type = 1 'adTypeBinary
        echo    objStream.Open
        echo    objStream.Write xmlhttp.responseBody
        echo    objStream.SaveToFile LocalFile
        echo    objStream.Close
        echo    set objStream = Nothing
        echo  End If
        echo.
        echo.
        echo  set xmlhttp=Nothing
        echo End function
        echo.
        echo '=======================================================================
        echo ' Fin Defs de fonction, Start Page
        echo '=======================================================================
        echo getit(^)
        echo Wscript.Echo "Telechargement Termine. voir " ^& LocalFile ^& " pour la reussite."
        echo Wscript.Quit(intOK^)
        )>"%tmp%\httpdownload.vbs"
        ::Debut
        echo Veuillez Patienter...  Telechargement du fichier est en cours ...
        for /f "tokens=* delims=*" %%a in ('Cscript "%tmp%\httpdownload.vbs" //nologo') do (echo "%%a")
        Del %tmp%\httpdownload.vbs
        ::fin
        pause>nul