//  The Pod class organizes groups of agents 
class Pod {

  int maxAgents;
  Agents [] agentAR;
  
  float minSpeed, maxSpeed;
  float minStroke, maxStroke;
  
  float minWait, maxWait;
  float minThick, maxThick;
  
  int minAlpha, maxAlpha;
  
  int hue, sat, brt, alp;
  
  int PID;
  
  Pod()
  {
    maxAgents = 8;
    
    minSpeed = 4;
    maxSpeed = 12;
    
    minThick = 1;
    maxThick = 16;
    
    minAlpha = 196;
    maxAlpha = 255;
  
    minStroke = 50; 
    maxStroke = 3000;
    
    minWait = 50;
    maxWait = 3000; 
  }
  
  void setPodID(int id)
  {
    PID = id;
  }
  
  // set the pod gui
  void setGUI()
  {
    cpTotalAgents.setValue(maxAgents);
    cpSpeed.setRangeValues(minSpeed, maxSpeed);
    cpThickness.setRangeValues(minThick, maxThick);
    cpAlphaRange.setRangeValues(minAlpha, maxAlpha);
    cpStrokeLength.setRangeValues(minStroke, maxStroke);
    cpGapLength.setRangeValues(minWait, maxWait);
    cpHue.setValue(hue);
    cpSat.setValue(sat);
    cpBrt.setValue(brt);
  }
  
  
  void initAgents()
  {
    agentAR = new Agents[maxAgents];
  
    for (int f = 0; f < maxAgents; f++)
    {
      agentAR[f] = new Agents(PID, new PVector(random(canvasWD), random(canvasHT)) );
    }
  }
  
  void allNewStroke()
  {
    for (int f = 0; f < maxAgents; f++)
    {
      agentAR[f].newStroke();
    }
  }
  
  void stopAllStrokes()
  {
    for (int f = 0; f < maxAgents; f++)
    {
      agentAR[f].isDrawing = false;
    }
  }
  
  void update()
  {
    for (int f = 0; f < agentAR.length; f++)
    {
      agentAR[f].goWithTheFlow();
  
      if (showAgents)
      {
        agentAR[f].drawPos(agentBuffer);
      } 
  
      if (agentAR[f].isDrawing)
      {
        agentAR[f].drawUpdate(drawBuffer);
      }
    }
  }
}
