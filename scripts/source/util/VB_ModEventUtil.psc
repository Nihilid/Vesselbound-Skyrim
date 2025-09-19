Scriptname VB_ModEventUtil

; Fire a standard orgasm event Vesselbound will pick up
Function FireOrgasm(Actor akActor, Int flags = 0) Global
    If akActor == None
        return
    EndIf
    Int id = ModEvent.Create("Vesselbound_Orgasm")
    If id
        ModEvent.PushInt(id, flags)    ; becomes argNum
        ModEvent.PushForm(id, akActor) ; becomes sender
        ModEvent.Send(id)
    EndIf
EndFunction
