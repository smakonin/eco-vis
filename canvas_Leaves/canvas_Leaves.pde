/***********************************************************************
 
 Leaves of Consumtion (canvas_Leaves)
 
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
final static String PROJECT_FILENAME = "canvas_Leaves";

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


