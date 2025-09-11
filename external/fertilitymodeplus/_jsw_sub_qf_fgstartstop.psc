;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 21
scriptName	_JSW_SUB_QF_FGStartStop	extends	quest	hidden

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
; stage 10
	if theRef && theActor && (((theRef as referenceAlias).GetReference() as actor) != theActor)
		(theRef as referenceAlias).ForceRefTo(theActor)
	endIf
	Start()
	((theRef as referenceAlias) as _JSW_SUB_FGReferenceAlias).OnInit()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; stage 20
	(theRef as referenceAlias).Clear()
	Reset()
	Stop()
	(theRef as referenceAlias).Clear()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Alias	Property	theRef		Auto

actor	Property	theActor	Auto

;/	Two properties:
	theRef		: leave null if the quest doesn't use an alias
	theActor	: the actor to ForceRefTo() /;
