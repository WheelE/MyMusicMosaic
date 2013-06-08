class Gui {
  color backgroundColor =  color(255);
  int pressedX = 0;
  Button backgroundOptions[] = new Button[2];
  String logo[] = new String[13];
  PImage logoImages[] = new PImage[13];
  int selectedPallet = 0;
  boolean drawStartup = true;
  color[][] pallets;


  PalletBox palletBox;
  Button startButton;
  Button exitButton;


  public Gui(color[][]pallets) {
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



  void backgroundOptionsClicked() {
    for (int i = 0; i < backgroundOptions.length; i++) {
      if (backgroundOptions[i].isPressed(mouseX, mouseY) ) {
        unselectBackgroundOptions();
        backgroundOptions[i].selected = true;
        backgroundColor = color(backgroundOptions[i].value);
        palletBox.backgroundColor = backgroundColor;
      }
    }
  }

  void unselectBackgroundOptions() {
    for (int i = 0; i < backgroundOptions.length; i++) {
      backgroundOptions[i].selected = false;
    }
  }

  void drawBackgroundOptions() {
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

  void drawLogo() {
    int position = (displayWidth / 2) - 445; //445 is half the size of the logo
    for (int i = 0; i < logo.length; i++) {
      image(logoImages[i], position, 50);    //Here's the y position. It's ugly, I know.
      position = position + logoImages[i].width;
    }
  }

  void updateLogo() {
    for (int i = 0; i < logo.length; i++) {
      logoImages[i] = setImagePixels(logo[i], pallets[selectedPallet][i % pallets[selectedPallet].length]);
    }
  }
  PImage[][] fillPalletBox() {
    PImage[][] tempImages = new PImage[pallets.length][pallets[0].length];
    for (int row = 0; row < pallets.length; row++) {
      for (int col = 0; col < pallets[row].length; col++) {
        tempImages[row][col] = setImagePixels("brush.jpg", pallets[row][col]);
      }
    }
    return tempImages;
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

