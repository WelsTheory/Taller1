; **** Encabezado ****
list p=16F84A
#include "p16f84a.inc"

; CONFIG
; __config 0xFFF1
 __CONFIG _FOSC_XT & _WDTE_OFF & _PWRTE_ON & _CP_OFF



;**** Declaración de Registros ****
LCD_Dato EQU	0X0C
Loop	 EQU	0X0D

Contador1	equ	0x0E	;registro	para demoras
Contador2	equ	0x0F	;registro	para demoras

	 
RS	equ	0
RW	equ	1
E	equ	2
BACK	equ	3
 
D4	equ	4
D5	equ	5
D6	equ	6
D7_BF	equ	7
;**** Declaracion de Bytes del LCD ****
LCD_PORT_Control	equ	PORTA	; PORTA para control del LCD
LCD_PORT_Data	equ	PORTB	; PORTB para envio de Datos al LCD
LCD_TRIS_Control	equ	0x85	; TRISA
LCD_TRIS_Data	equ	0x86	; TRISB
; **** Comandos de Software para la LCD ****
LCDLinea1	equ	0x80	; Dirección comienzo línea1
LCDLinea2	equ	0xC0	; Dirección comienzo línea2
LCDClr	equ	0x01	; Borra pantalla, cursor a Inicio
LCDInicio	equ	0x02	; Cursor a Inicio, DDRAM sin cambios
LCDInc	equ	0x06	; Modo incrementa cursor
LCDDec	equ	0x04	; Modo decrementa cursor
LCDOn	equ	0x0C	; Pantalla On
LCDOff	equ	0x08	; Pantalla Off
CursOn	equ	0x0E	; Pantalla On, cursor On
CursOff	equ	0x0C	; Pantalla On, cursor Off
CursBlink	equ	0x0F	; Pantalla On, Cursor parpadeante
CurIzda	equ	0x10	; Mueve cursor a la izquierda
CurDecha	equ	0x14	; Mueve cursor a la derecha
DisIzda	equ	0x18	; Mueve Display a la izquierda
DisDecha	equ	0x1C	; Mueve Display a la Derecha
LCDBus_4_2	equ	0x28	; Bus 4 bits, 2 líneas, 5x7
;**** Definiciones para el ensamblador ****
#DEFINE LCD_E	LCD_PORT_Control,E
#DEFINE LCD_RS	LCD_PORT_Control,RS
#DEFINE LCD_RW	LCD_PORT_Control,RW
#DEFINE LCD_D4	LCD_PORT_Data,D4
#DEFINE LCD_D5	LCD_PORT_Data,D5
#DEFINE LCD_D6	LCD_PORT_Data,D6
#DEFINE LCD_D7_BF	LCD_PORT_Data,D7_BF
#DEFINE	LCD_backlight	LCD_PORT_Control,BACK	; Control Backligth.-
;**** Definición de macros ****
LCD_Putc macro Carac
movlw	Carac
call	LCD_Caracter
endm
LCD_Putd macro Coman
movlw	Coman
call	LCD_Comando
endm
;//////////////////////////////////////////////////////////
;**** Inicio del Micro ****
org	0x00
goto	Inicio
;**** Programa principal ****
org	0x05
Inicio
call	LCD_Config_puertos	; Configuramos Puertos a utilizar por LCD.-
call	LCD_Init	; Inicializamos LCD.-
bsf	LCD_backlight	; Prendemos Backlight.-
;LCD_Putd CursBlink	; Cursor Parpadeante.-
MOVLW	'I'	; Escribimos en LCD.-
CALL	LCD_Caracter
LCD_Putc 'n'
LCD_Putc 'f'
LCD_Putc 'o'
LCD_Putc 'P'
LCD_Putc 'I'
LCD_Putc 'C'
Bucle
nop
GOTO	Bucle	; Bucle Infinito.-

;**** Configuracion de puertos ****
LCD_Config_puertos
bsf	STATUS,RP0	; Seleccionamos Banco 1.-
bcf	LCD_RS	; Colocamos todas las lineas de control y bus como Salidas.-
bcf	LCD_RW	
bcf	LCD_E	
bcf	LCD_D4	
bcf	LCD_D5	
bcf	LCD_D6	
bcf	LCD_D7_BF	
bcf	LCD_backlight	
bcf	STATUS,RP0	;	Volvemos an Banco	0.-
bcf	LCD_RS	
bcf	LCD_RW	
bcf	LCD_E	
bcf	LCD_D4	
bcf	LCD_D5	
bcf	LCD_D6	
bcf	LCD_D7_BF	
bcf	LCD_backlight	
return		
;...................................
;**** Inicializacion de LCD ****
LCD_Init
bcf	STATUS,RP0	; Aseguramos Banco 0.-
movlw	0x03	
movwf	Loop	
bsf	LCD_D4	;<D7 D6 D5 D4> = 0011.-
bsf	LCD_D5	
;.... se ejecuta 3 veces el siguiente bloque ....
bsf	LCD_E
call	Demora_5ms	
bcf	LCD_E
call	Demora_5ms	
decfsz Loop
goto	$-5
;.... Interfase de 4 bits ....
bcf	LCD_D4	;<D7 D6 D5 D4> = 0010.-
bsf	LCD_E
call	Demora_5ms	
bcf	LCD_E
call	Demora_5ms	
;.... Sistema -> << Bus de 4 bits, 2 lineas, 5x7>>.-
movlw	LCDBus_4_2
call	LCD_Comando
;....Limpia display y retorna al origen ....
movlw	LCDClr
call	LCD_Comando
return
;.........................................
;**** Lee Estado del LCD ****
LCD_Bandera
bcf	LCD_RW	
bcf	LCD_RS	
bcf	LCD_E	
bcf	LCD_D4	
bcf	LCD_D5	
bcf	LCD_D6	
bcf	LCD_D7_BF	
NOP
BCF	LCD_RW
; Modo Lectura.-	
bsf	STATUS,RP0	;	Banco 1.-
bsf	LCD_D7_BF	;	Configura TRIS para recibir estado del		
bcf	STATUS,RP0	;	Banco 1.-
bsf	LCD_E		
nop			
btfsc	LCD_D7_BF	;	Lee estado del LCD, 1-> Ocupado.-
goto	$-1	;	Esperamos a que se desocupe.-
bcf	LCD_E	;	LCD_D7/BF->0, seguimos adelante.-
bsf	STATUS,RP0	;	Banco 1.-
bcf	LCD_D7_BF	;	Reconfigura TRIS para envio de Data.-
bcf	STATUS,RP0	;	Banco 1.-
return			
;.............................
;**** Envia pulso Enable ****
LCD_Enable
bsf	LCD_E
nop
nop
bcf	LCD_E
return
;.............................
;**** Envia Dato al LCD ****
;*** Previamente configurado como Comando o como Caracter.-
LCD_Envio_Data
movwf	LCD_Dato	;	Guardamos Dato a enviar.-
bcf	LCD_D4	;	Cargamos un cero.-
btfsc	LCD_Dato,4	;	
bsf	LCD_D4			
bcf	LCD_D5	;		
btfsc	LCD_Dato,5			
bsf	LCD_D5			
bcf	LCD_D6	;		
btfsc	LCD_Dato,6			
bsf	LCD_D6			
bcf	LCD_D7_BF	;		
btfsc	LCD_Dato,7			
bsf	LCD_D7_BF			
call	LCD_Enable	;	Habilitamos LCD para recepcion de	Data.-
			;	CARGAMOS NIBLE BAJO EN PUERTO.-	
bcf	LCD_D4	;	Cargamos un cero.-	
btfsc	LCD_Dato,0	;	Si es 1, modificamos a uno, sino	
bsf	LCD_D4	
bcf	LCD_D5	;
btfsc	LCD_Dato,1	
bsf	LCD_D5		
bcf	LCD_D6	;	
btfsc	LCD_Dato,2		
bsf	LCD_D6		
bcf	LCD_D7_BF	;	
btfsc	LCD_Dato,3		
bsf	LCD_D7_BF		
call	LCD_Enable	; Habilitamos LCD para recepcion de	Data.-
return			

;**** Envia Comando al LCD ****
LCD_Comando
call	LCD_Bandera	;Controla si el LCD esta en condiciones de recibir un nuevo dato.-
bcf	LCD_RW	; Modo escritura.-
bcf	LCD_RS	; Se enviara Comando.-
call	LCD_Envio_Data ; Envio Comando.-
return
;.............................
;**** Envia Caracter al LCD ****
LCD_Caracter
call	LCD_Bandera	;Controla si el LCD esta en condiciones de recibir un nuevo dato.-
bcf	LCD_RW	; Modo escritura.-
bsf	LCD_RS	; Se enviara Caracter.-
call	LCD_Envio_Data ; Envio Caracter.-
return
			
			;**** Demora ****
Demora_5ms
movlw	0xC8	; 200
movwf	Contador1	; Iniciamos contador1.-
Repeticion1
movlw	0x07	;
movwf	Contador2	; Iniciamos contador2
Repeticion2
decfsz Contador2,1	; Decrementa Contador2 y si es 0 sale.-
goto	Repeticion2	; Si no es 0 repetimos ciclo.-
decfsz Contador1,1	; Decrementa Contador1.-
goto	Repeticion1	; Si no es cero repetimos ciclo.-
return	; Regresa de la subrutina.-

end
