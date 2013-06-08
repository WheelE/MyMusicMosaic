import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import themidibus.*; 

import themidibus.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MyMusicMosaic extends PApplet {

//TODO
//-Catch error if there is no input
//-Set instruments to brushes
//something weird happening with last stroke
//Prettify ui
//installer



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
int backgroundColor = color(0, 0, 0);

int [][] storedPixels;

boolean notePressed = false;
int saved =0; //0 is not saving, 1 is saved, -1 is failed

String filePath = "/untitled";

int xOffset = 0;
Gui gui;
StartMessage startMessage;
PauseScreen pauseScreen;
HelpScreen helpScreen;
int[] scheme = new int[13];

int schemeNumber = 0;
int[][] pallets = {
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



public void setup() {
  size(displayWidth, displayHeight);
  smooth();
  fill(255);
  background(backgroundColor);
  gui = new Gui(pallets);
  pauseScreen = new PauseScreen();
  helpScreen = new HelpScreen();
  state = State.STARTSCREEN;
  storedPixels = new int[displayWidth][displayHeight];

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

public void setScheme() {

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

public int getBlend(int first, int second) {
  return color((red(scheme[first]) + red(scheme[second]))/2, 
  (green(scheme[first]) + green(scheme[second]))/2, 
  (blue(scheme[first]) + blue(scheme[second]))/2);
}

public synchronized void rawMidi(byte[] data) {
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
public boolean sketchFullScreen() {
  return true;
}

public void draw() {

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

public void fileSelected(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
    saved = -1;
  } 
  else {
    filePath = selection.getAbsolutePath();
    saved = 1;
  }
}



public void darkenScreen() {

  fill(50, 100);
  rect(0, 0, displayWidth, displayHeight);
}

public void updatePathPosition() {
  if (pathX >= displayWidth - 10) {
    xOffset += 50;
  }
  prevX = pathX;
  prevY = pathY;
  pathX =  (millis()/(10))%(displayWidth);
  pathY = ((displayHeight/2 - 50) * sin((2*PI*pathX + xOffset)/200)+displayHeight/2 - 150);
}

public void mousePressed() {
  gui.pressedX = mouseX;
  if (state == State.STARTMESSAGE) {
    state = State.PAUSESCREEN; 
    storeBlank();
    wait(100);
    darkenScreen();
  }
}



public void storeDisplayPixels() {
  for (int x = 0; x < displayWidth; x++) {
    for (int y =0; y < displayHeight; y++) {
      storedPixels[x][y] = get(x, y);
    }
  }
}

public void storeBlank() {
  for (int x = 0; x < displayWidth; x++) {
    for (int y =0; y < displayHeight; y++) {
      storedPixels[x][y] = backgroundColor;
    }
  }
}

public void setDisplayPixels() {
  for (int x = 0; x < displayWidth; x++) {
    for (int y =0; y < displayHeight; y++) {
      set(x, y, storedPixels[x][y]);
    }
  }
}

public synchronized void drawActiveNotes() {
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



public void firstStroke(Note note) {
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

public void lastStroke(Note note) {
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

public void brushStroke(Note note) {

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

public void jitteryStroke(Note note) {
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

public void alignedStroke(Note note) {
  pushMatrix();
  rotate(note.strokeAngle);
  translate(-note.brushImg.width/2, -note.brushImg.height/2);
  image(note.brushImg, 0, 0);
  g.removeCache(note.brushImg);
  popMatrix();
}

public void defaultStroke(Note note) {
  pushMatrix();
  translate(-note.brushImg.width/2, -note.brushImg.height/2);
  image(note.brushImg, 0, 0);
  g.removeCache(note.brushImg);
  popMatrix();
}

public void drawSplat(Note note) {
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

public void setDrawDirection(Note note) {
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



public int determineColor(int pitch, int velocity) {
  //This will be filled in better later
  return color(setColorBrightness(scheme[pitch % 12], pitch));
}

public int setColorBrightness(int oldColor, int pitch) {
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

public void noteOn(int channel, int pitch, int velocity) {
  if (state == State.PLAYING || state == State.STARTMESSAGE) {
    addActiveNote(channel, pitch, velocity);
    notePressed = true;
  }
}

public void noteOff(int channel, int pitch, int velocity) {
  if (state == State.PLAYING) {
    Note dyingNote = removeActiveNote(pitch, velocity);
    if (dyingNote != null) {
      lastStroke(dyingNote);
    }
  }
}


public synchronized void addActiveNote(int channel, int pitch, int velocity) {

  activeNotes.add(new Note(channel, pitch, velocity, determineColor(pitch, velocity)));
}

public synchronized Note removeActiveNote(int pitch, int velocity) {
  //Search the activeNotes array for a note with a matching pitch
  //If one is found, remove it
  for (int currentNote = 0; currentNote < activeNotes.size(); currentNote++) {
    if (activeNotes.get(currentNote).pitch == pitch) {
      return activeNotes.remove(currentNote);
    }
  }
  return null;
}

public synchronized void removeStaleNotes() {
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

public void wait(int milliseconds) {
  int startTime = millis();
  int timePassed = 0;
  while (milliseconds > timePassed) {
    timePassed = millis() - startTime;
  }
}


class Brush {
  String brushName;
  String firstBrushName;
  String lastBrushName;
  PImage brushImg;
  PImage firstBrushImg;
  PImage lastBrushImg;
  int strokeType;
  int pathType;
  boolean hasEnds = false;
  boolean splat = false;

  Brush(String [] brushNames, int strokeType, int pathType) {
    brushName = brushNames[0];
    brushImg = loadImage(brushNames[0]);
    if (brushNames.length > 1) {
      firstBrushName = brushNames[1];
      firstBrushImg = loadImage(brushNames[1]);
      lastBrushName = brushNames[2];
      lastBrushImg = loadImage(brushNames[2]);
      hasEnds = true;
    }
    this.strokeType = strokeType;
    this.pathType = pathType;

    if (strokeType ==5) {
      splat = true;
    }
    //handle errors...
  }
}

class Button {
  PImage image;
  PImage hoverImage;
  PImage selectImage;
  int x;
  int y;
  int buttonWidth;
  int buttonHeight;
  int value;
  boolean hovered = false;
  boolean selected = false;

  Button(int x, int y, int value, PImage image) {
    this.x = x;
    this.y = y;
    this.buttonWidth = image.width;
    this.buttonHeight = image.height;
    this.image = image;
    this.value = value;
    hoverImage = image;
    selectImage = image;
  }

  public void drawButton() {
    noTint();
    isHovered(mouseX, mouseY);
    if (selected) {
      image(selectImage, x, y);
    }
    else if (hovered) {
      image(hoverImage, x, y);
    }
    else
      image(image, x, y);
  }

  public boolean isPressed(int xClicked, int yClicked) {
    if (xClicked >= x && xClicked <= x+buttonWidth
      && yClicked >= y && yClicked <= y+buttonHeight) {
      wait(100);
      return true;
    }
    return false;
  }

  public void isHovered(int xMouse, int yMouse) {
    if (xMouse >= x && xMouse <= x+buttonWidth
      && yMouse >= y && yMouse <= y+buttonHeight) {
      hovered = true;
    }
    else
      hovered = false;
  }

  public void wait(int milliseconds) {
    int startTime = millis();
    int timePassed = 0;
    while (milliseconds > timePassed) {
      timePassed = millis() - startTime;
    }
  }
}

class Gui {
  int backgroundColor =  color(255);
  int pressedX = 0;
  Button backgroundOptions[] = new Button[2];
  String logo[] = new String[13];
  PImage logoImages[] = new PImage[13];
  int selectedPallet = 0;
  boolean drawStartup = true;
  int[][] pallets;


  PalletBox palletBox;
  Button startButton;
  Button exitButton;


  public Gui(int[][]pallets) {
    // Place your setup code here
    this.pallets = pallets;
    palletBox = new PalletBox(fillPalletBox());
    startButton = new Button((displayWidth/2) - 135, displayHeight - 200, 0, setImagePixels("start.jpg", color(0, 230, 0)));
    startButton.hoverImage = setImagePixels("start.jpg", color(0, 0, 230));
    backgroundOptions[0] =  new Button(palletBox.left+ 100, palletBox.top - 100, 0, setImagePixels("bgBox.jpg", color(0)));
    backgroundOptions[1] =  new Button(palletBox.left, palletBox.top - 100, 255, setImagePixels("bgBox.jpg", color(255)));
    backgroundOptions[0].selectImage = setImagePixels("bgBoxSelected.jpg", color(255));
    backgroundOptions[1].selectImage = setImagePixels("bgBoxSelected.jpg", color(0));
    backgroundOptions[1].selected = true;
    exitButton = new Button(displayWidth - 200, displayHeight - 100, -1, setImagePixels("exit.jpg", color(200, 0, 0)));
    exitButton.hoverImage = setImagePixels("exit.jpg", color(50));

    logo[0] = "M.jpg";
    logo[1] = "y.jpg";
    logo[2] = "M.jpg";
    logo[3] = "u.jpg";
    logo[4] = "s.jpg";
    logo[5] = "i.jpg";
    logo[6] = "c.jpg";
    logo[7] = "M.jpg";
    logo[8] = "o.jpg";
    logo[9] = "s.jpg";
    logo[10] = "a.jpg";
    logo[11] = "i.jpg";
    logo[12] = "c.jpg";
    updateLogo();
  }

  public void drawGui() {
    noTint();
    if (mousePressed) {
      if (palletBox.touchingScrollbar(pressedX, mouseY)) {
        palletBox.updateScrollbar(mouseY);
      }
      else if (palletBox.touchingPallet(mouseX, mouseY) != -1) {
        selectedPallet = palletBox.touchingPallet(pressedX, mouseY); 
        palletBox.selected = selectedPallet;
        updateLogo();
      }
      else if (startButton.isPressed(mouseX, mouseY)) {
        drawStartup = false;
      }
      else if (exitButton.isPressed(mouseX, mouseY)) {
        exit();
      }
      else {
        backgroundOptionsClicked();  //This is horribly done
      }
    }
    palletBox.drawEverything();
    coverPalletBox();
    drawBackgroundOptions();
    drawLogo();

    startButton.drawButton();
    exitButton.drawButton();
  }



  public void backgroundOptionsClicked() {
    for (int i = 0; i < backgroundOptions.length; i++) {
      if (backgroundOptions[i].isPressed(mouseX, mouseY) ) {
        unselectBackgroundOptions();
        backgroundOptions[i].selected = true;
        backgroundColor = color(backgroundOptions[i].value);
        palletBox.backgroundColor = backgroundColor;
      }
    }
  }

  public void unselectBackgroundOptions() {
    for (int i = 0; i < backgroundOptions.length; i++) {
      backgroundOptions[i].selected = false;
    }
  }

  public void drawBackgroundOptions() {
    for (int i = 0; i < backgroundOptions.length; i++) {
      backgroundOptions[i].drawButton();
    }
  }

  public void coverPalletBox() {
    noStroke();
    fill(backgroundColor); 
    rect(0, 0, palletBox.left, displayHeight);
    rect(0, 0, displayWidth, palletBox.top);
    rect(palletBox.right, 0, displayWidth - palletBox.right, displayHeight);
    rect(0, palletBox.bottom, (displayWidth - palletBox.left) +40, displayHeight - palletBox.bottom);
  }

  public void drawLogo() {
    int position = (displayWidth / 2) - 445; //445 is half the size of the logo
    for (int i = 0; i < logo.length; i++) {
      image(logoImages[i], position, 50);    //Here's the y position. It's ugly, I know.
      position = position + logoImages[i].width;
    }
  }

  public void updateLogo() {
    for (int i = 0; i < logo.length; i++) {
      logoImages[i] = setImagePixels(logo[i], pallets[selectedPallet][i % pallets[selectedPallet].length]);
    }
  }
  public PImage[][] fillPalletBox() {
    PImage[][] tempImages = new PImage[pallets.length][pallets[0].length];
    for (int row = 0; row < pallets.length; row++) {
      for (int col = 0; col < pallets[row].length; col++) {
        tempImages[row][col] = setImagePixels("brush.jpg", pallets[row][col]);
      }
    }
    return tempImages;
  }

  public PImage setImagePixels(String imageName, int imageColor) {
    PImage originalImage = loadImage(imageName);
    PImage img = createImage(originalImage.width, originalImage.height, ARGB);
    img.loadPixels();

    for (int y = 1; y < originalImage.height-1; y++) {
      for (int x = 1; x < originalImage.width-1; x++) {  

        int brightness = (int)brightness((int)originalImage.pixels[y*originalImage.width + x]);
        img.pixels[x + y*img.width] = color(imageColor, 255 -brightness);
      }
    } 
    return img;
  }
}

class HelpScreen {
  String text = "Gee, this is really helpful";
  Button backButton;
  boolean buttonPressed = false;

  int top;
  int left; //change these
  int boxHeight;
  int boxWidth;
  PImage helpImage;

  HelpScreen() {
    helpImage = loadImage("help.png");
    boxHeight = helpImage.height + 100;
    boxWidth = helpImage.width + 100;
    top = displayHeight/2 - boxHeight/2;
    left = displayWidth/2 - boxWidth/2;
    backButton = new Button(left + boxWidth/2 + 50, top + boxHeight - 90, 0, setImagePixels("continue.jpg", color(143, 222, 27)));
    backButton.hoverImage = setImagePixels("continue.jpg", color(250, 0, 0));
  }

  public void drawScreen() {
    fill(150);
    rect(left, top, boxWidth, boxHeight);
    image(helpImage, left, top);
    backButton.drawButton();
    if (mousePressed) {
      if (backButton.isPressed(mouseX, mouseY)) {
        buttonPressed = true;
      }
    }
  }
  public PImage setImagePixels(String imageName, int imageColor) {
    PImage originalImage = loadImage(imageName);
    PImage img = createImage(originalImage.width, originalImage.height, ARGB);
    img.loadPixels();

    for (int y = 1; y < originalImage.height-1; y++) {
      for (int x = 1; x < originalImage.width-1; x++) {  

        int brightness = (int)brightness((int)originalImage.pixels[y*originalImage.width + x]);
        img.pixels[x + y*img.width] = color(imageColor, 255 -brightness);
      }
    } 
    return img;
  }
}

class Note {
  int duration; 
  int startTime;
  int pitch;
  int velocity;
  int noteColor;
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

  Note(int channel, int pitch, int velocity, int myColor) {
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


  public void update() {

    previousX = posX;
    previousY = posY;
    duration = duration + 1;
    setXPosition();

    brushSize =(float)(velocity+20)/100 - (float)(duration/6)/100;
    brushTint =  (maxTint) -(duration);

    strokeAngle = getAngle(posX, previousX, posY, previousY);
    setYPosition();
  }

  public void setXPosition() {
    posX = pathX;
    //  if(posX >= displayWidth){
    //     posX = 0;}
    //   else if(posX <= 0){
    //     posX = displayWidth;
    //   }
  }

  public void setYPosition() {
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

  public void generateBrush() {
    
    brushImg = setBrushPixels(brush.brushImg);
    if (brush.hasEnds) {
      firstImg = setBrushPixels(brush.firstBrushImg);
      lastImg = setBrushPixels(brush.lastBrushImg);
    }
  }

  public PImage setBrushPixels(PImage originalImage) {
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

  public float getAngle(float firstx, float secondx, float firsty, float secondy) {
    return atan2(secondy-firsty, secondx-firstx);
  }



  public void setVoice() {

    if (msb >= 126 && msb <= 127)
    {
      voice = (int)random(brushes.size()-5, brushes.size()-1);
    }
    else {
      voice = programChange % (brushes.size()-4);
    }
  }
}

class PalletBox {
  PImage[][] pallets;
  int palletYs[];
  int scrollbarWidth = 10;
  int scrollbarHeight= 80;
  int scrollbarPositionX;
  int scrollbarPositionY;
  int scrollbarClickedY;
  int top;
  int bottom;
  int left;
  int right;
  int boxWidth;
  int boxHeight;
  int elementHeight = 71; 
  int elementWidth = 81;
  int padding = 8;
  int realHeight;
  int selected = 0;
  int backgroundColor = color(255);
  int selectedColor = color(50);
  int scrollbarColor = color(255);

  PalletBox(PImage[][] pallets) {
    this.pallets = pallets;
    palletYs = new int[pallets.length];
    elementHeight = pallets[0][0].height;
    elementWidth = pallets[0][0].width;
    boxHeight = displayHeight/4;
    boxWidth = elementWidth * pallets[0].length + 30;
    top= (displayHeight/2) - (boxHeight/2);
    bottom = top + boxHeight;
    left = (displayWidth/2) - (boxWidth/2);
    right = left + boxWidth;

    realHeight = pallets.length * elementHeight;
    scrollbarPositionX = boxWidth - scrollbarWidth + left;
    scrollbarPositionY = top;
  } 

  public void drawEverything() {
    fill(backgroundColor);
    rect(left, top, boxWidth, boxHeight);
    stroke(backgroundColor);
    noFill();
    strokeWeight(4);
    filter(INVERT);
    rect(left + 2, palletYs[selected] + 2, boxWidth -30, elementHeight - 2, 20);
    noStroke();
    fill(backgroundColor);
    rect(scrollbarPositionX, scrollbarPositionY, scrollbarWidth, scrollbarHeight, 7); 
    filter(INVERT);
    drawColors();
  }

  public void drawColors() {
    for (int row = 0; row < pallets.length; row++) {
      for (int col = 0; col < pallets[row].length; col++) {
        int x = col * elementWidth + left;
        float y = (row * elementHeight) + ((top-scrollbarPositionY) * realHeight/boxHeight) + top;
        palletYs[row] = (int)y;
        image(pallets[row][col], x, y);
        //    fill(50);
        //    stroke(255);
        //    rect(x,y,elementWidth, elementHeight);
      }
    }
  }

  public void updateScrollbar(int y) {
    scrollbarPositionY = y - (scrollbarHeight/3);
    //check my bounds
    if (scrollbarPositionY + scrollbarHeight >= bottom) {
      scrollbarPositionY = bottom - scrollbarHeight;
    }

    if (scrollbarPositionY  <= top) {
      scrollbarPositionY = top;
    }
  }



  public boolean touchingScrollbar(int x, int y) {
    if (x >= scrollbarPositionX && x <=  scrollbarPositionX + scrollbarWidth
      &&y >= scrollbarPositionY && y <=  scrollbarPositionY + scrollbarHeight) {
      return true;
    }
    return false;
  }

  public int touchingPallet(int x, int y) {
    //returns the index of the selected pallet
    //or -1 if not touching
    if (x >= left && x <=  right
      &&y >= top && y <=  bottom) {
      for (int i = 0; i < palletYs.length-1; i++) {
        if (y >= palletYs[i] && y <= palletYs[i+1])
          return i;
      }
      if (y >= palletYs[palletYs.length-1])
        return palletYs.length-1;
    }
    return -1;
  }
}

class PauseScreen {
  Button continueButton;
  Button resetButton;
  Button saveButton;
  Button helpButton;
  Button exitButton;

  int top;
  int left; 
  int boxHeight;
  int boxWidth;
  int buttonHeight = 100;

  boolean buttonPressed = false;
  int buttonNumber = 0;


  PauseScreen() {
    boxHeight = buttonHeight * 5  + 50;
    boxWidth =  buttonHeight * 3;
    top = displayHeight/2 - boxHeight/2;
    left = displayWidth/2 - boxWidth/2;

    continueButton = new Button(left + 15, top + 15, 0, setImagePixels("continue.jpg", color(223, 26, 130)));
    continueButton.hoverImage = setImagePixels("continue.jpg", color(250, 0, 0));
    resetButton = new Button(left + 15, top + 15 + buttonHeight, 0, setImagePixels("startOver.jpg", color(230, 180, 50)));
    resetButton.hoverImage = setImagePixels("startOver.jpg", color(250, 0, 0));
    saveButton = new Button(left + 15, top + 15 + buttonHeight * 2, 0, setImagePixels("save.jpg", color(143, 222, 27)));
    saveButton.hoverImage = setImagePixels("save.jpg", color(250, 0, 0));
    helpButton = new Button(left + 15, top + 15 + buttonHeight * 3, 0, setImagePixels("help.jpg", color(29, 134, 220)));
    helpButton.hoverImage = setImagePixels("help.jpg", color(250, 0, 0));
    exitButton = new Button(left + 15, top + 15 + buttonHeight * 4, 0, setImagePixels("exit.jpg", color(163, 73, 164)));
    exitButton.hoverImage = setImagePixels("exit.jpg", color(250, 0, 0));
  } 

  public void drawScreen() {

    fill(50);
    rect(left, top, boxWidth, boxHeight);
    continueButton.drawButton();
    resetButton.drawButton();
    saveButton.drawButton();
    helpButton.drawButton();
    exitButton.drawButton();
    if (mousePressed) {
      if (continueButton.isPressed(mouseX, mouseY)) {
        buttonNumber = 1; 
        buttonPressed = true;
      }
      if (resetButton.isPressed(mouseX, mouseY)) {
        buttonNumber = 2; 
        buttonPressed = true;
      }
      if (saveButton.isPressed(mouseX, mouseY)) {
        buttonNumber = 3; 
        buttonPressed = true;
      }
      if (helpButton.isPressed(mouseX, mouseY)) {
        buttonNumber = 4; 
        buttonPressed = true;
      }
      if (exitButton.isPressed(mouseX, mouseY)) {
        buttonNumber = 5; 
        buttonPressed = true;
      }
    }
  }

  public PImage setImagePixels(String imageName, int imageColor) {
    PImage originalImage = loadImage(imageName);
    PImage img = createImage(originalImage.width, originalImage.height, ARGB);
    img.loadPixels();

    for (int y = 1; y < originalImage.height-1; y++) {
      for (int x = 1; x < originalImage.width-1; x++) {  

        int brightness = (int)brightness((int)originalImage.pixels[y*originalImage.width + x]);
        img.pixels[x + y*img.width] = color(imageColor, 255 -brightness);
      }
    } 
    return img;
  }
}

class StartMessage {
  int textColor;

  StartMessage(int backgroundColor) {
    textColor = color(modifyColor(red(backgroundColor)), modifyColor(green(backgroundColor)), modifyColor( blue(backgroundColor)));
  } 

  public int modifyColor(float colorValue) {
    if (colorValue > 150)
      return (int)colorValue - 100;
    return (int)colorValue + 100;
  }

  public void drawMessage() {
    fill(textColor);
    textSize(100);
    text("Start Playing!", displayWidth/2 - 322, 200);
    textSize(50);
    text("Click for Menu", displayWidth/2 - 175, 260);
  }
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "MyMusicMosaic" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
