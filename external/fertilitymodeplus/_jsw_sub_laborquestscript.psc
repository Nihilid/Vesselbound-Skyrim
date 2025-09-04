scriptName		_JSW_SUB_LaborQuestScript		extends		quest

event	OnInit()
	RegisterForSingleUpdate(5.0)
endEvent

event	OnUpdate()
	if ((GetAlias(0) as referenceAlias).GetReference() as actor == none) && GetCurrentStageID() != 0
		Reset()
		Stop()
	endIf
endEvent	