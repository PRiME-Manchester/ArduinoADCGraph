// This program takes ASCII-encoded strings
// from the serial port at 9600 baud and graphs them. It expects values in the
// range 0 to 1023, followed by a newline, or newline and carriage return
 
// Created 20 Apr 2005
// Updated 18 Jan 2008
// by Tom Igoe
// This example code is in the public domain.
 
import processing.serial.*;

Serial myPort;        // The serial port
int xPos = 1;         // horizontal position of the graph
int lastX = 0, k=0;
float lastY = 0, y;
int win_width=400, win_height=800;
String inString="";
float [] dac_old  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
float [] dac_disp = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
float [] meas     = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
int j=0;
int x1=320, y1=50, step=57;
String[] labels = {"12V (V)", "12V (I)", "3.3V (V)", "3.3V (I)", "SDRAM (V)", "SDRAM (I)", "FPGA (V)", "FPGA (I)",
                   "Bank C (V)", "Bank C (I)", "Bank B (V)", "Bank B (I)", "Bank A (V)", "Bank A (I)"};
String[] units = {" V", " A", " V", " A", " V", " A", " V", " A",
                  " V", " A", " V", " A", " V", " A"};
//create file
//PrintWriter output = createWriter("/Users/patrick/Development/sketchbook/arduino_adcgraph/graph_adc_14channel/data.log");
PrintWriter output = createWriter("/home/camillep/Development/sketchbook/arduino_adcgraph/graph_adc_14channel/data.log");

void setup ()
{
  int i;
    
  // set the window size:
  size(win_width, win_height);        
  frameRate(5);
  
  // set inital background:
  noSmooth();
  background(255,255,255);

  // initialize dac_old
  for (i=0; i<14; i++)
    dac_old[i] =  map(i*5000, 0, 69999, 0, height);

  for(i=0; i<14; i++)
  {
    y = map(i*5000, 0, 69999, 0, height);
    stroke(0);
    strokeWeight(2);
    line(0, height-y-1, win_width, height-y-1);
    
    y = map(i*5000 + 4095, 0, 69999, 0, height);
    stroke(255,0,0);
    strokeWeight(1);
    line(0, height-y-1, win_width, height-y-1);          
  } 

  // List all the available serial ports
  println(Serial.list());
  // I know that the first port in the serial list on my mac
  // is always my  Arduino, so I open Serial.list()[0].
  // Open whatever port is the one you're using.
  myPort = new Serial(this, Serial.list()[0], 115200); // for Work PC
  //myPort = new Serial(this, Serial.list()[2], 115200); // for MAC
  // don't generate a serialEvent() unless you get a newline character:
  myPort.bufferUntil('\n');

}
 
void draw ()
{
  //background(255);
  //text(inString, 50, 50);
  // everything happens in the serialEvent()
}
 
void serialEvent (Serial myPort)
{
  // get the ASCII string:
  inString = myPort.readStringUntil('\n');

  int i;
  
  if (inString != null)
  {
    // trim off any whitespace:
    inString = trim(inString);
    float[] dac = float(split(inString, ","));
    
    // draw the line:
    stroke(127,34,255);
    strokeWeight(1);
    //line(lastX, height - lastY, xPos, height - yPos);
    
    if (dac.length==15) //last value contains the time stamp
    {
      // save string to file
      output.println(inString);
      
      for(i=0; i<dac.length-1; i++)
      {
        // convert to an int and map to the screen height:
        if (i<11)
        {
          /*if (i==8) //SDRAM
            dac_disp[i] = map(dac[i]*10+i*5000, 0, 69999, 0, height);
          else*/
            dac_disp[i] = map(dac[i]+i*5000, 0, 69999, 0, height);
        }
        else if (i==11)
          dac_disp[i] = map(dac[13]+i*5000, 0, 69999, 0, height);
        else if (i==12)
          dac_disp[i] = map(dac[11]+i*5000, 0, 69999, 0, height);
        else if (i==13)
          dac_disp[i] = map(dac[12]+i*5000, 0, 69999, 0, height);
        
        //point(xPos, height - dac[i] - 2);
        line(xPos, height - dac_old[i] - 2, xPos+1, height - dac_disp[i] - 2);

        // Copy dac values to dac_old
        dac_old[i] = dac_disp[i];
      }
    
      // Bank A
      meas[0] = dac[0]*2.5/(4096*0.005*50); //I
      meas[1] = dac[1]*2.5/4096; //V
      
      // Bank B
      meas[2] = dac[2]*2.5/(4096*0.005*50); //I
      meas[3] = dac[3]*2.5/4096; //V
      
      // Bank C
      meas[4] = dac[4]*2.5/(4096*0.005*50); //I
      meas[5] = dac[5]*2.5/4096; //V
      
      //FPGA
      meas[6] = dac[6]*2.5/(4096*0.010*50); //I
      meas[7] = dac[7]*2.5/4096; //V
      
      //SDRAM
      meas[8] = dac[8]*2.5/(4096*0.005*50); //I
      meas[9] = dac[9]*2.5/4096; //V
      
      // 3.3V
      meas[10] = dac[10]*2.5/(4096*0.010*50); //I
      meas[11] = dac[13]*2.5/4096*3/2; //V
            
      // 12V
      meas[12] = dac[11]*2.5/(4096*0.005*50); //I
      meas[13] = dac[12]*2.5/4096*6; //V
      
    
      //stroke(255);
      //fill(255);
      //rect(10,10,30,15);
      //stroke(100);
      
      fill(255);
      stroke(255);
      for(i=0; i<14; i++)
        rect(10, y1+step*i-10, 50,13);
      
      fill(0);
      for (i=0; i<14; i++)
      {
        text(labels[i], x1, y1+step*i);        
        text(nf(meas[13-i],1,1)+units[i], 10, y1+step*i); 
      }

    }
  
    k++;
     
    lastX = xPos;
    //lastY = yPos;
     
    // at the edge of the screen, go back to the beginning:
    if (xPos >= width)
    {
      xPos = 0;
      lastX = xPos;
      background(255);
              
      for(i=0; i<14; i++)
      {
        y = map(i*5000, 0, 69999, 0, height);
        stroke(0);
        strokeWeight(2);
        line(0, height-y-1, win_width, height-y-1);
        
        y = map(i*5000 + 4095, 0, 69999, 0, height);
        stroke(255,0,0);
        strokeWeight(1);
        line(0, height-y-1, win_width, height-y-1);          
      } 
    } 
    else if (k%14==0)
    {
      // increment the horizontal position:
      xPos++;
    }
  }
}

// This will get called when the sketch quits
void stop() {
  output.flush();  // Flush all the data to the file
  output.close();  // Close the file
}

