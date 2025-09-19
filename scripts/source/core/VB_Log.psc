Scriptname VB_Log

; level: 0=info, 1=warn, 2=error
Function Trace(String msg, VB_Settings settings, Int level = 0) Global
    If settings && settings.DebugEnabled
        String tag = "[Vesselbound] "
        If level == 2
            Debug.Trace(tag + "ERR: " + msg, 2)
        ElseIf level == 1
            Debug.Trace(tag + "WARN: " + msg)
        Else
            Debug.Trace(tag + msg)
        EndIf
    EndIf
EndFunction
