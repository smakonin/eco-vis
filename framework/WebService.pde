/***********************************************************************
 
 eco-vis -- Common Vis Framework
 
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

