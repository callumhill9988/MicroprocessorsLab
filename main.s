	#include <xc.inc>

	psect	code, abs
main:
	org	0x0		    ;tells assembler where to load instructions and data    
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0		 ;Moves 0 to the working register   
	movwf	TRISC, A	  ;Move the value 0 from the working register to TRISC-0 makes it an output  ; Port C all outputs
	bra 	test
loop:
	movff 	0x06, PORTC
	incf 	0x06, W, A
test:
	movwf	0x06, A          ;Move 0 from working register to 0x06
	movlw	0xff			; all bits are inputs-0xff=8x1
	movwf 	TRISD, A		; Port D TRIS Register
	 		
	movf	PORTD, W, A			;Puts value from port d into working memory-store it in access ram
	
	cpfsgt 	0x06, A ;compares value in 0x06 with with W,skip if f>w
	bra 	loop		    ; Not yet finished goto start of loop again
	goto 	0x0		    ; Re-run program from start

	end	main
