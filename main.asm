TITLE NumeraX - Number System Converter
INCLUDE Irvine32.inc
.data
; Main Menu
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

; Direct Conversions Menu
directConvMenu BYTE \
    "=== Direct Conversions ===", 0Dh,0Ah,\
    "1. Binary to Octal", 0Dh,0Ah,\
    "2. Binary to Hexadecimal", 0Dh,0Ah,\
    "3. Octal to Binary", 0Dh,0Ah,\
    "4. Hexadecimal to Binary", 0Dh,0Ah,\
    "5. Back to Main Menu", 0Dh,0Ah,0

; General Data
userChoice DWORD ?
inputBuffer BYTE 32 DUP(0)
outputBuffer BYTE 32 DUP(0)
invalidMsg  BYTE "Invalid choice. Try again.", 0
goodbyeMsg  BYTE "Exiting program... Goodbye!", 0

; Two's Complement Data
msg1 byte "Enter number : ",0
two_c_print byte "Two's complement : ",0
buffer byte 33 DUP(0) ,0
final byte 33 DUP(0) ,0

; Prompt Messages
directChoice BYTE "Choose conversion type: ", 0
choice BYTE "Enter your choice: ", 0
decPrompt BYTE "Enter decimal number: ", 0
binPrompt BYTE "Enter binary number: ", 0
octPrompt BYTE "Enter octal number: ", 0
hexPrompt BYTE "Enter hexadecimal number: ", 0

; Quiz Mode Data
quizTitle BYTE "=== QUIZ MODE ===", 0
quizScoreMsg BYTE "Score: ", 0
quizTotalMsg BYTE " out of ", 0
quizCorrect BYTE "Correct! Well done!", 0
quizWrong BYTE "Wrong! The correct answer is: ", 0

questionBuffer BYTE 64 DUP(0)
userAnswerBuffer BYTE 32 DUP(0)
correctAnswerBuffer BYTE 32 DUP(0)
tempDecBuffer BYTE 32 DUP(0)

numQuestions DWORD 5
currentQuestion DWORD 0
correctAnswers DWORD 0

quizTypeMenu BYTE \
    "=== QUIZ TYPE SELECTION ===", 0Dh,0Ah,\
    "1. Random Questions (Mixed types)", 0Dh,0Ah,\
    "2. Specific Conversion Type", 0Dh,0Ah,\
    "3. Back to Main Menu", 0Dh,0Ah,0

quizTypePrompt BYTE "Choose quiz type: ", 0
selectedQuizType DWORD ?
questionType DWORD -1

specificTypeMenu BYTE \
    "=== SELECT CONVERSION TYPE ===", 0Dh,0Ah,\
    "1. Decimal to Binary", 0Dh,0Ah,\
    "2. Decimal to Octal", 0Dh,0Ah,\
    "3. Decimal to Hexadecimal", 0Dh,0Ah,\
    "4. Binary to Decimal", 0Dh,0Ah,\
    "5. Binary to Octal", 0Dh,0Ah,\
    "6. Binary to Hexadecimal", 0Dh,0Ah,\
    "7. Octal to Decimal", 0Dh,0Ah,\
    "8. Octal to Binary", 0Dh,0Ah,\
    "9. Octal to Hexadecimal", 0Dh,0Ah,\
    "10. Hexadecimal to Decimal", 0Dh,0Ah,\
    "11. Hexadecimal to Binary", 0Dh,0Ah,\
    "12. Hexadecimal to Octal", 0Dh,0Ah,\
    "13. Back to Quiz Type Menu", 0Dh,0Ah,0

specificTypePrompt BYTE "Choose conversion type: ", 0
promptNumQuestions BYTE "Enter the number of questions: ", 0
progressMsg BYTE "Question ", 0
quizPercentageMsg BYTE "Percentage: ", 0
userAnswerPrompt BYTE "Your answer: ", 0
playAgainPrompt BYTE "Play again? (1=Yes, 2=No): ", 0

; Question Templates
decToBinQText BYTE "Convert decimal to binary: ", 0
decToOctQText BYTE "Convert decimal to octal: ", 0
decToHexQText BYTE "Convert decimal to hexadecimal: ", 0
binToDecQText BYTE "Convert binary to decimal: ", 0
binToOctQText BYTE "Convert binary to octal: ", 0
binToHexQText BYTE "Convert binary to hexadecimal: ", 0
octToDecQText BYTE "Convert octal to decimal: ", 0
octToBinQText BYTE "Convert octal to binary: ", 0
octToHexQText BYTE "Convert octal to hexadecimal: ", 0
hexToDecQText BYTE "Convert hexadecimal to binary: ", 0
hexToBinQText BYTE "Convert hexadecimal to decimal: ", 0
hexToOctQText BYTE "Convert hexadecimal to octal: ", 0

.code
main PROC
    call Clrscr
    call Randomize
    mov edi, OFFSET outputBuffer
    mov ecx, LENGTHOF outputBuffer
    dec ecx
    xor eax, eax
    rep stosb
    mov BYTE PTR [edi], 0

mainMenuLoop:
    mov edx, OFFSET menuTitle
    call WriteString
    call CRLF

    mov edx, OFFSET menuOptions
    call WriteString
    call CRLF

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

    mov edx, OFFSET invalidMsg
    call WriteString
    call CRLF
    jmp mainMenuLoop

do_DecToBin:
    mov edx, OFFSET decPrompt
    call WriteString
    call ReadDec
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
    call CRLF
    jmp mainMenuLoop

ExitProgram:
    mov edx, OFFSET goodbyeMsg
    call WriteString
    call CRLF
    exit
main ENDP

; Decimal to Binary
DecToBin PROC
    mov ecx, 32
    mov ebx, eax
    lea edi, outputBuffer
    add edi, 31
    mov BYTE PTR [edi+1], 0

decToBinLoop:
    mov eax, ebx
    and eax, 1
    add al, '0'
    mov [edi], al
    shr ebx, 1
    dec edi
    loop decToBinLoop

    mov edx, OFFSET outputBuffer
    call WriteString
    call CRLF
    ret
DecToBin ENDP

; Decimal to Octal
DecToOct PROC
    mov edx, OFFSET decPrompt
    call WriteString
    call ReadInt

    mov ebx, eax
    lea edi, outputBuffer
    add edi, 31
    mov BYTE PTR [edi+1], 0

decToOctLoop:
    mov eax, ebx
    xor edx, edx
    mov ecx, 8
    div ecx
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
    call CRLF
    ret
DecToOct ENDP

; Decimal to Hexadecimal
DecToHex PROC
    mov edx, OFFSET decPrompt
    call WriteString
    call ReadInt

    mov ebx, eax
    lea edi, outputBuffer
    add edi, 31
    mov BYTE PTR [edi+1], 0

decToHexLoop:
    mov eax, ebx
    xor edx, edx
    mov ecx, 16
    div ecx
    cmp dl, 9
    jbe decToHexDigit
    add dl, 7
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
    call CRLF
    ret
DecToHex ENDP

; Get and Validate Binary Input
GetBinaryInput PROC
    mov edx, OFFSET binPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    
    mov esi, OFFSET inputBuffer
    xor eax, eax
    
validateBinaryLoop:
    mov bl, [esi]
    cmp bl, 0
    je validationSuccess
    cmp bl, '0'
    jb validationError
    cmp bl, '1'
    ja validationError
    shl eax, 1
    sub bl, '0'
    add eax, ebx
    inc esi
    jmp validateBinaryLoop

validationError:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CRLF
    stc
    ret

validationSuccess:
    clc
    ret
GetBinaryInput ENDP

; Binary to Decimal
BinToDec PROC
    call GetBinaryInput
    jc binToDecExit
    call WriteDec
    call CRLF
binToDecExit:
    ret
BinToDec ENDP

; Octal to Decimal
OctToDec PROC
    mov edx, OFFSET octPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString

    mov esi, OFFSET inputBuffer
    xor eax, eax
    xor ebx, ebx
octToDecLoop:
    mov bl, [esi]
    cmp bl, 0
    je octToDecDone
    sub bl, '0'
    imul eax, 8
    add eax, ebx
    inc esi
    jmp octToDecLoop
octToDecDone:
    call WriteInt
    call CRLF
    ret
OctToDec ENDP

; Hexadecimal to Decimal
HexToDec PROC
    mov edx, OFFSET hexPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString

    mov esi, OFFSET inputBuffer
    xor eax, eax
hexToDecLoop:
    movzx ebx, BYTE PTR [esi]
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
    sub bl, 32
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
    call CRLF
    ret
HexToDec ENDP

; Two's Complement
TwosComplement PROC
    mov edx, OFFSET msg1 
    call WriteString

    mov edx, OFFSET buffer
    mov ecx, 32
    call ReadString

    mov esi, OFFSET buffer
    mov ecx, 0
validateLoop:
    mov al, [esi]
    cmp al, 0
    je startConversion
    cmp al, '0'
    jb invalidBinaryTC
    cmp al, '1'
    ja invalidBinaryTC
    inc esi
    inc ecx
    jmp validateLoop

invalidBinaryTC:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CRLF
    ret

startConversion:
    cmp ecx, 0
    je invalidBinaryTC
    
    mov edi, OFFSET final
    mov ecx, LENGTHOF final
    call ClearBuffer
    
    mov esi, OFFSET buffer
    mov edi, OFFSET final

    mov ecx, 0
copyInput:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    inc ecx
    cmp al, 0
    jne copyInput
    mov esi, OFFSET final
invertLoop:
    mov al, [esi]
    cmp al, 0
    je addOne
    cmp al, '0'
    je make1
    mov BYTE PTR [esi], '0'
    jmp nextInvert
make1:
    mov BYTE PTR [esi], '1'
nextInvert:
    inc esi
    jmp invertLoop

addOne:
    mov esi, OFFSET final
findEnd: 
    cmp BYTE PTR [esi], 0
    je doAdd
    inc esi
    jmp findEnd

doAdd:
    dec esi
    mov bl, 1

addLoop:
    cmp esi, OFFSET final
    jb displayResult
    
    mov al, [esi]
    cmp al, '0'
    je handleZero
    cmp bl, 1
    jne noChange
    mov BYTE PTR [esi], '0'
    jmp nextDigit
handleZero:
    cmp bl, 1
    jne noChange
    mov BYTE PTR [esi], '1'
    mov bl, 0
noChange:
nextDigit:
    dec esi
    jmp addLoop

displayResult:
    mov edx, OFFSET two_c_print 
    call WriteString
    mov edx, OFFSET final
    call WriteString
    call CRLF
    call WaitMsg
    ret
TwosComplement ENDP

; Direct Conversions Menu
DirectConversions PROC
    call Clrscr
directMenuLoop:
    mov edx, OFFSET directConvMenu
    call WriteString
    call CRLF
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
    call CRLF
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

; Binary to Octal
BinToOct PROC
    call GetBinaryInput
    jc binToOctExit
    call DecimalToOctalString
    mov edx, OFFSET correctAnswerBuffer
    call WriteString
    call CRLF
binToOctExit:
    ret
BinToOct ENDP

; -----------------------------
; Binary to Hexadecimal
; -----------------------------
BinToHex PROC
    call GetBinaryInput
    jc binToHexExit
    call DecimalToHexString
    mov edx, OFFSET correctAnswerBuffer
    call WriteString
    call CRLF
binToHexExit:
    ret
BinToHex ENDP

; Octal to Binary
OctToBin PROC
    mov edx, OFFSET octPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    mov edi, OFFSET userAnswerBuffer
    mov ecx, LENGTHOF userAnswerBuffer
    mov al, 0
    rep stosb
    
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET userAnswerBuffer
    
octToBinLoop:
    mov al, [esi]
    cmp al, 0
    je octToBinDone
    
    cmp al, '0'
    jb invalidOct
    cmp al, '7'  
    ja invalidOct
    
    cmp al, '0'
    je digit_0
    cmp al, '1'
    je digit_1
    cmp al, '2'
    je digit_2
    cmp al, '3'
    je digit_3
    cmp al, '4'
    je digit_4
    cmp al, '5'
    je digit_5
    cmp al, '6'
    je digit_6
    cmp al, '7'
    je digit_7

digit_0:
    mov DWORD PTR [edi], '000'
    jmp next_digit
digit_1:
    mov DWORD PTR [edi], '100'
    jmp next_digit
digit_2:
    mov DWORD PTR [edi], '010'
    jmp next_digit
digit_3:
    mov DWORD PTR [edi], '110'
    jmp next_digit
digit_4:
    mov DWORD PTR [edi], '001'
    jmp next_digit
digit_5:
    mov DWORD PTR [edi], '101'
    jmp next_digit
digit_6:
    mov DWORD PTR [edi], '011'
    jmp next_digit
digit_7:
    mov DWORD PTR [edi], '111'

next_digit:
    add edi, 3
    inc esi
    jmp octToBinLoop

invalidOct:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CRLF
    ret
    
octToBinDone:
    mov BYTE PTR [edi], 0
    mov edx, OFFSET userAnswerBuffer
    call WriteString
    call CRLF
    ret
OctToBin ENDP

; Hexadecimal to Binary
HexToBin PROC
    mov edx, OFFSET hexPrompt
    call WriteString
    mov edx, OFFSET inputBuffer
    mov ecx, SIZEOF inputBuffer
    call ReadString
    
    mov edi, OFFSET userAnswerBuffer
    mov ecx, LENGTHOF userAnswerBuffer
    mov al, 0
    rep stosb
    
    mov esi, OFFSET inputBuffer
    mov edi, OFFSET userAnswerBuffer
    
hexToBinLoop:
    mov al, [esi]
    cmp al, 0
    je hexToBinDone
    
    cmp al, 'a'
    jb not_lower
    cmp al, 'f'
    ja not_lower
    sub al, 32
not_lower:
    cmp al, '0'
    je hex_0
    cmp al, '1'
    je hex_1
    cmp al, '2'
    je hex_2
    cmp al, '3'
    je hex_3
    cmp al, '4'
    je hex_4
    cmp al, '5'
    je hex_5
    cmp al, '6'
    je hex_6
    cmp al, '7'
    je hex_7
    cmp al, '8'
    je hex_8
    cmp al, '9'
    je hex_9
    cmp al, 'A'
    je hex_A
    cmp al, 'B'
    je hex_B
    cmp al, 'C'
    je hex_C
    cmp al, 'D'
    je hex_D
    cmp al, 'E'
    je hex_E
    cmp al, 'F'
    je hex_F
    jmp invalidHex

hex_0: mov DWORD PTR [edi], '0000'
jmp next_hex
hex_1: mov DWORD PTR [edi], '1000'
jmp next_hex
hex_2: mov DWORD PTR [edi], '0100'
jmp next_hex
hex_3: mov DWORD PTR [edi], '1100'
jmp next_hex
hex_4: mov DWORD PTR [edi], '0010'
jmp next_hex
hex_5: mov DWORD PTR [edi], '1010'
jmp next_hex
hex_6: mov DWORD PTR [edi], '0110'
jmp next_hex
hex_7: mov DWORD PTR [edi], '1110'
jmp next_hex
hex_8: mov DWORD PTR [edi], '0001'
jmp next_hex
hex_9: mov DWORD PTR [edi], '1001'
jmp next_hex
hex_A: mov DWORD PTR [edi], '0101'
jmp next_hex
hex_B: mov DWORD PTR [edi], '1101'
jmp next_hex
hex_C: mov DWORD PTR [edi], '0011'
jmp next_hex
hex_D: mov DWORD PTR [edi], '1011'
jmp next_hex
hex_E: mov DWORD PTR [edi], '0111'
jmp next_hex
hex_F: mov DWORD PTR [edi], '1111'
jmp next_hex

next_hex:
    add edi, 4
    inc esi
    jmp hexToBinLoop

invalidHex:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CRLF
    ret
    
hexToBinDone:
    mov BYTE PTR [edi], 0
    mov edx, OFFSET userAnswerBuffer
    call WriteString
    call CRLF
    ret
HexToBin ENDP

;====== Quiz Mode
QuizMode PROC
    call Clrscr
    selectQuizType:
        mov edx, OFFSET quizTitle
        call WriteString
        call Crlf
        mov edx, OFFSET quizTypeMenu
        call WriteString
        call Crlf
        mov edx, OFFSET quizTypePrompt
        call WriteString
        call ReadDec
        mov selectedQuizType, eax
        cmp selectedQuizType, 3
        je backToMain
        cmp selectedQuizType, 2
        je specificType
        cmp selectedQuizType, 1
        je RandomType
        mov edx, OFFSET invalidMsg
        call WriteString
        call CRLF
    jmp selectQuizType
    specificType:
    mov edx, OFFSET specificTypeMenu
    call WriteString
    call CRLF
    mov edx, OFFSET specificTypePrompt
    call WriteString
    call ReadDec
    cmp eax, 13
    je selectQuizType
    mov questionType, eax 
    jmp startQuiz

    RandomType:
    mov questionType, -1

    startQuiz:
    mov correctAnswers, 0
    mov currentQuestion, 0
    call CRLF
    mov edx, OFFSET promptNumQuestions
    call WriteString
    call ReadInt
    mov numQuestions, eax
    call CRLF
    call RunQuiz
    call DisplayQuizResults
    call AskPlayAgain
    backtoMain:
    ret
QuizMode ENDP

RunQuiz PROC
    mov edi, OFFSET questionBuffer
    mov ecx, LENGTHOF questionBuffer
    call ClearBuffer

    mov edi, OFFSET correctAnswerBuffer
    mov ecx, LENGTHOF correctAnswerBuffer
    call ClearBuffer
    mov ecx, numQuestions
quizLoop:
    push ecx
    cmp questionType, -1
    jne getQuestion
    call GenerateRandomNumber
    getQuestion:
    call GenerateQuestion
    getAnswer:

    pop ecx
loop quizLoop
    ret
RunQuiz ENDP

GenerateRandomNumber PROC
    mov eax, 12
    call RandomRange
    inc eax
    mov questionType, eax
    ret
GenerateRandomNumber ENDP

GenerateQuestion PROC
    mov eax, questionType
    cmp questionType, 1
    je DeciToBin
    cmp questionType, 2
    je DeciToOct
    cmp questionType, 3
    je DeciToHex
    cmp questionType, 4
    je BinToDeci
    cmp questionType, 5
    je BinToOct
    cmp questionType, 6
    je BinToHex
    cmp questionType, 7
    je OctToDeci
    cmp questionType, 8
    je OctToBin
    cmp questionType, 9
    je OctToHex
    cmp questionType, 10
    je HexToDeci
    cmp questionType, 11
    je HexToBin
    cmp questionType, 12
    je HexToOct
    jmp invalidQuestionType
    
    DeciToBin:
    mov edx, OFFSET decToBinQText
    call WriteString
    mov eax, 256
    call RandomRange
    mov questionBuffer, eax
    call WriteInt
    call CRLF
    call DecToBin
    ;This should return binary in eax or something and that would be stored in correctAnswerBuffer
    jmp done
    
    DeciToOct:
    mov edx, OFFSET decToOctQText
    call WriteString
    
    jmp done
    
    DeciToHex:
    mov edx, OFFSET deciToHexQText
    call WriteString
    
    jmp done
    
    BinToDeci:
    mov edx, OFFSET binToDeciQText
    call WriteString
    
    jmp done
    
    BinToOct:
    mov edx, OFFSET binToOctQText
    call WriteString
    
    jmp done
    
    BinToHex:
    mov edx, OFFSET binToHexQText
    call WriteString
    
    jmp done
    
    OctToDeci:
    mov edx, OFFSET octToDeciQText
    call WriteString
    
    jmp done
    
    OctToBin:
    mov edx, OFFSET octToBinQText
    call WriteString
    
    jmp done
    
    OctToHex:
    mov edx, OFFSET octToHexQText
    call WriteString
    
    jmp done
    
    HexToDeci:
    mov edx, OFFSET hexToDeciQText
    call WriteString
    
    jmp done
    
    HexToBin:
    mov edx, OFFSET hexToBinQText
    call WriteString
    
    jmp done

    HexToOct:
    mov edx, OFFSET hexToOctQText
    call WriteString

    jmp done
    
    invalidQuestionType:
    mov edx, OFFSET invalidMsg
    call WriteString
    call CRLF
    call QuizMode
    done:
    ret
GenerateQuestion ENDP

; Utilities
ClearBuffer PROC
    push edi              
    mov edi, esi          
    xor al, al            
ClearLoop:
    mov [edi], al        
    inc edi
    loop ClearLoop
    pop edi
    ret
ClearBuffer ENDP
; -----------------------------
; Speed Test Mode (Stub)
; -----------------------------
SpeedTestMode PROC
    mov edx, OFFSET hexPrompt
    call WriteString
    ; TODO: Implement speed test logic
    ret
SpeedTestMode ENDP

; Conversions
DecimalToBinaryString PROC
    pushad
    mov ebx, eax
    mov edi, OFFSET correctAnswerBuffer
    add edi, 31
    mov BYTE PTR [edi+1], 0
    mov ecx, 32
binConvertLoop:
    mov eax, ebx
    and eax, 1
    add al, '0'
    mov [edi], al
    shr ebx, 1
    dec edi
    loop binConvertLoop
    mov esi, OFFSET correctAnswerBuffer
findFirstOne:
    cmp BYTE PTR [esi], '1'
    je foundStart
    cmp BYTE PTR [esi], 0
    je allZero
    inc esi
    jmp findFirstOne

allZero:
    mov edi, OFFSET correctAnswerBuffer
    mov BYTE PTR [edi], '0'
    mov BYTE PTR [edi+1], 0
    jmp doneBin

foundStart:
    mov edi, OFFSET correctAnswerBuffer
shiftLoop:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne shiftLoop

doneBin:
    mov byte ptr [edi], 0
    popad
    ret
DecimalToBinaryString ENDP

DecimalToOctalString PROC
    pushad
    mov ebx, eax
    mov edi, OFFSET correctAnswerBuffer
    add edi, 31
    mov BYTE PTR [edi+1], 0
octConvertLoop:
    mov eax, ebx
    xor edx, edx
    mov ecx, 8
    div ecx
    add dl, '0'
    mov [edi], dl
    mov ebx, eax
    cmp ebx, 0
    je doneOct
    dec edi
    jmp octConvertLoop

doneOct:
    mov esi, edi
    mov edi, OFFSET correctAnswerBuffer
shiftOct:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne shiftOct
    mov byte ptr [edi], 0 
    popad
    ret
DecimalToOctalString ENDP

DecimalToHexString PROC
    pushad
    mov ebx, eax
    mov edi, OFFSET correctAnswerBuffer
    add edi, 31
    mov BYTE PTR [edi+1], 0
hexConvertLoop:
    mov eax, ebx
    xor edx, edx
    mov ecx, 16
    div ecx
    cmp dl, 9
    jbe hexDigit
    add dl, 7
hexDigit:
    add dl, '0'
    mov [edi], dl
    mov ebx, eax
    cmp ebx, 0
    je doneHex
    dec edi
    jmp hexConvertLoop

doneHex:
    mov esi, edi
    mov edi, OFFSET correctAnswerBuffer
shiftHex:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    cmp al, 0
    jne shiftHex
    mov byte ptr [edi], 0 
    popad
    ret
DecimalToHexString ENDP


END main