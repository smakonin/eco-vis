/***********************************************************************

 Spirals of Consumtion (canvas_Spirals)
 
 Spiral Visual Class and Globals
 
 
/***********************************************************************
 * Copyright (C) 2011, Maryam H Kashani. All rights reserved.
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


final int   SUB_SAMPLES = 12;
final int   STROKE_WEIGHT = 2;
final float CENTER_RADIUS = 0;
final float MAX_RADIUS = min(height, width) / 2;

float time = 0; 

class SpiralVisual 
{
  private int[] order = null;
  private boolean[] enabled = null;
  
  private float dataTimeUnit = 10; // in seconds
  private int subDataIncrements = 12;
  private float readingPeriod = 1;
  private float rotation_inc; 
  private float rScale = 0.01;
  private float userScale = 10;
  private boolean autoScale = true;
  
  public SpiralVisual(float _dataTimeUnit/*, int _deviceCount, int _cycleLength*/) 
  {
    dataTimeUnit = _dataTimeUnit;
    updateRotationInc();
      
    enabled = new boolean[cdata.getDeviceCount()];
    enableAA();
  }
  
  public void enableAA()
  {
    for (int i = 0; i < cdata.getDeviceCount(); i++)
      enabled[i] = true;      

    enabled[0] = false;
  }
  
  public void enableAH(int a)
  {
    for (int i = 0; i < cdata.getDeviceCount(); i++)
      enabled[i] = false;

    enabled[0] = true;
    enabled[a] = true;
  }

  public void updateRotationInc() 
  {
    rotation_inc = 2.0 * PI / (float)(cdata.getReadingsCount() * subDataIncrements);
  }
  
  public void setScale(float val) {
    userScale = max(val, 0);
  }

  public float getScale() {
    return rScale;
  }

  public void setAutoScale(boolean val) {
    autoScale = val;
  }

  public boolean getAutoScale() {
    return autoScale;
  }

  public void setSubsample(int val) {
    subDataIncrements = val;
    updateRotationInc();
  }
  
  public int getSubsample() {
    return subDataIncrements;
  }
  
  public boolean isEnabled(int index) 
  {
    return enabled[order[index]];
  }
  
    // return the bezier curve value where start and end points are given (p_i and p_f), and x is from 0 to 1 representing where in the curve we are.  
  private float bezierCurve(float p_i, float p_f, float x) {
    float c_i = p_i;
    float c_f = p_f;
    
    return pow(1-x,3)*p_i + 3*pow(1-x,2)*(x)*c_i + 3*(1-x)*pow(x,2)*c_f + pow(x,3)*p_f;
  }
   
  // find the device orders by sorting them based on their total consumption
  int[] deviceOrder() 
  {
    order = new int[cdata.getDeviceCount()];
  
    // calculate the total sums for each device
    float[] totals = new float[cdata.getDeviceCount()];
    for (int i = 0; i < cdata.getDeviceCount(); i++) {
      totals[i] = 0;
      for (int j = 0; j < cdata.getReadingsCount(); j++) {
        totals[i] += cdata.getReading(i, j);
      }    
    }
    
    // find the most-consuming devices, and put them at the end of the drawing stack
    int index = order.length-1;
    for (int i = 0; i < cdata.getDeviceCount(); i++) {
      int max_ind = 0;
      for (int j = 0; j < cdata.getDeviceCount(); j++) {
        if (totals[j] > totals[max_ind])
          max_ind = j;
      }    
      order[index] = max_ind;
      totals[max_ind] = 0;
      index--;
    }
    
    return order;
  } 
  
  // calculate the length of a new line segment, based on its consumption value (L) and where in the circle it starts 
  private float lineSegmentLength(float R0, float L) {
    return (-R0 + sqrt(R0*R0 + 2*L))/2.0;
  }
    
  // draw the line given a starting position (R0) and the device consumption (L)
  private float drawLine(float R0, float v, color col) {
    if (v == 0)
      return R0;  

    float L = lineSegmentLength(R0, v);
    stroke(col);
    line(0, -R0*rScale, 0, -(R0+L)*rScale);

    return R0+L;
  }
  
  private float calculateScale() {
    // calculate the longest line segment in the data
    // note that this calculation is not 100% accurate. the line lengths change depending on the scale, so this is just an estimation.
    float max_length = 0, new_length;
    for(int j = 0; j < cdata.getReadingsCount(); j++)
    {
      new_length = 0;
      for(int i = 0; i < cdata.getDeviceCount(); i++)
      {
        if (!isEnabled(i))
          continue;
        new_length += lineSegmentLength(new_length, cdata.getReading(order[i], j));
      }
      max_length = max(new_length, max_length);
    }
    
    // calculate a scale so that the maximum line length won't exceed the screen size
    return MAX_RADIUS/max_length;
  }
  
  // find the device orders by sorting them based on their total consumption
  boolean updateScale() {

    float newScale = rScale;
    
    // if auto-scale is on, calculate the new scale; otherwise, use the user-specified scale
    if (autoScale)
      newScale = calculateScale();
    else
      newScale = userScale;
    

    //makes it look live
    //if (floor((int)(time/1)) % 2 == 0)
    //  newScale = newScale * 0.9;
    
    // if scale changed, redraw everything
    if (newScale != rScale) {
      // don't change the scale to new value suddenly; change it gradually
      rScale = 0.05*newScale + 0.95*rScale;
      return true;
    }
    
    return false;
  }  

  // draw everything up to time t
  public void redraw(float t) 
  {
//    background(0);

    float t0 = max(t - dataTimeUnit * cdata.getReadingsCount(), 0);
    float transparency;
    
    for (float x=t0; x <= t; x += 1.0/(subDataIncrements * 2)) 
    {
      transparency = (cdata.getReadingsCount() * dataTimeUnit - (t - x)) / ( float)(cdata.getReadingsCount() * dataTimeUnit);
      drawALine(x, false, transparency);
    }
  } 
    
   
  public void draw() {
    // get time
    time = millis()/1000.0;

    // update the device order
    order = deviceOrder();

    // calculate the scale
    updateScale();

    redraw(time);
  }
    
    
  // draw the portion of the circle for time 't'
  private void drawALine(float t, boolean radar, float transparency) 
  {
    
    pushMatrix();

    // create a delay in 't' since we are waiting for a new data before we fully draw the latest time period
    float cur_t = (t/dataTimeUnit);
    cur_t = (int)(cur_t*subDataIncrements)/( float)subDataIncrements;
    float delay_t = (( cur_t - 0.5) + cdata.getReadingsCount()) % cdata.getReadingsCount();
    
    // calculate the index
    int index = (int) delay_t; //(int)(( delay_t / dataTimeUnit)+cycleLength) % cycleLength;
    int prev_index = ((index - 1 + cdata.getReadingsCount()) % cdata.getReadingsCount());

    
    // rotate in a circle
    translate(width / 2, height / 2);
    rotate(cur_t * subDataIncrements * rotation_inc);
    strokeWeight(STROKE_WEIGHT);

    // draw all device lines
    float val_i, val_f, newLength;
    float R = CENTER_RADIUS/rScale;
    color col;
    
    float p = max((delay_t/readingPeriod) % 1.0, 0);
    for (int i = 0; i < cdata.getDeviceCount(); i++) 
    {
      if(!isEnabled(i))
        continue;
        
      if(order[i] == 0)
      {
        val_i = modTotal(prev_index);
        val_f = modTotal(index);
      }
      else
      {
        val_i = cdata.getReading(order[i], prev_index);
        val_f = cdata.getReading(order[i], index);
      }
      

      val_i = val_i / 100 + 1;
      val_f = val_f / 100 + 1;
      newLength = bezierCurve((val_i), (val_f), p);
      
      col = canvas.getPalette().getColour(order[i]); 
      col = color(red(col), green(col), blue(col), (int)(transparency * 255.0));
      R = drawLine(R, newLength, col);
    }
    
    popMatrix();

  } 
  
  float modTotal(int idx)
  {
    float tl = 0;
    
    for (int i = 1; i < cdata.getDeviceCount(); i++) 
    {
      if(!isEnabled(i))
        continue; 
 
      tl = abs(tl - cdata.getReading(order[i], idx));
    }

    return tl;
  }
}


