PImage img;
int xStep = 12, yStep = 12;

void setup() {
  size(623, 604);
  img = loadImage("testi.png");
}

float side(float x, float y, float x1, float y1, float x2, float y2)
{
   return (y2 - y1)*(x - x1) + (-x2 + x1)*(y - y1);
}

boolean contains(float x, float y,
                  float[] triangle)
{
  boolean result = true;
  for (int i=0; i<triangle.length;i++) {
    int x1 = i;
    int y1 = (i + 1) % triangle.length;
    int x2 = (i + 2) % triangle.length;
    int y2 = (i + 3) % triangle.length;

    result &= side(x, y, triangle[x1], triangle[y1], triangle[x2], triangle[y2]) >= 0;
  }
  
  return result;
}

color average(PImage img, int sx, int sy, int w, int h, float[] triangles) {
  float r = 0;
  float g = 0;
  float b = 0;
  int pixelCount = 0;
  for (int x=sx; x < sx + w; x++) {
    for (int y=sy; y < sy + h; y++) {
      for (int i=0;i<triangles.length;i += 6) {
        float[] triangle = new float[] {
          triangles[i], triangles[i+1],
          triangles[i+2], triangles[i+3],
          triangles[i+4], triangles[i+5]
        };
        if (contains(x - sx, y - sy, triangle)) {
          color p = img.pixels[y * img.width + x];
          r += red(p);
          g += green(p);
          b += blue(p);
          pixelCount ++;
        }
      }
    }
  }
  return color(r / pixelCount, g / pixelCount, b / pixelCount);
}

void draw() {
  background(255);
  //image(img, 0, 0, width, height);
  noStroke();
  for ( int i=0; i<width/xStep; i++) {
    for ( int j=0; j<height/yStep; j++) {
      pushMatrix();
      translate(xStep * i, yStep * j);
      bloop(i, j);
      popMatrix();
    }
  }
}

void bloop(int i, int j) {
  float[] triangles = new float[] {
    xStep / 2, 0,
    0, yStep / 4,
    xStep / 2, yStep / 2,
    
    xStep / 2, 0,
    xStep, yStep / 4,
    xStep / 2, yStep / 2,
    
    0, yStep / 4,
    xStep / 2, yStep / 2,
    0, 3 * yStep / 4,
    
    xStep, yStep / 4,
    xStep / 2, yStep / 2,
    xStep, 3 * yStep / 4,
    
    0, 3 * yStep / 4,
    xStep / 2, yStep /2, 
    xStep / 2, yStep,
    
    xStep, 3 * yStep / 4,
    xStep / 2, yStep / 2,
    xStep / 2, yStep
    };
 
  color a = average(
    img, 
    i * xStep, 
    j * yStep,
    100, 55,
    triangles
  );
  
  fill(a);
  noStroke();
  beginShape(TRIANGLES);
  for(int n=0;n<triangles.length;n+=2)
      vertex(triangles[n], triangles[n + 1]);
  endShape();
}
