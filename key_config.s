#include <xc.inc>
    
global  KEY_Read, KEY_Setupr,KEY_Setupc

psect	udata_acs   ; reserve data space in access ram
UART_counter: ds    1	    ; reserve 1 byte for variable UART_counter
row:	    ds 1
column:	    ds 1
position:   ds 1
    
psect	uart_code,class=CODE
UART_Setup:
    bsf	    SPEN	; enable
    bcf	    SYNC	; synchronous
    bcf	    BRGH	; slow speed
    bsf	    TXEN	; enable transmit
    bcf	    BRG16	; 8-bit generator only
    movlw   103		; gives 9600 Baud rate (actually 9615)
    movwf   SPBRG1, A	; set baud rate
    bsf	    TRISC, PORTC_TX1_POSN, A	; TX1 pin is output on RC6 pin
					; must set TRISC6 to 1
    return

KEY_Setupr:		; Sets up the keyboard to read for rows
    movlw   0x0f	; These are the last 4 bits
    movwf   TRISE, A
    banksel PADCFG1
    bsf	    REPU
    clrf    LATE
    return
    
KEY_Setupc:		; Sets up the keyboard to read for columns
    movlw   0xf0	; These are the first 4 bits
    movwf   TRISE,A
    banksel PADCFG1
    bsf	    REPU
    clrf    LATE
    return
    
KEY_Read:
    ; Setup ports
    movlw   0x00
    movwf   TRISD, A
    movwf   TRISC, A
    
    call    KEY_Setupr	    ; Read the row
    call    Longdelay	    ; implement a millisecond delay
    movff   PORTE, row	    ; 
    ;movff   PORTE, 0x02 ; 
    
    call    KEY_Setupc	    ; Read the column
    call    Longdelay
    movff   PORTE, column ;
    
    ; Implement Echo to PORTC
    ;movf    0x02, 0
    movf    row, W, A
    movwf   PORTD
    
    addwf   column, W, A	    ; sums rows and columns to get position encoding
    movwf   position, A
    movff   position, PORTC
    
    
    ;movff   column, PORTD

    return

KEY_Decode:
    ;movff   row
    return
    
; implement a millisecond delay
Longdelay:		    
        call    Bigdelay
	call    Bigdelay
	return
    
; implementation of the 16 bit delay
Bigdelay:
	movlw 0xff
	movwf 0x10, A	    ; first 8 bits and last 8 are 1s
	movlw 0xff		    
	movwf 0x11, A		    
	
	movlw 0x00 ; W = 0
	
Dloop:	decf 0x11, f, A	    ; counter decrement
	subwfb 0x10, f, A
	bc Dloop
	return 
    
    

