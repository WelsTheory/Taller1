; PIC16F648A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
 
    ORG	    0
    GOTO    INICIO
		;V     R    

    
INICIO
    BSF	    STATUS,RP0; BANCO 1
    BSF	    TRISB,0
    BSF	    TRISB,1
    BCF	    TRISB,6
    BCF	    TRISB,7
;    MOVLW   B'00000011' ;W
;    MOVWF   TRISB; W = '00000011' = TRISB
;    CLRF    TRISB; TRISB = 0
    BCF	    STATUS,RP0; BANCO 1
    CLRF    PORTB; PORTB -> 0
START
    BTFSC   PORTB,0
    GOTO    PREG
    BTFSC   PORTB,1
    GOTO    PREG2
    BSF	    PORTB,6
    BCF	    PORTB,7
    GOTO    START
    ;RB1 - RB0 = RB7 - RB6
    ; 0	    0 =   0     1
    ; 0     1 =   1     0 -> CORRECTA
    ; 1     0 =   0     0
    ; 1     1 =   1     1
PREG
    BTFSC   PORTB,1
    GOTO    ENC
    BCF	    PORTB,6
    BSF	    PORTB,7
    GOTO    START

ENC
    BSF	    PORTB,6
    BSF	    PORTB,7
    GOTO    START
    
PREG2
    BCF	    PORTB,6
    BCF	    PORTB,7
    GOTO    START
    END