scriptName		_JSW_SUB_ScriptStarter		extends		activeMagicEffect

quest							Property	FMMainQuest			Auto	; 

; 2.25
Actor							Property	playerRef			Auto	; 
Spell							Property	ScriptRollCall		Auto	; 

string		errorPrefix		=		"FM+: Error "
; 2.09
Spell 							Property	FMUpdateSpell		Auto	; spell added to PC when Storage.UpdateRequired = true
; 2.25
Spell							Property	CompactArrays		Auto	; spell for array maintenence
; 2.11
FormList						Property	ChildrenToSpawn		Auto	; the formlist of PC's children to spawn
FormList						Property	FMBabyBirthRace		Auto	; to be copied to Storage.BabyBirthRace[]
FormList						Property	FMSupportedRaces	Auto	; the names of these forms are copied to Storage.ParentStrings[]
; 2.12
FormList						Property	FollowerChildren	Auto	; 
; 2.13
FormList						Property	NameBlackList		Auto	; importable name blacklist, to be copied to GVAlias script, 

;		---- begin 2.18 ----
FormList						Property	UniqueChildren		Auto	; 
FormList						Property	UniqueFathers		Auto	; 
FormList						Property	UniqueMothers		Auto	; 
;		---- end 2.18  ----
; 2.14
GlobalVariable					Property	GameDaysPassed		Auto	;	
GlobalVariable					Property	NextMornSick		Auto	;	
; 2.51
GlobalVariable					Property	GVFMEPresent		Auto	;	GV set by FME to indicate it's installed

; 2.51
Quest					Property	BYOHRelationshipAdoption	Auto	;	the quest by that name
Quest					Property	FMChildHandler				Auto	;	FM+ Child Handler Quest
event	OnEffectStart(Actor akTarget, Actor akCaster)

	; 2.09
	playerRef.RemoveSpell(FMUpdateSpell)
	DoRollCallOne()
	; 2.10
	UpdateFormLists()
	; ---- begin 2.51
	CountMaxAdoptions()
	SendModEvent("FMUpdateChildren")
	(FMMainQuest as _JSW_SUB_ScheduledUpdater).FMEPresent.SetValue(GVFMEPresent.GetValue())
	; ----  end 2.51
	; 2.28 re-order, moved RollCallTwo after UpdateFormLists
	DoRollCallTwo()
	; 2.14
	if GameDaysPassed.GetValue() as int > NextMornSick.GetValue() as int
		NextMornSick.SetValue((GameDaysPassed.GetValue() as int) as float + 0.02)
	endIf
	; 2.15
	ImportBlackList()
	; 2.09
	if (FMMainQuest as _JSW_BB_Storage).UpdateRequired
		playerRef.AddSpell(FMUpdateSpell, false)
	endIf
	; 2.25
	playerRef.AddSpell(CompactArrays, false)

	RegisterForSingleUpdate(0.10)

endEvent

event	OnUpdate()

	if playerRef.HasSpell(CompactArrays as form)
		RegisterForSingleUpdate(0.05)
		return
	endIf
	ModEvent.Send(ModEvent.Create("FMWidgetFactions"))
	; 2.18
	SendModEvent("FMCheckNames")
	Debug.Trace("FM+ Script Roll Call completed!")
	; 2.23
	int handle = ModEvent.Create("FertilityModeActorsUpdated")
	if handle
		ModEvent.PushBool(handle, false)
		ModEvent.Send(handle)
	endIf
	playerRef.RemoveSpell(ScriptRollCall)

endEvent

function	DoRollCallOne()

	; have other scripts Unregister for any old modevents that they may be registered for
	(FMMainQuest as _JSW_BB_Utility).UtilUnregister()
	(FMMainQuest as _JSW_SUB_ActorUpdates).AUUnregister()
	(FMMainQuest as _JSW_SUB_EventHandler).EventHandlerUnregister()
	(FMMainQuest as _JSW_SUB_MatchMaker).MatchMakerUnregister()
	(FMMainQuest as _JSW_SUB_ScheduledUpdater).ScheduledUpdaterUnregister()
	(FMMainQuest as _JSW_SUB_SpellHandler).SpellHandlerUnregister()
	;	2.51
	((FMChildHandler.GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).GameLoaded()

endFunction

function	DoRollCallTwo()

	; iterate through current scripts, verifying they're present and have them perform their startup routines
	if !(FMMainQuest as _JSW_BB_Storage).CheckPresence2()
		Debug.Messagebox(errorPrefix + "_JSW_BB_Storage script is being overwritten\n by either a loose file or another mod!\nThis patch cannot function properly!")
		Debug.Trace(errorPrefix + "_JSW_BB_Storage script error", 2)
	endIf

	if !(FMMainQuest as _JSW_BB_Utility).StartupFunction()
		Debug.Messagebox(errorPrefix + "_JSW_BB_Utility script is being overwritten\n by either a loose file or another mod!\nThis patch cannot function properly!")
		Debug.Trace(errorPrefix + "_JSW_BB_Utility script error", 2)
	endIf

	if !(FMMainQuest as _JSW_SUB_ActorUpdates).RunAtGoFunction()
		Debug.Messagebox(errorPrefix + "ActorUpdates Script is non-responsive")
		Debug.Trace(errorPrefix + "_JSW_SUB_ActorUpdates script error", 2)
	endIf

	if !(FMMainQuest as _JSW_SUB_EventHandler).FMReregisterEvents()
		Debug.Messagebox(errorPrefix + "EventHandler Script is non-responsive")
		Debug.Trace(errorPrefix + "_JSW_SUB_EbentHandler script error", 2)
	endIf

	if !(FMMainQuest as _JSW_SUB_MatchMaker).InitializeMatchMaker()
		Debug.Messagebox(errorprefix + "_JSW_SUB_MatchMaker script is non-responsive")
		Debug.Trace(errorprefix + "_JSW_SUB_MatchMaker script error: other", 2)
	endIf

	if !(FMMainQuest as _JSW_SUB_ScheduledUpdater).ScheduledUpdaterStartup()
		Debug.Messagebox(errorPrefix + "_JSW_SUB_ScheduledUpdater script is non-responsive")
		Debug.Trace(errorPrefix + "_JSW_SUB_ScheduledUpdater script error", 2)
	endIf

	if !(FMMainQuest as _JSW_SUB_SpellHandler).SpellHandlerListener()
		Debug.Messagebox(errorPrefix + "SpellHandler Script is non-responsive")
	endIf

endFunction

function	UpdateFormLists()

	_JSW_BB_Storage Storage = FMMainQuest as _JSW_BB_Storage
	Storage.Children = ChildrenToSpawn.ToArray()
	; 2.51
	((FMChildHandler.GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).SpawnableKids = ChildrenToSpawn.ToArray()
;	debug.trace("FM+: SpawnableKids.length: " + ((FMChildHandler.GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).SpawnableKids.length)
	Storage.BirthBabyRace = FMBabyBirthRace.ToArray()
		; 2.12
	Storage.AdultChildren = FollowerChildren.ToArray()
	int index = FMSupportedRaces.GetSize()
	Storage.ParentStrings = Utility.ResizeStringArray(Storage.ParentStrings, index)
	while (index > 0)
		index -= 1
		Storage.ParentStrings[index] = FMSupportedRaces.GetAt(index).GetName()
	endWhile
	; ---- begin 2.18 ----
	Storage.UniqueChildren	=	UniqueChildren.ToArray()
	Storage.UniqueFathers	=	UniqueFathers.ToArray()
	Storage.UniqueMothers	=	UniqueMothers.ToArray()
	; ----  end 2.18  ----

endFunction

function	ImportBlackList()

	_JSW_BB_Storage Storage = FMMainQuest as _JSW_BB_Storage
	if (Storage.BlacklistByName.Find("ghost") == -1)
		Storage.BlacklistByName = Utility.ResizeStringArray(Storage.BlacklistByName, Math.LogicalAnd((Storage.BlacklistByName.Length + 1), 0x00000FFF), "ghost")
		Debug.Trace("FM+ : ghost added to blacklist")
	endIf

	int importLength = NameBlackList.GetSize()
	int imports = 0
	int iterations = 0
	string theName
	while (iterations < importLength)
		theName = NameBlackList.GetAt(iterations).GetName()
		if theName && (Storage.BlackListByName.Find(theName) == -1)
			Storage.BlackListByName = Utility.ResizeStringArray(Storage.BlackListByName, Math.LogicalAnd((Storage.BlacklistByName.Length + 1), 0x00000FFF), theName)
			imports += 1
			theName = ""
		endIf
		iterations += 1
	endWhile
	if imports > 0
		Debug.MessageBox(imports + " names imported to FM+ BlackList")
	endIf

endFunction

;/	2.51	Checks the max number of children that can be adopted via the BYOHRelationshipAdoption quest and sets
	the property maxAdoptions on the storage script.   Expected values are 2 for vanilla, 6 if HMA is installed	/;
function	CountMaxAdoptions()

;/	int		maxAdopts	=	0
	int		currAlias	=	0
	int		maxAliases	=	BYOHRelationshipAdoption.GetNumAliases()
	alias	thisAlias	=	none
	while currAlias < maxAliases
		thisAlias = BYOHRelationshipAdoption.GetNThAlias(currAlias)
		if thisAlias as referenceAlias	; don't bother checking locationAliases
			maxAdopts += (StringUtil.Find(thisAlias.GetName(), "child") != -1) as int
		endIf
		thisAlias = none
		currAlias += 1
	endWhile
	(FMMainQuest as _JSW_BB_Storage).maxAdoptions = maxAdopts
	(FMChildHandler as _JSW_SUB_ChildManagerQuest).maxAdoptions = maxAdopts/;
	
	Alias[]	myAliases	=	BYOHRelationshipAdoption.GetAliases()
	int		maxAdopts	=	0
	int		currAlias	=	0
	while currAlias < myAliases.Length
		if myAliases[currAlias] as referenceAlias
			maxAdopts += (StringUtil.Find(myAliases[currAlias].GetName(), "child") != -1) as int
		endIf
		currAlias += 1
	endWhile
	(FMMainQuest as _JSW_BB_Storage).maxAdoptions = maxAdopts
	(FMChildHandler as _JSW_SUB_ChildManagerQuest).maxAdoptions = maxAdopts
			
endFunction
