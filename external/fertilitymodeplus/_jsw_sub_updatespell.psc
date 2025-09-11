Scriptname		_JSW_SUB_UpdateSpell		Extends		ActiveMagicEffect

_JSW_BB_Storage					Property	Storage				Auto	; Storage data helper
_JSW_SUB_ScheduledUpdater		Property	SchedUpdatr			Auto	; Scheduled Updater script for RNG array

Spell 							Property	FMUpdateSpell		Auto	; the spell that applies this ME

; the next will vary based on exactly what needs to be updated

;		---- begin 2.09 ----
;Quest			Property		FGQuest				Auto
;Quest			Property		MiscUtilQ			Auto
;Quest			Property		UpdHlpQ				Auto
;Quest			Property		AdoptQ				Auto
;		----  end 2.09  ----
;		---- begin 2.11 ----
FormList		Property		ActorBlackFormList	Auto	; formlist copied to form[] on storage script NEVER STOP!
;		----  end 2.11  ----
;		---- begin 2.21 ----
Faction			Property		TrackedMaleFaction	Auto	; faction for tracked males
;		----  end 2.21  ----
;		---- begin 2.24 ----
Formlist		Property		ExcludeAT			Auto	; associations used for eliminating random inseminators
;		----  end 2.24  ----
;		---- begin 2.50 ----
Quest			Property	RhiadaQuest		Auto			; on-demand quest that makes Rhiada temporarality persistent while I need her to be
;		----  end 2.50  ----
;		---- begin 2.51 ----
faction		property	BYOHRelationshipAdoptableFACT		Auto	; faction by that name
Keyword		Property	FMSpawnedChild						Auto	;	_jsw_bb_spawnedChild
Quest		Property	BYOHRelationshipAdoption			Auto	;	HF quest by that name
Quest		Property	BYOHRelationshipAdoptableOrphanage	Auto	;	HF quest by that name. HF Quest names suck.
Quest		Property	FMChildManager						Auto	;	FM Child Manager Quest
;		----  end 2.51  ----

event	OnEffectStart(Actor akTarget, Actor akCaster)

	; ----   Common   ----
	int index = 1024
	if (SchedUpdatr.RandomIntArray.Length != 1024)
		SchedUpdatr.RandomIntArray = Utility.ResizeIntArray(SchedUpdatr.RandomIntArray, 1024, -1)
;		int index = 1024
		while (index > 0)
			index -= 1
			SchedUpdatr.RandomIntArray[index] = Utility.RandomInt(0, 99)
		endWhile
		Debug.Trace("FM+ Info: Random Int Array Initialized", 0)
	endIf
	index = 6
	while (index > 0)
		index -= 1
;/		Storage.LaborAliases[index].GetOwningQuest().Reset()
		Storage.LaborAliases[index].GetOwningQuest().Stop()/;
		if Storage.LaborAliases[index].GetOwningQuest().IsRunning() && !((Storage.LaborAliases[index] as referenceAlias).GetReference() as actor)
			(Storage.LaborAliases[index].GetOwningQuest() as _JSW_SUB_LaborQuestScript).OnInit()
		endIf
	endWhile
	; ---- end Common ----
	int currMinorVer = Storage.FMValues[10]
	if Storage.FMValues[9] == 2
		; ---- begin 2.09 ----
;/		if currMinorVer < 9
			MiscUtilQ.Reset()
			MiscUtilQ.Stop()
			MiscUtilQ.SetCurrentStageID(10)
			UpdHlpQ.Reset()
			UpdHlpQ.Stop()
			AdoptQ.Reset()
			AdoptQ.Stop()
			FGQuest.Reset()
			if FGQuest.IsRunning()
				FGQuest.Stop()
				FGQuest.SetCurrentStageID(10)
			endIf
		endIf/;
		; ----  end 2.09  ----
		; ---- begin 2.10 ----
		if currMinorVer < 9
			Storage.Fidelity	=	Utility.ResizeIntArray(Storage.Fidelity, Math.LogicalAnd(Storage.TrackedActors.Length, 0x00000FFF))
		endIf
		; ----  end 2.10  ----
		; ---- begin 2.11 ----
		if currMinorVer < 11
			if !Storage.FormListToForm
				Storage.ActorBlackList = ActorBlackFormList.ToArray()
				Storage.FormListToForm = true
				debug.trace("FM+ info: ActorBlackList = " + Storage.ActorBlackList.Length)
			endIf
;/		if (Storage.BlacklistByName.Find("ghost") == -1)
			Storage.BlacklistByName = Utility.ResizeStringArray(Storage.BlacklistByName, Math.LogicalAnd((Storage.BlacklistByName.Length + 1), 0x00000FFF), "ghost")
			Debug.Trace("FM+ : ghost added to blacklist")
		endIf/;
			if Storage.PlayerChildRace.Length < Storage.PlayerChildName.Length
				Storage.PlayerChildRace = Utility.ResizeFormArray(Storage.PlayerChildRace, Math.LogicalAnd(Storage.PlayerChildName.Length, 0x00000FFF))
			endIf
			if Storage.LastFatherForm.Length < Storage.TrackedActors.Length
				Storage.LastFatherForm = Utility.ResizeFormArray(Storage.LastFatherForm, Math.LogicalAnd(Storage.TrackedActors.Length, 0x00000FFF))
			endIf
		endIf
		; ----  end 2.11  ----
		; ---- begin 2.13 ----
		; as of 2.20, this array is dropped
;/		if currMinorVer < 13
			Storage.LastFather = Utility.ResizeStringArray(Storage.LastFather, 0)
		endIf/;
		; ---- end 2.13  ----
		; ---- begin 2.21 ----
		actor thisActor = none
		if currMinorVer < 21
			index = Storage.TrackedFathers.Length
			while index > 0
				index -= 1
				thisActor = Storage.TrackedFathers[index] as actor
				if thisActor
					thisActor.SetFactionRank(TrackedMaleFaction, -1)
					thisActor = none
				endIf
			endWhile
		endIf
		; ----  end 2.21  ----
		; ---- begin 2.24 ----
		int flags = 0
		int theCount = 0
		int FLLEngth = 0
		if currMinorVer < 24
; 		0xFFFFFFFF	=	not unique actor - added 2.25 ( -1 )
;		0x00000001	=	has family relationship
;		0x00000002	=	has sibling
;		0x00000004	=	has Parent/Child
;		0x00000008	=	has Aunt/Uncle
;		0x00000010	=	has Grandparent/Grandchild
			index = Storage.TrackedActors.Length
			if Storage.ActorLocParent.Length != index
				Storage.ActorLocParent = Utility.ResizeFormArray(Storage.ActorLocParent, index, none)
			endIf
			FLLength = ExcludeAT.GetSize()
			if Storage.ATFlags.Length != index
				Storage.ATFlags = Utility.ResizeIntArray(Storage.ATFlags, index, 0)
				thisActor = none
				while (index > 0)
					index -= 1
					thisActor = Storage.TrackedActors[index] as actor
					if thisActor && (Storage.ATFlags[index] == 0)
						if !thisActor.GetLeveledActorBase().IsUnique()
							flags = -1
						elseIf thisActor.HasFamilyRelationship()
							flags = 0x01
							theCount = 0
							while (theCount < FLLength)
								if thisActor.HasAssociation(ExcludeAT.GetAt(theCount) as AssociationType)
									flags = Math.LogicalOR(flags, Math.LeftShift(0x01, (theCount + 1)))
								endIf
								theCount += 1
							endWhile
						endIf
						Storage.ATFlags[index] = flags
						; 2.25
						flags = 0
						thisActor = none
					endIf
				endWhile
			endIf
			index = Storage.TrackedFathers.Length
			if Storage.FatherLocParent.Length != index
				Storage.FatherLocParent = Utility.ResizeFormArray(Storage.FatherLocParent, index, none)
			endIf
		endIf
		; ----  end 2.24  ----
		; ---- begin 2.25 ----
		if currMinorVer < 25
			index = Storage.TrackedFathers.Length
			FLLength = ExcludeAT.GetSize()
			if Storage.ATFlagsMale.Length != index
				Storage.ATFlagsMale = Utility.ResizeIntArray(Storage.ATFlagsMale, index, 0)
				flags = 0
				thisActor = none
				theCount = 0
				while (index > 0)
					index -= 1
					thisActor = Storage.TrackedFathers[index] as actor
					if thisActor && (Storage.ATFlagsMale[index] == 0)
						if !thisActor.GetLeveledActorBase().IsUnique()
							flags = -1
						elseIf thisActor.HasFamilyRelationship()
							flags = 0x01
							theCount = 0
							while (theCount < FLLength)
								if thisActor.HasAssociation(ExcludeAT.GetAt(theCount) as AssociationType)
									flags = Math.LogicalOR(flags, Math.LeftShift(0x01, (theCount + 1)))
								endIf
								theCount += 1
							endWhile
						endIf
						Storage.ATFlagsMale[index] = flags
						flags = 0
						thisActor = none
					endIf
				endWhile
			endIf
		endIf
		; ----  end 2.25  ----
		; ---- begin 2.28 ----
		if currMinorVer < 28
			index = Storage.TrackedActors.Length
			if Storage.FemPromiscuity.Length != index
				Storage.FemPromiscuity	=	Utility.ResizeIntArray(Storage.FemPromiscuity, index, 1)
			endIf
		endIf
		; ----  end 2.28  ----
		; ---- begin 2.32 ----
		if currMinorVer < 32
			Storage.LastMotherLocation = Utility.ResizeStringArray(Storage.LastMotherLocation, 0)
			Storage.LastFatherLocation = Utility.ResizeStringArray(Storage.LastFatherLocation, 0)
;			Storage.EventLock = Utility.ResizeIntArray(Storage.EventLock, 0)
		endIf
		; ----  end 2.32  ----

		; ----	begin 2.50	----
		if currMinorVer < 50
			if !RhiadaQuest.IsRunning()
				RhiadaQuest.SetCurrentStageID(10)
			endIf
		endIf
		; ----  end 2.50  ----

		; ---- begin 2.51 ----
		if currMinorVer < 51
			_JSW_SUB_LittleBlackBookAlias theScript = (FMChildManager.GetNthAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias
			index = 0
			while (index < 10) && (theScript.GetState() != "")
				utility.wait(0.5)
				index += 1
			endWhile
			theScript.SpawnedKids = Utility.ResizeFormArray(theScript.SpawnedKids, 0)
			index = 0
			while index < Storage.ChildrenSpawned.Length
				thisActor = Storage.ChildrenSpawned[index] as actor
				theScript.SpawnedKids = Utility.ResizeFormArray(theScript.SpawnedKids, theScript.SpawnedKids.Length + 1, thisActor as form)
				index += 1
			endWhile
			theScript.FMDoChildUpdate("", "", 0.0, none)
			alias[] aliases = Utility.CreateAliasArray(0)
			index = 1
			alias thisAlias
			theCount = BYOHRelationshipAdoptableOrphanage.GetNumAliases()
			; get aliases in the orphanage quest
			while index < theCount
				aliases = Utility.ResizeAliasArray(aliases, aliases.Length + 1, BYOHRelationshipAdoptableOrphanage.GetNthAlias(index))
				index += 1
			endWhile
			index = 0
			actor newKid
			;	swap temporary orphans with permanent ones
			while index < aliases.Length
				thisActor = (aliases[index] as referenceAlias).GetReference() as actor
				if thisActor && thisActor.HasKeyword(FMSpawnedChild)
					flags = thisActor.GetFormID()
					flags = Math.RightShift(flags, 24)
					if flags == 0xFF	; temporary spawn
						newKid = ((FMChildManager.GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).UpdateSpawnArrays(none, thisActor.GetLeveledActorBase())
						if newKid
							SwapKids (thisActor, newKid, aliases[index] as referenceAlias)
						endIf
					endIf
				endIf
				index += 1
			endWhile
			index = 0
			aliases = Utility.ResizeAliasArray(aliases, 0)
			theCount = BYOHRelationshipAdoption.GetNumAliases()
			; get child aliases on adoption quest
			while index < theCount
				thisAlias = BYOHRelationshipAdoption.GetNThAlias(index)
				if (thisAlias as referenceAlias) && (StringUtil.Find(thisAlias.GetName(), "child") != -1)
					aliases = Utility.ResizealiasArray(aliases, aliases.Length + 1, thisAlias)
				endIf
				index += 1
			endWhile
			index = 0
			; swap old adopted kids for new
			while index < aliases.Length
				thisActor = (aliases[index] as referenceAlias).GetReference() as actor
				if thisActor && thisActor.HasKeyword(FMSpawnedChild)
					newKid = ((FMChildManager.GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).UpdateSpawnArrays(none, thisActor.GetLeveledActorBase())
					if newKid
						SwapKids (thisActor, newKid, aliases[index] as referenceAlias)
					endIf
				endIf
				index += 1
			endWhile
		endIf
		; ----  end 2.51  ----
		; ---- begin 2.53 ----
		if currMinorVer < 53
			if SchedUpdatr.GVHolder.PollingInterval > 4.0
				SchedUpdatr.GVHolder.PollingInterval = 4.0
				SchedUpdatr.GVHolder.UpdateGVs()
			endIf
		endIf
		; ----  end 2.53  ----
		; ---- begin 2.59 ----
		if currMinorVer < 59
			index = 0
			while index < Storage.FemAttached.Length
				if Storage.FemAttached[index] == 0
					Storage.FemAttached[index] = -1
				endIf
				index += 1
			endWhile
			index = 0
			while index < Storage.MaleAttached.Length
				if Storage.MaleAttached[index] == 0
					Storage.MaleAttached[index] = -1
				endIf
				index += 1
			endWhile
		endIf
		; ----  end 2.59  ----
		; ---- begin 2.61 ----
		if currMinorVer < 61
			index = 0
			while index < Storage.TrackedActors.Length
				thisActor = Storage.TrackedActors[index] as actor
				if thisActor && (Math.RightShift(thisActor.GetFormId(), 24) == 0xFF)
					Storage.TrackedActorRemove(index)
				endIf
				index += 1
			endWhile
			index = 0
			while index < Storage.TrackedFathers.Length
				thisActor = Storage.TrackedFathers[index] as actor
				if thisActor && (Math.RightShift(thisActor.GetFormId(), 24) == 0xFF)
					Storage.TrackedFatherRemove(index)
				endIf
				index += 1
			endWhile
		endIf
		; ----  end 2.61  ----
	endIf

	; Final Task: update the stored version info
	Storage.FMValues[9] = 2
	Storage.FMValues[10] = 61
	debug.trace("FM+ Successfully updated to v" + Storage.FMValues[9] + "." + Storage.FMValues[10])
	akTarget.RemoveSpell(FMUpdateSpell)

endEvent

function	SwapKids(actor oldKid, actor newKid, referenceAlias theRef)

	debug.trace("swapkids called, oldkid: " + oldkid + " newkid: " + newkid)
	if !newKid || !oldKid || !theRef
		return
	endIf
	newKid.MoveTo(oldKid)
	newKid.SetActorValue("Variable06", oldKid.GetActorValue("Variable06"))
	newKid.SetActorValue("Variable07", oldKid.GetActorValue("Variable07"))
	newKid.SetFactionRank(BYOHRelationshipAdoptableFACT, oldKid.GetFactionRank(BYOHRelationshipAdoptableFACT))
	theRef.Clear()
	oldKid.Delete()
	newKid.Enable()
	theRef.ForceRefTo(newKid)
	newKid.EvaluatePackage()
	(newkid as _SUB_FM_ChildActorOrphanageScript).OnCellLoad()
endFunction
