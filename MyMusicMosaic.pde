//TODO
//-Catch error if there is no input
//-Channels + voices!
//-Sometimes keyboard refuses to send data...don't know why
//-Note path
//-note direction doesn't work...?

import themidibus.*;

MidiBus myMidiBus;
ArrayList<Note> activeNotes = new ArrayList<Note>();
float pathY = 0;
float pathX = 0;
int imgLength;
int imgHeight;
float prevX;
float prevY;

int speed = 1;

PImage img;



void setup(){
  size(128*10,128*5);
  smooth();
  background(255);
  fill(255,20*2,20*2,20*2);
  stroke(255,20);
  
  img = loadImage("rollerBrush.png");
  img = loadImage("palletKnifeBrush.png");
  img = loadImage("brush.jpg");
  
  //get an instance of MidiBus
  println("printPorts of MidiBus");
  
  //print a list of all available devices
  MidiBus.list();
  
  //open the first midi channel of the first device
  myMidiBus = new MidiBus(this, 0, 1);
  
    //image(img, 0, 0);
    img.loadPixels();
    imgLength = img.width;
    imgHeight = img.height;
    
 
  
  
}

void draw(){
    updatePathPosition();
    drawActiveNotes(); 
    

}

void updatePathPosition(){
  prevX = pathX;
  prevY = pathY;
  pathX =  (millis()/(speed * 10))%(128*10);
  pathY = (200 * sin((2*PI*pathX)/200)+300);
}


synchronized void drawActiveNotes(){
  for(Note note : activeNotes){
    
    
    note.update();
    pushMatrix();
    rotate(note.startAngle);
    brushStroke(note);
    popMatrix();
  }
  
}

void brushStroke(Note note){
  pushMatrix();
   translate(note.posX, note.posY);
   rotate(note.strokeAngle); 
   translate(-note.brush.width/2, -note.brush.height/2);
   //------------------------------------------------------
   //Draw your brush here!
   //------------------------------------------------------
   
  
  tint(note.noteColor);
  image(note.brush, note.posX, note.posY);
  popMatrix();
   
}

color determineColor(int pitch, int velocity){
  //This will be filled in better later
  return color(random(255),random(255),random(255));
}

void noteOn(int channel, int pitch, int velocity){
  //Note: this function gets called anytime (aparently)ANYTHING happens, so treat it with caution.
  //*This includes releasing a key as well
  
  addActiveNote(channel, pitch,velocity);
}

void noteOff(int channel, int pitch, int velocity){
  removeActiveNote(channel, pitch, velocity);
}


//int findActiveNotes(Note note){
// //Find number of notes with same pitch
// //--not specific to instrument...yet
// int numberActive = 0;
//  for(Note currentNote : activeNotes){
//    if (currentNote.pitch == note.getPitch()){
//      numberActive++;
//    }
//  }
//  return numberActive;
//}

synchronized void addActiveNote(int channel, int pitch, int velocity){

    activeNotes.add(new Note(channel, pitch, velocity, determineColor(pitch, velocity)));
  
}

synchronized Note removeActiveNote(int channel, int pitch, int velocity){
 //Search the activeNotes array for a note with a matching pitch
 //If one is found, remove it
  for(int currentNote = 0; currentNote < activeNotes.size(); currentNote++){
    if (activeNotes.get(currentNote).pitch == pitch){
      return activeNotes.remove(currentNote);
      }
  }
  return null;
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}
//
//void programChange(ProgramChange programChange, int device, int channel){
//  int num = programChange.getNumber();
//  
//  fill(255,num*2,num*2,num*2);
//  stroke(255,num);
//  ellipse(num*5,num*5,30,30);
//  println("Program change: " + num);
//  
//}

//---------CLASSES-------------
//
//-----------------------------
class Note {
 int duration; 
 int startTime;
 int pitch;
 int velocity;
 color noteColor;
 float posX;
 float posY;
 float previousX;
 float previousY;
 color brushTexture[][];
 float strokeAngle; 
 float startAngle;
 PImage brush;
 
 
 
 int offset;

 //anything and everything else we need!
 
 Note(int channel, int pitch, int velocity, color myColor){
   startTime = millis();
   noteColor = myColor;
   duration = 0;
   posX = pathX;
   posY = pathY;
   this.pitch = pitch;
   this.velocity = velocity;
   generateBrush();
   
   startAngle = radians(random(-30,30));
   strokeAngle = startAngle;
 }
 
 void update(){
  
   previousX = posX;
   previousY = posY;
   duration = millis() - startTime;
   posX = pathX;
   strokeAngle = getAngle(posX, previousX, posY, previousY); 
   
 }
 
 void generateBrush(){
   //-------------------------------------------------
   //Load your image here!
   //-------------------------------------------------
   
//   brushTexture = new color[img.width][img.height];
//   brush = createImage(img.width, img.height, ARGB);
//   brush.loadPixels();
////    int red = myColor >> 16 & 0xFF;
////      int green = myColor >> 8 & 0xFF;
////      int blue = myColor & 0xFF;
//    
//    for (int y = 1; y < img.height-1; y++) {   // Skip top and bottom edges
//    for (int x = 1; x < img.width-1; x++) {  
//      
//      int brightness = (int)brightness((int)img.pixels[y*img.width + x]);
//      brush.pixels[x + y*brush.width] = color(noteColor, 255 -brightness);
//    }
//  }
    brush = loadImage("rollerBrush.png");

  }
  
  float getAngle(float firstx, float secondx, float firsty, float secondy){
     return atan2(secondy-firsty,secondx-firstx);
  }
  
}

