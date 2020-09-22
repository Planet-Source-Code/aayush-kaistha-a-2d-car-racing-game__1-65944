Attribute VB_Name = "modMain"
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

Public Sub Main()

OpenLevel App.Path + "\2.txt"
Initialize
MainLoop

End Sub

Public Sub OpenLevel(Fname As String)
Dim txt As String, buf As String
Dim i As Integer, j As Integer
Dim tx As Integer, ty As Integer
Dim inl As Boolean

For i = 0 To WorldSize
    For j = 0 To WorldSize
        TileData(i, j).Type = 0
        TileData(i, j).Movable = 0
    Next
Next

If Fname <> "" Then
    Open Fname For Input As #1

    While Not EOF(1)
        Line Input #1, txt
        j = 1: i = 1
        inl = True
        While inl
            buf = ""
            Do While Mid(txt, i, 1) <> "-"
                If Mid(txt, i, 1) = "#" Then
                    inl = False
                    Exit Do
                Else
                    buf = buf + Mid(txt, i, 1)
                End If
                i = i + 1
                DoEvents
            Loop
            Select Case j
                Case 1:
                    TileData(tx, ty).Type = buf
                Case 2:
                    TileData(tx, ty).Movable = buf
            End Select
            i = i + 1
            j = j + 1
            DoEvents
        Wend
        ty = ty + 1
        If ty > WorldSize Then
            ty = 0
            tx = tx + 1
        End If
    Wend
End If

Close #1

End Sub

Private Sub MainLoop()

Do While bRunning
    CheckKeys
    Turn
    Render
    If Not GetMp3Status Then PlayNextSong
    DoEvents
Loop

DestroyApp

End Sub

Private Sub Render()

D3DDevice.Clear 0, ByVal 0, D3DCLEAR_TARGET, &H112233, 1#, 0

D3DDevice.BeginScene

    UpdateTiles
    DrawCar
    DrawMp3Plr
    
    D3DX.DrawText MainFont, &HFF00FF00, Friction, MakeRect(10, 300, 40, 60), DT_TOP Or DT_LEFT
    D3DX.DrawText MainFont, &HFF00FF00, Center.Y, MakeRect(10, 300, 70, 90), DT_TOP Or DT_LEFT
    
D3DDevice.EndScene

D3DDevice.Present ByVal 0, ByVal 0, 0, ByVal 0

End Sub

Private Sub DrawCar()

D3DDevice.SetRenderState D3DRS_ALPHABLENDENABLE, True

D3DDevice.SetTexture 0, CarTex
D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, CarVert(0), Len(CarVert(0))

D3DDevice.SetRenderState D3DRS_ALPHABLENDENABLE, False

End Sub

Private Sub DrawMp3Plr()
Dim msg As String

D3DDevice.SetTexture 0, PlrTex
D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, PlrVert(0), Len(CarVert(0))

If NoMp3 Then
    msg = "No Mp3 files found"
Else
    msg = SongList(CurSong)
End If

SetFont "bankgothic md bt", 12, False
D3DX.DrawText MainFont, &HFFAAAAFF, msg, MakeRect(260, 540, 20, 40), DT_CENTER

End Sub

Private Sub UpdateTiles()

Dim i As Integer, j As Integer
Dim tmpX As Single, tmpY As Single

stX = (Center.X - (ScreenWidth / 2)) \ TileSize
stY = (Center.Y - (ScreenHeight / 2)) \ TileSize

tmpX = (Center.X - (ScreenWidth / 2)) Mod TileSize
tmpY = (Center.Y - (ScreenHeight / 2)) Mod TileSize
CreateTiles -tmpX, -tmpY

If stX < 0 Then stX = 0
If stY < 0 Then stY = 0
If stX > (WorldSize - NoTilesX) Then stX = (WorldSize - NoTilesX)
If stY > (WorldSize - NoTilesY) Then stY = (WorldSize - NoTilesY)

For i = 0 To NoTilesX
    For j = 0 To NoTilesY
        D3DDevice.SetTexture 0, Texture(TileData(stX + i, stY + j).Type)
        D3DDevice.DrawPrimitiveUP D3DPT_TRIANGLESTRIP, 2, Tiles(i, j).Vert(0), Len(Tiles(0, 0).Vert(0))
    Next
Next

End Sub

Private Sub Turn()
If Car.Speed = 0 Then Exit Sub

Dim tmp As D3DVECTOR, RadX As Single, RadY As Single
Dim pos As D3DVECTOR

RadX = (Car.X2 - Car.X1) / 2
RadY = (Car.Y2 - Car.Y1) / 2

pos.X = (ScreenWidth / 2): pos.Y = (ScreenHeight / 2)
With Car
    tmp = Rotate(pos.X - RadX, pos.Y - RadY, Car.Facing, pos)
    CarVert(0) = CreateTLVertex(tmp.X, tmp.Y, 0, 1, &HFFFFFF, &HFFFFFF, 0, 0)
    
    tmp = Rotate(pos.X + RadX, pos.Y - RadY, Car.Facing, pos)
    CarVert(1) = CreateTLVertex(tmp.X, tmp.Y, 0, 1, &HFFFFFF, &HFFFFFF, 1, 0)
    
    tmp = Rotate(pos.X - RadX, pos.Y + RadY, Car.Facing, pos)
    CarVert(2) = CreateTLVertex(tmp.X, tmp.Y, 0, 1, &HFFFFFF, &HFFFFFF, 0, 1)
    
    tmp = Rotate(pos.X + RadX, pos.Y + RadY, Car.Facing, pos)
    CarVert(3) = CreateTLVertex(tmp.X, tmp.Y, 0, 1, &HFFFFFF, &HFFFFFF, 1, 1)
End With

End Sub

Private Function Rotate(X As Single, Y As Single, Q As Single, c As D3DVECTOR) As D3DVECTOR

Rotate.X = X * Cos(Q) - Y * Sin(Q) + c.X * (1 - Cos(Q)) + c.Y * Sin(Q)
Rotate.Y = X * Sin(Q) + Y * Cos(Q) + c.Y * (1 - Cos(Q)) - c.X * Sin(Q)

End Function

Private Sub CheckKeys()

Car.Acc = 0.1 * UpKey
Car.Brake = 0.2 * DownKey

Car.Speed = Car.Speed + Car.Acc - Car.Brake - Friction
If Car.Speed > 12 Then Car.Speed = 12
If Car.Speed < -5 Then Car.Speed = -5

If Car.Speed = 0 Then
    Car.Dir = Car.Facing
    Friction = 0
Else
    If Car.Speed > 0 Then
        Friction = 0.05
        If RightKey Then Car.Facing = Car.Facing + Car.TurnAng
        If LeftKey Then Car.Facing = Car.Facing - Car.TurnAng
        AddVectors (Car.Speed * 0.95) + Car.Acc, Car.Dir, Car.Speed * 0.05, Car.Facing, Car.Speed, Car.Dir
    Else
        Friction = 0.01 * Car.Speed
        If Car.Speed <= -1 Then
            If RightKey Then Car.Facing = Car.Facing - Car.TurnAng
            If LeftKey Then Car.Facing = Car.Facing + Car.TurnAng
        End If
        Car.Dir = Car.Facing
    End If
End If

Center.X = Center.X + Car.Speed * Cos(Car.Dir)
Center.Y = Center.Y + Car.Speed * Sin(Car.Dir)

If CInt(Car.Speed) <> 0 Then
    If CheckRoadColl Then Friction = 0.1 * Sgn(Car.Speed)
End If

If Center.X < (ScreenWidth / 2) Then Center.X = (ScreenWidth / 2)
If Center.Y < (ScreenHeight / 2) Then Center.Y = (ScreenHeight / 2)

End Sub

Private Function CheckRoadColl() As Boolean

Dim i As Integer, edge(3) As D3DVECTOR
Dim tmp As Integer, Result As Boolean

For i = 0 To 3
    edge(i).X = CarVert(i).X + Center.X - 400
    edge(i).Y = CarVert(i).Y + Center.Y - 300
Next

Result = False

tmp = Center.X \ TileSize
tmp = tmp + 1
If TileData(tmp, Center.Y \ TileSize).Movable = 0 Then
    tmp = tmp * TileSize
    tmp = tmp - 10
    For i = 0 To 3
        If tmp < edge(i).X Then
            Center.X = Center.X - edge(i).X + tmp
            Result = True
        End If
    Next
End If

tmp = Center.X \ TileSize
tmp = tmp - 1
If TileData(tmp, Center.Y \ TileSize).Movable = 0 Then
    tmp = (tmp + 1) * TileSize
    tmp = tmp + 10
    For i = 0 To 3
        If tmp > edge(i).X Then
            Center.X = Center.X - edge(i).X + tmp
            Result = True
        End If
    Next
End If

tmp = Center.Y \ TileSize
tmp = tmp + 1
If TileData(Center.X \ TileSize, tmp).Movable = 0 Then
    tmp = tmp * TileSize
    tmp = tmp - 10
    For i = 0 To 3
        If tmp < edge(i).Y Then
            Center.Y = Center.Y - edge(i).Y + tmp
            Result = True
        End If
    Next
End If

tmp = Center.Y \ TileSize
tmp = tmp - 1
If TileData(Center.X \ TileSize, tmp).Movable = 0 Then
    tmp = (tmp + 1) * TileSize
    tmp = tmp + 10
    For i = 0 To 3
        If tmp > edge(i).Y Then
            Center.Y = Center.Y - edge(i).Y + tmp
            Result = True
        End If
    Next
End If

CheckRoadColl = Result

End Function

Private Sub AddVectors(ByVal Mag1 As Single, ByVal Dir1 As Single, ByVal Mag2 As Single, ByVal Dir2 As Single, Optional ByRef MagResult As Single, Optional ByRef DirResult As Single)

Dim XComp As Single
Dim YComp As Single
     
    'Determine the components of the resultant vector
    XComp = Mag1 * Sin(Dir1) + Mag2 * Sin(Dir2)
    YComp = Mag1 * Cos(Dir1) + Mag2 * Cos(Dir2)
    'Determine the resultant magnitude
    MagResult = Sqr(XComp ^ 2 + YComp ^ 2)
    'Calculate the resultant direction, and adjust for arctangent by adding Pi if necessary
    If YComp > 0 Then DirResult = Atn(XComp / YComp)
    If YComp < 0 Then DirResult = Atn(XComp / YComp) + PI

End Sub

Private Sub DestroyApp()
On Error Resume Next

TerminateEngine
Set D3DX = Nothing
Set D3DDevice = Nothing
Set D3D = Nothing
Set DX = Nothing

ShowCursor 1

End

End Sub

