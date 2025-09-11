Scriptname _JSW_SUB_MiscUtilAlias extends ReferenceAlias  

_JSW_SUB_MiscUtilQuest		Property	FMMiscUtil		Auto			; script to calculate conception chance and stuff

_JSW_BB_Storage				Property	Storage			Auto			; Storage data helper

_JSW_SUB_GVAlias			GVAliasSC

Actor			Property		playerRef				Auto			; 

Alias			Property		GVAliasPlayerAlias		Auto			;

form[]			Property		femActor				Auto	Hidden
form[]			Property		maleActor				Auto	Hidden
form[]			Property		femWhere				Auto	Hidden
form[]			Property		maleWhere				Auto	Hidden
int[]			Property		femFlags				Auto	Hidden
int[]			Property		maleFlags				Auto	Hidden
form[]			Property		femParentLoc			Auto	Hidden
form[]			Property		maleParentLoc			Auto	Hidden

event	OnLocationChange(location oldLoc, location newLoc)

	if (Storage.TrackedActors.Length && Storage.TrackedFathers.Length)
		int index = ModEvent.Create("FMPatchIncActorUpdate")
		ModEvent.PushInt(index, 8)
		ModEvent.Send(index)
	endIf

endEvent

event	OnInit()

	if (FMMiscUtil as quest).IsRunning()
		OnPlayerLoadGame()
	endIf

endEvent

event	OnPlayerLoadGame()

	GoToState("Busy")
	if !(Storage as quest).IsRunning()
		(Storage as quest).SetCurrentStageID(10)
	endIf
	FMMiscUtil.PlayerLoadedGame()
	ClearArrays()
	GoToState("")

endEvent

bool	function	Queue(form thisActor, form thisWhere, bool female, int flags)

	if (GetState() == "Busy")
		return false
	endIf
	GoToState("Busy")
	int index
	form parentLoc
	if (thisWhere as location)
		if (GVAliasSC.HabitationLocs.Find(thisWhere) != -1)
			parentLoc = thisWhere
		else
			index = GVAliasSC.ChildLocs.Find(thisWhere)
			if index != -1
				parentLoc = GVAliasSC.HabitationLocs[index]
			endIf
		endIf
	endIF
	if female
		index			=	Math.LogicalAnd((femActor.Length + 1), 0x000000FF)
		femActor		=	Utility.ResizeFormArray(femActor, index, thisActor)
		femWhere		=	Utility.ResizeFormArray(femWhere, index, thisWhere)
		femFlags		=	Utility.resizeIntArray(femFlags, index, flags)
		femParentLoc	=	Utility.ResizeFormArray(femParentLoc, index, parentLoc)
	else
		index			=	Math.LogicalAnd((maleActor.Length + 1), 0x000000FF)
		maleActor		=	Utility.ResizeFormArray(maleActor, index, thisActor)
		maleWhere		=	Utility.ResizeFormArray(maleWhere, index, thisWhere)
		maleFlags		=	Utility.ResizeIntArray(MaleFlags, index, flags)
		maleParentLoc	=	Utility.ResizeFormArray(maleParentLoc, index, parentLoc)
	endIf
	RegisterForSingleUpdate(0.24)
	GoToState("")
	return true

endFunction

function	DumpArrays()

	int aLength	=	Math.LogicalAnd(femActor.Length, 0x000000FF)
	int index	=	0
	; index increments for FIFO
	while (index < aLength)
		Storage.TrackedActorAdd((femActor[index] as actor), (femWhere[index] as location), femFlags[index], femParentLoc[index] as location)
		index += 1
	endWhile
	aLength	=	Math.LogicalAnd(maleActor.Length, 0x000000FF)
	index	=	0
	while (index < aLength)
		Storage.TrackedFatherAdd((maleActor[index] as actor), (maleWhere[index] as location), maleFlags[index], maleParentLoc[index] as location)
		index += 1
	endWhile

endFunction

function	ClearArrays()

	femActor		=	Utility.ResizeFormArray(femActor, 0)
	maleActor		=	Utility.ResizeFormArray(maleActor, 0)
	femWhere		=	Utility.ResizeFormArray(femWhere, 0)
	maleWhere		=	Utility.ResizeFormArray(maleWhere, 0)
	femFlags		=	Utility.ResizeIntArray(femFlags, 0)
	femParentLoc	=	Utility.ResizeFormArray(femParentLoc, 0)
	maleParentLoc	=	Utility.ResizeFormArray(maleParentLoc, 0)
	maleFlags		=	Utility.ResizeIntArray(maleFlags, 0)

endFunction

event	OnUpdate()

	if (GetState() == "Busy")
		RegisterForSingleUpdate(0.10)
		return
	endIf
	GoToState("Busy")
	DumpArrays()
	ClearArrays()
	GoToState("")

endEvent

state Busy

	bool	function	Queue(form thisActor, form thisWhere, bool female, int flags)
		return false
	endFunction

	event	OnBeginState()
		if !GVAliasSC || !GVAliasSC.ImHere()
			GVAliasSC = (GVAliasPlayerAlias as referenceAlias) as _JSW_SUB_GVAlias
		endIf
	endEvent
	
endState
