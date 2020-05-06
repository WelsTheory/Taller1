; PIC16F648A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

    ORG	    0
    GOTO    INICIO
    ORG	    4
    GOTO    INT_TMR0

#DEFINE LED PORTB,0    
    
;   TMR0 => 0 A 255
;
;   TMR0 = 256 - ((TIEMPO_DESEADO*FOSC)/(PRESCALER*4)) 
;   (1mS) -> TMR0 = 256 - ((10ms*4MHZ)/(256*4))
;   TMR0 = 240.375 = 240
    
INICIO
    BSF	    STATUS,RP0; BANCO 1
    BCF	    TRISB,0 ;ENTRADA PIN RB0
    BCF	    OPTION_REG,5; TEMPORIZADOR
    BCF	    OPTION_REG,3; PSA -> TMR0
    BSF	    OPTION_REG,2;
    BCF	    OPTION_REG,1
    BSF	    OPTION_REG,0; 101 -> 64 PRESCALER
    BCF	    STATUS,RP0; BANCO 1
    MOVLW   D'240'
    MOVWF   TMR0; TMR0 = 240
    BSF	    INTCON,T0IE; TMR0 INT HABILITADA
    BCF	    INTCON,2; FLANCO
    BSF	    INTCON,7; GIE -> 1
    BSF	    INTCON,6; PIEI -> 1
START
    GOTO    START
    
INT_TMR0
    BTFSS   LED
    GOTO    ENCENDER
    BCF	    LED
    GOTO    FIN_INT
ENCENDER
    BSF	    LED
FIN_INT
    MOVLW   D'240'
    MOVWF   TMR0; TMR0 = 240
    BCF	    INTCON,2
    RETFIE
    
    END