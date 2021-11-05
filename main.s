	#include <xc.inc>

	psect	code, abs
main:
	org	0x0		    ;tells assembler where to load instructions and data    
	goto	start

	org	0x100		    ; Main code starts here at address 0x100
start:
	movlw 	0x00		    ;Moves 0 to the working register   
	movwf	TRISC, A	    ;Move the value 0 from the working register to TRISC-0 makes it an output  ; Port C all outputs
	call read_d
	call convert
	goto 	0x0		    ; Re-run program from start

read_d:
	movwf	0x06, A		    ;Move 0 from working register to 0x06
	movlw	0xff		    ; all bits are inputs-0xff=8x1
	movwf 	TRISD, A	    ; Port D TRIS Register
	 		
	movf	PORTD, W, A
	movwf 0x07, A		    ;Puts value from port d into working memory-store it in access ram
	return 
convert:
        movff 0x07, 0x10, A		   ; moves input in D to 0x10, first 8 bits
	movlw 0x00		    ; all zeros as last 8 bits
	movwf 0x11, A		    ; move zeros to behind portD values
	call Bigdelay
	
	movlw 0xff		    ; Turns all LEDS on
        movwf PORTC
	
	call Bigdelay
	
	movlw 0x00		    ; Turns all LEDS off
	movwf PORTC

	return
; implementation of the 16 bit delay
Bigdelay: 
	movlw 0x00 ; W = 0
Dloop:	decf 0x11, f, A ; counter decrement
	subwfb 0x10, f, A
	bc Dloop
	return 
	
end main       
    
        
  
    
