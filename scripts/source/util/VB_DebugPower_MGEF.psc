Scriptname VB_DebugPower_MGEF Extends ActiveMagicEffect

VB_Storage Property S Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
    if S == None
        Debug.Trace("[Vesselbound][DEBUG] Storage not bound")
        return
    endif

    Debug.Trace("[Vesselbound][DEBUG] ---- Snapshot ----")
    Debug.Trace("[Vesselbound][DEBUG] Caps: SLO=" + S.HasSLO + " SLSO=" + S.HasSLSO + " SLATE=" + S.HasSLATE + " ODF=" + S.HasODF + " FISS=" + S.HasFISS + " MCMH=" + S.HasMCMHelper + " SUM=" + S.HasSUM + " Parasites=" + S.HasParasites)
    Debug.Trace("[Vesselbound][DEBUG] OIO: enabled=" + S.OIOEnabled + " baseChance=" + S.OIOBaseChance + " durH=" + S.OIODurationHours + " instant=" + S.OIOInstantFertEnabled + " reqWomb=" + S.OIORequireWombPenetration + " arousalW=" + S.OIOArousalWeight)
    Debug.Trace("[Vesselbound][DEBUG] Womb: sizeThr=" + S.WombSizeThreshold + " base=" + S.WombAccessBaseChance + " retry=" + S.WombAccessRetryBonus + " pleasureMult=" + S.WombAccessPleasureMult)
    Debug.Trace("[Vesselbound][DEBUG] Parasites: gainRate=" + S.ParasitePleasureGainRate + " resistInt=" + S.ParasiteResistInterval + " diff=" + S.ParasiteResistDifficulty + " successCut=" + S.ParasiteResistSuccessReduction + " OIOonOrg=" + S.ParasiteOrgasmTriggersOIO)
    Debug.Trace("[Vesselbound][DEBUG] ---- /Snapshot ----")
EndEvent
