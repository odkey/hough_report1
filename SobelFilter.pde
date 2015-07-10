class SobelFilter {
  PImage origin;
  PImage gray;
  PImage export;

  int w, h;

  float threshold;

  final float[][] sobelX= {
    {-1, 0, 1},
    {-2, 0, 2},
    {-1, 0, 1}
  };
  final float[][] sobelY= {
    {-1, -2, -1},
    {0, 0, 0},
    {1, 2, 1}
  };

  SobelFilter (PImage _origin, float _threshold) {
    threshold = _threshold;
    origin = _origin;
    
    w = origin.width;
    h = origin.height;
    
    origin.loadPixels();
    gray = createImage(w, h, RGB);
    export = createImage(w, h, RGB);
    
    for(int i = 0; i < origin.pixels.length; i++){
      gray.pixels[i] = origin.pixels[i];
    }
    
    gray.filter(GRAY);
    gray.updatePixels();

    //gray.loadPixels();
    //export.loadPixels();
  }
  
  SobelFilter(PImage _origin) {
    this(_origin, 0.5);
  }
  
  void execute(float _threshold){
    threshold = _threshold;

    float max_value = 0;
    float[][] values = new float[w][h];
    for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        if(i == 0 || i == w-1 || j == 0 || j == h-1){
          export.pixels[j*w+i] = color(0);
          continue;
        }
        float valueX = 0, valueY = 0;
        for(int x = -1; x < 2; x++){
          for(int y = -1; y < 2; y++){
            int _i = i+x, _j = j+y;
            valueX += sobelX[x+1][y+1]*blue(gray.pixels[_j*w+_i]);
            valueY += sobelY[x+1][y+1]*blue(gray.pixels[_j*w+_i]);
          }
        }
        float value = (abs(valueX)+abs(valueY))/255.f/2;///(float)mag(1020, 1020);
        //value = (value >= 10)? 1: .1*value;
        values[i][j] = value;
        max_value = (value >= max_value)? value: max_value;
      }
    }
    float thr = max_value*threshold;
    for(int i = 0; i < w; i++){
      for(int j = 0; j < h; j++){
        ///////////
        if (values[i][j] >= thr){
          export.pixels[j*w+i] = color(255);
        }
        else {
          export.pixels[j*w+i] = color(0);
        }
      }
    }
    export.updatePixels();
  }
  
  void execute() {
    execute(0.5);
  }
  
  PImage sobel() {
    execute(threshold);
    return export;
  }
  
  PImage sobel(float _threshold) {
    if (_threshold > 1)println("Threshold value should be no more than 1.0.");
    if (_threshold < 0)println("Threshold value should be no less than 0.0.");
    execute(_threshold);
    return export;
  }
}