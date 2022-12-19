# 8x8 pixels with a 512x512 display
# Connect to heap base memory
.data
Colors:
	.word 0xFFFFFF # 0 White	Square
	.word 0x000000 # 1 Black	Background
	.word 0x00FF00 # 2 Green	Player 1's circle
	.word 0xFF0000 # 3 Red		Player 2's circle
#Array: Present the gameboard's state, 0: empty, 1: Player 1, 2: Player 2
#Array[0:6] = Column 1
#Array[6:12] = Column 2...
Array: .byte 0:42
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
jal gamePlay
# Draw gameboard

#####TEST FIELD

#####
Exit:
	li $v0, 10 # terminate the program
	syscall


# Function: newGameBoard
# Output: Draw a new gameboard
newGameBoard:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#Saved data variables
	li $s0, 0     	#s0 = number of coins
	la $s1, Array 	#s1 = array of game status
	li $s2, 0	 	#s2 = last inserted index
	li $s3, 0 		#type of win for checking

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
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	li $a2, 0
	# Number 1
	li $a0, 3
	li $a1, 55
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 4
	li $a3, 6
	jal drawVerticalLine
	li $a0, 3
	li $a1, 61
	li $a3, 3
	jal drawHorizontalLine
	# Number 2
	li $a0, 11
	li $a1, 56
	jal drawUnit
	li $a0, 12
	li $a1, 55
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 14
	li $a1, 56
	li $a3, 2
	jal drawVerticalLine
	li $a0, 13
	li $a1, 58
	jal drawUnit
	li $a0, 12
	li $a1, 59
	jal drawUnit
	li $a0, 11
	li $a1, 60
	jal drawUnit
	li $a0, 11
	li $a1, 61
	li $a3, 4
	jal drawHorizontalLine
	# Number 3 
	li $a0, 21
	li $a1, 56
	jal drawUnit
	li $a0, 22
	li $a1, 55
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 24
	li $a1, 56
	li $a3, 2
	jal drawVerticalLine
	li $a0, 23
	li $a1, 58
	jal drawUnit
	li $a0, 24
	li $a1, 59
	li $a3, 2
	jal drawVerticalLine
	li $a0, 21
	li $a1, 60
	jal drawUnit
	li $a0, 22
	li $a1, 61
	li $a3, 2
	jal drawHorizontalLine
	# Number 4
	li $a0, 30
	li $a1, 55
	li $a3, 4
	jal drawVerticalLine
	li $a0, 31
	li $a1, 58
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 33
	li $a1, 55
	li $a3, 7
	jal drawVerticalLine
	# Number 5
	li $a0, 39
	li $a1, 55
	li $a3, 4
	jal drawHorizontalLine
	li $a0, 39
	li $a1, 56
	li $a3, 2
	jal drawVerticalLine
	li $a0, 40
	li $a1, 58
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 42
	li $a1, 59
	li $a3, 2
	jal drawVerticalLine
	li $a0, 39
	li $a1, 61
	li $a3, 3
	jal drawHorizontalLine
	# Number 6
	li $a0, 48
	li $a1, 56
	li $a3, 5
	jal drawVerticalLine
	li $a0, 49
	li $a1, 55
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 51
	li $a1, 56
	jal drawUnit
	li $a0, 49
	li $a1, 58
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 49
	li $a1, 61
	li $a3, 2
	jal drawHorizontalLine
	li $a0, 51
	li $a1, 59
	li $a3, 2
	jal drawVerticalLine
	# Number 7
	li $a0, 57
	li $a1, 55
	li $a3, 4
	jal drawHorizontalLine
	li $a0, 60
	li $a1, 56
	li $a3, 2
	jal drawVerticalLine
	li $a0, 59
	li $a1, 58
	li $a3, 4
	jal drawVerticalLine

	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

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

# Function: drawCoin
# Input:
# 	$a0 = X
#	$a1 = Y
#	$a2 = Player Number (1 or 2)
# Output: draw coin in the box which has top left (X, Y)
drawCoin:
	addi $a2, $a2, 1
	addi $sp, $sp, -20
	sw $s0, 16($sp)
	sw $s1, 12($sp)
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $ra, 0($sp)
	move $s0, $a0
	move $s1, $a1
	addi $a0, $s0, 1
	addi $a1, $s1, 1
	li $a3, 6
	jal drawSquare
	addi $a0, $s0, 2
	addi $a1, $s1, 0
	li $a3, 4
	jal drawHorizontalLine # (X+2, Y)
	addi $a0, $s0, 2
	addi $a1, $s1, 7
	jal drawHorizontalLine
	addi $a0, $s0, 0
	addi $a1, $s1, 2
	jal drawVerticalLine
	addi $a0, $s0, 7
	addi $a1, $s1, 2
	jal drawVerticalLine
	
			
	lw $ra, 0($sp)
	lw $a1, 4($sp)
	lw $a0, 8($sp)
	lw $s1, 12($sp)
	lw $s0, 16($sp)
	addi $sp, $sp, 20
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

#Function: checkInput
#Input: integer i from keyboard, $a0 = i
#Output: $a0 = X, $a1 = Y with (X,Y) 
checkInput:
	#############
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#condition 1 ( 1 <= i <= 7)
	slti $t0, $a0, 8 	# if (i < 8)
	slti $t1, $a0, 1 	# if (i < 1)
	not $t1, $t1 	# if (i>=1)
	and $t0, $t0, $t1	
	beqz $t0, choose_another
	#condition 2 ( array[6(i-1)+5]  <> 0 )	
	addi $t0, $a0, -1
	li $t1, 6
	mult $t0, $t1
	mflo $t0
	addi $t0, $t0, 5 	# t0 = 6(i-1) + 5
	add $t0, $t0, $s1 	# t0 = &array
	lbu $t1, 0($t0)
	slti $t0, $t1, 1	 # t0 = 1 if array[6(i-1) + 5] == 0 
	beqz $t0, choose_another
	#loop 6(i-1), 6i -5, ... 6i -1
	li $t1, 6
	addi $t0, $a0, -1
	mult $t0, $t1
	mflo $t0
	add $t0, $t0, $s1 
	Loop:
		lbu $t2, 0($t0)
		slti $t2, $t2, 1
		bnez $t2, breakLoop
		addi $t0, $t0, 1
		addi $t1, $t1, -1
		bnez $t1, Loop
	breakLoop:
	sb $a2, 0($t0)
	sub  $t0, $t0, $s1
	addi $s2, $t0, 0	# update $s2 = i
	li $t1, 6
	# x = (t div 6)*9 + 1
	# y = (5 - (t mod 6))*9 + 1
	div $t0, $t1 
	mfhi $t1 		#t mod 6
	mflo $t0 		#t div 6
	
	li $t2, 9
	mult $t0, $t2
	mflo $t0
	addi $a0, $t0, 1	#(t div 6)*9+1
	
	li $t0, 5
	sub $t0, $t0, $t1
	mult $t0, $t2
	mflo $t0
	addi $a1, $t0, 1	#(5 - (t mod 6))*9 +1
	##################
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#Funtion: checkWin
checkWin:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	### Horizontal Check
	 #cau nay` lon left voi right nma luoi` sua qua :))
	add $t1, $s1, $s2	#t1 = &array[i]
	lbu $t2, 0($t1) 	#t2 = array[i]
	li $t3, 3		#t3 = count
	li $t4, 0 		#t4 = offset for left
	li $t5, 0		#t5 = offset for right
	leftCheck:
		addi $t4, $t4, 6		#t4 = t4 + 6
		add $t0, $s2, $t4		#t0 = i + t4
		slti $t6, $t0, 42
		beqz $t6, rightCheck		#check if t0 > 42
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, rightCheck	#check if array[t0] == array[i]
		addi $t3, $t3, -1
		beqz $t3, announceWin1	#win
		j leftCheck		#loop	
	rightCheck:
		addi $t5, $t5, -6		#t5 = t5 - 6
		add $t0, $s2, $t5		#t0 = i + t5
		slti $t6, $t0, 0
		bnez  $t6, noHorizontalWin	#check if t0  < 0
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, noHorizontalWin	#check if array[t0] == array[i]
		add $t3, $t3, -1
		beqz $t3, announceWin1	#win
		j rightCheck		#loop
	noHorizontalWin:
	### Vertical Check
	add $t1, $s1, $s2	#t1 = &array[i]
	lbu $t2, 0($t1) 	#t2 = array[i]
	li $t3, 3		#t3 = count
	li $t4, 0 		#t4 = offset for up
	li $t5, 0		#t5 = offset for down
	li $t0, 6		#t0 = 6
	div $s2, $t0	
	mflo $t8		#t8 = i mod 6
	mult $t8, $t0	
	mfhi $t8		#t8 = i-th column * 6
	addi $t9, $t8, 6	#t9 = i+1-th column *6		
	upCheck:
		addi $t4, $t4, 1
		add $t0, $s2, $t4
		slt $t6, $t0, $t9
		beqz $t6, downCheck
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, downCheck
		addi $t3, $t3, -1
		beqz $t3, announceWin2
		j upCheck
	downCheck:
		addi $t5, $t5, -1
		add $t0, $s2, $t5
		slt $t6, $t0, $t8
		bnez  $t6, noVerticalWin
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, noVerticalWin
		add $t3, $t3, -1
		beqz $t3, announceWin2
		j downCheck
	noVerticalWin:
	### Left Diagonal Check
	add $t1, $s1, $s2	#t1 = &array[i]
	lbu $t2, 0($t1) 	#t2 = array[i]
	li $t3, 3		#t3 = count
	li $t4, 0 		#t4 = offset for up-left
	li $t5, 0		#t5 = offset for down-right
	li $t8, 6
	down_rightCheck:
		addi $t4, $t4, 5 
		add $t0, $s2, $t4
		slti $t6, $t0, 42
		beqz $t6, up_leftCheck	#check if t0 < 42
		addi $t9, $t0, 1
		div $t9, $t8
		mfhi $t9
		beqz $t9, up_leftCheck 	#check if (t0 + 1) mod 6 == 0
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, up_leftCheck	#check if array[t0] == array[i]
		addi $t3, $t3, -1
		beqz $t3, announceWin3	
		j down_rightCheck		
	up_leftCheck:
		addi $t5, $t5, -5
		add $t0, $s2, $t5
		slti $t6, $t0, 0
		bnez $t6, noLeftDiagonalWin	#check if t0 < 0
		addi $t9, $t0, 0
		div $t9, $t8
		mfhi $t9
		beqz $t9, noLeftDiagonalWin	#chekc if t0 mod 6 == 0 
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, noLeftDiagonalWin #check if array[t0] == array[i]	
		addi $t3, $t3, -1
		beqz $t3, announceWin3
		j up_leftCheck
	noLeftDiagonalWin:
	### Right Diagonal Check
	add $t1, $s1, $s2	#t1 = &array[i]
	lbu $t2, 0($t1) 	#t2 = array[i]
	li $t3, 3		#t3 = count
	li $t4, 0 		#t4 = offset for down-left
	li $t5, 0		#t5 = offset for up-right
	li $t8, 6
	up_rightCheck:
		addi $t4, $t4, 7
		add $t0, $s2, $t4
		slti $t6, $t0, 42
		beqz $t6, down_leftCheck
		addi $t9, $t0, 0
		div $t9, $t8
		mfhi $t9
		beqz $t9, down_leftCheck
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, down_leftCheck
		addi $t3, $t3, -1
		beqz $t3, announceWin4
		j up_rightCheck
	down_leftCheck:
		addi $t5, $t5, -7
		add $t0, $s2, $t5
		slti $t6, $t0, 0
		bnez $t6, noRightDiagonalWin
		addi $t9, $t0, 1
		div $t9, $t8
		mfhi $t9
		beqz $t9, noRightDiagonalWin
		add $t0, $t0, $s1
		lbu $t7, 0($t0)
		bne $t2, $t7, noRightDiagonalWin
		addi $t3, $t3, -1
		beqz $t3, announceWin4
		j down_leftCheck
	noRightDiagonalWin:
	##
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
#Function: announceWin(1, 2, 3, 4) for each type of win
announceWin1:
	li $s3, 1
	j announceWin
announceWin2:
	li $s3, 2
	j announceWin
announceWin3:
	li $s3, 3
	j announceWin
announceWin4:
	li $s3, 4
	j announceWin
announceWin:
	li $t0, 2
	bne $a2, $t0, player_2win
	li $v0, 4
	la $a0, prompt_win_one
	syscall
	j Exit
player_2win:
	li $v0, 4
	la $a0, prompt_win_two
	syscall
	j Exit
#Function: checkTie: if ($s0 == 42) print("Tie")
checkTie:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	slti $t0, $s0, 42
	bnez $t0, continue
	la $a0, prompt_draw
	li $v0, 4
	syscall
	j Exit
continue:
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp , $sp, 8
	jr $ra
	
#Function: gamePlay
gamePlay:
	jal player1		#start with player 1
player1:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	##########
	jal print_player1_turn
	li $v0, 5
	syscall
	li $a2, 1 		#set color for player1
	move $a0, $v0 
	jal checkInput
	jal drawCoin	#change $a2 += 1  after this
	addi $s0, $s0, 1	#update number of coins
	jal checkWin
	jal checkTie
	##############
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	##############
	jal player2
player2:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	#############
	jal print_player2_turn
	li $v0, 5
	syscall 
	li $a2, 2		#set color for player2
	move $a0, $v0 
	jal checkInput
	jal drawCoin 	#change $a2 += 1 after this
	addi $s0, $s0, 1	#update number of coins
	jal checkWin
	jal checkTie
	##
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jal player1
	j player1
	
	

#Function: choose_another: print "Choose another.." and back to player's turn 
choose_another: 
	jal print_choose_another
	addi $sp, $sp, 4 #skip $ra of checkInput
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
#Function: Print_xx (print without changing $a0)
print_choose_another:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	li $v0, 4
	la $a0, prompt_full
	syscall
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp , $sp, 8
	jr $ra
print_player1_turn:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	li $v0, 4
	la $a0, prompt_turn_one
	syscall
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp , $sp, 8
	jr $ra
print_player2_turn:
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	li $v0, 4
	la $a0, prompt_turn_two
	syscall
	lw $ra, 4($sp)
	lw $a0, 0($sp)
	addi $sp , $sp, 8
	jr $ra
