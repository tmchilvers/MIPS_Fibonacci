#recursive implementation of fibonacci sequence
#Tristan Chilvers | Alex Muse

.text #text section
.globl main #call main by SPIM

main:
    # Register assignments:
    # s0 = n, s1 = returned data

    #========== Initialize Registers ===========================================
    # ASK FOR INPUT
    li $v0, 4                   # system call code for printing string (command 4)
    la $a0, prompt_user         # load address of string to be printed into $a0
    syscall

    # USER INPUT
    li $v0, 5                   # read in input from user (command 5)
    syscall
    move $s0, $v0               # store data from user into s0 (n)

    # CALL FUNCTION
    jal fib                     # go to posrun function
    move $s1, $v0               # move return data to s1

    # PRINT ANSWER TEXT
    li $v0, 4                   # system call code for printing string (command 4)
    la $a0, answer              # load address of string to be printed into $a0
    syscall

    # PRINT RESULTS
    move $a0, $s1               # move result to a0 to print
    li $v0, 1                   # print data in a0
    syscall

    li $v0, 10                  # terminate program
    syscall

    #===========================================================================
    #===========================================================================
    # FUNCTION: Recursive int fib(int n)
    # Arguments stored in $s0
    # Return value stored in $v0
    # Return address stored in $ra (done by jal function)
fib:
    # IF STATEMENTS
    beq $s0, $zero, zero        # if n = 0, go to zero branch
    beq $s0, 1, one             # if n = 1, go to one branch

    # RECURSIVE CALL
    #---------------------------------------------------------------------------
    # FIB(N - 1)

    addi $sp, $sp, -4           # allocate 1 word of space in stack
    sw $ra, 0($sp)              # push return address to 0(sp)

    sub $s0, $s0, 1             # n - 1
    jal fib                     # recursive call fib
    add $s0, $s0, 1             # set n back to original value

    lw $ra, 0($sp)              # pop return adress from 0(sp)
    sw $v0, 0($sp)              # push return value in 0(sp)

    #---------------------------------------------------------------------------
    # FIB(N - 2)

    addi $sp, $sp, -4           # allocate another 1 word of space in stack
    sw $ra, 0($sp)              # push return address in 0(sp)

    sub $s0, $s0, 2             # n - 2
    jal fib                     # call fib
    add $s0, $s0, 2             # set n back to original value

    lw $ra, 0($sp)              # pop return address from 0(sp)
    add $sp, $sp, 4             # restore 1 word of space in stack

    #---------------------------------------------------------------------------
    # SUM THE RETURNED DATA

    lw $s2, 0($sp)              # pop the return value from STACK
    add $sp, $sp, 4             # restore another 1 word of space in stack

    add $v0, $v0, $s2           # v0 = fib(n-1) + fib(n-2)

    jr $ra
    #============ IF STATEMENTS ================================================
zero:
    li $v0, 0                   # return 0
    jr $ra                      # jump to return address

one:
    li $v0, 1                   # return 1
    jr $ra                      # jump to return address

    #===========================================================================
    #===========================================================================


.data #data section
prompt_user: .asciiz "\nWhat is the starting sequence value: "
answer: .asciiz "Calculated value is: "
