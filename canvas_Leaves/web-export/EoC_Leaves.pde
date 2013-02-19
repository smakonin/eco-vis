/***********************************************************************
 
 Leaves of Consumtion (EoC_Leaves)
 
 Main program
 
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

// PROJECT VARIABLES
final String PROJECT_NAME = "Leaves of Consumption";
final String COPYRIGHT = "Copyright © 2011 Stephen Makonin and Maryam H Kashani";
final static String PROJECT_FILENAME = "EoC_Leaves";

final static boolean BE_VERBOSE = true;
final static boolean USE_TOUCH_SCREEN = false;
final static boolean USE_FULL_SCREEN = true;

// GLOBAL OBJETCTS AND STATE
AmbientDisplay display;
ConsumptionData cdata;
WebService ws;
MyCanvas canvas;
Interaction interaction;

void setup() 
{
  display = new AmbientDisplay(USE_FULL_SCREEN, false, 0, 60, "SavoyeLetPlain-128.vlw", "LiberationSans-18.vlw");
  display.showTitle(PROJECT_NAME, COPYRIGHT);
  
  cdata = null;
  ws = new WebService("http://makonin.com/restful/ecovis.last24hrs.py", 15, false);
  ws.start();

  canvas = new MyCanvas(false);
  interaction = new Interaction(USE_TOUCH_SCREEN);
}

void draw()
{
  display.titleDelay();
    
  if(!interaction.isUIVisible() && (cdata.isNew() || canvas.isForceRedraw()))
  {
    canvas.update();
    canvas.show();
  }

  interaction.handleDrawUI();
}

void keyPressed() 
{
  interaction.handleKeyPress(key);
}

void mousePressed()
{
  interaction.handleMouseClick(mouseX, mouseY);
}


/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
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

/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
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

/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
 Consumption Data Class and Globals
 
 
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

class ConsumptionDevice
{
  String _id;
  String _descr;
  float[] _readings;
  
  ConsumptionDevice()
  {
    _id = "";
    _descr = "";
    _readings = null;
  }
}
 
class ConsumptionData
{
  private ConsumptionDevice[] _devices;
  private int _timeShift;
  private boolean _new;
  private int[] _sortedIndex;
  
  ConsumptionData(int num)
  {
    _new = false;
    _timeShift = 0;
    _devices = new ConsumptionDevice[num];
    
    for(int i = 0; i < num; i++)
      _devices[i] = new ConsumptionDevice();
  }
  
  void updateData(String[] lines)
  {
    setStale();
    
    for(int i = 0; i < lines.length; i++)
    {
      String[] a = splitTokens(lines[i], ",");         
      int offset = 2;
      int l2 = a.length - offset;
      int l1 = 0;
      int tshift = 0;
      int similar = 0;
                      
//      if(USE_LOCAL_CACHE)
//      {
//        // shift the data simulate changes
//        String last = a[a.length-1];
//        for(int j = a.length-1; j > offset; j--)
//          a[j] = a[j-1];
//        a[offset] = last;
//      }

      _devices[i]._id = a[0];
      _devices[i]._descr = a[1];
            
      if(_devices[i]._readings != null)
      {
        l1 = _devices[i]._readings.length;
        for(tshift = 0; tshift < l1; tshift++)
        {
          similar = 0;
          for(int j = 0; j < l1 - tshift; j++)
          {
            if(_devices[i]._readings[j] == float(a[j+offset+tshift]))
              similar++;
          }
          
          if(similar == l1 - tshift)
            break;
        }
        
        _timeShift = tshift;
      }
      else
      {
          _timeShift = l2;            
      }
        
      if(BE_VERBOSE)
      {
        print("Data update: ");
        print(_devices[i]._descr);
        print("(");
        print(_devices[i]._id);
        print(") Length=");
        print(l2);
        print(", Time Shift=");
        println(_timeShift);    
      }
      
      if(_devices[i]._readings == null || _devices[i]._readings.length != i)
        _devices[i]._readings = new float[l2];
        
      for(int j = 0; j < l2; j++)
        _devices[i]._readings[j] = float(a[j+offset]);
    }   

    //need to remove when real data
    //for(int i = 0; i< _devices[0]._readings.length; i++)
    //{
    //  _devices[0]._readings[i] = 0.0;
    //  for(int j = 1; j < _devices.length; j++)
    //    _devices[0]._readings[i] += _devices[j]._readings[i];
    //}   
    ///////
    
    _new = true;
  }

  boolean isNew()
  {
    return _new;
  }
  
  void setStale()
  {
    _new = false;
  }

  String getDeviceDescr(String id)
  {
    for(int i = 0; i < _devices.length; i++)
    {
      if(_devices[i]._id == id)
        return _devices[i]._descr;
    }    
    
    return "";
  }
  
  float[] getNewReadings(String id, boolean blocking)
  {
    float[] readings;

    while(blocking && !isNew())
      delay(200);
   
    for(int i = 0; i < _devices.length; i++)
    {
      if(_devices[i]._id.equals(id))
      {
        readings = new float[_timeShift];
        for(int j = 0; j < _timeShift; j++)
        {
          readings[j] = _devices[i]._readings[j];
        }
        return readings;
      }
    }

    return null;
  }
  
  int getDeviceCount()
  {
    return _devices.length;
  }
  
  int getReadingsCount()
  {
    return _devices[0]._readings.length;
  }

  ConsumptionDevice getDevice(int idx)
  {
    return _devices[idx];
  }

  float getReading(int device, int ridx)
  {
    return _devices[device]._readings[ridx];
  }
  
  void sortDeviceByReading(int ridx)
  {  
    _sortedIndex = new int[getDeviceCount()];

    for(int i = 0; i < _sortedIndex.length; i++)
      _sortedIndex[i] = i;
    
    for(int i = 1; i < _sortedIndex.length; i++)
    {
      for(int j = 1; j < _sortedIndex.length; j++)
      {
        if(getReading(_sortedIndex[i], ridx) > getReading(_sortedIndex[j], ridx))
        {
          int m = _sortedIndex[i];
          _sortedIndex[i] = _sortedIndex[j];
          _sortedIndex[j] = m;
        }
      }
    }
  }
  
  void sortDeviceByReadingASC(int ridx)
  {  
    _sortedIndex = new int[getDeviceCount()];

    for(int i = 0; i < _sortedIndex.length; i++)
      _sortedIndex[i] = i;
    
    for(int i = 1; i < _sortedIndex.length; i++)
    {
      for(int j = 1; j < _sortedIndex.length; j++)
      {
        if(getReading(_sortedIndex[i], ridx) < getReading(_sortedIndex[j], ridx))
        {
          int m = _sortedIndex[i];
          _sortedIndex[i] = _sortedIndex[j];
          _sortedIndex[j] = m;
        }
      }
    }
  }

  ConsumptionDevice getSortedDevice(int idx)
  {
    return _devices[_sortedIndex[idx]];
  }

  int getSortedDeviceID(int idx)
  {
    return _sortedIndex[idx];
  }
}


/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
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

/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
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

/***********************************************************************
 
 Leaves of Consumtion (EoC_Leaves)
 
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

/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
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

/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
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

/***********************************************************************
 
 Elements of Consumtion (EoC) -- Common Vis Framework
 
 Web Serice Inferface Class and Globals
 
 
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
 
class WebService extends Thread 
{
  private String _url;
  private String _fname;
  private boolean _available;
  private boolean _running;
  private boolean _useLocalCache;
  private int _updateInterval;
  private int _lastMin;

  // updateInterval read once evey n minutes. E.g. n = 60 is once/hr
  WebService(String url, int updateInterval, boolean useLocalCache)
  {
    _url = url;
    _updateInterval = updateInterval;
    _useLocalCache = useLocalCache;
    
//    String[] list = split(url, '/');
//    _fname ="data/" + list[list.length-1] + ".cache";
//    File file = new File(_fname);
//    if(!file.exists())
//      _fname = "";
  }
  
  void start()
  {
    _available = false;
    _running = true;
    _lastMin = -1;
    
    super.start();
  }
   
  void run()
  {
    while(_running)
    {
      String[] lines;
      int tmin = minute();
      int tsec = second();
      
      if((tmin % _updateInterval == 0 && tmin != _lastMin && tsec == 0) || _lastMin == -1)
      {
        _available = false;
        
//        if(USE_LOCAL_CACHE && _fname != "")
//        {
//          lines = loadStrings(_fname);
//          
//          if(cdata != null)
//          {            
//            for(int i = 0; i < lines.length; i++)
//            {
//            for(int j = 0; j < 30; j++)
//            {
//              print(cdata._devices[i]._readings[j]);
//              print(" ");
//            }
//            println();
//
//              lines[i] = cdata._devices[i]._id + "," + cdata._devices[i]._descr;
//              for(int j = 0; j < cdata._devices[i]._readings.length; j++)
//                lines[i] += "," + str(cdata._devices[i]._readings[j]);
//
//            for(int j = 0; j < 30; j++)
//            {
//              print(cdata._devices[i]._readings[j]);
//              print(" ");
//            }
//            println();
//
//            }
//          }
//        }
//        else
//        {
          lines = loadStrings(_url);
//        }
                
        if(cdata == null || cdata._devices.length != lines.length)        
          cdata = new ConsumptionData(lines.length);
        
        cdata.updateData(lines);
        _available = true;
        _lastMin = tmin;
      }
      delay(100);
    }
  }

  boolean isAvailable()
  {
    return _available;
  }
}


