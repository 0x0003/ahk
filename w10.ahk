#NoEnv
#SingleInstance force
#Notrayicon
ListLines Off
SetBatchLines -1
SendMode Input
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
#KeyHistory 0
#WinActivateForce

Process, Priority,, H

SetWinDelay -1
SetControlDelay -1

#Include %A_LineFile%\..\VD.ahk

; virtual desktop info popup
vinfo(t) {
  a = % VD.getCurrentDesktopNum()
  b = % VD.getCount()
  BG := "000000"

  Gui, Destroy
  Gui, +LastFound +HwndGUI_ID -Caption +AlwaysOnTop +Disabled -SysMenu +Owner
  Gui, Color, %BG%
  Gui, Font, s54 cEEEEEE, Iosevka
  Gui, Add, Text,, %a% / %b%
  WinSet, Transparent, 150
  Gui, Show, NoActivate
  Sleep t
  Gui, Destroy
  GoSub, HookWindow ; re-initialize hook from main.ahk
}
#z::vinfo(500)

; next/prev desktop
#r::VD.goToRelativeDesktopNum(+1)
#e::VD.goToRelativeDesktopNum(-1)

; switch to desktop
#1::VD.goToDesktopNum(1)
#2::VD.goToDesktopNum(2)
#3::VD.goToDesktopNum(3)
#4::VD.goToDesktopNum(4)
#5::VD.goToDesktopNum(5)
#6::VD.goToDesktopNum(6)
#7::VD.goToDesktopNum(7)
#8::VD.goToDesktopNum(8)
#9::VD.goToDesktopNum(9)

; send to next/prev desktop
#d::VD.goToDesktopNum(VD.MoveWindowToRelativeDesktopNum("A", 1)), vinfo(200)
#s::VD.goToDesktopNum(VD.MoveWindowToRelativeDesktopNum("A", -1)), vinfo(200)

; send to desktop
^#1::VD.MoveWindowToDesktopNum("A",1), VD.goToDesktopNum(1)
^#2::VD.MoveWindowToDesktopNum("A",2), VD.goToDesktopNum(2)
^#3::VD.MoveWindowToDesktopNum("A",3), VD.goToDesktopNum(3)
^#4::VD.MoveWindowToDesktopNum("A",4), VD.goToDesktopNum(4)
^#5::VD.MoveWindowToDesktopNum("A",5), VD.goToDesktopNum(5)
^#6::VD.MoveWindowToDesktopNum("A",6), VD.goToDesktopNum(6)
^#7::VD.MoveWindowToDesktopNum("A",7), VD.goToDesktopNum(7)
^#8::VD.MoveWindowToDesktopNum("A",8), VD.goToDesktopNum(8)
^#9::VD.MoveWindowToDesktopNum("A",9), VD.goToDesktopNum(9)

; new desktop
#w::VD.createDesktop(false), vinfo(200)

; remove last desktop
#q::VD.removeDesktop(VD.getCount()), vinfo(200)

; alt+f4
#f::
  Send, !{F4}
return

; task switcher
#MaxThreadsPerHotkey 255
LWin & a::AltTab
return
#MaxThreadsPerHotkey
; task switcher rev
;#MaxThreadsPerHotkey 255
;LWin & h::ShiftAltTab
;return
;#MaxThreadsPerHotkey

; taskview
#h:: Send, #{Tab}

; maximize/restore active window
#x::
  WinGet a, MinMax, A
  if (a==0)
    WinMaximize A
  else
    WinRestore A
return

; minimize active window
#i::
  WinMinimize A
return

; open explorer
^#e::
  Send, #e
return

; open `run` prompt
^#r::
  Send, #r
return

; ueli
#o::
  Send, +#o
  Winset, Alwaysontop, , ahk_exe ueli.exe
  WinActivate, ahk_exe ueli.exe
return

; terminal
#Space::
  ; NOTE: the spawned window doesn't gain focus
  ; WinActivate Program Manager ; messes with last focus
  run, D:\Software\term\alacritty\alacritty.exe --config-file D:\Software\term\alacritty\config.yml --command wsl, \\wsl.localhost\Arch\home\tuna,,PID
  WinWait ahk_pid %PID%
  Sleep, 300
  WinActivate, ahk_pid %PID%
return
^#Space::
  ; WinActivate Program Manager ; desktop
  run, D:\Software\term\alacritty\alacritty.exe --config-file D:\Software\term\alacritty\config.yml, C:\Users\%A_Username%
return

; multimedia controls
; ^+p::Media_Play_Pause
; ^+;::Volume_Down
; ^+'::Volume_Up
; ^+,::Media_Prev
; ^+.::Media_Next

; show/hide taskbar
SetWorkArea(left, top, right, bottom) {
  VarSetCapacity(area, 16)
  NumPut(left,  area, 0, "UInt")
  NumPut(top,   area, 4, "UInt")
  NumPut(right, area, 8, "UInt")
  NumPut(bottom,area,12, "UInt")
  DllCall("SystemParametersInfo", "UInt", 0x2F, "UInt", 0, "UPtr", &area, "UInt", 0) ; 0x2F SPI_SETWORKAREA
}

TBState(opacity,topheight,m) {
  WinSet, transparent, %opacity%, ahk_class Shell_TrayWnd
  WinSet, transparent, %opacity%, ahk_class Shell_SecondaryTrayWnd
  SysGet, Mon, %m%
  SetWorkArea(MonLeft, topheight, MonRight, MonBottom) ; topheight default 30
}

ToggleTaskbar() {
  WinGet, t, transparent, ahk_class Shell_TrayWnd
  if (t != 255) then {
    ; TBState(255, 30, "Monitor") ; autohide in desktop mode = false; NOTE: causes visual glitches  on some maximized windows
    TBState(255, 0, "Monitor") ; autohide in desktop mode = true
  } else {
    TBState(0, 0, "MonitorWorkArea")
  }
}
#t::ToggleTaskbar()
#.::ToggleTaskbar()

; toggleTaskbar(how_to_toggle) {
;   static SW_HIDE := 0, SW_SHOWNA := 8, SPI_SETWORKAREA := 0x2F
;   DetectHiddenWindows, On
;   hTB := WinExist("ahk_class Shell_TrayWnd")
;   WinGetPos,,,, H
;   hBT := WinExist("ahk_class Button ahk_exe Explorer.EXE")  ; for Windows 7
;   b := DllCall("IsWindowVisible", "Ptr", hTB)
;   ; always set to false
;   if (how_to_toggle != -1)
;   {
;     b = %how_to_toggle%
;   }
;   ; for k, v in [hTB, hBT]
;   ;   ( v && DllCall("ShowWindow", "Ptr", v, "Int", b ? SW_HIDE : SW_SHOWNA) )
;   ; VarSetCapacity(RECT, 16, 0)
;   ; NumPut(A_ScreenWidth, RECT, 8)
;   ; NumPut(A_ScreenHeight - !b * H, RECT, 12, "UInt")
;   ; DllCall("SystemParametersInfo", "UInt", SPI_SETWORKAREA, "UInt", 0, "Ptr", &RECT, "UInt", 0)
; }
; #t:: toggleTaskbar(-1)

; mouse bindings when the cursor is over the root window
MouseIsOver(WinTitle) {
  MouseGetPos, , , Win
  return WinExist(WinTitle . " ahk_id " . Win)
}
#If MouseIsOver("ahk_class Progman ahk_exe Explorer.EXE") or MouseIsOver("ahk_class WorkerW ahk_exe Explorer.EXE")
  ; next/prev desktop
  WheelDown::VD.goToRelativeDesktopNum(+1)
  WheelUp::VD.goToRelativeDesktopNum(-1)
  ; taskview
  XButton2::
    Send, #{Tab}
  return
  ; virtual desktop info popup
  MButton:: vinfo(500)
  ; show/hide taskbar
  XButton1::ToggleTaskbar()
  ; start menu; use any_modifier_key+RButton to open the default right-click menu
  RButton::
  Send, {LWin}
  return
#if
