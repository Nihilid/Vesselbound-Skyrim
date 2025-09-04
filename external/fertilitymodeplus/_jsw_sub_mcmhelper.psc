Scriptname _JSW_SUB_MCMHelper extends Quest

_JSW_SUB_GVAlias		Property	GVAlias			Auto	; 
_JSW_BB_Utility			Property	Util			Auto	; Independent helper functions
_JSW_BB_Storage			Property	Storage			Auto	; Storage data helper
_JSW_SUB_MiscUtilQuest	Property	FMMiscUtil		Auto	; script to calculate conception chance and stuff

Actor 			Property 	PlayerRef  				Auto	; Reference to the player. Game.GetPlayer() is slow

Faction			Property	CycleBuffFaction	 	Auto	; 10% buff/debuff

Keyword			Property	FertilityKeyword		Auto	; keyword for fertility altering effects

MagicEffect		Property	EffectContraception		Auto	; Magic effect for decreased fertility
MagicEffect		Property	EffectFertility			Auto	; Magic effect for increased fertility
;2.29
Quest			Property	GVAliasQ				Auto	;

int[]			Property	returnList				Auto	; the list of filtered actors 
int		lastFilterType = 42
int		STALength

function ReallyCountActors(int filterType)
;	return returnList
endFunction

function UpdateTheFactions(int percent)
endFunction

event OnUpdate()

	; 2.29
	if !GVAlias || (GVAlias.playerRef != playerRef)
		GVAlias = (GVAliasQ.GetAlias(1) as referenceAlias) as _JSW_SUB_GVAlias
	endIf
	UnregisterforUpdate()
	returnList = Utility.ResizeIntArray(returnList, 0)
	lastFilterType = 42
	
endEvent

function UpdateFactions(int percent)

	GoToState("UpdateBuffFactions")
	UpdateTheFactions(percent)

endFunction

; 1.64
string function GenerateFirstString(int actorIndex, string preString, int someDay, string postString)

; 2.32 goodbye old defunct array
;	return (prestring + someDay + "]" + postString + (Storage.TrackedActors[actorIndex] as objectReference).GetDisplayName() + "(" + Storage.LastMotherLocation[actorIndex] + ")")
	form theLoc = Storage.ActorLocation[actorIndex]
	string LocName
	if theLoc
		LocName = theLoc.GetName()
	else
		LocName = "Skyrim"
	endIf
	return (prestring + someDay + ":" + postString + (Storage.TrackedActors[actorIndex] as objectReference).GetDisplayName() + "(" + LocName + ")")

endFunction

function CountFilteredActors(int filterType, bool forceIt = false)
{returns how many tracked actors based on the filter}

	UnregisterforUpdate()
	if (filterType == 12)	; males
		STALength = Math.LogicalAnd(Storage.TrackedFathers.Length, 0x00000FFF)
	else
		STALength = Math.LogicalAnd(Storage.TrackedActors.Length, 0x00000FFF)
	endIf
	if (STALength < 1)
		OnUpdate()
		return
	endIf
	if !forceIt && ((lastFilterType == filterType) && (returnList.Length > 0))
		RegisterForSingleUpdate(30.0)
		return
	endIf
	UnregisterforUpdate()
	GoToState("Filter" + filterType)
	lastFilterType = filterType
	ReallyCountActors(filterType)
	RegisterForSingleUpdate(30.0)

endFunction

State Filter0	;	All (unfiltered)

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		int index = 0
		while (index < STALength)
			if (Storage.TrackedActors[index] as actor)
				returnList[filterType] = index
				filterType += 1
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

State Filter1	;	All Unique

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		int index = 0
		filterType = 0
		while (index < STALength)
			if (Storage.TrackedActors[index] as actor)
				; 2.25
;				if (Storage.TrackedActors[index] as actor).GetLeveledActorBase().IsUnique()
				if (Storage.ATFlags[index] != -1)
					returnList[filterType] = index
					filterType += 1
				endIf
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

State Filter2	;	Ovulating

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		int index = 0
		filterType = 0
		while (index < STALength)
			if (Storage.TrackedActors[index] as actor) && (Storage.LastOvulation[index] != 0.0)
				returnList[filterType] = index
				filterType += 1
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

State Filter3	;	Pregnant

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		int index = 0
		filterType = 0
		while (index < STALength)
			if (Storage.TrackedActors[index] as actor) && (Storage.LastConception[index] != 0.0)
				returnList[filterType] = index
				filterType += 1
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

State Filter4	;	Not Pregnant

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		int index = 0
		filterType = 0
		while (index < STALength)
			if (Storage.TrackedActors[index] as actor) && (Storage.LastConception[index] == 0.0)
				returnList[filterType] = index
				filterType += 1
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

State Filter5	;	player-related

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		form playerRefForm = playerRef as form
		int index = 0
		filterType = 0
		while (index < STALength)
			; 2.26
;			if (Storage.TrackedActors[index] as actor) && (Storage.CurrentFatherForm[index] == playerRefForm)
			if (Storage.TrackedActors[index] as actor) && ((Storage.CurrentFatherForm[index] == playerRefForm) || (Storage.LastFatherForm[index] == playerRefForm))
				returnList[filterType] = index
				filterType += 1
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

State	Filter6	;	Promiscuous Only

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		int index = 0
		filterType = 0
		while (index < STALength)
			if (Storage.TrackedActors[index] as actor) && (Storage.FemPromiscuity[index] == 2)
				returnList[filterType] = index
				filterType += 1
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

State Filter12	;	males

	function ReallyCountActors(int filterType)

		returnList = Utility.ResizeIntArray(returnList, STALength)
		int index = 0
		filterType = 0
		while (index < STALength)
			if (Storage.TrackedFathers[index] as actor)
				returnList[filterType] = index
				filterType += 1
			endIf
			index += 1
		endWhile
		GoToState("")
		returnList = Utility.ResizeIntArray(returnList, filterType)

	endFunction

endState

state UpdateBuffFactions

	function UpdateTheFactions(int percent)
	{applies correct faction to character based on slider setting}

		GoToState("")
		PlayerRef.SetFactionRank(CycleBuffFaction, percent)
		FMMiscUtil.UpdateCyclePerks(Util.GetActorGender(playerRef) == 1)
		; 1.58 make updatecontent not gender conditional
		if GVAlias.GVHolder.Enabled
			ModEvent.Send(ModEvent.Create("FMPUpdateWidgetContent"))
			ModEvent.Send(ModEvent.Create("FMPPlayerFactStat"))
		endIf
	endFunction

endState

string	function	GetThatString(string formToGet)

	if formToGet == ""
		return ""
	endIf
	int formID = 0
	int iterations = 0
		;/	you *have to* count up from zero in interations otherwise it will scramble the FormID sequence	/;
	while (iterations < 3)
		; the first ShiftLeft is useless, but it is needed for subsequent ones to prevent mangling the FormID
		formID = Math.LeftShift(formID, 4)
		int tempInt = StringUtil.AsOrd(StringUtil.GetNthChar(formToGet, iterations))
		;	letters will return AsOrd value = (Hex Value + 55)
		if tempInt > 63
			tempInt -= 55
		else
			; numerals return AsOrd value = (Hex Value + 48)
			tempInt -= 48
		endIf
		formID = Math.LogicalOR(formID, tempInt)
		iterations += 1
	endWhile
	;/	GetMeMyForm() is custom, similar to GetFormFromFile in parameters, but has error-checking for out-of-bounds
		FormIDs in ESL plugins.  Requires SKSE	/;
	if !((Math.LogicalAnd(0xFFFFF000, formID) != 0) || (Math.LogicalAnd(0x00000800, formID) == 0))
		; 2.31 
		form theForm = Game.GetFormEx(Math.LogicalOR(Storage.myLoadIndex, formID))
;		form theForm = GVAlias.GVHolder.GetMeMyForm(formID, "Fertility Mode 3 Fixes and Updates.esp")
		if theForm
			return theForm.GetName()
		else
			Debug.Trace("FM+ : Erroneous FormID " + formId + " attempted by MCM script.  State: " + formToGet)
		endIf
	endIf
	return ""

endFunction

function	PlayerOnlyClear()

   	; Clear tracking lists of all actors not "related" to the player
;/	int index = Storage.TrackedActors.Find(playerRef as form)
	if (index > 0)
		Storage.TrackedActors[0]				=	Storage.TrackedActors[index]
;		Storage.LastMotherLocation[0]			=	Storage.LastMotherLocation[index]
		Storage.CurrentFatherForm[0]			=	Storage.CurrentFatherForm[index]
		Storage.LastFatherForm[0]				=	Storage.LastFatherForm[index]
		Storage.LastGameHours[0]				=	Storage.LastGameHours[index]
		Storage.LastInsemination[0]				=	Storage.LastInsemination[index]
		Storage.LastOvulation[0]				=	Storage.LastOvulation[index]
		Storage.LastConception[0]				=	Storage.LastConception[index]
		Storage.LastBirth[0]					=	Storage.LastBirth[index]
		Storage.SpermCount[0]					=	Storage.SpermCount[index]
		Storage.BabyAdded[0]					=	Storage.BabyAdded[index]
;		Storage.EventLock[0]					=	Storage.EventLock[index]
		Storage.DayOfCycle[0]					=	Storage.DayOfCycle[index]
		Storage.TimesDelivered[0]				=	Storage.TimesDelivered[index]
		Storage.OvulationBlock[0]				=	Storage.OvulationBlock[index]
		Storage.FemHasLoveInterest[0]			=	Storage.FemHasLoveInterest[index]
		Storage.FemAttached[0]					=	Storage.FemAttached[index]
		Storage.ActorLocation[0]				=	Storage.ActorLocation[index]
		Storage.Fidelity[0]						=	Storage.Fidelity[index]
		Storage.CurrentFatherRace[0]			=	Storage.CurrentFatherRace[index]
		Storage.ATFlags[0]						=	Storage.ATFlags[index]
		Storage.ActorLocParent[0]				=	Storage.ActorLocParent[index]
		; 2.28
		Storage.FemPromiscuity[0]				=	Storage.FemPRomiscuity[index]
	endIf/;
	int index = Math.LogicalAnd(Storage.TrackedActors.Length, 0x00000FFF)
	; Remove all women who are not the player or sexually related to the player
	while (index > 0)
		index -= 1
		if (Storage.TrackedActors[index] != none) && (Storage.TrackedActors[index] != playerRef as form) && \
		(Storage.CurrentFatherForm[index] != playerRef as form) && (Storage.LastFatherForm[index] != playerRef as form)
			Storage.TrackedActorRemove(index)
		endIf
	endWhile
;/	index = (Storage.TrackedActors.Find(playerRef as form) != -1) as int
	if index == 0
		Storage.TrackedActorRemove(0)
	endIf
	Storage.TrackedActors			=	Utility.ResizeFormArray(Storage.TrackedActors, index)
;	Storage.LastMotherLocation		=	Utility.ResizeStringArray(Storage.LastMotherLocation, index)
	Storage.CurrentFatherForm		=	Utility.ResizeFormArray(Storage.CurrentFatherForm, index)
	Storage.LastFatherForm			=	Utility.ResizeFormArray(Storage.LastFatherForm, index)
	Storage.LastGameHours			=	Utility.ResizeFloatArray(Storage.LastGameHours, index)
	Storage.LastInsemination		=	Utility.ResizeFloatArray(Storage.LastInsemination, index)
	Storage.LastOvulation			=	Utility.ResizeFloatArray(Storage.LastOvulation, index)
	Storage.LastConception			=	Utility.ResizeFloatArray(Storage.LastConception, index)
	Storage.LastBirth				=	Utility.ResizeFloatArray(Storage.LastBirth, index)
	Storage.SpermCount				=	Utility.ResizeIntArray(Storage.SpermCount, index)
	Storage.BabyAdded				=	Utility.ResizeFloatArray(Storage.BabyAdded, index)
;	Storage.EventLock				=	Utility.ResizeIntArray(Storage.EventLock, index)
	Storage.DayOfCycle				=	Utility.ResizeIntArray(Storage.DayOfCycle, index, 1)
	Storage.TimesDelivered			=	Utility.ResizeIntArray(Storage.TimesDelivered, index)
	Storage.OvulationBlock			=	Utility.ResizeIntArray(Storage.OvulationBlock, index)
	Storage.FemHasLoveInterest		=	Utility.ResizeFormArray(Storage.FemHasLoveInterest, index)
	Storage.FemAttached				=	Utility.ResizeIntArray(Storage.FemAttached, index)
	Storage.ActorLocation			=	Utility.ResizeFormArray(Storage.ActorLocation, index)
	Storage.Fidelity				=	Utility.ResizeIntArray(Storage.Fidelity, index)
	Storage.CurrentFatherRace		=	Utility.ResizeFormArray(Storage.CurrentFatherRace, index)
	Storage.ATFlags					=	Utility.ResizeIntArray(Storage.ATFlags, index)
	Storage.ActorLocParent			=	Utility.ResizeFormArray(Storage.ActorLocParent, index)
	; 2.28
	Storage.FemPromiscuity			=	Utility.ResizeIntArray(Storage.FemPromiscuity, index)/;

endFunction
