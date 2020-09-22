Attribute VB_Name = "modDeclarations"
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

Public DX As DirectX8
Public D3D As Direct3D8
Public D3DX As D3DX8
Public D3DDevice As Direct3DDevice8

Public TexturePath As String, MusicPath As String
Public bRunning As Boolean

Public Const FVF_TLVERTEX = (D3DFVF_XYZRHW Or D3DFVF_TEX1 Or D3DFVF_DIFFUSE Or D3DFVF_SPECULAR)

Public Const TileSize = 100
Public Const WorldSize = 160
Public Const ScreenWidth = 800
Public Const ScreenHeight = 600
Public Const NoTilesX = ScreenWidth / TileSize + 1
Public Const NoTilesY = ScreenHeight / TileSize + 1

Public Type TLVERTEX
    X As Single
    Y As Single
    z As Single
    rhw As Single
    Color As Long
    Specular As Long
    tu As Single
    tv As Single
End Type
Public CarVert(3) As TLVERTEX
Public PlrVert(3) As TLVERTEX

Public Type Square
    Vert(3) As TLVERTEX
End Type
Public Tiles(NoTilesX, NoTilesY) As Square

Public Type Tile_Data
    Type As Integer
    Movable As Integer
End Type
Public TileData(WorldSize, WorldSize) As Tile_Data

Private Type CarType
    X1 As Single
    Y1 As Single
    X2 As Single
    Y2 As Single
    Dir As Single
    Facing As Single
    TurnAng As Single
    Speed As Single
    Acc As Single
    Brake As Single
    HBrake As Single
End Type
Public Car As CarType

Public Friction As Single
Public Const PI As Double = 3.14159265358979
Public Const RAD As Double = PI / 180

Public MainFont As D3DXFont
Public MainFontDesc As IFont
Public fnt As New StdFont

Public RightKey As Integer, LeftKey As Integer
Public UpKey As Integer, DownKey As Integer

Public SongList() As String, CurSong As Integer
Public NoMp3 As Boolean
Public PlrTex As Direct3DTexture8
Public Center As D3DVECTOR
Public stX As Integer, stY As Integer
Public CurX As Integer, CurY As Integer
Public BoxX As Single, BoxY As Single
Public TexNo As Integer
Public CarTex As Direct3DTexture8
Public BoxTex As Direct3DTexture8
Public Texture(34) As Direct3DTexture8

Public Declare Function ShowCursor Lib "user32" (ByVal bShow As Long) As Long
Public Declare Function GetTickCount Lib "kernel32" () As Long

Public Function CreateTLVertex(X As Single, Y As Single, z As Single, rhw As Single, _
                                                Color As Long, Specular As Long, tu As Single, _
                                                tv As Single) As TLVERTEX
    CreateTLVertex.X = X
    CreateTLVertex.Y = Y
    CreateTLVertex.z = z
    CreateTLVertex.rhw = rhw
    CreateTLVertex.Color = Color
    CreateTLVertex.Specular = Specular
    CreateTLVertex.tu = tu
    CreateTLVertex.tv = tv
End Function

Public Function MakeVector(X As Single, Y As Single, z As Single) As D3DVECTOR
    MakeVector.X = X: MakeVector.Y = Y: MakeVector.z = z
End Function

Public Function MakeRect(Left As Single, Right As Single, Top As Single, Bottom As Single) As RECT
    MakeRect.Left = Left
    MakeRect.Right = Right
    MakeRect.Top = Top
    MakeRect.Bottom = Bottom
End Function

