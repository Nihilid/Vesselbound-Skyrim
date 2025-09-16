ScriptName VB_Events Extends Quest

VB_Storage Property S Auto

Import SKSE_Events

; SexLab/SLSO detection flags cached on init for clarity
Bool hasSLSO
Bool hasSLO

; Soft state used by crude ejaculation window if SLSO isn’t present
Float lastPartnerEjacGT

Event OnInit()
    VB_Debug.Log("Events init")
    hasSLSO = S.HasSLSO
    hasSLO  = S.HasSLO

    ; --- Register for SLSO orgasm if available ---
    if hasSLSO
        ; SLSO events differ between versions; we’ll listen to a couple common names.
        RegisterForModEvent("SLSO_OrgasmStart", "OnSLSO_OrgasmStart")
        RegisterForModEvent("SLSO_OrgasmEnd",   "OnSLSO_OrgasmEnd")
    endif

    ; If you later add native SexLab hooks, you can register here too.

    RegisterForSingleUpdate(1.0)
EndEvent

Event OnUpdate()
    ; Keep a lightweight heartbeat for any future timers (ejac window, etc.)
    RegisterForSingleUpdate(5.0)
EndEvent

; -------- Orgasms → OIO --------

; Call this from any source that indicates the victim climaxed
Function OnActorOrgasm(Actor akVictim, Actor akPartner)
    if akVictim == None || S == None
        return
    endif
    if !S.OIOEnabled
        return
    endif

    ; Chance roll for creating ova
    Float arousalMult = 1.0
    if hasSLO
        arousalMult = GetArousalMult(akVictim)
    endif
    Float p = Clamp01(S.OIOBaseChance * arousalMult)
    if Roll01(p)
        OIO_CreateOva(akVictim, S.OIODurationHours)
    endif

    ; Optional instant fertilization
    TryInstantFertilize(akVictim, akPartner)
EndFunction

; ---- SLSO glue (common event names) ----
Event OnSLSO_OrgasmStart(String evn, String strArg, Float numArg, Form sender)
    Actor who = sender as Actor
    if who
        lastPartnerEjacGT = Utility.GetCurrentGameTime() ; crude global tick
        ; If SLSO tells us “victim vs partner”, you can gate here. For now we just log.
        VB_Debug.Log("[SLSO] OrgasmStart: " + who)
    endif
EndEvent

Event OnSLSO_OrgasmEnd(String evn, String strArg, Float numArg, Form sender)
    Actor who = sender as Actor
    if who
        VB_Debug.Log("[SLSO] OrgasmEnd: " + who)
    endif
EndEvent

; -------- Helpers --------

Float Function GetArousalMult(Actor a)
    ; TODO: replace with real SLO call; use a neutral 0.5 for now
    Float arousal01 = 0.5
    Float w = Clamp01(S.OIOArousalWeight)
    Float mix = arousal01 * w + (1.0 - w)
    ; Keep within sane bounds
    if mix < 0.25
        mix = 0.25
    elseif mix > 2.0
        mix = 2.0
    endif
    return mix
EndFunction

Function OIO_CreateOva(Actor a, Float hours)
    VB_Debug.Log("[OIO] Adding ova to " + a + " for ~" + hours + "h")
    ; TODO: real token/overlay/parasite hookup here
EndFunction

Function OnActorOrgasm(Actor akVictim, Actor akPartner)
    if !S.OIOEnabled || akVictim == None
        ; we still allow cascades even if OIO disabled
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

    ; NEW: Climax Cascades
    MaybeStartCascade(akVictim, akPartner)
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
        ; TODO: mark fertilized state or dispatch an event
    endif
EndFunction

Bool Function IsEjaculatingNow(Actor a)
    ; Prefer SLSO event timing window if available
    if hasSLSO
        Float dtDays = Utility.GetCurrentGameTime() - lastPartnerEjacGT
        ; ~6s real time window ≈ 6 / (24*60*60) game-days
        return dtDays > 0.0 && dtDays < (6.0 / 86400.0)
    endif
    ; Without SLSO, we can’t reliably know — return False for safety
    return False
EndFunction

Function MaybeStartCascade(Actor akVictim, Actor akPartner)
    if !S.CascadeEnabled || akVictim == None
        return
    endif
    if S.CascadeGuardActive(akVictim)
        return
    endif

    Float p = VB_Math.Clamp(S.CascadeBaseChance * GetCascadeRollMult(akVictim), 0.0, 1.0)
    if !VB_Math.Roll(p)
        return
    endif

    Int maxN = VB_Math.Clamp(S.CascadeMaxCount as Float, 1.0, 10.0) as Int
    S.SetCascadeGuard(akVictim, S.CascadeCooldownSec)
    TriggerCascade(akVictim, akPartner, maxN)
EndFunction

Function TriggerCascade(Actor akVictim, Actor akPartner, Int remaining)
    if remaining <= 0 || akVictim == None
        return
    endif

    VB_Debug.Log("[Cascade] forcing extra climax, left=" + remaining + " on " + akVictim)

    ; Prefer SLSO if present, else fall back to SexLab / log only for now
    if S.HasSLSO
        ; SKSE_Events.SendModEvent("SLSO_OrgasmStart") ; TODO: pick correct API/event
        ; SKSE_Events.SendModEvent("SLSO_OrgasmEnd")
    else
        ; TODO: SexLab: advance/force orgasm stage
    endif

    ; Stagger next attempt slightly to let frameworks tick
    Utility.Wait(1.0)

    Int next = remaining - 1
    if next > 0
        ; Optional: decay chance each hop later; for now just run the count
        TriggerCascade(akVictim, akPartner, next)
    endif
EndFunction

; -------- Tiny math helpers (no external deps) --------
Float Function Clamp01(Float x)
    if x < 0.0
        return 0.0
    elseif x > 1.0
        return 1.0
    endif
    return x
EndFunction

Bool Function Roll01(Float p01)
    if p01 <= 0.0
        return False
    elseif p01 >= 1.0
        return True
    endif
    return Utility.RandomFloat(0.0, 1.0) <= p01
EndFunction
