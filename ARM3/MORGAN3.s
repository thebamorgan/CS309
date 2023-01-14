@ Filename: MORGAN3.S
@ Author:   Ben Morgan
@ Email:    bam0043@uah.edu
@ Term:     CS309-01 2022
@ Purpose:   1. Prompt for the user to enter a number (integer). 

@            2. If the entered number is <100 print: "The input number is less than 100."

@            3. If the entered number is >=100 print: "The input number is greater than or equal to 100."

@            4. Prompt for the user to enter a single character. 

@            5. If the entered character is lower case (a..z) print: "Lower case letter entered."

@            6. If the entered character is upper case (A..Z) print: "Upper case letter entered."

@            7. Otherwise print: "Special character entered."

@            8. Return control to the operating system. 
@
@ Use these commands to assemble, link, run and debug this program:
@    as -o MORGAN3.o MORGAN3.s
@    gcc -o MORGAN3 MORGAN3.o
@    ./MORGAN3 ;echo $?
@    gdb --args ./MORGAN3 

.equ READERROR, 0 @Used to check for scanf read error. 

.global main
main:

prompt:

    ldr r0, = strInputPrompt //Satisfies requirement 1
    bl printf

get_input:

    ldr r0, = numInputPattern
    ldr r1, =intInput

    bl  scanf 
    cmp r0, #READERROR             
    beq readerror          
    ldr r1, =intInput       
    ldr r1, [r1]

    cmp r1, #100
    bpl greaterThan

    ldr r0, = isLess //Satisfies requirement 2
    bl printf

charPrompt:

    ldr r0, = charInputPrompt //Satisfies requirement 4
    bl printf

getCharInput:

    ldr r0, = charInputPattern
    ldr r1, = charInput

    bl scanf
    cmp r0, #charreaderror
    beq charreaderror
    ldr r1, = charInput
    ldr r1, [r1]

    cmp r1, #'A'
    blt specialChar

    cmp r1, #'['
    blt upperCase

    cmp r1, #'a'
    blt specialChar

    cmp r1, #'{'
    blt lowerCase

    b specialChar


greaterThan:

    ldr r0, = isGreater //Satisfies requirement 3
    bl printf

    b charPrompt

upperCase:

    ldr r0, = isUpper //Satisfies requirement 6
    bl printf

    b myexit


lowerCase:
    
    ldr r0, = isLower //Satisfies requirement 5
    bl printf
    b myexit

specialChar:
    
    ldr r0, = isSpecial //Satisfies requirement 7
    bl printf

    b myexit

readerror:

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b prompt

charreaderror:

    ldr r0, = charInputPattern
    ldr r1, = charInputError
    bl scanf

    b charPrompt 

myexit:

    mov r7, #0x01 //Satisfies requirement 8
    svc 0

.data

.balign 4
isGreater: .asciz "The number is greater than or equal to 100.\n"

.balign 4
isLess: .asciz "The number is less than 100.\n"

.balign 4
isLower: .asciz "The input is lowercase.\n"

.balign 4
isUpper: .asciz "The input is upppercase.\n"

.balign 4
isSpecial: .asciz "The input is a sepcial character.\n"



.balign 4
strInputPrompt: .asciz "Input a number: \n" 


.balign 4
charInputPrompt: .asciz "Input a character: \n"


@ Format pattern for scanf call.

.balign 4
charInputPattern: .asciz "%s" @ string format for read

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
charInputError: .skip 100*4

.balign 4
intInput: .word 0   @ Location used to store the user input. 

.balign 4
charInput: .word 0

@ Let the assembler know these are the C library functions. 

.global printf

.global scanf

@ End of code and end of file. Leave a blank line after this.
