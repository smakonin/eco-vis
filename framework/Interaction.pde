/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
 Interaction Inferface Class and Globals
 
 
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
 
class Interaction
{
  private LegendUI _legend;
  private PaletteUI _palSelect;

  Interaction(boolean useTouchScreen)
  {
    if(useTouchScreen)
      noCursor();

    _legend = new LegendUI(80, 100);
    _palSelect = new PaletteUI(80, 80, 200);
  }
  
  void hideUI()
  {
    _legend.hide();
    _palSelect.hide();
  }
  
  boolean isUIVisible()
  {
    return (_legend.isVisible() || _palSelect.isVisible());
  }
  
  void handleDrawUI()
  {
    _legend.draw();
    _palSelect.draw();
  }
  
  void handleKeyPress(char n)
  {
    if(n == '0' || n == '1' || n == '2' || n == '3' || n == '4' || n == '5' || n == '6')
      screenSwitch(int(str(n)));
      
    if(n == 'l')
    {
      if(_legend.isVisible())
        _legend.hide();
      else
        _legend.show();
    }
  }
  
  void handleMouseClick(int mx, int my)
  {
    if(!_legend.isVisible())
      _legend.show();
    else
    {
      int ret = -1;
      if(_legend.isVisible())
        ret = _palSelect.checkClick(mx, my);
      
      if(ret >= 0)
        screenSwitch(ret);
      else
        screenSwitch(_legend.checkClick(mx, my));
    }
  }
  
  void handleMouseWheel(int delta) 
  {
    canvas.zoom(delta);
  }
  
  private void screenSwitch(int n)
  {
    if(BE_VERBOSE)
    {
      print("interaction=");
      println(n);
    }

    switch(n)
    {
      case -1:
        hideUI();
        break;      
      
      case 0:
        break;
        
      case 100:
        canvas.enableAA();
        hideUI();
        break;
      
      case 101:
      case 102:
      case 103:
      case 104:
      case 105:
      case 106:
      case 107:
      case 108:
      case 109:
        canvas.enableAH(n-100);
        hideUI();
        break;
        
      case 190:
        if(_palSelect.isVisible())
          _palSelect.hide();
        else
          _palSelect.show();
        break;
        
      case 191:
        hideUI();
        exit();
        break;
        
      case 201:
          hideUI();
          break;
        
      default:
        if(BE_VERBOSE)
          println("--unhandled--");
        break;
    }
  }  
}

