; Center window using its current size
CenterWindow(WinTitle) {
  WinGetPos,,, Width, Height, %WinTitle%
  WinMove, %WinTitle%,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}

; tiling section
; all variables can be found in config
; NOTE: numlock should be off in order for mappings to work

; ------------------- Unique
;5 - fullscreen with gaps
NumpadClear::
  WinMove,A,, %MarginWidth%, %MarginWidth%, A_ScreenWidth-MarginWidth*2, WindowFullHeight
return
;win+shift+x - fullscreen with gaps
#+x::
  WinMove,A,, %MarginWidth%, %MarginWidth%, A_ScreenWidth-MarginWidth*2, WindowFullHeight
return
;shift+5 - center active window
+NumpadClear::
  WinGetPos,,, Width, Height, A
  WinMove, A,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
return
;win+g - center active window
#g::
  WinGetPos,,, Width, Height, A
  WinMove, A,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
return
;win+j - half + center window with bigger gaps
#j::
  WinMove, A,,,, WindowNormalWidth-2*16, (WindowFullHeight-10)-2*16
  sleep 10
  WinGetPos,,, Width, Height, A
  WinMove, A,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
return
;ctrl+shift+5 - center active window on X axis
^+NumpadClear::
  WinGetPos,,, Width, Height, A
  WinMove, A,, (A_ScreenWidth/2)-(Width/2), (Height-%MarginWidth%)
return
;alt+shift+5 - center active window on Y axis
!+NumpadClear::
  WinGetPos,,, Width, Height, A
  WinMove, A,, (Width-%MarginWidth%), (A_ScreenHeight/2)-(Height/2)
return
;shift+8 - pseudo fullscreen w/ taskbar
+NumpadUp::
  WinMove,A,, 0, %MarginWidth%, A_ScreenWidth, A_ScreenHeight-MarginWidth
return
;shift+2 - pseudo fullscreen w/o taskbar
+NumpadDown::
  WinMove,A,, 0, 0, A_ScreenWidth, A_ScreenHeight
return
;win+x - pseudo fullscreen w/o taskbar
^#x::
  WinMove,A,, 0, 0, A_ScreenWidth, A_ScreenHeight
return
;win+k - 1080
#k::
  WinMove,A,,,, 1920, 1080
  sleep 10
  WinGetPos,,, Width, Height, A
  WinMove, A,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
return
;;win+l - default terminal size@9pt
; #l::
;   WinMove,A,,,, 582, 391
; return

;mpv - 1080
#If WinActive("ahk_exe mpv.exe")
NumpadClear::
  WinMove,A,,,, 1920, 1080
  sleep 10
  CenterWindow(A)
  return
#if

;firefox - 1080
#If WinActive("ahk_exe firefox.exe")
NumpadClear::
  WinMove,A,,,, 1920, 1080
  sleep 10
  CenterWindow(A)
  return
#if

;fb2k
#If WinActive("ahk_exe foobar2000.exe")
NumpadClear::
  WinMove,A,,,, 905, 460 ;- main window > borders > no caption
  sleep 10
  CenterWindow(A)
  return
#if

;rpgmaker games
#IF WinActive("ahk_exe Game.exe")
NumpadClear::
  WinMove,A,,,, 846, 695
  sleep 10
  CenterWindow(A)
  return
#if

;8 - tile horizontally up
; +---------+
; |@@@@@@@@@|
; +---------+
; |         |
; +---------+
NumpadUp::
  WinMove,A,, %MarginWidth%, %MarginWidth%, A_ScreenWidth-MarginWidth*2, WindowHalfHeight
return
#+b::
  WinMove,A,, %MarginWidth%, %MarginWidth%, A_ScreenWidth-MarginWidth*2, WindowHalfHeight
return
;2 - tile horizontally down
; +---------+
; |         |
; +---------+
; |@@@@@@@@@|
; +---------+
NumpadDown::
  WinMove,A,, %MarginWidth%, LowerOffset, A_ScreenWidth-MarginWidth*2, WindowHalfHeight
return
#+n::
  WinMove,A,, %MarginWidth%, LowerOffset, A_ScreenWidth-MarginWidth*2, WindowHalfHeight
return

; -------------------- Normal windows
; +----+----+
; |    |    |
; +~~~~+~~~~+
; |    |    |
; +----+----+
;nomod
;7
NumpadHome::
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowNormalWidth%, %WindowHalfHeight%
return
;4
NumpadLeft::
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowNormalWidth%, %WindowFullHeight%
return
;alternative - win+shift+y
+#y::
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowNormalWidth%, %WindowFullHeight%
return
;1
NumpadEnd::
  WinMove,A,, %MarginWidth%, %LowerOffset%, %WindowNormalWidth%, %WindowHalfHeight%
return
;9
NumpadPgUp::
  WinMove,A,, %NormalFarLeftOffset%, %MarginWidth%, %WindowNormalWidth%, %WindowHalfHeight%
return
;6
NumpadRight::
  WinMove,A,, %NormalFarLeftOffset%, %MarginWidth%, %WindowNormalWidth%, %WindowFullHeight%
return
;alternative - win+shift+u
+#u::
  WinMove,A,, %NormalFarLeftOffset%, %MarginWidth%, %WindowNormalWidth%, %WindowFullHeight%
return
;3
NumpadPgDn::
  WinMove,A,, %NormalFarLeftOffset%, %LowerOffset%, %WindowNormalWidth%, %WindowHalfHeight%
return

; teleport to corners
;win+
;y - upper left
#y::
  WinGetPos,,, Width, Height, A
  WinMove,A,, 0+(MarginWidth), 0+(MarginWidth)
return
;b - lower left
#b::
  WinGetPos,,, Width, Height, A
  WinMove,A,, 0+(MarginWidth), (A_ScreenHeight)-(Height)-(MarginWidth)
return
;u - upper right
#u::
  WinGetPos,,, Width, Height, A
  WinMove,A,, (A_ScreenWidth)-(Width)-(MarginWidth), 0+(MarginWidth)
return
;n - lower right
#n::
  WinGetPos,,, Width, Height, A
  WinMove,A,, (A_ScreenWidth)-(Width)-(MarginWidth), (A_ScreenHeight)-(Height)-(MarginWidth)
return

; -------------------- Small windows
; +--+---+--+
; |  |   |  |
; +~~+   +~~+
; |  |   |  |
; +--+---+--+
;CTRL+
;7
^NumpadHome::
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowSmallWidth%, %WindowHalfHeight%
return
;4
^NumpadLeft::
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowSmallWidth%, %WindowFullHeight%
return
;1
^NumpadEnd::
  WinMove,A,, %MarginWidth%, %LowerOffset%, %WindowSmallWidth%, %WindowHalfHeight%
return
;9
^NumpadPgUp::
  WinMove,A,, %SmallFarLeftOffset%, %MarginWidth%, %WindowSmallWidth%, %WindowHalfHeight%
return
;6
^NumpadRight::
  WinMove,A,, %SmallFarLeftOffset%, %MarginWidth%, %WindowSmallWidth%, %WindowFullHeight%
return
;3
^NumpadPgDn::
  WinMove,A,, %SmallFarLeftOffset%, %LowerOffset%, %WindowSmallWidth%, %WindowHalfHeight%
return

; -------------------- Large windows
; +-----+---+
; |     |   |
; +~~~~~+   |
; |     |   |
; +-----+---+
;SHIFT+
;7
+NumpadHome::
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowLargeWidth%, %WindowHalfHeight%
return
;4
+NumpadLeft::
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowLargeWidth%, %WindowFullHeight%
return
;1
+NumpadEnd::
  WinMove,A,, %MarginWidth%, %LowerOffset%, %WindowLargeWidth%, %WindowHalfHeight%
return
;9
+NumpadPgUp::
  WinMove,A,, %LargeFarLeftOffset%, %MarginWidth%, %WindowLargeWidth%, %WindowHalfHeight%
return
;6
+NumpadRight::
  WinMove,A,, %LargeFarLeftOffset%, %MarginWidth%, %WindowLargeWidth%, %WindowFullHeight%
return
;3
+NumpadPgDn::
  WinMove,A,, %LargeFarLeftOffset%, %LowerOffset%, %WindowLargeWidth%, %WindowHalfHeight%
return

