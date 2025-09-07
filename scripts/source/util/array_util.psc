; ==============================
; Vesselbound — Util: ArrayUtil
; File: source/util/arrayutil.psc
; Notes: Provides push/append helpers for primitive arrays.
; ==============================

Scriptname VB_ArrayUtil Hidden

String[] Function PushString(String[] src, String v) Global
    if src == None
        String[] t = new String[1]
        t[0] = v
        return t
    endif
    Int n = src.Length
    String[] out = Utility.CreateStringArray(n + 1)
    Int i = 0
    while i < n
        out[i] = src[i]
        i += 1
    endwhile
    out[n] = v
    return out
EndFunction

Float[] Function PushFloat(Float[] src, Float v) Global
    if src == None
        Float[] t = new Float[1]
        t[0] = v
        return t
    endif
    Int n = src.Length
    Float[] out = Utility.CreateFloatArray(n + 1)
    Int i = 0
    while i < n
        out[i] = src[i]
        i += 1
    endwhile
    out[n] = v
    return out
EndFunction
