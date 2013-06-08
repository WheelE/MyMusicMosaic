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

