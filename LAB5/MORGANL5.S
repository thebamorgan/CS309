@ Filename: MORGANL5.S
@ Author:   Ben Morgan
@ Email:    bam0043@uah.edu
@ Term:     CS309-01 2022
@ Purpose:   
@ This ARM Assembly program simulates a bank teller and allows the user to withdraw money. There is a limit of
@ 10 transactions per day, and a maximum of $200 withdrawal per transaction. The teller is initialized with
@ $20 x50 and $10 x50, totalling to $1500. The secret code "-9" lets the super user see the current status
@ of the teller. After 10 transactions or when the balance is depleted, a summary of the day's transaction
@ history is printed.

@ Use these commands to assemble, link, run and debug this program:
@    as -o MORGANL5.o MORGANL5.s
@    gcc -o MORGANL5 MORGANL5.o
@    ./MORGANL5 ;echo $?
@    gdb --args ./MORGANL5 

.global main
main:

initialize:

	mov r4, #50		@ Number of $20's
	mov r5, #50		@ Number of $10's
	mov r6, #1500   @ Total balance in teller
	mov r8, #0		@ Total number of valid transactions
	mov r9, #0		@ Temporary variable for input value

welcome:

	ldr r0, =strWelcome		@ Print welcome message
	bl  printf

inputPrompt:

	ldr r0, =strInputPrompt		@ Ask for withdrawal input
	bl  printf

	ldr r0, =numInputPattern
	ldr r1, =intInput
	bl  scanf

	ldr r1, =intInput
	ldr r1, [r1]

	cmp r1, #-9			@ Check for secret code
	beq secretCode

	cmp r1, #200
	bgt invalid			@ If >200, invalid input

	cmp r1, #10
	blt invalid			@ If <0, invalid input

	cmp r1, r6			@ Compare to total balance in teller
	bgt brokeBoi		@ if true move to insufficient funds

	mov r9, r1			@ Put input value in r9 for temporary usage
	mov r10, r1			@ Put input value in r10 for temporary usage

	b   modTen

modTen:

	sub r10, r10, #10		@ -10 from input 

	cmp r10, #0
	beq subTwenty			@ If = 0, input was a multiple of 10, valid input

	cmp r10, #0
	blt invalid			@ If < 0, input was not a multiple of 10, invalid input

	b   modTen

subTwenty:

	cmp r4, #0			@ see if there are $20 bills left
	beq subTen			@ Go check for $10's

	cmp r9, #10			@ Check if more $20's needed
	ble subTen			@ move to $10s

	sub r4, r4, #1			@ Take one $20 bill
	sub r6, r6, #20			@ Take $20 from balance
	sub r9, r9, #20			@ Take $20 from input value

	b   subTwenty			@ Loop

subTen:

	cmp r9, #0			    @ see if there are $10 bills left
	beq finishTransaction	@ If = 0, transaction complete

	sub r5, r5, #1			@ Take one $10 bill
	sub r6, r6, #10			@ Take $10 from balance
	sub r9, r9, #10			@ Take $10 from input value

	b subTen			    @ Loop

secretCode:

	ldr r0, =secretHeader	@ Print current summary title
	bl  printf

	ldr r0, =strNumBills		@ Print number of each type of bill remaining
	mov r1, r4
	mov r2, r5
	bl  printf

	ldr r0, =strRemaining		@ Print remaining balance
	mov r1, r6
	bl  printf

	mov r3, #1500
	sub r1, r3, r6			@ Calculate $ given so far

	ldr r0, =strTotalDistributed	@ Print amount of $ given so far
	bl  printf

	b   inputPrompt

invalid:

	ldr r0, =strInvalidInput	@ Print invalid input message
	bl  printf

	b   inputPrompt			@ Return to input prompt

brokeBoi:

	ldr r0, =theyBroke	@ Print insufficient funds message
	bl  printf

	b   inputPrompt			@ Return to input prompt

finishTransaction:

	ldr r0, =validTransaction	@ Print successful transaction message
	bl  printf

	add r8, r8, #1			@ Increment transaction counter

	cmp r8, #10
	beq finishDay			@ If = 10, max transaction limit reached, end teller program

	cmp r6, #0
	beq finishDay			@ If = 0, balance depleted, end teller program

	b   inputPrompt			@ Else, return to input prompt

finishDay:

	ldr r0, =eodSummary	@ Print summary title
	bl  printf

	ldr r0, =strNumTransactions	@ Print number of transactions
	mov r1, r8			@ r8 = number of transactions
	bl  printf

	mov r3, #50
	sub r1, r3, r4			@ Calculate #20's given
	sub r2, r3, r5			@ Calculate #10's given

	ldr r0, =strNumBillsGiven	@ Print number of each type of bill given
	bl  printf

	mov r3, #1500
	sub r1, r3, r6			@ Calculate $ given

	ldr r0, =strTotalDistributed	@ Print amount of $ given
	bl  printf

	ldr r0, =strRemaining		@ Print remaining balance
	mov r1, r6
	bl  printf

	b   myexit			@ Exit code

myexit:

	mov r7, #0x01
	svc 0

.data

@ Print messages

.balign 4
strWelcome: .asciz "Welcome to the ATM. The current balance is:\n$20 x 50\n$10 x50\nThe amount can be no greater than $200 and no less than $10. The values must be multiples of 10.\nYou are limited to 10 transactions per day.\n"

.balign 4
strInputPrompt: .asciz "Enter an amount to withdraw:\t\n"

.balign 4
strInvalidInput: .asciz "The withdraw request you made is invalid. Remember, it must be a multiple of 10 and be less than or equal to 200 and greater than or eqaul to 10.\n\n"

.balign 4
theyBroke: .asciz "Insufficient funds. There is $%d remaining. Please request a smaller amount.\n"

.balign 4
validTransaction: .asciz "Transaction complete.\n\n"


.balign 4
eodSummary: .asciz "\n---------Summary---------\n"

.balign 4
strNumTransactions: .asciz "Num of Transactions: %d\n"

.balign 4
strNumBillsGiven: .asciz "Num $20's Distributed: %d\nNum $10's Distributed: %d\n"

.balign 4
strTotalDistributed: .asciz "Total amount distributed: $%d\n"

.balign 4
strRemaining: .asciz "Remaining Balance: $%d\n"

.balign 4
secretHeader: .asciz "\n---------Welcome to the secret level---------\n"

.balign 4
strNumBills: .asciz "Number of $20's Remaining: %d\nNumber of $10's Remaining: %d\n"

.balign 4
numInputPattern: .asciz "%d"

.balign 4
intInput: .word 0

.global printf
.global scanf
