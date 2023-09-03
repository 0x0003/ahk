; move
wm(rx, ry) {
  WinExist("A")
  WinGetPos, x, y,,
  rrx := rx + x
  rry := ry + y
  WinMove,A,,%rrx%, %rry%,,
}

; resize
wr(rx, ry, rh, rw) {
  WinExist("A")
  WinGetPos, x, y, height, width
  rrx := rx + x
  rry := ry + y
  rrh := rh + height
  rrw := rw + width
  WinMove,A,,%rrx%, %rry%,%rrh%,%rrw%
}

; ------------------- move
;left
^#h::
  wm(0-MovePix, 0)
return
;slow left
+^#h::
  wm(0-SlowMovePix, 0)
return

;left and up
^#y::
  wm(0-MovePix, 0-MovePix)
return
;slow left and up
+^#y::
  wm(0-SlowMovePix, 0-SlowMovePix)
return

;left and down
^#b::
  wm(0-MovePix, 0+MovePix)
return
;slow left and down
+^#b::
  wm(0-SlowMovePix, 0+SlowMovePix)
return

;down
^#j::
  wm(0,0+MovePix)
return
;slow down
+^#j::
  wm(0,0+SlowMovePix)
return

;up
^#k::
  wm(0,0-MovePix)
return
;slow up
+^#k::
  wm(0,0-SlowMovePix)
return

;right
^#l::
  wm(0+MovePix,0)
return
;slow right
+^#l::
  wm(0+SlowMovePix,0)
return

;right and down
^#n::
  wm(0+MovePix,0+MovePix)
return
;slow right and down
+^#n::
  wm(0+SlowMovePix,0+SlowMovePix)
return

;right and up
^#u::
  wm(0+MovePix,0-MovePix)
return
;slow right and up
+^#u::
  wm(0+SlowMovePix,0-SlowMovePix)
return

; ------------------- resize
;width-
!#h::
  wr(0+MovePix/2, 0, 0-MovePix, 0)
return
;slow width-
^!#h::
  wr(0+SlowMovePix/2, 0, 0-SlowMovePix, 0)
return

;height-
!#k::
  wr(0, 0+MovePix/2, 0, 0-MovePix)
return
;slow height-
^!#k::
  wr(0, 0+SlowMovePix/2, 0, 0-SlowMovePix)
return

;height+
!#j::
  wr(0, 0-MovePix/2, 0, 0+MovePix)
return
;slow height+
^!#j::
  wr(0, 0-SlowMovePix/2, 0, 0+SlowMovePix)
return

;width+
!#l::
  wr(0-MovePix/2, 0, 0+MovePix, 0)
return
;slow width+
^!#l::
  wr(0-SlowMovePix/2, 0, 0+SlowMovePix, 0)
return

;;width+ height+
;!#u::
;  wr(0+MovePix/2, 0-MovePix/2, 0+MovePix, 0+MovePix)
;return
;; slow width+ height+
;+!#u::
;  wr(0+SlowMovePix, 0-SlowMovePix, 0+SlowMovePix, 0+SlowMovePix)
;return
;
;;width- height-
;!#b::
;  wr(0-MovePix/2, 0+MovePix/2, 0-MovePix, 0-MovePix)
;return
;;slow width- height-
;+!#b::
;  wr(0-SlowMovePix, 0+SlowMovePix, 0-SlowMovePix, 0-SlowMovePix)
;return

; ------------------- meta+lmb drag
#LButton::
CoordMode, Mouse  ; switch to absolute coords
MouseGetPos, EWD_MouseStartX, EWD_MouseStartY, EWD_MouseWin
WinGetPos, EWD_OriginalPosX, EWD_OriginalPosY,,, ahk_id %EWD_MouseWin%
WinGet, EWD_WinState, MinMax, ahk_id %EWD_MouseWin%
if EWD_WinState = 0  ; check if maximized
  SetTimer, EWD_WatchMouse, 10
return

EWD_WatchMouse:
GetKeyState, EWD_LButtonState, LButton, P
if EWD_LButtonState = U  ; button released
{
  SetTimer, EWD_WatchMouse, off
  return
}
GetKeyState, EWD_EscapeState, Escape, P
if EWD_EscapeState = D  ; esc pressed
{
  SetTimer, EWD_WatchMouse, off
  WinMove, ahk_id %EWD_MouseWin%,, %EWD_OriginalPosX%, %EWD_OriginalPosY%
  return
}

CoordMode, Mouse
MouseGetPos, EWD_MouseX, EWD_MouseY
WinGetPos, EWD_WinX, EWD_WinY,,, ahk_id %EWD_MouseWin%
SetWinDelay, -1 ; smoother movement
WinMove, ahk_id %EWD_MouseWin%,, EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY
EWD_MouseStartX := EWD_MouseX  ; update for the next timer-call to this subroutine
EWD_MouseStartY := EWD_MouseY
return

