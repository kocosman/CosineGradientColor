
import controlP5.*;
ControlP5 cp5;

PGraphics palette;
String paletteName;

CosineGradientColor gradColor;

void setup() {
  size(700, 400);

  gradColor = new CosineGradientColor(this);
  gradColor.displayControllers(!false);

  palette = createGraphics(700, 200);
  cp5 = new ControlP5(this);

  cp5.addBang("SaveImage")
    .setPosition(width-80, 40)
    .setSize(30, 30)
    .setCaptionLabel("Save");

  cp5.addBang("Randomize")
    .setPosition(width-80, 110)
    .setSize(30, 30);
}

void draw() {
  background(0);

  gradColor.update();
  palette.beginDraw();
  palette.background(0);

  for (int i = 0; i < palette.width; i++) {
    color c = gradColor.getColor(map(i, 0, palette.width, 0, TWO_PI));
    palette.stroke(c);
    palette.line(i, 0, i, palette.height);
  }

  palette.endDraw();
  image(palette, 0, height/2);

  noStroke();
  fill(255);
  textSize(20);
  text("Red", gradColor.red.location.x+10, gradColor.red.location.y+30);
  text("Green", gradColor.green.location.x+10, gradColor.green.location.y+30);
  text("Blue", gradColor.blue.location.x+10, gradColor.blue.location.y+30);
}

void SaveImage() {
  paletteName = "Red_"+gradColor.red.bias+"_"+gradColor.red.amplitude+"_"+gradColor.red.frequency+"_"+gradColor.red.phase+"-"
    +"Green_"+gradColor.green.bias+"_"+gradColor.green.amplitude+"_"+gradColor.green.frequency+"_"+gradColor.green.phase+"-"
    +"Blue_"+gradColor.blue.bias+"_"+gradColor.blue.amplitude+"_"+gradColor.blue.frequency+"_"+gradColor.blue.phase;
  palette.save(paletteName+".jpg");
}

void Randomize() {
  gradColor.randomize();
}

void keyPressed() {
  if (key == 's') {
    SaveImage();
  } else if (key == 'r') {
    Randomize();
  }
}

public class CosineGradientColor {
  public CosineGradientChannel red;
  public CosineGradientChannel green;
  public CosineGradientChannel blue;
  public PApplet papplet;

  CosineGradientColor(PApplet _papplet) {
    papplet = _papplet;
    red = new CosineGradientChannel(papplet, new PVector(0, 0));
    green = new CosineGradientChannel(papplet, new PVector(200, 0));
    blue = new CosineGradientChannel(papplet, new PVector(400, 0));
  }

  void displayControllers(boolean _show) {
    if (_show) {
      red.cp5.show();
      green.cp5.show();
      blue.cp5.show();
    } else {
      red.cp5.hide();
      green.cp5.hide();
      blue.cp5.hide();
    }
  }


  void randomize() {
    red.cp5.getController("bias").setValue(random(red.cp5.getController("bias").getMin(), red.cp5.getController("bias").getMax()));
    red.cp5.getController("amplitude").setValue(random(red.cp5.getController("amplitude").getMin(), red.cp5.getController("amplitude").getMax()));
    red.cp5.getController("frequency").setValue(random(red.cp5.getController("frequency").getMin(), red.cp5.getController("frequency").getMax()));
    red.cp5.getController("phase").setValue(random(red.cp5.getController("phase").getMin(), red.cp5.getController("phase").getMax()));

    green.cp5.getController("bias").setValue(random(red.cp5.getController("bias").getMin(), red.cp5.getController("bias").getMax()));
    green.cp5.getController("amplitude").setValue(random(red.cp5.getController("amplitude").getMin(), red.cp5.getController("amplitude").getMax()));
    green.cp5.getController("frequency").setValue(random(red.cp5.getController("frequency").getMin(), red.cp5.getController("frequency").getMax()));
    green.cp5.getController("phase").setValue(random(red.cp5.getController("phase").getMin(), red.cp5.getController("phase").getMax()));

    blue.cp5.getController("bias").setValue(random(red.cp5.getController("bias").getMin(), red.cp5.getController("bias").getMax()));
    blue.cp5.getController("amplitude").setValue(random(red.cp5.getController("amplitude").getMin(), red.cp5.getController("amplitude").getMax()));
    blue.cp5.getController("frequency").setValue(random(red.cp5.getController("frequency").getMin(), red.cp5.getController("frequency").getMax()));
    blue.cp5.getController("phase").setValue(random(red.cp5.getController("phase").getMin(), red.cp5.getController("phase").getMax()));
    update();
  }

  void update() {
    red.update();
    green.update();
    blue.update();
  }

  color getColor(float _param) {
    color c = color(red.calculateCosGrad(_param), 
      green.calculateCosGrad(_param), 
      blue.calculateCosGrad(_param)
      );
    return c;
  }
}

public class CosineGradientChannel {
  PApplet papplet;
  ControlP5 cp5;
  PVector location;
  float bias;
  float amplitude;
  float frequency;
  float phase;

  CosineGradientChannel(PApplet _papplet) {
    this(_papplet, new PVector(0, 0), 0f, 0f, 0f, 0f);
  }

  CosineGradientChannel(PApplet _papplet, PVector _location) {
    this(_papplet, _location, 0f, 0f, 0f, 0f);
  }

  CosineGradientChannel(PApplet _papplet, PVector _location, float _bias, float _amplitude, float _frequency, float _phase) {
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