/**
* Copyright (c) 2009 Paul Coyle
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/
package com.paulcoyle.mazegenerator {
  /**
  * Defines a room in a maze.  This is basically a value object with some string
  * serialization methods.
  *
  * @author Paul Coyle &lt;paul@paulcoyle.com&gt;
  */
  final public class Room {
    public var x:uint;
    public var y:uint;
    
    // Defines whether or not there are walls on the right and bottom.
    public var hWall:Boolean = true;
    public var vWall:Boolean = true;
    
    public var visited:Boolean = false;
    public var previous:Room;
    
    // These are flags just used for display
    public var start:Boolean;
    public var end:Boolean;
    
    /**
    * Returns a string representation of the object.
    */
    final public function toString():String {
      return "[Room x="+x+" y="+y+"]";
    }
    
    /**
    * Returns a graphical string representation used when showing an ASCII
    * version of a maze.
    */
    final public function toMazeString():String {
      var out:String;
      if ((start) || (end)) out = (start) ? 'S' : (end) ? 'E' : '';
      else out = (vWall) ? '_' : ' ';
      
      out += (hWall) ? '|' : '.';
      
      return out;
    }
  }
}