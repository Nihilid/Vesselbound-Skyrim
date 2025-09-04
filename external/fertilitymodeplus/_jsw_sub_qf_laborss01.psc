;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 21
Scriptname _jsw_sub_qf_laborss01 Extends Quest Hidden

;BEGIN FRAGMENT Fragment_20
Function Fragment_20()
;BEGIN CODE
; stage 20
	referenceAlias theRef = GetAlias(0) as referenceAlias
	if theRef.GetReference() != none
		theRef.Clear()
	endIf
	Reset()
	Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_10
Function Fragment_10()
;BEGIN CODE
; stage 10
	if (GetAlias(0) as referenceAlias).GetReference() as actor
		Start()
	endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
