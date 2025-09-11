;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname _JSW_SUB_TIF__Adopt Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
;BEGIN CODE
; Attempt adoption
string result = ((FMChildManager.GetAlias(0) as referenceAlias) as _JSW_SUB_LittleBlackBookAlias).TryAdoptChildMcm(akSpeakerRef as actor)


Debug.Notification(result)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
;_JSW_SUB_AdoptionScript Property FMAdoptScript  Auto                     ; 
Quest	Property	FMChildManager	Auto
