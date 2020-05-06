
; PIC16F648A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

CBLOCK
CUENTA
    ENDC
    
NUMERO EQU D'62' ; -> 100%
; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    ORG	    0
    GOTO    INICIO
    ORG	    4
    GOTO    INT_EXT
  
INICIO
    BSF	    STATUS,RP0
    BCF	    TRISB,3; CCP1 PWM
    BSF	    TRISB,0; ENTRADA
    BCF	    TRISB,1
    BCF	    TRISB,2
    MOVLW   D'62'
    MOVWF   PR2
    BCF	    STATUS,RP0
    BSF	    INTCON,7; GIE -> 1
    BSF	    INTCON,6; PIEI -> 1
    BSF	    INTCON,4; INT0 HABILITADA
    BCF	    INTCON,1; INTF0 -> 0
    ;100% DUTY CYCLE -> 250
    ;50% -> X
    ;100% -> 125
    ; X = 250*50/100 = 125
    ; DUTY 10 BITS -> 125
    ; 0001 1111 01
    MOVLW   B'00011111'
    MOVWF   CCPR1L
    BSF	    CCP1CON,4; 1
    BCF	    CCP1CON,5; 0
    BSF	    CCP1CON,3; PWM -> 11XX
    BSF	    CCP1CON,2
    BSF	    CCP1CON,1
    BSF	    CCP1CON,0
    BSF	    T2CON,0
    BCF	    T2CON,1 ; PRESCALER 4
    BSF	    T2CON,2; TMR2 ON
    CLRF    CUENTA
START
    BSF	    PORTB,1
    BCF	    PORTB,2
    
    GOTO    START
    
INT_EXT
    INCF    CUENTA,F
    MOVLW   NUMERO ; NUMERO -> W
    SUBWF   CUENTA,W; CUENTA - W(NUMERO) = W
    BTFSS   STATUS,Z; ¿Z == 1? 
    GOTO    MUESTRA
    MOVLW   D'0'
    MOVWF   CUENTA
MUESTRA
    MOVF    CUENTA,W ; CUENTA -> W
    MOVWF   CCPR1L
    BCF	    INTCON,1
    RETFIE
    
 #include "Retardos.inc"   
    
    END
    