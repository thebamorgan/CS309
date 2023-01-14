@ File:    MORGAN1.s
@ Author:  Ben Morgan
@
@ Use these commands to assemble, link, run and debug the program
@
@  as -o MORGAN1.o MORGAN1.s
@  gcc -o MORGAN1 MORGAN1.o
@ ./MORGAN1 ;echo $?
@ gdb --args ./MORGAN1
@
@ If you get an error from the as (assembler) command AND it does not call out a line
@ number, check to make sure the current default directory contains the file.
@
@ If your codes executes with no errors but your string is not printing then
@ you have forgotten the end your string with \n. 
@

@ ************
@ The = (equal sign) is used in the ARM Assembler to get the address of a
@ label declared in the .data section. This takes the place of the ADR
@ instruction used in the textbook. 
@ ************

.global main 
main:        @Must use this label where to start executing the code. 



    MOV   r7, #0x04    @ A 4 is a write command and has to be in r7.
    MOV   r0, #0x01    @ 01 is the STD (standard) output device. 
    MOV   r2, #0x18   @ Length of string to print (in Hex).
    LDR   r1, =string1 @ Put address of the start of the string in r1
    SVC   0            @ Do the system call

    LDR  r0, =string2 @ Put address of string in r0
    BL   printf       @ Make the call to printf

@ Part 3 - Use the System Service Call to print the following string "This is my first ARM Assembly program for CS309-01 <Term Year>"
    MOV   r7, #0x04    @ A 4 is a write command and has to be in r7.
    MOV   r0, #0x01    @ 01 is the STD (standard) output device. 
    MOV   r2, #0x39   @ Length of string to print (in Hex).
    LDR   r1, =string3 @ Put address of the start of the string in r1
    SVC   0            @ Do the system call

@ Force the exit of this program and return command to OS.

    MOV  r7, #0X01
    SVC  0

@ Declare the stings

.data       @ Lets the OS know it is OK to write to this area of memory. 

@String 1 uses the system service call technique to output my full name as a string
.balign 4   @ Force a word boundry.
string1: .asciz "Benjamin Albert Morgan\n"  @Length 0x18

@String 2 uses the C++ function call to printf a string with my UAH email address
.balign 4   @ Force a word boundry
string2: .asciz "bam0043@uah.edu\n" @Length 0x11

@String 3
.balign 4
string3: .asciz "This is my first ARM Assembly program for CS309-01 2022\n" @Length 0x39

.global printf
@  To use printf:
@     r0 - Contains the starting address of the string to be printed. The string
@          must conform to the C coding standards.
@     r1 - If the string contains an output parameter i.e., %d, %c, etc. register
@          r1 must contain the value to be printed. 
@ When the call returns registers: r0, r1, r2, r3 and r12 are changed. 

@end of code and end of file. Leave a blank line after this. 
