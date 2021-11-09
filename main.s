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
SPI_MasterInit:	; Set Clock edge to negative
	bcf	CKE2	; CKE bit in SSP2STAT, 
	; MSSP enable; CKP=1; SPI master, clock=Fosc/64 (1MHz)
	movlw 	(SSP2CON1_SSPEN_MASK)|(SSP2CON1_CKP_MASK)|(SSP2CON1_SSPM1_MASK)
	movwf 	SSP2CON1, A
	; SDO2 output; SCK2 output
	bcf	TRISD, PORTD_SDO2_POSN, A	; SDO2 output
	bcf	TRISD, PORTD_SCK2_POSN, A	; SCK2 output
	return 

SPI_MasterTransmit:  ; Start transmission of data (held in W)
	movwf 	SSP2BUF, A 	; write data to output buffer
Wait_Transmit:	; Wait for transmission to complete 
	btfss 	SSP2IF		; check interrupt flag to see if data has been sent
	bra 	Wait_Transmit
	bcf 	SSP2IF		; clear interrupt flag
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
	
	