; PIC16F648A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
CBLOCK
  CUENTA
 ENDC
 
 
NUMERO EQU D'10'
 
;PORTB 7 -> SALIDA
#DEFINE LED PORTB,7
 
    ORG	    0
    GOTO    INICIO
    ORG	    4
    GOTO    INT_EXT

    
;INICIO
;    BSF	    STATUS,RP0; BANCO 1
;    BSF	    TRISB,0 ;ENTRADA PIN RB0
;    BCF	    TRISB,7 ; SALIDA PIN RB7
;    BCF	    STATUS,RP0; BANCO 1
;    CLRF    PORTB; PORTB -> 0
;    BSF	    INTCON,7; GIE -> 1
;    BSF	    INTCON,6; PIEI -> 1
;    BSF	    INTCON,4; INT0 HABILITADA
;    BCF	    INTCON,1; INTF0 -> 0
;START
;    GOTO    START
;    
;INT_EXT
;    BTFSS   LED
;    GOTO    ENCENDER
;    BCF	    LED
;    GOTO    FIN_INT
;ENCENDER
;    BSF	    LED
;FIN_INT
;    BCF	    INTCON,1
;    RETFIE
    
    
INICIO
    CLRF    CUENTA
    BSF	    CMCON,2
    BSF	    CMCON,1
    BSF	    CMCON,0 ; PORTA RA0 RA1 RA2 RA3 -> DIGITALES
    BSF	    STATUS,RP0; BANCO 1
    MOVLW   B'11100000'; RA0 - RA4 -> SALIDA
    MOVWF   TRISA
    BSF	    TRISB,0 ;ENTRADA PIN RB0
    BCF	    STATUS,RP0; BANCO 1
    CLRF    PORTB; PORTB -> 0
    BSF	    INTCON,7; GIE -> 1
    BSF	    INTCON,6; PIEI -> 1
    BSF	    INTCON,4; INT0 HABILITADA
    BCF	    INTCON,1; INTF0 -> 0
START
    MOVF    CUENTA,W
    MOVWF   PORTA
    GOTO    START
    
INT_EXT
    INCF    CUENTA,F; F- > CUENTA
		    ; W -> W 
    MOVLW   NUMERO ; NUMERO -> W
    SUBWF   CUENTA,W; CUENTA - W(NUMERO) = W
    BTFSS   STATUS,Z; ¿Z == 1? 
    GOTO    FIN_INT
    MOVLW   D'0'
    MOVWF   CUENTA
FIN_INT
    BCF	    INTCON,1
    RETFIE
    
    END