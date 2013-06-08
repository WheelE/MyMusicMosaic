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

  void drawScreen() {

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

  PImage setImagePixels(String imageName, color imageColor) {
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

