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

  void drawScreen() {
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

