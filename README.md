NumeraX — Number System Converter (Assembly | COAL Project)

NumeraX is an educational Number System Converter built entirely in MASM Assembly using the Irvine32 library.
It helps students understand and practice number system conversions interactively, making concepts of decimal, binary, octal, and hexadecimal easier to learn.

This project also includes Quiz Mode, Speed Test Mode, and Two’s Complement representation, making it much more than a simple calculator — it is a learning tool.

🚀 Features
🔢 Number System Conversions

Decimal → Binary
Decimal → Octal
Decimal → Hexadecimal
Binary / Octal / Hexadecimal → Decimal
Direct Conversions:
Binary ↔ Octal
Binary ↔ Hexadecimal
Octal ↔ Hexadecimal

⚙️ Advanced Features
❗ Error Handling
Detects invalid digits (e.g., entering 2 for a binary value)

🧮 Two’s Complement Representation
Shows signed and unsigned interpretations of binary numbers

🕒 Conversion History (optional feature)
Stores last few conversions and displays them on command

🎮 Interactive Learning Modes
1️⃣ Quiz Mode

Random conversion questions
User enters answer
Program checks correctness
Shows total score

2️⃣ Speed Test Mode

User selects number of questions (5 or 10)
Timer starts & ends automatically
Shows correct answers + total time

🛠 Tech Stack
Component	Technology
Language	MASM x86 Assembly
Library	Irvine32
IDE	Visual Studio
Debugger	Visual Studio Debugger
OS	Windows

Project Structure
NumeraX/
│
├── main.asm              ; Main menu + program controller
├── convert_decimal.asm   ; Decimal → Binary/Octal/Hex functions
├── convert_to_decimal.asm; Binary/Octal/Hex → Decimal
├── convert_direct.asm    ; Binary ↔ Octal/Hexadecimal
├── twos_complement.asm   ; Signed/Unsigned binary interpreter
├── quiz.asm              ; Quiz Mode
├── speed_test.asm        ; Speed Test Mode
├── utils.asm             ; String handling, validation, timing
├── README.md             ; Project documentation
└── /Include/Irvine32.inc ; Irvine library


👥 Team Members
Leader:  Abeeha Binte Aamer 24k0940
Member 1:  Aamna Rizwan 24k0695
Member 2: Laiba Khan 24k0644
