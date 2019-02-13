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
                # Segmento de código
                ##########################################################

                .globl __start
                .text 0x00400000

__start:        la $a0, reloj

				#completaryoy
				la $a0, reloj
				li $a1, 0x0012202D
				jal inicializa_reloj
				la $a0, reloj
				jal devuelve_reloj_en_s_srd
				move $a0, $v0
				jal imprime_s
				#termina completar
             
salir:          li $v0, 10              # Código de exit (10)
                syscall                 # Última instrucción ejecutada
                .end


                ########################################################## 
                # Subrutina que imprime el valor del reloj
                # Entrada: $a0 con la dirección de la variable reloj
                ########################################################## 

imprime_reloj:  move $t0, $a0
                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                la $a0, cad_horas       # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                lbu $a0, 2($t0)         # Lee el campo HH
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_minutos     # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                lbu $a0, 1($t0)         # Lee el campo MM
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_segundos    # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                lbu $a0, 0($t0)         # Lee el campo SS
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall
                jr $ra

                ########################################################## 
                # Subrutina que imprime los segundos calculados
                # Entrada: $a0 con los segundos a imprimir
                ########################################################## 

imprime_s:      move $t0, $a0
                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall


                la $a0, cad_reloj_en_s  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall

                move $a0, $t0           # Valor entero a imprimir
                li $v0, 1               # Código de print_int
                syscall

                la $a0, cad_asteriscos  # Dirección de la cadena
                li $v0, 4               # Código de print_string
                syscall
                jr $ra
                
                ########################################################## 
                # Subrutina que incrementa el reloj en una hora
                # Entrada: $a0 con la dirección del reloj
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

inicializa_reloj: sw $a1, 0($a0)
				jr $ra 
				
devuelve_reloj_en_s:
				li $t3, 60			# Factor from h->m and m->s
				lb $t0, 2($a0)		# Load hours
				li $t1, 0x1f		# Clean hours
				and $t0, $t0, $t1
				mult $t0, $t3		# Hours to minutes
				mflo $t2
				lb $t0, 1($a0)		# Load minutes
				li $t1, 0x3f		# Clean minutes
				and $t0, $t0, $t1
				add $t0, $t0, $t2	# minutes = hours * 60 + minutes
				mult $t0, $t3		# Minutes to seconds
				mflo $t2
				lb $t0, 0($a0)		# Load seconds
				li $t1, 0x3f		# Clean seconds
				and $t0, $t0, $t1
				add $v0, $t0, $t2	# seconds = minutes * 60 + seconds
				jr $ra	
				
devuelve_reloj_en_s_sd:
				lb $t0, 2($a0) #cargamos la hora
				sll $v0, $t0, 11
				sll $t1, $t0, 10
				addu $v0,$v0,$t1 #$v0 = $t0 * (2^11+2^10)
				sll $t1, $t0, 9
				addu $v0, $t1, $v0 #$v0 = $t0 * (2^11+2^10+2^9)
				sll $t1, $t0, 4
				addu $v0, $t1, $v0 #$v0 = $t0 * (2^11+2^10+2^9+2^4)
						#bien
				
				lb $t0, 1($a0) #cargamos minutos++++
				sll $v1, $t0, 5
				sll $t1, $t0, 4
				addu $v1,$v1,$t1 #$v1 = $t0 * (2^5+2^4)
				sll $t1, $t0, 3
				addu $v1, $t1, $v1 #$v1 = $t0 * (2^5+2^4+2^3)
				sll $t1, $t0, 2
				addu $v1, $t1, $v1 #$v1 = $t0 * (2^5+2^4+2^3+2^2)
				
				addu $v0,$v0,$v1
				
				lb $t0, 0($a0)
				addu $v0,$v0,$t0
				jr $ra
				
devuelve_reloj_en_s_srd:
				lb $t0, 2($a0) #cargamos la hora
				sll $v0, $t0, 11
				sll $t1, $t0, 10
				addu $v0,$v0,$t1 #$v0 = $t0 * (2^11+2^10)
				sll $t1, $t0, 9
				addu $v0, $t1, $v0 #$v0 = $t0 * (2^11+2^10+2^9)
				sll $t1, $t0, 4
				addu $v0, $t1, $v0 #$v0 = $t0 * (2^11+2^10+2^9+2^4)
						#bien
				
				lb $t0, 1($a0) #cargamos minutos++++
				sll $v1, $t0, 6
				sll $t1, $t0, 2
				subu $v1,$v1,$t1 #$v1 = $t0 * (2^6-2^2)
				
				
				addu $v0,$v0,$v1
				
				lb $t0, 0($a0)
				addu $v0,$v0,$t0
				jr $ra