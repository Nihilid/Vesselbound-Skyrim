scriptName		_JSW_SUB_SpawnedChildAliasScript		extends		referenceAlias

float	myInitialHeight
float	myCurrentHeight

function	YouAreFilled(float heightMult = 0.85)
	actor mySelf = GetReference() as actor
	myInitialHeight = mySelf.GetLeveledActorBase().GetHeight()
	myCurrentHeight = myInitialHeight * heightMult
	myCurrentHeight = (((myCurrentHeight * 100.0) as int) as float) / 100.0
	mySelf.GetLeveledActorBase().SetHeight(myCurrentHeight)
	mySelf.QueueNINodeUpdate()
	RegisterForSingleUpdateGameTime(72.0)
endFunction

function	ResetHeight()
	myCurrentHeight = myInitialHeight
	OnCellLoad()
	UnregisterForUpdateGameTime()
endFunction

event	OnUpdateGameTime()
	if myCurrentHeight > myInitialHeight
		return
	endIf
	myCurrentHeight += 0.01
	OnCellLoad()
	RegisterForSingleUpdateGameTime(72.0)
endEvent

event	OnCellLoad()
	(GetReference() as actor).GetLeveledActorBase().SetHeight(myCurrentHeight)
endEvent
