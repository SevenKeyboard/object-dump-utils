#Include AutoHotkey v1.1.35+
#Include %A_ScriptDir%
#Include .\lib\StringEscapeUtils.ahk
;==============================================================
; ObjectDumpUtils — Recursive object dump helpers
;
; GitHub: https://github.com/SevenKeyboard/object-dump-utils
; Author: SevenKeyboard Ltd. (2025)
; License: The Unlicense
;==============================================================
class VersionManager_ObjectDumpUtils
{
    static _ := VersionManager_ObjectDumpUtils._init()
    _init()    {
        global
        OBJECTDUMPUTILS_VERSION := "1.0.0"
        if (!this._verCheck(STRINGESCAPEUTILS_VERSION, "1.0.0"))
            throw exception("StringEscapeUtils version 1.x is required (minimum 1.0.0).")
        return true
    }
    _verCheck(byRef actual, required)    {
        if !isSet(actual)
            return false
        actualMajor     := strSplit(actual, ".",, 2)[1]
        requiredMajor   := strSplit(required, ".",, 2)[1]
        if (actualMajor !== requiredMajor)
            return false
        return verCompare(actual, ">=" required)
    }
}
dumpArray(arr, dptLimit:=0,  unescape:=false, dpt:=1, delim:="", sep:=" : ", lBrkt:="[", rBrkt:="]")    {
    if (delim=="")
        delim:=["`n",", "]
    if (!isObject(arr) || (dptLimit&&dptLimit<dpt))
        return ""
    switch isObject(delim)
    {
        case true:  c_delim:=delim[min(dpt,delim.length())]
        default:    c_delim:=delim
    }
    str:=""
    try  {
        for k,v in arr    {
            str.=isObject(v)
                ?((A_Index!==1?c_delim:"") (k!==A_Index?k sep:"") lBrkt %A_ThisFunc%(v,dptLimit,unescape,dpt+1,delim,sep,lBrkt,rBrkt) rBrkt)
                :((A_Index!==1?c_delim:"") (k!==A_Index?k sep:"") (unescape?strUnescape(v):v))
        }
    }
	return str
}