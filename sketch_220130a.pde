import controlP5.*;

PImage img;
PImage wImg;
ControlP5 cp5;

int gridSize = 32;
int thresholdValue = 128;
boolean doThreshold = false;
boolean average = false;
boolean showImage = false;
boolean variableRadius = false;

float imgMin = 0;
float imgMax = 255;

color constantColor = color(8, 38, 88);
color constantBackground = color(246, 253, 160);

color labelColor = color(constantColor);

void setup() {
  img = loadImage("aino.jpg");
  wImg = img.copy();
  size(600, 600);
  imgMin = minValue(img);
  imgMax = maxValue(img);
  img.resize(width, height);
  cp5 = new ControlP5(this);
  cp5.addSlider("thresholdValue")
    .setPosition(16, 16)
    .setSize(100, 20)
    .setRange(0, 255)
    .setValue(128)
    .setColorCaptionLabel(labelColor);
  cp5.addSlider("gridSize")
    .setPosition(16, 44)
    .setSize(100, 20)
    .setRange(1, 64)
    .setValue(32)
    .setColorCaptionLabel(labelColor);
  cp5.addToggle("doThreshold")
     .setValue(true)
     .setPosition(16, 72)
      .setColorCaptionLabel(labelColor);
  cp5.addToggle("average")
     .setValue(true)
     .setPosition(16, 112)
     .setColorCaptionLabel(labelColor);
  cp5.addToggle("showImage")
     .setValue(true)
     .setPosition(16, 152)
     .setColorCaptionLabel(labelColor);
  cp5.addToggle("variableRadius")
     .setValue(true)
     .setPosition(16, 192)
     .setColorCaptionLabel(labelColor);
}

void threshold(PImage img) {
  for (int x=0;x < img.width;x++) {
    for (int y=0;y < img.height;y++) {
      int pos = y * img.width + x;
      color p = img.pixels[pos];
      color gray = color((red(p) + blue(p) + green(p)) / 3);
      img.pixels[pos] = gray >= color(thresholdValue) ? constantColor : color(0,0,0,0);
    }
  }
}

color average(PImage img, int cx, int cy, int gs) {
  float r = 0;
  float g = 0;
  float b = 0;
  float gs2 = (2*gs) * (2*gs);
  for (int x=cx - gs; x < cx + gs; x++) {
    for (int y=cy - gs; y < cy + gs; y++) {
       color p = img.pixels[y * img.width + x];
       r += red(p);
       g += green(p);
       b += blue(p);
    }
  }
  return color(r / gs2, g / gs2, b / gs2);
}
float maxValue(PImage img) {
  float value = 0;
  for (int x=0;x<img.width;x++) {
    for (int y=0;y<img.height;y++) {
      color col = img.pixels[y * img.width + x];
      float gray = (red(col) + blue(col) + green(col)) / 3;

       if (gray > value)
         value = gray;
    }
  }
  return value;
}
float minValue(PImage img) {
  float value = Float.MAX_VALUE;
  for (int x=0;x<img.width;x++) {
    for (int y=0;y<img.height;y++) {
      color col = img.pixels[y * img.width + x];
      float gray = (red(col) + blue(col) + green(col)) / 3;

       if (gray < value)
         value = gray;
    }
  }
  return value;
}
void grid(PImage img) {
  noStroke();
  int gs = width / gridSize; 
  for (int x=gs; x < img.width - gs;x += gs) {
    for (int y=gs;y < img.height - gs;y += gs) {
      color col = average ? average(img, x, y, gs) : img.pixels[y*img.width+x];
      fill(average ? col : constantColor);
      if (variableRadius) {
        color gray = color((red(col) + blue(col) + green(col)) / 3);
        float s = map(red(gray), imgMin, imgMax, gs/4, gs);
        ellipse(x, y, s, s);
      } else {
        ellipse(x, y, gs, gs);
      }
    }
  }  
}

void draw() {
  background(constantBackground);
  if (showImage) {
    image(img, 0, 0, width, height);
  }
  
  wImg = img.copy();
  
  if (doThreshold) {
    threshold(wImg);
  }
  
  grid(wImg);
}
