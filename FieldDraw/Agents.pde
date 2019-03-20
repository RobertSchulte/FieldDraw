//  The Drawing Agent class
class Agents {
  PVector pos;
  PVector lastpos;
  PVector dir;
  PVector lastdir;
  float speed;
  float thickness, lastThickness, maxWidth, strokeTime;
  float alp;
  float startTime, duration;
  boolean isDrawing = false; 
  PVector grav;
  
  Agents(PVector _pos, float minSpeed, float maxSpeed, float minThick, float maxThick, int minAlpha, int maxAlpha)
  {
    pos = _pos;
    
    lastpos = new PVector();
    lastdir = new PVector();

    dir = PVector.random2D();
   // dir = fm.getValByRowCol(pos); very odd agent behavior
    
    speed = random(minSpeed, maxSpeed);
    maxWidth = random(minThick, maxThick);

    grav = new PVector();
    
    alp = random(minAlpha, maxAlpha);
  }
  
  void goWithTheFlow()
  {
    lastpos.x = pos.x;
    lastpos.y = pos.y;
    
    lastdir.x = dir.x;
    lastdir.y = dir.y;

    dir.add(gravDir.setMag(gravForce));
    
    PVector mVec = fm.getValByRowCol(pos);

    dir.add(mVec.setMag(friction));
    
    dir.setMag(speed);

    pos.add(dir);
    
    wrapAround();
    
    if(!isDrawing)
    {
      if(checkTime())
      {
        newStroke();
      }
    }
  }
  
  void newStroke()
  {
    isDrawing = true;
    startTime = millis();
    thickness = 1;
    lastThickness = thickness;
    
    lastpos.x = pos.x;
    lastpos.y = pos.y;
    
    lastdir.x = dir.x;
    lastdir.y = dir.y;
    
    duration = Math.round(random(2000)) + 500;
  }
  
  boolean checkTime() 
  {
    float elapsed = (millis() - startTime);
    //int seconds = (elapsed / 1000) % 60;
    
    boolean timesUp = false;

    if(elapsed >= duration)
    {
      timesUp = true;
    }
  
    return timesUp;
  }

  void drawUpdate(PGraphics db)
  {
    float elapsed = (millis() - startTime);
    
    if(elapsed < 250)
    {
      thickness = easeOutQuad(elapsed, 1, maxWidth, 250);
    }
    
    if(elapsed > duration - 250)
    {
      thickness = easeInQuad(elapsed - (duration - 250) , maxWidth,  -(maxWidth - 1), 250);
    }
    
    PVector p1, p2, p3, p4;
    PVector r1, r2;
    
    r1 = dir.copy();
    r2 = lastdir.copy();
    
    r1.rotate(HALF_PI);
    p1 = PVector.add(pos, r1.setMag(thickness));
    
    r2.rotate(HALF_PI);
    p2 = PVector.add(lastpos, r2.setMag(lastThickness));
    
    r2.rotate(PI);
    p3 = PVector.add(lastpos, r2.setMag(lastThickness));
    
    r1.rotate(PI);
    p4 = PVector.add(pos, r1.setMag(thickness));
    
    db.stroke(fgClr, alp);
    db.strokeWeight(1.5);
    db.fill(fgClr, alp);
    //db.noStroke();

    db.beginShape();
    db.vertex(p1.x, p1.y);
    db.vertex(p2.x, p2.y);
    db.vertex(p3.x, p3.y);
    db.vertex(p4.x, p4.y);
    db.endShape(CLOSE);
    
    lastThickness = thickness;
    
    if(checkTime())
    {
      isDrawing = false;
      startTime = millis();
      duration = Math.round(random(2000)) + 500;
      
      if(isPause)
      {
        duration = 60000;
      }
    }

    //db.line(lastpos.x, lastpos.y, pos.x, pos.y);
  } 

  // Wrap around
  void wrapAround() {
    if (pos.x < 0 - thickness) 
    {
      pos.x = canvasWD;
      lastpos.x = pos.x;
    }
    
    if (pos.y < 0 - thickness) 
    {
      pos.y = canvasHT;
      lastpos.y = pos.y;
    }
    
    if (pos.x > canvasWD + thickness) 
    {
      pos.x = 0;
      lastpos.x = pos.x;
    }
    
    if (pos.y > canvasHT + thickness)
    {
      pos.y = 0;
      lastpos.y = pos.y;
    }
  }
  
  //   t = time, b = startvalue, c = change in value, d = duration
  float easeInQuad(float t, float b, float c, float d) 
  {
    t /= d;
    return c * t * t + b;
  }
  
  float easeOutQuad(float t, float b, float c, float d) 
  {
    t /= d;
    return -c * t * (t - 2) + b;
  }
  
  float easeLinear(float t, float b, float c, float d)
  {
    t /= d;
    return c * t + b;
  }
  
  
}
