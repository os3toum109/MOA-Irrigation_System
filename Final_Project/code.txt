unsigned char f1, f2, f3;
     //unsigned int PWM_freq = 500;  // PWM_Period = 2ms
     void initial()
     {
      TRISD = 0x00;//portd is output
      PORTD=0x00; //initiall value =0
     TRISB = 0x01;//portb is output bit 0 is input
     PORTB=0x00;  //initiall value =0
     RCREG=0x00;  //initiall value =0
      f1 = 0x00;//initiall value =0
      f2=0x00;//initiall value =0
      f3 = 0x00;//initiall value =0
      OPTION_REG = OPTION_REG | 0x40;  //interrupt flag on rising edge
      INTCON = INTCON | 0x90;
     }
    void PWM_Init()
{
     /*Fosc = 8Mghz, Finp = 2Mghz, Tinp = 0.5us, Tinc = 0.5us
     With 1:16 Prescale, Tinc = 8us (TMR2 increments every 8us)*/

     CCP1CON = 0X0C; //Configure the CCP1 module for PWM operation
     T2CON = 0x06; //TMR2 on with 1:16 Prescale
     PR2 = 250 ; // 8us * 250 = 2ms = PWM_Period
     //PR2 = (Fosc / (PWM_freq*4*TMR2PRESCALE)) - 1;
     TRISC = TRISC & 0xFB; // CCP1/RC2 Pin Output

}
void PWM_Duty(unsigned char duty)
{
     if(duty<=250) // Make sure the duty cycle is within the PWM_Period
     {
            //We will be using only 8 bits for the duty cycle
            //duty resolution = 8-bits
            CCPR1L = duty;// Store the 8 bits in the CCPR1L Reg
     }
}

   void bck();
   //delay for 1.6 sec
   void ms_delay(){
  unsigned char k;
  unsigned int j;
  for(k=0; k<200;k++){
  for(j=0;j<2000;j++) {
  k=k;
  j=j;
  }
  }
  }
  void USART_in()
{
// Fosc = 8 MHz and Baud Rate = 9600 bps.
TXSTA =0x24;// to enable Asynchronous mode transmitting
RCSTA=0x90;// 8-bits transmitting
SPBRG = 51; // SPBRG = (8000000 / (16 * baud rate(9600))) - 1
}

  /* in the interrupt code we are trying to make the car to enter the track and rise the interrupt flag so we are trying
  to make the edge change every time it end the black track so it start walcking backward*/
  void interrupt(){


       f1 = ~f1;
        f2++;

       if(f2 & 0x02){
       f3 = ~f3;
        OPTION_REG = OPTION_REG ^ 0x40;// changing to rising edge
        }



       OPTION_REG = OPTION_REG ^ 0x40;  // falling edge
       INTCON = INTCON & 0xFD; // clear the interrupr
  }

void main(){
USART_in();
 PWM_Init();
 initial();
     while(1){
       PORTC=0x00;
      PWM_Duty(130);//initial speed
       PORTB=0x14; //forward
       // mapping the value received from RCREG
     if(RCREG==0x31)
{
PWM_Duty(130);
PORTB=0x14;
ms_delay();
}
if(RCREG==0x32)
{
PWM_Duty(130);
PORTB=0x0A;//backward
ms_delay();
}
if(RCREG==0x33)
{
PWM_Duty(130);
PORTB=0x00;//stop
ms_delay();
}
if(RCREG==0x34)
{

PORTD=0x80; //water pump on
ms_delay();
}

 if(RCREG==0x35)
{
PWM_Duty(130);
PORTB=0x10; //right
ms_delay();
}
if(RCREG==0x36)
{
PWM_Duty(130);
PORTB=0x04;//left
ms_delay();
}
      //after the black track
       while(f3)
    {
    PWM_Duty(60); //slow down speed
    PORTD=0x80;
    PORTB = 0x0A;
    }
    //after ending the back and forward loop
    if(f2 == 25)
    {
    TRISB=0x00;
    PORTB=0x00;
    PORTD=0x00;
    while(1) ;
}
// in the black track
   while(f1) {
     PWM_Duty(65);  //slow down speed
      PORTD=0x80;
      PORTB = 0x14;


     }
  }




}