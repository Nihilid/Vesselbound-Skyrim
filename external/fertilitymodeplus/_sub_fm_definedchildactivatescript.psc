scriptName	_SUB_FM_DefinedChildActivateScript		extends		actor

;/  I'm trying to make this as generic as possible, as all defined children have to share the same script.
	Differences in behavior will come about by filled properties.
	Filling properties in the CK or xEdit is optional.   If you do not fill them, nothing happens.
	But, if you need a spawned defined child to fill a quest alias, or set a quest stage, or just send
	a ModEvent when they are spawned, this can help that happen.					/;
;/	Did I miss anything?  Do you need something else?  Let me know, I'll add it in to the base script.
	Again, all children must use the same script- so please don't make custom modifications!	/;

alias		property		aliasToFill			auto
;/ if this property is filled, the child will be forced into this alias's referenceAlias when the child is spawned /;

quest		property		myQuest				auto
int			property		stageToSet			auto	; if set, cannot be zero
;/  if both myQuest and stageToSet properties are filled, myQuest will be set to stage stageToSet when the child is spawned /;

string		property		modEventToSend		auto
;/ if this property is filled, a ModEvent with name modEventToSend will be sent when the child is spawned /;

function	ItsAliiiIIIiiive()
{this function will be executed when the child is spawned, and FM+ will send the ModEvent immediately after}
	GoToState("Ready")
	RegisterForModEvent("FMDefinedChildSpawned", "OnSpawn")
endFunction

event	OnSpawn(string eventName, string useless = "", float unused = 0.0, form sender)
endEvent

state	Ready
	event	OnSpawn(string eventName, string useless = "", float unused = 0.0, form sender)
		GoToState("")
		UnRegisterForModEvent("FMDefinedChildSpawned")
		if aliasToFill
			(aliasToFill as referenceAlias).ForceRefTo((self as actor) as objectReference)
		endIf
		if myQuest && stageToSet
			myQuest.SetCurrentStageID(stageToSet)
		endIf
		if modEventToSend
			SendModEvent(modEventToSend)
		endIf
	endEvent
endState
