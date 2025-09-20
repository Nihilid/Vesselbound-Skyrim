Scriptname VB_FeatureManager extends Quest

VB_Storage          Property S         Auto
VB_Feature_OIO      Property OIO       Auto
VB_Feature_Cascades Property Cascades  Auto

Function OnOrgasm(Actor akActor)
    If akActor == None || S == None
        return
    EndIf

    VB_Log.Trace("Manager: OnOrgasm for " + akActor, S)

    If OIO
        OIO.HandleOrgasm(akActor)
    EndIf

    If Cascades
        Cascades.HandleOrgasm(akActor)
    EndIf

    ; Emit post-processed event for other mods
    Int e = ModEvent.Create("Vesselbound_OrgasmProcessed")
    If e
        ModEvent.PushForm(e, akActor)
        ModEvent.Send(e)
        VB_Log.Trace("Manager: Emitted 'Vesselbound_OrgasmProcessed' for " + akActor, S)
    EndIf
EndFunction
