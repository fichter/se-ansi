; ==============================================================================
; se-ansi by Rene Fichter
; Keyboard layout for AutoHotkey v2
; ==============================================================================

#Requires AutoHotkey v2.0
#SingleInstance Force
SendMode("Input")

; ------------------------------------------------------------------------------
; Core Functions
; ------------------------------------------------------------------------------

; Dispatches characters based on Shift and CapsLock state
SendLetter(lower, upper, isShifted) {
    isCaps := GetKeyState("CapsLock", "T")
    
    ; If CapsLock and Shift states are different, output uppercase
    if (isCaps != isShifted) {
        SendText(upper)
    } else {
        SendText(lower)
    }
}

; ------------------------------------------------------------------------------
; Base Layer Remappings
; ------------------------------------------------------------------------------

; SC01A (US [) -> å / Å | AltGr: [ | Shift+AltGr: {
$SC01A::SendLetter("å", "Å", false)
$+SC01A::SendLetter("å", "Å", true)
$>!SC01A::SendText("[")
$+>!SC01A::SendText("{")

; SC01B (US ]) -> ' / " | AltGr: ] | Shift+AltGr: }
$SC01B::SendText("'")
$+SC01B::SendText('"')
$>!SC01B::SendText("]")
$+>!SC01B::SendText("}")

; SC027 (US ;) -> ö / Ö | AltGr: ; | Shift+AltGr: :
$SC027::SendLetter("ö", "Ö", false)
$+SC027::SendLetter("ö", "Ö", true)
$>!SC027::SendText(";")
$+>!SC027::SendText(":")

; SC028 (US ') -> ä / Ä | AltGr: ' | Shift+AltGr: "
$SC028::SendLetter("ä", "Ä", false)
$+SC028::SendLetter("ä", "Ä", true)
$>!SC028::SendText("'")
$+>!SC028::SendText('"')

; SC029 (US `) -> ` / ~ | AltGr: § | Shift+AltGr: ½
$SC029::SendText(Chr(0x60))
$+SC029::SendText("~")
$>!SC029::SendText("§")
$+>!SC029::SendText("½")

; SC056 (ISO <) -> < / > | AltGr: |
$SC056::SendText("<")
$+SC056::SendText(">")
$>!SC056::SendText("|")

; Numpad Decimal overrides
$NumpadDot::SendText(",")
$+NumpadDot::SendText(",")

; ------------------------------------------------------------------------------
; AltGr (Right Alt) Layer Mappings
; ------------------------------------------------------------------------------

; Number Row
$>!1::SendText("¾")
$+>!1::SendText("¹")

$>!2::SendText('"')
$+>!2::SendText("²")

$>!3::SendText("£")
$+>!3::SendText("³")

$>!4::SendText("¤")
$+>!4::SendText("¥")

$>!5::SendText("€")
$+>!5::SendText("×")

$+>!6::SendText("÷")
$+>!7::SendText("‘")
$+>!8::SendText("’")

$>!9::SendText("{")
$+>!9::SendText("[")

$>!0::SendText("}")
$+>!0::SendText("]")

; Letter & Punctuation Row
$>!e::SendText("€")
$>!m::SendText("µ")
$>!,::SendText(";")
$>!.::SendText(":")

; ------------------------------------------------------------------------------
; Dead Key Assignments
; ------------------------------------------------------------------------------

$>!6::HandleDeadKey("^")
$>!-::HandleDeadKey("¨")
$+>!-::HandleDeadKey("~")
$>!=::HandleDeadKey("´")
$+>!=::HandleDeadKey(Chr(0x60)) ; Grave Accent (`)

; ------------------------------------------------------------------------------
; Dead Key Composition Engine
; ------------------------------------------------------------------------------

HandleDeadKey(dk) {
    ; Static composition dictionary
    static dkMap := Map(
        "^",        Map("a", "â", "e", "ê", "u", "û", "i", "î", "o", "ô", "A", "Â", "E", "Ê", "U", "Û", "I", "Î", "O", "Ô", " ", "^"),
        "¨",        Map("a", "ä", "e", "ë", "u", "ü", "i", "ï", "y", "ÿ", "o", "ö", "A", "Ä", "E", "Ë", "U", "Ü", "I", "Ï", "O", "Ö", " ", "¨"),
        "~",        Map("n", "ñ", "a", "ã", "o", "õ", "N", "Ñ", "A", "Ã", "O", "Õ", " ", "~"),
        "´",        Map("a", "á", "e", "é", "u", "ú", "i", "í", "y", "ý", "o", "ó", "A", "Á", "E", "É", "U", "Ú", "I", "Í", "Y", "Ý", "O", "Ó", " ", "´"),
        Chr(0x60),  Map("a", "à", "e", "è", "u", "ù", "i", "ì", "o", "ò", "A", "À", "E", "È", "U", "Ù", "I", "Ì", "O", "Ò", " ", Chr(0x60))
    )
    
    ; Intercept the next keystroke (indefinite wait)
    ih := InputHook("L1")
    ih.Start()
    ih.Wait()
    
    key := ih.Input
    
    ; Output resolved character or fallback sequence
    if (dkMap[dk].Has(key)) {
        SendText(dkMap[dk][key])
    } else {
        SendText(dk . key)
    }
}