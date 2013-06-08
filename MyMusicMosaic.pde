//TODO
//-Catch error if there is no input
//-Set instruments to brushes
//something weird happening with last stroke
//Prettify ui
//installer

import themidibus.*;

State state;

MidiBus myMidiBus;
ArrayList<Note> activeNotes = new ArrayList<Note>();
ArrayList<Brush> brushes = new ArrayList<Brush>();
ArrayList<Brush> splats = new ArrayList<Brush>();
float pathY = 0;
float pathX = 0;
int imgLength;
int imgHeight;
float prevX;
float prevY;
int programChange = 0;
int msb = 0;
int lsb = 0;
color backgroundColor = color(0, 0, 0);

color [][] storedPixels;

boolean notePressed = false;
int saved =0; //0 is not saving, 1 is saved, -1 is failed

String filePath = "/untitled";

int xOffset = 0;
Gui gui;
StartMessage startMessage;
PauseScreen pauseScreen;
HelpScreen helpScreen;
color[] scheme = new color[13];

int schemeNumber = 0;
color[][] pallets = {
  {  
    color(146, 38, 217), 
    color(26, 122, 230), 
    color(11, 213, 207), 
    color(23, 181, 31), 
    color(28, 223, 86), 
    color(252, 153, 18), 
    color(209, 14, 53)
  }
  , 
  {  
    color(20, 124, 239), 
    color(129, 164, 18), 
    color(239, 207, 134), 
    color(0, 0, 168), 
    color(28, 141, 98), 
    color(125, 207, 229), 
    color(88, 0, 183)
  }
  , 
  {  
    color(10, 11, 91), 
    color(63, 60, 105), 
    color(63, 71, 204), 
    color(7, 71, 107), 
    color(0, 0, 168), 
    color(67, 67, 67), 
    color(38, 87, 128)
  }
  , 
  {  
    color(200, 0, 0), 
    color(255, 201, 13), 
    color(255, 13, 12), 
    color(0, 200, 0), 
    color(0, 60, 0), 
    color(1, 0, 200), 
    color(1, 111, 0)
  }
  , 
  {  
    color(124, 63, 97), 
    color(43, 125, 149), 
    color(96, 186, 239), 
    color(199, 191, 230), 
    color(255, 62, 67), 
    color(249, 251, 152), 
    color(242, 105, 115)
  }
  , 
  {  
    color(123, 4, 8), 
    color(82, 82, 82), 
    color(223, 0, 1), 
    color(192, 192, 192), 
    color(98, 50, 4), 
    color(234, 111, 34), 
    color(69, 35, 0)
  }
  , 
  {  
    color(92, 32, 206), 
    color(248, 23, 119), 
    color(29, 176, 158), 
    color(239, 237, 58), 
    color(255, 79, 167), 
    color(8, 102, 138), 
    color(77, 13, 162)
  }
  , 
  {  
    color(255, 104, 5), 
    color(2, 72, 202), 
    color(87, 217, 4), 
    color(90, 135, 254), 
    color(248, 139, 74), 
    color(99, 249, 27), 
    color(22, 65, 116)
  }
  , 
  {  
    color(255, 127, 38), 
    color(249, 54, 34), 
    color(165, 221, 114), 
    color(241, 151, 153), 
    color(101, 255, 97), 
    color(89, 133, 58), 
    color(173, 85, 0)
  }
  , 
  {  
    color(204, 238, 99), 
    color(160, 254, 201), 
    color(255, 222, 107), 
    color(151, 232, 93), 
    color(207, 147, 207), 
    color(248, 153, 157), 
    color(254, 249, 121)
  }
  , 
  {  
    color(100, 100, 100), 
    color(32, 179, 36), 
    color(251, 205, 8), 
    color(237, 27, 36), 
    color(54, 58, 227), 
    color(231, 116, 0), 
    color(160, 160, 160)
  }
  , 
  {
    color(random(255), random(255), random(255)), 
    color(random(255), random(255), random(255)), 
    color(random(255), random(255), random(255)), 
    color(random(255), random(255), random(255)), 
    color(random(255), random(255), random(255)), 
    color(random(255), random(255), random(255)), 
    color(random(255), random(255), random(255))
  }
};


PImage img;



void setup() {
  size(displayWidth, displayHeight);
  smooth();
  fill(255);
  background(backgroundColor);
  gui = new Gui(pallets);
  pauseScreen = new PauseScreen();
  helpScreen = new HelpScreen();
  state = State.STARTSCREEN;
  storedPixels = new color[displayWidth][displayHeight];

  //get an instance of MidiBus
  println("printPorts of MidiBus");

  //print a list of all available devices
  MidiBus.list();

  //open the first midi channel of the first device
  myMidiBus = new MidiBus(this, 0, 1);
  //First.file, Middle.file, Last.file, Stroketype, PathType

  //brushes.add(new Brush("brushfirst.jpg","brush.jpg","brushlast.jpg", 1,1));
  brushes.add(new Brush(new String[] {
    "chalkBrush.jpg"
  }
  , 2, 1));
  brushes.add(new Brush(new String[] {
    "dryWatercolorBrushMiddle.jpg", "dryWatercolorBrushTip.jpg", "dryWatercolorBrushEnd.jpg"
  }
  , 1, 0));
  //brushes.add(new Brush(new String[]{"fingerPaintMiddle.jpg","fingerPaintTip.jpg","fingerPaintEnd.jpg"},1,0));

  brushes.add(new Brush(new String[] {
    "watercolorBrushMiddle.jpg", "watercolorBrushTip.jpg", "watercolorBrushEnd.jpg"
  }
  , 1, 1));
  brushes.add(new Brush(new String[] {
    "palletKnifeMiddle.jpg", "palletKnifeTip.jpg", "palletKnifeEnd.jpg"
  }
  , 1, 0));
  brushes.add(new Brush(new String[] {
    "rollerBrush.jpg"
  }
  , 1, 0));
  brushes.add(new Brush(new String[] {
    "marker.jpg"
  }
  , 0, 1));
  brushes.add(new Brush(new String[] {
    "jaylynSplat.jpg"
  }
  , 5, 0));
  brushes.add(new Brush(new String[] {
    "jaylynSplat2.jpg"
  }
  , 5, 0));
  brushes.add(new Brush(new String[] {
    "jaylynSplat3.jpg"
  }
  , 5, 0));
  brushes.add(new Brush(new String[] {
    "jaylynSplat4.jpg"
  }
  , 5, 0));
  brushes.add(new Brush(new String[] {
    "jaylynSplat5.jpg"
  }
  , 5, 0));
  //   brushes.add(new Brush("palletKnifeBrush.jpg", 1,0));

  //   brushes.add(new Brush("chalkBrush.jpg", 1, 1));
  setScheme();

  //thread("noteOff");
}

void setScheme() {

  scheme[0] = pallets[schemeNumber][0];
  scheme[2] = pallets[schemeNumber][1];
  scheme[4] = pallets[schemeNumber][2];
  scheme[5] = pallets[schemeNumber][3];
  scheme[7] = pallets[schemeNumber][4];
  scheme[9] = pallets[schemeNumber][5];
  scheme[11] = pallets[schemeNumber][6];


  scheme[1] = getBlend(0, 2);
  scheme[3] = getBlend(2, 4);
  scheme[6] = getBlend(5, 7);
  scheme[8] = getBlend(7, 9);
  scheme[10] = getBlend(9, 11);
}

color getBlend(int first, int second) {
  return color((red(scheme[first]) + red(scheme[second]))/2, 
  (green(scheme[first]) + green(scheme[second]))/2, 
  (blue(scheme[first]) + blue(scheme[second]))/2);
}

synchronized void rawMidi(byte[] data) {
  //listen for program changes
  if ((int)(data[0] & 0xFF) == 176) {
    if ((int)data[1] == 0) {
      msb = data[2];
    }
    if ((int)data[1] == 32) {
      lsb = data[2];
    }
  }
  if ((int)(data[0] & 0xFF) == 192) {
    programChange = data[1]+1;
    println((int)msb + " " + (int)lsb+ " " + programChange);
  }
}
boolean sketchFullScreen() {
  return true;
}

void draw() {

  switch(state) {
  case STARTSCREEN:
    gui.drawGui();
    //put these things in the intermediate menu!
    schemeNumber = gui.selectedPallet;
    setScheme(); 
    backgroundColor = gui.backgroundColor;
    if (!gui.drawStartup) {
      background(backgroundColor);
      background(backgroundColor);
      state = State.STARTMESSAGE;
      startMessage =  new StartMessage(backgroundColor);
      notePressed = false;
    }
    break;
  case STARTMESSAGE:
    startMessage.drawMessage();
    if (notePressed) {
      state = State.PLAYING;
      background(backgroundColor);
      background(backgroundColor);
    }
    break;
  case PLAYING:

    updatePathPosition();
    drawActiveNotes(); 
    if (keyPressed || mousePressed) {
      state = State.PAUSESCREEN;
      storeDisplayPixels();
      wait(100);
      darkenScreen();
    }
    break;
  case PAUSESCREEN:
    pauseScreen.drawScreen();
    if (pauseScreen.buttonPressed) {
      if (pauseScreen.buttonNumber == 1) {
        state = State.PLAYING;
        setDisplayPixels();
      }
      if (pauseScreen.buttonNumber == 2) {
        state = State.STARTSCREEN;
        gui.drawStartup = true;
      }
      if (pauseScreen.buttonNumber == 3) {
        selectOutput("Select a file to write to:", "fileSelected");
        while (saved == 0) {
          //wait for them to finish
        }
        if (saved == 1) {
          setDisplayPixels();
          save(filePath +".png");
          println("Saved sucessfully to " + filePath);
          darkenScreen();
        }
        if (saved == -1) {
          pauseScreen.buttonPressed = false;
        }
        saved = 0;
      }
      if (pauseScreen.buttonNumber == 4) {
        state = State.HELP;
      }
      if (pauseScreen.buttonNumber == 5) {
        exit();
      }
      pauseScreen.buttonPressed = false;
    }
    break;
  case HELP:
    helpScreen.drawScreen();
    if (helpScreen.buttonPressed) {
      state = State.PLAYING;
      setDisplayPixels();
      helpScreen.buttonPressed = false;
    }
    break;
  }
  removeStaleNotes();
}

void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    saved = -1;
  } 
  else {
    filePath = selection.getAbsolutePath();
    saved = 1;
  }
}



void darkenScreen() {

  fill(50, 100);
  rect(0, 0, displayWidth, displayHeight);
}

void updatePathPosition() {
  if (pathX >= displayWidth - 10) {
    xOffset += 50;
  }
  prevX = pathX;
  prevY = pathY;
  pathX =  (millis()/(10))%(displayWidth);
  pathY = ((displayHeight/2 - 50) * sin((2*PI*pathX + xOffset)/200)+displayHeight/2 - 150);
}

void mousePressed() {
  gui.pressedX = mouseX;
  if (state == State.STARTMESSAGE) {
    state = State.PAUSESCREEN; 
    storeBlank();
    wait(100);
    darkenScreen();
  }
}



void storeDisplayPixels() {
  for (int x = 0; x < displayWidth; x++) {
    for (int y =0; y < displayHeight; y++) {
      storedPixels[x][y] = get(x, y);
    }
  }
}

void storeBlank() {
  for (int x = 0; x < displayWidth; x++) {
    for (int y =0; y < displayHeight; y++) {
      storedPixels[x][y] = backgroundColor;
    }
  }
}

void setDisplayPixels() {
  for (int x = 0; x < displayWidth; x++) {
    for (int y =0; y < displayHeight; y++) {
      set(x, y, storedPixels[x][y]);
    }
  }
}

synchronized void drawActiveNotes() {
  for (Note note : activeNotes) {

    note.update();
    setDrawDirection(note);
    if (!note.firstDrawn && note.brush.hasEnds) { 
      firstStroke(note);
    }
    else 
    {
      brushStroke(note);
    }

    popMatrix();
  }
}



void firstStroke(Note note) {
  if (!note.firstDrawn) {
    pushMatrix();
    rotate(note.strokeAngle);
    translate(-note.firstImg.width/2, -note.firstImg.height/2);
    tint(255, note.maxTint+50);
    image(note.firstImg, 0, 0);
    g.removeCache(note.firstImg);
    popMatrix();
    note.firstDrawn = true;
  }
}

void lastStroke(Note note) {
  if (!note.lastDrawn && note.brush.hasEnds) {
    setDrawDirection(note);

    pushMatrix();
    rotate(-note.strokeAngle);
    translate(-note.lastImg.width/2, -note.lastImg.height/2);
    tint(255, note.brushTint);
    image(note.lastImg, 0, 0);
    g.removeCache(note.lastImg);
    popMatrix();
    popMatrix();
    note.lastDrawn = true;
  }
}

void brushStroke(Note note) {

  if (note.brush.strokeType == 0) {
    defaultStroke(note);
  }
  if (note.brush.strokeType == 1) {
    alignedStroke(note);
  }
  if (note.brush.strokeType == 2) {
    jitteryStroke(note);
  }
  if (note.brush.strokeType == 5) {
    drawSplat(note);
  }
}

void jitteryStroke(Note note) {
  //recommended for round brushes
  if (note.duration%3 == 0) {
    pushMatrix();
    rotate(radians((note.duration %5)) * 5);
    translate(-note.brushImg.width/2, -note.brushImg.height/2);
    //tint(255, note.velocity/90 + 100);
    image(note.brushImg, 0, 0);
    g.removeCache(note.brushImg);
    popMatrix();
  }
}

void alignedStroke(Note note) {
  pushMatrix();
  rotate(note.strokeAngle);
  translate(-note.brushImg.width/2, -note.brushImg.height/2);
  image(note.brushImg, 0, 0);
  g.removeCache(note.brushImg);
  popMatrix();
}

void defaultStroke(Note note) {
  pushMatrix();
  translate(-note.brushImg.width/2, -note.brushImg.height/2);
  image(note.brushImg, 0, 0);
  g.removeCache(note.brushImg);
  popMatrix();
}

void drawSplat(Note note) {
  if (!note.hasSplatted) {
    pushMatrix();
    noTint();
    rotate(radians(random(360)));
    translate(-note.brushImg.width/2, -note.brushImg.height/2);
    image(note.brushImg, 0, 0);
    g.removeCache(note.brushImg);
    note.hasSplatted = true;
    popMatrix();
  }
}

void setDrawDirection(Note note) {
  pushMatrix();
  translate(note.initalX, note.initalY);
  rotate(note.startAngle);
  //    fill(255,0,0);
  //    ellipse(0,0, 20,20);
  //    fill(0,255,0);
  //    line(0,0, 20,0);
  translate(note.posX - note.initalX, note.posY );
  tint(255, note.brushTint); //Fade out brush
  scale(note.brushSize);
}



color determineColor(int pitch, int velocity) {
  //This will be filled in better later
  return color(setColorBrightness(scheme[pitch % 12], pitch));
}

color setColorBrightness(color oldColor, int pitch) {
  int octave = pitch/12;
  int change;
  if (octave <= 3) {
    change = -10 * octave;
  }
  else {
    change = 10 * octave;
  }
  //change this, maybe? in the future... mask the color to get individual values
  return color(red(oldColor) + change, green(oldColor) +change, blue(oldColor) + change);
}

void noteOn(int channel, int pitch, int velocity) {
  if (state == State.PLAYING || state == State.STARTMESSAGE) {
    addActiveNote(channel, pitch, velocity);
    notePressed = true;
  }
}

void noteOff(int channel, int pitch, int velocity) {
  if (state == State.PLAYING) {
    Note dyingNote = removeActiveNote(pitch, velocity);
    if (dyingNote != null) {
      lastStroke(dyingNote);
    }
  }
}


synchronized void addActiveNote(int channel, int pitch, int velocity) {

  activeNotes.add(new Note(channel, pitch, velocity, determineColor(pitch, velocity)));
}

synchronized Note removeActiveNote(int pitch, int velocity) {
  //Search the activeNotes array for a note with a matching pitch
  //If one is found, remove it
  for (int currentNote = 0; currentNote < activeNotes.size(); currentNote++) {
    if (activeNotes.get(currentNote).pitch == pitch) {
      return activeNotes.remove(currentNote);
    }
  }
  return null;
}

synchronized void removeStaleNotes() {
  boolean staleFound = true;
  while (staleFound)
  {
    staleFound = false;
    for (int currentNote = 0; currentNote < activeNotes.size(); currentNote++) {
      if (activeNotes.get(currentNote).duration > 100) {
        activeNotes.remove(currentNote);
        staleFound = true;
        break;
      }
    }
  }
}

void wait(int milliseconds) {
  int startTime = millis();
  int timePassed = 0;
  while (milliseconds > timePassed) {
    timePassed = millis() - startTime;
  }
}


