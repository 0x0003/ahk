;You can bind your own hotkeys to certain positions using
; MoveWindowToTile(window-title, x0-index, x1-index, y0-index, y1-index)
;For example:
; NumpadIns:: MoveWindowToTile("A", 1, 3, 1, 2)

; current grid
; +----+----+
; |    |    |
; +----+----+
; |    |    |
; +----+----+

; V[n]:= [ x-coord, y0-index, y1-index, corner?, resize-only?]
V := []
V[1] := [ ScreenX,                  1,  3,  1, 0 ]
V[2] := [ ScreenX+ScreenW/2,        1,  3,  0, 0 ]
V[3] := [ ScreenX+ScreenW,          1,  3,  1, 0 ]

; H[n]:= [ y-coord, x0-index, x1-index, corner?, resize-only?]
H := []
H[1] := [ ScreenY,               1,  3,  1, 0 ]
H[2] := [ ScreenY+(ScreenH)/2,   1,  3,  0, 0 ]
H[3] := [ ScreenY+ScreenH,       1,  3,  1, 0 ]



; Hide Tray Icon
NoTrayIcon := True

; Gaps (px)
MarginWidth := 15

; Margin between windows at edges (px)
MarginWidthHalf := MarginWidth//2

; Minimum distance from lines/windows before snapping (px)
SnapDistance := 10

; Minimum distance before starting to move/resize window (px)
MinimumMovement := 1



; Enable snapping to grid?
SnapToGrid := True

; Enable snapping to surrounding windows?
SnapToWindows := True

; Enable maximizing window if moved to top of screen?
MoveToTopToMaximize := False

; Minimize the window if it is moved to the bottom of the screen?
MoveToBottomToClose := False



; Enable display of grid? (useful for debugging)
VisibleGrid := False

; Colour of grid
ColorGrid := 0xA2B2A1

; Transparency of grid
TransparencyGrid := 128

; Colour of window preview
ColorPreview := 0xD0D0D0

; Transparency of window preview
TransparencyPreview := 128

; Preview animation duration (ms)
AnimationDuration := 0



; HotkeyModifier is prefixed to each hotkey, but can be released once the hotkey has activated.
HotkeyModifier := "#"

; Move window hotkey (leave blank to disable)
HotkeyMove := "MButton"

; Resize window hotkey (leave blank to disable)
HotkeyResize := "RButton"

; Move Resize window hotkey (leave blank to disable)
; When moving window, press this to switch to grid resize mode (different from normal resize)
HotkeyMoveResize := ""


; tiling/moving/resizing variables
MovePix := 50
SlowMovePix := 10
LowerOffset := A_ScreenHeight/2+MarginWidth/2
WindowFullHeight := A_ScreenHeight-MarginWidth*2
if mod (MarginWidth,2) = 0 {
  WindowHalfHeight := WindowFullHeight/2-MarginWidth/2
} else {
  WindowHalfHeight := WindowFullHeight/2-MarginWidth/2+1
}

WindowNormalWidth := A_ScreenWidth/2-(MarginWidth+MarginWidth/2)+1
NormalFarLeftOffset := A_ScreenWidth/2+MarginWidth/2

WindowSmallWidth := WindowNormalWidth-MarginWidth*7
SmallFarLeftOffset := NormalFarLeftOffset+MarginWidth*7

WindowLargeWidth := A_ScreenWidth-WindowSmallWidth-(MarginWidth*3)
LargeFarLeftOffset := A_ScreenWidth-SmallFarLeftOffset+MarginWidth

