; ============================== ; Vesselbound — Core: Events ; File: source/core/events.psc ; Notes: Quest script for handling Vesselbound events. ; Registers hooks, handles orgasm → OIO logic. ; ==============================

Scriptname VB_Events Extends Quest

VB_Storage Property S Auto

Event OnInit() VB_Debug.Log("Events init") if S.HasSLSO ; RegisterForModEvent("SLSO_OrgasmStart", "OnSLSO_OrgasmStart") endif RegisterForSingleUpdate(1.0) EndEvent

Event OnUpdate() RegisterForSingleUpdate(5.0) EndEvent

Function OnActorOrgasm(Actor akVictim, Actor akPartner) if !S.OIOEnabled || akVictim == None return endif Float arousalMult = 1.0 if S.HasSLO arousalMult = GetArousalMult(akVictim) endif Float p = VB_Math.Clamp(S.OIOBaseChance * arousalMult, 0.0, 1.0) if VB_Math.Roll(p) OIO_CreateOva(akVictim, S.OIODurationHours) endif TryInstantFertilize(akVictim, akPartner) EndFunction

Float Function GetArousalMult(Actor a) Float arousal01 = 0.5 ; TODO: real query Float w = VB_Math.Clamp(S.OIOArousalWeight, 0.0, 1.0) return VB_Math.Clamp(arousal01 * w + (1.0 - w), 0.25, 2.0) EndFunction

Function OIO_CreateOva(Actor a, Float hours) VB_Debug.Log("[OIO] Adding ova to " + a + " for ~" + hours + "h") EndFunction

Function TryInstantFertilize(Actor akVictim, Actor akPartner) if !S.OIOInstantFertEnabled || akVictim == None || akPartner == None return endif if S.OIORequireWombPenetration && !S.HasWombAccess(akVictim) return endif if IsEjaculatingNow(akPartner) VB_Debug.Log("[OIO] Instant fertilization: " + akPartner + " → " + akVictim) endif EndFunction

Bool Function IsEjaculatingNow(Actor a) return False ; TODO: SexLab/SLSO query EndFunction