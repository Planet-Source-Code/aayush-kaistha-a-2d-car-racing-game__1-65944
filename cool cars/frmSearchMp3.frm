VERSION 5.00
Begin VB.Form frmSearchMp3 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   9000
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   11985
   LinkTopic       =   "Form1"
   ScaleHeight     =   9000
   ScaleWidth      =   11985
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
   Begin VB.FileListBox FileList 
      Height          =   1845
      Left            =   1200
      TabIndex        =   0
      Top             =   840
      Visible         =   0   'False
      Width           =   2055
   End
End
Attribute VB_Name = "frmSearchMp3"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
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

Private Sub Form_Load()

Me.Show
SearchMp3
frmMain.Show
Unload Me

End Sub

Private Sub SearchMp3()
Dim i As Integer, msg As String
Dim c As Integer

MusicPath = App.Path + "\mp3\"

FileList.Path = MusicPath
NoMp3 = True

Open MusicPath + "mp3_report.txt" For Output As #1
Close #1

Open MusicPath + "mp3_report.txt" For Binary As #1

For i = 0 To FileList.ListCount - 1
    If (LoadMP3(FileList.Path + "\" + FileList.List(i))) Then
        ReDim Preserve SongList(c) As String
        SongList(c) = FileList.List(i)
        c = c + 1
        msg = FileList.List(i) + " is a valid mp3." + vbCrLf
    Else
        msg = FileList.List(i) + " is NOT a valid mp3." + vbCrLf
    End If
    Put #1, , msg
Next

Close #1

If c > 0 Then NoMp3 = False

End Sub
