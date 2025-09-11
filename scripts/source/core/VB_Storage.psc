Scriptname VB_Storage Extends Quest

; Capability flags
Bool Property HasSLO Auto
Bool Property HasSLSO Auto
Bool Property HasSLATE Auto
Bool Property HasODF Auto
Bool Property HasFISS Auto
Bool Property HasMCMHelper Auto
Bool Property HasSUM Auto
Bool Property HasParasites Auto

; Settings snapshot
Bool  Property OIOEnabled Auto
Float Property OIOBaseChance Auto
Float Property OIODurationHours Auto
Bool  Property OIOInstantFertEnabled Auto
Bool  Property OIORequireWombPenetration Auto
Float Property OIOArousalWeight Auto

Float Property WombSizeThreshold Auto
Float Property WombAccessBaseChance Auto
Float Property WombAccessRetryBonus Auto
Float Property WombAccessPleasureMult Auto

Float Property ParasitePleasureGainRate Auto
Float Property ParasiteResistInterval Auto
Float Property ParasiteResistDifficulty Auto
Float Property ParasiteResistSuccessReduction Auto
Bool  Property ParasiteOrgasmTriggersOIO Auto

; Scene-scoped fixed-capacity arrays (literal sizes to satisfy strict compilers)
String[] wombKeys
Float[]  wombTTL

; Capacity constants (adjust and recompile if you ever need more)
; NOTE: must be literals where used with 'new'
Int Property WombMaxSlots Auto

Event OnInit()
    ; --- capability detection ---
    HasSLO        = (Game.GetFormFromFile(0x000800, "SexLabAroused.esm") != None)
    HasSLSO       = (Game.GetFormFromFile(0x000800, "SLSO.esp") != None)
    HasSLATE      = (Game.GetFormFromFile(0x000800, "SLATE.esp") != None)
    HasODF        = (Game.GetFormFromFile(0x000800, "OverlayDistributionFramework.esp") != None)
    HasFISS       = (Game.GetFormFromFile(0x000800, "FISS.esp") != None)
    HasMCMHelper  = (Game.GetFormFromFile(0x000800, "MCMHelper.esp") != None)
    HasSUM        = (Game.GetFormFromFile(0x000800, "Skyrim - Utility Mod.esm") != None)
    HasParasites  = (Game.GetFormFromFile(0x000800, "SexLab-Parasites.esp") != None)

    VB_Debug.Log("Storage init — Capabilities:")
    VB_Debug.Log("  SLO=" + HasSLO + " SLSO=" + HasSLSO + " SLATE=" + HasSLATE)
    VB_Debug.Log("  ODF=" + HasODF + " FISS=" + HasFISS + " MCMH=" + HasMCMHelper)
    VB_Debug.Log("  SUM=" + HasSUM + " Parasites=" + HasParasites)

    ; defaults
    if OIOBaseChance <= 0.0
        OIOEnabled = True
        OIOBaseChance = 0.15
        OIODurationHours = 24.0
        OIOInstantFertEnabled = True
        OIORequireWombPenetration = False
        OIOArousalWeight = 0.50
    endif

    ; fixed allocations — use literal sizes to avoid compiler restrictions
    if wombKeys == None
        wombKeys = new String[64] ; <— increase and recompile if needed
    endif
    if wombTTL == None
        wombTTL = new Float[64]  ; <— must match wombKeys length
    endif
EndEvent

Function SetWombAccessWindow(Actor akVictim, Float hours)
    if akVictim == None
        return
    endif
    String key = akVictim.GetFormID() as String
    Float expiry = Utility.GetCurrentGameTime() + (hours / 24.0)

    Int idx = FindKeyIndex(key)
    if idx < 0
        idx = FindFreeIndex()
        if idx < 0
            VB_Debug.Warn("[WombAccess] No free slot; increase array size in storage.psc and recompile.")
            return
        endif
        wombKeys[idx] = key
    endif
    wombTTL[idx] = expiry
    VB_Debug.Log("WombAccess set for " + akVictim + " for " + hours + "h (slot " + idx + ")")
EndFunction

Bool Function HasWombAccess(Actor akVictim)
    if akVictim == None
        return False
    endif
    String key = akVictim.GetFormID() as String
    Int idx = FindKeyIndex(key)
    if idx < 0
        return False
    endif
    return wombTTL[idx] > Utility.GetCurrentGameTime()
EndFunction

Int Function FindKeyIndex(String key)
    if key == "" || wombKeys == None
        return -1
    endif
    Int i = 0
    Int n = wombKeys.Length
    while i < n
        if wombKeys[i] == key
            return i
        endif
        i += 1
    endwhile
    return -1
EndFunction

Int Function FindFreeIndex()
    if wombKeys == None
        return -1
    endif
    Int i = 0
    Int n = wombKeys.Length
    Float now = Utility.GetCurrentGameTime()
    while i < n
        if wombKeys[i] == "" || wombTTL[i] <= now
            return i
        endif
        i += 1
    endwhile
    return -1
EndFunction
