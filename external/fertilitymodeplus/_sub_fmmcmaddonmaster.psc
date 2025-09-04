scriptName		_SUB_FMMCMAddonMaster		extends		quest

;/	Parent script for all the MCM Addon pages	
	Consider this a master script, and addon authors should not need to edit it.
	Doing so could cause other addon MCM pages to malfunction.   If you need a change
	made to this script, please inform me so that changes can be kept consistent
	for all addon page users		/;

; list of addon page scripts
_SUB_FMMCMAddonPage01 AddonPage01
_SUB_FMMCMAddonPage02 AddonPage02
_SUB_FMMCMAddonPage03 AddonPage03
_SUB_FMMCMAddonPage04 AddonPage04
_SUB_FMMCMAddonPage05 AddonPage05
_SUB_FMMCMAddonPage42 AddonPage42


string[]	function	GetAddonNames()

	AddonPage01 = self as _SUB_FMMCMAddonPage01
	AddonPage02 = self as _SUB_FMMCMAddonPage02
	AddonPage03 = self as _SUB_FMMCMAddonPage03
	AddonPage04 = self as _SUB_FMMCMAddonPage04
	AddonPage05 = self as _SUB_FMMCMAddonPage05
	AddonPage42 = self as _SUB_FMMCMAddonPage42
	string[]	childNames	=	Utility.CreateStringArray(0)
	if AddonPage01.DoYouDoAnything()
		childNames = Utility.ResizeStringArray(childNames, childNames.Length + 1, AddonPage01.MyPageName)
	endIf
	if AddonPage02.DoYouDoAnything()
		childNames = Utility.ResizeStringArray(childNames, childNames.Length + 1, AddonPage02.MyPageName)
	endIf
	if AddonPage03.DoYouDoAnything()
		childNames = Utility.ResizeStringArray(childNames, childNames.Length + 1, AddonPage03.MyPageName)
	endIf
	if AddonPage04.DoYouDoAnything()
		childNames = Utility.ResizeStringArray(childNames, childNames.Length + 1, AddonPage04.MyPageName)
	endIf
	if AddonPage05.DoYouDoAnything()
		childNames = Utility.ResizeStringArray(childNames, childNames.Length + 1, AddonPage05.MyPageName)
	endIf
	if AddonPage42.DoYouDoAnything()
		childNames = Utility.ResizeStringArray(childNames, childNames.Length + 1, AddonPage42.MyPageName)
	endIf
	return	childNames
endFunction

function	PageReset(string pageName)
	if pageName == AddonPage01.MyPageName
		AddonPage01.ResetPageAddon()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.ResetPageAddon()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.ResetPageAddon()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.ResetPageAddon()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.ResetPageAddon()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.ResetPageAddon()
	endIf
endFunction

function	SetChildState(string pageName, string theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.GoToState(theState)
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.GoToState(theState)
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.GoToState(theState)
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.GoToState(theState)
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.GoToState(theState)
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.GoToState(theState)
	endIf
endFunction
	
function	HighlightST(string pageName, string theState)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnHighlightST()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnHighlightST()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnHighlightST()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnHighlightST()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnHighlightST()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnHighlightST()
	endIf
endFunction

function	DefaultST(string pageName, string theState)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnDefaultST()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnDefaultST()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnDefaultST()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnDefaultST()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnDefaultST()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnDefaultST()
	endIf
endFunction

function	SelectST(string pageName, string theState)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnSelectST()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnSelectST()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnSelectST()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnSelectST()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnSelectST()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnSelectST()
	endIf
endFunction

function	SliderOpenST(string pageName, string theState)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnSliderOpenST()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnSliderOpenST()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnSliderOpenST()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnSliderOpenST()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnSliderOpenST()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnSliderOpenST()
	endIf
endFunction

function	SliderAcceptST(string pageName, string theState, float theFloat)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnSliderAcceptST(theFloat)
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnSliderAcceptST(theFloat)
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnSliderAcceptST(theFloat)
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnSliderAcceptST(theFloat)
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnSliderAcceptST(theFloat)
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnSliderAcceptST(theFloat)
	endIf
endFunction

function	MenuOpenST(string pageName, string theState)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnMenuOpenST()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnMenuOpenST()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnMenuOpenST()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnMenuOpenST()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnMenuOpenST()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnMenuOpenST()
	endIf
endFunction

function	MenuAcceptST(string pageName, string theState, int index)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnMenuAcceptST(index)
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnMenuAcceptST(index)
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnMenuAcceptST(index)
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnMenuAcceptST(index)
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnMenuAcceptST(index)
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnMenuAcceptST(index)
	endIf
endFunction

function	ColorOpenST(string pageName, string theState)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnColorOpenST()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnColorOpenST()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnColorOpenST()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnColorOpenST()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnColorOpenST()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnColorOpenST()
	endIf
endFunction

function	ColorAcceptST(string pageName, string theState, int color)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnColorAcceptST(color)
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnColorAcceptST(color)
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnColorAcceptST(color)
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnColorAcceptST(color)
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnColorAcceptST(color)
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnColorAcceptST(color)
	endIf
endFunction

function	KeyMapChangeST(string pageName, string theState, int keyCode, string conflictControl, string conflictName)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnKeyMapChangeST(keycode, conflictControl, conflictName)
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnKeyMapChangeST(keycode, conflictControl, conflictName)
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnKeyMapChangeST(keycode, conflictControl, conflictName)
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnKeyMapChangeST(keycode, conflictControl, conflictName)
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnKeyMapChangeST(keycode, conflictControl, conflictName)
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnKeyMapChangeST(keycode, conflictControl, conflictName)
	endIf
endFunction

function	InputOpenST(string pageName, string theState)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnInputOpenST()
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnInputOpenST()
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnInputOpenST()
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnInputOpenST()
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnInputOpenST()
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnInputOpenST()
	endIf
endFunction

function	InputAcceptST(string pageName, string theState, string theString)
	SetChildState(pageName, theState)
	if pageName == AddonPage01.MyPageName
		AddonPage01.OnInputAcceptST(theString)
	elseIf pageName == AddonPage02.MyPageName
		AddonPage02.OnInputAcceptST(theString)
	elseIf pageName == AddonPage03.MyPageName
		AddonPage03.OnInputAcceptST(theString)
	elseIf pageName == AddonPage04.MyPageName
		AddonPage04.OnInputAcceptST(theString)
	elseIf pageName == AddonPage05.MyPageName
		AddonPage05.OnInputAcceptST(theString)
	elseIf pageName == AddonPage42.MyPageName
		AddonPage42.OnInputAcceptST(theString)
	endIf
endFunction

;/	below are empty stubs that need to exist in order to compile.  The functions/events must
	exist on the parent (here) in case one of more of the child scripts do not contain them	
	the below events are the ONLY ones that get passed on to the children.  If you do not see
	it below, your script will not receive it!	/;

event	OnHighlightST()
endEvent

event	OnDefaultST()
endEvent

event	OnSelectST()
endEvent

event	OnSliderOpenST()
endEvent

event	OnSliderAcceptST(float theFloat)
endEvent

event	OnMenuOpenST()
endEvent

event	OnMenuAcceptST(int index)
endEvent

event	OnColorOpenST()
endEvent

event	OnColorAcceptST(int color)
endEvent

event	OnKeyMapChangeST(int keyCode, string conflictControl, string conflictName)
endEvent

event	OnInputOpenST()
endEvent

event	OnInputAcceptST(string theString)
endEvent
