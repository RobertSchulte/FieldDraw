class FieldMatrix {
  PVector [][] field;
  int row, col, offset;
  PGraphics fieldBuffer;
  int wd, ht, blockSize;
  boolean visible;
  float thres = 3;
  
  FieldMatrix(int _wd, int _ht, int _col) 
  {
    visible = true;
    
    wd = _wd;
    ht = _ht;

    col = _col;
    
    blockSize = wd / col;
    
    row = ht / blockSize;
    
    offset = blockSize / 2;
    
    field = new PVector[col][row];
    
    makeField();
  }
  
  void makeField(){
    for (int posX = 0; posX < col; posX++)
    {
      for(int posY = 0; posY < row; posY++)
      {
        field[posX][posY] = PVector.random2D();
      }
    }
  }
  
  void makeSmoothField()
  {
    PVector [][] tempField;
  
    tempField = new PVector[col][row];

    int max = col * row;
    
    for(int f = 0; f < max; f++)
    {
      int x1 = ( f % col );
      int y1 = ( f - x1 ) / col;
      
      PVector pv1 = new PVector(x1, y1);
      PVector avg = new PVector();
      
      int count = 0;
          
      for(int j = 0; j < max; j++)
      {
        if(j != f)
        {
          int x2 = ( j % col );
          int y2 = ( j - x2 ) / col;
          
          PVector pv2 = new PVector(x2, y2);
          
          float dist = PVector.dist(pv1, pv2);
          
          if(dist < thres)
          {
            avg.add(field[x2][y2]);
            count++;
          }
        }
      }
      
      tempField[x1][y1] = avg.div(count);
    }
    
    arrayCopy(tempField, field);
  }
  
  void drawField(PGraphics fb)
  {
    fb.beginDraw();
    fb.background(0, 0);
    
    fb.noStroke();
    fb.fill(0, 128);
    fb.rect(0, 0, wd, ht);
    
    fb.noFill();
    fb.stroke(255, 192);

    for (int posX = 0; posX < col; posX++)
    {
      for(int posY = 0; posY < row; posY++)
      {
        fb.pushMatrix();
        fb.translate(posX * blockSize + offset, posY * blockSize + offset);
        fb.rotate(field[posX][posY].heading());
        
        //fb.stroke(255, 128);
    
        fb.ellipse(0, 0, blockSize, blockSize);
        fb.line(0, 0, offset, 0);
        fb.popMatrix();
      }
    }
    
    fb.endDraw();    
  }
  
  void smoothField()
  {
    PVector [][] tempField;

    tempField = new PVector[col][row];
    arrayCopy(field, tempField);
    
    for (int posX = 1; posX < col - 1; posX++)
    {
      for(int posY = 1; posY < row - 1; posY++)
      {
        PVector avg = new PVector();
        avg.add(field[posX - 1][posY - 1]);
        avg.add(field[posX][posY - 1]);
        avg.add(field[posX + 1][posY - 1]);
        avg.add(field[posX + 1][posY]);
        avg.add(field[posX + 1][posY + 1]);
        avg.add(field[posX][posY + 1]);
        avg.add(field[posX - 1][posY + 1]);
        avg.add(field[posX - 1][posY]);

        tempField[posX][posY] = avg.div(8);
      }
    }
    
    arrayCopy(tempField, field);
  }

  
  PVector getValByRowCol(PVector pos) 
  {
    int c = int(constrain((pos.x * scale) / blockSize, 0, col - 1));
    int r = int(constrain((pos.y * scale) / blockSize, 0, row - 1));
    
    return field[c][r];
  }
  
}
