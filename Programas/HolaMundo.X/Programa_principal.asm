
; PIC16F648A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
 
    ORG	    0
    GOTO    INICIO
    
;INICIO
;    ;STATUS -> RP1 RP0
;    ;		0   0 -> BANCO 0
;    ;		0   1 -> BANCO 1
;    ;		1   0 -> BANCO 2
;    ;		1   1 -> BANCO 3
;    BSF	    STATUS,RP0  ;BANCO 1 -> TRISB
;    ;BSF	-> 1 BIT 
;    ; BSF   REGISTRO,BIT
;    BCF     TRISB,0	; 1 -> ENTRADA , SALIDA -> 0
;    ;PIN RB0 -> SALIDA
;    BSF	    TRISB,1    ; RB1 -> ENTRADA , TRISB,1 = 1
;    ;BANCO 0
;    BCF	    STATUS,RP0
;START
;    BSF	    PORTB,0;  RB0 -> 1 
;    GOTO    START
    
    INICIO
    BSF	    STATUS,RP0  ;BANCO 1 -> TRISB
    BCF     TRISB,0	; 1 -> ENTRADA , SALIDA -> 0
    BSF	    TRISB,1    ; RB1 -> ENTRADA , TRISB,1 = 1
    BCF	    STATUS,RP0
START
    ; RB1 -> 1 = RB0 = 1
    ; RB0 -> 0 - RB0 = 0
    BTFSS   PORTB,1
    GOTO    APAGAR; RB0 -> 0
    BCF	    PORTB,0;  RB0 -> 1
    GOTO    START
    
APAGAR
    BSF	    PORTB,0
    GOTO    START
    
    END
    
    