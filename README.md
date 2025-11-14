# NumeraX — Number System Converter  
### *(Assembly Language | COAL Course Project)*

NumeraX is an educational **Number System Converter** built entirely in **MASM Assembly** using the **Irvine32** library.  
It helps students understand and practice number system conversions interactively, making concepts of **decimal, binary, octal, and hexadecimal** easier to learn.

This project also includes **Quiz Mode**, **Speed Test Mode**, and **Two’s Complement Representation**, making it more than just a calculator — it is a complete **learning tool** for COAL students.


# Features

### **Number System Conversions**
- Decimal → Binary  
- Decimal → Octal  
- Decimal → Hexadecimal  
- Binary / Octal / Hexadecimal → Decimal  
- Direct Conversions:
  - Binary ↔ Octal  
  - Binary ↔ Hexadecimal  
  - Octal ↔ Hexadecimal  


## Advanced Features

### **Error Handling**
- Detects invalid digits  
  *(e.g., entering `2` for a binary number)*

### **Two’s Complement Representation**
- Shows **signed** and **unsigned** interpretations of binary values

### **Conversion History** *(Optional)*
- Stores last few conversions  
- Displays them on request  


## Interactive Learning Modes

### **Quiz Mode**
- Generates random conversion questions  
- Takes user input  
- Validates answer  
- Displays score  

### **Speed Test Mode**
- User chooses **5 or 10 questions**  
- Timer starts & ends automatically  
- Shows:
  - Number of correct answers  
  - Total time taken  


## 🛠 Tech Stack

| Component  | Technology             |
|-----------|------------------------|
| Language  | MASM x86 Assembly      |
| Library   | Irvine32               |
| IDE       | Visual Studio          |
| Debugger  | Visual Studio Debugger |
| OS        | Windows                |


## Project Structure
NumeraX/
│
├── main.asm ; Main menu + program controller
├── convert_decimal.asm ; Decimal → Binary/Octal/Hex conversions
├── convert_to_decimal.asm ; Binary/Octal/Hex → Decimal
├── convert_direct.asm ; Binary ↔ Octal/Hexadecimal conversions
├── twos_complement.asm ; Signed/Unsigned binary interpreter
├── quiz.asm ; Quiz Mode functionality
├── speed_test.asm ; Speed Test Mode functionality
├── utils.asm ; Validation, string handling, timing
├── README.md ; Project documentation
└── /Include/Irvine32.inc ; Irvine32 library


## Team Members

| Role | Name | Roll No. |
|------|-----------------------|----------|
| **Leader** | Abeeha Binte Aamer | 24k0940 |
| Member | Aamna Rizwan | 24k0695 |
| Member | Laiba Khan | 24k0644 |




