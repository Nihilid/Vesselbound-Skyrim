Scriptname VB_OrgasmListener extends Quest

; SexLab
SexLabFramework Property SexLab Auto

; Dispatch
VB_FeatureManager Property Manager Auto
VB_Settings       Property Settings Auto

Event OnInit()
    ; Register for SexLab hook events (works via Mod Events)
    RegisterForModEvent("HookOrgasmEnd", "OnSexLabHook")
    RegisterForModEvent("HookOrgasmStart", "OnSexLabHookStart") ; optional if you ever want pre-end logic
    RegisterForModEvent("Vesselbound_Orgasm", "OnVBOrgasm")

    If Settings
        VB_Log.Trace("Listener: Registered for SexLab orgasm hooks", Settings)
    Else
        Debug.Trace("[Vesselbound] Listener: Settings not set!", 2)

    ; Optional: if you want a simple pair notification too (see notes below)
    ; RegisterForModEvent("Vesselbound_OrgasmPair", "OnVBOrgasmPair")
    If Settings
    VB_Log.Trace("Listener: Registered for ModEvent 'Vesselbound_Orgasm'", Settings)
EndIf

EndEvent

; Called for HookOrgasmEnd
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
    EndIf
EndFunction

; Optional: start-of-orgasm hook
Function OnSexLabHookStart(String eventName, String argStr, Float argNum, Form sender)
    ; No-op for now, but keeping for future sequencing if needed
EndFunction

; ---------------------------
; Vesselbound ModEvent Bridge
; ---------------------------
; EXPECTED PAYLOAD:
;   Int id = ModEvent.Create("Vesselbound_Orgasm")
;   if id
;       ; PUSH ORDER MATTERS!
;       ; The *last* pushed form becomes the "sender" param here.
;       ModEvent.PushInt(id, flags)   ; (optional) bitfield — becomes argNum
;       ModEvent.PushForm(id, akActor); becomes 'sender'
;       ModEvent.Send(id)
;   endif
;
; FLAGS (optional suggestion):
;   bit 0 (1): Aggressor
;   bit 1 (2): Consensual
;   bit 2 (4): Solo
;
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
            VB_Log.Trace("Listener: Dispatched ModEvent orgasm -> " + akActor + " (flags=" + argNum as Int + ")", Settings)
        EndIf
    EndIf
EndFunction
