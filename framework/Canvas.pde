/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
 Canvas Base Class and Globals
 
 
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

class Canvas
{
  protected PGraphics _offscreen;
  protected Palette _palette;
  private boolean _useBackBuffer;

  Canvas(boolean useBackBuffer, Palette palette)
  {
    _useBackBuffer = useBackBuffer;
    _offscreen = null;
    
    _palette = palette;    

    if(_useBackBuffer)
      _offscreen = createGraphics(width, height, P2D);
  }

  void update(boolean cls) 
  {
    if(_useBackBuffer)
    {
      _offscreen.beginDraw();
      if(cls)
        _offscreen.background(_palette.getBgColour());
    }
    else
    {
      if(cls)
        background(_palette.getBgColour());
    }
  }

  void show()
  {
    if(_useBackBuffer)
    {
      _offscreen.endDraw();
      image(_offscreen, 0, 0);   
    }
  }
  
  void setPalette(Palette palette)
  {
    _palette = palette;    
  }
  
  Palette getPalette()
  {
    return _palette;    
  }
}

