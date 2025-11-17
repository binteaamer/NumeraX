TITLE NumeraX - Number System Converter
INCLUDE Irvine32.inc

.data
menuTitle   BYTE "=== NumeraX: Number System Converter ===", 0
menuOptions BYTE \
    "1. Decimal to Binary", 0Dh,0Ah,\
    "2. Decimal to Octal", 0Dh,0Ah,\
    "3. Decimal to Hexadecimal", 0Dh,0Ah,\
    "4. Binary to Decimal", 0Dh,0Ah,\
    "5. Octal to Decimal", 0Dh,0Ah,\
    "6. Hexadecimal to Decimal", 0Dh,0Ah,\
    "7. Binary <-> Octal / Hexadecimal", 0Dh,0Ah,\
    "8. Two's Complement Representation", 0Dh,0Ah,\
    "9. Quiz Mode", 0Dh,0Ah,\
    "10. Speed Test Mode", 0Dh,0Ah,\
    "11. Exit", 0Dh,0Ah,0
directConvMenu BYTE \
    "=== Direct Conversions ===", 0Dh,0Ah,\
    "1. Binary to Octal", 0Dh,0Ah,\
    "2. Binary to Hexadecimal", 0Dh,0Ah,\
    "3. Octal to Binary", 0Dh,0Ah,\
    "4. Hexadecimal to Binary", 0Dh,0Ah,\
    "5. Back to Main Menu", 0Dh,0Ah,0

directChoice BYTE "Choose conversion type: ", 0
choice BYTE "Enter your choice: ", 0
decPrompt BYTE "Enter decimal number: ", 0
binPrompt BYTE "Enter binary number: ", 0
octPrompt BYTE "Enter octal number: ", 0
hexPrompt BYTE "Enter hexadecimal number: ", 0
invalidMsg  BYTE "Invalid choice. Try again.", 0
goodbyeMsg  BYTE "Exiting program... Goodbye!", 0

userChoice DWORD ?
inputBuffer BYTE 32 DUP(0)
outputBuffer BYTE 32 DUP(0)

score DWORD ?
questionCount DWORD ?
startTime DWORD ?
endTime DWORD ?


;data for TwosComplement Procedure
msg1 byte "Enter number : ",0
two_c_print byte "Two's complement : ",0
buffer byte 33 DUP(0) ,0
final byte 33 DUP(0) ,0


.code
main PROC
    call Clrscr
    ; Initialize buffers
    mov edi, OFFSET outputBuffer
    mov ecx, 32
    mov al, 0
    rep stosb

mainMenuLoop:
    ;display 
    mov edx, OFFSET menuTitle
    call WriteString
    call CrLf

    mov edx, OFFSET menuOptions
    call WriteString
    call CrLf

    mov edx, OFFSET choice
    call WriteString
    call ReadInt
    mov userChoice, eax

    cmp eax, 1
    je do_DecToBin
    cmp eax, 2
    je do_DecToOct
    cmp eax, 3
    je do_DecToHex
    cmp eax, 4
    je do_BinToDec
    cmp eax, 5
    je do_OctToDec
    cmp eax, 6
    je do_HexToDec
    cmp eax, 7
    je do_DirectConversions
    cmp eax, 8
    je do_TwosComplement
    cmp eax, 9
    je do_QuizMode
    cmp eax, 10
    je do_SpeedTest
    cmp eax, 11
    je ExitProgram

    ; Invalid choice
    mov edx, OFFSET invalidMsg
    call WriteString
    call CrLf
    jmp mainMenuLoop


do_DecToBin:
     call DecToBin
    jmp returnToMenu

do_DecToOct:
     call DecToOct
    jmp returnToMenu

do_DecToHex:
     call DecToHex
    jmp returnToMenu

do_BinToDec:
     call BinToDec
    jmp returnToMenu

do_OctToDec:
     call OctToDec
    jmp returnToMenu

do_HexToDec:
     call HexToDec
    jmp returnToMenu

do_DirectConversions:
     call DirectConversions
    jmp returnToMenu

do_TwosComplement:
     call TwosComplement
    jmp returnToMenu

do_QuizMode:
     call QuizMode
    jmp returnToMenu

do_SpeedTest:
     call SpeedTestMode
    jmp returnToMenu

returnToMenu:
    call CrLf
    jmp mainMenuLoop

    mov edx, OFFSET goodbyeMsg
    call WriteString
    call CrLf
    exit

main ENDP

; -----------------------------
; Decimal to Binary
; -----------------------------
DecToBin PROC
    ; Prompt for decimal number
    mov edx, OFFSET decPrompt
    call WriteString
    call ReadDec       ; EAX = decimal number

    ; Convert decimal to binary
    mov ecx, 32        ; 32 bits
    mov ebx, eax       ; Save original number
    lea edi, outputBuffer
    add edi, 32        ; Point to end of buffer
    mov BYTE PTR [edi], 0
    dec edi

decToBinLoop:
    mov eax, ebx
    and eax, 1
    add al, '0'
    mov [edi], al
    shr ebx, 1
    dec edi
    loop decToBinLoop

    ; Print result
    mov edx, OFFSET outputBuffer
    call WriteString
    call CrLf
    ret
DecToBin ENDP

; -----------------------------
; Decimal to Octal
; -----------------------------
DecToOct PROC
    mov edx, OFFSET decPrompt
    call WriteString
    call ReadInt       ; EAX = decimal number

    mov ebx, eax
    lea edi, outputBuffer
    add edi, 32
    mov BYTE PTR [edi], 0
    dec edi

decToOctLoop:
    mov eax, ebx
    mov edx, 0
    mov ecx, 8
    div ecx            ; EAX / 8, remainder in EDX
    add dl, '0'
    mov [edi], dl
    mov ebx, eax
    cmp ebx, 0
    je decToOctDone
    dec edi
    jmp decToOctLoop

decToOctDone:
    mov edx, edi
    call WriteString
    call CrLf
    ret
DecToOct ENDP

; -----------------------------
; Decimal to Hexadecimal
; -----------------------------
DecToHex PROC
    mov edx, OFFSET decPrompt
    call WriteString
    call ReadInt       ; EAX = decimal number

    mov ebx, eax
    lea edi, outputBuffer
    add edi, 32
    mov BYTE PTR [edi], 0
    dec edi

decToHexLoop:
    mov eax, ebx
    mov edx, 0
    mov ecx, 16
    div ecx
    cmp dl, 9
    jbe decToHexDigit
    add dl, 7           ; Convert 10-15 to 'A'-'F'
decToHexDigit:
    add dl, '0'
    mov [edi], dl
    mov ebx, eax
    cmp ebx, 0
    je decToHexDone
    dec edi
    jmp decToHexLoop

decToHexDone:
    mov edx, edi
    call WriteString
    call CrLf
    ret
DecToHex ENDP

; -----------------------------
; Binary to Decimal
; -----------------------------
BinToDec PROC
    mov edx, OFFSET binPrompt
    call WriteString
    
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    
    mov esi, OFFSET inputBuffer
    xor eax, eax        ; EAX = result
    
binToDecLoop:
    mov bl, [esi]
    cmp bl, 0
    je binToDecDone
    
    ; Validate binary digit
    cmp bl, '0'
    jb invalidBinary
    cmp bl, '1'
    ja invalidBinary
    
    shl eax, 1          ; Multiply result by 2
    sub bl, '0'         ; Convert ASCII to number
    add eax, ebx        ; Add current digit
    
    inc esi
    jmp binToDecLoop

invalidBinary:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CrLf
    ret
    
binToDecDone:
    call WriteDec       ; Use WriteDec instead of WriteInt for unsigned
    call CrLf
    ret
BinToDec ENDP

; -----------------------------
; Octal to Decimal
; -----------------------------
OctToDec PROC
    mov edx, OFFSET octPrompt
    call WriteString
    lea edx, inputBuffer
    call ReadString

    mov esi, OFFSET inputBuffer
    xor eax, eax
    xor ebx, ebx        ; EBX = result
octToDecLoop:
    mov bl, [esi]
    cmp bl, 0
    je octToDecDone
    sub bl, '0'
    imul eax, eax, 8
    add eax, ebx
    inc esi
    jmp octToDecLoop
octToDecDone:
    call WriteInt
    call CrLf
    ret
OctToDec ENDP

; -----------------------------
; Hexadecimal to Decimal
; -----------------------------
HexToDec PROC
    mov edx, OFFSET hexPrompt
    call WriteString
    lea edx, inputBuffer
    call ReadString

    mov esi, OFFSET inputBuffer
    xor eax, eax
hexToDecLoop:
    mov bl, [esi]
    cmp bl, 0
    je hexToDecDone
    shl eax, 4
    cmp bl, '0'
    jb hexNext
    cmp bl, '9'
    jbe hexAddDigit
    cmp bl, 'A'
    jb hexNext
    cmp bl, 'F'
    jbe hexAddAlpha
    cmp bl, 'a'
    jb hexNext
    cmp bl, 'f'
    ja hexNext
    sub bl, 32           ; Convert lowercase to uppercase
hexAddAlpha:
    sub bl, 'A'
    add bl, 10
    jmp hexAdd
hexAddDigit:
    sub bl, '0'
hexAdd:
    add eax, ebx
hexNext:
    inc esi
    jmp hexToDecLoop
hexToDecDone:
    call WriteInt
    call CrLf
    ret
HexToDec ENDP

TwosComplement PROC
    mov edx, OFFSET msg1 
    call WriteString

    mov edx, OFFSET buffer
    mov ecx, 32
    call ReadString

    ; Validate binary input first
    mov esi, OFFSET buffer
validateLoop:
    mov al, [esi]
    cmp al, 0
    je startConversion
    cmp al, '0'
    jb invalidBinaryTC
    cmp al, '1'
    ja invalidBinaryTC
    inc esi
    jmp validateLoop

invalidBinaryTC:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CrLf
    ret

startConversion:
    mov esi, OFFSET buffer
    mov edi, OFFSET final

    ; Copy and invert bits
invertLoop:
    mov al, [esi]
    cmp al, 0
    je addOne
    cmp al, '0'
    je make1
    mov BYTE PTR [edi], '0'
    jmp nextInvert
make1:
    mov BYTE PTR [edi], '1'
nextInvert:
    inc esi
    inc edi
    jmp invertLoop

addOne:
    mov BYTE PTR [edi], 0  ; Null terminate
    mov edi, OFFSET final
    
    ; Find the end of the string
findEnd: 
    cmp BYTE PTR [edi], 0
    je doAdd
    inc edi
    jmp findEnd

doAdd:
    dec edi
    mov bl, 1              ; Carry flag

addLoop:
    cmp edi, OFFSET final
    jb doneAdd
    
    mov al, [edi]
    cmp al, '0'
    je handleZero
    ; It's '1'
    cmp bl, 1
    jne noChange
    mov BYTE PTR [edi], '0'
    jmp nextDigit
handleZero:
    cmp bl, 1
    jne noChange
    mov BYTE PTR [edi], '1'
    mov bl, 0
noChange:
nextDigit:
    dec edi
    jmp addLoop

doneAdd:
    mov edx, OFFSET two_c_print 
    call WriteString
    mov edx, OFFSET final
    call WriteString
    call CrLf
    ret
TwosComplement ENDP

; -----------------------------
; Direct Conversions
; -----------------------------
DirectConversions PROC
    call Clrscr
    
directMenuLoop:
    mov edx, OFFSET directConvMenu
    call WriteString
    call CrLf
    
    mov edx, OFFSET directChoice
    call WriteString
    call ReadInt
    
    cmp eax, 1
    je do_BinToOct
    cmp eax, 2
    je do_BinToHex
    cmp eax, 3
    je do_OctToBin
    cmp eax, 4
    je do_HexToBin
    cmp eax, 5
    je directConvExit
    
    mov edx, OFFSET invalidMsg
    call WriteString
    call CrLf
    jmp directMenuLoop

do_BinToOct:
    call BinToOct
    jmp directMenuLoop

do_BinToHex:
    call BinToHex
    jmp directMenuLoop

do_OctToBin:
    call OctToBin
    jmp directMenuLoop

do_HexToBin:
    call HexToBin
    jmp directMenuLoop

directConvExit:
    ret
DirectConversions ENDP

BinToOct PROC
    ; Get binary input
    mov edx, OFFSET binPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    
    ; Pad binary to multiple of 3 bits
    mov esi, OFFSET inputBuffer
    call StrLength
    mov ecx, eax
    
    ; Calculate padding needed
    mov edx, 0
    mov ebx, 3
    div ebx
    cmp edx, 0
    je noPadding
    mov eax, 3
    sub eax, edx    ; EAX = padding needed
    
padLoop:
    cmp eax, 0
    je noPadding
    ; Shift buffer right and add '0' at beginning
    ; Implementation details below...
    dec eax
    jmp padLoop

noPadding:
    ; Convert 3-bit groups to octal digits
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET outputBuffer
    
binToOctLoop:
    cmp BYTE PTR [esi], 0
    je binToOctDone
    
    ; Process 3 bits
    mov ebx, 0
    mov ecx, 3
    
processThreeBits:
    mov al, [esi]
    cmp al, 0
    je processRemaining
    sub al, '0'
    shl ebx, 1
    or bl, al
    inc esi
    loop processThreeBits
    
processRemaining:
    add bl, '0'
    mov [edi], bl
    inc edi
    jmp binToOctLoop

binToOctDone:
    mov BYTE PTR [edi], 0
    mov edx, OFFSET outputBuffer
    call WriteString
    call CrLf
    ret
BinToOct ENDP

BinToHex PROC
    ; Get binary input
    mov edx, OFFSET binPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    
    ; Pad to multiple of 4 bits
    mov esi, OFFSET inputBuffer
    call StrLength
    mov ecx, eax
    
    ; Calculate padding (similar to octal but with 4)
    ; Convert 4-bit groups to hex digits
    
binToHexLoop:
    ; Process 4 bits at a time
    mov ebx, 0
    mov ecx, 4
    
processFourBits:
    mov al, [esi]
    cmp al, 0
    je hexConvert
    sub al, '0'
    shl ebx, 1
    or bl, al
    inc esi
    loop processFourBits
    
hexConvert:
    cmp bl, 9
    jbe hexDigit
    add bl, 7           ; Convert to 'A'-'F'
hexDigit:
    add bl, '0'
    mov [edi], bl
    inc edi
    jmp binToHexLoop
    
    ; Similar structure to BinToOct
    ret
BinToHex ENDP

OctToBin PROC
    ; Get octal input
    mov edx, OFFSET octPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET outputBuffer
    
octToBinLoop:
    mov al, [esi]
    cmp al, 0
    je octToBinDone
    
    ; Validate octal digit
    cmp al, '0'
    jb invalidOct
    cmp al, '7'
    ja invalidOct
    
    sub al, '0'
    ; Convert digit to 3-bit binary
    mov ecx, 3
    mov bl, al
    
convertOctDigit:
    shl bl, 1
    jc outputOne
    mov BYTE PTR [edi], '0'
    jmp nextBit
outputOne:
    mov BYTE PTR [edi], '1'
nextBit:
    inc edi
    loop convertOctDigit
    
    inc esi
    jmp octToBinLoop

invalidOct:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CrLf
    ret
    
octToBinDone:
    mov BYTE PTR [edi], 0
    mov edx, OFFSET outputBuffer
    call WriteString
    call CrLf
    ret
OctToBin ENDP

HexToBin PROC
    ; Get hex input
    mov edx, OFFSET hexPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET outputBuffer
    
hexToBinLoop:
    mov al, [esi]
    cmp al, 0
    je hexToBinDone
    
    ; Convert hex digit to 4-bit binary
    call HexCharToBinary  ; Separate procedure for conversion
    
    inc esi
    jmp hexToBinLoop

hexToBinDone:
    mov BYTE PTR [edi], 0
    mov edx, OFFSET outputBuffer
    call WriteString
    call CrLf
    ret
HexToBin ENDP

HexCharToBinary PROC
    ; Input: AL = hex character
    ; Output: 4 binary digits in output buffer
    
    ; Convert hex char to numeric value
    cmp al, '0'
    jb invalidHex
    cmp al, '9'
    jbe isDigit
    cmp al, 'F'
    jbe isUpper
    cmp al, 'f'
    jbe isLower
    jmp invalidHex

isDigit:
    sub al, '0'
    jmp convertToBits

isUpper:
    sub al, 'A' - 10
    jmp convertToBits

isLower:
    sub al, 'a' - 10

convertToBits:
    mov ecx, 4
    mov bl, al
    
hexBitLoop:
    shl bl, 1
    jc outputOneHex
    mov BYTE PTR [edi], '0'
    jmp nextBitHex
outputOneHex:
    mov BYTE PTR [edi], '1'
nextBitHex:
    inc edi
    loop hexBitLoop
    ret

invalidHex:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CrLf
    ret
HexCharToBinary ENDP

; -----------------------------
; Quiz Mode (Stub)
; -----------------------------
QuizMode PROC
    mov edx, OFFSET choice
    call WriteString
    ; TODO: Implement quiz logic
    ret
QuizMode ENDP

; -----------------------------
; Speed Test Mode (Stub)
; -----------------------------
SpeedTestMode PROC
    mov edx, OFFSET choice
    call WriteString
    ; TODO: Implement speed test logic
    ret
SpeedTestMode ENDP

END main


