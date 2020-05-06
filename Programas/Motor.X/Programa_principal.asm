;
;; PIC16F877A Configuration Bit Settings
;
;; Assembly source line config statements
;
;#include "p16f648a.inc"
;
;; CONFIG
;; __config 0xFF21
;CBLOCK
;CUENTA
;    ENDC
;    
;NUMERO EQU D'62' ; -> 100%
;; CONFIG
;; __config 0xFF21
; __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
; 
;    ORG	    0
;    GOTO    INICIO
;  
;INICIO
;    MOVLW   B'00000111'
;    MOVWF   CMCON
;    BSF	    STATUS,RP0
;    BSF	    TRISA,0
;    BCF	    TRISB,0; PINES DIR
;    BCF	    TRISB,1
;    BCF	    TRISB,3; CCP1 PWM - enable motor
;    MOVLW   D'187'; periodo 3 ms
;    MOVWF   PR2
;    BCF	    STATUS,RP0
;
;    ;100% DUTY CYCLE -> 750 = 10111011 10
;    ;50% -> X
;    ;100% -> 750
;    ; X = 750*50/100 = 375
;    ; DUTY 10 BITS -> 375
;    ; 01011101 11
;;    MOVLW   B'01011101'
;;    MOVWF   CCPR1L
;;    BSF	    CCP1CON,4; 1
;;    BSF	    CCP1CON,5; 0
;    MOVLW   B'10111011'
;    MOVWF   CCPR1L
;    BSF	    CCP1CON,4; 1
;    BCF	    CCP1CON,5; 0
;    
;    BSF	    CCP1CON,3; PWM -> 11XX
;    BSF	    CCP1CON,2
;    BSF	    CCP1CON,1
;    BSF	    CCP1CON,0
;    BSF	    T2CON,0
;    BSF	    T2CON,1 ; PRESCALER 16
;    BSF	    T2CON,2; TMR2 ON
;    CLRF    CUENTA
;START
;    BTFSS   PORTA,0
;    GOTO    CONTRARIO
;    BSF	    PORTB,0
;    BCF	    PORTB,1
;    GOTO    START
;    
;CONTRARIO
;    BCF	    PORTB,0
;    BSF	    PORTB,1
;    GOTO    START
;	END
;	
	
; PIC16F877A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
CBLOCK
CUENTA
ENDC
    
NUMERO EQU D'5' ; -> 100%
; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
 
    ORG	    0
    GOTO    INICIO
    ORG	    4
    GOTO    INT_TMR0
  
INICIO
    MOVLW   B'00000111'
    MOVWF   CMCON
    BSF	    STATUS,RP0
    BSF	    TRISA,0; GIRO
    BCF	    TRISB,0; PINES DIR
    BCF	    TRISB,1
    BCF	    TRISB,3; CCP1 PWM - enable motor
    BCF	    OPTION_REG,5; TEMPORIZADOR
    BCF	    OPTION_REG,3; PSA -> TMR0
    BSF	    OPTION_REG,2;
    BSF	    OPTION_REG,1
    BSF	    OPTION_REG,0; 111 -> 256 PRESCALER
    BCF	    STATUS,RP0
    MOVLW   D'217'
    MOVWF   TMR0; TMR0 = 217
    BSF	    INTCON,T0IE; TMR0 INT HABILITADA
    BCF	    INTCON,2; FLANCO
    BSF	    INTCON,7; GIE -> 1
    BSF	    INTCON,6; PIEI -> 1
    CLRF    CUENTA
START
    BTFSS   PORTA,0
    GOTO    CONTRARIO
    BSF	    PORTB,0
    BCF	    PORTB,1
    GOTO    START
    
CONTRARIO
    BCF	    PORTB,0
    BSF	    PORTB,1
    GOTO    START
    
INT_TMR0
    MOV
    CLRF    CUENTA
FIN_INT
    MOVLW   D'240'
    MOVWF   TMR0; TMR0 = 240
    BCF	    INTCON,2
    RETFIE    
    
#include "Retardos.inc"    
    
	END