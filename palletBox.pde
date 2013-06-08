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
  color backgroundColor = color(255);
  color selectedColor = color(50);
  color scrollbarColor = color(255);

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

  void drawEverything() {
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

  void drawColors() {
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

  void updateScrollbar(int y) {
    scrollbarPositionY = y - (scrollbarHeight/3);
    //check my bounds
    if (scrollbarPositionY + scrollbarHeight >= bottom) {
      scrollbarPositionY = bottom - scrollbarHeight;
    }

    if (scrollbarPositionY  <= top) {
      scrollbarPositionY = top;
    }
  }



  boolean touchingScrollbar(int x, int y) {
    if (x >= scrollbarPositionX && x <=  scrollbarPositionX + scrollbarWidth
      &&y >= scrollbarPositionY && y <=  scrollbarPositionY + scrollbarHeight) {
      return true;
    }
    return false;
  }

  int touchingPallet(int x, int y) {
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

