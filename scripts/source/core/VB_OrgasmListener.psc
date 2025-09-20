Scriptname VB_OrgasmListener extends Quest

; --- External frameworks ---
SexLabFramework Property SexLab Auto

; --- Dispatch targets ---
VB_FeatureManager Property Manager  Auto
VB_Settings       Property Settings Auto

Event OnInit()
    ; SexLab orgasm hooks
    RegisterForModEvent("HookOrgasmEnd",   "OnSexLabHook")
    RegisterForModEvent("HookOrgasmStart", "OnSexLabHookStart")

    ; Vesselbound ModEvent bridge (external mods can fire orgasms to us)
    RegisterForModEvent("Vesselbound_Orgasm", "OnVBOrgasm")

    If Settings
        VB_Log.Trace("Listener: Registered for SexLab orgasm hooks", Settings)
        VB_Log.Trace("Listener: Registered for ModEvent 'Vesselbound_Orgasm'", Settings)
    Else
        Debug.Trace("[Vesselbound] Listener: Settings not set!", 2)
    EndIf
EndEvent

; -------------------------------
; SexLab: Orgasm End Hook handler
; -------------------------------
Function OnSexLabHook(String eventName, String argStr, Float argNum, Form sender)
    sslThreadController ctrl = sender as sslThreadController
    If ctrl == None
        If Settings
            VB_Log.Trace("Listener: Orgasm hook fired but no controller provided", Settings, 1)
        EndIf
        return
    EndIf

    Actor[] actors = ctrl.GetActors()
    If actors != None && Manager != None
        Int i = 0
        While i < actors.Length
            Actor a = actors[i]
            If a
                Manager.OnOrgasm(a)
            EndIf
            i += 1
        EndWhile
        If Settings
            VB_Log.Trace("Listener: Dispatched orgasm to " + actors.Length + " actor(s)", Settings)
        EndIf
    ElseIf Manager == None && Settings
        VB_Log.Trace("Listener: Manager not set; cannot dispatch orgasm", Settings, 2)
    EndIf
EndFunction

; Optional: SexLab start hook (kept for future sequencing)
Function OnSexLabHookStart(String eventName, String argStr, Float argNum, Form sender)
    ; No-op for now
EndFunction

; -----------------------------------
; Vesselbound ModEvent bridge handler
; -----------------------------------
; EXPECTED PAYLOAD:
;   Int id = ModEvent.Create("Vesselbound_Orgasm")
;   if id
;       ModEvent.PushInt(id, flags)   ; becomes argNum
;       ModEvent.PushForm(id, actor)  ; becomes sender
;       ModEvent.Send(id)
;   endif
Function OnVBOrgasm(String eventName, String argStr, Float argNum, Form sender)
    Actor akActor = sender as Actor
    If akActor == None
        If Settings
            VB_Log.Trace("Listener: 'Vesselbound_Orgasm' received but sender was not an Actor", Settings, 1)
        EndIf
        return
    EndIf

    If Manager
        Manager.OnOrgasm(akActor)
        If Settings
            VB_Log.Trace("Listener: Dispatched ModEvent orgasm -> " + akActor + " (flags=" + (argNum as Int) + ")", Settings)
        EndIf
    ElseIf Settings
        VB_Log.Trace("Listener: Manager not set; dropping ModEvent orgasm for " + akActor, Settings, 2)
    EndIf
EndFunction
