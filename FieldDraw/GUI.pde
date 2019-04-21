void initGUI()
{
  int btW = 120, btH = 16;
  int col = 20;

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

  col = 400;

  controlP5.addSlider("maxAgents")
    .setRange(1, 512)
    .setValue(maxAgents)
    .setPosition(col, 20)
    .setSize(btW, btH);

  controlP5.addButton("INIT AGENTS")
    .setValue(1)
    .setPosition(col, 40)
    .setSize(btW, btH);

  controlP5.addRange("Speed")
    .setRange(minSpeed, maxSpeed)
    .setRangeValues(minSpeed, maxSpeed)
    .setPosition(col, 60)
    .setSize(btW, btH);

  controlP5.addRange("Thickness")
    .setRange(minThick, maxThick)
    .setRangeValues(minThick, maxThick)
    .setPosition(col, 80)
    .setSize(btW, btH);

  controlP5.addRange("AlphaRange")
    .setBroadcast(false)
    .setRange(minAlpha, maxAlpha)
    .setRangeValues(minAlpha, maxAlpha)
    .setPosition(col, 100)
    .setSize(btW, btH)
    .setBroadcast(true);

  controlP5.addRange("StrokeLength")
    .setBroadcast(false)
    .setRange(minStroke, maxStroke)
    .setRangeValues(minStroke, maxStroke)
    .setPosition(col, 120)
    .setSize(btW, btH)
    .setBroadcast(true);

  controlP5.addRange("GapLength")
    .setBroadcast(false)
    .setRange(minWait, maxWait)
    .setRangeValues(minWait, maxWait)
    .setPosition(col, 140)
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
    if (event.getController().getName()=="Save")
    {
      saveImage();
    }

    if (event.getController().getName()=="CLEAR") 
    {
      stopAllStrokes();
      
      drawBuffer.beginDraw();
      drawBuffer.background(bgClr);
      drawBuffer.endDraw();
      
      //if(!showAgents)
      //{
        //allNewStroke();
     // }
    }

    if (event.getController().getName()=="Pause") 
    {
      isPause = !isPause;

      if (!isPause)
      {
        event.getController().setLabel("Pause");
        allNewStroke();
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

    if (event.isFrom("Speed"))
    {
      minSpeed = int(event.getController().getArrayValue(0));
      maxSpeed = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("Thickness"))
    {
      minThick = int(event.getController().getArrayValue(0));
      maxThick = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("AlphaRange"))
    {
      minAlpha = int(event.getController().getArrayValue(0));
      maxAlpha = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("StrokeLength"))
    {
      minStroke = int(event.getController().getArrayValue(0));
      maxStroke = int(event.getController().getArrayValue(1));
    }

    if (event.isFrom("GapLength"))
    {
      minWait = int(event.getController().getArrayValue(0));
      maxWait = int(event.getController().getArrayValue(1));
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

    if (event.getController().getName()=="INIT AGENTS") 
    {
      initAgents();
      //fm.drawField(fieldBuffer);
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

      allNewStroke();
    }
  }
}
