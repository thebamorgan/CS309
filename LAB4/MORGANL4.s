@ Filename: MORGANL4.S
@ Author:   Ben Morgan
@ Email:    bam0043@uah.edu
@ Term:     CS309-01 2022
@ Purpose:   
@ The program is to prompt the user to enter a number between 1 and 100. 
@ Reject any invalid user inputs and terminate the program if invalid inputs are entered.
@ From 1 to the user entered number print out the number and the sum of all the integers to that point.
@ Terminate the program when all the numbers from 1 to the user entered number is printed.

@ Example of what the output should look like:
@ This program will print the sum of the integers from 1 to a number you enter. Please enter an
@ integer from 1 to 100.

@ You entered 4. Following is the number and the sum of the integers from 1 to n. 
@ Number  Sum 
@ 1       1 
@ 2       3 
@ 3       6 
@ 4       10

@ Use these commands to assemble, link, run and debug this program:
@    as -o MORGANL4.o MORGANL4.s
@    gcc -o MORGANL4 MORGANL4.o
@    ./MORGANL4 ;echo $?
@    gdb --args ./MORGANL4 

.equ READERROR, 0 @Used to check for scanf read error. 

.global main
main:

prompt:

    ldr r0, = strInputPrompt
    bl printf

get_input:

    ldr r0, = numInputPattern
    ldr r1, =intInput

    bl  scanf 
    
    cmp r0, #READERROR             
    beq readerror          
    ldr r1, =intInput       
    ldr r1, [r1]

    cmp r1, #100 @performs r1-101.
    bgt invalidInput @should break if r1 is greater than or equal to 101.
    
    cmp r1, #1
    blt invalidInput
	
	mov r6, r1
	
	ldr r0, = strOutputNum @ Will tell the value to user
    bl printf
    
    mov r5, #0
    mov r4, #0

	
mathLoop: @Figure out how to make this work
	@r5 = i, r1=n, r4 = sum = 0, move i #0
	
	cmp r5, r6
	bge myexit
	add r4, r4, r5
	add r5, r5, #1
    @ print indexer then sum
    mov r1, r5
    bl printf

    mov r1, r4
    bl printf

	b mathLoop
	
invalidInput:
    ldr r0, = isGreater
    bl printf
    bl myexit
readerror:

    ldr r0, = strInputPattern
    ldr r1, = strInputError
    bl scanf

    b prompt

myexit:

    mov r7, #0x01 //Satisfies requirement 8
    svc 0

.data

.balign 4
isGreater: .asciz "Invalid input, terminating.\n"

.balign 4
isLess: .asciz "The number is less than or equal to 100.\n"

.balign 4
strInputPrompt: .asciz "This program will print the sum of the integers from 1 to a number you enter. Please enter an integer from 1 to 100: \n" 

.balign 4
strOutputNum: .asciz "You entered %d. Below is the number and the sum of the integers from 1 to n.  \n" @Satisfies requirement 2
@ Format pattern for scanf call.

.balign 4
numInputPattern: .asciz "%d"  @ integer format for read. 

.balign 4
strInputPattern: .asciz "%[^\n]" @ Used to clear the input buffer for invalid input. 

.balign 4
strInputError: .skip 100*4  @ User to clear the input buffer for invalid input. 

.balign 4
intInput: .word 0   @ Location used to store the user input. 


@ Let the assembler know these are the C library functions. 

.global printf

.global scanf

@ End of code and end of file. Leave a blank line after this.
