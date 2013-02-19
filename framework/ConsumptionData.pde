/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
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


