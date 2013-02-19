/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
 Palette Inferface Class and Globals
 
 
/***********************************************************************
 * Copyright (C) 2011, Stephen Makonin. All rights reserved.
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

final int PALETTE_COUNT = 2;
final int COLOUR_MODE_RGBA256 = 0;
final int COLOUR_MODE_HSB3601 = 1;
 
class Palette
{
  private String _name;
  private int _colourMode;
  private color _bgcolour;
  private color[] _colours;
  
  Palette(String name, int colourMode, String bgcolour, String colours)
  {
    _name = name;
    
    _colourMode = colourMode;
    setColourMode();
    
    String[] arr = split(bgcolour, ",");    
    _bgcolour = color(int(trim(arr[0])), int(trim(arr[1])), int(trim(arr[2])));
    
    arr = split(colours, ",");
    int dim = arr.length / 3;
    _colours = new color[dim];
    for(int i = 0, j = 0; j < dim; i += 3, j++)
      _colours[j] = color(int(trim(arr[i])), int(trim(arr[i+1])), int(trim(arr[i+2])));
  }

  String getName()
  {
    return _name;
  }

  color getBgColour()
  {
    return _bgcolour;
  }  

  color getColour(int idx)
  {
    return _colours[idx];
  }  
  
  int getIndex(color pixel)
  {
    for(int i = 0; i < _colours.length; i++)
    {
      if(red(_colours[i]) == red(pixel) && green(_colours[i]) == green(pixel) && blue(_colours[i]) == blue(pixel))
        return i;
    }
    
    return -1;
  }

  int getSize()
  {
    return _colours.length;
  }
  
  void setColourMode()
  {
    switch(_colourMode)
    {
      case COLOUR_MODE_RGBA256:
        colorMode(RGB, 256, 256, 256, 256);
        break;
      
      case COLOUR_MODE_HSB3601:
        colorMode(HSB, 360, 1, 1, 1);
        break;
    }
  }
}

class AutumnLeavesPalette extends Palette
{
  AutumnLeavesPalette()
  {
    // "82, 52, 12" or "41, 26, 6" or "20, 10, 0" for bg ....? :-(
    super("Autumn", COLOUR_MODE_RGBA256, "20, 10, 3", "64, 80, 96, 64, 64, 0, 117, 48, 0, 80, 16, 0, 192, 112, 0, 32, 80, 32, 176, 48, 0, 0, 0, 0");
  }
}

class SpringTimePalette extends Palette
{
  SpringTimePalette()
  {
    super("Spring", COLOUR_MODE_RGBA256, "248,233,226", "177,160,165, 225,76,104, 235,206,123, 153,190,196, 182,143,187, 237,142,120, 196,228,165, 0,0,0");
    //super("Spring", COLOUR_MODE_RGBA256, "124,116,113", "177,160,165, 225,76,104, 235,206,123, 153,190,196, 182,143,187, 237,142,120, 196,228,165, 0,0,0");
    //super("Spring", COLOUR_MODE_RGBA256, "128,128,128", "177,160,165, 225,76,104, 235,206,123, 153,190,196, 182,143,187, 237,142,120, 196,228,165, 0,0,0");
  }
}

class PaletteUI extends UserInferface
{
  private int _bw;
  private int _bh;
  private int _cwheel;
  
  PaletteUI(int w, int h, int interactionID)
  {
    super((width - w * 10) / 2 - 20, 40, w * 10 + 40, 20 * (PALETTE_COUNT + 1) + h * PALETTE_COUNT + 30 * 2 + 640, interactionID);
    _bw = w;
    _bh = h;
    _cwheel = 550;
  }

  private Palette getPalette(int id)
  {
    Palette p;

    switch(id)
    {
      case 0:
        p = new AutumnLeavesPalette();
        break;

      case 1:
        p = new SpringTimePalette();
        break;
        
      default:
        p = null;
        break;
    }

    return p;
  }
  
  private void makeColourWheel(int x, int y, float r)
  {
    int segs = 360;
    int steps = 36;
    float radius = r;
    float rotAdjust = TWO_PI / segs / 2;
    float segWidth = r / steps;
    float interval = TWO_PI / segs;

    ellipseMode(RADIUS);
    noStroke();
    colorMode(HSB, segs, 1, 1, 1);
    
    for (int j = -(steps/2)-1; j <= steps/2; j++) 
    {
      for (int i = 0; i < segs; i++) 
      {
        color c;
        
        /*if(j < 0)
          c = color(i, steps + j, steps, 1);
        else if(j > 0)     
          c = color(i, steps, steps - j, 1);
        else*/
          c = color(i, 1, 1, 1);
        
        stroke(c);
        fill(c);
        arc(width/2, height/2, r, r, interval*i+rotAdjust, interval*(i+1)+rotAdjust);
      }
      radius -= segWidth;
    }
  }

  private void makeColourBar(int x, int y, int w, int h)
  {
    noStroke();
    colorMode(HSB, 360);
     
    for(int i = 0; i < 360; i++)
    {
      color c = color(i,360,360,360);
      fill(c);
      rect(x + i, y, 1, h); 
    }
  }
  
  boolean draw()
  {
    if(!super.draw())
      return false;
      
    printText("Select the colour palette you want:", _x + 20, _y + 25);  

    for(int i = 0; i < PALETTE_COUNT; i++)
    {
      Palette p = getPalette(i);

      if(p == null)
        return false;
    
      int pw = _bw * (p.getSize() + 2);
      int ph = _bh;
      int px = _x + (_w - pw) / 2;
      int py = _y + 20 * (i + 1) + _bh * i + 30;
      
      smooth();
      rectMode(CORNER);
      stroke(255);
      strokeWeight(2);
      fill(255);
      rect(px-1, py-1, pw+2, ph+2);
      
      for(int j = 0; j < p.getSize(); j++)
      {
        noStroke();
        fill(p.getColour(j));
        int x = px + j * _bw;
        int y = py;
        rect(x , y, _bw, _bh);
      }
      
      fill(p.getBgColour());
      rect(px + pw - _bw * 2 + 1, py, _bw * 2 - 1, _bh);
      
      printText(p.getName(), px + 5, py + _bh / 2);
    }
    
    ///printText("Or create a custom colour palette:", _x + 20, _y + 20 * (PALETTE_COUNT + 1) + _bh * PALETTE_COUNT + 35);  
    //makeColourWheel(_x + _w / 2, _y + 20 * (PALETTE_COUNT + 1) + _bh * PALETTE_COUNT + 50, _cwheel / 2);
    ///Palette p = getPalette(0);
    ///makeColourBar(_x + (_w - _bw * (p.getSize() + 2)) / 2, _y + 20 * (PALETTE_COUNT + 1) + _bh * PALETTE_COUNT + 35, _bw * (p.getSize() + 2), _bh);
    
    noStroke();
    return true;
  }
  
  int checkClick(int mx, int my)
  {
    for(int i = 0; i < PALETTE_COUNT; i++)
    {
      Palette p = getPalette(i);

      if(p == null)
        return 0;

      int pw = _bw * (p.getSize() + 2);
      int ph = _bh;
      int px = _x + (_w - pw) / 2;
      int py = _y + 20 * (i + 1) + _bh * i + 30;
    
      if(mx >= px && mx <= px + pw && my >= py && my <= py + ph)
      {
        canvas.setPalette(p);
        return _interactionID + 1;
      }
    }
    
    return super.checkClick(mx, my);      
  }
}

