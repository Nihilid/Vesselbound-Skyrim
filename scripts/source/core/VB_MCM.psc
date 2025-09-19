Scriptname VB_MCM extends SKI_ConfigBase

VB_Settings Property Settings Auto

Int _pageMain

; ===== SkyUI lifecycle =====
Event OnConfigInit()
    PagesClear()
    _pageMain = PagesAdd("Vesselbound")
EndEvent

Event OnPageReset(String a_page)
    If a_page == "Vesselbound"
        BuildMain()
    EndIf
EndEvent

; ===== UI Builders =====
Function BuildMain()
    If Settings == None
        AddTextOption("warning", "Settings quest not linked!", "")
        return
    EndIf

    AddHeaderOption("Climax Cascades")
    AddToggleOptionST("cc_enabled", "Enabled", Settings.CascadesEnabled)
    AddSliderOptionST("cc_base", "Base Chance %", Settings.CascadesBaseChance, "{0}", 0, 100, 1)
    AddSliderOptionST("cc_max",  "Max Cascades",  Settings.CascadesMax, "{0}", 1, 10, 1)

    AddEmptyOption()

    AddHeaderOption("OIO (Orgasm-Induced Ovulation)")
    AddToggleOptionST("oio_enabled", "Enabled", Settings.OIOEnabled)
    AddSliderOptionST("oio_base", "Base Chance %", Settings.OIOBaseChance, "{0}", 0, 100, 1)
    AddToggleOptionST("oio_force", "Force Ovulation on Orgasm", Settings.OIOForceOvulation)

    AddEmptyOption()

    AddHeaderOption("Debug / UX")
    AddToggleOptionST("dbg", "Enable Logging", Settings.DebugEnabled)
    AddToggleOptionST("toasts", "Show Notifications", Settings.NotificationsEnabled)
EndFunction

; ===== Setters (SkyUI stateful options) =====
State cc_enabled
    Event OnSelectST()
        Settings.CascadesEnabled = !Settings.CascadesEnabled
        SetToggleOptionValueST(Settings.CascadesEnabled)
    EndEvent
EndState

State cc_base
    Event OnSliderOpenST()
        SetSliderDialogRange(0, 100)
        SetSliderDialogDefaultValue(10)
        SetSliderDialogStartValue(Settings.CascadesBaseChance)
    EndEvent
    Event OnSliderAcceptST(Float value)
        Settings.CascadesBaseChance = value as Int
        SetSliderOptionValueST(Settings.CascadesBaseChance, "{0}")
    EndEvent
EndState

State cc_max
    Event OnSliderOpenST()
        SetSliderDialogRange(1, 10)
        SetSliderDialogDefaultValue(3)
        SetSliderDialogStartValue(Settings.CascadesMax)
    EndEvent
    Event OnSliderAcceptST(Float value)
        Settings.CascadesMax = value as Int
        SetSliderOptionValueST(Settings.CascadesMax, "{0}")
    EndEvent
EndState

State oio_enabled
    Event OnSelectST()
        Settings.OIOEnabled = !Settings.OIOEnabled
        SetToggleOptionValueST(Settings.OIOEnabled)
    EndEvent
EndState

State oio_base
    Event OnSliderOpenST()
        SetSliderDialogRange(0, 100)
        SetSliderDialogDefaultValue(25)
        SetSliderDialogStartValue(Settings.OIOBaseChance)
    EndEvent
    Event OnSliderAcceptST(Float value)
        Settings.OIOBaseChance = value as Int
        SetSliderOptionValueST(Settings.OIOBaseChance, "{0}")
    EndEvent
EndState

State oio_force
    Event OnSelectST()
        Settings.OIOForceOvulation = !Settings.OIOForceOvulation
        SetToggleOptionValueST(Settings.OIOForceOvulation)
    EndEvent
EndState

State dbg
    Event OnSelectST()
        Settings.DebugEnabled = !Settings.DebugEnabled
        SetToggleOptionValueST(Settings.DebugEnabled)
    EndEvent
EndState

State toasts
    Event OnSelectST()
        Settings.NotificationsEnabled = !Settings.NotificationsEnabled
        SetToggleOptionValueST(Settings.NotificationsEnabled)
    EndEvent
EndState
