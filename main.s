	#include <xc.inc>

	psect	code, abs
main:
	org	0x0		    ; tells assembler where to load instructions and data    
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x0		    ; Moves 0 to the working register   
	movwf	TRISD, A
	movwf	TRISE, A	    ; Move the value 0 from the working register to TRISC-0 makes it an output  ; Port C all outputs
	movlw   0x7		    ; Output LEDs
	movwf   PORTE		    
	
	call	clock		    ;
	call	Bigdelay
	call	Bigdelay
	call	Bigdelay
	call	Bigdelay
	
	movlw   0x0		    ; Output LEDs
	movwf   PORTE		     

	call	clock		    
	call	Bigdelay
	call	Bigdelay
	call	Bigdelay
	call	Bigdelay

	goto 	0x0		    ; Re-run program from start

clock:				    ; clock routine to register in memory
	movlw	0x1		    ; Change clock from 0 to 1
	movwf   PORTD
	
	movlw	0x0
	 ;Change clock from 1 to 0
	movwf   PORTD
	
	return
    

Bigdelay:
	movlw	0xff
	movwf	0x11, A
	movwf	0x10, A
	movlw	0x00
Dloop:
	decf 0x11, f, A

	subwfb 0x10, f, A
	bc Dloop
	return
	
end	main