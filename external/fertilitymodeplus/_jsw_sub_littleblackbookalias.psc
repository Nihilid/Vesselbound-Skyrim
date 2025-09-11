scriptName		_JSW_SUB_LittleBlackBookAlias		extends		referenceAlias  

bool			property	bUpdateDue		=	true		auto	hidden	;	Set to true by UpdateScript as needed

faction			property	HomelessChildren				auto			;	rank tracks homeless status of children

form[]			property	SpawnableKids					auto	hidden	;	same as SpawnableKids on JSW_BB_Storage - all possible kids 
																			;	that might be spawned, as defined in the formList.  ActorBase
form[]			property	KidsInHolding					auto	hidden	;	kids not yet spawned - adoptable.  Actor
form[]			property	KidsInHoldingAB					auto	hidden	;	kids not yet spawned - adoptable.  AcotorBase - for faster searches

globalVariable	property	FMAdoptableChildScale			auto			;	_SUB_FMAdoptableChildScaleStart

keyword[]		property	keywords						auto			;	0 - FMAdoptableChild	1 - FMFollowerChild
																			;	2 - FMTrackedChild

quest[]			property	theQuests						auto			;	0 - BYOHRelationshipAdoptable		1 - BYOHRelationshipAdoption
																			;	2 - BYOHRelationshipAdoptableOrphanage
																			;	3 - FM+ Main Quest					4 - FM+ GVHolder Quest

alias[]			property	myAliases						auto	hidden	;	list of child aliases (30) on this quest
form[]			property	SpawnedKids						auto	hidden	;	kids already spawned - both defined and adoptable.  Actor

form[]	kidsToAdd			;	temporary holding of spawned kids, not passed to BYOHRealtionshipAdoptableAccessor yet
int		addchecks			;	count to prevent infinitely re-trying adding kids to BYOHRelationshipAdoptableAccessor

function	GameLoaded()
	RegisterForModEvent("FMUpdateChildren", "FMDoChildUpdate")
endFunction

event	OnUpdate()

	int		index	=	0
	actor	theKid	=	none
	BYOHRelationshipAdoptableAccessor theScript = theQuests[0] as BYOHRelationshipAdoptableAccessor
	while index < kidsToAdd.Length
		theKid = kidsToAdd[index] as actor
		if theKid
			if theScript.OrphanableChildren.Find(theKid) == -1
				if theScript.AddOrphanableChild(theKid)
					if theScript.OrphanableChildren.Find(theKid) != -1
						kidsToAdd[index] = none
					endIf
					if !theKid.HasKeyword(keywords[2])
						FindFreeAlias(theKid)
					endIf
				endIf
			endIf
			theKid = none
		endIf
		index += 1
	endWhile
	if kidstoAdd.Length > 0
		kidsToAdd = RemoveEmpties(kidsToAdd)
	endIf
	if (kidsToAdd.Length > 0) && (addChecks < 10)
		; if not all were added to BYOHRelationshipAdoptableAccessor, keep trying
		RegisterForSingleUpdate(2.0)
		addChecks += 1
		return
	endIf
	;	Once all the kids have been added to BYOHRelationshipAdoptableAccessor, check their status in 1 hour
	RegisterForSingleUpdateGameTime(1.0)
	;	...and reset the counter. Zero out kidsToAdd in case we got here from too many fails
	kidsToAdd = Utility.ResizeFormArray(kidsToAdd, 0)
	addChecks = 0
endEvent

event	OnUpdateGameTime()

	; check for dead kids, or kids that have > 6 days homeless
	UpdateKidStatus()
	;	ensure adoption status is current
	UpdateAdoptionStatus()
	; re-check in "around" a day
	RegisterForSingleUpdateGameTime(Utility.RandomFloat(23.0, 25.0))
endEvent

event	FMDoChildUpdate(string aString, string bString, float aFloat, form sender)
	GoToState("Busy")
	GetMyAliases()
	UpdateAdoptionStatus()
	if bUpdateDue
		Debug.Trace("FM+: Change detected to SpawnableKids Formlist, or this is the first-time run")
		GetKidsInCell()
		SortKidArray()
		VerifyKidArrays()
		bUpdateDue = false
	endIf
	GoToState("")
	RegisterForModEvent("FMUpdateChildren", "FMDoChildUpdate")
endEvent

state Busy
	event	FMDoChildUpdate(string aString, string bString, float aFloat, form sender)
	endEvent
endState

bool	function	TrackMe(actor theKid)
{called by spawned child actors, to tell this quest to keep track of them}
	RegisterForSingleUpdate(2.0)
	if kidsToAdd.Find(theKid as form) == -1
		kidsToAdd	=	Utility.ResizeFormArray(kidsToAdd, kidsToAdd.Length + 1, theKid as form)
	endIf
	return (kidsToAdd.Find(theKid as form) != -1)
endFunction

function	UpdateAdoptionStatus()
	_JSW_SUB_ChildManagerQuest myScript = GetOwningQuest() as _JSW_SUB_ChildManagerQuest
	myScript.currAdoptions = (theQuests[1] as BYOHRelationshipAdoptionScript).numChildrenAdopted
	myScript.canAdopt = myScript.currAdoptions < myScript.maxAdoptions
endFunction

function	ImResetting(actor theKid)
{called by spawned child actors when they're resetting and returning to the holding cell}
	if theKid == none
		return
	endIf
	actorBase theAB = theKid.GetLeveledActorBase()
	int index = SpawnableKids.Find(theAB as form)
	if theAB && (index != -1)
		kidsInHolding[index] = theKid as form
		kidsInHoldingAB[index] = theAB as form
	endIf
	index = SpawnedKids.Find(theKid as form)
	if index != -1
		SpawnedKids[index] = none
	endIf
	if (theQuests[2] as BYOHRelationshipAdoptableOrphanageSC).IsHonorhallExpanded() == true
		(theQuests[0] as BYOHRelationshipAdoptableAccessor).StopTracking(theKid)
	endIf
	SpawnedKids = RemoveEmpties(SpawnedKids)
endFunction

form[] function	RemoveEmpties(form[] arrayToShrink)
{removes none entries from the passed-in form[] (actor) array and returns it}
	int		index	=	0
	form[]	tempArray	=	Utility.CreateFormArray(0)
	while index < arrayToShrink.Length
		if arrayToShrink[index] as actor
			tempArray = Utility.ResizeFormArray(tempArray, tempArray.Length + 1, (arrayToShrink[index] as actor) as form)
		endIf
		index += 1
	endWhile
	arrayToShrink = Utility.ResizeFormArray(tempArray, tempArray.Length)
	return arrayToShrink
endFunction

function	FindFreeAlias(actor theKid)
{adds a kid to a free alias on this quest}
	int	index	=	0
	while index < myAliases.Length
		if !((myAliases[index] as referenceAlias).GetReference() as actor)
			; maybe a cheese wheel is filling the alias....
			(myAliases[index] as referenceAlias).Clear()
			(myAliases[index] as referenceAlias).ForceRefTo(theKid)
			theKid.SetFactionRank(HomelessChildren, 0)
			((myAliases[index] as referenceAlias) as _JSW_SUB_SpawnedChildAliasScript).YouAreFilled(FMAdoptableChildScale.GetValue())
			return
		endIf
		index += 1
	endWhile
endFunction

function	UpdateKidStatus()
{daily check for dead or homeless tracked children}
	int index
	actor theKid
	bool	bIsDead
	while index < myAliases.Length
		theKid = (myAliases[index] as referenceAlias).GetReference() as actor
		bIsDead = !theKid || theKid.IsDead()
		if theKid && (bIsDead || theKid.IsInFaction(HomelessChildren))
			if !bIsDead && (theKid.GetNumReferenceAliases() > 1)
				theKid.RemoveFromFaction(HomelessChildren)
			else
				theKid.SetFactionRank(HomelessChildren, TheKid.GetFactionRank(HomelessChildren) + 1 + (6 * (bIsDead as int)))
			endIf
			;	homeless > 6 days, or already dead?   Bye-bye!
			if (theKid.GetFactionRank(HomelessChildren) > 4) && !theKid.Is3DLoaded()
;				(myAliases[index] as referenceAlias).Clear()
				;/	call the function on the script attached to the kid that handles cleanup	/;
				((myAliases[index] as referenceAlias) as _JSW_SUB_SpawnedChildAliasScript).ResetHeight()
				theKid.RemoveFromFaction(HomelessChildren)
				(theKid as _SUB_FM_ChildActorOrphanageScript).ResetToHoldingCell()
			endIf
		endIf
		index += 1
	endWhile
endFunction

function	GetMyAliases()
{gets the child aliases on this quest, currently 30 but may change if needed}
	RegisterForSingleUpdateGameTime(Utility.RandomFloat(0.25, 0.40))
	;/	Set up the myAliases array, somewhat involved but it ensures aliases can be added 
		in the future to a running game.  Assuming you reset the quest...		/;
	quest	myQuest	=	GetOwningQuest()
	; -1 to not grab the playerAlias
	int		anInt	=	myQuest.GetNumAliases() - 1
	if myAliases.Length != anInt
		myAliases = Utility.ResizeAliasArray(myAliases, 0)
		while myAliases.Length < anInt
			myAliases = Utility.ResizeAliasArray(myAliases, myAliases.Length + 1, myQuest.GetNthAlias(myAliases.Length + 1))
		endWhile
	endIf
	;/	an uninitialized array will also come up with length == 0, but will throw errors later.  
		This ensures it's initialized.		/;
	if kidsToAdd.Length < 1
		kidsToAdd = Utility.ResizeFormArray(kidsToAdd, 0)
	endIf
endFunction

function	GetKidsInCell()
{creates array of spawnable adoptable kids still in the holding cell}
	int index
	cell myCell = GetReference().GetParentCell()
;	debug.trace("FM+ mycell = " + mycell)
	; type 43 = kNPC
	int maxKids = myCell.GetNumRefs(43)
;	debug.trace("FM+: maxkids = " + maxkids)
	actor theKid
	KidsInHolding = Utility.CreateFormArray(0)
	while index < maxKids
		theKid = myCell.GetNthRef(index, 43) as actor
		if theKid && theKid.HasKeyword(keywords[0])
			KidsInHolding = Utility.ResizeFormArray(KidsInHolding, KidsInHolding.Length + 1, theKid as form)
;			debug.trace(KidsInHolding[KidsInHolding.Length - 1] as actor + " added to FMChildren")
		endIf
		index += 1
	endWhile
endFunction

function	SortKidArray()
{sorts the array of kids found by GetKidsInCell to match the order of the mod's formList}
	int index
	int found
	actorBase theAB
	actor theKid
	form[]	tempArray	=	Utility.ResizeFormArray(KidsInHolding, KidsInHolding.Length)
	KidsInHoldingAB = Utility.ResizeFormArray(KidsInHoldingAB, 0)
	KidsInHoldingAB = Utility.ResizeFormArray(KidsInHoldingAB, KidsInHolding.Length)
;	debug.trace("FM+: temparray.length: " + temparray.length + " kidsinholding.length: " + kidsinholding.length + " kidsinholdingAB.length: " + kidsinholdingab.length)
	while index < KidsInHolding.Length
	; 2.60
;	while index < SpawnableKids.Length
		theKid = tempArray[index] as actor
		theAB = theKid.GetLeveledActorBase()
		found = SpawnableKids.Find(theAB as form)
		if found != -1
			KidsInHolding[found] = theKid as form
			KidsInHoldingAB[found] = theAB as form
		endIf
		index += 1
	endWhile
endFunction

function	VerifyKidArrays()
{verifies that the kids found, matches the expected kids formList after sorting}
	int index
	actorBase theAB
	bool	bError
	while index < SpawnableKids.Length
		theAB = (KidsInHolding[index] as actor).GetLeveledActorBase()
		if index != SpawnableKids.Find(theAB as form)
			bError = true
			Debug.Trace("FM+ Error: SpawnableKids and KidsInHolding do not match on index: " + index)
		endIf
		index += 1
	endWhile
	if !bError
		Debug.Trace("FM+ Spawnable childen verified")
	endIf
endFunction

actor	function	SpawnAdoptableChild(actor mother, objectReference where)
{Attempt to spawn a child, taking into consideration the player's MCM preferences for race inheritence}

	actor child = SortPreferences(mother)
	if !child
		Debug.Notification("No children available!")
		return none
	endIf
	if SpawnKidHere(child, where)
		return child
	endIf
	return none
endFunction

bool	function	SpawnKidHere(actor child, objectReference whereAt)
{spawns a kid at specified objectReference}
	if child && whereAt
		if UpdateSpawnArrays(child) == none
			return false
		endIf
		child.MoveTo(whereAt)
		child.Enable()
		TrackMe(child)
		location where = whereAt.GetCurrentLocation()
		string locName
		if where
			locName = where.GetName()
			if locName
				locName = " in " + locName
			endIf
		endIf
		Debug.Notification("Your baby has grown into a child" + locName + "!")
		(child as _SUB_FM_ChildActorOrphanageScript).OnCellLoad()
		return true
	endIf
	return false
endFunction

actor	function	UpdateSpawnArrays(actor child = none, actorBase theAB = none, int index = -1)
{flags the selected kid as no longer spawnable, and returns the appropriate actor if given an actorBase or array index}
	if (child == none) && (theAB == none) && (index == -1)
		return none
	endIf
	if index != -1
		child = KidsInHolding[index] as actor
		theAB = KidsInHoldingAB[index] as actorBase
	elseIf child
		index = KidsInHolding.Find(child as form)
		if index != -1
			theAB = KidsInHoldingAB[index] as actorBase
		endIf
	else
		index = KidsInHoldingAB.Find(theAB as form)
		if index != -1
			child = KidsInHolding[index] as actor
		endIf
	endIf
	if child && theAB && (child.GetLeveledActorbase() == theAB)
		KidsInHolding[index] = none
		KidsInHoldingAB[index] = none
		index = SpawnedKids.Find(child as form)
		if index == -1
			index = SpawnedKids.Find(none)
			if index != -1
				SpawnedKids[index] = child as form
			else
				SpawnedKids = Utility.ResizeFormArray(SpawnedKids, SpawnedKids.Length + 1, child as form)
			endIf
		endIf
		return child
	endIf
	return none
endFunction

string	function	TryAdoptChildMCM(actor child)
{Debug function for spawning and adopting a child in the MCM - or by dialogue!}


	if !(GetOwningQuest() as _JSW_SUB_ChildManagerQuest).canAdopt
		; Adopted children maxed out
		return "Maximum adoptions reached"
	endIf
	; Make sure that the home status is current
	(theQuests[0] as BYOHRelationshipAdoptableScript).UpdateHouseStatus()
	; the set player's home location, will be stored on child's Variable07
	int destination = (theQuests[2] as BYOHRelationshipAdoptableOrphanageSc).OrphanageHouseLoc
	; 2.59 
	destination = (theQuests[1] as BYOHRelationshipAdoptionScript).ValidateMoveDestination(destination)
	if (destination != 0)
		DoAdopt(child, destination)
		return "Adopting, move queued!"
	else
		return "No valid available houses"
	endIf
endFunction

function	DoAdopt(actor akChild, int destination)
{sets the child destination variable, and hands them off to BYOH adoption questt}
	; The target house is stored in variable07 on the child actor and must be present before HF adoption quest is invoked
	akChild.SetActorValue("Variable07", destination as float)
	; make sure the adoption quest is running
	theQuests[1].SetCurrentStageID(10)
	; ...and adopt them
	(theQuests[1] as BYOHRelationshipAdoptionScript).AdoptChild(akChild)
	; update the adopted kid count
	UpdateAdoptionStatus()
	; remove them from the "orphans needing a bed" list, if present
	BYOHRelationshipAdoptableAccessor theScript = theQuests[0] as BYOHRelationshipAdoptableAccessor
	int index = theScript.OrphanableChildren.Find(akChild)
	if index != -1
		theScript.OrphanableChildren[index] = none
	endIf
endFunction

string function GenerateName(string msg)

	return ((GetOwningQuest() as Form) as UILIB_1).ShowTextInput(msg, "")

endFunction

function RenameChild(Actor akChild, actor akOtherParent = none)
{Renames the specified child}

; 2.33 make message gender-specific
;    string theString = "Name your child: "
    string theString = "Name your "
	int index 
	if akOtherParent
		index = (theQuests[3] as _JSW_BB_Storage).TrackedActors.Find(akOtherParent as form)
	else
		index = -1
	endIf
	if akChild.GetLeveledActorBase().GetSex()
		theString += "daughter"
	else
		theString += "son"
	endIf
	actor playerRef = Game.Getform(0x14) as actor
	; renamed via MCM, or player is mother and father is dead so we can't resolve his name, or player impregnated themselves via debug
	if (akOtherParent == none) || ((akOtherParent == playerRef) && ((theQuests[3] as _JSW_BB_Storage).LastFatherForm[index] == none))
		theString += ": "
	; player is the mother
	elseIf (akOtherParent == playerRef) && (index != -1)
		theString += " by " + ((theQuests[3] as _JSW_BB_Storage).LastFatherForm[index] as objectReference).GetDisplayName() + ": "
	;player is father
	elseIf index != -1
		theString += " by " + ((theQuests[3] as _JSW_BB_Storage).TrackedActors[index] as objectReference).GetDisplayName() + ": "
	; something eent wrong
	else
		Debug.Trace("FM+: error in RenameChild, akChild: " + akChild + " akOtherParent: " + akOtherParent, 1)
	endIf
	
; end 2.33
	theString = GenerateName(theString)
	index = ModEvent.Create("FMChildRenamed")
	if index
		ModEvent.PushForm(index, akChild as form)
		ModEvent.PushString(index, theString)
		ModEvent.Send(index)
	endIf

endFunction

actor	function	SortPreferences(actor akActor)

;/	sort the raceIndex as primary, secondary, tertiary preferences based on MCM settings.  As long as some child is available,
	one should spawn- even if all children of the preferred race have already come into being
	akActor parameter should be the birth mother		/;
	int birthRace = (theQuests[4] as _JSW_SUB_GVHolderScript).BirthRace	; (mother=0, father=1, random=2, specific=3)
	; 2.60
	int[] raceIndex = Utility.CreateIntArray(3, -1)
;	int[] raceIndex = new int[4]
	int actorIndex = (theQuests[3] as _JSW_BB_Storage).GetActorIndex(akActor)
	; 2.54
;	raceIndex[0] = FindRaceString((akActor.GetLeveledActorBase().GetRace() as form).GetName())
	raceIndex[0] = FindRaceString((akActor.GetRace() as form).GetName())
	; 2.60
	if (theQuests[3] as _JSW_BB_Storage).CurrentFatherRace[actorIndex] != none
		raceIndex[1] = FindRaceString((theQuests[3] as _JSW_BB_Storage).CurrentFatherRace[actorIndex].GetName())
	endIf
;/ 
	if (theQuests[3] as _JSW_BB_Storage).CurrentFatherRace[actorIndex] == none
		raceIndex[1] = -1
	else
		raceIndex[1] = FindRaceString((theQuests[3] as _JSW_BB_Storage).CurrentFatherRace[actorIndex].GetName())
	endIf /;
	if birthRace == 3
		raceIndex[2] = (theQuests[4] as _JSW_SUB_GVHolderScript).BirthRaceSpecific
;	else
;		raceIndex[2] = -1
	endIf
	int[] preferredRaces = Utility.CreateIntArray(3, -1)
;	preferredRaces = Utility.ResizeIntArray(preferredRaces, 3, -1)
	if birthRace == 3
	;/	birthrace specified- try the specified, then mother, finally father	/;
		preferredRaces[0] = raceIndex[2]
		preferredRaces[1] = raceIndex[0]
		preferredRaces[2] = raceIndex[1]
	elseIf birthRace == 0
	; mother- try her, then father
		preferredRaces[0] = raceIndex[0]
		preferredRaces[1] = raceIndex[1]
	elseIf birthRace == 1
	; father- try him, then mother
		preferredRaces[0] = raceIndex[1]
		preferredRaces[1] = raceIndex[0]
	endIf
	return SelectChild(preferredRaces)
endFunction

actor	function	SelectChild(int[] races)

;/	called (typically) by SortPreferences() after the player's race preferences have been determined.
	Returns a valid, spawnable adoptable child actor value if one is available		/;
	int index
	while index < 3
		if (races[index] != -1)
			if (kidsInHolding[2 * races[index]] as actor) && (kidsInHolding[2 * races[index] + 1] as actor)
				; 2.57 whoops, forgot 2 *
				return kidsInHolding[(2 * races[index]) + Utility.RandomInt(0, 1)] as actor
			elseIf kidsInHolding[2 * races[index]] as actor
				return kidsInHolding[2 * races[index]] as actor
			elseIf kidsInHolding[2 * races[index] + 1] as actor
				return kidsInHolding[2 * races[index] + 1] as actor
			endIf
		endIf
		index += 1
	endWhile
	;	no kids available matching preferences, select a random rugrat
	form[] children = Utility.CreateFormArray(0)
	index = 0
	while index < kidsInHolding.Length
		if kidsInHolding[index] as actor
			children = Utility.ResizeFormArray(children, children.Length + 1, (kidsInHolding[index] as actor) as form)
		endIf
		; fuck me... changed 2.60
;		index == 1
		index += 1
	endWhile
	if children.Length == 0
		return none
	elseIf children.Length == 1
		return children[0] as actor
	endIf
	return children[Utility.RandomInt(0, children.Length - 1)] as actor
endFunction

int	function	FindRaceString(string raceName)

;/	Matches parents' race name, with possible matching child race names. -1 means no match found		/;
	if !racename
		return -1
	endIf
	bool found = false
	int anInt = Math.LogicalAnd((theQuests[3] as _JSW_BB_Storage).ParentStrings.Length, 0x0000001F)
	while !found && (anInt > 0)
		anInt -= 1
		found = (StringUtil.Find(raceName, (theQuests[3] as _JSW_BB_Storage).ParentStrings[anInt]) != -1)
	endWhile
	if found
		return anInt
	endIf
	return -1
endFunction

