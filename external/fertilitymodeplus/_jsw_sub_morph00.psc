ScriptName		_JSW_SUB_Morph00		Extends		ActiveMagicEffect

GlobalVariable		Property		GVBellyScMult		Auto	;	
GlobalVariable		Property		GVBreastScMult		Auto	;	
GlobalVariable		Property		GVScaleStart		Auto	;	

Faction				Property		GenericFaction		Auto	; 

actor		thisActor

event	OnEffectStart(actor akTarget, actor akCaster)
	thisActor	=	akTarget
	GoToState("Morphed")
	UpdateMorph(sender = none)
endEvent

event	UpdateMorph(string a = " ", string b = " ", float ScaleStart = 0.0, form sender)
endEvent

event	OnEffectFinish(actor akTarget, actor akCaster)
endEvent

state Morphed
	event	OnEffectFinish(actor akTarget, actor akCaster)
		GoToState("")
		NiOverride.ClearBodyMorph(akTarget, "PregnancyBelly", "Fertility Mode")
		NiOverride.ClearBodyMorph(akTarget, "BreastsSH", "Fertility Mode")
		NiOverride.ClearBodyMorph(akTarget, "BreastsNewSH", "Fertility Mode")
		NiOverride.UpdateModelWeight(akTarget)
	endEvent

	event	OnCellDetach()
		OnEffectFinish(thisActor, none)
	endEvent

	event	UpdateMorph(string a = " ", string b = " ", float ScaleStart = 0.0, form sender)
		float factionRank = thisActor.GetFactionRank(GenericFaction) as float
		ScaleStart = GVScaleStart.GetValue() - 1.0
		float breastScale = GVBreastScMult.GetValue()
		float percent
		if factionRank > -1.0
			percent = (factionRank - ScaleStart) / (100.0 - ScaleStart)
			if percent > 1.0
				percent = 1.0
			elseIf percent < 0.0
				GoToState("")
				return
			endIf
			percent *= GVBellyScMult.GetValue()
			breastScale *= percent
		else
			percent = ((110.0 + factionRank) / 100.0)
			if percent < 0.0
				percent = 0.0
			endIf
		endIf
		; BodyMorph
		NiOverride.SetBodyMorph(thisActor, "PregnancyBelly", "Fertility Mode", percent)
		NiOverride.SetBodyMorph(thisActor, "BreastsSH", "Fertility Mode", breastScale)
		NiOverride.SetBodyMorph(thisActor, "BreastsNewSH", "Fertility Mode", breastScale)
		NiOverride.UpdateModelWeight(thisActor)
		RegisterForModEvent("FMPlusDoMorph", "UpdateMorph")
	endEvent
endState
