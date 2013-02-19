/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
 Ambient Display Class and Globals
 
 
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

import processing.opengl.*;

class AmbientDisplay
{
  private float _invWidth;
  private float _invHeight;
  private float _aspectRatio;
  private float _aspectRatio2;
  private int _fps;
  private PFont _titleFont;
  private PFont _subtitleFont;
  private boolean _useOpenGL;
  private boolean _showTitle;

  AmbientDisplay(boolean fullscr, boolean ogl, color bgcolour, int fps, String title, String subtitle)
  {
    if(BE_VERBOSE)
    {
      print("Screen size = ");
      print(screen.width);
      print("x");
      println(screen.height);    
    }
    
    _fps = fps;
    _useOpenGL = ogl;
    _showTitle = false;
    
    int w = screen.width;
    int h = screen.height;
    if(!fullscr)
    {
      w = (int)(screen.width * 0.80);
      h = (int)(screen.height * 0.80);
    }
    
    if(_useOpenGL)
    {
      size(w, h, OPENGL);
      hint(ENABLE_OPENGL_4X_SMOOTH);
    }
    else
    {  
      size(w, h, P2D);      
    }
      
    frameRate(_fps);
    background(bgcolour);
    
    _titleFont = null;
    if(title != "")  
      _titleFont = loadFont(title);

    _subtitleFont = null;
    if(subtitle != "")  
      _subtitleFont = loadFont(subtitle);
    
    if(_useOpenGL)
      textMode(MODEL);
    else
      textMode(SCREEN);
    textAlign(CENTER, CENTER);

    _invWidth = 1.0f / width;
    _invHeight = 1.0f / height;
    _aspectRatio = width * _invHeight;
    _aspectRatio2 = _aspectRatio * _aspectRatio;  
  }
  
  void showTitle(String line1, String line2)
  {
    if(_titleFont != null)  
    {
      textFont(_titleFont);
      text(line1, width/2, height*0.4);  
    }
    
    if(_subtitleFont != null)  
    {
      textFont(_subtitleFont);
      text(line2, width/2, height*0.55);  
    }
    
    _showTitle = true;
  }

  void titleDelay()
  {
    while(cdata == null || _showTitle)
    {
      delay(2000);
      _showTitle = false;
    }
  }
  
  float getInvWidth()
  {
    return _invWidth;
  }
  
  float getInvHeight()
  {
    return _invHeight;
  }
  
  float getAspectRatio()
  {
    return _aspectRatio;
  }
  
  float getAspectRatio2()
  {
    return _aspectRatio2;
  }

  boolean isOpenGLUsed()
  {
    return _useOpenGL;
  }
}

