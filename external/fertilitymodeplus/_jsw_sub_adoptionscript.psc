Scriptname	_JSW_SUB_AdoptionScript	Extends	Quest

;_JSW_BB_Storage				Property	Storage		Auto	; Storage data helper

;_JSW_SUB_GVHolderScript		Property	GVHolder	Auto	;

;Actor			Property	PlayerRef				Auto	; Reference to the player. Game.GetPlayer() is slow

;Keyword			Property	SpawnedChild			Auto	; Keyword for identifying Fertility Mode children

;Quest			Property	RelationshipAdoptable	Auto	;	BYOHRelationshipAdoptable
;Quest			Property	RelationshipAdoption	Auto	;	BYOHRelationshipAdoption
;Quest			Property	BYOHRAO					Auto	;	BYOHRelationshipAdoptableOrphanage
;Quest			Property	FMChildHandler			Auto	;	FM+ Child Manager Quest

;/string	function	TryAdoptChildMCM(actor child)
{Debug function for spawning and adopting a child in the MCM}

	RegisterForSingleUpdate(10.0)
	if (!child.HasKeyword(SpawnedChild))
		return "Invalid actor selected"
	endIf

	if !(Storage.maxAdoptions > (RelationshipAdoption as BYOHRelationshipAdoptionScript).numChildrenAdopted)
		; Adopted children maxed out
		return "Maximum adoptions reached"
	endIf
	; Make sure that the home status is current
	(RelationshipAdoptable as BYOHRelationshipAdoptableScript).UpdateHouseStatus()
	; the set player's home location, will be stored on child's Variable07
	int destination = (RelationshipAdoptable as BYOHRelationshipAdoptableScript).ValidateMoveDestination((BYOHRAO as BYOHRelationshipAdoptableOrphanageSc).OrphanageHouseLoc, 0)
	if (destination != 0)
		DoAdopt(child, destination)
		return "Adopting, move queued!"
	else
		return "No valid available houses"
	endIf
endFunction/;
;/
Actor function TrySpawnChildAdopt(Actor akActor)
{Attempt to spawn a child actor for the Hearthfire/HMA adoption system}

	RegisterForSingleUpdate(10.0)
    int raceIndex = Storage.GetRaceIndex(akActor)

    if (raceIndex != -1)
		if !(Storage.maxAdoptions > (RelationshipAdoption as BYOHRelationshipAdoptionScript).numChildrenAdopted)
            ; Adopted children maxed out
;			RegisterForSingleUpdate(10.0)
            return none
        endIf

        ; Make sure that the home status is current
        (RelationshipAdoptable as BYOHRelationshipAdoptableScript).UpdateHouseStatus()

		int destination = (RelationshipAdoptable as BYOHRelationshipAdoptableScript).ValidateMoveDestination((BYOHRAO as BYOHRelationshipAdoptableOrphanageSc).OrphanageHouseLoc, 0)

        if destination != 0

            ActorBase childBase = Storage.Children[2 * raceIndex + Utility.RandomInt(0, 1)] as actorbase

            Actor child = PlayerRef.PlaceActorAtMe(childBase) as Actor

			DoAdopt(child, destination)

            if GVHolder.VerboseMode
                Debug.Notification("Mother '" + akActor.GetDisplayName() + "': New child sent to player's home.")
            endIf

;			RegisterForSingleUpdate(10.0)
            return child
        else
			if (destination == 0)
				Debug.Notification("Mother '" + akActor.GetDisplayName() + "': No available homes for child growth")
			endIf
        endIf
    else
        ; The actor's race is unsupported
		Debug.Notification("Mother '" + akActor.GetDisplayName() + "': Unsupported race for child growth")
    endIf
;	RegisterForSingleUpdate(10.0)
    return none

endFunction/;

;/function	DoAdopt(actor child, int destination)

	; The target house is stored in variable07 on the child actor and must be present before HF adoption quest is invoked
	child.SetActorValue("Variable07", destination as float)
	; Adopt and go!
	RelationshipAdoption.SetCurrentStageID(10)
	(RelationshipAdoption as BYOHRelationshipAdoptionScript).AdoptChild(child)
endFunction/;

;/Actor function TrySpawnChild(Actor akActor, int raceIndex)
{Attempt to spawn a child actor and send to the package location}

    ActorBase childBase = Storage.Children[2 * raceIndex + Utility.RandomInt(0, 1)] as actorbase

    ; Match hair color to the parent
	; pointless, doesn't persist thru game loads
;    childBase.SetHairColor(akActor.GetActorBase().GetHairColor())

	RegisterForSingleUpdate(10.0)
    return PlayerRef.PlaceActorAtMe(childBase) as Actor

endFunction/;

;/string function GenerateName(string msg)

	string theString = ((self as Form) as UILIB_1).ShowTextInput(msg, "")
	RegisterForSingleUpdate(10.0)
	return theString

endFunction/;

;/function RenameChild(Actor akChild, actor akOtherParent = none)
{Renames the specified child}

    if (!akChild.HasKeyword(SpawnedChild))
		RegisterForSingleUpdate(10.0)
        return
    endIf

; 2.33 make message gender-specific
;    string theString = "Name your child: "
    string theString = "Name your "
	int index = Storage.TrackedActors.Find(akOtherParent as form)
	if akChild.GetLeveledActorBase().GetSex()
		theString += "daughter"
	else
		theString += "son"
	endIf
	; renamed via MCM, or player is mother and father is dead so we can't resolve his name, or player impregnated themselves via debug
	if (akOtherParent == none) || ((akOtherParent == playerRef) && (Storage.LastFatherForm[index] == none))
		theString += ": "
	; player is the mother
	elseIf (akOtherParent == playerRef) && (index != -1)
		theString += " by " + (Storage.LastFatherForm[index] as objectReference).GetDisplayName() + ": "
	;player is father
	elseIf index != -1
		theString += " by " + (Storage.TrackedActors[index] as objectReference).GetDisplayName() + ": "
	; something eent wrong
	else
		Debug.Trace("FM+: error in RenameChild, akChild: " + akChild + " akOtherParent: " + akOtherParent, 1)
	endIf
	
; end 2.33
	theString = ((self as Form) as UILIB_1).ShowTextInput(theString, "")
	index = ModEvent.Create("FMChildRenamed")
	if index
		ModEvent.PushForm(index, akChild as form)
		ModEvent.PushString(index, theString)
		ModEvent.Send(index)
	endIf
	RegisterForSingleUpdate(10.0)

endFunction/;

event	OnUpdate()

	SetCurrentStageID(20)

endEvent
