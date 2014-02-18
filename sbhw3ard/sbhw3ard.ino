int sensor_val = 0;
int sensor_val_map = 0;
int byteFromProcessing = 0;
int led_pin = 11;
boolean debug = false;

void setup(){
  pinMode(led_pin,OUTPUT);
  Serial.begin(9600);
  if(debug!=true){  
    establishContact(); 
  }
}

void loop(){
  
  sensor_val = analogRead(A0); //read analog pin zero
  sensor_val_map = map(sensor_val,0,1023,1,254); 
  analogWrite(led_pin,sensor_val_map);
  
  if(debug!=true){    
    if (Serial.available() > 0){
      byteFromProcessing = Serial.read();
      if(byteFromProcessing=='m'){ //more data was requested
        Serial.write(sensor_val_map);
      }
    }    
  }else{
    Serial.println(sensor_val_map);
  }
}

void establishContact(){
  while(Serial.available() <= 0) {
    Serial.print('A'); 
    delay(100);
  }
}
