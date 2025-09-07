; ===== source/core/storage.psc =====
; Persistent quest-backed storage. Arrays/Maps live on the quest instance to save in co-save.
ScriptName VB_Storage Extends Quest


; === Capability flags (populated at OnInit) ===
Bool Property HasSLO Auto ; SexLab Aroused NG (SexLabAroused.esm)
Bool Property HasSLSO Auto ; SexLab Separate Orgasms (SLSO.esp)
Bool Property HasSLATE Auto ; SLATE.esp
Bool Property HasODF Auto ; OverlayDistributionFramework.esp
Bool Property HasFISS Auto ; FISS.esp
Bool Property HasMCMHelper Auto ; MCMHelper.esp
Bool Property HasSUM Auto ; Skyrim - Utility Mod.esm
Bool Property HasParasites Auto ; SexLab-Parasites.esp


; === Settings snapshot (subset; MCM writes these) ===
Bool Property OIOEnabled Auto
Float Property OIOBaseChance Auto
Float Property OIODurationHours Auto
Bool Property OIOInstantFertEnabled Auto
Bool Property OIORequireWombPenetration Auto
Float Property OIOArousalWeight Auto ; 0..1 influence from SLO


Float Property WombSizeThreshold Auto
Float Property WombAccessBaseChance Auto
Float Property WombAccessRetryBonus Auto
Float Property WombAccessPleasureMult Auto


Float Property ParasitePleasureGainRate Auto
Float Property ParasiteResistInterval Auto
Float Property ParasiteResistDifficulty Auto
Float Property ParasiteResistSuccessReduction Auto
Bool Property ParasiteOrgasmTriggersOIO Auto


; === Scene-scoped ephemeral flags ===
; Map-like storage via parallel arrays (Papyrus limitation); key by Actor formID string
String[] wombKeys
Float[] wombTTL


Event OnInit()
; Detect capabilities by plugin presence (safe, cheap)
HasSLO = (Game.GetFormFromFile(0x000800, "SexLabAroused.esm") != None)
HasSLSO = (Game.GetFormFromFile(0x000800, "SLSO.esp") != None)
HasSLATE = (Game.GetFormFromFile(0x000800, "SLATE.esp") != None)
EndFunction