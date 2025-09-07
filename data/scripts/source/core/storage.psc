; ==============================
; Vesselbound — Core: Storage
; File: source/core/storage.psc
; Notes: Quest-backed persistent storage for Vesselbound.
; Holds capability flags, settings, and scene state.
; ==============================

Scriptname VB_Storage Extends Quest
Bool Property HasFISS Auto
Bool Property HasMCMHelper Auto
Bool Property HasSUM Auto


VB_Debug.Log("Storage init — Capabilities:" )
VB_Debug.Log(" SLO=" + HasSLO + " SLSO=" + HasSLSO + " SLATE=" + HasSLATE)
VB_Debug.Log(" ODF=" + HasODF + " FISS=" + HasFISS + " MCMH=" + HasMCMHelper)
VB_Debug.Log(" SUM=" + HasSUM + " Parasites=" + HasParasites)


if OIOBaseChance <= 0.0
OIOEnabled = True
OIOBaseChance = 0.15
OIODurationHours = 24.0
OIOInstantFertEnabled = True
OIORequireWombPenetration = False
OIOArousalWeight = 0.50
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
wombKeys = VB_ArrayUtil.PushString(wombKeys, key)
wombTTL = VB_ArrayUtil.PushFloat(wombTTL, expiry)
else
wombTTL[idx] = expiry
endif
VB_Debug.Log("WombAccess set for " + akVictim + " for " + hours + "h")
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
if wombKeys == None
return -1
endif
Int i = 0
while i < wombKeys.Length
if wombKeys[i] == key
return i
endif
i += 1
endwhile
return -1
EndFunction