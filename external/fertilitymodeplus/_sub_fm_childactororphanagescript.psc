scriptName		_SUB_FM_ChildActorOrphanageScript		extends		actor

form[]	property	myForms		auto	;	0 - _JSW_SUB_TrackedChild keyword
										;	1 - _JSW_SUB_ChildManager quest
										;	2 - BYOHRelationshipAdoptable

event	OnUpdate()
	if HasKeyword(myForms[0] as keyword)
		return
	endIf
	(((myForms[1] as quest).GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).TrackMe(self as actor)
	; LittleBlackBookAlias fills aliases, which adds the faction, after 2 seconds of no new requests
	RegisterForSingleUpdate(12.0)
	RegisterForSingleUpdateGameTime(8.0)
endEvent
event	OnUpdateGameTime()
	if HasKeyword(myForms[0] as keyword)
		return
	endIf
	if !Is3Dloaded()
		ResetToHoldingCell()
		return
	endIf
	RegisterForSingleUpdateGameTime(1.0)
endEvent

event	OnCellLoad()
	if !HasKeyword(myForms[0] as keyword)
		RegisterForSingleUpdate(1.0)
	endIf
endEvent

function	ResetToHoldingCell()
	UnRegisterForUpdate()
	UnRegisterForUpdateGameTime()
	(((myForms[1] as quest).GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).ImResetting(self as actor)
	MoveToMyEditorLocation()
	referenceAlias[] myAliases = GetReferenceAliases()
	int index = 0
	while index < myAliases.Length
		myaliases[index].Clear()
		index += 1
	endWhile
	RemoveFromAllFactions()
	Reset()
;	Disable()
endFunction

event	OnReset()
	MoveToMyEditorLocation()
	Disable()
endEvent
	