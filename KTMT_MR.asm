# 8x8 pixels with a 512x512 display
# Connect to heap base memory
.data
Colors:
	.word 0xFFFFFF # 0 White	Square
	.word 0x0000FF # 1 Blue	    Background
	.word 0x00FF00 # 2 Green	Player 1's circle
	.word 0xFF0000 # 3 Red		Player 2's circle


prompt_welcome: .asciiz "Welcome to Connect 4!\n\n"
prompt_turn_one: .asciiz "\n> Player 1's turn: "
prompt_turn_two: .asciiz "\n> Player 2's turn: "
prompt_win_one: .asciiz "\n> Player 1 win!"
prompt_win_two: .asciiz "\n> Player 2 win!"
prompt_draw: .asciiz "\n> Draw!"
prompt_enter: .asciiz "\n> Enter a number between 1 and 7: "
prompt_full: .asciiz "\n> This column is full. Select another one: "
.text
# Print Welcome
la $a0, prompt_welcome
li $v0, 4
syscall
# Welcome to Connect Four!
#
#
jal newGameBoard

Exit:
	li $v0, 10 # terminate the program
	syscall


# Function: newGameBoard
# Output: Draw a new gameboard
newGameBoard:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# Background
	li $a0, 0 # X = 0
	li $a1, 0 # Y = 0
	li $a2, 1 # Colors[1] = Blue from .data
	li $a3, 64 # Width = 64
	jal drawSquare
	# Squares
	li $a0, 1 # X = 1
	li $a2, 0 # Color[0] = White
	li $a3, 8
	# for(i = 1; i < 64; i += 9) {
	LoopGridX:
		li $a1, 1
		# for(j = 1; j < 55; j += 9) {
		LoopGridY:
			# drawSquare(X = i, Y = j, width = 8)
			jal drawSquare
			addi $a1, $a1, 9
			slti $t0, $a1, 55
			bnez $t0, LoopGridY
		addi $a0, $a0, 9
		slti $t0, $a0, 64
		bnez $t0, LoopGridX
	# Column's number: 1 2 3 4 5 6 7
	jal drawNumber

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

# Function: drawNumber
# Output: draw column's number
drawNumber:
	li $a2, 
	# Number 1


# Function: drawSquare
# Input: 
#	$a0 = X
#	$a1 = Y
#	$a2 = Color from Colors in .data
#	$a3 = width
# Output: Draw a square with given width
drawSquare:
	addi $sp, $sp, -12
	sw $s0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	move $s0, $a3 # Iterator s0 = width, s0 > 0; s0--
	LoopSquare:
		jal drawHorizontalLine
		addi $a1, $a1, 1
		addi $s0, $s0, -1
		bnez $s0, LoopSquare
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $s0, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	 
# Funtion: drawHorizontalLine
# Input:
#	$a0 = X
#	$a1 = Y
#	$a2 = Color
#	$a3 = Width
# Output: Draw a horizontal line starting from (X,Y)
drawHorizontalLine:
	addi $sp, $sp, -12
	sw $a0, 8($sp)
	sw $a3, 4($sp)
	sw $ra, 0($sp)
	LoopHorizontal:
		jal drawUnit
		addi $a3, $a3, -1
		addi $a0, $a0, 1
		bnez $a3, LoopHorizontal
	lw $ra, 0($sp)
	lw $a3, 4($sp)
	lw $a0, 8($sp)
	addi $sp, $sp, 12
	jr $ra

# Funtion: drawVerticalLine
# Input:
#	$a0 = X
#	$a1 = Y
#	$a2 = Color
#	$a3 = Width
# Output: Draw a vertical line starting from (X,Y)
drawVerticalLine:
	addi $sp, $sp, -12
	sw $a1, 8($sp)
	sw $a3, 4($sp)
	sw $ra, 0($sp)
	LoopVertical:
		jal drawUnit
		addi $a3, $a3, -1
		addi $a1, $a1, 1
		bnez $a3, LoopVertical
	lw $ra, 0($sp)
	lw $a3, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra

# Function: XYtoAddress
# Input:
#	$a0 = X
#	$a1 = Y
# Output:	
#	$v0 = Actual memory address in heap
XYtoAddress:
# Every unit is 8x8 pixels. 1 unit = 1 word
# The screen is 512 x 512 pixels ==> 64 x 64 unit ==> 64 words x 64 words.
# so words[0:63] is the first row, words[64:127] is the second...
# ==> A unit at (X,Y) is the (X + 64 x Y)th word. 
# ==> Actual address in heap: 0x10040000 + (X + 64 x Y)x4 
	sll $t1, $a1, 6		# t1 = 64 x Y
	add $t1, $t1, $a0	# t1 = X + 64 x Y
	sll $t1, $t1, 2		# t1 = (X + 64 x Y) x 4
	addi $v0, $t1, 0x10040000
	jr $ra

# Function: getColor
# Input:	$a2 = index
# Output:	$v1 = Colors[index] in .data
getColor:
	la $t0, Colors
	sll $t1, $a2, 2
	add $t0, $t0, $t1
	lw $v1, 0($t0)
	jr $ra

# Function: drawUnit
# Input:
#	$a0 = X
#	$a1 = Y
#	$a2 = Color
# Output: Draw unit (X,Y) with color Colors[$a2]
drawUnit:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal XYtoAddress		# Now $v0 will hold the address of unit
	jal getColor		# Now $v1 will hold the hex value of color
	sw $v1, 0($v0)		# Address $v0 will display color $v1
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	
	
	
	
	
