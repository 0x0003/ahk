#SingleInstance Force
#installKeybdHook
#KeyHistory 0
#Notrayicon
#Persistent
#NoEnv
#MaxThreads 255
; #Warn
SendMode Input
SetWorkingDir %A_ScriptDir% ; Consistent starting directory
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetBatchLines, -1
SetWinDelay, 2
SetTitleMatchMode, 2

Run, grid.ahk,,, gridPid
Run, w10_taskbar.ahk
#include config.ahk

; ------------------- window decorations
; Uncomment this if you want a hotkey to set it for every window
; !+r::GoSub, AdjustAllWindows

; Init
GoSub, HookWindow
; Run it once for every window
GoSub, AdjustAllWindows
Return

HookWindow:
  Gui +LastFound
  hWnd := WinExist()

  DllCall( "RegisterShellHookWindow", UInt,hWnd )
  MsgNum := DllCall( "RegisterWindowMessage", Str,"SHELLHOOK" )
  OnMessage( MsgNum, "ShellMessage" )

  ShellMessage(wParam,lParam) {
    If (wParam = 1) { ;  HSHELL_WINDOWCREATED := 1
      Sleep, 25 ; 10
      AdjustWindow(lParam)
    }
  }
Return

; Adjust Window
AdjustWindow(id) {
  WinId := id
  WinTitle := id = "A" ? "A" : "ahk_id " . id

  ; check if the window is in alt-tab menu
  WinGet, WinExStyle, ExStyle, %WinTitle%
  If (WinExStyle & 0x80) {
    Return
  }

  ; Match classes and/or processes
  WinGetClass, WinClass, %WinTitle%
  WinGet, WinProcess, ProcessName, %WinTitle%

;  Processes/classes go here
;  WinSet, Style, -0x40000, A  ; WS_THICKFRAME

  ; Explorer caption
  ;If WinClass In % "CabinetWClass"
  ;If WinProcess In % "explorer.exe"
  ;{
  ;  WinSet, Style, -0xC00000, %WinTitle%
  ;}

  ; qbt
  If WinProcess In % "qbittorrent.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    WinSet, Style, -0x40000, %WinTitle%
  }

  ; Anki
  If WinProcess In % "anki.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    WinSet, Style, -0x40000, %WinTitle%
  }

  ; Notepad caption
  If WinProcess In % "notepad.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
  }

  ; Mintty
  If WinProcess In % "mintty.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    WinSet, Style, -0x40000, %WinTitle%
  }

  ; Firefox
  ; Customize Toolbar > "Title Bar" on
  If WinProcess In % "firefox.exe"
  {
    Winset, Style, -0x40000, %WinTitle%
    WinSet, Style, -0xC00000, %WinTitle%
  }

  ; Qutebrowser thickframe
  If WinProcess In % "qutebrowser.exe"
  {
   ;WinSet, Style, -0xC00000, %WinTitle%
   WinSet, Style, -0x40000, %WinTitle%
  }

  ; qimgv
  If WinProcess In % "qimgv.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    Winset, Style, -0x40000, %WinTitle%
  }

  ; SumatraPDF
  If WinProcess In % "SumatraPDF.exe"
  {
    winset, style, -0xc00000, %wintitle%
    winset, style, -0x40000, %wintitle%
  }

  ; sioyek
  If WinProcess In % "sioyek.exe"
  {
    winset, style, -0xc00000, %wintitle%
    winset, style, -0x40000, %wintitle%
  }

  ; Volume mixer
  If WinProcess In % "SndVol.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    Winset, Style, -0x40000, %WinTitle%
  }

  ; MO2
  If WinProcess In % "ModOrganizer.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    Winset, Style, -0x40000, %WinTitle%
  }

  ; nekoray
  If WinProcess In % "Throne.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    Winset, Style, -0x40000, %WinTitle%
  }

  ; Uncomment this and comment section above
  ; if you want it to work on every window
  ; WinSet, Style, -0xC00000, %WinTitle%
}

AdjustAllWindows:
WinGet, id, list,,, Program Manager
  Loop, %id% {
    AdjustWindow(id%A_Index%)
  }
Return

; ------------------- mappings
; toggle caption
#^f::
WinGetTitle, currentWindow, A
IfWinExist %currentWindow%
{
  WinSet, Style, ^0xC00000
}
return

; toggle border (thickframe)
#^c::
WinGetTitle, currentWindow, A
IfWinExist %currentWindow%
{
  WinSet, Style, ^0x40000, A
  ; WinSet, Style, ^0x800000, A
}
return

; swap caps and esc (IME-compatible)
$sc03A::sc001
$Esc::CapsLock
;^sc03A::!sc029

; ff
#If WinActive("ahk_exe firefox.exe")
  ^e::^l   ;focus urlbar
  ^#e::^#e
#if

; foobar
#v::
  run, C:\Software\players\Foobar2000\foobar2000.exe
return

; volume mixer
#m::
  run, SndVol.exe
  sleep 200
  WinMove, A,,,, 1440
return

; stb-imv
#If WinActive("ahk_exe imv.exe")
  a::Left
  d::Right
  l::Right
  h::Left
  +Space::
    Send {Left}
  return
  b::l
  ; preserve default behaviour
  #a::#a
  #d::#d
  ^#h::^#h
  ^#b::^#b
  ^#l::^#l
  !#h::^#h
  !#l::^#l
#if

; imageglass
#If WinActive("ahk_exe ImageGlass.exe")
  $a::Left
  $d::Right
  $Space::
    Send {Right}
  return
  $+Space::
    Send {Left}
  return
  $b::h
  $f::
    WinGet, active, ID, A
    Send {F10}
    WinActivate, ahk_id %active%
  return
#if

; RWin
!^LWin::
  Keywait Ctrl
  Keywait Alt
  Send {RWin}
return

; toggle border on active window
#c::
  DetectHiddenWindows, On
  IfWinExist, activeborder.ahk ahk_class AutoHotkey
    WinClose, activeborder.ahk ahk_class AutoHotkey
  else IfWinNotExist, activeborder.ahk ahk_class AutoHotkey
    Run, activeborder.ahk
  DetectHiddenWindows, Off
return

; toggle always on top on active window
#^w::
  Winset, Alwaysontop, , A
return

; window transparency
#^t::
  WinSet, Transparent, Off, A
return
#!t::
  WinSet, Transparent, 210, A
return
#If WinActive("ahk_exe alacritty.exe")
#!t::
  WinSet, Transparent, 230, A
  return
#if

; mute/unmute mic
; either 6 or 7
;#^a::
;  SoundSet, +1, MASTER, Mute, 6
;return

; reload the script
!#r::
  WinClose, grid.ahk,,, gridPid
  Reload
return

; ------------------- source other modules
#include tile.ahk
#include moveandresize.ahk
#include w10.ahk

