Attribute VB_Name = "modInitialize"
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

Public Function InitD3D() As Boolean

On Error GoTo Hell:

Dim D3DWindow As D3DPRESENT_PARAMETERS
Dim DispMode As D3DDISPLAYMODE

'initialize and allocate memory 4 directX objects
Set DX = New DirectX8
Set D3D = DX.Direct3DCreate
Set D3DX = New D3DX8

DispMode.Format = CheckDisplayMode(ScreenWidth, ScreenHeight, 32)
If DispMode.Format > D3DFMT_UNKNOWN Then
    Debug.Print "Using 32-Bit format"
Else
    DispMode.Format = CheckDisplayMode(ScreenWidth, ScreenHeight, 16)
    If DispMode.Format > D3DFMT_UNKNOWN Then
        Debug.Print "32-Bit format not supported. Using 16-Bit format"
    Else
        MsgBox "Neither 16-Bit nor 32-Bit Display Mode Supported", vbInformation, "ERROR"
        Unload frmMain
        End
    End If
End If

With D3DWindow
    .BackBufferCount = 1
    .BackBufferFormat = DispMode.Format
    .BackBufferWidth = ScreenWidth
    .BackBufferHeight = ScreenHeight
    .hDeviceWindow = frmMain.hWnd
    .SwapEffect = D3DSWAPEFFECT_COPY_VSYNC
End With

If D3D.CheckDeviceFormat(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, DispMode.Format, D3DUSAGE_DEPTHSTENCIL, D3DRTYPE_SURFACE, D3DFMT_D32) = D3D_OK Then
    D3DWindow.AutoDepthStencilFormat = D3DFMT_D32
    D3DWindow.EnableAutoDepthStencil = 1
Else
    If D3D.CheckDeviceFormat(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, DispMode.Format, D3DUSAGE_DEPTHSTENCIL, D3DRTYPE_SURFACE, D3DFMT_D24X8) = D3D_OK Then
        D3DWindow.AutoDepthStencilFormat = D3DFMT_D24X8
        D3DWindow.EnableAutoDepthStencil = 1
    Else
        If D3D.CheckDeviceFormat(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, DispMode.Format, D3DUSAGE_DEPTHSTENCIL, D3DRTYPE_SURFACE, D3DFMT_D16) = D3D_OK Then
            D3DWindow.AutoDepthStencilFormat = D3DFMT_D16
            D3DWindow.EnableAutoDepthStencil = 1
        Else
            D3DWindow.EnableAutoDepthStencil = 0
            MsgBox "Depth buffer could not be enabled", vbInformation, "Depth buffer not supported"
        End If
    End If
End If

Set D3DDevice = D3D.CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, frmMain.hWnd, D3DCREATE_SOFTWARE_VERTEXPROCESSING, D3DWindow)

With D3DDevice
    .SetVertexShader FVF_TLVERTEX
    .SetRenderState D3DRS_LIGHTING, 1
End With

D3DDevice.SetTextureStageState 0, D3DTSS_COLOROP, D3DTOP_MODULATE
D3DDevice.SetTextureStageState 0, D3DTSS_COLORARG1, D3DTA_TEXTURE
D3DDevice.SetTextureStageState 0, D3DTSS_COLORARG2, D3DTA_DIFFUSE
    
D3DDevice.SetTextureStageState 0, D3DTSS_MINFILTER, D3DTEXF_LINEAR
D3DDevice.SetTextureStageState 0, D3DTSS_MAGFILTER, D3DTEXF_LINEAR
D3DDevice.SetTextureStageState 0, D3DTSS_MIPFILTER, D3DTEXF_LINEAR

D3DDevice.SetRenderState D3DRS_SRCBLEND, D3DBLEND_SRCALPHA
D3DDevice.SetRenderState D3DRS_DESTBLEND, D3DBLEND_INVSRCALPHA

'font settings
SetFont "Verdana", 12, True

InitD3D = True

Exit Function
Hell:
MsgBox "ERROR initializing D3D ", vbCritical, "ERROR"
InitD3D = False

End Function

Public Sub SetFont(Name As String, Size As Integer, Bold As Boolean)

fnt.Name = Name
fnt.Size = Size
fnt.Bold = Bold
Set MainFontDesc = fnt
Set MainFont = D3DX.CreateFont(D3DDevice, MainFontDesc.hFont)

End Sub

Public Function CheckDisplayMode(Width As Long, Height As Long, Depth As Long) As CONST_D3DFORMAT
Dim i As Long
Dim DispMode As D3DDISPLAYMODE
    
For i = 0 To D3D.GetAdapterModeCount(0) - 1
    D3D.EnumAdapterModes 0, i, DispMode
    If DispMode.Width = Width Then
        If DispMode.Height = Height Then
            If (DispMode.Format = D3DFMT_R5G6B5) Or (DispMode.Format = D3DFMT_X1R5G5B5) Or (DispMode.Format = D3DFMT_X4R4G4B4) Then
                '16 bit mode
                If Depth = 16 Then
                    CheckDisplayMode = DispMode.Format
                    Exit Function
                End If
            ElseIf (DispMode.Format = D3DFMT_R8G8B8) Or (DispMode.Format = D3DFMT_X8R8G8B8) Then
                '32bit mode
                If Depth = 32 Then
                    CheckDisplayMode = DispMode.Format
                    Exit Function
                End If
            End If
        End If
    End If
Next i
CheckDisplayMode = D3DFMT_UNKNOWN
End Function

Public Sub CreateRectangle(X1 As Single, Y1 As Single, X2 As Single, Y2 As Single, z As Single, Color As Long, ByRef tmp() As TLVERTEX)

tmp(0) = CreateTLVertex(X1, Y1, z, 1, Color, 0, 0, 0)
tmp(1) = CreateTLVertex(X2, Y1, z, 1, Color, 0, 1, 0)
tmp(2) = CreateTLVertex(X1, Y2, z, 1, Color, 0, 0, 1)
tmp(3) = CreateTLVertex(X2, Y2, z, 1, Color, 0, 1, 1)

End Sub

Public Sub Initialize()

TexturePath = App.Path + "\res\"
bRunning = InitD3D

With Car
    .X1 = 375: .Y1 = 290: .X2 = 425: .Y2 = 315
    .TurnAng = 0.05
    .Acc = 0.02

    CarVert(0) = CreateTLVertex(.X1, .Y1, 0, 1, &HFFFFFF, 0, 0, 0)
    CarVert(1) = CreateTLVertex(.X2, .Y1, 0, 1, &HFFFFFF, 0, 1, 0)
    CarVert(2) = CreateTLVertex(.X1, .Y2, 0, 1, &HFFFFFF, 0, 0, 1)
    CarVert(3) = CreateTLVertex(.X2, .Y2, 0, 1, &HFFFFFF, 0, 1, 1)
End With

CreateRectangle 250, 0, 550, 50, 0, &HFFFFFF, PlrVert

Center.X = 1800
Center.Y = 2200

CreateTiles 0, 0
LoadTextures

TexNo = 0
CurSong = -1
PlayNextSong

ShowCursor 0

End Sub

Public Sub CreateTiles(sx As Single, sy As Single)
Dim i As Single, j As Single
Dim X As Single, Y As Single

X = sx: Y = sy
For i = 0 To NoTilesX
    For j = 0 To NoTilesY
        CreateRectangle X, Y, X + TileSize, Y + TileSize, 0, &HFFFFFF, Tiles(i, j).Vert
        Y = Y + TileSize
    Next
    X = X + TileSize
    Y = sy
Next

End Sub
