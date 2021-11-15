#include <xc.inc>
    
global  KEY_Setupr,KEY_Setupc

psect	udata_acs   ; reserve data space in access ram
UART_counter: ds    1	    ; reserve 1 byte for variable UART_counter

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

KEY_Setupr:
    movlw   0x0f
    movwf   TRISE,A
    banksel PADCFG1
    bsf	    REPU
    clrf    LATE
KEY_Setupc:
    movlw   0xf0    
    movwf   TRISE,A
    banksel PADCFG1
    bsf	    REPU
    clrf    LATE
    
KEY_Read:
    call    KEY_Setupr
    movff   PORTE ; 
    ; implement a millisecond delay
    call    KEY_Setupc
Delay:
    
    


 

