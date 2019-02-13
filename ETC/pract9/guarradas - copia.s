.globl __start
          .data 0x10000000

string:   .asciiz "á"             

          .text 0x00400000
__start:  lb $t0, string
		  
