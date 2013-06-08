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

  void drawButton() {
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

  boolean isPressed(int xClicked, int yClicked) {
    if (xClicked >= x && xClicked <= x+buttonWidth
      && yClicked >= y && yClicked <= y+buttonHeight) {
      wait(100);
      return true;
    }
    return false;
  }

  void isHovered(int xMouse, int yMouse) {
    if (xMouse >= x && xMouse <= x+buttonWidth
      && yMouse >= y && yMouse <= y+buttonHeight) {
      hovered = true;
    }
    else
      hovered = false;
  }

  void wait(int milliseconds) {
    int startTime = millis();
    int timePassed = 0;
    while (milliseconds > timePassed) {
      timePassed = millis() - startTime;
    }
  }
}

