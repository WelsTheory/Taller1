
; PIC16F648A Configuration Bit Settings

; Assembly source line config statements

#include "p16f648a.inc"

; CONFIG
; __config 0xFF21
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _MCLRE_ON & _BOREN_OFF & _LVP_OFF & _CPD_OFF & _CP_OFF
