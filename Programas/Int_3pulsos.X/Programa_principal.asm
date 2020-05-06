;Cada 3 veces que se actúe sobre el pin RB0/INT
;El LED conectado al pin RA3 cambiará de encendido a apagado y viceversa.

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

CBLOCK
 CUENTA
ENDC
 
NUMERO EQU D'3'
 
#DEFINE LED PORTA,3
 
    ORG	    0
    GOTO    INICIO
    ORG	    4
    GOTO    INT_EXT
    
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
    GOTO    START
    
INT_EXT
    INCF    CUENTA,F
    MOVLW   NUMERO ; NUMERO -> W
    SUBWF   CUENTA,W; CUENTA - W(NUMERO) = W
    BTFSS   STATUS,Z; ¿Z == 1? 
    GOTO    FIN_INT
    MOVLW   D'0'
    MOVWF   CUENTA
    BTFSS   LED
    GOTO    ENCENDER
    BCF	    LED
    GOTO    FIN_INT
ENCENDER
    BSF	    LED
FIN_INT
    BCF	    INTCON,1
    RETFIE
    
    END