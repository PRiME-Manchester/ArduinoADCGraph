/*
  Digital Pot Control

  This example controls an Analog Devices AD5206 digital potentiometer.
  The AD5206 has 6 potentiometer channels. Each channel's pins are labeled
  A - connect this to voltage
  W - this is the pot's wiper, which changes when you set it
  B - connect this to ground.

 The AD5206 is SPI-compatible,and to command it, you send two bytes,
 one with the channel number (0 - 5) and one with the resistance value for the
 channel (0 - 255).

 The circuit:
  * All A pins  of AD5206 connected to +5V
  * All B pins of AD5206 connected to ground
  * An LED and a 220-ohm resisor in series connected from each W pin to ground
  * CS - to digital pin 10  (SS pin)
  * SDI - to digital pin 11 (MOSI pin)
  * CLK - to digital pin 13 (SCK pin)

 created 10 Aug 2010
 by Tom Igoe

 Thanks to Heather Dewey-Hagborg for the original tutorial, 2005

*/


// inslude the SPI library:
#include <SPI.h>

const int CONVST = 2;
const int EOC = 3;
const int CS  = 4;

void setup() {
  // set the slaveSelectPin as an output:
  pinMode(CONVST, OUTPUT);
  pinMode(EOC, INPUT);
  pinMode(CS,  OUTPUT);
  
  // initialize SPI and serial:
  Serial.begin(115200);
  SPI.begin();

  digitalWrite(CS, LOW);
  digitalWrite(CONVST, LOW); //This is configured as an analog input AIN15 (so tie low)
  
  // configure Maxim ADC
  SPI.transfer(0x68); //setup register: Internally timed acquisitions, Int Vref always on
  //SPI.transfer(0x20); //no averaging
  SPI.transfer(0x30); //no averaging x4
  //SPI.transfer(0x34); //no averaging x8
  //SPI.transfer(0x38); //averaging x16
  //SPI.transfer(0x3c); //averaging x32
  
}

void loop()
{
  byte byte1, byte2;
  unsigned int dac;
  unsigned long clocktime;
  
  digitalWrite(CS, LOW);
  SPI.transfer(0xe8); //conversion register: scan channels 0-13
  digitalWrite(CS,  HIGH);

  // wait for EOC to go low
  while(digitalRead(EOC) == HIGH);

  // read bytes
  digitalWrite(CS, LOW);
  
  clocktime = millis();
  for(int i=0; i<14; i++)
  {
    byte1 = SPI.transfer(0x00); 
    byte2 = SPI.transfer(0x00); 
    dac = byte1<<8 | byte2;
    
    if (i<13)
    {
      Serial.print(dac);
      Serial.print(",");
    }
    else
    {
      Serial.print(dac);
      Serial.print(",");
      Serial.println(clocktime);
      
//      Serial.println(voltage);
    }
  }
  digitalWrite(CS, HIGH);

  delay(9); //this results in an acquisition rate of 10ms, i.e. 100Hz
//  delay(100);
}


