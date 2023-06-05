
_initial:

;Finalproject.c,3 :: 		void initial()
;Finalproject.c,5 :: 		TRISD = 0x00;//portd is output
	CLRF       TRISD+0
;Finalproject.c,6 :: 		PORTD=0x00; //initiall value =0
	CLRF       PORTD+0
;Finalproject.c,7 :: 		TRISB = 0x01;//portb is output bit 0 is input
	MOVLW      1
	MOVWF      TRISB+0
;Finalproject.c,8 :: 		PORTB=0x00;  //initiall value =0
	CLRF       PORTB+0
;Finalproject.c,9 :: 		RCREG=0x00;  //initiall value =0
	CLRF       RCREG+0
;Finalproject.c,10 :: 		f1 = 0x00;//initiall value =0
	CLRF       _f1+0
;Finalproject.c,11 :: 		f2=0x00;//initiall value =0
	CLRF       _f2+0
;Finalproject.c,12 :: 		f3 = 0x00;//initiall value =0
	CLRF       _f3+0
;Finalproject.c,13 :: 		OPTION_REG = OPTION_REG | 0x40;  //interrupt flag on rising edge
	BSF        OPTION_REG+0, 6
;Finalproject.c,14 :: 		INTCON = INTCON | 0x90;
	MOVLW      144
	IORWF      INTCON+0, 1
;Finalproject.c,15 :: 		}
L_end_initial:
	RETURN
; end of _initial

_PWM_Init:

;Finalproject.c,16 :: 		void PWM_Init()
;Finalproject.c,21 :: 		CCP1CON = 0X0C; //Configure the CCP1 module for PWM operation
	MOVLW      12
	MOVWF      CCP1CON+0
;Finalproject.c,22 :: 		T2CON = 0x06; //TMR2 on with 1:16 Prescale
	MOVLW      6
	MOVWF      T2CON+0
;Finalproject.c,23 :: 		PR2 = 250 ; // 8us * 250 = 2ms = PWM_Period
	MOVLW      250
	MOVWF      PR2+0
;Finalproject.c,25 :: 		TRISC = TRISC & 0xFB; // CCP1/RC2 Pin Output
	MOVLW      251
	ANDWF      TRISC+0, 1
;Finalproject.c,27 :: 		}
L_end_PWM_Init:
	RETURN
; end of _PWM_Init

_PWM_Duty:

;Finalproject.c,28 :: 		void PWM_Duty(unsigned char duty)
;Finalproject.c,30 :: 		if(duty<=250) // Make sure the duty cycle is within the PWM_Period
	MOVF       FARG_PWM_Duty_duty+0, 0
	SUBLW      250
	BTFSS      STATUS+0, 0
	GOTO       L_PWM_Duty0
;Finalproject.c,34 :: 		CCPR1L = duty;// Store the 8 bits in the CCPR1L Reg
	MOVF       FARG_PWM_Duty_duty+0, 0
	MOVWF      CCPR1L+0
;Finalproject.c,35 :: 		}
L_PWM_Duty0:
;Finalproject.c,36 :: 		}
L_end_PWM_Duty:
	RETURN
; end of _PWM_Duty

_ms_delay:

;Finalproject.c,40 :: 		void ms_delay(){
;Finalproject.c,43 :: 		for(k=0; k<200;k++){
	CLRF       R1+0
L_ms_delay1:
	MOVLW      200
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_ms_delay2
;Finalproject.c,44 :: 		for(j=0;j<2000;j++) {
	CLRF       R2+0
	CLRF       R2+1
L_ms_delay4:
	MOVLW      7
	SUBWF      R2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__ms_delay27
	MOVLW      208
	SUBWF      R2+0, 0
L__ms_delay27:
	BTFSC      STATUS+0, 0
	GOTO       L_ms_delay5
;Finalproject.c,45 :: 		k=k;
;Finalproject.c,46 :: 		j=j;
;Finalproject.c,44 :: 		for(j=0;j<2000;j++) {
	INCF       R2+0, 1
	BTFSC      STATUS+0, 2
	INCF       R2+1, 1
;Finalproject.c,47 :: 		}
	GOTO       L_ms_delay4
L_ms_delay5:
;Finalproject.c,43 :: 		for(k=0; k<200;k++){
	INCF       R1+0, 1
;Finalproject.c,48 :: 		}
	GOTO       L_ms_delay1
L_ms_delay2:
;Finalproject.c,49 :: 		}
L_end_ms_delay:
	RETURN
; end of _ms_delay

_USART_in:

;Finalproject.c,50 :: 		void USART_in()
;Finalproject.c,53 :: 		TXSTA =0x24;// to enable Asynchronous mode transmitting
	MOVLW      36
	MOVWF      TXSTA+0
;Finalproject.c,54 :: 		RCSTA=0x90;// 8-bits transmitting
	MOVLW      144
	MOVWF      RCSTA+0
;Finalproject.c,55 :: 		SPBRG = 51; // SPBRG = (8000000 / (16 * baud rate(9600))) - 1
	MOVLW      51
	MOVWF      SPBRG+0
;Finalproject.c,56 :: 		}
L_end_USART_in:
	RETURN
; end of _USART_in

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;Finalproject.c,60 :: 		void interrupt(){
;Finalproject.c,63 :: 		f1 = ~f1;
	COMF       _f1+0, 1
;Finalproject.c,64 :: 		f2++;
	INCF       _f2+0, 1
;Finalproject.c,66 :: 		if(f2 & 0x02){
	BTFSS      _f2+0, 1
	GOTO       L_interrupt7
;Finalproject.c,67 :: 		f3 = ~f3;
	COMF       _f3+0, 1
;Finalproject.c,68 :: 		OPTION_REG = OPTION_REG ^ 0x40;// changing to rising edge
	MOVLW      64
	XORWF      OPTION_REG+0, 1
;Finalproject.c,69 :: 		}
L_interrupt7:
;Finalproject.c,73 :: 		OPTION_REG = OPTION_REG ^ 0x40;  // falling edge
	MOVLW      64
	XORWF      OPTION_REG+0, 1
;Finalproject.c,74 :: 		INTCON = INTCON & 0xFD; // clear the interrupr
	MOVLW      253
	ANDWF      INTCON+0, 1
;Finalproject.c,75 :: 		}
L_end_interrupt:
L__interrupt30:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;Finalproject.c,77 :: 		void main(){
;Finalproject.c,78 :: 		USART_in();
	CALL       _USART_in+0
;Finalproject.c,79 :: 		PWM_Init();
	CALL       _PWM_Init+0
;Finalproject.c,80 :: 		initial();
	CALL       _initial+0
;Finalproject.c,81 :: 		while(1){
L_main8:
;Finalproject.c,82 :: 		PORTC=0x00;
	CLRF       PORTC+0
;Finalproject.c,83 :: 		PWM_Duty(130);//initial speed
	MOVLW      130
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,84 :: 		PORTB=0x14; //forward
	MOVLW      20
	MOVWF      PORTB+0
;Finalproject.c,86 :: 		if(RCREG==0x31)
	MOVF       RCREG+0, 0
	XORLW      49
	BTFSS      STATUS+0, 2
	GOTO       L_main10
;Finalproject.c,88 :: 		PWM_Duty(130);
	MOVLW      130
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,89 :: 		PORTB=0x14;
	MOVLW      20
	MOVWF      PORTB+0
;Finalproject.c,90 :: 		ms_delay();
	CALL       _ms_delay+0
;Finalproject.c,91 :: 		}
L_main10:
;Finalproject.c,92 :: 		if(RCREG==0x32)
	MOVF       RCREG+0, 0
	XORLW      50
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;Finalproject.c,94 :: 		PWM_Duty(130);
	MOVLW      130
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,95 :: 		PORTB=0x0A;//backward
	MOVLW      10
	MOVWF      PORTB+0
;Finalproject.c,96 :: 		ms_delay();
	CALL       _ms_delay+0
;Finalproject.c,97 :: 		}
L_main11:
;Finalproject.c,98 :: 		if(RCREG==0x33)
	MOVF       RCREG+0, 0
	XORLW      51
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;Finalproject.c,100 :: 		PWM_Duty(130);
	MOVLW      130
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,101 :: 		PORTB=0x00;//stop
	CLRF       PORTB+0
;Finalproject.c,102 :: 		ms_delay();
	CALL       _ms_delay+0
;Finalproject.c,103 :: 		}
L_main12:
;Finalproject.c,104 :: 		if(RCREG==0x34)
	MOVF       RCREG+0, 0
	XORLW      52
	BTFSS      STATUS+0, 2
	GOTO       L_main13
;Finalproject.c,107 :: 		PORTD=0x80; //water pump on
	MOVLW      128
	MOVWF      PORTD+0
;Finalproject.c,108 :: 		ms_delay();
	CALL       _ms_delay+0
;Finalproject.c,109 :: 		}
L_main13:
;Finalproject.c,111 :: 		if(RCREG==0x35)
	MOVF       RCREG+0, 0
	XORLW      53
	BTFSS      STATUS+0, 2
	GOTO       L_main14
;Finalproject.c,113 :: 		PWM_Duty(130);
	MOVLW      130
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,114 :: 		PORTB=0x10; //right
	MOVLW      16
	MOVWF      PORTB+0
;Finalproject.c,115 :: 		ms_delay();
	CALL       _ms_delay+0
;Finalproject.c,116 :: 		}
L_main14:
;Finalproject.c,117 :: 		if(RCREG==0x36)
	MOVF       RCREG+0, 0
	XORLW      54
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;Finalproject.c,119 :: 		PWM_Duty(130);
	MOVLW      130
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,120 :: 		PORTB=0x04;//left
	MOVLW      4
	MOVWF      PORTB+0
;Finalproject.c,121 :: 		ms_delay();
	CALL       _ms_delay+0
;Finalproject.c,122 :: 		}
L_main15:
;Finalproject.c,124 :: 		while(f3)
L_main16:
	MOVF       _f3+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main17
;Finalproject.c,126 :: 		PWM_Duty(60); //slow down speed
	MOVLW      60
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,127 :: 		PORTD=0x80;
	MOVLW      128
	MOVWF      PORTD+0
;Finalproject.c,128 :: 		PORTB = 0x0A;
	MOVLW      10
	MOVWF      PORTB+0
;Finalproject.c,129 :: 		}
	GOTO       L_main16
L_main17:
;Finalproject.c,131 :: 		if(f2 == 25)
	MOVF       _f2+0, 0
	XORLW      25
	BTFSS      STATUS+0, 2
	GOTO       L_main18
;Finalproject.c,133 :: 		TRISB=0x00;
	CLRF       TRISB+0
;Finalproject.c,134 :: 		PORTB=0x00;
	CLRF       PORTB+0
;Finalproject.c,135 :: 		PORTD=0x00;
	CLRF       PORTD+0
;Finalproject.c,136 :: 		while(1) ;
L_main19:
	GOTO       L_main19
;Finalproject.c,137 :: 		}
L_main18:
;Finalproject.c,139 :: 		while(f1) {
L_main21:
	MOVF       _f1+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_main22
;Finalproject.c,140 :: 		PWM_Duty(65);  //slow down speed
	MOVLW      65
	MOVWF      FARG_PWM_Duty_duty+0
	CALL       _PWM_Duty+0
;Finalproject.c,141 :: 		PORTD=0x80;
	MOVLW      128
	MOVWF      PORTD+0
;Finalproject.c,142 :: 		PORTB = 0x14;
	MOVLW      20
	MOVWF      PORTB+0
;Finalproject.c,145 :: 		}
	GOTO       L_main21
L_main22:
;Finalproject.c,146 :: 		}
	GOTO       L_main8
;Finalproject.c,151 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
