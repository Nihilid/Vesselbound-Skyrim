Scriptname VB_TestConsole

Function Run(Int flags = 0) Global
    Actor p = Game.GetPlayer()
    _FireEvent(p, flags)
EndFunction

Function RunOnTarget(Int flags = 0) Global
    ObjectReference r = Game.GetCurrentCrosshairRef()
    Actor a = r as Actor
    If a == None
        Debug.Notification("[VB Test] No actor under crosshair")
        return
    EndIf
    _FireEvent(a, flags)
EndFunction

Function RunOnRef(ObjectReference ref, Int flags = 0) Global
    Actor a = ref as Actor
    If a == None
        Debug.Notification("[VB Test] Not an actor ref")
        return
    EndIf
    _FireEvent(a, flags)
EndFunction

Function _FireEvent(Actor akActor, Int flags)
    If akActor == None
        Debug.Notification("[VB Test] No valid actor")
        return
    EndIf
    Int id = ModEvent.Create("Vesselbound_Orgasm")
    If id
        ModEvent.PushInt(id, flags)
        ModEvent.PushForm(id, akActor)
        ModEvent.Send(id)
        Debug.Notification("[VB Test] Fired Vesselbound_Orgasm for " + akActor)
        Debug.Trace("[Vesselbound] VB_TestConsole: Sent Vesselbound_Orgasm (actor=" + akActor + ", flags=" + flags + ")")
    Else
        Debug.Trace("[Vesselbound] VB_TestConsole: Failed to create ModEvent", 2)
    EndIf
EndFunction
