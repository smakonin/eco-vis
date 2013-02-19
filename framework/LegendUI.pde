/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
 Legend User Inferface Class and Globals
 
 
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
 
class LegendUI extends UserInferface
{
  private int _r;
  private int _a;
  private PImage _iconPalette;
  private PImage _iconExit;
  
  LegendUI(int r, int interactionID)
  {
    super(0, height - r * 2, width, r * 2, interactionID);
    
    _r = r;
    _a = 0;

    _iconPalette = loadImage("palette-icon.png");
    _iconExit = loadImage("exit-icon.png");    
  }
  
  boolean draw()
  {
    if(!super.draw())
      return false;

    for(int i = 0; i < cdata.getDeviceCount(); i++)
    {
      ellipseMode(CENTER);
      smooth();
      stroke(255);
      strokeWeight(2);
      fill(canvas.getPalette().getColour(i));
      int sp = (_w - (40 + 10) * 2) / (cdata.getDeviceCount() + 1);
      int x = sp * i + _r / 2 + 10;
      int y = _y + _r;
      ellipse(x , y, _r, _r);
      
      printText(cdata.getDevice(i)._descr, x + _r / 2 + 5, y);  
    }
    
    image(_iconPalette, _w - 10 * 2 - _r * 2, _y + _r / 2);    
    image(_iconExit, _w - 10 - _r, _y + _r / 2);
    
    noStroke();
    return true;
  }
  
  int checkClick(int mx, int my)
  {
    for(int i = 0; i < cdata.getDeviceCount(); i++)
    {
      int sp = (_w - (40 + 10) * 2) / (cdata.getDeviceCount() + 1);
      int x = sp * i + _r / 2 + 10;
      int y = _y + _r;

      if(dist(mx, my, x, y) <= _r)
      {
        _a = i;
        return _interactionID + i;
      }
    }
      
    // the 1st other icon (left most icon)
    if(dist(mx, my, _w - 10 * 2 - _r * 1.5 , _y + _r) <= _r / 2)
      return _interactionID + 90;
    
    // the 2nd other icon
    int x = _w - 10 - _r;
    int y = _y + _r / 2;
    if(mx >= x && mx <= x + _r && my >= y && my <= y + _r)
      return _interactionID + 91;

    return super.checkClick(mx, my);
  }
}

