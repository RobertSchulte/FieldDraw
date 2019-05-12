//  Field Draw Jan 2019 Robert Schulte

import controlP5.*; // import controlP5 library
ControlP5 controlP5; // controlP5 object GUI

float printWidth, printHeight, scale, scaleUp;
int canvasWD, canvasHT, imageWD, imageHT;
int dpi, session, sequence;

int bgClr, fgClr;

float offX, offY;

int matrixColumns, matrixRows;

ArrayList<Pod> podARL;
int podID; // active pod

int dimension;

float friction;
float gravForce;
PVector gravDir;

int count;
float step;

boolean showAgents, drawMode, isPause;  

FieldMatrix fm; // new field matrix
Agents [] drawAgents; // draw agent array

PGraphics drawBuffer;
PGraphics fieldBuffer;
PGraphics screenBuffer;
PGraphics agentBuffer;

void settings() {
  //fullScreen(P2D);
  fullScreen();
  //size(960, 540);
}

void setup() 
{
  controlP5 = new ControlP5(this);

  printWidth = 10;
  printHeight = 8.5;
  dpi = 100;

  bgClr = 0;
  fgClr = 255;

  matrixColumns = 10;
  matrixRows = 5;

  friction = .01;

  gravDir = new PVector();
  gravForce = 0.1;

  showAgents = false;
  isPause = false;

  fill(bgClr);
  strokeWeight(4);
  stroke(fgClr);

  podARL = new ArrayList();

  setUpCanvas();
  initFieldMatrix();
  initGUI();
  
  addPod();
}

//  adds a pod
void addPod()
{
  podARL.add(new Pod());
  podID = podARL.size() - 1;
  podARL.get(podID).setPodID(podID);
  podARL.get(podID).initAgents();
  
  podARL.get(podID).setGUI();
  
  controlP5.addButton("POD " + (podID + 1) )
  .setBroadcast(false)
  .setValue(podID)
  .setPosition(400 + podID * 36, 180)
  .setSize(32, 32)
  .onPress(new CallbackListener() { 
    public void controlEvent(CallbackEvent event) {
      String name = event.getController().getName();
      float value = event.getController().getValue();
      println("got a press from a " + name + ", the value is " + value);
      podID = int(value);
      podARL.get(podID).setGUI();
    }})
  .setBroadcast(true);
}

void initFieldMatrix()
{
  fm = new FieldMatrix(imageWD, imageHT, matrixColumns);
  fm.drawField(fieldBuffer);
}

//  Set up the canvas - full print resolution
void setUpCanvas()
{
  scale = 1;

  canvasWD = int(printWidth * dpi);
  canvasHT = int(printHeight * dpi);

  float scar = width / height;
  float cvar = canvasWD / canvasHT;

  if (canvasWD > width || canvasHT > height)
  {
    if (scar < cvar) 
    {
      scale = float(width) / float(canvasWD);
    } else
    {
      scale = float(height) / float(canvasHT);
    }
  }

  //  image size is set to fit on the screen
  imageWD = int(canvasWD * scale);
  imageHT = int(canvasHT * scale);

  scaleUp = float(canvasWD) / float(imageWD);

  dimension = imageWD * imageHT;

  step = (canvasWD * canvasHT) / dimension;

  offX = (width - imageWD) / 2;
  offY = (height - imageHT) / 2;

  drawBuffer = createGraphics(canvasWD, canvasHT);
  fieldBuffer = createGraphics(imageWD, imageHT);
  screenBuffer = createGraphics(imageWD, imageHT);
  agentBuffer = createGraphics(imageWD, imageHT);

  screenBuffer.beginDraw();
  screenBuffer.background(bgClr);
  screenBuffer.endDraw();

  session = int(random(8999) + 1000);
  sequence = 0;

  println(width, height, imageWD, imageHT, canvasWD, canvasHT, scale, scaleUp);
}

void updateScreenBuffer()
{
  int i2 = 0, x2, y2;
  //screenBuffer.loadPixels();
  for (int i = 0; i < screenBuffer.pixels.length; i++) 
  { 
    x2 = round((i % imageWD) * scaleUp);
    //y2 = round((i / imageWD) * scaleUp);
    y2 = round( (i - x2) / (imageWD) * scaleUp );

    i2 = floor(x2 + y2 * canvasWD);

    if (i2 < 0 || i2 >= drawBuffer.pixels.length) {
      // i2 is out of bounds
      // println("i2 is out of bounds: " + x2, y2, i2);
    } else {
      screenBuffer.pixels[i] = drawBuffer.pixels[i2];
    }
  }

  screenBuffer.updatePixels();
}

void saveImage()
{
  sequence++;
  String filename = "Flow-" + session + "-" + pad(str(sequence), 3) + ".png";
  drawBuffer.save("images/" + filename);
}

void keyPressed() {
  if (key  == 'p')
  {
    for (int i = 0; i < dimension; i++) { 
      screenBuffer.pixels[i] = drawBuffer.pixels[i];
    }
    screenBuffer.updatePixels();
  }

  if (key  == 's') {
    saveImage();
  }

  if (key  == 'm')  
  {
    if (controlP5.isVisible())
    {
      controlP5.hide();
    } else
    {
      controlP5.show();
    }
  }

  if (key  == 'b')  
  {
    fm.makeSmoothField();
    fm.drawField(fieldBuffer);
  }
}

String pad (String num, int max) 
{
  String str = num.toString();
  return str.length() < max ? pad("0" + str, max) : str;
}

void draw() {

  background(0);

  rect(offX, offY, imageWD, imageHT);

  drawBuffer.beginDraw();
  agentBuffer.beginDraw();

  if (showAgents)
  {
    agentBuffer.background(0, 0);
  }
  
  for(int i = 0; i < podARL.size(); i++)
  {
    podARL.get(i).update();
  }
  
  agentBuffer.endDraw();
  drawBuffer.endDraw();
    
  updateScreenBuffer();
  image(screenBuffer, offX, offY);
    
  if (showAgents)
  {
    image(fieldBuffer, offX, offY);
    image(agentBuffer, offX, offY);
  }

}
