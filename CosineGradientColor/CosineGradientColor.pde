
import controlP5.*;

CosGrad red, green, blue;
PGraphics palette;
void setup() {
  size(700, 400);

  red = new CosGrad(this, new PVector(0, 0));
  green = new CosGrad(this, new PVector(200, 0));
  blue = new CosGrad(this, new PVector(400, 0));
  palette = createGraphics(700, 200);
}

void draw() {
  background(0);

  red.update();
  green.update();
  blue.update();

  palette.beginDraw();
  palette.background(0);
  for (int i = 0; i < palette.width; i++) {
    color c = color(red.calculateCosGrad(map(i, 0, palette.width, 0, TWO_PI)), 
      green.calculateCosGrad(map(i, 0, palette.width, 0, TWO_PI)), 
      blue.calculateCosGrad(map(i, 0, palette.width, 0, TWO_PI))
      );
    palette.stroke(c);
    palette.line(i, 0, i, palette.height);
  }
  palette.endDraw();

  image(palette,0,height/2);

  noStroke();
  fill(255);
  textSize(20);
  text("Red", red.location.x+10, red.location.y+30);
  text("Green", green.location.x+10, green.location.y+30);
  text("Blue", blue.location.x+10, blue.location.y+30);
}


void keyPressed(){
  if(key == 's'){
    palette.save("palette.jpg");
  }
}

public class CosGrad {
  PApplet papplet;
  ControlP5 cp5;
  PVector location;
  float bias;
  float amplitude;
  float frequency;
  float phase;

  CosGrad(PApplet _papplet, PVector _location) {
    this(_papplet, _location, 0f, 0f, 0f, 0f);
  }

  CosGrad(PApplet _papplet, PVector _location, float _bias, float _amplitude, float _frequency, float _phase) {
    papplet = _papplet;
    location = _location;
    bias = _bias;
    amplitude = _amplitude;
    frequency = _frequency;
    phase = _phase;

    cp5 = new ControlP5(papplet);
    cp5.addSlider("bias")
      .plugTo(bias)
      .setValue(bias)
      .setPosition(location.x+10, location.y+40)
      .setSize(100, 20)
      .setRange(0., 1.);

    cp5.addSlider("amplitude")    
      .plugTo(amplitude)
      .setValue(amplitude)
      .setPosition(location.x+10, location.y+70)
      .setSize(100, 20)
      .setRange(0., 1.);

    cp5.addSlider("frequency")    
      .plugTo(frequency)
      .setValue(frequency)
      .setPosition(location.x+10, location.y+100)
      .setSize(100, 20)
      .setRange(0., 3.);

    cp5.addSlider("phase")    
      .plugTo(phase)
      .setValue(phase)
      .setPosition(location.x+10, location.y+130)
      .setSize(100, 20)
      .setRange(0., TWO_PI);
  }

  void update() {
    bias = cp5.getController("bias").getValue();
    amplitude = cp5.getController("amplitude").getValue();
    frequency = cp5.getController("frequency").getValue();
    phase = cp5.getController("phase").getValue();
  }

  float calculateCosGrad(float param) {
    float c = amplitude * cos(frequency * param + phase*TWO_PI);
    return 255*pow(constrain(c + bias, 0, 1), 2.2);
  }
}