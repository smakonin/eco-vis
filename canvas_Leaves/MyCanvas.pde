/***********************************************************************
 
 Leaves of Consumtion (canvas_Leaves)
 
 MyCanvas Class and Globals
 
 
/***********************************************************************
 * Copyright (C) 2011, Stephen Makonin and Maryam H Kashani. All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of MSA Visuals nor the names of its contributors 
 *       may be used to endorse or promote products derived from this software
 *       without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, 
 * THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS 
 * OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
 * OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE 
 * OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED
 * OF THE POSSIBILITY OF SUCH DAMAGE. 
 *
 * ***********************************************************************/
 
 /***********************************************************************
 * ADDITIONAL NOTES:
 *
 * Parts of the bolow code have be taken from:
 *
 * Fall leaves project
 * version 1.0, Andrew, 16 April 2009
 * 
 * Processing for Visual Artists: How to Create Expressive Images and Interactive Art
 * Andrew S. Glassner.
 * Published August 2010, A K Peters. Paperback.
 *
 * ***********************************************************************/


class MyCanvas extends Canvas
{
  private int _a;
  private int _i;
  private int _j;
  private int _k;
  private boolean _redraw; 
  
  MyCanvas(boolean useBackBuffer)
  {
    super(useBackBuffer, new AutumnLeavesPalette()); 
    
    _a = 0;
    reset();
    _redraw = false;
  }

  void update() 
  {
    if(_i == 0 && _j == 0 && _k == 0)
    {
      super.update(true);
      interaction.hideUI();
      cdata.sortDeviceByReading(_i);
    }

    _palette.setColourMode();              
    noStroke();
    strokeWeight(1);

    int amt = 0;
    if(_a == 0)
      amt = updateAA();
    else
      amt = updateAH();    

    _k++;
    
    if(_k >= amt)
    {
      _k = 0;
      _j++;

      if(_j < cdata.getDeviceCount())
        cdata.sortDeviceByReading(_i);        
    }
    
    if(_j >= cdata.getDeviceCount())
    {      
      _j = 0;
      _i++;  
    }
       
    if(_i >= cdata.getReadingsCount())
    {
      _i = 0;
      cdata.setStale();
      _redraw = false;
    }
  }

  int updateAA()
  {
    if(_j == 0)
      return 0;
      
    int d = cdata.getSortedDeviceID(_j);
    int amt = int(cdata.getReading(d, _i) / 100.0 + 1.0);

    if(random(1000) > 300)
      drawOneLeaf(true, _palette.getColour(d));
    else 
      drawOneLeaf(false, _palette.getColour(d)); 
      
    return amt;
  }

  int updateAH()
  {
    if(_j != 0 && _j != _a)
      return 0;

    int tl = 20;
    float r = cdata.getReading(_a, _i) / cdata.getReading(0, _i);
    int amt = ceil(tl * r);
    
    if(_j == 0)
      amt = tl - amt;

    drawOneLeaf(true, _palette.getColour(_j));

    return amt;    
  }

  void show()
  {
    super.show();
  }
  
  void reset()
  {
    _i = 0;
    _j = 0;
    _k = 0;
  }
    
  void zoom(int delta)
  {
  }

  void enableAA()
  {
    if(_a == 0)
      return;
      
    _a = 0;
    _redraw = true;
    reset();
  }
  
  void enableAH(int a)
  {
    if(_a == a)
      return;
      
    _a = a;
    _redraw = true;
    reset();
  }
  
  boolean isForceRedraw()
  {
    return _redraw;
  }

  void setPalette(Palette palette)
  {
    /*
    Palette oldpal = _palette;
    
    loadPixels();
    for(int i = 0; i < width*height; i++)
    {
      int index = oldpal.getIndex(pixels[i]);
      if(index > 0)
      {
        float af = alpha(pixels[i]);
        color c = palette.getColour(index);
        pixels[i] = color(red(c), green(c), blue(c), 255*af);
      }
    }
    updatePixels();
    */
    _palette = palette;
    _redraw = true;
  }

  private PVector pointToWindow(PVector p) 
  {
    PVector t = p.get();
    t.x = map(t.x, -1, 1, 0, width-1);
    t.y = map(t.y, -1, 1, 0, height-1);
    return(t);
  }

  private PVector makeControlPoint(float x, float dxlo, float dxhi, float y, float dylo, float dyhi) 
  {
    float px = x + random(dxlo, dxhi);
    float py = y + random(dylo, dyhi);
    PVector t = new PVector(px, py);
    return(t);
  }

  private  void drawOneLeaf(boolean drawInside, color leafColor) 
  {
    PVector pG1 = makeControlPoint(-0.25, -0.15,  0.15, -0.05, -0.15, 0.0);
    PVector pG2 = makeControlPoint( 0.25, -0.15,  0.15, -0.05, -0.15, 0.0);
    PVector pH1 = makeControlPoint(-0.25, -0.15,  0.15,  0.05,  0.0, 0.15);
    PVector pH2 = makeControlPoint( 0.25, -0.15,  0.15,  0.05,  0.0, 0.15);
   
    // move the H control points so that the leaf bends
    float yMove = random(0, 0.35);
    if(random(100) > 80) 
    {
      yMove = -yMove;
    }
    pG2.y += yMove;
    pH2.y += yMove;
  
    fill(leafColor);
  
    translate(width/2, height/2);
   
    PVector pA;
    PVector pB;
    float xTrans;
    float yTrans;
    float scaleFactor;    
    float rotationAngle;
    if(_a == 0)
    {
      pA = new PVector(-0.5, 0.0);  // left end
      pB = new PVector( 0.5, 0.0);  // right end
      xTrans = random(-width/2, width/2);
      yTrans = random(-height/2, height/2);
      scaleFactor = random(0.6, 1.0);
      rotationAngle = random(0, 360);
    }
    else
    { //6x4
      xTrans = (-width/2) + (_i%6 + 1) * (width/7);
      yTrans = (-height/2) + (_i/6 + 1)  * (height/4) - 36;
      float nval = noise(xTrans, yTrans);
      scaleFactor = 0.8;//0.6 + (_i * 0.025);
      if(_j == 0)
      {
        pA = new PVector(-0.5, 0.0);  // left end
        pB = new PVector( 0.5, 0.0);  // right end
        xTrans -= random(-36, 36);
        yTrans -= random(-5, 10);      
        rotationAngle = random(-30, 30);    
      }
      else
      {
        pA = new PVector(-1.0, 0.0);  // left end
        pB = new PVector( 0.0, 0.0);  // right end
        rotationAngle = random(60, 120);    
      }
    }
    translate(xTrans, yTrans);
    scale(scaleFactor*width/8);
    rotate(radians(rotationAngle));
  
    if(drawInside) 
    {
      for (int d=0; d<1000; d++) 
      {
        float t = random(0.0, 1.0);
        t += .07 * sin(TWO_PI*t);
        float px = lerp(pA.x, pB.x, t);
        float uy = bezierPoint(pA.y, pG1.y, pG2.y, pB.y, t);
        float ly = bezierPoint(pA.y, pH1.y, pH2.y, pB.y, t);
        float a = random(0.0, 1.0);
        float py = lerp(uy, ly, a);
        float myAlpha = map(abs(.5-a), 0, .5, 255, 0);
        stroke(leafColor, myAlpha);
        point(px, py);
      }
    } 
    else
    {
      for(int d=0; d<10000; d++) 
      {
        float tbump = 0.3;
        float aura = 0.5;
        float t = random(-tbump, 1+tbump);
        float px = lerp(pA.x, pB.x, t); // can't use bezierPoint because they curl up
        float py, dir;
        if(random(1000) > 500) 
        {
          dir = -1;
          py = bezierPoint(pA.y, pG1.y, pG2.y, pB.y, t);
        } 
        else 
        {
          dir = 1;
          py = bezierPoint(pA.y, pH1.y, pH2.y, pB.y, t);
        }
  
        // add fading to the sides
        float tfade = 1.0;
        if(t < 0) 
        {
          tfade = 1-(abs(t)/tbump);
          py = pA.y;
        }
        else if(t > 1) 
        {
          tfade = 1-((t-1)/tbump);
          py = pB.y;
        }
  
        float auraD = random(aura);
        float aurafade = 1-(auraD/aura);
        aurafade *= tfade;
        aurafade = map(cos(PI * aurafade), 1, -1, 0, 1);
        py += dir * auraD;
        stroke(leafColor, 255*aurafade);
        point(px, py);
      }
    }
  }
}

