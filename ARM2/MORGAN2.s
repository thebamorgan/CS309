@ Filename: MORGAN2.S
@ Author:   Ben Morgan
@ Email:    bam0043@uah.edu
@ Term:     CS309-01 2022
@ Purpose:  1. Prompt the user for an input number (integer). [Already in program]

@           2. Print the input number back to the screen. [Already in program]

@           3. Prompt the user for an input character. [New function].  Use "%s" instead of "%c" for the input. This will keep from reading the CR from the previous input. 

@           4. Print the input character back to the screen. [New function]. Use "%c" for the output. 

@           5. Return control back to the operating system. [Already in program]
@
@ Use these commands to assemble, link, run and debug this program:
@    as -o MORGAN2.o MORGAN2.s
@    gcc -o MORGAN2 MORGAN2.o
@    ./MORGAN2 ;echo $?
@    gdb --args ./MORGAN2 

.equ READERROR, 0 @Used to check for scanf read error. 

.global main @ Have to use main because of C library uses. 
main:

prompt:

    ldr r0, = strInputPrompt @ 1. Prompt the user for an input number (integer).
    bl printf

get_input:

    ldr r0, = numInputPattern
    ldr r1, =intInput

    bl  scanf 
    cmp r0, #READERROR             
    beq readerror          
    ldr r1, =intInput       
    ldr r1, [r1]

    ldr r0, = strOutputNum @ 2. Print the input number back to the screen. [Already in program]
    bl printf
    @b myexit

charPrompt:

    ldr r0, = charInputPrompt @ 3. Prompt the user for an input character.
    bl printf

getCharInput:

    ldr r0, = charInputPattern
    ldr r1, = charInput

    bl scanf
    cmp r0, #charreaderror
    beq charreaderror
    ldr r1, = charInput
    ldr r1, [r1]

    ldr r0, = charOutput @ 4. Print the input character back to the screen.
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

    mov r7, #0x01 @ 5. Return control back to the operating system.
    svc 0

.data

.balign 4
strInputPrompt: .asciz "Input the number: \n" @Satisfies requirement 1

.balign 4
strOutputNum: .asciz "The number value is: %d \n" @Satisfies requirement 2

.balign 4
charInputPrompt: .asciz "Input a character: \n" @Satisfies requirement 3

.balign 4
charOutput: .asciz "The character value is: %c \n" @Satisfies requirement 4

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
