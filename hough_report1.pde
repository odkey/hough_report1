int canvas_size = 500;
int diagonal;
int mx, my;

PImage myself;

PGraphics canvas;
PGraphics rhotheta;
PGraphics lines;
PGraphics result;
SobelFilter filter;
HoughField houghfield;

boolean isDrawing = true;
boolean isUpdated = false;
boolean isLineDrawn = true;
boolean isCurvesCleared = false;

void setup() {
    myself = loadImage("input.jpg");
    myself.resize(canvas_size, canvas_size);
    diagonal = (int)dist(0, 0, canvas_size, canvas_size);
    canvas = createGraphics(canvas_size, canvas_size);

    filter = new SobelFilter(myself);
    houghfield = new HoughField(canvas_size, canvas_size, canvas);
    rhotheta = createGraphics(houghfield.field_theta, houghfield.field_rho);
    lines = createGraphics(canvas_size, canvas_size);

    size(canvas_size * 2, canvas_size); 

    canvas.beginDraw();
    canvas.image(filter.sobel(0.2), 0, 0, canvas_size, canvas_size);
    canvas.endDraw();

    rhotheta.beginDraw();
    rhotheta.background(0);
    rhotheta.endDraw();

    lines.beginDraw();
    lines.background(0, 0);
    lines.endDraw();
}

void draw() {
    if (isDrawing) {
        mx = mouseX;
        my = mouseY;
        canvas.beginDraw();
        canvas.stroke(255);
        canvas.image(filter.sobel(), 0, 0, canvas.width, canvas.height);
        canvas.point(mx, my);
        canvas.endDraw();


        houghfield.update(canvas);
        houghfield.draw(rhotheta);

        lines.beginDraw();
        lines.background(255, 0);
        houghfield.drawLines(lines, 20);

        lines.endDraw();
    }

    image(canvas, 0, 0);
    if (isLineDrawn)image(lines, 0, 0);
    
    if (mouseX >= canvas_size) {
        int irho = mouseY;
        int itheta = mouseX - canvas_size;
        Line l = houghfield.restoreLine(irho, itheta);
        if (l != null) {
          line(l.x1, l.y1, l.x2, l.y2);
      }
  }

  image(rhotheta, canvas_size, 0);
  stroke(255);
  line(canvas_size, 0, canvas_size, canvas_size);

  isCurvesCleared = false;
}

void saveLines(int x, int y){
    String filename = "data/lines-";
    filename += x;
    filename += "-";
    filename += y;
    filename += ".jpg";
    lines.save(filename);
    println("lines saved");
}
void saveCurves(int x, int y){
    if(isCurvesCleared)return;
    String filename = "data/curves-";
    filename += x;
    filename += "-";
    filename += y;
    filename += ".jpg";
    rhotheta.save(filename);
    println("curves saved");
}
void saveResult(){
    String filename = "data/2620130650_7.jpg";
    result = createGraphics(canvas_size, canvas_size);
    result.beginDraw();
    result.image(canvas, 0, 0);
    result.image(lines, 0, 0);
    result.endDraw();
    result.save(filename);
}
void keyPressed() {
    if (key == 'c') {
        canvas.beginDraw();
        canvas.background(0);
        canvas.endDraw();
        lines.beginDraw();
        lines.background(0);
        lines.endDraw();

        houghfield.clear();
        isUpdated = true;
        isCurvesCleared = true;
    }
    if(key == 'l')isLineDrawn = !isLineDrawn;
    
    if(key == 's')saveResult();
}

