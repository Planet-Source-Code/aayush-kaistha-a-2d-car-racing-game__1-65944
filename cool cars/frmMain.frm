VERSION 5.00
Begin VB.Form frmMain 
   BackColor       =   &H00000000&
   BorderStyle     =   0  'None
   Caption         =   "Form1"
   ClientHeight    =   9000
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   12000
   LinkTopic       =   "Form1"
   ScaleHeight     =   9000
   ScaleWidth      =   12000
   ShowInTaskbar   =   0   'False
   StartUpPosition =   3  'Windows Default
End
Attribute VB_Name = "frmMain"
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

Private Sub Form_KeyDown(KeyCode As Integer, Shift As Integer)

If KeyCode = vbKeyEscape Then bRunning = False

If KeyCode = vbKeyRight Then RightKey = 1
If KeyCode = vbKeyLeft Then LeftKey = 1
If KeyCode = vbKeyUp Then UpKey = 1
If KeyCode = vbKeyDown Then DownKey = 1

If KeyCode = vbKeyP Then PlayNextSong

End Sub

Private Sub Form_KeyUp(KeyCode As Integer, Shift As Integer)

If KeyCode = vbKeyRight Then RightKey = 0
If KeyCode = vbKeyLeft Then LeftKey = 0
If KeyCode = vbKeyUp Then UpKey = 0
If KeyCode = vbKeyDown Then DownKey = 0

End Sub

Private Sub Form_Load()

Me.Show
DoEvents
Main

End Sub
