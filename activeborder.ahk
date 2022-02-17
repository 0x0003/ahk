#KeyHistory 0
#Persistent
#Notrayicon

SetTimer, DrawRect, 50
border_thickness = 2
; colors
;#EA91A9
;#755b76
;#B54B3E
;#F0696F
;#F0686F
;#F0AA6F
;#C0BFBF
;#FFB7C5
;#E9D6F3
;#E8CCD7
;#C0BFBF
;#FFF8E7
;#E9999D
;#FF768C
border_color = EEEEEE
border_transparency = 75 ; 75

DrawRect:
WinGetPos, x, y, w, h, A
if (x="")
  return
Gui, +Lastfound +AlwaysOnTop +Toolwindow

borderType:="outside"

if (borderType="outside") {
  outerX:=0
  outerY:=0
  outerX2:=w+2*border_thickness
  outerY2:=h+2*border_thickness

  innerX:=border_thickness
  innerY:=border_thickness
  innerX2:=border_thickness+w
  innerY2:=border_thickness+h

  newX:=x-border_thickness
  newY:=y-border_thickness
  newW:=w+2*border_thickness
  newH:=h+2*border_thickness

} else if (borderType="inside") {
  WinGet, myState, MinMax, A
  if (myState=1)
    offset:=8
  else
    offset:=0

  outerX:=offset
  outerY:=offset
  outerX2:=w-offset
  outerY2:=h-offset

  innerX:=border_thickness+offset
  innerY:=border_thickness+offset
  innerX2:=w-border_thickness-offset
  innerY2:=h-border_thickness-offset

  newX:=x
  newY:=y
  newW:=w
  newH:=h

} else if (borderType="both") {
  outerX:=0
  outerY:=0
  outerX2:=w+2*border_thickness
  outerY2:=h+2*border_thickness

  innerX:=border_thickness*2
  innerY:=border_thickness*2
  innerX2:=w
  innerY2:=h

  newX:=x-border_thickness
  newY:=y-border_thickness
  newW:=w+4*border_thickness
  newH:=h+4*border_thickness
}

Gui, Color, %border_color%
Gui, -Caption

WinSet, Region, %outerX%-%outerY% %outerX2%-%outerY% %outerX2%-%outerY2% %outerX%-%outerY2% %outerX%-%outerY%    %innerX%-%innerY% %innerX2%-%innerY% %innerX2%-%innerY2% %innerX%-%innerY2% %innerX%-%innerY%

WinSet, Transparent, % border_transparency
Gui, Show, w%newW% h%newH% x%newX% y%newY% NoActivate, Table awaiting Action
return

