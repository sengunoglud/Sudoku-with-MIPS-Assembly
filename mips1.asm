##################################################################################################################################
#																 #
#																 #
#						         9x9 Sudoku Game							 #
#																 #
#																 #
##################################################################################################################################
# Game Documentation:														 #
#																 #
# Sudoku is a logic game that is played on a grid of 9x9. Fill each row, column, and 3x3 box in order to win the game    #
# Ensure that each number only shows once in each row, column, and box as you enter the numbers from 1 to 9.			 #
#																 #
# Follow these procedures to start the game:											 #
#																 #
# 1. Click "1" to start the game.												 #
#																 #
# The game board will be shown, with filled cells denoted by numbers and empty cells denoted by dots. 		 #
# It's up to you to fill in the empty cells with the right numbers.								 #
#																 #
# Please follow the following steps for each move:											 #
#      																 #
# 1. The statement "Enter the number:" will appear. Enter a number by depressing a key on the keyboard.				 #
#																 #
# 2. The phrase "Enter the row:" will appear. To input the row number where the cell is placed, press a key on the keyboard.  #
# The row number must range from 1 to 9.											 #
#																 #
# 3. The phrase "Enter the column:" will appear. To input the column number where the cell is, press a key on the keyboard.     #
# located. The column number must range from 1 to 9.									 #
#																 #
# The number will be inserted into the matching cell on the game board if the row, column, and number information are accurate.    #
# board, which will then be updated. An error notice will appear if the number, row, or column information you submitted is incorrect.    #
#You will then be required to reenter the right information when it has been presented.							 #
#																 #
# You will see the message as you go through the game by adding the proper numbers and finishing the game board. 	 #
# "Correct!". When the entire game board is filled, the game is over.								 #
#																 #
# The game board will be refreshed and you will be given another opportunity if you make an improper move, as shown by the notification "Incorrect!"    #
# chance to make the correct move.												 #
#																 #
# Check for the word "Correct!" and make sure you get a chance to make the right move on the game board to know whether you've won.    #
# absolutely full.														 #
#																 #
# 							Enjoy!								 #								 
##################################################################################################################################

.data

welcome: .asciiz "\t\t\t- Welcome to the 9x9 Sudoku Game- \n"
start_move: .asciiz "Press 1 to Start!\n"

wrong: .asciiz "Input is not correct! "
new_row: .asciiz "|\n"
h_sep: .asciiz "+-----------------------------------+\n"
v_sep: .asciiz " | "
error_msg: .asciiz "Incorrect! \n"
corr_msg: .asciiz "Correct \n"
e: .asciiz "Enter the number: \n"
r: .asciiz "Enter the row: \n"
c: .asciiz "Enter the column: \n"


##################################################################################################################################
sample_gameboard:      
    .byte     0, 0, 3, 0, 2, 0, 6, 0, 0
    .byte     9, 0, 0, 3, 0, 5, 0, 0, 1
    .byte     0, 0, 1, 8, 0, 6, 4, 0, 0
    .byte     0, 0, 8, 1, 0, 2, 9, 0, 0
    .byte     7, 0, 0, 0, 0, 0, 0, 0, 8
    .byte     0, 0, 6, 7, 0, 8, 2, 0, 0
    .byte     0, 0, 2, 6, 0, 9, 5, 0, 0
    .byte     8, 0, 0, 2, 0, 3, 0, 0, 9
    .byte     0, 0, 5, 0, 1, 0, 3, 0, 0



.text
main:
    # Print a welcome message
    li $v0, 4
    la $a0, welcome
    syscall

    # Print instructions
    li $v0, 4
    la $a0, start_move
    syscall

    # Read the user's choice
    li $v0, 5
    syscall
    beq $v0, 1, start_game
    j input_error

start_game:
    # Print the game board
    la $a0, sample_gameboard
    jal print_board

    # Start moving numbers
    la $a0, sample_gameboard
    jal move

print_board:
    # Set up the stack frame
    sub $sp, $sp, 16
    sw $ra, 12($sp)
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)

    # The configuration of registers
    move $s0, $a0     # $s0 specifies the cell to be printed
    move $s1, $zero   # $s1 maintains a record of the current row
    move $s2, $zero   # $s2 maintains a record of the current column

    # write the top border.
    la $a0, h_sep
    li $v0, 4
    syscall

    print_row:
        # write the row content
        print_cell:
            # Print the cell's vertical border
            la $a0, v_sep
            li $v0, 4
            syscall

            # write the number in the current cell
            lb $a0, ($s0)
            li $v0, 1
            syscall

            addi $s0, $s0, 1   # specifies to the next board cell
            addi $s2, $s2, 1   # the column count is increased

            blt $s2, 9, print_cell   # until the row is finished, repeat the loop.

        # Finish the row by printing a new separator.
        la $a0, new_row
        li $v0, 4
        syscall

        move $s2, $zero   # Reset the column counter
        addi $s1, $s1, 1  # Increment the row counter

        # Print horizontal line between rows
        la $a0, h_sep
        li $v0, 4
        syscall

        # Print the next row
        blt $s1, 9, print_row   # Restart the loop until the table is complete

    # Destroy the stack frame
    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16

    jr $ra   # Return to the calling function


move:
    # Set up the stack frame
    subi $sp, $sp, 16
    sw $ra, 12($sp)
    sw $s2, 8($sp)
    sw $s1, 4($sp)
    sw $s0, 0($sp)

    # The configuration of registers
    move $s0, $a0   # $s0 points to the cell

    # Get the user's move
    li $v0, 4
    la $a0, e
    syscall

    li $v0, 5
    syscall
    move $t0, $v0 

    li $v0, 4
    la $a0, r
    syscall

    li $v0, 5
    syscall
    move $t1, $v0   # Row index

    li $v0, 4
    la $a0, c
    syscall

    li $v0, 5
    syscall
    move $t2, $v0   # Column index

    move $a0, $s0   # Board address
    move $a1, $t0   # Number entered
    move $a2, $t1   # Row index
    move $a3, $t2   # Column index

    jal check

    beqz $v0, correct_move

    li $v0, 4
    la $a0, error_msg
    syscall

    move $a0, $s0   # Board address
    jal print_board

    j move   

correct_move:
    li $v0, 4
    la $a0, corr_msg
    syscall

    move $a0, $s0   # Board address
    jal board_full
    beqz $v0, not_full

    # Remove the stack frame.

    lw $s0, 0($sp)
    lw $s1, 4($sp)
    lw $s2, 8($sp)
    lw $ra, 12($sp)
    addi $sp, $sp, 16

    jr $ra   # to the calling function once more

not_full:
    move $a0, $s0   # Board address
    jal move

check:
    subi $sp, $sp, 4   #Create space in the stack.

    sw $ra, ($sp)   # Save $ra register

    move $s0, $a0   
    move $t9, $a1  

    # Row control
    li $t0, 9   # Set counter
    mul $t1, $a2, $t0   # offset of the row's first cell


check_row:
    add $s1, $s0, $t1
    lb $t2, ($s1)   # Value in the current cell

    beq $t2, $t9, check_ret_fail   # Number present in previous rows

    addi $t1, $t1, 1   # Increment the pointer 
    subi $t0, $t0, 1   # Decrement the counter

    bnez $t0, check_row   

    # Column check
    move $t1, $a3   # offset of the column's top row's cell

check_col:
    add $s1, $s0, $t1
    lb $t2, ($s1)   # Value of the current cell

    beq $t2, $t9, check_ret_fail   # Number is already in the column.

    addi $t1, $t1, 9   # The current cell's pointer is advanced.

    ble $t1, 81, check_col   # control the next cell in the column

    # 3x3-Box check
    div $t0, $a2, 3   # $t0 = row / 3
    mul $t0, $t0, 27   # Offset of the row
    div $t1, $a3, 3   # $t1 = col / 3
    mul $t1, $t1, 3   # Dimensions of the column
    add $t1, $t0, $t1   # Dimensions of the first cell in the box

    li $t0, 3   # the row counter set up
    li $t3, 3   # the row coulumn set up


check_box:
    add $s1, $s0, $t1
    lb $t6, ($s1)   # the current cell's value

    beq $t9, $t6, check_ret_fail   # The box contains the number.

    subi $t3, $t3, 1   # Lower the column counter.
    beqz $t3, end_box_row   # Verify to see if the current box row has ended.

    addi $t1, $t1, 1  
    j check_box

end_box_row:
    addi $t1, $t1, 7   
    li $t3, 3   # Reset column counter
    subi $t0, $t0, 1   # Lower the row counter.
    bnez $t0, check_box   # Make sure the box's end is reached.

    li $t8, 9
    mul $t7, $a2, $t8   # 9 * row_index
    add $t7, $a3, $t7   # 9 * row_index + column_index
    add $s1, $s0, $t7
    sb $t9, ($s1)   # Store byte

    move $a0, $s0
    jal print_board

    move $v0, $zero   # Return code is 0 (success)

check_ret:
    lw $ra, ($sp)   # Restore $ra register
    addi $sp, $sp, 4   # Clean up the stack

    jr $ra   # to the calling function once more

check_ret_fail:
    li $t8, 9
    mul $t7, $a2, $t8   # 9 * row_index
    add $t7, $a3, $t7   # 9 * row_index + column_index
    add $s1, $s0, $t7
    sb $t9, ($s1)   # byte

    move $a0, $s0
    jal print_board

    li $v0, 1   # Return code is 1 (failure)

    j check_ret

board_full:
    move $s0, $a0   # Board address
    move $s1, $zero   # Row counter
    move $s2, $zero   # Column counter

    move $t0, $s0   
    li $t2, 9

for_row:
    mul $t1, $s1, $t2

for_boxes:
    add $t3, $t1, $s2
    add $s0, $t0, $t3
    lb $t4, ($s0)

    beqz $t4, not_full

    addi $s2, $s2, 1
    beq $s2, 9, end_and_reset

    j for_boxes

end_and_reset:
    addi $s1, $s1, 1
    beq $s1, 9, end_game

    move $s2, $zero   # Reset column counter
    j for_row


input_error:
   # Print warning for incorrect input
    li $v0, 4
    la $a0, wrong
    syscall

    # Exit the program
    li $v0, 10
    syscall
    
end_game:
    li $v0, 1   # Full
    jr $ra
