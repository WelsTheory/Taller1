; PIC16F648A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF

    ORG	    0
    GOTO    INICIO

#DEFINE		LED	PORTB,7    
TMR0_Carga1ms	EQU	D'240'
	
;   TMR0 => 0 A 255
;
;   TMR0 = 256 - ((TIEMPO_DESEADO*FOSC)/(PRESCALER*4)) 
;   (1mS) -> TMR0 = 256 - ((1ms*4MHZ)/(64*4))
;   TMR0 = 240.375 = 240
    
INICIO
    BSF	    STATUS,RP0; BANCO 1
    BCF	    TRISB,0 ;ENTRADA PIN RB0
    BCF	    TRISB,7 ;SALIDA PIN RB7
    BCF	    OPTION_REG,5; TEMPORIZADOR
    BCF	    OPTION_REG,3; PSA -> TMR0
    BSF	    OPTION_REG,2;
    BCF	    OPTION_REG,1
    BSF	    OPTION_REG,0; 101 -> 64 PRESCALER
    BCF	    STATUS,RP0; BANCO 1
START
    BSF	    LED
    CALL    Timer0
    BCF	    LED
    CALL    Timer0
    GOTO    START

;RUTINA 1mSeg    
Timer0
    MOVLW   TMR0_Carga1ms	    ;Carga el Timer0 con el valor que queremos
    MOVWF   TMR0
    BCF	    INTCON,T0IF		    ;Reseteamos el Flag de desbordamiento del TMR0
Timer0_Desbordamiento
    BTFSS   INTCON,T0IF		    ;¿Se ha desbordado el TMR0?
    GOTO    Timer0_Desbordamiento   ;Aún no, Repite.
    RETURN    
    
    
    END