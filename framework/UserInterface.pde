/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
 User Inferface Base Class and Globals
 
 
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
 
class UserInferface
{
  protected int _x; 
  protected int _y; 
  protected int _w; 
  protected int _h; 
  protected int _interactionID;
  private boolean _isVisible;
  private PFont _bodyFont;  
  private PImage _before;
  
  UserInferface(int x, int y, int w, int h, int interactionID)
  {
    _x = x;
    _y = y;
    _w = w;
    _h = h;
    _interactionID = interactionID;
    _before = null;
    _isVisible = false;
    _bodyFont = loadFont("SansSerif-28.vlw");
  }
  
  boolean isVisible()
  {
    return _isVisible;
  }
  
  void show()
  {
    _isVisible = true;
  }

  void hide()
  {
    _isVisible = false;
    if(_before != null)
      set(_x, _y, _before);
    _before = null;
  }
  
  void printText(String t, int x, int y)
  {
    textMode(SCREEN);
    textAlign(LEFT, CENTER);
    textFont(_bodyFont);
    fill(255);
    text(t, x, y);  
  }
  
  boolean draw()
  {
    if(!_isVisible || _before != null)
      return false;
      
    _before = get(_x, _y, _w, _h);
    
    colorMode(RGB, 256, 256, 256, 256);
    noStroke();
    smooth();
    fill(0, 0, 0, 128);
    rect(_x, _y, _w, _h);

    return true;
  }
  
  int checkClick(int mx, int my)
  {
    // the transpatent panek
    if(mx >= _x && mx <= _x + _w && my >= _y && my <= _y + _h)
      return 0;
      
    return -1;
  }  
}

