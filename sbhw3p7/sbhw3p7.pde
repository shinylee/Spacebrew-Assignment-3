//reference:http://www.instructables.com/id/Prototyping-Wizardry-With-SPACEBREW/ 

import spacebrew.*;
import krister.Ess.*; //library for sound

AudioChannel myChannel;

Spacebrew spacebrewConnection;
String server="sandbox.spacebrew.cc";  
String name="cookie_p5";
String description ="sbhw3";

import processing.serial.*;
Serial myPort; 
boolean firstContact = false;

int sensor_val;


void setup() {
  
  size(500,500);
  
  //SPACEBBREW
  spacebrewConnection = new Spacebrew( this );
  spacebrewConnection.addPublish( "sensor", "cookie", sensor_val);
  spacebrewConnection.addSubscribe( "sound", "cookie");
  spacebrewConnection.connect("ws://"+server+":9000", name, description );
  
  //SERIAL WITH ARDUINO
  String portName = Serial.list()[4]; //ensure this port # matches that of arduino
  myPort = new Serial(this, portName, 9600);
  
  sensor_val = 0;
   
  Ess.start(this);
  myChannel=new AudioChannel("eating.aiff");
  myChannel.play(Ess.FOREVER); 
  }

void draw() {
  
  background(0);
  textSize(16);
  fill(255); 
  text(sensor_val, 10, 30); 
  strokeWeight(4);
  stroke(255);
  
  Ess.masterVolume(111-sensor_val*0.5);
  println(Ess.masterVolume);
  
 if(firstContact==true && sensor_val!=0){
    spacebrewConnection.send("sensor", sensor_val);
    delay(25); 
 
}}


void serialEvent(Serial myPort) {
  
  if(myPort.available()>0){
    
    int inByte = myPort.read(); //read one byte from serial
  
    if (firstContact == false) { 
      if (inByte == 'A') { 
        myPort.clear();          
        firstContact = true;     
        myPort.write('A');  
      } 
    }else{
      sensor_val = inByte;
      myPort.write('m'); //request more data
    }
  }
}


public void stop() {
  Ess.stop();
  super.stop();
}

