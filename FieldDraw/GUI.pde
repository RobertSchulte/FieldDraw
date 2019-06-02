Slider cpTotalAgents;
Slider cpHue, cpSat, cpBrt;
Range cpSpeed;
Range cpThickness;
Range cpAlphaRange;
Range cpStrokeLength;
Range cpGapLength;

void initGUI()
{
  int btW = 120, btH = 16;
  int col = 20, row = 0;
  
  //  document settings
  controlP5.addSlider("printWidth")
    .setRange(0.5, 20)
    .setValue(printWidth)
    .setPosition(col, 20)
    .setNumberOfTickMarks(40)
    .snapToTickMarks(true)
    .showTickMarks(false)
    .setSize(btW, btH);

  controlP5.addSlider("printHeight")
    .setRange(0.5, 20)
    .setValue(printHeight)
    .setPosition(col, 40)
    .setNumberOfTickMarks(40)
    .snapToTickMarks(true)
    .showTickMarks(false)
    .setSize(btW, btH);

  controlP5.addSlider("dpi")
    .setRange(10, 400)
    .setNumberOfTickMarks(40)
    .snapToTickMarks(true)
    .showTickMarks(false)
    .setValue(dpi)
    .setPosition(col, 60)
    .setSize(btW, btH);
    
  //  Field settings
  controlP5.addSlider("matrixColumns")
    .setRange(4, 32)
    .setValue(matrixColumns)
    .setPosition(col, 90)
    .setSize(btW, btH);

  controlP5.addButton("UPDATE")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(col, 110)
    .setSize(btW, btH * 2)
    .setBroadcast(true);

  controlP5.addButton("Save")
    .setPosition(col, 145)
    .setSize(btW, btH * 2);

  col = 210;

  controlP5.addButton("SMOOTH MATRIX")
    .setValue(1)
    .setPosition(col, 20)
    .setSize(btW, btH);

  controlP5.addButton("RANDOM MATRIX")
    .setValue(1)
    .setPosition(col, 40)
    .setSize(btW, btH);

  controlP5.addSlider("gravForce")
    .setRange(0.1, 2)
    .setValue(gravForce)
    .setPosition(col, 60)
    .setSize(btW, btH);

  controlP5.addSlider("Direction")
    .setRange(0, PI)
    .setValue(0)
    .setPosition(col, 80)
    .setSize(btW, btH);

  controlP5.addSlider("friction")
    .setRange(0.1, 2)
    .setValue(.5)
    .setPosition(col, 100)
    .setSize(btW, btH);
    
  controlP5.addSlider("Smooth threshold")
    .setRange(1, 5)
    .setValue(3)
    .setPosition(col, 120)
    .setSize(btW, btH); 

  
  //  Agent settings
  
  col = 10;
  row = 300;
  
  controlP5.addButton("INIT AGENTS")
    .setBroadcast(false)
    .setPosition(col, row)
    .setSize(btW, btH)
    .setBroadcast(true);
    
  cpTotalAgents = controlP5.addSlider("Total Agents")
    .setBroadcast(false)
    .setRange(1, 64)
    .setPosition(col, row + 20)
    .setSize(btW, btH)
    .setBroadcast(true);

  cpSpeed = controlP5.addRange("Speed")
    .setBroadcast(false)
    .setRange(2, 16)
    .setPosition(col, row + 40)
    .setSize(btW, btH)
    .setBroadcast(true);

  cpThickness = controlP5.addRange("Thickness")
    .setBroadcast(false)
    .setRange(1, 32)
    .setPosition(col, row + 60)
    .setSize(btW, btH)
    .setBroadcast(true);
    
  cpStrokeLength = controlP5.addRange("StrokeLength")
    .setBroadcast(false)
    .setRange(50, 3000)
    .setPosition(col, row + 80)
    .setSize(btW, btH)
    .setBroadcast(true);

  cpGapLength = controlP5.addRange("GapLength")
    .setBroadcast(false)
    .setRange(50, 3000)
    .setPosition(col, row + 100)
    .setSize(btW, btH)
    .setBroadcast(true);
    
  cpHue = controlP5.addSlider("Hue")
    .setBroadcast(false)
    .setRange(0, 100)
    .setValue(255)
    .setPosition(col, row + 120)
    .setSize(btW, btH)
    .setBroadcast(true);
    
  cpSat = controlP5.addSlider("Saturation")
    .setBroadcast(false)
    .setRange(0, 100)
    .setValue(255)
    .setPosition(col, row + 140)
    .setSize(btW, btH)
    .setBroadcast(true);
    
  cpBrt = controlP5.addSlider("Brightness")
    .setBroadcast(false)
    .setRange(0, 100)
    .setValue(255)
    .setPosition(col, row + 160)
    .setSize(btW, btH)
    .setBroadcast(true);
    
  cpAlphaRange = controlP5.addRange("AlphaRange")
    .setBroadcast(false)
    .setRange(1, 256)
    .setRangeValues(1, 256)
    .setPosition(col, row + 180)
    .setSize(btW, btH)
    .setBroadcast(true);
    
  controlP5.addButton("ADD POD")
    .setBroadcast(false)
    .setPosition(col, row + 200)
    .setSize(btW, btH)
    .setBroadcast(true);

  col = 600;

  controlP5.addButton("SHOW AGENTS")
    .setValue(0)
    .setPosition(col, 20)
    .setSize(btW / 2, btH * 2);

  controlP5.addButton("INVERT")
    .setBroadcast(false)
    .setValue(0)
    .setPosition(col, 60)
    .setSize(btW / 2, btH)
    .setBroadcast(true);

  controlP5.addButton("CLEAR")
    .setPosition(col, 80)
    .setSize(btW / 2, btH);

  controlP5.addButton("Pause")
    .setPosition(col, 100)
    .setSize(btW / 2, btH * 2);
}



void controlEvent(ControlEvent event) 
{
  if (event.isController()) 
  {
    
    if (event.getController().getName()=="ADD POD")
    {
      addPod();
    }
    
    if (event.getController().getName()=="Save")
    {
      saveImage();
    }

    if (event.getController().getName()=="CLEAR") 
    {
      podARL.get(podID).stopAllStrokes();
      
      drawBuffer.beginDraw();
      drawBuffer.background(bgClr);
      drawBuffer.endDraw();
    }

    if (event.getController().getName()=="Pause") 
    {
      isPause = !isPause;

      if (!isPause)
      {
        event.getController().setLabel("Pause");
        podARL.get(podID).allNewStroke();
      }
      else
      {
        event.getController().setLabel("Run");
      }
    }

    if (event.isFrom("Direction"))
    {
      float angle = event.getValue();
      gravDir = PVector.fromAngle(angle);
    }
    
    if (event.isFrom("Total Agents"))
    {
      podARL.get(podID).maxAgents = int(event.getValue());
    }

    if (event.isFrom("Speed"))
    {
       podARL.get(podID).minSpeed = int(event.getController().getArrayValue(0));
       podARL.get(podID).maxSpeed = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("Thickness"))
    {
       podARL.get(podID).minThick = int(event.getController().getArrayValue(0));
       podARL.get(podID).maxThick = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("AlphaRange"))
    {
       podARL.get(podID).minAlpha = int(event.getController().getArrayValue(0));
       podARL.get(podID).maxAlpha = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("StrokeLength"))
    {
       podARL.get(podID).minStroke = int(event.getController().getArrayValue(0));
       podARL.get(podID).maxStroke = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("GapLength"))
    {
       podARL.get(podID).minWait = int(event.getController().getArrayValue(0));
       podARL.get(podID).maxWait = int(event.getController().getArrayValue(1));
    }
    
    if (event.isFrom("Hue"))
    {
       podARL.get(podID).hue = int(event.getValue());
    }
    
    if (event.isFrom("Saturation"))
    {
       podARL.get(podID).sat = int(event.getValue());
    }
    
    if (event.isFrom("Brightness"))
    {
       podARL.get(podID).brt = int(event.getValue());
    }

    if (event.getController().getName()=="UPDATE") 
    {
      setUpCanvas();
      initFieldMatrix();
    }

    if (event.getController().getName()=="RANDOM MATRIX") 
    {
      fm.makeField();
      //fm.makeSmoothField();
      fm.drawField(fieldBuffer);
    }

    if (event.getController().getName()=="SMOOTH MATRIX") 
    {
      //fm.smoothField();
      fm.makeSmoothField();
      fm.drawField(fieldBuffer);
    }
    
    if (event.getController().getName()=="Smooth threshold") 
    {
      fm.thres = int(event.getValue());
    }
    

    if (event.getController().getName()=="INIT AGENTS") 
    {
      podARL.get(podID).initAgents();
    }

    if (event.getController().getName()=="SHOW AGENTS") 
    {
      showAgents = !showAgents;
      
      if(showAgents)
      {
        event.getController().setLabel("HIDE AGENTS");
      }
      else
      {
        event.getController().setLabel("SHOW AGENTS");
      }
      //allNewStroke();
    }

    if (event.getController().getName()=="INVERT") 
    {
      int tempClr = bgClr;
      bgClr = fgClr;
      fgClr = tempClr;

      podARL.get(podID).allNewStroke();
    }
  }
}
