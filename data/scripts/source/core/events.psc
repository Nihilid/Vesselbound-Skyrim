; ===== source/core/events.psc =====
ScriptName VB_Events Extends Quest


VB_Storage Property S Auto


; Registers to external mod events where available.
Event OnInit()
VB_Debug.Log("Events init")


; --- SexLab/SLSO hooks (names TBD per actual API) ---
if S.HasSLSO
; Example: RegisterForModEvent("SLSO_OrgasmStart", "OnSLSO_OrgasmStart")
endif
; Fallback generic SexLab callbacks would be registered here


RegisterForSingleUpdate(1.0)
EndEvent


Event OnUpdate()
; Periodic TTL cleanup or parasite tick scheduling will go here (Phase 5)
RegisterForSingleUpdate(5.0)
EndEvent


; === Orgasm → OIO roll (stub) ===
Function OnActorOrgasm(Actor akVictim, Actor akPartner)
if !S.OIOEnabled || akVictim == None
return
endif
Float arousalMult = 1.0
if S.HasSLO
arousalMult = GetArousalMult(akVictim)
endif
Float p = VB_Math.Clamp(S.OIOBaseChance * arousalMult, 0.0, 1.0)
if VB_Math.Roll(p)
OIO_CreateOva(akVictim, S.OIODurationHours)
endif


TryInstantFertilize(akVictim, akPartner)
EndFunction


Float Function GetArousalMult(Actor a) ; TODO: replace with real SLO query
; placeholder: map 0..100 to 0.5..1.5 using weight
Float arousal01 = 0.5 ; TODO
Float w = VB_Math.Clamp(S.OIOArousalWeight, 0.0, 1.0)
return VB_Math.Clamp(arousal01 * w + (1.0 - w), 0.25, 2.0)
EndFunction


Function OIO_CreateOva(Actor a, Float hours)
VB_Debug.Log("[OIO] Adding ova to " + a + " for ~" + hours + "h")
; TODO: append to actor-scoped list; schedule decay
EndFunction


Function TryInstantFertilize(Actor akVictim, Actor akPartner)
if !S.OIOInstantFertEnabled || akVictim == None || akPartner == None
return
endif
if S.OIORequireWombPenetration && !S.HasWombAccess(akVictim)
return
endif
if IsEjaculatingNow(akPartner)
VB_Debug.Log("[OIO] Instant fertilization: " + akPartner + " → " + akVictim)
; TODO: call FM+/FHU conception path with immediate success
endif
EndFunction


Bool Function IsEjaculatingNow(Actor a)
; TODO: query SexLab/SLSO state
return False
EndFunction