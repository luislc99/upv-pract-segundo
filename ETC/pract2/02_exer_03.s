          .globl __start	#multiplica números
          .text 0x00400000
__start:  jal Input

			#mod
			#comprobamos si t9 > 0
			bgtz $t9, positivo
			
			#lo es saltamos a positivo
			#no hacemos $t9 = $zero - $t9
			sub $t9, $zero, $t9
			sub $t8, $zero, $t8
			#llamamos mult
			
positivo :	  jal Mult
#finish mod
		  move $t9, $v0
		  jal Output
          li $v0,10
          syscall		#acaba el proceso
Mult:     li $v0, 0		#en v0 un 0
          beqz $t9, MultRet	#saltas a MultRet si $a1 = 0
MultFor:  add $v0, $v0, $t8 	
          addi $t9, $t9, -1
          bne $t9, $zero, MultFor  #sumo $a1 veces $a0
MultRet:  jr $ra   #volvemos después del jal


Input:	 	#preparar impresión M e imprimimos
			li $v0, 11
			li $a0, 77
			syscall 
			li $a0, 61 
			syscall
			#leer M
			li $v0, 5 #tenemos en $v0 valor leído
			syscall
			move $t8, $v0	#primer valor en $t8
			#preparar impresión Q e imprimir
			li $v0, 11
			li $a0, 81
			syscall 
			li $a0, 61
			syscall
			#leer Q
			li $v0, 5
			syscall
			move $t9, $v0 #segundo valor $t9
			#volver cuerpo
			jr $ra
			
Output:		#preparar impresión R
			li $v0, 11
			li $a0, 82
			syscall 
			li $a0, 61
			syscall
			li $v0, 1
			move $a0, $t9
			syscall