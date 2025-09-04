scriptName		_SUB_FMMCMAddonPage01		extends		_SUB_FMMCMAddonMaster

;/	
	COMMUNICATION IS KEY!  Once you "claim" one of these scripts as your own, please
	let the other FM+ addon authors know, and at the very least inform me!   If two 
	people try to claim the same script, then one of the MCM pages can't work!
	
	If I need to add more than 5 pages, I can.  SkyUI has a limit of 128.
																			/;

;/	variable for FM MCM Script to eliminate the need for constant casting	/;
_JSW_SUB_ConfigQuestScript		FMMCM

;/	variable for direct access to the conditional script /;
_SUB_FMConditionHolder		property	ConditionScript		auto

;/ the name of this page as it appears in FM+ MCM page index	/;
string		property	myPageName	=	""	auto	;	change this to suit your needs

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
	FMMCM.AddTextOptionST("TestState", "AddTextOptionST Text", "State Text")
endFunction

;/	Child scripts (such as this one) will only receive events that end in "ST":
	OnHighlightST, OnDefaultST, OnSelectST, OnSliderOpenST, OnSliderAcceptST, OnMenuOpenST, OnMenuAcceptST, 
	OnColorOpenST, OnColorAcceptST, OnKeyMapChangeST, OnInputOpenST and OnInputAcceptST
	You will not receive other events!	/;
state TestState
	event	OnHighlightST()
		FMMCM.SetInfoText("This is OnHighlightST info text")
	endEvent
endState
