#define LCD_CS A3 // Chip Select goes to Analog 3
#define LCD_CD A2 // Command/Data goes to Analog 2
#define LCD_WR A1 // LCD Write goes to Analog 1
#define LCD_RD A0 // LCD Read goes to Analog 0
#define LCD_RESET A4 // Can alternately just connect to Arduino's reset pin

#include<SPI.h>
#include "Adafruit_GFX.h"
#include "MCUFRIEND_kbv.h"

#define BLACK 0x0000
#define NAVY 0x000F
#define DARKGREEN 0x03E0
#define DARKCYAN 0x03EF
#define MAROON 0x7800
#define PURPLE 0x780F
#define OLIVE 0x7BE0
#define LIGHTGREY 0xC618
#define DARKGREY 0x7BEF
#define BLUE 0x001F
#define GREEN 0x07E0
#define CYAN 0x07FF
#define RED 0xF800
#define MAGENTA 0xF81F
#define YELLOW 0xFFE0
#define WHITE 0xFFFF
#define ORANGE 0xFD20
#define GREENYELLOW 0xAFE5

#define N 16
#define N_double 2*N
#define N_half (int)N/2
#define bar_width (int)480/N
#define raw_bar_width (int)bar_width/2

//#define DEBUG

MCUFRIEND_kbv tft;

int8_t count = 0;
int8_t nr = 0;
int8_t data[N_double];
int8_t data_old[N_double];
int8_t real[N];
int8_t imag[N];
int16_t real_shift[N];
int16_t imag_shift[N];
int16_t betrag[N];
int16_t betrag_old[N];
int16_t shift[N];

void setup() {
  // put your setup code here, to run once:
  uint16_t ID = tft.readID();
  tft.begin(ID); 
  tft.fillScreen(BLACK);
  SPI_SlaveInit();
  delay(100);
  tft.fillRect(0, 0         , 120, bar_width, WHITE);
  tft.fillRect( 0,1*bar_width,  187, bar_width, GREEN);
  tft.fillRect( 0,2*bar_width,  50, bar_width, RED);
  delay(100);
  tft.fillScreen(BLACK);

}

void loop() {
  // collect the data over SPI.
  while(count < N_double){
    data_old[count] = data[count];
    data[count] = SPI_SlaveReceive();
    count++;
  }
  #ifndef DEBUG
 for(int i=0; i<N;i++){
      
      real[i] = data[2*i];
      imag[i] = data[2*i+1];
    }
  for(int i = 0; i<N;i++){
    betrag_old[i] = betrag[i];
    betrag[i] = 2*sqrt(real[i]*real[i] + imag[i] * imag[i]);
    //betrag[i] = abs(real[i] ) + abs(imag[i]);
    shift[i] = betrag[i];
    }
   for(int i=0; i <N_half;i++){
      byte n = flipByte(i) >> 5;
      betrag[i] = shift[n];
      betrag[i+N_half] = shift[n+N_half];
      }

  for(int i = 0; i<N; i++){
      tft.drawLine(betrag_old[i], bar_width*i, betrag_old[i], bar_width*(i+1), BLACK);
      tft.drawLine(betrag[i], bar_width*i, betrag[i], bar_width*(i+1), WHITE);
    }
    
  #endif
  #ifdef DEBUG
  for(int i = 0; i<N_double; i++){
      tft.drawLine(100+data_old[i], raw_bar_width*i, 100+data_old[i], raw_bar_width*(i+1), BLACK);
      tft.drawLine(100+data[i], raw_bar_width*i, 100+data[i], raw_bar_width*(i+1), WHITE);
      tft.drawLine(100, 0, 100, 480, RED);//Null linie
    }
  #endif
  count = 0;
}

char SPI_SlaveReceive(void)
{
  // Wait for reception complete
  // SPI Status Reg & 1<<SPI Interrupt Flag
  while(!(SPSR & (1<<SPIF)));

  // Return data register
  return SPDR;
}

byte flipByte(byte c)
     {
       c = ((c>>1)&0x55)|((c<<1)&0xAA);
       c = ((c>>2)&0x33)|((c<<2)&0xCC);
       c = (c>>4) | (c<<4) ;

       return c;
     }

void SPI_SlaveInit(void)
{
  // Set MISO output, all others input
  DDRB |= (1<<PB3);
  // Enable SPI
  SPCR |= (1<<SPE)|(1<<SPR0);
}
