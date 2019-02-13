          .globl __start
          .data 0x10000000
M:        .space 4
Q:        .space 4
R:        .space 4
          
          .text 0x00400000
__start:  li $a0,'M'
          la $a1, M
          jal InputV
          li $v0,10
          syscall

InputV:   li $v0, 11
          syscall
          li $v0, 11
          li $a0, '='
          syscall
          li $v0, 5
          syscall
          sw $v0, 0($a1)
          jr $ra

MultV:	  lw $t0, 0($a0)
		  lw $t1, 0($a1)
		  bgez $t1, mayor
		  sub $t0, $zero, $t0
		  sub $t1, $zero, $t1
		  li $t2, 0
mayor:	  add $t2, $t2, $t0				//si es 0...
		  subi $t1, $t1, 1
		  bgtz $t1, mayor
		  sw $t2, 0($a2)
		  jr $ra