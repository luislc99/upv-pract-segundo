                ##########################################################
                # Segmento de datos
                ##########################################################

                .data 0x10000000
reloj:          .word 0                # HH:MM:SS (3 bytes de menor peso)

cad_asteriscos: .asciiz "\n  **************************************"
cad_horas:      .asciiz "\n   Horas: "
cad_minutos:    .asciiz " Minutos: "
cad_segundos:   .asciiz " Segundos: "
cad_reloj_en_s: .asciiz "\n   Reloj en segundos: "

                ##########################################################
                # Segmento de c�digo
                ##########################################################

                .globl __start
                .text 0x00400000

__start:        la $a0, reloj

				#completaryoy
				li $a1, 2
				li $a2, 3
				li $a3, 12
				jal inicializa_reloj_alt
				la $a0, reloj
				#termina completar
                jal imprime_reloj
             
salir:          li $v0, 10              # C�digo de exit (10)
                syscall                 # �ltima instrucci�n ejecutada
                .end


                ########################################################## 
                # Subrutina que imprime el valor del reloj
                # Entrada: $a0 con la direcci�n de la variable reloj
                ########################################################## 

imprime_reloj:  move $t0, $a0
                la $a0, cad_asteriscos  # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall

                la $a0, cad_horas       # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall

                lbu $a0, 2($t0)         # Lee el campo HH
                li $v0, 1               # C�digo de print_int
                syscall

                la $a0, cad_minutos     # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall

                lbu $a0, 1($t0)         # Lee el campo MM
                li $v0, 1               # C�digo de print_int
                syscall

                la $a0, cad_segundos    # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall

                lbu $a0, 0($t0)         # Lee el campo SS
                li $v0, 1               # C�digo de print_int
                syscall

                la $a0, cad_asteriscos  # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall
                jr $ra

                ########################################################## 
                # Subrutina que imprime los segundos calculados
                # Entrada: $a0 con los segundos a imprimir
                ########################################################## 

imprime_s:      move $t0, $a0
                la $a0, cad_asteriscos  # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall


                la $a0, cad_reloj_en_s  # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall

                move $a0, $t0           # Valor entero a imprimir
                li $v0, 1               # C�digo de print_int
                syscall

                la $a0, cad_asteriscos  # Direcci�n de la cadena
                li $v0, 4               # C�digo de print_string
                syscall
                jr $ra
                
                ########################################################## 
                # Subrutina que incrementa el reloj en una hora
                # Entrada: $a0 con la direcci�n del reloj
                # Salida: reloj incrementado en memoria
                # Nota: 23:MM:SS -> 00:MM:SS
                ########################################################## 
                
pasa_hora:      lbu $t0, 2($a0)         # $t0 = HH
                addiu $t0, $t0, 1       # $t0 = HH++
                li $t1, 24
                beq $t0, $t1, H24       # Si HH==24 se pone HH a cero
                sb $t0, 2($a0)          # Escribe HH++
                j fin_pasa_hora
H24:            sb $zero, 2($a0)        # Escribe HH a 0
fin_pasa_hora:  jr $ra

				
inicializa_reloj_alt: addiu $4, $a1, $zero
				or $a4, $a1, $zero	
				sll $a4 $a4 8#desplazar 8 bits
				or $a4, $a4, $a2	
				sll $a4 $a4 8#desplazar 8 bits
				or $a4, $a4, $a3
				sw $a4, 0($a0)

				jr $ra