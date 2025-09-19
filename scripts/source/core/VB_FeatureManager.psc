Scriptname VB_FeatureManager extends Quest

VB_Settings        Property Settings  Auto
VB_Feature_OIO     Property OIO       Auto
VB_Feature_Cascades Property Cascades Auto

; Called by the OrgasmListener for each participant we want to evaluate
Function OnOrgasm(Actor akActor)
    If akActor == None || Settings == None
        return
    EndIf

    VB_Log.Trace("Manager: OnOrgasm for " + akActor, Settings)

    If OIO
        OIO.HandleOrgasm(akActor)
    EndIf
    If Cascades
        Cascades.HandleOrgasm(akActor)
    EndIf

    ; ---- Emit: Vesselbound_OrgasmProcessed(Actor) ----
    Int e = ModEvent.Create("Vesselbound_OrgasmProcessed")
    If e
        ModEvent.PushForm(e, akActor) ; becomes 'sender' on the receiver
        ModEvent.Send(e)
        VB_Log.Trace("Manager: Emitted 'Vesselbound_OrgasmProcessed' for " + akActor, Settings)
    EndIf
EndFunction

; If you have both parties and want pair-wise logic later:
Function OnOrgasmPair(Actor akA, Actor akB)
    If akA
        OnOrgasm(akA)
    EndIf
    If akB
        OnOrgasm(akB)
    EndIf
EndFunction

