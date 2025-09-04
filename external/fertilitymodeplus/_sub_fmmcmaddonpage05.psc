scriptName		_SUB_FMMCMAddonPage05		extends		_SUB_FMMCMAddonMaster

;/	
	COMMUNICATION IS KEY!  Once you "claim" one of these scripts as your own, please
	let the other FM+ addon authors know, and at the very least inform me!   If two 
	people try to claim the same script, then one of the MCM pages can't work!
	
	If I need to add more than 5 pages, I can.  SkyUI has a limit of 128.
																			/;

;/	pre-set property for FM MCM Script to eliminate the need for constant casting	/;
_JSW_SUB_ConfigQuestScript	property	FMMCM				auto

;/	variable for direct access to the conditional script /;
_SUB_FMConditionHolder		property	ConditionScript		auto

;/ the name of this page as it appears in FM+ MCM page index	/;
string		property	myPageName	=	""	auto	;	change this to suit your needs

;/ comment out this one, and uncomment the "true" and recompile once claimed	/;
bool	function	DoYouDoAnything()
	FMMCM = (self as quest) as _JSW_SUB_ConfigQuestScript
	return false
endFunction

;/	Uncomment this one!		/;
;/bool	function	DoYouDoAnything()
	FMMCM = (self as quest) as _JSW_SUB_ConfigQuestScript
	return true
endFunction/;

;/	Your code goes inside here	/;
function	ResetPageAddon()
	FMMCM.ShowMessage("This page does nothing... yet!")
endFunction
