#SingleInstance Force
#installKeybdHook
#KeyHistory 0
#Notrayicon
#Persistent
#NoEnv ; Recommended for performance and compatibility /w future AHK releases
;#Warn ; Recommended for catching common errors
SendMode Input ; Recommended for new scripts
SetWorkingDir %A_ScriptDir% ; Consistent starting directory
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetBatchLines, -1
SetWinDelay, 2
SetTitleMatchMode, 2

; run grid and source config
Run, grid.ahk,,, gridPid
#include config.ahk

; ------------------- main hook
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

  ShellMessage(wParam,lParam)
  {
    If (wParam = 1) ;  HSHELL_WINDOWCREATED := 1
    {
      Sleep, 10
      AdjustWindow(lParam)
    }
  }
Return

; Adjust Window
AdjustWindow(id)
{
  WinId := id
  WinTitle := id = "A" ? "A" : "ahk_id " . id

  ; check if the window is in alt-tab menu
  WinGet, WinExStyle, ExStyle, %WinTitle%
  If (WinExStyle & 0x80)
  {
    Return
  }

  ; Match classes and/or processes
  WinGetClass, WinClass, %WinTitle%
  WinGet, WinProcess, ProcessName, %WinTitle%


;  Processes/classes go here
;  WinSet, Style, -0x40000, A  ; WS_THICKFRAME

  ;Explorer caption
  If WinClass In % "CabinetWClass"
  If WinProcess In % "explorer.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
  }

  ;qBitTorrent
  If WinProcess In % "qbittorrent.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    WinSet, Style, -0x40000, %WinTitle%
  }

  ;Anki caption
  If WinProcess In % "anki.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
  }

  ;Notepad caption
  If WinProcess In % "notepad.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
  }

  ;Mintty
  If WinProcess In % "mintty.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    WinSet, Style, -0x40000, %WinTitle%
  }

  ;Firefox thickframe
  If WinProcess In % "firefox.exe"
  {
    Winset, Style, -0x40000, %WinTitle%
  }

  ;Nomacs
  If WinProcess In % "nomacs.exe"
  {
    WinSet, Style, -0xC00000, %WinTitle%
    Winset, Style, -0x40000, %WinTitle%
  }

  ;SumatraPDF
  If WinProcess In % "SumatraPDF.exe"
  {
    winset, style, -0xc00000, %wintitle%
    winset, style, -0x40000, %wintitle%
  }

  ; Uncomment this and comment section above
  ; if you want it to work on every window
  ; WinSet, Style, -0xC00000, %WinTitle%
}

AdjustAllWindows:
WinGet, id, list,,, Program Manager
  Loop, %id%
  {
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
}
return

; remap caps
$CapsLock::Esc
return
!CapsLock::CapsLock
return

; ff
#If WinActive("ahk_exe firefox.exe")
  ^e::^l   ;focus urlbar
  ^#e::^#e
#if

; terminal
^#Space::
  run, C:\Cygwin\bin\mintty.exe /usr/bin/fish --login
  sleep 200
  WinMove,A,, %MarginWidth%, %MarginWidth%, %WindowNormalWidth%, %WindowFullHeight%
return
#Space::
  run, C:\Cygwin\bin\mintty.exe /usr/bin/fish --login
return

; foobar
#v::
  run, C:\Apps\players\Foobar2000\foobar2000.exe
return

; vi-like controls in blackbox menu
#If WinActive("ahk_class BBMenu")
  h::Left
  j::Down
  k::Up
  l::Right
  o::Enter
  g::Home
  +g::End
#if

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

; make window be always on top
#^w::
  Winset, Alwaysontop, , A
return

; mute/unmute mic
; either 6 or 7
#^a::
  SoundSet, +1, MASTER, Mute, 6
return

; mpv global hotkeys
;#^!Space::
;  DetectHiddenWindows, On
;  IfWinNotActive, ahk_class mpv
;    Send ^!{Space}
;  ControlSend,, {Space}, ahk_class mpv
;  DetectHiddenWindows Off
;return
;
;#^!Up::
;  DetectHiddenWindows, On
;  IfWinNotActive, ahk_class mpv
;    Send ^!{Up}
;  ControlSend,, 0, ahk_class mpv
;  DetectHiddenWindows, Off
;return
;
;#^!Down::
;  DetectHiddenWindows, On
;  IfWinNotActive, ahk_class mpv
;    Send ^!{Down}
;  ControlSend,, 9, ahk_class mpv
;  DetectHiddenWindows, Off
;return

; reload script
!#r::
  WinClose, grid.ahk,,, gridPid
  Reload
return

; ------------------- source other modules
#include tile.ahk
#include moveandresize.ahk

