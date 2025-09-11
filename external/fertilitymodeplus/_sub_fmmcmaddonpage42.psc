scriptName		_SUB_FMMCMAddonPage42		extends		_SUB_FMMCMAddonMaster

;/	
	COMMUNICATION IS KEY!  Once you "claim" one of these scripts as your own, please
	let the other FM+ addon authors know, and at the very least inform me!   If two 
	people try to claim the same script, then one of the MCM pages can't work!
	
	If I need to add more pages, I can.  SkyUI has a limit of 128.
																			/;

;/	variable for FM MCM Script to eliminate the need for constant casting	/;
_JSW_SUB_ConfigQuestScript		FMMCM

;/	variable for direct access to the conditional script /;
_SUB_FMConditionHolder		property	ConditionScript		auto

;/ the name of this page as it appears in FM+ MCM page index	/;
string		property	myPageName	=	"Example Addon"	auto	;	change this to suit your needs

;/	Change from "false" to "true" and recompile to activate this script		/;
bool	function	DoYouDoAnything()
	FMMCM = (self as quest) as _JSW_SUB_ConfigQuestScript
	return false
endFunction

;/	Your code goes inside here
	All calls to SkyUI functions must be preceeded with "FMMCM." 
	as shown in the examples below	/;
function	ResetPageAddon()
;	((self as quest) as _JSW_SUB_ConfigQuestScript).ShowMessage("This page does nothing... yet!")

	FMMCM.AddTextOption("AddTextOption Text", "Option Text")
	;/	when picking State Names (exTestState in the line below) there cannot be collissions between either
		the main FM+ MCM script or other Addon scripts!   Make them unique, suggested preface them with
		your mod name or an abbreviated version thereof.  Example: Fertility Adventures State Names might
		begin with "FA" and FME State Names might begin with "FME"		
		I'm prefacing this with "ex" for "example"	/;
	FMMCM.AddTextOptionST("exTestState", "AddTextOptionST Text", "State Text")
	;/	Included is a conditional quest, witha  conditional script for you to set values on.
		Each of these child scripts ahs access to five conditional Ints:
		ConditionScript.ScriptxxInt01 - ConditionScript.ScriptxxInt05   where "xx" is your script number, this one is "42"
		and five Conditional Floats: 
		ConditionScript.ScriptxxFloat01 - ConditionScript.ScriptxxFloat05				
		If you need more, just ask!    
		Conditional variables can be used in quest, dialogue, spell, etc conditions via
		the "GetVMQuestVariable" condition check	/;
	; for the hell of it, as an example, we're setting the value of one of our floats
	ConditionScript.Script42Float01 = 1.037
endFunction

;/	Child scripts (such as this one) will only receive events that end in "ST".  They are:
	OnHighlightST, OnDefaultST, OnSelectST, OnSliderOpenST, OnSliderAcceptST, OnMenuOpenST, OnMenuAcceptST, 
	OnColorOpenST, OnColorAcceptST, OnKeyMapChangeST, OnInputOpenST and OnInputAcceptST
	You will not receive other events!	/;
state exTestState
	event	OnHighlightST()
		FMMCM.SetInfoText("This is OnHighlightST info text")
	endEvent
endState
