#line 1 "C:/Users/20190086/Desktop/FinalPro/Finalproject.c"
unsigned char f1, f2, f3;

 void initial()
 {
 TRISD = 0x00;
 PORTD=0x00;
 TRISB = 0x01;
 PORTB=0x00;
 RCREG=0x00;
 f1 = 0x00;
 f2=0x00;
 f3 = 0x00;
 OPTION_REG = OPTION_REG | 0x40;
 INTCON = INTCON | 0x90;
 }
 void PWM_Init()
{
#line 21 "C:/Users/20190086/Desktop/FinalPro/Finalproject.c"
 CCP1CON = 0X0C;
 T2CON = 0x06;
 PR2 = 250 ;

 TRISC = TRISC & 0xFB;

}
void PWM_Duty(unsigned char duty)
{
 if(duty<=250)
 {


 CCPR1L = duty;
 }
}

 void bck();

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

TXSTA =0x24;
RCSTA=0x90;
SPBRG = 51;
}
#line 60 "C:/Users/20190086/Desktop/FinalPro/Finalproject.c"
 void interrupt(){


 f1 = ~f1;
 f2++;

 if(f2 & 0x02){
 f3 = ~f3;
 OPTION_REG = OPTION_REG ^ 0x40;
 }



 OPTION_REG = OPTION_REG ^ 0x40;
 INTCON = INTCON & 0xFD;
 }

void main(){
USART_in();
 PWM_Init();
 initial();
 while(1){
 PORTC=0x00;
 PWM_Duty(130);
 PORTB=0x14;

 if(RCREG==0x31)
{
PWM_Duty(130);
PORTB=0x14;
ms_delay();
}
if(RCREG==0x32)
{
PWM_Duty(130);
PORTB=0x0A;
ms_delay();
}
if(RCREG==0x33)
{
PWM_Duty(130);
PORTB=0x00;
ms_delay();
}
if(RCREG==0x34)
{

PORTD=0x80;
ms_delay();
}

 if(RCREG==0x35)
{
PWM_Duty(130);
PORTB=0x10;
ms_delay();
}
if(RCREG==0x36)
{
PWM_Duty(130);
PORTB=0x04;
ms_delay();
}

 while(f3)
 {
 PWM_Duty(60);
 PORTD=0x80;
 PORTB = 0x0A;
 }

 if(f2 == 25)
 {
 TRISB=0x00;
 PORTB=0x00;
 PORTD=0x00;
 while(1) ;
}

 while(f1) {
 PWM_Duty(65);
 PORTD=0x80;
 PORTB = 0x14;


 }
 }




}
