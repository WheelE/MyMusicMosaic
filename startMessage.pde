class StartMessage {
  color textColor;

  StartMessage(color backgroundColor) {
    textColor = color(modifyColor(red(backgroundColor)), modifyColor(green(backgroundColor)), modifyColor( blue(backgroundColor)));
  } 

  int modifyColor(float colorValue) {
    if (colorValue > 150)
      return (int)colorValue - 100;
    return (int)colorValue + 100;
  }

  void drawMessage() {
    fill(textColor);
    textSize(100);
    text("Start Playing!", displayWidth/2 - 322, 200);
    textSize(50);
    text("Click for Menu", displayWidth/2 - 175, 260);
  }
}

