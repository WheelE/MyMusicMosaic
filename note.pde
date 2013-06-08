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
  float strokeAngle; 
  float startAngle;
  float initalY;
  float initalX;
  int voice;
  float brushSize;
  float brushTint;
  int pathType;
  float maxTint;
  Brush brush;

  boolean firstDrawn;
  boolean lastDrawn;
  boolean hasSplatted =false;
  boolean splat = false;


  PImage brushImg;
  PImage firstImg;
  PImage lastImg;
  int offset;

  //anything and everything else we need!

  Note(int channel, int pitch, int velocity, color myColor) {
    startTime = millis();
    firstDrawn = false;
    lastDrawn = false;
    noteColor = myColor;
    duration = 1;
    posX = pathX;
    posY = pathY;
    initalY = pathY + (pitch * 2);
    initalX = pathX;
    this.pitch = pitch;
    this.velocity = velocity;
    setVoice();

    brush = brushes.get(voice);
    maxTint =255*((float)velocity/90);


    generateBrush();
    pathType = brush.pathType;
    startAngle = getAngle(prevX, pathX, prevY, pathY);////radians(random(-30,30));
    strokeAngle = startAngle;
  }


  void update() {

    previousX = posX;
    previousY = posY;
    duration = duration + 1;
    setXPosition();

    brushSize =(float)(velocity+20)/100 - (float)(duration/6)/100;
    brushTint =  (maxTint) -(duration);

    strokeAngle = getAngle(posX, previousX, posY, previousY);
    setYPosition();
  }

  void setXPosition() {
    posX = pathX;
    //  if(posX >= displayWidth){
    //     posX = 0;}
    //   else if(posX <= 0){
    //     posX = displayWidth;
    //   }
  }

  void setYPosition() {
    if (pathType == 0) {
      posY = ((previousY - posY)/(previousX - posX)) * posX;
    }
    else if (pathType == 1) {
      posY = (velocity * sin((2*PI*posX)/200));
    }
    //   if(posY >= displayHeight){
    //     posY = 0;}
    //   else if(posY <= 0){
    //     posY = displayHeight;
    //   }
  }

  void generateBrush() {
    
    brushImg = setBrushPixels(brush.brushImg);
    if (brush.hasEnds) {
      firstImg = setBrushPixels(brush.firstBrushImg);
      lastImg = setBrushPixels(brush.lastBrushImg);
    }
  }

  PImage setBrushPixels(PImage originalImage) {
    PImage img = createImage(originalImage.width, originalImage.height, ARGB);
    img.loadPixels();

    for (int y = 1; y < originalImage.height-1; y++) {
      for (int x = 1; x < originalImage.width-1; x++) {  

        int brightness = (int)brightness((int)originalImage.pixels[y*originalImage.width + x]);
        img.pixels[x + y*img.width] = color(noteColor, 255 -brightness);
      }
    }
    img.updatePixels(); 
    return img;
  }

  float getAngle(float firstx, float secondx, float firsty, float secondy) {
    return atan2(secondy-firsty, secondx-firstx);
  }



  void setVoice() {

    if (msb >= 126 && msb <= 127)
    {
      voice = (int)random(brushes.size()-5, brushes.size()-1);
    }
    else {
      voice = programChange % (brushes.size()-4);
    }
  }
}

