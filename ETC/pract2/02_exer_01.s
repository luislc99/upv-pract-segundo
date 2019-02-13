          .globl __start	#multiplica números
          .text 0x00400000
__start:  li $v0,5
          syscall		#lee entero
          move $a0,$v0 	#mueve el valor leído a $a0
          li $v0,5		
          syscall		#lee OTRO entero
          move $a1,$v0	#mueve segundo entero en $a1
          jal Mult		#salta a Mult y guarda en $ra la siguiente instrucción
          move $a0,$v0	# $v0 -> $a0
          li $v0,1 		#prepara impresión	
          syscall		#imprime el valor de $ a0
          li $v0,10
          syscall		#acaba el proceso
Mult:     li $v0, 0		#en v0 un 0
          beqz $a1, MultRet	#saltas a MultRet si $a1 = 0
MultFor:  add $v0, $v0, $a0 	
          addi $a1, $a1, -1
          bne $a1, $zero, MultFor  #sumo $a1 veces $a0
MultRet:  jr $ra   #volvemos después del jal
