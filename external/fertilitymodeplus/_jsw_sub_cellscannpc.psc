ScriptName	_JSW_SUB_CellScanNPC	Extends	ActiveMagicEffect

_JSW_SUB_MiscUtilAlias		Property	MiscUtilAlias		Auto	; 
_JSW_SUB_GVAlias			Property	GVAlias				Auto	; 

Int							Property	gender				Auto	;	Actor's gender passed in by ME
; 2.24
Formlist					Property	ExcludeAT			Auto	; associations used for eliminating random inseminators
form		thisActor	=	none
int			flags		=	0										; AssociationType Flags
location	where		=	none

event OnEffectStart(Actor akTarget, Actor akCaster)

	if !akTarget
		return
	endIf
	; 2.61 don't add temporary spawns
	if Math.RightShift(akTarget.GetFormID(), 24) == 0xFF
		return
	endIf
	thisActor = akTarget as form
	if (gender == 1)
		if (GVAlias.TACopy.Find(thisActor) != -1)
			return
		endIf
	else
		if (GVAlias.TFCopy.Find(thisActor) != -1)
			return
		endIf
	endIf
	string myName = akTarget.GetDisplayName()
    if (!myName || (GVAlias.BlacklistCopy.Find(thisActor) != -1) || (GVAlias.BLByNameCopy.Find(myName) != -1))
		return
	endIf
;	debug.trace("jsw_sub_cellScanNPC applied to: " + myName)
	where = akTarget.GetCurrentLocation()
	if !akTarget.GetLeveledActorBase().IsUnique()
		flags = -1
	elseIf akTarget.HasFamilyRelationship()
		flags = 0x01
		int FLLength = ExcludeAT.GetSize()
		int index = 0
;	0xFFFFFFFF	=	not unique actor ( -1 ) added 2.25
;	0x00000001	=	has family relationship
;	0x00000002	=	has sibling
;	0x00000004	=	has Parent/Child
;	0x00000008	=	has Aunt/Uncle
;	0x00000010	=	has Grandparent/Grandchild
		while (index < FLLength)
			if akTarget.HasAssociation(ExcludeAT.GetAt(index) as AssociationType)
				flags = Math.LogicalOR(flags, Math.LeftShift(0x02, index))
			endIf
			index += 1
		endWhile
	endIf
	OnUpdate()

endEvent

event	OnUpdate()

	if MiscUtilAlias.Queue(thisActor, where as form, (gender == 1), flags)
		return
	endIf
	RegisterForSingleUpdate(0.012)

endEvent
