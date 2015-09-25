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

String inString="";
float [] dac_disp  = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};
float [] meas      = {0,0,0,0,0,0,0};
float [] meas_disp = {0,0,0,0,0,0,0};
float [] meas_old  = {0,0,0,0,0,0,0};
float [] ranges    = {16,16,16,1,10,10,100}; //BankA, B, C, FPGA, SDRAM, 3.3V, 12V
float [] plot_en   = {1,1,1,0,1,0,1};
float meas_i;
float meas_v;
String[] labels = {"12V (W)", "3.3V (W)", "SDRAM (W)", "FPGA (W)", "Bank C (W)", "Bank B (W)", "Bank A (W)"};
String[] units = {" W", " W", " W", " W", " W", " W", " W"};

//create file
//PrintWriter output = createWriter("/Users/patrick/Development/sketchbook/arduino_adcgraph/graph_adc_14channel/data.log");
PrintWriter output = createWriter("/home/camillep/Development/sketchbook/arduino_adcgraph/arduino_graph_power_pde/data.log");

// Constants
int NumPlots = 0;
int TotPlotHeight;

static final int win_width=400, win_height=800;
static final int PlotHeight = 10000;
static final int ADC_Bits = 4096;
static final int NumMeas = 7;
int x1=320, y1=50, step;

void setup ()
{
  int i;
    
  // set the window size:
  size(win_width, win_height);        
  frameRate(5);
  
  // set inital background:
  noSmooth();
  background(255,255,255);

 
  // count NumPlots
  for(i=0; i<NumMeas; i++)
  {
    if (plot_en[i]==1)
      NumPlots++;
  }
  TotPlotHeight = PlotHeight*NumPlots;
  step = win_height/NumPlots;

  // initialize dac_old, step for label text
  int j=0;
  for(i=NumMeas-1; i>=0; i--)
  {
    if (plot_en[i]==1)
    {
      meas_old[i] =  map(j*PlotHeight, 0, TotPlotHeight, 0, height);
      j++;
    }
  }
  
  for(i=0; i<NumPlots; i++)
  {
    y = map(i*PlotHeight, 0, TotPlotHeight, 0, height);
    stroke(0);
    strokeWeight(2);
    line(0, height-y-1, win_width, height-y-1);
    
    y = map(i*PlotHeight + ADC_Bits*2, 0, TotPlotHeight, 0, height);
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

      // Bank A
      meas_i = dac[0]*2.5/(ADC_Bits*0.005*50); //I
      meas_v = dac[1]*2.5/ADC_Bits; //V
      meas[0] = meas_i * meas_v;
      
      // Bank B
      meas_i = dac[2]*2.5/(ADC_Bits*0.005*50); //I
      meas_v = dac[3]*2.5/ADC_Bits; //V
      meas[1] = meas_i * meas_v; 
      
      // Bank C
      meas_i = dac[4]*2.5/(ADC_Bits*0.005*50); //I
      meas_v = dac[5]*2.5/ADC_Bits; //V
      meas[2] = meas_i * meas_v;
      
      //FPGA
      meas_i = dac[6]*2.5/(ADC_Bits*0.010*50); //I
      meas_v = dac[7]*2.5/ADC_Bits; //V
      meas[3] = meas_i * meas_v;
      
      //SDRAM
      meas_i = dac[8]*2.5/(ADC_Bits*0.005*50); //I
      meas_v = dac[9]*2.5/ADC_Bits; //V
      meas[4] = meas_i * meas_v;
      
      // 3.3V
      meas_i = dac[10]*2.5/(ADC_Bits*0.010*50); //I
      meas_v = dac[13]*2.5/ADC_Bits*3/2; //V
      meas[5] = meas_i * meas_v;
      
      // 12V
      meas_i = dac[11]*2.5/(ADC_Bits*0.005*50); //I
      meas_v = dac[12]*2.5/ADC_Bits*6; //V
      meas[6] = meas_i * meas_v;
      
      int j=0;
      for(i=NumMeas-1; i>=0; i--)
      {
        if (plot_en[i]==1)
        {
          //point(xPos, height - dac[i] - 2);
          meas_disp[i] = map(meas[i]/ranges[i]*ADC_Bits*2+j*PlotHeight, 0, TotPlotHeight, 0, height);
          //println(i, labels[NumPlots-i-1], meas[i], meas_disp[i]);
          line(xPos, height - meas_old[i] - 2, xPos+1, height - meas_disp[i] - 2);
          
          meas_old[i] = meas_disp[i];
          j++; 
        }
      }
    
      //stroke(255);
      //fill(255);
      //rect(10,10,30,15);
      //stroke(100);
      
      fill(255);
      stroke(255);
      for(i=0; i<NumPlots; i++)
        rect(10, y1+step*i-10, 50,13);
      
      fill(0);
      j=0;
      for (i=NumMeas-1; i>=0; i--)
      {
        if (plot_en[NumMeas-i-1]==1)
        {
          text(labels[i], x1, y1+step*j);        
          text(nf(meas[NumMeas-1-i],1,1)+units[i], 10, y1+step*j);
          j++; 
        }  
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
              
      for(i=0; i<NumPlots; i++)
      {
        y = map(i*PlotHeight, 0, TotPlotHeight, 0, height);
        stroke(0);
        strokeWeight(2);
        line(0, height-y-1, win_width, height-y-1);
        
        y = map(i*PlotHeight + ADC_Bits*2, 0, TotPlotHeight, 0, height);
        stroke(255,0,0);
        strokeWeight(1);
        line(0, height-y-1, win_width, height-y-1);          
      } 
    } 
    else if (k%NumPlots==0)
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

