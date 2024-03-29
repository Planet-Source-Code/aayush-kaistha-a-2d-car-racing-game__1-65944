Attribute VB_Name = "modDirectMusic"
'#########################################################
'#                                                       #
'#      A 2d Car Racing Game (incomplete)                #
'#                                                       #
'#      By: Aayush Kaistha                               #
'#      Place: UIET, Panjab University Chandigarh, India #
'#      Contact: aayushkaistha@gmail.com                 #
'#                                                       #
'#      Remark: i've made a level and car driving        #
'#              physics. now i dont know what to add     #
'#              next. tell me ur suggestions through     #
'#              comments on pscode.com n i'll try to     #
'#              implement them. infact, just post any    #
'#              comment that u wanna make. all comments  #
'#              r welcome.                               #
'#                                                       #
'#########################################################

Option Explicit

Private DSAudio  As IBasicAudio         'Basic Audio Objectt
Private DSEvent As IMediaEvent        'MediaEvent Object
Private DSControl As IMediaControl    'MediaControl Object
Private DSPosition As IMediaPosition 'MediaPosition Object

Public Function TerminateEngine() As Boolean
On Error GoTo BailOut:

    If ObjPtr(DSControl) > 0 Then
        DSControl.Stop
    End If
                
    If ObjPtr(DSAudio) Then Set DSAudio = Nothing
    If ObjPtr(DSEvent) Then Set DSEvent = Nothing
    If ObjPtr(DSControl) Then Set DSControl = Nothing
    If ObjPtr(DSPosition) Then Set DSPosition = Nothing
                
    TerminateEngine = True
    Exit Function
BailOut:
    TerminateEngine = False
    Debug.Print "ERROR: modDirectShow.TerminateEngine()"
    Debug.Print "     ", Err.Number, Err.Description
End Function


Public Function LoadMP3(FileName As String) As Boolean
On Error GoTo BailOut:

    '//0. Any variables
    
    '//1. Destroy existing instances
        If Not (TerminateEngine() = True) Then GoTo BailOut:
        
    '//2. Setup a filter graph for the file
        Set DSControl = New FilgraphManager
        Call DSControl.RenderFile(FileName)
    
    '//3. Setup the basic audio object
        Set DSAudio = DSControl
        DSAudio.Volume = 0
        DSAudio.Balance = 0
    
    '//4. Setup the media event and position objects
        Set DSEvent = DSControl
        Set DSPosition = DSControl
        If ObjPtr(DSPosition) Then DSPosition.Rate = 1#
        DSPosition.CurrentPosition = 0
        
    
    '//5. Done!

    LoadMP3 = True
    Exit Function
BailOut:
    LoadMP3 = False
    Debug.Print "ERROR: modDirectShow.LoadMP3()"
    Debug.Print "     ", Err.Number, Err.Description
End Function


Public Function SetPlayBackSpeed(Speed As Single) As Boolean
On Error GoTo BailOut:

    If ObjPtr(DSPosition) > 0 Then
        DSPosition.Rate = Speed
    End If

    SetPlayBackSpeed = True
    Exit Function
BailOut:
    SetPlayBackSpeed = False
    Debug.Print "ERROR: modDirectShow.SetPlayBackSpeed()"
    Debug.Print "     ", Err.Number, Err.Description
End Function


Public Function SetPlayBackVolume(Volume As Long) As Boolean
On Error GoTo BailOut:
    
    '//Set the new volume
    If ObjPtr(DSControl) > 0 Then
        DSAudio.Volume = Volume * 40 ' makes it in the 0 to -4000 range (-4000 is almost silent)
    End If

    SetPlayBackVolume = True
    Exit Function
BailOut:
    SetPlayBackVolume = False
    Debug.Print "ERROR: modDirectShow.SetPlayBackVolume()"
    Debug.Print "     ", Err.Number, Err.Description
End Function

Public Function SetPlayBackBalance(Balance As Long) As Boolean
On Error GoTo BailOut:

    If ObjPtr(DSControl) > 0 Then
        DSAudio.Balance = Balance
    End If

    SetPlayBackBalance = True
    Exit Function
BailOut:
    SetPlayBackBalance = False
    Debug.Print "ERROR: modDirectShow.SetPlayBackBalance()"
    Debug.Print "     ", Err.Number, Err.Description
End Function


Public Function PlayMP3() As Boolean
On Error GoTo BailOut:

    DSControl.Run

    PlayMP3 = True
    Exit Function
BailOut:
    PlayMP3 = False
    Debug.Print "ERROR: modDirectShow.PlayMP3()"
    Debug.Print "     ", Err.Number, Err.Description
End Function

Public Function StopMP3() As Boolean
On Error GoTo BailOut:
    
    DSControl.Stop
    DSPosition.CurrentPosition = 0 'set it back to the beginning

    StopMP3 = True
    Exit Function
BailOut:
    StopMP3 = False
    Debug.Print "ERROR: modDirectShow.StopMP3()"
    Debug.Print "     ", Err.Number, Err.Description
End Function

Public Function PauseMP3() As Boolean
On Error GoTo BailOut:
    
    DSControl.Stop

    PauseMP3 = True
    Exit Function
BailOut:
    PauseMP3 = False
    Debug.Print "ERROR: modDirectShow.PauseMP3()"
    Debug.Print "     ", Err.Number, Err.Description
End Function

Public Sub PlayNextSong()

If NoMp3 Then Exit Sub

CurSong = CurSong + 1
If CurSong > UBound(SongList) Then CurSong = 0
StopMP3
LoadMP3 MusicPath + SongList(CurSong)
PlayMP3

End Sub

Public Function GetMp3Status() As Boolean

If NoMp3 Then
    GetMp3Status = False
    Exit Function
End If

If DSPosition.CurrentPosition - DSPosition.Duration Then
    GetMp3Status = True
Else
    GetMp3Status = False
End If

End Function
